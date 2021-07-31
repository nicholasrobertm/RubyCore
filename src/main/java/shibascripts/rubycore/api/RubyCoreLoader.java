package shibascripts.rubycore.api;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.jruby.embed.ScriptingContainer;
import shibascripts.rubycore.RubyCore;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLDecoder;

public class RubyCoreLoader {

    private static final Logger LOGGER = LogManager.getLogger();

    public static ScriptingContainer container = new ScriptingContainer();
    public static Object core = null;


    public RubyCoreLoader() {
        try {
            container.setClassLoader(RubyCore.class.getClassLoader());
            URL url = getClass().getResource("/loader.rb");
            String unescapedurl = URLDecoder.decode(url.toString(), "UTF-8");
            LOGGER.warn(container.runScriptlet(url.openStream(), unescapedurl));
            Object brainClass = container.runScriptlet(url.openStream(), unescapedurl);
            core = container.callMethod(brainClass, "new");
            container.callMethod(core, "loader_init");
        } catch (UnsupportedEncodingException e) {
            LOGGER.error("UnsupportedEncoding Exception");
            LOGGER.error(e.getMessage());
        } catch (IOException e) {
            LOGGER.error("IO Exception");
            LOGGER.error(e.getMessage());
        }
    }

}
