/* --------------------------------------------------------------------------------------------------------------------
	Author:		 Cre8or
	Description:
		Compiles all class-specific Inventory Event Handlers (IEHs) that were defined in the game config and
		in the mission config file. The results are saved on location namespaces (one per Cfg* entry) and can
		later be looked up using cre_fnc_cfg_getClassIEHs.
	Arguments:
		(nothing)
	Returns:
		(nothing)
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\res\common\macros.hpp"

// Optional debug macro - uncomment to turn on / comment to turn off
#define MACRO_CFG_COMPILEIEHS_DEBUG

// Debug macros to add words/lines to the debug hint message (without having to check if the debug macro exists everytime)
#ifdef MACRO_CFG_COMPILEIEHS_DEBUG
	#define MACRO_CFG_COMPILEIEH_DEBUG_ADD_LINE(LINE) _str = _str + LINE + "<br />"
	#define MACRO_CFG_COMPILEIEH_DEBUG_ADD_NEWLINE _str = _str + "<br />"
	#define MACRO_CFG_COMPILEIEH_DEBUG_ADD_WORD(WORD) _str = _str + WORD
#else
	#define MACRO_CFG_COMPILEIEH_DEBUG_ADD_LINE(LINE)
	#define MACRO_CFG_COMPILEIEH_DEBUG_ADD_NEWLINE
	#define MACRO_CFG_COMPILEIEH_DEBUG_ADD_WORD(WORD)
#endif





// DEBUG - Clear all existing IEH namespaces
if (isNil "cre_IEHNamespaces") then {
	cre_IEHNamespaces = []
} else {
	{
		deleteLocation _x;
	} forEach cre_IEHNamespaces;
};





// Set up some variables
private _str = "";
private _namespaceVarName_preInit = "";
private _namespaceVarName_isFinal = "";
private _namespace_preInit = locationNull;
private _namespace_isFinal = locationNull;





// Iterate through all entries inside the IEH root class
{
	private _modTagPath = _x;
	#ifdef MACRO_CFG_COMPILEIEHS_DEBUG
		private _arrayConfigName = ["MISSION", "CONFIG"];
		MACRO_CFG_COMPILEIEH_DEBUG_ADD_WORD("<t align='center'><t color='#ffffff'>" + (_arrayConfigName select isClass (configFile >> STR(MACRO_CLASSNAME_IEH) >> configName _modTagPath)) + "<\t>");
		MACRO_CFG_COMPILEIEH_DEBUG_ADD_WORD("<t color='#aaaaaa'> - <\t>");
		MACRO_CFG_COMPILEIEH_DEBUG_ADD_LINE("<t color='#00aaff'>" + configName _modTagPath + "<\t><\t>");
	#endif

	// Iterate through all entries inside the mod tag path (e.g. CfgWeapons, CfgVehicles, CfgMagazines, etc.)
	{
		private _configTypePath = _x;
		private _configTypeName = configName _configTypePath;
		MACRO_CFG_COMPILEIEH_DEBUG_ADD_LINE("<t align='left' color='#e06c75'>" + _configTypeName + "<\t>");

		// Iterate through all entries inside the config type path (e.g. Man, Static, arifle_Mk20_GL_plain_F, 11Rnd_45ACP_Mag, etc.)
		{
			private _classPath = _x;
			private _class = configName _classPath;
			MACRO_CFG_COMPILEIEH_DEBUG_ADD_LINE("<t color='#eda765'>  " + _class + "</t>");

			// Iterate through the entry's events
			{
				private _event = configName _x;

				// Fetch the preInit and isFinal namespaces for this config type and event combination
				_namespaceVarName_preInit = format ["cre8ive_IEH_preInit_%1_%2", _configTypeName, _event];
				_namespaceVarName_isFinal = format ["cre8ive_IEH_isFinal_%1_%2", _configTypeName, _event];
				_namespace_preInit = missionNamespace getVariable [_namespaceVarName_preInit, locationNull];
				_namespace_isFinal = missionNamespace getVariable [_namespaceVarName_isFinal, locationNull];

				// If the preInit namespace doesn't exist yet, create it
				if (isNull _namespace_preInit) then {
					_namespace_preInit = createLocation ["NameVillage", [0,0,0], 0, 0];
					missionNamespace setVariable [_namespaceVarName_preInit, _namespace_preInit, false];
					cre_IEHNamespaces pushBack _namespace_preInit;	// DEBUG
				};

				// If the isFinal namespace doesn't exist yet, create it
				if (isNull _namespace_isFinal) then {
					_namespace_isFinal = createLocation ["NameVillage", [0,0,0], 0, 0];
					missionNamespace setVariable [_namespaceVarName_isFinal, _namespace_isFinal, false];
					cre_IEHNamespaces pushBack _namespace_isFinal;	// DEBUG
				};

				// Fetch the previous entries from the preInit namespace
				private _eventEntries = _namespace_preInit getVariable [_class, []];
				private _function = getText (_x >>		"function"		);
				private _code = getText (_x >>			"code"			);
				private _overwrite = getNumber (_x >>		"overwrite"		);
				private _isFinal = [_x,				"isFinal",		-1] call BIS_fnc_returnConfigEntry;

				// If this event should overwrite all other entries for this class, clear the array
				if (_overwrite > 0) then {
					_eventEntries = [];
				};

				// Check if we have a value for isFinal
				if (_isFinal >= 0) then {
					// If this entry is final, save this class onto the isFinal namespace
					if (_isFinal > 0) then {
						_namespace_isFinal setVariable [_class, true];

					// Otherwise, remove the entry in case it was there (enables mods to overwrite eachother's changes)
					} else {
						_namespace_isFinal setVariable [_class, nil];
					};
				};

				// DEBUG
				MACRO_CFG_COMPILEIEH_DEBUG_ADD_WORD("<t color='#44dddd'>    " + _event + "</t>");
				#ifdef MACRO_CFG_COMPILEIEHS_DEBUG

					if (_overwrite > 0) then {
						MACRO_CFG_COMPILEIEH_DEBUG_ADD_LINE("<t color='#ffff88'> ( ! )</t>");
					} else {
						MACRO_CFG_COMPILEIEH_DEBUG_ADD_NEWLINE;
					};
				#endif

				// If a function was provided, add it to the entries
				if !(_function isEqualTo "") then {
					_eventEntries pushBack call compile _function;		// Fetch the function
					MACRO_CFG_COMPILEIEH_DEBUG_ADD_LINE("<t color='#aaaaaa'>      " + _function + "</t>");
				};

				// If a piece of code was provided, add it to the entries
				if !(_code isEqualTo "") then {
					_eventEntries pushBack compile _code;

					#ifdef MACRO_CFG_COMPILEIEHS_DEBUG
						private _limit = 30;
						if ((count _code) > _limit) then {
							private _codeSub = _code select [0, _limit - 5];
							MACRO_CFG_COMPILEIEH_DEBUG_ADD_WORD("<t color='#aaaaaa'>      {</t>");
							MACRO_CFG_COMPILEIEH_DEBUG_ADD_WORD("<t color='#a3d87d'>" + _codeSub + "</t>");
							MACRO_CFG_COMPILEIEH_DEBUG_ADD_LINE("<t color='#aaaaaa'>...}</t>");
						} else {
							MACRO_CFG_COMPILEIEH_DEBUG_ADD_WORD("<t color='#aaaaaa'>      {</t>");
							MACRO_CFG_COMPILEIEH_DEBUG_ADD_WORD("<t color='#a3d87d'>" + _code + "</t>");
							MACRO_CFG_COMPILEIEH_DEBUG_ADD_LINE("<t color='#aaaaaa'>}</t>");
						};
					#endif
				};

				// Save the entries array back onto the namespace
				_namespace_preInit setVariable [_class, _eventEntries];
			} forEach configProperties [_classPath, "isClass _x", true];

		} forEach configProperties [_configTypePath, "isClass _x", true];

	} forEach configProperties [_modTagPath, "isClass _x", true];

	MACRO_CFG_COMPILEIEH_DEBUG_ADD_NEWLINE;

} forEach (
 	(configProperties [configFile >> STR(MACRO_CLASSNAME_IEH), "isClass _x", true]) +
 	(configProperties [missionConfigFile >> STR(MACRO_CLASSNAME_IEH), "isClass _x", true])
);





// Create the preInit namespace for the category-based events
_namespace_preInit = createLocation ["NameVillage", [0,0,0], 0, 0];
missionNamespace setVariable ["cre8ive_IEH_preInit_category", _namespace_preInit, false];
cre_IEHNamespaces pushBack _namespace_preInit;	// DEBUG

// Iterate through all entries inside the IEH categories class
{
	private _modTagPath = _x;
	#ifdef MACRO_CFG_COMPILEIEHS_DEBUG
		private _arrayConfigName = ["MISSION", "CONFIG"];
		MACRO_CFG_COMPILEIEH_DEBUG_ADD_WORD("<t align='center'><t color='#ffffff'>" + (_arrayConfigName select isClass (configFile >> STR(MACRO_CLASSNAME_IEH) >> configName _modTagPath)) + "<\t>");
		MACRO_CFG_COMPILEIEH_DEBUG_ADD_WORD("<t color='#aaaaaa'> - <\t>");
		MACRO_CFG_COMPILEIEH_DEBUG_ADD_LINE("<t color='#00aaff'>" + configName _modTagPath + "<\t><\t>");
	#endif

	// Iterate through all category entries inside the mod tag path (e.g. Category_Weapon, Category_item, etc.)
	{
		private _categoryPath = _x;
		private _category = MACRO_ENUM_CATEGORY_INVALID;
		switch (configName _categoryPath) do {
			case STR(MACRO_CLASSNAME_IEH_CATEGORY_ITEM):			{_category = MACRO_ENUM_CATEGORY_ITEM};
			case STR(MACRO_CLASSNAME_IEH_CATEGORY_WEAPON):			{_category = MACRO_ENUM_CATEGORY_WEAPON};
			case STR(MACRO_CLASSNAME_IEH_CATEGORY_MAGAZINE):		{_category = MACRO_ENUM_CATEGORY_MAGAZINE};
			case STR(MACRO_CLASSNAME_IEH_CATEGORY_UNIFORM):			{_category = MACRO_ENUM_CATEGORY_UNIFORM};
			case STR(MACRO_CLASSNAME_IEH_CATEGORY_VEST):			{_category = MACRO_ENUM_CATEGORY_VEST};
			case STR(MACRO_CLASSNAME_IEH_CATEGORY_BACKPACK):		{_category = MACRO_ENUM_CATEGORY_BACKPACK};
			case STR(MACRO_CLASSNAME_IEH_CATEGORY_NVGS):			{_category = MACRO_ENUM_CATEGORY_NVGS};
			case STR(MACRO_CLASSNAME_IEH_CATEGORY_HEADGEAR):		{_category = MACRO_ENUM_CATEGORY_HEADGEAR};
			case STR(MACRO_CLASSNAME_IEH_CATEGORY_BINOCULARS):		{_category = MACRO_ENUM_CATEGORY_BINOCULARS};
			case STR(MACRO_CLASSNAME_IEH_CATEGORY_GOGGLES):			{_category = MACRO_ENUM_CATEGORY_GOGGLES};
		};
		MACRO_CFG_COMPILEIEH_DEBUG_ADD_LINE("<t align='left' color='#eda765'>  " + str _category + "</t>");

		// Only continue if the category is valid
		if (_category != MACRO_ENUM_CATEGORY_INVALID) then {

			// Iterate through the category entry's events
			{

				// Fetch the entries for this event
				private _event = configName _x;
				private _eventEntries = _namespace_preInit getVariable [_event, []];
				private _categoryEntries = _eventEntries param [_category, []];

				private _function = getText (_x >>		"function"		);
				private _code = getText (_x >>			"code"			);
				private _overwrite = getNumber (_x >>		"overwrite"		);

				// If this event should overwrite all other entries for this class, clear the array
				if (_overwrite > 0) then {
					_categoryEntries = [];
				};

				// DEBUG
				MACRO_CFG_COMPILEIEH_DEBUG_ADD_WORD("<t align='left' color='#44dddd'>    " + _event + "</t>");
				#ifdef MACRO_CFG_COMPILEIEHS_DEBUG

					if (_overwrite > 0) then {
						MACRO_CFG_COMPILEIEH_DEBUG_ADD_LINE("<t color='#ffff88'> ( ! )</t>");
					} else {
						MACRO_CFG_COMPILEIEH_DEBUG_ADD_NEWLINE;
					};
				#endif

				// If a function was provided, add it to the entries
				if !(_function isEqualTo "") then {
					_categoryEntries pushBack call compile _function;		// Fetch the function
					MACRO_CFG_COMPILEIEH_DEBUG_ADD_LINE("<t align='left' color='#aaaaaa'>      " + _function + "</t>");
				};

				// If a piece of code was provided, add it to the entries
				if !(_code isEqualTo "") then {
					_categoryEntries pushBack compile _code;

					#ifdef MACRO_CFG_COMPILEIEHS_DEBUG
						private _limit = 30;
						if ((count _code) > _limit) then {
							private _codeSub = _code select [0, _limit - 5];
							MACRO_CFG_COMPILEIEH_DEBUG_ADD_WORD("<t align='left' color='#aaaaaa'>      {</t>");
							MACRO_CFG_COMPILEIEH_DEBUG_ADD_WORD("<t color='#a3d87d'>" + _codeSub + "</t>");
							MACRO_CFG_COMPILEIEH_DEBUG_ADD_LINE("<t color='#aaaaaa'>...}</t>");
						} else {
							MACRO_CFG_COMPILEIEH_DEBUG_ADD_WORD("<t align='left' color='#aaaaaa'>      {</t>");
							MACRO_CFG_COMPILEIEH_DEBUG_ADD_WORD("<t color='#a3d87d'>" + _code + "</t>");
							MACRO_CFG_COMPILEIEH_DEBUG_ADD_LINE("<t color='#aaaaaa'>}</t>");
						};
					#endif
				};

				// Save the entries array back onto the namespace
				_eventEntries set [_category, _categoryEntries];
				_namespace_preInit setVariable [_event, _eventEntries];
			} forEach configProperties [_categoryPath, "isClass _x", true];
		};

	} forEach configProperties [_modTagPath, "isClass _x", true];

	MACRO_CFG_COMPILEIEH_DEBUG_ADD_NEWLINE;

} forEach (
 	(configProperties [configFile >> STR(MACRO_CLASSNAME_IEH_CATEGORY), "isClass _x", true]) +
 	(configProperties [missionConfigFile >> STR(MACRO_CLASSNAME_IEH_CATEGORY), "isClass _x", true])
);





// Show the debug hint
#ifdef MACRO_CFG_COMPILEIEHS_DEBUG
	hint parseText _str;
#endif
