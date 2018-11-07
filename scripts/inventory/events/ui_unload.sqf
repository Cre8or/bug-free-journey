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
