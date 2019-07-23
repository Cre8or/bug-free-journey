/* --------------------------------------------------------------------------------------------------------------------
	Author:		 Cre8or
	Description:
		Returns all code expressions attached to a classname and to the provided event.
		Also returns IEHs attached to the class' category
	Arguments:
		0:      <STRING>	Classname of the item/object to check
		1:	<NUMBER>	The category of the item/object
		2:      <STRING>	The event in question (refer to macros.hpp for a list of events)
	Returns:
		0:      <ARRAY>		Array of all code expressions that are attached to this class and event
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\res\common\macros.hpp"

// Fetch our params
params [
	["_class", "", [""]],
	["_category", MACRO_ENUM_CATEGORY_INVALID, [MACRO_ENUM_CATEGORY_INVALID]],
	["_event", "", [""]]
];

// If no class or event was provided, exit and return an empty array
if (_class == "" or {_event == ""}) exitWith {
	systemChat "ERROR: No class/event provided!";
	[]
};





// Get our config path
private _configPathName = "";
switch (_category) do {
	case MACRO_ENUM_CATEGORY_ITEM;
	case MACRO_ENUM_CATEGORY_WEAPON;
	case MACRO_ENUM_CATEGORY_HEADGEAR;
	case MACRO_ENUM_CATEGORY_BINOCULARS;
	case MACRO_ENUM_CATEGORY_UNIFORM;
	case MACRO_ENUM_CATEGORY_CONTAINER;
	case MACRO_ENUM_CATEGORY_VEST;
	case MACRO_ENUM_CATEGORY_NVGS: {
		_configPathName = "CfgWeapons";
	};
	case MACRO_ENUM_CATEGORY_BACKPACK;
	case MACRO_ENUM_CATEGORY_VEHICLE;
	case MACRO_ENUM_CATEGORY_MAN: {
		_configPathName = "CfgVehicles";
	};
	case MACRO_ENUM_CATEGORY_MAGAZINE: {
		_configPathName = "CfgMagazines";
	};
	case MACRO_ENUM_CATEGORY_GOGGLES: {
		_configPathName = "CfgGlasses";
	};
	default {
		private _str = format ["ERROR [cre_fnc_cfg_getClassIEHs]: No rule for category '%1' (%2)!", _category, _class];
		systemChat _str;
		hint _str;
	};
};

// Get our corresponding cached IEH namespace
_namespaceVarName = format ["cre8ive_IEH_cached_%1_%2", _configPathName, _event];
_namespace = missionNamespace getVariable [_namespaceVarName, locationNull];

// Fetch the array of codes and functions from the namespace
private _codes = _namespace getVariable _class;

// If the codes array doesn't exist yet, we determine it
if (isNil "_codes") then {
	_codes = [];

	// Fetch the preInit and isFinal IEH namespaces
	private _namespace_preInit = missionNamespace getVariable [format ["cre8ive_IEH_preInit_%1_%2", _configPathName, _event], locationNull];
	private _namespace_isFinal = missionNamespace getVariable [format ["cre8ive_IEH_isFinal_%1_%2", _configPathName, _event], locationNull];

	// Iterate over the parents of this class
	private _classParent = "";
	private _configPath = inheritsFrom (configFile >> _configPathName >> _class);
	while {isClass _configPath} do {
		_classParent = configName _configPath;
		_codes append (_namespace_preInit getVariable [_classParent, []]);

		// Check whether this class is final
		if (_namespace_isFinal getVariable [_classParent, false]) then {
			_configPath = configNull;
		} else {
			_configPath =  inheritsFrom _configPath;
		};
	};

	// Fetch the category-specific codes and functions
	_namespace_preInit = missionNamespace getVariable ["cre8ive_IEH_preInit_category", locationNull];
	private _eventEntries = _namespace_preInit getVariable [_event, []];
	_codes append (_eventEntries param [_category, []]);

	// If the cached namespace doesn't exist yet, create it
	if (isNull _namespace) then {
		_namespace = createLocation ["NameVillage", [0,0,0], 0, 0];
		missionNamespace setVariable [_namespaceVarName, _namespace, false];
		cre_IEHNamespaces pushBack _namespace;	// DEBUG
	};

	// Save the codes array onto the namespace
	_namespace setVariable [_class, _codes];
};





// Return the codes array
_codes;
