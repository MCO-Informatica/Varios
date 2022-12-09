#Include "Protheus.ch"
#INCLUDE "RWMAKE.CH"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	F340FCAN
// Autor 		Alexandre Dalpiaz
// Data 		10/12/2013
// Descricao  	ponto de entrada no FINA340 (ap�s grava��o da compensa��o a pagar)
//				grava campo E5_FILORIG, quando n�o for gravado pelo padr�o do sistema, pois at� o momento n�o est� gravando.
//				chamado aberto na Totvs, erro n�o reproduzido pelo pelo analista da Totvs
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
