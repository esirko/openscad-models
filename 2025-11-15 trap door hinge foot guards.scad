include <BOSL2/std.scad>

fn = 36;
r = 3;
e = 0.01;

back(50) {
    diff() cuboid([60, 1, 60], anchor=FRONT+BOTTOM+LEFT)
        tag("remove") {
            up(35/2) left(35/2) cyl(r=r, l=1+1, $fn=fn, orient=FWD);
            up(35/2) left(-35/2) cyl(r=r, l=1+1, $fn=fn, orient=FWD);
            up(-35/2) left(40/2) cyl(r=r, l=1+1, $fn=fn, orient=FWD);
            up(-35/2) left(-37/2) cyl(r=r, l=1+1, $fn=fn, orient=FWD);
        }
        
    diff() cuboid([60, 10, 60], anchor=BACK+BOTTOM+LEFT) {
        tag("remove") cuboid([58, 41+1, 58]);
        tag("remove") cuboid([38, 41+1, 58+10]);
    }
}

t = 2;
down(t) left(t) diff() cuboid([15+t, 11, 60+2*t], anchor=BACK+BOTTOM+LEFT)
    tag("remove") right(t/2) cuboid([15+e, 11+1, 60]);
right(60) down(t) right(t) diff() cuboid([15+t, 11, 60+2*t], anchor=BACK+BOTTOM+RIGHT)
    tag("remove") left(t/2) cuboid([15+e, 11+1, 60]);

//right(14) up(60+t) diff() cuboid([32, 40, 28], anchor=BACK+BOTTOM+LEFT)
//    tag("remove") down(1) fwd(1) cuboid([30, 40, 28]);

right(12) up(60) cuboid([36, 1, 28], anchor=BACK+BOTTOM+LEFT);

right(12) up(60) cuboid([1, 10, 16], anchor=BACK+BOTTOM+LEFT);
right(12+35) up(60) cuboid([1, 10, 16], anchor=BACK+BOTTOM+LEFT);

/*
right(100)
diff() cuboid([10, 1, 60], anchor=FRONT+BOTTOM+LEFT)
    tag("remove") {
        up(-20) cyl(r=1.5, l=1+1, $fn=fn, orient=FWD);
        up(-10) cyl(r=2, l=1+1, $fn=fn, orient=FWD);
        up(0) cyl(r=2.5, l=1+1, $fn=fn, orient=FWD);
        up(10) cyl(r=3, l=1+1, $fn=fn, orient=FWD);
    }
*/

/*
difference() {
    circle(16);
    circle(15);
    rect(32, anchor=BACK);
}
*/

//path_sweep

shape = flatten([18*[for(theta=[-90:90]) [sin(theta), cos(theta)]], 
    17*[for(theta=[-90:90]) [-sin(theta), cos(theta)]]]);
    //20*[[0.65, 0], [0.45, 0.8], [-0.45, 0.8], [-0.65, 0]]]);
polygon(shape);

path = [[0, 20, 75], [0, -10, 75], [0, -50, 40], [0, -60, 0]];

right(30)
difference() {
    path_sweep(shape, path);
    cuboid([100, 100, 150], anchor=BOTTOM+FRONT);
}

