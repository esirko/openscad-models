include <BOSL2/std.scad>

e = 0.02;

ct = 15 + 2; // circle_thickness
rt = 25 + 2; // rectangle_thickness
ctl = 120; // circle_trench_length
rtl = 80; // rectangle_trench_length
h = 35;
t = 3;


difference() {
    union() {
        cuboid([rtl, rt+2*t, h], anchor=TOP) {
            attach(LEFT) prismoid(size1=[rt+2*t, h], size2=[ct+2*t, h], h=(ctl-rtl)/2+t);
            attach(RIGHT) prismoid(size1=[rt+2*t, h], size2=[ct+2*t, h], h=(ctl-rtl)/2+t);
        }
    }
    color("red") {
        up(e) cuboid([ctl, ct, 51], anchor=TOP);
        up(e) cuboid([rtl+e, rt, 51], anchor=TOP);
        
        down(t) {
            ycut = rt+2*t+e;
            cuboid([rtl+e, ycut, h-2*t], anchor=TOP);
            xflip_copy() right(rtl/2+t) cuboid([(ctl-rtl)/2-t, ycut, h-2*t], anchor=TOP+LEFT);
            cuboid([ctl+2*t+e, ct, h-2*t], anchor=TOP);
        }
    }
}

bh = 4;
by = rt+30;
down(h)
        cuboid([ctl+2*t+2, by, bh], anchor=TOP, chamfer=1, edges=TOP); //{
            //attach(LEFT) prismoid(size1=[by, bh], size2=[by-5, bh], h=(ctl-rtl)/2+t, rounding=2);
            //attach(RIGHT) prismoid(size1=[by, bh], size2=[by-5, bh], h=(ctl-rtl)/2+t);
        //}