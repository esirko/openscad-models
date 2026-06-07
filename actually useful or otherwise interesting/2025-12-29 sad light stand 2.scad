include <BOSL2/std.scad>

e = 0.01;
fn = 36;

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

// The pin holes go right by an amount that splits the difference... It must be at least the pin's radius (2) but has to be 
// less than what would cause the right edge of the hole on the main piece to go past h/2, so h/2-r (20/3-2 = 8).

module pole_hugger(r=10, t=10, h=20, pinr=3, rounding=1) {

    pinscoot = ((h/2-pinr) + pinr)/2;
    
    difference() {
        union() {
            cyl(r=r+t, h=h, rounding=rounding, $fn=fn);
            fwd(2*r+2-e) 
            difference() {
                diff() cuboid([2*r+t, 40, h/2], rounding=rounding, edges=["Y", FRONT], $fn=fn, anchor=BACK+TOP) {
                    position(BACK+BOTTOM) fwd(-r+e) cuboid([2*r+t, r, h], rounding=rounding, edges="Y", $fn=fn, anchor=BACK+BOTTOM);
                    tag("remove") position(TOP+BACK) fwd(11) xrot(-30) cyl(r=rpin, h=30+1, $fn=fn);
                    tag("remove") position(TOP+BACK) fwd(35) left(14) yrot(30) cyl(r=rpin, h=30+1, $fn=fn);
                    tag("remove") position(TOP+BACK) fwd(35) right(14) yrot(-30) cyl(r=rpin, h=30+1, $fn=fn);
                }
            }
        }
        cyl(r=r, h=h+2*e, $fn=fn);
        cuboid([r+t+e, 2*r, h+2*e], anchor=LEFT);
        down(r+t) right(r+t) prismoid(size1=[2*(r+t), 2*(r+t)], size2=[2*(r+t), 0], shift=[0, 0], h=r+t, anchor=BOTTOM+BACK, orient=LEFT, spin=90);
        right(pinscoot) fwd(r+t/2) cyl(r=pinr,h=32, $fn=fn);
        right(pinscoot) back(r+t/2) cyl(r=pinr,h=32, $fn=fn);
    }
    
    right(2*(r+t)+1) {
        intersection() {
            difference() {
                union() {
                    cyl(r=r+t, h=h, rounding=rounding, $fn=fn);
                    fwd(r+2) cuboid([2*r+t, r, h], rounding=rounding, edges="Y", $fn=fn, anchor=BACK);
                }
                cyl(r=r, h=h+2*e, $fn=fn);
                cuboid([r+t+e, 2*r, h+2*e], anchor=RIGHT);
                right(pinscoot)  fwd(r+t/2) cyl(r=pinr,h=32, $fn=fn);
                right(pinscoot)  back(r+t/2) cyl(r=pinr,h=32, $fn=fn);
            }
            color("red") down(r+t) right(r+t) prismoid(size1=[2*(r+t), 2*(r+t)], size2=[2*(r+t), 0], shift=[0, 0], h=r+t, anchor=BOTTOM+BACK, orient=LEFT, spin=90);
        }
    }
}

rpin = 3;
hh = 20;
hr = 18;
ht = 12;

back(100) {
    back(100) pole_hugger(r=hr, t=ht, h=hh, pinr=rpin);
    back(100) left(50) pin(r1=rpin, h1=hh+2, r2=6, h2=2, slop=0.2, cutback_fudge=0.15);
    back(120) left(50) pin(r1=rpin, h1=hh+2, r2=6, h2=2, slop=0.2, cutback_fudge=0.15);
    back(140) left(50) pin(r1=rpin, h1=hh+5+ 2, r2=6, h2=2, slop=0.2, cutback_fudge=0.15);
    back(160) left(50) pin(r1=rpin, h1=hh+5+ 2, r2=6, h2=2, slop=0.2, cutback_fudge=0.15);
    back(180) left(50) pin(r1=rpin, h1=hh+5+ 2, r2=6, h2=2, slop=0.2, cutback_fudge=0.15);
}


// payload
zrot(-90)
diff() cuboid([2*hr+ht, 40, hh/2], rounding=1, edges="Y", $fn=fn, anchor=FRONT+BOTTOM+LEFT) {
    tag("remove") position(BOTTOM+BACK) fwd(11) xrot(-30) cyl(r=rpin, h=30+1, $fn=fn);
    tag("remove") position(BOTTOM+BACK) fwd(35) left(14) yrot(30) cyl(r=rpin, h=30+1, $fn=fn);
    tag("remove") position(BOTTOM+BACK) fwd(35) right(14) yrot(-30) cyl(r=rpin, h=30+1, $fn=fn);
}

bt = 18; // back thickness
ft = 3; // floor thickness
xrot(30) fwd(75) up(ft)
xrot(-90) {
left(80)
difference() {
    back(ft) prismoid(size1=[160, 42], size2=[90, 12], shift=[0, (42-12)/2], h=98, anchor=BACK+BOTTOM);
    color("pink") up(10) fwd(e) prismoid(size1=[130, 32.5], size2=[70, 9.5], shift=[0,(32.5-9.5)/2], h=78, anchor=BACK+BOTTOM);
    color("purple") up(50) cuboid([20, 50, 100], anchor=BACK+BOTTOM);
    color("orange") up(78+10-3) back(25) cuboid([20, 50, 100], anchor=BACK+BOTTOM);
    color("blue") intersection() {
        up(10) down(e) cuboid([130, bt-ft+e, 20], anchor=BACK+BOTTOM);
        //up(210) yrot(135) pie_slice(ang=90, r=200, h=20, $fn=fn, orient=FWD);
    }
    color("green") up(20) back(ft+e) prismoid(size1=[90, 10], size2=[50, 10], h=58, anchor=BACK+BOTTOM);
    fwd(7+e) down(e) cuboid([170, 50, 75], anchor=BACK+BOTTOM);
}

difference() {
    left(80) up(404) diff() yrot(90+20/2) pie_slice(ang=20, r=401, h=20, $fn=180, orient=FWD)
        position(BOTTOM) tag("remove") down(e) zrot(-e) pie_slice(ang=91, r=395, h=21, $fn=180, anchor=BOTTOM);
    left(80) down(5) back(e) cuboid([50, 21, 20], anchor=BACK+BOTTOM);
}


color("yellow") back(ft) prismoid(size1=[0,10], size2=[30, 10], h=80, shift=[-15, 0], anchor=BACK+BOTTOM);
}

color("green")
skin([up(10, yrot(-90, p=path3d(trapezoid(w1=30, w2=10, shift=10, h=2*hr+ht, anchor=BACK+RIGHT)))), 
    left(25, up(5, yrot(-90, p=path3d(trapezoid(w1=1, w2=1, shift=20, h=35, anchor=BACK+RIGHT)))))], 
     slices=20);



