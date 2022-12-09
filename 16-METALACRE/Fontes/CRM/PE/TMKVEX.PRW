#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "Protheus.Ch"
#include "TbiConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TMKVEX   ºAutor  ³Mateus Hengle       º Data ³  15/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE executado ANTES do cancelamento do Atendimento para     º±±
±±º          ³ tratar a numeracao dos lacres e permitir a exclusao do PV  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºOBS       ³ Antigo A410EXC                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TMKVEX()
Local cNumPed	:= M->UA_NUMSC5
Local lOk		:= .T.
Local nFor		:= 0
Local nPosDel	:= Len(aHeader) + 1
Local nPosItem	:= Ascan(aHeader, { |x| Alltrim(x[2]) == "UB_ITEM" })
Local cQuery 	:= ""
Local cLinha   	:= CHR(13) + CHR(10)
Local aArea    	:= GetArea()
Local cOperX    := M->UA_OPER
Local aArea := GetArea()
Local cMotivo	:= 	MSMM(SUA->UA_CODCANC,TamSx3("UA_OBSCANC")[1])
Local cCodMot	:=	Space(06)
Local lSai		:=  .f.
Local oDlg

Private oDesMot
Private cDesMot

If lOK
	While !lSai
		@ 270,100 To 414,650 Dialog oDlg Title OemToAnsi("MOTIVO DO CANCELAMENTO")
		@ 005,005 Say OemToAnsi("Motivo:") Size 050,030 PIXEL Of oDlg
		@ 005,050 Get cMotivo MEMO Size 200,025 PIXEL Of oDlg
		@ 033,005 Say OemToAnsi("Ocorrência:") Size 050,030 PIXEL Of oDlg
		@ 033,050 MsGet oCodMot Var cCodMot F3 "SU9F" Valid(Empty(cCodMot) .Or. fMot(cCodMot,@cDesMot)) Size 030,010 PIXEL Of oDlg
		@ 033,100 MsGet oDesMot Var cDesMot When .f. Size 100,010 PIXEL Of oDlg
	
		@ 050,015 Button Oemtoansi("Confirma") Size 036,016 Action (lSai:=.t.,Close(oDlg)) PIXEL Of oDlg
		@ 050,075 Button OemToAnsi("Sair")   Size 036,016 Action (lSai:=.t.,oDlg:End(),Close(oDlg)) PIXEL Of oDlg
						
		ACTIVATE DIALOG oDlg CENTERED
	Enddo
	
	If !Empty(cMotivo) .And. !Empty(cCodMot)
		If SUA->(dbSetOrder(1), dbSeek(xFilial("SUA")+M->UA_NUM))
			If RecLock("SUA",.F.)
//				SUA->UA_CANC	:= "S"
//				SUA->UA_STATUS 	:= "CAN"
				SUA->UA_CODLIG	:= cCodMot
				SUA->UA_DTCANC	:= dDataBase
				MSMM(,TamSx3("UA_OBSCANC")[1],,cMotivo,1,,,"SUA","UA_CODCANC")
				MsUnlock()
			Endif
		Endif
		RestArea(aArea)
		Return .t.
	Else                                   
		Alert("Para Cancelar o Orçamento é Necessário Informar, Motivo e Código da Ocorrência !")
		RestArea(aArea)
		Return .f.
	Endif
Endif
Return(lOk)




Static Function fMot(cCodMot)
If !SU9->(dbSetOrder(2), dbSeek(xFilial("SU9")+cCodMot))
	Alert("Atenção Código de Motivo Não Localizado !!!")
	Return .f.
Else
	If !(SU9->U9_VALIDO=='1' .And. SU9->U9_TIPOATE $'2*4')
		Alert("Atenção Código de Motivo Inválido !")
		Return .f.
	Endif
	cDesMot	:= SU9->U9_DESC
	oDesMot:Refresh()
Endif
Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TMKVEX   ºAutor  ³Mateus Hengle       º Data ³  15/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE executado ANTES do cancelamento do Atendimento para     º±±
±±º          ³ tratar a numeracao dos lacres e permitir a exclusao do PV  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºOBS       ³ Antigo A410EXC                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TMKVDC(nOpca, cAtend)
Local aArea := GetArea()

If nOpca == 1 // Confirmou o Cancelamento
	If SUB->(dbSetOrder(1), dbSeek(xFilial("SUB")+cAtend))
		While SUB->(!Eof()) .And. SUB->UB_FILIAL == xFilial("SUB") .And. SUB->UB_NUM == cAtend
			
			aAreaSUB := SUB->(GetArea())
			
			U_JobCarga(SUB->UB_DTENTRE)
			U_CargaPed(SUB->UB_NUMPV,SUB->UB_ITEMPV,SUB->UB_PRODUTO)
			
			RestArea(aAreaSUB)

			// Voltando Numeração do lacre em caso de existencia de pedido de vendas
			
			cLacre := SUB->UB_XLACRE
			nLacreFim := SUB->UB_XFIM
			nQuant	:= SUB->UB_QUANT
			cNumSc5 :=	SUB->UB_NUMPV
			cItem	:=	SUB->UB_ITEMPV
			cStandXX:= SUB->UB_XSTAND
	
			If cStandXX <> '1' .And. Z00->(dbSetOrder(1), dbSeek(xFilial("Z00")+cLacre))
				cQuery := "SELECT Z01_PV "
				cQuery += "FROM "+RetSqlName("Z01")+" Z01 "
				cQuery += "WHERE Z01.Z01_FILIAL='"+xFilial("Z01")+"' AND "
				cQuery += "Z01.Z01_COD = '"+cLacre+"'  AND "
				cQuery += "Z01.Z01_INIC > " + AllTrim(Str(nLacreFim)) + " AND "
				cQuery += "Z01.D_E_L_E_T_<>'*' "
	
				cQuery := ChangeQuery( cQuery )
				dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), 'TMP' )
				
				If Empty(TMP->Z01_PV)
					If RecLock("Z00",.f.)
						Z00->Z00_LACRE  := Z00->Z00_LACRE - (nQuant)
						Z00->(MsUnlock())
					Endif
				Endif
				TMP->(dbCloseArea())
											
				dbselectarea("Z01")
				DBSETORDER(1)
				IF DBSEEK(XFILIAL("Z01") + cLacre + cNumSc5 + cItem)
					RECLOCK("Z01",.F.)
					Z01->(DBDELETE())
					Z01->(MSUNLOCK())
				ENDIF	
			Endif

			dbSelectArea("SUB")
			SUB->(dbSkip(1))
		Enddo
	Endif
Endif
Return Nil






/*





IF cOperX == '1'
	// Se nao tiver sido LIBERADO pelo SIGAFAT entao pode-se cancelar o pedido
	If SC9->(dbSetOrder(1), dbSeek(xFilial("SC9")+M->UA_NUMSC5))
		Alert("Atenção Pedido Já Liberado No Faturamento, Impossivel Cancelar este Atendimento !")
		Return .f.
	Endif

	For nFor := 1 To Len(aCols)
		
		DbSelectArea("SC6")
		DbSeek( xFilial("SC6") + cNumPed + aCols[nFor][nPosItem])
		
		cNumPed := C6_NUM
		cStandXX:= C6_XSTAND
		
		If !Empty(C6_NUMOP) .And. SC6->C6_XSTAND == '1' // Se For Stand By Deixa Excluir 3lSystems 30-09-14
			Alert("O item " + Alltrim(C6_PRODUTO) + " que você esta tentando deletar, ja possui OP gerada, número " + C6_NUMOP + ". Favor verificar com a área responsavel antes desta exclusão.")
			lOk := .F.
		Elseif !Empty(C6_NOTA)
			Alert("O item " + Alltrim(C6_PRODUTO) + " que você esta tentando deletar, ja possui nota fiscal gerada, número " + C6_NOTA + ". Favor verificar com a área responsavel antes desta exclusão.")
			lOk := .F.
		Else
			cQuery := "SELECT MAX(Z01_FIM) AS LACREMAX" + cLinha
			cQuery += "	FROM " + RetSqlName("Z01") + " " + cLinha
			cQuery += "WHERE " + cLinha
			cQuery += "	Z01_COD ='" + C6_XLACRE + "'" + cLinha
			cQuery += "	AND D_E_L_E_T_ = ''"
			
			dbUseArea(.T.,	"TOPCONN",	TcGenQry(,,cQuery), "TRBZ01",	.T., .T.)
			
			TRBZ01->( dbGoTop() )
			
			If !TRBZ01->(EOF())
				If SC6->C6_XFIM < TRBZ01->LACREMAX
					If MsgYesNo("A sequencia de numeração " + Alltrim(Str(SC6->C6_XFIM)) + " do lacre " + SC6->C6_XLACRE + " será perdida, pois já existe uma numeração maior !, mesmo assim deseja prosseguir com a exclusão do item ?")
						DbSelectArea("Z01")
						DbSetOrder(1)
						If DbSeek( xFilial("Z01") + SC6->C6_XLACRE + SC6->C6_NUM + SC6->C6_ITEM )
							RecLock("Z01",.F.)
							Z01->(DbDelete())
							Z01->(MsUnLock())
						Endif
					Else
						MsgInfo("A Exclusão do item " + Alltrim(SC6->C6_PRODUTO) + " foi abortada !")
						lOk := .F.
					Endif
				Else 
				
					IF cStandXX <> '1'  // TRATAMENTO FEITO PRA NAO VOLTAR A NUMERACAO QUANDO FOR PV STAND BY
						DbSelectArea("Z00")
						DbSetOrder(1)
						If DbSeek( xFilial("Z00") + SC6->C6_XLACRE )
							RecLock("Z00",.F.)
							Z00->Z00_LACRE := Z00_LACRE - SC6->C6_QTDVEN
							Z00->(MsUnLock())
				   		Endif 
					ENDIF
					
					DbSelectArea("Z01")
					DbSetOrder(1)
					If DbSeek( xFilial("Z01") + SC6->C6_XLACRE + SC6->C6_NUM + SC6->C6_ITEM )
						RecLock("Z01",.F.)
						Z01->(DbDelete())
						Z01->(MsUnLock())
					Endif
					RestArea(aArea)
				Endif
			Endif
			
			TRBZ01->(dbCloseArea())
			
		Endif
		
	Next nFor
ENDIF
*/