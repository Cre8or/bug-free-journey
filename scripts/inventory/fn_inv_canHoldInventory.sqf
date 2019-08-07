/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Returns true if the object can hold any inventory, otherwise false.
		For most vehicles, aswell as ammo boxes, this typically returns true. Used to filter out things like
		static props, buildings, etc. from generating container data.
	Arguments:
		0:	<OBJECT>	The object to check
	Returns:
		0:	<BOOLEAN>	Whether or not the object can hold any inventory
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\res\common\macros.hpp"

// Fetch the params
params [
	["_object", objNull, [objNull]]
];





// Look up the config class of this object
private _configPath = configFile >> "CfgVehicles" >> typeOf _object;

// Check if the object can hold backpacks, weapons or magazines
if (
	getNumber (_configPath >> "transportMaxBackpacks") > 0
	or {getNumber (_configPath >> "transportMaxMagazines") > 0}
	or {getNumber (_configPath >> "transportMaxWeapons") > 0}
) exitWith {true};

// Otherwise, return false
false;
