/* --------------------------------------------------------------------------------------------------------------------
	Author:	 	Cre8or
	Description:
		Checks if an item can fit in the given slot of a container.
		If so, returns true, along with an array of controls that will be used by the item. Otherwise,
		returns false, along with an array of controls that are preventing the item from fitting.
		NOTE: The load of the container will NOT be checked, merely the slots matter!
	Arguments:
		0:      <LOCATION>	The data of the container to insert into
		2:	<ARRAY>		Slot position of the container (in format [x,y])
		1:	<ARRAY>		Slot size of the item in format [w,h]
		3:	<BOOL>		Whether we should perform a simple check (true - faster) or a full
					check (false - slower)
	Returns:
		0:	<BOOL>		Whether or not the item fits
		1:	<ARRAY>		List of slot controls that will be used by the item (if true), or that prevent
					the item from fitting (if false)
					NOTE: Only used when performing full checks! (always empty on simple checks)
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\res\config\dialogs\macros.hpp"

params [
	["_containerData", locationNull, [locationNull]],
	["_slotPos", [1,1], [[]]],
	["_slotSize", [1,1], [[]]],
	["_doSimpleCheck", true, [true]]
];

// If no container was provided, exit and return false
if (isNull _containerData) exitWith {
	systemChat "(canFitItem) FAIL: Container data is null!";
	[false, []]
};





// Define some variables
_res = [false, []];

// Fetch the slot size of the item
_slotSize params ["_itemW", "_itemH"];
_slotPos params ["_slotStartX", "_slotStartY"];

// Fetch the size of the container
(_containerData getVariable ["containerSize", [1,1]]) params ["_containerW", "_containerH"];
private _containerSlotsOnLastY = _containerData getVariable ["containerSlotsOnLastY", 0];

// Define the scope name
scopeName "main";

// If we're doing a simple check, keep things simple for the best performance
if (_doSimpleCheck) then {

	private _slotEndX = _slotStartX + _itemW - 1;
	private _slotEndY = _slotStartY + _itemH - 1;

	// If the item would be out of boundaries at the given slot position, abort
	if (
		_slotStartX < 1
		or {_slotStartY < 1}
		or {_slotEndX > _containerW}
		or {_slotEndY > _containerH}
	) then {
		systemChat "(canFitItem) FAIL: Item does not fit in the container!";
		breakTo "main"
	};

	// Exception handling for the last line in the inventory (which might have less slots)
	if (_slotEndY == _containerH and {_slotEndX > _containerSlotsOnLastY}) then {
		systemChat format ["(canFitItem) FAIL: Item does not fit in the container's last line! (%1 > %2)", _slotStartX + _itemW - 1, _containerSlotsOnLastY];
		breakTo "main"
	};

	// Iterate through the required slots
	for "_y" from _slotStartY to _slotEndY do {
		for "_x" from _slotStartX to _slotEndX do {

			// Fetch the slot data
			private _slotData = _containerData getVariable [format [MACRO_VARNAME_SLOT_X_Y, _x, _y], locationNull];

			// If any of the slots is occupied, break and exit
			if (!isNull _slotData) then {
				systemChat format ["(canFitItem) FAIL: Found a non-null slot at: %1,%2", _x, _y];
				breakTo "main";
			};
		};
	};

	// If we got this far, everything went well, so we return true
	_res = [true, []];


// Otherwise (if we're performing a full check), we need to gather additional information
} else {

	private _slotEndX = _slotStartX + _itemW - 1;
	private _slotEndY = _slotStartY + _itemH - 1;

	// If the item would be out of boundaries at the given slot position, abort
	if (
		_slotStartX < 1
		or {_slotStartY < 1}
		or {_slotEndX > _containerW}
		or {_slotEndY > _containerH}
	) then {
		systemChat "(canFitItem) FAIL: Item does not fit in the container!";
		breakTo "main";
	};

	// Exception handling for the last line in the inventory (which might have less slots)
	if (_slotEndY == _containerH and {_slotEndX > _containerSlotsOnLastY}) then {
		systemChat format ["(canFitItem) FAIL: Item does not fit in the container's last line! (%1 > %2)", _slotStartX + _itemW - 1, _containerSlotsOnLastY];
		breakTo "main"
	};

	// Define some variables
	private _slots = [];
	private _canFit = true;

	// Iterate through the required slots
	for "_y" from _slotStartY to _slotEndY do {
		for "_x" from _slotStartX to _slotEndX do {

			//systemChat format ["(%1) Testing: %2,%3", time, _x, _y];

			// Fetch the slot data
			private _slotData = _containerData getVariable [format [MACRO_VARNAME_SLOT_X_Y, _x, _y], locationNull];

			if (!isNull _slotData) then {
				_canFit = false;
			};

			_slots pushBack [_x, _y];
		};
	};

	_res = [_canFit, _slots];
};

// Return the result
_res;
