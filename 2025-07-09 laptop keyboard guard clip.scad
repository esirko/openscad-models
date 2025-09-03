include <BOSL2/std.scad>

x = 40;

cuboid([x, 23, 2], anchor=FRONT+BOTTOM);
back(23) up(2) cuboid([x, 7, 4], anchor=FRONT+TOP);

up(5) cuboid([x, 13, 2], anchor=FRONT+BOTTOM);
back(13) up(2) cuboid([x, 3, 5], anchor=FRONT+BOTTOM);