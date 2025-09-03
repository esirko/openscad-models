include <BOSL2/std.scad>

e = 0.1;

w = 100;
h = 100;

t = 5;

theta = 20;

difference() {
    union() {
        xrot(-theta) {
            difference() {
                cuboid([w, t, h], anchor=FRONT+BOTTOM);
                back(2) up(5) cuboid([w-10, t, h-10], anchor=FRONT+BOTTOM);
            }
            color("#ffc0c0") back(t) cuboid([w, 25+t, t], anchor=TOP+BACK);
            color("red") back(e) up(h-15) prismoid(size1=[w-2*e,0], size2=[w-2*e, t-e], shift=[0,t/2], h=10);
        }

        color("#ff8080") {
            front_extent = 5 * sin(theta) + 25 * cos(theta); // distance from origin to lower point in front
            x1 = t/tan(theta); // distance from origin to x-intercept of bottom
            x2 = front_extent - x1;
            y1 = x2 * tan(theta); // distance from z=0 plane to lower point in front
            fwd(front_extent) prismoid(size1=[w,x2], size2=[w, 0], shift=[0, -x2/2], height=y1, anchor=FRONT+BOTTOM);
            cuboid([w, front_extent, 5], anchor=TOP+BACK);
        }

        back_extent = 30;
        cuboid([w, back_extent + t, t], anchor=FRONT+TOP);

        color("blue") {
            left((w-t)/2) back(t) prismoid(size1=[t,back_extent], size2=[t, 0], shift=[0, -back_extent/2+(h/2)*sin(theta)], h=h/2*cos(theta), anchor=BOTTOM+FRONT);
            right((w-t)/2) back(t) prismoid(size1=[t,back_extent], size2=[t, 0], shift=[0, -back_extent/2+(h/2)*sin(theta)], h=h/2*cos(theta), anchor=BOTTOM+FRONT);
        }
    }
    
    down(t-e) cuboid([w+2*e, 100, 10], anchor=TOP);
}