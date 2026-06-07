include <BOSL2/std.scad>

yt = 15; //
x0 = 1;
z0 = 23 + 31;
x1 = 5;
z1 = 43;
x2 = 50;
z2 = 10; //
x3 = 8; //
z3 = 16;

//down(z0) prismoid(size1=[0,yt], size2=[x0,yt], h=8, shift=[-x0/2,0], anchor=TOP+RIGHT);
cuboid([x0, yt, z0], anchor=RIGHT+TOP);
cuboid([x1, yt, z1+1], anchor=RIGHT+BOTTOM);
up(z1) cuboid([x2, yt, z2], anchor=RIGHT+BOTTOM, chamfer=1, edges="X");
left(x2) up(z1+z2-z3) cuboid([x3, yt, z3], anchor=RIGHT+BOTTOM, chamfer=1, except=RIGHT);

down(z0) cuboid([10, yt, 5], anchor=TOP+RIGHT, chamfer=1, edges=BOTTOM);