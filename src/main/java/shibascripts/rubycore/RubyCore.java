package shibascripts.rubycore;

import net.minecraft.block.AbstractBlock;
import net.minecraft.block.material.Material;
import net.minecraft.item.BlockItem;
import net.minecraft.item.Item;
import net.minecraft.item.ItemGroup;
import net.minecraftforge.registries.DeferredRegister;
import net.minecraftforge.registries.ForgeRegistries;
import shibascripts.rubycore.api.*;
import net.minecraft.block.Block;
import net.minecraftforge.common.MinecraftForge;
import net.minecraftforge.event.RegistryEvent;
import net.minecraftforge.eventbus.api.SubscribeEvent;
import net.minecraftforge.fml.InterModComms;
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.fml.event.lifecycle.FMLClientSetupEvent;
import net.minecraftforge.fml.event.lifecycle.FMLCommonSetupEvent;
import net.minecraftforge.fml.event.lifecycle.InterModEnqueueEvent;
import net.minecraftforge.fml.event.lifecycle.InterModProcessEvent;
import net.minecraftforge.fml.event.server.FMLServerStartingEvent;
import net.minecraftforge.fml.javafmlmod.FMLJavaModLoadingContext;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.jruby.embed.ScriptingContainer;

import javax.annotation.Nonnull;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLDecoder;
import java.util.stream.Collectors;

import static java.lang.Thread.sleep;

// The value here should match an entry in the META-INF/mods.toml file
@Mod(RubyCoreApi.MOD_ID)
public class RubyCore {

    // Directly reference a log4j logger.
    private static final Logger LOGGER = LogManager.getLogger();

    public static RubyCore instance;
    public static final DeferredRegister<Block> BLOCKS = DeferredRegister.create(ForgeRegistries.BLOCKS, RubyCoreApi.MOD_ID);
    public static final DeferredRegister<Item> ITEMS = DeferredRegister.create(ForgeRegistries.ITEMS, RubyCoreApi.MOD_ID);

    static ScriptingContainer container = new ScriptingContainer();
    private static Object core = null;

    public RubyCore() {
        instance = this;
        // Register the setup method for modloading
        FMLJavaModLoadingContext.get().getModEventBus().addListener(this::setup);

        // some preinit code
        try {
            container.setClassLoader(RubyCore.class.getClassLoader());
            URL url = getClass().getResource("/loader.rb");
            String unescapedurl = URLDecoder.decode(url.toString(), "UTF-8");
            Object brainClass = container.runScriptlet(url.openStream(), unescapedurl);
            core = container.callMethod(brainClass, "new");
            container.callMethod(core, "loader_init");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void setup(final FMLCommonSetupEvent event) {

    }

//    private void doClientStuff(final FMLClientSetupEvent event) {
//        // do something that can only be done on the client
//        LOGGER.info("ruby Got game settings {}", event.getMinecraftSupplier().get().gameSettings);
//    }
//
//    private void enqueueIMC(final InterModEnqueueEvent event) {
//        // some example code to dispatch IMC to another mod
//        InterModComms.sendTo(RubyCoreApi.MOD_ID, "helloworld", () -> {
//            LOGGER.info("ruby Hello world from the MDK");
//            return "ruby Hello world";
//        });
//    }
//
//    private void processIMC(final InterModProcessEvent event) {
//        // some example code to receive and process InterModComms from other mods
//        LOGGER.info("ruby Got IMC {}", event.getIMCStream().
//                map(m -> m.getMessageSupplier().get()).
//                collect(Collectors.toList()));
//    }
//
//    // You can use SubscribeEvent and let the Event Bus discover methods to call
//    @SubscribeEvent
//    public void onServerStarting(FMLServerStartingEvent event) {
//        // do something when the server starts
//        LOGGER.info("ruby HELLO from server starting");
//    }


}
