function write_color(x::vec3, samples_per_pixel::Int64)
    sqrt(x / samples_per_pixel).e
end
