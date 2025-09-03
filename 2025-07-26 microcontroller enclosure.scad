include <BOSL2/std.scad>
include <BOSL2/walls.scad>

e = 0.1;
fn = 36;
cr = 3;
chh = 3;
 
module clip(ch = 10, cz3 = 4, cdx=1.5, yback=0, slop=0.2) {
    // slop may depend on orientation of print. When horizontal, there's some extra gunk on one side of the cylinder, and slop=0.2 is a tight fit. If the cylinder is printed upright, I think slop would have to be smaller.
    cx1 = 3;
    cdz = 5;
    cx2 = 3;
    cx0 = 6;
    cz2 = 2;
    cy = cr*2;
    cy2 = 4;

    //cuboid([cx0, cy, cz1], anchor=BOTTOM);
    //up(cz1) 
    cuboid([cx1 + cdx + cx2, cy2, cz2], anchor=BOTTOM);
    left((cdx+cx1)/2) up(cz2) cuboid([cx1, cy2, cz3], anchor=BOTTOM);
    right((cdx+cx1)/2) up(cz2) cuboid([cx1, cy2, cz3], anchor=BOTTOM);
    if (yback > 0) {
        back((cy2-yback)/2) cuboid([cx1 + cdx + cx2, yback, cz2 + cz3], anchor=BOTTOM);
    }
    cyl(ch, cr-slop/2, anchor=TOP, $fn=fn);
}

/*
cyl(ch, cr-0.05, anchor=TOP, $fn=fn);
right(10) cyl(ch, cr-0.1, anchor=TOP, $fn=fn);
right(20) cyl(ch, cr-0.15, anchor=TOP, $fn=fn);
right(30) cyl(ch, cr-0.2, anchor=TOP, $fn=fn);
right(40) cyl(ch, cr-0.25, anchor=TOP, $fn=fn);
*/

// microcontroller box

x = 57;
y = 83.5;
z = 50;

dx = 2;
dy = 2;
dz = 2;
tempz = z;

tx = 5;
ty = 15;
tz = 2;

df = 5;
dwt = 0.4; // different dw due to printer orientation and wanting 2 layers either way
dw = 0.8;
zb = 10;

slop = 0.2;

/*
// Clips
left(50) {
    clip(ch=7, cz3=6, cdx=5);
    right(20) clip();
    back(30) right(20) clip(yback=1);
    back(30) clip(yback=1);
}
*/



// Port wall (front)
edy = dy+2*e;
difference() {
    union() {
        left(dx) cuboid([x + 2*dx, dy, z + dz], anchor=BOTTOM+LEFT+BACK);

    }
    back(e) {
        up(9) right((x-25)/2) cuboid([25, edy, 10], anchor=BOTTOM+LEFT+BACK);
        up(35) right(40) cuboid([12, edy, 11], anchor=BOTTOM+LEFT+BACK);
        up(38) right(8) cuboid([8, edy, 4], anchor=BOTTOM+LEFT+BACK);
        up(38) right(24) cuboid([9, edy, 5], anchor=BOTTOM+LEFT+BACK);
    }
}


// back wall
back(y) {
    left(dx) diff()
        cuboid([x + 2*dx, dy, z + dz], anchor=BOTTOM+LEFT+FRONT)
            attach(CENTER)
                fwd(dw) tag("remove") cuboid([x - 2*df, dy, z - 2*df], chamfer=2, edges=BOTTOM+BACK);
    
    
    /*
    right(x/2) {
        cuboid([tx, dy, dz+1], anchor=TOP+FRONT);
        down(dz) cuboid([tx, ty, tz], anchor=TOP+BACK);
    }
    */
}

/*
down(dz+3) right(6) cuboid([4, 4, 12], chamfer=4, edges=TOP+FRONT, anchor=LEFT+BOTTOM+BACK);
down(dz+3) right(x-6) cuboid([4, 4, 12], chamfer=4, edges=TOP+FRONT, anchor=RIGHT+BOTTOM+BACK);
back(y) {
down(dz+3) right(6) cuboid([4, 4, 12], chamfer=4, edges=TOP+BACK, anchor=LEFT+BOTTOM+FRONT);
down(dz+3) right(x-6) cuboid([4, 4, 12], chamfer=4, edges=TOP+BACK, anchor=RIGHT+BOTTOM+FRONT);
}
*/

// top wall with tab holes
etz = 2*e + tz;
ex = e + x;
difference() {
    union() {
        
        up(z) left(dx) 
        
        diff() cuboid([x + 2*dx, y, dz], anchor=BOTTOM+LEFT+FRONT)
                    attach(CENTER)
                down(dwt) tag("remove") cuboid([x - 2*df, y - 2*df, dz]);
        //back(3) up(z-dz) right(x+dx) cuboid([2+tx+dx, 4+ty, tz], anchor=BOTTOM+RIGHT+FRONT);
        //back(y-3) up(z-dz) right(x+dx) cuboid([2+tx+dx, 4+ty, tz], anchor=BOTTOM+RIGHT+BACK);
    }
    //back(5) up(z-e) right(ex+dx) cuboid([tx+1, ty, etz], anchor=BOTTOM+RIGHT+FRONT); // the +1 to be able to insert a screwdriver to pry it apart
    //back(y-5) up(z-e) right(ex+dx) cuboid([tx+1, ty, etz], anchor=BOTTOM+RIGHT+BACK);
}

color("#cc8888") up(zb) {
    diff() cuboid([dx, y, z-zb], anchor=BOTTOM+RIGHT+FRONT) attach(CENTER)
                right(dw) tag("remove") cuboid([dx, y - 2*df, z - zb - 2*df], chamfer=2, edges=BOTTOM+LEFT);
    diff() right(x) cuboid([dx, y, z-zb], anchor=BOTTOM+LEFT+FRONT) attach(CENTER)
                left(dw) tag("remove") cuboid([dx, y - 2*df, z - zb - 2*df], chamfer=2, edges=BOTTOM+RIGHT);
}

color("#cc8888")
right(100) {
    // left wall with clip holes and tab holes
    difference() {
        union() {
            cuboid([dx, y, zb], anchor=BOTTOM+RIGHT+FRONT);
            //up(17) back(y-10) left(dx-1) cyl(chh+e, r1=cr+6, r2=cr+3, $fn=fn, anchor=BOTTOM, orient=RIGHT);
            //up(17) back(10) left(dx-1) cyl(chh+e, r1=cr+6, r2=cr+3, $fn=fn, anchor=BOTTOM, orient=RIGHT);
            //back(3) cuboid([tz, ty+4, tx+2], anchor=BOTTOM+LEFT+FRONT);
            //back(y-3) cuboid([tz, ty+4, tx+2], anchor=BOTTOM+LEFT+BACK);
            //cuboid([tz, y, tx+2], anchor=BOTTOM+LEFT+FRONT);
            
            back((y-ty)/2) {
                left(dx) {
                    down(dz) cuboid([2, ty, z + 3*dz+slop], anchor=BOTTOM+RIGHT+FRONT, chamfer=1, edges=LEFT, except=BOTTOM);
                    up(z+dz+slop) cuboid([tx, ty, tz], anchor=BOTTOM+LEFT+FRONT, chamfer=1, edges=RIGHT+TOP);
                }
                right(x+dx) {
                    down(dz) cuboid([2, ty, z + 3*dz+slop], anchor=BOTTOM+LEFT+FRONT, chamfer=1, edges=RIGHT, except=BOTTOM);
                    up(z+dz+slop) cuboid([tx, ty, tz], anchor=BOTTOM+RIGHT+FRONT, chamfer=1, edges=LEFT+TOP);
                }
            }
            
            up(7)                  prismoid(size1=[0, 10], size2=[chh, 10], shift=[ chh/2, 0], h=5, anchor=BOTTOM+FRONT+LEFT);
            up(7) back(y)          prismoid(size1=[0, 10], size2=[chh, 10], shift=[ chh/2, 0], h=5, anchor=BOTTOM+BACK+ LEFT);
            up(7)         right(x) prismoid(size1=[0, 10], size2=[chh, 10], shift=[-chh/2, 0], h=5, anchor=BOTTOM+FRONT+LEFT);
            up(7) back(y) right(x) prismoid(size1=[0, 10], size2=[chh, 10], shift=[-chh/2, 0], h=5, anchor=BOTTOM+BACK+ LEFT);
            //up(z)                  prismoid(size1=[0, 10], size2=[chh, 10], shift=[ chh/2, 0], h=4, anchor=TOP+   FRONT+LEFT);
            //up(z) back(y)          prismoid(size1=[0, 10], size2=[chh, 10], shift=[ chh/2, 0], h=4, anchor=TOP+   BACK+ LEFT);
            //up(z)         right(x) prismoid(size1=[0, 10], size2=[chh, 10], shift=[-chh/2, 0], h=4, anchor=TOP+   FRONT+RIGHT);
            //up(z) back(y) right(x) prismoid(size1=[0, 10], size2=[chh, 10], shift=[-chh/2, 0], h=4, anchor=TOP+   BACK+ RIGHT);
        }
        //up(17) back(35) left(dx-1-e) cyl(chh+e, cr, $fn=fn, anchor=BOTTOM, orient=RIGHT);
        //up(17) back(5) left(dx-1-e) cyl(chh+e, cr, $fn=fn, anchor=BOTTOM, orient=RIGHT);
        //fwd(e) cuboid([10, 10, z], anchor=BACK+BOTTOM);
        //up(11) cuboid([chh+1, y, 2*cr+12], anchor=BOTTOM+LEFT+FRONT);
        
        //back(5) right(e) down(e) cuboid([etz, ty, tx], anchor=BOTTOM+RIGHT+FRONT);
        //back(y-5) right(e) down(e) cuboid([etz, ty, tx], anchor=BOTTOM+RIGHT+BACK);
    }
    
    // right wall with clip holes and tabs
    right(x)
    difference() {
        union() {
            cuboid([dx, y, zb], anchor=BOTTOM+LEFT+FRONT); // right wall
            //up(17) back(y-10) right(dx-1) cyl(chh+e, r1=cr+6, r2=cr+3, $fn=fn, anchor=BOTTOM, orient=LEFT);
            //up(17) back(10) right(dx-1) cyl(chh+e, r1=cr+6, r2=cr+3, $fn=fn, anchor=BOTTOM, orient=LEFT);
            // tabs
            //back(5) up(z) right(dx) cuboid([tx+dx, ty, tz], anchor=BOTTOM+RIGHT+FRONT);
            //back(y-5) up(z) right(dx) cuboid([tx+dx, ty, tz], anchor=BOTTOM+RIGHT+BACK);
        }
        //up(17) back(35) right(dx-1-e) cyl(chh+e, cr, $fn=fn, anchor=BOTTOM, orient=LEFT);
        //up(17) back(5) right(dx-1-e) cyl(chh+e, cr, $fn=fn, anchor=BOTTOM, orient=LEFT);
        //fwd(e) cuboid([10, 10, z], anchor=BACK+BOTTOM);
        //up(11) cuboid([chh+1, y, 2*cr+12], anchor=BOTTOM+RIGHT+FRONT);
    }
    
    etx = 2*e + tx;
    ety = 2*e + ty;
    edz = 2*e + dz;
    // bottom floor with tabs - thicker to discourage bending - nah, not necessary
    difference() {
        left(dx) fwd(dy) cuboid([x+2*dx, y+2*dy, dz], anchor=TOP+FRONT+LEFT);
        /*
        down(e) {
            slop = 0.2;
            down(dz+3) right(6) cuboid([4+slop, 4+slop, 12], chamfer=4, edges=TOP+FRONT, anchor=LEFT+BOTTOM+BACK);
            down(dz+3) right(x-6) cuboid([4+slop, 4+slop, 12], chamfer=4, edges=TOP+FRONT, anchor=RIGHT+BOTTOM+BACK);
            back(y) {
            down(dz+3) right(6) cuboid([4+slop, 4+slop, 12], chamfer=4, edges=TOP+BACK, anchor=LEFT+BOTTOM+FRONT);
            down(dz+3) right(x-6) cuboid([4+slop, 4+slop, 12], chamfer=4, edges=TOP+BACK, anchor=RIGHT+BOTTOM+FRONT);
            }
        }
        */
        /*
        right(x/2) {
            fwd(e) up(e) cuboid([etx, edy, edz+1], anchor=TOP+BACK);
            fwd(2*e) down(dz-0.5) cuboid([etx, ety+1, etz+0.5], anchor=TOP+FRONT); // the +1 to be able to insert a screwdriver to pry it apart
            back(y) {
                fwd(e) up(e) cuboid([etx, edy, edz+1], anchor=TOP+FRONT);
                back(2*e) down(dz-0.5) cuboid([etx, ety+1, etz+0.5], anchor=TOP+BACK);
            }
        }
        */
    //back(5) cuboid([tz, ty, tx], anchor=BOTTOM+RIGHT+FRONT);
    //back(y-5) cuboid([tz, ty, tx], anchor=BOTTOM+RIGHT+BACK);
    }
}



