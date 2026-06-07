include <BOSL2/std.scad>

e = 0.01;
r0 = 30;
r0b = 26;
r1 = 20.4;
r1b = 18;
r2 = 21;
r2b = 21.4;
r3 = 22;
r3b = 22.4;
h1 = 18;
h2 = 5.5;
h3 = 5.5;
fn = 90;

difference() {
    cyl(r1=r0b, r2=r0, h=h1+h2+h3, $fn=fn, anchor=BOTTOM, rounding=1);
    down(e) cyl(r1=r1b, r2=r1, h=h1+2*e, $fn=fn, anchor=BOTTOM);
    up(h1) cyl(r1=r2b, r2=r2, h=h2+2*e, $fn=fn, anchor=BOTTOM);
    up(h1+h2) cyl(r1=r3b, r2=r3, h=h3+2*e, $fn=fn, anchor=BOTTOM);
    cuboid([100, 100, 100], anchor=BACK);
    //zrot(60) cuboid([100, 100, 100], anchor=BACK);
    
    //up(2) cuboid([100, 100, 100], anchor=RIGHT+BOTTOM);
}