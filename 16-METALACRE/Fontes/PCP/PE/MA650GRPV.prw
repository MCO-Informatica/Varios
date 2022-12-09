#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MA650GRPV³Autor  ³Bruno Daniel Borges ³ Data ³  25/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada na geracao de OPs sobre pedidos de venda   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Metalacre                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista Resp.³  Data  ³ Manutencao Efetuada                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAdalberto Neto³18/02/14³Criacao do campo C2_XDESCLI pelo analista Renanº±±
±±º              ³        ³Inserido no IF abaixo a gravacao do campo      º±±
±±º              ³        ³C5_NOMECLI no campo C2_XDESCLI.                º±±
±±º              ³        ³Este campo C2_XDESCLI sera inserido no relato- º±±
±±º              ³        ³rio RELACAO DE OP. Via Personalizacao.         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MA650GRPV()
Local aAreaBKP := GetArea()
Local aAreaSC2    := SC2->(GetArea())
Local aAreaSC5    := SC5->(GetArea())
Local aAreaSC6    := SC6->(GetArea())
Local aAreaSC9    := SC9->(GetArea())
Local aAreaSB1    := SB1->(GetArea())
                                    
If cEmpAnt <> '01'
	Return
Endif

If SC6->C6_OP == '05'
	MsgStop("Atenção OP Não foi Gerada, pois Existe Saldo Disponivel para o Item " + SC6->C6_ITEM + " Do Pedido " + SC6->C6_NUM + " Produto " + SC6->C6_PRODUTO + Chr(13) + " Entrar em Contato com Depto de T.I. ")
Endif	

// Bruno Abrigo em 15.05.2012; trata atualizacoes dos campos customizados do Pedido para a OP
DbSelectArea("SC2");SC2->(DbSetOrder(1));SC2->(DbSeek(xFilial("SC6")+SC6->C6_NUM+SC6->C6_ITEM+'001'))
If !SC2->(Eof()) .and. !Empty(Alltrim(SC6->C6_XLACRE))
	If RecLock("SC2",.F.)
		SC2->C2_XLACRE		:= 	SC6->C6_XLACRE
		SC2->C2_XLACINI		:=	SC6->C6_XINIC
		SC2->C2_XLACFIN		:=	SC6->C6_XFIM
		SC2->C2_XEMBALA		:= 	SC6->C6_XEMBALA
		SC2->C2_XVOLITEM	:= 	SC6->C6_XVOLITEM
		SC2->C2_XPBITEM		:=	SC6->C6_XPBITEM
		SC2->C2_XPLITEM		:=	SC6->C6_XPLITEM
		SC2->C2_CLI			:=	SC6->C6_CLI
		SC2->C2_LOJA		:=	SC6->C6_LOJA  
		SC2->C2_OPC         := 	Left(SC6->C6_OPC,8)
		If SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+SC6->C6_NUM))
			If SC5->C5_CLIENTE+SC5->C5_LOJACLI$GetNewPar("MV_MTLCVN",'00132001*01140401')
				If SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+SC5->C5_CLIMTS+SC5->C5_LOJMTS))  	
					SC2->C2_XDESCLI		:= 	SA1->A1_NOME
				Endif
			Else
				If SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))  	
					SC2->C2_XDESCLI		:= 	SA1->A1_NOME
				Endif
			Endif
		Endif
	
		SC2->(MsUnlock())

		cProd := SC2->C2_PRODUTO // LINHA INSERIDA POR MATEUS HENGLE
	Endif
Endif  


//Atualiza o lacre associado ao item do pedido
If !Empty(SC6->C6_XLACRE)
	dbSelectArea("Z01")
	Z01->(dbSetOrder(1))
	Z01->(dbSeek(xFilial("Z01")+SC6->C6_XLACRE+SC6->C6_NUM+SC6->C6_ITEM ))
	While Z01->(!Eof()) .And. Z01->Z01_FILIAL+Z01->Z01_COD+Z01->Z01_PV+Z01->Z01_ITEMPV == xFilial("Z01")+SC6->C6_XLACRE+SC6->C6_NUM+SC6->C6_ITEM
		If Z01->Z01_STAT == "1"
			If RecLock("Z01",.F.)
				Z01->Z01_STAT	:= "2"
				Z01->Z01_OP		:= SC2->C2_NUM
				Z01->(MsUnlock())        
			Endif
		EndIf
		
		Z01->(dbSkip())
	EndDo
EndIf
If cEmpAnt == '01'
	If SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+SC6->C6_NUM)) .And. Empty(SC5->C5_PEDWEB)
		U_CargaPed(SC6->C6_NUM,SC6->C6_ITEM,SC6->C6_PRODUTO) // Ajusta Saldo Carga Fabrica
	Endif
Endif
RestArea(aAreaSC2)
RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aAreaSC9)
RestArea(aAreaSB1)
RestArea(aAreaBKP) 
Return(Nil)
