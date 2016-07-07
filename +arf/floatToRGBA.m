function enc = floatToRGBA(v)
enc = frac([1.0, 255.0, 65025.0, 160581375.0] * v);
enc = enc - enc([2 3 4 4]) .* [1.0/255.0, 1.0/255.0, 1.0/255.0, 0.0];
end

function y = frac(x)
y = x - floor(x);
end
