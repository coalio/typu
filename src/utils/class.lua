local class_prototype = {
    constructor = function(n_args)
        local new_of_class

        for key, value in pairs(self) do
            new_of_class[key] = value
        end

        setmetatable(new_of_class, {
            __index = self.prototype
        })

        for key, value in pairs(n_args) do
            new_of_class[key] = value
        end

        return new_of_class
    end
}

local function class(name, prototype) 
    local new_class_entity = {
        prototype = prototype
    }

    local function new_class_entity:new(onCreate, ...)
        if (onCreate) then onCreate() end
        return class_prototype.constructor(self, table.unpack({...}))
    end

    new_class_entity.class = name

    return new_class_entity
end

return class;