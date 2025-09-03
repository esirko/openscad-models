include <BOSL2/std.scad>
include <BOSL2/shapes3d.scad>
include <BOSL2/joiners.scad>

xb = 5;
yb = 10;
ro = 55/2;
ri = 36/2;
e = 0.01;
// first: 35/2
fn = 72;
$slop=0.2;

tilt_compensation=10; // angle to adjust joiner by to compensate for the weight tilting the thing downwards
dx = tan(tilt_compensation) * 15;
tip_compensation=15; // angle to tip the platform forwards

difference() {
    union() {
        difference() {
            union() {
                yrot(90) zrot(90) down(ro+xb/2) prismoid(size1=[2*(ro+yb), 10], size2=[2*ro, 10], height=2*ro+xb);
            }

            cyl(l=200, r=ri, $fn=fn);
            cuboid([50, 2*ri, 50], anchor=LEFT);
            right(8) cuboid([ro+xb, 2*(ro+yb), 11], anchor=LEFT);
            right(ro+e) cuboid([xb/2, 2*ro+2*e, 50], anchor=LEFT);
        }

        left(ro+yb/2+5)
        union() {
            cuboid([15, 50, 25], rounding=2, $fn=fn, edges="X");
            right(12) cuboid([xb+(ro-ri), 2*ri, 20]);
            
            left(10)
            xrot(tip_compensation) yrot(tilt_compensation) 
            union() {
                difference() {
                    cuboid([15, 46, 21], rounding=2, $fn=fn, edges="X");
                    left(7.5) half_joiner_clear(l=40, w=15, orient=LEFT);
                }
                left(7.5) half_joiner2(l=40, w=15, orient=LEFT);
            }
        }

        up(41)
        union() {
            difference() {
                union() {
                    yrot(90) zrot(90) down(ro+xb/2) prismoid(size1=[2*(ro+yb), 30], size2=[2*ro, 30], height=2*ro+xb, rounding=3, $fn=fn);
                }

                cyl(l=200, r=ri, $fn=fn);
                cuboid([70, 2*ri, 50], anchor=RIGHT);
                right(8) cuboid([2*ro + xb, 2*ro+2*yb+2*e, 10], anchor=RIGHT);
            }
        }
    }

    fwd(26) left(22) cyl(r=3, height=200);
    back(26) left(22) cyl(r=3, height=200);
}

right(50)
xcopies(20, 2)
union() {
    cyl(r=3-$slop, height=35, anchor=TOP);
    cyl(r=5, height=2, anchor=TOP);
    down(35) cyl(r1=1, r2=3-$slop, height=3, anchor=TOP);
    
}


back(100) 
union() {
    difference() {
        prismoid(size1=[160, 10], size2=[90, 10], h=98, anchor=FRONT+RIGHT+BOTTOM);
        left(15) up(10) fwd(e) prismoid(size1=[130, 7], size2=[70, 7], h=78, anchor=FRONT+RIGHT+BOTTOM);
        left(70) up(88-e) fwd(e) cuboid([20, 7, 10+2*e], anchor=FRONT+RIGHT+BOTTOM);
        left(15) up(10) fwd(e) cuboid([130, 7, 20], anchor=FRONT+RIGHT+BOTTOM);
        left(35) up(20) back(e) prismoid(size1=[90, 10], size2=[50, 10], h=58, anchor=FRONT+RIGHT+BOTTOM);
    }
    

    prismoid(size1=[0,10], size2=[30, 10], h=80, shift=[-15, 0], anchor=FRONT+RIGHT+BOTTOM);

    yrot(-90) xrot(180)
    union() {
        difference() {
            prismoid(size1=[80,10], size2=[55,25], h=30, shift=[0, 7.5], anchor=BACK+LEFT+BOTTOM);
            fwd(-2.5) right(40) up(30) half_joiner_clear(l=40, w=15, spin=90);
        }
        fwd(-2.5) right(40) up(30) half_joiner(l=40, w=15, spin=90);
    }
}