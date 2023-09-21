using OQ3Semantics
using Documenter

DocMeta.setdocmeta!(OQ3Semantics, :DocTestSetup, :(using OQ3Semantics); recursive=true)

makedocs(;
    modules=[OQ3Semantics],
    authors="John Lapeyre",
    repo="https://github.com/jlapeyre/OQ3Semantics.jl/blob/{commit}{path}#{line}",
    sitename="OQ3Semantics.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://jlapeyre.github.io/OQ3Semantics.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/jlapeyre/OQ3Semantics.jl",
    devbranch="main",
)
