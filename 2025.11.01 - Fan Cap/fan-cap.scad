include <BOSL2/std.scad>
include <BOSL2/walls.scad>

$fa = 1;
$fs = 0.5;

fan_side = 120.6; // Side of the CPU fan
fan_h = 25.2; // Height of the fan
w = 2; // Should not be transparent
edge_s = 3; // Edge side
osize = fan_side + w * 2; // Outer size

inner_w_h = 10;

cap_ext = 30; // Extension for exhaust
cap_h = 16;

wire_w = 4;
wire_h = 1;

function cap_path(offset = 0) =
  round_corners(
    [
      [offset - w, -w],
      [offset - w, cap_h - offset + w],
      [fan_side + w, cap_h - offset + w],
      [fan_side + w, -w],
    ], r=[0, cap_h, 0, 0]
  );

difference() {
  union() {

    // Ring around fan
    diff() rect_tube(h=fan_h, size=osize, isize=fan_side) {
        // Edge
        tag("base") right(cap_ext / 2) attach(BOTTOM, TOP, inside=true)
              rect_tube(
                h=3,
                size1=[
                  osize + cap_ext,
                  osize,
                ],
                size2=[
                  osize + cap_ext + edge_s * 2,
                  osize + edge_s * 2,
                ],
                isize=[
                  fan_side + cap_ext,
                  fan_side,
                ],
              );

        // Cut the wall
        attach(RIGHT, TOP, inside=true, shiftout=1) cube([fan_side, fan_h+2, w+2]);

        // And add partial walls that don't need supports

        up(inner_w_h) attach(RIGHT, LEFT, align=BOTTOM, inside=true) tag("keep") sparse_wall(
          l=fan_side + w*2,
          h=fan_h + cap_h + w*2-inner_w_h,
          thick=w,
          strut=2,
        );

        attach(RIGHT, LEFT, align=BOTTOM, inside=true) tag("keep") cuboid(
          [w, fan_side, inner_w_h]
        );

        // Cut out the wall
        // attach(RIGHT, TOP, inside=true, shiftout=1) cube([fan_side, fan_h+2, w+2]);
        // And replace it with a sparse wall
        // tag("keep")attach(RIGHT, LEFT, inside=true) sparse_wall(
        //   l=fan_side,
        //   h=fan_h,
        //   thick=2,
        //   strut=2,
        // );
      }

    // Air chamber
    move([-fan_side / 2, fan_side / 2 + w, fan_h + w]) xrot(90) difference() {
          linear_extrude(height=fan_side + w * 2)
            polygon(cap_path());

          up(w) difference() {
              linear_extrude(height=fan_side)
                polygon(cap_path(w));
            }
        }

    // Extension chamber
    right(cap_ext / 2 + osize / 2) up((fan_h + cap_h + w * 2) / 2)
        diff() cuboid([cap_ext, osize, fan_h + cap_h + w * 2]) {
            attach(LEFT, LEFT, shiftout=w, align=BOTTOM, inside=true)
              cuboid([cap_ext, fan_side, fan_h + cap_h + w * 2]);

            attach(RIGHT, LEFT, align=BOTTOM, shiftout=w, inside=true)
              cuboid([cap_ext, fan_side, fan_h + w]);
          }
  }

  #move([fan_side / 2 - 20, fan_side / 2, wire_h / 2]) cuboid([wire_w, 30, wire_h]);
}

// rect_tube(
//   h=w,
//   isize=fan_side,
//   size =osize
// );

// left(fan_side + 10) {
//   cuboid([osize, osize, w]);
// }