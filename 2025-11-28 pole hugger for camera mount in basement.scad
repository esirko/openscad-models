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
            // This is a boxy interface to the payload, not sure how I want to generalize it yet
            fwd(r+2) cuboid([2*r+t, r, h], rounding=rounding, edges="Y", $fn=fn, anchor=BACK);
            fwd(2*r+2-e) 
            difference() {
                diff() cuboid([2*r+t, 30, h/2], rounding=rounding, edges=["Y", FRONT], $fn=fn, anchor=BACK+TOP) {
                    tag("remove") position(TOP+BACK) fwd(8) xrot(-20) cyl(r=pinr, h=30+1, $fn=fn);
                    tag("remove") position(TOP+BACK) fwd(25) xrot(20) cyl(r=pinr, h=30+1, $fn=fn);
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
hr = 13;
ht = 12;


back(100) pole_hugger(r=hr, t=ht, h=hh, pinr=rpin);
back(100) left(50) pin(r1=rpin, h1=hh+2, r2=6, h2=2, slop=0.2, cutback_fudge=0.15);
back(120) left(50) pin(r1=rpin, h1=hh+2, r2=6, h2=2, slop=0.2, cutback_fudge=0.15);
back(140) left(50) pin(r1=rpin, h1=hh+5+ 2, r2=6, h2=2, slop=0.2, cutback_fudge=0.15);
back(160) left(50) pin(r1=rpin, h1=hh+5+ 2, r2=6, h2=2, slop=0.2, cutback_fudge=0.15);


// payload
diff() cuboid([2*hr+ht, 30, hh/2], rounding=1, edges="Y", $fn=fn, anchor=FRONT+BOTTOM) {
    tag("remove") position(BOTTOM+BACK) fwd(8) xrot(-20) cyl(r=rpin, h=30+1, $fn=fn);
    tag("remove") position(BOTTOM+BACK) fwd(25) xrot(20) cyl(r=rpin, h=30+1, $fn=fn);
}


back(e) diff() cuboid([2*hr+ht, 120, 10], rounding=1, except=BACK, $fn=fn, anchor=BACK+BOTTOM)
    tag("remove") position(BOTTOM+BACK) back(5) xrot(20) cyl(r=rpin, h=30+1, $fn=fn); // have to do this hack because my pin locations are not compatible with a short payload block, so next time make the payload block a bit bigger (or the holes closer together)
up(10) fwd(120) cuboid([2*hr, 20, 65], rounding=1, edges="Z", $fn=fn, anchor=FRONT+BOTTOM);
up(10) fwd(100) cuboid([2, 50, 65], anchor=FRONT+BOTTOM);
up(75-e) fwd(80) difference() {
    cuboid([80, 80, 15], anchor=BOTTOM);
    back(2) up(2) cuboid([76, 80, 20], anchor=BOTTOM);
}

/*
fwd(35) {
    difference() {
        cyl(r=30, h=1, anchor=BOTTOM);
        //down(e) cyl(r=25, h=1+1, anchor=BOTTOM);
    }
    
    difference() {
        cyl(r=30, h=9, anchor=BOTTOM);
        down(e) cyl(r=28.75, h=9+1, anchor=BOTTOM);
        fwd(30) cuboid([12, 10, 10], anchor=BOTTOM);
    }
}
*/
