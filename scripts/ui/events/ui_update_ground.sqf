// Update the ground menu
case "ui_update_ground": {
	_eventExists = true;

	// Fetch the inventory's ground controls group
	private _groundCtrlGrp = _inventory displayCtrl MACRO_IDC_GROUND_CTRLGRP;

	// Fetch the drop control
	private _ctrlDrop = _groundCtrlGrp controlsGroupCtrl MACRO_IDC_GROUND_DROP_FRAME;

	// Add some event handlers for mouse moving across the drop control, and exiting it
	if !(_ctrlDrop getVariable [MACRO_VARNAME_UI_CTRL_HAS_EHS, false]) then {
		_ctrlDrop ctrlAddEventHandler ["MouseExit", {["ui_mouse_exit", _this] call cre_fnc_ui_inventory}];
		_ctrlDrop ctrlAddEventHandler ["MouseMoving", {["ui_mouse_moving", _this] call cre_fnc_ui_inventory}];
		_ctrlDrop ctrlAddEventHandler ["MouseButtonDown", {["ui_focus_reset", _this] call cre_fnc_ui_inventory}];

		// Set up the control's slot position
		_ctrlDrop setVariable [MACRO_VARNAME_SLOTPOS, [MACRO_ENUM_SLOTPOS_DROP, MACRO_ENUM_SLOTPOS_INVALID]];
		_ctrlDrop setVariable [MACRO_VARNAME_UI_CTRL_HAS_EHS, true];
	};

	// Determine some UI variables
	private _safeZoneW = uiNamespace getVariable ["Cre8ive_Inventory_SafeZoneW", 0];
	private _safeZoneH = uiNamespace getVariable ["Cre8ive_Inventory_SafeZoneH", 0];
	private _slotSizeW = _safeZoneW * MACRO_SCALE_SLOT_SIZE_W;
	private _slotSizeH = _safeZoneH * MACRO_SCALE_SLOT_SIZE_H;
	private _posX = 0;
	private _posY = 0;
	private _distMaxSqr = MACRO_GROUND_MAX_DISTANCE ^ 2;







	// Fetch the list of ground containers and container controls
	private _namespace = _inventory getVariable [MACRO_VARNAME_UI_GROUND_NAMESPACE, locationNull];

	if (isNull _namespace) then {
		_namespace = createLocation ["NameVillage", [0,0,0], 0, 0];
	};



	// Filter out old ground holders that are too far
	private _groundHolderCtrls = _namespace getVariable [MACRO_VARNAME_UI_GROUND_CTRLS, []];
	for "_i" from (count _groundHolderCtrls) - 1 to 0 step -1 do {
		private _slotFrame = _groundHolderCtrls param [_i, controlNull];
		private _container = _slotFrame getVariable [MACRO_VARNAME_CONTAINER, objNull];

		// If this container is too far away, delete it from the list
		if (player distanceSqr _container > _distMaxSqr) then {
			_groundHolderCtrls deleteAt _i;

			if (!isNUll _container) then {
				private _containerData = _container getVariable [MACRO_VARNAME_DATA, locationNull];
				private _UID = _containerData getVariable [MACRO_VARNAME_UID, ""];

				// Blank out the entry in the namespace
				_namespace setVariable [_UID, controlNull];
				systemChat format ["Removed %1", _UID];
			} else {
				systemChat format ["Removed an unknown container (at %1)", _i];
			};

			// Also delete the associated slot frame and its child controls
			{
				ctrlDelete _x;
			} forEach (_slotFrame getVariable [MACRO_VARNAME_UI_CHILDCONTROLS, []]);
			ctrlDelete (_slotFrame getVariable [MACRO_VARNAME_UI_ICONTEMP, controlNull]);
			ctrlDelete _slotFrame;
		};
	};

	// Look for new ground holders
	{
		{
			private _container = _x;
			if (player distanceSqr _container <= _distMaxSqr) then {

				// If the object doesn't have any container data (yet), create it
				private _containerData = _container getVariable [MACRO_VARNAME_DATA, locationNull];
				if (isNull _containerData) then {
					_containerData = [_container] call cre_fnc_inv_generateContainerData;
				};

				// Fetch the UID
				private _UID = _containerData getVariable [MACRO_VARNAME_UID, ""];

				// If this ground holder isn't in our list yet, add it
				if (isNull (_namespace getVariable [_UID, controlNull])) then {

					// Fetch the item data of the first item inside of it
					private _itemData = _containerData getVariable [format [MACRO_VARNAME_SLOT_X_Y, 1, 1], locationNull];

					if (!isNull _itemData) then {
						private _class = _itemData getVariable [MACRO_VARNAME_CLASS, ""];
						private _category = [_class] call cre_fnc_cfg_getClassCategory;
						private _slotSize = [_class, _category] call cre_fnc_cfg_getClassSlotSize;

						// Create controls for the item
						private _slotFrame = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedFrame", -1, _groundCtrlGrp];
						_slotFrame ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);

						// Set the frame's pixel precision mode to off, disables rounding
						_slotFrame ctrlSetPixelPrecision 2;

						// Move the slot controls
						_slotFrame ctrlSetPosition  [
							_posX * _slotSizeW,
							_posY * _slotSizeH,
							_slotSizeW * (_slotSize select 0),
							_slotSizeH * (_slotSize select 1)
						];
						_slotFrame ctrlCommit 0;

						// Increase the position (TODO: Apply a sorting system for ground items)
						_posY = _posY + (_slotSize select 1);

						// Add some event handlers to the slot controls
						_slotFrame ctrlAddEventHandler ["MouseExit", {["ui_mouse_exit", _this] call cre_fnc_ui_inventory}];
						_slotFrame ctrlAddEventHandler ["MouseMoving", {["ui_mouse_moving", _this] call cre_fnc_ui_inventory}];
						_slotFrame ctrlAddEventHandler ["MouseButtonDown", {["ui_dragging_init", _this] call cre_fnc_ui_inventory}];

						// Save some data onto the slot
						_slotFrame setVariable ["active", true];
						_slotFrame setVariable [MACRO_VARNAME_CLASS, _class];
						_slotFrame setVariable [MACRO_VARNAME_DATA, _itemData];
						_slotFrame setVariable [MACRO_VARNAME_SLOTPOS, [_posX, _posY]];
						_slotFrame setVariable [MACRO_VARNAME_CONTAINER, _container];
						_slotFrame setVariable [MACRO_VARNAME_SLOTSIZE, _slotSize];

						// Generate the child controls
						[_slotFrame, _class, _category] call cre_fnc_ui_generateChildControls;

						// Save the slot control onto the namespace
						_namespace setVariable [_UID, _slotFrame];
						_groundHolderCtrls pushBack _slotFrame;
						systemChat format ["Added %1", _UID];
					};
				};
			};
		} forEach (player nearObjects [_x, MACRO_GROUND_MAX_DISTANCE + 5]);
	} forEach MACRO_CLASSES_GROUNDHOLDERS;
	_namespace setVariable [MACRO_VARNAME_UI_GROUND_CTRLS, _groundHolderCtrls];




	// Save the namespace onto the inventory
	_inventory setVariable [MACRO_VARNAME_UI_GROUND_NAMESPACE, _namespace];
};
