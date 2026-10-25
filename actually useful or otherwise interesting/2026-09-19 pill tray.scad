include <BOSL2/std.scad>

// --- PARAMETERS ---
inner_length = 42.5;
inner_width  = 79.5;
inner_depth  = 7;      // Height of the inside cavity

wall_thickness = 2;    // Thickness of the side walls
floor_thickness = 2;   // Thickness of the bottom floor

inside_rounding = 3;   // Radius of the inside fillets/corners
num_boxes = 4;

// --- DERIVED VARIABLES ---
outer_length = inner_length + (2 * wall_thickness);
outer_width  = inner_width + (2 * wall_thickness);
outer_height = inner_depth + floor_thickness;

// --- TRUNCATED/FILLETED TRAY ---
difference() {
    // 1. Outer Solid Box (with slight outside rounding for a clean look)
    cuboid([num_boxes*inner_length + (num_boxes+1)*wall_thickness, outer_width, outer_height], 
           rounding = inside_rounding + wall_thickness, 
           edges = [BOTTOM, "Z"], 
           anchor = BOTTOM);
    
    xcopies(inner_length+wall_thickness, n=num_boxes) {
        // 2. Inner Cavity (creates the inside fillets)
        translate([0, 0, floor_thickness])
            cuboid([inner_length, inner_width, inner_depth + 0.1], 
                   rounding = inside_rounding, 
                   edges = [BOTTOM, "Z"], 
                   anchor = BOTTOM);
        
        cuboid([33, 70, 50]);
    }
    
    
}
