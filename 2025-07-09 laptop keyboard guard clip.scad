include <BOSL2/std.scad>

x = 40;

cuboid([x, 30, 2], anchor=FRONT+BOTTOM);
//back(23) cuboid([x, 7, 2], anchor=FRONT+TOP);

up(5) cuboid([x, 13, 2], anchor=FRONT+BOTTOM);
back(13) up(2) cuboid([x, 3, 5], anchor=FRONT+BOTTOM);