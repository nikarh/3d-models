include <BOSL2/std.scad>
include <./v1.scad>

$fa = 1;
$fs = $preview ? 3 : 0.25;

// Tiny box
box_v1(
  [60, 40, 14],
  grip_tab_l=14,
  lid_tolerance = 0.6,
  lid_vertical_clearance=0.2,
  lid_floor_t = 0.8,
  box_floor_t = 0.8,
  hinge_count=2, hinge_margin=1,
);
