
export sphere, hit

mutable struct sphere <: hittable
    center::point3
    radius::Float64
    mat::material
end

function hit(s::sphere, r::ray, t_min::Float64, t_max::Float64)
    oc = origin(r) - s.center
    a = length_squared(direction(r))
    half_b = dot(oc, direction(r))
    c = length_squared(oc) - s.radius * s.radius

    discriminant = half_b * half_b - a * c
    if discriminant < 0
        return (false, nothing)
    end
    sqrtd = sqrt(discriminant)

    # Find the nearest root that lies in the acceptable range.
    root = (-half_b - sqrtd) / a
    if (root < t_min || t_max < root)
        root = (-half_b + sqrtd) / a
        if (root < t_min || t_max < root)
            return (false, nothing)
        end
    end

    p = at(r, root)
    rec = hit_record(p, (p - s.center) / s.radius, s.mat, root, false)
    outward_normal = (rec.p - s.center) / s.radius
    set_face_normal!(rec, r, outward_normal)
    return (true, rec)
end