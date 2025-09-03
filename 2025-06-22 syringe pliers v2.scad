include <BOSL2/std.scad>

e = 0.1;
slop = 0.2;
fn = 72;

//r0 = 25;
rc = 15;
zh = 8;

r1 = 30;
rc2 = rc;
rh0 = 3;

ht = 6;
hl = 40;




// syringe piston
gr = 15.5;
gw = 57;
gh = 45;
gt = 5;

gp = 18;
gs = 2;

theta = 90;

r0 = (gh/2) / sin(theta/2); // critical radius of the system
chordx = r0 - (r0 * cos(theta/2));
echo(chordx);

//back(120)
difference() {
    union() {
        up(110) zflip()
        difference() {
            union() {
                cuboid([gw,gh,gt], anchor=BOTTOM); // thin rectangular block
                zrot(90) xrot(-90) fwd(r0 - chordx) difference() { // chord
                    cyl(h=gw, r=r0, $fn=fn);
                    fwd(chordx/2) cuboid([2*r0+2*e, 2*r0-chordx, gw+2*e]);
                }
                fwd(2.5) right(gw/2) up(gt) cuboid([3, 4, 23.5], anchor=TOP+LEFT+BACK);
                back(2.5) right(gw/2) up(gt) cuboid([3, 4, 23.5], anchor=TOP+LEFT+FRONT);
                right(gw/2+3) cuboid([2, 13, 5], anchor=LEFT+BOTTOM);
                fwd(2.5) right(gw/2-4) down(23.5-gt-2) cuboid([4, 4, 2], anchor=TOP+LEFT+BACK);
                back(2.5) right(gw/2-4) down(23.5-gt-2) cuboid([4, 4, 2], anchor=TOP+LEFT+FRONT);
                fwd(2.5) left(gw/2) up(gt) cuboid([3, 4, 23.5], anchor=TOP+RIGHT+BACK);
                back(2.5) left(gw/2) up(gt) cuboid([3, 4, 23.5], anchor=TOP+RIGHT+FRONT);
                left(gw/2+3) cuboid([2, 13, 5], anchor=RIGHT+BOTTOM);
                fwd(2.5) left(gw/2-4) down(23.5-gt-2) cuboid([4, 4, 2], anchor=TOP+RIGHT+BACK);
                back(2.5) left(gw/2-4) down(23.5-gt-2) cuboid([4, 4, 2], anchor=TOP+RIGHT+FRONT);
            }
            down(chordx) union() {
                down(e) back(e) cuboid([2*gr,gh/2+e,gt+chordx+2*e], anchor=FRONT+BOTTOM);
                down(e) cylinder(h = gt+chordx+2*e, r = gr);
            }
        }
        
        
        difference() {
            union() {
                cuboid([gw, gh, gt], anchor=BOTTOM);
                zrot(90) xrot(-90) fwd(r0 - chordx) difference() { // chord
                    cyl(h=gw, r=r0, $fn=fn);
                    fwd(chordx/2) cuboid([2*r0+2*e, 2*r0-chordx, gw+2*e]);
                }
                //fwd(gh/2) cuboid([10, 2, 100], anchor=FRONT+BOTTOM);
                down(18.5) right(gw/2) cuboid([2, 4, 110], anchor=LEFT+BOTTOM);
                right(gw/2-4) down(23.5-gt-2) cuboid([4, 4, 2], anchor=LEFT+TOP);
                down(18.5) left(gw/2) cuboid([2, 4, 110], anchor=RIGHT+BOTTOM);
                left(gw/2-4) down(23.5-gt-2) cuboid([4, 4, 2], anchor=RIGHT+TOP);
            }
            up(gt-gs+e) cuboid([2*gp,gh/2+e,gs], anchor=FRONT+BOTTOM);
            up(gt-gs+e) cylinder(h=gs, r=gp);
        }
        
        
    }
}


// plier arms
rh1 = 12;
ds = 16; // size of reinforcing notch
// TODO: gw for the pliers should be less than gw for the pistons

left(100)
xcopies(50, 2) {
    ydisplacement = sqrt((r0+5)*(r0+5) - rc2*rc2) + 15; // hmmm may need to recalculate this. Hmm wait I think it will just be a configurable

    difference() {
        union() {
            right(rc2) back(ydisplacement) difference() {
                cyl(l=gw, r=r0+5, $fn=fn);
                cyl(l=gw+2*e, r=r0, $fn=fn);
                left(rc2) cuboid([r0+5+rc2+e, 2*(r0+5)+2*e, gw+2*e], anchor=LEFT);
                fwd(r0-8) cuboid([r0+5+e, 2*r0+5+e, 2*gp], anchor=RIGHT+FRONT);
            }
            cyl(l=gw, r=rh1, $fn=fn);
            fwd(hl/2) cuboid([ht, hl, gw], anchor=LEFT);
            //up(gw/2) cyl(h=gw/4, r=rh1, anchor=TOP);
            
            xrot(-90)
            union() {
                prismoid(size1=[0,gw],size2=[ds,gw],shift=[-ds/2,0], height=ds);
                zflip() prismoid(size1=[0,gw],size2=[ds,gw],shift=[ds/2,0], height=ds);
            }
            back(ds) left(2) cuboid([12,5.5,gw], anchor=RIGHT+FRONT);
            fwd(ds) right(4) cuboid([12,7,gw], anchor=LEFT+BACK);
        }
        
        down(gw/2+e) cyl(h=gw/4, r=8, anchor=BOTTOM);
        cyl(l=gw+4+2*e, r=rh0, $fn=fn);
        cyl(l=gw/2+e, r=rh1+e, $fn=fn, anchor=TOP);
        
    }
}




/*
// plier axle
cyl(h=gw+6, r=rh0-0.2, $fn=fn, anchor=BOTTOM);
cyl(h=2, r=rh0+1, $fn=fn, anchor=BOTTOM);
right(2*rh0+4) difference() {
    cyl(h=4, r=rh0+1, $fn=fn, anchor=BOTTOM);
    up(1+e) cyl(h=3, r=rh0-0.05, $fn=fn, anchor=BOTTOM);
}
*/

