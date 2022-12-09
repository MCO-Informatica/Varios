#INCLUDE "PROTHEUS.CH" 
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A415TDOK  ºAutor  ³Microsiga           º Data ³  03/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function MA415END()

Local lRet 		:= .F.
Local aAreaAnt 	:= GetArea()
Local nValor	:= 0
Local nDescPed	:= 0
Local nVlrReal 	:= 0
Local cGrpVar	:= ""
Local nMarMin	:= 99
Local lMargPed	:= .T. 
Local nMoeda	:= 1
Local aDocto	:= {}
Local nOper     := paramIXB[2]

If paramIXB[1] == 1
	
	
	dbSelectArea("SCK")
	dbSeek(xFilial("SCK")+SCJ->CJ_NUM)
	While !EOF() .And. SCK->CK_FILIAL+SCK->CK_NUM == xFilial("SCJ")+SCJ->CJ_NUM  
	
	   cGrpVar := Posicione("SB1",1,xFilial("SB1") + SCK->CK_PRODUTO,"B1_GRPVAR") //Grupo de Variaveis
	   nMarMin := Posicione("PA7",1,xFilial("PA7") + cGrpVar,"PA7_MARMIN") 
		
		nValor += 	SCK->CK_PRCVEN*SCK->CK_QTDVEN
		
		If SCK->CK_DESCONT > 0
			nDescPed	:= Max(nDescPed,(SCK->CK_DESCONT))
		Endif
		If SCK->CK_MRG < nMarMin
			lMargPed	:= .F.
		Endif
		
		dbSkip()
	End
	
	nVlrReal := xMoeda(nValor,nMoeda,1,dDataBase,2)
	
	aDocto := {SCJ->CJ_NUM,"01",nVlrReal,nil,__cUserID,nil,SCJ->CJ_EMISSAO,nil,nil,}
	
	nOper := If(ParamIXB[2] == 1 .Or. ParamIXB[2] == 2,1,ParamIXB[2])
	
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se alteracao, deleta todos os bloqueios pre existentes para gerar novamente  |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := " SELECT R_E_C_N_O_  AS NREC					"
	cQuery += " FROM "+RetSqlName("SCR")+" 		"
	cQuery += " WHERE CR_FILIAL = '"+xFilial("SCR")+"'		"
	cQuery += " AND CR_TIPO  = '01'		   					"
	cQuery += " AND CR_NUM = '"+SCJ->CJ_NUM+"'				"
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
	
	lRet := 	U_Delegantes(aDocto,nDescPed,lMargPed)
	
	If lRet
		
		U_AlcDoc1(aDocto,nOper)
		
		If aDocto[10] = "03"  .and. nVlrReal<=GETMV("MV_VALMIN")
			RecLock("SCJ",.F.)
			SCJ->CJ_STATUS := "A"
			SCJ->CJ_STSBLQ := "1"
			SCJ->CJ_TOTAL:=nVlrReal
		    MsUnLock("SCJ")
		Else
		    IF  SCJ->CJ_classi="1" .or. SCJ->CJ_classi="2" 
				RecLock("SCJ",.F.)
			    SCJ->CJ_STATUS := "A"
			    SCJ->CJ_STSBLQ := "1"
			    SCJ->CJ_TOTAL:=nVlrReal
		        MsUnLock("SCJ")
			ELSE
			    RecLock("SCJ",.F.)
			    SCJ->CJ_STATUS := "D"
		     	SCJ->CJ_STSBLQ := "2" 
			    SCJ->CJ_TOTAL:=nVlrReal
			    MsUnLock("SCJ")
			    If MsgYesNo("Prezado Usuario, Seu Orcamento ultramassou seu limite de valor. Para aprovar o mesmo sera necessario a liberacao pela diretoria. Deseja enviar Solicitacao?","Automacao de Processo") 
    		    	U_WFHC001()
    		    endif
    		ENDIF   	
		EndIf
	Else
		RecLock("SCJ",.F.)
		//SCJ->CJ_STATUS := "D"
		//SCJ->CJ_STSBLQ := "4"
		SCJ->CJ_STATUS := "A"
		SCJ->CJ_STSBLQ := "1"
		SCJ->CJ_TOTAL:=nVlrReal
		MsUnLock("SCJ")
	EndIf
EndIf


RestArea(aAreaAnt)

Return(lRet)


