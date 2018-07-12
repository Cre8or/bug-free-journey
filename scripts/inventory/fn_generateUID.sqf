private _prefix = "SV";

// Prefix for players
if (!isNull player) then {
        _prefix = str getPlayerUID player;
};

// Increments
private _increment1 = (missionNamespace getVariable ["cre_genUID_increment1", 0]) + 1;
private _increment2 = missionNamespace getVariable ["cre_genUID_increment2", 0];
if (_increment1 >= 16777215) then {             // 2^24 - 1
        _increment1 = 0;
        _increment2 = _increment2 + 1;

        missionNamespace setVariable ["cre_genUID_increment2", _increment2, false];
};
missionNamespace setVariable ["cre_genUID_increment1", _increment1, false];

// Put the UID together
private _UID = _prefix + "." + str _increment1 + "." + str _increment2;

_UID;
