// Start dragging
case "ui_dragging_start": {
	_eventExists = true;

	// Fetch the parameters
	_args params [
		"",
		["_button", 0, [0]]
	];

	// Only register left-clicks
	if (_button == 0) then {

		// Remove the MouseButtonUp event handler
		private _EH = _inventory getVariable [MACRO_VARNAME_UI_EH_MOUSEBUTTONUP, -1];
		if (_EH >= 0) then {
			_inventory displayRemoveEventHandler ["MouseButtonUp", _EH];
			_inventory setVariable [MACRO_VARNAME_UI_EH_MOUSEBUTTONUP, -1];
		};

		// Fetch the control
		private _draggedCtrl = _inventory getVariable [MACRO_VARNAME_UI_DRAGGEDCTRL, controlNull];

		// Only continue if the control still exists
		if (!isNull _draggedCtrl) then {

			// Reset the focus
			["ui_focus_reset", [_draggedCtrl]] call cre_fnc_ui_inventory;

			// Only continue if the control isn't already being dragged
			if !(_draggedCtrl getVariable [MACRO_VARNAME_UI_ISBEINGDRAGGED, false]) then {

				// Change the colour of the slot frame to indicate that it's being dragged
				_draggedCtrl ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);

				// Fetch the control's item class and its associated size
				private _itemData = _draggedCtrl getVariable [MACRO_VARNAME_DATA, locationNull];
				private _class = _itemData getVariable [MACRO_VARNAME_CLASS, ""];
				private _category = _itemData getVariable [MACRO_VARNAME_CATEGORY, MACRO_ENUM_CATEGORY_INVALID];
				private _subCategory = [_class, _category] call cre_fnc_cfg_getClassSubCategory;
				([_class, _category] call cre_fnc_cfg_getClassSlotSize) params ["_slotWidth", "_slotHeight"];

				private _defaultIconPath = _draggedCtrl getVariable [MACRO_VARNAME_UI_DEFAULTICONPATH, ""];
				private _safeZoneW = uiNamespace getVariable ["Cre8ive_Inventory_SafeZoneW", 0];
				private _safeZoneH = uiNamespace getVariable ["Cre8ive_Inventory_SafeZoneH", 0];
				private _posCtrl = ctrlPosition _draggedCtrl;
				_posCtrl params ["_posCtrlX", "_posCtrlY"];

				// Hide the original child controls
				private _childControls = _draggedCtrl getVariable [MACRO_VARNAME_UI_CHILDCONTROLS, []];
				{
					_x ctrlShow false;
				} forEach _childControls;

				// Create a temporary picture that stays on the slot
				if (_defaultIconPath != "") then {
					private _ctrlIconTemp = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedPicture", -1, ctrlParentControlsGroup _draggedCtrl];	// MACRO_IDC_SCRIPTEDPICTURE
					_ctrlIconTemp ctrlSetText _defaultIconPath;
					MACRO_FNC_UI_CTRL_SETPOSITION(_ctrlIconTemp, _posCtrl, 0);
					_inventory setVariable [MACRO_VARNAME_UI_ICONTEMP, _ctrlIconTemp];
				};

				// If the item is rotated, flip the width and height
				private _isRotated = _itemData getVariable [MACRO_VARNAME_ISROTATED, false];
				if (_isRotated) then {
					private _widthTemp = _slotWidth;
					_slotWidth = _slotHeight;
					_slotHeight = _widthTemp;
				};

				// Update the size
				_posCtrl set [2, _slotWidth * _safeZoneW * MACRO_SCALE_SLOT_SIZE_W];
				_posCtrl set [3, _slotHeight * _safeZoneH * MACRO_SCALE_SLOT_SIZE_H];

				// Create a temporary frame that follows the mouse
				private _ctrlFrameTemp = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedBox", -1];
				_ctrlFrameTemp ctrlSetPosition _posCtrl;
				_ctrlFrameTemp ctrlCommit 0;
				_ctrlFrameTemp ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);
				_inventory setVariable [MACRO_VARNAME_UI_FRAMETEMP, _ctrlFrameTemp];

				// Set the frame's pixel precision mode to off, disables rounding
				_ctrlFrameTemp ctrlSetPixelPrecision MACRO_GLOBAL_PIXELPRECISIONMODE;

				// Copy the original control's item data onto the dummy frame
				private _data = _draggedCtrl getVariable [MACRO_VARNAME_DATA, locationNull];
				_ctrlFrameTemp setVariable [MACRO_VARNAME_DATA, _data];
				_ctrlFrameTemp setVariable [MACRO_VARNAME_ISROTATED, _isRotated];

				// Raise the "Draw" event for the temporary frame control
				private _eventArgs = [_itemData, _ctrlFrameTemp, _inventory];
				[STR(MACRO_ENUM_EVENT_DRAW), _eventArgs] call cre_fnc_IEH_raiseEvent;

				// Calculate the position offsets for the child controls (so they get dragged properly)
				{
					private _posChildCtrl = ctrlPosition _x;
					_x setVariable [MACRO_VARNAME_UI_OFFSET, [
						(_posChildCtrl select 0) - _posCtrlX,
						(_posChildCtrl select 1) - _posCtrlY
					]];
				} forEach (_ctrlFrameTemp getVariable [MACRO_VARNAME_UI_CHILDCONTROLS, []]);

				// Mark the control as being dragged
				_draggedCtrl setVariable [MACRO_VARNAME_UI_ISBEINGDRAGGED, true];

				// Reset the list of highlit controls
				_inventory setVariable [MACRO_VARNAME_UI_HIGHLITCONTROLS, []];

				// Fetch the IDCs of the frames of all reserved slots (assigned items, weapons, etc.)
				private _allowedCtrlsIDCs = [];
				private _forbiddenCtrlsIDCs = [
					MACRO_IDC_NVGS_FRAME,
					MACRO_IDC_HEADGEAR_FRAME,
					MACRO_IDC_BINOCULARS_FRAME,
					MACRO_IDC_GOGGLES_FRAME,
					MACRO_IDC_MAP_FRAME,
					MACRO_IDC_GPS_FRAME,
					MACRO_IDC_RADIO_FRAME,
					MACRO_IDC_COMPASS_FRAME,
					MACRO_IDC_WATCH_FRAME,
					MACRO_IDC_PRIMARYWEAPON_FRAME,
					MACRO_IDC_HANDGUNWEAPON_FRAME,
					MACRO_IDC_SECONDARYWEAPON_FRAME,
					MACRO_IDC_UNIFORM_FRAME,
					MACRO_IDC_VEST_FRAME,
					MACRO_IDC_BACKPACK_FRAME
				];

				// Drop the frame of the slot that matches the item type
				switch (_category) do {
					case MACRO_ENUM_CATEGORY_NVGS: {
						_allowedCtrlsIDCs pushBack MACRO_IDC_NVGS_FRAME;
					};
					case MACRO_ENUM_CATEGORY_HEADGEAR: {
						_allowedCtrlsIDCs pushBack MACRO_IDC_HEADGEAR_FRAME;
					};
					case MACRO_ENUM_CATEGORY_BINOCULARS: {
						_allowedCtrlsIDCs pushBack MACRO_IDC_BINOCULARS_FRAME;
					};
					case MACRO_ENUM_CATEGORY_GOGGLES: {
						_allowedCtrlsIDCs pushBack MACRO_IDC_GOGGLES_FRAME;
					};
					case MACRO_ENUM_CATEGORY_ITEM: {
						switch (_subCategory) do {
							case MACRO_ENUM_SUBCATEGORY_MAP: {
								_allowedCtrlsIDCs pushBack MACRO_IDC_MAP_FRAME;
							};
							case MACRO_ENUM_SUBCATEGORY_GPS: {
								_allowedCtrlsIDCs pushBack MACRO_IDC_GPS_FRAME;
							};
							case MACRO_ENUM_SUBCATEGORY_RADIO: {
								_allowedCtrlsIDCs pushBack MACRO_IDC_RADIO_FRAME;
							};
							case MACRO_ENUM_SUBCATEGORY_COMPASS: {
								_allowedCtrlsIDCs pushBack MACRO_IDC_COMPASS_FRAME;
							};
							case MACRO_ENUM_SUBCATEGORY_WATCH: {
								_allowedCtrlsIDCs pushBack MACRO_IDC_WATCH_FRAME;
							};
						};
					};
					case MACRO_ENUM_CATEGORY_WEAPON: {
						switch (_subCategory) do {
							case MACRO_ENUM_SUBCATEGORY_PRIMARYWEAPON: {
								_allowedCtrlsIDCs pushBack MACRO_IDC_PRIMARYWEAPON_FRAME;
							};
							case MACRO_ENUM_SUBCATEGORY_HANDGUNWEAPON: {
								_allowedCtrlsIDCs pushBack MACRO_IDC_HANDGUNWEAPON_FRAME;
							};
							case MACRO_ENUM_SUBCATEGORY_SECONDARYWEAPON: {
								_allowedCtrlsIDCs pushBack MACRO_IDC_SECONDARYWEAPON_FRAME;
							};
						};
					};
					case MACRO_ENUM_CATEGORY_UNIFORM: {
						_allowedCtrlsIDCs pushBack MACRO_IDC_UNIFORM_FRAME;
					};
					case MACRO_ENUM_CATEGORY_VEST: {
						_allowedCtrlsIDCs pushBack MACRO_IDC_VEST_FRAME;
					};
					case MACRO_ENUM_CATEGORY_BACKPACK: {
						_allowedCtrlsIDCs pushBack MACRO_IDC_BACKPACK_FRAME;
					};
				};

				// Paint the forbidden slots in red
				private _forbiddenCtrls = [];
				{
					private _ctrlX = _inventory displayCtrl _x;
					_ctrlX ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_DRAGGING_RED);
					_forbiddenCtrls pushBack _ctrlX;
				} forEach _forbiddenCtrlsIDCs;

				// Paint the allowed slot in the inactive (hover) colour
				private _allowedCtrls = [];
				private _ctrlIndex = -1;
				{
					private _ctrlX = _inventory displayCtrl _x;
					_ctrlX ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE_HOVER);
					_allowedCtrls pushBack _ctrlX;

					// Remove this control from the forbidden controls list
					private _ctrlIndex = _forbiddenCtrls find _ctrlX;
					if (_ctrlIndex >= 0) then {
						_forbiddenCtrls deleteAt _ctrlIndex;
					};
				} forEach _allowedCtrlsIDCs;

				// Save the two lists
				_inventory setVariable [MACRO_VARNAME_UI_ALLOWEDCONTROLS, _allowedCtrls];
				_inventory setVariable [MACRO_VARNAME_UI_FORBIDDENCONTROLS, _forbiddenCtrls];

				// If the dragged control is a dropped item, hide its frame control
				if (typeOf (_itemData getVariable [MACRO_VARNAME_PARENT, objNull]) in MACRO_CLASSES_GROUNDHOLDERS) then {
					_draggedCtrl ctrlShow false;

				// Otherwise, if the item is inside a container, rescale and unhide the item's occupied slot controls
				} else {
					private _containerCtrl = _draggedCtrl getVariable [MACRO_VARNAME_UI_CTRLPARENT, controlNull];
					if (!isNull _containerCtrl and {_draggedCtrl != _containerCtrl}) then {

						// Unhide all occupied slot controls
						{
							private _slot = _containerCtrl getVariable [format [MACRO_VARNAME_SLOT_X_Y, _x select 0, _x select 1], controlNull];
							_slot ctrlShow true;
						} forEach (_itemData getVariable [MACRO_VARNAME_OCCUPIEDSLOTS, []]);

						// Rescale the original slot control
						_posCtrl set [2, _safeZoneW * MACRO_SCALE_SLOT_SIZE_W];
						_posCtrl set [3, _safeZoneH * MACRO_SCALE_SLOT_SIZE_H];
						_draggedCtrl ctrlSetPosition _posCtrl;
						_draggedCtrl ctrlCommit 0;
					};
				};

				// Move the temporary controls if the mouse is moving
				_inventory displayAddEventHandler ["MouseMoving", {
					params ["_inventory"];
					private _draggedCtrl = _inventory getVariable ["draggedControl", controlNull];

					getMousePosition params ["_posX", "_posY"];

					// Call the inventory function to handle dragging
					["ui_dragging", [_draggedCtrl, _posX, _posY]] call cre_fnc_ui_inventory;
				}];

				// Move the temporary controls in place initially
				getMousePosition params ["_posX", "_posY"];
				["ui_dragging", [_draggedCtrl, _posX, _posY]] call cre_fnc_ui_inventory;

				["ui_mouse_moving", [_draggedCtrl]] call cre_fnc_ui_inventory;

				// Add an event handler to the inventory to detect mouse presses
				_EH = _inventory displayAddEventHandler ["MouseButtonDown", {
					_this params ["", "_button"];

					switch (_button) do {
						case 0: {["ui_dragging_stop"] call cre_fnc_ui_inventory};
						case 1: {["ui_dragging_abort"] call cre_fnc_ui_inventory};
					};
				}];
				_inventory setVariable [MACRO_VARNAME_UI_EH_MOUSEBUTTONDOWN, _EH];

				// Add an event handler to the inventory to detect key presses
				_EH = _inventory displayAddEventHandler ["KeyDown", {
					_this params ["", "_key"];

					// If the player presses the reload key, rotate the dragged item
					if (_key in actionKeys "ReloadMagazine") then {
						["ui_dragging_rotate"] call cre_fnc_ui_inventory;
					};
				}];
				_inventory setVariable [MACRO_VARNAME_UI_EH_KEYDOWN, _EH];

			// If something went wrong, reset the dragged control (fallback)
			} else {
				_inventory setVariable [MACRO_VARNAME_UI_DRAGGEDCTRL, controlNull];
			};
		};
	};
};
