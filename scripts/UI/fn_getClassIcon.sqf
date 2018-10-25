params [
        ["_class", "", [""]],
	["_default", "", [""]]
];

// If no class was provided, exit
if (_class == "") exitWith {};





// Get our namespace
private _location = missionNamespace getVariable ["cre8ive_getClassIcon_namespace", locationNull];

// If the location namespace doesn't exist yet, create it
if (isNull _location) then {
        _location = createLocation ["NameVillage", [0,0,0], 0, 0];
        missionNamespace setVariable ["cre8ive_getClassIcon_namespace", _location, false];
};

// Fetch the icon path
private _iconPath = _location getVariable [_class, ""];

// If the icon doesn't exist yet, try to determine it
if (_iconPath == "") then {
        {
                _iconPath = [configfile >> _x >> _class, "picture", ""] call BIS_fnc_returnConfigEntry;
                if (_iconPath != "") exitWith {
                        _location setVariable [_class, _iconPath];
                };
        } forEach ["CfgWeapons", "CfgMagazines", "CfgVehicles", "CfgGlasses"];
};

if (_iconPath == "") then {
	if (_default != "") then {
                _iconPath = _default;
	} else {
                private _str = format ["ERROR [cre_fnc_getClassIcon]: Could not find icon for '%1', and no default path was provided!", _class];
	        systemChat _str;
	        hint _str;
	};
};





// Return the icon path
_iconPath
