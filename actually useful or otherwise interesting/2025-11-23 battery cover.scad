include <BOSL2/std.scad>

y0 = 10; //18;
y1 = 10; //20;
y2 = 10;

// 38, 1, 3
// 37, 1.25, 3
// 36, 1.5, 3
// 38, 1, 4
e= 0.01;
ee = 0.25;
xl = 42;
t = 1;
tl = 3;
th = 10;
sharpness = 2;
yrot = 30;

module clip(dx=0) {
    up(1) right(5) diff()  cuboid([xl-5, y1, 2], anchor=LEFT+BOTTOM);
        //attach(TOP) down(0.4) color("red") tag("remove") text3d(str_join([str(xl), str(th), str(yrot)], ", "), h=1, size=4, center=true);

    fwd(dx) {
        cuboid([10, y1, 2], anchor=LEFT+BOTTOM);
        up(1) zflip() prismoid(size1=[2, 10], size2=[0,10], shift=[-1,0], h=2, anchor=BOTTOM, orient=LEFT);
    }
    
    if (dx != 0) {
        s = dx > 0 ? 1 : -1;
        up(1) right(5) fwd(dx/2 + s * (y1 - y2/2)) cuboid([10, abs(dx)+y1-y2, 2], anchor=LEFT+BOTTOM);
    }
    
    right(xl) cuboid([3, y2, 1], anchor=RIGHT+BOTTOM);

    right(xl/2) up(2) cuboid([3, y2, 3], anchor=RIGHT+BOTTOM);

    right(xl) yrot(yrot)
    union() {
        color("red") prismoid(size1=[t, y2], size2=[3*t, y2], shift=[0,0], h=th/2, anchor=TOP+RIGHT);
        diff() prismoid(size1=[t, y2], size2=[t, y2], shift=[sharpness, 0], h=th, anchor=TOP+RIGHT)
            attach(BOTTOM+LEFT, LEFT+FWD, inside=true) color("red") rounding_edge_mask(r=1, $fn=18);
        right(-sharpness) down(th-t) cuboid([tl-1, y2, t], anchor=TOP+LEFT);

        right((tl-1) -sharpness) down(th-t/2) prismoid(size1=[t, y2], size2=[0, y2], shift=[-t/2, 0], h=0.5, anchor=BOTTOM, orient=RIGHT);
    }
}

module hoop() {
    ht = 3;
    //fwd((y2+ht)/2+0.5) cuboid([5, ht, 2+ht], anchor=BOTTOM);
    back((y2+ht)/2+0.5) cuboid([5, ht, 2+ht], anchor=BOTTOM);
    up(2) cuboid([5, y2+1, ht], anchor=BOTTOM);
}


clip(0);


fwd(70) clip(-15);
back(70) clip(15);

color("pink")
down(10) {
    difference() {
        right(5) cuboid([28, 160, 1], anchor=LEFT);
        fwd(0) left(e) cuboid([10+ee, y1+2*ee, 2], anchor=LEFT);
        fwd(70-15) left(e) cuboid([10+ee, y1+2*ee, 2], anchor=LEFT);
        fwd(-70+15) left(e) cuboid([10+ee, y1+2*ee, 2], anchor=LEFT);
    }
    /*
    cuboid([xl-18, 100, 1], anchor=LEFT+TOP);
    right(20) {
        hoop();
        fwd(40) hoop();
        back(40) hoop();
    }
    */
}
