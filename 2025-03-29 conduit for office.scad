include <BOSL2/std.scad>

e = 0.01;
t = 1;
w = 1.5*25.4;
h = 0.75*25.4;
r = 70;
l = 200;
l2 = 50;
lip = 5;
overlap = 30;
overlap_bottom1 = 5;
overlap_bottom2 = 10;
v = 5;

difference() {
    union() {
        difference() {
            cyl(l = h+2*t, r = r+w+t);
            cyl(l = h+2*t+2*e, r = r+w);
        }
        difference() {
            cyl(l = h+2*t, r = r);
            cyl(l = h+2*t+2*e, r = r-t);
        }
        
        down(h/2+t/2)
        difference() {
            cyl(l=t, r=r+w+t);
            cyl(l=t+2*e, r = r-t);
        }
        
        // top lid
        up(h/2+lip/2+10)
        union() {
            difference() {
                cyl(l=t, r=r+w+2*t);
                cyl(l=t+2*e, r = r-2*t);
            }
            down(lip/2)
            union() {
                difference() {
                    cyl(l = lip, r = r+w+2*t);
                    cyl(l = lip+2*e, r = r+t+w);
                }
                difference() {
                    cyl(l = lip, r = r+w);
                    cyl(l = lip+2*e, r = r-t+w);
                }
                difference() {
                    cyl(l = lip, r = r+t);
                    cyl(l = lip+2*e, r = r);
                }
                difference() {
                    cyl(l = lip, r = r-t);
                    cyl(l = lip+2*e, r = r-2*t);
                }
            }
        }   
    }

    cuboid([2 * (r + w + 2*t + e), 2 * (r + w + 2*t + e), h+2*t+2*e+100], anchor=BACK);
    cuboid([2 * (r + w + 2*t + e), 2 * (r + w + 2*t + e), h+2*t+2*e+100], anchor=LEFT);
}

// top lid continued with overlap part
up(h/2+lip/2+10)
union() {
    back(r-t/2+w/2) cuboid([overlap, w+4*t, t], anchor=LEFT);
    down(lip/2)
    union() {
        back(r-2*t) cuboid([overlap, t, lip], anchor=LEFT);
        back(r) cuboid([overlap, t, lip], anchor=LEFT);
        back(r+w-t) cuboid([overlap, t, lip], anchor=LEFT);
        back(r+w+t) cuboid([overlap, t, lip], anchor=LEFT);
    }
    
    left(r+w/2) cuboid([w+4*t, overlap, t], anchor=BACK);
    down(lip/2)
    union() {
        left(t/2) left(r-2*t) cuboid([t, overlap, lip], anchor=BACK);
        left(t/2) left(r) cuboid([t, overlap, lip], anchor=BACK);
        left(t/2) left(r+w-t) cuboid([t, overlap, lip], anchor=BACK);
        left(t/2) left(r+w+t) cuboid([t, overlap, lip], anchor=BACK);
    }
}

right(10) back(r+w/2)
union() {
    difference() {
        union() {
            cuboid([l, w+2*t, h+2*t], anchor=LEFT);
            // visual frame
            right(l-t) cuboid([t, w+2*v, h+2*v], anchor=LEFT);
            // bottom securer
            left(overlap_bottom1) down((h-lip+t)/2 + t) cuboid([overlap_bottom1+overlap_bottom2, w+4*t, lip+t], anchor=LEFT);
        }
        left(e) cuboid([l+2*e, w, h], anchor=LEFT);
        left(e) up(h) cuboid([overlap, w, h+2*e], anchor=LEFT);
        left(overlap_bottom1+e) down((h-lip+t)/2) cuboid([overlap_bottom1+2*e, w+2*t, lip+t], anchor=LEFT); 
    }
}

fwd(10) left(r+w/2) 
difference() {
    union() {
        cuboid([w+2*t, l2, h+2*t], anchor=BACK);
        fwd(l2-t) cuboid([w+2*v, t, h+2*v], anchor=BACK);
        back(overlap_bottom1) down((h-lip+t)/2 + t) cuboid([w+4*t, overlap_bottom1+overlap_bottom2, lip+t], anchor=BACK);
    }
    back(e) cuboid([w, l2+2*e, h], anchor=BACK);
    back(e) up(h) cuboid([w, overlap, h+2*e], anchor=BACK);
    back(overlap_bottom1+e) down((h-lip+t)/2) cuboid([w+2*t, overlap_bottom1+2*e, lip+t], anchor=BACK); 
}





