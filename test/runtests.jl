using OQ3Semantics: OQ3Semantics, Angle, Angle8, Angle16, Angle32, Angle64, Angle128
using Test

@testset "OQ3Semantics.jl" begin
    a = Angle(UInt8(3))
    @test Integer(a) === UInt8(3)

    # How you may and may not construct Angle
    @test (Angle(UInt16(5)); true)
    @test (Angle8(3); true)
    @test (Angle64(0.5); true)
    @test_throws MethodError Angle(3)
    @test_throws MethodError Angle(0.5)

    for T in (Angle8, Angle16, Angle32, Angle64, Angle128)
        @test eps(T) == float(T(1))
    end

    scale = OQ3Semantics._SCALE
    for T in (Angle64, Angle128)
        for v in (scale - 1e-6, scale - 1e-8, scale - 1e-12)
            @test float(T(v)) == v
        end
    end

end
