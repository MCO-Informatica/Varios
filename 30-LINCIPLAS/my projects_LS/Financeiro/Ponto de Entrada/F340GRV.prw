#Include "Protheus.ch"
#INCLUDE "RWMAKE.CH"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	F340GRV
// Autor 		Thiago Queiroz - SUPERTECH
// Data 		15/12/2015
// Descricao  	ponto de entrada no FINA340 (após gravação da compensação a pagar)
//				grava campo E5_FILORIG, quando não for gravado pelo padrão do sistema, pois até o momento não está gravando.
//				chamado aberto na Totvs, erro não reproduzido pelo pelo analista da Totvs
// Uso         	LaSelva
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function F340GRV()
////////////////////////
Private aArea := GetArea()

If empty(SE5->E5_FILORIG) .OR. SE5->E5_FILORIG != SE5->E5_FILIAL
	RecLock('SE5',.f.)
	SE5->E5_FILORIG := SE5->E5_FILIAL
	MsUnLock()
EndIf

cDocumen 	:= SE5->E5_DOCUMEN
cPrefixo	:= SUBSTR(cDocumen,1,3)
cNumero		:= SUBSTR(cDocumen,4,9)
cParcela	:= SUBSTR(cDocumen,13,3)
cTipo		:= SUBSTR(cDocumen,16,3)
cFornece	:= SUBSTR(cDocumen,19,6)
cLoja		:= SUBSTR(cDocumen,25,2)

dbSelectArea("SE5")
dbSetOrder(7)
IF dbSeek(xFilial("SE5")+cPrefixo+cNumero+cParcela+cTipo)
	WHILE !EOF() .AND. SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) == cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja
		IF SE5->E5_DTDIGIT == DDATABASE
			If empty(SE5->E5_FILORIG) .OR. SE5->E5_FILORIG != SE5->E5_FILIAL
				RecLock('SE5',.f.)
				SE5->E5_FILORIG := SE5->E5_FILIAL
				MsUnLock()
			EndIf
		ENDIF
		DBSKIP()
	ENDDO
ENDIF

RestArea(aArea)

Return()
