#Include 'Protheus.ch'
#Include 'Rwmake.ch'
#INCLUDE 'TOPCONN.CH'

User Function RFATR04()

Local oReport
Local cPerg		:= Padr( "RFATR04", LEN( SX1->X1_GRUPO ) )
Local cAlias 	:= "SF2"
Local _aGrupo   := UsrRetGrp(,RetCodUsr())
Local _cGrupo   := Iif(__cUserID$"000000","000007",_aGrupo[1])

If Alltrim(_cGrupo)$"000007"   
	oReport := reportDef(cAlias, cPerg)
	oReport:printDialog()
Else
	MsgAlert("Você não tem permissão para emitir este relatório")
EndIf

return


//+-----------------------------------------------------------------------------------------------+
//! Função para criação da estrutura do relatório.                                                !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportDef(cAlias,cPerg)

local cTitle  := "RELACAO DA MARGEM DE CONTRIBUCAO DOS PRODUTOS"
local cHelp   := "RELACAO DA MARGEM DE CONTRIBUCAO DOS PRODUTOS"
local oReport
local oSection1
//local oSection2

oReport := TReport():New('RFATR04',cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)
oReport:SetPortrait()
oReport:SetTotalInLine(.F.)

//Primeira seção
oSection1 := TRSection():New(oReport,"Produtos",{"TMPSF2","SF2"})

TRCell():New(oSection1,"PRODUTO"	    , "TMPSF2", "PRODUTO"			,"@!"				                    ,20		)
TRCell():New(oSection1,"VENDAS"		    , "TMPSF2", "VENDAS"			,PesqPict('SF2','F2_VALMERC')			,30		)
TRCell():New(oSection1,"CMV"		    , "TMPSF2", "CMV"			    ,PesqPict('SF2','F2_VALMERC')			,30		)
TRCell():New(oSection1,"ICMS"		    , "TMPSF2", "ICMS"		    	,PesqPict('SF2','F2_VALMERC')			,30		)
TRCell():New(oSection1,"PIS"		    , "TMPSF2", "PIS"			    ,PesqPict('SF2','F2_VALMERC')			,30		)
TRCell():New(oSection1,"COFINS"		    , "TMPSF2", "COFINS"			,PesqPict('SF2','F2_VALMERC')			,30		)
TRCell():New(oSection1,"MARGEM"		    , "TMPSF2", "MARGEM"			,PesqPict('SF2','F2_VALMERC')			,30		)
TRCell():New(oSection1,"PERCENTUAL"		, "TMPSF2", "PERCENTUAL"		,PesqPict('SF2','F2_VALMERC')			,30		)

oReport:SetTotalInLine(.F.)   

//TRFunction():New(oSection1:Cell("PRODUTO"),NIL,"",,,,,.F.,.T.) 
TRFunction():New(oSection1:Cell("VENDAS"),NIL,"SUM",,,,,.F.,.T.) 
TRFunction():New(oSection1:Cell("CMV"),NIL,"SUM",,,,,.F.,.T.)    
TRFunction():New(oSection1:Cell("ICMS"),NIL,"SUM",,,,,.F.,.T.)    
TRFunction():New(oSection1:Cell("PIS"),NIL,"SUM",,,,,.F.,.T.)   	
TRFunction():New(oSection1:Cell("COFINS"),NIL,"SUM",,,,,.F.,.T.)   
TRFunction():New(oSection1:Cell("MARGEM"),NIL,"SUM",,,,,.F.,.T.)   
TRFunction():New(oSection1:Cell("PERCENTUAL"),NIL,"AVERAGE",,,,{ ||  },.F.,.T.)   
 
  
//oSection1:SetPageBreak(.T.)
//oSection1:SetTotalText(" ")				

Return(oReport)


//+-----------------------------------------------------------------------------------------------+
//! Rotina para montagem dos dados do relatório.                                  !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportPrint(oReport,cAlias)


Local oSection1 	:= oReport:Section(1)
//Local oSection2 	:= oReport:Section(2)
Local cQuery			:= ""
Local cRepTit		:= oReport:Title()
Local cTitulo		:= oReport:Title() 

Local cAliasNew		:= "TMPSF2"
Local aStruSF2 		:= SF2->(dbStruct())

cQuery := ""

cQuery += "SELECT PRODUTO, "
cQuery += "ROUND(SUM(VENDAS),2) VENDAS, "
cQuery += "ROUND(SUM(CMV),2) CMV, "
cQuery += "ROUND(SUM(ICMS),2) ICMS, "
cQuery += "ROUND(SUM(COFINS),2) COFINS, "
cQuery += "ROUND(SUM(PIS),2) PIS, "
cQuery += "ROUND((SUM(VENDAS) - SUM(CMV) - SUM(ICMS) - SUM(COFINS) - SUM(PIS)),2) MARGEM, "
cQuery += "ROUND(((((SUM(VENDAS) - SUM(CMV) - SUM(ICMS) - SUM(COFINS) - SUM(PIS))/ SUM(VENDAS)))*100),4) PERCENTUAL "

cQuery += "FROM  "

cQuery += "(SELECT DISTINCT BM_DESC PRODUTO, "
//cQuery += "ROUND(SUM(D2_TOTAL),2) VENDAS,  "
cQuery += "(CASE D2_CF WHEN '5117' THEN 0 "
cQuery += "WHEN '6117' THEN 0 "
cQuery += "ELSE ROUND(SUM(D2_TOTAL),2) "
cQuery += "END) VENDAS, "
cQuery += "ROUND(SUM(D2_CUSTO1),2) CMV,  "
cQuery += "ROUND(SUM(D2_VALICM),2) ICMS,  "
cQuery += "ROUND(SUM(D2_VALIMP5),2) COFINS,  "
cQuery += "ROUND(SUM(D2_VALIMP6),2) PIS, "
cQuery += "ROUND((SUM(D2_TOTAL) - SUM(D2_CUSTO1) - SUM(D2_VALICM) - SUM(D2_VALIMP5) - SUM(D2_VALIMP6)),2) MARGEM, "
cQuery += "ROUND(((((SUM(D2_TOTAL) - SUM(D2_CUSTO1) - SUM(D2_VALICM) - SUM(D2_VALIMP5) - SUM(D2_VALIMP6))/ SUM(D2_TOTAL)))*100),4) PERCENTUAL "

cQuery += "FROM SD2010  "
cQuery += "INNER JOIN SF4010 ON "
cQuery += "F4_FILIAL = D2_FILIAL "
cQuery += "AND F4_CODIGO = D2_TES "
cQuery += "AND (F4_DUPLIC = 'S' OR F4_CF IN ('5117','6117')) "
cQuery += "AND SF4010.D_E_L_E_T_='' "
cQuery += "INNER JOIN SBM010 ON "
cQuery += "BM_GRUPO = D2_GRUPO "
cQuery += "AND BM_GRUPO NOT IN ('3000','4000','5000') "
cQuery += "AND SBM010.D_E_L_E_T_='' "
cQuery += "WHERE D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'  "
cQuery += "AND D2_FILIAL = '01' "
cQuery += "AND D2_TIPO NOT IN ('B','D') "
cQuery += "AND SD2010.D_E_L_E_T_='' "
cQuery += "GROUP BY BM_DESC, D2_CF "

cQuery += "UNION ALL "

cQuery += "SELECT DISTINCT BM_DESC PRODUTO, "
cQuery += "ROUND(SUM(D1_TOTAL-D1_VALDESC),2)*(-1) VENDAS,  "
cQuery += "ROUND(SUM(D1_CUSTO),2)*(-1) CMV,  "
cQuery += "ROUND(SUM(D1_VALICM),2)*(-1) ICMS,  "
cQuery += "ROUND(SUM(D1_VALIMP5),2)*(-1) COFINS,  "
cQuery += "ROUND(SUM(D1_VALIMP6),2)*(-1) PIS, "
cQuery += "ROUND((SUM(D1_TOTAL) - SUM(D1_CUSTO) - SUM(D1_VALICM) - SUM(D1_VALIMP5) - SUM(D1_VALIMP6)),2)*(-1) MARGEM, "
cQuery += "ROUND(((((SUM(D1_TOTAL) - SUM(D1_CUSTO) - SUM(D1_VALICM) - SUM(D1_VALIMP5) - SUM(D1_VALIMP6))/ SUM(D1_TOTAL)))*100),4)*(-1) PERCENTUAL "

cQuery += "FROM SD1010  "
cQuery += "INNER JOIN SF4010 ON "
cQuery += "F4_FILIAL = D1_FILIAL "
cQuery += "AND F4_CODIGO = D1_TES "
cQuery += "AND F4_DUPLIC = 'S' "
cQuery += "AND SF4010.D_E_L_E_T_='' "
cQuery += "INNER JOIN SBM010 ON "
cQuery += "BM_GRUPO = D1_GRUPO "
cQuery += "AND BM_GRUPO NOT IN ('3000','4000','5000') "
cQuery += "AND SBM010.D_E_L_E_T_='' "
cQuery += "WHERE D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'  "
cQuery += "AND D1_TIPO IN ('B','D') "
cQuery += "AND D1_FILIAL = '01' "
cQuery += "AND SD1010.D_E_L_E_T_='' "
cQuery += "GROUP BY BM_DESC ) TRB "

cQuery += "GROUP BY PRODUTO "
cQuery += "ORDER BY PRODUTO "


cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasNew,.T.,.T.)

For nX := 1 To Len(aStruSF2)
	If aStruSF2[nX][2] <> "C" .and.  FieldPos(aStruSF2[nX][1]) > 0
		TcSetField(cAliasNew,aStruSF2[nX][1],aStruSF2[nX][2],aStruSF2[nX][3],aStruSF2[nX][4])
	EndIf
Next nX

oReport:SetMeter((cAliasNew)->(LastRec()))

oReport:SetTitle(cTitulo)

(cAliasNew)->(dbGoTop())
While (cAliasNew)->(!Eof())
	
	If oReport:Cancel()
		Exit
	EndIf
   
	//inicializo a primeira seção
	oSection1:Init()

	oReport:IncMeter()
	
	IncProc("Imprimindo Relatorio")

	_cPedido := (cAliasNew)->PRODUTO
	

	//oSection1:Cell("PRODUTO"):SetValue((cAliasNew)->PRODUTO)
	//oSection1:Printline()
		
	//inicializo a segunda seção
	//oSection2:init()


	While (cAliasNew)->(!Eof()) .and. (cAliasNew)->PRODUTO == _cPedido
	
	
		oReport:IncMeter()		
	
		
		oSection1:Cell("PRODUTO"):SetValue((cAliasNew)->PRODUTO)
		oSection1:Cell("VENDAS"):SetValue((cAliasNew)->VENDAS)
		oSection1:Cell("CMV"):SetValue((cAliasNew)->CMV)
		oSection1:Cell("ICMS"):SetValue((cAliasNew)->ICMS)
		oSection1:Cell("PIS"):SetValue((cAliasNew)->PIS)
		oSection1:Cell("COFINS"):SetValue((cAliasNew)->COFINS)
		oSection1:Cell("MARGEM"):SetValue((cAliasNew)->MARGEM)
		oSection1:Cell("PERCENTUAL"):SetValue((cAliasNew)->PERCENTUAL)
		
		oSection1:Printline()
	
		DbSelectArea(cAliasNew)
		(cAliasNew)->(dbSkip())
		
	End
	
	//oSection2:Finish()
	//oReport:ThinLine()

End

oReport:ThinLine()

//finalizo a primeira seção
oSection1:Finish()

IF Select(cAliasNew) <> 0
	DbSelectArea(cAliasNew)
	DbCloseArea()
ENDIF


return

