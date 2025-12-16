include <BOSL2/std.scad>
include <../modules/box/v1.scad>

$fa = 1;
$fs = $preview ? 3 : 0.25;

box_v1(
  [165, 90, 44],
  radius=6,
  box_wall_t=0.8,
  grip_tab_l=26,
  hinge_count=2, hinge_margin=10
) {

  up(13) diff() cuboid([165, 90, 26]) {
        back(3) up(40-26 + 13) up(0) attach(TOP, TOP, inside=true)
              cuboid([160, 31, 40], rounding=14);

        back(3) right(2) up(8) attach(TOP, FWD, align=LEFT, inside=true)
              cuboid([15.4, 30, 40], rounding=3);

        back(3) up(32) attach(TOP, FWD, inside=true) cyl(50, 20, rounding=10);

        move([2, -4, 10]) attach(TOP, TOP, align=LEFT + BACK, inside=true)
            cuboid([18.2, 12.8, 40], rounding=1);

        move([24, -4, 10]) attach(TOP, TOP, align=LEFT + BACK, inside=true)
            cuboid([18.2, 14.4, 40], rounding=1);

        move([46, -4, 10]) attach(TOP, TOP, align=LEFT + BACK, inside=true)
            cuboid([18.2, 14.4, 40], rounding=1);

        move([-2.8, -4, 8])attach(TOP, TOP, align=RIGHT + BACK, inside=true)
          cuboid([61, 9.2, 15], rounding=4);

        move([-2, 0, 8])attach(TOP, TOP, align=FWD, inside=true)
          cuboid([200, 20, 26], rounding=4);
      }
}
