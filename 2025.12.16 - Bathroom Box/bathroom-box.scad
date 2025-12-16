include <BOSL2/std.scad>

$fs = 0.5;
$fa = 0.5;

h1 = 100;
h2 = 55;

ft = 1;
wt = 0.8;

r = 8;

function below(block) =
  [block[1][0], block[1][1] + block[2][1]];
function next_to(block) =
  [block[1][0] + block[2][0], block[1][1]];

b1_1 = [h1, [0, 0], [40, 45], [LEFT + BACK]];
b1_2 = [h2, below(b1_1), [40, 35]];
b1_3 = [h2, below(b1_2), [40, 40]];
b1_4 = [h2, below(b1_3), [40, 90], [LEFT + FRONT]];

b2_1 = [h1, next_to(b1_1), [85, 90]];
b2_2 = [h2, below(b2_1), [50, 40]];
b2_3 = [h2, next_to(b2_2), [35, 40]];
b2_4 = [h2, below(b2_2), [50, 45]];
b2_5 = [h2, next_to(b2_4), [35, 20]];
b2_6 = [h2, below(b2_4), [50, 35], [RIGHT + FRONT]];

b4_1 = [h1, next_to(b2_1), [90, 85], [RIGHT + BACK]];
b4_2 = [h2, below(b4_1), [45, 45]];
b4_3 = [h2, next_to(b4_2), [45, 45]];
b4_4 = [h2, below(b4_2), [45, 20]];
b4_5 = [h2, next_to(b4_4), [22.5, 20]];
b4_6 = [h2, next_to(b4_5), [22.5, 20], [RIGHT + FRONT]];

c1_1 = [h1, [0, 0], [65, 60], [LEFT + BACK, RIGHT + BACK]];
c1_2 = [h2, below(c1_1), [65, 50]];
c1_3 = [h2, below(c1_2), [40, 40], [LEFT + FRONT]];
c1_4 = [h2, next_to(c1_3), [25, 40], [RIGHT + FRONT]];

blocks1 = [
  b1_1,
  b1_2,
  b1_3,
  b1_4,
  b2_1,
  b2_2,
  b2_3,
  b2_4,
  b2_5,
  b2_6,
  b4_1,
  b4_2,
  b4_3,
  b4_4,
  b4_5,
  b4_6,
];

blocks2 = [
  c1_1,
  c1_2,
  c1_3,
  c1_4,
];

for (block = blocks1) {
  move([block[1][0], -block[1][1] - block[2][1]])
    diff()
      cuboid(
        [block[2][0] + wt, block[2][1] + wt, block[0]],
        anchor=FRONT + LEFT + BOT,
        rounding=is_def(block[3]) ? r : undef,
        edges=block[3],
      ) {
        up(ft) attach(TOP, TOP, inside=true)
            cuboid(
              [block[2][0] - wt, block[2][1] - wt, block[0]],
              rounding=is_def(block[3]) ? (r - wt / 2) : undef,
              edges=block[3],
            );
      }
}

left(100) union() {
  for (block = blocks2) {
    move([block[1][0], -block[1][1] - block[2][1]])
      diff()
        cuboid(
          [block[2][0] + wt, block[2][1] + wt, block[0]],
          anchor=FRONT + LEFT + BOT,
          rounding=is_def(block[3]) ? r : undef,
          edges=block[3],
        ) {
          up(ft) attach(TOP, TOP, inside=true)
              cuboid(
                [block[2][0] - wt, block[2][1] - wt, block[0]],
                rounding=is_def(block[3]) ? (r - wt / 2) : undef,
                edges=block[3],
              );
        }
  }
}
