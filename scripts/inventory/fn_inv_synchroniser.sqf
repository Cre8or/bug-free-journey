/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Scheduled script that synchronises the player's actual inventory with the custom inventory data.
		If a mismatch is detected in a container, this function will modify the actual inventory to match the
		custom inventory, by means of adding or removing items.
		If a mismatch is detected on the player's container data (e.g. weapons/assigned items), this function
		will modify the custom inventory to match the actual inventory, by modifying existing or creating new
		item data.
	Arguments:
		(none)
	Returns:
		(nothing)
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\res\config\dialogs\macros.hpp"





// Synchronise the inventories
addMissionEventHandler ["EachFrame", {
	private _time = time;

	// Check if we should synchronise the inventory this frame
	if (_time > (missionNamespace getVariable ["cre8ive_synchroniser_nextUpdate", 0])) then {
		disableSerialization;

		// Fetch the inventory
		private _inventory = uiNamespace getVariable ["cre8ive_dialog_inventory", displayNull];

		// Fetch the player's container data
		private _playerContainerData = player getVariable [MACRO_VARNAME_DATA, locationNull];

		// Only continue if the player's container data exists
		if (!isNull _playerContainerData) then {

			// Determine the unit's assigned items
			private _map = "";
			private _GPS = "";
			private _radio = "";
			private _compass = "";
			private _watch = "";
			{
				private _subCategory = [_x, MACRO_ENUM_CATEGORY_ITEM] call cre_fnc_cfg_getClassSubCategory;
				switch (_subCategory) do {
					case MACRO_ENUM_SUBCATEGORY_MAP:	{_map = _x};
					case MACRO_ENUM_SUBCATEGORY_GPS:	{_GPS = _x};
					case MACRO_ENUM_SUBCATEGORY_RADIO:	{_radio = _x};
					case MACRO_ENUM_SUBCATEGORY_COMPASS:	{_compass = _x};
					case MACRO_ENUM_SUBCATEGORY_WATCH:	{_watch = _x};
				};
			} forEach assignedItems player;

			// Iterate through the player's weapons and reserved items
			private _updateWeaponsMenu = false;
			private _weaponsItems = weaponsItems player;
			{
				_x params ["_slotPosEnum", "_classNew"];

				// Fetch the item from the player's container data
				private _itemData = _playerContainerData getVariable [format [MACRO_VARNAME_SLOT_X_Y, _slotPosEnum, -1], locationNull];
				private _shouldRecreateData = false;

				// If there is anything in this slot...
				private _classOld = _itemData getVariable [MACRO_VARNAME_CLASS, ""];

				// If the item class no longer matches, something happened to the item
				if (_classOld != _classNew) then {
					_updateWeaponsMenu = true;
					_shouldRecreateData = true;

					systemChat format ["(cre_fnc_inv_synchroniser) ITEM MISMATCH: '%1' / '%2'", _classOld, _classNew];

					// TODO: Figure out how to make this MP compatible
					(_itemData getVariable [MACRO_VARNAME_SLOTPOS, [MACRO_ENUM_SLOTPOS_INVALID, MACRO_ENUM_SLOTPOS_INVALID]]) params ["_slotPosX", "_slotPosY"];
					private _parentData = _itemData getVariable [MACRO_VARNAME_PARENTDATA, locationNull];
					_parentData setVariable [format [MACRO_VARNAME_SLOT_X_Y, _slotPosX, _slotPosY], locationNull];

					if (_slotPosX > 0) then {
						{
							_parentData setVariable [format [MACRO_VARNAME_SLOT_X_Y, _x select 0, _x select 1], locationNull];
						} forEach (_itemData getVariable [MACRO_VARNAME_OCCUPIEDSLOTS, []]);
					};

					// Delete the old item
					deleteLocation _itemData;

				// If the class still matches, take a closer look...
				} else {

					// For weapons, do some extra checks (for attachments/magazines)
					if (_forEachIndex <= 2) then {
						private _updateWeapon = false;
						private _weaponsItemsActual = [player, _forEachIndex, true] call cre_fnc_inv_generateWeaponAccArray;
						_weaponsItemsActual deleteAt 0;	// Ignore the weapon class for now (we'll check it later)

						private _weaponsItemsCalc = [
							(_itemData getVariable [MACRO_VARNAME_ACC_MUZZLE, locationNull]) getVariable [MACRO_VARNAME_CLASS, ""],
							(_itemData getVariable [MACRO_VARNAME_ACC_SIDE, locationNull]) getVariable [MACRO_VARNAME_CLASS, ""],
							(_itemData getVariable [MACRO_VARNAME_ACC_OPTIC, locationNull]) getVariable [MACRO_VARNAME_CLASS, ""],
							[
								(_itemData getVariable [MACRO_VARNAME_MAG, locationNull]) getVariable [MACRO_VARNAME_CLASS, ""],
								(_itemData getVariable [MACRO_VARNAME_MAG, locationNull]) getVariable [MACRO_VARNAME_MAG_AMMO, 0]
							],
							[
								(_itemData getVariable [MACRO_VARNAME_MAGALT, locationNull]) getVariable [MACRO_VARNAME_CLASS, ""],
								(_itemData getVariable [MACRO_VARNAME_MAGALT, locationNull]) getVariable [MACRO_VARNAME_MAG_AMMO, 0]
							],
							(_itemData getVariable [MACRO_VARNAME_ACC_BIPOD, locationNull]) getVariable [MACRO_VARNAME_CLASS, ""]
						];

						// List the varnames used to access the attachments
						private _accVarNames = [
							MACRO_VARNAME_ACC_MUZZLE,
							MACRO_VARNAME_ACC_SIDE,
							MACRO_VARNAME_ACC_OPTIC,
							MACRO_VARNAME_MAG,
							MACRO_VARNAME_MAGALT,
							MACRO_VARNAME_ACC_BIPOD
						];

						// Iterate through the weapon's attachments
						{
							private _xActual = _weaponsItemsActual param [_forEachIndex, [[], ""] select _xIsString];
							private _xActualClass = _xActual;
							private _isMagazine = _forEachIndex in [3,4];
							private _accIsDifferent = false;

							if (_isMagazine) then {
								_accIsDifferent = (_x param [0, ""]) != (_xActual param [0, ""]) or {(_x param [1, 0]) != (_xActual param [1, 0])};
							} else {
								_accIsDifferent = !(_x isEqualTo _xActual);
							};

							// Check if the calculated attachment matches the real (actual) one
							if (_accIsDifferent) then {

								// If the current item is a magazine, fetch its classname
								if (_isMagazine) then {
									_xActualClass = _xActual param [0, ""];
								};

								// Update the weapon (later)
								_updateWeapon = true;

								// Fetch the attachment's item data and delete it
								private _accVarName = _accVarNames select _forEachIndex;
								private _accItemData = _itemData getVariable [_accVarName, locationNull];
								deleteLocation _accItemData;

								// If there is a new attachment, create a new item data for it
								if (_xActualClass != "") then {
									_accItemData = (call cre_fnc_inv_createNamespace) select 0;

									// Save some basic info onto it
									_accItemData setVariable [MACRO_VARNAME_CLASS, _xActualClass];

									// Fetch the ammo
									if (_isMagazine) then {
										private _ammo = _xActual param [1, 0];

										// Save the ammo onto the magazine's item data
										_accItemData setVariable [MACRO_VARNAME_MAG_AMMO, _ammo];
									};
								};

								// Save the slot position
								// TODO: Add new slotPos enums for weapon attachments and apply them here (also in generateContainerData)
								//_accItemData setVariable [MACRO_VARNAME_SLOTPOS, [_slotPosEnum, MACRO_ENUM_SLOTPOS_INVALID]];
								//_itemData setVariable [format [MACRO_VARNAME_SLOT_X_Y, _slotPosEnum, MACRO_ENUM_SLOTPOS_INVALID], _itemData];
								_itemData setVariable [_accVarName, _accItemData];
							};
						} forEach _weaponsItemsCalc;

						// If the items arrays don't match (e.g. if an attachment was added/removed), update the control
						if (_updateWeapon) then {
							systemChat format ["(cre_fnc_inv_synchroniser) WEAPON MISMATCH: %1", _classOld];
							private _weaponsItemDatas = _inventory getVariable [MACRO_VARNAME_UI_WEAPONS_ITEMDATAS, []];
							_weaponsItemDatas set [_forEachIndex, locationNull];
							_inventory getVariable [MACRO_VARNAME_UI_WEAPONS_ITEMDATAS, _weaponsItemDatas];

							_updateWeaponsMenu = true;
						};
					};
				};

				// If the slot is not empty, we need to make a new item data
				if (_shouldRecreateData and {_classNew != ""}) then {

					// Create the new item data
					_itemData = (call cre_fnc_inv_createNamespace) select 0;

					// Save some basic info onto it
					_itemData setVariable [MACRO_VARNAME_CLASS, _classNew];
					_itemData setVariable [MACRO_VARNAME_PARENT, player];
					_itemData setVariable [MACRO_VARNAME_PARENTDATA, _playerContainerData];

					// Save the slot position
					_itemData setVariable [MACRO_VARNAME_SLOTPOS, [_slotPosEnum, MACRO_ENUM_SLOTPOS_INVALID]];
					_playerContainerData setVariable [format [MACRO_VARNAME_SLOT_X_Y, _slotPosEnum, MACRO_ENUM_SLOTPOS_INVALID], _itemData];
				};
			} forEach [
				[MACRO_ENUM_SLOTPOS_PRIMARYWEAPON,	primaryWeapon player],
				[MACRO_ENUM_SLOTPOS_HANDGUNWEAPON,	handgunWeapon player],
				[MACRO_ENUM_SLOTPOS_SECONDARYWEAPON,	secondaryWeapon player],
				[MACRO_ENUM_SLOTPOS_NVGS,		hmd player],
				[MACRO_ENUM_SLOTPOS_HEADGEAR,		headgear player],
				[MACRO_ENUM_SLOTPOS_BINOCULARS,		binocular player],
				[MACRO_ENUM_SLOTPOS_GOGGLES,		goggles player],
				[MACRO_ENUM_SLOTPOS_MAP,		_map],
				[MACRO_ENUM_SLOTPOS_GPS,		_GPS],
				[MACRO_ENUM_SLOTPOS_RADIO,		_radio],
				[MACRO_ENUM_SLOTPOS_COMPASS,		_compass],
				[MACRO_ENUM_SLOTPOS_WATCH,		_watch]
			];

			// If we changed anything, update the weapons menu (if the UI is open)
			if (_updateWeaponsMenu) then {
				if (!isNull _inventory) then {
					["ui_update_weapons"] call cre_fnc_ui_inventory;
				};
			};
		};





		// Fetch the current container
		private _container = objNull;
		private _containerIndex = missionNamespace getVariable ["cre8ive_synchroniser_containerIndex", -1];
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

			// Only continue if the container data exists
			if (!isNull _containerData) then {

				// DEBUG: Save the item data onto the playerContainer directly so it can be restored when entering the arsenal
				_playerContainerData setVariable [format ["playerContainer_%1", _containerIndex], _containerData];

				private _foundError = false;
				private _items = [_containerData, [MACRO_ENUM_CATEGORY_MAGAZINE], true] call cre_fnc_inv_getItemsByCategory;
				private _fakeMass = [_containerData] call cre_fnc_inv_getInvMass;
				private _realMass = [_container] call cre_fnc_inv_getRealMass;

				// If the real mass doesn't match the fake mass, something's wrong...
				if (_fakeMass != _realMass) then {
					_foundError = true;

				// Otherwise, keep looking deeper
				} else {

					// Set up the item lists (both from the data, and from the real contents)
					private _itemsReal = (weaponCargo _container + itemCargo _container + backpackCargo _container);

					// If the class counts match, we're off to a good start
					if (count _items == count _itemsReal) then {

						scopeName "matching";

						// Create a dummy namespace
						private _namespace = createLocation ["NameVillage", [0,0,0], 0, 0];

						// Iterate through the container and map the class counts onto the namespace
						{
							private _count = _namespace getVariable [_x, 0];
							_namespace setVariable [_x, _count + 1];
						} forEach _itemsReal;

						// Iterate through the items list
						{
							_x params ["_classX", "_countX"];

							if (_countX != _namespace getVariable [_classX, -1]) then {
								_foundError = true;
								breakTo "matching";
							};
						} forEach ([_containerData, [MACRO_ENUM_CATEGORY_MAGAZINE], 1, true] call cre_fnc_inv_getClassCountsByCategory);

						// Delete the namespace
						deleteLocation _namespace;

					// Otherwise, we already know that we have a mismatch somewhere
					} else {
						_foundError = true;
					};
				};

				// If we found a mismatch, we need to rebuild the container
				if (_foundError) then {
					systemChat format ["(cre_fnc_inv_synchroniser) CONTAINER MISMATCH: %1", _containerData getVariable [MACRO_VARNAME_CLASS, ""]];

					// Handle the fake mass
					[_container] call cre_fnc_inv_handleFakeMass;

					// CLear the container
					clearItemCargoGlobal _container;
					clearBackpackCargoGlobal _container;

					// Re-add all containers and items to the container
					{
						private _class = _x getVariable [MACRO_VARNAME_CLASS, ""];
						private _category = [_class] call cre_fnc_cfg_getClassCategory;

						switch (_category) do {
							case MACRO_ENUM_CATEGORY_BINOCULARS: {
								_container addWeaponCargoGlobal [_class, 1];
							};
							case MACRO_ENUM_CATEGORY_ITEM;
							case MACRO_ENUM_CATEGORY_NVGS;
							case MACRO_ENUM_CATEGORY_HEADGEAR;
							case MACRO_ENUM_CATEGORY_GOGGLES: {
								_container addItemCargoGlobal [_class, 1];
							};
							case MACRO_ENUM_CATEGORY_CONTAINER;
							case MACRO_ENUM_CATEGORY_UNIFORM;
							case MACRO_ENUM_CATEGORY_VEST: {
								// Fetch the list of containers before adding the new one
								private _listOld = everyContainer _container;

								// Add the new container
								_container addItemCargoGlobal [_class, 1];

								// The difference between the new list and the old one must be the new container that was added
								private _containerX = (((everyContainer _container) - _listOld) param [0, []]) param [1, objNull];

								// Update the container variable to point to the new container object
								_x setVariable [MACRO_VARNAME_CONTAINER, _containerX];
								_containerX setVariable [MACRO_VARNAME_DATA, _x];
							};
							case MACRO_ENUM_CATEGORY_BACKPACK: {
								// Fetch the list of containers before adding the new one
								private _listOld = everyContainer _container;

								// Add the new container
								_container addBackpackCargoGlobal [_class, 1];

								// The difference between the new list and the old one must be the new container that was added
								private _containerX = (((everyContainer _container) - _listOld) param [0, []]) param [1, objNull];

								// Update the container variable to point to the new container object
								_x setVariable [MACRO_VARNAME_CONTAINER, _containerX];
								_containerX setVariable [MACRO_VARNAME_DATA, _x];
							};
							default {}; // For everything else, do nothing
						};
					} forEach _items;
				};
			};
		};

		// Update the storage UI (if the inventory is open)
		if (!isNull _inventory) then {
			["ui_update_storage"] call cre_fnc_ui_inventory;
		};

		// Update our variables
		missionNamespace setVariable ["cre8ive_synchroniser_containerIndex", _containerIndex, false];
		missionNamespace setVariable ["cre8ive_synchroniser_nextUpdate", _time + 0.25, false];
	};
}];
