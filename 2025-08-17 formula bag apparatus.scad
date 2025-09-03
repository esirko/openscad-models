include <BOSL2/std.scad>

e = 0.02;
e2 = 0.04;
fn = 36;

// Ring dimensions
r1 = 19; // inner bottom
r2 = 21; // inner top
h1 = 8;  // height of ring
t = 5;   // thickness of ring

dy = 70; // distance from center to arm, in y-direction
z1 = 130; // distance from lower plane of ring to lower part of diagonal arm, in z-direction

module connectors(slop=0.0) {
    left(9) back(5) prismoid(size1=[10+slop, 5+slop], size2=[12+slop, 8+slop], shift=[1,-1.5], h=15, anchor=TOP);
    right(9) back(5) prismoid(size1=[10+slop, 5+slop], size2=[12+slop, 8+slop], shift=[-1,-1.5], h=15, anchor=TOP);
    left(0) fwd(5) prismoid(size1=[10+slop, 5+slop], size2=[15+slop, 8+slop], shift=[0,1.5], h=15, anchor=TOP);
}

// ring
difference() {
    union() {
        diff() cyl(r1=r1+t, r2=r2+t, h=h1, anchor=BOTTOM, $fn=fn) {
            attach(CENTER) tag("remove") cyl(r1=r1, r2=r2, h=h1+1, $fn=fn);
            attach(TOP) tag("remove") zrot(-150) up(e) pie_slice(r=50, h=h1+1, ang=120, anchor=TOP);
            // red filler wedge dimensions by lots of trial+error!
            attach(TOP) color("red") back(30) down(20+e) prismoid(size1=[27.25, 5], size2=[25, 10], shift=[0,-10], h=20);
        }
    }
}

// To make skin map correctly, need to draw a rectangle at a 45-degree angle.
// To map even more correctly, we should subdivide the rectangle ... but it's not worth the effort.
skin([rot(0, p=ring(r1=r1, r2=r1+t, angle=[45, 90+45], n=fn)),
    back(33, p=[[-14, -2.5], [-14, 2.5], [14, 2.5], [14, -2.5]])], z=[0,-20], slices=10);

// main diagonal arm from midpoint to ring
back(dy) down(z1) prismoid(size1=[40, 10], size2=[25, 5], shift=[0,-46], h=z1+h1);

// hefty part
down(z1) back(dy-10) prismoid(size1=[40, 30], size2=[36.5, 8], shift=[0, 0], h=30);

// connectors
down(z1) back(dy-10) {
    connectors();
}

fwd(50) 
//down(z1) back(dy-10) 
{
    // Thick connector part
    difference() {
        prismoid(size1=[50, 10], size2=[40, 30], shift=[0, 0], h=30, anchor=TOP);
        up(e) connectors(slop=0.05);
    }
    // Back legs
    down(30) 
    diff() prismoid(size1=[150, 10], size2=[50, 10], shift=[0, 0], h=110, anchor=TOP)
        position(BOTTOM) tag("remove") up(10) {
            // two prismoids stacked so that the walls aren't entirely thick, yet the print still converges at a point at the top
            prismoid(size1=[120, 10+e2], size2=[56, 10+e2], shift=[0, 0], h=70, anchor=BOTTOM)
                position(BOTTOM) up(70) prismoid(size1=[56, 10+e2], size2=[0, 10+e2], h=30, anchor=BOTTOM);
        }
        
    // bottom plate
    back(5) down(140) diff() cuboid([150, 150, 4], anchor=BACK+TOP)
            position(CENTER) fwd(3) tag("remove") cuboid([130, 114, 12]);
        
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
}





