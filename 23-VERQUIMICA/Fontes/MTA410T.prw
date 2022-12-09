#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA410T   ºAutor  ³Felipe Pieroni      º Data ³  08/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para Bloquear o Pedido por Regra no momento da      º±±
±±º          ³ inclusao ou alteracao                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MTA410T()

Local aAreaSC5 := SC5->(GetArea())
Local aAreaSC6 := SC6->(GetArea())
Local aAreaSC9 := SC9->(GetArea())

//If AllTrim(FunName()) == "MATA440"
	dbSelectArea("SC9")
	dbSetOrder(1)
	If dbSeek(SC5->C5_FILIAL+SC5->C5_NUM,.F.)
	
		While Eof() = .f. .And. SC9->C9_FILIAL == SC5->C5_FILIAL .AND. SC9->C9_PEDIDO == SC5->C5_NUM
		
			//----> INICIO GRAVACAO DOS CAMPOS CUSTOMIZADOS SC9 - 28/05/2017 - RICARDO SOUZA - MCINFOTEC
			//ALERT("SC9-> "+SC9->C9_PEDIDO+" "+SC9->C9_ITEM+" "+SC9->C9_PRODUTO)
			RecLock("SC9",.f.)
			SC9->C9_VQ_TRAN		:=	SC5->C5_TRANSP
			SC9->C9_VQ_NTRA		:=	Posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP,"A4_NOME")
			SC9->C9_VQ_NCLI		:=	POSICIONE("SA1",1,xFilial("SA1")+SC9->C9_CLIENTE+SC9->C9_LOJA,"A1_NOME")
			SC9->C9_VQ_FVER		:=	SC5->C5_VQ_FVER
			SC9->C9_VQ_FCLI		:=	SC5->C5_VQ_FCLI
			MsUnLock()
			//----> FIM GRAVACAO DOS CAMPOS CUSTOMIZADOS SC9 - 28/05/2017 - RICARDO SOUZA - MCINFOTEC
			
			SC9->(dbSkip())
		EndDo
	EndIf
//EndIf


SC5->(RestArea(aAreaSC5))
SC6->(RestArea(aAreaSC6))
SC9->(RestArea(aAreaSC9))

Return()