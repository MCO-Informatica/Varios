#include "report.ch"    
#INCLUDE "PROTHEUS.CH"

#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF
#DEFINE CHRCOMP If(aReturn[4]==1,15,18)

User Function CTSR020()

//������������������������������������������������������������������������Ŀ
//�Define Variaveis                                                        �
//��������������������������������������������������������������������������
Local Titulo  := "Impress�o de Titulos em Aberto"
Local cDesc1  := "Este Programa ir� imprimir os Titulos em aberto" 
Local cDesc2  := "Considerando os parametros Informados" 
Local cDesc3  := "" //""  // Descricao 3
Local cString := "SE1"  // Alias utilizado na Filtragem
Local lDic    := .F. 	// Habilita/Desabilita Dicionario
Local lComp   := .T. 	// Habilita/Desabilita o Formato Comprimido/Expandido
Local lFiltro := .T. 	// Habilita/Desabilita o Filtro
Local wnrel   := "CTSR020"  	// Nome do Arquivo utilizado no Spool
Local nomeprog:= "CTSR020"  	// nome do programa

Private Tamanho := "M" // P/M/G
Private Limite  := 132 // 80/132/220
Private aOrdem  := {}  // Ordem do Relatorio
Private cPerg   := "CTSR020   "  // Pergunta do Relatorio
Private aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 } //"Zebrado"###"Administracao"
						//[1] Reservado para Formulario
						//[2] Reservado para N� de Vias
						//[3] Destinatario
						//[4] Formato => 1-Comprimido 2-Normal
						//[5] Midia   => 1-Disco 2-Impressora
						//[6] Porta ou Arquivo 1-LPT1... 4-COM1...
						//[7] Expressao do Filtro
						//[8] Ordem a ser selecionada
						//[9]..[10]..[n] Campos a Processar (se houver)

Private lEnd    := .F.// Controle de cancelamento do relatorio
Private m_pag   := 1  // Contador de Paginas
Private nLastKey:= 0  // Controla o cancelamento da SetPrint e SetDefault

CriaSx1(cPerg)

Pergunte(cPerg,.F.)
//������������������������������������������������������������������������Ŀ
//�Envia para a SetPrinter                                                 �
//��������������������������������������������������������������������������
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,lDic,aOrdem,lComp,Tamanho,lFiltro)

If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	Set Filter to
	Return
Endif

Processa({|lEnd| ImpDet(@lEnd,wnRel,cString,nomeprog,Titulo)},Titulo)

Return(.T.)


Static Function ImpDet(lEnd,wnrel,cString,nomeprog,Titulo)

Local aLay	    := RetLayOut()

Local li        := 100 // Contador de Linhas
Local nFolha    := 01
Local nMemCount := 0 
Local nLoop     := 0 

Local cLinha    := ""
Local cbCont    := 0   // Numero de Registros Processados
Local cMemo     := ""
Local cSql		:= ""
Local cSqlA		:= ""
Local _nRecs		:= 0

If MV_PAR04 == 1
	//TITULO DE CLIENTES EM ABERTO	
	cSql += "SELECT  "+CRLF 
	cSql += "	'01-TITULOS' TIPO,  "+CRLF 
	cSql += "	'CLIENTE' DESCRICAO,  "+CRLF 
	cSql += "	'' NUM_CART,  "+CRLF 	
	cSql += "	'' COD_AUT_CARTAO,  "+CRLF 
	cSql += "	'' ID_VENDA_CARTAO,  "+CRLF 
	cSql += "	E1_CLIENTE CLIENTE_TIT, "+CRLF
	cSql += "	E1_LOJA LOJA_CLIENTE_TIT, "+CRLF
	cSql += "	E1_PREFIXO PREFIXO_TIT,  "+CRLF 
	cSql += "	E1_NUM NUMERO_TIT,  "+CRLF 
	cSql += "	E1_PARCELA PARCELA_TIT, "+CRLF 
	cSql += "	E1_TIPO TIPO_TIT, "+CRLF 
	cSql += "	E1_PEDGAR NUM_PEDGAR, "+CRLF 
	cSql += "	E1_EMISSAO DT_EMISSAO, "+CRLF 
	cSql += "	E1_VENCREA DT_VENCIMENTO, "+CRLF 
	cSql += "	E1_SALDO VLR_ABERTO "+CRLF 
	cSql += "FROM  "+CRLF 
	cSql += "	"+RetSqlname("SC5")+" C5 INNER JOIN "+RetSqlname("SC6")+" C6 ON "+CRLF 
	cSql += "	C5_FILIAL = C6_FILIAL AND "+CRLF 
	cSql += "	C5_NUM = C6_NUM INNER JOIN "+RetSqlname("SE1")+" E1 ON "+CRLF 
	cSql += "	C5_CLIENTE = E1_CLIENTE AND "+CRLF 
	cSql += "	C5_LOJACLI = E1_LOJA AND "+CRLF 
	cSql += "	C6_NOTA = E1_NUM AND "+CRLF 
	cSql += "	'SP'||substr(C6_SERIE,1,1) = E1_PREFIXO "+CRLF 
	cSql += "WHERE "+CRLF 
	cSql += "	C5_FILIAL		= '"+xFilial("SC5")+"' AND "+CRLF 
	cSql += "	C5_XCARTAO		= '' AND "+CRLF 
	cSql += "	C5.D_E_L_E_T_	= ' ' AND "+CRLF 
	cSql += "	C6.D_E_L_E_T_	= ' ' AND "+CRLF 
	cSql += "	E1_FILIAL		= '"+xFilial("SE1")+"' AND "+CRLF 
	cSql += "	upper(E1_ORIGEM) IN ('MATA460') AND "+CRLF 
	cSql += "	E1_SALDO		> 0 AND "+CRLF 
	cSql += "	E1_TIPO NOT IN( 'RA ','NCC', 'PI-', 'CF-','CS-','IR-') AND "+CRLF 
	cSql += "	E1.D_E_L_E_T_	= ' ' "+CRLF 
	cSql += "UNION ALL "+CRLF 
	cSql += "SELECT "+CRLF 
	cSql += "	'01-TITULOS' TIPO,  "+CRLF  
	cSql += "	'CLIENTE' DESCRICAO, "+CRLF 
	cSql += "	'' NUM_CART, "+CRLF 	
	cSql += "	'' COD_AUT_CARTAO, "+CRLF 
	cSql += "	'' ID_VENDA_CARTAO, "+CRLF 
	cSql += "	E1_CLIENTE CLIENTE_TIT, "+CRLF
	cSql += "	E1_LOJA LOJA_CLIENTE_TIT, "+CRLF
	cSql += "	E1_PREFIXO PREFIXO_TIT, "+CRLF 
	cSql += "	E1_NUM NUMERO_TIT, "+CRLF 
	cSql += "	E1_PARCELA PARCELA_TIT, "+CRLF 
	cSql += "	E1_TIPO TIPO_TIT, "+CRLF 
	cSql += "	E1_PEDGAR NUM_PEDGAR, "+CRLF 
	cSql += "	E1_EMISSAO DT_EMISSAO, "+CRLF 
	cSql += "	E1_VENCREA DT_VENCIMENTO, "+CRLF 
	cSql += "	E1_SALDO VLR_ABERTO "+CRLF 
	cSql += "FROM "+CRLF  
	cSql += "	"+RetSqlName("SE1")+" E1  "+CRLF  
	cSql += "WHERE "+CRLF  
	cSql += "	E1_FILIAL		= '"+xFilial("SE1")+"' AND "+CRLF  
	cSql += "	E1_SALDO		> 0 AND "+CRLF  
	cSql += "	E1_TIPO NOT IN( 'RA ','NCC', 'PI-', 'CF-','CS-','IR-') AND "+CRLF  
	cSql += "	upper(E1_ORIGEM) NOT IN ('MATA460') AND "+CRLF  
	cSql += "	E1.D_E_L_E_T_	= ' ' "+CRLF  
	If MV_PAR03 == 1 .or. MV_PAR05 == 1 .or. MV_PAR06 == 1
		cSql += "UNION "+CRLF 	
	EndIf	
EndIf
If MV_PAR03 == 1 
	cSql += "SELECT "+CRLF 
	cSql += "	'02-CARTAO DE CREDITO' TIPO, "+CRLF
	cSql += "	C5_XBANDEI DESCRICAO, "+CRLF
	cSql += "	CASE SUBSTR(C5_XBANDEI,1,3) "+CRLF
	cSql += "		WHEN 'AME' THEN SUBSTR(C5_XCARTAO, -15) "+CRLF
	cSql += "		ELSE SUBSTR(C5_XCARTAO, -8)+'****'+SUBSTR(C5_XCARTAO, 1, 4) "+CRLF
	cSql += "	END NUM_CART, "+CRLF	
	cSql += "	C5_XCODAUT COD_AUT_CARTAO, "+CRLF
	cSql += "	SUBSTR(C5_XTIDCC,1,20) ID_VENDA_CARTAO, "+CRLF
	cSql += "	E1_CLIENTE CLIENTE_TIT, "+CRLF
	cSql += "	E1_LOJA LOJA_CLIENTE_TIT, "+CRLF
	cSql += "	E1_PREFIXO PREFIXO_TIT, "+CRLF
	cSql += "	E1_NUM NUMERO_TIT, "+CRLF
	cSql += "	E1_PARCELA PARCELA_TIT, "+CRLF
	cSql += "	E1_TIPO TIPO_TIT, "+CRLF
	cSql += "	E1_PEDGAR NUM_PEDGAR, "+CRLF
	cSql += "	E1_EMISSAO DT_EMISSAO, "+CRLF
	cSql += "	E1_VENCREA DT_VENCIMENTO, "+CRLF 
	cSql += "	E1_SALDO VLR_ABERTO "+CRLF
	cSql += "FROM "+CRLF 
	cSql += "	"+RetSqlName("SC5")+" C5 INNER JOIN "+RetSqlName("SC6")+" C6 ON "+CRLF 
	cSql += "	C5_FILIAL = C6_FILIAL AND "+CRLF 
	cSql += "	C5_NUM = C6_NUM INNER JOIN "+RetSqlName("SE1")+" E1 ON "+CRLF 
	cSql += "	C6_NOTA = E1_NUM AND "+CRLF 
	cSql += "	'SP'||substr(C6_SERIE,1,1) = E1_PREFIXO "+CRLF 
	cSql += "WHERE "+CRLF 
	cSql += "	C5_FILIAL		= '"+xFilial("SC5")+"' AND "+CRLF 
	cSql += "	C5_XCARTAO		<> '' AND "+CRLF 
	cSql += "	C5.D_E_L_E_T_	= ' ' AND "+CRLF 
	cSql += "	C6.D_E_L_E_T_	= ' ' AND "+CRLF 
	cSql += "	E1_FILIAL		= '"+xFilial("SE1")+"' AND "+CRLF 
	cSql += "	E1_SALDO		> 0 AND "+CRLF 
	cSql += "	E1_TIPO NOT IN( 'RA ','NCC', 'PI-', 'CF-','CS-','IR-') AND  "+CRLF 
	cSql += "	E1.D_E_L_E_T_	= ' ' "+CRLF 
	cSql += "GROUP BY "+CRLF 
	cSql += "	C5_XBANDEI, "+CRLF 
	cSql += "	C5_XCARTAO, "+CRLF 
	cSql += "	C5_XCODAUT, "+CRLF 
	cSql += "	C5_XTIDCC, "+CRLF 
	cSql += "	E1_CLIENTE, "+CRLF
	cSql += "	E1_LOJA, "+CRLF
	cSql += "	E1_PREFIXO, "+CRLF 
	cSql += "	E1_NUM, "+CRLF 
	cSql += "	E1_PARCELA, "+CRLF 
	cSql += "	E1_TIPO, "+CRLF 
	cSql += "	E1_PEDGAR, "+CRLF 
	cSql += "	E1_EMISSAO, "+CRLF 
	cSql += "	E1_VENCREA, "+CRLF 
	cSql += "	E1_SALDO "+CRLF 
   //	If MV_PAR04 == 1 .or. MV_PAR05 == 1 .or. MV_PAR06 == 1
   	If MV_PAR05 == 1 .or. MV_PAR06 == 1
		cSql += "UNION "+CRLF 	
	EndIf
EndIf
If MV_PAR05 == 1
	//TITULO RA EM ABERTO	
	cSql += "SELECT "+CRLF  
	cSql += "	'03-TITULOS' TIPO,  "+CRLF  
	cSql += "	'RECEBIMENTO ANTECIPADO (RA)' DESCRICAO, "+CRLF  
	cSql += "	'' NUM_CART, "+CRLF  	
	cSql += "	'' COD_AUT_CARTAO, "+CRLF  
	cSql += "	'' ID_VENDA_CARTAO, "+CRLF  
	cSql += "	E1_CLIENTE CLIENTE_TIT, "+CRLF
	cSql += "	E1_LOJA LOJA_CLIENTE_TIT, "+CRLF
	cSql += "	E1_PREFIXO PREFIXO_TIT, "+CRLF  
	cSql += "	E1_NUM NUMERO_TIT, "+CRLF  
	cSql += "	E1_PARCELA PARCELA_TIT, "+CRLF  
	cSql += "	E1_TIPO TIPO_TIT, "+CRLF  
	cSql += "	E1_PEDGAR NUM_PEDGAR, "+CRLF  
	cSql += "	E1_EMISSAO DT_EMISSAO, "+CRLF  
	cSql += "	E1_VENCREA DT_VENCIMENTO, "+CRLF  
	cSql += "	E1_SALDO VLR_ABERTO "+CRLF  
	cSql += "FROM "+CRLF   
	cSql += "	"+RetSqlName("SE1")+" E1 "+CRLF   
	cSql += "WHERE "+CRLF   
	cSql += "	E1_FILIAL		= '"+xFilial("SE1")+"' AND "+CRLF   
	cSql += "	E1_TIPO IN( 'RA ') AND "+CRLF   
	cSql += "	E1_SALDO		> 0 AND "+CRLF   
	cSql += "	E1.D_E_L_E_T_	= ' ' "+CRLF       
	If MV_PAR03 == 1 .or. MV_PAR04 == 1 .or. MV_PAR06 == 1
		cSql += "UNION "+CRLF 	
	EndIf
Endif
If MV_PAR06 == 1
	//TITULO NCC EM ABERTO	
	cSql += "SELECT "+CRLF   
	cSql += "	'04-TITULOS' TIPO,  "+CRLF   
	cSql += "	'NOTA DE CREDITO (NCC)' DESCRICAO, "+CRLF   
	cSql += "	'' NUM_CART,	 "+CRLF   
	cSql += "	'' COD_AUT_CARTAO, "+CRLF   
	cSql += "	'' ID_VENDA_CARTAO, "+CRLF   
	cSql += "	E1_CLIENTE CLIENTE_TIT, "+CRLF
	cSql += "	E1_LOJA LOJA_CLIENTE_TIT, "+CRLF
	cSql += "	E1_PREFIXO PREFIXO_TIT, "+CRLF   
	cSql += "	E1_NUM NUMERO_TIT, "+CRLF   
	cSql += "	E1_PARCELA PARCELA_TIT, "+CRLF   
	cSql += "	E1_TIPO TIPO_TIT, "+CRLF   
	cSql += "	E1_PEDGAR NUM_PEDGAR, "+CRLF   
	cSql += "	E1_EMISSAO DT_EMISSAO, "+CRLF   
	cSql += "	E1_VENCREA DT_VENCIMENTO, "+CRLF   
	cSql += "	E1_SALDO VLR_ABERTO "+CRLF   
	cSql += "FROM "+CRLF    
	cSql += "	"+RetSqlName("SE1")+" E1 "+CRLF   
	cSql += "WHERE "+CRLF   
	cSql += "	E1_FILIAL		= '"+xFilial("SE1")+"' AND  "+CRLF   
	cSql += "	E1_TIPO IN( 'NCC') AND "+CRLF   
	cSql += "	E1_SALDO > 0 AND "+CRLF   
	cSql += "	E1.D_E_L_E_T_	= ' ' "+CRLF   
EndIf

If MV_PAR07 ==2
	cSqlA += "SELECT "+CRLF    
	cSqlA += "TIPO, "+CRLF   
	cSqlA += "DESCRICAO, "+CRLF
	cSqlA += "SUM(VLR_ABERTO) VLR_ABERTO "+CRLF   
Else
	cSqlA += "SELECT "+CRLF    
	cSqlA += " * "+CRLF
EndIf

cSqlA += "FROM "+CRLF   
cSqlA += "("+CRLF   
cSqlA += cSql+CRLF   
cSqlA += ") AS X "+CRLF   
cSqlA += " WHERE "   
cSqlA += " DT_EMISSAO BETWEEN "+DtoS(MV_PAR01)+" AND "+DtoS(MV_PAR02)+" "+CRLF   

If MV_PAR07 ==2
	cSqlA += "GROUP BY "+CRLF    
	cSqlA += "TIPO, "+CRLF	
	cSqlA += "DESCRICAO "+CRLF
EndIf
	
cSqlA += "ORDER BY TIPO, DESCRICAO "+CRLF
cSql := cSqlA

If Select("TRBTIT") > 0
	TRBTIT->(dbCloseArea())
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"TRBTIT",.F.,.T.)

If MV_PAR07 == 1
	TcSetField("TRBTIT","DT_EMISSAO","D",8,0)
	TcSetField("TRBTIT","DT_VENCIMENTO","D",8,0)
EndIf

dbSelectArea("TRBTIT")

TRBTIT->(DbGoTop())

TRBTIT->(DbEval({|| _nRecs++ }))

ProcRegua(_nRecs)

TRBTIT->(DbGoTop())
nFolha := 00

While ( !TRBTIT->(Eof()) )
	cbCont++
	
	IncProc("Processando "+AllTrim(Str(cbCont))+"/"+AllTrim(Str(_nRecs)) )
	ProcessMessage()

	#IFNDEF WINDOWS
		If LastKey() = 286
			lEnd := .T.
		EndIf
	#ENDIF
	
	If lEnd
		@ Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	EndIf

	If ( Li > 54 )
		nFolha++
		Li := RtCabec(@nFolha)
	EndIf
	 
	If MV_PAR07 == 1
		FmtLin({	TRBTIT->DESCRICAO,;				
					TRBTIT->CLIENTE_TIT+"/"+TRBTIT->LOJA_CLIENTE_TIT,;
					Posicione("SA1",1,xFilial("SA1")+TRBTIT->CLIENTE_TIT+TRBTIT->LOJA_CLIENTE_TIT,"A1_NREDUZ"),;
					TRBTIT->PREFIXO_TIT,;								
					TRBTIT->NUMERO_TIT,;
					TRBTIT->PARCELA_TIT,;
					TRBTIT->TIPO_TIT,;
					ALLTRIM(TRBTIT->NUM_PEDGAR),;
					TRBTIT->DT_EMISSAO,;
					TRBTIT->DT_VENCIMENTO,;
					VLR_ABERTO},aLay[06],,,@Li)
	Else
		FmtLin({	TRBTIT->TIPO,;				
					TRBTIT->DESCRICAO,;				
					VLR_ABERTO},aLay[06],,,@Li)	
	Endif
					
	FmtLin({},aLay[07],,,@Li)
	
	TRBTIT->(dbSkip())
EndDo

Set Device To Screen

If ( aReturn[5] = 1 )
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()
Return(.T.)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �RetLayOut � Autor � Eduardo Riera         � Data � 06.10.98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna o LayOut a ser impresso                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Array com o LayOut                                         ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static ;
Function RetLayOut()

Local aLay := Array(20)

//
//                     1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
//           01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

If MV_PAR07 == 1
	aLay[01] := "+-----------------------------------------------------------------------------------------------------------------------------+"
	aLay[02] := "|"+PadC("TITULOS EM ABERTO ANALITICO",112)+"Folha: ##### |"
	aLay[03] := "+-----------------------------------------------------------------------------------------------------------------------------+"
	aLay[04] := "|Descricao                  |Cliente   |Nome                |Pref|Num. Tit.|Parc|Tip|PedGar |Emissao |Vencto  |Valor em Aberto|"
	aLay[05] := "+---------------------------+-------------------------------+----+---------+----+---+-------+--------+--------+---------------+"
	aLay[06] := "|###########################|##########|####################|####|#########|####|###|#######|########|########|###############|"
	aLay[07] := "+-----------------------------------------------------------------------------------------------------------------------------+"
Else
	aLay[01] := "+-----------------------------------------------------------------------------------------------------------------------------+"
	aLay[02] := "|"+PadC("TITULOS EM ABERTO SINTETICO",112)+"Folha: ##### |"
	aLay[03] := "+-----------------------------------------------------------------------------------------------------------------------------+"
	aLay[04] := "|Tipo                       | Descricao                  |Valor em aberto                                                     |"
	aLay[05] := "+---------------------------+-------------------------------------------------------------------------------------------------+"
	aLay[06] := "|###########################|############################|##############                                                      |"
	aLay[07] := "+-----------------------------------------------------------------------------------------------------------------------------+"
EndIf
Return(aLay)

Static Function RtCabec(nFolha)

Local Li := 0
Local aLay := RetLayOut()

Li := 0
@ Li,000 PSAY AvalImp(Limite)

FmtLin({},aLay[01],,,@Li)
FmtLin({StrZero(nFolha,5)},aLay[02],,,@Li)
FmtLin({},aLay[03],,,@Li)
FmtLin({},aLay[04],,,@Li)
FmtLin({},aLay[05],,,@Li)

Return(Li)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CriaSx1   �Autor  �Solarium (David)    � Data �  15/09/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function CriaSx1(cPerg)
Local nX := 0
Local nY := 0
Local aAreaAnt := GetArea()
Local aAreaSX1 := SX1->(GetArea())
Local aReg := {}

aAdd(aReg,{cPerg,"01","Dt. Emissao de?"		,"mv_ch1","D", 8,0,0,"G",""							,"mv_par01","","","","","","","","","","","","","","",""})
aAdd(aReg,{cPerg,"02","Dt. Emissao ate?"	,"mv_ch2","D", 8 ,0,0,"G","(mv_par02>=mv_par01)"	,"mv_par02",""   ,"","","","",""   ,"","","","","","","","",""})
Aadd(aReg,{cPerg,"03","Cartao Cred.?"		,"MV_CH3","N", 01,0,0,"C",""                     	,"Mv_Par03","Sim","","","Nao","","","","","","","","","","",""})
Aadd(aReg,{cPerg,"04","Titulo Cliente?"		,"MV_CH4","N", 01,0,0,"C",""                     	,"Mv_Par04","Sim","","","Nao","","","","","","","","","","",""})
Aadd(aReg,{cPerg,"05","Titulo RA?"			,"MV_CH5","N", 01,0,0,"C",""                     	,"Mv_Par05","Sim","","","Nao","","","","","","","","","","",""})
Aadd(aReg,{cPerg,"06","Titulo NCC?"			,"MV_CH6","N", 01,0,0,"C",""                     	,"Mv_Par06","Sim"      ,"","","Nao","",""      ,"","","","","","","","",""})
Aadd(aReg,{cPerg,"07","Analitico/Sintetico"	,"MV_CH7","N", 01,0,0,"C",""                     	,"Mv_Par07","Analitico","","","Sintetico","","","","","","","","","","",""})
aAdd(aReg,{"X1_GRUPO","X1_ORDEM","X1_PERGUNT","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID","X1_VAR01","X1_DEF01","X1_CNT01","X1_VAR02","X1_DEF02","X1_CNT02","X1_VAR03","X1_DEF03","X1_CNT03","X1_VAR04","X1_DEF04","X1_CNT04","X1_VAR05","X1_DEF05","X1_CNT05","X1_F3"})

dbSelectArea("SX1")
dbSetOrder(1)
For ny:=1 to Len(aReg)-1
	If !dbSeek(aReg[ny,1]+aReg[ny,2])
		RecLock("SX1",.T.)
		For j:=1 to Len(aReg[ny])
			FieldPut(FieldPos(aReg[Len(aReg)][j]),aReg[ny,j])
		Next j
		MsUnlock()
	EndIf
Next ny
RestArea(aAreaSX1)
RestArea(aAreaAnt)
Return Nil
