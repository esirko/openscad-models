include <BOSL2/std.scad>




difference() {
    union() {
        diff() prismoid(size1=[50, 48], size2=[30, 48], h=40, anchor=TOP+BACK, orient=BACK) // chamfer=[2, 2, 0, 0]
            position(BOTTOM) tag("remove") up(4) prismoid(size1=[40, 48.1], size2=[24, 48.1], h=32);
        
        s = 132;
        fwd(22) zrot(90) diff() prismoid(size1=[s, 10], size2=[0, 10], h=s, shift=[-s/2, 0], anchor=BOTTOM+RIGHT)
            up(6) left(10) position(BOTTOM) tag("remove") prismoid(size1=[s-40, 10.1], size2=[0, 10.1], h=s-40, shift=[-(s-40)/2, 0]);
        
        fwd(100) {
            zrot(90) prismoid(size1=[20, 6], size2=[10, 6], h=50, anchor=BOTTOM+BACK, orient=BACK);
            zrot(-90) prismoid(size1=[20, 6], size2=[10, 6], h=50, anchor=BOTTOM+BACK, orient=BACK);
        }
        
        fwd(31) up(31) xrot(45) cyl(r=18, h=50);
    }
    
    fwd(31) up(31) xrot(45) up(2) cyl(r=16, h=50);
}

up(48-8) fwd(4) prismoid(size1=[30, 0], size2=[30, 4], shift=[0,-2], h=8, anchor=BOTTOM+BACK);

up(48) fwd(8) cuboid([30, 8 + 41 + 4, 4], anchor=BOTTOM+FRONT);
back(41) {
    cuboid([30, 4, 48], anchor=BOTTOM+FRONT);
    up(48-10-10) cuboid([4, 1, 10], anchor=BOTTOM+BACK);
}



/*
e = 0.01;
x = 36;
back = 2;
gap = 7.5;
holeh = 35;

//This one has its holh too big by about 2-3mm

difference() {
    union() {
        cuboid([x, 40, holeh+8], anchor=BOTTOM+BACK);
        fwd(33) up(29) xrot(20) cyl(r=18, h=50);
    }
    fwd(back) down(e) cuboid([x+1, gap, holeh], anchor=BOTTOM+BACK);
    down(e) back(e) cuboid([x+1, back+2*e, 8], anchor=BOTTOM+BACK);
    color("red") fwd(33) up(29) xrot(20) up(2) cyl(r=16, h=50);
    cuboid([100, 100, 10], anchor=TOP);
}
*/