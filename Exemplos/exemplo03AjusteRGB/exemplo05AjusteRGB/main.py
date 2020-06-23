#!/usr/bin/env pybricks-micropython
from pybricks.hubs import EV3Brick
from pybricks.ev3devices import (Motor, TouchSensor, ColorSensor,
                                 InfraredSensor, UltrasonicSensor, GyroSensor)
from pybricks.parameters import Port, Stop, Direction, Button, Color
from pybricks.tools import wait, StopWatch, DataLog
from pybricks.robotics import DriveBase
from pybricks.media.ev3dev import SoundFile, ImageFile

import socket

# This program requires LEGO EV3 MicroPython v2.0 or higher.
# Click "Open user guide" on the EV3 extension tab for more information.

ev3 = EV3Brick()

# Write your program here
ev3.speaker.set_speech_options('pt-br','m3')

ev3.speaker.say("Criando interface de rede")
HOST = '192.168.0.3'    # Endereco IP do Servidor
PORT = 2508             # Porta que o Servidor esta
udp = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
dest = (HOST, PORT)

ev3.speaker.say("Abrindo sensores")

corLeft  = ColorSensor(Port.S2)
corRight = ColorSensor(Port.S3)

ev3.speaker.say("Analizando as cores")

#cronometro = StopWatch()
contador = 0
while(Button.CENTER not in ev3.buttons.pressed()):
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
    rr = "{0:.2f}".format(right[0]+0.048859*right[0]+1.236116)
    rg = "{0:.2f}".format(right[1]+0.319633*right[1]+1.086458)
    rb = "{0:.2f}".format(right[2]+0.348117*right[2]+4.107346)

    contador += 1

    msg = str(contador)+" "+lr+" "+lg+" "+lb+" "+rr+" "+rg+" "+rb
    #print("Tempo formatação ", cronometro.time())

    udp.sendto (msg, dest)

ev3.speaker.say("Encerrado")
