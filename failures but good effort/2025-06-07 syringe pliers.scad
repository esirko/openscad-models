include <BOSL2/std.scad>
include <BOSL2/distributors.scad>

l = 80;
t = 15;
s = 8;
fn = 36;
rh = 3;
max_angle = 45;
w1 = 8;
w2 = 5;
w3 = 7;
$slop=0.4;

    gt = 5;
    gr = 15.5;
    

e = 0.1;
tm1 = 7;
handle_angle = asin(t/l);
hole4adjustment = l * (1 - cos(handle_angle)); // original calculation assumed the two handles would be exactly co-linear, but they aren't, they will be separated by a small amount given by t and handle_angle

module hole1() {
    yrot(90) cyl(h=100, r=rh, $fn=fn);
}

module hole2() {
    yrot(90) fwd(l/2) cyl(h=100, r=rh, $fn=fn);
}

module hole3() {
    yrot(90) fwd(l) cyl(h=100, r=rh, $fn=fn);
}

module hole4() {
    yrot(90) fwd(l - hole4adjustment) fwd(rh) cuboid([2*rh, 2*rh + l * (1-cos(max_angle)) - hole4adjustment, 100], rounding=rh, edges="Z", $fn=fn, anchor=FRONT);
}

/*
module grip1() {
    gt = 5;
    gr = 15.5;
    
    difference() {
        union() {
            cuboid([50, 35, gt], anchor=FRONT);
            up(gt/2) prismoid(size1=[50,35], size2=[50, 0], shift=[0,-17.5], height=20, anchor=FRONT+BOTTOM);
        }
        
        down(gt/2+e) back(gr + 5) cylinder(h = gt+20+2*e, r = gr);
        back(gr+5) cuboid([2*gr, 35, gt+15+2*e], anchor=FRONT);
    }
}
*/

zrot(-90) {


difference() {
    back(s)
    union() {
        left(0.5*w1+w2+0.5*w3) cuboid([w3, l + 2*s, t], anchor=BACK, $fn=fn);
        right(0.5*w1+w2+0.5*w3) cuboid([w3, l + 2*s, t], anchor=BACK, $fn=fn);
        up((t-tm1)/2) back(40) cuboid([w1 + 2*w2 + 2*w3, 40, tm1], anchor=BACK);
        fwd(l+2*s) cuboid([w1 + 2*w2 + 2*w3, 10, t], anchor=BACK);
        fwd(l+2*s+10) cuboid([w1, 70, t], anchor=BACK);
    }
    
    hole1();
    hole4();
}


up(40)
difference() {
    back(s)
    union() {
        cuboid([w1, l + 2*s, t], anchor=BACK, rounding=t/2, edges="X", $fn=fn);
        fwd(l+s) xrot(handle_angle) back(s) cuboid([w1, 80 + 2*s, t], anchor=BACK, rounding=t/2, edges="X", $fn=fn);
        xflip_copy() left(20) cuboid([w2, l + 2*s, t], anchor=BACK, rounding=t/2-1, edges="X");
        
    }
    
    hole1();
    hole2();
    hole3();
}



up(80)
difference() {
    back(s)
    union() {
        left(0.5*w1+w2+0.5*w3) cuboid([w3, l + 2*s, t], anchor=BACK, rounding=t/2-1, edges=[FRONT+TOP, FRONT+BOTTOM], $fn=fn);
        right(0.5*w1+w2+0.5*w3) cuboid([w3, l + 2*s, t], anchor=BACK, rounding=t/2-1, edges=[FRONT+TOP, FRONT+BOTTOM], $fn=fn);
        up(40/2+t/2) cuboid([50, 20, 40], anchor=BACK);
        
        up(t/2) prismoid(size1=[50, 60], size2=[50,20], shift=[0,20], height=130-t/2, anchor=BACK+BOTTOM, $fn=fn);
        
        difference() {
            cuboid([50, 35, 130], anchor=FRONT+BOTTOM);
            
            up(gt) back(35+e) prismoid(size1=[50, 0], size2=[50+2*e,35], shift=[0,-17.5], height=30, anchor=FRONT+BOTTOM);
            up(40+gt) back(35+e) prismoid(size1=[50, 0], size2=[50+2*e,35], shift=[0,-17.5], height=30, anchor=FRONT+BOTTOM);
            up(80+gt) back(35+e) prismoid(size1=[50, 0], size2=[50+2*e,35], shift=[0,-17.5], height=30, anchor=FRONT+BOTTOM);
            //up(90+gt) back(35+e) prismoid(size1=[50, 0], size2=[50+2*e,35], shift=[0,-17.5], height=20, anchor=FRONT+BOTTOM);
          
            up(40-e) back(e) cuboid([50+2*e,35,gt], anchor=FRONT+TOP);
            up(80-e) back(e) cuboid([50+2*e,35,gt], anchor=FRONT+TOP);
            up(120-e) back(e) cuboid([50+2*e,35,gt], anchor=FRONT+TOP);
            //up(120-e) back(e) cuboid([50+2*e,35,gt], anchor=FRONT+TOP);

            down(e) back(gr + 5) cylinder(h = 130+2*e, r = gr);
            back(gr+5) down(e) cuboid([2*gr, 35, 130+2*e], anchor=FRONT+BOTTOM);   
        }
    }
    
    hole1();
    hole4();
}


right(100) {
    ycopies(10, 4) {
        cyl(h=2*w3 + 2*w2 + w1 + 4+2, r=rh-$slop/2, $fn=fn, anchor=BOTTOM);
        cyl(h=2, r=rh+1, $fn=fn, anchor=BOTTOM);
        up(50) difference() {
            cyl(h=5, r=rh+1, $fn=fn, anchor=BOTTOM);
            down(e) cyl(h=3, r=rh-$slop/2, $fn=fn, anchor=BOTTOM);
        }
    }
    fwd(30) cyl(h=2*w2 + w1, r=rh-$slop/2, $fn=fn, anchor=BOTTOM);
}


}