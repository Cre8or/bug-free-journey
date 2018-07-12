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

                private _classes = [
                        hmd player,
                        headgear player,
                        goggles player,
                        binocular player,
                        primaryWeapon player,
                        secondaryWeapon player,
                        handgunWeapon player

                ];

                // Determine the icon paths for the items and weapons that we have
                {
                        private _class = _classes select _forEachIndex;

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
                        [_inventory displayCtrl MACRO_IDC_HANDGUNWEAPON_FRAME, _ctrlHandgunWeapon]
                ];
        };

};
