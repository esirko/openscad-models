include <BOSL2/std.scad>
include <BOSL2/walls.scad>

fn=9;
e = 0.01;

/*
left(100)
difference() {
    union() {
        cuboid([50, 80, 15], rounding=2, $fn=fn);
        down(4) cuboid([60, 90, 1], $fn=fn);
    }
    
    down(1) cuboid([48, 78, 15]);
}

back(100) 
difference() {
    cyl(r=40, h=8);
    down(1) cyl(r=39, h=8);
}
*/

/*
thick=2;
strut=2;
l = 100; //80; //100;
h = 40; //20; //40;
d = 27; //17; //27;

sparse_wall(h=h, l=l, thick=thick, strut=strut, anchor=LEFT+BOTTOM);
right(d+thick) sparse_wall(h=h, l=l, thick=thick, strut=strut, anchor=LEFT+BOTTOM);
up(e) sparse_wall(h=d+2*thick, l=l, thick=thick, strut=strut, anchor=LEFT+BOTTOM, orient=RIGHT);
*/


module frame(h, l, thick, anchor, spin) {
    //sparse_wall(h=h, l=l, thick=thick, strut=1, anchor=anchor, spin=spin);
    
    px = (l-2*t)/2;
    diff() cuboid([thick, l, h], anchor=anchor, spin=spin) {
        tag("remove") cuboid([thick+2*e, l-2*thick, h-2*thick]);
        down(t) back(t) tag("keep") position(TOP+FRONT) prismoid(size1=[1,0], size2=[t, px], shift=[0, px/2], h=px, anchor=TOP+FRONT);
        down(t) fwd(t) tag("keep") position(TOP+BACK) prismoid(size1=[1,0], size2=[t, px], shift=[0, -px/2], h=px, anchor=TOP+BACK);
    }
}

module one_fourth_of_it() {
    back(y0+y1) 
    frame(h=h, l = 2*x0 + 2*t, thick=t, anchor=RIGHT+BOTTOM, spin=-90);

    back(y0 + y1/2) right(x0) back(t/2)
    color("red") frame(h=h, l=y1+t, thick=t, anchor=RIGHT+BOTTOM, spin=180);

    back(y0) right(x0 + x1/2) right(t/2)
    frame(h=h, l = x1+t, thick=t, anchor=RIGHT+BOTTOM, spin=-90);

    right(x0+x1)
    color("red") frame(h=h, l=2*y0+2*t, thick=t, anchor=RIGHT+BOTTOM, spin=180);

}

ct = 15 + 2; // circle_thickness
rt = 25 + 2; // rectangle_thickness
ctl = 120; // circle_trench_length
rtl = 80; // rectangle_trench_length
h = 50;
t = 3;

x0 = ct/2; // 5
x1 = (rt-ct)/2; // 5
y0 = rtl/2; // 15
y1 = (ctl-rtl)/2; // 25


one_fourth_of_it();
xflip() one_fourth_of_it();
yflip() one_fourth_of_it();
xflip() yflip() one_fourth_of_it();


//frame(h=h, l = 2*x0 + 2*t, thick=t, anchor=RIGHT+BOTTOM);


