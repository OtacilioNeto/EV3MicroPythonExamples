#!/usr/bin/env pybricks-micropython

from pybricks import ev3brick as brick
from pybricks.ev3devices import (Motor, TouchSensor, ColorSensor,
                                 InfraredSensor, UltrasonicSensor, GyroSensor)
from pybricks.parameters import (Port, Stop, Direction, Button, Color,
                                 SoundFile, ImageFile, Align)
from pybricks.tools import print, wait, StopWatch
from pybricks.robotics import DriveBase

# Write your program here
brick.sound.beep()

sleft  = ColorSensor(Port.S2)
sright = ColorSensor(Port.S3)

corLeft= sleft.color()
corRight=sright.color()

brick.sound.file(SoundFile.LEFT)
if(corLeft == Color.RED):
    brick.sound.file(SoundFile.RED)
elif(corLeft == Color.YELLOW):
    brick.sound.file(SoundFile.YELLOW)
elif(corLeft == Color.GREEN):
    brick.sound.file(SoundFile.GREEN)
elif(corLeft == Color.BLUE):
    brick.sound.file(SoundFile.BLUE)
else:
    brick.sound.file(SoundFile.SORRY)

brick.sound.file(SoundFile.RIGHT)
if(corRight == Color.RED):
    brick.sound.file(SoundFile.RED)
elif(corRight == Color.YELLOW):
    brick.sound.file(SoundFile.YELLOW)
elif(corRight == Color.GREEN):
    brick.sound.file(SoundFile.GREEN)
elif(corRight == Color.BLUE):
    brick.sound.file(SoundFile.BLUE)
else:
    brick.sound.file(SoundFile.SORRY)
