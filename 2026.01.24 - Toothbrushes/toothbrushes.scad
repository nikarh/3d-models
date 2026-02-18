include <BOSL2/std.scad>

$fa = $preview ? 6 : 1;
$fs = $preview ? 6 : 0.25;

n_brush_shape = rect([28.4, 29.6], rounding=28.4 / 2);
n_base_d = 56.8;
n_base_h = 23.6;
n_base_hole_h = 12.6;
n_base_hole_l = 8.4;

a_brush_shake = rect([29.4, 28.2], rounding=11);
a_base_h = 11;
a_base_top_d = 54.3;
a_base_bot_d = 55;
a_base_hole_h = 8.5;
a_base_hole_l = 6;

ww = 2;
add_l = 10;
box_len = max(n_base_d, a_base_top_d) * 2 + ww * 4 + add_l;
box_w = max(n_base_d, a_base_top_d);
box_h = n_base_h + ww * 2;

diff() cuboid(
    [box_len, box_w, box_h],
    rounding=n_base_d / 2,
    edges=[LEFT + FRONT, RIGHT + FRONT],
  ) {

    // Roundings
    tag("remove") up(box_h / 2)
        path_extrude2d(
          path=outline,
          caps=false,
          s=1
        ) mask2d_roundover(r=10, spin=180);

    right(ww) attach(BOTTOM, TOP, align=LEFT, inside=true)
        cyl(h=n_base_h + ww, d=n_base_d);

    left(ww) attach(BOTTOM, TOP, align=RIGHT, inside=true)
        cyl(h=n_base_h + ww, d1=a_base_top_d, d2=a_base_bot_d);
  }

s = [box_len / 2, box_w / 2];

outline = round_corners(
  [
    v_mul([-1, 1], s),
    v_mul([-1, -1], s),
    v_mul([1, -1], s),
    v_mul([1, 1], s),
  ], radius=[0, n_base_d / 2, n_base_d / 2, 0]
);
