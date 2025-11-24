include <BOSL2/std.scad>

$fa = 0.5;
$fs = 0.5;

wall_thickness = 1.2;
floor_thickness = 0.8;

l = 86;
w = 50.2;
h = 14;

r = 4;

hole_offset = 4; // offset to hole center

bump_w = 8; // real is 8, but 6 will give space for fle cable
bump_h = 6 - 1.5; // total h minus pcb width

// Offset from the corners to real screen
screen_padding_y = 2.4;
screen_padding_l = 16.2;
screen_padding_r = 10.2;

sd_h = 3;
sd_w = 14;

sd_padding_x = 31;
sd_padding_z = 5; // from screen itself

diff()
  cuboid(
    [l + wall_thickness * 2, w + wall_thickness * 2, h],
    edges=[LEFT + FRONT, RIGHT + FRONT, LEFT + BACK, RIGHT + BACK],
    rounding=r
  ) {
    // Carve out the container
    attach(TOP, TOP, inside=true)
      down(floor_thickness + bump_h) cuboid(
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
      #move([(l / 2 - hole_offset) * i[0], (w / 2 - hole_offset) * i[1], floor_thickness]) cyl(h, d=2.8);

    // Carve out sd card hole
    right(wall_thickness + sd_padding_x)
      up(floor_thickness + sd_padding_z) attach(FRONT, TOP, align=BOTTOM + LEFT, inside=true)
          down(0.5)
            cuboid(
              [sd_w, sd_h, wall_thickness + 1],
              edges=[LEFT + FRONT, RIGHT + FRONT, LEFT + BACK, RIGHT + BACK],
              rounding=1.3
            );
  }
