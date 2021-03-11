# ConfigLoader

Instructions

    Usage:
        
        Config Loader will load configuration files into tables you can edit.
        
        local t = configLoader.LoadConfig(fileLocation)
        
    Notes:
    
        There may be subfolders inside the configuration.
        Subfolders can go inside other subfolders.
        Config folders should only contain ValueBase (BoolValue, Vector3Value, etc.) objects.
        Any other objects will be ignored.

        Folders and subfolders have a ._FOLDER property. This will be a pointer to the actual folder you're refrencing.

        EG: t.subfolder._FOLDER
            t._FOLDER
