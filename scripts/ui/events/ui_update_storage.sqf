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

	// Fetch the player's container data
	private _playerContainerData = player getVariable [MACRO_VARNAME_DATA, locationNull];

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
		_x params ["_containerVarName", "_containerSlotPosEnum", "_containerFrame", "_defaultIconPath"];

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
			_category = [_class] call cre_fnc_cfg_getClassCategory;
			_slotSize = [_class, _category] call cre_fnc_cfg_getClassSlotSize;

			// Change the frame's colour
			_containerFrame ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);

			// Mark the slot as active
			_containerFrame setVariable ["active", true];
			_containerFrame setVariable [MACRO_VARNAME_CLASS, _class];
			_containerFrame setVariable [MACRO_VARNAME_SLOTSIZE, _slotSize];

			// Save the slot's default icon path
			_containerFrame setVariable [MACRO_VARNAME_UI_DEFAULTICONPATH, _defaultIconPath];

			// Fetch the container data
			private _container = _containers select _forEachIndex;
			private _containerData = _container getVariable [MACRO_VARNAME_DATA, locationNull];

			// If the container doesn't have any data yet, generate it
	// ------------ DEBUG: Remove "true"! v --------------------------------------------------------------------------------
			if (false or isNull _containerData) then {
				systemChat format ["Building container data for: %1", _class];
				_containerData = [_container] call cre_fnc_inv_generateContainerData;

				// Fill the container data with some info
				_containerData setVariable [MACRO_VARNAME_CLASS, _class];
				_containerData setVariable [MACRO_VARNAME_PARENT, _playerContainerData];
				_containerData setVariable [MACRO_VARNAME_SLOTPOS, [_containerSlotPosEnum, MACRO_ENUM_SLOTPOS_INVALID]];

				_playerContainerData setVariable [_containerVarName, _containerData];
			};

			// Save the container data on the control
			_containerFrame setVariable [MACRO_VARNAME_DATA, _containerData];

			// Generate the child controls
			[_containerFrame, _class, _category, _defaultIconPath] call cre_fnc_ui_generateChildControls;

			// Fetch the container's dimensions
			private _containerSize = _containerData getVariable [MACRO_VARNAME_CONTAINERSIZE, [1,1]];
			private _containerSlotsOnLastY = _containerData getVariable [MACRO_VARNAME_CONTAINERSLOTSONLASTY, [1,1]];

			// Fetch the control's last container UID
			private _lastContainerUID = _containerFrame getVariable ["lastContainerUID", ""];

			// If we previously had a different container, rebuild the controls
			private _containerUID = _containerData getVariable [MACRO_VARNAME_UID, ""];
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

						// Add some event handlers to the slot controls
						_slotFrame ctrlAddEventHandler ["MouseExit", {["ui_mouse_exit", _this] call cre_fnc_ui_inventory}];
						_slotFrame ctrlAddEventHandler ["MouseMoving", {["ui_mouse_moving", _this] call cre_fnc_ui_inventory}];
						_slotFrame ctrlAddEventHandler ["MouseButtonDown", {["ui_dragging_init", _this] call cre_fnc_ui_inventory}];

						// Save some data onto the slot
						_slotFrame setVariable [MACRO_VARNAME_PARENT, _containerData];
						_slotFrame setVariable [MACRO_VARNAME_UI_CTRLPARENT, _containerFrame];
						_slotFrame setVariable [MACRO_VARNAME_SLOTPOS, [_posX, _posY]];

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
			private _items = _containerData getVariable [MACRO_VARNAME_ITEMS, []];
			{
				// Only continue if the item is valid
				if (!isNull _x) then {
					private _itemClass = _x getVariable [MACRO_VARNAME_CLASS, ""];
					private _itemSlot = _x getVariable [MACRO_VARNAME_SLOTPOS, []];
					private _itemCategory = [_itemClass] call cre_fnc_cfg_getClassCategory;
					private _itemSize = [_itemClass, _itemCategory] call cre_fnc_cfg_getClassSlotSize;
					_itemSlot params ["_posX", "_posY"];
					_itemSize params ["_sizeW", "_sizeH"];

					// Hide the occupied slots
					private _occupiedSlots = +(_x getVariable [MACRO_VARNAME_OCCUPIEDSLOTS, []]);
					_occupiedSlots deleteAt 0;
					{
						_x params ["_slotX", "_slotY"];
						(_containerFrame getVariable [format [MACRO_VARNAME_SLOT_X_Y, _slotX, _slotY], controlNull]) ctrlShow false;
					} forEach _occupiedSlots;

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
					[_slotFrame, _itemClass, _itemCategory, MACRO_PICTURE_SLOT_BACKGROUND] call cre_fnc_ui_generateChildControls;

					// Change the colour of the frame
					_slotFrame ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);

					// Save some more info onto the slot control
					_slotFrame setVariable ["active", true];
					_slotFrame setVariable [MACRO_VARNAME_CLASS, _itemClass];
				};
			} forEach _items;

			_offsetY = _offsetY + _sizeY + _safeZoneH * (MACRO_SCALE_SLOT_SIZE_H * (_containerSize select 1) + 0.005);
		} else {
			_offsetY = _offsetY + _sizeY + _safeZoneH * (MACRO_SCALE_SLOT_SIZE_H + 0.005);
		};

		// Add some event handlers to the container controls
		_containerFrame ctrlAddEventHandler ["MouseExit", {["ui_mouse_exit", _this] call cre_fnc_ui_inventory}];
		_containerFrame ctrlAddEventHandler ["MouseMoving", {["ui_mouse_moving", _this] call cre_fnc_ui_inventory}];
		_containerFrame ctrlAddEventHandler ["MouseButtonDown", {["ui_dragging_init", _this] call cre_fnc_ui_inventory}];

		// Save the container slot's slot position
		_containerFrame setVariable [MACRO_VARNAME_SLOTPOS, [_containerSlotPosEnum, MACRO_ENUM_SLOTPOS_INVALID]];
		_containerFrame setVariable [MACRO_VARNAME_PARENT, _playerContainerData];

	} forEach [
		[MACRO_VARNAME_UNIT_UNIFORM,	MACRO_ENUM_SLOTPOS_UNIFORM,	_ctrlUniformFrame,	MACRO_PICTURE_UNIFORM],
		[MACRO_VARNAME_UNIT_VEST,	MACRO_ENUM_SLOTPOS_VEST,	_ctrlVestFrame,		MACRO_PICTURE_VEST],
		[MACRO_VARNAME_UNIT_BACKPACK,	MACRO_ENUM_SLOTPOS_BACKPACK,	_ctrlBackpackFrame,	MACRO_PICTURE_BACKPACK]
	];

	// Move the scrollbar dummy
	private _pos = ctrlPosition _ctrlScrollbarDummy;
	_pos set [1, _offsetY];
	_ctrlScrollbarDummy ctrlSetPosition _pos;
	_ctrlScrollbarDummy ctrlCommit 0;
};
