#include 'protheus.ch'
#include 'parmtype.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณPZBC0001	บAutor  ณMicrosiga		     บ Data ณ  13/12/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBACA (Provis๓rio) para o preenchimento da FCI			      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PZBC0001() 

Local aArea 	:= GetArea() 
Local aParams   := {}

If BCCVPerg(@aParams)
	Processa( {|| ProcFci(aParams[1], aParams[2], aParams[3]) },"Aguarde...","" )
EndIf

RestArea(aArea)	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณBCCVPerg	บAutor  ณMicrosiga		     บ Data ณ  13/12/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Perguntas a serem utilizadas no filtro				      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function BCCVPerg(aParams)

Local aParamBox := {}
Local lRet      := .T.
Local cLoadArq	:= "PZBC0001"+Alltrim(RetCodUsr())+Alltrim(cEmpAnt) 

AADD(aParamBox,{1,"Periodo Venda"		,Space(TAMSX3("CFD_PERVEN")[1])	,"@E 999999"	,"","","",50,.T.})
AADD(aParamBox,{1,"Produto de"			,Space(TAMSX3("B1_COD")[1])		,""	,"","SB1","",50,.F.})
AADD(aParamBox,{1,"Produto ate"			,Space(TAMSX3("B1_COD")[1])		,""	,"","SB1","",50,.T.})

lRet := ParamBox(aParamBox, "Parโmetros", aParams, , /*alButtons*/, .T., /*nlPosx*/, /*nlPosy*/,, cLoadArq, .t., .t.)

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณProcFci	บAutor  ณMicrosiga		     บ Data ณ  13/12/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ														      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ProcFci(cPeriodo, cProdDe, cProdAte)

Local aArea := GetArea()
Local cQuery	:= ""
Local cArqTmp	:= GetNextAlias()	
Local nCnt		:= 0

Default cPeriodo	:= "" 
Default cProdDe		:= "" 
Default cProdAte	:= "" 

cQuery	:= " SELECT DISTINCT CFD_COD " +CRLF
cQuery	+= "		FROM "+RetSqlName("CFD")+" CFD "+CRLF
cQuery	+= " WHERE CFD.CFD_FILIAL = '"+xFilial("CFD")+"' "+CRLF 
//cQuery	+= " AND CFD.CFD_PERCAL < '"+cPeriodo+"' "+CRLF
cQuery	+= " AND CFD.CFD_PERVEN >= '012019' "+CRLF
cQuery	+= " AND CFD.CFD_PERVEN < '"+cPeriodo+"' "+CRLF
cQuery	+= " AND CFD.CFD_COD BETWEEN '"+cProdDe+"' AND '"+cProdAte+"' " +CRLF
//cQuery	+= " AND CFD.CFD_FCICOD != '' "+CRLF
cQuery	+= " AND CFD.D_E_L_E_T_ = ' ' "+CRLF
cQuery	+= " AND NOT EXISTS(SELECT * FROM "+RetSqlName("CFD")+" CFD2 "+CRLF
cQuery	+= " 				WHERE CFD2.CFD_FILIAL = CFD.CFD_FILIAL " +CRLF
//cQuery	+= " 				AND CFD2.CFD_PERCAL = '"+cPeriodo+"' "+CRLF
cQuery	+= " 				AND CFD2.CFD_PERVEN = '"+cPeriodo+"' "+CRLF
cQuery	+= " 				AND CFD2.CFD_COD = CFD.CFD_COD "+CRLF
//cQuery	+= " 				AND CFD2.CFD_FCICOD != '' "+CRLF
cQuery	+= " 				AND D_E_L_E_T_ = ' ' "+CRLF
cQuery	+= " 				) "+CRLF

DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

(cArqTmp)->( DbGoTop() )
(cArqTmp)->( dbEval( {|| nCnt++ },,{ || !Eof() } ) )
(cArqTmp)->( DbGoTop() )

ProcRegua(nCnt)

While (cArqTmp)->(!Eof())
	
	IncProc("Processando...")
	
	//Grava CFD para cada produto
	GrvPrdCFD((cArqTmp)->CFD_COD, cPeriodo)
	
	(cArqTmp)->(DbSkip())
EndDo

If Select(cArqTmp) > 0
	(cArqTmp)->(DbCloseArea())
Endif

RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณGrvPrdCFD	บAutor  ณMicrosiga		     บ Data ณ  13/12/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGrava os dados do produto na tabela CFD				      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GrvPrdCFD(cProd, cPeriodo)

Local aArea		:= GetArea()
Local cQuery	:= ""
Local cArqTmp	:= GetNextAlias()	

Default cProd		:= "" 
Default cPeriodo	:= "" 

//cQuery	:= " SELECT SubString(CFD_PERCAL,3,4) + SubString(CFD_PERCAL,1,2) ANOMES, "+CRLF 
cQuery	:= " SELECT SubString(CFD_PERVEN,3,4) + SubString(CFD_PERVEN,1,2) ANOMES, "+CRLF 
//cQuery	+= "		CFD_FILIAL, CFD_PERCAL, CFD_COD, CFD_OP, CFD_VPARIM, CFD_VSAIIE, CFD_CONIMP, CFD_FCICOD, CFD_FILOP, CFD_ORIGEM, R_E_C_N_O_ RECCFD " +CRLF 
cQuery	+= "		CFD_FILIAL, CFD_PERVEN, CFD_COD, CFD_OP, CFD_VPARIM, CFD_VSAIIE, CFD_CONIMP, CFD_FCICOD, CFD_FILOP, CFD_ORIGEM, R_E_C_N_O_ RECCFD " +CRLF 
cQuery	+= "		FROM "+RetSqlName("CFD")+" CFD "+CRLF
cQuery	+= " WHERE CFD.CFD_FILIAL = '"+xFilial("CFD")+"' "+CRLF 
//cQuery	+= " AND CFD.CFD_PERCAL <= '"+cPeriodo+"' "+CRLF
cQuery	+= " AND CFD.CFD_PERVEN >= '012019' "+CRLF
cQuery	+= " AND CFD.CFD_PERVEN <= '"+cPeriodo+"' "+CRLF
cQuery	+= " AND CFD.CFD_COD = '"+cProd+"' " +CRLF
cQuery	+= " AND CFD.D_E_L_E_T_ = ' ' "+CRLF
cQuery	+= " AND NOT EXISTS(SELECT * FROM "+RetSqlName("CFD")+" CFD2 "+CRLF
cQuery	+= " 				WHERE CFD2.CFD_FILIAL = CFD.CFD_FILIAL " +CRLF
//cQuery	+= " 				AND (CFD2.CFD_PERCAL = '"+cPeriodo+"' AND CFD2.CFD_FCICOD != '' ) "+CRLF
cQuery	+= " 				AND (CFD2.CFD_PERVEN = '"+cPeriodo+"') "+CRLF
cQuery	+= " 				AND CFD2.CFD_COD = CFD.CFD_COD "+CRLF
cQuery	+= " 				AND D_E_L_E_T_ = ' ' "+CRLF
cQuery	+= " 				) "+CRLF
cQuery	+= " ORDER BY ANOMES DESC "+CRLF

DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)
/*
If (cArqTmp)->(!Eof())
	
	If Empty((cArqTmp)->CFD_FCICOD)
				
		DbSelectArea("CFD")
		DbSetOrder(1)

		While (cArqTmp)->(!Eof())  
			
			CFD->(DbGoTo((cArqTmp)->RECCFD))
			If Alltrim(CFD->CFD_PERCAL) == Alltrim(cPeriodo) .And. Empty((cArqTmp)->CFD_FCICOD)
				RecLock("CFD",.F.)
				CFD->(DbDelete())
				CFD->(MsUnLock())
			EndIf
			
			If !Empty((cArqTmp)->CFD_FCICOD) .And. Alltrim(CFD->CFD_PERCAL) != Alltrim(cPeriodo)
				//Cria a nova linha com os dados do ultimo registro
				RecLock("CFD",.T.)
				CFD->CFD_FILIAL	:= (cArqTmp)->CFD_FILIAL 
				CFD->CFD_PERCAL := cPeriodo
				CFD->CFD_PERVEN	:= GetPerVen(cPeriodo) 
				CFD->CFD_COD	:= (cArqTmp)->CFD_COD   
				CFD->CFD_OP		:= (cArqTmp)->CFD_OP    
				CFD->CFD_VPARIM	:= (cArqTmp)->CFD_VPARIM
				CFD->CFD_VSAIIE	:= (cArqTmp)->CFD_VSAIIE 
				CFD->CFD_CONIMP	:= (cArqTmp)->CFD_CONIMP
				CFD->CFD_FCICOD	:= (cArqTmp)->CFD_FCICOD
				CFD->CFD_FILOP	:= (cArqTmp)->CFD_FILOP 
				CFD->CFD_ORIGEM	:= (cArqTmp)->CFD_ORIGEM
				CFD->CFD_YORIGE	:= "PZBC0001"
				CFD->(MsUnLock())
			
				Exit
			EndIf
			
			(cArqTmp)->(DbSkip())
		EndDo
	
	ElseIf Alltrim((cArqTmp)->CFD_PERCAL) != Alltrim(cPeriodo)
	
		//Cria a nova linha com os dados do ultimo registro
		RecLock("CFD",.T.)
		CFD->CFD_FILIAL	:= (cArqTmp)->CFD_FILIAL 
		CFD->CFD_PERCAL := cPeriodo
		CFD->CFD_PERVEN	:= GetPerVen(cPeriodo) 
		CFD->CFD_COD	:= (cArqTmp)->CFD_COD   
		CFD->CFD_OP		:= (cArqTmp)->CFD_OP    
		CFD->CFD_VPARIM	:= (cArqTmp)->CFD_VPARIM
		CFD->CFD_VSAIIE	:= (cArqTmp)->CFD_VSAIIE 
		CFD->CFD_CONIMP	:= (cArqTmp)->CFD_CONIMP
		CFD->CFD_FCICOD	:= (cArqTmp)->CFD_FCICOD
		CFD->CFD_FILOP	:= (cArqTmp)->CFD_FILOP 
		CFD->CFD_ORIGEM	:= (cArqTmp)->CFD_ORIGEM
		CFD->CFD_YORIGE	:= "PZBC0001"
		CFD->(MsUnLock())
	EndIf
EndIf 
*/


If (cArqTmp)->(!Eof())

	If Alltrim((cArqTmp)->CFD_PERVEN) != Alltrim(cPeriodo)	
		//Cria a nova linha com os dados do ultimo registro
		RecLock("CFD",.T.)
		CFD->CFD_FILIAL	:= (cArqTmp)->CFD_FILIAL 
		CFD->CFD_PERCAL := cPeriodo
		CFD->CFD_PERVEN	:= cPeriodo 
		CFD->CFD_COD	:= (cArqTmp)->CFD_COD   
		CFD->CFD_OP		:= (cArqTmp)->CFD_OP    
		CFD->CFD_VPARIM	:= (cArqTmp)->CFD_VPARIM
		CFD->CFD_VSAIIE	:= (cArqTmp)->CFD_VSAIIE 
		CFD->CFD_CONIMP	:= (cArqTmp)->CFD_CONIMP
		CFD->CFD_FCICOD	:= (cArqTmp)->CFD_FCICOD
		CFD->CFD_FILOP	:= (cArqTmp)->CFD_FILOP 
		CFD->CFD_ORIGEM	:= (cArqTmp)->CFD_ORIGEM
		CFD->CFD_YORIGE	:= "PZBC0001"
		CFD->(MsUnLock())
	EndIf

EndIf 


If Select(cArqTmp) > 0
	(cArqTmp)->(DbCloseArea())
Endif

RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณGetPerVen		บAutor  ณMicrosiga	     บ Data ณ  13/12/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o periodo da venda							      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetPerVen(cPerApur)

Local dDtAux	:= CTOD('')
Local cDtRet	:= ""
Local cAnoApur	:= ""
Local cMesApur	:= ""
Local cMesAux	:= ""

Default cPerApur := ""

cAnoApur	:= SubString(cPerApur,3,4)
cMesApur	:= SubString(cPerApur,1,2)

dDtAux := CTOD("01/"+cMesApur+"/"+cAnoApur)  
dDtAux := MonthSub( dDtAux , 2 )

If Month(dDtAux)<10
	cMesAux := "0"+Alltrim(Str(Month(dDtAux))) 
Else
	cMesAux := Alltrim(Str(Month(dDtAux)))
EndIf

cDtRet := cMesAux + Alltrim(Str(Year(dDtAux))) 

Return cDtRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณGetPerProc	บAutor  ณMicrosiga	     บ Data ณ  13/12/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o periodo de processamento					      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*Static Function GetPerProc(cAnoMes, cPerApur)

Local aRet			:= {}
Local cAnoUl		:= ""
Local cMesUl		:= ""
Local cAnoApur		:= ""
Local cMesApur		:= ""
Local aDifMesAno	:= {}
Local nQtdAno		:= 0
Local nQtdMes		:= 0

Default cAnoMes		:= "" 
Default cPerApur	:= ""	

cAnoUl	:= SubString(cAnoMes,3,4)
cMesUl	:= SubString(cAnoMes,1,2)

cAnoApur	:= SubString(cPerApur,3,4)
cMesApur	:= SubString(cPerApur,1,2)

//Diferen็a de ano m๊s e dias
aDifMesAno	:= DateDiffYMD( CTOD("01/"+cMesUl+"/"+cAnoUl), CTOD("01/"+cMesApur+"/"+cAnoApur) )

//Quantidade de anos nใo apurado
nQtdAno := aDifMesAno[1]

//Quantidade de meses nใo apurado 
nQtdMes := aDifMesAno[2]


Return*/


/*
DaySum( dDate , nDays ) //Soma Dias em Uma Data
DaySub( dDate , nDays ) //Subtrai Dias em Uma Data
MonthSum( dDate , nMonth ) //Soma Meses em Uma Data
MonthSub( dDate , nMonth ) //Subtrai Meses em Uma Data
YearSum( dDate , nYear ) //Soma Anos em Uma Data
YearSub( dDate , nYear ) //Subtrai Anos em Uma Data
DateDiffDay( dDate1 , dDate2 ) //Apura Diferenca em Dias entre duas Datas
DateDiffMonth( dDate1 , dDate2 ) //Apura Diferenca em Meses entre duas Datas
DateDiffYear( dDate1 , dDate2 ) //Apura Diferenca em Anos entre duas Datas
DateDiffYMD( dDate1 , dDate2 ) //Retorna Array contendo a Diferenca de Anos/Meses/Dias entre duas Datas
ElapTime (cHoraInicial, cHoraFinal) //Retorna uma string, com o n๚mero de segundos decorridos entre dois horแrios (hora inicial e final) diferentes, no formato hh:mm:ss.
*/
