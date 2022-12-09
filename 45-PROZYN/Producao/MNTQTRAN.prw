#include 'protheus.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA |MNTQTRAN  | AUTOR | Nadia Calcic 		          	|USERS    |     	  | DATA | 07/11/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO| Tela para selecao dos itens em transito												    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±|                        ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                            |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±|PROGRAMADOR | DATA   |  CHAMADO  |MOTIVO DA ALTERACAO                                                |±± 
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/ 
User Function MNTQTRAN()
Local oDlgLib      
Local aCoors        := FWGetDialogSize(oMainWnd)   
Local bSet15        := { || Iif( U_ATUQTDB2(), oDlgLib:End() , .F. ) }
Local bSet24        := { || oDlgLib:End() }
Local aBtn          := {}
Local bDialogInit   := { || EnchoiceBar(oDlgLib , bSet15, bSet24 , NIL , aBtn, , , , , .F.  ), NIL, NIL, NIL,NIL 	}   
Local lGrvSB2       := .F.
Local dDtIniTran	:= GetNewPar("PZ_DTINITR",CTOD('21/11/2018'))     

Private cCadastro   := "Liberação Importação"                                             
Private aHeadLib    := {}
Private aColsLib    := {}

HEADERLIB()
MNTITELIB()

If Len(aColsLib) > 0 .And. SF1->F1_DTDIGIT >= dDtIniTran
 
	DEFINE MSDIALOG oDlgLib TITLE "Lib. Importação"  FROM  aCoors[1], aCoors[2] TO (aCoors[3]*0.55), (aCoors[4]*0.50) PIXEL
	
	oGetLib := MsNewGetDados():New( 33, 03, __Dlgheight(oDlgLib)-15,__DlgWidth(oDlgLib), 0 , , , ;
	, , , , , , ,oDlgLib , aHeadLib, aColsLib )   
	
	oGetLib:oBrowse:bLDblClick := {|| Iif(oGetLib:oBrowse:nColPos == aScan(oGetLib:aHeader,{|x| AllTrim(x[2]) == "XMARLIB" } ) , LibMarca(), Nil) }
	
	ACTIVATE MSDIALOG oDlgLib CENTERED ON INIT Eval( bDialogInit ) 
Else
	Aviso("Atenção","Não existe item a ser liberado.",{"Ok"},2)
EndIf

Return()   

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                                   
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA |HEADERLIB | AUTOR | Nadia Calcic 		          	|USERS    |     	  | DATA | 07/11/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO| Funcao para montagem do aheader da tela dos itens da NF								    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±|                        ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                            |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±|PROGRAMADOR | DATA   |  CHAMADO  |MOTIVO DA ALTERACAO                                                |±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                      
Static Function HEADERLIB()
Local aCposSX3 := {'D1_ITEM','D1_COD','D1_QUANT','D1_LOCAL','D1_DOC','D1_SERIE', 'D1_FORNECE', 'D1_LOJA'}
Local nCpo		:= 0

aAdd(aHeadLib,{"Ok","XMARLIB","@BMP",10,0,"","","C","","" })

SX3->(dbSetOrder(2))             

For nCpo := 1 To Len(aCposSX3)
	If SX3->(dbSeek( aCposSX3[nCpo] ))
		Aadd(aHeadLib,{AllTrim(X3TITULO()),;
		SX3->X3_CAMPO,;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		'',;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		/*SX3->X3_F3*/,;
		SX3->X3_CONTEXT,;
		SX3->X3_CBOX,;
		SX3->X3_RELACAO,;
		SX3->X3_WHEN,;
		SX3->X3_VISUAL,;
		'',;
		SX3->X3_PICTVAR,;
		SX3->X3_OBRIGAT})
	EndIf	
Next nCpo

Return(Nil)      
    
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                                   
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA |MNTITELIB | AUTOR | Nadia Calcic 		          	|USERS    |     	  | DATA | 07/11/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO| Funcao para montagem do acols para os itens da NF										    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±|                        ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                            |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±|PROGRAMADOR | DATA   |  CHAMADO  |MOTIVO DA ALTERACAO                                                |±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/    
Static Function MNTITELIB()  
Local cChvPesq := SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
Local nCount	:= 0
dbSelectArea('SD1')
SD1->(dbSetOrder(1)) 
SD1->(dbSeek(xFilial('SD1')+cChvPesq))

DbSelectArea('SF4')
SF4->(dbSetOrder(1)) 

While SD1->(!Eof()) .And. SD1->D1_FILIAL == xFilial('SD1') .And. SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == cChvPesq
	
	If SF4->(dbSeek(xFilial('SF4')+SD1->D1_TES)) .And. SF4->F4_YTRANCQ == 'S'
		Aadd(aColsLib, Array(Len(aHeadLib)+1))
			
		For nCount := 1 To Len(aHeadLib)
			If AllTrim(aHeadLib[nCount,2]) $ "XMARLIB" 
				aColsLib[Len(aColsLib),nCount] := "UNCHECKED"  
		    Else
				aColsLib[Len(aColsLib),nCount] := SD1->&(aHeadLib[nCount,2])
			Endif
		Next nCount
		
		aColsLib[Len(aColsLib),Len(aHeadLib)+1] := .F.
	EndIf
	SD1->(dbSkip())
EndDo                         

Return(Nil) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA |LibMarca  | AUTOR | Nadia Calcic 		          	|USERS    |     	  | DATA | 07/11/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO| Funcao para marcar/desmarcar os itens												        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±|                        ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                            |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±|PROGRAMADOR | DATA   |  CHAMADO  |MOTIVO DA ALTERACAO                                                |±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LibMarca(cTpLib)
Local nPosMOk   := 0    

nPosMOk  := aScan(oGetLib:aHeader,{|x| AllTrim(x[2]) == "XMARLIB" } )

oGetLib:aCols[oGetLib:nAt,nPosMOk]   := Iif(oGetLib:aCols[oGetLib:nAt,nPosMOk]=="UNCHECKED","CHECKED","UNCHECKED")

Return(Nil)           

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                                   
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³PROGRAMA |ATUQTDB2  | AUTOR | Nadia Calcic 		          	|USERS    |     	  | DATA | 07/11/18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO| Funcao para atualizar a qtde da SB2 dos itens selecionados							    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±|                        ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                            |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±|PROGRAMADOR | DATA   |  CHAMADO  |MOTIVO DA ALTERACAO                                                |±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/   
User Function ATUQTDB2()  
Local aAreaAtu 	:= GetArea()
Local lAtuB2   	:= .T.  
Local nPosMOk  	:= aScan(oGetLib:aHeader,{|x| AllTrim(x[2]) == "XMARLIB" 	} ) 
Local nPosCod  	:= aScan(oGetLib:aHeader,{|x| AllTrim(x[2]) == "D1_COD" 	} )
Local nPosQtd  	:= aScan(oGetLib:aHeader,{|x| AllTrim(x[2]) == "D1_QUANT" 	} )  
Local nPosLoc  	:= aScan(oGetLib:aHeader,{|x| AllTrim(x[2]) == "D1_LOCAL" 	} )  
Local nPosItem 	:= aScan(oGetLib:aHeader,{|x| AllTrim(x[2]) == "D1_ITEM" 	} )
Local nPosDoc  	:= aScan(oGetLib:aHeader,{|x| AllTrim(x[2]) == "D1_DOC" 	} )
Local nPosSerie	:= aScan(oGetLib:aHeader,{|x| AllTrim(x[2]) == "D1_SERIE" 	} )
Local nPosForn	:= aScan(oGetLib:aHeader,{|x| AllTrim(x[2]) == "D1_FORNECE"	} )
Local nPosLoja	:= aScan(oGetLib:aHeader,{|x| AllTrim(x[2]) == "D1_LOJA" 	} )
Local nItLib	:= 0
DbSelectArea("SD1")
DbSetOrder(1)

lAtuB2 := ( aScan(oGetLib:aCols,{|x| x[nPosMOk] == "CHECKED"}) > 0 )

If lAtuB2
	dbSelectArea('SB2')  
	SB2->(dbSetOrder(1))
	
	For nItLib := 1 To Len(oGetLib:aCols)
		If oGetLib:aCols[nItLib,nPosMOk] == "CHECKED" 
			If SB2->(dbSeek(xFilial('SB2')+oGetLib:aCols[nItLib,nPosCod]+oGetLib:aCols[nItLib,nPosLoc]))
				RecLock('SB2',.F.)
				SB2->B2_YTRANCQ  := (SB2->B2_YTRANCQ-oGetLib:aCols[nItLib,nPosQtd]) 
				//SB2->B2_QATU  := (SB2->B2_QATU-oGetLib:aCols[nItLib,nPosQtd])
				SB2->(msUnLock())
			EndIf
			
			If SD1->(DbSeek(xFilial("SD1")+;												//Filial
			   		       PadR(oGetLib:aCols[nItLib,nPosDoc], TamSx3("D1_DOC")[1])+;		//Doc
			   		       PadR(oGetLib:aCols[nItLib,nPosSerie], TamSx3("D1_SERIE")[1])+;	//Serie
			   		       PadR(oGetLib:aCols[nItLib,nPosForn], TamSx3("D1_FORNECE")[1])+;	//Fornecedor	
			   		       PadR(oGetLib:aCols[nItLib,nPosLoja], TamSx3("D1_LOJA")[1])+;		//Loja
			   		       PadR(oGetLib:aCols[nItLib,nPosCod], TamSx3("D1_COD")[1])+;		//Codigo do produto
			   		       PadR(oGetLib:aCols[nItLib,nPosItem], TamSx3("D1_ITEM")[1]);		//Item
			   		        ) )
			   	
				RecLock('SD1',.F.)
				SD1->D1_YTRANCQ := SD1->D1_QUANT
				SD1->(MsUnLock())
			
			EndIf
		EndIf
	Next nItLib 
Else
	ApMsgStop("Seleciona algum item.")	
EndIf

RestArea(aAreaAtu)
	
Return(lAtuB2)