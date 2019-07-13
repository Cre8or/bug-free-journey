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

		// Reset the focus
		["ui_focus_reset", [_ctrl]] call cre_fnc_ui_inventory;

		// If we're not dragging anything yet, set everything up (phase 1)
		if (!isNull _ctrl and {!isNull (_ctrl getVariable [MACRO_VARNAME_DATA, locationNull])} and {isNull (_inventory getVariable [MACRO_VARNAME_UI_DRAGGEDCTRL, controlNull])} and {ctrlShown _ctrl}) then {

			if (isNull (_inventory getVariable [MACRO_VARNAME_UI_DRAGGEDCTRL, controlNull])) then {

				// Change the colour of the slot frame
				_ctrl ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE_HOVER);

				// Remember which control we're dragging
				_inventory setVariable [MACRO_VARNAME_UI_DRAGGEDCTRL, _ctrl];

				// Add an event handler to the inventory to detect the mouse release
				private _EH = _inventory displayAddEventHandler ["MouseButtonUp", {
					["ui_dragging_start", _this] call cre_fnc_ui_inventory;
				}];
				_inventory setVariable [MACRO_VARNAME_UI_EH_MOUSEBUTTONUP, _EH];

				// DEBUG
				private _data = _ctrl getVariable [MACRO_VARNAME_DATA, locationNull];
				private _namespaceToDebug = _data; //player getVariable [MACRO_VARNAME_DATA, locationNull];
				private _maxDepth = 5;
				private _str = format ["<t color='#00aaff'>VARIABLES</t> (%1)<br /><br />", count allVariables _namespaceToDebug];
				{
					private _val = _namespaceToDebug getVariable [_x, ""];

					// Filter slot variables
					if ((_x select [0, 5]) == "slot_") then {
						if (!isNull _val) then {
							_str = _str + format ["<t align='left'><t color='#888888'>%1:</t> <t color='#e06c75'>%2:</t> <t color='#%a3d87d'>%3</t><br /></t>", _forEachIndex + 1, _x, _val getVariable [MACRO_VARNAME_UID, ""]];
						};
					} else {

						if (_val isEqualType locationNull) then {
							private _countVars = count allVariables _val;
							if (_countVars > 0) then {
								_str = _str + format ["<t align='left'><t color='#888888'>%1:</t> <t color='#e06c75'>%2:</t> <t color='#%a3d87d'>%3</t><br />    [</t>", _forEachIndex + 1, _x, _val getVariable [MACRO_VARNAME_UID, ""]];
								{
									if (_forEachIndex + 1 <= _maxDepth) then {
										_str = _str + format ["<t align='left'><t color='#44dddd'>%1</t>", _x];
										if (_forEachIndex + 1 == _maxDepth) then {
											if (_countVars > _maxDepth) then {
												_str = _str + format [", ... <t color='#888888'>(%1 more)</t>", _countVars - _maxDepth];
											};
										} else {
											if (_forEachIndex + 1 < _countVars) then {
												_str = _str + ",   ";
											};
										};
									};
								} forEach allVariables _val;
								_str = _str + "]<br />";
							} else {
								_str = _str + format ["<t align='left'><t color='#888888'>%1:</t> <t color='#e06c75'>%2</t></t><br />", _forEachIndex + 1, _x];
							};
						} else {
							private _colourVal = "ffffff";
							switch (typeName _val) do {
								case typeName objNull;
								case typeName locationNull;
								case typeName true;
								case typeName 0: {_colourVal = "eda765"};
								case typeName "": {_colourVal = "a3d87d"};
							};
							_str = _str + format ["<t align='left'><t color='#888888'>%1:</t> <t color='#e06c75'>%2:</t> <t color='#%3'>%4</t></t><br />", _forEachIndex + 1, _x, _colourVal, _val];
						};
					};
				} forEach allVariables _namespaceToDebug;
				hint parseText _str;
			};
		};
	};
};
