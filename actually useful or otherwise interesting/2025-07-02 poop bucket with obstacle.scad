include <BOSL2/std.scad>

e = 0.01;
fn = 72;
t = 1;


x1 = 100;
y1 = 80;
z1 = 35;

x2 = 110;
y2 = 120;
z2 = 40;

x3 = 140;
y3 = 130;
z3 = 105;

tl = 4; // thickness of "lever arm" piece
ny = 19.5; // notch y-thickness

// Version 1 with 3.5cm area between handle and printer
zrot(-90) {
    
difference() {
    union() {
        cuboid([x1, y1, z1], anchor=BACK+BOTTOM);
        up(z1) prismoid(size1=[x1, y1], size2=[x2, y2], shift=[0, (y1-y2)/2], height=z2, anchor=BACK+BOTTOM);
        up(z1+z2) prismoid(size1=[x2, y2], size2=[x3, y3], shift=[0, (y2-y3)/2], height=z3, anchor=BACK+BOTTOM);
        
        up(z1) fwd(y1) prismoid(size1=[10,40], size2=[10, 0], shift=[0, -15], height=z2, anchor=BACK+BOTTOM);
        //fwd(y1) up(z1) prismoid(size1=[x1, 40], size2=[1.5*x1, 1], shift=[0, -35], height=100, anchor=BACK+BOTTOM);
    }
    
    fwd(tl) down(e) cuboid([x1+2*e, ny, z1-t], anchor=BACK+BOTTOM);
    up(t+e) fwd(tl+ny+t) cuboid([x1-2*t, y1-ny-tl-2*t, z1-t+e], anchor=BACK+BOTTOM);
    
    //up(t) fwd(t) cuboid([x1-2*t, y1-2*t, z1-t+e], anchor=BACK+BOTTOM);
    up(z1+e) fwd(t) prismoid(size1=[x1-2*t, y1-2*t], size2=[x2-2*t, y2-2*t], shift=[0, (y1-y2)/2], height=z2+e, anchor=BACK+BOTTOM);
    up(z1+z2) fwd(t) prismoid(size1=[x2-2*t, y2-2*t], size2=[x3-2*t, y3-2*t], shift=[0, (y2-y3)/2], height=z3+e, anchor=BACK+BOTTOM);
    
    color("red") up(z1+z2) back(10) prismoid(size1=[150,80], size2=[150,130], shift=[0, (80-130)/2], height=z3+e, anchor=BACK+BOTTOM);
}

}


// Version 2 that allows printer to be adjacent to handle
/*
x1 = 100;
y1 = 90;
z1 = 35;

x2 = 110;
y2 = 120;
z2 = 40;

x3 = 140;
y3 = 130;
z3 = 120;

//back(200) 
difference() {
union() {
    prismoid(size1=[x1, y1], size2=[x2, y2], shift=[0, (y1-y2)/2], height=z2, anchor=BACK+BOTTOM);
    up(z2) prismoid(size1=[x2, y2], size2=[x3, y3], shift=[0, (y2-y3)/2], height=z3, anchor=BACK+BOTTOM);
    fwd(y1) prismoid(size1=[10,40], size2=[10, 0], shift=[0, -10], height=z2, anchor=BACK+BOTTOM);
    
    cuboid([50, 4, 20], anchor=TOP+BACK);
    fwd(19+4) cuboid([50, 2, 20], anchor=TOP+BACK);
}

    up(t) fwd(t) prismoid(size1=[x1-2*t, y1-2*t], size2=[x2-2*t, y2-2*t], shift=[0, (y1-y2)/2], height=z2+e, anchor=BACK+BOTTOM);
    up(z2+t) fwd(t) prismoid(size1=[x2-2*t, y2-2*t], size2=[x3-2*t, y3-2*t], shift=[0, (y2-y3)/2], height=z3+e, anchor=BACK+BOTTOM);
    
    color("red") up(z2) back(10) prismoid(size1=[150,80], size2=[150,130], shift=[0, (80-130)/2], height=z3+e, anchor=BACK+BOTTOM);
}
*/

