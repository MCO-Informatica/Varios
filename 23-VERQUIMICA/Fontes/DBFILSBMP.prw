#include "Protheus.ch"     
#Include "TopConn.ch"

User Function DBFILSBMP()   
 
Local aSize, aObjects, aInfo, aPosObj, oLista   
Private cCodigo := ""
Private aHeader := {}
Private aCols   := {} 
Private aCols2  := {}                                   
Private oPesqu, oBFiltro  
Private cPesqu := "", cGNomCli := space(20)
Private aPesqu := {"Codigo Verquimica", "Codigo Produto"}
Private aDados := {}       
Private nLinAtu, nLinAnt, nCorAtu, nCorAnt          
Private oOK := LoadBitmap(GetResources(),'br_verde') 

cCodigo := DBFILT1()     

Return cCodigo

Static Function DBFILT1()         

aSize := MsAdvSize(.F.)       

aSize[3] -= 200
aSize[4] -= 100
aSize[5] -= 400
aSize[6] -= 200

//aObjects := {	{ 100, 040, .T., .F. },;
//				{ 100, 100, .T., .T. },;
//				{ 100, 022, .T., .F. }}

aObjects := {	{ 100, 080, .T., .F. },;
				{ 100, 100, .T., .T. },;
				{ 100, 025, .T., .F. }}

aInfo    := { 	aSize[1],;
				aSize[2],;
				aSize[3],;
				aSize[4],;
				3,;
				3 }

aPosObj  := MsObjSize(aInfo, aObjects)

Define MsDialog oDlgSB1 Title "Busca de Produto / MP" From aSize[7],0 To aSize[6]+50, aSize[5] Of oMainWnd Pixel 


//@ aPosObj[1][1], aPosObj[1][2] ComboBox oPesqu Var cPesqu Items aPesqu Size aPosObj[1][4] - 75, 50 Valid /*BtnFiltro()*/  Of oDlgSB1 Pixel //When lEditPesq
//@ aPosObj[1][1]+15, aPosObj[1][2] MsGet cGNomCli Size aPosObj[1][4] - 75, 09 Of oDlgSB1 Pixel    
//@ aPosObj[1][1], aPosObj[1][4] - 65 Button oBFiltro Prompt "Filtrar" Size 45, 12 Action _filtrar() Of oDlgSB1 Pixel

@ 032,005 ComboBox oPesqu Var cPesqu Items aPesqu Size aPosObj[1][4] - 75, 50 Valid /*BtnFiltro()*/  Of oDlgSB1 Pixel //When lEditPesq
@ 050,005 MsGet cGNomCli Size aPosObj[1][4] - 75, 09 Of oDlgSB1 Pixel    
@ 063,005 Button oBFiltro Prompt "Filtrar" Size 45, 12 Action _filtrar() Of oDlgSB1 Pixel
            
_crtHeader()                                                      
//oLista := MsNewGetDados():New(aPosObj[2][1]-5, aPosObj[2][2], aPosObj[2][3]-3, aPosObj[2][4]-3, ,"AllwaysTrue", "AllwaysTrue", "AllwaysTrue", ,, 99, "AllwaysTrue", "", "AllwaysTrue", oDlgSB1, aHeader, aCols)
oList := TCBrowse():New(aPosObj[2][1]-10, aPosObj[2][2], aPosObj[2][4]-3, aPosObj[2][3]-30,,aHeader,,oDlgSB1,,,,,,,,,,,,.F.,,.T.,,.F.,,,)

_crtACols() 
               
oList:AddColumn( TCColumn():New("Codigo"			,{ || aCols2[oList:nAt,1] },,,,"LEFT",,.F.,.T.,,,,.F.,) ) 
oList:AddColumn( TCColumn():New("Cod.Verqui.1"  	,{ || aCols2[oList:nAt,2] },,,,"LEFT",,.F.,.T.,,,,.F.,) ) 
oList:AddColumn( TCColumn():New("Quantidade MP"		,{ || TRANSFORM(aCols2[oList:nAt,3], "@E 999,999,999.99") },,,,"LEFT",,.F.,.T.,,,,.F.,) ) 
oList:AddColumn( TCColumn():New("Quantidade PA"		,{ || TRANSFORM(aCols2[oList:nAt,4], "@E 999,999,999.99") },,,,"LEFT",,.F.,.T.,,,,.F.,) ) 
oList:AddColumn( TCColumn():New("Qtd Total PA+MP" 	,{ || TRANSFORM(aCols2[oList:nAt,5], "@E 999,999,999.99")},,,,"LEFT",,.F.,.T.,,,,.F.,) ) 
oList:AddColumn( TCColumn():New("Descricao"			,{ || aCols2[oList:nAt,6] },,,,"LEFT",,.F.,.T.,,,,.F.,) ) 
oList:AddColumn( TCColumn():New("Unidade Med.VQ"	,{ || aCols2[oList:nAt,7] },,,,"LEFT",,.F.,.T.,,,,.F.,) ) 
oList:AddColumn( TCColumn():New("Frete Compra"		,{ || aCols2[oList:nAt,8] },,,,"LEFT",,.F.,.T.,,,,.F.,) ) 
oList:AddColumn( TCColumn():New("Val.Ref.Comp"		,{ || TRANSFORM(aCols2[oList:nAt,9], "@E 999,999,999.99")},,,,"LEFT",,.F.,.T.,,,,.F.,) ) 
oList:AddColumn( TCColumn():New("Data Ref.Com"  	,{ || aCols2[oList:nAt,10] },,,,"LEFT",,.F.,.T.,,,,.F.,) ) 
oList:AddColumn( TCColumn():New("Moeda Verq."		,{ || aCols2[oList:nAt,11] },,,,"LEFT",,.F.,.T.,,,,.F.,) ) 
oList:AddColumn( TCColumn():New("Icms Tab.Prc"		,{ || TRANSFORM(aCols2[oList:nAt,12], "@E 9999.99") },,,,"LEFT",,.F.,.T.,,,,.F.,) ) 
oList:AddColumn( TCColumn():New("Bloqueado"			,{ || aCols2[oList:nAt,13] },,,,"LEFT",,.F.,.T.,,,,.F.,) ) 


oList:lUseDefaultColors := .F.    
oList:SetBlkBackColor({|| _getColor(oList:nAt,8421376)})   
oList:SetBlkColor({|| _getFColor(oList:nAt,8421376)}) 
oList:bLDblClick := {|| _btnConf(oList:nAt, @aCols2) }   

//oLista:oBrowse:bLine := { || {aCols[oLista:nAt,1], aCols[oLista:nAt,2], aCols[oLista:nAt,3], aCols[oLista:nAt,4], aCols[oLista:nAt,5],aCols[oLista:nAt,6], aCols[oLista:nAt,7], aCols[oLista:nAt,8], aCols[oLista:nAt,9], aCols[oLista:nAt,10], aCols[oLista:nAt,11], aCols[oLista:nAt,12], aCols[oLista:nAt,13]}}
//oLista:oBrowse:bLDblClick := {|| _btnConf(oLista:nAt, @aCols) }   
//oLista:oBrowse:lUseDefaultColors := .F. 
//oLista:oBrowse:LADJUSTCOLSIZE := .T.
//oLista:oBrowse:SetBlkBackColor({|| _getColor(oLista:nAt,8421376)})   
//oLista:oBrowse:SetBlkColor({|| _getFColor(oLista:nAt,8421376)}) 

//DEFINE SBUTTON FROM @ aPosObj[3][1],5 TYPE 1 ACTION _btnConf(oLista:nAt, @aCols)  ENABLE OF oDlgSB1     
//DEFINE SBUTTON FROM @ aPosObj[3][1],40 TYPE 2 ACTION oDlgSB1:End() ENABLE OF oDlgSB1

EnchoiceBar(oDlgSB1, {||  _btnConf(oList:nAt, @aCols2) }, {|| oDlgSB1:End() },,) //padrão Totvs

Activate MSDialog oDlgSB1 Centered

Return cCodigo

          
Static Function _btnConf(_nPos, aCols2, _bRet)
//	cCodigo := aCols[_nPos,1]    
	cCodigo := aCols2[_nPos,1]    
	oDlgSB1:End()
Return

Static Function _filtrar()
	_crtACols()
Return()

Static Function _crtHeader()
	AADD(aHeader, {"Codigo"	   		,"SB1"	,PesqPict("SB1","B1_COD")	,TamSX3("B1_COD")[1],0,"",,"C",,""})
	AADD(aHeader, {"Cod.Verqui.1"	,"SB1"  ,PesqPict("SB1","B1_VQ_COD"),TamSX3("B1_VQ_COD")[1],0,"",,"C",,""})
	AADD(aHeader, {"Quantidade MP"	,""    	,"@E 999,999,999.99"			,12	,2	,""	,,"N",,""})
	AADD(aHeader, {"Quantidade PA"	,""    	,"@E 999,999,999.99"			,12	,2	,""	,,"N",,""})
	AADD(aHeader, {"Qtd Total PA+MP",""    	,"@E 999,999,999.99"			,12	,2	,""	,,"N",,""})   
	AADD(aHeader, {"Descricao"	   	,"SB1"  ,PesqPict("SB1","B1_DESC")	,TamSX3("B1_DESC")[1],0,"",,"C",,""})
	AADD(aHeader, {"Unidade Med.VQ"	,"SB1"  ,PesqPict("SB1","B1_VQ_UM")	,TamSX3("B1_VQ_UM")[1],0,"",,"C",,""})
	AADD(aHeader, {"Frete Compra"	,"SB1"  ,PesqPict("SB1","B1_VQ_FRET"),TamSX3("B1_VQ_FRET")[1],0,"",,"C",,""})
	AADD(aHeader, {"Val.Ref.Comp"	,"SB1"  ,PesqPict("SB1","B1_VQ_RCOM"),TamSX3("B1_VQ_RCOM")[1],0,"",,"C",,""})
	AADD(aHeader, {"Data Ref.Com"	,"SB1"  ,"@D",10,0,"",,"D",,""})
	AADD(aHeader, {"Moeda Verq."	,"SB1"  ,PesqPict("SB1","B1_VQ_MOED"),TamSX3("B1_VQ_MOED")[1],0,"",,"C",,""})
	AADD(aHeader, {"Icms Tab.Prc"	,"SB1"  ,PesqPict("SB1","B1_VQ_ICMS"),TamSX3("B1_VQ_ICMS")[1],0,"",,"C",,""})
	AADD(aHeader, {"Bloqueado"		,""  	,"@!",3,0,"",,"C",,""})
	
Return        

Static Function _crtACols()
aCols := {}   
aCols2 := {}

cQuery := " SELECT  "
cQuery += "    B1_COD,           "   
cQuery += "    B1_DESC,       "      
cQuery += "    B1_VQ_COD,  "
cQuery += "    B1_VQ_UM,  "
cQuery += "    B1_VQ_MOED,   "
cQuery += "    B1_VQ_RCOM,  "
cQuery += "    B1_VQ_FRET,  "
cQuery += "    B1_VQ_DATA,  "
cQuery += "    B1_VQ_ICMS,  "
cQuery += "    B1_MSBLQL,  "
cQuery += "    (CASE WHEN QTDE_MATPRIMA IS NULL THEN 0 ELSE QTDE_MATPRIMA END) AS QTDE_MATPRIMA, "
cQuery += "    (CASE WHEN QTDE_PA IS NULL THEN 0 ELSE QTDE_PA END) AS QTDE_PA, "
cQuery += "    (CASE WHEN QTDE_MATPRIMA IS NULL THEN 0 ELSE QTDE_MATPRIMA END) + (CASE WHEN QTDE_PA IS NULL THEN 0 ELSE QTDE_PA END) AS SALDO_TOTAL  "
cQuery += " FROM ( "
cQuery += "   SELECT "
cQuery += "    B1_COD,        "     
cQuery += "    B1_DESC,     "       
cQuery += "    B1_VQ_COD, "
cQuery += "    B1_VQ_UM, "
cQuery += "    B1_VQ_MOED,  "
cQuery += "    B1_VQ_RCOM, "
cQuery += "    B1_VQ_FRET, "
cQuery += "    B1_VQ_DATA, "
cQuery += "    B1_VQ_ICMS,	     "
cQuery += "    B1_MSBLQL,	     "
cQuery += "    SUM((CASE WHEN B2_QATU IS NULL THEN 0 ELSE B2_QATU END))      AS QTDE_MATPRIMA "
cQuery += " 	FROM " +RetSQLName("SB1")+ " ASB1  "
cQuery += "       	 LEFT JOIN " + RetSQLName("SB2") + " ASB2  "    
cQuery += "           ON (ASB2.D_E_L_E_T_ <> '*' AND (B1_COD = B2_COD)) "
cQuery += "   WHERE "                                                
cQuery += "		ASB1.D_E_L_E_T_ <> '*' AND "
cQuery += " 	ASB1.B1_FILIAL = '" +xFilial("SB1")+ "' AND"
cQuery += "     B1_TIPO = 'MP' "
   
If(!Empty(cPesqu))
	If( cPesqu = "Codigo Verquimica" .AND. !Empty(cGNomCli) ) 
		cQuery += " AND B1_VQ_COD LIKE '%"+Upper(AllTrim(cGNomCli))+"%' "
	ElseIf( cPesqu = "Codigo Produto" .AND. !Empty(cGNomCli) ) 
		cQuery += " AND B1_COD LIKE '%"+Upper(AllTrim(cGNomCli))+"%' "
    EndIf
EndIf

cQuery += "   GROUP BY B1_COD, B1_DESC, B1_VQ_COD, B1_VQ_UM, B1_VQ_MOED, B1_VQ_RCOM, B1_VQ_FRET, B1_VQ_DATA, B1_VQ_ICMS, B1_MSBLQL "
cQuery += " ) TB1  "
cQuery += " LEFT JOIN (  "
cQuery += "  SELECT "
cQuery += "   B1_VQ_MP, "
cQuery += "   SUM((CASE WHEN B2_QATU IS NULL THEN 0 ELSE B2_QATU END)) AS QTDE_PA  "
cQuery += "  FROM " +RetSQLName("SB1")+ " ASB1      "
cQuery += "   LEFT JOIN " + RetSQLName("SB2") + " ASB2      ON (ASB2.D_E_L_E_T_ <> '*' AND (B1_COD = B2_COD))  "
cQuery += "    WHERE  B1_TIPO = 'PA' AND "   	     
cQuery += "		ASB1.D_E_L_E_T_ <> '*' AND "
cQuery += " 	ASB1.B1_FILIAL = '" +xFilial("SB1")+ "' "
cQuery += "  GROUP BY B1_VQ_MP ) TB2 ON (TB1.B1_COD = TB2.B1_VQ_MP) ORDER BY B1_COD "

If Select("TABTMP")>0
	TABTMP->(dbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS "TABTMP"
MemoWrite("C:\temp\sldestoq.txt",cQuery)

Dbselectarea("TABTMP")
While TABTMP->(!Eof())   
/*
	aAdd( aCols, { 	TABTMP->B1_COD, ;
					TABTMP->B1_VQ_COD, ; 
					TABTMP->QTDE_MATPRIMA,;
					TABTMP->QTDE_PA,; 
					TABTMP->SALDO_TOTAL,;
					TABTMP->B1_DESC,; 
					TABTMP->B1_VQ_UM,; 
					TABTMP->B1_VQ_FRET,; 
					TABTMP->B1_VQ_RCOM,;
					TABTMP->B1_VQ_DATA,;
					TABTMP->B1_VQ_MOED,; 
					TABTMP->B1_VQ_ICMS,;
					IIF(TABTMP->B1_MSBLQL="1","SIM","NAO"),;
					 .F. } )  
*/ 

	aAdd( aCols2, { 	TABTMP->B1_COD, ;
					TABTMP->B1_VQ_COD, ; 
					TABTMP->QTDE_MATPRIMA,;
					TABTMP->QTDE_PA,; 
					TABTMP->SALDO_TOTAL,;
					TABTMP->B1_DESC,; 
					TABTMP->B1_VQ_UM,; 
					TABTMP->B1_VQ_FRET,; 
					TABTMP->B1_VQ_RCOM,;
					StoD(TABTMP->B1_VQ_DATA),;
					TABTMP->B1_VQ_MOED,; 
					TABTMP->B1_VQ_ICMS,;
					IIF(TABTMP->B1_MSBLQL="1","SIM","NAO") } )   
					 
					 					 
					 
	TABTMP->(DbSkip())
EndDo


TABTMP->(dbCloseArea())   

//oLista:setArray(aCols)    
oList:SetArray(aCols2)

//oLista:Refresh()
oList:Refresh()

Return()    

Static Function _getColor(nLinha, nCor)
Local nRet := 16777215
	If(aCols2[nLinha,13] = "SIM")
		nRet := 128
	Endif      
Return(nRet)              

Static Function _getFColor(nLinha, nCor)
Local nRet := 16777215
	if (aCols2[nLinha,13] = "SIM") 
		nRet := CLR_WHITE   
	Else                    
		nRet := CLR_BLACK   
	Endif               
Return nRet      
