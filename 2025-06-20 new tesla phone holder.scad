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
jw = 10; // joint width
jb = 6; // minimum joint base

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
xrot(-20)
union() {

// --- mount bar
union() {
    diff() prismoid([t1p + 2*tt, ttr], [t2p + 2*tt, ttr], th, orient=BACK, anchor=BACK+BOTTOM) {
        edge_profile(except=[BOTTOM+RIGHT, BOTTOM+LEFT], excess=5) mask2d_roundover(r=2, mask_angle=$edge_angle, $fn=fn);
    }
    mount_bar_side(10);
    xflip() mount_bar_side(10);
    
    left(t2p/2) back(th/2) up(ttr + jw/2) half_joiner2(l=jl, w=jw, base=jb+4, orient=LEFT);
    left(t2p/2-(jb+4)-jw/2) back(th/2) up(ttr + jb) half_joiner2(l=jl, w=jw, base=jb);
    left(jw/2) back(th/2) up(ttr + jb) half_joiner2(l=jl, w=jw, base=jb);
}
    

difference() {

union() {
// --- connector block: left-anchor to mount
back(2) left(20) left(t2p/2) back(th/2) up(ttr + jw/2) half_joiner(l=jl, w=jw, base=jb+4, orient=RIGHT);
up(3) left(120) color("#ffcccc") prismoid([20, jl+6], [20, jl+16], shift=[0,5], h=20, anchor=FRONT+BOTTOM+RIGHT, rounding=2, $fn=fn);


// --- left-anchor
union() {
right(5) fwd(3) up(4.5) xrot(-15)
up(100) back(80) left(197) xrot(60)
union() {
    cuboid([law, lay1, lat], anchor=RIGHT+BOTTOM+BACK, rounding=lar, except=BACK);
    up(0.4) right(72) fwd(lay1-2.5) xrot(20) cuboid([law+law2left+70.5, lay2, lat], anchor=RIGHT+BOTTOM+BACK, rounding=0*lar);
    fwd(lay1-lay3) left(law-laft/2) cuboid([law2left, lay3, lat], anchor=RIGHT+BOTTOM+BACK, rounding=lar);

    color("#ff8080") fwd(lay1+25) up(lat-6) left(law-laft/2) xrot(-90) 
    diff() 
        prismoid(size1=[jl,12], size2=[jl,0], shift=[0,-6], height=30)
            position(BOTTOM+FRONT)
                tag("remove") xrot(10) up(5) cyl(r=3, h=100, orient=BACK);



    // teeth
    up(lat/2) cuboid([latoothx, latoothy, latoothz-10], anchor=TOP+RIGHT+BACK);
    up(lat/2) left(5*latoothdx) cuboid([latoothx, latoothy, latoothz-10], anchor=TOP+RIGHT+BACK);
    
    down(latoothz-5) up(lat/2) fwd(latoothy/4) left(latoothx/2) prismoid([latoothx, latoothy/2], [latoothx, latoothy], shift=[0, -latoothy/4], h=5);
    down(latoothz-5) up(lat/2) fwd(latoothy/4) left(latoothx/2) left(5*latoothdx) prismoid([latoothx, latoothy/2], [latoothx, latoothy], shift=[0, -latoothy/4], h=5);
   
    up(lat/2) left(7*latoothdx) cuboid([latoothx, latoothy, latoothz], anchor=TOP+RIGHT+BACK);

    // extender to the up part
    color("#cc00ff") left(36) union() {
        prismoid([20, lat], [20, lat], shift=[0, -5], height=15, anchor=RIGHT+BOTTOM+BACK, orient=BACK)
            attach(TOP)
            prismoid([20, lat], [20, 10], shift=[0, 2], height=40);
    }

    // connector to attach to phone holder: left-anchor side
    //left(law-3) fwd(20) zrot(90) up(15) half_joiner2(l=jl, w=jw, base=jb+6);
    
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



// --- union to move phone holder + aligned joiner the same
fwd(10) up(10)
right(3.5) fwd(3) up(4.5) xrot(-15)
union() {
    // connector to attach to phone holder: phone side
    up(100) back(80) left(197) xrot(60)
    left(law-3) fwd(20) zrot(90) up(15)
    union() {
        //zflip() half_joiner(l=jl, w=jw, base=jb+6);
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
    // TODO: this might be an easier print with less supports if the red/blue part were lifted a bit up
    color("red")
    up(20) left(250.5) fwd(8) xrot(-2) difference () {
        prismoid([jl, 76], [jl, 114], shift=[0, -11], 60);
        down(e) cuboid([jl+1, 120, 40], anchor=BOTTOM); // I do a difference instead of changing the geometry of the red bar simply because I spent a lot of time visually aligning the red bar and I don't want to mess it up.
    }


    // --- phone holder
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
            }
            
            fwd(0.5*(pd+pt))
            union() {
                down(0.5*(ph-lip)) cuboid([pw, pt, lip]);        
                left(0.5*(pw-lip)) down(0.5*(ph-40)) cuboid([lip, pt, 40], rounding=3, edges=BACK+TOP);
                right(0.5*(pw-lip)) down(0.5*(ph-40)) cuboid([lip, pt, 40], rounding=3, edges=BACK+TOP);
            }
            
            //down(10) back((pd+2*pt)/2) cuboid([30, 130, 30], anchor=FRONT);
        }
        fwd(0.5*(pd+pt))
        color("red") down(0.5*(ph-lip)+2.5) cuboid([40, pt+2*e, lip+5+2*e], chamfer=-1);
        fwd(1) color("red") down(0.5*(ph)+2.5) cuboid([20, pd+2*e, 5+2*e], chamfer=-1);
        fwd(1) color("red") up(11) fwd(2.5) right(0.5*(pw+pt)) yrot(90) cuboid([30, pd+pt+2*e, pt+2*e], chamfer=-1);
    }
    
    }
}
}

up(3) left(120-1) color("#ccffcc") cuboid([180, 40, 10], anchor=FRONT+TOP+RIGHT);
}

}



back(50)
xcopies(20, 2)
pin(r1=3, h1=24, r2=6, h2=2, slop=0.2, cutback_fudge=0.15);

back(70)
pin(r1=3, h1=20, r2=6, h2=2, slop=0.2, cutback_fudge=0.15);

