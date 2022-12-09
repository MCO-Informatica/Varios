#Include "Protheus.ch"
#INCLUDE "RWMAKE.CH"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	F340FCAN
// Autor 		Alexandre Dalpiaz
// Data 		10/12/2013
// Descricao  	ponto de entrada no FINA340 (após gravação da compensação a pagar)
//				grava campo E5_FILORIG, quando não for gravado pelo padrão do sistema, pois até o momento não está gravando.
//				chamado aberto na Totvs, erro não reproduzido pelo pelo analista da Totvs
// Uso         	LaSelva
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function F340FCAN()
////////////////////////
If empty(SE5->E5_FILORIG) .OR. SE5->E5_FILORIG != SE5->E5_FILIAL
	RecLock('SE5',.f.)
	SE5->E5_FILORIG := SE5->E5_FILIAL
	MsUnLock()
EndIf
Return()
