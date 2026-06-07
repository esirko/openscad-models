include <BOSL2/std.scad>

// measurements are the grid of measurements I took from a laser level. The laser projects
// a flat surface 43mm above its base, and the ruler I used has a 7mm buffer at the bottom.
// I put the laser in the upper right corner.
// So a measurement of 36 means the floor is at the right level already,
// and a measurement of 63.5 means the floor is too low by 27.5mm.
measurements = [[63.5, 59.5, 55, 50, 43, 36],
    [64.5, 59.5, 55, 50, 42.5, 34],
    [64.5, 59, 54, 49, 41, 34],
    [63.5, 58.5, 53, 47.5, 40, 34],
    [62, 57, 53, 47, 39, 32],
    [62, 56, 51, 45, 37, 31.5]];
    
tilex = 85;
minorgap = 20;
majorgap = 30;
e = 0.01;
h = 4;
hslop=0.2;
doveslop=1.0;
overhang_angle = 0;
    
module create_four(m00, m02, m20, m22, i, j) {
    //echo("creating 4: ", m00, m02, m20, m22);
    
    m01 = (m00 + m02) / 2;
    m10 = (m00 + m20) / 2;
    m11 = (m00+m02+m20+m22)/4;
    m12 = (m02 + m22) / 2;
    m21 = (m20 + m22) / 2;

    create_one(m00, m01, m10, m11, 2*i, 2*j);
    //color("#ffc0c0") 
    right(tilex + minorgap) create_one(m01, m02, m11, m12, 2*i, 2*j+1);
    //color("#ffa0a0") 
    fwd(tilex + minorgap) create_one(m10, m11, m20, m21, 2*i+1, 2*j);
    //color("#ff8080") 
    right(tilex + minorgap) fwd(tilex + minorgap) create_one(m11, m12, m21, m22, 2*i+1, 2*j+1);
}

module create_one(m00, m01, m10, m11, ii, jj) {
    //echo("creating 1: ", m00, m01, m10, m11);

    p00 = [0, 0, m00];
    p01 = [tilex, 0, m01];
    p10 = [0, -tilex, m10];
    p11 = [tilex, -tilex, m11];
    
    // Not sure why plane_from_points isn't working very well on 4 points, it frequently returns undef
    plane00 = plane_from_points([p00, p01, p10]);
    plane01 = plane_from_points([p01, p10, p11]);
    plane10 = plane_from_points([p10, p11, p00]);
    plane11 = plane_from_points([p11, p00, p01]);
    
    // Since the direction of the plane normal is arbitrary we need to make sure they're all pointing the same direction before taking the average
    plane00corrected = plane00;
    plane01corrected = vector_angle(plane_normal(plane00), plane_normal(plane01)) < 90 ? plane01 : -plane01;
    plane10corrected = vector_angle(plane_normal(plane00), plane_normal(plane10)) < 90 ? plane10 : -plane10;
    plane11corrected = vector_angle(plane_normal(plane00), plane_normal(plane11)) < 90 ? plane11 : -plane11;
    
    avgplane = (plane00corrected + plane01corrected + plane10corrected + plane11corrected) / 4;
    //echo("avgplane ", avgplane);

    difference() {
        diff() cuboid([tilex, tilex, 100], anchor=TOP+LEFT+BACK) {
            tag("remove") up(e) attach(TOP) color("red") text3d(str(ii, ",", jj), size=16, anchor=TOP);

            if (jj < 9) attach(RIGHT) prismoid(size1=[100, 20], size2=[100, 29], h=h, spin=90, rounding=2);
            if (ii < 9) attach(FRONT) prismoid(size1=[100, 20], size2=[100, 29], h=h, spin=90, rounding=2);
            if (jj > 0) left(e) attach(LEFT) tag("remove") prismoid(size1=[101, 29+doveslop], size2=[100, 20+doveslop], h=h+hslop, spin=-90, anchor=TOP);
            if (ii > 0) back(e) attach(BACK) tag("remove") prismoid(size1=[101, 29+doveslop], size2=[100, 20+doveslop], h=h+hslop, spin=-90, anchor=TOP);
            
            // This conical cutout idea, to save filament when strength isn't as needed, is completely worthless. It creates another wall (which might make it stronger!), and you can get much better savings by simply adjusting the infill percentage.
            //if ( ((ii > 0 && ii < 4) || (ii > 5 && ii < 9)) && 
            //     ((jj > 0 && jj < 4) || (jj > 5 && jj < 9)) &&
            //     ((ii != 1 || jj != 1) && (ii != 1 || jj != 8) && (ii != 8 || jj != 1) && (ii != 8 || jj != 8)) ) {
            //    attach(TOP) down(2) tag("remove") cyl(r1=60/tan(90-overhang_angle), r2=0, h=60, anchor=TOP);
            //}
        }
        
        
        
        up(avgplane[3]) rot(from=UP, to=plane_normal(avgplane))
            left(50) back(50) cuboid([tilex+100, tilex+100, 100], anchor=TOP+LEFT+BACK);
    }
}


for (i = [0 : 1 : 4]) {
    for (j = [0 : 1 : 4]) {
        right(j * (2 * (tilex+minorgap) + majorgap)) fwd(i * (2 * (tilex+minorgap) + majorgap)) create_four(31 - measurements[i][j], 31 - measurements[i][j+1], 31 - measurements[i+1][j], 31 - measurements[i+1][j+1], i, j);
    }
}

/*
    diff() cuboid([10, 40, 7], anchor=TOP+LEFT+BACK) {
        tag("remove") up(e) attach(TOP) color("red") text3d(str("1"), size=8, anchor=TOP);
        attach(RIGHT) prismoid(size1=[7, 20], size2=[7, 29], h=h, spin=90, rounding=2);
    }

    right(20) 
    diff() cuboid([15, 40, 7], anchor=TOP+LEFT+BACK) {
        tag("remove") up(e) attach(TOP) color("red") text3d(str(".7"), size=8, anchor=TOP);
        left(e) attach(LEFT) tag("remove") prismoid(size1=[8, 29+doveslop], size2=[7, 20+doveslop], h=h+hslop, spin=-90, anchor=TOP);
    }
*/


