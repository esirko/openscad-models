include <BOSL2/std.scad>
include <BOSL2/screws.scad>

h = 115;
b = 130;
c = 50;
e = 0.01;

zrot(45)
diff()
regular_prism(4, r1=60/sqrt(2), r2=50/sqrt(2), h=15, rounding=2,  anchor=TOP)
    attach(TOP) up(e) color("red") tag("remove") regular_prism(4, r1=40/sqrt(2), r2=45/sqrt(2), h=10, anchor=TOP)
    attach(TOP) down(10) screw_hole("#8", length=12, head="flat", anchor=TOP);