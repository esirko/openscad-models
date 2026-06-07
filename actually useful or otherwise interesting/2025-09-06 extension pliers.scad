include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

fn = 72;
e = 0.01;

l = 50;
x = 25;

h = 12;
r0 = 6.25;
r1 = 8;
dx = 5;


/*
// First attempt at the star pattern - it works but then I redid it below with skin
module star(h) {
    for (i = [0:5]) {
        zrot(60*i) back(4) prismoid(size1=[7, h], size2=[5, h], h=4, orient=BACK);
    }
    color("blue") regular_prism(6, r=5, h=h);
}

difference() {
    down(2+e) cyl(r=11, h=7, rounding=1, $fn=36);
    star(5); // math is hard since the prismoids are orient=BACK, I already tried doing anchors on this, just leave it alone
}
*/

/*
fwd(50)
difference() {
    prismoid(size1=[24, h], size2=[30, h], h=l, rounding=1, $fn=fn, anchor=TOP);
    up(e) prismoid(size1=[12.5, h+2], size2=[14, h+2], h=22, anchor=TOP);
    up(e) prismoid(size1=[14.5, 5], size2=[16, 5], h=23, anchor=TOP); // inner slot
    
    fwd(2) down(l+e) cuboid([6, h, x+1], anchor=BOTTOM);
    down(l+e) cuboid([5, h+e, x+1], anchor=BOTTOM);
}
*/


quarter_path = [[0, r1],
        [dx/2, r1],
        [r0 * sin(30), r0 * cos(30)],
        zrot(-60, [-dx/2, r1])];

path = flatten([quarter_path, zrot(-60, quarter_path), zrot(-120, quarter_path), zrot(-180, quarter_path), 
    zrot(-240, quarter_path), zrot(-300, quarter_path)]);

difference() {
    down(2+e) union() {
        cyl(r=12, h=h, rounding=1, $fn=fn, anchor=BOTTOM);
        diff() cuboid([24, l, h], rounding=1, except=BACK, $fn=fn, anchor=BOTTOM+BACK) {
            //position(FRONT) fwd(e) tag("remove") cuboid([5, x+1, h+1], anchor=FRONT);
            position(FRONT) up(2-2) fwd(e) tag("remove") cuboid([6, x+1, h+e], anchor=FRONT);
        }
    }
    skin([path, path], z=[0, 5], slices=2);
    skin([path, zrot(90, circle(r=10, $fn=fn))], z=[5-e, 10], slices=10, $fn=fn);
    
    
}

