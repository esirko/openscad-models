include <BOSL2/std.scad>

e = 0.01;
x0 = 50;
y0 = 200;
z0 = 5;


module cutout(x, y, r, left=false) {
    back(y) right(x) {
        cyl(r=r, h=z0+1);
        if (left) {
            fwd(r) left(0.75*r) up(z0/2+e) color("red") text3d(str(r), size=5, anchor=TOP+RIGHT);
        } else {
            fwd(r) right(0.75*r) up(z0/2+e) color("red") text3d(str(r), size=5, anchor=TOP+LEFT);
        }
    }
}


difference() {
    cuboid([x0, y0, z0], anchor=FRONT+LEFT);
    cutout(0, 15, 10);
    cutout(0, 15+1+2*11, 11);
    cutout(0, 15+2+2*(11+12), 12);
    cutout(0, 15+3+2*(11+12+13), 13);
    cutout(0, 15+4+2*(11+12+13+14), 14);
    cutout(0, 15+5+2*(11+12+13+14+15), 15);
    cutout(0, 15+6+2*(11+12+13+14+15+16), 16);
    
    cutout(x0, y0-18, 17, left=true);
    cutout(x0, y0-19-2*(18), 18, left=true);
    cutout(x0, y0-20-2*(18+19), 19, left=true);
    cutout(x0, y0-21-2*(18+19+20), 20, left=true);
    cutout(x0, y0-22-2*(18+19+20+21), 21, left=true);
}
