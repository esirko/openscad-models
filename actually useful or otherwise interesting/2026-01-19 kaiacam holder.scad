include <BOSL2/std.scad>

e = 0.02;
w1 = 32;
h1 = 11;
w2 = 19;
h2 = 37;
t1 = 2;
t2 = 2;
t3 = 6;
w3 = 13;
d2 = 60;
fn=36;

h3 = d2/sqrt(2) - t1; // h3+t1 = 60/sqrt(2)
d1 = 60;

zrot(90) {

difference() {
    union() {
        cuboid([w1, d1, t1], anchor=LEFT+BOTTOM);
        right(w1) down(h1) cuboid([w2, d1, h1+t1], anchor=LEFT+BOTTOM, chamfer=8, edges=TOP+RIGHT);
        right(w1+w2) down(h1) cuboid([t2, d1, h2], anchor=RIGHT+TOP);
        color("red") right(w1+w2) down(h1+h2) cuboid([w2-4,d1, t3], anchor=RIGHT+TOP, chamfer=4, edges=TOP+LEFT);
    }
    
    up(t1+e) cuboid([100, 30, 100], anchor=TOP+LEFT);
}

up(t1) difference() {
    union() {
        left(w3+t1) yrot(-45) left(d2/2) union() {
            difference() {
                union() {
                    cyl(r=d2/2, h=30, anchor=TOP, $fn=fn);
                    cuboid([d2/2, d2, 30], anchor=TOP+LEFT);
                }
            }
        }
        cuboid([w3+t1, d2, w3+t1], anchor=RIGHT+TOP);
    }
    
    cuboid([50, d2+2*e, 50], anchor=LEFT+TOP);

    left(w3+t1) yrot(-45) left(d2/2) up(e) {
        left(39/2) cyl(r=1.75, h=27, anchor=TOP, $fn=fn);
        right(39/2) cyl(r=1.75, h=27, anchor=TOP, $fn=fn);
    }
}

}

