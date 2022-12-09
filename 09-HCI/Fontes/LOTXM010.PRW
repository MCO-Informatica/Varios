#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} LOTXM010
Digitalizacao Documentos

@author		Jair Ribeiro
@since		31/07/2015
@version	1.0
@obs		Rotina Especifica
/*/
//-------------------------------------------------------------------
User Function LOTXM010()
Local cAliasAux		:= Alias()
Local oDlg			:= Nil
Local oFwLayer		:= Nil
Local oPanelA		:= Nil
Local oPanelB		:= Nil
Local oPanelC		:= Nil
Local oPanelA1		:= Nil
Local oButtonB		:= Nil
Local oTree			:= Nil
Local oButtonC		:= Nil
Local oGetDados		:= Nil
Local oMsGet		:= Nil
Local oFont			:= Nil
Local oSayI			:= Nil
Local oSayJ			:= Nil
Local oSayX			:= Nil
Local oSayy			:= Nil
Local oTGetI		:= Nil
Local oTGetJ		:= Nil
Local oTGetX		:= Nil
Local oTGety		:= Nil
Local bSave			:= {|| oDlg:End()}
Local bEndWin		:= {|| oDlg:End()}
Local bAddTipo		:= {|| cRet := AddTipoDoc(@oTree,@oFWLayer,cNumAux,cItemAux,cSeqAux,@oGetDados,cTabSX5)  				,IiF(!Empty(cRet),(oTree:TreeSeek(cRet),Eval(bRefresh,oTree:GetCargo()),Eval(bAtuFol)),Nil)}
Local bExcTipo		:= {|| lRet := ExcTipoDoc(@oTree,@oFWLayer,cNumAux,cItemAux,cSeqAux,cAliasAux,@oGetDados)				,Eval(bRefresh,IiF(oTree:GetCargo() == Nil,"",oTree:GetCargo())),Eval(bAtuFol)}
Local bAddDoc		:= {|| lRet := AddDocs(@oTree,@oFWLayer,cNumAux,cItemAux,cSeqAux,@oGetDados,cAliasAux,cDiretorio)		,Eval(bRefresh,oTree:GetCargo()),Eval(bAtuFol)}
Local bExcDoc		:= {|| lRet := ExcDocs(@oTree,@oFWLayer,cNumAux,cItemAux,cSeqAux,cAliasAux,@oGetDados)	   				,Eval(bRefresh,oTree:GetCargo()),Eval(bAtuFol)}
Local bVisDoc		:= {|| lRet := VisDocs(@oTree,@oFWLayer,cNumAux,cItemAux,cSeqAux,@oGetDados)}
Local bAprDoc		:= {|| lRet := AprDocs(@oTree,@oFWLayer,cNumAux,cItemAux,cSeqAux,cAliasAux,@oGetDados)					,Eval(bRefresh,oTree:GetCargo()),Eval(bAtuFol)}
Local bAtuFol		:= {|| lRet	:= AtuFolder(@oTree,cTabSX5, cAliasAux )}

Local aHeaderX		:= {}
Local aColsX		:= {}
Local aNoFields		:= {}
Local aCpoEnc		:= {"Z00_NUM","Z00_ITEM","Z00_SEQUEN","NOUSER"}
Local cFiltroX		:= ""
Local lEdit			:= .F.
Local aDimensao		:= FWGetDialogSize(oMainWnd)

Local bRefresh		:= {|cNodeAtu| FReadData(cNodeAtu,oTree,oFWLayer,cNumAux,cItemAux,cSeqAux,oGetDados)}
Local aArea			:= GetArea()

Local cNumAux 		:= Space(15)
Local cItemAux		:= Space(2)
Local cSeqAux  		:= Space(3)
Local cTexto1      	:= ""
Local cTexto2		:= ""
Local cTexto3		:= ""
Local cTexto4		:= ""
Local cTitAux		:= ""
Local cSubTit		:= ""
Local cDescAux		:= ""
Local cTabSX5    	:= ""
Local cDiretorio	:= GetMv("ES_DIRDIG"	,,"\BookDocs\")
Local lAprovador	:= (__cUserID $ GetMv("ES_APRVDOC"	,,"000000") )
Local lComplTree	:= GetMv("ES_TREEDOC"	,,.T.)
Local cCodProd		:= ""
Local cTipoUso		:= ""
Local lProduto 		:= .F.
Local lTree			:= .T.

SaveInter()
MakeDir(cDiretorio)
Do Case
	Case cAliasAux == "SC2"
		
		cTitAux		:= "Ordem de Produção"
		cSubTit		:= "Tipo de Documento - Book OP"
		
		cTexto1		:= "Numero OP"
		cTexto2		:= "Item OP"
		cTexto3		:= "Sequencia OP"
		cTexto4		:= "Codigo do Produto "
		cDiretorio	:= cDiretorio+"C2"
		cTabSX5		:= "_P"    // OPs
		
		cNumAux 	:= SC2->C2_NUM + SPAC(15-LEN(SC2->C2_NUM))
		cItemAux	:= SC2->C2_ITEM
		cSeqAux  	:= SC2->C2_SEQUEN
		cDescAux	:= SC2->C2_PRODUTO
		cCodProd	:= SC2->C2_PRODUTO
		cTipoUso	:= "2"
		lProduto	:= .T.
		
	Case cAliasAux == "SRA"
		
		cTitAux		:= "Cadastro de Funcionarios"
		cSubTit		:= "Tipo de Documento - Book RH"
		
		cTexto1		:= "Matricula"
		cTexto2		:= ""
		cTexto3		:= ""
		cTexto4		:= "Nome do Funcionario  "
		cDiretorio	:= cDiretorio+"RA"
		cTabSX5		:= "_R"    // RH
		
		
		cNumAux 	:= SRA->RA_MAT  + SPAC(15-LEN(SRA->RA_MAT))
		cItemAux	:= Space(2)
		cSeqAux		:= Space(3)
		cDescAux	:= SRA->RA_NOME
		
	Case cAliasAux == "SB1"
		
		cTitAux		:= "Cadastro de Produtos"
		cSubTit		:= "Tipo de Documento - Book Produtos"
		cTexto1		:= "Produto  "
		cTexto2		:= ""
		cTexto3		:= ""
		cTexto4		:= "Descrição do Material"
		cDiretorio	:= cDiretorio+"B1"
		cTabSX5		:= "_P"    // Produtos
		cNumAux		:= SB1->B1_COD
		cItemAux	:= Space(2)
		cSeqAux		:= Space(3)
		cDescAux	:= SB1->B1_DESC
		cCodProd	:= SB1->B1_COD
		cTipoUso	:= "1"
		lProduto	:= .T.
EndCase

oDlg:= MSDialog():New(aDimensao[1],aDimensao[2],aDimensao[3],aDimensao[4],cCadastro,,,, nOR( WS_POPUP ,WS_DISABLED ),,,,oMainWnd,.T.)

oFWLayer:= FWLayer():New()
oFWLayer:Init(oDlg,.T.)
oFWLayer:AddLine('LineA',20,.F.)
oFWLayer:AddLine('LineB',80,.F.)

oFWLayer:AddCollumn('ColumnA',100,.F.,'LineA')
oFWLayer:SetColSplit('ColumnA',CONTROL_ALIGN_ALLCLIENT,'LineA')

oFWLayer:AddCollumn('ColumnB',30,.F.,'LineB')
oFWLayer:SetColSplit('ColumnB',CONTROL_ALIGN_ALLCLIENT,'LineB')

oFWLayer:AddCollumn('ColumnC',70,.F.,'LineB')
oFWLayer:SetColSplit('ColumnC',CONTROL_ALIGN_ALLCLIENT,'LineB')


oFWLayer:AddWindow('ColumnA','WindowA',cTitAux											,100,.F.,.T.,{||  }, 'LineA' )
oFWLayer:AddWindow('ColumnB','WindowB',cSubTit											,100,.F.,.T.,{||  }, 'LineB' )
oFWLayer:AddWindow('ColumnC','WindowC','Documentos'										,100,.F.,.T.,{||  }, 'LineB' )

oPanelA:= oFWLayer:GetWinPanel('ColumnA','WindowA','LineA')
oPanelA:FreeChildren()

oPanelB:= oFWLayer:GetWinPanel('ColumnB','WindowB','LineB')
oPanelB:FreeChildren()

oPanelC:= oFWLayer:GetWinPanel('ColumnC','WindowC','LineB')
oPanelC:FreeChildren()

oPanelA1:= TPanel():New(10		,10,"",oPanelA		,,.F.,,,,010	,010,.F.,.F.)
oPanelA1:Align:= CONTROL_ALIGN_ALLCLIENT

oFont	:= TFont():New('Courier New',,-14,.T.,.T.)
oSayI	:= TSay():New(001,005	,{|| cTexto1  	},oPanelA1,,,,,,.T.,CLR_BLACK,CLR_BLACK)
oSayJ	:= TSay():New(001,080	,{|| cTexto2 	},oPanelA1,,,,,,.T.,CLR_BLACK,CLR_BLACK)
oSayX	:= TSay():New(001,125	,{|| cTexto3   },oPanelA1,,,,,,.T.,CLR_BLACK,CLR_BLACK)
oSayY	:= TSay():New(001,170	,{|| cTexto4   },oPanelA1,,,,,,.T.,CLR_BLACK,CLR_BLACK)

oTGetI	:= TGet():New(008,005	,{|u| if(PCount()>0,cNumAux :=u	,cNumAux)			}	,oPanelA1,070,10		,'@!' 		,,,,,,,.T.,,,,,,,.T.,,,'cNumAux')
oTGetJ	:= TGet():New(008,080	,{|u| if(PCount()>0,cItemAux:=u	,cItemAux)		}	,oPanelA1,040,10		,'@!' 		,,,,,,,.T.,,,,,,,.T.,,,'cItemAux')
oTGetX	:= TGet():New(008,125	,{|u| if(PCount()>0,cSeqAux :=u	,cSeqAux)			}	,oPanelA1,030,10		,'@!' 		,,,,,,,.T.,,,,,,,.T.,,,'cSeqAux')
oTGety	:= TGet():New(008,170	,{|u| if(PCount()>0,cDescAux:=u	,cDescAux)		}	,oPanelA1,150,10		,'@!' 		,,,,,,,.T.,,,,,,,.T.,,,'cDescAux')

If !lComplTree .and. !lProduto
	oButtonB := FWButtonBar():New()
	oButtonB:Init(oPanelB,15,15,CONTROL_ALIGN_ALLCLIENT,.T.)
	
	oButtonB:AddBtnImage("AVG_IADD.PNG"			,OEMTOANSI("Adicionar Tipo")				,bAddTipo	,,.T.,CONTROL_ALIGN_BOTTOM)
	oButtonB:AddBtnImage("AVG_IDEL.PNG"			,OEMTOANSI("Excluir Tipo")					,bExcTipo	,,.T.,CONTROL_ALIGN_BOTTOM)
EndIf

oTree		:= xTree():New(,,,,oPanelB)
oTree:Align	:= CONTROL_ALIGN_ALLCLIENT
Processa( { || lTree := FBuildTree(oTree,oFWLayer,cNumAux,cItemAux,cSeqAux,@oGetDados,cTabSX5,lComplTree,lProduto,cCodProd,cTipoUso)},"Estrutura de Gestores","Aguarde... Carregando Estrutura" )

If lComplTree .and. !lTree
	MsgStop("Produto em questão nao possui cadastro de digitalizacao (LOTXM010 - Z01)!")
	Return Nil
EndIf

oButtonC := FWButtonBar():New()
oButtonC:Init(oPanelC,15,15,CONTROL_ALIGN_ALLCLIENT,.T.)
oButtonC:AddBtnImage("NOVACELULA.PNG"		,OEMTOANSI("Adicionar Documento")			,bAddDoc	,,.T.,CONTROL_ALIGN_TOP)
oButtonC:AddBtnImage("PCO_ITEXC.PNG"		,OEMTOANSI("Excluir Documento")				,bExcDoc	,,.T.,CONTROL_ALIGN_TOP)
oButtonC:AddBtnImage("VERNOTA.PNG"			,OEMTOANSI("Visualizar Documento")			,bVisDoc	,,.T.,CONTROL_ALIGN_TOP)

If lAprovador
	oButtonC:AddBtnImage("OK_MDI.PNG"		,OEMTOANSI("Aprova Documento")				,bAprDoc	,,.T.,CONTROL_ALIGN_TOP)
EndIf

aAdd(aNoFields,"Z00_NUM")
aAdd(aNoFields,"Z00_ITEM")
aAdd(aNoFields,"Z00_SEQUEN")

cFiltroX +=  " AND Z00_NUM	 	= '"+cNumAux			+"'"+CRLF
cFiltroX +=  " AND Z00_ITEM	 	= '"+cItemAux			+"'"+CRLF
cFiltroX +=  " AND Z00_SEQUEN 	= '"+cSeqAux			+"'"+CRLF

lEdit := xRetGdSql(aHeaderX,aColsX,"Z00",3,aNoFields,cFiltroX,.F.,.F.)

oGetDados	:= MsNewGetDados():New(0,0,150,200,0,"AllwaysTrue","AllwaysTrue",,,,,,,,oPanelC,aHeaderX,aColsX)
oGetDados:oBrowse:Align			:= CONTROL_ALIGN_ALLCLIENT

Eval(bRefresh,oTree:GetCargo())

Eval(bAtuFol)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bSave,bEndWin,,)
RestInter()
RestArea(aArea)
Return Nil
//-------------------------------------------------------------------
/*/{Protheus.doc} AprDocs
Aprovacao de documentos

@author	Jair Ribeiro
@since		31/07/2015
@version	1.0
@obs		Rotina Especifica
/*/
//-------------------------------------------------------------------
Static Function AprDocs(oTree,oFWLayer,cNumAux,cItemAux,cSeqAux,cAliasAux,oGetDados)
Local aArea		:= GetArea()
Local aAreaZ00	:= Z00->(GetArea())

If oTree:GetCargo() != Nil
	If Z00->(DbSeek(xFilial("Z00")+cNumAux+cItemAux+cSeqAux+oTree:GetCargo()+GdFieldGet("Z00_ID",oGetDados:oBrowse:nAt,,oGetDados:aHeader,oGetDados:aCols)+cAliasAux))
		If Z00->Z00_APROV == "1"
			MsgInfo("Documento já se encontra com status aprovado")
		ElseIf MsgYesNo("Deseja realmente aprovar o Documento em questão?")
			If RecLock("Z00",.F.)
				Z00->Z00_APRUSR		:= __cUserId
				Z00->Z00_APRDT		:= dDataBase
				Z00->Z00_APRHR		:= SubStr(Time(),1,5)
				Z00->Z00_APROV		:= "1"
				Z00->(MsUnlock())
			EndIf
		EndIf
	Else
		MsgInfo("Erro ao aprovar documento! Entre em contato com administrador!")
	EndIf
EndIf
RestArea(aAreaZ00)
RestArea(aArea)
Return .T.
//-------------------------------------------------------------------
/*/{Protheus.doc} AtuFolder
Atualiza Bitmap folder

@author	Jair Ribeiro
@since		31/07/2015
@version	1.0
@obs		Rotina Especifica
/*/
//-------------------------------------------------------------------
Static Function AtuFolder(oTree,cTabSX5,cAliasAux)
Local cQuery	:= ""
Local cAliasQry	:= ""


cQuery	:= " SELECT SX5.X5_CHAVE "+CRLF
cQuery	+= " ,("+CRLF
cQuery	+= " 	SELECT COUNT(*) QTDE"+CRLF
cQuery	+= " 	FROM "+RetSqlName("Z00")+" Z00A"+CRLF
cQuery	+= " 	WHERE Z00A.Z00_FILIAL 	= '"+xFilial("Z00")	+"'"+CRLF
cQuery	+= " 	AND Z00A.D_E_L_E_T_	 	= '"+Space(1)		+"'"+CRLF
cQuery	+= " 	AND Z00A.Z00_TPDOC		= SX5.X5_CHAVE"+CRLF
cQuery	+= " 	AND Z00A.Z00_ORIGEM		= '"+cAliasAux+"' "+CRLF

cQuery	+= " 	) QUANTIDADE"+CRLF
cQuery	+= " ,("+CRLF
cQuery	+= " 	SELECT COUNT(*) QTDE"+CRLF
cQuery	+= " 	FROM "+RetSqlName("Z00")+" Z00B"+CRLF
cQuery	+= " 	WHERE Z00B.Z00_FILIAL 	= '"+xFilial("Z00")	+"'"+CRLF
cQuery	+= " 	AND Z00B.D_E_L_E_T_	 	= '"+Space(1)		+"'"+CRLF
cQuery	+= " 	AND Z00B.Z00_TPDOC		= SX5.X5_CHAVE"+CRLF
cQuery	+= " 	AND Z00B.Z00_APROV		= '1'"+CRLF
cQuery	+= " 	AND Z00B.Z00_ORIGEM		= '"+cAliasAux+"'"+CRLF
cQuery	+= " 	) APROVADO"+CRLF
cQuery	+= " FROM "+RetSqlName("SX5")+" SX5"+CRLF
cQuery	+= " WHERE SX5.X5_TABELA   		= '"+cTabSX5		+"'"+CRLF
cQuery	+= " AND SX5.D_E_L_E_T_	 		= '"+Space(1)		+"'"+CRLF


cAliasQry	:= GetNextAlias()
If Select(cAliasQry) > 0
	(cAliasQry)->(DbCloseArea())
EndIf
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
(cAliasQry)->(DbGoTop())
While (cAliasQry)->(!EOF())
	If oTree:TreeSeek((cAliasQry)->X5_CHAVE)
		If (cAliasQry)->QUANTIDADE == 0 .and. (cAliasQry)->APROVADO == 0
			oTree:ChangeBmp("FOLDER7.PNG","FOLDER8.PNG",oTree:GetCargo(),.T.)
		ElseIf (cAliasQry)->QUANTIDADE == (cAliasQry)->APROVADO
			oTree:ChangeBmp("FOLDER10.PNG","FOLDER11.PNG",oTree:GetCargo(),.T.)
		Else
			oTree:ChangeBmp("FOLDER5.PNG","FOLDER6.PNG",oTree:GetCargo(),.T.)
		EndIf
	EndIf
	(cAliasQry)->(DbSkip())
EndDo
If Select(cAliasQry) > 0
	(cAliasQry)->(DbCloseArea())
EndIf
Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} AddDocs
Adiciona documentos

@author	Jair Ribeiro
@since		31/07/2015
@version	1.0
@obs		Rotina Especifica
/*/
//-------------------------------------------------------------------
Static Function AddDocs(oTree,oFWLayer,cNumAux,cItemAux,cSeqAux,oGetDados,cAliasAux,cDiretorio)
Local aParam		:= {}
Local aRetPb		:= {}
Local cNodeAtu		:= oTree:GetCargo()
Local cNameFile		:= ""
Local cDirDest		:= ""
Local aDiretorio	:= {}
Local lCopia		:= .F.

If cNodeAtu != Nil
	aAdd(aParam,{1,"Descricao"	,Space(TamSx3("Z00_DESCRI")[1]),"@!","","" ,"",65,.T.})
	aAdd(aParam,{6,"Arquivo"	,Space(TamSx3("Z00_LOCAL")[1])	,"","",""	,95,.T.,"Arquivos .* |*.*","",GETF_LOCALHARD+GETF_LOCALFLOPPY,.F.})
	
	If ParamBox(aParam,"Limpar Base",aRetPb,,,,,,)
		If File(aRetPb[2])
			cNameFile	:= Directory( aRetPb[2] )[1][1]
			
			aAdd(aDiretorio,cDiretorio)
			aAdd(aDiretorio,cEmpAnt+"01")
			aAdd(aDiretorio,AllTrim(cNumAux+cItemAux+cSeqAux))
			aAdd(aDiretorio,AllTrim(cNodeAtu))
			
			For nI	:= 1 To Len(aDiretorio)
				If nI > 1
					cDirDest 	+= "\"
				EndIf
				cDirDest 	+= aDiretorio[nI]
				MakeDir(cDirDest)
			Next nI
			cDirDest 	+= "\"
			
			
			Processa( { || lCopia := CpyT2S( aRetPb[2], cDirDest )},"Copia de Arquivo para Servidor","Aguarde... Copiando Arquivo" )
			If lCopia
				If File(cDirDest+"\"+cNameFile)
					If RecLock("Z00",.T.)
						Z00->Z00_FILIAL		:= xFilial("Z00")
						Z00->Z00_NUM   		:= cNumAux
						Z00->Z00_ITEM  		:= cItemAux
						Z00->Z00_SEQUEN		:= cSeqAux
						Z00->Z00_TPDOC 		:= cNodeAtu
						Z00->Z00_DESCRI		:= aRetPb[1]
						Z00->Z00_ID    		:= GetMaxIdDoc(cNumAux,cItemAux,cSeqAux,cNodeAtu,cAliasAux)
						Z00->Z00_LOCAL 		:= cDirDest+"\"+cNameFile
						Z00->Z00_ORIGEM		:= cAliasAux
						Z00->Z00_APROV 		:= "2"
						Z00->Z00_INCUSR		:= __cUserId
						Z00->Z00_INCDT		:= dDataBase
						Z00->Z00_INCHR		:= SubStr(Time(),1,5)
						Z00->(MsUnlock())
					EndIf
				EndIf
			Else
				MsgStop("Erro ao copiar arquivo para o servidor! Tente Novamente!")
			EndIf
		Else
			MsgStop("Arquivo informado nao encontrado!")
		EndIf
	EndIf
EndIf
Return .T.
//-------------------------------------------------------------------
/*/{Protheus.doc} GetMaxIdDoc
Retorna proximo Id para inclusao de documento

@author		Jair Ribeiro
@since		31/07/2015
@version	1.0
@obs		Rotina Especifica
/*/
//-------------------------------------------------------------------
Static Function GetMaxIdDoc(cNumAux,cItemAux,cSeqAux,cNodeAtu,cAliasAux)
Local cIdDoc 	:= StrZero(1,TamSx3("Z00_ID")[1])
Local cQuery	:= ""
Local cAliasQry	:= ""

cQuery	+= " SELECT COALESCE(MAX(Z00_ID),'') MAXID "+CRLF
cQuery	+= " FROM "+RetSqlName("Z00")+" Z00"+CRLF
cQuery	+= " WHERE Z00.Z00_FILIAL 	= '"+xFilial("Z00")	+"'"+CRLF
cQuery	+= " AND Z00.Z00_NUM	 	= '"+cNumAux		+"'"+CRLF
cQuery	+= " AND Z00.Z00_ITEM	 	= '"+cItemAux		+"'"+CRLF
cQuery	+= " AND Z00.Z00_SEQUEN 	= '"+cSeqAux		+"'"+CRLF
cQuery	+= " AND Z00.Z00_TPDOC	 	= '"+cNodeAtu		+"'"+CRLF
cQuery	+= " AND Z00.Z00_ORIGEM	 	= '"+cAliasAux		+"'"+CRLF
cQuery	+= " AND Z00.D_E_L_E_T_	 	= '"+Space(1)		+"'"+CRLF

cAliasQry	:= GetNextAlias()
If Select(cAliasQry) > 0
	(cAliasQry)->(DbCloseArea())
EndIf
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
(cAliasQry)->(DbGoTop())
If (cAliasQry)->(!EOF())
	If !Empty((cAliasQry)->MAXID)
		cIdDoc	:= (cAliasQry)->MAXID
		cIdDoc	:= Soma1(cIdDoc)
	EndIf
EndIf
If Select(cAliasQry) > 0
	(cAliasQry)->(DbCloseArea())
EndIf
Return cIdDoc
//-------------------------------------------------------------------
/*/{Protheus.doc} ExcDocs
Exclui documentos

@author	Jair Ribeiro
@since		31/07/2015
@version	1.0
@obs		Rotina Especifica
/*/
//-------------------------------------------------------------------
Static Function ExcDocs(oTree,oFWLayer,cNumAux,cItemAux,cSeqAux,cAliasAux,oGetDados)
Local aArea		:= GetArea()
Local aAreaZ00	:= Z00->(GetArea())

If oTree:GetCargo() != Nil
	If MsgYesNo("Deseja realmente excluir o Documento em questão?")
		If Z00->(DbSeek(xFilial("Z00")+cNumAux+cItemAux+cSeqAux+oTree:GetCargo()+GdFieldGet("Z00_ID",oGetDados:oBrowse:nAt,,oGetDados:aHeader,oGetDados:aCols)+cAliasAux))
			If  Z00->Z00_APROV != "1" .or. MsgYesNo("Documento já foi aprovado, confirma a exclusão?")
				If File(Z00->Z00_LOCAL)
					If FERASE(Z00->Z00_LOCAL) != 0
						MsgInfo("Erro ao excluir arquivo no servidor!")
					EndIf
				Else
					MsgInfo("Não consegui excluir o Arquivo !")
				EndIf
				If RecLock("Z00",.F.)
					Z00->Z00_EXCUSR		:= __cUserId
					Z00->Z00_EXCDT		:= dDataBase
					Z00->Z00_EXCHR		:= SubStr(Time(),1,5)
					Z00->(DbDelete())
					Z00->(MsUnlock())
				EndIf
			EndIf
		Else
			MsgInfo("Erro ao excluir indice do aquivo na tabela!")
		EndIf
	EndIf
EndIf
RestArea(aAreaZ00)
RestArea(aArea)
Return .T.
//-------------------------------------------------------------------
/*/{Protheus.doc} VisDocs
Visualiza documentos

@author	Jair Ribeiro
@since		31/07/2015
@version	1.0
@obs		Rotina Especifica
/*/
//-------------------------------------------------------------------
Static Function VisDocs(oTree,oFWLayer,cNumAux,cItemAux,cSeqAux,oGetDados)
Local cPathFile := GdFieldGet("Z00_LOCAL",oGetDados:oBrowse:nAt,,oGetDados:aHeader,oGetDados:aCols)
Local cPath		:= AllTrim(GetTempPath())
Local lCopia	:= .F.

If File(cPathFile)
	cNameFile	:= Directory( cPathFile )[1][1]
	
	If Substr(cPath, 1, 2) == '\\'
		cPath	:= StrTran( AllTrim(cPath)+'\', '\\', '\' )
		cPath 	:= '\' + cPath
	Else
		cPath	:= StrTran( AllTrim(cPath)+'\', '\\', '\' )
	EndIf
	
	Processa( { || lCopia := CpyS2T( cPathFile,cPath, .T. )},"Download de Arquivo para Visualizacao","Aguarde... Efetuando Download de Arquivo" )
	If lCopia
		ShellExecute("Open",cPath+cNameFile,"","C:\",1)
	EndIf
EndIf
Return .T.
//-------------------------------------------------------------------
/*/{Protheus.doc} AddTipoDoc
Adiciona um noh no tree em tempo de execucao

@author	Jair Ribeiro
@since		31/07/2015
@version	1.0
@obs		Rotina Especifica
/*/
//-------------------------------------------------------------------
Static Function AddTipoDoc(oTree,oFWLayer,cNumAux,cItemAux,cSeqAux,oGetDados,cTabSX5)
Local cRet		:= ""
Local cTipoDoc	:= ""
If ConPad1( , , ,cTabSX5, , , .F. )
	If oTree:TreeSeek(SX5->X5_CHAVE)
		MsgStop("Item já adicionado na estrutura")
	Else
		oTree:AddItem(SX5->X5_DESCRI,;
		SX5->X5_CHAVE,;
		'FOLDER7.PNG',;
		'FOLDER8.PNG',;
		1,;
		{|| FReadData(oTree:GetCargo(),oTree,oFWLayer,cNumAux,cItemAux,cSeqAux,oGetDados)},;
		{|| .T.})
		cRet	:= SX5->X5_CHAVE
	EndIf
	
EndIf
Return cRet
//-------------------------------------------------------------------
/*/{Protheus.doc} ExcTipoDoc
Exclui um noh no tree em tempo de execucao

@author		Jair Ribeiro
@since		31/07/2015
@version	1.0
@obs		Rotina Especifica
/*/
//-------------------------------------------------------------------
Static Function ExcTipoDoc(oTree,oFWLayer,cNumAux,cItemAux,cSeqAux,cAliasAux,oGetDados)

If MsgYesNo("Deseja realmente excluir da estrutura o Tipo de Documento em questão? Todos os documentos associados a esta OP e Tipo serão excluidos!")
	Z00->(DbSetOrder(2))
	While Z00->(DbSeek(xFilial("Z00")+cNumAux+cItemAux+cSeqAux+oTree:GetCargo()+cAliasAux))
		If File(Z00->Z00_LOCAL)
			If FERASE(Z00->Z00_LOCAL) != 0
				MsgInfo("Erro ao excluir arquivo no servidor!")
			EndIf
		EndIf
		If RecLock("Z00",.F.)
			Z00->Z00_EXCUSR		:= __cUserId
			Z00->Z00_EXCDT		:= dDataBase
			Z00->Z00_EXCHR		:= SubStr(Time(),1,5)
			Z00->(DbDelete())
			Z00->(MsUnlock())
		EndIf
	EndDo
	oTree:TreeSeek(oTree:GetCargo())
	oTree:DelItem()
EndIf
Return .T.
//-------------------------------------------------------------------
/*/{Protheus.doc} FBuildTree
Cria Tree com os tipo de documentos incluidos para OP em questao

@author		Jair Ribeiro
@since		31/07/2015
@version	1.0
@obs		Rotina Especifica
/*/
//-------------------------------------------------------------------
Static Function FBuildTree(oTree,oFWLayer,cNumAux,cItemAux,cSeqAux,oGetDados,cTabSX5,lComplTree,lProduto,cCodProd,cTipoUso)
Local cQuery 		:= ""
Local cAliasQry		:= ""
Local cFirstNode	:= ""
Local aColsX		:= {}
Local aHeaderX		:= {}
Local aArea	  		:= Getarea()
Local lRet			:= .F.

cQuery := " SELECT DISTINCT"+CRLF
cQuery += " SX5.X5_CHAVE"+CRLF
cQuery += " ,SX5.X5_DESCRI"+CRLF
cQuery += " FROM "+RetSqlName("SX5")+" SX5 "+CRLF
cQuery += " WHERE SX5.X5_TABELA			= '"+ cTabSX5 +"'	"+CRLF


IF cTabSX5 = "_R "
	cQuery += " AND EXISTS (	SELECT 1 FROM  "+RetSqlName("Z00")+" Z00 "+CRLF
	cQuery += " 				WHERE Z00.Z00_TPDOC	= SX5.X5_CHAVE  						"+CRLF
	cQuery += " 				AND Z00.Z00_NUM 	= '"+ cNumAux   		+"' 			"+CRLF
	cQuery += " 				AND Z00.Z00_ITEM 	= '"+ cItemAux 			+"' 			"+CRLF
	cQuery += " 				AND Z00.Z00_SEQUEN 	= '"+ cSeqAux   		+"' 			"+CRLF
	cQuery += " 				AND Z00.Z00_FILIAL 	= '"+ xFilial("Z00")	+"' 			"+CRLF
	cQuery += " 				AND Z00.D_E_L_E_T_	= '"+ Space(1)			+"' 			"+CRLF
	cQuery += " 			) "+CRLF
Else
	If !lComplTree .and. lProduto
		cQuery += " AND EXISTS (	SELECT 1 FROM  "+RetSqlName("Z00")+" Z00 "+CRLF
		cQuery += " 				WHERE Z00.Z00_TPDOC	= SX5.X5_CHAVE  						"+CRLF
		cQuery += " 				AND Z00.Z00_NUM 	= '"+ cNumAux   		+"' 			"+CRLF
		cQuery += " 				AND Z00.Z00_ITEM 	= '"+ cItemAux 			+"' 			"+CRLF
		cQuery += " 				AND Z00.Z00_SEQUEN 	= '"+ cSeqAux   		+"' 			"+CRLF
		cQuery += " 				AND Z00.Z00_FILIAL 	= '"+ xFilial("Z00")	+"' 			"+CRLF
		cQuery += " 				AND Z00.D_E_L_E_T_	= '"+ Space(1)			+"' 			"+CRLF
		cQuery += " 			) "+CRLF
	ElseIf lProduto
		cQuery += " AND EXISTS (	SELECT 1 FROM  "+RetSqlName("Z01")+" Z01 "+CRLF
		cQuery += " 				WHERE Z01.Z01_TPDOC	= SX5.X5_CHAVE  						"+CRLF
		cQuery += " 				AND Z01.Z01_PRODUT 	= '"+ cCodProd 			+"' 			"+CRLF
		cQuery += " 				AND Z01.Z01_TPUSO 	IN ('3','"+ cTipoUso   	+"') 			"+CRLF
		cQuery += " 				AND Z01.Z01_FILIAL 	= '"+ xFilial("Z01")	+"' 			"+CRLF
		cQuery += " 				AND Z01.D_E_L_E_T_	= '"+ Space(1)			+"' 			"+CRLF
		cQuery += " 			) "+CRLF
	EndIf
Endif

cQuery += " AND SX5.D_E_L_E_T_			= '"+ Space(1)			+"' 			"+CRLF

cAliasQry	:= GetNextAlias()

If Select(cAliasQry)>0
	(cAliasQry)->(DbCloseArea())
EndIf

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry)
(cAliasQry)->(DbGoTop())
IncProc('Carregando Estrutura')

While !(cAliasQry)->(EOF())
	If !Empty((cAliasQry)->X5_DESCRI) .and. !Empty((cAliasQry)->X5_CHAVE)
		oTree:AddTree((cAliasQry)->X5_DESCRI,'FOLDER7.PNG','FOLDER8.PNG',(cAliasQry)->X5_CHAVE,;
		{|| FReadData(oTree:GetCargo(),oTree,oFWLayer,cNumAux,cItemAux,cSeqAux,oGetDados)},;
		{|| .T.})
		lRet := .T.
		oTree:EndTree()
		IncProc()
	EndIf
	(cAliasQry)->(DbSkip())
EndDo
(cAliasQry)->(DbCloseArea())
RestArea(aArea)
Return lRet
//-------------------------------------------------------------------
/*/{Protheus.doc} FReadData
Preenche MsGetdados de acordo com item posicionado no tree

@author		Jair Ribeiro
@since		31/07/2015
@version	1.0
@obs		Rotina Especifica
/*/
//-------------------------------------------------------------------
Static Function FReadData(cNodeAtu,oTree,oFWLayer,cNumAux,cItemAux,cSeqAux,oGetDados)
Local nI			:= 0
Local aHeaderX 		:= {}
Local aColsX		:= {}
Local aNoFields		:= {}
Local cFiltroX		:= ""
Local aArea			:= Getarea()

If oGetDados != Nil .and. cNodeAtu != Nil
	aHeaderX	:= aClone(oGetDados:aHeader)
	aAdd(aNoFields,"Z00_NUM")
	aAdd(aNoFields,"Z00_ITEM")
	aAdd(aNoFields,"Z00_SEQUEN")
	
	cFiltroX +=  " AND Z00_NUM	 	= '"+cNumAux				+"'"+CRLF
	cFiltroX +=  " AND Z00_ITEM	 	= '"+cItemAux		   		+"'"+CRLF
	cFiltroX +=  " AND Z00_SEQUEN	= '"+cSeqAux				+"'"+CRLF
	cFiltroX +=  " AND Z00_TPDOC	= '"+cNodeAtu				+"'"+CRLF
	
	lEdit := xRetGdSql(aHeaderX,aColsX,"Z00",0,aNoFields,cFiltroX,.F.,.F.)
	oGetDados:aCols := aClone(aColsX)
	oGetDados:oBrowse:Refresh()
EndIf
RestArea(aArea)

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

If nOpcX != 3
	cQuery := " SELECT "+cAlias+"_FILIAL "+CRLF
	
	For nI := 1 To Len(aHeaderX)
		If aHeaderX[nI,10] != "V" .and. Alltrim(aHeaderX[nI,3]) != "@BMP"
			cQuery += " ,"+aHeaderX[nI,2]+CRLF
		ElseIf "_REC_WT" $ aHeaderX[nI,2]
			cQuery += " ,R_E_C_N_O_"+CRLF
		EndIf
	Next nI
	
	cQuery += " FROM "+RetSqlName(cAlias)+" "+cAlias
	cQuery += " WHERE "+cAlias+"_FILIAL = 	'" + xFilial(cAlias)	+"' 			"+CRLF
	cQuery += " AND "+cAlias+".D_E_L_E_T_= 	'" + Space(1)			+"' 			"+CRLF
	cQuery += cFiltroX
	cQuery += " ORDER BY "+SqlOrder((cAlias)->(IndexKey(1)))
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.F.)
	
	For nI := 1 To Len(aHeaderX)
		If aHeaderX[nI,8] != "C" .and. !("_REC_WT" $ aHeaderX[nI,2])
			TcSetField(cAliasQry,aHeaderX[nI,2],aHeaderX[nI,8],aHeaderX[nI,4],aHeaderX[nI,5])
		EndIf
	Next nI
	
	(cAliasQry)->(DbGoTop())
	While !(cAliasQry)->(EOF())
		aAdd(aColsX,Array(Len(aHeaderX)+1))
		nCols ++
		For nI := 1 To Len(aHeaderX)
			If (aHeaderX[nI][10] != "V") .and. AllTrim(aHeaderX[nI,3]) != "@BMP"
				aColsX[nCols][nI] := (cAliasQry)->&(aHeaderX[nI][2])
				M->&(aHeaderX[nI][2]) := aColsX[nCols][nI]
			ElseIf "_REC_WT" $ aHeaderX[nI,2]
				aColsX[nCols][nI] 		:= (cAliasQry)->R_E_C_N_O_
			ElseIf AllTrim(aHeaderX[nI,3]) == "@BMP"
				aColsX[nCols][nI] 		:= BNO
			ElseIf lCriaVar
				aColsX[nCols][nI] 		:= CriaVar(aHeaderX[nI][2],.T.)
				M->&(aHeaderX[nI][2])	:= aColsX[nCols][nI]
			EndIf
		Next nI
		aColsX[nCols][Len(aHeaderX)+1] := .F.
		(cAliasQry)->(DbSkip())
	EndDo
	(cAliasQry)->(DbCloseArea())
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
