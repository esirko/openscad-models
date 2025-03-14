e = 0.01;

l = 4 * 25.4;
h = 1.5 * 25.4;
t = 5;

w = 1.5 * 25.4;
r = 7;


difference() {
union() {
    translate([-t, -t, 0]) cube([l, t, h]);
    translate([-t, -t, 0]) cube([t, l, h]);
    translate([-t, -t, -t]) cube([l, l, t]);
    translate([w, w, 0]) cube([l-w, t, h]);
    translate([w, w, 0]) cube([t, l-w, h]);
}

translate([0, 0, -t-e]) linear_extrude(h + 10) polygon([[0, l + w], [l + w, 0], [l + w, l + w]]);
translate([10, -t-e, 10]) cube([w - 20, 2 * t, h - 20]);
translate([-t-e, 10, 10]) cube([2 * t, w - 20, h - 20]);

/*
translate([45, e, h/2 + 7]) rotate([90, 0, 0]) cylinder(2 * t, r, r);
translate([55, 500 + e, h/2 - 8]) rotate([90, 0, 0]) cylinder(2 * t + 1000, r, r);
translate([65, 500 + e, h/2 + 7]) rotate([90, 0, 0]) cylinder(2 * t + 1000, r, r);
translate([75, 500 + e, h/2 - 8]) rotate([90, 0, 0]) cylinder(2 * t + 1000, r, r);
translate([85, 500 + e, h/2 + 7]) rotate([90, 0, 0]) cylinder(2 * t + 1000, r, r);

translate([-t-e, 45, h/2 + 7]) rotate([0, 90, 0]) cylinder(2 * t, r, r);
translate([-t-e, 55, h/2 - 8]) rotate([0, 90, 0]) cylinder(2 * t + 1000, r, r);
translate([-t-e, 65, h/2 + 7]) rotate([0, 90, 0]) cylinder(2 * t + 1000, r, r);
translate([-t-e, 75, h/2 - 8]) rotate([0, 90, 0]) cylinder(2 * t + 1000, r, r);
translate([-t-e, 85, h/2 + 7]) rotate([0, 90, 0]) cylinder(2 * t + 1000, r, r);

translate([11, 80, -t-e]) cylinder(2 * t, r, r);
translate([26, 70, -t-e]) cylinder(2 * t, r, r);
translate([11, 60, -t-e]) cylinder(2 * t, r, r);
translate([26, 50, -t-e]) cylinder(2 * t, r, r);
translate([11, 40, -t-e]) cylinder(2 * t, r, r);
translate([26, 30, -t-e]) cylinder(2 * t, r, r);
translate([11, 20, -t-e]) cylinder(2 * t, r, r);
translate([26, 10, -t-e]) cylinder(2 * t, r, r);

translate([45, 26, -t-e]) cylinder(2 * t, r, r);
translate([55, 11, -t-e]) cylinder(2 * t, r, r);
translate([65, 26, -t-e]) cylinder(2 * t, r, r);
translate([75, 11, -t-e]) cylinder(2 * t, r, r);
translate([85, 26, -t-e]) cylinder(2 * t, r, r);
*/
}

