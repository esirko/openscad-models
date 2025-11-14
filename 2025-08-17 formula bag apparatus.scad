include <BOSL2/std.scad>

e = 0.02;
e2 = 0.04;
fn = 180;

basex = 150;
basey = 150;


// Ring dimensions
r1 = 19; // inner bottom
r2 = 21; // inner top
h1 = 8;  // height of ring
t = 25;   // thickness of ring

dy = basey/2-5; // distance from center to arm, in y-direction
z1 = 130; // in upper part, distance from lower plane of ring to joint, in z-direction
z2 = 140; // in lower part, distance from joint to top plane of base



module connectors(slop=0.0) {
    /*
    left(9) back(5) prismoid(size1=[10+slop, 5+slop], size2=[12+slop, 8+slop], shift=[1,-1.5], h=15, anchor=TOP);
    right(9) back(5) prismoid(size1=[10+slop, 5+slop], size2=[12+slop, 8+slop], shift=[-1,-1.5], h=15, anchor=TOP);
    left(0) fwd(5) prismoid(size1=[10+slop, 5+slop], size2=[15+slop, 8+slop], shift=[0,1.5], h=15, anchor=TOP);
    */
    left(7) prismoid(size1=[9+slop, 5+slop], size2=[11+slop, 8+slop], shift=[1,-1.5], h=15, anchor=TOP);
    right(7) prismoid(size1=[9+slop, 5+slop], size2=[11+slop, 8+slop], shift=[-1,1.5], h=15, anchor=TOP);

}

module connector_group(male=true) {
    if (male) {
        //prismoid(size1=[40, 30], size2=[40, 8], shift=[0, 0], h=30);
        //cuboid([35, 15, 10], anchor=BOTTOM);
        prismoid(size1=[35, 15], size2=[35, 10], h=10, anchor=BOTTOM);
        connectors();
    } else {
        difference() {
            //prismoid(size1=[50, 10], size2=[40, 30], shift=[0, 0], h=30, anchor=TOP);
            cuboid([35, 15, 20], anchor=TOP);
            up(e) connectors(slop=0.05);
        }
    }
}

module diagonal_arm_from_midpoint_to_ring(zrot) {
    zrot(zrot) back(dy) down(z1) {
        color("red") up(10) prismoid(size1=[35, 10], size2=[20, 3], shift=[0,t+r1-dy+-1], h=z1+h1-10);
        connector_group(true);
    }
    zrot(zrot) back(49.5) down(35) prismoid(size1=[0, 0], size2=[20.875, 10], shift=[0, -11], h=35);
}


// ring
pie_angle = 105;
difference() {
    union() {
        diff() cyl(r1=r1+t, r2=r2+t, h=h1, anchor=BOTTOM, $fn=fn) {
            attach(CENTER) tag("remove") cyl(r1=r1, r2=r2, h=h1+1, $fn=fn);
            attach(TOP) tag("remove") zrot(-90-pie_angle/2) up(e) pie_slice(r=50, h=h1+1, ang=pie_angle, anchor=TOP);
            attach(CENTER) tag("remove") prismoid(size1=[2*r1-6, h1+1], size2=[2*r1+4, h1+1], h=r1, anchor=BOTTOM, orient=FRONT);
        }
    }
}

// To make skin map correctly, need to draw a rectangle at a 45-degree angle.
// To map even more correctly, we should subdivide the rectangle ... but it's not worth the effort.
//skin([rot(0, p=ring(r1=r1, r2=r1+t, angle=[45, 90+45], n=fn)),
//    back(33, p=[[-14, -2.5], [-14, 2.5], [14, 2.5], [14, -2.5]])], z=[0,-20], slices=10);


// main diagonal arm from midpoint to ring
diagonal_arm_from_midpoint_to_ring(0);
diagonal_arm_from_midpoint_to_ring(90);
diagonal_arm_from_midpoint_to_ring(-90);



fwd(50) 
//down(z1) back(dy)
{
    connector_group(false);
    fwd(dy) zrot(90) back(dy) connector_group(false);
    fwd(dy) zrot(-90) back(dy) connector_group(false);
    
    basedx = 10;
    down(z2) {
        // bottom plate
        back(5) diff() cuboid([basex, basey, 4], anchor=BACK+TOP)
            position(CENTER) tag("remove") cuboid([basex-2*basedx, basey-2*basedx, 12]);
       
        // vertical legs
        prismoid(size1=[35, 10], size2=[35, 15], h=z2-20);
        fwd(dy) zrot(90) back(dy) prismoid(size1=[35, 10], size2=[35, 15], h=z2-20);
        fwd(dy) zrot(-90) back(dy) prismoid(size1=[35, 10], size2=[35, 15], h=z2-20);
        
        /*
        // mid-brace plane
        up(z2) back(7.5) diff() cuboid([basex+5, basey, 4], anchor=BACK+TOP) {
            position(CENTER) tag("remove") fwd(5) cuboid([basex-2*basedx-5, basey-2*basedx, 12]);
            tag("remove") fwd(basey/2) cuboid([basex+6, basey+1, 12]);
        }
        */
        
        // cross bars
        difference() {
            union() {
                back(7.5) left(3.5) up(z2-10) xrot(90) prismoid(size1=[14, 10], size2=[12, 10], shift=[-basex/2+15.5, -0.5*z2+10], h=basey/2-15, anchor=FRONT+BOTTOM+RIGHT);
                back(7.5) right(3.5) up(z2-10) xrot(90) prismoid(size1=[14, 10], size2=[12, 10], shift=[basex/2-15.5, -0.5*z2+10], h=basey/2-15, anchor=FRONT+BOTTOM+LEFT);
            }
            up(z2) cuboid([35, 15, 20], anchor=TOP);
        }

        fwd(basey-5) left(basex/2) prismoid(size1=[10, 12], size2=[12, 12], shift=[0, basey/2-15], h=z2/2-10, anchor=BOTTOM+FRONT+LEFT);
        fwd(basey-5) right(basex/2) prismoid(size1=[10, 12], size2=[12, 12], shift=[0, basey/2-15], h=z2/2-10, anchor=BOTTOM+FRONT+RIGHT);

    }

    /*
    // Back legs
    down(30) 
    diff() prismoid(size1=[150, 10], size2=[50, 10], shift=[0, 0], h=110, anchor=TOP)
        position(BOTTOM) tag("remove") up(10) {
            // two prismoids stacked so that the walls aren't entirely thick, yet the print still converges at a point at the top
            prismoid(size1=[120, 10+e2], size2=[56, 10+e2], shift=[0, 0], h=70, anchor=BOTTOM)
                position(BOTTOM) up(70) prismoid(size1=[56, 10+e2], size2=[0, 10+e2], h=30, anchor=BOTTOM);
        }
    */
        

        /*
    // diagonal struts
    down(140) difference() {
        color("red") union() {
            //fwd(70) left(70) prismoid(size1=[10, 20], size2=[10, 20], shift=[25, 80], h=50, anchor=BOTTOM);
            //fwd(70) right(70) prismoid(size1=[10, 20], size2=[10, 20], shift=[-25, 80], h=50, anchor=BOTTOM);
            fwd(95) left(70) prismoid(size1=[10, 20], size2=[10, 20], shift=[39, 110], h=85, anchor=BOTTOM);
            fwd(95) right(70) prismoid(size1=[10, 20], size2=[10, 20], shift=[-39, 110], h=85, anchor=BOTTOM);
        }
        back(5) cuboid([200, 20, 200], anchor=FRONT);
    }
        */
}





