// Start dragging
case "ui_dragging_abort": {
	_eventExists = true;

	// Fetch the control
	private _ctrl = _inventory getVariable [MACRO_VARNAME_UI_DRAGGEDCTRL, controlNull];

	// Only continue if the control still exists and isn't already being dragged
	if (!isNull _ctrl) then {

		// Reset the focus
		["ui_focus_reset", [_ctrl]] call cre_fnc_inventory;

		// Mark the control as no longer being dragged
		_ctrl setVariable [MACRO_VARNAME_UI_ISBEINGDRAGGED, false];
		_inventory setVariable [MACRO_VARNAME_UI_DRAGGEDCTRL, controlNull];

		// Remove the event handlers
		private _EH = _inventory getVariable [MACRO_VARNAME_UI_EH_MOUSEBUTTONDOWN, -1];
		_inventory displayRemoveEventHandler ["MouseButtonDown", _EH];
		_inventory displayRemoveAllEventHandlers "MouseMoving";

		// Reset the colour of the original slot frame
		_ctrl ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);

		// Delete the temporary slot picture
		ctrlDelete (_ctrl getVariable [MACRO_VARNAME_UI_ICONTEMP, controlNull]);

		// Remove the dragging controls
		private _ctrlFrameTemp = _ctrl getVariable [MACRO_VARNAME_UI_FRAMETEMP, controlNull];
		{
			ctrlDelete _x;
		} forEach (_ctrlFrameTemp getVariable [MACRO_VARNAME_UI_CHILDCONTROLS, []]);
		ctrlDelete _ctrlFrameTemp;

		// Unhide the original control's child controls
		{
			_x ctrlShow true;
		} forEach (_ctrl getVariable [MACRO_VARNAME_UI_CHILDCONTROLS, []]);
	};
};
