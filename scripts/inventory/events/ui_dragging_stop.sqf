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
		private _containerData = _cursorCtrl getVariable [MACRO_VARNAME_PARENT, locationNull];

		// Try to fit the item on the slot
		//private _canFit = [_itemData, _containerData, _slotPos, _slotSize] call cre_fnc_canFitItem;
		//systemChat format ["(%1) - pos: %2 - size: %3 - canFit: %4", time, _slotPos, _slotSize, _canFit];

		([_itemData, _containerData, _slotPos, _slotSize, false] call cre_fnc_canFitItem) params ["_canFit", "_slots"];
		systemChat format ["(%1) - pos: %2 - size: %3 - canFit: %4 - sots: %5", time, _slotPos, _slotSize, _canFit, _slots];


/*
		// If the control is a slot, handle the hidden slot controls
		private _containerCtrl = _ctrl getVariable [MACRO_VARNAME_UI_CTRLPARENT, controlNull];
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
*/
	};
};
