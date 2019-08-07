// Update the ground menu
case "ui_update_ground": {
	_eventExists = true;

	// Fetch the inventory's ground controls group
	private _groundCtrlGrp = _inventory displayCtrl MACRO_IDC_GROUND_CTRLGRP;

	// Fetch the drop control
	private _ctrlDrop = _groundCtrlGrp controlsGroupCtrl MACRO_IDC_GROUND_DROP_FRAME;

	// Fetch the container object
	private _activeContainer = _inventory getVariable [MACRO_VARNAME_UI_ACTIVECONTAINER, objNull];
	private _activeContainerData = _activeContainer getVariable [MACRO_VARNAME_DATA, locationNull];

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
	private _startDrawX = _safeZoneW * MACRO_POS_SPACER_X * 2;
	private _startDrawY = _safeZoneH * MACRO_POS_SPACER_Y * 2;
	private _distMaxSqr = MACRO_GROUND_MAX_DISTANCE ^ 2;
	private _doUpdate = false;
	private _eyePos = eyePos player;
	private _inVehicle = !isNull objectParent player;





	// Check if the active container is within range
	if (!isNull _activeContainerData and {[player, _activeContainer] call cre_fnc_inv_canOpenContainer}) then {
		private _containerCtrlGrp = _inventory displayCtrl MACRO_IDC_CONTAINER_CTRLGRP;

		// Rescale the controls group so that the container UI becomes visible
		if !(_inventory getVariable [MACRO_VARNAME_UI_ACTIVECONTAINER_VISIBLE, false]) then {
			_inventory setVariable [MACRO_VARNAME_UI_ACTIVECONTAINER_VISIBLE, true];
			systemChat "Opening container UI";

			// Rescale the ground controls group
			private _pos = ctrlPosition _groundCtrlGrp;
			private _heightNew = _safeZoneH * (MACRO_POS_SEPARATOR_CONTAINER - MACRO_POS_SPACER_Y);
			_pos set [3, _heightNew];
			{
				_x ctrlSetPositionH _heightNew;
				_x ctrlCommit 0;
			} forEach [
				_groundCtrlGrp,
				_inventory displayCtrl MACRO_IDC_GROUND_FRAME
			];

			// Show the container UI
			{
				_x ctrlShow true;
			} forEach [
				_containerCtrlGrp,
				_inventory displayCtrl MACRO_IDC_CONTAINER_FRAME
			];

			// Rescale the drop control inside the ground controls group
			private _highestPosY = _inventory getVariable [MACRO_VARNAME_UI_GROUND_HIGHESTPOSY, 0];
			_ctrlDrop ctrlSetPositionH (_heightNew max ((_highestPosY + MACRO_EMPTY_SLOTS_UNDER_GROUND_ITEMS) * _slotSizeH));
			_ctrlDrop ctrlCommit 0;
		};

	// Otherwise, get rid of the container UI controls group
	} else {
		if (_inventory getVariable [MACRO_VARNAME_UI_ACTIVECONTAINER_VISIBLE, false]) then {
			_inventory setVariable [MACRO_VARNAME_UI_ACTIVECONTAINER_VISIBLE, false];
			systemChat "Closing container UI";

			// Rescale the ground controls group
			{
				_x ctrlSetPositionH _safeZoneH;
				_x ctrlCommit 0;
			} forEach [
				_groundCtrlGrp,
				_inventory displayCtrl MACRO_IDC_GROUND_FRAME
			];

			// Hide the container UI
			private _containerCtrlGrp = _inventory displayCtrl MACRO_IDC_CONTAINER_CTRLGRP;
			{
				_x ctrlShow false;
			} forEach [
				_containerCtrlGrp,
				_inventory displayCtrl MACRO_IDC_CONTAINER_FRAME
			];

			// Rescale the drop control inside the ground controls group
			private _highestPosY = _inventory getVariable [MACRO_VARNAME_UI_GROUND_HIGHESTPOSY, 0];
			_ctrlDrop ctrlSetPositionH (_safeZoneH max ((_highestPosY + MACRO_EMPTY_SLOTS_UNDER_GROUND_ITEMS) * _slotSizeH));
			_ctrlDrop ctrlCommit 0;
		};
	};





	// Fetch the list of ground containers and container controls
	// (Using this namespace, we make sure not to accidentally detect ground items more than once, and subsequently create multiple controls per item)
	private _namespace = _inventory getVariable [MACRO_VARNAME_UI_GROUND_NAMESPACE, locationNull];

	if (isNull _namespace) then {
		_namespace = createLocation ["NameVillage", [0,0,0], 0, 0];
	};

	// Fetch the groundHolder controls
	private _groundHolderCtrls = _namespace getVariable [MACRO_VARNAME_UI_GROUND_CTRLS, []];

	// If a request was made to force updating the ground UI, clear all existing controls (useful for custom item functions that need to update the child controls)
	if (_inventory getVariable [MACRO_VARNAME_UI_FORCEREDRAW_GROUND, false]) then {
		_inventory setVariable [MACRO_VARNAME_UI_FORCEREDRAW_GROUND, false];
		systemChat "Forced a ground UI redraw!";

		{
			// Blank out the UID on the namespace
			private _container = _x getVariable [MACRO_VARNAME_CONTAINER, objNull];
			private _containerData = _container getVariable [MACRO_VARNAME_DATA, locationNull];
			private _UID = _containerData getVariable [MACRO_VARNAME_UID, ""];
			_namespace setVariable [_UID, controlNull];

			// Delete all controls
			[_x] call cre_fnc_ui_deleteSlotCtrl;
		} forEach _groundHolderCtrls;

		// Clear the array
		_groundHolderCtrls = [];
	};

	// If the player is in a vehicle, remove all ground holders from the UI
	if (_inVehicle) then {
		private ["_container", "_containerData", "_UID"];
		{
			_container = _x getVariable [MACRO_VARNAME_CONTAINER, objNull];

			if (!isNull _container) then {
				_containerData = _container getVariable [MACRO_VARNAME_DATA, locationNull];
				_UID = _containerData getVariable [MACRO_VARNAME_UID, ""];
				// Blank out the entry in the namespace
				_namespace setVariable [_UID, controlNull];
			};

			// Also delete the associated slot frame and its child controls
			[_x] call cre_fnc_ui_deleteSlotCtrl;
		} forEach _groundHolderCtrls;

		_doUpdate = true;
		_groundHolderCtrls = [];

	// Otherwise, only filter out the ones that are too far
	} else {
		private ["_slotFrame", "_container", "_containerData", "_UID"];

		for "_i" from (count _groundHolderCtrls) - 1 to 0 step -1 do {
			_slotFrame = _groundHolderCtrls param [_i, controlNull];
			_container = _slotFrame getVariable [MACRO_VARNAME_CONTAINER, objNull];

			// If this container is too far away, delete it from the list
			if (_eyePos distanceSqr getPosASL _container > _distMaxSqr) then {
				_groundHolderCtrls deleteAt _i;

				if (!isNull _container) then {
					_containerData = _container getVariable [MACRO_VARNAME_DATA, locationNull];
					_UID = _containerData getVariable [MACRO_VARNAME_UID, ""];

					// Blank out the entry in the namespace
					_namespace setVariable [_UID, controlNull];
					//systemChat format ["Removed %1", _UID];
				} else {
					//systemChat format ["Removed an unknown container (at %1)", _i];
				};

				// Also delete the associated slot frame and its child controls
				[_slotFrame] call cre_fnc_ui_deleteSlotCtrl;

				_doUpdate = true;
			};
		};
	};

	// Look for new ground holders
	if (!_inVehicle) then {
		{
			{
				private _container = _x;
				if (_eyePos distanceSqr getPosASL _container <= _distMaxSqr) then {

					// If the object doesn't have any container data (yet), create it
					private _containerData = _container getVariable [MACRO_VARNAME_DATA, locationNull];
					if (isNull _containerData) then {
						_containerData = [_container, "", MACRO_ENUM_CONFIGTYPE_CFGVEHICLES] call cre_fnc_inv_generateContainerData;
					};

					// Fetch the UID
					private _UID = _containerData getVariable [MACRO_VARNAME_UID, ""];

					// If this ground holder isn't in our list yet, add it
					if (isNull (_namespace getVariable [_UID, controlNull])) then {

						// Fetch the item data of the first item inside of it
						private _itemData = _containerData getVariable [format [MACRO_VARNAME_SLOT_X_Y, 1, 1], locationNull];

						// If the item data is not null, we passed all tests, so we create the new control
						if (!isNull _itemData) then {
							private _class = _itemData getVariable [MACRO_VARNAME_CLASS, ""];
							private _category = _itemData getVariable [MACRO_VARNAME_CATEGORY, MACRO_ENUM_CATEGORY_INVALID];
							private _slotSize = [_class, _category] call cre_fnc_cfg_getClassSlotSize;

							// Create controls for the item
							private _slotFrame = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedFrame", -1, _groundCtrlGrp];
							_slotFrame ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);

							// Set the frame's pixel precision mode to off, disables rounding
							_slotFrame ctrlSetPixelPrecision MACRO_GLOBAL_PIXELPRECISIONMODE;

							// Resize the slot controls
							_slotFrame ctrlSetPosition  [
								0,
								0,
								_slotSizeW * (_slotSize select 0),
								_slotSizeH * (_slotSize select 1)
							];
							_slotFrame ctrlCommit 0;

							// Add some event handlers to the slot controls
							_slotFrame ctrlAddEventHandler ["MouseExit", {["ui_mouse_exit", _this] call cre_fnc_ui_inventory}];
							_slotFrame ctrlAddEventHandler ["MouseMoving", {["ui_mouse_moving", _this] call cre_fnc_ui_inventory}];
							_slotFrame ctrlAddEventHandler ["MouseButtonDown", {["ui_dragging_init", _this] call cre_fnc_ui_inventory}];

							// Save some data onto the slot
							_slotFrame setVariable [MACRO_VARNAME_CLASS, _class];
							_slotFrame setVariable [MACRO_VARNAME_DATA, _itemData];
							_slotFrame setVariable [MACRO_VARNAME_SLOTPOS, [0,0]];
							_slotFrame setVariable [MACRO_VARNAME_CONTAINER, _container];
							_slotFrame setVariable [MACRO_VARNAME_SLOTSIZE, _slotSize];

							// Raise the "Draw" event
							private _eventArgs = [_itemData, _slotFrame, _inventory];
							[STR(MACRO_ENUM_EVENT_DRAW), _eventArgs] call cre_fnc_IEH_raiseEvent;

							// Calculate the position offsets for the child controls (so they get moved properly)
							{
								_x setVariable [MACRO_VARNAME_UI_OFFSET, ctrlPosition _x];
							} forEach (_slotFrame getVariable [MACRO_VARNAME_UI_CHILDCONTROLS, []]);

							// Save the slot control onto the namespace
							_namespace setVariable [_UID, _slotFrame];
							_groundHolderCtrls pushBack _slotFrame;
							//systemChat format ["Added %1", _UID];

							_doUpdate = true;
						};
					};
				};
			} forEach (player nearObjects [_x, MACRO_GROUND_MAX_DISTANCE + 5]);
		} forEach MACRO_CLASSES_GROUNDHOLDERS;
	};

	// If anything changed in this execution, update the UI
	if (_doUpdate) then {

		// Determine the size of every item
		private _sizeArray = [];
		{
			private _slotSize = _x getVariable [MACRO_VARNAME_SLOTSIZE, [1,1]];
			_sizeArray pushBack ((_slotSize select 0) * (_slotSize select 1));
		} forEach _groundHolderCtrls;

		// Sort the items by order of increasing slot size (and then reverse it
		[_sizeArray, _groundHolderCtrls] call cre_fnc_util_quickSort;
		reverse _groundHolderCtrls;

		// Create a temporary namespace to keep track of the slot positions
		private _namespaceSlots = createLocation ["NameVillage", [0,0,0], 0, 0];

		// Next, we iterate through our controls and see where we can fit them
		private _lastFreeY = 1;
		private _highestPosY = 1;
		{
			scopeName "loopItems";

			private _yHasFreeSlot = false;
			private _slotSize = _x getVariable [MACRO_VARNAME_SLOTSIZE, [1,1]];
			_slotSize params ["_itemWidth", "_itemHeight"];
			_itemWidth = _itemWidth min MACRO_SCALE_SLOT_COUNT_PER_LINE;		// Support items with unreasonable item size (rather than failing and giving up)

			// Iterate through all slot positions till we find one that can fit the item
			for "_posY" from _lastFreeY to 999 do {

				for "_posX" from 1 to MACRO_SCALE_SLOT_COUNT_PER_LINE do {
					scopeName "loopSlots";

					private _slotStr = format [MACRO_VARNAME_SLOT_X_Y, _posX, _posY];

					// If this slot is empty, check if the item can fit in it
					if (_namespaceSlots getVariable [_slotStr, true]) then {

						// Remember the Y position of the first free slot that we found (meaning everything above this Y is full, should optimise the search a little)
						if (!_yhasFreeSlot) then {
							_yhasFreeSlot = true;
							_lastFreeY = _posY;
						};

						// First of all, test if the item even fits in this position
						private _posEndX = _posX + _itemWidth - 1;
						private _posEndY = _posY + _itemHeight - 1;
						if (_posEndX <= MACRO_SCALE_SLOT_COUNT_PER_LINE) then {

							// The dimensions fit, now we check if the required slots are all free
							private _requiredSlotsStrArray = [];
							for "_posItemY" from _posY to _posEndY do {
								for "_posItemX" from _posX to _posEndX do {
									private _requiredSlotStr = format [MACRO_VARNAME_SLOT_X_Y, _posItemX, _posItemY];

									// If the slot is empty, add it to the list
									if (_namespaceSlots getVariable [_requiredSlotStr, true]) then {
										_requiredSlotsStrArray pushBack _requiredSlotStr;

									// Otherwise, abort and look for a new slot
									} else {
										breakTo "loopSlots";
									};
								};
							};

							// If we didn't exit yet, that means the item can fit!
							// Mark the required slots as taken ("available?"" -> false)
							{
								_namespaceSlots setVariable [_x, false];
							} forEach _requiredSlotsStrArray;

							// Determine the new UI position for this control
							private _posCtrlX = _startDrawX + (_posX - 1) * _slotSizeW;
							private _posCtrlY = _startDrawY + (_posY - 1) * _slotSizeH;

							// Move the control to this position
							MACRO_FNC_UI_CTRL_SETPOSITION_XY(_x, _posCtrlX, _posCtrlY, 0);

							// Move the child controls along
							{
								// Fetch the offset
								private _posOffset = _x getVariable [MACRO_VARNAME_UI_OFFSET, [0,0]];

								// Apply the offset
								private _pos = ctrlPosition _x;
								_pos set [0, _posCtrlX + (_posOffset select 0)];
								_pos set [1, _posCtrlY + (_posOffset select 1)];

								MACRO_FNC_UI_CTRL_SETPOSITION(_x, _pos, 0);
							} forEach (_x getVariable [MACRO_VARNAME_UI_CHILDCONTROLS, []]);

							// Save the Y position of the highest slot that was filled
							_highestPosY = _highestPosY max (_posY + _itemHeight - 1);

							// Move on to the next item
							breakTo "loopItems";
						};
					};
				};
			};
		} forEach _groundHolderCtrls;

		// Delete the temporary slots namespace
		deleteLocation _namespaceSlots;

		// Save the new ground controls list onto the namespace
		_namespace setVariable [MACRO_VARNAME_UI_GROUND_CTRLS, _groundHolderCtrls];

		// Rescale the drop control to match the amount of items displayed
		private _heightMin = (ctrlPosition _groundCtrlGrp) select 3;
		_ctrlDrop ctrlSetPositionH (_heightMin max ((_highestPosY + MACRO_EMPTY_SLOTS_UNDER_GROUND_ITEMS) * _slotSizeH));
		_ctrlDrop ctrlCommit 0;

		_inventory setVariable [MACRO_VARNAME_UI_GROUND_HIGHESTPOSY, _highestPosY];
	};

	// Save the namespace onto the inventory
	_inventory setVariable [MACRO_VARNAME_UI_GROUND_NAMESPACE, _namespace];
};
