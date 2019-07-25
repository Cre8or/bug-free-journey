// Update the weapons menu
case "ui_update_weapons": {
	_eventExists = true;

	// Fetch the player's container data
	private _containerData = player getVariable [MACRO_VARNAME_DATA, locationNull];

	// Fetch the weapons data list (used to determine which control(s) need updating)
	private _weaponsItemDatas = _inventory getVariable [MACRO_VARNAME_UI_WEAPONS_ITEMDATAS, []];

	// Fetch the weapons controls group
	private _weaponsCtrlGrp = _inventory displayCtrl MACRO_IDC_WEAPONS_CTRLGRP;

	// Determine the icon paths for the items and weapons that we have
	{
		_x params ["_slotPosEnum", "_ctrlFrame", "_defaultIconPath"];
		private _slotPos = [_slotPosEnum, MACRO_ENUM_SLOTPOS_INVALID];
		private _itemData = _containerData getVariable [format [MACRO_VARNAME_SLOT_X_Y, _slotPosEnum, MACRO_ENUM_SLOTPOS_INVALID], locationNull];
		private _itemDataOld = _weaponsItemDatas param [_forEachIndex, locationNull];

		// If the item data has changed, regenerate the control
		if (_itemData != _itemDataOld) then {

			private _class = "";
			private _category = MACRO_ENUM_CATEGORY_EMPTY;
			private _slotSize = [1,1];
			private _isForbiddenControl = false;

			// Delete all of the frame's child controls (but not the control itself)
			[_ctrlFrame, false] call cre_fnc_ui_deleteSlotCtrl;

			// If the slot still contains an item, update the control
			if (!isNull _itemData) then {

				// Save the item data to the list
				_weaponsItemDatas set [_forEachIndex, _itemData];

				// Fetch some info from the item data
				_class = _itemData getVariable [MACRO_VARNAME_CLASS, ""];
				_category = [_class] call cre_fnc_cfg_getClassCategory;
				_slotSize = [_class, _category] call cre_fnc_cfg_getClassSlotSize;

				// Mark the slot as active and save some info on the control
				_ctrlFrame setVariable [MACRO_VARNAME_CLASS, _class];
				_ctrlFrame setVariable [MACRO_VARNAME_DATA, _itemData];
				_ctrlFrame setVariable [MACRO_VARNAME_SLOTSIZE, _slotSize];

				// Raise the "Draw" event
				private _eventArgs = [_itemData, _ctrlFrame, _inventory];
				[STR(MACRO_ENUM_EVENT_DRAW), _eventArgs] call cre_fnc_IEH_raiseEvent;

			// Otherwise, mark the slot as inactive
			} else {
				_ctrlFrame setVariable [MACRO_VARNAME_CLASS, ""];
				_ctrlFrame setVariable [MACRO_VARNAME_DATA, locationNull];

				// Generate child controls for the empty slot (default icon)
				[_ctrlFrame, _defaultIconPath, _inventory] call cre_fnc_ui_drawEmptySlot;
			};

			// Next, if the slot is currently being dragged, cancel the dragging
			if (_ctrlFrame getVariable [MACRO_VARNAME_UI_ISBEINGDRAGGED, false]) then {
				["ui_dragging_abort"] call cre_fnc_ui_inventory;
			} else {
				private _forbiddenCtrls = _inventory getVariable [MACRO_VARNAME_UI_FORBIDDENCONTROLS, []];
				_isForbiddenControl = _ctrlFrame in _forbiddenCtrls;
			};

			// Following that, set the frame's control based on what we're dragging
			if (_isForbiddenControl) then {
				_ctrlFrame ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_DRAGGING_RED);
			} else {
				if (isNull _itemData) then {
					_ctrlFrame ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);
				} else {
					_ctrlFrame ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);
				};
			};
		};

		// Add some event handlers for mouse entering/exiting the controls, and moving across it
		if !(_ctrlFrame getVariable [MACRO_VARNAME_UI_CTRL_HAS_EHS, false]) then {
			_ctrlFrame setVariable [MACRO_VARNAME_UI_CTRL_HAS_EHS, true];
			_ctrlFrame ctrlAddEventHandler ["MouseExit", {["ui_mouse_exit", _this] call cre_fnc_ui_inventory}];
			_ctrlFrame ctrlAddEventHandler ["MouseMoving", {["ui_mouse_moving", _this] call cre_fnc_ui_inventory}];
			_ctrlFrame ctrlAddEventHandler ["MouseButtonDown", {["ui_dragging_init", _this] call cre_fnc_ui_inventory}];

			// Save the slot's default icon path and slot position
			_ctrlFrame setVariable [MACRO_VARNAME_UI_DEFAULTICONPATH, _defaultIconPath];
			_ctrlFrame setVariable [MACRO_VARNAME_SLOTPOS, _slotPos];
			_ctrlFrame setVariable [MACRO_VARNAME_PARENTDATA, _containerData];
		};

	} forEach [	// NOTE: the order below matters! (see cre_fnc_inv_synchroniser)
		[MACRO_ENUM_SLOTPOS_PRIMARYWEAPON,	_inventory displayCtrl MACRO_IDC_PRIMARYWEAPON_FRAME, 		MACRO_PICTURE_PRIMARYWEAPON],
		[MACRO_ENUM_SLOTPOS_HANDGUNWEAPON,	_inventory displayCtrl MACRO_IDC_HANDGUNWEAPON_FRAME,		MACRO_PICTURE_HANDGUNWEAPON],
		[MACRO_ENUM_SLOTPOS_SECONDARYWEAPON,	_inventory displayCtrl MACRO_IDC_SECONDARYWEAPON_FRAME,		MACRO_PICTURE_SECONDARYWEAPON],
		[MACRO_ENUM_SLOTPOS_NVGS,		_inventory displayCtrl MACRO_IDC_NVGS_FRAME,			MACRO_PICTURE_NVGS],
		[MACRO_ENUM_SLOTPOS_HEADGEAR,		_inventory displayCtrl MACRO_IDC_HEADGEAR_FRAME,		MACRO_PICTURE_HEADGEAR],
		[MACRO_ENUM_SLOTPOS_BINOCULARS,		_inventory displayCtrl MACRO_IDC_BINOCULARS_FRAME, 		MACRO_PICTURE_BINOCULARS],
		[MACRO_ENUM_SLOTPOS_GOGGLES,		_inventory displayCtrl MACRO_IDC_GOGGLES_FRAME,			MACRO_PICTURE_GOGGLES],
		[MACRO_ENUM_SLOTPOS_MAP,		_inventory displayCtrl MACRO_IDC_MAP_FRAME, 			MACRO_PICTURE_MAP],
		[MACRO_ENUM_SLOTPOS_GPS,		_inventory displayCtrl MACRO_IDC_GPS_FRAME, 			MACRO_PICTURE_GPS],
		[MACRO_ENUM_SLOTPOS_RADIO,		_inventory displayCtrl MACRO_IDC_RADIO_FRAME, 			MACRO_PICTURE_RADIO],
		[MACRO_ENUM_SLOTPOS_COMPASS,		_inventory displayCtrl MACRO_IDC_COMPASS_FRAME, 		MACRO_PICTURE_COMPASS],
		[MACRO_ENUM_SLOTPOS_WATCH,		_inventory displayCtrl MACRO_IDC_WATCH_FRAME,	 		MACRO_PICTURE_WATCH]
	];

	// Update the weapons item datas list
	_inventory setVariable [MACRO_VARNAME_UI_WEAPONS_ITEMDATAS, _weaponsItemDatas];
};
