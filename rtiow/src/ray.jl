export ray, origin, direction, at

mutable struct ray
    orig::point3
    dir::vec3
end

function origin(r::ray)
    r.orig
end

function direction(r::ray)
    r.dir
end

function at(r::ray, t::Float64)
    r.orig + t * r.dir
end