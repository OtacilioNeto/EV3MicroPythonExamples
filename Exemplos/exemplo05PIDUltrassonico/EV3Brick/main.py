#!/usr/bin/env pybricks-micropython

# file:///home/ota/.vscode/extensions/lego-education.ev3-micropython-1.0.3/resources/docs/index.html

from pybricks import ev3brick as brick
from pybricks.ev3devices import (Motor, TouchSensor, ColorSensor,
                                 InfraredSensor, UltrasonicSensor, GyroSensor)
from pybricks.parameters import (Port, Stop, Direction, Button, Color,
                                 SoundFile, ImageFile, Align)
from pybricks.tools import print, wait, StopWatch
from pybricks.robotics import DriveBase

import socket

brick.sound.beep()

HOST = '192.168.0.2'  # Endereco IP do Servidor
PORT = 2508            # Porta que o Servidor esta
udp = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
dest = (HOST, PORT)
brick.sound.file(SoundFile.READY)

brick.sound.file(SoundFile.ANALYZE)

cronometro = StopWatch()

# topSensor está em Port.S4
# bottonSensor está em Port.S1
topSensor = UltrasonicSensor(Port.S4)
bottonSensor = UltrasonicSensor(Port.S1)

# Desliga os dois sensores
topOff       = True
topSensor.distance(topOff)
bottonOff    = False
bottonSensor.distance(bottonOff)

# Vamos testar os motores
motorLeft = Motor(Port.B)
motorRight= Motor(Port.C)
motorLeft.dc(0)
motorRight.dc(0)

contador    = 0
top         = 0
botton      = 0
motorOn     = False

Kp          =   -1.0    # Testa com -0.5 -4 -2 -1.5 Ganho Proporcional -1.0
Kd          =  -80.0    # Testa com  0 -10 -20 -30  Ganho Derivativo  -70.0
Ki          =  -0.002   # Ganho integral

setPoint    = 70    # Distancia em milimetros da referência de parada
atuacao     = 60    # Distancia do ponto de parada a partir do qual o controlador passa a atuar
potMaxima   = 100   # Potencia máxima de atuação dos motores
distMinima  = 30    # A partir desta distância para baixo desliga os motores
erro        = 0
erroAnt     = 0
integral    = 0
while(True):
    if(not topOff):
        top  = topSensor.distance()
        distancia = top
    if(not bottonOff):
        botton = bottonSensor.distance()
        distancia = botton
    
    if(motorOn):
        if(distancia>=(setPoint-atuacao) and distancia<=(setPoint+atuacao)):
            erroAnt     = erro
            erro        = (setPoint - distancia)
            tempo       = cronometro.time()
            cronometro.reset()

            integral    = integral + (erro+erroAnt)*tempo/2.0
            derivativo  = (erro-erroAnt)/tempo
            
            potencia    = Kp*erro + Ki*integral + Kd*derivativo
        elif(distancia>(setPoint+atuacao)):
            potencia= potMaxima
            integral= 0
        elif(distancia<(setPoint-atuacao)):
            potencia= -potMaxima
            integral= 0
                
        if(potencia>potMaxima):
            potencia = potMaxima
        elif(potencia<-potMaxima):
            potencia = -potMaxima
        motorLeft.dc(int(potencia))
        motorRight.dc(int(potencia))
    else:
        motorLeft.dc(0)
        motorRight.dc(0)
    
    botoes = brick.buttons()

    if(Button.CENTER in botoes):
        break
    if(Button.UP in botoes):
        topOff      = not topOff
        bottonOff   = not topOff
        topSensor.distance(topOff)
        bottonSensor.distance(bottonOff)
        if(topOff):
            top = 0
    if(Button.DOWN in botoes):
        bottonOff   = not bottonOff
        topOff      = not bottonOff
        topSensor.distance(topOff)
        bottonSensor.distance(bottonOff)
        if(bottonOff):
            botton = 0
    if(Button.RIGHT in botoes):
        motorOn = True
        cronometro.reset()
    if(Button.LEFT in botoes):
        motorOn = False
    
    if((top<=distMinima and not topOff) or (botton<=distMinima and not bottonOff)):
        # Parada de emergência
        motorOn = False

    contador += 1
    msg = str(contador)+" "+str(top)+" "+str(botton)
    udp.sendto (msg, dest)

motorLeft.dc(0)
motorRight.dc(0)
brick.sound.file(SoundFile.STOP)

