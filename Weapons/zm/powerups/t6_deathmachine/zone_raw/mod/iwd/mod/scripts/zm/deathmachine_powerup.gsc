#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_laststand;

init()
{
    level thread onplayerconnect();

    precachemodel( "zombie_pickup_minigun" );
    precacheitem( "deathmachine_zm" );

    level.deathmachine_weapon = "deathmachine_zm";
    level.deathmachine_duration = getdvarintdefault( "sv_deathmachine_duration", 30 );

    include_zombie_powerup( "deathmachine" );
    add_zombie_powerup( "deathmachine", "zombie_pickup_minigun", &"ZOMBIE_POWERUP_MINIGUN", ::drop_deathmachine, 0, 0, 0 );
    powerup_set_can_pick_up_in_last_stand( "deathmachine", 0 );

    maps\mp\zombies\_zm_spawner::register_zombie_damage_callback( ::deathmachine_damage_response );
}

onplayerconnect()
{
    for ( ;; )
    {
        level waittill( "connected", player );
        player thread onplayerspawned();
    }
}

onplayerspawned()
{
    self endon( "disconnect" );
    level endon( "end_game" );

    for ( ;; )
    {
        self waittill( "spawned_player" );

        deathmachine_clear_powerup_state( self );

        if ( !isDefined( level.deathmachine_powerup_init_done ) )
        {
            wait 2;

            if ( isDefined( level._zombiemode_powerup_grab ) )
            {
                level.original_deathmachine_powerup_grab = level._zombiemode_powerup_grab;
            }

            level._zombiemode_powerup_grab = ::custom_powerup_grab;
            level.deathmachine_powerup_init_done = 1;
        }

        self notify( "restart_deathmachine_test" );
        //self thread powerup_test();
    }
}
/*
powerup_test()
{
    self endon( "disconnect" );
    self endon( "death" );
    self endon( "restart_deathmachine_test" );
    level endon( "end_game" );

    wait 3;

    for ( ;; )
    {
        if ( self meleebuttonpressed() )
        {
            if ( !isDefined( self.deathmachine_melee_spawn_lock ) || !self.deathmachine_melee_spawn_lock )
            {
                self.deathmachine_melee_spawn_lock = 1;

                drop_origin = self.origin + VectorScale( AnglesToForward( self.angles ), 70 );

                iprintln( "^6Death Machine Spawned" );
                level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop( "deathmachine", drop_origin );
            }
        }
        else
        {
            self.deathmachine_melee_spawn_lock = 0;
        }

        wait 0.05;
    }
}*/

drop_deathmachine()
{
    if ( is_true( getdvarintdefault( "sv_deathmachine_powerup", 1 ) ) )
    {
        return 1;
    }

    return 0;
}

deathmachine_damage_response( mod, hit_location, hit_origin, player, amount )
{
    if ( !isDefined( player ) || !isPlayer( player ) )
        return false;

    if ( !isDefined( player.deathmachine_active ) || !player.deathmachine_active )
        return false;

    weapon = get_deathmachine_weapon();

    if ( player getcurrentweapon() != weapon )
        return false;

    if ( !isDefined( amount ) || amount <= 0 )
        return false;

    if ( isDefined( self.deathmachine_forced_kill ) && self.deathmachine_forced_kill )
        return false;

    if ( !isAlive( self ) || !isDefined( self.health ) || self.health <= 0 )
        return false;

    if ( !isDefined( hit_origin ) )
        hit_origin = self.origin;

    if ( deathmachine_during_instakill( player ) )
    {
        final_damage = self.health + 666;
    }
    else
    {
        bonus_damage = self.health * randomfloatrange( 0.34, 0.75 );
        final_damage = amount + bonus_damage;
    }

    self.deathmachine_forced_kill = 1;
    self DoDamage( final_damage, hit_origin, player, player, hit_location, mod, 0, weapon );
    self.deathmachine_forced_kill = undefined;

    return true;
}

deathmachine_during_instakill( player )
{
    if ( !isDefined( player ) || !isPlayer( player ) || !isAlive( player ) )
        return false;

    if ( isDefined( level.zombie_vars ) && isDefined( player.team ) && isDefined( level.zombie_vars[player.team] ) && isDefined( level.zombie_vars[player.team]["zombie_insta_kill"] ) && level.zombie_vars[player.team]["zombie_insta_kill"] )
        return true;

    if ( isDefined( player.personal_instakill ) && player.personal_instakill )
        return true;

    return false;
}

set_powerup_state( player )
{
    if ( !isDefined( player ) || !isPlayer( player ) )
    {
        return;
    }

    player.deathmachine_active = 1;
    player.has_minigun = 1;
    player.has_powerup_weapon = 1;
    player._show_solo_hud = 1;
    player setclientammocounterhide( 1 );
    player setclientdvar( "deathmachine_powerup_state", 1 );
}

deathmachine_clear_powerup_state( player )
{
    if ( !isDefined( player ) || !isPlayer( player ) )
    {
        return;
    }

    player.deathmachine_active = undefined;
    player.has_minigun = 0;
    player.has_powerup_weapon = 0;
    player._show_solo_hud = 0;
    player setclientammocounterhide( 0 );
    player setclientdvar( "deathmachine_powerup_state", 0 );
}

custom_powerup_grab( s_powerup, e_player )
{
    if ( isDefined( s_powerup ) && isDefined( s_powerup.powerup_name ) && s_powerup.powerup_name == "deathmachine" )
    {
        level thread deathmachine_powerup( s_powerup, e_player );
        return;
    }

    if ( isDefined( level.original_deathmachine_powerup_grab ) )
    {
        level thread [[level.original_deathmachine_powerup_grab]]( s_powerup, e_player );
    }
}

deathmachine_powerup( m_powerup, e_player )
{
    if ( !isDefined( e_player ) )
    {
        return;
    }

    if ( e_player maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
    {
        return;
    }

    level.deathmachine_duration = getdvarintdefault( "sv_deathmachine_duration", 30 );

    e_player notify( "end_deathmachine" );
    wait 0.05;

    e_player playsound( "death_machine" );
    e_player thread powerup_state_monitor();
    e_player thread start_deathmachine();
    e_player thread notify_deathmachine_end();
}

powerup_state_monitor()
{
    level endon( "end_game" );
    self endon( "disconnect" );
    self endon( "death" );
    self endon( "end_deathmachine" );

    time_left = getdvarintdefault( "sv_deathmachine_duration", 30 );
    self setclientdvar( "deathmachine_powerup_state", 1 );

    while ( time_left > 10 )
    {
        wait 0.05;
        time_left -= 0.05;
    }

    flash_on = 1;

    while ( time_left > 0 )
    {
        if ( time_left <= 5 )
        {
            blink_time = 0.1;
        }
        else
        {
            blink_time = 0.2;
        }

        if ( flash_on )
        {
            self setclientdvar( "deathmachine_powerup_state", 3 );
        }
        else
        {
            self setclientdvar( "deathmachine_powerup_state", 2 );
        }

        flash_on = !flash_on;

        wait blink_time;
        time_left -= blink_time;
    }

    self setclientdvar( "deathmachine_powerup_state", 0 );
}

start_deathmachine()
{
    level endon( "end_game" );
    self endon( "disconnect" );
    self endon( "death" );
    self endon( "end_deathmachine" );

    weapon = get_deathmachine_weapon();

    self.weapon_before_deathmachine = self getcurrentweapon();
    self.deathmachine_had_weapon_before = self hasweapon( weapon );

    set_powerup_state( self );

    if ( !self.deathmachine_had_weapon_before )
    {
        self notify( "replace_weapon_powerup" );
        self giveweapon( weapon );
        wait 0.05;
    }

    self setweaponammoclip( weapon, 150 );
    self setweaponammostock( weapon, 300 );
    self switchtoweapon( weapon );

    self thread deathmachine_infinite_ammo();
    self thread end_deathmachine_powerup();
    self thread end_deathmachine_on_weapon_switch( weapon );
}

deathmachine_infinite_ammo()
{
    level endon( "end_game" );
    self endon( "disconnect" );
    self endon( "death" );
    self endon( "end_deathmachine" );

    weapon = get_deathmachine_weapon();

    for ( ;; )
    {
        if ( self hasweapon( weapon ) )
        {
            self setweaponammoclip( weapon, 150 );
            self setweaponammostock( weapon, 300 );
        }

        wait 0.05;
    }
}

end_deathmachine_powerup()
{
    level endon( "end_game" );
    self waittill_any( "end_deathmachine", "disconnect", "death" );

    weapon = get_deathmachine_weapon();

    if ( !isDefined( self.deathmachine_had_weapon_before ) || !self.deathmachine_had_weapon_before )
    {
        if ( self hasweapon( weapon ) )
        {
            self takeweapon( weapon );
        }

        if ( isDefined( self.weapon_before_deathmachine ) )
        {
            player_weapons = self getweaponslistprimaries();

            for ( i = 0; i < player_weapons.size; i++ )
            {
                if ( player_weapons[i] == self.weapon_before_deathmachine )
                {
                    self switchtoweapon( self.weapon_before_deathmachine );
                    deathmachine_clear_powerup_state( self );
                    clear_deathmachine_vars();
                    return;
                }
            }
        }

        self switch_back_from_deathmachine();
    }
    else if ( self getcurrentweapon() == weapon && isDefined( self.weapon_before_deathmachine ) && self.weapon_before_deathmachine != "none" && self.weapon_before_deathmachine != weapon && self hasweapon( self.weapon_before_deathmachine ) )
    {
        self switchtoweapon( self.weapon_before_deathmachine );
    }

    deathmachine_clear_powerup_state( self );
    clear_deathmachine_vars();
}

end_deathmachine_on_weapon_switch( weapon )
{
    level endon( "end_game" );
    self endon( "disconnect" );
    self endon( "death" );
    self endon( "end_deathmachine" );

    for ( ;; )
    {
        if ( self getcurrentweapon() == weapon )
        {
            break;
        }

        wait 0.05;
    }

    wait 0.1;

    for ( ;; )
    {
        if ( !self hasweapon( weapon ) )
        {
            return;
        }

        if ( self getcurrentweapon() != weapon )
        {
            self notify( "end_deathmachine" );
            return;
        }

        wait 0.05;
    }
}

switch_back_from_deathmachine()
{
    wait 0.05;

    if ( isDefined( self.weapon_before_deathmachine ) && self.weapon_before_deathmachine != "none" && self hasweapon( self.weapon_before_deathmachine ) )
    {
        self switchtoweapon( self.weapon_before_deathmachine );
    }
    else
    {
        primaryweapons = self getweaponslistprimaries();

        if ( isDefined( primaryweapons ) && primaryweapons.size > 0 )
        {
            self switchtoweapon( primaryweapons[0] );
        }
        else
        {
            self maps\mp\zombies\_zm_weapons::give_fallback_weapon();
        }
    }
}

notify_deathmachine_end()
{
    level endon( "end_game" );
    self endon( "disconnect" );
    self endon( "death" );
    self endon( "end_deathmachine" );

    wait getdvarintdefault( "sv_deathmachine_duration", 30 );

    self playsound( "zmb_insta_kill" );
    self notify( "end_deathmachine" );
}

get_deathmachine_weapon()
{
    if ( isDefined( level.deathmachine_weapon ) )
    {
        return level.deathmachine_weapon;
    }

    return "deathmachine_zm";
}

clear_deathmachine_vars()
{
    self.deathmachine_had_weapon_before = undefined;
    self.weapon_before_deathmachine = undefined;
}
