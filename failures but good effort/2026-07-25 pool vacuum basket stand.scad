include <BOSL2/std.scad>


dz = 5;
dx = 240;


partition([250, 250, 100], spread=10, cutsize=5, spin=90) zrot(30) {

    cuboid([dx, 10, dz], anchor=BOTTOM);
    right(dx/2) prismoid(size1=[14,dz], size2=[14,dz], shift=[-dx/2,0], h=dx/2, orient=BACK, anchor=BACK+BOTTOM);
    left(dx/2) prismoid(size1=[14,dz], size2=[14,dz], shift=[dx/2,0], h=dx/2, orient=BACK, anchor=BACK+BOTTOM);

    right(dx/2) {
        fwd(2.5) cuboid([50, 5, 25], anchor=BOTTOM+RIGHT);
        fwd(5) cuboid([5, 25, 25], anchor=BOTTOM+FRONT);
    }
    left(dx/2) {
        fwd(2.5) cuboid([50, 5, 25], anchor=BOTTOM+LEFT);
        fwd(5) cuboid([5, 25, 25], anchor=BOTTOM+FRONT);
    }

    back(100) cuboid([100, 5, 60], anchor=BOTTOM);
}


/*
partition([250, 250, 50], spread=10, cutsize=5, spin=90) {
    zrot(20) 
    difference() {
        union() {
            left(dx/2) cyl(r=20, h=dz);
            right(dx/2) cyl(r=20, h=dz);
            cuboid([dx, 10, dz]);
            
            right(100) prismoid(size1=[14,dz], size2=[14,dz], shift=[-100,0], h=100, orient=BACK);
            left(100) prismoid(size1=[14,dz], size2=[14,dz], shift=[100,0], h=100, orient=BACK);
            back(97) down(dz/2) cuboid([20, 10, 50], anchor=BOTTOM+BACK);
        }
        
        left(100) cyl(r=15, h=dz+1);
        right(100) cyl(r=15, h=dz+1);
    }
}
*/


/*
    difference() {
        union() {
            cyl(r=125, h=dz);
            left(100) cyl(r=20, h=dz);
            right(100) cyl(r=20, h=dz);
        }
        //cyl(r=115, h=dz+1);
        cuboid([250, 200, dz+1], anchor=BACK);


    }

    cuboid([250, 10, dz]);    

//}
    */