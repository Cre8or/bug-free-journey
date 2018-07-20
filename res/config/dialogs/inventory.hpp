__EXEC(_safeZoneMul = 5)
__EXEC(_safeZoneW = safeZoneW / _safeZoneMul - 1 / _safeZoneMul + 1)
__EXEC(_safeZoneH = safeZoneH / _safeZoneMul - 1 / _safeZoneMul + 1)
__EXEC(_safeZoneX = safeZoneX / _safeZoneMul)
__EXEC(_safeZoneY = safeZoneY / _safeZoneMul)





#include "macros.hpp"





class Rsc_Cre8ive_Inventory {
        idd = 888801;
        name = "Rsc_Cre8ive_Inventory";
        onLoad = "uiNamespace setVariable ['cre8ive_dialog_inventory', _this select 0]";

        class Controls {
                class Ground_Frame : RscBox {
                        idc = -1;
                        x = "_safeZoneX";
                        y = "_safeZoneY";
                        w = "_safeZoneW * (0.35 - 0.002)";
                        h = "_safeZoneH";
                        colorBackground[] = CURLY(MACRO_COLOUR_BACKGROUND);
                };

                class Storage_Frame : Ground_Frame {
                        x = "_safeZoneX + _safeZoneW * (0.65 + 0.002)";
                };

                class Weapons_Frame : Ground_Frame {
                        x = "_safeZoneX + _safeZoneW * (0.35 + 0.002)";
                        w = "_safeZoneW * (0.3 - 0.004)";
		};

                // ------------------------------------------------------------------------------------------------------------------------------------------------
                // Player Info
                class Player_Name_Frame : RscBox {
                        idc = -1;
                        x = "_safeZoneX + _safeZoneW * (0.35 + 0.002)";
                        y = "_safeZoneY";
                        w = "_safeZoneW * (0.3 - 0.004)";
                        h = "_safeZoneH * 0.04";
                        colorBackground[] = CURLY(MACRO_COLOUR_SEPARATOR);
                };

                class Player_Name : RscText {
                        idc = MACRO_IDC_PLAYER_NAME;
                        font = "PuristaLight";
                        text = "";
                        sizeEx = "_safeZoneW * 0.03";
                        style = ST_LEFT;
                        x = "_safeZoneX + _safeZoneW * (0.35 + 0.002)";
                        y = "_safeZoneY";
                        w = "_safeZoneW * (0.27 - 0.002)";
                        h = "_safeZoneH * 0.04";
                        colorBackground[] = {0,0,0,0};
                };

                class Exit_Button_Picture : RscPicture {
                        idc = -1;
                        text = MACRO_PICTURE_EXIT_BUTTON;
                        style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
                        x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 + 0.27)";
                        y = "_safeZoneY";
                        w = "_safeZoneW * (0.03 - 0.004)";
                        h = "_safeZoneH * 0.04";
                };

                class Exit_Button : RscButton {
                        idc = MACRO_IDC_WEAPONS_BUTTON;
                        period = 0;
                        offsetX = 0;
                        offsetY = 0;
                        offsetPressedX = 0;
                        offsetPressedY = 0;
                        shadow = 0;
                        x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 + 0.27)";
                        y = "_safeZoneY";
                        w = "_safeZoneW * (0.03 - 0.004)";
                        h = "_safeZoneH * 0.04";
                        colorBackground[] = {0,0,0,0};
                        colorBackgroundActive[] = {1,0,0,0.2};
                        colorShadow[] = {0,0,0,0};
                        colorText[] = {1,1,1,1};
                        action = "(uiNamespace getVariable ['cre8ive_dialog_inventory', displayNull]) closeDisplay 0";
                };

                // ------------------------------------------------------------------------------------------------------------------------------------------------
                // TOP SLOTS
                        // NVGs
                        class NVGs_Frame : RscText {
                                idc = MACRO_IDC_NVGS_FRAME;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 3)";
                                y = "_safeZoneY + _safeZoneH * (0.12 + 0.005)";
                                w = "_safeZoneW * 0.0705";
                                h = "_safeZoneH * 0.105";
                                colorBackground[] = CURLY(MACRO_COLOUR_ELEMENT_INACTIVE);
                        };

                        class NVGs_Picture : RscPicture {
                                idc = MACRO_IDC_NVGS_ICON;
                                text = MACRO_PICTURE_NVGS;
                                style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 3)";
                                y = "_safeZoneY + _safeZoneH * (0.12 + 0.005)";
                                w = "_safeZoneW * 0.0705";
                                h = "_safeZoneH * 0.105";
                        };

                        // Headgear
                        class Headgear_Frame : NVGs_Frame {
                                idc = MACRO_IDC_HEADGEAR_FRAME;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 4 + 0.0705 * 1)";
                        };

                        class Headgear_Picture : NVGs_Picture {
                                idc = MACRO_IDC_HEADGEAR_ICON;
                                text = MACRO_PICTURE_HEADGEAR;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 4 + 0.0705 * 1)";
                        };

                        // Goggles
                        class Goggles_Frame : NVGs_Frame {
                                idc = MACRO_IDC_GOGGLES_FRAME;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 5 + 0.0705 * 2)";
                        };

                        class Goggles_Picture : NVGs_Picture {
                                idc = MACRO_IDC_GOGGLES_ICON;
                                text = MACRO_PICTURE_GOGGLES;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 5 + 0.0705 * 2)";
                        };

                        // Binoculars
                        class Binoculars_Frame : NVGs_Frame {
                                idc = MACRO_IDC_BINOCULARS_FRAME;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 6 + 0.0705 * 3)";
                        };

                        class Binoculars_Picture : NVGs_Picture {
                                idc = MACRO_IDC_BINOCULARS_ICON;
                                text = MACRO_PICTURE_BINOCULARS;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 6 + 0.0705 * 3)";
                        };

                // ------------------------------------------------------------------------------------------------------------------------------------------------
                // WEAPONS
                        // Primary Weapon
                        class PrimaryWeapon_Frame : RscText {
                                idc = MACRO_IDC_PRIMARYWEAPON_FRAME;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 3)";
                                y = "_safeZoneY + _safeZoneH * 0.3";
                                w = "_safeZoneW * (0.3 - 0.004 * 3)";
                                h = "_safeZoneH * 0.175";
                                colorBackground[] = CURLY(MACRO_COLOUR_ELEMENT_INACTIVE);
				onMouseButtonDown = "['dragging_start', _this] call cre_fnc_inventory";
				onMouseButtonUp = "['dragging_stop', _this] call cre_fnc_inventory";
                        };

                        class PrimaryWeapon_Picture : RscPicture {
                                idc = MACRO_IDC_PRIMARYWEAPON_ICON;
                                text = MACRO_PICTURE_PRIMARYWEAPON;
                                style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 3)";
                                y = "_safeZoneY + _safeZoneH * 0.3";
                                w = "_safeZoneW * (0.3 - 0.004 * 3)";
                                h = "_safeZoneH * 0.175";
                        };

                        // Handgun weapon
                        class HandgunWeapon_Frame : PrimaryWeapon_Frame {
                                idc = MACRO_IDC_HANDGUNWEAPON_FRAME;
                                y = "_safeZoneY + _safeZoneH * (0.3 + 0.18 * 1)";
                        };

                        class HandgunWeapon_Picture : PrimaryWeapon_Picture {
                                idc = MACRO_IDC_HANDGUNWEAPON_ICON;
                                text = MACRO_PICTURE_HANDGUNWEAPON;
                                y = "_safeZoneY + _safeZoneH * (0.3 + 0.18 * 1)";
                        };

                        // Secondary weapon
                        class SecondaryWeapon_Frame : PrimaryWeapon_Frame {
                                idc = MACRO_IDC_SECONDARYWEAPON_FRAME;
                                y = "_safeZoneY + _safeZoneH * (0.3 + 0.18 * 2)";
                        };

                        class SecondaryWeapon_Picture : PrimaryWeapon_Picture {
                                idc = MACRO_IDC_SECONDARYWEAPON_ICON;
                                text = MACRO_PICTURE_SECONDARYWEAPON;
                                y = "_safeZoneY + _safeZoneH * (0.3 + 0.18 * 2)";
                        };

                // ------------------------------------------------------------------------------------------------------------------------------------------------
                // BOTTOM SLOTS
                        // Map
                        class Map_Frame : RscText {
                                idc = MACRO_IDC_MAP_FRAME;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 3)";
                                y = "_safeZoneY + _safeZoneH * 0.91)";
                                w = "_safeZoneW * 0.056";
                                h = "_safeZoneH * 0.085";
                                colorBackground[] = CURLY(MACRO_COLOUR_ELEMENT_INACTIVE);
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
                        class GPS_Frame : Map_Frame {
                                idc = MACRO_IDC_GPS_FRAME;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 4 + 0.056 * 1)";
                        };

                        class GPS_Picture : Map_Picture {
                                idc = MACRO_IDC_GPS_ICON;
                                text = MACRO_PICTURE_GPS;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 4 + 0.056 * 1)";
                        };

                        // Radio
                        class Radio_Frame : Map_Frame {
                                idc = MACRO_IDC_RADIO_FRAME;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 5 + 0.056 * 2)";
                        };

                        class Radio_Picture : Map_Picture {
                                idc = MACRO_IDC_RADIO_ICON;
                                text = MACRO_PICTURE_RADIO;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 5 + 0.056 * 2)";
                        };

                        // Compass
                        class Compass_Frame : Map_Frame {
                                idc = MACRO_IDC_COMPASS_FRAME;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 6 + 0.056 * 3)";
                        };

                        class Compass_Picture : Map_Picture {
                                idc = MACRO_IDC_COMPASS_ICON;
                                text = MACRO_PICTURE_COMPASS;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 6 + 0.056 * 3)";
                        };

                        // Watch
                        class Watch_Frame : Map_Frame {
                                idc = MACRO_IDC_WATCH_FRAME;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 7 + 0.056 * 4)";
                        };

                        class Watch_Picture : Map_Picture {
                                idc = MACRO_IDC_WATCH_ICON;
                                text = MACRO_PICTURE_WATCH;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 7 + 0.056 * 4)";
                        };

                // ------------------------------------------------------------------------------------------------------------------------------------------------
                // Character
                class Character_Outline : RscPicture {
                        idc = MACRO_IDC_CHARACTER_ICON;
                        text = MACRO_PICTURE_CHARACTER_OUTLINE;
                        style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
                        x = "_safeZoneX";
                        y = "_safeZoneY + _safeZoneH * 0.1";
                        w = "_safeZoneW";
                        h = "_safeZoneH * 0.9";
                        colorText[] = {1,1,1,0.5};
                };

                // ------------------------------------------------------------------------------------------------------------------------------------------------
                // Weapons / Medical buttons
                        // Weapons
                        class Weapons_Button_Frame : RscText {
                                idc = MACRO_IDC_WEAPONS_BUTTON_FRAME;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 3)";
                                y = "_safeZoneY + _safeZoneH * (0.04 + 0.005)";
                                w = "_safeZoneW * 0.143";
                                h = "_safeZoneH * 0.075";
                                colorBackground[] = CURLY(MACRO_COLOUR_ELEMENT_ACTIVE);
                        };

                        class Weapons_Button : RscButton {
                                idc = MACRO_IDC_WEAPONS_BUTTON;
                                font = "PuristaMedium";
                                period = 0;
                                offsetX = 0;
                                offsetY = 0;
                                offsetPressedX = "_safeZoneW * 0.001";
                                offsetPressedY = "_safeZoneH * 0.002";
                                shadow = 0;
                                sizeEx = "_safeZoneW * 0.03";
                                text = "WEAPONS";
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 3)";
                                y = "_safeZoneY + _safeZoneH * (0.04 + 0.005)";
                                w = "_safeZoneW * 0.143";
                                h = "_safeZoneH * 0.075";
                                colorBackground[] = {0,0,0,0};
                                colorBackgroundActive[] = {0,0,0,0};
                                colorShadow[] = {0,0,0,0};
                                colorText[] = {1,1,1,1};
                                action = "['menu_weapons'] call cre_fnc_inventory";
                        };

                        // Medical
                        class Medical_Button_Frame : Weapons_Button_Frame {
                                idc = MACRO_IDC_MEDICAL_BUTTON_FRAME;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 4 + 0.143)";
                                colorBackground[] = CURLY(MACRO_COLOUR_ELEMENT_INACTIVE);
                        };

                        class Medical_Button : Weapons_Button {
                                idc = MACRO_IDC_MEDICAL_BUTTON;
                                text = "MEDICAL";
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 4 + 0.143)";
                                action = "['menu_medical'] call cre_fnc_inventory";
                        };

        };
};
