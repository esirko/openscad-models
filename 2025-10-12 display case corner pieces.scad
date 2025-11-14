include <BOSL2/std.scad>

forty = 38;
four = 6;
ten = 10;

t1 = 0.5; // size of the slot (where the notch opens)
t2 = 1.0;  // size of the slot (at the bottom of notch)

ee =0.01;
b = 1; // thickness of bottom plate thingy

l = forty + four;

difference() {
    left(four) down(four) back(four) cuboid([l, l, l], anchor=LEFT+BACK+BOTTOM);
    cuboid([l, l, l], anchor=LEFT+BACK+BOTTOM);
    left(ten) up(ten) fwd(ten) cuboid([l, l, l], anchor=LEFT+BACK+BOTTOM);
    right(ten) up(ten) back(ten) cuboid([l, l, l], anchor=LEFT+BACK+BOTTOM);
    right(ten) down(ten) fwd(ten) cuboid([l, l, l], anchor=LEFT+BACK+BOTTOM);
    
    back(four/2)                     prismoid(size1=[l, t2], size2=[l, t1], h=ten+ee, anchor=LEFT+BOTTOM);
    left(four/2) zrot(-90)           prismoid(size1=[l, t2], size2=[l, t1], h=ten+ee, anchor=LEFT+BOTTOM);
    left(four/2) zrot(90) yrot(-90)  prismoid(size1=[l, t2], size2=[l, t1], h=ten+ee, anchor=LEFT+BOTTOM);
    back(four/2) zrot(180) yrot(-90) prismoid(size1=[l, t2], size2=[l, t1], h=ten+ee, anchor=LEFT+BOTTOM);
    
    down (four/2) xrot(90)           prismoid(size1=[l, t2], size2=[l, t1], h=ten+ee, anchor=LEFT+BOTTOM);
    down (four/2) yrot(90) zrot(-90) prismoid(size1=[l, t2], size2=[l, t1], h=ten+ee, anchor=LEFT+BOTTOM);
    
    yrot(45) up(9) cuboid([0.25, 4, 20], anchor=BOTTOM);
    xrot(45) up(9) cuboid([4, 0.25, 20], anchor=BOTTOM);
    zrot(45) fwd(9) cuboid([0.25, 20, 4], anchor=BACK);

    //back(3) left(3) down(3) xrot(-45) zrot(45) cuboid([50, 50, 50], anchor=FRONT);
    
    //down(four/2) left(four) back(four) up(ee) cuboid([l+ee, l+ee, l+ee], chamfer=four, edges=[LEFT+TOP, BACK+TOP], anchor=TOP+LEFT+BACK);
    
    left((four-b)/2) back((four-b)/2) up(ee) cuboid([forty+(four-b)/2+ee, forty+(four-b)/2+ee, four-b], chamfer=(four-b)/2, edges=[LEFT+TOP, BACK+TOP, LEFT+BOTTOM, BACK+BOTTOM], anchor=TOP+LEFT+BACK);
}

 //left(four/2) back(four/2) up(ee) cuboid([l+ee, l+ee, four], chamfer=four/2, anchor=TOP+LEFT+BACK);
down(four+1)
difference() {
    left((four-b)/2) back((four-b)/2) up(ee) cuboid([forty+(four-b)/2+ee, forty+(four-b)/2+ee, four-b], chamfer=(four-b)/2, edges=[LEFT+TOP, BACK+TOP, LEFT+BOTTOM, BACK+BOTTOM], anchor=TOP+LEFT+BACK);
    
    right(ten-0.5) down(ten-0.5) fwd(ten-0.5) cuboid([l, l, l], anchor=LEFT+BACK+BOTTOM);
    down (four/2) xrot(90)           prismoid(size1=[l, t2], size2=[l, t1], h=ten+ee, anchor=LEFT+BOTTOM);
    down (four/2) yrot(90) zrot(-90) prismoid(size1=[l, t2], size2=[l, t1], h=ten+ee, anchor=LEFT+BOTTOM);
    left((four-b)/2-0.2) back((four-b)/2-0.2) cuboid([l, l, l], anchor=RIGHT+BACK);
    left((four-b)/2-0.2) back((four-b)/2-0.2) cuboid([l, l, l], anchor=FRONT+LEFT);
}