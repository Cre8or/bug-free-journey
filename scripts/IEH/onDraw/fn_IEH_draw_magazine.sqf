/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Draws (generates and updates) the child controls for a given item data.
		This function specifically handles items of category "MAGAZINE".
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
private _maxAmmo = [_class] call cre_fnc_cfg_getMagazineMaxAmmo;

// Fetch the child controls
private _ctrlAmmoFront = _ctrl getVariable [MACRO_VARNAME_UI_CTRLAMMOBARFRONT, controlNull];
private _ctrlAmmoBack = _ctrl getVariable [MACRO_VARNAME_UI_CTRLAMMOBARBACK, controlNull];

// If this is the initial draw call, generate the child controls
if (isNull (_ctrl getVariable [MACRO_VARNAME_UI_CTRLICON, controlNull])) then {

	// Fetch some info about the item
	private _category = [_class] call cre_fnc_cfg_getClassCategory;
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

	// Create the outline
	MACRO_FNC_UI_CREATEOUTLINE_PRIVATE(_ctrlOutline, _display, -1, _ctrlParent, _pos, MACRO_COLOUR_OUTLINE_MAGAZINE);

	// If this magazine holds more than one bullet, create some controls for the ammo bar
	if (_maxAmmo > 1) then {
		_ctrlAmmoBack = _display ctrlCreate ["Cre8ive_Inventory_ScriptedBox", -1, _ctrlParent];
		_ctrlAmmoFront = _display ctrlCreate ["Cre8ive_Inventory_ScriptedBox", -1, _ctrlParent];

		// Position the background control (the foreground control gets positioned/coloured on every Draw call, see below)
		private _posAmmoBar = [
			(_pos select 0) + pixelW * 2,
			(_pos select 1) + (_pos select 3) - pixelH * 4,
			(_pos select 2) - pixelW * 4,
			pixelH * 3
		];
		MACRO_FNC_UI_CTRL_SETPOSITION(_ctrlAmmoFront, _posAmmoBar, 0);
		MACRO_FNC_UI_CTRL_SETPOSITION(_ctrlAmmoBack, _posAmmoBar, 0);
		_ctrlAmmoBack ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_AMMOBAR_BACKGROUND);

		// Set the pixel precision mode
		_ctrlAmmoFront ctrlSetPixelPrecision MACRO_GLOBAL_PIXELPRECISIONMODE;
		_ctrlAmmoBack ctrlSetPixelPrecision MACRO_GLOBAL_PIXELPRECISIONMODE;

		// Save the ammo bar controls onto the frame control
		_ctrl setVariable [MACRO_VARNAME_UI_CTRLAMMOBARFRONT, _ctrlAmmoFront];
		_ctrl setVariable [MACRO_VARNAME_UI_CTRLAMMOBARBACK, _ctrlAmmoBack];

		// Save the new child controls array
		_ctrl setVariable [MACRO_VARNAME_UI_CHILDCONTROLS, [_ctrlIcon, _ctrlOutline, _ctrlAmmoFront, _ctrlAmmoBack]];
	} else {
		_ctrl setVariable [MACRO_VARNAME_UI_CHILDCONTROLS, [_ctrlIcon, _ctrlOutline]];
	};
};





// Next, we update the existing child controls
if (_maxAmmo > 1) then {
	private _ratio = (_itemData getVariable [MACRO_VARNAME_MAG_AMMO, 0]) / _maxAmmo;

	_ctrlAmmoFront ctrlSetPositionW (ctrlPosition _ctrlAmmoBack select 2) * _ratio;
	_ctrlAmmoFront ctrlCommit 0;

	_ctrlAmmoFront ctrlSetBackgroundColor [(1 - _ratio) * 2 min 1,_ratio * 2 min 1, 0, 1];
};
