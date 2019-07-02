/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		[Inventory EventHandler]
		Called when a container UI should update (both when opening for the first time, and on subsequent
		updates).
		This is the default handler for all container classes (boxes/vehicles) except Men.
	Arguments:
		0:      <CONTROL>	The container UI controls group
		1:	<OBJECT>	The container object on which the event is called
	Returns:
		(nothing)
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\res\common\macros.hpp"

// Fetch our params
params [
//	["_inventory", controlNull, [controlNull]],
	["_containerCtrlGrp", controlNull, [controlNull]],
	["_container", objNull, [objNull]]
];





// Fetch the container's item data
private _containerData = _container getVariable [MACRO_VARNAME_DATA, locationNull];

// If either the container or its data data doesn't exist, clean up the UI
if (isNull _container or {isNull _containerData}) then {



// Otherwise, carry on
} else {



};
