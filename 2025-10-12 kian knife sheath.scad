include <BOSL2/std.scad>

e = 0.01;

difference() {
    prismoid(size1=[20, 8], size2=[18, 6], shift=[-1, 0], h=35);
    
    down(e) left(1) prismoid(size1=[30, 1.5], size2=[30, 2.5], h=15, orient=RIGHT, anchor=RIGHT);

    //cuboid([50, 50, 100], anchor=BACK);
}

    //down(e) left(1) prismoid(size1=[30, 1.5], size2=[30, 2.5], h=15, orient=RIGHT, anchor=RIGHT);
   