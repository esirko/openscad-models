r1 = 3.8/2;
r2 = 10/2;

tl = 8.5;
to = 1.5;
th = 6;

lt = 7;
ll = 20;
theta = 35;

zh = 7;
e = 0.01;


difference() {
    union() {
        cylinder(zh, r2, r2, $fn=360);
        rotate([0, 0, theta]) translate([0, -r2, 0]) cube([ll, lt, zh]);
        translate([-(tl + r2), -(th/2 + to), 0]) cube([tl + r2, th, zh]);
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
        translate([0, 0, -e]) rotate([0, 0, -15]) cube([thumb_r2 + e, thumb_r2 + e, thumb_zh + 2 * e]);
        translate([-(thumb_r2 + e), -(thumb_r2 + e), -e]) cube([2 * (thumb_r2 + e), thumb_r2 + e, thumb_zh + 2 * e]);
    }
    
    translate([-93, -50, -e]) cube([100, 100, thumb_zh + 2 * e]);
}