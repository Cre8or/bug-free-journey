params [
	["_obj", objNull, [objNull]]
];

// Exit if the object doesn't exist
if (!alive _obj) exitWith {};





// If the spawnpoints array doesn't exist yet, create it
private _spawns = missionNamespace getVariable ["Cre8ive_Warfare_AISpawns", []];
_spawns pushBack _obj;
missionNamespace setVariable ["Cre8ive_Warfare_AISpawns", _spawns, false];

// Make the object invisible
_obj hideObjectGlobal true;
