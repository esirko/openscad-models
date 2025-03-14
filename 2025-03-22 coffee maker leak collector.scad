include <BOSL2/std.scad>
include <BOSL2/joiners.scad>
include <BOSL2/walls.scad>
 
// 70 oz = 2070.15 mL = 18cm * 18cm * 7cm
// coffee maker dimensions: 203mm * 254mm

rw = 168; // width of reservoir (constrained by A1 mini)
h = 80; // height of reservoir;
g = 95; // height of pedestal total;
t = 4; // thickness of walls;
f = 0.5; // fudge factor to make pedestal bigger than tray so it can insert easily
x = 6.5 * 25.4; // distance from back to center of circle
r = 3.8 * 25.4; // radius of circular front, or half of width
hole = 1/3; // size of hole relative to width of pedestal (approx)
e = 0.01;

//pedestal
difference() {
    union() {
        cylinder(g, r+f, r+f);
        cuboid([2*(r+f), x, g],anchor=BOTTOM+FRONT);
    }

    up(-e) cylinder(g+2*e,r-t+f,r-t+f);
    up(-e) back(t) cuboid([2*(r-t+f), x-2*t, g+t],anchor=BOTTOM+FRONT);
    up(t) back(x-t-e) cuboid([rw+f, t+2*e, h+2*f],anchor=BOTTOM+FRONT);
    //sparse_cuboid([2*(r+f), t, h],BACK,anchor=BOTTOM+FRONT);
    
    down(e) cylinder(t+e,0.75*r, 0.75*r);
    down(e) cuboid([1.5*r, 1.5*r, t+e],anchor=BOTTOM+FRONT);
}
sparse_cuboid([2*(r+f), t, h+t+2*f],BACK,anchor=BOTTOM+FRONT);

// support for pedestal
down(20)
difference() {
    
    down(1) fwd(t)
    union() {
        back(4) cylinder(t+2, r+f+t, r+f+t);
        cuboid([2*(r+f+t), x+2*t, t+2],anchor=BOTTOM+FRONT);
    }
    sparse_cuboid([2*(r+f), t, h+t+2*f],BACK,anchor=BOTTOM+FRONT);

    down(2*e)
    difference() {
        union() {
            cylinder(t+4*e+3, r+f, r+f);
            cuboid([2*(r+f), x, t+4*e+3],anchor=BOTTOM+FRONT);
        }

        down(e) cylinder(t+2*e,r-t+f,r-t+f);
        down(e) back(t) cuboid([2*(r-t+f), x-2*t, t+2*e],anchor=BOTTOM+FRONT);
    }

    down(1+e)
    union() {
        cylinder(2+t+3, r+f-2*t, r+f-2*t);
        cuboid([2*(r+f-2*t), x-2*t, 2+t+3],anchor=BOTTOM+FRONT);
    }
    
    fwd(250) down(t) cuboid([40, 400, 2*t+3],anchor=BOTTOM+FRONT);
    back(90) down(t) cuboid([400, 80, 2*t+3],anchor=BOTTOM);
}

// tray
up(h+t+2*f)
difference() {
    union() {
        cylinder(t, r+f, r+f);
        cuboid([2*(r+f), x, t],anchor=BOTTOM+FRONT);
    }
    back(x/3) up(e) cuboid([rw*hole, rw*hole, t+2*e],anchor=BOTTOM+FRONT);
}

// reservoir
back(x+20)
difference() {
    up(t) cuboid([rw, rw, h],anchor=BOTTOM+FRONT);
    up(2*t) back(t) cuboid([rw-2*t, rw-2*t, h+e],anchor=BOTTOM+FRONT);
}


