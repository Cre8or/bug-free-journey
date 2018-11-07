// Load the storage menu
case "ui_update_storage": {
        _eventExists = true;

        // Grab some of our inventory controls
        private _storageCtrlGrp = _inventory displayCtrl MACRO_IDC_STORAGE_CTRLGRP;
        private _ctrlUniformFrame = _storageCtrlGrp controlsGroupCtrl MACRO_IDC_UNIFORM_FRAME;
        private _ctrlUniformIcon = _storageCtrlGrp controlsGroupCtrl MACRO_IDC_UNIFORM_ICON;
        private _ctrlVestFrame = _storageCtrlGrp controlsGroupCtrl MACRO_IDC_VEST_FRAME;
        private _ctrlVestIcon = _storageCtrlGrp controlsGroupCtrl MACRO_IDC_VEST_ICON;
        private _ctrlBackpackFrame = _storageCtrlGrp controlsGroupCtrl MACRO_IDC_BACKPACK_FRAME;
        private _ctrlBackpackIcon = _storageCtrlGrp controlsGroupCtrl MACRO_IDC_BACKPACK_ICON;
        private _ctrlScrollbarDummy = _storageCtrlGrp controlsGroupCtrl MACRO_IDC_SCROLLBAR_DUMMY;

        // Set the pixel precision mode of all frames to "OFF"
        {
                _x ctrlSetPixelPrecision 2;
        } forEach [
                _ctrlUniformFrame,
                _ctrlVestFrame,
                _ctrlBackpackFrame
        ];

        // Determine our starting positions
        (ctrlPosition _ctrlUniformFrame) params ["_startX", "_startY", "_sizeW", "_sizeY"];
        private _safeZoneW = uiNamespace getVariable ["Cre8ive_Inventory_SafeZoneW", 0];
        private _safeZoneH = uiNamespace getVariable ["Cre8ive_Inventory_SafeZoneH", 0];
        private _slotSizeW = _safeZoneW * MACRO_SCALE_SLOT_SIZE_W;
        private _slotSizeH = _safeZoneH * MACRO_SCALE_SLOT_SIZE_H;
        private _offsetY = 0;

        // Determine our classes array
        private _classes = [
                uniform player,
                vest player,
                backpack player
        ];

        // Determine the icon paths for the items and weapons that we have
        {
                private _containerFrame = _x select 0;
                private _containerIcon = _x select 1;
                private _class = _classes param [_forEachIndex, ""];
                private _startYNew = _startY + _sizeY + _offsetY;

                if (_class != "") then {
                        private _default = _x select 2;
                        private _category = [_class] call cre_fnc_getClassCategory;
                        private _containerIconPath = [_class, _category, _default] call cre_fnc_getClassIcon;
                        //private _containerIconPath = "res\ui\inventory\weapon_frame.paa";

                        _containerIcon ctrlSetText _containerIconPath;
                        _containerFrame ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);

                        // Save the slot's data
                        _containerFrame setVariable ["active", true];
                        _containerFrame setVariable ["childPictureIcon", _containerIcon];
                        _containerFrame setVariable ["defaultIconPath", _default];
                        _containerFrame setVariable ["class", _class];
                };

                // Move the frame and icon controls
                {
                        (ctrlPosition _x) params ["_posX", "", "_w", "_h"];
                        _x ctrlSetPosition [
                                _posX,
                                _startY + _offsetY,
                                _w,
                                _h
                        ];
                        _x ctrlCommit 0;
                } forEach [_containerFrame, _containerIcon];

                // Fetch the maximum load of this container
                private _maxLoad = floor (MACRO_STORAGE_CAPACITY_MULTIPLIER * getContainerMaxLoad _class);
                private _slotsCountPerLine = ((ceil (_maxLoad / 3)) min MACRO_SCALE_SLOT_COUNT_PER_LINE) max 1;
                private _slotControls = [];

                // Only continue if the container can fit anything
                if (_maxLoad > 0) then {
                        private _container = objNull;
                        switch (_forEachIndex) do {
                                case 0: {_container = uniformContainer player};
                                case 1: {_container = vestContainer player};
                                case 2: {_container = backpackContainer player};
                        };
                        private _currentLoad = floor (MACRO_STORAGE_CAPACITY_MULTIPLIER * ([_container] call cre_fnc_getMass));

                        // Create the slot controls for this container
                        for "_i" from 0 to (_maxLoad - 1) do {
                                private _slotFrame = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedText", -1, _storageCtrlGrp];
                                private _slotIcon = _inventory ctrlCreate ["Cre8ive_Inventory_ScriptedPicture", -1, _storageCtrlGrp];
                                _slotFrame ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_INACTIVE);
                                _slotIcon ctrlSetText MACRO_PICTURE_SLOT_BACKGROUND;

                                // Set the frame's pixel precision mode to off, disables rounding
                                _slotFrame ctrlSetPixelPrecision 2;

                                // Move the slot controls
                                private _slotPos = [
                                        _startX + _slotSizeW * (_i % _slotsCountPerLine),
                                        _startYNew + _slotSizeH * floor (_i / _slotsCountPerLine),
                                        _slotSizeW,
                                        _slotSizeH
                                ];
                                {
                                        _x ctrlSetPosition _slotPos;
                                        _x ctrlCommit 0;
                                } forEach [_slotFrame, _slotIcon];

                                // Mark used slots as active
                                if (_i < _currentLoad) then {
                                        _slotFrame ctrlSetBackgroundColor SQUARE(MACRO_COLOUR_ELEMENT_ACTIVE);

                                        // Save the slot's data
                                        _slotFrame setVariable ["active", true];
                                        _slotFrame setVariable ["childPicture1", _slotIcon];
                                        _slotFrame setVariable ["defaultIconPath", MACRO_PICTURE_SLOT_BACKGROUND];

                                        // Add dragging EHs
                                        _slotFrame ctrlAddEventHandler ["MouseButtonDown", {["ui_dragging_start", _this] call cre_fnc_inventory}];
                                        _slotFrame ctrlAddEventHandler ["MouseButtonUp", {["ui_dragging_stop", _this] call cre_fnc_inventory}];
                                };

                                // Add the controls to the list of child controls
                                _slotControls pushBack _slotFrame;
                                _slotControls pushBack _slotIcon;

                                // Save the frame onto the control via its position
                                _containerFrame setVariable [format ["slotFrame_%1_%2", _i % _slotsCountPerLine, floor (_i / _slotsCountPerLine)], _slotFrame];
                        };
                };

                // Save the child controls onto the container control
                _containerFrame setVariable ["slotControls", _slotControls];

                _offsetY = _offsetY + _sizeY + _safeZoneH * (MACRO_SCALE_SLOT_SIZE_H * ceil (_maxLoad / _slotsCountPerLine) + 0.005);
        } forEach [
                [_ctrlUniformFrame,		_ctrlUniformIcon,		MACRO_PICTURE_UNIFORM],
                [_ctrlVestFrame,		_ctrlVestIcon,			MACRO_PICTURE_VEST],
                [_ctrlBackpackFrame,		_ctrlBackpackIcon,		MACRO_PICTURE_BACKPACK]
        ];

        // Move the scrollbar dummy
        private _pos = ctrlPosition _ctrlScrollbarDummy;
        _pos set [1, _offsetY];
        _ctrlScrollbarDummy ctrlSetPosition _pos;
        _ctrlScrollbarDummy ctrlCommit 0;
};
