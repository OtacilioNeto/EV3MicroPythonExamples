#!/usr/bin/env pybricks-micropython

from pybricks.hubs import EV3Brick
from pybricks.ev3devices import (Motor, TouchSensor, ColorSensor,
                                 InfraredSensor, UltrasonicSensor, GyroSensor)
from pybricks.parameters import Port, Stop, Direction, Button, Color
from pybricks.tools import wait, StopWatch, DataLog
from pybricks.robotics import DriveBase
from pybricks.media.ev3dev import SoundFile, ImageFile

# This program requires LEGO EV3 MicroPython v2.0 or higher.
# Click "Open user guide" on the EV3 extension tab for more information.

ev3 = EV3Brick()

# Write your program here
ev3.speaker.set_speech_options('pt-br','m3')

ev3.speaker.beep()

corLeft  = ColorSensor(Port.S2)
corRight = ColorSensor(Port.S3)

ev3.speaker.say("Analizando cor do sensor esquerdo")

print("Sensor esquerdo=", corLeft.rgb())

ev3.speaker.say("Analizando cor do sensor direito")

print("Sensor direito =", corRight.rgb())
