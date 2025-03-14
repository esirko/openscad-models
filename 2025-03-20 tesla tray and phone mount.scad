include <BOSL2/std.scad>
include <BOSL2/joiners.scad>
include <BOSL2/beziers.scad>
include <BOSL2/walls.scad>
include <BOSL2/rounding.scad>

// TODOs as of 2025-03-30
// - Make the skate have a protrusion on the achilles heel to keep the trapezoid from moving back and forth.
// - The phone mount should move closer, be tilted forward, and be tilted towards the center a bit.
// - The phone mount to tray adapter could be a bit more user friendly and use less filament. Consider a vertical sliding connector
// - My car is currently using an outdated version of the right trapzeoid part and the right tray part, where the difference is
//   that the joiners are the opposite way.

//trapezoid_mount = false;
//wood_panel_contour = false;
//cargo_tray = false;
//phone_mount = false;
//tray_to_phone_connector = false;

trapezoid_mount = true;
wood_panel_contour = true;
cargo_tray = true;
phone_mount = true;
tray_to_phone_connector = true;

// --- constants
e = 0.01;
fn = 36;
fn2 = 72;

// mount bar
t1 = 170; // trapezoid length 1
t2 = 180; // trapezoid length 2
th = 35; // depth of mount bar
ttr = 3; // thickness of trapezoid part of mount bar
tt = 5; // thickness of tooth part of mount bar
ttc = 5; // thickness of clip part
tr = 2.5; // rounding on edges
tsc1 = 20; // skate clip length, right side
tsc2 = 20; // skate clip length, left side
tooth_inward_angle = 95;
tpartition_dx = 20;
tpartition_x = -40;
tjoiner_height = 10;

// cargo tray
cw = 300;
ct = 3;
cpartition_dx = 20;
cpartition_x = -40;
cjoiner_height = 10;
tray_to_phone_block = 20;
separate_tray_from_wood_contour = true;
separate_phone_from_tray = true;

// wood panel contour
wt = 3;
ww = 15; // width of wood panel contour

// Derived
theta = atan2((t2-t1)/2, th);
t1p = t1 + tpartition_dx;
t2p = t2 + tpartition_dx;
cwp = cw + cpartition_dx;

// --- modules
module tooth(dir) {
    side = sqrt(((t2-t1)/2 * (t2-t1)/2) + th*th);

    // set rounding to 0 for faster renderings if you don't care about rounding
    per_side_rounding = [3,3,3,3,0,0,0,0,0,0,0,3,0,0];

    curved_part = bezpath_curve([[70,-39], [48,-20], [36,-14], [side, 0]], splinesteps=8);
    full_tooth_path = flatten([[[0, 0], [15, -42-ttc], [70, -49-ttc]], curved_part, [[side, ttr], [0, ttr]]]);
    
    tbx = full_tooth_path[2][0] - full_tooth_path[1][0];
    tby = full_tooth_path[2][1] - full_tooth_path[1][1];
    tooth_bottom_theta = atan2(tby, tbx);
    tooth_bottom_len = sqrt(tbx*tbx + tby*tby);
    
    right(dir*t1p/2) fwd(th/2)
    zrot(90-dir*theta) xrot(90+dir*(tooth_inward_angle-90))
    difference() {
        union() {
            up(dir*tt/2) 
            rounded_prism(full_tooth_path, height=tt, joint_top=0, joint_bot=0, joint_sides=per_side_rounding);
        
            right(full_tooth_path[1][0]) back(full_tooth_path[1][1]+ttc)
            zrot(tooth_bottom_theta) xrot(dir*90 - dir*(tooth_inward_angle-90))
            union()
            {
                cuboid([tooth_bottom_len, (dir > 0) ? tsc1 : tsc2, ttc], anchor=(dir < 0 ? TOP : BOTTOM)+LEFT+BACK, rounding=tr, except=BACK, $fn=fn);
                
                // strengthening edge
                fudge1 = 2.5;
                back(fudge1) right(tr) xrot(dir > 0 ? 180 : 90) yrot(-90)
                    rounding_edge_mask(l=tooth_bottom_len-2*tr,r=10, anchor=TOP+BACK+FRONT, $fn=fn2);
            }
        }
        
        // Round the sharp corners
        tempround=20;
        rounddiag = tempround * (1 - 1/sqrt(2));
        if (dir > 0) {
            up(tt) right(full_tooth_path[2][0]) back(full_tooth_path[2][1]) zrot(0) 
                translate([rounddiag,-rounddiag,rounddiag])
                rounding_corner_mask(tempround, orient=DOWN, $fn=fn2);
            up(tt) right(full_tooth_path[1][0]) back(full_tooth_path[1][1]) zrot(-90) 
                translate([rounddiag+1.5,-rounddiag-4.5,rounddiag]) // fudge factors
                rounding_corner_mask(tempround, orient=DOWN, $fn=fn2);
        } else {
            up(-tt) right(full_tooth_path[2][0]) back(full_tooth_path[2][1]) zrot(90) 
                translate([-rounddiag,-rounddiag,-rounddiag])
                rounding_corner_mask(tempround, orient=UP, $fn=fn2);
            up(-tt) right(full_tooth_path[1][0]) back(full_tooth_path[1][1]) zrot(0) 
                translate([-rounddiag-4.5,-rounddiag-1.5,-rounddiag]) // fudge factors
                rounding_corner_mask(tempround, orient=UP, $fn=fn2);
        }
    }
}

xrot(-20) // This rotates the entire model so that it's approximately in the right orientation relative to the car. Not necessary, but may be helpful for visualizing.
difference() {
union() { // ---- full model union

// --- trapezoid mount
if(trapezoid_mount) {
    difference() {
        union() {
            prismoid([t1p + 2*tt, ttr], [t2p + 2*tt, ttr], th, anchor=BACK, orient=BACK);
            tooth(1);
            tooth(-1);
        }
        up(ttr) fwd(th/2) yrot(90) rounding_edge_mask(l=200, r=tr, excess=4, $fn=fn);
        up(ttr) back(th/2) zrot(180) yrot(90) rounding_edge_mask(l=200, r=tr, excess=4, $fn=fn);
        up(ttr) right((t1p+t2p)/4+tt) zrot(90-theta) yrot(90) rounding_edge_mask(l=50, r=tr, excess=4, $fn=fn);
        up(ttr) left((t1p+t2p)/4+tt) zrot(-90+theta) yrot(90) rounding_edge_mask(l=50, r=tr, excess=4, $fn=fn);
        // Corners - lots of fudge factors
        up(ttr+1.5) fwd(th/2+3) right(t1p/2+tt + 4) rounding_corner_mask(10, orient=DOWN, excess=4, $fn=fn2);
        up(ttr+1.5) back(th/2+3) right(t2p/2+tt + 3) zrot(90) rounding_corner_mask(10, orient=DOWN, excess=4, $fn=fn2);
        up(ttr+1.5) back(th/2+3) left(t2p/2+tt + 3) zrot(180) rounding_corner_mask(10, orient=DOWN, excess=4, $fn=fn2);
        up(ttr+1.5) fwd(th/2+3) left(t1p/2+tt + 4) zrot(270) rounding_corner_mask(10, orient=DOWN, excess=4, $fn=fn2);
        
        right(tpartition_x)
        if (tpartition_dx > 0) {
            down(e) cuboid([tpartition_dx, th+2*e, ttr+2*e], anchor=BOTTOM);
            left(tpartition_dx/2) up(tjoiner_height/2) yrot(90) half_joiner_clear(l=th-2*tr, w=tjoiner_height);
            left(-tpartition_dx/2) up(tjoiner_height/2) yrot(-90) half_joiner_clear(l=th-2*tr, w=tjoiner_height);
        }
    }

    right(tpartition_x)
    if (tpartition_dx > 0) {
        left(tpartition_dx/2) up(tjoiner_height/2) yrot(90) half_joiner(l=th-2*tr, w=tjoiner_height, base=20);
        left(-tpartition_dx/2) up(tjoiner_height/2) yrot(-90) half_joiner2(l=th-2*tr, w=tjoiner_height, base=20);
    }
}

// --- wood panel contour (and trapezoid-to-tray interface)
if(wood_panel_contour) {
    path4 = bezpath_curve([[0,0], [0,8], [-4,20], [57,72]]);
    path5 = slice(path4, 0, 13); // chop off the front-most part of it, don't need it and don't want to see it
    last_segment = slice(path5, len(path5)-2, len(path5)-1);
    last_segment_theta = atan2(last_segment[1][1] - last_segment[0][1], last_segment[1][0] - last_segment[0][0]);
    fudgeh = 29; // theoretically math derived but practically eye-balled

    xflip_copy() {
        up(wt/2) back(th/2 - wt/2 - tr) left(t2p/2-tr)
        yrot(90) zrot(90)
        union() {
            difference() {
                union() {
                    linear_extrude(ww) stroke(path5, width=wt, endcaps="round");
                    back(last_segment[1][1]) right(last_segment[1][0]) zrot(180+last_segment_theta) up(ww/2) xrot(90) prismoid(size1=[3, ww], size2=[5, 2*ww], h=fudgeh, rounding=1, $fn=fn);
                }
            }
        }
        
        fudgeh2 = 39;
        up(wt/2) fwd(th/2 - wt/2 - tr) left(t1p/2-tr-ww/2) xrot(20) zrot(90) prismoid(size1=[wt,ww], size2=[wt,2*ww], h=fudgeh2, rounding=1, $fn=fn);
    }
}

// --- cargo tray
tray_path = [[0, 50], [5, 0], [40, 0], [70, 15], [85, 40]];
if (cargo_tray) {
    pt = 3;
    ctheta = atan2(40-15, 85-70); // from last two points in tray_path
    jtheta = atan2(15-0, 70-40);
    
    fwd(45) up(54) left(cwp/2+ct) xrot(20) zrot(90) xrot(90)
    union() {
        back(separate_tray_from_wood_contour ? 20 : 0)
        union() {
            difference() {
                union() {
                    // Making a tray with exact inner dimensions
                    // Option 1: simple but doesn't get exact inner dimension
                    //stroke(tray_path, width=ct, endcaps="square",endcap_length=0);
                    // Option 2: exact inner dimension and almost opens the top without calculation, but still need to do some calculation to clean it up
                    //difference() {
                    //    stroke(tray_path,width=10, endcaps="square",endcap_length=0);
                    //    hull() stroke(tray_path,width=e);
                    //}
                    // Option 3: exact inner dimension but closed polygon. Need to difference out the top by doing some calculation
                    //shell2d(10, or=1) polygon(tray_path);
                    // Option 4: Option 3, but using half_of
                    first_to_last_vector = last(tray_path) - select(tray_path, 0);
                    normal_vector = unit([-first_to_last_vector[1], first_to_last_vector[0]]);
                    linear_extrude(cwp + 2*ct)
                    half_of(-normal_vector, cp=tray_path[0], s=500, planar=true) 
                    shell2d(ct) polygon(tray_path);

                    // sides
                    down(tray_to_phone_block) linear_extrude(ct+tray_to_phone_block) polygon(tray_path);
                    up(cwp+ct) linear_extrude(ct) polygon(tray_path);
                    
                    // partitions
                    difference() {
                        union() {
                            up(0.25*(cw+ct)) linear_extrude(pt) polygon(tray_path);
                            up(0.5*(cw+ct)) linear_extrude(pt) polygon(tray_path);
                            up(0.75*(cwp+ct)) linear_extrude(pt) polygon(tray_path);
                        }
                        up(0.24*(cw+ct)) left(10) back(20) zrot(-10) cube([100, 100, 0.04*cw]);
                        up(0.49*(cw+ct)) left(10) back(35) zrot(-10) cube([100, 100, 0.04*cw]);
                        up(0.74*(cwp+ct)) left(10) back(20) zrot(-10) cube([100, 100, 0.04*cw]);
                    }
                }
                
                if (cpartition_dx > 0) {
                    up(0.51*cwp+e) cuboid([200, 200, cpartition_dx]);
                    up(0.51*cw+e) right(20) fwd(5) zrot(90) half_joiner_clear(l=30, w=10); 
                    up(0.51*cw+e+cpartition_dx) right(20) fwd(5) zrot(90) yrot(180) half_joiner_clear(l=30, w=10);
                    up(0.51*cw+e) right(85) back(40) zrot(ctheta) left(15) fwd(5) zrot(90) half_joiner_clear(l=30, w=10);
                    up(0.51*cw+e+cpartition_dx) right(85) back(40) zrot(ctheta) left(15) fwd(5) zrot(90) yrot(180) half_joiner_clear(l=30, w=10);
                }
                
                up(8) down(tray_to_phone_block) right(25) back(30) zrot(90) xrot(180) 
                    union() {
                        half_joiner_clear(l=40, w=20);
                        cuboid([20, 40, 18]);
                    }
                }
            
            if (cpartition_dx > 0) {
                up(0.51*cw+e) right(20) fwd(5) zrot(90) half_joiner2(l=30, w=10, base=20);
                up(0.51*cw+e+cpartition_dx) right(20) fwd(5) zrot(90) yrot(180) half_joiner(l=30, w=10, base=20);
                up(0.51*cw+e) right(85) back(40) zrot(ctheta) left(15) fwd(5) zrot(90) half_joiner2(l=30, w=10, base=20);
                up(0.51*cw+e+cpartition_dx) right(85) back(40) zrot(ctheta) left(15) fwd(5) zrot(90) yrot(180) half_joiner(l=30, w=10, base=20);
            }
        }
    }
    
    xflip_copy()
    fwd(45) up(54) left(cwp/2+ct) xrot(20) zrot(90) xrot(90)
    union() {
        back(separate_tray_from_wood_contour ? 20 : 0)
        union() {
            // fudge numbers! But the complicated "up" expression is exact.
            up(cwp/2+ct - (t2p/2-tr) + ww/2) 
            fwd(0) right(64) zrot(jtheta) xrot(90) half_joiner(l=30, w=10, base=10); 

            up(cwp/2+ct - (t1p/2-tr) + ww/2)
            fwd(12) right(12) xrot(90) half_joiner(l=30, w=10, base=10);
        }

        // These joints belong to the wood contour part, but defined here to be an exact match!
        up(cwp/2+ct - (t2p/2-tr) + ww/2) 
        fwd(0) right(64) zrot(jtheta) xrot(90) yrot(180) half_joiner2(l=30, w=10, base=10);
        
        up(cwp/2+ct - (t1p/2-tr) + ww/2)
        fwd(12) right(12) xrot(90) yrot(180) half_joiner2(l=30, w=10, base=10);
    }
}


// --- phone mount and extension arm
pw = 79; // width of iphone+spigen case
pd = 13; // thickness(depth) of iphone+spigen case
ph = 100; // height of phone, but doesn't have to be exact
pt = 5;
lip = 5;
if (phone_mount) {
    left(separate_phone_from_tray ? 40 : 0)
    up(separate_tray_from_wood_contour ? 20 : 0)
    left(cpartition_dx/2)
    fwd(55) up(50) left(230) zrot(-10) xrot(10)
    union() {
        // Probably a smarter (and prettier) way to do this - the rounding page on BOSL2 has some good examples
        difference() {
            cuboid([pw+2*pt, pd+2*pt, ph+2*pt],chamfer=3);
            up(ph-2*pt) cuboid([100, 100, ph]);
            fwd(pt/2) cuboid([pw, pd+pt+e, ph], rounding=5, edges="Y");
        }
        
        fwd(0.5*(pd+pt))
        union() {
            down(0.5*(ph-lip)) cuboid([pw, pt, lip]);        
            left(0.5*(pw-lip)) down(0.5*(ph-40)) cuboid([lip, pt, 40], rounding=3, edges=BACK+TOP);
            right(0.5*(pw-lip)) down(0.5*(ph-40)) cuboid([lip, pt, 40], rounding=3, edges=BACK+TOP);
        }
    }
}

if (tray_to_phone_connector) {
    // same transform as tray
    p1 = fwd(45,  up(54, left(cwp/2+ct, xrot(20, zrot(90, xrot(90,
    back(separate_tray_from_wood_contour ? 20 : 0,
    down(tray_to_phone_block,
    p=path3d(tray_path)))))))));

    // same transform as phone mount
    p2 = up(separate_tray_from_wood_contour ? 20 : 0, left(cpartition_dx/2,
    fwd(55, up(50, left(230, zrot(-10, xrot(10,
    back(pd/2+pt, up(10, xrot(90, 
    p=path3d(rect([pw, 40]))))))))))));

    left(separate_phone_from_tray ? 40 : 0)
    difference() {
        skin([p1,p2], method="distance", slices=10, refine=10);
        fwd(45) up(54) left(cwp/2+ct) xrot(20) zrot(90) xrot(90)
            back(separate_tray_from_wood_contour ? 20 : 0)
            down(tray_to_phone_block) right(25) back(30) zrot(90) xrot(180) yrot(180) half_joiner_clear(l=40, w=20);
    }

    // For reference here are the polygons...
    //fwd(45) up(54) left(tw/2+ct) xrot(20) zrot(90) xrot(90)
    //polygon(tray_path);

    //fwd(80) up(100) left(230) zrot(-10) xrot(10) 
    //back(pd/2+pt) down(20) xrot(90) rect([pw, 40]);
    
    // same transform as tray for joiners
    fwd(45) up(54) left(cwp/2+ct) xrot(20) zrot(90) xrot(90)
    back(separate_tray_from_wood_contour ? 20 : 0)
    up(8) down(tray_to_phone_block) right(25) back(30) zrot(90) xrot(180) half_joiner2(l=40, w=20, base=10);

    left(separate_phone_from_tray ? 40 : 0)
    fwd(45) up(54) left(cwp/2+ct) xrot(20) zrot(90) xrot(90)
    back(separate_tray_from_wood_contour ? 20 : 0)
    up(8) down(tray_to_phone_block) right(25) back(30) zrot(90) xrot(180) yrot(180) half_joiner(l=40, w=20, base=10);
    
}

} // --- end full model union

}


