removeBackpack player;
player addBackpack "B_CarryAll_oucamo";
private _targetContainer = backpackContainer player;
//private _targetContainer = cursorTarget;

if (!alive _targetContainer) exitWith {};





// Clear the container
//clearBackpackCargoGlobal _targetContainer;
//clearItemCargoGlobal _targetContainer;

private _listOld = everyContainer _targetContainer;

_targetContainer addItemCargoGlobal ["U_C_IDAP_Man_cargo_F", 1];
_targetContainer addItemCargoGlobal ["V_Safety_orange_F", 1];
_targetContainer addItemCargoGlobal ["U_C_IDAP_Man_Jeans_F", 1];
_targetContainer addItemCargoGlobal ["U_OrestesBody", 1];
/*
_targetContainer addItemCargoGlobal ["U_I_FullGhillie_sard", 1];
_targetContainer addItemCargoGlobal ["U_BG_Guerilla3_1", 1];
_targetContainer addItemCargoGlobal ["V_Chestrig_rgr", 1];
_targetContainer addItemCargoGlobal ["U_C_IDAP_Man_casual_F", 1];
_targetContainer addItemCargoGlobal ["V_PlateCarrier1_blk", 1];
_targetContainer addItemCargoGlobal ["U_C_Man_sport_1_F", 1];
_targetContainer addItemCargoGlobal ["V_DeckCrew_red_F", 1];
_targetContainer addItemCargoGlobal ["U_C_Poor_1", 1];
_targetContainer addItemCargoGlobal ["U_O_T_Sniper_F", 1];
_targetContainer addItemCargoGlobal ["V_PlateCarrierGL_rgr", 1];
_targetContainer addItemCargoGlobal ["V_Press_F", 1];
_targetContainer addItemCargoGlobal ["U_B_CTRG_2", 1];
_targetContainer addItemCargoGlobal ["V_LegStrapBag_olive_F", 1];
_targetContainer addItemCargoGlobal ["U_Competitor", 1];
_targetContainer addItemCargoGlobal ["V_BandollierB_rgr", 1];

listNew = (everyContainer _targetContainer) - _listOld;
copyToClipboard str listNew;
*/
