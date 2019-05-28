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

	// Remove the eachFrame EH
	private _EH = missionNamespace getVariable [MACRO_VARNAME_UI_EH_EACHFRAME, -1];
	if (_EH >= 0) then {
		removeMissionEventHandler ["EachFrame", _EH];
	 	missionNamespace setVariable [MACRO_VARNAME_UI_EH_EACHFRAME, -1, false];
	};

	// Remove the ground namespace
	deleteLocation (_inventory getVariable [MACRO_VARNAME_UI_GROUND_NAMESPACE, locationNull]);
};
