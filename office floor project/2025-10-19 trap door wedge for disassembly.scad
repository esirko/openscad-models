include <BOSL2/std.scad>
include <BOSL2/screws.scad>

e = 0.01;
w = 15;
fn= 36;

module box(h, l=50, chamfer=false) {
    diff() cuboid([w, l, h], chamfer=(chamfer ? h/2 : 0), edges=BACK, anchor=BACK+TOP) {
        fwd(l/2 - 2) up(e) attach(TOP) color("red") tag("remove") text3d(str(h), size=8, anchor=CENTER+TOP);
    }
}

module bracket(t) {
    up(1) diff() cuboid([w, t, 21], anchor=BACK+TOP) {
        fwd(e) attach(FRONT) color("red") tag("remove") text3d(str(t), anchor=BACK);
    }
    cuboid([w, 20, 1], anchor=FRONT+BOTTOM);
}

module wedge(h) {
    box(h);
    fwd(6) xrot(90) prismoid(size1=[w,0], size2=[w,4], shift=[0, 2], h=30);
}


right(80) {
    wedge(7);
    right(40) wedge(8);
    right(80) wedge(9);
    right(120) wedge(10);
    right(160) wedge(18);
    right(200) wedge(19);

    back(100) {
        box(1, l=80, chamfer=true);
        right(40) box(2, l=80, chamfer=true);
        right(80) box(4, l=80, chamfer=true);
        right(120) box(8, l=80, chamfer=true);
    }

    back(140) {
        bracket(1);
        right(40) bracket(4);
        right(80) bracket(8);
        right(120) bracket(12);
    }
}


back(40) diff() // s=20, d1=19
prismoid(size1=[19, 1.5], size2=[19, 1], h=35) attach(FRONT)
    up(7) screw_hole("#8-32,1",head="flat",counterbore=0,anchor=TOP, $fn=fn);


// gap filler for right-inside edge

x1=5;
x2=4;
y1=4;
y2=2.5;
l = 200;
left(80)
{
    cuboid([x1, l, y1+y2], anchor=RIGHT+TOP);
    cuboid([x2, l, y2], anchor=LEFT+TOP);
}



// clamp for holding the angle in place while gluing

x0a = 19;
x0b = 30;
x0c = 10;
y0 = 40;
z0 = 30;
x1a = 20;
y1a = 29;
fwd(100)
difference() {
    cuboid([x0a+x0c, y0, z0], anchor=BOTTOM+LEFT+BACK);
    left(e) down(e) fwd((y0-y1a)/2) cuboid([x1a, y1a, z0+2*e], anchor=BOTTOM+LEFT+BACK);
}



xt = 10;
x1b = 30;
x2b = 19;
yt2 = 8;
yt1 = 3;
yg = 29;
z0b = 20;
fwd(120) right(80) {
cuboid([xt, yt1+yg+yt2, z0b], anchor=BOTTOM+RIGHT+FRONT);
cuboid([x1b, yt1, z0b], anchor=BOTTOM+LEFT+FRONT);
back(yg+yt1) cuboid([x2b, yt2, z0b], anchor=BOTTOM+LEFT+FRONT);

right(x1b) cuboid([3, yt1+1, z0b], anchor=BOTTOM+LEFT+FRONT);
}


// reference blocks for laser level

//box(h=42, l=15);

box(h=42, l=15);
diff() cuboid([15, 4, 15], anchor=BACK+BOTTOM)
    down(4) fwd(e) attach(FRONT)
    color("red") tag("remove") text3d(str(15), size=8, anchor=CENTER+TOP);

right(40) {
    box(h=41, l=15);
    diff() cuboid([15, 4, 15], anchor=BACK+BOTTOM)
        down(4) fwd(e) attach(FRONT)
        color("red") tag("remove") text3d(str(15), size=8, anchor=CENTER+TOP);
}

right(-40) {
    box(h=43, l=15);
    diff() cuboid([15, 4, 15], anchor=BACK+BOTTOM)
        down(4) fwd(e) attach(FRONT)
        color("red") tag("remove") text3d(str(15), size=8, anchor=CENTER+TOP);
}


// brace to hold platform against left wall
/*
x0 = 10;
x1c = 38+40;
x2c = 32;
x3 = 65;
x4 = 10;
y1b = 8;
y2 = 20;
cuboid([x0, y1b, 20], anchor=RIGHT+BOTTOM+FRONT);
back(y1b/2) cyl(r=y1b/2, l=x1c, anchor=RIGHT+BOTTOM, orient=RIGHT);
right(x1c) cuboid([x2c+x3, y2, 1], anchor=LEFT+BOTTOM+FRONT);
up(1) right(x1c) cuboid([x2c, y2, 7], anchor=LEFT+BOTTOM+FRONT);
right(x1c+x2c+x3) cuboid([x4, y2, 10], anchor=LEFT+BOTTOM+FRONT);
*/



// Final adjustments on floor right side
/*
module final_wedge(xl0=60, zl0=11, xl1=14, zl1=9, zl2=8, xr0=100, zr0=2.75, zr1=1, y=80) {
    zrot(-90) prismoid(size1=[y, zl0], size2=[y, zl1], shift=[0,(zl1-zl0)/2], h=xl0, anchor=LEFT+FRONT+BOTTOM, orient=BACK);
    right(xl0) zrot(-90) prismoid(size1=[y, zl1], size2=[y, zl2], shift=[0,(zl2-zl1)/2], h=xl1, anchor=LEFT+FRONT+BOTTOM, orient=BACK);
    right(xl0+xl1) zrot(-90) prismoid(size1=[y, zr0], size2=[y, zr1], shift=[0,(zr1-zr0)/2], h=xr0, anchor=LEFT+FRONT+BOTTOM, orient=BACK);
    right(xl0+xl1) zrot(-90) prismoid(size1=[y, zr0], size2=[y, zr1], shift=[0,(zr1-zr0)/2], h=xr0, anchor=LEFT+FRONT+BOTTOM, orient=BACK);
}

back(450) final_wedge(xl0=60, zl0=11, xl1=14, zl1=9, zl2=8, xr0=100, zr0=2.75, zr1=1, y=130);
back(300)final_wedge(xl0=46, zl0=11, xl1=26, zl1=9, zl2=7.75, xr0=77, zr0=1.5, zr1=1, y=80);
back(150) final_wedge(xl0=54, zl0=10.5, xl1=19, zl1=9, zl2=7.75, xr0=72, zr0=1.75, zr1=1, y=80);
final_wedge(xl0=40, zl0=11, xl1=67, zl1=9, zl2=7.5, xr0=10, zr0=1.25, zr1=1, y=130);
*/

