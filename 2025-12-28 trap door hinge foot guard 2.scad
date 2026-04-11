include <BOSL2/std.scad>

// "horseshoe"

e = 0.01;
h = 10;

/*
down(20) {
xflip() {
    diff() zrot(-45) pie_slice(ang=90, r=20, l=h, anchor=BOTTOM)
        tag("remove") cyl(r=18, h=h+2*e);
        
    zrot(45) right(18) cuboid([17, 2, h], anchor=LEFT+BOTTOM);

    diff() zrot(-45) pie_slice(ang=90, r=35, l=h, anchor=BOTTOM)
        tag("remove") cyl(r=33, h=h+2*e);
        
    fwd(30) zrot(14) left(1) cuboid([27, 2, h], anchor=LEFT+BOTTOM);
}

diff() zrot(-45) pie_slice(ang=90, r=20, l=h, anchor=BOTTOM)
    tag("remove") cyl(r=18, h=h+2*e);
    
zrot(45) right(18) cuboid([17, 2, h], anchor=LEFT+BOTTOM);

diff() zrot(-45) pie_slice(ang=90, r=35, l=h, anchor=BOTTOM)
    tag("remove") cyl(r=33, h=h+2*e);
    
fwd(30) zrot(14) left(1) cuboid([27, 2, h], anchor=LEFT+BOTTOM);
}
*/



color("red")
fwd(10) 
difference() {
    cuboid([64, 35, h]);
    back(7+e) cuboid([25, 22, h+2*e]);
    left(22) cuboid([16, 30, h+2*e]);
    right(22) cuboid([16, 30, h+2*e]);
    fwd(10) cuboid([35, 10, h+2*e]);
}

fwd(12+e) down(10) cuboid([6, 4, 20+h]);