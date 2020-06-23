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


ev3.speaker.say("Iniciando programa de controle")

cronometro = StopWatch()

# topSensor está em Port.S4
# bottonSensor está em Port.S1
topSensor = UltrasonicSensor(Port.S4)
bottonSensor = UltrasonicSensor(Port.S1)

# Seta o estado dos sensores de distância
topOff       = True
topSensor.distance(topOff)
bottonOff    = False
bottonSensor.distance(bottonOff)

# Vamos testar os motores
motorLeft = Motor(Port.B)
motorRight= Motor(Port.C)
motorLeft.brake()
motorRight.brake()

contador    = 0
top         = 0
botton      = 0
motorOn     = False

Kp          =    -0.9   # -4 oscila bastante a potência e a distância, 
                        # -3 dá um pico passando e tem pico inverso
                        # -2 dá um pico passando 
                        # Os valores anteriores foram encontrados para Kd e Ki = 0
                        # O melhor valor é -0.9 Não mexa!

setPoint    = 70    # Distancia em milimetros da referência de parada
potMaxima   = 100   # Potencia máxima de atuação dos motores
distMinima  = 30    # A partir desta distância para baixo chame brake() nos motores
DEADPOT     = 2.0   # Potencia que se solicitada por mais de 10 vezes o sistema entende que é para parar os motores
erro        = 0
potencia    = 0
Kperro      = 0
contaPot    = 0

while(True):
    if(not topOff):
        top  = topSensor.distance()
        distancia = top
    if(not bottonOff):
        botton = bottonSensor.distance()
        distancia = botton
    
    erro = setPoint - distancia
    if(motorOn):
        Kperro      = Kp*erro
        potencia    = Kperro
                
        if(potencia>potMaxima):
            potencia = potMaxima
        elif(potencia<-potMaxima):
            potencia = -potMaxima
        
        if(potencia>=0):
            potenciaReal = potencia/1.098901098901099 + 9
        else:
            potenciaReal = potencia/1.098901098901099 - 9
        
        potenciaReal = potencia
        
        if(abs(potencia) <= DEADPOT): # Testa se esta em uma posição da zona morta
            contaPot += 1
        else:
            contaPot  = 0

        if(contaPot<=10):
            motorLeft.dc(potenciaReal)
            motorRight.dc(potenciaReal)
        else:
            motorLeft.brake()
            motorRight.brake()
    else:
        potencia = 0.0
        motorLeft.brake()
        motorRight.brake()
    
    botoes = ev3.buttons.pressed()

    if(Button.CENTER in botoes):
        break
    if(Button.UP in botoes):    # Botão para cima usa o sensor de cima
        topOff      = not topOff
        bottonOff   = not topOff
        topSensor.distance(topOff)
        bottonSensor.distance(bottonOff)
        if(topOff):
            top = 0
    if(Button.DOWN in botoes):  # Botão para baixo usa o sensor de baixo
        bottonOff   = not bottonOff
        topOff      = not bottonOff
        topSensor.distance(topOff)
        bottonSensor.distance(bottonOff)
        if(bottonOff):
            botton = 0
    if(Button.RIGHT in botoes): # Botão para a direita liga os motores
        motorOn = True
    if(Button.LEFT in botoes):  # Botão para a esquerda desliga os motores
        motorOn = False
    
    if((top<=distMinima and not topOff) or (botton<=distMinima and not bottonOff)):
        # Parada de emergência
        motorOn = False
    if(not topOff):
        sensor = top
    elif(not bottonOff):
        sensor = botton
    else:
        sensor = -1

    contador += 1
    msg = '{:} {:} {:.f} {:.2f}'.format(contador, sensor, potencia, Kperro)
    udp.sendto (msg, dest)

motorLeft.brake()
motorRight.brake()
ev3.speaker.say("Encerrado")
