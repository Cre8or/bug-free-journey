//player setUnitLoadout [["arifle_Mk20_GL_plain_F","","acc_pointer_IR","optic_Aco",["30Rnd_556x45_Stanag",30],[],""],[],["hgun_P07_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_CombatUniform_mcam",[["FirstAidKit",1],["Chemlight_green",1,1]]],["V_PlateCarrier1_rgr",[["16Rnd_9x21_Mag",2,16],["SmokeShell",1,1],["SmokeShellGreen",1,1],["Chemlight_green",1,1],["HandGrenade",2,1]]],[],"H_HelmetB","G_Aviator",[],["ItemMap","","ItemRadio","ItemCompass","ItemWatch","NVGoggles"]];

sleep 2;

removeBackpack player;
//systemChat "Removed bag";

private _weapon = primaryWeapon player;
private _optic = (player weaponAccessories _weapon) select 2;
player removeWeapon _weapon;

sleep 2;

//systemChat "Added bag";
player addBackpack "B_AssaultPack_blk";
private _targetContainer = backpackContainer player;

_targetContainer addItemCargoGlobal ["Cre8ive_Container_AmmoBox", 1];
_targetContainer addItemCargoGlobal ["Cre8ive_Container_FirstAidKit", 1];
_targetContainer addItemCargoGlobal ["Cre8ive_Container_Drysack", 1];


sleep 0.5 + random 0.5;

/*
player removeWeapon _weapon;
player addWeapon selectRandom ([
	"arifle_MX_GL_Black_F",
	"arifle_Mk20C_plain_F",
	"arifle_Katiba_F",
	"srifle_DMR_06_olive_F",
	"SMG_03C_TR_black"
] - [_weapon]);
*/

player addWeapon _weapon;
if (_optic != "") then {
	removeAllPrimaryWeaponItems player;
} else {
	player addPrimaryWeaponItem "optic_ACO_grn";
};
