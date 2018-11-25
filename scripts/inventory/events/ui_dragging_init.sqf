// Initialise the dragging process
case "ui_dragging_init": {
	_eventExists = true;

	// Fetch the parameters
	_args params [
		["_ctrl", controlNull, [controlNull]],
		["_button", 0, [0]]
	];

	// Only register left-clicks
	if (_button == 0) then {

		// If we're not dragging anything yet, set everything up (phase 1)
		if (!isNull _ctrl and {_ctrl getVariable ["active", false]} and {ctrlShown _ctrl}) then {

			// Reset the focus
			["ui_focus_reset", [_ctrl]] call cre_fnc_inventory;

			if (isNull (_inventory getVariable [MACRO_VARNAME_UI_DRAGGEDCTRL, controlNull])) then {

				// Change the colour of the slot frame
				_ctrl ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE_HOVER);

				// Remember which control we're dragging
				_inventory setVariable [MACRO_VARNAME_UI_DRAGGEDCTRL, _ctrl];

				// Add an event handler to the inventory to detect the mouse release
				private _EH = _inventory displayAddEventHandler ["MouseButtonUp", {
					["ui_dragging_start", _this] call cre_fnc_inventory;
				}];
				_inventory setVariable [MACRO_VARNAME_UI_EH_MOUSEBUTTONUP, _EH];

				// DEBUG
				private _data = _ctrl getVariable [MACRO_VARNAME_DATA, locationNull];
				private _str = format ["VARIABLES (%1):\n\n", count allVariables _data];
				{
					private _val = _data getVariable [_x, ""];

					if (_val isEqualType locationNull) then {
						_str = _str + format ["* %1: %2\n[", _x, _val getVariable [MACRO_VARNAME_UID, ""]];
						{
							_str = _str + _x;
							if (_forEachIndex + 1 < count allVariables _val) then {
								_str = _str + ", ";
							};
						} forEach allVariables _val;
						_str = _str + "]\n";
					} else {
						_str = _str + format ["* %1: %2", _x, _val] + "\n";
					};
				} forEach allVariables _data;
				hint _str;
			};
		};
	};
};
