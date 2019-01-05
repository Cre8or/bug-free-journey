removeBackpack player;
player addBackpack "B_AssaultPack_blk";
private _targetContainer = backpackContainer player;
//private _targetContainer = cursorTarget;

if (!alive _targetContainer) exitWith {};





// Clear the container
//clearBackpackCargoGlobal _targetContainer;
//clearItemCargoGlobal _targetContainer;

_targetContainer addItemCargoGlobal ["Cre8ive_Container_AmmoBox", 1];
_targetContainer addItemCargoGlobal ["Cre8ive_Container_FirstAidKit", 1];
_targetContainer addItemCargoGlobal ["Cre8ive_Container_Drysack", 1];
