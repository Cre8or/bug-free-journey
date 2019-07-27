/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Draws (generates and updates) the child controls for a given item data.
		This function handles items of category "ITEM", "NVGS", "HEADGEAR", "BINOCULARS" and "GOGGLES"
	Arguments:
		0:	<LOCATION>	The data of the item to draw
		1:      <CONTROL>	The frame control to which we should attach the child controls
		2:      <DISPLAY>	The parent display of the control
	Returns:
		(nothing)
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\..\res\common\macros.hpp"

// Fetch our params
params [
	["_itemData", locationNull, [locationNull]],
	["_ctrl", controlNull, [controlNull]],
	["_display", displayNull, [displayNull]]
];

// We don't check whether the data/control/display is valid, because we assume the event raiser handled it for us





// Fetch some info about the item
private _class = _itemData getVariable [MACRO_VARNAME_CLASS, ""];

// If this is the initial draw call, generate the child controls
if (isNull (_ctrl getVariable [MACRO_VARNAME_UI_CTRLICON, controlNull])) then {

	// Fetch some info about the item
	private _category = _itemData getVariable [MACRO_VARNAME_CATEGORY, MACRO_ENUM_CATEGORY_INVALID];
	private _iconPath = [_class, _category, _ctrl getVariable [MACRO_VARNAME_UI_DEFAULTICONPATH, ""]] call cre_fnc_cfg_getClassIcon;
	private _isRotated = _ctrl getVariable [MACRO_VARNAME_ISROTATED, false];

	// Fetch some info about the control
	private _pos = ctrlPosition _ctrl;
	private _ctrlParent = ctrlParentControlsGroup _ctrl;
	private _ctrlIcon = controlNull;

	// Create the picture icon
	if (_isRotated) then {
		MACRO_FNC_UI_CREATEPICTUREICON_ROTATED(_ctrl, _ctrlIcon, _display, -1, _ctrlParent, _pos, _iconPath);
	} else {
		MACRO_FNC_UI_CREATEPICTUREICON(_ctrl, _ctrlIcon, _display, -1, _ctrlParent, _pos, _iconPath);
	};

	// If the slot is empty, we stop here
	if (isNull _itemData) then {
		_ctrl setVariable [MACRO_VARNAME_UI_CHILDCONTROLS, [_ctrlIcon]];

	// Otherwise, we create the outline
	} else {
		MACRO_FNC_UI_CREATEOUTLINE_PRIVATE(_ctrlOutline, _display, -1, _ctrlParent, _pos, MACRO_COLOUR_OUTLINE_UNIFORM);

		// Save the child controls array
		_ctrl setVariable [MACRO_VARNAME_UI_CHILDCONTROLS, [_ctrlIcon, _ctrlOutline]];
	};
};
