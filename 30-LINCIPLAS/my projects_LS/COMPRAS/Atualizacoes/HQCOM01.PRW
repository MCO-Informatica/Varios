#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHQCOM01   บ Autor ณ GIANE              บ Data ณ  29/01/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Criar Pedidos de Compras                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LA SELVA                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function HQCOM01

Local _nIndex, _cIndex, _cFiltro, _cKey
Local oFont			:= TFont():New("Arial",,-12,,.t.) //quinto parametro <negrito>
Local _aCampos 		:= {}
Local _aCampos2 	:= {}
Local oCombo

Private oDlg
Private _cMarca := GetMark()
Private oMark
Private oMark2
Private _cArq, _cArq2
Private _cIndice
Private _cAlias 	:= "TMP"
Private _cAlias2 	:= "TSA2"
Private _lInverte 	:= .f.
Private _lInver2  	:= .f.
Private _aCombo 	:= {}, _cCombo
Private _cInd3, _cInd2, _cInd4 
Private _aPedidos 	:= {} 
Private cUser		:= RetCodUsr()

aadd(_aCombo, "Codigo       ")
aadd(_aCombo, "Razao Social ")
aadd(_aCombo, "CNPJ         ")

AADD(_aCampos, {"A2_OK",,"","@!"} )
AADD(_aCampos, {"A2_COD",,"Codigo","@!"} )
AADD(_aCampos, {"A2_LOJA",,"Loja","@!"} )
AADD(_aCampos, {"A2_NREDUZ",,"Fantasia","@!"} )
AADD(_aCampos, {"A2_NOME",,"Razao Social" ,"@!"} )
AADD(_aCampos, {"A2_CGC",,"Cnpj",""} )

AADD(_aCampos2, {"M0_OK",,"","@!"} )
AADD(_aCampos2, {"M0_CODIGO",,"Empresa","@!"} )
AADD(_aCampos2, {"M0_CODFIL",,"Filial" ,"@!"} )
AADD(_aCampos2, {"M0_NOME"  ,,"Nome Filial","@!"} )
AADD(_aCampos2, {"M0_NOMECOM",,"Nome Empresa","@!"} )

_CArqTmp()                                                     

dbSelectArea("SA2") 
                   
//so inclui no browse de fornecedores, aqueles que tem necessidade > 0 na tabela de Compras
_cQuery := "SELECT DISTINCT XCOM.A2_COD 	A2_COD, "
_cQuery += "	   SA2.A2_LOJA  			A2_LOJA, "	 
_cQuery += "	   SA2.A2_NREDUZ  			A2_NREDUZ, "	 
_cQuery += "	   SA2.A2_NOME				A2_NOME,   "	 
_cQuery += "	   SA2.A2_COND				A2_COND,   "	 
_cQuery += "	   SA2.A2_OK 	  			A2_OK, "
_cQuery += "	   SA2.A2_CGC 	  			A2_CGC "

_cQuery += " FROM " 

_cQuery += "  "+RetSQLName("SA2")+ " SA2 (NOLOCK) INNER JOIN COMPRAS XCOM ON SA2.A2_COD = XCOM.A2_COD and SA2.A2_LOJA = XCOM.A2_LOJA"

_cQuery += "   WHERE "
_cQuery += "   SA2.A2_FILIAL  		= '" + xFilial("SA2")	+"' "
_cQuery += "   and SA2.D_E_L_E_T_ 	= '' "
_cQuery += "   and XCOM.NECESSIDADE > 0 "
_cQuery += "   ORDER BY  XCOM.A2_COD "

//dbUseArea(.t.,"TOPCONN",TCGENQRY('192.168.1.3','LASELVA',_cQuery),"XSA2",.f.,.F.)
dbUseArea(.t.,"TOPCONN",TCGENQRY(,,_cQuery),"XSA2",.f.,.F.)

_CArqSA2()

XSA2->(DbCloseArea())

DEFINE MSDIALOG oDlg FROM  15,6 TO 455,900 TITLE "Gerar Pedidos de Compras" PIXEL  

@ 014,005 TO 124,446  LABEL '' OF oDlg  	PIXEL

@ 018,008 SAY  "Fornecedores"	SIZE 040,07 OF oDlg PIXEL  FONT oFont
@ 018,082 Say "Visualizar por: " OF oDlg PIXEL
@ 016,120 COMBOBOX oCombo VAR _cCombo ITEMS _aCombo SIZE 70,09 PIXEL ON CHANGE _AltOrde() OF oDlg

oMark := MsSelect():New(_cAlias2,"A2_OK",,_aCampos,@_lInverte,@_cMarca,{28,8,120,442},,,oDlg)
oMark:oBrowse:lhasMark := .T.
oMark:oBrowse:lCanAllMark:=.T.                            
oMark:oBrowse:bAllMark := {|| _GrvMarca(_cAlias2,"A2_OK")}

@ 126,005 TO 220,446  LABEL '' OF oDlg  	PIXEL
@ 130,008 SAY  "Filiais"		SIZE 025,07 OF oDlg PIXEL  FONT oFont
oMark2 := MsSelect():New(_cAlias,"M0_OK",,_aCampos2,@_lInver2,@_cMarca,{139,8,217,442},,,oDlg)
oMark2:oBrowse:lhasMark := .T.
oMark2:oBrowse:lCanAllMark:=.T.
oMark2:oBrowse:bAllMark := {|| _GrvMarca(_cAlias,"M0_OK")}

ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {||MsgRun("Gerando Pedidos de Compras,  Aguarde...  ","",{|| U_HQCOM02()}), U_HQCOM03()}, {||oDlg:End()})
//{|| IIF(U_VERMARK(), {|| U_HQCOM02(), U_HQCOM03()},"") }, {||oDlg:End()})


TMP->(DbCloseArea())
Ferase(_cArq+".dbf")
Ferase(_cIndice+OrdBagExt())
                            
TSA2->(DbCloseArea())
Ferase(_cArq2+".dbf")
Ferase(_cInd2+OrdBagExt())
Ferase(_cInd3+OrdBagExt())
Ferase(_cInd4+OrdBagExt())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ_AltOrde  บAutor  ณGiane               บ Data ณ  11/02/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Altera a ordem de visualizacao do grid de FORNECEDORES     บฑฑ
ฑฑบ          ณ de acordo com a escolha do usuario na combobox             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _AltOrde()
Local i

DbSelectArea("TSA2")
For i := 1 to len(_aCombo)

    if alltrim(_aCombo[i]) == alltrim(_cCombo)        
       Set Order to i
       DbGotop()
       oMark:oBrowse:Refresh()
       exit
    endif
    
Next

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFUNCAO    ณ_GRVMARCA บ Autor ณ GIANE              บ Data ณ  05/02/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Grava ou limpa a marca nos campos OK das tabelas SA2 e     บฑฑ
ฑฑบ          ณ TMP quando usuario usa marca/desmarca TODOS de uma vez     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Para utilizar no Markbrowse                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/      
Static Function _GrvMarca(_cTab,_cOK)
DbSelectArea(_cTab)
DbGotop()
Do while !eof()
   Reclock(_cTab,.f.)      
   
   if Ismark(_cOK, _cMarca)
      &_cOK := space(02)      
   else
      &_cOK := _cMarca
   endif
   
   MsUnlock()
   
   Dbskip()
Enddo

DbGotop()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFUNCAO    ณCARQTMP   บ Autor ณ GIANE              บ Data ณ  29/01/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Cria Arq. Temporario com estrutura igual a SM0(sigamat.emp)บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Para utilizar no Markbrowse                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function _CArqTmp()
Local _aEstru := {}
Local _cCampo, _dIndex

//Copia a estrutura da tabela SM0 e cria arquivo temporario
dbSelectArea("SM0")
_aEstru := dbStruct()
AADD(_aEstru,{"M0_OK","C",02,0})  //acrescenta campo para o markbrowse

//_cAlias := "TMP"
_cArq := CriaTrab(_aEstru, .T.)
dbUseArea(.t.,,_cArq,_cAlias,.f.,.f.)

//cria indice para a tabela temporaria
_cIndice := CriaTrab(nil,.f.)
DbSelectArea(_cAlias)
_dIndex := "M0_CODIGO+M0_CODFIL"
IndRegua(_cAlias,_cIndice,_dIndex,,)

DbSelectArea("SM0")
dbGoTop()
While ! eof()
	
	if cEmpAnt <> SM0->M0_CODIGO
		dbSkip()
		loop
	Endif
   
   //so inclui no markbrowse de filiais, as que existem na tabela de compras
	_cQuery := "SELECT * FROM COMPRAS WHERE M0_CODFIL = '"+SM0->M0_CODFIL + "' "
//	dbUseArea(.t.,"TOPCONN",TCGENQRY('192.168.1.3','LASELVA',_cQuery),"XXX",.T.,.F.)
	dbUseArea(.t.,"TOPCONN",TCGENQRY(,,_cQuery),"XXX",.T.,.F.)

	dbGotop()
	if eof()
		XXX->(dbCloseArea())
		dbSelectArea("SM0")
		dbSkip()
		loop
	Endif
	
	XXX->(dbCloseArea())

	dbSelectAreA(_cAlias)
	Reclock(_cAlias,.t.)
	TMP->M0_CODIGO := SM0->M0_CODIGO
	TMP->M0_CODFIL := SM0->M0_CODFIL
	TMP->M0_FILIAL := SM0->M0_FILIAL
	TMP->M0_NOME   := SM0->M0_NOME
	TMP->M0_NOMECOM:= SM0->M0_NOMECOM
	TMP->M0_OK     := space(2)
	MsUnlock()
	
	dbSelectArea("SM0")
	dbskip()
	
End

DbSelectArea(_cAlias)
dbGotop()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFUNCAO    ณCARQSA2   บ Autor ณ GIANE              บ Data ณ  29/01/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Cria Arq. Temporario com estrutura igual a SA2             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Para utilizar no Markbrowse                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function _CArqSA2()
Local _aEstru := {}
Local _cCampo      
Local _dIndex, _dIndex2, _dIndex3 

//Copia a estrutura da tabela SM0 e cria arquivo temporario
dbSelectArea("SA2")   
_aEstru := dbStruct()
_cArq2 := CriaTrab(_aEstru, .T.)    
dbUseArea(.t.,,_cArq2,_cAlias2,.f.,.f.)                           

//cria indice 1 para a tabela temporaria 
_cInd2 := CriaTrab(nil,.f.)     
DbSelectArea(_cAlias2 )
//_dIndex := "A2_FILIAL+A2_COD"
_dIndex := "A2_FILIAL+A2_COD+A2_LOJA"
IndRegua(_cAlias2,_cInd2,_dIndex,,) 

//cria indice 2 para a tabela temporaria
_cInd3 := CriaTrab(nil,.f.)
DbSelectArea(_cAlias2)
_dIndex2:= "A2_FILIAL+A2_NOME"
IndRegua(_cAlias2,_cInd3,_dIndex2,,) 
                        
//cria indice 3 para a tabela temporaria   
_cInd4 := CriaTrab(nil,.f.) 
DbSelectArea(_cAlias2)
_dIndex3:= "A2_FILIAL+A2_CGC"
IndRegua(_cAlias2,_cInd4,_dIndex3,,) 
                     
dbSetIndex(_cInd2+OrdBagExt())
dbSetIndex(_cInd3+OrdBagExt())
dbSetIndex(_cInd4+OrdBagExt())

dbsetorder(1)

SET INDEX TO (_cInd2),(_cInd3), (_cInd4)
dbGotop()

dbSelectArea("XSA2")
dbGotop()
While ! eof()
		
	dbSelectAreA(_cAlias2)
	Reclock(_cAlias2,.t.)
	TSA2->A2_COD    := XSA2->A2_COD
	TSA2->A2_LOJA	:= XSA2->A2_LOJA
	TSA2->A2_NREDUZ := XSA2->A2_NREDUZ
	TSA2->A2_NOME   := XSA2->A2_NOME		
	TSA2->A2_COND   := XSA2->A2_COND		              
	TSA2->A2_CGC    := XSA2->A2_CGC
	TSA2->A2_OK     := space(2)
	MsUnlock(_cAlias2)
	
	dbSelectArea("XSA2")
	dbskip()
	
End

DbSelectArea(_cAlias2)
dbGotop()

Return
        
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVerMark   บ Autor ณ Giane              บ Data ณ  18/02/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Verifica se usuario marcou alguma filial e fornecedor para บฑฑ
ฑฑบ          ณ o processamento                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function VerMark()

if !_CHKMark("TMP","M0_OK")
   MsgBox("Nenhuma filial foi selecionada!","Aviso","INFO")
   return .f.
endif

if !_CHKMark("TSA2","A2_OK")
	MsgBox("Nenhum Fornecedor foi selecionado!","Aviso","INFO")
	return .f.
endif
              
return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLACOM02   บ Autor ณ GIANE              บ Data ณ  31/01/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gerar arrays com dados do cabecalho e dos itens do         บฑฑ
ฑฑบ          ณ pedido de compra para chamar a funcao mata120              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LA SELVA                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function HQCOM02
Local _aArea := GetArea()
Local _aCabec := {}
Local _aItens := {}
Local _cForne, _cLoja
Local _nTotal
Local _cFilAnt  := cFilAnt                                     
Local _nSaveSX8 := GetSX8Len()
Local _cItem    
Local _nPreco                                      

Private	lMSHelpAuto := .f.
Private	lMsErroAuto := .f.                       

if !_CHKMark("TMP","M0_OK")
   MsgBox("Nenhuma filial foi selecionada!","Aviso","INFO")
   return 
endif

if !_CHKMark("TSA2","A2_OK")
	MsgBox("Nenhum Fornecedor foi selecionado!","Aviso","INFO")
	return 
endif

dbSelectArea("SB1")
DbSetOrder(1)

_cQuery := "SELECT * FROM COMPRAS"
_cQuery += "   ORDER BY  M0_CODFIL, A2_COD, A2_LOJA "
                
//dbUseArea(.t.,"TOPCONN",TCGENQRY('192.168.1.3','LASELVA',_cQuery),"XCOM",.F.,.F.)                                                          
dbUseArea(.t.,"TOPCONN",TCGENQRY(,,_cQuery),"XCOM",.F.,.F.)                                                          

DbSelectArea("XCOM")
DbGotop()
              
_aPedidos := {}
Do While !eof()
	
	//filtrar apenas os registros cuja filial tenha sido marcada no browse pelo usuario
	dbSelectArea("TMP")              
	dbSeek(cEmpAnt+XCOM->M0_CODFIL)
	if !found() .or. (TMP->M0_OK <> _cMarca)
    	dbSelectArea("XCOM")
		dbSkip()
		loop
	endif
		
	cFilAnt := XCOM->M0_CODFIL                      
   
	// filtrar apenas os registros cujo fornecedor tenho sido marcadono browse pelo usuario	       	
	dbSelectArea("TSA2")
	dbSetOrder(1)                   
	DbSeek(xFilial("TSA2")+XCOM->A2_COD+XCOM->A2_LOJA)
  //	DbSeek(XCOM->A2_COD+XCOM->A2_LOJA)
	if !found() .or. (TSA2->A2_OK <> _cMarca)
	    dbSelectArea("XCOM")
		dbSkip()
		Loop
	endif
	
	_cForne := TSA2->A2_NREDUZ
	_cLoja  := TSA2->A2_LOJA    	                     	               
	_cCond :=  TSA2->A2_COND

	_aCabec := {}
	_aItens := {}  
	_cItem  := '0'                 
			
    DbSelectArea("SB1")
    dbseek(xFilial("SB1") + ALLTRIM(XCOM->B1_COD))
    
	_cCod  := alltrim(XCOM->A2_COD)
	_cLoja := alltrim(XCOM->A2_LOJA) 
	
	dbSelectArea("XCOM")        
	Do While !eof() .and. alltrim(XCOM->A2_COD) == _cCod .And. alltrim(XCOM->A2_LOJA) == _cLoja .and. XCOM->M0_CODFIL == cFilAnt
	    	
		_nTotal := 0
		_nPreco := 0
		 
		//Subtrai da necessidade, as quantidades dos pedidos ja gravados no SC7 com saldo em aberto 
		_nQuant := XCOM->NECESSIDADE - _SomaPC(XCOM->M0_CODFIL,XCOM->B1_COD)    	   	

		dbSelectArea("XCOM")						
		if _nQuant <= 0
		    dbSkip()
		    Loop
		Endif 			 	                                
	   		   			              
	   	if XCOM->CUSTO > 0	   			     
	   	   _nPreco := XCOM->CUSTO       
	   	elseif SB1->B1_UPRC > 0
	   	   _nPreco := SB1->B1_UPRC
	   	else
	   	   _nPreco := 0.01
	   	endif   
	   	
		_nTotal := (_nQuant * _nPreco )
		         
		_cItem := strzero(val(_cItem)+1,len(SC7->C7_ITEM))                                          
		
		aadd(_aItens, {	{"C7_ITEM"   , _cItem 				  		         ,Nil},;
		                {"C7_PRODUTO", XCOM->B1_COD    					  	 ,Nil},; 
		                {"C7_UM"     , SB1->B1_UM                           ,Nil},;
		                {"C7_QUANT"  , _nQuant								 ,Nil},;
		                {"C7_PRECO"  , _nPreco     						     ,Nil},;
		                {"C7_TOTAL"  , _nTotal								 ,Nil},;
		                {"C7_DATPRF" , dDataBase    						 ,Nil},; //data da entrega
		                {"C7_TES"    , POSICIONE("SBZ",1,xFilial("SBZ")+_cProd,"BZ_TE_FORN"),Nil},; //codigo da TES 
		                {"C7_LOCAL"  , RetFldProd(SB1->B1_COD,"B1_LOCPAD")  ,Nil}} ) //armazem                                                        
             
        DbSelectArea("XCOM")
		DbSkip()
		
	End
                                                                
  	if !empty(_aItens) 	        
  	   //inclui o cabecalho do pedido
   	   _cNumero := CriaVar("C7_NUM",.T.)                  	       
       _aCabec  :=  {{"C7_NUM"     , _cNumero		  ,Nil},;
                     {"C7_FILIAL"  , cFilAnt          ,Nil},;	
           	    	 {"C7_TIPO"    , "1"       		  ,Nil},;
   		             {"C7_FORNECE" , _cCod		 	  ,Nil},;
    		         {"C7_LOJA"    , _cLoja    		  ,Nil},;
		             {"C7_CONTATO" , " "	          ,Nil},;
		             {"C7_FILENT"  , cFilAnt	      ,Nil},;
		             {"C7_COND"    , iif(!empty(_cCond),_cCond,"001")  ,Nil},; 
		             {"C7_EMISSAO" , dDataBase 		  ,Nil},;                     		             
		             {"C7_MOEDA"   , 1         		  ,Nil},;
		             {"C7_TXMOEDA" , 1         		  ,Nil}}


 	    //Gravar o Pedido
		Begin Transaction
		MsExecAuto({ |x,y,z,w|  mata120(x,y,z,w)} ,1,_aCabec,_aItens,3)                                                                                            
	
		If lMsErroAuto
    	    MostraErro()
			While ( GetSX8Len() > _nSaveSX8 )
				RollBackSX8()
			EndDo		
		                               
			MsgBox("Erro na gera็ao do Pedido do Fornecedor: " + alltrim(_cForne) ,"Aviso","STOP")
			DisarmTransaction()
		Else 
			While ( GetSX8Len() > _nSaveSX8 )
				ConfirmSX8()
			EndDo
	
			//MsgBox("Pedido Nr. " + _cNumero + "  do Fornecedor  " + alltrim(_cForne) + " ,  gerado com sucesso! ","Aviso","INFO")  
			aadd(_aPedidos,{cFilAnt,_cLoja,_cNumero,_cCod,_cForne})
		EndIf
		
		End Transaction
		
   	Endif		
	    
	dbSelectArea("XCOM")
	
Enddo
                              
cFilAnt := _cFilAnt
                 
XCOM->(dbCloseArea()) 

if len(_aPedidos) == 0
   MsgBox("Nao existem Pedidos de Compras a serem Gerados!","Aviso","INFO")     
else
	U_COMP007(_aPedidos,cUser)	
endif

DbSelectArea("TSA2")
DbGoTop()           
DbSelectArea("TMP")
DbGotop()

RestArea(_aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFUNCAO    ณ_SOMAPC   บ Autor ณ GIANE              บ Data ณ  03/02/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Traz os saldos dos produtos para gerar pedidos de compras  บฑฑ
ฑฑบ          ณ apenas da necessidade - saldo                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LA SELVA                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _SomaPC(_cFil,_cProd)
Local _aArea := GetArea()
Local _nSaldo := 0

DbSelectArea("SC7")
DbSetOrder(2)
dbseek(_cFil+_cProd)
Do while !eof() .and. SC7->C7_FILIAL+SC7->C7_PRODUTO == _cFil+_cProd
     
	IF (SC7->C7_RESIDUO == "S") .or. (SC7->C7_QUJE > 0)
		dbskip()
		loop
	Endif
	
	//if (SC7->C7_TES $ '007/008')
	if (SC7->C7_TES $ '205/206')
		dbskip()
		loop
	Endif
	
	if(SC7->C7_FORNECE <= '000009')
		dbskip()
		loop
	Endif
	
    _nSaldo += SC7->C7_QUANT                   

   DbSkip()
Enddo

RestArea(_aArea)
Return( _nSaldo)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFUNCAO    ณ_CHKMARK  บ Autor ณ GIANE              บ Data ณ  06/02/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Verifica se usuario escolheu alguma filial e fornecedor    บฑฑ
ฑฑบ          ณ e avisa se nao marcou nenhum.                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/      
Static Function _CHKMark(_cTab,_cOK)
Local _lRet := .f.
DbSelectArea(_cTab)
DbGotop()
Do while !eof()
      
   if Ismark(_cOK, _cMarca)
      _lRet := .t.
      exit
   endif
        
   Dbskip()
Enddo
DbGotop() 

Return _lRet  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHQCOM03   บ Autor ณ Giane              บ Data ณ  13/02/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio mostra os pedidos gerados automaticamente pela   บฑฑ
ฑฑบ          ณ rotina HQCOM02                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function HQCOM03

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Pedidos de Compras Automแtico"
Local cPict          := ""
Local titulo       := "Pedidos de Compras Automแtico"
Local nLin         := 80

Local Cabec1       := "Filial    Pedido     Loja   Fornecedor"             
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 80
Private tamanho          := "P"
Private nomeprog         := "HQCOM03" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "HQCOM03" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := ""

oDlg:End()

if len(_aPedidos) == 0
   return
endif

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  13/02/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

SetRegua(RecCount())

For _nx := 1 to len(_aPedidos)
  
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif
   
   If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif
  
   @ nLin,03 PSAY _aPedidos[_nx,1] //filial
   @ nLin,10 PSAY _aPedidos[_nx,3] //pedido
   @ nLin,22 PSAY _aPedidos[_nx,2] //loja fornecedor
   @ nLin,28 PSAY _aPedidos[_nx,4] //cod fornecedor
   @ nLin,36 PSAY _aPedidos[_nx,5] // nome fornecedor
   
   nLin := nLin + 1 // Avanca a linha de impressao
   
Next

SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return
