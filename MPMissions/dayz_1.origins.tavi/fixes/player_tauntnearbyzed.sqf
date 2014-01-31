////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Player_TauntNearbyZed.SQF
// Taunt Nearby Zombies - by BDC - Aug 14 2013, for DayZ 1.7.7.1 
//
// BDC's Sanctuary Private DayZ Server - RaidCall group 6824535
// This script allows the player, while wielding a hunting knife, to injure his or herself, creating a bleeding wound,
// combined with a loud scream, in an attempt to gather the aggro of any zombies nearby to a high percentage. There 
// are three looped rounds of point-blank area of effect taunts made based upon the bleeding wound to keep said aggro (or
// gain new aggro) in two-second intervals. A modifier to this is the possibility of a severe and painful wound (18%
// chance that will create 6 rounds of aggro instead of three. 
//
// This option will only activate itself if the player has a zombie targeted (cursorTarget) and that zombie target is within a distance of 35m.
//
// Called directly from a modification done to fn_SelfActions.SQF with a portion borrowed from player_alertZombies.sqf
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

private["_FemalePanic","_MalePanic","_LoopCount","_SevereWound","_SevereWoundMultiplier","_SeverelyWounded","_isFemale","_hit","_wound","_damage","_hasKnife","_firstMaleScream","_secondMaleScream","_firstFemaleScream","_secondFemaleScream","_AggroDist","_listTalk","_pos","_target","_targets","_chanceToAggro","_zombie"];

// Core variables
_hasKnife = "ItemKnife" in items player;
_MaleScream = "scream"; // scream_short_0 // z_scream_0  z_scream0_0
_FemaleScream = "screamw"; // scream_woman_4
_MalePanic = "panic";
_FemalePanic = "panicw";
_SeverelyWounded = false;

// Configurable variables 
_AggroDist = 35; // distance in meters to attract zombies when screaming and bleeding (default: 35)
_SevereWoundMultiplier = 1.5; // Multiplier of _AggroDist when player accidentally severely wounds his or herself (default: 1.5)

// Initial Disqualifications
if (!_hasKnife) exitwith { cutText [format["You must have a hunting knife to perform this action."], "PLAIN DOWN"]; };

// Grab gender type (currently based upon the outfit "skin")
_isFemale = ((typeOf player == "SurvivorW2_DZ")||(typeOf player == "BanditW1_DZ"));

// Slight delay at beginning to allow player to stand up from crouch or prone position  
  sleep 0.25; 

// Determine if self-injury is moderate or is more severe and painful  
_SevereWound = random 1;
if (_SevereWound >= 0.82) then { // 18% chance to cause very bad cut
  _damage = 2.00;
  r_player_inpain = true;
  player setVariable["USEC_inPain",true,true];
  _SeverlyWounded = true;
  _AggroDist = (_AggroDist * _SevereWoundMultiplier); // Set multiplier to aggro distance variable to increase aggro range
  _LoopCount = 6;
  cutText [format["You accidentally cause a very painful, severely bleeding wound and start screaming uncontrollably!"], "PLAIN DOWN"];
} else {
  _damage = 0.70;
  _LoopCount = 3;
  cutText [format["You create a moderate bleeding wound and start screaming."], "PLAIN DOWN"];
};
  
//Create the Bleeding Wound
_hit = "body";
_wound = _hit call fnc_usec_damageGetWound;
r_player_blood = r_player_blood - (_damage * 1);
player setVariable["USEC_BloodQty",r_player_blood,true];
player setVariable["hit_"+_wound,true,true];
PVDZ_hlt_Bleed = [player,_wound,_damage];
publicVariable "PVDZ_hlt_Bleed"; 
[player,_wound,_hit] spawn fnc_usec_damageBleed; 
dayz_sourceBleeding = player;
r_player_injured = true;
player setVariable["USEC_injured",true,true];
player setVariable["medForceUpdate",true,true];

// Start waves of point-blank area of effect taunt
for "_x" from 1 to _LoopCount do {

	// Player screams
	if (_isFemale) then {
		[player,_FemaleScream,0,false,_AggroDist] call dayz_zombieSpeak;
	} else {
		[player,_MaleScream,0,false,_AggroDist] call dayz_zombieSpeak; 
	};

	// Grab player position and list of zombies nearby (taken from player_alertZombies.sqf and modified
	_pos = (getPosATL player);
	_listTalk = _pos nearEntities ["zZombie_Base",_AggroDist];
	{
		_zombie = _x;
		_targets = _zombie getVariable ["targets",[]];
		_chanceToAggro = random 1;
		if (_SeverelyWounded) then { _chanceToAggro = 1; }; // If severely wounded, aggro chance = 100%
		if (_chanceToAggro > 0.22) then { // 78% chance to grab aggro if regular wound
			if (!(player in _targets)) then {
				_targets set [count _targets, player];
				_zombie setVariable ["targets",_targets, true];
			};
		};
	} forEach _listTalk;

	// Slight pause
	sleep 2.25;
};

// Final panic sounds from severely wounded folk'
if (_SeverelyWounded) then {
	if (_isFemale) then {
		[player,_FemalePanic,0,false,_AggroDist] call dayz_zombieSpeak;
	} else {
		[player,_MalePanic,0,false,_AggroDist] call dayz_zombieSpeak; 
	};
};

// Prevent Taunt option from re-appearing for a bit
sleep 25;

// Completion - reset taunt flags for fn_selfActions
player removeAction s_player_tauntzed;
s_player_tauntzed = -1;