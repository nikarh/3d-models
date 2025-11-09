include <BOSL2/std.scad>
include <BOSL2/walls.scad>

$fa = 0.5;
$fs = 0.5;

l = 150;
w = 40;
h = 55;

r = 0; // radius
t = 0.8; // wall thickness

s = 1.2; // side of a rect to remove

wall_l = l - r * 2 - s;

cuboid([l, w, t]) {
  align(BOTTOM, FRONT, inside=true) hex_panel([wall_l, h, t], strut=t, spacing=t + s, orient=FRONT) {

      fwd(3) attach(TOP, FRONT, inside=true) color("red")
          hex_panel([l, w, t], strut=t, spacing=t + s, orient=FRONT);
      back(3) attach(TOP, FRONT, inside=true) color("red")
          hex_panel([l, w, t], strut=t, spacing=t + s, orient=FRONT);

      attach(BACK, TOP, align=TOP, inside=true)
        hex_panel([l, w, t], strut=t, spacing=t + s, orient=FRONT);
    }

  attach(LEFT, TOP, align=BOTTOM, inside=true)
    hex_panel([w, h, t], strut=t, spacing=t + s, orient=FRONT);
  attach(RIGHT, TOP, align=BOTTOM, inside=true)
    hex_panel([w, h, t], strut=t, spacing=t + s, orient=FRONT);
}

// difference() {
//   // Outer body
//   linear_extrude(height=h, center=true)
//     polygon(round_corners(rect([l, w]), r=[r, r, 0, 0]));

//   // Remove insides
//   linear_extrude(height=h - t * 2, center=true)
//     polygon(round_corners(rect([l - t * 2, w - t * 2]), r=[1, 1, 0, 0] * max(0, (r - t))));

//   down(t) linear_extrude(height=h, center=true)
//       rect([wall_l, w + 2]);

//   // xn = floor((l - r * 2 - s * 2) / (s * 3));
//   // zcopies(n=10, spacing=s * 6) xcopies(n=xn, spacing=s * 3)
//   //     xrot(90) regular_prism(n=4, h=w + 2, r=s);
// }

// //cuboid([l, w, h]);

// fwd((w - t) / 2)
//   hex_panel([wall_l, h, t], strut=t, spacing=t + s, orient=FRONT);

// down ((h-t)/2)hex_panel([wall_l, w, t], strut=t, spacing=t + s, orient=TOP);
