/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Draws (generates) the child controls for an empty slot.
		This function expects a default icon path, since there is no item to pull an icon from.
	Arguments:
		0:      <CONTROL>	The frame control to which we should attach the child controls
		1:	<STRING>	The default icon path
		2:      <DISPLAY>	The parent display of the control
	Returns:
		(nothing)
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\res\common\macros.hpp"

// Fetch our params
params [
	["_ctrl", controlNull, [controlNull]],
	["_defaultIconPath", "", [""]],			// TODO: Set the default image path to a "missing texture" icon
	["_display", displayNull, [displayNull]]
];





// If this is the initial draw call, generate the child controls
if (isNull (_ctrl getVariable [MACRO_VARNAME_UI_CTRLICON, controlNull])) then {

	// Create the picture icon
	MACRO_FNC_UI_CREATEPICTUREICON_PRIVATE(_ctrl, _ctrlIcon, _display, -1, ctrlParentControlsGroup _ctrl, ctrlPosition _ctrl, _defaultIconPath);

	// Save the new child controls array
	_ctrl setVariable [MACRO_VARNAME_UI_CHILDCONTROLS, [_ctrlIcon]];
};
