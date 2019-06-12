/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Destroys the slot control and all of its child controls. Used for convenience.
	Arguments:
		0:      <CONTROL>	The control to delete
		1:	<BOOLEAN>	Whether or not to exclude the control itself from deletion
					(if true, only child controls will be deleted, otherwise everything)
	Returns:
		(nothing)
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\res\config\dialogs\macros.hpp"

// Fetch our params
params [
	["_ctrl", controlNull],
	["_shouldDeleteCtrl", true]
];





// Delete the child controls
{
	ctrlDelete _x;
} forEach (_ctrl getVariable [MACRO_VARNAME_UI_CHILDCONTROLS, []]);

// Delete the temporary slot icon

ctrlDelete (_ctrl getVariable [MACRO_VARNAME_UI_ICONTEMP, controlNull]);

// Delete the slot icon
ctrlDelete (_ctrl getVariable [MACRO_VARNAME_UI_CTRLSLOTICON, controlNull]);

// Delete the control itself (if desired)
if (_shouldDeleteCtrl) then {
	ctrlDelete _ctrl;
};
