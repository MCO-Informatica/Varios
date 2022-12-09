#Include "RwMake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"                 

#DEFINE CRLF CHR(13)+CHR(10)
                                                                                                                                         
/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: MT103NFE  | Autor: Celso Ferrone Martins  | Data: 28/10/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | PE para Ajuste de Notas do Tipo CTE referente a NF de Saida|||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

User Function MA103BUT()

Local aButCte := {}               
Private lOCenXml := IsInCallStack("U_CENTNFEXM") //Origem via central xml?

If lOcenXml      
	Private nPosNFOr := aScan(aHeader,{|x| Alltrim(x[2])=="D1_NFORI"}) 	// Nota Fiscal de Origem vinda da Central via aHeader - utilizado no acols 
	Private nPosNFSO := aScan(aHeader,{|x| Alltrim(x[2])=="D1_SERIORI"}) 	// Serie da Nota Fiscal de Origem vinda da Central via aHeader - utilizado no acols 
	U_CfmCteNfs("Central",.T.)
Else
	Private lDeletNF := .F.
EndIf

	aAdd( aButCte, { "BAR" ,{ || U_CfmCteNfs("", .F.) }, "CTE Nfe Saida"} )
//
If !Inclui .And. !Altera
	aAdd( aButCte, { "BAR" ,{ || U_EntFispq() } , "Etiq. FISPQ"  } )
EndIf

Return(aButCte)

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: CfmCteNfs | Autor: Celso Ferrone Martins  | Data: 28/10/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | PE para Ajuste de Notas do Tipo CTE referente a NF de Saida|||
||+-----------+------------------------------------------------------------+||
||| Alterado Por| Autor: Danilo Alves Del Busso         | Data: 11/11/2016 |||
||+-----------+---------+-------------------------------+------------------+||
||| Alteracao | Adicionados os parametros cOrigem (indica a origem de 	   |||
|||			  |	de chamada) e lFilNFO ( .T. indica se deve filtrar apenas a|||   
|||			  | nota de origem passada pela central ou .F. para filtrar    |||
|||			  | todas							                           |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

User Function CfmCteNfs(cOrigem, lFilNFO)

Local aStruct   := {}
Local aCampos   := {}
Local cArqTrab1 := ""
Local cKey1     := ""
//Local cKey2     := ""
//Local cKey3     := ""
Local cIndTab1  := ""
//Local cIndTab2  := ""
//Local cIndTab3  := ""
Private cMarca    := GetMark()
Private cAliasSEL := "TMPSEL"
Private lInverte  := .F.							// Flag de invers?o de sele¡?o
Private cCodTrans := ""
Private cEol      := CHR(13)+CHR(10)        
Private lOCenXml := IsInCallStack("U_CENTNFEXM")

If (!AllTrim(cEspecie) $ "CTE|NFS" .Or. cTipo != "N" .Or. Empty(cA100For) .Or. Empty(cLoja)) .And. !lOCenXml 
	MsgAlert("Rotina especifica para Conhecimento de Frete."+cEol+cEol+;
	"Tipo da Nota -> Normal          "   +cEol+ ;
	"Espec.Docum. -> CTE ou NFS"         +cEol+ ;
	"Campo Fornecedor/Loja -> Prenchido" +cEol  ;
	,"Atencao!!!")
	Return()
EndIf

If !Inclui .And. !Altera
	lContCte := .T.
	aAreaSf8 := SF8->(GetArea())
	DbSelectArea("SF8") ; DbSetOrder(1)
	If SF8->(DbSeek(xFilial("SF8")+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))
		lContCte := .F.
	EndIf
	SF8->(RestArea(aAreaSf8))
	If !lContCte
		MsgAlert("Rotina especifica para Conhecimento de Frete de Nota de Saida."+cEol+cEol+;
		"Complemento de frete refernte a Nota de Entrada."+cEol;
		,"Atencao!!!")
		Return()
	EndIf
EndIf

DbSelectArea("SF2") ; DbSetOrder(1)

aAdd(aStruct,{"F2_OK"      ,"C" ,02,0 })
aAdd(aStruct,{"F2_DOC"     ,"C" ,09,0 })
aAdd(aStruct,{"F2_SERIE"   ,"C" ,03,0 })
aAdd(aStruct,{"F2_CLIENT"  ,"C" ,06,0 })
aAdd(aStruct,{"A1_NOME"    ,"C" ,30,0 })
aAdd(aStruct,{"F2_LOJA"    ,"C" ,02,0 })
aAdd(aStruct,{"F2_EMISSAO" ,"D" ,08,0 })
aAdd(aStruct,{"F2_TRANSP"  ,"C" ,06,0 })
aAdd(aStruct,{"F2_VALBRUT" ,"N" ,18,2 })
aAdd(aStruct,{"F2_VQ_FVAL" ,"N" ,18,2 })

If Inclui .Or. Altera .Or. lOCenXml
	aAdd(aCampos,{"F2_OK"      ,"" ," "          ,"@!" })
EndIf
aAdd(aCampos,{"F2_DOC"     ,"" ,"Nota"       ,"@!" })
aAdd(aCampos,{"F2_SERIE"   ,"" ,"Serie"      ,"@!" })
aAdd(aCampos,{"F2_CLIENT"  ,"" ,"Cliente"    ,"@!" })
aAdd(aCampos,{"A1_NOME"    ,"" ,"Nome"       ,"@!" })
aAdd(aCampos,{"F2_LOJA"    ,"" ,"Loja"       ,"@!" })
aAdd(aCampos,{"F2_EMISSAO" ,"" ,"Emissao"    ,"@!" })
aAdd(aCampos,{"F2_TRANSP"  ,"" ,"Transp."    ,"@!" })
aAdd(aCampos,{"F2_VALBRUT" ,"" ,"Valor Nf."  ,"@E 999,999,999,999.99" })
aAdd(aCampos,{"F2_VQ_FVAL" ,"" ,"Valor Frete","@E 999,999,999,999.99" })

cKey1 := "F2_DOC+F2_SERIE"
//cKey2 := "F2_CODVQ1"
//cKey3 := "ORDEM+F2_COD"

If Select(cAliasSEL) > 0
	(cAliasSEL)->(dbCloseArea())
EndIf

cArqTrab1 := CriaTrab(aStruct, .T.)
dbUseArea(.T.,, cArqTrab1 ,cAliasSEL, .F.,.F. )
dbSelectArea(cAliasSEL)

cIndTab1 := cArqTrab1+"A"
//cIndTab2 := cArqTrab1+"B"
//cIndTab3 := cArqTrab1+"C"

IndRegua(cAliasSEL,cIndTab1,cKey1,,,"Ordenando Arquivo de trabalho !!!")         

//IndRegua(cAliasSEL,cIndTab2,cKey2,,,"Ordenando Arquivo de trabalho !!!")
//IndRegua(cAliasSEL,cIndTab3,cKey3,,,"Ordenando Arquivo de trabalho !!!")

(cAliasSEL)->(dbClearIndex())
(cAliasSEL)->(dbSetIndex(cIndTab1+OrdBagExt()))
//(cAliasSEL)->(dbSetIndex(cIndTab2+OrdBagExt()))
//(cAliasSEL)->(dbSetIndex(cIndTab3+OrdBagExt()))

CfmCarrega(cOrigem, lFilNFO) // Carrega temporario

If !lFilNFO                                                     
	Define MsDialog oDlgFil Title "Notas Fiscais" From 001,001 To 438,900 Of oMainWnd Pixel
	
	oDlgFil:lEscClose := .F. // Desabilita fechar apertando a tecla escape ESC.
	
	oMark  := MsSelect():New(cAliasSEL,"F2_OK",,aCampos,@lInverte,cMarca,{001, 001, 200, 450})
	ObjectMethod(oMark:oBrowse,"Refresh()")
	oMark:bMark := {|| fRegSel()}
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	oMark:oBrowse:bAllMark := {|| fMarkAll()}
	//oMark:oBrowse:bHeaderClick := {|obj,col| fOrdTemp(obj,col)}
	
	If Inclui .Or. Altera .Or. lOCenXml
		
		@ 020,001 Button "CTE Complementar"  		Size 050,015 Action fCfmConPad()
//		@ 020,015 Button "Incluir NF Aljan" Size 050,015 Action fNfAljan()
	EndIf
	@ 020,086 Button "OK"       Size 050,015 Action fDefSel(.T.)
	@ 020,100 Button "Cancelar" Size 050,015 Action fDefSel(.F.)
	
	Activate MsDialog oDlgFil Centered   
Else
	fAtualiza()
EndIf
	
Return()

/*
================================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+--------------------------------+------------------+||
||| Programa: fCfmConPad | Autor: Celso Ferrone Martins   | Data: 24/05/2014 |||
||+-----------+----------+--------------------------------+------------------+||
||| Descricao |                                                              |||
||+-----------+--------------------------------------------------------------+||
||| Alteracao |                                                              |||
||+-----------+--------------------------------------------------------------+||
||| Uso       |                                                              |||
||+-----------+--------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
================================================================================
*/
Static Function fCfmConPad()

Local lRet := .F.
//Local cFilSf2 := "F2_TRANSP=='"+cCodTrans+"'"
Local cFilSf2 := "F2_TRANSP$'"+cCodTrans+"'"
DbSelectArea("SF2") 
Set Filter To &cFilSf2

lRet := ConPad1(,,,"SF2",,,.F.)

Set Filter To

If lRet

	If Len(aCfmDaCte) == 0
		aAdd(aCfmDaCte,{cEspecie,cTipo,cA100For,cLoja})
		aAdd(aCfmDaCte,{})
	EndIf

	If !(cAliasSEL)->(DbSeek(SF2->(F2_DOC+F2_SERIE)))
	
		aCteAux := {}
		
		aAdd(aCfmDaCte[2],{;
		Space(2)        ,; // 01 - OK
		SF2->F2_DOC     ,; // 02 - F2_DOC
		SF2->F2_SERIE   ,; // 03 - F2_SERIE
		SF2->F2_CLIENT  ,; // 04 - F2_CLIENT
		SF2->F2_LOJA    ,; // 05 - F2_LOJA
		SF2->F2_EMISSAO ,; // 06 - F2_EMISSAO
		SF2->F2_TRANSP  ,; // 07 - F2_TRANSP
		SF2->F2_VALBRUT ,; // 08 - F2_VALBRUT
		SF2->F2_VQ_FVAL ,; // 09 - F2_VQ_FVAL
		SF2->F2_TIPO    ,; // 10 - F2_TIPO
		"S"              ; // 11 - CTE COMPLEMENTAR
		})
		
		RecLock(cAliasSEL,.T.)
		(cAliasSEL)->F2_OK      := Space(2)        // 01 - OK
		(cAliasSEL)->F2_DOC     := SF2->F2_DOC     // 02 - F2_DOC
		(cAliasSEL)->F2_SERIE   := SF2->F2_SERIE   // 03 - F2_SERIE
		(cAliasSEL)->F2_CLIENT  := SF2->F2_CLIENT  // 04 - F2_CLIENT
		(cAliasSEL)->F2_LOJA    := SF2->F2_LOJA    // 05 - F2_LOJA
		(cAliasSEL)->A1_NOME    := Posicione("SA1",1,xFilial("SA1")+SF2->(F2_CLIENT+F2_LOJA),"A1_NOME")
		(cAliasSEL)->F2_EMISSAO := SF2->F2_EMISSAO // 06 - F2_EMISSAO
		(cAliasSEL)->F2_TRANSP  := SF2->F2_TRANSP  // 07 - F2_TRANSP
		(cAliasSEL)->F2_VALBRUT := SF2->F2_VALBRUT // 08 - F2_VALBRUT
		(cAliasSEL)->F2_VQ_FVAL := SF2->F2_VQ_FVAL // 09 - F2_VQ_FVAL
		MsUnLock()

	EndIf
	(cAliasSEL)->(DbGoTop())
EndIf

Return(lRet)

/*
================================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+--------------------------------+------------------+||
||| Programa: fNfAljan   | Autor: Nelson Junior           | Data: 05/01/2015 |||
||+-----------+----------+--------------------------------+------------------+||
||| Descricao |                                                              |||
||+-----------+--------------------------------------------------------------+||
||| Alteracao |                                                              |||
||+-----------+--------------------------------------------------------------+||
||| Uso       |                                                              |||
||+-----------+--------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
================================================================================
*/

Static Function fNfAljan()

Local aParamBox	:= {}
Local aRet		:= {}
Local lRet

If Len(aCfmDaCte) == 0
	aAdd(aCfmDaCte,{cEspecie,cTipo,cA100For,cLoja})
	aAdd(aCfmDaCte,{})
EndIf

aAdd(aParamBox,{1,"Documento"		,Space(TamSX3("F2_DOC"   )[1])	,PesqPict("SF2","F2_DOC"	),"",""   ,"",TamSX3("F2_DOC"    )[1]	,.T.})
aAdd(aParamBox,{1,"Série"			,Space(TamSX3("F2_SERIE" )[1])	,PesqPict("SF2","F2_SERIE"	),"",""   ,"",TamSX3("F2_SERIE"  )[1]	,.T.})
aAdd(aParamBox,{1,"Cliente"			,Space(TamSX3("F2_CLIENT")[1])	,PesqPict("SF2","F2_CLIENT"	),"","SA1","",TamSX3("F2_CLIENT" )[1]	,.T.})
aAdd(aParamBox,{1,"Loja"			,Space(TamSX3("F2_LOJA"  )[1])	,PesqPict("SF2","F2_LOJA"	),"",""   ,"",TamSX3("F2_LOJA"   )[1]	,.T.})
aAdd(aParamBox,{1,"Emissão"			,CtoD("  /  /    ")				,PesqPict("SF2","F2_EMISSAO"),"",""   ,"",TamSX3("F2_EMISSAO")[1]+40,.T.})
aAdd(aParamBox,{1,"Transportadora"	,Space(TamSX3("F2_TRANSP")[1])	,PesqPict("SF2","F2_TRANSP"	),"","SA4","",TamSX3("F2_TRANSP" )[1]	,.T.})           
aAdd(aParamBox,{1,"Valor Total"		,000000.00						,PesqPict("SF2","F2_VALBRUT"),"",""   ,"",TamSX3("F2_VALBRUT")[1]+50,.T.})
aAdd(aParamBox,{1,"Valor Frete"		,000000.00						,PesqPict("SF2","F2_VQ_FVAL"),"",""   ,"",TamSX3("F2_VQ_FVAL")[1]+50,.T.})

If ParamBox(aParamBox,"NF Aljan",@aRet)
	//
	aAdd(aCfmDaCte[2],{;
	Space(2)	,; // 01 - OK
	aRet[1]     ,; // 02 - F2_DOC
	aRet[2]		,; // 03 - F2_SERIE
	aRet[3]		,; // 04 - F2_CLIENT
	aRet[4]		,; // 05 - F2_LOJA
	aRet[5]		,; // 06 - F2_EMISSAO
	aRet[6]		,; // 07 - F2_TRANSP
	aRet[7]		,; // 08 - F2_VALBRUT
	aRet[8]		,; // 09 - F2_VQ_FVAL
	"V"			,; // 10 - NF DE SAÍDA DO ALJAN
	"N"         ,; // 11 - CTE COM NF DE SAÍDA DO ALJAN
	})
	//
	RecLock(cAliasSEL,.T.)
		(cAliasSEL)->F2_OK      := Space(2)     // 01 - OK
		(cAliasSEL)->F2_DOC     := aRet[1]    	// 02 - F2_DOC
		(cAliasSEL)->F2_SERIE   := aRet[2]  	// 03 - F2_SERIE
		(cAliasSEL)->F2_CLIENT  := aRet[3]  	// 04 - F2_CLIENT
		(cAliasSEL)->F2_LOJA    := aRet[4]   	// 05 - F2_LOJA
		(cAliasSEL)->A1_NOME    := Posicione("SA1",1,xFilial("SA1")+aRet[3]+aRet[4],"A1_NOME")
		(cAliasSEL)->F2_EMISSAO := aRet[5] 		// 06 - F2_EMISSAO
		(cAliasSEL)->F2_TRANSP  := aRet[6]  	// 07 - F2_TRANSP
		(cAliasSEL)->F2_VALBRUT := aRet[7] 		// 08 - F2_VALBRUT
		(cAliasSEL)->F2_VQ_FVAL := aRet[8] 		// 09 - F2_VQ_FVAL
	(cAliasSEL)->(MsUnLock())
	//	
	(cAliasSEL)->(DbGoTop())
	//	
	lRet := .T.
	//
Else
	//
	lRet := .F.
	//
EndIf

Return(lRet)


/*
=============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+------------------------------+------------------+||
||| Programa: fOrdTemp  | Autor: Celso Ferrone Martins | Data: 17/04/2014 |||
||+-----------+---------+------------------------------+------------------+||
||| Descricao | Organiza MsSelect. Altera o indice de selecao             |||
||+-----------+-----------------------------------------------------------+||
||| Alteracao |                                                           |||
||+-----------+-----------------------------------------------------------+||
||| Uso       |                                                           |||
||+-----------+-----------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
=============================================================================
*/
Static Function fOrdTemp(obj, col)

If col != 1
	
	Do Case
		Case col == 2
			DbSelectArea(cAliasSEL) ; DbSetOrder(1)
		Case col == 3
			DbSelectArea(cAliasSEL) ; DbSetOrder(2)
			//		Case col == 4
			//			DbSelectArea(cAliasSEL) ; DbSetOrder(3)
	EndCase
	
	(cAliasSEL)->(DbGoTop())
	
	oMark:oBrowse:Refresh(.T.)
	oDlgFil:Refresh()
	
EndIf

Return()

/*
============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+------------------------------+------------------+||
||| Programa: fRegSel  | Autor: Celso Ferrone Martins | Data: 17/04/2014 |||
||+-----------+--------+------------------------------+------------------+||
||| Descricao | Seleciona itens do MsSelect                              |||
||+-----------+----------------------------------------------------------+||
||| Alteracao |                                                          |||
||+-----------+----------------------------------------------------------+||
||| Uso       |                                                          |||
||+-----------+----------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
============================================================================
*/
Static Function fRegSel()

Local lRet := .T.

If Marked("F2_OK")
	RecLock(cAliasSEL,.F.)
	(cAliasSEL)->F2_OK := cMarca
	(cAliasSEL)->(MsUnlock())
Else
	RecLock(cAliasSEL,.F.)
	(cAliasSEL)->F2_OK := "  "
	(cAliasSEL)->(MsUnlock())
Endif

oMark:oBrowse:Refresh(.t.)
oDlgFil:Refresh()

Return(lRet)

/*
============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+--------------------+------------------------------+------------------+||
||| Programa: fMarkAll | Autor: Celso Ferrone Martins | Data: 17/04/2014 |||
||+-----------+--------+------------------------------+------------------+||
||| Descricao | Marca todos os registros do MsSelect                     |||
||+-----------+----------------------------------------------------------+||
||| Alteracao |                                                          |||
||+-----------+----------------------------------------------------------+||
||| Uso       |                                                          |||
||+-----------+----------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
============================================================================
*/
Static Function fMarkAll()

Local nREC  := (cAliasSEL)->(Recno())
Local lRet  := .T.
Local lMack := .T.

(cAliasSEL)->(DbGoTop())
While !(cAliasSEL)->(EOF())
	RecLock(cAliasSEL,.F.)
	If Empty((cAliasSEL)->F2_OK)
		(cAliasSEL)->F2_OK := cMarca
		lMack := .T.
	Else
		(cAliasSEL)->F2_OK := "  "
		lMack := .F.
	Endif
	(cAliasSEL)->(MsUnlock())
	
	(cAliasSEL)->(DbSkip())
EndDo

(cAliasSEL)->(DbGoTo(nREC))
oMark:oBrowse:Refresh(.t.)
oDlgFil:Refresh()

Return(lRet)

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: fDefSel   | Autor: Celso Ferrone Martins  | Data: 17/04/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | Define selecao. Encerra ou atualiza                        |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function fDefSel(lRet)

Local lEncerra := .F.
Default lRet   := .F.

If lRet
	//	If MsgYesNo("Deseja recalcular os itens selecionados ?","Atencao!")
	If lRet
		fAtualiza()
	EndIf
	lEncerra := .T.
	//	EndIf
Else
	lEncerra := .T.
EndIf

If lEncerra
	If Select(cAliasSEL) > 0
		(cAliasSEL)->(dbCloseArea())
	EndIf
	Close(oDlgFil)
EndIf

Return(.F.)


/*
===============================================================================
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+-------------------------------+------------------+||
||| Programa: CfmCarrega | Autor: Celso Ferrone Martins  | Data: 23/09/2014 |||
||+-----------+----------+-------------------------------+------------------+||
||| Descricao | Carrega TMP                                                 |||
||+-----------+-------------------------------------------------------------+||
||| Alteracao |                                                             |||
||+-----------+-------------------------------------------------------------+||
||| Uso       |                                                             |||
||+-----------+-------------------------------------------------------------+||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
===============================================================================
*/

Static Function CfmCarrega(cOrigem, lFilNFO)
            
Local cMsg := "Verificamos que voce ja efetuou essa pesquisa, deseja filtrar com os mesmos parametros?"
Local cCaption := "Aviso: Parametros ja definidos"	  

Local lAchouCte := .F.
Local aCteAux   := {}
Local aAreaSa2  := SA2->(GetArea())
Local aAreaSa4  := SA4->(GetArea())    

Private aCodTrans := {}   
Private aNFSearch := {}  
Private	cNFAtr := ""  
Private	cNotas := ""

DbSelectArea("SA2") ; DbSetOrder(1)
DbSelectArea("SA4") ; DbSetOrder(3) // Filial + CGC   


If !lOcenXml      
	Private lDeletNF := .F.
EndIf

/*
If SA2->(DbSeek(xFilial("SA2")+cA100For+cLoja))
	If SA4->(DbSeek(xFilial("SA4")+SA2->A2_CGC))
		lAchouCte := .T.
		cCodTrans := SA4->A4_COD
	EndIf
EndIf
*/

//Alteração para tratar apenas a raiz do CNPJ da Transportadora - ARMI - Nelson Junior
If SA2->(DbSeek(xFilial("SA2")+cA100For+cLoja))
	If SA4->(DbSeek(xFilial("SA4")+Left(SA2->A2_CGC,8)))
		lAchouCte := .T.
		While !SA4->(EoF()) .And. Left(SA2->A2_CGC,8) == Left(SA4->A4_CGC,8)
			aaDD(aCodTrans, SA4->A4_COD)
			SA4->(DbSkip())
		EndDo
		//
		For i := 1 To Len(aCodTrans)
			If i <> 1
				cCodTrans += "/"+aCodTrans[i]
			Else
				cCodTrans += aCodTrans[i]
			EndIf
		Next
	EndIf
EndIf

If !lAchouCte
	aCfmDaCte := {}
	Return()
EndIf

If Len(aCfmDaCte) > 0   	
	If   aCfmDaCte[1][1] != cEspecie ;
		.Or. aCfmDaCte[1][2] != cTipo    ;
		.Or. aCfmDaCte[1][3] != cA100For ;
		.Or. aCfmDaCte[1]	[4] != cLoja
		aCfmDaCte := {} 
	Else
		If !ApMsgNoYes(cMsg, cCaption)         
				aCfmDaCte := {}   
		EndIf 	 
	EndIf
EndIf

(cAliasSEL)->(DbGoTop())
While !(cAliasSEL)->(Eof())
	RecLock(cAliasSEL,.F.)
	(cAliasSEL)->(DbDelete())
	MsUnLock()
	(cAliasSEL)->(DbSkip())
EndDo

 If Len(aCfmDaCte) == 0	
	If (Inclui .Or. Altera .Or. lOCenXml) .And. !lDeletNF //lDeletNF variavel da central responsavel pela exclusao
		If !lFilNFO
			Pergunte("CTEPERIODO",.T.)
		EndIf
		cQuery := " SELECT * FROM " + RetSqlName("SF2") + " SF2 "
		//Tratativa CNPJ
		cQuery += "    INNER JOIN " + RetSqlName("SA4") + " SA4 ON "
		cQuery += "       SA4.D_E_L_E_T_ <> '*' "
		cQuery += "       AND F2_TRANSP = A4_COD "
		//
		cQuery += " WHERE "
		cQuery += "    SF2.D_E_L_E_T_ <> '*' "
		cQuery += "    AND SF2.F2_FILIAL = '" + xFilial("SF2") + "' "

		If !lFilNFO
			cQuery += "    AND SF2.F2_EMISSAO BETWEEN '"+DTos(MV_PAR01)+"' 	AND '"+DTos(MV_PAR02)+"' "
			cQuery += "    AND SF2.F2_DOC     BETWEEN '"+MV_PAR03+"' 		AND '"+MV_PAR04+"' "
		Else                                     
			For nX := 1 To Len(aCols) 
				If(nX == 1)
					cNFAtr += "'"+PADL(aCols[nX,nPosNFOr],9,'0') + "'"
				Else
					cNFAtr += ",'" + PADL(aCols[nX,nPosNFOr],9,'0') + "'"  
				EndIf 
				AADD(aNFSearch,aCols[nX,nPosNFOr]) 
				cNotas += PADL(aCols[nX,nPosNFOr],9,'0') + CRLF
			Next
			cQuery += "   AND SF2.F2_DOC IN("+cNFAtr+")" 		
		EndIf
	//	cQuery += "    AND SF2.F2_TRANSP IN ('" + StrTran(cCodTrans,"/","','") + "') "
	//	cQuery += "    AND SF2.F2_DOC+SF2.F2_SERIE NOT IN ( "
	//	cQuery += "       SELECT Z11_DOCORI+Z11_SERORI FROM " + RetSqlName("Z11") + " Z11 "
	//	cQuery += "       WHERE " 
	//	cQuery += "          Z11.D_E_L_E_T_ <> '*' " 
	//	cQuery += "          AND Z11.Z11_TRANSP IN ('" + StrTran(cCodTrans,"/","','") + "') "
	//  cQuery += "          AND Z11_DOCORI <> ' ' "
	//	cQuery += "    ) "            
	Else
		cQuery := " SELECT * FROM " + RetSqlName("SF2") + " SF2 "
		//Tratativa CNPJ
		cQuery += "    INNER JOIN " + RetSqlName("SA4") + " SA4 ON "
		cQuery += "       SA4.D_E_L_E_T_ <> '*' "
		cQuery += "       AND F2_TRANSP = A4_COD "
	//	cQuery += "       AND F2_EMISSAO BETWEEN '"+DTos(MV_PAR01)+"' AND '"+DTos(MV_PAR02)+"' "
	//	cQuery += "       AND F2_DOC     BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
		//
		cQuery += "    INNER JOIN " + RetSqlName("Z11") + " Z11 ON "
		cQuery += "       Z11.D_E_L_E_T_ <> '*' "
		cQuery += "       AND Z11_FILIAL = F2_FILIAL "
		cQuery += "       AND Z11_DOCORI = F2_DOC "
		cQuery += "       AND Z11_SERORI = F2_SERIE "
		cQuery += "       AND Z11_DOC    = '" + SF1->F1_DOC     + "' "
		cQuery += "       AND Z11_SERIE  = '" + SF1->F1_SERIE   + "' "
		cQuery += "       AND Z11_CLIFOR = '" + SF1->F1_FORNECE + "' "
		cQuery += "       AND Z11_LOJA   = '" + SF1->F1_LOJA    + "' "
		cQuery += " WHERE "
		cQuery += "    SF2.D_E_L_E_T_ <> '*' "
//		cQuery += "    AND SF2.F2_TRANSP  = '" + SA4->A4_COD + "' "
		cQuery += "    AND SF2.F2_TRANSP IN ('" + StrTran(cCodTrans,"/","','") + "') "
	EndIf
	
	MemoWrite("C:\temp\MA103BUT.txt",cQuery)

	If Select("TMPSF2") > 0
		TMPSF2->(DbCloseArea())
	EndIf
	
	TcQuery cQuery New Alias "TMPSF2"
	
	//	DbSelectArea("TMPSF2")
	While !TMPSF2->(Eof())
		
		If Len(aCfmDaCte) == 0
			aAdd(aCfmDaCte,{cEspecie,cTipo,cA100For,cLoja})
		EndIf
		
		aAdd(aCteAux,{;
		Space(2)                 ,; // 01 - OK
		TMPSF2->F2_DOC           ,; // 02 - F2_DOC
		TMPSF2->F2_SERIE         ,; // 03 - F2_SERIE
		TMPSF2->F2_CLIENT        ,; // 04 - F2_CLIENT
		TMPSF2->F2_LOJA          ,; // 05 - F2_LOJA
		Stod(TMPSF2->F2_EMISSAO) ,; // 06 - F2_EMISSAO
		TMPSF2->F2_TRANSP        ,; // 07 - F2_TRANSP
		TMPSF2->F2_VALBRUT       ,; // 08 - F2_VALBRUT
		TMPSF2->F2_VQ_FVAL       ,; // 09 - F2_VQ_FVAL
		TMPSF2->F2_TIPO          ,; // 10 - F2_TIPO
		"N"                       ; // 11 - CTE COMPLEMENTAR
		})
		
		TMPSF2->(DbSkip())
	EndDo

	If Len(aCteAux) > 0
		aAdd(aCfmDaCte,aCteAux)
	EndIf
	
	If Select("TMPSF2") > 0
		TMPSF2->(DbCloseArea())
	EndIf
EndIf

If Len(aCfmDaCte) > 0 
	aNFFound := {}  
	cMensagem := ""
	cNFLocalizada := ""
	cNFNLocalizada := ""

	If Len(aCfmDaCte[2]) > 0	
		For nX := 1 To Len(aCfmDaCte[2])
			RecLock(cAliasSEL,.T.) 
			If !lFilNFO
				(cAliasSEL)->F2_OK      := If(!Empty(aCfmDaCte[2][nX][1]),cMarca,Space(2)) // 01 - OK   
			Else
				(cAliasSEL)->F2_OK      := cMarca // 01 - OK				
			EndIf      
			(cAliasSEL)->F2_DOC     := aCfmDaCte[2][nX][2] // 02 - F2_DOC
			(cAliasSEL)->F2_SERIE   := aCfmDaCte[2][nX][3] // 03 - F2_SERIE
			(cAliasSEL)->F2_CLIENT  := aCfmDaCte[2][nX][4] // 04 - F2_CLIENT
			(cAliasSEL)->F2_LOJA    := aCfmDaCte[2][nX][5] // 05 - F2_LOJA
			(cAliasSEL)->A1_NOME    := Posicione("SA1",1,xFilial("SA1")+aCfmDaCte[2][nX][4]+aCfmDaCte[2][nX][5],"A1_NOME")
			(cAliasSEL)->F2_EMISSAO := aCfmDaCte[2][nX][6] // 06 - F2_EMISSAO
			(cAliasSEL)->F2_TRANSP  := aCfmDaCte[2][nX][7] // 07 - F2_TRANSP
			(cAliasSEL)->F2_VALBRUT := aCfmDaCte[2][nX][8] // 08 - F2_VALBRUT
			(cAliasSEL)->F2_VQ_FVAL := aCfmDaCte[2][nX][9] // 09 - F2_VQ_FVAL
			           
			AADD(aNFFound, aCfmDaCte[2][nX][2])
			MsUnLock()
		Next Nx 
		
		If lFilNFO
			For nX := 1 To Len(aNFSearch)
				If Ascan(aNFFound, aNFSearch[nX]) <> 0
					cNFLocalizada 	+= "" + cValToChar(aNFSearch[nX]) + CRLF 
				 Else
					cNFNLocalizada 	+= "" + cValToChar(aNFSearch[nX]) + CRLF 
				EndIf
			Next nX
					
			If !Empty(cNFLocalizada)
				cMensagem += "Esse CT-e já encontra-se atrelado as seguintes notas: " + CRLF + cNFLocalizada + CRLF 
	  		EndIf		                                                                                           
	  		
	  		If !Empty(cNFNLocalizada)
	  			cMensagem += "Não foram localizados registros das notas abaixo informadas pela CENTRAL XML, sendo assim, não foi possível atrelar ao CTE. Confirme a existência da(s) nota(s) no menu AÇÕES RELACIONADAS > CTE NFE SAIDA." + CRLF + CRLF + cNFNLocalizada + CRLF
	  		EndIf        
	  		     
	  		If !lDeletNF
		  		MSGINFO(cMensagem)		      
		  	EndIf
	  	EndIf
	Else
		aCfmDaCte := {}
	EndIf  
Else   
	If !Empty(cNotas)
		Alert("As notas informadas pela CENTRAL XML não foram encontradas, sendo assim, não foi possível atrelar ao CTE. " + CRLF + "Confirme a existência da(s) nota(s) através do menu AÇÕES RELACIONADAS > CTE NFE SAIDA. " + CRLF +  CRLF + " Notas não encontradas: " + CRLF + cNotas)
	End
EndIf

(cAliasSEL)->(DbGoTop())

SA2->(RestArea(aAreaSa2))
SA4->(RestArea(aAreaSa4))

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: fAtualiza | Autor: Celso Ferrone Martins  | Data: 29/10/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function fAtualiza()

(cAliasSEL)->(DbSetOrder(1))
                   
If Len(aCfmDaCte) > 0
	For nX := 1 To Len(aCfmDaCte[2])
		If (cAliasSEL)->(DbSeek(aCfmDaCte[2][nX][2]+aCfmDaCte[2][nX][3]))
			aCfmDaCte[2][nX][1] := (cAliasSEL)->F2_OK
		EndIf
	Next nX
EndIf
	
Return()
