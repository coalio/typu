env = {
    platform = package.config:sub(1,1) == '\\' and 'windows' or '?nix'
}