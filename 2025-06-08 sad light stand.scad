include <BOSL2/std.scad>
include <BOSL2/shapes3d.scad>
include <BOSL2/joiners.scad>

xb = 15;
ro = 55/2;
ri = 36/2;
e = 0.01;
// first: 35/2
fn = 72;


difference() {
    union() {
        cuboid([2*ro + xb, 2*ro, 10]);
    }

    cyl(l=200, r=ri, $fn=fn);
    cuboid([50, 2*ri, 50], anchor=LEFT);
    right(ro+e) cuboid([xb/2, 2*ro+2*e, 50], anchor=LEFT);
}

tilt_compensation=3; // angle to adjust joiner by to compensate for the weight tilting the thing downwards

left(ro + xb/2)
union() {
    difference() {
        cuboid([20, 55, 30], anchor=RIGHT);
        left(20) yrot(tilt_compensation) union() {
            half_joiner_clear(l=40, w=15, orient=LEFT);
            cuboid([10, 40, 15], anchor=RIGHT);
        }
    }
    left(20) yrot(tilt_compensation) half_joiner2(l=40, w=15, orient=LEFT);
}


up(50)
difference() {
    union() {
        cuboid([2*ro + xb, 2*ro, 30]);
    }

    cyl(l=200, r=ri, $fn=fn);
    cuboid([50, 2*ri, 50], anchor=RIGHT);
    right(8) cuboid([2*ro + xb, 2*ro+2*e, 10], anchor=RIGHT);
    
    fwd((ro+ri)/2) left(e) cuboid([ro, ro-ri+2*e, 10+2*e], anchor=LEFT);
    back((ro+ri)/2) left(e) cuboid([ro, ro-ri+2*e, 10+2*e], anchor=LEFT);
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