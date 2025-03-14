e = 0.01;


difference () {
union() {
    
rotate([270, 0, 0]) cylinder(100, 5, 5);
rotate([0, 90, 0]) cylinder(100, 5, 5);
sphere(5);

translate([0, 0, 0.75*25.4])
union() {
rotate([270, 0, 0]) cylinder(100, 5, 5);
rotate([0, 90, 0]) cylinder(100, 5, 5);
sphere(5);
}

cylinder(0.75 * 25.4, 5, 5);

translate([0, 0, -5])
cube([100, 100, 5]);
    translate([0, 0, 0.75*25.4])
cube([100, 100, 5]);

translate([90, -5, 0])
cube([10, 10, 0.75*25.4]);

translate([-5, 90, 0])
cube([10, 10, 0.75*25.4]);

}


translate([0, 0, e])
cube([200, 200, 0.75*25.4 - 2 * e]);

translate([100, 0, -5-e])
rotate([0, 0, 45])
cube([200, 200, 200]);

translate([0, 0, -100])
linear_extrude(200)
polygon([[10, 10], [10, 80], [80, 10]]);
}