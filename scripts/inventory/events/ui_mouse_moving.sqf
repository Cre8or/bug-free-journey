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
	(_ctrl getVariable [MACRO_VARNAME_SLOTPOS, [0,0]]) params ["_slotPosX", "_slotPosY"];

	if (!isNull _draggedCtrl) then {
		(_draggedCtrl getVariable [MACRO_VARNAME_SLOTSIZE, [1,1]]) params ["_slotSizeW", "_slotSizeH"];

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
		([_containerData, [_slotPosX, _slotPosY], [_slotSizeW, _slotSizeH], false] call cre_fnc_canFitItem) params ["_canFit", "_slots"];

		//systemChat format ["(%1) - pos: %2 - size: %3 - canFit: %4 - slots: %5", time, [_slotPosX, _slotPosY], [_slotSizeW, _slotSizeH], _canFit, _slots];

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
			//systemChat format ["(%1) %2", time, _containerData];

			// Paint the new controls in green
			{
				_x ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_DRAGGING_GREEN);
			} forEach _ctrls;

		} else {
			{
				_x ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_DRAGGING_RED);
			} forEach _ctrls;
		};


		// Fetch the previously painted controls
		private _ctrlsOld = _inventory getVariable [MACRO_VARNAME_UI_HIGHLITCONTROLS, []];
		private _ctrlsToReset = _ctrlsOld - _ctrls;

		// Paint the old controls in whichever colour they were before
		{
			if (_x getVariable ["active", false]) then {
				_x ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);
			} else {
				_x ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);
			};
		} forEach _ctrlsToReset;

		// Save the new list of painted controls
		_inventory setVariable [MACRO_VARNAME_UI_HIGHLITCONTROLS, _ctrls];
	};

	// Update the control on the inventory
	_inventory setVariable [MACRO_VARNAME_UI_CURSORCTRL, _ctrl];
	//_inventory setVariable [MACRO_VARNAME_UI_HIGHLITCONTROLS, []];

};
