/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Returns a list with all the item datas of every sub-container inside the provided container.
		Essentially the equivalent of 'everyContainer', but with item data instead of objects.
	Arguments:
		0:	<LOCATION>	Item data of the container to be inspected
		1:	<ARRAY>		Array of allowed categories (items that don't match are ignored)
	Returns:
		0:	<ARRAY>		Array of item datas (<LOCATION>) of every sub-container that was found
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\..\res\common\macros.hpp"

// Fetch the params
params [
	["_containerData", locationNull, [locationNull]],
	["_validCategories", [MACRO_ENUM_CATEGORY_UNIFORM, MACRO_ENUM_CATEGORY_VEST, MACRO_ENUM_CATEGORY_BACKPACK], [[]]]
];

// If the container (or its data) doesn't exist, exit and return an empty array
if (isNull (_containerData getVariable [MACRO_VARNAME_CONTAINER, objNull])) exitWith {
	systemChat format ["ERROR [cre_fnc_inv_getEveryContainer]: Provided container data is empty, or container doesn't exist! (%1 - %2)", _containerData getVariable [MACRO_VARNAME_UID, "n/a"], _containerData getVariable [MACRO_VARNAME_CLASS, "n/a"]];
	[]
};





// Iterate through all items
private _res = [];
{
	// Fetch the item category
	private _class = _x getVariable [MACRO_VARNAME_CLASS, ""];
	private _category = [_class] call cre_fnc_cfg_getClassCategory;

	// If the category is valid, add it to our results
	if (_category in _validCategories) then {
		_res pushBack _x;
	};
} forEach (_containerData getVariable [MACRO_VARNAME_ITEMS, []]);

// Return the results
_res;
