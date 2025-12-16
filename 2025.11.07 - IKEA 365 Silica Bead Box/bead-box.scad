include <BOSL2/std.scad>
include <BOSL2/walls.scad>

$fa = 0.5;
$fs = 0.5;

l = 150;
w = 35;
h = 55;

t = 1.2; // wall thickness
r=2;
s = 1.2; // side of a rect to remove

strut = 0.8;
spacing = 2;

wall_l = l - r * 2 - s;

lid_tolerance = 0.4;

// diff() cuboid([l, w, h]) {
//     #attach(BACK, FWD, inside=true)
//       cuboid([l - t * 2, w - t * 2, h - t]);
//   }

// // Inner walls
// up(4) cuboid([l, w, t]);
// down(4) cuboid([l, w, t]);

down(h/2 -t/2) cuboid([l, w, t]) {
  align(BOTTOM, FRONT, inside=true) hex_panel([wall_l, h, t], strut=strut, spacing=spacing, orient=FRONT) {

      fwd(3) attach(TOP, FRONT, inside=true) color("red")
            hex_panel([l, w, t], strut=strut, spacing=spacing, orient=FRONT);
      back(3) attach(TOP, FRONT, inside=true) color("red")
            hex_panel([l, w, t], strut=strut, spacing=spacing, orient=FRONT);

      attach(BACK, TOP, align=TOP, inside=true)
        hex_panel([l, w, t], strut=strut, spacing=spacing, orient=FRONT);
    }

  attach(LEFT, TOP, align=BOTTOM, inside=true)
    hex_panel([w, h, t], strut=strut, spacing=spacing, orient=FRONT);
  attach(RIGHT, TOP, align=BOTTOM, inside=true)
    hex_panel([w, h, t], strut=strut, spacing=spacing, orient=FRONT);
}

module tri45_prism(side, h, orient) {
  prismoid([h, side], [h, 0], h=side / 2, orient=orient);
}

s_h = 2;
t_s = 3;

move([0, w / 2 + s_h, 0])
  union() {
    diff() cuboid([l, s_h * 2, h]) {
        tag("remove") right(t) cuboid([l, s_h * 2 + 1, h - t * 2]);
      }

    up(h / 2 - t) tri45_prism(side=t_s, h=l, orient=BOTTOM);
    down(h / 2 - t) tri45_prism(side=t_s, h=l, orient=TOP);
    left(l / 2 - t) tri45_prism(side=t_s, h=h, orient=RIGHT);
  }

back(w) {
  diff() cuboid([l - lid_tolerance, s_h * 2, h - t * 2 - lid_tolerance]) {
      attach(TOP, BOTTOM, inside=true)
        tri45_prism(side=t_s, h=l);
      attach(BOTTOM, BOTTOM, inside=true)
        tri45_prism(side=t_s, h=l);
      attach(LEFT, BOTTOM, spin=90, inside=true)
        tri45_prism(side=t_s, h=h);
    }
}
