include <BOSL2/std.scad>

// See https://www.penny-arcade.com/comic/2005/09/26/unique-gifts-for-the-home for the origin of the name

e = 0.01;

w = 12;
h = 7;
t = 2;
tl = 1;

ew = e + w;
eh = e + h;

module upper(l, scarf1=false, scarf2=false) {
    difference() {
        cuboid([w, l, h], chamfer=t, edges=[TOP+RIGHT, TOP+LEFT], anchor=FRONT+BOTTOM);
        down(e) fwd(e) cuboid([w-2*t, 2*e+l, h-t], chamfer=1, edges=[TOP+RIGHT, TOP+LEFT], anchor=FRONT+BOTTOM);
        if (scarf1) { // subtractive
            back(l+e) {
                up(h-t+e) prismoid(size1=[ew, 0], size2=[ew-2*t, t], shift=[0, -t/2], h=t, anchor=BOTTOM+BACK);
                down(e) left(w/2+e)  prismoid(size1=[eh, 0], size2=[eh-t, t], shift=[-t/2, -t/2], h=t, orient=LEFT, anchor=TOP+BACK+LEFT);
                down(e) right(w/2+e) prismoid(size1=[eh, 0], size2=[eh-t, t], shift=[t/2, -t/2],  h=t, orient=RIGHT, anchor=TOP+BACK+RIGHT);
            }
        }
    }
    if (scarf2) { // additive
        up(h-t) prismoid(size1=[w, 0], size2=[w-2*t, t], shift=[0, -t/2], h=t, anchor=BOTTOM+BACK);
        left(w/2)  prismoid(size1=[h, 0], size2=[h-t, t], shift=[-t/2, -t/2], h=t, orient=LEFT, anchor=TOP+BACK+LEFT);
        right(w/2) prismoid(size1=[h, 0], size2=[h-t, t], shift=[t/2, -t/2],  h=t, orient=RIGHT, anchor=TOP+BACK+RIGHT);
    }
}

module lower(l) {
    difference() {
        cuboid([w-2*t, l, h-t-1-2*e], chamfer=1, edges=[TOP+RIGHT, TOP+LEFT], anchor=FRONT+BOTTOM); // the -1 is for the tape thickness
        up(tl+e) fwd(e) cuboid([w-2*t-2*tl, 2*e+l, h-2*tl], anchor=FRONT+BOTTOM);
    }
}



upper(220, scarf1=true, scarf2=false);
left(15) upper(220, scarf1=true, scarf2=true);

color("#ffc0c0")  {
    right(15) lower(200);
    right(30) lower(200);
}