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

corLeft  = ColorSensor(Port.S2)
corRight = ColorSensor(Port.S3)

brick.sound.file(SoundFile.ANALYZE)
brick.sound.file(SoundFile.COLOR)
brick.sound.file(SoundFile.LEFT)

print("Sensor esquerdo=", corLeft.rgb())

brick.sound.file(SoundFile.ANALYZE)
brick.sound.file(SoundFile.COLOR)
brick.sound.file(SoundFile.RIGHT)

print("Sensor direito =", corRight.rgb())
