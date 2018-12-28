// Load the weapons menu
case "ui_menu_weapons": {
	_eventExists = true;

	// Show the weapons controls
	(_inventory displayCtrl MACRO_IDC_WEAPONS_CTRLGRP) ctrlShow true;
	(_inventory displayCtrl MACRO_IDC_MEDICAL_CTRLGRP) ctrlShow false;

	// Change the button colours
	(_inventory displayCtrl MACRO_IDC_WEAPONS_BUTTON_FRAME) ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);
	(_inventory displayCtrl MACRO_IDC_MEDICAL_BUTTON_FRAME) ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);
	//_inventory setVariable ["isMedicalMenuOpen", false];

	// Reset the focus
	["ui_focus_reset"] call cre_fnc_ui_inventory;

	// Update the menu
	["ui_update_weapons"] call cre_fnc_ui_inventory;
};
