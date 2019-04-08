// Start dragging
case "ui_dragging_abort": {
	_eventExists = true;

	// Remove the event handlers
	_inventory displayRemoveEventHandler ["KeyDown", _inventory getVariable [MACRO_VARNAME_UI_EH_KEYDOWN, -1]];
	_inventory displayRemoveEventHandler ["MouseButtonDown", _inventory getVariable [MACRO_VARNAME_UI_EH_MOUSEBUTTONDOWN, -1]];
	_inventory displayRemoveAllEventHandlers "MouseMoving";

	// Fetch the control
	private _draggedCtrl = _inventory getVariable [MACRO_VARNAME_UI_DRAGGEDCTRL, controlNull];

	// Only continue if the control still exists and isn't already being dragged
	if (!isNull _draggedCtrl) then {

		// Reset the focus
		["ui_focus_reset", [_draggedCtrl]] call cre_fnc_ui_inventory;

		// Fetch the control's item class and its associated size
		private _class = _draggedCtrl getVariable [MACRO_VARNAME_CLASS, ""];
		private _category = [_class] call cre_fnc_cfg_getClassCategory;

		// Mark the control as no longer being dragged
		_draggedCtrl setVariable [MACRO_VARNAME_UI_ISBEINGDRAGGED, false];
		_inventory setVariable [MACRO_VARNAME_UI_DRAGGEDCTRL, controlNull];

		// Reset the colour of the original slot frame
		_draggedCtrl ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);

		// Delete the temporary slot picture
		ctrlDelete (_draggedCtrl getVariable [MACRO_VARNAME_UI_ICONTEMP, controlNull]);

		// Remove the dragging controls
		private _ctrlFrameTemp = _draggedCtrl getVariable [MACRO_VARNAME_UI_FRAMETEMP, controlNull];
		{
			ctrlDelete _x;
		} forEach (_ctrlFrameTemp getVariable [MACRO_VARNAME_UI_CHILDCONTROLS, []]);
		ctrlDelete _ctrlFrameTemp;

		// Restore the original colour on the highlighted controls (copied from ui_mouse_exit)
		private _ctrlDrop = _inventory displayCtrl MACRO_IDC_GROUND_DROP_FRAME;
		{
			// If the current control is the drop control, make it invisible
			if (_x == _ctrlDrop) then {
				_x ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_INVISIBLE);

			// Otherwise, apply the usual behaviour
			} else {
				if (_x getVariable ["active", false] and {_x != _draggedCtrl}) then {
					_x ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);
				} else {
					_x ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);
				};
			};
		} forEach (_inventory getVariable [MACRO_VARNAME_UI_HIGHLITCONTROLS, []]);
		_inventory setVariable [MACRO_VARNAME_UI_HIGHLITCONTROLS, []];

		// Unhide the original control's child controls
		{
			_x ctrlShow true;
		} forEach (_draggedCtrl getVariable [MACRO_VARNAME_UI_CHILDCONTROLS, []]);

		// Reset the allowed and forbidden controls
		private _allowedCtrls = _inventory getVariable [MACRO_VARNAME_UI_ALLOWEDCONTROLS, []];
		private _forbiddenCtrls = _inventory getVariable [MACRO_VARNAME_UI_FORBIDDENCONTROLS, []];
		{
			if (_x getVariable ["active", false]) then {
				_x ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);
			} else {
				_x ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);
			};
		} forEach (_allowedCtrls + _forbiddenCtrls);
		_inventory setVariable [MACRO_VARNAME_UI_ALLOWEDCONTROLS, []];
		_inventory setVariable [MACRO_VARNAME_UI_FORBIDDENCONTROLS, []];


		// If the control is a container slot, handle the hidden slot controls
		private _containerCtrl = _draggedCtrl getVariable [MACRO_VARNAME_UI_CTRLPARENT, controlNull];
		if (!isNull _containerCtrl and {_draggedCtrl != _containerCtrl}) then {

			// Rehide the hidden slot controls
			{
				_x ctrlShow false;
			} forEach (_inventory getVariable [MACRO_VARNAME_UI_HIDDENSLOTCONTROLS, []]);
			_inventory setVariable [MACRO_VARNAME_UI_HIDDENSLOTCONTROLS, []];

			// Fetch some additional data
			private _safeZoneW = uiNamespace getVariable ["Cre8ive_Inventory_SafeZoneW", 0];
			private _safeZoneH = uiNamespace getVariable ["Cre8ive_Inventory_SafeZoneH", 0];
			([_class, _category] call cre_fnc_cfg_getClassSlotSize) params ["_slotWidth", "_slotHeight"];
			private _posCtrl = ctrlPosition _draggedCtrl;

			// If the item is rotated, flip the width and height
			private _isRotated = _draggedCtrl getVariable [MACRO_VARNAME_ISROTATED, false];
			if (_isRotated) then {
				private _widthTemp = _slotWidth;
				_slotWidth = _slotHeight;
				_slotHeight = _widthTemp;
			};

			// Rescale the control
			_posCtrl set [2, _slotWidth * _safeZoneW * MACRO_SCALE_SLOT_SIZE_W];
			_posCtrl set [3, _slotHeight * _safeZoneH * MACRO_SCALE_SLOT_SIZE_H];
			_draggedCtrl ctrlSetPosition _posCtrl;
			_draggedCtrl ctrlCommit 0;

		};

		// Reset the cursor variables
		_inventory setVariable [MACRO_VARNAME_UI_CURSORCTRL, controlNull];
		_inventory setVariable [MACRO_VARNAME_UI_CURSORPOSNEW, []];
	};
};
