function ret = CartesianToDiamond(cart, radius)
%CARTESIANTODIAMOND
%   Converts cartesian coordinates to diamond coordinates
%
%   TODO: Cleanup code and comment

    poly = {[0, radius], [radius, 0], [0, -radius], [-radius, 0]};
    
    if ~IsInsidePolygon(poly, cart)
        if cart(1) == 0
            if cart(2) > 0
                cart(2) = radius;
            else
                cart(2) = -radius;
            end
        elseif cart(2) == 0
            if cart(1) > 0
                cart(1) = radius;
            else
                cart(1) = -radius;
            end
        else
            if cart(1) > 0 && cart(2) > 0
                cart = GetIntersection(cart, [0 0], [0 radius], [radius, 0]);
            elseif cart(1) > 0 && cart(2) < 0
                cart = GetIntersection(cart, [0 0], [0 -radius], [radius, 0]);
            elseif cart(1) < 0 && cart(2) < 0
                cart = GetIntersection(cart, [0 0], [0 -radius], [-radius, 0]);
            else
                cart = GetIntersection(cart, [0 0], [0 radius], [-radius, 0]);
            end
        end
    end
    
    left = [cart(1) - (2 * radius) cart(2) + (2 * radius)];
    leftIntersect = GetIntersection(cart, left, [0 radius], [-radius 0]);
    leftScale = (leftIntersect(2) - (radius / 2)) * 2;
    
   	right = [cart(1) + (2 * radius) cart(2) + (2 * radius)];
    rightIntersect = GetIntersection(cart, right, [0 radius], [radius 0]);
    rightScale = (rightIntersect(2) - (radius / 2)) * 2;
    
    ret = struct('left', leftScale, 'right', rightScale);
end