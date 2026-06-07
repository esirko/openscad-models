include <BOSL2/std.scad>
include <BOSL2/joiners.scad>

pw = 79; // width of iphone+spigen case
pd = 13; // thickness(depth) of iphone+spigen case
ph = 90; // height of phone, but doesn't have to be exact
pt = 5;
lip = 5;

fn = 36;
e = 0.1;

jl = 30; // joint length
jw = 10; // joint width - TODO: will be deprecated
jw2 = 18;
jb = 6; // minimum joint base - TODO: will be deprecated
jh = 8; // joint height - 

// mount bar
t1 = 170; // trapezoid length 1
t2 = 180; // trapezoid length 2
th = 35; // depth of mount bar
ttr = 3; // thickness of trapezoid part of mount bar
tt = 5; // thickness of tooth part of mount bar
ttc = 5; // thickness of clip part
tr = 2.5; // rounding on edges
tsc1 = 20; // skate clip length, right side
tsc2 = 20; // skate clip length, left side
tooth_inward_angle = 95;
tpartition_dx = 0;
tpartition_x = -40;


lay1 = 70;
lay2 = 40;
lat = 5; // maybe 5
laft = 3; // maybe 10
latoothx = 4.5;
latoothy = 3.5;
latoothz = 20;
latoothdx = 52./7.;
law = 7 * latoothdx + latoothx;
law2left = 47;
//law2right = 110; // maybe 110
lay3 = 46;
lar = 0.5;
law3 = 30;

barw = 90;
bary = 20;

r_ohsnap = 29;
h_ohsnap = 4;
y_ohsnap = 48;



// Derived
theta = atan2((t2-t1)/2, th);
t1p = t1 + tpartition_dx;
t2p = t2 + tpartition_dx;

module pin(r1=3, h1=20, r2=6, h2=2, slop=0.1, cutback_fudge=0.15) {
    // cutback_fudge should be adjusted so that the entire edge face of the screw is cut just slightly, so that it can print flat. It will depend on $fn (in theory, possible to calculate, but may not be worth it)
    difference() {
        union() {
            cyl(r=r1-slop, rounding1=1, height=h1, anchor=TOP);
            cyl(r=r2, height=h2, anchor=BOTTOM);
        }
        fwd(r1-slop-cutback_fudge) down(h1+e) cuboid([2*r2+2*e, r2-(r1-slop)+cutback_fudge, h2+h1+2*e], anchor=BOTTOM+BACK);
    }
}


module mount_bar_side(toothsize) {
    right(t1p/2)
    back(0.5) up(2)
    zrot(-theta)
    yrot(90 + tooth_inward_angle)
    
    union() {
        diff() prismoid([tt, th], [tt, tsc1], 50, anchor=FRONT+BOTTOM+RIGHT) {
            edge_profile(except=BOTTOM, excess=5) mask2d_roundover(r=2, mask_angle=$edge_angle, $fn=fn);
        }

        left(2) back((th-tsc1)/2) up(50) yrot(90) diff() prismoid([tt, tsc1], [tt, tsc1], toothsize, anchor=LEFT+FRONT+BOTTOM) {
            edge_profile(except=BOTTOM, excess=5) mask2d_roundover(r=2, mask_angle=$edge_angle, $fn=fn);
        }
    }
}


// everything
xrot(0)
union() {

// --- mount bar
    /*
difference() {
    union() {
        diff() prismoid([t1p + 2*tt, ttr], [t2p + 2*tt, ttr], th, orient=BACK, anchor=BACK+BOTTOM) {
            edge_profile(except=[BOTTOM+RIGHT, BOTTOM+LEFT], excess=5) mask2d_roundover(r=2, mask_angle=$edge_angle, $fn=fn);
        }
        mount_bar_side(10);
        xflip() mount_bar_side(10);

        color("red") //up(jw)
            up(jh) left(5) left(t2p/2) back(th/2) up(ttr + jh/2) diff() cuboid([jw2, jl, jh]) {
                position(BOTTOM)  {
                    tag("remove") yrot(10) xrot(10) cyl(r=3, h=100);
                    tag("cap") yrot(10) xrot(10) up(8) cyl(r=5, h=5);
                }
                position(RIGHT+TOP) cuboid([15, jl, 2*jh], anchor=LEFT+TOP);
                position(BACK+TOP+LEFT) cuboid([jw2+15, 10, 2*jh+ttr/2], anchor=FRONT+TOP+LEFT); // extension on the back to make it print flat without supports
            }
    }
    back(5) back(th+(th-tsc1)/2) down(50) prismoid([210, 2*(th-tsc1)+10], [210, 12], h=2*50); //large plane cutout to make it print flat without support
}
*/


// --- everything else besides the mount bar
union() {
    /*
    difference() {
        union() {
            // --- connector block: left-anchor to mount bar, left-anchor side
            color("pink") back(2) left(20) //up(jw) 
                down(e) left(5) left(t2p/2) back(th/2) up(ttr + jh/2) diff() cuboid([jw2, jl, jh]) {
                    position(LEFT) fwd(jl/2) down(jh/2) prismoid([15, jl+2], [15, jl+8], shift=[0,3], h=2*jh, anchor=RIGHT+BOTTOM+FRONT);
                    position(TOP) tag("remove") yrot(10) xrot(10) cyl(r=3, h=100);
                }

            //back(2) left(20) left(t2p/2) back(th/2) up(ttr + jw/2) half_joiner(l=jl, w=jw, base=jb+4, orient=RIGHT);
            //right(2) up(3) left(120) color("#ffcccc") prismoid([20, jl+6], [20, jl+16], shift=[0,5], h=20, anchor=FRONT+BOTTOM+RIGHT, rounding=2, $fn=fn);

            // --- left anchor main part that fits over the wooden dash
            right(5) fwd(3) up(4.5) xrot(-15)
            up(100) back(80) left(197) xrot(60)
            union() {
                cuboid([law, lay1, lat], anchor=RIGHT+BOTTOM+BACK, rounding=lar, except=BACK);
                up(0.4) right(68) fwd(lay1-2.5) xrot(20) cuboid([law+law2left+66.5, lay2, lat], anchor=RIGHT+BOTTOM+BACK, rounding=0*lar);
                fwd(lay1-lay3) left(law-laft/2) cuboid([law2left, lay3, lat], anchor=RIGHT+BOTTOM+BACK, rounding=lar);

                color("#ff8080") fwd(lay1+25) up(lat-6) left(law-laft/2) xrot(-90) 
                diff() 
                    prismoid(size1=[jl,12], size2=[jl,0], shift=[0,-6], height=30)
                        position(BOTTOM+FRONT)
                            tag("remove") xrot(10) up(5) cyl(r=3, h=100, orient=BACK);

                up(lat/2) cuboid([latoothx, latoothy, latoothz-10], anchor=TOP+RIGHT+BACK);
                up(lat/2) left(5*latoothdx) cuboid([latoothx, latoothy, latoothz-10], anchor=TOP+RIGHT+BACK);
                
                down(latoothz-5) up(lat/2) fwd(latoothy/4) left(latoothx/2) prismoid([latoothx, latoothy/2], [latoothx, latoothy], shift=[0, -latoothy/4], h=5);
                down(latoothz-5) up(lat/2) fwd(latoothy/4) left(latoothx/2) left(5*latoothdx) prismoid([latoothx, latoothy/2], [latoothx, latoothy], shift=[0, -latoothy/4], h=5);
               
                up(lat/2) left(7*latoothdx) cuboid([latoothx, latoothy, latoothz], anchor=TOP+RIGHT+BACK);

                // extender to the up part to keep it in place vertically
                color("#cc00ff") left(36) union() {
                    prismoid([20, lat], [20, lat], shift=[0, -5], height=15, anchor=RIGHT+BOTTOM+BACK, orient=BACK)
                        attach(TOP)
                        prismoid([20, lat], [20, 12], shift=[0, 1], height=40);
                }

                fwd(25) right(barw/2 - (law-laft/2)) up(lat) 
                difference() {
                    diff()
                        cuboid([barw, bary, 10], anchor=BOTTOM+RIGHT+BACK, rounding=lar, edges="Z") {
                            position(LEFT+TOP+BACK) fwd(10) right(10) tag("remove") yrot(-10) xrot(-10) cyl(r=3, h=100);
                            position(RIGHT+TOP+BACK) fwd(10) left(10) tag("remove") yrot(10) xrot(-10) cyl(r=3, h=100);
                        }
                    right((jl-barw)/2) back(e) up(e) cuboid([jl+e, 8+2*e, 10], anchor=BOTTOM+RIGHT+BACK);
                }
            }
        }
        // skim off the bottom of the whole left mount, to be able to print this flat
        up(3) left(105-1) color("#ccffcc") cuboid([195, 40, 10], anchor=FRONT+TOP+RIGHT);
    }
    */
    
    
    // --- phone holder complete assemblage, including base with 3 holes, extension bar, and the actual phone holding part
    fwd(10) up(10)
    right(3.5) fwd(3) up(4.5) xrot(-15)
    union() {
        // The assemblage that forms the base of the phone holder, with the three holes
        up(100) back(80) left(197) xrot(60)
        left(law-3) fwd(20) zrot(90) up(15)
        union() {
             difference () {
                color("blue") left(40) up(2) down(jb+6) prismoid([70, jl], [10, jl], shift=[30,0], (jb+6)*2-2);
                left(13) down(e) cuboid([bary-8, jl+e, 10], anchor=TOP+RIGHT);
                left(55) down(e) cuboid([20, jl+e, 10], anchor=TOP+RIGHT); // hack: leave room for the hole - this can all be cleaned up
            }
            color("#8080ff") up(10) left(5) 
                diff()
                    cuboid([bary, barw, 10], anchor=TOP+RIGHT, rounding=lar, edges=[TOP, "Z"]) {
                        position(RIGHT+BOTTOM+BACK)
                            left(10) fwd(10) {
                                tag("remove") yrot(10) xrot(-10) cyl(r=3, h=100);
                                tag("cap") yrot(10) xrot(-10) up(10) cyl(r=5, h=5);
                            } 
                        position(RIGHT+BOTTOM+FRONT)
                            left(10) back(10) {
                                tag("remove") yrot(10) xrot(10) cyl(r=3, h=100);
                                tag("cap") yrot(10) xrot(10) up(10) cyl(r=5, h=5);
                            }
                        }
            color("#8080ff") left(45) 
                diff() 
                    cuboid([30, jl, 10], anchor=TOP+RIGHT, rounding=lar, edges=[TOP,"Z"])
                        position(BOTTOM+LEFT) right(5) {
                            tag("remove") yrot(-10) cyl(r=3, h=100);
                            tag("cap") yrot(-10) up(10) cyl(r=5, h=5);
                        }                    
        }
        
        // --- extension bar from the "base" to actual phone holding part
        color("red")
        up(45) left(250.5) fwd(20) xrot(-5) difference () {
            prismoid([jl, 100], [jl, 120], shift=[0, 0], 25);
            fwd(77) up(50) yrot(6) zrot(-3) xrot(29.5) cuboid([150, 20, 150]); // These numbers on this line were all guess-and-check eyeball
        }
        
        // --- phone holder: just the phone holding part
        xrot(5)
        left(25)
        fwd(55) up(70) left(220) yrot(2) zrot(-5) xrot(20) left(5) fwd(15)
        difference() {
            union() {
                // Probably a smarter (and prettier) way to do this - the rounding page on BOSL2 has some good examples
                difference() {
                    cuboid([pw+2*pt, pd+2*pt, ph+2*pt],chamfer=3);
                    up(ph-2*pt) cuboid([100, 100, ph]);
                    fwd(pt/2) cuboid([pw, pd+pt+e, ph], rounding=5, edges="Y");
                    back((pd+pt+e)/2-pt/2-e) up(y_ohsnap - ph/2 + r_ohsnap) {
                        cyl(r=r_ohsnap, h=h_ohsnap, anchor=TOP, orient=FWD);
                        cuboid([2*r_ohsnap, h_ohsnap, 100], anchor=FRONT+BOTTOM);
                    }
                }
                
                fwd(0.5*(pd+pt))
                union() {
                    down(0.5*(ph-lip)) cuboid([pw, pt, lip]);        
                    left(0.5*(pw-lip)) down(0.5*(ph-40)) cuboid([lip, pt, 40], rounding=3, edges=BACK+TOP);
                    right(0.5*(pw-lip)) down(0.5*(ph-40)) cuboid([lip, pt, 40], rounding=3, edges=BACK+TOP);
                }
            }
            fwd(0.5*(pd+pt))
            color("red") down(0.5*(ph-lip)+2.5) cuboid([40, pt+2*e, lip+5+2*e], chamfer=-1);
            fwd(1) color("red") down(0.5*(ph)+2.5) cuboid([20, pd+2*e, 5+2*e], chamfer=-1);
            fwd(1) color("red") up(11) fwd(2.5) right(0.5*(pw+pt)) yrot(90) cuboid([30, pd+pt+2*e, pt+2*e], chamfer=-1);
        }
    }
}


} // --- everything block


back(50)
xcopies(20, 2)
pin(r1=3, h1=24, r2=6, h2=2, slop=0.2, cutback_fudge=0.15);

back(70)
pin(r1=3, h1=20, r2=6, h2=2, slop=0.2, cutback_fudge=0.15);

back(60) left(50) pin(r1=3, h1=20, r2=6, h2=2, slop=0.2, cutback_fudge=0.15);

