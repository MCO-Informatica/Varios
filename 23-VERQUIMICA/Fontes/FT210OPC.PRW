#include "rwmake.ch"
#include "Protheus.ch"
#include "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FT210OPC  ºAutor  ³Felipe Pieroni      º Data ³  08/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para gravacao de campos especificos na telaº±±
±±º          ³ de aprovacao de Regra. Trata 1a. e 2a. Liberacao            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FT210OPC()

MsgRun("Efetuando Liberacao", "Liberacao de Regras", {||VQLIBERA()})

Return

Static Function VQLIBERA()

If SC5->C5_BLQ	==	"1"	
	RecLock("SC5",.F.)
	SC5->C5_BLQ := ""
	SC5->C5_VQ_USL1  := cUserName
	SC5->C5_VQ_DTL1  := Date()
	SC5->C5_VQ_HRL1  := Time()
	SC5->(MsUnlock())
EndIf

MsgRun("Gravando Pedido Liberado", "Faturamento Estoque", {||VQLIBFAT()})

Return()

Static Function VQLIBFAT()

Local aCond	:= {}
//----> GRAVA O PEDIDO LIBERADO
If Empty(SC5->C5_BLQ)

	dbSelectArea("SC9")
	SC9->(dbSetOrder(1))
	SC9->(dbSeek(xFilial("SC9")+SC5->C5_NUM))
	While SC9->(!EOF()) .and. SC9->C9_FILIAL+SC9->C9_PEDIDO == xFilial("SC9")+SC5->C5_NUM
		If SC9->C9_BLCRED <> '10' .and. SC9->C9_BLEST <> '10'
			a460Estorna()
		EndIf
		SC9->(dbSkip())
	Enddo

	dbSelectArea("SC6")
	dbSetOrder(1)
	SC6->(DbSeek(SC5->C5_FILIAL+SC5->C5_NUM))
	Begin Transaction
	While SC6->C6_NUM == SC5->C5_NUM .AND. SC6->(!EOF())
		MaLibDoFat(SC6->(RecNo()),(SC6->C6_QTDVEN-SC6->C6_QTDENT),.T.,.T.,.T.,.T.)
        RecLock("SC6",.F.)
        	SC6->C6_FCICOD	:=	POSICIONE("SD1",23,xFilial("SD1")+SC9->C9_LOTECTL,"D1_FCICOD")                                        
        MsUnLock()
		SC6->(dBSkip())
	EndDo
	
	MaLiberOk({ SC5->C5_NUM },.T.)
	End Transaction

	//Seleciona condicao de pagamento que gera bloqueio
	cQuery := "SELECT E4_CODIGO CODIGO FROM "+RetSqlName("SE4")+" (NOLOCK) "	
	cQuery += "WHERE E4_FILIAL = '"+xFilial("SE4")+"' "
	cQuery += "AND E4_DESCRI = 'A VISTA' OR LEFT(E4_DESCRI,2) = '00' "
	cQuery += "AND D_E_L_E_T_ = ' ' "
	U_FinalArea("QUERY")
	TcQuery cQuery New Alias "QUERY"
	dbSelectArea("QUERY")
	QUERY->(dbGoTop())
	While QUERY->(!EOF())
		aAdd(aCond,QUERY->CODIGO)
		QUERY->(dbSkip())
	ENDDO
	U_FinalArea("QUERY")
	
	dbSelectArea("SC9")
	dbSetOrder(1)
	If dbSeek(SC5->C5_FILIAL+SC5->C5_NUM,.F.)
		
		While Eof() = .f. .And. SC9->C9_FILIAL == SC5->C5_FILIAL .AND. SC9->C9_PEDIDO == SC5->C5_NUM
			
			//----> INICIO GRAVACAO DOS CAMPOS CUSTOMIZADOS SC9 - 28/05/2017 - RICARDO SOUZA - MCINFOTEC
			RecLock("SC9",.F.)
				SC9->C9_VQ_TRAN		:=	SC5->C5_TRANSP
				SC9->C9_VQ_NTRA		:=	Posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP,"A4_NOME")
				SC9->C9_VQ_NCLI		:=	POSICIONE("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME")
				SC9->C9_VQ_FVER		:=	SC5->C5_VQ_FVER
				SC9->C9_VQ_FCLI		:=	SC5->C5_VQ_FCLI
				If Ascan(aCond,SC5->C5_CONDPAG) > 0
					SC9->C9_BLCRED := "01"
				Endif
			MsUnLock()
			//----> FIM GRAVACAO DOS CAMPOS CUSTOMIZADOS SC9 - 28/05/2017 - RICARDO SOUZA - MCINFOTEC
			
			SC9->(dbSkip())
		EndDo
	EndIf
EndIf

Return()
