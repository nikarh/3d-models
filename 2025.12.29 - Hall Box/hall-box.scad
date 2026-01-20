include <BOSL2/std.scad>
include <BOSL2/joiners.scad>

$fa = $preview ? 3 : 1;
$fs = $preview ? 3 : 0.25;

car_key_h = 35;
car_key_l_1 = 42;
car_key_l_2 = 36;
car_key_w = 19;

f_h = 1.4;
w_t = 2;

h = car_key_h + f_h;
l = 250;
w = 160;
r = 10;

dist = 3;
glasses_w = 38;
glasses_l = 57;
glasses_h = 60;

glasses_r = 5;
glasses_rows = 3;
glasses_cols = 2;

key_dist = 10;

slot_w = 100;

add_l = glasses_l * glasses_cols + (glasses_cols + 1) * dist;
add_w = glasses_w * glasses_rows + (glasses_rows + 1) * dist; //w;

glasses_move_y = (w - add_w) / 2;

card_w = 24;
card_l = glasses_l * glasses_cols + (glasses_cols - 1) * dist; // 100
card_h = 35;

eufy_l = 25;
eufy_w = 3.4;
eufy_d = 2.4;
eufy_d_l = 20;

dt_l = 100;
dt_w = 16;
dt_h = 8;

panel_l = l - add_l;
panel_w = dt_w + 2;
panel_h = 180;
panel_b = 2;
panel_wt = 2;

// Main body
diff() cuboid([l, w, h], rounding=r, edges=[LEFT + FWD, LEFT + BACK, RIGHT + FWD, RIGHT + BACK]) {
    tag("body") attach(TOP, TOP, align=LEFT + BACK)
        cuboid([add_l, add_w, glasses_h - h], rounding=r, edges=[RIGHT + BACK]);

    for (i = [1:1:glasses_cols]) {
      move([i * dist + glasses_l * (i - 1), glasses_move_y, glasses_h - h + f_h])
        attach(TOP, BOTTOM, inside=true, align=LEFT)
          ycopies(spacing=glasses_w + dist, n=glasses_rows) prismoid(
              size1=[glasses_l, glasses_w],
              size2=[glasses_l, glasses_w],
              h=glasses_h,
              rounding=glasses_r,
            );
    }

    move([w_t, w_t, f_h + 0.02]) attach(TOP, BOTTOM, inside=true, align=LEFT + FWD)
        cuboid([add_l - w_t * 2, w - add_w - w_t, h], rounding=r - w_t, edges=[RIGHT + FWD]);

    move([-w_t, w_t, 0.01]) attach(TOP, TOP, align=RIGHT + FWD, inside=true)
        cuboid([l - add_l - w_t, slot_w - w_t, h - f_h], rounding=r - w_t, edges=[RIGHT + FWD]);

    move([-17 - car_key_l_1 / 2, slot_w + 5, 0.01]) // 15 + car_key_w / 2
      attach(TOP, BOTTOM, inside=true, align=RIGHT + FWD)
        xcopies(spacing=car_key_l_1 + key_dist, n=2) prismoid(
            size1=[car_key_l_1, car_key_w],
            size2=[car_key_l_2, car_key_w],
            h=car_key_h,
            rounding=4,
          );

    move([-l + add_l + w_t + 4, 34, -15 + 0.02]) attach(TOP, TOP, inside=true, align=RIGHT)
        cyl(d=eufy_d, h=eufy_d_l) {
          attach(TOP, TOP) cuboid([eufy_w, eufy_l, h - eufy_d_l]);
        }

    tag("remove") move([add_l / 2, -dt_w / 2, h / 2]) attach(BACK) xrot(-90)
            dovetail("female", slide=dt_w, width=dt_l, height=dt_h, chamfer=1);
  }

// Key hooks
move([add_l / 2, (w - panel_w) / 2, (panel_h + h) / 2])
  diff() cuboid(
      [panel_l, panel_w, panel_h],
      rounding=r,
      edges=[RIGHT + BACK]
    ) {
      edge_profile([TOP + RIGHT, TOP + LEFT], excess=10, convexity=20) {
        mask2d_roundover(h=r, mask_angle=$edge_angle);
      }

      fwd(0.01) attach(FWD, BOTTOM, inside=true) diff(remove="delete2") cuboid(
              [panel_l - panel_b * 2, panel_h - panel_b * 2, panel_w - panel_wt],
              rounding=r - panel_b,
              edges=[LEFT + BACK, RIGHT + BACK]
            ) {
              tag("delete2") edge_profile([TOP + RIGHT, TOP + LEFT], excess=10, convexity=20) {
                  mask2d_roundover(h=r, mask_angle=$edge_angle);
                }
            }

      tag("keep") attach(FRONT, TOP, inside=true) cuboid([panel_b, panel_h, panel_w]);

      for (i = [1, -1]) {
        tag("keep") move([i * panel_l / 4, panel_w / 2 - panel_wt, 60])
            yrot(-90) xrot(90) hook();
        // attach(FWD, TOP)
        // cyl(h=30, d1=12, d2=8, anchor=BOTTOM + FRONT, rounding1=4);
      }

      back((panel_w - dt_w) / 2)
        attach(BOTTOM) dovetail("male", slide=dt_w, width=dt_l, height=dt_h, chamfer=1);
    }

module hook(
  hook_h = 26,
  hook_d = 8,
  hook_base_a = 40,
  hook_base_bottom_d = 24,
) {
  hook_base_top_d = hook_d / cos(hook_base_a);
  hook_base_h = ( (hook_base_bottom_d - hook_base_top_d) / 2) / tan(hook_base_a);
  hook_cf = hook_h * cos(hook_base_a);
  hook_cs = hook_d * sin(hook_base_a);
  hook_dz = (hook_cf - hook_cs) / 2;
  hook_xl = hook_d * cos(hook_base_a);
  hook_xr = hook_h * sin(hook_base_a);
  hook_dx = (hook_xl + hook_xr) / 2;
  diff_size = [hook_dx * 2, hook_d, hook_cs];

  up(hook_base_h / 2)
    union() {
      yscale(cos(hook_base_a)) cyl(l=hook_base_h, d1=hook_base_bottom_d, d2=hook_base_top_d);

      move([-hook_base_top_d / 2, 0, hook_base_h / 2])
        difference() {
          move([hook_dx, 0, hook_dz])
            yrot(hook_base_a) cyl(l=hook_h, d=hook_d, rounding2=hook_d / 2);
          move([diff_size[0] / 2, 0, -diff_size[2] / 2]) cuboid(diff_size);
        }
    }
}

// cuboid([dt_l - 0.2, dt_w - 0.2, 0.4]);
// fwd(10) cuboid([dt_l - 0.2, 1.8, 0.4]);

// fwd(20) union() {
//   cuboid([dt_l - 0.2, dt_w - 0.2, 0.6]);
//   fwd(10) cuboid([dt_l - 0.2, 1.8, 0.6]);
// }
