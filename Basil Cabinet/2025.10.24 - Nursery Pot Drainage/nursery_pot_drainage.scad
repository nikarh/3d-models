include <BOSL2/std.scad>

bot_side = 70;
top_side = 80;
h = 30;
bot_r = 8;
side_r = 10;

thickness = 1.6;
additional_thick = 1.2;

difference() {
  rounded_prism(
    square(bot_side, center=true),
    square(top_side, center=true),
    height=h,
    joint_top=3,
    joint_bot=bot_r,
    joint_sides=side_r,
    k=0.4,
    k_top=0.1
  );
  up(thickness) rounded_prism(
      square(bot_side - thickness, center=true),
      square(top_side - thickness, center=true),
      height=h,
      joint_top=-6,
      joint_bot=bot_r * additional_thick,
      joint_sides=side_r,
      k=0.4,
      k_top=0.5
    );
}
