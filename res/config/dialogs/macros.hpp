// ------------------------------------------------------------------------------------------------------------------------------------------------
//      COLOURS
// ------------------------------------------------------------------------------------------------------------------------------------------------

        //#define COLOUR_SCHEME

        #ifdef COLOUR_SCHEME
                #define MACRO_COLOUR_BACKGROUND                                 0.11, 0.095, 0.06, 0.8
                #define MACRO_COLOUR_ELEMENT_INACTIVE                           0.8, 0.72, 0.55, 0.15
                #define MACRO_COLOUR_ELEMENT_ACTIVE                             0.8, 0.72, 0.55, 0.6
        #else
                #define MACRO_COLOUR_BACKGROUND                                 0.1, 0.1, 0.1, 0.8
                #define MACRO_COLOUR_ELEMENT_INACTIVE                           0.7, 0.7, 0.7, 0.15
                #define MACRO_COLOUR_ELEMENT_ACTIVE                             0.7, 0.7, 0.7, 0.6
        #endif





// ------------------------------------------------------------------------------------------------------------------------------------------------
//      PICTURES
// ------------------------------------------------------------------------------------------------------------------------------------------------

        // NVGs, binoculars, headgear and goggles
        #define MACRO_PICTURE_NVGS                                      "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_nvg_gs.paa"
        #define MACRO_PICTURE_HEADGEAR                                  "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_helmet_gs.paa"
        #define MACRO_PICTURE_GOGGLES                                   "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_glasses_gs.paa"
        #define MACRO_PICTURE_BINOCULARS                                "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_binocular_gs.paa"

        // Weapons
        #define MACRO_PICTURE_PRIMARYWEAPON                             "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_primary_gs.paa"
        #define MACRO_PICTURE_SECONDARYWEAPON                           "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_secondary_gs.paa"
        #define MACRO_PICTURE_HANDGUNWEAPON                             "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_hgun_gs.paa"

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


// ------------------------------------------------------------------------------------------------------------------------------------------------
//      IDCS
// ------------------------------------------------------------------------------------------------------------------------------------------------

        // NVGs, binoculars, headgear and goggles
        #define MACRO_IDC_NVGS_FRAME                                    101
        #define MACRO_IDC_NVGS_ICON                                     102
        #define MACRO_IDC_HEADGEAR_FRAME                                103
        #define MACRO_IDC_HEADGEAR_ICON                                 104
        #define MACRO_IDC_GOGGLES_FRAME                                 105
        #define MACRO_IDC_GOGGLES_ICON                                  106
        #define MACRO_IDC_BINOCULARS_FRAME                              107
        #define MACRO_IDC_BINOCULARS_ICON                               108

        // Primary Weapon
        #define MACRO_IDC_PRIMARYWEAPON_FRAME                           201
        #define MACRO_IDC_PRIMARYWEAPON_ICON                            202

        // Secondary Weapon
        #define MACRO_IDC_SECONDARYWEAPON_FRAME                         203
        #define MACRO_IDC_SECONDARYWEAPON_ICON                          204

        // Handgun Weapon
        #define MACRO_IDC_HANDGUNWEAPON_FRAME                           205
        #define MACRO_IDC_HANDGUNWEAPON_ICON                            206

        // Assigned slots
        #define MACRO_IDC_MAP_FRAME                                     301
        #define MACRO_IDC_MAP_ICON                                      302
        #define MACRO_IDC_GPS_FRAME                                     303
        #define MACRO_IDC_GPS_ICON                                      304
        #define MACRO_IDC_RADIO_FRAME                                   305
        #define MACRO_IDC_RADIO_ICON                                    306
        #define MACRO_IDC_COMPASS_FRAME                                 307
        #define MACRO_IDC_COMPASS_ICON                                  308
        #define MACRO_IDC_WATCH_FRAME                                   309
        #define MACRO_IDC_WATCH_ICON                                    310


// ------------------------------------------------------------------------------------------------------------------------------------------------
//      MACRO FUNCTIONS
// ------------------------------------------------------------------------------------------------------------------------------------------------
        #define CURLY(DATA) {##DATA##}
        #define SQUARE(DATA) [##DATA##]
