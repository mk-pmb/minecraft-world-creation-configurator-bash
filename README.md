
<!--#echo json="package.json" key="name" underline="=" -->
minecraft-world-creation-configurator
=====================================
<!--/#echo -->

<!--#echo json="package.json" key="description" -->
Automatically fill in your favorite seed, game rules and other options into
the Minecraft world creation settings.
<!--/#echo -->



Motivation
----------

Minecraft offers lots of settings for world creation.
However, playing around with them is very laborious,
because you always have to enter all of them again from scratch:

* People [on the Monjang feedback site][mojang-feedback] would love to be
  granted at least one customizeable profile to set their personal defaults.
  __Unsolved since 2020-10-14.__
* A little later, someone [asked Reddit for help][reddit-neither],
  but they had no solution either,
  and apparently gave up (thread closed/archived).
  __Unsolved since 2021-01-02.__
* Microsoft has [documentation about World Templates][world-templates],
  but it seems those are only useful for exactly reproducing all settings
  of a pre-generated world.
  As far as I understand it from a quick glance,
  you cannot even change the seed later.
  This does not help with tweaking and tinkering.

  [mojang-feedback]: https://feedback.minecraft.net/hc/en-us/community/posts/360073707691
  [reddit-neither]: https://www.reddit.com/r/Minecraft/comments/koszsg/is_there_a_way_to_change_what_the_new_world/
  [world-templates]: https://learn.microsoft.com/en-us/minecraft/creator/documents/packagingaworldtemplate

The proper solution would probably be for someone who knows about Minecraft
modding to implement "Export World Settings" and "Import World Settings"
buttons for the world creation dialog.

Until then, as a stopgap/crutch, I can try and set stuff blindly using
`xdotool` to generate fake keyboard activity.




Usage
-----

* To learn the names of options, see [`cfg.defaults.ini`](cfg.defaults.ini)
  and also the `todo_add_spaces_enum` commands in
  [`funcs/mc_1_19_4.sh`](funcs/mc_1_19_4.sh).
  * If you provide un
* `cfg.defaults.ini` is read first, and it's NOT meant to be edited.
  Rather, give command line options as `key=value` (see example below).
* The special option name `:` means to read an additional config file.
* The special option name `.` means to import and run bash code.
  This is not officially supported and will probably break accross versions.
* In case of duplicate options, the later ones win over the earlier ones.
* If the `worldName` option is empty, a world name will be generated
  based on date, time, and (if specified) the seed.
* The script will display a preview of what keyboard interactions it will
  produce, then ask you how many seconds you will need to prepare.
  * Ideally you have the world creation dialog already open and the only
    thing to do is to switch to the Minecraft window,
    so your answer will probably be 1 or 2.
  * After the chosen preparation time, fake keyboard input will start.
    With default delays, it will type somewhat rapidly, and after very
    few seconds, MC will start creating the world.
  * If you do not see rapid interaction even after double your wait time,
    something is broken.
    It's hopefully safe to switch back to your terminal and read the error
    messages.
    Usually the interactions do not include pressing Enter/Return
    (double-check the preview), so a surprise late start while you're
    back in the terminal shouldn't wreak too much havoc.



#### Invocation examples

```text
# To use just defaults:
./wcc.sh

# Read options from mobs.ini, challenge.ini and also set seed:
./wcc.sh :=mobs.ini :=challenge.ini seed=wombatwombatwombat

# Using unsupported option values gives an error. (The mistake here is uppercase.)
./wcc.sh gameMode=Creative
E: Unsupported value 'Creative' for option 'gameMode'! Expected one of: survival hardcore creative

# Using unsupported option names gives a warning message but won't stop WCC:
./wcc.sh instantWin=yes
[…]
Unsupported settings in config: instantWin
[…]
```



<!--#toc stop="scan" -->



Known issues
------------

* Needs more/better tests and docs.




&nbsp;


License
-------
<!--#echo json="package.json" key=".license" -->
ISC
<!--/#echo -->
