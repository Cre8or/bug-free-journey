/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Creates a new namespace. Used for anything that interacts with inventories (e.g. items, nested containers).
	Arguments:
		(none)
	Returns:
		0:      <LOCATION>	New namespace
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\res\config\dialogs\macros.hpp"






// Create the namespace
private _data = createLocation ["NameVillage", [0,0,0], 0, 0];

// Create a UID for this namespace
private _UID = call cre_fnc_inv_generateUID;

// Save the UID onto the namespace
_data setVariable [MACRO_VARNAME_UID, _UID];

// DEBUG
if (isNil "allLocations") then {
	allLocations = [];
};
for "_i" from (count allLocations) - 1 to 0 step -1 do {
	private _location = allLocations param [_i, locationNull];

	if (isNull _location) then {
		allLocations deleteAt _i
	};
};
allLocations pushBack _data;

// Return both the namespace and the UID
[_data, _UID];
