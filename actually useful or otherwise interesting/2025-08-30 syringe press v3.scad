include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <BOSL2/rounding.scad>

// https://thors.com/threaded-fastener-parts-and-terminology/

fnhr = 36; // Should be 180 for final export - controls smoothness of screw and nut
fn = 36; // Can be less, as it's mainly for aesthetics
e = 0.01;

// screw parameters
major_diameter = 20;
minor_diameter = 10;
pitch = 15;

depth = pitch * (major_diameter - minor_diameter)/major_diameter;
root_y = -depth/pitch;
minor_radius = (major_diameter-pitch)/2; // ???? wild guess ????

dx = 0.25;
fudgex = 0.05;
fudgey1 = 0.05;
fudgey2 = 0.05;

//l = 152; // screw length: 143 is final, er 152 is final
l = 117; // screw length not including part that will end up in nut: 117 is final

knob_scale = 40;
knob_height = 15;

gr = 15;   // radius of syringe body
gp = 17.5; // radius of top of syringe plunger

sl = 132;  // final gutter length from slot to nut
st = 5;    // gutter thickness
nl = 20;   // nut length
nt = gp+st;    // nut radius, must be > major_diameter/2

lnl = l + nl;
fph = minor_radius+2; // flat plate height
slb = 20; // screw lower buffer

spr = 31; // slotted part radius (outer)
sph = 25; // slotted part height, not including the tapered support
tsh = 8; // slotted part tapered support height; tsh+spz needs to be <=13
spz = 5; // amount of slotted part (not including tapered support) on the + end of the syringe

traph = 16; // equivalent to the front cut plane
trapw1 = 8; // whatever looks nice
trapw2 = spr-gp;


profile = [
    [-0.5, root_y],
    [-dx, root_y],
    [-dx, 0.0],
    [dx, 0.0],
    [dx, root_y],
    [0.5, root_y]
];

profile2 = [
    [-0.5, root_y+fudgey1],
    [-dx-fudgex, root_y+fudgey1],
    [-dx-fudgex, fudgey2],
    [dx+fudgex, fudgey2],
    [dx+fudgex, root_y+fudgey1],
    [0.5, root_y+fudgey1]
];

/*
// Code for studying positive/negative - leave commented out but don't delete!
back(50)
difference() {
    union() {
        left_half()
        generic_threaded_rod(d=major_diameter, l=lnl, pitch=pitch, starts=3, profile=profile, $fn=fn);

        color("red")
        up(pitch/2) right_half()
        generic_threaded_rod(d=major_diameter, l=lnl, pitch=pitch, starts=3, profile=profile2, internal=true, $fn=fn);
    }

    up(lnl/2 + 1) cuboid([50, 50, 50]);
}
*/


// screw - print with PETG with 4 wall loops (the screw part will be solid), 15% gyroid infill: 50.40g (clear/blue)
// PLA (dark red)
right(100)
union() {
    up((lnl+fph-slb)/2) diff() generic_threaded_rod(d=major_diameter, l=lnl+fph+slb, pitch=pitch, starts=3, profile=profile, $fn=fnhr) {
        position(TOP) tag("remove") up(e) cyl(r=minor_radius+e, h=5, $fn=fn, anchor=TOP);
        position(BOTTOM) tag("remove") cyl(r=major_diameter/2+1, h=slb, anchor=BOTTOM);
    }
    up(lnl+fph-4) sphere(r=minor_radius, $fn=fn);
    
    // knob
    rounded_prism(hexagon(knob_scale), height=knob_height,
                  joint_top=2, joint_bot=2, joint_sides=2, anchor=TOP);
}



/*
// flat plate
right(100) up(lnl+fph+5)
diff() cyl(r=gp-2, h=fph)
    position(BOTTOM) tag("remove") up(1) sphere(r=minor_radius+e, $fn=fn);
*/

// main part - PETG, support on build-plate only makes it easier to remove supports at the slot.
// If support interface is a different material, it makes it weaker. 
// 4 wall loops, 15% gyroid infill: 107.03g model, 116.97g total (clear/blue PETG)
// Same parameters except PLA (textured plate): 107.51g model, 117.51g total (white PLA)

difference() {
    union() {
        // main gutter
        diff() cyl(r=gp+st, h=sl+fph+2, $fn=fn, anchor=BOTTOM)
            tag("remove") cyl(r=gp, h=sl+fph+3, $fn=fn)
            tag("remove") cuboid([2*(gp+st+1), gp+st+1, sl+fph+3], anchor=BACK);
        
        up(spz+tsh) diff() skin([hexagon(knob_scale), circle(gp+st)], z=[0,20], slices=5, $fn=fn) {
            tag("remove") cyl(r=gp, h=sl+fph+3, $fn=fn);
            tag("remove") cuboid([2*gp, 16+e, 20], anchor=BACK+BOTTOM);
            tag("remove") color("red") fwd(16) prismoid(size1=[2*knob_scale, 0], size2=[2*knob_scale, 16], shift=[0,8], height=20+e, anchor=BACK+BOTTOM);
        }
        
        // slotted part
        up(spz) cyl(r=spr, h=sph, rounding=2, $fn=fn, anchor=TOP);
        up(spz) cyl(r=spr, h=2, $fn=fn, anchor=TOP); // hack to cover up the rounded part of the top edge
        
        // extra hexagonal grip
        down(sph-spz) rounded_prism(hexagon(knob_scale), height=sph+tsh, joint_top=0, joint_bot=2, joint_sides=2, anchor=BOTTOM);

    }

    // cutouts to the slotted part
    union() {
        up(spz+tsh+e) cyl(r=gr, h=sph+tsh+1, $fn=fn, anchor=TOP);
        up(spz+tsh+e) cuboid([2*gr, spr+1, sph+tsh+1], anchor=BACK+TOP);
        up(spz+tsh+e) cyl(r1=gr, r2=gp, h=4, $fn=fn, anchor=TOP); // cutout for inner support part
        up(spz+tsh+e) prismoid(size1=[2*gr, 40], size2=[2*gp, 40], h=4, anchor=TOP+BACK); // getting into the details

        color("red") back(9) prismoid(size1=[45, 3], size2=[22, 3], h=8, orient=BACK, anchor=FRONT+BOTTOM);
        color("pink") back(9) cuboid([45, 50, 3], anchor=BACK+TOP);
        color("#ff8080") fwd(16) up(5+8+20+e) cuboid([2*knob_scale, 21, 25+8+20+1], anchor=BACK+TOP);

    }
}


// nut: the zrot(-7.5) is experimentally determined so that the hexagons line up satisfyingly when screwed all the way in
up(sl+fph+nl/2)
difference() {
    cyl(r=nt, l=nl, rounding=2, $fn=fn);
    zrot(-7.5) generic_threaded_rod(d=major_diameter, l=l, pitch=pitch, starts=3, profile=profile2, internal=true, $fn=fnhr);
}

// gutter/nut attachment
up(sl+fph+nl/2)
diff() cyl(r=gp+e, h=nl, $fn=fn) {
    tag("remove") cuboid([2*(gp+1), gp+1, nl+1], anchor=BACK);
    tag("remove") cyl(r=major_diameter/2+nt-e, l=nl+1, $fn=fn);
}

up(sl) diff() cyl(r1=gp+st-0.5, r2=spr, h=nl+fph, rounding=2, $fn=fn, anchor=BOTTOM)
    tag("remove") cyl(r=gp, h=nl+fph+1);

// extra hexagonal grip
up(nl) up(sl+fph) diff() rounded_prism(hexagon(knob_scale), height=knob_height, joint_top=2, joint_bot=2, joint_sides=2, anchor=TOP)
    tag("remove") cyl(r=gr, h=nl+1);

// outer support for this end
up(sl+fph+nl-knob_height) diff() cyl(r1=gp+st, r2=spr, h=20, $fn=fn, anchor=TOP) // outer support below the gutter
    tag("remove") cyl(r=gp, h=40+1, $fn=fn)
    tag("remove") cuboid([2*(spr+1), spr+1, sl+1], anchor=BACK);

// Had to guess at the 2.875, not sure how that's derived!
left(gp) up(sl+fph+nl-knob_height) skin([trapezoid(traph, trapw1, trapw2, shift=(trapw1-trapw2)/2), right(2.875, back(traph/2, rect([st, 0])))], z=[0,-20], slices=5, anchor=RIGHT+BACK+TOP);

left(-gp) up(sl+fph+nl-knob_height) skin([trapezoid(traph, trapw1, trapw2, shift=-(trapw1-trapw2)/2), right(-2.875, back(traph/2, rect([st, 0])))], z=[0,-20], slices=5, anchor=LEFT+BACK+TOP);



/*
// attachments to experiment with for left-hand grip (TODO: can delete this later)
slop=0.2;
left(100)
union() {
    difference() {
        union() {
            rounded_prism(hexagon(knob_scale), height=knob_height, joint_top=2, joint_bot=2, joint_sides=2, anchor=TOP);
            //cuboid([2*knob_scale, 16, knob_height], rounding=1, $fn=fn, anchor=BACK+TOP);
        }
        up(e) cyl(r=spr+slop, h=knob_height+1, anchor=TOP);
        //fwd(16) up(5+8+20+e) cuboid([50, 21, 25+8+20+1], anchor=BACK+TOP);
        up(e) cuboid([2*gr+slop, 100, 50], anchor=BACK+TOP);
        fwd(16) cuboid([100, 50, 50], anchor=BACK);
    }
    //fwd(16+slop) left(gr) cuboid([8, 10, knob_height], anchor=RIGHT+TOP+BACK);
    //fwd(16+slop) right(gr) cuboid([8, 10, knob_height], anchor=LEFT+TOP+BACK);
}
*/

//press plate (for future reference but probably not going to use)
/*
gw = 57;
gh = 45;
gt = 5;
gl = 80;
gs = 2;
left(100) up(gl + 20)
diff() cuboid([gw, gh, gt], rounding=1, $fn=fn, anchor=TOP) tag("remove") down(e) position(BOTTOM) {
    cuboid([2*gp,gh/2+e,gs], anchor=FRONT+BOTTOM);
    cylinder(h=gs, r=gp, anchor=BOTTOM);
}
*/ 

        
