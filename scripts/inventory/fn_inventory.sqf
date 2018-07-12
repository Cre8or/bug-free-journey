#include "..\..\res\config\dialogs\macros.hpp"

params [
        ["_event", "", [""]]
];

_event = toLower _event;

// Exit if no event was specified
if (_event == "") exitWith {systemChat "No event specified!"};

// Check if the inventory is open
disableSerialization;
private _inventory = uiNamespace GetVariable ["cre8ive_dialog_inventory", displayNull];
if (_event != "init") then {
        if (isNull _inventory) exitWith {systemChat "Inventory isn't open!"};
};





switch (_event) do {

        // Initialisation
        case "init": {
                [] spawn {

                        (findDisplay 46) createDisplay "Rsc_Cre8ive_Inventory";

                        private _timeOut = time + 1;
                        waitUntil {!isNull (findDisplay 888801) or {time > _timeOut}};

                        ["update"] call cre_fnc_inventory;
                };
        };

        // Update
        case "update": {
                // Grab all of our inventory controls
                private _ctrlPrimaryWeapon = _inventory displayCtrl MACRO_IDC_PRIMARYWEAPON_ICON;
                private _ctrlSecondaryWeapon = _inventory displayCtrl MACRO_IDC_SECONDARYWEAPON_ICON;
                private _ctrlHandgunWeapon = _inventory displayCtrl MACRO_IDC_HANDGUNWEAPON_ICON;

                private _types = [
                        primaryWeapon player,
                        secondaryWeapon player,
                        handgunWeapon player
                ];

                // Determine the icon paths for the items and weapons that we have
                {
                        private _type = _types select _forEachIndex;

                        if (_type != "") then {
                                private _icon = [configfile >> "CfgWeapons" >> _type, "picture", ""] call BIS_fnc_returnConfigEntry;

                                _x ctrlSetText _icon;
                        };
                } forEach [
                        _ctrlPrimaryWeapon,
                        _ctrlSecondaryWeapon,
                        _ctrlHandgunWeapon
                ];
        };

};
