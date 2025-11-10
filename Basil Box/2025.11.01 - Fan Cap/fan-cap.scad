include <BOSL2/std.scad>
include <BOSL2/walls.scad>

// TODO: this prints like shit,
// roundover is an overhang >45 degrees and must be turned into a chamfer
// or a teardrop

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

difference() {
  union() {

    // Ring around fan
    diff() rect_tube(h=fan_h, size=osize, isize=fan_side) {
        // Add bottom chamfered edge
        tag("base") right(cap_ext / 2) attach(BOTTOM, TOP, inside=true)
              rect_tube(
                h=3,
                size1=[osize + cap_ext, osize],
                size2=[osize + cap_ext + edge_s * 2, osize + edge_s * 2],
                isize=[fan_side + cap_ext, fan_side],
              );

        // Cut the wall
        attach(RIGHT, TOP, inside=true, shiftout=1) cube([fan_side, fan_h + 2, w + 2]);
        // And add partial walls that don't need supports
        up(inner_w_h) attach(RIGHT, LEFT, align=BOTTOM, inside=true) tag("keep") sparse_wall(
                l=fan_side + w * 2,
                h=fan_h + cap_h + w * 2 - inner_w_h,
                thick=w,
                strut=2,
              );
        // Add a wall above the support
        attach(RIGHT, LEFT, align=BOTTOM, inside=true) tag("keep") cuboid(
              [w, fan_side, inner_w_h]
            );
      }

    // Air chamber
    move([0, 0, fan_h + cap_h / 2 + w]) diff("remove")
        cube([fan_side + w * 2, fan_side + w * 2, cap_h+w*2], center=true) {
          edge_profile(LEFT + TOP)
            mask2d_teardrop(r=10, angle=40);

          down(w) diff("rem2", $tag="remove") cube([fan_side, fan_side, cap_h], center=true) {
                tag("rem2") edge_profile(LEFT + TOP)
                    mask2d_teardrop(r=10, angle=40);
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
