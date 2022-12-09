#INCLUDE "PROTHEUS.CH" 
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M410STTS  ºAutor  ³Joao Tavares Junior º Data ³  03/22/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera bloqueio pedido de venda                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function M410STTS()

Local aAreaAnt 	:= GetArea()
Local nPosQtd    	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
Local nPosValor	    := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})
Local nPosDesc		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCONT"})
Local nPosPrc		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})
Local nPosList		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"})
Local nPosMrg		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_MRG"})
Local nPosOrc		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_NUMORC"})
Local cCliente     :=""
Local cLoja			:=""
Local nX 			:= 0
Local nValor 		:= 0
Local nDescPed      := 0
Local nPrcVen       := 0
Local nMarMin       := 0
Local nDesconto     := 0
Local lMargPed		:= .T.
lOCAL lGeraRc 		:=.F.
Local cGrpVar       := ""
Local nOper			:= 1
Local cNumOrc		:= ""
Local lProcesso     :=.F. 
Local lRetorno		:=.T.
     
If Altera .And. Len(aCols) == 0
	dbSelectArea("SC6")
	dbSeek(xFilial("SC6")+SC5->C5_NUM)
	While !EOF() .And. C6_FILIAL+C6_NUM == xFilial("SC6")+SC5->C5_NUM
		cGrpVar := Posicione("SB1",1,xFilial("SB1") + SC6->C6_PRODUTO,"B1_GRPVAR") //Grupo de Variaveis
		nMarMin := Posicione("PA7",1,xFilial("PA7") + cGrpVar,"PA7_MARMIN")
		
		nPrcVen 	:= 	SC6->C6_PRCVEN
		nDesconto 	:= SC6->C6_DESCONT
		
		nValor += nPrcVen*SC6->C6_QTDLIB
		
		If nDesconto > 0
			nDescPed	:= Max(nDescPed,(nDesconto))
		Endif
		If SC6->C6_MRG < nMarMin
				lMargPed	:= .F.
		Endif
		dbSkip()
	End
Else
	For nX := 1 to Len(aCols)
		If aCols[nX][Len(aHeader)+1] == .F. //Verifica se a linha eh valida
			
			cGrpVar := Posicione("SB1",1,xFilial("SB1") + SC6->C6_PRODUTO,"B1_GRPVAR") //Grupo de Variaveis
			nMarMin := Posicione("PA7",1,xFilial("PA7") + cGrpVar,"PA7_MARMIN")
			
			nValor 		+= aCols[nX][nPosPrc]*aCols[nX][nPosQtd]
			nDesconto	:=(aCols[nX][nPosDesc])
			
			If nDesconto > 0
				nDescPed	:= Max(nDescPed,(nDesconto))
			Endif
			If (aCols[nX][nPosMrg]) < nMarMin
				lMargPed	:= .F.	
			Endif
		EndIf
	Next nX
Endif
nVlrReal := xMoeda(nValor,1,1,dDataBase,2)

aDocto := {SC5->C5_NUM,"02",nVlrReal,nil,__cUserID,nil,SC5->C5_EMISSAO,nil,nil,}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se alteracao, deleta todos os bloqueios pre existentes para gerar novamente  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := " SELECT R_E_C_N_O_  AS NREC					"
cQuery += " FROM "+RetSqlName("SCR")+" 		"
cQuery += " WHERE CR_FILIAL = '"+xFilial("SCR")+"'		"
cQuery += " AND CR_TIPO  = '02'		   					"
cQuery += " AND CR_NUM = '"+SC5->C5_NUM+"'				"
cQuery += " AND D_E_L_E_T_ = ''							"

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

TcQuery cQuery New Alias "TMP"

DbSelectArea("TMP")
DbGoTop()
While !TMP->(EOF())
	DbSelectArea("SCR")
	DbGoTo(TMP->NREC)
	RecLock("SCR")
	DbDelete()
	MsUnLock()
	TMP->(DbSkip())
EndDo

If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
EndIf

dbSelectArea( 'SCR' )
lRet := 	U_Delegantes(aDocto,nDescPed,lMargPed)


If lRet 

//If inclui 
cNumOrc := SubStr(aCols[1][nPosOrc],1,6)
If aDocto[3] == Posicione("SCR",1,xFilial("SCR") + "01" + cNumOrc,"CR_TOTAL");
	 .And. Posicione("SCR",1,xFilial("SCR") + "01" + cNumOrc,"CR_STATUS") == "03"

			aDocto[9] := "Aprovado no Orcamento"
			aDocto[10] := "03"

EndIf
	
	U_AlcDoc1(aDocto,nOper)
	dbSelectArea( 'SC5' )
	
	If aDocto[10] = "03"
		RecLock("SC5",.F.)
		SC5->C5_LIBEROK := "S"
		SC5->C5_STSBLQ := "1"
		MsUnLock()
	Else
		RecLock("SC5",.F.)
		SC5->C5_LIBEROK := " "
		SC5->C5_STSBLQ := "2"
		MsUnLock()
	EndIf
Else
	RecLock("SC5",.F.)
	SC5->C5_LIBEROK := " "
	SC5->C5_STSBLQ := "4"
	MsUnLock()
EndIf
// workflow para solicitacao de compra partindo da venda
DbSelectArea("SC6")
dbSetOrder(1)
IF MsSeek(xfilial("SC6")+SC5->C5_NUM)
WHILE (SC6->C6_NUM=SC5->C5_NUM)
  if SC6->C6_QTDLOC2>0 
    lGeraRc:=.t.
  ENDIF
  DBSKIP()
ENDDO
ENDIF
if lGeraRc=.t.
  If MsgYesNo("Prezado Usuario, Seu pedido tem quantidades para compra imediata. Deseja enviar Solicitacao?","Automacao de Processo") 
    	U_WFHC002()
  endif
endif	

Return(lRetorno)
