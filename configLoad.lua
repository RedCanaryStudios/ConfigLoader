local configLoader = {}

configLoader.Cache = {}

configLoader.LoadConfig = function(conf)
    assert(type(conf) == "userdata", "The given parameter is not an instance.")
    assert(conf:IsA("Configuration"), "The given parameter is not a configuration object.")
    assert(not configLoader[conf], "The given config folder has already been loaded!")
    
    configLoader.Cache[conf] = conf
    
    local mt
    
    mt = {
        __index = function(t, k)
            
            local obj = rawget(t, "_FOLDER")[k]
            
            assert(obj, "Attempted to index invalid member.")

            if obj:IsA("Folder") then
               
                return setmetatable({_FOLDER = obj}, mt)

            elseif obj:IsA("ValueBase") then

                return obj.Value

            end

            error("Attempted to index non-existant config value.")
        end;

        __newindex = function(t, k, v)
            
            local obj = rawget(t, "_FOLDER")[k]
            
            
            if obj:IsA("Folder") then

                error("Attempted to change subfolder value.")

            elseif obj:IsA("ValueBase") then

                obj.Value = v

            else

                error("Attempted to change non-existant config value.")

            end

        end;
    }

    local configFolder = setmetatable({_FOLDER = conf}, mt)
    
    return configFolder
  
end

return configLoader
