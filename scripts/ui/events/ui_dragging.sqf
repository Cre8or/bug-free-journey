// Dragging
case "ui_dragging": {
	_eventExists = true;

	// Fetch the parameters
	_args params [
		["_ctrl", controlNull, [controlNull]],
		["_posX", 0, [0]],
		["_posY", 0, [0]]
	];

	// Position the dragged controls
	private _ctrlFrameTemp = _inventory getVariable [MACRO_VARNAME_UI_FRAMETEMP, controlNull];
	private _posCtrl = ctrlPosition _ctrlFrameTemp;
	{
		// Fetch the offset
		private _posOffset = _x getVariable ["offset", [0,0]];

		// Apply the offset
		private _pos = ctrlPosition _x;
		_pos set [0, _posX + (_posOffset select 0) - (_posCtrl select 2) / 2];
		_pos set [1, _posY + (_posOffset select 1) - (_posCtrl select 3) / 2];

		_x ctrlSetPosition _pos;
		_x ctrlCommit 0;
	} forEach ((_ctrlFrameTemp getVariable [MACRO_VARNAME_UI_CHILDCONTROLS, []]) + [_ctrlFrameTemp]);
};
