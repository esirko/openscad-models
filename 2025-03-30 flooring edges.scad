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
tlvp = 6 + 1.5; // thickness of LVP + underlayment
d1 = 19;
d2 = 20;
ch1 = 2.5;

t2_1 = 6;
w2_1 = 19;
t2_2 = 15;
w2_2 = 42;
        
notch_w = 45;
notch_d = 20;
notch_x = 47;
    
// Inner edging parameters
iw1 = w1; // unlikely to be different from w1
it1 = t1-1;
id1 = 18;
it2 = 3;
it3 = 1;
iw2 = 30;
ich1 = ch1-1;
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
                    right(s) screw_hole("#8-32,1/2",head="flat",counterbore=0,anchor=TOP, $fn=fn);
                }
            }
}

// Trap door: outside edging, i.e. frame of the trap door
module outside_edging(t2, w2, l1, screw_positions) {
    union() {
        up(tlvp) right(t2) cuboid([w1, l1, t1], chamfer=ch1, edges=TOP+LEFT, anchor=RIGHT+BOTTOM+BACK);
        cuboid([t2, l1, tlvp], anchor=LEFT+BOTTOM+BACK);
        diff()
            cuboid([t2, l1, d1], anchor=LEFT+TOP+BACK)
                attach(RIGHT)
                    for (s = screw_positions) {
                        right(s) screw_hole("#8-32,1/2",head="flat",counterbore=0,anchor=TOP, $fn=fn);
                    }
        down(d1) cuboid([w2, l1, t3], anchor=LEFT+BOTTOM+BACK);
        right(w2) down(d1-t3) cuboid([t4, l1, d2+t3], anchor=LEFT+TOP+BACK);
    }
}

// Trap door: outside corner, i.e. frame of the trap door
module outside_corner(l1, l2) {
    difference () {
        union() {
            outside_edging(t2_1, w2_1, l1, [-l1/2+sd, l1/2-sd-t2_2+10]);
            up(tlvp) right(t2_1) fwd(t2_2) cuboid([w1, w1, t1], chamfer=ch1, edges=TOP, anchor=RIGHT+BOTTOM+FRONT);
            zrot(90) xflip()
            outside_edging(t2_2, w2_2, l2, [-l2/2+sd]);
            
            fwd(w2_2+t4-e) down(d1-t3+e) right(notch_x-t4)
            color("red")
            cuboid([notch_w+2*t4, notch_d+t4, d2+t4], anchor=LEFT+TOP+FRONT);
        }
        
        fwd(w2_2-e) left(2*e) down(d1+e) cuboid([w2_1+e, t4+2*e, 100], anchor=LEFT+TOP+BACK);
        right(w2_1-e) back(2*e) down(d1+e) cuboid([t4+2*e, w2_2+e, 100], anchor=LEFT+TOP+BACK);
        
        fwd(w2_2+t4+e) down(d1-t3-e) right(notch_x)
        color("red")
        cuboid([notch_w, notch_d, d2], anchor=LEFT+TOP+FRONT);
    }
}


// Trap door: inside edging, i.e., trap door itself
module inside_edging(length, screw_positions) {
    up(tlvp) left(it2) cuboid([iw1, length, it1], chamfer=ich1, edges=TOP+RIGHT, anchor=LEFT+BOTTOM+BACK);
    cuboid([it2, length, tlvp], anchor=RIGHT+BOTTOM+BACK);
    diff()
        cuboid([it2, length, id1], anchor=RIGHT+TOP+BACK)
            attach(LEFT) {
                for (s = screw_positions) {
                    right(s) screw_hole("#8-32,1/2",head="flat",counterbore=0,anchor=TOP, $fn=fn);
                }
                
            }
    left(it2) down(id1) cuboid([iw2, length, it3], anchor=LEFT+TOP+BACK, chamfer=ich2, edges=BOTTOM+RIGHT);
}

module inside_corner(l1, l2) {
    inside_edging(l1, [-l1/2+sd, l1/2-sd]);
    down(id1+it3) cuboid([it2, it2, it1+tlvp+id1+it3], anchor=RIGHT+FRONT+BOTTOM);
    zrot(90) xflip()
    inside_edging(l2, [l2/2-sd]);
}

// Trap door: beam cover on trap door itself
module beam_cover_endcap() {
    t5 = 1;
    l3 = 50;
    w3 = 20;
    
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

// ------------------------------------------------------
// --- invocations
// ------------------------------------------------------

l0 = 180;

outside_corner(150, 150);

fwd(160) outside_edging(t2_1, w2_1, l0, [-l0/2+sd, l0/2-sd]);

right(160) zrot(90) xflip()
outside_edging(t2_2, w2_2, l0, [-l0/2+sd, l0/2-sd]);

right(120) fwd(120)
inside_edging(l0, [-l0/2+sd, l0/2-sd]);

right(60) fwd(60)
inside_corner(l0, l0);


//front_edging(175, [-175/2+sd, 175/2-sd]);

//beam_cover_endcap();


