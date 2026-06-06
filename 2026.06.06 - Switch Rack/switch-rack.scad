include <BOSL2/std.scad>

main = [200, 40, 110];
base = [200, 60, 2];
cavity = [200 - 6, 20, 106];

opiz = [60, 24, 56];
swch = [117, 26, 80];
e = 0.05;

diff() cuboid(main) {
    tag("keep") attach(BOTTOM, TOP)
        cuboid(base, rounding=8, edges="Z");

    up(e) attach(TOP, TOP, inside=true)
        cuboid(cavity);

    right((main[1] - opiz[1]) / 2) up(e) attach(TOP, TOP, align=LEFT, inside=true) {
          cuboid(opiz);

          ycopies(n=2, spacing=opiz[1] + 1.5)
            left(opiz[0] / 2 - 1.5) xcopies(l=opiz[0] - 3, spacing=6) cuboid([3, 3, opiz[2]]);
        }
    ;

    left((main[1] - swch[1]) / 2) up(e) attach(TOP, TOP, align=RIGHT, inside=true) {
          cuboid(swch);

          ycopies(n=2, spacing=swch[1] + 1.5)
            right(swch[0] / 2 - 1.5) xcopies(l=swch[0] - 3, spacing=6) cuboid([3, 3, swch[2]]);
        }
    ;

    right(5) attach(RIGHT, TOP, align=BOTTOM, inside=true) cuboid(20);
  }
