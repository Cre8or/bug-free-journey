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
					private _containerData = [player, "", false] call cre_fnc_inv_generateContainerData;
					_containerData setVariable [MACRO_VARNAME_CONTAINER, player];
					player setVariable [MACRO_VARNAME_DATA, _containerData];
				};

				// Update the ground menu
				["ui_update_ground"] call cre_fnc_ui_inventory;

				// Load the weapons menu (default)
				["ui_menu_weapons"] call cre_fnc_ui_inventory;

				// Update the storage menu
				["ui_update_storage"] call cre_fnc_ui_inventory;

				// Set the pixel precision mode of all slot frames to "OFF"
				{
					_x ctrlSetPixelPrecision 2;
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
				private _EH = addMissionEventHandler ["EachFrame", {

					// Fetch the time and the inventory display
					private _time = time;
					private _inventory = uiNamespace getVariable ["cre8ive_dialog_inventory", displayNull];

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
				}];
				missionNamespace setVariable [MACRO_VARNAME_UI_EH_EACHFRAME, _EH, false];

				// Reset the focus
				["ui_focus_reset"] call cre_fnc_ui_inventory;
/*
				// DEBUG - Print the cursor control
				[_inventory] spawn {
					disableSerialization;
					params ["_inventory"];

					while {!isNull _inventory} do {

						private _str = str (_inventory getVariable [MACRO_VARNAME_UI_DRAGGEDCTRL, controlNull]) + "<br />";
						_str = _str + str (_inventory getVariable [MACRO_VARNAME_UI_FRAMETEMP, controlNull]) + "<br />";
						//_str = _str + "count: " + str count (_inventory getVariable [MACRO_VARNAME_UI_HIGHLITCONTROLS, []]) + "<br />";
						//_str = _str + "posNew: " + str (_inventory getVariable [MACRO_VARNAME_UI_CURSORPOSNEW, []]);

						hint parseText _str;

						sleep 0.1;
					};

					hint "";
				};
*/
			};
		};
	};
};
