// Rotate control
case "ui_dragging_rotate": {
	_eventExists = true;

	// Fetch the control
	private _draggedCtrl = _inventory getVariable [MACRO_VARNAME_UI_DRAGGEDCTRL, controlNull];

	// Only continue if the control still exists and isn't already being dragged
	if (!isNull _draggedCtrl) then {

		// Fetch the control's item class and its associated size
		private _class = _draggedCtrl getVariable [MACRO_VARNAME_CLASS, ""];
		private _category = [_class] call cre_fnc_cfg_getClassCategory;
		private _slotSize = [_class, _category] call cre_fnc_cfg_getClassSlotSize;
		_slotSize params ["_slotWidth", "_slotHeight"];
		private _defaultIconPath = _draggedCtrl getVariable [MACRO_VARNAME_UI_DEFAULTICONPATH, ""];
		private _safeZoneW = uiNamespace getVariable ["Cre8ive_Inventory_SafeZoneW", 0];
		private _safeZoneH = uiNamespace getVariable ["Cre8ive_Inventory_SafeZoneH", 0];

		// Fetch the old temporary frame
		private _ctrlFrameTemp = _inventory getVariable [MACRO_VARNAME_UI_FRAMETEMP, controlNull];
		private _posCtrl = ctrlPosition _ctrlFrameTemp;
		_posCtrl params [["_posCtrlX", 0], ["_posCtrlY", 0]];

		// Fetch and invert the rotation variable
		private _isRotated = !(_ctrlFrameTemp getVariable [MACRO_VARNAME_ISROTATED, false]);

		// Delete the old temporary frame (and it's child controls)
		[_ctrlFrameTemp] call cre_fnc_ui_deleteSlotCtrl;

		// Update the size
		if (_isRotated) then {	// Rotated
			_posCtrl set [2, _slotHeight * _safeZoneW * MACRO_SCALE_SLOT_SIZE_W];
			_posCtrl set [3, _slotWidth * _safeZoneH * MACRO_SCALE_SLOT_SIZE_H];
		} else {		// Not rotated
			_posCtrl set [2, _slotWidth * _safeZoneW * MACRO_SCALE_SLOT_SIZE_W];
			_posCtrl set [3, _slotHeight * _safeZoneH * MACRO_SCALE_SLOT_SIZE_H];
		};

		// Create a temporary frame that follows the mouse
		_ctrlFrameTemp = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedBox", -1];
		MACRO_FNC_UI_CTRL_SETPOSITION(_ctrlFrameTemp, _posCtrl, 0);
		_ctrlFrameTemp ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);
		_inventory setVariable [MACRO_VARNAME_UI_FRAMETEMP, _ctrlFrameTemp];

		// Set the frame's pixel precision mode to off, disables rounding
		_ctrlFrameTemp ctrlSetPixelPrecision MACRO_GLOBAL_PIXELPRECISIONMODE;

		// Copy the original control's item data onto the dummy frame
		private _data = _draggedCtrl getVariable [MACRO_VARNAME_DATA, locationNull];
		_ctrlFrameTemp setVariable [MACRO_VARNAME_DATA, _data];

		// Update the rotation variable on the temporary frame control (NOT on the dragged control/item data, because we can still abort the dragging process!)
		_ctrlFrameTemp setVariable [MACRO_VARNAME_ISROTATED, _isRotated];

		// Generate additional temporary child controls
		private _tempChildControls = [_ctrlFrameTemp, _class, _category, _defaultIconPath] call cre_fnc_ui_generateChildControls;

		// Move the temporary controls in place initially
		getMousePosition params ["_posX", "_posY"];
		["ui_dragging", [_draggedCtrl, _posX, _posY]] call cre_fnc_ui_inventory;

		// Update the highlighted controls (only if the cursor slot is not a reserved slot, otherwise it will always highlight)
		private _cursorCtrl = _inventory getVariable [MACRO_VARNAME_UI_CURSORCTRL, controlNull];
		private _cursorSlotPos = _cursorCtrl getVariable [MACRO_VARNAME_SLOTPOS, [MACRO_ENUM_SLOTPOS_INVALID, MACRO_ENUM_SLOTPOS_INVALID]];
		if ((_cursorSlotPos select 0) >= 0) then {
			["ui_mouse_moving", [_cursorCtrl]] call cre_fnc_ui_inventory;
		};
	};
};
