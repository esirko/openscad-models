include <BOSL2/std.scad>

e = 0.01;
arml = 91;

// Version 1
/*
module arm() {
    difference() {
        union() {
            prismoid(size1=[5, 14], size2=[9, 2], h=arml, shift=[0, -6], anchor=FRONT+BOTTOM, orient=RIGHT, spin=90);
            right(arml) cyl(r=10, h=6, anchor=BOTTOM);
        }
        up(2+e) right(arml) cyl(r=8, h=4, anchor=BOTTOM);
    }
}

difference() {
    union() {
        arm();
        zrot(120) arm();
        zrot(240) arm();
        cyl(r=20, h=10, anchor=BOTTOM);
    }
    up(3) cyl(r=18, h=20, anchor=BOTTOM);
    down(e) cyl(r=3.25, h=3+2*e, anchor=BOTTOM);
}
*/


// Version 2

module arm() {
    difference() {
        union() {
            down(37) prismoid(size1=[5, 14], size2=[9, 5], h=arml, shift=[0, 80], anchor=FRONT+BOTTOM, orient=RIGHT, spin=90);
            up(47) right(arml) cyl(r=10, h=6, anchor=BOTTOM);
        }
        up(49+e) right(arml) cyl(r=8, h=4, anchor=BOTTOM);
    }
}

difference() {
    union() {
        arm();
        zrot(120) arm();
        zrot(240) arm();
        cyl(r=40, h=10, anchor=BOTTOM);
    }
    up(3) cyl(r=38, h=60, anchor=BOTTOM);
    down(e) cyl(r=33.25, h=3+2*e, anchor=BOTTOM);
    cuboid([100, 100, 40], anchor=TOP);
}
