include <BOSL2/std.scad>

r1 = 4.5;
r2 = 8;
r3 = 12;
r4 = 18;
dz = 4;
ddz = 2;
y1 = 35;
y2 = 25;
y3 = 15;
z3 = 4;
z2 = 5;
rc = 10;

e = 0.01;
e2 = 2*e;

difference() {
    union() {
        cyl(r=r3, h=dz, anchor=TOP);
        cuboid([y1, 2*r3, dz], anchor=LEFT+TOP);
        color("red") down(dz) right(y1 - y2) cuboid([y2, 2*r4, z2+dz], anchor=LEFT+BOTTOM);
    }
    
    up(e) cyl(r=r1, h=dz+e2, anchor=TOP);
    cuboid([y1+e, 2*r1, 21], anchor=LEFT);
    right(y1-y3) up(ddz) cuboid([y3+e, 2*r3+e2, dz+ddz+e], anchor=LEFT+TOP);
    cuboid([30, 2*r3, ddz], anchor=LEFT+BOTTOM);
}

difference() {
    union() {
        intersection() {
            right(y1-2) up(ddz) cyl(r=rc, h=z2+5, anchor=BOTTOM);
            right(y1-10) up(ddz) cyl(r=rc, h=z2+5, anchor=BOTTOM);
        }
        right(y1-10) up(ddz+z2+5) cyl(r=rc, h=4, anchor=BOTTOM);
        //right(y1-10) up(ddz+z2+5) cuboid([rc, 2*rc, 4], anchor=BOTTOM+LEFT);
    }
    right(y1) cuboid([rc+e, 2*rc, 100], anchor=BOTTOM+LEFT);
}


//right(y1-10) up(ddz) cuboid([10, 2*r3, z2+z3+5], anchor=LEFT+BOTTOM);
//color("blue") right(y1-20) up(z2+z3+ddz) cuboid([20, 14, 5], anchor=LEFT+BOTTOM, chamfer=2, edges=LEFT);