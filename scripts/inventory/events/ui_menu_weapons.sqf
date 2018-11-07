// Load the weapons menu
case "ui_menu_weapons": {
        _eventExists = true;

        // Show the weapons controls
        (_inventory displayCtrl MACRO_IDC_WEAPONS_CTRLGRP) ctrlShow true;
        (_inventory displayCtrl MACRO_IDC_MEDICAL_CTRLGRP) ctrlShow false;

        // Change the button colours
        (_inventory displayCtrl MACRO_IDC_WEAPONS_BUTTON_FRAME) ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);
        (_inventory displayCtrl MACRO_IDC_MEDICAL_BUTTON_FRAME) ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);
	_inventory setVariable ["isMedicalMenuOpen", false];

        // Reset the overall focus back to the empty dummy control (stops buttons from breaking)
        ctrlSetFocus (_inventory displayCtrl MACRO_IDC_EMPTY_FOCUS_FRAME);

        // Set the pixel precision mode of all frames to "OFF"
        {
                _x ctrlSetPixelPrecision 2;
        } forEach [
                _inventory displayCtrl MACRO_IDC_NVGS_FRAME,
                _inventory displayCtrl MACRO_IDC_HEADGEAR_FRAME,
                _inventory displayCtrl MACRO_IDC_GOGGLES_FRAME,
                _inventory displayCtrl MACRO_IDC_BINOCULARS_FRAME,
                _inventory displayCtrl MACRO_IDC_PRIMARYWEAPON_FRAME,
                _inventory displayCtrl MACRO_IDC_HANDGUNWEAPON_FRAME,
                _inventory displayCtrl MACRO_IDC_SECONDARYWEAPON_FRAME,
                _inventory displayCtrl MACRO_IDC_MAP_FRAME,
                _inventory displayCtrl MACRO_IDC_GPS_FRAME,
                _inventory displayCtrl MACRO_IDC_RADIO_FRAME,
                _inventory displayCtrl MACRO_IDC_COMPASS_FRAME,
                _inventory displayCtrl MACRO_IDC_WATCH_FRAME
        ];

        // Update the menu
        ["ui_update_weapons"] call cre_fnc_inventory;
};
