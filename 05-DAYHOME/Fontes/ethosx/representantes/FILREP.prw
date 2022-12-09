#Include "Protheus.ch"
#Define NMAXPAGE 50

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ//
//Funcao      : FILREP()                                    //
//Objetivos   : Consulta especifica util. representantes   	//
//Desenv.  POR: EWERTON SOBRINHO			    				//
//Data/Hora   : 16/04/12 		                    			//
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ//
User Function FILREP() //U_FILREP()

Local lRet			:= .F.
Local aCampos		:= {}
Local aIndices		:= {}
Local aTabRel   	:= {}
Local cWhere		:= ""  
Local cAliasRef 	:= "SA1"
Local cFil 			:= ""                                                    
Local cQuery		:= ""
Local cMvGrp 		:= SuperGetMV("MV_GRPREP",,"") 

PswOrder(1)
PSWSeek(__CUSERID, .T.)
aUser      	:= PswRet(1)
IdUsuario  	:= aUser[1][1]  	// codigo do usuario     
GrpUser		:= IIF(LEN(aUser[1][10]) > 0 , aUser[1][10][1], "000000") 	// Grupo Que o usuario Pertence


aCampos := {"A1_FILIAL", "A1_COD", "A1_LOJA","A1_NOME","A1_CGC", "R_E_C_N_O_"}

aIndices:= {{"A1_FILIAL", "A1_COD", "A1_LOJA","A1_NOME", "A1_CGC"},;
	    	  {"FILIAL"   ,"CODIGO" ,"LOJA","RAZAO SOCIAL","CNPJ"}}

aTabRel := { {"SA3","A3_COD = A1_VEND AND A3_CODUSR = '" + __CUSERID + "' AND A3_FILIAL = '" + XFILIAL("SA1") + "'" } }





DbSelectarea("SA3")
DBSETORDER(7)
IF DBSEEK(xfilial("SA3") + IdUsuario) .AND. GrpUser $ cMvGrp 
	cWhere	:=  "A1_VEND = '" + SA3->A3_COD  + "'"
ELSE
	cWhere := "" 
ENDIF


lRet := RESA1(cAliasRef,aCampos,aIndices,cWhere,aTabRel) 

Return lRet


//--------------------------------------+
// MONTA TELA PARA CONSULTA ESPECÍFICA	+
//--------------------------------------+

Static Function RESA1(cAliasRef,aCampos,aIndices,cWhere,aTabRel)

Local cCmbIndice:= ""
Local cPesq	:= Space(50)
Local oPesq
Local nX	:= 0
Local cCod   	:= 0
Local lRet	:= .F.
Local lRetFil	:= .F.
Local cTrbName	:= "TMPF3"+cAliasRef
Local cTitle	:= ""
Local cBLine	:= ""
Local cSep	:= "" 
Local bRet	:= {||lRet := .T., cCod := IIf ( Len(oLstBx:aArray) >= oLstBx:nAt ,oLstBx:aArray[oLstBx:nAt][2] +  oLstBx:aArray[oLstBx:nAt][3] ,""),oDlg:End()}
Local oDlg
Local aDados	:= {}
Local aHeaders	:= {}   

Private oLstBx       

Default cWhere := ""

//Monta header do listbox
SX3->(DbSetOrder(2)) 

For nX := 1 to Len(aCampos) -1 
	SX3->(DbSeek(aCampos[nX]))
	aAdd(aHeaders,AllTrim(Capital(SX3->X3_TITULO)))
Next nX

//Nome da pesquisa
SX2->(DbSetOrder(1))
SX2->(DbSeek(cAliasRef))
cTitle := ALLTRIM(SX2->X2_NOME)

DEFINE MSDIALOG oDlg TITLE "Consulta" + " " + cTitle FROM 268,260 TO 642,796 PIXEL
    
	//Texto de pesquisa
	@ 017,002 MsGet oPesq Var cPesq Size 219,009 COLOR CLR_BLACK PIXEL OF oDlg

	//Interface para selecao de indice e filtro
	@ 003,228 Button "Filtrar" Size 037,012 PIXEL OF oDlg;
		ACTION (ESCSLBX(@oLstBx, @aDados  , cWhere	   , cTrbName,;
						 aCampos, cAliasRef, cCmbIndice, aIndices,;
						 @oDlg	, cPesq    , aTabRel ))	
		
	@ 005,002 ComboBox cCmbIndice Items aIndices[2] Size 220,010 PIXEL OF oDlg;
		On Change (ESCSLBX(@oLstBx, @aDados  , cWhere    , cTrbName,;
							aCampos, cAliasRef, cCmbIndice, aIndices,;
							@oDlg  , cPesq    , aTabRel ))
    
	//ListBox
	oLstBx := TWBrowse():New(30,3,264,139,Nil,aHeaders,,oDlg,,,,,,,,,,,,,,.T.)
	oLstBx:bLDblClick := bRet //{|| IIf ( Len(oLstBx:aArray) >= oLstBx:nAt , DPLCLICK(), NIL ) } 	//Botoes inferiores
	
	DEFINE SBUTTON FROM 172,002 TYPE 1	 ENABLE OF oDlg Action(Eval(bRet))
	DEFINE SBUTTON FROM 172,035 TYPE 15 ENABLE OF oDlg Action(DPLCLICK())
	DEFINE SBUTTON FROM 172,068 TYPE 2	 ENABLE OF oDlg Action(oDlg:End())


	
	//Carga dos dados
	ESCSLBX(@oLstBx, @aDados  , cWhere    , cTrbName,;
			 aCampos, cAliasRef, cCmbIndice, aIndices,;
			 @oDlg  , cPesq    , aTabRel)
	


ACTIVATE MSDIALOG oDlg CENTERED 

If Select(cTrbName) > 0
	(cTrbName)->(DbCloseArea())
EndIf

If lRet
	DbSelectArea("SA1")
   	SA1->(DbSetorder(1))
	SA1->(dbSeek(XFILIAL("SA1") + cCod))  
EndIf

Return lRet

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ//
//Funcao      : ESCSLBX()                                            //
//Objetivos   : Criar a query de filro da consulta especifica.        //
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ//

Static Function ESCSLBX(oLstBx , aDados, cWhere,cTrbName,aCampos, cAlias, cCmbIndice, aIndices,oDlg,cPesq, aTabRel)

Local cQuery 	:= ""
Local cCpos	:= ""
Local cSep	:= ""
Local cChave	:= ""
Local nP        := 0
Local nX		:= 0  
Local cPrefx	:= PrefixoCpo(cAlias)
Local cIdTab    := ""
Local cOrder	:= ""
Local bLine	:= Nil 
Local bNextReg	:= {|a,b,c,d|ESCSPag(@a,b,c,d)}
Local nTotReg	:= 0 
Local nLenChave	:= 0
Local nInd		:= 0    
Local lFiltra	:= .F.
Local cConcat	:= "+"
Local cLenPsq	:= ""  
Local aCposAdd	:= aClone(aCampos)
Local cFiltro	:= ""

Default cPesq	:= ""  

//Adiciona o recno a lista de campos carregados na Listbox
//AAdd(aCposAdd,"RECNUM")

//Remove espacos do texto pesquisado
cPesq	:= AllTrim(cPesq)
cLenPsq	:= AllTrim(Str(Len(cPesq))) 

//Verifica se deve ser feito algum filtro
If !Empty(cPesq)
	lFiltra := .T.
EndIf    

//Define a ordem utilizada
nInd := aScan(aIndices[2],cCmbIndice)
cOrder := AllTrim(StrTran(aIndices[1][nInd],"+",","))

//Filtro de acordo com a pesquisa
If lFiltra
	//Define o simbolo de concatenacao de acordo com o banco
	If Upper(TcGetDb()) $ "ORACLE,POSTGRES,DB2,INFORMIX"
		cConcat := "||"
	Endif 
	                     
	cChave		:= Upper(aIndices[1][nInd])
	cChave 		:= StrTran(cChave,cPrefX+"_FILIAL+","") 
	cChvOrig	:= cChave
	cChave 		:= StrTran(cChave,cPrefX+"_",cAlias+"."+cPrefX+"_")
	cChave 		:= StrTran(cChave,"DTOS","")
	If cConcat <> "+"
		cChave 	:= StrTran(cChave,"+",cConcat)
	EndIf
	                                 
	//Verifica se a chave de busca nao eh maior que o indice
	nLenChave := ESCSTam(cChvOrig)    
	
	If nLenChave < Val(cLenPsq)
		cLenPsq := AllTrim(Str(nLenChave))
		cPesq	:= SubStr(cPesq,1,nLenChave)
	EndIf
	
	//Concatena a expressao do filtro
	If lFiltra
		cFiltro += cChave + " LIKE '%"+Upper(cPesq)+"%' " //Pesquisar em qualquer posição da chave.
	EndIf
	
EndIf
 
//Monta lista de campos
SX3->(DbSetOrder(2)) 

cBLine	:= "{||{"

For nX := 1 to Len(aCampos) 
	cBLine	+= cSep + "oLstBx:aArray[oLstBx:nAt]["+AllTrim(Str(nX))+"]"
	cSep	:= ","
Next nX 

cBLine	+= "}}" 
bLine	:= &(cBLine)
cSep := ""

//Campos a serem selecionados da tabela
For nX := 1 to Len(aCampos) -1
	
	nP := At("_",aCampos[nX])
	cIdTab := Substr(aCampos[nX],1,nP-1)
	
	If Len(cIdTab) == 2
		cIdTab := "S"+cIdTab
	EndIf
	
	cCpos	+= cSep + cIdTab + "." + aCampos[nX] 
	cSep	:= ","
Next

//Selecao dos campos
cQuery	:= "SELECT DISTINCT " + cCpos + " ," +cAlias +".R_E_C_N_O_" 
cQuery	+= " FROM " + RetSqlName(cAlias) + " " + cAlias

//Relacionamento com outras tabelas
For nX := 1 To Len(aTabRel)
	cQuery  += " LEFT JOIN " + RetSqlName(aTabRel[nX][1]) + " " + aTabRel[nX][1]
	cQuery  += " ON " + aTabRel[nX][2] + " AND " + aTabRel[nX][1] + ".D_E_L_E_T_ = '' "
Next
	
//Condicao
cQuery += " WHERE "

If !Empty(cWhere)
	cQuery += " " + cWhere + " AND "
EndIf

If lFiltra
	cQuery += cFiltro + " AND "
EndIf

//Remove deletados
cQuery	+= cAlias + ".D_E_L_E_T_ = '' "

//Ordena e executa query
cQuery	+= " ORDER BY " + cOrder

cQuery := ChangeQuery( cQuery )

If Select(cTrbName) > 0
	(cTrbName)->(DbCloseArea())
EndIf

DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cTrbName,.T.,.T.)

(cTrbName)->(DbGoTop())

If (cTrbName)->(Eof())

	MsgStop("Nenhum registro foi encontrado")

Else

	//Conta registros da tabela
	DbSelectArea(cTrbName)
	DbGoTop()
	While !Eof() .AND. nTotReg <= NMAXPAGE
		nTotReg++
		DbSkip()
	End	
	DbGoTop()

	aDados := ESCSPag(Nil,cTrbName,aCposAdd,NMAXPAGE) 
	
	oLstBx:SetArray(aDados)
	oLstBx:bLine := bLine
	//oLstBx:GoTop()
	oLstBx:Refresh()
	oDlg:Refresh()
	
	If (nTotReg > NMAXPAGE)
		oLstBx:bGoBottom	:= {||Eval(bNextReg,oLstBx,cTrbName,aCposAdd,NMAXPAGE),oLstBx:NAT := EVAL( oLstBx:BLOGICLEN ) }    
		oLstBx:bSkip		:= {|NSKIP, NOLD, nMax|nMax:=EVAL( oLstBx:BLOGICLEN ),NOLD := oLstBx:NAT, oLstBx:NAT += NSKIP,;
								oLstBx:NAT := MIN( MAX( oLstBx:NAT, 1 ), nMax ),If(oLstBx:nAt==nMax,Eval(bNextReg,oLstBx,cTrbName,aCposAdd,NMAXPAGE),.F.),;
								oLstBx:NAT - NOLD}	
	EndIf	
EndIf

Return Nil


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ//
//Funcao      : ESCSPag()                                                               //
//Parametros  : Nenhum                                                                   //
//Retorno     : Nil                                                                      //
//Objetivos   : Paginacao de registros no RecordSet da tela de consulta customizada      //
//Autor       : Eduardo C. Romanini                                                      //
//Data/Hora   : 23/09/10 15:55                                                           //
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ//

Static Function ESCSPag(oLstBx,cAlias,aCampos,nLimite)

Local aLinha	:= {}
Local nX		:= 0
Local nRegs		:= 0 
Local aDados	:= {}

While !(cAlias)->(Eof()) .AND. nRegs <= nLimite

	aLinha := {}

	For nX := 1 to Len(aCampos) 
		AAdd(aLinha,(cAlias)->&(aCampos[nX]))
	Next nX
	
	If oLstBx <> Nil
		AAdd(oLstBx:aArray,aClone(aLinha))
	Else
		Aadd(aDados,aClone(aLinha))
	EndIf

	nRegs++ 
	
	(cAlias)->(DbSkip())
	
End

If oLstBx <> Nil
	Return aClone(oLstBx:aArray)
Else             
	Return aDados
EndIf

Return .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ//
//Funcao      : ESCSTam()                                                             	 //
//Parametros  : Nenhum                                                                   //
//Retorno     : Nil                                                                      //
//Objetivos   : Retorna o tamanho maximo da pesquisa de acordo com a chave de pesquisa   //
//Data/Hora   : 19/10/10                                                            	//
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ//

Static Function ESCSTam(cChvOrig) 

Local nTam	:= 0
Local nX	:= 0
Local aCpos	:= {}

cChvOrig := StrTran(cChvOrig,"DTOS")
cChvOrig := StrTran(cChvOrig,"(")
cChvOrig := StrTran(cChvOrig,")")

aCpos := StrToKArr(cChvOrig,"+")

For nX := 1 to Len(aCpos)
	nTam += TamSX3(aCpos[nX])[1]
Next nX

Return nTam


STATIC FUNCTION DPLCLICK()

Local nOpca 		:= 0
Private  aButtons 	:= {}
Private cCadastro 	:= "Cadastro - Visualizar"                                                                   

DBSELECTAREA("SA1")
DBSETORDER(1)
SA1->(DBGOTO(oLstBx:aArray[oLstBx:nAt][6]))
  
nOpca := AxVisual("SA1",SA1->(Recno()),2,,,,,aButtons,,,,,,,,,)
           
SA1->(DBCLOSEAREA())

return