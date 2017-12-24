**SyncedUI is a compilation created using [pfUI](https://github.com/shagu/pfUI) to form a complete and fully fuctional interface for 1.12 WoW clients.**  
Special thanks to Shagu, Shino, Aviana, Athene and Shirsig.

**Note:** This release is for **1080p** users only. The **1440p** release of SyncedUI can be found [here](https://github.com/vashin1/SyncedUI-1440p-).  


## Screenshots

![Screenshot](https://i.imgur.com/IOOtJqZ.jpg)

![Modular](https://i.imgur.com/VviqvTc.jpg)

## Included Addons
*  **pfUI** - A complete rewrite of the stock UI.  
*  **HealComm** - Visual representation of incoming heals  
*  **KTM 17.35** - Threat meter     
*  **SWStats** - Combat analysis  
*  **Mik's Scrolling Battle Text** - Scrolling combat text  
*  **VCB** - Consolidated buff frames  
*  **Cooline** - Track your cooldowns neatly 
*  **Linkmend** - Converts clink item links into actual item links, also localizes items that would otherwise appear in another language  
*  **Mail** - Improved mailbox interface  
*  **Crafty** - Improved crafting interface  
*  **Extended Quest Log** - Improved quest log    
*  **MobHealth3** - MobHealth3 is a mod that calculates hostile monster and player HP    

## Recommended Addons
* [WIM (continued)](https://github.com/shirsig/WIM) Give whispers an instant messenger feel.  
* [Decursive](https://github.com/Zerf/Decursive) Dispel & decurse automation.  
* [Cartographer](https://github.com/Road-block/Cartographer) Cartographer is a modular, lightweight, and efficient framework for manipulation of the world map with mining/herb support.  
* [Atlas](https://github.com/Cabro/Atlas/) The best version of Atlas, Atlas Loot, and Atlas Quest your going to find for the 1.12 client.  
* [pfQuest](https://github.com/shagu/pfQuest/releases) Quest helper for Vanilla. 
* [BigWigs-Kronos](https://github.com/Vnm-Kronos/BigWigs) Boss timers for use on the Kronos server.  
* [BigWigs-Elysium](https://github.com/Hosq/BigWigs) Boss timers for use on the Elysium server.   

## Installation
1. Backup your current Interface & WTF folders or make a new client (Recommended)   
2. Delete Interface/WTF & unpack the ZIP. Place the provided SyncedUI Interface/WTF folders in the WoW directory.
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

**How do I make my swstats come back, it disappeared?**  
Type /sws bars  
	
## Credits

Shagu - pfUI  
Shino - VCB    
Athene - MSBT  
Shirsig - Linkmend, Postal, Crafty  
Aviana - Healcomm  






