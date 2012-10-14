function light = filterLight(uLight)
    light = 0.6*uLight(1) + 0.3*uLight(2) + 0.1*uLight(1);
end