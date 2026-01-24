include <BOSL2/std.scad>

$fa = $preview ? 3 : 1;
$fs = $preview ? 3 : 0.25;
eps = 0.01;

// MOTU m2 main box without legs, [l, w, h, h+legs, r]
motu = [190.2, 108, 44.2, 48, 12];
// MOTU m2 legs only, [l, w, h, retraction]
motu_bot = [146, 96.2, motu[3] - motu[2], 7.6];
motu_leg = [19, 96, motu_bot[2]];
// Amplifier box without front panel, [l, w, h, r]
amp = [88 + 0.2, 158 - 6, 38, 4.2];
/// Amplifier front panel, [l, w, h, r]
amp_panel = [92 + 0.2, 6, 42, 7];
// FIIO x5 inside sleeve, [l, w, h, r]
fiio = [70, 116.4, 18.4];

ww = 2; // Wall width
ww_top = 2; // Additional top wall between motu and amp

// Edges in Y projection
re = [LEFT + TOP, LEFT + BOTTOM, RIGHT + TOP, RIGHT + BOTTOM];

// Sensible var name
total_w = amp[1];

// MOTU m2 box

motu_h = motu[3];
motu_d = motu[1]; //fiio[1];
// motu_h = motu[2]; // without legs
diff() cuboid(
    [motu[0] + ww * 2, total_w, motu_h + ww + ww_top],
    rounding=motu[4] + ww, edges=[RIGHT + BOTTOM]
  ) {
    // Remove MOTU m2 from the box
    down(ww_top) attach(TOP, TOP, inside=true)
        cuboid([motu[0], total_w + eps, motu[2]], rounding=motu[4], edges=re);
    // Remove rect for legs
    *back(motu_bot[3]) up(ww) attach(BOTTOM, BOTTOM, align=FRONT, inside=true)
          cuboid([motu_bot[0], total_w, motu_bot[2] + eps]);

    // Remove honest slots for legs
    left((motu_bot[0] - motu_leg[0]) / 2) up(ww + eps) down(eps) back(motu_bot[3]) attach(BOTTOM, BOTTOM, align=FRONT, inside=true)
              cuboid([motu_leg[0], motu_leg[1] + total_w, motu_leg[2] + eps], rounding=motu_leg[0] / 2, edges=[BACK + LEFT, BACK + RIGHT, FRONT + LEFT, FRONT + RIGHT]);
    right((motu_bot[0] - motu_leg[0]) / 2) up(ww + eps) down(eps) back(motu_bot[3]) attach(BOTTOM, BOTTOM, align=FRONT, inside=true)
              cuboid([motu_leg[0], motu_leg[1] + total_w, motu_leg[2] + eps], rounding=motu_leg[0] / 2, edges=[BACK + LEFT, BACK + RIGHT, FRONT + LEFT, FRONT + RIGHT]);

    // Chop off a rect on the right to make shutdown button accessible
    move([eps, eps, eps - ww]) attach(TOP, BOTTOM, align=RIGHT + BACK, inside=true) cuboid(
          [
            motu[0] - amp_panel[0] + eps,
            amp[1] - motu_d + eps,
            motu[3] + ww_top + eps * 2,
          ],
        );

    // Add a fillet and rounding in a place where choped off block creates 90 angle at the bottom
    fr = (amp[1] - motu_d) / 2;
    //bottom_h = ww; // without legs
    bottom_h = motu_bot[2] + ww;
    tag("keep") move([-(motu[0] - amp_panel[0]) + fr, -(amp[1] - motu_d), bottom_h])
        attach(BOTTOM, BOTTOM, align=RIGHT + BACK)
          fillet(l=bottom_h, r=fr, spin=90);
    tag("remove") move([-(motu[0] - amp_panel[0]) - fr, 0, bottom_h + eps])
        attach(BOTTOM, BOTTOM, align=RIGHT + BACK)
          fillet(l=bottom_h + eps * 2, r=fr, spin=-90);

    // AMPLIFIER
    attach(TOP, BOTTOM, align=LEFT) diff("d2") cuboid(
          [amp_panel[0] + ww * 2, amp[1], amp_panel[2] + ww * 2],
          rounding=amp_panel[3] + ww, edges=[LEFT + TOP, RIGHT + TOP]
        ) {
          // Remove front panel
          tag("d2") fwd(eps) attach(FWD, FWD, inside=true)
                cuboid([amp_panel[0], amp_panel[1] + eps, amp_panel[2]], rounding=amp_panel[3], edges=re);
          // Remove amp itself
          tag("d2") back(eps) attach(FWD, FWD, inside=true)
                cuboid([amp[0], amp[1] + eps, amp[2]], rounding=amp[3], edges=re);
        }

    // FIIO
    fp_w = motu[0] - amp_panel[0];
    fiio_c = 1; // ceiling
    down(ww) attach(TOP, BOTTOM, align=RIGHT + FWD) diff("d2")
          cuboid([fp_w, total_w, fiio[2] + ww + fiio_c]) {
            fiio_panel_add = 2;
            fiio_panel_add_top = 2;
            fiio_panel_w = 0.6;
            fiio_panel_r = 3;

            // Remove FIIO body
            tag("d2") up((ww - fiio_c) / 2) back(fiio_panel_w) left(ww - fiio_panel_add / 2) attach(FWD, FWD, align=RIGHT, inside=true)
                      cuboid(
                        [fiio[0], total_w - fiio_panel_w + eps, fiio[2]],
                        rounding=2, edges=re
                      );

            // Cutout for controls
            tag("d2") up((ww - fiio_c) / 2) move([-ww, -eps, -fiio_panel_add_top / 2]) attach(FWD, FWD, align=RIGHT, inside=true)
                    cuboid(
                      [fiio[0] - fiio_panel_add, fiio_panel_w + eps * 2, fiio[2] - fiio_panel_add - fiio_panel_add_top],
                      rounding=fiio_panel_r, edges=re
                    );

            // Cutout for volume control on the right side
            tag("d2") up((ww - fiio_c) / 2) back(12 + fiio_panel_w) right(1) attach(RIGHT, FWD, inside=true, align=FWD)
                      cuboid([30, 12, 12], rounding=5, edges=re);

            // A box for some wires and stuff
            box = [fp_w, total_w, amp_panel[2] - fiio[2] - amp_panel[3] + ww - fiio_c];
            down(fiio_c) attach(TOP, BOTTOM, align=RIGHT + FWD) diff("d3") cuboid(box) {
                    tag("d3") left(ww / 2) up(0 + eps) attach(TOP, TOP, inside=true)
                            cuboid(box - [ww, ww * 2, fiio_c - eps]);
                  }

            // Cutout a box in a box between the fiio and the amp
            add_cut = fp_w - fiio[0] - fiio_panel_add / 2 - 1;
            tag("d2") back(ww) up(ww) attach(LEFT, FWD, inside=true, align=BOTTOM + FRONT)
                    cuboid(
                      [
                        total_w - ww * 2,
                        add_cut,
                        amp_panel[2] - fiio[2],
                      ]
                    );

            // Remove additional fillet to smooth out the edges along Y axis on the upper part of the hole
            tag("d2") move([add_cut, 0, 0]) attach(TOP, FWD, align=LEFT, inside=true)
                  fillet(l=total_w - ww * 2, r=fiio_panel_r, orient=LEFT);
          }

    // Channel for wires
    wire_d = 6.2;
    channel_d = 5.4;
    channel_w = 16;
    channel_h = wire_d * 4;
    attach(LEFT, RIGHT, align=BOTTOM) diff("d2") cuboid(
          [channel_w, total_w, channel_h],
          rounding=wire_d,
          edges=[LEFT + TOP, LEFT + BOTTOM]
        ) {

          // Cutout to insert XLR wires
          tag("d2") move([ww / 2, -eps, eps]) attach(FRONT, BACK, align=TOP, inside=true)
                cuboid(
                  [channel_d, total_w + eps * 2, channel_h - wire_d + eps],
                  rounding=channel_d / 2, edges=[BOTTOM + RIGHT, BOTTOM + LEFT]
                );

          // Remove syllinders for the XLR wires
          tag("d2") move([ww / 2, -eps, -wire_d]) attach(FRONT, BACK, align=TOP, inside=true)
                ycyl(l=total_w + eps * 2, d=wire_d);
          tag("d2") move([ww / 2, -eps, -wire_d * 2]) attach(FRONT, BACK, align=TOP, inside=true)
                ycyl(l=total_w + eps * 2, d=wire_d);
        }
  }

// Dont forget to add a holder for cables to the left of the motu
