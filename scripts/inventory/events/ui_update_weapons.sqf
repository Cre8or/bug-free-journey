// Update the weapons menu
case "ui_update_weapons": {
        _eventExists = true;

        // Determine the player's assigned items
        private _map = "";
        private _GPS = "";
        private _radio = "";
        private _compass = "";
        private _watch = "";
        {
                private _simulation = [configfile >> "CfgWeapons" >> _x, "simulation", ""] call BIS_fnc_returnConfigEntry;
                switch (_simulation) do {
                        case "ItemMap": {_map = _x};
                        case "ItemGPS": {_GPS = _x};
                        case "ItemRadio": {_radio = _x};
                        case "ItemCompass": {_compass = _x};
                        case "ItemWatch": {_watch = _x};
                };
        } forEach assignedItems player;

        // Determine our classes array
        private _classes = [
                hmd player,
                headgear player,
                goggles player,
                binocular player,
                primaryWeapon player,
                handgunWeapon player,
                secondaryWeapon player,
                _map,
                _GPS,
                _radio,
                _compass,
                _watch
        ];

        // Determine the icon paths for the items and weapons that we have
        {
                private _class = _classes param [_forEachIndex, ""];

                if (_class != "") then {
                        private _frame = _x select 0;
                        private _icon = _x select 1;
                        private _default = _x select 2;
                        private _category = [_class] call cre_fnc_getClassCategory;
			private _iconPath = [_class, _category, _default] call cre_fnc_getClassIcon;
                        //private _iconPath = "res\ui\inventory\weapon_frame.paa";

                        _icon ctrlSetText _iconPath;
                        _frame ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);

                        // Save the slot's data
                        _frame setVariable ["active", true];
                        _frame setVariable ["childPictureIcon", _icon];
                        _frame setVariable ["defaultIconPath", _default];
                        _frame setVariable ["class", _class];
                };
        } forEach [
                [_inventory displayCtrl MACRO_IDC_NVGS_FRAME,			_inventory displayCtrl MACRO_IDC_NVGS_ICON,		MACRO_PICTURE_NVGS],
                [_inventory displayCtrl MACRO_IDC_HEADGEAR_FRAME,		_inventory displayCtrl MACRO_IDC_HEADGEAR_ICON,		MACRO_PICTURE_HEADGEAR],
                [_inventory displayCtrl MACRO_IDC_GOGGLES_FRAME,		_inventory displayCtrl MACRO_IDC_GOGGLES_ICON,		MACRO_PICTURE_GOGGLES],
                [_inventory displayCtrl MACRO_IDC_BINOCULARS_FRAME, 		_inventory displayCtrl MACRO_IDC_BINOCULARS_ICON,	MACRO_PICTURE_BINOCULARS],
                [_inventory displayCtrl MACRO_IDC_PRIMARYWEAPON_FRAME, 		_inventory displayCtrl MACRO_IDC_PRIMARYWEAPON_ICON,	MACRO_PICTURE_PRIMARYWEAPON],
                [_inventory displayCtrl MACRO_IDC_HANDGUNWEAPON_FRAME,		_inventory displayCtrl MACRO_IDC_HANDGUNWEAPON_ICON,	MACRO_PICTURE_HANDGUNWEAPON],
                [_inventory displayCtrl MACRO_IDC_SECONDARYWEAPON_FRAME,	_inventory displayCtrl MACRO_IDC_SECONDARYWEAPON_ICON,	MACRO_PICTURE_SECONDARYWEAPON],
                [_inventory displayCtrl MACRO_IDC_MAP_FRAME, 			_inventory displayCtrl MACRO_IDC_MAP_ICON,		MACRO_PICTURE_MAP],
                [_inventory displayCtrl MACRO_IDC_GPS_FRAME, 			_inventory displayCtrl MACRO_IDC_GPS_ICON,		MACRO_PICTURE_GPS],
                [_inventory displayCtrl MACRO_IDC_RADIO_FRAME, 			_inventory displayCtrl MACRO_IDC_RADIO_ICON,		MACRO_PICTURE_RADIO],
                [_inventory displayCtrl MACRO_IDC_COMPASS_FRAME, 		_inventory displayCtrl MACRO_IDC_COMPASS_ICON,		MACRO_PICTURE_COMPASS],
                [_inventory displayCtrl MACRO_IDC_WATCH_FRAME,	 		_inventory displayCtrl MACRO_IDC_WATCH_ICON,		MACRO_PICTURE_WATCH]
        ];
};
