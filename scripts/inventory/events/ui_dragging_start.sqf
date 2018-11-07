// Start dragging
case "ui_dragging_start": {
        _eventExists = true;

	// Fetch the parameters
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

			// Fetch the control's item class and its associated size
			private _class = _ctrl getVariable ["class", ""];
			private _category = [_class] call cre_fnc_getClassCategory;
			private _slotSize = [_class, _category] call cre_fnc_getClassSlotSize;
			private _safeZoneW = uiNamespace getVariable ["Cre8ive_Inventory_SafeZoneW", 0];
			private _safeZoneH = uiNamespace getVariable ["Cre8ive_Inventory_SafeZoneH", 0];

                        // Hide the original picture
                        private _childPicture = _ctrl getVariable ["childPictureIcon", controlNull];
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
                        //_ctrl setVariable ["ctrlPosOffset", _posOffset];
                        // -------------------- TODO: Check if this is still needed ^ ------------------------------------------------------------------------------------------------------------------------------------------------------

                        // Create a temporary picture that stays on the slot
                        private _childPictureSlotTemp = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedPicture", MACRO_IDC_SCRIPTEDPICTURE, _ctrlParent];
                        _childPictureSlotTemp ctrlSetText (_ctrl getVariable ["defaultIconPath", ""]);
                        _childPictureSlotTemp ctrlSetPosition _pos;
                        _childPictureSlotTemp ctrlCommit 0;
                        _ctrl setVariable ["childPictureSlotTemp", _childPictureSlotTemp];

			// Update the size
			_pos set [2, (_slotSize select 0) * _safeZoneW * MACRO_SCALE_SLOT_SIZE_W];
			_pos set [3, (_slotSize select 1) * _safeZoneH * MACRO_SCALE_SLOT_SIZE_H];

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
                                private _childPictureX = _ctrl getVariable [format ["childPictureIcon", _forEachIndex], controlNull];
                                if (!isNull _childPictureX) then {

                                        // Add the offset to the child's position
                                        private _posX = ctrlPosition _childPictureX;
                                        for "_i" from 0 to 1 do {
                                                _posX set [_i, (_posX select _i) + (_posOffset select _i)];
                                        };

					// Scale the elements according to the slot size
					_posX set [2, _pos select 2];
					_posX set [3, _pos select 3];

                                        // Copy the child control's parameters
                                        _x ctrlSetText ctrlText _childPictureX;
                                        _x ctrlSetPosition _posX;
                                        _x ctrlCommit 0;
                                        _x ctrlShow true;
                                        _childControlsTemp pushBack _x;
                                };
                        } forEach [
                                _inventory displayCtrl MACRO_IDC_DRAGGING_PICTURE_ICON,
                                _inventory displayCtrl MACRO_IDC_DRAGGING_PICTURE_ATTACHMENT_MUZZLE,
                                _inventory displayCtrl MACRO_IDC_DRAGGING_PICTURE_ATTACHMENT_BIPOD,
                                _inventory displayCtrl MACRO_IDC_DRAGGING_PICTURE_ATTACHMENT_RAIL,
                                _inventory displayCtrl MACRO_IDC_DRAGGING_PICTURE_ATTACHMENT_OPTIC,
                                _inventory displayCtrl MACRO_IDC_DRAGGING_PICTURE_ATTACHMENT_MAGAZINE,
                                _inventory displayCtrl MACRO_IDC_DRAGGING_PICTURE_ATTACHMENT_ALTMAGAZINE
                        ];
                        _ctrl setVariable ["childControlsTemp", _childControlsTemp];

                        // Mark the control as being dragged
                        _ctrl setVariable ["isBeingDragged", true];

			// Remember which control we're dragging
			_inventory setVariable ["draggedControl", _ctrl];

                        // Move the temporary controls if the mouse is moving
                        _inventory displayAddEventHandler ["MouseMoving", {
				params ["_inventory"];
				private _ctrl = _inventory getVariable ["draggedControl", controlNull];

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
