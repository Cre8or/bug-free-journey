/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		[Inventory EventHandler]
		Called when a container UI should update (both when opening for the first time, and on subsequent
		updates).
		This is the default handler for all container classes (boxes/vehicles) except Men.
	Arguments:
		0:      <LOCATION>	The active container's item data
		1:      <CONTROL>	The controls group in which we should draw
		2:      <OBJECT>	The container object
	Returns:
		(nothing)
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\res\common\macros.hpp"

// Fetch our params
params [
	["_containerData", locationNull, [locationNull]],
	["_containerCtrlGrp", controlNull, [controlNull]],
	["_container", objNull, [objNull]]
];

// If the provided container data or the controls group is null, exit
if (isNull _containerData or {isNull _containerCtrlGrp}) exitWith {};






// Otherwise, carry on
