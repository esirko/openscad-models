include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <BOSL2/walls.scad>

e = 0.1;
pad = 20;
zh = 20;
slop = 0.2;
fn = 36;


left(100) fwd(0) union() {
    right(pad) cuboid([35+pad, 35, 32.5], anchor=BOTTOM+FRONT+RIGHT);
    fwd(pad) cuboid([36.5, 35+pad, 32.5], anchor=BOTTOM+FRONT+RIGHT);
    
    //up(50) right(pad) cuboid([35+pad, 35, zh+8], anchor=BOTTOM+FRONT+RIGHT);
    //up(50) fwd(pad) cuboid([35, 35+pad, zh+8], anchor=BOTTOM+FRONT+RIGHT);
}

left(100) fwd(100) union() {
    color("red") right(pad) cuboid([34+pad, 93, 31], anchor=BOTTOM+BACK+RIGHT);
    back(pad) cuboid([34, 93+pad, 31], anchor=BOTTOM+BACK+RIGHT);
    
    //up(50) right(pad) cuboid([32+pad, 87, zh+8], anchor=BOTTOM+BACK+RIGHT);
    //up(50) back(pad) cuboid([32, 87+pad, zh+8], anchor=BOTTOM+BACK+RIGHT);
}

lrx = 43;
lry = 82;

left(0) fwd(100) union() {
    left(pad) cuboid([lrx+pad, lry, zh], anchor=BOTTOM+BACK+LEFT);
    back(pad) cuboid([lrx, lry+pad, zh], anchor=BOTTOM+BACK+LEFT);
}

urzh = 81;
urx = 40;
ury = 42;
urs = 16;
split = 20;
hh = urzh-zh;

difference() {
    union() {
        // bottom piece
        left(pad) cuboid([urx+pad, ury, zh], anchor=BOTTOM+FRONT+LEFT);
        fwd(pad) cuboid([urx, ury+pad, zh], anchor=BOTTOM+FRONT+LEFT);
        
        // top piece
        up(split+zh) back(ury-38) right(urx) cuboid([urs, 38, urzh - zh], anchor=BOTTOM+FRONT+RIGHT, rounding=2, edges=[LEFT, "X"], except=BACK, $fn=fn);

        // legs of top piece
        right(30) back(10) up(split+zh) cuboid([5-slop, 5-slop, 10], anchor=TOP+FRONT+LEFT);
        right(30) back(30) up(split+zh) cuboid([5-slop, 5-slop, 10], anchor=TOP+FRONT+LEFT);
        
        // screw plate
        diff() 
        color("red") right(urx) back(ury-63) up(split+zh+15) cuboid([4, 30, 30], anchor=BOTTOM+FRONT+RIGHT, rounding=2, edges=LEFT, except=BACK, $fn=fn)
            attach(LEFT)
                screw_hole("#8-32,1",head="flat",counterbore=0,anchor=TOP, $fn=fn);
    }
    // angular cut of bottom piece
    fwd(e) down(e) left(pad+e) xrot(-90) prismoid([10, zh+2*e], [urx+pad-urs, zh+2*e], shift=[(urx+pad-urs-10)/2, 0], h = ury+2*e, anchor=BOTTOM+BACK+LEFT);

    // cutouts for electronics
    up(urzh+split+e) right(urx) back(ury) 
    union() {
        left(2) fwd(2) cuboid([8, 8, 2], anchor=TOP+BACK+RIGHT);
        right(2+e) fwd(2) down(4) cuboid([urs, 38-4, urzh - zh - 10], anchor=TOP+BACK+RIGHT);

        // holes for wire of hall sensor
        down(4) left(8.5) fwd(9) cuboid([1, 1, 10]);
        down(4) left(6.) fwd(9) cuboid([1, 1, 10]);
        down(4) left(3.5) fwd(9) cuboid([1, 1, 10]);
        
        // window for wires coming out to go to the smurf tube
        down(urzh-zh-19) fwd(4) cuboid([30, 15, 11], anchor=TOP+BACK+RIGHT);

    }

    // holes for legs in bottom piece for top piece to insert into
    right(30) back(10) up(zh+e) cuboid([5, 5, 10], anchor=TOP+FRONT+LEFT);
    right(30) back(30) up(zh+e) cuboid([5, 5, 10], anchor=TOP+FRONT+LEFT);
}
