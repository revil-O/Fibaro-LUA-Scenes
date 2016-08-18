-- @file      	wallplug_auto_off.lua
-- @author    	oliver schmidt
-- @date      	2016-08-18
-- @licence   
-- 		© Oliver Schmidt (tutorials at net-fx2 dot de)
-- 		Unless stated otherwise, all lua-code of this Project is:
--		Licensed under the Create-Commons Attribution-Noncommercial-Share Alike 3.0 Unported 
--		http://creativecommons.org/licenses/by-nc-sa/3.0/


--[[
%% properties
%% autostart
%% globals
--]]

local version = '1.0';
local sleep_value = 60000;          -- SleepValue for while-loop
local sleep_counter = 0;            -- initialize sleep_counter
local low_power = 40;               -- low-power-value  --> turn off device when powerconsumption is lower than specified value (watts)
local wall_plug = 57;               -- fibaro-ID of the desired wallplug 
local set_off_time = 240000;        -- 240 seconds -- 4 minutes

fibaro:debug('Automatische WallplugAbschaltung bei EnergyLevel unter 40 Watt nach 3 Minuten (Ver.' .. version .. ')');

if (fibaro:countScenes()>1)
  then
 	fibaro:abort();
  fibaro:debug('abort');
end

while true do
     fibaro:debug('SleepCounter: ' ..sleep_counter);
     local wp_power = tonumber(fibaro:getValue(wall_plug,"power"));
	 --fibaro:debug(wp_power);
-- only for debugging
--     if(wp_power > 0) 
--       then fibaro:debug('WallPlug ist eingeschaltet..');
--    		fibaro:debug('Aktueller Verbrauch: '.. wp_power ..' Watt.');
--       else fibaro:debug('Wallplug ist ausgeschaltet');
--     end
     if (wp_power < low_power and wp_power > 0) then
     	sleep_counter = sleep_counter + sleep_value;
     else 
    	-- Zurücksetzen des SleepCounter wenn die angeschlossenen Geräte wieder
    	-- innnerhalb der eingestellten set_off_time eingeschaltet und genutzt werden 
        sleep_counter = 0;
     end
     if(sleep_counter == set_off_time and sleep_counter > 0)
    	then fibaro:debug('WallPlug wird nach ' .. set_off_time/1000/60 .. ' Minuten unter ' .. low_power .. ' \n Watt Verbrauch abgeschaltet.' );
     		 fibaro:call(wall_plug,"turnOff");
    		 sleep_counter = 0;
     end
     fibaro:sleep(sleep_value);
     
end
