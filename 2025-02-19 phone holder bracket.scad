thickness = 6;
width = 20;
eps = 0.001;
radius = width / 2;

setback = 10;
vsetback = 13;

scale([1.75, 1.75, 1.75]){
// side extenders
difference() {
translate([0, (radius + setback)/2, 0])
  cube([width, radius + setback, thickness], center = true);
translate([0, (radius + setback)/2 ,0])
  cube([width - 2, radius + setback + eps, thickness + eps], center = true);
}

// nail bar
translate([0, radius + setback, 1.5])
cube([2 * width, 1, thickness + 3], center = true);

translate([-(width-0.5), radius + setback - 4.5, 1.5])
cube([1, 10, thickness + 3], center = true);

translate([width-0.5, radius + setback - 4.5, 1.5])
cube([1, 10, thickness + 3], center = true);

// top loop
difference() {
  cylinder(thickness, width/2, width/2, center = true);
  cylinder(thickness + eps, 9, 9, center = true);
  translate([0, 10, 0])
    cube([18, 20, 10 + eps], center = true);
}

// attachment from vertical extension bar to nailbar
translate([0, vsetback + (radius + setback - vsetback - 1)/2, 0]) 
    cube([5, (radius + setback - vsetback) + eps,1], center=true);

// vertical extension bar
translate([0, vsetback, -25-eps])
cube([ 5, 1, 50 + 2*eps], center=true);

// bottom loop
translate([0, 0, -35]) {
difference() {
  cylinder(thickness, width/2, width/2, center = true);
  cylinder(thickness + eps, 9, 9, center = true);
  translate([0, 10, 0])
    cube([18, 20, 10 + eps], center = true);
}

// bottom side extenders
difference() {
translate([0, (vsetback)/2, 0])
  cube([width,  vsetback, thickness], center = true);
translate([0, ( vsetback )/2 ,0])
  cube([width - 2,  vsetback + eps, thickness + eps], center = true);
}

// bottom horizontal bar
translate([0, vsetback, 0])
cube([width, 1, thickness + eps], center=true);
}

// bottom support
translate([0, 3.5, -50])
    cube([5, 20, 1], center=true);
}