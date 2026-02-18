include <BOSL2/std.scad>

h = 0.4;
w = 0.43;
d = 0.5;

l = 50;

union() {
  ycopies(n=ceil(l / (w + d)), spacing=d + w) cuboid([l, w, h]);
  xcopies(n=ceil(l / (w + d)), spacing=d + w) cuboid([w, l, h]);
}
