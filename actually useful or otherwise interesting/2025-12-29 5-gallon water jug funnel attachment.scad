include <BOSL2/std.scad>

e = 0.01;
fn = 72;

module thingy(r0, r1, h1, h2) {
    regular_prism(6, r1=r1, r2=r0, h=h1+e, anchor=TOP);
    down(h1) regular_prism(6, r1=r0, r2=r1, h=h2, rounding1=0.5, $fn=fn, anchor=TOP);
}


down(50)
difference() {
    up(2+e) cyl(r=38, h=13, $fn=fn, anchor=TOP, rounding=2);
    down(0) cyl(r1=28, r2=27.5, h=5+e, $fn=fn, anchor=TOP);
    down(5) cyl(r1=27.5, r2=28, h=6, $fn=fn, anchor=TOP, rounding1=-1);
    cyl(r=17.5, h=30, $fn=fn);
}

down(100)
difference() {
    up(2+e) cyl(r=38, h=13, $fn=fn, anchor=TOP, rounding=2);
    down(0) cyl(r1=28, r2=27.5, h=5+e, $fn=fn, anchor=TOP);
    down(5) cyl(r1=27.5, r2=28, h=6, $fn=fn, anchor=TOP, rounding1=-1);
}

up(10) {
    //diff() 
    cyl(r1=5, r2=12, h=25, anchor=BOTTOM, rounding1=0, rounding2=2, $fn=72);
        //position(TOP) tag("remove") up(e) fwd(3) text3d("4.75", size=5, anchor=TOP);
    thingy(4.75, 5.0, 1.2, 1.2);
}


// Test knob attachment system

// Results: Using h1=h2=1.2 seems to be good, then the thickness of the lid can be 3 and there's
// 3 layers (of 0.2mm). I can fit a (r1=4.75, r1=5.0) thingy into a (r1=4.875, r1=5.125) thingy hole
// by pressing firmly, and I was able to fit a (4.75,5.0) thingy into a hole of the same size
// (4.75, 5.0) by using a rubber mallet!
/*
right(20) up(10) {
    diff() cyl(r1=5, r2=6, h=10, anchor=BOTTOM, rounding1=0, rounding2=1, $fn=72)
        position(TOP) tag("remove") up(e) fwd(3) text3d("4.875", size=5, anchor=TOP);
    thingy(4.875, 5.0, 1.2, 1.2);
}

difference() {
    cuboid([100, 20, 3], anchor=TOP+LEFT);
    up(e) right(10) thingy(4.75, 5.0, 1.2, 1.2);
    up(e) right(22) thingy(4.875, 5.0, 1.2, 1.2);
    up(e) right(34) thingy(4.875, 5.125, 1.2, 1.2);
    up(e) right(46) thingy(5.0, 5.125, 1.2, 1.2);
    up(e) right(58) thingy(5.0, 5.25, 1.2, 1.2);
}
*/


lid_thickness = 3;

difference() {
    union() {
        cyl(r=81.5, h=lid_thickness, $fn=fn, rounding=1, anchor=BOTTOM);
        up(lid_thickness) cyl(r=71.5, h=18+lid_thickness, $fn=fn, rounding1=1, anchor=TOP);
    }
    cyl(r=69.5, h=40, $fn=fn, anchor=TOP);
    fwd(60) cuboid([50, 30, 40+2*e], anchor=BACK+TOP);
    //up(e) cyl(r=60,h=40, $fn=fn, anchor=TOP);
    up(lid_thickness+e) thingy(4.875, 5.125, 1.2, 1.2);
    fwd(60) up(lid_thickness+e) cuboid([3, 20, 0.6], anchor=TOP); // colored line
}



//fwd(60) up(lid_thickness) cuboid([3, 20, 0.6], anchor=TOP); // colored line