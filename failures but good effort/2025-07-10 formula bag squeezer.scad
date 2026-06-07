include <BOSL2/std.scad>

fn=36;

l = 170; // groove length
h = 40; // handle length
t = 20; // y-thickness
z = 10; // z-height
g = 2; // gap
f = 5; //trapezoidal fudge
w = 30; // wing width


xflip_copy(offset=g/2)
union() {
    diff()
        prismoid(size1=[z,l], size2=[z-f, l], shift=[f/2, 0], height=t, anchor=LEFT+FRONT+BOTTOM, rounding=[2, 2, 0, 0], $fn=fn) {
            edge_profile(TOP, except=FRONT, excess=5)
                mask2d_roundover(r=2, mask_angle=$edge_angle, $fn=fn);
            edge_profile(BOTTOM, except=FRONT, excess=5)
                mask2d_roundover(r=2, mask_angle=$edge_angle, $fn=fn);
        }

    fwd(20) right(z-2) yrot(90) 
    diff()
        prismoid(size1=[z, l+20], size2=[z, 0], shift=[0, -(l+20)/2], height=w, anchor=FRONT+BOTTOM+RIGHT)
        {
            attach([BACK+LEFT, BACK+RIGHT], LEFT+FRONT, inside=true)
                rounding_edge_mask(l=max($parent_size)+5, r=2, anchor=BOTTOM, $fn=fn);
            
            attach([FRONT+RIGHT, FRONT+LEFT, FRONT+TOP], LEFT+FRONT, inside=true)
                rounding_edge_mask(l=40, r=2, anchor=BOTTOM+FRONT+LEFT, $fn=fn);
        }
}
    

cuboid([2*z+g, h, t], anchor=BACK+BOTTOM, rounding=2, $fn=fn, except=BACK);

