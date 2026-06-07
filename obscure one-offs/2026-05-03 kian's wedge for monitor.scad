include <BOSL2/std.scad>

x = 180;
h = 20;
l = 100;

prismoid(size1=[x, 0], size2=[x, h], shift=[0, h/2], h=l, orient=FRONT);