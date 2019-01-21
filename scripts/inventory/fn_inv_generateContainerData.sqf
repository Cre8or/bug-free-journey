/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Generates the data for a given inventory container, including slot position of items.
		ALso works on units. In this case, it will generate item data for the weapon's units and assigned items,
		and recursively run the function on the unit's vest, uniform and backpack containers (true by default,
		see argument #1).
		NOTE: Due to how the algorithm works, some items may get lost in the process (due to item sizes)!
	Arguments:
		0:      <OBJECT>	Container object to generate data for
		1:	<BOOL>		If the container is a unit, this bool will decide whether to also generate
					container data for the unit's vest, uniform and backpack (true), or just
					the unit's data (weapons and assigned items) (false)
	Returns:
		0:      <LOCATION>	Generated container data
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\res\config\dialogs\macros.hpp"

// Fetch our params
params [
	["_container", objNull, [objNull]],
	["_containerClass", "", [""]],
	["_recursiveOnUnits", true, [true]]
];

// If no object was provided, exit and return a null location
if (isNull _container) exitWith {locationNull};





// Fetch the object's previous container data and delete it (aswell as all contained item data)
private _containerData = _container getVariable [MACRO_VARNAME_DATA, locationNull];
{
	deleteLocation _x;
} forEach (_containerData getVariable ["items", []]);
deleteLocation _containerData;





// If the container is a unit, the data has to be generated differently (due to predetermined slots)
if (_container isKindOf "Man") then {

	// Create a new namespace for the container
	_containerData = (call cre_fnc_inv_createNamespace) select 0;

	// Determine the unit's assigned items
	private _map = "";
	private _GPS = "";
	private _radio = "";
	private _compass = "";
	private _watch = "";
	{
		private _simulation = [configfile >> "CfgWeapons" >> _x, "simulation", ""] call BIS_fnc_returnConfigEntry;
		switch (_simulation) do {
			case "ItemMap": {_map = _x};
			case "ItemGPS": {_GPS = _x};
			case "ItemRadio": {_radio = _x};
			case "ItemCompass": {_compass = _x};
			case "ItemWatch": {_watch = _x};
		};
	} forEach assignedItems _container;

	// Handle the unit's weapons
	private _slotPosEnums = [
		MACRO_ENUM_SLOTPOS_PRIMARYWEAPON,
		MACRO_ENUM_SLOTPOS_HANDGUNWEAPON,
		MACRO_ENUM_SLOTPOS_SECONDARYWEAPON
	];
	private _weaponDataArray = [];
	{
		// Only continue if we have a weapon
		if (_x != "") then {

			// Generate the accessories data for the weapon
			(call cre_fnc_inv_createNamespace) params ["_itemData"];
			private _weaponAccArray = [_container, _forEachIndex] call cre_fnc_inv_generateWeaponAccArray;
			[_itemData, _weaponAccArray] call cre_fnc_inv_generateWeaponAccData;

			// Save some basic info onto the item data
			_itemData setVariable [MACRO_VARNAME_CLASS, _x];
			_itemData setVariable [MACRO_VARNAME_PARENT, _container];
			_itemData setVariable [MACRO_VARNAME_PARENTDATA, _containerData];

			// Save the slot position
			private _slotPosEnum = _slotPosEnums select _forEachIndex;
			_itemData setVariable [MACRO_VARNAME_SLOTPOS, [_slotPosEnum, MACRO_ENUM_SLOTPOS_INVALID]];
			_containerData setVariable [format [MACRO_VARNAME_SLOT_X_Y, _slotPosEnum, MACRO_ENUM_SLOTPOS_INVALID], _itemData];
		};
	} forEach [
		primaryWeapon _container,
		handgunWeapon _container,
		secondaryWeapon _container
	];

	// Handle the unit's assigned items
	_slotPosEnums = [
		MACRO_ENUM_SLOTPOS_NVGS,
		MACRO_ENUM_SLOTPOS_HEADGEAR,
		MACRO_ENUM_SLOTPOS_BINOCULARS,
		MACRO_ENUM_SLOTPOS_GOGGLES,
		MACRO_ENUM_SLOTPOS_MAP,
		MACRO_ENUM_SLOTPOS_GPS,
		MACRO_ENUM_SLOTPOS_RADIO,
		MACRO_ENUM_SLOTPOS_COMPASS,
		MACRO_ENUM_SLOTPOS_WATCH
	];
	{
		// Only continue if we have an item
		if (_x != "") then {

			// Generate the data for the item
			(call cre_fnc_inv_createNamespace) params ["_itemData"];

			// Save some basic info onto the item data
			_itemData setVariable [MACRO_VARNAME_CLASS, _x];
			_itemData setVariable [MACRO_VARNAME_PARENT, _container];
			_itemData setVariable [MACRO_VARNAME_PARENTDATA, _containerData];

			// Save the slot position
			private _slotPosEnum = _slotPosEnums select _forEachIndex;
			_itemData setVariable [MACRO_VARNAME_SLOTPOS, [_slotPosEnum, MACRO_ENUM_SLOTPOS_INVALID]];
			_containerData setVariable [format [MACRO_VARNAME_SLOT_X_Y, _slotPosEnum, MACRO_ENUM_SLOTPOS_INVALID], _itemData];
		};
	} forEach [
		hmd _container,
		headgear _container,
		binocular _container,
		goggles _container,
		_map,
		_GPS,
		_radio,
		_compass,
		_watch
	];

	// If required, recursively run this function on the unit's uniform, vest and backpack containers
	if (_recursiveOnUnits) then {
		_slotPosEnums = [
			MACRO_ENUM_SLOTPOS_UNIFORM,
			MACRO_ENUM_SLOTPOS_VEST,
			MACRO_ENUM_SLOTPOS_BACKPACK
		];
		private _containerTypes = [
			uniform _container,
			vest _container,
			backpack _container
		];
		{
			private _subContainerData = [_x] call cre_fnc_inv_generateContainerData;

			// Save some basic info onto the sub-container data
			_subContainerData setVariable [MACRO_VARNAME_CLASS, _containerTypes select _forEachIndex];
			_subContainerData setVariable [MACRO_VARNAME_PARENT, _container];
			_subContainerData setVariable [MACRO_VARNAME_PARENTDATA, _containerData];

			// Save the sub-container's position
			private _slotPosEnum = _slotPosEnums select _forEachIndex;
			_subContainerData setVariable [MACRO_VARNAME_SLOTPOS, [_slotPosEnum, MACRO_ENUM_SLOTPOS_INVALID]];
			_containerData setVariable [format [MACRO_VARNAME_SLOT_X_Y, _slotPosEnum, MACRO_ENUM_SLOTPOS_INVALID], _subContainerData];
		} forEach [
			uniformContainer _container,
			vestContainer _container,
			backpackContainer _container
		];
	};





// Otherwise, the container is an object
} else {

	// Define some variables
	private _index = 0;
	private _items = [];
	private _filteredClasses = [	// This is only faster than looking up a class if there are less than ~70-80 entries
		"Cre8ive_DummyWeight_1",
		"Cre8ive_DummyWeight_2",
		"Cre8ive_DummyWeight_3",
		"Cre8ive_DummyWeight_4",
		"Cre8ive_DummyWeight_5",
		"Cre8ive_DummyWeight_6",
		"Cre8ive_DummyWeight_7",
		"Cre8ive_DummyWeight_8",
		"Cre8ive_DummyWeight_9",
		"Cre8ive_DummyWeight_10",
		"Cre8ive_DummyWeight_20",
		"Cre8ive_DummyWeight_30",
		"Cre8ive_DummyWeight_40",
		"Cre8ive_DummyWeight_50",
		"Cre8ive_DummyWeight_60",
		"Cre8ive_DummyWeight_70",
		"Cre8ive_DummyWeight_80",
		"Cre8ive_DummyWeight_90",
		"Cre8ive_DummyWeight_100",
		"Cre8ive_DummyWeight_200",
		"Cre8ive_DummyWeight_300",
		"Cre8ive_DummyWeight_400",
		"Cre8ive_DummyWeight_500",
		"Cre8ive_DummyWeight_600",
		"Cre8ive_DummyWeight_700",
		"Cre8ive_DummyWeight_800",
		"Cre8ive_DummyWeight_900",
		"Cre8ive_DummyWeight_1000",
		"Cre8ive_DummyWeight_2000",
		"Cre8ive_DummyWeight_3000",
		"Cre8ive_DummyWeight_4000",
		"Cre8ive_DummyWeight_5000",
		"Cre8ive_DummyWeight_6000",
		"Cre8ive_DummyWeight_7000",
		"Cre8ive_DummyWeight_8000",
		"Cre8ive_DummyWeight_9000",
		"Cre8ive_DummyWeight_10000"
	];

	// Create some temporary namespaces
	private _slotAreaNamespace = createLocation ["NameVillage", [0,0,0], 0, 0];
	private _itemsListNamespace = createLocation ["NameVillage", [0,0,0], 0, 0];

	// Iterate through the container
	{
		private _formatType = _forEachIndex;

		// Iterate through the sub-arrays
		{
			// Fetch the class
			private _class = _x;
			if (_x isEqualType []) then {
				_class = _x select 0;
			} else {
				_x = [_class];
			};

			// Fetch the item category
			private _category = [_class] call cre_fnc_cfg_getClassCategory;

			// If the item originates from itemCargo...
			private _skip = false;
			if (_formatType == 2) then {

				// ...but it's actually a vest or a uniform, we skip it
				if (_category in [MACRO_ENUM_CATEGORY_UNIFORM, MACRO_ENUM_CATEGORY_VEST, MACRO_ENUM_CATEGORY_CONTAINER]) then {
					_skip = true;
				};
			};

			// If the class is blacklisted, skip it
			if (_class in _filteredClasses) then {
				_skip = true;
			};

			// If the item is valid, we handle it
			if (!_skip) then {
				private _slotSize = [_class, _category] call cre_fnc_cfg_getClassSlotSize;
				private _slotArea = (_slotSize select 0) * (_slotSize select 1);
				private _slotAreaStr = format ["%1.0", _slotArea];

				// Generate a UID for the item
				private _UID = call cre_fnc_inv_generateUID;

				// Get the list of indexes for this specific slot area, and add the current one to it
				private _indexes = _slotAreaNamespace getVariable [_slotAreaStr, []];
				_slotAreaNamespace setVariable [_slotAreaStr, _indexes + [_index]];

				// Save the item using its UID so we can find it later, along with an index to classify its data format
				_itemsListNamespace setVariable [_UID, [_formatType, _x]];

				// Add the item's UID to the list of items (to be sorted later)
				_items pushBack _UID;

				// Increase the index
				_index = _index + 1;
			};
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
	_containerData = (call cre_fnc_inv_createNamespace) select 0;

	// If no container class was provided, fetch it from the object (not reliable on uniforms/vests!)
	if (_containerClass == "") then {
		_containerClass = typeOf _container;
	};

	// Iterate through the sorted list of items and fit them into the container
	([_containerClass] call cre_fnc_cfg_getContainerSize) params ["_containerSize", "_containerSlotsOnLastY"];
	private _containerItems = [];
	_containerData setVariable [MACRO_VARNAME_CONTAINER, _container];
	_containerData setVariable [MACRO_VARNAME_CONTAINERSIZE, _containerSize];
	_containerData setVariable [MACRO_VARNAME_CONTAINERSLOTSONLASTY, _containerSlotsOnLastY];

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
		private _category = [_class] call cre_fnc_cfg_getClassCategory;
		private _itemSize = [_class, _category] call cre_fnc_cfg_getClassSlotSize;
		_itemSize params ["_itemWidth", "_itemHeight"];

		// Iterate twice (once normally, and once with the item rotated)
		for "_rotateMode" from 0 to 1 do {

			private _isRotated = (_rotateMode > 0);
			if (_isRotated) then {
				private _widthTemp = _itemWidth;
				_itemWidth = _itemHeight;
				_itemHeight = _widthTemp;
			};

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
						private _posEndX = _posX + _itemWidth - 1;
						private _posEndY = _posY + _itemHeight - 1;
						if (_posEndX <= _newW and {_posEndY <= _sizeH}) then {

							// Exception handling for the last line in the inventory (which might have less slots)
							if !(_posEndY == _sizeH and {_posEndX > _containerSlotsOnLastY}) then {

								// The dimensions fit, now we check if the required slots are all free
								private _requiredSlots = [];
								private _requiredSlotsStrArray = [];
								for "_posItemY" from _posY to _posEndY do {
									for "_posItemX" from _posX to _posEndX do {
										private _requiredSlotStr = format [MACRO_VARNAME_SLOT_X_Y, _posItemX, _posItemY];
										private _requiredSlot = _containerData getVariable [_requiredSlotStr, locationNull];

										// If the slot is empty, add it to the list
										if (isNull _requiredSlot) then {
											_requiredSlotsStrArray pushBack _requiredSlotStr;
											_requiredSlots pushBack [_posItemX, _posItemY];

										// Otherwise, abort and look for a new slot
										} else {
											breakTo "loopSlots";
										};
									};
								};

								// If we didn't exit yet, that means the item can fit!
								// Now we generate a namespace for this item and save the item class onto it
								// However, if the item is a container, we don't need to generate the item data manually,
								// instead we recursively generate the container data on it and fetch the result
								private _itemData = locationNull;
								if (_formatType == 3) then {
									private _containerX = _args select 1;
									_itemData = [_containerX, _class] call cre_fnc_inv_generateContainerData;
									bag = _containerX;
								} else {
									_itemData = (call cre_fnc_inv_createNamespace) select 0;
								};

								// Save the item class onto the item data
								_itemData setVariable [MACRO_VARNAME_CLASS, _class];

								// Link the slots to the item
								{
									_containerData setVariable [_x, _itemData];
								} forEach _requiredSlotsStrArray;

								// Now we may fill in the item data
								// The provided scripting commands return results in a different format, so we have to choose accordingly
								switch (_formatType) do {

									// magazinesAmmoCargo
									case 0: {
										private _ammo = _args select 1;

										_itemData setVariable [MACRO_VARNAME_MAG_AMMO, _ammo];
									};

									// weaponsItemsCargo
									case 1: {
										[_itemData, _args] call cre_fnc_inv_generateWeaponAccData;
									};

									// itemCargo
									case 2: {

									};
								};

								// Save some more info onto the item data
								_itemData setVariable [MACRO_VARNAME_PARENT, _container];
								_itemData setVariable [MACRO_VARNAME_PARENTDATA, _containerData];
								_itemData setVariable [MACRO_VARNAME_SLOTPOS, [_posX, _posY]];
								_itemData setVariable [MACRO_VARNAME_OCCUPIEDSLOTS, _requiredSlots];
								_itemData setVariable [MACRO_VARNAME_ISROTATED, _isRotated];

								_containerItems pushBack _itemData,

								// Move on to the next item
								breakTo "loopItems";
							};
						};
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
	_containerData setVariable [MACRO_VARNAME_ITEMS, _containerItems];
};





// Save the container data onto the container object
_container setVariable [MACRO_VARNAME_DATA, _containerData];

// Return the data
_containerData;
