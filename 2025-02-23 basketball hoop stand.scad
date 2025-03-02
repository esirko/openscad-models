e = 0.01;

x1 = 20;
x2 = 65;
x3 = 60;
x4 = 31;
x5 = 10;

y1 = 130;
y2 = 121;

t3 = 2;

z1 = 7 + t3;
z2 = 15 + t3;

t1 = 1;
t2 = 1;
r = y1 / 2;

h1 = 20;


// cut out holes for prototyping
difference() {

// The main object
union() {
cube([x3 + x5/2 + t1 + h1, y1, t3]);

//translate([x2, y1/2, 0]) cylinder(t3, r, r);

x5a = (x5 + 2 * t1)/2;
translate([x3 - x5a, y1/2 - x5a, 0])
difference() {
   cube([2 * x5a, 2 * x5a, z1]);
   translate([t1, t1, 0]) cube([x5, x5, z1+e]);
}

translate([x1 - (x4/2 + t2), y1/2 - y2/2 - t2, 0])
difference() {
    cube([x4 + 2 * t2, y2 + 2 * t2, z2]);
    translate([t2, t2, 0]) cube([x4, y2, z2 + e]);
}
}

// The holes
/*
translate([x1 - x4/2, (y1 - y2)/2, -e])
    cube([x4, y2, t3 + 2*e]);

translate([x1 + x4/2 + t2 + 2, 2, -e])
    cube([x3 - x5/2 - t1 - 2 - x1 - x4/2 - t2 - 2, y1 - 4, t3 + 2 * e]);

translate([90, 40, -e])
cylinder(t3 + 2 * e, 20, 20);

translate([90, 90, -e])
cylinder(t3 + 2 * e, 20, 20);

translate([105, 65, -e])
cylinder(t3 + 2 * e, 20, 20);
*/
}