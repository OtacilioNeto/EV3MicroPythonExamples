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

ev3.speaker.beep()

ev3.speaker.say("Criando interface de rede")
HOST = '192.168.0.3'  # Endereco IP do Servidor
PORT = 2508            # Porta que o Servidor esta
udp = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
dest = (HOST, PORT)


ev3.speaker.say("Iniciando teste dos motores")

motorLeft = Motor(Port.B)
motorRight= Motor(Port.C)
motorLeft.brake()
motorRight.brake()

# Aqui o lance é o seguinte. Testar o acionamento partindo de 0 até 100, medir quanto o motor
# girou e enviar para o PC

udp.sendto("// potencia (%), giro esquerdo (graus/%s), giro direito (graus/%s)", dest)
udp.sendto("datalog = [", dest)

for potx in range(0, 101):
    motorLeft.reset_angle(0)
    motorRight.reset_angle(0)
    pot = potx
    # pot = potx/1.098901098901099 + 9 # Tira o comentário desta linha para usar a potência corrigida
    motorLeft.dc(pot)
    motorRight.dc(pot)
    wait(1000)
    motorLeft.brake()
    motorRight.brake()
    msg = '{:} {:} {:};'.format(potx, motorLeft.angle(), motorRight.angle())
    print(msg)
    udp.sendto(msg, dest)
    wait(3000)

udp.sendto("];", dest)

ev3.speaker.say("Encerrado")