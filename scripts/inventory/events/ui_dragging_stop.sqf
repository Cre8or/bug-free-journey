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

                        // Reset the colour of the original slot frame
                        _ctrl ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);

                        _ctrl ctrlRemoveAllEventHandlers "MouseMoving";

                        // Unhide the child picture
                        (_ctrl getVariable ["childPictureIcon", controlNull]) ctrlShow true;

                        // Delete the temporary slot picture
                        ctrlDelete (_ctrl getVariable ["childPictureSlotTemp", controlNull]);

                        // Hide the dragging controls
                        {
                                _x ctrlShow false;
                        } forEach (_ctrl getVariable ["childControlsTemp", []]);
                };
        };
};
