--[[
loottables.es.lua --- Traduction ES por maqjav y StiviS
This file assigns a title to every loot table.  The primary use of this table
is in the search function, as when iterating through the loot tables there is no
inherant title to the loot table, given the origins of the mod as an Atlas plugin.

]]

if (GetLocale() == "esES") then

-----------------
--- Instances ---
-----------------

  --Keys
    AtlasLoot_TableNames["OldKeys"][1] = "Llaves";
    AtlasLoot_TableNames["BCKeys"][1] = "Llaves";
  --Auch: Sethekk Halls
    AtlasLoot_TableNames["AuchSethekkTheSagaofTerokk"][1] = "La Saga de Terokk";
  --Auch: Shadow Labyrinth
    AtlasLoot_TableNames["AuchShadowFirstFragmentGuardian"][1] = "Guardián del Primer Fragmento";
  --Blackrock Depths
    AtlasLoot_TableNames["BRDArena"][1] = "Círculo de la Ley";
    AtlasLoot_TableNames["BRDForgewright"][1] = "Monumento a Franclorn Forjador";
    AtlasLoot_TableNames["BRDGuzzler"][1] = "Grim Guzzler"; --FALTA
    AtlasLoot_TableNames["BRDTomb"][1] = "Tumba del Invocador";
    AtlasLoot_TableNames["BRDBSPlans"][1] = "Diseño de herrería (PRN)";
  --The Black Temple
    AtlasLoot_TableNames["BTEssencofSouls"][1] = "Reliquaire des \195\162mes";
    AtlasLoot_TableNames["BTPatterns"][1] = "Recetas/Planos del Templo Oscuro";
  --Blackwing Lair
    AtlasLoot_TableNames["BWLDraconicForDummies"][1] = "Dracónico para torpes Volumen VII";
  --CFR: The Steamvault
    AtlasLoot_TableNames["CFRSteamSecondFragmentGuardian"][1] = "Guardián del Segundo Fragmento";
  --CoT: Old Hillsbrad Foothills
    AtlasLoot_TableNames["CoTHillsbradAgedDalaranWizard"][1] = "Zhaorí Dalaran envejecido";
  --The Deadmines
  --AtlasLoot_TableNames["VCDefiasGunpowder"][1] = "Pólvora de los Defias";
  --Dire Maul East
    AtlasLoot_TableNames["DMBooks"][1] = "Libros (LM)";
  --HC: Shattered Halls
    AtlasLoot_TableNames["HCHallsExecutioner"][1] = "Ejecutor Mano Destrozada (Heróico)";
  --Karazhan
    AtlasLoot_TableNames["KaraCharredBoneFragment"][1] = "Trozo de hueso carbonizado (Objeto de misión)";
    AtlasLoot_TableNames["KaraNamed"][1] = "Los jefes animales";
    AtlasLoot_TableNames["KaraKeannaLog"][1] = "Apuntes de Keanna (Objeto de misión)";
    AtlasLoot_TableNames["KaraOperaEvent"][1] = "Evento de la opera";
  --Maraudon
    AtlasLoot_TableNames["MaraKhanKolk"][1] = "Kolk (El primer Kahn)";
    AtlasLoot_TableNames["MaraKhanGelk"][1] = "Gelk (El segundo Kahn)";
    AtlasLoot_TableNames["MaraKhanMagra"][1] = "Magra (El tercer Kahn)";
    AtlasLoot_TableNames["MaraKhanVeng"][1] = "Veng (El quinto Kahn)";
    AtlasLoot_TableNames["MaraKhanMaraudos"][1] = "Maraudos (El cuarto Khan)";
  --Molten Core
    AtlasLoot_TableNames["MCRANDOMBOSSDROPPS"][1] = "Botín de jefes aleatorios";
  --The Ruins of Ahn'Qiraj
    AtlasLoot_TableNames["AQ20Trash"][1] = "Bichos varios (AQ20)";
    AtlasLoot_TableNames["AQ20ClassBooks"][1] =  "Libros de clase de AQ";
    AtlasLoot_TableNames["AQEnchants"][1] = "Encantamientos AQ";
  --Shadowfang Keep
    AtlasLoot_TableNames["BSFFelSteed"][1] = "Corcel vil";
  --Stratholme
    AtlasLoot_TableNames["STRATStratholmeCourier"][1] = "Mensajero de Stratholme";
    AtlasLoot_TableNames["STRATAtiesh"][1] = "Atiesh <Mano de Sargeras>";
    AtlasLoot_TableNames["STRATBSPlansSerenity"][1] = "Diseño: Serenidad";
    AtlasLoot_TableNames["STRATBSPlansCorruption"][1] = "Diseño: Corrupción";
  --Sunken Temple
    AtlasLoot_TableNames["STSpawnOfHakkar"][1] = "Altar de Hakkar";
    AtlasLoot_TableNames["STTrollMinibosses"][1] = "Mini jefes troll";
  --Temple of Ahn'Qiraj
    AtlasLoot_TableNames["AQ40Trash1"][1] = "Bichos varios (AQ40)";
    AtlasLoot_TableNames["AQ40Trash2"][1] = "Bichos varios (AQ40)";
    AtlasLoot_TableNames["AQOpening"][1] = "Apertura de AQ";
  --TK: The Arcatraz
    AtlasLoot_TableNames["TKArcThirdFragmentGuardian"][1] = "Guardián del Tercer Fragmento";
  --TK: The Eye
    AtlasLoot_TableNames["TKEyeLegendaries"][1] = "Objetos legendarios de la lucha contra Kael'thas";
  --TK: The Mechanar
    AtlasLoot_TableNames["TKMechCacheoftheLegion"][1] = "Alijo de la Legión";
    AtlasLoot_TableNames["TKMechOverchargedManacell"][1] = "Célula de maná sobrecargada";
  --Uldaman
    AtlasLoot_TableNames["UldTabletofRyuneh"][1] = "Tablilla de Ryun'eh";
    AtlasLoot_TableNames["UldTabletofWill"][1] = "Tablilla de Voluntad";
    AtlasLoot_TableNames["UldShadowforgeCache"][1] = "Alijo de Forjatiniebla";
  --Zul'Aman
    AtlasLoot_TableNames["ZATimedChest"][1] = "Cofre con temporizador"; --Comprobar
  --Zul'Gurub
    AtlasLoot_TableNames["ZGMuddyChurningWaters"][1] = "Aguas Fangosas";
    AtlasLoot_TableNames["ZGShared"][1] = "Botín compartido por los sacerdotes (ZG)";
    AtlasLoot_TableNames["ZGEnchants"][1] = "Encantamientos (ZG)";

------------------------
--- Misc Collections ---
------------------------

    AtlasLoot_TableNames["BlizzardCollectables1"][1] = "Colecciones Blizzard";
    AtlasLoot_TableNames["RareMounts1"][1] = "Monturas raras - WoW Original";
    AtlasLoot_TableNames["RareMounts2"][1] = "Monturas raras - The Burning Crusade";

--------------
--- Events ---
--------------

  --Abyssal Council
    AtlasLoot_TableNames["Templars"][1] = "Consejo abisal - Templarios";
    AtlasLoot_TableNames["Dukes"][1] = "Consejo abisal - Duques";
    AtlasLoot_TableNames["HighCouncil"][1] = "Consejo abisal - Consejero mayor";
  --Seasonal
    AtlasLoot_TableNames["LordAhune"][1] = "Lord Ahune"; --FALTA
    AtlasLoot_TableNames["Winterviel2"][1] = "Regalos del Festival de Invierno";
  --Skettis
    AtlasLoot_TableNames["SkettisTalonpriestIshaal"][1] = "Sacerdote de la garra Ishaal";
    AtlasLoot_TableNames["SkettisHazziksPackage"][1] = "Paquete de Hazzik";
  --Other
    AtlasLoot_TableNames["ScourgeInvasionEvent2"][1] = "Jefes de la invasión de La plaga";

end
