// Update the ground menu
case "ui_update_ground": {
	_eventExists = true;

	// Fetch the drop control
	private _ctrlDrop = _inventory displayCtrl MACRO_IDC_GROUND_DROP_FRAME;

	// Add some event handlers for mouse moving across the drop control, and exiting it
	if !(_ctrlDrop getVariable [MACRO_VARNAME_UI_CTRL_HAS_EHS, false]) then {
		_ctrlDrop ctrlAddEventHandler ["MouseExit", {["ui_mouse_exit", _this] call cre_fnc_ui_inventory}];
		_ctrlDrop ctrlAddEventHandler ["MouseMoving", {["ui_mouse_moving", _this] call cre_fnc_ui_inventory}];

		// Set up the control's slot position
		_ctrlDrop setVariable [MACRO_VARNAME_SLOTPOS, [MACRO_ENUM_SLOTPOS_DROP, MACRO_ENUM_SLOTPOS_INVALID]];
		_ctrlDrop setVariable [MACRO_VARNAME_UI_CTRL_HAS_EHS, true];
	};
};
