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

	// Fetch the class category
	private _category = [_class] call cre_fnc_cfg_getClassCategory;

	// Check if the class has a container size defined in its config
	private _containerSize = [];
	switch (_category) do {
		case MACRO_ENUM_CATEGORY_CONTAINER;
		case MACRO_ENUM_CATEGORY_UNIFORM;
		case MACRO_ENUM_CATEGORY_VEST: {
			_containerSize = [configfile >> "CfgWeapons" >> _class, "cre8ive_containerSize", []] call BIS_fnc_returnConfigEntry;
		};
		default {
			_containerSize = [configfile >> "CfgVehicles" >> _class, "cre8ive_containerSize", []] call BIS_fnc_returnConfigEntry;
		};
	};

	// If a container size was found, compile the results
	if !(_containerSize isEqualTo []) then {
		_res = [_containerSize, 0];

	// If no container size is defined, calculate it from the max load
	} else {

		// Determine how much load this container can carry
		_maxLoad = getContainerMaxLoad _class;
		if (_maxLoad < 0) then {

			// If the scripting command failed, we need to manually fetch the load from the config
			switch (_category) do {
				case MACRO_ENUM_CATEGORY_CONTAINER;
				case MACRO_ENUM_CATEGORY_UNIFORM;
				case MACRO_ENUM_CATEGORY_VEST: {
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

		// Compile the results
		_res = [
			[_slotsCountPerLine, _sizeH],
			_maxLoad - (_sizeH - 1) * _slotsCountPerLine
		];
	};

	// Save the results onto the namespace
	_namespace setVariable [_class, _res];
};

// Return the results
_res;
