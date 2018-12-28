// Dragging completed successfully (button released)
case "ui_dragging_complete": {
	_eventExists = true;

	// Fetch the parameters
	_args params [
		"",
		["_button", 0, [0]]
	];

	// Only register left-clicks
	if (_button == 0) then {

		// Reset the dragged control variables (if applicable)
		_inventory setVariable [MACRO_VARNAME_UI_DRAGGEDCTRL, controlNull];

		// Remove the MouseButtonUp event handler
		private _EH = _inventory getVariable [MACRO_VARNAME_UI_EH_MOUSEBUTTONUP, -1];
		_inventory displayRemoveEventHandler ["MouseButtonUp", _EH];

		// Reset the allowed controls list
		//_inventory setVariable [MACRO_VARNAME_UI_ALLOWEDCONTROLS, []];
	};
};
