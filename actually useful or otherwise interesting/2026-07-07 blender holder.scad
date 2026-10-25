include <BOSL2/std.scad>

e = 0.01;

pad_x = 30;
pad_y = 40;
pad_z = 0.1;

pad_x2 = 80;
pad_y2 = 20; 
pad_z2 = 4;

pillarbase_halfx = 60;

// base
basex = 2*pillarbase_halfx + 10;
basey = 150;
base_dx = basex/2-5;
base_dy = basey/2+0; // distance from center to arm, in y-direction
base_z2 = 140; // in lower part, distance from joint to top plane of base


module connectors(slop=0.0) {
    zflip() {
        left(7) prismoid(size1=[9+slop, 5+slop], size2=[11+slop, 8+slop], shift=[1,-1.5], h=15, anchor=TOP);
        right(7) prismoid(size1=[9+slop, 5+slop], size2=[11+slop, 8+slop], shift=[-1,1.5], h=15, anchor=TOP);
    }
}

module connector_group(male=true) {
    if (male) {
        cuboid([35, 15, 20], anchor=TOP);
        fwd(base_dy) zrot(90) back(base_dx) cuboid([35, 15, 20], anchor=TOP);
        fwd(base_dy) zrot(-90) back(base_dx) cuboid([35, 15, 20], anchor=TOP);
        connectors(slop=0);
        fwd(base_dy) zrot(90) back(base_dx) connectors(slop=0);
        fwd(base_dy) zrot(-90) back(base_dx) connectors(slop=0);
    }
    else {
        connectors(slop=0.5);
        fwd(base_dy) zrot(90) back(base_dx) connectors(slop=0.5);
        fwd(base_dy) zrot(-90) back(base_dx) connectors(slop=0.5);
    }
}


// per-pad size / anchor / placement -- single source of truth
s1 = [pad_x, pad_y, pad_z];  a1 = LEFT+BACK+TOP;     t1 = [50, -40,  0];  // contact TOP,   back BOTTOM
s2 = [pad_x, pad_z, pad_y];  a2 = LEFT+FRONT+BOTTOM; t2 = [50,   0, 40];  // contact FRONT, back BACK
s3 = [pad_z2, pad_x2,    pad_y2];     a3 = RIGHT+BOTTOM;      t3 = [ 0,   0, 80]; // contact RIGHT, back LEFT

// Back face of each pad (opposite the contact face), in the pad's own frame.
// A little redundant with size/anchor above, but simpler than deriving it.
f1 = [[0,-pad_y,-pad_z], [pad_x,-pad_y,-pad_z], [pad_x,0,-pad_z],     [0,0,-pad_z]];    // pad1 BOTTOM face
f2 = [[0, pad_z, 0],     [pad_x, pad_z,0],      [pad_x,pad_z,pad_y],  [0,pad_z,pad_y]];    // pad2 BACK face
f3 = [[-pad_z2,-pad_x2/2,0], [-pad_z2,pad_x2/2,0],      [-pad_z2,pad_x2/2,pad_y2], [-pad_z2,-pad_x2/2,pad_y2]]; // pad3 LEFT face

pillar_x = 25;
pillar_y = 20;
pillar_x2 = 30;
pillar_y2 = 15;

upness = 30;
base_thickness = 10;

function orient_p(pts) = xrot(-70, p = zrot(-90, p = xrot(-45, p = pts)));

difference() {
    union() {
        // The rotations of 3.11 are due to the pitcher's wall taper
        color("red")
        xrot(-70) zrot(-90) xrot(-45) {
            translate(t1) yrot(-3.11) cuboid(s1, rounding=0, edges=TOP,   anchor=a1);
            translate(t2) zrot(-3.11) cuboid(s2, rounding=0, edges=FRONT, anchor=a2);
            xrot(45) translate(t3) cuboid(s3, rounding=1, edges=RIGHT, anchor=a3);
        }

        pad1_back = move(t1, p = yrot(-3.11, p = f1));
        pad2_back = move(t2, p = zrot(-3.11, p = f2));
        pad3_back = xrot(45, p = move(t3, p = f3));

        skin([orient_p(pad1_back), 
            translate([-pillarbase_halfx, 5, 40], zrot(45, path3d(reverse(rect([pillar_y, pillar_x]))))),
            translate([-pillarbase_halfx, 0, 0], zrot(0, path3d(reverse(rect([pillar_y, pillar_x])))))], slices=50);
        skin([orient_p(pad2_back), 
            translate([pillarbase_halfx, 5, 40], zrot(135, path3d(reverse(rect([pillar_y, pillar_x]))))),
            translate([pillarbase_halfx, 0, 0], zrot(180, path3d(reverse(rect([pillar_y, pillar_x])))))], slices=50);
        skin([orient_p(pad3_back), translate([0, 80, 0], zrot(90, path3d(reverse(rect([pillar_y2, pillar_x2])))))], slices=0);

        translate([-pillarbase_halfx, 0, 0]) cuboid([pillar_y, pillar_x, upness], anchor=TOP);
        translate([pillarbase_halfx, 0, 0]) cuboid([pillar_y, pillar_x, upness], anchor=TOP);
        translate([0, 80, 0]) cuboid([pillar_x2, pillar_y2, upness], anchor=TOP);

        down(upness) {
            color("blue") difference() {
                intersection() {
                    cyl(r=89, h=base_thickness, anchor=TOP);
                    fwd(pillar_x/2) cuboid([2*pillarbase_halfx+pillar_y, 100, base_thickness], anchor=TOP+FRONT);
                }
                fwd(e) up(e) intersection() {
                    cyl(r=73, h=base_thickness+1, anchor=TOP);
                    fwd(pillar_x/2) cuboid([2*pillarbase_halfx-pillar_y, 100, base_thickness+1], anchor=TOP+FRONT);
                }
            }

            color("darkblue") {
                translate([-pillarbase_halfx, -pillar_x/2, 0]) cuboid([pillar_y, 35, 20], anchor=FRONT);
                translate([ pillarbase_halfx, -pillar_x/2, 0]) cuboid([pillar_y, 35, 20], anchor=FRONT);
            }
        }
        
        
        ring_factor = 94;
        translate([0, 0, 40])
        color("lightgreen") 
        difference() {
            back(ring_factor-30) cyl(r=ring_factor, h=base_thickness, anchor=TOP);
            back(ring_factor-30) up(e) cyl(r=ring_factor-10, h=base_thickness+1, anchor=TOP);
            cuboid([2*ring_factor+1, 2*ring_factor+1, 50], anchor=FRONT);
        }
        
    }

    color("red") translate([0, 80, -40-e]) connector_group(false);
}



// ----- base
fwd(100) 
{
    color("red") connector_group(true);
    
    expansion_shift=10;
    
    basedx = 10;
    down(base_z2) {
        // bottom plate
        back(5) diff() cuboid([basex+2*expansion_shift, basey, 4], anchor=BACK+TOP)
            position(CENTER) tag("remove") cuboid([basex+2*expansion_shift-2*basedx, basey-2*basedx, 12]);
       
        // vertical legs
        prismoid(size1=[35, 10], size2=[35, 15], h=base_z2-20);
        fwd(base_dy) zrot(90) back(base_dx+expansion_shift) prismoid(size1=[35, 10], size2=[35, 15], shift=[0, -expansion_shift], h=base_z2-20);
        fwd(base_dy) zrot(-90) back(base_dx+expansion_shift) prismoid(size1=[35, 10], size2=[35, 15], shift=[0, -expansion_shift], h=base_z2-20);
        
        // cross bars
        difference() {
            union() {
                back(7.5) left(3.5) up(base_z2-10) xrot(90) prismoid(size1=[14, 10], size2=[12, 10], shift=[-basex/2+17-expansion_shift/2, -0.5*base_z2+10], h=basey/2-10, anchor=FRONT+BOTTOM+RIGHT);
                back(7.5) right(3.5) up(base_z2-10) xrot(90) prismoid(size1=[14, 10], size2=[12, 10], shift=[basex/2-17+expansion_shift/2, -0.5*base_z2+10], h=basey/2-10, anchor=FRONT+BOTTOM+LEFT);
            }
            up(base_z2) cuboid([35, 15, 20], anchor=TOP);
        }

        fwd(basey-5) left(basex/2 + expansion_shift) prismoid(size1=[10, 12], size2=[12, 12], shift=[expansion_shift/2, basey/2-15], h=base_z2/2-10, anchor=BOTTOM+FRONT+LEFT);
        fwd(basey-5) right(basex/2 + expansion_shift) prismoid(size1=[10, 12], size2=[12, 12], shift=[-expansion_shift/2, basey/2-15], h=base_z2/2-10, anchor=BOTTOM+FRONT+RIGHT);
    }
}







// ---- pitcher (measure/tune these) ----
body_w    = 120;    // face-to-face width at the grip height
base_w    = 95;     // width up at the narrow (blade) end -- taper, ghost only
corner_r  = 15;     // rounded corner radius
pitcher_h = 230;    // body height (ghost only)
tilt      = 20;     // deg: diagonal tilt, spout corner tips down. Flip sign if backwards.
spout_local  = zrot(45, p = [-body_w/2, -body_w/2, 0]);   // spout corner, opening rim
spout_tilted = xrot(tilt, p = spout_local);
module place() { move(-spout_tilted) xrot(tilt) zrot(45) children(); }

// ---- translucent reference pitcher, to eyeball the fit ----
% place() pitcher();
module pitcher() {
    prismoid(size1=[body_w, body_w], size2=[base_w, base_w],
             h=pitcher_h, rounding=corner_r, anchor=BOTTOM);
    // little spout nub at the -X/-Y opening corner
    translate([-body_w/2, -body_w/2, 0])
        cuboid([26, 26, 14], rounding=4, anchor=TOP);
}
