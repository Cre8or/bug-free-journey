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
                                ["ui_update_storage"] call cre_fnc_inventory;

                                // Set the focus on something unimportant (to avoid triggering the close button with space)
                                ctrlSetFocus (_inventory displayCtrl MACRO_IDC_EMPTY_FOCUS_FRAME);
                        };
                };
        };
};
