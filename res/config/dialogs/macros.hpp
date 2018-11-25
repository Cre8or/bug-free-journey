// ------------------------------------------------------------------------------------------------------------------------------------------------
//	COLOURS
// ------------------------------------------------------------------------------------------------------------------------------------------------

	//#define COLOUR_SCHEME


	#ifdef COLOUR_SCHEME
		#define MACRO_COLOUR_BACKGROUND				0.11, 0.095, 0.06, 0.8
		#define MACRO_COLOUR_ELEMENT_ACTIVE			0.8, 0.72, 0.55, 0.5
		#define MACRO_COLOUR_ELEMENT_INACTIVE			0.8, 0.72, 0.55, 0.15
		#define MACRO_COLOUR_SEPARATOR				0.08, 0.07, 0.045, 0.8
//		#define MACRO_COLOUR_BACKGROUND				0.095, 0.11, 0.06, 0.8
//		#define MACRO_COLOUR_ELEMENT_ACTIVE			0.72, 0.8, 0.55, 0.4
//		#define MACRO_COLOUR_ELEMENT_INACTIVE			0.72, 0.8, 0.55, 0.15
//		#define MACRO_COLOUR_SEPARATOR				0.07, 0.08, 0.045, 0.8
	#else
		#define MACRO_COLOUR_BACKGROUND				0.1, 0.1, 0.1, 0.8
		#define MACRO_COLOUR_ELEMENT_ACTIVE			0.7, 0.7, 0.7, 0.6
		#define MACRO_COLOUR_ELEMENT_INACTIVE			0.7, 0.7, 0.7, 0.15
		#define MACRO_COLOUR_ELEMENT_ACTIVE_HOVER		0.7, 0.7, 0.7, 0.8
		#define MACRO_COLOUR_ELEMENT_INACTIVE_HOVER		0.7, 0.7, 0.7, 0.3
		#define MACRO_COLOUR_ELEMENT_DRAGGING_ORIGIN		0.3, 0.3, 0.3, 0.3
		#define MACRO_COLOUR_ELEMENT_DRAGGING_GREEN		0.2, 1, 0.2, 0.5
		#define MACRO_COLOUR_ELEMENT_DRAGGING_RED		1, 0.2, 0.2, 0.5
		#define MACRO_COLOUR_SEPARATOR				0.05, 0.05, 0.05, 0.8
	#endif

	#define MACRO_COLOUR_INVISIBLE					0, 0, 0, 0



// ------------------------------------------------------------------------------------------------------------------------------------------------
//	PICTURES
// ------------------------------------------------------------------------------------------------------------------------------------------------

	// Exit Button
	#define MACRO_PICTURE_EXIT_BUTTON				"a3\ui_f\data\GUI\RscCommon\RscButtonSearch\search_end_ca.paa"

	// NVGs, binoculars, headgear and goggles
	#define MACRO_PICTURE_NVGS					"a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_nvg_gs.paa"
	#define MACRO_PICTURE_HEADGEAR					"a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_helmet_gs.paa"
	#define MACRO_PICTURE_GOGGLES					"a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_glasses_gs.paa"
	#define MACRO_PICTURE_BINOCULARS				"a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_binocular_gs.paa"

	// Weapons
	#define MACRO_PICTURE_PRIMARYWEAPON				"a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_primary_gs.paa"
	#define MACRO_PICTURE_HANDGUNWEAPON				"a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_hgun_gs.paa"
	#define MACRO_PICTURE_SECONDARYWEAPON				"a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_secondary_gs.paa"

	// Weapon Items
	#define MACRO_PICTURE_WEAPON_MUZZLE				"a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_muzzle_gs.paa"
	#define MACRO_PICTURE_WEAPON_BIPOD				"a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_bipod_gs.paa"
	#define MACRO_PICTURE_WEAPON_SIDE				"a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_side_gs.paa"
	#define MACRO_PICTURE_WEAPON_OPTIC				"a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_top_gs.paa"
	#define MACRO_PICTURE_WEAPON_MAGAZINEGL				"a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_magazineGL_gs.paa"
	#define MACRO_PICTURE_WEAPON_MAGAZINE				"a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_magazine_gs.paa"

	// Weapon accessories
	#define MACRO_PICTURE_WEAPON_ACC_MUZZLE				"a3\weapons_f\Data\UI\attachment_muzzle.paa"
	#define MACRO_PICTURE_WEAPON_ACC_BIPOD				"a3\weapons_f_mark\Data\UI\attachment_under.paa"
	#define MACRO_PICTURE_WEAPON_ACC_SIDE				"a3\weapons_f\Data\UI\attachment_side.paa"
	#define MACRO_PICTURE_WEAPON_ACC_OPTIC				"a3\weapons_f\Data\UI\attachment_top.paa"

	// Assigned slots
	#define MACRO_PICTURE_MAP					"a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_map_gs.paa"
	#define MACRO_PICTURE_GPS					"a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_gps_gs.paa"
	#define MACRO_PICTURE_RADIO					"a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_radio_gs.paa"
	#define MACRO_PICTURE_COMPASS					"a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_compass_gs.paa"
	#define MACRO_PICTURE_WATCH					"a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_watch_gs.paa"

	// Uniform, vest and backpack
	#define MACRO_PICTURE_UNIFORM					"a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_uniform_gs.paa"
	#define MACRO_PICTURE_VEST					"a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_vest_gs.paa"
	#define MACRO_PICTURE_BACKPACK					"a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_backpack_gs.paa"

	// Medical menu
	#define MACRO_PICTURE_CHARACTER_OUTLINE				"res\ui\inventory\character.paa"

	// Slot background
	#define MACRO_PICTURE_SLOT_BACKGROUND				"res\ui\inventory\slot_background.paa"





// ------------------------------------------------------------------------------------------------------------------------------------------------
//	IDCS
// ------------------------------------------------------------------------------------------------------------------------------------------------

	// Ground
	#define MACRO_IDC_GROUND_CTRLGRP				1000
	#define MACRO_IDC_GROUND_FOCUS_FRAME				1001

	// Weapons / Medical
	#define MACRO_IDC_WEAPONS_CTRLGRP				2000
	#define MACRO_IDC_MEDICAL_CTRLGRP				2001
	#define MACRO_IDC_WEAPONS_FOCUS_FRAME				2002
	#define MACRO_IDC_MEDICAL_FOCUS_FRAME				2003

	// PLayer info
	#define MACRO_IDC_PLAYER_NAME					2101

	// Weapons / Medical buttons
	#define MACRO_IDC_WEAPONS_BUTTON_FRAME				2102
	#define MACRO_IDC_WEAPONS_BUTTON				2103
	#define MACRO_IDC_MEDICAL_BUTTON_FRAME				2104
	#define MACRO_IDC_MEDICAL_BUTTON				2105

	// Character (Weapons)
	#define MACRO_IDC_CHARACTER_WEAPONS_ICON			2201

	// NVGs, binoculars, headgear and goggles
	#define MACRO_IDC_NVGS_FRAME					2202
	#define MACRO_IDC_HEADGEAR_FRAME				2203
	#define MACRO_IDC_GOGGLES_FRAME					2204
	#define MACRO_IDC_BINOCULARS_FRAME				2205

	// Primary Weapon
	#define MACRO_IDC_PRIMARYWEAPON_FRAME				2211

	// Handgun Weapon
	#define MACRO_IDC_HANDGUNWEAPON_FRAME				2212

	// Secondary Weapon
	#define MACRO_IDC_SECONDARYWEAPON_FRAME				2213

	// Assigned slots
	#define MACRO_IDC_MAP_FRAME					2221
	#define MACRO_IDC_GPS_FRAME					2222
	#define MACRO_IDC_RADIO_FRAME					2223
	#define MACRO_IDC_COMPASS_FRAME					2224
	#define MACRO_IDC_WATCH_FRAME					2225

	// Character (Medical)
	#define MACRO_IDC_CHARACTER_MEDICAL_ICON			2301

	// Storage
	#define MACRO_IDC_STORAGE_CTRLGRP				3000
	#define MACRO_IDC_STORAGE_FOCUS_FRAME				3001

	// Uniform, vest and backpack
	#define MACRO_IDC_UNIFORM_FRAME					3101
	#define MACRO_IDC_VEST_FRAME					3102
	#define MACRO_IDC_BACKPACK_FRAME				3103
	#define MACRO_IDC_SCROLLBAR_DUMMY				3104

	// Empty control group (for focus)
	#define MACRO_IDC_EMPTY_CTRLGROUP				4000
	#define MACRO_IDC_EMPTY_FOCUS_FRAME				4001

	// Temporary frame and picture
	#define MACRO_IDC_SCRIPTEDFRAME					4101
	#define MACRO_IDC_SCRIPTEDPICTURE				4102





// ------------------------------------------------------------------------------------------------------------------------------------------------
//	UI ELEMENT CHILD CONTROL TYPES
// ------------------------------------------------------------------------------------------------------------------------------------------------

	#define MACRO_ENUM_CTRL_PICTURE_ICON				0
	#define MACRO_ENUM_CTRL_OUTLINE					1
	#define MACRO_ENUM_CTRL_PICTURE_WEAPON_MUZZLE			10
	#define MACRO_ENUM_CTRL_PICTURE_WEAPON_BIPOD			11
	#define MACRO_ENUM_CTRL_PICTURE_WEAPON_SIDE			12
	#define MACRO_ENUM_CTRL_PICTURE_WEAPON_OPTIC			13
	#define MACRO_ENUM_CTRL_PICTURE_WEAPON_MAGAZINE			14
	#define MACRO_ENUM_CTRL_PICTURE_WEAPON_ALTMAGAZINE		15
	#define MACRO_ENUM_CTRL_BOX_AMMO_FILLBAR			20





// ------------------------------------------------------------------------------------------------------------------------------------------------
//	UI ELEMENT POSITIONING AND SCALING
// ------------------------------------------------------------------------------------------------------------------------------------------------

	#define MACRO_POS_SEPARATOR_GROUND				0.35
	#define MACRO_POS_SEPARATOR_STORAGE				0.65

	#define MACRO_SCALE_SLOT_SIZE_W					0.033 * 0.84
	#define MACRO_SCALE_SLOT_SIZE_H					0.055 * 0.84
	#define MACRO_SCALE_SLOT_COUNT_PER_LINE				12





// ------------------------------------------------------------------------------------------------------------------------------------------------
//	ITEM TYPES
// ------------------------------------------------------------------------------------------------------------------------------------------------

	#define MACRO_ENUM_CATEGORY_EMPTY				-2
	#define MACRO_ENUM_CATEGORY_INVALID				-1

	#define MACRO_ENUM_CATEGORY_ITEM				0
	#define MACRO_ENUM_CATEGORY_WEAPON				1
	#define MACRO_ENUM_CATEGORY_MAGAZINE				2

	#define MACRO_ENUM_CATEGORY_UNIFORM				3
	#define MACRO_ENUM_CATEGORY_VEST				4
	#define MACRO_ENUM_CATEGORY_BACKPACK				5

	#define MACRO_ENUM_CATEGORY_GLASSES				6
	#define MACRO_ENUM_CATEGORY_HEADGEAR				7
	#define MACRO_ENUM_CATEGORY_NVG					8
	#define MACRO_ENUM_CATEGORY_BINOCULAR				9

	#define MACRO_ENUM_CATEGORY_VEHICLE				10





// ------------------------------------------------------------------------------------------------------------------------------------------------
//	VARIABLE NAMES
// ------------------------------------------------------------------------------------------------------------------------------------------------

	// UI
	#define MACRO_VARNAME_UI_DRAGGEDCTRL				"draggedControl"
	#define MACRO_VARNAME_UI_ISBEINGDRAGGED				"draggedControl"
	#define MACRO_VARNAME_UI_FRAMETEMP				"ctrlFrameTemp"
	#define MACRO_VARNAME_UI_ICONTEMP				"ctrlIconTemp"
	#define MACRO_VARNAME_UI_CHILDCONTROLS				"childControls"
	#define MACRO_VARNAME_UI_CTRLICON				"ctrlIcon"
	#define MACRO_VARNAME_UI_CTRLOUTLINE				"ctrlOutline"
	#define MACRO_VARNAME_UI_CTRLPARENT				"ctrlParent"

	#define MACRO_VARNAME_UI_CURSORCTRL				"cursorCtrl"
	#define MACRO_VARNAME_UI_CURSORPOSREL				"cursorPosRel"
	#define MACRO_VARNAME_UI_CURSORPOSNEW				"cursorPosNew"
	#define MACRO_VARNAME_UI_HIGHLITCONTROLS			"dragging_oldControls"

	#define MACRO_VARNAME_UI_EH_MOUSEBUTTONUP			"EH_mouseButtonUp"
	#define MACRO_VARNAME_UI_EH_MOUSEBUTTONDOWN			"EH_mouseButtonDown"

	// Items and containers
	#define MACRO_VARNAME_UID					"UID"
	#define MACRO_VARNAME_DATA					"data"
	#define MACRO_VARNAME_CLASS					"class"
	#define MACRO_VARNAME_SLOTSIZE					"slotSize"
	#define MACRO_VARNAME_SLOTPOS					"slotPos"
	#define MACRO_VARNAME_SLOT_X_Y					"slot_%1_%2"
	#define MACRO_VARNAME_PARENT					"parent"

	#define MACRO_VARNAME_MAG_AMMO					"ammo"
	#define MACRO_VARNAME_MAG_MAXAMMO				"maxAmmo"

	#define MACRO_VARNAME_ACC_MUZZLE				"accMuzzle"
	#define MACRO_VARNAME_ACC_BIPOD					"accBipod"
	#define MACRO_VARNAME_ACC_SIDE					"accSide"
	#define MACRO_VARNAME_ACC_OPTIC					"accOptic"
	#define MACRO_VARNAME_MAG					"magazine"
	#define MACRO_VARNAME_MAGALT					"magazineAlt"





// ------------------------------------------------------------------------------------------------------------------------------------------------
//	MACRO FUNCTIONS
// ------------------------------------------------------------------------------------------------------------------------------------------------

	#define CURLY(DATA)						{##DATA##}
	#define SQUARE(DATA)						[##DATA##]
	#define STR(DATA)						#DATA





// ------------------------------------------------------------------------------------------------------------------------------------------------
//	DEV / DEBUGGING
// ------------------------------------------------------------------------------------------------------------------------------------------------

	// Debug toggles - uncomment to enable debug outputs in the respective script
	//#define MACRO_DEBUG_GETCLASSICON




// ------------------------------------------------------------------------------------------------------------------------------------------------
//	OTHERS / EXTRAS
// ------------------------------------------------------------------------------------------------------------------------------------------------

	// Overall inventory storage capacity scaling
	#define MACRO_STORAGE_CAPACITY_MULTIPLIER			0.5

	// Name of the UI
	#define MACRO_GUI_NAME						Rsc_Cre8ive_Inventory

	// Determine which config file the UI is defined in (mission or addon format)
	#define MACRO_CONFIG_FILE_SWITCH

	#ifdef MACRO_CONFIG_FILE_SWITCH
		#define MACRO_CONFIG_FILE missionConfigFile
	#else
		#define MACRO_CONFIG_FILE configFile
	#endif
