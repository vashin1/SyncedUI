SyncedUI is a compilation created using pfUI (https://github.com/shagu/pfUI) and other addons to form a complete and fully fuctional interface for 1.12 WoW. Special thanks to Shagu, Shino, Athene and Shirsig.  


## Screenshots
![Screenshot](http://i.imgur.com/q6FOF9k.jpg)

![Screenshot](http://i.imgur.com/u5UH0AI.jpg)

![Screenshot](http://i.imgur.com/tTLNO7z.jpg)

![Modular](http://i.imgur.com/SP3vVib.jpg)

## Included Addons
*  **pfUI custom fork** - A complete rewrite of the stock UI with a few adjustments from me.  [Source](https://github.com/vashin1/pfUI)
*  **HealComm** - Visual representation of incoming heals  
*  **KTM 17.35** - Threat meter     
*  **SWStats** - Combat analysis  
*  **Bigwigs** - Boss timers  
*  **Mik's Scrolling Battle Text** - Scrolling combat text  
*  **VCB** - Consolidated buff frames  
*  **Cooline** - Track your cooldowns neatly 
*  **Linkmend** - Converts clink item links into actual item links, also localizes items that would otherwise appear in another language  
*  **Postal** - Improved mailbox interface  
*  **Crafty** - Improved crafting interface  
*  **Extended Quest Log** - Improved quest log    
*  **Classic Snowfall** - On press casting for all classes   

## Recommended Addons
* [Bonus Scanner](http://www.vanilla-addons.com/dls/bonusscanner/) Scans your equipment for cumulative item bonuses and sums them up for use with Healcomm  
* [WIM (continued)](https://github.com/shirsig/WIM) Give whispers an instant messenger feel.  
* [Clean_Up](https://github.com/shirsig/Clean_Up) Automatically stacks and sorts your items.  
* [Decursive](https://drive.google.com/open?id=0B5QT3H5F-mBXNDRtbUloODJnWVU) Dispel & decurse automation.  
* [Cartographer](https://drive.google.com/open?id=0B5QT3H5F-mBXRHlUbGVrTW1ZUm8) Cartographer is a modular, lightweight, and efficient framework for manipulation of the world map with mining/herb support.  
* [Atlas](https://github.com/Cabro/Atlas/) The best version of Atlas, Atlas Loot, and Atlas Quest your going to find for the 1.12 client.  
* [Questie](https://github.com/Dyaxler/QuestieDev/tree/Version3.70) Quest helper for Vanilla. 

## Installation
1. Backup your current Interface & WTF folders or make a new client (Recommended)   
2. Unpack the ZIP & replace your Interface and WTF folders with the ones provided.  
3. Navigate to /WTF, find and rename the "your-account" folder to your account name in all caps.  
4. Rename the "Kronos" folder to the realm your currently playing on.  
5. Rename the "your-character" folder to your characters name, make a copy and rename for any alts on that account.  
6. Delete the WDB Folder  
7. Start WoW and configure Video, Sound, Interface, Keybinds and Macro's.  Note: You can use pfUI to hover bind your bars.  

## Addon Commands

    /pfui       Open the configuration GUI
    /gm         Open the ticket Dialog
    /rl         Reload the whole UI
    /vcb config Configure buff frames
	/swstats    Configure damage meter
	/bigwigs    Configure boss mods
	/msbt       Configure scrolling battle text  

## FAQ

**Can I use Clique with pfUI?**  
A pfUI compatible version of Clique can be found [Here](https://github.com/shagu/Clique/releases). If you want to keep your current version of Clique, you'll have to apply this [Patch](https://github.com/shagu/Clique/commit/a5ee56c3f803afbdda07bae9cd330e0d4a75d75a).

**How can I enable mouseover cast?**  
Create a macro with "/pfcast SPELLNAME". If you also want to see the cooldown, You might want to add "/run if nil then CastSpellByName("SPELLNAME") end" on top of the macro.

**How can I resize frames when pfUI is unlocked?**  
Hold shift and hover over the frame you wish to modify and then mouse wheel up to increase scale, and down to decrease scale.

**How can I move my Raid frames and keep them interlocked?**  
Hold shift and select a raid frame in the middle and drag, the entire frames will interlock to it's new location.

**How can I make my own profile?**  
Enter pfUI config and create a new profile, rename it and modify to your taste & save. This is handy to have if you have a healer and DPS toon.
	
## Credits

Shagu - pfUI  
Shino - VCB    
Athene - MSBT  
Shirsig - Linkmend, Postal, Crafty  






