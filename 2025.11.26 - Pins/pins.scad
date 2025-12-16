// Pins for a printed book with drilled holes

include <BOSL2/std.scad>
include <BOSL2/threading.scad>
include <BOSL2/screw_drive.scad>

$fa = 0.5;
$fs = 0.5;

d = 6.8;
nut_d = d - 2;
rod_h = 4.8;
floor_h = 0.6;
cap_d = 10;

pitch = 0.8;

slop = 0.1;

// Bolt
diff()
  threaded_nut(
    nutwidth=d + 8,
    id=nut_d,
    h=rod_h,
    pitch=pitch,
    $slop=slop,
  ) {
    tag("remove") tube(h=rod_h + 2, id=d, od=d + 20);

    tag("keep") attach(BOTTOM, TOP) cyl(d=cap_d, h=floor_h);
  }

// Rod
left(cap_d + 4)
  diff()
    threaded_rod(
      d=nut_d,
      l=rod_h - 0.4,
      pitch=pitch
    ) {
      tag("base") attach(TOP, TOP) cyl(d=cap_d, h=floor_h);

      attach(TOP, TOP, inside=true) down(floor_h + 1.4)
          phillips_mask(size="#1");
    }
