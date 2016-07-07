function v = rgbaToFloat(rgba)
v = dot(rgba, [1.0, 1/255.0, 1/65025.0, 1/160581375.0]);
end
