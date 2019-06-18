// If our inventory functions haven't initialised yet, do nothing
if (isNil "cre_fnc_inv_moveItem") exitWith {};

// Run unscheduled, as script errors will freeze the arsenal loading process, requiring a game restart
[] spawn {

	#include "..\res\config\dialogs\macros.hpp"





	// Fetch the player's container data
	private _playerContainerData = player getVariable [MACRO_VARNAME_DATA, locationNull];

	// Fetch the item data of the 3 containers the playerm ight have, and re-add their original items to them
	for "_i" from 0 to 2 do {
		private _containerVarStr = format ["playerContainer_%1", _i];
		private _containerData = _playerContainerData getVariable [_containerVarStr, locationNull];

		// Fetch the current container
		private _container = objNull;
		switch (_i) do {
			case 0: {_container = uniformContainer player};
			case 1: {_container = vestContainer player};
			case 2: {_container = backpackContainer player};
		};

		// If the data is not null...
		if (!isNull _containerData and {!isNull _container}) then {

			// Delete all contents of the backpack
			clearWeaponCargoGlobal _container;
			clearMagazineCargoGlobal _container;
			clearItemCargoGlobal _container;
			clearBackpackCargo _container;

			// Iterate through all items inside the container
			{
				// Move the item to the container
				[_x, objNull, _container, false] call cre_fnc_inv_moveItem;

				// Delete the item's data (it will get recreated once we leave the arsenal and re-open the inventory)
				deleteLocation _x;
			} forEach (_containerData getVariable [MACRO_VARNAME_ITEMS, []]);
		};

		// Delete the container data (so it gets re-created when we leave the arsenal)
		deleteLocation _containerData;
	};
};
