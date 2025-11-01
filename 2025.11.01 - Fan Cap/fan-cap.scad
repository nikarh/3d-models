include <BOSL2/std.scad>

fan_side = 120; // Side of the CPU fan
fan_h = 25.2; // Height of the fan
w = 2; // Should not be transparent

edge_s = 4; // Edge side

osize = fan_side + edge_s * 2; // Outer size

// Ring around fan
*rect_tube(h=fan_h, size=osize, isize=fan_side)
  attach(BOTTOM, TOP)
    // Edge
    rect_tube(h=1, size=osize + edge_s * 2, isize=fan_side);

function get_cap_path(offset = 0) =
  round_corners(
    [
      [offset, 0],
      [offset, fan_h + 10 - offset],
      [fan_side - offset, fan_h - offset],
      [fan_side - offset, 0],
    ], r=[0, 20, 15, 0]
  );

r_r = 10; // Radius to round over

function align_across_path(shapes, path, displace = 0) =
  let (
    n = len(shapes),
    points = resample_path(path, n, closed=false),
    tangents = path_tangents(points),
    normals = path_normals(points, tangents),
  ) [
      // Translate shape by points[i].
      // Keep in mind we cant use translate function as it 
      // is pure matrix math
      for (i = [0:n - 1]) let (
        p = points[i],
        t = tangents[i],
        a = atan2(t[0], t[1]),
        s = shapes[i],
        n = normals[i],
        h = i/n,
      ) move(
        p + n * (displace * ease_hyper(0)),
        zrot(
          -a,
          xrot(90, path3d(s))
        )
      ),
  ];

function ease_hyper(i, S = 0.4, E = 0.6) =
  i < S ? (i / S) ^ 1 // ease in
  : i > E ? (1 - (i - E) / (1 - E)) ^ 1 // ease out
  : // ease out
  1;

seg = 50;
roundovers = [
  for (i = [0:seg]) mask2d_roundover(
    excess=30,
    r=0.0001 + r_r * ease_hyper(i / seg)
  ),
];

difference() {
  linear_extrude(height=fan_side)
    polygon(get_cap_path());

  up(fan_side/2) mirror_copy([0, 0, -1], fan_side/2) skin(
    align_across_path(
      roundovers,
      path=get_cap_path(0),
      0.1
    ), slices=0
  );

  /*linear_extrude(height=fan_side)
    polygon(get_cap_path(2));*/
}

// for (
//   n = align_across_path(
//     roundovers,
//     path=get_cap_path(0)
//   )
// ) {
//   stroke(n);
// }
