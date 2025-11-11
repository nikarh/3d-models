include <BOSL2/std.scad>
include <../modules/box/v1.scad>

// Tiny box
box_v1(
  [60, 40, 14],
  grip_l=14,
  lid_t=0.8,
  hinge_count=2, hinge_margin=1,
);
