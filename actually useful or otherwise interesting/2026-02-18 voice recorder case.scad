include <BOSL2/std.scad>
include <BOSL2/partitions.scad>
include <misc/apple_airtag.scad> // https://github.com/franpoli/OpenSCADutil/blob/master/libraries/apple_airtag_accessories

e = 0.01;
x = 87.5;
y = 27.25; // used to be 27, 28 was too big
z = 10.5;
t = 1;
fn = 36;

bx = 0;
bt = 4;
by = 10;

airtag_w = 15.93;
airtag_h = 7.98;

/*
difference() {
    cuboid([x+t, y+2*t, z+2*t], anchor=BOTTOM+RIGHT+FRONT, chamfer=2, except=RIGHT);
    
    left(t+e) back(t) up(t) cuboid([x+10, y, z], anchor=BOTTOM+RIGHT+FRONT, rounding=2, $fn=fn);
    left(48) back(y) cuboid([37, 10, 10], anchor=BOTTOM+RIGHT+FRONT);
    left(42) back(2+e) cuboid([31, 10, 10], anchor=BOTTOM+RIGHT+BACK);

    up(5) right(e) fwd(e) cuboid([100, 100, 20], anchor=BOTTOM+RIGHT+FRONT);
}
*/

//up(40)
difference() {
    down(bx) right(by) cuboid([x+t+by, y+2*t, z+2*t+bx], anchor=BOTTOM+RIGHT+FRONT, chamfer=2);
    
    left(t+e) back(t) up(t) cuboid([x+10, y, z], anchor=BOTTOM+RIGHT+FRONT, rounding=2, $fn=fn);
    left(48) back(y) up(2) cuboid([37, 10, 6], anchor=BOTTOM+RIGHT+FRONT);
    left(42) back(2+e) up(2) cuboid([31, 10, 6], anchor=BOTTOM+RIGHT+BACK);

    left(62.5) back((y+2*t-20)/2) up(5) cuboid([20, 20, 30], anchor=BOTTOM+RIGHT+FRONT);
    left(34.5) back((y+2*t-20)/2) up(5) cuboid([20, 20, 30], anchor=BOTTOM+RIGHT+FRONT);
    
    //down(bx+e) back(bt+t) left(bt+t) cuboid([x-2*bt, y-2*bt, bx+3], anchor=BOTTOM+RIGHT+FRONT);
    down(bx+e) back(bt+t) right(20+e) cuboid([x+40, y-2*bt, 7], anchor=BOTTOM+RIGHT+FRONT);
    
    //down(bx+e) back(bt+t) left(bt+t) cuboid([x-2*bt, y-2*bt, bx+3], anchor=BOTTOM+RIGHT+FRONT);
    //up(5) right(e) fwd(e) cuboid([100, 100, 20], anchor=TOP+RIGHT+FRONT);
    
    back(y/2+t) right(4) cyl(r=2, h=30, $fn=fn);
}

//up(z+2*t-4) back(y/2+t-10) cuboid([10, 20, 4], anchor=BOTTOM+LEFT+FRONT, );

/*
difference() {
    fwd(((2*airtag_w+t) - (y+2*t))/2) cuboid([2*airtag_w+t, 2*airtag_w+2*t, 5], anchor=LEFT+BOTTOM+FRONT, chamfer=2, except=LEFT);
    up(t) right(airtag_w) up(airtag_h) back((y+2*t)/2) xrot(180) airtag(0.2, false);
}
*/