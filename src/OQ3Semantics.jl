module OQ3Semantics

export Angle, Angle8, Angle16, Angle32, Angle64, Angle128, bitsizeof

const _SCALE = 2.0 * pi
#const _SCALE = 1.0

"""
    Angle{T<:Unsigned}

NOTE: this doc string is incorrect for _SCALE = 2.0 * pi.
Represents an angle in "turns". A turn is a real number in `[0, 1)`.
This `struct` represents real values from `0` to `1 - 1/2^n`, separated by increments of
`1/2^n` where `n` is the width of `T` in bits.
"""
struct Angle{T<:Unsigned}
    _int::T
end

for size in (8, 16, 32, 64, 128)
    @eval const $(Symbol(:Angle, size)) = Angle{$(Symbol(:UInt,size))}
end

Base.Integer(a::Angle) = a._int
Base.show(io::IO, a::Angle) = print(io, float(a))
Base.float(a::Angle) = Integer(a) * (_SCALE / 2.0^bitsizeof(a))

"""
    Angle{T}(x::AbstractFloat) where T <: Unsigned

Construct an `Angle` from a floating point number `x` in `[0, 1)`.
The returned value represents the closest representable angle in turns.
"""
function Angle{T}(x::AbstractFloat) where T <: Unsigned
    (x >= 0 && x < _SCALE) || throw(DomainError(x, "Only floating point values in [0, $_SCALE) can be converted to `Angle`"))
    Angle(round(T, x * 2.0^bitsizeof(T) / _SCALE))
end

Base.:(==)(a1::Angle{T}, a2::Angle{T}) where T = a1 === a2

# FIXME could be more efficient and exact
Base.:(==)(a1::Angle{T}, a2::Angle{V}) where {T, V} = float(a1) == float(a2)

"""
    eps(a::Angle)
    eps(::Type{<:Angle})

The increment between consecutive representable values of `typeof(a)` in turns.
"""
Base.eps(::Type{T}) where T <: Angle = _SCALE /2.0^bitsizeof(T)
Base.eps(a::Angle) = eps(typeof(a))

Base.:*(a1::Angle{T}, x::Integer) where T = Angle(T(x) * Integer(a1))
Base.:*(x::Integer, a::Angle) = a * x

for func in (:+, :-)
    @eval Base.$func(a1::Angle{T}, a2::Angle{T}) where T = Angle($func(Integer(a1), Integer(a2)))
end

function Angle{T}(a::Angle) where T <: Unsigned
    return convert(Angle{T}, a)
end

# We have to preserve the semantics.
function Base.convert(::Type{Angle{T}}, a::Angle{V}) where {T<:Unsigned, V<:Unsigned}
    bitdiff = 8 * (sizeof(T) - sizeof(V))
    iszero(bitdiff) && return a
    if bitdiff > 0
        return Angle{T}(T(Integer(a)) << bitdiff)
    else
        return Angle{T}(V(Integer(a)) >> -bitdiff)
    end
end

for func in (:typemax, :typemin)
    @eval Base.$func(::Type{T}) where T <: Angle{V} where V = Angle($func(V))
    @eval Base.$func(::Angle{T}) where T = Angle($func(T))
end

"""
    bitsizeof(x)

Return the size of `x` in bits.
This is `8 * sizeof(x)`.
"""
bitsizeof(x) = 8 * sizeof(x)

end
