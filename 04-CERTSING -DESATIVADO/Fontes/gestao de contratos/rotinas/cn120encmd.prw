#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CN120ENCMD º Autor ³ Tatiana Pontes 	   º Data ³ 11/04/13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada Encerramento da Medicao (CNTA120)	      º±±
±±º          ³ Criado para gravar campos adicionais no Pedido de Venda    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CN120ENCMD()

Local _cPvContr	:= Alltrim(GetMv("MV_PVCONTR")) // Gera pedido de venda atraves do modulo de gestao de contratos (S/N)
Local _aArea 	:= GetArea()

If CN1->CN1_ESPCTR <> "1"
	If _cPvContr == "S" .And. CNL->CNL_XGRPD <> "2"
		RecLock("SC5",.F.)
		SC5->C5_MDPROJE :=	_cCodPrj
		SC5->C5_MDEMPE	:= 	_cCodEmp
		//	SC5->C5_OPORTU	:=	_cOportu
		SC5->C5_ITEMCT  :=	_cItConta
		SC5->C5_CLVL    :=	_cClaVal
		C5_XNATURE		:=  AD1->AD1_XNATUR
		SC5->C5_XORIGPV	:= 	"6"
		MsUnlock()
	Endif
	
	//Envia Workflow de encerramento.
	U_CSGCT004()
	
	DbSelectArea("SZW")
	DbSetOrder(1)
	If !DbSeek( xFilial("SZW") + CND->CND_CONTRA + CND->CND_NUMERO + CND->CND_REVISA + _cCodEmp)
		
		RecLock("SZW",.T.)
		
		ZW_FILIAL := xFilial("SZW")
		ZW_NRCONT := CND->CND_CONTRA
		ZW_NRPLAN := CND->CND_NUMERO
		ZW_REVISA := CND->CND_REVISA
		ZW_NUMMED := CND->CND_NUMMED
		ZW_NOTA   := _cCodEmp
		ZW_CLIENT := CND->CND_CLIENT
		ZW_LOJA   := CND->CND_LOJACL
		
		SZW->(MsUnlock())
		
	EndIf
	
EndIf

RestArea(_aArea)

Return                                                                                
