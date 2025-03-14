// The zero-plane is the top of the studs, the bottom of the subfloor

//translate([0, 0, 0])
//cube([37, 39.5, 0.75]);
e = 0.1;

// wood frame
translate([0, 0, 0]) cube([8, 39.5, 0.75]);
translate([29, 0, 0]) cube([8, 39.5, 0.75]);

translate([8+e, 0, 0]) cube([37-8-8-2*e, 8, 0.75]);
translate([8+e, 39.5-8, 0]) cube([37-8-8-2*e, 8, 0.75]);

// osb
//translate([8+e, 8+e, 0]) cube([37-8-8-2*e, 39.5-8-8-2*e, 0.75]);
// paper-thin layer to simulate that the OSB shouldn't be relied on for strength
translate([0, 0, 0.65]) cube([37, 39.5, 0.1]);

// shelving standards
translate([12, 5, -0.5]) cube([0.75, 30, 0.5]);
translate([25, 5, -0.5]) cube([0.75, 30, 0.5]);

// hinges
color([1, 0, 0]) translate([4.5, 0, 0]) rotate([90, 0, 90]) polygon([[0,0], [4.25, 0], [3, -1.75], [0, -2]]);
translate([14, 0, 0]) rotate([90, 0, 90]) polygon([[0,0], [4.25, 0], [3, -1.75], [0, -2]]);
translate([23, 0, 0]) rotate([90, 0, 90]) polygon([[0,0], [4.25, 0], [3, -1.75], [0, -2]]);
translate([32.5, 0, 0]) rotate([90, 0, 90]) polygon([[0,0], [4.25, 0], [3, -1.75], [0, -2]]);

/*
// pad
translate([1.5, 4.5, -2]) cube([34, 34, 1.25]);

// gas struts
translate([0.5, 29, -1.5])
rotate([85, 0, 0]) cylinder(18, 0.5, 0.5, $fn=36);

translate([36.5, 29, -1.5])
rotate([85, 0, 0]) cylinder(18, 0.5, 0.5, $fn=36);

*/
