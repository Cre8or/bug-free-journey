// Stop dragging
case "ui_dragging_stop": {
        _eventExists = true;

	// Fetch the parameters
        _args params [
		["_ctrl", controlNull, [controlNull]]
	];

	// Remove the dragging EH
	_inventory displayRemoveAllEventHandlers "MouseMoving";
	_inventory setVariable ["draggedControl", controlNull];

        if (!isNull _ctrl and {_ctrl getVariable ["isBeingDragged", false]}) then {

                // Mark the control as not being dragged anymore
                _ctrl setVariable ["isBeingDragged", false];

                // Set the focus inside the control group back to its respective dummy control
                switch (ctrlParentControlsGroup _ctrl) do {
                        case (_inventory displayCtrl MACRO_IDC_GROUND_CTRLGRP): {ctrlSetFocus (_inventory displayCtrl MACRO_IDC_GROUND_FOCUS_FRAME)};
                        case (_inventory displayCtrl MACRO_IDC_WEAPONS_CTRLGRP): {ctrlSetFocus (_inventory displayCtrl MACRO_IDC_WEAPONS_FOCUS_FRAME)};
                        case (_inventory displayCtrl MACRO_IDC_MEDICAL_CTRLGRP): {ctrlSetFocus (_inventory displayCtrl MACRO_IDC_MEDICAL_FOCUS_FRAME)};
                        case (_inventory displayCtrl MACRO_IDC_STORAGE_CTRLGRP): {ctrlSetFocus (_inventory displayCtrl MACRO_IDC_STORAGE_FOCUS_FRAME)};
                };

                // Only continue if the control is active
                if (_ctrl getVariable ["active", false] and {ctrlShown _ctrl}) then {

			_ctrl ctrlRemoveAllEventHandlers "MouseMoving";
			private _ctrlFrameTemp = _ctrl getVariable ["ctrlFrameTemp", controlNull];

                        // Reset the colour of the original slot frame
                        _ctrl ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);

                        // Delete the temporary slot picture
                        ctrlDelete (_ctrl getVariable ["ctrlIconTemp", controlNull]);

                        // Remove the dragging controls
                        {
                                ctrlDelete _x;
                        } forEach (_ctrlFrameTemp getVariable ["childControls", []]);
			ctrlDelete _ctrlFrameTemp;

			// Unhide the original control's child controls
			{
				_x ctrlShow true;
			} forEach (_ctrl getVariable ["childControls", []]);
                };
        };
};
