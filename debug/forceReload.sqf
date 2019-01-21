private _currentWeapon = currentWeapon player;
private _currentMuzzle = currentMuzzle player;
private _magType = "";
private _magCount = 0;

// Fetch the magazine data from our weapon
{
	private _weaponType = _x param [0, ""];

	if (_weaponType == _currentWeapon) exitWith {
		private _compatibleMags = [configfile >> "CfgWeapons" >> _currentWeapon >> _currentMuzzle, "magazines", []] call BIS_fnc_returnConfigEntry;
		if (_compatibleMags isEqualTo []) then {
			_compatibleMags = [configfile >> "CfgWeapons" >> _currentMuzzle, "magazines", []] call BIS_fnc_returnConfigEntry;
		};

		// Cycle through the primary and secondary magazines
		for "_i" from 4 to 5 do {
			private _magInfo = _x param [_i, []];
			private _magTypeNew = _magInfo param [0, ""];

			if (_magTypeNew in _compatibleMags) exitWith {
				_magType = _magTypeNew;
				_magCount = _magInfo param [1, 0];
			};
		};
	};
} forEach weaponsItems player;

// Remove the loaded magazine
switch (_currentWeapon) do {
	case secondaryWeapon player: {player removeSecondaryWeaponItem _magType};
	case handgunWeapon player: {player removeHandgunItem _magType};
	default {player removePrimaryWeaponItem _magType};
};

// Re-add the weapon magazine to the inventory
if (_magType != "") then {

	// Check if the unit has a cargo container
	private _container = objNull;
	private _shouldRemove = false;
	{
		if (!isNull _x) exitWith {_container = _x};
	} forEach [uniformContainer player, vestContainer player, backpackContainer player];

	// If the player is naked, give them a temporary container
	if (isNull _container) then {
		player addVest "V_Rangemaster_belt";
		_container = vestContainer player;
		_shouldRemove = true;
	};

	// Force the player to reload
	_container addMagazineCargo [_magType, 1];
	reload player;
	clearMagazineCargo _container;

	// Add the correct magazine to the weapon
	player addWeaponItem [_currentWeapon, [_magType, _magCount, _currentMuzzle]];

	// Remove the container, if needed
	if (_shouldRemove) then {
		removeVest player;
	};
};
