enableSaving [false, false];



// Functions
//cre_fnc_arrayToCA = compile preprocessFileLineNumbers "functions\fnc_arrayToCA.sqf";
//cre_fnc_generateUID = compile preprocessFileLineNumbers "functions\fnc_generateUID.sqf";
//cre_fnc_addWeaponWithItems = compile preprocessFileLineNumbers "functions\fnc_addWeaponWithItems.sqf";


/*
if (is3DEN) then {createDialog "Rsc_Cre8ive_Inventory"} else {["ui_init"] call cre_fnc_ui_inventory}
*/



// TODO: Push these functions to description.ext
//cre_fnc_cfg_getClassSlotSize = compile preprocessFileLineNumbers "scripts\config\fn_cfg_getClassSlotSize.sqf";
//cre_fnc_cfg_getContainerSize = compile preprocessFileLineNumbers "scripts\config\fn_cfg_getContainerSize.sqf";

cre_fnc_ui_inventory = compile preprocessFileLineNumbers "scripts\ui\fn_ui_inventory.sqf";
cre_fnc_ui_deleteSlotCtrl = compile preprocessFileLineNumbers "scripts\ui\fn_ui_deleteSlotCtrl.sqf";
cre_fnc_ui_generateChildControls = compile preprocessFileLineNumbers "scripts\ui\fn_ui_generateChildControls.sqf";

cre_fnc_inv_generateContainerData = compile preprocessFileLineNumbers "scripts\inventory\fn_inv_generateContainerData.sqf";
cre_fnc_inv_canFitItem = compile preprocessFileLineNumbers "scripts\inventory\fn_inv_canFitItem.sqf";
cre_fnc_inv_moveItem = compile preprocessFileLineNumbers "scripts\inventory\fn_inv_moveItem.sqf";
cre_fnc_inv_handleFakeMass = compile preprocessFileLineNumbers "scripts\inventory\fn_inv_handleFakeMass.sqf";
cre_fnc_inv_getInvMass = compile preprocessFileLineNumbers "scripts\inventory\fn_inv_getInvMass.sqf";
cre_fnc_inv_getRealMass = compile preprocessFileLineNumbers "scripts\inventory\fn_inv_getRealMass.sqf";

cre_fnc_inv_getClassCountsByCategory = compile preprocessFileLineNumbers "scripts\inventory\commands\fn_inv_getClassCountsByCategory.sqf";
cre_fnc_inv_getEveryContainer = compile preprocessFileLineNumbers "scripts\inventory\commands\fn_inv_getEveryContainer.sqf";
cre_fnc_inv_getItemsByCategory = compile preprocessFileLineNumbers "scripts\inventory\commands\fn_inv_getItemsByCategory.sqf";
//cre_fnc_inv_isContainer = compile preprocessFileLineNumbers "scripts\inventory\commands\fn_inv_isContainer.sqf";

cre_fnc_util_quickSort = compile preprocessFileLineNumbers "scripts\util\quickSort\fn_util_quickSort.sqf";
cre_fnc_util_quickSort_internal = compile preprocessFileLineNumbers "scripts\util\quickSort\fn_util_quickSort_internal.sqf";
cre_fnc_util_quickSort_partition = compile preprocessFileLineNumbers "scripts\util\quickSort\fn_util_quickSort_partition.sqf";
cre_fnc_util_quickSort_swap = compile preprocessFileLineNumbers "scripts\util\quickSort\fn_util_quickSort_swap.sqf";

if (isNil "cre_inv_synchroniser") then {cre_inv_synchroniser = scriptNull}; terminate cre_inv_synchroniser;
cre_inv_synchroniser = [] spawn compile preprocessFileLineNumbers "scripts\inventory\fn_inv_synchroniser.sqf";

// Bonus stuff
cre_warfare = [] spawn compile preprocessFileLineNumbers "scripts\AI\fn_handleWarfare.sqf";



// Test script
player addAction ["<t color='#00DD00'>test.sqf</t>", {if (isNil "cre_handle") then {cre_handle = scriptNull}; terminate cre_handle; cre_handle = [] spawn compile preprocessFileLineNumbers "debug\test.sqf"}, nil, 10, false, false];
