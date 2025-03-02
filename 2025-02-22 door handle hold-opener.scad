t1 = 10;
t2 = 10;
t3 = 10;
t4 = 15;
t5 = 10;

h = 66 + t1 + t2;
l1 = 67 + t5 + t3;
l2 = l1;

r = 8;
x = 23;
y = 19;
z = 73;
cylinder_res = 36;

// Bracket around square mount
cube([t2, l2, t4]);
cube([h, t3, t4]);
translate([h-t1, 0, 0])
    cube([t1, l1, t4]);
translate([0, l2 - t5, 0])
    cube([h, t5, t4]);

// extrusion to cylinder
linear_extrude(height = t4)
    polygon(points=[[0,0], [-y, -(x-r)], [-y, -(x+r)], [h,0]]);

// cylilnder
translate([-y, -x, 0])
    cylinder(z, r, r, $fn=cylinder_res);