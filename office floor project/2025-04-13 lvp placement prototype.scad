include <bosl2/std.scad>

difference() {
    union() {
        cuboid([11, 40, 1], anchor=LEFT+BACK+TOP);
        right(11.5) cuboid([37, 40, 1], anchor=LEFT+BACK+TOP);
        right(11.5 + 37.5)cuboid([10, 40, 1], anchor=LEFT+BACK+TOP);

        color("red")
        xcopies(12, 10, sp=0)
        left(5) cuboid([11.9, 20, 1], anchor=LEFT+FRONT+BOTTOM);
    }

    cuboid([100,100,100], anchor=RIGHT);
    right(11.5 + 37.5 + 10) cuboid([100,100,100], anchor=LEFT);
}