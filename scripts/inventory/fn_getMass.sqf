/* --------------------------------------------------------------------------------------------------------------------
        Author:         Cre8or
        Description:
                Returns the total mass of all items inside a container. Does not include the container's mass.
        Arguments:
                0:      <OBJECT>        Container object
        Returns:
                0:      <NUMBER>	Mass of all objects inside the container object
-------------------------------------------------------------------------------------------------------------------- */

params [
	["_obj", objNull, [objNull]]
];

if (!alive _obj) exitWith {};





// Set up some variables
private _totalMass = 0;





// Fetch the contents of the box
{
	_x params ["_classes", "_counts"];
	private _contentType = _forEachIndex;

	// Iterate through everything inside the box and sum up the mass
	{
		// Fetch the config path based on the item type
		private _configPath = "";
		switch (_contentType) do {
			case 0: {_configPath = configFile >> "CfgWeapons" >> _x >> "WeaponSlotsInfo" >> "mass"};
			case 1: {_configPath = configFile >> "CfgMagazines" >> _x >> "mass"};
			case 2: {_configPath = configFile >> "CfgWeapons" >> _x >> "ItemInfo" >> "mass"};
			case 3: {_configPath = configFile >> "CfgVehicles" >> _x >> "mass"};
		};

		// Look up the mass of one item and multiply it by the count
		private _mass = getNumber _configPath;
		private _count = _counts param [_forEachIndex, 1];
		_totalMass = _totalMass + _mass * _count;
	} forEach _classes;
} forEach [
	getWeaponCargo _obj,
	getMagazineCargo _obj,
	getItemCargo _obj,
	getBackpackCargo _obj
];

// Return the total mass
_totalMass;
