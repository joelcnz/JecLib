module jec.draw;

import jec.base;

void jecDrawDot(ref Image img, Point pos, Color colour) {
    if (pos.X >=0 && pos.X < img.getSize.x &&
        pos.Y >= 0 && pos.Y < img.getSize.y)
        img.setPixel(cast(int)pos.X, cast(int)pos.Y, colour);
}

/// fast draw modified for my purposes
/// See: http://www.brackeen.com/vga/source/bc31/lines.c.html
void jecDrawLine(ref Image img, Point pst, Point ped, Color cst, Color ced) {
    int i,dx,dy,sdx,sdy,dxabs,dyabs,x,y, px, py;
    int x1 = pst.Xi, x2 = ped.Xi,
        y1 = pst.Yi, y2 = ped.Yi;

    dx=x2-x1;      /* the horizontal distance of the line */
    dy=y2-y1;      /* the vertical distance of the line */
    dxabs=abs(dx);
    dyabs=abs(dy);
    sdx=sgn(dx);
    sdy=sgn(dy);
    x=dyabs>>1;
    y=dxabs>>1;
    px=x1;
    py=y1;

    Color colour;
    int clen;
    int[] nums = [ced.r - cst.r, ced.g - cst.g, ced.b - cst.b];

    import std.array;
    import std.algorithm;

    clen = nums.map!"abs(a)".array.sort!"a > b"[0];
    //trace!clen;
    float r,g,b, dr,dg,db;
    float[] flts = [ped.X - pst.X, ped.Y - pst.Y];
    float llen;
    llen = flts.map!"abs(a)".array.sort!"a > b"[0];
    dr = ((cast(float)ced.r - cst.r) / clen) * llen;
    dg = ((cast(float)ced.g - cst.g) / clen) * llen;
    db = ((cast(float)ced.b - cst.b) / clen) * llen;

    r = cst.r;
    g = cst.g;
    b = cst.b;

    //mixin(trace("r g b dr dg db clen".split));

    if (dxabs>=dyabs) /* the line is more horizontal than vertical */
    {
        for(i=0;i<dxabs;i++)
        {
        y+=dyabs;
        if (y>=dxabs)
        {
            y-=dxabs;
            py+=sdy;
        }
        px+=sdx;
        colour = cst; //Color(cast(ubyte)r, cast(ubyte)g, cast(ubyte)b);
        jecDrawDot(img, Point(px, py), colour);
        r += dr;
        g += dg;
        b += db;
        //trace!colour;
        }
    }
    else /* the line is more vertical than horizontal */
    {
        for(i=0;i<dyabs;i++)
        {
        x+=dxabs;
        if (x>=dyabs)
        {
            x-=dyabs;
            px+=sdx;
        }
        py+=sdy;
        colour = cst; //Color(cast(ubyte)r, cast(ubyte)g, cast(ubyte)b);
        jecDrawDot(img, Point(px, py), colour);
        r += dr;
        g += dg;
        b += db;
        //trace!colour;
        }
    }
}
