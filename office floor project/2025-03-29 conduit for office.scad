include <BOSL2/std.scad>
include <BOSL2/joiners.scad>

e = 0.01;
ee = 0.2;
fn = 72;

t = 2;
w = 50;
h = 30;
v = 15;
vt = 1;

r = 38+25;
h1 = 30;
h2 = 25;

l1 = 100;
l2 = 56;
l3 = 145;
lip = 5;
overlap = 30;
overlap_bottom1 = 5;
overlap_bottom2 = 10;
right_part_offset = 20;

//angle_part(r, 90, overlap, overlap);

//back(3*r) right(150) zrot(90+20) angle_part(r, 20, 10, 0);
//right(195) zrot(-90+20) angle_part(r, 20, 10, 0);

//b = 30;

//path = [[-100, -100], [-100, 0], [-50, 50], [0, 100], [100, 100]];


//w = 10;
//h = 5;
//t = 1;

path = flatten([[[-r,-53, 0]], 
    xflip(helix(h=h1, turns=0.25, r=r, $fn=fn)), 
    [[80,r,h1], [160, r+20, h2], [180, r+20, h2], [210, r+20, h2]]]);

echo(path);

sq = difference(rect([w+2*t,h+2*t]), rect([w,h]));

//partition([500, 300, 200], cutpath="dovetail", spin=90,spread=20, gap=10)
//zrot(-25) right(60)
//partition([500, 300, 200], cutpath="dovetail", spin=90,spread=20, gap=10)
//left(50)


union() {
    difference() {
        partition([500, 300, 200], cutpath="flat", spin=90,spread=20, gap=10)
        left(50) path_sweep(sq, path, method="manual");
        
        up(h1) back(r-w/2-5+ee) left(10) xrot(90) yrot(90) half_joiner_clear(l=20, w=10);
        up(h1) back(r+w/2+5-ee) left(10) xrot(90) yrot(90) half_joiner_clear(l=20, w=10);
        up(h1) back(r+w/2+5-ee) right(10) xrot(90) yrot(-90) half_joiner_clear(l=20, w=10);
        up(h1) back(r-w/2-5+ee) right(10) xrot(90) yrot(-90) half_joiner_clear(l=20, w=10);
    }
    
    up(h1) back(r-w/2-5) left(10) xrot(90) yrot(90) half_joiner(l=20, w=10);
    up(h1) back(r+w/2+5) left(10) xrot(90) yrot(90) half_joiner(l=20, w=10);
    up(h1) back(r+w/2+5) right(10) xrot(90) yrot(-90) half_joiner2(l=20, w=10);
    up(h1) back(r-w/2-5) right(10) xrot(90) yrot(-90) half_joiner2(l=20, w=10);
}

// endcaps
xcopies(100, n=2)
union() {
    linear_extrude(20)
    union() {
        difference() {
            rect([w, h]);
            rect([w-2*t, h-2*t]);
        }
        difference() {
            rect([w+4*t, h+4*t]);
            rect([w+2*t, h+2*t]);
        }
    }

    linear_extrude(vt)
    difference() {
        rect([w+v, h+v]);
        rect([w-2*t, h-2*t]);
    }
}



//angle_part3(65, 90, overlap, overlap);

module angle_part3(r, theta, overlap1, overlap2) {
    
    path = [[-w/2-t, h/2], [-w/2, h/2], [-w/2, -h/2], [w/2, -h/2], [w/2, h/2], [w/2+t, h/2],
        [w/2+t, -h/2-t], [-w/2-t, -h/2-t]];
    
   stroke(path, closed=true, width=e);
    
}


module angle_part2(r, theta, overlap1, overlap2) {
    
    path = [for(theta=[-180:5:180]) [theta/100, 5sin(theta)]];
    //object = difference(rect([w+2*t, h+2*t]), back(t, rect([w, h+t+e])));
//    stroke(object);
    
    //polygon(object);
    
    //path_extrude(arc(r=50,angle=[0,45],n=10)) //,caps=true)
//path_extrude(path)
        //left(r)
        union() {
            difference() {
                rect([w+2*t, h+2*t]);
                back(t) rect([w, h+t+e]);
            }
            back(20)
            difference() {
                rect([w+4*t, t+lip]);
                fwd(t) rect([w-2*t, lip+e]);
                left((w+t)/2) fwd(t+e) rect([t, lip]);
                right((w+t)/2) fwd(t+e) rect([t, lip]);
            }
        }
    
    
}

module angle_part(r, theta, overlap1, overlap2) {
    difference() {
        union() {
            difference() {
                cyl(l = h+2*t, r = r+w+t, $fn=fn);
                cyl(l = h+2*t+2*e, r = r+w, $fn=fn);
            }
            difference() {
                cyl(l = h+2*t, r = r, $fn=fn);
                cyl(l = h+2*t+2*e, r = r-t, $fn=fn);
            }
            
            
            down(h/2+t/2)
            difference() {
                cyl(l=t, r=r+w+t, $fn=fn);
                cyl(l=t+2*e, r = r-t, $fn=fn);
            }
            
            
            
            // top lid
            up(h/2+lip/2+10)
            union() {
                difference() {
                    cyl(l=t, r=r+w+2*t, $fn=fn);
                    cyl(l=t+2*e, r = r-2*t, $fn=fn);
                }
                down(lip/2)
                union() {
                    difference() {
                        cyl(l = lip, r = r+w+2*t, $fn=fn);
                        cyl(l = lip+2*e, r = r+t+w, $fn=fn);
                    }
                    difference() {
                        cyl(l = lip, r = r+w, $fn=fn);
                        cyl(l = lip+2*e, r = r-t+w, $fn=fn);
                    }
                    difference() {
                        cyl(l = lip, r = r+t, $fn=fn);
                        cyl(l = lip+2*e, r = r, $fn=fn);
                    }
                    difference() {
                        cyl(l = lip, r = r-t, $fn=fn);
                        cyl(l = lip+2*e, r = r-2*t, $fn=fn);
                    }
                }
            }
            
        }

        cuboid([2 * (r + w + 2*t + e), 2 * (r + w + 2*t + e), h+2*t+2*e+100], anchor=BACK);
        zrot(-theta) cuboid([2 * (r + w + 2*t + e), 2 * (r + w + 2*t + e), h+2*t+2*e+100], anchor=FRONT);
    }

/*
    // top lid continued with overlap part
    up(h/2+lip/2+10)
    union() {
        zrot(90-theta) union() {
            back(r-t/2+w/2) cuboid([overlap1, w+4*t, t], anchor=LEFT);
            down(lip/2)
            union() {
                back(r-2*t) cuboid([overlap1, t, lip], anchor=LEFT);
                back(r) cuboid([overlap1, t, lip], anchor=LEFT);
                back(r+w-t) cuboid([overlap1, t, lip], anchor=LEFT);
                back(r+w+t) cuboid([overlap1, t, lip], anchor=LEFT);
            }
        }
        
        left(r+w/2) cuboid([w+4*t, overlap2, t], anchor=BACK);
        down(lip/2)
        union() {
            left(t/2) left(r-2*t) cuboid([t, overlap2, lip], anchor=BACK);
            left(t/2) left(r) cuboid([t, overlap2, lip], anchor=BACK);
            left(t/2) left(r+w-t) cuboid([t, overlap2, lip], anchor=BACK);
            left(t/2) left(r+w+t) cuboid([t, overlap2, lip], anchor=BACK);
        }
    }
    */
    
}

/*
right(10) back(r+w/2)
union() {
    difference() {
        union() {
            cuboid([l1, w+2*t, h+2*t], anchor=LEFT);
            // visual frame
            //right(l1-t) cuboid([t, w+2*v, h+2*v], anchor=LEFT);
            // bottom securer
            left(overlap_bottom1) down((h-lip+t)/2 + t) cuboid([overlap_bottom1+overlap_bottom2, w+4*t, lip+t], anchor=LEFT);
        }
        left(e) cuboid([l1+2*e, w, h], anchor=LEFT);
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




*/

