include <BOSL2/std.scad>
include <BOSL2/fnliterals.scad>

e = 0.01;
fn = 16;
text_h = 0.4;

//t = 2;
//w1 = 75;
//w2 = 35;
//l = 80; // length of scoop
//h = 30; // height of scoop
//sbt = 2.5; // scale from bottom to top
//shift = 10;
//hx1 = 45; // handle x, thick part
//hx2 = 20; // handle x, thin part
//hl = 70; //handle length

// Thanks Gemini
// Function to find the real root of a cubic equation: ax^3 + bx^2 + cx + d = 0
function solve_cubic(a, b, c, d) = 
    let(
        // Normalize coefficients
        b1 = b / a,
        c1 = c / a,
        d1 = d / a,
        
        // Calculate depressed cubic parameters: t^3 + pt + q = 0
        p = c1 - (pow(b1, 2) / 3),
        q = (2 * pow(b1, 3) / 27) - (b1 * c1 / 3) + d1,
        
        // Discriminant
        disc = pow(q/2, 2) + pow(p/3, 3)
    )
    (disc > 0) ? (
        // One real root (Cardano's formula)
        let(
            u = root(3, -(q/2) + sqrt(disc)),
            v = root(3, -(q/2) - sqrt(disc))
        ) u + v - (b1/3)
    ) : (
        // Three real roots (Trigonometric solution)
        let(
            r = sqrt(-4/3 * p),
            phi = acos(-q / (2 * sqrt(pow(-p/3, 3))))
        ) r * cos(phi/3) - (b1/3)
    );

// Helper function for cube root (handles negative numbers)
function root(n, x) = sign(x) * pow(abs(x), 1/n);


module draw_marking_with_params(text_fwd=0, text_right=0, text="X", size=8, line_shift=0, line_length = 10) {
    fwd(text_fwd) right(text_right) text3d(text, size=size, h=text_h, anchor=TOP+BACK, font="Arial");
    right(line_shift) cuboid([line_length, 1, text_h], anchor=TOP+FRONT);
}

module markings(l, w1, w2, sbt, cospla, inneredge_h, inneredge_l, innershift, marks, texts, mark_styles) {
    back(l/2) right(w1/4+w2/4)
    zrot(-atan2(l, (w1-w2)/2))
    xrot(90-acos(cospla))
    up(e) {
        //trapezoid equal to the inner right wall - commenting out but keep for reference
        //linear_sweep(trapezoid(w1=inneredge_l/sbt, w2=inneredge_l, h=inneredge_h, shift=-innershift), h=0.6, anchor=TOP+BACK);
        for (i = [0:len(marks)-1]) {
            echo(i, marks[i], texts[i]);
            m = 1-marks[i]; // m controls how much "down" the (bottom of the) mark is from the top of the scoop
            fwd(m*inneredge_h) {
                ml = m * (inneredge_l/sbt - inneredge_l) + inneredge_l;
                
                text_size = 8;
                
                if (mark_styles[i] == "below_with_arrow") {
                     draw_marking_with_params(1, 0, text=texts[i], size=text_size, line_shift=m*innershift, line_length = ml);
                     fwd(1) right(18) text3d("=", size=text_size, h=text_h, anchor=TOP+BACK, font="Wingdings 3");
                } else if (mark_styles[i] == "left") {
                     draw_marking_with_params(-text_size/2, 9+m*innershift+(10-ml)/2, text=texts[i], size=text_size, line_shift=m*innershift+(10-ml)/2, line_length = 10);
                } else if (mark_styles[i] == "right") {
                     draw_marking_with_params(-text_size/2, 5+ml/2+m*innershift-20, text=texts[i], size=text_size, line_shift=m*innershift+(-20)/2, line_length = ml-20);
                } else { // if (mark_styles[i] == "below") 
                    draw_marking_with_params(1, 0, text=texts[i], size=text_size, line_shift=m*innershift, line_length = ml);
                }
            }
        }
    }
}

module scoop(t=2, w1=75, w2=35, l=80, h=30, sbt = 2.5, shift=10, hx1=60, hx2=20, hl=70, mark_volumes=[1, 0.5], mark_texts=["1 cup", "1/2 cup"], mark_styles=["below_with_arrow", "below"], just_markings=false) {
    
    // Calculate volume
    w = (w1+w2)/2;
    w0 = w/sbt;
    l0 = l/sbt;
    aterm = (l - l0) * (w - w0);
    bterm = w0*(l - l0) + l0*(w - w0);
    cterm = l*w/(sbt*sbt);
    volume_mm3 = h * (aterm/3 + bterm/2 + cterm);
    echo(w, w0, l, l0, aterm, bterm, cterm);

    echo("Volume (mL): ", volume_mm3/1000);
    echo("Volume (fl.oz): ", volume_mm3/29573.5);
    echo("Volume (cups): ", volume_mm3/236588);
    
    // Calculate location of marks of desired volumes. Requires solving the cubic equation.
    mark_lines = map(function(v) solve_cubic(h*aterm/3, h*bterm/2, h*cterm, -236588*v), mark_volumes);
    for (i = [0:len(mark_volumes)-1]) {
        echo(str_join(["---- Mark ", i, " for ", mark_volumes[i], " cups: ", mark_lines[i]]));
    }

    // Three points on the right face. Assumption is the 4th point is also in the plane. (If not, I could enforce it, but I don't have to with my assumed constraints)
    p1 = [w1/2, 0, 0];
    p2 = [w2/2, l, 0];
    p3 = [w1/2/sbt, l/2-l/sbt/2-shift, -h];
    p4 = [w2/2/sbt, l/2+l/sbt/2-shift, -h];

    // The normal to the plane defined by those three points (the 4th point must be in that plane too)
    n = plane_normal(plane_from_points([p1, p2, p3]));
    ncheck = plane_normal(plane_from_points([p1, p2, p4]));
    echo("n", n, ncheck);

    // One of the points on the plane defined by pushing out the inner plane by t
    p1o = p1 + t*n;
    
    // The inner plane, and the outer plane defined by pushing out the inner plane by t
    innerplane = plane_from_normal(n, p1);
    outerplane = plane_from_normal(n, p1o);
    echo("innerplane and outerplane", innerplane, outerplane);

    // The x-coordinates of the corners of the outer plane with the constraints where y is known based on l and t and on the z=0 and z=-(h+t) planes
    p1oa = plane_line_intersection(outerplane, [xflip(p1+[0,-t,0]), p1+[0,-t,0]]);
    p2oa = plane_line_intersection(outerplane, [xflip(p2+[0,t,0]), p2+[0,t,0]]);
    p3oa = plane_line_intersection(outerplane, [xflip(p3+[0,-t,-t]), p3+[0,-t,-t]]);
    p4oa = plane_line_intersection(outerplane, [xflip(p4+[0,t,-t]), p4+[0,t,-t]]);
    echo("p1oa", p1oa, p2oa, p3oa, p4oa);
    
    // Angle for aligning text on the inner right wall
    n2 = [l, (w1-w2)/2, 0];
    absn2 = n2[0]*n2[0] + n2[1]*n2[1] + n2[2]*n2[2];
    n2n = n2/sqrt(absn2);
    cospla = n[0]*n2n[0] + n[1]*n2n[1] + n[2]*n2n[2]; // "cosine of the plane-line-angle"
    
    // Some more parameters necessary to create the trapezoid equal to the inner right wall
    inneredge_l = sqrt((w1-w2)*(w1-w2)/4 + l*l);
    inneredge_h = point_line_distance(p3, [p1, p2]);
    p3ifnoshift = back(l/2, right(w1/4+w2/4, zrot(-atan2(l, (w1-w2)/2), xrot(90-acos(cospla), [inneredge_l/sbt/2, -inneredge_h, 0]))));
    innershift2 = (p3ifnoshift - p3);
    innershift = sqrt(innershift2[0]*innershift2[0] + innershift2[1]*innershift2[1] + innershift2[2]*innershift2[2]);
    
    if (just_markings) {
        color("red") difference() {
            markings(l, w1, w2, sbt, cospla, inneredge_h, inneredge_l, innershift, mark_lines, mark_texts, mark_styles);
            fwd(5) cuboid([2*w1+10, l+10, 10], anchor=BOTTOM+FRONT);
        }
    } else {
        // the scoop
        difference() {
            fwd(t) skin([fwd(shift, (trapezoid(w1=2*p3oa[0], w2=2*p4oa[0], h=l/sbt+2*t, rounding=1, $fn=fn))), trapezoid(w1=2*p1oa[0], w2=2*p2oa[0], h=l+2*t, rounding=1, $fn=fn)], z=[0, h+t], slices=5, anchor=TOP+FRONT);
            up(e) skin([fwd(shift, trapezoid(w1=w1/sbt, w2=w2/sbt, h=l/sbt, rounding=1, $fn=fn)), trapezoid(w1=w1, w2=w2, h=l, rounding=1, $fn=fn)], z=[0, h], slices=5, anchor=TOP+FRONT);
            color("red") markings(l, w1, w2, sbt, cospla, inneredge_h, inneredge_l, innershift, mark_lines, mark_texts, mark_styles);
        }
        
        // handle
        prismoid(size1=[hx1, 1.5*t], size2=[hx2, 3*t], shift=[0, -0.75*t], h=hl, anchor=BACK+BOTTOM, orient=FRONT);
        
        // handle reinforcement and "ergonomic" grip
        hr_angle = atan2(h, l/2 - l/(2*sbt) - shift);
        down(1.5*t) 
        up(e) 
        difference() {
            skin([xrot(-hr_angle, p=path3d(trapezoid(w1=hx1, w2=0.80*hx1, h=0.2*h, anchor=FRONT))), 
                fwd(0.15*hl, xrot(-90, p=path3d(trapezoid(w1=0.75*hx1, w2=0.75*0.80*hx1, h=e, anchor=FRONT)))),
                //fwd(0.65*hl, xrot(-90, p=path3d(trapezoid(w1=0.4*hx1, w2=0.4*0.80*hx1, h=0.14*h, anchor=FRONT)))),
                //fwd(0.2*hl, up(0.1, xrot(-90, path3d(square(0.1)))))
                ], slices=5);
            //color("purple") down(e) back(e) 
            //skin([xrot(-hr_angle, p=path3d(back(0.05*h, trapezoid(w1=20, w2=0.70*hx1, h=0.15*h, anchor=FRONT)))), 
            //    up(0.1, fwd(0.75*hl, xrot(-hr_angle, path3d(square(0.1)))))
            //    ], slices=20); 
        }
    }
}

// How to design your measuring cup
// Define sizes and shape of cup with all those parameters. Rendering will echo out the volume of the entire cup.
// Specify the volumes (in units of cups) at which you want markings (i.e., 1 for one cup, 0.5 for half a cup, etc.)
// The texts array will be the labels on those marks, make sure it has the same number of elements as the marks array.
// Also you can use the mark_styles array for control over how the markings appear.
// When you're satisfied with all the parameters, export once with just_markings=false and another time 
// with just_markings=true to a separate STL file.
// In bambu studio, load both STLs at the same time, and answer Yes to loading these files as a single object with multiple parts.
// Use the outside face of the right side (the side with the text markings) as the side to place on the plate.
// You can then change the filament colors of the two parts.

// Unicode super/subscript characters for making fractions: ²⁄₃¹₄⅓⅛½¾¼⅔... not all fonts have these same characters 

//left(150)
//scoop(t=2, w1=100, w2=50, l=80, h=80, sbt=2.5, shift=10, hx1=80, hx2=20, hl=70, mark_volumes=[1.0, 0.5, 0.25], mark_texts=["1 cup", "1/2 cup", "1/4 cup"], just_markings=false);

//scoop(t=2, w1=125, w2=15, l=100, h=67, sbt=2.5, shift=10, hx1=90, hx2=20, hl=70, mark_volumes=[1.0, 0.666, 0.5, 0.333, 0.25], mark_texts=["1 cup", "⅔", "½", "⅓", "¼"], mark_styles=["below_with_arrow", "left", "right", "left", "right"], just_markings=false);

zrot(60)
scoop(t=2, w1=100, w2=50, l=80, h=46.5, sbt=2, shift=10, hx1=90, hx2=20, hl=70, mark_volumes=[0.666, 0.5, 0.333, 0.25], mark_texts=["⅔ cup", "½", "⅓", "¼"], mark_styles=["below_with_arrow", "left", "right", "left"], just_markings=false);




