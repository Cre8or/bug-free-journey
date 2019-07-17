// macros.hpp is already included

// Debug class to print all events
class Cre8ive_Debug_PrintAllIEHs {
	class MACRO_ENUM_EVENT_INIT {
		code = "systemChat '(IEH) Initialised something!'; _this call cre_fnc_debug_printIEH";
	};
	class MACRO_ENUM_EVENT_TAKE {
//		code = "systemChat '(IEH) Took something!'; _this call cre_fnc_debug_printIEH";
		code = "systemChat format ['(IEH) Took: %1', (_this select 0) getVariable ['uid', '???']]";
	};
	class MACRO_ENUM_EVENT_DROP {
//		code = "systemChat '(IEH) Dropped something!'; _this call cre_fnc_debug_printIEH";
		code = "systemChat format ['(IEH) Dropped: %1', (_this select 0) getVariable ['uid', '???']]";
	};
	class MACRO_ENUM_EVENT_MOVE {
//		code = "systemChat '(IEH) Moved something!'; _this call cre_fnc_debug_printIEH";
		code = "systemChat format ['(IEH) Moved: %1', (_this select 0) getVariable ['uid', '???']]";
	};
};





class MACRO_CLASSNAME_IEH {

	class Cre8ive {

		class CfgVehicles {
			class All {
				class MACRO_ENUM_EVENT_DRAWCONTAINER {
					function = "cre_fnc_IEH_default_drawContainer";
					code = "systemChat '(IEH) Updated container!'; _this call cre_fnc_debug_printIEH";
				};
			};

			class Man {
				class MACRO_ENUM_EVENT_DRAWCONTAINER {
					function = "cre_fnc_IEH_man_drawContainer";
					code = "systemChat '(IEH) Updated man!'; _this call cre_fnc_debug_printIEH";
					isFinal = 1;		// Stop at this class (don't execute the code from "All")
				};
			};

			class Bag_Base : Cre8ive_Debug_PrintAllIEHs {};
		};

		class CfgWeapons {
			class ItemCore : Cre8ive_Debug_PrintAllIEHs {};
		};
		class CfgMagazines {
			class CA_Magazine : Cre8ive_Debug_PrintAllIEHs {};
		};
		class CfgGlasses {
			class None : Cre8ive_Debug_PrintAllIEHs {};
		};
	};
/*
	class Something_Else {
		class CfgVehicles {
			class Man {
				class MACRO_ENUM_EVENT_DRAWCONTAINER {
					code = "systemChat 'This guy is lit, yo!'";
					overwrite = 0;
				};
			};
		};

		class CfgWeapons {
			// Vests
			class Vest_Camo_Base {
				class MACRO_ENUM_EVENT_DROP {
					isFinal = 0;	// Actually I changed my mind - don't make this class final
				};
			};
		};
	};
*/
};