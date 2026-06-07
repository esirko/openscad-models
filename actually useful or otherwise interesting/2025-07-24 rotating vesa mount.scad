include <BOSL2/std.scad>
include <BOSL2/screws.scad>

e = 0.1;
fn = 72;

screwdx1 = 68;
screwdx2 = 75;
screwdy = 47;
x0 = 92;
y0 = 74;
z0 = 2;

u = 15;
r1 = 20;
r2 = 25;
r3 = 35;

z1 = 0;
z2 = 3.5;
z3 = 3.5;

x1 = 120;
y1 = 120;
zz0 = 2;
zz1 = z3 + 0.5;

zz2 = z2 - 0.5;
r4 = r1 - 0.5;
r5 = r2 - 0.5;

back(100) 
difference() {
    union() {
        up(1) diff()
        cuboid([x0, y0, z0], anchor=TOP)
            attach(TOP) {
                right(screwdx1/2) fwd(screwdy/2) screw_hole("#6-32,1",head="flat",counterbore=0,anchor=TOP, $fn=fn);
                right(screwdx2/2) fwd(-screwdy/2) screw_hole("#6-32,1",head="flat",counterbore=0,anchor=TOP, $fn=fn);
                right(-screwdx2/2) fwd(-screwdy/2) screw_hole("#6-32,1",head="flat",counterbore=0,anchor=TOP, $fn=fn);
                right(-screwdx1/2) fwd(screwdy/2) screw_hole("#6-32,1",head="flat",counterbore=0,anchor=TOP, $fn=fn);
            }
        
        difference() {
            cyl(z2+z3, r3, $fn=fn, anchor=BOTTOM);
            down(e) cuboid([2*r3+2*e, r3+e, z2+z3+2*e], anchor=BOTTOM+FRONT);
        }
        cuboid([2*r3, u, z2+z3], anchor=BOTTOM+FRONT);
    }

    cuboid([2*r2, y0/2+e, z2], anchor=BOTTOM+FRONT);
    cyl(z2, r2, $fn=fn, anchor=BOTTOM);
    
    up(z2) cyl(z3+e, r1, $fn=fn, anchor=BOTTOM);
    up(z2-e) cuboid([2*r1, r1+e, z3+2*e], anchor=BOTTOM+FRONT);
}


difference() {
    cuboid([x1, y1, zz0], anchor=TOP);
        right(50) fwd(50) up(e) { cyl(zz0+2*e, 2.5, $fn=fn, anchor=TOP); up(1) cyl(zz0+2*e, 5, $fn=fn, anchor=TOP); }
        right(50) fwd(-50) up(e) { cyl(zz0+2*e, 2.5, $fn=fn, anchor=TOP); up(1) cyl(zz0+2*e, 5, $fn=fn, anchor=TOP); }
        right(-50) fwd(-50) up(e) { cyl(zz0+2*e, 2.5, $fn=fn, anchor=TOP); up(1) cyl(zz0+2*e, 5, $fn=fn, anchor=TOP); }
        right(-50) fwd(50) up(e) { cyl(zz0+2*e, 2.5, $fn=fn, anchor=TOP); up(1) cyl(zz0+2*e, 5, $fn=fn, anchor=TOP); }
    }
cyl(zz1, r4, $fn=fn, anchor=BOTTOM);
up(zz1) cyl(zz2, r5, $fn=fn, anchor=BOTTOM);
//zrot(45) up(zz1) cuboid([5, r5+10, zz2], anchor=FRONT+BOTTOM);
    
