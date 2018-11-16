/* --------------------------------------------------------------------------------------------------------------------
        Author:         Cre8or
        Description:
                Generates the child controls for a given control. Used to populate inventory slots with preview
		icons and miscellaneous information, based on the item category (attachments on weapons, fill-bar
		on consumables, etc.).
        Arguments:
                0:      <CONTROL>	Control that needs its child controls generated
        Returns:
                0:	<ARRAY>		List of generated child controls
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\res\config\dialogs\macros.hpp"

params [
	["_ctrl", controlNull, [controlNull]],
	["_class", "", [""]],
	["_category", MACRO_ENUM_CATEGORY_INVALID, [MACRO_ENUM_CATEGORY_INVALID]],
	["_slotSize", [1,1], [[1,1]]],
	["_defaultIconPath", "", [""]],
	["_useFrameSize", false, [false]]
];

// If no control was provided, exit
if (isNull _ctrl) exitWith {systemChat "ERROR: No control provided!"};

// Fetch the inventory display
private _inventory = uiNamespace getVariable ["cre8ive_dialog_inventory", displayNull];

// If the inventory isn't open, exit
if (isNull _inventory) exitWith {systemChat "ERROR: Inventory isn't open!"};




// If the class or the category wasn't provided, determine them from the control
if (_class == "" or {_category == MACRO_ENUM_CATEGORY_INVALID}) then {

	// If the category was intentionally left empty, don't fetch any data and use the provided default path instead
	// Otherwise, fetch the required information from the class
	if (_category != MACRO_ENUM_CATEGORY_EMPTY) then {
		_class = _ctrl getVariable ["class", ""];
		_category = [_class] call cre_fnc_getClassCategory;
		_slotSize = [_class, _category] call cre_fnc_getClassSlotSize;
		_defaultIconPath = _ctrl getVariable ["defaultIconPath", ""];
	};
};

// Decide which child controls are needed based on the category
private _requiredControls = [];
switch (_category) do {
	case MACRO_ENUM_CATEGORY_EMPTY: {
		_requiredControls = [
			MACRO_ENUM_CTRL_PICTURE_ICON
		];
	};

	case MACRO_ENUM_CATEGORY_WEAPON: {
		_requiredControls = [
			MACRO_ENUM_CTRL_PICTURE_ICON,
			MACRO_ENUM_CTRL_OUTLINE,
			MACRO_ENUM_CTRL_PICTURE_WEAPON_MUZZLE,
			MACRO_ENUM_CTRL_PICTURE_WEAPON_BIPOD,
			MACRO_ENUM_CTRL_PICTURE_WEAPON_RAIL,
			MACRO_ENUM_CTRL_PICTURE_WEAPON_OPTIC,
			MACRO_ENUM_CTRL_PICTURE_WEAPON_MAGAZINE,
			MACRO_ENUM_CTRL_PICTURE_WEAPON_ALTMAGAZINE
		];
	};

	case MACRO_ENUM_CATEGORY_MAGAZINE: {
		_requiredControls = [
			MACRO_ENUM_CTRL_PICTURE_ICON,
			MACRO_ENUM_CTRL_OUTLINE,
			MACRO_ENUM_CTRL_BOX_AMMO_FILLBAR
		];
	};

	default {
		_requiredControls = [
			MACRO_ENUM_CTRL_PICTURE_ICON,
			MACRO_ENUM_CTRL_OUTLINE
		];
	};
};





// Fetch some more information from our parent control and from the UI namespace
private _ctrlParent = ctrlParentControlsGroup _ctrl;
private _posCtrl = ctrlPosition _ctrl;
_posCtrl params ["", "", "_sizeW", "_sizeH"];
private _safeZoneW = uiNamespace getVariable ["Cre8ive_Inventory_SafeZoneW", 0];
private _safeZoneH = uiNamespace getVariable ["Cre8ive_Inventory_SafeZoneH", 0];

// If we're supposed to use the control's dimensions, recalculate the sizes
if (_useFrameSize) then {
	_sizeW = (_slotSize select 0) * MACRO_SCALE_SLOT_SIZE_W * _safeZoneW;
	_sizeH = (_slotSize select 1) * MACRO_SCALE_SLOT_SIZE_H * _safeZoneH;
	_posCtrl set [2, _sizeW];
	_posCtrl set [3, _sizeH];
};

// Iterate through the list of required controls and create them
private _childControls = [];
{
	switch (_x) do {

		// Class icon
		case MACRO_ENUM_CTRL_PICTURE_ICON: {
			private _ctrlNew = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedPicture", -1, _ctrlParent];
			_ctrlNew ctrlSetPosition _posCtrl;
			_ctrlNew ctrlCommit 0;

			private _iconPath = [_class, _category, _defaultIconPath] call cre_fnc_getClassIcon;
			_ctrlNew ctrlSetText _iconPath;

			// Save the new control onto the parent control
			_ctrl setVariable ["ctrlIcon", _ctrlNew];
			_childControls pushBack _ctrlNew;
		};

		// Ammo Fillbar
		case MACRO_ENUM_CTRL_BOX_AMMO_FILLBAR: {

			// Only create a fillbar if the magazine has more than one round
			if (([configfile >> "CfgMagazines" >> _class, "count", 0] call BIS_fnc_returnConfigEntry) > 1) then {

				private _ctrlNew = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedBox", -1, _ctrlParent];
				private _pos = [
					(_posCtrl select 0) + pixelW * 2,
					(_posCtrl select 1) + pixelH * 2,
					pixelW * 3,
					(_posCtrl select 3) - pixelH * 4
				];
				_ctrlNew ctrlSetPosition _pos;
				_ctrlNew ctrlCommit 0;
				_ctrlNew ctrlSetBackgroundColor [0,1,0,1];

	                        // Set the box's pixel precision mode to off, disables rounding
	                        _ctrlNew ctrlSetPixelPrecision 2;

				// Save the new control onto the parent control
				_ctrl setVariable ["ctrlAmmoFillbar", _ctrlNew];
				_childControls pushBack _ctrlNew;
			};
		};

		// Outline
		case MACRO_ENUM_CTRL_OUTLINE: {
			private _ctrlNew = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedOutline", -1, _ctrlParent];
			private _pos = [
				ceil ((_posCtrl select 0) / pixelW) * pixelW,
				ceil ((_posCtrl select 1) / pixelH) * pixelH,
				ceil ((_posCtrl select 2) / pixelW) * pixelW,
				ceil ((_posCtrl select 3) / pixelH) * pixelH
			];
			_ctrlNew ctrlSetPosition _pos;
			_ctrlNew ctrlCommit 0;

                        // Set the box's pixel precision mode to off, disables rounding
                        _ctrlNew ctrlSetPixelPrecision 2;

			// Paint the outline based on the item category
			switch (_category) do {
				case MACRO_ENUM_CATEGORY_WEAPON: {
					_ctrlNew ctrlSetTextColor [0,0,1,0.6];
				};
				case MACRO_ENUM_CATEGORY_MAGAZINE: {
					_ctrlNew ctrlSetTextColor [1,1,1,0.3];
				};
				case MACRO_ENUM_CATEGORY_UNIFORM;
				case MACRO_ENUM_CATEGORY_VEST;
				case MACRO_ENUM_CATEGORY_BACKPACK: {
					_ctrlNew ctrlSetTextColor [0,1,0,0.8];
				};
				default {
					_ctrlNew ctrlSetTextColor [1,0,0,0.8];
				};
			};

			// Save the new control onto the parent control
			_childControls pushBack _ctrlNew;
		};

		// Muzzle
		case MACRO_ENUM_CTRL_PICTURE_WEAPON_MUZZLE: {
/*
			private _ctrlNew = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedPicture", -1, _ctrlParent];
			_ctrlNew ctrlSetPosition _posCtrl;
			_ctrlNew ctrlCommit 0;

			_ctrlNew ctrlSetText MACRO_PICTURE_WEAPON_ACC_MUZZLE;

			// Save the new control onto the parent control
			_ctrl setVariable ["ctrlWeaponMuzzle", _ctrlNew];
			_childControls pushBack _ctrlNew;
*/
		};

	};
} forEach _requiredControls;

// Save the child controls onto the parent control
_ctrl setVariable ["childControls", _childControls];

// Return the child controls
_childControls;
