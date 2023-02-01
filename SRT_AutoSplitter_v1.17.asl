/////////////////////////////////////////////////////////////////
///
///     Spyro Reignited Trilogy Autosplitter v1.17
///   
/////////////////////////////////////////////////////////////////
///
///     Author: Dinopony (@DinoponyRuns)
///     Updated by: SirBorris (@TheSirBorris) & Bored_Banana (@BoredBanana1) (v1.15 Onwards)
///     Special thanks to:
///        - CptBrian for his precious knowledge about UE4 games structure and his work unifying pointers
///        - Zic3 for helping finding RAM addresses
///        - All the Spyro community for being helpful and supportive in the process of making this beast :)
///
/////////////////////////////////////////////////////////////////
///
///     Change log
///     v1.15: 
///			- Updated Sorceress Last Hit function and added a memory pointer (This was painful :) )
///    		- Fixed typo in Sgt Byrd Base causing autosplitter to not function
///			- Added vars.storedMap for SRT3 boss battles using an extra variable to store the value "old.map" in the event of a null map. 
///
///     v1.15.1
///         - Added the war crime of three checks for each SRT 3 boss to remove issues in SRT 1 & 2. Will need fixing but for now it works.
///
///     v1.16
///         - Removed the war crime in favour of another dictionary, improving performance (Thanks Banana for the assist!)
///
///		v1.17
///			- Located a pointer for cutscenes! This should remove loadless when cutscenes are playing, assuming we actually attach it to a process. This will need SRC mod approval before it is created
///
///
/////////////////////////////////////////////////////////////////

state("Spyro-Win64-Shipping")
{
    // Set to 0 when loading, set to 1 otherwise (foundable as a 4-byte searching for 256)
    byte isNotLoading : 0x03415F30, 0xF8, 0x4A8, 0xE19;

    // Set to 0 in game, 1 if in menu, 15 if in graphics submenu
    byte inMenu : 0x034160D0, 0x20, 0x218, 0x60;

    // Set to 0 in title screen and main menu, set to 1 everywhere else
    byte inGame : 0x03415F30, 0xF0, 0x378, 0x564;

    // Counts Ripto's 3rd phase health (init at 8 from the very beginning of Ripto 1 fight, can be frozen at 0 to end the fight)
    byte healthRipto3 : 0x03415F30, 0x110, 0x50, 0x140, 0x8, 0x1D0, 0x134;    

    // Counts Sorceress's health (init at 10 from the very beginning of Sorc 1 fight, can be frozen at 0 to end the fight)
    byte healthSorc2 : 0x03601278, 0x40, 0x58, 0x20, 0xB0, 0x90, 0x140, 0xA28;

    // ID of the map the player is being in
    string256 map : 0x03415F30, 0x138, 0xB0, 0xB0, 0x598, 0x210, 0xB8, 0x148, 0x190, 0x0;
	
	//ID of the cutscene currently being played, set to ?? if no cutscene is playing
	//string256 CurrentCutscene : 0x03610178, 0x68, 0xC0, 0x50, 0x368, 0xA0, 0x98, 0x60;
	
	// ID of how many areas have been entered, used to remove opening cutscenes from timing (SRT3 only)
	//byte RenderCount : 0x031DB390, 0x8, 0x78, 0x8, 0x2D0, 0x2E0, 0x8, 0x28;
	
	//ID for SBR Sorceress in SRT 3
}

/* Old unstable pointer values found, may be useful if anybody has a problem with current ones
state("Spyro-Win64-Shipping")
{
    byte isNotLoading : 0x034149E8, 0x18, 0xE0, 0x4A8, 0xE19;
    byte inMenu : 0x03658048, 0x68, 0x218, 0x60;
    byte inGame : 0x03659C60, 0x7E8, 0x2D0, 0x70, 0xE0, 0x564;
    byte healthRipto3 : 0x03415F30, 0x88, 0x48, 0x138, 0x140, 0x8, 0x1D0, 0x134;
    string255 gvasRoot : 0x36A2010, 0x1E0, 0x0, 0x10, 0x20, 0x0;
}
*/

startup
{
    // Maps info tuples contains :
    //  1) internal map ID           (string)
    //  2) English display name      (string)
    vars.maps = new Dictionary<string, Tuple<string,string>> {
        // Spyro 1 maps
        { "s1_stone_hill",              new Tuple<string,string>("/LS102_StoneHill/Maps/",          "Stone Hill")       },
        { "s1_dark_hollow",             new Tuple<string,string>("/LS103_DarkHollow/Maps/",         "Dark Hollow")      },
        { "s1_town_square",             new Tuple<string,string>("/LS104_Townsquare/Maps/",         "Town Square")      },
        { "s1_sunny_flight",            new Tuple<string,string>("/LS105_Sunnyflight/Maps/",        "Sunny Flight")     },
        { "s1_toasty",                  new Tuple<string,string>("/LS106_Toasty/Maps/",             "Toasty")           },
        { "s1_dry_canyon",              new Tuple<string,string>("/LS108_DryCanyon/Maps/",          "Dry Canyon")       },
        { "s1_cliff_town",              new Tuple<string,string>("/LS109_CliffTown/Maps/",          "Cliff Town")       },
        { "s1_ice_cavern",              new Tuple<string,string>("/LS110_IceCavern/Maps/",          "Ice Cavern")       },
        { "s1_night_flight",            new Tuple<string,string>("/LS111_NightFlight/Maps/",        "Night Flight")     },
        { "s1_doctor_shemp",            new Tuple<string,string>("/LS112_DrShemp/Maps/",            "Doctor Shemp")     },
        { "s1_alpine_ridge",            new Tuple<string,string>("/LS114_AlpineRidge/Maps/",        "Alpine Ridge")     },  
        { "s1_high_caves",              new Tuple<string,string>("/LS115_HighCaves/Maps/",          "High Caves")       },
        { "s1_wizard_peak",             new Tuple<string,string>("/LS116_WizardPeak/Maps/",         "Wizard Peak")      },
        { "s1_crystal_flight",          new Tuple<string,string>("/LS117_CrystalFlight/Maps/",      "Crystal Flight")   },       
        { "s1_blowhard",                new Tuple<string,string>("/LS118_Blowhard/Maps/",           "Blowhard")         },
        { "s1_terrace_village",         new Tuple<string,string>("/LS120_TerraceVillage/Maps/",     "Terrace Village")  },
        { "s1_misty_bog",               new Tuple<string,string>("/LS121_MistyBog/Maps/",           "Misty Bog")        },
        { "s1_tree_tops",               new Tuple<string,string>("/LS122_TreeTops/Maps/",           "Tree Tops")        },
        { "s1_wild_flight",             new Tuple<string,string>("/LS123_WildFlight/Maps/",         "Wild Flight")      },
        { "s1_metalhead",               new Tuple<string,string>("/LS124_MetalHead/Maps/",          "Metalhead")        },
        { "s1_dark_passage",            new Tuple<string,string>("/LS126_DarkPassage/Maps/",        "Dark Passage")     },
        { "s1_lofty_castle",            new Tuple<string,string>("/LS127_LoftyCastle/Maps/",        "Lofty Castle")     },
        { "s1_haunted_towers",          new Tuple<string,string>("/LS128_HauntedTowers/Maps/",      "Haunted Towers")   },
        { "s1_icy_flight",              new Tuple<string,string>("/LS129_IcyFlight/Maps/",          "Icy Flight")       },
        { "s1_jacques",                 new Tuple<string,string>("/LS130_Jacques/Maps/",            "Jacques")          },
        { "s1_gnorc_cove",              new Tuple<string,string>("/LS132_GnorcCove/Maps/",          "Gnorc Cove")       },
        { "s1_twilight_harbor",         new Tuple<string,string>("/LS133_TwlightHarbour/Maps/",     "Twilight Harbor")  },
        { "s1_gnasty_gnorc",            new Tuple<string,string>("/LS134_GnastyGnorc/Maps/",        "Gnasty Gnorc")     },
        { "s1_gnastys_loot",            new Tuple<string,string>("/LS135_GnastyLoot/Maps/",         "Gnasty's Loot")    },

        // Spyro 2 maps
        { "s2_glimmer",                 new Tuple<string,string>("/LS202_Glimmer/Maps/",            "Glimmer")          },
        { "s2_idol_springs",            new Tuple<string,string>("/LS203_IdolSprings/Maps/",        "Idol Springs")     },
        { "s2_colossus",                new Tuple<string,string>("/LS204_Colossus/Maps/",           "Colossus")         },
        { "s2_hurricos",                new Tuple<string,string>("/LS205_Hurricos/Maps/",           "Hurricos")         },
        { "s2_sunny_beach",             new Tuple<string,string>("/LS206_SunnyBeach/Maps/",         "Sunny Beach")      },
        { "s2_aquaria_towers",          new Tuple<string,string>("/LS207_AquariaTowers/Maps/",      "Aquaria Towers")   },
        { "s2_crushs_dungeon",          new Tuple<string,string>("/LS208_CrushsDungeon/Maps/",      "Crush's Dungeon")  },
        { "s2_ocean_speedway",          new Tuple<string,string>("/LS209_OceanSpeedway/Maps/",      "Ocean Speedway")   },
        { "s2_crystal_glacier",         new Tuple<string,string>("/LS211_CrystalGlacier/Maps/",     "Crystal Glacier")  },
        { "s2_skelos_badlands",         new Tuple<string,string>("/LS212_SkelosBadlands/Maps/",     "Skelos Badlands")  },
        { "s2_zephyr",                  new Tuple<string,string>("/LS213_Zephyr/Maps/",             "Zephyr")           },
        { "s2_breeze_harbor",           new Tuple<string,string>("/LS214_BreezeHarbor/Maps/",       "Breeze Harbor")    },
        { "s2_scorch",                  new Tuple<string,string>("/LS215_Scorch/Maps/",             "Scorch")           },
        { "s2_fracture_hills",          new Tuple<string,string>("/LS216_FractureHills/Maps/",      "Fracture Hills")   },
        { "s2_magma_cone",              new Tuple<string,string>("/LS217_MagmaCone/Maps/",          "Magma Cone")       },
        { "s2_shady_oasis",             new Tuple<string,string>("/LS218_ShadyOasis/Maps/",         "Shady Oasis")      },
        { "s2_gulps_overlook",          new Tuple<string,string>("/LS219_GulpsOverlook/Maps/",      "Gulp's Overlook")  },
        { "s2_icy_speedway",            new Tuple<string,string>("/LS220_IcySpeedway/Maps/",        "Icy Speedway")     },
        { "s2_metro_speedway",          new Tuple<string,string>("/LS221_MetroSpeedway/Maps/",      "Metro Speedway")   },
        { "s2_mystic_marsh",            new Tuple<string,string>("/LS223_MysticMarsh/Maps/",        "Mystic Marsh")     },
        { "s2_cloud_temples",           new Tuple<string,string>("/LS224_CloudTemples/Maps/",       "Cloud Temples")    },
        { "s2_metropolis",              new Tuple<string,string>("/LS225_Metropolis/Maps/",         "Metropolis")       },
        { "s2_robotica_farms",          new Tuple<string,string>("/LS226_RoboticaFarms/Maps/",      "Robotica Farms")   },
        { "s2_riptos_arena",            new Tuple<string,string>("/LS227_RiptosArena/Maps/",        "Ripto's Arena")    },
        { "s2_canyon_speedway",         new Tuple<string,string>("/LS228_CanyonSpeedway/Maps/",     "Canyon Speedway")  },
        { "s2_dragon_shores",           new Tuple<string,string>("/LS229_DragonShores/Maps/",       "Dragon Shores")    },

        // Spyro 3 maps
        { "s3_sunny_villa",             new Tuple<string,string>("/LS302_SunnyVilla/Maps/",         "Sunny Villa")          },
        { "s3_cloud_spires",            new Tuple<string,string>("/LS303_CloudSpires/Maps/",        "Cloud Spires")         },
        { "s3_molten_crater",           new Tuple<string,string>("/LS304_MoltenCrater/Maps/",       "Molten Crater")        },
        { "s3_seashell_shore",          new Tuple<string,string>("/LS305_SeashellShore/Maps/",      "Seashell Shore")       },
        { "s3_sheilas_alp",             new Tuple<string,string>("/LS306_SheilasAlp/Maps/",         "Sheila's Alp")         },
        { "s3_mushroom_speedway",       new Tuple<string,string>("/LS307_MushroomSpeedway/Maps/",   "Mushroom Speedway")    },
        { "s3_buzzs_dungeon",           new Tuple<string,string>("/LS308_BuzzsDungeon/Maps/",       "Buzz's Dungeon")       },
        { "s3_crawdad_farms",           new Tuple<string,string>("/LS309_CrawdadFarm/Maps/",        "Crawdad Farm")         },
        { "s3_icy_peak",                new Tuple<string,string>("/LS311_IcyPeak/Maps/",            "Icy Peak")             },
        { "s3_enchanted_towers",        new Tuple<string,string>("/LS312_EnchantedTowers/Maps/",    "Enchanted Towers")     },
        { "s3_spooky_swamp",            new Tuple<string,string>("/LS313_SpookySwamp/Maps/",        "Spooky Swamp")         },
        { "s3_bamboo_terrace",          new Tuple<string,string>("/LS314_BambooTerrace/Maps/",      "Bamboo Terrace")       },
        { "s3_sgt_byrds_base",          new Tuple<string,string>("/LS315_SgtByrdBase/Maps/",        "Sgt. Byrd's Base")     },
        { "s3_country_speedway",        new Tuple<string,string>("/LS316_CountrySpeedway/Maps/",    "Country Speedway")     },
        { "s3_spikes_arena",            new Tuple<string,string>("/LS317_SpikesArena/Maps/",        "Spike's Arena")        },
        { "s3_spider_town",             new Tuple<string,string>("/LS318_SpiderTown/Maps/",         "Spider Town")          },
        { "s3_lost_fleet",              new Tuple<string,string>("/LS320_LostFleet/Maps/",          "Lost Fleet")           },
        { "s3_frozen_altars",           new Tuple<string,string>("/LS321_FrozenAltars/Maps/",       "Frozen Altars")        },
        { "s3_fireworks_factory",       new Tuple<string,string>("/LS322_FireworksFactory/Maps/",   "Fireworks Factory")    },
        { "s3_charmed_ridge",           new Tuple<string,string>("/LS323_CharmedRidge/Maps/",       "Charmed Ridge")        },
        { "s3_bentleys_outpost",        new Tuple<string,string>("/LS324_BentleysOutpost/Maps/",    "Bentleys Outpost")     },
        { "s3_honey_speedway",          new Tuple<string,string>("/LS325_HoneySpeedway/Maps/",      "Honey Speedway")       },
        { "s3_scorchs_pit",             new Tuple<string,string>("/LS326_ScorchsPit/Maps/",         "Scorchs Pit")          },
        { "s3_starfish_reef",           new Tuple<string,string>("/LS327_StarfishReef/Maps/",       "Starfish Reef")        },
        { "s3_crystal_islands",         new Tuple<string,string>("/LS329_CrystalIslands/Maps/",     "Crystal Islands")      },
        { "s3_desert_ruins",            new Tuple<string,string>("/LS330_DesertRuins/Maps/",        "Desert Ruins")         },
        { "s3_haunted_tomb",            new Tuple<string,string>("/LS331_HauntedTomb/Maps/",        "Haunted Tomb")         },
        { "s3_dino_mines",              new Tuple<string,string>("/LS332_DinoMines/Maps/",          "Dino Mines")           },
        { "s3_agent_9s_lab",            new Tuple<string,string>("/LS333_Agent9sLab/Maps/",         "Agent 9's Lab")        },
        { "s3_harbor_speedway",         new Tuple<string,string>("/LS334_HarborSpeedway/Maps/",     "Harbor Speedway")      },
        { "s3_sorceress_lair",          new Tuple<string,string>("/LS335_SorceressLair/Maps/",      "Sorceress's Lair")     },
        { "s3_bugbot_factory",          new Tuple<string,string>("/LS336_BugbotFactory/Maps/",      "Bugbot Factory")       },
        { "s3_super_bonus",             new Tuple<string,string>("/LS337_SuperBonusRound/Maps/",    "Super Bonus Round")    }
    };

    // This dictionary defines which autosplits require a specific transition to be triggered, and to which map the transition must lead.
    // This is especially useful for boss fights, where leaving the level without completing it must not split (only happens in level storage contexts)
    vars.specificMapTransitions = new Dictionary<string, string> {
        { "s2_crushs_dungeon", "/LS210_AutumnPlains_Home/Maps/" },
        { "s2_gulps_overlook", "/LS222_WinterTundra_Home/Maps/" },
        { "s2_riptos_arena",   "/LS229_DragonShores/Maps/"      }
    };

    // This dictionary defines levels which are known to lead to a "null" level and thus will not split correctly. These levels are linked to 
    // the world that they lead back into - the assumption being this currently onlyoccurs for S3 Bosses
    vars.s3BossAutoSplitWhitelist = new Dictionary<string, string> {
       { "/LS308_BuzzsDungeon/Maps/", "/LS310_MiddayGardens_Home/Maps/" },
       { "/LS317_SpikesArena/Maps/", "/LS319_EveningLake_Home/Maps/" },
       { "/LS326_ScorchsPit/Maps/", "/LS328_MidnightMountain_Home/Maps/" }
    };

    // A variable which stores old.map for later use to help check the split for null levels
    vars.storedMap = null;

    settings.Add("reset", false, "Reset timer on title screen");
    settings.Add("ignore_fast_exits", true, "Ignore fast exits (time spent in level < 15s)");

    settings.Add("s1", true, "Spyro the Dragon");
        settings.Add("s1_first", true, "Level exits (first time)", "s1");
        settings.Add("s1_everytime", true, "Level exits (every time)", "s1");
//      settings.Add("s1_kill_gnasty", true, "Gnasty Gnorc (on kill)", "s1");

    settings.Add("s2", true, "Spyro 2: Ripto's Rage!");
        settings.Add("s2_first", true, "Level exits (first time)", "s2");
        settings.Add("s2_everytime", true, "Level exits (every time)", "s2");
        settings.Add("s2_enter_ripto", false, "Enter Ripto's Arena", "s2");
        settings.Add("s2_kill_ripto", true, "Ripto (on last blow) [EXPERIMENTAL]", "s2");

    settings.Add("s3", true, "Spyro: Year of the Dragon");
        settings.Add("s3_first", true, "Level exits (first time)", "s3");
        settings.Add("s3_everytime", true, "Level exits (every time)", "s3");
        settings.Add("s3_kill_sorceress", true, "Sorceress (on last blow)", "s3");

    // Initialize settings for autosplits from the map list
    foreach(KeyValuePair<string, Tuple<string,string>> entry in vars.maps)
    {
        string splitCode = entry.Key;
        string mapName = entry.Value.Item2;
        string gamePrefix = splitCode.Substring(0,2);

        settings.Add(splitCode + "_first", true, mapName, gamePrefix + "_first");
        settings.Add(splitCode + "_everytime", false, mapName, gamePrefix + "_everytime");
    }
}

init
{
    refreshRate = 30;

    if (modules.First().ModuleMemorySize == 61046784) 
    {
        print("Spyro Reignited Trilogy ASL started (game version detected: Release)");
        version = "Release";
    }
    else 
    {
        print("Spyro Reignited Trilogy ASL started (unknown game version)");
    }

    vars.alreadyTriggeredSplits = new HashSet<string>();
    vars.lastLevelExitTimestamp = 0;
}

update
{
//  print("isNotLoading = " + current.isNotLoading.ToString());
//  print("inMenu = " + current.inMenu.ToString());
//  print("inGame = " + current.inGame.ToString());
//  print("healthRipto3 = " + current.healthRipto3.ToString())
//  print("healthSorc2 = " + current.healthSorc2.ToString())
//  print("map = " + current.map.ToString());
}

start
{
    if(current.inGame == 1 && old.inGame == 0)
    {
        vars.alreadyTriggeredSplits.Clear();
        vars.lastLevelExitTimestamp = 0;
        return true;
    }
    
    return false;    
}

reset
{
    return settings["reset"] && current.inGame == 0;
}

split 
{
    // For each map...
    foreach(KeyValuePair<string, Tuple<string,string>> entry in vars.maps)
    {
        string splitCode = entry.Key;
        string mapID = entry.Value.Item1;

        // An autosplit can only happen if we were in the currently processed map, and if we aren't in it anymore.
        // If that's not the case, no need to continue.
        if(old.map != mapID || current.map == mapID || current.map == null) 
            continue;

        bool isFastExit = (timer.CurrentTime.GameTime.Value.TotalSeconds - vars.lastLevelExitTimestamp < 15);
        vars.lastLevelExitTimestamp = timer.CurrentTime.GameTime.Value.TotalSeconds;
        
        if(settings["ignore_fast_exits"] && isFastExit)
            break;

        // This autosplit needs to be verified if it's always enabled, or if it's enabled for first exit check and it has not yet been triggered.
        if(settings[splitCode + "_everytime"] || (settings[splitCode + "_first"] && !vars.alreadyTriggeredSplits.Contains(entry.Key)))
        {
            bool shouldAutosplit = true;

            // If a specific map transition is required, we autosplit only if we go from map A to map B
            if(vars.specificMapTransitions.ContainsKey(entry.Key))
                shouldAutosplit = (current.map == vars.specificMapTransitions[entry.Key]);

            //if(shouldAutosplit)
            {
                //print("Autosplitting going from map '" + old.map.ToString() + "' to map '" + current.map.ToString() + "'");
                vars.alreadyTriggeredSplits.Add(entry.Key);
                return true;
            }
        }

        break;
    }

    // Borris's way of troubleshooting, please ignore
    // print("Currently in " + current.map.ToString() + "");

    // Below section accomedates splitting from levels that lead to "null" so current.map = null which causes failure as above
	// Stores old map data in the event of a null map, useful for boss fights. 
	if (current.map == null && old.map != null)
	{	
        //print("Storing Map:" + old.map);
        vars.storedMap = old.map;
    }
	
    // If there is a stored map, it means we are waiting to enter its respective level before splitting
    if(vars.storedMap != null) 
    {
        //print("Waiting for:" + vars.s3BossAutoSplitWhitelist[vars.storedMap]);

        if(vars.s3BossAutoSplitWhitelist.ContainsKey(vars.storedMap) && current.map == vars.s3BossAutoSplitWhitelist[vars.storedMap]) 
        {
            //print("Splitting leaving:" + vars.storedMap + " and entering " + vars.s3BossAutoSplitWhitelist[vars.storedMap].ToString());

            vars.storedMap = null;
            return true;
        }
    }

    // QGC will no longer cause a double split, as stored map will dump itself if it detects a re-entry
    if(vars.storedMap != null && current.map != null)
    {
        //print("Clearing stored map: " + vars.storedMap);
        vars.storedMap = null;
    }


    // Boss final hitting splits
    if(current.map == vars.maps["s2_riptos_arena"].Item1)
    {
        // "Enter Ripto's Arena" specific handling
        if(settings["s2_enter_ripto"] && old.map != current.map)
            return true;
        
        // "Ripto (on last blow)" specific handling
        if(settings["s2_kill_ripto"] && old.healthRipto3 == 1 && current.healthRipto3 == 0)
            return true;
    }

    // Gnasty Gnorc kill specific handling
    // if(settings["s1_kill_gnasty"] && current.map == vars.maps["s1_gnasty_gnorc"].Item1)
    //     return true;

    // Sorceress (last blow) specific handling
    if(current.map == vars.maps["s3_sorceress_lair"].Item1) 
    {
		if(settings["s3_kill_sorceress"] && old.healthSorc2 == 1 && current.healthSorc2 == 0)
            return true;
    }
    
    return false;
}

isLoading 
{
	
	// Game must be loading something to pause the timer
    if(current.isNotLoading != 0)
        return false;

    // Timer must never be paused on title screen
    if(current.inGame == 0)
        return false;
    
    // Timer must not be paused when inside menu to prevent abusing this by buffering a loading and pausing the game at the exact same frame.
    // We also check that the run didn't just start, because the "inMenu" state is active during the fade to black after game is selected
    // (which would cause 0.9s to elapse on run start whereas something is indeed loading).
    if(current.inMenu > 0 && timer.CurrentTime.RealTime.Value.TotalSeconds >= 3)
        return false;

    return true;
}