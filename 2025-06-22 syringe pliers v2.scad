include <BOSL2/std.scad>

e = 0.1;
fn = 72;

r0 = 25;
rc = 15;
zh = 8;

r1 = 30;
rc2 = rc;
rh1 = 6;
rh0 = 3;

ht = 6;
hl = 40;

 
// syringe piston
gr = 15.5;
gt = 5;
back(100)
difference() {
    union() {
        difference() {
            cuboid([50,40,gt], anchor=BOTTOM);
            down(e) back(15+e) cuboid([2*gr,20,gt+2*e], anchor=BOTTOM);
            down(e) back(5) cylinder(h = gt+2*e, r = gr);
        }
        
        up(40) union() {
            cuboid([50, 40, gt], anchor=BOTTOM);
            up(gt) back(5) difference() {
                cyl(h=2, r=18, anchor=BOTTOM);
                down(e) cyl(h=2+2*e, r=17, anchor=BOTTOM);
                down(e) back(9) cuboid([36+2*e, 18+e, 2+2*e], anchor=BOTTOM);
            }
        }
        
        right(16) fwd(30) cyl(h=50, r=2.9, anchor=BOTTOM);
        left(16) fwd(30) cyl(h=50, r=2.9, anchor=BOTTOM);
    }
    
    right(16) fwd(14) down(e) cyl(h=100, r=3.1, anchor=BOTTOM);
    left(16) fwd(14) down(e) cyl(h=100, r=3.1, anchor=BOTTOM);
}


// pistons
back(50)
xcopies(100, 2) {
    difference() {
        union() {
            cyl(l=zh+2, r=r0, $fn=fn);
            right(12) up((zh+2)/2 + 1) cuboid([85, 5, 2]);
            right(12) down((zh+2)/2 + 1) back(5.2) cuboid([85, 5, 2]);
            right(12) down((zh+2)/2 + 1) fwd(5.2) cuboid([85, 5, 2]);
        }
        left(rc) cuboid([r0+rc+e, 2*r0+2*e, zh+2+2*e], anchor=LEFT);
        back(r0/2+5/2) down(1.5) up((zh+2)/2 + 1+e) cuboid([85, r0, 1]);
        fwd(r0/2+5/2) down(1.5) up((zh+2)/2 + 1+e) cuboid([85, r0, 1]);
        
        back(r0/2+5/2 + 5.2) up(1.5) down((zh+2)/2 + 1+e) cuboid([85, r0, 1]);
        up(1.5-e) down((zh+2)/2 + 1) cuboid([85, 5.4, 1]);
        fwd(r0/2+5/2 + 5.2) up(1.5) down((zh+2)/2 + 1+e) cuboid([85, r0, 1]);
    }
    right(85/2+12-1) up((zh+2)/2 - 1) cuboid([2, 5, 4]);
    right(85/2+12-1) down((zh+2)/2 - 1) back(5.2) cuboid([2, 5, 4]);
    right(85/2+12-1) down((zh+2)/2 - 1) fwd(5.2) cuboid([2, 5, 4]);
}

// plier arms
left(10)
xcopies(20, 2) {

    ydisplacement = sqrt(r1*r1 - rc2*rc2) + 4; // hmmm may need to recalculate this

    difference() {
        union() {
            difference() {
                cyl(l=zh, r=r1, $fn=fn);
                cyl(l=zh+2*e, r=r0, $fn=fn);
                left(rc2) cuboid([r1+rc2+e, 2*r1+2*e, zh+2*e], anchor=LEFT);
            }
            fwd(ydisplacement) left(rc2) cyl(l=zh, r=rh1, $fn=fn);
            //fwd(ydisplacement-5) left(rc2) cuboid([5, 10, zh], anchor=RIGHT);
            fwd(ydisplacement+hl/2) left(rc2) cuboid([ht, hl, zh], anchor=LEFT);
        }
        
        fwd(ydisplacement) left(rc2) cyl(l=zh+2*e, r=rh0, $fn=fn);
        fwd(ydisplacement) left(rc2) cyl(l=zh/2+e, r=rh1+e, $fn=fn, anchor=BOTTOM);
    }
}

// plier axle
cyl(h=zh+6, r=rh0-0.2, $fn=fn, anchor=BOTTOM);
cyl(h=2, r=rh0+1, $fn=fn, anchor=BOTTOM);
right(2*rh0+4) difference() {
    cyl(h=4, r=rh0+1, $fn=fn, anchor=BOTTOM);
    up(1+e) cyl(h=3, r=rh0-0.05, $fn=fn, anchor=BOTTOM);
}

