include <BOSL2/std.scad>

e = 0.01;

module shim(thickness) {
    difference() {
        fwd(20) cuboid([10, 50, thickness], anchor=BOTTOM);
        fwd(40) up(thickness-1-e) text3d(str(thickness), h=1+2*e, size=8, center=true, anchor=BOTTOM);
    }
}

shim(1);
zrot(270) shim(2);
zrot(180) shim(3);
zrot(90) shim(4);

right(100)
union() {
    shim(5);
    zrot(270) shim(6);
    zrot(180) shim(7);
    zrot(90) shim(8);
}

right(200)
union() {
    shim(9);
    zrot(270) shim(10);
    zrot(180) shim(11);
    zrot(90) shim(12);
}