/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Generates the child controls for a given control. Used to populate inventory slots with preview
		icons and miscellaneous information, based on the item category (attachments on weapons, fill-bar
		on consumables, etc.).
	Arguments:
		0:      <CONTROL>	Control that needs its child controls generated
		1:	<STRING>	Class of the item
		2:	<NUMBER>	Category of the item
		3:	<STRING>	Default icon path for this control (fallback for empty slots)
		4:	<ARRAY>		Custom slot size - only used if non-empty!
					NOTE: Leave eempty to fill out the control fully (default behaviour)
	Returns:
		0:	<ARRAY>		List of generated child controls
-------------------------------------------------------------------------------------------------------------------- */

#include "..\..\res\config\dialogs\macros.hpp"

// Fetch our params
params [
	["_ctrl", controlNull, [controlNull]],
	["_class", "", [""]],
	["_category", MACRO_ENUM_CATEGORY_INVALID, [MACRO_ENUM_CATEGORY_INVALID]],
	["_defaultIconPath", "", [""]],
	["_customSlotSize", [], [[]]]
];

// If no control was provided, exit
if (isNull _ctrl) exitWith {systemChat "(cre_fnc_ui_generateChildControls) ERROR: No control provided!"};

// Fetch the inventory display
private _inventory = uiNamespace getVariable ["cre8ive_dialog_inventory", displayNull];

// If the inventory isn't open, exit
if (isNull _inventory) exitWith {systemChat "ERROR: Inventory isn't open!"};





// If the class or the category wasn't provided, determine them from the control
if (_class == "" or {_category == MACRO_ENUM_CATEGORY_INVALID}) then {

	// If the category was intentionally left empty, don't fetch any data and use the provided default path instead
	// Otherwise, fetch the required information from the class
	if (_category != MACRO_ENUM_CATEGORY_EMPTY) then {
		_class = _ctrl getVariable [MACRO_VARNAME_CLASS, ""];
		_category = [_class] call cre_fnc_cfg_getClassCategory;
		_defaultIconPath = _ctrl getVariable [MACRO_VARNAME_UI_DEFAULTICONPATH, ""];

		if (count _customSlotSize > 0) then {
			if ((_customSlotSize param [0, 0]) < 0) then {
				_customSlotSize = [_class, _category] call cre_fnc_cfg_getClassSlotSize;
			};
		};
	};
};

// Decide which child controls are needed based on the category
private _requiredControls = [];
switch (_category) do {
	case MACRO_ENUM_CATEGORY_INVALID;
	case MACRO_ENUM_CATEGORY_EMPTY: {
		_requiredControls = [
			MACRO_ENUM_CTRL_PICTURE_ICON
		];
	};

	case MACRO_ENUM_CATEGORY_WEAPON: {
		_requiredControls = [
			MACRO_ENUM_CTRL_PICTURE_ICON,
			MACRO_ENUM_CTRL_OUTLINE,
			MACRO_ENUM_CTRL_TEXT_DISPLAYNAME,
			MACRO_ENUM_CTRL_PICTURE_WEAPON_MUZZLE,
			MACRO_ENUM_CTRL_PICTURE_WEAPON_BIPOD,
			MACRO_ENUM_CTRL_PICTURE_WEAPON_SIDE,
			MACRO_ENUM_CTRL_PICTURE_WEAPON_OPTIC,
			MACRO_ENUM_CTRL_PICTURE_WEAPON_MAGAZINE,
			MACRO_ENUM_CTRL_PICTURE_WEAPON_ALTMAGAZINE
		];
	};

	case MACRO_ENUM_CATEGORY_MAGAZINE: {
		_requiredControls = [
			MACRO_ENUM_CTRL_PICTURE_ICON,
			MACRO_ENUM_CTRL_OUTLINE,
			MACRO_ENUM_CTRL_TEXT_DISPLAYNAME,
			MACRO_ENUM_CTRL_BOX_AMMO_FILLBAR
		];
	};

	case MACRO_ENUM_CATEGORY_CONTAINER: {
		_requiredControls = [
			MACRO_ENUM_CTRL_PICTURE_ICON,
			MACRO_ENUM_CTRL_OUTLINE,
			MACRO_ENUM_CTRL_TEXT_DISPLAYNAME
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
private _data = _ctrl getVariable [MACRO_VARNAME_DATA, locationNull];
private _isRotated = _ctrl getVariable [MACRO_VARNAME_ISROTATED, false];

_posCtrl params ["", "", "_sizeW", "_sizeH"];
private _safeZoneW = uiNamespace getVariable ["Cre8ive_Inventory_SafeZoneW", 0];
private _safeZoneH = uiNamespace getVariable ["Cre8ive_Inventory_SafeZoneH", 0];
private _posIconAR = [];

// If we're supposed to use custom dimensions, recalculate the sizes
if (count _customSlotSize > 0) then {
	// If the control is rotated, flip the width and height
	_customSlotSize params ["_slotWidth", "_slotHeight"];
	if (_isRotated) then {
		private _widthTemp = _slotWidth;
		_slotWidth = _slotHeight;
		_slotHeight = _widthTemp;
	};

	_sizeW = _slotWidth * MACRO_SCALE_SLOT_SIZE_W * _safeZoneW;
	_sizeH = _slotHeight * MACRO_SCALE_SLOT_SIZE_H * _safeZoneH;
	_posCtrl set [2, _sizeW];
	_posCtrl set [3, _sizeH];

// Otherwise, if the control is rotated, flip the width and height
} else {
	if (_isRotated) then {
		private _widthTemp = _slotWidth;
		_slotWidth = _slotHeight;
		_slotHeight = _widthTemp;
	};
};


// Iterate through the list of required controls and create them
private _childControls = [];
{
	switch (_x) do {

		// Class icon
		case MACRO_ENUM_CTRL_PICTURE_ICON: {

			// Fetch the icon path
			private _iconPath = [_class, _category, _defaultIconPath] call cre_fnc_cfg_getClassIcon;

			// Only continue if a valid icon path was provided
			if (_iconPath != _defaultIconPath or {_defaultIconPath != ""}) then {
				private _ctrlNew = controlNull;

				// Determine the scale of the icon, with regard to the fixed aspect ratio
				switch (_category) do {

					// Weapon icons are 2x1
					case MACRO_ENUM_CATEGORY_WEAPON: {
						// Create a picture control without the "keep aspect ratio" property (because weapons are 2:1)
						_ctrlNew = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedPictureNoAR", -1, _ctrlParent];
						_posCtrl params ["_posX", "_posY", "_widthOld", "_heightOld"];

						// Safezone aspect ratio: 4:3
						// meaning a rectangle of width 1 and height 1 is (in reality) 4 units wide and 3 units high
						// We want weapon icons to be displayed in true 2:1 ratio (to avoid stretching/incorrect scaling)
						// To do this, we set the height to the width * 2 / 3, resulting in the 2:1 ratio
						// If the item is rotated, we need to achieve a 1:2 ratio, so we set the height to the width * 8 / 3
						private _widthNew = _widthOld;
						private _heightNew = _widthOld * 2 / 3;
						if (_isRotated) then {
							 _heightNew = _widthOld * 8 / 3;
							 _ctrlNew ctrlSetAngle [90, 0.5, 0.5];	// Rotate the control
						};

						// We only modified the height, so now we check whether it increased or decreased
						// If the height has increased (typically from rotations, but not necessarily), we need to scale the control down (and reposition it)
						if (_heightNew > _heightOld) then {
							_widthNew = _widthNew * (_heightOld / _heightNew);
							_posX = _posX + (_widthOld - _widthNew) / 2;
							_heightNew = _heightOld;
						// Otherwise, if the height has decreased (or hasn't changed), we just need to reposition the control
						} else {
							_posY = _posY + (_heightOld - _heightNew) / 2;
						};
						_posIconAR = [_posX, _posY, _widthNew, _heightNew];
						_ctrlNew ctrlSetPosition _posIconAR;
						_ctrlNew ctrlCommit 0;
					};

					// Everything else should be 1x1
					default {
						_ctrlNew = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedPicture", -1, _ctrlParent];
						_posIconAR = +_posCtrl;
						_ctrlNew ctrlSetPosition _posCtrl;
						_ctrlNew ctrlCommit 0;

						// If the control is rotated, rotate the icon
						if (_isRotated) then {
							_ctrlNew ctrlSetAngle [90, 0.5, 0.5];
						};
					};
				};

				// Set the icon path
				_ctrlNew ctrlSetText _iconPath;

				// Save the new control onto the parent control
				_ctrl setVariable [MACRO_VARNAME_UI_CTRLICON, _ctrlNew];
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
			_ctrl setVariable [MACRO_VARNAME_UI_CTRLOUTLINE, _ctrlNew];
		};

		// Display name
		case MACRO_ENUM_CTRL_TEXT_DISPLAYNAME: {

			private _safeZoneH = uiNamespace getVariable ["Cre8ive_Inventory_SafeZoneH", 0];
			private _ctrlNew = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedText", -1, _ctrlParent];
			private _pos = [
				(_posCtrl select 0) - pixelW * 4,
				(_posCtrl select 1) + pixelH * 2,
				(_posCtrl select 2),
				_safeZoneH * 0.01
			];
			_ctrlNew ctrlSetPosition _pos;
			_ctrlNew ctrlCommit 0;

			// Fetch the display name from the proper config path, based on the category
			private _displayName = "";
			switch (_category) do {
				case MACRO_ENUM_CATEGORY_ITEM;
				case MACRO_ENUM_CATEGORY_WEAPON;
				case MACRO_ENUM_CATEGORY_UNIFORM;
				case MACRO_ENUM_CATEGORY_CONTAINER;
				case MACRO_ENUM_CATEGORY_VEST;
				case MACRO_ENUM_CATEGORY_HEADGEAR: {
					_displayName = [configfile >> "CfgWeapons" >> _class, "displayName", ""] call BIS_fnc_returnConfigEntry;
				};
				case MACRO_ENUM_CATEGORY_MAGAZINE: {
					_displayName = [configfile >> "CfgMagazines" >> _class, "displayName", ""] call BIS_fnc_returnConfigEntry;
				};
				case MACRO_ENUM_CATEGORY_BACKPACK: {
					_displayName = [configfile >> "CfgVehicles" >> _class, "displayName", ""] call BIS_fnc_returnConfigEntry;
				};
				case MACRO_ENUM_CATEGORY_GOGGLES: {
					_displayName = [configfile >> "CfgGlasses" >> _class, "displayName", ""] call BIS_fnc_returnConfigEntry;
				};
			};

			_ctrlNew ctrlSetText _displayName;
			_ctrlNew ctrlSetTextColor [1,1,1,1];
			_ctrlNew ctrlSetFontHeight (0.018 * _safeZoneH);

			// Save the new control onto the parent control
			_ctrl setVariable [MACRO_VARNAME_UI_DISPLAYNAME, _ctrlNew];
			_childControls pushBack _ctrlNew;
		};

		// Ammo Fillbar
		case MACRO_ENUM_CTRL_BOX_AMMO_FILLBAR: {

			// Fetch the item's data
			private _maxAmmo = [_class] call cre_fnc_cfg_getMagazineMaxAmmo;

			// Only create a fillbar if the magazine has more than one round
			if (_maxAmmo > 1) then {

				private _ammo = _data getVariable [MACRO_VARNAME_MAG_AMMO, 1];
				private _ratio = _ammo / _maxammo;

				// Create a frame for the ammo bar, and a background
				private _ctrlBack = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedBox", -1, _ctrlParent];
				private _ctrlFront = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedBox", -1, _ctrlParent];

				// Position the foreground control
				private _pos = [
					(_posCtrl select 0) + pixelW * 2,
					(_posCtrl select 1) + _sizeH - pixelH * 4,
					(_sizeW - pixelW * 4) * _ratio,
					pixelH * 3
				];
				_ctrlFront ctrlSetPosition _pos;
				_ctrlFront ctrlCommit 0;
				_ctrlFront ctrlSetBackgroundColor [(1 - _ratio) * 2 min 1,_ratio * 2 min 1,0,1];

				// Position the background control
				_pos set [2, _sizeW - pixelW * 4];
				_ctrlBack ctrlSetPosition _pos;
				_ctrlBack ctrlCommit 0;
				_ctrlBack ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_SEPARATOR);

				{
					// Set the box's pixel precision mode to off, disables rounding
					_x ctrlSetPixelPrecision 2;

					_childControls pushBack _x;
				} forEach [
					_ctrlFront,
					_ctrlBack
				];
				// Save the new controls onto the parent control
				_ctrl setVariable ["ctrlAmmoFillbar", _ctrlFront];
				_ctrl setVariable ["ctrlAmmoFillbarBack", _ctrlBack];
			};
		};

		// Muzzle
		case MACRO_ENUM_CTRL_PICTURE_WEAPON_MUZZLE: {

			// Only continue if the weapon has this attachment
			if (!isNull (_data getVariable [MACRO_VARNAME_ACC_MUZZLE, locationNull])) then {
				private _ctrlNew = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedPicture", -1, _ctrlParent];
				private _accSizeMul = 2 * ([configFile >> "CfgWeapons" >> _class >> "WeaponSlotsInfo" >> "MuzzleSlot", "iconScale", 0.2] call BIS_fnc_returnConfigEntry);
				private _pos = [configFile >> "CfgWeapons" >> _class >> "WeaponSlotsInfo" >> "MuzzleSlot", "iconPosition", [0, 0]] call BIS_fnc_returnConfigEntry;
				_pos params ["_posX", "_posY"];
				_posIconAR params ["_posIconX", "_posIconY", "_widthIcon", "_heightIcon"];

				private _width = _accSizeMul * _widthIcon;
				private _height = _accSizeMul * _heightIcon;

				// If the item is rotated, rotate the control and invert the width/height
				if (_isRotated) then {
					_pos = [
						_posIconX + (1 - _posY) * _widthIcon - _width * 0.5,
						_posIconY + _posX * _heightIcon - _height * 0.5,
						_width,
						_height
					];
					_ctrlNew ctrlSetAngle [90, 0.5, 0.5];

				// Otherwise, position the control normally
				} else {
					_pos = [
						_posIconX + _posX * _widthIcon - _width * 0.5,
						_posIconY + _posY * _heightIcon - _height * 0.5,
						_width,
						_height
					];
				};

				_ctrlNew ctrlSetPosition _pos;
				_ctrlNew ctrlCommit 0;

				_ctrlNew ctrlSetText MACRO_PICTURE_WEAPON_ACC_MUZZLE;

				// Save the new control onto the parent control
				_ctrl setVariable [MACRO_VARNAME_UI_ACC_MUZZLE, _ctrlNew];
				_childControls pushBack _ctrlNew;
			};
		};

		// Bipod
		case MACRO_ENUM_CTRL_PICTURE_WEAPON_BIPOD: {

			// Only continue if the weapon has this attachment
			if (!isNull (_data getVariable [MACRO_VARNAME_ACC_BIPOD, locationNull])) then {
				private _ctrlNew = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedPicture", -1, _ctrlParent];
				private _accSizeMul = 1.5 * ([configFile >> "CfgWeapons" >> _class >> "WeaponSlotsInfo" >> "UnderBarrelSlot", "iconScale", 0.2] call BIS_fnc_returnConfigEntry);
				private _pos = [configFile >> "CfgWeapons" >> _class >> "WeaponSlotsInfo" >> "UnderBarrelSlot", "iconPosition", [0, 0]] call BIS_fnc_returnConfigEntry;
				_pos params ["_posX", "_posY"];
				_posIconAR params ["_posIconX", "_posIconY", "_widthIcon", "_heightIcon"];

				private _width = _accSizeMul * _widthIcon;
				private _height = _accSizeMul * _heightIcon;

				// If the item is rotated, rotate the control and invert the width/height
				if (_isRotated) then {
					_pos = [
						_posIconX + (1 - _posY) * _widthIcon - _width * 0.25,
						_posIconY + _posX * _heightIcon - _height * 0.5,
						_width,
						_height
					];
					_ctrlNew ctrlSetAngle [90, 0.5, 0.5];

				// Otherwise, position the control normally
				} else {
					_pos = [
						_posIconX + _posX * _widthIcon - _width * 0.5,
						_posIconY + _posY * _heightIcon - _height * 0.75,
						_width,
						_height
					];
				};

				_ctrlNew ctrlSetPosition _pos;
				_ctrlNew ctrlCommit 0;

				_ctrlNew ctrlSetText MACRO_PICTURE_WEAPON_ACC_BIPOD;

				// Save the new control onto the parent control
				_ctrl setVariable [MACRO_VARNAME_UI_ACC_BIPOD, _ctrlNew];
				_childControls pushBack _ctrlNew;
			};
		};

		// Side
		case MACRO_ENUM_CTRL_PICTURE_WEAPON_SIDE: {

			// Only continue if the weapon has this attachment
			if (!isNull (_data getVariable [MACRO_VARNAME_ACC_SIDE, locationNull])) then {
				private _ctrlNew = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedPicture", -1, _ctrlParent];
				private _accSizeMul = [configFile >> "CfgWeapons" >> _class >> "WeaponSlotsInfo" >> "PointerSlot", "iconScale", 0.2] call BIS_fnc_returnConfigEntry;
				private _pos = [configFile >> "CfgWeapons" >> _class >> "WeaponSlotsInfo" >> "PointerSlot", "iconPosition", [0, 0]] call BIS_fnc_returnConfigEntry;
				_pos params ["_posX", "_posY"];
				_posIconAR params ["_posIconX", "_posIconY", "_widthIcon", "_heightIcon"];

				private _width = _accSizeMul * _widthIcon;
				private _height = _accSizeMul * _heightIcon;

				// If the item is rotated, rotate the control and invert the width/height
				if (_isRotated) then {
					_pos = [
						_posIconX + (1 - _posY) * _widthIcon - _width * 0.5,
						_posIconY + _posX * _heightIcon - _height * 0.5,
						_width,
						_height
					];
					_ctrlNew ctrlSetAngle [90, 0.5, 0.5];

				// Otherwise, position the control normally
				} else {
					_pos = [
						_posIconX + _posX * _widthIcon - _width * 0.5,
						_posIconY + _posY * _heightIcon - _height * 0.5,
						_width,
						_height
					];
				};

				_ctrlNew ctrlSetPosition _pos;
				_ctrlNew ctrlCommit 0;

				_ctrlNew ctrlSetText MACRO_PICTURE_WEAPON_ACC_SIDE;

				// Save the new control onto the parent control
				_ctrl setVariable [MACRO_VARNAME_UI_ACC_SIDE, _ctrlNew];
				_childControls pushBack _ctrlNew;
			};
		};


		// Optic
		case MACRO_ENUM_CTRL_PICTURE_WEAPON_OPTIC: {

			// Only continue if the weapon has this attachment
			if (!isNull (_data getVariable [MACRO_VARNAME_ACC_OPTIC, locationNull])) then {
				private _ctrlNew = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedPicture", -1, _ctrlParent];
				private _accSizeMul = 4 * ([configFile >> "CfgWeapons" >> _class >> "WeaponSlotsInfo" >> "CowsSlot", "iconScale", 0.2] call BIS_fnc_returnConfigEntry);
				private _pos = [configFile >> "CfgWeapons" >> _class >> "WeaponSlotsInfo" >> "CowsSlot", "iconPosition", [0, 0]] call BIS_fnc_returnConfigEntry;
				_pos params ["_posX", "_posY"];
				_posIconAR params ["_posIconX", "_posIconY", "_widthIcon", "_heightIcon"];

				private _width = _accSizeMul * _widthIcon;
				private _height = _accSizeMul * _heightIcon;

				// If the item is rotated, rotate the control and invert the width/height
				if (_isRotated) then {
					_pos = [
						_posIconX + (1 - _posY) * _widthIcon - _width * (0.5 - 1 / 8),
						_posIconY + _posX * _heightIcon - _height * 0.5,
						_width,
						_height
					];
					_ctrlNew ctrlSetAngle [90, 0.5, 0.5];

				// Otherwise, position the control normally
				} else {
					_pos = [
						_posIconX + _posX * _widthIcon - _width * 0.5,
						_posIconY + _posY * _heightIcon - _height * (0.5 + 1 / 8),
						_width,
						_height
					];
				};

				_ctrlNew ctrlSetPosition _pos;
				_ctrlNew ctrlCommit 0;

				_ctrlNew ctrlSetText MACRO_PICTURE_WEAPON_ACC_OPTIC;

				// Save the new control onto the parent control
				_ctrl setVariable [MACRO_VARNAME_UI_ACC_OPTIC, _ctrlNew];
				_childControls pushBack _ctrlNew;
			};
		};

	};
} forEach _requiredControls;

// Save the child controls onto the parent control
_ctrl setVariable [MACRO_VARNAME_UI_CHILDCONTROLS, _childControls];

// Return the child controls
_childControls;
