// Update the ground menu
case "ui_update_ground": {
	_eventExists = true;

	// Fetch the drop control
	private _ctrlDrop = _inventory displayCtrl MACRO_IDC_GROUND_DROP_FRAME;

	// Add some event handlers for mouse moving across the drop control, and exiting it
	if !(_ctrlDrop getVariable [MACRO_VARNAME_UI_CTRL_HAS_EHS, false]) then {
		_ctrlDrop ctrlAddEventHandler ["MouseExit", {["ui_mouse_exit", _this] call cre_fnc_ui_inventory}];
		_ctrlDrop ctrlAddEventHandler ["MouseMoving", {["ui_mouse_moving", _this] call cre_fnc_ui_inventory}];

		// Set up the control's slot position
		_ctrlDrop setVariable [MACRO_VARNAME_SLOTPOS, [MACRO_ENUM_SLOTPOS_DROP, MACRO_ENUM_SLOTPOS_INVALID]];
		_ctrlDrop setVariable [MACRO_VARNAME_UI_CTRL_HAS_EHS, true];
	};

	// Valid classnames
	private _types = [
		"Thing",
		"AllVehicles"
	];

	// Look for nearby objects
	private _objs = [];
	{
		// Check if the object is within range
		if (_x distance player <= MACRO_GROUND_MAX_DISTANCE) then {

			scopeName "loop";
			private _obj = _x;
			private _hasInventory = false;

			// If it is, check if it has an inventory
			{
				if (([configFile >> "CfgVehicles" >> typeOf _obj, _x, 0] call BIS_fnc_returnConfigEntry) > 0) then {
					_hasInventory = true;
					breakTo "loop";
				};
			} forEach [
				"transportMaxBackpacks",
				"transportMaxMagazines",
				"transportMaxWeapons"
			];

			// If it does, add it to the list
			if (_hasInventory) then {
				_objs pushBack _x;
			};
		};
	} forEach (player nearEntities [_types, MACRO_GROUND_MAX_DISTANCE + 10]);

	// Look for nearby ground holders
	{
		private _objsNew = player nearObjects [_x, MACRO_GROUND_MAX_DISTANCE + 10];
		{
			if (_x distance player <= MACRO_GROUND_MAX_DISTANCE) then {
				_objs pushBack _x;
			};
		} forEach _objsNew;
	} forEach MACRO_CLASSES_GROUNDHOLDERS;

	//systemChat format ["Found %1 objects: %2", count _objs, _objs];

	// Iterate through the found objects
	{
		private _data = _x getVariable [MACRO_VARNAME_DATA, locationNull];

		// If the object doesn't have any container data (yet), create it
		if (isNull _data) then {
			[_x] call cre_fnc_inv_generateContainerData;
		};
	} forEach _objs;
};
