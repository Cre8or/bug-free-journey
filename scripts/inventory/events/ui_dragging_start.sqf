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

	        // Set the focus into the parent group of the passed control, so it moves ontop of everything else
	        switch (ctrlParentControlsGroup _ctrl) do {
	                case (_inventory displayCtrl MACRO_IDC_GROUND_CTRLGRP): {ctrlSetFocus (_inventory displayCtrl MACRO_IDC_GROUND_FOCUS_FRAME)};
	                case (_inventory displayCtrl MACRO_IDC_WEAPONS_CTRLGRP): {ctrlSetFocus (_inventory displayCtrl MACRO_IDC_WEAPONS_FOCUS_FRAME)};
	                case (_inventory displayCtrl MACRO_IDC_MEDICAL_CTRLGRP): {ctrlSetFocus (_inventory displayCtrl MACRO_IDC_MEDICAL_FOCUS_FRAME)};
	                case (_inventory displayCtrl MACRO_IDC_STORAGE_CTRLGRP): {ctrlSetFocus (_inventory displayCtrl MACRO_IDC_STORAGE_FOCUS_FRAME)};
	        };

                // Next we shift the focus into the dummy controls group to force the temporary controls to the top
                ctrlSetFocus (_inventory displayCtrl MACRO_IDC_EMPTY_FOCUS_FRAME);

                // Move the associated frame and picture to the cursor
                if (!isNull _ctrl and {_ctrl getVariable ["active", false]} and {ctrlShown _ctrl}) then {

			// Fetch the control's item class and its associated size
			private _class = _ctrl getVariable ["class", ""];
			private _category = [_class] call cre_fnc_getClassCategory;
			private _slotSize = [_class, _category] call cre_fnc_getClassSlotSize;
			private _defaultIconPath = _ctrl getVariable ["defaultIconPath", ""];
			private _safeZoneW = uiNamespace getVariable ["Cre8ive_Inventory_SafeZoneW", 0];
			private _safeZoneH = uiNamespace getVariable ["Cre8ive_Inventory_SafeZoneH", 0];

                        // Hide the original child controls
                        private _childControls = _ctrl getVariable ["childControls", []];
                        {
				_x  ctrlShow false;
			} forEach _childControls;

                        // Create a temporary picture that stays on the slot
			private _posCtrl = ctrlPosition _ctrl;
                        private _ctrlIconTemp = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedPicture", MACRO_IDC_SCRIPTEDPICTURE, ctrlParentControlsGroup _ctrl];
                        _ctrlIconTemp ctrlSetText _defaultIconPath;
                        _ctrlIconTemp ctrlSetPosition _posCtrl;
                        _ctrlIconTemp ctrlCommit 0;
                        _ctrl setVariable ["ctrlIconTemp", _ctrlIconTemp];

			// Update the size
			_posCtrl set [2, (_slotSize select 0) * _safeZoneW * MACRO_SCALE_SLOT_SIZE_W];
			_posCtrl set [3, (_slotSize select 1) * _safeZoneH * MACRO_SCALE_SLOT_SIZE_H];

                        // Create a temporary frame that follows the mouse
                        private _ctrlFrameTemp = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedBox", -1];
                        _ctrlFrameTemp ctrlSetPosition _posCtrl;
                        _ctrlFrameTemp ctrlCommit 0;
                        _ctrlFrameTemp ctrlShow true;
			_ctrlFrameTemp ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);
			_ctrl setVariable ["ctrlFrameTemp", _ctrlFrameTemp];

			// Set the frame's pixel precision mode to off, disables rounding
                        _ctrlFrameTemp ctrlSetPixelPrecision 2;

                        // Change the colour of the original slot frame
                        _ctrl ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);

			// Generate additional child controls
			private _childControls = [_ctrlFrameTemp, _class, _category, _slotSize, _defaultIconPath] call cre_fnc_generateChildControls;

// -------------------- TODO: Iterate through the new child controls and determine their offset to the temp frame! ------------------------------------------------------------------------
			{
				private _posX = ctrlPosition _x;
				private _posOffset = [
					(_posX select 0) - (_posCtrl select 0),
					(_posX select 1) - (_posCtrl select 1)
				];
				_x setVariable ["offset", _posOffset];
			} forEach _childControls;

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
