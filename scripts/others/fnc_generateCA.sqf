params [["_obj", objNull]];

if (isNull _obj) exitWith {systemChat "[generateCA] Object is null! Aborting generation..."};



if (_obj isKindOf "CAManBase") then {
        systemChat "Unit";

        private _CA = [];

        {
                _CA = _CA +
                [
                        call cre_fnc_generateUID,
                        [(weaponsItemsCargo _x) call cre_fnc_arrayToCA + (magazinesAmmoCargo _x) call cre_fnc_arrayToCA]
                ];
        } forEach [
                uniformContainer _obj,
                vestContainer _obj,
                backpackContainer _obj
        ];


};
