include <BOSL2/std.scad>
include <BOSL2/joiners.scad>

half_joiner(l=20, w=10);
back(40) half_joiner2(l=20, w=10);

right(40) half_joiner(l=20, w=10, base=40);
right(40) back(40) half_joiner2(l=20, w=10, base=40);

right(80) half_joiner(l=40, w=10, base=20);
right(80) back(60) half_joiner2(l=40, w=10, base=20);

right(120) half_joiner(l=20, w=20, base=20);
right(120) back(60) half_joiner2(l=20, w=20, base=20);