private _currentWeapon = currentWeapon player;
private _currentMuzzle = currentMuzzle player;
private _magType = "";
private _magCount = 0;

// Fetch the magazine data from our weapon
{
        private _weaponType = _x param [0, ""];

        if (_weaponType == _currentWeapon) exitWith {
                private _compatibleMags = [configfile >> "CfgWeapons" >> _currentWeapon >> _currentMuzzle, "magazines", []] call BIS_fnc_returnConfigEntry;
                if (_compatibleMags isEqualTo []) then {
                        _compatibleMags = [configfile >> "CfgWeapons" >> _currentMuzzle, "magazines", []] call BIS_fnc_returnConfigEntry;
                };

                // Cycle through the primary and secondary magazines
                for "_i" from 4 to 5 do {
                        private _magInfo = _x param [_i, []];
                        private _magTypeNew = _magInfo param [0, ""];

                        if (_magTypeNew in _compatibleMags) exitWith {
                                _magType = _magTypeNew;
                                _magCount = _magInfo param [1, 0];
                        };
                };
        };
} forEach weaponsItems player;

// Remove the loaded magazine
switch (_currentWeapon) do {
        case secondaryWeapon player: {player removeSecondaryWeaponItem _magType};
        case handgunWeapon player: {player removeHandgunItem _magType};
        default {player removePrimaryWeaponItem _magType};
};

// Re-add the weapon magazine to the inventory
if (_magType != "") then {

        // Check if the unit has a cargo container
        private _container = objNull;
        private _deleteContainer = false;
        {
                if (!isNull _x) exitWith {_container = _x};
        } forEach [uniformContainer player, vestContainer player, backpackContainer player];

        // If the player is naked, give them a temporary container
        if (isNull _container) then {
                player addVest "V_Rangemaster_belt";
                _container = vestContainer player;
                _deleteContainer = true;
        };

        // Force the player to reload
        _container addMagazineAmmoCargo [_magType, 1, _magCount];
        reload player;

        // Delete the temporary container after the reload completes
        if (_deleteContainer) then {
                player setVariable ["cre_forceReload_magType", _magType, false];
                player setVariable ["cre_forceReload_tempContainer", _container, false];

                private _reloadEH = player addEventHandler ["Reloaded", {
                        params ["_unit", "", "", ["_newMagazine", [], [[]]], ["_oldMagazine", [], [[]]]];

                        private _magType = _unit getVariable ["cre_forceReload_magType", ""];
                        if (_magType == (_newMagazine param [0, ""]) or {_magType == (_oldMagazine param [0, ""])}) then {

                                // Check if we're still wearing the temporary vest
                                private _vest = player getVariable ["cre_forceReload_tempContainer", objNull];
                                if (vestContainer _unit == _vest) then {
                                        removeVest _unit;
                                };

                                private _reloadEH = _unit getVariable ["cre_forceReload_reloadEH", 0];
                                _unit removeEventHandler ["Reloaded", _reloadEH];
                        };
                }];
                player setVariable ["cre_forceReload_reloadEH", _reloadEH, false];
        };
};
