include <BOSL2/std.scad>
include <BOSL2/joiners.scad>
include <BOSL2/screws.scad>

// Globals
e = 0.01;
fn = 36;
sd = 20; // Distance from screwhole to edge of piece

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
ich1 = ch1-1;
ich2 = 0.75;
extra_ledge = false;

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

// Trap door: outside edging, i.e. frame of the trap door
module outside_edging(l1, t2, w2, w1, screw_positions, notch_x, notch_w, notch_d, cutout_for_hinge) {
    
    difference() {
        union() {
            up(tlvp) right(t2) cuboid([w1, l1, t1], chamfer=ch1, edges=TOP+LEFT, anchor=RIGHT+BOTTOM+BACK);
            cuboid([t2, l1, tlvp], anchor=LEFT+BOTTOM+BACK);
            diff()
                cuboid([t2, l1, d1], anchor=LEFT+TOP+BACK)
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
module outside_corner(l1, l2, t2_1, t2_2, w2_1, w2_2, w1_1, w1_2, notch_x, notch_w, notch_d, cutout_for_hinge) {
    
    difference () {
        union() {
            outside_edging(l1, t2_1, w2_1, w1_1, [-l1/2+sd, l1/2-sd-t2_2+10], 0, 0, 0, 0);
            up(tlvp) right(t2_1) fwd(t2_2) cuboid([w1_1, w1_2, t1], chamfer=ch1, edges=TOP+LEFT+BACK, anchor=RIGHT+BOTTOM+FRONT);
            zrot(90) xflip()
            outside_edging(l2, t2_2, w2_2, w1_2, [-l2/2+sd], notch_x, notch_w, notch_d, cutout_for_hinge);
        }
        
        fwd(w2_2-e) left(2*e) down(d1+e) cuboid([w2_1+e, t4+2*e, 100], anchor=LEFT+TOP+BACK);
        right(w2_1-e) back(2*e) down(d1+e) cuboid([t4+2*e, w2_2+e, 100], anchor=LEFT+TOP+BACK);
    }
}


// Trap door: inside edging, i.e., trap door itself
module inside_edging(length, it2, iw2, iw1, screw_positions, bottom_chamfer, bar_cover_x, hinge_hole_x, bar_cover_border1, bar_cover_border2) {
    t5 = 1;
    l3 = 45;
    //w3 = 14;
    
    difference() {
        union() {
            up(tlvp) left(it2) cuboid([iw1, length, it1], chamfer=ich1, edges=TOP+RIGHT, anchor=LEFT+BOTTOM+BACK);
            cuboid([it2, length, tlvp], anchor=RIGHT+BOTTOM+BACK);
            if (extra_ledge) {
                left(it2) cuboid([it2+10, length, 1], anchor=LEFT+BOTTOM+BACK);
            }
            diff()
                cuboid([it2, length, id1], anchor=RIGHT+TOP+BACK)
                    attach(LEFT) {
                        for (s = screw_positions) {
                            right(s) screw_hole("#8-32,1",head="flat",counterbore=0,anchor=TOP, $fn=fn);
                        }
                    }
            left(it2) down(id1) cuboid([iw2, length, it3], anchor=LEFT+TOP+BACK, chamfer=bottom_chamfer, edges=BOTTOM+RIGHT);
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
            inside_edging(l1, it2_1, iw2_1, iw1_1, [l1/2-sd, -l1/2+sd], 0, 0, 0, 0, 0);
            down(id1+it3) cuboid([it2_1, it2_2, it1+tlvp+id1+it3], anchor=RIGHT+FRONT+BOTTOM);
            zrot(90) xflip()
            inside_edging(l2, it2_2, iw2_2, iw1_2, [l2/2-sd, -l2/2+notch_x+38+sd, -l2/2+notch_x+38-sd], ich2, notch_x, 113, bar_cover_border1, bar_cover_border2);
        }
    }
}

module inside_corner_front(l1, l2, it2_1, it2_2, iw2_1, iw2_2, iw1_1, iw1_2, notch_x, bar_cover_border1, bar_cover_border2) {
    difference() {
        union() {
            // corner of two edges
            inside_edging(l1, it2_1, iw2_1, iw1_1, [l1/2-sd, -l1/2+sd], 0, 0, 0, 0, 0);
            down(id1+it3) cuboid([it2_1, it2_2, it1+tlvp+id1+it3], anchor=RIGHT+FRONT+BOTTOM);
            zrot(90) xflip()
            inside_edging(l2, it2_2, iw2_2, iw1_2, [l2/2-sd], ich2, notch_x, 0, bar_cover_border1, bar_cover_border2);
        }
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
outside_edging(l1, t2, w2, w1, screw_positions, notch_x, notch_w, notch_d, cutout_for_hinge)
outside_corner(l1, l2, t2_1, t2_2, w2_1, w2_2, w1_1, w1_2, notch_x, notch_w, notch_d, cutout_for_hinge)
inside_edging(length, it2, iw2, iw1, screw_positions, bottom_chamfer, bar_cover_x, hinge_hole_x, bar_cover_border1, bar_cover_border2)
inside_corner_{back,front}(l1, l2, it2_1, it2_2, iw2_1, iw2_2, iw1_2, iw1_2, notch_x, bar_cover_border1, bar_cover_border2)
*/

// ------------------------------------------------------
// --- invocations
// ------------------------------------------------------

l0 = 160;


// Front edge outside
/*
outside_corner(150, 150, 7, 17, w2_1, w2_2+1, w1, w1+10, notch_x, notch_w,  notch_d, 0);

fwd(100) right(40) zrot(90) xflip()
outside_edging(125, 15, w2_2+1, w1+10, [-125/2+sd, 125/2-sd], 0, 0, 0, 0);

fwd(100) right(200) zrot(90) xflip()
outside_edging(133, 15, w2_2+1, w1+10, [-133/2+sd, 133/2-sd], 0, 0, 0, 0);

right(170) zrot(90) xflip()
outside_edging(l0, 15, w2_2, w1+10, [-l0/2+sd, l0/2-sd], l0/2-notch_w/2, notch_w, notch_d+1, 0);

fwd(200) right(140) zrot(90) xflip()
outside_edging(125, 15, w2_2-1, w1+10, [-125/2+sd, 125/2-sd], 0, 0, 0, 0);

fwd(200) right(300) zrot(90) xflip()
outside_edging(123, 15, w2_2-1, w1+10, [-122/2+sd, 122/2-sd], 0, 0, 0, 0);

right(500) xflip()
outside_corner(150, 150, 6, 15, w2_1, w2_2-2, w1, w1+10, notch_x, notch_w, notch_d, 0);
*/

// Front edge inside

//inside_corner_front(150, 150, 3, 3, iw2, iw2_back, iw1, iw1, 39, 14, 15);

//fwd(100) right(200) zrot(-90)
inside_edging(125, it2, iw2, iw1, [-125/2+sd, 125/2-sd], 0.75, 0, 0, 0, 0);

//fwd(100) right(350) zrot(-90)
//inside_edging(121, it2, iw2, iw1, [-121/2+sd, 121/2-sd], 0.75, 0, 0, 0, 0);

//right(330) zrot(-90)
//inside_edging(l0, it2, iw2, iw1, [-l0/2+sd, l0/2-sd], 0.75, l0/2-38/2, 0, 14, 14);

//fwd(200) right(300) zrot(-90)
//inside_edging(125, it2, iw2, iw1, [-125/2+sd, 125/2-sd], 0.75, 0, 0, 0, 0);

//fwd(200) right(450) zrot(-90)
//inside_edging(111, it2, iw2, iw1, [-111/2+sd, 111/2-sd], 0.75, 0, 0, 0, 0);

//right(500) xflip()
//inside_corner_front(150, 150, 3, 3, iw2, iw2_back, iw1, iw1, 37, 14, 15);


// Back edge outside
/*
outside_corner(l0, l0-2, 6, 2, 18, 28+7, w1, w1, notch_x, notch_w, 15, 13);

right(50) fwd(100) zrot(90) xflip()
outside_edging(120, 2, 30+7, w1, [-120/2+sd, 120/2-sd], 0, 0, 0, 0);

right(180) fwd(100) zrot(90) xflip()
outside_edging(124, 2, 30+7, w1, [-124/2+sd, 124/2-sd], 0, 0, 0, 59);

right(180) zrot(90) xflip()
outside_edging(l0, 2, 30+7, w1, [-l0/2+sd, l0/2-sd], l0/2-notch_w/2, notch_w, 15, 0);

right(250) fwd(200) zrot(90) xflip()
outside_edging(121, 2, 30+7, w1, [-121/2+sd, 121/2-sd], 0, 0, 0, 6);

right(380) fwd(200) zrot(90) xflip()
outside_edging(120, 2, 30+7, w1, [-120/2+sd, 120/2-sd], 0, 0, 0, 0);

right(530) xflip()
outside_corner(l0, l0+1, 6, 2, 21, 29+7, w1, w1, 53, notch_w, 15, 9);
*/

// Back edge inside
/*
partition(spread=5, cutpath="flat", spin=90, size=[400, 400, 200])
left(78+e) inside_corner_back(l0, 77+l0, 3, 12+7, iw2, iw2_back+7, iw1+10, iw1+10, 38, 16, 15);

//right(250) fwd(100) zrot(-90)
//inside_edging(154, 12+7, iw2_back+7, iw1+10, [-154/2+sd, 154/2-sd], 0.75, 0, 32, 0, 0);

//right(350) zrot(-90)
//inside_edging(l0, 12+7, iw2_back+7, iw1+10, [-l0/2+sd, l0/2-sd], 0.75, l0/2-20, 0, 14, 14);

//right(450) fwd(100) zrot(-90)
//inside_edging(149, 12+7, iw2_back+7, iw1+10, [-149/2+sd, 149/2-sd], 0.75, 0, 109, 0, 0);

right(550) xflip()
partition(spread=5, cutpath="flat", spin=90, size=[400, 400, 200])
left(81+e) inside_corner_back(l0, 80+l0, 3, 12+7, iw2, iw2_back+7, iw1+10, iw1+10, 41, 14, 15);
*/



//front_edging(175, [-175/2+sd, 175/2-sd]);



