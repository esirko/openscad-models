d1 = 5;
w = 187;
d2 = 9;
d3 = 5;
d4 = 14;
d4a = 8;
d5 = 2;
h = 54;
c1 = 9;
c2 = 47;

buf = 10;
e = 1;

z1 = 5;
z2 = 6;
g = 9;

d6 = 9;
d7 = 2;
b = 9; // short to save filament, try 9

q = 7;
l1 = 27;
l2 = 18;
d8 = 8;

r1 = 800;
r2 = 804; // narrow to save filament, try 210

a1 = -145 - 591;
a2 = -30 - 100;


union () {
    difference() {
        union() {
            
            translate([c1, 0, -d4 - buf]) {
                cube([d1, w, d4a + buf]);
                cube([d1, 5 , d4a + buf + 2]);
                cube([18, 10, d4a + buf]);
            }
            translate([0, c2, -d4 - buf]) cube([h, d2, d4 + buf]);
        }

        translate([0, w + e, 0])
        rotate([90, 0, 0]) 
        linear_extrude(w + 2 * e) 
        polygon([[-e, -d4 - buf - e], [-e, -d4], [h + e, -d5], [h + e, -d4 - buf - e]]);
    }

    translate([0, c2, 0])
    rotate([90, 0, 90])
    linear_extrude(h + g)
    polygon([[0, 0], [0, z1], [d2, z2], [d2, 0]]);

    translate([g, c2+d2, 4])
    rotate([-174.6, 0, 0])
    union() {
        cube([40, d6, d7]);

        difference() {
            translate([a1, a2, -2])
            difference() {
                cylinder(d7 + b, r2, r2, $fn=360);
                translate([0, 0, -e]) cylinder(d7 + 2 * e + b, r1, r1, $fn=360);
            }

            translate([-2000, -1000, -200])
            cube([2000, 2000, 400]); //d7 + b + 2 * e]);

            translate([a1, a2, -500])
            rotate([0, 0, 14])
            cube([1000, 1000, 1000]); //d7 + b + 2 * e]);

            translate([a1, a2, -500])
            rotate([0, 0, -88])
            cube([1000, 1000, 1000]); //d7 + b + 2 * e]);
        }
    }

}

