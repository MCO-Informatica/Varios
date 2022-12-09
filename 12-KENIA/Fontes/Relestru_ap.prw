#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF
#include "TOPCONN.CH"

User Function Relestru()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,AORD")
SetPrvt("WNREL,ARETURN,NLASTKEY,CPERG,_APERGUNTAS,_NLACO")
SetPrvt("_ACAMPOS,_CARQTMP,_CARQTM2,_CCOMP,_CCOD,TAMANHO")
SetPrvt("NTIPO,CRODATXT,NCNTIMPR,LI,M_PAG,CABEC1")
SetPrvt("CABEC2,_CCODIGO,_NCODS,CQUERY,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==> 	#DEFINE PSAY SAY
#ENDIF
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==> #include "TOPCONN.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � RELESTRU � Autor �  Luciano Lorenzetti	� Data � 11/09/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Efetua a  impressao relacao de estruturas.				  ���
�������������������������������������������������������������������������Ĵ��
���Uso		 � Especifico KENIA.										  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

//��������������������������������������������������������������Ŀ
//� Variaveis obrigatorias dos programas de relatorio			 �
//����������������������������������������������������������������
titulo	  := "RELACAO DE ESTRUTURAS - PARA TROCA DE COMPONENTES"
cDesc1	  := "Emite a relacao das estruturas para troca de componentes."
cDesc2	  := "*** Especifico do cliente KENIA ***"
cDesc3    := ""
cString   := "SG1"
aOrd      := {}
wnrel	  := "RELESTRU"

//��������������������������������������������������������������Ŀ
//� Variaveis padrao de todos os relatorios 					 �
//����������������������������������������������������������������
aReturn  := { "Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nLastKey := 0
cPerg	 := "RELSTR    "

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas							 �
//��������������������������������������������������������������Ĵ
//� Variaveis utilizadas para parametros						 �
//� mv_par01	// Data de Referencia							 �
//��������������������������������������������������������������Ĵ
//� O trecho de programa abaixo verifica se o arquivo SX1 esta	 �
//� atualizado. Caso nao, deve ser inserido o grupo de perguntas �
//� que sera utilizado. 										 �
//����������������������������������������������������������������
_aPerguntas:= {}
//        1     2        3     4  5  6  7 8  9  10     11       12      13 14  15    16 17   18   19 20 21 22 23 24 25  26
AADD(_aPerguntas,{cPerg,"01","Componente 1       ?","mv_ch1","C",15,0,0,"G","","mv_par01","       ","  ","","       ","","","     ","","","","","","","","SB1",})
AADD(_aPerguntas,{cPerg,"02","Componente 2       ?","mv_ch2","C",15,0,0,"G","","mv_par02","       ","  ","","       ","","","     ","","","","","","","","SB1",})
AADD(_aPerguntas,{cPerg,"03","Componente 3       ?","mv_ch3","C",15,0,0,"G","","mv_par03","       ","  ","","       ","","","     ","","","","","","","","SB1",})
AADD(_aPerguntas,{cPerg,"04","Componente 4       ?","mv_ch4","C",15,0,0,"G","","mv_par04","       ","  ","","       ","","","     ","","","","","","","","SB1",})
AADD(_aPerguntas,{cPerg,"05","Componente 5       ?","mv_ch5","C",15,0,0,"G","","mv_par05","       ","  ","","       ","","","     ","","","","","","","","SB1",})
AADD(_aPerguntas,{cPerg,"06","Componente 6       ?","mv_ch6","C",15,0,0,"G","","mv_par06","       ","  ","","       ","","","     ","","","","","","","","SB1",})
dbSelectArea("SX1")

//If dbSeek(_aPerguntas[1,1]+_aPerguntas[1,2])
//	 Do While SX1->X1_GRUPO == cPerg
//		RecLock("SX1",.F.)
//		DELETE
//		MsUnLock()
//		dbSkip()
//	 EndDo
//EndIf

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
pergunte(cPerg,.F.)


//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT						 �
//����������������������������������������������������������������

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)

nLastKey:=IIf(LastKey()==27,27,nLastKey)
If nLastKey == 27
	Return
Endif
SetDefault(aReturn,cString)
nLastKey:=IIf(LastKey()==27,27,nLastKey)
If nLastKey == 27
	Return
Endif

Processa({|| RDESPGR() })// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({|| Execute(RDESPGR) })

Processa({|| ACERTA() })// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({|| Execute(ACERTA) })

RptStatus({|| PROCREL() })// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> RptStatus({|| Execute(PROCREL) })

Return



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � RDESPGR	� Autor � Luciano Lorenzetti	� Data � 11.09.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Processamento											  ���
�������������������������������������������������������������������������Ĵ��
��� Uso 	 � DVDESPGR 												  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> FUNCTION RDESPGR
Static FUNCTION RDESPGR()
//��������������������������������������������������������������Ŀ
//� Cria Arquivo de Trabalho									 �
//����������������������������������������������������������������
_aCampos:={ {"CODIGO"  ,"C",015,0},;
			{"COMP"    ,"C",015,0},;
			{"QUANT"   ,"N",012,6},;
			{"DESC"    ,"C",030,0} }

_cArqTmp := CriaTrab( _aCampos )
dbUseArea( .T.,, _cArqTmp, "TRB", if(.F. .OR. .F., !.F., NIL), .F. )
IndRegua ( "TRB",_cArqTmp,"CODIGO+COMP",,,"Selecionando Registros...")

//��������������������������������������������������������������Ŀ
//� Gera Arquivo Temporario utilizando TCQUERY					 �
//����������������������������������������������������������������
CriaTmp()
//��������������������������������������������������������������Ŀ
//� Trabalha os dados do arquivo gerado 						 �
//����������������������������������������������������������������
dbSelectArea("SQL")
dbGotop()
#IFDEF WINDOWS
	ProcRegua(RecCount())
#ENDIF
While !EOF()
	#IFDEF WINDOWS
		IncProc()
	#ENDIF
	dbSelectArea("SQL")
	RecLock("TRB",.T.)
	TRB->CODIGO := SQL->CODIGO
	TRB->COMP	:= SQL->COMP
	TRB->QUANT	:= SQL->QUANT
	MsUnLock()
	dbSelectArea("SQL")
	dbSkip()
EndDo

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � ACERTA	� Autor � Luciano Lorenzetti	� Data � 11.09.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Processamento											  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> FUNCTION ACERTA
Static FUNCTION ACERTA()
//��������������������������������������������������������������Ŀ
//� Cria Arquivo de Trabalho									 �
//����������������������������������������������������������������
_aCampos:={ {"CODIGO"  ,"C",015,0},;
			{"QUANT"   ,"N",010,0}}

_cArqTm2 := CriaTrab( _aCampos )
dbUseArea( .T.,, _cArqTm2, "TR2", if(.F. .OR. .F., !.F., NIL), .F. )
IndRegua ( "TR2",_cArqTm2,"CODIGO",,,"Selecionando Registros...")
//��������������������������������������������������������������Ŀ
//� Trabalha os dados do arquivo gerado 						 �
//����������������������������������������������������������������

dbSelectArea("TRB")
dbGotop()
#IFDEF WINDOWS
	ProcRegua(RecCount())
#ENDIF
_cComp := ""
_cCod  := TRB->CODIGO
While !EOF()
	#IFDEF WINDOWS
		IncProc()
	#ENDIF
	If (_cCod==TRB->CODIGO .and. _cComp<>TRB->COMP) .or. (_cCod<>TRB->CODIGO)
	   dbSelectArea("TR2")
	   If !dbSeek(TRB->CODIGO)
		  RecLock("TR2",.T.)
		  TR2->CODIGO := TRB->CODIGO
		  TR2->QUANT  := 1
		  MsUnLock()
	   Else
		  RecLock("TR2",.F.)
		  TR2->CODIGO := TRB->CODIGO
		  TR2->QUANT  := TR2->QUANT + 1
		  MsUnLock()
	   EndIf
	EndIf
	dbSelectArea("TRB")
	_cComp := TRB->COMP
	_cCod  := TRB->CODIGO
	dbSkip()
EndDo

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � PROCREL	� Autor � Luciano Lorenzetti	� Data � 11/09/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio 									  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> FUNCTION PROCREL
Static FUNCTION PROCREL()
//��������������������������������������������������������������Ŀ
//� Variaveis locais exclusivas deste programa					 �
//����������������������������������������������������������������
Tamanho  := "P"
nTipo    := 0
cRodaTxt := "REGISTRO(S)"
nCntImpr := 0

//�������������������������������������������������������������������Ŀ
//� Inicializa os codigos de caracter Comprimido/Normal da impressora �
//���������������������������������������������������������������������
nTipo  := IIF(aReturn[4]==1,15,18)

//��������������������������������������������������������������Ŀ
//� Contadores de linha e pagina								 �
//����������������������������������������������������������������
li    := 80
m_pag := 1

//����������������������������������������������������������Ŀ
//� Cria o cabecalho.										 �
//������������������������������������������������������������
cabec1 := "Codigo:          Componente:        Quantidade:"
cabec2 := "  "
*****	   XXXXXXXXXXXXXXX	XXXXXXXXXXXXXXX  99,999.999999
*****	   0		 1		   2		 3		   4		 5		   6	 7	   8		 9		   10	 11    12		 13 	   14	 15    16		 17 	   18	 19    20		 21 	   22
*****	   01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890


//����������������������������������������������������������Ŀ
//� Executa a impressao do relatorio.						 �
//������������������������������������������������������������
dbSelectArea("TR2")
dbGotop()
_cCodigo := TR2->CODIGO

//��������������������������������������������������������������Ŀ
//� Inicializa variaveis para controlar cursor de progressao     �
//����������������������������������������������������������������
SetRegua(RecCount())
Do While !Eof()
	IncRegua()
	//��������������������������������������������������������������Ŀ
	//� Verifica se o usuario interrompeu o relatorio		           �
	//����������������������������������������������������������������
	If lAbortPrint
		@ PROW(),001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	Endif

	If TR2->QUANT <> _nCods
	   dbSkip()
	   Loop
	EndIf

	If (li > 56)
		cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
	EndIf

	If (_cCodIgo <> TR2->CODIGO)
	   _cCodIgo := TR2->CODIGO
	   li := li + 1
	EndIf

	@ li,000 PSAY TR2->CODIGO
	dbSelectArea("TRB")
	dbSeek(TR2->CODIGO)
	Do While !Eof() .and. TRB->CODIGO==TR2->CODIGO
	   @ li,017 PSAY TRB->COMP
	   @ li,034 PSAY TRB->QUANT PICTURE "@E 99,999.999999"
	   li:=li+1
	   dbSkip()
	EndDo
	dbSelectArea("TR2")
	dbSkip()

EndDo

IF li != 80
	Roda(nCntImpr,cRodaTxt,Tamanho)
EndIF

//��������������������������������������������������������������Ŀ
//� Apaga arquivos tempor�rios									 �
//����������������������������������������������������������������
dbSelectarea("TRB")
dbCloseArea()
Ferase(_cArqTmp+".DBF")
Ferase(_cArqTmp+OrdBagExt())
dbSelectarea("TR2")
dbCloseArea()
Ferase(_cArqTm2+".DBF")
Ferase(_cArqTm2+OrdBagExt())
dbSelectArea("SQL")
dbCloseArea()

//��������������������������������������������������������������Ŀ
//� Apresenta relatorio na tela 								 �
//����������������������������������������������������������������
Set Device To Screen
If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnRel)
EndIf
MS_FLUSH()
RETURN


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � CriaTmp	� Autor � Luciano Lorenzetti	� Data � 11.09.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cria area temporaria em TopConnect ( Query ) 			  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function CriaTmp
Static Function CriaTmp()

_nCods := 0

cQuery := ''
cQuery :="Select     G1_COD       CODIGO   , "
cQuery := cQuery + " G1_COMP      COMP     , "
cQuery := cQuery + " G1_QUANT     QUANT      "
cQuery := cQuery + " From  "+RetSQLName("SG1")
cQuery := cQuery + " Where G1_FILIAL   = '" + xfilial("SG1") + "' and "
If Empty(mv_par01) .and. Empty(mv_par02) .and. Empty(mv_par03) .and. Empty(mv_par04) .and. Empty(mv_par05) .and. Empty(mv_par06)
   cQuery := cQuery + "       G1_COMP = ''"
Else
   If !Empty(mv_par01)
	  cQuery := cQuery + "       G1_COMP    = '" + ALLTRIM(mv_par01) +  "' "
	  _nCods := _nCods + 1
   EndIf
   If !Empty(mv_par02)
	  If _nCods > 0
		 cQuery := cQuery + " or "
	  EndIf
	  cQuery := cQuery + "       G1_COMP    = '" + ALLTRIM(mv_par02) +  "' "
	  _nCods := _nCods + 1
   EndIf
   If !Empty(mv_par03)
	  If _nCods > 0
		 cQuery := cQuery + " or "
	  EndIf
	  cQuery := cQuery + "       G1_COMP    = '" + ALLTRIM(mv_par03) +  "' "
	  _nCods := _nCods + 1
   EndIf
   If !Empty(mv_par04)
	  If _nCods > 0
		 cQuery := cQuery + " or "
	  EndIf
	  cQuery := cQuery + "       G1_COMP    = '" + ALLTRIM(mv_par04) +  "' "
	  _nCods := _nCods + 1
   EndIf
   If !Empty(mv_par05)
	  If _nCods > 0
		 cQuery := cQuery + " or "
	  EndIf
	  cQuery := cQuery + "       G1_COMP    = '" + ALLTRIM(mv_par05) +  "' "
	  _nCods := _nCods + 1
   EndIf
   If !Empty(mv_par06)
	  If _nCods > 0
		 cQuery := cQuery + " or "
	  EndIf
	  cQuery := cQuery + "       G1_COMP    = '" + ALLTRIM(mv_par06) +  "'  "
	  _nCods := _nCods + 1
   EndIf
EndIf
cQuery := cQuery + "  and  D_E_L_E_T_ <> '*' "

//cQuery := cQuery + " ORDER G1_COD , G1_COMP "

MEMOWRIT("C:\SQL.txt",cQuery)

cQuery := ChangeQuery(cQuery)

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"SQL", .F., .T.)
Return




