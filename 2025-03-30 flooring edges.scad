include <BOSL2/std.scad>
include <BOSL2/joiners.scad>

// trap door edging pieces

e = 0.01;
fn = 36;

h = 19+5;
t1 = 2;
x1 = 10;
t2 = 3;
t3 = 3;
x2 = 15;
l = 30;
r1 = 1;
r2 = 3;
ch1 = 1.5;
ch2 = 2.5;

difference() {
    union() {
        cuboid([x1, l, t1], chamfer=ch1, edges=TOP+RIGHT, anchor=FRONT+LEFT+TOP);
        diff("remove")
        down(t1) cuboid([t2, l, h], anchor=FRONT+LEFT+TOP) {
            attach(BACK) dovetail("male", slide=t2, width=10, height=5, spin=90, taper=-6);
            tag("remove") attach(FRONT) dovetail("female", slide=t2, width=10, height=5, spin=90, taper=-6);
        }
        
        diff("remove")
        down(t1+h) cuboid([x2, l, t3], chamfer=ch2, edges=BOTTOM+RIGHT, anchor=FRONT+LEFT+TOP) {
            attach(BACK) dovetail("male", slide=t2, width=6, height=5, taper=-6);
            tag("remove") attach(FRONT) dovetail("female", slide=t2, width=6, height=5, taper=-6);
        }
    }

    fwd(e) yrot(90) xrot(90) rounding_edge_mask(l=l+2*e, r=r1, excess=1, $fn=fn, anchor=TOP);
    fwd(e) down(t1+h+t3) xrot(90) rounding_edge_mask(l=l+2*e, r=r2, excess=1, $fn=fn, anchor=TOP);
}

