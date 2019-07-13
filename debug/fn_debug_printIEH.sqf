#include "..\res\common\macros.hpp"

private _str = "";
private _ar = [];
if (!isNil "_this") then {
	_ar = +_this;
};

// Iterate over the adday
{
	if (_x isEqualType locationNull) then {
		if (!isNull _x) then {
			_ar set [_forEachIndex, "LOCATION <" + (_x getVariable [MACRO_VARNAME_UID, "???"]) + ">"];
		};
	};
	if (_x isEqualType objNull) then {
		if (!isNull _x) then {
			private _objStr = ((_x getVariable [MACRO_VARNAME_DATA, locationNull]) getVariable [MACRO_VARNAME_CLASS, ""]);
			if (_objStr == "") then {
				_objStr = str _x;
			};

			_ar set [_forEachIndex, "OBJECT <" + _objStr + ">"];
		};
	};
} forEach _ar;

systemChat str _ar;
