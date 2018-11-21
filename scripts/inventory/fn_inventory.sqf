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

	#include "events\ui_init.sqf"
	#include "events\ui_unload.sqf"
	#include "events\ui_menu_weapons.sqf"
	#include "events\ui_menu_medical.sqf"
	#include "events\ui_update_storage.sqf"
	#include "events\ui_update_weapons.sqf"
	#include "events\ui_update_medical.sqf"
	#include "events\ui_dragging_start.sqf"
	#include "events\ui_dragging.sqf"
	#include "events\ui_dragging_stop.sqf"
};





// DEBUG: Check if the event was recognised - if not, print a message
if (!_eventExists) then {
	private _str = format ["(%1) [INVENTORY] ERROR: Unknown event '%2' called!", time, _event];
	systemChat _str;
	hint _str;
};
