// Stop dragging
case "ui_dragging_stop": {
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
	};
};
