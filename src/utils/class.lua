local class_prototype = {
    constructor = function(self, n_args)
        local new_of_class = {}

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

local function class(name, prototype, onCreate) 
    local new_class_entity = {
        prototype = prototype
    }

    function new_class_entity:new(n_args)
        local new_instance = class_prototype.constructor(self, n_args)
        if (onCreate) then return onCreate(new_instance) end
        return new_instance
    end

    new_class_entity.class = name

    return new_class_entity
end

return class;