#INCLUDE "PROTHEUS.CH"
#DEFINE INCLUIR 1
#DEFINE ALTERAR 2
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RFISC001  ³ Autor ³ROBSON BUENO           ³ Data ³03-09-08  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Preparacao do meio-magnetico para o Sintegra - CONV 69/02   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFISC001()

Local aAreaMt940:= GetArea()
Local cTitulo	:="SINTEGRA"
Local cText1	:="Esta rotina tem como objetivo gerar o arquivo pre-formatado no formato do "
Local cText2	:="Convenio ICMS 69/02, conforme os parametros solicitados. "
Local cText3    := ""
Local cNorma    := ""
Local cDest     := ""
Local cDir      := ""
Local cPerg		:= "MTA940"
Local nOpcA		:= 0
Local aSays		:= {}
Local aButtons	:= {}
Local oDlg
Local nOpc	  	:=1	
Local cTpFrete  := "1"


Private cFilA940  :=""
Private _aTotal[100]
Private aReturn :=	{"Zebrado", 1,"Administra‡„o", 2, 2, 1, "",1 } //###

AJUSTASX1 ()
Pergunte(cPerg,.F.)

While .T.

	AADD(aSays,OemToAnsi( cText1 ) )
	AADD(aSays,OemToAnsi( cText2 ) )
	AADD(aButtons, {17,.T.,{|| RF001Fl(nOpc,@cFilA940,"SF3") } } )
	AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}} )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
	AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
	FormBatch( cTitulo, aSays, aButtons )
       
	Do Case
	   Case nOpca ==1
  	 	    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Preparacao do inicio de processamento do arquivo pre-formatado          ³
		  	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cNorma := AllTrim(MV_PAR03)+".INI"
			cDest  := AllTrim(MV_PAR04)
			cDir   := Alltrim(MV_PAR13)

			Processa({||U_PrHcma(cNorma,cDest,cDir)})

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Reabre os Arquivos do Modulo desprezando os abertos pela Normativa      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbCloseAll()
			OpenFile(SubStr(cNumEmp,1,2))
	   Case nOpca==3
			Pergunte(cPerg,.t.)
			Loop
	EndCase
	Exit
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura area                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea(aAreaMt940)

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³hcsinteg  ³ Autor ³ Robson Bueno          ³ Data ³03.08.2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Processamento dos documentos fiscais - CONV 69/02           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER Function hcsint(dDtIni,dDtFim,cNrLivro,cEstDest,nListEst,lReg88,cArqMag,cFilA940,lValidaPr)

Local aAreaSint := GetArea()
Local lListEst  := IIF(nListEst==1,.T.,.F.)
Local lQuery    := .F.
Local lValido   := .T.
Local lFirst    := .T.
Local lCupom    := .T.	
Local nItem     := 0
Local nX        := 0
Local nI        := 0
Local nAliqICM  := 0
Local nPosAliq  := 0
Local nAliqIte  := 0
Local nBRetido  := 0
Local nRedBase  := 0
Local cSitTrib  := ""
Local cSeek     := ""
Local cCNPJ     := "" 
Local cCNPJOri	:= ""
Local cIE       := ""
Local cTranspCGC:= ""
Local cTranspIns:= ""
Local cTranspOri:= ""
Local cAliasSD1 := "SD1"
Local cAliasSD2 := "SD2"
Local cAliasSF1 := "SF1"
Local cAliasSF2 := "SF2"
Local cAliasSF3 := "SF3"
Local cAliasSF6 := "SF6"
Local cAliasSFI := "SFI"
Local cAliasDT6 := "DT6"
Local cTranspEst:=	""
Local cChave    := ""
Local cChaveAux := ""
Local cChaveAux2:= ""
Local cCfoAux	:= ""
Local cQuery    := ""
Local cNcm      := ""
Local cProd     := ""
Local cCpVlPisEn:= ""
Local cCpVlPisSa:= ""
Local aArray71  := ""
Local nValPis   := 0
Local nPsVlPisEn:= 0
Local nPsVlPisSa:= 0
Local nValCof   := 0
Local aArrayF3  := {}
Local aStruSF3  := {}
Local cSintegra := GetNewPar("MV_SINTEG","")
Local cCfoSint  := ""   
Local lMtaTIP71 := ExistBlock("MTATIP71")
Local lMt940fil := ExistBlock("MT940FIL")
Local cD1_Di    := GetNewPar("MV_DI","") 
Local cD1_DtDi  := GetNewPar("MV_DTDI","")
Local cDi 		:= ""
Local dDtdi     := ""
Local cRazSoc	:= ""
Local lSef		:= .F.
Local lSintegMG	:= .F.
Local lSintegMS	:= .F.
Local nR50Obs	:= 0
Local lConv76	:= .F.	//Aplica Convenio no.76
Local lReg61I	:= .F.	//Gera Registro 61I (Convenio 76)
Local lNfProd	:= .F.	//Gera NF Produtor - Mod. 4 (Convenio 76)
Local nVlaTot	:= 0
Local lMta56S	:= ExistBlock("MTA56S")
Local lMta56E	:= ExistBlock("MTA56E")
Local lMta8586	:= ExistBlock("MTA8586")
Local cCfopPR	:= GetNewPar("MV_CFOPPR","")
Local lImpSt	:= GetNewPar("MV_IMPST",.F.)
Local lTareDf	:=	.F.
Local l52Tare	:=	.T.
Local lCompTare	:= .T.
Local aTrbs		:=	{}
Local lCompIcms	:=	.F.	//Complemento de ICMS
Local lGnre		:= GetNewPar("MV_GNRE",.F.)
Local dDataGnre	:=	CTOD("//")
Local nY		:= 0
Local lObs		:= .F.
Local cObs		:= ""
Local aProdepe	:= {}
Local lIntegra  := Iif(GetNewPar("MV_EASY","") == "S",.T.,.F.)
Local lSigaEEC	:= GetNewPar("MV_EECFAT",.F.)
Local lTrading	:= Iif(GetNewPar("MV_TRADING","N") == "S",.T.,.F.)
Local lServico	:= .F.	//Verifica se o item eh um Servico
Local cNumFab	:=	Space (20)
Local cCompExp	:= GetNewPar("MV_COMPEXP","")
Local cDCmpExp	:= GetNewPar("MV_DCMPEXP","")
Local cSeqIns	:= ""
Local cInscr	:= ""         
Local cInscrDest:= ""
Local cDescObs	:= Upper(Alltrim(GetNewPar("MV_DESCOBS","")))		//Desconsidera Observacoes - SEF
Local cFuncep	:= ""
Local lGimPB	:= .F.
Local lGera75S	:=	.T.
Local lMtReg71 := Existblock("MTREG71")
Local nPos 		:= 0
Local nBsICMS	:= 0       
Local cModNF	:=	""
Local cSeekDTC	:= ""
Local lAglR54	:=	GetNewPar ("MV_AGLR54", .F.)
Local lAglutinou := .F.
Local cR51CFOP	:= GetNewPar("MV_R51CFOP","")
Local cContrTare:=	"2"
Local cFilDe	:=	MV_PAR25
Local cFilAte	:=	MV_PAR26
Local lConsUF	:= 	MV_PAR27==1
Local cMV_ESTADO:= 	SuperGetMv ("MV_ESTADO")
Local aAreaSm0	:=	SM0->(GetArea ())

#IFDEF TOP
	Local nSFI := 0
	Local nDT6 := 0
#ENDIF	

Default lReg88  	:= .F.
Default cArqMag		:= ""
Default cFilA940	:= ""
Default lValidaPr 	:= .F.

Private aRetCfp := {}

If (Empty (MV_PAR25) .And. Empty (MV_PAR26))
	cFilDe	:=	cFilAte	:=	cFilAnt
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Selecao do arquivo SFI por demanda                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SFI")
dbGoTop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se foi passado o parametro cArqMag (Arquivo Magnetico)         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(cArqMag)
	Do Case
		Case Upper(Alltrim(cArqMag)) == "SEF"		//SEF de Pernambuco
			lSef		:= .T.
			aRetCfp		:= RetCfp()
			_aTotal[02]	:= aRetCfp[1][1]
		Case Upper(Alltrim(cArqMag)) == "SINTEGMG" .Or. Upper(Alltrim(cArqMag)) == "SINTMG" //Sintegra de Minas Gerais - Registro 88A
			If SF3->(FieldPos("F3_NFEMP")) > 0
				lSintegMG := .T.
			Endif                                                                            
		Case Upper(Alltrim(cArqMag)) == "CONV76"	//Novo Convenio 76/03
			lConv76	:= IIf(Year(mv_par01)>2003.And.Year(mv_par02)>2003,.T.,.F.)
			lReg61I	:= IIf(mv_par17==2.And.lConv76,.T.,.F.)	//Gera Registro 61I (Convenio 76)
			lNfProd	:= IIf(mv_par18==2.And.lConv76,.T.,.F.)	//Gera NF Produtor - Mod. 4 (Convenio 76)
		Case Upper(Alltrim(cArqMag)) == "TAREDF"	//CAT 384/01 - TARE - DF
			lTareDf	:=	.T.
		Case Upper(Alltrim(cArqMag)) == "GIMPB" 	// GIM Paraiba
			lGimPB	:= .T.
		Case Upper(Alltrim(cArqMag)) == "SINTEGMS" 	// Sintegra de Mato Grosso do Sul
			lSintegMS	:= .T.
	EndCase
Endif

If Empty(cSintegra)
    cCfoSint := "173/273/174/274/191/291/391/192/292/197/297/397/198/298/591/691/592/692/595/695"
    cCfoSint += "1406/2406/1407/2407/1551/1556/2551/2556/3551/3556/1552/1557/2552/2557/5551/6551/7551"
	cCfoSint += "5552/5557/6552/6557/5553/5556/6553/6556/7553/7556"   
Else
    cCfoSint :=cSintegra
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Funcao utilizada para montar os trbs e retornar array com os arquivos abertos.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTrbs	:=	CriaTrbs (lReg88)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processo as Filiais³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea ("SM0")
	SM0->(DbSeek (cEmpAnt+cFilDe, .T.))
Do While !SM0->(Eof ()) .And. (SM0->M0_CODIGO==cEmpAnt) .And. (SM0->M0_CODFIL<=cFilAte)
	cFilAnt	:= SM0->M0_CODFIL
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atendimento ao Art. 121 do ANEXO 5 do RICMS/SC. O mesmo determina que todo prestador de                    ³
	//³  serviço de transporte deve apresentar as obrigações acessórias de forma consolidada pelo estabelecimento ³
	//³  matriz, e esta consolidação deverá abranger somente as empresas que estiverem domiciliadas no mesmo      ³
	//³  estado do estabelecimento consolidador.                                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lConsUF .And. (SM0->M0_ESTENT<>cMV_ESTADO)
		SM0->(DbSkip ())
		Loop
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Processamento dos documentos Fiscais                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SF3")
	dbSetOrder(1)
	ProcRegua(LastRec())
	#IFDEF TOP
	    If TcSrvType()<>"AS/400"
		    lQuery := .T.
			cAliasSF3 := "SF3_SINTEGRA"
			aStruSF3  := SF3->(dbStruct())
			cQuery := "SELECT * "
			cQuery += "FROM "+RetSqlName("SF3")+" "
			cQuery += "WHERE F3_FILIAL='"+xFilial("SF3")+"' AND "
			cQuery += "F3_ENTRADA>='"+Dtos(dDtIni)+"' AND "
			cQuery += "F3_ENTRADA<='"+Dtos(dDtFim)+"' AND "	
			cQuery += "F3_CFO NOT LIKE '000%' AND F3_CFO NOT LIKE '999%' AND "
			If cNrLivro <> "*"
				cQuery += "F3_NRLIVRO ='"+ cNrLivro +"' AND "
			EndIf	
			If !Empty(cEstDest)
				If lListEst
					cQuery += "F3_ESTADO ='"+ cEstDest+"' AND "
				Else
					cQuery += "F3_ESTADO <>'"+ cEstDest+"' AND "
				EndIf
			EndIf			
			If (MV_PAR21==1)
				If mv_par11 == 1 	//Entrada
					cQuery	+=	"(F3_CFO LIKE '2%') AND F3_ICMSRET>0 AND "
				Elseif mv_par11 == 2 				//Saida
					cQuery	+=	"(F3_CFO LIKE '6%') AND F3_ICMSRET>0 AND "
				Else
					cQuery	+=	"(F3_CFO LIKE '2%' OR F3_CFO LIKE '6%') AND F3_ICMSRET>0 AND "
				Endif
			ElseIf (MV_PAR21==2)
				If mv_par11 == 1 	//Entrada
					cQuery	+=	"(F3_CFO LIKE '2%') AND "
				Elseif mv_par11 == 2 				//Saida
					cQuery	+=	"(F3_CFO LIKE '6%') AND "
				Else
					cQuery	+=	"(F3_CFO LIKE '2%' OR F3_CFO LIKE '6%') AND "
				Endif
			ElseIf (MV_PAR21==3)
				If mv_par11 == 1 	//Entrada
					cQuery	+=	"(F3_CFO LIKE '1%' OR F3_CFO LIKE '2%' OR F3_CFO LIKE '3%') AND "
				Elseif mv_par11 == 2 				//Saida
					cQuery	+=	"(F3_CFO LIKE '5%' OR F3_CFO LIKE '6%' OR F3_CFO LIKE '7%') AND "
				Endif
			EndIf		
			cQuery += "F3_TIPO NOT IN('S') AND "
			If mv_par05 == 4
				cQuery += "F3_TIPO = 'D' AND "
				cQuery += "F3_CFO < '5' AND "
			Endif
			If (lTareDf)
		 	    cQuery += " (((F3_CFO LIKE '1%' OR F3_CFO LIKE '2%' OR F3_CFO LIKE '3%') AND F3_TIPO = 'D') OR (F3_CFO LIKE '5%' OR F3_CFO LIKE '6%' OR F3_CFO LIKE '7%')) AND F3_DTCANC='' AND "
		    EndIf		
	
			//Implementacao NFE-BA		
			If !Empty(MV_PAR23) .And. !Empty(MV_PAR24)
				cQuery	+=	"(F3_NFISCAL>='"+MV_PAR23+"' AND F3_NFISCAL<='"+MV_PAR24+"') AND "
	    	Endif
	
	        //Implementação Sintegra - MS (CFOP´S referente a Transporte de Carga sem obrigatoriedade de Nota Fiscal)
	        If lSintegMS
	        	cQuery	+=	"(F3_CFO<>'5359' AND F3_CFO<>'6359') AND "
	        Endif
	
			cQuery += "D_E_L_E_T_ = ' ' "
			cQuery += "ORDER BY "+SqlOrder(SF3->(IndexKey()))
		
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSF3)
		
			For nX := 1 To len(aStruSF3)
				If aStruSF3[nX][2] <> "C" .And. FieldPos(aStruSF3[nX][1])<>0
					TcSetField(cAliasSF3,aStruSF3[nX][1],aStruSF3[nX][2],aStruSF3[nX][3],aStruSF3[nX][4])
				EndIf
			Next nX
			dbSelectArea(cAliasSF3)	
		Else
	#ENDIF
		    cIndex    := CriaTrab(NIL,.F.)
		    cCondicao := 'F3_FILIAL=="'+xFilial("SF3")+'".And.'
		   	cCondicao += 'DTOS(F3_ENTRADA)>="'+DTOS(dDtIni)+'".And.DTOS(F3_ENTRADA)<="'+DTOS(dDtFim)+'" '
			cCondicao += '.And. !Substr(F3_CFO,1,3)$"999/000" '
		    If cNrLivro <> "*"
			    cCondicao += '.And.F3_NRLIVRO ="'+ cNrLivro +'" '
		   	EndIf	
		    If !Empty(cEstDest)
			    If lListEst
				    cCondicao += '.And. F3_ESTADO ="'+ cEstDest+'" '
		  		Else                                                                   
				    cCondicao += '.And. F3_ESTADO <> "'+ cEstDest+'" '
			    EndIf
		    EndIf			
			If (MV_PAR21==1)
				If mv_par11 == 1 	//Entrada
					cCondicao	+=	'.And. SubStr(F3_CFO,1,1)$"2" .And. F3_ICMSRET>0 '
				Elseif mv_par11 == 2 				//Saida
					cCondicao	+=	'.And. SubStr(F3_CFO,1,1)$"6" .And. F3_ICMSRET>0 '
				Else
					cCondicao	+=	'.And. SubStr(F3_CFO,1,1)$"6,2" .And. F3_ICMSRET>0 '
				Endif
			ElseIf (MV_PAR21==2)
				If mv_par11 == 1 	//Entrada
					cCondicao	+=	'.And. SubStr(F3_CFO,1,1)$"2" '
				Elseif mv_par11 == 2 				//Saida
					cCondicao	+=	'.And. SubStr(F3_CFO,1,1)$"6" '
				Else
					cCondicao	+=	'.And. SubStr(F3_CFO,1,1)$"6,2" '
				Endif
			ElseIf (MV_PAR21==3)
				If mv_par11 == 1 	//Entrada
					cCondicao	+=	'.And. SubStr(F3_CFO,1,1)$"1,2,3"'
				Elseif mv_par11 == 2 				//Saida
					cCondicao	+=	'.And. SubStr(F3_CFO,1,1)$"5,6,7"'
				Endif
			EndIf
		    cCondicao += '.And. F3_TIPO <> "S" '
		    If mv_par05 == 4
		 	    cCondicao += '.And. F3_TIPO = "D" '
			    cCondicao += '.And. Substr(F3_CFO,1,1) < "5" '
		    Endif
		    If (lTareDf)
		 	    cCondicao += '.And. ((SubStr (F3_CFO,1,1)$"1,2,3" .And. F3_TIPO = "D") .Or. SubStr (F3_CFO,1,1)$"5,6,7") .And. Empty(F3_DTCANC) '
		    EndIf
	
			//Implementacao NFE-BA
			If !Empty(MV_PAR23) .And. !Empty(MV_PAR24)
				cCondicao += '.And. (F3_NFISCAL>="'+MV_PAR23+'" .And. F3_NFISCAL<="'+MV_PAR24+'")'
	    	Endif
	
	        //Implementação Sintegra - MS (CFOP´S referente a Transporte de Carga sem obrigatoriedade de Nota Fiscal)
	        If lSintegMS
	        	cCondicao	+=	' .And. !Substr(F3_CFO,1,4)$"5359/6359" '
	        Endif
	        
		    IndRegua(cAliasSF3,cIndex,SF3->(IndexKey()),,cCondicao)
		    nIndex := RetIndex("SF3")
			#IFNDEF TOP
				dbSetIndex(cIndex+OrdBagExt())
			#ENDIF
			dbSelectArea("SF3")
		    dbSetOrder(nIndex+1)
		
		    dbSelectArea(cAliasSF3)
		    ProcRegua(LastRec())
		    dbGoTop()
	#IFDEF TOP
		Endif    
	#ENDIF
	
	If Empty(cFilA940)
		bFiltro := { || .T. }
	Else
		cFilA940 := "{ || " + cFilA940 + " }"
		bFiltro := &(cFilA940)
	Endif
	While (cAliasSF3)->(!Eof()) 
	
		IncProc("Preparando Base de Dados 1/3") //
	    
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica filtro	³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If	! Eval(bFiltro) 
			dbSkip()
			Loop
		EndIf
		//
		l52Tare	:=	.F.
		If (lTareDf) .And. (Val (Left ((cAliasSF3)->F3_CFO, 1))<5 .And. "D"$AllTrim ((cAliasSF3)->F3_TIPO))
			l52Tare	:=	.T.
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica a transportadora ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(mv_par14) .And. SubStr((cAliasSF3)->F3_CFO,1,1) >= "5"
			If SF2->( MsSeek(F3Filial("SF2",cAliasSF3)+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA))
			    If SF2->F2_TRANSP <> mv_par14
			    	(cAliasSF3)->(dbSkip())
			    	Loop
			    Endif
			Endif
		Endif	
	
		If lMt940Fil
			If !Execblock("MT940FIL" ,.f.,.f.)
		    	(cAliasSF3)->(dbSkip())
		    	Loop
			Endif                                 
		Endif
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cliente/fornecedor                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (SubStr((cAliasSF3)->F3_CFO,1,1)>="5" .And. (cAliasSF3)->F3_TIPO$"BD") .Or.;
		   (SubStr((cAliasSF3)->F3_CFO,1,1)<"5" .And. !(cAliasSF3)->F3_TIPO$"BD")
			
			dbSelectArea("SA2")
			dbSetOrder(1)
			MsSeek(F3Filial("SA2",cAliasSF3)+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA)				
			cRazSoc		:=	SA2->A2_NOME
			cCNPJ 		:=	A940CNPJ(SA2->A2_CGC,SA2->A2_TIPO, lTareDf)
			cCNPJOri	:=	SA2->A2_CGC
			cIE   := A940IE(SA2->A2_INSCR)
			cTranspCGC	:=	AFISFILL (Num2Chr (Val (SA2->A2_CGC), 14, 0), 14)
			cTranspIns	:=	aRETDIG(SA2->A2_INSCR,.t.,(cAliasSF3)->F3_ESTADO)
			cTranspEst	:=	SA2->A2_EST
			cTranspOri	:=	SA2->A2_CGC
			If (SA2->(FieldPos ("A2_CTARE"))>0)
				cContrTare	:=	SA2->(FieldGet (FieldPos ("A2_CTARE")))
			EndIf
		Else
			dbSelectArea("SA1")
			dbSetOrder(1)				
			MsSeek(F3Filial("SA1",cAliasSF3)+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA)
			cRazSoc		:=	SA1->A1_NOME		
			cCNPJ 		:=	A940CNPJ(SA1->A1_CGC,SA1->A1_TIPO, lTareDf)
			cCNPJOri	:=	SA1->A1_CGC
			cIE   := A940IE(SA1->A1_INSCR)
			cTranspCGC	:=	AFISFILL (Num2Chr (Val (SA1->A1_CGC), 14, 0), 14)
			cTranspIns	:=	aRETDIG(SA1->A1_INSCR,.t.,(cAliasSF3)->F3_ESTADO)
			cTranspEst	:=	SA1->A1_EST
			cTranspOri	:=	SA1->A1_CGC
			If (SA1->(FieldPos ("A1_CTARE"))>0)
				cContrTare	:=	SA1->(FieldGet (FieldPos ("A1_CTARE")))
			EndIf
		EndIf
	
		dbSelectArea(cAliasSF3)
		cChave := (cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA
		Aadd(aArrayF3, {(cAliasSF3)->F3_NFISCAL	,;	//01
		(cAliasSF3)->F3_SERIE		,;	//02
		(cAliasSF3)->F3_CLIEFOR		,;	//03
		(cAliasSF3)->F3_LOJA		,;	//04
		(cAliasSF3)->F3_CFO			,;	//05
		(cAliasSF3)->F3_TIPO		,;	//06
		(cAliasSF3)->F3_ESPECIE		,;	//07
		(cAliasSF3)->F3_ALIQICM		,;	//08
		(cAliasSF3)->F3_PDV			,;	//09
		(cAliasSF3)->F3_ENTRADA		,;	//10
		(cAliasSF3)->F3_ICMSRET		,;	//11
		(cAliasSF3)->F3_ISENICM		,;	//12
		(cAliasSF3)->F3_DTCANC		,;	//13
		(cAliasSF3)->F3_CODISS		,;	//14
		(cAliasSF3)->F3_OUTRICM		,;	//15
		(cAliasSF3)->F3_VALICM		,;	//16
		(cAliasSF3)->F3_VALCONT		,;	//17
		(cAliasSF3)->F3_EMISSAO		,;	//18
		(cAliasSF3)->F3_BASEICM		,;	//19
		(cAliasSF3)->F3_OBSERV		,;	//20
		(cAliasSF3)->F3_FORMUL		,;	//21
		(cAliasSF3)->F3_ESTADO		,;	//22
		(cAliasSF3)->F3_DESPESA		,;	//23
		(cAliasSF3)->F3_FORMULA		,;	//24
		(cAliasSF3)->F3_VALIPI		,;	//25
		(cAliasSF3)->F3_ISENIPI		,;	//26
		(cAliasSF3)->F3_OUTRIPI		,;	//27
		(cAliasSF3)->F3_BASEIPI		,;	//28
		(cAliasSF3)->F3_BASERET		,;	//29
		(cAliasSF3)->F3_IPIOBS		,;	//30
		(cAliasSF3)->F3_NRLIVRO})		//31
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Implementacao do Sintegra MG - Registro 88A       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lSintegMG
			Aadd(aArrayF3[Len(aArrayF3)],(cAliasSF3)->F3_NFEMP)	//Nota de Empenho
		Endif
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Executa funcoes do arquivo magnetico                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lSef					//SEF de Pernambuco
			Sef("1",cAliasSF3)	//Executa a SEF DURANTE o While do SF3
		Endif
		dbSkip()
		
		If cChave <> (cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Monta Registro Tipo 54 e Registro Tipo 75 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF aModNot(aArrayF3[1][7])=="55" 
			  aArrayF3[1][7]="KKK"
			endif
			If (Empty(aArrayF3[1][7]) .Or. AModNot(aArrayF3[1][7]) $ "01/02/06/04/21/22") .And. (Empty(cCfopPR) .Or. !(Alltrim(aArrayF3[1][5])$cCfopPR))
				If substr(aArrayF3[1][5],1,1)<"5" .And. AModNot(aArrayF3[1][7])$"01/06/21/22" .And. aArrayF3[1][6] <> "L"
				    SF1->( dbSetOrder(1) )
					SF1->( MsSeek(F3Filial("SF1",cAliasSF3)+aArrayF3[1][1]+aArrayF3[1][2]+aArrayF3[1][3]+aArrayF3[1][4]))
	
					lCompTare	:=	Iif (lTareDf .And. AllTrim (SF1->F1_TIPO)$"CIP", .F., .T.)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Registro adicional para Frete,Seguro e Outras Despesas       ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If SF1->(!Eof()) 
						For nI := 1 to 5
							// Somente gera o item 993 quando o contribuinte destacar PIS/COFINS na nota fiscal - Sintegra
							If nI == 4 .And. mv_par22 <> 1 .And. !lGimPB
								Loop
							Endif
							If nI == 4
								aRelImp	   := MaFisRelImp("MT100",{ "SF1" })
								nPsVlPisEn := 0
								nValPis    := 0
								nValCof    := 0
								If !Empty( nScanPis := aScan(aRelImp,{|x| x[1]=="SF1" .And. x[3]=="NF_VALPS2"} ) )
									cCpVlPisEn := aRelImp[nScanPis,2]
									nPsVlPisEn := SF1->(FieldPos(cCpVlPisEn))
								EndIf 	
								If !Empty( nPsVlPisEn ) 
									nValPis := SF1->( FieldGet( nPsVlPisEn ) )
								EndIf
								If !Empty( nScanCof := aScan(aRelImp,{|x| x[1]=="SF1" .And. x[3]=="NF_VALCF2"} ) )
									If !Empty(SF1->(FieldPos(aRelImp[nScanCof,2])))
										nValCof := SF1->(FieldGet(SF1->(FieldPos(aRelImp[nScanCof,2]) ) ) )
									EndIf
								EndIf
							Endif
							If (nI == 9999 .And. SF1->F1_FRETE > 0) .Or.;
							   (nI == 9999 .And. SF1->F1_SEGURO > 0) .Or.;
							   (nI == 9999 .And. SF1->F1_DESPESA > 0) .Or.;
							   (nI == 9999 .And. nValPis+nValCof > 0) .Or.;
							   (nI == 9999 .And. SF1->F1_TIPO $ "CIP")
								dbSelectArea("R54")
					        	If ! ALLTRIM(aArrayF3[1][5]) $ cCfoSint
								   If !MsSeek(cCNPJ+aArrayF3[1][2]+aArrayF3[1][1]+IIf(nI==1,"991",If(nI==2,"992",If(nI==3,"999",If(nI==4,"993","997")))))
									  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									  //³ Somente SEF - Grava na Entrada Reg. 54 Modelos 01,06,21 e 22 ³
									  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									  If lSef .And. AModNot(aArrayF3[1][7])$"01/06/21/22" .Or. ;
										!lSef .And. AModNot(aArrayF3[1][7])=="01"
										 RecLock("R54",.T.)
										 R54->A54_CTARE	:=	cContrTare
										 R54->A54_CNPJ    := cCNPJ
										 R54->A54_MODELO  := AModNot(aArrayF3[1][7])
										 R54->A54_SERIE   := aArrayF3[1][2]
										 R54->A54_NFISC   := aArrayF3[1][1]
										 R54->A54_CFOP    := aArrayF3[1][5]
										 R54->A54_CST     := CSTCompl (dDtIni, lSef, lValidaPr)
										 R54->A54_NUMITE  := IIf(nI==1,"991",If(nI==2,"992",If(nI==3,"999",If(nI==4,"993","997")))) //Numero do Item (991-Frete;992 -Seguro;999-Outras despesas acessorias;993-PIS/COFINS;997-Compl.Preco/ICMS)
										 R54->A54_QUANT   := IIf(lSef,1,0)
										 R54->A54_CNORI   := cCNPJOri
		
										 If lSef
											// Os itens 991/992/993/998/999 nao devem ser apresentados com CFOP e nem
											// com codigo do produto no registro 54 do SEF.
											If R54->A54_NUMITE $ "991/992/993/998/999"
												R54->A54_CFOP	:= "0000"		 
												If R54->A54_NUMITE == "998"
													R54->A54_PRODUT := ""
												Endif
											Else
												R54->A54_PRODUT  := SefProd54(aArrayF3,cAliasSF3)
												R54->A54_PRORI	:=	SefProd54(aArrayF3,cAliasSF3, 2)
												
												GrvReg75(aArrayF3,cAliasSF3,dDtIni,dDtFim)
											Endif
										 Endif
										
									     //Alteracao efetuada apos consulta na Secretaria RS
									     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									  	 //³REGISTRO ERRO                                                                        ³
									  	 //³                                                                                     ³
									  	 //³PARA OS CODIGOS ESPECIAIS QUANTIDADE (CAMPO 10) E VALOR DO PRODUTO (CAMPO 11)        ³
									  	 //³ DEVEM ESTAR ZERADOS E A INFORMACAO DEVE SER PREENCHIDA NO VALOR DESCONTAO / DESPESA ³
								  	  	 //³ ACESSORIOS (CAMPO 12 ).  REJEICAO                                                   ³
									  	 //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										 If GETMV("MV_ESTADO")=="RS"
	 									     R54->A54_QUANT  := 0
											 R54->A54_VALPRO  := 0
											 R54->A54_VALDES  := IIf(nI==1,SF1->F1_FRETE,If(nI==2,SF1->F1_SEGURO,If(nI==3,SF1->F1_DESPESA,If(nI==4,nValPis+nValCof,SF1->F1_VALBRUT))))
										 Else
										     R54->A54_VALPRO  := IIf(nI==1,SF1->F1_FRETE,If(nI==2,SF1->F1_SEGURO,If(nI==3,SF1->F1_DESPESA,If(nI==4,nValPis+nValCof,SF1->F1_VALBRUT))))
										     R54->A54_VALDES  := R54->A54_VALPRO
										 EndIf
	
										 If lSef
		                                	R54->A54_ALQICM  := aArrayF3[1][8]
										 ElseIf (SF1->F1_TIPO$"CI" .And. lTareDf)
											SD1->(DbSetOrder (1))
										 	SD1->(MsSeek (F3Filial ("SD1")+aArrayF3[1][1]+aArrayF3[1][2]+aArrayF3[1][3]+aArrayF3[1][4]))
		
											R54->A54_ALQICM	:=	SD1->D1_PICM
										 Else
		                                	R54->A54_ALQICM  := IIf(nI==4,aArrayF3[1][8],0)
										 Endif
										
										 //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										 //³ Implementacao do SEF PE                           ³
										 //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										 R54->A54_IE	  	:= 	cIE
										 R54->A54_EMISS 	:= 	SF1->F1_DTDIGIT
										 R54->A54_UF  	:= 	cTranspEst
										
										 //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										 //³ Implementacao do PRODEPE                          ³
										 //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										 If lSef .And. Val(aRetCfp[19][1]) == 1		//Industria
											aProdepe 		:= Prodepe(SefProd54(aArrayF3,cAliasSF3,2),cAliasSF3)
											R54->A54_APUR	:= aProdepe[1]			//Codigo da Apuracao
	        							 Endif         
	        							 
										 //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										 //³Implementacao do FUNCEP/PB³
										 //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										 If lGimPB
											R54->A54_FUNCEP	:=	cFuncep                
											R54->A54_ICMDIF	:=	SD1->D1_ICMSCOM
										 Endif

									     If lSintegMG .And. aArrayF3[1][29]>0 .And. SF1->F1_TIPO$"C"
										  	SD1->(DbSetOrder (1))
	  								 	 	SD1->(MsSeek (F3Filial ("SD1")+aArrayF3[1][1]+aArrayF3[1][2]+aArrayF3[1][3]+aArrayF3[1][4]))
	  								 	 	SB1->( DbSetOrder( 1 ) )
	  										SB1->( MsSeek( xFilial( "SB1" )+SD1->D1_COD ) )
	  										SF4->( DbSetOrder( 1 ) )
	  										SF4->( MsSeek( xFilial( "SF4" )+SD1->D1_TES ) )
											  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
											  //³Situacao Tributaria ³
											  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
											If Empty( SD1->D1_CLASFIS )
											    If SF4->(Fieldpos("F4_SITTRIB"))>0
												    cSitTrib 	:= 	aFISFill(Num2Chr(Val(Substr(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB),3,0),3)
												Else
											    	If len(alltrim(SB1->B1_ORIGEM)) ==2
													    cSitTrib	:= SB1->B1_ORIGEM+"0"
											    	Else	
											    	    cSitTrib	:=	aFISFill(Num2Chr(Val(Substr(SB1->B1_ORIGEM,1,1)+Substr(SB1->B1_CLASFIS,1,1)+"0"),3,0),3)
										    		EndIf
											  	EndIf	
											Else
												IF SUBSTR((cAliasSD1)->D1_CLASFIS,1,1)=" "
									               cSitTrib :="0"+Alltrim((cAliasSD1)->D1_CLASFIS)
									            ELSE
									               cSitTrib := Alltrim((cAliasSD1)->D1_CLASFIS)
									               cSitTrib += IIf(Len(cSitTrib)==1,"00",IIf(Len(cSitTrib)==2,"0",""))							    
							                    ENDIF
											EndIf
										    A940LoadPro("S",@cNcm,@cProd,,lSef)
								    		  
								    		R54->A54_PRODUT	:=	cProd
	  								 	 	R54->A54_CST		:=	cSitTrib
	  									 	R54->A54_DTEMI 	:= aArrayF3[1][18]  // Data da Emissao 
										  	R54->A54_ALIQST		:=	aArrayF3[1][8]
										  	R54->A54_BRICMS		+=	aArrayF3[1][29]
										  	R54->A54_VALIPI		+=  aArrayF3[1][25]
										 EndIf

										 MsUnlock()
									  Endif
								   EndIf
								Endif   
						    Endif
						Next	   
					EndIf
	
					SD1->( dbSetOrder(1))
	
					#IFDEF TOP
					    If TcSrvType()<>"AS/400"
						    cAliasSD1 := "a940ASD1"
							aStru  := SD1->(dbStruct())
							cQuery := "SELECT * "
							cQuery += "FROM "+RetSqlName("SD1")+" "
							cQuery += "WHERE D1_FILIAL='"+F3Filial("SD1",cAliasSF3)+"' AND "
							cQuery += "D1_DOC='"+aArrayF3[1][1]+"' AND "
							cQuery += "D1_SERIE='"+aArrayF3[1][2]+"' AND "
							cQuery += "D1_FORNECE='"+aArrayF3[1][3]+"' AND "
							cQuery += "D1_LOJA='"+aArrayF3[1][4]+"' AND "
							cQuery += "D1_CF NOT IN('000','999','0000','9999') AND "
							// Notas Fiscais de Complemento devem gerar apenas o 54 especifico (997)
							cQuery += "D1_TIPO NOT IN ('I','P','C') AND "						
							cQuery += "D_E_L_E_T_ = ' ' "
							cQuery += "ORDER BY "+SqlOrder(SD1->(IndexKey()))
			
							cQuery := ChangeQuery(cQuery)
							dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD1,.T.,.T.)
			
							For nX := 1 To len(aStru)
								If aStru[nX][2] <> "C" .And. FieldPos(aStru[nX][1])<>0
									TcSetField(cAliasSD1,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
								EndIf
							Next nX
							dbSelectArea(cAliasSD1)
						Else
					#ENDIF
					   		(cAliasSD1)->( MsSeek(F3Filial("SD1",cAliasSF3)+aArrayF3[1][1]+aArrayF3[1][2]+aArrayF3[1][3]+aArrayF3[1][4]))
					#IFDEF TOP
						EndIf
					#ENDIF
	
					nItem	:= 1
				   	 	
				    While (cAliasSD1)->(!Eof()).And. (cAliasSD1)->D1_FILIAL +(cAliasSD1)->D1_DOC + (cAliasSD1)->D1_SERIE+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA==;
					    F3Filial("SD1",cAliasSF3)+aArrayF3[1][1]+aArrayF3[1][2]+aArrayF3[1][3]+aArrayF3[1][4] .And. lCompTare
					    
					    If !lQuery .And. Left((cAliasSD1)->D1_CF,3) $ "000/999"
						    (cAliasSD1)->(dbSkip())	
						    Loop
					    Endif
	
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Nao ser gerado Reg. 54 para Notas de Complementos  ³
						//³Devem gerar apenas o registro 54 especifico (997)  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					    If (cAliasSD1)->D1_TIPO $ "IPC"	//I-ICMS P-IPI C-Preco
						    (cAliasSD1)->(dbSkip())	
						    Loop
					    Endif
	
						SF4->(MsSeek(F3Filial("SF4",cAliasSF3)+(cAliasSD1)->D1_TES))
						If SF4->F4_LFICM <> "N" .And. (cAliasSD1)->D1_TOTAL > 0
	
							SB1->(MsSeek(F3Filial("SB1",cAliasSF3)+(cAliasSD1)->D1_COD))
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Verifica se o produto faz parte do FUNCEP/PB                  ³
							//³Fundo de Combate e Erradicacao da Pobreza do Estado da Paraiba³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If lGimPB
								cFuncep := ""
								If SB5->(FieldPos("B5_FUNCEP")) > 0
									SB5->(dbSetOrder(1))
									If SB5->(dbSeek(F3Filial("SB5",cAliasSF3)+(cAliasSD1)->D1_COD))
										cFuncep := SB5->B5_FUNCEP
									Endif
								Endif
							Endif
							nPosAliq := 0
							nAliqIte := 0
							cSitTrib := ""
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Processo utilizado para atribuir os valores de Base de Icms e³
							//³Aliquota de Icms ao Registro 54 conforme Registro 50.        ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ					 
							A940LoadPro("E",@cNcm,@cProd,(cAliasSD1)->D1_TEC,lSef)
				        	If ! ALLTRIM((cAliasSD1)->D1_CF) $ cCfoSint
							    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Monta Registro Tipo 75³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								nAliqICM	:= SuperGETMV("MV_ICMPAD")
								nBRetido	:=(cAliasSD1)->D1_BRICMS/(cAliasSD1)->D1_QUANT
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Situacao Tributaria ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If Empty((cAliasSD1)->D1_CLASFIS)
								  	If SF4->(Fieldpos("F4_SITTRIB"))>0
									    cSitTrib 	:= 	aFISFill(Num2Chr(Val(Substr(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB),3,0),3)
							   		Else
								        If len(alltrim(SB1->B1_ORIGEM)) ==2
											cSitTrib 	:=  SB1->B1_ORIGEM+"0"
										Else	
										    cSitTrib 	:= 	aFISFill(Num2Chr(Val(Substr(SB1->B1_ORIGEM,1,1)+Substr(SB1->B1_CLASFIS,1,1)+"0"),3,0),3)
								        EndIf
									EndIf	
								Else
									IF SUBSTR((cAliasSD1)->D1_CLASFIS,1,1)=" "
									  cSitTrib :="0"+Alltrim((cAliasSD1)->D1_CLASFIS)
									ELSE
									  cSitTrib := Alltrim((cAliasSD1)->D1_CLASFIS)
									  cSitTrib += IIf(Len(cSitTrib)==1,"00",IIf(Len(cSitTrib)==2,"0",""))							    
							        ENDIF
									
								EndIf
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³% de Reducao do ICMS nas Operacoes Internas³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								nRedBase :=0
								If SF4->F4_BASEICM >=100
									nRedBase :=0
								ElseIf SF4->F4_BASEICM > 0
								    nRedBase :=	(100-SF4->F4_BASEICM)
								Else
								    nRedBase :=	SF4->F4_BASEICM
								EndIf		
								
								If Empty((cAliasSD1)->D1_TEC)
		 				    		If len(alltrim(SB1->B1_COD))>01
			                            cSeek	:=(dtos(dDtIni)+dtos(dDtFim)+PADR(cProd,14)+PADR(cNcm,8)+SB1->B1_UM+space(4))
								    Else						
		               		            cSeek	:=(dtos(dDtIni)+dtos(dDtFim)+Substr(SB1->B1_COD,1,14)+PADR(cNcm,8)+SB1->B1_UM+space(4))
						    		EndIf						
								Else
		       		                cSeek	:=(dtos(dDtIni)+dtos(dDtFim)+PADR(cProd,14)+Substr(cNcm,1,8)+(cAliasSD1)->D1_UM+space(4))
								Endif
								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Somente SEF - Grava na Entrada Reg. 54 Modelos 01,06,21 e 22 ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If lSef .And. AModNot(aArrayF3[1][7])$"01/06/21/22" .Or. ;
									!lSef .And. AModNot(aArrayF3[1][7])=="01"
									//
									//Utilizo informacoes do SWN
									If !Empty((cAliasSD1)->D1_TEC)								
										ImporSWN (cAliasSd1, cCNPJ, cSitTrib, cCNPJOri, cIe, cTranspEst, aRetCfp, cFuncep, dDTIni, dDTFim, cProd, cNcm, nAliqICM, nBRetido, nRedBase, aArrayF3, cAliasSF3, lSef, lImpSt, lGimPB, @nItem,cContrTare)
										//
									Else
										nAliqIte  := (cAliasSD1)->D1_PICM
										If !SF4->F4_ISS $ "N "
											nAliqIte  := 0
										ElseIf SF4->F4_LFICM $ "IO" .And. nRedBase > 0 .And. SF4->F4_CONSUMO == "S"
											nAliqIte  := 0
										ElseIf 	SF4->F4_LFICM $ "IO" .And. nRedBase == 0
											nAliqIte  := 0
										Endif
										nPosAliq := Ascan(aArrayF3,{|x| x[8]==nAliqIte})
										//
										If (lAglR54 .And. !R54->(MsSeek (cCNPJ+aArrayF3[1][2]+aArrayF3[1][1]+cProd+Str (Iif (nPosAliq>0, aArrayF3[nPosAliq][8], 0), 5, 2)))) .Or. !(lAglR54)
											
											lAglutinou := .F.
											
											RecLock("R54",.T.)
											R54->A54_CTARE	:=	cContrTare
											R54->A54_CNPJ	:=	cCNPJ
											R54->A54_MODELO	:=	AModNot(aArrayF3[1][7])
											R54->A54_SERIE 	:=	(cAliasSD1)->D1_SERIE
											R54->A54_NFISC 	:=	(cAliasSD1)->D1_DOC
											R54->A54_CFOP	:=	(cAliasSD1)->D1_CF
											R54->A54_CST   	:=	cSitTrib
											R54->A54_NUMITE	:=	StrZero(nItem,3)
											R54->A54_PRODUT	:=	cProd
											R54->A54_PRORI	:=	SB1->B1_COD
											R54->A54_CNORI  :=  cCNPJOri
											R54->A54_ALQICM	:=	IIf(nPosAliq > 0,aArrayF3[nPosAliq][8],0)
											//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
											//³ Implementacao do SEF PE                           ³
											//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
											R54->A54_IE	  	:= 	cIE
											R54->A54_EMISS	:= 	SF1->F1_DTDIGIT
											R54->A54_UF 	:= 	cTranspEst
											//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
											//³ Implementacao do PRODEPE                          ³
											//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
											If lSef .And. Val(aRetCfp[19][1]) == 1		//Industria
												aProdepe 		:= Prodepe(SB1->B1_COD,cAliasSF3)
												R54->A54_APUR	:= aProdepe[1]			//Codigo da Apuracao
			       							Endif
											//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
											//³Implementacao do FUNCEP/PB³
											//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
											If lGimPB
												R54->A54_FUNCEP	:=	cFuncep                
												R54->A54_ICMDIF	:=	(cAliasSD1)->D1_ICMSCOM
											Endif
											//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
											//³Sintegra-MG -> Informacoes de Substituicao Tributaria³
											//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
											//OBSERVACAO: ALIQUOTA SEMPRE SERA A MESMA GRAVADA NO SD1, POR ISSO O SEEK ACIMA SOMENTE TRATA DA ALIQICM
									 		R54->A54_DTEMI := aArrayF3[1][18]  // Data da Emissao 
											R54->A54_DTSAI := aArrayF3[1][10]  // Data da Entrada/Saida
											If (cAliasSD1)->D1_ICMSRET>0
												R54->A54_ALIQST := Iif(SB1->B1_PICM == 0,GetMV("MV_ICMPAD"),SB1->B1_PICM)
											Endif
										Else
											RecLock("R54",.F.)
											
											lAglutinou := .T.
										EndIf	
											R54->A54_QUANT 	+=	(cAliasSD1)->D1_QUANT
											R54->A54_VALPRO	+=	(cAliasSD1)->D1_TOTAL
											R54->A54_VALDES	+=	(cAliasSD1)->D1_VALDESC
											R54->A54_VALICM	+=	(cAliasSD1)->D1_VALICM
											R54->A54_ICMRET	+=	(cAliasSD1)->D1_ICMSRET
											//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
											//³Verifica a referencia do item no SF3, para checar a base³
											//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							  				nPos := aScan(aArrayF3,{|x| x[1]==(cAliasSD1)->D1_DOC .And. x[2]==(cAliasSD1)->D1_SERIE .And. x[3]==(cAliasSD1)->D1_FORNECE .And. x[4]==(cAliasSD1)->D1_LOJA .And. x[5]==(cAliasSD1)->D1_CF .And. x[8]==(cAliasSD1)->D1_PICM})
							  				If nPos > 0
							  					nBsICMS := aArrayF3[nPos][19] 	// F3_BASEICM
							  				Else                             
							  					nBsICMS := aArrayF3[1][19]		// F3_BASEICM
							  				Endif
											If lSef
												If SF4->F4_LFICM $ "IONZ" .And. (Alltrim((cAliasSD1)->D1_CF)$"1556/2556/3556/197" .Or. Empty(nBsICMS))
													R54->A54_BSICM  +=	0
												Else
													R54->A54_BSICM  +=	(cAliasSD1)->D1_BASEICM
												Endif
												R54->A54_BRICMS +=	(cAliasSD1)->D1_BRICMS
											Else
												If SF4->F4_LFICM $ "IONZ" .And. (Alltrim((cAliasSD1)->D1_CF)$"1556/2556/3556/197" .Or. Empty(nBsICMS))
												   R54->A54_BSICM  +=	0
												Else	
												   R54->A54_BSICM  +=	(cAliasSD1)->D1_BASEICM
												Endif   
												R54->A54_BRICMS +=	(cAliasSD1)->D1_BRICMS
											Endif
			
											If lImpSt .And. (cAliasSD1)->D1_VALIPI > 0		//Valor do IPI
												R54->A54_VALIPI	+=	0
											Else
												If lSef .And. SF4->F4_LFIPI $ "IO"
													R54->A54_VALIPI	+=	0
												Else
													R54->A54_VALIPI	+=	(cAliasSD1)->D1_VALIPI
												Endif
											Endif
										MsUnlock()
									EndIf
									//
									If (lMta56E)
								        Execblock("MTA56E",.F.,.F., {cAliasSD1, StrZero(nItem,3)})
									EndIf
								EndIf
								//
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Somente SEF - Grava na Entrada Reg. 54 Modelos 01,06,21 e 22 ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If (lSef .And. AModNot(aArrayF3[1][7])$"01/06/21/22" .Or. ;
									!lSef .And. AModNot(aArrayF3[1][7])=="01") .And. Empty((cAliasSD1)->D1_TEC)
									If R75->(!dbSeek(cSeek))
							    	   RecLock("R75",.T.)
							    	   R75->A75_CTARE	:=	cContrTare
									   R75->A75_DTAINI	:=	dDTIni
									   R75->A75_DTAFIM	:=	dDTFim
									   A940LoadPro("E",@cNcm,@cProd,(cAliasSD1)->D1_TEC,lSef)
									   R75->A75_PROD	:=cProd
								   	   R75->A75_PRORI	:=SB1->B1_COD
									   IF cNcm=="        "
									   	   R75->A75_CODNCM	:="00000000"
									   else
     									   R75->A75_CODNCM	:=cNcm
									   endif
									   If !Empty((cAliasSD1)->D1_TEC)
									      R75->A75_DESCR	:=	(cAliasSD1)->D1_COD
										  R75->A75_UM    	:=	(cAliasSD1)->D1_UM
										  R75->A75_ALQIPI	:=	(cAliasSD1)->D1_IPI
									   Else
										  R75->A75_DESCR	:=	SB1->B1_DESC
										  R75->A75_UM    	:=	SB1->B1_UM
										  R75->A75_ALQIPI	:=	SB1->B1_IPI
									   EndIf
									   R75->A75_ALQICM	:=	nAliqICM
		
										If lSef
											If (cAliasSD1)->D1_ICMSRET > 0		//Substituicao Tributaria
												R75->A75_BRICMS :=	nBRetido
											Else
												R75->A75_BRICMS :=	0
											Endif
										Else
											R75->A75_BRICMS	:=	nBRetido  	//Base do Retido
										Endif
		
									   R75->A75_SITTRI	:=	cSitTrib
									   R75->A75_REDBSE	:= nRedBase		//Reducao da Base do ICMS
									   MsUnlock()							 
								    Endif
							    Endif
							    
							    If !lAglutinou
								    nItem ++
								EndIF
							Endif   
	
					        If lReg88      
			                   If (SF4->(Fieldpos("F4_ICMSDIF"))>0 .And. SF4->F4_ICMSDIF=="1")				        
							      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							      //³ Verifica Fornecedor/Cliente                                            ³
							      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							      If (SubStr((cAliasSD1)->D1_CF,1,1)<"5" .And. (cAliasSD1)->D1_TIPO$"BD") .Or.; 
								     (SubStr((cAliasSD1)->D1_CF,1,1)>="5" .And. (cAliasSD1)->D1_TIPO$"BD") 
		   					         dbSelectArea("SA1")
								     dbSetOrder(1)				
								     SA1->(MsSeek(F3Filial("SA1",cAliasSF3)+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA))
		   				          Else
								     dbSelectArea("SA2")
								     dbSetOrder(1)
								     SA2->(MsSeek(F3Filial("SA2",cAliasSF3)+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA))					
							      EndIf
							               
							      If (Subs((cAliasSD1)->D1_CF,1,1)=="3") .And. !Empty(cD1_Di) .And. !Empty(cD1_Dtdi)
								     cDi   := cD1_Di
								     dDtdi := cD1_Dtdi							  
							      Else
								     cDi   := ""   
								     dDtdi := ""
							      Endif  
					      
					  		      RecLock("R88",.T.)
							      R88->A88_TIPINF := Iif((Subs((cAliasSD1)->D1_CF,1,1)<>"3"),"A","C")
							      R88->A88_INSEST := Iif((cAliasSD1)->D1_TIPO$"DB",SA1->A1_INSCR,SA2->A2_INSCR)
							      R88->A88_DTEMIS := (cAliasSD1)->D1_EMISSAO
							      R88->A88_UF     := Iif((cAliasSD1)->D1_TIPO$"DB",SA1->A1_EST,SA2->A2_EST)     
							      R88->A88_MODELO := AModNot((cAliasSF3)->F3_ESPECIE)
							      R88->A88_SERIE  := Alltrim(Subs((cAliasSD1)->D1_SERIE,1,2))
							      R88->A88_NTFISC := (cAliasSD1)->D1_DOC 
							      R88->A88_VALPRO := (cAliasSD1)->D1_TOTAL
							      R88->A88_VALICM := (cAliasSD1)->D1_VALICM                           
							      R88->A88_DECLIM := If(Empty(cDi),0,(cAliasSD1)->&cDi)
							      R88->A88_DTDI    := If(Empty(dDtdi),CTOD("//"),(cAliasSD1)->&dDtDi)
							      R88->A88_DESCPR := SB1->B1_DESC 
							      MsUnlock()
							   Endif   
							Endif   
					    Endif
					    (cAliasSD1)->(dbSkip())
					EndDo
	        		If lQuery
					    dbSelectArea(cAliasSD1)
						dbCloseArea()
				    Endif
				Else
		    		SF2->( dbSetOrder(1) )
					SF2->( MsSeek(F3Filial("SF2",cAliasSF3)+aArrayF3[1][1]+aArrayF3[1][2]+aArrayF3[1][3]+aArrayF3[1][4]))
					
					lCompTare	:=	Iif (lTareDf .And. AllTrim (SF2->F2_TIPO)$"CIP", .F., .T.)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Registro adicional para Frete,Seguro e Outras Despesas       ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If SF2->(!Eof()) .And. AModNot(aArrayF3[1][7])=="01" .And. aArrayF3[1][6] <> "L"
					    For nI := 1 to 6
							// Somente gera o item 993 quando o contribuinte destacar PIS/COFINS na nota fiscal - Sintegra
							If nI == 4 .And. mv_par22 <> 1 .And. !lGimPB
								Loop
							Endif
							If nI == 4
								aRelImp2   := MaFisRelImp("MT100",{ "SF2" })
								nPsVlPisSa := 0
								nValPis    := 0
								nValCof    := 0
								If !Empty( nScanPis := aScan(aRelImp2,{|x| x[1]=="SF2" .And. x[3]=="NF_VALPS2"} ) )
									cCpVlPisSa := aRelImp2[nScanPis,2]
									nPsVlPisSa := SF2->(FieldPos(cCpVlPisSa))
								EndIf 	
								If !Empty( nPsVlPisSa ) 
									nValPis := SF2->( FieldGet( nPsVlPisSa ) )
								EndIf
								If !Empty( nScanCof := aScan(aRelImp2,{|x| x[1]=="SF2" .And. x[3]=="NF_VALCF2"} ) )
									If !Empty(SF2->(FieldPos(aRelImp2[nScanCof,2])))
										nValCof := SF2->(FieldGet(SF2->(FieldPos(aRelImp2[nScanCof,2]) ) ) )
									EndIf
								EndIf
							Endif
				    		If (nI == 9999 .And. SF2->F2_FRETE > 0) .Or.;
				    		   (nI == 9999 .And. SF2->F2_SEGURO > 0) .Or.;
							   (nI == 9999 .And. SF2->F2_DESPESA > 0) .Or.;
							   (nI == 9999 .And. nValPis+nValCof > 0) .Or.;
	   						   (nI == 9999 .And. SF2->F2_TIPO $ "CIP") .Or.;
	   						   (nI == 9999 .And. SF2->F2_VALISS > 0 .And. !lConv76)
							
								dbSelectArea("R54")
					        	If ! ALLTRIM(aArrayF3[1][5]) $ cCfoSint
									If !MsSeek(cCNPJ+aArrayF3[1][2]+aArrayF3[1][1]+IIf(nI==1,"991",If(nI==2,"992",If(nI==3,"999",If(nI==4,"993",If(nI==5,"997","998"))))))
									  RecLock("R54",.T.)
									  R54->A54_CTARE	:=	cContrTare
									  R54->A54_CNPJ		:=	cCNPJ
									  R54->A54_MODELO 	:=	AModNot(aArrayF3[1][7])	
									  R54->A54_SERIE  	:=	aArrayF3[1][2]
									  R54->A54_NFISC  	:=	aArrayF3[1][1]
								  	  R54->A54_CFOP		:=	aArrayF3[1][5]
									  R54->A54_CST     	:= CSTCompl (dDtIni, lSef, lValidaPr)
									  R54->A54_NUMITE	:= IIf(nI==1,"991",If(nI==2,"992",If(nI==3,"999",If(nI==4,"993",If(nI==5,"997","998"))))) //Numero do Item (991-Frete;992 -Seguro;999-Outras despesas acessorias;993-PIS/COFINS;997-Compl.Preco/ICMS;998-Servicoes Nao Tributados)
									  R54->A54_QUANT  	:= IIf(lSef,1,0)
									  R54->A54_CNORI  	:= cCNPJOri
									  
									  If lSef 
										 // Os itens 991/992/993/998/999 nao devem ser apresentados com CFOP e nem
										 // com codigo do produto no registro 54 do SEF.
										 If R54->A54_NUMITE $ "991/992/993/998/999"
											R54->A54_CFOP	:= "0000"		 
											If R54->A54_NUMITE == "998"
												R54->A54_PRODUT := ""
											Endif
										 Else
											R54->A54_PRODUT	:= SefProd54(aArrayF3,cAliasSF3)
											R54->A54_PRORI	:=	SefProd54(aArrayF3,cAliasSF3, 2)
												
												GrvReg75(aArrayF3,cAliasSF3,dDtIni,dDtFim)											
										 Endif
									  Endif
		                                   
									  //Alteracao efetuada apos consulta na Secretaria RS
									  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									  //³REGISTRO ERRO                                                                        ³
									  //³                                                                                     ³
									  //³PARA OS CODIGOS ESPECIAIS QUANTIDADE (CAMPO 10) E VALOR DO PRODUTO (CAMPO 11)        ³
									  //³ DEVEM ESTAR ZERADOS E A INFORMACAO DEVE SER PREENCHIDA NO VALOR DESCONTAO / DESPESA ³
								  	  //³ ACESSORIOS (CAMPO 12 ).  REJEICAO                                                   ³
									  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									  If GETMV("MV_ESTADO")=="RS"
	 								     R54->A54_QUANT  := 0
										 R54->A54_VALPRO  := 0
										 R54->A54_VALDES  := IIf(nI==1,SF2->F2_FRETE,If(nI==2,SF2->F2_SEGURO,If(nI==3,SF2->F2_DESPESA,If(nI==4,nValPis+nValCof,SF2->F2_VALBRUT))))
									  Else
										 R54->A54_VALPRO := IIf(nI==1,SF2->F2_FRETE,If(nI==2,SF2->F2_SEGURO,If(nI==3,SF2->F2_DESPESA,If(nI==4,nValPis+nValCof,If(nI==6,SF2->F2_BASEISS,SF2->F2_VALBRUT)))))
									     R54->A54_VALDES := R54->A54_VALPRO
									  EndIf
		
									  If lSef
		                               	 R54->A54_ALQICM  := aArrayF3[1][8]
									  ElseIf (SF2->F2_TIPO$"CI" .And. lTareDf)
										 SD2->(DbSetOrder (3))
									 	 SD2->(MsSeek (F3Filial ("SD2")+aArrayF3[1][1]+aArrayF3[1][2]+aArrayF3[1][3]+aArrayF3[1][4]))
										 R54->A54_ALQICM	:=	SD2->D2_PICM
									  Else
		                               	 R54->A54_ALQICM  := IIf(nI==4,aArrayF3[1][8],0)
									  Endif
		
									  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									  //³ Implementacao do SEF PE                           ³
									  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									  R54->A54_IE	  	:= 	cIE
									  R54->A54_EMISS	:= 	SF2->F2_EMISSAO
									  R54->A54_UF 	:= 	cTranspEst
	
									  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									  //³ Implementacao do PRODEPE                          ³
									  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									  If lSef .And. Val(aRetCfp[19][1]) == 1		//Industria
										 aProdepe 		:= Prodepe(SefProd54(aArrayF3,cAliasSF3,2),cAliasSF3)
										 R54->A54_APUR	:= aProdepe[1]			//Codigo da Apuracao
										 If aProdepe[1] > 1
											SefRegX35(aProdepe[1])					//Processa Registro 88-35-00
										 Endif
	       							  Endif         
	       							  
									  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									  //³Implementacao do FUNCEP/PB³
									  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									  If lGimPB
									     R54->A54_FUNCEP := 	cFuncep
									  Endif
									  
									  If lSintegMG .And. aArrayF3[1][29]>0 .And. SF2->F2_TIPO$"C"
									  	  SD2->(DbSetOrder (3))
  								 	 	  SD2->(MsSeek (F3Filial ("SD2")+aArrayF3[1][1]+aArrayF3[1][2]+aArrayF3[1][3]+aArrayF3[1][4]))
  								 	 	  SB1->( DbSetOrder( 1 ) )
  										  SB1->( MsSeek( xFilial( "SB1" )+SD2->D2_COD ) )
  										  SF4->( DbSetOrder( 1 ) )
  										  SF4->( MsSeek( xFilial( "SF4" )+SD2->D2_TES ) )
										  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										  //³Situacao Tributaria ³
										  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										  If Empty( SD2->D2_CLASFIS )
										    If SF4->(Fieldpos("F4_SITTRIB"))>0
											    cSitTrib 	:= 	aFISFill(Num2Chr(Val(Substr(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB),3,0),3)
											Else
										    	If len(alltrim(SB1->B1_ORIGEM)) ==2
												    cSitTrib	:= SB1->B1_ORIGEM+"0"
										    	Else	
										    	    cSitTrib	:=	aFISFill(Num2Chr(Val(Substr(SB1->B1_ORIGEM,1,1)+Substr(SB1->B1_CLASFIS,1,1)+"0"),3,0),3)
									    		EndIf
										  	EndIf	
										  Else
										  	IF SUBSTR((cAliasSD2)->D2_CLASFIS,1,1)=" "
									          IF aArrayF3[1][25]>0 
                                                  cSitTrib :="1"+Alltrim((cAliasSD2)->D2_CLASFIS)
                                              ELSE    									          
									              cSitTrib :="0"+Alltrim((cAliasSD2)->D2_CLASFIS)
									          ENDIF
									        ELSE
									          cSitTrib := Alltrim((cAliasSD2)->D2_CLASFIS)
									          cSitTrib += IIf(Len(cSitTrib)==1,"00",IIf(Len(cSitTrib)==2,"0",""))							    
							                ENDIF
										  EndIf
									      A940LoadPro("S",@cNcm,@cProd,,lSef)
							    		  
							    		  R54->A54_PRODUT	:=	cProd
  								 	 	  R54->A54_CST		:=	cSitTrib
  									 	  R54->A54_DTEMI 	:= aArrayF3[1][18]  // Data da Emissao 
										  R54->A54_ALIQST	:=	aArrayF3[1][8]
										  R54->A54_BRICMS	+=	aArrayF3[1][29]
										  R54->A54_VALIPI	+=  aArrayF3[1][25]
									  EndIf
									  MsUnlock()     
								   Endif	  
							    Endif
							Endif   
							If (nI == 6 .And. SF2->F2_VALISS > 0 .And. lConv76)
								R54NFServ (	aArrayF3,aArrayF3[1][1],aArrayF3[1][2],aArrayF3[1][3],aArrayF3[1][4],;
											cContrTare,cCNPJ,lCONV76,dDtIni,lSef,lValidaPr,cCNPJOri,lTareDf,cIE,;
											cTranspEst,lGimPB,cFuncep,aProdepe,cAliasSF3)								
							Endif   
						Next
					EndIf
	
					SD2->( dbSetOrder(3) )
	
					#IFDEF TOP
	  				     If TcSrvType()<>"AS/400"
		  				     cAliasSD2 := "a940ASD2"
							 aStru  := SD2->(dbStruct())
							 cQuery := "SELECT * "
							 cQuery += "FROM "+RetSqlName("SD2")+" "
							 cQuery += "WHERE D2_FILIAL='"+F3Filial("SD2",cAliasSF3)+"' AND "
							 cQuery += "D2_DOC='"+aArrayF3[1][1]+"' AND "
							 cQuery += "D2_SERIE='"+aArrayF3[1][2]+"' AND "
							 cQuery += "D2_CLIENTE='"+aArrayF3[1][3]+"' AND "
							 cQuery += "D2_LOJA='"+aArrayF3[1][4]+"' AND "
							 cQuery += "D2_CF NOT IN('000','999','0000','9999') AND "
							 // Notas Fiscais de Complemento devem gerar apenas o 54 especifico (997)
							 cQuery += "D2_TIPO NOT IN ('I','P','C') AND "						
							 cQuery += "D_E_L_E_T_ = ' ' "
							 cQuery += "ORDER BY "+SqlOrder(SD2->(IndexKey()))
		            	
							 cQuery := ChangeQuery(cQuery)
							 dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD2,.T.,.T.)
		
							 For nX := 1 To len(aStru)
								 If aStru[nX][2] <> "C" .And. FieldPos(aStru[nX][1])<>0
									 TcSetField(cAliasSD2,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
								 EndIf
							 Next nX
							 dbSelectArea(cAliasSD2)
						 Else
					#ENDIF
						 	 (cAliasSD2)->( MsSeek(F3Filial("SD2",cAliasSF3)+aArrayF3[1][1]+aArrayF3[1][2]+aArrayF3[1][3]+aArrayF3[1][4]))
					#IFDEF TOP
						 EndIf
					#ENDIF
				   
					nItem	:= 1
	
				    While (cAliasSD2)->(!Eof()).And. (cAliasSD2)->D2_FILIAL+(cAliasSD2)->D2_DOC+(cAliasSD2)->D2_SERIE+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA== ;
						F3Filial("SD2",cAliasSF3)+aArrayF3[1][1]+aArrayF3[1][2]+aArrayF3[1][3]+aArrayF3[1][4] .And. lCompTare
						
						If !lQuery .And. Left((cAliasSD2)->D2_CF,3) $ "000/999"
						    (cAliasSD2)->(dbSkip())	
						    Loop
					    Endif
	
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Nao ser gerado Reg. 54 para Notas de Complementos  ³
						//³Devem gerar apenas o registro 54 especifico (997)  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					    If (cAliasSD2)->D2_TIPO $ "IPC"	//I-ICMS P-IPI C-Preco
						    (cAliasSD2)->(dbSkip())	
						    Loop
					    Endif
					    
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄT¿
						//³Apenas os registros 61 e 61R devem tratar de documentos lancados em lote³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄTÙ
						If aArrayF3[1][6] == "L" .And. !AModNot(aArrayF3[1][7])$"02/04"
						    (cAliasSD2)->(dbSkip())	
						    Loop
	                    Endif
	
						SF4->(MsSeek(F3Filial("SF4",cAliasSF3)+(cAliasSD2)->D2_TES))
	
						If SF4->F4_LFICM <> "N" .And. (cAliasSD2)->D2_TOTAL > 0 
	
							SB1->(MsSeek(F3Filial("SB1",cAliasSF3)+(cAliasSD2)->D2_COD))
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Verifica se o produto faz parte do FUNCEP/PB                  ³
							//³Fundo de Combate e Erradicacao da Pobreza do Estado da Paraiba³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If lGimPB
								cFuncep := ""
								If SB5->(FieldPos("B5_FUNCEP")) > 0
									SB5->(dbSetOrder(1))
									If SB5->(dbSeek(F3Filial("SB5",cAliasSF3)+(cAliasSD2)->D2_COD))
										cFuncep := SB5->B5_FUNCEP
									Endif
								Endif
							Endif
							nPosAliq := 0
							nAliqIte := 0
							cSitTrib := ""
						    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Processo utilizado para atribuir os valores de Base de Icms e³
							//³Aliquota de Icms ao Registro 54 conforme Registro 50.        ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ					 
							A940LoadPro("S",@cNcm,@cProd,,lSef)
				        	If !(ALLTRIM((cAliasSD2)->D2_CF)$cCfoSint) .And. ;
								AModNot(aArrayF3[1][7])$"01/02/04/21/22"
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Monta Registro Tipo 75³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								nAliqICM	:= SuperGETMV("MV_ICMPAD")
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Situacao Tributaria ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If Empty((cAliasSD2)->D2_CLASFIS)
								    If SF4->(Fieldpos("F4_SITTRIB"))>0
									    cSitTrib 	:= 	aFISFill(Num2Chr(Val(Substr(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB),3,0),3)
									Else
									    If len(alltrim(SB1->B1_ORIGEM)) ==2
										    cSitTrib	:= SB1->B1_ORIGEM+"0"
									    Else	
									        cSitTrib	:=	aFISFill(Num2Chr(Val(Substr(SB1->B1_ORIGEM,1,1)+Substr(SB1->B1_CLASFIS,1,1)+"0"),3,0),3)
									    EndIf
									EndIf	
								Else
									IF SUBSTR((cAliasSD2)->D2_CLASFIS,1,1)=" "
									  IF (cAliasSD2)->D2_VALIPI>0 
									    cSitTrib :="1"+Alltrim((cAliasSD2)->D2_CLASFIS)
									  ELSE
									    cSitTrib :="0"+Alltrim((cAliasSD2)->D2_CLASFIS)
									  ENDIF
									ELSE
									  cSitTrib := Alltrim((cAliasSD2)->D2_CLASFIS)
									  cSitTrib += IIf(Len(cSitTrib)==1,"00",IIf(Len(cSitTrib)==2,"0",""))							    
							        ENDIF
							    EndIf
							  								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³% de Reducao do ICMS nas Operacoes Internas³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								nRedBase := 0
					    		If SF4->F4_BASEICM >=100
									nRedBase :=0
								ElseIf SF4->F4_BASEICM > 0
								    nRedBase :=	(100-SF4->F4_BASEICM)
								Else
								    nRedBase :=	SF4->F4_BASEICM
							    Endif
	
							    cSeek	:= (dtos(dDtIni)+dtos(dDtFim)+PADR(cProd,14)+PADR(cNcm,8)+SB1->B1_UM+space(4))
								lServico := (!Empty((cAliasSD2)->D2_VALISS))	//Verifica se o item eh um Servico
								
								If AModNot(aArrayF3[1][7])=="01" .And. !lServico
	                                
									nAliqIte  := (cAliasSD2)->D2_PICM
									If !SF4->F4_ISS $ "N "
										nAliqIte  := 0
									ElseIf SF4->F4_LFICM $ "IO" .And. nRedBase > 0 .And. SF4->F4_CONSUMO == "S"
										nAliqIte  := 0
									ElseIf 	SF4->F4_LFICM $ "IO" .And. nRedBase == 0
										nAliqIte  := 0
									Endif
									nPosAliq := Ascan(aArrayF3,{|x| x[8]==nAliqIte})
									//
									If (lAglR54 .And. !R54->(MsSeek (cCNPJ+aArrayF3[1][2]+aArrayF3[1][1]+cProd+Str (Iif (nPosAliq>0, aArrayF3[nPosAliq][8], 0), 5, 2)))) .Or. !(lAglR54)
										
										lAglutinou := .F.
										
										RecLock("R54",.T.)
										R54->A54_CTARE	:=	cContrTare
										R54->A54_CNPJ	:=	cCNPJ
										R54->A54_MODELO	:=	AModNot(aArrayF3[1][7])
										R54->A54_SERIE	:=	(cAliasSD2)->D2_SERIE
										R54->A54_NFISC	:=	(cAliasSD2)->D2_DOC
										R54->A54_CFOP	:=	(cAliasSD2)->D2_CF
										R54->A54_CST   	:=  cSitTrib
										R54->A54_NUMITE	:=	StrZero(nItem,3)
										R54->A54_PRODUT	:=	cProd
										R54->A54_PRORI	:=	SB1->B1_COD
										R54->A54_CNORI  := 	cCNPJOri
										R54->A54_ALQICM	:=	IIf(nPosAliq > 0,aArrayF3[nPosAliq][8],0)
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³ Implementacao NFE-BA                              ³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										R54->A54_ALQIPI	:= (cAliasSD2)->D2_IPI
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³ Implementacao do SEF PE                           ³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										R54->A54_IE	  	:= 	cIE
										R54->A54_EMISS	:= 	SF2->F2_EMISSAO
										R54->A54_UF 	:= 	cTranspEst
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³ Implementacao do PRODEPE                          ³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										If lSef .And. Val(aRetCfp[19][1]) == 1		//Industria
											aProdepe 		:= Prodepe(SB1->B1_COD,cAliasSF3)
											R54->A54_APUR	:= aProdepe[1]			//Codigo da Apuracao
											If aProdepe[1] > 1
												SefRegX35(aProdepe[1])					//Processa Registro 88-35-00
											Endif
		       							Endif
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³Implementacao do FUNCEP/PB³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										If lGimPB
											R54->A54_FUNCEP := 	cFuncep
										Endif
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³Sintegra-MG -> Informacoes de Substituicao Tributaria³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										//OBSERVACAO: ALIQUOTA SEMPRE SERA A MESMA GRAVADA NO SD1, POR ISSO O SEEK ACIMA SOMENTE TRATA DA ALIQICM
									 	R54->A54_DTEMI := aArrayF3[1][18]  // Data da Emissao 
										R54->A54_DTSAI := aArrayF3[1][10]  // Data da Entrada/Saida
										If (cAliasSD2)->D2_ICMSRET
											R54->A54_ALIQST := Iif(SB1->B1_PICM == 0,GetMV("MV_ICMPAD"),SB1->B1_PICM)
										Endif
									Else
										RecLock ("R54", .F.)
										
										lAglutinou := .T.
									EndIf
										R54->A54_QUANT	+=	(cAliasSD2)->D2_QUANT
										R54->A54_VALPRO	+=	(cAliasSD2)->D2_TOTAL+(cAliasSD2)->D2_DESCON
										R54->A54_VALDES	+=	(cAliasSD2)->D2_DESCON
										R54->A54_VALICM	+=	(cAliasSD2)->D2_VALICM
										R54->A54_ICMRET	+=	(cAliasSD2)->D2_ICMSRET
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³Verifica a referencia do item no SF3, para checar a base³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						  				nPos := aScan(aArrayF3,{|x| x[1]==(cAliasSD2)->D2_DOC .And. x[2]==(cAliasSD2)->D2_SERIE .And. x[3]==(cAliasSD2)->D2_CLIENTE .And. x[4]==(cAliasSD2)->D2_LOJA .And. x[5]==(cAliasSD2)->D2_CF .And. x[8]==(cAliasSD2)->D2_PICM})
						  				If nPos > 0
						  					nBsICMS := aArrayF3[nPos][19]	// F3_BASEICM
						  				Else                             
						  					nBsICMS := aArrayF3[1][19]		// F3_BASEICM
						  				Endif
						  				
										If SF4->F4_LFICM $ "IONZ" .And. Empty(nBsICMS)
											R54->A54_BSICM  +=	0
										Else
											R54->A54_BSICM  +=	(cAliasSD2)->D2_BASEICM
										EndIF
										R54->A54_BRICMS +=	(cAliasSD2)->D2_BRICMS
								
										R54->A54_VALIPI	+=  (cAliasSD2)->D2_VALIPI
									MsUnlock()
									//
									If (lMta56S)
								        Execblock("MTA56S",.F.,.F., {cAliasSD2, StrZero(nItem,3)})
									EndIf
									//
									If !lAglutinou
										nItem++								
									EndIf
								Endif
								//
								If (lValidaPr)
									If (AModNot(aArrayF3[1][7])=="01") .And. !(lServico)
										lGera75S	:=	.T.
									Else
										lGera75S	:=	.F.
									EndIf
								Else     
									lGera75S	:=	.T.
									If (AModNot(aArrayF3[1][7])=="01") .And. lServico
										lGera75S	:=	.F.
									Endif
								EndIf
								//
								If (lGera75S)
									If !(R75->(dbSeek(cSeek)))
										RecLock("R75",.T.)
										R75->A75_CTARE	:=	cContrTare
										R75->A75_DTAINI	:=	dDTIni
										R75->A75_DTAFIM	:=	dDTFim
										A940LoadPro("S",@cNcm,@cProd,,lSef)
										R75->A75_PROD  	:=  cProd
				  					    R75->A75_PRORI	:=SB1->B1_COD
				       					IF cNcm=="        "
									   	   R75->A75_CODNCM	:="00000000"
									    else
     									   R75->A75_CODNCM	:=cNcm
									    endif
				       					R75->A75_DESCR	:=	SB1->B1_DESC
										R75->A75_UM    	:=	SB1->B1_UM
										R75->A75_ALQIPI	:=	SB1->B1_IPI
										R75->A75_ALQICM	:=	nAliqICM
										
										If lSef
											If (cAliasSD2)->D2_ICMSRET > 0		//Substituicao Tributaria
												R75->A75_BRICMS :=	NoRound((cAliasSD2)->D2_BRICMS/(cAliasSD2)->D2_QUANT)
											Else
												R75->A75_BRICMS :=	0
											Endif
										Else
											R75->A75_BRICMS	:=	(cAliasSD2)->D2_BRICMS
										Endif								
										
										R75->A75_SITTRI	:=	cSitTrib
										R75->A75_REDBSE	:= nRedBase		//Reducao da Base do ICMS
										MsUnlock()
									Endif	
								EndIf
								
						   		If AModNot(aArrayF3[1][7]) $ "21,22" .And. aArrayF3[1][6] <> "L" //Notas Fiscais de Comunicacao/Telecomunicacao
							   		RecLock("R77",.T.)
									R77->A77_CNPJ  	:=	cCNPJ
									R77->A77_MODELO	:=	AModNot(aArrayF3[1][7])
									R77->A77_SERIE	:=	Substr((cAliasSD2)->D2_SERIE,1,1)
									R77->A77_SUBSER	:=  Substr((cAliasSD2)->D2_SERIE,2,2)
									R77->A77_NFISC	:=	(cAliasSD2)->D2_DOC  
									R77->A77_CFOP	:=	(cAliasSD2)->D2_CF   
									R77->A77_TIPREC	:= "1"
									R77->A77_NUMITE	:= StrZero(nItem,3)
									R77->A77_PRODUT	:= Left(cProd,11)
									R77->A77_QUANT	:= Iif(SF2->F2_TIPO$"C#P#I" .and. (cAliasSD2)->D2_QUANT == 0 ,1,(cAliasSD2)->D2_QUANT)
									R77->A77_VALPRO	:= (cAliasSD2)->D2_TOTAL+(cAliasSD2)->D2_DESCON
									R77->A77_VALDES	:= (cAliasSD2)->D2_DESCON
									R77->A77_BSICM	:= (cAliasSD2)->D2_BASEICM
									R77->A77_ALQICM	:= (cAliasSD2)->D2_PICM
									R77->A77_CNPJMF	:= SM0->M0_CGC
									R77->A77_CODTER	:= (cAliasSD2)->D2_CLIENTE
									R77->A77_CNORI  := cCNPJOri
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Implementacao do SEF PE                           ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									R77->A77_IE		:=	cIE
									R77->A77_DTEMIS	:=	SF2->F2_EMISSAO
									R77->A77_UF		:=	SF2->F2_EST
									R77->A77_CFOMOV	:=	(cAliasSD2)->D2_CF 
									MsUnlock()
									nItem++
			            		Endif
							Endif
		 		    	
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Implementacao do Convenio no.76 - 10.10.2003      ³
							//³ Grava Registro I61 - Resumo Mensal por Item       ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If lReg61I .And. AModNot(aArrayF3[1][7])$"02/04" .And. !(SF2->F2_TIPO$"C/P/I")
								If I61->(dbSeek(PADR(cProd,14)+Str((cAliasSD2)->D2_PICM,5,2)))
									RecLock("I61",.F.)
								Else
									RecLock("I61",.T.)
									I61->I61_MESANO	:= StrZero(Month((cAliasSD2)->D2_EMISSAO),2)+StrZero(Year((cAliasSD2)->D2_EMISSAO),4)	//Mes e Ano de Emissao "MMAAAA"
									I61->I61_CODPRO	:= cProd	//Codigo do Produto do Informante
									I61->I61_ALIQ	:= (cAliasSD2)->D2_PICM		//Aliquota do ICMS do Prod.
								Endif
								I61->I61_QUANT		+= (cAliasSD2)->D2_QUANT	//Qtde. Acum. do Prod. Vendida no Mes
								I61->I61_VLBRUTO	+= (cAliasSD2)->D2_TOTAL+(cAliasSD2)->D2_DESCON	///Vlr. Bruto Acum. na Venda do Prod. no Mes
								I61->I61_BCICMS		+= (cAliasSD2)->D2_BASEICM	//Base de Calculo do ICMS do Vlr. Acum. no Mes
								If lGimPB
									If ! Empty(cFuncep) .And. cFuncep == "1"
		                            	FUN->(dbGoTop())
		                            	If FUN->FUN_ICMS + FUN->FUN_STSAI == 0
		                            		RecLock("FUN",.T.)
		                            	Else                         
		                            		RecLock("FUN",.F.)
		                            	Endif                 
										FUN->FUN_ICMS	+=	(cAliasSD2)->D2_BASEICM
										FUN->FUN_STSAI	+=	Iif(Left((cAliasSD2)->D2_CF,1) == "5",(cAliasSD2)->D2_BRICMS,0)
										MsUnLock()
									Endif
								Endif
								MsUnlock()
							Endif
		 		    	Endif
		 		    	(cAliasSD2)->(dbSkip())
			 	    EndDo
				    If lQuery
		    		    dbSelectArea(cAliasSD2)
					    dbCloseArea()
			        EndIf 
			    EndIf	
			Endif
		    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		    //³Monta Registro Tipo 71 atraves de ponto de entrada³
		    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		    //³Somente gera registro tipo 71 para      ³
		    //³emitentes de conhecimento de transporte.³
		    //³Portanto somente Notas Fiscais de Saida.³
		    //³Devera gerar registros no arquivo       ³
		    //³R71 em funcao do registro lido no       ³
		    //³arquivo SF3.                            ³                                                                               ³
	  	    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		    If Substr(aArrayF3[1][5],1,1) >= "5" .And. aArrayF3[1][6] <> "L"
			    If lMtaTIP71
			        aArray71 := aClone(aArrayF3)
			        Execblock("MTATIP71",.F.,.F.,{,aArray71})
			    EndIf
		    EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		    //³Monta Registro Tipo 71 atraves da Integracao com TMS³
		    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If IntTms() .And. AModNot(aArrayF3[1][7])$"08/09/10/11/26"
			    DbSelectArea ("DTC")
			    DbSelectArea ("DT6")
				dbSetOrder(1)
				#IFDEF TOP
				    If TcSrvType()<>"AS/400"
					    cAliasDT6:= "A940aDT6"
					  	lQuery   := .T.
						aStruDT6 := DT6->(dbStruct())		
						cQuery := "SELECT * "
						cQuery += "FROM "
						cQuery += RetSqlName("DT6") + " DT6 "
						cQuery += "WHERE "
						cQuery += "DT6.DT6_FILIAL = '"+xFilial("DT6")+"' AND "
						cQuery += "DT6.DT6_FILDOC = '"+cFilAnt+"' AND "
			            cQuery += "DT6.DT6_DOC='"+aArrayF3[1][1]+"' AND "
					    cQuery += "DT6.DT6_SERIE='"+aArrayF3[1][2]+"' AND "
						cQuery += "DT6.D_E_L_E_T_ = ' ' "
						cQuery += "ORDER BY "+SqlOrder(DT6->(IndexKey()))
						
						cQuery := ChangeQuery(cQuery)
					    	
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasDT6)
							
						For nDT6 := 1 To Len(aStruDT6)
							If aStruDT6[nDT6][2] <> "C" .and.  FieldPos(aStruDT6[nDT6][1]) > 0
								TcSetField(cAliasDT6,aStruDT6[nDT6][1],aStruDT6[nDT6][2],aStruDT6[nDT6][3],aStruDT6[nDT6][4])
							EndIf
						Next nDT6
					Else
				#ENDIF	
						dbSelectArea(cAliasDT6)
						cIndex := CriaTrab(,.F.)
						cKey := IndexKey()	
						cFilter := 'DT6_FILIAL == "'+xFilial("DT6")+'" .And.'
						cFilter += 'DT6_FILDOC == "'+cFilAnt+'" .And.'
		                cFilter += 'DT6_DOC="'+aArrayF3[1][1]+'" .And.'
					    cFilter += 'DT6_SERIE="'+aArrayF3[1][2]+'" '
						IndRegua(cAliasDT6,cIndex,cKey,,cFilter,"Selecionando Registros...")
						dbGotop()
				#IFDEF TOP
					Endif
				#ENDIF	
				dbSelectArea(cAliasDT6)		
	
				While (cAliasDT6)->(!Eof())
	                If (Empty ((cAliasDT6)->DT6_FILDCO))
	                	cSeekDTC	:=	xFilial("DTC")+(cAliasDT6)->DT6_FILDOC+(cAliasDT6)->DT6_DOC+(cAliasDT6)->DT6_SERIE
					Else
						cSeekDTC	:=	xFilial("DTC")+(cAliasDT6)->DT6_FILDCO+(cAliasDT6)->DT6_DOCDCO+(cAliasDT6)->DT6_SERDCO
					EndIf
					//
	                dbSelectArea("DTC")
	                dbSetOrder(3)
	                If dbSeek(cSeekDTC)
	                	While DTC->(!Eof()) .And. cSeekDTC==DTC->DTC_FILIAL+DTC->DTC_FILDOC+DTC->DTC_DOC+DTC->DTC_SERIE
							cInscr	:= cIE
							cSeqIns	:= ""
				   			Do Case
				   				Case DTC->DTC_DEVFRE == "1" .And. !Empty(DTC->DTC_SQIREM)
				   					cSeqIns := DTC->DTC_SQIREM
				   				Case DTC->DTC_DEVFRE == "2" .And. !Empty(DTC->DTC_SQIDES)
				   					cSeqIns := DTC->DTC_SQIDES
				   				Case DTC->DTC_DEVFRE == "3" .And. DTC->(FieldPos("DTC_SQICON")) > 0 .And. !Empty(DTC->DTC_SQICON)
				   					cSeqIns := DTC->DTC_SQICON
				   				Case DTC->DTC_DEVFRE == "4" .And. DTC->(FieldPos("DTC_SQIDPC")) > 0 .And. !Empty(DTC->DTC_SQIDPC)
				   					cSeqIns := DTC->DTC_SQIDPC
				   			EndCase
				   			If !Empty(cSeqIns)
				   				cInscr := Posicione("DV3",1,xFilial("DV3")+(cAliasDT6)->DT6_CLIDEV+(cAliasDT6)->DT6_LOJDEV+cSeqIns,"DV3_INSCR")
				   			Endif
						   	Reclock("R71",.T.)
						   	R71->A71_CGCTOM := cCNPJ	//SA1->A1_CGC
							R71->A71_IETOM  := aRetDig(cInscr,.T.)
							R71->A71_DTCONH := (cAliasDT6)->DT6_DATEMI
							R71->A71_UFTOM  := cTranspEst	//SA1->A1_EST
							R71->A71_MODCON := AModNot(aArrayF3[1][7])
							R71->A71_SERCON := Left((cAliasDT6)->DT6_SERIE,1)
							R71->A71_SUBCON := Substr((cAliasDT6)->DT6_SERIE,2,2)
							R71->A71_NUMCON := (cAliasDT6)->DT6_DOC
							//
							cInscrDest	:= ""         
						    SA1->(dbSeek(xFilial("SA1")+(cAliasDT6)->DT6_CLIREM+(cAliasDT6)->DT6_LOJREM))
						   	If DTC->DTC_DEVFRE == "1" .And. !Empty(DTC->DTC_SQIREM) .And. !Empty(DTC->DTC_SQIDES)  .And. cSeqIns==DTC->DTC_SQIREM                          
						   	 	cInscrDest := Posicione("DV3",1,xFilial("DV3")+(cAliasDT6)->DT6_CLIDEV+(cAliasDT6)->DT6_LOJDEV+DTC->DTC_SQIDES,"DV3_INSCR")
						   	ElseIf DTC->DTC_DEVFRE == "2" .And. !Empty(DTC->DTC_SQIDES) .And. !Empty(DTC->DTC_SQIREM) .And. cSeqIns=DTC->DTC_SQIDES    
						   	 	cInscrDest := Posicione("DV3",1,xFilial("DV3")+(cAliasDT6)->DT6_CLIDEV+(cAliasDT6)->DT6_LOJDEV+DTC->DTC_SQIREM,"DV3_INSCR")
				   			ElseIf!Empty(DTC->DTC_SQIREM)
							   	cInscrDest := Posicione("DV3",1,xFilial("DV3")+(cAliasDT6)->DT6_CLIDEV+(cAliasDT6)->DT6_LOJDEV+cSeqIns,"DV3_INSCR")
							Else
								cInscrDest := SA1->A1_INSCR	
							EndIf
							                        
							R71->A71_UFREM  := SA1->A1_EST
							R71->A71_CGCREM := SA1->A1_CGC
							R71->A71_IEREM  := aRETDIG(cInscrDest,.T.)
							R71->A71_DTNOTA := DTC->DTC_EMINFC
							R71->A71_MODNOT := "01"
							R71->A71_SERNOT := DTC->DTC_SERNFC
							R71->A71_NUMNOT := DTC->DTC_NUMNFC
							R71->A71_VALNOT := DTC->DTC_VALOR
							MsUnlock()
							If lMtReg71
								Execblock("MTREG71",.f.,.f.)
							Endif
							DTC->(dbSkip())	
						EndDo	
					Endif
					(cAliasDT6)->(dbSkip())
				EndDo
			    If lQuery
				    dbSelectArea(cAliasDT6)
					dbCloseArea()
				Else
	    		   	dbSelectArea("DT6")
					RetIndex("DT6")
					dbClearFilter()
					Ferase(cIndex+OrdBagExt())
				Endif	
		    Endif
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Monta Registro Tipo 76³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	   		For nI := 1 To Len(aArrayF3)
		   		If AModNot(aArrayF3[nI][7]) $ "21,22" .And. aArrayF3[nI][6] <> "L" .And. Substr(aArrayF3[nI][5],1,1) >= "5" //Notas Fiscais de Comunicacao/Telecomunicacao
					If lSef .And. !Empty(aArrayF3[nI][13])
			   			RecLock("R76",.T.)
						R76->A76_MODELO	:=	AModNot(aArrayF3[nI][7])
						R76->A76_SERIE	:=	Substr(aArrayF3[nI][2],1,1)
						R76->A76_SUBSER	:=	Substr(aArrayF3[nI][2],2,2)
						R76->A76_NFISC	:=	aArrayF3[nI][1]
						R76->A76_EMISS	:=	aArrayF3[nI][10]
						If lSintegMG
							R76->A76_UF :=	cTranspEst
						Endif
						R76->A76_CFOP	:=	aArrayF3[nI][5]
						R76->A76_SITUAC	:=	"S"
						R76->A76_CFOMOV	:=	aArrayF3[nI][5]
						MsUnlock()
					Else
		   				RecLock("R76",.T.)
						R76->A76_CNPJ  	:=	cCNPJ
						R76->A76_IE		:=  cIE
						R76->A76_MODELO	:=	AModNot(aArrayF3[nI][7])
						R76->A76_SERIE	:=	Substr(aArrayF3[nI][2],1,1)
						R76->A76_SUBSER	:=  Substr(aArrayF3[nI][2],2,2)
						R76->A76_NFISC	:=	aArrayF3[nI][1]
						R76->A76_CFOP	:=	aArrayF3[nI][5]
						R76->A76_TIPREC	:= "1"
						R76->A76_EMISS	:=	aArrayF3[nI][10]
						R76->A76_UF		:=	cTranspEst
						R76->A76_VALTOT	:=	aArrayF3[nI][17]
						R76->A76_BRICMS	:=	aArrayF3[nI][19]
						R76->A76_VALICM	:=	aArrayF3[nI][16]
						R76->A76_ISENTA	:=	aArrayF3[nI][12]
						R76->A76_OUTRAS	:=	aArrayF3[nI][15]
						R76->A76_ALQICM	:=	aArrayF3[nI][8]
						R76->A76_SITUAC	:=	IIf(("CANCELAD"$aArrayF3[nI][20] .Or.!empty(aArrayF3[nI][13])),"S","N")
						R76->A76_CNORI	:=	cCNPJOri
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Implementacao do SEF PE                                    ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						R76->A76_CODIGO	:=	aArrayF3[nI][3]
						R76->A76_LOJA	:=	aArrayF3[nI][4]
						R76->A76_CFOMOV	:=	aArrayF3[nI][5]
						MsUnlock()
					Endif
		   		Endif
			Next
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Gravacao do registro 50                                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For nI := 1 To Len(aArrayF3)
				If (Empty(aArrayF3[nI][7]) .Or.;
			    	AModNot(aArrayF3[nI][7])$"01/06/21/22"+IIf(lNfProd,"/04","")) .And.;
			    	aArrayF3[nI][6] <> "L" .And. (Empty(cCfopPR) .Or. !(Alltrim(aArrayF3[nI][5])$cCfopPR))
			    	//
	                If (l52Tare)
						//
						SA1->(DbSetOrder (1)) 
						SA1->(MsSeek (xFilial ("SA1")+aArrayF3[nI][03]+aArrayF3[nI][04]))
						//    
						SD1->(DbSetOrder (1))
						SD1->(MsSeek (xFilial ("SD1")+aArrayF3[nI][01]+aArrayF3[nI][02]+SA1->A1_COD+SA1->A1_LOJA))
						//                      
						Do While !SD1->(Eof ()) .And. xFilial("SD1")==SD1->D1_FILIAL .And. aArrayF3[nI][01]==SD1->D1_DOC .And.;
							aArrayF3[nI][02]==SD1->D1_SERIE .And. SA1->A1_COD==SD1->D1_FORNECE .And. SA1->A1_LOJA==SD1->D1_LOJA
							//
							If (!Empty (SD1->D1_NFORI) .And. !Empty (SD1->D1_SERIORI) .And. !Empty (SD1->D1_ITEMORI))
								SF2->(DbSetorder (1)) 
								SF2->(MsSeek (xFilial ("SF2")+SD1->D1_NFORI+SD1->D1_SERIORI+SA1->A1_COD+SA1->A1_LOJA))
								//     
								SD2->(DbSetOrder (3)) 
								SD2->(MsSeek (xFilial ("SD2")+SD1->D1_NFORI+SD1->D1_SERIORI+SA1->A1_COD+SA1->A1_LOJA))
								//
								Do While !SD2->(Eof ()) .And. xFilial ("SD2")==SD2->D2_FILIAL .And. SD1->D1_NFORI==SD2->D2_DOC .And.;
									SD1->D1_SERIORI==SD2->D2_SERIE .And. SA1->A1_COD==SD2->D2_CLIENTE .And. SA1->A1_LOJA==SD2->D2_LOJA
									//
									If (StrZero (Val(SD2->D2_ITEM), 2, 0)==StrZero (Val (SD1->D1_ITEMORI), 2, 0))
										If (R52->(MsSeek (cCNPJ+aArrayF3[nI][1]+aArrayF3[nI][2]+AllTrim (aArrayF3[nI][5])+StrZero (aArrayF3[nI][8], 5, 2))))
										   RecLock ("R52", .F.)
										Else
										   RecLock ("R52", .T.)
											 	R52->A52_CNPJ	:=	cCNPJ
												R52->A52_IE		:=	cIE
												R52->A52_EMISS	:=	aArrayF3[nI][10]
												R52->A52_UF		:=	aArrayF3[nI][22]
												R52->A52_MODELO	:=	AModNot(aArrayF3[nI][7])
												R52->A52_SERIE	:=	aArrayF3[nI][2]
												R52->A52_NFISC	:=	aArrayF3[nI][1]
											 	R52->A52_CFOP	:=	aArrayF3[nI][5]
												R52->A52_ALQ	:=	aArrayF3[nI][8]
											 	R52->A52_BSCALC	:=	aArrayF3[nI][19]
												R52->A52_VLRICM	:=	aArrayF3[nI][16]
											 	R52->A52_MODDEV	:=	AModNot(SF2->F2_ESPECIE)
											 	R52->A52_SERDEV	:=	SD2->D2_SERIE
											  	R52->A52_NFIDEV := 	SD2->D2_DOC
												R52->A52_CFODEV	:=	SD2->D2_CF
												R52->A52_ALQDEV	:=	SD2->D2_PICM 
												R52->A52_CNORI	:=	cCNPJOri
										EndIf
											R52->A52_VLRTOT	+=	SD1->D1_TOTAL
										MsUnlock ()
										//
										Exit
									EndIf
									//
									SD2->(DbSkip ())
								EndDo
							EndIf
							//
							SD1->(DbSkip ())
						EndDo
					ElseIf !(AModNot(aArrayF3[nI][7])$"21/22" .And. Left(aArrayF3[nI][5],1)>="5")
					    If ((cChaveAux == aArrayF3[nI][24] .Or. nI==1) .Or. (cCfoAux<>aArrayF3[nI][05]) .Or. (cChaveAux2 <> aArrayF3[nI][08]))
					    	If !Empty(aArrayF3[nI][13])
					    		If nI==1
								    RecLock("R50",.T.)
								    R50->A50_EMISS  :=	aArrayF3[nI][10]
									If lSintegMG
										R50->A50_UF     :=	aArrayF3[nI][22]	
									Endif
									R50->A50_MODELO :=  AModNot(aArrayF3[nI][7])
									R50->A50_SERIE  :=	aArrayF3[nI][2]
									R50->A50_NFISC  :=	aArrayF3[nI][1]
									R50->A50_CFOP   :=	IIf(lSef,aArrayF3[nI][5],"")
									R50->A50_EMIT   :=	IIf(lSef,"",IIf(aArrayF3[nI][21]=="S".Or.SubStr(aArrayF3[nI][5],1,1)>="5","P","T"))
									R50->A50_SITUAC :=	"S"
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³Campos para o layout SAPI³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									R50->A50_CLIFOR	:=	aArrayF3[nI][3]
									R50->A50_LOJCF	:=	aArrayF3[nI][4]
									R50->A50_TIPO	:=	aArrayF3[nI][6]
									R50->A50_CFOMOV	:=	aArrayF3[nI][5]
									MsUnlock()
								Endif
						    Else    
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Verifica se ja nao existe um registro 50 com as mesmas caracteristicas. Se existir,  ³
								//³acumula os valores, para atender a situacoes em que se utilizem livros distintos nos ³
								//³itens de uma mesma nota fiscal.                                                      ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								R50->(dbSetOrder(3))
								If !R50->(dbSeek(cCNPJ+aArrayF3[nI][1]+aArrayF3[nI][2]+SubStr(aArrayF3[nI][5],1,4)+StrZero(aArrayF3[nI][8],5,2)))
								    RecLock("R50",.T.)
								    R50->A50_CNPJ   := cCNPJ
								    R50->A50_IE     :=	cIE
								    R50->A50_EMISS  :=	aArrayF3[nI][10]
								    R50->A50_UF     :=	aArrayF3[nI][22]
									R50->A50_MODELO :=  AModNot(aArrayF3[nI][7])
									R50->A50_SERIE  :=	aArrayF3[nI][2]
									R50->A50_NFISC  :=	aArrayF3[nI][1]
									R50->A50_CFOP   :=	aArrayF3[nI][5]
									R50->A50_EMIT   :=	IIf(aArrayF3[nI][21]=="S".Or.SubStr(aArrayF3[nI][5],1,1)>="5","P","T")
									R50->A50_ALQICM :=	aArrayF3[nI][8]
					                R50->A50_ALQINT :=	GrvAliq(aArrayF3,nI)
									R50->A50_SITUAC :=	IIf(("CANCELAD"$aArrayF3[nI][20] .Or.!Empty(aArrayF3[nI][13])),"S","N")
									R50->A50_CLIENT :=	aArrayF3[nI][3]
									R50->A50_LOJA   :=	aArrayF3[nI][4]
									R50->A50_CNORI  :=	cCNPJOri
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³Campos para o layout SAPI³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									R50->A50_CLIFOR	:=	aArrayF3[nI][3]
									R50->A50_LOJCF	:=	aArrayF3[nI][4]
									R50->A50_TIPO	:=	aArrayF3[nI][6]
									R50->A50_CFOMOV	:=	aArrayF3[nI][5]
									//
									If lSef  .Or. lGimPB
										For nY := 1 To Len(aArrayF3)
											If (!Empty(aArrayF3[nY][20]) .And. !(Alltrim(aArrayF3[nY][20])$cDescObs)) .Or. !Empty(aArrayF3[nY][24])
												If !Empty(aArrayF3[nY][20])
													cObs := aArrayF3[nY][20]
												Endif
												If !Empty(aArrayF3[nY][24])
													cObs := Formula(aArrayF3[nY][24])
												Endif
												lObs := .T.
												Exit
											Endif
										Next
									Endif
		
									If lObs .Or. ;
										((lImpSt .And. Left(aArrayF3[nI][05],1)<"5" .And. aArrayF3[nI][11]>0) .Or. ;
										(lImpSt .And. Left(aArrayF3[nI][05],1)<"5" .And. aArrayF3[nI][30]>0))
										If nI == 1
											R50->A50_OBS 	:= ++nR50Obs
											R50->A50_OBSERV	:= cObs
											If lImpSt .And. Left(aArrayF3[nI][05],1)<"5" .And. aArrayF3[nI][11]>0	//F3_ICMSRET - Imposto Retido
												R50->A50_OBSERV	:= "BASE ICMS RET: "+Alltrim(Transform(aArrayF3[nI][29],"@E 999,999,999.99")) + " / ICMS RETIDO: " + Alltrim(Transform(aArrayF3[nI][11], "@E 999,999,999.99"))
											Endif
											If lImpSt .And. Left(aArrayF3[nI][05],1)<"5" .And. aArrayF3[nI][30]>0	//F3_IPIOBS
												R50->A50_OBSERV	:= "IPI: "+Alltrim(Transform(aArrayF3[nI][30],"@E 999,999,999.99"))+IIf(!Empty(R50->A50_OBSERV)," / "+Alltrim(R50->A50_OBSERV),"")
		                                    Endif
										ElseIf nI > 1
											R50->A50_OBS	:= nR50Obs
										Endif
									Endif
									MsUnlock()     
								Endif
					    	Endif
						Endif	
				    	If Empty(aArrayF3[nI][13])
							RecLock("R50",.F.)
							lCompIcms := .F.	//Complemento de ICMS
					    	If (Left (aArrayF3[nI][5], 1)>="5")
					    		SF2->(DbSetOrder (1))
								If (SF2->(DbSeek (xFilial ("SF2")+aArrayF3[nI][1]+aArrayF3[nI][2]+aArrayF3[nI][3]+aArrayF3[nI][4])))
									If SF2->F2_TIPO == "I"
										lCompIcms := .T.
									EndIf
								EndIf
							Else
					    		SF1->(DbSetOrder (1))
								If (SF1->(DbSeek (xFilial ("SF1")+aArrayF3[nI][1]+aArrayF3[nI][2]+aArrayF3[nI][3]+aArrayF3[nI][4])))
									If SF1->F1_TIPO == "I"
										lCompIcms := .T.
									EndIf
								EndIf
							EndIf
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Se a NF for de Complemento de ICMS, outros valores deverao  ³
							//³ estar zerados (Conforme consulta no Posto Fiscal)           ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							R50->A50_VALTOT +=	IIf(lCompIcms,0,aArrayF3[nI][17])
							R50->A50_BSICM  +=	IIf(lCompIcms,0,aArrayF3[nI][19])
							If GETMV("MV_ESTADO")=="MG"
							   If lCompIcms .And. aArrayF3[nI][15]>0
							      R50->A50_VALICM +=	0						   
							   Else
							      R50->A50_VALICM +=	IIf(lCompIcms,aArrayF3[nI][12]+aArrayF3[nI][15]+aArrayF3[nI][16],aArrayF3[nI][16])
							   Endif
							Else
							   R50->A50_VALICM +=	IIf(lCompIcms,aArrayF3[nI][12]+aArrayF3[nI][15]+aArrayF3[nI][16],aArrayF3[nI][16])
							Endif   
							R50->A50_ISENTO +=	IIf(lCompIcms,0,aArrayF3[nI][12])
							If GETMV("MV_ESTADO")=="MG"
							   If lCompIcms .And. aArrayF3[nI][15]>0
		 						  R50->A50_OUTRAS +=	aArrayF3[nI][15]
		 					   Else	  
		 						  R50->A50_OUTRAS +=	IIf(lCompIcms,0,aArrayF3[nI][15])
		 					   Endif	                                          
		 					Else
	 						   R50->A50_OUTRAS +=	IIf(lCompIcms,0,aArrayF3[nI][15])
		 					Endif   
							R50->A50_DESPES +=	IIf(lCompIcms,0,aArrayF3[nI][23])
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Implementacao do SEF PE                                     ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							R50->A50_CODIGO	:= aArrayF3[nI][3]
							R50->A50_LOJA	:= aArrayF3[nI][4]
							R50->A50_NOME	:= cRazSoc
							If lSef .And. Left(aArrayF3[nI][5],1)<"5"
								R50->A50_DTOPER	:= aArrayF3[nI][18]		//F3_EMISSAO
							Endif
							MsUnlock()
						Endif
					Endif
	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Implementacao do Sintegra MG - Registro Tipo 88A            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lSintegMG
						If !Empty(aArrayF3[nI][Len(aArrayF3[nI])])	//NF de Empenho
							GravaMG88A(aArrayF3,cCNPJ,cIE,cChaveAux,cCfoAux,cChaveAux2,nI)
						Endif
					Endif
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Gravacao do registro 51                                                ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If (Empty(aArrayF3[nI][7]) .Or. AModNot(aArrayF3[nI][7])=="01") .And.;
						(aArrayF3[nI][25]+aArrayF3[nI][26]+aArrayF3[nI][27])>0 .And. ;
						aArrayF3[nI][6] <> "L" .And. Empty(aArrayF3[nI][13]) .And. (!AllTrim (aArrayF3[nI][05])$cR51CFOP)
	
						If (nI==1 .Or. cCfoAux<>aArrayF3[nI][05]) .Or. R51->(Eof() .Or. R51->A51_CNPJ	 <>	cCNPJ .Or. R51->A51_IE <> cIE .Or.;
							R51->A51_SERIE <> aArrayF3[nI][02] .Or. R51->A51_NFISC	<> aArrayF3[nI][01] 	)
							RecLock("R51",.T.)
							R51->A51_CNPJ	:=	cCNPJ
						  	R51->A51_IE		:=	cIE
							R51->A51_EMISS	:=	aArrayF3[nI][10]
							R51->A51_UF		:=	aArrayF3[nI][22]
							R51->A51_SERIE	:=	aArrayF3[nI][02]
							R51->A51_NFISC	:=	aArrayF3[nI][01]
							R51->A51_CFOP	:=	aArrayF3[nI][05]
						    R51->A51_SITUAC	:=	IIf(("CANCELAD"$aArrayF3[nI][20] .Or.!empty(aArrayF3[nI][13])),"S","N")
						    R51->A51_CNORI	:=	cCNPJOri
						Endif
		   				RecLock("R51",.F.)
						R51->A51_VALTOT	+=	aArrayF3[nI][17]
						R51->A51_VALIPI	+=	aArrayF3[nI][25]
						R51->A51_ISENTA	+=	aArrayF3[nI][26]
						R51->A51_OUTRAS	+=	aArrayF3[nI][27]
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Implementacao do SEF PE                                     ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						R51->A51_BASIPI	+=	aArrayF3[nI][28]				   
						MsUnlock()
					Endif
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Gravacao do registro 53                                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If 	(aArrayF3[nI][29]+aArrayF3[nI][11]) > 0 .And.;
					aArrayF3[nI][06] <> "L" .And. !(AModNot(aArrayF3[nI][07])$"07#08#09#10#11#26") .And.;
					Empty(aArrayF3[nI][13])
					If !R53->(dbSeek(cCNPJ+aArrayF3[nI][1]+aArrayF3[nI][2]+aArrayF3[nI][05]))
					   RecLock("R53",.T.)
					   R53->A53_CNPJ  	:=	cCNPJ
					   R53->A53_IE		:=  cIE
					   R53->A53_EMISS	:=	aArrayF3[nI][10]
					   R53->A53_UF		:=	aArrayF3[nI][22]
					   R53->A53_MODELO	:=	AModNot(aArrayF3[nI][07])
					   R53->A53_SERIE	:=	aArrayF3[nI][02]
					   R53->A53_NFISC	:=	aArrayF3[nI][01]
					   R53->A53_CFOP	:=	aArrayF3[nI][05]
					   R53->A53_EMIT   :=	IIf(aArrayF3[nI][21]=="S".Or.SubStr(aArrayF3[nI][05],1,1)>="5","P","T")
					   R53->A53_SITUAC :=	IIf(("CANCELAD"$aArrayF3[nI][20] .Or.!empty(aArrayF3[nI][13])),"S","N")
					   R53->A53_CNORI	:=	cCNPJOri
	                Else
				       RecLock("R53",.F.)
				    Endif   
				    R53->A53_BRICMS +=	aArrayF3[nI][29]				
				    If lImpSt .And. Left(aArrayF3[nI][05],1)<"5" .And. aArrayF3[nI][11]>0	//F3_ICMSRET - Imposto Retido
				       R53->A53_VALRET	:=	0
				    Else
				       R53->A53_VALRET +=	aArrayF3[nI][11]
				    Endif					
				    R53->A53_DESPES +=	aArrayF3[nI][23]
				    MsUnlock()
				EndIf	
			    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			    //³Grava Registro Tipo 61³
			    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				GrvReg61(aArrayF3,nI,lConv76,lNfProd,lSef)
		    	
		    	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Monta Registro Tipo 70 - SINTEGRA e SEF              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				//Esse if serve para alimentaR a string cModNF com os devidos modelos de  
				//nota fiscal para geracao da SEF ou SINTEGRA
				If lSef
					cModNF := "01/07/08/09/10/11"
				else
					cModNF := "01/07/08/09/10/11/26"
				endif
				
				If  AModNot(aArrayF3[nI][7])$cModNF .And. aArrayF3[nI][6]<>"L"
					If  lSef .And. !Empty(aArrayF3[1][13]) .And. AModNot(aArrayF3[1][7])<>"01"
						RecLock("R70",.T.)
						R70->A70_EMISS	:=	aArrayF3[1][10]
						If lSintegMG
							R70->A70_UF :=	cTranspEst	
						Endif
						R70->A70_MODELO	:=	AModNot(aArrayF3[1][7])
						R70->A70_SERIE	:=	Substr(aArrayF3[1][2],1,1)
						R70->A70_SUBSER	:=  Substr(aArrayF3[1][2],2,2)
						R70->A70_NFISC	:=	aArrayF3[1][1]
						R70->A70_CFOP	:=	aArrayF3[1][5]
						R70->A70_SITUAC	:=	"S"
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Campos para o layout SAPI³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						R70->A70_CLIFOR	:=	aArrayF3[nI][3]
						R70->A70_LOJCF	:=	aArrayF3[nI][4]
						R70->A70_TIPO	:=	aArrayF3[nI][6]
						R70->A70_CFOMOV	:=	aArrayF3[1][5]
						MsUnlock()
					Else
						If AModNot(aArrayF3[nI][7])<>"01" .Or.;
						   (AModNot(aArrayF3[nI][7])=="01" .And. Alltrim(aArrayF3[nI][5])$cCfopPR)
							If (nI==1 .Or. cCfoAux<>aArrayF3[nI][05]) .Or. R70->(Eof())
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Checando se frete CIF ou FOB         ³
								//³- com valor de frete na NF = 1 - CIF ³
								//³- sem valor de frete na NF = 2 - FOB ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							    cTpFrete := "1"
								If substr(aArrayF3[nI][5],1,1)<"5"
								    SF1->( dbSetOrder(1) )
									SF1->( MsSeek(F3Filial("SF1",cAliasSF3)+aArrayF3[nI][1]+aArrayF3[nI][2]+aArrayF3[nI][3]+aArrayF3[nI][4]))
									If SF1->F1_FRETE = 0
								    	cTpFrete := "1"
									Endif
									If SF1->F1_FRETE = 0 .And. SF1->F1_ORIGLAN=="F " .And. SF1->F1_TIPO=="C" //NF Conhecimento Frete
										cTpFrete := "2"
									Endif
								Else
						    		SF2->( dbSetOrder(1) )
									SF2->( MsSeek(F3Filial("SF2",cAliasSF3)+aArrayF3[nI][1]+aArrayF3[nI][2]+aArrayF3[nI][3]+aArrayF3[nI][4]))
									If SF2->F2_FRETE = 0
								    	cTpFrete := "1"
									Endif
								Endif
		
								RecLock("R70",.T.)
						   		R70->A70_CNPJ	:= 	cTranspCGC
							    R70->A70_IE		:=	IIF(IntTms() .And. AModNot(aArrayF3[1][7])$"08/09/10/11/26",Iif(!Empty(cInscr),cInscr,cTranspIns),cTranspIns)
								R70->A70_EMISS	:=	aArrayF3[nI][10]
								R70->A70_UF		:=	cTranspEst
								R70->A70_MODELO	:=	AModNot(aArrayF3[nI][7])
								R70->A70_SERIE	:=	Substr(aArrayF3[nI][2],1,1)
								R70->A70_SUBSER	:=  Substr(aArrayF3[nI][2],2,2)
								R70->A70_NFISC	:=	aArrayF3[nI][1]
								R70->A70_CFOP	:=	aArrayF3[nI][5]
								R70->A70_CIfFOB	:=	cTpFrete
								R70->A70_SITUAC	:=	IIf(("CANCELAD"$aArrayF3[nI][20] .Or.!empty(aArrayF3[nI][13])),"S","N")
								R70->A70_CNORI	:= 	cTranspOri
								R70->A70_NOME	:=	cRazSoc
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Campos para o layout SAPI³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								R70->A70_CLIFOR	:=	aArrayF3[nI][3]
								R70->A70_LOJCF	:=	aArrayF3[nI][4]
								R70->A70_TIPO	:=	aArrayF3[nI][6]
								R70->A70_CFOMOV	:=	aArrayF3[nI][5]
								If Substr(aArrayF3[1][5],1,1)<"5"					
									R70->A70_DTOP	:=	aArrayF3[1][18]		//Somente Entrada - Data Emissao
								Endif				
								R70->A70_ALQICM	:=	aArrayF3[1][8]
							Endif	
							RecLock("R70",.F.)
							R70->A70_VALTOT	+=	aArrayF3[nI][17]
							R70->A70_BSICM	+=	aArrayF3[nI][19]
							R70->A70_VALICM	+=	aArrayF3[nI][16]
							R70->A70_ISENTA	+=	aArrayF3[nI][12]
							R70->A70_OUTRAS	+=	aArrayF3[nI][15]
							MsUnlock()
						Endif
					EndIf
				EndIf
				cChaveAux  := aArrayF3[nI][24]
				cChaveAux2 := aArrayF3[nI][08]
				cCfoAux    := aArrayF3[nI][05]
			Next
			aArrayF3  	:= {}
			cChaveAux 	:= ""
			cChaveAux2	:= ""		
			cCfoAux   	:= ""
			lObs	  	:= .F.
			cObs	  	:= ""
		Endif
		dbSelectArea(cAliasSF3)
	EndDo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se a UF do parametro e a mesma da empresa corrente  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	If !Empty(cEstDest) .And. SM0->M0_ESTENT <> cEstDest .And. MV_PAR21<>3
	    lCupom := .F.	//Se o estado for diferente do parametro nao pode ser gerado os registros tipo 60
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta Registro Tipo 60³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SFI->(LastRec()) > 0 .And. mv_par05 <> 4 .And. lCupom .And. mv_par11 <> 1
		dbSelectArea("SFI")              
		dbSetOrder(1)
		#IFDEF TOP
		    If TcSrvType()<>"AS/400"
			    cAliasSFI:= "A940aSFI"
			  	lQuery   := .T.
				aStruSFI := SFI->(dbStruct())		
				cQuery := "SELECT * "
				cQuery += "FROM "
				cQuery += RetSqlName("SFI") + " SFI "
				cQuery += "WHERE "
				cQuery += "SFI.FI_FILIAL = '"+xFilial("SFI")+"' AND "
				cQuery += "SFI.FI_DTMOVTO>='"+Dtos(dDtIni)+"' AND "
				cQuery += "SFI.FI_DTMOVTO<='"+Dtos(dDtFim)+"' AND "
				cQuery += "SFI.D_E_L_E_T_ = ' ' "
				cQuery += "ORDER BY "+SqlOrder(SFI->(IndexKey()))
				
				cQuery := ChangeQuery(cQuery)
			    	
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSFI)
				
				For nSFI := 1 To Len(aStruSFI)
					If aStruSFI[nSFI][2] <> "C" .and.  FieldPos(aStruSFI[nSFI][1]) > 0
						TcSetField(cAliasSFI,aStruSFI[nSFI][1],aStruSFI[nSFI][2],aStruSFI[nSFI][3],aStruSFI[nSFI][4])
					EndIf
				Next nSFI
			Else
		#ENDIF	
				dbSelectArea(cAliasSFI)
				cIndex := CriaTrab(,.F.)
				cKey := IndexKey()	
				cFilter := 'FI_FILIAL == "'+xFilial("SFI")+'" .And. (Dtos(FI_DTMOVTO) >= "'+Dtos(dDtIni)+'" .And. Dtos(FI_DTMOVTO) <= "'+Dtos(dDtFim)+'")'
				IndRegua(cAliasSFI,cIndex,cKey,,cFilter,"Selecionando Registros...")
				dbGotop()
		#IFDEF TOP
			Endif
		#ENDIF	
		dbSelectArea(cAliasSFI)		
	
		While (cAliasSFI)->(!Eof())
			If !M60->(MsSeek(DTOS((cAliasSFI)->FI_DTMOVTO)+StrZero(Val((cAliasSFI)->FI_PDV),3)))
				RecLock("M60",.T.)
				M60->M60_EMISS  := (cAliasSFI)->FI_DTMOVTO
				M60->M60_NUMFAB := (cAliasSFI)->FI_SERPDV
				M60->M60_PDV    := STRZERO(VAL((cAliasSFI)->FI_PDV),3)
				M60->M60_MODELO := "2D" 
				M60->M60_NUMINI := (cAliasSFI)->FI_NUMINI
				M60->M60_NUMFIM := (cAliasSFI)->FI_NUMFIM														
				M60->M60_REDUCZ := (cAliasSFI)->FI_NUMREDZ
				M60->M60_CRO   	:= IIF((cAliasSFI)->(FieldPos("FI_CRO"))>0,Val(PADR(SFI->FI_CRO,3)),0)
				M60->M60_VENDA 	:= (cAliasSFI)->FI_VALCON+(cAliasSFI)->FI_DESC+(cAliasSFI)->FI_CANCEL+IIF((cAliasSFI)->(FieldPos("FI_ISS"))>0,(cAliasSFI)->FI_ISS,0)
			    M60->M60_GERAL	:= (cAliasSFI)->FI_GTFINAL
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Implementacao SEF PE                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				M60->M60_GTINI	:= (cAliasSFI)->FI_GTINI
				M60->M60_VLIQ	:= (cAliasSFI)->FI_VALCON
				M60->M60_OBS	:= 0
				MsUnlock()
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Totaliza cupons fiscais pela Situacao Tributaria             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If (cAliasSFI)->FI_SUBTRIB > 0
					RecLock("A60",.T.)
					A60->A60_EMISS	:=	(cAliasSFI)->FI_DTMOVTO
					A60->A60_NUMFAB	:=	(cAliasSFI)->FI_SERPDV
					A60->A60_SITTRI	:=	"F"
					A60->A60_VALOR	:=	(cAliasSFI)->FI_SUBTRIB
					MsUnlock()
				EndIf
				If (cAliasSFI)->FI_ISENTO >0
				  	RecLock("A60",.T.)
					A60->A60_EMISS	:=	(cAliasSFI)->FI_DTMOVTO
					A60->A60_NUMFAB	:=	(cAliasSFI)->FI_SERPDV
					A60->A60_SITTRI	:=	"I"
					A60->A60_VALOR	:=	(cAliasSFI)->FI_ISENTO
					MsUnlock()
				EndIf
				If (cAliasSFI)->FI_CANCEL >0
					RecLock("A60",.T.)
					A60->A60_EMISS	:=	(cAliasSFI)->FI_DTMOVTO
					A60->A60_NUMFAB	:=	(cAliasSFI)->FI_SERPDV
					A60->A60_SITTRI	:=	"CANC"
					A60->A60_VALOR	:=	(cAliasSFI)->FI_CANCEL
					MsUnlock()
				EndIf         
				If (cAliasSFI)->FI_NTRIB >0
					RecLock("A60",.T.)
					A60->A60_EMISS	:=	(cAliasSFI)->FI_DTMOVTO
					A60->A60_NUMFAB	:=	(cAliasSFI)->FI_SERPDV
					A60->A60_SITTRI	:=	"N"
					A60->A60_VALOR	:=	(cAliasSFI)->FI_NTRIB
					MsUnlock()
				EndIf    
				If (cAliasSFI)->FI_DESC >0
					RecLock("A60",.T.)
					A60->A60_EMISS	:=	(cAliasSFI)->FI_DTMOVTO
					A60->A60_NUMFAB	:=	(cAliasSFI)->FI_SERPDV
					A60->A60_SITTRI	:=	"DESC"
					A60->A60_VALOR	:=	(cAliasSFI)->FI_DESC
					MsUnlock()
				EndIf
				If (cAliasSFI)->(FieldPos("FI_ISS")) > 0 .And. (cAliasSFI)->FI_ISS >0
					RecLock("A60",.T.)
					A60->A60_EMISS	:=	(cAliasSFI)->FI_DTMOVTO
					A60->A60_NUMFAB	:=	(cAliasSFI)->FI_SERPDV
					A60->A60_SITTRI	:=	"ISS"
					A60->A60_VALOR	:=	(cAliasSFI)->FI_ISS 
					MsUnlock()
				EndIf
				aStruSFI := (cAliasSFI)->(dbStruct())
				For nX := 1 To Len(aStruSFI)
					If "FI_BAS"$(cAliasSFI)->(FieldName(nX))
						If (cAliasSFI)->(FieldGet(nX))>0
							RecLock("A60",.T.)
							A60->A60_EMISS	:=	(cAliasSFI)->FI_DTMOVTO
							A60->A60_NUMFAB	:=	(cAliasSFI)->FI_SERPDV
				    		A60->A60_SITTRI	:=	aFISFill(Num2Chr(Val(SubStr((cAliasSFI)->(FieldName(nX)),7)),4),4)
							A60->A60_VALOR	:=	(cAliasSFI)->(FieldGet(nX))
							MsUnlock()
						EndIf
					EndIf
				Next nX	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Implementacao SEF PE                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				RecLock("M60",.F.)
				M60->M60_ICMSD	+=	(cAliasSFI)->FI_IMPDEBT
				MsUnlock ()
			Endif
			(cAliasSFI)->(dbSkip())
		EndDo
	    If lQuery
		    dbSelectArea(cAliasSFI)
			dbCloseArea()
		Else
	       	dbSelectArea("SFI")
			RetIndex("SFI")
			dbClearFilter()
			Ferase(cIndex+OrdBagExt())
		Endif
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta Registros Tipo 60D, 60I, 60R ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SFI->(LastRec()) > 0 .And. mv_par11 <> 1
		dbSelectArea("SF2")	
		dbSetOrder(1)
		
		dbSelectArea("SD2")
		ProcRegua(LastRec())
		#IFDEF TOP
		     If TcSrvType()<>"AS/400"
			     cAliasSD2 := "a940ASD2"
				 aStru  := SD2->(dbStruct())
				 cQuery := "SELECT * "
				 cQuery += "FROM "+RetSqlName("SD2")+" "
				 cQuery += "WHERE D2_FILIAL='"+xFilial("SD2")+"' AND "
				 cQuery += "D2_EMISSAO>='"+Dtos(dDtIni)+"' AND "
		         cQuery += "D2_EMISSAO<='"+Dtos(dDtFim)+"' AND "	
		         
		         If MV_PAR21==1
					 cQuery	+= "(D2_CF LIKE '6%') AND D2_ICMSRET>0 AND "
				 ElseIf MV_PAR21==2
					 cQuery	+= "(D2_CF LIKE '6%') AND "
				 Else
					 cQuery	+= "(D2_CF LIKE '5%' OR D2_CF LIKE '6%' OR D2_CF LIKE '7%') AND "
				 EndIf
				 
				 cQuery += "D2_PDV <> ' ' AND "
				 cQuery += "D_E_L_E_T_ = ' ' "
				 cQuery += "ORDER BY D2_FILIAL, D2_PDV, D2_EMISSAO"
		           	
				 cQuery := ChangeQuery(cQuery)
				 dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD2,.T.,.T.)
		
				 For nX := 1 To Len(aStru)
					 If aStru[nX][2] <> "C" .And. FieldPos(aStru[nX][1])<>0
						 TcSetField(cAliasSD2,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
					 EndIf
				 Next nX
				 dbSelectArea(cAliasSD2)
			 Else
		#ENDIF	
			     cIndex2 := CriaTrab(NIL,.F.)
				 cKey	 := 'D2_FILIAL+D2_PDV+DTOS(D2_EMISSAO)'
				 cFilter := 'D2_FILIAL == "'+xFilial("SD2")+'" .And. (Dtos(D2_EMISSAO) >= "'+Dtos(dDtIni)+'" .And. Dtos(D2_EMISSAO) <= "'+Dtos(dDtFim)+'")'
				 cFilter += '.And. !Empty(D2_PDV)'
				 
			     If MV_PAR21==1
					 cFilter	+= ' .And. Substr(D2_CF,1,1)$"6" .And. D2_ICMSRET>0'
				 ElseIf MV_PAR21==2
					 cFilter	+= ' .And. Substr(D2_CF,1,1)$"6"'
				 Else
					 cfilter	+= ' .And. Substr(D2_CF,1,1)$"5,6,7"'
				 EndIf
				 
				 IndRegua(cAliasSD2,cIndex2,cKey,,cFilter,)
				 nIndex := RetIndex("SD2")
				 #IFNDEF TOP
				 	dbSetIndex(cIndex2+OrdBagExt())
				 #ENDIF			 
				 dbSelectArea("SD2")
				 dbSetOrder(nIndex+1)
		
				 dbSelectArea(cAliasSD2)
				 dbGotop()			 
		#IFDEF TOP
			 EndIf
		#ENDIF
	
	    nItem := 1
	    nAliqICM := SuperGETMV("MV_ICMPAD")
	    While (cAliasSD2)->(!Eof()) 
	
	    	IncProc("Preparando Base de Dados 2/3") //
	       					
	       	SF4->(MsSeek(xFilial("SF4")+(cAliasSD2)->D2_TES))
	       	If ("N"$SF4->F4_LFICM)
	       		(cAliasSD2)->(DbSkip ())
	       		Loop
	       	EndIf
	       	
	       	SB1->(MsSeek(xFilial("SB1")+(cAliasSD2)->D2_COD))
	       	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se o produto faz parte do FUNCEP/PB                  ³
			//³Fundo de Combate e Erradicacao da Pobreza do Estado da Paraiba³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lGimPB
				cFuncep := ""
				If SB5->(FieldPos("B5_FUNCEP")) > 0
					SB5->(dbSetOrder(1))
					If SB5->(dbSeek(F3Filial("SB5",cAliasSF3)+(cAliasSD2)->D2_COD))
						cFuncep := SB5->B5_FUNCEP
					Endif
				Endif
	       	Endif
	       	
			If SF2->(MsSeek(xFilial("SF2")+(cAliasSD2)->D2_DOC+(cAliasSD2)->D2_SERIE+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA))
			    If (SF2->F2_ECF <> "S" .AND. !Empty(SF2->F2_NFCUPOM))
			    	(cAliasSD2)->(dbSkip()) 
			    	Loop
			    Endif	
			Endif
	
			A940LoadPro("S",@cNcm,@cProd,,lSef)
		        
	   		cSitTrib := ""
			If (cAliasSD2)->D2_ICMSRET > 0
				cSitTrib := "F"
			Elseif (cAliasSD2)->D2_VALISS+(cAliasSD2)->D2_BASEISS > 0
				cSitTrib := "ISS"
			Elseif SF4->F4_BASEICM > 0 .And. SF4->F4_CONSUMO == "S" 
			    If SF4->F4_LFICM == "I"
					cSitTrib := "I"
				ElseIf SF4->F4_LFICM == "O"
					cSitTrib := "N"
				Endif	
			Elseif SF4->F4_BASEICM == 0
			    If SF4->F4_LFICM == "I"
					cSitTrib := "I"
				ElseIf SF4->F4_LFICM == "O"
					cSitTrib := "N"
				ElseIf SF4->F4_LFICM == "T"
					cSitTrib := aFISFill(Num2Chr((cAliasSD2)->D2_PICM,4),4)
				Endif		
			ElseIf SF4->F4_BASEICM > 0 .And. SF4->F4_CONSUMO == "N"
				cSitTrib := aFISFill(Num2Chr((cAliasSD2)->D2_PICM,4),4)
			EndIf	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Define tipo de cupom fiscal                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Substr((cAliasSD2)->D2_SERIE,1,2)=="CP"
				cEspDoc:="2C"
			Else
			   	cEspDoc:="2D"
			EndIf
	        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Monta Registro Tipo 60D e Tipo 60I³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If mv_par12 == 1
				cNumFab := ""
				If SFI->(MsSeek(xFilial("SFI")+Dtos((cAliasSD2)->D2_EMISSAO)+(cAliasSD2)->D2_PDV))
					cNumFab := SFI->FI_SERPDV
				ElseIf SFI->(MsSeek(xFilial("SFI")+Dtos((cAliasSD2)->D2_EMISSAO)+Subs((cAliasSD2)->D2_PDV,2,3)))
					cNumFab := SFI->FI_SERPDV
				Endif	
				If D60->(MsSeek(Dtos((cAliasSD2)->D2_EMISSAO)+cProd+cNumFab))
					RecLock("D60",.F.)
					D60->D60_QUANT  += (cAliasSD2)->D2_QUANT
					D60->D60_VALOR  += (cAliasSD2)->D2_TOTAL 
					D60->D60_BSICM  += (cAliasSD2)->D2_BASEICM
					D60->D60_VLICM  += (cAliasSD2)->D2_VALICM 
					MsUnlock()
				Else         
					RecLock("D60",.T.)
					D60->D60_EMISS  := (cAliasSD2)->D2_EMISSAO
					D60->D60_NUMFAB := cNumFab
					D60->D60_CODPRO := cProd
					D60->D60_QUANT  := (cAliasSD2)->D2_QUANT
					D60->D60_VALOR  := (cAliasSD2)->D2_TOTAL 
					D60->D60_BSICM  := (cAliasSD2)->D2_BASEICM
					D60->D60_SITTRI := cSitTrib
					D60->D60_VLICM  := (cAliasSD2)->D2_VALICM 
					MsUnlock()
				Endif
	
				If !I60->(MsSeek(Dtos((cAliasSD2)->D2_EMISSAO)+cNumFab+(cAliasSD2)->D2_DOC))
					nItem	:=	1
				Else
					nItem++
				Endif
				//
				RecLock("I60",.T.)
					I60->I60_EMISS  := (cAliasSD2)->D2_EMISSAO
					I60->I60_NUMFAB := cNumFab
					I60->I60_COO    := (cAliasSD2)->D2_DOC
					I60->I60_MODELO := cEspDoc
					I60->I60_ITEM   := StrZero(nItem,3)
					I60->I60_CODPRO := cProd
					I60->I60_SITTRI := cSitTrib
					//
					If lConv76
						I60->I60_VLUNI  += (cAliasSD2)->D2_TOTAL
					Else
						I60->I60_VLUNI  += (cAliasSD2)->D2_PRCVEN 
					Endif
					//
					I60->I60_QUANT  += (cAliasSD2)->D2_QUANT  
					I60->I60_BSICM  += (cAliasSD2)->D2_BASEICM
					I60->I60_VLICM  += (cAliasSD2)->D2_VALICM 
					I60->I60_BSST	+= (cAliasSD2)->D2_BRICMS 
					I60->I60_CFOP	:= (cAliasSD2)->D2_CF
					If lGimPB
						I60->I60_FUNCEP := cFuncep
					Endif
				MsUnlock()
		    Endif
		    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Monta Registro Tipo 60R³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                      
			If mv_par16 == 1
				cEmiss := ""
				cEmiss := Substr(DTOS((cAliasSD2)->D2_EMISSAO),5,2)+Substr(DTOS((cAliasSD2)->D2_EMISSAO),1,4)
				If R60->(MsSeek(cEmiss+cProd+cSitTrib))
				    RecLock("R60",.F.)
					R60->R60_QUANT	+=	(cAliasSD2)->D2_QUANT
	
					If lConv76
						R60->R60_VALOR	+=	(cAliasSD2)->D2_TOTAL
					Else
						R60->R60_VALOR	+=	(cAliasSD2)->D2_PRCVEN
					Endif
	
					R60->R60_BSICM	+=	(cAliasSD2)->D2_BASEICM
					MsUnlock()
				Else
					RecLock("R60",.T.)
					R60->R60_MESANO	:=	cEmiss
					R60->R60_CODPRO	:=	cProd
					R60->R60_QUANT	:=	(cAliasSD2)->D2_QUANT	
					
					If lConv76
						R60->R60_VALOR	:=	(cAliasSD2)->D2_TOTAL
					Else
						R60->R60_VALOR	:=	(cAliasSD2)->D2_PRCVEN				
					Endif
									
					R60->R60_BSICM	:=	(cAliasSD2)->D2_BASEICM
					R60->R60_SITTRI	:=	cSitTrib
					MsUnlock()
				Endif
			Endif
			If mv_par12 == 1 .Or. mv_par16 == 1
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³% de Reducao do ICMS nas Operacoes Internas³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nRedBase := 0
		    	If SF4->F4_BASEICM >=100
					nRedBase :=0
				ElseIf SF4->F4_BASEICM > 0
				    nRedBase :=	(100-SF4->F4_BASEICM)
				Else
				    nRedBase :=	SF4->F4_BASEICM
			    Endif
		   		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Situacao Tributaria ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cSitTrib := ""
				If Empty((cAliasSD2)->D2_CLASFIS)
				    If SF4->(Fieldpos("F4_SITTRIB"))>0
					    cSitTrib := aFISFill(Num2Chr(Val(Substr(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB),3,0),3)
					Else
					    If Len(alltrim(SB1->B1_ORIGEM)) ==2
						    cSitTrib := SB1->B1_ORIGEM+"0"
					    Else	
					        cSitTrib :=	aFISFill(Num2Chr(Val(Substr(SB1->B1_ORIGEM,1,1)+Substr(SB1->B1_CLASFIS,1,1)+"0"),3,0),3)
					    EndIf
					EndIf	
				Else
				    cSitTrib :=	aFISFill(Num2Chr(Val((cAliasSD2)->D2_CLASFIS),3,0),3)
			    EndIf
				cSeek := (dtos(dDtIni)+dtos(dDtFim)+PADR(cProd,14)+PADR(cNcm,8)+SB1->B1_UM+space(4))
				If !(R75->(dbSeek(cSeek)))
					RecLock("R75",.T.)
					R75->A75_CTARE	:=	cContrTare
					R75->A75_DTAINI	:= dDTIni
					R75->A75_DTAFIM	:= dDTFim
					R75->A75_PROD  	:= cProd
					R75->A75_PRORI	:=SB1->B1_COD
		   			IF cNcm=="        "
						R75->A75_CODNCM	:="00000000"
					else
     				   R75->A75_CODNCM	:=cNcm
					endif
		   			R75->A75_DESCR	:= SB1->B1_DESC
					R75->A75_UM    	:= SB1->B1_UM
					R75->A75_ALQIPI	:= SB1->B1_IPI
					R75->A75_ALQICM	:= nAliqICM
		
					If lSef
						If (cAliasSD2)->D2_ICMSRET > 0		//Substituicao Tributaria
							R75->A75_BRICMS :=	NoRound((cAliasSD2)->D2_BRICMS/(cAliasSD2)->D2_QUANT)
						Else
							R75->A75_BRICMS :=	0
						Endif
					Else
						R75->A75_BRICMS	:= (cAliasSD2)->D2_BRICMS
					Endif								
		
					R75->A75_SITTRI	:= cSitTrib
					R75->A75_REDBSE	:= nRedBase		
					MsUnlock()
				Endif	
		   	Endif
		   	(cAliasSD2)->(dbSkip())
		EndDo
		If lQuery
	    	dbSelectArea(cAliasSD2)
			dbCloseArea()
	    Else
	       	dbSelectArea("SD2")
			RetIndex("SD2")
			dbClearFilter()
			Ferase(cIndex2+OrdBagExt())
	    EndIf 
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Grava Registro 75 de acordo com o registro 74 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par10 == 1
		cNcm  := ""
		cProd := ""
		cSitTrib := ""
		dbSelectArea("R74")
		dbGoTop()
		While R74->(!Eof()) 
			
			If AllTrim(R74->CODIGO)<>AllTrim(R74->NCM)
				SB1->(MsSeek(xFilial("SB1")+Alltrim(R74->CODIGO)))
				A940LoadPro("I",@cNcm,@cProd,,lSef)
		   		
		   		If Len(Alltrim(SB1->B1_COD))>14
		            cSeek :=(dtos(dDtIni)+dtos(dDtFim)+PADR(cProd,14)+PADR(cNcm,8)+SB1->B1_UM+space(4))
		            RecLock("R74",.F.)
		            R74->CODIGO := cProd
		            MsUnlock()
			    Else						
		            cSeek :=(dtos(dDtIni)+dtos(dDtFim)+Substr(SB1->B1_COD,1,14)+PADR(cNcm,8)+SB1->B1_UM+space(4))
		   		EndIf						
		   		
		        If Len(Alltrim(SB1->B1_ORIGEM)) ==2
					cSitTrib := SB1->B1_ORIGEM+"0"
				Else	
				    cSitTrib :=	aFISFill(Num2Chr(Val(Substr(SB1->B1_ORIGEM,1,1)+Substr(SB1->B1_CLASFIS,1,1)+"0"),3,0),3)
		        EndIf
		        If R75->(!dbSeek(cSeek)) .And. R74->UF <> "EX"
					RecLock("R75",.T.)
					R75->A75_CTARE	:=	cContrTare
					R75->A75_DTAINI	:= dDTIni
					R75->A75_DTAFIM	:= dDTFim
					R75->A75_PROD  	:= cProd
					R75->A75_PRORI	:=SB1->B1_COD
			       	IF cNcm=="        "
					   R75->A75_CODNCM	:="00000000"
					else
     				   R75->A75_CODNCM	:=cNcm
					endif
					R75->A75_DESCR	:= SB1->B1_DESC
					R75->A75_UM    	:= SB1->B1_UM
					R75->A75_ALQIPI	:= SB1->B1_IPI
					R75->A75_ALQICM	:= 0
					R75->A75_BRICMS	:= 0
					R75->A75_SITTRI	:= cSitTrib
					R75->A75_REDBSE	:= 0	
					MsUnlock()        
		        Endif
			Else
				cSeek :=(dtos(dDtIni)+dtos(dDtFim)+R74->NCM+PADR(R74->NCM,8)+"UM"+space(4))
				If R75->(!dbSeek(cSeek)) .And. R74->UF <> "EX"
					RecLock("R75",.T.)
					R75->A75_CTARE	:=	cContrTare
					R75->A75_DTAINI	:= dDTIni
					R75->A75_DTAFIM	:= dDTFim
					R75->A75_PROD  	:= R74->CODIGO
					R75->A75_PRORI	:= R74->CODIGO
			       	R75->A75_CODNCM	:= R74->CODIGO
					R75->A75_DESCR	:= "NCM: "+R74->CODIGO
					R75->A75_UM    	:= "UM"
					R75->A75_ALQIPI	:= 0
					R75->A75_ALQICM	:= 0
					R75->A75_BRICMS	:= 0
					R75->A75_SITTRI	:= "000"
					R75->A75_REDBSE	:= 0	
					MsUnlock()        
		        Endif	        
		    EndIf        
	        If R74->UF == "EX"
		        RecLock("R74",.F.)
		        dbDelete()
		        MsUnlock()        
	        Endif
	        R74->(dbSkip())
	    EndDo    
	    dbSelectArea("R74")
	    Pack
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta Registro Tipo 55³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par05 <> 4
		dbSelectArea("SF6")
		dbSetOrder(2)
		#IFDEF TOP
		    If TcSrvType()<>"AS/400"
			    cAliasSF6 := "a940ASF6"
				aStru  := SF6->(dbStruct())
				cQuery := "SELECT * "
				cQuery += "FROM "+RetSqlName("SF6")+" "
				cQuery += "WHERE F6_FILIAL='"+xFilial("SF6")+"' AND "
				cQuery += "F6_DTARREC>='"+Dtos(dDtIni)+"' AND "
				cQuery += "F6_DTARREC<='"+Dtos(dDtFim)+"' AND "	
				If !Empty(cEstDest)
					If lListEst
						cQuery += "F6_EST ='"+ cEstDest+"' AND "
					Else
						cQuery += "F6_EST <>'"+ cEstDest+"' AND "
					EndIf
				EndIf			
				cQuery += "D_E_L_E_T_ = ' ' "
				cQuery += "ORDER BY "+SqlOrder(SF6->(IndexKey()))
			
				cQuery := ChangeQuery(cQuery)
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSF6,.T.,.T.)
			
				For nX := 1 To len(aStru)
					If aStru[nX][2] <> "C" .And. FieldPos(aStru[nX][1])<>0
						TcSetField(cAliasSF6,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
					EndIf
				Next nX
				dbSelectArea(cAliasSF6)
			Else
		#ENDIf
		    	(cAliasSF6)->( MsSeek(xFilial("SF6")))
		#IFDEF TOP
			EndIf
		#ENDIF
	
		lTipoImp := Iif(SF6->(Fieldpos("F6_TIPOIMP"))>0,.T.,.F.)
		ProcRegua(LastRec())
		While (cAliasSF6)->(!Eof()) .And. xFilial("SF6")== (cAliasSF6)->F6_FILIAL
			IncProc("Selecionando Registros...") //
			#IFNDEF TOP
			    If !lGnre .Or. !(SF6->(FieldPos("F6_ANOREF"))>0)
				   If (cAliasSF6)->F6_DTARREC < dDtIni .Or. Iif(lListEst,((cAliasSF6)->F6_EST <> cEstDest .And. !Empty(cEstDest)),((cAliasSF6)->F6_EST==cEstDest .And. !Empty(cEstDest)))
					  (cAliasSF6)->(dbSkip())
					  Loop
				   EndIf
				   If (cAliasSF6)->F6_DTARREC > dDtFim
					  (cAliasSF6)->(dbSkip())
					  Loop
				   EndIf
				Else 
			       dDataGnre :=CTOD("01/"+StrZero((cAliasSF6)->F6_MESREF,2)+"/"+StrZero((cAliasSF6)->F6_ANOREF,4))
				   dDataGnre :=CTOD(Strzero(Val(Subs(Dtoc(LastDay(dDataGnre)),1,2)),2)+"/"+StrZero((cAliasSF6)->F6_MESREF,2)+"/"+StrZero((cAliasSF6)->F6_ANOREF,4))
				   If dDataGnre < dDtIni .Or. Iif(lListEst,((cAliasSF6)->F6_EST <> cEstDest .And. !Empty(cEstDest)),((cAliasSF6)->F6_EST==cEstDest .And. !Empty(cEstDest)))
				      (cAliasSF6)->(dbSkip())
					  Loop
				   EndIf
				   
				   If dDataGnre > dDtFim
				     (cAliasSF6)->(dbSkip())
				     Loop			      
				   EndIf			
				Endif   
		    #ENDIf
		    If lTipoImp
		    	If !(cAliasSF6)->F6_TIPOIMP$"3# "
					(cAliasSF6)->(dbSkip())
					Loop    	
				ElseIf (cAliasSF6)->F6_TIPOIMP=="3"
					If (cAliasSF6)->F6_EST==GETMV("MV_ESTADO")
						(cAliasSF6)->(dbSkip())
						Loop				
					Endif
				EndIf
			EndIf	
			RecLock("R55",.T.)	
			R55->A55_CNPJ	:=	SM0->M0_CGC
	        If AllTrim((cAliasSF6)->F6_INSC)<>AllTrim(SM0->M0_INSC)
			   R55->A55_IE		:=	ARETDIG((cAliasSF6)->F6_INSC,.t.,(cAliasSF6)->F6_EST)
			Else
			   R55->A55_IE		:=	ARETDIG("",.t.,(cAliasSF6)->F6_EST)
			Endif   
			R55->A55_DATPAG	:=	(cAliasSF6)->F6_DTARREC
			R55->A55_UFSUBS	:=	GETMV("MV_ESTADO")
			R55->A55_UFFAV	:=	(cAliasSF6)->F6_EST
			R55->A55_BANCO	:=	StrZero(val((cAliasSF6)->F6_BANCO),3)
			R55->A55_AGENC	:=	Strzero(val(Left((cAliasSF6)->F6_AGENCIA,4)),4)
			R55->A55_NUMERO	:=	Strzero(val((cAliasSF6)->F6_NUMERO),20)
			R55->A55_VALOR	:=	(cAliasSF6)->F6_VALOR
			R55->A55_VENCTO	:=	(cAliasSF6)->F6_DTVENC
			R55->A55_CONVEN	:=	(cAliasSF6)->F6_NUMCONV
		
			SX3->(DbSetOrder(2))
			If SF6->(FieldPos("F6_ANOREF"))>0 .And. SX3->(MsSeek("F6_ANOREF")) .And. X3USO(SX3->X3_USADO)
				R55->A55_MESANO	:= StrZero((cAliasSF6)->F6_MESREF,2)+StrZero((cAliasSF6)->F6_ANOREF,4)
			Else
				R55->A55_MESANO	:= StrZero((cAliasSF6)->F6_MESREF,2)+StrZero(Year(dDatabase),4)
			EndIf
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Implementacao do SEF PE                                                 ³
			//³Registro 88/78 - Detalhamento de Obrigacoes a Recolher                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			R55->X78_VLRDAE	:= (cAliasSF6)->F6_VALOR
			R55->X78_RECDAE	:= PadL(Alltrim((cAliasSF6)->F6_CODREC),4)
			R55->X78_PERFIS	:= Substr(R55->A55_MESANO,3,4)+Substr(R55->A55_MESANO,1,2)
			R55->X78_DTVECT	:= (cAliasSF6)->F6_DTVENC
			MsUnLock()
	
			SX3->(DbSetOrder(1))
			MsUnlock()
		
			(cAliasSF6)->( dbSkip())
			IncProc("Preparando Base de Dados - 3/3") //
		EndDo                      
	    dbSelectArea(cAliasSF6)
		dbCloseArea()
	Endif

	DbSelectArea ("SA1")	//Manter um alias aberto para nao dar problema. Poderia ser qualquer tabela.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta Registros 85 e 86 referentes a exportacao.             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lSigaEEC
		MTA940EXP(dDtIni,dDtFim,lCONV76,cEstDest,lListEst)
	Else
		If (lMta8586)
			Execblock("MTA8586",.F.,.F.)
		EndIf
	Endif    
	//
	If lQuery
		dbSelectArea(cAliasSF3)
		dbCloseArea()
	Else
	  	dbSelectArea("SF3")
		RetIndex("SF3")
		dbClearFilter()
		Ferase(cIndex+OrdBagExt())
	EndIf
	//
	SM0->(DbSkip ())		
EndDo
RestArea (aAreaSm0)
cFilAnt	:= SM0->M0_CODFIL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Armazena os registros 60 M/A/D/I                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Reg60Ord()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa funcoes do arquivo magnetico                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lSef					//SEF de Pernambuco
	Sef("2",cAliasSF3)	//Executa a SEF no final do While do SF3
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa funcoes do arquivo magnetico                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lSef	  				//SEF de Pernambuco
	Sef("3",cAliasSF3)	//Executa a SEF no final do processamento da funcao Sintegra()
Endif

If !lFirst
	dbSelectArea("SD2")
	RetIndex("SD2")
	dbClearFilter()
	Ferase(cIndex2+OrdBagExt())
Endif

RestArea(aAreaSint)

Return(aTrbs)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³GrvReg61  ³ Autor ³ Sergio S. Fuzinaka    ³ Data ³ 15.03.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Grava o Registro Tipo 61                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GrvReg61(aArrayF3,nI,lConv76,lNfProd,lSef)

Local aArea := GetArea()

If Val(Subs(AllTrim(aArrayF3[nI][5]),1,1))>=5
	If AModNot(aArrayF3[nI][7])$"02/13/14/15/16"+IIf(lConv76,IIf(lNfProd,"/04",""),"/04")+IIf(lSef,"/18","") .And. ;
    	Alltrim(aArrayF3[nI][7])<>"CF"
       	
       	cSeek := dTos(aArrayF3[nI][18])+Str(aArrayF3[nI][8],5,2)
		
		If R61->(!MsSeek(cSeek))
		    RecLock("R61",.T.)
			R61->A61_EMISS	:= 	aArrayF3[nI][18]
			R61->A61_MODELO	:=	AModNot(aArrayF3[nI][7])
			R61->A61_SERIE	:=	aArrayF3[nI][2]
			R61->A61_NUMINI	:=	aArrayF3[nI][1]
			R61->A61_CFOP	:=	aArrayF3[nI][5]	//Implementacao SEF PE
			R61->A61_ALQICM	:= 	aArrayF3[nI][8]
		Else
		    RecLock("R61",.F.)
		EndIf		
		R61->A61_NUMFIM	:=	aArrayF3[nI][1]
		R61->A61_VALTOT	+=	aArrayF3[nI][17]
		R61->A61_BSICM	+=	aArrayF3[nI][19]
		R61->A61_VALICM	+=	aArrayF3[nI][16]
		R61->A61_ISENTA	+= 	aArrayF3[nI][12]
		R61->A61_OUTRAS	+= 	aArrayF3[nI][15]
		MsUnlock()
	EndIf
Endif  

RestArea(aArea)

Return Nil




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³A940CNPJ  ³ Autor ³Nereu Humberto Jr      ³ Data ³12.12.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida CNPJ                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpC1: CNPJ valido                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: CNPJ                                                 ³±±
±±³          ³ExpC2: Tipo do Cliente/Fornecedor                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A940CNPJ(cCGC,cTipo, lTareDf)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Zera o campo de CGC para pessoas nao obrigadas a inscricao.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( cTipo=="X")
	cCGC:=""
EndIf

If (lTareDf) .And. ("F"$cTipo)
	cCGC := AFISFILL (cCGC, 14)
Else
	cCGC := AFISFILL (Num2Chr (Val (cCGC), 14, 0), 14)
EndIf

Return(PadR(cCGC,14))
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³A940IE    ³ Autor ³Nereu Humberto Jr      ³ Data ³12.12.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida Inscricao Estadual                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpC1: IE valida                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: IE                                                   ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A940IE(cInsc)

Local cRet	:=	""
Local nI	:=	1

For nI:=1 To Len(cInsc)
	If Isdigit(Subs(cInsc,nI,1)) .Or. IsAlpha(Subs(cInsc,nI,1))
		cRet+=Subs(cInsc,nI,1)
	Endif
Next
If Empty(cRet)
	cRet:="ISENTO"
Endif
Return(cRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³A94LoadPro³ Autor ³Nereu Humberto Jr      ³ Data ³26.12.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Define codigo do Produto e do NCM                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpC1: .T.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: cTipo "E" - SD1 /  "S" - SD2                         ³±±
±±³          ³ExpC2: cNcm                                                 ³±±
±±³          ³ExpC3: cProd                                                ³±±
±±³          ³ExpC4: cTec - SD1->D1_TEC                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A940LoadPro(cTipo,cNcm,cProd,cTec,lSef)

Default lSef := .F.		//Tratamento para chave duplicada, conforme layout SEF-PE

If Len(alltrim(SB1->B1_COD))>14
	If lSef
		cNcm  :=STRTRAN(ALLTRIM(SB1->B1_POSIPI),".","")
		cProd :=STRTRAN(ALLTRIM(SB1->B1_POSIPI),".","")+ALLTRIM(SB1->B1_UM)
	Else
		cNcm  :=STRTRAN(ALLTRIM(SB1->B1_POSIPI),".","")
		cProd :=STRTRAN(ALLTRIM(SB1->B1_POSIPI),".","")
	Endif
Else
	cNcm  :=STRTRAN(ALLTRIM(SB1->B1_POSIPI),".","")
	cProd :=SUBS(SB1->B1_COD,1,14)
EndIf
If cTipo == "E" .And. cTec <> NIL
	If!Empty(cTec)
		cNcm  :=STRTRAN(ALLTRIM(cTec),".","")
		cProd :=STRTRAN(ALLTRIM(cTec),".","")
	Endif	
EndIf

If Existblock("A940PRD")
    cProd := Execblock("A940PRD",.F.,.F.,{cTipo,cNcm,cProd,cTec}) 
EndIf

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³A940AREG90ºAutor  ³ Nereu Humberto Jr. º Data ³  02/01/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta registro totalizador tipo 90                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA940                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A940REG90(nPar88,nTotSTES)

Local 	cRegistro   :=	""
Private lGravou		:=	.F.       

// Total do inventario de Subst. Tributaria
Default nTotSTES 	:= 0

nReg50	:=	IIF(Ascan(_aTotal[98],"R50")>0,R50->(LastRec()),0)
nReg51	:=	IIF(Ascan(_aTotal[98],"R51")>0,R51->(LastRec()),0)
nReg53	:=	IIF(Ascan(_aTotal[98],"R53")>0,R53->(LastRec()),0)
nReg54	:=	IIF(Ascan(_aTotal[98],"R54")>0,R54->(LastRec()),0)
nReg55	:=	IIF(Ascan(_aTotal[98],"R55")>0,R55->(LastRec()),0)
nReg60	:=	IIF(Ascan(_aTotal[98],"M60")>0,M60->(LastRec()),0)
nReg60	+=	IIF(Ascan(_aTotal[98],"A60")>0,A60->(LastRec()),0)
nReg60	+=	IIF(Ascan(_aTotal[98],"D60")>0,D60->(LastRec()),0)
nReg60	+=	IIF(Ascan(_aTotal[98],"I60")>0,I60->(LastRec()),0)
nReg60	+=	IIF(Ascan(_aTotal[98],"R60")>0,R60->(LastRec()),0)
nReg61	:=	IIF(Ascan(_aTotal[98],"R61")>0,R61->(LastRec()),0)
nReg61	+=	IIF(Ascan(_aTotal[98],"I61")>0,I61->(LastRec()),0)
nReg70	:=	IIF(Ascan(_aTotal[98],"R70")>0,R70->(LastRec()),0)
nReg71	:=	IIF(Ascan(_aTotal[98],"R71")>0,R71->(LastRec()),0)
nReg74	:=	Iif(mv_par05 == 4,0,IiF(Select("R74")>0,R74->(LastRec()),0))
nReg75	:=	IIF(Ascan(_aTotal[98],"R75")>0,R75->(LastRec()),0)
nReg76	:=	IIF(Ascan(_aTotal[98],"R76")>0,R76->(LastRec()),0)
nReg77	:=	IIF(Ascan(_aTotal[98],"R77")>0,R77->(LastRec()),0)
nReg85	:=	IIF(Ascan(_aTotal[98],"R85")>0,R85->(LastRec()),0)
nReg86	:=	IIF(Ascan(_aTotal[98],"R86")>0,R86->(LastRec()),0)
nReg88	:=	Iif(nPar88==Nil,IIF(Ascan(_aTotal[98],"R88")>0,R88->(LastRec()),0),nPar88)
nReg56	:=	IIF(Ascan(_aTotal[98],"R56")>0,R56->(LastRec()),0)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Implementacao do SEF PE                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nReg88	+=	IIF(Ascan(_aTotal[98],"X10")>0,X10->(LastRec()),0)
nReg88	+=	IIF(Ascan(_aTotal[98],"X20")>0,X20->(LastRec()),0)	//Implementacao NFE-BA
nReg88	+=	IIF(Ascan(_aTotal[98],"X15")>0,X15->(LastRec()),0)
nReg88	+=	IIF(Ascan(_aTotal[98],"X25")>0,X25->(LastRec()),0)
nReg88	+=	IIF(Ascan(_aTotal[98],"X30")>0,X30->(LastRec()),0)
nReg88	+=	IIF(Ascan(_aTotal[98],"X35")>0,X35->(LastRec()),0)
nReg88	+=	IIF(Ascan(_aTotal[98],"X60")>0,X60->(LastRec()),0)
nReg88	+=	IIF(Ascan(_aTotal[98],"X61")>0,X61->(LastRec()),0)
nReg88	+=	IIF(Ascan(_aTotal[98],"X74")>0,X74->(LastRec()),0)
nReg88	+=	IIF(Ascan(_aTotal[98],"X77")>0,X77->(LastRec()),0)
nReg88	+=	IIF(Ascan(_aTotal[98],"X78")>0,R55->(LastRec()),0)
nReg88	+=	IIF(Ascan(_aTotal[98],"X80")>0,X80->(LastRec()),0)
nReg88	+=	IIF(Ascan(_aTotal[98],"X82")>0,X82->(LastRec()),0)
nReg88	+=	IIF(Ascan(_aTotal[98],"X85")>0,X85->(LastRec()),0)
nReg88	+=	IIF(Ascan(_aTotal[98],"X89")>0,X89->(LastRec()),0)
nReg90	:=	1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Registro 88-STES - Minas Gerais³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nReg88	+=	nTotSTES

cRegistro	:=	"90"												//01.Tipo
cRegistro	+=	aFISFill(Num2Chr(Val(SM0->M0_CGC),14,0),14)   //02.CGC
cRegistro	+=	aFISFill(ARETDIG(SM0->M0_INSC,.t.,SM0->M0_ESTENT),14) //03.Inscr. Estadual

If nReg50>0
	cRegistro	+=	"50"
	cRegistro	+=	aFISFill(StrZero(nReg50,8),8)	// Total de Registros "50"
EndIf

If nReg51>0
	cRegistro	+=	"51"
	cRegistro	+=	aFISFill(StrZero(nReg51,8),8)	// Total de Registros "51"
EndIf

If nReg53>0
	cRegistro	+=	"53"
	cRegistro	+=	aFISFill(StrZero(nReg53,8),8)	// Total de Registros "53"
EndIf

If nReg54>0
	cRegistro	+=	"54"
	cRegistro	+=	aFISFill(StrZero(nReg54,8),8)	// Total de Registros "54"
EndIf

If nReg55>0
	cRegistro	+=	"55"
	cRegistro	+=	aFISFill(StrZero(nReg55,8),8)	// Total de Registros "55"
EndIf

If nReg56>0
	cRegistro	+=	"56"
	cRegistro	+=	aFISFill(StrZero(nReg56,8),8)	// Total de Registros "56"
EndIf
If nReg60>0
	cRegistro	+=	"60"
	cRegistro	+=	aFISFill(StrZero(nReg60,8),8)	// Total de Registros "60"
EndIf

If nReg61>0
	cRegistro	+=	"61"
	cRegistro	+=	aFISFill(StrZero(nReg61,8),8)	// Total de Registros "61"
EndIf

If nReg70>0
	cRegistro	+=	"70"
	cRegistro	+=	aFISFill(StrZero(nReg70,8),8)	// Total de Registros "70"
EndIf

// Imprime Reg. Tipo 90
If Len(cRegistro)>=110
	A940IncReg90(@cRegistro,@nReg90,(nReg71+nReg74+nReg75+nReg76+nReg77+nReg85+nReg86+nReg88))
EndIf

If nReg71>0
	cRegistro	+=	"71"
	cRegistro	+=	aFISFill(StrZero(nReg71,8),8)	// Total de Registros "71"
EndIf

// Imprime Reg. Tipo 90
If Len(cRegistro)>=110.And.!lGravou
	A940IncReg90(@cRegistro,@nReg90,(nReg74+nReg75+nReg76+nReg77+nReg85+nReg86+nReg88))
EndIf

If nReg74>0
	cRegistro	+=	"74"
	cRegistro	+=	aFISFill(StrZero(nReg74,8),8)	// Total de Registros "74"
EndIf

// Imprime Reg. Tipo 90
If Len(cRegistro)>=110.And.!lGravou
	A940IncReg90(@cRegistro,@nReg90,(nReg75+nReg76+nReg77+nReg85+nReg86+nReg88))
EndIf

If nReg75>0
	cRegistro	+=	"75"
	cRegistro	+=	aFISFill(StrZero(nReg75,8),8)	// Total de Registros "75"
EndIf

// Imprime Reg. Tipo 90
If Len(cRegistro)>=110.And.!lGravou
	A940IncReg90(@cRegistro,@nReg90,(nReg76+nReg77+nReg85+nReg86+nReg88))
EndIf

If nReg76>0
	cRegistro	+=	"76"
	cRegistro	+=	aFISFill(StrZero(nReg76,8),8)	// Total de Registros "76"
EndIf

// Imprime Reg. Tipo 90
If Len(cRegistro)>=110.And.!lGravou
	A940IncReg90(@cRegistro,@nReg90,(nReg77+nReg85+nReg86+nReg88))
EndIf

If nReg77>0
	cRegistro	+=	"77"
	cRegistro	+=	aFISFill(StrZero(nReg77,8),8)	// Total de Registros "77"
EndIf

// Imprime Reg. Tipo 90
If Len(cRegistro)>=110.And.!lGravou
	A940IncReg90(@cRegistro,@nReg90,nReg85+nReg86+nReg88)
EndIf

If nReg85>0
	cRegistro	+=	"85"
	cRegistro	+=	aFISFill(StrZero(nReg85,8),8)	// Total de Registros "85"
EndIf

// Imprime Reg. Tipo 90
If Len(cRegistro)>=110.And.!lGravou
	A940IncReg90(@cRegistro,@nReg90,nReg86+nReg88)
EndIf

If nReg86>0
	cRegistro	+=	"86"
	cRegistro	+=	aFISFill(StrZero(nReg86,8),8)	// Total de Registros "86"
EndIf

// Imprime Reg. Tipo 90
If Len(cRegistro)>=110.And.!lGravou
	A940IncReg90(@cRegistro,@nReg90,nReg88)
EndIf

If nReg88 > 0
	cRegistro += "88"
	cRegistro	+=	aFISFill(StrZero(nReg88,8),8)	// Total de Registros "88"
EndIf	

// Imprime Reg. Tipo 90
If (Len(cRegistro)>=110.And.!lGravou).Or.!lGravou
	A940IncReg90(@cRegistro,@nReg90,0)
EndIf

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao ³A940IncReg90 ºAutor  ³ Nereu Humberto Jr. º Data ³  02/01/03   º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.  ³ Grava registros tipo 90                                       º±±
±±º       ³                                                               º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso    ³ MATA940                                                       º±±
±±ÈÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A940IncReg90(cRegistro,nReg90,nResto)

If nResto<=0.And.(125-Len(cRegistro))>8
	// Nao possui mais registros a imprimir
	lGravou	:=	.T.
	cRegistro	+=	"99"
    cRegistro	+=	AFISFill(StrZero(2+nReg90+nReg50+nReg51+nReg53+nReg54+nReg55+nReg60+nReg61+nReg70+nReg71+nReg74+nReg75+nReg76+nReg77+nReg85+nReg86+nReg88+nReg56,8),8)
	cRegistro	+=	aFISFill(,(125-Len(cRegistro)))	// Brancos ate registro final	
	cRegistro	+=	Alltrim(Str(nReg90)) 				// Nro registro tipo 90	
	RecLock("R90",.T.)
	R90->A90_REGS := cRegistro
	MsUnlock()
EndIf

If (125-Len(cRegistro))<=16	// VerIfica se imprime mais um registro
	If !lGravou
		nReg90++				// Incrementa reg. tipo 90
		cRegistro	+=	space(125-Len(cRegistro))
		cRegistro	+=	Alltrim(Str(nReg90))				// Nro registro tipo 90
		
		RecLock("R90",.T.)
		R90->A90_REGS := cRegistro
		MsUnlock()
		
		If nResto<=0.And.(125-Len(cRegistro))<9
			// Nao possui mais registros a imprimir
			lGravou:=.T.
			cRegistro	:=	"90"	// Reinicializa segundo registro 90
			cRegistro	+=	aFISFill(Num2Chr(Val(SM0->M0_CGC),14,0),14)
			cRegistro	+=	aFISFill(ARETDIG(SM0->M0_INSC,.T.,SM0->M0_ESTENT),14)
			cRegistro	+=	"99"
			cRegistro	+=	AFISFill(StrZero(2+nReg90+nReg50+nReg51+nReg53+nReg54+nReg55+nReg60+nReg61+nReg70+nReg71+nReg74+nReg75+nReg76+nReg77+nReg85+nReg86+nReg88+nReg56,8),8)
			cRegistro	+=	aFISFill(,(125-Len(cRegistro)))	// Brancos ate registro final
			cRegistro	+=	Alltrim(Str(nReg90))  				// Nro registro tipo 90
	    
	    	RecLock("R90",.T.)
			R90->A90_REGS := cRegistro
			MsUnlock()
		Else
			cRegistro	:=	"90"	// Reinicializa segundo registro 90
			cRegistro	+=	aFISFill(Num2Chr(Val(SM0->M0_CGC),14,0),14)
			cRegistro	+=	aFISFill(ARETDIG(SM0->M0_INSC,.T.,SM0->M0_ESTENT),14)
		EndIf
	EndIf
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³a940Relat   ³ Autor ³ Nereu Humberto Jr.  ³ Data ³ 02/01/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Imprime relatorio de conferencia                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function a940Relat(nParam,nPar88,nTotSTES)
Local cTela:=""                          

// Total de Registros do Inventario com Subst. Tributaria
Default nTotSTES	:= 0

Titulo	:=	"Listagem de acompanhamento" //
cDesc1	:=	"Listagem de acompanhamento do arquivo pr‚-formatado." //
cDesc2	:=	""
cDesc3	:=	""
Tamanho	:=	"P"
Limite	:=	80
nTipo	:=	18
cabec1	:=	''
cabec2	:=	''
cabec3	:=	''
cbCont	:=	0
cbtxt	:=	Space(10)
m_pag	:=	1
cPerg   :=	"MTA940"
cString :=	"SF3"
lEnd	:=	.f.
Nomeprog:=	"RFISC001"
wnrel	:=	Nomeprog
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLastKey:=0
If nParam == 1
	wnrel	:=	SetPrint(cString,wnrel,,Titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.)
	If nLastKey==27
		Return
	EndIf
	SetDefault(aReturn,cString)
Endif

If nLastKey==27
	Return
EndIf

If nParam <> 1
	RptStatus({|lEnd|A940Impr(@lEnd,wnRel,cString,Tamanho, nPar88,nTotSTES)},titulo)
Endif	
Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³a940Impr     ³Autor ³ Nereu Humberto Jr.  ³ Data ³ 02/01/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Chamada para impressao da listagem                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function a940Impr(lEnd,wnRel,cString,Tamanho, nPar88,nTotSTES)

Local nLin    := 0
Local nTotReg := 0
Local nReg50  := IIF(Ascan(_aTotal[98],"R50")>0,R50->(LastRec()),0)
Local nReg51  := IIF(Ascan(_aTotal[98],"R51")>0,R51->(LastRec()),0)
Local nReg53  := IIF(Ascan(_aTotal[98],"R53")>0,R53->(LastRec()),0)
Local nReg54  := IIF(Ascan(_aTotal[98],"R54")>0,R54->(LastRec()),0)
Local nReg55  := IIF(Ascan(_aTotal[98],"R55")>0,R55->(LastRec()),0)
Local nReg56  := IIF(Ascan(_aTotal[98],"R56")>0,R56->(LastRec()),0)
Local nReg61  := IIF(Ascan(_aTotal[98],"R61")>0,R61->(LastRec()),0)
Local nReg70  := IIF(Ascan(_aTotal[98],"R70")>0,R70->(LastRec()),0)
Local nReg71  := IIF(Ascan(_aTotal[98],"R71")>0,R71->(LastRec()),0)
Local nReg74  := Iif(mv_par05 == 4,0,IiF(Select("R74")>0,R74->(LastRec()),0))
Local nReg75  := IIF(Ascan(_aTotal[98],"R75")>0,R75->(LastRec()),0)
Local nReg76  := IIF(Ascan(_aTotal[98],"R76")>0,R76->(LastRec()),0)
Local nReg77  := IIF(Ascan(_aTotal[98],"R77")>0,R77->(LastRec()),0)
Local nReg85  := IIF(Ascan(_aTotal[98],"R85")>0,R85->(LastRec()),0)
Local nReg86  := IIF(Ascan(_aTotal[98],"R86")>0,R86->(LastRec()),0)
Local nReg88  := Iif (nPar88==Nil, IIF(Ascan(_aTotal[98],"R88")>0,R88->(LastRec()),0), nPar88)
Local nReg90  := R90->(LastRec())
Local nReg60  := IIF(Ascan(_aTotal[98],"M60")>0,M60->(LastRec()),0)
nReg60 += IIF(Ascan(_aTotal[98],"A60")>0,A60->(LastRec()),0)
nReg60 += IIF(Ascan(_aTotal[98],"D60")>0,D60->(LastRec()),0)
nReg60 += IIF(Ascan(_aTotal[98],"I60")>0,I60->(LastRec()),0)
nReg60 += IIF(Ascan(_aTotal[98],"R60")>0,R60->(LastRec()),0)
nReg61 += IIF(Ascan(_aTotal[98],"I61")>0,I61->(LastRec()),0)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Implementacao do SEF PE                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nReg88 += IIF(Ascan(_aTotal[98],"X10")>0,X10->(LastRec()),0)
nReg88 += IIF(Ascan(_aTotal[98],"X20")>0,X20->(LastRec()),0)	//Implementacao NFE-BA
nReg88 += IIF(Ascan(_aTotal[98],"X15")>0,X15->(LastRec()),0)
nReg88 += IIF(Ascan(_aTotal[98],"X25")>0,X25->(LastRec()),0)
nReg88 += IIF(Ascan(_aTotal[98],"X30")>0,X30->(LastRec()),0)
nReg88 += IIF(Ascan(_aTotal[98],"X35")>0,X35->(LastRec()),0)
nReg88 += IIF(Ascan(_aTotal[98],"X60")>0,X60->(LastRec()),0)
nReg88 += IIF(Ascan(_aTotal[98],"X61")>0,X61->(LastRec()),0)
nReg88 += IIF(Ascan(_aTotal[98],"X74")>0,X74->(LastRec()),0)
nReg88 += IIF(Ascan(_aTotal[98],"X77")>0,X77->(LastRec()),0)
nReg88 += IIF(Ascan(_aTotal[98],"X78")>0,R55->(LastRec()),0)
nReg88 += IIF(Ascan(_aTotal[98],"X80")>0,X80->(LastRec()),0)
nReg88 += IIF(Ascan(_aTotal[98],"X82")>0,X82->(LastRec()),0)
nReg88 += IIF(Ascan(_aTotal[98],"X85")>0,X85->(LastRec()),0)
nReg88 += IIF(Ascan(_aTotal[98],"X89")>0,X89->(LastRec()),0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Registro 88-STES - Minas Gerais³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nReg88	+=	nTotSTES

cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
nLin	:=	Prow()+1
@ nLin,00 PSAY Replic("*",80)
nLin	+=2
@ ++nLin,15 PSAY "C.G.C.(MF)........: "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99") //
@ ++nLin,15 PSAY "Inscricao Estadual: "+SM0->M0_INSC //
@ ++nLin,15 PSAY "Razao Social......: "+SM0->M0_NOMECOM //
@ ++nLin,15 PSAY "Endereco..........: "+SM0->M0_ENDENT //
@ ++nLin,15 PSAY "                    "+SM0->M0_CIDENT+" - "+SM0->M0_ESTENT+" - CEP: "+Transform(SM0->M0_CEPENT,"@R 99999-999")
nLin	+=2
@++nLin,15 PSAY "Equipamento.......: "+AllTrim(mv_par09)   // 
@++nLin,15 PSAY "Meio Magnetico....: "+Iif (MV_PAR19==1, "FITA" , "FITA" )  // FITA" 
@++nLin,15 PSAY "Fator de Bloco....:"+MV_PAR20  // 1/1" 
nLin	+=2
@ ++nLin,15 PSAY "Periodo abrangido.: "+DTOC(mv_par01)+" a "+DTOC(mv_par02) //
nLin++
@ ++nLin,15 PSAY "Tipo 10...........: "+Str(1,8)	   +" Registro" //"###
@ ++nLin,15 PSAY "Tipo 11...........: "+Str(1,8)	   +" Registro" //###

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime somente itens existentes no arq. magnetico           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nReg50>0
	@ ++nLin,15 PSAY "Tipo 50...........: "+Str(nReg50,8)	+" Registro(s)" //###
EndIf
If nReg51>0
	@ ++nLin,15 PSAY "Tipo 51...........: "+Str(nReg51,8)	+" Registro(s)" //"Tipo 51...........: "###" Registro(s)"
EndIf
If nReg53>0
	@ ++nLin,15 PSAY "Tipo 53...........: "+Str(nReg53,8)	+" Registro(s)" //"Tipo 53...........: "###" Registro(s)"
EndIf
If nReg54>0
	@ ++nLin,15 PSAY "Tipo 54...........: "+Str(nReg54,8)	+" Registro(s)" //"Tipo 54...........: "###" Registro(s)"
EndIf
If nReg55>0
	@ ++nLin,15 PSAY "Tipo 55...........: "+Str(nReg55,8)	+" Registro(s)" //"Tipo 55...........: "###" Registro(s)"
EndIf
If nReg56>0
	@ ++nLin,15 PSAY "Tipo 55...........: "+Str(nReg56,8)	+" Registro(s)" //"Tipo 55...........: "###" Registro(s)"
EndIf
If nReg60>0
	@ ++nLin,15 PSAY "Tipo 60...........: "+Str(nReg60,8) +" Registro(s)" //"Tipo 60...........: "###" Registro(s)"
EndIf
If nReg61>0
	@ ++nLin,15 PSAY "Tipo 61...........: "+Str(nReg61,8)	+" Registro(s)" //"Tipo 61...........: "###" Registro(s)"
EndIf
If nReg70>0
	@ ++nLin,15 PSAY "Tipo 70...........: "+Str(nReg70,8)	+" Registro(s)" //"Tipo 70...........: "###" Registro(s)"
EndIf
If nReg71>0
	@ ++nLin,15 PSAY "Tipo 71...........: "+Str(nReg71,8)	+" Registro(s)" //"Tipo 71...........: "###" Registro(s)"
EndIf
If nReg74>0
	@ ++nLin,15 PSAY "Tipo 74...........: "+Str(nReg74,8)	+" Registro(s)" //"Tipo 74...........: "###" Registro(s)"
EndIf
If nReg75>0
	@ ++nLin,15 PSAY "Tipo 75...........: "+Str(nReg75,8)	+" Registro(s)" //"Tipo 75...........: "###" Registro(s)"
EndIf
If nReg76>0
	@ ++nLin,15 PSAY "Tipo 76...........: "+Str(nReg76,8)	+" Registro(s)" //"Tipo 76...........: "###" Registro(s)"
EndIf
If nReg77>0
	@ ++nLin,15 PSAY "Tipo 77...........: "+Str(nReg77,8)	+" Registro(s)" //"Tipo 77...........: "###" Registro(s)"
EndIf
If nReg85>0
	@ ++nLin,15 PSAY "Tipo 85...........: "+Str(nReg85,8)	+" Registro(s)" //"Tipo 85...........: "###" Registro(s)"
EndIf                                 
If nReg86>0
	@ ++nLin,15 PSAY "Tipo 86...........: "+Str(nReg86,8)	+" Registro(s)" //"Tipo 86...........: "###" Registro(s)"
EndIf                                 
If nReg88>0
	@ ++nLin,15 PSAY "Tipo 88...........: "+Str(nReg88,8)	+" Registro(s)" //"Tipo 88...........: "###" Registro(s)"
EndIf
If nReg90>0
	@ ++nLin,15 PSAY "Tipo 90...........: "+Str(nReg90,8)	+" Registro(s)" //"Tipo 90...........: "###" Registros(s)"
Endif	
nLin++

nTotReg	:=	2+nReg90+nReg50+nReg51+nReg53+nReg54+nReg55+nReg60+nReg61+nReg70+nReg71+nReg74+nReg75+nReg76+nReg77+nReg85+nReg86+nReg88+nReg56

@ ++nLin,15 PSAY "Total de registros: "+Str(nTotReg,8)+" Registros"//"Total de registros: "###" Registros"
nLin++

If nTotReg>0
	Roda(cbcont,cbtxt,tamanho)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Spool de Impressao                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Printer to
If aReturn[5] == 1
	dbCommitAll()
	Ourspool(aReturn[6])
EndIf

MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao   ³A940DelArq ºAutor  ³ Nereu Humberto Jr. º Data ³  02/01/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.    ³ Apaga arquivos temporarios criados para gerar o arquivo     º±±
±±º         ³ Magnetico                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso      ³ MATA940                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function a940DelArq(aDelArqs)
Local aAreaDel := GetArea()
Local nI := 0

For nI:= 1 To Len(aDelArqs)
	If File(aDelArqs[ni,1]+GetDBExtension())
		dbSelectArea(aDelArqs[ni,2])
		dbCloseArea()
		Ferase(aDelArqs[ni,1]+GetDBExtension())
		Ferase(aDelArqs[ni,1]+OrdBagExt())
	Endif	
Next

RestArea(aAreaDel)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³AjustaSX1 ³ Autor ³ Nereu Humberto Jr     ³ Data ³12.12.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria as perguntas necesarias para o programa                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1()

Local aHelpPor :={} 
Local aHelpEng :={} 
Local aHelpSpa :={} 
      
/*-----------------------MV_PAR21--------------------------*/
Aadd( aHelpPor, "Informe o tipo de identificacao" )
Aadd( aHelpPor, "da natureza das operacoes " )
Aadd( aHelpPor, "informadas conforme tabela de " )
Aadd( aHelpPor, "preenchimento do campo 11 do " )
Aadd( aHelpPor, "registro 10." )
Aadd( aHelpEng, "Informe o tipo de identificacao" )
Aadd( aHelpEng, "da natureza das operacoes " )
Aadd( aHelpEng, "informadas conforme tabela de " )
Aadd( aHelpEng, "preenchimento do campo 11 do " )
Aadd( aHelpEng, "registro 10." )
Aadd( aHelpSpa, "Informe o tipo de identificacao" )
Aadd( aHelpSpa, "da natureza das operacoes " )
Aadd( aHelpSpa, "informadas conforme tabela de " )
Aadd( aHelpSpa, "preenchimento do campo 11 do " )
Aadd( aHelpspa, "registro 10." )

PutSx1( "MTA940","21","Natureza Operacoes","Natureza Operacoes","Natureza Operacoes","mv_chl",;
"N",1,0,3,"C","","","","","MV_PAR21","Inter. ST","Inter. ST","Inter. ST","",;
"Interestadual","Interestadual","Interestadual","Totalidade","Totalidade","Totalidade","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor :={} 
aHelpEng :={} 
aHelpSpa :={} 

/*-----------------------MV_PAR22--------------------------*/
Aadd( aHelpPor, "Informe se o contribuinte destaca"  )
Aadd( aHelpPor, "PIS/COFINS no corpo do documento"   )
Aadd( aHelpPor, "fiscal. Somente serao gerados os"   )
Aadd( aHelpPor, "Registros Tipo 54 com numero"       )
Aadd( aHelpPor, "sequencial de item 993, se essa"    )
Aadd( aHelpPor, "pergunta estiver preenchida com SIM")
Aadd( aHelpEng, "Informe se o contribuinte destaca"  )
Aadd( aHelpEng, "PIS/COFINS no corpo do documento"   )
Aadd( aHelpEng, "fiscal. Somente serao gerados os"   )
Aadd( aHelpEng, "Registros Tipo 54 com numero"       )
Aadd( aHelpEng, "sequencial de item 993, se essa"    )
Aadd( aHelpEng, "pergunta estiver preenchida com SIM")
Aadd( aHelpSpa, "Informe se o contribuinte destaca"  )
Aadd( aHelpSpa, "PIS/COFINS no corpo do documento"   )
Aadd( aHelpSpa, "fiscal. Somente serao gerados os"   )
Aadd( aHelpSpa, "Registros Tipo 54 com numero"       )
Aadd( aHelpSpa, "sequencial de item 993, se essa"    )
Aadd( aHelpSpa, "pergunta estiver preenchida com SIM")

PutSx1( "MTA940","22","Destaca PIS/COFINS?","Destaca PIS/COFINS?","Destaca PIS/COFINS?","mv_chm",;
"N",1,0,1,"C","","","","","mv_par22","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

/*-----------------------MV_PAR23--------------------------*/
aHelpPor :={} 
aHelpEng :={} 
aHelpSpa :={} 

Aadd( aHelpPor, "Informe o numero da Nota Fiscal "   )
Aadd( aHelpPor, "Inicial"                            )
Aadd( aHelpEng, "Informe o numero da Nota Fiscal "   )
Aadd( aHelpEng, "Inicial"                            )
Aadd( aHelpSpa, "Informe o numero da Nota Fiscal "   )
Aadd( aHelpSpa, "Inicial"                            )

PutSx1( "MTA940","23","NF De","NF De","NF De","mv_chn",;
"C",6,0,0,"G","","","","","mv_par23","","","","","","","","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

/*-----------------------MV_PAR24--------------------------*/
aHelpPor :={} 
aHelpEng :={} 
aHelpSpa :={} 

Aadd( aHelpPor, "Informe o numero da Nota Fiscal "   )
Aadd( aHelpPor, "Final"                              )
Aadd( aHelpEng, "Informe o numero da Nota Fiscal "   )
Aadd( aHelpEng, "Final"                              )
Aadd( aHelpSpa, "Informe o numero da Nota Fiscal "   )
Aadd( aHelpSpa, "Final"                              )

PutSx1( "MTA940","24","NF Ate","NF Ate","NF Ate","mv_cho",;
"C",6,0,0,"G","","","","","mv_par24","","","","","","","","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

/*-----------------------MV_PAR25--------------------------*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Foi retirada a pergunta 25 - Tipo Nota Produtor: (MV_PAR25).   ³
//³OBS.: A rotina de exclusao abaixo, devera ser retirada quando  ³
//³for incluida uma nova pergunta.                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SX1->(dbSeek("MTA94025")) .And. AllTrim (SX1->X1_PERGUNT)<>"Filial de"
	RecLock("SX1",.F.)
	dbDelete()
	MsUnlock()
Endif

aHelpPor :={} 
aHelpEng :={} 
aHelpSpa :={} 
Aadd (aHelpPor, "Informe a filial inicial para o         ")	//
Aadd (aHelpPor, "processamento centralizado do relatório.")	// 
Aadd (aHelpPor, "Caso o processamento não seja           ")	//
Aadd (aHelpPor, "centralizado, deixar esta pergunta em   ")	// 
Aadd (aHelpPor, "branco.                                 ")	//

Aadd (aHelpEng, "Informe a filial inicial para o         ")	//"Informe a filial inicial para o         "
Aadd (aHelpEng, "processamento centralizado do relatório.")	//"processamento centralizado do relatório." 
Aadd (aHelpEng, "Caso o processamento não seja           ")	//"Caso o processamento não seja           "
Aadd (aHelpEng, "centralizado, deixar esta pergunta em   ")	//"centralizado, deixar esta pergunta em   " 
Aadd (aHelpEng, "branco.                                 ")	//"branco.                                 "

Aadd( aHelpSpa, "Informe a filial inicial para o         ")	//"Informe a filial inicial para o         "
Aadd( aHelpSpa, "processamento centralizado do relatório.")	//"processamento centralizado do relatório." 
Aadd( aHelpSpa, "Caso o processamento não seja           ")	//"Caso o processamento não seja           "
Aadd( aHelpSpa, "centralizado, deixar esta pergunta em   ")	//"centralizado, deixar esta pergunta em   " 
Aadd( aHelpSpa, "branco.                                 ")	//"branco.                                 "
PutSx1 ("MTA940","25","Filial de","Filial de","Filial de","mv_chp","C",2,0,0,"G","","","","","mv_par25","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)	//

/*-----------------------MV_PAR26--------------------------*/

aHelpPor :={} 
aHelpEng :={} 
aHelpSpa :={} 
Aadd (aHelpPor, "Informe a filial final para o           ")	// 
Aadd (aHelpPor, "processamento centralizado do relatório.")	//"processamento centralizado do relatório." 
Aadd (aHelpPor, "Caso o processamento não seja           ")	//"Caso o processamento não seja           "
Aadd (aHelpPor, "centralizado, deixar esta pergunta em   ")	//"centralizado, deixar esta pergunta em   " 
Aadd (aHelpPor, "branco.                                 ")	//"branco.                                 "

Aadd (aHelpEng, "Informe a filial final para o           ")	//"Informe a filial final para o           " 
Aadd (aHelpEng, "processamento centralizado do relatório.")	//"processamento centralizado do relatório." 
Aadd (aHelpEng, "Caso o processamento não seja           ")	//"Caso o processamento não seja           "
Aadd (aHelpEng, "centralizado, deixar esta pergunta em   ")	//"centralizado, deixar esta pergunta em   " 
Aadd (aHelpEng, "branco.                                 ")	//"branco.                                 "

Aadd (aHelpSpa, "Informe a filial final para o           ")	//"Informe a filial final para o           " 
Aadd (aHelpSpa, "processamento centralizado do relatório.")	//"processamento centralizado do relatório." 
Aadd (aHelpSpa, "Caso o processamento não seja           ")	//"Caso o processamento não seja           "
Aadd (aHelpSpa, "centralizado, deixar esta pergunta em   ")	//"centralizado, deixar esta pergunta em   " 
Aadd (aHelpSpa, "branco.                                 ")	//"branco.                                 "
PutSx1 ("MTA940","26","Filial ate","Filial ate","Filial ate","mv_chq","C",2,0,0,"G","","","","","mv_par26","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)	//
/*-----------------------MV_PAR27--------------------------*/

aHelpPor :={} 
aHelpEng :={} 
aHelpSpa :={} 
Aadd (aHelpPor, "Atendimento ao Art. 121 do ANEXO 5 do   ")	//
Aadd (aHelpPor, "RICMS/SC. O mesmo determina que todo    ")	//
Aadd (aHelpPor, "prestador de serviço de transporte deve ")	//
Aadd (aHelpPor, "apresentar as obrigações acessórias de  ")	//
Aadd (aHelpPor, "forma consolidada pelo estabelecimento  ")	//
Aadd (aHelpPor, "matriz, e esta consolidação deverá      ")	//
Aadd (aHelpPor, "abranger somente as empresas que estive-")	//
Aadd (aHelpPor, "rem domiciliadas no mesmo estado do es- ")	//
Aadd (aHelpPor, "tabelecimento consolidador.             ")	//

Aadd (aHelpEng, "Atendimento ao Art. 121 do ANEXO 5 do   ")	//
Aadd (aHelpEng, "RICMS/SC. O mesmo determina que todo    ")	//
Aadd (aHelpEng, "prestador de serviço de transporte deve ")	//
Aadd (aHelpEng, "apresentar as obrigações acessórias de  ")	//
Aadd (aHelpEng, "forma consolidada pelo estabelecimento  ")	//
Aadd (aHelpEng, "matriz, e esta consolidação deverá      ")	//
Aadd (aHelpEng, "abranger somente as empresas que estive-")	//
Aadd (aHelpEng, "rem domiciliadas no mesmo estado do es- ")	//
Aadd (aHelpEng, "tabelecimento consolidador.             ")	//

Aadd (aHelpSpa, "Atendimento ao Art. 121 do ANEXO 5 do   ")	//
Aadd (aHelpSpa, "RICMS/SC. O mesmo determina que todo    ")	//
Aadd (aHelpSpa, "prestador de serviço de transporte deve ")	//
Aadd (aHelpSpa, "apresentar as obrigações acessórias de  ")	//
Aadd (aHelpSpa, "forma consolidada pelo estabelecimento  ")	//
Aadd (aHelpSpa, "matriz, e esta consolidação deverá      ")	//
Aadd (aHelpSpa, "abranger somente as empresas que estive-")	//
Aadd (aHelpSpa, "rem domiciliadas no mesmo estado do es- ")	//
Aadd (aHelpSpa, "tabelecimento consolidador.             ")	//
PutSx1("MTA940","27","Consolidação na mesma UF","Consolidação na mesma UF","Consolidação na mesma UF","mv_chr","N",1,0,2,"C","","","","","mv_par27","Sim","Sim","Sim","","Nao","Nao","Nao","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)	//"Consolidação na mesma UF"###"Sim"###"Nao"

Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A940Fill     ³Autor ³ Andreia dos Santos  ³ Data ³ 07/01/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Encaixa conteudo em espaco especificado                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function a940Fill(cConteudo,nTam)
	
cConteudo	:=	If(cConteudo==NIL,"",cConteudo)
If Len(cConteudo)>nTam
	cRetorno	:=	Substr(cConteudo,1,nTam)
Else
	cRetorno	:=	cConteudo+Space(nTam-Len(cConteudo))
Endif
	
Return (cRetorno)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³   A940CGC    ³Autor ³    Andreia dos Santos³Data³ 07/01/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna numero de CGC                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                  

Static Function A940CGC(cCliFor,cCGC,cTipo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Zera o campo de CGC para pessoas nao obrigadas a inscricao.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( cTipo=="X")
   If !lTrading
	  cCGC:=""
   Endif	  
Endif

Return(cCGC)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³fSintReg17³ Autor ³ Gustavo G. Rueda      ³ Data ³26.06.2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna uma string contendo o registro 17 no sintegra.      º±±
±±º          ³Inicialmente baseado no layout de Manaus.                   º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpC: Formato do registro 17 do sintegra.                   ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³														      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fSintReg17 ()
	Local	cString	:=	""
	Local	cCodCliente	:=	""
	Local	cCodLoja	:=	""
	Local	aArea	:=	GetArea ()
	Local	cR17	:= ""
	Local	cR18	:= ""
	Local	xRet	:= .T.
	Local	cTipo	:= "N"
	//
	DbSelectArea ("SF2")
	SF2->(DbSetOrder (1))
	If (SF2->(MsSeek (xFilial ("SF2")+R50->A50_NFISC+R50->A50_SERIE)))
		cCodCliente	:=	SF2->F2_CLIENTE
		cCodLoja	:=	SF2->F2_LOJA
		cTipo		:=	SF2->F2_TIPO
	Else  
		DbSelectArea ("SF3")
		SF3->(DbSetOrder (5))
		SF3->(MsSeek (xFilial ("SF3")+R50->A50_SERIE+R50->A50_NFISC))
		//
		cCodCliente	:=	SF3->F3_CLIEFOR
		cCodLoja	:=	SF3->F3_LOJA
		cTipo		:=	SF3->F3_TIPO
	EndIf
	//	
	DbSelectArea ("SA4")
	SA4->(DbSetOrder (1))
	SA4->(MsSeek (xFilial ("SA4")+SF2->F2_REDESP))
	//
	If ! (cTipo$"BD")
		DbSelectArea ("SA1")
		SA1->(DbSetOrder (1))
		SA1->(MsSeek (xFilial ("SA1")+cCodCliente+cCodLoja))
		//Dados do destinatario
		cString	:=	"17"+StrZero (Val (SA1->A1_CGC), 14)+aFisFill (A940IE(SA1->A1_INSCR), 14)+aFisFill (SA1->A1_NOME, 40)
		cString	+=	aFisFill (SA1->A1_END, 40)+aFisFill (SA1->A1_BAIRRO, 20)+aFisFill (SA1->A1_MUN, 20)
		cString	+=	StrZero (Val (SA1->A1_CEP), 8)+aFisFill (SA1->A1_EST, 2)+StrZero (Val (SA1->A1_TEL), 12)
		cR17	:=	StrZero (Val (SA1->A1_CGC),14)+aFisFill (A940IE(SA1->A1_INSCR),14)
	Else
		DbSelectArea ("SA2")
		SA2->(DbSetOrder (1))
		SA2->(MsSeek (xFilial ("SA2")+cCodCliente+cCodLoja))
		//Dados do destinatario
		cString	:=	"17"+StrZero (Val (SA2->A2_CGC), 14)+aFisFill (A940IE(SA2->A2_INSCR), 14)+aFisFill (SA2->A2_NOME, 40)
		cString	+=	aFisFill (SA2->A2_END, 40)+aFisFill (SA2->A2_BAIRRO, 20)+aFisFill (SA2->A2_MUN, 20)
		cString	+=	StrZero (Val (SA2->A2_CEP), 8)+aFisFill (SA2->A2_EST, 2)+StrZero (Val (SA2->A2_TEL), 12)
		cR17	:=	StrZero (Val (SA2->A2_CGC),14)+aFisFill (A940IE(SA2->A2_INSCR),14)
	Endif
	//
	//Dados do redespachador
	If (SA4->(Eof ()))
		cString	+=	"00000000000000"+Space (134)+"00000000"+Space (02)+"000000000000"
		cR17	+=	"00000000000000"+Space(14)
	Else
		cString	+=	StrZero (Val (SA4->A4_CGC), 14)+aFisFill (SA4->A4_INSEST, 14)+aFisFill (SA4->A4_NOME, 40)
		cString	+=	aFisFill (SA4->A4_END, 40)+aFisFill (SA4->A4_BAIRRO, 20)+aFisFill (SA4->A4_MUN, 20)
		cString	+=	StrZero (Val (SA4->A4_CEP), 8)+aFisFill (SA4->A4_EST, 2)+StrZero (Val (SA4->A4_TEL), 12)
		cR17	+=	StrZero (Val (SA4->A4_CGC), 14)+aFisFill (SA4->A4_INSEST, 14)
	EndIf
	//
	_aTotal[51] := .T.	//Condicao para o Registro 18 ser impresso 
	fSintReg18(@cR18)	//Busca Dados do Frete e Local de Entrega ( Registro 18 )
	If ASCAN(_aTotal[50],cR17+cR18) == 0	//Verifica se ja existe Dados do Transporte e Local de Entrega
		AADD(_aTotal[50],cR17+cR18)			//Se verdadeiro o Registro 17 e 18 serao impressos
		xRet := cString	
		_aTotal[51] := .F.
	Endif
	//
	RestArea (aArea)
Return (xRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³fSintReg18³ Autor ³ Gustavo G. Rueda      ³ Data ³26.06.2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna uma string contendo o registro 18 no sintegra.      º±±
±±º          ³Inicialmente baseado no layout de Manaus.                   º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpC: Formato do registro 18 do sintegra.                   ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³														      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fSintReg18 (cR18)
	Local	cString	:=	""
	Local	cCodCliente	:=	""
	Local	cCodLoja	:=	""
	Local	nFrete		:=	0
	Local	aArea	:=	GetArea ()
	Local	xRet	:= .T.
	Local 	cTipo		:= "N"
	Default cR18		:= ""
	//
	DbSelectArea ("SF2")
	SF2->(DbSetOrder (1))
	If (SF2->(MsSeek (xFilial ("SF2")+R50->A50_NFISC+R50->A50_SERIE)))
		cCodCliente	:=	SF2->F2_CLIENTE
		cCodLoja	:=	SF2->F2_LOJA
		nFrete		:=	SF2->F2_FRETE
		cTipo		:=	SF2->F2_TIPO
	Else  
		DbSelectArea ("SF3")
		SF3->(DbSetOrder (5))
		SF3->(MsSeek (xFilial ("SF3")+R50->A50_SERIE+R50->A50_NFISC))
		//
		cCodCliente	:=	SF3->F3_CLIEFOR
		cCodLoja	:=	SF3->F3_LOJA
		nFrete		:=	0
		cTipo		:=	SF3->F3_TIPO
	EndIf		
	//
	If ! (cTipo$"BD")
		DbSelectArea ("SA1")
		SA1->(DbSetOrder (1))
		SA1->(MsSeek (xFilial ("SA1")+cCodCliente+cCodLoja))
		//
		cString	:=	"18"
		cString	+=	Iif (nFrete>0, StrZero (Val (SA1->A1_CGC), 14), StrZero (Val (SM0->M0_CGC), 14))
		cString	+=	Iif (nFrete>0, aFisFill (A940IE(SA1->A1_INSCR), 14), aFisFill (SM0->M0_INSC, 14))
		cString	+=	Iif (nFrete>0, aFisFill (SA1->A1_NOME, 40), aFisFill (SM0->M0_NOMECOM, 40))
		cString	+=	Iif (nFrete>0, aFisFill (SA1->A1_END, 40), aFisFill (SM0->M0_ENDENT, 40))
		cString	+=	Iif (nFrete>0, aFisFill (SA1->A1_BAIRRO, 20), aFisFill (SM0->M0_BAIRENT, 20))
		cString	+=	Iif (nFrete>0, aFisFill (SA1->A1_MUN, 20), aFisFill (SM0->M0_CIDENT, 20))
		cString	+=	Iif (nFrete>0, StrZero (Val (SA1->A1_CEP), 8), StrZero (Val (SM0->M0_CEPENT), 8))
		cString	+=	Iif (nFrete>0, aFisFill (SA1->A1_EST, 2), aFisFill (SM0->M0_ESTENT, 2))
		cString	+=	Iif (nFrete>0, StrZero (Val (SA1->A1_TEL), 12), StrZero (Val (SM0->M0_TEL), 12))
		cString	+=	Iif (Empty (SA1->A1_ENDENT), StrZero (Val (SA1->A1_CGC), 14), StrZero (Val (SA1->A1_CGC), 14))
		cString	+=	Iif (Empty (SA1->A1_ENDENT), aFisFill (A940IE(SA1->A1_INSCR), 14), 	aFisFill (A940IE(SA1->A1_INSCR), 14))
		cString	+=	Iif (Empty (SA1->A1_ENDENT), aFisFill (SA1->A1_NOME, 40), 		aFisFill (SA1->A1_NOME, 40))
		cString	+=	Iif (Empty (SA1->A1_ENDENT), aFisFill (SA1->A1_END, 40), 		aFisFill (SA1->A1_ENDENT, 40))
		cString	+=	Iif (Empty (SA1->A1_ENDENT), aFisFill (SA1->A1_BAIRRO, 20), 	aFisFill (SA1->A1_BAIRROE, 20))
		cString	+=	Iif (Empty (SA1->A1_ENDENT), aFisFill (SA1->A1_MUN, 20), 		aFisFill (SA1->A1_MUNE, 20))
		cString	+=	Iif (Empty (SA1->A1_ENDENT), StrZero (Val (SA1->A1_CEP), 8), 	StrZero (Val (SA1->A1_CEPE), 8))
		cString	+=	Iif (Empty (SA1->A1_ENDENT), aFisFill (SA1->A1_EST, 2), 	aFisFill (SA1->A1_ESTE, 2))
		cString	+=	Iif (Empty (SA1->A1_ENDENT), StrZero (Val (SA1->A1_TEL), 12), 		StrZero (Val (SA1->A1_TEL), 12))
		//
		cR18	:=	Iif (nFrete>0, StrZero (Val (SA1->A1_CGC), 14), StrZero (Val (SM0->M0_CGC), 14))+;
					Iif (nFrete>0, aFisFill (A940IE(SA1->A1_INSCR), 14), aFisFill (SM0->M0_INSC, 14))+;
					StrZero (Val (SA1->A1_CGC), 14)+aFisFill(A940IE(SA1->A1_INSCR),14)
	Else
		DbSelectArea ("SA2")
		SA2->(DbSetOrder (1))
		SA2->(MsSeek (xFilial ("SA2")+cCodCliente+cCodLoja))
		//
		cString	:=	"18"
		cString	+=	Iif (nFrete>0, StrZero (Val (SA2->A2_CGC), 14), StrZero (Val (SM0->M0_CGC), 14))
		cString	+=	Iif (nFrete>0, aFisFill (A940IE(SA2->A2_INSCR), 14), aFisFill (SM0->M0_INSC, 14))
		cString	+=	Iif (nFrete>0, aFisFill (SA2->A2_NOME, 40), aFisFill (SM0->M0_NOMECOM, 40))
		cString	+=	Iif (nFrete>0, aFisFill (SA2->A2_END, 40), aFisFill (SM0->M0_ENDENT, 40))
		cString	+=	Iif (nFrete>0, aFisFill (SA2->A2_BAIRRO, 20), aFisFill (SM0->M0_BAIRENT, 20))
		cString	+=	Iif (nFrete>0, aFisFill (SA2->A2_MUN, 20), aFisFill (SM0->M0_CIDENT, 20))
		cString	+=	Iif (nFrete>0, StrZero (Val (SA2->A2_CEP), 8), StrZero (Val (SM0->M0_CEPENT), 8))
		cString	+=	Iif (nFrete>0, aFisFill (SA2->A2_EST, 2), aFisFill (SM0->M0_ESTENT, 2))
		cString	+=	Iif (nFrete>0, StrZero (Val (SA2->A2_TEL), 12), StrZero (Val (SM0->M0_TEL), 12))
		cString	+=	StrZero (Val (SA2->A2_CGC), 14)
		cString	+=	aFisFill (A940IE(SA2->A2_INSCR), 14)
		cString	+=	aFisFill (SA2->A2_NOME, 40)
		cString	+=	aFisFill (SA2->A2_END, 40)
		cString	+=	aFisFill (SA2->A2_BAIRRO, 20)
		cString	+=	aFisFill (SA2->A2_MUN, 20)
		cString	+=	StrZero (Val (SA2->A2_CEP), 8)
		cString	+=	aFisFill (SA2->A2_EST, 2)
		cString	+=	StrZero (Val (SA2->A2_TEL), 12)
		//
		cR18	:=	Iif (nFrete>0, StrZero (Val (SA2->A2_CGC), 14), StrZero (Val (SM0->M0_CGC), 14))+;
					Iif (nFrete>0, aFisFill (A940IE(SA2->A2_INSCR), 14), aFisFill (SM0->M0_INSC, 14))+;
					StrZero (Val (SA2->A2_CGC), 14)+aFisFill(A940IE(SA2->A2_INSCR),14)
	Endif
    //
	If !_aTotal[51]		//Se verdadeiro o Registro 18 sera impresso
		xRet := cString
	Endif
	//
	RestArea (aArea)
Return (xRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³fSintReg19³ Autor ³ Gustavo G. Rueda      ³ Data ³26.06.2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna uma string contendo o registro 19 no sintegra.      º±±
±±º          ³Inicialmente baseado no layout de Manaus.                   º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpC: Formato do registro 19 do sintegra.                   ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³														      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fSintReg19 ()
	Local	cString		:=	""
	Local	nAcVol		:=	0
	Local	cAcEsp		:=	""
	Local	cCodCliente	:=	""
	Local	cCodLoja	:=	""
	Local	nFrete		:=	0
	Local	nPesoBruto	:=	0
	Local	aArea		:=	GetArea ()
	Local 	nInd		:= 0
	Local 	cTipo		:=	"N"
	//
	DbSelectArea ("SF2")
	SF2->(DbSetOrder (1))
	If (SF2->(MsSeek (xFilial ("SF2")+R50->A50_NFISC+R50->A50_SERIE)))
		cCodCliente	:=	SF2->F2_CLIENTE
		cCodLoja	:=	SF2->F2_LOJA
		nFrete		:=	SF2->F2_FRETE
		nPesoBruto	:=	SF2->F2_PBRUTO
		cTipo		:=	SF2->F2_TIPO
	Else  
		DbSelectArea ("SF3")
		SF3->(DbSetOrder (5))
		SF3->(MsSeek (xFilial ("SF3")+R50->A50_SERIE+R50->A50_NFISC))
		//
		cCodCliente	:=	SF3->F3_CLIEFOR
		cCodLoja	:=	SF3->F3_LOJA
		nFrete		:=	0
		nPesoBruto	:=	0
		cTipo		:=	SF3->F3_TIPO
	EndIf
	//
	If ! (cTipo$"BD")
		DbSelectArea ("SA1")
		SA1->(DbSetOrder (1))
		SA1->(MsSeek (xFilial ("SA1")+cCodCliente+cCodLoja))
	Else
		DbSelectArea ("SA2")
		SA2->(DbSetOrder (1))
		SA2->(MsSeek (xFilial ("SA2")+cCodCliente+cCodLoja))
	Endif
	//
	For nInd := 1 To 3
		cString	:=	"SF2->F2_VOLUME"+Str (nInd, 1)
		//
		nAcVol	+=	&(cString)
	Next (nInd)
	//
	For nInd := 1 To 3
		cString	:=	"SF2->F2_ESPECI"+Str (nInd, 1)
		//
		cAcEsp	+=	&(cString)
	Next (nInd)
	//
	If ! (cTipo$"BD")
		//Dados do destinatario
		cString	:=	"19"+StrZero (Val (SA1->A1_CGC), 14)+aFisFill (A940IE(SA1->A1_INSCR), 14)+aFisFill (R50->A50_SERIE, 3)+;
			StrZero (Val (R50->A50_NFISC), 6)+"0"+Replace (StrZero (nPesoBruto, 9, 3), ".", "")+StrTran(StrZero (SF2->F2_VOLUME4,7,3),".","")+;
			"0"+Replace (StrZero (R50->A50_VALTOT, 13, 2), ".", "")+"0"+Replace (StrZero (nAcVol, 8, 2),".", "")+;
			Iif (nFrete>0, "2", "1")+aFisFill (cAcEsp, 6)
		//
	Else
		//Dados do destinatario
		cString	:=	"19"+StrZero (Val (SA2->A2_CGC), 14)+aFisFill (A940IE(SA2->A2_INSCR), 14)+aFisFill (R50->A50_SERIE, 3)+;
			StrZero (Val (R50->A50_NFISC), 6)+"0"+Replace (StrZero (nPesoBruto, 9, 3), ".", "")+StrTran(StrZero (SF2->F2_VOLUME4,7,3),".","")+;
			"0"+Replace (StrZero (R50->A50_VALTOT, 13, 2), ".", "")+"0"+Replace (StrZero (nAcVol, 8, 2),".", "")+;
			Iif (nFrete>0, "2", "1")+aFisFill (cAcEsp, 6)
		//
	Endif
	RestArea (aArea)
Return (cString)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A940Filtro ³ Autor ³ Edstron E. Correia    ³ Data ³ 30/09/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Filtro generico para a entidade escolhida                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³SINTEGRA                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RF001Fl(nOpc,cFilA940,cEntidade)
Local oWnd		 := GetWndDefault()
Local cDesc 	 := ""
Local lRet 		 := .F.
Local cDescFiltro:= ""
Local oDlgFiltro
Local oDescFiltro

cDescFiltro := IIF(!Empty(cFilA940),MontDescr(cEntidade,cFilA940),"")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza a descricao da selecao.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlgFiltro FROM  00,00 TO 200,310 TITLE "Filtro" PIXEL

	@02,02 TO 75,153 LABEL "Descricao do Filtro" OF oDlgFiltro PIXEL
	@10,05 MSGET oDescFiltro VAR cDescFiltro PICTURE "@!" SIZE 145,60 OF oDlgFiltro PIXEL COLOR CLR_RED WHEN .F.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Filtro para a selecao dos registros da entidade³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DEFINE SBUTTON FROM 80,55  TYPE 17 ENABLE OF oDlgFiltro ACTION (lRet:=.T.,;
																	cFilA940  := BuildExpr(cEntidade,oWnd),;
																	cDescFiltro := MontDescr(cEntidade,cFilA940),;
																	oDescFiltro:Refresh()) WHEN (nOpc == INCLUIR .OR. nOpc == ALTERAR)//Monta o filtro
																	
	DEFINE SBUTTON FROM 80,90  TYPE 1 ENABLE OF oDlgFiltro ACTION oDlgFiltro:End() //Fecha a tela e mantem o filtro
	
	DEFINE SBUTTON FROM 80,125 TYPE 2 ENABLE OF oDlgFiltro ACTION (	lRet:=.F.,;
																	cDescFiltro:="",;
																	oDescFiltro:Refresh(),;
																	oDlgFiltro:End())// Cancela o filtro
																
ACTIVATE MSDIALOG oDlgFiltro CENTERED

Return(lRet,cFilA940)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TOTREG90  ºAutor  ³Gustavo G. Rueda    º Data ³  26/03/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera registro 90 (Toralizador) no formato especifico da     º±±
±±º          ³  TARE-DF, diferente do gerado no SINTEGRA.                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TotReg90 (aRegistros)
	Local	nInd1		:=	0
	Local	cInicial	:=	aRegistros[1][1]+aRegistros[1][2]
	Local	cRegistro	:=	cInicial
	Local	nReg90		:=	0
	Local	nCtdReg		:=	0
	//
	For nInd1 := 2 To Len (aRegistros)
		If (Val (aRegistros[nInd1][2])>0)
			If (Len (cRegistro)>110)
				IncReg90 (@cRegistro, @nReg90, cInicial, nCtdReg, .F.)
				cRegistro	+=	aRegistros[nInd1][1]+aRegistros[nInd1][2]
			Else
				cRegistro	+=	aRegistros[nInd1][1]+aRegistros[nInd1][2]
			EndIf
			//
			nCtdReg	+=	Val (aRegistros[nInd1][2])
		EndIf
	Next (nInd1)
	//
	IncReg90 (@cRegistro, @nReg90, cInicial, nCtdReg, .T.)
Return (.T.)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao ³A940IncReg90 ºAutor  ³ Nereu Humberto Jr. º Data ³  02/01/03   º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.  ³Incremento do registro 90 (Totalizador) especifico para TARE-DFº±±
±±º       ³ no formato diferente do SINTEGRA.                             º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso    ³ MATA940 - Funcao: TotReg90                                    º±±
±±ÈÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IncReg90 (cRegistro, nReg90, cInicial, nCtdReg, lAcabou)

	nReg90++
	
	If (lAcabou)
		nCtdReg++
		cRegistro	+=	Space (117-Len (cRegistro))+StrZero (nCtdReg, 8)
		cRegistro	+=	Alltrim (Str (nReg90))
	Else
		cRegistro	+=	Space (125-Len (cRegistro))
		cRegistro	+=	Alltrim (Str (nReg90))		
	EndIf

	RecLock("R90",.T.)
		R90->A90_REGS := cRegistro
	MsUnlock()
	//
	cRegistro	:=	cInicial
Return (.T.)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao ³CriaTrbs     ºAutor  ³ Gustavo G. Rueda   º Data ³  30/03/04   º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.  ³Montagem dos arquivos de trabalho.                             º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParam. ³ExpL -> lReg88 - Logico para a geracao do TRB para registro 88.º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno³ExpA -> aTrbs - Array contendo alias abertos pela funcao       º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso    ³ MATA940 - Funcao: Sintegra                                    º±±
±±ÈÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaTrbs (lReg88)
	Local cArq050		:= ""
	Local cArq050B		:= ""
	Local cArq050C		:= ""
	Local cArq051		:= ""
	Local cArq052		:= ""
	Local cArq053   	:= ""
	Local cArq054   	:= ""
	Local cArq055   	:= ""
	Local cArq056   	:= ""
	Local cArq060M  	:= ""
	Local cArq060A  	:= ""
	Local cArq060D  	:= ""
	Local cArq60D2  	:= ""
	Local cArq060I  	:= ""
    Local cArq60I2  	:= ""
	Local cArq060R  	:= ""
	Local cArq061   	:= ""
	Local cArq061I  	:= ""	//Resumo Mensal por Item
	Local cArq070   	:= ""
	Local cArq071   	:= ""
	Local cArq074   	:= ""
	Local cArq075   	:= ""
	Local cArq076   	:= ""
	Local cArq077   	:= ""
	Local cArq085		:= ""
	Local cArq086		:= ""
	Local cArq088   	:= ""
	Local cArq090   	:= ""
	Local cArqFUN		:= ""
	Local aStru050  	:= {}
	Local aStru051  	:= {}
	Local aStru052  	:= {}
	Local aStru053  	:= {}
	Local aStru054  	:= {}
	Local aStru055  	:= {}
	Local aStru056  	:= {}
	Local aStru060M 	:= {}
	Local aStru060A 	:= {}
	Local aStru060D 	:= {}
	Local aStru060I 	:= {}
	Local aStru060R 	:= {}
	Local aStru061  	:= {}
	Local aStru061I 	:= {}	//Resumo Mensal por Item
	Local aStru070  	:= {}
	Local aStru071  	:= {}
	Local aStru074  	:= {}
	Local aStru075  	:= {}
	Local aStru076  	:= {}
	Local aStru077  	:= {}
	Local aStru085		:= {}
	Local aStru086		:= {}
	Local aStru088  	:= {}
	Local aStru090  	:= {}
	Local aStruFUN		:= {}
	Local aTrbs			:= {}	
	Local lAglR54		:= GetNewPar ("MV_AGLR54", .F.)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Criacao os arquivos de trabalho                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Registro 050 - Notas Fiscais Modelo 1/1A (ICMS)                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru050,{"A50_CNPJ"	,"C",014,0})
	AADD(aStru050,{"A50_IE"		,"C",014,0})
	AADD(aStru050,{"A50_EMISS"	,"D",008,0})
	AADD(aStru050,{"A50_UF"		,"C",002,0})
	AADD(aStru050,{"A50_MODELO"	,"C",002,0})
	AADD(aStru050,{"A50_SERIE"	,"C",003,0})
	AADD(aStru050,{"A50_NFISC"	,"C",006,0})
	AADD(aStru050,{"A50_CFOP"	,"C",004,0})
	AADD(aStru050,{"A50_EMIT"	,"C",001,0})
	AADD(aStru050,{"A50_VALTOT"	,"N",013,2})
	AADD(aStru050,{"A50_BSICM"	,"N",013,2})
	AADD(aStru050,{"A50_VALICM"	,"N",013,2})
	AADD(aStru050,{"A50_ISENTO"	,"N",013,2})
	AADD(aStru050,{"A50_OUTRAS"	,"N",013,2})
	AADD(aStru050,{"A50_ALQICM"	,"N",005,2})
	AADD(aStru050,{"A50_ALQINT"	,"N",005,2})
	AADD(aStru050,{"A50_SITUAC"	,"C",001,0})
	AADD(aStru050,{"A50_DESPES"	,"N",014,2})
	AADD(aStru050,{"A50_CLIENT","C",006,0})
	AADD(aStru050,{"A50_LOJA"	,"C",002,0})
	AADD(aStru050,{"A50_CNORI"	,"C",014,0})	// CNPJ/CPF original, sem formatacao do meio magnetico
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Campos referentes a SEF-PE                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru050,{"A50_CODIGO"	,"C",006,0})	//Codigo Cliente e/ou Fornecedor
	AADD(aStru050,{"A50_NOME"	,"C",035,0})	//Nome/Denominacao/Razao Social
	AADD(aStru050,{"A50_DTOPER"	,"D",008,0})	//Data da Operacao
	AADD(aStru050,{"A50_TOTNF"	,"N",014,2})	//Vlr. Total da NF 
	AADD(aStru050,{"A50_TBSICM"	,"N",014,2})	//Base de Calc. do ICMS Total
	AADD(aStru050,{"A50_TVALIC"	,"N",014,2})	//Montante Total do Imposto
	AADD(aStru050,{"A50_TISENT"	,"N",014,2})	//Oper./Prest. Isentas ou Nao Trib. - Total
	AADD(aStru050,{"A50_TOUTRA"	,"N",014,2})	//Valor Total que nao confira deb. ou cred. do ICMS
	AADD(aStru050,{"A50_OBSERV"	,"C",070,0})	//Observacao
	AADD(aStru050,{"A50_OBS"	,"N",005,0})	//Sequencial
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Campos para o layout SAPI³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru050,{"A50_CLIFOR"	,"C",006,0})	//CLIENTE OU FORNECEDOR
	AADD(aStru050,{"A50_LOJCF"	,"C",002,0})	//LOJA
	AADD(aStru050,{"A50_TIPO"	,"C",001,0})	//TIPO
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Campo para geracao dos Regs 88SME e 88SMS³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru050,{"A50_CFOMOV","C",004,0})	//CFOP
 	//
	cArq050	:=	CriaTrab(aStru050)
	dbUseArea(.T.,__LocalDriver,cArq050,"R50")
	IndRegua("R50",cArq050,"DTOS(A50_EMISS)")
	dbClearIndex()
	//
	cArq050B := CriaTrab(Nil,.F.)
	IndRegua("R50",cArq050B,"A50_CNPJ+A50_IE")
	dbClearIndex()
	//
	cArq050C := CriaTrab(Nil,.F.)
	IndRegua("R50",cArq050C,"A50_CNPJ+A50_NFISC+A50_SERIE+A50_CFOP+StrZero(A50_ALQICM,5,2)")
	dbClearIndex()
    //
	dbSelectArea("R50")
	dbSetIndex(cArq050+OrdBagExt())
	dbSetIndex(cArq050B+OrdBagExt())
	dbSetIndex(cArq050C+OrdBagExt())
	dbSetOrder(1)
    //
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Registro 051 - Nota Fiscal ( IPI )                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru051,{"A51_CNPJ"	,"C",014,0})
	AADD(aStru051,{"A51_IE"		,"C",014,0})
	AADD(aStru051,{"A51_EMISS"	,"D",008,0})
	AADD(aStru051,{"A51_UF"		,"C",002,0})
	AADD(aStru051,{"A51_SERIE"	,"C",003,0})
	AADD(aStru051,{"A51_NFISC"	,"C",006,0})
	AADD(aStru051,{"A51_CFOP"	,"C",004,0})
	AADD(aStru051,{"A51_VALTOT"	,"N",014,2})
	AADD(aStru051,{"A51_VALIPI"	,"N",014,2})
	AADD(aStru051,{"A51_ISENTA"	,"N",014,2})
	AADD(aStru051,{"A51_OUTRAS"	,"N",014,2})
	AADD(aStru051,{"A51_SITUAC"	,"C",001,0})
	AADD(aStru051,{"A51_CNORI"	,"C",014,0})	// CNPJ/CPF original, sem formatacao do meio magnetico
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Campos referentes a SEF-PE                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru051,{"A51_BASIPI","N",014,2})	//Base de Calc. do IPI
	//
	cArq051	:=	CriaTrab(aStru051)
	dbUseArea(.T.,__LocalDriver,cArq051,"R51")
	IndRegua("R51",cArq051,"Dtos(A51_EMISS)")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Registro 052 - Devolucao total ou parcial de notas fiscais de saidas.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAdd (aStru052, {"A52_CNPJ",	"C",	014,	0})
	aAdd (aStru052, {"A52_IE",		"C",	014,	0})
	aAdd (aStru052, {"A52_EMISS",	"D",	008,	0})
	aAdd (aStru052, {"A52_UF",		"C",	002,	0})
	aAdd (aStru052, {"A52_MODELO",	"C",	002,	0})
	aAdd (aStru052, {"A52_SERIE",	"C",	003,	0})
	aAdd (aStru052, {"A52_NFISC",	"C",	006,	0})
	aAdd (aStru052, {"A52_CFOP",	"C",	004,	0})
	aAdd (aStru052, {"A52_ALQ",		"N",	005,	2})
	aAdd (aStru052, {"A52_VLRTOT",	"N",	013,	2})
	aAdd (aStru052, {"A52_BSCALC",	"N",	013,	2})
	aAdd (aStru052, {"A52_VLRICM",	"N",	013,	2})
	aAdd (aStru052, {"A52_MODDEV",	"C",	002,	0})
	aAdd (aStru052, {"A52_SERDEV",	"C",	003,	0})
	aAdd (aStru052, {"A52_NFIDEV",	"C",	006,	0})
	aAdd (aStru052, {"A52_CFODEV",	"C",	004,	0})
	aAdd (aStru052, {"A52_ALQDEV",	"N",	005,	2})
	aAdd (aStru052, {"A52_CNORI",	"C",	014,	0})	// CNPJ/CPF original, sem formatacao do meio magnetico
	//
	cArq052	:=	CriaTrab (aStru052)
	dbUseArea (.T., __LocalDriver, cArq052, "R52")
	IndRegua ("R52", cArq052, "A52_CNPJ+A52_NFISC+A52_SERIE+A52_CFOP+StrZero (A52_ALQ, 5, 2)")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Registro 053 - Nota Fiscal Subst. Tributaria                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru053,{"A53_CNPJ"	,"C",014,0})
	AADD(aStru053,{"A53_IE"		,"C",014,0})
	AADD(aStru053,{"A53_EMISS"	,"D",008,0})
	AADD(aStru053,{"A53_UF"		,"C",002,0})
	AADD(aStru053,{"A53_MODELO"	,"C",002,0})
	AADD(aStru053,{"A53_SERIE"	,"C",003,0})
	AADD(aStru053,{"A53_NFISC"	,"C",006,0})
	AADD(aStru053,{"A53_CFOP"	,"C",004,0})
	AADD(aStru053,{"A53_EMIT"	,"C",001,0})
	AADD(aStru053,{"A53_BRICMS"	,"N",014,2})
	AADD(aStru053,{"A53_VALRET"	,"N",014,2})
	AADD(aStru053,{"A53_DESPES"	,"N",014,2})
	AADD(aStru053,{"A53_SITUAC"	,"C",001,0})
	AADD(aStru053,{"A53_CNORI"	,"C",014,0})	// CNPJ/CPF original, sem formatacao do meio magnetico
	//
	cArq053	:=	CriaTrab(aStru053)
	dbUseArea(.T.,__LocalDriver,cArq053,"R53")
	IndRegua("R53",cArq053,"A53_CNPJ+A53_NFISC+A53_SERIE+A53_CFOP")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Registro 054 - Itens do documento fiscal                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru054,{"A54_CNPJ"	,"C",014,0})
	AADD(aStru054,{"A54_MODELO"	,"C",002,0})
	AADD(aStru054,{"A54_SERIE"	,"C",003,0})
	AADD(aStru054,{"A54_NFISC"	,"C",006,0})
	AADD(aStru054,{"A54_CFOP"	,"C",004,0})
	AADD(aStru054,{"A54_CST"	,"C",003,0})
	AADD(aStru054,{"A54_NUMITE"	,"C",003,0})
	AADD(aStru054,{"A54_PRODUT"	,"C",014,0})
	AADD(aStru054,{"A54_QUANT"	,"N",014,3})
	AADD(aStru054,{"A54_VALPRO"	,"N",014,2})
	AADD(aStru054,{"A54_VALDES"	,"N",014,2})
	AADD(aStru054,{"A54_BSICM"	,"N",014,2})
	AADD(aStru054,{"A54_BRICMS"	,"N",014,2})
	AADD(aStru054,{"A54_VALIPI"	,"N",014,2})
	AADD(aStru054,{"A54_ALQICM"	,"N",005,2})
	AADD(aStru054,{"A54_CNORI"	,"C",014,0})	// CNPJ/CPF original, sem formatacao do meio magnetico
	AADD(aStru054,{"A54_ALQIPI"	,"N",005,2})	// Aliquota de IPI - Implementacao NFE-BA 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Campos referentes a SEF-PE                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru054,{"A54_IE"		,"C",014,0})
	AADD(aStru054,{"A54_EMISS"	,"D",008,0})	//Dt. Emissao ou Recebimento
	AADD(aStru054,{"A54_UF"		,"C",002,0})
	AADD(aStru054,{"A54_APUR"	,"N",002,0})	//Cod. Apuracao PRODEPE/FUNCRESCE
	AADD(aStru054,{"A54_INDESP"	,"N",002,0})	//Indicador Especial
	AADD(aStru054,{"A54_VALICM"	,"N",014,2})	
	AADD(aStru054,{"A54_ICMRET"	,"N",014,2})	
	AADD(aStru054,{"A54_PRORI"	,"C",15,0})	//Codigo do produto original sem conversao para o NCM igual ocorre no campo A54_PRODUT
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Campos referente ao FUNCEP/PB³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru054,{"A54_FUNCEP"	,"C",1,0})
	AADD(aStru054,{"A54_ICMDIF"	,"N",014,2})	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Campos para o Sintegra-MG    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru054,{"A54_DTEMI"	,"D",008,0})	//Data da Emissao
	AADD(aStru054,{"A54_DTSAI"	,"D",008,0})	//Data da Saida ou Entrada
	AADD(aStru054,{"A54_ALIQST"	,"N",005,2})	//Aliquota do ICMS ST
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³FLAG DE CONTRIBUINTE TARE³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru054,{"A54_CTARE"	,"C",001,0})	//Aliquota do ICMS ST
	//
	cArq054	:=	CriaTrab(aStru054)
	dbUseArea(.T.,__LocalDriver,cArq054,"R54")
	If (lAglR54)
		IndRegua("R54",cArq054,"A54_CNPJ+A54_SERIE+A54_NFISC+A54_PRODUT+Str (A54_ALQICM, 5, 2)+A54_NUMITE")
	Else	
		IndRegua("R54",cArq054,"A54_CNPJ+A54_SERIE+A54_NFISC+A54_NUMITE")
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Arquivo do Registro tipo 55 - Guia Nacional de Recolhimento de Tributos Estaduais³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru055,{"A55_CNPJ"	,"C",014,0})
	AADD(aStru055,{"A55_IE"		,"C",014,0})
	AADD(aStru055,{"A55_DATPAG"	,"D",008,0})
	AADD(aStru055,{"A55_UFSUBS"	,"C",002,0})
	AADD(aStru055,{"A55_UFFAV"	,"C",002,0})
	AADD(aStru055,{"A55_BANCO"	,"C",003,0})
	AADD(aStru055,{"A55_AGENC"	,"C",004,0})
	AADD(aStru055,{"A55_NUMERO"	,"C",020,0})
	AADD(aStru055,{"A55_VALOR"	,"N",014,2})
	AADD(aStru055,{"A55_VENCTO"	,"D",008,0})
	AADD(aStru055,{"A55_MESANO"	,"C",006,0})
	AADD(aStru055,{"A55_CONVEN"	,"C",030,0})
	AADD(aStru055,{"A55_CNORI"	,"C",014,0})	// CNPJ/CPF original, sem formatacao do meio magnetico
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Campos referentes a SEF-PE                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru055,{"X78_VLRDAE"	,"N",014,2})
	AADD(aStru055,{"X78_RECDAE"	,"C",004,0})
	AADD(aStru055,{"X78_PERFIS"	,"C",006,0})
	AADD(aStru055,{"X78_DTVECT"	,"D",008,0})
	//
	cArq055	:=	CriaTrab(aStru055)
	dbUseArea(.T.,__LocalDriver,cArq055,"R55")
	IndRegua("R55",cArq055,"DTOS(A55_DATPAG)") 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Registro 56 (Operacoes com veiculos automotores novos) para ser alimentado através de um ponto de entrada.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAdd (aStru056, {"A56_CNPJ",	"C",	014,	0})
	aAdd (aStru056, {"A56_MODELO",	"N",	002,	0})
	aAdd (aStru056, {"A56_SERIE",	"C",	003,	0})
	aAdd (aStru056, {"A56_NUMERO",	"C",	006,	0})
	aAdd (aStru056, {"A56_CFOP",	"C",	004,	0})
	aAdd (aStru056, {"A56_CST",		"N",	003,	0})
	aAdd (aStru056, {"A56_NRIT",	"N",	003,	0})
	aAdd (aStru056, {"A56_PROD",	"C",	014,	0})
	aAdd (aStru056, {"A56_OPER",	"N",	001,	0})
	aAdd (aStru056, {"A56_CNPJC",	"N",	014,	0})
	aAdd (aStru056, {"A56_ALQIPI",	"N",	005,	2})
	aAdd (aStru056, {"A56_CHASSI",	"C",	017,	0})
	aAdd (aStru056, {"A56_CNORI",	"C",	014,	0})	// CNPJ/CPF original, sem formatacao do meio magnetico
	//
	cArq056	:=	CriaTrab (aStru056)
	dbUseArea (.T.,__LocalDriver, cArq056, "R56")
	IndRegua ("R56", cArq056, "A56_CNPJ+A56_NUMERO+A56_SERIE+A56_CFOP+A56_PROD")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Registro 060 - ECF(Mestre do equipamento)                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru060M,{"M60_EMISS"	,"D",008,0})
	AADD(aStru060M,{"M60_NUMFAB","C",020,0})
	AADD(aStru060M,{"M60_PDV"	,"C",003,0})
	AADD(aStru060M,{"M60_MODELO","C",002,0})
	AADD(aStru060M,{"M60_NUMINI","C",006,0})
	AADD(aStru060M,{"M60_NUMFIM","C",006,0})
	AADD(aStru060M,{"M60_REDUCZ","C",006,0})
	AADD(aStru060M,{"M60_CRO"	,"N",003,0})
	AADD(aStru060M,{"M60_VENDA"	,"N",016,2})
	AADD(aStru060M,{"M60_GERAL"	,"N",016,2})
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Campos referentes a SEF-PE                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru060M,{"M60_GTINI"	,"N",014,2})	//Grande Total Inicial
	AADD(aStru060M,{"M60_VLIQ"	,"N",014,2})	//Venda Liquida
	AADD(aStru060M,{"M60_ICMSD"	,"N",014,2})	//ICMS Debitado
	AADD(aStru060M,{"M60_OBS"	,"N",005,0})	//Observacao-Sequencial
	//
	cArq060M :=	CriaTrab(aStru060M)
	dbUseArea(.T.,__LocalDriver,cArq060M,"M60")
	IndRegua("M60",cArq060M,"DTOS(M60_EMISS)+M60_PDV")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Registro 060A - ECF(Analitico)                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru060A,{"A60_EMISS"	,"D",008,0})
	AADD(aStru060A,{"A60_NUMFAB","C",020,0})
	AADD(aStru060A,{"A60_SITTRI","C",004,0})
	AADD(aStru060A,{"A60_VALOR"	,"N",014,2})
	//
	cArq060A	:=	CriaTrab(aStru060A)
	dbUseArea(.T.,__LocalDriver,cArq060A,"A60")
	IndRegua("A60",cArq060A,"DTOS(A60_EMISS)+A60_NUMFAB+A60_SITTRI")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Registro 060D - ECF ( Resumo Diario )                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru060D,{"D60_EMISS"	,"D",008,0})
	AADD(aStru060D,{"D60_NUMFAB","C",020,0})
	AADD(aStru060D,{"D60_CODPRO","C",014,0})
	AADD(aStru060D,{"D60_QUANT" ,"N",013,3})
	AADD(aStru060D,{"D60_VALOR" ,"N",016,2})
	AADD(aStru060D,{"D60_BSICM" ,"N",016,2})
	AADD(aStru060D,{"D60_SITTRI","C",004,0})
	AADD(aStru060D,{"D60_VLICM" ,"N",013,2})
	//
	cArq060D	:=	CriaTrab(aStru060D)
	dbUseArea(.T.,__LocalDriver,cArq060D,"D60")
	IndRegua("D60",cArq060D,"DTOS(D60_EMISS)+D60_CODPRO+D60_NUMFAB")
    cArq60D2  :=CriaTrab(NIL,.F.)
    IndRegua("D60",cArq60D2,"DTOS(D60_EMISS)+D60_NUMFAB")
    DbClearIndex()
    DbSetIndex(cArq060D+OrdBagExt())
    DbSetIndex(cArq60D2+OrdBagExt())
    DbSetOrder(1)
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Registro 060I - ECF ( Itens do documento )                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru060I,{"I60_EMISS" ,"D",008,0})
	AADD(aStru060I,{"I60_NUMFAB","C",020,0})
	AADD(aStru060I,{"I60_MODELO","C",002,0})
	AADD(aStru060I,{"I60_COO"   ,"C",006,0})
	AADD(aStru060I,{"I60_ITEM"  ,"C",003,0})
	AADD(aStru060I,{"I60_CODPRO","C",014,0})
	AADD(aStru060I,{"I60_QUANT" ,"N",013,3})
	AADD(aStru060I,{"I60_VLUNI" ,"N",013,2})
	AADD(aStru060I,{"I60_VALOR" ,"N",013,2})
	AADD(aStru060I,{"I60_BSICM" ,"N",012,2})
	AADD(aStru060I,{"I60_SITTRI","C",004,0})
	AADD(aStru060I,{"I60_VLICM" ,"N",012,2})
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Implementação do FUNCEP/PB³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru060I,{"I60_FUNCEP","C",001,0})
	AADD(aStru060I,{"I60_BSST","N",012,2})	
	AADD(aStru060I,{"I60_CFOP"	,"C",004,2})
	//
	cArq060I	:=	CriaTrab(aStru060I)
	dbUseArea(.T.,__LocalDriver,cArq060I,"I60")
	IndRegua("I60",cArq060I,"DTOS(I60_EMISS)+I60_NUMFAB+I60_COO+I60_CODPRO")
	cArq60I2  :=CriaTrab(NIL,.F.)
    IndRegua("I60",cArq60I2,"DTOS(I60_EMISS)+I60_NUMFAB")
    DbClearIndex()
    DbSetIndex(cArq060I+OrdBagExt())
    DbSetIndex(cArq60I2+OrdBagExt())
    DbSetOrder(1)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Registro 060R - ECF ( Resumo Mensal )                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru060R,{"R60_MESANO","C",006,0})
	AADD(aStru060R,{"R60_CODPRO","C",014,0})
	AADD(aStru060R,{"R60_QUANT" ,"N",013,3})
	AADD(aStru060R,{"R60_VALOR" ,"N",016,2})
	AADD(aStru060R,{"R60_BSICM" ,"N",016,2})
	AADD(aStru060R,{"R60_SITTRI","C",004,0})
	//
	cArq060R	:=	CriaTrab(aStru060R)
	dbUseArea(.T.,__LocalDriver,cArq060R,"R60")
	IndRegua("R60",cArq060R,"R60_MESANO+R60_CODPRO+R60_SITTRI")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Arquivo do Registro tipo 61 - Docs.Fiscais nao emitidos por ECF ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru061,{"A61_EMISS"	,"D",008,0})
	AADD(aStru061,{"A61_MODELO"	,"C",002,0})
	AADD(aStru061,{"A61_SERIE"	,"C",003,0})
	AADD(aStru061,{"A61_SUBSER"	,"C",002,0})
	AADD(aStru061,{"A61_NUMINI"	,"C",006,0})
	AADD(aStru061,{"A61_NUMFIM"	,"C",006,0})
	AADD(aStru061,{"A61_VALTOT"	,"N",014,2})
	AADD(aStru061,{"A61_BSICM"	,"N",014,2})
	AADD(aStru061,{"A61_VALICM"	,"N",014,2})
	AADD(aStru061,{"A61_ISENTA"	,"N",014,2})
	AADD(aStru061,{"A61_OUTRAS"	,"N",014,2})
	AADD(aStru061,{"A61_ALQICM"	,"N",005,2})
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Campos referentes a SEF-PE                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru061,{"A61_LANCCO"	,"C",012,0})	//Numero de Lanc. Contabil
	AADD(aStru061,{"A61_CFOP"	,"C",004,0})
	AADD(aStru061,{"A61_OBS"	,"N",005,0})	//Observacao-Sequencial
	//
	cArq061	:=	CriaTrab(aStru061)
	dbUseArea(.T.,__LocalDriver,cArq061,"R61")
	IndRegua("R61",cArq061,"DTOS(A61_EMISS)+STR(A61_ALQICM,5,2)+A61_CFOP")
	//Ú Convenio 76/2003 ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Arquivo do Registro Tipo 61 Subtipo "R" - Resumo Mensal por Item de NF's ³
	//³nao emitidos por ECF                                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru061I,{"I61_MESANO"	,"C",006,0})	//Mes e Ano de Emissao "MMAAAA"
	AADD(aStru061I,{"I61_CODPRO"	,"C",014,0})	//Codigo do Produto do Informante
	AADD(aStru061I,{"I61_QUANT"		,"N",013,3})	//Qtde. Acum. do Prod. Vendida no Mes
	AADD(aStru061I,{"I61_VLBRUT"	,"N",016,2})	///Vlr. Bruto Acum. na Venda do Prod. no Mes
	AADD(aStru061I,{"I61_BCICMS"	,"N",016,2})	//Base de Calculo do ICMS do Vlr. Acum. no Mes
	AADD(aStru061I,{"I61_ALIQ"		,"N",005,2})	//Aliquota do ICMS do Prod.
	//
	cArq061I := CriaTrab(aStru061I)
	dbUseArea(.T.,__LocalDriver,cArq061I,"I61")
	IndRegua("I61",cArq061I,"I61_CODPRO+STR(I61_ALIQ,5,2)") 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Registro 070 - Documento de Conhecimento de Transporte                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru070,{"A70_CNPJ"	,"C",014,0})
	AADD(aStru070,{"A70_IE"		,"C",014,0})
	AADD(aStru070,{"A70_EMISS"	,"D",008,0})
	AADD(aStru070,{"A70_UF"		,"C",002,0})
	AADD(aStru070,{"A70_MODELO"	,"C",002,0})
	AADD(aStru070,{"A70_SERIE"	,"C",001,0})
	AADD(aStru070,{"A70_SUBSER"	,"C",002,0})
	AADD(aStru070,{"A70_NFISC"	,"C",006,0})
	AADD(aStru070,{"A70_CFOP"	,"C",004,0})
	AADD(aStru070,{"A70_VALTOT"	,"N",015,2})
	AADD(aStru070,{"A70_BSICM"	,"N",015,2})
	AADD(aStru070,{"A70_VALICM"	,"N",015,2})
	AADD(aStru070,{"A70_ISENTA"	,"N",015,2})
	AADD(aStru070,{"A70_OUTRAS"	,"N",015,2})
	AADD(aStru070,{"A70_CIfFOB"	,"C",001,0})
	AADD(aStru070,{"A70_SITUAC"	,"C",001,0})
	AADD(aStru070,{"A70_CNORI"	,"C",014,0})	// CNPJ/CPF original, sem formatacao do meio magnetico
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Campos referentes a SEF-PE                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru070,{"A70_NOME"	,"C",035,0})	//Nome/Denominacao/Razao Social
	AADD(aStru070,{"A70_DTOP"	,"D",008,0})	//Dt. Operacao
	AADD(aStru070,{"A70_LANCC"	,"C",012,0})	//Numero de Lanc. Contabil
	AADD(aStru070,{"A70_ALQICM"	,"N",005,2})	//Aliquota de ICMS
	AADD(aStru070,{"A70_OBS"	,"N",005,0})	//Observacao-Sequencial
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Campos para o layout SAPI³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru070,{"A70_CLIFOR"	,"C",006,0})	//CLIENTE OU FORNECEDOR
	AADD(aStru070,{"A70_LOJCF"	,"C",002,0})	//LOJA
	AADD(aStru070,{"A70_TIPO"	,"C",001,0})	//TIPO
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Campo para geracao dos Regs 88SME e 88SMS³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru070,{"A70_CFOMOV","C",004,0})	//CFOP
	//
	cArq070	:=	CriaTrab(aStru070)
	dbUseArea(.T.,__LocalDriver,cArq070,"R70")
	IndRegua("R70",cArq070,"DTOS(A70_EMISS)")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Registro 071 - Complemento do Conhecimento de Transporte                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru071,{"A71_CGCTOM"	,"C",014,0})
	AADD(aStru071,{"A71_IETOM"	,"C",014,0})
	AADD(aStru071,{"A71_DTCONH"	,"D",008,0})
	AADD(aStru071,{"A71_UFTOM"	,"C",002,0})
	AADD(aStru071,{"A71_MODCON"	,"C",002,0})
	AADD(aStru071,{"A71_SERCON"	,"C",001,0})
	AADD(aStru071,{"A71_SUBCON"	,"C",002,0})
	AADD(aStru071,{"A71_NUMCON"	,"C",006,0})
	AADD(aStru071,{"A71_UFREM"	,"C",002,0})
	AADD(aStru071,{"A71_CGCREM"	,"C",014,0})
	AADD(aStru071,{"A71_IEREM"	,"C",014,0})
	AADD(aStru071,{"A71_DTNOTA"	,"D",008,0})
	AADD(aStru071,{"A71_MODNOT"	,"C",002,0})
	AADD(aStru071,{"A71_SERNOT"	,"C",003,0})
	AADD(aStru071,{"A71_NUMNOT"	,"C",006,0})
	AADD(aStru071,{"A71_VALNOT"	,"N",014,2}) 
	//
	cArq071	:=	CriaTrab(aStru071)
	dbUseArea(.T.,__LocalDriver,cArq071,"R71")
	IndRegua("R71",cArq071,"DTOS(A71_DTCONH)")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Registro 074 - Registro de Inventario                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par10 == 2  // Cria a estrutura quando nao for gerar inventario para nao dar problema no INI
		AADD(aStru074,{"A74_DTINVE"	,"D",008,0})
		AADD(aStru074,{"A74_PRODUT"	,"C",014,0})
		AADD(aStru074,{"A74_QUANT"	,"N",013,3})
		AADD(aStru074,{"A74_CUSTO"	,"N",013,2})
		AADD(aStru074,{"A74_SITUAC"	,"C",001,0})
		AADD(aStru074,{"A74_CNPJ"	,"C",014,0})
		AADD(aStru074,{"A74_IE"  	,"C",014,0})
		AADD(aStru074,{"A74_UF"  	,"C",002,0})
		AADD(aStru074,{"A74_CNORI"	,"C",014,0})	// CNPJ/CPF original, sem formatacao do meio magnetico
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Campos referentes a SEF-PE                                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AADD(aStru074,{"A74_OBS"	,"N",005,0})
		//
		cArq074  :=	CriaTrab(aStru074)
		dbUseArea(.T.,__LocalDriver,cArq074,"R74")
		IndRegua("R74",cArq074,"DTOS(A74_DTINVE)")
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Registro 075 - Relacao de Produtos e Servicos                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru075,{"A75_DTAINI"	,"D",008,0})
	AADD(aStru075,{"A75_DTAFIM"	,"D",008,0})
	AADD(aStru075,{"A75_PROD"	,"C",014,0})
	AADD(aStru075,{"A75_CODNCM"	,"C",008,0})
	AADD(aStru075,{"A75_DESCR"	,"C",053,0})
	AADD(aStru075,{"A75_UM"		,"C",006,0})
	AADD(aStru075,{"A75_SITTRI"	,"C",003,0})
	AADD(aStru075,{"A75_ALQIPI"	,"N",005,2})
	AADD(aStru075,{"A75_ALQICM"	,"N",005,2})
	AADD(aStru075,{"A75_REDBSE"	,"N",006,2})
	AADD(aStru075,{"A75_BRICMS"	,"N",014,2})
	AADD(aStru075,{"A75_PRORI"	,"C",015,0})
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³FLAG DE CONTRIBUINTE TARE³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru075,{"A75_CTARE"	,"C",001,0})	//Aliquota do ICMS ST
	//
	cArq075	  :=	CriaTrab(aStru075)
	dbUseArea(.T.,__LocalDriver,cArq075,"R75")
	IndRegua("R75",cArq075,"DTOS(A75_DTAINI)+DTOS(A75_DTAFIM)+A75_PROD+A75_CODNCM+A75_UM")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Registro 076 - Nota Fiscal Servico de Comunicacao/Telecomunicacao (mod.21/mod.22) ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru076,{"A76_CNPJ"	,"C",014,0})
	AADD(aStru076,{"A76_IE"		,"C",014,0})
	AADD(aStru076,{"A76_MODELO"	,"C",002,0})
	AADD(aStru076,{"A76_SERIE"	,"C",002,0})
	AADD(aStru076,{"A76_SUBSER"	,"C",002,0})
	AADD(aStru076,{"A76_NFISC"	,"C",006,0})
	AADD(aStru076,{"A76_CFOP"	,"C",004,0})
	AADD(aStru076,{"A76_TIPREC"	,"C",001,0})
	AADD(aStru076,{"A76_EMISS"	,"D",008,0})
	AADD(aStru076,{"A76_UF"		,"C",002,0})
	AADD(aStru076,{"A76_VALTOT"	,"N",013,2})
	AADD(aStru076,{"A76_BRICMS"	,"N",013,2})
	AADD(aStru076,{"A76_VALICM"	,"N",012,2})
	AADD(aStru076,{"A76_ISENTA"	,"N",012,2})
	AADD(aStru076,{"A76_OUTRAS"	,"N",012,2})
	AADD(aStru076,{"A76_ALQICM"	,"N",005,2})
	AADD(aStru076,{"A76_SITUAC"	,"C",001,0})
	AADD(aStru076,{"A76_CNORI"	,"C",014,0})	// CNPJ/CPF original, sem formatacao do meio magnetico
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Campos referentes a SEF-PE                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru076,{"A76_CODIGO"	,"C",006,0})	//Codigo Cliente e/ou Fornecedor
	AADD(aStru076,{"A76_LOJA"	,"C",002,0})	//Loja
	AADD(aStru076,{"A76_TVLTOT"	,"N",013,2})	//Valor Total
	AADD(aStru076,{"A76_TBICMS"	,"N",013,2})	//Base de Calculo do ICMS Total
	AADD(aStru076,{"A76_TOTICM"	,"N",012,2})	//Valor do ICMS Total
	AADD(aStru076,{"A76_TISENT"	,"N",012,2})	//Prest. Isentas ou Nao Trib. - Total
	AADD(aStru076,{"A76_TOUTRA"	,"N",012,2})	//Outras - Total
	AADD(aStru076,{"A76_OBS"	,"N",005,0})	//Observacao-Sequencia
	//
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Campo para geracao dos Regs 88SME e 88SMS³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru076,{"A76_CFOMOV","C",004,0})	//CFOP
	//
	cArq076	:=	CriaTrab(aStru076)
	dbUseArea(.T.,__LocalDriver,cArq076,"R76")
	IndRegua("R76",cArq076,"DTOS(A76_EMISS)")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Registro 077 - Servicos de Comunicacao de Telecomunicacao                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru077,{"A77_CNPJ"	,"C",014,0})
	AADD(aStru077,{"A77_MODELO"	,"C",002,0})
	AADD(aStru077,{"A77_SERIE"	,"C",002,0})
	AADD(aStru077,{"A77_SUBSER"	,"C",002,0})
	AADD(aStru077,{"A77_NFISC"	,"C",006,0})
	AADD(aStru077,{"A77_CFOP"	,"C",004,0})
	AADD(aStru077,{"A77_TIPREC"	,"C",001,0})
	AADD(aStru077,{"A77_NUMITE"	,"C",003,0})
	AADD(aStru077,{"A77_PRODUT"	,"C",011,0})
	AADD(aStru077,{"A77_QUANT"	,"N",013,3})
	AADD(aStru077,{"A77_VALPRO"	,"N",012,2})
	AADD(aStru077,{"A77_VALDES"	,"N",012,2})
	AADD(aStru077,{"A77_BSICM"	,"N",012,2})
	AADD(aStru077,{"A77_ALQICM"	,"N",005,2})
	AADD(aStru077,{"A77_CNPJMF"	,"C",014,0})
	AADD(aStru077,{"A77_CODTER"	,"C",010,0})
	AADD(aStru077,{"A77_CNORI"	,"C",014,0})	// CNPJ/CPF original, sem formatacao do meio magnetico
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Campos referentes a SEF-PE                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru077,{"A77_IE"		,"C",014,0})
	AADD(aStru077,{"A77_DTEMIS"	,"D",008,0})	//Dt. Emissao ou Recebimento
	AADD(aStru077,{"A77_UF"		,"C",002,0})	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Campo para geracao dos Regs 88SME e 88SMS³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru077,{"A77_CFOMOV","C",004,0})	//CFOP
	//
	cArq077	:=	CriaTrab(aStru077)
	dbUseArea(.T.,__LocalDriver,cArq077,"R77")
	IndRegua("R77",cArq077,"A77_PRODUT")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Registro 085 - Informacoes de Exportacoes                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru085,{"A85_DECL"	,"C",020,0})
	AADD(aStru085,{"A85_DTDECL"	,"D",008,0})
	AADD(aStru085,{"A85_AVERBA"	,"C",001,0})
	AADD(aStru085,{"A85_REGEX"	,"C",012,0})
	AADD(aStru085,{"A85_DTREGX"	,"D",008,0})
	AADD(aStru085,{"A85_CONHEC"	,"C",020,0})
	AADD(aStru085,{"A85_DTCONH"	,"D",008,0})
	AADD(aStru085,{"A85_TPCONH"	,"N",002,0})
	AADD(aStru085,{"A85_PAIS"	,"C",004,0})
	AADD(aStru085,{"A85_COMPRO"	,"C",012,0})
	AADD(aStru085,{"A85_DTCOMP"	,"D",008,0})
	AADD(aStru085,{"A85_NFEXP"	,"C",006,0})
	AADD(aStru085,{"A85_DTNF"	,"D",008,0}) 
	AADD(aStru085,{"A85_MODEL"	,"C",002,0})
	AADD(aStru085,{"A85_SERIE"	,"C",003,0})
	//
	cArq085	:=	CriaTrab(aStru085)
	dbUseArea(.T.,__LocalDriver,cArq085,"R85")
	IndRegua("R85",cArq085,"A85_DECL+A85_NFEXP+A85_SERIE")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Registro 086 - Informacoes Complementares de Exportacoes                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru086,{"A86_REGEXP"	,"C",012,0})
	AADD(aStru086,{"A86_DTREG"	,"D",008,0})
	AADD(aStru086,{"A86_CNPJ"	,"C",014,0})
	AADD(aStru086,{"A86_IE"		,"C",014,0})
	AADD(aStru086,{"A86_UF"		,"C",002,0})
	AADD(aStru086,{"A86_NF"		,"C",006,0})
	AADD(aStru086,{"A86_DATA"	,"D",008,0})
	AADD(aStru086,{"A86_MODELO"	,"C",002,0})
	AADD(aStru086,{"A86_SERIE"	,"C",003,0})
	AADD(aStru086,{"A86_PROD"	,"C",014,0})
	AADD(aStru086,{"A86_QUANT"	,"N",011,3})
	AADD(aStru086,{"A86_UNIT"	,"N",012,2})
	AADD(aStru086,{"A86_VALPR"	,"N",012,2})
	AADD(aStru086,{"A86_RELAC"	,"N",001,0})
	AADD(aStru086,{"A86_PRORI"	,"C",015,0})
	//
	cArq086	:=	CriaTrab(aStru086)
	dbUseArea(.T.,__LocalDriver,cArq086,"R86")
	IndRegua("R86",cArq086,"A86_REGEXP+A86_PROD+A86_NF+A86_SERIE")
	//
	If lReg88
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Registro 088 - Detalhe GT (Polo Gas Quimico e Termogeracao de Energia Eletrica a Gas)³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AADD(aStru088,{"A88_TIPO"	,"N",002,0})
		AADD(aStru088,{"A88_SUBTIP" ,"C",002,0})
		AADD(aStru088,{"A88_TIPINF"	,"C",001,0})
		AADD(aStru088,{"A88_INSEST"	,"C",014,0})
		AADD(aStru088,{"A88_DTEMIS"	,"D",008,0})
		AADD(aStru088,{"A88_UF"	    ,"C",002,0})
		AADD(aStru088,{"A88_MODELO"	,"C",002,0})
		AADD(aStru088,{"A88_SERIE"	,"C",002,0})
		AADD(aStru088,{"A88_NTFISC"	,"C",006,0})
		AADD(aStru088,{"A88_VALPRO"	,"N",013,2})
		AADD(aStru088,{"A88_VALICM"	,"N",013,2})
		AADD(aStru088,{"A88_DECLIM"	,"N",010,0})
		AADD(aStru088,{"A88_DTDI"	,"D",008,0})
		AADD(aStru088,{"A88_DESCPR"	,"C",043,0})
		//
		cArq088	:=	CriaTrab(aStru088)
		dbUseArea(.T.,__LocalDriver,cArq088,"R88")
		IndRegua("R88",cArq088,"A88_NTFISC+A88_SERIE")
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Totalizador do Registro 61 - FUNCEP³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStruFUN,{"FUN_ICMS"	,"N",012,2})
	AADD(aStruFUN,{"FUN_STSAI"	,"N",012,2})
	//
	cArqFUN	:=	CriaTrab(aStruFUN)
	dbUseArea(.T.,__LocalDriver,cArqFUN,"FUN")
	IndRegua("FUN",cArqFUN,"Str(FUN_ICMS,12,2)")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Arquivo do Registro tipo 90 - Totalizador do Arquivo                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru090,{"A90_REGS"	,"C",126,0})
	//
	cArq090	:=	CriaTrab(aStru090)
	dbUseArea(.T.,__LocalDriver,cArq090,"R90")
	IndRegua("R90",cArq090,"LEFT(A90_REGS,10)") 
	//
	aTrbs	:=	{{cArq050,"R50"},{cArq051,"R51"},{cArq053,"R53"},{cArq054,"R54"},{cArq055,"R55"},;
			{cArq060M,"M60"},{cArq060A,"A60"},{cArq060D,"D60"},{cArq060I,"I60"},{cArq060R,"R60"},;
			{cArq061,"R61"},{cArq061I,"I61"},{cArq070,"R70"},{cArq071,"R71"},IIF(mv_par10==2,{cArq074,"R74"},{"",""}),;
			{cArq075,"R75"},{cArq076,"R76"},{cArq077,"R77"},{cArq088,"R88"},{cArq090,"R90"},{cArq056,"R56"},{cArq052,"R52"},;
			{cArqFun,"FUN"}}
			//	
Return (aTrbs)


























/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao ³ Reg60Ord()  ºAutor³ Thiago Galvao Silveira º Data ³ 21/05/04  º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.  ³Gera um arquivo temporario com os dados do registro 60 M/A/D/I º±±
±±º       ³colocados na ordem pedida pelo Convenio 142/02                 º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso    ³ MATA940 - Funcao: Sintegra                                    º±±
±±ÈÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static function Reg60Ord()

Local aReg60   := {}
Local cArq60   := ""
Local dDtEmM   := ""
Local cNumFabM := ""
Local dDtEmA   := ""
Local cNumFabA := ""
Local dDtEmD   := ""
Local cNumFabD := ""
Local dDtEmI   := ""
Local cNumFabI := ""

AADD(aReg60,{"T60_TIPO"	    ,"C",002,0})
AADD(aReg60,{"T60_SUBTP"    ,"C",001,0})
AADD(aReg60,{"T60_EMISS"	,"D",008,0})
AADD(aReg60,{"T60_NUMFAB"   ,"C",020,0})
AADD(aReg60,{"T60_OUTROS"   ,"C",095,0})
cArq60 :=	CriaTrab(aReg60)
dbUseArea(.T.,__LocalDriver,cArq60,"T60")
DbSelectArea("M60")
DbGoTop()

While !Eof()
	  dDtEmM   := M60->M60_EMISS  
	  cNumFabM := M60->M60_NUMFAB	  
	  RecLock("T60",.T.)
	        T60->T60_TIPO    := "60"
	        T60->T60_SUBTP   := "M"
			T60->T60_EMISS   := dDtEmM
			T60->T60_NUMFAB  := AFISFILL(M60->M60_NUMFAB,20)
			T60->T60_OUTROS  := AFISFILL(M60->M60_PDV,03)+"2D"+AFISFILL(StrZero(Val(M60->M60_NUMINI),6),6)+AFISFILL(StrZero(Val(M60->M60_NUMFIM),6),06)+AFISFill(StrZero(Val(M60->M60_REDUCZ),6),6)+STRZERO(M60->M60_CRO,3)+StrTran(STRZERO(M60->M60_VENDA,17,2),".","")+StrTran(STRZERO(M60->M60_GERAL,17,2),".","")+SPACE(37) 
	  MsUnlock() 
	  DbSelectArea("A60")
      A60->(MsSeek(DTOS(dDtEmM)+cNumFabM))      
      dDtEmA   := A60->A60_EMISS  
	  cNumFabA := A60->A60_NUMFAB
      While dDtEmM==A60->A60_EMISS .AND. cNumFabM==A60->A60_NUMFAB
            RecLock("T60",.T.)
	           T60->T60_TIPO    := "60"
	           T60->T60_SUBTP   := "A"
      		   T60->T60_EMISS   := A60->A60_EMISS
        	   T60->T60_NUMFAB  := AFISFILL(A60->A60_NUMFAB,20)
      		   T60->T60_OUTROS  := AFISFILL(A60->A60_SITTRI,04)+StrTran(STRZERO(A60->A60_VALOR,13,2),".","")+SPACE(79)
            MsUnlock()         
            DbSelectArea("A60")
            A60->(DbSkip())
	  EndDo      
	  If mv_par12 == 1
         DbSelectArea("D60")
	     DbSetOrder(2)
         D60->(MsSeek(DTOS(dDtEmA)+cNumFabA))
         dDtEmD   := D60->D60_EMISS  
   	     cNumFabD := D60->D60_NUMFAB	
         While dDtEmA==D60->D60_EMISS .AND. cNumFabA==D60->D60_NUMFAB	 .AND. dDtEmM==dDtEmA .AND. cNumFabM==cNumFabA
               RecLock("T60",.T.)
      	          T60->T60_TIPO    := "60"
   	              T60->T60_SUBTP   := "D"
         		  T60->T60_EMISS   := D60->D60_EMISS
        	      T60->T60_NUMFAB  := AFISFILL(D60->D60_NUMFAB,20)
      		      T60->T60_OUTROS  := AFISFILL(D60->D60_CODPRO,14)+StrTran(STRZERO(D60->D60_QUANT,14,3),".","")+StrTran(STRZERO(D60->D60_VALOR,17,2),".","")+StrTran(STRZERO(D60->D60_BSICM,17,2),".","")+AFISFILL(D60->D60_SITTRI,04)+StrTran(STRZERO(D60->D60_VLICM,14,2),".","")+SPACE(19)
               MsUnlock() 
               DbSelectArea("D60")            
               D60->(DbSkip())
         EndDo              
         DbSelectArea("I60")
	     DbSetOrder(2)
         I60->(MsSeek(DTOS(dDtEmD)+cNumFabD))
         dDtEmI   := I60->I60_EMISS  
   	     cNumFabI := I60->I60_NUMFAB	
         While dDtEmI==I60->I60_EMISS .AND. cNumFabI==I60->I60_NUMFAB .AND. dDtEmA==dDtEmD .AND. cNumFabA==cNumFabD .AND. dDtEmM==dDtEmA .AND. cNumFabM==cNumFabA
               RecLock("T60",.T.)
      	          T60->T60_TIPO    := "60"
   	              T60->T60_SUBTP   := "I"
         		  T60->T60_EMISS   := I60->I60_EMISS
        	      T60->T60_NUMFAB  := AFISFILL(I60->I60_NUMFAB,20)	
      		      T60->T60_OUTROS  := AFISFILL(I60->I60_MODELO,02)+AFISFILL(StrZero(Val(I60->I60_COO),06),06)+AFISFILL(I60->I60_ITEM,03)+AFISFILL(I60->I60_CODPRO,14)+StrTran(STRZERO(I60->I60_QUANT,14,3),".","")+StrTran(STRZERO(I60->I60_VLUNI,14,2),".","")+StrTran(STRZERO(I60->I60_BSICM,13,2),".","")+AFISFILL(I60->I60_SITTRI,04)+StrTran(STRZERO(I60->I60_VLICM,13,2),".","")+SPACE(16)
               MsUnlock() 
               DbSelectArea("I60")            
               I60->(DbSkip())
         EndDo
      EndIf   
      DbSelectArea("M60")	  	    
      M60->(DbSkip())
EndDo  

Return()













/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M940RExp      ºAutor  ³Mary C. Hergert     º Data ³ 27/10/2004  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Processa o relacionamento entre o Registro de Exportacao e a    º±±
±±º          ³Nota Fiscal com fim especifico.                                 º±±
±±º          ³-> Quantos registros de exportacao para cada nota fiscal:       º±±
±±º          ³   - 1:1 Um Registro de Exportacao para uma Nota Fiscal         º±±
±±º          ³   - 1:N Um Registro de Exportacao para mais de uma Nota Fiscal º±±
±±º          ³   - N:1 Mais de um Registro de Exportacao para uma Nota Fiscal º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Mata940                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function M940RExp()

	Local aStruREG 	:= {}
	Local cArqREG	:= ""
	Local aStruNF 	:= {}
	Local cArqNF	:= ""  
	Local nContReg	:= 0
	Local nContNF	:= 0
	Local aTemps	:= {}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tabelas Temporarias para controle dos registros                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStruREG,{"REG_REGEXP"	,"C",012,0})
	AADD(aStruREG,{"REG_NF"		,"C",006,0})
	//
	cArqREG := CriaTrab(aStruREG)
	dbUseArea(.T.,__LocalDriver,cArqREG,"REG")
	IndRegua("REG",cArqREG,"REG_REGEXP")
	
	AADD(aStruNF,{"NF_REGEXP"	,"C",012,0})
	AADD(aStruNF,{"NF_NF"		,"C",006,0})
	//
	cArqNF := CriaTrab(aStruNF)
	dbUseArea(.T.,__LocalDriver,cArqNF,"NF")
	IndRegua("NF",cArqNF,"NF_NF")

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Carrega informacoes na tabela de conferencia³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    REG->(dbSetOrder(1))
	NF->(dbSetOrder(1))
    R86->(dbSetOrder(1))
	R86->(dbGoTop()) 
	Do While ! R86->(Eof())
		If ! REG->(dbSeek(R86->A86_REGEXP)) .Or. REG->REG_NF <> R86->A86_NF
			RecLock("REG",.T.)
	    	REG->REG_REGEXP	:= R86->A86_REGEXP
	    	REG->REG_NF		:= R86->A86_NF
	    	MsUnLock()
		Endif         
		If ! NF->(dbSeek(R86->A86_NF)) .Or. NF->NF_REGEXP <> R86->A86_NF
			RecLock("NF",.T.)
	    	NF->NF_REGEXP	:= NF->NF_REGEXP
	    	NF->NF_NF		:= NF->NF_NF
	    	MsUnLock()
		Endif
		R86->(dbSkip())
	Enddo	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica o numero de notas fiscais por registro de exportacao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	REG->(dbSetOrder(1))
	R86->(dbGoTop()) 
	Do While ! R86->(Eof())
        
		// Controle por registro de exportacao
		nContReg := 0
		REG->(dbSeek(R86->A86_REGEXP))
		Do While ! REG->(Eof()) .And. R86->A86_REGEXP == REG->REG_REGEXP
			nContReg += 1
			If nContReg > 1
				Exit
			Endif 
			REG->(dbSkip())
		Enddo          
		
		// Controle por nota fiscal
		nContNF := 0
		NF->(dbSeek(R86->A86_NF))
		Do While ! NF->(Eof()) .And. R86->A86_NF == NF->NF_NF
			nContNF += 1
			If nContNF > 1
				Exit
			Endif         
			NF->(dbSkip())
		Enddo          
        
        // Mais de uma nota para o mesmo registro de exportacao
        If nContNF > 1
        	nContReg := 3
        Endif
        
        // Grava o relacionamento 
        RecLock("R86",.F.)     
        Do Case
        Case nContReg == 1
			R86->A86_RELAC := 0
		Case nContReg == 2
			R86->A86_RELAC := 1
		Case nContReg == 3
			R86->A86_RELAC := 2
		EndCase
        MsUnLock()
        
		R86->(dbSkip())
	Enddo

	aTemps	:=	{{cArqREG,"REG"},{cArqNF,"NF"}}

Return(aTemps)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao ³CSTCompl     ºAutor  ³ Gustavo G. Rueda   º Data ³  17/05/05   º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.  ³Funcao utilizada para retornar o Situacao tributaria para NFs  º±±
±±º       ³ de complemento.                                               º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParam. ³dDtIni -> Data inicial, um dos casos que deve retornar 000.    º±±
±±ºParam. ³lSef -> Flag da SEF, um dos casos que deve retornar 000.       º±±
±±ºParam. ³lValidaPr -> Flag do validapr, um dos casos que deve retornar 000.º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno³cRet -> aTrbs - Array contendo alias abertos pela funcao       º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso    ³ MATA940 - Funcao: Sintegra                                    º±±
±±ÈÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CSTCompl (dDtIni, lSef, lValidaPr)
	Local	cRet	:=	""
	//
	If (lSef .or. YEAR(dDtini)<=2003 .Or. lValidaPr)
		cRet	:=	"000"
	Else
		cRet	:=	Space (03)
	EndIf
Return (cRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImporSWN  ºAutor  ³Microsiga           º Data ³  06/01/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Tratamento para os itens de importacao da tabela SWN        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImporSWN (cAliasSd1, cCNPJ, cSitTrib, cCNPJOri, cIe, cTranspEst, aRetCfp, cFuncep,;
	dDTIni, dDTFim, cProd, cNcm, nAliqICM, nBRetido, nRedBase, aArrayF3, cAliasSF3, lSef, lImpSt, lGimPB, nItem,cContrTare)
	//
	Local aProdepe	:=	{}
	Local aAreaSb1	:=	{}
	Local lAglR54	:=	GetNewPar ("MV_AGLR54", .F.)
	Local cNcmSWN   := ""
	Local cProdSWN  := ""	
	dbSelectArea("SWN")
	dbSetOrder(1)	
	SWN->(DbSeek (cSeek:=xFilial ('SWN')+(cAliasSD1)->D1_DOC+(cAliasSD1)->D1_SERIE+AllTrim ((cAliasSD1)->D1_TEC), .F.))
	While !SWN->(Eof ()) .And.;
		xFilial ("SWN")+(cAliasSD1)->D1_DOC+(cAliasSD1)->D1_SERIE+(cAliasSD1)->D1_TEC==SWN->WN_FILIAL+SWN->WN_DOC+SWN->WN_SERIE+SWN->WN_TEC+SWN->WN_EX_NCM+SWN->WN_EX_NBM
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³While de verificacao para gerar o registro 54 e 75 com o SIGAEIC.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (SWN->WN_ITEM<>(cAliasSD1)->D1_ITEMPC)
		    SWN->(DbSkip())
			Loop
		EndIf
		//
		aAreaSb1	:=	SB1->(GetArea ())
		SB1->(DbSeek (xFilial ("SB1")+SWN->WN_PRODUTO))
		A940LoadPro ("E",@cNcmSwn,@cProdSwn)
        If (lAglR54 .And. !R54->(MsSeek (cCNPJ+(cAliasSD1)->D1_SERIE+(cAliasSD1)->D1_DOC+cProdSwn+Str (aArrayF3[1][8], 5, 2)))) .Or. !(lAglR54)
			RecLock("R54",.T.)
				R54->A54_CTARE	:=	cContrTare
				R54->A54_CNPJ	:=	cCNPJ
				R54->A54_MODELO	:=	AModNot(aArrayF3[1][7])
				R54->A54_SERIE 	:=	(cAliasSD1)->D1_SERIE
				R54->A54_NFISC 	:=	(cAliasSD1)->D1_DOC
				R54->A54_CFOP	:=	(cAliasSD1)->D1_CF
				R54->A54_CST   	:=	cSitTrib
				R54->A54_NUMITE	:=	StrZero(nItem,3)
				R54->A54_PRODUT	:=	cProdSwn
				R54->A54_PRORI	:=	SWN->WN_PRODUTO
				R54->A54_CNORI  :=	cCNPJOri
				R54->A54_ALQICM	:=	aArrayF3[1][8]
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Implementacao do SEF PE                           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				R54->A54_IE	  	:= 	cIE
				R54->A54_EMISS	:= 	SF1->F1_DTDIGIT
				R54->A54_UF 	:= 	cTranspEst
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Implementacao do PRODEPE                          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lSef .And. Val(aRetCfp[19][1]) == 1		//Industria
					aProdepe 		:= Prodepe(SB1->B1_COD,cAliasSF3)
					R54->A54_APUR	:= aProdepe[1]			//Codigo da Apuracao
				Endif
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Implementacao do FUNCEP/PB³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lGimPB
					R54->A54_FUNCEP	:=	cFuncep                
					R54->A54_ICMDIF	:=	0
				Endif
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Campos da data de emissao e entrada/saida para o Sintegra - MG³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				R54->A54_DTEMI := (cAliasSD1)->D1_EMISSAO
				R54->A54_DTSAI := (cAliasSD1)->D1_DTDIGIT
		Else
			RecLock("R54",.F.)
		EndIf
				R54->A54_QUANT 	+=	SWN->WN_QUANT
				R54->A54_VALPRO	+=	SWN->WN_VALOR
				R54->A54_VALDES	+=	0
				R54->A54_VALICM	+=	SWN->WN_VALICM
				R54->A54_ICMRET	+=	0

				If Posicione("SF4",1,xFilial("SF4")+(cAliasSD1)->D1_TES,"F4_LFICM")$"IONZ" .And. Alltrim((cAliasSD1)->D1_CF)$"1556/2556/3556/197"
		   	   		R54->A54_BSICM  +=	0
				Else
		   	   		R54->A54_BSICM  +=	SWN->WN_BASEICM
		  		Endif

				R54->A54_VALIPI	+=	SWN->WN_VALIPI
		MsUnlock()
		//
		If !R75->(dbSeek (DTOS(dDTIni)+DTOS(dDTFim)+cProdSwn))
    	   RecLock("R75",.T.)         
    	   R75->A75_CTARE	:=	cContrTare
		   R75->A75_DTAINI	:=	dDTIni
		   R75->A75_DTAFIM	:=	dDTFim
           R75->A75_PROD	:=	cProdSwn                
	   	   R75->A75_PRORI	:=	SB1->B1_COD
		   IF SB1->B1_POSIPI=="        "
			   R75->A75_CODNCM	:="00000000"
		   else
     		   R75->A75_CODNCM	:=SB1->B1_POSIPI
		   endif
		   R75->A75_DESCR	:=	SB1->B1_DESC
		   R75->A75_UM    	:=	SB1->B1_UM
		   R75->A75_ALQIPI	:=	SB1->B1_IPI
		   R75->A75_ALQICM	:=	nAliqICM
		   R75->A75_BRICMS	:=	nBRetido  	//Base do Retido
		   R75->A75_SITTRI	:=	cSitTrib
		   R75->A75_REDBSE	:= 	nRedBase		//Reducao da Base do ICMS
		   MsUnlock()							 
	    Endif
	    //
		nItem++
	    RestArea (aAreaSb1)
		SWN->(DbSkip ())
	EndDo
	nItem--
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA940EXP ºAutor  ³Mary C. Hergert     º Data ³ 26/07/2005  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera os registros 85 e 86 de Exportacao                     º±±
±±º          ³Apenas para empresas com integracao SIGAEIC/SIGAEEC         º±±
±±º          ³Apenas os movimentos com averbacao no periodo devem         º±±
±±º          ³ser apresentados, independente dos Registros 50/54.         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³MATA940                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MTA940EXP(dDtIni,dDtFim,lCONV76,cEstDest,lListEst)

	Local lQuery		:= .F.
	Local lGrava		:= .T.
	
	Local cAliasEE9		:= "EE9"
	Local cPreemb 		:= ""
	Local cNF			:= ""
	Local cSerie		:= ""	
	Local cChave8586	:= ""
	Local cNcm			:= ""
	Local cProd			:= ""
	Local cSitTrib 		:= ""
	Local cSeek 		:= ""
	Local cAverba      	:= ""
		
	Local nTpConhe	:= GetNewPar("MV_TPCONHE",99)
	Local nAliqICM	:= 0
	Local nRedBase 	:= 0
	Local cNumDecl	:=	""
	Local cContrTare:=	"2"
	
	#IFDEF TOP
		Local aStruEE9	:= {}
		Local cQuery 	:= ""
		Local nX	 	:= 0
	#ELSE
		Local cIndex	:= ""
		Local cCondicao := ""
		Local nIndex 	:= 0 
	#ENDIF

	dbSelectArea("EE9")
	dbSetOrder(1)
	#IFDEF TOP
	    If TcSrvType()<>"AS/400"
		    lQuery 		:= .T.
			cAliasEE9 	:= "EE9_SINTEGRA"
			aStruEE9  	:= EE9->(dbStruct())
			cQuery := "SELECT EE9_FILIAL,EE9_PREEMB,EE9_PEDIDO,EE9_DTAVRB,EE9_NRSD,EE9_RE,EE9_DTRE,EE9_NF,EE9_SERIE"
			cQuery += "FROM "+RetSqlName("EE9")+" "
			cQuery += "WHERE EE9_FILIAL='"+xFilial("EE9")+"' AND "
			cQuery += "EE9_DTAVRB>='"+Dtos(dDtIni)+"' AND "
			cQuery += "EE9_DTAVRB<='"+Dtos(dDtFim)+"' AND "	
			cQuery += "D_E_L_E_T_ = ' ' "
			cQuery += "ORDER BY "+SqlOrder(EE9->(IndexKey()))
		
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasEE9)
		
			For nX := 1 To len(aStruEE9)
				If aStruEE9[nX][2] <> "C" .And. FieldPos(aStruEE9[nX][1])<>0
					TcSetField(cAliasEE9,aStruEE9[nX][1],aStruEE9[nX][2],aStruEE9[nX][3],aStruEE9[nX][4])
				EndIf
			Next nX
			dbSelectArea(cAliasEE9)	
		Else
		
	#ENDIF
		    cIndex    := CriaTrab(NIL,.F.)
		    cCondicao := 'EE9_FILIAL=="'+xFilial("EE9")+'".And.'
		   	cCondicao += 'DTOS(EE9_DTAVRB)>="'+DTOS(dDtIni)+'".And.DTOS(EE9_DTAVRB)<="'+DTOS(dDtFim)+'" '
		    IndRegua(cAliasEE9,cIndex,EE9->(IndexKey()),,cCondicao)
		    nIndex := RetIndex("EE9")
			#IFNDEF TOP
				dbSetIndex(cIndex+OrdBagExt())
			#ENDIF
			dbSelectArea("EE9")
		    dbSetOrder(nIndex+1)
		
		    dbSelectArea(cAliasEE9)
		    dbGoTop()
	#IFDEF TOP
		Endif    
	#ENDIF

	ProcRegua(LastRec())
	
	SD2->(dbSetOrder(3))
	EEC->(dbSetOrder(1))
	SYA->(dbSetOrder(1))     
	EE7->(dbSetOrder(1))               
	SA2->(dbSetOrder(1))
	SYQ->(dbSetOrder(1))
	SF3->(dbSetOrder(4))
	
	Do While !(cAliasEE9)->(Eof())
	
		IncProc("Selecionando Registros de Exportação") //
		
		If (cAliasEE9)->EE9_PREEMB <> cPreemb .Or. (cAliasEE9)->EE9_NF <> cNF .Or. (cAliasEE9)->EE9_SERIE <> cSerie 

			lGrava		:= .T. 
			cPreemb 	:= (cAliasEE9)->EE9_PREEMB
			cNF			:= (cAliasEE9)->EE9_NF
			cSerie		:= (cAliasEE9)->EE9_SERIE
			
			cChave8586 	:= xFilial("SD2")+(cAliasEE9)->EE9_NF+(cAliasEE9)->EE9_SERIE			
			
			If (EEC->(dbSeek(xFilial("EEC")+(cAliasEE9)->EE9_PREEMB))) .And.;
				(SYA->(dbSeek(xFilial("SYA")+EEC->EEC_PAISDT))) .And.;
				(EE7->(dbSeek(xFilial("EE7")+(cAliasEE9)->EE9_PEDIDO))) .And.;
				(SA2->(dbSeek(xFilial("SA2")+EE7->EE7_FORN+EE7->EE7_FOLOJA)))
				// O contribuinte produtor/industrial/fabricante fica armazenado no EE7
				// Portanto, CNPJ/IE/UF serao pesquisados no SA2, como referencia.
				
				If SD2->(dbSeek(cChave8586))
					
					If SF3->(dbSeek(xFilial("SF3")+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_DOC+SD2->D2_SERIE))
					
						If !Empty(cEstDest)		//UF Origem/Destino
							If lListEst			//Somente UF
								If SF3->F3_ESTADO <> cEstDest
									lGrava := .F.
								Endif
							Else
								If SF3->F3_ESTADO == cEstDest							
									lGrava := .F.
								Endif
							Endif
						Endif

						If (SA2->(FieldPos ("A2_TARE"))>0)
							cContrTare	:=	SA2->(FieldGet (FieldPos ("A2_TARE")))
						EndIf    
					
						Do While lGrava .And. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE == cChave8586 .And. !SD2->(Eof())

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Verifica se sera apresentado o codigo do produto ou o NCM - maior que 14 posicoes³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							A940LoadPro("S",@cNcm,@cProd)
							SB1->(MsSeek(F3Filial("SB1","SF3")+SD2->D2_COD))
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Apenas um registro por Declaracao de Exportacao³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							cNumDecl	:=aRetDig((cAliasEE9)->EE9_NRSD,.F.)
							cNumDecl	+=SPACE(20-Len(cNumDecl))
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³A exportacao sera direta quando o emitente for a propria empresa³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If Alltrim(SA2->A2_CGC) == Alltrim(SM0->M0_CGC)
								If dDtFim < Ctod("01/07/05")		//CONVENIO CONFAZ 15/2005
									cAverba := "S"
								Else
									cAverba := "1"
								Endif
							Else
								If dDtFim < Ctod("01/07/05")		//CONVENIO CONFAZ 15/2005
									cAverba := "N"
								Else
									cAverba := "2"
								Endif								
							Endif

							R85->(dbSetOrder(1))
							If ! R85->(dbSeek(cNumDecl+SD2->D2_DOC+SD2->D2_SERIE))
								RecLock("R85",.T.)
								R85->A85_DECL	:= cNumDecl
								R85->A85_DTDECL	:= (cAliasEE9)->EE9_DTAVRB
								R85->A85_AVERBA	:= cAverba
								R85->A85_REGEX	:= (cAliasEE9)->EE9_RE
								R85->A85_DTREGX	:= (cAliasEE9)->EE9_DTRE
								R85->A85_CONHEC	:= EEC->EEC_NRCONH
								R85->A85_DTCONH	:= EEC->EEC_DTCONH              
								R85->A85_TPCONH	:= nTpConhe
								If SYQ->(FieldPos("YQ_TDC")) > 0	
									If SYQ->(dbSeek(xFilial("SYQ")+EEC->EEC_VIA))
										R85->A85_TPCONH	:= Val(SYQ->YQ_TDC)
									Endif
								Endif
								R85->A85_PAIS	:= SYA->YA_SISEXP
								//
								R85->A85_COMPRO	:= ""	//CONVENIO CONFAZ 15/2005
								//
								R85->A85_DTCOMP	:= (cAliasEE9)->EE9_DTAVRB	//CONVENIO CONFAZ 15/2005
								//
								R85->A85_NFEXP	:= SD2->D2_DOC
								R85->A85_DTNF	:= SD2->D2_EMISSAO
								R85->A85_MODEL	:= AModNot(SF3->F3_ESPECIE)
								R85->A85_SERIE	:= SD2->D2_SERIE
								MsUnLock()
							Endif                
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Este registro sera gerado somente quando a exportacao for indireta.³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If (cAverba == "2") .Or. (cAverba == "N")
								R86->(dbSetOrder(1))
								If ! R86->(dbSeek((cAliasEE9)->EE9_RE+SD2->D2_COD+SD2->D2_DOC+SD2->D2_SERIE))
									RecLock("R86",.T.)
									R86->A86_REGEXP	:= (cAliasEE9)->EE9_RE
									R86->A86_DTREG	:= (cAliasEE9)->EE9_DTRE
									R86->A86_CNPJ	:= SA2->A2_CGC
									R86->A86_IE		:= A940IE(SA2->A2_INSCR)
									R86->A86_UF		:= SA2->A2_EST
									R86->A86_NF		:= SD2->D2_DOC
									R86->A86_DATA	:= SD2->D2_EMISSAO
									R86->A86_MODELO	:= AModNot(SF3->F3_ESPECIE)
									R86->A86_SERIE	:= SD2->D2_SERIE
									R86->A86_PROD	:= cProd
									R86->A86_QUANT	:= SD2->D2_QUANT
									R86->A86_UNIT	:= SD2->D2_PRCVEN
									R86->A86_VALPR	:= SD2->D2_TOTAL
									R86->A86_PRORI	:= SD2->D2_COD
									MsUnLock()
								Endif
	
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Grava o Registro 75 de acordo com cada item do registro 86³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								nAliqICM	:= SuperGETMV("MV_ICMPAD")
															
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Verifica o TES utilizado no documento³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								SF4->(MsSeek(F3Filial("SF4","SF3")+SD2->D2_TES))
	
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Situacao Tributaria ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If Empty(SD2->D2_CLASFIS)
								    If SF4->(Fieldpos("F4_SITTRIB"))>0
									    cSitTrib 	:= 	aFISFill(Num2Chr(Val(Substr(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB),3,0),3)
									Else
									    If len(alltrim(SB1->B1_ORIGEM)) ==2
										    cSitTrib	:= SB1->B1_ORIGEM+"0"
									    Else	
									        cSitTrib	:=	aFISFill(Num2Chr(Val(Substr(SB1->B1_ORIGEM,1,1)+Substr(SB1->B1_CLASFIS,1,1)+"0"),3,0),3)
									    EndIf
									EndIf	
								Else
									cSitTrib := Alltrim(SD2->D2_CLASFIS)
									cSitTrib += IIf(Len(cSitTrib)==1,"00",IIf(Len(cSitTrib)==2,"0",""))							    
							    EndIf
	
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Redução na base de cálculo³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								nRedBase := 0
						    	If SF4->F4_BASEICM >=100
									nRedBase :=0
								ElseIf SF4->F4_BASEICM > 0
								    nRedBase :=	(100-SF4->F4_BASEICM)
								Else
								    nRedBase :=	SF4->F4_BASEICM
							    Endif
	
								cSeek := (dtos(dDtIni)+dtos(dDtFim)+PADR(cProd,14)+PADR(cNcm,8)+SB1->B1_UM+space(4))
	
								If !(R75->(dbSeek(cSeek)))
									RecLock("R75",.T.)
									R75->A75_CTARE	:=	cContrTare
									R75->A75_DTAINI	:= dDTIni
									R75->A75_DTAFIM	:= dDTFim
									R75->A75_PROD  	:= cProd
									R75->A75_PRORI	:= SB1->B1_COD
						 			IF cNcm=="        "
					   					R75->A75_CODNCM	:="00000000"
									else
     				   					R75->A75_CODNCM	:=cNcm
									endif
									R75->A75_DESCR	:= SB1->B1_DESC
									R75->A75_UM    	:= SB1->B1_UM
									R75->A75_ALQIPI	:= SB1->B1_IPI
									R75->A75_ALQICM	:= nAliqICM
									R75->A75_BRICMS	:= SD2->D2_BRICMS
									R75->A75_SITTRI	:= cSitTrib
									R75->A75_REDBSE	:= nRedBase		
									MsUnlock()
								Endif
							Endif
							SD2->(dbSkip())
						Enddo 
					Endif
				Endif
			Endif    
		Endif           
		(cAliasEE9)->(dbSkip())
	Enddo
	If lQuery
		dbSelectArea(cAliasEE9)
		dbCloseArea()
	Else
	  	dbSelectArea("EE9")
		RetIndex("EE9")
		Set Filter to
		Ferase(cIndex+OrdBagExt())
	EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³GrvReg75  ³ Autor ³ Sergio S. Fuzinaka    ³ Data ³ 23.05.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Grava o Registro Tipo 75, para NF de Complemento (Cod. 997) ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GrvReg75(aArrayF3,cAliasSF3,dDtIni,dDtFim)

Local aArea 	:= GetArea()
Local aAreaSD1	:= SD1->(GetArea())
Local aAreaSD2	:= SD2->(GetArea())
Local aAreaSB1	:= SB1->(GetArea())
Local aAreaSF4	:= SF4->(GetArea())
Local cSeek		:= ""
Local cProd		:= ""
Local cNcm		:= ""
Local cSitTrib	:= ""
Local cDescr	:= ""
Local cUN    	:= ""
Local nAliqIPI	:= 0
Local nAliqICM	:= GetNewPar("MV_ICMPAD",0)
Local nRedBase	:= 0
Local nBRetido	:= 0

dbSelectArea("SB1")
dbSetOrder(1)

dbSelectArea("SD1")
dbSetOrder(1)

dbSelectArea("SD2")
dbSetOrder(3)

dbSelectArea("SF4")
dbSetOrder(1)

If Left(aArrayF3[1][5],1) < "5"	

	If SD1->(dbSeek(F3Filial("SD1",cAliasSF3)+aArrayF3[1][1]+aArrayF3[1][2]+aArrayF3[1][3]+aArrayF3[1][4]))
		SB1->(dbSeek(F3Filial("SB1",cAliasSF3)+SD1->D1_COD))
		A940LoadPro("E",@cNcm,@cProd,SD1->D1_TEC,.T.)	
    Endif

	If Empty(SD1->D1_TEC)
		If Len(Alltrim(SB1->B1_COD)) > 14
	       cSeek := (dtos(dDtIni)+dtos(dDtFim)+PADR(cProd,14)+PADR(cNcm,8)+SB1->B1_UM+space(4))
	    Else						
	       cSeek := (dtos(dDtIni)+dtos(dDtFim)+Substr(SB1->B1_COD,1,14)+PADR(cNcm,8)+SB1->B1_UM+space(4))
		EndIf						
	Else
		cSeek := (dtos(dDtIni)+dtos(dDtFim)+PADR(cProd,14)+Substr(cNcm,1,8)+(cAliasSD1)->D1_UM+space(4))
	Endif
    
	If !Empty(SD1->D1_TEC)
		cDescr	:=	SD1->D1_COD
		cUn	   	:=	SD1->D1_UM
		nAliqIPI:=	SD1->D1_IPI
	Else
		cDescr	:=	SB1->B1_DESC
		cUn    	:=	SB1->B1_UM
		nAliqIPI:=	SB1->B1_IPI
	EndIf
	
	If SD1->D1_ICMSRET > 0
		nBRetido := SD1->D1_BRICMS / SD1->D1_QUANT
	Else
		nBRetido := 0
	Endif

	If SF4->(dbSeek(F3Filial("SF4",cAliasSF3)+SD1->D1_TES))
		If SF4->F4_BASEICM >= 100
			nRedBase := 0
		ElseIf SF4->F4_BASEICM > 0
		    nRedBase :=	(100-SF4->F4_BASEICM)
		Else
		    nRedBase :=	SF4->F4_BASEICM
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Situacao Tributaria ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Empty(SD1->D1_CLASFIS)
		  	If SF4->(Fieldpos("F4_SITTRIB"))>0
			    cSitTrib := aFISFill(Num2Chr(Val(Substr(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB),3,0),3)
	   		Else
		        If Len(alltrim(SB1->B1_ORIGEM)) == 2
					cSitTrib := SB1->B1_ORIGEM+"0"
				Else	
				    cSitTrib := aFISFill(Num2Chr(Val(Substr(SB1->B1_ORIGEM,1,1)+Substr(SB1->B1_CLASFIS,1,1)+"0"),3,0),3)
		        EndIf
			EndIf	
		Else
			cSitTrib := Alltrim(SD1->D1_CLASFIS)
			cSitTrib += IIf(Len(cSitTrib)==1,"00",IIf(Len(cSitTrib)==2,"0",""))
		EndIf

	Endif

Else

	If SD2->(dbSeek(F3Filial("SD2",cAliasSF3)+aArrayF3[1][1]+aArrayF3[1][2]+aArrayF3[1][3]+aArrayF3[1][4]))
		SB1->(dbSeek(F3Filial("SB1",cAliasSF3)+SD2->D2_COD))
		A940LoadPro("S",@cNcm,@cProd,,.T.)
    Endif

    cSeek	:= (Dtos(dDtIni)+dtos(dDtFim)+PADR(cProd,14)+PADR(cNcm,8)+SB1->B1_UM+Space(4))
	cDescr	:= SB1->B1_DESC		
		
	If SF4->(dbSeek(F3Filial("SF4",cAliasSF3)+SD2->D2_TES))
		If SF4->F4_BASEICM >= 100
			nRedBase := 0
		ElseIf SF4->F4_BASEICM > 0
		    nRedBase :=	(100-SF4->F4_BASEICM)
		Else
		    nRedBase :=	SF4->F4_BASEICM
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Situacao Tributaria ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Empty(SD2->D2_CLASFIS)
		    If SF4->(Fieldpos("F4_SITTRIB"))>0
			    cSitTrib := aFISFill(Num2Chr(Val(Substr(SB1->B1_ORIGEM,1,1)+SF4->F4_SITTRIB),3,0),3)
			Else
			    If Len(alltrim(SB1->B1_ORIGEM)) == 2
				    cSitTrib := SB1->B1_ORIGEM+"0"
			    Else	
			        cSitTrib := aFISFill(Num2Chr(Val(Substr(SB1->B1_ORIGEM,1,1)+Substr(SB1->B1_CLASFIS,1,1)+"0"),3,0),3)
			    EndIf
			EndIf	
		Else
			cSitTrib := Alltrim(SD2->D2_CLASFIS)
			cSitTrib += IIf(Len(cSitTrib)==1,"00",IIf(Len(cSitTrib)==2,"0",""))							    
	    EndIf
	Endif
	
Endif

If R75->(!dbSeek(cSeek))
	RecLock("R75",.T.)
	R75->A75_DTAINI	:= dDTIni
	R75->A75_DTAFIM	:= dDTFim
	R75->A75_PROD	:= cProd
   	R75->A75_PRORI	:= SB1->B1_COD
    IF cNcm=="        "
	   R75->A75_CODNCM	:="00000000"
	else
       R75->A75_CODNCM	:=cNcm
	endif
	R75->A75_DESCR	:= cDescr
	R75->A75_UM    	:= cUn
	R75->A75_ALQIPI	:= nAliqIPI
	R75->A75_ALQICM	:= nAliqICM
	R75->A75_BRICMS	:= nBRetido
	R75->A75_SITTRI	:= cSitTrib
	R75->A75_REDBSE	:= nRedBase
	MsUnlock()							 
Endif

RestArea(aAreaSF4)
RestArea(aAreaSB1)
RestArea(aAreaSD2)
RestArea(aAreaSD1)
RestArea(aArea)

Return Nil	

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao ³R54NFServ    ºAutor  ³ Luciana P. Munhoz  º Data ³  18/07/2006 º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.  ³Funcao utilizada para gerar o registro 54, caso     			  º±±
±±º       ³seja item de Serviço e lCONV76 == .T.		                  º±±
±±ÌÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±                                                                                                                     ;
±±ºUso    ³ MATA940 - Funcao: Sintegra (CONV76)                           º±±
±±ÈÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R54NFServ (	aArrayF3,cNumNF,cSerie,cCliFor,cLoja,cContrTare,cCNPJ,lCONV76,;
					   		dDtIni,lSef,lValidaPr,cCNPJOri,lTareDf,cIE,cTranspEst,lGimPB,cFuncep,;
							aProdepe,cAliasSF3)
Local aArea		:= GetArea()
Local cRet		:=	""                                                                          
Local cR54CFOP	:= GetNewPar("MV_R54CFOP","") 
Local nX		:= 0                                                                
Local nPos		:= 0
Local cChave	:= cNumNF+cSerie+cCliFor+cLoja 
 
nPos := Ascan(aArrayF3,{|x| x[1]+x[2]+x[3]+x[4]==cChave})

For nX := nPos To Len(aArrayF3)
	
	If (aArrayF3[nX][1]+aArrayF3[nX][2]+aArrayF3[nX][3]+aArrayF3[nX][4]) <> cChave
		Exit
	Endif
	
	If Alltrim(aArrayF3[nX][5]) $ cR54CFOP
		RecLock("R54",.T.)
		R54->A54_CTARE		:=	cContrTare
		R54->A54_CNPJ		:=	cCNPJ
		R54->A54_MODELO 	:=	AModNot(aArrayF3[1][7])	
		R54->A54_SERIE  	:= 	aArrayF3[1][2]
		R54->A54_NFISC  	:= 	aArrayF3[1][1]
		R54->A54_CFOP 		:= 	aArrayF3[nX][5]	 	//CFOP de Serviço   
		R54->A54_CST     	:= 	CSTCompl (dDtIni, lSef, lValidaPr)
		R54->A54_NUMITE		:= 	"998" //998-Servicoes Nao Tributados
		R54->A54_QUANT  	:= 	0
		R54->A54_CNORI  	:= 	cCNPJOri
		R54->A54_VALDES 	:= 	aArrayF3[nX][17] 
    	R54->A54_ALQICM 	:= 0    
    	
		//Alteracao efetuada apos consulta na Secretaria RS
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REGISTRO ERRO                                                                        ³
		//³                                                                                     ³
		//³PARA OS CODIGOS ESPECIAIS QUANTIDADE (CAMPO 10) E VALOR DO PRODUTO (CAMPO 11)        ³
		//³ DEVEM ESTAR ZERADOS E A INFORMACAO DEVE SER PREENCHIDA NO VALOR DESCONTAO / DESPESA ³
	  	//³ ACESSORIOS (CAMPO 12 ).  REJEICAO                                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If GETMV("MV_ESTADO")=="RS"
 			R54->A54_QUANT 	:= 0
			R54->A54_VALPRO := 0                                                                                                                                                            
		Else
			R54->A54_VALPRO := aArrayF3[nX][17] 
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Implementacao do SEF PE                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		R54->A54_IE	  		:= 	cIE
		R54->A54_EMISS		:= 	SF2->F2_EMISSAO
		R54->A54_UF 		:= 	cTranspEst

		MsUnlock()     
	EndIf
Next nX

RestArea(aArea)

Return (cRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³GrvReg61  ³ Autor ³ Andressa Fagundes    	³ Data ³ 09/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Considera a aliquota do produto com interna.                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GrvAliq(aArrayF3,nI)

Local lAliqInt := GetNewPar("MV_ALINT",.F.) // Considera aliquota do produto como interna(B1_PICM)

If lAliqInt

	SD1->(DbSetOrder(1))
	
 	If SD1->(MsSeek(F3Filial("SD1")+aArrayF3[nI][1]+aArrayF3[nI][2]+aArrayF3[nI][3]+aArrayF3[nI][4]))
		SB1->(MsSeek(F3Filial("SB1")+SD1->D1_COD))
        If !Empty(SB1->B1_PICM)
	        R50->A50_ALQINT :=	SB1->B1_PICM
        Endif
    Endif
Else
	R50->A50_ALQINT := GetNewPar ("MV_ICMPAD",0)
Endif
									
Return Nil    


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ReadNorma ³ Autor ³Eduardo Riera          ³ Data ³17.07.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de Leitura dos arquivos de Instrucao Normativa       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Array com o Lay-Out da Instr.Normativa                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Arquivo                                              ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER Function ReadHcma(cNorma, lImprime, cMdb, cMaskVlr, lXml)

Local aNorma 	:= {}
Local cLinha 	:= ""
Local aArq      := {{}}
Local aAlias 	:= {{}}//{NIL,NIL,NIL}
Local aPre	 	:= {{}}
Local aPos	 	:= {{}}
Local aPreReg	:= {{}}
Local aPosReg	:= {{}}
Local aStru  	:= {{}}
Local aConteudo	:= {{}}
Local aContReg	:= {{}}
Local aIni      := {{}}
Local cAux		:= ""
Local aArea		:= GetArea()
Local nNivel   	:= 1
Local aImprime 	:= {.F.,,,,.F.}
Local aDelimit  := {{}}
Local aConsolidado	:=	{{"cFilAnt", "cFilAnt", "", ""}}
Local aChv		:=	{}
Local aOrd		:=	{""}
Local cLay      := ""

Default cMaskVlr	:=	""
Default cMdb 		:= 	{}
Default lImprime	:=	.F.
Default lXml		:=	.F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estrutura do Arquivo a Ser Lido                                         ³
//³                                                                        ³
//³[XXX] Onde XXX eh o Alias Principal - Identifica um Registro de Arquivo³
//³(ARQ) Definicao do Nome do Arquivo TXT referente ao Bloco []            ³
//³(PRE) Pre-Processamento do Registro de Arquivo                          ³
//³(PREREG) Pre-Processamento para cada registro do Alias Principal        ³
//³WWWWWWWWWW X YYY Z CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC ³
//³|          | |   | |                                                    ³
//³|          | |   | -> Conteudo                                          ³
//³|          | |   | -> Numero de Decimais                                ³
//³|          | | -----> Tamanho da Coluna                                 ³
//³|          | -------> Formato de Gravacao ( Numerico Caracter Data      ³
//³| ------------------> Nome da Coluna                                    ³
//³(POSREG) Pos-Processamento para cada registro do Alias Principal        ³
//³(POS) Pos-Processamento do Registro de Arquivo                          ³
//³(INI:<Nome>) Normativa a ser processada apos este registro.             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Efetua a Abertura do Arquivo NormaXXX.Ini                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (File(cNorma))
	FT_FUse(cNorma)
	FT_FGotop()

	While ( !FT_FEof() )
		cLinha := FT_FREADLN()

		Do Case
		Case "["==SubStr(cLinha,1,1)
			If ( !Empty(aAlias[nNivel]) )
				aadd(aNorma,{ aAlias,aPre,aPreReg,aPos,aPosReg,aStru,aConteudo,aArq,aContReg,aINI, aImprime, aDelimit, aConsolidado, aChv, aOrd,cLay})
				aPre 		:= {{}}
				aPreReg 	:= {{}}
				aPos		:= {{}}
				aPosReg		:= {{}}
				aStru		:= {{}}
				aConteudo	:= {{}}
				aContReg	:= {{}}
				aINI    	:= {{}}					
				aAlias		:= {{}} //{NIL,NIL,NIL}
				nNivel   	:= 1
				aArq        := {{}}
				aDelimit 	:= {{}}
				aConsolidado:=	{{"cFilAnt", "cFilAnt", "", ""}}
				aChv		:=	{{}}
			EndIf
			aAlias[nNivel] := SubStr(cLinha,2,3)
			If nNivel <= 1
				cLay       := AllTrim(SubStr(cLinha,6,Len(cLinha)-6))
				If Len(cLay)>47
					cLay   := SubStr(cLay,1,47)+"..."
				EndIf
			EndIf
			aImprime 	:= {.F.,,,,.F.}
			aOrd		:=	{""}
		Case "{"==SubStr(cLinha,1,1)
			nNivel++
			aadd(aAlias,SubStr(cLinha,2,3))
			aadd(aPre,{})
			aadd(aPreReg,{})
			aadd(aPos,{})
			aadd(aPosReg,{})
			aadd(aStru,{})
			aadd(aConteudo,{})
			aadd(aContReg,{})
			aadd(aINI,{})
			aadd(aArq,{})
			aadd(aDelimit,{})
			aAdd(aConsolidado, {"cFilAnt", "cFilAnt", "", ""})
			aadd(aChv,{})
			aadd(aOrd,"")

			//Identifica em que ordem deve ser impresso um determinado registro no INI. Esta clausula deve ser utilizada para os blocos
			//	que nao possuem Alias, ou seja, deve ser XXX e que o bloco esteja no INI principal (nao podendo estar dentro de um outro
			//	INI chamado pelo principal. Ex: SISIF). Um exemplo de utilizacao eh para totalizador, onde os valores calculados durante o
			//	o processamento do INI deverao compor o registro HEADER, na primeira linha do meio-magnetico.
			//	- Sua clausula pode indicar TOP para o primeiro registro do meio-magnetico ou BOT (Bottom) para o ultimo registro do meio-magnetico.
			//	- Se nao for informado, sera considerado na posicao em que aparecer no INI.
			//
			//INI Utilizado: GIARS.INI
		Case "(ORD"==SubStr (cLinha,1,4)
			aOrd[nNivel]	:=	AllTrim (SubStr (cLinha, 6))

			//Esta chave eh utilizada para otimizar o while quando nao for possivel implementar um FSQUERY por exemplo, esta chave faz
			//	parte do while para a tabela passada como Alias no bloco do registro.
		Case "(CHV"==SubStr (cLinha,1,4)
			aChv[nNivel]	:=	AllTrim (SubStr (cLinha, 6))

		Case "//"==SubStr (cLinha,1,2)
			//Nao faz nada, pois eh comentario.                                        	

			//Esta clausula define uma mascara padrao para todos os campos valores gerados pela IN no meio-magnetico.
			//	Ex. MANAD.INI: @MASKVLR="@E 9999999.99"
		Case "@MASKVLR="==SubStr (cLinha,1,9)
			cMaskVlr	:=	&(AllTrim (SubStr (cLinha, 10)))

		Case "(CONSOLIDADO)"==SubStr (cLinha,1,13)
			aConsolidado[nNivel]	:=	&(AllTrim (SubStr (cLinha, 14)))

		Case "(ARQ"==SubStr(cLinha,1,4) .And.(")"==SubStr(cLinha,5,1).or.")"==SubStr(cLinha,6,1)).And. !Empty(aAlias[nNivel])
			cAux := AllTrim(SubStr(cLinha,7))
			If ("&"$cAux)
				cAux	:=	&(AllTrim(SubStr (cAux, At ("&", cAux)+1)))
			EndIf
			//
			If ( !Empty(cAux) )
				aadd(aArq[nNivel],cAux)
			EndIf
		Case "(PRE"==SubStr(cLinha,1,4) .And.(")"==SubStr(cLinha,5,1).or.")"==SubStr(cLinha,6,1)).And. !Empty(aAlias[nNivel])
			cAux := AllTrim(SubStr(cLinha,7))
			If ( !Empty(cAux) )
				aadd(aPre[nNivel],cAux)
			EndIf
		Case "(IMP"==SubStr(cLinha,1,4)
			aImprime	:=	&(AllTrim (AllTrim (SubStr (cLinha, 6))))

		Case "(LEG"==SubStr(cLinha,1,4)

		Case "(CMP"==SubStr(cLinha,1,4)

		Case "(DEL"==SubStr(cLinha,1,4)
			If ("&"$AllTrim (AllTrim (SubStr (cLinha, 6))))
				aDelimit[nNivel]	:=	&(SubStr (AllTrim (SubStr (cLinha, 6)),2))
			Else
				aDelimit[nNivel]	:=	AllTrim (AllTrim (SubStr (cLinha, 6)))
			EndIf

		Case "(PREREG"==SubStr(cLinha,1,7) .And. !Empty(aAlias[nNivel])
			cAux := AllTrim(SubStr(cLinha,10))
			If ( !Empty(cAux) )
				aadd(aPreReg[nNivel],cAux)
			EndIf

		Case "(POS"==SubStr(cLinha,1,4) .And.(")"==SubStr(cLinha,5,1).or.")"==SubStr(cLinha,6,1)) .And. !Empty(aAlias[nNivel])
			cAux := AllTrim(SubStr(cLinha,7))
			If ( !Empty(cAux) )
				aadd(aPos[nNivel],cAux)
			EndIf

		Case "(POSREG"==SubStr(cLinha,1,7) .And. !Empty(aAlias[nNivel])
			cAux := AllTrim(SubStr(cLinha,10))
			If ( !Empty(cAux) )
				aadd(aPosReg[nNivel],cAux)
			EndIf

		Case "(CONT"==SubStr(cLinha,1,5) .And. !Empty(aAlias[nNivel])
			cAux := AllTrim(SubStr(cLinha,7))
			If ( !Empty(cAux) )
				aadd(aContReg[nNivel],cAux)
			EndIf	

		Case "(INI:"==SubStr(cLinha,1,5)
			cAux := AllTrim(SubStr(cLinha,6))
			If ( !Empty(cAux) )
				aadd(aIni[nNivel],Left(cAux,Len(cAux)-1))
			EndIf	
		Case "@MDB="==SubStr(cLinha,1,5)
			cMdb	:=	AllTrim (SubStr (cLinha,6))
		Case "@XML"==SubStr(cLinha,1,4)
			lXml	:=	.T.
		OtherWise
			If !lImprime .And. aImprime[1]
				lImprime	:=	.T.
			EndIf
			If ( !Empty(aAlias[nNivel]) ) .And. !Empty(SubStr(cLinha,01,10))
				aadd(aStru[nNivel], {	SubStr(cLinha,01,10) ,; 		//Campo
					SubStr(cLinha,12,01) ,; 		//Tipo
					Val(SubStr(cLinha,14,03)) ,; 	//Tamanho
					Val(SubStr(cLinha,18,01)) })	//Decimal

				aadd(aConteudo[nNivel], SubStr(cLinha,20) )

			EndIf

		EndCase
		FT_FSkip()
	EndDo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Adiciona o ultimo registro                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( !Empty(aAlias[nNivel]) )
		aadd(aNorma,{ aAlias,aPre,aPreReg,aPos,aPosReg,aStru,aConteudo,aArq,aContReg,aINI, aImprime, aDelimit, aConsolidado, aChv, aOrd , cLay})
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Fecha o Arquivo NormaXXX.INI                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FT_FUse()
Else
	Help(" ",1,"NORMAERRO1")
EndIf

RestArea(aArea)

Return(aNorma)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ProcNorma ³ Autor ³Eduardo Riera          ³ Data ³17.07.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de Processamento de Instr.Normativa                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Arquivo da Normativa                                 ³±±
±±³          ³ExpC2: Arquivo de Destino                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PrHcma(cNorma,cDest,cDir,aProcFil)

Local aArea 	 := GetArea()
Local lImprime	 :=	.F.
Local cMdb		 :=	""
Local cMaskVlr   :=	""
Local lXml       := .F.
Local aNorma     :=	U_ReadHcma(cNorma, @lImprime, @cMdb, @cMaskVlr, @lXml)
Local cTrab	     := CriaTrab(,.F.)+".TXT"
Local nHandle    := 0
Local nX     	 := 0
Local lApaga   	 := .T.
Local aArqSpool  := {}
Local cBuffer    := ""
Local aBufferFim := {}
Local nIndBuf    := 0
Local nExcluidos := 0

DEFAULT cDir := ""
Default aProcFil	:= {.F.,cFilAnt}
nHandle 	:= FCreate(cTrab,0)

If ( FError() == 0 )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Declara Variaveis que podem ser utilizadas nas Normativas.              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Private _aTotal[100]
	Private lAbtMT950	:=	.F.
	Private cDirNorma	:= cDir

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Calcula o Numero de Registros da Normativa a Processar                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcRegua(Len(aNorma)+1)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Processa a Normativa                                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aEval(aNorma,{|x| IncProc(x[16]),aadd(aBufferFim,U_RegHcma(x,@nHandle,@cTrab,cDir,cMaskVlr,lXml,aProcFil))})

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Encerra o arquivo binario                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FClose(nHandle)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Efetua a gravacao no Cliente                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 to len(aNorma)
		If len(aNorma[nX][8][1]) > 0
			If !Empty(aNorma[nX][8][1][1])
				If (aNorma[nX][11][1])	//Se for para gerar registro no spool
					aAdd (aArqSpool, aNorma[nX][8][1][1])
				EndIf
				lApaga := .F.
			EndIf
		EndIf	
	Next nX	

	For nX := 1 To Len(aBufferFim)
		If Empty(aBufferFim[nX]) .Or. !"T"$SubStr (aBufferFim[nX], 1, 1) .Or. !"B"$SubStr (aBufferFim[nX], 1, 1)
			aDel(aBufferFim,nX)
			nExcluidos++
		EndIf
	Next nX
	aSize(aBufferFim,Len(aBufferFim)-nExcluidos)
	If !Empty (aBufferFim)
		FErase (cDir+cDest)
		nHdle := FCreate (cDir+cDest, 0)
		For nIndBuf := 1 To Len(aBufferFim)
			If ("T"$SubStr (aBufferFim[nIndBuf], 1, 1))
				FWrite(nHdle, SubStr (aBufferFim[nIndBuf], 2)+Chr(13)+Chr(10))
			EndIf
		Next nIndBuf

		FT_FUse (cTrab)
		FT_FGoTop ()

		Do While !FT_FEoF ()
			cBuffer := FT_FReadLn ()
			FWrite(nHdle, cBuffer+Chr(13)+Chr(10))
			//
			FT_FSkip ()
		EndDo

		For nIndBuf := 1 To Len(aBufferFim)
			If ("B"$SubStr (aBufferFim[nIndBuf], 1, 1))
				FWrite(nHdle, SubStr (aBufferFim[nIndBuf], 2)+Chr(13)+Chr(10))
			EndIf
		Next nIndBuf

		FT_FUse ()
		FClose (nHdle)
	Else	
		If lApaga
			Ferase(cDir+cDest)
			__CopyFIle(cTrab,cDir+cDest)
			Ferase(cTrab)
		Else
			If !lAbtMT950
					If cPaisLoc <> "MEX"
						Aviso("Instrucoes Normativas",; //"Instrucoes Normativas"
							"Esta instrucao normativa possui arquivos de destino especificos e portanto o parametro de destino nao foi respeitado!",; //"Esta instrucao normativa possui arquivos de destino especificos e portanto o parametro de destino nao foi respeitado!"
							{"OK"})
					Endif
			Endif
		EndIf	
	EndIf
	Ferase(cTrab)
Else
	Help(" ",1,"NORMAERRO2")
EndIf

If (lImprime) .And. !(lAbtMt950)
	ImpSpool (cNorma, cDest, cDir, aArqSpool)
EndIf
//
If !Empty (cMdb)
	If (File (cDir+cMdb))
		FErase (cDir+cMdb)
	EndIf
	WaitRun ("TxtToMdb "+cDir+cDest+" "+cDir+cMdb+" -ver=4", SW_HIDE)
EndIf
//
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³RegNorma  ³ Autor ³Eduardo Riera          ³ Data ³17.07.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Processa um registro de Instrucao Normativa                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpA1: Registro da Norma                                    ³±±
±±³          ³ExpN1: Handle do Arquivo a Ser Gravado                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RegHcma(aReg,nHandle,cTrab,cDir, cMaskVlr, lXml,aProcFil)

Local aArea		:= GetArea()
Local aArea1	:= {}
Local aArea2	:= {}
Local aArea3	:= {}
Local aAlias	:= aReg[1]
Local aPre	 	:= aReg[2]
Local aPreReg	:= aReg[3]
Local aPos		:= aReg[4]
Local aPosReg   := aReg[5]
Local aStru		:= aReg[6]
Local aConteudo := aReg[7]
Local aArq		:= aReg[8]
Local aContReg	:= aReg[9]
Local aINI      := aReg[10]
Local aDelimit	:= aReg[12]
Local aConsolidado := aReg[13]
Local aChv		:= aReg[14]
Local aOrd		:= aReg[15]
Local cFilDe		:=	""
Local cFilAte		:=	""
Local cChaveCons	:=	""
Local cCmpGrvCon	:=	""
Local aArqNew		:=	{}
Local uConteudo
Local cBuffer		:= ""
Local nCntFor		:= 0
Local bError
Local lContinua 	:= Len(aStru) > 0
Local nNivel    	:= 0
Local cDelimit  	:= ""
Local aAreaSm0	 	:=	SM0->(GetArea ())
Local cBufferFim 	:= ""
Local aChvNivel		:= {.F., .F., .F.}
Local aSkipChv		:=	{.F., .F., .F.}

Default lXml 		:= .F.                                               
Default aProcFil	:= {.F.,cFilAnt}
//
//lAbtMt950 - Aborta a rotina
If (lAbtMT950)
	RestArea(aAreaSm0)
	Return (cBufferFim)
EndIf

If aAlias[1] <> "XXX"
	dbSelectArea(aAlias[1])
EndIf

aArea1 := GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona o cFilAnt sempre na filial que esta sendo processada³
//³atraves da selecao do aFisCalc.                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aProcFil[1]
	cFilAnt := aProcFil[2]
Endif
cFilDe		:=	&(aConsolidado[1][1])	//Filial de passado pelo INI
cFilAte		:=	&(aConsolidado[1][2])	//Filial ate passado pelo INI
cChaveCons	:=	aConsolidado[1][3]
cCmpGrvCon	:=	aConsolidado[1][4]
If Empty (cFilDe) .And. Empty (cFilAte)
	cFilDe		:=	cFilAnt
	cFilAte		:=	cFilAnt
EndIf
If (cFilDe#cFilAte)
	TrbConso (1, 1, aStru, cChaveCons, @aArqNew)
EndIf

DbSelectArea("SM0")
SM0->(DbSeek (cEmpAnt+cFilDe, .T.))

Do While !SM0->(Eof ()) .And. SM0->M0_CODIGO+SM0->M0_CODFIL<=cEmpAnt+cFilAte
	cFilAnt	:=	SM0->M0_CODFIL

	If aAlias[1] <> "XXX"
		dbSelectArea(aAlias[1])
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Efetua o Pre-Processamento                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aEval(aPre[1],{|x| &(x) })

	If aAlias[1] <> "XXX"

		dbSelectArea(aAlias[1])

		aChvNivel[1] := ( Len(aChv)>=1 .And. !Empty(aChv[1]) )
		
		While ( !Eof() ) .And. lContinua .And. Iif (aChvNivel[1], &(aChv[1]), .T.)

			cBuffer := ""
			aSkipChv	:=	{.T., .F., .F.}	//Controle para execucao do skip de cada nivel, este controle eh utilizado para quando a IN estah usando a clausula CHV.

			If (sfVldPReg (@aPreReg[1], @nHandle))
				cDelimit	:=	AllTrim (aDelimit[1])
				cBuffer		+=	""
				//
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Ha casos em que o delimitador eh so considerado no meio, ou so no inicio e fim, ou so no meio e fim, portanto foi criado a seguinte regra:                             ³
				//³A clausula (DEL) no INI devera ser criada na seguinte estrutura:                                                                                                       ³
				//³Ex: (DEL)|IMF, onde | eh o delimitador, I eh para gerar no incio de cada linha, M eh para gerar entre os campos de cada linha e F eh para gerar no final de cada linha.³
				//³Algumas formas de se utilizar:                                                                                                                                         ³
				//³(DEL)|MF                                                                                                                                                               ³
				//³(DEL)|M                                                                                                                                                                ³
				//³(DEL)|IMF                                                                                                                                                              ³
				//³(DEL)|IF                                                                                                                                                               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If (cFilDe#cFilAte)	//Somente para o Nivel 1, inicialmente resolver o caso do MANAD
					ConsoFil (aArqNew, cChaveCons, 1, aStru, aConteudo, cCmpGrvCon)
					DbSelectArea (aAlias[1])
					(aAlias[1])->(DbSkip ())
					Loop
				EndIf

				If (Len (cDelimit)>1)
					If ("I"$SubStr (cDelimit, 2))
						cBuffer	+=	SubStr (cDelimit, 1, 1)
					EndIf
				EndIf

				For nCntFor := 1 To Len(aStru[1])

					bError := ErrorBlock({|e| Help(" ",1,"NORMAERRO3",,aAlias[1]+"->"+aStru[1][nCntFor][1]+"|"+aConteudo[1][nCntFor],3,1) })
					BEGIN SEQUENCE

				       uConteudo := &(aConteudo[1][nCntFor])


						Do Case
						Case ( aStru[1][nCntFor][2] == "N" )

							If ( uConteudo == Nil )
								uConteudo := 0
							EndIf

							If Empty (cMaskVlr) .Or. (aStru[1][nCntFor][4])==0
								uConteudo := NoRound(uConteudo*(10**(aStru[1][nCntFor][4])),aStru[1][nCntFor][4])
								//
								If (!Empty (aDelimit[1]))
									cBuffer += Iif (Empty (AllTrim (Str (uConteudo,aStru[1][nCntFor][3]))), "", AllTrim (Str (uConteudo,aStru[1][nCntFor][3])))
								Else
									cBuffer += StrZero(uConteudo,aStru[1][nCntFor][3])									
								EndIf
							Else
								cBuffer += AllTrim (Transform (uConteudo, cMaskVlr))
							EndIf

						Case ( aStru[1][nCntFor][2] == "D" )

							If ( uConteudo == Nil )
								uConteudo := dDataBase
							EndIf
							cBuffer += PadR(Dtos(uConteudo),aStru[1][nCntFor][3])

						Case ( aStru[1][nCntFor][2] == "C" )

							If ( uConteudo == Nil )
								uConteudo := ""
							EndIf

							If (!Empty (aDelimit[1]))
								cBuffer += AllTrim(uConteudo)
							Else   
								If !lXML .And. aStru[1][nCntFor][3]<>0
									cBuffer += PadR(uConteudo,aStru[1][nCntFor][3])
								Else                                                
									cBuffer += uConteudo
								EndIf
							EndIf

						EndCase

					END SEQUENCE
					ErrorBlock(bError)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Ha casos em que o delimitador eh so considerado no meio, ou so no inicio e fim, ou so no meio e fim, portanto foi criado a seguinte regra:                             ³
					//³A clausula (DEL) no INI devera ser criada na seguinte estrutura:                                                                                                       ³
					//³Ex: (DEL)|IMF, onde | eh o delimitador, I eh para gerar no incio de cada linha, M eh para gerar entre os campos de cada linha e F eh para gerar no final de cada linha.³
					//³Algumas formas de se utilizar:                                                                                                                                         ³
					//³(DEL)|MF                                                                                                                                                               ³
					//³(DEL)|M                                                                                                                                                                ³
					//³(DEL)|IMF                                                                                                                                                              ³
					//³(DEL)|IF                                                                                                                                                               ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If (Len (cDelimit)>1)
						If (nCntFor==Len(aStru[1]))
							If ("F"$SubStr (cDelimit, 2))
								cBuffer	+=	SubStr (cDelimit, 1, 1)
							EndIf
						Else
							If ("M"$SubStr (cDelimit, 2))
								cBuffer	+=	SubStr (cDelimit, 1, 1)
							EndIf
						EndIf
					EndIf

				Next nCntFor

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Efetua a Gravacao da Linha                                              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !Empty(cBuffer)
					FWrite(nHAndle,cBuffer+Chr(13)+Chr(10))
					If ( Ferror()!=0 )
						Help(" ",1,"NORMAERRO4")
					EndIf
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Incrementa o contador  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aEval(aContReg[1],{|x| &(x) })     	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³FIM DO PRIMEIRO NIVEL                    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Len(aAlias)>=2
					If aAlias[2]<>"XXX"
						dbSelectArea(aAlias[2])
					EndIf
					aArea2 := GetArea()

					aEval(aPre[2],{|x| &(x) })

					If aAlias[2]<>"XXX"

						aChvNivel[2] := Len (aChv)>=2 .And. !Empty (aChv[2])
						While ( !Eof() )  .And. Iif (aChvNivel[2], &(aChv[2]), .T.)
							cBuffer := ""
							aSkipChv	:=	{.T., .T., .F.}	//Controle para execucao do skip de cada nivel, este controle eh utilizado para quando a IN estah usando a clausula CHV.
							If (sfVldPReg (@aPreReg[2], @nHandle))

								cDelimit	:=	AllTrim (aDelimit[2])
								If (Len (cDelimit)>1)
									If ("I"$SubStr (cDelimit, 2))
										cBuffer	+=	SubStr (cDelimit, 1, 1)
									EndIf
								EndIf

								For nCntFor := 1 To Len(aStru[2])
									bError := ErrorBlock({|e| Help(" ",1,"NORMAERRO3",,aAlias[2]+"->"+aStru[2][nCntFor][1]+"|"+aConteudo[2][nCntFor],3,1) })
									BEGIN SEQUENCE
										uConteudo := &(aConteudo[2][nCntFor])
										Do Case
										Case ( aStru[2][nCntFor][2] == "N" )
											If ( uConteudo == Nil )
												uConteudo := 0
											EndIf

											If Empty (cMaskVlr) .Or. (aStru[2][nCntFor][4])==0
												uConteudo := NoRound(uConteudo*(10**(aStru[2][nCntFor][4])),aStru[2][nCntFor][4])
												If (!Empty (aDelimit[2]))
													cBuffer += Iif (Empty (AllTrim (Str (uConteudo,aStru[2][nCntFor][3]))), "", AllTrim (Str (uConteudo,aStru[2][nCntFor][3])))
												Else
													cBuffer += StrZero(uConteudo,aStru[2][nCntFor][3])
												EndIf
											Else
												cBuffer += AllTrim (Transform (uConteudo, cMaskVlr))
											EndIf

										Case ( aStru[2][nCntFor][2] == "D" )
											If ( uConteudo == Nil )
												uConteudo := dDataBase
											EndIf
											cBuffer += PadR(Dtos(uConteudo),aStru[2][nCntFor][3])
										Case ( aStru[2][nCntFor][2] == "C" )
											If ( uConteudo == Nil )
												uConteudo := ""
											EndIf
											If (!Empty (aDelimit[2]))
												cBuffer += AllTrim(uConteudo)
											Else   
												If !lXML .And. aStru[2][nCntFor][3]<>0
													cBuffer += PadR(uConteudo,aStru[2][nCntFor][3])
												Else                                                
													cBuffer += uConteudo
												Endif
											EndIf

										EndCase
									END SEQUENCE
									ErrorBlock(bError)

									If (Len (cDelimit)>1)
										If (nCntFor==Len(aStru[2]))
											If ("F"$SubStr (cDelimit, 2))
												cBuffer	+=	SubStr (cDelimit, 1, 1)
											EndIf
										Else
											If ("M"$SubStr (cDelimit, 2))
												cBuffer	+=	SubStr (cDelimit, 1, 1)
											EndIf
										EndIf
									EndIf

								Next nCntFor
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Efetua a Gravacao da Linha  nivel 2                                     ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If !Empty(cBuffer)
									FWrite(nHAndle,cBuffer+Chr(13)+Chr(10))
									If ( Ferror()!=0 )
										Help(" ",1,"NORMAERRO4")
									EndIf
								EndIf
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Incrementa o contador  ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								aEval(aContReg[2],{|x| &(x) })
							EndIf	
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Inicio do nivel 3                    ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If Len(aAlias)==3
								dbSelectArea(aAlias[3])
								aArea3 := GetArea()
								aEval(aPre[3],{|x| &(x) })

								aChvNivel[3] := Len (aChv)>=3 .And. !Empty (aChv[3])
								While ( !Eof() ) .And. Iif (aChvNivel[3], &(aChv[3]), .T.)

									cBuffer := ""
									aSkipChv	:=	{.T., .T., .T.}	//Controle para execucao do skip de cada nivel, este controle eh utilizado para quando a IN estah usando a clausula CHV.

									If (sfVldPReg (@aPreReg[3], @nHandle))

										cDelimit	:=	AllTrim (aDelimit[3])
										If (Len (cDelimit)>1)
											If ("I"$SubStr (cDelimit, 2))
												cBuffer	+=	SubStr (cDelimit, 1, 1)
											EndIf
										EndIf

										For nCntFor := 1 To Len(aStru[3])
											bError := ErrorBlock({|e| Help(" ",1,"NORMAERRO3",,aAlias[3]+"->"+aStru[3][nCntFor][1]+"|"+aConteudo[3][nCntFor],3,1) })
											BEGIN SEQUENCE
												uConteudo := &(aConteudo[3][nCntFor])
												Do Case
												Case ( aStru[3][nCntFor][2] == "N" )
													If ( uConteudo == Nil )
														uConteudo := 0
													EndIf

													If Empty (cMaskVlr) .Or. (aStru[3][nCntFor][4])==0
														uConteudo := NoRound(uConteudo*(10**(aStru[3][nCntFor][4])),aStru[3][nCntFor][4])
														If (!Empty (aDelimit[3]))
															cBuffer += Iif (Empty (AllTrim (Str (uConteudo,aStru[3][nCntFor][3]))), "", AllTrim (Str (uConteudo,aStru[3][nCntFor][3])))
														Else
															cBuffer += StrZero(uConteudo,aStru[3][nCntFor][3])
														EndIf
													Else
														cBuffer += AllTrim (Transform (uConteudo, cMaskVlr))
													EndIf

												Case ( aStru[3][nCntFor][2] == "D" )
													If ( uConteudo == Nil )
														uConteudo := dDataBase
													EndIf
													cBuffer += PadR(Dtos(uConteudo),aStru[3][nCntFor][3])
												Case ( aStru[3][nCntFor][2] == "C" )
													If ( uConteudo == Nil )
														uConteudo := ""
													EndIf
													If (!Empty (aDelimit[3]))
														cBuffer += AllTrim(uConteudo)
													Else   
														If !lXML .And. aStru[3][nCntFor][3]<>0
															cBuffer += PadR(uConteudo,aStru[3][nCntFor][3])
														Else                                                
															cBuffer += uConteudo
														Endif
													EndIf
													
												EndCase
											END SEQUENCE
											ErrorBlock(bError)

											If (Len (cDelimit)>1)
												If (nCntFor==Len(aStru[3]))
													If ("F"$SubStr (cDelimit, 2))
														cBuffer	+=	SubStr (cDelimit, 1, 1)
													EndIf
												Else
													If ("M"$SubStr (cDelimit, 2))
														cBuffer	+=	SubStr (cDelimit, 1, 1)
													EndIf
												EndIf
											EndIf

										Next nCntFor
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³Efetua a Gravacao da Linha  nivel 3                                     ³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										If !Empty(cBuffer)
											FWrite(nHAndle,cBuffer+Chr(13)+Chr(10))
											If ( Ferror()!=0 )
												Help(" ",1,"NORMAERRO4")
											EndIf
										EndIf
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³Incrementa o contador  ³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										aEval(aContReg[3],{|x| &(x) })
									EndIf	
									aEval(aPosReg[3],{|x| &(x) })
									dbSelectArea(aAlias[3])
									dbSkip()
								EndDo
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Efetua o Pos-Processamento do nivel 3         ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								aEval(aPos[3],{|x| &(x) })
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Efetua o INI-Processamento do nivel 3         ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								aEval(aINI[3],{|x| ProcIni(x,nHAndle,@cTrab,cDir,cMaskVlr,lXml,aProcFil) })
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³Esta condicao se deve quando estiver utilizando a clausula (CHV), pois nao devo       ³
								//³   retornar a Area salva antes do while, pois quando estiver utilizando esta clausula ³
								//³   e sair do while jah estarah posicionado no proximo registro que deverah ser pro-   ³
								//³   cessado novamente desde o nivel anterior, ou seja, neste caso, nivel 2.            ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If !aChvNivel[3]
									RestArea(aArea3)
								EndIf
							EndIf
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Fim do nivel 3         ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If Len(aArq)>2
								If Len(aArq[3]) >= 1 .And. !Empty(aArq[3][1])
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³Fecha e efetua a gravacao por bloco ³		
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									FClose(nHAndle)		
									// Caso seja necessario utilizar alguma informacao lancada em tempo de execucao no nome do arquivo, sera necessario gravar em um _aTotal
									If ("_ATOTAL["$Upper(aArq[3][1]))
										aArq[3][1]	:=	&(aArq[3][1])
									EndIf
									Ferase(cDir+aArq[3][1])
									__CopyFIle(cTrab,cDir+aArq[3][1])
									Ferase(cTrab)
									cTrab	:= CriaTrab(,.F.)+".TXT"
									nHAndle  := FCreate(cTrab,0)
								EndIf						   	
							EndIf
							aEval(aPosReg[2],{|x| &(x) })
							dbSelectArea(aAlias[2])
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Tratamento para quando estiver utilizando a clausula (CHV) (condicao para o while).        ³
							//³OBS: Nao precisarei dar SKIP novamente quando sair do terceiro NIVEL que tenha             ³
							//³         o controle pela clausula (CHV), pois jah estara no proximo registro e nao deverah ³
							//³         dar o SKIP novamente e sim voltar e processar o registro atual desde o nivel ante-³
							//³         rior, ou seja, neste caso o nivel 2                                               ³
							//³OBS 2: A condicao abaixo determina NAO serah dado SKIP quando possuir a clausula CHV no    ³
							//³         bloco em execucao, quando o alias do nivel 2 for igual ao alias do nivel 3 e quan-³
							//³         estiver executado o while do nivel 3, onde jah foi executado o SKIP e a tabela jah³
							//³         jah saiu do while com SKIP.                                                       ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If !(aChvNivel[3] .And. Len (aAlias)>=3 .And. aAlias[2]==aAlias[3] .And. aSkipChv[3])
								dbSkip()
							EndIf
						EndDo
					Else
						cBuffer := ""
						If (sfVldPReg(@aPreReg[2], @nHandle))

							cDelimit	:=	AllTrim (aDelimit[2])
							If (Len (cDelimit)>1)
								If ("I"$SubStr (cDelimit, 2))
									cBuffer	+=	SubStr (cDelimit, 1, 1)
								EndIf
							EndIf				
							For nCntFor := 1 To Len(aStru[2])
								bError := ErrorBlock({|e| Help(" ",1,"NORMAERRO3",,aAlias[2]+"->"+aStru[2][nCntFor][2]+"|"+aConteudo[2][nCntFor],3,1) })
								BEGIN SEQUENCE			
									uConteudo := &(aConteudo[2][nCntFor])			
									Do Case
									Case ( aStru[2][nCntFor][2] == "N" )					
										If ( uConteudo == Nil )
											uConteudo := 0
										EndIf

										If Empty (cMaskVlr) .Or. (aStru[2][nCntFor][4])==0
											uConteudo := NoRound(uConteudo*(10**(aStru[2][nCntFor][4])),aStru[2][nCntFor][4])
											If (!Empty (aDelimit[2]))
												cBuffer += Iif (Empty (AllTrim (Str (uConteudo,aStru[2][nCntFor][3]))), "", AllTrim (Str (uConteudo,aStru[2][nCntFor][3])))
											Else
												cBuffer += StrZero(uConteudo,aStru[2][nCntFor][3])
											EndIf
										Else
											cBuffer += AllTrim (Transform (uConteudo, cMaskVlr))
										EndIf

									Case ( aStru[2][nCntFor][2] == "D" )
										If ( uConteudo == Nil )
											uConteudo := dDataBase
										EndIf
										cBuffer += PadR(Dtos(uConteudo),aStru[2][nCntFor][3])
									Case ( aStru[2][nCntFor][2] == "C" )
										If ( uConteudo == Nil )
											uConteudo := ""
										EndIf
										If (!Empty (aDelimit[2])) .Or. Empty(uConteudo)
											cBuffer += AllTrim (uConteudo)
										Else
											cBuffer += PadR(uConteudo,aStru[2][nCntFor][3])
										EndIf
									EndCase
								END SEQUENCE
								ErrorBlock(bError)

								If (Len(cDelimit)>1)
									If (nCntFor==Len(aStru[2]))
										If ("F"$SubStr (cDelimit, 2))
											cBuffer	+=	SubStr (cDelimit, 1, 1)
										EndIf
									Else
										If ("M"$SubStr (cDelimit, 2))
											cBuffer	+=	SubStr (cDelimit, 1, 1)
										EndIf
									EndIf
								EndIf

							Next nCntFor
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Efetua a Gravacao da Linha                                              ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If !Empty(cBuffer)
								If ("TOP"$aOrd[2])
									cBufferFim += "T"+cBuffer
								ElseIf ("BOT"$aOrd[2])
									cBufferFim += "B"+cBuffer
								Else
									FWrite(nHAndle,cBuffer+Chr(13)+Chr(10))
									If ( Ferror()!=0 )
										Help(" ",1,"NORMAERRO4")
									EndIf
								EndIf
							EndIf
							aEval(aPosReg[2],{|x| &(x) })
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Incrementa o contador  ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							aEval(aContReg[2],{|x| &(x) })     			
						EndIf					
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Efetua o Pos-Processamento do nivel 2         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aEval(aPos[2],{|x| &(x) })
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Efetua o INI-Processamento do nivel 2         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aEval(aINI[2],{|x| ProcIni(x,nHAndle,@cTrab,cDir,cMaskVlr,lXml,aProcFil) })
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Esta condicao se deve quando estiver utilizando a clausula (CHV), pois nao devo       ³
					//³   retornar a Area salva antes do while, pois quando estiver utilizando esta clausula ³
					//³   e sair do while jah estarah posicionado no proximo registro que deverah ser pro-   ³
					//³   cessado novamente desde o nivel anterior, ou seja, neste caso, nivel 1.            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !(aChvNivel[2])
						RestArea(aArea2)
					EndIf
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Fim do nivel 2         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Len(aArq)>=2
					If Len(aArq[2]) >= 1 .And. !Empty(aArq[2][1])
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Fecha e efetua a gravacao por bloco ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						FClose(nHAndle)
						If ("_ATOTAL["$Upper(aArq[2][1]))
							aArq[2][1]	:=	&(aArq[2][1])
						EndIf		
						Ferase(cDir+aArq[2][1])
						__CopyFIle(cTrab,cDir+aArq[2][1])
						Ferase(cTrab)
						cTrab	:= CriaTrab(,.F.)+".TXT"
						nHAndle  := FCreate(cTrab,0)
					EndIf				   	
				EndIf
				aEval(aPosReg[1],{|x| &(x) })	
			EndIf

			dbSelectArea(aAlias[1])
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Tratamento para quando estiver utilizando a clausula (CHV) (condicao para o while).        ³
			//³OBS: Nao precisarei dar SKIP novamente quando sair do terceiro/segundo NIVEL que tenha     ³
			//³         o controle pela clausula (CHV), pois jah estarah no proximo registro e nao deverah³
			//³         dar o SKIP novamente e sim voltar e processar o registro atual desde o nivel ante-³
			//³         rior, ou seja, neste caso o nivel 1                                               ³
			//³OBS 2: A condicao abaixo determina NAO serah dado SKIP quando possuir a clausula CHV no    ³
			//³         bloco em execucao, quando o alias do nivel 1 for igual ao alias do nivel 2 e quan-³
			//³         estiver executado o while do nivel 2, onde jah foi executado o SKIP e a tabela jah³
			//³         jah saiu do while com SKIP.                                                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !(aChvNivel[2] .And. Len (aAlias)>=2 .And. aAlias[1]==aAlias[2] .And. aSkipChv[2])
				dbSkip()
			EndIf
		EndDo
	Else
		cBuffer := ""
		If (sfVldPReg(@aPreReg[1], @nHandle))

			cDelimit	:=	AllTrim (aDelimit[1])
			If (Len (cDelimit)>1)
				If ("I"$SubStr (cDelimit, 2))
					cBuffer	+=	SubStr (cDelimit, 1, 1)
				EndIf
			EndIf

			For nCntFor := 1 To Len(aStru[1])
				bError := ErrorBlock({|e| Help(" ",1,"NORMAERRO3",,aAlias[1]+"->"+aStru[1][nCntFor][1]+"|"+aConteudo[1][nCntFor],3,1) })
				BEGIN SEQUENCE			
					uConteudo := &(aConteudo[1][nCntFor])			
					Do Case
					Case ( aStru[1][nCntFor][2] == "N" )					
						If ( uConteudo == Nil )
							uConteudo := 0
						EndIf

						If Empty (cMaskVlr) .Or. (aStru[1][nCntFor][4])==0
							uConteudo := NoRound(uConteudo*(10**(aStru[1][nCntFor][4])),aStru[1][nCntFor][4])
							If (!Empty (aDelimit[1]))
								cBuffer += Iif (Empty (AllTrim (Str (uConteudo,aStru[1][nCntFor][3]))), "", AllTrim (Str (uConteudo,aStru[1][nCntFor][3])))
							Else
								cBuffer += StrZero(uConteudo,aStru[1][nCntFor][3])
							EndIf
						Else
							cBuffer += AllTrim (Transform (uConteudo, cMaskVlr))
						EndIf

					Case ( aStru[1][nCntFor][2] == "D" )
						If ( uConteudo == Nil )
							uConteudo := dDataBase
						EndIf
						cBuffer += PadR(Dtos(uConteudo),aStru[1][nCntFor][3])
					Case ( aStru[1][nCntFor][2] == "C" )
						If ( uConteudo == Nil )
							uConteudo := ""
						EndIf
						
						If (!Empty (aDelimit[1]))
							cBuffer += AllTrim (uConteudo)
						Else
							If !lXML .And. aStru[1][nCntFor][3]<>0
								cBuffer += PadR(uConteudo,aStru[1][nCntFor][3])
							Else                                                
								cBuffer += uConteudo
							Endif
						EndIf
					EndCase
				END SEQUENCE
				ErrorBlock(bError)

				If (Len(cDelimit)>1)
					If (nCntFor==Len(aStru[1]))
						If ("F"$SubStr (cDelimit, 2))
							cBuffer	+=	SubStr (cDelimit, 1, 1)
						EndIf
					Else
						If ("M"$SubStr (cDelimit, 2))
							cBuffer	+=	SubStr (cDelimit, 1, 1)
						EndIf
					EndIf
				EndIf

			Next nCntFor
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Efetua a Gravacao da Linha                                              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(cBuffer)
				If ("TOP"$aOrd[1])
					cBufferFim += "T"+cBuffer
				ElseIf ("BOT"$aOrd[1])
					cBufferFim += "B"+cBuffer
				Else
					FWrite(nHAndle,cBuffer+Chr(13)+Chr(10))
					If ( Ferror()!=0 )
						Help(" ",1,"NORMAERRO4")
					EndIf
				EndIf
			EndIf
			aEval(aPosReg[1],{|x| &(x) })
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Incrementa o contador  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aEval(aContReg[1],{|x| &(x) })     			
		EndIf
	EndIf
	//
	SM0->(DbSkip ())
EndDo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a integridade da rotina                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea(aAreaSm0)
cFilAnt	:=	SM0->M0_CODFIL
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Efetua o Pos-Processamento                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aEval(aPos[1],{|x| &(x) })
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Efetua o INI-Processamento do nivel 1         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aEval(aINI[1],{|x| ProcIni(x,nHAndle,@cTrab,cDir,cMaskVlr,lXml,aProcFil) })
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura demais areas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea(aArea1)
RestArea(aArea)

If (cFilDe#cFilAte)		
	GeroConso (nHAndle, aDelimit, aStru, aArqNew, aAlias, aConteudo, aPosReg, aContReg, cMaskVlr)
	TrbConso (2,,,, aArqNew)
EndIf

If Len(aArq) >= 1
	If Len(aArq[1]) >= 1  .And. !Empty(aArq[1][1])
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Fecha e efetua a gravacao por bloco ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FClose(nHAndle)
		// Caso seja necessario utilizar alguma informacao lancada em tempo de execucao no nome do arquivo, sera necessario gravar em um _aTotal
		If ("_ATOTAL["$Upper(aArq[1][1]))
			aArq[1][1]	:=	&(aArq[1][1])
		EndIf		
		Ferase(cDir+aArq[1][1])
		__CopyFile(cTrab,cDir+aArq[1][1])
		Ferase(cTrab)
		cTrab	:= CriaTrab(,.F.)+".TXT"
		nHAndle  := FCreate(cTrab,0)
	EndIf	
EndIf

Return(cBufferFim)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ProcIni   ³ Autor ³ Eduardo Jose Zanardo   ³ Data ³03/05/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processa a Clausula INI                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Static Function ProcIni(cIniName,nHAndle,cTrab,cDir,cMaskVlr,lXml,aProcFil)
Local aNorma := {}
Default aProcFil := {.F.,cFilAnt}

If ( !Empty(cIniName) )
	aNorma := ReadNorma(cIniName)
	aEval(aNorma,{|x| RegHcma(x,nHAndle,@cTrab,cDir,cMaskVlr,lXml,aProcFil) })
EndIf

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³FsPrdInv  ³ Autor ³ Eduardo Riera         ³ Data ³15/01/2003  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calculo do saldo em estoque no ultimo inventario          	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ExpC1: Codigo do produto                                    	³±±
±±³          ³ExpL2: Indica se o saldo em/de terceiro deve ser por CNPJ     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpA [.][1] Quantidade do Produto                             ³±±
±±³          ³     [.][2] Valor do Produto                                  ³±±
±±³          ³     [.][3] 1 - Nosso:2-De terceiros;3-Em terceiros           ³±±
±±³          ³     [.][4] Tipo(C/F)+Codigo de Cliente/Fornecedor            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user Function HcPrdInv(cCodPro,lCliFor,dUltFec)

Local aArea     := GetArea()
Local aSaldo    :={}
Local aRetorno  := {}
Local cQuery    :=""
Local cAliasSB9 := "SB9"
Local lQuery    := .F.
Local nX        := 0
Local nY        := 0

Default dUltFec := SuperGetMv("MV_ULMES")

dbSelectArea("SB9")
dbSetOrder(1)

#IFDEF TOP  
	If TcSrvType()<>"AS/400"
		lQuery := .T.
	Endif
#ENDIF

If lQuery
	cAliasSB9 := "FSPRDINV"

	cQuery := "SELECT B9_FILIAL,B9_COD,B9_LOCAL,B9_QINI,B9_VINI1,B9_DATA "
	cQuery += "FROM "+RetSqlName("SB9")+" SB9 "
	cQuery += "WHERE SB9.B9_FILIAL='"+xFilial("SB9")+"' AND "
	cQuery += "SB9.B9_COD='"+cCodPro+"' AND "
	cQuery += "SB9.B9_DATA='"+Dtos(dUltFec)+"' AND "
	cQuery += "SB9.D_E_L_E_T_=' ' "
	cQuery += "ORDER BY "+SqlOrder(SB9->(IndexKey()))

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB9)
	TcSetField(cAliasSB9,"B9_DATA","D",8,0)
	TcSetField(cAliasSB9,"B9_QINI","N",TamSx3("B9_QINI")[1],TamSx3("B9_QINI")[2])
	TcSetField(cAliasSB9,"B9_VINI1","N",TamSx3("B9_VINI1")[1],TamSx3("B9_VINI1")[2])

Else
	MsSeek(xFilial("SB9")+cCodPro)
Endif

While (!Eof() .And. (cAliasSB9)->B9_FILIAL == xFilial("SB9") .And.;
		(cAliasSB9)->B9_COD == cCodPro )

	If (cAliasSB9)->B9_DATA == dUltFec
		aRetorno := {(cAliasSB9)->B9_QINI,(cAliasSB9)->B9_VINI1}
		nY := aScan(aSaldo,{|x| x[3] == 1 .And. x[4]==""})
		If nY==0
			aadd(aSaldo,{aRetorno[1],aRetorno[2],1,""})
		Else
			aSaldo[nY][1] += aRetorno[1]
			aSaldo[nY][2] += aRetorno[2]
			aSaldo[nY][3] := 1
			aSaldo[nY][4] := ""
		EndIf
		aRetorno := SaldoTerc(cCodPro,(cAliasSB9)->B9_LOCAL,"T",dUltFec,(cAliasSB9)->B9_LOCAL,lCliFor) //De terceiro
		If lCliFor
			For nX := 1 To Len(aRetorno)
				nY := aScan(aSaldo,{|x| x[3] == 2 .And. x[4]==aRetorno[nX][1]})
				If nY==0
					aadd(aSaldo,{aRetorno[nX][2],aRetorno[nX][3],2,aRetorno[nX][1]})
				Else
					aSaldo[nY][1] += aRetorno[nX][2]
					aSaldo[nY][2] += aRetorno[nX][3]
					aSaldo[nY][3] := 2
					aSaldo[nY][4] := aRetorno[nX][1]
				EndIf
			Next nX
		Else
			nY := aScan(aSaldo,{|x| x[3] == 2 })
			If nY == 0
				aadd(aSaldo,{aRetorno[1],aRetorno[2],2,""})
			Else
				aSaldo[nY][1] += aRetorno[1]
				aSaldo[nY][2] += aRetorno[2]
			EndIf
		EndIf
		aRetorno := SaldoTerc(cCodPro,(cAliasSB9)->B9_LOCAL,"D",dUltFec,(cAliasSB9)->B9_LOCAL,lCliFor) //Em terceiro
		If lCliFor
			For nX := 1 To Len(aRetorno)
				nY := aScan(aSaldo,{|x| x[3] == 3 .And. x[4]==aRetorno[nX][1]})
				If nY==0
					aadd(aSaldo,{aRetorno[nX][2],aRetorno[nX][3],3,aRetorno[nX][1]})
				Else
					aSaldo[nY][1] += aRetorno[nX][2]
					aSaldo[nY][2] += aRetorno[nX][3]
					aSaldo[nY][3] := 3
					aSaldo[nY][4] := aRetorno[nX][1]
				EndIf
			Next nX
		Else
			nY := aScan(aSaldo,{|x| x[3] == 3 })
			If nY == 0
				aadd(aSaldo,{aRetorno[1],aRetorno[2],3,""})
			Else
				aSaldo[nY][1] += aRetorno[1]
				aSaldo[nY][2] += aRetorno[2]
			EndIf
		EndIf
	EndIf
	dbSelectArea(cAliasSB9)
	dbSkip()
EndDo
If lQuery
	dbSelectArea(cAliasSB9)
	dbCloseArea()
	dbSelectArea("SB9")
EndIf
If Empty(aSaldo)
	aSaldo := {{0,0,1,""},{0,0,2,""},{0,0,3,""}}
EndIf
RestArea(aArea)
Return(aSaldo)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³FsEstInv  ³ Autor ³ Eduardo Riera         ³ Data ³15/01/2003  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Calculo do saldo em estoque no ultimo inventario          	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ExpA1: [1] Alias do Arquivo                                   ³±±
±±³          ³       [2] Nome do arquivo fisico                             ³±±
±±³          ³ExpN2: [1] Para Inicializacao                                 ³±±
±±³          ³       [2] Para finalizacao                                   ³±±
±±³          ³ExpL3: Indica se o saldo em/de terceiro deve ser por CNPJ     ³±±
±±³          ³ExpL4: Indica se os produtos sem saldo devem ser registrados  ³±±
±±³          ³ExpD5: Data de fechamento do estoque a ser considerada        ³±±
±±³          ³ExpL6: Indica se a codificação deve ser feita por NCM         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Arquivo no formato:                                           ³±±
±±³          ³     CODIGO  C 15   Codigo do Produto                         ³±±
±±³          ³     UM      C 02   Unidade de Medida                         ³±±
±±³          ³     SITUACA C 01   1-Proprio;2=Em Terceiro;3=De Terceiro     ³±±
±±³          ³     QUANT   N 19 3 Quantidade                                ³±±
±±³          ³     CUSTO   N 19 3 Custo Total                               ³±±
±±³          ³     CNPJ    C 14 0 CNPJ  (Ver parametro ExpL3)               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user Function HcEstInv(aAlias,nTipo,lCliFor,lMovimen,dUltFec,lNCM,lST,lSelB5,cFiltraB5,aNFsProc,aProcCod,cFiltraB1)

Local aCampos   := {}
Local aSaldo    := {}
Local aTam		:= {}
Local cAliasSB1 := "SB1"
Local cQuery    := ""
Local cCNPJ     := ""
Local cInsc 	:= ""
Local cUf	  	:= ""
Local lQuery    := .F.
Local lCodPro   := .F.
Local nX        := 0
Local cMvEstado := GetMv("MV_ESTADO")
Local cAliasNCM := ""
Local cArqNCM   := ""
Local cNome		:= ""
Local cCodNome	:= ""
Local aUltMov	:= {}
Local cCodInv	:= GetNewPar("MV_CODINV","")
Local lA950PRD	:= Existblock("A950PRD")
Local aICMS		:= {}
Local l88STMG	:= GetNewPar("MV_88STMG",.F.)
Local c88Ind	:= ""

#IFDEF TOP
	Local aStru     := {}
#ELSE
	Local c88Chave	:= ""
	Local c88Filtro	:= ""
	Local cIndSB6   := ""
	Local cChave    := ""
#ENDIF

Local lRgEspSt	:= GetNewPar("MV_RGESPST",.F.)
Local lUsaSFT	:= SFT->(FieldPos("FT_RGESPST")) > 0

DEFAULT lCliFor 	:= .F.
DEFAULT lMovimen	:= .T.
DEFAULT dUltFec 	:= SuperGetMV("MV_ULMES")
DEFAULT lNCM    	:= .F.
DEFAULT lST			:= .F.
DEFAULT lSelB5		:= .F.
DEFAULT cFiltraB5	:= ""
DEFAULT cFiltraB1	:= ""
DEFAULT	aNFsProc	:= {}
DEFAULT	aProcCod	:= {}

If !Empty(cFiltraB5) 
	lSelB5 := .T.
Endif                                                                           

If nTipo==1

	If l88STMG
		#IFNDEF TOP
			dbSelectArea("SD1")
			c88Ind		:=	CriaTrab(NIL,.F.)
			c88Chave	:=	"D1_NFORI+D1_SERIORI+D1_ITEMORI"
			c88Filtro	:=	"D1_FILIAL == '" + xFilial("SD1") + "' .And. "
			If !lRgEspSt
				c88Filtro	+=	"D1_TIPO $ 'P/I/C' .And. D1_ICMSRET > 0 .And. Dtos(D1_DTDIGIT) < '" + Dtos(dUltFec) + "'"
			Else
				c88Filtro	+=	"D1_TIPO $ 'P/I/C' .And. Dtos(D1_DTDIGIT) < '" + Dtos(dUltFec) + "'"
			Endif
			IndRegua("SD1",c88Ind,c88Chave,,c88Filtro,Nil,.F.)
			dbClearIndex()	
			RetIndex("SD1")
			dbSetIndex(c88Ind+OrdBagExt())
			dbSetOrder(1)
		#ENDIF
	Endif

	PRIVATE nIndSb6 := 0
	#IFNDEF TOP
		dbSelectArea("SB6")
		cIndSB6 := CriaTrab(Nil,.F.)
		cChave := "B6_FILIAL+B6_PRODUTO+B6_LOCAL+B6_TIPO+DTOS(B6_DTDIGIT)"
		cQuery := 'B6_FILIAL="'+xFilial("SB6")+'" .And. DtoS(B6_DTDIGIT)<="'+Dtos(dUltFec)+'"'
		IndRegua("SB6",cIndSB6,cChave,,cQuery,Nil,.F.)
		nIndSB6:=RetIndex("SB6")
		dbSetIndex(cIndSB6+OrdBagExt())
		dbSetOrder(nIndSB6 + 1)
		dbGoTop()
	#ENDIF

	aadd(aCampos,{"CODIGO" ,"C",15,0})
	aadd(aCampos,{"CODPRD" ,"C",15,0})
	aadd(aCampos,{"NCM"    ,"C",14,0})
	aadd(aCampos,{"UM"     ,"C",02,0})
	aadd(aCampos,{"SITUACA","C",01,0})
	aadd(aCampos,{"QUANT"  ,"N",19,3})
	aadd(aCampos,{"CUSTO"  ,"N",19,3})
	aadd(aCampos,{"CNPJ"   ,"C",14,0})
	aTam:=TamSX3("A2_INSCR")
	aadd(aCampos,{"INSCR"  ,"C",aTam[1],0})
	aadd(aCampos,{"UF"     ,"C",02,0})
	aadd(aCampos,{"NOME"   ,"C",40,0})
	aadd(aCampos,{"CODNOME","C",06,0})
	aadd(aCampos,{"BASEST" ,"N",14,2})
	aadd(aCampos,{"VALST"  ,"N",14,2})
	aadd(aCampos,{"VALICMS","N",14,2})	//Valor do ICMS Operacao Propria
	aadd(aCampos,{"ICMSRET","N",14,2})	//Valor do ICMS ST
	aadd(aCampos,{"ALIQST" ,"N",05,2})
	aadd(aCampos,{"CODINV" ,"C",01,0})		//Campo utilizado pelo o SEF-PE
	aadd(aCampos,{"TIPO"   ,"C",TamSX3("B1_TIPO")[1],0}) //Campo com o tipo do produto
	aadd(aCampos,{"DESC_PRD" ,"C",50,0})	//Descricao produto
	aadd(aCampos,{"CLASSFIS" ,"C",02,0})	//Classificacao Fiscal
	aAlias[2] := CriaTrab(aCampos,.T.)
	dbUseArea(.T.,__LocalDrive,aAlias[2],aAlias[1],.F.,.F.)

	dbSelectArea("SB1")
	dbSetOrder(1)
	#IFDEF TOP
		aStru     := SB1->(dbStruct())
		cAliasSB1 := "FSESTINV"
		lQuery    := .T.

		cQuery := "SELECT B1_FILIAL, B1_TIPO, B1_COD, B1_DESC, B1_UM, B1_POSIPI, B1_PICMENT, B1_PICM, B1_CLASFIS, B1_CODBAR "
		cQuery += "FROM "+RetSqlName("SB1")+" SB1 "               
		If lSelB5
			cQuery += " , "+RetSqlName("SB5")+" SB5 "               
		Endif
		cQuery += "WHERE SB1.B1_FILIAL='"+xFilial("SB1")+"' AND "
		cQuery += "SB1.D_E_L_E_T_=' ' "
		If lSelB5
			cQuery += " AND SB5.B5_FILIAL = '"+xFilial("SB5")+"'"
			cQuery += " AND SB5.B5_COD = SB1.B1_COD "
			cQuery += " AND SB5.D_E_L_E_T_=' ' "
		Endif
		If !Empty(cFiltraB5)			
			cQuery += cFiltraB5 + ' ' 
		Endif
		cQuery += "ORDER BY "+SqlOrder(SB1->(IndexKey()))

		cQuery := ChangeQuery(cQuery)

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB1)

		For nX := 1 To Len(aStru)
			If aStru[nX][2] <> "C"
				TcSetField(cAliasSB1,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
			EndIf
		Next nX

	#ELSE
		MsSeek(xFilial("SB1"))
	#ENDIF
	While !Eof() .And. (cAliasSB1)->B1_FILIAL == xFilial("SB1")

		If !Empty(cFiltraB1) .And. !(cAliasSB1)->B1_TIPO $cFiltraB1 
			(cAliasSB1)->(dbSkip())
			Loop
		EndIf		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se devera ser considerado o SB5 na geracao do estoque³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lSelB5 .And. !lQuery
			SB5->(dbSetOrder(1))
			If !(SB5->(dbSeek(xFilial("SB5")+(cAliasSB1)->B1_COD)))
				(cAliasSB1)->(dbSkip())
				Loop
			Endif
			If !Empty(cFiltraB5)
				If !(&cFiltraB5)
					(cAliasSB1)->(dbSkip())
					Loop
				Endif
			Endif
		Endif
		If !lCodPro .And. Len(AllTrim((cAliasSB1)->B1_COD))==15 .And. !lA950PRD
			lCodPro := .T.
		EndIf

		aSaldo := hcPrdInv((cAliasSB1)->B1_COD,lCliFor,dUltFec)

		For nX := 1 To Len(aSaldo)
			If aSaldo[nX][1]<>0 .Or. aSaldo[nX][3]==1
				If !Empty(aSaldo[nX][4])
					If SubStr(aSaldo[nX][4],1,1)=="C"
						dbSelectArea("SA1")
						dbSetOrder(1)
						MsSeek(xFilial("SA1")+SubStr(aSaldo[nX][4],2))
						cCNPJ 		:= SA1->A1_CGC
						cInsc 		:= SA1->A1_INSCR
						cUf	  		:= SA1->A1_EST
						cNome		:= SubStr(SA1->A1_NOME,1,40)
						cCodNome 	:= SA1->A1_COD
					Else
						dbSelectArea("SA2")
						dbSetOrder(1)
						MsSeek(xFilial("SA2")+SubStr(aSaldo[nX][4],2))
						cCNPJ		:= SA2->A2_CGC
						cInsc 		:= SA2->A2_INSCR
						cUf	  		:= SA2->A2_EST
						cNome 		:= SubStr(SA2->A2_NOME,1,40)
						cCodNome 	:= SA1->A1_COD
					EndIf
				Else
					cCNPJ := SM0->M0_CGC
					cINSC := SM0->M0_INSC
					cUf	  := cMvEstado
				EndIf

				If lMovimen
					RecLock(aAlias[1],.T.)
					(aAlias[1])->DESC_PRD := (cAliasSB1)->B1_DESC
					(aAlias[1])->CODIGO := IIf(lA950PRD,Execblock("A950PRD",.F.,.F.,{cAliasSB1}),(cAliasSB1)->B1_COD)
					(aAlias[1])->CODPRD := (cAliasSB1)->B1_COD
					(aAlias[1])->UM     := (cAliasSB1)->B1_UM
					(aAlias[1])->SITUACA:= StrZero(aSaldo[nX][3],1)
					(aAlias[1])->QUANT  := aSaldo[nX][1]
					(aAlias[1])->CUSTO  := aSaldo[nX][2]
					(aAlias[1])->CNPJ   := cCNPJ
					(aAlias[1])->INSCR  := cINSC
					(aAlias[1])->UF   	 := cUF
					(aAlias[1])->NCM   	 := (cAliasSB1)->B1_POSIPI
					(aAlias[1])->NOME  	 := cNome
					(aAlias[1])->CODNOME := cCodNome
					(aAlias[1])->TIPO	:= (cAliasSB1)->B1_TIPO
					If At((cAliasSB1)->B1_TIPO+"=",cCodInv) > 0
						(aAlias[1])->CODINV := Substr(cCodInv,At((cAliasSB1)->B1_TIPO+"=",cCodInv)+3,1)
					Else
						(aAlias[1])->CODINV := "1"	//Mercadorias
					Endif
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifica o valor do ICMS Subst. Tributaria da ultima entrada, de acordo com o parametro³
					//³Apenas para os produtos que possuem a aliquota do ICMS ST entrada em seu cadastro.     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lST .And. ((!lRgEspSt .And. (cAliasSB1)->B1_PICMENT > 0) .Or. lRgEspSt)
						aICMS := RetTotICMS((cAliasSB1)->B1_COD,dUltFec,aSaldo[nX][1],c88Ind,@aNFsProc,lRgEspSt,lUsaSFT)
						Aadd(aProcCod,(cAliasSB1)->B1_COD)
						(aAlias[1])->VALICMS := aICMS[1]	//ICMS Proprio
						(aAlias[1])->ICMSRET := aICMS[2]	//ICMS ST
					Endif
					(aAlias[1])->CLASSFIS	:= (cAliasSB1)->B1_CLASFIS
					MsUnLock()
				Else
					If aSaldo[nX][1]>0 .And. aSaldo[nX][2]>0
						RecLock(aAlias[1],.T.)
						(aAlias[1])->DESC_PRD := (cAliasSB1)->B1_DESC
						(aAlias[1])->CODIGO := IIf(lA950PRD,Execblock("A950PRD",.F.,.F.,{cAliasSB1}),(cAliasSB1)->B1_COD)
						(aAlias[1])->CODPRD := (cAliasSB1)->B1_COD
						(aAlias[1])->UM     := (cAliasSB1)->B1_UM
						(aAlias[1])->SITUACA:= StrZero(aSaldo[nX][3],1)
						(aAlias[1])->QUANT  := aSaldo[nX][1]
						(aAlias[1])->CUSTO  := aSaldo[nX][2]
						(aAlias[1])->CNPJ   := cCNPJ
						(aAlias[1])->INSCR  := cINSC
						(aAlias[1])->UF   	 := cUF
						(aAlias[1])->NCM     := (cAliasSB1)->B1_POSIPI
						(aAlias[1])->NOME  	  := cNome
						(aAlias[1])->CODNOME := cCodNome
						(aAlias[1])->TIPO	:= (cAliasSB1)->B1_TIPO
						If At((cAliasSB1)->B1_TIPO+"=",cCodInv) > 0
							(aAlias[1])->CODINV := Substr(cCodInv,At((cAliasSB1)->B1_TIPO+"=",cCodInv)+3,1)
						Else
							(aAlias[1])->CODINV := "1"	//Mercadorias
						Endif
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Verifica o valor do ICMS Subst. Tributaria da ultima entrada, de acordo com o parametro³
						//³Apenas para os produtos que possuem a aliquota do ICMS ST entrada em seu cadastro.     ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If lST .And. ((!lRgEspSt .And. (cAliasSB1)->B1_PICMENT > 0) .Or. lRgEspSt)
							aICMS := RetTotICMS((cAliasSB1)->B1_COD,dUltFec,aSaldo[nX][1],c88Ind,@aNFsProc,lRgEspSt,lUsaSFT)
							Aadd(aProcCod,(cAliasSB1)->B1_COD)
							(aAlias[1])->VALICMS := aICMS[1]	//ICMS Proprio
							(aAlias[1])->ICMSRET := aICMS[2]	//ICMS ST							
						Endif
						(aAlias[1])->CLASSFIS	:= (cAliasSB1)->B1_CLASFIS
						MsUnLock()
					Endif
				Endif
			EndIf
		Next nX
		dbSelectArea(cAliasSB1)
		dbSkip()
	EndDo
	If lQuery
		dbSelectArea(cAliasSB1)
		dbCloseArea()
		dbSelectArea("SB1")
	EndIf
	#IFNDEF TOP
		dbSelectArea("SB6")
		RetIndex("SB6")
		Ferase(cIndSB6+OrdBagExt())
	#ENDIF
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se os produtos devem ser aglutinados por NCM                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lNCM
		cAliasNCM := GetNextAlias()
		cArqNCM   := CriaTrab(aCampos,.T.)
		dbUseArea(.T.,__LocalDrive,cArqNCM,cAliasNCM,.F.,.F.)

		If lCodPro
			IndRegua(cAliasNCM,cArqNCM,"NCM+SITUACA+CNPJ+INSCR",,,Nil,.F.)	//?Por NCM
		Else
			IndRegua(cAliasNCM,cArqNCM,"CODIGO+SITUACA+CNPJ+INSCR",,,Nil,.F.)	//Por codigo produto
		EndIf

		dbSelectArea(aAlias[1])
		dbGotop()
		While !Eof()
			dbSelectArea(cAliasNCM)
			If MsSeek(Iif (lCodPro, (aAlias[1])->NCM, (aAlias[1])->CODIGO)+(aAlias[1])->SITUACA+(aAlias[1])->CNPJ+(aAlias[1])->INSCR)
				RecLock(cAliasNCM,.F.)
			Else
				RecLock(cAliasNCM,.T.)
			EndIf
			(cAliasNCM)->DESC_PRD	:=	(aAlias[1])->DESC_PRD
			(cAliasNCM)->CODIGO 	:= Iif (lCodPro, (aAlias[1])->NCM, (aAlias[1])->CODIGO)
			(cAliasNCM)->CODPRD 	:= (aAlias[1])->CODPRD
			(cAliasNCM)->UM     	:= (aAlias[1])->UM
			(cAliasNCM)->SITUACA	:= (aAlias[1])->SITUACA
			(cAliasNCM)->QUANT  	+= (aAlias[1])->QUANT
			(cAliasNCM)->CUSTO  	+= (aAlias[1])->CUSTO
			(cAliasNCM)->CNPJ   	:= (aAlias[1])->CNPJ
			(cAliasNCM)->INSCR  	:= (aAlias[1])->INSCR
			(cAliasNCM)->UF   		:= (aAlias[1])->UF
			(cAliasNCM)->NCM   		:= (aAlias[1])->NCM
			(cAliasNCM)->NOME   	:= (aAlias[1])->NOME
			(cAliasNCM)->CODNOME	:= (aAlias[1])->CODNOME
			(cAliasNCM)->BASEST 	+= (aAlias[1])->BASEST
			(cAliasNCM)->VALST		+= (aAlias[1])->VALST
			(cAliasNCM)->ALIQST		:= (aAlias[1])->ALIQST
			(cAliasNCM)->TIPO		:= (aAlias[1])->TIPO
			(cAliasNCM)->VALICMS	+= (aAlias[1])->VALICMS	//ICMS Operacoes Proprias
			(cAliasNCM)->ICMSRET	+= (aAlias[1])->ICMSRET	//ICMS ST
			If At((aAlias[1])->TIPO+"=",cCodInv) > 0
				(cAliasNCM)->CODINV := Substr(cCodInv,At((aAlias[1])->TIPO+"=",cCodInv)+3,1)
			Else
				(cAliasNCM)->CODINV := "1"	//Mercadorias
			Endif
			(cAliasNCM)->CLASSFIS	:= (aAlias[1])->CLASSFIS
			MsUnLock()
			dbSelectArea(aAlias[1])
			dbSkip()
		EndDo
		dbSelectArea(aAlias[1])
		dbCloseArea()
		dbSelectArea(cAliasNCM)
		dbCloseArea()
		FErase(cAliasNCM+OrdBagExt())
		FErase(aAlias[2]+GetDbExtension())
		aAlias[2] := cArqNCM
		dbUseArea(.T.,__LocalDrive,aAlias[2],aAlias[1],.F.,.F.)
	EndIf
	If l88STMG
		#IFNDEF TOP
			dbSelectArea("SD1")
			RetIndex("SD1")
			FErase(c88Ind+OrdBagExt())
		#ENDIF		
	Endif
Else
	dbSelectArea(aAlias[1])
	dbCloseArea()
	FErase(aAlias[2]+GetDbExtension())
	dbSelectArea("SM0")
EndIf
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³FsQuery   ³ Autor ³ Eduardo Riera         ³ Data ³16/01/2003  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de selecao de registros atraves de comandos SQL      	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ExpA1: Array de controle                                    	³±±
±±³          ³       [1] Alias da tabela principal                          ³±±
±±³          ³       [2] Controle Interno ( ExpC )                          ³±±
±±³          ³       [3] Novo alias                                    (TOP)³±±
±±³          ³ExpN2: [1] Inicializacao                                    	³±±
±±³          ³       [2] Finalizacao                                        ³±±
±±³          ³ExpC3: Expressao SQL ( WHERE )                           (OPC)³±±
±±³          ³ExpC4: Expressao ADVPL ( Filter )                        (OPC)³±±
±±³          ³ExpC5: Expressao ADVPL ( Index  )                        (OPC)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpA [1] Quantidade do Produto                              	³±±
±±³          ³     [2] Valor do Produto                                   	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function HcQuery(aControle,nTipo,cWhere,cFilter,cKey, aIN, aJoin, cFields, cGroup, cFrom)
#IFDEF TOP
	Local aStru     := {}
	Local nX      := 0
	Local cQuery    := ""
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Selecao dos dados a serem filtrados                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
If TcSrvType()<>"AS/400"
	DEFAULT aIn := {}
	DEFAULT aJoin := {}
	DEFAULT cFields	:= " * "
	DEFAULT cGroup	:= ""
	DEFAULT cFrom 	:= ""

	If Len(aControle)==2
		aadd(aControle,aControle[1])
	EndIf

	If nTipo == 1
		cQuery := "SELECT" + cFields
		If Empty(cFrom)
			aStru  := (aControle[1])->(dbStruct())
			cQuery += "FROM "+RetSqlName(aControle[1])+" "
			If !empty( aJoin )
				cQuery += "INNER JOIN "+RetSqlName(aJoin[1])+" "
				cQuery += "ON " + ajoin[2] + " "
			EndIf
			cQuery += "WHERE "
			If !Empty(cWhere)
				cQuery += cWhere+" AND "
			EndIf
	
			If !empty( aIN )
				cQuery += " "+aIn[1]+" IN " +aIn[2] + " AND "
			EndIf
	
			cQuery += RetSqlName(aControle[1])+".D_E_L_E_T_=' ' "
		Else
			cQuery += "FROM "+cFrom
			If !Empty(cWhere)
				cQuery += " WHERE " + cWhere	
				If !empty( aIN )
					cQuery += " AND "+aIn[1]+" IN " +aIn[2]
				EndIf
			EndIf
		EndIf

		If !Empty(cGroup)
			cQuery += " GROUP BY "+cGroup+" "
		Endif

		If !Empty(cKey)
			cQuery += " ORDER BY "+SqlOrder(cKey)
		EndIf

		cQuery := ChangeQuery(cQuery)

		If Select(aControle[3])<>0
			(aControle[3])->(dbCloseArea())
		EndIf

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),aControle[3])
		If !Empty(cFrom)
			aStru  := (aControle[3])->(dbStruct())
		EndIf
		For nX := 1 To Len(aStru)
			If aStru[nX][2] <> "C"
				TcSetField(aControle[3],aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
			EndIf
		Next nX	
	Else
		dbSelectArea(aControle[3])
		dbCloseArea()
		dbSelectArea(aControle[1])
	EndIf
Else
#ENDIF
	If Len(aControle)==2
		aadd(aControle,aControle[1])
	EndIf
	If nTipo == 1
		If aControle[1] <> aControle[3]
			ChkFile(aControle[1],.F.,aControle[3])
		EndIf
		dbSelectArea(aControle[3])
		aControle[2] := CriaTrab(,.F.)
		Do Case
		Case !Empty(cKey) .And. !Empty(cFilter)
			IndRegua(aControle[3],aControle[2],cKey,,cFilter,Nil,.F.)
		Case !Empty(cKey)
			IndRegua(aControle[3],aControle[2],cKey,,,Nil,.F.)
		EndCase
	Else		
		If aControle[1] <> aControle[3]
			dbSelectArea(aControle[3])
			dbCloseArea()
			dbSelectArea(aControle[1])
		Else
			RetIndex(aControle[1])
		EndIf
		FErase(aControle[2]+OrdBagExt())
	EndIf
#IFDEF TOP
EndIf
#ENDIF
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³FsDump    ³ Autor ³ Eduardo Riera         ³ Data ³16/01/2003  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina generica de DUMP de arquivo                          	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ExpC1: Nome do arquivo de lay-out                           	³±±
±±³          ³ExpN2: [1] Para parametros                                  	³±±
±±³          ³       [2] Para impressao                                   	³±±
±±³          ³ExpC3: Nome do arquivo magnetico de destino                 	³±±
±±³          ³ExpC4: Diretorio de destino                                 	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      	³±±
±±³          ³                                                            	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function HcDump(cLayOut,nTipo,cArquivo,cDir)

Local aArea   := GetArea()
Local Titulo  := "DUMP"
Local cDesc1  := "Este relatorio imprime a listagem de acompanhamento dos meios-magnetivos"
Local cDesc2  := ""
Local cDesc3  := ""
Local wnrel   := "DUMP"  // Nome do Arquivo utilizado no Spool
Local nomeprog:= "DUMP"  // nome do programa

Private Tamanho := "G" // P/M/G
Private Limite  := 220 // 80/132/220
Private lEnd    := .F.// Controle de cancelamento do relatorio
Private m_pag   := 1  // Contador de Paginas
Private nLastKey:= 0  // Controla o cancelamento da SetPrint e SetDefault
If nTipo == 1
	aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 } //###"Administracao"
	//[1] Reservado para Formulario
	//[2] Reservado para N§ de Vias
	//[3] Destinatario
	//[4] Formato => 1-Comprimido 2-Normal
	//[5] Midia   => 1-Disco 2-Impressora
	//[6] Porta ou Arquivo 1-LPT1... 4-COM1...
	//[7] Expressao do Filtro
	//[8] Ordem a ser selecionada
	//[9]..[10]..[n] Campos a Processar (se houver)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Envia para a SetPrinter                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel:=SetPrint("",wnrel,"",@Titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,Tamanho,,.F.)
Else
	SetDefault(aReturn,"")
	RptStatus({|lEnd| FsImpDet(cLayOut,cArquivo,cDir,@lEnd,wnrel,nomeprog,Titulo)},Titulo)
EndIf
RestArea(aArea)
Return(.T.)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³FsImpDet  ³ Autor ³ Eduardo Riera         ³ Data ³16/01/2003  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina generica de DUMP de arquivo - Impressao              	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ExpL1: Controle de saida                                    	³±±
±±³          ³ExpC2: Nome do arquivo magnetico de destino                 	³±±
±±³          ³ExpC3: Diretorio de destino                                 	³±±
±±³          ³ExpC4: Nome do arquivo de impressao                         	³±±
±±³          ³ExpC5: Nome do programa de impressao                      	³±±
±±³          ³ExpC6: Titulo do relatorio                                	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      	³±±
±±³          ³                                                            	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   	³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FsImpDet(cLayOut,cFisico,cDir,lEnd,wnrel,nomeprog,Titulo)

Local aCabec   := {}
Local aDumpP   := {}
Local aDumpU   := {}
Local cLinha   := ""
Local cComando := ""
Local nX       := 0
Local nY       := 0
Local nZ       := 0
Local Li       := 100

Private cArquivo := cFisico //Utilizado dentro do layout do dump

If File(cLayOut)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Calcula o DUMP dos 30 primeiros e 30 ultimos registros                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cDir := AllTrim(cDir)
	FT_FUse(cDir+cArquivo)
	FT_FGotop()
	While ( !FT_FEof() )
		cLinha   := SubStr(FT_FREADLN(),1,220)
		If Len(aDumpP) < 30
			aadd(aDumpP,cLinha)
		EndIf
		aadd(aDumpU,cLinha)
		If Len(aDumpU) > 30
			aDumpU := aDel(aDumpU,1)
			aDumpU := aSize(aDumpU,30)
		EndIf
		FT_FSkip()
	EndDo
	FT_FUse()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Imprime a listagem de acompanhamento                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Li > 60
		Li:=0
		@ 000,000 PSAY AvalImp(limite)
		For nY := 1 To Len(aCabec)
			@ Li,000 PSAY &(aCabec[nY])
			Li++
		Next nY
	EndIf
	FT_FUse(cLayOut)
	FT_FGotop()
	While ( !FT_FEof() )
		cLinha   := FT_FREADLN()
		nX       := At("]",cLinha)
		cComando := Upper(SubStr(cLinha,2,nX-2))
		Do Case
		Case cComando == "PSAY" .Or. cComando == "CABEC"
			If !Empty(SubStr(cLinha,nX+1))
				@ Li,000 PSAY &(SubStr(cLinha,nX+1))
			EndIf
			Li++
			If cComando == "CABEC"
				aadd(aCabec,SubStr(cLinha,nX+1))
			EndIf
		Case cComando == "DUMPP"
			For nY := 1 To Len(aDumpP)
				@ Li,000 PSAY aDumpP[nY]
				Li++
				If Li > 60
					Li:=0
					@ 000,000 PSAY AvalImp(limite)
					For nZ := 1 To Len(aCabec)
						@ Li,000 PSAY &(aCabec[nZ])
						Li++
					Next nZ
				EndIf
			Next nY
		Case cComando == "DUMPU"
			For nY := 1 To Len(aDumpU)
				@ Li,000 PSAY aDumpU[nY]
				Li++
				If Li > 60
					Li:=0
					@ 000,000 PSAY AvalImp(limite)
					For nZ := 1 To Len(aCabec)
						@ Li,000 PSAY &(aCabec[nZ])
						Li++
					Next nZ
				EndIf
			Next nY
		EndCase
		FT_FSkip()
	EndDo
	FT_FUSE()
	Set Device To Screen
	Set Printer To
	If ( aReturn[5] = 1 )
		dbCommitAll()
		OurSpool(wnrel)
	Endif
EndIf
MS_FLUSH()
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³FisGetEnd ³ Autor ³Nereu Humberto Jr      ³ Data ³12.12.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna a estrutura do endereco passado                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpA:  [1] Endereco                                         ³±±
±±³          ³       [2] Numero                                           ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Texto do Endereco                                    ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FisHcEnd(cEndereco)

Local nVirgula		:= Rat(",",cEndereco)
Local cNumero   	:= AllTrim(SubStr(cEndereco,nVirgula+1))
Local nNumero 		:= Val(cNumero)
Local cEnderec		:= PadR(IIf(nNumero!=0,SubStr(cEndereco,1,nVirgula-1),cEndereco),34)
Local cCompl		:= AllTrim(SubStr(cEndereco,nVirgula+1))
Local cComplemen	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quando nao ha virgula no endereco procura-se o caracter branco³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( nVirgula == 0 )
	nVirgula 	:= Rat(" ",AllTrim(cEndereco))
	cNumero     := AllTrim(SubStr(cEndereco,nVirgula+1))
	nNumero		:= Val(cNumero)
	cEnderec	:= PadR(IIf(nNumero!=0,SubStr(cEndereco,1,nVirgula-1),cEndereco),34)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quando o numero é numerico, obtem-se o complemento            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nNumero <> 0 
	If At(" ",AllTrim(cCompl)) > 0
		cComplemen := Alltrim(SubStr(cCompl,At(" ",AllTrim(cCompl))+1))
	Endif
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Para o numero caracter extrai o complemmento.                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNumero := StrTran(cNumero,cComplemen,"")

Return({cEnderec,nNumero,cNumero,cComplemen})

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³FisGetTel ³ Autor ³Eduardo Riera          ³ Data ³26.02.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna a estrutura do telefone passado                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpA:  ExpN[1] Codigo do Pais                               ³±±
±±³          ³       ExpN[2] Codigo de Area                               ³±±
±±³          ³       ExpN[3] Telefone                                     ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Texto do Telefone                                    ³±±
±±³          ³ExpC2: Codigo de area                                       ³±±
±±³          ³ExpC3: Codigo do Pais                                       ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FisHcTel(cTelefone,cArea,cPais)

Local nX      := 0
Local cAux    := ""
Local cNumero := ""
Local lFone   := .T.
Local lArea   := .F.
Local lPais   := .F.

DEFAULT cArea := ""
DEFAULT cPais := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifico o que deve ser extraido do numero do telefone        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lArea := Empty(cArea)
lPais := Empty(cPais) .And. lArea
cTelefone := AllTrim(cTelefone)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtenho o codigo de pais/area e telefone do Telefone          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nX := Len(cTelefone) To 1 Step -1
	cAux := SubStr(cTelefone,nX,1)
	If cAux >= "0" .And. cAux <= "9"
		Do Case
		Case lFone
			cNumero := cAux + cNumero
		Case lArea
			cArea := cAux + cArea
		Case lPais
			cPais := cAux + cPais
		EndCase
	Else
		Do Case
		Case lFone
			If Len(cNumero) > 5
				lFone := .F.
			EndIf
		Case lArea
			If !Empty(cArea)
				lArea := .F.
			EndIf
		EndCase
	EndIf
Next nX

Return({Val(cPais),Val(cArea),Val(cNumero)})

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³FisGetSer ³ Autor ³ Nereu Humberto Junior ³ Data ³27.02.2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna a serie valida para os validadores                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpA:  ExpN[1] Serie valida                                 ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Serie a ser validada                                 ³±±
±±³          ³ExpC2: Tipo do Registro                                     ³±±
±±³          ³ExpC2: Especie - (Especifico para DES)                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FisHcSer(cSerie,cTipo,cEspecie,cCFOP)

Local cRetorno := ""
DEFAULT cTipo  := ""
DEFAULT cEspecie := ""
DEFAULT cCFOP    := ""

If !Empty(cSerie)
	If Empty(cTipo)
		Do Case
		Case Substr(cSerie,1,1)=="B"
			cRetorno := "B  "
		Case Substr(cSerie,1,1)=="C"
			cRetorno := "C  "
		Case Substr(cSerie,1,1)=="E"
			cRetorno := "E  "
		Case Substr(cSerie,1,1)=="U"
			cRetorno := "1  "
		Case Substr(cSerie,1,1) $ "1234567890" .And. !Substr(cSerie,2,1) $ "1234567890 " .And. !Substr(cSerie,3,1) $ "1234567890 "
			cRetorno := "1  "
		Case Substr(cSerie,1,1) $ "1234567890 " .And. Substr(cSerie,2,1) $ "1234567890 " .And. Substr(cSerie,3,1) $ "1234567890 "
			cRetorno := cSerie
		OtherWise
			cRetorno := "1  "
		EndCase
		If !Empty(cEspecie)
			If AllTrim(cEspecie) == "NFS"
				If Substr(cSerie,1,1) $ "ACDE"
					cRetorno := Substr(cSerie,1,1)+Space(2)
				Endif
			Else
				cRetorno := cSerie
			Endif
		Endif
	ElseIf cTipo == "61"
		If !Substr(cSerie,1,1) $ "123456789U "
			cRetorno := "D  "
		Else
			cRetorno := "U  "
		Endif
	ElseIf cTipo == "70"
		If !Substr(cSerie,1,1) $ "123456789U "
			cRetorno := SubStr (cSerie, 1, 1)
		Else
			cRetorno := "U"
		Endif
	Endif
Else
	cRetorno := cSerie
Endif

Return(cRetorno)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³sfVldPReg ³ Autor ³ Gustavo G. Rueda      ³ Data ³26.06.2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao utilizada para validar o (PREREG) dos INI's, podendo ³±±
±±º          ³inserir uma condicao ou uma funcao retornando uma string.   |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL: .T./.F.                                               ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpA1: Array contendo todos PreReg                          ³±±
±±³          ³ExpN2: Controle                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function sfVldPReg (aPreReg, nHandle)
Local	lRet	:=	.T.
Local	nInd	:=	0
Local	aArea	:=	GetArea ()
Local	xVar
Local   cVar
//
If (Len (aPreReg)<>0)
	For nInd := 1 To Len (aPreReg)
		cVar	:= aPreReg[nInd]
		xVar	:=	&(aPreReg[nInd])
		If (ValType(xVar)=="C") .And. !":="$cVar
			FWrite (nHandle, xVar+Chr(13)+Chr(10))
			lRet	:=	.T.
		Else
			If (ValType (xVar)=="L")
				If !xVar
					lRet	:=	xVar
					Exit
				EndIf
			Else
				lRet	:=	.T.
			EndIf
		EndIf
	Next nInd
EndIf
RestArea (aArea)
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ImpSpool  ³ Autor ³ Gustavo G. Rueda      ³ Data ³26.04.2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao utilizada atraves dos ini's para impressao em spool  ³±±
±±º          ³de informacoes sob um layout basico.                        |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL: lRet - .T./.F.                                        ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC: cNorma - Arquivo INI de configuracao.                 ³±±
±±³          ³ExpC: cDest - Nome do arquivo txt gerado                    ³±±
±±³          ³ExpC: cDir - Nome do diretorio onde o txt foi gerado.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³OBS       ³Para impressao deste relatório e necessario que as clausulas³±±
±±³          ³abaixo estejam configuradas conforme seguem:                ³±±
±±³          ³1 - Da mesma forma que o (PRE) deve ser criado uma clausula ³±±
±±³          ³chamada (IMP) onde devera conter um array com a primeira po-³±±
±±³          ³sicao indicando se o registro deve ser impresso (.T.) ou nao³±±
±±³          ³(.F.), caso esta clausula nao exista sera considerado .F. e ³±±
±±³          ³nenhum campo do registro sera impresso. A segunda e a ter-  ³±±
±±³          ³ceira posicao deste array definido pela clausula (IMP)      ³±±
±±³          ³he utilizada para indicar a coordenada do                   ³±±
±±³          ³campo chave de cada registro, onde a segunda posicao indica ³±±
±±³          ³a posicao inicial e a terceira posicao indica a qtd de len  ³±±
±±³          ³para este campo. A quarta posicao indica o nome do campo    ³±±
±±³          ³digitado no ini que indique o campo chave do registro. Ex:  ³±±
±±³          ³(IMP){.T.,1,2,"SEQ01"}                                      ³±±
±±³          ³2 - Quando um campo for impresso deve ter um label de 20 ca-|±±
±±³          ³racteres contando com as aspas logo apos a qtd de casas de- ³±±
±±³          ³cimais, em seguida deve se deixar um espaco em branco e in- ³±±
±±³          ³dicar novamente entre aspas com o tamanho de 20 caracteres  ³±±
±±³          ³a PICTURE a ser utilizada para a coluna em questao, em se-  ³±±
±±³          ³guida deve-se deixar outro espaco em branco e idicar o      ³±±
±±³          ³conteudo do campo, conforme atualmente utilizado. Ex:       ³±±
±±³          ³SEQ01      C 002 0 "TP             " "@!             " "TO" ³±±
±±³          ³3 - Para a impressao do relatorio, a qtd de len para uma    ³±±
±±³          ³coluna he a mesma definido no ini. No exemplo acima, o len  ³±±
±±³          ³da coluna para o campo SEQ01 he de 2 caracteres, portanto,  ³±±
±±³          ³o label da coluna deve respeitar esta regra.                ³±±
±±³          ³4 - Ao final do ini a ser utilizada esta funcao, deve-se    ³±±
±±³          ³inserir a seguinte chamada de funcao. Ex:                   ³±±
±±³          ³ImpSpool (MV_PAR03, MV_PAR04, MV_PAR05), onde:              ³±±
±±³          ³MV_PAR03 = Arquivo ini de configuracao.                     ³±±
±±³          ³MV_PAR04 = Arquivo txt gerado atraves do ini.               ³±±
±±³          ³MV_PAR05 = Diretorio destino do arquivo txt gerado.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ImpHcool (cNorma, cDest, cDir, aArqSpool)
Local 		aArea		:=	GetArea ()
Local		lRet		:=	.T.
Local 		cTitulo  	:= 	"teste"
Local 		cDesc1  	:= 	"teste2"
Local 		cDesc2  	:= 	""
Local 		cDesc3  	:= 	""
Local 		wnrel   	:= 	"Mata950"
Local 		NomeProg	:= 	"Mata950"
Private 	Tamanho 	:= 	"G" 	// P/M/G
Private 	Limite  	:= 	220 	// 80/132/220
Private 	lEnd    	:= 	.F.		// Controle de cancelamento do relatorio
Private 	m_pag   	:= 	1  		// Contador de Paginas
Private	nLastKey	:= 	0  		// Controla o cancelamento da SetPrint e SetDefault
Private 	aReturn 	:= {"Zebrado", 1,"Administracao", 1, 2, 1, "",1 } //"Zebrado"###"Administracao"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia para a SetPrinter                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel	:=	SetPrint ("", NomeProg, "", @cTitulo, cDesc1, cDesc2, cDesc3, .F.,, .F., Tamanho,, .F.)
//
If (nLastKey==27)
	Return (lRet)
Endif
//
SetDefault (aReturn, "")
//
If (nLastKey==27)
	Return (lRet)
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Preparacao do inicio de processamento do arquivo pre-formatado          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus ({|lEnd| GeraSpool (cNorma, cDest, cDir, aArqSpool)}, cTitulo)
//
If (aReturn[5]==1)
	Set Printer To
	ourspool(wnrel)
Endif
MS_FLUSH()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura area ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea (aArea)
Return (lRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³GeraSpool ³ Autor ³ Gustavo G. Rueda      ³ Data ³26.04.2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de impressao.                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL: lRet - .T./.F.                                        ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC: cNorma - Arquivo INI de configuracao.                 ³±±
±±³          ³ExpC: cDest - Nome do arquivo txt gerado                    ³±±
±±³          ³ExpC: cDir - Nome do diretorio onde o txt foi gerado.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GeraSpool (cNorma, cDest, cDir, aArqSpool)
Local	lRet		:=	.T.
Local	nTamNorma	:=	0
Local	nTamTxt		:=	0
Local	nReadNorma	:=	0
Local	nReadTxt	:=	0
Local	nHandleNorma:=	0
Local	nHandleTxt	:=	0
Local	nByteNorma	:=	1
Local	nByteTxt	:=	1
Local	cTitulo		:=	""
Local	lFirst		:=	.T.
Local	aColImp		:=	{}
Local	aImprime	:=	{.F.,,,,.F.}	//1-Indica se imprime (.T. ou .F.), 2-Posicao inicial chave registro, 3-Len do indentificador, 4-Nome do campo na estrutura do ini, 5-Analitico(.f.) ou Sintetico (.t.)
Local	aLidosNorma	:=	{}
Local	aLidosTxt	:=	{}
Local	cLinhaNorma	:=	""
Local	cLinhaTxt	:=	""
Local	cLinha		:=	""
Local	cLinha2		:=	""
Local	cChaveNorma	:=	""
Local	cChaveTxt	:=	""
Local	nInd		:=	1
Local	aColuna		:=	{}
Local	nLin		:=	99
Local	nTipo		:=	18
Local	nPosInicial	:=	1
Local	nIniCampo	:=	0
Local	nLenCampo	:=	0
Local	cDetCampo	:=	""
Local	aDetImp		:=	{}
Local	cTipoCampo	:=	""
Local	cMaskCampo	:=	""
Local	cFundo		:=	""
Local	cDivisao	:=	""
Local	lNumber		:=	.T.
Local	lGerou		:=	.T.
Local	cBarra		:=	""
Local	nLinPag		:=	60
Local	lLinha		:=	.T.
Local	cLegenda	:=	""
Local	cDecimal	:=	""
Local	aCampos		:=	{}
Local	nPosCampos	:=	0
Local	aArqSpoolX	:=	aArqSpool
Local	nI			:=	0
Local	lLoop		:=	.F.
Local	lVariosArq	:=	Len (aArqSpoolX)>0
Local	cDelimitador:=	""
Local	nCmpDel		:=	0
Local	lSintetico	:=	aImprime[5]
Local	nLenCmp		:=	0
Local	cArqBloco	:=	""	//Nome do arquivo para controle, pois com este nome me certifico de que o arquivo TXT
//  gerado aberto no momento se refere a IN ou a um bloco dela (no caso de varios arquivos. Ex: NORMA086/SINCONF)
//
If (File(cNorma)) .And. ((File(cDir+cDest)) .Or. lVariosArq)
	nHandleNorma	:=	FOpen (cNorma)
	nTamNorma		:=	FSeek (nHandleNorma, 0, 2)
	FSeek (nHandleNorma, 0, 0)
	nReadNorma 	:= 	FRead (nHandleNorma, @cLinha, nTamNorma)
	// 
	lVariosArq	:=	Len(aArqSpoolX)>1
	If !lVariosArq  
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tratamento para quando existir somente uma clausula ARQ para ³
		//³  todo o arquivo.                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cDest	:=	Iif( Len(aArqSpoolX)==1,aArqSpoolX[1],cDest)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tratamento para quando for uma IN para um arquivo TXT gerado³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cArqBloco	:=	cDest
		aAdd (aArqSpoolX, cDest)
	EndIf
	//
	For nI := 1 To Len (aArqSpoolX)
		FT_FUse(cDir+aArqSpoolX[nI])
		FT_FGotop()
		//
		While nByteNorma<=nTamNorma .And. ( !FT_FEof() )
			aLidosNorma	:=	LerLinha (cLinha, nByteNorma)	//Funcao utilizada para ler registro a registro do txt gerado.
			cLinhaNorma	:=	SubStr (aLidosNorma[1], 1, At (Chr (13)+Chr(10), aLidosNorma[1])-1)
			nByteNorma	:=	aLidosNorma[2]
			//
			If (lVariosArq)	//Somente Para inis que utilizam a clausula (ARQ)
				If (AllTrim (SubStr (cLinhaNorma, 1, 1))$"[{")
					lLoop	:=	.F.
				EndIf
				//
				If (lLoop)
					Loop
				EndIf
			EndIf
			//
			Do Case
			Case (AllTrim (SubStr (cLinhaNorma, 1, 1))$"[{") .Or. nByteNorma>nTamNorma
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Impressao efetuada a cada bloco ou quando o proximo while for falso.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If (aImprime[1]) .And. !(lFirst) .And. (aArqSpoolX[nI]$cArqBloco)
					cFundo		:=	""
					cDivisao	:=	""
					cBarra		:=	""
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Neste for monta-se o nome das colunas e o fundo para ser utilizado pela funcao FMTLIN³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					For nInd := 1 To Len (aColImp)
						aAdd (aColuna, AllTrim (SubStr (aColImp[nInd][7], 1, aColImp[nInd][4])))
						//
						cFundo		+=	"|"+Replicate ("#", aColImp[nInd][4])
						cDivisao	+=	"+"+Replicate ("-", aColImp[nInd][4])
					Next nInd
					cFundo		+=	"|"
					cDivisao	+=	"+"
					cBarra		:=	Replicate ("-", Len (cFundo))
					//
					While ( !FT_FEof() )
						//
						lGerou	:=	.F.
						lNumber	:=	.F.
						If ValType (cChaveNorma)=="N"
							lNumber		:=	.T.
							cChaveNorma	:=	StrZero (cChaveNorma, Len (AllTrim (cChaveTxt)))
						EndIf
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Padronizo a comparacao, pois pode ocorrer de em algum registro o len do campo chave for diferente de um outro registro.  ³
						//³Ex: Por default, na maioria dos registros os campos chaves possuem 2 caracteres mais em um registro em especifico,       ³
						//³o campo chave he formado por 3 caracteres, portanto na proxima passagem por esta linha, quando a qtd de caracteres for 2,³
						//³tera de ser transformada para 2 caracteres antes da comparacao. O exemplo he de 2, mas pode ser a qualquer qtd.          ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If  cChaveNorma==Left (cChaveTxt, Len (AllTrim (cChaveNorma)))
							cChaveTxt	:=	Left (cChaveTxt, Len (AllTrim (cChaveNorma)))
						EndIf
						//
						If cChaveNorma<>cChaveTxt
							cLinhaTxt	:=	FT_FReadLn()

							If (lVariosArq)	//Se o ini gerar mais de um arquivo aceito todos os registros contidos no arquivo como o mesmo bloco.
								cChaveTxt	:=	cChaveNorma		//Somente Para inis que utilizam a clausula (ARQ)
							Else
								cChaveTxt	:=	SubStr (cLinhaTxt, aImprime[2], aImprime[3])
							EndIf
							//
							If lNumber
								cChaveNorma	:=	StrZero (Val (cChaveNorma), Len (AllTrim (cChaveTxt)))
							EndIf
						EndIf
						//
						If (cChaveNorma==cChaveTxt)
							lGerou	:=	.T.
							//
							If nLin>=nLinPag
								nLin	:=	cabec ("", "", "", "MATA950", "G", nTipo)
							EndIf
							//
							nLin++
							FmtLin ({cTitulo}, "",,"@X", @nLin)
							FmtLin ({}, cBarra,,, @nLin)
							FmtLin (aColuna, cFundo,,"@X", @nLin)
							FmtLin ({}, cDivisao,,, @nLin)
							//
							lLinha	:=	.F.
							//
							While ( !FT_FEof() ) .And. ( cChaveNorma == cChaveTxt )
								//Soh zero quando for analitico pois nao precisarah acumular (no caso do sintetico)
								If !lSintetico
									aDetImp	:=	{}
								EndIf
								//
								If nLin>=nLinPag
									If (lLinha)
										lLinha	:=	.F.
										FmtLin ({}, cBarra,,, @nLin)
									EndIf
									FmtLin ({}, "",,, @nLin)
									nLin	:=	cabec ("", "", "", "MATA950", "G", nTipo)
									nLin++
									FmtLin ({cTitulo}, "",,"@X", @nLin)
									FmtLin ({}, cBarra,,, @nLin)
								EndIf
								//
								For nInd := 1 To Len (aColImp)
									cTipoCampo	:=	aColImp[nInd][2]
									nIniCampo	:=	aColImp[nInd][3]
									nLenCampo	:=	aColImp[nInd][4]
									nDecimal	:=	aColImp[nInd][5]
									//Quando for analitico gero linha a linha do arquivo texto
									If !lSintetico
										If Empty (cDelimitador)
											If ("N"$cTipoCampo)
												If (nDecimal<>0)
													cMaskCampo	:=	A950Tm (Val (SubStr (cLinhaTxt, nIniCampo, nLenCampo)), nLenCampo, nDecimal)
													cDetCampo	:=	IntToDec (SubStr (cLinhaTxt, nIniCampo, nLenCampo), cMaskCampo, nDecimal)
												Else
													cDetCampo	:=	SubStr (cLinhaTxt, nIniCampo, nLenCampo)
												EndIf
											ElseIf ("C"$cTipoCampo)
												cMaskCampo	:=	A950Tm (SubStr (cLinhaTxt, nIniCampo, nLenCampo), nLenCampo, nDecimal)
												cDetCampo	:=	Transform (SubStr (cLinhaTxt, nIniCampo, nLenCampo), cMaskCampo)
											ElseIf ("D"$cTipoCampo)
												cDetCampo	:=	StrZero (Day(StoD (SubStr (cLinhaTxt, nIniCampo, nLenCampo))),2)+"/"+StrZero (Month(StoD (SubStr (cLinhaTxt, nIniCampo, nLenCampo))),2)+"/"+Right (StrZero (Year(StoD (SubStr (cLinhaTxt, nIniCampo, nLenCampo))),4), 2)
											EndIf
										Else
											nCmpDel	:=	aColImp[nInd][8]
											cDetCampo	:=	RetCmpDel (cLinhaTxt, cDelimitador, nCmpDel)
										EndIf
										//
										aAdd (aDetImp, cDetCampo)

										//Se for sintetico soh gero o totalizador
									Else
										cDetCampo	:=	Space (nLenCampo)
										//Monto o totalizador somente para campos numericos
										If ("N"$cTipoCampo)
											//Este 6 define que somente irei pegar campo que armazenarah valor a ser
											//	totalizado. Ex: Aliquota possui no maximo 6 (999.99)
											If (nDecimal<>0) .And. (nLenCampo>6)
												cMaskCampo	:=	A950Tm (Val (SubStr (cLinhaTxt, nIniCampo, nLenCampo)), nLenCampo, nDecimal)
												cDetCampo	:=	SubStr (cLinhaTxt, nIniCampo, nLenCampo)
												//
												If (Len (aDetImp)<Len (aColImp))//Para a primeira linha do txt inicializo o array com um add, nas proximas vou acumulando
													aAdd (aDetImp, {Val (cDetCampo), cMaskCampo, nDecimal})
												Else
													aDetImp[nInd][1]	+=	Val (cDetCampo)
												EndIf
											EndIf
										EndIf
										//
										//Este add somente serah executado para a primeira linha quando o conteudo da
										//	variavel cDetCampo estiver em branco.
										If Empty (cDetCampo) .And. (Len (aDetImp)<Len (aColImp))
											aAdd (aDetImp, {cDetCampo, "", 0})
										EndIf
									EndIf
								Next nInd
								//
								//Somente gero linha a linha quando for analitico
								If !lSintetico
									FmtLin (aDetImp, cFundo,,, @nLin)
								EndIf
								lLinha	:=	.T.
								//
								FT_FSkip()
								cLinhaTxt := FT_FReadLn()
								//
								If (lVariosArq)	//Se o ini gerar mais de um arquivo aceito todos os registros contidos no arquivo como o mesmo bloco.
									cChaveTxt	:=	cChaveNorma		//Somente Para inis que utilizam a clausula (ARQ)
								Else
									cChaveTxt	:=	SubStr (cLinhaTxt, aImprime[2], aImprime[3])
								EndIf
							EndDo
							//
							If (cChaveNorma<>cChaveTxt)
								Exit
							EndIf
						Else
							FT_FSkip()
							cLinhaTxt := FT_FReadLn()
							//
							If (lVariosArq)	//Se o ini gerar mais de um arquivo aceito todos os registros contidos no arquivo como o mesmo bloco.
								cChaveTxt	:=	cChaveNorma		//Somente Para inis que utilizam a clausula (ARQ)
							Else
								cChaveTxt	:=	SubStr (cLinhaTxt, aImprime[2], aImprime[3])
							EndIf
						EndIf
					EndDo
					//
					If (lGerou)
						//
						//Somente gero quando for sintetico pois trata-se do totalizador de cada registro
						If lSintetico
							For nInd := 1 To Len (aDetImp)
								cDetCampo	:=	aDetImp[nInd][1]
								If !Empty (cDetCampo)
									cDetCampo	:=	IntToDec (aDetImp[nInd][1], aDetImp[nInd][2], aDetImp[nInd][3])
								EndIf
								aDetImp[nInd]	:=	cDetCampo
							Next nInd
							FmtLin (aDetImp, cFundo,,, @nLin)
						EndIf
						FmtLin ({}, cBarra,,, @nLin)
						If !Empty (cLegenda)
							FmtLin ({cLegenda}, "",,"@X", @nLin)
							cLegenda	:=	""
						EndIf
					Else
						FT_FGotop()
					EndIf
				EndIf
				//
				cTitulo		:=	AllTrim (SubStr (cLinhaNorma, 5, At ("]", cLinhaNorma)-5))
				lFirst		:=	.F.
				aImprime	:=	{.F.,,,,.F.}
				aColImp		:=	{}
				aColuna		:=	{}
				nPosInicial	:=	1
				cChaveNorma	:=	""
				aCampos		:=	{}
				cDelimitador:= 	""
				nCmpDel		:=	0
				aDetImp		:=	{}
				//
				If (lVariosArq)	//Somente para ini com clausula (ARQ)
					cChaveTxt	:=	""
				EndIf
				//
			Case "(DEL)"$AllTrim (SubStr (cLinhaNorma, 1, 5))
				cDelimitador:=	SubStr (AllTrim (SubStr (cLinhaNorma, 6)), 1, 1)

			Case "(ARQ)"$AllTrim (SubStr (cLinhaNorma, 1, 5))
				cArqBloco	:=	AllTrim (SubStr (cLinhaNorma, 6))
				If ("&"$cArqBloco)
					cArqBloco	:=	&(AllTrim(SubStr (cArqBloco, At ("&", cArqBloco)+1)))
				EndIf

				If !(aArqSpoolX[nI]$cArqBloco)
					lLoop	:=	.T.
				EndIf

			Case "(IMP)"$AllTrim (SubStr (cLinhaNorma, 1, 5))
				aImprime	:=	&(AllTrim (SubStr (cLinhaNorma, 6)))
				lSintetico 	:= 	Iif (Len (aImprime)<>5, .F., &(aImprime[5]))

			Case "(LEG)"$AllTrim (SubStr (cLinhaNorma, 1, 5))
				cLegenda	:=	&(AllTrim (SubStr (cLinhaNorma, 6)))

			Case "(CMP)"$AllTrim (SubStr (cLinhaNorma, 1, 5))
				aCampos	:=	&(AllTrim (SubStr (cLinhaNorma, 6)))

			Case !(AllTrim (SubStr (cLinhaNorma, 1, 1))$"(") .And. (aImprime[1])
				//
				nCmpDel++
				nPosCampos	:=	aScan (aCampos, {|aX| aX[1]==AllTrim (SubStr (cLinhaNorma, 01, 10))})
				//
				If nPosCampos<>0
					nLenCmp	:=	Iif (Len (aCampos[nPosCampos])==3, aCampos[nPosCampos][3], Val(SubStr (cLinhaNorma, 14, 3)))
					aAdd (aColImp, {AllTrim (SubStr (cLinhaNorma, 01, 10)), SubStr (cLinhaNorma, 12, 01), nPosInicial, nLenCmp, Val (SubStr (cLinhaNorma, 18, 01)), SubStr (cLinhaNorma, 20), Iif (Empty (aCampos[nPosCampos][2]), aCampos[nPosCampos][1], aCampos[nPosCampos][2]), nCmpDel})
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Este if trata o codigo de identificacao de cada registro como fixo no proprio ini para³
				//³posterior associacao com o txt gerado.                                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If aImprime[1] .And. (AllTrim (SubStr (cLinhaNorma, 01, 10))$aImprime[4]) .And. !(lVariosArq)
					cChaveNorma	:=	&(AllTrim (SubStr (cLinhaNorma, 20)))

				ElseIf (lVariosArq)	//Somente Para inis que utilizam a clausula (ARQ)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Se o ini gerar varios arquivos como por exemplo a NORMA086, essume-se que cada arquivo identifica um registro  e o codigo³
					//³de identificacao de cada registro e assumido como ALL.                                                                   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cChaveNorma	:=	"ALL"
				EndIf
				//
				nPosInicial	+=	Val(SubStr (cLinhaNorma, 14, 3))
			EndCase
			//
		EndDo
		//
		FT_FUse()
	Next nI
	//
	FClose (nHandleNorma)
	FT_FUse()
EndIf
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³LerLinha  ³ Autor ³ Gustavo G. Rueda      ³ Data ³28.04.2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao utilizada para ler linha-a-linha de um arquivo texto.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpA[1]: String lida                                        ³±±
±±³          ³ExpA[2]: Bytes lidos                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC: cLinha - Buffer do arquivo a ser processado           ³±±
±±³          ³ExpN: nInicio - Byte inicial para leitura                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³MATA950        |                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function LerLinha (cLinha, nInicio)
Local 	cString 	:= 	""
Local	nLidos 		:=	nInicio
//
While .T.
	cChar 		:= 	SubStr (cLinha, nLidos, 1)
	cString		+=	cChar
	nLidos++
	//
	If cChar==chr (10)
		cString := cString
		Exit
	EndIf
EndDo
Return {cString, nLidos}
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³A950Tm    ³ Autor ³ Gustavo G. Rueda      ³ Data ³28.04.2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao utilizada para retornar a Picture para um numero ou  ³±±
±±³          ³caracter.                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpC: cRetPic - Picture formada no processamento. No caso   ³±±
±±³          ³de Numero sera retornado @E.... e no caso de caracter @!.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpU: uCampo - Conteudo de um campo a ser processado        ³±±
±±³          ³ExpN: nLen - Numero de bytes para formatar a picture        ³±±
±±³          ³ExpN: nDec - Numero de bytes para a casa decimal            ³±±
±±³          ³ExpN: lEstrang - Nao considera nenhuma picture para casos   ³±±
±±³          ³estrangeiros.                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³MATA950        |                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A950Tm (uCampo, nLen, nDec, lEstrang)
Local	cPic		:=	""
Local	cRetPic		:=	""
Local	nInicio		:=	0
//
lEstrang := Iif (lEstrang==Nil, .F., lEstrang)
//
If nDec==NIL
	nDec	:=	GetMv("mv_cent")
EndIf
//
If Valtype (uCampo)=="N"
	cPic := Iif (GetMv("mv_milhar"), "999,999,999,999,999,999,999,999", "9999999999999999999999999999999")+Iif (nDec>0, ("."+Replicate ("9", nDec)),"")
ElseIf Valtype (uCampo)=="C"
	cRetPic := "@!"
EndIf
//
nInicio	:=	Len (cPic)-nLen
nInicio++
//
While (nInicio<=Len (cPic)) .And. Valtype (uCampo)=="N"
	If !(nInicio==Len (cPic)-nLen .And. SubStr (cPic, nInicio, 1)$".,")
		cRetPic	+=		SubStr (cPic, nInicio, 1)
	EndIf
	//
	nInicio++
End
//
If !(lEstrang) .And. !"@!"$cRetPic
	cRetPic	:=	"@E "+cRetPic
EndIf
Return (cRetPic)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³IntToDec  ³ Autor ³Gustavo G. Rueda       ³ Data ³28.04.2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao para conversao dos valores gravados nos arquivos     ³±±
±±³          ³ textos conforme instrucao normativa. Especificamente para  ³±±
±±³          ³ numeros decimais.                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpN -> nDec - numero convertido.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC -> cInt - Numerono formato de caracter a ser convertido³±±
±±³          ³ExpC -> cMask - Mascara a ser utilizada apos conversao.     ³±±
±±³          ³ExpN -> nDec - Qtd de casas decimais.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³MATA950        |                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function IntToDec (cInt, cMask, nDec)
Local		cDec	:=	""
//
nDec := Iif (nDec==Nil, 2, nDec)
If (ValType (cInt)$"N")
	cInt	:=	Str (cInt)
EndIf
//
cDec	:=	Transform (Val (Left (AllTrim (cInt), Len (AllTrim (cInt))-nDec)+"."+Right (AllTrim (cInt), nDec)), cMask)
Return (cDec)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RetTotICMSºAutor  ³Sergio S. Fuzinaka  º Data ³ 05/09/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Retorna o Total de ICMS Proprio e ST do Produto sujeito a STº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³MATA950	                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RetTotICMS(cProduto,dUltFec,nSaldo,c88Ind,aNFsProc,lRgEspSt,lUsaSFT)

Local aArea		:= GetArea()
Local nRecno	:= 0
Local aRet		:= {0,0}
Local cAliasSD1	:= "SD1"
Local nQuant	:= 0
Local bCond		:= {||}
Local nVlrUnit	:= 0	//Valor Unitario do ICMS PROPRIO
Local nVlrUnST	:= 0	//Valor Unitario do ICMS ST
Local nSldDif	:= 0	//Diferenca de Saldo
Local nValIcms	:= 0	//ICMS PROPRIO Proporcional
Local nIcmsRet	:= 0	//ICMS ST Proporcional
Local nRetInd	:= 0
Local aDtFec	:= {}	//Datas de Fechamento do Produto
Local nX		:=	0
Local cChave	:= ""
Local lMonta88	:= .T. 

#IFDEF TOP
	Local aStruSD1 	:=	{}
	Local cQuery   	:=	""
	Local nY		:= 0
#ELSE
	Local cInd		:=	""
	Local cFiltro	:=	""
#ENDIF

Default aNFsProc 	:= {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array contendo as datas de fechamento do produto ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SB9")
dbSetOrder(1)
If dbSeek(xFilial("SB9")+cProduto)
	While !Eof() .And. xFilial("SB9") == SB9->B9_FILIAL .And. cProduto == SB9->B9_COD
		If Ascan(aDtFec,{|x| x[1]==SB9->B9_DATA}) == 0
			AADD(aDtFec,{SB9->B9_DATA})
		Endif
		dbSkip()
	Enddo
	AADD(aDtFec,{CtoD("")})
	aSort(aDtFec,,,{|x,y| x[1]>y[1]}) 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ As ultimas Notas Fiscais de Compra do Produto    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SD1")
	dbSetOrder(6)

	For nX := 1 To Len(aDtFec)
		If nX > 1
			#IFDEF TOP
				dbSelectArea(cAliasSD1)
				dbCloseArea()
			#ELSE
				dbSelectArea(cAliasSD1)
				RetIndex(cAliasSd1)
				FErase(cInd+OrdBagExt())
			#ENDIF
		Endif		
		#IFDEF TOP
			cAliasSD1 := "AliasSD1"
			aStruSD1  := SD1->(dbStruct())
			cQuery    := "SELECT D1_FILIAL,D1_TIPO,D1_DTDIGIT,D1_VALICM,D1_QUANT,D1_ICMSRET,D1_BRICMS,D1_DOC,D1_SERIE,D1_ITEM,D1_FORNECE,D1_LOJA,D1_COD "
			cQuery    += "FROM " + RetSqlName("SD1") + " "
			cQuery    += "WHERE D1_FILIAL = '" + xFilial("SD1") + "' AND "
			cQuery    += "D1_COD = '" + cProduto + "' AND "
			cQuery    += "D1_TIPO NOT IN('P','I','C') AND "	
			cQuery    += "D1_DTDIGIT < '" + Dtos(dUltFec) + "' AND "
			cQuery    += "D1_DTDIGIT >= '" + Dtos(aDtFec[nX][1]) + "' AND "			
			If !lRgEspSt
				cQuery	+= "D1_BRICMS > 0 AND "
			Endif
			cQuery    += "D_E_L_E_T_= ' ' "
			cQuery    += "ORDER BY D1_DTDIGIT DESC"
			cQuery    := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD1,.T.,.T.)
			For nY := 1 To Len(aStruSD1)
				If ( aStruSD1[nY][2] <> "C" )
					TcSetField(cAliasSD1,aStruSD1[nY][1],aStruSD1[nY][2],aStruSD1[nY][3],aStruSD1[nY][4])
				EndIf
			Next nY
		#ELSE
			cInd	:=	CriaTrab(NIL,.F.)
			cFiltro	:=	"D1_FILIAL == '" + xFilial("SD1") + "'"
			If !lRgEspSt
				cFiltro	+=	" .And. !(D1_TIPO $ 'P/I/C') .And. D1_BRICMS > 0 .And. D1_COD == '" + cProduto + "' .And. Dtos(D1_DTDIGIT) < '" + Dtos(dUltFec) + "'.And. Dtos(D1_DTDIGIT) >= '" + Dtos(aDtFec[nX][1]) + "'"
			Else
				cFiltro	+=	" .And. !(D1_TIPO $ 'P/I/C') .And. D1_COD == '" + cProduto + "' .And. Dtos(D1_DTDIGIT) < '" + Dtos(dUltFec) + "'.And. Dtos(D1_DTDIGIT) >= '" + Dtos(aDtFec[nX][1]) + "'"
			Endif
			IndRegua (cAliasSD1,cInd,IndexKey(),,cFiltro,Nil,.F.)
			dbClearIndex()	
			nRetInd := RetIndex(cAliasSD1)
			dbSetIndex(c88Ind+OrdBagExt())  
			dbSetIndex(cInd+OrdBagExt())
			dbSetOrder(nRetInd+2)
			dbGoTop()			
		#ENDIF
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se possuir regime especial de ST, ira verificar se o TES utilizado³
		//³e para movimentos de Regime Especial.                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lMonta88 	:= .T.
		nQuant 		:= 0
		If lRgEspSt
			lMonta88 := RetMonta88((cAliasSD1)->D1_BRICMS,(cAliasSD1)->D1_SERIE,;
						(cAliasSD1)->D1_DOC,(cAliasSD1)->D1_FORNECE,(cAliasSD1)->D1_LOJA,;
						(cAliasSD1)->D1_ITEM,(cAliasSD1)->D1_COD,lUsaSFT)
		Endif
		
		If lMonta88
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Armazena o item da nota fiscal que foi processado para composicao do estoque de ST³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cChave := (cAliasSD1)->D1_FILIAL+(cAliasSD1)->D1_DOC+(cAliasSD1)->D1_SERIE+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA+(cAliasSD1)->D1_COD+(cAliasSD1)->D1_ITEM
			If aScan(aNFsProc,{|x| x[1]+x[2]+x[3]+x[4]+x[5]+x[6]+x[7]==cChave}) == 0
				Aadd(aNFsProc,{(cAliasSD1)->D1_FILIAL,(cAliasSD1)->D1_DOC,(cAliasSD1)->D1_SERIE,(cAliasSD1)->D1_FORNECE,(cAliasSD1)->D1_LOJA,(cAliasSD1)->D1_COD,(cAliasSD1)->D1_ITEM})
			Endif

			dbEval({|| nQuant += D1_QUANT})
		Endif
		If nQuant >= nSaldo
			Exit
		Endif
	Next nX

	dbSelectArea(cAliasSD1)
	#IFDEF TOP
		bCond := {|| !Eof()}
		dbGoTop()
	#ELSE
		bCond := {|| !Bof()}	
		dbGoBottom()	
	#ENDIF
	nQuant := 0
	While Eval(bCond) .And. (nQuant < nSaldo)
		
		nValIcms	:= (cAliasSD1)->D1_VALICM	//ICMS PROPRIO
		nIcmsRet	:= (cAliasSD1)->D1_ICMSRET	//ICMS ST
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se possuir regime especial de ST, ira verificar se o TES utilizado³
		//³e para movimentos de Regime Especial.                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lMonta88 	:= .T.
		If lRgEspSt
			lMonta88 := RetMonta88((cAliasSD1)->D1_BRICMS,(cAliasSD1)->D1_SERIE,;
						(cAliasSD1)->D1_DOC,(cAliasSD1)->D1_FORNECE,(cAliasSD1)->D1_LOJA,;
						(cAliasSD1)->D1_ITEM,(cAliasSD1)->D1_COD,lUsaSFT)
		Endif
	
		If lMonta88        

		    If (cAliasSD1)->D1_TIPO == "N"
				nRecno := Recno()
			    NfCompl(cAliasSD1,@nValIcms,@nIcmsRet,dUltFec,nRetInd,@aNFsProc,lUsaSFT,lRgEspSt)
				dbSelectArea(cAliasSD1)
				#IFNDEF TOP
					dbSetOrder(nRetInd+2)
				#ENDIF
		   		dbGoTo(nRecno)
		    Endif
		
			If (nQuant + (cAliasSD1)->D1_QUANT) > nSaldo
				nVlrUnit	:= (nValIcms / (cAliasSD1)->D1_QUANT)	//Valor Unitario do ICMS PROPRIO
				nVlrUnST	:= (nIcmsRet / (cAliasSD1)->D1_QUANT)	//Valor Unitario do ICMS ST
				nSldDif		:= (nSaldo - nQuant)		//Diferencao de Saldo
				nValIcms	:= (nVlrUnit * nSldDif)		//ICMS PROPRIO Proporcional
				nIcmsRet	:= (nVlrUnST * nSldDif)		//ICMS ST Proporcional
			Endif
			
			nQuant	+= (cAliasSD1)->D1_QUANT
			aRet[1]	+= nValIcms		//ICMS Proprio
			aRet[2]	+= nIcmsRet		//ICMS ST
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Armazena o item da nota fiscal que foi processado para composicao do estoque de ST³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cChave := (cAliasSD1)->D1_FILIAL+(cAliasSD1)->D1_DOC+(cAliasSD1)->D1_SERIE+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA+(cAliasSD1)->D1_COD+(cAliasSD1)->D1_ITEM
			If aScan(aNFsProc,{|x| x[1]+x[2]+x[3]+x[4]+x[5]+x[6]+x[7]==cChave}) == 0
				Aadd(aNFsProc,{(cAliasSD1)->D1_FILIAL,(cAliasSD1)->D1_DOC,(cAliasSD1)->D1_SERIE,(cAliasSD1)->D1_FORNECE,(cAliasSD1)->D1_LOJA,(cAliasSD1)->D1_COD,(cAliasSD1)->D1_ITEM})
			Endif
		Endif
		#IFDEF TOP
			dbSkip()
		#ELSE
			dbSkip(-1)
		#ENDIF
	Enddo
	
	#IFDEF TOP
		dbSelectArea(cAliasSD1)
		dbCloseArea()
	#ELSE
		dbSelectArea(cAliasSD1)
		RetIndex(cAliasSd1)
		FErase(cInd+OrdBagExt())
	#ENDIF

Endif

RestArea(aArea)

Return(aRet)

Static Function RetMonta88(nBrICMS,cSerie,cNF,cFornece,cLoja,cItem,cCod,lUsaSFT)

Local lMonta88	:= .F.

If lUsaSFT 
	SFT->(dbSetOrder(1))
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³O registro devera ser gerado:                                     ³
//³- quando na NF existir ICMS Retido                                ³
//³- quando na NF existir a indicacao de que a operacao faz parte do ³
//³  Regime Especial de ST, onde, mesmo sem ST, o item devera ser    ³
//³  apresentado nos registros 88.                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nBrICMS == 0
	If lUsaSFT
		If SFT->(dbSeek(xFilial("SFT")+"E"+cSerie+cNF+cFornece+cLoja+cItem+cCod))
			If SFT->FT_RGESPST == "1"
				lMonta88 := .T.
			Endif
		Endif	
	Endif
Else 
	lMonta88 := .T.
Endif     

Return lMonta88

Static Function NfCompl(cAliasSD1,nValIcms,nIcmsRet,dUltFec,nRetInd,aNFsProc,lUsaSFT,lRgEspSt)

Local cAlias	:= "SD1"
Local cDoc		:= (cAliasSD1)->D1_DOC
Local cSerie	:= (cAliasSD1)->D1_SERIE
Local cItem		:= (cAliasSD1)->D1_ITEM
Local cChave	:= ""
Local lMonta88	:= .T.

#IFDEF TOP
	Local aStru 	:=	{}
	Local cQuery   	:=	""
	Local nX		:=	0
#ENDIF

Default aNFsProc := {}
#IFDEF TOP
	cAlias	:= "ComplSD1"
	aStru	:= SD1->(dbStruct())
	cQuery	:= "SELECT D1_NFORI,D1_SERIORI,D1_ITEMORI,D1_VALICM,D1_ICMSRET,D1_BRICMS,"
	cQuery	+= "D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_COD,D1_ITEM "
	cQuery	+= "FROM " + RetSqlName("SD1") + " "
	cQuery	+= "WHERE D1_FILIAL = '" + xFilial("SD1") + "' AND "
	cQuery	+= "D1_DTDIGIT < '" + Dtos(dUltFec) + "' AND "		
	If !lRgEspSt
		cQuery	+= "D1_BRICMS > 0 AND "
	Endif
	cQuery	+= "D1_TIPO IN('P','I','C') AND "		
	cQuery	+= "D1_NFORI = '" + cDoc + "' AND "
	cQuery	+= "D1_SERIORI = '" + cSerie + "' AND "	
	cQuery	+= "D1_ITEMORI = '" + cItem + "' AND "
	cQuery	+= "D_E_L_E_T_= ' ' "
	cQuery	:= ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
	For nX := 1 To Len(aStru)
		If ( aStru[nX][2] <> "C" )
			TcSetField(cAlias,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
		EndIf
	Next nX
#ELSE
	dbSelectArea(cAlias)
	dbSetOrder(nRetInd+1)
	dbSeek(cDoc+cSerie+cItem)
#ENDIF

While !Eof() .And. (cAlias)->(D1_NFORI+D1_SERIORI+D1_ITEMORI) == (cDoc+cSerie+cItem)
	lMonta88 := .T.
	If lRgEspSt
		lMonta88 := RetMonta88((cAlias)->D1_BRICMS,(cAlias)->D1_SERIE,;
				(cAlias)->D1_DOC,(cAlias)->D1_FORNECE,(cAlias)->D1_LOJA,;
				(cAlias)->D1_ITEM,(cAlias)->D1_COD,lUsaSFT)
	Endif

	If lMonta88        
		nValIcms	+= (cAlias)->D1_VALICM		//ICMS PROPRIO
		nIcmsRet	+= (cAlias)->D1_ICMSRET		//ICMS ST
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Armazena o item da nota fiscal que foi processado para composicao do estoque de ST³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cChave := (cAlias)->D1_FILIAL+(cAlias)->D1_DOC+(cAlias)->D1_SERIE+(cAlias)->D1_FORNECE+(cAlias)->D1_LOJA+(cAlias)->D1_COD+(cAlias)->D1_ITEM
		If aScan(aNFsProc,{|x| x[1]+x[2]+x[3]+x[4]+x[5]+x[6]+x[7]==cChave}) == 0
			Aadd(aNFsProc,{(cAlias)->D1_FILIAL,(cAlias)->D1_DOC,(cAlias)->D1_SERIE,(cAlias)->D1_FORNECE,(cAlias)->D1_LOJA,(cAlias)->D1_COD,(cAlias)->D1_ITEM})
		Endif
	Endif
	dbSelectArea(cAlias)
	dbSkip()
Enddo

#IFDEF TOP
	dbSelectArea(cAlias)
	dbCloseArea()
#ENDIF

Return Nil

Static Function RetCmpDel (cLinhaTxt, cDelimitador, nCmpDel)
Local	nX		:=	0
Local	nDel	:=	0
Local	cCampo	:=	""
//
For nX := 1 To Len (cLinhaTxt)
	cCampo	+=	SubStr (cLinhaTxt, nX, 1)
	If (cDelimitador$cCampo) .Or. (CHR (13)$cCampo)
		nDel++
		If (nDel==nCmpDel)
			cCampo:= substr(cCampo,1,len(cCampo)-1)
			Exit
		Else
			cCampo	:=	""
		EndIf
	EndIf
Next nX
Return (cCampo)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |TrbConso  ºAutor  ³Gustavo             º Data ³  05/09/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Crio TRB conforme estrutura do registro contida no INI.     º±±
±±º          ³Esta rotina eh somente utilizado para inis que possuem a    º±±
±±º          ³ clausula (CONSOLIDADO), para que seja processado o bloco   º±±
±±º          ³ para o range de filiais apontado nesta clausula.           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function TrbConso (nNewDel, nNivel, aStru, cChaveCons, aArqNew)
Local	lRet		:=	.T.
Local	nX			:=	0
Local	aStruXZ		:=	{}
Local	cChave		:=	""
Local	cCampo		:=	""
Local	cTipo		:=	""
Local	nTamanho	:=	0
Local	nDecimal	:=	0
Local	cNomeTrb	:=	""
//
If (nNewDel==1)
	cNomeTrb	:=	"XZ"+StrZero (nNivel, 1, 0)
	//
	For nX := 1 To Len (aStru[nNivel])
		cCampo		:=	AllTrim (aStru[nNivel][nX][1])
		cTipo		:=	AllTrim (aStru[nNivel][nX][2])
		nTamanho	:=	aStru[nNivel][nX][3]
		nDecimal	:=	aStru[nNivel][nX][4]
		aAdd (aStruXZ, {cCampo, cTipo, nTamanho, nDecimal})
		//
		If (AllTrim (cCampo)$cChaveCons)
			If ("N"$cTipo)
				cChave	+=	"StrZero ("+cCampo+","+StrZero (nTamanho, 3, 0)+","+StrZero (nDecimal, 2, 0)+")+"

			ElseIf ("C"$cTipo)
				cChave	+=	cCampo+"+"

			ElseIf ("D"$cTipo)
				cChave	+=	"DTOS ("+cCampo+")+"
			EndIf
		EndIf
	Next nX
	cChave	:=	Left (cChave, Len (cChave)-1)	//Tiro o mais do final
	//
	cArq	:=	CriaTrab (aStruXZ)
	DbUseArea (.T., __LocalDriver, cArq, cNomeTrb)
	IndRegua (cNomeTrb, cArq, cChave,,,Nil,.F.)
	//
	aArqNew	:=	{cNomeTrb, cArq}
Else
	dbSelectArea(aArqNew[1])
	dbCloseArea()
	Ferase(aArqNew[2]+GetDBExtension())
	Ferase(aArqNew[2]+OrdBagExt())
	//
	aArqNew	:=	{}
EndIf
Return (lRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |ConsoFil  ºAutor  ³Gustavo             º Data ³  05/09/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Alimento o TRB gerado pela funcao TrbConso acumulando con-  º±±
±±º          ³ a chave apontada na clausula (CONSOLIDADO).                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ConsoFil (aArqNew, cChaveCons, nNivel, aStru, aConteudo, cCmpGrvCon)
Local	lRet	:=	.T.
Local	nCntFor		:=	0
Local	uConteudo
Local	cString		:=	""
Local	aGrava		:=	{}
Local	aAcumula	:=	{}
Local	cChave		:=	""

For nCntFor := 1 To Len (aStru[nNivel])
	uConteudo 	:= 	&(aConteudo[nNivel][nCntFor])
	cCampo		:=	AllTrim (aStru[nNivel][nCntFor][1])
	cTipo		:=	aStru[nNivel][nCntFor][2]
	//
	Do Case
	Case (cTipo == "N")
		If ( uConteudo == Nil )
			uConteudo := 0
		EndIf
		cString	:=	Str (uConteudo, aStru[nNivel][nCntFor][3], aStru[nNivel][nCntFor][4])

	Case (aStru[1][nCntFor][2]=="D")
		If (uConteudo==Nil)
			uConteudo := dDataBase
		EndIf
		cString	:=	PadR (Dtos (uConteudo), aStru[nNivel][nCntFor][3])

	Case (cTipo=="C")
		If (uConteudo==Nil)
			uConteudo := ""
		EndIf
		cString := PadR (uConteudo, aStru[nNivel][nCntFor][3])

	EndCase
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifico se o conteudo (cString) faz parte da chave de pesquisa pelo indice criado no TRB³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (cCampo$cChaveCons)
		cChave	+=	cString
		aAdd (aGrava, {cCampo, uConteudo})
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifico se o conteudo mesmo nao fazendo parte do indice deve ser gravado no Reclock(.T.)³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ElseIf (cCampo$cCmpGrvCon)
		aAdd (aGrava, {cCampo, uConteudo})
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Gravo os Reclock (.F.), acumuladores de valores³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Else
		aAdd (aAcumula, {cCampo, uConteudo})
	EndIf
Next nCntFor
//
DbSelectArea (aArqNew[1])
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Faco a inclusao no TRB conforme chave³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !(aArqNew[1])->(DbSeek(cChave))
	RecLock (aArqNew[1], .T.)
	For nCntFor := 1 To Len (aGrava)
		(aArqNew[1])->(FieldPut (&(aArqNew[1]+"->(FieldPos('"+aGrava[nCntFor][1]+"'))"), aGrava[nCntFor][2]))
	Next nCntFor
Else
	RecLock (aArqNew[1], .F.)
EndIf
For nCntFor := 1 To Len (aAcumula)
	(aArqNew[1])->&(aAcumula[nCntFor][1])	+=	aAcumula[nCntFor][2]
Next nCntFor
MsUnLock ()
Return (lRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |GeroConso ºAutor  ³Gustavo             º Data ³  05/09/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Faco While no TRB criado e alimentado que servira de base   º±±
±±º          ³ para a gravacao da funcao GrvBuffer com o TRB ja consolidadoº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³nHandle -> Handle do txt para gravacao.                     º±±
±±º          ³aDelimit -> Flags para a inclusao dos delimitadores         º±±
±±º          ³aStru -> Estrutura do arquivo TRB criado.                   º±±
±±º          ³aArqNew -> Alias e Nome Fisico do TRB criado.               º±±
±±º          ³aAlias -> Alias apontado no INI para o bloco (SOMENTE UTI-  º±±
±±º          ³ LIZADO PARA MOSTRAR O HELP NA TELA, POIS OS VALORES JA ESTAOº±±
±±º          ³ ACUMULADOS NO TRB CRIADO)                                  º±±
±±º          ³aConteudo -> Conteudo apontado no INI para o bloco (SOMENTE º±±
±±º          ³ UTILIZADO PARA MOSTRAR O HELP NA TELA, POIS OS VALORES JA  º±±
±±º          ³ ESTAO ACUMULADOS NO TRB CRIADO)                            º±±
±±º          ³aPosReg -> Conteudo apontado no INI para a clausula (POSREG)º±±
±±º          ³aContReg -> Conteudo apontado no INI para a clausula (CONT) º±±
±±º          ³cMaskVlr -> Mascara padrao para os campos valores apontado  º±±
±±º          ³ no INI atraves da clausula (MASKVLR)                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GeroConso (nHAndle, aDelimit, aStru, aArqNew, aAlias, aConteudo, aPosReg, aContReg, cMaskVlr)
Local	lRet	:=	.T.
//
DbSelectArea (aArqNew[1])
(aArqNew[1])->(DbGoTop ())
//
While !(aArqNew[1])->(Eof ())
	//
	GrvBuffer (nHAndle, aDelimit, aStru, aArqNew, aAlias, aConteudo, aPosReg, aContReg, cMaskVlr)
	//
	(aArqNew[1])->(DbSkip ())
EndDo
Return (lRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |GeroConso ºAutor  ³Gustavo             º Data ³  05/09/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gravacao do registro do TRB no meio-magnético               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³nHandle -> Handle do txt para gravacao.                     º±±
±±º          ³aDelimit -> Flags para a inclusao dos delimitadores         º±±
±±º          ³aStru -> Estrutura do arquivo TRB criado.                   º±±
±±º          ³aArqNew -> Alias e Nome Fisico do TRB criado.               º±±
±±º          ³aAlias -> Alias apontado no INI para o bloco (SOMENTE UTI-  º±±
±±º          ³ LIZADO PARA MOSTRAR O HELP NA TELA, POIS OS VALORES JA ESTAOº±±
±±º          ³ ACUMULADOS NO TRB CRIADO)                                  º±±
±±º          ³aConteudo -> Conteudo apontado no INI para o bloco (SOMENTE º±±
±±º          ³ UTILIZADO PARA MOSTRAR O HELP NA TELA, POIS OS VALORES JA  º±±
±±º          ³ ESTAO ACUMULADOS NO TRB CRIADO)                            º±±
±±º          ³aPosReg -> Conteudo apontado no INI para a clausula (POSREG)º±±
±±º          ³aContReg -> Conteudo apontado no INI para a clausula (CONT) º±±
±±º          ³cMaskVlr -> Mascara padrao para os campos valores apontado  º±±
±±º          ³ no INI atraves da clausula (MASKVLR)                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GrvBuffer (nHAndle, aDelimit, aStru, aArqNew, aAlias, aConteudo, aPosReg, aContReg, cMaskVlr)
Local	cBuffer		:=	""
Local	nCntFor		:=	0
Local	cDelimit	:=	AllTrim (aDelimit[1])
//
If (Len (cDelimit)>1)
	If ("I"$SubStr (cDelimit, 2))
		cBuffer	+=	SubStr (cDelimit, 1, 1)
	EndIf
EndIf
//
For nCntFor := 1 To Len(aStru[1])
	cTipo		:=	ValType ((aArqNew[1])->&(aStru[1][nCntFor][1]))
	//
	bError := ErrorBlock({|e| Help(" ",1,"NORMAERRO3",,aAlias[1]+"->"+aStru[1][nCntFor][1]+"|"+aConteudo[1][nCntFor],3,1) })
	//
	BEGIN SEQUENCE
		uConteudo := (aArqNew[1])->&(aStru[1][nCntFor][1])
		Do Case
		Case (aStru[1][nCntFor][2]=="N")
			If ( uConteudo == Nil )
				uConteudo := 0
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ`¿
			//³Quando possuir mascara apontada no INI, utilizo-a no transform para gravacao no TXT.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ`Ù
			If Empty (cMaskVlr) .Or. (aStru[1][nCntFor][4])==0
				uConteudo := NoRound (uConteudo*(10**(aStru[1][nCntFor][4])), aStru[1][nCntFor][4])

				If (!Empty (aDelimit[1]))
					cBuffer += Iif (Empty (AllTrim (Str (uConteudo,aStru[1][nCntFor][3]))), "", AllTrim (Str (uConteudo,aStru[1][nCntFor][3])))
				Else
					cBuffer += StrZero (uConteudo, aStru[1][nCntFor][3])
				EndIf
			Else
				cBuffer += AllTrim (Transform (uConteudo, cMaskVlr))
			EndIf

		Case (aStru[1][nCntFor][2]=="D")
			If (uConteudo==Nil)
				uConteudo := dDataBase
			EndIf
			cBuffer += PadR (Dtos (uConteudo), aStru[1][nCntFor][3])
		Case (aStru[1][nCntFor][2]=="C")
			If ( uConteudo == Nil )
				uConteudo := ""
			EndIf

			If (!Empty (aDelimit[1]))
				cBuffer += AllTrim (uConteudo)
			Else
				cBuffer += PadR (uConteudo, aStru[1][nCntFor][3])
			EndIf
		EndCase
	END SEQUENCE

	ErrorBlock(bError)

	If (Len (cDelimit)>1)
		If (nCntFor==Len (aStru[1]))
			If ("F"$SubStr (cDelimit, 2))
				cBuffer	+=	SubStr (cDelimit, 1, 1)
			EndIf
		Else
			If ("M"$SubStr (cDelimit, 2))
				cBuffer	+=	SubStr (cDelimit, 1, 1)
			EndIf
		EndIf
	EndIf

Next nCntFor
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Efetua a Gravacao da Linha                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(cBuffer)
	FWrite(nHAndle,cBuffer+Chr(13)+Chr(10))
	If ( Ferror()!=0 )
		Help(" ",1,"NORMAERRO4")
	EndIf
EndIf
aEval(aPosReg[1],{|x| &(x) })
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Incrementa o contador  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aEval(aContReg[1],{|x| &(x) })
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FsGrvTmp  ³ Autor ³Eduardo Riera          ³ Data ³07.09.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de conversao de Array para arquivo temporario        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Alias do arquivo temporario                          ³±±
±±³          ³ExpA2: Array com a seguinte estrutura                       ³±±
±±³          ³       [1] Registro                                         ³±±
±±³          ³       [1][n] Campos do arquivo                             ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function HcGrvTmp(cAlias,aArray)

Local aArea := GetArea()
Local nX    := 0
Local nY    := 0

dbSelectArea(cAlias)

For nX := 1 To Len(aArray)
	RecLock(cAlias,.T.)
	For nY := 1 To Len(aArray[nX])
		FieldPut(nY,aArray[nX][nY])
	Next nY
	MsUnLock()	
Next nX

RestArea(aArea)
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FsDateConv³ Autor ³Eduardo Riera          ³ Data ³20.10.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de conversao de data para string em varios formatos  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpC1: String                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpD1: Alias do arquivo temporario                          ³±±
±±³          ³ExpC2: Formato onde:                                        ³±±
±±³          ³       DD = Dia                                             ³±±
±±³          ³       MM = Mes                                             ³±±
±±³          ³       YYYY ou YY = Ano                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function HcDateConv(dData,cMasc)

Local cDia    := ""
Local cMes    := ""
Local cAno    := ""
Local cData   := Dtos(dData)
Local cResult := ""
Local cAux    := ""

DEFAULT cMasc := "DDMMYYYY"

cDia := SubStr(cData,7,2)
cMes := SubStr(cData,5,2)
cAno := SubStr(cData,1,4)

While !Empty(cMasc)
	cAux := SubStr(cMasc,1,2)
	Do Case
		Case cAux == "DD"
			cResult += cDia
		Case cAux == "MM"
			cResult += cMes
		Case cAux == "YY"
			If SubStr(cMasc,1,4) == "YYYY"
				cResult += cAno
				cMasc := SubStr(cMasc,3)
			Else
				cResult += SubStr(cAno,3)
			EndIf			
	EndCase
	cMasc := SubStr(cMasc,3)
EndDo
Return(cResult)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FsLoadTxt ³ Autor ³Eduardo Riera          ³ Data ³24.10.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de leitura de arquivo texto para anexar ao layout    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExC1: Arquivo texto                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: Nome do arquivo texto com path                       ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function HcLoadTXT(cFileImp)

Local cTexto     := ""
Local cNewFile   := ""
Local cExt       := "" 
Local cStartPath := GetSrvProfString("StartPath","")
cStartPath := StrTran(cStartPath,"/","\")
cStartPath +=If(Right(cStartPath,1)=="\","","\")

CpyT2S(cFileImp,cStartPath)
SplitPath(cFileImp,/*cDrive*/,/*cPath*/, @cNewFile,cExt)
cNewFile := cNewFile+cExt

FT_FUse(cNewFile)
FT_FGotop()
While ( !FT_FEof() )
	cTexto += FT_FREADLN()
	FT_FSkip()
EndDo
FT_FUse()
Return(cTexto)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³RetNf 	³ Autor ³Andressa Fagundes      ³ Data ³19.12.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Funcao para retornar a quantidade de caracteres de acordo   ³±±
±±³          ³com o layout especificado(Usado para numero da Nota Fiscal) ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExC1: Arquivo texto                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cCampo: Nome do campo            				    	      ³±±
±±³          ³nDig:	Qtd de digitos de acordo com o layout 		          ³±±
±±³          ³cTipo: Tipo Caracter(C) ou Numerico(N) conforme layout      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/ 
User Function HcRetNf(cCampo,nDig,cTipo)

Local 	cRet	:=	""

Default nDig	:= TamSX3("F2_DOC")[1]
Default cCampo	:= ""
Default cTipo	:= ""

If cTipo = "N"
	cRet	:= Right(Replicate("0",nDig-Len(Alltrim(cCampo)))+Alltrim(cCampo),nDig)
Else
	cRet	:= Right(Alltrim(cCampo),nDig) //usar nos casos que o tamanho e menor que 9
Endif	

Return (cRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³MontaXML 	³ Autor ³Mary C. Hergert        ³ Data ³03/05/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Funcao para retornar a linha em formato XML (tags)          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpC1 : linha em xml                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1 : Tag a ser apresentada   				    	      ³±±
±±³          ³ExpC2 : Campo a ser apresentado na Tag (conteudo)           ³±±
±±³          ³ExpC3 : Tipo do campo                                       ³±±
±±³          ³ExpN4 : Tamanho do campo                                    ³±±
±±³          ³ExpN5 : Decimais do campo                                   ³±±
±±³          ³ExpC6 : Mascara do campo                                    ³±±
±±³          ³ExpN7 : Deslocamento inicial da tag (identacao)             ³±±
±±³          ³ExpL8 : Se apresenta a Tag inicial <>                       ³±±
±±³          ³ExpL9 : Se apresenta a Tag final </>                        ³±±
±±³          ³ExpLA : Se inclui a quebra de linha chr(13) + chr(10)       ³±±
±±³          ³ExpLB : Atributo de TAG                                     ³±±
±±³          ³ExpLC : Se apresenta Tag caracter com acentos               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/ 
User Function HcMoXML(cTag,cCampo,cTipo,nTam,nDec,cMask,nDesloc,lTagIn,lTagFim,lQuebra,cAtrib,lAcento)

Local cXML 		:= ""
Local cAuxCampo := ""
Local cAuxTam	:= ""
Local cAuxDec	:= ""
Local cDesloc	:= ""
Local cTagIni	:= ""
Local cTagFim	:= "" 

Default cTipo	:= "C"
Default nTam	:= 0
Default	nDec	:= 0   
Default	cMask	:= ""
Default nDesloc	:= 0
Default	lTagIn	:= .T.
Default	lTagFim	:= .T.
Default	lQuebra	:= .T.
Default cCampo	:= ""
Default	cAtrib	:= ""
Default lAcento	:=	.F.

cAuxTam	:= Replicate("9",nTam)
cAuxDec	:= Replicate("9",nDec)
cDesloc	:= Space(nDesloc)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta as tags³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lTagIn
	cTagIni	:= "<" + Alltrim(cTag)
	If !Empty(cAtrib)
		cTagIni	+= " " + Alltrim(cAtrib)
	EndIf
	cTagIni	+= ">"
Endif                                   
If lTagFim                           
	cTagFim	:= "</" + Alltrim(cTag) + ">"
Endif                                       

cAuxCampo := Alltrim(cCampo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Remove os acentos das strings³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cTipo == "C" .And. !lAcento 
	cAuxCampo := Alltrim(Upper(NoAcento(AnsiToOem(AllTrim(cAuxCampo)))))
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta a mascara passada como parametro ou mascara padrao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(cMask)
	cAuxCampo := Transform(cCampo,cMask)
Else
	If cTipo == "N"                      
		cAuxCampo := Transform(cCampo,"@E"+cAuxTam+"."+cAuxDec)
	Endif
	If cTipo == "D"
		cAuxCampo := dToS(cCampo)
	Endif
Endif
        
cAuxCampo := Alltrim(cAuxCampo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta a linha XML: deslocamento inicial da linha + Tag Inicial + campo a ser apresentado + Tag Final³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cXML := cDesloc + cTagIni + cAuxCampo + cTagFim

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Insere o <enter> para quebrar linha³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lQuebra 
	cXML  	:= cXML + Chr(13) + Chr(10)
Endif

Return cXML            

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³FormDate  ºAutor  ³                    º Data ³  31/05/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Converte data no formato dd/mm/aaaa                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³MATA950                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function HcFmDate(dData)

Return StrZero(Day(dData),2)+ "/" + StrZero(Month(dData),2)+ "/" + StrZero(Year(dData),4)  

