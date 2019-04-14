// Update the weapons menu
case "ui_update_weapons": {
	_eventExists = true;

	// Fetch the player's container data
	private _containerData = player getVariable [MACRO_VARNAME_DATA, locationNull];

	// Fetch the weapons data list (used to determine which control(s) need updating)
	private _weaponsItemDatas = _inventory getVariable [MACRO_VARNAME_UI_WEAPONS_ITEMDATAS, []];

	// Fetch some inventory data
	private _weaponsCtrlGrp = _inventory displayCtrl MACRO_IDC_WEAPONS_CTRLGRP;
	private _forbiddenCtrls = _inventory getVariable [MACRO_VARNAME_UI_FORBIDDENCONTROLS, []];

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

			// Fetch the old frame's data
			private _pos = ctrlPosition _ctrlFrame;
			private _IDC = ctrlIDC _ctrlFrame;
			private _isForbiddenControl = (_forbiddenCtrls findIf {_x == _ctrlFrame});

			// Delete the old frame control and all of its child controls
			{
				ctrlDelete _x;
			} forEach (_ctrlFrame getVariable [MACRO_VARNAME_UI_CHILDCONTROLS, []]);
			ctrlDelete (_ctrlFrame getVariable [MACRO_VARNAME_UI_ICONTEMP, controlNull]);
			ctrlDelete _ctrlFrame;

			// Create the new frame control
			_ctrlFrame = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedFrame", _IDC, _weaponsCtrlGrp];
			_ctrlFrame ctrlSetPosition _pos;
			_ctrlFrame ctrlCommit 0;
			_ctrlFrame ctrlSetPixelPrecision 2;
			if (_isForbiddenControl >= 0) then {
				_forbiddenCtrls set [_isForbiddenControl, _ctrlFrame];
			};

			// Only continue if we have this item
			if (!isNull _itemData) then {

				// Save the item data to the list
				_weaponsItemDatas set [_forEachIndex, _itemData];

				// Fetch some info from the item data
				_class = _itemData getVariable [MACRO_VARNAME_CLASS, ""];
				_category = [_class] call cre_fnc_cfg_getClassCategory;
				_slotSize = [_class, _category] call cre_fnc_cfg_getClassSlotSize;

				// Mark the slot as active and save some info on the control
				_ctrlFrame setVariable ["active", true];
				_ctrlFrame setVariable [MACRO_VARNAME_CLASS, _class];
				_ctrlFrame setVariable [MACRO_VARNAME_DATA, _itemData];
				_ctrlFrame setVariable [MACRO_VARNAME_SLOTSIZE, _slotSize];

			// If the slot is empty, mark the slot as inactive
			} else {
				_ctrlFrame ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);

				_ctrlFrame setVariable ["active", false];
				_ctrlFrame setVariable [MACRO_VARNAME_CLASS, ""];
				_ctrlFrame setVariable [MACRO_VARNAME_DATA, locationNull];
			};

			// Set the frame's control based on what we're dragging
			if (_isForbiddenControl > 0) then {
				_ctrlFrame ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_DRAGGING_RED);
			} else {
				if (isNull _itemData) then {
					_ctrlFrame ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);
				} else {
					_ctrlFrame ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);
				};
			};

			// TODO: Recreate the slot controls instead of repopulating them, so that the ui_dragging_abort event fires automatically
/*
			// If the slot is being dragged, cancel the dragging
			if (_ctrlFrame getVariable [MACRO_VARNAME_UI_ISBEINGDRAGGED, false]) then {
				["ui_dragging_abort"] call cre_fnc_ui_inventory;
			};

			// Delete the old child controls
			{
				ctrlDelete _x;
			} forEach (_ctrlFrame getVariable [MACRO_VARNAME_UI_CHILDCONTROLS, []]);
*/

			// Generate new child controls
			[_ctrlFrame, _class, _category, _defaultIconPath] call cre_fnc_ui_generateChildControls;
		};

		// Add some event handlers for mouse entering/exiting the controls, and moving across it
		if !(_ctrlFrame getVariable [MACRO_VARNAME_UI_CTRL_HAS_EHS, false]) then {
			_ctrlFrame setVariable [MACRO_VARNAME_UI_CTRL_HAS_EHS, true];
			_ctrlFrame ctrlAddEventHandler ["MouseExit", {["ui_mouse_exit", _this] call cre_fnc_ui_inventory}];
			_ctrlFrame ctrlAddEventHandler ["MouseMoving", {["ui_mouse_moving", _this] call cre_fnc_ui_inventory}];
			_ctrlFrame ctrlAddEventHandler ["MouseButtonDown", {["ui_dragging_init", _this] call cre_fnc_ui_inventory}];
		};

		// Save the slot's default icon path and slot position
		_ctrlFrame setVariable [MACRO_VARNAME_UI_DEFAULTICONPATH, _defaultIconPath];
		_ctrlFrame setVariable [MACRO_VARNAME_SLOTPOS, _slotPos];
		_ctrlFrame setVariable [MACRO_VARNAME_PARENTDATA, _containerData];

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
	_inventory getVariable [MACRO_VARNAME_UI_FORBIDDENCONTROLS, _forbiddenCtrls];
};
