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

sleft  = ColorSensor(Port.S2)
sright = ColorSensor(Port.S3)

corLeft= sleft.color()
corRight=sright.color()

ev3.speaker.set_speech_options('pt-br','m3')

ev3.speaker.say("Sensor Esquerdo")
if(corLeft == Color.RED):
    ev3.speaker.say("Vermelho")
elif(corLeft == Color.YELLOW):
    ev3.speaker.say("Amarelo")
elif(corLeft == Color.GREEN):
    ev3.speaker.say("Verde")
elif(corLeft == Color.BLUE):
    ev3.speaker.say("Azul")
else:
    ev3.speaker.say("Cor desconhecida")

ev3.speaker.say("Sensor Direito")
if(corRight == Color.RED):
    ev3.speaker.say("Vermelho")
elif(corRight == Color.YELLOW):
    ev3.speaker.say("Amarelo")
elif(corRight == Color.GREEN):
    ev3.speaker.say("Verde")
elif(corRight == Color.BLUE):
    ev3.speaker.say("Azul")
else:
    ev3.speaker.say("Cor desconhecida")
