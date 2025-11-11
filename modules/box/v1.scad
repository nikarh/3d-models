include <BOSL2/std.scad>
include <util.scad>

module box_v1(
  size,
  grip_l, // grip length for a finger to latch
  wall_t = 0.8, // wall thickness
  lid_t = 1.6, // lid thickness
  floor_t = 0.8, // floor thickness
  radius = 9, // outer radius
  hinge_d = 3, // outer diameter of the hinge
  hinge_hole_d = 1.2, // hinge hole diameter
  hinge_ang = 45, // hinge teardrop angle
  hinge_count = 3, // number of hinges on main box
  hinge_margin = 0, // margin to the first hinge from the rounding of the box
  hinge_tolerance = 0.2, // space between each hinge edge
  box_top_profile = os_chamfer(height=0.4), // offset sweep profile
  box_bottom_r = 0.4, // bottom teardrop radius
) {
  l = size[0];
  w = size[1];
  h = size[2];

  box_bottom_profile = os_teardrop(box_bottom_r);

  // Main body
  hollow_box(
    l=l,
    w=w,
    h=h,
    wt=wall_t,
    ft=floor_t,
    br=radius,
    outer_top=box_top_profile,
    outer_bottom=box_bottom_profile,
  );

  // Calculate height of the skirt based on the hinge size
  skirt_bottom_r = 2; // Bottom profile
  skirt_tear_h = (hinge_d / 2) / tan(hinge_ang / 2);
  skirt_h = skirt_tear_h + skirt_bottom_r;

  // Attach skirt
  up(h - skirt_tear_h - skirt_h)
    skirt(
      l=l + wall_t * 2,
      w=w + wall_t * 2,
      h=skirt_h,
      t=wall_t,
      gl=grip_l,
      br=radius + wall_t,
      bottom=os_teardrop(r=skirt_bottom_r),
    );

  hinge_total = hinge_count * 2 - 1;
  hinge_length = (l - radius * 2 - hinge_margin * 2 - (hinge_total - 1) * hinge_tolerance) / hinge_total;
  hinge_rod_length = hinge_length * hinge_total + hinge_tolerance * (hinge_total - 1);

  // Attach hinges to the skirt
  xcopies(spacing=(hinge_length + hinge_tolerance) * 2, n=hinge_count)
    move([0, (w + hinge_d) / 2 + wall_t, h - skirt_tear_h])
      rot([90, 180 + hinge_ang / 2, 90]) hinge(
          l=hinge_length,
          d=hinge_d,
          hole_d=hinge_hole_d,
          ang=hinge_ang,
          direction=HINGE_BOX,
        );

  // Draw lid
  lid_h = skirt_tear_h + box_bottom_r;
  left(l + wall_t * 3)
    union() {
      // Main box of the lid
      hollow_box(
        l=l + wall_t * 2,
        w=w + wall_t * 2,
        h=lid_h,
        br=radius + wall_t * 2,
        wt=wall_t,
        ft=lid_t,
        outer_bottom=box_bottom_profile,
        outer_top=os_chamfer(height=0.4),
        //inner_top=os_chamfer(height=-1.2)
      );

      // Attach hinges
      xcopies(spacing=(hinge_length + hinge_tolerance) * 2, n=hinge_count - 1)
        move([0, -(w + hinge_d) / 2 - wall_t, lid_h])
          rot([90, 180 - hinge_ang / 2, 90]) hinge(
              l=hinge_length,
              d=hinge_d,
              hole_d=hinge_hole_d,
              ang=hinge_ang,
              direction=HINGE_LID
            );

      // Attach a wedge
      move([0, w / 2 + wall_t * 1.5, skirt_tear_h / 2 + box_bottom_r]) xrot(-90) diff()
            wedge([grip_l, skirt_tear_h, wall_t], center=true)
              attach("top_edge", FWD + LEFT, inside=true)
                rounding_edge_mask(r=wall_t / 1.5, l=$edge_length + 1, $fn=32);
    }

  intersection() {
    union() { children(); }

    rounded_box(
      l=l, w=w, h=h,
      br=radius,
      top=box_top_profile,
      bottom=box_bottom_profile,
    );
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
