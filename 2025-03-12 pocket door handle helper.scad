e = 0.01;


difference() {
    union() {
        translate([30, 10, 0]) cylinder(3, 25, 25);
        cube([60, 20, 3]);
        translate([20, -20, 0]) cube([20, 60, 3]);
    }
    translate([7.5, 10, -e]) cylinder(5, 2, 2, $fn=36);
    translate([52.5, 10, -e]) cylinder(5, 2, 2, $fn=36);
    translate([7.5, 10, 2 + e]) cylinder(1, 2, 4, $fn=36);
    translate([52.5, 10, 2 + e]) cylinder(1, 2, 4, $fn=36);
    translate([30, 10, -e]) cylinder(5, 15, 15);
}

translate([25, -17.5, 14]) cube([10, 55, 6]);

x = 14;
translate([30, 0 - x, 0]) rotate([90, 0, 0]) linear_extrude(6) polygon([[-10, 3-e], [-5, 20], [5, 20], [10, 3-e]]);
translate([30, 26 + x, 0]) rotate([90, 0, 0]) linear_extrude(6) polygon([[-10, 3-e], [-5, 20], [5, 20], [10, 3-e]]);