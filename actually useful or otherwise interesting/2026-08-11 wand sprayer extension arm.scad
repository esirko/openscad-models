include <BOSL2/std.scad>

e = 0.01;

knobz = 26;
gapz = 2.5;
inner_radius = 14;
vertical_spacing = 6.57;
very_inner_radius = 6.5;
radial_block_thickness = 2;
tab_protrusion_width = 0.4;


module hook_joiner_male(x, y, z, tx, tz) {
    zrot(180) {
        down(e) cuboid([x, y, z-tz+2*e], anchor=BOTTOM);
        up(z-tz) left(tx/2) prismoid(size1=[x+tx, y], size2=[x-tx, y-tx], shift=[tx, tx/2], h=tz, anchor=BOTTOM); // the -tx terms are for narrowing the top for easier insertion
    }
}

module hook_joiner_female(x, y, z, tx, tz, xslop, yslop) {
    tag("remove") xrot(180) {
        down(e) cuboid([x+xslop, y+yslop, z-tz+2*e], anchor=BOTTOM);
        up(z-tz) left(tx/2) prismoid(size1=[x+tx+xslop, y+yslop], size2=[x+xslop, y+yslop], shift=[tx/2, 0], h=tz, anchor=BOTTOM);
    }
} 


module half_knob(male=false) {
    difference() {
        diff() prismoid(size1=[knobz, 44], size2=[knobz, 24], h=17, orient=BACK, spin=90) {
            if (male) {
                attach(BOTTOM) fwd(18) zrot(90) hook_joiner_male(5, 7, 6, tab_protrusion_width, 2);
                attach(BOTTOM) back(18) zrot(-90) hook_joiner_male(5, 7, 6, tab_protrusion_width, 2);
            } else {
                attach(BOTTOM) fwd(18) cuboid([12, 8, 8], anchor=TOP);
                attach(BOTTOM) back(18) cuboid([12, 8, 8], anchor=TOP);
                attach(BOTTOM) fwd(18) zrot(-90) tag("remove") hook_joiner_female(5, 7, 6, tab_protrusion_width, 2, 0.2, 0.2);
                attach(BOTTOM) back(18) zrot(90) tag("remove") hook_joiner_female(5, 7, 6, tab_protrusion_width, 2, 0.2, 0.2);
                attach(TOP) prismoid(size1=[12, 44], size2=[12, 30], h=9, anchor=TOP);
            }
        }
        cyl(r=inner_radius, h=gapz);
        up(vertical_spacing) cyl(r=inner_radius, h=gapz);
        up(2*vertical_spacing) cyl(r=inner_radius, h=gapz);
        up(-vertical_spacing) cyl(r=inner_radius, h=gapz);
        up(-2*vertical_spacing) cyl(r=inner_radius, h=gapz);
        fwd(e) cuboid([radial_block_thickness, inner_radius, knobz+1], anchor=FRONT);
        cuboid([2*inner_radius, radial_block_thickness, knobz+1]);
        cyl(r=very_inner_radius, h=knobz+1);
    }
    
    down(knobz/2 + 120/2) difference() {
        diff() prismoid(size1=[120, 44], size2=[120, 24], h=17, orient=BACK, spin=90) {
            right(52)
            if (male) {
                attach(BOTTOM) fwd(18) zrot(90) hook_joiner_male(5, 7, 6, tab_protrusion_width, 2);
                attach(BOTTOM) back(18) zrot(-90) hook_joiner_male(5, 7, 6, tab_protrusion_width, 2);
            } else {
                attach(BOTTOM) fwd(18) cuboid([12, 8, 8], anchor=TOP);
                attach(BOTTOM) back(18) cuboid([12, 8, 8], anchor=TOP);
                attach(BOTTOM) fwd(18) zrot(-90) tag("remove") hook_joiner_female(5, 7, 6, tab_protrusion_width, 2, 0.2, 0.2);
                attach(BOTTOM) back(18) zrot(90) tag("remove") hook_joiner_female(5, 7, 6, tab_protrusion_width, 2, 0.2, 0.2);
                attach(TOP) prismoid(size1=[12, 44], size2=[12, 30], h=9, anchor=TOP);
            }
        }
        up(0) cyl(r=inner_radius, h=121);
        down(43) right(10) cuboid([50, 50, 30], anchor=LEFT+BOTTOM);
    }

    down(knobz/2+120+30) 
    difference() {
        linear_extrude(30) hexagon(17/(sqrt(3)/2), rounding=1);
        cuboid([100, 100, 100], anchor=BACK);
        down(e) linear_extrude(31) hexagon(12, rounding=1);
    }
    
    down(150) right(50) {
        difference() {
            union() {
                linear_extrude(30) hexagon(18, rounding=1);
                up(10) linear_extrude(10) hexagon(25, rounding=1);
            }
            down(e) linear_extrude(31) hexagon(12, rounding=1);
            cuboid([100, 100, 100], anchor=BACK);
            up(15) cyl(r=inner_radius, h=10);
            if (!male) {
                translate([-18, -e, 15]) yrot(180) xrot(90) hook_joiner_female(5, 7, 6, tab_protrusion_width, 2, 0.2, 0.2);
                translate([ 18, -e, 15]) xrot(90) hook_joiner_female(5, 7, 6, tab_protrusion_width, 2, 0.2, 0.2);
            }
            back(18*sqrt(3)/2) cuboid([100, 100, 100], anchor=FRONT);
        }
        if (male) {
            translate([-18, e, 15]) xrot(90) hook_joiner_male(5, 7, 6, tab_protrusion_width, 2);
            translate([ 18, e, 15]) yrot(180) xrot(90) hook_joiner_male(5, 7, 6, tab_protrusion_width, 2);
        }
    }
}


back(20)
half_knob(male=true);

fwd(20)
yflip()
half_knob(male=false);


back(100) {
    difference() {
        union() {
            down(200) linear_extrude(200) hexagon(12, rounding=1);
            cyl(r=inner_radius, h=5);
            down(35) cyl(r=inner_radius, h=5);
            down(200) cyl(r=inner_radius, h=5);
        }
        up(6) back(12*sqrt(3)/2-e) cuboid([50, 50, 250], anchor=FRONT+TOP);
    }
}

back(100) right(50) {
    difference() {
        union() {
            down(200) linear_extrude(200) hexagon(12, rounding=1);
            cyl(r=inner_radius, h=5);
            down(200) cyl(r=inner_radius, h=5);
        }
        up(6) back(12*sqrt(3)/2-e) cuboid([50, 50, 250], anchor=FRONT+TOP);
    } 
}


