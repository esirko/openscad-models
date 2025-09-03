include <BOSL2/std.scad>

// Using the cartoon hand pointer from 
// https://www.reddit.com/r/BambuLab/comments/1kdwma4/i_designed_a_full_set_of_3d_printed_cartoon_hand/
// https://makerworld.com/en/models/1295430-cartoon-hand-pointer-stick-single-finger#profileId-1326617


e = 0.01;
e2 = 2*e;
fn = 72;


difference() {
    union() {
        yrot(90) prismoid(size1=[4.5, 11], size2=[4, 9], h=17+10, shift=[0, 0], rounding=1, $fn=fn);
        //right(17) yrot(90) prismoid(size1=[4, 9], size2=[3, 9], h=10, rounding=1, $fn=fn);
        right(10.5) up(2) cyl(r=3, h=4, $fn=fn, anchor=BOTTOM);
        
    }
    left(e) cuboid([13, 6.5, 2.5], anchor=LEFT);
    up(5) right(10.5) cyl(r=1, h=10, $fn=fn, anchor=TOP);
    up(6+e) right(10.5) cyl(r=1.5, h=3, $fn=fn, anchor=TOP);
    
    //color("red") 
    //down(7.7) back(2) right(25) yrot(90) diff() cyl(r1=14, r2=11, h=30) tag("remove") cyl(r1=13, r2=9, h=30+e2, $fn=2*fn);
    //up(7.7) back(2) right(25) yrot(90) diff() cyl(r1=14, r2=11, h=30) tag("remove") cyl(r1=13, r2=9, h=30+e2, $fn=2*fn);
}


/*
down(2) back(2) right(17) {
    difference() {
        union() {
            diff() torus(r_maj = 10, r_min=2, $fn=fn) {
                    tag("remove") cuboid([50, 50, 5], anchor=RIGHT);
                    tag("remove") cuboid([50, 50, 5], anchor=FRONT);
                    tag("remove") fwd(6.5) cuboid([50, 50, 5], anchor=BACK);
                    tag("remove") right(10) cuboid([50, 50, 5], anchor=RIGHT+BACK);
            }
            right(10) cyl(r=2, h=5, $fn=fn, orient=BACK, anchor=BOTTOM);
        }
        //fwd(5) right(7.5) zrot(5) tube(h=5, ir=2, or=3, $fn=fn, orient=RIGHT);
        
    }
}
*/

down(2) fwd(4.5) right(15)
right(10) cyl(r=2, h=9+4, $fn=fn, orient=BACK, anchor=BOTTOM);


/*
difference() {
    cuboid([17+10, 11, 4.5], rounding=1, $fn=fn, anchor=LEFT);
    left(e) cuboid([13, 6.5, 2.5], anchor=LEFT);
}
*/