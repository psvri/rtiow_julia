using LinearAlgebra

# vanilla vector
mutable struct vvec
    e::Array{Float64,1}
    function vvec(e1::Float64, e2::Float64, e3::Float64)
        new([e1, e2, e3])
    end
    function vvec(e::Array{Float64,1})
        new(e)
    end
    function vvec()
        new([0.0, 0.0, 0.0])
    end
end

function Base.:+(x::vvec, y::vvec)
    vvec(x.e + y.e)
end

function Base.:-(x::vvec, y::vvec)
    vvec(x.e - y.e)
end

function Base.:-(x::vvec)
    vvec(-x.e)
end

function Base.:(==)(x::vvec, y::vvec)
    x.e == y.e
end

function Base.:*(x::vvec, y::vvec)
    vvec(x.e .* y.e)
end

function Base.:*(x::vvec, y::Float64)
    vvec(x.e * y)
end

function Base.:*(y::Float64, x::vvec)
    vvec(x.e * y)
end

function Base.:/(x::vvec, y::Float64)
    vvec(x.e / y)
end

function Base.:/(x::vvec, y::Int64)
    vvec(x.e / y)
end

function Base.getindex(x::vvec, i::Int)
    x.e[i]
end

function Base.setindex!(x::vvec, v::Float64, i::Int)
    x.e[i] = v
end

x(t::vvec) = t.e[1]
y(t::vvec) = t.e[2]
z(t::vvec) = t.e[3]
to_rgb(t::vvec) = t.e

function Base.length(x::vvec)
    sqrt(length_squared(x))
end

function length_squared(x::vvec)
    dot(x.e, x.e)
end

function LinearAlgebra.dot(x::vvec, y::vvec)
    LinearAlgebra.dot(x.e, y.e)
end

function LinearAlgebra.cross(x::vvec, y::vvec)
    vvec(LinearAlgebra.cross(x.e, y.e))
end

function Base.sqrt(x::vvec)
    vvec(sqrt.(x.e))
end

function unit_vector(v::vvec)
    v / length(v)
end

function random_vec()
    vec3(rand(3))
end

function random_vec(lower::Float64, higher::Float64)
    vec3(lower .+ (higher - lower) * rand(3))
end

function random_in_unit_sphere()
    while true
        p = random_vec(-1.0, 1.0)
        if length_squared(p) < 1.0
            return p
        end
    end
end

function random_unit_vector()
    return unit_vector(random_in_unit_sphere())
end

function near_zero(x::vvec)
    #Return true if the vector is close to zero in all dimensions.
    s = 1e-8
    return (abs(x.e[1]) < s) && (abs(x.e[2]) < s) && (abs(x.e[3]) < s)
end

function random_in_unit_disk()
    while true
        p = vec3(rand(-1.0, 1.0), rand(-1.0, 1.0), 0.0)
        if length_squared(p) < 1
            return p
        end
    end
end

const vec3 = vvec

const point3 = vec3
const color = vec3

function reflect(v::vec3, n::vec3)
    return v - 2 * dot(v, n) * n
end

function refract(uv::vec3, n::vec3, etai_over_etat::Float64)
    cos_theta = min(dot(-uv, n), 1.0)
    r_out_perp = etai_over_etat * (uv + cos_theta * n)
    r_out_parallel = -sqrt(abs(1.0 - length_squared(r_out_perp))) * n
    return r_out_perp + r_out_parallel
end