include <BOSL2/std.scad>

e = 0.1;
fn = 72;

t = 2;
s = 50;


difference() {
    cuboid([s+t, s+t, 40], rounding=2, edges=[TOP, "Z"], $fn=fn, anchor=TOP);
    
    down(11) fwd(s/2) cuboid([16, s/2, 40], anchor=TOP);
    down(20) fwd(s/3) right(3) cuboid([s+1, s+1, 40], anchor=TOP);
    
    //left(8) down(11) cuboid([s+t+1, s+t+1, 40], anchor=TOP+RIGHT);
    //right(8) down(11) cuboid([s+t+1, s+t+1, 40], anchor=TOP+LEFT);
    down(2) cuboid([s, s, 40], rounding=2, $fn=fn, anchor=TOP);
}


r = 47;

tc = 1;

up(r+tc) right(40) yrot(-90) zrot(-90)
difference() {
    union() {
        cyl(r=r+tc, h=40, $fn=fn, anchor=BOTTOM);
        up(40) cyl(r1=r+tc, r2=30+tc, h=20, $fn=fn, anchor=BOTTOM);
        
        up(14) cuboid([s+t, 50, s+t], anchor=BACK+BOTTOM, rounding=2, edges="Y", $fn=fn);
        
        //up(18) fwd(r+tc-20) cuboid([s-4, 20, 42], anchor=BACK+BOTTOM);
        /*
        up(18) fwd(r+tc-1) cuboid([10, 10, 3], anchor=BACK);
        up(28) fwd(r+tc-1) cuboid([10, 10, 3], anchor=BACK);
        up(38) fwd(r+tc-1-10) cuboid([10, 20, 3], anchor=BACK);
        up(48) fwd(r+tc-1-10) cuboid([10, 20, 3], anchor=BACK);
        up(58) fwd(r+tc-1-20) cuboid([10, 30, 3], anchor=BACK);
        */
        
    }
    up(tc) cyl(r=r, h=40-tc+e, $fn=fn, anchor=BOTTOM);
    up(40) cyl(r1=r, r2=30, h=20+e, $fn=fn, anchor=BOTTOM);
    up(60) cyl(r1=30, r2=30, h=20+e, $fn=fn, anchor=BOTTOM);
    down(e) cuboid([100, 100, 100], anchor=BOTTOM+FRONT);
}
