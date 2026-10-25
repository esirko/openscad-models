include <BOSL2/std.scad>

e = 0.01;
fn=36;

//dowel_r = 2.38+0.05; // 3/16" diameter = 2.38mm radius
dowel_r = 3.175+0.05; // 1/4" diameter = 3.175mm radius

difference() {
    cyl(r=14, h=6, chamfer=1, $fn=fn);
    //cuboid([100, 100, 5+2*e], anchor=BACK, chamfer=-1);
    translate([0, 0, 1]) cyl(r=dowel_r, h=6, $fn=fn);
}

/*
translate([20, 0, 0])
intersection() {
    difference() {
        sphere(r=4, $fn=2*fn);
        translate([0, 0, -3]) cyl(r=dowel_r, h=10, $fn=fn, anchor=BOTTOM);
    }
    
    cyl(r=3.5, h=10, $fn=fn);
}
*/

/*
translate([20, 0, 0]) {
    difference() {
        sphere(r=3.5, $fn=2*fn);
        cuboid([10, 10, 10], anchor=TOP);
    }
    difference() {
        cyl(r=3.5, h=5, $fn=fn, anchor=TOP);
        cyl(r=2.38, h=5.1, $fn=fn, anchor=TOP);
    }
}
*/

translate([40, 0, 0]) {
    difference() {
        cuboid([30, 10, 6], chamfer=1);
        up(2) cyl(r=dowel_r, h=6, $fn=fn);
    }
}

xflip_copy()
translate([20, 40, 0]) {
    difference() {
        cuboid([30, 10+9, 18], chamfer=1, anchor=BOTTOM+LEFT+BACK);
        translate([-e, -4, 4]) cuboid([30+2*e, 11, 12], anchor=BOTTOM+LEFT+BACK);
        translate([-e, -4, 6]) cuboid([30+2*e, 6, 17], anchor=BOTTOM+LEFT+BACK);
        translate([-e, -4, 6]) cuboid([15+dowel_r, 9, 17], anchor=BOTTOM+LEFT+BACK);
    }
}