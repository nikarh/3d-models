include <BOSL2/std.scad>

// A cap to light proof IKEA BESTA from the right side

$fa = 0.5;
$fs = 0.5;

l = 45; // part length
zd = 8; // tube diameter from bottom to top
yr = 3; // tube raidus from front to back

t = 3; // wall thickness
db = 1; // mm from floor
w = zd + t + db; // part height
d = yr + t; // main cuboid depth

// holes width
h_w = 13;
// Holes length after the main part. SHOULD BE TOTAL INSTEAD AND INCLUDE
real_h_l = 20;
h_l = real_h_l - d;
// Holes height
h_h = 1.8;
// Excess for rounding
round_e = h_h + 1.4;

difference() {
  union() {
    difference() {
      union() {
        // Body
        cuboid([l, d, w]);

        // Bottom Roundover
        back(d / 2) down(w / 2 - round_e) xrot(90) yrot(90)
                linear_extrude(height=l, center=true)
                  mask2d_roundover(r=zd, excess=round_e);

        // Bottom holder
        bhl = real_h_l - d - zd + 2;
        move([0, d / 2 + bhl / 2 + zd, -w / 2 + round_e / 2]) cuboid([l, bhl, round_e]);
      }

      // Cut out the hole for lock
      #left(h_w / 2 + 2) right((l - d) / 2) down(w / 2) fwd(d / 2 - real_h_l / 2 + 0.5)
              cuboid([h_w, real_h_l + 1, h_h * 2]);

      // Cut out hole for a screw
      back(d / 2 + zd) union() {
          down(5) xrot(-90) yrot(-90)
                teardrop(d=3.4, h=6, cap_h=1.6, ang=45);

          down(3) xrot(-90) yrot(-90)
                teardrop(d=5.6, h=4, cap_h=2.7, ang=45);
        }
    }

    // Support
    move([(l - d) / 2 - h_w / 2 - 2, h_l / 2, -w / 2 + 1])
      cuboid([h_w - 0.8, real_h_l - 1.8, 1.4]) {
        // Breakables
        attach(LEFT, TOP) xcopies(n=5, spacing=3) cuboid(0.4);
        attach(RIGHT, TOP) xcopies(n=5, spacing=3) cuboid(0.4);
      }
  }
  fwd(d / 2)
    // And now remove the cyllinder
    left(t) down(w / 2 - zd / 2 - db)
        yscale((yr * 2) / zd) xcyl(d=zd, h=l - t + 1);
}

// And add a cap WITH CHAMFER
move([-l/2 + d/2, 0, 0])rot([0, 90, -90]) wedge([w, d, d], center=true);
