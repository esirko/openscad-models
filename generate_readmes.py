#!/usr/bin/env python3
"""Generate / update per-directory README.md files for OpenSCAD models.

For each model subdirectory this script:
  * groups files into "models" (scad + stl pairs, plus variants / supplemental files),
  * renders an STL thumbnail (.png) via the OpenSCAD CLI when available,
  * maintains a `## <model>` section in that directory's README.md,
  * is NON-DESTRUCTIVE: it only rewrites the auto-managed block between
    <!-- AUTOGEN:START ... --> and <!-- AUTOGEN:END ... --> markers. Any prose
    you write above that block (or anywhere else) is preserved.

Run `python generate_readmes.py --check` to only run the dependency preflight.
"""

from __future__ import annotations

import argparse
import os
import platform
import shutil
import subprocess
import sys
import tempfile
from dataclasses import dataclass, field
from pathlib import Path

# --------------------------------------------------------------------------- #
# Configuration
# --------------------------------------------------------------------------- #

REPO_ROOT = Path(__file__).resolve().parent

# Directories to skip entirely while walking.
SKIP_DIRS = {".git", "renders", "backups", "__pycache__", ".venv"}

MODEL_EXTS = {".scad", ".stl", ".3mf"}
# Supplemental images discovered in model directories (non-recursive).
# Intentionally excludes .png so top-level PNGs can be managed manually in README.
IMAGE_EXTS = {".jpg", ".jpeg"}

RENDER_DIRNAME = "renders"
IMG_SIZE = (600, 600)

# Markers that delimit the script-owned block inside each model section.
AUTOGEN_START = "<!-- AUTOGEN:START {key} -->"
AUTOGEN_END = "<!-- AUTOGEN:END {key} -->"


# --------------------------------------------------------------------------- #
# Dependency preflight
# --------------------------------------------------------------------------- #


@dataclass
class Deps:
    openscad: str | None = None


def find_openscad() -> str | None:
    """Return a path to the OpenSCAD executable, or None if not found."""
    found = shutil.which("openscad")
    if found:
        return found
    candidates = [
        r"C:\Program Files\OpenSCAD\openscad.exe",
        r"C:\Program Files\OpenSCAD (Nightly)\openscad.exe",
        "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD",
        "/usr/bin/openscad",
        "/usr/local/bin/openscad",
    ]
    for c in candidates:
        if Path(c).exists():
            return c
    return None


def preflight() -> Deps:
    """Check dependencies, print a concise summary with install hints."""
    deps = Deps(openscad=find_openscad())
    is_win = platform.system() == "Windows"

    print("Dependency check")
    print("================")

    # OpenSCAD ---------------------------------------------------------------
    if deps.openscad:
        print(f"  [ok]   OpenSCAD CLI : {deps.openscad}")
    else:
        print("  [warn] OpenSCAD CLI : not found -> STL thumbnails will be skipped")
        print("         Install:")
        if is_win:
            print("           winget install OpenSCAD.OpenSCAD")
            print("           (or download: https://openscad.org/downloads.html)")
        else:
            print("           brew install --cask openscad")
            print("           (or download: https://openscad.org/downloads.html)")

    print()
    return deps


# --------------------------------------------------------------------------- #
# Model discovery
# --------------------------------------------------------------------------- #


def model_key(stem: str) -> str:
    """Return the grouping key for a file stem.

    Variant files use a " - suffix", e.g. "flooring edges - 1 - back outside".
    The date prefix ("2025-03-30 ") uses hyphens without surrounding spaces, so
    splitting on " - " (space-hyphen-space) safely isolates the base model name.
    """
    return stem.split(" - ", 1)[0].strip()


@dataclass
class Model:
    key: str
    scad: Path | None = None
    stl: Path | None = None
    variant_stls: list[Path] = field(default_factory=list)
    variant_scads: list[Path] = field(default_factory=list)
    threemf: list[Path] = field(default_factory=list)
    images: list[Path] = field(default_factory=list)

    def primary_stl(self) -> Path | None:
        if self.stl:
            return self.stl
        if self.variant_stls:
            return sorted(self.variant_stls)[0]
        return None


def discover_models(directory: Path) -> dict[str, Model]:
    """Group files in *directory* (non-recursive) into models keyed by base name."""
    models: dict[str, Model] = {}

    for entry in sorted(directory.iterdir()):
        if not entry.is_file():
            continue
        ext = entry.suffix.lower()
        if ext not in MODEL_EXTS and ext not in IMAGE_EXTS:
            continue

        key = model_key(entry.stem)
        model = models.setdefault(key, Model(key=key))
        is_variant = entry.stem.strip() != key

        if ext == ".scad":
            if is_variant:
                model.variant_scads.append(entry)
            else:
                model.scad = entry
        elif ext == ".stl":
            if is_variant:
                model.variant_stls.append(entry)
            else:
                model.stl = entry
        elif ext == ".3mf":
            model.threemf.append(entry)
        elif ext in IMAGE_EXTS:
            model.images.append(entry)

    return models


# --------------------------------------------------------------------------- #
# Rendering
# --------------------------------------------------------------------------- #


def render_thumbnail(stl: Path, out_png: Path, deps: Deps, warnings: list[str]) -> Path | None:
    """Render *stl* to a PNG thumbnail via OpenSCAD.

    Returns the image path actually written (or the existing one when up to date).
    Re-renders only when the output is missing or the STL is newer.
    """
    if not deps.openscad:
        return out_png if out_png.exists() else None

    # Reuse the existing render if it's current.
    if out_png.exists() and out_png.stat().st_mtime >= stl.stat().st_mtime:
        return out_png

    out_png.parent.mkdir(parents=True, exist_ok=True)

    # OpenSCAD renders .scad files; wrap the STL in a tiny import scad.
    scad_src = 'import("{}");\n'.format(str(stl.resolve()).replace("\\", "/"))
    tmp = None
    try:
        with tempfile.NamedTemporaryFile("w", suffix=".scad", delete=False, encoding="utf-8") as fh:
            fh.write(scad_src)
            tmp = Path(fh.name)

        cmd = [
            deps.openscad,
            "--autocenter",
            "--viewall",
            f"--imgsize={IMG_SIZE[0]},{IMG_SIZE[1]}",
            "--colorscheme=Tomorrow",
            "-o",
            str(out_png),
            str(tmp),
        ]
        result = subprocess.run(cmd, capture_output=True, text=True)
        if result.returncode != 0 or not out_png.exists():
            warnings.append(
                f"render failed for {stl.name}: {result.stderr.strip().splitlines()[-1] if result.stderr.strip() else 'unknown error'}"
            )
            return None
    finally:
        if tmp is not None:
            tmp.unlink(missing_ok=True)

    return out_png


# --------------------------------------------------------------------------- #
# README section building
# --------------------------------------------------------------------------- #


def md_link(directory: Path, target: Path) -> str:
    """Markdown link with a POSIX, URL-encoded path relative to *directory*."""
    from urllib.parse import quote

    rel = target.relative_to(directory).as_posix()
    return f"[{target.name}]({quote(rel)})"


def md_image(directory: Path, image: Path) -> str:
    from urllib.parse import quote

    rel = image.relative_to(directory).as_posix()
    return f"![{image.stem}]({quote(rel)})"


def build_managed_block(directory: Path, model: Model, render: Path | None) -> str:
    """Return the inner content for the auto-managed block (no markers)."""
    lines: list[str] = []

    if render is not None:
        lines.append(md_image(directory, render))
        lines.append("")

    files: list[str] = []
    if model.scad:
        files.append(f"- SCAD: {md_link(directory, model.scad)}")
    if model.stl:
        files.append(f"- STL: {md_link(directory, model.stl)}")
    for tmf in sorted(model.threemf):
        files.append(f"- 3MF: {md_link(directory, tmf)}")

    if model.variant_scads:
        links = ", ".join(md_link(directory, p) for p in sorted(model.variant_scads))
        files.append(f"- Variant SCAD: {links}")
    if model.variant_stls:
        links = ", ".join(md_link(directory, p) for p in sorted(model.variant_stls))
        files.append(f"- Variant STL: {links}")

    # Supplemental images = user-supplied images, excluding the auto render.
    supplemental = [
        img for img in sorted(model.images)
        if render is None or img.resolve() != render.resolve()
    ]
    if supplemental:
        links = ", ".join(md_link(directory, p) for p in supplemental)
        files.append(f"- Images: {links}")

    if files:
        lines.append("**Files:**")
        lines.append("")
        lines.extend(files)
    else:
        lines.append("_No model files found._")

    return "\n".join(lines)


# --------------------------------------------------------------------------- #
# Non-destructive README maintenance
# --------------------------------------------------------------------------- #


def split_sections(text: str) -> tuple[str, list[tuple[str, str]]]:
    """Split README text into (preamble, [(heading_title, body), ...]).

    A section starts at a line beginning with "## ". *body* includes the heading
    line and everything until the next "## " heading.
    """
    lines = text.splitlines(keepends=True)
    preamble: list[str] = []
    sections: list[tuple[str, list[str]]] = []
    current: list[str] | None = None
    current_title: str | None = None

    for line in lines:
        if line.startswith("## "):
            if current is not None:
                sections.append((current_title or "", current))
            current_title = line[3:].strip()
            current = [line]
        elif current is None:
            preamble.append(line)
        else:
            current.append(line)

    if current is not None:
        sections.append((current_title or "", current))

    return "".join(preamble), [(t, "".join(b)) for t, b in sections]


def replace_managed_block(section_body: str, key: str, new_inner: str) -> str:
    """Replace content between AUTOGEN markers; insert markers if absent.

    Everything outside the markers (including user prose) is preserved.
    """
    start = AUTOGEN_START.format(key=key)
    end = AUTOGEN_END.format(key=key)
    block = f"{start}\n{new_inner}\n{end}"

    si = section_body.find(start)
    ei = section_body.find(end)

    if si != -1 and ei != -1 and ei > si:
        before = section_body[:si]
        after = section_body[ei + len(end):]
        return f"{before}{block}{after}"

    # No markers yet: append the block at the end of the section, keeping any
    # existing prose (which the user may have started writing) intact.
    body = section_body.rstrip("\n")
    return f"{body}\n\n{block}\n"


def build_section(title: str, key: str, inner: str) -> str:
    start = AUTOGEN_START.format(key=key)
    end = AUTOGEN_END.format(key=key)
    return f"## {title}\n\n{start}\n{inner}\n{end}\n"


def update_readme(
    directory: Path, models: dict[str, Model], deps: Deps, warnings: list[str]
) -> None:
    readme = directory / "README.md"
    existing_text = readme.read_text(encoding="utf-8") if readme.exists() else ""

    if existing_text:
        preamble, sections = split_sections(existing_text)
    else:
        preamble, sections = f"# {directory.name}\n", []

    section_titles = {title for title, _ in sections}
    disk_keys = set(models.keys())

    # Warn about README sections that no longer exist on disk.
    for title in section_titles:
        if title not in disk_keys and not title.startswith(("actually", "failures", "funny", "obscure", "office", "useful")):
            # Only warn for headings that look like model headings (have a key match shape).
            if title in section_titles and title not in disk_keys:
                warnings.append(f"{directory.name}/README.md: section '## {title}' has no matching files on disk")

    # Build/refresh each existing section in place; collect new ones to append.
    rebuilt: list[str] = []
    handled_keys: set[str] = set()

    for title, body in sections:
        if title in models:
            model = models[title]
            render = _render_for(directory, model, deps, warnings)
            inner = build_managed_block(directory, model, render)
            rebuilt.append(replace_managed_block(body, title, inner))
            handled_keys.add(title)
        else:
            rebuilt.append(body)  # untouched (could be a non-model section or orphan)

    # Append new models (not already present), in sorted order.
    new_keys = [k for k in sorted(disk_keys) if k not in handled_keys]
    for key in new_keys:
        model = models[key]
        render = _render_for(directory, model, deps, warnings)
        inner = build_managed_block(directory, model, render)
        rebuilt.append(build_section(key, key, inner))

    # Assemble final document.
    parts = [preamble.rstrip("\n"), ""]
    for sec in rebuilt:
        parts.append(sec.rstrip("\n"))
        parts.append("")
    final = "\n".join(parts).rstrip("\n") + "\n"

    if final != existing_text:
        readme.write_text(final, encoding="utf-8")
        action = "updated" if existing_text else "created"
        print(f"  {action}: {readme.relative_to(REPO_ROOT)}")
    else:
        print(f"  unchanged: {readme.relative_to(REPO_ROOT)}")


def _render_for(
    directory: Path, model: Model, deps: Deps, warnings: list[str]
) -> Path | None:
    stl = model.primary_stl()
    if stl is None:
        return None
    out_png = directory / RENDER_DIRNAME / f"{model.key}.png"
    return render_thumbnail(stl, out_png, deps, warnings)


# --------------------------------------------------------------------------- #
# File-pairing warnings
# --------------------------------------------------------------------------- #


def collect_pairing_warnings(directory: Path, models: dict[str, Model], warnings: list[str]) -> None:
    for key, model in sorted(models.items()):
        has_scad = model.scad is not None or bool(model.variant_scads)
        has_stl = model.stl is not None or bool(model.variant_stls)
        if has_scad and not has_stl:
            warnings.append(f"{directory.name}/: '{key}' has SCAD but no STL")
        elif has_stl and not has_scad:
            warnings.append(f"{directory.name}/: '{key}' has STL but no SCAD")


# --------------------------------------------------------------------------- #
# Main
# --------------------------------------------------------------------------- #


def iter_model_dirs() -> list[Path]:
    dirs = []
    for entry in sorted(REPO_ROOT.iterdir()):
        if not entry.is_dir():
            continue
        if entry.name in SKIP_DIRS or entry.name.startswith("."):
            continue
        # A model directory is any subdir that contains scad/stl/3mf files.
        if any(p.suffix.lower() in MODEL_EXTS for p in entry.iterdir() if p.is_file()):
            dirs.append(entry)
    return dirs


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--check",
        action="store_true",
        help="Run the dependency preflight only, then exit.",
    )
    args = parser.parse_args()

    deps = preflight()

    if args.check:
        return 0

    warnings: list[str] = []
    model_dirs = iter_model_dirs()
    if not model_dirs:
        print("No model directories found.")
        return 0

    for directory in model_dirs:
        print(f"\n{directory.name}/")
        models = discover_models(directory)
        collect_pairing_warnings(directory, models, warnings)
        update_readme(directory, models, deps, warnings)

    print("\nDone.")
    if warnings:
        print(f"\nWarnings ({len(warnings)}):")
        for w in warnings:
            print(f"  - {w}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
