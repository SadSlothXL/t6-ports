#include clientscripts\mp\zombies\_zm_weapons;

main()
{
	include_weapons();
}

include_weapons()
{
	// Include the weapon in the box and precache item
	include_weapon( "t9_blastomatic_zm" );
	include_weapon( "t9_blastomatic_upgraded_zm", 0 );
}
