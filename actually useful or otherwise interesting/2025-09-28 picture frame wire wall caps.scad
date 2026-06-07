include <BOSL2/std.scad>


x1 = 53;
y1 = 66;

x2 = 50;
y2 = 52;
h = 6;


module cap(x, y, h) {
    difference() {
        union() {
            diff() cuboid([x, y, h], anchor=TOP)
                tag("remove") cuboid([x-2, y-2, h+1]);
                
            diff() cuboid([x+10, y+10, 1], anchor=BOTTOM) {
                left(20) tag("remove") { 
                    cyl(r=3, h=h+1);
                    //cuboid([x-2, y-2, h+1]);
                }
            }
        }
        
        left(20) cuboid([50, 4, 20], anchor=RIGHT);
    }
}


xrot(180) yrot(-90) {

cap(x1, y1, h);
up(30) cap(x2, y2, h);

}