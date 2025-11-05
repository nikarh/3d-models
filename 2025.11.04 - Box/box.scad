include <BOSL2/std.scad>

//import("/home/nikarh/Parametric Box 120x80x40_2x2.3mf");

thickness = 0.8; // Outer box thickness
separator_thickness = 0.8; // Thickness of separators

// Small

// height = 14;
// length = 60;
// width = 40;

height = 36;
length = 168;
width = 95;

// Main box border radius top down.
// Other radii are calculated from that and thickness
outer_radius = 9;
// Bottom chamfer radius
box_bottom_r = 0.4;

// Latch
latch_d = 3; // Latch pipe diameter
latch_r = latch_d / 2;
latch_tear_a = 45; // Latch teardrop angle
latch_hole_d = 1.2;
// Skirt
skirt_bottom_r = 2; // Bottom chamfer
skirt_tear_h = latch_r / tan(latch_tear_a / 2); // + thickness / tan(latch_tear_a);
// Total height of the skirt including chamfer/radius
skirt_h = skirt_tear_h + skirt_bottom_r;
skirt_dh = skirt_tear_h; // Clearance in mm from the top
lid_h = skirt_tear_h + box_bottom_r;

latch_box_segments = 3; // 2
latch_lid_segments = latch_box_segments - 1;
latch_segments = latch_box_segments + latch_lid_segments;
latch_margin = 10; // 1; // left-right margin along length side starting from the end of the rounding
latch_tolerance = 0.2; // Tolerance from each side between segments
latch_length = (length - outer_radius * 2 - latch_margin * 2 - (latch_segments - 1) * latch_tolerance) / latch_segments;
latch_rod_length = latch_length * latch_segments + latch_tolerance * (latch_segments - 1);

grip_w = 26;
grip_w_t = grip_w + 0.01; // Add tolerance

module filled_box(height = height, d = 0, top) {
  offset_sweep(
    round_corners(
      rect([length + d * 2, width + d * 2]),
      radius=outer_radius + d, $fs=0.5, $fa=0.5
    ),
    height=height,
    check_valid=false, steps=4,
    top=top,
    bottom=os_teardrop(r=box_bottom_r),
  );
}

module hollow_box(height, d = 0, outer_top, inner_top) {
  difference() {
    // Body of the box
    filled_box(height=height, d=d, top=outer_top);

    // Remove the insides
    up(thickness)
      offset_sweep(
        round_corners(
          rect([length - thickness * 2 + d * 2, width - thickness * 2 + d * 2]),
          radius=outer_radius - thickness / 2 + d, $fs=0.5, $fa=0.5
        ),
        height=height,
        check_valid=false, steps=4,
        bottom=os_teardrop(r=box_bottom_r),
        top=inner_top
      );
  }
}

module latch(side = 1) {
  difference() {
    // Sweep a teardrop2d instead of using plain teardrop
    // in order to have better control over chamfer function
    down(latch_length / 2) offset_sweep(
        teardrop2d(d=latch_d, ang=latch_tear_a / 2, $fn=20),
        height=latch_length,
        top=os_chamfer(0.4, angle=45),
        bottom=os_chamfer(0.4, angle=45),
      );

    // Cutout a teardrop instead of a cylinder in order
    // to reduce the angle of overhangs
    zrot(180) xrot(90)
        yrot(side * latch_tear_a / 2)
          teardrop(d=latch_hole_d, h=latch_length + 2, cap_h=0.6, $fn=32);
    // cyl(h=latch_length + 2, d=latch_hole_d, $fn=32);
  }
}

// Main box body
hollow_box(height=height, d=0, outer_top=os_chamfer(height=0.4));

// Walls
module ywall() {
  left(length / 2 - separator_thickness / 2) intersection() {
      up(height / 2 + thickness / 2) cuboid([separator_thickness, width, height - thickness]);
    }
}

module xwall(l, t = [0, 0]) {
  left(length / 2 - l / 2) intersection() {
      move(t) up(height / 2 + thickness / 2) cuboid([l, separator_thickness, height - thickness]);
    }
}

// Draw walls, and 
intersection() {
  union() {
    // First wall is at 36
    right(36) ywall();

    // Next 3 walls separate remaining space equally
    remain_x = length - 36 - 2 * thickness - separator_thickness * 4;
    each_x = remain_x / 4;

    right(36 + (each_x + separator_thickness) * 1) ywall();
    right(36 + (each_x + separator_thickness) * 2) ywall();
    right(36 + (each_x + separator_thickness) * 3) ywall();

    xwall(36, [0, -(width / 2 - width / 3 - 0.5)]);
    xwall(36, [0, +(width / 2 - width / 3 - 0.5)]);
    xwall(length - 36, [36, 0]);
  }

  // Intersect walls with the main box, otherwise they will clip through chamfers
  filled_box(top=os_chamfer(height=0.4));
}

// Latching mechanism

skirt_w = width + thickness * 2;
skirt_l = length + thickness * 2;
skirt_r = outer_radius + thickness;
skirt_r2 = thickness / 2.1;

// Skirt
up(height - skirt_dh - skirt_h) difference() {
    move([-skirt_l / 2, -skirt_w / 2]) offset_sweep(
        round_corners(
          // rect([length + thickness * 2, width + thickness * 2]),
          [
            [0, 0],
            [0, skirt_w],
            [skirt_l, skirt_w],
            [skirt_l, 0],
            [(skirt_l + grip_w_t) / 2, 0], // recess
            [(skirt_l + grip_w_t) / 2, thickness], // recess
            [(skirt_l - grip_w_t) / 2, thickness], // recess
            [(skirt_l - grip_w_t) / 2, 0], // recess
          ],
          radius=[
            skirt_r,
            skirt_r,
            skirt_r,
            skirt_r,
            skirt_r2,
            skirt_r2,
            skirt_r2,
            skirt_r2,
          ], $fs=0.5, $fa=0.5
        ),
        height=skirt_h,
        steps=8, // chamfer steps
        bottom=os_teardrop(r=skirt_bottom_r),
      );

    down(height / 2) filled_box();
  }

// Body latch
color("red")
  down(skirt_dh)
    xcopies(spacing=(latch_length + latch_tolerance) * 2, n=latch_box_segments)
      move([0, (width + latch_d) / 2 + thickness, height])
        rot([90, 180 + latch_tear_a / 2, 90]) latch();


// Lid
//up(height + lid_h - skirt_dh) xrot(180)
left(length + 10)
  union() {
    hollow_box(height=lid_h, d=thickness, inner_top=os_chamfer(height=-1.2));
    color("red")
      xcopies(spacing=(latch_length + latch_tolerance) * 2, n=latch_lid_segments)
        move([0, -(width + latch_d) / 2 - thickness, lid_h])
          rot([90, 180 - latch_tear_a / 2, 90]) latch(-1);
    move([0, width / 2 + thickness * 1.5, skirt_tear_h / 2 + box_bottom_r]) xrot(-90) diff()
          wedge([grip_w, skirt_tear_h, thickness], center=true)
            attach("top_edge", FWD + LEFT, inside=true)
              rounding_edge_mask(r=thickness / 1.5, l=$edge_length + 1, $fn=32);
  }

// fwd(width)
//   yrot(90) cyl(d=latch_hole_d - 0.4, l=latch_rod_length, $fn=32);
