#include "..\..\res\config\dialogs\macros.hpp"

params [
        ["_event", "", [""]]
];

_event = toLower _event;

// Exit if no event was specified
if (_event == "") exitWith {systemChat "No event specified!"};

// Check if the inventory is open
disableSerialization;
private _inventory = uiNamespace getVariable ["cre8ive_dialog_inventory", displayNull];
if (_event != "init") then {
        if (isNull _inventory) exitWith {systemChat "Inventory isn't open!"};
};





switch (_event) do {

        // Initialisation
        case "init": {
                [] spawn {

                        (findDisplay 46) createDisplay "Rsc_Cre8ive_Inventory";

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
                        MACRO_IDC_SECONDARYWEAPON_FRAME,
                        MACRO_IDC_SECONDARYWEAPON_ICON,
                        MACRO_IDC_HANDGUNWEAPON_FRAME,
                        MACRO_IDC_HANDGUNWEAPON_ICON,
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
                        MACRO_IDC_SECONDARYWEAPON_FRAME,
                        MACRO_IDC_SECONDARYWEAPON_ICON,
                        MACRO_IDC_HANDGUNWEAPON_FRAME,
                        MACRO_IDC_HANDGUNWEAPON_ICON,
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
                        secondaryWeapon player,
                        handgunWeapon player,
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
                                private _iconPath = [_class] call cre_fnc_getClassIcon;

                                _icon ctrlSetText _iconPath;
                                _frame ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);
                                _Frame ctrlCommit 0;
                        };
                } forEach [
                        [_inventory displayCtrl MACRO_IDC_NVGS_FRAME, _inventory displayCtrl MACRO_IDC_NVGS_ICON],
                        [_inventory displayCtrl MACRO_IDC_HEADGEAR_FRAME, _inventory displayCtrl MACRO_IDC_HEADGEAR_ICON],
                        [_inventory displayCtrl MACRO_IDC_GOGGLES_FRAME, _inventory displayCtrl MACRO_IDC_GOGGLES_ICON],
                        [_inventory displayCtrl MACRO_IDC_BINOCULARS_FRAME, _inventory displayCtrl MACRO_IDC_BINOCULARS_ICON],
                        [_inventory displayCtrl MACRO_IDC_PRIMARYWEAPON_FRAME, _ctrlPrimaryWeapon],
                        [_inventory displayCtrl MACRO_IDC_SECONDARYWEAPON_FRAME, _ctrlSecondaryWeapon],
                        [_inventory displayCtrl MACRO_IDC_HANDGUNWEAPON_FRAME, _ctrlHandgunWeapon],
                        [_inventory displayCtrl MACRO_IDC_MAP_FRAME, _inventory displayCtrl MACRO_IDC_MAP_ICON],
                        [_inventory displayCtrl MACRO_IDC_GPS_FRAME, _inventory displayCtrl MACRO_IDC_GPS_ICON],
                        [_inventory displayCtrl MACRO_IDC_RADIO_FRAME, _inventory displayCtrl MACRO_IDC_RADIO_ICON],
                        [_inventory displayCtrl MACRO_IDC_COMPASS_FRAME, _inventory displayCtrl MACRO_IDC_COMPASS_ICON],
                        [_inventory displayCtrl MACRO_IDC_WATCH_FRAME, _inventory displayCtrl MACRO_IDC_WATCH_ICON]
                ];
        };
};
