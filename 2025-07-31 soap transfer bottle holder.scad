include <BOSL2/std.scad>

e = 0.1;
t = 2;
h1 = 17; // 13
r1 = 30; // 20
r2 = 15; // 13
h2 = 12;
r3 = 25;
h3 = 40;
r4 = 37; // 37
shift = 8; // 5

difference() {
    union() {
        diff()
        cyl(r1=r1, r2=r2, h=h1, anchor=TOP)
            attach(CENTER) tag("remove") cyl(r1=r1-t, r2=r2-t, h=h1+1);

        diff()
        cyl(r1=r2, r2=r3, h=h2, shift=[0, shift], anchor=BOTTOM)
            attach(CENTER) tag("remove") cyl(r1=r2-t, r2=r3-t, h=h2+1, shift=[0, shift]);
        
        back(shift) up(h2) diff()
        cyl(r1=r3, r2=r4, h=h3, anchor=BOTTOM)
            attach(CENTER) tag("remove") cyl(r1=r3-t, r2=r4-t, h=h3+1);
    }
    
    up(5) {
        for (i = [0:4]) {
            zrot(-i*60+30) prismoid(size1=[50, 12], size2=[50, 18], h=25, anchor=LEFT+BOTTOM);
            zrot(-i*60+30) up(25) prismoid(size1=[50, 18], size2=[50, 1], h=10, anchor=LEFT+BOTTOM);
        }
    }

    up(h2) cuboid([25, 100, h3+e], anchor=FRONT+BOTTOM);
    up(h2) prismoid(size1=[30, 100], size2=[50, 100], h=h3+e, anchor=FRONT+BOTTOM);
}

