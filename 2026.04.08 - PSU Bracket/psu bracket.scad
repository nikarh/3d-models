include <BOSL2/std.scad>

$fa = $preview ? 1 : 1;
$fs = $preview ? 1 : 0.25;

hd = 3;
ho = 5.2;

h = 98.2;
w = 41.2;
t = 3;

br = 3;

e = 0.01;

cutout = [20.8, 15.8];
// Cutout height, t + support height + tolerance
ch = 10;

*diff() cuboid(
    [w, h, t],
    edges=[RIGHT + FRONT, LEFT + BACK, RIGHT + BACK],
    rounding=br
  ) {

    // Support
    //attach(TOP) xcopies(spacing=5, l=w - 5)
    //    cuboid([1, h - 5, 2]);

    fwd(ho - hd) align(BACK, inside=true)
        cyl(d=hd, h=ch);
    back(ho - hd) align(FWD, inside=true)
        cyl(d=hd, h=ch);

    tag("remove") back(25.8) chain_hull() {
          d1 = 10.6;
          d2 = 10.4;
          tr = [5.8, 6];

          cyl(d=d1, h=ch);
          move([tr[0] * -1, tr[1]]) cyl(d=d2, h=ch);
          move(tr) cyl(d=d2, h=ch);
          cyl(d=d1, h=ch);
        }

    screw_d = 15.8 / 2 + 1 - 0.2;
    tag("remove") back(36 - screw_d) left(15) cyl(d=2.2, h=ch);
    tag("remove") back(36 - screw_d) right(15) cyl(d=2.2, h=ch);

    *back(29) cuboid([20.8, 15.8, 5]);
  }

t1 = 0.8;
hold_l = 180;
hold_w = 58;
hold_w = 56 + t + t1;
floor_w = 24.6;

floor_hole_l = 173 - 3.2;
floor_hole_dist = 10.4;
floor_hole_w = 4;
floor_hole_d = 3;

// Wall
move([-(w - t1) / 2, -(h - hold_w) / 2, (hold_l + t) / 2])
  rot([90, 0, 90])
    diff() cuboid([hold_w, hold_l, t1]) {
        // dw = 43.4;
        // dh = 122.2;
        // d = 3.2;

        // tag("remove") move([-dw / 2 + 1.8, -dh / 2 + 16]) {
        //     cyl(d=floor_hole_d, h=ch);
        //     move([dw, dh]) cyl(d=floor_hole_d, h=ch);
        //     move([0, dh]) cyl(d=floor_hole_d, h=ch);
        //     move([dw, 0]) cyl(d=floor_hole_d, h=ch);
        //   }
      }


move([floor_w + t1, 0, 0])move([-(w - t1) / 2, -(h - hold_w) / 2, (hold_l + t) / 2])
  rot([90, 0, 90]) cuboid([hold_w, hold_l, t1]);

// Floor
move([(floor_w - w) / 2 + t1, (t - h) / 2, (hold_l + t) / 2])
  rot([90, 0, 0])
    diff() color("red") cuboid([floor_w, hold_l, t]) {

        move([floor_hole_w - floor_w / 2, floor_hole_l - hold_l / 2 - t, 0]) {
          tag("remove")
            move([0, 0, 0]) cyl(d=floor_hole_d, h=ch);
          tag("remove")
            move([0, -floor_hole_dist, 0]) cyl(d=floor_hole_d, h=ch);

          tag("remove")
            move([0, 0, -ch/2 + t/2 - 0.8]) cyl(d=6.3, h=ch);
          tag("remove")
            move([0, -floor_hole_dist, -ch/2 + t/2 - 0.8]) cyl(d=6.3, h=ch);
        }
      }
;
