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
		private _ctrl = _x select 0;
		private _defaultIconPath = _x select 1;
		private _args = _x param [2, []];

		private _category = MACRO_ENUM_CATEGORY_EMPTY;
		private _slotSize = [1,1];

		// If the slot has something in it, fetch its data
		if (_class != "") then {
			_category = [_class] call cre_fnc_getClassCategory;
			_slotSize = [_class, _category] call cre_fnc_getClassSlotSize;

			// Change the frame's colour
			_ctrl ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);

			// Mark the slot as active
			_ctrl setVariable ["active", true];
			_ctrl setVariable [MACRO_VARNAME_CLASS, _class];

			// Generate the item data
			(call cre_fnc_inventory_createNamespace) params ["_itemData"];
			_itemData setVariable [MACRO_VARNAME_CLASS, _class];
			_ctrl setVariable [MACRO_VARNAME_DATA, _itemData];

			// If we have a third argument, it's a weapon accessories array
			if !(_args isEqualTo []) then {
				[_itemData, _args] call cre_fnc_generateWeaponAccData;
			};
		};

		// Generate the child controls
		[_ctrl, _class, _category, _slotSize, _defaultIconPath] call cre_fnc_generateChildControls;

		// Save the slot's default icon path
		_ctrl setVariable ["defaultIconPath", _defaultIconPath];

	} forEach [
		[_inventory displayCtrl MACRO_IDC_NVGS_FRAME,			MACRO_PICTURE_NVGS],
		[_inventory displayCtrl MACRO_IDC_HEADGEAR_FRAME,		MACRO_PICTURE_HEADGEAR],
		[_inventory displayCtrl MACRO_IDC_GOGGLES_FRAME,		MACRO_PICTURE_GOGGLES],
		[_inventory displayCtrl MACRO_IDC_BINOCULARS_FRAME, 		MACRO_PICTURE_BINOCULARS],
		[_inventory displayCtrl MACRO_IDC_PRIMARYWEAPON_FRAME, 		MACRO_PICTURE_PRIMARYWEAPON,		[player, 0] call cre_fnc_generateWeaponAccArray],
		[_inventory displayCtrl MACRO_IDC_HANDGUNWEAPON_FRAME,		MACRO_PICTURE_HANDGUNWEAPON,		[player, 1] call cre_fnc_generateWeaponAccArray],
		[_inventory displayCtrl MACRO_IDC_SECONDARYWEAPON_FRAME,	MACRO_PICTURE_SECONDARYWEAPON,		[player, 2] call cre_fnc_generateWeaponAccArray],
		[_inventory displayCtrl MACRO_IDC_MAP_FRAME, 			MACRO_PICTURE_MAP],
		[_inventory displayCtrl MACRO_IDC_GPS_FRAME, 			MACRO_PICTURE_GPS],
		[_inventory displayCtrl MACRO_IDC_RADIO_FRAME, 			MACRO_PICTURE_RADIO],
		[_inventory displayCtrl MACRO_IDC_COMPASS_FRAME, 		MACRO_PICTURE_COMPASS],
		[_inventory displayCtrl MACRO_IDC_WATCH_FRAME,	 		MACRO_PICTURE_WATCH]
	];
};
