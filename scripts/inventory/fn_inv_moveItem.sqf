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





// Set up some variables
private _doNothing = false;

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

			case MACRO_ENUM_CATEGORY_GOGGLES: {
				removeGoggles _originContainer;
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

		// If the two containers are the same, do nothing
		if (_originContainer == _targetContainer) then {
			_doNothing = true;

		// Otherwise...
		} else {

			// Determine what to do based on the class
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

				case MACRO_ENUM_CATEGORY_ITEM;
				case MACRO_ENUM_CATEGORY_NVGS;
				case MACRO_ENUM_CATEGORY_GOGGLES;
				case MACRO_ENUM_CATEGORY_UNIFORM;
				case MACRO_ENUM_CATEGORY_VEST: {

					private _items = [];
					private _itemCargo = getItemCargo _originContainer;
					private _forbiddenCategories = [
						MACRO_ENUM_CATEGORY_UNIFORM,
						MACRO_ENUM_CATEGORY_VEST
					];

					// Fetch the items that are not containers
					{
						private _category = [_x] call cre_fnc_cfg_getClassCategory;

						if !(_category in _forbiddenCategories) then {
							if (_x == _itemData getVariable [MACRO_VARNAME_CLASS, ""]) then {	// Substract 1 from the count of this class
								_items pushBack [_x, ((_itemCargo select 1) select _forEachIndex) - 1];
							} else {
								_items pushBack [_x, (_itemCargo select 1) select _forEachIndex];
							};
						};
					} forEach (_itemCargo select 0);

					// Remove all items from the cargo (if only there was a better command...)
					clearItemCargoGlobal _originContainer;

					// Re-add the deleted items that are not containers
					{
						_originContainer addItemCargoGlobal _x;
					} forEach _items;

					// Re-add the item containers
					private _originContainerData = _originContainer getVariable [MACRO_VARNAME_DATA, locationNull];
					private _containers = [_originContainerData, [MACRO_ENUM_CATEGORY_UNIFORM, MACRO_ENUM_CATEGORY_VEST]] call cre_fnc_inv_getEveryContainer;
					{
						private _class = _x getVariable [MACRO_VARNAME_CLASS, ""];
						_originContainer addItemCargoGlobal [_class, 1];
					} forEach _containers;

					// Reassign the containers' item data to the new containers
					private _everyContainer = everyContainer _originContainer;
					{
						_containerX = (_everyContainer select _forEachIndex) select 1;

						_x setVariable [MACRO_VARNAME_CONTAINER, _containerX];
						_containerX setVariable [MACRO_VARNAME_DATA, _x];
					} forEach _containers;
				};

				case MACRO_ENUM_CATEGORY_BACKPACK: {

					// Remove all backpacks from the cargo
					clearBackpackCargoGlobal _originContainer;

					// Fetch a list of all the backpacks that should be there
					private _originContainerData = _originContainer getVariable [MACRO_VARNAME_DATA, locationNull];
					private _backpacks = [_originContainerData, [MACRO_ENUM_CATEGORY_BACKPACK]] call cre_fnc_inv_getEveryContainer;

					// Re-add the backpacks
					{
						private _class = _x getVariable [MACRO_VARNAME_CLASS, ""];
						_originContainer addBackpackCargoGlobal [_class, 1];
					} forEach _backpacks;

					// Reassign the containers' item data to the new containers
					private _allBackpackContainers = everyBackpack _originContainer;
					{
						private _backpackContainer = _allBackpackContainers param [_forEachIndex, objNull];

						_x setVariable [MACRO_VARNAME_CONTAINER, _backpackContainer];
						_backpackContainer setVariable [MACRO_VARNAME_DATA, _x];
					} forEach _backpacks;
				};
			};
		};
	};
};





// Only continue if we should do something
if (!_doNothing) then {

	// If the target container is a unit
	if (_targetContainer isKindOf "Man") then {

		// Determine what to do based on the category
		switch (_category) do {

			case MACRO_ENUM_CATEGORY_GOGGLES: {
				_targetContainer addGoggles _class;
			};

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

				// Fetch the list of containers before adding the new one
				private _listOld = everyContainer _targetContainer;

				// Add the new container
				_targetContainer addItemCargoGlobal [_class, 1];

				// The difference between the new list and the old one must be the new container that was added
				private _container = (((everyContainer _targetContainer) - _listOld) param [0, []]) param [1, objNull];

				// Update the container variable to point to the new container object
				_itemData setVariable [MACRO_VARNAME_CONTAINER, _container];
				_container setVariable [MACRO_VARNAME_DATA, _itemData];
			};

			case MACRO_ENUM_CATEGORY_BACKPACK: {

				// Fetch the list of containers before adding the new one
				private _listOld = everyContainer _targetContainer;

				// Add the new container
				_targetContainer addBackpackCargoGlobal [_class, 1];

				// The difference between the new list and the old one must be the new container that was added
				private _container = (((everyContainer _targetContainer) - _listOld) param [0, []]) param [1, objNull];

				// Update the container variable to point to the new container object
				_itemData setVariable [MACRO_VARNAME_CONTAINER, _container];
				_container setVariable [MACRO_VARNAME_DATA, _itemData];
			};

			// TODO: Handle the vehicle category (e.g. small boxes, pouches, crates, jars, cases, etc.)
		};
	};

	// Update the parent variable
	_itemData setVariable [MACRO_VARNAME_PARENT, _targetContainer];
};




// Return true
true;
