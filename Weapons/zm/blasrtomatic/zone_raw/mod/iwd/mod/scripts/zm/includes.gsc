#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;

init()
{
    //add_zombie_weapon( weapon_name, upgrade_name, hint, cost, weaponvo, weaponvoresp, ammo_cost, create_vox )
	add_zombie_weapon( "t9_blastomatic_zm", "t9_blastomatic_upgraded_zm", &"WEAPON_T9_GALLO_BLASTOMATIC_ZM", 10, "wpck_shotgun", "", undefined, 1 );
}

main()
{
	include_weapons();
}

include_weapons()
{
	// Include the weapon in the box and precache item
	include_weapon( "t9_blastomatic_zm" );
	include_weapon( "t9_blastomatic_upgraded_zm", 0 );
	//add_limited_weapon( "", 1 );
}
