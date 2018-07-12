/*
        Name:
        cre_fnc_addWeaponWithItems

        Arguments:
        0: _container [OBJECT]:         Loot container to add weapon to         REQUIRED!
        1: _weapon [STRING]:            Class of weapon to be added             REQUIRED!
        2: _magazine [ARRAY]:           Array with class of magazine to be added, aswell as its ammo count - ["MagazineType", AmountOfBullets]          DEFAULT: []
        3: _items [ARRAY]:              Array of attachment classes that should be attached to the weapon - ["Muzzle", "Rail", "UnderBarrel", "Optic"]          DEFAULT: []

        Example:
        [cursorTarget, "arifle_MX_F", ["30Rnd_65x39_caseless_mag_Tracer", 19], ["muzzle_snds_H","optic_DMS","bipod_01_F_blk"]] spawn cre_fnc_addWeaponWithItems
*/

params [
        ["_container", objNull, [objNull]],
        ["_weapon", "", [""]],
        ["_magazine", [], [[]], 2],
        ["_items", [], [[]]]
];

// Exit if no loot container or weapon class was provided
if (isNull _container or _weapon == "") exitWith {};





// Set up the AI
private _start = time;
//private _center = createCenter civilian;
//private _group = createGroup _center;
//private _filler = _group createUnit [ "C_Man_1", [0,0,0], [], 0, "CAN_COLLIDE" ];
private _filler = createAgent [ "C_Man_1", [0,0,0], [], 0, "CAN_COLLIDE" ];
hideObject _filler;
_filler allowDamage false;
_filler setAnimSpeedCoef 100;
_filler addBackpack "B_Carryall_mcamo";

// Prevent the AI from doing anything stupid
{_filler disableAI _x} forEach [
        "ANIM",
        "MOVE",
        "FSM",
        "TARGET",
        "AUTOTARGET"
];





// Add the magazine, the weapon and the items
systemChat format ["(%1) Equipping weapon...", time - _start];

if !(_magazine isEqualTo []) then {_filler addMagazine _magazine};

_filler addWeapon _weapon;
removeAllItemsWithMagazines _filler;
removeAllPrimaryWeaponItems _filler;
removeAllHandgunItems _filler;
_filler setVehicleAmmo 0;
{_filler addWeaponItem [_weapon, _x]} forEach _items;

// Put the weapon in the loot container
_filler setPosATL (getPosATL _container);
_filler action ["PutWeapon", _container, _weapon];

systemChat format ["(%1) Waiting for anim change...", time - _start];
private _oldAnim = animationState _filler;
private _loop = true;
while {_loop} do {
        if (animationState _filler != _oldAnim or (time - _start) > 5) then {_loop = false};
        sleep 0.01;
};

systemChat format ["(%1) Switching anim...", time - _start];
_filler switchMove "AinvPercMstpSnonWnonDnon_Putdown_AmovPercMstpSnonWnonDnon";





// Once the weapon has been added, remove the AI
waitUntil {(!(_filler hasWeapon _weapon) or (time - _start > 5))};

deleteVehicle _filler;
systemChat format ["Done! (%1)", time - _start];
