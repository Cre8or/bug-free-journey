// Start dragging
case "ui_dragging_abort": {
	_eventExists = true;

	// Fetch the control
	private _ctrl = _inventory getVariable [MACRO_VARNAME_UI_DRAGGEDCTRL, controlNull];

	// Only continue if the control still exists and isn't already being dragged
	if (!isNull _ctrl) then {

		// Set the focus into the parent group of the passed control, so it moves ontop of everything else
		switch (ctrlParentControlsGroup _ctrl) do {
			case (_inventory displayCtrl MACRO_IDC_GROUND_CTRLGRP): {ctrlSetFocus (_inventory displayCtrl MACRO_IDC_GROUND_FOCUS_FRAME)};
			case (_inventory displayCtrl MACRO_IDC_WEAPONS_CTRLGRP): {ctrlSetFocus (_inventory displayCtrl MACRO_IDC_WEAPONS_FOCUS_FRAME)};
			case (_inventory displayCtrl MACRO_IDC_MEDICAL_CTRLGRP): {ctrlSetFocus (_inventory displayCtrl MACRO_IDC_MEDICAL_FOCUS_FRAME)};
			case (_inventory displayCtrl MACRO_IDC_STORAGE_CTRLGRP): {ctrlSetFocus (_inventory displayCtrl MACRO_IDC_STORAGE_FOCUS_FRAME)};
		};

		// Next we shift the focus into the dummy controls group to force the temporary controls to the top
		ctrlSetFocus (_inventory displayCtrl MACRO_IDC_EMPTY_FOCUS_FRAME);

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
