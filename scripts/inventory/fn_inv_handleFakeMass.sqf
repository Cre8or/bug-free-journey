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

#include "..\..\res\common\macros.hpp"

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
};





// Clear the container's magazines and weapons pool
clearMagazineCargoGlobal _container;
clearWeaponCargoGlobal _container;

// Fetch the list of weapons that are supposed to be in the container
private _listWeapons = [_containerData, [MACRO_ENUM_CATEGORY_WEAPON], 1] call cre_fnc_inv_getClassCountsByCategory;

// Re-add the weapons
{
	_container addWeaponCargoGlobal _x;
} forEach _listWeapons;

// Get the container's total fake mass
private _totalMass = [_containerData, true, false] call cre_fnc_inv_getInvMass;

// If the fake mass is equal to 0, exit
if (_totalMass <= 0) exitWith {};





// Otherwise, determine the amount and type of dummy weights that are needed
{
	// Determine how many dummy weights of this type we need
	private _count = floor (_totalMass / _x);

	// Add the dummy weights
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
