include <BOSL2/std.scad>

$fa = 0.5;
$fs = 0.5;

wall_thickness = 1.2;
floor_thickness = 0.8;

l = 86.4;
w = 50.4;
h = 14;

r = 4;

hole_offset = 4; // offset to hole center

bump_w = 8; // real is 8, but 6 will give space for fle cable
bump_h = 6 - 1.5; // total h minus pcb width

// Offset from the corners to real screen
screen_padding_y = 3.4;
screen_padding_l = 16.8;
screen_padding_r = 11.6;

sd_h = 3;
sd_w = 15;
sd_padding_x = 31.4;
sd_padding_z = 5.8; // from screen itself

r_offset = 7;
r_w = 8;

usb_padding_y = 26.2; // center of the hole to top edge
usb_padding_z = 5.6; // from screen
usb_h = 3.8;
usb_w = 8.8;

diff()
  cuboid(
    [l + wall_thickness * 2, w + wall_thickness * 2, h],
    edges=[LEFT + FRONT, RIGHT + FRONT, LEFT + BACK, RIGHT + BACK],
    rounding=r
  ) {

    // Add a holder for the stylus
    // up(3)attach(BACK, LEFT) yflip() xrot(-45/2) teardrop(h=60, d=6, chamfer=2, ang=45/2);

    // Carve out the container
    up(floor_thickness + bump_h) attach(TOP, TOP, inside=true)
        cuboid(
          [l, w, h],
          edges=[LEFT + FRONT, RIGHT + FRONT, LEFT + BACK, RIGHT + BACK],
          rounding=r - wall_thickness
        );

    // Carve out for the screen body
    attach(TOP, TOP, inside=true)
      down(floor_thickness) cuboid([l - bump_w * 2, w, h]);

    // Carve out hole for the screen
    sbl = l - screen_padding_l - screen_padding_r;
    sbw = w - screen_padding_y * 2;
    attach(TOP, TOP, inside=true)
      left((screen_padding_l - screen_padding_r) / 2) up(floor_thickness)
          cuboid([sbl, sbw, h], chamfer=-2);

    // Carve out holes for m3 screws
    for (i = [[1, 1], [-1, -1], [-1, 1], [1, -1]])
      tag("remove") move([(l / 2 - hole_offset) * i[0], (w / 2 - hole_offset) * i[1], floor_thickness]) cyl(h, d=2.8);

    // Carve out sd card hole
    right(wall_thickness + sd_padding_x)
      up(floor_thickness + sd_padding_z) attach(FRONT, TOP, align=BOTTOM + LEFT, inside=true)
          down(0.5)
            cuboid(
              [sd_w, sd_h, wall_thickness + 1],
              edges=[LEFT + FRONT, RIGHT + FRONT, LEFT + BACK, RIGHT + BACK],
              rounding=1.3
            );

    // Carve out a hole for resistor
    move([-wall_thickness, wall_thickness + r_offset, floor_thickness + bump_h - 2]) attach(TOP, TOP, inside=true, align=RIGHT + FRONT)
        cuboid([bump_w, r_w, h]);

    // Carve a hole for USB
    #fwd(wall_thickness + usb_padding_y - usb_w / 2)
      up(wall_thickness + usb_padding_z)
        attach(LEFT, TOP, align=BOTTOM + BACK, inside=true)
          down(0.5)
            cuboid(
              [usb_w, usb_h, wall_thickness + 1],
              edges=[LEFT + FRONT, RIGHT + FRONT, LEFT + BACK, RIGHT + BACK],
              rounding=usb_h / 2
            );
  }

// Back lid

lid_h = h - floor_thickness - bump_h - 1.8;
lid_tolerance = 0.2;
screw_head_h = 2.4;

column_side = 7.4;

fwd(w + 4) diff() cuboid(
      [l - lid_tolerance, w - lid_tolerance, lid_h],
      edges=[LEFT + FRONT, RIGHT + FRONT, LEFT + BACK, RIGHT + BACK],
      rounding=r - wall_thickness
    ) {

      // Carve out holes for m3 screws
      for (i = [[1, 1], [-1, -1], [-1, 1], [1, -1]])
        tag("remove") move([(l / 2 - hole_offset) * i[0], (w / 2 - hole_offset) * i[1], floor_thickness])
            cyl(h, d=3.1);

      // Carve out holes for m3 screw heads
      for (i = [[1, 1], [-1, -1], [-1, 1], [1, -1]])
        #tag("remove") move([(l / 2 - hole_offset) * i[0], (w / 2 - hole_offset) * i[1], -lid_h / 2 + screw_head_h / 2])
            cyl(screw_head_h, d=6);

      up(2) attach(BOTTOM, TOP, inside=true) cuboid(
            [
              l - lid_tolerance - column_side * 2,
              w,
              h,
            ]
          );
      up(2) attach(BOTTOM, TOP, inside=true) cuboid(
            [
              l,
              w - lid_tolerance - column_side * 2,
              h,
            ]
          );
    }
