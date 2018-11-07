// ------------------------------------------------------------------------------------------------------------------------------------------------
//      COLOURS
// ------------------------------------------------------------------------------------------------------------------------------------------------

        //#define COLOUR_SCHEME


        #ifdef COLOUR_SCHEME
                #define MACRO_COLOUR_BACKGROUND                                 0.11, 0.095, 0.06, 0.8
                #define MACRO_COLOUR_ELEMENT_INACTIVE                           0.8, 0.72, 0.55, 0.15
                #define MACRO_COLOUR_ELEMENT_ACTIVE                             0.8, 0.72, 0.55, 0.5
                #define MACRO_COLOUR_SEPARATOR                                  0.08, 0.07, 0.045, 0.8
//		#define MACRO_COLOUR_BACKGROUND                                 0.095, 0.11, 0.06, 0.8
//		#define MACRO_COLOUR_ELEMENT_INACTIVE                           0.72, 0.8, 0.55, 0.15
//		#define MACRO_COLOUR_ELEMENT_ACTIVE                             0.72, 0.8, 0.55, 0.4
//		#define MACRO_COLOUR_SEPARATOR                                  0.07, 0.08, 0.045, 0.8
        #else
                #define MACRO_COLOUR_BACKGROUND                                 0.1, 0.1, 0.1, 0.8
                #define MACRO_COLOUR_ELEMENT_INACTIVE                           0.7, 0.7, 0.7, 0.15
                #define MACRO_COLOUR_ELEMENT_ACTIVE                             0.7, 0.7, 0.7, 0.6
                #define MACRO_COLOUR_SEPARATOR                                  0.05, 0.05, 0.05, 0.8
        #endif

	#define MACRO_COLOUR_INVISIBLE						0, 0, 0, 0



// ------------------------------------------------------------------------------------------------------------------------------------------------
//      PICTURES
// ------------------------------------------------------------------------------------------------------------------------------------------------

        // Exit Button
        #define MACRO_PICTURE_EXIT_BUTTON                               "a3\ui_f\data\GUI\RscCommon\RscButtonSearch\search_end_ca.paa"

        // NVGs, binoculars, headgear and goggles
        #define MACRO_PICTURE_NVGS                                      "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_nvg_gs.paa"
        #define MACRO_PICTURE_HEADGEAR                                  "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_helmet_gs.paa"
        #define MACRO_PICTURE_GOGGLES                                   "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_glasses_gs.paa"
        #define MACRO_PICTURE_BINOCULARS                                "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_binocular_gs.paa"

        // Weapons
        #define MACRO_PICTURE_PRIMARYWEAPON                             "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_primary_gs.paa"
	#define MACRO_PICTURE_HANDGUNWEAPON                             "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_hgun_gs.paa"
        #define MACRO_PICTURE_SECONDARYWEAPON                           "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_secondary_gs.paa"

        // Weapon Items
        #define MACRO_PICTURE_WEAPON_MUZZLE                             "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_muzzle_gs.paa"
        #define MACRO_PICTURE_WEAPON_BIPOD                              "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_bipod_gs.paa"
        #define MACRO_PICTURE_WEAPON_SIDE                               "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_side_gs.paa"
        #define MACRO_PICTURE_WEAPON_TOP                                "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_top_gs.paa"
        #define MACRO_PICTURE_WEAPON_MAGAZINEGL                         "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_magazineGL_gs.paa"
        #define MACRO_PICTURE_WEAPON_MAGAZINE                           "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_magazine_gs.paa"

        // Assigned slots
        #define MACRO_PICTURE_MAP                                       "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_map_gs.paa"
        #define MACRO_PICTURE_GPS                                       "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_gps_gs.paa"
        #define MACRO_PICTURE_RADIO                                     "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_radio_gs.paa"
        #define MACRO_PICTURE_COMPASS                                   "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_compass_gs.paa"
        #define MACRO_PICTURE_WATCH                                     "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_watch_gs.paa"

	// Uniform, vest and backpack
	#define MACRO_PICTURE_UNIFORM                                   "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_uniform_gs.paa"
	#define MACRO_PICTURE_VEST                                      "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_vest_gs.paa"
	#define MACRO_PICTURE_BACKPACK                                  "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_backpack_gs.paa"

        // Medical menu
        #define MACRO_PICTURE_CHARACTER_OUTLINE                         "res\ui\inventory\character.paa"

	// Slot background
	#define MACRO_PICTURE_SLOT_BACKGROUND				"res\ui\inventory\Slot background.paa"





// ------------------------------------------------------------------------------------------------------------------------------------------------
//      IDCS
// ------------------------------------------------------------------------------------------------------------------------------------------------

	// Ground
	#define MACRO_IDC_GROUND_CTRLGRP                                1000
	#define MACRO_IDC_GROUND_FOCUS_FRAME                            1001

	// Weapons / Medical
	#define MACRO_IDC_WEAPONS_CTRLGRP                               2000
	#define MACRO_IDC_MEDICAL_CTRLGRP                               2001
	#define MACRO_IDC_WEAPONS_FOCUS_FRAME                           2002
	#define MACRO_IDC_MEDICAL_FOCUS_FRAME                           2003

        // PLayer info
        #define MACRO_IDC_PLAYER_NAME                                   2101

        // Weapons / Medical buttons
        #define MACRO_IDC_WEAPONS_BUTTON_FRAME                          2102
        #define MACRO_IDC_WEAPONS_BUTTON                                2103
        #define MACRO_IDC_MEDICAL_BUTTON_FRAME                          2104
        #define MACRO_IDC_MEDICAL_BUTTON                                2105

	// Character (Weapons)
        #define MACRO_IDC_CHARACTER_WEAPONS_ICON                        2201

        // NVGs, binoculars, headgear and goggles
	#define MACRO_IDC_NVGS_FRAME                                    2202
        #define MACRO_IDC_NVGS_ICON                                     2203
	#define MACRO_IDC_HEADGEAR_FRAME                                2204
        #define MACRO_IDC_HEADGEAR_ICON                                 2205
	#define MACRO_IDC_GOGGLES_FRAME                                 2206
        #define MACRO_IDC_GOGGLES_ICON                                  2207
	#define MACRO_IDC_BINOCULARS_FRAME                              2208
        #define MACRO_IDC_BINOCULARS_ICON                               2209

        // Primary Weapon
        #define MACRO_IDC_PRIMARYWEAPON_FRAME                           2301
        #define MACRO_IDC_PRIMARYWEAPON_ICON                            2302

        // Handgun Weapon
        #define MACRO_IDC_HANDGUNWEAPON_FRAME                           2311
        #define MACRO_IDC_HANDGUNWEAPON_ICON                            2312

        // Secondary Weapon
        #define MACRO_IDC_SECONDARYWEAPON_FRAME                         2321
        #define MACRO_IDC_SECONDARYWEAPON_ICON                          2322

        // Assigned slots
	#define MACRO_IDC_MAP_FRAME                                     2401
        #define MACRO_IDC_MAP_ICON                                      2402
	#define MACRO_IDC_GPS_FRAME                                     2403
        #define MACRO_IDC_GPS_ICON                                      2404
	#define MACRO_IDC_RADIO_FRAME                                   2405
        #define MACRO_IDC_RADIO_ICON                                    2406
	#define MACRO_IDC_COMPASS_FRAME                                 2407
        #define MACRO_IDC_COMPASS_ICON                                  2408
	#define MACRO_IDC_WATCH_FRAME                                   2409
        #define MACRO_IDC_WATCH_ICON                                    2410

	// Character (Medical)
        #define MACRO_IDC_CHARACTER_MEDICAL_ICON                        2501

	// Storage
	#define MACRO_IDC_STORAGE_CTRLGRP                               3000
	#define MACRO_IDC_STORAGE_FOCUS_FRAME                           3001

	// Uniform, vest and backpack
	#define MACRO_IDC_UNIFORM_FRAME                                 3101
	#define MACRO_IDC_UNIFORM_ICON                                  3102
	#define MACRO_IDC_VEST_FRAME                                    3103
	#define MACRO_IDC_VEST_ICON                                     3104
	#define MACRO_IDC_BACKPACK_FRAME                                3105
	#define MACRO_IDC_BACKPACK_ICON                                 3106
	#define MACRO_IDC_SCROLLBAR_DUMMY                               3107

	// Empty control group (for focus)
	#define MACRO_IDC_EMPTY_CTRLGROUP				4000
	#define MACRO_IDC_EMPTY_FOCUS_FRAME				4001

	// Temporary frame and picture
	#define MACRO_IDC_DRAGGING_FRAME				4101
	#define MACRO_IDC_DRAGGING_PICTURE_ICON				4102
	#define MACRO_IDC_DRAGGING_PICTURE_ATTACHMENT_MUZZLE		4103
	#define MACRO_IDC_DRAGGING_PICTURE_ATTACHMENT_BIPOD		4104
	#define MACRO_IDC_DRAGGING_PICTURE_ATTACHMENT_RAIL		4105
	#define MACRO_IDC_DRAGGING_PICTURE_ATTACHMENT_OPTIC		4106
	#define MACRO_IDC_DRAGGING_PICTURE_ATTACHMENT_MAGAZINE		4107
	#define MACRO_IDC_DRAGGING_PICTURE_ATTACHMENT_ALTMAGAZINE	4108
	#define MACRO_IDC_SCRIPTEDFRAME					4111
        #define MACRO_IDC_SCRIPTEDPICTURE				4112





// ------------------------------------------------------------------------------------------------------------------------------------------------
//      UI ELEMENT POSITIONING AND SCALING
// ------------------------------------------------------------------------------------------------------------------------------------------------

	#define MACRO_POS_SEPARATOR_GROUND				0.35
	#define MACRO_POS_SEPARATOR_STORAGE				0.65

	#define MACRO_SCALE_SLOT_SIZE_W					0.033 * 0.84
	#define MACRO_SCALE_SLOT_SIZE_H					0.055 * 0.84
	#define MACRO_SCALE_SLOT_COUNT_PER_LINE				12





// ------------------------------------------------------------------------------------------------------------------------------------------------
//      ITEM TYPES
// ------------------------------------------------------------------------------------------------------------------------------------------------

        #define MACRO_ENUM_CATEGORY_ITEM                                0
        #define MACRO_ENUM_CATEGORY_WEAPON                              1
        #define MACRO_ENUM_CATEGORY_MAGAZINE                            2
        #define MACRO_ENUM_CATEGORY_VEHICLE                             3
        #define MACRO_ENUM_CATEGORY_GLASSES                             4





// ------------------------------------------------------------------------------------------------------------------------------------------------
//      MACRO FUNCTIONS
// ------------------------------------------------------------------------------------------------------------------------------------------------

        #define CURLY(DATA) {##DATA##}
        #define SQUARE(DATA) [##DATA##]
	#define STR(DATA) #DATA






// ------------------------------------------------------------------------------------------------------------------------------------------------
//      DEV / DEBUGGING
// ------------------------------------------------------------------------------------------------------------------------------------------------

        // Debug toggles - uncomment to enable debug outputs in the respective script
	//#define MACRO_DEBUG_GETCLASSICON




// ------------------------------------------------------------------------------------------------------------------------------------------------
//      OTHERS / EXTRAS
// ------------------------------------------------------------------------------------------------------------------------------------------------

        // Overall inventory storage capacity scaling
        #define MACRO_STORAGE_CAPACITY_MULTIPLIER                       0.5

	// Name of the UI
	#define MACRO_GUI_NAME                                         Rsc_Cre8ive_Inventory

	// Determine which config file the UI is defined in (mission or addon format)
	#define MACRO_CONFIG_FILE_SWITCH

	#ifdef MACRO_CONFIG_FILE_SWITCH
		#define MACRO_CONFIG_FILE missionConfigFile
	#else
		#define MACRO_CONFIG_FILE configFile
	#endif
