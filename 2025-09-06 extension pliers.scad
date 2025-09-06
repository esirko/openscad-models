include <BOSL2/std.scad>

fn = 36;
e = 0.01;

l = 60;
x = 25;
r0 = 3.25;

h = 15;
w = 20;

difference() {
    left(x) cuboid([l, w, h], rounding=1, $fn=fn, anchor=LEFT);

    cuboid([x+1, 2*r0, h+1], anchor=RIGHT);
    prismoid(size1=[2*r0, h+1], size2=[2, h+1], h=r0+2, orient=RIGHT, spin=90);
}

fwd(30) 
difference() {
    cuboid([l, 30, h], rounding=1, $fn=fn, anchor=RIGHT);
    right(e) {
        cuboid([20, 15, h+1], anchor=RIGHT);
        cuboid([22, 17, 5], anchor=RIGHT); // inner slot
    }
    
}

