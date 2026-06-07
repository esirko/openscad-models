include <BOSL2/std.scad>
include <BOSL2/screws.scad>

//cuboid([100, 5, 1]);

//prismoid(size1=[100, 1], size2=[100,2], height=6);

e=0.1;
fn=36;

// Quick corners for the new platform

difference() {
    fwd(2) left(2) down(2) cuboid([40, 40, 31], rounding=2, $fn=fn, anchor=LEFT+FRONT+BOTTOM);
    cuboid([40, 40, 27], anchor=LEFT+FRONT+BOTTOM);
    up(2+19/2) right(20) fwd(2+e) zrot(90) yrot(-90) screw_hole("#8-32,1",head="flat",counterbore=0,anchor=TOP, $fn=fn);
}


// Webcam wedge to angle it a little differently
/*
difference() {
    cuboid([40, 50, 15], anchor=BOTTOM);
    up(1) fwd(4.5) zrot(6) cuboid([70, 36, 15], anchor=BOTTOM);
    up(10) cuboid([70, 70, 70], anchor=BACK+BOTTOM);
}
*/