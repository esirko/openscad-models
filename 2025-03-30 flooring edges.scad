include <BOSL2/std.scad>
include <BOSL2/joiners.scad>
include <BOSL2/screws.scad>

// trap door edging pieces

e = 0.01;
fn = 36;

    t1 = 3;
    t3 = 1;
    t4 = 1;
    w1 = 20;
    l1 = 80; //150;
    l2 = 100; //150;
    tlvp = 6; // thickness of LVP
    d1 = 19;
    d2 = 20;
    
    ch1 = 1.5;
    
    t2_1 = 5;
    w2_1 = 19;
    t2_2 = 14;
    w2_2 = 42;
            
    notch_w = 45;
    notch_d = 20;
    notch_x = 47;
    
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
   

module outside_edging(t1, t2, t3, t4, w1, w2, l1, d1, d2, ch1) {
    
    union() {
        up(tlvp) right(t2) cuboid([w1, l1, t1], chamfer=ch1, edges=TOP+LEFT, anchor=RIGHT+BOTTOM+BACK);
        cuboid([t2, l1, tlvp], anchor=LEFT+BOTTOM+BACK);
        diff()
            cuboid([t2, l1, d1], anchor=LEFT+TOP+BACK)
                attach(RIGHT)
                    screw_hole("#8-32,1/2",head="flat",counterbore=0,anchor=TOP, $fn=fn);
        down(d1) cuboid([w2, l1, t3], anchor=LEFT+BOTTOM+BACK);
        right(w2) down(d1-t3) cuboid([t4, l1, d2+t3], anchor=LEFT+TOP+BACK);
    }
}

module outside_corner() {

    difference () {
        union() {
            outside_edging(t1, t2_1, t3, t4, w1, w2_1, l1, d1, d2, ch1);
            up(tlvp) right(t2_1) fwd(t2_2) cuboid([w1, w1, t1], chamfer=ch1, edges=TOP, anchor=RIGHT+BOTTOM+FRONT);
            zrot(90) xflip()
            outside_edging(t1, t2_2, t3, t4, w1, w2_2, l2, d1, d2, ch1);
            
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

module edging2(l) {

    h = 19+5;
    t1 = 2;
    x1 = 15;
    t2 = 3;
    t3 = 3;
    x2 = 20;
    r1 = 1;
    r2 = 3;
    ch1 = 1.5;
    ch2 = 2.5;

    jh = 5;
    jw1 = 10;
    jt1 = 1;
    jw2 = 11;
    jw3 = 12;
    jt3 = 1.5;
    jr1 = t2/2;
    jr3 = t2/2;
    

    front_half() partition(spread=20, cutsize=x1/2, cutpath="sawtooth")
    fwd(l+x1/2)
    back_half() partition(spread=20, cutsize=x1/2, cutpath="sawtooth")
    union() {
        fwd(l/2) cuboid([x1, 2*l, t1], chamfer=ch1, edges=TOP+RIGHT, anchor=FRONT+LEFT+TOP);
        down(t1+h) fwd(l/2) cuboid([x2, 2*l, t3], chamfer=ch2, edges=BOTTOM+RIGHT, anchor=FRONT+LEFT+TOP);
    }

    down(t1) yrot(90)
    front_half() partition(spread=20, cutsize=h/4, gap=13, cutpath="dovetail")
    fwd(l+x1/2)
    back_half() partition(spread=20, cutsize=h/4, gap=13, cutpath="dovetail")
    fwd(l/2) cuboid([h, 2*l, t2], anchor=FRONT+LEFT+BOTTOM);
 
}


module edging(l) {
    h = 19+5;
    t1 = 2;
    x1 = 15;
    t2 = 3;
    t3 = 3;
    x2 = 20;
    r1 = 1;
    r2 = 3;
    ch1 = 1.5;
    ch2 = 2.5;

    jh = 5;
    jw1 = 10;
    jt1 = 1;
    jw2 = 11;
    jw3 = 12;
    jt3 = 1.5;
    jr1 = t2/2;
    jr3 = t2/2;

    difference() {
        union() {
            // top main piece
            back(jh) cuboid([x1, l, t1], chamfer=ch1, edges=TOP+RIGHT, anchor=FRONT+LEFT+TOP);
            // first try - 1mm protrusion addition
            //right(jr1) down(t1-jt1) cuboid([jw1, jh, jt1], anchor=FRONT+LEFT+TOP);
            // second try - triangular surface protrusion addition
            back(jh) 
            rounded_prism([[0, jh], [x1/2, 0], [x1, jh]], height=t1, anchor=FRONT+LEFT+TOP);
        
            diff("remove")
            down(t1) cuboid([t2, l, h], anchor=FRONT+LEFT+TOP) {
                attach(BACK) dovetail("male", slide=t2, width=jw2, height=jh, spin=90);
                tag("remove") attach(FRONT) dovetail("female", slide=t2, width=jw2, height=jh, spin=90);
            }
            
            back(jh) down(t1+h) cuboid([x2, l, t3], chamfer=ch2, edges=BOTTOM+RIGHT, anchor=FRONT+LEFT+TOP);
            // first try
            //down(h+t1) right(jr3) cuboid([jw3, jh, jt3], anchor=FRONT+LEFT+TOP);
            // second try
            // ...
        }
        
        // first try - 1mm protrusion subtraction
        //down(e) back(e) back(l) right(jr1) down(t1-jt1) cuboid([jw1, jh, jt1], anchor=FRONT+LEFT+TOP);
        
        // second try - triangular surface protrusion addition
        back(l+jh) up(e) rounded_prism([[0, jh-e], [x1/2, 0], [x1, jh+e]], height=t1+2*e, anchor=FRONT+LEFT+TOP);

        // first try
        //up(e) back(e) back(l) down(h+t1) right(jr3) cuboid([jw3, jh, jt3], anchor=FRONT+LEFT+TOP);
        // second try
        // ...

        fwd(e) yrot(90) xrot(90) rounding_edge_mask(l=l+jh+2*e, r=r1, excess=1, $fn=fn, anchor=TOP);
        fwd(e) down(t1+h+t3) xrot(90) rounding_edge_mask(l=l+jh+2*e, r=r2, excess=1, $fn=fn, anchor=TOP);
        
    }

    
    // TODO: there will be varying degrees of protrusion of the LVP and the subfloor, so we want a "buffer" to butt up against them, and have that buffer be variable and specifyable.
    // TODO: need corner pieces
}

// This was an attempt to create a very thin but as large as possible sheet to act as a covering for ugly OSB. I eventually decided not to use this method but to use Cricut vinyl instead.
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



outside_corner();

l_80 = 80;
fwd(160) outside_edging(t1, t2_1, t3, t4, w1, w2_1, l_80, d1, d2, ch1);

right(160) zrot(90) xflip()
outside_edging(t1, t2_2, t3, t4, w1, w2_2, l_80, d1, d2, ch1);

//beam_cover_endcap();



