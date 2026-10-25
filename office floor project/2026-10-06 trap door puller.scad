include <BOSL2/std.scad>


down(55) {
    cuboid([12, 9, 10], anchor=TOP+BACK+LEFT);
    right(52) cuboid([12, 9, 10], anchor=TOP+BACK+LEFT);
}

//
difference() {
    translate([0, 0, 10]) prismoid(size1=[64, 5], size2=[64, 14], shift=[0, 1.5], h=75, anchor=TOP+LEFT+BACK);
    translate([12, 0, 0]) cuboid([40, 200, 45], anchor=TOP+LEFT);
    translate([12, 0, -53]) cuboid([40, 200, 45], anchor=TOP+LEFT);
}