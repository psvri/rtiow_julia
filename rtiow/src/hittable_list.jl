
export hittable_list, hit

mutable struct hittable_list
    objects::Array{hittable}
end

function Base.empty!(list::hittable_list)
    empty!(list.objects)
end

function Base.push!(list::hittable_list, object::hittable)
    push!(list.objects, object)
end

function hit(list::hittable_list, r::ray, t_min::Float64, t_max::Float64)
    hit_anything = false
    closest_so_far = t_max
    rec = nothing

    for object in list.objects
        result = hit(object, r, t_min, closest_so_far)
        if result[1]
            hit_anything = true
            closest_so_far = result[2].t
            rec = result[2]
        end
    end

    (hit_anything, rec)
end
