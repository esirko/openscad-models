include <BOSL2/std.scad>

/*
One-piece shallow drain-water collector for a Bambu A1 Mini.

The low front section slides below a freezer or washing-machine drain. Its
side walls remain low around the collection area, then rise toward a tall back
wall. To carry the water, lift the low/front edge and let the water settle
against the tall back wall. The wall profile is intended for a 30-45 degree
carrying angle.

Print in the generated orientation with no supports. Suggested settings are
0.20 mm layers, 4 walls, 5 bottom layers, and PETG. The broad floor provides
bed adhesion, so a brim should not be necessary on the 180 mm A1 Mini bed.

This is an open splash-resistant tray, not a sealed container. Carry it with
both hands and test it over a sink before using it near finished flooring.
*/

$fn = 64;

tray_x = 174;
tray_y = 174;
floor_thickness = 2.4;
wall_thickness = 3.0;
corner_radius = 7;

// Raising both ends equally preserves the existing 30-degree transport angle.
// The 48 mm front lip still fits beneath the newly measured drain clearance.
front_wall_height = 48;
back_wall_height = 123;

// Keep this much of the tray low enough to fit beneath the drain. Behind this
// point, the side-wall tops rise in a straight, support-free line.
low_section_end_y = -42;

// Raised waterline marks indicate volume while the tray is tilted far enough
// to make the rising top edges of the side walls horizontal.
show_fill_marks = true;
fill_mark_volumes = [250, 400, 500, 750, 1000]; // mL
fill_mark_depth = 0.8;
fill_mark_thickness = 0.8;
tilted_mark_length = 10;
flat_mark_length = 24;

inner_x = tray_x - 2*wall_thickness;
inner_y = tray_y - 2*wall_thickness;
carry_slope = (back_wall_height-front_wall_height)
    / (tray_y/2-low_section_end_y);
carry_angle = atan(carry_slope);

module floor_panel() {
    cuboid([tray_x, tray_y, floor_thickness],
        rounding=corner_radius, edges="Z", anchor=BOTTOM);
}

module front_wall() {
    translate([0, -tray_y/2+wall_thickness/2, 0])
        cuboid([tray_x, wall_thickness, front_wall_height], anchor=BOTTOM);
}

module back_wall() {
    translate([0, tray_y/2-wall_thickness/2, 0])
        cuboid([tray_x, wall_thickness, back_wall_height], anchor=BOTTOM);
}

module side_wall_profile() {
    // The polygon is expressed as [tray-depth, height]. Extruding and rotating
    // it produces a wall whose top stays low near the spout and rises aft.
    polygon([
        [-tray_y/2, 0],
        [ tray_y/2, 0],
        [ tray_y/2, back_wall_height],
        [ low_section_end_y, front_wall_height],
        [-tray_y/2, front_wall_height]
    ]);
}

module side_wall(x) {
    translate([x, 0, 0])
        rotate([90, 0, 90])
            linear_extrude(height=wall_thickness, center=true, convexity=4)
                side_wall_profile();
}

module tilted_fill_line(volume) {
    // At this angle the water forms a triangular cross section against the
    // back wall. Solve A = slope*length^2/2 for the wetted length.
    cross_section_area = volume*1000/inner_x;
    wetted_length = sqrt(2*cross_section_area/carry_slope);
    rear_y = inner_y/2;
    front_y = rear_y-wetted_length;
    mark_x = -(inner_x/2-fill_mark_depth/2+0.1);
    start_y = front_y+0.5;
    end_y = start_y+tilted_mark_length;
    start_z = floor_thickness+carry_slope*(start_y-front_y);
    end_z = floor_thickness+carry_slope*(end_y-front_y);

    hull() {
        translate([mark_x, start_y, start_z])
            cuboid([fill_mark_depth, 1.2, fill_mark_thickness]);
        translate([mark_x, end_y, end_z])
            cuboid([fill_mark_depth, 1.2, fill_mark_thickness]);
    }
}

module flat_fill_line(volume) {
    mark_z = floor_thickness+volume*1000/(inner_x*inner_y);

    translate([0, inner_y/2+0.1, mark_z])
        cuboid([flat_mark_length, fill_mark_depth, fill_mark_thickness]);
}

module fill_marks() {
    for (volume = fill_mark_volumes) {
        tilted_fill_line(volume);
        flat_fill_line(volume);
    }
}

module water_collector() {
    union() {
        floor_panel();
        front_wall();
        back_wall();
        side_wall(-tray_x/2+wall_thickness/2);
        side_wall( tray_x/2-wall_thickness/2);

        if (show_fill_marks)
            fill_marks();
    }
}

water_collector();

echo(str("Footprint: ", tray_x, " x ", tray_y, " mm"));
echo(str("Low front height: ", front_wall_height, " mm"));
echo(str("Tall back height: ", back_wall_height, " mm"));
echo(str("Level capacity to front lip: approximately ",
    floor(inner_x*inner_y*(front_wall_height-floor_thickness)/1000), " mL"));
echo(str("Marked carrying angle: ", carry_angle, " degrees"));