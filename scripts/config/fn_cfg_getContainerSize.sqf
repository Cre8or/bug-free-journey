/* --------------------------------------------------------------------------------------------------------------------
	Author:		 Cre8or
	Description:
		Determines the UI size of an inventory container. Result is returned in format [[x,y], slotsCount].
	Arguments:
		0:	<STRING>	Classname of the container to check
	Returns:
		0: 	<ARRAY>		UI size in format [x, y], where x and y represent an amount of slots
		1:	<NUMBER>	Amount of slots in the last line (at: y = yMax)
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\res\config\dialogs\macros.hpp"

// Fetch our params
params [
	["_class", "", [""]]
];

// If no class was provided, exit
if (_class == "") exitWith {};





// Get our namespace
private _namespace = missionNamespace getVariable ["cre8ive_getContainerSize_namespace", locationNull];

// Fetch the icon path from the namespace
private _res = _namespace getVariable [_class, []];

// If the icon path doesn't exist yet, fetch it from the config
if (_res isEqualTo []) then {

	// If the namespace doesn't exist yet, create it
	if (isNull _namespace) then {
		_namespace = createLocation ["NameVillage", [0,0,0], 0, 0];
		missionNamespace setVariable ["cre8ive_getContainerSize_namespace", _namespace, false];
	};

	// Determine how much load this container can carry
	_maxLoad = getContainerMaxLoad _class;
	if (_maxLoad < 0) then {

		// If the scripting command failed, we need to manually fetch the load from the config
		private _category = [_class] call cre_fnc_cfg_getClassCategory;

		switch (_category) do {
			case MACRO_ENUM_CATEGORY_WEAPON: {
				private _containerClass = [configfile >> "CfgWeapons" >> _class >> "ItemInfo", "containerClass", ""] call BIS_fnc_returnConfigEntry;
				_maxLoad = [configfile >> "CfgVehicles" >> _containerClass, "maximumLoad", 0] call BIS_fnc_returnConfigEntry;
			};
			default {
				_maxLoad = [configfile >> "CfgVehicles" >> _class, "maximumLoad", 0] call BIS_fnc_returnConfigEntry;
			};
		};
	};
	_maxLoad = floor (MACRO_STORAGE_CAPACITY_MULTIPLIER * _maxLoad);
	private _slotsCountPerLine = ((ceil (_maxLoad / 3)) min MACRO_SCALE_SLOT_COUNT_PER_LINE) max 1;

	private _sizeH = ceil (_maxLoad / _slotsCountPerLine);

	// Save the results
	_res = [
		[_slotsCountPerLine, _sizeH],
		_maxLoad - (_sizeH - 1) * _slotsCountPerLine
	];
	_namespace setVariable [_class, _res];
};

// Return the results
_res;
