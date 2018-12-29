// Update the weapons menu
case "ui_update_weapons": {
	_eventExists = true;

	// Fetch the player's container data
	private _containerData = player getVariable [MACRO_VARNAME_DATA, locationNull];

	// Determine the icon paths for the items and weapons that we have
	{
		_x params ["_slotPosEnum", "_ctrlFrame", "_defaultIconPath"];

		private _slotPos = [_slotPosEnum, MACRO_ENUM_SLOTPOS_INVALID];
		private _itemData = _containerData getVariable [format [MACRO_VARNAME_SLOT_X_Y, _slotPosEnum, MACRO_ENUM_SLOTPOS_INVALID], locationNull];
		private _class = "";
		private _category = MACRO_ENUM_CATEGORY_EMPTY;
		private _slotSize = [1,1];

		//systemChat format ["%1: %2 - %3", _forEachIndex, _varName, isNull _itemData];

		// Only continue if we have this item
		if (!isNull _itemData) then {
			_class = _itemData getVariable [MACRO_VARNAME_CLASS, ""];
			_category = [_class] call cre_fnc_cfg_getClassCategory;
			_slotSize = [_class, _category] call cre_fnc_cfg_getClassSlotSize;

			// Change the frame's colour
			_ctrlFrame ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);

			// Mark the slot as active and save some info on the control
			_ctrlFrame setVariable ["active", true];
			_ctrlFrame setVariable [MACRO_VARNAME_CLASS, _class];
			_ctrlFrame setVariable [MACRO_VARNAME_DATA, _itemData];
			_ctrlFrame setVariable [MACRO_VARNAME_SLOTSIZE, _slotSize];
		};

		// Generate the child controls
		[_ctrlFrame, _class, _category, _defaultIconPath] call cre_fnc_ui_generateChildControls;

		// Add some event handlers for mouse entering/exiting the controls, and moving across it
		_ctrlFrame ctrlAddEventHandler ["MouseExit", {["ui_mouse_exit", _this] call cre_fnc_ui_inventory}];
		_ctrlFrame ctrlAddEventHandler ["MouseMoving", {["ui_mouse_moving", _this] call cre_fnc_ui_inventory}];
		_ctrlFrame ctrlAddEventHandler ["MouseButtonDown", {["ui_dragging_init", _this] call cre_fnc_ui_inventory}];

		// Save the slot's default icon path and slot position
		_ctrlFrame setVariable [MACRO_VARNAME_UI_DEFAULTICONPATH, _defaultIconPath];
		_ctrlFrame setVariable [MACRO_VARNAME_SLOTPOS, _slotPos];
		_ctrlFrame setVariable [MACRO_VARNAME_PARENTDATA, _containerData];

	} forEach [
		[MACRO_ENUM_SLOTPOS_NVGS,		_inventory displayCtrl MACRO_IDC_NVGS_FRAME,			MACRO_PICTURE_NVGS],
		[MACRO_ENUM_SLOTPOS_HEADGEAR,		_inventory displayCtrl MACRO_IDC_HEADGEAR_FRAME,		MACRO_PICTURE_HEADGEAR],
		[MACRO_ENUM_SLOTPOS_BINOCULARS,		_inventory displayCtrl MACRO_IDC_BINOCULARS_FRAME, 		MACRO_PICTURE_BINOCULARS],
		[MACRO_ENUM_SLOTPOS_GOGGLES,		_inventory displayCtrl MACRO_IDC_GOGGLES_FRAME,			MACRO_PICTURE_GOGGLES],
		[MACRO_ENUM_SLOTPOS_PRIMARYWEAPON,	_inventory displayCtrl MACRO_IDC_PRIMARYWEAPON_FRAME, 		MACRO_PICTURE_PRIMARYWEAPON],
		[MACRO_ENUM_SLOTPOS_HANDGUNWEAPON,	_inventory displayCtrl MACRO_IDC_HANDGUNWEAPON_FRAME,		MACRO_PICTURE_HANDGUNWEAPON],
		[MACRO_ENUM_SLOTPOS_SECONDARYWEAPON,	_inventory displayCtrl MACRO_IDC_SECONDARYWEAPON_FRAME,		MACRO_PICTURE_SECONDARYWEAPON],
		[MACRO_ENUM_SLOTPOS_MAP,		_inventory displayCtrl MACRO_IDC_MAP_FRAME, 			MACRO_PICTURE_MAP],
		[MACRO_ENUM_SLOTPOS_GPS,		_inventory displayCtrl MACRO_IDC_GPS_FRAME, 			MACRO_PICTURE_GPS],
		[MACRO_ENUM_SLOTPOS_RADIO,		_inventory displayCtrl MACRO_IDC_RADIO_FRAME, 			MACRO_PICTURE_RADIO],
		[MACRO_ENUM_SLOTPOS_COMPASS,		_inventory displayCtrl MACRO_IDC_COMPASS_FRAME, 		MACRO_PICTURE_COMPASS],
		[MACRO_ENUM_SLOTPOS_WATCH,		_inventory displayCtrl MACRO_IDC_WATCH_FRAME,	 		MACRO_PICTURE_WATCH]
	];
};
