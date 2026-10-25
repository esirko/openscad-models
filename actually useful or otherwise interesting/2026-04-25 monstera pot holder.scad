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
e = 0.01;



cuboid([x0, yt, z0], anchor=RIGHT+TOP);
cuboid([x1, yt, z1+1], anchor=RIGHT+BOTTOM);
up(z1) cuboid([x2+e, yt, z2], anchor=RIGHT+BOTTOM, chamfer=1, edges="X");
left(x2) up(z1+z2-z3) cuboid([x3, yt, z3], anchor=RIGHT+BOTTOM, chamfer=1, except=RIGHT);

down(z0) cuboid([10, yt, 5], anchor=TOP+RIGHT, chamfer=1, edges=BOTTOM);



right(30) {
    up(232) {
        left(140)
        difference() {
            union() {
                cyl(r=100, h=20, anchor=BOTTOM);
                color("green") translate([80, 0, 18]) prismoid(size1=[120, 4], size2=[yt, 4], h=50, orient=RIGHT, spin=90);
            }
            down(e) cyl(r=96, h=21, anchor=BOTTOM);
            translate([80, 0, -e]) cuboid([250, 250, 22], anchor=BOTTOM+RIGHT);
        }
        up(16) cuboid([44, yt, 4], anchor=BOTTOM+RIGHT);
    }

    
    splitz = 125;

    color("red")
    up(z1+z2) {
        cuboid([10, yt, splitz-10], anchor=BOTTOM+RIGHT);
        up(splitz-15) zrot(-90) xrot(90) back(20) 
            partition([100, 30, 20], spread=20)
            cuboid([40, 20, 10], anchor=BOTTOM);
        up(splitz+20) cuboid([10, yt, 212-(z1+z2)+20-splitz], anchor=BOTTOM+RIGHT);
        translate([0, yt/2, -z2-10]) cuboid([20, 4, 10+z2+10], anchor=BOTTOM+RIGHT+FRONT, chamfer=1, edges=LEFT, except=FRONT);
        translate([-10, yt/2, 0]) cuboid([10, yt+5, 10], anchor=BOTTOM+RIGHT+BACK, chamfer=1, edges=[FRONT, LEFT+TOP])
            attach(BOTTOM) fwd(yt/2 - 2.5) prismoid(size1=[8, 1], size2=[8, 0], h=0.4);
        translate([-10, yt/2, -z2]) cuboid([10, yt+15, 10], anchor=TOP+RIGHT+BACK, chamfer=1, edges=[FRONT, LEFT+BOTTOM])
            attach(TOP) fwd(yt/2 -7.5) prismoid(size1=[8, 1], size2=[8, 0], h=0.4);
    }
    
    arm=75;
    color("lightblue")
    translate([0, yt/2+0.2, z1]) cuboid([10, arm, 10], anchor=TOP+FRONT+RIGHT);
    translate([0, arm, 0]) cuboid([10, 10, z1], anchor=BOTTOM+FRONT+RIGHT, chamfer=1, edges=BACK);
    
    translate([0, -yt/2-0.2, z1]) cuboid([10, arm, 10], anchor=TOP+BACK+RIGHT);
    translate([0, -arm, 0]) cuboid([10, 10, z1], anchor=BOTTOM+BACK+RIGHT, chamfer=1, edges=FRONT);
}



