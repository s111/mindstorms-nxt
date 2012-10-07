function ret = IsInsidePolygon(poly, test)
%ISINSIDEPOLYGON
%   Check to see if a point is within a polygon
%
%   TODO: Cleanup code and comment
    counter = 0;
    
    for corner = poly
        if corner{1} == test
            ret = false;
            return;
        end
    end
    
    p1 = poly(end);
    
    for k = 1:length(poly)
        p2 = poly(k);
        
        if test(2) > min(p1{1}(2), p2{1}(2)) && test(2) <= max(p1{1}(2), p2{1}(2)) && test(1) <= max(p1{1}(1), p2{1}(1)) && p1{1}(2) ~= p2{1}(2)
            xcross = (test(2) - p1{1}(2))*(p2{1}(1) - p1{1}(1))/(p2{1}(2) - p1{1}(2)) + p1{1}(1);
            
            if p1{1}(1) == p2{1}(1) || test(1) <= xcross
                counter = counter + 1;
            end
        end
        
        p1 = p2;
    end
    
    ret = mod(counter, 2) ~= 0;
end