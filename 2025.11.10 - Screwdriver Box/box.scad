include <BOSL2/std.scad>

// l, wl, h, segments, margin, grip_w
box = [154, 88, 50, 3, 10, 22];

box_wall_thickness = 1.4; // Outer box thickness
lid_thickness = 1.6;
separator_thickness = 1.0; // Thickness of separators

height = box[2];
length = box[0];
width = box[1];

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
skirt_tear_h = latch_r / tan(latch_tear_a / 2); // + box_wall_thickness / tan(latch_tear_a);
// Total height of the skirt including chamfer/radius
skirt_h = skirt_tear_h + skirt_bottom_r;
skirt_dh = skirt_tear_h; // Clearance in mm from the top
lid_h = skirt_tear_h + box_bottom_r + lid_thickness - box_wall_thickness;

latch_box_segments = box[3];
latch_lid_segments = latch_box_segments - 1;
latch_segments = latch_box_segments + latch_lid_segments;
latch_margin = box[4]; // left-right margin along length side starting from the end of the rounding
latch_tolerance = 0.2; // Tolerance from each side between segments
latch_length = (length - outer_radius * 2 - latch_margin * 2 - (latch_segments - 1) * latch_tolerance) / latch_segments;
latch_rod_length = latch_length * latch_segments + latch_tolerance * (latch_segments - 1);

grip_w = box[5];
grip_w_t = grip_w + 0.01; // Add tolerance

// L, W, H are OUTER sizes, so they include thickness
module rounded_box(
  l, // length along X axis
  w, // width along Y axis
  h, // height along Z axis
  br = 0, // border radii top down view
  top, // top chamfer
  bottom // bottom chamfer
) {
  offset_sweep(
    round_corners(rect([l, w]), radius=br, $fs=0.5, $fa=0.5),
    height=h,
    check_valid=false, steps=4,
    top=top, bottom=bottom,
  );
}

module hollow_box(
  l, // length along X axis
  w, // width along Y axis
  h, // height along Z axis
  wt, // wall thickness
  ft = wt, // floor thickness
  br = 0, //  border radii top down view
  outer_top = undef, // outer top chamfer
  inner_top = undef, // inner top chamfer
  outer_bottom = undef, // outer bottom chamfer
  inner_bottom = undef, // inner bottom chamfer
) {
  epsilon = 0.01; // helps with visual artifacts before render

  _inner_bottom = (ft > 0 && !is_def(inner_bottom)) ? outer_bottom : inner_bottom;
  _ft = (ft == 0) ? -epsilon : ft;

  difference() {
    // Body of the box
    rounded_box(l=l, w=w, h=h, br=br, top=outer_top, bottom=_inner_bottom);

    // Remove the insides
    up(_ft) // Bump it up for floor thickness
      rounded_box(l=l - wt * 2, w=w - wt * 2, h=h - ft + epsilon * 2, br=br - wt / 2, top=inner_top, bottom=inner_bottom);
  }
}

// Main body
hollow_box(l=length, w=width, h=height, wt=box_wall_thickness, ft=0, br=outer_radius);

/*
module hollow_box(
  height, // full height
  floor_thickness = box_wall_thickness,
  d = 0, // x-y delta
  outer_top, // chamfer
  inner_top // chamfer
) {
  difference() {
    // Body of the box
    filled_box(height=height, d=d, top=outer_top);

    // Remove the insides
    up(floor_thickness)
      offset_sweep(
        round_corners(
          rect([length - box_wall_thickness * 2 + d * 2, width - box_wall_thickness * 2 + d * 2]),
          radius=outer_radius - box_wall_thickness / 2 + d, $fs=0.5, $fa=0.5
        ),
        height=height - floor_thickness + box_wall_thickness,
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

// Latching mechanism

skirt_w = width + box_wall_thickness * 2;
skirt_l = length + box_wall_thickness * 2;
skirt_r = outer_radius + box_wall_thickness;
skirt_r2 = box_wall_thickness / 2.1;

// Skirt
up(height - skirt_dh - skirt_h) difference() {
    move([-skirt_l / 2, -skirt_w / 2]) offset_sweep(
        round_corners(
          // rect([length + box_wall_thickness * 2, width + box_wall_thickness * 2]),
          [
            [0, 0],
            [0, skirt_w],
            [skirt_l, skirt_w],
            [skirt_l, 0],
            [(skirt_l + grip_w_t) / 2, 0], // recess
            [(skirt_l + grip_w_t) / 2, box_wall_thickness], // recess
            [(skirt_l - grip_w_t) / 2, box_wall_thickness], // recess
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
      move([0, (width + latch_d) / 2 + box_wall_thickness, height])
        rot([90, 180 + latch_tear_a / 2, 90]) latch();


// Lid
//up(height + lid_h - skirt_dh) xrot(180)
left(length + 10)
  union() {
    hollow_box(
      height=lid_h,
      floor_thickness=lid_thickness,
      d=box_wall_thickness,
      inner_top=os_chamfer(height=-1.2)
    );
    color("red")
      xcopies(spacing=(latch_length + latch_tolerance) * 2, n=latch_lid_segments)
        move([0, -(width + latch_d) / 2 - box_wall_thickness, lid_h])
          rot([90, 180 - latch_tear_a / 2, 90]) latch(-1);
    move([0, width / 2 + box_wall_thickness * 1.5, skirt_tear_h / 2 + box_bottom_r]) xrot(-90) diff()
          wedge([grip_w, skirt_tear_h, box_wall_thickness], center=true)
            attach("top_edge", FWD + LEFT, inside=true)
              rounding_edge_mask(r=box_wall_thickness / 1.5, l=$edge_length + 1, $fn=32);
  }

// fwd(width)
//   yrot(90) cyl(d=latch_hole_d - 0.4, l=latch_rod_length, $fn=32);
*/
