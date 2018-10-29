params [
	["_box", objNull, [objNull]]
];

if (!alive _box) exitWith {};





// Set up some variables
_totalMass = 0;





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
	getWeaponCargo _box,
	getMagazineCargo _box,
	getItemCargo _box,
	getBackpackCargo _box
];

// Return the total mass
_totalMass;
