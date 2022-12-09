#INCLUDE "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � cfina001  �Autor  �                   � Data �  28/01/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera��o de Dados Excel - SE1 / Dados para Controle de      ���
���          � Comiss�o                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � AP7 - Espec�fico CertiSign                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION cfina01()

PutSx1("CFIN01","01","Emiss�o De"               ,"Emiss�o De"               ,"Emiss�o De"                       ,"mv_ch1","D",08,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",;
{"Emiss�o Inicial (Branco para todos)"},;
{"Emiss�o Inicial (Branco para todos)"},;
{"Emiss�o Inicial (Branco para todos)"},"","","","","","","")
PutSx1("CFIN01","02","Emiss�o Ate"              ,"Emiss�o Ate"              ,"Emiss�o Ate"                      ,"mv_ch2","D",08,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",;
{"Emiss�o Final (ZZZZZZZZZZ para todos)"},;
{"Emiss�o Final (ZZZZZZZZZZ para todos)"},;
{"Emiss�o Final (ZZZZZZZZZZ para todos)"},"","","","","","","")
PutSx1("CFIN01","03","Recebimento De"               ,"Recebimento De"               ,"Recebimento De"           ,"mv_ch3","D",08,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",;
{"Recebimento Inicial (Branco para todos)"},;
{"Recebimento Inicial (Branco para todos)"},;
{"Recebimento Inicial (Branco para todos)"},"","","","","","","")
PutSx1("CFIN01","04","Recebimento Ate"               ,"Recebimento Ate"               ,"Recebimento Ate"        ,"mv_ch4","D",08,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","",;
{"Recebimento Final (ZZZZ para todos)"},;
{"Recebimento Final (ZZZZ para todos)"},;
{"Recebimento Final (ZZZZ para todos)"},"","","","","","","")
PutSx1("CFIN01","05","Vendedor De"               ,"Vendedor De"               ,"Vendedor De"                    ,"mv_ch5","C",06,0,0,"G","","SA3","","","mv_par05","","","","","","","","","","","","","","","","",;
{"Vendedor Inicial (Branco para todos)"},;
{"Vendedor Inicial (Branco para todos)"},;
{"Vendedor Inicial (Branco para todos)"},"","","","","","","")
PutSx1("CFIN01","06","Vendedor Ate"               ,"Vendedor Ate"               ,"Vendedor Ate"                 ,"mv_ch6","C",06,0,0,"G","","SA3","","","mv_par06","","","","","","","","","","","","","","","","",;
{"Vendedor Final (ZZZZZZ para todos)"},;
{"Vendedor Final (ZZZZZZ para todos)"},;
{"Vendedor Final (ZZZZZZ para todos)"},"","","","","","","")
PutSx1("CFIN01","07","Cliente De"               ,"Cliente De"               ,"Cliente De"                      ,"mv_ch7","C",06,0,0,"G","","SA1","","","mv_par07","","","","","","","","","","","","","","","","",;
{"Cliente Inicial (Branco para todos)"},;
{"Cliente Inicial (Branco para todos)"},;
{"Cliente Inicial (Branco para todos)"},"","","","","","","SA1")
PutSx1("CFIN01","08","Loja De"               ,"Loja De"               ,"Loja De"                               ,"mv_ch8","C",02,0,0,"G","","","","","mv_par08","","","","","","","","","","","","","","","","",;
{"Loja Inicial (ZZ para todos)"},;
{"Loja Inicial (ZZ para todos)"},;
{"Loja Inicial (ZZ para todos)"},"","","","","","","")
PutSx1("CFIN01","09","Cliente Ate"               ,"Cliente Ate"               ,"Cliente Ate"                      ,"mv_ch9","C",06,0,0,"G","","SA1","","","mv_par09","","","","","","","","","","","","","","","","",;
{"Cliente Final (Branco para todos)"},;
{"Cliente Final (Branco para todos)"},;
{"Cliente Final (Branco para todos)"},"","","","","","","SA1")
PutSx1("CFIN01","10","Loja Ate"               ,"Loja Ate"               ,"Loja Ate"                               ,"mv_chA","C",02,0,0,"G","","","","","mv_par10","","","","","","","","","","","","","","","","",;
{"Vendedor Final (ZZ para todos)"},;
{"Vendedor Final (ZZ para todos)"},;
{"Vendedor Final (ZZ para todos)"},"","","","","","","")
PutSx1("CFIN01","11","Local de grava��o da Planilha?"  ,"Local de grava��o da Planilha?"  ,"Local de grava��o da Planilha?" ,"mv_chB","C",80,0,0,"G","","","","","mv_par11","","","","","","","","","","","","","","","","",;
{"Unidade + Diret�rio para grava��o da","planilha gerada pela rotina"},;
{"Unidade + Diret�rio para grava��o da","planilha gerada pela rotina"},;
{"Unidade + Diret�rio para grava��o da","planilha gerada pela rotina"},"","","","","","","")
PutSx1("CFIN01","12","Nome do Arquivo?"          ,"Nome do Arquivo?"          ,"Nome do Arquivo?"           ,"mv_chC","C",08,0,0,"G","","","","","mv_par12","","","","","","","","","","","","","","","","",;
{"Nome da Planilha Excel (sem a extens�o)"},;
{"Nome da Planilha Excel (sem a extens�o)"},;
{"Nome da Planilha Excel (sem a extens�o)"},"","","","","","","")
If !Pergunte("CFIN01",.T.)
	Return
EndIf
_cFiltro := "SELECT DISTINCT E1_VEND1,E1_PREFIXO,E1_EMISSAO,E1_NUM,E1_PARCELA,E1_CLIENTE,E1_LOJA,E1_BAIXA,E1_COMIS1,E1_VALCOM1, "
_cFiltro += "E5_NATUREZ,E1_PORTADO,E1_NOMCLI,E1_PEDIDO,E1_SERIE,E1_VALOR,   "
_cFiltro += "E5_FILIAL,E5_TIPO,E5_PREFIXO,E5_NUMERO, E5_PARCELA, E5_CLIFOR,E5_LOJA, E5_MOTBX, "
_cFiltro += "E5_VALOR,C5_CHVBPAG "
_cFiltro += "FROM " + RetSQLName("SE1") + " SE1, " + RetSQLName("SE5") + " SE5, " + RetSQLName("SC5") + " SC5, " + RetSQLName("SC6") + " SC6 "
_cFiltro += "WHERE E1_EMISSAO between '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "' AND "
_cFiltro += "E1_BAIXA   between '" + DtoS(mv_par03) + "' AND  '" + DtoS(mv_par04) + "' AND "
_cFiltro += "E1_VEND1   >= '" + mv_par05 + "' AND E1_VEND1   <= '" + mv_par06 + "' AND "
_cFiltro += "E1_CLIENTE >= '" + mv_par07 + "' AND E1_CLIENTE <= '" + mv_par09 + "' AND "
_cFiltro += "E1_LOJA    >= '" + mv_par08 + "' AND E1_LOJA    <= '" + mv_par10 + "' AND "
_cFiltro += "E1_TIPO IN ('NF','NDC') AND E1_NATUREZ NOT IN ('FT030001','FT010020') AND "
_cFiltro += "E1_PREFIXO||E1_NUM||E1_PARCELA||E1_CLIENTE||E1_LOJA=E5_PREFIXO||E5_NUMERO||E5_PARCELA||E5_CLIFOR||E5_LOJA "
_cFiltro += "AND E1_NUM||E1_CLIENTE||E1_LOJA=C6_NOTA||C6_CLI||C6_LOJA AND C6_NUM=C5_NUM AND E5_RECPAG ='R' "
_cFiltro += "AND SE1.D_E_L_E_T_=' ' AND SE5.D_E_L_E_T_=' ' AND SC5.D_E_L_E_T_=' ' AND E5_MOTBX = 'NOR'"
_cFiltro += "ORDER BY E5_NUMERO, E5_PARCELA "
_cFiltro := ChangeQuery(_cFiltro)

dbUseArea( .T., "TopConn", TCGenQry(,,_cFiltro), "_MAXITEM", .F., .F. )

cArq := CriaTrab(NIL, .F.)

aStru := {}
AADD(aStru,{ "MARCA"     , "C", 2, 0})
AADD(aStru,{'VENDEDOR'   ,'C', 06, 0})
AADD(aStru,     {'NOMEVEND'  ,'C', 40, 0})
AADD(aStru,     {'PREFIXO'   ,'C', 03, 0})
AADD(aStru,     {'TITULO'    ,'C', 06, 0})
AADD(aStru,     {'PARCELA'   ,'C', 01, 0})
AADD(aStru,     {'TIPO'      ,'C', 03, 0})
AADD(aStru,     {'NATUREZA'  ,'C', 10, 0})
AADD(aStru,     {'PORTADOR'  ,'C', 03, 0})
AADD(aStru,     {'CLIENTE'   ,'C', 06, 0})
AADD(aStru,     {'LOJA'      ,'C', 02, 0})
AADD(aStru,     {'NOME'      ,'C', 20, 0})
AADD(aStru,     {'CNPJ'      ,'C', 14, 0})
AADD(aStru,     {'EMISSAO'   ,'D', 08, 0})
AADD(aStru,     {'BAIXA'     ,'D', 08, 0})
AADD(aStru,     {'VALOR'     ,'C', 12, 2})
AADD(aStru,     {'VALORE1'   ,'C', 12, 2})
AADD(aStru,     {'PERC_COMIS','N', 05, 2})
AADD(aStru,     {'COMISSAO'  ,'N', 12, 2})
AADD(aStru,     {'PRODUTO'   ,'C', 15, 0})
AADD(aStru,     {'DESCRICAO' ,'C', 40, 0})
AADD(aStru,     {'MOTBAX'    ,'C', 03, 0})
AADD(aStru,     {'BPAG'            ,'C', 10, 2})
cArqTrab := CriaTrab(aStru, .T.)

dbUseArea(.T.,, cArqTrab, "TRB", .F., .F.)
     
//dbUSEarea &cArqTrab ALIAS TRB NEW
aCampos := {}
AADD(aCampos,{ "MARCA"   ,,"",})
AADD(aCampos,{'VENDEDOR'  ,,'VENDEDOR',})
AADD(aCampos,{'NOMEVEND'  ,,'NOMEVEND',})
AADD(aCampos,{'PREFIXO'   ,,'PREFIXO',})
AADD(aCampos,{'TITULO'    ,,'TITULO',})
AADD(aCampos,{'PARCELA'   ,,'PARCELA',})
AADD(aCampos,{'TIPO'      ,,'TIPO',})
AADD(aCampos,{'NATUREZA'  ,,'NATUREZA',})
AADD(aCampos,{'PORTADOR'  ,,'PORTADOR',})
AADD(aCampos,{'CLIENTE'   ,,'CLIENTE',})
AADD(aCampos,{'LOJA'      ,,'LOJA',})
AADD(aCampos,{'NOME'      ,,'NOME',})
AADD(aCampos,{'CNPJ'      ,,'CNPJ',})
AADD(aCampos,{'EMISSAO'   ,,'EMISSAO',})
AADD(aCampos,{'BAIXA'     ,,'BAIXA',})
AADD(aCampos,{'VALOR'     ,,'VALOR',})
AADD(aCampos,{'VALORE1'   ,,'VALORE1',})
AADD(aCampos,{'PERC_COMIS',,'PERC_COMIS',})
AADD(aCampos,{'COMISSAO'  ,,'COMISSAO',})
AADD(aCampos,{'PRODUTO'   ,,'PRODUTO',})
AADD(aCampos,{'DESCRICAO' ,,'DESCRICAO',})
AADD(aCampos,{'MOTBAX'    ,,'MOTBAX',})
AADD(aCampos,{'BPAG'             ,,'BPAG',})
dbSelectArea("_MAXITEM")
DbGoTop()
Do While !EoF()
	DbSelectArea('TRB')
	RecLock('TRB',.T.)
	Replace VENDEDOR   With _MAXITEM->E1_VEND1
	Replace NOMEVEND   With Posicione('SA3', 1, xFilial('SA3')+_MAXITEM->E1_VEND1, 'A3_NOME')
	Replace PREFIXO    With _MAXITEM->E5_PREFIXO
	Replace TITULO     With _MAXITEM->E5_NUMERO
	Replace PARCELA    With _MAXITEM->E5_PARCELA
	Replace TIPO       With _MAXITEM->E5_TIPO
	Replace NATUREZA   With _MAXITEM->E5_NATUREZ
	Replace PORTADOR   With _MAXITEM->E1_PORTADO
	Replace CLIENTE    With _MAXITEM->E5_CLIFOR
	Replace LOJA       With _MAXITEM->E5_LOJA
	Replace NOME       With _MAXITEM->E1_NOMCLI
	Replace CNPJ       With Posicione('SA1', 1, xFilial('SA1')+_MAXITEM->E1_CLIENTE+_MAXITEM->E1_LOJA, 'A1_CGC')
	Replace EMISSAO    With STOD(_MAXITEM->E1_EMISSAO)
	Replace BAIXA      With STOD(_MAXITEM->E1_BAIXA)
	Replace VALOR      With TRANSFORM(_MAXITEM->E5_VALOR, "@E 999,999.99")
	Replace VALORE1    With TRANSFORM(_MAXITEM->E1_VALOR, "@E 999,999.99")
	Replace PERC_COMIS With _MAXITEM->E1_COMIS1
	Replace COMISSAO   With _MAXITEM->E1_VALCOM1
	Replace PRODUTO    With SD2->D2_COD
	Replace DESCRICAO  With Posicione('SB1',1, xFilial('SB1')+SD2->D2_COD, 'B1_DESC')
	Replace MOTBAX       With Posicione('SE5',7, xFilial('SE5')+_MAXITEM->E1_PREFIXO+_MAXITEM->E1_NUM, 'E5_MOTBX')
	Replace BPAG                   With Posicione('SC5',1, xFilial('SC5')+_MAXITEM->E1_PEDIDO, 'C5_CHVBPAG')
	MsUnlock()
	dbSelectArea("_MAXITEM")
	dbSkip()
EndDo
dbSelectArea("TRB")
dbGoTop()

cMarca := GetMark()
cCadastro := "Controle de Bonifica��es - Integra��o Excel"

aRotina := {{"Gera Planilha" ,'Processa( {|| U_cfina01Ex()} )',0,2}}
MarkBrowse("TRB","MARCA",,aCampos,,cMarca)
TRB->(DbCloseArea())
_MAXITEM->(DbCloseArea())
RETURN (.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFINA01_NEW�Autor  �Eduardo Ramos      � Data �  05/25/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cria��a     de arquivo .dbf para .dtc                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/



User Function cfina01Ex()

_cArqExcel := AllTrim(mv_par12)+'.dbf'

_aCampos := {  {'VENDEDOR'  ,'C', 06, 0},;
{'NOMEVEND'  ,'C', 40, 0},;
{'PREFIXO'   ,'C', 03, 0},;
{'TITULO'    ,'C', 06, 0},;
{'PARCELA'   ,'C', 01, 0},;
{'TIPO'      ,'C', 03, 0},;
{'NATUREZA'  ,'C', 10, 0},;
{'PORTADOR'  ,'C', 03, 0},;
{'CLIENTE'   ,'C', 06, 0},;
{'LOJA'      ,'C', 02, 0},;
{'NOME'      ,'C', 20, 0},;
{'CNPJ'      ,'C', 14, 0},;
{'EMISSAO'   ,'D', 08, 0},;
{'BAIXA'     ,'D', 08, 0},;
{'VALOR'     ,'C', 12, 2},;
{'VALORE1'   ,'C', 12, 2},;
{'PERC_COMIS','N', 05, 2},;
{'COMISSAO'  ,'N', 12, 2},;
{'PRODUTO'   ,'C', 15, 0},;
{'DESCRICAO' ,'C', 40, 0},;
{'MOTBAX'    ,'C', 03, 0},;
{'BPAG'            ,'C', 10, 2}}

//_cArqExcel := AllTrim(mv_par12)+'.DBF'
DbCreate(_cArqExcel, _aCampos,"DBFCDXADS")

dbUseArea(.T.,"DBFCDXADS", _cArqExcel, "TMPSE1", .F., .F.)

dbSelectArea("_MAXITEM")
DbGoTop()
Do While !EoF()
	IncProc()	
			DbSelectArea('TMPSE1')
			RecLock('TMPSE1',.T.)
			Replace VENDEDOR   With _MAXITEM->E1_VEND1
			Replace NOMEVEND   With Posicione('SA3', 1, xFilial('SA3')+_MAXITEM->E1_VEND1, 'A3_NOME')
			Replace PREFIXO    With _MAXITEM->E5_PREFIXO
			Replace TITULO     With _MAXITEM->E5_NUMERO
			Replace PARCELA    With _MAXITEM->E5_PARCELA
			Replace TIPO       With _MAXITEM->E5_TIPO
			Replace NATUREZA   With _MAXITEM->E5_NATUREZ
			Replace PORTADOR   With _MAXITEM->E1_PORTADO
			Replace CLIENTE    With _MAXITEM->E5_CLIFOR
			Replace LOJA       With _MAXITEM->E5_LOJA
			Replace NOME       With _MAXITEM->E1_NOMCLI
			Replace CNPJ       With Posicione('SA1', 1, xFilial('SA1')+_MAXITEM->E1_CLIENTE+_MAXITEM->E1_LOJA, 'A1_CGC')
			Replace EMISSAO    With STOD(_MAXITEM->E1_EMISSAO)
			Replace BAIXA      With STOD(_MAXITEM->E1_BAIXA)
			Replace VALOR      With TRANSFORM(_MAXITEM->E5_VALOR,"@E 999,999.99")
			Replace VALORE1    With TRANSFORM(_MAXITEM->E1_VALOR,"@E 999,999.99")
			Replace PERC_COMIS With _MAXITEM->E1_COMIS1
		    Replace COMISSAO   With _MAXITEM->E1_VALCOM1
			Replace PRODUTO    With SD2->D2_COD
			Replace DESCRICAO  With Posicione('SB1',1, xFilial('SB1')+SD2->D2_COD, 'B1_DESC')
			Replace MOTBAX     With Posicione('SE5',7, xFilial('SE5')+_MAXITEM->E1_PREFIXO+_MAXITEM->E1_NUM, 'E5_MOTBX')
			Replace BPAG       With Posicione('SC5',1, xFilial('SC5')+_MAXITEM->E1_PEDIDO, 'C5_CHVBPAG')
			MsUnlock()

			DbSelectArea('SD2')
			DbSkip()
	dbSelectArea("_MAXITEM")
	dbSkip()
EndDo
_cRooth := GetPvProfString( GetEnvServer(), "StartPath", "", GetADV97() )
_cDir   := AllTrim(mv_par11)
TMPSE1->(DbCloseArea())
If Right(_cDir,1) <> '\'
	_cDir += '\'
EndIf
//_cArqExcel := StrTran(CriaTrab(,.F.), '.DBF')+ '.XLS
//// Copy To _cArqExcel // --> faz virar excel
CpyS2T(_cRooth+_cArqExcel, _cDir, .T. )
MsgInfo("GERADO !!!")

//If mv_par09 == 1    
//   DbSelectArea('TMPQ')  
//   _cArqTmp := StrTran(CriaTrab(,.F.), '.DBF')+ '.XLS'
//   Copy To &_cArqTmp
//   CpyS2T( GetPvProfString( GetEnvServer(), "StartPath", "", GetADV97() )+_cArqTmp , mv_par10, .T. )
//   MsgInfo('Favor verificar arquivo '+AllTrim(mv_par10)+_cArqTmp,'Planilha Excel')
//   FErase(_cArqTmp)
//EndIf




Return (.T.)
