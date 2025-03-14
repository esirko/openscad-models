e = 0.01;

l = 4 * 25.4;
h = 1.5 * 25.4;
t = 5;

w = 1.5 * 25.4;
r = 7;


difference() {
union() {
    translate([-t - (l - w), -t, 0]) cube([l + (l - w), t, h]);
    translate([-t - (l - w), -t, -t]) cube([l + (l - w), l, t]);
    translate([w, w, 0]) cube([l-w, t, h]);
    translate([w, w, 0]) cube([t, l-w, h]);
    
    translate([-t - (l - w), w, 0]) cube([l-w, t, h]);
    translate([-t, w, 0]) cube([t, l-w, h]);

}

translate([0, 0, -t-e]) linear_extrude(h + 10) polygon([[0, l + w], [l + w, 0], [l + w, l + w]]);
translate([w, 0, -t-e]) linear_extrude(h + 10) polygon([[0, l + w], [-(l + w), 0], [-(l + w), l + w]]);
translate([10, -t-e, 10]) cube([w - 20, 2 * t, h - 20]);

}