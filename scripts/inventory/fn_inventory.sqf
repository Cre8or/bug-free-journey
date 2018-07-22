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
if (_event != "init") then {
        if (isNull _inventory) exitWith {systemChat "Inventory isn't open!"};
};





switch (_event) do {

        // Initialisation
        case "init": {
		_eventExists = true;
                [] spawn {

                        (findDisplay 46) createDisplay "Rsc_Cre8ive_Inventory";
			//createDialog "Rsc_Cre8ive_Inventory";

			private _timeOut = time + 1;
                        waitUntil {!isNull (uiNamespace getVariable ["cre8ive_dialog_inventory", displayNull]) or {time > _timeOut}};

                        if (time > _timeOut) then {
                                systemChat "Couldn't open inventory!";
                        } else {
                                // Fetch the inventory
                                private _inventory = uiNamespace getVariable ["cre8ive_dialog_inventory", displayNull];

                                // Write down the player's name
                                (_inventory displayCtrl MACRO_IDC_PLAYER_NAME) ctrlSetText name player;

				// Load the weapons menu (default)
				["menu_weapons"] call cre_fnc_inventory;
                        };
                };
        };

        // Show weapons menu
        case "menu_weapons": {
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
			MACRO_IDC_PRIMARYWEAPON_DRAGBOX,
                        MACRO_IDC_PRIMARYWEAPON_FRAME,
                        MACRO_IDC_PRIMARYWEAPON_ICON,
			MACRO_IDC_HANDGUNWEAPON_DRAGBOX,
                        MACRO_IDC_HANDGUNWEAPON_FRAME,
                        MACRO_IDC_HANDGUNWEAPON_ICON,
			MACRO_IDC_SECONDARYWEAPON_DRAGBOX,
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

                // Hide the medical controls
                {
                        (_inventory displayCtrl _x) ctrlShow false;
                } forEach [
                        MACRO_IDC_CHARACTER_ICON
                ];

                // Change the button colours
                private _buttonWeapons = _inventory displayCtrl MACRO_IDC_WEAPONS_BUTTON_FRAME;
                private _buttonMedical = _inventory displayCtrl MACRO_IDC_MEDICAL_BUTTON_FRAME;
                _buttonWeapons ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);
                _buttonWeapons ctrlCommit 0;
                _buttonMedical ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);
                _buttonMedical ctrlCommit 0;

                // Update the menu
                ["update_weapons"] call cre_fnc_inventory;
        };

        // Show medical menu
        case "menu_medical": {
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
			MACRO_IDC_PRIMARYWEAPON_DRAGBOX,
                        MACRO_IDC_PRIMARYWEAPON_FRAME,
                        MACRO_IDC_PRIMARYWEAPON_ICON,
			MACRO_IDC_HANDGUNWEAPON_DRAGBOX,
                        MACRO_IDC_HANDGUNWEAPON_FRAME,
                        MACRO_IDC_HANDGUNWEAPON_ICON,
			MACRO_IDC_SECONDARYWEAPON_DRAGBOX,
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

                // Show the medical controls
                {
                        (_inventory displayCtrl _x) ctrlShow true;
                } forEach [
                        MACRO_IDC_CHARACTER_ICON
                ];

                // Change the button colours
                private _buttonWeapons = _inventory displayCtrl MACRO_IDC_WEAPONS_BUTTON_FRAME;
                private _buttonMedical = _inventory displayCtrl MACRO_IDC_MEDICAL_BUTTON_FRAME;
                _buttonWeapons ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);
                _buttonWeapons ctrlCommit 0;
                _buttonMedical ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);
                _buttonMedical ctrlCommit 0;

                // Update the menu
                ["update_medical"] call cre_fnc_inventory;
        };

        // Update weapons menu
        case "update_weapons": {
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
				private _dragbox = _x select 0;
				private _frame = _x select 1;
                                private _icon = _x select 2;
				private _default = _x select 3;
                                private _iconPath = [_class, _default] call cre_fnc_getClassIcon;

                                _icon ctrlSetText _iconPath;
                                _frame ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);
                                _frame ctrlCommit 0;

				_dragbox setVariable ["active", true];
                        };
                } forEach [
                        [_inventory displayCtrl MACRO_IDC_NVGS_DRAGBOX,			_inventory displayCtrl MACRO_IDC_NVGS_FRAME,			_inventory displayCtrl MACRO_IDC_NVGS_ICON,		MACRO_PICTURE_NVGS],
                        [_inventory displayCtrl MACRO_IDC_HEADGEAR_DRAGBOX,		_inventory displayCtrl MACRO_IDC_HEADGEAR_FRAME,		_inventory displayCtrl MACRO_IDC_HEADGEAR_ICON,		MACRO_PICTURE_HEADGEAR],
                        [_inventory displayCtrl MACRO_IDC_GOGGLES_DRAGBOX,		_inventory displayCtrl MACRO_IDC_GOGGLES_FRAME,			_inventory displayCtrl MACRO_IDC_GOGGLES_ICON,		MACRO_PICTURE_GOGGLES],
                        [_inventory displayCtrl MACRO_IDC_BINOCULARS_DRAGBOX,		_inventory displayCtrl MACRO_IDC_BINOCULARS_FRAME, 		_inventory displayCtrl MACRO_IDC_BINOCULARS_ICON,	MACRO_PICTURE_BINOCULARS],
                        [_inventory displayCtrl MACRO_IDC_PRIMARYWEAPON_DRAGBOX,	_inventory displayCtrl MACRO_IDC_PRIMARYWEAPON_FRAME, 		_ctrlPrimaryWeapon,					MACRO_PICTURE_PRIMARYWEAPON],
                        [_inventory displayCtrl MACRO_IDC_HANDGUNWEAPON_DRAGBOX,	_inventory displayCtrl MACRO_IDC_HANDGUNWEAPON_FRAME,		_ctrlHandgunWeapon,					MACRO_PICTURE_HANDGUNWEAPON],
                        [_inventory displayCtrl MACRO_IDC_SECONDARYWEAPON_DRAGBOX,	_inventory displayCtrl MACRO_IDC_SECONDARYWEAPON_FRAME,		_ctrlSecondaryWeapon,					MACRO_PICTURE_SECONDARYWEAPON],
                        [_inventory displayCtrl MACRO_IDC_MAP_DRAGBOX,			_inventory displayCtrl MACRO_IDC_MAP_FRAME, 			_inventory displayCtrl MACRO_IDC_MAP_ICON,		MACRO_PICTURE_MAP],
                        [_inventory displayCtrl MACRO_IDC_GPS_DRAGBOX,			_inventory displayCtrl MACRO_IDC_GPS_FRAME, 			_inventory displayCtrl MACRO_IDC_GPS_ICON,		MACRO_PICTURE_GPS],
                        [_inventory displayCtrl MACRO_IDC_RADIO_DRAGBOX,		_inventory displayCtrl MACRO_IDC_RADIO_FRAME, 			_inventory displayCtrl MACRO_IDC_RADIO_ICON,		MACRO_PICTURE_RADIO],
                        [_inventory displayCtrl MACRO_IDC_COMPASS_DRAGBOX,		_inventory displayCtrl MACRO_IDC_COMPASS_FRAME, 		_inventory displayCtrl MACRO_IDC_COMPASS_ICON,		MACRO_PICTURE_COMPASS],
                        [_inventory displayCtrl MACRO_IDC_WATCH_DRAGBOX,		_inventory displayCtrl MACRO_IDC_WATCH_FRAME,	 		_inventory displayCtrl MACRO_IDC_WATCH_ICON,		MACRO_PICTURE_WATCH]
                ];
        };

	// Update weapons menu
	case "update_medical": {
		_eventExists = true;
	};

	// Start dragging
	case "dragging_start": {
		_eventExists = true;
		private _ctrl = _args param [0, controlNull];

		// Move the associated frame and picture to the cursor
		if (!isNull _ctrl and {_ctrl getVariable ["active", false]} and {ctrlShown _ctrl}) then {

			// Determine the children of the (dummy) control and save them onto it
			private _children = [];
			{
				private _idc = [MACRO_CONFIG_FILE >> STR(MACRO_GUI_NAME) >> "Controls" >> ctrlClassName _ctrl, _x, -1] call BIS_fnc_returnConfigEntry;

				if (_idc >= 0) then {
					_children pushBack (_inventory displayCtrl _idc);
				};
			} forEach ["childFrame", "childPicture"];
			_ctrl setVariable ["childControls", _children];

			// Change the colour of the dragbox
			_ctrl ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);

			// Move the children if the mouse is moving
			_ctrl ctrlAddEventHandler ["MouseMoving", {
				params ["_ctrl", "_posX", "_posY"];

				// Update the position
				{
					private _pos = ctrlPosition _x;
					_pos set [0, _posX - (_pos param [2, 0]) / 2];
					_pos set [1, _posY - (_pos param [3, 0]) / 2];

					// Move the control
					_x ctrlSetPosition _pos;
					_x ctrlCommit 0;
				} forEach (_ctrl getVariable ["childControls", []]);
			}];
		};
	};

	// Stop dragging
	case "dragging_stop": {
		_eventExists = true;
		private _ctrl = _args param [0, controlNull];

		if (!isNull _ctrl) then {
			_ctrl ctrlRemoveAllEventHandlers "MouseMoving";

			// Reset the colour of the dragbox
			_ctrl ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_INVISIBLE);

			// Update the position
			private _pos = ctrlPosition _ctrl;
			{
				_x ctrlSetPosition _pos;
				_x ctrlCommit 0;
			} forEach (_ctrl getVariable ["childControls", []]);
		};
	};
};




// DEBUG: Check if the event was recognised - if not, print a message
if (!_eventExists) then {
	private _str = format ["(%1) [INVENTORY] ERROR: Unknown event '%2' called!", time, _event];
	systemChat _str;
	hint _str;
};
