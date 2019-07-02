// macros.hpp is already included

class MACRO_CLASSNAME_IEH {

	class Cre8ive {
		class CfgVehicles {
			class All {
				class MACRO_ENUM_EVENT_UPDATECONTAINER {
					function = "cre_fnc_IEH_default_updateContainer";
				};
			};

			class Man {
				class MACRO_ENUM_EVENT_UPDATECONTAINER {
					function = "cre_fnc_IEH_man_updateContainer";
					isFinal = 1;		// Stop at this class (don't execute the code from "All")
				};
			};
		};
/*
		class CfgWeapons {
			// Items
			class ItemCore {
				class MACRO_ENUM_EVENT_DROP {
					code = "systemChat '(IEH) Dropped an item!'";
				};
			};

			// Rifles
			class RifleCore {
				class MACRO_ENUM_EVENT_DROP {
					code = "systemChat '(IEH) Dropped a rifle!'";
					//overwrite = 1;
				};
			};

			// Uniforms
			class Uniform_Base {
				class MACRO_ENUM_EVENT_DROP {
					code = "systemChat '(IEH) Dropped a uniform!'";
					overwrite = 1;
				};
			};

			// Vests
			class Vest_NoCamo_Base {
				class MACRO_ENUM_EVENT_DROP {
					code = "systemChat '(IEH) Dropped a vest!'";
					overwrite = 1;
					isFinal = 1;
				};
			};
			class Vest_Camo_Base : Vest_NoCamo_Base {};

			// Helmets
			class HelmetBase {
				class MACRO_ENUM_EVENT_DROP {
					code = "systemChat '(IEH) Dropped a helmet!'";
					overwrite = 1;
				};
			};
		};
		class CfgMagazines {
			class CA_Magazine {
				class MACRO_ENUM_EVENT_DROP {
					code = "systemChat '(IEH) Dropped a magazine!'";
				};
			};
		};
*/
	};

	class Something_Else {
		class CfgVehicles {
			class Man {
				class MACRO_ENUM_EVENT_UPDATECONTAINER {
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
};
