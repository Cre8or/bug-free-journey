// Initialisation
case "ui_init": {
	_eventExists = true;

	//private _pos = [0, 0];
	//missionNamespace setVariable [MACRO_VARNAME_UI_LASTMOUSEPOS, _pos];
	//setMousePosition _pos;

	_args spawn {

		// Fetch our params
		_this params [
			["_activeContainer", objNull, [objNull]]
		];

		// Create the inventory display
		(findDisplay 46) createDisplay "Rsc_Cre8ive_Inventory";
		//createDialog "Rsc_Cre8ive_Inventory";

		private _timeOut = time + 1;
		waitUntil {!isNull (uiNamespace getVariable ["cre8ive_dialog_inventory", displayNull]) or {time > _timeOut}};

		if (time > _timeOut) then {
			systemChat "Couldn't open inventory!";
		} else {
			//sleep 0.1;

			// Escape scheduled environment
			isNil {
				private _timeStart = diag_tickTime;
				private _activeContainerType = typeOf _activeContainer;

				// Fetch the inventory
				private _inventory = uiNamespace getVariable ["cre8ive_dialog_inventory", displayNull];

				// Validate the active container object and write it onto the inventory display
				if !(_activeContainerType in MACRO_CLASSES_GROUNDHOLDERS) then {

					if ([_activeContainer] call cre_fnc_inv_canHoldInventory) then {
						if (isNull (_activeContainer getVariable [MACRO_VARNAME_DATA, locationNull])) then {
							[_activeContainer, _activeContainerType, MACRO_ENUM_CONFIGTYPE_CFGVEHICLES] call cre_fnc_inv_generateContainerData;
						};
					};

					_inventory setVariable [MACRO_VARNAME_UI_ACTIVECONTAINER, _activeContainer];
				};
				_inventory setVariable [MACRO_VARNAME_UI_ACTIVECONTAINER_VISIBLE, true];

				// Write down the player's name
				(_inventory displayCtrl MACRO_IDC_PLAYER_NAME) ctrlSetText name player;

				// Attach an EH to the inventory to detect when it is closed
				_inventory displayAddEventHandler ["Unload", {
					["ui_unload"] call cre_fnc_ui_inventory;
				}];

				// Set up the blur post-process effect
				private _blurFX = missionNamespace getVariable ["Cre8ive_Inventory_BlurFX", 0];
				if (_blurFX <= 0) then {
					private _index = _indexStart;
					while {
						_blurFX = ppEffectCreate ["DynamicBlur", _index];
						_blurFX < 0
					} do {
						_index = _index + 1;
					};

					_blurFX ppEffectEnable true;
				};

				// Start the post-process effect and save the handle for later use
				_blurFX ppEffectAdjust [3];
				_blurFX ppEffectCommit 0;
				missionNamespace setVariable  ["Cre8ive_Inventory_blurFX", _blurFX, false];

				// Stop the action menu from interfering
				inGameUISetEventHandler ["PrevAction", "true"];
				inGameUISetEventHandler ["NextAction", "true"];
				inGameUISetEventHandler ["Action", "true"];

				// Close the commanding menu if it is open
				if (commandingMenu != "") then {showCommandingMenu ""};

				// If the player doesn't have any data yet, generate it
				// ---- DEBUG: Remove "true"! v --------------------------------------------------------------------------------
				// TODO: Move this into mission init (or similar) so that this data is available even if the inventory hasn't been opened yet!
				if (false or isNull (player getVariable [MACRO_VARNAME_DATA, locationNull])) then {
					private _containerData = [player, "", MACRO_ENUM_CONFIGTYPE_CFGVEHICLES, objNull, [0,0], false] call cre_fnc_inv_generateContainerData;
					_containerData setVariable [MACRO_VARNAME_CONTAINER, player];
					player setVariable [MACRO_VARNAME_DATA, _containerData];
				};

				// Prepare the storage menu
				// TODO: Make this value depend on the framerate?
				_inventory setVariable [MACRO_VARNAME_UI_STORAGE_MAXITERATIONS, 10];	// Amount of slot controls to generate, per frame

				// Update the ground menu
				["ui_update_ground"] call cre_fnc_ui_inventory;

				// Load the weapons menu (default)
				["ui_menu_weapons"] call cre_fnc_ui_inventory;

				// Update the storage menu
				["ui_update_storage"] call cre_fnc_ui_inventory;

				// Set the pixel precision mode of all slot frames to "OFF"
				{
					_x ctrlSetPixelPrecision MACRO_GLOBAL_PIXELPRECISIONMODE;
				} forEach [
					_inventory displayCtrl MACRO_IDC_GROUND_DROP_FRAME,
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
					_inventory displayCtrl MACRO_IDC_WATCH_FRAME,
					_inventory displayCtrl MACRO_IDC_UNIFORM_FRAME,
					_inventory displayCtrl MACRO_IDC_VEST_FRAME,
					_inventory displayCtrl MACRO_IDC_BACKPACK_FRAME
				];

				// Add an event handler to the mission that handles the inventory's onEachFrame code
				private _EH = missionNamespace getVariable [MACRO_VARNAME_UI_EH_EACHFRAME, -1];
				if (_EH < 0) then {
					_EH = addMissionEventHandler ["EachFrame", {

						// Fetch the time and the inventory display
						private _time = time;
						private _inventory = uiNamespace getVariable ["cre8ive_dialog_inventory", displayNull];

						// If the inventory no longer exists, exit and remove this EH
						if (isNull _inventory) exitWith {
							removeMissionEventHandler ["EachFrame", missionNamespace getVariable [MACRO_VARNAME_UI_EH_EACHFRAME, -1]];
						 	missionNamespace setVariable [MACRO_VARNAME_UI_EH_EACHFRAME, -1, false];
						};

						// Check if the temporary frame exists
						private _ctrlFrameTemp = _inventory getVariable [MACRO_VARNAME_UI_FRAMETEMP, controlNull];
						if (!isNull _ctrlFrameTemp) then {

							// If it exists, but we're not dragging anything, call the abort event (which then removes it)
							private _draggedCtrl = _inventory getVariable [MACRO_VARNAME_UI_DRAGGEDCTRL, controlNull];
							if (isNull _draggedCtrl) then {
								["ui_dragging_abort"] call cre_fnc_ui_inventory;
							};
						};

						// Check if we should update the ground menu
						if (_time > (_inventory getVariable [MACRO_VARNAME_UI_NEXTUPDATE_GROUND, 0])) then {
							_inventory setVariable [MACRO_VARNAME_UI_NEXTUPDATE_GROUND, _time + MACRO_GROUND_UPDATE_DELAY];

							["ui_update_ground"] call cre_fnc_ui_inventory;
						};

						private _curMousePos = getMousePosition;
						private _lastMousePos = missionNamespace getVariable [MACRO_VARNAME_UI_LASTMOUSEPOS, [999, 999]];

						// Save the mouse position
						if (_inventory getVariable [MACRO_VARNAME_UI_LASTMOUSEPOS_LOADED, false]) then {
							if !(_curMousePos isEqualTo (missionNamespace getVariable [MACRO_VARNAME_UI_LASTMOUSEPOS, [0.5, 0.5]])) then {
								missionNamespace setVariable [MACRO_VARNAME_UI_LASTMOUSEPOS, _curMousePos, false];
								//systemChat format ["Saving: %1", _curMousePos];
							};

						// If the mouse position hasn't glitched out yet, wait for it to happen
						} else {
							if (_lastMousePos isEqualTo [999, 999]) then {
								missionNamespace setVariable [MACRO_VARNAME_UI_LASTMOUSEPOS, _curMousePos];
							} else {
								private _deltaX = (((_lastMousePos select 0) max 0) min 1) - 0.5;
								private _deltaY = (((_lastMousePos select 1) max 0) min 1) - 0.5;
								private _calcPos = [
									0.5 + _deltaX * safeZoneW,
									0.5 + _deltaY * safeZoneH
								];
								//systemChat format ["Calc: %1", _calcPos];

								// Check if the cursor has jumped to the predicted position
								if (_curMousePos distanceSqr _calcPos < 0.00001) then {		// pixelW ~= pixelH ~= 0.001 (1 pixel radius)
									//systemChat format ["Offset: %1    dist: %2", _curMousePos, _curMousePos distance _calcPos];
									//systemChat format ["Loading: %1", missionNamespace getVariable [MACRO_VARNAME_UI_LASTMOUSEPOS, [0.5, 0.5]]];
									setMousePosition (missionNamespace getVariable [MACRO_VARNAME_UI_LASTMOUSEPOS, [0.5, 0.5]]);
									_inventory setVariable [MACRO_VARNAME_UI_LASTMOUSEPOS_LOADED, true];

								// Otherwise, check if the user has moved the cursor before it could jump
								} else {
									if (_curMousePos distanceSqr _lastMousePos > 0.01) then {
										missionNamespace setVariable [MACRO_VARNAME_UI_LASTMOUSEPOS, _curMousePos, false];
										//systemChat format ["Saving (override): %1", _curMousePos];
										_inventory setVariable [MACRO_VARNAME_UI_LASTMOUSEPOS_LOADED, true];
									};
								};
							};
						};
					}];
					missionNamespace setVariable [MACRO_VARNAME_UI_EH_EACHFRAME, _EH, false];
				};

				// Reset the focus
				["ui_focus_reset"] call cre_fnc_ui_inventory;
/*
				// DEBUG - Print the cursor control
				[_inventory] spawn {
					disableSerialization;
					params ["_inventory"];

					while {!isNull _inventory} do {

						private _str = str (_inventory getVariable [MACRO_VARNAME_UI_DRAGGEDCTRL, controlNull]) + "<br />";
						_str = _str + str (_inventory getVariable [MACRO_VARNAME_UI_FRAMETEMP, controlNull]) + " - " + str ((_inventory getVariable [MACRO_VARNAME_UI_FRAMETEMP, controlNull]) getVariable [MACRO_VARNAME_ISROTATED, "???"]) + "<br />";
						_str = _str + str (_inventory getVariable [MACRO_VARNAME_UI_ICONTEMP, controlNull]) + "<br />";
						//_str = _str + "count: " + str count (_inventory getVariable [MACRO_VARNAME_UI_HIGHLITCONTROLS, []]) + "<br />";
						//_str = _str + "posNew: " + str (_inventory getVariable [MACRO_VARNAME_UI_CURSORPOSNEW, []]);

						hint parseText _str;

						sleep 0.1;
					};

					hint "";
				};
*/
				//hint format ["Opened in %1s", diag_tickTime - _timeStart];
			};
		};
	};
};
