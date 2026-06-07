include <BOSL2/std.scad>

// Webcam wedge to angle it a little differently

difference() {
    cuboid([40, 50, 15], anchor=BOTTOM);
    up(1) fwd(4.5) zrot(6) cuboid([70, 36, 15], anchor=BOTTOM);
    up(10) cuboid([70, 70, 70], anchor=BACK+BOTTOM);
}
