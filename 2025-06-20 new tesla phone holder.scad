include <BOSL2/std.scad>

pw = 79; // width of iphone+spigen case
pd = 13; // thickness(depth) of iphone+spigen case
ph = 90; // height of phone, but doesn't have to be exact
pt = 5;
lip = 5;

e = 0.1;

cuboid([5, 4, 20], anchor=LEFT+BOTTOM+FRONT);
left(50) cuboid([5, 4, 20], anchor=LEFT+BOTTOM+FRONT);
color("red") up(20-3) cuboid([50, 3, 3], anchor=RIGHT+BOTTOM+FRONT);
color("blue") up(20-3) left(25) cuboid([5, 40, 3], anchor=LEFT+BOTTOM+BACK);
color("green") fwd(40) left(25) cuboid([5, 3, 20], anchor=LEFT+BOTTOM+BACK);

up(20-3) left(25) xrot(30) cuboid([5, 3, 100], anchor=LEFT+BOTTOM+FRONT);

/*
fwd(55) up(70) left(100) 
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
    }
    fwd(0.5*(pd+pt))
    color("red") down(0.5*(ph-lip)+2.5) cuboid([40, pt+2*e, lip+5+2*e], chamfer=-1);
    fwd(1) color("red") down(0.5*(ph)+2.5) cuboid([20, pd+2*e, 5+2*e], chamfer=-1);
    fwd(1) color("red") up(11) fwd(2.5) right(0.5*(pw+pt)) yrot(90) cuboid([30, pd+pt+2*e, pt+2*e], chamfer=-1);
}
*/