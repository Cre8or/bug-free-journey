// Move an item from one slot to another (only visually! Item/container data does NOT get changed here!)
case "ui_item_move": {
	_eventExists = true;

	// Fetch the parameters
	_args params [
		["_ctrl", controlNull, [controlNull]],
		["_slotPos", [MACRO_ENUM_SLOTPOS_INVALID, MACRO_ENUM_SLOTPOS_INVALID], [[]]],
		["_targetContainerCtrl", controlNull, [controlNull]]
	];

	// Check if the control exists
	if (!isNull _ctrl) then {

		// Fetch the control's item class and its associated size
		private _class = _ctrl getVariable [MACRO_VARNAME_CLASS, ""];
		private _category = [_class] call cre_fnc_cfg_getClassCategory;
		private _slotSize = [_class, _category] call cre_fnc_cfg_getClassSlotSize;

		// Remove the event handlers
		private _EH = _inventory getVariable [MACRO_VARNAME_UI_EH_MOUSEBUTTONDOWN, -1];
		_inventory displayRemoveEventHandler ["MouseButtonDown", _EH];
		_inventory displayRemoveAllEventHandlers "MouseMoving";

		// Reset the colour of the original slot frame
		_ctrl ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);

		// Delete the temporary slot picture
		ctrlDelete (_ctrl getVariable [MACRO_VARNAME_UI_ICONTEMP, controlNull]);

		// Remove the temporary dragging controls
		private _ctrlFrameTemp = _ctrl getVariable [MACRO_VARNAME_UI_FRAMETEMP, controlNull];
		{
			ctrlDelete _x;
		} forEach (_ctrlFrameTemp getVariable [MACRO_VARNAME_UI_CHILDCONTROLS, []]);
		ctrlDelete _ctrlFrameTemp;

		// Restore the original colour on the highlighted controls
		{
			if (_x getVariable ["active", false]) then {
				_x ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);
			} else {
				_x ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);
			};
		} forEach (_inventory getVariable [MACRO_VARNAME_UI_HIGHLITCONTROLS, []]);
		_inventory setVariable [MACRO_VARNAME_UI_HIGHLITCONTROLS, []];

		// Delete the original control's child controls
		{
			ctrlDelete _x;
		} forEach (_ctrl getVariable [MACRO_VARNAME_UI_CHILDCONTROLS, []]);

		// Reset the allowed and forbidden controls
		private _allowedCtrls = _inventory getVariable [MACRO_VARNAME_UI_ALLOWEDCONTROLS, []];
		private _forbiddenCtrls = _inventory getVariable [MACRO_VARNAME_UI_FORBIDDENCONTROLS, []];
		{
			if (_x getVariable ["active", false]) then {
				_x ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);
			} else {
				_x ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);
			};
		} forEach (_allowedCtrls + _forbiddenCtrls);
		_inventory setVariable [MACRO_VARNAME_UI_ALLOWEDCONTROLS, []];
		_inventory setVariable [MACRO_VARNAME_UI_FORBIDDENCONTROLS, []];

		// Fetch the target slot (or the target control itself if it doesn't have a container control)
		_slotPos params ["_slotPosX", "_slotPosY"];
		private _targetCtrl = _targetContainerCtrl getVariable [format [MACRO_VARNAME_SLOT_X_Y, _slotPos select 0, _slotPos select 1], _targetContainerCtrl];

		// If the target slot is a container slot, handle the required slots and the scaling
		if (_slotPosX > 0) then {

			_slotSize params ["_itemW", "_itemH"];
			private _slotEndX = _slotPosX + _itemW - 1;
			private _slotEndY = _slotPosY + _itemH - 1;

			// Define some variables
			private _occupiedSlots = [];

			// Iterate through the required slots
			private _slots = [];
			for "_y" from _slotPosY to _slotEndY do {
				for "_x" from _slotPosX to _slotEndX do {
					_slots pushBack [_x, _y];
				};
			};
			_slots deleteAt 0;

			// Hide the required slots
			{
				(_targetContainerCtrl getVariable [format [MACRO_VARNAME_SLOT_X_Y, _x select 0, _x select 1], controlNull]) ctrlShow false;
			} forEach _slots;

			// Fetch some additional data
			private _safeZoneW = uiNamespace getVariable ["Cre8ive_Inventory_SafeZoneW", 0];
			private _safeZoneH = uiNamespace getVariable ["Cre8ive_Inventory_SafeZoneH", 0];
			private _posCtrl = ctrlPosition _targetCtrl;

			// Rescale the control
			_posCtrl set [2, _itemW * _safeZoneW * MACRO_SCALE_SLOT_SIZE_W];
			_posCtrl set [3, _itemH * _safeZoneH * MACRO_SCALE_SLOT_SIZE_H];
			_targetCtrl ctrlSetPosition _posCtrl;
			_targetCtrl ctrlCommit 0;
		};

		// Reset the old slot data
		private _itemData = _ctrl getVariable [MACRO_VARNAME_DATA, locationNull];
		_ctrl setVariable ["active", false];
		_ctrl setVariable [MACRO_VARNAME_CLASS, ""];
		_ctrl setVariable [MACRO_VARNAME_DATA, locationNull];
		_ctrl setVariable [MACRO_VARNAME_SLOTSIZE, [1,1]];

		// Fill out the target slot data
		_targetCtrl setVariable ["active", true];
		_targetCtrl setVariable [MACRO_VARNAME_CLASS, _class];
		_targetCtrl setVariable [MACRO_VARNAME_DATA, _itemData];
		_targetCtrl setVariable [MACRO_VARNAME_SLOTSIZE, _slotSize];

		// Set the allowed controls list to only contain the target slot control
		//_inventory setVariable [MACRO_VARNAME_UI_ALLOWEDCONTROLS, [_targetCtrl]];

		// Delete the original target control's child controls
		{
			ctrlDelete _x;
		} forEach (_targetCtrl getVariable [MACRO_VARNAME_UI_CHILDCONTROLS, []]);

		// Create new child controls on the target control
		[_targetCtrl, _class, _category, _targetCtrl getVariable [MACRO_VARNAME_UI_DEFAULTICONPATH, ""]] call cre_fnc_ui_generateChildControls;

		// Create new child controls on the original control (empty slot), provided it is not the same as the target slot
		if (_ctrl != _targetCtrl) then {
			[_ctrl] call cre_fnc_ui_generateChildControls;
		};

		// Paint the controls
		_ctrl ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);
		_targetCtrl ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);

		// Update the cursor variables
		_inventory setVariable [MACRO_VARNAME_UI_CURSORCTRL, _targetCtrl];
		_inventory setVariable [MACRO_VARNAME_UI_CURSORPOSNEW, []];
	};
};