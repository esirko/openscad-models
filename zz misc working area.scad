include <BOSL2/std.scad>
include <BOSL2/walls.scad>

// pre-defined
t = 4;
w = 80;
d = 100;
h3 = 90;
it=27;
e = 0.05;

// new vars
theta = 30;
wt = 5;
ww =  w+2*it+4*t; // 150
dd = d+it+2*t; // 135
dd_extension = 35; // the extension of the front attachment
hh = h3+t; // 94
x3_extension = 45;
x2_extension = 0;
x_partition = 67;
xt_partition = 16;
x4 = 101;
z0 = 8;
st = 3;
grt = 5;
rpin = 3;
fn=36;
st2 = 4;

// fudges
f3 = 3;
f5 = 5;
f7 = 7;
f10 = 10;
f20 = 20;

x1 = dd*cos(theta);
x2 = (dd+dd_extension)*cos(theta);
x3 = hh*cos(90-theta);

z1 = dd*sin(theta);
z2 = (dd+dd_extension)*sin(theta);
z3 = hh*sin(90-theta);

dd_partition = x_partition/cos(theta);
corresponding_z_for_partition = dd_partition*sin(theta);
corresponding_x_left_for_partition = corresponding_z_for_partition*corresponding_z_for_partition/x_partition;



partition(size=[360, ww+2*wt, 200], spin=90, $slop=0.1)
fwd(ww/2+wt-f5/2) left(x_partition+xt_partition/2) 
{
    color("red") {
        yrot(-theta) down(st) sparse_wall(h=hh+st, l=ww, thick=st, strut=4, max_bridge=40, maxang=45, anchor=RIGHT+BOTTOM+FRONT);
        yrot(90-theta) down(st) sparse_wall(h=dd_partition+2*st, l=ww, thick=st, strut=4, max_bridge=40, maxang=45, anchor=LEFT+BOTTOM+FRONT);
        yrot(90-theta) up(dd_partition+xt_partition) down(st) sparse_wall(h=(dd+dd_extension-dd_partition-xt_partition)+st, l=ww, thick=st, strut=4, max_bridge=40, maxang=45, anchor=LEFT+BOTTOM+FRONT);

        right(x_partition) down(z0) cuboid([xt_partition, ww, corresponding_z_for_partition+z0], anchor=LEFT+BOTTOM+FRONT);
        right(x_partition) up(corresponding_z_for_partition) prismoid(size1=[xt_partition, ww], size2=[0, ww], shift=[xt_partition/2, 0], h=xt_partition*tan(theta), anchor=LEFT+BOTTOM+FRONT);
    }

    color("blue") {
        right(x2+x2_extension+st2) yrot(atan2(z2, x2_extension)-90) down(st2) sparse_wall(h=sqrt(x2_extension*x2_extension+z2*z2)+st2, l=ww, thick=st2, anchor=RIGHT+BOTTOM+FRONT, strut=7, max_bridge=40);
        difference() {
            left(x3+x3_extension) yrot(90-atan2(z3, x3_extension)) down(f5) sparse_cuboid([st2, ww, sqrt(x3_extension*x3_extension+z3*z3)+f5], anchor=RIGHT+BOTTOM+FRONT, strut=7, max_bridge=40);
            down(5) left(98) cuboid([10, ww, 10], anchor=RIGHT+BOTTOM+FRONT);
        }
    }
    
    color("lightblue")
    fwd(wt) left(corresponding_x_left_for_partition + f5) up(corresponding_z_for_partition+f20/2) {
        cuboid([x_partition + corresponding_x_left_for_partition + 2*grt, wt, f20], anchor=LEFT+FRONT+TOP, chamfer=2, edges=[FRONT,TOP]);
        back(ww+wt) cuboid([x_partition + corresponding_x_left_for_partition + 2*grt, wt, f20], anchor=LEFT+FRONT+TOP, chamfer=2, edges=[BACK,TOP]);
    }
    
    color("lightblue") cuboid([f10, ww, z0], anchor=TOP+FRONT);
    color("pink") left(f7) fwd(f5) left(x3+x3_extension) sparse_cuboid([x3_extension+x3+x2+x2_extension+f7, ww+2*f5, z0], "Z", strut=10, max_bridge=100, anchor=LEFT+TOP+FRONT, rounding=2, except=RIGHT);

    color("lightgreen") right(x2+x2_extension) {
        fwd(f5) diff() cuboid([x4, ww+2*f5, z0], anchor=LEFT+TOP+FRONT, rounding=2, except=LEFT)
            tag("remove") cuboid([x4-20, ww, z0+2*e]);
        down(z0) right(st2) {
            diff() cuboid([x4-st2-2, 20, 15], anchor=LEFT+BOTTOM+FRONT) position(TOP) {
                tag("remove") left(25) yrot(-30) cyl(r=rpin, h=50, $fn=fn);
                tag("remove") right(30) yrot(30) cyl(r=rpin, h=50, $fn=fn);
            }
            back((ww-20)/2) diff() cuboid([x4-st2-2, 20, 15], anchor=LEFT+BOTTOM+FRONT) position(TOP) {
                tag("remove") left(25) yrot(-30) cyl(r=rpin, h=50, $fn=fn);
                tag("remove") right(30) yrot(30) cyl(r=rpin, h=50, $fn=fn);
            }
            back(ww-20) diff() cuboid([x4-st2-2, 20, 15], anchor=LEFT+BOTTOM+FRONT) position(TOP) {
                tag("remove") left(25) yrot(-30) cyl(r=rpin, h=50, $fn=fn);
                tag("remove") right(30) yrot(30) cyl(r=rpin, h=50, $fn=fn);
            }
        }
    }
}

right(300) {
    right(25) up(10-4) cuboid([40, ww, 4], anchor=LEFT+BOTTOM+FRONT, rounding=2, edges=TOP);
    
    diff() cuboid([x4-st2-2, 20, 10], anchor=LEFT+BOTTOM+FRONT, rounding=2, edges=TOP+RIGHT+FRONT) position(BOTTOM) {
        tag("remove") left(25) yrot(-30) cyl(r=rpin, h=50, $fn=fn);
        tag("remove") right(30) yrot(30) cyl(r=rpin, h=50, $fn=fn);
    }
    
    back((ww-20)/2) diff() cuboid([x4-st2-2, 20, 10], anchor=LEFT+BOTTOM+FRONT, rounding=2, edges=TOP+RIGHT) position(BOTTOM) {
        tag("remove") left(25) yrot(-30) cyl(r=rpin, h=50, $fn=fn);
        tag("remove") right(30) yrot(30) cyl(r=rpin, h=50, $fn=fn);
    }
    
    back(ww-20) diff() cuboid([x4-st2-2, 20, 10], anchor=LEFT+BOTTOM+FRONT, rounding=2, edges=TOP+RIGHT+BACK) position(BOTTOM) {
        tag("remove") left(25) yrot(-30) cyl(r=rpin, h=50, $fn=fn);
        tag("remove") right(30) yrot(30) cyl(r=rpin, h=50, $fn=fn);
    }
    
    fwd(50) {
        pin(r1=rpin, h1=28, r2=6, h2=2, slop=0.2, cutback_fudge=0.15);
        right(20) pin(r1=rpin, h1=28, r2=6, h2=2, slop=0.2, cutback_fudge=0.15);
    }
}

module pin(r1=3, h1=20, r2=6, h2=2, slop=0.1, cutback_fudge=0.15) {
    // cutback_fudge should be adjusted so that the entire edge face of the screw is cut just slightly, so that it can print flat. It will depend on $fn (in theory, possible to calculate, but may not be worth it)
    difference() {
        union() {
            cyl(r=r1-slop, rounding1=1, height=h1, $fn=fn, anchor=TOP);
            cyl(r=r2, height=h2, $fn=fn, anchor=BOTTOM);
        }
        fwd(r1-slop-cutback_fudge) down(h1+e) cuboid([2*r2+2*e, r2-(r1-slop)+cutback_fudge, h2+h1+2*e], anchor=BOTTOM+BACK);
    }
}





/*
back(200)
{   
    difference() {
        down(z0) union() {
            left(x3) sparse_cuboid([x3, ww, z2+z0], "Z", strut=5, anchor=LEFT+FRONT+BOTTOM);
            sparse_cuboid([x_partition, ww, z2+z0], "Z", strut=5, anchor=LEFT+FRONT+BOTTOM);
            right(x_partition) sparse_cuboid([x2-x_partition, ww, z2+z0], "Z", strut=5, anchor=LEFT+FRONT+BOTTOM);
        }
        yrot(-theta) cuboid([dd+dd_extension, ww, hh], anchor=LEFT+FRONT+BOTTOM);
        left(x3+x3_extension) yrot(90-atan2(z3, x3_extension)) cuboid([sqrt(x3_extension*x3_extension+z3*z3), ww, 100], anchor=RIGHT+FRONT+BOTTOM);
    }
}
*/



