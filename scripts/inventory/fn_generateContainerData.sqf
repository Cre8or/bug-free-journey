/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Generates the data for a given inventory container, including slot position of items.
		NOTE: Due to how the algorithm works, some items may get lost in the conversion!
	Arguments:
		0:      <OBJECT>	Container object to generate data for
	Returns:
		0:      <LOCATION>	Generated container data
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\res\config\dialogs\macros.hpp"

params [
	["_container", objNull, [objNull]]
];

// If no object was provided, exit and return a null location
if (isNull _container) exitWith {locationNull};





// Fetch the object's container data and delete it (aswell as all contained item data)
private _oldContainerData = _container getVariable ["cre8ive_data", locationNull];
{
	deleteLocation _x;
} forEach (_oldContainerData getVariable ["items", []]);
deleteLocation _oldContainerData;

// Now, let's regenerate the data from scratch
// Define some variables
private _index = 0;
private _items = [];

// Create some temporary namespaces
private _slotAreaNamespace = createLocation ["NameVillage", [0,0,0], 0, 0];
private _itemsListNamespace = createLocation ["NameVillage", [0,0,0], 0, 0];

// Iterate through the container
{
	private _formatType = _forEachIndex;

	// Iterate through the sub-arrays
	{
		private _class = _x;
		if (_x isEqualType []) then {
			_class = _x select 0;
		} else {
			_x = [_class];
		};

		private _category = [_class] call cre_fnc_getClassCategory;
		private _slotSize = [_class, _category] call cre_fnc_getClassSlotSize;
		private _slotArea = (_slotSize select 0) * (_slotSize select 1);
		private _slotAreaStr = format ["%1.0", _slotArea];

		// Generate a UID for the item
		private _UID = call cre_fnc_generateUID;

		// Get the list of indexes for this specific slot area, and add the current one to it
		private _indexes = _slotAreaNamespace getVariable [_slotAreaStr, []];
		_slotAreaNamespace setVariable [_slotAreaStr, _indexes + [_index]];

		// Save the item using its UID so we can find it later, along with an index to classify its data format
		_itemsListNamespace setVariable [_UID, [_formatType, _x]];

		// Add the item's UID to the list of items (to be sorted later)
		_items pushBack _UID;

		// Increase the index
		_index = _index + 1;
	} forEach _x;

} forEach [
	magazinesAmmoCargo _container,
	weaponsItemsCargo _container,
	itemCargo _container,
	everyContainer _container
];





// Fetch the maximum slot area in the list
private _max = 0;
private _slotAreaGroups = (allVariables _slotAreaNamespace) apply {
	private _ret = parseNumber _x;
	_max = _max max _ret;
	_ret;
};

// Sort the items using the slot area groups
private _itemsSorted = [];
for "_i" from 1 to count _slotAreaGroups do {
	private _indexes = _slotAreaNamespace getVariable [format ["%1.0", _max], []];

	// Add the items with this slot area to the list
	{
		_itemsSorted pushBack (_items select _x);
	} forEach _indexes;

	private _maxNew = 0;
	for "_i" from (count _slotAreaGroups) - 1 to 0 step -1 do {
		private _slotArea = _slotAreaGroups select _i;
		if (_max == _slotArea) then {
			_slotAreaGroups deleteAt _i;
		} else {
			_maxNew = _maxNew max _slotArea;
		};
	};

	_max = _maxNew;
};

// Delete the temporary slot area namespace
deleteLocation _slotAreaNamespace;

// Create a new namespace for the container
(call cre_fnc_inventory_createNamespace) params ["_containerData"];

// Iterate through the sorted list of items and fit them into the container
([typeOf _container] call cre_fnc_getContainerSize) params ["_containerSize", "_containerSlotsOnLastY"];
private _containerItems = [];
_containerData setVariable ["containerSize", _containerSize];
_containerData setVariable ["containerSlotsOnLastY", _containerSlotsOnLastY];

// Fetch the width and height of the container
_containerSize params ["_sizeW", "_sizeH"];
private _lastFreeY = 1;
{
	scopeName "loopItems";

	// Fetch the data associated to this UID
	private _data = _itemsListNamespace getVariable [_x, []];
	_data params ["_formatType", "_args"];

	// Fetch some information from the item
	private _class = _args select 0;
	private _category = [_class] call cre_fnc_getClassCategory;
	private _itemSize = [_class, _category] call cre_fnc_getClassSlotSize;

	// Generate a namespace for this item and save the item class onto it
	(call cre_fnc_inventory_createNamespace) params ["_itemData"];
	_itemData setVariable [MACRO_VARNAME_CLASS, _class];

	// Iterate through the container to see where we can fit the item
	for "_posY" from _lastFreeY to _sizeH do {
		private _yHasFreeSlot = false;

		_newW = [_sizeW, _containerSlotsOnLastY] select (_posY == _sizeH);
		for "_posX" from 1 to _newW do {
			scopeName "loopSlots";

			private _slotStr = format [MACRO_VARNAME_SLOT_X_Y, _posX, _posY];
			private _slotData = _containerData getVariable [_slotStr, locationNull];

			// If this slot is empty, check if the item can fit in it
			if (isNull _slotData) then {
				_yhasFreeSlot = true;

				// First of all, test if the item even fits in this position
				private _posEndX = _posX + (_itemSize select 0) - 1;
				private _posEndY = _posY + (_itemSize select 1) - 1;
				if (_posEndX <= _newW and {_posEndY <= _sizeH}) then {

					// The dimensions fit, now we check if the required slots are all free
					private _requiredSlots = [];
					for "_posItemY" from _posY to _posEndY do {
						for "_posItemX" from _posX to _posEndX do {
							private _requiredSlotStr = format [MACRO_VARNAME_SLOT_X_Y, _posItemX, _posItemY];
							private _requiredSlot = _containerData getVariable [_requiredSlotStr, locationNull];

							// If the slot is empty, add it to the list
							if (isNull _requiredSlot) then {
								_requiredSlots pushBack _requiredSlotStr;

							// Otherwise, abort and look for a new slot
							} else {
								breakTo "loopSlots";
							};
						};
					};

					// If we didn't exit the loop yet, then the slots are free
					{
						_containerData setVariable [_x, _itemData];
					} forEach _requiredSlots;

					// Now we may fill in the item data
					// The provided scripting commands return results in a different format, so we have to choose accordingly
					switch (_formatType) do {

						// magazinesAmmoCargo
						case 0: {
							private _ammo = _args select 1;
							private _maxAmmo = [_class] call cre_fnc_getMagazineMaxAmmo;

							_itemData setVariable [MACRO_VARNAME_MAG_AMMO, _ammo];
							_itemData setVariable [MACRO_VARNAME_MAG_MAXAMMO, _maxAmmo];
						};

						// weaponsItemsCargo
						case 1: {
							[_itemData, _args] call cre_fnc_generateWeaponAccData;
						};

						// itemCargo
						case 2: {

						};

						// everyContainer
						case 3: {
							private _containerX = _args select 1;

							// Recursively generate the container data for all nested containers
							[_containerX] call cre_fnc_generateContainerData;
						};
					};

					_itemData setVariable [MACRO_VARNAME_SLOTPOS, [_posX, _posY]];
					_itemData setVariable [MACRO_VARNAME_PARENT, _containerData];
					_containerItems pushBack _itemData,
					//systemChat format ["Added %1 at pos: %2", _class, [_posX, _posY]];

					// Move on to the next item
					breakTo "loopItems";
				};
			};
		};

		// If there were no free slots left on this Y-line, ignore it in future searches
		if (!_yHasFreeSlot) then {
			_lastFreeY = _posY + 1;
		};
	};

} forEach _itemsSorted;

// Save the list of items for quick access
_containerData setVariable ["items", _containerItems];

// Save the container data onto the container object
_container setVariable ["cre8ive_data", _containerData];
//systemChat format ["Container has %1 items", count _containerItems];

// Return the data
_containerData;
