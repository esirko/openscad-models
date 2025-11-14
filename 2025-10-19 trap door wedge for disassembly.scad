include <BOSL2/std.scad>
include <BOSL2/screws.scad>

e = 0.01;
w = 30;
fn= 36;

module box(h, l=50, chamfer=false) {
    diff() cuboid([w, l, h], chamfer=(chamfer ? h/2 : 0), edges=BACK, anchor=BACK+TOP) {
        fwd(l/2 - 3) up(e) attach(TOP) color("red") tag("remove") text3d(str(h), anchor=CENTER+TOP);
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

/*
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

left(40) diff() // s=20, d1=19
prismoid(size1=[19, 1.5], size2=[19, 1], h=35) attach(FRONT)
    up(7) screw_hole("#8-32,1",head="flat",counterbore=0,anchor=TOP, $fn=fn);
*/

// gap filler for right-inside edge
/*
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
*/


// clamp for holding the angle in place while gluing
/*
x0a = 19;
x0b = 30;
x0c = 10;
y0 = 40;
z0 = 30;
x1 = 20;
y1 = 29;
difference() {
    cuboid([x0a+x0c, y0, z0], anchor=BOTTOM+LEFT+BACK);
    left(e) down(e) fwd((y0-y1)/2) cuboid([x1, y1, z0+2*e], anchor=BOTTOM+LEFT+BACK);
}
*/

/*
xt = 10;
x1 = 30;
x2 = 19;
yt2 = 8;
yt1 = 3;
yg = 29;
z0 = 20;
cuboid([xt, yt1+yg+yt2, z0], anchor=BOTTOM+RIGHT+FRONT);
cuboid([x1, yt1, z0], anchor=BOTTOM+LEFT+FRONT);
back(yg+yt1) cuboid([x2, yt2, z0], anchor=BOTTOM+LEFT+FRONT);

right(x1) cuboid([3, yt1+1, z0], anchor=BOTTOM+LEFT+FRONT);
*/

box(h=42, l=20);

right(50) box(h=42, l=20);
left(10) diff() cuboid([5, 20, 20], anchor=BACK+BOTTOM+RIGHT)
    down(4) right(e) attach(RIGHT) 
    color("red") tag("remxove") text3d(str(20), anchor=CENTER+TOP);
