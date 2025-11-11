include <BOSL2/std.scad>
include <../modules/box/v1.scad>

// Capacitor box with weird layout
box_v1(
  [168, 95, 36],
  grip_l=26,
  hinge_count=3, hinge_margin=10
) {
  left((168 - 36 - 0.8) / 2) grid(size=[36, 95, 36], layout=[1, 3]);
  right(18) grid(size=[168 - 36, 95, 36], layout=[4, 2]);
}
