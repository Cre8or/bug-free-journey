// Cursor is exiting the control area
case "ui_mouse_exit": {
	_eventExists = true;

	// Fetch the parameters
	_args params [
		["_ctrl", controlNull, [controlNull]]
	];

	// Restore the dragged control's icon colour
	private _draggedCtrl = _inventory getVariable [MACRO_VARNAME_UI_DRAGGEDCTRL, controlNull];
	private _ctrlFrameTemp = _draggedCtrl getVariable [MACRO_VARNAME_UI_FRAMETEMP, controlNull];

	// Reset the temporary frame's colour
	(_ctrlFrameTemp getVariable [MACRO_VARNAME_UI_CTRLICON, controlNull]) ctrlSetTextColor [1,1,1,1];

	// If the control was an allowed reserved slot, paint it in the inactive (hover) colour
	if (_ctrl in (_inventory getVariable [MACRO_VARNAME_UI_ALLOWEDCONTROLS, []])) then {
		_ctrl ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE_HOVER);

	// Otherwise, reset its colour
	} else {

		// If the control was a forbidden reserved slot, don't modify the colour
		if !(_ctrl in (_inventory getVariable [MACRO_VARNAME_UI_FORBIDDENCONTROLS, []])) then {

			// If the control is not being dragged
			if (_draggedCtrl getVariable [MACRO_VARNAME_UI_ISBEINGDRAGGED, false]) then {

				// Restore the original colour on the highlighted controls
				{
					if (_x getVariable ["active", false] and {_x != _draggedCtrl}) then {
						_x ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);
					} else {
						_x ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);
					};
				} forEach (_inventory getVariable [MACRO_VARNAME_UI_HIGHLITCONTROLS, []]);
				_inventory setVariable [MACRO_VARNAME_UI_HIGHLITCONTROLS, []];

			} else {
				{
					if (_x getVariable ["active", false]) then {
						_x ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);
					} else {
						_x ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);
					};
				} forEach ((_inventory getVariable [MACRO_VARNAME_UI_HIGHLITCONTROLS, []]) - [_draggedCtrl]);
				_inventory setVariable [MACRO_VARNAME_UI_HIGHLITCONTROLS, []];
			};
		};
	};

	// Reset the cursor control on the inventory
	_inventory setVariable [MACRO_VARNAME_UI_CURSORCTRL, controlNull];
};
