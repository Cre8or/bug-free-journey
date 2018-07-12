__EXEC(_safeZoneMul = 5)
__EXEC(_safeZoneW = safeZoneW / _safeZoneMul - 1 / _safeZoneMul + 1)
__EXEC(_safeZoneH = safeZoneH / _safeZoneMul - 1 / _safeZoneMul + 1)
__EXEC(_safeZoneX = safeZoneX / _safeZoneMul)
__EXEC(_safeZoneY = safeZoneY / _safeZoneMul)





#include "macros.hpp"





class Rsc_Cre8ive_Inventory {
        idd = 888801;
        enableSimulation = 1;
        movingEnable = 0;
        name = "Rsc_Cre8ive_Inventory";
        onLoad = "uiNamespace setVariable ['cre8ive_dialog_inventory', _this select 0]";

        class controls {

                class Ground_Background : RscBox {
                        idc = -1;
                        x = "_safeZoneX";
                        y = "_safeZoneY";
                        w = "_safeZoneW * (0.35 - 0.002)";
                        h = "_safeZoneH";
                        colorBackground[] = MACRO_COLOUR_BACKGROUND;
                };

                // ------------------------------------------------------------------------------------------------------------------------------------------------
                // Character
                class Character_Background : RscBox {
                        idc = -1;
                        x = "_safeZoneX + _safeZoneW * (0.35 + 0.002)";
                        y = "_safeZoneY";
                        w = "_safeZoneW * (0.3 - 0.004)";
                        h = "_safeZoneH";
                        colorBackground[] = MACRO_COLOUR_BACKGROUND;
                };

                class Character_Outline : RscPicture {
                        idc = -1;
                        text = "res\ui\inventory\character.paa";
                        style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
                        x = "_safeZoneX";
                        y = "_safeZoneY + _safeZoneH * 0.1";
                        w = "_safeZoneW";
                        h = "_safeZoneH * 0.5";
                        colorText[] = {1,1,1,0};
                };

                // ------------------------------------------------------------------------------------------------------------------------------------------------
                // WEAPONS
                        // Primary Weapon
                        class PrimaryWeapon_Background : RscBox {
                                idc = -1;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 3)";
                                y = "_safeZoneY + _safeZoneH * 0.28";
                                w = "_safeZoneW * (0.3 - 0.004 * 3)";
                                h = "_safeZoneH * 0.175";
                                colorBackground[] = MACRO_COLOUR_ELEMENT_INACTIVE;
                        };

                        class PrimaryWeapon_Picture : RscPicture {
                                idc = MACRO_IDC_PRIMARYWEAPON_ICON;
                                text = MACRO_PICTURE_PRIMARYWEAPON;
                                style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 3)";
                                y = "_safeZoneY + _safeZoneH * 0.28";
                                w = "_safeZoneW * (0.3 - 0.004 * 3)";
                                h = "_safeZoneH * 0.175";
                        };

                        // Secondary weapon
                        class SecondaryWeapon_Background : PrimaryWeapon_Background {
                                y = "_safeZoneY + _safeZoneH * (0.28 + 0.18 * 1)";
                                colorBackground[] = MACRO_COLOUR_ELEMENT_ACTIVE;
                        };

                        class SecondaryWeapon_Picture : PrimaryWeapon_Picture {
                                idc = MACRO_IDC_SECONDARYWEAPON_ICON;
                                text = MACRO_PICTURE_SECONDARYWEAPON;
                                y = "_safeZoneY + _safeZoneH * (0.28 + 0.18 * 1)";
                        };

                        // Handgun weapon
                        class HandgunWeapon_Background : PrimaryWeapon_Background {
                                y = "_safeZoneY + _safeZoneH * (0.28 + 0.18 * 2)";
                        };

                        class HandgunWeapon_Picture : PrimaryWeapon_Picture {
                                idc = MACRO_IDC_HANDGUNWEAPON_ICON;
                                text = MACRO_PICTURE_HANDGUNWEAPON;
                                y = "_safeZoneY + _safeZoneH * (0.28 + 0.18 * 2)";
                        };

                // ------------------------------------------------------------------------------------------------------------------------------------------------
                // TOP SLOTS
                        // NVGs
                        class NVGs_Background : RscBox {
                                idc = -1;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 3)";
                                y = "_safeZoneY + _safeZoneH * (0.08 + 0.005)";
                                w = "_safeZoneW * 0.0705";
                                h = "_safeZoneH * 0.105";
                                colorBackground[] = MACRO_COLOUR_ELEMENT_INACTIVE;
                        };

                        class NVGs_Picture : RscPicture {
                                idc = MACRO_IDC_NVGS_ICON;
                                text = MACRO_PICTURE_NVGS;
                                style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 3)";
                                y = "_safeZoneY + _safeZoneH * (0.08 + 0.005)";
                                w = "_safeZoneW * 0.0705";
                                h = "_safeZoneH * 0.105";
                        };

                        // Headgear
                        class Headgear_Background : NVGs_Background {
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 4 + 0.0705 * 1)";
                        };

                        class Headgear_Picture : NVGs_Picture {
                                idc = MACRO_IDC_HEADGEAR_ICON;
                                text = MACRO_PICTURE_HEADGEAR;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 4 + 0.0705 * 1)";
                        };

                        // Goggles
                        class Goggles_Background : NVGs_Background {
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 5 + 0.0705 * 2)";
                        };

                        class Goggles_Picture : NVGs_Picture {
                                idc = MACRO_IDC_GOGGLES_ICON;
                                text = MACRO_PICTURE_GOGGLES;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 5 + 0.0705 * 2)";
                        };

                        // Binoculars
                        class Binoculars_Background : NVGs_Background {
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 6 + 0.0705 * 3)";
                        };

                        class Binoculars_Picture : NVGs_Picture {
                                idc = MACRO_IDC_BINOCULARS_ICON;
                                text = MACRO_PICTURE_BINOCULARS;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 6 + 0.0705 * 3)";
                        };

                // ------------------------------------------------------------------------------------------------------------------------------------------------
                // BOTTOM SLOTS
                        // Map
                        class Map_Background : RscBox {
                                idc = -1;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 3)";
                                y = "_safeZoneY + _safeZoneH * 0.91)";
                                w = "_safeZoneW * 0.056";
                                h = "_safeZoneH * 0.085";
                                colorBackground[] = MACRO_COLOUR_ELEMENT_INACTIVE;
                        };

                        class Map_Picture : RscPicture {
                                idc = MACRO_IDC_MAP_ICON;
                                text = MACRO_PICTURE_MAP;
                                style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 3)";
                                y = "_safeZoneY + _safeZoneH * 0.91)";
                                w = "_safeZoneW * 0.056";
                                h = "_safeZoneH * 0.085";
                        };

                        // GPS
                        class GPS_Background : Map_Background {
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 4 + 0.056 * 1)";
                        };

                        class GPS_Picture : Map_Picture {
                                idc = MACRO_IDC_GPS_ICON;
                                text = MACRO_PICTURE_GPS;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 4 + 0.056 * 1)";
                        };

                        // Radio
                        class Radio_Background : Map_Background {
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 5 + 0.056 * 2)";
                        };

                        class Radio_Picture : Map_Picture {
                                idc = MACRO_IDC_RADIO_ICON;
                                text = MACRO_PICTURE_RADIO;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 5 + 0.056 * 2)";
                        };

                        // Compass
                        class Compass_Background : Map_Background {
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 6 + 0.056 * 3)";
                        };

                        class Compass_Picture : Map_Picture {
                                idc = MACRO_IDC_COMPASS_ICON;
                                text = MACRO_PICTURE_COMPASS;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 6 + 0.056 * 3)";
                        };

                        // Watch
                        class Watch_Background : Map_Background {
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 7 + 0.056 * 4)";
                        };

                        class Watch_Picture : Map_Picture {
                                idc = MACRO_IDC_WATCH_ICON;
                                text = MACRO_PICTURE_WATCH;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 7 + 0.056 * 4)";
                        };

        };
};
