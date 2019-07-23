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
private _itemData_accMuzzle = _itemData getVariable [MACRO_VARNAME_ACC_MUZZLE, locationNull];
private _itemData_accBipod = _itemData getVariable [MACRO_VARNAME_ACC_BIPOD, locationNull];
private _itemData_accSide = _itemData getVariable [MACRO_VARNAME_ACC_SIDE, locationNull];
private _itemData_accOptic = _itemData getVariable [MACRO_VARNAME_ACC_OPTIC, locationNull];

// Fetch the child controls
private _ctrlAccMuzzle = _ctrl getVariable [MACRO_VARNAME_UI_ACC_MUZZLE, controlNull];
private _ctrlAccBipod = _ctrl getVariable [MACRO_VARNAME_UI_ACC_BIPOD, controlNull];
private _ctrlAccSide = _ctrl getVariable [MACRO_VARNAME_UI_ACC_SIDE, controlNull];
private _ctrlAccOptic = _ctrl getVariable [MACRO_VARNAME_UI_ACC_OPTIC, controlNull];

// If this is the initial draw call, generate the child controls
if (isNull (_ctrl getVariable [MACRO_VARNAME_UI_CTRLICON, controlNull])) then {

	// Fetch some info about the item
	private _category = [_class] call cre_fnc_cfg_getClassCategory;
	private _iconPath = [_class, _category, _ctrl getVariable [MACRO_VARNAME_UI_DEFAULTICONPATH, ""]] call cre_fnc_cfg_getClassIcon;
	private _isRotated = _ctrl getVariable [MACRO_VARNAME_ISROTATED, false];

	// Fetch some info about the control
	private _pos = ctrlPosition _ctrl;
	private _ctrlParent = ctrlParentControlsGroup _ctrl;
	private _childControls = [];

	// Create the picture icon
	private _ctrlIcon = _display ctrlCreate ["Cre8ive_Inventory_ScriptedPictureNoAR", -1, _ctrlParent];
	_ctrl setVariable [MACRO_VARNAME_UI_CTRLICON, _ctrlIcon];
	_childControls pushBack _ctrlIcon;

		// Safezone aspect ratio: 4:3
		// meaning a rectangle of width 1 and height 1 is (in reality) 4 units wide and 3 units high
		// We want weapon icons to be displayed in true 2:1 ratio (to avoid stretching/incorrect scaling)
		// To do this, we set the height to the width * 2 / 3, resulting in the 2:1 ratio
		// If the item is rotated, we need to achieve a 1:2 ratio, so we set the height to the width * 8 / 3
		_pos params ["_posX", "_posY", "_widthOld", "_heightOld"];
		private _widthNew = _widthOld;
		private _heightNew = _widthOld * 2 / 3;
		if (_isRotated) then {
			 _heightNew = _widthOld * 8 / 3;
			 _ctrlIcon ctrlSetAngle [90, 0.5, 0.5];	// Rotate the control
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
		_ctrlIcon ctrlSetPosition [_posX, _posY, _widthNew, _heightNew];
		_ctrlIcon ctrlCommit 0;

		// Set the icon path
		_ctrlIcon ctrlSetText _iconPath;

	// Create the outline
	MACRO_FNC_UI_CREATEOUTLINE_PRIVATE(_ctrlOutline, _display, -1, _ctrlParent, _pos, MACRO_COLOUR_OUTLINE_WEAPON);
	_childControls pushBack _ctrlOutline;

	// Create the muzzle attachment icon
	_ctrlAccMuzzle = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedPicture", -1, _ctrlParent];
	_ctrl setVariable [MACRO_VARNAME_UI_ACC_MUZZLE, _ctrlAccMuzzle];
	_childControls pushBack _ctrlAccMuzzle;

		private _accSizeMul = 2 * ([configFile >> "CfgWeapons" >> _class >> "WeaponSlotsInfo" >> "MuzzleSlot", "iconScale", 0.2] call BIS_fnc_returnConfigEntry);
		private _posAcc = [configFile >> "CfgWeapons" >> _class >> "WeaponSlotsInfo" >> "MuzzleSlot", "iconPosition", [0, 0]] call BIS_fnc_returnConfigEntry;
		private _posAccX = _posACc select 0;
		private _posAccY = _posACc select 1;
		private _width = _accSizeMul * _widthNew;
		private _height = _accSizeMul * _heightNew;

		// If the item is rotated, rotate the control and invert the width/height
		if (_isRotated) then {
			_ctrlAccMuzzle ctrlSetPosition [
				_posX + (1 - _posAccY) * _widthNew - _width * 0.5,
				_posY + _posAccX * _heightNew - _height * 0.5,
				_width,
				_height
			];
			_ctrlAccMuzzle ctrlCommit 0;
			_ctrlAccMuzzle ctrlSetAngle [90, 0.5, 0.5];

		// Otherwise, position the control normally
		} else {
			_ctrlAccMuzzle ctrlSetPosition [
				_posX + _posAccX * _widthNew - _width * 0.5,
				_posY + _posAccY * _heightNew - _height * 0.5,
				_width,
				_height
			];
			_ctrlAccMuzzle ctrlCommit 0;
		};

		// Set the icon path
		_ctrlAccMuzzle ctrlSetText MACRO_PICTURE_WEAPON_ACC_MUZZLE;

	// Create the bipod attachment icon
	_ctrlAccBipod = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedPicture", -1, _ctrlParent];
	_ctrl setVariable [MACRO_VARNAME_UI_ACC_BIPOD, _ctrlAccBipod];
	_childControls pushBack _ctrlAccBipod;

		_accSizeMul = 1.5 * ([configFile >> "CfgWeapons" >> _class >> "WeaponSlotsInfo" >> "UnderBarrelSlot", "iconScale", 0.2] call BIS_fnc_returnConfigEntry);
		_posAcc = [configFile >> "CfgWeapons" >> _class >> "WeaponSlotsInfo" >> "UnderBarrelSlot", "iconPosition", [0, 0]] call BIS_fnc_returnConfigEntry;
		_posAccX = _posACc select 0;
		_posAccY = _posACc select 1;
		_width = _accSizeMul * _widthNew;
		_height = _accSizeMul * _heightNew;

		// If the item is rotated, rotate the control and invert the width/height
		if (_isRotated) then {
			_ctrlAccBipod ctrlSetPosition [
				_posX + (1 - _posAccY) * _widthNew - _width * 0.25,
				_posY + _posAccX * _heightNew - _height * 0.5,
				_width,
				_height
			];
			_ctrlAccBipod ctrlCommit 0;
			_ctrlAccBipod ctrlSetAngle [90, 0.5, 0.5];

		// Otherwise, position the control normally
		} else {
			_ctrlAccBipod ctrlSetPosition [
				_posX + _posAccX * _widthNew - _width * 0.5,
				_posY + _posAccY * _heightNew - _height * 0.75,
				_width,
				_height
			];
			_ctrlAccBipod ctrlCommit 0;
		};

		_ctrlAccBipod ctrlSetText MACRO_PICTURE_WEAPON_ACC_BIPOD;

	// Create the side attachment icon
	_ctrlAccSide = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedPicture", -1, _ctrlParent];
	_ctrl setVariable [MACRO_VARNAME_UI_ACC_SIDE, _ctrlAccSide];
	_childControls pushBack _ctrlAccSide;

		_accSizeMul = ([configFile >> "CfgWeapons" >> _class >> "WeaponSlotsInfo" >> "PointerSlot", "iconScale", 0.2] call BIS_fnc_returnConfigEntry);
		_posAcc = [configFile >> "CfgWeapons" >> _class >> "WeaponSlotsInfo" >> "PointerSlot", "iconPosition", [0, 0]] call BIS_fnc_returnConfigEntry;
		_posAccX = _posACc select 0;
		_posAccY = _posACc select 1;
		_width = _accSizeMul * _widthNew;
		_height = _accSizeMul * _heightNew;

		// If the item is rotated, rotate the control and invert the width/height
		if (_isRotated) then {
			_ctrlAccSide ctrlSetPosition [
				_posX + (1 - _posAccY) * _widthNew - _width * 0.5,
				_posY + _posAccX * _heightNew - _height * 0.5,
				_width,
				_height
			];
			_ctrlAccSide ctrlCommit 0;
			_ctrlAccSide ctrlSetAngle [90, 0.5, 0.5];

		// Otherwise, position the control normally
		} else {
			_ctrlAccSide ctrlSetPosition [
				_posX + _posAccX * _widthNew - _width * 0.5,
				_posY + _posAccY * _heightNew - _height * 0.5,
				_width,
				_height
			];
			_ctrlAccSide ctrlCommit 0;
		};

		_ctrlAccSide ctrlSetText MACRO_PICTURE_WEAPON_ACC_SIDE;

	// Create the optic attachment icon
	_ctrlAccOptic = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedPicture", -1, _ctrlParent];
	_ctrl setVariable [MACRO_VARNAME_UI_ACC_OPTIC, _ctrlAccOptic];
	_childControls pushBack _ctrlAccOptic;

		_accSizeMul = 4 * ([configFile >> "CfgWeapons" >> _class >> "WeaponSlotsInfo" >> "CowsSlot", "iconScale", 0.2] call BIS_fnc_returnConfigEntry);
		_posAcc = [configFile >> "CfgWeapons" >> _class >> "WeaponSlotsInfo" >> "CowsSlot", "iconPosition", [0, 0]] call BIS_fnc_returnConfigEntry;
		_posAccX = _posACc select 0;
		_posAccY = _posACc select 1;
		_width = _accSizeMul * _widthNew;
		_height = _accSizeMul * _heightNew;

		// If the item is rotated, rotate the control and invert the width/height
		if (_isRotated) then {
			_ctrlAccOptic ctrlSetPosition [
				_posX + (1 - _posAccY) * _widthNew - _width * 0.375,		// 0.5 - 1 / 8
				_posY + _posAccX * _heightNew - _height * 0.5,
				_width,
				_height
			];
			_ctrlAccOptic ctrlCommit 0;
			_ctrlAccOptic ctrlSetAngle [90, 0.5, 0.5];

		// Otherwise, position the control normally
		} else {
			_ctrlAccOptic ctrlSetPosition [
				_posX + _posAccX * _widthNew - _width * 0.5,
				_posY + _posAccY * _heightNew - _height * 0.625,		// 0.5 + 1 / 8
				_width,
				_height
			];
			_ctrlAccOptic ctrlCommit 0;
		};

		_ctrlAccOptic ctrlSetText MACRO_PICTURE_WEAPON_ACC_OPTIC;


	// Save the child controls
	_ctrl setVariable [MACRO_VARNAME_UI_CHILDCONTROLS, _childControls];
};





// Next, we update the existing child controls
private _colourArray = [[1,1,1,1], [0,0,0,0]];
_ctrlAccMuzzle ctrlSetTextColor (_colourArray select isNull _itemData_accMuzzle);
_ctrlAccBipod ctrlSetTextColor (_colourArray select isNull _itemData_accBipod);
_ctrlAccSide ctrlSetTextColor (_colourArray select isNull _itemData_accSide);
_ctrlAccOptic ctrlSetTextColor (_colourArray select isNull _itemData_accOptic);
