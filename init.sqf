enableSaving [false, false];

#include "res\common\macros.hpp"



// Functions
//cre_fnc_arrayToCA = compile preprocessFileLineNumbers "functions\fnc_arrayToCA.sqf";
//cre_fnc_generateUID = compile preprocessFileLineNumbers "functions\fnc_generateUID.sqf";
//cre_fnc_addWeaponWithItems = compile preprocessFileLineNumbers "functions\fnc_addWeaponWithItems.sqf";


/*
if (is3DEN) then {createDialog "Rsc_Cre8ive_Inventory"} else {["ui_init"] call cre_fnc_ui_inventory}
*/


// Add a keybinding to open the inventory (Tab)
[] spawn {
	waitUntil {!isNull findDisplay 46};

	(findDisplay 46) displayAddEventHandler ["KeyDown", {
		params ["", "_key"];

		if (_key == 15 and {inputAction "lookAround" == 0}) then {

			call compile preprocessFileLineNumbers "debug\recompileInventory.sqf";
			["ui_init", [cursorTarget]] call cre_fnc_ui_inventory;

			[] spawn {
				private _inventory = displayNull;
				waitUntil {
					_inventory = uiNamespace getVariable ["cre8ive_dialog_inventory", displayNull];
					!isNull _inventory;
				};

				_inventory displayAddEventHandler ["KeyDown", {
					params ["_display", "_key"];

					if (_key == 15 and {inputAction "lookAround" == 0}) then {
						_display closeDisplay 0;
					};
				}];
			};
		};
	}];

	systemChat "Added inventory keybinding (TAB)";
};




// Bonus stuff
cre_warfare = [] spawn compile preprocessFileLineNumbers "scripts\AI\fn_handleWarfare.sqf";



// Test script
player addAction ["<t color='#00DD00'>test.sqf</t>", {if (isNil "cre_handle") then {cre_handle = scriptNull}; terminate cre_handle; cre_handle = [] spawn compile preprocessFileLineNumbers "debug\test.sqf"}, nil, 10, false, false];



// Arsenal handling (translate custom inventory data to actual items, to prevent fakeMass items from interfering)
[missionNamespace, "arsenalOpened", {
	call compile preprocessFileLineNumbers "debug\onOpenArsenal.sqf";
}] call BIS_fnc_addScriptedEventHandler;
