#include "rwmake.ch"
#include "Protheus.ch"   

#DEFINE CRLF CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FT210OPC  ºAutor  ³Felipe Pieroni      º Data ³  08/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para gravacao de campos especificos na tela º±±
±±º          ³ de aprovacao de Regra. Trata 1a. e 2a. Liberacao            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FT210OPC()

Local _cUsuario	 := Upper(Alltrim(__cUserID))
Local _cQuemLib1 := Alltrim(Upper(GETMV("MV_VQPVL1")))
Local _cQuemLib2 := Alltrim(Upper(GETMV("MV_VQPVL2")))  
Local _UsrLib1 := IIF(_cUsuario $ _cQuemLib1, .T., .F.)
Local _UsrLib2 := IIF(_cUsuario $ _cQuemLib2, .T., .F.)   

If SC5->C5_BLQ	==	"1"
	 If _cUsuario $ _cQuemLib1	
		RecLock("SC5",.F.)
		SC5->C5_BLQ := "2"
		SC5->C5_VQ_USL1  := cUserName
		SC5->C5_VQ_DTL1  := Date()
		SC5->C5_VQ_HRL1  := Time()
		SC5->(MsUnlock())  
	Else              
		If _UsrLib2
			_cMsgBlq := "Voce nao tem permissao para liberar por REGRA COMERCIAL" + CRLF + CRLF
			_cMsgBlq += "Esse pedido esta aguardando pela liberação do COMERCIAL"
			MsgInfo(_cMsgBlq)
		EndIf
	EndIf
ElseIf SC5->C5_BLQ == "2"
	If _cUsuario $ _cQuemLib2	
		RecLock("SC5",.F.)
		SC5->C5_BLQ := ""
		SC5->C5_VQ_USL2  := cUserName
		SC5->C5_VQ_DTL2  := Date()
		SC5->C5_VQ_HRL2  := Time()
		SC5->(MsUnlock())  
	Else                                                                
		If _UsrLib1                                                                            
			_dDtLib1 := SC5->C5_VQ_DTL1
			_cMsgBlq := "Voce nao tem permissao para liberar por REGRA FINANCEIRO " + CRLF + CRLF
			_cMsgBlq += "O pedido de numero " + AllTrim(SC5->C5_NUM) + " ja foi liberado pelo COMERCIAL por : " + AllTrim(SC5->C5_VQ_USL1) + " em : " + DtoC(_dDtLib1)
			MsgInfo(_cMsgBlq)
		EndIf		
	EndIf 
Else                     
		_dDtLib1 := SC5->C5_VQ_DTL1
		_dDtLib2 := SC5->C5_VQ_DTL2 
		_cMsgBlq := "O pedido de numero " + AllTrim(SC5->C5_NUM) + " ja encontra-se liberado pelo COMERCIAL e FINANCEIRO " + CRLF + CRLF
		_cMsgBlq += "Aprovado pelo COMERCIAL POR: " + AllTrim(SC5->C5_VQ_USL1) + " EM : " + DtoC(_dDtLib1) + CRLF 
		_cMsgBlq += "Aprovado pelo FINANCEIRO POR: " + AllTrim(SC5->C5_VQ_USL1) + " EM : " + DtoC(_dDtLib2) + CRLF 		
		MsgInfo(_cMsgBlq)
EndIf

Return()