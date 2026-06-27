include <BOSL2/std.scad>

// l  = length (x)
// fl = front-left depth  (y at x=0)
// fr = front-right depth (y at x=l)
// h  = vertical drop (z)
// dx = bottom inset toward back
module seg(l, fl, fr, h, dx=1.0) {
    skin([
        path3d([[0, 0],   [l, 0],   [l, -fr],    [0, -fl]],    0),
        path3d([[0, -dx], [l, -dx], [l, -fr+dx], [0, -fl+dx]], -h),
    ], slices=0);
}


l0 = 20;
l1 = 120;
l2 = 100;
l3 = 20;
l4 = 175;
l5 = 20;

difference() {
    union() {
                      seg(l0, fl=10, fr=9,  h=37, dx=1.0);
        right(l0)     seg(l1, fl=9,  fr=10, h=9,  dx=0.5);
        right(l0+l1)  seg(l2, fl=10, fr=11, h=16, dx=1.0);
        left(10) {
            left(l3)       seg(l3, fl=11, fr=10, h=40, dx=0.5);
            left(l3+l4)    
                               seg(l4, fl=13, fr=11, h=80);

            left(l3+l4+l5) seg(l5, fl=12, fr=13, h=40, dx=0.5);
        }
    }

    left(60) down(30) cuboid([115, 50, 100], anchor=RIGHT+BACK+TOP);
    left(5) down(10) cuboid([20, 50, 100], anchor=BACK+TOP);
}

