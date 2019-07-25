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
	private _shouldMoveCtrls = false;

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

	// Fetch the list of storage containers
	private _storageContainers = _inventory getVariable [MACRO_VARNAME_UI_STORAGE_CONTAINERS, []];
	private _storageContainersNew = [];

	// Check if this is the first execution
	private _isFirstExecution = (_storageContainers isEqualTo []);

	// Iterate through the containers
	{
		_x params ["_containerSlotPosEnum", "_containerFrame", "_defaultIconPath"];

		private _class = _classes param [_forEachIndex, ""];
		private _category = MACRO_ENUM_CATEGORY_EMPTY;
		private _slotSize = [1,1];
		private _startYNew = _startY + _sizeY + _offsetY;
		private _container = _containers select _forEachIndex;
		private _storageContainer = _storageContainers param [_forEachIndex, objNull];
		_storageContainersNew set [_forEachIndex, _container];

		// Fetch the container data
		private _containerData = _container getVariable [MACRO_VARNAME_DATA, locationNull];

		// If the container doesn't have any data yet, generate it
// ------------ DEBUG: Remove "true"! v --------------------------------------------------------------------------------
		if (isNull _containerData and {!isNull _container}) then {
			//systemChat format ["Building container data for: %1", _class];
			_containerData = [_container, _class, player, [_containerSlotPosEnum, MACRO_ENUM_SLOTPOS_INVALID]] call cre_fnc_inv_generateContainerData;

			// Link the player container data with this container data
			_playerContainerData setVariable [format [MACRO_VARNAME_SLOT_X_Y, _containerSlotPosEnum, MACRO_ENUM_SLOTPOS_INVALID], _containerData];
		};

		// Fetch the container's dimensions
		private _containerSize = _containerData getVariable [MACRO_VARNAME_CONTAINERSIZE, [0,0]];

		// Move the frame
		private _deltaY = (_startY + _offsetY) - (ctrlPosition _containerFrame select 1);
		_containerFrame ctrlSetPositionY _startY + _offsetY;
		_containerFrame ctrlCommit 0;

		// If the container has changed, or was removed, delete the old controls
		if !(_container isEqualTo _storageContainer) then {	// Using == would return false if both objects are objNull, but isEqualTo works fine
			_shouldMoveCtrls = true;
			private _allSlotFrames = _containerFrame getVariable [MACRO_VARNAME_UI_ALLSLOTFRAMES, []];
			private _isForbiddenControl = false;

			// Link the player container data to this container data
			_containerData setVariable [MACRO_VARNAME_PARENT, player];
			_containerData setVariable [MACRO_VARNAME_PARENTDATA, _playerContainerData];
			_playerContainerData setVariable [format [MACRO_VARNAME_SLOT_X_Y, _containerSlotPosEnum, MACRO_ENUM_SLOTPOS_INVALID], _containerData];

			// Delete all itme slot controls of the previous container
			{
				// Delete all child controls of the slot controls
				[_x] call cre_fnc_ui_deleteSlotCtrl;
			} forEach _allSlotFrames;
			_allSlotFrames = [];

			// If the container exists, create and fill out its new slot controls
			if (!isNull _container) then {

				// Fetch some information about the container
				_category = [_class] call cre_fnc_cfg_getClassCategory;
				_slotSize = [_class, _category] call cre_fnc_cfg_getClassSlotSize;

				// Change the frame's colour
				_containerFrame ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);

				// Mark the slot as active
				_containerFrame setVariable [MACRO_VARNAME_CLASS, _class];
				_containerFrame setVariable [MACRO_VARNAME_SLOTSIZE, _slotSize];

				// Save the slot's default icon path
				_containerFrame setVariable [MACRO_VARNAME_UI_DEFAULTICONPATH, _defaultIconPath];

				// Save the container data on the control
				_containerFrame setVariable [MACRO_VARNAME_DATA, _containerData];

				// Fetch the container's slots count on the last line
				private _containerSlotsOnLastY = _containerData getVariable [MACRO_VARNAME_CONTAINERSLOTSONLASTY, _sizeW];
				if (_containerSlotsOnLastY == 0) then {_containerSlotsOnLastY = _sizeW};

				_containerSize params ["_sizeW", "_sizeH"];

				// Create the new slots
				for "_posY" from 1 to _sizeH do {
					_newW = [_sizeW, _containerSlotsOnLastY] select (_posY == _sizeH);
					for "_posX" from 1 to _newW do {
						private _slotFrame = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedFrame", -1, _storageCtrlGrp];
						private _slotIcon = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedPicture", -1, _storageCtrlGrp];
						_slotFrame ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);
						_slotIcon ctrlSetText MACRO_PICTURE_SLOT_BACKGROUND;

						// Set the frame's pixel precision mode to off, disables rounding
						_slotFrame ctrlSetPixelPrecision MACRO_GLOBAL_PIXELPRECISIONMODE;

						// Move the slot controls
						private _slotPos = [
							_startX + _slotSizeW * (_posX - 1),
							_startYNew + _slotSizeH * (_posY - 1),
							_slotSizeW,
							_slotSizeH
						];
						{
							MACRO_FNC_UI_CTRL_SETPOSITION(_x, _slotPos, 0);
						} forEach [_slotFrame, _slotIcon];

						// Add some event handlers to the slot controls
						_slotFrame ctrlAddEventHandler ["MouseExit", {["ui_mouse_exit", _this] call cre_fnc_ui_inventory}];
						_slotFrame ctrlAddEventHandler ["MouseMoving", {["ui_mouse_moving", _this] call cre_fnc_ui_inventory}];
						_slotFrame ctrlAddEventHandler ["MouseButtonDown", {["ui_dragging_init", _this] call cre_fnc_ui_inventory}];

						// Save some data onto the slot
						_slotFrame setVariable [MACRO_VARNAME_PARENTDATA, _containerData];
						_slotFrame setVariable [MACRO_VARNAME_UI_CTRLPARENT, _containerFrame];
						_slotFrame setVariable [MACRO_VARNAME_SLOTPOS, [_posX, _posY]];
						_slotFrame setVariable [MACRO_VARNAME_UI_CTRLSLOTICON, _slotIcon];

						// Save the slot's frame control onto the container
						_containerFrame setVariable [format [MACRO_VARNAME_SLOT_X_Y, _posX, _posY], _slotFrame];
						_allSlotFrames pushBack _slotFrame;
					};
				};

				// Save this container's new slot controls
				_containerFrame setVariable [MACRO_VARNAME_UI_ALLSLOTFRAMES, _allSlotFrames];

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

						// If the control is rotated, flip the width and height
						private _isRotated = _x getVariable [MACRO_VARNAME_ISROTATED, false];
						if (_isRotated) then {
							private _widthTemp = _sizeW;
							_sizeW = _sizeH;
							_sizeH = _widthTemp;
						};

						// Hide the occupied slots
						private _occupiedSlots = +(_x getVariable [MACRO_VARNAME_OCCUPIEDSLOTS, []]);
						_occupiedSlots deleteAt 0;
						{
							_x params ["_slotX", "_slotY"];
							(_containerFrame getVariable [format [MACRO_VARNAME_SLOT_X_Y, _slotX, _slotY], controlNull]) ctrlShow false;
						} forEach _occupiedSlots;

						// Scale the slot controls
						private _slotFrame = _containerFrame getVariable [format [MACRO_VARNAME_SLOT_X_Y, _posX, _posY], controlNull];
						_slotFrame ctrlSetPositionW _slotSizeW * _sizeW;
						_slotFrame ctrlSetPositionH _slotSizeH * _sizeH;
						_slotFrame ctrlCommit 0;

						// Save the item data onto the control
						_slotFrame setVariable [MACRO_VARNAME_CLASS, _itemClass];
						_slotFrame setVariable [MACRO_VARNAME_DATA, _x];
						_slotFrame setVariable [MACRO_VARNAME_SLOTSIZE, _itemSize];
						_slotFrame setVariable [MACRO_VARNAME_ISROTATED, _isRotated];

						// Change the colour of the frame
						_slotFrame ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);

						// Raise the "Draw" event
						private _eventArgs = [_x, _slotFrame, _inventory];
						[STR(MACRO_ENUM_EVENT_DRAW), _eventArgs] call cre_fnc_IEH_raiseEvent;
					};
				} forEach _items;

				// Raise the "Draw" event for the container
				private _eventArgs = [_containerData, _containerFrame, _inventory];
				[STR(MACRO_ENUM_EVENT_DRAW), _eventArgs] call cre_fnc_IEH_raiseEvent;

			// Otherwise, if the container is null...
			} else {
				_containerFrame setVariable [MACRO_VARNAME_CLASS, ""];
				_containerFrame setVariable [MACRO_VARNAME_DATA, locationNull];

				// Delete the frame's existing child controls (but not the control itself)
				[_containerFrame, false] call cre_fnc_ui_deleteSlotCtrl;

				// Generate new child controls for the empty slot (default icon)
				[_containerFrame, _defaultIconPath, _inventory] call cre_fnc_ui_drawEmptySlot;
			};

			// Next, if the container is currently being dragged, cancel the dragging
			if (_containerFrame getVariable [MACRO_VARNAME_UI_ISBEINGDRAGGED, false]) then {
				["ui_dragging_abort"] call cre_fnc_ui_inventory;
			} else {
				private _forbiddenCtrls = _inventory getVariable [MACRO_VARNAME_UI_FORBIDDENCONTROLS, []];
				_isForbiddenControl = _containerFrame in _forbiddenCtrls;
			};

			// Following that, set the frame's control based on what we're dragging
			if (_isForbiddenControl) then {
				_containerFrame ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_DRAGGING_RED);
			} else {
				if (isNull _containerData) then {
					_containerFrame ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);
				} else {
					_containerFrame ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);
				};
			};

		// If the container hasn't changed, check if we need to reposition its controls
		} else {

			// If this is the first execution, and there is no container in this slot, draw an empty slot
			if (_isFirstExecution) then {
				[_containerFrame, _defaultIconPath, _inventory] call cre_fnc_ui_drawEmptySlot;

			// Otherwise, check if we need to move anything
			} else {

				if (_shouldMoveCtrls) then {
					// Reposition the container frame's child controls
					private _containerFrameCtrls = (_containerFrame getVariable [MACRO_VARNAME_UI_CHILDCONTROLS, []]) + [_containerFrame getVariable [MACRO_VARNAME_UI_CTRLSLOTICON, controlNull]];
					{
						_x ctrlSetPositionY (ctrlPosition _x select 1) + _deltaY;
						_x ctrlCommit 0;
					} forEach _containerFrameCtrls;

					// Reposition all slots that belong to this container
					{
						// Reposition the slot frames
						_x ctrlSetPositionY (ctrlPosition _x select 1) + _deltaY;
						_x ctrlCommit 0;

						// Reposition all child controls of the slot frames
						{
							_x ctrlSetPositionY (ctrlPosition _x select 1) + _deltaY;
							_x ctrlCommit 0;
						} forEach ((_x getVariable [MACRO_VARNAME_UI_CHILDCONTROLS, []]) + [_x getVariable [MACRO_VARNAME_UI_CTRLSLOTICON, controlNull]]);
					} forEach (_containerFrame getVariable [MACRO_VARNAME_UI_ALLSLOTFRAMES, []]);
				};
			};
		};

		// Increase the Y position offset
		_offsetY = _offsetY + _slotSizeH * (_containerSize select 1) + _safeZoneH * MACRO_POS_SPACER_Y * 2 + _sizeY;
/*
		// Create the container frame's child controls, if it doesn't have any yet
		if (isNull (_containerFrame getVariable [MACRO_VARNAME_UI_CTRLICON, controlNull])) then {
			[_containerFrame, _class, _category, _defaultIconPath] call cre_fnc_ui_generateChildControls;
		};
*/
		// Add some event handlers to the container controls
		if !(_containerFrame getVariable [MACRO_VARNAME_UI_CTRL_HAS_EHS, false]) then {
			_containerFrame setVariable [MACRO_VARNAME_UI_CTRL_HAS_EHS, true];
			_containerFrame ctrlAddEventHandler ["MouseExit", {["ui_mouse_exit", _this] call cre_fnc_ui_inventory}];
			_containerFrame ctrlAddEventHandler ["MouseMoving", {["ui_mouse_moving", _this] call cre_fnc_ui_inventory}];
			_containerFrame ctrlAddEventHandler ["MouseButtonDown", {["ui_dragging_init", _this] call cre_fnc_ui_inventory}];
		};

		// Save the container slot's slot position
		_containerFrame setVariable [MACRO_VARNAME_SLOTPOS, [_containerSlotPosEnum, MACRO_ENUM_SLOTPOS_INVALID]];
		_containerFrame setVariable [MACRO_VARNAME_PARENTDATA, _playerContainerData];

	} forEach [
		[MACRO_ENUM_SLOTPOS_UNIFORM,	_ctrlUniformFrame,	MACRO_PICTURE_UNIFORM],
		[MACRO_ENUM_SLOTPOS_VEST,	_ctrlVestFrame,		MACRO_PICTURE_VEST],
		[MACRO_ENUM_SLOTPOS_BACKPACK,	_ctrlBackpackFrame,	MACRO_PICTURE_BACKPACK]
	];

	// Move the scrollbar dummy
	_ctrlScrollbarDummy ctrlSetPositionY _offsetY;
	_ctrlScrollbarDummy ctrlCommit 0;

	// Save the new list of storage containers
	_inventory setvariable [MACRO_VARNAME_UI_STORAGE_CONTAINERS, _storageContainersNew];
};
