include <BOSL2/std.scad>
include <BOSL2/screws.scad>

/*
difference() {
    union() {
        cuboid([80, 110, 30], anchor=BOTTOM+RIGHT);
        up(30) diff() cuboid([50, 110, 30+30], anchor=TOP+LEFT) {
            up(10) attach(FRONT) screw_hole("#8", length=12, head="flat", anchor=TOP);
            up(10) attach(BACK) screw_hole("#8", length=12, head="flat", anchor=TOP);
        }
    }
    
    yrot(30) up(10) cuboid([200, 91, 100], anchor=BOTTOM);
    left(90) yrot(-30) cuboid([129, 120, 50], anchor=BOTTOM);
}
*/


// Non-configurable
l = 48 * 25.4;
t = 1.5 * 25.4;

// Configurable
h = 22 * 25.4;
b = 40;
f = 40; 
r = 100;
d = 100; // needs to be bigger than 3.5*25.4 = 90
x2fudge = 0;
slop=0.2;
e = 0.01;

// Derived
theta = asin(h / (l - b));
x1 = b * cos(theta);
y1 = b * sin(theta);
y2 = t * cos(theta);
x2 = t * sin(theta);

echo(theta, x1, y1, y2);


difference() {
    union() {
        left(f-x2) prismoid(size1=[r, d], size2=[0, d], shift=[r/2, 0], h=y1+y2, anchor=RIGHT+BOTTOM);
        cuboid([f-x2, d, y1+y2], anchor=BOTTOM+RIGHT);
        prismoid(size1=[x1, d], size2=[0, d], shift=[-x1/2, 0], h=y1, anchor=LEFT+BOTTOM);
        up(y1) prismoid(size1=[0, d], size2=[x2-x2fudge, d], shift=[(x2-x2fudge)/2, 0], h=y2, anchor=LEFT+BOTTOM);
        
    }
    
    up(35) right(10) yrot(theta-90) color("red") screw_hole("#8", length=50, head="flat", anchor=BOTTOM);
    up(35) right(10) yrot(theta-90) up(26) color("pink") cyl(r=5, h=20, anchor=BOTTOM);

    yrot(theta) right(10) color("red") screw_hole("#8", length=100, head="flat", anchor=TOP, orient=DOWN);
    yrot(theta) right(10) color("pink") cyl(r=5, h=8, anchor=BOTTOM);

    down(e) left(60) color("blue") prismoid(size1=[42, d+e], size2=[46, d+e], h=10+e, anchor=BOTTOM);
}

difference() {
    union() {
        fwd(d/2) up(y1) cyl(r=t, h=(d-3.5*25.4)/2-1, orient=FRONT, anchor=TOP);
        back(d/2) up(y1) cyl(r=t, h=(d-3.5*25.4)/2-1, orient=FRONT, anchor=BOTTOM);
    }
    up(y1+y2-e) cuboid([50, d+2*e, 50], anchor=BOTTOM);
    up(e) cuboid([100, d+2*e, 50], anchor=TOP);
    up(28) right(26) color("blue") cyl(r=3, h=d+2*e, orient=FRONT);
}

down(20) {
    left(60) color("blue") prismoid(size1=[42-slop, d], size2=[46-slop, d], h=10-slop, anchor=BOTTOM);
    // 55 tesla
    right(55) left(f-x2+r) prismoid(size1=[5, d], size2=[12, d], shift=[-3.5, 0], h=10, anchor=TOP+RIGHT);
}

down(50) {
    left(60) color("blue") prismoid(size1=[42-slop, d], size2=[46-slop, d], h=10-slop, anchor=BOTTOM);
    // 68 porch
    right(68) left(f-x2+r) prismoid(size1=[3, d], size2=[5, d], shift=[-1, 0], h=12, anchor=TOP+RIGHT);
}
