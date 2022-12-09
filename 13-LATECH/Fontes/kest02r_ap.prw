#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#INCLUDE "TOPCONN.ch"

User Function kest02r()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_CALIAS,_NORDEM,_NRECNO,TAMANHO,LIMITE,CDESC1")
SetPrvt("CDESC2,CDESC3,ARETURN,NOMEPROG,NLASTKEY,CSTRING")
SetPrvt("LCONTINUA,WNREL,CNOMEPRG,TITULO,AORD,ADRIVER")
SetPrvt("CPERG,LEND,CBCONT,CBTXT,_APERGUNTAS,_NLACO")
SetPrvt("_AARQUIVO,_CARQTRB,_NLIN,_NPAG,_NTIPO,M_PAG")
SetPrvt("_SINTETICO,_GRUPO_ATUAL,I,_PI,_PF,_LO")
SetPrvt("CQUERY,")

// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==> #INCLUDE "TOPCONN.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao	 � K_RELSLD � Autor �Ricardo Cassolatto 	� Data � 13.03.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio de Relacao de Saldos - USO Clinte Kenia		  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//��������������������������������������������������������������Ŀ
//� Guarda Ambiente                                              �
//����������������������������������������������������������������
_cAlias  := ALIAS()
_nOrdem  := INDEXORD()
_nRecno  := RECNO()
//��������������������������������������������������������������Ŀ
//� Inicializa Variaveis                                         �
//����������������������������������������������������������������
tamanho  := "P"
limite	 := 080
cDesc1	 := PADC("RELACAO DE SALDOS DE ESTOQUE",74)
cDesc2   := PADC("Especifico Kenia Tecelagem",74)
cDesc3   :=""
aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog :="K_RELSLD"
nLastkey := 0
cString  := "SF2"
lContinua:= .F.
wnrel    := "KEST02R"
cNomePrg := "KEST02R"
titulo	 := "RELACAO DE SALDOS"

aOrd     := {}
aDriver  :=ReadDriver()
cPerg	 :="K_RSLD    "
lEnd     := .F.

cbCont   := 00
Cbtxt    := Space( 10 )

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01               Produto Inicial                       �
//� mv_par02               Produto Final                         �
//� mv_par03			   Mostra Saldo Zero ?(S/N) 			 �
//� mv_par04			   Local de Estoque 					 �
//��������������������������������������������������������������Ĵ
//� O trecho de programa abaixo verifica se o arquivo SX1 esta   �
//� atualizado. Caso nao, deve ser inserido o grupo de perguntas �
//� que sera utilizado.                                          �
//����������������������������������������������������������������
_aPerguntas:= {}
//                   1       2          3                 4       5  6  7 8  9   10     11      12         13 14    15        16 17 18 19 20 21 22 23 24 25   26

AADD(_aPerguntas,{"K_RSLD","01","Produto Inicial     ?" ,"mv_ch1","C",15,0,0,"G"," ","mv_par01","         ","","","         ","","","","","","","","","","","SB1",})
AADD(_aPerguntas,{"K_RSLD","02","Produto Final       ?" ,"mv_ch2","C",15,0,0,"G"," ","mv_par02","         ","","","         ","","","","","","","","","","","SB1",})
AADD(_aPerguntas,{"K_RSLD","03","Saldo Zero  S/N     ?" ,"mv_ch3","N", 1,0,0,"C"," ","mv_par03","Sim      ","","","Nao      ","","","","","","","","","","","   ",})
AADD(_aPerguntas,{"K_RSLD","04","Local de Estoque    ?" ,"mv_ch4","C", 2,0,0,"G"," ","mv_par04","01       ","","","         ","","","","","","","","","","","   ",})


//dbSelectArea("SX1")
//dbSeek(cPerg)
//Do While cPerg == SX1->X1_GRUPO
//	 RecLock("SX1",.F.)
//	 dbDelete()
//	 MsUnlock()
//	 dbSkip()
//EndDo


dbSelectArea("SX1")
FOR _nLaco:=1 to LEN(_aPerguntas)
   If !dbSeek(_aPerguntas[_nLaco,1]+_aPerguntas[_nLaco,2])
     RecLock("SX1",.T.)
     SX1->X1_Grupo     := _aPerguntas[_nLaco,01]
     SX1->X1_Ordem     := _aPerguntas[_nLaco,02]
     SX1->X1_Pergunt   := _aPerguntas[_nLaco,03]
     SX1->X1_Variavl   := _aPerguntas[_nLaco,04]
     SX1->X1_Tipo      := _aPerguntas[_nLaco,05]
     SX1->X1_Tamanho   := _aPerguntas[_nLaco,06]
     SX1->X1_Decimal   := _aPerguntas[_nLaco,07]
     SX1->X1_Presel    := _aPerguntas[_nLaco,08]
     SX1->X1_Gsc       := _aPerguntas[_nLaco,09]
     SX1->X1_Valid     := _aPerguntas[_nLaco,10]
     SX1->X1_Var01     := _aPerguntas[_nLaco,11]
     SX1->X1_Def01     := _aPerguntas[_nLaco,12]
     SX1->X1_Cnt01     := _aPerguntas[_nLaco,13]
     SX1->X1_Var02     := _aPerguntas[_nLaco,14]
     SX1->X1_Def02     := _aPerguntas[_nLaco,15]
     SX1->X1_Cnt02     := _aPerguntas[_nLaco,16]
     SX1->X1_Var03     := _aPerguntas[_nLaco,17]
     SX1->X1_Def03     := _aPerguntas[_nLaco,18]
     SX1->X1_Cnt03     := _aPerguntas[_nLaco,19]
     SX1->X1_Var04     := _aPerguntas[_nLaco,20]
     SX1->X1_Def04     := _aPerguntas[_nLaco,21]
     SX1->X1_Cnt04     := _aPerguntas[_nLaco,22]
     SX1->X1_Var05     := _aPerguntas[_nLaco,23]
     SX1->X1_Def05     := _aPerguntas[_nLaco,24]
     SX1->X1_Cnt05     := _aPerguntas[_nLaco,25]
     SX1->X1_F3        := _aPerguntas[_nLaco,26]
     MsUnLock()
  EndIf
NEXT

PERGUNTE(cPerg,.F.)

wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,"",,,,.F.)

If nLastKey == 27
     Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
     Return
Endif

Processa({||CalcRel()})// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({||Execute(CalcRel)})
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return(.T.)
Return(.T.)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
*����������������������������������������������������������������������Ŀ*
*�     Processa os dados no temporario para obter e calcular os valores �*
*�     vindos das TABELAS de SQL                                        �*
*������������������������������������������������������������������������*
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CalcRel
Static Function CalcRel()

//��������������������������������������������������������������Ŀ
//� Estrutura de Arquivo DBF temporario para armazenar resultado �
//� da TCQUERY                                                   �
//����������������������������������������������������������������
_aArquivo:={}
AADD(_aArquivo,{"CODIGO"   ,"C",15,0})
AADD(_aArquivo,{"DESCRICAO","C",30,0})
AADD(_aArquivo,{"LOCAL"    ,"C",02,0})
AADD(_aArquivo,{"CRU"      ,"N",16,4})
AADD(_aArquivo,{"ESTOQUE"  ,"N",16,4})
AADD(_aArquivo,{"TINGINDO" ,"N",16,4})
AADD(_aArquivo,{"PEDIDOS"  ,"N",16,4})
AADD(_aArquivo,{"EMPENHO"  ,"N",16,4})
AADD(_aArquivo,{"SALDO"    ,"N",17,4})
AADD(_aArquivo,{"PRO_MES"  ,"N",16,4})
AADD(_aArquivo,{"QTD_TEAR" ,"N",16,4})
AADD(_aArquivo,{"SINT_ANA" ,"C",01,0})// este campo define sintetico/analitico

_cArqTRB:=CriaTrab(_aArquivo,.T.)
dbUseArea( .T.,, _cArqTRB, "TRB", if(.F. .OR. .F., !.F., NIL), .F. )
IndRegua("TRB",_cArqTRB,"CODIGO",,,"Criando Indice ...")

//��������������������������������������������������������������Ŀ
//� Gera Arquivo Temporario utilizando TCQUERY                   �
//����������������������������������������������������������������

CriaK1()

DbSelectArea("K1")
DbGoTop()
ProcRegua(LastRec())

Do While !Eof()

    //----> filtrando somente produto acabado E CRU
//  If K1->B1_TIPO == "PA" .OR. (K1->B1_TIPO == "PI" .AND. SUBSTR((K1->B1_COD),7,1) == ' ')
//  If K1->B1_TIPO == "PA" .OR. (SUBSTR((K1->B1_COD),4,3) == '000' .AND. RIGHT(ALLTRIM(K1->B1_COD),1) #' ') 
    If !K1->B1_TIPO$"KC KT"
       DbSkip()
       Loop
    Endif

	IncProc( OemToAnsi("Processando Saldos em Estoque - Produto "+K1->B1_COD) )
  
	//----> a formula do campo saldo e ((ESTOQUE+CRU+TINGINDO)-PEDIDOS)-EMPENHO)
	DbSelectArea("TRB")
	RecLock( "TRB" , .t. )
	  TRB->CODIGO   := K1->B1_COD
	  TRB->DESCRICAO:= K1->B1_DESC
	  TRB->LOCAL    := K1->B1_LOCPAD
	  
	  //----> este If trata a troca da coluna de estoque para o produto cru
      If K1->B1_TIPO$"KC"
		  TRB->CRU      := K1->B2_QATU
	  Else
		  TRB->ESTOQUE  := K1->B2_QATU
      EndIf
  
	  TRB->TINGINDO := 0.00
	  TRB->EMPENHO  := K1->B2_QEMP
      TRB->SALDO    := 0.00
      TRB->PRO_MES  := K1->B1_PRODMES
      TRB->QTD_TEAR := K1->B1_QTEARES
      TRB->SINT_ANA := "S"
	MsUnLock()
	
	DbSelectArea("K1")
	DbSkip()
EndDo

DbSelectArea("K1")
DbCloseArea("K1")

//----> busca os dados de produtos em tingimento (ordens de producao)
CriaK3()

DbSelectArea("K3")
DbGoTop()
ProcRegua(LastRec())

Do While !Eof()
	
	IncProc( OemToAnsi("Processando Ordens de Producao - Produto "+K3->C2_PRODUTO) )

	DbSelectArea("TRB")
    If DbSeek(K3->C2_PRODUTO)
		RecLock( "TRB" , .f. )
		  TRB->TINGINDO := IIf(TRB->TINGINDO+K3->C2_QUANT-(K3->C2_QUJE+K3->C2_PERDA) < 0, 0, TRB->TINGINDO+K3->C2_QUANT-(K3->C2_QUJE+K3->C2_PERDA))  
		MsUnLock()
	EndIf
	
	DbSelectArea("K3")
	DbSkip()
EndDo

DbSelectArea("K3")
DbCloseArea("K3")

//----> busca dados dos pedidos de venda em aberto produtos "normais"
CriaK4()

DbSelectArea("K4")
DbGoTop()
ProcRegua(LastRec())

Do While !Eof() 

	IncProc( OemToAnsi("Processando Pedidos de Vendas - Produto "+K4->C6_PRODUTO) )

    DbSelectArea("TRB")
    If DbSeek(K4->C6_PRODUTO)
		RecLock("TRB",.f.)
		  TRB->PEDIDOS := TRB->PEDIDOS + (K4->C6_QTDVEN - K4->C6_QTDENT)
		MsUnLock()
	EndIf
	
	DbSelectArea("K4")
	DbSkip()
EndDo

DbSelectArea("K4")
DbCloseArea("K4")

//----> calcula os saldos finais
DbSelectArea("TRB")
DbGoTop()
ProcRegua(LastRec())
Do While  !Eof()
	
	IncProc(OemToAnsi("Selecionando Dados para Impressao"))
  
	RecLock("TRB",.f.)
//      If RIGHT(AllTrim(TRB->CODIGO),3) == '000'    Jefferson
      If Substr((TRB->CODIGO),4,3) == '000'   
		  TRB->CRU      := TRB->CRU-TRB->EMPENHO
          TRB->TINGINDO := 0
		  TRB->SALDO    := TRB->ESTOQUE+TRB->CRU+TRB->TINGINDO-TRB->PEDIDOS
	  Else
		  TRB->SALDO := TRB->ESTOQUE+TRB->CRU+TRB->TINGINDO-TRB->PEDIDOS-TRB->EMPENHO
	  EndIf
	MsUnLock()
	DbSkip()
EndDo
////////////////////////////////////////////////////////////////////
// processa os dados baseado nos parametros para filtrar os dados //
////////////////////////////////////////////////////////////////////
DBSELECTAREA("TRB")
DBGOTOP()
// ������������������������������������������������������������Ŀ
// � se for sem inativos ou sem mostrar saldo zero, elimina-os /�
// � e se for somente tecido cru tambem                         �
// ��������������������������������������������������������������
WHILE ! EOF()
   /////////////////////////////////
   // elimina saldo zero/inativos //
   /////////////////////////////////
   IF MV_PAR03 == 2  // saldo zero
      IF TRB->SALDO == 0
		 RECLOCK("TRB",.f.)
           DBDELETE()
		 MSUNLOCK()
      ENDIF
   ENDIF

   DBSKIP()

END

*******************************************************************************
*******************************************************************************
****                           IMPRESSAO DOS DADOS                        *****
*******************************************************************************
*******************************************************************************
//��������������������������������������������������������������Ŀ
//� Variaveis para impressao                                     �
//����������������������������������������������������������������
_nLin      := 60
_nPag      := 0
_nTipo     := IIF(aReturn[4]==1,15,18)
m_pag      := 1
*��������������������������������������������������������������Ŀ
*� Imprime os dados do arquivo TRB                              �
*����������������������������������������������������������������

RptStatus({|| REL_KENIA() })// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> RptStatus({|| Execute(REL_KENIA) })
Return()

*���������������������������������������������������������������������������Ŀ*
*���������������������������������������������������������������������������Ĵ*
*����������������������FUNCAO DE IMPRESSAO RELATORIO������������������������Ĵ*
*���������������������������������������������������������������������������Ĵ*
*�����������������������������������������������������������������������������*
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function REL_KENIA
Static Function REL_KENIA()
dbSelectArea("TRB")
_sintetico := .t.
IndRegua("TRB",_cArqTRB,"SINT_ANA+CODIGO",,,"Criando Indice ...")
DBGOTOP()
SetRegua(RecCount())
_grupo_atual:=" "

While !EOF()
  //��������������������������������������������������������������Ŀ
  //� Verifica se o usuario interrompeu o relatorio                �
  //����������������������������������������������������������������
  If lAbortPrint
    @Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
    Exit
  Endif
  If TRB->SALDO <= 0.1
    DBSKIP()
    LOOP
  ENDIF

  IF TRB->SINT_ANA<>"S" .AND. _sintetico
     DBSKIP()
     LOOP
  ENDIF
  /////////////////
  // grupo atual //
  /////////////////
  _grupo_atual := LEFT( TRB->CODIGO , 3 )
  ///////////////////////////////////////////////////////////
  //acumula totais, por grupo, geral p/ final de relatorio //
  ///////////////////////////////////////////////////////////

  ////////////////////////////////////////
  //            do grupo                //
  ////////////////////////////////////////
  
  /////////////////////////////
  // *** imprime DETALHE *** //
  /////////////////////////////
  DETALHE()

  //////////////////////////////////////////////////
  // vai pro proximo e verifica se imprime totais //
  //////////////////////////////////////////////////
  DBSKIP()
  
  IF LEFT(TRB->CODIGO,3) <> _grupo_atual .AND. !_sintetico
     TOTGRUPO()
  ENDIF
EndDo

EJECT


// Fecha e apaga os arquivos temporarios
dbSelectarea("TRB")
dbCloseArea()
Ferase(_cArqTRB+".DBF")
Ferase(_cArqTRB+OrdBagExt())

// retorna a area anterior
DbSelectArea(_cAlias)
DbSetOrder(_nOrdem)
DbGoto(_nRecno)

Set device to Screen
//��������������������������������������������������������������Ŀ
//� Se em disco, desvia para Spool                               �
//����������������������������������������������������������������
If aReturn[5] == 1    // Se Saida para disco, ativa SPOOL
   Set Printer TO
   Set Device to Screen
   DbCommitAll()
   ourspool(wnrel)
Endif
MS_FLUSH()
Return()

//*���������������������������������������������������������������������������Ŀ*
//*���������������������������������������������������������������������������Ĵ*
//*���������������� CABECALHOS E LINHAS DE DETALHE DO RELATORIO ��������������Ĵ*
//*���������������������������������������������������������������������������Ĵ*
//*�����������������������������������������������������������������������������*
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function ImpCabec
Static Function ImpCabec()
*****************
/*
	 1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
CODIGO     DESCRICAO                      ESTOQUE    CRU        TINGINDO   PEDIDOS    SALDO      PROD.MES   QT.TEARES
---------- ------------------------------ ---------- ---------- ---------- ---------- ---------- ---------- ----------
999.999    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999.999,99 999.999,99 999.999,99 999.999,99 999.999,99 999.999,99 999.999,99
999.999    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999.999,99 999.999,99 999.999,99 999.999,99 999.999,99 999.999,99 999.999,99
*/
Titulo	 := "RELACAO DE SALDOS"
_nPag    := _nPag + 1
Cabec(Titulo," "," ",cNomePrg,Tamanho,_nTipo)
@ 004,000 PSAY REPLICATE("-",LIMITE)
@ 005,000 PSAY "CODIGO       SALDO | CODIGO       SALDO | CODIGO       SALDO | CODIGO       SALDO "
//				XXXXXX	999,999.99	 XXXXXX  999,999.99   XXXXXX  999,999.99   XXXXXX  999,999.99
@ 006,001 PSAY REPLICATE("-",LIMITE)
_nLin := 7
Return()

*�����������������������������������������������������������������������������*

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Detalhe
Static Function Detalhe()
If _nLin >= 57
   IMPCABEC()
EndIf
If TRB->SINT_ANA == "S"
   For i:= 0 to 3
	  If !Eof()
		 @ _nLin,000+(i*20)+i  PSAY SubStr(TRB->CODIGO,1,6)
         @ _nLin,008+(i*20)+i  PSAY TRB->SALDO     PICTURE "@E 999,999.99"
		 If i<3
			@ _nLin,019+(i*20)+i PSAY "|"
		 EndIf
		 dbSkip()
	  EndIf
   Next
   _nlin:=_nlin+1
EndIf

Return()

*����������������������������������������������������������������������������¿
*�                       Imprime total do Grupo                              ��
*������������������������������������������������������������������������������

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> FUNCTION TOTGRUPO
Static FUNCTION TOTGRUPO()
If _nLin >= 57
   IMPCABEC()
EndIf
_nLin:= _nLin+1
Return()

*******************************************************************************
*���������������������������������������������������������������������������Ŀ*
*��������������������������������������������������������������������������Ŀ�*
*���������������������������  QUERY's do SQL ������������������������������Ĵ�*
*���������������������������������������������������������������������������ٳ*
*�����������������������������������������������������������������������������*
*******************************************************************************
*---------------------------------------------------------------------------*

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CriaK1
Static Function CriaK1()
*---------------------------------------------------------------------------*

_pi:= MV_PAR01
_pf:= MV_PAR02
_lo:= MV_PAR04
cQuery := ''
cQuery := "SELECT  B1_COD, B1_DESC, B1_LOCPAD, B1_TIPO, B1_PRODMES, B1_QTEARES, B2_QATU, B2_QPEDVEN, B2_QEMP "
cQuery := cQuery + "FROM  "+RetSQLName("SB1")+" T1 , "+RetSQLName("SB2")+" T2 "
cQuery := cQuery + "WHERE T1.B1_FILIAL = '"+xfilial("SB1")+"' AND "
cQuery := cQuery + "      T2.B2_FILIAL = '"+xfilial("SB2")+"' AND "
//cQuery := cQuery + " T1.B1_TIPO= 'PA' AND "  Jefferson
cQuery := cQuery + " T1.B1_COD>= '"+ _pi+"' AND T1.B1_COD <= '"+_pf+"' AND "
cQuery := cQuery + " T2.B2_COD>= '"+ _pi+"' AND T2.B2_COD <= '"+_pf+"' AND "
cQuery := cQuery + " T1.B1_COD = T2.B2_COD AND "
cQuery := cQuery + " T1.B1_LOCPAD = T2.B2_LOCAL AND"
cQuery := cQuery + " T1.B1_LOCPAD = '" + _lo + "' AND "
cQuery := cQuery + " T2.B2_LOCAL =  '" + _lo + "' AND "
cQuery := cQuery + " T1.D_E_L_E_T_ <> '*' AND "
cQuery := cQuery + " T2.D_E_L_E_T_ <> '*' "
cQuery := cQuery + "ORDER BY  T1.B1_COD"
MEMOWRIT("C:\SQL01.txt",cQuery)
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"K1", .F., .T.)

Return()

*---------------------------------------------------------------------------*Function CriaK3

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CriaK3
Static Function CriaK3()
*---------------------------------------------------------------------------*

_pi:= MV_PAR01
_pf:= MV_PAR02
_lo:= MV_PAR04

DbSelectArea("SC2")
cQuery := ''
cQuery :="SELECT C2_QUANT, C2_PRODUTO, C2_QUJE , C2_PERDA"
cQuery := cQuery + "FROM  "+RetSQLName("SC2")+" T1 "
cQuery := cQuery + "WHERE T1.C2_FILIAL = '"+xfilial("SC2")+"' AND "
cQuery := cQuery + " ((T1.C2_PRODUTO>= '1"+ _pi+"' AND T1.C2_PRODUTO <= '1"+_pf+"')  OR "
cQuery := cQuery + " (T1.C2_PRODUTO>= '"+ _pi+"' AND T1.C2_PRODUTO <= '"+_pf+"' )) AND "
cQuery := cQuery + " T1.C2_LOCAL='"+_lo+"' AND "
cQuery := cQuery + " T1.C2_QUJE<>T1.C2_QUANT AND "
cQuery := cQuery + " (T1.C2_TIPO='1' OR T1.C2_ITEM='01') AND "
cQuery := cQuery + " T1.D_E_L_E_T_ <> '*' "
cQuery := cQuery + "ORDER BY  T1.C2_PRODUTO"
MEMOWRIT("C:\SQL03.txt",cQuery)
cQuery := ChangeQuery(cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"K3", .F., .T.)

Return()

*---------------------------------------------------------------------------*

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CriaK4
Static Function CriaK4()
*---------------------------------------------------------------------------*

_pi:= MV_PAR01
_pf:= MV_PAR02
_lo:= MV_PAR04

DbSelectArea("SC5")
DbSelectArea("SC6")

cQuery := ''
cQuery := "SELECT C5_NUM, C5_TIPO, C6_NUM, C6_ITEM, C6_PRODUTO, C6_QTDVEN, C6_QTDENT, C6_BLQ "
cQuery := cQuery + "FROM "+RetSQLName("SC5")+" T1, "+RetSQLName("SC6")+" T2 "
cQuery := cQuery + "WHERE T1.C5_FILIAL = T2.C6_FILIAL AND "
cQuery := cQuery + "T1.C5_NUM = T2.C6_NUM AND T1.C5_TIPO = 'N' AND "
cQuery := cQuery + "T2.C6_PRODUTO >= '"+ _pi+"' AND T2.C6_PRODUTO <= '"+_pf+"' AND "
cQuery := cQuery + "(T2.C6_QTDVEN - T2.C6_QTDENT) > 0 AND C6_BLQ <> 'R' AND "
cQuery := cQuery + "T1.D_E_L_E_T_ <> '*' AND "
cQuery := cQuery + "T2.D_E_L_E_T_ <> '*' "
cQuery := cQuery + "ORDER BY T2.C6_PRODUTO "
MEMOWRIT("C:\SQL04.txt",cQuery)
cQuery := ChangeQuery(cQuery)
DbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"K4", .F., .T.)

Return()

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

