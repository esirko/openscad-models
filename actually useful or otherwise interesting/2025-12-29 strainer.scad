include <BOSL2/std.scad>
include <BOSL2/threading.scad>

// Suggestions on how to print
// - Upside-down
//     - Use a smooth plate to get a smooth top part
//     - I had a terribly hard time separating PLA support from the bottom of the well, so much that I gave up
//     - Even PETG was easier to remove, but still not the easiest
// - Rightside-up
//     - Removing PETG as the support was fairly easy, but there's a noticeable weakness at the transition point where it starts to break



e = 0.01;
r0 = 113/2;
r1 = 72/2; // I measured this wrong I think, it should be more like 76 not 72
fn = 36;

dx = 6;
t = 1.6;
h = 23;

sqrt2 = sqrt(2);
shape = [[47-dx, 0], [43-dx, -4], [41-dx, -12], [38-dx, -18], [33-dx, -h], [0, -h], 
    [0, -h+t], [33-dx-t/sqrt2, -h+t], [38-dx-t/sqrt2, -18+t/sqrt2], [41-dx-t, -12], [43-dx-t, 0]];

blank_space_shape = [[43,0], [41,-12], [39,-18], [34,-23], [26,-26],
    [34-dx-t/sqrt2, -h+t], [38-dx-t/sqrt2, -18+t/sqrt2], [41-dx-t, -12], [43-dx-t, 0]];

difference() {
    union() {
        diff() cyl(r1=r0, r2=r0-1, h=1, anchor=BOTTOM, $fn=fn)
            position(BOTTOM) tag("remove") down(e) cyl(r=43-dx-t, h=1+2*e, rounding2=-1, $fn=fn, anchor=BOTTOM);

        rotate_sweep(shape);
    }

    down(h) grid_copies(size=2*(25-dx), spacing=3)
        cuboid([2, 1.5, 10]);
    
    zrot_copies(n=40)
    right(43-dx) {
        down(3) cuboid([20, 2, 2]); // smaller hole to avoid supports when printing as it pokes through more material
        down(6) cuboid([20, 3, 2]);
        down(9) cuboid([20, 3, 2]);
        down(12) cuboid([20, 3, 2]);
        down(15) cuboid([20, 3, 2]);
    }
    
    //cuboid([100,100,100], anchor=BACK); // debug cutout
}



// little knob
down(h) {
    cyl(r=6,h=t, anchor=BOTTOM);
    up(t) cyl(r1=6, r2=4, h=3, anchor=BOTTOM);
    up(t+3) cyl(r=4, h=19.4-3, anchor=BOTTOM);
    up(t+19.4) cyl(r1=4, r2=6, h=3, rounding2=1, anchor=BOTTOM);
}


spiral_path = [[0,0], [30, 0], [30, -2], [0, -2]];
difference() {
    color("red") 
    intersection() {
        rotate_sweep(blank_space_shape);
        zrot_copies(n=8)
        spiral_sweep(spiral_path, h=h, r=30-dx, turns=-0.125, $fn=360, anchor=TOP);
        cuboid([150, 150, h], anchor=TOP); // make sure the spiral at the bottom lies on exactly the same plane as the bottom of the disk
    }
    //cuboid([100,100,100], anchor=BACK); // debug cutout
}



/*
module hcyl(r1, r2, h, anchor) {
    diff() cyl(r1=r1, r2=r2, h=h, anchor=anchor)
        position(TOP) tag("remove") up(e) cyl(r1=r1-2, r2=r2-2, h=h+2*e, anchor=anchor);
}

// shape of actual drain as best as I can determine/measure
color("blue")
down(e)
difference() {
    union() {
        diff() cyl(r=r0, h=1, anchor=BOTTOM)
            position(BOTTOM) tag("remove") down(e) cyl(r=r1-2, h=1+2*e, anchor=BOTTOM);
        hcyl(r2=43, r1=41, h=12, anchor=TOP);
        down(12) hcyl(r2=41, r1=39, h=6, anchor=TOP);
        down(18) hcyl(r2=39, r1=34, h=5, anchor=TOP);
        down(23) hcyl(r2=34, r1=26, h=3, anchor=TOP);
        down(26) hcyl(r2=26, r1=24, h=5, anchor=TOP);
        down(31-1) cyl(r=24,h=1,anchor=TOP);
        up(1)cuboid([72, 10, 1]);
    }

    fwd(5) cuboid([250, 150, 100], anchor=BACK);
    back(5) cuboid([250, 150, 100], anchor=FRONT);
}
*/

// shape of the pre-existing one to compare
/*
color("red") {
    difference() {
        union() {
            diff() cyl(r=r0, h=1, anchor=BOTTOM)
                position(BOTTOM) tag("remove") down(e) cyl(r=38, h=1+2*e, anchor=BOTTOM);
            hcyl(r1=33.5+2, r2=38+2, h=23, anchor=TOP);
            down(23) cyl(r=33.5+2,h=1,anchor=BOTTOM);
        }
    cuboid([250, 150, 100], anchor=BACK);
    }
}
*/
