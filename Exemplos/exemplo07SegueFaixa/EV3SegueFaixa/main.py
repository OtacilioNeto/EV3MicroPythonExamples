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
NAMOSTRAS = 100

def calibraCor(sensorLeft, sensorRight):
    corLeft  = []
    corRight = []
    while(len(corLeft)<NAMOSTRAS):
        corLeft.append(sensorLeft.rgb())
        corRight.append(sensorRight.rgb())
    
    return (corLeft, corRight)

def opcoesMenuPrincipal():
    ev3.speaker.say("Executando menu principal")
    ev3.speaker.say("Para cima, calibração de cores")
    ev3.speaker.say("Para direita, inicia a prova")
    ev3.speaker.say("Para esquerda, pausa a prova")
    ev3.speaker.say("Centro, encerra o programa")

def executaCalibracao(sensorLeft, sensorRight):
    ev3.speaker.say("Iniciando calibração")
    ev3.speaker.say("Para cima, branco")
    ev3.speaker.say("Para baixo, preto")
    ev3.speaker.say("Para esquerda, verde")
    ev3.speaker.say("Para direita, cinza")
    ev3.speaker.say("Centro, retorna ao menu principal")
    cronometro = StopWatch()
    cronometro.reset()
    botoes = []
    botoesAnt = botoes
    while(True):
        # Vamos implementar o menu principal
        botoes = ev3.buttons.pressed()
        if(len(botoes) == 0):
            cronometro.reset()
        elif(botoes != botoesAnt):
            cronometro.reset()
        elif([Button.UP] == botoes and cronometro.time()>=250):        
            ev3.speaker.say("Calibrando branco")
            (brancoLeft, brancoRight) = calibraCor(sensorLeft, sensorRight)
            ev3.speaker.say("Feito")
        elif([Button.DOWN] == botoes and cronometro.time()>=250):        
            ev3.speaker.say("Calibrando preto")
            (pretoLeft, pretoRight) = calibraCor(sensorLeft, sensorRight)
            ev3.speaker.say("Feito")
        elif([Button.LEFT] == botoes and cronometro.time()>=250):        
            ev3.speaker.say("Calibrando verde")
            (verdeLeft, verdeRight) = calibraCor(sensorLeft, sensorRight)
            ev3.speaker.say("Feito")
        elif([Button.RIGHT] == botoes and cronometro.time()>=250):        
            ev3.speaker.say("Calibrando cinza")
            (cinzaLeft, cinzaRight) = calibraCor(sensorLeft, sensorRight)
            ev3.speaker.say("Feito")
        elif([Button.CENTER] == botoes and cronometro.time()>=250):
            break
        botoesAnt = botoes

# Create your objects here.
ev3 = EV3Brick()

# Write your program here.
ev3.speaker.set_speech_options('pt-br','m3')
ev3.speaker.beep()

# Motores
motorLeft = Motor(Port.B)
motorRight= Motor(Port.C)
motorLeft.brake()
motorRight.brake()

# Sensores ultrassônicos
topSensor = UltrasonicSensor(Port.S4)
bottonSensor = UltrasonicSensor(Port.S1)

# Sensores de cor
corLeft  = ColorSensor(Port.S2)
corRight = ColorSensor(Port.S3)

# Seta o estado dos sensores de distância
topOff       = True
topSensor.distance(topOff)
bottonOff    = False
bottonSensor.distance(bottonOff)

cronometro = StopWatch()

ev3.speaker.say("Iniciando programa de controle")

botoes = []
botoesAnt = botoes
opcoesMenuPrincipal()
while(True):
    # Vamos implementar o menu principal
    botoes = ev3.buttons.pressed()
    if(len(botoes) == 0):
        cronometro.reset()
    elif(botoes != botoesAnt):
        cronometro.reset()
    elif([Button.UP] == botoes and cronometro.time()>=250):        
        executaCalibracao(corLeft, corRight)        
        opcoesMenuPrincipal()
    elif([Button.CENTER] == botoes and cronometro.time()>=250):
        break

    botoesAnt = botoes


ev3.speaker.say("Encerrado")