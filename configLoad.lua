_G.Instructions = [[

   ©2021 Red Canary Studios
   
    -- // discord.canary.red \\ --

    Usage:
        
        Load config and turn them into easily editable tables.
        
        configLoader.LoadConfig(fileLocation)
        
    Notes:
    
        There may be subfolders inside the configuration.
        The there should NOT be any subfolders inside other subfolders.
        Config folders should only contain ValueBases (BoolValue, Vector3Value, etc.) objects.
        Any other objects will be ignored.

]]



local configLoader = {}

configLoader.Cache = {}

configLoader.LoadConfig = function(conf)
    assert(type(conf) == "userdata", "The given parameter is not an instance.")
    assert(conf:IsA("Configuration"), "The given parameter is not a configuration object.")
    assert(not configLoader.Cache[conf], "The given config folder has already been loaded!")
    
    local contents = {
        ["Values"] = {};
        ["Subfolders"] = {};
    }
    
    local child = conf:GetChildren()
    
    for i, v in ipairs(child) do
    
        if v:IsA("ValueBase") then
            
            contents.Values[v.Name] = v
            
        elseif v:IsA("Folder") then
            
            contents.Subfolders[v.Name] = v
            
        end
    
    end
    
    configLoader.Cache[conf] = conf
    

    local configFolder = setmetatable(configLoader, {
        __index = function(t, k)
            
            if contents.Subfolders[k] then
                
                local main = contents.Subfolders[k]
                
                return setmetatable({}, {
                    
                    __index = function(t, k)
                        
                        return main[k].Value
                        
                    end;
                    
                    __newindex = function(t, k, v)
                        
                        main[k].Value = v
                        
                    end;
                    
                })
                
            elseif contents.Values[k] then
                
                return contents.Values[k].Value
                
            end
            
            error("Attempted to index non-existant config value.")
        end;
        
        __newindex = function(t, k, v)
            
            if contents.Subfolders[k] then
                
                error("Attempted to change subfolder value.")
                
            elseif contents.Values[k] then
                
                contents.Values[k].Value = k
                
            else
                
                error("Attempted to change non-existant config value.")
                
            end
            
        end;
    })
    
    return configFolder
  
end

return configLoader

