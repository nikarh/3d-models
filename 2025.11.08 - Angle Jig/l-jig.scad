include <BOSL2/std.scad>

l = 40; // overall size
t = 3; // wall thickness
h = 30; // height of the inner walls to hold 3rd plank

w = 16.2;
d = w + t;

module l_jig(l = l) {
  difference() {
    cube(l);
    move([t, t, t]) cube(l * 1.1);
  }
}

xdistribute(l + t) {
  // l jig
  l_jig(l);

  // t jig
  union() {
    l_jig(l);
    move([w + t, w + t, 0]) l_jig([l - w - t, l - w - t, h]);
  }
}
