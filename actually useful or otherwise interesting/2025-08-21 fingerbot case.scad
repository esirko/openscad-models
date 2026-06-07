include <BOSL2/std.scad>

e = 0.01;
e2 = 2*e;
dx = 23;
dy = 2.54;
y0 = 8;
dp = 1.25;
dxtot = dx + 2.54;

dhr = [3, 3, 3, 2, 6, 6, 6, 6];
dhl = [2, 3, 6, 6, 6, 6, 6, 6];

pdx = 4;

yrot(0) {
for (i = [0:7]) {
    back(2.54*i) difference() {
        diff() cuboid([2.54, 2.54, dhl[i]], anchor=BOTTOM+FRONT+RIGHT) {
            tag("remove") cuboid([dp, dp, 10]);
        }
    }
}
cuboid([2.54, 8*2.54, 3], anchor=TOP+FRONT+RIGHT);

right(dx) {
    for (i = [0:7]) {
        back(2.54*i) difference() {
            diff() cuboid([2.54, 2.54, dhr[i]], anchor=BOTTOM+FRONT+RIGHT) {
                tag("remove") cuboid([dp, dp, 10]);
            }
        }
    }
    cuboid([2.54, 8*2.54, 3], anchor=TOP+FRONT+RIGHT);
}

f = 0.5;

fwd(8) down(3) left(2.54) diff() cuboid([dxtot, 35, 1], anchor=TOP+FRONT+LEFT) {
    position(FRONT+LEFT+BOTTOM) right(f) cuboid([9-f, 1, 13+1], anchor=BACK+LEFT+BOTTOM) position(TOP+FRONT) cuboid([9-f, 1.5+2, 1], anchor=FRONT+BOTTOM);
    position(FRONT+RIGHT+BOTTOM) left(0) cuboid([7-0, 1, 13+1], anchor=BACK+RIGHT+BOTTOM) position(TOP+FRONT) cuboid([7-0, 1.5+2, 1], anchor=FRONT+BOTTOM);
    position(BACK+LEFT+BOTTOM) right(f) cuboid([4-f, 1, 13+1], anchor=FRONT+LEFT+BOTTOM) position(TOP+BACK) cuboid([4-f, 1.5+2, 1], anchor=BACK+BOTTOM);
    position(BACK+RIGHT+BOTTOM) left(0) cuboid([4-0, 1, 13+1], anchor=FRONT+RIGHT+BOTTOM) position(TOP+BACK) cuboid([4-0, 1.5+2, 1], anchor=BACK+BOTTOM);
    
    position(BACK+BOTTOM) cuboid([20, 1, 12+1], anchor=FRONT+BOTTOM);
    position(FRONT+BOTTOM) cuboid([20, 1, 8+1], anchor=BACK+BOTTOM);
    position(FRONT+BOTTOM+RIGHT) tag("remove") down(e) right(e) fwd(e) cuboid([10, 4, 1+e2], anchor=FRONT+BOTTOM+RIGHT);
    
    position(BOTTOM+LEFT) right(1) cuboid([tt, 20, 3], anchor=TOP+LEFT);
    position(BOTTOM+LEFT) right(5) cuboid([tt, 20, 3], anchor=TOP+LEFT);
    position(BOTTOM+LEFT) right(9) cuboid([tt, 20, 3], anchor=TOP+LEFT);
    position(BOTTOM+LEFT) right(13) cuboid([tt, 20, 3], anchor=TOP+LEFT);
    position(BOTTOM+LEFT) right(13+2.2) {
        fwd(9.5) cuboid([dxtot-13-5-2.2, 1, 3], anchor=TOP+LEFT);
        back(9.5) cuboid([dxtot-13-5-2.2, 1, 3], anchor=TOP+LEFT);
    }
    
    position(BOTTOM+LEFT) cuboid([1, 35+2, 14], anchor=BOTTOM+RIGHT)
        position(TOP+FRONT+LEFT) tag("remove") up(e) left(e) back(2) cuboid([1+e2, 6, 4], anchor=TOP+FRONT+LEFT);
}
}

sx = 12.5;
sy = 23.75;
sz = 17;
st = 1;
tt = 1;
fn = 36;


left(30)
diff()
cuboid([sx+2*st, sy+2*st, sz+st], anchor=BOTTOM+FRONT+LEFT) {
    position(TOP) tag("remove") up(e) cuboid([sx, sy, sz], anchor=TOP)

    position(BACK+TOP) tag("remove") down(6) fwd(e) cuboid([9, st+e2, sz-2-6], anchor=FRONT+TOP);
    color("blue") position(BACK+TOP+RIGHT) tag("remove") up(e) back(e) left(1) cuboid([3.5, st+e2, 10], anchor=BACK+TOP+RIGHT);
    position(BACK+TOP) tag("remove") back(1.5) up(e) cyl(r=1, h=7, $fn=fn, anchor=TOP);
    position(BACK+BOTTOM+LEFT) cuboid([1, 3, sz+st], anchor=FRONT+BOTTOM+LEFT);
    position(BACK+BOTTOM+LEFT) back(3) cuboid([sx+2*st, 1, sz+st], anchor=FRONT+BOTTOM+LEFT);
    position(BACK+BOTTOM+LEFT) cuboid([sx+2*st, 3, st], anchor=FRONT+BOTTOM+LEFT);
    color("red") fwd(1) position(BACK+TOP+LEFT) cuboid([10, 4, 8], anchor=FRONT+TOP+LEFT);
    
    position(FRONT+BOTTOM+RIGHT) back(3) cuboid([1, 20, dxtot], anchor=BOTTOM+RIGHT+FRONT) {
        position(FRONT+TOP+RIGHT) cuboid([3, 20, 1], anchor=TOP+LEFT+FRONT);
        position(FRONT+TOP+RIGHT) down(14) cuboid([3, 20, 1], anchor=TOP+LEFT+FRONT);
        up(5) position(FRONT+BOTTOM+RIGHT) fwd(1) cuboid([3, 1, dxtot-14-5], anchor=BOTTOM+LEFT+FRONT);
        up(5) position(FRONT+BOTTOM+RIGHT) back(20) cuboid([3, 1, dxtot-14-5], anchor=BOTTOM+LEFT+FRONT);
    }
}

slop = 0.5;
chx = 23; // coffee-maker hole
chy = 12;
chz = 5;
hmdx = 7;
hmy = 32; // hole-to-mount
hmz = 4;
mix = sy+2*st+4+2*slop; //mount inner dimension
miy = sx+2*st+2*slop;
miz = 4.5;

right(40) {
    
    zrot(1) fwd(2) diff() cuboid([chx+4, chy+4, chz], anchor=FRONT+LEFT+BOTTOM) {
        position(BOTTOM) tag("remove") down(e) cuboid([chx, chy, chz+e2], anchor=BOTTOM);
        position(BOTTOM+LEFT+FRONT) tag("remove") right(2) fwd(e) up(0.5) cuboid([4, 2+e2, chz], anchor=BOTTOM+LEFT+FRONT);
    }
    right(6) cuboid([20, hmy, hmz], anchor=BACK+LEFT+BOTTOM);
    left(hmdx) fwd(hmy-2) diff() cuboid([mix+4, miy+4, miz], anchor=BACK+LEFT+BOTTOM) {
        position(BOTTOM) tag("remove") down(e) cuboid([mix, miy, miz+e2], anchor=BOTTOM);
    }
    
    left(hmdx-2) fwd(hmy-e) cuboid([mix, 3, sz+st], anchor=FRONT+LEFT+BOTTOM)
        position(TOP+BACK) cuboid([mix, 4, 1], anchor=BOTTOM+BACK);
    
    //color("red") fwd(31) right(22) cuboid([1, 1, 10]);
}


// helper tools

left(60) {
    difference() {
        cuboid([3, 30, 6], anchor=FRONT+BOTTOM);
        for (i = [0:5]) {
            up(0 - e) back(dp + i*dy) cuboid([dp, dp, 6+2*e], anchor=FRONT+BOTTOM);
        }
        for (i = [0:0]) {
            up(5 + e) back(30 - dp - i*dy) cuboid([dp, dp, 1], anchor=BACK+BOTTOM);
        }
    }
}

left(70) {
    difference() {
        cuboid([3, 30, 6], anchor=FRONT+BOTTOM);
        for (i = [0:4]) {
            up(1 + e) back(dp + i*dy) cuboid([dp, dp, 5], anchor=FRONT+BOTTOM);
        }
        for (i = [0:1]) {
            up(4 + e) back(30 - dp - i*dy) cuboid([dp, dp, 2], anchor=BACK+BOTTOM);
        }
    }
}

left(80) {
    difference() {
        cuboid([3, 30, 6], anchor=FRONT+BOTTOM);
        for (i = [0:3]) {
            up(2 + e) back(dp + i*dy) cuboid([dp, dp, 4], anchor=FRONT+BOTTOM);
        }
        for (i = [0:2]) {
            up(3 + e) back(30 - dp - i*dy) cuboid([dp, dp, 3], anchor=BACK+BOTTOM);
        }
    }
}

left(90) {
    cuboid([1, 1, 20], anchor=BACK);
    cuboid([10, 3, 20], anchor=BOTTOM+BACK);
}
