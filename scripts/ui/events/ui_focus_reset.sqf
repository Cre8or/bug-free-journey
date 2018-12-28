// Reset the focus
case "ui_focus_reset": {
	_eventExists = true;

	// If we have any additional parameters...
	if (!isNil "_args") then {

		// ...we fetch them
		_args params [
			["_ctrl", controlNull, [controlNull]]
		];

		// Set the focus into the parent group of the passed control, so it moves ontop of everything else
		if (!isNull _ctrl) then {
			switch (ctrlParentControlsGroup _ctrl) do {
				case (_inventory displayCtrl MACRO_IDC_GROUND_CTRLGRP): {ctrlSetFocus (_inventory displayCtrl MACRO_IDC_GROUND_FOCUS_FRAME)};
				case (_inventory displayCtrl MACRO_IDC_WEAPONS_CTRLGRP): {ctrlSetFocus (_inventory displayCtrl MACRO_IDC_WEAPONS_FOCUS_FRAME)};
				case (_inventory displayCtrl MACRO_IDC_MEDICAL_CTRLGRP): {ctrlSetFocus (_inventory displayCtrl MACRO_IDC_MEDICAL_FOCUS_FRAME)};
				case (_inventory displayCtrl MACRO_IDC_STORAGE_CTRLGRP): {ctrlSetFocus (_inventory displayCtrl MACRO_IDC_STORAGE_FOCUS_FRAME)};
			};
		};
	};

	// Next we shift the focus into the dummy controls group to force the temporary controls to the top
	ctrlSetFocus (_inventory displayCtrl MACRO_IDC_EMPTY_FOCUS_FRAME);
};
