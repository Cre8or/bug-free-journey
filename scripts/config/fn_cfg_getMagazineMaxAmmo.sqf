/* --------------------------------------------------------------------------------------------------------------------
	Author:		 Cre8or
	Description:
		Returns the maximum ammo count that a specific magazine class can hold.
	Arguments:
		0:      <STRING>	Classname of the magazine to check
	Returns:
		0:      <NUMBER>	Amount of bullets that fit into the magazine
-------------------------------------------------------------------------------------------------------------------- */

// Fetch our params
params [
	["_class", "", [""]]
];

// If no class or no category was provided, exit and return 1 bullet (to avoid division by zero errors)
if (_class == "") exitWith {1};





// Get our namespace
private _namespace = missionNamespace getVariable ["cre8ive_getMagazineMaxAmmo_namespace", locationNull];

// Fetch the max ammo count from the namespace
private _maxAmmo = _namespace getVariable _class;

// If the max ammo count doesn't exist yet, try to determine it
if (isNil "_maxAmmo") then {

	// If the namespace doesn't exist yet, create it
	if (isNull _namespace) then {
		_namespace = createLocation ["NameVillage", [0,0,0], 0, 0];
		missionNamespace setVariable ["cre8ive_getMagazineMaxAmmo_namespace", _namespace, false];
	};

	_maxAmmo = ([configfile >> "CfgMagazines" >> _class, "count", 1] call BIS_fnc_returnConfigEntry) max 1;

	// Save the max ammo count on the namespace
	_namespace setVariable [_class, _maxAmmo];
};

// Return the result
_maxAmmo;
