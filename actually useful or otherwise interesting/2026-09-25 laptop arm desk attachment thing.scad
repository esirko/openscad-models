include <BOSL2/std.scad>

h = 64;
e = 0.01;
e2 = 0.02;

difference() {
    union() {
        color("lightblue") translate([-10, 0, 0]) cuboid([25, 18.5, h], anchor=FRONT+LEFT+TOP);
        translate([-20, 0, 0]) cuboid([95, 36, h], anchor=BACK+LEFT+TOP);
    }

    color("red")
    translate([34, e, 23+e]) prismoid(size1=[30, h], size2=[30, h], shift=[36+e2, 0], h=36+e2, anchor=FRONT+LEFT+TOP, orient=BACK);

    translate([12, -37, e]) cyl(r=22, h=10, anchor=TOP);
    translate([0, 17.5, -h]) cuboid([200, 2, 2], anchor=FRONT+BOTTOM);
    translate([13, -38, -(h-23)-2]) cyl(r=10, h=10, anchor=BOTTOM);

    //translate([-12, -3, 0]) cuboid([28, 20, 150], anchor=LEFT+BACK);
    //translate([-7,-4, 0]) cuboid([20, 20, 150], anchor=LEFT+FRONT);
}