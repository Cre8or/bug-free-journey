// Stop dragging
case "ui_dragging_stop": {
	_eventExists = true;

	// Fetch the control
	private _draggedCtrl = _inventory getVariable [MACRO_VARNAME_UI_DRAGGEDCTRL, controlNull];

	// Only continue if the control still exists and isn't already being dragged
	if (!isNull _draggedCtrl) then {

		// Reset the focus (NOTE: scheduled environment, because it needs to execute *after* the MouseDown event
		["ui_focus_reset", [_draggedCtrl]] spawn cre_fnc_ui_inventory;

		private _slotPos = _inventory getVariable [MACRO_VARNAME_UI_CURSORPOSNEW, []];
		private _slotSize = _draggedCtrl getVariable [MACRO_VARNAME_SLOTSIZE, [1,1]];
		private _itemData = _draggedCtrl getVariable [MACRO_VARNAME_DATA, locationNull];
		private _originContainerData = _itemData getVariable [MACRO_VARNAME_PARENT, controlNull];

		private _cursorCtrl = _inventory getVariable [MACRO_VARNAME_UI_CURSORCTRL, controlNull];
		private _targetContainerData = _cursorCtrl getVariable [MACRO_VARNAME_PARENT, locationNull];
		private _targetContainerCtrl = _cursorCtrl getVariable [MACRO_VARNAME_UI_CTRLPARENT, _cursorCtrl];	// Fallback for reserved slots that don't have a container control

		// Try to fit the item on the slot
		([_itemData, _targetContainerData, _slotPos, _slotSize] call cre_fnc_inv_canFitItem) params ["_canFit"];
		//systemChat format ["(%1) - origin: %2 - target: %3 - pos: %4 - size: %5 - canFit: %6", time, ctrlIDC (_draggedCtrl getVariable [MACRO_VARNAME_UI_CTRLPARENT, controlNull]), ctrlIDC _targetContainerCtrl, _slotPos, _slotSize, _canFit];

		// If the item can fit there, move it
		if (_canFit) then {

			// Fetch the item's occupied slot(s)
			private _slotPosOld = _itemData getVariable [MACRO_VARNAME_SLOTPOS, [0,0]];
			private _occupiedSlots = [];

			// Fetch the old slot position
			_slotPosOld params ["_slotPosOldX", "_slotPosOldY"];

			// First, clear the old slot position
			_originContainerData setVariable [format [MACRO_VARNAME_SLOT_X_Y, _slotPosOld select 0, _slotPosOld select 1], locationNull];

			// Next, clear the previously occupied slots on the old container
			if (_slotPosOldX > 0) then {
				_occupiedSlots = _itemData getVariable [MACRO_VARNAME_OCCUPIEDSLOTS, []];
				{
					_originContainerData setVariable [format [MACRO_VARNAME_SLOT_X_Y, _x select 0, _x select 1], locationNull];
				} forEach _occupiedSlots;
			};

			// If the X position is negative, the item is going into a reserved slot
			_slotPos params ["_slotPosX", "_slotPosY"];
			if (_slotPosX < 0) then {

				// Link the container's reserved slot position towards the item
				_targetContainerData setVariable [format [MACRO_VARNAME_SLOT_X_Y, _slotPosX, _slotPosY], _itemData];

			// Otherwise, it's going into a regular contianer
			} else {

				// Iterate through the new occupied slots and add them to the list
				_occupiedSlots = [];
				for "_posY" from _slotPosY to (_slotPosY + (_slotSize select 1) - 1) do {
					for "_posX" from _slotPosX to (_slotPosX + (_slotSize select 0) - 1) do {
						_occupiedSlots pushBack [_posX, _posY];

						// Link the container's slot at this position towards the item
						_targetContainerData setVariable [format [MACRO_VARNAME_SLOT_X_Y, _posX, _posY], _itemData];
					};
				};
			};

			// Now, we update the item's new occupied slots, position and parent
			_itemData setVariable [MACRO_VARNAME_OCCUPIEDSLOTS, _occupiedSlots];
			_itemData setVariable [MACRO_VARNAME_SLOTPOS, _slotPos];
			_itemData setVariable [MACRO_VARNAME_PARENT, _targetContainerData];

			// Also update the items lists
			private _itemsOrigin = _originContainerData getVariable [MACRO_VARNAME_ITEMS, []];
			private _itemsTarget = _targetContainerData getVariable [MACRO_VARNAME_ITEMS, []];
			_itemsOrigin deleteAt (_itemsOrigin findIf {_x == _itemData});
			_itemsTarget pushBack _itemData;
			// TODO: Add items lists to the player container data, requires changing storage & weapons

			// Tell the control that it is no longer being dragged
			_draggedCtrl setVariable [MACRO_VARNAME_UI_ISBEINGDRAGGED, false];

			// Update the inventory UI to reflect the changes
			["ui_item_move", [_draggedCtrl, _slotPos, _targetContainerCtrl]] call cre_fnc_ui_inventory;

			// Finally, complete the dragging process once the button is released
			private _EH = _inventory displayAddEventHandler ["MouseButtonUp", {
				["ui_dragging_complete", _this] call cre_fnc_ui_inventory;
			}];
			_inventory setVariable [MACRO_VARNAME_UI_EH_MOUSEBUTTONUP, _EH];
		};
	};
};
