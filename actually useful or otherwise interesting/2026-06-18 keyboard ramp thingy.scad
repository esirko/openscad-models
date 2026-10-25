include <BOSL2/std.scad>

e = 0.01;

fn = 180;

x1 = 131;
sh = 37;

x2 = 61; // if you have to print ortho-aligned, 45. If you can print at a diagonal, 61

y0 = 30;
z0 = 30;

y1 = 75;
y2 = 90;
z1 = 12;

tz = 2;
tx = 2;

y3 = 10;

lsx = 3;
lxsr = 5;
hx = 36;
hz = 19;
hz2 = 28;

tex = 3;
sy = 56;

buf1 = 1;
buf2 = 2;
buf10 = 10;

// inner-boundary points in the y-z plane, in sequence as [y, z]
inner = [ [y3, sh], [0, sh], [-y0, z0], [-y1, z1], [-y2, 0], [-y2-buf10, -buf10] ];

// outer boundary: offset the open inner path outward by the thickness
outer = offset(inner, delta=-tz, closed=false);

// closed cross-section = inner edge + reversed outer edge
section = concat(inner, reverse(outer));

huge_upper_void = concat(outer, [[-110, 0], [-110, 100], [y3, 100]]);

//difference() { union() {

// polygon/linear_extrude live in the xy-plane and extrude along z. 
// A 120° rotation about [1,1,1] cyclically maps the axes (x→y, y→z, z→x)
difference() {
    union() {
        left(x2) rotate(120, [1,1,1]) linear_sweep(section, height=x1+x2+tx);
        color("blue") right(hx) cuboid([lsx, 10, sh], anchor=LEFT+BOTTOM+BACK);
        color("blue") right(x1-lxsr) cuboid([lxsr, 10, sh], anchor=LEFT+BOTTOM+BACK);
        color("darkblue") right(hx) fwd(10) cuboid([10, 11, 2], anchor=LEFT+BOTTOM+FRONT);
        color("darkblue") right(hx) cuboid([10, 10, 7], anchor=LEFT+BOTTOM+BACK);
        color("lightblue") right(x1) back(y3) cuboid([tx, y2+y3+buf10, sh], anchor=LEFT+BOTTOM+BACK);
        color("lightgreen") up(hz) back(y3) cuboid([tx, y2+y3+buf10, sh-hz], anchor=RIGHT+BOTTOM+BACK);
        /*
        color("green") left(tex+tx) up(hz) back(y3) difference() {
            cuboid([tx, y2+y3+buf10, sh-hz], anchor=RIGHT+BOTTOM+BACK);
            up(6) left(e) fwd(10) cuboid([tx+2*e, 10, 7], anchor=RIGHT+BOTTOM+BACK);
        }
        */
        color("lightgreen") up(hz2) back(y3) left(x2-tx) cuboid([tx, y2+y3+buf10, sh-hz2], anchor=RIGHT+BOTTOM+BACK);
        //color("red") fwd(68) prismoid(size1=[x2, 4], size2=[x2, 10], h=20, shift=[0,-3], anchor=RIGHT+BOTTOM+BACK);
        //color("red") fwd(68) xrot(90) prismoid(size1=[x2, 6], size2=[x2, 1], h=10, shift=[0,-2.5], anchor=RIGHT+BOTTOM+FRONT);
        
        //color("red") fwd(y2-10) xrot(90) prismoid(size1=[x2, 2], size2=[x2, 6], h=10, shift=[0,2], anchor=RIGHT+BOTTOM+FRONT);
        
    }
    up(5) right(e) cuboid([hx-2*e, 40, 40], anchor=BOTTOM+LEFT+BACK);
    down(e) left(x2+buf1) rotate(120, [1,1,1]) linear_sweep(huge_upper_void, height=x1+x2+tx+buf2);
    left(x2+buf1) cuboid([x1+x2+tx+buf2, 110, 100], anchor=LEFT+TOP+BACK);
}

intersection() {
    left(x2) back(y3) down(41.75) rotate(120, [1, 1, 1]) cyl(r=100, h=5, $fn=fn, anchor=BOTTOM);
    down(e) left(x2+buf1) rotate(120, [1,1,1]) linear_sweep(huge_upper_void, height=x1+x2+tx+buf2);
}


//}
//left(26) fwd(12) down(e) cuboid([200, 200, 100], anchor=LEFT+BOTTOM+BACK);
//right(50) back(30) down(e) cuboid([200, 200, 100], anchor=LEFT+BOTTOM+BACK);
//up(40) back(11) cuboid([200, 200, 100], anchor=RIGHT+BOTTOM+BACK);
//}


//Clip to back side
/*
void_for_key = concat(inner, [[-100, 100], [-10, 100]]);
slop = 0.1;

back(30)
color("cyan") {
    difference() {
        union() {
            left(tex+0.6) up(hz) back(y3) up(6) left(e) fwd(10) // matching translations above of the hole
                cuboid([tx+2*e, 10-slop, 7-slop], anchor=RIGHT+BOTTOM+BACK);

            up(sh) {
                left(tx) fwd(10) cuboid([tex-slop, 30, sh-hz], anchor=RIGHT+TOP+FRONT);
                back(y3) cuboid([tex+tx-slop, sy-y3, 8], anchor=RIGHT+TOP+FRONT);
                back(sy) right(5) cuboid([tex+tx-slop+5, 5, 15], anchor=RIGHT+TOP+FRONT);
            }
        }
        
        left(x2) rotate(120, [1,1,1]) linear_sweep(void_for_key, height=x1+x2+tx);
    }
}
*/

clip_w = 30;
clip_z3 = 8;
clip_y1 = 20;
clip_y2 = 5+clip_y1;
clip_y3 = 10+clip_y2;
clip_y4 = 10+clip_y3;
clip_y5 = 5+clip_y4;

module clip_key_part(slop=0.0) {
    z1 = 2;
    z2 = 5;
    dz = 0.4;
    dy = 4;
    dt = 1;
    translate([-clip_y3+slop, 0, z1]) prismoid(size1=[clip_w, z2-z1-slop], size2=[clip_w, 0], h=dt, orient=LEFT, spin=90, anchor=BOTTOM+BACK);
    translate([-clip_y3+slop, 0, z1]) cuboid([clip_y3-clip_y1, clip_w, z2-z1-slop], anchor=LEFT+BOTTOM);
    translate([-clip_y3+slop, 0, z2-slop]) prismoid(size1=[clip_w, dy], size2=[clip_w, dy-0.5], h=dz, spin=90, anchor=BACK+BOTTOM);
}

module clip_key_male() {
    shiftmatch = 10; // adjust this based on eyeballing intersection with main part
    clip_key_part(slop=0.2);
    right(0.5) prismoid(size1=[clip_w, clip_y1], size2=[clip_w, clip_y2-shiftmatch], shift=[0, (clip_y2-clip_y1)/2 + shiftmatch/2], h=clip_z3, spin=90, anchor=FRONT+BOTTOM);
}

module clip_key_female() {
    difference() {
        // Let clip_y5-clip_y4 == clip_y2-clip_y1 so the trapezoid is symmetrical and I don't have to worry about shift
        left(clip_y1) prismoid(size1=[clip_w, clip_y5-clip_y1], size2=[clip_w, clip_y4-clip_y2], h=clip_z3, spin=90, anchor=FRONT+BOTTOM);
        clip_key_part();
    }
    
}
color("red")
translate([70, -91, 1]) zrot(-90) clip_key_male();
zrot(-90) clip_key_female();





