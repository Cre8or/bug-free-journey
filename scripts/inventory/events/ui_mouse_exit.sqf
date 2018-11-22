// Cursor exits the control area
case "ui_mouse_exit": {
	_eventExists = true;

	// Fetch the parameters
	_args params [
		["_ctrl", controlNull, [controlNull]]
	];

	// Only continue if the control is visible
	if (ctrlShown _ctrl and {_ctrl != (_inventory getVariable [MACRO_VARNAME_UI_DRAGGEDCTRL, controlNull])}) then {
		if (_ctrl getVariable ["active", false]) then {
			_ctrl ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);
		} else {
			_ctrl ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);
		};
	};
};
