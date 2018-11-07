// Load the medical menu
case "ui_menu_medical": {
        _eventExists = true;

        // Hide the weapons controls
        (_inventory displayCtrl MACRO_IDC_WEAPONS_CTRLGRP) ctrlShow false;
        (_inventory displayCtrl MACRO_IDC_MEDICAL_CTRLGRP) ctrlShow true;

        // Change the button colours
        (_inventory displayCtrl MACRO_IDC_WEAPONS_BUTTON_FRAME) ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);
        (_inventory displayCtrl MACRO_IDC_MEDICAL_BUTTON_FRAME) ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);
	_inventory setVariable ["isMedicalMenuOpen", true];

        // Reset the overall focus back to the empty dummy control (stops buttons from breaking)
        ctrlSetFocus (_inventory displayCtrl MACRO_IDC_EMPTY_FOCUS_FRAME);

        // Update the menu
        ["ui_update_medical"] call cre_fnc_inventory;
};
