include <BOSL2/std.scad>
include <../modules/box/v1.scad>

$fa = 1;
$fs = $preview ? 3 : 0.25;

l = 100;
w = 60;
h = 36;
r = 9;
t = 0.8;
tolerance = 0.2;

// Outer box
box_v1(
  [100, 60, 36],
  radius=r,
  box_wall_t=t,
  grip_tab_l=26,
  hinge_count=2, hinge_margin=10
) {
  grid(size=[100, 60, 48], layout=[2, 1]);
}

ir = r - t - tolerance;

// Insets

inset_h = 1;
font = "Adwaita Sans:style=bold";

// Flat Inlays
!union() {
  *color("red") up(h + 10) left(l / 4 - tolerance / 2) diff()
          cuboid(
            [l / 2 - t * 2 - tolerance, w - t * 2 - tolerance, inset_h],
            rounding=r - t, edges=[LEFT + FRONT, LEFT + BACK]
          ) {

            tag("keep") left(12) back(1) attach(TOP, TOP, inside=true) cuboid([10, 0.6, inset_h]);

            tag("remove") text3d(
                "Dirty", h=inset_h + 1,
                font=font, size=10, center=true
              );
          }

  color("red") up(h + 10) right(l / 4 - tolerance / 2) diff()
          cuboid(
            [l / 2 - t * 2 - tolerance, w - t * 2 - tolerance, inset_h],
            rounding=ir, edges=[LEFT + FRONT, LEFT + BACK]
          ) {

            attach(BOTTOM, TOP) cuboid(
                [l / 2 - t * 2 - tolerance*2 - t * 2, w - t * 2 - tolerance*2 -t * 2, 2],
                rounding=ir, edges=[LEFT + FRONT, LEFT + BACK]
              );

            tag("keep") left(1) back(0.2) attach(TOP, TOP, inside=true) cuboid([9, 0.6, inset_h]);
            tag("keep") fwd(2.6) right(7) attach(TOP, TOP, inside=true) cuboid([8, 0.6, inset_h]);

            tag("remove") text3d(
                "Clean", h=3 + 1,
                font=font, size=10, center=true
              );
          }
}

// Volumetric inlays

color("green") hollow_box(
    l=l / 2 - t * 1.5 - tolerance,
    w=w - t * 2 - tolerance,
    h=h - 2,
    wt=t,
    ft=t,
    br=ir,
    br_vec=[0, 1, 1, 0]
  );
