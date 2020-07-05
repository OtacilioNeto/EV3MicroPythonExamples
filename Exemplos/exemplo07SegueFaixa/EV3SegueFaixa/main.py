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

def leCorMedia(sensorLeft, sensorRight):
    corLeftRed      = 0
    corLeftGreen    = 0
    corLeftBlue     = 0
    corRightRed     = 0
    corRightGreen   = 0
    corRightBlue    = 0
    for i in range(0, NAMOSTRAS):
        sensorEsquerdo = sensorLeft.rgb()
        sensorDireito  = sensorRight.rgb()

        corLeftRed      += sensorEsquerdo[0]
        corLeftGreen    += sensorEsquerdo[1]
        corLeftBlue     += sensorEsquerdo[2]

        corRightRed      += sensorDireito[0]
        corRightGreen    += sensorDireito[1]
        corRightBlue     += sensorDireito[2]
    
    corLeftRed      = corLeftRed/NAMOSTRAS
    corLeftGreen    = corLeftGreen/NAMOSTRAS
    corLeftBlue     = corLeftBlue/NAMOSTRAS

    corRightRed     = corRightRed/NAMOSTRAS
    corRightGreen   = corRightGreen/NAMOSTRAS
    corRightBlue    = corRightBlue/NAMOSTRAS

    return (corLeftRed, corLeftGreen, corLeftBlue, corRightRed, corRightGreen, corRightBlue)

def encontraErroRGB(corRGB):
    return (corRGB[0]-corRGB[3], corRGB[1]-corRGB[4], corRGB[2]-corRGB[5])

def minimosQuadradosRGB(Y, X):
    red     = 0
    green   = 1
    blue    = 2
    n       = len(X)

    sumxyr  = sumxyg = sumxyb = 0
    sumxr   = sumxg  = sumxb  = 0
    sumyr   = sumyg  = sumyb  = 0
    sumx2r  = sumx2g = sumx2b = 0
    for i in range(0, n):
        sumxyr += X[i][red]*Y[i][red]
        sumxr  += X[i][red]
        sumyr  += Y[i][red]
        sumx2r += X[i][red]**2

        sumxyg += X[i][green]*Y[i][green]
        sumxg  += X[i][green]
        sumyg  += Y[i][green]
        sumx2g += X[i][green]**2

        sumxyb += X[i][blue]*Y[i][blue]
        sumxb  += X[i][blue]
        sumyb  += Y[i][blue]
        sumx2b += X[i][blue]**2
    
    a1 = ((n*sumxyr - sumxr*sumyr) / (n*sumx2r - sumxr**2), (n*sumxyg - sumxg*sumyg) / (n*sumx2g - sumxg**2), (n*sumxyb - sumxb*sumyb) / (n*sumx2b - sumxb**2))
    a0 = (sumyr/n - a1[red]*sumxr/n, sumyg/n - a1[green]*sumxg/n, sumyb/n - a1[blue]*sumxb/n)

    return (a1, a0)

def opcoesMenuPrincipal():
    ev3.speaker.say("Executando menu principal")
    botoes = ev3.buttons.pressed()
    if(len(botoes) == 0):
        ev3.speaker.say("Para cima, calibração de cores")
        botoes = ev3.buttons.pressed()
    if(len(botoes) == 0):
        ev3.speaker.say("Para baixo, carrega uma calibração prévia")
        botoes = ev3.buttons.pressed()
    if(len(botoes) == 0):
        ev3.speaker.say("Para direita, inicia a prova")
        botoes = ev3.buttons.pressed()
    if(len(botoes) == 0):
        ev3.speaker.say("Para esquerda, pausa a prova")
        botoes = ev3.buttons.pressed()
    if(len(botoes) == 0):
        ev3.speaker.say("Centro, encerra o programa")

def executaCalibracao(sensorLeft, sensorRight, contador, udp):
    ev3.speaker.say("Iniciando calibração")
    botoes = ev3.buttons.pressed()
    if(len(botoes) == 0):
        ev3.speaker.say("Para cima, branco")
        botoes = ev3.buttons.pressed()
    if(len(botoes) == 0):
        ev3.speaker.say("Para baixo, preto")
        botoes = ev3.buttons.pressed()
    if(len(botoes) == 0):
        ev3.speaker.say("Para esquerda, verde")
        botoes = ev3.buttons.pressed()
    if(len(botoes) == 0):
        ev3.speaker.say("Para direita, cinza")
        botoes = ev3.buttons.pressed()
    if(len(botoes) == 0):
        ev3.speaker.say("Centro, retorna ao menu principal")
        botoes = ev3.buttons.pressed()
    
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
            branco = leCorMedia(sensorLeft, sensorRight)
            erroBranco = encontraErroRGB(branco)
            ev3.speaker.say("Feito")
        elif([Button.DOWN] == botoes and cronometro.time()>=250):        
            ev3.speaker.say("Calibrando preto")
            preto = leCorMedia(sensorLeft, sensorRight)
            erroPreto = encontraErroRGB(preto)
            ev3.speaker.say("Feito")
        elif([Button.LEFT] == botoes and cronometro.time()>=250):        
            ev3.speaker.say("Calibrando verde")
            verde = leCorMedia(sensorLeft, sensorRight)
            erroVerde = encontraErroRGB(verde)
            ev3.speaker.say("Feito")
        elif([Button.RIGHT] == botoes and cronometro.time()>=250):        
            ev3.speaker.say("Calibrando cinza")
            cinza = leCorMedia(sensorLeft, sensorRight)
            erroCinza = encontraErroRGB(cinza)
            ev3.speaker.say("Feito")
        elif([Button.CENTER] == botoes and cronometro.time()>=250):
            break
        
        left = corLeft.rgb()
        right= corRight.rgb()

        lr = "{0:.2f}".format(left[0])
        lg = "{0:.2f}".format(left[1])
        lb = "{0:.2f}".format(left[2])

        rr = "{0:.2f}".format(right[0])
        rg = "{0:.2f}".format(right[1])
        rb = "{0:.2f}".format(right[2])

        contador += 1

        msg = str(contador)+" "+lr+" "+lg+" "+lb+" "+rr+" "+rg+" "+rb

        udp.sendto (msg, dest)
        
        botoesAnt = botoes
        
    X = [(branco[3],     branco[4],     branco[5]),     (preto[3],     preto[4],     preto[5]),     (verde[3],     verde[4],     verde[5]),     (cinza[3],     cinza[4],     cinza[5])]
    Y = [(erroBranco[0], erroBranco[1], erroBranco[2]), (erroPreto[0], erroPreto[1], erroPreto[2]), (erroVerde[0], erroVerde[1], erroVerde[2]), (erroCinza[0], erroCinza[1], erroCinza[2])]
    (a1, a0) = minimosQuadradosRGB(Y, X)
    return (a1, a0, contador)

def salvaCalibracao(a1, a0):
    arquivo = open("calibracao.csv", "w")
    arquivo.write(str(a1[0])+";"+str(a1[1])+";"+str(a1[2])+";"+str(a0[0])+";"+str(a0[1])+";"+str(a0[2]))
    arquivo.close()

def carregaCalibracao():
    ev3.speaker.say("Carregando uma calibração prévia")
    a1 = (0, 0, 0)
    a0 = (0, 0, 0)
    arquivo = open("calibracao.csv", "r")
    linha   = arquivo.readline()
    a10, a11, a12, a00, a01, a02 = linha.split(";")
    a1 = (float(a10), float(a11), float(a12))
    a0 = (float(a00), float(a01), float(a02))
    arquivo.close()
    return (a1, a0)

# Create your objects here.
ev3 = EV3Brick()

# Write your program here.
ev3.speaker.set_speech_options('pt-br','m3')
ev3.speaker.beep()

HOST = '192.168.0.3'    # Endereco IP do Servidor
PORT = 2508             # Porta que o Servidor esta
udp = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
dest = (HOST, PORT)

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
a1 = (0, 0, 0)
a0 = (0, 0, 0)
contador = 0
while(True):
    # Vamos implementar o menu principal
    botoes = ev3.buttons.pressed()
    if(len(botoes) == 0):
        cronometro.reset()
    elif(botoes != botoesAnt):
        cronometro.reset()
    elif([Button.UP] == botoes and cronometro.time()>=250):        
        (a1, a0, contador) = executaCalibracao(corLeft, corRight, contador, udp)
        salvaCalibracao(a1, a0)
        opcoesMenuPrincipal()
    elif([Button.DOWN] == botoes and cronometro.time()>=250):        
        (a1, a0) = carregaCalibracao()
        opcoesMenuPrincipal()
    elif([Button.CENTER] == botoes and cronometro.time()>=250):
        break

    left = corLeft.rgb()
    right= corRight.rgb()

    lr = "{0:.2f}".format(left[0])
    lg = "{0:.2f}".format(left[1])
    lb = "{0:.2f}".format(left[2])

    rr = "{0:.2f}".format(right[0]+a1[0]*right[0] + a0[0])
    rg = "{0:.2f}".format(right[1]+a1[1]*right[1] + a0[1])
    rb = "{0:.2f}".format(right[2]+a1[2]*right[2] + a0[2])

    contador += 1

    msg = str(contador)+" "+lr+" "+lg+" "+lb+" "+rr+" "+rg+" "+rb
    #print("Tempo formatação ", cronometro.time())

    udp.sendto (msg, dest)

    botoesAnt = botoes


ev3.speaker.say("Encerrado")