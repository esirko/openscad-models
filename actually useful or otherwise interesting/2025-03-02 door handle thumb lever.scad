include <BOSL2/std.scad>

r1 = 3.8/2;
r2 = 10/2;

tl = 8.5;
to = 1.5;
th = 6;

lt = 7;
ll = 20;
theta = 35;

// TODO: 8 seemed to get stuck, but 7.5 wiggles a bit too much. 
// I think ideally the part surrounding the axle should be 7.5 but there should be an extra protrusion,
// not directly around the axle, that prevents it from wiggling from side to side.
zh = 7.5;
e = 0.01;

xrot(90) {

difference() {
    union() {
        cylinder(zh, r2, r2, $fn=360);
        rotate([0, 0, theta]) translate([0, -r2, 0]) cube([ll, lt, zh]);
        translate([-(tl + r2), -(th/2 + to), 0]) cube([tl + r2, th, zh]);
        
        // new feature for sturdiness
        //zrot(theta) 
        //fwd(1.5) up(zh/2) right(r2) yrot(90) zrot(90) 
        //prismoid(size1=[lt, zh], size2=[lt, 4*zh], height=ll);
    }
    
    translate([0, 0, -e]) cylinder(zh + 2 * e, r1, r1, $fn=360);
}

thumb_zh = 25;
thumb_r2 = 60;
thumb_r1 = 55;

// Final adjustment: rotate about 10 degrees around the point (x,y) = (20, 10)
translate([20, 8, 0])
rotate([0, 0, -17])
translate([-20, -8, 0])

translate([0, 0, -(thumb_zh - zh)/2])
difference() {
    translate([42, -40, 0])
    difference() {
        cylinder(thumb_zh, thumb_r2, thumb_r2, $fn=360);
        translate([0, 0, -e]) cylinder(thumb_zh + 2 * e, thumb_r1, thumb_r1, $fn=360);
        translate([0, 0, -e]) rotate([0, 0, -e]) cube([thumb_r2 + e, thumb_r2 + e, thumb_zh + 2 * e]);
        translate([-(thumb_r2 + e), -(thumb_r2 + e), -e]) cube([2 * (thumb_r2 + e), thumb_r2 + e, thumb_zh + 2 * e]);
    }
    
    translate([-93, -50, -e]) cube([100, 100, thumb_zh + 2 * e]);
}


/*
color("red")
translate([0, 0, -(thumb_zh - zh)/2])
translate([42, -40, 0])
translate([-15, 0, -e]) rotate([0, 0, -15]) cube([thumb_r2 + e, thumb_r2 + e, thumb_zh + 2 * e]);
*/

}
