include <BOSL2/std.scad>


e = 0.01;
fn = 36;
fn2 = 36;

gr = 15;   // radius of syringe body
gp = 17.5; // radius of top of syringe plunger
gf = 14;  // radius of fin-part of plunger

bgt = 8; // body-part grip thickness
pgt = 6; // plunger-part grip thickness
bt = 2.5; // body-part thickness
pt = 2; // plunger-part thickness

ft = 1; // flange extra thickness added to body-part grip thickness on one side




difference() {
    union() {
        diff()
        cuboid([70, 30, bgt], rounding=2, edges="Y", $fn=fn) {
            fwd(10) color("#004400") prismoid(size1=[70, bgt], size2=[70, bgt+ft], h=5 , $fn=fn, anchor=BOTTOM, orient=FRONT)
                attach([BACK+RIGHT, FRONT+RIGHT, BACK+LEFT, FRONT+LEFT], LEFT+FRONT, inside=true) rounding_edge_mask(r=2, l=10.9);
            attach(BACK) down(e) color("#00aa00") prismoid(size1=[70, bgt], size2=[60, bgt], h=6, rounding=2, anchor=BOTTOM) // the down(e) prevents the thing from being separate objects
                attach([TOP+FRONT, TOP+BACK, TOP+RIGHT, TOP+LEFT], LEFT+FRONT, inside=true) rounding_edge_mask(r=2);
            attach(FRONT) color("#00ff00") prismoid(size1=[70, bgt+ft], size2=[60, bgt+ft], h=6, rounding=2, anchor=BOTTOM)
                attach([TOP+FRONT, TOP+BACK, ], LEFT+FRONT, inside=true) rounding_edge_mask(r=2);
        }
    }
    
    // cutouts to the slotted part
    union() {
        cyl(r=gr, h=bgt+1, $fn=fn2);
        cuboid([2*gr, 40, bgt+ft+1], anchor=BACK);
        
        color("red") back(9) prismoid(size1=[45, bt], size2=[22, bt], h=8, orient =BACK);
        color("pink") back(9) cuboid([45, 50, bt], anchor=BACK);
        color("blue") fwd(9+e) prismoid(size1=[45, bt], size2=[60, bt+ft+3], h=12, orient=FRONT);
    }
    
    //up(0) cuboid([200, 200, 200], anchor=BOTTOM);
}

fff = 12;
sss = 22;
rrr = 1.5;

up(  bt/2 + rrr - 0.25 ) fwd(fff) left( sss) zrot(-20) cyl(r=rrr, h=12, $fn=fn, rounding=rrr, orient=RIGHT);
up(  bt/2 + rrr - 0.25 ) fwd(fff) left(-sss) zrot( 20) cyl(r=rrr, h=12, $fn=fn, rounding=rrr, orient=RIGHT);
up(-(bt/2 + rrr - 0.25)) fwd(fff) left( sss) zrot(-20) cyl(r=rrr, h=12, $fn=fn, rounding=rrr, orient=RIGHT);
up(-(bt/2 + rrr - 0.25)) fwd(fff) left(-sss) zrot( 20) cyl(r=rrr, h=12, $fn=fn, rounding=rrr, orient=RIGHT);




right(100) {
difference() {
    union() {
        cyl(r=30, h=pgt, rounding=2, $fn=fn2);
        back(15) diff() prismoid(size1=[44.5, pgt], size2=[23.5, pgt], h=10.5, $fn=fn, rounding=2, anchor=BOTTOM, orient=BACK)
            attach([TOP+FRONT, TOP+BACK, TOP+RIGHT, TOP+LEFT], LEFT+FRONT, inside=true) rounding_edge_mask(r=2);
    }

    union() {
        cyl(r=gp, h=pt, $fn=fn);
        cuboid([2*gp, 40, pt], anchor=BACK);
        back(9) cuboid([19, 40, pgt+1], anchor=BACK+BOTTOM);
        
        color("blue") fwd(15+e) prismoid(size1=[2*gp, bt], size2=[45, bt+ft+2], shift=[0, -1], h=6, orient=FRONT);
        
        fwd(20+e) cuboid([50, 50, 50], anchor=BACK);
        down(2) back(23+e) cuboid([50, 50, pgt+4+2*e], anchor=FRONT);

        up(2) back(23+2*e) prismoid(size1=[60, 0], size2=[60, 4], shift=[0, 2], h=15, anchor=TOP, orient=BACK);
        
        fwd(20+e) right(9.5) rounding_edge_mask(r=8, l=10, anchor=BOTTOM);
        fwd(20+e) left(9.5) zrot(90) rounding_edge_mask(r=8, l=11, anchor=BOTTOM);
     }
    
    //cuboid([200, 200, 200], anchor=BOTTOM);
}

down(2) fwd(8) diff() prismoid(size1=[54, 0], size2=[44, 3], shift=[0,-1.5], h=14, $fn=fn, anchor=BOTTOM, orient=FRONT)
    attach([TOP+FRONT, TOP+BACK, TOP+RIGHT, TOP+LEFT, RIGHT+FRONT, LEFT+FRONT, RIGHT+BACK, LEFT+BACK], LEFT+FRONT, inside=true) rounding_edge_mask(r=2);

down(2.25) back(24) diff() prismoid(size1=[58, 0], size2=[38, 6], shift=[0,-.5], h=14, $fn=fn, anchor=TOP, orient=BACK)
    attach([TOP+FRONT, TOP+BACK, TOP+RIGHT, TOP+LEFT, RIGHT+FRONT, LEFT+FRONT, RIGHT+BACK, LEFT+BACK], LEFT+FRONT, inside=true) rounding_edge_mask(r=2);
}

