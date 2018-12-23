/* --------------------------------------------------------------------------------------------------------------------
	Author:	 	Cre8or
	Description:
		Checks if an item can fit in the given slot of a container.
		If so, returns true, along with an array of controls that will be used by the item. Otherwise,
		returns false, along with an array of controls that are preventing the item from fitting.
		NOTE: The load of the container will NOT be checked, merely the slots matter!
	Arguments:
		0:      <LOCATION>	The data of the item to be inserted
		1:      <LOCATION>	The data of the container to insert into
		2:	<ARRAY>		Slot position of the container (in format [x,y])
		3:	<ARRAY>		Slot size of the item in format [w,h]
		4:	<BOOL>		Whether we should perform a simple check (true - faster) or a full
					check (false - slower)
	Returns:
		0:	<BOOL>		Whether or not the item fits
		1:	<ARRAY>		List of slot controls that will be used by the item (if true), or that prevent
					the item from fitting (if false)
					NOTE: Only used when performing full checks! (always empty on simple checks)
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\res\config\dialogs\macros.hpp"

params [
	["_itemData", locationNull, [locationNull]],
	["_containerData", locationNull, [locationNull]],
	["_slotPos", [MACRO_ENUM_SLOTPOS_INVALID], [[]]],
	["_slotSize", [1,1], [[]]],
	["_doSimpleCheck", true, [true]]
];
//systemChat format ["[canFitItem] item: %1 - container: %2 - pos: %3 - size: %4 - simple: %5", _itemData getVariable [MACRO_VARNAME_UID, "n/a"], _containerData getVariable [MACRO_VARNAME_UID, "n/a"], _slotPos, _slotSize, _doSimpleCheck];

// If no container was provided, exit and return false
if (isNull _containerData) exitWith {
	//systemChat "(canFitItem) FAIL: Container data is null!";
	[false, []]
};





// Define some variables
_res = [false, []];

// Fetch the slot size of the item
_slotSize params [
	["_itemW", 1],
	["_itemH", 1]
];
_slotPos params [
	["_slotStartX", MACRO_ENUM_SLOTPOS_INVALID],
	"_slotStartY"
];

// Fetch the size of the container
(_containerData getVariable [MACRO_VARNAME_CONTAINERSIZE, [1,1]]) params ["_containerW", "_containerH"];
private _containerSlotsOnLastY = _containerData getVariable [MACRO_VARNAME_CONTAINERSLOTSONLASTY, 0];

// Define the scope name
scopeName "main";






// If the slot position is a reserved slot (negative X values), check the allowed slots
if (_slotStartX < 0) then {

	// Determine the expected slot data based on the slot position enumeration
	private _slotVarName = "";
	private _slotCategory = MACRO_ENUM_CATEGORY_INVALID;
	private _slotSubCategory = MACRO_ENUM_SUBCATEGORY_INVALID;
	switch (_slotStartX) do {
		// Weapon slots
		case MACRO_ENUM_SLOTPOS_PRIMARYWEAPON: {
			_slotVarName =		MACRO_VARNAME_UNIT_PRIMARYWEAPON;
			_slotCategory =		MACRO_ENUM_CATEGORY_WEAPON;
			_slotSubCategory =	MACRO_ENUM_SUBCATEGORY_PRIMARYWEAPON;
		};
		case MACRO_ENUM_SLOTPOS_HANDGUNWEAPON: {
			_slotVarName =		MACRO_VARNAME_UNIT_HANDGUNWEAPON;
			_slotCategory =		MACRO_ENUM_CATEGORY_WEAPON;
			_slotSubCategory =	MACRO_ENUM_SUBCATEGORY_HANDGUNWEAPON;
		};
		case MACRO_ENUM_SLOTPOS_HANDGUNWEAPON: {
			_slotVarName =		MACRO_VARNAME_UNIT_HANDGUNWEAPON;
			_slotCategory =		MACRO_ENUM_CATEGORY_WEAPON;
			_slotSubCategory =	MACRO_ENUM_SUBCATEGORY_HANDGUNWEAPON;
		};

		// Item slots (top)
		case MACRO_ENUM_SLOTPOS_NVGS: {
			_slotVarName =		MACRO_VARNAME_UNIT_NVGS;
			_slotCategory =		MACRO_ENUM_CATEGORY_ITEM;
			_slotSubCategory =	MACRO_ENUM_SUBCATEGORY_NVGS;
		};
		case MACRO_ENUM_SLOTPOS_HEADGEAR: {
			_slotVarName =		MACRO_VARNAME_UNIT_HEADGEAR;
			_slotCategory =		MACRO_ENUM_CATEGORY_HEADGEAR;
		};
		case MACRO_ENUM_SLOTPOS_BINOCULARS: {
			_slotVarName =		MACRO_VARNAME_UNIT_BINOCULARS;
			_slotCategory =		MACRO_ENUM_CATEGORY_ITEM;
			_slotSubCategory =	MACRO_ENUM_SUBCATEGORY_BINOCULARS;
		};
		case MACRO_ENUM_SLOTPOS_GOGGLES: {
			_slotVarName =		MACRO_VARNAME_UNIT_GOGGLES;
			_slotCategory =		MACRO_ENUM_CATEGORY_GOGGLES;
		};

		// Item slots (bottom)
		case MACRO_ENUM_SLOTPOS_MAP: {
			_slotVarName =		MACRO_VARNAME_UNIT_MAP;
			_slotCategory =		MACRO_ENUM_CATEGORY_ITEM;
			_slotSubCategory =	MACRO_ENUM_SUBCATEGORY_MAP;
		};
		case MACRO_ENUM_SLOTPOS_GPS: {
			_slotVarName =		MACRO_VARNAME_UNIT_GPS;
			_slotCategory =		MACRO_ENUM_CATEGORY_ITEM;
			_slotSubCategory =	MACRO_ENUM_SUBCATEGORY_GPS;
		};
		case MACRO_ENUM_SLOTPOS_RADIO: {
			_slotVarName =		MACRO_VARNAME_UNIT_RADIO;
			_slotCategory =		MACRO_ENUM_CATEGORY_ITEM;
			_slotSubCategory =	MACRO_ENUM_SUBCATEGORY_RADIO;
		};
		case MACRO_ENUM_SLOTPOS_COMPASS: {
			_slotVarName =		MACRO_VARNAME_UNIT_COMPASS;
			_slotCategory =		MACRO_ENUM_CATEGORY_ITEM;
			_slotSubCategory =	MACRO_ENUM_SUBCATEGORY_COMPASS;
		};
		case MACRO_ENUM_SLOTPOS_WATCH: {
			_slotVarName =		MACRO_VARNAME_UNIT_WATCH;
			_slotCategory =		MACRO_ENUM_CATEGORY_ITEM;
			_slotSubCategory =	MACRO_ENUM_SUBCATEGORY_WATCH;
		};

		// Uniform, vest and backpack slots
		case MACRO_ENUM_SLOTPOS_UNIFORM: {
			_slotVarName =		MACRO_VARNAME_UNIT_UNIFORM;
			_slotCategory =		MACRO_ENUM_CATEGORY_UNIFORM;
		};
		case MACRO_ENUM_SLOTPOS_VEST: {
			_slotVarName =		MACRO_VARNAME_UNIT_VEST;
			_slotCategory =		MACRO_ENUM_CATEGORY_VEST;
		};
		case MACRO_ENUM_SLOTPOS_BACKPACK: {
			_slotVarName =		MACRO_VARNAME_UNIT_BACKPACK;
			_slotCategory =		MACRO_ENUM_CATEGORY_BACKPACK;
		};
	};

	// If we found a valid varname...
	if (_slotVarName != "") then {

		// Fetch the item data from the reserved slot
		private _slotData = _containerData getVariable [_slotVarName, locationNull];

		// If the slot is empty...
		if (isNull _slotData or {_slotData == _itemData}) then {

			// Fetch the item's category
			private _class = _itemData getVariable [MACRO_VARNAME_CLASS, ""];
			private _category = [_class] call cre_fnc_getClassCategory;

			// If the item is of the right category...
			if (_category == _slotCategory) then {

				// Fetch the item's subcategory, if it has one
				private _subCategory = [_class, _category] call cre_fnc_getClassSubCategory;

				// If the item is also of the right subcategory, accept it
				if (_subCategory == _slotSubCategory) then {
					_res = [true, []];
				};
			};
		};
	};

// Otherwise, determine whether the item fits based on the slot position and size
} else {

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
			or {_itemData == _containerData}
		) then {
			//systemChat "(canFitItem) FAIL: Item does not fit in the container!";
			breakTo "main"
		};

		// Exception handling for the last line in the inventory (which might have less slots)
		if (_slotEndY == _containerH and {_slotEndX > _containerSlotsOnLastY}) then {
			//systemChat format ["(canFitItem) FAIL: Item does not fit in the container's last line! (%1 > %2)", _slotStartX + _itemW - 1, _containerSlotsOnLastY];
			breakTo "main"
		};

		// Iterate through the required slots
		for "_y" from _slotStartY to _slotEndY do {
			for "_x" from _slotStartX to _slotEndX do {


				// Fetch the slot data
				private _slotData = _containerData getVariable [format [MACRO_VARNAME_SLOT_X_Y, _x, _y], locationNull];

				// If any of the slots is occupied, break and exit
				if (!isNull _slotData and {_slotData != _itemData}) then {
					//systemChat format ["(canFitItem) FAIL: Found a non-null slot at: %1,%2", _x, _y];
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
		private _canFit = true;

		// If the item would be out of boundaries at the given slot position, abort
		if (
			_slotStartX < 1
			or {_slotStartY < 1}
			or {_slotEndX > _containerW}
			or {_slotEndY > _containerH}
			or {_itemData == _containerData}
		) then {
			_canFit = false;
		};

		// Exception handling for the last line in the inventory (which might have less slots)
		if (_slotEndY == _containerH and {_slotEndX > _containerSlotsOnLastY}) then {
			_canFit = false;
		};

		// Define some variables
		private _slots = [];

		// Iterate through the required slots
		for "_y" from _slotStartY to _slotEndY do {
			for "_x" from _slotStartX to _slotEndX do {

				//systemChat format ["(%1) Testing: %2,%3", time, _x, _y];

				// Fetch the slot data
				private _slotData = _containerData getVariable [format [MACRO_VARNAME_SLOT_X_Y, _x, _y], locationNull];
				private _slotPos = _slotData getVariable [MACRO_VARNAME_SLOTPOS, [_x, _y]];

				if (isNull _slotData or {_slotData == _itemData}) then {
					_slots pushBack [_x, _y];
				} else {
					_canFit = false;
					_slots pushBack _slotPos;
				};

			};
		};

		_res = [_canFit, _slots];
	};
};

// Return the result
_res;
