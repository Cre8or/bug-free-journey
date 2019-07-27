// Stop dragging
case "ui_dragging_stop": {
	_eventExists = true;

	// Fetch the control
	private _draggedCtrl = _inventory getVariable [MACRO_VARNAME_UI_DRAGGEDCTRL, controlNull];

	// Only continue if the control still exists and isn't already being dragged
	if (!isNull _draggedCtrl) then {
		private _canMoveItem = false;

		// Reset the focus (NOTE: scheduled environment, because it needs to execute *after* the MouseDown event
		["ui_focus_reset", [_draggedCtrl]] spawn cre_fnc_ui_inventory;

		private _slotPos = _inventory getVariable [MACRO_VARNAME_UI_CURSORPOSNEW, []];
		private _slotSize = +(_draggedCtrl getVariable [MACRO_VARNAME_SLOTSIZE, [1,1]]);
		private _itemData = _draggedCtrl getVariable [MACRO_VARNAME_DATA, locationNull];
		private _originContainer = _itemData getVariable [MACRO_VARNAME_PARENT, objNull];
		private _originContainerData = _itemData getVariable [MACRO_VARNAME_PARENTDATA, locationNull];

		private _cursorCtrl = _inventory getVariable [MACRO_VARNAME_UI_CURSORCTRL, controlNull];
		private _targetContainer = objNull;
		private _targetContainerData = _cursorCtrl getVariable [MACRO_VARNAME_PARENTDATA, locationNull];
		private _targetContainerCtrl = _cursorCtrl getVariable [MACRO_VARNAME_UI_CTRLPARENT, _cursorCtrl];	// Fallback for reserved slots that don't have a container control

		// If the control is rotated, flip the width and height
		private _ctrlFrameTemp = _inventory getVariable [MACRO_VARNAME_UI_FRAMETEMP, controlNull];
		private _isRotated = _ctrlFrameTemp getVariable [MACRO_VARNAME_ISROTATED, false];
		if (_isRotated) then {
			private _widthTemp = _slotSize select 0;
			_slotSize set [0, _slotSize select 1];
			_slotSize set [1, _widthTemp];
		};

		// If the item is going into a drop slot, skip the canFit checks
		_slotPos params ["_slotPosX", "_slotPosY"];
		if (_slotPosX == MACRO_ENUM_SLOTPOS_DROP) then {
			_canMoveItem = true;

			// Create the ground weapon holder for the dropped item
			private _targetContainerClass = MACRO_CLASSES_GROUNDHOLDERS select 0;
			_targetContainer = _targetContainerClass createVehicle (getPosATL player);
			_targetContainer setPosASL getPosASL player;
			_targetContainer setDir random 360;
			player reveal _targetContainer;

			// Generate the container data *manually*
			_targetContainerData = (call cre_fnc_inv_createNamespace) select 0;

			// Set up some other variables
			_targetContainerData setVariable [MACRO_VARNAME_CLASS, _targetContainerClass];
			_targetContainerData setVariable [MACRO_VARNAME_CONFIGTYPE, MACRO_ENUM_CONFIGTYPE_CFGVEHICLES];
			_targetContainerData setVariable [MACRO_VARNAME_CATEGORY, [_targetContainerClass, MACRO_ENUM_CONFIGTYPE_CFGVEHICLES] call cre_fnc_cfg_getClassCategory];

			_targetContainerData setVariable [MACRO_VARNAME_CONTAINERSIZE, _slotSize];
			_targetContainerData setVariable [MACRO_VARNAME_CONTAINERSLOTSONLASTY, _slotSize param [0, 0]];

			// Link the container and its data together
			_targetContainerData setVariable [MACRO_VARNAME_CONTAINER, _targetContainer];
			_targetContainer setVariable [MACRO_VARNAME_DATA, _targetContainerData, false];

			// Nullify the target control, as we don't handle drawing ground/dropped items here
			_targetContainerCtrl = controlNull;

			// If the item wasn't already dropped...
			if !(typeOf _originContainer in MACRO_CLASSES_GROUNDHOLDERS) then {
				// Raise the "Drop" event
				private _eventArgs = [_itemData, player, _originContainer, _originContainerData, _targetContainer, _targetContainerData, _itemData getVariable [MACRO_VARNAME_SLOTPOS, [0,0]], _slotPos];
				[STR(MACRO_ENUM_EVENT_DROP), _eventArgs] call cre_fnc_IEH_raiseEvent;
			};

		// Otherwise...
		} else {

			// Try to fit the item on the slot
			([_itemData, _targetContainerData, _slotPos, _slotSize] call cre_fnc_inv_canFitItem) params ["_canFit"];
			//systemChat format ["(%1) - origin: %2 - target: %3 - pos: %4 - size: %5 - canFit: %6", time, ctrlIDC (_draggedCtrl getVariable [MACRO_VARNAME_UI_CTRLPARENT, controlNull]), ctrlIDC _targetContainerCtrl, _slotPos, _slotSize, _canFit];

			// If the item can fit there, move it
			if (_canFit) then {
				_canMoveItem = true;

				// Fetch the target container
				_targetContainer = _targetContainerData getVariable [MACRO_VARNAME_CONTAINER, objNull];
			};
		};

		// If the item can be moved without any issues...
		if (_canMoveItem) then {

			// Fetch the item's occupied slot(s)
			private _slotPosOld = _itemData getVariable [MACRO_VARNAME_SLOTPOS, [0,0]];
			private _occupiedSlots = [];

			// Fetch the old slot position
			_slotPosOld params ["_slotPosOldX", "_slotPosOldY"];

			// Fetch the parent container of this item (in case of nested containers, fetch the "top" one)
			private _parentContainerData = _originContainerData;
			while {!isNull (_parentContainerData getVariable [MACRO_VARNAME_PARENTDATA, locationNull])} do {
				_parentContainerData = _parentContainerData getVariable [MACRO_VARNAME_PARENTDATA, locationNull];
			};

			// If the item was picked up from the ground (or from the active container), raise the "Take" event
			if ((_inventory getVariable [MACRO_VARNAME_UI_ACTIVECONTAINER, objNull]) == (_parentContainerData getVariable [MACRO_VARNAME_CONTAINER, objNull]) or {(_parentContainerData getVariable [MACRO_VARNAME_CLASS, ""]) in MACRO_CLASSES_GROUNDHOLDERS}) then {
				// ...unless it is being dropped - in that case, don't raise the "Take" event (because we didn't really grab anything)
				if !(typeOf _targetContainer in MACRO_CLASSES_GROUNDHOLDERS) then {
					private _eventArgs = [_itemData, player, _originContainer, _originContainerData, _targetContainer, _targetContainerData, _slotPosOld, _slotPos];
					[STR(MACRO_ENUM_EVENT_TAKE), _eventArgs] call cre_fnc_IEH_raiseEvent;
				};
			};

			// Raise the "Move" event
			private _eventArgs = [_itemData, player, _originContainer, _originContainerData, _targetContainer, _targetContainerData, _slotPosOld, _slotPos];
			[STR(MACRO_ENUM_EVENT_MOVE), _eventArgs] call cre_fnc_IEH_raiseEvent;

			// First, clear the old slot position
			_originContainerData setVariable [format [MACRO_VARNAME_SLOT_X_Y, _slotPosOldX, _slotPosOldY], locationNull];

			// Next, clear the previously occupied slots on the old container
			if (_slotPosOldX > 0) then {
				_occupiedSlots = _itemData getVariable [MACRO_VARNAME_OCCUPIEDSLOTS, []];
				{
					_originContainerData setVariable [format [MACRO_VARNAME_SLOT_X_Y, _x select 0, _x select 1], locationNull];
				} forEach _occupiedSlots;
			};

			// If the X position is negative, the item is going into a reserved slot
			if (_slotPosX < 0) then {

				// If the item is being dropped, set the slot position to [1,1] (required for containers to work)
				if (_slotPosX == MACRO_ENUM_SLOTPOS_DROP) then {
					_slotPos = [1,1];
					_slotPosX = 1;
					_slotPosY = 1;
				};

				// Reset the rotation
				_isRotated = false;

				// Link the container's reserved slot position towards the item
				_targetContainerData setVariable [format [MACRO_VARNAME_SLOT_X_Y, _slotPosX, _slotPosY], _itemData];

			// Otherwise, it's going into a regular container
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

			// Update the item's new occupied slots, position and parent
			_itemData setVariable [MACRO_VARNAME_OCCUPIEDSLOTS, _occupiedSlots];
			_itemData setVariable [MACRO_VARNAME_SLOTPOS, _slotPos];
			_itemData setVariable [MACRO_VARNAME_PARENT, _targetContainer];
			_itemData setVariable [MACRO_VARNAME_PARENTDATA, _targetContainerData];
			_itemData setVariable [MACRO_VARNAME_ISROTATED, _isRotated];

			// Also update the items lists
			_originContainerData setVariable [MACRO_VARNAME_ITEMS, (_originContainerData getVariable [MACRO_VARNAME_ITEMS, []]) - [_itemData]];
			_targetContainerData setVariable [MACRO_VARNAME_ITEMS, (_targetContainerData getVariable [MACRO_VARNAME_ITEMS, []]) + [_itemData]];

			// TODO: Add items lists to the player container data, requires changing storage & weapons

			// Tell the control that it is no longer being dragged
			_draggedCtrl setVariable [MACRO_VARNAME_UI_ISBEINGDRAGGED, false];

			// Move the item across the inventories
			[_itemData, _originContainer, _targetContainer] call cre_fnc_inv_moveItem;

			// Update the inventory UI to reflect the changes
			["ui_item_move", [_draggedCtrl, _slotPos, _targetContainerCtrl, _isRotated]] call cre_fnc_ui_inventory;

			// Update the storage screen, in case we moved a container (uniform, vest, backpack)
			["ui_update_storage"] call cre_fnc_ui_inventory;

			// Remove the event handlers
			_inventory displayRemoveEventHandler ["KeyDown", _inventory getVariable [MACRO_VARNAME_UI_EH_KEYDOWN, -1]];
			_inventory displayRemoveEventHandler ["MouseButtonDown", _inventory getVariable [MACRO_VARNAME_UI_EH_MOUSEBUTTONDOWN, -1]];
			_inventory displayRemoveAllEventHandlers "MouseMoving";

			// Finally, complete the dragging process once the button is released
			_EH = _inventory displayAddEventHandler ["MouseButtonUp", {
				["ui_dragging_complete", _this] call cre_fnc_ui_inventory;
			}];
			_inventory setVariable [MACRO_VARNAME_UI_EH_MOUSEBUTTONUP, _EH];
		};
	};
};
