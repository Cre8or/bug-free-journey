// Load the storage menu
case "ui_update_storage": {
	_eventExists = true;

	// Grab some of our inventory controls
	private _storageCtrlGrp = _inventory displayCtrl MACRO_IDC_STORAGE_CTRLGRP;
	private _ctrlUniformFrame = _storageCtrlGrp controlsGroupCtrl MACRO_IDC_UNIFORM_FRAME;
	private _ctrlVestFrame = _storageCtrlGrp controlsGroupCtrl MACRO_IDC_VEST_FRAME;
	private _ctrlBackpackFrame = _storageCtrlGrp controlsGroupCtrl MACRO_IDC_BACKPACK_FRAME;
	private _ctrlScrollbarDummy = _storageCtrlGrp controlsGroupCtrl MACRO_IDC_SCROLLBAR_DUMMY;

	// Determine our starting positions
	(ctrlPosition _ctrlUniformFrame) params ["_startX", "_startY", "_sizeW", "_sizeY"];
	private _safeZoneW = uiNamespace getVariable ["Cre8ive_Inventory_SafeZoneW", 0];
	private _safeZoneH = uiNamespace getVariable ["Cre8ive_Inventory_SafeZoneH", 0];
	private _slotSizeW = _safeZoneW * MACRO_SCALE_SLOT_SIZE_W;
	private _slotSizeH = _safeZoneH * MACRO_SCALE_SLOT_SIZE_H;
	private _offsetY = 0;

	// Determine our classes array
	private _classes = [
		uniform player,
		vest player,
		backpack player
	];

	// Determine our containers array
	private _containers = [
		uniformContainer player,
		vestContainer player,
		backpackContainer player
	];

	// Determine the icon paths for the items and weapons that we have
	{
		private _containerFrame = _x select 0;
		private _defaultIconPath = _x select 1;
		private _class = _classes param [_forEachIndex, ""];
		private _category = MACRO_ENUM_CATEGORY_EMPTY;
		private _slotSize = [1,1];
		private _startYNew = _startY + _sizeY + _offsetY;

		// Move the frame
		private _posFrame = ctrlPosition _containerFrame;
		_posFrame set [1, _startY + _offsetY];
		_containerFrame ctrlSetPosition _posFrame;
		_containerFrame ctrlCommit 0;

		// If the slot has something in it, fetch its data
		if (_class != "") then {
			_category = [_class] call cre_fnc_getClassCategory;
			_slotSize = [_class, _category] call cre_fnc_getClassSlotSize;

			// Change the frame's colour
			_containerFrame ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);

			// Mark the slot as active
			_containerFrame setVariable ["active", true];
			_containerFrame setVariable [MACRO_VARNAME_CLASS, _class];
			_containerFrame setVariable [MACRO_VARNAME_SLOTSIZE, _slotSize];
		};

		// Save the slot's default icon path
		_containerFrame setVariable ["defaultIconPath", _defaultIconPath];

		// Fetch the container data
		private _container = _containers select _forEachIndex;
		private _containerData = _container getVariable [MACRO_VARNAME_DATA, locationNull];
		private _containerUID = _containerData getVariable [MACRO_VARNAME_UID, ""];

		// If the container doesn't have any data yet, generate it
// ------------ DEBUG: Remove "true"! v --------------------------------------------------------------------------------
		if (true or _containerUID == "") then {
			_containerData = [_container] call cre_fnc_generateContainerData;
			_containerUID = _containerData getVariable [MACRO_VARNAME_UID, ""];
		};

		// Save the container data on the control
		_containerFrame setVariable [MACRO_VARNAME_DATA, _containerData];

		// Generate the child controls
		[_containerFrame, _class, _category, _slotSize, _defaultIconPath] call cre_fnc_generateChildControls;

		// Fetch the container's dimensions
		private _containerSize = _containerData getVariable ["containerSize", [1,1]];
		private _containerSlotsOnLastY = _containerData getVariable ["containerSlotsOnLastY", [1,1]];

		// Fetch the control's last container UID
		private _lastContainerUID = _containerFrame getVariable ["lastContainerUID", ""];

		// If we previously had a different container, rebuild the controls
		if (_containerUID != _lastContainerUID) then {
			_containerSize params ["_sizeW", "_sizeH"];

			// Delete all controls of the previous container
			private _allSlotFrames = _containerFrame getVariable ["allSlotFrames", []];
			{
				// Delete all child controls of the slot controls
				{
					ctrlDelete _x;
				} forEach (_x getVariable [MACRO_VARNAME_UI_CHILDCONTROLS, []]);
				ctrlDelete (_x getVariable ["slotControl", controlNull]);
				ctrlDelete _x;
			} forEach _allSlotFrames;
			_allSlotFrames = [];

			// Create the new slots
			for "_posY" from 1 to _sizeH do {
				_newW = [_sizeW, _containerSlotsOnLastY] select (_posY == _sizeH);
				for "_posX" from 1 to _newW do {
					private _slotFrame = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedFrame", -1, _storageCtrlGrp];
					private _slotIcon = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedPicture", -1, _storageCtrlGrp];
					_slotFrame ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);
					_slotIcon ctrlSetText MACRO_PICTURE_SLOT_BACKGROUND;

					// Set the frame's pixel precision mode to off, disables rounding
					_slotFrame ctrlSetPixelPrecision 2;

					// Move the slot controls
					private _slotPos = [
						_startX + _slotSizeW * (_posX - 1),
						_startYNew + _slotSizeH * (_posY - 1),
						_slotSizeW,
						_slotSizeH
					];
					{
						_x ctrlSetPosition _slotPos;
						_x ctrlCommit 0;
					} forEach [_slotFrame, _slotIcon];

					// Add some event handlers for mouse entering/exiting the controls, and moving across it
					//_slotFrame ctrlAddEventHandler ["MouseEnter", {["ui_mouse_enter", _this] call cre_fnc_inventory}];
					//_slotFrame ctrlAddEventHandler ["MouseExit", {["ui_mouse_exit", _this] call cre_fnc_inventory}];
					_slotFrame ctrlAddEventHandler ["MouseMoving", {["ui_mouse_moving", _this] call cre_fnc_inventory}];

					// Save some data onto the slot
					_slotFrame setVariable [MACRO_VARNAME_SLOTPOS, [_posX, _posY]];
					_slotFrame setVariable [MACRO_VARNAME_PARENT, _containerData];
					_slotFrame setVariable [MACRO_VARNAME_UI_CTRLPARENT, _containerFrame];

					// Save the slot's frame control onto the container
					_containerFrame setVariable [format [MACRO_VARNAME_SLOT_X_Y, _posX, _posY], _slotFrame];
					_allSlotFrames pushBack _slotFrame;
				};
			};

			// Save this container's new slot controls
			_containerFrame setVariable ["allSlotFrames", _allSlotFrames];
			_containerFrame setVariable ["lastContainerUID", _containerUID];
		};

		// Iterate through the items
		private _items = _containerData getVariable ["items", []];
		{
			// Only continue if the item is valid
			if (!isNull _x) then {
				private _itemClass = _x getVariable [MACRO_VARNAME_CLASS, ""];
				private _itemSlot = _x getVariable [MACRO_VARNAME_SLOTPOS, []];
				private _itemCategory = [_itemClass] call cre_fnc_getClassCategory;
				private _itemSize = [_itemClass, _itemCategory] call cre_fnc_getClassSlotSize;
				_itemSlot params ["_posX", "_posY"];
				_itemSize params ["_sizeW", "_sizeH"];

				// Fetch the occupied slots
				private _slotsStr = [];
				for "_posItemY" from _posY to (_posY + (_itemSize select 1) - 1) do {
					for "_posItemX" from _posX to (_posX + (_itemSize select 0) - 1) do {
						_slotsStr pushBack format [MACRO_VARNAME_SLOT_X_Y, _posItemX, _posItemY];
					};
				};
				_slotsStr deleteAt 0;

				// Hide the occupied slots
				{
					private _slotFrame = _containerFrame getVariable [_x, controlNull];
					_slotFrame ctrlShow false;
				} forEach _slotsStr;

				// Scale the slot controls
				private _slotFrame = _containerFrame getVariable [format [MACRO_VARNAME_SLOT_X_Y, _posX, _posY], controlNull];
				private _slotPos = ctrlPosition _slotFrame;
				_slotPos set [2, _slotSizeW * _sizeW];
				_slotPos set [3, _slotSizeH * _sizeH];
				_slotFrame ctrlSetPosition _slotPos;
				_slotFrame ctrlCommit 0;
				_slotFrame ctrlShow true;

				// Save the item data onto the control
				_slotFrame setVariable [MACRO_VARNAME_DATA, _x];
				_slotFrame setVariable [MACRO_VARNAME_SLOTSIZE, _itemSize];

				// Generate the child controls for this slot
				[_slotFrame, _itemClass, _itemCategory, _itemSize, MACRO_PICTURE_SLOT_BACKGROUND] call cre_fnc_generateChildControls;

				// Change the colour of the frame
				_slotFrame ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);

				// Add event handlers for dragging
				_slotFrame ctrlAddEventHandler ["MouseButtonDown", {["ui_dragging_init", _this] call cre_fnc_inventory}];
				//_slotFrame ctrlAddEventHandler ["MouseButtonUp", {["ui_dragging_stop", _this] call cre_fnc_inventory}];

				// Save some data onto the control
				_slotFrame setVariable ["active", true];
				_slotFrame setVariable ["defaultIconPath", _slotIconPath];
				_slotFrame setVariable [MACRO_VARNAME_CLASS, _itemClass];
			};
		} forEach _items;

		_offsetY = _offsetY + _sizeY + _safeZoneH * (MACRO_SCALE_SLOT_SIZE_H * (_containerSize select 1) + 0.005);
	} forEach [
		[_ctrlUniformFrame,		MACRO_PICTURE_UNIFORM],
		[_ctrlVestFrame,		MACRO_PICTURE_VEST],
		[_ctrlBackpackFrame,		MACRO_PICTURE_BACKPACK]
	];

	// Move the scrollbar dummy
	private _pos = ctrlPosition _ctrlScrollbarDummy;
	_pos set [1, _offsetY];
	_ctrlScrollbarDummy ctrlSetPosition _pos;
	_ctrlScrollbarDummy ctrlCommit 0;
};
