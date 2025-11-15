include <BOSL2/std.scad>


e = 0.01;
fn=36;

gr = 15;   // radius of syringe body
gp = 17.5; // radius of top of syringe plunger
gf = 14;  // radius of fin-part of plunger

bgt = 8; // body-part grip thickness
pgt = 6; // plunger-part grip thickness
bt = 2.5; // body-part thickness
pt = 2; // plunger-part thickness

ft = 2; // flange extra thickness added to body-part grip thickness on one side




difference() {
    union() {
        diff()
        cuboid([70, 30, bgt], rounding=2, edges="Y", $fn=fn) {
            fwd(10) color("#004400") prismoid(size1=[70, bgt], size2=[70, bgt+ft], h=5 , $fn=fn, anchor=BOTTOM, orient=FRONT)
                attach([BACK+RIGHT, FRONT+RIGHT, BACK+LEFT, FRONT+LEFT], LEFT+FRONT, inside=true) rounding_edge_mask(r=2, l=10.9);
            attach(BACK) down(e) color("#00aa00") prismoid(size1=[70, bgt], size2=[35, bgt], h=6, anchor=BOTTOM) // the down(e) prevents the thing from being separate objects
                attach([TOP+FRONT, TOP+BACK, LEFT+FRONT, LEFT+BACK, RIGHT+FRONT, RIGHT+BACK], LEFT+FRONT, inside=true) rounding_edge_mask(r=2);
            attach(FRONT) color("#00ff00") prismoid(size1=[70, bgt+ft], size2=[35, bgt+ft], h=6, anchor=BOTTOM)
                attach([TOP+FRONT, TOP+BACK, LEFT+FRONT, LEFT+BACK, RIGHT+FRONT, RIGHT+BACK], LEFT+FRONT, inside=true) rounding_edge_mask(r=2);
        }
    }
    
    // cutouts to the slotted part
    union() {
        cyl(r=gr, h=bgt+1, $fn=fn);
        cuboid([2*gr, 40, bgt+ft+1], anchor=BACK);
        
        color("red") back(9) prismoid(size1=[45, bt], size2=[22, bt], h=8, orient =BACK);
        color("pink") back(9) cuboid([45, 50, bt], anchor=BACK);
        color("blue") fwd(9+e) prismoid(size1=[45, bt], size2=[60, bt+ft+3], h=12, orient=FRONT);
    }
    
    //up(0) cuboid([200, 200, 200], anchor=BOTTOM);
}

fff = 14;
sss = 22;
rrr = 1.5;
/*
down( 0.25) up( bt/2) fwd(fff) left( sss) cyl(r=rrr, h=3, $fn=fn, rounding=rrr, anchor=BOTTOM);
down( 0.25) up( bt/2) fwd(fff) left(-sss) cyl(r=rrr, h=3, $fn=fn, rounding=rrr, anchor=BOTTOM);
down(-0.25) up(-bt/2) fwd(fff) left( sss) cyl(r=rrr, h=3, $fn=fn, rounding=rrr, anchor=TOP);
down(-0.25) up(-bt/2) fwd(fff) left(-sss) cyl(r=rrr, h=3, $fn=fn, rounding=rrr, anchor=TOP);

color("red")
*/
up(  bt/2 + rrr - 0.35 ) fwd(fff) left( sss) zrot(-20) cyl(r=rrr, h=12, $fn=fn, rounding=rrr, orient=RIGHT);
up(  bt/2 + rrr - 0.35 ) fwd(fff) left(-sss) zrot( 20) cyl(r=rrr, h=12, $fn=fn, rounding=rrr, orient=RIGHT);
up(-(bt/2 + rrr - 0.35)) fwd(fff) left( sss) zrot(-20) cyl(r=rrr, h=12, $fn=fn, rounding=rrr, orient=RIGHT);
up(-(bt/2 + rrr - 0.35)) fwd(fff) left(-sss) zrot( 20) cyl(r=rrr, h=12, $fn=fn, rounding=rrr, orient=RIGHT);




right(100)
difference() {
    union() {
        cyl(r=30, h=pgt, rounding=2, $fn=fn);
        diff() 
        fwd(10) prismoid(size1=[50, pgt], size2=[50, pgt+ft], h=10, $fn=fn, anchor=BOTTOM, orient=FRONT)
            attach([BACK+RIGHT, FRONT+RIGHT, BACK+LEFT, FRONT+LEFT], LEFT+FRONT, inside=true) rounding_edge_mask(r=2, l=10.9);
        up(7) fwd(15) diff() sphere(r=20) 
            tag("remove") sphere(r=18)
            tag("remove") down(10) cuboid([50, 50, 50], anchor=BOTTOM);
    }

        
    union() {
        cyl(r=gp, h=pt, $fn=fn);
        cuboid([2*gp, 40, pt], anchor=BACK);
        back(9) cuboid([19, 40, pgt+1], anchor=BACK+BOTTOM);
        
        color("blue") fwd(9+e) prismoid(size1=[2*gp, bt], size2=[45, bt+ft], h=12, orient=FRONT);
        
        fwd(20+e) cuboid([50, 50, 50], anchor=BACK);
        
        // HACK: these values are dependent on the sphere above
        up(7) fwd(15) diff() sphere(r=18)
            tag("remove") down(7) cuboid([50, 50, 50], anchor=BOTTOM);
     }
    
    //cuboid([200, 200, 200], anchor=BOTTOM);
}




