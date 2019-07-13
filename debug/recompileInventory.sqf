// TODO: Push these functions to description.ext
//cre_fnc_cfg_getClassSlotSize = compile preprocessFileLineNumbers "scripts\config\fn_cfg_getClassSlotSize.sqf";
//cre_fnc_cfg_getContainerSize = compile preprocessFileLineNumbers "scripts\config\fn_cfg_getContainerSize.sqf";





// DEBUG
cre_fnc_debug_printIEH = compile preprocessFileLineNumbers "debug\fn_debug_printIEH.sqf";





// Config
cre_fnc_cfg_getClassIEHs = compile preprocessFileLineNumbers "scripts\config\fn_cfg_getClassIEHs.sqf";

// IEHs
cre_fnc_IEH_raiseEvent = compile preprocessFileLineNumbers "scripts\IEH\fn_IEH_raiseEvent.sqf";
cre_fnc_IEH_default_drawContainer = compile preprocessFileLineNumbers "scripts\IEH\fn_IEH_default_drawContainer.sqf";
cre_fnc_IEH_man_drawContainer = compile preprocessFileLineNumbers "scripts\IEH\fn_IEH_man_drawContainer.sqf";

// Inventory
cre_fnc_inv_generateContainerData = compile preprocessFileLineNumbers "scripts\inventory\fn_inv_generateContainerData.sqf";
cre_fnc_inv_canFitItem = compile preprocessFileLineNumbers "scripts\inventory\fn_inv_canFitItem.sqf";
cre_fnc_inv_moveItem = compile preprocessFileLineNumbers "scripts\inventory\fn_inv_moveItem.sqf";
cre_fnc_inv_handleFakeMass = compile preprocessFileLineNumbers "scripts\inventory\fn_inv_handleFakeMass.sqf";
cre_fnc_inv_getInvMass = compile preprocessFileLineNumbers "scripts\inventory\fn_inv_getInvMass.sqf";
cre_fnc_inv_getRealMass = compile preprocessFileLineNumbers "scripts\inventory\fn_inv_getRealMass.sqf";

// Inventory commands
cre_fnc_inv_canOpenContainer = compile preprocessFileLineNumbers "scripts\inventory\commands\fn_inv_canOpenContainer.sqf";
cre_fnc_inv_getClassCountsByCategory = compile preprocessFileLineNumbers "scripts\inventory\commands\fn_inv_getClassCountsByCategory.sqf";
cre_fnc_inv_getEveryContainer = compile preprocessFileLineNumbers "scripts\inventory\commands\fn_inv_getEveryContainer.sqf";
cre_fnc_inv_getItemsByCategory = compile preprocessFileLineNumbers "scripts\inventory\commands\fn_inv_getItemsByCategory.sqf";

// Util
cre_fnc_util_quickSort = compile preprocessFileLineNumbers "scripts\util\quickSort\fn_util_quickSort.sqf";
cre_fnc_util_quickSort_internal = compile preprocessFileLineNumbers "scripts\util\quickSort\fn_util_quickSort_internal.sqf";
cre_fnc_util_quickSort_partition = compile preprocessFileLineNumbers "scripts\util\quickSort\fn_util_quickSort_partition.sqf";
cre_fnc_util_quickSort_swap = compile preprocessFileLineNumbers "scripts\util\quickSort\fn_util_quickSort_swap.sqf";

// UI
cre_fnc_ui_deleteSlotCtrl = compile preprocessFileLineNumbers "scripts\ui\fn_ui_deleteSlotCtrl.sqf";
cre_fnc_ui_generateChildControls = compile preprocessFileLineNumbers "scripts\ui\fn_ui_generateChildControls.sqf";
cre_fnc_ui_inventory = compile preprocessFileLineNumbers "scripts\ui\fn_ui_inventory.sqf";

// Synchroniser
if (isNil "cre_inv_synchroniser") then {cre_inv_synchroniser = scriptNull};
terminate cre_inv_synchroniser;
cre_inv_synchroniser = [] spawn compile preprocessFileLineNumbers "scripts\inventory\fn_inv_synchroniser.sqf";

// Compile IEHs
call compile preprocessFileLineNumbers "scripts\config\fn_cfg_compileIEHs.sqf";





// Other stuff
enableEnvironment false;
