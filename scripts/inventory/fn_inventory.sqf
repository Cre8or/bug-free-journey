#include "..\..\res\config\dialogs\macros.hpp"

params [
        ["_event", "", [""]],
	"_args"
];

// Change the case to avoid mistakes
_event = toLower _event;

// Exit if no event was specified
if (_event == "") exitWith {systemChat "No event specified!"};

// Check if the inventory is open
disableSerialization;
private _eventExists = false;
private _inventory = uiNamespace getVariable ["cre8ive_dialog_inventory", displayNull];
if (_event != "ui_init") then {
        if (isNull _inventory) exitWith {systemChat "Inventory isn't open!"};
};





switch (_event) do {

        // Initialisation
        case "ui_init": {
		_eventExists = true;
                [] spawn {

                        (findDisplay 46) createDisplay "Rsc_Cre8ive_Inventory";
			//createDialog "Rsc_Cre8ive_Inventory";

			private _timeOut = time + 1;
                        waitUntil {!isNull (uiNamespace getVariable ["cre8ive_dialog_inventory", displayNull]) or {time > _timeOut}};

                        if (time > _timeOut) then {
                                systemChat "Couldn't open inventory!";
                        } else {
				// Escape scheduled environment
				isNil {
	                                // Fetch the inventory
	                                private _inventory = uiNamespace getVariable ["cre8ive_dialog_inventory", displayNull];

	                                // Write down the player's name
	                                (_inventory displayCtrl MACRO_IDC_PLAYER_NAME) ctrlSetText name player;

					// Attach an EH to the inventory to detect when it is closed
					_inventory displayAddEventHandler ["Unload", {
						["ui_unload"] call cre_fnc_inventory;
					}];

					// Set up the blur post-process effect
					private _blurFX = missionNamespace getVariable ["Cre8ive_Inventory_BlurFX", 0];
					if (_blurFX <= 0) then {
						private _index = 400;
						while {
							_blurFX = ppEffectCreate ["DynamicBlur", _index];
							_blurFX < 0
						} do {
							_index = _index + 1;
						};

						_blurFX ppEffectEnable true;
					};

					// Start the post-process effect and save the handle for later use
					_blurFX ppEffectAdjust [5];
					_blurFX ppEffectCommit 0;
					missionNamespace setVariable  ["Cre8ive_Inventory_blurFX", _blurFX, false];

					// Stop the action menu from interfering
				        inGameUISetEventHandler ["PrevAction", "true"];
					inGameUISetEventHandler ["NextAction", "true"];
					inGameUISetEventHandler ["Action", "true"];

					// Close the commanding menu if it is open
					if (commandingMenu != "") then {showCommandingMenu ""};

					// Load the weapons menu (default)
					["ui_menu_weapons"] call cre_fnc_inventory;

					// Load the storage menu
					["ui_menu_storage"] call cre_fnc_inventory;

					// Set the focus on something unimportant (to avoid triggering the close button with space)
					ctrlSetFocus (_inventory displayCtrl MACRO_IDC_EMPTY_FOCUS_FRAME);
				};
                        };
                };
        };



	// Unloading (closing the inventory)
	case "ui_unload": {
		_eventExists = true;

		// Stop the blur post-process effect
		private _blurFX = missionNamespace getVariable ["Cre8ive_Inventory_BlurFX", 0];
		_blurFX ppEffectAdjust [0];
		_blurFX ppEffectCommit 0;

		// Re-enable the action menu
		inGameUISetEventHandler ["PrevAction", "false"];
		inGameUISetEventHandler ["NextAction", "false"];
		inGameUISetEventHandler ["Action", "false"];

	};



        // Load the weapons menu
        case "ui_menu_weapons": {
		_eventExists = true;
                // Show the weapons controls
		(_inventory displayCtrl MACRO_IDC_WEAPONS_CTRLGRP) ctrlShow true;
		(_inventory displayCtrl MACRO_IDC_MEDICAL_CTRLGRP) ctrlShow false;

		// Change the button colours
                (_inventory displayCtrl MACRO_IDC_WEAPONS_BUTTON_FRAME) ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);
                (_inventory displayCtrl MACRO_IDC_MEDICAL_BUTTON_FRAME) ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);

		// Reset the overall focus back to the empty dummy control (stops buttons from breaking)
		ctrlSetFocus (_inventory displayCtrl MACRO_IDC_EMPTY_FOCUS_FRAME);

		// Set the pixel precision mode of all frames to "OFF"
		{
			_x ctrlSetPixelPrecision 2;
		} forEach [
			_inventory displayCtrl MACRO_IDC_NVGS_FRAME,
			_inventory displayCtrl MACRO_IDC_HEADGEAR_FRAME,
			_inventory displayCtrl MACRO_IDC_GOGGLES_FRAME,
			_inventory displayCtrl MACRO_IDC_BINOCULARS_FRAME,
			_inventory displayCtrl MACRO_IDC_PRIMARYWEAPON_FRAME,
			_inventory displayCtrl MACRO_IDC_HANDGUNWEAPON_FRAME,
			_inventory displayCtrl MACRO_IDC_SECONDARYWEAPON_FRAME,
			_inventory displayCtrl MACRO_IDC_MAP_FRAME,
			_inventory displayCtrl MACRO_IDC_GPS_FRAME,
			_inventory displayCtrl MACRO_IDC_RADIO_FRAME,
			_inventory displayCtrl MACRO_IDC_COMPASS_FRAME,
			_inventory displayCtrl MACRO_IDC_WATCH_FRAME
		];

                // Update the menu
        	["ui_update_weapons"] call cre_fnc_inventory;
        };



        // Load the medical menu
        case "ui_menu_medical": {
		_eventExists = true;

                // Hide the weapons controls
		(_inventory displayCtrl MACRO_IDC_WEAPONS_CTRLGRP) ctrlShow false;
		(_inventory displayCtrl MACRO_IDC_MEDICAL_CTRLGRP) ctrlShow true;

                // Change the button colours
		(_inventory displayCtrl MACRO_IDC_WEAPONS_BUTTON_FRAME) ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);
                (_inventory displayCtrl MACRO_IDC_MEDICAL_BUTTON_FRAME) ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);

		// Reset the overall focus back to the empty dummy control (stops buttons from breaking)
		ctrlSetFocus (_inventory displayCtrl MACRO_IDC_EMPTY_FOCUS_FRAME);

                // Update the menu
                ["ui_update_medical"] call cre_fnc_inventory;
        };



	// Load the storage menu
	case "ui_menu_storage": {
		_eventExists = true;
		// Grab some of our inventory controls
		private _storageCtrlGrp = _inventory displayCtrl MACRO_IDC_STORAGE_CTRLGRP;
		private _ctrlUniformFrame = _storageCtrlGrp controlsGroupCtrl MACRO_IDC_UNIFORM_FRAME;
                private _ctrlUniformIcon = _storageCtrlGrp controlsGroupCtrl MACRO_IDC_UNIFORM_ICON;
		private _ctrlVestFrame = _storageCtrlGrp controlsGroupCtrl MACRO_IDC_VEST_FRAME;
                private _ctrlVestIcon = _storageCtrlGrp controlsGroupCtrl MACRO_IDC_VEST_ICON;
		private _ctrlBackpackFrame = _storageCtrlGrp controlsGroupCtrl MACRO_IDC_BACKPACK_FRAME;
		private _ctrlBackpackIcon = _storageCtrlGrp controlsGroupCtrl MACRO_IDC_BACKPACK_ICON;
		private _ctrlScrollbarDummy = _storageCtrlGrp controlsGroupCtrl MACRO_IDC_SCROLLBAR_DUMMY;

		// Set the pixel precision mode of all frames to "OFF"
		{
			_x ctrlSetPixelPrecision 2;
		} forEach [
			_ctrlUniformFrame,
			_ctrlVestFrame,
			_ctrlBackpackFrame
		];

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

                // Determine the icon paths for the items and weapons that we have
                {
			private _frame = _x select 0;
			private _icon = _x select 1;
                        private _class = _classes param [_forEachIndex, ""];
			private _startYNew = _startY + _sizeY + _offsetY;

                        if (_class != "") then {
				private _default = _x select 2;
                                private _iconPath = [_class, _default] call cre_fnc_getClassIcon;
				//private _iconPath = "res\ui\inventory\weapon_frame.paa";

                                _icon ctrlSetText _iconPath;
                                _frame ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);

				// Save the slot's data
				_frame setVariable ["active", true];
				_frame setVariable ["childPicture1", _icon];
	                        _frame setVariable ["defaultIconPath", _default];
			};

			// Move the frame and icon controls
			{
				(ctrlPosition _x) params ["_posX", "", "_w", "_h"];
				_x ctrlSetPosition [
					_posX,
					_startY + _offsetY,
					_w,
					_h
				];
				_x ctrlCommit 0;
			} forEach [_frame, _icon];

			// Create the slots for this container
			private _maxLoad = floor getContainerMaxLoad _class;
			private _container = objNull;
			switch (_forEachIndex) do {
				case 0: {_container = uniformContainer player};
				case 1: {_container = vestContainer player};
				case 2: {_container = backpackContainer player};
			};
			private _currentLoad = [_container] call cre_fnc_getMass;

			if (_maxLoad > 0) then {
				for "_i" from 0 to (_maxLoad - 1) do {
					// Create the slot controls
					private _slotFrame = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedText", -1, _storageCtrlGrp];
					private _slotIcon = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedPicture", -1, _storageCtrlGrp];
					_slotFrame ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);
					_slotIcon ctrlSetText MACRO_PICTURE_SLOT_BACKGROUND;

					// Set the frame's pixel precision mode to off, disables rounding
					_slotFrame ctrlSetPixelPrecision 2;

					// Move the slot controls
					private _slotPos = [
						_startX + _slotSizeW * (_i % MACRO_SCALE_SLOT_COUNT_PER_LINE) * 1.0,
						_startYNew + _slotSizeH * floor (_i / MACRO_SCALE_SLOT_COUNT_PER_LINE) * 1.0,
						_slotSizeW,
						_slotSizeH
					];
					{
						_x ctrlSetPosition _slotPos;
						_x ctrlCommit 0;
					} forEach [_slotFrame, _slotIcon];

					// Paint used slots red
					if (_i < _currentLoad) then {
						_slotFrame ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);
					};
				};
			};

			_offsetY = _offsetY + _sizeY + _safeZoneH * (MACRO_SCALE_SLOT_SIZE_H * ceil (_maxLoad / MACRO_SCALE_SLOT_COUNT_PER_LINE) + 0.005);

                } forEach [
			[_ctrlUniformFrame,		_ctrlUniformIcon,		MACRO_PICTURE_UNIFORM],
			[_ctrlVestFrame,		_ctrlVestIcon,			MACRO_PICTURE_VEST],
			[_ctrlBackpackFrame,		_ctrlBackpackIcon,		MACRO_PICTURE_BACKPACK]
                ];

		// Move the scrollbar dummy
		private _pos = ctrlPosition _ctrlScrollbarDummy;
		_pos set [1, _offsetY];
		_ctrlScrollbarDummy ctrlSetPosition _pos;
		_ctrlScrollbarDummy ctrlCommit 0;
	};



        // Update the weapons menu
        case "ui_update_weapons": {
		_eventExists = true;
                // Grab some of our inventory controls
                private _ctrlPrimaryWeapon = _inventory displayCtrl MACRO_IDC_PRIMARYWEAPON_ICON;
                private _ctrlSecondaryWeapon = _inventory displayCtrl MACRO_IDC_SECONDARYWEAPON_ICON;
                private _ctrlHandgunWeapon = _inventory displayCtrl MACRO_IDC_HANDGUNWEAPON_ICON;

                // Determine the player's assigned items
                private _map = "";
                private _GPS = "";
                private _radio = "";
                private _compass = "";
                private _watch = "";
                {
                        private _simulation = [configfile >> "CfgWeapons" >> _x, "simulation", ""] call BIS_fnc_returnConfigEntry;
                        switch (_simulation) do {
                                case "ItemMap": {_map = _x};
                                case "ItemGPS": {_GPS = _x};
                                case "ItemRadio": {_radio = _x};
                                case "ItemCompass": {_compass = _x};
                                case "ItemWatch": {_watch = _x};
                        };
                } forEach assignedItems player;

                // Determine our classes array
                private _classes = [
                        hmd player,
                        headgear player,
                        goggles player,
                        binocular player,
                        primaryWeapon player,
			handgunWeapon player,
                        secondaryWeapon player,
                        _map,
                        _GPS,
                        _radio,
                        _compass,
                        _watch
                ];

                // Determine the icon paths for the items and weapons that we have
                {
                        private _class = _classes param [_forEachIndex, ""];

                        if (_class != "") then {
				private _frame = _x select 0;
                                private _icon = _x select 1;
				private _default = _x select 2;
                                private _iconPath = [_class, _default] call cre_fnc_getClassIcon;
				//private _iconPath = "res\ui\inventory\weapon_frame.paa";

                                _icon ctrlSetText _iconPath;
                                _frame ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);

                                // Save the slot's data
				_frame setVariable ["active", true];
				_frame setVariable ["childPicture1", _icon];
                                _frame setVariable ["defaultIconPath", _default];
                        };
                } forEach [
                        [_inventory displayCtrl MACRO_IDC_NVGS_FRAME,			_inventory displayCtrl MACRO_IDC_NVGS_ICON,		MACRO_PICTURE_NVGS],
                        [_inventory displayCtrl MACRO_IDC_HEADGEAR_FRAME,		_inventory displayCtrl MACRO_IDC_HEADGEAR_ICON,		MACRO_PICTURE_HEADGEAR],
                        [_inventory displayCtrl MACRO_IDC_GOGGLES_FRAME,		_inventory displayCtrl MACRO_IDC_GOGGLES_ICON,		MACRO_PICTURE_GOGGLES],
                        [_inventory displayCtrl MACRO_IDC_BINOCULARS_FRAME, 		_inventory displayCtrl MACRO_IDC_BINOCULARS_ICON,	MACRO_PICTURE_BINOCULARS],
                        [_inventory displayCtrl MACRO_IDC_PRIMARYWEAPON_FRAME, 		_ctrlPrimaryWeapon,					MACRO_PICTURE_PRIMARYWEAPON],
                        [_inventory displayCtrl MACRO_IDC_HANDGUNWEAPON_FRAME,		_ctrlHandgunWeapon,					MACRO_PICTURE_HANDGUNWEAPON],
                        [_inventory displayCtrl MACRO_IDC_SECONDARYWEAPON_FRAME,	_ctrlSecondaryWeapon,					MACRO_PICTURE_SECONDARYWEAPON],
                        [_inventory displayCtrl MACRO_IDC_MAP_FRAME, 			_inventory displayCtrl MACRO_IDC_MAP_ICON,		MACRO_PICTURE_MAP],
                        [_inventory displayCtrl MACRO_IDC_GPS_FRAME, 			_inventory displayCtrl MACRO_IDC_GPS_ICON,		MACRO_PICTURE_GPS],
                        [_inventory displayCtrl MACRO_IDC_RADIO_FRAME, 			_inventory displayCtrl MACRO_IDC_RADIO_ICON,		MACRO_PICTURE_RADIO],
                        [_inventory displayCtrl MACRO_IDC_COMPASS_FRAME, 		_inventory displayCtrl MACRO_IDC_COMPASS_ICON,		MACRO_PICTURE_COMPASS],
                        [_inventory displayCtrl MACRO_IDC_WATCH_FRAME,	 		_inventory displayCtrl MACRO_IDC_WATCH_ICON,		MACRO_PICTURE_WATCH]
                ];
        };



	// Update the weapons menu
	case "ui_update_medical": {
		_eventExists = true;
	};



	// Start dragging
	case "ui_dragging_start": {
		_eventExists = true;
		_args params [
			["_ctrl", controlNull, [controlNull]],
			["_button", 0, [0]]
		];

		// Only register left-clicks
		if (_button == 0) then {

			// Set the focus into the dedicated dummy control group (so that the control renders ontop of everything else)
			ctrlSetFocus (_inventory displayCtrl MACRO_IDC_EMPTY_FOCUS_FRAME);

			// Move the associated frame and picture to the cursor
			if (!isNull _ctrl and {_ctrl getVariable ["active", false]} and {ctrlShown _ctrl}) then {

				// Hide the original picture
				private _childPicture = _ctrl getVariable ["childPicture1", controlNull];
				_childPicture ctrlShow false;

				// Calculate the control's position offset and save it
				private _pos = ctrlPosition _ctrl;
				private _posOffset = [0,0];
				_ctrlParent = _ctrl;
				while {!isNull ctrlParentControlsGroup _ctrlParent} do {
					_ctrlParent = ctrlParentControlsGroup _ctrlParent;
					private _parentPos = ctrlPosition _ctrlParent;

					for "_i" from 0 to 1 do {
						_posOffset set [_i, (_posOffset select _i) + (_parentPos select _i)];
					};
				};
				_ctrl setVariable ["ctrlPosOffset", _posOffset];

	                        // Create a temporary picture that stays on the slot
	 			private _childPictureSlotTemp = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedPicture", MACRO_IDC_SCRIPTEDPICTURE, _ctrlParent];
	 			_childPictureSlotTemp ctrlSetText (_ctrl getVariable ["defaultIconPath", ""]);
				_childPictureSlotTemp ctrlSetPosition _pos;
				_childPictureSlotTemp ctrlCommit 0;
	 			_ctrl setVariable ["childPictureSlotTemp", _childPictureSlotTemp];

				// Create a temporary frame that follows the mouse
				private _childFrameTemp = _inventory displayCtrl MACRO_IDC_DRAGGING_FRAME;
				_childFrameTemp ctrlSetPosition _pos;
				_childFrameTemp ctrlCommit 0;
				_childFrameTemp ctrlShow true;

				// Change the colour of the original slot frame
				_ctrl ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);

				// Set up additional temporary dragging controls that follow the mouse
				private _childControlsTemp = [_childFrameTemp];
				{
					private _childPictureX = _ctrl getVariable [format ["childPicture%1", _forEachIndex], controlNull];
					if (!isNull _childPictureX) then {

						// Add the offset to the child's position
						private _posX = ctrlPosition _childPictureX;
						for "_i" from 0 to 1 do {
							_posX set [_i, (_posX select _i) + (_posOffset select _i)];
						};

						// Copy the child control's parameters
						_x ctrlSetText ctrlText _childPictureX;
						_x ctrlSetPosition _posX;
						_x ctrlCommit 0;
						_x ctrlShow true;
						_childControlsTemp pushBack _x;
					};
				} forEach [
					_inventory displayCtrl MACRO_IDC_DRAGGING_PICTURE_1,
					_inventory displayCtrl MACRO_IDC_DRAGGING_PICTURE_2,
					_inventory displayCtrl MACRO_IDC_DRAGGING_PICTURE_3,
					_inventory displayCtrl MACRO_IDC_DRAGGING_PICTURE_4,
					_inventory displayCtrl MACRO_IDC_DRAGGING_PICTURE_5,
					_inventory displayCtrl MACRO_IDC_DRAGGING_PICTURE_6,
					_inventory displayCtrl MACRO_IDC_DRAGGING_PICTURE_7
				];
				_ctrl setVariable ["childControlsTemp", _childControlsTemp];

				// Mark the control as being dragged
				_ctrl setVariable ["isBeingDragged", true];

				// Move the temporary controls if the mouse is moving
				_ctrl ctrlAddEventHandler ["MouseMoving", {
					params ["_ctrl"];
					getMousePosition params ["_posX", "_posY"];

					// Call the inventory function to handle dragging
					["ui_dragging", [_ctrl, _posX, _posY]] call cre_fnc_inventory;
				}];

				// Move the temporary controls in place initially
				getMousePosition params ["_posX", "_posY"];
				["ui_dragging", [_ctrl, _posX, _posY]] call cre_fnc_inventory;
			};
		};
	};



	// Dragging
	case "ui_dragging": {
		_eventExists = true;

		// Fetch the parameters
		_args params [
			["_ctrl", controlNull, [controlNull]],
			["_posX", 0, [0]],
			["_posY", 0, [0]]
		];

		private _posOffset = _ctrl getVariable ["ctrlPosOffset", [0,0]];
		{
			private _pos = ctrlPosition _x;
			_pos set [0, _posX - (_pos param [2, 0]) / 2];
			_pos set [1, _posY - (_pos param [3, 0]) / 2];

			_x ctrlSetPosition _pos;
			_x ctrlCommit 0;
		} forEach (_ctrl getVariable ["childControlsTemp", []]);
	};

	// Stop dragging
	case "ui_dragging_stop": {
		_eventExists = true;
		private _ctrl = _args param [0, controlNull];

		if (!isNull _ctrl and {_ctrl getVariable ["isBeingDragged", false]}) then {

			// Mark the control as not being dragged anymore
			_ctrl setVariable ["isBeingDragged", false];

			// Set the focus inside the control group back to its respective dummy control
			switch (ctrlParentControlsGroup _ctrl) do {
				case (_inventory displayCtrl MACRO_IDC_GROUND_CTRLGRP): {ctrlSetFocus (_inventory displayCtrl MACRO_IDC_GROUND_FOCUS_FRAME)};
				case (_inventory displayCtrl MACRO_IDC_WEAPONS_CTRLGRP): {ctrlSetFocus (_inventory displayCtrl MACRO_IDC_WEAPONS_FOCUS_FRAME)};
				case (_inventory displayCtrl MACRO_IDC_MEDICAL_CTRLGRP): {ctrlSetFocus (_inventory displayCtrl MACRO_IDC_MEDICAL_FOCUS_FRAME)};
				case (_inventory displayCtrl MACRO_IDC_STORAGE_CTRLGRP): {ctrlSetFocus (_inventory displayCtrl MACRO_IDC_STORAGE_FOCUS_FRAME)};
			};

			// Only continue if the control is active
			if (_ctrl getVariable ["active", false] and {ctrlShown _ctrl}) then {

				// Reset the colour of the original slot frame
				_ctrl ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);

				_ctrl ctrlRemoveAllEventHandlers "MouseMoving";

				// Unhide the child picture
				(_ctrl getVariable ["childPicture1", controlNull]) ctrlShow true;

				// Delete the temporary slot picture
				ctrlDelete (_ctrl getVariable ["childPictureSlotTemp", controlNull]);

				// Hide the dragging controls
				{
					_x ctrlShow false;
				} forEach (_ctrl getVariable ["childControlsTemp", []]);
			};
		};
	};
};





// DEBUG: Check if the event was recognised - if not, print a message
if (!_eventExists) then {
	private _str = format ["(%1) [INVENTORY] ERROR: Unknown event '%2' called!", time, _event];
	systemChat _str;
	hint _str;
};
