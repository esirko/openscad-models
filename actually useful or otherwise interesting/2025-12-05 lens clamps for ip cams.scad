include <BOSL2/std.scad>

e = 0.01;
t = 1;
fn = 72;
tabx = 6;
b = 6;
rlens = 27.5;
roverhang = 5;
slop=0.2;
tb=3;
    
/*
module lens_clamp_v1(r=30.75, h=38.5, hl=7.5) {
    // r and h are dimensions of the camera cylinder of the tapo, hl is the extension of the lens
    difference() {
        cyl(r=r+t, h=h+hl+2*t, $fn=fn);
        cyl(r=r, h=h+hl, $fn=fn);
        d = r+t-10;
        back(d) left(d) cuboid([r+t, r+t, h+hl+2*t+1]);
        back(-d) left(d+b) cuboid([r+t, r+t, h+hl+2*t+1]);
        back(d) left(-d) cuboid([r+t, r+t, h+hl+2*t+1]);
        back(-d+b/2) left(-d-b) cuboid([r+t, r+t-b, h+hl+2*t+1]);
        up((h+hl+2*t)/2 - t/2) cyl(r=r-tabx, h=t+1, $fn=fn);
        
        up(t+1) {
            difference() {
                cyl(r=r, h=h+hl, $fn=fn);
                back(15) cuboid([2*(r+t), 2*(r+t), 100]);
            }
        }
        fwd(r+t) up(h-1) cuboid([40, 20, 20], anchor=TOP);
    }
}

module notch(r) {
    difference() {
        pie_slice(r=r+5, h=10, $fn=fn, ang=30, spin=-15, anchor=TOP);
        up(e) cyl(r=r+t, h=11, $fn=fn, anchor=TOP);
        down(5) right(r+t+5) cuboid([10, 10, 1]); 
    }
}
*/

module clip(r, h, hl) {
    difference() {
        union() {
            color("red") difference() {
                cyl(r=r+tb, h=h+tb, $fn=fn, anchor=TOP);
                up(tb+e) cyl(r=r, h=h+tb, $fn=fn, anchor=TOP);
                up(e) cyl(r=r+t, h=10+slop, $fn=fn, anchor=TOP);
            }
            
            color("blue") difference() {
                cyl(r1=r+tb, r2=rlens+tb, h=hl+t+slop, $fn=fn, anchor=BOTTOM);
                down(e) cyl(r1=r+t, r2=rlens+t, h=hl+t+slop+2*e, $fn=fn, anchor=BOTTOM);
            }
            
            up(hl+t+slop-e) color("pink") difference() {
                cyl(r=rlens+tb, h=tb, $fn=fn, anchor=BOTTOM);
                down(e) cyl(r=rlens-roverhang, h=tb+2*e, $fn=fn, anchor=BOTTOM);
            }
        }
        
        back(4) cuboid([100, 100, 100], anchor=FRONT);
        fwd(4) cuboid([100, 100, 100], anchor=BACK);
        cuboid([100, 100, 100], anchor=RIGHT);
    }
}

module lens_clamp(r=30.75, h=38.5, hl=7.5) {
    
    back(100) {
        down(e) 
        difference() {
            cyl(r=rlens+t, h=hl+t, $fn=fn, anchor=BOTTOM);
            down(e) cyl(r=rlens, h=hl, $fn=fn, anchor=BOTTOM);
            up(hl-2*e) cyl(r=rlens-roverhang, h=t+1, $fn=fn, anchor=BOTTOM);
        }
        
        difference() {
            cyl(r1=r+t, r2=rlens+t, h=hl+t, $fn=fn, anchor=BOTTOM);
            down(e) cyl(r=rlens+t, h=hl+t+1, $fn=fn, anchor=BOTTOM);
        }
        
        difference() {
            cyl(r=r+t, h=10, $fn=fn, anchor=TOP);
            down(t) cyl(r=r, h=10, $fn=fn, anchor=TOP);
            cyl(r=rlens, h=10, $fn=fn);
        }
    }
    
    clip(r, h, hl);
    zrot(120) clip(r, h, hl);
    zrot(240) clip(r, h, hl);

}


// tapo C113 with a +10 lens. r=30.25 is a pretty tight fit, but it works.
//lens_clamp(r=30.25, h=39.5, hl=9);

// tapo C120 with a +4 lens. r=29 is a little loose, r=28.75 is a nice tight fit.
right(100)
lens_clamp(r=28.75, h=36.5, hl=8);

