package shibascripts.rubycore.api;

import java.lang.reflect.Field;
import java.lang.reflect.Method;

public class RubyCoreApi {

    public static final String MOD_ID = "rubycore";
    public static final String MOD_VERSION = "0.0.5";

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
