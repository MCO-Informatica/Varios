#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRELFAT02  บ Autor ณJunior Carvalho     บ Data ณ  17/02/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRelatorio AUDITORIA DENIS                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function IMCDAUD01()

Local aCabExcel := {}
Local aItensExcel := {}
Local aPergs := {}
Local cTitulo := "Rela็ใo Entradas, Saidas e OP"
Private lRet := .F.
Private aRet := {}

aAdd( aPergs ,{1,"Filial De            ",Space(02),"@!",'.T.',"XM0",'.T.',60,.F.})
aAdd( aPergs ,{1,"Filial Ate           ",Space(02),"@!",'.T.',"XM0",'.T.',60,.T.})
Aadd( aPergs ,{1,"Emissao De           ",FirstDate(dDatabase) ,"@E 99/99/9999","","","",100,.F.})
Aadd( aPergs ,{1,"Emissใo Ate          ",LastDate(dDatabase)  ,"@E 99/99/9999","","","",100,.T.})

If ParamBox(aPergs ," Parametros - "+cTitulo,aRet)
	
	// AADD(aCabExcel, {"TITULO DO CAMPO", "TIPO", NTAMANHO, NDECIMAIS})
	AADD(aCabExcel,{"MOVIMENTAวรO","C",3})
	AADD(aCabExcel,{"FILIAL","C",7})
	AADD(aCabExcel,{"PRODUTO","C",30})
	AADD(aCabExcel,{"UN","C",2})
	AADD(aCabExcel,{"QUANTIDADE","N",18,5})
	AADD(aCabExcel,{"CUSTO","N",18,5})
	AADD(aCabExcel,{"TIPO MOV","C",3})
	AADD(aCabExcel,{"DESCRIวรO","C",30})
	AADD(aCabExcel,{"DOCUMENTO/OP","C",20})
	AADD(aCabExcel,{"TERCEIRO","C",2})
	AADD(aCabExcel,{"EMISSAO","D",10})
	AADD(aCabExcel,{"CONTA","C",20})
	
	MsgRun("Favor Aguardar.....", "Selecionando os Registros... "+cTitulo,{|| GeraItens(@aItensExcel)})
	if lRet
		MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",;
		{||DlgToExcel({{"GETDADOS",cTitulo,aCabExcel,aItensExcel}})})
	Else
		Aviso( cTitulo,"Nenhum dado gerado! Verifique os parametros utilizados.",{"OK"},3)
	Endif
	
Else
	Aviso(cTitulo,"Pressionado Cancela",{"OK"},1)
EndIf

Return()

Static Function GeraItens( aCols )

Local cAlias := GetNextAlias()
Local cQuery   := ""
local lSF4Exc  := !empty(xFilial("SF4"))

cQuery += " SELECT * FROM ( "
cQuery += " SELECT "
cQuery += " 'ENT' MOV, D1_FILIAL FILIAL, D1_COD PRODUTO, D1_UM UM, D1_QUANT QUANTIDADE,D1_CUSTO CUSTO, "
cQuery += " D1_TES TIPO_MOV,  F4_TEXTO DESCRICAO, D1_DOC DOCUMENTO, F4_PODER3 TERCEIRO, D1_DTDIGIT EMISSAO, B1_CONTA CONTA "
cQuery += " FROM "+RETSQLNAME("SD1") +" SD1, "+RETSQLNAME("SF4")+" SF4, "+RETSQLNAME("SB1")+" SB1 "
cQuery += " WHERE  "
cQuery += " B1_COD = D1_COD "
cQuery += " AND SB1.D_E_L_E_T_ <> '*' "
cQuery += " AND F4_ESTOQUE = 'S' "
cQuery += " AND D1_TES = F4_CODIGO "
if lSF4Exc
	cQuery += " AND D1_FILIAL = F4_FILIAL "
endif
cQuery += " AND SF4.D_E_L_E_T_ <> '*' "
cQuery += " AND SD1.D_E_L_E_T_ <> '*' "

cQuery += " UNION ALL "

cQuery += " SELECT  "
cQuery += " 'OP ' MOV,D3_FILIAL, D3_COD, D3_UM, D3_QUANT, D3_CUSTO1, D3_CF,  F5_TEXTO , D3_OP, D3_PARCTOT, D3_EMISSAO EMISSAO, B1_CONTA "
cQuery += " FROM "+RETSQLNAME("SD3")+" SD3, "+RETSQLNAME("SF5")+" SF5, "+RETSQLNAME("SB1")+" SB1 "
cQuery += " WHERE  "
cQuery += " B1_COD = D3_COD "
cQuery += " AND SB1.D_E_L_E_T_ <> '*'"
cQuery += " AND F5_CODIGO  = D3_TM "
cQuery += " AND F5_FILIAL = D3_FILIAL "
cQuery += " AND SF5.D_E_L_E_T_ <> '*' "
cQuery += " AND D3_OP <> ' '  "
cQuery += " AND D3_ESTORNO = ' '  "
cQuery += " AND SD3.D_E_L_E_T_ <> '*' "

cQuery += " UNION ALL "

cQuery += " SELECT  "
cQuery += " 'SAI' MOV,D2_FILIAL, D2_COD, D2_UM, D2_QUANT,D2_CUSTO1, D2_TES, F4_TEXTO , D2_DOC, F4_PODER3, D2_EMISSAO EMISSAO, B1_CONTA  "
cQuery += " FROM "+RETSQLNAME("SD2")+" SD2, "+RETSQLNAME("SF4")+" SF4, "+RETSQLNAME("SB1")+" SB1 "
cQuery += " WHERE  "
cQuery += " B1_COD = D2_COD "
cQuery += " AND SB1.D_E_L_E_T_ <> '*'
cQuery += " AND F4_ESTOQUE = 'S' "
cQuery += " AND D2_TES = F4_CODIGO  "
if lSF4Exc
	cQuery += " AND D2_FILIAL = F4_FILIAL "
endif
cQuery += " AND SF4.D_E_L_E_T_ <> '*'  "
cQuery += " AND SD2.D_E_L_E_T_ <> '*' "

cQuery += " ORDER BY 1,2,7,6)  "
cQuery += " TABELAS "

cQuery += " WHERE FILIAL BETWEEN '"+aRet[1]+"' AND '"+aRet[2]+"' "
cQuery += " AND EMISSAO BETWEEN '"+DTOS(aRet[3])+"' AND '"+DTOS(aRet[4])+"' "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

TcSetField(cAlias,'QUANTIDADE','N',16,4)
TcSetField(cAlias,'CUSTO','N',16,4)
TcSetField(cAlias,'EMISSAO','D',8,0)

DbSelectArea(cAlias)
(cAlias)->(DbGoTop())
ProcRegua(RecCount())

While !(cAlias)->(EOF())
	
	IncProc("Aguarde o Processamento...")
	
	aAdd(aCols,{ (cAlias)->MOV, (cAlias)->FILIAL, (cAlias)->PRODUTO, (cAlias)->UM,(cAlias)->QUANTIDADE, (cAlias)->CUSTO,;
	(cAlias)->TIPO_MOV, (cAlias)->DESCRICAO, (cAlias)->DOCUMENTO, (cAlias)->TERCEIRO, (cAlias)->EMISSAO, (cAlias)->CONTA," "})
	
	(cAlias)->(DbSkip())
	lRet := .T.
	
EndDo

(cAlias)->(DbCloseArea())
MsErase(cAlias)
Return()
