/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Checks if a unit is within range of, and can open a specified container object.
	Arguments:
		0:	<OBJECT>	The unit that wants to open something
		1:	<OBJECT>	The container object the unit wants to open
	Returns:
		0:	<BOOOLEAN>	Whether or not the unit can open the container
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\..\res\common\macros.hpp"

// Fetch the params
params [
	["_unit", objNull, [objNull]],
	["_container", objNull, [objNull]]
];

// If the unit is dead, or if the container is null, exit and return false
if (!alive _unit or {isNull _container}) exitWith {false};





// Set up some variables
private _canAccess = false;
private _eyePos = eyePos _unit;
private _type = typeOf _container;
private _memPoint = [configFile >> "CfgVehicles" >> _type, "memoryPointSupply", ""] call BIS_fnc_returnConfigEntry;
private _invPos = _container modelToWorldVisualWorld (_container selectionPosition [_memPoint, "Memory"]);
private _invDistSqr = [configFile >> "CfgVehicles" >> _type, MACRO_VARNAME_CFG_INVDISTANCE, (sizeOf _type) min 15] call BIS_fnc_returnConfigEntry;

// If the unit is close enough to the container's supply position, then the container can be accessed
if (_eyePos distanceSqr _invPos <= _invDistSqr) then {
	_canAccess = true;
};

// Return the result
_canAccess;
