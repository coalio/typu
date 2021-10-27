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
    key_limit = 123948239480 -- Handle only first 10 keystrokes
}

env.window = table.pack(
    love.graphics.getDimensions()
)

env.window.width  = env.window[1]
env.window.height = env.window[2]