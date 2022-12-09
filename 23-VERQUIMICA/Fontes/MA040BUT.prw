#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH" 

#DEFINE CRLF CHR(13)+CHR(10)

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: MA040BUT | Autor: Celso Ferrone Martins  | Data: 07/11/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | PE para incluir botao na Bowse do cadastro de Vendedor     |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
User Function MA040BUT()	

Local _aBotao := {}

aAdd(_aBotao, { "BAR" ,{ ||U_CFMAZ12N() } , "Regiao x Grupo"  } )

Return(_aBotao)
         

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: MTA040MNU | Autor: Celso Ferrone Martins  | Data: 07/11/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | PE para incluir botao na Bowse do cadastro de Vendedor     |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
User Function CFMAZ12N()

//Variáveis da MsNewGetDados()
Local nStyle    := GD_INSERT+GD_UPDATE+GD_DELETE 	// Opção da MsNewGetDados
Local cLinhaOk  := "U_CFMZ12LOKN()"					// Funcao executada para validar o contexto da linha atual do aCols (Localizada no Fonte GS1008)
Local cTudoOk   := "AllwaysTrue"					// Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
Local cTdOkLk   := "AllwaysTrue"					// Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
Local cIniCpos  := ""								// Nome dos campos do tipo caracter que utilizarao incremento automatico.
Local nFreeze   := 000								// Campos estaticos na GetDados.
Local nMax      := 999								// Numero maximo de linhas permitidas.
Local aAlter    := {}	   							// Campos a serem alterados pelo usuario
Local cFieldOk  := "AllwaysTrue"					// Funcao executada na validacao do campo
Local cSuperDel := "AllwaysTrue"					// Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
Local cDelOk    := "AllwaysTrue"					// Funcao executada para validar a exclusao de uma linha do aCols
Local cBChange  := ""

Local aSize     := {}
Local aInfo     := {}
Local aPosObj   := {}
Local aPosGet   := {}
Local aObjects  := {}
Local aNoFields := {"Z12_COD"}

Local cSeek     := xFilial("Z12")+SA3->A3_COD
Local bWhile    := {|| Z12->(Z12_FILIAL+Z12_COD) }
Local cQueryFil := ""
Local nOpc      := 4                

Private _cQuery	:= ""  
Private _nLinha := 0   
Private _cLogZ19 := "DE: "

aSize   := MsAdvSize()

Aadd(aObjects,{100,100,.T.,.T.})
Aadd(aObjects,{100,100,.T.,.T.})
Aadd(aObjects,{100,020,.T.,.T.})

aInfo   := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
aPosObj := MsObjSize(aInfo,aObjects)
aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,263}})

FillGetDados(nOpc,"Z12",1,cSeek,bWhile,/*uSeekFor*/,aNoFields,/*aYesFields*/,/*lOnlyYes*/,/*cQueryFil*/,/*bMontCols*/,If(nOpc==3,.T.,.F.),/*aHeaderAux*/,/*aColsAux*/,/*bAfterCols*/,/*bBeforeCols*/,/*bAfterHeader*/,/*cAliasQry*/,/*bCriaVar*/,/*lUserFields*/,/*lUserFields*/)

Define MsDialog oDlg From aSize[7],000 TO aSize[6],aSize[5] Title "Regiao e Grupo de Vendas" Of oMainWnd Pixel

oDlg:lMaximized := .T.

@ 006,005 Say "Codigo" Object oSay
@ 005,040 Get SA3->A3_COD  Picture "@!" Size 055,030 When .F. Object oA3Cod
@ 005,100 Get SA3->A3_NOME Picture "@!" Size 200,030 When .F. Object oA3Nome

For nX := 1 To Len(aCols) 
	_cLogZ19 += AllTrim(aCols[nX][1])+ "-" + AllTrim(aCols[nX][3]) + "/"
Next

oGrid:=MsNewGetDados():New(aPosObj[1][1]+90,aPosObj[1][2],aPosObj[3][3],aPosObj[3][4],nStyle,cLinhaOk,cTudoOk,cIniCpos,/*aAlter*/,nFreeze,nMax,cFieldOk,cSuperDel,cDelOk,oDlg,aHeader,aCols,cBChange)

Activate MsDialog oDlg On Init EnchoiceBar(oDlg,{||If(CfmTudoOK(nOpc),oDlg:End(),.F.)},{||oDlg:End()},,/*aButtons*/) CENTERED

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: CFMZ12LOK | Autor: Celso Ferrone Martins  | Data: 07/11/2014 |||
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
User Function CFMZ12LOK()

Local lRet := CfmValLin()

Return(lRet)

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: CfmTudoOK | Autor: Celso Ferrone Martins  | Data: 07/11/2014 |||
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
Static Function CfmTudoOK(nOpc)

Local lRet 		 := .T.
Local nPosRegiao := aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z12_REGIAO"})
Local nPosDesReg := aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z12_REGDES"})
Local nPosGrupo  := aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z12_GRUPO"})
Local nPosDesGru := aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z12_GRUDES"})
Local nPosRecno  := aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z12_REC_WT"}) 

lRet := CfmValLin()

If lRet
	If !MsgYesNo("Deseja salvar informacoes ?","Atencao!!!")
		If !MsgYesNo("Deseja sair do sistema ?","Atencao!!!")
			lRet := .F.
		EndIf
	Else         
		_cLogZ19 += " ::::::PARA: "
		For nX := 1 To Len(oGrid:aCols)
			If oGrid:aCols[nX][nPosRecno] > 0
				Z12->(DbGoTo(oGrid:aCols[nX][nPosRecno]))
				RecLock("Z12",.F.)
					If GdDeleted(nX,oGrid:aHeader,oGrid:aCols)
						Z12->(DbDelete())
					Else
						Z12->Z12_REGIAO := oGrid:aCols[nX][nPosRegiao]
						Z12->Z12_REGDES := oGrid:aCols[nX][nPosDesReg]
						Z12->Z12_GRUPO  := oGrid:aCols[nX][nPosGrupo]
						Z12->Z12_GRUDES := oGrid:aCols[nX][nPosDesGru]
						_cLogZ19 += AllTrim(oGrid:aCols[nX][nPosRegiao]) + "-" + AllTrim(oGrid:aCols[nX][nPosGrupo])  + "/"  
					EndIf
				Z12->(MsUnLock())
			ElseIf !GdDeleted(nX,oGrid:aHeader,oGrid:aCols)
				RecLock("Z12",.T.)
				Z12->Z12_FILIAL := xFilial("Z12")
				Z12->Z12_COD    := SA3->A3_COD
				Z12->Z12_REGIAO := oGrid:aCols[nX][nPosRegiao]
				Z12->Z12_REGDES := oGrid:aCols[nX][nPosDesReg]
				Z12->Z12_GRUPO  := oGrid:aCols[nX][nPosGrupo]
				Z12->Z12_GRUDES := oGrid:aCols[nX][nPosDesGru]
				Z12->(MsUnLock())
				_cLogZ19 += AllTrim(oGrid:aCols[nX][nPosRegiao]) + "-" + AllTrim(oGrid:aCols[nX][nPosGrupo])  + "/"  
			EndIf
	 	
		Next nX
		RecLock("Z19",.T.)
			Z19->Z19_FILIAL := xFilial("Z19")			
			Z19->Z19_CODVEN	:= SA3->A3_COD
			Z19->Z19_USRALT := UsrRetName(RetCodUsr())          
			Z19->Z19_HORALT := Time()
			Z19->Z19_DATALT := Date()
			Z19->Z19_HISTOR := _cLogZ19
		Z19->(MsUnlock())
		
		Processa({||DbRemVSa1(SA3->A3_COD)},"Exclusao do Vendedor: " + SA3->A3_COD + " no registro de clientes")
		Processa({||DbIncVSa1(SA3->A3_COD)},"Inclusao do Vendedor: " + SA3->A3_COD + " no registro de clientes")    
		 
		Close(oDlg)
	EndIf
EndIf

Return(lRet)

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: CfmValLin | Autor: Celso Ferrone Martins  | Data: 10/11/2014 |||
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
Static Function CfmValLin()

Local lRet 		 := .T.
Local nPosRegiao := aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z12_REGIAO"})
Local nPosGrupo  := aScan(oGrid:aHeader,{|x|AllTrim(x[2])=="Z12_GRUPO"})

For nX := 1 To Len(oGrid:aCols)
	If !GdDeleted(nX,oGrid:aHeader,oGrid:aCols)
		For nY := 1 To Len(oGrid:aCols)
			If !GdDeleted(nY,oGrid:aHeader,oGrid:aCols)
				If nX != nY
					If oGrid:aCols[nX][nPosRegiao] == oGrid:aCols[nY][nPosRegiao] .And. oGrid:aCols[nX][nPosGrupo] == oGrid:aCols[nY][nPosGrupo]
						lRet := .F.
						MsgAlert("Regiao e Grupo ja cadastrado!","Atencao!!!")
					EndIf
				EndIf
			EndIf
		Next nY 	
		If Empty(oGrid:aCols[nX][nPosRegiao]) .Or. Empty(oGrid:aCols[nX][nPosGrupo]) 
		     lRet := .F.                     
		     MsgAlert("Regiao ou Grupo não preenchido de vendas, para prosseguir preencha os dois campos corretamente.")
		EndIf
	EndIf
Next nX    


Return(lRet)
                     
//Função responsável por incluir o código do vendedor no cadastro do cliente SA1->A1_VQ_VEND
Static Function DbIncVSa1(_cCodVen)       
Local _aIncSA1 := {}   
Local _aAuxSplit := {}   
Local _cAuxStr := ""   


_cQuery := " SELECT A1_COD,	" 	+ CRLF
_cQuery += " A1_LOJA, " 		+ CRLF
_cQuery += " A1_REGIAO+A1_GRPVEN,	" 	+ CRLF
_cQuery += " A1_VQ_VEND 			"	+ CRLF
_cQuery += " FROM " + RetSqlName("SA1") + CRLF
_cQuery += " WHERE " 					+ CRLF
_cQuery += " 	D_E_L_E_T_ <> '*' "  	+ CRLF
_cQuery += " 	AND A1_REGIAO+A1_GRPVEN IN ( " 	+ CRLF
_cQuery += " 	SELECT Z12_REGIAO+Z12_GRUPO FROM " + RetSqlName("Z12")	+ CRLF 	
_cQuery += " 	WHERE " 				+ CRLF
_cQuery += " 		D_E_L_E_T_ <> '*' " + CRLF
_cQuery += " 		AND Z12_COD LIKE '%"  + _cCodVen + "%' " 			+ CRLF	
_cQuery += " 		AND Z12_REGIAO+Z12_GRUPO NOT IN ( "	+ CRLF 	
_cQuery += " 			SELECT A1_REGIAO+A1_GRPVEN " 	 	+ CRLF
_cQuery += " 			FROM " + RetSqlName("SA1")			+ CRLF
_cQuery += " 			WHERE	" 		+ CRLF
_cQuery += " 				A1_VQ_VEND LIKE '%"  + _cCodVen + "%' " + CRLF
_cQuery += " 				AND D_E_L_E_T_ <> '*' " + CRLF
_cQuery += " 			) " 			+ CRLF
_cQuery += " 	) " 					+ CRLF


If Select("TMPZ12I") > 0
	TMPZ12I->(DbCloseArea())
EndIf

TcQuery _cQuery New Alias "TMPZ12I"

ProcRegua(Contar("TMPZ12I","!Eof()")   )
Dbselectarea("TMPZ12I")  
TMPZ12I->(DbGoTop())       
  
_nLinha := 0 
While !TMPZ12I->(Eof())  
	IncProc("Cliente: "+ TMPZ12I->A1_COD +" - Loja: " + TMPZ12I->A1_LOJA)			
	_nLinha := _nLinha + 1	
    _cAuxStr := AllTrim(TMPZ12I->A1_VQ_VEND)
	DbSelectArea("SA1");DbSetOrder(1)
    If SA1->(DbSeek(xFilial("SA1")+TMPZ12I->(A1_COD+A1_LOJA)))
    	RecLock("SA1",.F.)
			SA1->A1_VQ_VEND :=  _cAuxStr + Alltrim(_cCodVen) + "/"
    	MsUnlock()
    EndIf
	TMPZ12I->(DbSkip())    

EndDo			                                                                                                         
TMPZ12I->(MsUnlock())                                                        
Return                                                            

//Função responsável por remover o vendedor de todos clientes que eles nao deve ter acesso SA1->A1_VQ_VEND
Static Function DbRemVSa1(_cCodVen) 
Local _aRemSA1 := {}     
Local _aAuxSplit := {}   
Local _cAuxStr := ""

_cQuery := " SELECT A1_COD, " 				+ CRLF
_cQuery += " A1_LOJA, " 					+ CRLF
_cQuery += " A1_REGIAO+A1_GRPVEN, " 		+ CRLF
_cQuery += " A1_VQ_VEND "				 	+ CRLF 
_cQuery += " FROM " + RetSqlName("SA1")		+ CRLF
_cQuery += " WHERE "						+ CRLF
_cQuery += " 	D_E_L_E_T_ <> '*' "			+ CRLF
_cQuery += " 	AND A1_VQ_VEND LIKE '%"+_cCodVen+"%'		" 		+ CRLF
_cQuery += " 	AND A1_REGIAO+A1_GRPVEN NOT IN ( 	" 				+ CRLF
_cQuery += "		SELECT Z12_REGIAO+Z12_GRUPO " 					+ CRLF 
_cQuery += "		FROM "+ RetSqlName("Z12") 						+ CRLF
_cQuery += "		WHERE	Z12_COD LIKE '%"  + _cCodVen + "%'" 	+ CRLF 
_cQuery += "		AND D_E_L_E_T_ <> '*'		 " 					+ CRLF
_cQuery += "	) " 							+ CRLF
_cQuery += " ORDER BY A1_REGIAO+A1_GRPVEN	 " 	


If Select("TMPZ12R") > 0
	TMPZ12R->(DbCloseArea())
EndIf
TcQuery _cQuery New Alias "TMPZ12R"

ProcRegua(Contar("TMPZ12R","!Eof()")   )
Dbselectarea("TMPZ12R")  
TMPZ12R->(DbGoTop())       

_nLinha := 0
While !TMPZ12R->(Eof())  
	IncProc("Cliente: "+ TMPZ12R->A1_COD +" - Loja: " + TMPZ12R->A1_LOJA)			
	_nLinha := _nLinha + 1	
    _aAuxSplit := StrTokArr(AllTrim(TMPZ12R->A1_VQ_VEND),"/")
    For nX := 1 to Len(_aAuxSplit)
    	If !(AllTrim(_aAuxSplit[nX]) == AllTrim(_cCodVen))
    		_cAuxStr += _aAuxSplit[nX] + "/"
    	End 
    Next 
    DbSelectArea("SA1");DbSetOrder(1)
    If SA1->(DbSeek(xFilial("SA1")+TMPZ12R->(A1_COD+A1_LOJA)))
    	RecLock("SA1",.F.)
			SA1->A1_VQ_VEND := _cAuxStr    	
    	MsUnlock()
    EndIf                   
   	_cAuxStr := "" //limpando os vendedores
	TMPZ12R->(DbSkip())    

EndDo			                                                                                                         
TMPZ12R->(MsUnlock())                                                                                                     

Return         
