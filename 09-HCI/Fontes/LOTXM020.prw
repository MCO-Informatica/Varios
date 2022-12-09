#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

#DEFINE cFieldBitmap "Z01_FILIAL"   
#DEFINE BNO "LBNO"
#DEFINE BOK "LBOK"
//-------------------------------------------------------------------
/*/{Protheus.doc} LOTXM020
Produto x Documento x OP

@author		Jair Ribeiro 
@since		31/07/2015
@version	1.0
@obs		Rotina Especifica
/*/
//-------------------------------------------------------------------
User Function LOTXM020(a,b,c,cCodPrd,cDescPrd)  
Local oDlg			:= Nil
Local oFwLayer		:= Nil
Local oPanelA		:= Nil
Local oPanelB		:= Nil
Local oPanelA1		:= Nil
Local oGetDados		:= Nil
Local oMsGet		:= Nil
Local oFont			:= Nil 
Local oSayI			:= Nil
Local oTGetI		:= Nil
Local bSave			:= {|| IiF(Eval(bLinhaAll,.T.),(SaveConfig(oGetDados,cCodPrd),oDlg:End()),Nil)}
Local bEndWin		:= {|| oDlg:End()}
Local aHeaderX		:= {}
Local aColsX		:= {}
Local aNoFields		:= {}   
Local cFiltroX		:= ""
Local cFirstNode	:= ""
Local lEdit			:= .F.
Local aDimensao		:= FWGetDialogSize(oMainWnd)

Local aArea			:= GetArea() 
Local bLinhaOk		:= {|| VldLineGet(oGetDados,.F.)}
Local bLinhaAll		:= {|| VldLineGet(oGetDados,.T.)}

Default cCodPrd		:= SB1->B1_COD
Default cDescPrd	:= SB1->B1_DESC

SaveInter()
oDlg:= MSDialog():New(10,10,550,550,"Produto x Documento x OP",,,, nOR( WS_POPUP ,WS_DISABLED ),,,,,.T.) 

oFWLayer:= FWLayer():New()
oFWLayer:Init(oDlg,.T.)
oFWLayer:AddLine('LineA',20,.F.)
oFWLayer:AddLine('LineB',80,.F.) 

oFWLayer:AddCollumn('ColumnA',100,.F.,'LineA')
oFWLayer:AddCollumn('ColumnB',100,.F.,'LineB')
oFWLayer:AddWindow('ColumnA','WindowA','Produto'											,100,.F.,.T.,{||  }, 'LineA' )
oFWLayer:AddWindow('ColumnB','WindowB','Documentos'											,100,.F.,.T.,{||  }, 'LineB' )

oPanelA:= oFWLayer:GetWinPanel('ColumnA','WindowA','LineA')
oPanelA:FreeChildren()	
                                                           
oPanelB:= oFWLayer:GetWinPanel('ColumnB','WindowB','LineB')
oPanelB:FreeChildren()	

oPanelA1:= TPanel():New(10		,10,"",oPanelA		,,.F.,,,,010	,010,.F.,.F.) 
oPanelA1:Align:= CONTROL_ALIGN_ALLCLIENT

oFont	:= TFont():New('Courier New',,-14,.T.,.T.)
oSayI	:= TSay():New(001,005	,{|| "Produto"  	},oPanelA1,,,,,,.T.,CLR_BLACK,CLR_BLACK)
oTGetI	:= TGet():New(008,005	,{|u| if(PCount()>0,cCodPrd :=u	,cCodPrd)			}	,oPanelA1,065,10		,'@!' 		,,,,,,,.T.,,,,,,,.T.,,,'cCodPrd')

oSayJ	:= TSay():New(001,075	,{|| "Descricao"  	},oPanelA1,,,,,,.T.,CLR_BLACK,CLR_BLACK)
oTGetJ	:= TGet():New(008,075	,{|u| if(PCount()>0,cDescPrd :=u	,cDescPrd)			}	,oPanelA1,140,10		,'@!' 		,,,,,,,.T.,,,,,,,.T.,,,'cDescPrd')


aAdd(aNoFields,"Z01_PRODUT")
aAdd(aNoFields,"Z01_DESCRI")

cFiltroX +=  " AND Z01_PRODUT	 	= '"+cCodPrd			+"'"+CRLF
lEdit := xRetGdSql(aHeaderX,aColsX,"Z01",3,aNoFields,cFiltroX,.T.,.F.)

oGetDados	:= MsNewGetDados():New(0,0,150,200,GD_UPDATE ,"AllwaysTrue","AllwaysTrue",,,,,,,,oPanelB,aHeaderX,aColsX)
oGetDados:oBrowse:Align			:= CONTROL_ALIGN_ALLCLIENT  
oGetDados:oBrowse:bLDblClick	:= {|| MarcaGetDd(oGetDados)} 
oGetDados:bLinhaOk				:= bLinhaOk
SetaCols(oGetDados,cCodPrd)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bSave,bEndWin,,)

RestInter()
RestArea(aArea)
Return Nil
//-------------------------------------------------------------------
/*/{Protheus.doc} VldLineGet
Grava valores cadastro

@author		Jair Ribeiro 
@since		31/07/2015
@version	1.0
@obs		Rotina Especifica
/*/
//-------------------------------------------------------------------
Static Function SaveConfig(oGetDados,cCodPrd)
Local nI		:= 0
Local lDelete	:= .F.
Local lExiste	:= .F.

Z01->(DbSetOrder(1)) ////Z01_FILIAL+Z01_PRODUT+Z01_TPDOC+Z01_TPUSO
For nI	:= 1 To Len(oGetDados:aCols)                                                     
	lDelete := oGetDados:aCols[nI,GdFieldPos(cFieldBitmap,oGetDados:aHeader)] == BNO
	lExiste	:= Z01->(DbSeek(xFilial("Z01")+cCodPrd+oGetDados:aCols[nI,GdFieldPos("Z01_TPDOC"		,oGetDados:aHeader)]))
	
	If lDelete .and. lExiste
		If RecLock("Z01",.F.)
			Z01->(DbDelete())
			Z01->(MsUnLock())
		EndIf
	ElseIf !lDelete
		If RecLock("Z01",!lExiste)
			Z01->Z01_FILIAL		:= xFilial("Z01") 
			Z01->Z01_PRODUT		:= cCodPrd 
			Z01->Z01_TPDOC		:= oGetDados:aCols[nI,GdFieldPos("Z01_TPDOC"		,oGetDados:aHeader)] 
			Z01->Z01_TPUSO		:= oGetDados:aCols[nI,GdFieldPos("Z01_TPUSO"		,oGetDados:aHeader)] 
			Z01->(MsUnLock())
		EndIf
	
	EndIf  
Next nI
Return .T.
//-------------------------------------------------------------------
/*/{Protheus.doc} VldLineGet
Validacao de linha cadastro

@author		Jair Ribeiro 
@since		31/07/2015
@version	1.0
@obs		Rotina Especifica
/*/
//-------------------------------------------------------------------
Static Function VldLineGet(oGetDados,lAllLine)
Local lRet			:= .T.
Local nI			:= 0
Default lAllLine	:= .F.

If lAllLine
	For nI	:= 1 to Len(oGetDados:aCols)
		If oGetDados:aCols[nI,GdFieldPos(cFieldBitmap,oGetDados:aHeader)] == BOK .and.;
			Empty(oGetDados:aCols[nI,GdFieldPos("Z01_TPUSO",oGetDados:aHeader)])
			lRet := .F.	
			Exit
		EndIf
	Next nI
ElseIf oGetDados:aCols[oGetDados:oBrowse:nAt,GdFieldPos(cFieldBitmap,oGetDados:aHeader)] == BOK .and.;
	Empty(oGetDados:aCols[oGetDados:oBrowse:nAt,GdFieldPos("Z01_TPUSO",oGetDados:aHeader)])
	lRet := .F.
EndIf 

If !lRet
	MsgStop("Quando selecionado necessario informar o campo Tipo de Uso")
EndIf

Return lRet
//-------------------------------------------------------------------
/*/{Protheus.doc} MarcaGetDd
Marcacao MsNewGetDados

@author		Jair Ribeiro 
@since		31/07/2015
@version	1.0
@obs		Rotina Especifica
/*/
//-------------------------------------------------------------------
Static Function MarcaGetDd(oGetDados)
Local nPosMrk	:= GdFieldPos(cFieldBitmap,oGetDados:aHeader)
Local cMarca	:= ""
If oGetDados:oBrowse:nColPos == nPosMrk
	cMarca:= GdFieldGet(cFieldBitmap,oGetDados:oBrowse:nAt,,oGetDados:aHeader,oGetDados:aCols)
	oGetDados:aCols[oGetDados:oBrowse:nAt,nPosMrk]:= IiF(cMarca == BOK,BNO,BOK)
Else
	oGetDados:EditCell()
EndIf
oGetDados:oBrowse:Refresh()
Return .T.  
//-------------------------------------------------------------------
/*/{Protheus.doc} SetaCols
Retorna aCols

@author		Jair Ribeiro 
@since		31/07/2015
@version	1.0
@obs		Rotina Especifica
/*/
//-------------------------------------------------------------------
Static Function SetaCols(oGetDados,cCodPrd)
Local cQuery		:= ""
Local cAliasQry		:= ""
Local nAux			:= 0 
Local cTipoDoc		:= GetMv("ES_TPDOCPR",,"_O")

cQuery		:= " SELECT DISTINCT SX5.X5_CHAVE "+CRLF
cQuery		+= " ,SX5.X5_DESCRI "+CRLF
cQuery		+= " ,COALESCE(Z01.Z01_TPUSO,'0') Z01_TPUSO  "+CRLF
cQuery		+= " FROM "+RetSqlName("SX5") +" SX5  "+CRLF
cQuery		+= " LEFT JOIN "+RetSqlName("Z01") +" Z01 "+CRLF
cQuery		+= " ON (	Z01.Z01_TPDOC 		= SX5.X5_CHAVE "+CRLF
cQuery		+= " 		AND Z01.Z01_PRODUT	= '"+cCodPrd		+"' "+CRLF
cQuery		+= " 		AND Z01.D_E_L_E_T_ 	= '"+Space(1)		+"') "+CRLF
cQuery		+= " WHERE SX5.X5_TABELA 	= '"+cTipoDoc+"' "+CRLF 
cQuery		+= " AND SX5.D_E_L_E_T_ 	= '"+Space(1)		+"' "+CRLF

cAliasQry	:= GetNextAlias()
If Select(cAliasQry) > 0 
	(cAliasQry)->(DbCloseArea())
EndIf 
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)  
(cAliasQry)->(DbGoTop())
While (cAliasQry)->(!EOF())
	nAux++
	If nAux > 1
   		oGetDados:AddLine(.F.,.F.)
	EndIf
	oGetDados:aCols[Len(oGetDados:aCols),GdFieldPos(cFieldBitmap	,oGetDados:aHeader)] := IiF((cAliasQry)->Z01_TPUSO == "0",BNO,BOK)   
	oGetDados:aCols[Len(oGetDados:aCols),GdFieldPos("Z01_TPDOC"		,oGetDados:aHeader)] := (cAliasQry)->X5_CHAVE 
	oGetDados:aCols[Len(oGetDados:aCols),GdFieldPos("Z01_TPDESC"	,oGetDados:aHeader)] := (cAliasQry)->X5_DESCRI    
	oGetDados:aCols[Len(oGetDados:aCols),GdFieldPos("Z01_TPUSO"		,oGetDados:aHeader)] := IiF((cAliasQry)->Z01_TPUSO == "0","",(cAliasQry)->Z01_TPUSO)  

	(cAliasQry)->(DbSkip())	
EndDo
oGetDados:ForceRefresh()

Return .T.
//-------------------------------------------------------------------
/*/{Protheus.doc} xRetGdSql
Preenche aCols e aHeader para MsNewGetDados

@param	aHeaderX ,Array ,aHeader do Objeto MsNewGetDados
@param	aColsX 	,Array ,aColsX do Objeto MsNewGetDados
@param	cAlias	,Caractere, Alias do arquivo
@param	nOpcX	,Numerico, Opcao de manutencao

@author Jair Ribeiro
@since 	12/11/2013
@version 1.0
@obs   Funcao auxiliar para MsNewGetDados
/*/
//-------------------------------------------------------------------
Static Function xRetGdSql(aHeaderX,aColsX,cAlias,nOpcX,aNoFields,cFiltroX,lBitMap,lRecWt,lCriaVar)
Local cQuery 	:= ""
Local cAliasQry	:= GetNextAlias()
Local aArea		:= SX3->(GetArea())
Local nI		:= 0
Local nJ		:= 0
Local nCols    	:= 0
Local nPosI		:= 0
Local lRet		:= .T.
Default lCriaVar	:= .T.

If Empty(aHeaderX)
	SX3->(DbSetOrder(1))
	SX3->(DbSeek(cAlias))
	If lBitMap
		xBuildHdr(aHeaderX,,,,lBitMap,)
	EndIf
	While (SX3->(!EOF()) .and. SX3->X3_ARQUIVO == cAlias)
		If X3USO(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL .and. aScan(aNoFields,{|aX| aX == AllTrim(SX3->X3_CAMPO)}) == 0
			xBuildHdr(aHeaderX,SX3->X3_CAMPO)
		EndIf
		SX3->(DbSkip())
	EndDo
	If lRecWt
		xBuildHdr(aHeaderX,cAlias+"_REC_WT",,,,lRecWt)
	EndIf
EndIf

If Empty(aColsX)
	aAdd(aColsX,Array(Len(aHeaderX)+1))
	For nI := 1 To Len(aHeaderX)
		If "_REC_WT" $ aHeaderX[nI,2]
			aColsX[1][nI] 		:= 0
		ElseIf AllTrim(aHeaderX[nI,3]) == "@BMP"
			aColsX[1][nI] 		:= BNO
		ElseIf lCriaVar
			aColsX[1][nI] := CriaVar(aHeaderX[nI][2])
		EndIf
	Next nI
	aColsX[1][Len(aHeaderX)+1] := .F.
	lRet		:= .F.
EndIf

RestArea(aArea)
Return (lRet)
//-------------------------------------------------------------------
/*/{Protheus.doc} xBuildHdr
Adiciona elemento no aHeader para MsNewGetDados 

@param	aHeaderX ,Array ,aHeader do Objeto MsNewGetDados
@param	cCampo 	,Caractere ,Nome do campo
@param	cTitulo ,Caractere, Titulo do campo
@param	aStruct ,Array, Estrutura do campo (SX3)
@param	lBitmap ,Boolean, Define se havera campo de marcacao
@param	lRecWt	,Boolean, Define se havera o campo REC_WT
@author Jair Ribeiro
@since 	12/11/2013
@version 1.0
@obs   Funcao auxiliar para MsNewGetDados
/*/
//-------------------------------------------------------------------
Static Function xBuildHdr(aHeaderX,cCampo,cTitulo,aStruct,lBitmap,lRecWt)
Local aArea			:= SX3->(GetArea())
Default cCampo		:= ""
Default cTitulo 	:= ""
Default	aStruct		:= {}
Default	lBitmap		:= .F.
Default	lRecWt		:= .F.

SX3->(DbSetOrder(2))

If lBitmap
	aAdd(aHeaderX,{;
	"",;						// 01 - Titulo
	cFieldBitmap,; 				// 02 - Campo
	"@BMP",;			   		// 03 - Picture
	06,;						// 04 - Tamanho
	0,;					   		// 05 - Decimal
	"",;				   		// 06 - Valid
	"????????",;	  			// 07 - Usado
	"C",;				  		// 08 - Tipo
	"",;				  		// 09 - F3
	"R",;			   	  		// 10 - Contexto
	"",;				  		// 11 - ComboBox
	"",;				  		// 12 - Relacao
	".F.",;       	 	 		// 13 - When
	"A",;				 		// 14 - Visual
	"",;				 		// 15 - ValidUser
	"",;				  		// 16 - PictVar
	.T.})				  		// 17 - Obrigat
EndIf

If lRecWt
	aAdd(aHeaderX,{;
	"Recno WT",;				// 01 - Titulo
	cCampo,;		   			// 02 - Campo
	"",;				   		// 03 - Picture
	09,;						// 04 - Tamanho
	0,;					   		// 05 - Decimal
	"",;				   		// 06 - Valid
	"????????",;		  		// 07 - Usado
	"N",;				  		// 08 - Tipo
	"",;				  		// 09 - F3
	"V",;			   	  		// 10 - Contexto
	"",;				  		// 11 - ComboBox
	"",;				  		// 12 - Relacao
	"",;        	 	 		// 13 - When
	"V",;				 		// 14 - Visual
	"",;				 		// 15 - ValidUser
	"",;				  		// 16 - PictVar
	.T.})				  		// 17 - Obrigat
EndIf

If !Empty(cCampo) .and. SX3->(DbSeek(cCampo))
	cTitulo := Iif(Empty(cTitulo),X3Titulo(),cTitulo)
	aAdd(aHeaderX,{;
	cTitulo,; 	  				// 01 - Titulo
	SX3->X3_CAMPO,;				// 02 - Campo
	SX3->X3_PICTURE,;			// 03 - Picture
	SX3->X3_TAMANHO,;			// 04 - Tamanho
	SX3->X3_DECIMAL,;			// 05 - Decimal
	SX3->X3_VALID,;				// 06 - Valid
	SX3->X3_USADO,;				// 07 - Usado
	SX3->X3_TIPO,;				// 08 - Tipo
	SX3->X3_F3,;				// 09 - F3
	SX3->X3_CONTEXT,;	   		// 10 - Contexto
	X3CBox(),;					// 11 - ComboBox
	SX3->X3_RELACAO,;			// 12 - Relacao
	SX3->X3_WHEN,;         		// 13 - When
	SX3->X3_VISUAL,;			// 14 - Visual
	SX3->X3_VLDUSER,;			// 15 - ValidUser
	SX3->X3_PICTVAR,;			// 16 - PictVar
	X3Obrigat(SX3->X3_CAMPO)})	// 17 - Obrigat
	
ElseIf !Empty(aStruct)
	aAdd(aHeaderX,{;
	aStruct[1],; 				// 01 - Titulo
	aStruct[2],;				// 02 - Campo
	aStruct[3],;				// 03 - Picture
	aStruct[4],;				// 04 - Tamanho
	aStruct[5],;				// 05 - Decimal
	aStruct[6],;				// 06 - Valid
	"",;						// 07 - Usado
	aStruct[7],;				// 08 - Tipo
	"",;						// 09 - F3
	"R",;				   		// 10 - Contexto
	aStruct[8],;				// 11 - ComboBox
	aStruct[9],;				// 12 - Relacao
	aStruct[10],;         		// 13 - When
	"",;						// 14 - Visual
	aStruct[11],;				// 15 - ValidUser
	"",;						// 16 - PictVar
	aStruct[12]})				// 17 - Obrigat
EndIf
RestArea(aArea)
Return .T.