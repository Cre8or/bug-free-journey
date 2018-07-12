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
                // Primary Weapon
                class PrimaryWeapon_Background : RscBox {
                        idc = -1;
                        x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 3)";
                        y = "_safeZoneY + _safeZoneH * 0.31";
                        w = "_safeZoneW * (0.3 - 0.004 * 3)";
                        h = "_safeZoneH * 0.145";
                        colorBackground[] = MACRO_COLOUR_BACKGROUND_ELEMENT;
                };

                class PrimaryWeapon_Picture : RscPicture {
                        idc = MACRO_IDC_PRIMARYWEAPON_PICTURE;
                        text = MACRO_PICTURE_PRIMARYWEAPON;
                        style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
                        x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 3)";
                        y = "_safeZoneY + _safeZoneH * 0.31";
                        w = "_safeZoneW * (0.3 - 0.004 * 3)";
                        h = "_safeZoneH * 0.145";
                };

                        // Muzzle
                        class PrimaryWeapon_Muzzle_Background : RscBox {
                                idc = -1;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 3)";
                                y = "_safeZoneY + _safeZoneH * 0.46";
                                w = "_safeZoneW * 0.04633";
                                h = "_safeZoneH * 0.07";
                                colorBackground[] = MACRO_COLOUR_BACKGROUND_ELEMENT;
                        };

                        class PrimaryWeapon_Muzzle_Picture : RscPicture {
                                idc = MACRO_IDC_PRIMARYWEAPON_MUZZLE_PICTURE;
                                text = MACRO_PICTURE_WEAPON_MUZZLE;
                                style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 3)";
                                y = "_safeZoneY + _safeZoneH * 0.46";

                                w = "_safeZoneW * 0.04633";
                                h = "_safeZoneH * 0.07";
                        };

                        // Bipod
                        class PrimaryWeapon_Bipod_Background : PrimaryWeapon_Muzzle_Background {
                                idc = -1;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 4 + 0.04633)";
                        };

                        class PrimaryWeapon_Bipod_Picture : PrimaryWeapon_Muzzle_Picture {
                                idc = MACRO_IDC_PRIMARYWEAPON_BIPOD_PICTURE;
                                text = MACRO_PICTURE_WEAPON_BIPOD;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 4 + 0.04633)";
                        };

                        // Side
                        class PrimaryWeapon_Side_Background : PrimaryWeapon_Muzzle_Background {
                                idc = -1;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 5 + 0.04633 * 2)";
                        };

                        class PrimaryWeapon_Side_Picture : PrimaryWeapon_Muzzle_Picture {
                                idc = MACRO_IDC_PRIMARYWEAPON_SIDE_PICTURE;
                                text = MACRO_PICTURE_WEAPON_SIDE;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 5 + 0.04633 * 2)";
                        };

                        // Top
                        class PrimaryWeapon_Top_Background : PrimaryWeapon_Muzzle_Background {
                                idc = -1;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 6 + 0.04633 * 3)";
                        };

                        class PrimaryWeapon_Top_Picture : PrimaryWeapon_Muzzle_Picture {
                                idc = MACRO_IDC_PRIMARYWEAPON_TOP_PICTURE;
                                text = MACRO_PICTURE_WEAPON_TOP;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 6 + 0.04633 * 3)";
                        };

                        // Magazine GL
                        class PrimaryWeapon_MagazineGL_Background : PrimaryWeapon_Muzzle_Background {
                                idc = -1;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 7 + 0.04633 * 4)";
                        };

                        class PrimaryWeapon_MagazineGL_Picture : PrimaryWeapon_Muzzle_Picture {
                                idc = MACRO_IDC_PRIMARYWEAPON_MAGAZINEGL_PICTURE;
                                text = MACRO_PICTURE_WEAPON_MAGAZINEGL;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 7 + 0.04633 * 4)";
                        };

                        // Magazine
                        class PrimaryWeapon_Magazine_Background : PrimaryWeapon_Muzzle_Background {
                                idc = -1;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 8 + 0.04633 * 5)";
                        };

                        class PrimaryWeapon_Magazine_Picture : PrimaryWeapon_Muzzle_Picture {
                                idc = MACRO_IDC_PRIMARYWEAPON_MAGAZINE_PICTURE;
                                text = MACRO_PICTURE_WEAPON_MAGAZINE;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 8 + 0.04633 * 5)";
                        };

                // ------------------------------------------------------------------------------------------------------------------------------------------------
                // Secondary weapon
                class SecondaryWeapon_Background : RscBox {
                        idc = -1;
                        x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 3)";
                        y = "_safeZoneY + _safeZoneH * 0.54";
                        w = "_safeZoneW * (0.3 - 0.004 * 3)";
                        h = "_safeZoneH * 0.145";
                        colorBackground[] = MACRO_COLOUR_BACKGROUND_ELEMENT;
                };

                class SecondaryWeapon_Picture : RscPicture {
                        idc = -1;
                        text = MACRO_PICTURE_SECONDARYWEAPON;
                        style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
                        x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 3)";
                        y = "_safeZoneY + _safeZoneH * 0.54";
                        w = "_safeZoneW * (0.3 - 0.004 * 3)";
                        h = "_safeZoneH * 0.145";
                };

                        // Muzzle
                        class SecondaryWeapon_Muzzle_Background : RscBox {
                                idc = -1;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 3.5 + 0.04633 * 0.5)";
                                y = "_safeZoneY + _safeZoneH * 0.69";
                                w = "_safeZoneW * 0.04633";
                                h = "_safeZoneH * 0.07";
                                colorBackground[] = MACRO_COLOUR_BACKGROUND_ELEMENT;
                        };

                        class SecondaryWeapon_Muzzle_Picture : RscPicture {
                                idc = MACRO_IDC_SECONDARYWEAPON_MUZZLE_PICTURE;
                                text = MACRO_PICTURE_WEAPON_MUZZLE;
                                style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 3.5 + 0.04633 * 0.5)";
                                y = "_safeZoneY + _safeZoneH * 0.69";
                                w = "_safeZoneW * 0.04633";
                                h = "_safeZoneH * 0.07";
                        };

                        // Bipod
                        class SecondaryWeapon_Bipod_Background : SecondaryWeapon_Muzzle_Background {
                                idc = -1;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 4.5 + 0.04633 * 1.5)";
                        };

                        class SecondaryWeapon_Bipod_Picture : SecondaryWeapon_Muzzle_Picture {
                                idc = MACRO_IDC_SECONDARYWEAPON_BIPOD_PICTURE;
                                text = MACRO_PICTURE_WEAPON_BIPOD;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 4.5 + 0.04633 * 1.5)";
                        };

                        // Side
                        class SecondaryWeapon_Side_Background : SecondaryWeapon_Muzzle_Background {
                                idc = -1;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 5.5 + 0.04633 * 2.5)";
                        };

                        class SecondaryWeapon_Side_Picture : SecondaryWeapon_Muzzle_Picture {
                                idc = MACRO_IDC_SECONDARYWEAPON_SIDE_PICTURE;
                                text = MACRO_PICTURE_WEAPON_SIDE;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 5.5 + 0.04633 * 2.5)";
                        };

                        // Top
                        class SecondaryWeapon_Top_Background : SecondaryWeapon_Muzzle_Background {
                                idc = -1;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 6.5 + 0.04633 * 3.5)";
                        };

                        class SecondaryWeapon_Top_Picture : SecondaryWeapon_Muzzle_Picture {
                                idc = MACRO_IDC_SECONDARYWEAPON_TOP_PICTURE;
                                text = MACRO_PICTURE_WEAPON_TOP;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 6.5 + 0.04633 * 3.5)";
                        };

                        // Magazine
                        class SecondaryWeapon_Magazine_Background : SecondaryWeapon_Muzzle_Background {
                                idc = -1;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 7.5 + 0.04633 * 4.5)";
                        };

                        class SecondaryWeapon_Magazine_Picture : SecondaryWeapon_Muzzle_Picture {
                                idc = MACRO_IDC_SECONDARYWEAPON_MAGAZINE_PICTURE;
                                text = MACRO_PICTURE_WEAPON_MAGAZINE;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 7.5 + 0.04633 * 4.5)";
                        };

                // ------------------------------------------------------------------------------------------------------------------------------------------------
                // Handgun weapon
                class HandgunWeapon_Background : RscBox {
                        idc = -1;
                        x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 3)";
                        y = "_safeZoneY + _safeZoneH * 0.77";
                        w = "_safeZoneW * (0.3 - 0.004 * 3)";
                        h = "_safeZoneH * 0.145";
                        colorBackground[] = MACRO_COLOUR_BACKGROUND_ELEMENT;
                };

                class HandgunWeapon_Picture : RscPicture {
                        idc = -1;
                        text = MACRO_PICTURE_HANDGUNWEAPON;
                        style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
                        x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 3)";
                        y = "_safeZoneY + _safeZoneH * 0.77";
                        w = "_safeZoneW * (0.3 - 0.004 * 3)";
                        h = "_safeZoneH * 0.145";
                };

                        // Muzzle
                        class HandgunWeapon_Muzzle_Background : RscBox {
                                idc = -1;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 3.5 + 0.04633 * 0.5)";
                                y = "_safeZoneY + _safeZoneH * 0.92";
                                w = "_safeZoneW * 0.04633";
                                h = "_safeZoneH * 0.07";
                                colorBackground[] = MACRO_COLOUR_BACKGROUND_ELEMENT;
                        };

                        class HandgunWeapon_Muzzle_Picture : RscPicture {
                                idc = MACRO_IDC_HANDGUNWEAPON_MUZZLE_PICTURE;
                                text = MACRO_PICTURE_WEAPON_MUZZLE;
                                style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 3.5 + 0.04633 * 0.5)";
                                y = "_safeZoneY + _safeZoneH * 0.92";
                                w = "_safeZoneW * 0.04633";
                                h = "_safeZoneH * 0.07";
                        };

                        // Bipod
                        class HandgunWeapon_Bipod_Background : HandgunWeapon_Muzzle_Background {
                                idc = -1;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 4.5 + 0.04633 * 1.5)";
                        };

                        class HandgunWeapon_Bipod_Picture : HandgunWeapon_Muzzle_Picture {
                                idc = MACRO_IDC_HANDGUNWEAPON_BIPOD_PICTURE;
                                text = MACRO_PICTURE_WEAPON_BIPOD;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 4.5 + 0.04633 * 1.5)";
                        };

                        // Side
                        class HandgunWeapon_Side_Background : HandgunWeapon_Muzzle_Background {
                                idc = -1;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 5.5 + 0.04633 * 2.5)";
                        };

                        class HandgunWeapon_Side_Picture : HandgunWeapon_Muzzle_Picture {
                                idc = MACRO_IDC_HANDGUNWEAPON_SIDE_PICTURE;
                                text = MACRO_PICTURE_WEAPON_SIDE;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 5.5 + 0.04633 * 2.5)";
                        };

                        // Top
                        class HandgunWeapon_Top_Background : HandgunWeapon_Muzzle_Background {
                                idc = -1;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 6.5 + 0.04633 * 3.5)";
                        };

                        class HandgunWeapon_Top_Picture : HandgunWeapon_Muzzle_Picture {
                                idc = MACRO_IDC_HANDGUNWEAPON_TOP_PICTURE;
                                text = MACRO_PICTURE_WEAPON_TOP;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 6.5 + 0.04633 * 3.5)";
                        };

                        // Magazine
                        class HandgunWeapon_Magazine_Background : HandgunWeapon_Muzzle_Background {
                                idc = -1;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 7.5 + 0.04633 * 4.5)";
                        };

                        class HandgunWeapon_Magazine_Picture : HandgunWeapon_Muzzle_Picture {
                                idc = MACRO_IDC_HANDGUNWEAPON_MAGAZINE_PICTURE;
                                text = MACRO_PICTURE_WEAPON_MAGAZINE;
                                x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 7.5 + 0.04633 * 4.5)";
                        };

                // ------------------------------------------------------------------------------------------------------------------------------------------------
                // Binoculars
                class Binoculars_Background : RscBox {
                        idc = -1;
                        x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 3)";
                        y = "_safeZoneY + _safeZoneH * 0.005";
                        w = "_safeZoneW * 0.05";
                        h = "_safeZoneH * 0.07";
                        colorBackground[] = MACRO_COLOUR_BACKGROUND_ELEMENT;
                };

                class Binoculars_Picture : RscPicture {
                        idc = MACRO_IDC_BINOCULARS_PICTURE;
                        text = MACRO_PICTURE_BINOCULARS;
                        style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
                        x = "_safeZoneX + _safeZoneW * (0.35 + 0.002 * 3)";
                        y = "_safeZoneY + _safeZoneH * 0.005";
                        w = "_safeZoneW * 0.05";
                        h = "_safeZoneH * 0.07";
                };
        };
};
