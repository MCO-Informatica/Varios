#INCLUDE "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CFINA02  �Autor  � Raphael Nascimento � Data �  28/01/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera��o de Dados Excel - SE1 / Dados para Controle do      ���
���          � Financeiro                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP7 - Espec�fico CertiSign                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION CFINA02()



PutSx1("CFIN02","01","Emiss�o De"               ,"Emiss�o De"               ,"Emiss�o De"                       ,"mv_ch1","D",08,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",;
      {"Emiss�o Inicial (Branco para todos)"},;
      {"Emiss�o Inicial (Branco para todos)"},;
      {"Emiss�o Inicial (Branco para todos)"},"","","","","","","")
PutSx1("CFIN02","02","Emiss�o Ate"              ,"Emiss�o Ate"              ,"Emiss�o Ate"                      ,"mv_ch2","D",08,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",;
      {"Emiss�o Final (ZZZZZZZZZZ para todos)"},;
      {"Emiss�o Final (ZZZZZZZZZZ para todos)"},;
      {"Emiss�o Final (ZZZZZZZZZZ para todos)"},"","","","","","","")
/*PutSx1("CFIN02","03","Recebimento De"               ,"Recebimento De"               ,"Recebimento De"           ,"mv_ch3","D",08,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",;
      {"Recebimento Inicial (Branco para todos)"},;
      {"Recebimento Inicial (Branco para todos)"},;
      {"Recebimento Inicial (Branco para todos)"},"","","","","","","")
PutSx1("CFIN02","04","Recebimento Ate"               ,"Recebimento Ate"               ,"Recebimento Ate"        ,"mv_ch4","D",08,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","",;
      {"Recebimento Final (ZZZZ para todos)"},;
      {"Recebimento Final (ZZZZ para todos)"},;
      {"Recebimento Final (ZZZZ para todos)"},"","","","","","","")
*/
PutSx1("CFIN02","03","Vencimento De"		          ,"Vencimento De"     		     ,"Vencimento De"   ,"mv_ch3","D",08,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",;
      {"Vencimento Inicial (Branco para todos)"},;
      {"Vencimento Inicial (Branco para todos)"},;
      {"Vencimento Inicial (Branco para todos)"},"","","","","","","")
PutSx1("CFIN02","04","Vencimento Ate"          		 ,"Vencimento Ate"      	     ,"Vencimento Ate"   ,"mv_ch4","D",08,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","",;
      {"Vencimento Final (ZZZZ para todos)"},;
      {"Vencimento Final (ZZZZ para todos)"},;
      {"Vencimento Final (ZZZZ para todos)"},"","","","","","","")
PutSx1("CFIN02","05","Prefixos a Considerar"           ,"Prefixos a Considerar"        ,"Prefixos a Considerar"   ,"mv_ch5","C",40,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","",;
      {"Prefixos a filtrar - Separar com /(Branco para todos)"},;
      {"Prefixos a filtrar - Separar com / (Branco para todos)"},;
      {"Prefixos a filtrar - Separar com / (Branco para todos)"},"","","","","","","")
PutSx1("CFIN02","06","Prefixos a Desconsiderar"        ,"Prefixos a Desconsiderar"     ,"Prefixos a Desconsiderar"  ,"mv_ch6","C",40,0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","",;
      {"Prefixos a desconsiderar - Separar com / (A ignorar)"},;
      {"Prefixos a desconsiderar - Separar com / (A ignorar)"},;
      {"Prefixos a desconsiderar - Separar com / (A ignorar)"},"","","","","","","")
PutSx1("CFIN02","07","Naturezas a Considerar"           ,"Naturezas a Considerar"        ,"Naturezas a Considerar"   ,"mv_ch7","C",60,0,0,"G","","","","","mv_par07","","","","","","","","","","","","","","","","",;
      {"Naturezas a filtrar - Separar com /(Branco para todos)"},;
      {"Naturezas a filtrar - Separar com / (Branco para todos)"},;
      {"Naturezas a filtrar - Separar com / (Branco para todos)"},"","","","","","","")
PutSx1("CFIN02","08","Naturezas a Desconsiderar"        ,"Naturezas a Desconsiderar"     ,"Naturezas a Desconsiderar"  ,"mv_ch8","C",60,0,0,"G","","","","","mv_par08","","","","","","","","","","","","","","","","",;
      {"Naturezas a desconsiderar - Separar com / (A ignorar)"},;
      {"Naturezas a desconsiderar - Separar com / (A ignorar)"},;
      {"Naturezas a desconsiderar - Separar com / (A ignorar)"},"","","","","","","")
PutSx1("CFIN02","09","Vendedor De"               ,"Vendedor De"               ,"Vendedor De"                    ,"mv_ch9","C",06,0,0,"G","","SA3","","","mv_par09","","","","","","","","","","","","","","","","",;
      {"Vendedor Inicial (Branco para todos)"},;
      {"Vendedor Inicial (Branco para todos)"},;
      {"Vendedor Inicial (Branco para todos)"},"","","","","","","")
PutSx1("CFIN02","10","Vendedor Ate"               ,"Vendedor Ate"               ,"Vendedor Ate"                 ,"mv_chA","C",06,0,0,"G","","SA3","","","mv_par10","","","","","","","","","","","","","","","","",;
      {"Vendedor Final (ZZZZZZ para todos)"},;
      {"Vendedor Final (ZZZZZZ para todos)"},;
      {"Vendedor Final (ZZZZZZ para todos)"},"","","","","","","")
PutSx1("CFIN02","11","Cliente De"               ,"Cliente De"               ,"Cliente De"                      ,"mv_chB","C",06,0,0,"G","","SA1","","","mv_par11","","","","","","","","","","","","","","","","",;
      {"Cliente Inicial (Branco para todos)"},;
      {"Cliente Inicial (Branco para todos)"},;
      {"Cliente Inicial (Branco para todos)"},"","","","","","","SA1")
PutSx1("CFIN02","12","Loja De"               ,"Loja De"               ,"Loja De"                               ,"mv_chC","C",02,0,0,"G","","","","","mv_par12","","","","","","","","","","","","","","","","",;
      {"Loja Inicial (ZZ para todos)"},;
      {"Loja Inicial (ZZ para todos)"},;
      {"Loja Inicial (ZZ para todos)"},"","","","","","","")
PutSx1("CFIN02","13","Cliente Ate"               ,"Cliente Ate"               ,"Cliente Ate"                      ,"mv_chD","C",06,0,0,"G","","SA1","","","mv_par13","","","","","","","","","","","","","","","","",;
      {"Cliente Final (Branco para todos)"},;
      {"Cliente Final (Branco para todos)"},;
      {"Cliente Final (Branco para todos)"},"","","","","","","SA1")
PutSx1("CFIN02","14","Loja Ate"               ,"Loja Ate"               ,"Loja Ate"                               ,"mv_chE","C",02,0,0,"G","","","","","mv_par14","","","","","","","","","","","","","","","","",;
      {"Vendedor Final (ZZ para todos)"},;
      {"Vendedor Final (ZZ para todos)"},;
      {"Vendedor Final (ZZ para todos)"},"","","","","","","")
PutSx1("CFIN02","15","Local de grava��o da Planilha?"  ,"Local de grava��o da Planilha?"  ,"Local de grava��o da Planilha?" ,"mv_chF","C",80,0,0,"G","","","","","mv_par15","","","","","","","","","","","","","","","","",;
      {"Unidade + Diret�rio para grava��o da","planilha gerada pela rotina"},;
      {"Unidade + Diret�rio para grava��o da","planilha gerada pela rotina"},;
      {"Unidade + Diret�rio para grava��o da","planilha gerada pela rotina"},"","","","","","","")
PutSx1("CFIN02","16","Nome do Arquivo?"          ,"Nome do Arquivo?"          ,"Nome do Arquivo?"           ,"mv_chG","C",08,0,0,"G","","","","","mv_par16","","","","","","","","","","","","","","","","",;
      {"Nome da Planilha Excel (sem a extens�o)"},;
      {"Nome da Planilha Excel (sem a extens�o)"},;
      {"Nome da Planilha Excel (sem a extens�o)"},"","","","","","","")
PutSx1("CFIN02","17","Tipo NF/NDC?"          ,"Tipo NF/NDC?"          ,"Tipo NF/NDC?"           ,"mv_chH","C",08,0,0,"G","","","","","mv_par17","","","","","","","","","","","","","","","","",;
      {"Tipo NF/NDC"},;
      {"Tipo NF/NDC"},;
      {"Tipo NF/NDC"},"","","","","","","")


If !Pergunte("CFIN02",.T.) 
   Return
EndIf               
       
_cFiltro := " SELECT DISTINCT SubStr(E1_EMISSAO,7,2)||'/'||SubStr(E1_EMISSAO,5,2)||'/'||SubStr(E1_EMISSAO,1,4) AS E1_EMISSAO, "
_cFiltro += " E1_SERIE, "
_cFiltro += " E1_NUM, "
_cFiltro += " E1_PREFIXO, "
_cFiltro += " SubStr(E1_VENCREA,7,2)||'/'||SubStr(E1_VENCREA,5,2)||'/'||SubStr(E1_VENCREA,1,4) AS E1_VENCREA, "
_cFiltro += " E1_PARCELA, "
_cFiltro += " E1_CLIENTE, "
_cFiltro += " E1_LOJA, "
_cFiltro += " E1_VEND1, "
_cFiltro += " E1_VEND2, "
_cFiltro += " SubStr(E1_BAIXA,7,2)||'/'||SubStr(E1_BAIXA,5,2)||'/'||SubStr(E1_BAIXA,1,4) AS E1_BAIXA, "
_cFiltro += " E1_TIPO, "
_cFiltro += " E1_NATUREZ, "
_cFiltro += " E1_NOMCLI, "
_cFiltro += " E1_PEDIDO, "
_cFiltro += " E1_VALOR "
_cFiltro += " FROM " + RetSQLName("SE1") + " SE1 " 
_cFiltro += " WHERE E1_EMISSAO between '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "' AND "
_cFiltro += " E1_VENCREA   >= '" + DtoS(mv_par03) + "' AND E1_VENCREA   <= '" + DtoS(mv_par04) + "' "  

If !Empty(mv_par05)
_cTro7 := ''
_cPar7 := mv_par05
		_cTro7 := At(',',_cPar7) 
		If _cTro7 <> 0 
		   _cPar7 := Stuff(_cPar7,_cTro7,1,"','")
		EndiF
_cFiltro += " AND E1_PREFIXO IN ('"+(_cPar7)+"')" 
Endif

If !Empty(mv_par06)
_cTro8 := ''
_cPar8 := mv_par06
		_cTro8 := At(',',_cPar8) 
		If _cTro8 <> 0 
		   _cPar8 := Stuff(_cPar8,_cTro8,1,"','")
		EndiF
_cFiltro += " AND E1_PREFIXO NOT IN ('"+(_cPar8)+"')" 
Endif                            

If !Empty(mv_par07)
_cTro2 := ''
_cPar2 := mv_par07
		_cTro2 := At(',',_cPar2) 
		If _cTro2 <> 0 
		   _cPar2 := Stuff(_cPar2,_cTro2,1,"','")
		EndiF
_cFiltro += " AND E1_NATUREZ IN ('"+(_cPar2)+"')"
Endif

If !Empty(mv_par08)
_cTro3 := ''
_cPar3 := mv_par08
		_cTro3 := At(',',_cPar3) 
		If _cTro3 <> 0 
		   _cPar3 := Stuff(_cPar3,_cTro3,1,"','")
		EndiF
_cFiltro += " AND E1_NATUREZ NOT IN ('"+(_cPar3)+"')"
Endif		                          

_cFiltro += " AND E1_VEND1   >= '" + mv_par09 + "' AND E1_VEND1   <= '" + mv_par10 + "' AND "
_cFiltro += " E1_CLIENTE >= '" + mv_par11 + "' AND E1_CLIENTE <= '" + mv_par13 + "' AND " 
_cFiltro += " E1_LOJA    >= '" + mv_par12 + "' AND E1_LOJA <= '" + mv_par14 + "' "

If !Empty(mv_par17)
_cTro0 := ''
_cPar0 := mv_par17
		_cTro0 := At(',',_cPar0) 
		If _cTro0 <> 0 
		   _cPar0 := Stuff(_cPar0,_cTro0,1,"','")
		EndiF
_cFiltro += " AND E1_TIPO IN ('"+(_cPar0)+"')"
EndIf
_cFiltro += " AND SE1.D_E_L_E_T_= ' '
_cFiltro += " ORDER BY E1_EMISSAO, E1_NUM, E1_SERIE, E1_PARCELA "
_cFiltro := ChangeQuery(_cFiltro)
dbUseArea( .T., "TopConn", TCGenQry(,,_cFiltro), "MAXITEM", .F., .F. )      

cArq := CriaTrab(NIL, .F.)
aStru := {}  
AADD(aStru,{"MARCA"     ,"C", 02, 0})
AADD(aStru,{'EMISSAO'   ,'C', 10, 0}) //,'D', 08, 0})
AADD(aStru,{'SERIE'     ,'C', 03, 0})
AADD(aStru,{'TITULO'    ,'C', 06, 0})
AADD(aStru,{'PREFIXO'   ,'C', 03, 0})
AADD(aStru,{'VENREAL'   ,'C', 10, 0}) //,'D', 08, 0})
AADD(aStru,{'PARCELA'   ,'C', 01, 0})
AADD(aStru,{'CLIENTE'   ,'C', 06, 0})
AADD(aStru,{'LOJA'      ,'C', 02, 0})
AADD(aStru,{'NOME'      ,'C', 40, 0})
AADD(aStru,{'VENDEDOR'  ,'C', 06, 0})
AADD(aStru,{'NOMEVEND'  ,'C', 40, 0})
AADD(aStru,{'VEND2'     ,'C', 06, 0})
AADD(aStru,{'NOMEVEN2'  ,'C', 40, 0})
AADD(aStru,{'BAIXA'     ,'C', 10, 0}) //,'D', 08, 0})
AADD(aStru,{'NATUREZA'  ,'C', 10, 0})
AADD(aStru,{'PEDIDO'    ,'C', 06, 0})
AADD(aStru,{'VALOR'     ,'C', 12, 2})
AADD(aStru,{'VALORE1'   ,'C', 12, 2})
AADD(aStru,{'TIPO'      ,'C', 03, 0})
AADD(aStru, {'MOTBAX'   ,'C', 03, 0})
cArqTrab := CriaTrab(aStru, .T.)
USE &cArqTrab ALIAS TRB NEW          

aCampos := {}                       
AADD(aCampos,{ "MARCA"    ,,"",})
AADD(aCampos,{'EMISSAO'   ,,'EMISSAO',})
AADD(aCampos,{'SERIE'     ,,'SERIE',})
AADD(aCampos,{'TITULO'    ,,'TITULO',})
AADD(aCampos,{'PREFIXO'   ,,'PREFIXO',})
AADD(aCampos,{'VENREAL'   ,,'VENREAL',})
AADD(aCampos,{'PARCELA'   ,,'PARCELA',})
AADD(aCampos,{'CLIENTE'   ,,'CLIENTE',})
AADD(aCampos,{'LOJA'	  ,,'LOJA',})
AADD(aCampos,{'NOME'	  ,,'NOME',})
AADD(aCampos,{'VENDEDOR'  ,,'VENDEDOR',})
AADD(aCampos,{'NOMEVEND'  ,,'NOMEVEND',})
AADD(aCampos,{'VEND2'     ,,'VEND2',})
AADD(aCampos,{'NOMEVEN2'  ,,'NOMEVEN2',})
AADD(aCampos,{'BAIXA'     ,,'BAIXA',})
AADD(aCampos,{'NATUREZA'  ,,'NATUREZA',})
AADD(aCampos,{'PEDIDO'    ,,'PEDIDO',})
AADD(aCampos,{'VALOR'     ,,'VALOR',})
AADD(aCampos,{'VALORE1'   ,,'VALORE1',})
AADD(aCampos,{'TIPO'	  ,,'TIPO',})
AADD(aCampos,{'MOTBAX'    ,,'MOTBAX',})

dbSelectArea("MAXITEM")
DbGoTop()
Do While !EoF()   
	DbSelectArea('TRB')
	RecLock('TRB',.T.)
      Replace EMISSAO    With MAXITEM->E1_EMISSAO //STOD(MAXITEM->E1_EMISSAO)
	  Replace SERIE	     With MAXITEM->E1_SERIE    
      Replace TITULO     With MAXITEM->E1_NUM
      Replace PREFIXO    With MAXITEM->E1_PREFIXO
      Replace VENREAL    With MAXITEM->E1_VENCREA //STOD(MAXITEM->E1_VENCREA)
      Replace PARCELA    With MAXITEM->E1_PARCELA
      Replace CLIENTE    With MAXITEM->E1_CLIENTE
      Replace LOJA		 With MAXITEM->E1_LOJA
	  Replace NOME	     With Posicione('SA1', 1, xFilial('SA1')+MAXITEM->E1_CLIENTE+MAXITEM->E1_LOJA, 'A1_NOME')
      Replace VENDEDOR   With MAXITEM->E1_VEND1      
      Replace NOMEVEND   With Posicione('SA3', 1, xFilial('SA3')+MAXITEM->E1_VEND1, 'A3_NOME')
      Replace VEND2      With MAXITEM->E1_VEND2      
      Replace NOMEVEN2   With Posicione('SA3', 1, xFilial('SA3')+MAXITEM->E1_VEND2, 'A3_NOME')
      Replace BAIXA      With MAXITEM->E1_BAIXA //STOD(MAXITEM->E1_BAIXA)
      Replace TIPO       With MAXITEM->E1_TIPO
      Replace NATUREZA   With MAXITEM->E1_NATUREZ
      Replace MOTBAX	 With Posicione('SE5',14, xFilial('SE5')+MAXITEM->E1_PREFIXO+MAXITEM->E1_NUM+MAXITEM->E1_PARCELA+'R', 'E5_MOTBX')
      //Replace VALOR      With TRANSFORM(Posicione('SE5',14, xFilial('SE5')+MAXITEM->E1_PREFIXO+MAXITEM->E1_NUM+MAXITEM->E1_PARCELA+'R', 'E5_VALOR'), "@E 999,999.99")
      Replace VALOR      With TRANSFORM(Posicione('SE5',14, xFilial('SE5')+MAXITEM->E1_PREFIXO+MAXITEM->E1_NUM+MAXITEM->E1_PARCELA+'R', 'E5_VALOR'), "@E 999,999.99")
      Replace VALORE1    With TRANSFORM(MAXITEM->E1_VALOR, "@E 999,999.99")
      
      MsUnlock()   
	dbSelectArea("MAXITEM")
    dbSkip()
EndDo

dbSelectArea("TRB")   
dbGoTop()

cMarca := GetMark()
cCadastro := "Controle de Bonifica��es - Integra��o Excel"

aRotina := {{"Gera Planilha" ,'Processa( {|| U_CFINA02Ex()} )',0,2}}
MarkBrowse("TRB","MARCA",,aCampos,,cMarca)      
TRB->(DbCloseArea())
MAXITEM->(DbCloseArea())

Return (.T.)

User Function CFINA02Ex()

_aCampos := {	{'EMISSAO'   ,'C', 10, 0},;  //,'D', 08, 0},;
				{'SERIE'     ,'C', 03, 0},;
 				{'TITULO'    ,'C', 06, 0},;
				{'PREFIXO'   ,'C', 03, 0},;
				{'VENREAL'   ,'C', 10, 0},; //,'D', 08, 0},;
				{'PARCELA'   ,'C', 01, 0},;
				{'CLIENTE'   ,'C', 06, 0},;
				{'LOJA'      ,'C', 02, 0},;
				{'NOME'      ,'C', 40, 0},;
				{'VENDEDOR'  ,'C', 06, 0},;
				{'NOMEVEND'  ,'C', 40, 0},;
				{'VEND2'     ,'C', 06, 0},;
				{'NOMEVEN2'  ,'C', 40, 0},;
				{'BAIXA'     ,'C', 10, 0},;  //,'D', 08, 0},;
				{'NATUREZA'  ,'C', 10, 0},;
				{'PEDIDO'    ,'C', 06, 0},;
				{'VALOR'     ,'C', 12, 2},;
				{'VALORE1'   ,'C', 12, 2},;
				{'TIPO'      ,'C', 03, 0},;
				{'MOTBAX'    ,'C', 03, 0}} 
				
_cArqExcel := AllTrim(mv_par16)+'.XLS' 

DbCreate(_cArqExcel, _aCampos,"DBFCDXADS")

dbUseArea(.T.,"DBFCDXADS", _cArqExcel, "TMPSE1", .F., .F.)

/*
DbCreate(_cArqExcel, _aCampos)
dbUseArea(.T.,"DBFCDX", _cArqExcel, "TMPSE1", .F., .F.)

*/

dbSelectArea("MAXITEM")
DbGoTop()
Do While !EoF()
	 IncProc()                 
      DbSelectArea('TMPSE1')
      RecLock('TMPSE1',.T.)
      Replace EMISSAO    With MAXITEM->E1_EMISSAO //STOD(MAXITEM->E1_EMISSAO)
	  Replace SERIE	     With MAXITEM->E1_SERIE    
      Replace TITULO     With MAXITEM->E1_NUM
      Replace PREFIXO    With MAXITEM->E1_PREFIXO
      Replace VENREAL    With MAXITEM->E1_VENCREA //STOD(MAXITEM->E1_VENCREA)
      Replace PARCELA    With MAXITEM->E1_PARCELA
      Replace CLIENTE    With MAXITEM->E1_CLIENTE
      Replace LOJA		 With MAXITEM->E1_LOJA
	  Replace NOME	     With Posicione('SA1', 1, xFilial('SA1')+MAXITEM->E1_CLIENTE+MAXITEM->E1_LOJA, 'A1_NOME')
      Replace VENDEDOR   With MAXITEM->E1_VEND1      
      Replace NOMEVEND   With Posicione('SA3', 1, xFilial('SA3')+MAXITEM->E1_VEND1, 'A3_NOME')
      Replace VEND2      With MAXITEM->E1_VEND2      
      Replace NOMEVEN2   With Posicione('SA3', 1, xFilial('SA3')+MAXITEM->E1_VEND2, 'A3_NOME')
      Replace BAIXA      With MAXITEM->E1_BAIXA //STOD(MAXITEM->E1_BAIXA)
      Replace TIPO       With MAXITEM->E1_TIPO
      Replace NATUREZA   With MAXITEM->E1_NATUREZ
      Replace MOTBAX	 With Posicione('SE5',14, xFilial('SE5')+MAXITEM->E1_PREFIXO+MAXITEM->E1_NUM+MAXITEM->E1_PARCELA+'R', 'E5_MOTBX')
      Replace VALOR      With TRANSFORM(Posicione('SE5',14, xFilial('SE5')+MAXITEM->E1_PREFIXO+MAXITEM->E1_NUM+MAXITEM->E1_PARCELA+'R', 'E5_VALOR'), "@E 999,999.99")
      Replace VALORE1    With TRANSFORM(MAXITEM->E1_VALOR, "@E 999,999.99")
      MsUnlock()      
	dbSelectArea("MAXITEM")
    dbSkip()
EndDo

_cRooth := GetPvProfString( GetEnvServer(), "StartPath", "", GetADV97() )
_cDir   := AllTrim(mv_par15)
TMPSE1->(DbCloseArea())


If Right(_cDir,1) <> '\'
   _cDir += '\'
EndIf
CpyS2T(_cRooth+_cArqExcel, _cDir, .T. )

//Finaliza o processo
//Break                
MsgInfo("GERADO !!!")

Return (.T.)