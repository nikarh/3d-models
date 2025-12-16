include <BOSL2/std.scad>
include <util.scad>

BOX = 1;
LID = 2;
HIDE_HINGES = 4;

module box_v1(
  size,
  radius = 9, // outer radius
  grip_tab_l, // grip length for a finger to latch
  box_wall_t = 0.8, // wall thickness
  box_floor_t = 0.8, // floor thickness
  box_top_profile = os_chamfer(height=0.4), // offset sweep profile
  box_bottom_r = 0.4, // bottom teardrop radius
  lid_oversize = 0, // protrude lid above the box
  lid_overlap = 10, // reduces box height by that amount and increases lid height
  lid_wall_t = 0.8, // lid wall thickness
  lid_floor_t = 1.6, // lid floor thickness
  lid_tolerance = 0, // increases lid size by that amount
  lid_vertical_clearance = 0.4, // decrease lid height by that amount
  hinge_d = 3, // outer diameter of the hinge
  hinge_hole_d = 1.2, // hinge hole diameter
  hinge_ang = 45, // hinge teardrop angle
  hinge_count = 3, // number of hinges on main box
  hinge_margin = 0, // margin to the first hinge from the rounding of the box
  hinge_tolerance = 0.2, // space between each hinge edge
  latch_h = 0,
  draw = BOX + LID,
) {
  draw_box = (draw % 2) >= BOX;
  draw_lid = (draw % 4) >= LID;
  draw_hinges = (draw % 8) < HIDE_HINGES;

  l = size[0];
  w = size[1];
  h = size[2];

  box_bottom_profile = os_teardrop(box_bottom_r);

  // Calculate height of the skirt based on the hinge size
  skirt_bottom_r = 2; // Bottom profile
  skirt_tear_h = (hinge_d / 2) / tan(hinge_ang / 2);
  skirt_h = skirt_tear_h + skirt_bottom_r;

  // Calculate hinge sizes
  hinge_total = hinge_count * 2 - 1;
  hinge_length = (l - radius * 2 - hinge_margin * 2 - (hinge_total - 1) * hinge_tolerance) / hinge_total;
  hinge_rod_length = hinge_length * hinge_total + hinge_tolerance * (hinge_total - 1);

  // Latch is designed to print well with overhangs
  latch_ang = 45;
  latch_len = grip_tab_l - 4;
  latch_slot_h = latch_h + lid_tolerance;
  latch_slot_base = 2 * latch_slot_h * tan(latch_ang);
  latch_base = 2 * latch_h * tan(latch_ang);

  lid_outer_chamfer = 0.2;
  lid_inner_chamfer = 0.6;
  lid_h = skirt_tear_h + box_bottom_r + lid_floor_t - lid_vertical_clearance + lid_oversize;
  lid_inner_h = lid_h - lid_oversize - lid_floor_t;

  if (draw_box) {
    // Main body
    difference() {
      hollow_box(
        l=l,
        w=w,
        h=h,
        wt=box_wall_t,
        ft=box_floor_t,
        br=radius,
        outer_top=box_top_profile,
        outer_bottom=box_bottom_profile,
      );

      hd = (lid_inner_h) - lid_vertical_clearance - lid_inner_chamfer - (latch_base - latch_slot_base) / 2;

      if (latch_h > 0)
        color("red") move([0, -w / 2, h + latch_slot_base / 2 - hd])
            xrot(-90) prismoid(
                size1=[latch_len, latch_slot_base],
                size2=[latch_len - latch_slot_base, 0], h=latch_slot_h
              );
    }

    // Attach skirt
    if (draw_hinges) {
      up(h - skirt_tear_h - skirt_h)
        skirt(
          l=l + lid_wall_t * 2,
          w=w + lid_wall_t * 2,
          h=skirt_h,
          t=lid_wall_t,
          gl=grip_tab_l,
          br=radius + lid_wall_t,
          bottom=os_teardrop(r=skirt_bottom_r),
        );

      // Attach hinges to the skirt
      xcopies(spacing=(hinge_length + hinge_tolerance) * 2, n=hinge_count)
        move([0, (w + hinge_d) / 2 + lid_wall_t, h - skirt_tear_h])
          rot([90, 180 + hinge_ang / 2, 90]) hinge(
              l=hinge_length,
              d=hinge_d,
              hole_d=hinge_hole_d,
              ang=hinge_ang,
              direction=HINGE_BOX,
            );
    }

    intersection() {
      union() { children(); }

      union() {
        rounded_box(
          l=l, w=w, h=h + lid_oversize,
          br=radius,
          top=box_top_profile,
          bottom=box_bottom_profile,
        );
      }
    }
  }

  if (draw_lid) {
    move_lid = (draw_box) ? l + box_wall_t * 3 : 0;

    // Draw lid
    left(move_lid)
      union() {
        // Main box of the lid
        difference() {
          hollow_box(
            l=l + lid_tolerance + lid_wall_t * 2,
            w=w + lid_tolerance + lid_wall_t * 2,
            h=lid_h,
            br=radius + (lid_tolerance + lid_wall_t * 2) / 2,
            wt=box_wall_t + lid_wall_t,
            ft=lid_floor_t,
            outer_bottom=box_bottom_profile,
            outer_top=os_chamfer(height=lid_outer_chamfer),
          );

          // Remove the insides
          up(lid_floor_t + lid_oversize) // Bump it up for floor thickness
            rounded_box(
              l=l + lid_tolerance,
              w=w + lid_tolerance,
              h=lid_inner_h + 0.01,
              br=radius + lid_tolerance / 2,
              top=os_chamfer(height=-lid_inner_chamfer),
            );
        }

        // Attach hinges
        if (draw_hinges) {
          xcopies(spacing=(hinge_length + hinge_tolerance) * 2, n=hinge_count - 1)
            move([0, -(w + hinge_d + lid_tolerance) / 2 - lid_wall_t, lid_h])
              rot([90, 180 - hinge_ang / 2, 90]) hinge(
                  l=hinge_length,
                  d=hinge_d,
                  hole_d=hinge_hole_d,
                  ang=hinge_ang,
                  direction=HINGE_LID
                );

          // Attach a pull_tab
          grip_tab_h = skirt_tear_h + lid_floor_t - lid_vertical_clearance - lid_outer_chamfer;
          move(
            [
              0,
              (w + lid_tolerance) / 2 + lid_wall_t * 1.5,
              grip_tab_h / 2 + box_bottom_r + lid_oversize,
            ]
          )
            xrot(-90) diff()
                wedge([grip_tab_l, grip_tab_h, lid_wall_t], center=true)
                  attach("top_edge", FWD + LEFT, inside=true)
                    rounding_edge_mask(r=lid_wall_t / 1.5, l=$edge_length + 1, $fn=32);

          // Attach an inner wedge
          if (latch_h > 0)
            color("red") move([0, w / 2, lid_h - lid_inner_chamfer - latch_base / 2])
                xrot(90) prismoid(
                    size1=[latch_len, latch_base],
                    size2=[latch_len - latch_base, 0], h=latch_h
                  );
        }
      }
  }
}

module grid(
  size,
  layout,
  box_t = 0.8,
  wall_t = 0.8, // wall thickness
) {
  l = size[0] - box_t * 2 + wall_t;
  w = size[1] - box_t * 2 + wall_t;
  h = size[2];

  x = layout[0];
  y = layout[1];

  if (y > 1) {
    up(h / 2)
      ycopies(l=w, n=y + 1) cuboid([l, wall_t, h]);
  }

  if (x > 1) {
    up(h / 2)
      xcopies(l=l, n=x + 1) cuboid([wall_t, w, h]);
  }
}
