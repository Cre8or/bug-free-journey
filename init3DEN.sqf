if (isNil "cre_3DEN_validLightsNamespace") then {
	cre_3DEN_validLightsNamespace = locationNull;
};
deleteLocation cre_3DEN_validLightsNamespace;





// Determine a list of valid lights
private _validLights = [
	"Land_PortableLight_single_F",
	"Land_PortableLight_double_F",
	"Land_LampAirport_F",
	"Land_LampDecor_F",
	"Land_LampHalogen_F",
	"Land_LampHarbour_F",
	"Land_LampShabby_F",
	"Land_LampSolar_F",
	"Land_LampStreet_small_F",
	"Land_LampStreet_F",
	"Land_PowerPoleWooden_L_F",
	"Land_Camping_Light_F"
];

// Create a temporary namespace
cre_3DEN_validLightsNamespace = createLocation ["NameVillage", [0,0,0], 0, 0];
{
	cre_3DEN_validLightsNamespace setVariable [_x, true];
} forEach _validLights;

// Turn on street lights
{
	if (cre_3DEN_validLightsNamespace getVariable [typeOf _x, false]) then {
		_x switchLight "ON";
		_x enableSimulation true;

		if !(_x getVariable ["cre_3DEN_hasEHs", false]) then {
			_x setVariable ["cre_3DEN_hasEHs", true];
			_x addEventHandler ["RegisteredToWorld3DEN", {
				params ["_obj"];
				_obj switchLight "ON";
				_obj enableSimulation true;
			}];
			_x addEventHandler ["UnregisteredFromWorld3DEN", {
				params ["_obj"];
				_obj switchLight "OFF";
				_obj enableSimulation false;
			}];
		};
	};
} forEach (all3DENEntities select 0);





// Add an event handler to turn on new lights as they are created
removeAll3DENEventHandlers "OnSelectionChange";
add3DENEventHandler ["OnSelectionChange", {
	{
		if (cre_3DEN_validLightsNamespace getVariable [typeOf _x, false]) then {
			_x switchLight "ON";
			_x enableSimulation true;

			if !(_x getVariable ["cre_3DEN_hasEHs", false]) then {
				_x setVariable ["cre_3DEN_hasEHs", true];
				_x addEventHandler ["RegisteredToWorld3DEN", {
					params ["_obj"];
					_obj switchLight "ON";
					_obj enableSimulation true;
				}];
				_x addEventHandler ["UnregisteredFromWorld3DEN", {
					params ["_obj"];
					_obj switchLight "OFF";
					_obj enableSimulation false;
				}];
			};
		};
	} forEach (get3DENSelected "object");
}];
