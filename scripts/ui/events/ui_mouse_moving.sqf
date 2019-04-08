// Cursor is moving across the control area
case "ui_mouse_moving": {
	_eventExists = true;

	// Fetch the parameters
	_args params [
		["_ctrl", controlNull, [controlNull]],		// The control that the mouse is currently moving over
		["_posRelX", -99999, [-1]],
		["_posRelY", -99999, [-1]]
	];

	// If the control is null, exit
	if (isNull _ctrl) exitWith {};

	// Fetch the control's dimensions
	(ctrlPosition _ctrl) params ["_posCtrlX", "_posCtrlY", "_widthCtrl", "_heightCtrl"];

	// Check if an empty control, or an invalid relative position was provided
	if (_posRelX == -99999 or {_posRelY == -99999}) then {
		private _cursorPosRel = _inventory getVariable [MACRO_VARNAME_UI_CURSORPOSREL, [0,0]];
		_posRelX = _cursorPosRel select 0;
		_posRelY = _cursorPosRel select 1;

	// If not, update the cursor control and the relative position on the inventory
	} else {
		_posRelX = _posRelX - _posCtrlX;
		_posRelY = _posRelY - _posCtrlY;

		_inventory setVariable [MACRO_VARNAME_UI_CURSORCTRL, _ctrl];
		_inventory setVariable [MACRO_VARNAME_UI_CURSORPOSREL, [_posRelX, _posRelY]];
	};


	// Fetch the dragged control and the drop control
	private _ctrlDrop = _inventory displayCtrl MACRO_IDC_GROUND_DROP_FRAME;
	private _draggedCtrl = _inventory getVariable [MACRO_VARNAME_UI_DRAGGEDCTRL, controlNull];

	// If the dragged control is not null, and is being dragged...
	if (_draggedCtrl getVariable [MACRO_VARNAME_UI_ISBEINGDRAGGED, false]) then {

		// Fetch the dragged control's slot size
		(_draggedCtrl getVariable [MACRO_VARNAME_SLOTSIZE, [1,1]]) params ["_slotSizeW", "_slotSizeH"];

		// Fetch the temporary frame, aswell as the target control's slot position
		private _ctrlFrameTemp = _draggedCtrl getVariable [MACRO_VARNAME_UI_FRAMETEMP, controlNull];

		// Fetch the item and container data
		private _containerData = _ctrl getVariable [MACRO_VARNAME_PARENTDATA, locationNull];
		private _itemData = _draggedCtrl getVariable [MACRO_VARNAME_DATA, locationNull];

		// Fetch the target control's slot position
		private _targetSlotPos = _ctrl getVariable [MACRO_VARNAME_SLOTPOS, [MACRO_ENUM_SLOTPOS_INVALID, MACRO_ENUM_SLOTPOS_INVALID]];
		_targetSlotPos params ["_targetSlotPosX", "_targetSlotPosY"];

		// If the control is a reserved slot, do a simple check to see if the item can fit in it
		if (_targetSlotPosX < 0) then {

			// If we're hovering over a drop control, highlight it (don't check if the item fits)
			if (_targetSlotPosX == MACRO_ENUM_SLOTPOS_DROP) then {
				//private _ctrlIconTemp = _ctrlFrameTemp getVariable [MACRO_VARNAME_UI_CTRLICON, controlNull];
				//_ctrlIconTemp ctrlSetTextColor [0,1,0,1];
				_ctrl ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE_HOVER);	// MACRO_COLOUR_ELEMENT_DRAGGING_GREEN

				// Add the drop frame to the highlit controls array
				 private _ctrls = _inventory getVariable [MACRO_VARNAME_UI_HIGHLITCONTROLS, []];
				 if !(_ctrl in _ctrls) then {
					 _ctrls pushBack _ctrl;
				 	_inventory setVariable [MACRO_VARNAME_UI_HIGHLITCONTROLS, _ctrls];
				};

			// Otherwise...
			} else {

				// Fetch the allowed controls and the temporary icon
				private _allowedCtrls = _inventory getVariable [MACRO_VARNAME_UI_ALLOWEDCONTROLS, []];
				private _ctrlIconTemp = _ctrlFrameTemp getVariable [MACRO_VARNAME_UI_CTRLICON, controlNull];

				// If the item is allowed to go in the target control, paint it green
				if (_ctrl in _allowedCtrls) then {

					// Check if the item fits
					([_itemData, _containerData, _targetSlotPos, [], false] call cre_fnc_inv_canFitItem) params ["_canFit"];

					if (_canFit) then {
						_ctrl ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_DRAGGING_GREEN);
						_ctrlIconTemp ctrlSetTextColor [0,1,0,1];
					} else {
						_ctrlIconTemp ctrlSetTextColor [1,0,0,1];
					};
				} else {
					_ctrlIconTemp ctrlSetTextColor [1,0,0,1];
				};
			};

			// Reset the slot position
			_inventory setVariable [MACRO_VARNAME_UI_CURSORPOSNEW, _targetSlotPos];

		// Otherwise, determine whether the item can fit via its size
		} else {

			// If the item is rotated, flip the slot sizes
			if (_ctrlFrameTemp getVariable [MACRO_VARNAME_ISROTATED, false]) then {
				private _slotSizeTemp = _slotSizeW;
				_slotSizeW = _slotSizeH;
				_slotSizeH = _slotSizeTemp;
			};

			// Fetch the target control's slot size
			(_ctrl getVariable [MACRO_VARNAME_SLOTSIZE, [1,1]]) params ["_targetSlotSizeW", "_targetSlotSizeH"];

			// If the target control is the same as the dragged control, treat it as an empty slot (of size [1,1])
			if (_ctrl == _draggedCtrl) then {
				_targetSlotSizeW = 1;
				_targetSlotSizeH = 1;
			} else {
				// If the target control is rotated, invert the width/height
				if (_ctrl getVariable [MACRO_VARNAME_ISROTATED, false]) then {
					private _widthTemp = _targetSlotSizeW;
					_targetSlotSizeW = _targetSlotSizeH;
					_targetSlotSizeH = _widthTemp;
				};
			};

			// Factor the relative cursor position in (noticeable on large items)
			private _oneSlotSizeW = _widthCtrl / _targetSlotSizeW;
			private _oneSlotSizeH = _heightCtrl / _targetSlotSizeH;
			_targetSlotPosX = _targetSlotPosX + (0 max floor ((_posRelX  / _oneSlotSizeW) - 0.5));
			_targetSlotPosY = _targetSlotPosY + (0 max floor ((_posRelY  / _oneSlotSizeH) - 0.5));

			// Offset the slot by 50% of the size of the control, so it's centered
			_targetSlotPosX = _targetSlotPosX - ceil (_slotSizeW / 2) + 1;
			_targetSlotPosY = _targetSlotPosY - ceil (_slotSizeH / 2) + 1;

			// If the width is even, and the mouse is in the left 50% of the control, pick the next slot to the left
			if (_slotSizeW % 2 == 0 and {_posRelX < _oneSlotSizeW * 0.5}) then {
				_targetSlotPosX = _targetSlotPosX - 1;
			};

			// Same thing on the Y axis
			if (_slotSizeH % 2 == 0 and {_posRelY < _oneSlotSizeH * 0.5}) then {
				_targetSlotPosY = _targetSlotPosY - 1;
			};

			// Clamp the slot position (stop it from going negative)
			_targetSlotPosX = _targetSlotPosX max 0;
			_targetSlotPosY = _targetSlotPosY max 0;

			// Save the new slot position onto the inventory
			_inventory setVariable [MACRO_VARNAME_UI_CURSORPOSNEW, [_targetSlotPosX, _targetSlotPosY]];

			// Test if the dragged item can fit
			([_itemData, _containerData, [_targetSlotPosX, _targetSlotPosY], [_slotSizeW, _slotSizeH], false] call cre_fnc_inv_canFitItem) params ["_canFit", "_slots"];

			// Fetch the controls
			private _containerCtrl = _ctrl getVariable [MACRO_VARNAME_UI_CTRLPARENT, controlNull];
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

		// Make sure the control isn't one that's about to be dragged
		if (!isNull _ctrl and {_ctrl != _draggedCtrl} and {_ctrl != _ctrlDrop}) then {

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
	};
};
