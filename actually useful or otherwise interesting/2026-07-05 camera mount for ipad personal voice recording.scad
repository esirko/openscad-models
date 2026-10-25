include <BOSL2/std.scad>


e = 0.02;
e2 = 0.04;
fn = 180;

basex = 116;
basey = 127;
basedx = 10;

h0 = 104;
h1 = 144;
h2 = 44;

lens_inner_r = 50/2;
lens_outer_r = 55/2;
camera_r = 58/2;

jh = 10;

module legs(slop=0.0) {
    fwd(basey/2) left(10) prismoid(size1=[20, basedx], size2=[20+slop, basedx+slop], height=h0-4, shift=[0, 0], anchor=BOTTOM+RIGHT+BACK);
    left(basex/2) prismoid(size1=[basedx, 20], size2=[basedx+slop, 20+slop], height=h0-4, shift=[0, 0], anchor=BOTTOM+RIGHT+FRONT);
    back(basey/2) right(10) prismoid(size1=[20, basedx], size2=[20+slop, basedx+slop], height=h0-4, shift=[0, 0], anchor=BOTTOM+LEFT+FRONT);
}



// Bottom mount
down(60) {
    //prismoid(size1=[basex+2*basedx, 0], size2=[basex+2*basedx,  basey+2*basedx], shift=[0, (basey+2*basedx)/2], h=8, anchor=BACK);
    diff() cuboid([basex+2*basedx, basey+2*basedx, 4], anchor=BOTTOM)
        position(CENTER) tag("remove") cuboid([basex, basey, 12]);
        
    up(4) legs();
    
    up(10) 
    difference() {
        up(h0) union() {
            fwd(10) cuboid([175, 175, 0.4], anchor=BOTTOM);
            left(10) cuboid([basex+2*basedx-10, basey+2*basedx+10, 4], anchor=BOTTOM);
        }
        up(h0) cyl(r=50, h=10);
        up(6) legs(0.1);
    }
}


// Top camera holder
up(h1+h2) {
    difference() {
        down(4) cyl(r1=camera_r+2, r2=camera_r+8, h=4+41, anchor=BOTTOM);
        cyl(r=lens_outer_r, h=100, anchor=BOTTOM);
        up(5) cyl(r=camera_r, h=100, anchor=BOTTOM);
        down(5) cyl(r=lens_inner_r-2, h=20, anchor=BOTTOM);
        cuboid([100, 100, 30], anchor=BOTTOM+BACK);
        color("red") cuboid([10, 100, 50], anchor=BOTTOM+BACK);
    }

    fwd(lens_outer_r) cuboid([8, 3.5, 5], anchor=BOTTOM+BACK, chamfer=0.5, edges=TOP);
}


up(h1+h2) color("red")
up(40) difference() {
    cyl(r=camera_r+7, h=14, anchor=BOTTOM);
    down(e) cyl(r=camera_r+4, h=14+2*e, anchor=BOTTOM);
    down(e) cuboid([100, 100, 100], anchor=BOTTOM+BACK);
}

up(h1) { color("lightblue")
    difference() {
        cyl(r1=50, r2=camera_r+2, h=h2-4, anchor=BOTTOM);
        down(e) cyl(r1=46, r2=lens_inner_r-2, h=h2-4+2*e, anchor=BOTTOM);
    }
}

module circle_mount_part() {
    cylslop = 0.1;
    difference() {
        union() {
            cyl(r=50-cylslop, h=10, anchor=TOP);
            cyl(r=55, h=2, anchor=TOP);
        }
        up(e) cyl(r=46, h=10+2*e, anchor=TOP);
    }
}

color("blue")
up(h1) circle_mount_part();

// Extension cylinder - TODO continue here
extension_cylinder_height = 20;
down(60) up(h1) color("red") {
    circle_mount_part();
    difference() {
        union() {
            //cyl(r1=55, r2=52, h=4, anchor=BOTTOM); // attempt to remove supports - need to do it on the other side to work - too complicated, just use supports
            cyl(r=52, h=extension_cylinder_height, anchor=BOTTOM);
        }
        down(e) cyl(r=50, h=extension_cylinder_height+1, anchor=BOTTOM);
    }
}


// hacky ipad mount pieces
mount_x = 55.5;
mount_y = 16;
out_buf_x = 10;
out_buf_y = 10;
ipad_thickness = 6+1;
in_buf = 5;
bottom_z = 0;
top_z = 1;

xflip_copy() {
    back(120) left(120) {
        back(out_buf_y) cuboid([out_buf_x, out_buf_y+mount_y+20, ipad_thickness], anchor=BACK+RIGHT+TOP);
        cuboid([mount_x, out_buf_y, ipad_thickness], anchor=FRONT+LEFT+TOP);

        right(mount_x) back(out_buf_y) cuboid([10, out_buf_y+mount_y+basedx, 4], anchor=BOTTOM+RIGHT+BACK);
        right(mount_x) fwd(mount_y) cuboid([21, 10, 4], anchor=BOTTOM+LEFT+FRONT);

        right(mount_x+11) fwd(mount_y + basedx) cuboid([10, 10, 4], anchor=BOTTOM+LEFT+BACK);
        color("blue") right(mount_x+11) fwd(mount_y-10) up(4) cuboid([10, 30, 5], anchor=BOTTOM+LEFT+BACK);
    }
    
    fwd(120) left(80) {
        cuboid([10, 10, 5], anchor=BOTTOM+FRONT+RIGHT);
        fwd(10.1) cuboid([10, 25, 5], anchor=BOTTOM+BACK+RIGHT);
        back(10) cuboid([10, 45.1, 10], anchor=TOP+BACK+RIGHT);
        fwd(35.1) down(10) cuboid([10, 8, 4], anchor=TOP+FRONT+RIGHT);
    }
}




// light shield
/*
slop = 0.5;
light_shield_dz = 3;
up(300) {
    difference() {
        cuboid([175, 175, light_shield_dz], anchor=BOTTOM);

        down(e) {
            difference() { // same as part above
                cyl(r=camera_r+7+slop, h=14, anchor=BOTTOM);
                down(e) cyl(r=camera_r+4, h=14+2*e, anchor=BOTTOM);
                down(e) fwd(slop) cuboid([100, 100, 100], anchor=BOTTOM+BACK);
            }

            fwd(30) cuboid([12, 150, light_shield_dz+1], anchor=BOTTOM+BACK);
            fwd(10) left(2.5) cuboid([25, 12, light_shield_dz+1], anchor=BOTTOM+BACK);
            fwd(33) left(5) difference() {
                cyl(r=23, h=light_shield_dz+1, anchor=BOTTOM);
                down(e) cyl(r=15, h=light_shield_dz+1+2*e, anchor=BOTTOM);
                cuboid([100, 100, 100], anchor=LEFT);
            }
        }
    }

    left(70) up(light_shield_dz-e) cuboid([10, 30, 10], anchor=BOTTOM);
    right(70) up(light_shield_dz-e) cuboid([10, 30, 10], anchor=BOTTOM);
    
    left(150) {
        difference() {
            cuboid([100, 170, 1], anchor=BOTTOM);
            right(35) cuboid([10, 30, 10]);
        }
    }
}
*/

/*
// light shield v2, simpler
yshift = 15;
up(300) {
    difference() { // same as part above
        cyl(r=camera_r, h=14+2*e, anchor=TOP);
        up(e) fwd(5) cuboid([100, 100, 100], anchor=TOP+BACK);
    }
    difference() {
        fwd(yshift) cuboid([170, 170, 0.6], anchor=BOTTOM);
        right(75) cuboid([10, 30, 10]);
        left(75) cuboid([10, 30, 10]);
    }
    
    xflip_copy() {
        left(150) {
            fwd(yshift) cuboid([100, 170, 0.6], anchor=TOP);
            right(35) cuboid([10, 30, 5], anchor=TOP);
        }
    }
}
*/

