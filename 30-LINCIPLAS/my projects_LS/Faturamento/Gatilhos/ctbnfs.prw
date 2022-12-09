#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

// Programa.: CTBNFS
// Autor....: Alexandre Dalpiaz
// Data.....: 27/01/2012
// Descrição: PONTO DE ENTRADA NA CONTABILIZAÇÃO DAS NOTAS FISCAIS DE SAIDA
//			  UTILIZADO COM O PARAMETRO MV_OPTNFS 

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function CTBNFS()
//////////////////////

_aRet := aClone(paramixb)
aadd(_aRet[1],{'B1_GRUPO GRUPO','C',4,0})
aadd(_aRet[1],{"ISNULL(ZK.X5_DESCRI, 'SX5 ZK GRUPO ' + SB1.B1_GRUPO) ZK_CONTA",'C',40,0})
aadd(_aRet[1],{"ISNULL(ZK.X5_DESCSPA,'SX5 ZK GRUPO ' + SB1.B1_GRUPO) ZK_GRUPO",'C',40,0})
aadd(_aRet[1],{"ISNULL(ZH.X5_DESCRI, 'SX5 ZH GRUPO ' + SB1.B1_GRUPO) ZH_CONTA",'C',40,0})
aadd(_aRet[1],{"ISNULL(ZH.X5_DESCSPA,'SX5 ZH GRUPO ' + SB1.B1_GRUPO) ZH_GRUPO",'C',40,0})
aadd(_aRet[1],{"ISNULL(ZL.X5_DESCRI, 'SX5 ZL GRUPO ' + SB1.B1_GRUPO) ZL_CONTA",'C',40,0})
aadd(_aRet[1],{"ISNULL(ZL.X5_DESCSPA,'SX5 ZL GRUPO ' + SB1.B1_GRUPO) ZL_GRUPO",'C',40,0}) 
aadd(_aRet[1],{"ISNULL(CFOP.X5_DESCSPA,'SX5 CFOP DESCRICAO ' + SD2.D2_CF) CFOP_DESC",'C',40,0}) 


aadd(_aRet[2],{RetSqlName('SX5'),'ZK'} )
aadd(_aRet[2],{RetSqlName('SX5'),'ZL'} )
aadd(_aRet[2],{RetSqlName('SX5'),'ZH'} )
aadd(_aRet[2],{RetSqlName('SX5'),'CFOP'} )

_aRet[3] := strtran(_aRet[3], "<>'LF'","=''")
_aRet[3] += " AND ZK.X5_TABELA = 'ZK' AND ZK.X5_CHAVE =* B1_GRUPO AND ZK.D_E_L_E_T_ = ''"
_aRet[3] += " AND ZL.X5_TABELA = 'ZL' AND ZL.X5_CHAVE =* B1_GRUPO AND ZL.D_E_L_E_T_ = ''"
_aRet[3] += " AND ZH.X5_TABELA = 'ZH' AND ZH.X5_CHAVE =* B1_GRUPO AND ZH.D_E_L_E_T_ = ''"
_aRet[3] += " AND CFOP.X5_TABELA = '13' AND CFOP.X5_CHAVE =* D2_CF AND CFOP.D_E_L_E_T_ = ''"

_aRet[3] += " AND F2_DOC BETWEEN '" + mv_par10 + "' AND '" + mv_par11 + "'"
Return(_aRet)