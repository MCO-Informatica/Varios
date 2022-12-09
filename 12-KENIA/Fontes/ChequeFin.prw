#INCLUDE "rwmake.CH"
#include "PROTHEUS.CH"

#ifdef SPANISH
	#define STR0001 "Este programa imprimira los cheques del banco, a traves de"
	#define STR0002 "formulario impreso prev."
	#define STR0003 "Emision de cheques en formulario continuo"
	#define STR0004 "Cheque"
	#define STR0005 "Administrac."
	#define STR0006 "Enero"
	#define STR0007 "Febrero"
	#define STR0008 "Marzo"
	#define STR0009 "Abril"
	#define STR0010 "Mayo"
	#define STR0011 "Junio"
	#define STR0012 "Julio"
	#define STR0013 "Agosto"
	#define STR0014 "Septiemb"
	#define STR0015 "Octubr"
	#define STR0016 "Noviemb"
	#define STR0017 "Diciemb"
	#define STR0018 "Haga clic en el boton impresora para prueba de posicion."
	#define STR0019 "Antes de iniciar la impresion, compruebe si el formul. continuo"
	#define STR0020 "esta ajustado. La prueba se imprim. en la colum. de vlr."
	#define STR0021 "�Formulario colocado correctamente?                           "
	#define STR0022 "Fch. Inicial"
	#define STR0023 "Fecha Final "
	#define STR0024 "Error en la config. del cheque" + CHR ( 13 ) + "Verif. el tama�o de las lineas de extens."
	#define STR0025 "Ya existe el cheque numero: "
	#define STR0026 "Datos de Cta. Corriente Destino de cheque CPMF son invalidos"
#else
	#ifdef ENGLISH
		#define STR0001 "This program print the Bank Checks, using a "
		#define STR0002 "pre-printed form.   "
		#define STR0003 "Print Checks in Continuous Form Paper"
		#define STR0004 "Check"
		#define STR0005 "Management   "
		#define STR0006 "January"
		#define STR0007 "Febuary  "
		#define STR0008 "March"
		#define STR0009 "April"
		#define STR0010 "May "
		#define STR0011 "June "
		#define STR0012 "July "
		#define STR0013 "August"
		#define STR0014 "September"
		#define STR0015 "October"
		#define STR0016 "November"
		#define STR0017 "December"
		#define STR0018 "Click on the printer button for a positioning test."
		#define STR0019 "Before starting to print, make sure that the continuous form paper"
		#define STR0020 "is well adjusted. The test will be printed in the value column."
		#define STR0021 "Is the Form correctly positioned?"
		#define STR0022 "Initial Date"
		#define STR0023 "Final Date"
		#define STR0024 "Error configuring check" + CHR ( 13 ) + "Please check the extension line size"
		#define STR0025 "Check number already exists:  "
		#define STR0026 "Checking Account Data check Target CPMF are invalid         "
	#else
		#define STR0001 "Este programa ir� imprimir os Cheques do Banco, atrav�s de"
		#define STR0002 "formul�rio pr�-impresso."
		#define STR0003 "Emiss�o de Cheques em Formul�rio Cont�nuo"
		#define STR0004 "Cheque"
		#define STR0005 "Administracao"
		#define STR0006 "janeiro"
		#define STR0007 "fevereiro"
		#define STR0008 "marco"
		#define STR0009 "abril"
		#define STR0010 "maio"
		#define STR0011 "junho"
		#define STR0012 "julho"
		#define STR0013 "agosto"
		#define STR0014 "setembro"
		#define STR0015 "outubro"
		#define STR0016 "novembro"
		#define STR0017 "dezembro"
		#define STR0018 "Clique no bot�o impressora para teste de posicionamento."
		#define STR0019 "Antes de iniciar a impress�o, verifique se o formul�rio continuo"
		#define STR0020 "est� ajustado. O teste ser� impresso na coluna do valor."
		#define STR0021 "Formul�rio posicionado corretamente ?                         "
		#define STR0022 "Data Inicial"
		#define STR0023 "Data Final  "
		#define STR0024 "Erro na configuracao do cheque" + CHR ( 13 ) + "Verifique o tamanho das linhas de extenso"
		#define STR0025 "Ja existe o cheque numero:  "
		#define STR0026 "Dados da Conta Corrente Destino do cheque CPMF s�o invalidos"
	#endif
#endif

STATIC nColVlr
STATIC nLin1Ext
STATIC nCol1Ext
STATIC nLin2Ext
STATIC nCol2Ext
STATIC nLinFav
STATIC nColFav
STATIC nLinDat
STATIC nColVir
STATIC cExt
STATIC nCasas  :=0
STATIC nColAno :=0
STATIC nTamChq	:=0
STATIC nTamExt
STATIC nTamLin
STATIC cValor
STATIC nSalto
STATIC nComp

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FINR480  � Autor � Wagner Xavier         � Data � 09.07.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impress�o de Cheques                                       ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � FINR480(void)                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ChequeFin()
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
LOCAL cDesc1:= STR0001  //"Este programa ir� imprimir os Cheques do Banco, atrav�s de"
LOCAL cDesc2:= STR0002  //"formul�rio pr�-impresso."
LOCAL cDesc3:=""
LOCAL cString :="SEF"

PRIVATE wnrel
PRIVATE titulo:= STR0003  //"Emiss�o de Cheques em Formul�rio Cont�nuo"
PRIVATE cabec1
PRIVATE cabec2
PRIVATE aReturn := { OemToAnsi(STR0004), 1, OemToAnsi(STR0005), 1, 2, 1, "",1 }  //"Cheque"###"Administracao"
PRIVATE nomeprog:="ChequeFin"
PRIVATE nLastKey:= 0
PRIVATE cPerg   :="FIN480"
PRIVATE lComp   := .T.
PRIVATE lLayOut := .F.
PRIVATE nLinVlr := 0
PRIVATE cNumCheq
PRIVATE cBenef
PRIVATE lFA480MUN := ExistBlock("FA480MUN")



nComp	:= GetMv("MV_COMP")

If cPaisLoc == "BRA"
	AjustaSx1()
Endif
//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
pergunte("FIN480",.F.)

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01            // Codigo do Banco                       �
//� mv_par02            // Agencia                               �
//� mv_par03            // Conta                                 �
//� mv_par04            // Do Cheque                             �
//� mv_par05            // Ate o Cheque                          �
//� mv_par06            // Numera cheque automaticamente (S/N)   �
//� mv_par07            // Numero do 1.Cheque                    �
//� mv_par08            // Data Inicial                          �
//� mv_par09            // Data Final                            �
//� mv_par10            // Imprime cheques para PAS              �
//� mv_par11            // LayOut do Cheque (Normal ou CPMF)     �
//� mv_par12            // Codigo do Banco Destino (CPMF)        �
//� mv_par13            // Agencia  Destino (CPMF)               �
//� mv_par14            // Conta  Destino (CPMF)                 �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel := "ChequeFin"            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,"M")

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| FA480Imp(@lEnd,wnRel,cString)},Titulo)
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FA480Imp � Autor � Marcos Patricio       � Data � 20/12/95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao de Cheques                                       ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � FA600Imp(lEnd,wnRel,cString)                               ���
�������������������������������������������������������������������������Ĵ��
���Parametros� lEnd    - A��o do Codeblock                                ���
���          � wnRel   - T�tulo do relat�rio                              ���
���          � cString - Mensagem                                         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � FINA600                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FA480Imp()

LOCAL nRecAnt := 0
LOCAL nSavRec := 0
Local aDriver := ReadDriver()
Local cMunic  := ""
Local lFa480Bene := ExistBlock("FA480BENE")

If cPaisLoc	<>	"BRA"
	Private	aLayout	:=	{{0,0,""}}
	Private 	nMoeda:=1
Endif

If !( "DEFAULT" $ Upper( __DRIVER ) )
	SetPrc(000,000)
Endif

// Reseta a impressora se nao for via windows
If aReturn[5] <> 2 
	If GetMv("MV_COMP") == 15
		@ pRow(),pCol() PSAY &(If(aReturn[4]=1,aDriver[3],aDriver[4]))
	Else
		@ pRow(),pCol() PSAY &(aDriver[4])
	EndIf
EndIF

//��������������������������������������������������������������Ŀ
//� Verifica se existe o Banco                                   �
//����������������������������������������������������������������
dbSelectArea("SA6")
dbSeek(cFilial+mv_par01+mv_par02+mv_par03)
IF !Found()
	Help(" ",1,"BCONOEXIST")
	Return
Endif

If cPaisLoc == "BRA" .and. !FR480CC(3)
	Help(" ",1,"BCODESTINO",,STR0026,1,1) //"Dados da Conta Corrente Destino do cheque CPMF s�o inv�lidos"
	Return
Endif

If cPaisLoc<>"BRA"
	nMoeda:=Iif(SA6->A6_MOEDA>0,SA6->A6_MOEDA,1)
Endif

//��������������������������������������������������������������Ŀ
//� Verifica se j� existe o cheque inicial                       �
//����������������������������������������������������������������
If mv_par06 == 1
	dbSelectArea("SEF")
	If (dbSeek(cFilial+mv_par01+mv_par02+mv_par03+mv_par07))
		Help( " ",1,"A460CHEQUE")
		Return
	EndIf
EndIf

mv_par01:=mv_par01+Space( 3-Len(mv_par01))
mv_par02:=mv_par02+Space( 5-Len(mv_par02))
mv_par03:=mv_par03+Space(10-Len(mv_par03))
mv_par04:=mv_par04+Space(15-Len(mv_par04))

cNumCheq  := mv_par07
lImprimiu := .F.
lTeste := .F.

If cPaisLoc<>"BRA"
	IF !Empty( mv_par07 ) .and. mv_par06 == 1   //Cheques n�o gerados
		dbSelectArea("SEF")
		dbSetOrder(1)
		DbGotop()	
		dbSeek( cFilial+mv_par01+mv_par02+mv_par03 )
		cCond1 := "SEF->EF_BANCO==mv_par01.and.SEF->EF_AGENCIA==mv_par02.and.SEF->EF_CONTA==mv_par03"
	Else
		dbSelectArea("SEF")
		dbSeek( cFilial+mv_par01+mv_par02+mv_par03+mv_par04,.T. )
		cCond1:="SEF->EF_BANCO==mv_par01.and.SEF->EF_AGENCIA==mv_par02.and.SEF->EF_CONTA==mv_par03.and.EF_NUM<=mv_par05"
	EndIF
Else
	IF !Empty( mv_par07 ) .and. mv_par06 == 1   //Cheques n�o gerados
		dbSelectArea( "SEF" )
		dbSetOrder(2)
		dbSeek( xFilial("SEF")+mv_par01+mv_par02+mv_par03 )
		cCond1 := "SEF->EF_BANCO==mv_par01.and.SEF->EF_AGENCIA==mv_par02.and.SEF->EF_CONTA==mv_par03"//".T."
	Else
		dbSelectArea("SEF")
		dbSeek( cFilial+mv_par01+mv_par02+mv_par03+mv_par04,.T. )
		cCond1:="SEF->EF_BANCO==mv_par01.and.SEF->EF_AGENCIA==mv_par02.and.SEF->EF_CONTA==mv_par03.and.EF_NUM<=mv_par05"	
	Endif
EndIF

SetRegua(RecCount())

While !SEF->(Eof()) .and. SEF->EF_FILIAL = cFilial .and. &cCond1

	IncRegua()
	nPosTot:=1

	IF SEF->EF_IMPRESS $ "SAC"
		SEF->(dbSkip())
		Loop
	Endif

   If Alltrim(SEF->EF_TIPO) $ MVPAGANT .and. mv_par10==2
		SEF->(dbSkip())
		Loop
	Endif

	If !Empty( EF_BANCO)
		If EF_BANCO != mv_par01
			dbSkip( )
			Loop
		EndIf
	EndIf

	IF mv_par06 == 2 .and. ( Empty( SEF->EF_NUM ) .or. SubStr( SEF->EF_NUM,1,1 ) = "*" )
		SEF->(dbSkip())
		Loop
	EndIF

	If SEF->EF_DATA < mv_par08 .or. SEF->EF_DATA > mv_par09
		dbSkip()
		Loop
	Endif

	*����������������������������������������������������������Ŀ
	*�Se for numeracao automatica e cheque j� tenha sido gerado,�
	*�n�o ser� impresso                                         �
	*������������������������������������������������������������
	If mv_par06 == 1 .and. (!Empty(SEF->EF_NUM) .and. Substr(SEF->EF_NUM,1,1) != "*" )
		SEF->(dbSkip())
		Loop
	Endif

	*����������������������������������������������������������Ŀ
	*� Se houver selecao de banco, filtra o banco escolhido.    �
	*������������������������������������������������������������
	If !Empty(SEF->EF_BANCO)
		If SEF->EF_BANCO # mv_par01 .or. ;
			SEF->EF_AGENCIA # mv_par02 .or. ;
			SEF->EF_CONTA # mv_par03
			SEF->(dbSkip())
			Loop
		Endif
	Endif

	*����������������������������������������������������������Ŀ
	*� Recupera o extenso do cheque e monta as linhas           �
	*������������������������������������������������������������
	nRecAnt := Recno()
	dbSkip( )
	nSavRec := RecNo()
	dbGoto(nRecAnt)
	cBenef := SEF->EF_BENEF	
	//��������������������������������������������������������������Ŀ
	//� Ponto de entrada que permite alterar o beneficiario          �
	//����������������������������������������������������������������                                               
	If lFa480Bene
		cBenef := ExecBlock("FA480BENE",.F.,.F.)
	Else
		IF Empty(SEF->EF_BENEF) .and. !(SEF->EF_ORIGEM $ "FINA390AVU#FINA100PAG")
			IF !Empty( SEF->EF_BANCO )
				dbSelectArea( "SA6" )
				dbSeek( xFilial() + SEF->EF_BANCO )
				cBenef := SA6->A6_NOME
			Else
				dbSelectArea( "SA2" )
				dbSeek( xFilial() + SEF->EF_FORNECE + SEF->EF_LOJA )
				cBenef := SA2->A2_NOME
			Endif
		Endif
	Endif
                                                                
	//��������������������������������������������������������������Ŀ
	//� Ponto de entrada para carga do municipio pelo cliente.       �
	//����������������������������������������������������������������
	If lFA480MUN
		cMunic := ExecBlock("FA480MUN",.F.,.F.)
	Else
		cMunic := SA6->A6_MUN
	Endif

	If cPaisLoc ==	"BRA"
		If !ImpCheq(mv_par01,mv_par02,mv_par03,.F.,xFilial("SE5"),mv_par11,cMunic)
			Exit
		Endif
	Else
		If !ImpCheqLoc(mv_par01,mv_par02,mv_par03,.F.,xFilial("SE5"))
			Exit
		Endif
	Endif
	lImprimiu := .T.
	dbSelectArea( "SEF" )
	dbGoTo( nSavRec )
Enddo

If lImprimiu
	@ Prow(), PCol() PSAY Chr(27)+Chr(64)  // (48 = 1/8)  (64 = 1/6)
	@ Prow(), PCol() PSAY Chr(18)+" "
Endif
	
Set Device To Screen
dbSelectArea("SEF")
dbSetOrder(1)
dbSelectArea("SA6")
dbSetOrder(1)
Set Filter To

Set Device To Screen
SetPgEject(.F.)
If aReturn[5] = 1
	Set Printer To
	Commit
	Ourspool(wnrel)
Endif
MS_FLUSH()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �ImpCheq   � Autor � Wagner Xavier         � Data � 09.07.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Imprime um determinado cheque                               ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �ImpCheq                                                     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ImpCheq(cBanco,cAgencia,cConta,lMovBco,cFilAtual,nLayOut,cMunic)
Local lRet		:=	.F.
LOCAL cValor
LOCAL lFirst	:=.T.
LOCAL aMes := { OemToAnsi(STR0006),OemToAnsi(STR0007),OemToAnsi(STR0008),;   //"Janeiro"###"Fevereiro"###"Marco"
	OemToAnsi(STR0009),OemToAnsi(STR0010),OemToAnsi(STR0011),;   //"Abril"###"Maio"###"Junho"
	OemToAnsi(STR0012),OemToAnsi(STR0013),OemToAnsi(STR0014),;   //"Julho"###"Agosto"###"Setembro"
	OemToAnsi(STR0015),OemToAnsi(STR0016),OemToAnsi(STR0017) }   //"Outubro"###"Novembro"###"Dezembro"


Local cExtenso:= Extenso( SEF->EF_VALOR,.F.,1 )
Local cExt1
Local cExt2
Local nTamanho
Local nLoop
Local nRepete
LOCAL lFa480Dat := ExistBlock("FA480DAT")
Local nLinLoc
Local	nColLoc
Local	nColDat
Local nColBco
Local	nColCta

nComp := IIF(nComp == NIL , GetMv("MV_COMP"), nComp)
nLayOut := IIF(nLayOut == NIL, 1, nLayOut)

DEFAULT cMunic := SA6->A6_MUN

//��������������������������������������������������������������Ŀ
//� Verifica se cheque foi configurado.                          �
//����������������������������������������������������������������
IF (nLayOut == 1 .and. Empty( SA6->A6_LAYOUT )) .or. (nLayOut == 2 .and. Empty( SA6->A6_LAYIPMF ))
	Help(" ",1,"CHEQNAOCONF")
	Return .f.
Endif

If ! lLayout 
	If nLayOut == 1
		nTamChq :=Val(Substr(SA6->A6_LAYOUT,1,2))
		nSalto  :=Val(Substr(SA6->A6_LAYOUT,3,1))
		nLinVlr :=Val(SubStr(SA6->A6_LAYOUT,4,1))
		nColVlr :=Val(SubStr(SA6->A6_LAYOUT,25, 3))
		nColVlr :=IIF(nColVlr==0,93,nColVlr)
		nLin1Ext:=Val(SubStr(SA6->A6_LAYOUT,5,1))-nLinVlr
		nCol1Ext:=Val(SubStr(SA6->A6_LAYOUT,6,2))
		nLin2Ext:=Val(SubStr(SA6->A6_LAYOUT,8,1))-Val(SubStr(SA6->A6_LAYOUT,5,1))
		nCol2Ext:=Val(SubStr(SA6->A6_LAYOUT,9,2))
		nTamExt :=Val(SubStr(SA6->A6_LAYOUT,23, 2))
		nTamExt :=IIF(nTamExt==0,95,nTamExt)
		nLinFav :=Val(SubStr(SA6->A6_LAYOUT,11,2))-Val(SubStr(SA6->A6_LAYOUT,8,1))
		nColFav :=Val(SubStr(SA6->A6_LAYOUT,13,2))
		nLinDat :=Val(SubStr(SA6->A6_LAYOUT,15,2))-Val(SubStr(SA6->A6_LAYOUT,11,2))
		nColVir :=Val(SubStr(SA6->A6_LAYOUT,17,2))
		nCasas  :=Val(SubStr(SA6->A6_LAYOUT,19,1))
		nCasas  :=IIF(nCasas==0,2,nCasas)
		nColAno :=Val(SubStr(SA6->A6_LAYOUT,20,3))
		lComp   :=(SubStr(SA6->A6_LAYOUT,28, 1)=="S" .or. SubStr(SA6->A6_LAYOUT,28, 1)==" ")
	Else
		nTamChq :=Val(Substr(SA6->A6_LAYIPMF,1,2))
		nSalto  :=Val(Substr(SA6->A6_LAYIPMF,3,1))
		nLinVlr :=Val(SubStr(SA6->A6_LAYIPMF,4,1))
		nColVlr :=Val(SubStr(SA6->A6_LAYIPMF,25, 3))
		nColVlr :=IIF(nColVlr==0,93,nColVlr)
		nLin1Ext:=Val(SubStr(SA6->A6_LAYIPMF,5,1))-nLinVlr
		nCol1Ext:=Val(SubStr(SA6->A6_LAYIPMF,6,2))
		nLin2Ext:=Val(SubStr(SA6->A6_LAYIPMF,8,1))-Val(SubStr(SA6->A6_LAYIPMF,5,1))
		nCol2Ext:=Val(SubStr(SA6->A6_LAYIPMF,9,2))
		nTamExt :=Val(SubStr(SA6->A6_LAYIPMF,23, 2))
		nTamExt :=IIF(nTamExt==0,95,nTamExt)
		nLinLoc :=Val(SubStr(SA6->A6_LAYIPMF,11,2))//-Val(SubStr(SA6->A6_LAYIPMF,8,1))
		nColLoc :=Val(SubStr(SA6->A6_LAYIPMF,13,2))
		nColDat :=Val(SubStr(SA6->A6_LAYIPMF,15,2))//-Val(SubStr(SA6->A6_LAYIPMF,11,2))
		nColBco :=Val(SubStr(SA6->A6_LAYIPMF,17,2))
		nColCta :=Val(SubStr(SA6->A6_LAYIPMF,26,3))
		lComp   :=(SubStr(SA6->A6_LAYIPMF,28, 1)=="S" .or. SubStr(SA6->A6_LAYIPMF,28, 1)==" ")
	Endif
	lLayOut := .T.
	nLinVlr :=FA480Test(nColVlr)

	If  nLinVlr == 99
		 Return .f.
	Endif

Endif

*����������������������������������������������������������Ŀ
*� Verifica se o extenso ultrapassa o tamanho de colunas    �
*������������������������������������������������������������
cExt1 := SubStr (cExtenso,1,nTamExt ) // 1.a linha do extenso
nLoop := Len(cExt1)

While .T.

	If Len(cExtenso) == Len(cExt1) .and. Len(cExt1)+nCol1Ext <= nTamExt
		Exit
	EndIf

	If SubStr(cExtenso,Len(cExt1),1) == " " .and. Len(cExt1)+nCol1Ext <= nTamExt
		Exit
	EndIf

	cExt1 := SubStr( cExtenso,1,nLoop )
	nLoop --
	If nLoop <= 0
		MsgAlert(STR0024) // "Erro na configuracao do cheque"+CHR(13)+"Verifique o tamanho das linhas de extenso"
		Return .f.
	Endif
Enddo

cExt2 := SubStr(cExtenso,Len(cExt1)+1,nTamExt) // 2.a linha do extenso
IF Empty(cExt2)
	//��������������������������������������������������������������Ŀ
	//� Se nao tem 2a. linha de extenso, completa 1a. com *          �
	//����������������������������������������������������������������
	cExt1 += Replicate( "*",nTamExt - Len(cExt1) - nCol1Ext )
Else
	//������������������������������������������������������������������Ŀ
	//� Se tem, completa a primeira linha com espa�os entre as palavras  �
	//��������������������������������������������������������������������
	cExt1 := StrTran(cExt1," ","  ",,nTamExt - Len(cExt1) - nCol1Ext + 1)
Endif
cExt2 += Replicate( "*",nTamExt - Len(cExt2) - nCol2Ext )

*����������������������������������������������������������Ŀ
*� Imprime o cheque                                         �
*������������������������������������������������������������
If lFirst
	If lTeste  // SE FOI IMPRESSO TESTE
      SetPrc(0,0)
		@ 0,0 PSAY Chr(27)+Chr(64)
		If nSalto = 8
         SetPrc(0,0)
			@0,0 PSAY Chr(27)+Chr(48)
		Endif
		If lComp .and. !Empty(nComp)
         SetPrc(0,0)
			@ 0,0 PSAY CHR(nComp)
		Endif
		nLinVlr := PROW()
	Else
		@nLinVlr, 0 PSAY Chr(27)+Chr(64)
		If nSalto = 8
			@nLinVlr, 0 PSAY Chr(27)+Chr(48)
		Endif
		If lComp .and. !Empty(nComp)
			@nLinVlr,0 PSAY CHR(nComp)
		Endif
	Endif
Endif

cSimb  :=GETMV("MV_SIMB1")
cValor :=Alltrim(Transform(SEF->EF_VALOR,PesqPict("SEF","EF_VALOR",17)))
//�������������������������������������������������������������������Ŀ
//�  Ajuste do posicionamento da impressora: compactada: 1 posi��o ;  �
//�  sem compactar: 2 posi��es; segunda impress�o em diante: sem      �
//�  ajuste. Lembrete: ajuste apenas no primeiro cheque.              �
//���������������������������������������������������������������������
__LogPages()
If lFirst
	If lComp
      SetPrc(nLinVlr,0)
		@nLinVlr,nColVlr+1 PSAY cSimb
	Else
      SetPrc(nLinVlr,0)
		@nLinVlr,nColVlr+2 PSAY cSimb
	Endif
	lFirst := .F.
Else
	@nLinVlr,nColVlr PSAY cSimb
Endif

nRepete := pCol()+Len(cValor)+17-Len(cValor) - nTamExt

If nRepete > 0
	cValor += Replicate("*",17-Len(cValor)-nRepete)
Else
	cValor += Replicate("*",17-Len(cValor))
EndIf

@nLinVlr,PCOL()             PSAY cValor
@Prow()+nLin1Ext,nCol1Ext   PSAY cExt1
@Prow()+nLin2Ext,nCol2Ext   PSAY cExt2

If nLayOut == 1 //Cheque Normal
	@Prow()+nLinFav ,nColFav    PSAY IIF(cBenef==NIL,SEF->EF_BENEF,cBenef)
	nTamanho    :=1+Len(Trim(cMunic))
	@Prow()+nLinDat,nColVir-nTamanho  PSAY IIF(!Empty(cMunic),Trim(cMunic)," ")
	@Prow(),nColVir+1           PSAY Day(SEF->EF_DATA)  PicTure "99"
	@Prow(),Pcol()+6            PSAY aMes[Month(SEF->EF_DATA)]
	IF nCasas == 1
		@Prow(),nColAno         PSAY SubStr(Str(Year(SEF->EF_DATA),4),4,1)
	Elseif nCasas == 2
		@Prow(),nColAno         PSAY SubStr(Str(Year(SEF->EF_DATA),4),3,2)
	Elseif nCasas == 3
		@Prow(),nColAno         PSAY SubStr(Str(Year(SEF->EF_DATA),4),2,3)
	Else
		@Prow(),nColAno         PSAY Str(Year(SEF->EF_DATA),4)
	Endif
Else
	@ nLinLoc,nColLoc  PSAY IIF(!Empty(cMunic),AllTrim(cMunic)," ")
	@ nLinLoc,nColDat	 PSAY SUBSTR(DTOC(SEF->EF_DATA),1,6)+Str(Year(SEF->EF_DATA),4)
	@ nLinLoc,nColBco	 PSAY Alltrim(mv_par12)+"-"+AllTrim(mv_par13)
	@ nLinLoc,nColCta	 PSAY AllTrim(mv_par14)
Endif	

If lFA480DAT
	ExecBlock("FA480DAT",.F.,.F.)
Endif

@Prow()+1,0 PSAY " "   // Para descarregar buffer Windows 95

dbSelectArea("SEF")
nLinVlr+=nTamChq

@nLinVLr,0 PSAY " "		// Para avancar at� o fim do cheque
SetPrc(nLinVlr,0)

Reclock("SEF")
SEF->EF_IMPRESS := "S"
MsUnlock( )

lRet	:=	Fr480Grav(cBanco,cAgencia,cConta,lMovBco,cFilAtual)

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FR480Grav �Autor  �Bruno Sobieski      � Data �  06/15/00   ���
�������������������������������������������������������������������������͹��
���Desc.     � Faz as grava��es necessarias ap�s a impressao.             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � FINR480                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FR480Grav(cBanco,cAgencia,cConta,lMovBco,cFilAtual)
LOCAL lGerar    := .F.
LOCAL cCheqAnt
LOCAL nRecAnt   :=0
LOCAL nRegProx
LOCAL nRegCheq
Local cHistor:=""
Local nSEFpos := 0
Local lSpbInUse := SpbInUse()
Local aAreaSEF := {}

cNatGpe := GETMV("MV_CHQGPE")

lMovBco := Iif(lMovbco=Nil,.f.,lMovBco)
*���������������������������������������������������������Ŀ
*� Caso cheque n�o tenha sido gerado, ira gravar a movimen-�
*� ��o banc�ria e atualizar cheque emitido                 �
*�����������������������������������������������������������
IF (Empty( SEF->EF_NUM ) .or. SubStr(SEF->EF_NUM, 1, 1 ) = "*") .Or. FunName() == "GPER280"
 
	*����������������������������������������������������������������Ŀ
	*� Somente atualiza Movimentacao Bancaria caso cheque N�O SEJA p/ �
	*� um "PA" e esteja liberado pelo parametro MV_LIBCHEQ (=S)       �
	*������������������������������������������������������������������
	nSEFpos := Recno()
	lMovbco := GetMv("MV_LIBCHEQ")="S"
	lGerar  := .T.
	cCheqAnt := SEF->EF_NUM
	If FunName() != "GPER280" .and. Empty(cCheqAnt)     // GPE, o cheque j� foi gerado pelo GPER280
		Reclock( "SEF" )
		SEF->EF_NUM  	 := cNumCheq
		SEF->EF_BANCO   := mv_par01
		SEF->EF_AGENCIA := mv_par02
		SEF->EF_CONTA   := mv_par03
		SEF->EF_BENEF   := cBenef
		MsUnlock( )
	Endif
	nRegCheq := RecNo()
	If (Empty(cCheqAnt)) .AND. !SEF->EF_TIPO $ MVRECANT+"/"+MV_CRNEG
		//���������������������������������������������������������Ŀ
		//� Grava o numero do cheque no SE2 - para contabilizacao   �
		//�����������������������������������������������������������
		If FunName()  != "GPER280"        //GPE
			dbSelectArea("SE2")
			If SE2->(dbSeek(xFilial()+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO+SEF->EF_FORNECE+SEF->EF_LOJA))
				RecLock("SE2")
				SE2->E2_NUMBCO := cNumCheq
				MsUnlock()
				dbSelectArea("SE5")
				dbSetOrder(7)
				SE5->( dbSeek(xFilial()+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO))
				While ( SE5->(!Eof()) .And. xFilial("SE5") == SE5->E5_FILIAL .And.;
					SE2->E2_PREFIXO == SE5->E5_PREFIXO .And.;
					SE2->E2_NUM     == SE5->E5_NUMERO  .And.;
					SE2->E2_PARCELA == SE5->E5_PARCELA .And.;
					SE2->E2_TIPO    == SE5->E5_TIPO )
					If ( SE2->E2_FORNECE+SE2->E2_LOJA == SE5->E5_CLIFOR+SE5->E5_LOJA ) .and.;
						SE5->E5_SEQ == SEF->EF_SEQUENC .and. SE5->E5_TIPODOC != "CP"
						If Empty(SE5->E5_NUMCHEQ)
							RecLock("SE5",.F.)
							SE5->E5_BANCO   := mv_par01
							SE5->E5_AGENCIA := mv_par02
							SE5->E5_CONTA   := mv_par03
							SE5->E5_NUMCHEQ := cNumCheq
							MsUnlock()
						Endif
						cHistor			 := SE5->E5_HISTOR
					EndIf
					dbSelectArea("SE5")
					SE5->( dbSkip())
				EndDo
				dbSelectArea("SEF")
			Endif
		Endif
	EndIf

	If SEF->EF_TIPO $ MVRECANT+"/"+MV_CRNEG
		lMovBco := .T.
		//��������������������������������������Ŀ
		//� Neste caso o titulo veio de um Contas�
		//� a Receber (SE1)                      �
		//����������������������������������������
		dbSelectArea("SE1")
		dbSetOrder(1)
		dbSeek(xFilial()+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO)
		dbSelectArea("SE5")
		dbSetOrder(7)
		dbSeek(xFilial("SE5")+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO)
		While !Eof() .And. xFilial()+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO=;
			SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO
	
			IF	SE5->E5_MOTBX == "CMP"
				dbSkip()
				Loop
			Endif
						
			//������������������������������������������Ŀ
			//� Grv. o N.Cheque nos registros do    SE5 .�
			//� se nao for caixa , considerando E5_SEQ   �
			//��������������������������������������������
			If ( SE5->E5_CLIFOR+SE5->E5_LOJA == SE1->E1_CLIENTE+SE1->E1_LOJA ) .and. ;
				Substr(SE5->E5_BANCO,1,2) != "CX" .and. ;
				!(SE5->E5_BANCO $ GetMV("MV_CARTEIR")) .and.;
				SE5->E5_SEQ == SEF->EF_SEQUENC .And. SE5->E5_RECPAG == "P" .and. ;
				Empty (SE5->E5_NUMCHEQ)
				RecLock("SE5",.F.)
				SE5->E5_BANCO 		:= cBanco
				SE5->E5_AGENCIA	:= cAgencia
				SE5->E5_CONTA		:= cConta
				SE5->E5_NUMCHEQ	:= cNumCheq
				MsUnlock()
			EndIf
			dbSkip()
		Enddo
	Endif

	//���������������������������������������������������������Ŀ
	//� Caso cheque tenha sido gerado, ir� regravar novo numero �
	//� nos elementos do cheque.                                �
	//�����������������������������������������������������������
	If SubStr(cCheqAnt,1,1) = "*"
		dbSelectArea( "SEF" )
		dbSetOrder(1)
		SEF->( dbSeek( cFilial + mv_par01 + mv_par02 + mv_par03 + cCheqAnt ))
		While SEF->( !Eof() ).and. mv_par01+mv_par02+mv_par03+cCheqAnt == EF_BANCO+EF_AGENCIA+EF_CONTA+EF_NUM .And.;
				SEF->EF_FILIAL == xFilial("SEF")
			nRecAnt  := Recno()
			dbSkip( )
			nRegProx := RecNo()
			dbGoto(nRecAnt)
			Reclock( "SEF" )
			SEF->EF_NUM   := cNumCheq
			SEF->EF_BENEF := cBenef
			MsUnlock()
			//���������������������������������������������������������Ŀ
			//� Grava o numero do cheque no SE2 - para contabilizacao   �
			//�����������������������������������������������������������
			If FunName() != "GPER280" .and. !SEF->EF_TIPO $ MVRECANT +"/"+MV_CRNEG
				dbSelectArea( "SE2" )
				If SE2->(dbSeek(xFilial()+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO+SEF->EF_FORNECE+SEF->EF_LOJA))
					RecLock("SE2")
					SE2->E2_NUMBCO := cNumCheq
					MsUnlock()
					dbSelectArea("SE5")
					dbSetOrder(4)
					dbSeek(xFilial()+SE2->E2_NATUREZ+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO,.T.)
					While ( !Eof() .And. xFilial("SE5") == SE5->E5_FILIAL .And.;
							SE2->E2_NATUREZ == SE5->E5_NATUREZ .And.;
							SE2->E2_PREFIXO == SE5->E5_PREFIXO .And.;
							SE2->E2_NUM     == SE5->E5_NUMERO  .And.;
							SE2->E2_PARCELA == SE5->E5_PARCELA .And.;
							SE2->E2_TIPO    == SE5->E5_TIPO )
						If ( SE2->E2_FORNECE+SE2->E2_LOJA == SE5->E5_CLIFOR+SE5->E5_LOJA ) .and.;
								SE5->E5_SEQ == SEF->EF_SEQUENC
							RecLock("SE5",.F.)
							SE5->E5_BANCO   := mv_par01
							SE5->E5_AGENCIA := mv_par02
							SE5->E5_CONTA   := mv_par03
							SE5->E5_NUMCHEQ := SE2->E2_NUMBCO
							cHistor         := SE5->E5_HISTOR
							MsUnlock()
						EndIf
						dbSelectArea("SE5")
						dbSkip()
					EndDo
				Else
					//���������������������������������������������������������Ŀ
					//� Trata caso o registro seja origin�rio de uma movimenta- �
					//� ��o banc�ria manual e atualiza o saldo banc�rio do che- �
					//� que renumerado.                                         �
					//�����������������������������������������������������������
					dbSelectArea("SE5")
					dbSetOrder(1)
					If dbSeek(xFilial()+DtoS(SEF->EF_DATA)+SEF->EF_BANCO+SEF->EF_AGENCIA+SEF->EF_CONTA+cCheqAnt)
						lMovBco := .F.
						While ! Eof() .And.SE5->E5_FILIAL== xFilial() .And.;
								DTOS(SE5->E5_DATA)== DtoS(SEF->EF_DATA) .And.;
								SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA) == SEF->(EF_BANCO+EF_AGENCIA+EF_CONTA)								
							If SE5->E5_SITUACA == "C" .Or. SE5->E5_TIPODOC == "TE" ;
									.Or. (SE5->E5_TIPODOC == "TR" .And. SE5->E5_MOEDA == "ES")
								dbSkip()
								Loop
							EndIf
							If SE5->E5_TIPODOC == "TR"
								If Substr(SE5->E5_NUMCHEQ,1,15) == Substr(cCheqAnt,1,15) .or. ;
										Substr(SE5->E5_DOCUMEN,1,15) == Substr(cCheqAnt,1,15)
									RecLock("SE5",.F.)
									IF SE5->E5_RECPAG == "P"
										SE5->E5_NUMCHEQ := cNumCheq
									Else
										SE5->E5_DOCUMEN := cNumCheq
									Endif
									MsUnlock()
									If SE5->E5_RECPAG == "P"
										AtuSalBco( SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,SE5->E5_DTDISPO,SE5->E5_VALOR,"-")
									Else
										AtuSalBco( SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,SE5->E5_DTDISPO,SE5->E5_VALOR,"+")
									EndIf
								Endif
							Else
								If Substr(SE5->E5_NUMCHEQ,1,15) == Substr(cCheqAnt,1,15)
									RecLock("SE5",.F.)
									SE5->E5_NUMCHEQ := cNumCheq
									MsUnlock()
									If SE5->E5_RECPAG == "P"
										AtuSalBco( SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,SE5->E5_DTDISPO,SE5->E5_VALOR,"-")
									Else
										AtuSalBco( SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,SE5->E5_DTDISPO,SE5->E5_VALOR,"+")
									EndIf
								Endif
							EndIf
							dbSelectArea("SE5")
							dbSkip()
						EnddO
					Endif
				Endif
			Endif
			dbSelectArea( "SEF" )
			dbSetOrder(1)
			SEF->( dbGoTo( nRegProx ) )
		EndDO
	Endif
	dbGoTo( nRegCheq )
Endif

If cPaisLoc != "BRA" .AND. nSEFpos != 0 .AND. Alltrim(SEF->EF_ORIGEM) 	== "FINA085A"
	aArea:=GetArea()
	DbSelectArea("SEF")
	DbGoto(nSEFpos)
	DbSelectArea("SE2")
	DbSetOrder(1)
	If dbSeek(xFilial()+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO+SEF->EF_FORNECE+SEF->EF_LOJA)
		lMovBco := .F.
	EndIf
	RestArea(aArea)
Endif

If lMovBco
	Reclock( "SE5",.T. )
	SE5->E5_FILIAL      := Iif(cFilAtual=Nil,xFilial(),cFilAtual)
	SE5->E5_BANCO       := cBanco
	SE5->E5_AGENCIA     := cAgencia
	SE5->E5_CONTA       := cConta
	SE5->E5_BENEF       := SEF->EF_BENEF
	SE5->E5_DATA        := SEF->EF_DATA
	SE5->E5_NUMCHEQ     := cNumCheq
	SE5->E5_DTDIGIT     := SEF->EF_DATA
	SE5->E5_HISTOR      := if(!Empty(SEF->EF_HIST),SEF->EF_HIST,cHistor)
	SE5->E5_RECPAG      := "P"
	SE5->E5_TIPODOC     := "CH"
	SE5->E5_DTDISPO     := SEF->EF_DATA
	SE5->E5_VALOR       := SEF->EF_VALOR
	If FunName() == "GPER280"     //GPE
		SE5->E5_NATUREZ     := &cNatGpe
	Endif
	//Se o cheque vem de uma ordem de pagamento, gravar o numero dela no SE5
	If cPaisLoc	<>	"BRA" .And. SEF->EF_TIPO == "ORP"
		SE5->E5_ORDREC	:=	Alltrim(SEF->EF_TITULO)
	Endif
	If lSpbInuse
		SE5->E5_MODSPB  := "3"
	Endif
	MsUnlock()

	If FunName() != "GPER280"     //GPE
		If !SE2 -> E2_TIPO $ MVPAGANT
			Reclock("SE5")
			SE5->E5_NATUREZ     := SE2->E2_NATUREZ
			MsUnlock()
		Endif
	Endif

	If ExistBlock("FA480SAL")
		ExecBlock("FA480SAL",.F.,.F.)
	Endif

	If FunName() != "GPER280" .Or. (FunName() == "GPER280" .And. Select("SE8") > 0)   //GPE
		//���������������������������������������������������������Ŀ
		//� Atualiza o Saldo Bancario                               �
		//�����������������������������������������������������������
		AtuSalBco( cBanco,cAgencia,cConta,SEF->EF_DATA,SEF->EF_VALOR,"-")
	Endif
Elseif SEF->EF_TIPO $ MVPAGANT
	dbSelectArea("SE5")
	dbSetOrder(3)
	If dbSeek(xFilial()+SEF->EF_BANCO+SEF->EF_AGENCIA+SEF->EF_CONTA+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO)
		While SE5->(!Eof()) .And.;
				xFilial("SE5") == SE5->E5_FILIAL .And.;
				SEF->EF_PREFIXO == SE5->E5_PREFIXO .And.;
				SEF->EF_TITULO  == SE5->E5_NUMERO  .And.;
				SEF->EF_PARCELA == SE5->E5_PARCELA .And.;
				SEF->EF_TIPO    == SE5->E5_TIPO
			If SEF->EF_FORNECE+SEF->EF_LOJA == SE5->E5_CLIFOR+SE5->E5_LOJA .And.;
				SE5->E5_SEQ == SEF->EF_SEQUENC
				Reclock("SE5")
				SE5->E5_NUMCHEQ := SEF->EF_NUM
				MsUnlock()
			Endif
			SE5->(DbSkip()	)
		End
	Endif
Endif
If lMovBco .or. lGerar
	//���������������������������������������������������������Ŀ
	//� Incrementa o Numero do Cheque caso houve movimentacao   �
	//� bancaria ou um novo cheque foi gerado                   �
	//�����������������������������������������������������������
	While .T.
		cNumCheq:=Soma1(Trim(cNumCheq),Len(Trim(cNumCheq)))
		aAreaSEF := SEF->(GetArea())
		SEF->(dbSetOrder(1))
		If !(SEF->(dbSeek(xFilial("SEF")+cBanco+cAgencia+cConta+cNumCheq)))
			SEF->(RestArea(aAreaSEF))
			Exit
		Endif
	Enddo	
Endif
//���������������������������������������������������������Ŀ
//� PE FA480COM                                             �
//� Utilizado para gravar dados complementares apos imprimir�
//� o cheque                                                �
//�����������������������������������������������������������
If ExistBlock("FA480COM")
	ExecBlock("FA480COM",.F.,.F.)
Endif

Return .t.

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � fa480Test� Autor � Wagner Xavier         � Data � 14/02/92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Teste da emissao do cheque                                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � fa480test                                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FA480TEST(nColVlr)

Local nOpca
LOCAL li:=nLinVlr
Local aSays:={}, aButtons:={},cCadastro := ""

AADD(aSays,OemToAnsi( STR0019 ) ) //"Antes de iniciar a impress�o, verifique se o formul�rio continuo"
AADD(aSays,OemToAnsi( STR0020 ) ) //"est� ajustado. O teste ser� impresso na coluna do valor."
AADD(aSays,OemToAnsi( STR0018 ) ) //"Clique no bot�o impressora para teste de posicionamento."
AADD(aSays,OemToAnsi( STR0021 ) )  //"Formul�rio posicionado corretamente ?"
AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}} )
AADD(aButtons, { 2,.T.,{|o| nOpca:= 0, li:=99,o:oWnd:End()}} )
AADD(aButtons, { 6,.T.,{|o| nOpca:= 0, li:=CKIMP(nColVlr)}} )
FormBatch( cCadastro, aSays, aButtons )

Return li

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � CKIMP    � Autor � Marcos Patricio       � Data � 20/12/95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime caracter para teste                                ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � CKIMP                                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � FINR480                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CKIMP(nColVlr)
LOCAL cTeste
LOCAL li :=nLinVlr
cTeste := "."
If lComp .and. !Empty(nComp)
	cTeste:= CHR(nComp)+"."
Endif
@li,00      PSAY cTeste
@li,nColVlr PSAY "."
prnflush()
lTeste := .T.
Return nColVlr

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FA480CH  � Autor � Wagner Xavier         � Data � 24/06/98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de entrada para teste do n� cheque e outros          ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � FA480CH()                                                  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � FINR480                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fa480Ch()
LOCAL lRet := .T.
If !Execblock("FA480CH",.f.,.f.)
	lRet := .f.
Endif
Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �ImpCheqLoc� Autor � Bruno Sobieski        � Data � 15.06.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Imprime um determinado cheque (Localizacoes)                ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �ImpCheqLoc(cBanco,cAgencia,cConta,lMovBco,cFilAtual)        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ImpCheqLoc(cBanco,cAgencia,cConta,lMovBco,cFilAtual)
Local lRet			:=	.F.
LOCAL cValor
LOCAL lFirst    	:=.T.
LOCAL aMes := { OemToAnsi(STR0006),OemToAnsi(STR0007),OemToAnsi(STR0008),;   //"Janeiro"###"Fevereiro"###"Marco"
	OemToAnsi(STR0009),OemToAnsi(STR0010),OemToAnsi(STR0011),;   //"Abril"###"Maio"###"Junho"
	OemToAnsi(STR0012),OemToAnsi(STR0013),OemToAnsi(STR0014),;   //"Julho"###"Agosto"###"Setembro"
	OemToAnsi(STR0015),OemToAnsi(STR0016),OemToAnsi(STR0017) }   //"Outubro"###"Novembro"###"Dezembro"
Local cExtenso := ""
Local nI
Local cExt1
Local cExt2
Local nPosExt1	:=	nPosExt2	:=	0
Local nLoop
Local nRepete
Local	aLaySort	:=	{}
Local nDesplaza	:=	0
Local aArea:={}
//��������������������������������������������������������������Ŀ
//� Verifica se cheque foi configurado.                          �
//����������������������������������������������������������������
IF Empty( SA6->A6_LAYOUT )
	Help(" ",1,"CHEQNAOCONF")
	Return .f.
Endif

If cPaisLoc=="PAR"  // Acertado pois no Paraguai nao pode imprimir a descricao 
	cExtenso:= Extenso( SEF->EF_VALOR,.F.,nMoeda,".")
Else
	cExtenso:= Extenso( SEF->EF_VALOR,.F.,nMoeda)
Endif

If ! lLayout
	aLayout	:=	{}
	AAdd(aLayout,{Val(SubStr(SA6->A6_LAYOUT,4,1))	,IIF(Val(SubStr(SA6->A6_LAYOUT,25, 3))==0,93,Val(SubStr(SA6->A6_LAYOUT,25, 3))),"VALOR"})
	AAdd(aLayout,{Val(SubStr(SA6->A6_LAYOUT,5,1))	,Val(SubStr(SA6->A6_LAYOUT,6,2))	,"EXTENSO1"	})
	AAdd(aLayout,{Val(SubStr(SA6->A6_LAYOUT,8,1))	,Val(SubStr(SA6->A6_LAYOUT,9,2))	,"EXTENSO2"	})
	AAdd(aLayout,{Val(SubStr(SA6->A6_LAYOUT,11,2))	,Val(SubStr(SA6->A6_LAYOUT,13,2))	,"FAVORECI"	})
	AAdd(aLayout,{Val(SubStr(SA6->A6_LAYOUT,15,2))	,Val(SubStr(SA6->A6_LAYOUT,17,2))-(1+Len(Trim(SA6->A6_MUN))) ,"MUNICIP"	})
	AAdd(aLayout,{Val(SubStr(SA6->A6_LAYOUT,15,2))	,Val(SubStr(SA6->A6_LAYOUT,17,2))+2,"DIA"})
	AAdd(aLayout,{Val(SubStr(SA6->A6_LAYOUT,15,2))	,Val(SubStr(SA6->A6_LAYOUT,17,2))+8,"MES"	}) //2 do DIA + 6 de espaco para  o "  DE  " do cheque
	AAdd(aLayout,{Val(SubStr(SA6->A6_LAYOUT,15,2))	,Val(SubStr(SA6->A6_LAYOUT,20,3))	,"ANO"	})
	
	
	//Ordernar por linha + coluna
	aLaySort	:=	aSort(aLayout,,,{|x,y| IIf(x[1] == y[1],x[2] < y[2],x[1] < y[1] ) })
	aLayout	:=	AClone(aLaySort)
	
	//Arrumo todas as linhas para ficarem relativas a primeira, comeco da ultima.
	For nI	:=	Len(aLayout)	To	2	STEP -1
		aLayOut[nI][1]	:=	aLayOut[nI][1] - aLayOut[nI-1][1]
	Next		
	
	nTamChq :=Val(Substr(SA6->A6_LAYOUT,1,2))
	nSalto  :=Val(Substr(SA6->A6_LAYOUT,3,1))
	nTamExt :=Val(SubStr(SA6->A6_LAYOUT,23, 2))
	nTamExt :=IIF(nTamExt==0,95,nTamExt)
	nCasas  :=Val(SubStr(SA6->A6_LAYOUT,19,1))
	nCasas  :=IIF(nCasas==0,2,nCasas)
	lComp   :=(SubStr(SA6->A6_LAYOUT,28, 1)=="S" .or. SubStr(SA6->A6_LAYOUT,28, 1)==" ")
	
	//For�o o valor da nLinVlr porque dentro da funcao fa480test() referencia ela.
	nLinVlr  :=	aLayOut[1][1]
	nPrimCol	:=	aLayOut[1][2]
	
	aLayOut[1][1]	:=	FA480Test(nPrimCol)
	
	lLayOut := .T.
	
	If	aLayOut[1][1] == 99
		Return .f.
	Endif
	
Endif

//Vou Obter as Posicoes no Array de cada um dos campos que precisso
nPosExt1	:=	Ascan(aLayout,{|X| X[3] == "EXTENSO1" })
nPosExt2	:=	Ascan(aLayout,{|X| X[3] == "EXTENSO2" })

*����������������������������������������������������������Ŀ
*� Verifica se o extenso ultrapassa o tamanho de colunas    �
*������������������������������������������������������������
cExt1 := SubStr (cExtenso,1,nTamExt ) // 1.a linha do extenso
nLoop := Len(cExt1)

While .T.
	
	If Len(cExtenso) == Len(cExt1) .And. Len(cExt1) + aLayout[nPosExt1][2] <= nTamExt
		Exit
	EndIf
	
	If SubStr(cExtenso,Len(cExt1),1) == " " .And. Len(cExt1)+ aLayout[nPosExt1][2] <= nTamExt
		Exit
	EndIf
	
	cExt1 := SubStr( cExtenso,1,nLoop )
	nLoop -- 
	If nLoop <= 0
		MsgAlert(STR0024) // "Erro na configuracao do cheque"+CHR(13)+"Verifique o tamanho das linhas de extenso"
		Return .f.
	Endif
Enddo

cExt2 := SubStr(cExtenso,Len(cExt1)+1,nTamExt) // 2.a linha do extenso
IF Empty(cExt2)
	//��������������������������������������������������������������Ŀ
	//� Se nao tem 2a. linha de extenso, completa 1a. com *          �
	//����������������������������������������������������������������
	cExt1 += Replicate( "*",nTamExt - Len(cExt1) - aLayout[nPosExt1][2] )
Else
	//������������������������������������������������������������������Ŀ
	//� Se tem, completa a primeira linha com espa�os entre as palavras  �
	//��������������������������������������������������������������������
	cExt1 := StrTran(cExt1," ","  ",,nTamExt - Len(cExt1) - aLayout[nPosExt1][2] + 1)
Endif
cExt2 += Replicate( "*",nTamExt - Len(cExt2) - aLayout[nPosExt2][2] )

*����������������������������������������������������������Ŀ
*� Imprime o cheque                                         �
*������������������������������������������������������������
If lFirst
	@aLayout[1][1], 0 PSAY Chr(27)+Chr(64)
	If nSalto = 8
		@aLayout[1][1], 0 PSAY Chr(27)+Chr(48)
	Endif
	If lComp
		@aLayout[1][1],0 PSAY Chr(15)
	Endif
Endif

if cPaisLoc=="PAR"
	cSimb:= " "
else 
	cSimb  :=GetMv("MV_SIMB"+alltrim(Str(nMoeda,2)))
EndIf 
cValor := cSimb + Alltrim(Transform(SEF->EF_VALOR,PesqPict("SEF","EF_VALOR",17)))

//�������������������������������������������������������������������Ŀ
//�  Ajuste do posicionamento da impressora: compactada: 1 posi��o ;  �
//�  sem compactar: 2 posi��es; segunda impress�o em diante: sem      �
//�  ajuste. Lembrete: ajuste apenas no primeiro cheque.              �
//���������������������������������������������������������������������
__LogPages()

If lFirst
	If lComp
		nDesplaza	:=	1
	Else
		nDesplaza	:=	2
	Endif
	lFirst := .F.
Else
	nDesplaza	:=	0
Endif

For	nI	:=	1	To	Len(aLayout)
	If nI	==	1	//So o primeiro tem uma posicao absoluta, os outros sao relativos ao primeiro
		nRow	:=	0
	Else
		nRow	:=	PROW()
	Endif	
	Do Case	
	Case aLayout[nI][3] == "VALOR"
		nRepete := nDesplaza + aLayout[nI][2] +Len(cValor)+17-Len(cValor) - nTamExt
		If nRepete > 0
			cValor += Replicate("*",14-Len(cValor)-nRepete)
		Else
			cValor += Replicate("*",14-Len(cValor))
		EndIf
		@nRow + aLayout[nI][1], nDesplaza + aLayout[nI][2] PSAY cValor
		nDesplaza	:=	0
	Case aLayout[nI][3] == "EXTENSO1"
		@nRow + aLayout[nI][1], nDesplaza + aLayout[nI][2] PSAY cExt1
		nDesplaza	:=	0
	Case aLayout[nI][3] == "EXTENSO2"
		@nRow + aLayout[nI][1], nDesplaza + aLayout[nI][2] PSAY cExt2
		nDesplaza	:=	0
	Case aLayout[nI][3] == "FAVORECI"
		@nRow + aLayout[nI][1], nDesplaza + aLayout[nI][2] PSAY IIF(cBenef==NIL,SEF->EF_BENEF,cBenef)
		nDesplaza	:=	0
	Case aLayout[nI][3] == "MUNICIP"
		@nRow + aLayout[nI][1], nDesplaza + aLayout[nI][2] PSAY Trim(SA6->A6_MUN)
		nDesplaza	:=	0
	Case aLayout[nI][3] == "DIA"
		@nRow + aLayout[nI][1], nDesplaza + aLayout[nI][2] PSAY Day(SEF->EF_DATA) PICTURE "99"
		nDesplaza	:=	0
	Case aLayout[nI][3] == "MES"
		@nRow + aLayout[nI][1], nDesplaza + aLayout[nI][2] PSAY aMes[Month(SEF->EF_DATA)]
		nDesplaza	:=	0
	Case aLayout[nI][3] == "ANO"
		IF nCasas == 1
			@nRow + aLayout[nI][1], nDesplaza + aLayout[nI][2]	PSAY SubStr(Str(Year(SEF->EF_DATA),4),4,1)
		Elseif nCasas == 2
			@nRow + aLayout[nI][1], nDesplaza + aLayout[nI][2]	PSAY SubStr(Str(Year(SEF->EF_DATA),4),3,2)
		Elseif nCasas == 3
			@nRow + aLayout[nI][1], nDesplaza + aLayout[nI][2]	PSAY SubStr(Str(Year(SEF->EF_DATA),4),2,3)
		Else
			@nRow + aLayout[nI][1], nDesplaza + aLayout[nI][2]	PSAY Str(Year(SEF->EF_DATA),4)
		Endif
		nDesplaza	:=	0
	Endcase	
Next

dbSelectArea("SEF")

aLayout[1][1]	+=	nTamChq

Reclock("SEF")
SEF->EF_IMPRESS := "S"
MsUnlock( )

lRet	:=	Fr480Grav(cBanco,cAgencia,cConta,lMovBco,cFilAtual)

If mv_par06 == 1 .and. lRet
	aArea:=GetArea()
	dbSelectArea("SEF")
	DbSetOrder(1)
	If (dbSeek(cFilial+mv_par01+mv_par02+mv_par03+cNumcheq))
		MsgAlert(STR0025+cNumcheq)
		lRet:=.F.	
	EndIf
	RestArea(aArea)
Endif
Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FR480CC  � Autor � Mauricio Pequim Jr    � Data � 24.06.04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verificacao do Banco/Agencia/Conta destino do cheque CPMF  ���
���          � das perguntas 12, 13 e 14. Se encontra no SX1      		  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � FR480CC()	                                               ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Finr480                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Fr480CC(nOpcao)

Local lRet := .T.
Local aArea := GetArea()



If cPaisLoc == "BRA" .and. mv_par11 == 2 .and. ((nOpcao == 1 .and. !Empty(mv_par12) .and. !CarregaSa6(mv_par12)) .or. ;
	(nOpcao == 2 .and. !Empty(mv_par12+mv_par13) .and. !CarregaSa6(mv_par12,mv_par13)) .or. ;
	(nOpcao == 3 .and. !Empty(mv_par12+mv_par13+mv_par14) .and. !CarregaSa6(mv_par12,mv_par13,mv_par14)))	
	lRet := .F.
Endif

RestArea(aArea)

Return lRet



/*/
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Fun��o    � AjustaSx1    � Autor � Mauricio Pequim Jr.	� Data � 03/06/04 ���
�����������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica/cria SX1 a partir de matriz para verificacao          ���
�����������������������������������������������������������������������������Ĵ��
���Uso       � Siga                                                           ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
Static Function AjustaSX1()

Local _sAlias	:= Alias()
Local aCposSX1	:= {}
Local nX 		:= 0
Local lAltera	:= .F.
Local nCondicao
Local cKey		:= ""
Local aPergs	:= {}
Local nJ			:= 0
Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}
Local cPerg		:="FIN480"

AADD(aHelpPor,"Informe o c�digo do banco destino do")
AADD(aHelpPor,"cheque. Esta op��o serve para informar")
AADD(aHelpPor,"qual o banco destino do cheque de ")
AADD(aHelpPor,"transfer�ncia entre contas de mesma ")
AADD(aHelpPor,"titularidade (cheque CPMF). Este ")
AADD(aHelpPor,"par�metro n�o tem qualquer fun��o quando")
AADD(aHelpPor,"o layout do cheque for normal. Consulta")
AADD(aHelpPor,"<F3> dispon�vel")

AADD(aHelpSpa,"Informe el codigo del banco destino del")
AADD(aHelpSpa,"cheque. Esta opcion sirve para informar")
AADD(aHelpSpa,"el banco destino del cheque de")
AADD(aHelpSpa,"transferencia entre cuentas del mismo")
AADD(aHelpSpa,"titular (cheque CPMF). Este parametro")
AADD(aHelpSpa,"no tiene ninguna utilidad en el caso que")
AADD(aHelpSpa,"el layout del cheque sea Normal.")
AADD(aHelpSpa,"Consulta <F3> disponible")

AADD(aHelpEng,"Enter the check target bank code. This")
AADD(aHelpEng,"option is used to informing which check")
AADD(aHelpEng,"target bank belongs the transfer among")
AADD(aHelpEng,"accounts from the same ownership (CPMF ")
AADD(aHelpEng,"check).This parameter does not have any")
AADD(aHelpEng,"function when the check layout is")
AADD(aHelpEng,"regular. Search <F3> available")

Aadd(aPergs,{"Banco Destino (Tipo CPMF)","Banco Destino (Tipo CPMF)","Target Bank (Type CPMF)","mv_chc","C",Len(SEF->EF_BANCO),0,1,"G","Fr480cc(1)","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","S",,aHelpPor,aHelpEng,aHelpSpa})

aHelpPor := {}
aHelpSpa := {}
aHelpEng := {}

AADD(aHelpPor,"Informe o c�digo da Ag�ncia destino do")
AADD(aHelpPor,"cheque. Esta op��o serve para informar")
AADD(aHelpPor,"qual a ag�ncia destino do cheque de ")
AADD(aHelpPor,"transfer�ncia entre contas de mesma ")
AADD(aHelpPor,"titularidade (cheque CPMF). Este ")
AADD(aHelpPor,"par�metro n�o tem qualquer fun��o quando")
AADD(aHelpPor,"o layout do cheque for normal.")

AADD(aHelpSpa,"Informe el codigo de la agencia destino")
AADD(aHelpSpa,"del cheque. Esta opcion sirve para ")
AADD(aHelpSpa,"informar la agencia destino del cheque ")
AADD(aHelpSpa,"de transferencia entre cuentas del ")
AADD(aHelpSpa,"mismo titular (cheque CPMF). Este ")
AADD(aHelpSpa,"parametro no tiene ninguna utilidad en ")
AADD(aHelpSpa,"el caso que el layout del cheque sea ")
AADD(aHelpSpa,"Normal.")

AADD(aHelpEng,"Enter the check target branch code.This")
AADD(aHelpEng,"option is used to informing which check")
AADD(aHelpEng,"target branch belongs the transfer among")
AADD(aHelpEng,"accounts from the same ownership (CPMF ")
AADD(aHelpEng,"check). This parameter does not have")
AADD(aHelpEng,"any function when the check layout is")
AADD(aHelpEng,"regular.")

Aadd(aPergs,{"Agencia Destino (Tipo CPMF)","Agencia Destino (Tipo CPMF)","Target Branch (Type CPMF)","mv_chd","C",Len(SEF->EF_AGENCIA),0,1,"G","Fr480cc(2)","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","","","S",,aHelpPor,aHelpEng,aHelpSpa})

aHelpPor := {}
aHelpSpa := {}
aHelpEng := {}

AADD(aHelpPor,"Informe o c�digo da Conta destino do")
AADD(aHelpPor,"cheque. Esta op��o serve para informar")
AADD(aHelpPor,"qual a conta destino do cheque de ")
AADD(aHelpPor,"transfer�ncia entre contas de mesma ")
AADD(aHelpPor,"titularidade (cheque CPMF). Este ")
AADD(aHelpPor,"par�metro n�o tem qualquer fun��o quando")
AADD(aHelpPor,"o layout do cheque for normal.")

AADD(aHelpSpa,"Informe el codigo de la cuenta destino ")
AADD(aHelpSpa,"del cheque. Esta opcion sirve para ")
AADD(aHelpSpa,"informar la cuenta destino del cheque")
AADD(aHelpSpa,"de transferencia entre cuentas del ")
AADD(aHelpSpa,"mismo titular (cheque CPMF). Este ")
AADD(aHelpSpa,"parametro no tiene ninguna utilidad en ")
AADD(aHelpSpa,"el caso que el layout del cheque sea ")
AADD(aHelpSpa,"Normal.")

AADD(aHelpEng,"Enter the check target account code. ")
AADD(aHelpEng,"This option is used to informing which")
AADD(aHelpEng,"check target account belongs the ")
AADD(aHelpEng,"transfer among accounts from the same")
AADD(aHelpEng,"ownership (CPMF check). This parameter")
AADD(aHelpEng,"does not have any function when the")
AADD(aHelpEng,"check layout is regular.")

Aadd(aPergs,{"Conta Destino (Tipo CPMF)","Cuenta Destino (Tipo CPMF)","Target Account (Type CPMF)","mv_che","C",Len(SEF->EF_CONTA),0,1,"G","Fr480cc(3)","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","","","S",,aHelpPor,aHelpEng,aHelpSpa})


aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
	"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
	"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
	"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
	"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
	"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
	"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
	"X1_F3","X1_PYME","X1_GRPSXG","X1_HELP" }

dbSelectArea("SX1")
dbSetOrder(1)
For nX:=1 to Len(aPergs)
	lAltera := .F.
	If MsSeek(cPerg+Right(aPergs[nX][11], 2))
		If (ValType(aPergs[nX][Len(aPergs[nx])]) = "B" .And.;
				Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
			aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
			lAltera := .T.
		Endif
	Endif
	
	If ! lAltera .And. Found() .And. X1_TIPO <> aPergs[nX][5]	
		lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
	Endif	
	
	If ! Found() .Or. lAltera
		RecLock("SX1",If(lAltera, .F., .T.))
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with Right(aPergs[nX][11], 2)
		For nj:=1 to Len(aCposSX1)
			If 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
					FieldPos(AllTrim(aCposSX1[nJ])) > 0
				Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
			Endif
		Next nj
		MsUnlock()
		cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."
		
		If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
			aHelpSpa := aPergs[nx][Len(aPergs[nx])]
		Else
			aHelpSpa := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
			aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
		Else
			aHelpEng := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
			aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
		Else
			aHelpPor := {}
		Endif
		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	Endif
Next

Return