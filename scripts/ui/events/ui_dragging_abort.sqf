// Start dragging
case "ui_dragging_abort": {
	_eventExists = true;

	// Remove the event handlers
	_inventory displayRemoveEventHandler ["KeyDown", _inventory getVariable [MACRO_VARNAME_UI_EH_KEYDOWN, -1]];
	_inventory displayRemoveEventHandler ["MouseButtonDown", _inventory getVariable [MACRO_VARNAME_UI_EH_MOUSEBUTTONDOWN, -1]];
	_inventory displayRemoveAllEventHandlers "MouseMoving";



	// Reset the focus
	["ui_focus_reset", [_draggedCtrl]] call cre_fnc_ui_inventory;

	// Delete the control and its child controls
	[_inventory getVariable [MACRO_VARNAME_UI_FRAMETEMP, controlNull]] call cre_fnc_ui_deleteSlotCtrl;

	// Fetch the dragged control and the drop control
	private _draggedCtrl = _inventory getVariable [MACRO_VARNAME_UI_DRAGGEDCTRL, controlNull];
	private _ctrlDrop = _inventory displayCtrl MACRO_IDC_GROUND_DROP_FRAME;

	// Restore the original colour on the highlighted controls (copied from ui_mouse_exit)
	{
		// If the current control is the drop control, make it invisible
		if (_x == _ctrlDrop) then {
			_x ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_INVISIBLE);

		// Otherwise, apply the usual behaviour
		} else {
			if (!isNull (_x getVariable [MACRO_VARNAME_DATA, locationNull]) and {_x != _draggedCtrl}) then {
				_x ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);
			} else {
				_x ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);
			};
		};
	} forEach (_inventory getVariable [MACRO_VARNAME_UI_HIGHLITCONTROLS, []]);
	_inventory setVariable [MACRO_VARNAME_UI_HIGHLITCONTROLS, []];

	// Reset the allowed and forbidden controls
	private _allowedCtrls = _inventory getVariable [MACRO_VARNAME_UI_ALLOWEDCONTROLS, []];
	private _forbiddenCtrls = _inventory getVariable [MACRO_VARNAME_UI_FORBIDDENCONTROLS, []];
	{
		if (isNull (_x getVariable [MACRO_VARNAME_DATA, locationNull])) then {
			_x ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);
		} else {
			_x ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);
		};
	} forEach (_allowedCtrls + _forbiddenCtrls);
	_inventory setVariable [MACRO_VARNAME_UI_ALLOWEDCONTROLS, []];
	_inventory setVariable [MACRO_VARNAME_UI_FORBIDDENCONTROLS, []];

	// Reset the cursor variables
	_inventory setVariable [MACRO_VARNAME_UI_CURSORCTRL, controlNull];
	_inventory setVariable [MACRO_VARNAME_UI_CURSORPOSNEW, []];



	// Only continue if the control still exists
	if (!isNull _draggedCtrl) then {

		// Fetch the control's item class and its associated size
		private _itemData = _draggedCtrl getVariable [MACRO_VARNAME_DATA, locationNull];
		private _class = _itemData getVariable [MACRO_VARNAME_CLASS, ""];
		private _category = _itemData getVariable [MACRO_VARNAME_CATEGORY, MACRO_ENUM_CATEGORY_INVALID];

		// Mark the control as no longer being dragged
		_draggedCtrl setVariable [MACRO_VARNAME_UI_ISBEINGDRAGGED, false];
		_inventory setVariable [MACRO_VARNAME_UI_DRAGGEDCTRL, controlNull];

		// Reset the colour of the original slot frame
		_draggedCtrl ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);

		// Delete the temporary slot picture
		ctrlDelete (_inventory getVariable [MACRO_VARNAME_UI_ICONTEMP, controlNull]);

		// Unhide the original control's child controls
		{
			_x ctrlShow true;
		} forEach (_draggedCtrl getVariable [MACRO_VARNAME_UI_CHILDCONTROLS, []]);

		// If the dragged control was a dropped item, unhide its frame control
		if (typeOf (_itemData getVariable [MACRO_VARNAME_PARENT, objNull]) in MACRO_CLASSES_GROUNDHOLDERS) then {
			_draggedCtrl ctrlShow true;

		// Otherwise, determine whether the dragged control should be unhidden
		} else {
			private _containerCtrl = _draggedCtrl getVariable [MACRO_VARNAME_UI_CTRLPARENT, controlNull];
			if (!isNull _containerCtrl and {_draggedCtrl != _containerCtrl}) then {

				// Rehide all occupied slot controls...
				{
					private _slot = _containerCtrl getVariable [format [MACRO_VARNAME_SLOT_X_Y, _x select 0, _x select 1], controlNull];
					_slot ctrlShow false;
				} forEach (_itemData getVariable [MACRO_VARNAME_OCCUPIEDSLOTS, []]);

				// ...except for the slot's frame control
				_draggedCtrl ctrlShow true;

				// Fetch some additional data
				private _safeZoneW = uiNamespace getVariable ["Cre8ive_Inventory_SafeZoneW", 0];
				private _safeZoneH = uiNamespace getVariable ["Cre8ive_Inventory_SafeZoneH", 0];
				([_class, _category] call cre_fnc_cfg_getClassSlotSize) params ["_slotWidth", "_slotHeight"];
				private _posCtrl = ctrlPosition _draggedCtrl;

				// If the item is rotated, flip the width and height
				private _isRotated = _draggedCtrl getVariable [MACRO_VARNAME_ISROTATED, false];
				if (_isRotated) then {
					private _widthTemp = _slotWidth;
					_slotWidth = _slotHeight;
					_slotHeight = _widthTemp;
				};

				// Rescale the control
				_posCtrl set [2, _slotWidth * _safeZoneW * MACRO_SCALE_SLOT_SIZE_W];
				_posCtrl set [3, _slotHeight * _safeZoneH * MACRO_SCALE_SLOT_SIZE_H];
				MACRO_FNC_UI_CTRL_SETPOSITION(_draggedCtrl, _posCtrl, 0);
			};
		};
	};
};
