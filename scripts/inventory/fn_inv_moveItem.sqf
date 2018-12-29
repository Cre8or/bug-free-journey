/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Moves an item from one inventory container to another.

		NOTE: Does not modify item/container data, nor does it move items visually (in the inventory UI).
		For that, see the "ui_dragging_stop" and "ui_item_move" events in cre_fnc_ui_inventory.
	Arguments:
		0:	<LOCATION>	Item data of the item to be moved
		1:	<OBJECT>	Origin container from which the item should be taken
		2:	<OBJECT>	Target container in which the item should be moved
	Returns:
		0:	<BOOL>		True if the item was moved successfully, otherwise false
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\res\config\dialogs\macros.hpp"

// Fetch our params
params [
	["_itemData", locationNull, [locationNull]],
	["_originContainer", objNull, [objNull]],
	["_targetContainer", objNull, [objNull]]
];

// If the item or the target containers is null, exit and return false
if (isNull _itemData or {isNull _targetContainer}) exitWith {false};





// Fetch the item's category
private _class = _itemData getVariable [MACRO_VARNAME_CLASS, ""];
private _category = [_class] call cre_fnc_cfg_getClassCategory;

// If the origin container exists
if (!isNull _originContainer) then {

	// If the origin container is a unit, things are easier, but we need to use different scripting commands
	if (_originContainer isKindOf "Man") then {

		// Determine what to do based on the category
		switch (_category) do {

			case MACRO_ENUM_CATEGORY_WEAPON;
			case MACRO_ENUM_CATEGORY_NVGS;
			case MACRO_ENUM_CATEGORY_HEADGEAR;
			case MACRO_ENUM_CATEGORY_BINOCULARS: {
				_originContainer removeWeapon _class;
			};

			case MACRO_ENUM_CATEGORY_UNIFORM: {
				removeUniform _originContainer;
			};

			case MACRO_ENUM_CATEGORY_VEST: {
				removeVest _originContainer;
			};

			case MACRO_ENUM_CATEGORY_BACKPACK: {
				removeBackpack _originContainer;
			};
		};

	// Otherwise, use the regular (more complex) way
	} else {

		// Otherwise, determine what to do based on the class
		switch (_category) do {

			case MACRO_ENUM_CATEGORY_WEAPON;
			case MACRO_ENUM_CATEGORY_HEADGEAR;
			case MACRO_ENUM_CATEGORY_BINOCULARS: {

				// Figure out how many weapons of this type are inside the container
				private _index = 0;
				private _count = 0;
				private _classLower = toLower _class;
				private _weapons = getWeaponCargo _originContainer;
				private _allCounts = _weapons select 1;
				scopeName "switch";
				{
					if (toLower _x == _classLower) then {
						_count = _allCounts select _forEachIndex;
						_index = _forEachIndex;
						breakTo "switch";
					};
				} forEach (_weapons select 0);

				// Remove all weapons from the cargo (if only there was a better command...)
				clearWeaponCargoGlobal _originContainer;

				// Re-add the weapons
				{
					if (_forEachIndex != _index) then {
						_originContainer addWeaponCargoGlobal [_x, _allCounts select _forEachIndex];
					} else {
						if (_count > 1) then {
							_originContainer addWeaponCargoGlobal [_x, _count - 1];
						};
					};
				} forEach (_weapons select 0);;
			};

			case MACRO_ENUM_CATEGORY_ITEM;
			case MACRO_ENUM_CATEGORY_NVGS;
			case MACRO_ENUM_CATEGORY_GOGGLES;
			case MACRO_ENUM_CATEGORY_UNIFORM;
			case MACRO_ENUM_CATEGORY_VEST: {

				// Figure out how many items of this type are inside the container
				private _index = 0;
				private _count = 0;
				private _classLower = toLower _class;
				private _items = getItemCargo  _originContainer;
				private _allCounts = _items select 1;
				scopeName "switch";
				{
					if (toLower _x == _classLower) then {
						_count = _allCounts select _forEachIndex;
						_index = _forEachIndex;
						breakTo "switch";
					};
				} forEach (_items select 0);

				// Remove all items from the cargo (if only there was a better command...)
				clearItemCargoGlobal _originContainer;

				// Re-add the items
				{
					if (_forEachIndex != _index) then {
						_originContainer addItemCargoGlobal [_x, _allCounts select _forEachIndex];
					} else {
						if (_count > 1) then {
							_originContainer addItemCargoGlobal [_x, _count - 1];
						};
					};
				} forEach (_items select 0);
			};

			case MACRO_ENUM_CATEGORY_MAGAZINE: {

				// Figure out how many magazines of this type are inside the container
				private _index = 0;
				private _count = 0;
				private _classLower = toLower _class;
				private _magazines = getMagazineCargo _originContainer;
				private _allCounts = _magazines select 1;
				scopeName "switch";
				{
					if (toLower _x == _classLower) then {
						_count = _allCounts select _forEachIndex;
						_index = _forEachIndex;
						breakTo "switch";
					};
				} forEach (_magazines select 0);

				// Remove all magazines from the cargo (if only there was a better command...)
				clearMagazineCargoGlobal _originContainer;

				// Re-add the magazines
				{
					if (_forEachIndex != _index) then {
						_originContainer addMagazineCargoGlobal [_x, _allCounts select _forEachIndex];
					} else {
						if (_count > 1) then {
							_originContainer addMagazineCargoGlobal [_x, _count - 1];
						};
					};
				} forEach (_magazines select 0);
			};

			case MACRO_ENUM_CATEGORY_BACKPACK: {

				// Figure out how many backpacks of this type are inside the container
				private _index = 0;
				private _count = 0;
				private _classLower = toLower _class;
				private _backpacks = getBackpackCargo _originContainer;
				private _allCounts = _backpacks select 1;
				scopeName "switch";
				{
					if (toLower _x == _classLower) then {
						_count = _allCounts select _forEachIndex;
						_index = _forEachIndex;
						breakTo "switch";
					};
				} forEach (_backpacks select 0);

				// Remove all backpacks from the cargo (if only there was a better command...)
				clearBackpackCargoGlobal _originContainer;

				// Re-add the backpacks
				{
					if (_forEachIndex != _index) then {
						_originContainer addBackpackCargoGlobal [_x, _allCounts select _forEachIndex];
					} else {
						if (_count > 1) then {
							_originContainer addBackpackCargoGlobal [_x, _count - 1];
						};
					};
				} forEach (_backpacks select 0);
			};
		};
	};
};





// If the target container is a unit
if (_targetContainer isKindOf "Man") then {

	// Determine what to do based on the category
	switch (_category) do {

		case MACRO_ENUM_CATEGORY_WEAPON: {
			_targetContainer addWeaponGlobal _class;

			// Re-add the attachments
			{
				private _accX = _itemData getVariable [_x, locationNull];
				if (!isNull _accX) then {
					_targetContainer addWeaponItem [_class, _accX getVariable [MACRO_VARNAME_CLASS, ""]];
				};
			} forEach [
				MACRO_VARNAME_ACC_MUZZLE,
				MACRO_VARNAME_ACC_BIPOD,
				MACRO_VARNAME_ACC_SIDE,
				MACRO_VARNAME_ACC_OPTIC,
				MACRO_VARNAME_MAG,
				MACRO_VARNAME_MAGALT
			];
		};

		case MACRO_ENUM_CATEGORY_NVGS;
		case MACRO_ENUM_CATEGORY_HEADGEAR;
		case MACRO_ENUM_CATEGORY_BINOCULARS: {
			_targetContainer addWeaponGlobal _class;
		};

		case MACRO_ENUM_CATEGORY_UNIFORM: {
			_targetContainer forceAddUniform _class;

			// Save some basic info onto the container
			private _container = uniformContainer _targetContainer;
			_container setVariable [MACRO_VARNAME_DATA, _itemData];
			_itemData setVariable [MACRO_VARNAME_CONTAINER, _container];

			{
				// Update the parent variable
				_x setVariable [MACRO_VARNAME_PARENT, _container];

				// Re-add the items that were inside the container
				[_x, objNull, _container] call cre_fnc_inv_moveItem;
			} forEach (_itemData getVariable [MACRO_VARNAME_ITEMS, []]);
		};

		case MACRO_ENUM_CATEGORY_VEST: {
			_targetContainer addVest _class;

			// Save some basic info onto the container
			private _container = vestContainer _targetContainer;
			_container setVariable [MACRO_VARNAME_DATA, _itemData];
			_itemData setVariable [MACRO_VARNAME_CONTAINER, _container];

			{
				// Update the parent variable
				_x setVariable [MACRO_VARNAME_PARENT, _container];

				// Re-add the items that were inside the container
				[_x, objNull, _container] call cre_fnc_inv_moveItem;
			} forEach (_itemData getVariable [MACRO_VARNAME_ITEMS, []]);
		};

		case MACRO_ENUM_CATEGORY_BACKPACK: {
			_targetContainer addBackpackGlobal _class;

			// Save some basic info onto the container
			private _container = backpackContainer _targetContainer;
			_container setVariable [MACRO_VARNAME_DATA, _itemData];
			_itemData setVariable [MACRO_VARNAME_CONTAINER, _container];

			{
				// Update the parent variable
				_x setVariable [MACRO_VARNAME_PARENT, _container];

				// Re-add the items that were inside the container
				[_x, objNull, _container] call cre_fnc_inv_moveItem;
			} forEach (_itemData getVariable [MACRO_VARNAME_ITEMS, []]);
		};
	};

// Otherwise, it's a container object
} else {

	// Determine what to do based on the category
	switch (_category) do {

		case MACRO_ENUM_CATEGORY_WEAPON;
		case MACRO_ENUM_CATEGORY_HEADGEAR;
		case MACRO_ENUM_CATEGORY_BINOCULARS: {
			_targetContainer addWeaponCargoGlobal [_class, 1];
		};

		case MACRO_ENUM_CATEGORY_MAGAZINE: {
			_targetContainer addMagazineCargoGlobal [_class, 1];
		};

		case MACRO_ENUM_CATEGORY_ITEM;
		case MACRO_ENUM_CATEGORY_NVGS;
		case MACRO_ENUM_CATEGORY_GOGGLES: {
			_targetContainer addItemCargoGlobal [_class, 1];
		};

		case MACRO_ENUM_CATEGORY_UNIFORM;
		case MACRO_ENUM_CATEGORY_VEST: {
			_targetContainer addItemCargoGlobal [_class, 1];

			// TODO: Update the "container" variable to point to the new vest/uniform
		};

		case MACRO_ENUM_CATEGORY_BACKPACK: {
			_targetContainer addBackpackCargoGlobal [_class, 1];

			// TODO: Update the "container" variable to point to the new backpack
		};

		// TODO: Handle the vehicle category (e.g. small boxes, pouches, crates, jars, cases, etc.)
	};
};

// Update the parent variable
_itemData setVariable [MACRO_VARNAME_PARENT, _targetContainer];





// Return true
true;
