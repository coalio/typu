-- Functions not defined in 5.1 / Compatibility

function table.pack(...)
    local t = {...}
    t.n = select("#", ...)

    return t
end


env = {
    platform = package.config:sub(1,1) == '\\' and 'windows' or '?nix',
    debug = true,
    muted = false,
    key_limit = 10 -- Handle only 10 simultaneous keystrokes
}

env.window = table.pack(
    love.graphics.getDimensions()
)

env.window.width  = env.window[1]
env.window.height = env.window[2]