// Cursor is moving across the control area
case "ui_mouse_moving": {
	_eventExists = true;

	// Fetch the parameters
	_args params [
		["_ctrl", controlNull, [controlNull]],
		["_posRelX", 0, [0]],
		["_posRelY", 0, [0]]
	];

	// Determine the position of the mouse cursor relative to the control
	(ctrlPosition _ctrl) params ["_posCtrlX", "_posCtrlY", "_widthCtrl", "_heightCtrl"];
	_posRelX = (_posRelX - _posCtrlX) / _widthCtrl;
	_posRelY = (_posRelY - _posCtrlY) / _heightCtrl;

	// Save the mouse position relative to the control onto the inventory
	_inventory setVariable [MACRO_VARNAME_UI_CURSORPOSREL, [_posRelX, _posRelY]];

	// Check if the control has changed
	private _ctrlOld = _inventory getVariable [MACRO_VARNAME_UI_CURSORCTRL, controlNull];
	private _draggedCtrl = _inventory getVariable [MACRO_VARNAME_UI_DRAGGEDCTRL, controlNull];

	if (!isNull _draggedCtrl) then {

		// Fetch the temporary frame
		private _ctrlFrameTemp = _draggedCtrl getVariable [MACRO_VARNAME_UI_FRAMETEMP, controlNull];

		// Fetch the target control's slot position
		private _slotPos = _ctrl getVariable [MACRO_VARNAME_SLOTPOS, [0,0]];

		// If the control is a reserved slot, do a simple check to see if the item can fit in it
		if (_slotPos isEqualTo [0,0]) then {

			// Fetch the allowed controls
			private _allowedCtrls = _inventory getVariable [MACRO_VARNAME_UI_ALLOWEDCONTROLS, []];

			// Fetch the temporary icon
			_ctrlIconTemp = _ctrlFrameTemp getVariable [MACRO_VARNAME_UI_CTRLICON, controlNull];

			// If the item is allowed to go in the target control, paint it green
			if (_ctrl in _allowedCtrls) then {

				if (_ctrl getVariable ["active", false] and {_ctrl == _draggedCtrl}) then {
					_ctrl ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_DRAGGING_GREEN);
					_ctrlIconTemp ctrlSetTextColor [0,1,0,1];
				} else {
					_ctrlIconTemp ctrlSetTextColor [1,0,0,1];
				};
			} else {
				_ctrlIconTemp ctrlSetTextColor [1,0,0,1];
			};

		// Otherwise, determine whether the item can fit via its size
		} else {

			// Fetch the dragged control's slot size
			(_draggedCtrl getVariable [MACRO_VARNAME_SLOTSIZE, [1,1]]) params ["_slotSizeW", "_slotSizeH"];
			_slotPos params ["_slotPosX", "_slotPosY"];


			// Offset the slot by 50% of the size of the control, so it's centered
			_slotPosX = _slotPosX - ceil (_slotSizeW / 2) + 1;
			_slotPosY = _slotPosY - ceil (_slotSizeH / 2) + 1;

			// If the width is even, and the mouse is in the left 50% of the control, pick the next slot to the left
			if (_slotSizeW % 2 == 0 and {_posRelX < 0.5}) then {
				_slotPosX = _slotPosX - 1;
			};

			// Same thing on the Y axis
			if (_slotSizeH % 2 == 0 and {_posRelY < 0.5}) then {
				_slotPosY = _slotPosY - 1;
			};

			// Save the new slot position onto the inventory
			_inventory setVariable [MACRO_VARNAME_UI_CURSORPOSNEW, [_slotPosX, _slotPosY]];

			// Test if the dragged item can fit
			private _containerCtrl = _ctrl getVariable [MACRO_VARNAME_UI_CTRLPARENT, controlNull];
			private _containerData = _ctrl getVariable [MACRO_VARNAME_PARENT, locationNull];
			private _itemData = _draggedCtrl getVariable [MACRO_VARNAME_DATA, locationNull];
			([_itemData, _containerData, [_slotPosX, _slotPosY], [_slotSizeW, _slotSizeH], false] call cre_fnc_canFitItem) params ["_canFit", "_slots"];

			// Fetch the controls
			private _ctrls = [];
			{
				private _ctrlX = _containerCtrl getVariable [format [MACRO_VARNAME_SLOT_X_Y, _x select 0, _x select 1], controlNull];
				if (!isNull _ctrlX) then {
					_ctrls pushBack _ctrlX;
				};
			} forEach _slots;

			// If the item fits, paint the required slots green
			if (_canFit) then {
				// Paint the new controls in green
				{
					_x ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_DRAGGING_GREEN);
				} forEach _ctrls;

				(_ctrlFrameTemp getVariable [MACRO_VARNAME_UI_CTRLICON, controlNull]) ctrlSetTextColor [1,1,1,1];

			} else {
				{
					_x ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_DRAGGING_RED);
				} forEach _ctrls;

				(_ctrlFrameTemp getVariable [MACRO_VARNAME_UI_CTRLICON, controlNull]) ctrlSetTextColor [1,0,0,1];
			};

			// Fetch the previously painted controls
			private _ctrlsOld = _inventory getVariable [MACRO_VARNAME_UI_HIGHLITCONTROLS, []];
			private _ctrlsToReset = _ctrlsOld - _ctrls;

			// Paint the old controls in whichever colour they were before
			{
				if (ctrlShown _x) then {
					if (_x getVariable ["active", false] and {_x != _draggedCtrl}) then {
						_x ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);
					} else {
						_x ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);
					};
				};
			} forEach _ctrlsToReset;

			// Update the list of highlighted controls
			_inventory setVariable [MACRO_VARNAME_UI_HIGHLITCONTROLS, _ctrls];
		};

	// Otherwise, if we're not dragging anything, highlight the control under the cursor
	} else {
		// Paint the old controls in whichever colour they were before
		private _ctrlsOld = _inventory getVariable [MACRO_VARNAME_UI_HIGHLITCONTROLS, []];
		{
			if (ctrlShown _x) then {
				if (_x getVariable ["active", false]) then {
					_x ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);
				} else {
					_x ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);
				};
			};
		} forEach _ctrlsOld;

		// Paint the control under the cursor
		if (_ctrl getVariable ["active", false]) then {
			_ctrl ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE_HOVER);
		} else {
			_ctrl ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE_HOVER);
		};

		// Update the list of highlighted controls
		_inventory setVariable [MACRO_VARNAME_UI_HIGHLITCONTROLS, [_ctrl]];
	};

	// Update the control on the inventory
	_inventory setVariable [MACRO_VARNAME_UI_CURSORCTRL, _ctrl];
};
