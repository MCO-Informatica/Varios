#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"
#Include "ap5mail.Ch"
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT120GRV  ºAutor  ³Rodrigo             º Data ³  08/05/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada, Dispara email se estourou o orcamento     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT120GRV()
dbSelectArea("SC7")
_aArea := GetArea()

lRet   := .T.
//
//
//   RETIRADO EM 05/10/2018 - ESTA COM ERRO NO PROTHEUS12 - POS VIRADA.
//
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia Workflow para aprovacao da Solicitacao de Compras ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//If INCLUI .OR. ALTERA //Verifica se e Inclusao ou Alteracao da Solicitacao
//	MsgRun("Enviando Workflow para Aprovador da Solicitação, Aguarde...","",{|| CursorWait(), U_COMRD003() ,CursorArrow()})
//EndIf
//////////////////////////////////////////////////////////////////////////

_cNaturez := SUBSTR(M->CCODNATU,1,3)  // PEGA A NATUREZA
_dDataAte  := lastday(ddatabase)
_dDataDe   := firstday(ddatabase)  
_cCond     := ccondicao


dbSelectArea("SED")
DBSETORDER(1)
DBSEEK(XFILIAL("SED") + _cNaturez)
_DescNat  := ED_DESCRIC

dbSelectArea("SC7")
dbSetOrder(1)

cFilTrab   := CriaTrab(NIL,.F.)
cCondicao  := " C7_FILIAL == '"+xFilial()+"'.And."
cCondicao  := " DTOS(C7_DATPRF) >= '" + dtos(_dDATAde)  + "' .And. "
cCondicao  += " DTOS(C7_DATPRF) <= '" + dtos(_dDATAate) + "' .And. "
cCondicao  += " SUBSTR(C7_NATUREZ,1,3)  == '" +_cNaturez + "'"
cChave := "C7_NATUREZ"
IndRegua("SC7",cFilTrab,cChave,,cCondicao,"Filtrando")    // "Selecionando Registros..."

dbSelectArea("SC7")
DbGoTop()
_NTOTGER := 0
While !Eof()
	_nTotGER  += SC7->C7_TOTAL
	
	DBSELECTAREA("SC7")
	DBSKIP()
EndDo

_aMes := {}
AADD(_aMes,"JAN1")
AADD(_aMes,"FEV1")
AADD(_aMes,"MAR1")
AADD(_aMes,"ABR1")
AADD(_aMes,"MAI1")
AADD(_aMes,"JUN1")
AADD(_aMes,"JUL1")
AADD(_aMes,"AGO1")
AADD(_aMes,"SET1")
AADD(_aMes,"OUT1")
AADD(_aMes,"NOV1")
AADD(_aMes,"DEZ1")

dbSelectArea("SE7")
dbsetorder(2) 
DBGOTOP()
_cAnoAtu := StrZero(Year(dDatabase),4)
_cMesAtu := StrZero(Month(dDatabase),2)
_cCampo  := "SE7->E7_VAL"+_aMes[Month(dDatabase)]
_nValOrc := 0
If DbSeek(xfilial("SE7") + _cAnoAtu + _cNaturez )
	_nValOrc := &_cCampo
EndIf

_nValOrc := (_nValOrc * 0.90)

IF _nValOrc < _nTotGER
	
	
	Private cServer   := GETMV("MV_RELSERV")
	Private cAccount  := GETMV("MV_RELACNT")
	Private cPassword := GETMV("MV_RELPSW")
	Private cMensagem := ""
	//	Private cEnvia	 	:= "schutter.brasil@terra.com.br" //GETMV("MV_RELACNT")
	Private cEnvia	  := GETMV("MV_RELACNT")
	Private cCRLF	  := CHR(13)+CHR(10)
	Private cRecebe   := ""
	
	cRecebe 	:= "thiago@stch.com.br"
	
	cSubJect := "NATUREZA " + _cNaturez + " - " +_DescNat +"  " + "COM VALOR ACIMA DO ORCAMENTO !!!
	
	cMensagem:= "A NATUREZA " + _cNaturez + " - " + _DescNat + " ESTA COM VALOR ACIMA DO ORCAMENTO !!!!! " + " " + cCRLF + " " + cCRLF +"  "+;
	"Valor do Orcamento no Mes: " + Transform(_nValOrc,"@E 99,999,999.99") +cCRLF+" "+cCRLF+" "+cCRLF+" "+cCRLF+" "+;
	"Valor de Pedidos dessa Natureza no Mes " + Transform(_nTotGER,"@E 99,999,999.99")+cCRLF+" "
	
	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword TIMEOUT 10 Result lConectou
	SEND MAIL FROM cEnvia;
	TO cRecebe;
	SUBJECT cSubJect;
	BODY cMensagem;
	RESULT lEnviado
	
	If !lEnviado
		cMensagem := ""
		GET MAIL ERROR cMensagem
		Alert(cMensagem)
	Endif
	
	DISCONNECT SMTP SERVER Result lDisConectou
	
	cRecebe 	:= ""
	cSubJect := ""
	cMensagem:= ""
	

ENDIF    



ccondicao := _ccond
SINDEX := RetIndex ("SC7")
RestArea(_aArea)
	

dbSelectArea("SC7") 
dbCloseArea("SC7")

Return( lRet )

