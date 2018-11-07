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
        private _posOffset = _ctrl getVariable ["ctrlPosOffset", [0,0]];
        {
                private _pos = ctrlPosition _x;
                _pos set [0, _posX - (_pos param [2, 0]) / 2];
                _pos set [1, _posY - (_pos param [3, 0]) / 2];

                _x ctrlSetPosition _pos;
                _x ctrlCommit 0;
        } forEach (_ctrl getVariable ["childControlsTemp", []]);
};
