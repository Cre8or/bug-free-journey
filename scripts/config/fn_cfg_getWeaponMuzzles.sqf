/* --------------------------------------------------------------------------------------------------------------------
	Author:		 Cre8or
	Description:
		Returns a list of muzzles that a certain weapon class has.
	Arguments:
		0:      <STRING>	Classname of the weapon to check
	Returns:
		0:      <ARRAY>		Array containing the weapon's muzzles
-------------------------------------------------------------------------------------------------------------------- */

// Fetch our params
params [
	["_class", "", [""]]
];

// If no class or no category was provided, exit and return 1 bullet
if (_class == "") exitWith {[]};





// Get our namespace
private _namespace = missionNamespace getVariable ["cre8ive_getWeaponMuzzles_namespace", locationNull];

// Fetch the max ammo count from the namespace
private _muzzles = _namespace getVariable [_class, 0];

// If there is no magazines list for this weapon yet, try to determine it
if (_muzzles isEqualType 0) then {

	// If the namespace doesn't exist yet, create it
	if (isNull _namespace) then {
		_namespace = createLocation ["NameVillage", [0,0,0], 0, 0];
		missionNamespace setVariable ["cre8ive_getWeaponMuzzles_namespace", _namespace, false];
	};

	_muzzles = [configfile >> "CfgWeapons" >> _class, "muzzles", []] call BIS_fnc_returnConfigEntry;

	// make sure the magazines are all in lowercase!
	_muzzles = _muzzles apply {toLower _x};

	// Save the magazines list on the namespace
	_namespace setVariable [_class, _muzzles];
};

// Return the result
_muzzles;
