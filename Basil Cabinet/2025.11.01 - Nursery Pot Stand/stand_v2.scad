include <BOSL2/std.scad>
include <BOSL2/screws.scad>

// TODO: too thin, also needs fins for support

$fa = 1;
$fs = 0.5;

l = 270;
w = 90;
rd = 6;
h = 3;
b = 4; // border

r = 6;

hole_w = 3;
hole_d = 1;
hole_l = w - b * 2;
hole_c = (l / hole_w) - 2;

nut_h = 8;
nut_d = 6;
nut_pitch = 1.25;
nut_head = nut_d + 10;
slop = 0.2;

module leg_nut() {
  diff()
    threaded_nut(
      nutwidth=nut_d + 6, id=nut_d,
      h=nut_h, pitch=nut_pitch,
      $slop=slop
    ) {
      // Cap
      align(TOP, CENTER)
        cyl(h=h, d=nut_head);

      tag("remove") tube(
          h=nut_h,
          od=10 + nut_d + 4, id=nut_d + 4
        );
    }
}

// Base
linear_extrude(height=h) union() {
    difference() {
      rect([l, w], rounding=r);
      rect([l - b * 2, w - b * 2], rounding=r - b);
    }

    intersection() {
      rect([l - b * 2, w - b * 2], rounding=r - b);
      union() {
        zrot(45) xcopies(hole_w + hole_d, l=l * 2)
            rect([hole_d, l * 2]);
        zrot(45) ycopies(hole_w + hole_d, l=l * 2)
            rect([l * 2, 0.8]);
      }
    }
  }

// Fins
fin_h = 5;
down(fin_h) rect_tube(fin_h, size=[l, w], isize=[l - b, w - b], rounding=r);
down(-h + (fin_h + h) / 2) difference() {
    cuboid([l, b, fin_h + h]);
    cyl(
      h=fin_h + h,
      d=nut_d + 4
    );
  }

d = move([l, w] / 2, -([1, 1] * (nut_head / 2)));

down(nut_h / 2)for (
  i = [
    [1, 1],
    [-1, 1],
    [-1, -1],
    [1, -1],
    [0, 0],
    //[0, 1],
    //[0, -1],
  ]
)
  move([d[0] * i[0], d[1] * i[1]]) leg_nut();

for (i = [[100, 10], [50, 30], [30, 60]]) {
  rod_h=i[0];
  rod_dl=i[1];

  fwd(rod_dl) left(l) diff() cyl(h=rod_h, d=nut_d + 2) {
        align(TOP, CENTER) threaded_rod(
            d=nut_d,
            l=nut_h - 1,
            pitch=nut_pitch,
            $slop=slop
          );
        // Bottom
        tag("base") align(BOTTOM, inside=true) down(0.1)
              cyl(h=3, d=nut_head);
        attach(BOTTOM, TOP, inside=true) down(0.1)
            phillips_mask(size="#2");
      }
}
