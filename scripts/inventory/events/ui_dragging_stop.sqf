// Stop dragging
case "ui_dragging_stop": {
	_eventExists = true;

	// Fetch the control
	private _draggedCtrl = _inventory getVariable [MACRO_VARNAME_UI_DRAGGEDCTRL, controlNull];

	// Only continue if the control still exists and isn't already being dragged
	if (!isNull _draggedCtrl) then {

		// Reset the focus (NOTE: scheduled environment, because it needs to execute *after* the MouseDown event
		["ui_focus_reset", [_draggedCtrl]] spawn cre_fnc_inventory;

		private _cursorCtrl = _inventory getVariable [MACRO_VARNAME_UI_CURSORCTRL, controlNull];
		private _slotPos = _inventory getVariable [MACRO_VARNAME_UI_CURSORPOSNEW, [0,0]];
		private _slotSize = _draggedCtrl getVariable [MACRO_VARNAME_SLOTSIZE, [1,1]];
		private _itemData = _draggedCtrl getVariable [MACRO_VARNAME_DATA, locationNull];
		private _containerCtrl = _ctrl getVariable [MACRO_VARNAME_UI_CTRLPARENT, controlNull];
		private _containerData = _cursorCtrl getVariable [MACRO_VARNAME_PARENT, locationNull];

		// Try to fit the item on the slot
		([_itemData, _containerData, _slotPos, _slotSize] call cre_fnc_canFitItem) params ["_canFit"];
		//systemChat format ["(%1) - pos: %2 - size: %3 - canFit: %4", time, _slotPos, _slotSize, _canFit];

		// If the item can fit there, move it
		if (_canFit) then {

			// Fetch the item's occupied slot(s)
			private _slotPosOld = _itemData getVariable [MACRO_VARNAME_SLOTPOS, []];
			private _occupiedSlots = _itemData getVariable [MACRO_VARNAME_OCCUPIEDSLOTS, []];

			// If the position is an array, the item might have multiple occupied slots
			if (_slotPosOld isEqualType []) then {

				// First, we reset the occupied slots on the container
				{
					_containerData setVariable [format [MACRO_VARNAME_SLOT_X_Y, _x select 0, _x select 1], locationNull];
				} forEach _occupiedSlots;
				_occupiedSlots = [];

				// Next, we check where the item has gone
				// If the new position is an array, then it must be going into a container
				if (_slotPos isEqualType []) then {

					// Determine the new list of slots at the new position
					_slotPos params ["_slotPosX", "_slotPosY"];
					for "_posY" from _slotPosY to (_slotPosY + (_slotSize select 1) - 1) do {
						for "_posX" from _slotPosX to (_slotPosX + (_slotSize select 0) - 1) do {
							_occupiedSlots pushBack [_posX, _posY];

							// Link the container's slot at this position towards the item
							_containerData setVariable [format [MACRO_VARNAME_SLOT_X_Y, _posX, _posY], _itemData];
						};
					};

				// Otherwise, the item must be going into a reserved slot
				} else {
					_containerData setVariable [_slotPos, _itemData];
				};

				// Finally, update the item's occupied slots and its slot position
				_itemData setVariable [MACRO_VARNAME_OCCUPIEDSLOTS, _occupiedSlots];
				_itemData setVariable [MACRO_VARNAME_SLOTPOS, _slotPos];

			// Otherwise, the slot position variable is just the varname for the item's slot
			} else {

				// Reset the item data at the given slot
				_containerData setVariable [_slotPosOld, locationNull];
			};
		};

		// If the control is a slot, handle the hidden slot controls
		if (!isNull _containerCtrl and {_ctrl != _containerCtrl}) then {

			// Rehide the hidden slot controls
			{
				_x ctrlShow false;
			} forEach (_inventory getVariable [MACRO_VARNAME_UI_HIDDENSLOTCONTROLS, []]);
			_inventory setVariable [MACRO_VARNAME_UI_HIDDENSLOTCONTROLS, []];

			// Rescale the control
			_posCtrl set [2, (_slotSize select 0) * _safeZoneW * MACRO_SCALE_SLOT_SIZE_W];
			_posCtrl set [3, (_slotSize select 1) * _safeZoneH * MACRO_SCALE_SLOT_SIZE_H];
			_ctrl ctrlSetPosition _posCtrl;
			_ctrl ctrlCommit 0;
		};
	};
};
