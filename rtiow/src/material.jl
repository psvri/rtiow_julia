struct lambertian <: material
    albedo::color
end

function scatter(mat::lambertian, r_in::ray, rec::hit_record)
    scatter_direction = rec.normal + random_unit_vector()

    if (near_zero(scatter_direction))
        scatter_direction = rec.normal
    end

    scattered = ray(rec.p, scatter_direction)
    attenuation = mat.albedo
    return (true, attenuation, scattered)
end

struct metal <: material
    albedo::color
    fuzz::Float64
end

function scatter(mat::metal, r_in::ray, rec::hit_record)
    reflected = reflect(unit_vector(direction(r_in)), rec.normal)
    scattered = ray(rec.p, reflected + mat.fuzz * random_in_unit_sphere())
    attenuation = mat.albedo
    return (dot(direction(scattered), rec.normal) > 0, attenuation, scattered)
end

struct dielectric <: material
    ir::Float64
end

function scatter(mat::dielectric, r_in::ray, rec::hit_record)
    attenuation = color(1.0, 1.0, 1.0)
    refraction_ratio = rec.front_face ? (1.0 / mat.ir) : mat.ir

    unit_direction = unit_vector(direction(r_in))
    cos_theta = min(dot(-unit_direction, rec.normal), 1.0)
    sin_theta = sqrt(1.0 - cos_theta * cos_theta)

    cannot_refract = refraction_ratio * sin_theta > 1.0
    dir = nothing

    if cannot_refract || reflectance(cos_theta, refraction_ratio) > rand()
        dir = reflect(unit_direction, rec.normal)
    else
        dir = refract(unit_direction, rec.normal, refraction_ratio)
    end

    scattered = ray(rec.p, dir)
    return (true, attenuation, scattered)
end

function reflectance(cosine::Float64, ref_idx::Float64)
    # Use Schlick's approximation for reflectance.
    r0 = (1 - ref_idx) / (1 + ref_idx)
    r0 = r0 * r0
    return r0 + (1 - r0) * (1 - cosine)^5
end