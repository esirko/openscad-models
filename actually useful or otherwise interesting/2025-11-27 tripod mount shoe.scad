include <BOSL2/std.scad>

e = 0.01;
w = 27;
d = 21;
h = 6;
s = 3;

dropz = 100;
dropy = 70;

zrot(-90) {

left(0) {
    difference() {
        prismoid(size1=[d+2*s, w], size2=[d, w], h=8);
    }

    up(8) prismoid(size1=[d, w], size2=[d+18, w+18], h=10);
    
    difference() {
        up(18)
        union() {
            fwd(w/2+9) cuboid([d+18, w+18+30, 10], anchor=BOTTOM+FRONT);
            back(w/2+9+15) prismoid(size1=[64, 30], size2=[64, 15], shift=[0, -8], h=dropz, anchor=TOP+FRONT);
            //back(w/2+9+18) cuboid([20, 10, dropz], anchor=TOP+FRONT);
            back(w/2+9) prismoid(size1=[d, 0], size2=[d+18, 30], shift=[0, -15], h=30, anchor=TOP+FRONT);
        }
        
        up(18-dropz+12) back(50) cuboid([29*2, 100, 70], anchor=BOTTOM);
        back(dropy) down(dropz+e) cyl(r=28.75, h=2*dropz, anchor=BOTTOM);
    }
    
    color("red") up(10.5+18-e) back(dropy-30) down(dropz) cuboid([10, 7, 2], anchor=BOTTOM+FRONT);

    back(dropy) up(18-dropz) {
        cyl(r=30, h=1, anchor=BOTTOM);
        
        difference() {
            cyl(r=30, h=9, anchor=BOTTOM);
            down(e) cyl(r=28.75, h=9+1, anchor=BOTTOM);
            back(30) cuboid([12, 10, 10], anchor=BOTTOM);
        }
    }
}

/*
x0 = 80;
x1 = 120;
t = 1;

y0 = 110;
y1 = 80;
y2 = 40;

z0 = 40;
z1 = 50;
*/

// These guards for the plug are too narrow to fit the USB brick and power cable
// Also it would be nice if there were a natural dip to place the cable in, but then you need a drain hole
/*
up(50)
difference() {
    
    prismoid(size1=[x1+2, y1+2], size2=[x1-40+2, y2+2], h=z1+1, anchor=BOTTOM);
    down(e) prismoid(size1=[x1, y1], size2=[x1-40, y2], h=z1, anchor=BOTTOM);
}

difference() {
    prismoid(size1=[x0+40, y0], size2=[x0, 70], h=z1, anchor=TOP);
    down(t+e) prismoid(size1=[x0+40-2, y0-2], size2=[x0-2, 70-2], h=z1-1, anchor=TOP);

    down(10) prismoid(size1=[x0+20, 150], size2=[x0-20, 150], h=z1, anchor=TOP);
    down(10) prismoid(size1=[150, y0-20], size2=[150, 40], h=z1, anchor=TOP);
    
}
*/

}

