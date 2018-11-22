// Start dragging
case "ui_dragging_start": {
	_eventExists = true;

	// Fetch the parameters
	_args params [
		"",
		["_button", 0, [0]]
	];

	// Only register left-clicks
	if (_button == 0) then {

		// Fetch the control
		private _ctrl = _inventory getVariable [MACRO_VARNAME_UI_DRAGGEDCTRL, controlNull];

		// Only continue if the control still exists
		if (!isNull _ctrl) then {

			// Set the focus into the parent group of the passed control, so it moves ontop of everything else
			switch (ctrlParentControlsGroup _ctrl) do {
				case (_inventory displayCtrl MACRO_IDC_GROUND_CTRLGRP): {ctrlSetFocus (_inventory displayCtrl MACRO_IDC_GROUND_FOCUS_FRAME)};
				case (_inventory displayCtrl MACRO_IDC_WEAPONS_CTRLGRP): {ctrlSetFocus (_inventory displayCtrl MACRO_IDC_WEAPONS_FOCUS_FRAME)};
				case (_inventory displayCtrl MACRO_IDC_MEDICAL_CTRLGRP): {ctrlSetFocus (_inventory displayCtrl MACRO_IDC_MEDICAL_FOCUS_FRAME)};
				case (_inventory displayCtrl MACRO_IDC_STORAGE_CTRLGRP): {ctrlSetFocus (_inventory displayCtrl MACRO_IDC_STORAGE_FOCUS_FRAME)};
			};

			// Next we shift the focus into the dummy controls group to force the temporary controls to the top
			ctrlSetFocus (_inventory displayCtrl MACRO_IDC_EMPTY_FOCUS_FRAME);

			// Only continue if the control isn't already being dragged
			if !(_ctrl getVariable [MACRO_VARNAME_UI_ISBEINGDRAGGED, false]) then {

				// Change the colour of the slot frame to indicate that it's being dragged
				_ctrl ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);

				// Fetch the control's item class and its associated size
				private _class = _ctrl getVariable [MACRO_VARNAME_CLASS, ""];
				private _category = [_class] call cre_fnc_getClassCategory;
				private _slotSize = [_class, _category] call cre_fnc_getClassSlotSize;
				private _defaultIconPath = _ctrl getVariable ["defaultIconPath", ""];
				private _safeZoneW = uiNamespace getVariable ["Cre8ive_Inventory_SafeZoneW", 0];
				private _safeZoneH = uiNamespace getVariable ["Cre8ive_Inventory_SafeZoneH", 0];
				private _posCtrl = ctrlPosition _ctrl;

				// Hide the original child controls
				private _childControls = _ctrl getVariable [MACRO_VARNAME_UI_CHILDCONTROLS, []];
				{
					_x ctrlShow false;
				} forEach _childControls;

				// Create a temporary picture that stays on the slot
				if (_defaultIconPath != "") then {
					private _ctrlIconTemp = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedPicture", MACRO_IDC_SCRIPTEDPICTURE, ctrlParentControlsGroup _ctrl];
					_ctrlIconTemp ctrlSetText _defaultIconPath;
					_ctrlIconTemp ctrlSetPosition _posCtrl;
					_ctrlIconTemp ctrlCommit 0;
					_ctrl setVariable [MACRO_VARNAME_UI_ICONTEMP, _ctrlIconTemp];
				};

				// Update the size
				_posCtrl set [2, (_slotSize select 0) * _safeZoneW * MACRO_SCALE_SLOT_SIZE_W];
				_posCtrl set [3, (_slotSize select 1) * _safeZoneH * MACRO_SCALE_SLOT_SIZE_H];

				// Create a temporary frame that follows the mouse
				private _ctrlFrameTemp = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedBox", -1];
				_ctrlFrameTemp ctrlSetPosition _posCtrl;
				_ctrlFrameTemp ctrlCommit 0;
				_ctrlFrameTemp ctrlShow true;
				_ctrlFrameTemp ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);
				_ctrl setVariable [MACRO_VARNAME_UI_FRAMETEMP, _ctrlFrameTemp];

				// Set the frame's pixel precision mode to off, disables rounding
				_ctrlFrameTemp ctrlSetPixelPrecision 2;

				// Copy the original control's item data onto the dummy frame
				private _data = _ctrl getVariable [MACRO_VARNAME_DATA, locationNull];
				_ctrlFrameTemp setVariable [MACRO_VARNAME_DATA, _data];

				// Generate additional child controls
				private _childControls = [_ctrlFrameTemp, _class, _category, _slotSize, _defaultIconPath] call cre_fnc_generateChildControls;

				// Determine the offset of the child controls in relation to the temporary frame
				{
					private _posX = ctrlPosition _x;
					private _posOffset = [
						(_posX select 0) - (_posCtrl select 0),
						(_posX select 1) - (_posCtrl select 1)
					];
					_x setVariable ["offset", _posOffset];
				} forEach _childControls;

				// Mark the control as being dragged
				_ctrl setVariable [MACRO_VARNAME_UI_ISBEINGDRAGGED, true];

				// Remove the MouseButtonUp event handler
				private _EH = _inventory getVariable [MACRO_VARNAME_UI_EH_MOUSEBUTTONUP, -1];
				_inventory displayRemoveEventHandler ["MouseButtonUp", _EH];

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

				// Add an event handler to the inventory to detect mouse presses
				private _EH = _inventory displayAddEventHandler ["MouseButtonDown", {
					_this params ["", "_button"];

					switch (_button) do {
						case 0: {["ui_dragging_stop"] call cre_fnc_inventory};
						case 1: {["ui_dragging_abort"] call cre_fnc_inventory};
					};
				}];
				_inventory setVariable [MACRO_VARNAME_UI_EH_MOUSEBUTTONDOWN, _EH];

			};
		};
	};
};
