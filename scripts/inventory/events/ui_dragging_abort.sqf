// Start dragging
case "ui_dragging_abort": {
	_eventExists = true;

	// Fetch the control
	private _ctrl = _inventory getVariable [MACRO_VARNAME_UI_DRAGGEDCTRL, controlNull];

	// Only continue if the control still exists and isn't already being dragged
	if (!isNull _ctrl) then {

		// Reset the focus
		["ui_focus_reset", [_ctrl]] call cre_fnc_inventory;

		// Fetch the control's item class and its associated size
		private _class = _ctrl getVariable [MACRO_VARNAME_CLASS, ""];
		private _category = [_class] call cre_fnc_getClassCategory;
		private _slotSize = [_class, _category] call cre_fnc_getClassSlotSize;
		private _safeZoneW = uiNamespace getVariable ["Cre8ive_Inventory_SafeZoneW", 0];
		private _safeZoneH = uiNamespace getVariable ["Cre8ive_Inventory_SafeZoneH", 0];
		private _posCtrl = ctrlPosition _ctrl;

		// Mark the control as no longer being dragged
		_ctrl setVariable [MACRO_VARNAME_UI_ISBEINGDRAGGED, false];
		_inventory setVariable [MACRO_VARNAME_UI_DRAGGEDCTRL, controlNull];

		// Remove the event handlers
		private _EH = _inventory getVariable [MACRO_VARNAME_UI_EH_MOUSEBUTTONDOWN, -1];
		_inventory displayRemoveEventHandler ["MouseButtonDown", _EH];
		_inventory displayRemoveAllEventHandlers "MouseMoving";

		// Reset the colour of the original slot frame
		_ctrl ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);

		// Delete the temporary slot picture
		ctrlDelete (_ctrl getVariable [MACRO_VARNAME_UI_ICONTEMP, controlNull]);

		// Remove the dragging controls
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

		// Unhide the original control's child controls
		{
			_x ctrlShow true;
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

		// Reset the cursor variables
		_inventory setVariable [MACRO_VARNAME_UI_CURSORCTRL, controlNull];
		_inventory setVariable [MACRO_VARNAME_UI_CURSORPOSNEW, []];
	};
};
