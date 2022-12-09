#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

// Programa.: CTBNFE
// Autor....: Alexandre Dalpiaz
// Data.....: 27/01/2012
// Descrição: PONTO DE ENTRADA NA CONTABILIZAÇÃO DAS NOTAS FISCAIS DE SAIDA
//			  UTILIZADO COM O PARAMETRO MV_OPTNFS






//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function CTBNFE()
//////////////////////

_aRet := aClone(paramixb)

aadd(_aRet[1],{"COALESCE(ROUND((D1_VALICM * DE_PERC / 100),2),0) DE_VALICM",'N',15,2}) 
aadd(_aRet[1],{"COALESCE(ROUND((D1_VALIPI * DE_PERC / 100),2),0) DE_VALIPI",'N',15,2}) 
aadd(_aRet[1],{"COALESCE(ROUND((D1_VALPIS * DE_PERC / 100),2),0) DE_VALPIS",'N',15,2}) 
aadd(_aRet[1],{"COALESCE(ROUND((D1_VALCOF * DE_PERC / 100),2),0) DE_VALCOF",'N',15,2}) 
aadd(_aRet[1],{"COALESCE(ROUND((D1_VALCSL * DE_PERC / 100),2),0) DE_VALCSL",'N',15,2}) 
aadd(_aRet[1],{"COALESCE(ROUND((D1_VALDESC * DE_PERC / 100),2),0) DE_VALDESC",'N',15,2}) 
aadd(_aRet[1],{"COALESCE(ROUND((D1_VALIMP5 * DE_PERC / 100),2),0) DE_VALIMP5",'N',15,2}) 
aadd(_aRet[1],{"COALESCE(ROUND((D1_VALIMP6 * DE_PERC / 100),2),0) DE_VALIMP6",'N',15,2}) 
aadd(_aRet[1],{"COALESCE(ROUND((D1_VALISS * DE_PERC / 100),2),0) DE_VALISS",'N',15,2}) 

aadd(_aRet[1],{'B1_GRUPO GRUPO','C',4,0})
aadd(_aRet[1],{"COALESCE(ZE.X5_DESCRI,'SX5 ZE GRUPO ' + SB1.B1_GRUPO) ZE_CONTA",'C',40,0})
aadd(_aRet[1],{"COALESCE(ZG.X5_DESCRI,'SX5 ZG GRUPO ' + SB1.B1_GRUPO) ZG_CONTA",'C',40,0})
aadd(_aRet[1],{"COALESCE(ZI.X5_DESCRI,'SX5 ZI GRUPO ' + SB1.B1_GRUPO) ZI_CONTA",'C',40,0})
aadd(_aRet[1],{"COALESCE(ZK.X5_DESCRI,'SX5 ZK GRUPO ' + SB1.B1_GRUPO) ZK_CONTA",'C',40,0})
aadd(_aRet[1],{"COALESCE(ZO.X5_DESCRI,'SX5 ZO GRUPO ' + SB1.B1_GRUPO) ZO_CONTA",'C',40,0})
aadd(_aRet[1],{"COALESCE(ZU.X5_DESCRI,'SX5 ZU GRUPO ' + SB1.B1_GRUPO) ZU_CONTA",'C',40,0})

aadd(_aRet[1],{"COALESCE(SDE.DE_PERC,0) DE_PERC"     ,'N',05,2})
aadd(_aRet[1],{"COALESCE(SDE.DE_CC,0) DE_CC"         ,'C',20,0})
aadd(_aRet[1],{"COALESCE(SDE.DE_CUSTO1,0) DE_CUSTO1" ,'N',12,2})
aadd(_aRet[1],{"COALESCE(CFOP.X5_DESCSPA,'SX5 CFOP DESCRICAO ' + SD1.D1_CF) CFOP_DESC",'C',40,0})                

_cQuery := " (SELECT COALESCE(CASE WHEN SDE.DE_CC = MIN(DE.DE_CC) THEN ROUND(D1_TOTAL - SUM(ROUND(D1_TOTAL*DE_PERC/100,2)),2) ELSE 0 END,0) DE_DIF""
_cQuery += " FROM SF1010 F1 , SD1010 D1 , SDE010 DE "
_cQuery += " WHERE  F1.F1_FILIAL = SF1.F1_FILIAL AND F1.F1_DOC = SF1.F1_DOC AND F1.F1_SERIE = SF1.F1_SERIE AND F1.F1_FORNECE = SF1.F1_FORNECE AND F1.F1_LOJA = SF1.F1_LOJA" 
_cQuery += " AND D1.D1_FILIAL = SF1.F1_FILIAL AND D1.D1_DOC = SF1.F1_DOC AND D1.D1_SERIE = SF1.F1_SERIE AND D1.D1_FORNECE = SF1.F1_FORNECE AND D1.D1_LOJA = SF1.F1_LOJA AND D1.D1_ITEM = SD1.D1_ITEM" 
_cQuery += " AND DE.DE_FILIAL = SF1.F1_FILIAL AND DE.DE_DOC = SF1.F1_DOC AND DE.DE_SERIE = SF1.F1_SERIE AND DE.DE_FORNECE = SF1.F1_FORNECE AND DE.DE_LOJA = SF1.F1_LOJA AND DE.DE_ITEMNF = SD1.D1_ITEM" 
_cQuery += " GROUP BY F1_DOC, F1_VALMERC, F1_VALBRUT, F1_VALIPI, D1_TOTAL) DE_DIF"
aadd(_aRet[1],{_cQuery,'N',5,2})                

_cQuery := " (SELECT CASE WHEN SDE.DE_CC = MIN(DE.DE_CC) THEN D1_VALPIS + D1_VALCSL + D1_VALCOF ELSE 0 END DE_PCC"
_cQuery += " FROM SF1010 F1 , SD1010 D1 , SDE010 DE "
_cQuery += " WHERE  F1.F1_FILIAL = SF1.F1_FILIAL AND F1.F1_DOC = SF1.F1_DOC AND F1.F1_SERIE = SF1.F1_SERIE AND F1.F1_FORNECE = SF1.F1_FORNECE "
_cQuery += " AND F1.F1_LOJA = SF1.F1_LOJA AND D1.D1_FILIAL = SF1.F1_FILIAL AND D1.D1_DOC = SF1.F1_DOC AND D1.D1_SERIE = SF1.F1_SERIE "
_cQuery += " AND D1.D1_FORNECE = SF1.F1_FORNECE AND D1.D1_LOJA = SF1.F1_LOJA AND D1.D1_ITEM = SD1.D1_ITEM AND DE.DE_FILIAL = SF1.F1_FILIAL "
_cQuery += " AND DE.DE_DOC = SF1.F1_DOC AND DE.DE_SERIE = SF1.F1_SERIE AND DE.DE_FORNECE = SF1.F1_FORNECE AND DE.DE_LOJA = SF1.F1_LOJA "
_cQuery += " AND DE.DE_ITEMNF = SD1.D1_ITEM GROUP BY F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, D1_VALPIS, D1_VALCSL, D1_VALCOF) DE_PCC"
aadd(_aRet[1],{_cQuery,'N',15,2})                

_cQuery := " (SELECT CASE WHEN SDE.DE_CC = MIN(DE.DE_CC) THEN D1_VALIRR ELSE 0 END DE_IRRF"
_cQuery += " FROM SF1010 F1 , SD1010 D1 , SDE010 DE "
_cQuery += " WHERE  F1.F1_FILIAL = SF1.F1_FILIAL AND F1.F1_DOC = SF1.F1_DOC AND F1.F1_SERIE = SF1.F1_SERIE AND F1.F1_FORNECE = SF1.F1_FORNECE "
_cQuery += " AND F1.F1_LOJA = SF1.F1_LOJA AND D1.D1_FILIAL = SF1.F1_FILIAL AND D1.D1_DOC = SF1.F1_DOC AND D1.D1_SERIE = SF1.F1_SERIE "
_cQuery += " AND D1.D1_FORNECE = SF1.F1_FORNECE AND D1.D1_LOJA = SF1.F1_LOJA AND D1.D1_ITEM = SD1.D1_ITEM AND DE.DE_FILIAL = SF1.F1_FILIAL "
_cQuery += " AND DE.DE_DOC = SF1.F1_DOC AND DE.DE_SERIE = SF1.F1_SERIE AND DE.DE_FORNECE = SF1.F1_FORNECE AND DE.DE_LOJA = SF1.F1_LOJA "
_cQuery += " AND DE.DE_ITEMNF = SD1.D1_ITEM GROUP BY F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, D1_VALIRR) DE_IRRF"
aadd(_aRet[1],{_cQuery,'N',15,2})                


aadd(_aRet[2],{RetSqlName('SDE'),'SDE'} )
aadd(_aRet[2],{RetSqlName('SX5'),'ZE'} )
aadd(_aRet[2],{RetSqlName('SX5'),'ZG'} )
aadd(_aRet[2],{RetSqlName('SX5'),'ZI'} )
aadd(_aRet[2],{RetSqlName('SX5'),'ZK'} )
aadd(_aRet[2],{RetSqlName('SX5'),'ZO'} )
aadd(_aRet[2],{RetSqlName('SX5'),'ZU'} )
aadd(_aRet[2],{RetSqlName('SX5'),'CFOP'} )

_aRet[3] := strtran(_aRet[3], "<>'LF'","=''")

_aRet[3] += " AND SDE.DE_FILIAL =* SD1.D1_FILIAL"
_aRet[3] += " AND SDE.DE_DOC =* SD1.D1_DOC"
_aRet[3] += " AND SDE.DE_SERIE =* SD1.D1_SERIE"
_aRet[3] += " AND SDE.DE_FORNECE =* SD1.D1_FORNECE"
_aRet[3] += " AND SDE.DE_LOJA =* SD1.D1_LOJA"
_aRet[3] += " AND SDE.DE_ITEMNF =* SD1.D1_ITEM"
_aRet[3] += " AND SDE.D_E_L_E_T_ = ''"

_aRet[3] += " AND ZE.X5_TABELA = 'ZE' AND ZE.X5_CHAVE =* B1_GRUPO AND ZE.D_E_L_E_T_ = ''"
_aRet[3] += " AND ZG.X5_TABELA = 'ZG' AND ZG.X5_CHAVE =* B1_GRUPO AND ZG.D_E_L_E_T_ = ''"
_aRet[3] += " AND ZI.X5_TABELA = 'ZI' AND ZI.X5_CHAVE =* B1_GRUPO AND ZI.D_E_L_E_T_ = ''"
_aRet[3] += " AND ZK.X5_TABELA = 'ZK' AND ZK.X5_CHAVE =* B1_GRUPO AND ZK.D_E_L_E_T_ = ''"
_aRet[3] += " AND ZO.X5_TABELA = 'ZO' AND ZO.X5_CHAVE =* B1_GRUPO AND ZO.D_E_L_E_T_ = ''"
_aRet[3] += " AND ZU.X5_TABELA = 'ZU' AND ZU.X5_CHAVE =* B1_GRUPO AND ZU.D_E_L_E_T_ = ''"
_aRet[3] += " AND CFOP.X5_TABELA = '13' AND CFOP.X5_CHAVE =* D1_CF AND CFOP.D_E_L_E_T_ = ''"

_aRet[3] += " AND F1_DOC BETWEEN '" + mv_par09 + "' AND '" + mv_par10 + "'"

Return(_aRet)                                                	



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function CT010BRW()
////////////////////////
If cFilAnt >= '01' .and. cFilAnt <= '99'
	cFilAnt := '01'
ElseIf cFilAnt >= 'A0' .and. cFilAnt <= 'AZ'
	cFilAnt := 'A0'
ElseIf (cFilAnt >= 'C0' .and. cFilAnt <= 'EZ') .or. cFilAnt == 'GH'
	cFilAnt := 'C0'
ElseIf cFilAnt == 'BH'
	cFilAnt := 'BH'
ElseIf cFilAnt >= 'G0' .and. cFilAnt <= 'GZ'
	cFilAnt := 'G0'
ElseIf cFilAnt >= 'T0' .and. cFilAnt <= 'TZ'
	cFilAnt := 'T0'
ElseIf cFilAnt >= 'R0' .and. cFilAnt <= 'RZ'
	cFilAnt := 'R0'
EndIf

//set filter to CTG_FILIAL == cFilAnt

Return()

User Function CT010GRV()

a := 0
DbSelectArea('SM0')
If cFilAnt == '01' 
	Set filter to cFilAnt >= '01'.and. cFilAnt <= '99'
ElseIf cFilAnt == 'A0'
	Set filter to cFilAnt >= 'A0'.and. cFilAnt <= '99'
ElseIf cFilAnt == 'C0'
	Set filter to cFilAnt >= 'C0'.and. cFilAnt <= '99'
ElseIf cFilAnt == 'BH'
	Set filter to cFilAnt == 'BH'
ElseIf cFilAnt == 'G0'
	Set filter to cFilAnt >= 'G0'.and. cFilAnt <= 'GZ'
ElseIf cFilAnt == 'T0'
	Set filter to cFilAnt >= 'T0'.and. cFilAnt <= 'TZ'
ElseIf cFilAnt == 'R0'
	Set filter to cFilAnt >= 'R0'.and. cFilAnt <= 'RZ'
EndIf

DbGoTop()
Do While !eof()
	DbSelectArea('CTG')
	//RecLock('CTG',!DbSeek(SM0->M0_CODFIL +  
	DbSelectArea('SM0')
	DbSkip()
EndDo

Set Filter to
DbSeek(cEmpAnt + cFilAnt)

Return()



