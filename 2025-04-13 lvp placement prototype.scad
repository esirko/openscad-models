include <bosl2/std.scad>

cuboid([11, 40, 1], anchor=LEFT+BACK+TOP);
right(11.5) cuboid([37, 40, 1], anchor=LEFT+BACK+TOP);
right(11.5 + 37.5)cuboid([10, 40, 1], anchor=LEFT+BACK+TOP);

color("red")
xcopies(7.08, 10, sp=0)
left(3) cuboid([7., 20, 1], anchor=LEFT+FRONT+BOTTOM);