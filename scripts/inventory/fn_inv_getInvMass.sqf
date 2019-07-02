/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Returns the total mass of all items that SHOULD be inside a container.
		Unlike cre_fnc_inv_getRealMass, this function relies merely on the container's data, and consequently
		completely ignores its actual content.
	Arguments:
		0:      <LOCATION>	Item data of the container object
		1:	<BOOL>		Whether or not exceptional items (magazines and weapon attachments) should
					be considered (default: true)
		2:	<BOOL>		Whether or not non-exceptional items (anything else) should be considered
					(default: true)
	Returns:
		0:      <NUMBER>	Total mass of all objects inside the container object
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\res\common\macros.hpp"

// Fetch our params
params [
	["_containerData", locationNull, [locationNull]],
	["_includeExceptions", true, [true]],
	["_includeNonExceptions", true, [true]]
];

// If the passed container data doesn't exist, exit and return 0
if (isNull _containerData) exitWith {0};





// Iterate through the items list
private _totalMass = 0;
{
	private _class = _x getVariable [MACRO_VARNAME_CLASS, ""];
	private _category = [_class] call cre_fnc_cfg_getClassCategory;

	// If we should include exception items
	if (_includeExceptions) then {

		// If the item is a magazine, add
		switch (_category) do {
			case MACRO_ENUM_CATEGORY_WEAPON: {
				// Iterate through the weapon's items
				{
					if (!isNull _x) then {
						private _classX = _x getVariable [MACRO_VARNAME_CLASS, ""];
						private _categoryX = [_classX] call cre_fnc_cfg_getClassCategory;
						private _mass = [_classX, _categoryX] call cre_fnc_cfg_getClassMass;
						_totalMass = _totalMass + _mass;
					};
				} forEach [
					_x getVariable [MACRO_VARNAME_ACC_MUZZLE, locationNull],
					_x getVariable [MACRO_VARNAME_ACC_BIPOD, locationNull],
					_x getVariable [MACRO_VARNAME_ACC_SIDE, locationNull],
					_x getVariable [MACRO_VARNAME_ACC_OPTIC, locationNull],
					_x getVariable [MACRO_VARNAME_MAG, locationNull],
					_x getVariable [MACRO_VARNAME_MAGALT, locationNull]
				];
			};
			case MACRO_ENUM_CATEGORY_MAGAZINE: {
				private _mass = [_class, _category] call cre_fnc_cfg_getClassMass;
				_totalMass = _totalMass + _mass;
			};
		};
	};

	// If we should include non-exception items
	if (_includeNonExceptions) then {
		if !(_category in [MACRO_ENUM_CATEGORY_MAGAZINE]) then {
			private _mass = [_class, _category] call cre_fnc_cfg_getClassMass;
			_totalMass = _totalMass + _mass;
		};
	};

} forEach (_containerData getVariable [MACRO_VARNAME_ITEMS, []]);

// Return the total mass
_totalMass;
