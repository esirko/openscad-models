include <BOSL2/std.scad>

x0 = 110;
x1 = 56;
x2 = 46;
x2a = 73-x2;
x3 = 18;
x4 = 120;
x5 = 57;

z0 = 30;
z1 = 10;
z2 = 30;
z2a = 30;
z3 = 10;
z4 = 30;
z5 = 0;


e = 0.1;
t = 1;

yt = 2;
yp = 5;
zp = 10;

module segment(x, z) {
    if (z > 0) {
        cuboid([x, yt, z], anchor=LEFT+TOP+BACK);
    }
    difference() {
        cuboid([x, yp, zp], anchor=LEFT+BOTTOM+BACK, chamfer=1, edges=[TOP+FRONT, BOTTOM+FRONT]);
        up(t) back(e) left(e) cuboid([x+2*e, yp-t, zp-2*t], anchor=LEFT+BOTTOM+BACK);
    }
}

left(10) {
    segment(x0, z0);
    right(x0) segment(x1, z1);
    right(x0+x1) segment(x2, z2);
}

right(x0+x1+x2) segment(x2a, z2a);
right(x0+x1+x2+x2a) segment(x3, z3);
right(x0+x1+x2+x2a+x3) segment(x4, z4);
right(x0+x1+x2+x2a+x3+x4) segment(x5, z5);