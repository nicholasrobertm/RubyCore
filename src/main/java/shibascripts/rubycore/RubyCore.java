package shibascripts.rubycore;

import com.mojang.datafixers.util.Pair;
import net.minecraft.client.Minecraft;
import net.minecraftforge.api.distmarker.Dist;
import net.minecraftforge.event.entity.player.PlayerEvent;
import net.minecraftforge.eventbus.EventBus;
import net.minecraftforge.eventbus.api.Event;
import net.minecraftforge.fml.DistExecutor;
import net.minecraftforge.fml.ExtensionPoint;
import net.minecraftforge.fml.ModLoadingContext;
import net.minecraftforge.fml.event.lifecycle.IModBusEvent;
import net.minecraftforge.fml.event.server.FMLServerStartedEvent;
import net.minecraftforge.fml.javafmlmod.FMLJavaModLoadingContext;
import net.minecraftforge.fml.network.FMLNetworkConstants;
import net.minecraftforge.fml.network.NetworkEvent;
import net.minecraftforge.registries.DeferredRegister;
import net.minecraftforge.registries.ForgeRegistries;
import shibascripts.rubycore.api.*;
import net.minecraftforge.common.MinecraftForge;
import net.minecraftforge.event.RegistryEvent;
import net.minecraftforge.eventbus.api.SubscribeEvent;
import net.minecraftforge.fml.InterModComms;
import net.minecraftforge.fml.common.Mod;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.jruby.embed.ScriptingContainer;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLDecoder;
import java.util.function.Consumer;

@Mod(RubyCoreApi.MOD_ID)
public class RubyCore {

    private static final Logger LOGGER = LogManager.getLogger();

    public static RubyCore instance;

    static ScriptingContainer container = new ScriptingContainer();
    private static Object core = null;

    public RubyCore() {
        instance = this;
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
        MinecraftForge.EVENT_BUS.register(this);
    }

    @SubscribeEvent
    public void subscribeEvents(Event event){
        container.callMethod(core, "process_event", event);
    }

}
