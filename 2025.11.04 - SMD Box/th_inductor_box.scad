include <BOSL2/std.scad>
include <../modules/box/v1.scad>

// Through hole inductor box
box_v1(
  [168, 95, 36],
  grip_l=26,
  hinge_count=3, hinge_margin=10
) {
  grid(size=[168, 95, 36], layout=[6, 1]);
}
