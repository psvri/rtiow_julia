module rtiow

using Images

include("utils.jl")
include("vector.jl")
include("color.jl")
include("ray.jl")
include("hittable.jl")
include("hittable_list.jl")
include("sphere.jl")
include("camera.jl")
include("material.jl")

function random_scene()
    world = hittable_list([])

    ground_material = lambertian(color(0.5, 0.5, 0.5))
    push!(world, sphere(point3(0.0, -1000.0, 0.0), 1000.0, ground_material))

    for a in (-11:10)
        for b in (-11:10)
            choose_mat = rand()
            center = point3(a + 0.9 * rand(), 0.2, b + 0.9 * rand())
            if length(center - point3(4.0, 0.2, 0.0)) > 0.9

                if (choose_mat < 0.8)
                    # diffuse
                    albedo = random_vec() * random_vec()
                    sphere_material = lambertian(albedo)
                    push!(world, sphere(center, 0.2, sphere_material))
                elseif (choose_mat < 0.95)
                    # metal
                    albedo = random_vec(0.5, 1.0)
                    fuzz = rand(0.0, 0.5)
                    sphere_material = metal(albedo, fuzz)
                    push!(world, sphere(center, 0.2, sphere_material))
                else
                    # glass
                    sphere_material = dielectric(1.5)
                    push!(world, sphere(center, 0.2, sphere_material))

                end
            end
        end
    end

    material1 = dielectric(1.5)
    push!(world, sphere(point3(0.0, 1.0, 0.0), 1.0, material1))

    material2 = lambertian(color(0.4, 0.2, 0.1))
    push!(world, sphere(point3(-4.0, 1.0, 0.0), 1.0, material2))

    material3 = metal(color(0.7, 0.6, 0.5), 0.0)
    push!(world, sphere(point3(4.0, 1.0, 0.0), 1.0, material3))


    return world
end


function ray_color(r::ray, world::hittable_list, depth::Int64)

    if depth <= 0
        return color()
    end

    is_hit, rec = hit(world, r, 0.001, Inf)
    if is_hit
        is_scatter, attenuation, scattered = scatter(rec.mat, r, rec)
        if is_scatter
            return attenuation * ray_color(scattered, world, depth - 1)
        end
        return color()
    end
    unit_direction = unit_vector(direction(r))
    t = 0.5 * (y(unit_direction) + 1.0)
    (1.0 - t) * color(1.0, 1.0, 1.0) + t * color(0.5, 0.7, 1.0)
end


function main()

    # Image
    aspect_ratio = 16.0 / 9.0
    image_width::UInt32 = 426
    image_height::UInt32 = UInt32(round(image_width / aspect_ratio))
    image = zeros(Float64, 3, image_height, image_width)
    samples_per_pixel = 100
    max_depth = 50

    # World
    world = random_scene()

    # Camera
    lookfrom = point3(13.0, 2.0, 3.0)
    lookat = point3()
    vup = vec3(0.0, 1.0, 0.0)
    dist_to_focus = 10.0
    aperture = 0.1

    cam = camera(lookfrom, lookat, vup, 20.0, aspect_ratio, aperture, dist_to_focus)

    counter = Threads.Atomic{Int}(0)

    Threads.@threads for j in reverse(1:image_height)
        Threads.@threads for i in (1:image_width)
            pixel_color = color()
            for _ in (1:samples_per_pixel)
                u::Float64 = (i - 1 + rand()) / (image_width - 1)
                v::Float64 = (j - 1 + rand()) / (image_height - 1)

                r = get_ray(cam, u, v)
                pixel_color += ray_color(r, world, max_depth)

            end
            image[:, image_height+1-j, i] = write_color(pixel_color, samples_per_pixel)
            Threads.atomic_add!(counter, 1)
            print(stderr::IO, "\r completed ", counter.value, ":", (image_height * image_width))
        end
    end

    save("output.png", colorview(RGB, image))

end

precompile(main, ())

end # module rtiow
