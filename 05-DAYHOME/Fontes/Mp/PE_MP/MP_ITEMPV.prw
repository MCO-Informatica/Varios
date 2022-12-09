#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO4     บ Autor ณ Lucas Pereira      บ Data ณ  11/04/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ ponto de entrada meus pedidos ARRAY CABECALHO PEDIDOS      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function MP_ITEMPV
local cFilMp 	:= PARAMIXB[1]	// FILIAL DA CONTA MEUS PEDIDOS
local cCtaMp 	:= PARAMIXB[2]	// CODIGO DA CONTA MEUS PEDIDOS
local aLinha 	:= PARAMIXB[3]	// ARRAY INTENS COM ESTRTURA PARA EXECUวรO DO EXCAUTO
local aPedido 	:= PARAMIXB[4]	// OBJETO RETORNO GET JSON MEUS PEDIDOS
local cTipVen 	:= PARAMIXB[5]	// TIPO DE OPERAวรO

local 	nPosDesc := aScan(aLinha,{|x|AllTrim(x[1]) == "C6_DESCONT"})
local 	nPosVlr  := aScan(aLinha,{|x|AllTrim(x[1]) == "C6_VALOR"})
local 	nPosPrc  := aScan(aLinha,{|x|AllTrim(x[1]) == "C6_PRCVEN"})
local 	nPosQtd  := aScan(aLinha,{|x|AllTrim(x[1]) == "C6_QTDVEN"})
local 	nPosPrun := aScan(aLinha,{|x|AllTrim(x[1]) == "C6_PRUNIT"})
local 	nDescont := 0	
local   nPrcVen
local 	nQtdVen
local 	nValor	
local   nAgio
local   nVlrTab

nQtdVen		:= aLinha[nPosQtd,2]
nPrcVen		:= aLinha[nPosPrc,2]
nValor		:= aLinha[nPosVlr,2]
nVlrTab     := aLinha[nPosQtd,2] * aLinha[nPosPrun,2]
nAgio       := ( ( nVlrTab - nValor) / nVlrTab ) * 100

IF nVlrTab < nValor
    aadd(aLinha,{ " C6_DESCONT"	,nAgio 		,Nil}) 
ENDIF

Return(aLinha)
