include <BOSL2/std.scad>

$fs = 0.5;
$fa = 0.5;

bot_side = 70;
top_side = 80;
h = 34;
bot_r = 0;
side_r = 10;

// Anf
angle = atan2(h, (top_side - bot_side) / 2);

thickness = 1.6;
additional_thick = 1.2;

lip_scale = 1.7;
lip_d1 = 25;
lip_d2 = 5;
lip_a = 90 - 30; // lip angle
// lip_h = (lip_d1 * lip_scale - lip_d2 * lip_scale) / 2;
lip_h = tan(lip_a) * (lip_d1 * lip_scale - lip_d2 * lip_scale) / 2;
lip_offset = lip_h / tan(angle);

echo(lip_offset);

difference() {
  union() {
    rounded_prism(
      square(bot_side, center=true),
      square(top_side, center=true),
      height=h,
      joint_top=3,
      joint_bot=bot_r,
      joint_sides=side_r,
      k=0.4,
      k_top=0,1
    );
    fwd(top_side / 2 - lip_d2 - lip_offset) up((h - lip_h) / 2)
        yscale(lip_scale) zcyl(h=lip_h, d1=lip_d2, d2=lip_d1);
  }
  up(thickness) union() {
      rounded_prism(
        square(bot_side - thickness, center=true),
        square(top_side - thickness, center=true),
        height=h,
        joint_top=-6,
        joint_bot=2 * additional_thick,
        joint_sides=side_r,
        k=0.4,
        k_top=0
      );
      fwd(top_side / 2 - lip_d2 - lip_offset) up((h - lip_h) / 2 - thickness)
          yscale(lip_scale) zcyl(h=lip_h, d1=lip_d2 - thickness, d2=lip_d1 - thickness);
    }
}
