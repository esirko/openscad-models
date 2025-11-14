include <BOSL2/std.scad>
include <BOSL2/joiners.scad>
include <BOSL2/screws.scad>

// Globals
e = 0.01;
fn = 36;
sd = 20; // Distance from screwhole to edge of piece

// 2025-10-17 Version 2 using aluminum angle/edge protector
aluminum_edge = 1;

// Outer edging parameters
t1 = 4;
t3 = 1;
t4 = 1;
w1 = 20;
tlvp = 6 + 2; // thickness of LVP + underlayment
d1 = 19;
d2 = 20;
ch1 = 2.5;

w2_1 = 19;
w2_2 = 40;
        
notch_w = 45;
notch_d = 23;
notch_x = 47;
    
// Inner edging parameters
iw1 = w1; // unlikely to be different from w1
iw1_back = w1+10;
it1 = t1-1;
id1 = 18;
it2 = 3;
it3 = 1;
iw2 = 30;
iw2_back = 33+12;
ich1 = 1.5;
ich2 = 0.75;

// Front edging parameters
fw1 = 40; // almost certainly bigger than w1
ft1 = t1; // consider bigger than t1
fch1 = ch1;
ft2 = 3;
fd1 = 18;
fch2 = 1.5;

// Front of entire platform (not trap door)
module front_edging(length, screw_positions) {
    up(tlvp) left(ft2)
    difference() {
        cuboid([fw1, length, ft1], chamfer=fch1, edges=TOP+RIGHT, anchor=LEFT+BOTTOM+BACK);
        back(e) rounding_edge_mask(l=length+2*e, r=ft1, anchor=TOP+BACK, $fn=fn, orient=BACK);
    }
    
    cuboid([ft2, length, tlvp], anchor=RIGHT+BOTTOM+BACK);
    diff()
        cuboid([ft2, length, fd1], anchor=RIGHT+TOP+BACK, chamfer=fch2, edges=BOTTOM+LEFT)
            attach(LEFT) {
                for (s = screw_positions) {
                    right(s) screw_hole("#8-32,1",head="flat",counterbore=0,anchor=TOP, $fn=fn);
                }
            }
    
}

// --- New side edge (not trap door) model (previously front edging)
module side_edging(l, h1, h2, screw_positions, scarf_joint_1=true, scarf_joint_2=true, far_side=false) {
    w1 = 30;
    //t1 = 4; // should be same as other t1
    //ch1 = 2.5; // should be same as other ch1
    d1 = 19+6+2;
    t2 = 3;
    w2 = far_side ? 15 : 30;
    t3 = 1;
    c1 = 8.5;
    c2 = 11.5;
    c3 = 5.5;
    
    difference() {
        union() {
            left(t2)
            difference() {
                cuboid([w1, l, t1], chamfer=ch1, edges=TOP+RIGHT, anchor=LEFT+BOTTOM+BACK);
                back(e) rounding_edge_mask(l=l+2*e, r=t1, anchor=TOP+BACK, $fn=fn, orient=BACK);
            }
            cuboid([t2, l, d1], chamfer=2, edges=BOTTOM+LEFT, anchor=RIGHT+TOP+BACK);
            
            if (h1 == 0) {
                down(d1-t3) cuboid([w2-t2, l, t3], chamfer=0.5, edges=BOTTOM+RIGHT, anchor=LEFT+TOP+BACK);
                if (!far_side) {
                    cuboid([c1+c3, l, d1-t3], anchor=LEFT+TOP+BACK);
                }
            } else {
                color("red") xrot(90) prismoid(size1=[c1, c2+h1], size2=[c1, c2+h2], h=l, shift=[0,(h1-h2)/2], anchor=LEFT+BACK+BOTTOM);
                color("blue") right(c1) xrot(90) prismoid(size1=[c3, h1], size2=[c3, h2], h=l, shift=[0,(h1-h2)/2], anchor=LEFT+BACK+BOTTOM);
            }
        }

        for (s = screw_positions) {
            fwd(s) left(t2+e) down(d1-t3-9.5) yrot(-90) screw_hole("#8-32,1",head="flat",counterbore=0, anchor=TOP, $fn=fn);
        }
        
        // make the diagonal scarf joint thingy - fwd side
        if (scarf_joint_1) {
            fwd(l-t1) left(t2+e) fwd(e) down(e) prismoid(size1=[w1+2*e, t1], size2=[w1+2*e, 0], h=t1, shift=[0,-t1/2], anchor=LEFT+BOTTOM+BACK);
            fwd(l-t1) left(t2+e) fwd(e) cuboid([t2+c1+c3+2*e, t1, d1-t3], anchor=LEFT+TOP+BACK);
            fwd(l-t1) left(t2+e) down(d1-t3) fwd(e) up(e) cuboid([w2+2*e, t1, t3+2*e], anchor=LEFT+TOP+BACK);
        }
        
        // back side joint
        if (scarf_joint_2) {
            left(t2+e) back(e) up(e) prismoid(size1=[w1+2*e, 0], size2=[w1+2*e, t1], h=t1, shift=[0,-t1/2], anchor=LEFT+BOTTOM+BACK);
        }
        
        //right(2) fwd(2) up(t1+e) text3d(str(h1), h=1, size=8, center=true, anchor=TOP+BACK+LEFT);
    }
}



// Trap door: outside edging, i.e. frame of the trap door
module outside_edging(l1, t2, w2, w1, screw_positions, notch_x, notch_w, notch_d, cutout_for_hinge, minimal_edge, d1adjustment, hack="") {
    
    tlvp = tlvp + d1adjustment; // adjusting tlvp works better in that if you adjust d1, it affects the screw hole lo7cations
    
    difference() {
        union() {
            if (aluminum_edge == 0) {
                up(tlvp) right(t2) 
                    if (minimal_edge) {
                        difference() {
                            cuboid([w1, l1, 2], anchor=RIGHT+BOTTOM+BACK);
                            color("red") back(e) up(t1+e) fwd(l1+e) left(w1+e) zrot(90) xrot(180) wedge([l1+2*e, w1, t1-0.4]);
                        }
                    } else {
                        cuboid([w1, l1, t1], chamfer=ch1, edges=TOP+LEFT, anchor=RIGHT+BOTTOM+BACK);
                    }
            }
            color("gray") 
            if (hack == "FO4") {
                prismoid(size1=[t2-aluminum_edge, tlvp], size2=[t2-aluminum_edge, tlvp-2], shift=[0,-1], h=l1, anchor=BOTTOM+FRONT+LEFT, orient=FRONT);
            } else {
                cuboid([t2-aluminum_edge, l1, tlvp], anchor=LEFT+BOTTOM+BACK);
            }
            diff()
                cuboid([t2-aluminum_edge, l1, d1], anchor=LEFT+TOP+BACK)
                    attach(RIGHT)
                        for (s = screw_positions) {
                            right(s) screw_hole("#8-32,1",head="flat",counterbore=0,anchor=TOP, $fn=fn);
                        }
            down(d1) cuboid([w2, l1, t3], anchor=LEFT+BOTTOM+BACK);
            right(w2) down(d1-t3) cuboid([t4, l1, d2+t3], anchor=LEFT+TOP+BACK);
                        
            if (notch_x > 0) {
                color("red") right(w2+t4-e) down(d1-t3+e) fwd(notch_x-t4)
                cuboid([notch_d+t4, notch_w+2*t4, d2+t4], anchor=RIGHT+TOP+BACK);
            }
            
        }
        
        if (notch_x > 0) {
            color("red") right(w2+t4+e) down(d1-t3-e) fwd(notch_x)
            cuboid([notch_d, notch_w, d2], anchor=RIGHT+TOP+BACK);
        }
        if (cutout_for_hinge > 0) {
            fwd(notch_x + notch_w + cutout_for_hinge + e) down(d1-t3-e) right(w2-e) cuboid([t4+2*e, 54, d2+t3+2*e], anchor=LEFT+TOP+BACK);
        }
    }
}

// Trap door: outside corner, i.e. frame of the trap door
module outside_corner(l1, l2, t2_1, t2_2, w2_1, w2_2, w1_1, w1_2, notch_x, notch_w, notch_d, cutout_for_hinge, front, d1adjustment=0, hack="") {
    
    //d1adjustment = (front && t2_1 == 6) ? -2 : 0; // HACK: assume t2_1 is 6 for the right front corner
    
    screw_adjustment = hack == "FO1" ? -2 : 0;

    difference () {
        union() {
            outside_edging(l1, t2_1, w2_1, w1_1, [-l1/2+sd+screw_adjustment, l1/2-sd-t2_2+10+screw_adjustment], 0, 0, 0, 0, false, d1adjustment);
            zrot(90) xflip()
            outside_edging(l2, t2_2, w2_2, w1_2, [-l2/2+sd], notch_x, notch_w, notch_d, cutout_for_hinge, front, d1adjustment);
            if (aluminum_edge == 0) {
                up(tlvp+d1adjustment) right(t2_1) fwd(t2_2) cuboid([w1_1, w1_2, t1], chamfer=ch1, edges=TOP+LEFT+BACK, anchor=RIGHT+BOTTOM+FRONT);
            }
        }
        //if (aluminum_edge == 0) {
            fwd(w2_2-e) left(2*e) down(d1+e) cuboid([w2_1+e, t4+2*e, 100], anchor=LEFT+TOP+BACK);
            right(w2_1-e) back(2*e) down(d1+e) cuboid([t4+2*e, w2_2+e, 100], anchor=LEFT+TOP+BACK);
            if (front) {
                zrot(90) xflip()
                up(tlvp) right(t2_2) 
                color("blue") back(e) up(t1+d1adjustment+e) fwd(l2+e) left(w1_2+e) zrot(90) xrot(180) wedge([l2+2*e + 100, w1_2, t1-0.4]);
            }
        //}
    }
}


// Trap door: inside edging, i.e., trap door itself
module inside_edging(length, it2, iw2, iw1, screw_positions, bottom_chamfer, bar_cover_x, hinge_hole_x, bar_cover_border1, bar_cover_border2, minimal_edge, d1adjustment, hack="") {
    t5 = 1;
    l3 = 45;
    //w3 = 14;
    
    tlvp = tlvp + d1adjustment;
    
    screw_hole_vertical = (hack == "FI5") ? 1 : 0;
    
    difference() {
        union() {
            if (aluminum_edge == 0) {
                up(tlvp) left(it2)
                    if (minimal_edge) {
                        difference() {
                            cuboid([iw1, length, 1], anchor=LEFT+BOTTOM+BACK);
                            color("red") back(e) up(it1+e) right(iw1+e) zrot(-90) xrot(180) wedge([length+2*e, iw1-it2, it1-0.4]);
                        }
                    } else {
                        cuboid([iw1, length, it1], chamfer=ich1, edges=TOP+RIGHT, anchor=LEFT+BOTTOM+BACK);
                    }
            }
            cuboid([it2-aluminum_edge, length, tlvp], anchor=RIGHT+BOTTOM+BACK);
            diff()
                cuboid([it2-aluminum_edge, length, id1], anchor=RIGHT+TOP+BACK)
                    attach(LEFT) {
                        for (s = screw_positions) {
                            up(it2-aluminum_edge <= 1 ? 0.5 : 0) right(s) back(s > 0 ? screw_hole_vertical : 0) screw_hole("#8-32,1",head="flat",counterbore=0,anchor=TOP, $fn=fn);
                        }
                    }
            left(it2-aluminum_edge) down(id1) cuboid([iw2-aluminum_edge, length, it3], anchor=LEFT+TOP+BACK, chamfer=bottom_chamfer, edges=BOTTOM+RIGHT);
            if (bar_cover_x > 0) {
                fwd(bar_cover_x) left(t5) down(id1) cuboid([l3+t5, 38+2*t5, 19+t5], anchor=LEFT+TOP+BACK);
                fwd(bar_cover_x-bar_cover_border2+t5) left(t5) down(id1) cuboid([l3+t5, 38+bar_cover_border1+bar_cover_border2, t5], anchor=LEFT+TOP+BACK);
            }
        }
        if (bar_cover_x > 0) {
            fwd(bar_cover_x+t5) down(id1-e) right(e) cuboid([l3, 38, 19], anchor=LEFT+TOP+BACK);
        }
        if (hinge_hole_x > 0) {
            down(id1-e) right(iw2-it2-16) fwd(hinge_hole_x) cuboid([16, 15, it3+2*e], anchor=LEFT+TOP+BACK);
        }
    }

}

// for the back.
module inside_corner_back(l1, l2, it2_1, it2_2, iw2_1, iw2_2, iw1_1, iw1_2, notch_x, bar_cover_border1, bar_cover_border2) {
    difference() {
        union() {
            // corner of two edges
            inside_edging(l1, it2_1, iw2_1, iw1_1, [l1/2-sd, -l1/2+sd], 0, 0, 0, 0, 0, false, 0);
            down(id1+it3) cuboid([it2_1-aluminum_edge, it2_2-aluminum_edge, (aluminum_edge == 0 ? it1 : 0) +tlvp+id1+it3], anchor=RIGHT+FRONT+BOTTOM);
            zrot(90) xflip()
            inside_edging(l2, it2_2, iw2_2, iw1_2, [l2/2-sd, -l2/2+notch_x+38+sd, -l2/2+notch_x+38-sd], ich2, notch_x, 113, bar_cover_border1, bar_cover_border2, false, 0);
        }
    }
}

module inside_corner_front(l1, l2, it2_1, it2_2, iw2_1, iw2_2, iw1_1, iw1_2, notch_x, bar_cover_border1, bar_cover_border2, hack="") {
    difference() {
        union() {
            // corner of two edges
            side_screw_adjustment = (hack == "FI1" || hack == "FI7") ? -2 : 0;
            inside_edging(l1, it2_1, iw2_1, iw1_1, [l1/2-sd+side_screw_adjustment, -l1/2+sd+side_screw_adjustment], 0, 0, 0, 0, 0, false, 0);
            down(id1+it3) cuboid([it2_1-aluminum_edge, it2_2-aluminum_edge, (aluminum_edge == 0 ? 1 : 0)+tlvp+id1+it3], anchor=RIGHT+FRONT+BOTTOM);
            zrot(90) xflip()
            inside_edging(l2, it2_2, iw2_2, iw1_2, [l2/2-sd], ich2, notch_x, 0, bar_cover_border1, bar_cover_border2, true, 0);
        }
            
        color("green") up(tlvp+1+e) left(it2_1+e) back(e) prismoid(size1=[iw1_1+2*e, 0], size2=[iw1_1+2*e, iw1_2-it2_2], h=it1-1, shift=[0,-(iw1_2-it2_2)/2], anchor=LEFT+BACK+BOTTOM);
        
    }

}

// Trap door: beam cover on trap door itself
module beam_cover_endcap() {
    t5 = 1;
    l3 = 50;
    w3 = 12;
    
    difference() {
        union() {
            down(e) back(t5+e) left(t5) cuboid([38+2*t5, l3+t5, 19+t5], anchor=LEFT+TOP+BACK);
            left(t5) cuboid([w3, l3, t5], anchor=RIGHT+TOP+BACK);
            right(38+t5) cuboid([w3, l3, t5], anchor=LEFT+TOP+BACK);
        }
        cuboid([38, l3, 19], anchor=LEFT+TOP+BACK);
    }
    
    // temporary handle for opening the door
    /*
    back(e) down(20) cuboid([38, 2, 35], anchor=LEFT+BOTTOM+FRONT);
    up(6) zrot(-90) yrot(-90) prismoid(size1=[18, 38], size2=[0, 38], shift=[9, 0],  h=20, anchor=FRONT+BOTTOM);
    left(w3) up(13) cuboid([38+2*w3, 18, 3], anchor=FRONT+BOTTOM+LEFT);
    */
}


// Create a very thin but as large as possible sheet to act as a covering for ugly OSB. I eventually decided not to use this method but to use Cricut vinyl instead.
module paneling(w, h, j1, j2) {
    t = 0.4;
    maxh = 190;
    
    echo (h, j1);
    assert (h+j1 <= maxh);
    
    difference() {
        union() {
            cuboid([w, h, t]);
            back(h/2) prismoid([w, t], [0, t], j1, orient=BACK);
        }
        fwd(h/2) prismoid([w, t+2*e], [0, t+2*e], j1, orient=BACK);
    }
}

// --- function signatures for reference
/*
outside_edging(l1, t2, w2, w1, screw_positions, notch_x, notch_w, notch_d, cutout_for_hinge, minimal_edge, d1adjustment)
outside_corner(l1, l2, t2_1, t2_2, w2_1, w2_2, w1_1, w1_2, notch_x, notch_w, notch_d, cutout_for_hinge, front)
inside_edging(length, it2, iw2, iw1, screw_positions, bottom_chamfer, bar_cover_x, hinge_hole_x, bar_cover_border1, bar_cover_border2, minimal_edge, d1adjustment)
inside_corner_{back,front}(l1, l2, it2_1, it2_2, iw2_1, iw2_2, iw1_2, iw1_2, notch_x, bar_cover_border1, bar_cover_border2)
*/

// ------------------------------------------------------
// --- invocations
// ------------------------------------------------------

l0 = 160;


// Left edge inside: 3x175 + 170
// Note: for the 175 ones, I accidentally used 150 instead of 175 as the numerator for the screw hole positions. - wait, did I? - yes, in fact for all of them, including the 170 one
//inside_edging(175, 2, iw2-1, iw1+10, [150/2-sd, -150/2+sd], 0, 0, 0, 0, 0, false, 0); // x3
//right(50) inside_edging(170, 2, iw2-1, iw1+10, [150/2-sd, -150/2+sd], 0, 0, 0, 0, 0, false, 0);

// Left edge outside: 4x150 + 144
//outside_edging(150, 6, 19, w1, [-150/2+sd, 150/2-sd], 0, 0, 0, 0, false, 0);
//right(50) outside_edging(148, 6, 20, w1, [-150/2+sd, 150/2-sd], 0, 0, 0, 0, false, 0);
//right(100) outside_edging(144, 6, 20, w1, [-144/2+sd, 144/2-sd], 0, 0, 0, 0, false, 0);
//right(150) outside_edging(150, 7, 20, w1, [-150/2+sd, 150/2-sd], 0, 0, 0, 0, false, 0);
//right(200) outside_edging(150, 7, 21, w1, [-150/2+sd, 150/2-sd], 0, 0, 0, 0, false, 0);

// Right edge inside: 173 (with 175 screw positions), 175, 169, 175
//inside_edging(173, 3, iw2, iw1+10, [175/2-sd+1, -175/2+sd+1], 0, 0, 0, 0, 0, false, 0);
//right(50) inside_edging(175, 3, iw2, iw1+10, [175/2-sd, -175/2+sd], 0, 0, 0, 0, 0, false, 0);
//right(100) inside_edging(169, 3, iw2, iw1+10, [169/2-sd, -169/2+sd], 0, 0, 0, 0, 0, false, 0);
//right(150) inside_edging(175, 3, iw2, iw1+10, [175/2-sd, -175/2+sd], 0, 0, 0, 0, 0, false, 0);

// Right edge outside:
outside_edging(150, 7, 19, w1, [-150/2+sd, 150/2-sd], 0, 0, 0, 0, false, -1); // x2
right(50) outside_edging(140, 7, 19, w1, [-140/2+sd, 140/2-sd], 0, 0, 0, 0, false, 0);
//right(100) outside_edging(150, 6, 18, w1, [-150/2+sd, 150/2-sd], 0, 0, 0, 0, false, 0); // x2


// Front edge outside
/*
outside_corner(150, 150, 6, 12, w2_1, w2_2+1, w1, w1+10, notch_x, notch_w,  notch_d, 0, true, hack="FO1");

fwd(100) right(40) zrot(90) xflip()
outside_edging(125, 12, w2_2+1, w1+10, [-125/2+sd, 125/2-sd], 0, 0, 0, 0, true, 0);

fwd(100) right(200) zrot(90) xflip()
outside_edging(132, 12, w2_2+1, w1+10, [-133/2+sd, 133/2-sd], 0, 0, 0, 0, true, 0); // 132 vs 133 is intentional since I already screwed in the screws

right(170) zrot(90) xflip()
outside_edging(l0, 12, w2_2, w1+10, [-l0/2+sd, l0/2-sd], l0/2-notch_w/2, notch_w, notch_d+1, 0, true, 0, hack="FO4");

left(100)
fwd(200) right(140) zrot(90) xflip()
outside_edging(125, 12, w2_2-1, w1+10, [-125/2+sd, 125/2-sd], 0, 0, 0, 0, true, -2);

fwd(200) right(300) zrot(90) xflip()
outside_edging(123, 12, w2_2-1, w1+10, [-122/2+sd, 122/2-sd], 0, 0, 0, 0, true, -2);

right(500) xflip()
outside_corner(150, 150, 7, 12, w2_1, w2_2-2, w1, w1+10, notch_x, notch_w, notch_d, 0, true, d1adjustment=-2);
*/

// Front edge inside
/*
inside_corner_front(150, 150, 2, 10, iw2, iw2_back, iw1+10, iw1, 39, 14, 15, hack="FI1");

fwd(100) right(200) zrot(-90)
inside_edging(125, 9, iw2, iw1, [-125/2+sd, 125/2-sd], ich2, 0, 0, 0, 0, true, 0);

fwd(100) right(350) zrot(-90)
inside_edging(121, 8, iw2, iw1, [-121/2+sd, 121/2-sd], ich2, 0, 0, 0, 0, true, 0);

right(330) zrot(-90)
inside_edging(l0, 7, iw2, iw1, [-l0/2+sd, l0/2-sd], ich2, l0/2-38/2, 0, 14, 14, true, 0);

fwd(200) right(300) zrot(-90)
inside_edging(111, 7, iw2, iw1, [-111/2+sd, 111/2-sd], ich2, 0, 0, 0, 0, true, 0, hack="FI5"); // I think this one needs to be d1adjusted - hm, maybe just the left side?

fwd(200) right(450) zrot(-90)
inside_edging(125, 6, iw2, iw1, [-125/2+sd, 125/2-sd], ich2, 0, 0, 0, 0, true, 0); // Guessing on the d1 adjustment on this one - hm, maybe not

right(500) xflip()
inside_corner_front(150, 149, 3, 6, iw2, iw2_back, iw1+10, iw1, 37, 14, 15, hack="FI7");
*/

// Back edge outside
/*
outside_corner(l0, l0-2, 6, 7, 18, 29+6, w1, w1, notch_x, notch_w, 15, 13, false);

right(50) fwd(100) zrot(90) xflip()
outside_edging(120, 9, 30+6, w1, [-120/2+sd, 120/2-sd], 0, 0, 0, 0, false, 0);

right(180) fwd(100) zrot(90) xflip()
outside_edging(124, 9, 30+6, w1, [-124/2+sd, 124/2-sd], 0, 0, 0, 59, false, 0);

right(180) zrot(90) xflip()
outside_edging(l0, 9, 30+6, w1, [-l0/2+sd, l0/2-sd], l0/2-notch_w/2, notch_w, 15, 0, false, 0);

right(250) fwd(200) zrot(90) xflip()
outside_edging(121, 9, 30+6, w1, [-121/2+sd, 121/2-sd], 0, 0, 0, 6, false, 0);

right(380) fwd(200) zrot(90) xflip()
outside_edging(120, 9, 30+6, w1, [-120/2+sd, 120/2-sd], 0, 0, 0, 0, false, 0);

right(530) xflip()
outside_corner(l0, l0+1, 7, 7, 21, 30+6, w1, w1, 53, notch_w, 15, 9, false);
*/

// Back edge inside
/*
partition(spread=5, cutpath="flat", spin=90, size=[400, 400, 200])
left(78+e) inside_corner_back(l0, 77+l0, 3, 10, iw2, iw2_back-2, iw1+10, iw1+10, 38, 16, 15);

right(250) fwd(100) zrot(-90)
inside_edging(154, 10, iw2_back-2, iw1+10, [-154/2+sd, 154/2-sd], 0.75, 0, 32, 0, 0, false, 0);

right(350) zrot(-90)
inside_edging(l0, 10, iw2_back-2, iw1+10, [-l0/2+sd, l0/2-sd], 0.75, l0/2-20, 0, 14, 14, false, 0);

right(450) fwd(100) zrot(-90)
inside_edging(149, 10, iw2_back-2, iw1+10, [-149/2+sd, 149/2-sd], 0.75, 0, 109, 0, 0, false, 0);

right(550) xflip()
partition(spread=5, cutpath="flat", spin=90, size=[400, 400, 200])
left(81+e) inside_corner_back(l0, 80+l0, 2, 10, iw2, iw2_back-2, iw1+10, iw1+10, 41, 14, 15);
*/

//--- Near side of office side edging

//back(110-4+216+126) side_edging(126, 0, 0, [sd, 126-sd], true, false);
//back(110-4+216) side_edging(216, 0, 0, [sd, 216-sd]);

// The joint between the two types, welded together.
//back(110-4) side_edging(110, 0, 0, [sd]);
//side_edging(110, 11.5, 10.5, [110-sd]);

//fwd(110) side_edging(216, 10.5, 8, [sd, 216-sd]);
//fwd(326) side_edging(216, 8, 6, [sd, 216-sd]);
//fwd(542) side_edging(216, 6, 6, [sd, 216-sd]);
//fwd(758) side_edging(216, 6, 6, [sd, 216-sd]);
//fwd(974) side_edging(216, 6, 6, [sd, 216-sd]); // maybe it should have been 6, 6.5
//fwd(1190) side_edging(216, 6, 6, [sd, 216-sd]);
//fwd(1406) side_edging(170, 6, 6, [sd, 170-sd]); // 216 makes the next piece look bad, so shortening it a bit
//fwd(1576) side_edging(80, 6, 6, [sd, 80-sd], false, true);

// --- Far side of office side edging
//side_edging(216, 0, 0, [sd, 216-sd], true, false, true); // Need to cut out a notch manually (I didn't bother modeling it)
//side_edging(216, 0, 0, [sd, 216-sd], true, true, true); // x8
//side_edging(175, 0, 0, [sd, 175-sd], true, true, true);
//side_edging(179, 0, 0, [sd, 179-sd], false, true, true);


// --- Extra platform corners

// switch these and print two each, for the four corners
extra_platform_x = 155;
extra_platform_y = 180;

/*
difference() {
    union() {
        side_edging(extra_platform_x, 0, 0, [extra_platform_x-sd], true, false, true);
        right(extra_platform_y) zrot(-90) side_edging(extra_platform_y, 0, 0, [sd], false, true, true);
        up(4) cuboid([3, 3, 19+6+2+ 4], anchor=RIGHT+TOP+FRONT);
    }
    back(4+e) left(3) rounding_edge_mask(l=100+2*e, r=t1, anchor=TOP+BACK, $fn=fn, orient=BACK);
    left(4+e) back(3) right(100) zrot(-90) rounding_edge_mask(l=100+2*e, r=t1, anchor=TOP+BACK, $fn=fn, orient=BACK);
 
    left(3) back(3) down(19+6+2) chamfer_corner_mask(chamfer=3);

    left(3) back(3) zrot(-90) rounding_edge_mask(l=100, r=t1, $fn=fn);
}
*/


//side_edging(180, 0, 0, [sd, 180-sd], true, true, true); // x3 x2
//side_edging(192, 0, 0, [sd, 192-sd], true, true, true); // x1 x2
//side_edging(155, 0, 0, [sd, 155-sd], true, true, true); // x1 x2
//side_edging(155, 0, 0, [sd, 155-sd], true, true, true); // x2 x2
//side_edging(163, 0, 0, [sd, 163-sd], true, true, true); // x1
//side_edging(162, 0, 0, [sd, 162-sd], true, true, true); // x1





//joint test
/*
fwd(-20) side_edging(10, 0, 0, []);
fwd(0) side_edging(10, 0, 0, []);
fwd(20) side_edging(10, 10.5, 10.5, []);
fwd(40) side_edging(10, 10.5, 10.5, []);
*/

/*
// h test
lg = 15;
side_edging(lg, 11, 11, []);
back(30) side_edging(lg, 10, 10, []);
back(60) side_edging(lg, 9, 9, []);
back(90) side_edging(lg, 8, 8, []);
back(120) side_edging(lg, 7, 7, []);
back(150) side_edging(lg, 6, 6, []);
back(180) side_edging(lg, 5, 5, []);
back(210) side_edging(lg, 4, 4, []);
*/