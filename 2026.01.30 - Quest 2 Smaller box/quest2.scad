include <BOSL2/std.scad>

$fa = $preview ? 6 : 1;
$fs = $preview ? 6 : 0.25;

c_l = 146;
c_d1 = 95;
c_d2 = 120;

module controllers() {
  right(10) up(2.5) scale([c_d2 / c_d1, 1, 1]) up(c_d1 / 2)
          ycyl(l=c_l, d=c_d1, rounding=12);
}

//move([16, 77, 20]) color("red") linear_extrude(height = 100) ring(r1=4,r2=10, angle=[180,270], n=32);

difference() {
  import("quest case bottom.stl");

  controllers();
  right(40) right(150) cuboid([300, 300, 300]);
}

difference() {
  union() {
  move([43, 0, 2])
      offset_sweep(
        rect([54, 190], rounding=[1, 0, 0, 1] * 14), h=30,
        bot=os_circle(r=10)
      );


    move([20, 0, 7])cuboid([60, 160, 10]);
  }

  // cuboid([40, 190, 30]);
  controllers();
}

left(70) difference() {
    import("quest case bottom.stl");
    right(110) left(150) cuboid([300, 300, 300]);
  }
