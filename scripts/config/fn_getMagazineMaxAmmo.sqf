/* --------------------------------------------------------------------------------------------------------------------
        Author:         Cre8or
        Description:
                Returns the maximum ammo count that a specific magazine class can hold.
        Arguments:
                0:      <STRING>	Classname of the magazine to check
        Returns:
                0:      <NUMBER>	Amount of bullets that fit into the magazine
-------------------------------------------------------------------------------------------------------------------- */

params [
        ["_class", "", [""]]
];

// If no class or no category was provided, exit and return 1 bullet
if (_class == "") exitWith {1};





// Get our namespace
private _namespace = missionNamespace getVariable ["cre8ive_getMagazineMaxAmmo_namespace", locationNull];

// If the namespace doesn't exist yet, create it
if (isNull _namespace) then {
        _namespace = createLocation ["NameVillage", [0,0,0], 0, 0];
        missionNamespace setVariable ["cre8ive_getMagazineMaxAmmo_namespace", _namespace, false];
};

// Fetch the max ammo count from the namespace
private _maxAmmo = _namespace getVariable [_class, -1];

// If the max ammo count doesn't exist yet, try to determine it
if (_maxAmmo < 0) then {
	_maxAmmo = [configfile >> "CfgMagazines" >> _class, "count", 1] call BIS_fnc_returnConfigEntry;

        // Save the max ammo count on the namespace
	_namespace setVariable [_class, _maxAmmo];
};

// Return the result
_maxAmmo;
