params [["_unit", objNull]];

if (isNull _unit) exitWith {systemChat "Unit does not exist!"};

private _anim = [
	"HubStandingUA_move1",
	"HubStandingUA_move2",
	"HubStandingUA_idle3",
	"HubStandingUB_idle1",
	"HubStandingUB_move1",
	"HubStandingUC_idle2",
	"HubStandingUC_idle3",
	"HubStandingUC_move2",
	"HubBriefing_stretch",
	"Acts_CivilIdle_1",
	"Acts_CivilIdle_2",
	"Acts_AidlPercMstpSloWWpstDnon_warmup_1_loop",
	"Acts_AidlPercMstpSnonWnonDnon_warmup_1_loop",
	"Acts_AidlPercMstpSnonWnonDnon_warmup_2_loop",
	"Acts_AidlPercMstpSnonWnonDnon_warmup_3_loop",
	"Acts_AidlPercMstpSnonWnonDnon_warmup_4_loop",
	"Acts_AidlPercMstpSnonWnonDnon_warmup_6_loop",
	"Acts_AidlPercMstpSnonWnonDnon_warmup_8_loop"
] call BIS_fnc_selectRandom;

_unit addEventHandler ["AnimDone", {
	private _unit = _this select 0;
	private _anim = _unit getVariable ["idleAnim", ""];
	_unit playMove _anim;
	_unit switchMove _anim;
}];

_unit addEventHandler ["Killed", {
	private _unit = _this select 0;
	//_unit switchMove "";
	_unit removeAllEventhandlers "AnimDone";
}];

_unit playMove _anim;
_unit switchMove _anim;

group _unit setBehaviour "CARELESS";
_unit setUnitPos "UP";
_unit disableAI "MOVE";
_unit setVariable ["idleAnim", _anim, false];
