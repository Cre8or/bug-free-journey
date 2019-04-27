/* --------------------------------------------------------------------------------------------------------------------
	Author:	 	Cre8or
	Description:
		Generates the array containing a unit's weapon's accessories and magazines (primary, secondary
		or handgun), for use in fn_generateWeaponAccData.
		The format is the same the one returned by the "weaponsItems" command.
	Arguments:
		0:      <OBJECT>	The unit in question
		1:	<NUMBER>	Which weapon we want to obtain information about. Possible values are:
						0:	primary weapon
						1:	handgun
						2:	secondary weapon (launcher)
		2:	<BOOL>		Whether or not the alt magazine sub-array should be included if it's empty
					(default: false)
	Returns:
		0:	<ARRAY>		The weapon's accessories array.
-------------------------------------------------------------------------------------------------------------------- */

// Fetch our params
params [
	["_unit", objNull, [objNull]],
	["_weaponType", 0, [0]],
	["_includeAltMag", false, [false]]
];






// Set up some variables
private _array = [];
private _getLoadedMagazines = {
	private _magazines = [ [[]], [[],[]] ] select _includeAltMag;
	scopeName "magazines";
	{
		scopeName "loop";
		_x params ["_magazine", "_ammo", "_isLoaded", "", "_loadedMuzzle"];

		// If the magazine is loaded somewhere
		if (_isLoaded) then {

			// If it is loaded in a muzzle that is a sub-class of the weapon, it's an alt magazine
			if (isClass (configFile >> "CfgWeapons" >> _weapon >> _loadedMuzzle)) then {
				_magazines set [1, [_magazine, _ammo]];

				if ((_magazines select 0) isEqualTo []) then {
					breakTo "loop";
				} else {
					breakTo "magazines";
				};
			};

			// Otherwise, it's a primary magazine
			if (toLower _weapon == toLower _loadedMuzzle) then {
				_magazines set [0, [_magazine, _ammo]];

				if (_includeAltMag and {(_magazines select 1) isEqualTo []}) then {
					breakTo "loop";
				} else {
					breakTo "magazines";
				};
			};
		};
	} forEach magazinesAmmoFull _unit;

	// Return the magazines array
	_magazines;
};

// Choose which weapon we want to know about
switch (_weaponType) do {

	// Handgun
	case 1: {
		private _weapon = handgunWeapon _unit;

		_array = handgunItems _unit;
		private _bipod = _array deleteAt 3;
		_array = [_weapon] + _array + (call _getLoadedMagazines) + [_bipod];
	};

	// Secondary weapon
	case 2: {
		private _weapon = secondaryWeapon _unit;

		_array = secondaryWeaponItems _unit;
		private _bipod = _array deleteAt 3;
		_array = [_weapon] + _array + (call _getLoadedMagazines) + [_bipod];
	};

	// Primary weapon
	default {
		private _weapon = primaryWeapon _unit;

		_array = primaryWeaponItems _unit;
		private _bipod = _array deleteAt 3;
		_array = [_weapon] + _array + (call _getLoadedMagazines) + [_bipod];
	};
};

// Return the results
_array;
