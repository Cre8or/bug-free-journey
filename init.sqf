enableSaving [false, false];



// Functions
//cre_fnc_arrayToCA = compile preprocessFileLineNumbers "functions\fnc_arrayToCA.sqf";
//cre_fnc_generateUID = compile preprocessFileLineNumbers "functions\fnc_generateUID.sqf";
//cre_fnc_addWeaponWithItems = compile preprocessFileLineNumbers "functions\fnc_addWeaponWithItems.sqf";


/*
if (is3DEN) then {createDialog "Rsc_Cre8ive_Inventory"} else {["ui_init"] call cre_fnc_inventory}
*/

// TODO: Push these functions to description.ext
cre_fnc_inventory = compile preprocessFileLineNumbers "scripts\inventory\fn_inventory.sqf";
cre_fnc_generateContainerData = compile preprocessFileLineNumbers "scripts\inventory\fn_generateContainerData.sqf";
cre_fnc_generateChildControls = compile preprocessFileLineNumbers "scripts\inventory\fn_generateChildControls.sqf";
cre_fnc_canFitItem = compile preprocessFileLineNumbers "scripts\inventory\fn_canFitItem.sqf";

cre_warfare = [] spawn compile preprocessFileLineNumbers "scripts\AI\fn_handleWarfare.sqf";
