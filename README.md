RubyCore
========

This Repository is Hosted and mirrored from [gitlab](https://gitlab.com/nicholasrobertm/rubycore).
All issues and contributions should be made there.

This is an updated & maintained fork of btripoloni's idea found [here](https://github.com/btripoloni/RubyCore)

RubyCore is an easy way to create mods / plugins for Minecraft using Ruby.

Requirements
============
JRuby - 9.2.17 - Pre-included in this repo's libs folder, bundled with rubyzip for RubyCore functionality
Java - You need java 15 for version 1.16.5 of minecraft. Given how lightweight this is on the java end, it may actually support many other versions, it's just untested.

**Note**: DeferredRegister makes block/item registration much easier than passing registry events through from the java end which is why this is targeting 1.16.5 for the moment.

Caveats
=======

Currently, due to JRuby (What's used to interpret the ruby code from java) not supporting annotations on ruby functions or classes you're still required to have your mod annotation on the java side.
Additionally, the lack of annotations makes @SubscribeEvent annotations not work 100% from the ruby side, so if you need to use these you should ensure to have either:
- Java code in your mod doing similar to what RubyCore.java does, calling your ruby code from the java end
- Define a process_event(event) function in your mod / script. RubyCore will pass events from forge to your function for you to handle.

Both Internal and External mods (found in the 'mod' folder or copied in from external jars) are copied into the 'cache' folder in rubycore. 
There is no known way around this currently as you need a file to call ruby's `load` function against.

Avoid system/exec/backticks calls. Spawning a sub-ruby in jruby can cause negative performance and should be avoided when possible.

#Getting started:

RubyCore is written to allow you to write a mod / plugin in a few ways. These include:
  
* Create a standard forge project in Intellij, setup your mods.toml and annotation in your main class then create a file named `mod_yourmodname.rb` in `src/main/resources` Use this file as the base of your mod / plugin.   
    * When you put this external mod in your mods folder and have RubyCore there as well, 
      RubyCore will scan for existence of the mod_*.rb file, copy them to `rubycore/cache` on the client / server and load the files in.

* Create a script directly in the `rubycore/scripts` directory. It will be loaded in straight from there

* Cloning this repo, changing the mod ID in `src/main/java/shibascripts/rubycore/api/RubyCoreApi.java` and the mods.toml. Then adding any of your ruby code in `src/main/resources/mod`. You must follow the mod_*.rb syntax for your main mod file.
  * **Note**: Doing this disables the loading of external mods (Ruby code bundled in jars in the /mods folder)

Once you've done either of these you can run gradle build to get your jar like you would normally.

---
Create a mod using RubyCore is easy
===================================

Check out `src/resources/examples` or https://gitlab.com/nicholasrobertm/gems for some example mod / plugin implementations.

JRuby (the interpreter that executes the Ruby Code) automatically converts things like Objects and function names to a Ruby happy format.

Example of a block in Ruby:
@ruby_block = Block.new(AbstractBlock::Properties.create(Material::ROCK).hardness_and_resistance(3, 10).harvest_level(2))

Additionally this project uses Mojmaps and has a class for generating ruby versions of the mappings which then are modified and included in `src/main/resources/rubycore/forge/mappings`

---
FAQ
===

What type of mods / plugins can I create?
===============================

You can access all Java, Minecraft, and Forge APIs using Ruby, so you can create whatever you'd like! This project will have some helper classes that wrap the Forge APIs (see what's under the 'rubycore' folder in `src/main/resources`) so check those out as well.

Fabric / Sponge / Spigot support?
=================================

I am currently working toward porting the bare minimum 'loader' portion to be generic. This will allow implementation of any API.

Wrapper classes are currently only being written with Forge in mind, if you'd like to contribute Fabric or Spigot supported wrapper classes, feel free to create a Merge request!

Can I use gems?
===============

Technically it's possible to download gems via the same line found in loader.rb
- RubyCore::Gems::process_gems([{rubygem: "rubyzip", as: "zip"}])

This must be done at the top where 'require' is, otherwise they won't be available to the running program.

This uses ruby's `system` call to spawn a sub-ruby process from jruby within the built rubycore jar. 
This implementation isn't 100% ideal as downloading things during runtime isn't great, and sub-ruby processes when use can have performance issues (though you likely won't see it since this would only happen on startup once)

RubyCore does make use of the rubyzip gem, which is why you'll find a modified version of jruby in libs/
This was done essentially following the below steps:

- mkdir rubyzip
- java -jar jruby-complete-9.2.jar -S gem install -i ./rubyzip rubyzip
- jar uf jruby-complete-9.2.jar -C rubyzip .

You could do the same to include any gems you wish to use, presuming you build your mod from the rubycore base and not as an external mod.

Can I include other mods as a dependency?
========================================

You can use java so yes, you can import any java classes per usual. Add them to your build.gradle and use java_import in your ruby code (see forge.rb for an example)

Can I use java in my mod?
=========================
You can call any Java class / function from Ruby. Just be sure to understand that JRuby changes the function / class name to a Ruby syntax form of the same thing.

Why Ruby?
========

Ruby is a language that was designed for the developer. It's a language born in Japan in the 1990's that is now used all over the world.

- Did you know both Github and Gitlab are built with Ruby on Rails (A popular web framework / dsl written in ruby) and scale to millions of users?
    * https://about.gitlab.com/blog/2020/06/24/scaling-our-use-of-sidekiq/
    * https://github.blog/2019-09-09-running-github-on-rails-6-0/
---

Bug Bounties
============
If you identify a way to either:

- Download gems from a compiled jruby, from Ruby code
- Call the ruby load function (From Ruby) against Ruby files inside a jar without having to unzip them to a cache folder

Please contact me or open and issue, and we can discuss compensation for these being sorted.

---
Contributing
============

Be sure to contribute your changes against [Gitlab](https://gitlab.com/nicholasrobertm/rubycore).

I'm happily accepting pull requests for this project. Check out current git issues for an idea of the current goals of this project.

>- Fork
>- Complete all your changes
>- Send a merge request

---
License
=======
Can be found in LICENSE.md in the root directory