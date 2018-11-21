// Wait for all  spawnpoints to initialise
private _spawns = [];
waitUntil {
	private _exit = false;
	private _spawnsNew = missionNamespace getVariable ["Cre8ive_Warfare_AISpawns", []];

	if !(_spawnsNew isEqualTo []) then {
		// If the spawns haven't changed since the last time we checked, assume the list is complete
		if (_spawns isEqualTo _spawnsNew) then {
			_exit = true;
		};

		_spawns = +_spawnsNew;
	};

	// Sleep
	sleep 0.1;
	_exit;
};





// Set up some constants
private _maxUnits = 20;
private _maxSpawnAttempts = 5;
private _updateRate = 5;		// How many AIs we iterate through per second
private _moveInterval = 10;	     // In seconds
private _minSpawnDistance = 10 ^ 2;     // In meters
private _sleepTime = 1 / _updateRate;
private _groupDead = createGroup resistance;
private _unitTypes = [
	"I_G_Soldier_AR_F",
	"I_G_Soldier_A_F",
	"I_G_engineer_F",
	"I_G_Soldier_exp_F",
	"I_G_Soldier_M_F",
	"I_G_officer_F",
	"I_G_Soldier_lite_F",
	"I_G_Soldier_SL_F"
];

// Set up some variables
private _units = [];
private _index = -1;
private _circlePos = [0,0,0];
private _circleRadius = 0;





// Delete the old markers
{
	deleteMarker _x;
} forEach (missionNamespace getVariable ["Cre8ive_Warfare_Markers", []]);

// Create a marker for the circle
private _markers = missionNamespace getVariable ["Cre8ive_Warfare_Markers", []];
private _markerCircle = createMarker [format ["warfareCircle_%1", time], [0,0,0]];
_markerCircle setMarkerShape "ELLIPSE";
_markerCircle setMarkerBrush "SolidBorder";
_markerCircle setMarkerColor "ColorRed";
_markers pushBack _markerCircle;

// Calculate the smallest circle that encloses our spawnpoints (so we can determine the trigger area)
{
/*
	// Create a marker
	private _marker = createMarker [str _x, getPos _x];
	_marker setMarkerShape "ICON";
	_marker setMarkerType "mil_dot";
	_marker setmarkerColor "ColorBlue";
	_marker setMarkerSize ([[0.75, 0.75], [1.5, 1.5]] select (_forEachIndex == 0));
	_markers pushBack _marker;
*/

	// Determine the average positon
	_circlePos = _circlePos vectorAdd (getPos _x);
/*
	// Determine our next action based on how many points are currently on the circle
	switch (count _spawnsOnCircle) do {
		case 0: {
			_spawnsOnCircle pushBackUnique _x;
		};
		case 1: {
			_spawnsOnCircle pushBackUnique _x;

			// We now have 2 points, the circle is in middle of the two
			private _spawn0 = getPos (_spawnsOnCircle select 0);
			private _spawn1 = getPos (_spawnsOnCircle select 1);
			_circlePos = _spawn0 vectorAdd ((_spawn1 vectorDiff _spawn0) vectorMultiply 0.5);
			_circleRadius = (_spawn0 distance2D _spawn1) / 2;

			systemChat format ["Position: %1", _circlePos];
			systemChat format ["Radius: %1", _circleRadius];

			// Position our marker on the center
			_markerCircle setMarkerPos _circlePos;
			_markerCircle setMarkerSize [_circleRadius, _circleRadius];
		};
		case 2: {
			_spawnsOnCircle pushBackUnique _x;

			// We now have 3 points, the circle center must be equidistant to all of them
			private _spawn0 = getPos (_spawnsOnCircle select 0);
			private _spawn1 = getPos (_spawnsOnCircle select 1);
			private _spawn2 = getPos (_spawnsOnCircle select 2);

			// Calculate the intersection between the perpendicular lines of two sides of the triangle
			private _dir1 = (_spawn0 getDir _spawn1) + 90;
			private _dir2 = (_spawn0 getDir _spawn2) + 90;


		};
	};
*/
} forEach _spawns;
missionNamespace setVariable ["Cre8ive_Warfare_Markers", _markers, false];

// Normalize the circle position
_circlePos = _circlePos vectorMultiply (1 / count _spawns);
{
	_circleRadius = _circleRadius max (_circlePos distance2D getPos _x);
} forEach _spawns;

// Reposition the circle marker
_markerCircle setMarkerPos _circlePos;
_markerCircle setMarkerSize [_circleRadius, _circleRadius];

// Delete the old units
{
	deleteVehicle _x;
} forEach (missionNamespace getVariable ["Cre8ive_Warfare_Units", []]);
missionNamespace setVariable ["Cre8ive_Warfare_Units", [], false];





// Make independents hate eachother
resistance setFriend [resistance, 0];

// Handle AI behaviour
while {true} do {

	// If the player is too far away, delete all units
	if (player distanceSqr _circlePos > (_circleRadius + 500) ^ 2) then {
		{
			deleteVehicle _x;
			sleep 0.02;
		} forEach (missionNamespace getVariable ["Cre8ive_Warfare_Units", []]);
		missionNamespace setVariable ["Cre8ive_Warfare_Units", [], false];

	// Otherwise, manage AI behaviour
	} else {

		// Decrease the index and fetch the current unit
		_index = (_index + 1) % _maxUnits;
		private _unit = _units param [_index, objNull];

		// If the unit isn't alive, delete it and create a new one
		if (!alive _unit) then {

			// Only delete it if it exists
			if (!isNull _unit) then {
				_units deleteAt _index;

				// Delete the old group
				private _groupOld = group _unit;
				[_unit] joinSilent _groupDead;
				deleteGroup _groupOld;

				// Hide the body
				[_unit] spawn {
					sleep 30;

					private _unit = (_this param [0, objNull]);
					isNil {
						if (!isNull _unit) then {
							_units = (missionNamespace getVariable ["Cre8ive_Warfare_Units", []]) - [_unit];
							missionNamespace setVariable ["Cre8ive_Warfare_Units", _units, false];

							deleteVehicle _unit;
						};
					};
				};
			};

			// Determine a new spawn position
			private _spawn = objNull;
			private _canSpawn = false;
			for "_i" from 1 to _maxSpawnAttempts do {
				_spawn = selectRandom _spawns;
				private _pos = (getPosASL _spawn) vectorAdd [0,0,1.5];

				// Check if there are any units nearby
				private _canSee = false;
				{
					if (_spawn distanceSqr _x > _minSpawnDistance) then {
						_canSee = ((lineIntersectsSurfaces [_pos, eyePos _x, _x]) isEqualTo []);
					} else {
						_canSee = true;
					};

					if (_canSee) exitWith {};
				} forEach (_spawn nearObjects ["Man", 100]);

				if (!_canSee) exitWith {
					_canSpawn = true;
				};
			};

			// If we found a valid position, create a new unit
			if (_canSpawn) then {
				private _group = createGroup resistance;
				_group deleteGroupWhenEmpty true;

				_unit = _group createUnit [selectRandom _unitTypes, [0,0,0], [], 0, "CAN_COLLIDE"];
				_unit setPosASL getPosASL _spawn;
				_unit setDir getDir _spawn;
				//_unit setUnitLoadout [["arifle_TRG20_ACO_F","","acc_flashlight","optic_ACO_grn",["30Rnd_556x45_Stanag_Tracer_Green",30],[],""],[],["hgun_ACPC2_F","","","",["9Rnd_45ACP_Mag",8],[],""],["U_BG_Guerilla2_1",[["FirstAidKit",1],["30Rnd_556x45_Stanag_Tracer_Green",2,30]]],["V_Chestrig_blk",[["9Rnd_45ACP_Mag",1,9],["HandGrenade",1,1],["MiniGrenade",1,1],["SmokeShellGreen",1,1],["SmokeShellRed",1,1],["SmokeShellBlue",1,1],["Chemlight_blue",2,1],["30Rnd_556x45_Stanag_Tracer_Green",12,30]]],[],"H_Watchcap_khk","",["Binocular","","","",[],[],""],["ItemMap","","ItemRadio","ItemCompass","ItemWatch",""]];
				_unit setUnitLoadout [["hgun_PDW2000_F","","","",["16Rnd_9x21_red_Mag",16],[],""],[],["hgun_Rook40_F","","","",["16Rnd_9x21_red_Mag",7],[],""],["U_I_C_Soldier_Bandit_3_F",[["FirstAidKit",1],["Chemlight_red",2,1],["16Rnd_9x21_red_Mag",2,16]]],["V_Pocketed_black_F",[["FirstAidKit",2],["16Rnd_9x21_red_Mag",5,16],["SmokeShellRed",1,1],["Chemlight_red",2,1]]],[],"","G_Balaclava_blk",[],["ItemMap","ItemGPS","","ItemCompass","ItemWatch",""]];
				_unit enableGunLights "forceOn";

				[_unit, false, random 45] call ca_fnc_groupGuerrillaAI;
				[_unit, 1 + random 1, 0.1] call ca_fnc_groupSuppressiveAI;

				// Save the units to the mission namespace
				_units set [_index, _unit];
				private _missionUnits = missionNamespace getVariable ["Cre8ive_Warfare_Units", []];
				_missionUnits pushBack _unit;
				missionNamespace setVariable ["Cre8ive_Warfare_Units", _missionUnits, false];
			};
		};

		// If the unit is alive, move it around
		if (alive _unit) then {
			private _time = time;

			// Check when the unit was last moved around
			if (_time - (_unit getVariable ["Cre8ive_Warfare_LastMoved", -999]) > _moveInterval) then {

				// Save the time
				_unit setVariable ["Cre8ive_Warfare_LastMoved", _time, false];

				// Send the unit to a random position around the circle
				private _dir = random 360;
				private _pos = _circlePos vectorAdd ([cos _dir, sin _dir, 0] vectorMultiply _circleRadius);
				//private _pos = getPosATL player;
				_unit doMove _pos;
			};
		};
	};

	// Sleep
	sleep _sleepTime;
};
