/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Scheduled script that synchronises the player's actual inventory with the custom inventory data.
		When a mismatch is found, this function will attempt to update the custom data to match the actual
		inventory. However, if this is not possible, the actual inventory will be modified instead.
	Arguments:
		(none)
	Returns:
		(nothing)
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\res\config\dialogs\macros.hpp"

// Define some constants
private _sleepTime = 1 / 3;	// in seconds

// Define some variables
private _containerIndex = -1;





// Synchronise the inventories
while {true} do {

	// Fetch the current container
	private _container = objNull;
	_containerIndex = (_containerIndex + 1) % 3;
	switch (_containerIndex) do {
		case 0: {_container = uniformContainer player};
		case 1: {_container = vestContainer player};
		case 2: {_container = backpackContainer player};
	};

	// Only continue if the container exists
	if (!isNull _container) then {

		// Fetch the container data
		private _containerData = _container getVariable [MACRO_VARNAME_DATA, locationNull];
		private _items = _containerData getVariable [MACRO_VARNAME_ITEMS, []];

		// Iterate through the items list
		{

		} forEach _items;
	};

	sleep _sleepTime;
};
