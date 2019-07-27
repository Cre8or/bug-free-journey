/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Returns the total mass of all items that SHOULD be inside a container.
		Unlike cre_fnc_inv_getRealMass, this function relies merely on the container's data, and consequently
		completely ignores its actual content.
		NOTE: Does not include the container's own mass.
	Arguments:
		0:      <LOCATION>	Item data of the container object
		1:	<BOOL>		Whether or not exceptional items (magazines and weapon attachments) should
					be considered (default: true)
		2:	<BOOL>		Whether or not non-exceptional items (everything else) should be considered
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
	private _category =_x getVariable [MACRO_VARNAME_CATEGORY, MACRO_ENUM_CATEGORY_INVALID];

	// If we should include exceptional items
	if (_includeExceptions) then {

		switch (_category) do {
			case MACRO_ENUM_CATEGORY_WEAPON: {
				// Add the mass of every weapon accessory
				{
					if (!isNull _x) then {
						private _mass = [
							_x getVariable [MACRO_VARNAME_CLASS, ""],
							_x getVariable [MACRO_VARNAME_CATEGORY, MACRO_ENUM_CATEGORY_INVALID]
						] call cre_fnc_cfg_getClassMass;

						//diag_log format ["    Added attachment: %1 (%2)", _x getVariable [MACRO_VARNAME_CLASS, ""], _mass];

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
				//diag_log format ["    Added magazine: %1 (%2)", _class, _mass];

				_totalMass = _totalMass + _mass;
			};
		};
	};

	// If we should include non-exceptional items
	if (_includeNonExceptions and {_category != MACRO_ENUM_CATEGORY_MAGAZINE}) then {
		private _mass = [_class, _category] call cre_fnc_cfg_getClassMass;
		//diag_log format ["    Added item: %1 (%2)", _class, _mass];

		_totalMass = _totalMass + _mass;
	};

} forEach (_containerData getVariable [MACRO_VARNAME_ITEMS, []]);

//diag_log format ["(%1) Final FAKE mass: %2", diag_frameNo, _totalMass];

// Return the total mass
_totalMass;
