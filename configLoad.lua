_G.Instructions = [[

   ©2021 Red Canary Studios
   
    -- // discord.canary.red \\ --

    Usage:
        
        Load config and turn them into easily editable tables.
        
        configLoader.LoadConfig(fileLocation)
        
    Notes:
    
        There may be subfolders inside the configuration.
        Subfolders can go inside other subfolders.
        Config folders should only contain ValueBase (BoolValue, Vector3Value, etc.) objects.
        Any other objects will be ignored.

]]



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
            
            local obj = rawget(t, "main")[k]
            
            assert(obj, "Attempted to index invalid member.")

            if obj:IsA("Folder") then
                
                local Folder = {main = obj}

                return setmetatable(Folder, mt)

            elseif obj:IsA("ValueBase") then

                return obj.Value

            end

            error("Attempted to index non-existant config value.")
        end;

        __newindex = function(t, k, v)
            
            local obj = rawget(t, "main")[k]
            
            
            if obj:IsA("Folder") then

                error("Attempted to change subfolder value.")

            elseif obj:IsA("ValueBase") then

                obj.Value = v

            else

                error("Attempted to change non-existant config value.")

            end

        end;
    }

    local configFolder = setmetatable({main = conf}, mt)
    
    return configFolder
  
end

return configLoader
