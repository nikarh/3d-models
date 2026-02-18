include <BOSL2/std.scad>

// All dimensions are in millimeters.
$fn = 64;

// Strip dimensions
strip_height = 10;
strip_depth  = 2;

// Angled connector + top strip
bridge_angle_deg = 45;
z_offset         = 4; // vertical distance between bottom and top strip centers

// Switch holder ring (mounted on the lower strip)
switch_length       = 114.4;
switch_depth        = 25.2;
ring_wall_thickness = 2;
ring_height         = 10;
ring_fit_clearance  = 0.3;

top_strip_length = switch_length + 2 * ring_wall_thickness;
top_strip_height = 30;
top_strip_depth  = strip_depth;

// Hole pattern
hole_inner_diameter = 4;   // screw shaft clearance
hole_outer_diameter = 7;   // countersink top diameter
hole_head_height    = 2.4; // countersink depth
hole_spacing        = 151; // center-to-center distance

// Screw bosses on wall-mount strip
mount_boss_width_x  = 12;
mount_boss_width_y  = strip_height;
mount_boss_height_z = 6;
mount_edge_margin_x = 0;

// Auto-fit mounting strip length so bosses do not overhang.
strip_length = max(
    top_strip_length,
    hole_spacing + mount_boss_width_x + 2 * mount_edge_margin_x
);

// Hole position offsets from strip center
hole_offset_x = hole_spacing / 2;
hole_center_y = 0;

eps = 0.005;

// Derived positions from z offset + angle.
bridge_run_y  = z_offset / tan(bridge_angle_deg);
top_center_z  = -z_offset;
bottom_back_y = -strip_height / 2;
top_front_y   = bottom_back_y - bridge_run_y;
top_center_y  = top_front_y - top_strip_height / 2;
top_center_x  = strip_length / 2 - top_strip_length / 2;
top_face_z    = top_center_z + top_strip_depth / 2;
top_back_y    = top_center_y - top_strip_height / 2;

ring_inner_x  = switch_length + ring_fit_clearance;
ring_inner_y  = switch_depth + ring_fit_clearance;
ring_outer_x  = ring_inner_x + 2 * ring_wall_thickness;
ring_outer_y  = ring_inner_y + 2 * ring_wall_thickness;
ring_center_z = top_face_z + ring_inner_y / 2;
ring_center_y = top_back_y - ring_height / 2;

mount_boss_center_z = strip_depth / 2 + mount_boss_height_z / 2;
mount_hole_height   = strip_depth + mount_boss_height_z + 2;
mount_sink_center_z = strip_depth / 2 + mount_boss_height_z - hole_head_height / 2 + eps;

difference() {
    union() {
        // Bottom strip
        cuboid([strip_length, strip_height, strip_depth], anchor = CENTER);

        // Extra material for screw length at hole locations.
        move([-hole_offset_x, hole_center_y, mount_boss_center_z])
            cuboid([mount_boss_width_x, mount_boss_width_y, mount_boss_height_z], anchor = CENTER);
        move([hole_offset_x, hole_center_y, mount_boss_center_z])
            cuboid([mount_boss_width_x, mount_boss_width_y, mount_boss_height_z], anchor = CENTER);

        // Middle angled section: connect attachment rectangles directly in X projection.
        hull() {
            move([top_center_x, bottom_back_y, 0])
                cuboid([top_strip_length, eps, strip_depth], anchor = CENTER);
            move([top_center_x, top_front_y, top_center_z])
                cuboid([top_strip_length, eps, top_strip_depth], anchor = CENTER);
        }

        // Top strip, parallel to the bottom strip.
        move([top_center_x, top_center_y, top_center_z])
            cuboid([top_strip_length, top_strip_height, top_strip_depth], anchor = CENTER);

        // Holder insert: cuboid ring that protrudes upward from the lower strip.
        move([top_center_x, ring_center_y, ring_center_z])
            xrot(90)
                difference() {
                    cuboid([ring_outer_x, ring_outer_y, ring_height], anchor = CENTER);
                    cuboid([ring_inner_x, ring_inner_y, ring_height + 6 * eps], anchor = CENTER);
                }
    }

    // Through holes + conical countersinks through bosses.
    move([-hole_offset_x, hole_center_y, 0])
        cyl(h = mount_hole_height, d = hole_inner_diameter, anchor = CENTER);

    move([hole_offset_x, hole_center_y, 0])
        cyl(h = mount_hole_height, d = hole_inner_diameter, anchor = CENTER);

    move([-hole_offset_x, hole_center_y, mount_sink_center_z])
        cyl(
            h = hole_head_height,
            d1 = hole_inner_diameter,
            d2 = hole_outer_diameter,
            anchor = CENTER
        );

    move([hole_offset_x, hole_center_y, mount_sink_center_z])
        cyl(
            h = hole_head_height,
            d1 = hole_inner_diameter,
            d2 = hole_outer_diameter,
            anchor = CENTER
        );
}
