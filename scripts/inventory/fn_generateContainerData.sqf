/* --------------------------------------------------------------------------------------------------------------------
        Author:         Cre8or
        Description:
                Generates the data for a given inventory container, including slot position of items.
		NOTE: Due to how the algorithm works, some items may get lost in the conversion!
        Arguments:
                0:      <OBJECT>        Container object to generate data for
        Returns:
                0:      <LOCATION>	Generated container data
-------------------------------------------------------------------------------------------------------------------- */

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
private _index = 0;
private _items = [];

// Create a temporary namespace
private _namespace = createLocation ["NameVillage", [0,0,0], 0, 0];

// Iterate through all items inside the container
{
	_x params ["_classes", "_counts"];

	// Add the items to the list
	{
		private _count = _counts select _forEachIndex;
		private _category = [_x] call cre_fnc_getClassCategory;
		private _slotSize = [_x, _category] call cre_fnc_getClassSlotSize;
		private _slotArea = (_slotSize select 0) * (_slotSize select 1);
		private _slotAreaStr = format ["%1.0", _slotArea];

		// Get the list of array indexes for this specific slot area
		private _indexes = _namespace getVariable [_slotAreaStr, []];

		for "_i" from 1 to _count do {
			_items pushBack _x;
			_indexes pushBack _index;

			_index = _index + 1;
		};

		_namespace setVariable [_slotAreaStr, _indexes];
		//systemChat format ["Saved indexes for area %1: %2", _slotArea, _indexes];
	} forEach _classes;

} forEach [
	getWeaponCargo _container,
	getMagazineCargo _container,
	getItemCargo _container,
	getBackpackCargo _container
];

// Fetch the maximum slot area in the list
private _max = 0;
private _slotAreaRegions = (allVariables _namespace) apply {
	private _ret = parseNumber _x;
	_max = _max max _ret;
	_ret;
};

// Sort the items using the slot area regions
private _itemsSorted = [];
for "_i" from 1 to count _slotAreaRegions do {
	private _indexes = _namespace getVariable [format ["%1.0", _max], []];
	//systemChat format ["Fetching indexes for slot area: %1: %2", _max, _indexes];

	// Added the classes with this slot area to the list
	{
		_itemsSorted pushBack (_items select _x);
	} forEach _indexes;

	private _maxNew = 0;
	for "_i" from (count _slotAreaRegions) - 1 to 0 step -1 do {
		private _slotArea = _slotAreaRegions select _i;
		if (_max == _slotArea) then {
			_slotAreaRegions deleteAt _i;
		} else {
			_maxNew = _maxNew max _slotArea;
		};
	};

	_max = _maxNew;
};

// Delete the temporary namespace
deleteLocation _namespace;

// Create a namespace for the container (since it doesn't exist yet)
(call cre_fnc_inventory_createNamespace) params ["_containerData", "_containerUID"];

// Iterate through the sorted list of items and fit them into the container
([typeOf _container] call cre_fnc_getContainerSize) params ["_containerSize", "_containerSlotsCount"];
private _containerItems = [];
_containerData setVariable ["containerSize", _containerSize];
_containerData setVariable ["containerSlotsCount", _containerSlotsCount];

// Fetch the width and height of the container
_containerSize params ["_sizeW", "_sizeH"];
private _lastYSizeW = _containerSlotsCount - (_sizeH - 1) * _sizeW;
private _lastFreeY = 1;
isNil {         // Run in unscheduled code
        {
        	scopeName "loopItems";

        	// Fetch the data for this class
        	private _category = [_x] call cre_fnc_getClassCategory;
        	private _itemSize = [_x, _category] call cre_fnc_getClassSlotSize;

        	// Generate a namespace for this item and save the item class onto it
        	(call cre_fnc_inventory_createNamespace) params ["_itemData", "_itemUID"];
        	_itemData setVariable ["class", _x];

        	// Iterate through the container to see where we can fit the item
        	for "_posY" from _lastFreeY to _sizeH do {
        		private _yHasFreeSlot = false;

        		_newW = [_sizeW, _lastYSizeW] select (_posY == _sizeH);
        		for "_posX" from 1 to _newW do {
        			scopeName "loopSlots";

        			private _slotStr = format ["slot_%1_%2", _posX, _posY];
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
        							private _requiredSlotStr = format ["slot_%1_%2", _posItemX, _posItemY];
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

        					_itemData setVariable ["slotPos", [_posX, _posY]];
        					_containerItems pushBack _itemData,
        					//systemChat format ["Added %1 at pos: %2", _x, [_posX, _posY]];

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
};

// Save the list of items for quick access
_containerData setVariable ["items", _containerItems];

// Save the container data onto the container object
_container setVariable ["cre8ive_data", _containerData];
//systemChat format ["Container has %1 items", count _containerItems];

// Return the data
_containerData;
