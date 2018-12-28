/* --------------------------------------------------------------------------------------------------------------------
	Author:		 Cre8or
	Description:
		Returns the magazines that a certain weapon class can use.
	Arguments:
		0:      <STRING>	Classname of the weapon to check
	Returns:
		0:      <ARRAY>		Array containing the classnames of all magazines that can be used
-------------------------------------------------------------------------------------------------------------------- */

params [
	["_class", "", [""]]
];

// If no class or no category was provided, exit and return 1 bullet
if (_class == "") exitWith {1};





// Get our namespace
private _namespace = missionNamespace getVariable ["cre8ive_getWeaponMagazines_namespace", locationNull];

// Fetch the max ammo count from the namespace
private _magazines = _namespace getVariable [_class, 0];

// If there is no magazines list for this weapon yet, try to determine it
if (_magazines isEqualType 0) then {

	// If the namespace doesn't exist yet, create it
	if (isNull _namespace) then {
		_namespace = createLocation ["NameVillage", [0,0,0], 0, 0];
		missionNamespace setVariable ["cre8ive_getWeaponMagazines_namespace", _namespace, false];
	};

	_magazines = [configfile >> "CfgWeapons" >> _class, "magazines", []] call BIS_fnc_returnConfigEntry;

	// make sure the magazines are all in lowercase!
	_magazines = _magazines apply {toLower _x};

	// Save the magazines list on the namespace
	_namespace setVariable [_class, _magazines];
};

// Return the result
_magazines;
