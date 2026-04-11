include <BOSL2/std.scad>

fn = 36;
difference() {
    cuboid([40, 12, 2]);
    left(16) cyl(r=2, h=10, $fn=fn);
    right(16) cyl(r=2, h=10, $fn=fn);
}