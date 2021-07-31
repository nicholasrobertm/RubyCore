package shibascripts.rubycore;

import net.minecraftforge.eventbus.api.Event;
import shibascripts.rubycore.api.*;
import net.minecraftforge.common.MinecraftForge;
import net.minecraftforge.eventbus.api.SubscribeEvent;
import net.minecraftforge.fml.common.Mod;

@Mod(RubyCoreApi.MOD_ID)
public class RubyCore {

    public static RubyCore instance;

    public static RubyCoreLoader loader;

    public RubyCore() {
        instance = this;
        loader = new RubyCoreLoader();
        MinecraftForge.EVENT_BUS.register(this);
    }

    @SubscribeEvent
    public void subscribeEvents(Event event){
        RubyCoreLoader.container.callMethod(RubyCoreLoader.core, "process_event", event);
    }

}
