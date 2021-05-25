local loader = {}
local parser = {
    pattern = {
        ['line'] = '%[(.-)%](.-)[\r\n]'
    }
}

function parser.to_milliseconds(timestamp)
    local m, s, ms = timestamp:match('(%d+):(%d+).(%d+)')
    return m * 60000 + s * 1000 + (('0.' .. ms) * 100)
end

function parser:parse(input)
    input = input .. '\n'
    local tags = {}
    local intervals = {}
    local commands = {}

    for timestamp, command in input:gmatch(self.pattern['line']) do
        table.insert(intervals, self.to_milliseconds(timestamp))
        table.insert(commands, command)
    end

    for i = 1, #commands do
        tags[i] = {
            command = commands[i],
            interval = (intervals[i + 1] or intervals[i] + 10) - intervals[i]
        }
    end

    return tags
end

function loader:deserialize(map_path)
    local map_data_raw = io.open(map_path, 'r')
    if (map_data_raw) then
        map_data_raw = map_data_raw:read('*a')
    else
        return
    end

    local map_data = {
        path = map_path:match('(.+/).*$')
    }

    local map_tags = parser:parse(map_data_raw)
    for index, tag in pairs(map_tags) do
        map_data[index] = {}
        map_data[index].interval = tag.interval
        map_data[index].actions = {}
        for action, params in map_tags[index].command:gmatch('([%w_]+); (.-)[\r\n;,>]') do
            table.insert(map_data[index].actions, {
                type = action,
                params = {}
            })
            for param in params:gmatch('(%S+)') do
                table.insert(
                    map_data[index].actions[#map_data[index].actions].params, 
                    tonumber(param) and param + 0 or param
                )
            end
        end
    end

    return map_data
end

return loader