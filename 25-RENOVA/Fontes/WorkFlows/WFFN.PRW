#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "tbicode.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NotifyAdm ºAutor  ³Microsiga           º Data ³  08/15/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Utilizado para enviar qualquer notificacao ao administrador º±±
±±º          ³do Siga.     												  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION NotifyAdm(cTitle, aMsg, aFiles )
RETURN U_MailNotify( , cTitle, aMsg, aFiles )

USER FUNCTION MailNotify(cTo, cTitle, aMsg, aFiles )
cTitle		:= ALLTRIM(cTitle) + " Emp/Fil : " + cEmpAnt + "/" + cFilAnt

cBody := ''
cBody += '<DIV><FONT face=Arial size=2></FONT>&nbsp;</DIV>'
cBody += '<DIV><SPAN class=610203920-12022004><FONT face=Verdana color=#ff0000 '
cBody += 'size=3><STRONG>Workflow - RENOVA - Serviço de Envio de Mensagens</STRONG></FONT></SPAN></DIV><hr>'
For nInd := 1 TO Len(aMsg)
 cBody += '<DIV><FONT face=Verdana color=#000080 size=2><SPAN class=216593018-10022004>' + aMsg[nInd] + '</SPAN></FONT></DIV><p>'
Next

IF EMPTY(cTo)
	cTo	:= Nil                            
ENDIF

RETURN WFNotifyAdmin( cTo , cTitle, cBody, aFiles )
	

//---------------- RETORNO E ENVIO


//------------------------------------------------------------------------
// SEMAFORO
//------------------------------------------------------------------------
                    
USER FUNCTION SEMAFORO(Params)
Local nHdl 	:= 0                  
Local cFile := ""

    IF Params == Nil .OR. ! ValType(Params) $ "N|C" 
    	U_CONSOLE("SEMAFORO - Parametro invalido")
    	RETURN
    ENDIF            

	IF VALTYPE(Params) == "C"	// Quando for caracter - fecha o semaforo
		cFile := TRIM(Params) + ".LCK"
		       
		IF !FILE(cFile)
			nHdl:=MSFCREATE(cFile,0)
			fClose(nHdl)
		ENDIF
			
		While .T.
			nHdl := FOPEN(cFile , 16)
			IF nHdl > 0
			   	EXIT
			ENDIF			    
		    
			SLEEP(5000)
		END
	ENDIF
	
	IF VALTYPE(Params) == "N"	// Quando for numerico - abre o semaforo
		fClose(Params)
	ENDIF
	
	RETURN IIF(nHdl <> 0, nHdl, Nil)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetTimeOut                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
*/
User function GetTimeOut(nTimeOut,dData, cHora)
Local cQuery := ""
                  
IF dData == Nil
	dData	:= MSDATE()
ENDIF
IF cHora == Nil
	cHora	:= TIME()
ENDIF
IF nTimeOut == Nil
	nTimeOut:= 24
ENDIF

cHoraI 	:= GetNewPar("MV_WFHORAI","08:00")
cHoraF  := GetNewPar("MV_WFHORAF","18:00")

nHora	:= Val(Left(cHora,2))  + Val(Substr(cHora,4,2))/60
nHoraI  := Val(Left(cHoraI,2)) + Val(Substr(cHoraI,4,2))/60
nHoraF  := Val(Left(cHoraF,2)) + Val(Substr(cHoraF,4,2))/60

IF nHora<=nHoraI  
	nHora	:= nHoraI 
ENDIF                
  
dDtVld := dData
While .T.
	IF (nHora + nTimeOut) <= nHoraF
		nHora	:= nHora + nTimeOut
		EXIT
	ENDIF
	nTimeOut	:= nTimeOut - (nHoraF - nHora)
	nHora		:= nHoraI

	dDtVld		:= dDtVld + 1     
	dDtVld		:= DataValida(dDtVld,.T.)
END

return {dData,cHora,dDtVld, ALLTRIM(STRZERO(int(nHora),2)) + ":" + ALLTRIM(STRZERO((nHora - Int(nHora)) * 60,2))}
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MaAlcDoc Autor ³ Aline Correa do Vale   ³  Data ³07.08.2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Controla a alcada dos documentos (SCS-Saldos/SCR-Bloqueios)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MaAlcDoc(ExpA1,ExpD1,ExpN1,ExpC1)                     	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array com informacoes do documento                 ³±±
±±³          ³       [1] Numero do documento                              ³±±
±±³          ³       [2] Tipo de Documento                                ³±±
±±³          ³       [3] Valor do Documento                               ³±±
±±³          ³       [4] Codigo do Aprovador                              ³±±
±±³          ³       [5] Codigo do Usuario                                ³±±
±±³          ³       [6] Grupo do Aprovador                               ³±±
±±³          ³       [7] Aprovador Superior                               ³±±
±±³          ³       [8] Moeda do Documento                               ³±±
±±³          ³       [9] Taxa da Moeda                                    ³±±
±±³          ³      [10] Data de Emissao do Documento                     ³±±
±±³          ³      [11] Grupo de Compras                                 ³±±
±±³          ³ ExpD1 = Data de referencia para o saldo                    ³±±
±±³          ³ ExpN1 = Operacao a ser executada                           ³±±
±±³          ³       1 = Inclusao do documento                            ³±±
±±³          ³       2 = Estorno do documento                             ³±±
±±³          ³       3 = Exclusao do documento                            ³±±
±±³          ³       4 = Aprovacao do documento                           ³±±
±±³          ³       5 = Estorno da Aprovacao                             ³±±
±±³          ³       6 = Bloqueio Manual da Aprovacao                     ³±±
±±³          ³ ExpC1 = Observacao                						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MaAlcDoc(_cFilial,aDocto,dDataRef,nOper, lTimeOut, cObs)
	Local cDocto	:= aDocto[1]
	Local cTipoDoc	:= aDocto[2]
	Local nValDcto	:= aDocto[3]
	Local cAprov	:= If(aDocto[4]==Nil,"",aDocto[4])
	Local cUsuario	:= If(aDocto[5]==Nil,"",aDocto[5])
	Local nMoeDcto	:= If(Len(aDocto)>7,If(aDocto[8]==Nil, 1,aDocto[8]),1)
	Local nTxMoeda	:= If(Len(aDocto)>8,If(aDocto[9]==Nil, 0,aDocto[9]),0)
	Local aArea		:= GetArea()
	Local aAreaSCS  := SCS->(GetArea())
	Local aAreaSCR  := SCR->(GetArea())
	Local nSaldo	:= 0
	Local cGrupo	:= If(aDocto[6]==Nil,"",aDocto[6])
	Local lFirstNiv:= .T.
	Local cAuxNivel:= ""
	Local cNextNiv := ""
	Local lAchou	:= .F.
	Local nRec		:= 0
	Local lRetorno	:= .T.
	Local aSaldo	:= {}
	dDataRef 	:= dDataBase
	cDocto 		:= cDocto+Space(Len(SCR->CR_NUM)-Len(cDocto))
	lTimeOut	:= IF(lTimeOut==Nil, .F. , lTimeOut)

	CHKFile("SAK")
	CHKFile("SC7")
	CHKFile("SC1")
	CHKFile("SCR")
	CHKFile("SCS")
	CHKFile("SAL")
			
	If Empty(cUsuario) .And. (nOper != 1 .And. nOper != 6) //nao e inclusao ou estorno de liberacao
		dbSelectArea("SAK")
		dbSetOrder(1)
		dbSeek(xFilial()+cAprov)
		cUsuario :=	AK_USER
		nMoeDcto :=	AK_MOEDA
		nTxMoeda	:=	0
	EndIf
	If nOper == 1  //Inclusao do Documento
		cGrupo := If(!Empty(aDocto[6]),aDocto[6],cGrupo)
		dbSelectArea("SAL")
		dbSetOrder(2)
		If !Empty(cGrupo) .And. dbSeek(xFilial()+cGrupo)
			While !Eof() .And. xFilial("SAL")+cGrupo == AL_FILIAL+AL_COD
				If lFirstNiv
					cAuxNivel := SAL->AL_NIVEL
					lFirstNiv := .F.
				EndIf
				Reclock("SCR",.T.)
				SCR->CR_FILIAL	:= xFilial("SCR")
				SCR->CR_NUM		:= cDocto
				SCR->CR_TIPO	:= cTipoDoc
				SCR->CR_NIVEL	:= SAL->AL_NIVEL
				SCR->CR_USER	:= SAL->AL_USER
				SCR->CR_APROV	:= SAL->AL_APROV
				SCR->CR_STATUS	:= IIF(SAL->AL_NIVEL == cAuxNivel,"02","01")
				SCR->CR_TOTAL	:= nValDcto
				SCR->CR_EMISSAO := aDocto[10]
		   		SCR->CR_MOEDA	:=	nMoeDcto
		    	SCR->CR_TXMOEDA := nTxMoeda
				MsUnlock()
				dbSelectArea("SAL")
				dbSkip()
			EndDo
		EndIf
		lRetorno := lFirstNiv
	EndIf
	
	If nOper == 3  //exclusao do documento
		dbSelectArea("SAK")
		dbSetOrder(1)

		dbSelectArea("SCR")
		dbSetOrder(1)
		dbSeek(xFilial("SCR")+cTipoDoc+cDocto)
		While !Eof() .And. SCR->CR_FILIAL+SCR->CR_TIPO+SCR->CR_NUM == xFilial("SCR")+cTipoDoc+cDocto
			If SCR->CR_STATUS == "03"
				dbSelectArea("SAL")
				dbSetOrder(3)
				dbSeek(xFilial()+cGrupo+SAK->AK_COD)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Reposiciona o usuario aprovador.               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			EndIf

			dbSelectArea("SCR")
			Reclock("SCR",.F.,.T.)
			dbDelete()
			MsUnlock()
			dbSkip()
		EndDo
	EndIf
	
	If nOper == 4 //Aprovacao do documento
	
		U_CONSOLE(" 4 -Aprovacao ")
		U_CONSOLE("cFilial     :"+cFilial)
		U_CONSOLE("xFilial(SCR):"+xFilial("SCR"))
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o saldo do aprovador.                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SAK")
		dbSetOrder(1)
		dbSeek(xFilial()+cAprov)
		
		dbSelectArea("SAL")
		dbSetOrder(3)
		dbSeek(xFilial()+cGrupo+cAprov)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Libera o pedido pelo aprovador.                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SCR")
		cAuxNivel := CR_NIVEL

		U_CONSOLE(" 4 -Aprovacao - CR STATUS = 03")
		
		Reclock("SCR",.F.)
		CR_STATUS	:= "03"
		CR_OBS		:= If(Len(aDocto)>10,aDocto[11],"")
		CR_DATALIB	:= dDataBase
		CR_USERLIB	:= SAK->AK_USER
		CR_LIBAPRO	:= SAK->AK_COD
		CR_VALLIB	:= nValDcto
		CR_TIPOLIM	:= SAK->AK_TIPO
		CR_DTLIMIT  := CTOD("  /  /  ")
		CR_HRLIMIT  := "     "
    	SCR->CR_OBS := cObs
		MsUnlock()
		
		dbSelectArea("SCR")
		dbSetOrder(1)
		dbSeek(_cFilial+cTipoDoc+cDocto+cAuxNivel)
		U_CONSOLE("Filial: ["+ _cFilial+"]")      
		U_CONSOLE("cTipoDoc: ["+cTipoDoc +"]")      
		U_CONSOLE("cDocto: ["+cDocto +"]")      
		U_CONSOLE("cAuxNivel: ["+ cAuxNivel+"]")  
		U_CONSOLE("Seek SCR: "+Iif(dbSeek(cFilAnt+cTipoDoc+cDocto+cAuxNivel),".t.",".f."))  
		    
		nRec := SCR->(RecNo())
		While !Eof() .And. cFilAnt+cDocto+cTipoDoc == CR_FILIAL+CR_NUM+CR_TIPO
			If cAuxNivel == CR_NIVEL .And. CR_STATUS != "03" .And. SAL->AL_TPLIBER$"U "
				Exit
			EndIf
			If cAuxNivel == CR_NIVEL .And. CR_STATUS != "03" .And. SAL->AL_TPLIBER$"NP"
				Reclock("SCR",.F.)
				CR_STATUS	:= "05"
				CR_DATALIB	:= dDataBase
				CR_USERLIB	:= SAK->AK_USER
				CR_APROV	:= cAprov
				MsUnlock()
				
			EndIf

			If CR_NIVEL > cAuxNivel .And. CR_STATUS != "03" .And. !lAchou
				lAchou 	:= .T.
				cNextNiv := CR_NIVEL
			EndIf
			
			If lAchou .And. CR_NIVEL == cNextNiv .And. CR_STATUS != "03"
				Reclock("SCR",.F.)
				CR_STATUS	:= "02"
				IF (SAL->AL_TPLIBER=="P" .AND. !lTimeOut )
					CR_STATUS	:= "05"
					CR_DATALIB	:= dDataBase
					CR_USERLIB	:= SAK->AK_USER
					CR_APROV	:= cAprov
					CR_OBS		:= "Aprovado por " + UsrRetName(SAK->AK_USER)
				ENDIF			
				MsUnlock()
			Endif
			dbSkip()
		EndDo
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Reposiciona e verifica se ja esta totalmente liberado.       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		lRetorno := .T.
		dbSelectArea("SCR")
		dbGoto(nRec)
		While !Eof() .And. cFilAnt+cTipoDoc+cDocto == CR_FILIAL+CR_TIPO+CR_NUM
			If CR_STATUS != "03" .And. CR_STATUS != "05" 
				lRetorno := .F.
			EndIf
			dbSkip()
		EndDo
	EndIf
	
	If nOper == 5  //Estorno da Aprovacao
		cGrupo := If(!Empty(aDocto[6]),aDocto[6],cGrupo)
		dbSelectArea("SAK")
		dbSetOrder(1)
		
		dbSelectArea("SCR")
		dbSetOrder(1)
		dbSeek(xFilial("SCR")+cTipoDoc+cDocto)
		
		nMoeDcto := SCR->CR_MOEDA
		nTxMoeda := SCR->CR_TXMOEDA
		
		While !Eof() .And. SCR->CR_FILIAL+SCR->CR_TIPO+SCR->CR_NUM == cFilAnt+cTipoDoc+cDocto
			If SCR->CR_STATUS == "03"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Reposiciona o usuario aprovador.               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SAK")
				dbSeek(xFilial()+SCR->CR_LIBAPRO)
		
				dbSelectArea("SAL")
				dbSetOrder(3)
				dbSeek(xFilial()+cGrupo+SAK->AK_COD)
			EndIf

			DBSelectArea("SCR")
			Reclock("SCR",.F.,.T.)
			dbDelete()
			MsUnlock()
			dbSkip()
		EndDo               
	
		dbSelectArea("SAL")
		dbSetOrder(2)
		If !Empty(cGrupo) .And. dbSeek(xFilial()+cGrupo)
			While !Eof() .And. xFilial("SAL")+cGrupo == AL_FILIAL+AL_COD
				If lFirstNiv
					cAuxNivel := SAL->AL_NIVEL
					lFirstNiv := .F.
				EndIf
				Reclock("SCR",.T.)
				SCR->CR_FILIAL	:= xFilial("SCR")
				SCR->CR_NUM		:= cDocto
				SCR->CR_TIPO	:= cTipoDoc
				SCR->CR_NIVEL	:= SAL->AL_NIVEL
				SCR->CR_USER	:= SAL->AL_USER
				SCR->CR_APROV	:= SAL->AL_APROV
				SCR->CR_STATUS	:= IIF(SAL->AL_NIVEL == cAuxNivel,"02","01")
				SCR->CR_TOTAL	:= nValDcto
				SCR->CR_EMISSAO:= dDataRef
			   	SCR->CR_MOEDA	:=	nMoeDcto
		    	SCR->CR_TXMOEDA:= nTxMoeda
				MsUnlock()
				dbSelectArea("SAL")
				dbSkip()
			EndDo
		EndIf
		lRetorno := lFirstNiv
	EndIf
	
	If nOper == 6  //Bloqueio manual

		U_CONSOLE("  6  - Bloqueio por " + cAprov)

		dbSelectArea("SAK")
		dbSetOrder(1)
		dbSeek(xFilial()+cAprov)
			
		dbSelectArea("SCR")
		cAuxNivel := CR_NIVEL
		
		Reclock("SCR",.F.)
		CR_STATUS   := "04"
		CR_OBS	   	:= If(Len(aDocto)>10,aDocto[11],"Reprovaçao manual")
		CR_DATALIB  := dDataBase
		CR_USERLIB	:= SAK->AK_USER
		CR_LIBAPRO	:= SAK->AK_COD
		CR_DTLIMIT  := CTOD("  /  /  ")
		CR_HRLIMIT  := "     "
		MsUnlock()

		cNome		:= UsrRetName(SAK->AK_USER)
				
		dbSelectArea("SCR")                       
		dbSetOrder(1)
		dbSeek(xFilial("SCR")+cTipoDoc+cDocto+cAuxNivel)
		      
		nRec := RecNo()
		While !Eof() .And. xFilial("SCR")+cDocto+cTipoDoc == CR_FILIAL+CR_NUM+CR_TIPO
		    U_CONSOLE(" 6 - Bloqueio - LOOP SCR " + CR_FILIAL+CR_NUM+CR_TIPO + CR_NIVEL + CR_STATUS )
		    
			If cAuxNivel == CR_NIVEL .And. CR_STATUS != "04"
				Reclock("SCR",.F.)
				CR_STATUS	:= "05"
				CR_DATALIB	:= dDataBase
				CR_USERLIB	:= SAK->AK_USER
				CR_OBS		:= "Reprovado por " + ALLTRIM(cNome)
				MsUnlock()
			EndIf
			If CR_NIVEL > cAuxNivel .And. CR_STATUS != "04" .And. !lAchou
				lAchou 	:= .T.
				cNextNiv := CR_NIVEL
			EndIf
			If lAchou .And. CR_NIVEL == cNextNiv .And. CR_STATUS != "04"
				Reclock("SCR",.F.)
				CR_STATUS	:= "05"
				CR_DATALIB	:= dDataBase
				CR_USERLIB	:= SAK->AK_USER
				CR_OBS		:= "Reprovado por " + ALLTRIM(cNome)
				MsUnlock()
			Endif
			dbSkip()
		    
		EndDo
		
		lRetorno := .F.
	EndIf
	
	dbSelectArea("SCR")
	RestArea(aAreaSCR)

	dbSelectArea("SCS")
	RestArea(aAreaSCS)
	RestArea(aArea) 
	Return(lRetorno)


//---------------- TESTA SE HÁ CONEXAO COM O SERVIDOR SMTP

User Function SMTPConnect()
	Local  lRet 	   := .F.
	Local  lSmtpAuth   := GetMv("MV_RELAUTH",,.F.)
	Static cMailConta  := NIL
	Static cMailServer := NIL
	Static cMailSenha  := NIL  
	Static cMailCtaAut := NIL
	Static lAvalMMail  := NIL
	Static lAvalFiltr  := NIL
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Obtem dados necessarios a conexao                                                |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMailConta  := If(cMailConta == NIL,GETMV("MV_EMCONTA"),cMailConta)
	cMailServer := If(cMailServer== NIL,GETMV("MV_RELSERV"),cMailServer)
	cMailSenha  := If(cMailSenha == NIL,GETMV("MV_EMSENHA"),cMailSenha)
			
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Se o parametro nao estiver definido pega o parametro dos relatorios              |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty( cMailConta )  
		cMailConta := GETMV("MV_RELFROM",,"")
	EndIf 	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Se o parametro nao estiver definido pega o parametro dos relatorios              |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty( cMailSenha )  
		cMailSenha := GETMV("MV_RELPSW")
	EndIf 	
			
	cMailCtaAut := If(cMailCtaAut == NIL,GETMV("MV_RELACNT"),cMailCtaAut)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Caso nao exista conta definida, pega o proprio e-mail origem                       |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty( cMailCtaAut ) 
		cMailCtaAut := cMailConta
	EndIf 		
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Envia e-mail com os dados necessarios                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(cMailServer) .And. !Empty(cMailConta) .And. !Empty(cMailSenha) .And. !Empty(cMailCtaAut) 
				
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| Conecta uma vez com o servidor de e-mails                                        |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		CONNECT SMTP SERVER cMailServer ACCOUNT cMailCtaAut PASSWORD cMailSenha RESULT lOk
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| Se configurado, efetua a autenticacao                                            |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ( lSmtpAuth ) 
			lAutOk := MailAuth(cMailCtaAut,cMailSenha)
		Else
			lAutOk := .T.
		EndIf 
				
		If lOk .And. lAutOk 
			DISCONNECT SMTP SERVER
			lRet := .T.
		EndIf
	EndIf
	RETURN lRet
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONSOLE   ºAutor  ³Microsiga           º Data ³  Ago/2006   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³
±±º          ³
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Console(_ctxt)
	local _ctxt
	if _ctxt == NIL
		_ctxt := 'nulo'
	endif
	CONOUT(_cTXT)
	nHdl2:= FOPEN("conout.log",2)
	IIF(nHdl2 > 0,,nHdl2:=MSFCREATE("conout.log",0))
	fseek(nHdl2,0,2)
	_cLogBody := ''
	_cLogBody += DTOC(DATE()) +" @ "+ TIME() +" "+ _cTxt + chr(13) + chr(10)
	Fwrite(nHdl2,_cLogBody,len(_cLogBody))
	_cLogBody := replicate('-',80) + chr(13) + chr(10)
	Fwrite(nHdl2,_cLogBody,len(_cLogBody))
	FCLOSE(nHdl2)
	Return
	
	