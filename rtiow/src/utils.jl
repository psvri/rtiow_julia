using Random


function Random.rand(lower::Float64, higher::Float64)
    lower + (higher - lower) * rand()
end

function clamp(x::Float64, lower::Float64, higher::Float64)
    if x < lower
        return lower
    elseif x > higher
        return higher
    else
        return x
    end
end