#!/usr/bin/env pybricks-micropython

from pybricks import ev3brick as brick
from pybricks.ev3devices import (Motor, TouchSensor, ColorSensor,
                                 InfraredSensor, UltrasonicSensor, GyroSensor)
from pybricks.parameters import (Port, Stop, Direction, Button, Color,
                                 SoundFile, ImageFile, Align)
from pybricks.tools import print, wait, StopWatch
from pybricks.robotics import DriveBase

import socket

# Write your program here

HOST = '192.168.0.2'  # Endereco IP do Servidor
PORT = 2508            # Porta que o Servidor esta
udp = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
dest = (HOST, PORT)
brick.sound.file(SoundFile.READY)

corLeft  = ColorSensor(Port.S2)
corRight = ColorSensor(Port.S3)

brick.sound.file(SoundFile.ANALYZE)
brick.sound.file(SoundFile.COLOR)

#cronometro = StopWatch()
contador = 0
botoes = brick.buttons()
while(Button.CENTER not in botoes):
    #cronometro.reset()
    left = corLeft.rgb()
    right= corRight.rgb()
    #print("Tempo sensores ", cronometro.time())

    #cronometro.reset()
    lr = "{0:.2f}".format(left[0])
    lg = "{0:.2f}".format(left[1])
    lb = "{0:.2f}".format(left[2])

    # Estas equações foram obtidas a partir dos valores ajustados
    # no script scilab
    rr = "{0:.2f}".format(right[0]+0.080936*right[0]+2.244448)
    rg = "{0:.2f}".format(right[1]+0.353503*right[1]+2.963078)
    rb = "{0:.2f}".format(right[2]+0.365826*right[2]+4.664990)

    contador += 1

    msg = str(contador)+" "+lr+" "+lg+" "+lb+" "+rr+" "+rg+" "+rb
    #print("Tempo formatação ", cronometro.time())

    udp.sendto (msg, dest)
    botoes = brick.buttons()

brick.sound.file(SoundFile.STOP)
