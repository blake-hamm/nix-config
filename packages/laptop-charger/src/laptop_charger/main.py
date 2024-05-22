"""Capabilities to turn on/off kasa charger based on batter level."""
import asyncio
import glob
import logging

from kasa import SmartStrip


logger = logging.getLogger(__name__)



def check_battery_level():
  _battery_file = f"/sys/class/power_supply/BAT*/capacity"
  battery_file = glob.glob(_battery_file)
  if len(battery_file) > 1:
    raise ValueError("There is more than one battery file!")
  with open(battery_file[0], "r") as file:
      battery_level = file.read().strip()
  logger.info(f'Battery level: {battery_level}%')
  return int(battery_level)


async def check_plug_on(power_strip, plug_alias):
    await power_strip.update()
    for plug in power_strip.children:
        if plug.alias == plug_alias:
            is_plug_on = plug.is_on
            logger.info(f"Kasa plug {plug_alias} is on: {is_plug_on}")
            return is_plug_on


async def switch_plug(power_strip, plug_alias):
    await power_strip.update()
    for plug in power_strip.children:
        if plug.alias == plug_alias:
            if plug.is_on:
                await plug.turn_off()
            else:
                await plug.turn_on()


async def main(ip="192.168.69.53", battery_lower_threshold=30, battery_upper_threshold=80):
    battery_level = check_battery_level()
    power_strip = SmartStrip(ip)
    is_plug_on = await check_plug_on(power_strip)
    if is_plug_on and battery_level > battery_upper_threshold:
        logger.info(
            f"""
            Battery is above upper threshold of {battery_upper_threshold}% and still charging.
            Turning off plug..
            """
        )
        await switch_plug(power_strip)
        logger.info("Plug turned off")
    elif (not is_plug_on) and battery_level < battery_lower_threshold:
        logger.info(
            f"""
            Battery is below lower threshold of {battery_lower_threshold}% and not charging.
            Turning on plug..
            """
        )
        await switch_plug(power_strip)
        logger.info("Plug turned on")
    else:
        logger.info(
            f"""
            Battery is at {battery_level} and plug is in on: {is_plug_on}.
            No changes needed.
            """
        )



if __name__ == "__main__":
    asyncio.run(main())
