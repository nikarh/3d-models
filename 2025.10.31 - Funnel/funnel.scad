include <BOSL2/std.scad>

$fs = 0.1;
$fa = 1;

//cube(1);

thickness = 1.4; // wall thickness
top_d = 90; // top diameter
top_d2 = top_d+2; // diameter of a second tube
top_edge_d = top_d2 + 6;
neck_d = 20; // diameter to fit a bottle neck
neck_h = 24; // height of the neck
h_t1 = 50; // height of the main section of the funnel
h_t2 = 3; // height of the second section of the funnel
h_t3 = 3; // height of the border of the funnel

tube(
  h=neck_h,
  od=neck_d,
  id=neck_d - thickness * 2
)
  align(TOP) tube(
      h=h_t1,
      od1=neck_d,
      id1=neck_d - thickness * 2,
      od2=top_d,
      id2=top_d - thickness * 2,
    )
      align(TOP) tube(
          h=h_t2,
          od1=top_d,
          id1=top_d - thickness * 2,
          od2=top_d2,
          id2=top_d2 - thickness * 2,
        )
          align(TOP) tube(
              h=h_t3,
              id=top_d2 - thickness * 2,
              od=top_edge_d,
            );

han_ww = 1.6; // Handle wall width
han_w = 10; // Handle width
han_h = 50; // Handle height
han_fin_h = 40; // Handle fin height
han_tip_w = 7; // Handle tip width
han_fin_w = 8;

// Make a handle
left(han_tip_w / 2) right(top_edge_d / 2) up(h_t1 + h_t2 + h_t3 + neck_h / 2) down(han_ww / 2) xrot(-90) union() {
            linear_extrude(height=han_w)
              stroke([[0, 0], [han_tip_w, 0], [han_tip_w, han_h]], width=han_ww, $fn=32);

            // attach a fin perpendicular to the handle
            fwd(han_ww/2) up((han_w - han_ww) / 2) left(han_fin_w - han_tip_w) linear_extrude(height=han_ww)
                  polygon(
                    points=[
                      [han_fin_w, 0],
                      [0, 0],
                      [0, h_t3],
                      [-(top_d2-top_d)/2, h_t3 + h_t2],
                      [0, han_fin_w],
                      [han_fin_w, han_fin_h],
                    ]
                  );
          }
