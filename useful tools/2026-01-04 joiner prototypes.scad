include <BOSL2/std.scad>

// Experiments with joiners
//t1 = 4;
//t2 = 4;
e = 0.01;
//slop_hole_x = 0.25;
//slop_hole_y = 0.25;


/*
module tab_joiner_male0() {
    color("red") cuboid([t2, t1, 3], anchor=BOTTOM+LEFT)
    position(RIGHT)
    color("blue") up(3/2) prismoid(size1=[2, t1], size2=[0,t1], h=0.4, shift=[-1,0], anchor=BOTTOM+RIGHT);
}

module tab_joiner_female0() {
    tag("remove") {
    color("red") cuboid([t2, t1, 3], anchor=BOTTOM+FRONT)
    position(RIGHT)
    color("blue") up(3/2) prismoid(size1=[2, t1], size2=[0,t1], h=0.4, shift=[-1,0], anchor=BOTTOM+RIGHT);
    }
}

back(100) {
cuboid([20, 40, t1], anchor=LEFT+BOTTOM)
    position(LEFT) orient(BACK) {
        tab_joiner_male0();
    }
    
    
left(10) diff() cuboid([t2, 40, 20], anchor=RIGHT+BOTTOM)
    position(BOTTOM) orient(BACK) {
        tab_joiner_female0();
    }
}
*/

// The above tries but doesn't allow for knowing the direction inward, so now I'll try orient being the direction pointing inwards along the plane of the wall (for male, the plane of the edge)
// the orient direction should be the direction _along the plane of the wall_ that best points inward
/*
module tab_joiner_male() {
    right(e) up(1) down(t1/2) cuboid([t2-0.6, 1.5, t1-1], anchor=BOTTOM+RIGHT)
    position(LEFT)
    color("blue") back(1.5/2) prismoid(size1=[2, t1-1], size2=[0,t1-1], h=tab_protrusion_width, shift=[1,0], orient=BACK, anchor=BOTTOM+LEFT);
}

module tab_joiner_female() {
    tag("remove") {
    right(e) up(1) right(0.6/2) cuboid([t2-0.6, 1.5+slop_hole_y, t1-1+slop_hole_x], anchor=BOTTOM)
    position(LEFT)
        back(slop_hole_y/2-e)
    color("blue") back(1.5/2) prismoid(size1=[2, t1-1+slop_hole_x], size2=[0,t1-1+slop_hole_x], h=tab_protrusion_width+slop_hole_y, shift=[1,0], orient=BACK, anchor=BOTTOM+LEFT);
    }
}

back(50) {
cuboid([20, 20, t1], anchor=LEFT+BOTTOM)
    position(LEFT) orient(UP) {
        back(6) tab_joiner_male();
        fwd(6) tab_joiner_male();
    }
    
left(10) diff() cuboid([t2, 20, 20], anchor=RIGHT+BOTTOM)
    position(BOTTOM) orient(UP) {
        back(6) tab_joiner_female();
        fwd(6) tab_joiner_female();
    }
}
*/

// Then I realized to make it more general, I shouldn't have the joiner know about 90 degree joins... so just make it simpler. The things that use the joiner need to be the ones to dictate exactly where they go... which makes it more general and not limited to 90 degree wall joins. At the same time, we can use cyls to make it a bit easier. / After experimenting with this, I decided that it's better to go with an approach based on the anisotropic tab above. Later it might be useful to have an option to have a two-sided tab, but one reason why I might not want to do that yet is because it would be important to do the math right, and it will fail fast in the one-sided tab case as I dev it. And for now, one-sided is totally fine for my purposes. But still doing the simpler way of not worrying about 90degree joins.
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

/*
{
cuboid([20, 20, t1], anchor=LEFT+BOTTOM)
    fwd(6) up(0.5) attach(LEFT) {
        hook_joiner_male(1.5, t1-1, t2-0.6, tab_protrusion_width, 2);
        left(12) hook_joiner_male(1.5, t1-1, t2-0.6, tab_protrusion_width, 2);
    }
   
    
left(10) diff() cuboid([t2, 20, 20], anchor=RIGHT+BOTTOM)
    fwd(6) up(0.5) up(t1/2) down(20/2) attach(RIGHT) {
        hook_joiner_female(1.5, t1-1, t2-0.6, tab_protrusion_width, 2, slop_xy);
        right(12) hook_joiner_female(1.5, t1-1, t2-0.6, tab_protrusion_width, 2, slop_xy);
    }
}
*/

// Printed vertically (not recommended): Snap together like Legos but a bit harder than below. When pulling apart with pliers, it broke. 
// Printed horizontally with supports: hard to insert and didn't align flush, probably because of supports. Maybe use a higher slop value.
/*
fwd(50) {
   cuboid([10, 20, 10], chamfer=1, except=LEFT, anchor=LEFT+BOTTOM)
        up(2) down(10/2-5/2) attach(LEFT) hook_joiner_male(3, 5, 5, tab_protrusion_width, 2);
   left(20) diff() cuboid([10, 20, 10], chamfer=1, except=RIGHT, anchor=RIGHT+BOTTOM)
        up(2) down(10/2-5/2) attach(RIGHT) hook_joiner_female(3, 5, 5, tab_protrusion_width, 2, slop_xy);
}
*/

/* --- THIS SECTION IS IMPORTANT >>>>>

Some notes on parameters based on my experiments

Print vertically or horizontally?
Vertically: In theory, it's not a good idea if there's going to be stress, because the stress will be in the direction of weakness
(perpendicular to the layer lines). However, printing in this direction isn't affected by build plate "brim" (is there another word for
the very small extension that happens at the perimeter of the object where it meets the build plate?) or supports, and
in fact I consistently got really satisfying results. These parameters actually gave a very satisfying snapping together 
like Legos. I was able to pull them apart (with pliers!) and put them back together a few times before the connection got a bit looser.

    x=5, y=7, z=6, tab_protrusion_width=0.4, tz=2, xslop=0.2, yslop=0.2

Horizontally: In theory these will be stronger since stress will not be against the layer lines. But you'll be dealing with 
supports, and if there isn't a good interface at the tab-support interface, then you really need to trim it down so that that 
surface of the tab isn't going to cause problems when you stick it in. Also, I found the "brim" as described above was 
particularly annoying at preventing a perfect fit, so you might have to trim that off a bit too, from the female side too
if it's going to come in the way of a flush mating. The same parameters above got a pretty good well-around fit this way.

You can avoid supports by having the bottom of the tab flush with the build plate.

Here's a way to get really small tabs. This actually fit together pretty well. Forcibly taking it apart destroyed it though.
    x=3, y=5, z=5, same other params
    
Some more observations:
- Using tab_protrusion_width=0.8 was too hard to put together.
- Using an xslop of 0.1 was still possible to put together, but noticably tougher, but also held together better

Here are some examples. One more thing... even if Bambu studio wants to put supports on the female pieces, I don't do supports on them.

OK, so out of all of these, the ones with the hook pointing vertically up is by far the best fit.

Here's a note about a previous design that I won't delete for reference because it's a good lesson:
> all the others attach a little bit askew and are hard to even align correctly. I think this is mainly
> because of the taper effect in the y-direction, actually. This can be very accurately printed when the hook
> is pointing up, but when the female part is printed on the side, the taper manifests as two "bumps" of a layer, since
> layers are discretized at a resolution of 0.2. The hook then has a problem getting past these bumps cleanly. 
Then I fixed this problem by having no y-taper for females.

When printing this experiment, separate into objects or parts, and avoid supports on all the female parts. 
Use supports on the "0" and "1"s.

Experiments...

Bad fits:
C0 male / C3 female - support interface interferes
A1 / A2
B0 / B0
A0 / A1
C3 / C0 - cracked, not sure why
B1 / B1 - probably support issue again

Good fits:
B3 / B3
C2 / C2
A3 / A3
C1 / C1
A0 / A2 (A2 broke easily when prying apart)
B2 / B0 (B2 broke easily when prying apart)

Another experiment:
C2 / C0 - this had trouble going in at first. I think we don't want the "negative hook" part of the female part to be a bridge, but... it also could be OK. After working with B1/B0 and A2/A0 I think I just didn't push in hard enough the first time.
B1 (trimmed well) / B0 - this fit fine.
C1 / C3 - had a hard time fitting, able to squish together with pliers and it turned out OK, but wasn't that satisfying click
C0 / C1 - fit fine. In this case I chopped off A LOT of the support interface exposing the grid inside. So this implies that chopping off the support interface, the correct amount, is important.
C3 / C2 - totally fine, good amount of resistance, a little click. I didn't need to chop off the "brim" this time.
A2 / A0 - this went in with a satisfying click. 
B0 / B1 - fine
B2 / B3 - fine
B3 / B2 - fine
A3 / A3 - good
A1 / A1 - fine
A0 / A2 - didn't trim enough and as a result it didn't fit quite right, I used pliers and it started to crack.

What this means:
Yes, printing the male parts vertically ("2"s) causes it to break easily when prying apart.
Male "0"s and "1"s, where there are supports, need special attention to trim the supports. If you trim the supports good enough it will probably work. Make sure to avoid printing supports on the face with the hook.
Females should be able to be printed in any direction with just bridges (without supports).

<<<< THAT'S THE IMPORTANT PART ----
*/

xslop = 0.2;
yslop = 0.2;
tab_protrusion_width = 0.4;

module three_samples(x, y, z, dz, letter="A") {
fwd(25) {
    diff() cuboid([10, 12, 20], chamfer=1, except=LEFT, anchor=LEFT+BOTTOM) {
        fwd(2) back(10/2-5/2) attach(LEFT) zrot(90) hook_joiner_male(x, y, z, tab_protrusion_width, dz);
        attach(RIGHT) tag("remove") up(e) fwd(3) text3d(str_join([letter, "0↑"]), size=6, anchor=TOP);
    }
    left(20) diff() cuboid([10, 12, 20], chamfer=1, except=RIGHT, anchor=RIGHT+BOTTOM) {
        fwd(2) back(10/2-5/2) attach(RIGHT) zrot(-90) hook_joiner_female(x, y, z, tab_protrusion_width, dz, xslop, yslop);
        attach(LEFT) tag("remove") up(e) fwd(3) text3d(str_join([letter, "0↑"]), size=6, anchor=TOP);
    }
}
    
back(0) {
    diff() cuboid([10, 20, 12], chamfer=1, except=LEFT, anchor=LEFT+BOTTOM) {
        up(2) down(10/2-5/2) attach(LEFT) hook_joiner_male(x, y, z, tab_protrusion_width, dz);
        attach(RIGHT) tag("remove") up(e) fwd(3) text3d(str_join([letter, "1↑"]), size=6, anchor=TOP);
    }
    left(20) diff() cuboid([10, 20, 12], chamfer=1, except=RIGHT, anchor=RIGHT+BOTTOM) {
        up(2) down(10/2-5/2) attach(RIGHT) hook_joiner_female(x, y, z, tab_protrusion_width, dz, xslop, yslop);
        attach(LEFT) tag("remove") up(e) fwd(3) text3d(str_join([letter, "1↑"]), size=6, anchor=TOP);
    }
}

back(25) {
    diff() cuboid([12, 20, 10], chamfer=1, except=TOP, anchor=LEFT+BOTTOM) {
        right(2) left(10/2-5/2) zrot(-90) attach(TOP) hook_joiner_male(x, y, z, tab_protrusion_width, dz);
        attach(RIGHT) tag("remove") up(e) fwd(3) text3d(str_join([letter, "2↑"]), size=6, anchor=TOP);
    }
    left(20) diff() cuboid([12, 20, 10], chamfer=1, except=TOP, anchor=RIGHT+BOTTOM) {
        left(2) right(10/2-5/2) zrot(90) attach(TOP) hook_joiner_female(x, y, z, tab_protrusion_width, dz, xslop, yslop);
        attach(LEFT) tag("remove") up(e) fwd(3) text3d(str_join([letter, "2↑"]), size=6, anchor=TOP);
    }
}

back(50) {
    difference() {
        down(0.2) diff() cuboid([10, 20, 12], chamfer=1, except=LEFT, anchor=LEFT+BOTTOM) {
            down(12/2-y/2) attach(LEFT) hook_joiner_male(x, y, z, tab_protrusion_width, dz);
            attach(RIGHT) tag("remove") up(e) fwd(3) text3d(str_join([letter, "3↑"]), size=6, anchor=TOP);
        }
    }
    left(20) diff() cuboid([10, 20, 12], chamfer=1, except=RIGHT, anchor=RIGHT+BOTTOM) {
        attach(RIGHT) hook_joiner_female(x, y, z, tab_protrusion_width, dz, xslop, yslop);
        attach(LEFT) tag("remove") up(e) fwd(3) text3d(str_join([letter, "3↑"]), size=6, anchor=TOP);
    }
}
}

left(60) three_samples(3, 5, 5, 2, "A");
three_samples(5, 7, 6, 2, "B"); //str(xslop));
right(60) three_samples(8, 8, 8, 4, "C");


// Following, some old things I can delete probably ....

// Printed vertically (not recommended) (slop 0.2): Snap together like Legos. Satisfying. Able to pull apart (with pliers) without damage and put together a couple times, especially if when pulling apart you wiggle it along the strong axis.
// Printed horizontally: if with supports, make sure to trim the support surface. Also the build plate interface "skirt" can also cause the pieces to not fit quite right.

// vertical: 0.2, 0.4 - still satisfying to put together!
// horizontal: 0, 0.4
// horizontal: 0, 0.8 - too hard to put together
// horizontal: 0, 1.2
// horizontal: 0.1, 0.8

// now trying different x/y slops. tab, xslop, yslop
// horizontal: 0.4, 0.2, 0.2 - same as other - satisfying resistance, like Legos
// horizontal: 0.4, 0.2, 0.4 
// horizontal: 0.4, 0.2, 0.6 - possible to pull apart with fingers
// horizontal: 0.4, 0.1, 0.4 - a little bit tougher than 0.4,0.2,0.2, but it works

// 



// Printed horizontally with supports (slop 0.2): hard to insert and didn't align flush. Try a higher slop value.
// Printed horizontally without supports with tab flush on plate (slop 0.2): doesn't quite align to flush, also too easy to insert.
// Printed horizontally with supports (slop 0.4, trimmed support interface): slop is too much.
// Printed horizontally without supports with tab flush on plate (slop 0.2, tab_protrusion_width=0.4, try again): 
// Printed horizontally without supports with tab flush on plate (slop 0.2, tab_protrusion_width=0.6): 
// Printed horizontally with supports (slop 0.2, trimmed support interface): 

/*
fwd(100) {
   cuboid([10, 20, 10], chamfer=1, except=LEFT, anchor=LEFT+BOTTOM)
        up(2) down(10/2-5/2) attach(LEFT) hook_joiner_male(5, 7, 6, tab_protrusion_width, 2);
   left(20) diff() cuboid([10, 20, 10], chamfer=1, except=RIGHT, anchor=RIGHT+BOTTOM)
        up(2) down(10/2-5/2) attach(RIGHT) hook_joiner_female(5, 7, 6, tab_protrusion_width, 2, 0.2, 0.2);
}

fwd(50) {
   cuboid([10, 20, 10], chamfer=1, except=LEFT, anchor=LEFT+BOTTOM)
        up(2) down(10/2-5/2) attach(LEFT) hook_joiner_male(5, 7, 6, tab_protrusion_width, 2);
   left(20) diff() cuboid([10, 20, 10], chamfer=1, except=RIGHT, anchor=RIGHT+BOTTOM)
        up(2) down(10/2-5/2) attach(RIGHT) hook_joiner_female(5, 7, 6, tab_protrusion_width, 2, 0.2, 0.4);
}

fwd(0) {
   cuboid([10, 20, 10], chamfer=1, except=LEFT, anchor=LEFT+BOTTOM)
        up(2) down(10/2-5/2) attach(LEFT) hook_joiner_male(5, 7, 6, tab_protrusion_width, 2);
   left(20) diff() cuboid([10, 20, 10], chamfer=1, except=RIGHT, anchor=RIGHT+BOTTOM)
        up(2) down(10/2-5/2) attach(RIGHT) hook_joiner_female(5, 7, 6, tab_protrusion_width, 2, 0.2, 0.6);
}

fwd(-50) left(10) {
   cuboid([10, 20, 10], chamfer=1, except=LEFT, anchor=LEFT+BOTTOM)
        up(2) down(10/2-5/2) attach(LEFT) hook_joiner_male(5, 7, 6, tab_protrusion_width, 2);
   left(20) diff() cuboid([10, 20, 10], chamfer=1, except=RIGHT, anchor=RIGHT+BOTTOM)
        up(2) down(10/2-5/2) attach(RIGHT) hook_joiner_female(5, 7, 6, tab_protrusion_width, 2, 0.1, 0.4);
}
*/

/*
right(30)
hook_joiner_male(1.5, t1-1, t2-0.6, tab_protrusion_width, 2);
right(40) 
hook_joiner_female(1.5, t1-1, t2-0.6, tab_protrusion_width, 2, 0.2, 0.4);
*/
