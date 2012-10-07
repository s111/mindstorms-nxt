function intersection = GetIntersection(l1p1, l1p2, l2p1, l2p2)
%GETINTERSECTION
%   Finds the intersection of two lines
%
%   TODO: Cleanup code and comment

    if l1p2(1) < l1p1(1)
        temp = l1p1;
        l1p1 = l1p2;
        l1p2 = temp;
    end
    
    if l2p2(1) < l2p1(1)
        temp = l2p1;
        l2p1 = l2p2;
        l2p2 = temp;
    end
    
    slope1 = (l1p2(2) - l1p1(2))/(l1p2(1) - l1p1(1));
    slope2 = (l2p2(2) - l2p1(2))/(l2p2(1) - l2p1(1));
    
    intercept1 = -((slope1 * l1p1(1)) - l1p1(2));
    intercept2 = -((slope2 * l2p1(1)) - l2p1(2));

    intersection(1) = (intercept2 - intercept1)/(slope1 - slope2);
    intersection(2) = (slope1 * intersection(1)) + intercept1;
end