#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO3     ºAutor  ³Elvis Kinuta        º Data ³  01/07/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada - Para gravacao de campos do Orcamento    º±±
±±º          ³   para Pedido de Venda na efetivacao.                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP Cliente Cozil                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT416FIM()

dbSelectArea("SCJ")

dbSelectArea("SC5")
dbSetOrder(1)
dbSeek(xFilial("SC5")+SCK->CK_NUMPV)

dbSelectArea("SCK")
dbSetOrder(1)
dbSeek(SCJ->CJ_FILIAL+SCJ->CJ_NUM)

While !eof() .And. SCK->CK_FILIAL+SCK->CK_NUM == SCJ->CJ_FILIAL+SCJ->CJ_NUM
	dbSelectArea("SC6")
	dbSetOrder(1)
	If dbSeek(SCK->CK_FILIAL+SCK->CK_NUMPV+SCK->CK_ITEM)
		RecLock("SC6",.F.)
		SC6->C6_XESPEC  	:= SCK->CK_XESPEC
		SC6->C6_XOP     	:= SC5->C5_NUM+SC6->C6_ITEM
		SC6->C6_UM      	:= SCK->CK_UM     
		
		If (SCJ->CJ_XTPPV = "L")
			SC6->C6_XSTATUS 	:= "1"                 // No caso de licitacoes o status passa para projetos
		Else
			SC6->C6_XSTATUS 	:= "3"                 // Para Status do Painel do Pedido de Venda ir para desenvolvimento	
		EndIF
				
		SC6->C6_XITCLI  	:= SCK->CK_XITCLI
		SC6->C6_XANDAR  	:= SCK->CK_XANDAR
		SC6->C6_XSETOR  	:= SCK->CK_XSETOR
		SC6->C6_XTPPROD 	:= SCK->CK_XTPPROD
		xSit 			:= Posicione("SF4",1,xFilial("SF4")+SC6->C6_TES,"F4_SITTRIB")
		xOri 			:= Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_ORIGEM")
		SC6->C6_CLASFIS  	:= xOri+xSit
		xAce1			:= Posicione("SB1",1,xFilial("SB1")+SCK->CK_XAC1,"B1_DESC")
		xAce2			:= Posicione("SB1",1,xFilial("SB1")+SCK->CK_XAC2,"B1_DESC")
		xAce3			:= Posicione("SB1",1,xFilial("SB1")+SCK->CK_XAC3,"B1_DESC")
		xAce4			:= Posicione("SB1",1,xFilial("SB1")+SCK->CK_XAC4,"B1_DESC")
		xAce5			:= Posicione("SB1",1,xFilial("SB1")+SCK->CK_XAC5,"B1_DESC")
		SC6->C6_XDAC1     	:= xAce1
		SC6->C6_XAC1      	:= SCK->CK_XAC1
		SC6->C6_XDAC2     	:= xAce2
		SC6->C6_XAC2      	:= SCK->CK_XAC2
		SC6->C6_XDAC3     	:= xAce3
		SC6->C6_XAC3      	:= SCK->CK_XAC3
		SC6->C6_XDAC4     	:= xAce4
		SC6->C6_XAC4      	:= SCK->CK_XAC4
		SC6->C6_XDAC5     	:= xAce5
		SC6->C6_XAC5      	:= SCK->CK_XAC5
		
		//[WILLIAM] COPIA O CAMPO: "TIPO DE PEDIDO DE VENDA" DOS ITENS DO ORC. PARA OS ITENS DO PEDIDO
		SC6->C6_XTPPV		:= SCK->CK_XTPPV
		//[FIM - WILLIAM]
		
		dbSelectArea("SCJ")
		cNomCli := Posicione("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_NOME")
		SC5->C5_NOMCLI  	:= cNomCli
		SC5->C5_TPFRETE 	:= SCJ->CJ_TPFRETE
		SC5->C5_MENNOTA 	:= SCJ->CJ_MENNOTA
		SC5->C5_TRANSP  	:= SCJ->CJ_TRANSP
		SC5->C5_VEND1   	:= SCJ->CJ_VEND1
		SC5->C5_ESPECI1 	:= SCJ->CJ_ESPECI1
		SC5->C5_PESOL   	:= SCJ->CJ_PESOL
		SC5->C5_PBRUTO  	:= SCJ->CJ_PBRUTO
		SC5->C5_VOLUME1 	:= SCJ->CJ_VOLUME1
		 
		//[WILLIAM] COPIA O CAMPO: "TIPO DE PEDIDO DE VENDA" e "HISTORICO"
		SC5->C5_XTPPV 		:= SCJ->CJ_XTPPV
		SC5->C5_XHISTOR	:= SCJ->CJ_XHISTOR
		//[FIM - WILLIAM]   
		
		MsUnlock()
	Endif
	dbSelectArea('SCK')
	dbSkip()
EndDo

Return
