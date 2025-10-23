include <BOSL2/std.scad>
include <BOSL2/walls.scad>

$vpr = [65, 0, 145];
$vpt = [-120, 0, 40];
$vpd = 1300;

$fn=14;

width = 200;
depth = 120;
back_height = 80;
wall_height = 30;
fillet_r = 30;

// Wall Thickness
floor_wall = 2;
back_wall = 2;



b_radius = 5;


top_r = 4;
slope = 5;
back_h = depth * tan(slope);


module inlay() {
//up(15)yrot(90)
 #left(width + 40) hex_panel(
    rect([width - back_wall*2 - 0.8, depth - back_wall*2 - 0.8], rounding=b_radius * [1,1,0,0]),
    1.3, 15,
    frame = 3,
    h = 2);
}

module main_box() {

    module rounded_slope() {
        right_triangle([back_h, depth-back_wall])
            attach([1, -1, 0], CENTER, inside=true) zrot((90) * 1.5)
            tag("keep") mask2d_roundover(r=top_r, mask_angle = 90+slope, $fn=40);
    }

    // Rounded wedge
    diff() {
        left (-width/2)back(-depth /2 + back_wall) yrot(-90)
            linear_extrude(height=width) rounded_slope();
            
        // Bottom
        cuboid([width, depth, floor_wall]);
     
        // Roudning
        move([width/2, depth/2]) zrot(180)
            rounding_edge_mask(r=b_radius,l=back_height);
        move([-width/2, depth/2]) zrot(270)
            rounding_edge_mask(r=b_radius,l=back_height);
    }


    diff() rect_tube(size=[width, depth], wall=back_wall, h=wall_height,
        rounding=b_radius * [1, 1, 0, 0])
    {
        // Remove front wall
        up(1) attach(BACK, FRONT, inside = true, shiftout=1)
            cuboid([width - b_radius * 2, back_wall + 2, wall_height + 2]);

        // Back wall
        align(TOP, FRONT)
            cuboid([ width, back_wall, back_height - wall_height],
            rounding=b_radius,
            edges=[TOP+RIGHT, TOP+LEFT]
        );

        // Add fillets on top
        back(back_wall) align(TOP, [LEFT+FRONT, RIGHT+FRONT])
            fillet(l=back_wall, r=fillet_r, orient=LEFT, $fn=40);
    }

    // Wedges
    side_wedges = 4;
    wegde_adj = 15;
    right(width / 2 - back_wall) 
        ycopies(depth / side_wedges, side_wedges) rot([180, 0, -90]) down(wegde_adj) wedge([3, 2, 10]);
    left(width / 2 - back_wall) 
        ycopies(depth / side_wedges, side_wedges) rot([180, 0, 90]) down(wegde_adj) wedge([3, 2, 10]);

    back_wedges = round(width / (depth / side_wedges));
    fwd(depth / 2 - back_wall)
        xcopies(depth / 4, back_wedges) rot([180, 0, 180]) down(wegde_adj) wedge([3, 2, 10]);
}

main_box();
inlay();
