/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Generates a unique identifier (UID).
	Arguments:
		(nothing)
	Returns:
		0:	<STRING>	Generated
-------------------------------------------------------------------------------------------------------------------- */





private _prefix = "SV";

// Prefix for players
if (isMultiplayer and {!isNull player}) then {
	_prefix = str getPlayerUID player;
};

// Increments
private _increment1 = (missionNamespace getVariable ["cre8ive_generateUID_incr1", 0]) + 1;
private _increment2 = missionNamespace getVariable ["cre8ive_generateUID_incr2", 0];
if (_increment1 >= 16777215) then {	     // 2^24 - 1
	_increment1 = 0;
	_increment2 = _increment2 + 1;

	missionNamespace setVariable ["cre8ive_generateUID_incr2", _increment2, false];
};
missionNamespace setVariable ["cre8ive_generateUID_incr1", _increment1, false];

// Put the UID together
private _UID = _prefix + "." + str _increment2 + "." + str _increment1;

_UID;
