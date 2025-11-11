include <BOSL2/std.scad>

// A cap to light proof IKEA BESTA from the right side

$fa = 0.5;
$fs = 0.5;

l = 40; // part length
zd = 10; // tube diameter from bottom to top
yr = 5; // tube raidus from front to back

t = 3; // wall thickness
db = 1; // mm from floor
w = zd + t + db; // part height
d = yr + t; // main cuboid depth

// holes width
h_w = 13;
// Holes length after the main part. SHOULD BE TOTAL INSTEAD AND INCLUDE
real_h_l = 18;
h_l = real_h_l - d;
// Holes height
h_h = 1.8;
// Excess for rounding
round_e = h_h + 1.4;

difference() {
  diff() {
    // Body
    cuboid([l, d, w]);
    #tag("remove") move([-l / 2 + 6.4 +2, 8 - 3, 0]) rot([-90, 90, 0]) {
          down(5) xrot(-90) yrot(-90)
                teardrop(d=3.4, h=16, cap_h=1.6, ang=45);

          down(3) xrot(-90) yrot(-90)
                teardrop(d1=6.4, d2=3.4, h=4, cap_h=3.2, ang=45);
        }
  }
  fwd(d / 2)
    // And now remove the cyllinder
    right(t) down(w / 2 - zd / 2 - db)
        yscale((yr * 2) / zd) xcyl(d=zd, h=l - t + 1);
}
