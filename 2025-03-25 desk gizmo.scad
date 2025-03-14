include <BOSL2/std.scad>

e = 0.01;
fn = 72;

difference() {
    union() {

        up(4.5) 
        difference() {
            down(e) cyl(9, 54, 54, rounding1=5, $fn=fn);
            cyl(9, 50, 50, rounding1=7, $fn=fn);
            down(0.5) cyl(9, 45, 45);
            zrot(-55) back(50) up(1) cuboid([20, 20, 10]);
        }

        sq=23;
        ch=1.5;
        h = 4;
        up(h/2) fwd(90)
        for (i = [0:5]) {
            right(i*(sq-2*ch+e) - 90)
            difference() {
                cuboid([sq, sq, h], chamfer=ch, edges=TOP);
                up(h-ch) cuboid([sq-2*ch, sq-2*ch, h], chamfer=ch, edges=BOTTOM);
                down(e) cuboid([sq-4*ch, sq-4*ch, h]);
            }
        }

        difference() {
            up((h-ch)/2) fwd(60) left(40) cuboid([120, 40, h-ch]);
            cyl(9, 49, 49, $fn=fn);
            up((h-ch)/2) fwd(70-ch) left(40) cuboid([40, 20-2*ch, h]);
            up(6) fwd(70-ch) left(40) cuboid([40+2*ch, 20, 10], chamfer=ch, edges=BOTTOM);
        }
    }

    color("red") fwd(62.5) down(1) cuboid([30, 30, 4]);
    color("red") fwd(62.5) down(1) left(80) cuboid([30, 30, 4]);
}