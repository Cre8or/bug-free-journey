#include "..\..\res\config\dialogs\macros.hpp"

params [
        ["_event", "", [""]],
	"_args"
];

// Change the case to avoid mistakes
_event = toLower _event;

// Exit if no event was specified
if (_event == "") exitWith {systemChat "No event specified!"};

// Check if the inventory is open
disableSerialization;
private _eventExists = false;
private _inventory = uiNamespace getVariable ["cre8ive_dialog_inventory", displayNull];
if (_event != "ui_init") then {
        if (isNull _inventory) exitWith {systemChat "Inventory isn't open!"};
};





switch (_event) do {

        // Initialisation
        case "ui_init": {
		_eventExists = true;
                [] spawn {

                        (findDisplay 46) createDisplay "Rsc_Cre8ive_Inventory";
			//createDialog "Rsc_Cre8ive_Inventory";

			private _timeOut = time + 1;
                        waitUntil {!isNull (uiNamespace getVariable ["cre8ive_dialog_inventory", displayNull]) or {time > _timeOut}};

                        if (time > _timeOut) then {
                                systemChat "Couldn't open inventory!";
                        } else {
				// Escape scheduled environment
				isNil {
	                                // Fetch the inventory
	                                private _inventory = uiNamespace getVariable ["cre8ive_dialog_inventory", displayNull];

	                                // Write down the player's name
	                                (_inventory displayCtrl MACRO_IDC_PLAYER_NAME) ctrlSetText name player;

					// Attach an EH to the inventory to detect when it is closed
					_inventory displayAddEventHandler ["Unload", {
						["ui_unload"] call cre_fnc_inventory;
					}];

					// Set up the blur post-process effect
					private _blurFX = missionNamespace getVariable ["Cre8ive_Inventory_BlurFX", 0];
					if (_blurFX <= 0) then {
						private _index = 400;
						while {
							_blurFX = ppEffectCreate ["DynamicBlur", _index];
							_blurFX < 0
						} do {
							_index = _index + 1;
						};

						_blurFX ppEffectEnable true;
					};

					// Start the post-process effect and save the handle for later use
					_blurFX ppEffectAdjust [5];
					_blurFX ppEffectCommit 0;
					missionNamespace setVariable  ["Cre8ive_Inventory_blurFX", _blurFX, false];

					// Load the weapons menu (default)
					["ui_menu_weapons"] call cre_fnc_inventory;
				};
                        };
                };
        };

	// Unloading (closing the inventory)
	case "ui_unload": {
		_eventExists = true;

		// Stop the blur post-process effect
		private _blurFX = missionNamespace getVariable ["Cre8ive_Inventory_BlurFX", 0];
		_blurFX ppEffectAdjust [0];
		_blurFX ppEffectCommit 0;
	};

        // Show weapons menu
        case "ui_menu_weapons": {
		_eventExists = true;
                // Show the weapons controls
                {
                        (_inventory displayCtrl _x) ctrlShow true;
                } forEach [
                        MACRO_IDC_NVGS_FRAME,
                        MACRO_IDC_NVGS_ICON,
                        MACRO_IDC_HEADGEAR_FRAME,
                        MACRO_IDC_HEADGEAR_ICON,
                        MACRO_IDC_GOGGLES_FRAME,
                        MACRO_IDC_GOGGLES_ICON,
                        MACRO_IDC_BINOCULARS_FRAME,
                        MACRO_IDC_BINOCULARS_ICON,
                        MACRO_IDC_PRIMARYWEAPON_FRAME,
                        MACRO_IDC_PRIMARYWEAPON_ICON,
                        MACRO_IDC_HANDGUNWEAPON_FRAME,
                        MACRO_IDC_HANDGUNWEAPON_ICON,
                        MACRO_IDC_SECONDARYWEAPON_FRAME,
                        MACRO_IDC_SECONDARYWEAPON_ICON,
                        MACRO_IDC_MAP_FRAME,
                        MACRO_IDC_MAP_ICON,
                        MACRO_IDC_GPS_FRAME,
                        MACRO_IDC_GPS_ICON,
                        MACRO_IDC_RADIO_FRAME,
                        MACRO_IDC_RADIO_ICON,
                        MACRO_IDC_COMPASS_FRAME,
                        MACRO_IDC_COMPASS_ICON,
                        MACRO_IDC_WATCH_FRAME,
                        MACRO_IDC_WATCH_ICON
                ];
/*
                // Hide the medical controls
                {
                        (_inventory displayCtrl _x) ctrlShow false;
                } forEach [
                        MACRO_IDC_CHARACTER_ICON
                ];
*/

		// Slightly hide the character
		private _character = _inventory displayCtrl MACRO_IDC_CHARACTER_ICON;
		_character ctrlSetTextColor [1,1,1,0.1];
		_character ctrlCommit 0;

                // Change the button colours
                private _buttonWeapons = _inventory displayCtrl MACRO_IDC_WEAPONS_BUTTON_FRAME;
                private _buttonMedical = _inventory displayCtrl MACRO_IDC_MEDICAL_BUTTON_FRAME;
                _buttonWeapons ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);
                _buttonWeapons ctrlCommit 0;
                _buttonMedical ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);
                _buttonMedical ctrlCommit 0;

                // Update the menu
        	["ui_update_weapons"] call cre_fnc_inventory;
        };

        // Show medical menu
        case "ui_menu_medical": {
		_eventExists = true;
                // Hide the weapons controls
                {
                        (_inventory displayCtrl _x) ctrlShow false;
                } forEach [
                        MACRO_IDC_NVGS_FRAME,
                        MACRO_IDC_NVGS_ICON,
                        MACRO_IDC_HEADGEAR_FRAME,
                        MACRO_IDC_HEADGEAR_ICON,
                        MACRO_IDC_GOGGLES_FRAME,
                        MACRO_IDC_GOGGLES_ICON,
                        MACRO_IDC_BINOCULARS_FRAME,
                        MACRO_IDC_BINOCULARS_ICON,
                        MACRO_IDC_PRIMARYWEAPON_FRAME,
                        MACRO_IDC_PRIMARYWEAPON_ICON,
                        MACRO_IDC_HANDGUNWEAPON_FRAME,
                        MACRO_IDC_HANDGUNWEAPON_ICON,
                        MACRO_IDC_SECONDARYWEAPON_FRAME,
                        MACRO_IDC_SECONDARYWEAPON_ICON,
                        MACRO_IDC_MAP_FRAME,
                        MACRO_IDC_MAP_ICON,
                        MACRO_IDC_GPS_FRAME,
                        MACRO_IDC_GPS_ICON,
                        MACRO_IDC_RADIO_FRAME,
                        MACRO_IDC_RADIO_ICON,
                        MACRO_IDC_COMPASS_FRAME,
                        MACRO_IDC_COMPASS_ICON,
                        MACRO_IDC_WATCH_FRAME,
                        MACRO_IDC_WATCH_ICON
                ];
/*
                // Show the medical controls
                {
                        (_inventory displayCtrl _x) ctrlShow true;
                } forEach [
                        MACRO_IDC_CHARACTER_ICON
                ];
*/

		// Show the character
		private _character = _inventory displayCtrl MACRO_IDC_CHARACTER_ICON;
		_character ctrlSetTextColor [1,1,1,0.5];
		_character ctrlCommit 0;

                // Change the button colours
                private _buttonWeapons = _inventory displayCtrl MACRO_IDC_WEAPONS_BUTTON_FRAME;
                private _buttonMedical = _inventory displayCtrl MACRO_IDC_MEDICAL_BUTTON_FRAME;
                _buttonWeapons ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);
                _buttonWeapons ctrlCommit 0;
                _buttonMedical ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);
                _buttonMedical ctrlCommit 0;

                // Update the menu
                ["ui_update_medical"] call cre_fnc_inventory;
        };

        // Update weapons menu
        case "ui_update_weapons": {
		_eventExists = true;
                // Grab some of our inventory controls
                private _ctrlPrimaryWeapon = _inventory displayCtrl MACRO_IDC_PRIMARYWEAPON_ICON;
                private _ctrlSecondaryWeapon = _inventory displayCtrl MACRO_IDC_SECONDARYWEAPON_ICON;
                private _ctrlHandgunWeapon = _inventory displayCtrl MACRO_IDC_HANDGUNWEAPON_ICON;

                // Determine the player's assigned items
                private _map = "";
                private _GPS = "";
                private _radio = "";
                private _compass = "";
                private _watch = "";
                {
                        private _simulation = [configfile >> "CfgWeapons" >> _x, "simulation", ""] call BIS_fnc_returnConfigEntry;
                        switch (_simulation) do {
                                case "ItemMap": {_map = _x};
                                case "ItemGPS": {_GPS = _x};
                                case "ItemRadio": {_radio = _x};
                                case "ItemCompass": {_compass = _x};
                                case "ItemWatch": {_watch = _x};
                        };
                } forEach assignedItems player;

                // Determine our classes array
                private _classes = [
                        hmd player,
                        headgear player,
                        goggles player,
                        binocular player,
                        primaryWeapon player,
			handgunWeapon player,
                        secondaryWeapon player,
                        _map,
                        _GPS,
                        _radio,
                        _compass,
                        _watch
                ];

                // Determine the icon paths for the items and weapons that we have
                {
                        private _class = _classes param [_forEachIndex, ""];

                        if (_class != "") then {
				private _frame = _x select 0;
                                private _icon = _x select 1;
				private _default = _x select 2;
                                private _iconPath = [_class, _default] call cre_fnc_getClassIcon;
				//private _iconPath = "res\ui\inventory\weapon_frame.paa";

                                _icon ctrlSetText _iconPath;
                                _frame ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);

                                // Save the slot's data
				_frame setVariable ["active", true];
				_frame setVariable ["childPicture", _icon];
                                _frame setVariable ["defaultIconPath", _default];
                        };
                } forEach [
                        [_inventory displayCtrl MACRO_IDC_NVGS_FRAME,			_inventory displayCtrl MACRO_IDC_NVGS_ICON,		MACRO_PICTURE_NVGS],
                        [_inventory displayCtrl MACRO_IDC_HEADGEAR_FRAME,		_inventory displayCtrl MACRO_IDC_HEADGEAR_ICON,		MACRO_PICTURE_HEADGEAR],
                        [_inventory displayCtrl MACRO_IDC_GOGGLES_FRAME,		_inventory displayCtrl MACRO_IDC_GOGGLES_ICON,		MACRO_PICTURE_GOGGLES],
                        [_inventory displayCtrl MACRO_IDC_BINOCULARS_FRAME, 		_inventory displayCtrl MACRO_IDC_BINOCULARS_ICON,	MACRO_PICTURE_BINOCULARS],
                        [_inventory displayCtrl MACRO_IDC_PRIMARYWEAPON_FRAME, 		_ctrlPrimaryWeapon,					MACRO_PICTURE_PRIMARYWEAPON],
                        [_inventory displayCtrl MACRO_IDC_HANDGUNWEAPON_FRAME,		_ctrlHandgunWeapon,					MACRO_PICTURE_HANDGUNWEAPON],
                        [_inventory displayCtrl MACRO_IDC_SECONDARYWEAPON_FRAME,	_ctrlSecondaryWeapon,					MACRO_PICTURE_SECONDARYWEAPON],
                        [_inventory displayCtrl MACRO_IDC_MAP_FRAME, 			_inventory displayCtrl MACRO_IDC_MAP_ICON,		MACRO_PICTURE_MAP],
                        [_inventory displayCtrl MACRO_IDC_GPS_FRAME, 			_inventory displayCtrl MACRO_IDC_GPS_ICON,		MACRO_PICTURE_GPS],
                        [_inventory displayCtrl MACRO_IDC_RADIO_FRAME, 			_inventory displayCtrl MACRO_IDC_RADIO_ICON,		MACRO_PICTURE_RADIO],
                        [_inventory displayCtrl MACRO_IDC_COMPASS_FRAME, 		_inventory displayCtrl MACRO_IDC_COMPASS_ICON,		MACRO_PICTURE_COMPASS],
                        [_inventory displayCtrl MACRO_IDC_WATCH_FRAME,	 		_inventory displayCtrl MACRO_IDC_WATCH_ICON,		MACRO_PICTURE_WATCH]
                ];

		private _maxI = 40;
		private _maxJ = 20;
/*
		for "_i" from 1 to _maxI do {
			for "_j" from 1 to _maxJ do {
				private _ctrl = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedFrame", 3000 + _i * _maxJ + _j];
				_ctrl ctrlSetBackgroundColor [_i / _maxI, _j / _maxJ, 0, 0.5];
				_ctrl ctrlSetPosition [safeZoneX + (_i / _maxI) * safeZoneW, safeZoneY + (_j / _maxJ) * safeZoneH, safeZoneW / (_maxI * 1.5), safeZoneH / (_maxJ * 1.5)];
				_ctrl ctrlCommit 0;
			};
		};
*/
        };

	// Update weapons menu
	case "ui_update_medical": {
		_eventExists = true;
	};

	// Start dragging
	case "ui_dragging_start": {
		_eventExists = true;
		private _ctrl = _args param [0, controlNull];

		// Move the associated frame and picture to the cursor
		if (!isNull _ctrl and {_ctrl getVariable ["active", false]} and {ctrlShown _ctrl}) then {

			// Hide the original picture
			private _childPicture = _ctrl getVariable ["childPicture", controlNull];
			 _childPicture ctrlShow false;

                         // Create a temporary frame that stays on the slot
                         private _childFrameSlotTemp = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedFrame", MACRO_IDC_SCRIPTEDFRAME];
			 _childFrameSlotTemp ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);
			 _childFrameSlotTemp ctrlSetPosition ctrlPosition _ctrl;
			 _childFrameSlotTemp ctrlCommit 0;
			 _ctrl setVariable ["childFrameSlotTemp", _childFrameSlotTemp];

                         // Create a temporary picture that stays on the slot
 			 private _childPictureSlotTemp = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedPicture", MACRO_IDC_SCRIPTEDPICTURE];
 			 _childPictureSlotTemp ctrlSetText (_ctrl getVariable ["defaultIconPath", ""]);
 			 _childPictureSlotTemp ctrlSetPosition ctrlPosition _childPicture;
 			 _childPictureSlotTemp ctrlCommit 0;
 			 _ctrl setVariable ["childPictureSlotTemp", _childPictureSlotTemp];

 			 // Create a temporary frame that follows the cursor
 			 private _childFrameTemp = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedFrame", MACRO_IDC_SCRIPTEDFRAME];
 			 _childFrameTemp ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);
 			 _childFrameTemp ctrlSetPosition ctrlPosition _ctrl;
 			 _childFrameTemp ctrlCommit 0;
 			 _ctrl setVariable ["childFrameTemp", _childFrameTemp];

  			 // Create a temporary picture that follows the cursor
  			 private _childPictureTemp = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedPicture", MACRO_IDC_SCRIPTEDPICTURE];
  			 _childPictureTemp ctrlSetText ctrlText _childPicture;
  			 _childPictureTemp ctrlSetPosition ctrlPosition _childPicture;
  			 _childPictureTemp ctrlCommit 0;
  			 _ctrl setVariable ["childPictureTemp", _childPictureTemp];

			// Change the colour of the frame
			_ctrl ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_INVISIBLE);

			// Move the temporary children controls if the mouse is moving
			_ctrl ctrlAddEventHandler ["MouseMoving", {
				params ["_ctrl", "_posX", "_posY"];

				{
					private _pos = ctrlPosition _x;
					_pos set [0, _posX - (_pos param [2, 0]) / 2];
					_pos set [1, _posY - (_pos param [3, 0]) / 2];

					_x ctrlSetPosition _pos;
					_x ctrlCommit 0;
				} forEach [
					_ctrl getVariable ["childFrameTemp", controlNull],
					_ctrl getVariable ["childPictureTemp", controlNull]
				];
			}];
		};
	};

	// Stop dragging
	case "ui_dragging_stop": {
		_eventExists = true;
		private _ctrl = _args param [0, controlNull];

		if (!isNull _ctrl) then {
			_ctrl ctrlRemoveAllEventHandlers "MouseMoving";

			// Reset the colour of the frame
			if (_ctrl getVariable ["active", false]) then {
				_ctrl ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);
			};

			// Unhide the original controls
			private _childPicture = _ctrl getVariable ["childPicture", controlNull];
                        _childPicture ctrlShow true;

			// Update the position
			private _pos = ctrlPosition _ctrl;
			{
				ctrlDelete _x;
			} forEach [
                                _ctrl getVariable ["childFrameSlotTemp", controlNull],
                                _ctrl getVariable ["childPictureSlotTemp", controlNull],
                                _ctrl getVariable ["childFrameTemp", controlNull],
                                _ctrl getVariable ["childPictureTemp", controlNull]
			];
		};
	};
};




// DEBUG: Check if the event was recognised - if not, print a message
if (!_eventExists) then {
	private _str = format ["(%1) [INVENTORY] ERROR: Unknown event '%2' called!", time, _event];
	systemChat _str;
	hint _str;
};
