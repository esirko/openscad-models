include <BOSL2/std.scad>
include <BOSL2/walls.scad>

/*
-- Kaia pink cooler TODO

- Fourth ice pack
    - Consider a slot for a fourth ice pack

- Upper attachment and upper walls
    - Figure out final h2 value before printing top half
	- Reconsider the top part, maybe a dowel to hang the bag on, instead of a slot

- Side attachment piece (ice pack to holder interface)
	- expand the base a bit so it can rest on the base (which will also be expanded)
	- Attachment system from ice pack wall to pump holder needs to be attached with several dowels (or other system) so it doesn't rotate

- Position of pump
	- Tweak position of pump - down, forward, rotated a bit more
	- Consider not even being attached to the main apparatus. It could be attached to the base
	- In its current position it seems to make the whole device too wide to fit in the pink bag neatly. Consider pulling it out around front

- Base
	- Expand to the right so it can support the weight of the pump part (probably needs to be two pieces)
	- Consider the base being a drop-in for the unit instead of having to be permanently attached to it.
	- Consider making the base the same as the 2-part bag frame that I was considering before.

- Base should be wimpy
- Upper attachment should be wimpy (for now)
- Side attachment interface wimpy?
*/


// potential outer frame for the whole thing
/*
module hollow_triangle_frame() {
    diff() prismoid(size1=[170,5], size2=[10, 5], h=170, shift=[80,0], anchor=BOTTOM+RIGHT+BACK)
        position(BOTTOM) up(10) right(5) tag("remove") prismoid(size1=[140, 6], size2=[0, 6], h=140, shift=[70,0]);
}

xflip_copy()
right(171) {
    diff() cuboid([5, 170, 170], anchor=BOTTOM+BACK+LEFT)
        tag("remove") cuboid([6, 150, 150]);

    hollow_triangle_frame();
    left(170) up(170/2-5) cuboid([170/2, 5, 10], anchor=BOTTOM+BACK+LEFT);
    fwd(170-5) {
        hollow_triangle_frame();
        left(170) up(170/2-5) cuboid([170/2, 5, 10], anchor=BOTTOM+BACK+LEFT);
    }

    up(5) xrot(90) hollow_triangle_frame();
    fwd(170) xrot(-90) hollow_triangle_frame();
}
*/

e = 0.01;
t = 4;
w = 80;
d = 100;
h = 260;
h1 = 140;
h2 = 100;
h3 = 90;

it=27;
iw=120;
ih=135;

// I usually use 3 for malez and 7 for femalez
barx = 10;
fn=18;
optimize_render = false;

/*
explodez=0;
explodex=0;
explodez2=0;
explodefront=0;

explodez=24;
explodex=18;
explodez2=12;
explodefront=100;
*/

explodez=24;
explodex=18;
explodez2=12;
explodefront=100;

// Experiments
// Non-wimpy, no extra_slop: this makes a permanent connection. You might be able to pry apart, but will be difficult to impossible with hands.
// You could pry them apart with pliers, but it's likely it will break. But if you're able to get a grip with pliers that allows you to wiggle
// it out gently, you can detach without breaking.
// Wimpy, no extra_slop: this is a fairly stable connection that you can pull apart with your hands. But under typical usage it shouldn't
// fall out, especially if stresses are perpendicular (i.e., not actually trying to pull the pieces apart).
// Non-wimpy, 0.2 extra slop: this was actually surprisingly difficult to take apart with hands. It would still be best to use pliers with a wiggling motion. But definitely easier than no extra slop.

module hook_joiner_male(x, y, z, tx, tz, wimpy=false, extra_slop = 0) {
    zrot(180) {
        if (wimpy) {
            wslop=0.2;
            down(e) cuboid([x-wslop-extra_slop, y-wslop-extra_slop, z-tz+2*e], anchor=BOTTOM);
            up(z-tz) left(0)    prismoid(size1=[x-wslop-extra_slop, y-wslop-extra_slop], size2=[x-tx-wslop-extra_slop, y-tx-wslop-extra_slop], shift=[tx/2, tx/2], h=tz, anchor=BOTTOM);
        } else {
            down(e) cuboid([x-extra_slop, y-extra_slop, z-tz+2*e], anchor=BOTTOM);
            up(z-tz) left(tx/2) prismoid(size1=[x + tx-extra_slop, y-extra_slop], size2=[x-tx-extra_slop, y-tx-extra_slop], shift=[tx,   tx/2], h=tz, anchor=BOTTOM); // the -tx terms are for narrowing the top for easier insertion
        }
    }
}

module hook_joiner_female(x, y, z, tx, tz, xslop, yslop) {
    tag("remove") xrot(180) {
        down(e) cuboid([x+xslop, y+yslop, z-tz+2*e], anchor=BOTTOM);
        up(z-tz) left(tx/2) prismoid(size1=[x+tx+xslop, y+yslop], size2=[x+xslop, y+yslop], shift=[tx/2, 0], h=tz, anchor=BOTTOM);
    }
}

module hook_joiner_pair(l, malez=3, femalez=7, xx=[0.15,0.5,0.85], explodez=explodez, explodex=0, rounding_edges=[], rounding_edges_male=[], touchup = 0, wimpy_male=false, extra_slop_male = 0, extra_slop_female = 0) {
    diff() cuboid([barx, malez, l], anchor=LEFT+TOP+FRONT, rounding=2, edges=rounding_edges_male, $fn=fn){
        if (!optimize_render) {
            attach(FRONT) {
                for (x = xx) {
                    fwd((x-0.5)*l) hook_joiner_male(5, 7, 6, 0.4, 2, wimpy=wimpy_male, extra_slop=extra_slop_male);
                }
            }
        }
        //color("red") fwd(e) attach(FRONT) zrot(90) fwd(barx/2) tag("remove") text3d(str_join(["W", str(extra_slop_male)]), size=barx-1, anchor=TOP);
    }

    fwd(explodez) right(explodex)
    diff() cuboid([barx, femalez, l], anchor=LEFT+TOP+BACK, rounding=2, edges=rounding_edges, $fn=fn) {
        if (!optimize_render) {
            attach(BACK)
            for (x = xx) {
                fwd((x-0.5)*l) hook_joiner_female(5, 7, 6, 0.4, 2, 0.2+extra_slop_female, 0.2+extra_slop_female);
            }
            if (abs(touchup) == 1) {
                dir = touchup == 1 ? LEFT+BOTTOM+FRONT : RIGHT+BOTTOM+FRONT;
                position(dir) cuboid([t, 2, 2], anchor=dir); // blue and red lefts
            }
            if (abs(touchup) == 2 && t > 3) {
                dir = touchup > 0 ? RIGHT+BOTTOM+BACK : LEFT+BOTTOM+BACK;
                position(dir) cuboid([2, t-3, 2], anchor=dir); // cyan left
            }
            if (abs(touchup) == 3) {
                dir = touchup > 0 ? LEFT+TOP+FRONT : RIGHT+TOP+FRONT;
                position(dir) cuboid([t, 2, 2], anchor=dir); // top magenta left
            }
            if (abs(touchup) == 4) {
                dir = touchup > 0 ? RIGHT+BOTTOM+BACK : LEFT+BOTTOM+BACK;
                position(dir) cuboid([2, t, 2], anchor=dir); // orange left
            }
        }
    }
}


//right(200) hook_joiner_pair(130);

difference() {
    union() {

        // Bottom sparse wall
        intersection() {
            yrot(-90) sparse_wall(h=w+2*it+4*t, l=2*t+it+d, thick=t, strut=3, max_bridge=30, anchor=LEFT+TOP+BACK);
            right(barx) fwd(t) cuboid([w+2*it+4*t-2*barx, it+d+t, t+2*e], anchor=LEFT+BOTTOM+BACK);
        }

        // Joiners to attach the bottom sparse wall to the outer vertical sparse walls (red and purple) and to the potentially angled base (orange and pink)
                                 down(explodez) xrot(-90) color("orange") hook_joiner_pair(it+d+2*t, femalez=6, xx=[0.1, 0.5], rounding_edges=[RIGHT+BOTTOM], rounding_edges_male=[RIGHT+BOTTOM], touchup=4, wimpy_male=true);
        right((w+2*it+4*t)-barx) down(explodez) xrot(-90) color("orange") hook_joiner_pair(it+d+2*t, femalez=6, xx=[0.1, 0.5], rounding_edges=[LEFT+BOTTOM], rounding_edges_male=[LEFT+BOTTOM], touchup=-4, wimpy_male=true);
                                 up(6) xrot(-90) color("red") hook_joiner_pair(it+d+2*t, malez=e, xx=[0.25, 0.65, 0.9], explodex=-explodex, rounding_edges=[RIGHT+FRONT+BOTTOM], rounding_edges_male=[RIGHT+BOTTOM], touchup=1);
        right((w+2*it+4*t)-barx) up(6) xrot(-90) color("red") hook_joiner_pair(it+d+2*t, malez=e, xx=[0.25, 0.65, 0.9], femalez=10, explodex=explodex, rounding_edges=[LEFT+FRONT+BOTTOM], rounding_edges_male=[LEFT+BOTTOM], touchup=-1);
        down(explodez) fwd(barx) right(barx) zrot(90) xrot(-90) color("pink")   hook_joiner_pair(w+2*it+4*t-2*barx, femalez=6, xx=[]);
        up(6)          fwd(barx) right(barx) zrot(90) xrot(-90) color("purple") hook_joiner_pair(w+2*it+4*t-2*barx, malez=e, explodex=explodex, rounding_edges=[LEFT+FRONT]);
        
        right(t+it)            fwd(t+it+barx) up(6) xrot(-90) color("blue")  hook_joiner_pair(d-barx+t, malez=6, femalez=10, xx=[0.2, 0.8], rounding_edges=[RIGHT+FRONT+BOTTOM], rounding_edges_male=[RIGHT+BOTTOM], touchup=1, extra_slop_female=0.3);
        right(t+it+t+w+t-barx) fwd(t+it+barx) up(6) xrot(-90) color("blue")  hook_joiner_pair(d-barx+t, malez=6, femalez=10, xx=[0.2, 0.8], rounding_edges=[LEFT+FRONT+BOTTOM], rounding_edges_male=[LEFT+BOTTOM], touchup=-1, extra_slop_female=0.3);
        right(t+it) fwd(t+it+barx) zrot(90)   up(6) xrot(-90) color("green") hook_joiner_pair(w+2*t,  malez=6, xx=[0.25, 0.75], explodex=explodez, rounding_edges=[LEFT+FRONT], extra_slop_female=0.2);

        up(explodez) {
            difference() {
                union() {
                    // outer ice pack sparse walls "H3"
                    up(h3) up(t) {
                        left(explodex) intersection() {
                            fwd(t) sparse_wall(h=h3, l=it+d+t, thick=t, strut=3, max_bridge=30, anchor=LEFT+TOP+BACK);
                            up(7+6-t) fwd(3+7) cuboid([t, 2*t+d+it-3-7, h3], anchor=LEFT+TOP+BACK);
                        }
                        right(explodex) right(2*it+4*t+w-t) intersection() {
                            fwd(t) sparse_wall(h=h3, l=it+d+t, thick=t, strut=3, max_bridge=30, anchor=LEFT+TOP+BACK);
                            up(7+6-t) fwd(3+7) cuboid([t, 2*t+d+it-3-7, h3], anchor=LEFT+TOP+BACK);
                        }
                        back(explodex) intersection() {
                            fwd(t) zrot(90) sparse_wall(h=h3, l=2*it+4*t+w,    thick=t, strut=3, max_bridge=30, anchor=LEFT+TOP+BACK);
                            union() {
                                right(barx) cuboid([w+2*it+4*t-2*barx, t, h3-6+t-7], anchor=LEFT+TOP+BACK);
                                color("red") cuboid([w+2*it+4*t, 3, 2], anchor=LEFT+TOP+BACK); // correction for gap caused by gap caused by rounding at top
                            }
                        }
                    }
                    
                    // Joiners to attach ice pack side walls to ice pack back wall
                    up(t) up(h3) back(explodex) fwd(3) {
                                               color("lightblue") hook_joiner_pair(h3-6+t-7, explodez=explodex, explodex=-explodex, rounding_edges=[RIGHT+FRONT+TOP], rounding_edges_male=[RIGHT+TOP], touchup=3);
                        right(w+2*it+4*t-barx) color("lightblue") hook_joiner_pair(h3-6+t-7, femalez=10, xx=[0.25, 0.85], explodez=explodex, explodex=explodex, rounding_edges=[LEFT+FRONT+TOP], rounding_edges_male=[LEFT+TOP], touchup=-3);
                    }
                }
            }

            // inner "H1" sparse walls
            right(t+it)                fwd(t+it+barx)          up(h1+t) intersection() {
                sparse_wall(h=h1, l=d-barx+t, thick=t, strut=3, max_bridge=30, anchor=LEFT+TOP+BACK);
                down(barx) cuboid([t, d-barx+t, h1-barx-(7+6-t)], anchor=LEFT+TOP+BACK);
            }
            right(t+it+w+t)            fwd(t+it+barx)          up(h1+t)  intersection() {
                sparse_wall(h=h1, l=d-barx+t, thick=t, strut=3, max_bridge=30, anchor=LEFT+TOP+BACK);
                down(barx) cuboid([t, d-barx+t, h1-barx-(7+6-t)], anchor=LEFT+TOP+BACK);
            }
            back(explodez) right(t+it) fwd(2*t+it)    up(h1+t)  intersection() {
                zrot(90) sparse_wall(h=h1, l=w+2*t,    thick=t, strut=3, max_bridge=30, anchor=LEFT+TOP+BACK);
                fwd(-t) down(barx) right(barx) cuboid([2*t+w-2*barx, t, h1-barx-(7+6-t)], anchor=LEFT+TOP+BACK);
            }
            
            // Joiners to attach side "H1" walls to back "H1" wall (lightgreen), and the back "H1" wall to the back "H2" wall (darkgreen)
            back(explodez) up(t) right(t+it) fwd(t+it+3) up(h1) {
                                                color("lightgreen") hook_joiner_pair(h1-(6+7-t), rounding_edges=[RIGHT+FRONT], extra_slop_female=0.3);
                right(w+2*t-barx)               color("lightgreen") hook_joiner_pair(h1-(6+7-t), rounding_edges=[LEFT+FRONT], extra_slop_female=0.3);
                down(barx) right(barx) yrot(-90) color("darkgreen") hook_joiner_pair(2*t+w-2*barx, xx=[0.25, 0.75], explodez=explodez2, explodex=explodex, rounding_edges=[LEFT+FRONT], extra_slop_male=0.1);
            }
            
            // Joiners to attach side "H1" walls to side "H2" walls
            color("aqua") up(h1+t) {
                right(t+it)         fwd(t+it+barx) right(3)   yrot(90)  xrot(-90) hook_joiner_pair(d-barx+t, xx=[0.2, 0.8], explodez=-explodez, explodex=-explodex, rounding_edges=[RIGHT+FRONT+BOTTOM], touchup=2, wimpy_male=true);
                right(t+it-3+t+w+t) fwd(t+it+barx) down(barx) yrot(-90) xrot(-90) hook_joiner_pair(d-barx+t, xx=[0.2, 0.8], explodez=-explodez, explodex=explodex, rounding_edges=[LEFT+FRONT+BOTTOM], touchup=-2, wimpy_male=true);
            }

            // "H2" sparse walls
            up(h1) {
                up(explodex) right(-explodez) right(t+it)                fwd(t+it+barx)          up(t) {
                    up(h2) intersection() {
                        sparse_wall(h=h2, l=d-barx+t, thick=t, strut=3, max_bridge=30, anchor=LEFT+TOP+BACK);
                        down(7) cuboid([t, d-barx+t, h2-7], anchor=LEFT+TOP+BACK);
                    }
                    up(3.5) cuboid([3+7, d-barx+t, 3.5], anchor=LEFT+TOP+BACK, rounding=2, edges=RIGHT+FRONT+TOP, $fn=fn);
                }
                up(explodex) left (-explodez) right(t+it+w+t)            fwd(t+it+barx)          up(t) {
                    up(h2) intersection() {
                        sparse_wall(h=h2, l=d-barx+t, thick=t, strut=3, max_bridge=30, anchor=LEFT+TOP+BACK);
                        down(7) cuboid([t, d-barx+t, h2-7], anchor=LEFT+TOP+BACK);
                    }
                    up(3.5) left(3+7-t) cuboid([3+7, d-barx+t, 3.5], anchor=LEFT+TOP+BACK, rounding=2, edges=LEFT+FRONT+TOP, $fn=fn);
                }
                fwd(explodez2) up(explodex) back(explodez) right(t+it) fwd(2*t+it)    up(t) {
                    up(h2)  intersection() {
                        zrot(90) sparse_wall(h=h2, l=w+2*t,    thick=t, strut=3, max_bridge=30, anchor=LEFT+TOP+BACK);
                        fwd(-t) down(7) right(barx) cuboid([w+2*t-2*barx, t, h2-7], anchor=LEFT+TOP+BACK);
                    }
                    up(3.5) right(barx) back(t) cuboid([2*t+w-2*barx, 3+7, 3.5], anchor=LEFT+TOP+BACK, rounding=2, edges=FRONT+TOP, $fn=fn);
                }

                fwd(explodez2) up(explodex) back(explodez) up(t) right(t+it) fwd(t+it+3) up(h2) {
                                                    color("lightgreen") hook_joiner_pair(h2, explodex=-explodez, explodez=explodez-explodez2, rounding_edges=[RIGHT+FRONT]);
                    right(w+2*t-barx)               color("lightgreen") hook_joiner_pair(h2, explodex=explodez, explodez=explodez-explodez2, rounding_edges=[LEFT+FRONT]);
                }
                
                color("magenta") up(h2+t) up(explodex) up(explodez) {
                    right(explodez) right(t+it)            fwd(d-barx+t + 3+7+t+it) left(explodez)  xrot(90) hook_joiner_pair(d-barx+t, xx=[0.2, 0.8], explodex=-explodez, rounding_edges=[RIGHT+TOP+FRONT], rounding_edges_male=[RIGHT+TOP], touchup=3, wimpy_male=true);
                    left(explodez) right(t+it+2*t+w-barx) fwd(d-barx+t + 3+7+t+it) right(explodez) xrot(90) hook_joiner_pair(d-barx+t, xx=[0.2, 0.8], explodex=explodez, rounding_edges=[LEFT+TOP+FRONT], rounding_edges_male=[LEFT+TOP], touchup=-3, wimpy_male=true);
                    back(explodez2) fwd(explodez) fwd(explodez2) fwd(3+7+t+it)  right(w+2*t-2*barx + t+it+barx) back(explodez) zrot(90) xrot(90) hook_joiner_pair(w+2*t-2*barx, xx=[0.2, 0.8], explodex=explodez-explodez2, rounding_edges=[LEFT+FRONT], wimpy_male=true);
                }
            }
        }
    }

    // Special case of subtractive female hook joiners on the right outer ice wall
    right(explodex) up(explodez) up(t) up(h3) fwd(3) fwd(5) right(2*it+4*t+w) color("pink") {
        down(8) 
        yrot(-90) zrot(90) yrot(180) hook_joiner_female(5, 7, 6, 0.4, 2, 0.2, 0.2);
        
        down(55) 
        yrot(-90) zrot(90) yrot(180) hook_joiner_female(5, 7, 6, 0.4, 2, 0.2, 0.2);

        fwd(95) 
        up(6+10/2) down(h3+t) yrot(-90) yrot(180) hook_joiner_female(5, 7, 6, 0.4, 2, 0.2, 0.2);

        fwd(12)
        up(6+10/2) down(h3+t) yrot(-90) yrot(180) hook_joiner_female(5, 7, 6, 0.4, 2, 0.2, 0.2);
    }
    
    // Special case of subtractive female hook joiners on the bottoms of the H1 walls to support future attachments in front
    color("lightgreen")
    up(explodez + barx/2) fwd(d-barx+t)
    right(t+it) fwd(t+it+barx) up(6) {
        yrot(-90) {
            back(7) hook_joiner_female(5, 7, 6, 0.4, 2, 0.2, 0.2);
            back(57) hook_joiner_female(5, 7, 6, 0.4, 2, 0.2, 0.2);
        }

        right(t+w+t-barx) right(barx) yrot(90) {
            back(7) hook_joiner_female(5, 7, 6, 0.4, 2, 0.2, 0.2);
            back(57) hook_joiner_female(5, 7, 6, 0.4, 2, 0.2, 0.2);
        }
    }
    
    // Special case chop off the extremeties of the base arms
    down(explodez) fwd(2*t+it+d - 55+e) up(e) left(e) cuboid([w+2*it+4*t+2*e, 55, 3+2*e], anchor=LEFT+TOP+BACK);
    
    // special case of a last-minute tweak to prevent a collision that I didn't properly account for (on the right ice pack outer wall)
    color("#ffd0d0") up(explodez) right(explodex) up(6) up(10) right(4*t+2*it+w) cuboid([barx, 3, 3], anchor=RIGHT+TOP+BACK);
}


// Bottom angled base
down(explodez) {
    xrot(30) diff() cuboid([w+2*it+4*t+2*e, 179, 2.5], anchor=LEFT+TOP)
        tag("remove") cuboid([w+2*it-10, 159, 3]);
    fwd(75) cuboid([10, 3, 45], anchor=LEFT+TOP);
    right(w+2*it+4*t-10) fwd(75) cuboid([10, 3, 45], anchor=LEFT+TOP);
    
    back(1) cuboid([10, 3, 50], anchor=LEFT+BOTTOM+FRONT);
    back(1) right(w+2*it+4*t-10) cuboid([10, 3, 50], anchor=LEFT+BOTTOM+FRONT);
}


// Upper attachment
up(2*explodez+explodex) fwd(t+it) right(t+it) up(h1+h2+t+3) {
    color("#ff80ff") cuboid([barx, 3+7, 3], anchor=BACK+LEFT+TOP);
    color("#ff80ff") right(w+2*t) cuboid([barx, 3+7, 3], anchor=BACK+RIGHT+TOP);
    difference() {
        diff() cuboid([w+2*t, d+t, 3], rounding=2, edges=TOP, $fn=fn, anchor=BACK+LEFT+BOTTOM)
            fwd(10) color("red") tag("remove") cuboid([20, d, 4], rounding=5, edges="Z");
        up(e) right(e) fwd(e) fwd(d+t-5) right((w+2*t)/2-15) color("red") diff() cuboid([10, 10, 10]) position(BACK+LEFT) tag("remove") cyl(r=10, h=15, $fn=fn);
        up(e) left(e) fwd(e)  fwd(d+t-5) right((w+2*t)/2+15) color("red") diff() cuboid([10, 10, 10]) position(BACK+RIGHT) tag("remove") cyl(r=10, h=15, $fn=fn);
     }
}

// Interface to front attachments - must match coordinates of the special case female differences above, except the yrots are the opposite for male

fwd(explodefront)
color("red") {
    fwd(30) up(explodez) fwd(d-barx+t) right(t+it) fwd(t+it+barx) up(t) {
                     cuboid([3, 70+30, 10+6-t], anchor=RIGHT+FRONT+BOTTOM, rounding=2, $fn=fn, edges=[BACK+LEFT+TOP]);
        right(t+w+t) cuboid([3, 70+30, 10+6-t], anchor=LEFT+FRONT+BOTTOM, rounding=2, $fn=fn, edges=[BACK+RIGHT+TOP]);
        left(3) cuboid([t+w+t+2*3, 5, 20], anchor=LEFT+BACK+BOTTOM, rounding=2, $fn=fn, edges=[TOP, LEFT+FRONT, RIGHT+FRONT]);
    }
    
    up(explodez + barx/2) fwd(d-barx+t) right(t+it) fwd(t+it+barx) up(6) {
        yrot(90) 
        {
            back(7) hook_joiner_male(5, 7, 6, 0.4, 2, wimpy=false);
            back(57) hook_joiner_male(5, 7, 6, 0.4, 2, wimpy=false);
        }
        
        right(t+w+t-barx) right(barx) yrot(-90) 
        {
            back(7) hook_joiner_male(5, 7, 6, 0.4, 2, wimpy=false);
            back(57) hook_joiner_male(5, 7, 6, 0.4, 2, wimpy=false);
        }
    }
}

/*
right(10) {
    right(explodex) up(explodez) right(2*it+4*t+w) {
        // Right interface to pump holder - must match coordinates of the special case female differences above
        up(t) up(h3) fwd(3) fwd(5) color("red") {
            down(8) 
            yrot(-90) zrot(90) hook_joiner_male(5, 7, 6, 0.4, 2, wimpy=true);
            
            down(55) 
            yrot(-90) zrot(90) hook_joiner_male(5, 7, 6, 0.4, 2, wimpy=true);
            
            fwd(95) 
            up(6+10/2) down(h3+t) yrot(-90) hook_joiner_male(5, 7, 6, 0.4, 2, wimpy=true);

            fwd(12)
            up(6+10/2) down(h3+t) yrot(-90) hook_joiner_male(5, 7, 6, 0.4, 2, wimpy=true);
        }
        
        up(6) fwd(3) {
            up(10) cuboid([3, 10, h3+t-6-10], anchor=BACK+BOTTOM+LEFT);
            cuboid([3, it+d+2*t, 10], anchor=BACK+BOTTOM+LEFT); // You can use up to it+d+2*t as the y value but I think it looks better to have less
            up(10) fwd(it+d+2*t-20) prismoid(size1=[3, 20], size2=[3, 20], shift=[0, it+d+2*t-20], h=h3+t-6-10, anchor=LEFT+BOTTOM+BACK); 
        }
        
        difference() {
            union() {
                path1 = [[0, 0], [0, 10], [50, 43], [100, 0]];
                interface_rect = fwd(100, up(70, right(40, p=path3d(rect([20, 30])))));

                skin([up(6, fwd(it+d+2*t + 3, right(t+1, yrot(90, zrot(90,p=path3d(path1)))))), interface_rect],slices=10);
                up(6) fwd(it+d+2*t + 3 - 100) prismoid(size1=[20, 100], size2=[0, 50], shift=[10, -15], h=25, anchor=BOTTOM+BACK+LEFT);
                
                color("yellow")
                skin([up(1, interface_rect), fwd(100, up(100, right(50, yrot(-30, xrot(20, yrot(-90, xflip(p=path3d(rect([15, 50], anchor=LEFT)))))))))], slices=10);
            }
            fwd(100) right(40) cyl(r=5, h=100, anchor=BOTTOM);
        }
        
        fwd(200) right(40) cyl(r=5-0.2, h=50, anchor=BOTTOM) attach(TOP) cyl(r=10, h=3, anchor=BOTTOM);

        // pump holder
        fwd(100) up(100) right(50) 
        yrot(-30) xrot(20) back((2*t+pl)/2) {
            //t = 2;
            pl = 146;
            pw = 38;
            ph = 49;

            pd20 = 20;
            pd30 = 20;
            pd4 = 4;
            pd10 = 10;
            pd60 = 75;
            pd8 = 8;
            
            fwd(pd8) yrot(90) sparse_wall(h=2*t+pw, l=2*t+pl-pd8, thick=t, strut=3, max_bridge=30, anchor=RIGHT+BACK+BOTTOM);
            fwd(pd8) right(2*t+pw) sparse_wall(h=t+ph, l=2*t+pl-pd8, thick=t, strut=3, max_bridge=30, anchor=RIGHT+BACK+BOTTOM);
            color("red") cuboid([pd20+t, pd8, t], anchor=LEFT+BACK+BOTTOM);
            
            fwd(2*t+pl) right(2*t+pw) zrot(-90) sparse_wall(h=t+ph, l=2*t+pw, thick=t, strut=3, max_bridge=30, anchor=RIGHT+BACK+BOTTOM);
            
            fwd(t) right(t+pd20) zrot(-90) sparse_wall(h=t+ph, l=t+pd20, thick=t, strut=3, max_bridge=30, anchor=RIGHT+BACK+BOTTOM);
            sparse_wall(h=t+ph, l=pd30, thick=t, strut=3, max_bridge=30, anchor=LEFT+BACK+BOTTOM);
            color("red") up(t+ph-pd4) fwd(pd30) diff() cuboid([t, t+pl-pd30, pd4], anchor=LEFT+BOTTOM+BACK) {
                position(TOP) tag("remove") up(e) back(18) cuboid([t+1, 26, 3], anchor=TOP+FRONT);
                position(TOP) tag("removex") up(e) down(3) back(14) cuboid([t, 34, 3], anchor=TOP+FRONT);
            }
            fwd(pd60) color("pink") cuboid([t, pd10, t+ph], anchor=LEFT+BOTTOM+BACK);
            
            pd40 = 30;
            pd9 = 10;
            
            fwd(pd8) up(t) cuboid([2*t+pw, 2*t+pl-pd8, t], anchor=BACK+TOP+LEFT);
            fwd(pd8) color("blue") prismoid(size1=[15, 50], size2=[2*t+pw, 2*t+pl-pd8], shift=[(2*t+pw-15)/2, 0], h=15, anchor=BACK+TOP+LEFT);
        }
    }
}
*/




