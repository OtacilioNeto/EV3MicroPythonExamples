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

maxPot      = 100
inicio      = 0
fim         = 20

def buscaBinaria(vetor, ev3, motorLeft, motorRight):
    salvaPot = 0
    inf = 0
    top = len(vetor)-1
    meio = (top+inf)//2
    while(inf<=top):
        ev3.speaker.say("Testando a potência mínima de "+str(vetor[meio]))
        motorLeft.reset_angle(0)
        motorRight.reset_angle(0)
        motorLeft.dc(vetor[meio])
        motorRight.dc(vetor[meio])
        wait(1000)
        motorLeft.brake()
        motorRight.brake()
        girou = motorLeft.angle()>0 and motorRight.angle()>0
        if(girou):
            salvaPot = meio
            top = meio-1
        else:
			inf = meio+1
        meio = (top+inf)//2
    
    return vetor[salvaPot]

# Create your objects here.
espaco = []
for i in range(inicio, fim+1):
    espaco.append(i)

ev3 = EV3Brick()

# Write your program here.
ev3.speaker.set_speech_options('pt-br','m3')

motorLeft = Motor(Port.B)
motorRight= Motor(Port.C)
motorLeft.dc(0)
motorRight.dc(0)

ev3.speaker.beep()

ev3.speaker.say("Buscando a potência mínima de "+str(inicio)+" até "+str(fim))

# vamos realizar a busca binária
minPot = buscaBinaria(espaco, ev3, motorLeft, motorRight)
print("Potência mínima é de "+str(espaco[minPot])+"%")

ev3.speaker.say("Potência mínima é de "+str(espaco[minPot])+" porcento")

if(minPot>0): # Encontra a potência do 0. A que está no limiar de movimentar
    minPot = minPot - 1

escala = (maxPot)/(maxPot-espaco[minPot])

print("potencia(x) = x/"+str(escala)+" + "+str(espaco[minPot]))