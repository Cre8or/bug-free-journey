// Cursor enters the control area
case "ui_mouse_enter": {
	_eventExists = true;

	// Fetch the parameters
	_args params [
		["_ctrl", controlNull, [controlNull]]
	];

	// Fetch the dragged control
	private _draggedCtrl = _inventory getVariable [MACRO_VARNAME_UI_DRAGGEDCTRL, controlNull];

	// If we're not currently dragging anything, highlight the slot under the cursor
	if (isNull _draggedCtrl) then {

		// Only continue if the control is visible
		if (ctrlShown _ctrl and {_ctrl != _draggedCtrl}) then {
			if (_ctrl getVariable ["active", false]) then {
				_ctrl ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE_HOVER);
			} else {
				_ctrl ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE_HOVER);
			};
		};

	// If we are dragging something, check if it fits in the slot under the cursor
	} else {

		// Only continue if the control is visible
		if (ctrlShown _ctrl and {_ctrl != _draggedCtrl}) then {
			if (_ctrl getVariable ["active", false]) then {
				_ctrl ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_DRAGGING_RED);
			} else {
				_ctrl ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_DRAGGING_GREEN);
			};
		};
	};
};
