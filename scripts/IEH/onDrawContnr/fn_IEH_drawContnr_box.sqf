/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Draws (generates and updates) the contents of the container UI for a given container object.
		This function handles the default options when opening a generic inventory object (e.g. ammo box).
	Arguments:
		0:	<LOCATION>	The data of the container object
		1:      <CONTROL>	The parent controls group control to which we should attach new controls
		2:      <DISPLAY>	The display in which we're drawing
	Returns:
		(nothing)
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\..\res\common\macros.hpp"

// Fetch our params
params [
	["_itemData", locationNull, [locationNull]],
	["_ctrlParent", controlNull, [controlNull]],
	["_display", displayNull, [displayNull]]
];

// We don't check whether the data/control/display is valid, because we assume the event raiser handled it for us





// Fetch some info about the item
private _class = _itemData getVariable [MACRO_VARNAME_CLASS, "???"];

// If this is the initial draw call, set up some buttons
if !(_ctrlParent getVariable [MACRO_VARNAME_UI_INITIALISED, false]) then {

	_ctrlParent setVariable [MACRO_VARNAME_UI_INITIALISED, true];

	systemChat ("Class: " + _class);
};
