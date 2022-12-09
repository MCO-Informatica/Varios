#include 'protheus.ch'

#DEFINE PRODUTDE	1
#DEFINE PRODUTATE	2
#DEFINE LOCALDE		3
#DEFINE LOCALATE	4
#DEFINE LOTEDE		5
#DEFINE LOTEATE		6
#DEFINE SBLOTEDE	7
#DEFINE SBLOTEATE	8

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPZCVP002 บAutor  ณMicrosiga 	          บ Data ณ 12/12/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de reprocessamento da atividade					  บฑฑ
ฑฑบ          ณ												    		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PZCVP002()

Local aArea 	:= GetArea()
Local aParams    := {}

If CVPerg(@aParams)  

	Processa( {|| ProcAtivB8(aParams[PRODUTDE],;	//Produto de
							aParams[PRODUTATE],;	//Produto ate
							aParams[LOCALDE],;		//Loja de
							aParams[LOCALATE],;		//Loja ate
							aParams[LOTEDE],;		//Lote de 
							aParams[LOTEATE],;		//Lote ate
							aParams[SBLOTEDE],;		//Sub-lote de
							aParams[SBLOTEATE];		//Sub-lote ate
							);
	 			},"Aguarde...","" )
	 
	 Aviso("Aten็ใo","Reprocessamento finalizado.",{"Ok"},2)
EndIf   

RestArea(aArea)	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProcAtivB8 บAutor  ณMicrosiga	          บ Data ณ 19/12/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de reprocessamento da Atividade					  บฑฑ
ฑฑบ          ณ												    		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ProcAtivB8(cProdDe, cProdAte, cLocalDe, cLocalAte, cLoteDe, cLoteAte, cSbLoteDe, cSbLoteAte)

Local aArea		:= GetArea()
Local cQuery	:= ""
Local cArqTmp	:= GetNextAlias()
Local nCnt		:= 0

Default cProdDe		:= "" 
Default cProdAte	:= "" 
Default cLocalDe	:= "" 
Default cLocalAte	:= "" 
Default cLoteDe		:= "" 
Default cLoteAte	:= "" 
Default cSbLoteDe	:= "" 
Default cSbLoteAte	:= ""

cQuery	:= " SELECT * FROM "+RetSqlName("SZ1")+" SZ1 "+CRLF
cQuery	+= " WHERE SZ1.Z1_FILIAL = '"+xFilial("SZ1")+"' "+CRLF
cQuery	+= " AND SZ1.Z1_PRODUTO BETWEEN '"+cProdDe+"' AND '"+cProdAte+"' "+CRLF
cQuery	+= " AND SZ1.Z1_LOCAL BETWEEN '"+cLocalDe+"' AND '"+cLocalAte+"' "+CRLF
cQuery	+= " AND SZ1.Z1_LOTECTL BETWEEN '"+cLoteDe+"' AND '"+cLoteAte+"' "+CRLF
cQuery	+= " AND SZ1.Z1_NUMLOTE BETWEEN '"+cSbLoteDe+"' AND '"+cSbLoteAte+"' " +CRLF
cQuery	+= " AND D_E_L_E_T_ = ' ' "+CRLF

DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

(cArqTmp)->( DbGoTop() )
(cArqTmp)->( dbEval( {|| nCnt++ },,{ || !Eof() } ) )
(cArqTmp)->( DbGoTop() )

ProcRegua(nCnt)

While (cArqTmp)->(!Eof())
	
	IncProc("Processando...")
	
	//Atualiza a atividade
	U_PZCVA003((cArqTmp)->Z1_PRODUTO, (cArqTmp)->Z1_LOCAL, (cArqTmp)->Z1_LOTECTL, (cArqTmp)->Z1_NUMLOTE, (cArqTmp)->Z1_ATIVIDA )
	
	(cArqTmp)->(DbSkip())
EndDo

If Select(cArqTmp) > 0
	(cArqTmp)->(DbCloseArea())
EndIf

RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณCVPerg	บAutor  ณMicrosiga		     บ Data ณ  12/12/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Perguntas a serem utilizadas no filtro				      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CVPerg(aParams)

Local aParamBox := {}
Local lRet      := .T.
Local cLoadArq	:= "PZCVP002"+Alltrim(RetCodUsr())+Alltrim(cEmpAnt) 

AADD(aParamBox,{1,"Produto de"			,Space(TAMSX3("B1_COD")[1])		,""	,"","SB1","",50,.F.})
AADD(aParamBox,{1,"Produto ate"			,Space(TAMSX3("B1_COD")[1])		,""	,"","SB1","",50,.T.})
AADD(aParamBox,{1,"Armaz. de"			,Space(TAMSX3("B2_LOCAL")[1])	,""	,"","","",50,.F.})
AADD(aParamBox,{1,"Armaz. ate"			,Space(TAMSX3("B2_LOCAL")[1])	,""	,"","","",50,.T.})
AADD(aParamBox,{1,"Lote de"				,Space(TAMSX3("B8_LOTECTL")[1])	,""	,"","","",50,.F.})
AADD(aParamBox,{1,"Lote ate"			,Space(TAMSX3("B8_LOTECTL")[1])	,""	,"","","",50,.T.})
AADD(aParamBox,{1,"Sub-Lote de"			,Space(TAMSX3("B8_NUMLOTE")[1])	,""	,"","","",50,.F.})
AADD(aParamBox,{1,"Sub-Lote ate"		,Space(TAMSX3("B8_NUMLOTE")[1])	,""	,"","","",50,.T.})

lRet := ParamBox(aParamBox, "Parโmetros", aParams, , /*alButtons*/, .T., /*nlPosx*/, /*nlPosy*/,, cLoadArq, .t., .t.)

Return lRet
