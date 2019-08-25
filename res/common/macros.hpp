/*------------------------------------------------------------------------------------------------------------------------------------------------
	IMPORTANT NOTE:

ALL MACROS IN THIS FILE USE SPACES INSTEAD OF HARD TABS - DO NOT CHANGE THAT!
This is because Arma's preprocessor trims spaces, but not tabs, meaning that if using STR() on them, THEY WILL BE PART OF THE STRING!!!
------------------------------------------------------------------------------------------------------------------------------------------------*/





// ------------------------------------------------------------------------------------------------------------------------------------------------
//	MACRO FUNCTIONS
// ------------------------------------------------------------------------------------------------------------------------------------------------

	#define CURLY(DATA)                                             {##DATA##}
	#define SQUARE(DATA)                                            [##DATA##]
	#define STR(DATA)                                               #DATA





// ------------------------------------------------------------------------------------------------------------------------------------------------
//	COLOURS
// ------------------------------------------------------------------------------------------------------------------------------------------------

//	#define COLOUR_SCHEME

	#ifdef COLOUR_SCHEME
/*
		#define MACRO_COLOUR_BACKGROUND                         0.1, 0.085, 0.065, 0.8
		#define MACRO_COLOUR_ELEMENT_ACTIVE                     0.85, 0.76, 0.55, 0.6
		#define MACRO_COLOUR_ELEMENT_INACTIVE                   0.85, 0.76, 0.55, 0.15
		#define MACRO_COLOUR_ELEMENT_ACTIVE_HOVER               0.85, 0.76, 0.55, 0.8
		#define MACRO_COLOUR_ELEMENT_INACTIVE_HOVER             0.85, 0.76, 0.55, 0.3
		#define MACRO_COLOUR_SEPARATOR                          0.08, 0.07, 0.045, 0.8
*/
		#define MACRO_COLOUR_BACKGROUND                         0.08, 0.1, 0.06, 0.8
		#define MACRO_COLOUR_ELEMENT_ACTIVE                     0.6, 0.8, 0.5, 0.6
		#define MACRO_COLOUR_ELEMENT_INACTIVE                   0.6, 0.8, 0.5, 0.15
		#define MACRO_COLOUR_ELEMENT_ACTIVE_HOVER               0.6, 0.8, 0.5, 0.8
		#define MACRO_COLOUR_ELEMENT_INACTIVE_HOVER             0.6, 0.8, 0.5, 0.3
		#define MACRO_COLOUR_SEPARATOR                          0.06, 0.08, 0.05, 0.8

	#else
		#define MACRO_COLOUR_BACKGROUND                         0.08, 0.08, 0.08, 0.8
		#define MACRO_COLOUR_ELEMENT_ACTIVE                     0.7, 0.7, 0.7, 0.6
		#define MACRO_COLOUR_ELEMENT_INACTIVE                   0.7, 0.7, 0.7, 0.15
		#define MACRO_COLOUR_ELEMENT_ACTIVE_HOVER               0.7, 0.7, 0.7, 0.8
		#define MACRO_COLOUR_ELEMENT_INACTIVE_HOVER             0.7, 0.7, 0.7, 0.3
		#define MACRO_COLOUR_SEPARATOR                          0.05, 0.05, 0.05, 0.8
	#endif

	#define MACRO_COLOUR_INVISIBLE                                  0, 0, 0, 0
	#define MACRO_COLOUR_ELEMENT_DRAGGING_GREEN                     0.2, 1, 0.2, 0.5
	#define MACRO_COLOUR_ELEMENT_DRAGGING_RED                       1, 0.2, 0.2, 0.5
	#define MACRO_COLOUR_AMMOBAR_BACKGROUND                         0, 0, 0, 0.8

	#define MACRO_COLOUR_OUTLINE_WEAPON                             0, 0, 1, 0.8
	#define MACRO_COLOUR_OUTLINE_MAGAZINE                           1, 1, 1, 0.4
	#define MACRO_COLOUR_OUTLINE_UNIFORM                            0, 1, 0, 0.6
//	#define MACRO_COLOUR_OUTLINE_VEST                               0, 1, 0, 0.8
//	#define MACRO_COLOUR_OUTLINE_BACKPACK                           0, 1, 0, 0.8
	#define MACRO_COLOUR_OUTLINE_ITEM                            1, 0, 0, 0.8



// ------------------------------------------------------------------------------------------------------------------------------------------------
//	PICTURES
// ------------------------------------------------------------------------------------------------------------------------------------------------

	// Exit Button
	#define MACRO_PICTURE_EXIT_BUTTON                               "a3\ui_f\data\GUI\RscCommon\RscButtonSearch\search_end_ca.paa"

	// NVGs, binoculars, headgear and goggles
	#define MACRO_PICTURE_NVGS                                      "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_nvg_gs.paa"
	#define MACRO_PICTURE_HEADGEAR                                  "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_helmet_gs.paa"
	#define MACRO_PICTURE_BINOCULARS                                "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_binocular_gs.paa"
	#define MACRO_PICTURE_GOGGLES                                   "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_glasses_gs.paa"

	// Weapons
	#define MACRO_PICTURE_PRIMARYWEAPON                             "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_primary_gs.paa"
	#define MACRO_PICTURE_HANDGUNWEAPON                             "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_hgun_gs.paa"
	#define MACRO_PICTURE_SECONDARYWEAPON                           "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_secondary_gs.paa"

	// Weapon Items
	#define MACRO_PICTURE_WEAPON_MUZZLE                             "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_muzzle_gs.paa"
	#define MACRO_PICTURE_WEAPON_BIPOD                              "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_bipod_gs.paa"
	#define MACRO_PICTURE_WEAPON_SIDE                               "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_side_gs.paa"
	#define MACRO_PICTURE_WEAPON_OPTIC                              "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_top_gs.paa"
	#define MACRO_PICTURE_WEAPON_MAGAZINEGL                         "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_magazineGL_gs.paa"
	#define MACRO_PICTURE_WEAPON_MAGAZINE                           "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_magazine_gs.paa"

	// Weapon accessories
	#define MACRO_PICTURE_WEAPON_ACC_MUZZLE                         "res\ui\inventory\attachments\acc_muzzle.paa"
	#define MACRO_PICTURE_WEAPON_ACC_BIPOD                          "res\ui\inventory\attachments\acc_bipod.paa"
	#define MACRO_PICTURE_WEAPON_ACC_SIDE                           "res\ui\inventory\attachments\acc_side.paa"
	#define MACRO_PICTURE_WEAPON_ACC_OPTIC                          "res\ui\inventory\attachments\acc_optic.paa"
	//#define MACRO_PICTURE_WEAPON_ACC_MUZZLE                         "a3\weapons_f\Data\UI\attachment_muzzle.paa"
	//#define MACRO_PICTURE_WEAPON_ACC_BIPOD                          "a3\weapons_f_mark\Data\UI\attachment_under.paa"
	//#define MACRO_PICTURE_WEAPON_ACC_SIDE                           "a3\weapons_f\Data\UI\attachment_side.paa"
	//#define MACRO_PICTURE_WEAPON_ACC_OPTIC                          "a3\weapons_f\Data\UI\attachment_top.paa"

	// Assigned slots
	#define MACRO_PICTURE_MAP                                       "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_map_gs.paa"
	#define MACRO_PICTURE_GPS                                       "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_gps_gs.paa"
	#define MACRO_PICTURE_RADIO                                     "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_radio_gs.paa"
	#define MACRO_PICTURE_COMPASS                                   "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_compass_gs.paa"
	#define MACRO_PICTURE_WATCH                                     "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_watch_gs.paa"

	// Uniform, vest and backpack
	#define MACRO_PICTURE_UNIFORM                                   "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_uniform_gs.paa"
	#define MACRO_PICTURE_VEST                                      "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_vest_gs.paa"
	#define MACRO_PICTURE_BACKPACK                                  "a3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_backpack_gs.paa"

	// Medical menu
	#define MACRO_PICTURE_CHARACTER_OUTLINE                         "res\ui\inventory\character.paa"

	// Slot background
	#define MACRO_PICTURE_SLOT_BACKGROUND                           "res\ui\inventory\slot_background.paa"





// ------------------------------------------------------------------------------------------------------------------------------------------------
//	IDCS
// ------------------------------------------------------------------------------------------------------------------------------------------------

	// Ground
	#define MACRO_IDC_GROUND_CTRLGRP                                1000
	#define MACRO_IDC_GROUND_FRAME                                  1001
	#define MACRO_IDC_GROUND_FOCUS_FRAME                            1002
	#define MACRO_IDC_GROUND_DROP_FRAME                             1003

	// Container
	#define MACRO_IDC_CONTAINER_CTRLGRP                             2000
	#define MACRO_IDC_CONTAINER_FRAME                               2001
	#define MACRO_IDC_CONTAINER_FOCUS_FRAME                         2002
	#define MACRO_IDC_CONTAINER_NAME_FRAME                          2003
	#define MACRO_IDC_CONTAINER_NAME                                2004

	// Weapons / Medical
	#define MACRO_IDC_WEAPONS_CTRLGRP                               3000
	#define MACRO_IDC_MEDICAL_CTRLGRP                               3001
	#define MACRO_IDC_WEAPONS_FOCUS_FRAME                           3002
	#define MACRO_IDC_MEDICAL_FOCUS_FRAME                           3003

	// PLayer info
	#define MACRO_IDC_PLAYER_NAME                                   3101

	// Weapons / Medical buttons
	#define MACRO_IDC_WEAPONS_BUTTON_FRAME                          3102
	#define MACRO_IDC_WEAPONS_BUTTON                                3103
	#define MACRO_IDC_MEDICAL_BUTTON_FRAME                          3104
	#define MACRO_IDC_MEDICAL_BUTTON                                3105

	// Character (Weapons)
	#define MACRO_IDC_CHARACTER_WEAPONS_ICON                        3201

	// NVGs, binoculars, headgear and goggles
	#define MACRO_IDC_NVGS_FRAME                                    3202
	#define MACRO_IDC_HEADGEAR_FRAME                                3203
	#define MACRO_IDC_BINOCULARS_FRAME                              3204
	#define MACRO_IDC_GOGGLES_FRAME                                 3205

	// Primary Weapon
	#define MACRO_IDC_PRIMARYWEAPON_FRAME                           3211

	// Handgun Weapon
	#define MACRO_IDC_HANDGUNWEAPON_FRAME                           3212

	// Secondary Weapon
	#define MACRO_IDC_SECONDARYWEAPON_FRAME                         3213

	// Assigned slots
	#define MACRO_IDC_MAP_FRAME                                     3221
	#define MACRO_IDC_GPS_FRAME                                     3222
	#define MACRO_IDC_RADIO_FRAME                                   3223
	#define MACRO_IDC_COMPASS_FRAME                                 3224
	#define MACRO_IDC_WATCH_FRAME                                   3225

	// Character (Medical)
	#define MACRO_IDC_CHARACTER_MEDICAL_ICON                        3301

	// Storage
	#define MACRO_IDC_STORAGE_CTRLGRP                               4000
	#define MACRO_IDC_STORAGE_FOCUS_FRAME                           4001

	// Uniform, vest and backpack
	#define MACRO_IDC_UNIFORM_FRAME                                 4101
	#define MACRO_IDC_VEST_FRAME                                    4102
	#define MACRO_IDC_BACKPACK_FRAME                                4103
	#define MACRO_IDC_SCROLLBAR_DUMMY                               4104

	// Empty control group (for focus)
	#define MACRO_IDC_EMPTY_CTRLGROUP                               5000
	#define MACRO_IDC_EMPTY_FOCUS_FRAME                             5001





// ------------------------------------------------------------------------------------------------------------------------------------------------
//	UI ELEMENT CHILD CONTROL TYPES
// ------------------------------------------------------------------------------------------------------------------------------------------------

	#define MACRO_ENUM_CTRL_PICTURE_ICON                            0
	#define MACRO_ENUM_CTRL_OUTLINE                                 1
	#define MACRO_ENUM_CTRL_TEXT_DISPLAYNAME                        2

	#define MACRO_ENUM_CTRL_PICTURE_WEAPON_MUZZLE                   10
	#define MACRO_ENUM_CTRL_PICTURE_WEAPON_BIPOD                    11
	#define MACRO_ENUM_CTRL_PICTURE_WEAPON_SIDE                     12
	#define MACRO_ENUM_CTRL_PICTURE_WEAPON_OPTIC                    13
	#define MACRO_ENUM_CTRL_PICTURE_WEAPON_MAGAZINE                 14
	#define MACRO_ENUM_CTRL_PICTURE_WEAPON_ALTMAGAZINE              15

	#define MACRO_ENUM_CTRL_BOX_AMMO_FILLBAR                        20





// ------------------------------------------------------------------------------------------------------------------------------------------------
//	UI ELEMENT POSITIONING AND SCALING
// ------------------------------------------------------------------------------------------------------------------------------------------------

	#define MACRO_POS_SEPARATOR_GROUND                              0.35
	#define MACRO_POS_SEPARATOR_CONTAINER                           0.35
	#define MACRO_POS_SEPARATOR_STORAGE                             0.65
	#define MACRO_POS_SPACER_X                                      0.002
	#define MACRO_POS_SPACER_Y                                      0.003

	#define MACRO_SCALE_SLOT_SIZE_W                                 0.033 * 0.84
	#define MACRO_SCALE_SLOT_SIZE_H                                 0.055 * 0.84
	#define MACRO_SCALE_SLOT_COUNT_PER_LINE                         12

	#define MACRO_EMPTY_SLOTS_UNDER_GROUND_ITEMS                    3

	#define MACRO_GLOBAL_PIXELPRECISIONMODE                         2





// ------------------------------------------------------------------------------------------------------------------------------------------------
//	CONFIG TYPES
// ------------------------------------------------------------------------------------------------------------------------------------------------

//	#define MACRO_ENUM_CONFIGTYPE_EMPTY                             -2
	#define MACRO_ENUM_CONFIGTYPE_INVALID                           -1

	#define MACRO_ENUM_CONFIGTYPE_CFGWEAPONS                        0
	#define MACRO_ENUM_CONFIGTYPE_CFGVEHICLES                       1
	#define MACRO_ENUM_CONFIGTYPE_CFGMAGAZINES                      2
	#define MACRO_ENUM_CONFIGTYPE_CFGGLASSES                        3



// ------------------------------------------------------------------------------------------------------------------------------------------------
//	ITEM CATEGORIES
// ------------------------------------------------------------------------------------------------------------------------------------------------

	#define MACRO_ENUM_CATEGORY_EMPTY                               -2
	#define MACRO_ENUM_CATEGORY_INVALID                             -1

	// NOTE: Category enums should also be useable as array indexes! Consequently, they must start at 0 (excluding empty/invalid) and must not have any gaps!
	#define MACRO_ENUM_CATEGORY_ITEM                                0
	#define MACRO_ENUM_CATEGORY_WEAPON                              1
	#define MACRO_ENUM_CATEGORY_MAGAZINE                            2

	#define MACRO_ENUM_CATEGORY_UNIFORM                             3
	#define MACRO_ENUM_CATEGORY_VEST                                4
	#define MACRO_ENUM_CATEGORY_BACKPACK                            5
	#define MACRO_ENUM_CATEGORY_CONTAINER                           6

	#define MACRO_ENUM_CATEGORY_NVGS                                7
	#define MACRO_ENUM_CATEGORY_HEADGEAR                            8
	#define MACRO_ENUM_CATEGORY_BINOCULARS                          9
	#define MACRO_ENUM_CATEGORY_GOGGLES                             10

	#define MACRO_ENUM_CATEGORY_OBJECT                              11
	#define MACRO_ENUM_CATEGORY_MAN                                 12





// ------------------------------------------------------------------------------------------------------------------------------------------------
//	ITEM SUB-CATEGORIES
// ------------------------------------------------------------------------------------------------------------------------------------------------

	#define MACRO_ENUM_SUBCATEGORY_INVALID                          -1

	// Weapon sub-categories
	#define MACRO_ENUM_SUBCATEGORY_PRIMARYWEAPON                    0
	#define MACRO_ENUM_SUBCATEGORY_HANDGUNWEAPON                    1
	#define MACRO_ENUM_SUBCATEGORY_SECONDARYWEAPON                  2

	// Item sub-categories
	#define MACRO_ENUM_SUBCATEGORY_MAP                              10
	#define MACRO_ENUM_SUBCATEGORY_GPS                              11
	#define MACRO_ENUM_SUBCATEGORY_RADIO                            12
	#define MACRO_ENUM_SUBCATEGORY_COMPASS                          13
	#define MACRO_ENUM_SUBCATEGORY_WATCH                            14





// ------------------------------------------------------------------------------------------------------------------------------------------------
//	SLOT POSITIONS
// ------------------------------------------------------------------------------------------------------------------------------------------------

	// Null:							[0,0]
	// Default (starting position for items):			[1,1]
	// Use invalid ([-1,-1]) for testing whether or not a slotPos is defined! Null ([0,0]) means it is defined, but the slotPos is empty (i.e. it doesn't matter/isn't used for anything)
	#define MACRO_ENUM_SLOTPOS_INVALID                              -1
	#define MACRO_ENUM_SLOTPOS_DROP                                 -2

	#define MACRO_ENUM_SLOTPOS_PRIMARYWEAPON                        -10
	#define MACRO_ENUM_SLOTPOS_HANDGUNWEAPON                        -11
	#define MACRO_ENUM_SLOTPOS_SECONDARYWEAPON                      -12

	#define MACRO_ENUM_SLOTPOS_NVGS                                 -20
	#define MACRO_ENUM_SLOTPOS_HEADGEAR                             -21
	#define MACRO_ENUM_SLOTPOS_BINOCULARS                           -22
	#define MACRO_ENUM_SLOTPOS_GOGGLES                              -23
	#define MACRO_ENUM_SLOTPOS_MAP                                  -24
	#define MACRO_ENUM_SLOTPOS_GPS                                  -25
	#define MACRO_ENUM_SLOTPOS_RADIO                                -26
	#define MACRO_ENUM_SLOTPOS_COMPASS                              -27
	#define MACRO_ENUM_SLOTPOS_WATCH                                -28

	#define MACRO_ENUM_SLOTPOS_UNIFORM                              -30
	#define MACRO_ENUM_SLOTPOS_VEST                                 -31
	#define MACRO_ENUM_SLOTPOS_BACKPACK                             -32





// ------------------------------------------------------------------------------------------------------------------------------------------------
//	INVENTORY EVENTHANDLER EVENTS
// ------------------------------------------------------------------------------------------------------------------------------------------------

	// Null / default:						""
	// NOTE: Use STR() on these macros to obtain a string!
	#define MACRO_ENUM_EVENT_INIT                                   Init
	#define MACRO_ENUM_EVENT_TAKE                                   Take
	#define MACRO_ENUM_EVENT_DROP                                   Drop
	#define MACRO_ENUM_EVENT_MOVE                                   Move
	#define MACRO_ENUM_EVENT_DRAW                                   Draw
//	#define MACRO_ENUM_EVENT_USE                                    Use
//	#define MACRO_ENUM_EVENT_DELETED                                Deleted
//	#define MACRO_ENUM_EVENT_EACHFRAME                              EachFrm
	#define MACRO_ENUM_EVENT_DRAWCONTAINER                          DrawContnr

/*
	EVENT DOCUMENTATIONS:
	The first parameter of EVERY event is *ALWAYS* the itemData that triggered the event

	MACRO_ENUM_EVENT_INIT
		params ["_itemData", "_UID", "_parentContainer", "_parentContainerData", "_slotPos"];
	MACRO_ENUM_EVENT_TAKE
		params ["_itemData", "_takenBy", "_originContainer", "_originContainerData", "_targetContainer", "_targetContainerData", "_originSlotPos", "_targetSlotPos"];
	MACRO_ENUM_EVENT_DROP
		params ["_itemData", "_droppedBy", "_originContainer", "_originContainerData", "_targetContainer", "_targetContainerData", "_originSlotPos", "_targetSlotPos"];
	MACRO_ENUM_EVENT_MOVE
		params ["_itemData", "_droppedBy", "_originContainer", "_originContainerData", "_targetContainer", "_targetContainerData", "_originSlotPos", "_targetSlotPos"];
	MACRO_ENUM_EVENT_DRAW
		params ["_itemData", "_ctrl", "_display"];
	MACRO_ENUM_EVENT_DRAWCONTAINER
		params ["_itemData", "_ctrlParent", "_display"];


	MACRO_ENUM_EVENT_DRAWCONTAINER
		params ["_containerData", "_ctrlGrp", "_container"];


*/

// ------------------------------------------------------------------------------------------------------------------------------------------------
//	VARIABLE NAMES
// ------------------------------------------------------------------------------------------------------------------------------------------------

	// UI
	#define MACRO_VARNAME_UI_DRAGGEDCTRL                            "draggedControl"
	#define MACRO_VARNAME_UI_ISBEINGDRAGGED                         "isBeingDragged"
	#define MACRO_VARNAME_UI_DEFAULTICONPATH                        "defaultIconPath"
	#define MACRO_VARNAME_UI_FRAMETEMP                              "ctrlFrameTemp"
	#define MACRO_VARNAME_UI_ICONTEMP                               "ctrlIconTemp"
	#define MACRO_VARNAME_UI_CTRLPARENT                             "ctrlParent"
	#define MACRO_VARNAME_UI_OFFSET                                 "offset"
	#define MACRO_VARNAME_UI_ALLSLOTFRAMES                          "allSlotFrames"
	#define MACRO_VARNAME_UI_CTRLSLOTICON                           "ctrlSlotIcon"		// NOT part of a slot's child controls - this is handled by whichever script that's responsible for generating a container's item slots

		// Child controls
		#define MACRO_VARNAME_UI_CHILDCONTROLS                          "childControls"
		#define MACRO_VARNAME_UI_CTRLICON                               "ctrlIcon"
//		#define MACRO_VARNAME_UI_CTRLOUTLINE                            "ctrlOutline"
		#define MACRO_VARNAME_UI_CTRLAMMOBARFRONT                       "ctrlAmmoBarFront"
		#define MACRO_VARNAME_UI_CTRLAMMOBARBACK                        "ctrlAmmoBarBack"

	#define MACRO_VARNAME_UI_NEXTUPDATE_GROUND                      "nextUpdate_ground"
	#define MACRO_VARNAME_UI_FORCEREDRAW_GROUND                     "forceRedraw_ground"
	#define MACRO_VARNAME_UI_ACTIVECONTAINER                        "activeContainer"
	#define MACRO_VARNAME_UI_ACTIVECONTAINER_VISIBLE                "activeContainer_visible"
	#define MACRO_VARNAME_UI_GROUND_HIGHESTPOSY                     "highestPosY"

	#define MACRO_VARNAME_UI_GROUND_CTRLS                           "groundHolderCtrls"
	#define MACRO_VARNAME_UI_GROUND_NAMESPACE                       "groundNamespace"
	#define MACRO_VARNAME_UI_WEAPONS_ITEMDATAS                      "weaponsItemData"
	#define MACRO_VARNAME_UI_STORAGE_CONTAINERS                     "storageContainers"
	#define MACRO_VARNAME_UI_STORAGE_CURRENTINDEX_ITEM              "storage_curIndexItem"
	#define MACRO_VARNAME_UI_STORAGE_CURRENTINDEX_CONTAINER         "storage_curIndexContainer"
	#define MACRO_VARNAME_UI_STORAGE_MAXITERATIONS                  "storage_maxIterations"
	#define MACRO_VARNAME_UI_STORAGE_INITIALISED                    "storage_init"

	#define MACRO_VARNAME_UI_CURSORCTRL                             "cursorCtrl"
	#define MACRO_VARNAME_UI_CURSORPOSREL                           "cursorPosRel"
	#define MACRO_VARNAME_UI_CURSORPOSNEW                           "cursorPosNew"
	#define MACRO_VARNAME_UI_HIGHLITCONTROLS                        "dragging_highlitControls"
	#define MACRO_VARNAME_UI_ALLOWEDCONTROLS                        "dragging_allowedControls"
	#define MACRO_VARNAME_UI_FORBIDDENCONTROLS                      "dragging_forbiddenControls"

	#define MACRO_VARNAME_UI_EH_MOUSEBUTTONUP                       "EH_mouseButtonUp"
	#define MACRO_VARNAME_UI_EH_MOUSEBUTTONDOWN                     "EH_mouseButtonDown"
	#define MACRO_VARNAME_UI_EH_KEYDOWN                             "EH_keyDown"
	#define MACRO_VARNAME_UI_EH_EACHFRAME                           "cre8ive_inventory_EH_eachFrame"
	#define MACRO_VARNAME_UI_INITIALISED                            "isInit"
	#define MACRO_VARNAME_UI_LASTMOUSEPOS                           "cre8ive_inventory_lastMousePos"
	#define MACRO_VARNAME_UI_LASTMOUSEPOS_LOADED                    "lastMousePos_loaded"


	// Items and containers
	#define MACRO_VARNAME_UID                                       "UID"
	#define MACRO_VARNAME_DATA                                      "data"
	#define MACRO_VARNAME_CLASS                                     "class"
	#define MACRO_VARNAME_CATEGORY                                  "category"
	#define MACRO_VARNAME_CONFIGTYPE                                "configType"
	#define MACRO_VARNAME_SLOTSIZE                                  "slotSize"
	#define MACRO_VARNAME_SLOTPOS                                   "slotPos"
	#define MACRO_VARNAME_SLOT_X_Y                                  "slot_%1_%2"
	#define MACRO_VARNAME_OCCUPIEDSLOTS                             "occupiedSlots"
	#define MACRO_VARNAME_ITEMS                                     "items"
	#define MACRO_VARNAME_CONTAINER                                 "container"
	#define MACRO_VARNAME_PARENT                                    "parent"
	#define MACRO_VARNAME_PARENTDATA                                "parentData"
	#define MACRO_VARNAME_ISROTATED                                 "isRotated"

	#define MACRO_VARNAME_CONTAINERSIZE                             "containerSize"
	#define MACRO_VARNAME_CONTAINERSLOTSONLASTY                     "containerSlotsOnLastY"

	#define MACRO_VARNAME_MAG_AMMO                                  "ammo"

	#define MACRO_VARNAME_ACC_MUZZLE                                "accMuzzle"
	#define MACRO_VARNAME_ACC_BIPOD                                 "accBipod"
	#define MACRO_VARNAME_ACC_SIDE                                  "accSide"
	#define MACRO_VARNAME_ACC_OPTIC                                 "accOptic"
	#define MACRO_VARNAME_MAG                                       "magazine"
	#define MACRO_VARNAME_MAGALT                                    "magazineAlt"

	#define MACRO_VARNAME_UI_ACC_MUZZLE                             "ctrlAccMuzzle"
	#define MACRO_VARNAME_UI_ACC_BIPOD                              "ctrlAccBipod"
	#define MACRO_VARNAME_UI_ACC_SIDE                               "ctrlAccSide"
	#define MACRO_VARNAME_UI_ACC_OPTIC                              "ctrlAccOptic"
	#define MACRO_VARNAME_UI_MAG                                    "ctrlMagazine"
	#define MACRO_VARNAME_UI_MAGALT                                 "ctrlMagazineAlt"
	#define MACRO_VARNAME_UI_DISPLAYNAME                            "ctrlDisplayName"

	// Config entries
	#define MACRO_VARNAME_CFG_SLOTSIZE                              "cre8ive_slotSize"
	#define MACRO_VARNAME_CFG_CONTAINERSIZE                         "cre8ive_containerSize"
	#define MACRO_VARNAME_CFG_SLOTSONLASTY                          "cre8ive_slotsOnLastY"
	#define MACRO_VARNAME_CFG_INVDISTANCE                           "cre8ive_inventoryDistance"





// ------------------------------------------------------------------------------------------------------------------------------------------------
//	INVENTORY UI EVENT MODES
// ------------------------------------------------------------------------------------------------------------------------------------------------

	// Modes for ui_storage_update
	//#define MACRO_VARNAME_UI_UPDATE_STORAGE_CONTAINERS              0
	//#define MACRO_VARNAME_UI_UPDATE_STORAGE_CONTENTS                1





// ------------------------------------------------------------------------------------------------------------------------------------------------
//	DEV / DEBUGGING
// ------------------------------------------------------------------------------------------------------------------------------------------------

	// Debug toggles - uncomment to enable debug outputs in the respective script
	//#define MACRO_DEBUG_GETCLASSICON




// ------------------------------------------------------------------------------------------------------------------------------------------------
//	OTHERS / EXTRAS
// ------------------------------------------------------------------------------------------------------------------------------------------------

	// Overall inventory storage capacity scaling
	#define MACRO_STORAGE_CAPACITY_MULTIPLIER                       0.5

	// Ground menu settings
	#define MACRO_GROUND_UPDATE_DELAY                               0.05
	#define MACRO_GROUND_MAX_DISTANCE                               2.5

	// Ground holder classnames
	#define MACRO_CLASSES_GROUNDHOLDERS                             ["GroundWeaponHolder", "GroundWeaponHolder_Scripted", "WeaponHolderSimulated", "WeaponHolderSimulated_Scripted"]

	// Name of the UI
	#define MACRO_GUI_NAME                                          Rsc_Cre8ive_Inventory

	// Name of the Inventory Event Handlers classname
	#define MACRO_CLASSNAME_IEH                                     Cre8ive_Inventory_EventHandlers
	#define MACRO_CLASSNAME_IEH_CATEGORY                            Cre8ive_Inventory_EventHandlers_Category

	// IEH Category classnames
	#define MACRO_CLASSNAME_IEH_CATEGORY_ITEM                       Category_Item
	#define MACRO_CLASSNAME_IEH_CATEGORY_WEAPON                     Category_Weapon
	#define MACRO_CLASSNAME_IEH_CATEGORY_MAGAZINE                   Category_Magazine

	#define MACRO_CLASSNAME_IEH_CATEGORY_UNIFORM                    Category_Uniform
	#define MACRO_CLASSNAME_IEH_CATEGORY_VEST                       Category_Vest
	#define MACRO_CLASSNAME_IEH_CATEGORY_BACKPACK                   Category_Backpack
	#define MACRO_CLASSNAME_IEH_CATEGORY_CONTAINER                  Category_Container
	//		^	used by the drysack, ammo box and first aid kit containers

	#define MACRO_CLASSNAME_IEH_CATEGORY_NVGS                       Category_NVGs
	#define MACRO_CLASSNAME_IEH_CATEGORY_HEADGEAR                   Category_Headgear
	#define MACRO_CLASSNAME_IEH_CATEGORY_BINOCULARS                 Category_Binoculars
	#define MACRO_CLASSNAME_IEH_CATEGORY_GOGGLES                    Category_Goggles

/*
	// Determine which config file the UI is defined in (mission or addon format)
	#define MACRO_CONFIG_FILE_SWITCH

	#ifdef MACRO_CONFIG_FILE_SWITCH
		#define MACRO_CONFIG_FILE missionConfigFile
	#else
		#define MACRO_CONFIG_FILE configFile
	#endif
*/





// ------------------------------------------------------------------------------------------------------------------------------------------------
//	SQF MACRO FUNCTIONS
// ------------------------------------------------------------------------------------------------------------------------------------------------

	#include "sqf\macro_UI_createPictureIcon.hpp"
	#include "sqf\macro_UI_createOutline.hpp"
	#include "sqf\macro_UI_ctrl_setPosition.hpp"
//	#include "sqf\macro_UI_ctrl_calculateOffset.hpp"
