mutable struct camera
    origin::point3
    lower_left_corner::point3
    horizontal::vec3
    vertical::vec3
    u::vec3
    v::vec3
    w::vec3
    lens_radius::Float64
    function camera(lookfrom::vec3, lookat::vec3, vup::vec3,
        vfov::Float64, aspect_ratio::Float64, aperture::Float64, focus_dist::Float64)

        theta = deg2rad(vfov)
        h = tan(theta / 2)
        viewport_height = 2.0 * h
        viewport_width = aspect_ratio * viewport_height

        w = unit_vector(lookfrom - lookat)
        u = unit_vector(cross(vup, w))
        v = cross(w, u)

        origin = lookfrom
        horizontal = focus_dist * viewport_width * u
        vertical = focus_dist * viewport_height * v
        lower_left_corner = origin - horizontal / 2.0 - vertical / 2.0 - focus_dist * w

        lens_radius = aperture / 2.0
        new(origin, lower_left_corner, horizontal, vertical, u, v, w, lens_radius)
    end
end

function get_ray(cam::camera, s::Float64, t::Float64)
    rd = cam.lens_radius * random_in_unit_disk()
    offset = cam.u * x(rd) + cam.v * y(rd)
    ray(
        cam.origin + offset,
        cam.lower_left_corner + s * cam.horizontal + t * cam.vertical - cam.origin - offset)
end
