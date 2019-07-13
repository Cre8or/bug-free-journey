/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		[Inventory EventHandler]
		Called when a container UI should update (both when opening for the first time, and on subsequent
		updates).
		This is the default handler for all classes inherited from Men. Handles linked items and attached
		containers (uniform/vest/backpack).
	Arguments:
		0:      <CONTROL>	The container UI controls group
		1:	<OBJECT>	The unit on which the event is called
	Returns:
		(nothing)
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\res\common\macros.hpp"

// Fetch our params
params [
//	["_inventory", controlNull, [controlNull]],
	["_containerCtrlGrp", controlNull, [controlNull]],
	["_unit", objNull, [objNull]]
];





// Fetch the unit's item data
private _unitData = _unit getVariable [MACRO_VARNAME_DATA, locationNull];

// If either the container or its data data doesn't exist, clean up the UI
if (isNull _unit or {isNull _unitData}) then {



// Otherwise, carry on
} else {



};
