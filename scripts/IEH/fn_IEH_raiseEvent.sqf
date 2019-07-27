/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Raises an event for use with Inventory EventHandlers.
		For a list of possible events and their required arguments, see macros.hpp.
	Arguments:
		0:      <STRING>	The event to be raised
		1:	<ARRAY>		An array with the required arguments for this event
	Returns:
		(nothing)
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\res\common\macros.hpp"

// Fetch our params
params [
	["_event", "", [""]],
	["_args", [], [[]]]
];





// Fetch the itemData from the arguments
private _itemData = _args param [0, locationNull];

// Execute all the class-specific codes and functions that are listening to this event
{
	_args call _x;
} forEach ([_itemData getVariable [MACRO_VARNAME_CLASS, ""], _itemData getVariable [MACRO_VARNAME_CATEGORY, MACRO_ENUM_CATEGORY_INVALID], _event] call cre_fnc_cfg_getClassIEHs);

// TODO: Implement per-item IEHs (saved onto the itemData)
