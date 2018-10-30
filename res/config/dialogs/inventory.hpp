__EXEC(_safeZoneMul = 1.25)
__EXEC(_safeZoneW = safeZoneW / _safeZoneMul - 1 / _safeZoneMul + 1)
__EXEC(_safeZoneH = safeZoneH / _safeZoneMul - 1 / _safeZoneMul + 1)
__EXEC(_safeZoneX = safeZoneX / _safeZoneMul)
__EXEC(_safeZoneY = safeZoneY / _safeZoneMul)
__EXEC(uiNamespace setVariable ["Cre8ive_Inventory_SafeZoneW", _safeZoneW])
__EXEC(uiNamespace setVariable ["Cre8ive_Inventory_SafeZoneH", _safeZoneH])





#include "macros.hpp"





class MACRO_GUI_NAME {
        idd = 888801;
        name = STR(MACRO_GUI_NAME);
        onLoad = "uiNamespace setVariable ['cre8ive_dialog_inventory', _this select 0]";

        class Controls {
                class Ground_Frame : RscBox {
                        idc = -1;
                        x = _safeZoneX;
                        y = _safeZoneY;
                        w = _safeZoneW * (0.35 - 0.002);
                        h = _safeZoneH;
                        colorBackground[] = CURLY(MACRO_COLOUR_BACKGROUND);
                };

                class Player_Frame : Ground_Frame {
                        x = _safeZoneX + _safeZoneW * (0.35 + 0.002);
                        w = _safeZoneW * (0.3 - 0.004);
		};

                class Storage_Frame : Ground_Frame {
                        x = _safeZoneX + _safeZoneW * (0.65 + 0.002);
                };

                // ------------------------------------------------------------------------------------------------------------------------------------------------
                // Player Info
                class Player_Name_Frame : RscBox {
                        idc = -1;
                        x = _safeZoneX + _safeZoneW * (0.35 + 0.002);
                        y = _safeZoneY;
                        w = _safeZoneW * (0.3 - 0.004);
                        h = _safeZoneH * 0.03;
                        colorBackground[] = CURLY(MACRO_COLOUR_SEPARATOR);
                };

                class Player_Name : RscText {
                        idc = MACRO_IDC_PLAYER_NAME;
                        font = "PuristaLight";
                        text = "";
                        sizeEx = _safeZoneW * 0.025;
                        style = ST_LEFT;
                        x = _safeZoneX + _safeZoneW * (0.35 + 0.002);
                        y = _safeZoneY;
                        w = _safeZoneW * (0.278 - 0.002);
                        h = _safeZoneH * 0.03;
                        colorBackground[] = CURLY(MACRO_COLOUR_INVISIBLE);
                };

                class Exit_Button_Picture : RscPicture {
                        idc = -1;
                        text = MACRO_PICTURE_EXIT_BUTTON;
                        style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
                        x = _safeZoneX + _safeZoneW * (0.35 + 0.002 + 0.278);
                        y = _safeZoneY;
                        w = _safeZoneW * (0.022 - 0.004);
                        h = _safeZoneH * 0.03;
                };

                class Exit_Button : RscButton {
                        idc = MACRO_IDC_WEAPONS_BUTTON;
                        period = 0;
                        offsetX = 0;
                        offsetY = 0;
                        offsetPressedX = 0;
                        offsetPressedY = 0;
                        shadow = 0;
                        x = _safeZoneX + _safeZoneW * (0.35 + 0.002 + 0.278);
                        y = _safeZoneY;
                        w = _safeZoneW * (0.022 - 0.004);
                        h = _safeZoneH * 0.03;
                        colorBackground[] = CURLY(MACRO_COLOUR_INVISIBLE);
                        colorBackgroundActive[] = {1,0,0,0.2};
                        colorShadow[] = CURLY(MACRO_COLOUR_INVISIBLE);
                        colorText[] = {1,1,1,1};
                        action = "(uiNamespace getVariable ['cre8ive_dialog_inventory', displayNull]) closeDisplay 0";
                };

		// ------------------------------------------------------------------------------------------------------------------------------------------------
                // Weapons / Medical buttons
                        // Weapons
                        class Weapons_Button_Frame : RscText {
                                idc = MACRO_IDC_WEAPONS_BUTTON_FRAME;
                                x = _safeZoneX + _safeZoneW * (0.35 + 0.002 * 3);
                                y = _safeZoneY + _safeZoneH * (0.03 + 0.005);
                                w = _safeZoneW * 0.143;
                                h = _safeZoneH * 0.06;		// 0.075
                                colorBackground[] = CURLY(MACRO_COLOUR_ELEMENT_ACTIVE);
                        };

                        class Weapons_Button : RscButton {
                                idc = MACRO_IDC_WEAPONS_BUTTON;
                                font = "PuristaMedium";
                                period = 0;
                                offsetX = 0;
                                offsetY = 0;
                                offsetPressedX = _safeZoneW * 0.001;
                                offsetPressedY = _safeZoneH * 0.002;
                                shadow = 0;
                                sizeEx = _safeZoneW * 0.03;
                                text = "WEAPONS";
                                x = _safeZoneX + _safeZoneW * (0.35 + 0.002 * 3);
                                y = _safeZoneY + _safeZoneH * (0.03 + 0.005);
                                w = _safeZoneW * 0.143;
                                h = _safeZoneH * 0.06;	// 0.075
                                colorBackground[] = CURLY(MACRO_COLOUR_INVISIBLE);
                                colorBackgroundActive[] = CURLY(MACRO_COLOUR_INVISIBLE);
                                colorShadow[] = CURLY(MACRO_COLOUR_INVISIBLE);
                                colorText[] = {1,1,1,1};
                                action = "['ui_menu_weapons'] call cre_fnc_inventory";
                        };

                        // Medical
                        class Medical_Button_Frame : Weapons_Button_Frame {
                                idc = MACRO_IDC_MEDICAL_BUTTON_FRAME;
                                x = _safeZoneX + _safeZoneW * (0.35 + 0.002 * 4 + 0.143);
                                colorBackground[] = CURLY(MACRO_COLOUR_ELEMENT_INACTIVE);
                        };

                        class Medical_Button : Weapons_Button {
                                idc = MACRO_IDC_MEDICAL_BUTTON;
                                text = "MEDICAL";
                                x = _safeZoneX + _safeZoneW * (0.35 + 0.002 * 4 + 0.143);
                                action = "['ui_menu_medical'] call cre_fnc_inventory";
                        };

		// ------------------------------------------------------------------------------------------------------------------------------------------------
                // Weapons Control Group
		class Weapons_CtrlGrp : RscControlsGroupNoScrollbars {
			idc = MACRO_IDC_WEAPONS_CTRLGRP;
			x = _safeZoneX + _safeZoneW * (0.35 + 0.002);
			y = _safeZoneY + _safeZoneH * 0.1;
                        w = _safeZoneW * (0.3 - 0.004);
                        h = _safeZoneH * 0.9;

			class controls {
				// Focus frame
				class Weapons_Focus_Frame : RscText {
					idc = MACRO_IDC_WEAPONS_FOCUS_FRAME;
					x = 0;
					y = 0;
					w = 0;
					h = 0;
				};

				// Character
				class Character_Weapons_Outline : RscPicture {
					idc = MACRO_IDC_CHARACTER_WEAPONS_ICON;
					text = MACRO_PICTURE_CHARACTER_OUTLINE;
					style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
					x = -_safeZoneW * (0.35 + 0.002);
					y = 0;
					w = _safeZoneW;
					h = _safeZoneH * 0.9;
					colorText[] = {1,1,1,0.1};
				};

				// ------------------------------------------------------------------------------------------------------------------------------------------------
				// TOP SLOTS
					// NVGs
					class NVGs_Frame : RscText {
						idc = MACRO_IDC_NVGS_FRAME;
						x = _safeZoneW * (0.15 - 0.002 - MACRO_SCALE_SLOT_SIZE_W * 3);
						y = _safeZoneH * (0.1);
						w = _safeZoneW * MACRO_SCALE_SLOT_SIZE_W * 1.5;
						h = _safeZoneH * MACRO_SCALE_SLOT_SIZE_H * 1.5;
						colorBackground[] = CURLY(MACRO_COLOUR_ELEMENT_INACTIVE);
						childPicture = MACRO_IDC_NVGS_ICON;
						onMouseButtonDown = "['ui_dragging_start', _this] call cre_fnc_inventory";
						onMouseButtonUp = "['ui_dragging_stop', _this] call cre_fnc_inventory";
					};

					class NVGs_Picture : RscPicture {
						idc = MACRO_IDC_NVGS_ICON;
						text = MACRO_PICTURE_NVGS;
						style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
						x = _safeZoneW * (0.15 - 0.002 - MACRO_SCALE_SLOT_SIZE_W * 3);
						y = _safeZoneH * (0.1);
						w = _safeZoneW * MACRO_SCALE_SLOT_SIZE_W * 1.5;
						h = _safeZoneH * MACRO_SCALE_SLOT_SIZE_H * 1.5;
					};

					// Headgear
					class Headgear_Frame : NVGs_Frame {
						idc = MACRO_IDC_HEADGEAR_FRAME;
						y = _safeZoneH * (0.1 + 0.005 + MACRO_SCALE_SLOT_SIZE_H * 1.5);
						childPicture = MACRO_IDC_HEADGEAR_ICON;
					};

					class Headgear_Picture : NVGs_Picture {
						idc = MACRO_IDC_HEADGEAR_ICON;
						text = MACRO_PICTURE_HEADGEAR;
						y = _safeZoneH * (0.1 + 0.005 + MACRO_SCALE_SLOT_SIZE_H * 1.5);
					};

					// Binoculars
					class Binoculars_Frame : NVGs_Frame {
						idc = MACRO_IDC_BINOCULARS_FRAME;
						x = _safeZoneW * (0.15 - 0.002 + MACRO_SCALE_SLOT_SIZE_W * 1.5);
						childPicture = MACRO_IDC_BINOCULARS_ICON;
					};

					class Binoculars_Picture : NVGs_Picture {
						idc = MACRO_IDC_BINOCULARS_ICON;
						text = MACRO_PICTURE_BINOCULARS;
						x = _safeZoneW * (0.15 - 0.002 + MACRO_SCALE_SLOT_SIZE_W * 1.5);
					};

					// Goggles
					class Goggles_Frame : NVGs_Frame {
						idc = MACRO_IDC_GOGGLES_FRAME;
						x = _safeZoneW * (0.15 - 0.002 + MACRO_SCALE_SLOT_SIZE_W * 1.5);
						y = _safeZoneH * (0.1 + 0.005 + MACRO_SCALE_SLOT_SIZE_H * 1.5);
						childPicture = MACRO_IDC_GOGGLES_ICON;
					};

					class Goggles_Picture : NVGs_Picture {
						idc = MACRO_IDC_GOGGLES_ICON;
						text = MACRO_PICTURE_GOGGLES;
						x = _safeZoneW * (0.15 - 0.002 + MACRO_SCALE_SLOT_SIZE_W * 1.5);
						y = _safeZoneH * (0.1 + 0.005 + MACRO_SCALE_SLOT_SIZE_H * 1.5);
					};


				// ------------------------------------------------------------------------------------------------------------------------------------------------
				// WEAPONS
					// Primary Weapon
					class PrimaryWeapon_Frame : RscText {
						idc = MACRO_IDC_PRIMARYWEAPON_FRAME;
						x = _safeZoneW * (0.15 - 0.002 - MACRO_SCALE_SLOT_SIZE_W * 3);
						y = _safeZoneH * (0.1 + 0.005 * 2 + MACRO_SCALE_SLOT_SIZE_H * 3);
						w = _safeZoneW * MACRO_SCALE_SLOT_SIZE_W * 6;
						h = _safeZoneH * MACRO_SCALE_SLOT_SIZE_H * 2.5;
						colorBackground[] = CURLY(MACRO_COLOUR_ELEMENT_INACTIVE);
						childPicture = MACRO_IDC_PRIMARYWEAPON_ICON;
						onMouseButtonDown = "['ui_dragging_start', _this] call cre_fnc_inventory";
						onMouseButtonUp = "['ui_dragging_stop', _this] call cre_fnc_inventory";
					};

					class PrimaryWeapon_Picture : RscPicture {
						idc = MACRO_IDC_PRIMARYWEAPON_ICON;
						text = MACRO_PICTURE_PRIMARYWEAPON;
						style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
						x = _safeZoneW * (0.15 - 0.002 - MACRO_SCALE_SLOT_SIZE_W * 3);
						y = _safeZoneH * (0.1 + 0.005 * 2 + MACRO_SCALE_SLOT_SIZE_H * 3);
						w = _safeZoneW * MACRO_SCALE_SLOT_SIZE_W * 6;
						h = _safeZoneH * MACRO_SCALE_SLOT_SIZE_H * 2.5;
					};

					// Handgun weapon
					class HandgunWeapon_Frame : PrimaryWeapon_Frame {
						idc = MACRO_IDC_HANDGUNWEAPON_FRAME;
						y = _safeZoneH * (0.1 + 0.005 * 3 + MACRO_SCALE_SLOT_SIZE_H * 5.5);
						childPicture = MACRO_IDC_HANDGUNWEAPON_ICON;
					};

					class HandgunWeapon_Picture : PrimaryWeapon_Picture {
						idc = MACRO_IDC_HANDGUNWEAPON_ICON;
						text = MACRO_PICTURE_HANDGUNWEAPON;
						y = _safeZoneH * (0.1 + 0.005 * 3 + MACRO_SCALE_SLOT_SIZE_H * 5.5);
					};

					// Secondary weapon
					class SecondaryWeapon_Frame : PrimaryWeapon_Frame {
						idc = MACRO_IDC_SECONDARYWEAPON_FRAME;
						y = _safeZoneH * (0.1 + 0.005 * 4 + MACRO_SCALE_SLOT_SIZE_H * 8);
						childPicture = MACRO_IDC_SECONDARYWEAPON_ICON;
					};

					class SecondaryWeapon_Picture : PrimaryWeapon_Picture {
						idc = MACRO_IDC_SECONDARYWEAPON_ICON;
						text = MACRO_PICTURE_SECONDARYWEAPON;
						y = _safeZoneH * (0.1 + 0.005 * 4 + MACRO_SCALE_SLOT_SIZE_H * 8);
					};

				// ------------------------------------------------------------------------------------------------------------------------------------------------
				// BOTTOM SLOTS
					// Map
					class Map_Frame : RscText {
						idc = MACRO_IDC_MAP_FRAME;
						x = _safeZoneW * (0.15 - 0.002 - 0.003 * 2 - MACRO_SCALE_SLOT_SIZE_W * 2.5);
						y = _safeZoneH * 0.65;
						w = _safeZoneW * MACRO_SCALE_SLOT_SIZE_W;
						h = _safeZoneH * MACRO_SCALE_SLOT_SIZE_H;
						colorBackground[] = CURLY(MACRO_COLOUR_ELEMENT_INACTIVE);
						childPicture = MACRO_IDC_MAP_ICON;
						onMouseButtonDown = "['ui_dragging_start', _this] call cre_fnc_inventory";
						onMouseButtonUp = "['ui_dragging_stop', _this] call cre_fnc_inventory";
					};

					class Map_Picture : RscPicture {
						idc = MACRO_IDC_MAP_ICON;
						text = MACRO_PICTURE_MAP;
						style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
						x = _safeZoneW * (0.15 - 0.002 - 0.003 * 2 - MACRO_SCALE_SLOT_SIZE_W * 2.5);
						y = _safeZoneH * 0.65;
						w = _safeZoneW * MACRO_SCALE_SLOT_SIZE_W;
						h = _safeZoneH * MACRO_SCALE_SLOT_SIZE_H;
					};

					// GPS
					class GPS_Frame : Map_Frame {
						idc = MACRO_IDC_GPS_FRAME;
						x = _safeZoneW * (0.15 - 0.002 - 0.003 - MACRO_SCALE_SLOT_SIZE_W * 1.5);
						childPicture = MACRO_IDC_GPS_ICON;
					};

					class GPS_Picture : Map_Picture {
						idc = MACRO_IDC_GPS_ICON;
						text = MACRO_PICTURE_GPS;
						x = _safeZoneW * (0.15 - 0.002 - 0.003 - MACRO_SCALE_SLOT_SIZE_W * 1.5);
					};

					// Radio
					class Radio_Frame : Map_Frame {
						idc = MACRO_IDC_RADIO_FRAME;
						x = _safeZoneW * (0.15 - 0.002 - MACRO_SCALE_SLOT_SIZE_W * 0.5);
						childPicture = MACRO_IDC_RADIO_ICON;
					};

					class Radio_Picture : Map_Picture {
						idc = MACRO_IDC_RADIO_ICON;
						text = MACRO_PICTURE_RADIO;
						x = _safeZoneW * (0.15 - 0.002 - MACRO_SCALE_SLOT_SIZE_W * 0.5);
					};

					// Compass
					class Compass_Frame : Map_Frame {
						idc = MACRO_IDC_COMPASS_FRAME;
						x = _safeZoneW * (0.15 - 0.002 + 0.003 + MACRO_SCALE_SLOT_SIZE_W * 0.5);
						childPicture = MACRO_IDC_COMPASS_ICON;
					};

					class Compass_Picture : Map_Picture {
						idc = MACRO_IDC_COMPASS_ICON;
						text = MACRO_PICTURE_COMPASS;
						x = _safeZoneW * (0.15 - 0.002 + 0.003 + MACRO_SCALE_SLOT_SIZE_W * 0.5);
					};

					// Watch
					class Watch_Frame : Map_Frame {
						idc = MACRO_IDC_WATCH_FRAME;
						x = _safeZoneW * (0.15 - 0.002 + 0.003 * 2 + MACRO_SCALE_SLOT_SIZE_W * 1.5);
						childPicture = MACRO_IDC_WATCH_ICON;
					};

					class Watch_Picture : Map_Picture {
						idc = MACRO_IDC_WATCH_ICON;
						text = MACRO_PICTURE_WATCH;
						x = _safeZoneW * (0.15 - 0.002 + 0.003 * 2 + MACRO_SCALE_SLOT_SIZE_W * 1.5);
					};

			};
		};

		// ------------------------------------------------------------------------------------------------------------------------------------------------
                // Medical Control Group
		class Medical_CtrlGrp : RscControlsGroupNoScrollbars {
			idc = MACRO_IDC_MEDICAL_CTRLGRP;
			x = _safeZoneX + _safeZoneW * (0.35 + 0.002);
			y = _safeZoneY + _safeZoneH * 0.1;
                        w = _safeZoneW * (0.3 - 0.004);
                        h = _safeZoneH * 0.9;

			class controls {
				// Focus frame
				class Medical_Focus_Frame : RscText {
					idc = MACRO_IDC_MEDICAL_FOCUS_FRAME;
					x = 0;
					y = 0;
					w = 0;
					h = 0;
				};

				// Character
				class Character_Medical_Outline : RscPicture {
					idc = MACRO_IDC_CHARACTER_MEDICAL_ICON;
					text = MACRO_PICTURE_CHARACTER_OUTLINE;
					style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
					x = -_safeZoneW * (0.35 + 0.002);
					y = 0;
					w = _safeZoneW;
					h = _safeZoneH * 0.9;
					colorText[] = {1,1,1,0.4};
				};
			};
		};

		// ------------------------------------------------------------------------------------------------------------------------------------------------
                // Storage Frame
		class Storage_CtrlGrp : RscControlsGroupNoHScrollbars {
			idc = MACRO_IDC_STORAGE_CTRLGRP;
			x = _safeZoneX + _safeZoneW * (0.65 + 0.002);
                        y = _safeZoneY;
                        w = _safeZoneW * (0.35 - 0.002);
                        h = _safeZoneH;

			class controls {
				// Focus frame
				class Storage_Focus_Frame : RscText {
					idc = MACRO_IDC_STORAGE_FOCUS_FRAME;
					x = 0;
					y = 0;
					w = 0;
					h = 0;
				};

				// Uniform
				class Storage_Uniform_Frame : RscText {
					idc = MACRO_IDC_UNIFORM_FRAME;
					x = _safeZoneW * 0.002 * 2;
		                        y = _safeZoneH * 0.005;
		                        w = _safeZoneW * MACRO_SCALE_SLOT_SIZE_W * 1.5; //0.33
		                        h = _safeZoneH * MACRO_SCALE_SLOT_SIZE_H * 1.5;
					colorBackground[] = CURLY(MACRO_COLOUR_ELEMENT_INACTIVE);
					onMouseButtonDown = "['ui_dragging_start', _this] call cre_fnc_inventory";
					onMouseButtonUp = "['ui_dragging_stop', _this] call cre_fnc_inventory";
				};

				class Storage_Uniform_Icon : RscPicture {
					idc = MACRO_IDC_UNIFORM_ICON;
					text = MACRO_PICTURE_UNIFORM;
					style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
					x = _safeZoneW * 0.002 * 2;
		                        y = _safeZoneH * 0.005;
		                        w = _safeZoneW * MACRO_SCALE_SLOT_SIZE_W * 1.5;
		                        h = _safeZoneH * MACRO_SCALE_SLOT_SIZE_H * 1.5;
				};

				// Vest
				class Storage_Vest_Frame : Storage_Uniform_Frame {
					idc = MACRO_IDC_VEST_FRAME;
		                        y = _safeZoneH * (0.005 * 2 + MACRO_SCALE_SLOT_SIZE_H * 1.5);
				};

				class Storage_Vest_Icon : Storage_Uniform_Icon {
					idc = MACRO_IDC_VEST_ICON;
					text = MACRO_PICTURE_VEST;
					y = _safeZoneH * (0.005 * 2 + MACRO_SCALE_SLOT_SIZE_H * 1.5);
				};

				// Backpack
				class Storage_Backpack_Frame : Storage_Uniform_Frame {
					idc = MACRO_IDC_BACKPACK_FRAME;
		                        y = _safeZoneH * (0.005 * 3 + MACRO_SCALE_SLOT_SIZE_H * 3);
				};

				class Storage_Backpack_Icon : Storage_Uniform_Icon {
					idc = MACRO_IDC_BACKPACK_ICON;
					text = MACRO_PICTURE_BACKPACK;
					y = _safeZoneH * (0.005 * 3 + MACRO_SCALE_SLOT_SIZE_H * 3);
				};

				// Scrollbar Dummy
				class Storage_Scrollbar_Dummy : RscBox {
					idc = MACRO_IDC_SCROLLBAR_DUMMY;
					x = _safeZoneW * 0.002 * 2;
		                        y = _safeZoneH * 0.005;
		                        w = _safeZoneW * MACRO_SCALE_SLOT_SIZE_W;
		                        h = _safeZoneH * MACRO_SCALE_SLOT_SIZE_H;
					colorBackground[] = {0,0,0,0};
				};
			};
		};

		// ------------------------------------------------------------------------------------------------------------------------------------------------
                // Ground Frame
		class Ground_CtrlGrp : RscControlsGroupNoHScrollbars {
			idc = MACRO_IDC_GROUND_CTRLGRP;
			x = _safeZoneX;
                        y = _safeZoneY;
                        w = _safeZoneW * (0.35 - 0.002);
                        h = _safeZoneH;

			class controls {
				// Focus frame
				class Ground_Focus_Frame : RscText {
					idc = MACRO_IDC_GROUND_FOCUS_FRAME;
					x = 0;
					y = 0;
					w = 0;
					h = 0;
				};
			};
		};

		// ------------------------------------------------------------------------------------------------------------------------------------------------
                // Empty control group (for focus)
		class Empty_CtrlGrp : RscControlsGroupNoScrollbars {
			idc = MACRO_IDC_EMPTY_CTRLGROUP;
			x = 0;
                        y = 0;
                        w = 0;
                        h = 0;

			class controls {
				// Focus frame
				class Empty_Focus_Frame : RscText {
					idc = MACRO_IDC_EMPTY_FOCUS_FRAME;
					x = 0;
					y = 0;
					w = 0;
					h = 0;
				};
			};
		};

                // Temporary dragging controls
		class Dragging_Dummy_Frame : RscBox {
			idc = MACRO_IDC_DRAGGING_FRAME;
			x = 0;
			y = 0;
			w = 0;
			h = 0;
			colorBackground[] = CURLY(MACRO_COLOUR_ELEMENT_ACTIVE);
		};

		class Dragging_Dummy_Picture_1 : RscPicture {
			idc = MACRO_IDC_DRAGGING_PICTURE_1;
			style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
			x = 0;
			y = 0;
			w = 0;
			h = 0;
		};

		class Dragging_Dummy_Picture_2 : Dragging_Dummy_Picture_1 {
			idc = MACRO_IDC_DRAGGING_PICTURE_2;
		};

		class Dragging_Dummy_Picture_3 : Dragging_Dummy_Picture_1 {
			idc = MACRO_IDC_DRAGGING_PICTURE_3;
		};

		class Dragging_Dummy_Picture_4 : Dragging_Dummy_Picture_1 {
			idc = MACRO_IDC_DRAGGING_PICTURE_4;
		};

		class Dragging_Dummy_Picture_5 : Dragging_Dummy_Picture_1 {
			idc = MACRO_IDC_DRAGGING_PICTURE_5;
		};

		class Dragging_Dummy_Picture_6 : Dragging_Dummy_Picture_1 {
			idc = MACRO_IDC_DRAGGING_PICTURE_6;
		};

		class Dragging_Dummy_Picture_7 : Dragging_Dummy_Picture_1 {
			idc = MACRO_IDC_DRAGGING_PICTURE_7;
		};
        };
};





// ------------------------------------------------------------------------------------------------------------------------------------------------
// SCRIPTED CONTROLS
class Cre8ive_Inventory_ScriptedBox : RscBox {
	x = 0;
	y = 0;
	w = 0;
	h = 0;
};

class Cre8ive_Inventory_ScriptedText : RscText {
	x = 0;
	y = 0;
	w = 0;
	h = 0;
};

class Cre8ive_Inventory_ScriptedPicture : RscPicture {
	style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
	x = 0;
	y = 0;
	w = 0;
	h = 0;
};
