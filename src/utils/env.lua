-- Functions not defined in 5.1 / Compatibility

function table.pack(...)
    local t = {...}
    t.n = select("#", ...)

    return t
end


env = {
    platform = package.config:sub(1,1) == '\\' and 'windows' or '?nix'
}

env.window = table.pack(
    love.graphics.getDimensions()
)

env.window.width  = env.window[1]
env.window.height = env.window[2]