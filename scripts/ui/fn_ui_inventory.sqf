/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Handles the custom inventory UI. Accepts an event name (e.g. "ui_init") and an optional array with
		additional parameters that might be required for the specified event.
	Arguments:
		0:      <STRING>	Name of the event
		1:	<ARRAY>		Array of additional parameters for the specified event

	Returns:
		(nothing)

	EXAMPLE:
		["ui_init"] call cre_fnc_ui_inventory
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\res\common\macros.hpp"

// Fetch our params
params [
	["_event", "", [""]],
	["_args", []]
];

// Change the case to avoid mistakes
_event = toLower _event;

// Exit if no event was specified
if (_event == "") exitWith {systemChat "No event specified!"};

// Check if the inventory is open
disableSerialization;
private _eventExists = false;
private _inventory = uiNamespace getVariable ["cre8ive_dialog_inventory", displayNull];
if (isNull _inventory and {_event != "ui_init"}) exitWith {systemChat format ["Inventory isn't open! (%1)", _event]};





switch (_event) do {

	#include "events\ui_init.sqf"
	#include "events\ui_unload.sqf"
	#include "events\ui_focus_reset.sqf"
	#include "events\ui_menu_weapons.sqf"
	#include "events\ui_menu_medical.sqf"
	#include "events\ui_update_ground.sqf"
	#include "events\ui_update_weapons.sqf"
	#include "events\ui_update_medical.sqf"
	#include "events\ui_update_storage.sqf"
	#include "events\ui_dragging_init.sqf"
	#include "events\ui_dragging_start.sqf"
	#include "events\ui_dragging.sqf"
	#include "events\ui_dragging_rotate.sqf"
	#include "events\ui_dragging_abort.sqf"
	#include "events\ui_dragging_stop.sqf"
	#include "events\ui_dragging_complete.sqf"
	#include "events\ui_mouse_moving.sqf"
	#include "events\ui_mouse_exit.sqf"
	#include "events\ui_item_move.sqf"
};




/*
// DEBUG: Print the event name
private _filteredEvents = [
	"ui_focus_reset",
	"ui_mouse_exit",
//	"ui_mouse_moving",
	"ui_dragging_init",
	"ui_dragging",
	"ui_update_ground",
	"ui_update_storage"
];
if !(_event in _filteredEvents) then {
	systemChat format ["(%1) %2", time, _event];
};
*/

// DEBUG: Check if the event was recognised - if not, print a message
if (!_eventExists) then {
	private _str = format ["(%1) [INVENTORY] ERROR: Unknown event '%2' called!", time, _event];
	systemChat _str;
	hint _str;
};
