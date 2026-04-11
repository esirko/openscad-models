include <BOSL2/std.scad>

e = 0.01;

// Horizontal slope is about 27-29 mm across 33 inches = 0.0334.
// (Vertical slope is 2-4 mm across 33 inches, and that's less noticable anyway, so don't worry about that.)

module block(dx, dy, x, text) {
    z = 0.0334 * x + 1;
    dz = 0.0334 * dx;
    
    difference() {
    prismoid(size1=[z + dz, dy], size2=[z, dy], shift=[dz/2, 0], h=dx, orient=LEFT, anchor=TOP+BACK+RIGHT);
    if (text != "") {
        color("red") up(e) right(dx/2) fwd(dy/2) text3d(text, h=1, size=8, center=true, anchor=TOP);
    }
}
}


// corner block
cx = 120;
cy = 130;

// mid block
mx = 80;
my = 178;

// center-center block
ccx = 100;
ccy = 60;

// blocks under the long horizontal strips
sx = 178;
sy = 50;

// 2.5" wood emulator
wx = 63;

/*
block(cx, 80, 0, text="1");
fwd(150) block(wx, 178, 120, text="5");
right(80) fwd(150) block(wx, 178, -29, text="0");
right(160) fwd(150) block(wx, 100, 60, text="3");
right(240) fwd(150) block(wx, 100, 239.5, text="9");


right(200)
diff() cuboid([wx, 50, 3], anchor=TOP+BACK+RIGHT)
    attach(TOP) color("red") tag("remove") up(e) text3d("3", h=1, size=8, center=true, anchor=TOP);

right(300)
diff() cuboid([wx, 50, 4], anchor=TOP+BACK+RIGHT)
    attach(TOP) color("red") tag("remove") up(e) text3d("4", h=1, size=8, center=true, anchor=TOP);
*/

block(cx, cy, 0, text="TL");
fwd(420) block(my, mx, 0, text="CL");
fwd(840) block(cx, cy, 0, text="BL");

midx = 420;
right(midx) {
    block(mx, my, midx, text="TM");
    fwd(420) block(ccx, ccy, midx, text="CM");
    fwd(840) block(mx, my, midx, text="BM");
}

fullx = 840;
right(fullx) {  
    block(cx, cy, fullx, text="TR");
    fwd(420) block(my, mx, fullx, text="CR");
    fwd(840) block(cx, cy, fullx, text="BR");
}

fwd(250) {
    block(sx, sy, 0, text="S1");
    right(420) block(sx, sy, 420, text="S2");
    right(840) block(sx, sy, 420, text="S3");
}

fwd(420+250) {
    block(sx, sy, 0, text="S1");
    right(420) block(sx, sy, 420, text="S2");
    right(840) block(sx, sy, 420, text="S3");
}



