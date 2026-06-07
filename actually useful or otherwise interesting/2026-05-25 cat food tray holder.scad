include <BOSL2/std.scad>

e = 0.1;

r_plate = 110;
r_bowl1 = 65;
r_bowl2 = 74;

t = 3;
h0 = 15;
h0b = 15;
h1 = 27;
h2 = 35;
platform_h0 = 5;
platform_h1 = 3;
platform_h2 = 3;
fn = 180;

module full_plate_tray() {
    difference() {
        cyl(r = r_plate+t, h=h0, anchor=BOTTOM, $fn=fn);
        up(platform_h0-e) cyl(r = r_plate, h=h0+2, anchor=BOTTOM, $fn=fn);
        down(e) cyl(r = 90, h=h0+2, anchor=BOTTOM, $fn=fn);
        fwd(r_plate) up(platform_h0) cuboid([50, 50, h0], anchor=BOTTOM);
    }
    up(h0) difference() {
        cyl(r1=r_plate+t, r2=r_plate, h=5, anchor=BOTTOM, $fn=fn);
        down(e) cyl(r1=r_plate, r2=r_plate-t, h=5+2*e, anchor=BOTTOM, $fn=fn);
        down(e) cuboid([300, 150, 10], anchor=BOTTOM+BACK);
    }
    up(h0) difference() {
        cyl(r = r_plate+t, h=h0b, anchor=BOTTOM, $fn=fn);
        down(e) cyl(r = r_plate, h=h0b+2, anchor=BOTTOM, $fn=fn);
        down(e) cuboid([300, 150, 50], anchor=BOTTOM+FRONT);
        down(e) xrot(-8) cuboid([300, 300, 50], anchor=BOTTOM);
        down(e) fwd(r_plate) cuboid([50, 50, h0b+2*e], anchor=BOTTOM);
    }

    //zrot(45) cuboid([2*r_plate, 10, platform_h0], anchor=BOTTOM);
    //zrot(-45) cuboid([2*r_plate, 10, platform_h0], anchor=BOTTOM);
}

module dovetail_wedge(d) {
    back(e) down(d ? e : 0) left((r_plate+t+90)/2) zrot(-90) yrot(90) 
        prismoid(size1=[platform_h0+(d ? 2*e : 0), 10+0.1], size2=[platform_h0+(d ? 2*e : 0), 15+0.1], h=10+(d ? 0.1 : 0), anchor=BOTTOM+RIGHT);
}

back(0) {
    back(20) {
        difference() {
            full_plate_tray();
            down(e) cuboid([300, 300, 50], anchor=BACK+BOTTOM);
            down(e) zrot(60) cuboid([300, 300, 50], anchor=BACK+BOTTOM);
            zrot(-120) dovetail_wedge(d=true);
        }
        dovetail_wedge();
        
    }
    
    right(20) {
        difference() {
            full_plate_tray();
            down(e) zrot(240) cuboid([300, 300, 50], anchor=BACK+BOTTOM);
            down(e) zrot(300) cuboid([300, 300, 50], anchor=BACK+BOTTOM);
            zrot(120) dovetail_wedge(d=true);
        }
        zrot(-120) dovetail_wedge();
    }
    
    difference() {
        full_plate_tray();
        down(e) zrot(120) cuboid([300, 300, 50], anchor=BACK+BOTTOM);
        down(e) zrot(180) cuboid([300, 300, 50], anchor=BACK+BOTTOM);
        zrot(0) dovetail_wedge(d=true);
    }
    zrot(120) dovetail_wedge();
}


/*
h_joiner = 25;

dovetail_y1 = 20;
dovetail_y2 = 29;
dovetail_h = 10;
dovetail_y_slop = 0.05;
dovetail_h_slop = 0.05;

left(110) {
    difference() {
        union() {
            cyl(r = r_bowl1+t, h=h1+platform_h1, anchor=BOTTOM, $fn=fn);
            right(r_bowl1-3) cuboid([30, 50, h_joiner], anchor=BOTTOM+LEFT)
                attach(RIGHT) prismoid(size1=[h_joiner, dovetail_y1], size2=[h_joiner, dovetail_y2], h=dovetail_h, spin=90, rounding=1);
        }
        down(e) cyl(r = r_bowl1, h=h1+platform_h1+2*e, anchor=BOTTOM, $fn=fn);
    }
    cuboid([2*r_bowl1, 20, platform_h1], anchor=BOTTOM);
}

right(110) {
    difference() {
        union() {
            cyl(r = r_bowl2+t, h=h2+platform_h2, anchor=BOTTOM, $fn=fn);
            left(r_bowl2-3) diff() cuboid([35, 50, h_joiner], anchor=BOTTOM+RIGHT, $fn=fn)
                left(e) attach(LEFT) tag("remove") prismoid(size1=[h_joiner+2*e, dovetail_y2+dovetail_y_slop], size2=[h_joiner+2*e, dovetail_y1+dovetail_y_slop], h=dovetail_h+dovetail_h_slop, spin=-90, anchor=TOP);
        }
        down(e) cyl(r = r_bowl2, h=h2+platform_h2+2*e, anchor=BOTTOM);
    }
    cuboid([2*r_bowl2, 20, platform_h2], anchor=BOTTOM);
}
*/

