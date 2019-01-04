/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Handles the fake mass of a container. Essentially replaces magazines with dummy items while preserving
		the container's total mass.
	Arguments:
		0:	<LOCATION>	Item data of the container to be handled, OR
			<OBJECT>	The container object itself
	Returns:
		(nothing)
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\res\config\dialogs\macros.hpp"

// Fetch the params
params [
	["_containerData", locationNull, [locationNull, objNull]]
];

// Re-arrange our variables, if needed
private _container = _containerData getVariable [MACRO_VARNAME_CONTAINER, objNull];
if (_containerData isEqualType objNull) then {
	_container = _containerData;
	_containerData = _container getVariable [MACRO_VARNAME_DATA, locationNull];
};

// If the container (or its data) doesn't exist, exit and return an empty array
if (isNull _container or {isNull _containerData}) exitWith {
	systemChat format ["ERROR [cre_fnc_inv_handleFakeMass]: Provided container data is empty, or container doesn't exist! (%1 - %2)", _containerData getVariable [MACRO_VARNAME_UID, "n/a"], _containerData getVariable [MACRO_VARNAME_CLASS, "n/a"]];
	[]
};






// Fetch the list of magazines that are supposed to be in this container
private _listMagazines = [_containerData, [MACRO_ENUM_CATEGORY_MAGAZINE]] call cre_fnc_inv_getItemsByCategory;

// Clear the container's magazines pool
clearMagazineCargoGlobal _container;

// If there are no magazines, exit here
if (_listMagazines isEqualTo []) exitWith {};





// Otherwise, calculate the mass of the magazines that are supposed to be in the inventory
private _totalMass = 0;
{
	private _class = _x getVariable [MACRO_VARNAME_CLASS, ""];
	private _mass = [_class, MACRO_ENUM_CATEGORY_MAGAZINE] call cre_fnc_cfg_getClassMass;
	_totalMass = _totalMass + _mass;
} forEach _listMagazines;


{
	// Determine how many magazines of this type we need
	private _count = floor (_totalMass / _x);

	// Add the fake magazines
	if (_count > 0) then {
		if (_forEachIndex == 0) then {
			if (_count > 9) then {
				private _count2 = floor _totalMass / (_x * 10);
				_container addMagazineCargoGlobal [format ["Cre8ive_DummyWeight_%1", _x * 10], _count2];

				// Remove the added amount from the remaining mass
				_totalMass = _totalMass - (_count2 * _x * 10);
			};
			_container addMagazineCargoGlobal [format ["Cre8ive_DummyWeight_%1", _x * _count], 1];
		} else {
			_container addMagazineCargoGlobal [format ["Cre8ive_DummyWeight_%1", _x * _count], 1];
		};
	};

	// Remove the added amount from the remaining mass
	_totalMass = _totalMass - (_count * _x);
} forEach [1000, 100, 10, 1];
