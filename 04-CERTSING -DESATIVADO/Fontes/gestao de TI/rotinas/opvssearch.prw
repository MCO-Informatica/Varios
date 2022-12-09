#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     �Autor  �Microsiga           � Data �  09/13/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function OpvsSearch(cAlias, nReg, nOpc, aAlias)

Local oDlg, oFolder, oChave, oFAlias1, oFAlias2, oMsGetD
Local nWidth	:= (oMainWnd:nClientWidth * .99) * .8
Local nHeight	:= (oMainWnd:nClientHeight * .95) * .85
Local aLbx		:= {}
Local aLbxCfg	:= {}
Local aLbxAll	:= {}
Local cChave	:= Space(256)
Local oOk		:= LoaDbitmap(GetResources(),"LBOK")
Local oNo		:= LoaDbitmap(GetResources(),"LBNO")
Local nI		:= 0
Local nJ		:= 0
Local nUsado	:= 0
Local aGetDAll	:= {}
Local aHeader	:= {}
Local aCols		:= {}
Local aTotHead	:= {}
Local aTotCols	:= {}
Local aRecord	:= {}
Local aItems	:= {}
Local aLbxObj	:= {}
Local nSX9		:= 0
Local lSX3		:= .T.

DEFINE FONT oFonte NAME "Courier New" SIZE 0,14 BOLD

If nWidth < 800
	nWidth := 800
Endif

If nHeight < 500
	nHeight := 500
Endif

If Empty(cAlias)
	MsgStop("Alias n�o definido")
	Return(0)
Endif

If aAlias[1] <> cAlias
	MsgStop("Alias enviado de forma incorreta nos par�metros...")
	Return(0)
Endif

For nI := 2 To Len(aAlias)
	SX9->( DbSetOrder(1) )
	SX9->( MsSeek( cAlias ) )
	While SX9->( !Eof() ) .AND. SX9->X9_DOM == cAlias
		If SX9->X9_CDOM == aAlias[nI]
			nSX9++
			Exit
		Endif
		SX9->( DbSkip() )
	End
Next nI

If Len(aAlias)-1 <> nSX9
	MsgStop("Alias enviado nos par�metros n�o possui amarra��o no SX9...")
	Return(0)
Endif
	
For nI := 2 To Len(aAlias)
	SX3->( DbSetOrder(1) )
	SX3->( MsSeek( aAlias[nI] ) )
	lSX3 := .F.
	While SX3->X3_ARQUIVO == aAlias[nI]
		If !X3USO(SX3->X3_USADO) .OR. SX3->X3_CONTEXT == "V" .OR. cNivel < SX3->X3_NIVEL .OR. SX3->X3_TIPO <> "C" .OR. !Empty(SX3->X3_CBOX)
			SX3->( DbSkip() )
			Loop
		Endif
		If SX3->X3_IDXFLD == "S"
			lSX3 := .T.
			Exit
		Endif
		SX3->( DbSkip() )
	End
	If !lSX3
		MsgStop("Alias "+aAlias[nI]+" enviado nos par�metros n�o possui indica��o de pesquisa no SX3...")
		Return(0)
	Endif
Next nI

DEFINE DIALOG oDlg TITLE cCadastro SIZE nWidth, nHeight PIXEL

@ 000,000 FOLDER oFolder ITEMS "Pesquisa", "Op��es" OF oDlg SIZE (nWidth/2)+2,(nHeight/2) PIXEL



//������������������������������������������������������Ŀ
//�Objetos do segundo folder.                            �
//��������������������������������������������������������
@ 005,005 TO 030,(nWidth/2)-5 LABEL "Pesquisa avan�ada OPVS" OF oFolder:aDialogs[2] PIXEL

@ 013,010 SAY "Os campos marcados ser�o utilizados para pesquisa o conte�do no banco de dados." OF oFolder:aDialogs[2] PIXEL FONT oFonte
@ 021,010 SAY "Para marcar e desmarcar os campos utilize um duplo click ou utilize os bot�es abaixo." OF oFolder:aDialogs[2] PIXEL FONT oFonte

SX2->( DbSetOrder(1) )
For nI := 1 to Len(aAlias)
	SX2->( MsSeek( aAlias[nI] ) )
	Aadd( aItems, AllTrim(SX2->X2_NOME) )
Next nI
oFAlias2 := TFolder():New( 040, 005, aItems, aAlias, oFolder:aDialogs[2], Nil, Nil, Nil, .T., .T., (nWidth/2)-10, (nHeight/2)-80, "" )

For nI := 1 to Len(aAlias)
	SX3->( DbSetOrder(1) )
	SX3->( MsSeek( aAlias[nI] ) )
	While SX3->X3_ARQUIVO == aAlias[nI]
		If !X3USO(SX3->X3_USADO) .OR. SX3->X3_CONTEXT == "V" .OR. cNivel < SX3->X3_NIVEL .OR. SX3->X3_TIPO <> "C" .OR. !Empty(SX3->X3_CBOX)
			SX3->( DbSkip() )
			Loop
		Endif
		Aadd( aLbxCfg, {	SX3->X3_IDXFLD,;
							SX3->X3_CAMPO,;
							SX3->X3_TITULO,;
							SX3->X3_DESCRIC,;
							SX3->X3_ORDEM,;
							SX3->X3_TIPO,;
							SX3->X3_TAMANHO,;
							SX3->X3_DECIMAL,;
							SX3->X3_PICTURE;
						} )
		SX3->( DbSkip() )
	End
	If Len(aLbxCfg) == 0
		MsgStop("Campos n�o definidos para o alias "+aAlias[nI])
		Return(0)
	Endif
	
	Aadd( aLbxAll, {} )
	aLbxAll[nI] := Aclone(aLbxCfg)
	aLbxCfg := {}
	
	Aadd( aLbxObj, Nil )
	@ 000,000 LISTBOX aLbxObj[nI] FIELDS HEADER "", "Campo", "Titulo", "Descri��o", "Ordem", "Tipo", "Tamanho", "Decimal", "Mascara" SIZE (nWidth/2)-12,(nHeight/2)-93 OF oFAlias2:aDialogs[nI] PIXEL
	
	aLbxObj[nI]:SetArray(aLbxAll[nI])
	aLbxObj[nI]:bLine := {||{	IIF(aLbxAll[nI][aLbxObj[nI]:nAt][1]=="S",oOk,oNo),;
								aLbxAll[nI][aLbxObj[nI]:nAt][2],;
								aLbxAll[nI][aLbxObj[nI]:nAt][3],;
								aLbxAll[nI][aLbxObj[nI]:nAt][4],;
								aLbxAll[nI][aLbxObj[nI]:nAt][5],;
								aLbxAll[nI][aLbxObj[nI]:nAt][6],;
								aLbxAll[nI][aLbxObj[nI]:nAt][7],;
								aLbxAll[nI][aLbxObj[nI]:nAt][8],;
								aLbxAll[nI][aLbxObj[nI]:nAt][9];
								}}
	aLbxObj[nI]:blDblClick := { || MarcaCpo("CLICK",@aLbxObj[oFAlias2:nOption]) }
	aLbxObj[nI]:bChange := { || OPVSMuda(@aLbxObj[oFAlias2:nOption]) }
Next nI
oFAlias2:nOption := 1

@ (nHeight/2)-30, (nWidth/2)-240 BUTTON "(Des)marca Tudo" SIZE 50,10 OF oFolder:aDialogs[2] PIXEL ACTION MarcaCpo("DMALL",@aLbxObj[oFAlias2:nOption])

@ (nHeight/2)-30, (nWidth/2)-180 BUTTON "Inverte Sele��o" SIZE 50,10 OF oFolder:aDialogs[2] PIXEL ACTION MarcaCpo("INVSE",@aLbxObj[oFAlias2:nOption])

@ (nHeight/2)-30, (nWidth/2)-120 BUTTON "Aplicar" SIZE 50,10 OF oFolder:aDialogs[2] PIXEL ACTION ApplyCpo(oFAlias2:nOption, aLbxObj, @aGetDAll, aAlias, @aTotHead, @aTotCols, @oFAlias1, @oFolder)

@ (nHeight/2)-30, (nWidth/2)-060 BUTTON "Cancela" SIZE 50,10 OF oFolder:aDialogs[2] PIXEL ACTION ((cAlias)->(DbGoTo(nReg)),oDlg:End())




//������������������������������������������������������Ŀ
//�Objetos do primeiro folder.                           �
//��������������������������������������������������������
@ 005,005 TO 030,(nWidth/2)-5 LABEL "Pesquisa avan�ada OPVS" OF oFolder:aDialogs[1] PIXEL

@ 017,010 SAY "Chave de pesquisa" OF oFolder:aDialogs[1] PIXEL FONT oFonte
@ 015,080 MSGET oChave VAR cChave OF oFolder:aDialogs[1] SIZE (nWidth/2)-90,5 PIXEL FONT oFonte VALID SearchData(aLbxObj,@aGetDAll,cChave,@aRecord,aAlias)

oFAlias1 := TFolder():New( 040, 005, aItems, aAlias, oFolder:aDialogs[1], Nil, Nil, Nil, .T., .T., (nWidth/2)-10, (nHeight/2)-80, "" )

For nJ := 1 To Len(aAlias)
	
	aLbxCfg := Aclone( aLbxAll[nJ] )
	
	SX3->( DbSetOrder(2) )
	For nI := 1 To Len(aLbxCfg)
		If aLbxCfg[nI][1] == "S" .AND. SX3->( MsSeek( aLbxCfg[nI][2] ) )
			Aadd(aHeader, {	SX3->X3_TITULO,;
							SX3->X3_CAMPO,;
							SX3->X3_PICTURE,;
							SX3->X3_TAMANHO,;
							SX3->X3_DECIMAL,;
							SX3->X3_VALID,;
							SX3->X3_USADO,;
							SX3->X3_TIPO,;
							SX3->X3_F3,;
							SX3->X3_CONTEXT } )
			nUsado++
		Endif
	Next nI
	
	DbSelectArea(cAlias)
	Aadd(aCols,Array(nUsado+1))
	For nI := 1 To nUsado
		aCols[Len(aCols)][nI] := CriaVar(aHeader[nI][2],.F.)
	Next nI
	aCols[Len(aCols)][nUsado+1] := .F.
	
	Aadd( aTotHead, Aclone(aHeader) )
	Aadd( aTotCols, Aclone(aCols) )
	
	Aadd( aGetDAll, Nil )
	aGetDAll[nJ] := MsNewGetDados():New(000,000,(nHeight/2)-92,(nWidth/2)-11,,,,,,,4096,,,,oFAlias1:aDialogs[nJ],aTotHead[nJ],aTotCols[nJ])
	
	aHeader	:= {}
	aCols	:= {}
	nUsado	:= 0
	
Next nJ

aGetDAll[1]:bChange := { || ChangeData(aAlias,@aGetDAll,aRecord) }	
oMsGetD := aGetDAll[1]
aHeader	:= Aclone( aTotHead[1] )
aCols	:= Aclone( aTotCols[1] )
nI		:= 1
oFAlias1:nOption := 1

@ (nHeight/2)-30, (nWidth/2)-180 BUTTON "OK" SIZE 50,10 OF oFolder:aDialogs[1] PIXEL ACTION IIF(Len(aRecord)>0,((cAlias)->(DbGoTo(aRecord[oMsGetD:nAt])),nReg:=(cAlias)->(Recno()),oDlg:End()),((cAlias)->(DbGoTo(nReg)),oDlg:End()))

@ (nHeight/2)-30, (nWidth/2)-120 BUTTON "Visualiza" SIZE 50,10 OF oFolder:aDialogs[1] PIXEL ACTION IIF(Len(aRecord)>0,((cAlias)->(DbGoTo(aRecord[oMsGetD:nAt])),(cAlias)->( AxVisual(cAlias,aRecord[oMsGetD:nAt],2) )),AllWaysTrue())

@ (nHeight/2)-30, (nWidth/2)-060 BUTTON "Cancela" SIZE 50,10 OF oFolder:aDialogs[1] PIXEL ACTION ((cAlias)->(DbGoTo(nReg)),oDlg:End())

ACTIVATE DIALOG oDlg CENTERED ON INIT OPVSRefresh(Len(aAlias),@aLbxObj)

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �OPVSSEARCH�Autor  �Microsiga           � Data �  10/27/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ChangeData(aAlias,aGetDAll,aRecord)

Local nI		:= 0
Local aHeader	:= {}
Local aCols		:= {}
Local cAlias	:= aAlias[1]
Local cPrefixo	:= IIF(SubStr(cAlias,1,1)=="S",SubStr(cAlias,2),cAlias)
Local cQuery	:=	""
Local cAlias2	:= ""
Local cPrefixo2	:= ""
Local cWhere	:= ""
Local cCampo	:= ""

For nI := 2 to Len(aAlias)
	
	aHeader		:= Aclone( aGetDAll[nI]:aHeader )
	aCols		:= {}
	nUsado		:= Len(aHeader)
	cAlias2		:= aAlias[nI]
	cPrefixo2	:= IIF(SubStr(cAlias2,1,1)=="S",SubStr(cAlias2,2),cAlias2)
	cWhere		:= ""
		
	If aGetDAll[nI]:nAt <= Len(aRecord)
		
		(cAlias)->( DbGoTo( aRecord[aGetDAll[1]:nAt] ) )
		
		SX9->( DbSetOrder(1) )
		SX9->( MsSeek( cAlias ) )
		While SX9->( !Eof() ) .AND. SX9->X9_DOM == cAlias
			
			If SX9->X9_CDOM == cAlias2
				cWhere	:=	AllTrim(SX9->X9_EXPCDOM) + " = '" + &(cAlias+"->("+SX9->X9_EXPDOM+")") + "' AND " +;
							AllTrim(SX9->X9_EXPCDOM) + " = " + AllTrim(SX9->X9_EXPDOM) + " AND "
				Exit
			Endif
			
			SX9->( DbSkip() )
		End
		
		If !Empty(cWhere)
			
			cQuery	:=	" SELECT  DISTINCT " + RetSqlName(cAlias2) + ".R_E_C_N_O_ " +;
						" FROM    " + RetSqlName(cAlias) + ", " + RetSqlName(cAlias2) +;
						" WHERE   " + cPrefixo + "_FILIAL = '" + xFilial(cAlias) + "' AND " +;
						"         " + cPrefixo2 + "_FILIAL = '" + xFilial(cAlias2) + "' AND "
			cQuery	+=	cWhere
			cQuery	+=	RetSqlName(cAlias) + ".D_E_L_E_T_ = ' ' AND " +;
						RetSqlName(cAlias2) + ".D_E_L_E_T_ = ' ' "
			
			PLSQuery( cQuery, "ALIASTMP" )
			
			While ALIASTMP->( !Eof() )
				
				(cAlias2)->( DbGoTo(ALIASTMP->R_E_C_N_O_) )
				
				Aadd(aCols,Array(nUsado+1))
				For nJ := 1 To nUsado
					cCampo := aHeader[nJ][2]
					aCols[Len(aCols)][nJ] := &(cAlias2+"->"+cCampo)
				Next nJ
				aCols[Len(aCols)][nUsado+1] := .F.
				
				ALIASTMP->( DbSkip() )
			End
			ALIASTMP->( DbCloseArea() )
			
		Endif
	Endif
	
	If Len(aCols) == 0
		Aadd(aCols,Array(nUsado+1))
		For nJ := 1 To nUsado
			aCols[Len(aCols)][nJ] := Criavar(aHeader[nJ][2],.F.)
		Next nJ
		aCols[Len(aCols)][nUsado+1] := .F.
	Endif
	
	aGetDAll[nI]:aCols := Aclone(aCols)
	aGetDAll[nI]:ForceRefresh()
	
Next nI

Return(.T.)



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �OPVSSEARCH�Autor  �Microsiga           � Data �  10/25/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function OPVSRefresh(nAlias,aLbxObj)

Local nI	:= 0
Local nJ	:= 0

For nI := 1 To nAlias
	For nJ := 1 To 2
		MarcaCpo("CLICK",@aLbxObj[nI])
	Next nJ
Next nI

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �OPVSSEARCH�Autor  �Microsiga           � Data �  10/25/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function OPVSMuda(oLbxCfg)

Local oOk		:= LoaDbitmap(GetResources(),"LBOK")
Local oNo		:= LoaDbitmap(GetResources(),"LBNO")
Local aLbxCfg	:= Aclone( oLbxCfg:aArray )
	
oLbxCfg:SetArray(aLbxCfg)
oLbxCfg:bLine := {||{	IIF(aLbxCfg[oLbxCfg:nAt][1]=="S",oOk,oNo),;
							aLbxCfg[oLbxCfg:nAt][2],;
							aLbxCfg[oLbxCfg:nAt][3],;
							aLbxCfg[oLbxCfg:nAt][4],;
							aLbxCfg[oLbxCfg:nAt][5],;
							aLbxCfg[oLbxCfg:nAt][6],;
							aLbxCfg[oLbxCfg:nAt][7],;
							aLbxCfg[oLbxCfg:nAt][8],;
							aLbxCfg[oLbxCfg:nAt][9];
							}}
oLbxCfg:Refresh()

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �OPVSSEARCH�Autor  �Microsiga           � Data �  09/14/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MarcaCpo(cTipo,oLbxCfg)

Local aLbxCfg	:= Aclone(oLbxCfg:aArray)
Local oOk		:= LoaDbitmap(GetResources(),"LBOK")
Local oNo		:= LoaDbitmap(GetResources(),"LBNO")
Local nI		:= 0

Do Case
	Case cTipo == "CLICK"
		If aLbxCfg[oLbxCfg:nAt][1] == "S"
			aLbxCfg[oLbxCfg:nAt][1] := "N"
		Else
			aLbxCfg[oLbxCfg:nAt][1] := "S"
		Endif
		
	Case cTipo == "DMALL"
		If aLbxCfg[1][1] == "S"
			For nI := 1 To Len(aLbxCfg)
				aLbxCfg[nI][1] := "N"
		    Next nI
		Else
			For nI := 1 To Len(aLbxCfg)
				aLbxCfg[nI][1] := "S"
		    Next nI
		Endif
	
	Case cTipo == "INVSE"
		For nI := 1 To Len(aLbxCfg)
			If aLbxCfg[nI][1] == "S"
				aLbxCfg[nI][1] := "N"
			Else
				aLbxCfg[nI][1] := "S"
			Endif
	    Next nI

Endcase

oLbxCfg:SetArray(aLbxCfg)
oLbxCfg:bLine := {||{	IIF(aLbxCfg[oLbxCfg:nAt][1]=="S",oOk,oNo),;
						aLbxCfg[oLbxCfg:nAt][2],;
						aLbxCfg[oLbxCfg:nAt][3],;
						aLbxCfg[oLbxCfg:nAt][4],;
						aLbxCfg[oLbxCfg:nAt][5],;
						aLbxCfg[oLbxCfg:nAt][6],;
						aLbxCfg[oLbxCfg:nAt][7],;
						aLbxCfg[oLbxCfg:nAt][8],;
						aLbxCfg[oLbxCfg:nAt][9];
						}}
oLbxCfg:Refresh()

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �OPVSSEARCH�Autor  �Microsiga           � Data �  09/14/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ApplyCpo(nFAlias2, aLbxObj, aGetDAll, aAlias, aTotHead, aTotCols, oFAlias1, oFolder)

Local aLbxCfg	:= Aclone( aLbxObj[nFAlias2]:aArray )
Local aHeader	:= {}
Local aCols		:= {}
Local nUsado	:= 0
Local nWidth	:= (oMainWnd:nClientWidth * .99) * .8
Local nHeight	:= (oMainWnd:nClientHeight * .95) * .85
Local cAlias	:= aAlias[nFAlias2]

If nWidth < 800
	nWidth := 800
Endif

If nHeight < 500
	nHeight := 500
Endif


SX3->( DbSetOrder(2) )
For nI := 1 To Len(aLbxCfg)
	If aLbxCfg[nI][1] == "S" .AND. SX3->( MsSeek( aLbxCfg[nI][2] ) )
		Aadd(aHeader, {	SX3->X3_TITULO,;
						SX3->X3_CAMPO,;
						SX3->X3_PICTURE,;
						SX3->X3_TAMANHO,;
						SX3->X3_DECIMAL,;
						SX3->X3_VALID,;
						SX3->X3_USADO,;
						SX3->X3_TIPO,;
						SX3->X3_F3,;
						SX3->X3_CONTEXT } )
		nUsado++
	Endif
Next nI

DbSelectArea(cAlias)
Aadd(aCols,Array(nUsado+1))
For nI := 1 To nUsado
	aCols[Len(aCols)][nI] := CriaVar(aHeader[nI][2],.F.)
Next nI
aCols[Len(aCols)][nUsado+1] := .F.

aTotHead[nFAlias2] := Aclone( aHeader )
aTotCols[nFAlias2] := Aclone( aCols )

aGetDAll[nFAlias2] := MsNewGetDados():New(000,000,(nHeight/2)-92,(nWidth/2)-11,,,,,,,4096,,,,oFAlias1:aDialogs[nFAlias2],aTotHead[nFAlias2],aTotCols[nFAlias2])

oFAlias1:nOption := nFAlias2
oFAlias1:Refresh()

oFolder:nOption := 1
oFolder:Refresh()

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �OPVSSEARCH�Autor  �Microsiga           � Data �  09/14/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function SearchData(aLbxObj,aGetDAll,cChave,aRecord,aAlias)

Local cAlias	:= aAlias[1]
Local nI		:= 0
Local nJ		:= 0
Local cQuery	:= ""
Local cCampo	:= ""
Local cPrefixo	:= IIF(SubStr(cAlias,1,1)=="S",SubStr(cAlias,2),cAlias)
Local aLbxCfg	:= Aclone( aLbxObj[1]:aArray )
Local aHeader	:= Aclone( aGetDAll[1]:aHeader )
Local aCols		:= {}
Local nUsado	:= Len(aHeader)
Local cFiltro	:= (cAlias)->( DbFilter() )
Local cAlias2	:= ""
Local cPrefixo2	:= ""

If Empty(cChave)
	Return(.T.)
Endif

cFiltro := StrTran(cFiltro,".AND.","AND")
cFiltro := StrTran(cFiltro,".OR.","OR")
aRecord := {}

cQuery	:=	" SELECT  R_E_C_N_O_ " +;
			" FROM    " + RetSqlName(cAlias) +;
			" WHERE   " + cPrefixo + "_FILIAL = '" + xFilial(cAlias) + "' AND ( "

For nJ := 1 To Len(aLbxCfg)
	
	If aLbxCfg[nJ][1] <> "S"
		Loop
	Endif
	
	cCampo := aLbxCfg[nJ][2]
	
	cQuery	+=	cCampo + " LIKE '%" + AllTrim(cChave) + "%' OR "
	
Next nJ

cQuery := PadR(cQuery,Len(cQuery)-3) + " ) AND "

If !Empty(cFiltro)
	cQuery	+=	cFiltro + " AND "
Endif
cQuery	+=	" D_E_L_E_T_ = ' ' "


For nI := 2 To Len(aAlias)
	
	cQuery += CRLF + CRLF + " UNION " + CRLF + CRLF
	
	cAlias2		:= aAlias[nI]
	cPrefixo2	:= IIF(SubStr(cAlias2,1,1)=="S",SubStr(cAlias2,2),cAlias2)
	aLbxCfg		:= Aclone( aLbxObj[nI]:aArray )
	
	cQuery	+=	" SELECT  " + RetSqlName(cAlias) + ".R_E_C_N_O_ " +;
				" FROM    " + RetSqlName(cAlias) + ", " + RetSqlName(cAlias2) +;
				" WHERE   " + cPrefixo + "_FILIAL = '" + xFilial(cAlias) + "' AND " +;
				"         " + cPrefixo2 + "_FILIAL = '" + xFilial(cAlias2) + "' AND ( "
	
	For nJ := 1 To Len(aLbxCfg)
		
		If aLbxCfg[nJ][1] <> "S"
			Loop
		Endif
		
		cCampo := aLbxCfg[nJ][2]
		
		cQuery	+=	cCampo + " LIKE '%" + AllTrim(cChave) + "%' OR "
		
	Next nJ
	
	cQuery := PadR(cQuery,Len(cQuery)-3) + " ) AND "
	
	If !Empty(cFiltro)
		cQuery	+=	cFiltro + " AND "
	Endif
	
	cQuery	+=	RetSqlName(cAlias) + ".D_E_L_E_T_ = ' ' AND " +;
				RetSqlName(cAlias2) + ".D_E_L_E_T_ = ' ' "
	
Next nI

PLSQuery( cQuery, "ALIASTMP" )
While ALIASTMP->( !Eof() )
	
	If Ascan( aRecord, { |x| x==ALIASTMP->R_E_C_N_O_ } ) > 0
		ALIASTMP->( DbSkip() )
		Loop
	Endif
	
	(cAlias)->( DbGoTo(ALIASTMP->R_E_C_N_O_) )
	
	Aadd(aCols,Array(nUsado+1))
	Aadd(aRecord,ALIASTMP->R_E_C_N_O_)
	For nJ := 1 To nUsado
		cCampo := aHeader[nJ][2]
		aCols[Len(aCols)][nJ] := &(cAlias+"->"+cCampo)
	Next nJ
	aCols[Len(aCols)][nUsado+1] := .F.
	
	ALIASTMP->( DbSkip() )
End
ALIASTMP->( DbCloseArea() )

If Len(aCols) == 0
	Aadd(aCols,Array(nUsado+1))
	For nJ := 1 To nUsado
		aCols[Len(aCols)][nJ] := Criavar(aHeader[nJ][2],.F.)
	Next nJ
	aCols[Len(aCols)][nUsado+1] := .F.
Endif

aGetDAll[1]:aCols := Aclone(aCols)
aGetDAll[1]:ForceRefresh()

ChangeData(aAlias,@aGetDAll,aRecord)

Return(.T.)
