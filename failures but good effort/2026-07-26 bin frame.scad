include <BOSL2/std.scad>

e = 0.01;

x = 381; // can be printed in 2 segments
y = 558; // can be printed in 3 segments
z = 330; // can be printed in 2 segments

dx = 20;
dy = 20;
dz = 20;


/*
cuboid([x, dy, dz], anchor=BOTTOM+FRONT+LEFT);
cuboid([dx, y, dz], anchor=BOTTOM+FRONT+LEFT);
back(y) cuboid([x, dy, dz], anchor=BOTTOM+BACK+LEFT);
right(x) cuboid([dx, y, dz], anchor=BOTTOM+FRONT+RIGHT);

cuboid([dx, dy, z], anchor=BOTTOM+FRONT+LEFT);
back(y) cuboid([dx, dy, z], anchor=BOTTOM+BACK+LEFT);
right(x) cuboid([dx, dy, z], anchor=BOTTOM+FRONT+RIGHT);
translate([x, y, 0]) cuboid([dx, dy, z], anchor=BOTTOM+BACK+RIGHT);

up(z-dz) {
    cuboid([x, dy, dz], anchor=BOTTOM+FRONT+LEFT);
    cuboid([dx, y, dz], anchor=BOTTOM+FRONT+LEFT);
    back(y) cuboid([x, dy, dz], anchor=BOTTOM+BACK+LEFT);
    right(x) cuboid([dx, y, dz], anchor=BOTTOM+FRONT+RIGHT);
}


color("red") cuboid([180, 180, 1]);
*/



c = 60;
n = 10;
ny1 = 8;
ny2 = 12;
slopny = 0.0;
slopn = 0.0;

difference() {
    union() {
        cuboid([c, dy, dz], anchor=BOTTOM+FRONT+LEFT, chamfer=1, except=RIGHT);
        cuboid([dx, c, dz], anchor=BOTTOM+FRONT+LEFT, chamfer=1, except=BACK);
        cuboid([dx, dy, c], anchor=BOTTOM+FRONT+LEFT, chamfer=1, except=TOP);
    }

    translate([-e, (dy-ny2-slopny)/2, c-n-slopn+e]) prismoid(size1=[dz+2*e, ny2+slopny], size2=[dz+2*e, ny1+slopny], h=n+slopn, anchor=BOTTOM+FRONT+LEFT);
    translate([c-n-slopn+e, (dy-ny2-slopny)/2, -e]) yrot(90) prismoid(size1=[dz+2*e, ny2+slopny], size2=[dz+2*e, ny1+slopny], h=n+slopn, anchor=BOTTOM+FRONT+RIGHT);
    translate([(dy-ny2-slopny)/2, c-n-slopn+e, -e]) zrot(90) yrot(90) prismoid(size1=[dz+2*e, ny2+slopny], size2=[dz+2*e, ny1+slopny], h=n+slopn, anchor=BOTTOM+BACK+RIGHT);
    
}




l = 210;
back(80) {
    cuboid([l, dy, dz], anchor=BOTTOM+FRONT+LEFT, chamfer=1, edges="X");
    translate([-n, (dy-ny2)/2, 0]) yrot(90) prismoid(size1=[dz+2*e, ny2], size2=[dz+2*e, ny1], h=n, anchor=BOTTOM+FRONT+RIGHT);
    translate([l-e, (dy-ny1)/2, 0]) zrot(180) yrot(90) prismoid(size1=[dz+2*e, ny2], size2=[dz+2*e, ny1], h=n, anchor=TOP+BACK+RIGHT);
}