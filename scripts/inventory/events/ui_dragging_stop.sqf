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
		private _canFit = [_containerData, _slotPos, _slotSize] call cre_fnc_canFitItem;
		systemChat format ["(%1) - pos: %2 - size: %3 - canFit: %4", time, _slotPos, _slotSize, _canFit];
	};
};
