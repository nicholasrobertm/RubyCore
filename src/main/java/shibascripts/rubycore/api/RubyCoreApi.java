package shibascripts.rubycore.api;

import java.io.File;
import java.lang.reflect.Field;
import java.lang.reflect.Method;

import net.minecraftforge.fml.loading.FMLPaths;


public class RubyCoreApi {

    public static final String MOD_ID = "rubycore";

    public static File minecraft_home(){
        return FMLPaths.GAMEDIR.get().toFile();
    }

    public static File rubycore_home() { return FMLPaths.GAMEDIR.get().resolve(MOD_ID).toFile(); }

    public static Method[] get_methods_from_a_class(String name) throws ClassNotFoundException{
        Class<?> cls = Class.forName(name);
        Method[] m = cls.getMethods();
        return m;
    }

    public static Field[] get_fields_from_a_class(String name) throws ClassNotFoundException{
        Class<?> cls = Class.forName(name);
        Field[] m = cls.getFields();
        return m;
    }

    public static Class<?> get_class(String name) throws ClassNotFoundException{
        Class<?> cls = Class.forName(name);
        return cls;
    }
}
