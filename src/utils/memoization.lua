local memoization = {}

function memoization:memoize(table, index, result)
    self[table] = self[table] or {}
    self[table][index] = result
end

function memoization:isMemoized(table, index, result)
    return self[table] and self[table][index] or false
end

return memoization