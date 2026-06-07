include <BOSL2/std.scad>

// Cat litter scoop holder to fit https://www.amazon.com/dp/B0D94TW9F8: use x0 = 113
// For the cat litter scoop that came with the cat litter genie, use x0 = 120
e = 0.01;

x0 = 120;
y0 = 10;

x1 = x0;
y1 = 25;
z1 = 20;

x2 = x0;
y2 = 40;
z2 = 50;

x3 = x0;
y3 = 45;
z3 = 110;

x4 = x3+25;
y4 = y3+25;
z4 = 140;

t = 2;

difference() {
    union() {
        down(t+e) fwd(t) prismoid(size1=[x3+2*t, y3+2*t], size2=[x3+2*t, y3+2*t], h=z3+t, anchor=BOTTOM+FRONT);
        fwd(t+y4-y3) down(t) prismoid(size2=[x3+2*t, y3+2*t], size1=[x4+2*t, y4+2*t], shift=[0,(y4-y3)/2], h=z4-z3, anchor=BOTTOM+FRONT);
    }

    prismoid(size1=[x0, y0], size2=[x1, y1], shift=[0,(y1-y0)/2], h=z1, anchor=BOTTOM+FRONT);
    up(z1) prismoid(size1=[x1, y1], size2=[x2, y2], shift=[0,(y2-y1)/2], h=z2-z1, anchor=BOTTOM+FRONT);
    up(z2) prismoid(size1=[x2, y2], size2=[x3, y3], shift=[0,(y3-y2)/2], h=z3-z2, anchor=BOTTOM+FRONT);

    //cuboid([300, 300, 300], anchor=LEFT);
}

difference() {
    up(z3) fwd(t+e) up(e) prismoid(size1=[x3+2*t, y3+2*t], size2=[x4+2*t, y4+2*t], shift=[0,(y3-y4)/2], h=z4-z3, anchor=BOTTOM+FRONT);
    up(z3) prismoid(size1=[x3, y3], size2=[x4, y4], shift=[0,(y3-y4)/2], h=z4-z3+2*e, anchor=BOTTOM+FRONT);
    
    up(z4+20) fwd(y4-y3) cyl(r=30, h=20, orient=FRONT);
}

    
    