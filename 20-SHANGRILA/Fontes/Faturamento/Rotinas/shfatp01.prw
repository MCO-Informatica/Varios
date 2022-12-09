#Include "Protheus.Ch"

Static __lHasWSSTART

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | shFATP01.PRW         | AUTOR | rdSolution   | DATA | 13/02/2007 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - shFATP01()                                             |//
//|           | Utilizado para gravar o volume nos pedidos ja liberados e não   |//
//|           | faturados, conforme Pedidos Selecionados por Parametros.        |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function shFATP01()

Local aCores := {{"C9_BLCRED == '  '.And. Iif(SC9->((FieldPos('C9_BLTMS') > 0)), Empty(C9_BLTMS), .T.)",'ENABLE'    },;	//Item Liberado
	             {"C9_BLCRED == '10'.And. C9_BLEST == '10' "                                           ,'DISABLE'   },;	//Item Faturado
	             {"!C9_BLCRED== '  '.And. C9_BLCRED <> '09' .And. C9_BLCRED <> '10' "                  ,'BR_AZUL'   },;	//Item Bloqueado - Credito
	             {"C9_BLCRED == '09'.And. C9_BLCRED <> '10' "                                          ,'BR_MARROM' },;	//Item Bloqueado - Credito	
	             {"!C9_BLEST == '  '.And. C9_BLEST <> '10' "                                           ,'BR_PRETO'  },;	//Item Bloqueado - Estoque
	             {"C9_BLWMS <= '05' .And. !C9_BLWMS == '  ' "                                          ,'BR_AMARELO'},; //Item Bloqueado - WMS
	             {"Iif(SC9->((FieldPos('C9_BLTMS') > 0)), !Empty(C9_BLTMS), .F.) "                     ,'BR_LARANJA'}}	//Item Bloqueado - TMS	            
	            
Private aRotina := {{"Pesquisar ", "u_FATP01_Pes", 0 , 1},;  //  "Pesquisar"		
					{"Visualizar", "u_FATP01_Vis", 0 , 2},;  //  "Visualizar"
					{"Alterar   ", "u_FATP01_Alt", 0 , 6},;  //  "Alterar"
					{"Varios    ", "u_FATP01_Alt", 0 , 6},;  //  "Autom tico"
					{"Legenda   ", "u_FATP01_Leg", 0 , 0} }  //  "Legenda"
					
Private cCadastro := "Alteração Volume dos Pedidos de Venda"
Private cAliasSC9 := "QRYSC9"

Private _aCpoSC5 := {"C5_VOLUME1","C5_FILIAL","C5_NUM","C5_TIPO","C5_CLIENTE","C5_LOJACLI","C5_LOJAENT",;
                   "A1_NOME","C5_DTENTR","C5_EMISSAO","C5_NOTA"}
                   
aSx3Box  := RetSx3Box( Posicione('SX3', 2, 'C5_TIPO', 'X3CBox()' ),,, 1 )

aCpoBrw  := {}
aCposBrw :=  {{ "Filial"      , {|| TRB->C5_FILIAL} , "C", 18 , 0, "@!"   },; 
              { "Numero"      , {|| TRB->C5_NUM}    , "C", 06 , 0, "@!"   },; 
              { "Tipo Pedido" , {|| TRB->C5_TIPO}   , "C", 25 , 0, "@!"   },;
              { "Cliente"     , {|| TRB->C5_CLIENTE}, "C", 06 , 0, "@!"   },;
              { "Loja Cliente", {|| TRB->C5_LOJACLI}, "C", 02 , 0, "@!"   },;
              { "Loja Entrega", {|| TRB->C5_LOJAENT}, "C", 02 , 0, "@!"   },;
              { "Nome"        , {|| TRB->A1_NOME}   , "C", 40 , 0, "@!"   },;
              { "Data Entrega", {|| TRB->C5_DTENTR} , "D", 10 , 0, "@D"   },;              
              { "Data Emissao", {|| TRB->C5_EMISSAO}, "D", 10 , 0, "@D"   },;
              { "Volume"      , {|| TRB->C5_VOLUME1}, "N", 05 , 0, "99999"},;
              { "Nota Fiscal" , {|| TRB->C5_NOTA}   , "C", 06 , 0, "@!"   },;
              { "Bloq.Credito", {|| TRB->C9_BLCRED} , "C", 02 , 0, "@!"   },;
              { "Bloq.Estoque", {|| TRB->C9_BLEST}  , "C", 02 , 0, "@!"   },;
              { "Bloq.TMS"    , {|| TRB->C9_BLTMS}  , "C", 02 , 0, "@!"   },;
              { "Bloq.WMS"    , {|| TRB->C9_BLWMS}  , "C", 02 , 0, "@!"   }}
              
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta arquivo de trabalho para armazenar os ACB que possuem keywords   ³				
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aStruct  := {}
AAdd( aStruct, { "C5_FILIAL" , "C", 18 , 0 } )
AAdd( aStruct, { "C5_NUM"    , "C", 06 , 0 } )
AAdd( aStruct, { "C5_TIPO"   , "C", 25 , 0 } )
AAdd( aStruct, { "C5_CLIENTE", "C", 06 , 0 } )
AAdd( aStruct, { "C5_LOJACLI", "C", 02 , 0 } )
AAdd( aStruct, { "C5_LOJAENT", "C", 02 , 0 } )
AAdd( aStruct, { "A1_NOME"   , "C", 40 , 0 } )
AAdd( aStruct, { "C5_DTENTR" , "D", 10 , 0 } )
AAdd( aStruct, { "C5_EMISSAO", "D", 10 , 0 } )
AAdd( aStruct, { "C5_VOLUME1", "N", 05 , 0 } )
AAdd( aStruct, { "C5_NOTA"   , "C", 06 , 0 } ) 
AAdd( aStruct, { "C9_BLCRED" , "C", 02 , 0 } )
AAdd( aStruct, { "C9_BLEST"  , "C", 02 , 0 } )
AAdd( aStruct, { "C9_BLTMS"  , "C", 02 , 0 } )
AAdd( aStruct, { "C9_BLWMS"  , "C", 02 , 0 } )

// Open Arquivo de Trabalho
//-------------------------
cOrdTrab := "Substr(C5_FILIAL,1,2)+C5_NUM"
cArqTrab := CriaTrab( aStruct, .T. ) 
dbUseArea(.T.,,cArqTrab,"TRB", if(.F. .OR. .F., !.F., NIL), .F. )				
IndRegua( "TRB", cArqTrab, "C5_NUM",,,"Selecionando Registros..." ) 	 

dbSelectArea("TRB")			
dbSetOrder(01)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega Arquivo temporario com as informacoes do SX5.                  ³				
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT DISTINCT(C9_PEDIDO) C9_PEDIDO,"
cQuery += " C5_FILIAL, C5_NUM, C5_TIPO, C5_CLIENTE, C5_LOJACLI, C5_LOJAENT, A1_NOME, C5_DTENTR, C5_EMISSAO,"
cQuery += " C5_VOLUME1, C5_NOTA, C9_BLCRED, C9_BLEST, C9_BLTMS, C9_BLWMS " 
cQuery += "FROM "
cQuery += RetSqlName("SC9") + " SC9, "
cQuery += RetSqlName("SC5") + " SC5, " 
cQuery += RetSqlName("SA1") + " SA1 "
cQuery += "WHERE"
cQuery += " SC9.C9_BLEST = '  ' AND"
cQuery += " SC9.C9_BLCRED = '  ' AND"
cQuery += " SC9.D_E_L_E_T_ <> '*' AND"
cQuery += " SC5.C5_NUM = SC9.C9_PEDIDO AND"
cQuery += " SC5.D_E_L_E_T_ <> '*' AND"   
cQuery += " SA1.A1_COD = SC5.C5_CLIENTE AND"
cQuery += " SA1.A1_LOJA = SC5.C5_LOJACLI AND"
cQuery += " SA1.D_E_L_E_T_ <> '*'"
cQuery += " ORDER BY SC5.C5_NUM"
cQuery := ChangeQuery(cQuery)
	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC9,.T.,.T.)
		
TCSetField(cAliasSC9,"C5_DTENTR ","D",10,0)
TCSetField(cAliasSC9,"C5_EMISSAO","D",10,0)
TCSetField(cAliasSC9,"C5_VOLUME1","N",05,0)

// Carrega Arquivo de Trabalho
//----------------------------
dbSelectArea(cAliasSC9)
(cAliasSC9)->( dbGotop() )

While !(cAliasSC9)->(Eof())

	TRB->( RecLock("TRB",.T.) )
		TRB->C5_FILIAL  := (cAliasSC9)->C5_FILIAL + "-" + Alltrim(SM0->M0_FILIAL)
		TRB->C5_NUM     := (cAliasSC9)->C5_NUM
		TRB->C5_TIPO    := aSx3Box[Ascan(aSx3Box,{|x| x[2] == (cAliasSC9)->C5_TIPO})][3]
		TRB->C5_CLIENTE := (cAliasSC9)->C5_CLIENTE
		TRB->C5_LOJACLI := (cAliasSC9)->C5_LOJACLI
		TRB->C5_LOJAENT := (cAliasSC9)->C5_LOJAENT
		TRB->A1_NOME    := (cAliasSC9)->A1_NOME
		TRB->C5_DTENTR  := (cAliasSC9)->C5_DTENTR
		TRB->C5_EMISSAO := (cAliasSC9)->C5_EMISSAO
		TRB->C5_VOLUME1 := (cAliasSC9)->C5_VOLUME1
		TRB->C5_NOTA    := (cAliasSC9)->C5_NOTA
		TRB->C9_BLCRED  := (cAliasSC9)->C9_BLCRED
		TRB->C9_BLEST   := (cAliasSC9)->C9_BLEST
		TRB->C9_BLTMS   := (cAliasSC9)->C9_BLTMS
		TRB->C9_BLWMS   := (cAliasSC9)->C9_BLWMS
	TRB->( MsUnLock() )

	(cAliasSC9)->( dbSkip() )
	
Enddo

(cAliasSC9)->( dbCloseArea() )

dbSelectArea("TRB")
TRB->( dbSetOrder(01) )
TRB->( dbGotop() )

//cAlias := "TRB"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Endereca a funcao de BROWSE                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
mBrowse( 7, 4, 20, 74, "TRB", aCposBrw,,,,,aCores)

DbSelectArea("TRB")
DbCloseArea()
Ferase(cArqTrab)

Return(.T.)



User Function FATP01_Alt(cAlias,nReg,nOpc)

//+----------------------------------------------------------------------------
//| Atribuicao de variaveis
//+----------------------------------------------------------------------------
//Local cFiltro := ""
//Local cKey    := ""
//Local cArq    := ""
//Local cMsg    := ""
//Local cDesc1  := "Este programa tem o objetivo de trazer os pedidos de venda liberados e não  "
//Local cDesc2  := "faturados conforme preenchimento dos parametros, para ser informado o volume"
//Local cDesc3  := ""

Local nIndex  := 0
Local nOpcao  := 0
Local nCnt    := 0
Local nUsado  := 0

Local aArea    := TRB->( GetArea() )
//Local aSay    := {}
//Local aButton := {}
Local aCpos   := {}
Local aCampos := {}
Local _aAlter := {}

Local aBackRot := aClone(aRotina)

//Local aSize		:= MsAdvSize(,.F.,430)
//Local aObjects 	:= {} 
//Local aPosObj  	:= {} 
//Local aSizeAut 	:= MsAdvSize()
//
//Aadd( aObjects, { 010, 010, .T., .T. } )
//Aadd( aObjects, { 005, 070, .T., .T. } )
//aInfo 	:= { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 } 
//aPosObj	:= MsObjSize( aInfo, aObjects, .F. ) 

Private cPerg       := "SHFT01"
Private cArquivo    := ""
Private cMarca      := ""

Private cAliasSC5   := "QRYSC5"

Private nTotal      := 0

Private aHeader     := {}
Private aCols       := {}

aRotina := {{"", "", 0,1 },;	//"Pesquisar"
	        {"", "", 0,2 },;	//"Visualizar"
			{"", "", 0,3 },;	//"Incluir"
			{"", "", 0,4 },;	//"Alterar"
			{"", "", 0,5 },;	//"Excluir"
			{"", "", 0,6 } }	//"Excluir"					

//+----------------------------------------------------------------------------
//| Cria as perguntas em SX1
//+----------------------------------------------------------------------------
CriaSX1()

//+----------------------------------------------------------------------------
//| Monta tela de paramentos para usuario, se cancelar sair
//+----------------------------------------------------------------------------
If nOpc == 4
	If !Pergunte(cPerg,.T.)
   		Return Nil
	Endif
Else
	mv_par01 := TRB->C5_NUM
	mv_par02 := TRB->C5_NUM	
	mv_par03 := TRB->C5_DTENTR
	mv_par04 := TRB->C5_DTENTR
	mv_par05 := TRB->C5_EMISSAO
	mv_par06 := TRB->C5_EMISSAO
Endif	

mv_par02 := IIf(Empty(mv_par02),"ZZZZZZ",mv_par02)
mv_par04 := IIf(Empty(mv_par04),ctod("31/12/9999"),mv_par04)
mv_par06 := IIf(Empty(mv_par06),ctod("31/12/9999"),mv_par06)

//+----------------------------------------------------------------------------
//| Seleciona os Registros conforme os Parametros
//+----------------------------------------------------------------------------
MONTA_HEADER()

//+----------------------------------------------------------------------------
//| Seleciona os Registros conforme os Parametros
//+----------------------------------------------------------------------------
MONTA_ACOLS()

//+----------------------------------------------------------------------------
//| Seleciona os Registros conforme os Parametros
//+----------------------------------------------------------------------------
nOpcA := 0
nOpcX := 6

_aAlter := { "C5_VOLUME1" }

DEFINE MSDIALOG oDlg TITLE cCadastro From 000,000 To 549,999 OF oMainWnd Pixel

oGet := MSGetDados():New(15,02,275,499,nOpcX,"AllWaysTrue","AllWaysTrue","",.F.,_aAlter)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,oDlg:End()},{||nOpcA:=0,oDlg:End()}) Centered

If nOpcA == 1
	FATP01_Grv()
Endif

aRotina := aClone(aBackRot)
RestArea(aArea)

Return()





Static Function MONTA_HEADER()

//Local _aCpoSC5 := {"C5_VOLUME1","C5_FILIAL","C5_NUM","C5_TIPO","C5_CLIENTE","C5_LOJACLI","C5_LOJAENT",;
//                   "A1_NOME","C5_DTENTR","C5_EMISSAO","C5_NOTA"}
                   
Local nUsado   := 0                   

aHeader := {}

SX3->( dbSetOrder(2) )
For nI := 1 To Len(_aCpoSC5)

  	SX3->( dbSeek(_aCpoSC5[nI]) )

	nUsado++
	
	_nTamanho := SX3->X3_TAMANHO
	
	If Alltrim(SX3->X3_CAMPO) == "C5_FILIAL"
		_nTamanho := 18
	ElseIf Alltrim(SX3->X3_CAMPO) == "C5_TIPO"
		_nTamanho := 25
	Endif		
	
	AADD(aHeader,{ X3Titulo()       ,;
	               SX3->X3_CAMPO    ,;
    	           SX3->X3_PICTURE  ,;
        	       _nTamanho        ,;
            	   SX3->X3_DECIMAL  ,;
	               SX3->X3_VALID    ,;
	               SX3->X3_USADO    ,;
    	           SX3->X3_TIPO     ,;
        	       SX3->X3_ARQUIVO  ,;
            	   SX3->X3_CONTEXT  })  	
		            	   
Next nI

Return()


Static Function MONTA_ACOLS()

Local nCnt   := 0
Local nUsado := 0

//Local _aCpoSC5 := {"C5_VOLUME1","C5_FILIAL","C5_NUM","C5_TIPO","C5_CLIENTE","C5_LOJACLI","C5_LOJAENT",;
//                   "A1_NOME","C5_DTENTR","C5_EMISSAO","C5_NOTA"}

aCols := {}

TRB->( dbSetOrder(01) )
TRB->( dbSeek(mv_par01,.T.) )

While TRB->C5_NUM <= mv_par02 .AND. !TRB->(Eof())

	If TRB->C5_NUM > mv_par02
		Exit
	Endif
	
	If DTOS(TRB->C5_DTENTR) < DTOS(mv_par03) .OR. DTOS(TRB->C5_DTENTR) > DTOS(mv_par04)	
		TRB->( dbSkip() )
		Loop
	Endif
	
	If DTOS(TRB->C5_EMISSAO) < DTOS(mv_par05) .OR. DTOS(TRB->C5_EMISSAO) > DTOS(mv_par06)
		TRB->( dbSkip() )
		Loop
	Endif		

	aAdd( aCOLS, Array(Len(aHeader)+1))
   
	nCnt++
	nUsado := 0
	
	SX3->( dbSetOrder(2) )
	
	For nI := 1 To Len(_aCpoSC5)

		SX3->( dbSeek(_aCpoSC5[nI]) )
		
		nUsado++

		cVarTemp := "TRB->"+(SX3->X3_CAMPO)

		If SX3->X3_CONTEXT # "V"

			If Alltrim(cVarTemp) == "TRB->C5_TIPO"
				aCOLS[nCnt][nUsado] := Substr(&cVarTemp,1,1)
			Else	
				aCOLS[nCnt][nUsado] := &cVarTemp
			Endif	

		ElseIF SX3->X3_CONTEXT == "V"
		
			aCOLS[nCnt][nUsado] := CriaVar(AllTrim(SX3->X3_CAMPO))
			
		Endif		
		
	Next nI
	
	aCOLS[nCnt][nUsado+1] := .F.
	
	TRB->( dbSkip() )

Enddo

Return()


///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | MarkBrowse.prw       | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - CriaSX1()                                              |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Cria o grupo de perguntas se caso nao existir                   |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
Static Function CriaSx1()

Local nX   := 0
Local nY   := 0

Local aReg := {}

//+--------------------------------------------------------+
//| Parametros utilizado no programa                       |
//+--------------------------------------------------------+
//| mv_par01 - Do  Pedido         ? 999999                 |
//| mv_par02 - Ate Pedido         ? 999999                 |
//| mv_par03 - Da  Entrega        ? 99/99/9999             |
//| mv_par04 - Ate Entrega        ? 99/99/9999             |
//| mv_par05 - Da  Emissao        ? 99/99/9999             |
//| mv_par05 - Da  Emissao        ? 99/99/9999             |
//+--------------------------------------------------------+

aAdd(aReg,{cPerg,"01","Do  Pedido     ?     ","mv_ch1","C", 06,00,00,"G","                    ","mv_par01","","","","","","","","","","","","","","","SC5"}) 
aAdd(aReg,{cPerg,"02","Até Pedido     ?     ","mv_ch2","C", 06,00,00,"G","(mv_par02>=mv_par01)","mv_par02","","","","","","","","","","","","","","","SC5"}) 
aAdd(aReg,{cPerg,"03","Da  Dt.Entrega ?     ","mv_ch3","D", 08,00,00,"G","                    ","mv_par03","","","","","","","","","","","","","","",""   })
aAdd(aReg,{cPerg,"04","Até Dt.Entrega ?     ","mv_ch4","D", 08,00,00,"G","(mv_par04>=mv_par03)","mv_par04","","","","","","","","","","","","","","",""   })
aAdd(aReg,{cPerg,"05","Da  Dt.Emissao ?     ","mv_ch5","D", 08,00,00,"G","                    ","mv_par05","","","","","","","","","","","","","","",""   })
aAdd(aReg,{cPerg,"06","Até Dt.Emissao ?     ","mv_ch6","D", 08,00,00,"G","(mv_par06>=mv_par05)","mv_par06","","","","","","","","","","","","","","",""   })
aAdd(aReg,{"X1_GRUPO","X1_ORDEM","X1_PERGUNT","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID","X1_VAR01","X1_DEF01","X1_CNT01","X1_VAR02","X1_DEF02","X1_CNT02","X1_VAR03","X1_DEF03","X1_CNT03","X1_VAR04","X1_DEF04","X1_CNT04","X1_VAR05","X1_DEF05","X1_CNT05","X1_F3"})

dbSelectArea("SX1")
dbSetOrder(1)

For nY:=1 to Len(aReg)-1
	If !dbSeek(aReg[nY,1]+aReg[nY,2])
		RecLock("SX1",.T.)
		For nX:=1 to Len(aReg[nY])
			FieldPut(FieldPos(aReg[Len(aReg)][nX]),aReg[nY,nX])
		Next nX
		MsUnlock()
	EndIf
Next nY

Return()


User Function FATP01_Vis(cAlias,nReg,nOpc)

Local aArea    := GetArea()
Local aHeadSC6 := {}
Local aCpos1   := {"C6_QTDVEN ","C6_QTDLIB"}
Local aCpos2   := {}
Local aBackRot := aClone(aRotina)
Local aPosObj  := {}
Local aObjects := {}
Local aSize    := {}
Local aPosGet  := {}
Local aInfo    := {}

Local lContinua:= .T.
Local lGrade   := MaGrade()
Local lQuery   := .F.
Local lHeadSC6 := .F.   
Local lFreeze   := (SuperGetMv("MV_PEDFREZ",.F.,0) <> 0)

Local nGetLin  := 0
Local nOpcA    := 0
Local nUsado   := 0
Local nTotPed  := 0
Local nTotDes  := 0
Local nCntFor  := 0
Local nNumDec  := TamSX3("C6_VALOR")[2]
Local nColFreeze:= SuperGetMv("MV_PEDFREZ",.F.,0)

Local cArqQry  := ""
Local cCadastro:= OemToAnsi("Alteração Volume dos Pedidos de Venda")
Local oGetd
Local oSAY1
Local oSAY2
Local oSAY3
Local oSAY4
Local oDlg                                        

#IFDEF TOP
	Local aStruSC6 := {}       
	Local cQuery   := ""
#ENDIF 

DEFAULT __lHasWSSTART := FindFunction("WS_HEADSC6")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a Variaveis Privates.                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aTrocaF3  := {}
PRIVATE aTELA[0][0],aGETS[0]
PRIVATE aHeader	  := {}
PRIVATE aCols	  := {}
PRIVATE aColsGrade:= {}
PRIVATE aHeadGrade:= {}
PRIVATE aHeadFor  := {}
PRIVATE aColsFor  := {}
PRIVATE N         := 1

If Type("Inclui") == "U"
	Inclui := .F.
	Altera := .F.
EndIf  

//Pergunte("MTA410",.F.)

If ( lGrade )
	aRotina[nOpc][4] := 6
EndIf

cAlias := "SC5"

dbSelectArea("SC6")
SC6->( dbSetOrder(01) )
SC6->( dbSeek(Substr(TRB->C5_FILIAL,1,2) + TRB->C5_NUM) )

dbSelectArea("SC5")
SC5->( dbSetOrder(01) )
SC5->( dbSeek(Substr(TRB->C5_FILIAL,1,2) + TRB->C5_NUM) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a Variaveis da Enchoice.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RegToMemory( "SC5", .F., .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do aHeader                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lHeadSC6 := .f.

If __lHasWSSTART
	lHEADSC6 := WS_HEADSC6(.t.,cEmpAnt,@aHeadSC6)
EndIf

If !lHEADSC6
	dbSelectArea("SX3")
	dbSetOrder(1)    
	MsSeek("SC6")
	While ( !Eof() .And. (SX3->X3_ARQUIVO == "SC6") )
		
		If ( X3USO(SX3->X3_USADO) .And.;
				!(	Trim(SX3->X3_CAMPO) == "C6_NUM" ) 	.And.;
				Trim(SX3->X3_CAMPO) <> "C6_QTDEMP" 	.And.;
				Trim(SX3->X3_CAMPO) <> "C6_QTDENT" 	.And.;
				cNivel >= SX3->X3_NIVEL )
			
			nUsado++
			
			Aadd(aHeader,{ TRIM(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_ARQUIVO,;
				SX3->X3_CONTEXT } )
		
		EndIf
		
		dbSelectArea("SX3")
		dbSkip()
		
	EndDo
	
	If __lHasWSSTART
		WS_HEADSC6(.f.,cEmpAnt,aHeader)
	EndIf 	
	
Else

	aHeader := aClone( aHeadSC6 ) 	
	nUsado  := Len( aHeader ) 

EndIf 	
	
For nCntFor := 1 To Len(aHeader)
	If aHeader[nCntFor][8] == "M"
		aadd(aCpos1,aHeader[nCntFor][2])
	EndIf
Next nCntFor

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do aCols                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC6")
dbSetOrder(1)

#IFDEF TOP
	If Ascan(aHeader,{|x| x[8] == "M"}) == 0
		aStruSC6:= SC6->(dbStruct())
		cArqQry := "SC6"
		lQuery  := .T.
		cQuery := "SELECT * "
		cQuery += "FROM "+RetSqlName("SC6")+" SC6 "
		cQuery += "WHERE SC6.C6_FILIAL='"+xFilial("SC6")+"' AND "
		cQuery += "SC6.C6_NUM='"+SC5->C5_NUM+"' AND "
		cQuery += "SC6.D_E_L_E_T_<>'*' "
		cQuery += "ORDER BY "+SqlOrder(SC6->(IndexKey()))

		cQuery := ChangeQuery(cQuery)

		dbSelectArea("SC6")
		dbCloseArea()
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArqQry,.T.,.T.)
		For nCntFor := 1 To Len(aStruSC6)
			If ( aStruSC6[nCntFor,2]<>"C" )
				TcSetField(cArqQry,aStruSC6[nCntFor,1],aStruSC6[nCntFor,2],aStruSC6[nCntFor,3],aStruSC6[nCntFor,4])
			EndIf
		Next nCntFor
	Else

#ENDIF

	cArqQry := "SC6"
	MsSeek(xFilial("SC6")+SC5->C5_NUM)
	#IFDEF TOP
	EndIf
	#ENDIF

While ( !Eof() .And. (cArqQry)->C6_FILIAL == xFilial("SC6") .And.;
		(cArqQry)->C6_NUM 	== SC5->C5_NUM )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se este item foi digitada atraves de uma    ³
	//³ grade, se for junta todos os itens da grade em uma   ³
	//³ referencia , abrindo os itens so quando teclar enter ³
	//³ na quantidade                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( (cArqQry)->C6_GRADE == "S" .And. lGrade )
		a410Grade(.F.,,cArqQry)
	Else
		AADD(aCols,Array(Len(aHeader)))
		For nCntFor:=1 To Len(aHeader)
			If ( aHeader[nCntFor,10] <>  "V" )
				aCOLS[Len(aCols)][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor,2]))
			Else			
				aCOLS[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor,2])
			EndIf
		Next nCntFor
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Mesmo nao sendo um item digitado atraves de grade e' necessa-³
		//³ rio criar o Array referente a este item para controle da     ³
		//³ grade                                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		MatGrdMont(Len(aCols))
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Efetua a Somatoria do Rodape                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nTotPed	+= (cArqQry)->C6_VALOR
	If ( (cArqQry)->C6_PRUNIT = 0 )
		nTotDes	+= (cArqQry)->C6_VALDESC
	Else
		nTotDes += A410Arred(((cArqQry)->C6_PRUNIT*(cArqQry)->C6_QTDVEN),"C6_VALOR")-A410Arred(((cArqQry)->C6_PRCVEN*(cArqQry)->C6_QTDVEN),"C6_VALOR")
	EndIf                 
	
	dbSelectArea(cArqQry)
	dbSkip()
EndDo
nTotPed  -= M->C5_DESCONT
nTotDes  += M->C5_DESCONT
nTotDes  += A410Arred(nTotPed*M->C5_PDESCAB/100,"C6_VALOR")
nTotPed  -= A410Arred(nTotPed*M->C5_PDESCAB/100,"C6_VALOR")
If ( lQuery )
	dbSelectArea(cArqQry)
	dbCloseArea()
	ChkFile("SC6",.F.)
	dbSelectArea("SC6")
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta o array com as formas de pagamento       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Ma410MtFor(@aHeadFor,@aColsFor)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso nao ache nenhum item , abandona rotina.         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( Len(aCols) == 0 )
	Help(" ",1,"A410SEMREG")
	lContinua := .F.
EndIf

If ( lContinua )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz o calculo automatico de dimensoes de objetos     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MsAdvSize()
	aObjects := {}
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 015, .t., .f. } )

	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )

	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,;
		{{003,033,160,200,240,263}} )

	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Estabelece a Troca de Clientes conforme o Tipo do Pedido de Venda      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( M->C5_TIPO $ "DB" )
		aTrocaF3 := {{"C5_CLIENTE","SA2"}}
	Else
		aTrocaF3 := {}
	EndIf
	EnChoice( cAlias, nReg, nOpc, , , , , aPosObj[1],aCpos2,3,,,"A415VldTOk")
	nGetLin := aPosObj[3,1]
	@ nGetLin,aPosGet[1,1]  SAY OemToAnsi(IIF(M->C5_TIPO$"DB","Fornec.:","Cliente: ")) SIZE 020,09 PIXEL	//"Fornec.:"###"Cliente: "
	@ nGetLin,aPosGet[1,2]  SAY oSAY1 VAR Space(40)						SIZE 120,09 PICTURE "@!" OF oDlg PIXEL
	@ nGetLin,aPosGet[1,3]  SAY OemToAnsi("Total :")						SIZE 020,09 OF oDlg PIXEL	//"Total :"
	@ nGetLin,aPosGet[1,4]  SAY oSAY2 VAR 0 PICTURE TM(0,16,nNumDec)		SIZE 050,09 OF oDlg	PIXEL
	@ nGetLin,aPosGet[1,5]  SAY OemToAnsi("Desc. :")						SIZE 020,09 OF oDlg PIXEL	//"Desc. :"
	@ nGetLin,aPosGet[1,6]  SAY oSAY3 VAR 0 PICTURE TM(0,16,nNumDec)		SIZE 050,09 OF oDlg	PIXEL RIGHT
	@ nGetLin+10,aPosGet[1,5] SAY OemToAnsi("=")							SIZE 020,09 OF oDlg PIXEL
	@ nGetLin+10,aPosGet[1,6] SAY oSAY4 VAR 0								SIZE 050,09 PICTURE TM(0,16,nNumDec) OF oDlg PIXEL RIGHT
	oDlg:Cargo	:= {|c1,n2,n3,n4| oSay1:SetText(c1),;
		oSay2:SetText(n2),;
		oSay3:SetText(n3),;
		oSay4:SetText(n4) }
	oGetd   := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,,,"",,aCpos1,nColFreeze,,"A410FldOk",,,,,,lFreeze)	
	Ma410Rodap(oGetd,nTotPed,nTotDes)
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,oDlg:End()},{||oDlg:End()},nOpc)
EndIf

aRotina := aClone(aBackRot)

RestArea(aArea)

Return()


User Function FATP01_Leg()	//	(cAlias,nReg,nOpc)

Local aArea    := TRB->(GetArea())
Local aLegenda := {}

Aadd(aLegenda, {"ENABLE"    ,"Item Liberado"           }) //"Item Liberado"
Aadd(aLegenda, {"DISABLE"   ,"Item Faturado"           }) //"Item Faturado"
Aadd(aLegenda, {"BR_MARROM" ,"Rejeitados"              }) //"Rejeitados"
Aadd(aLegenda, {"BR_AZUL"   ,"Item Bloqueado - Credito"}) //"Item Bloqueado - Credito"
Aadd(aLegenda, {"BR_PRETO"  ,"Item Bloqueado - Estoque"}) //"Item Bloqueado - Estoque"
Aadd(aLegenda, {"BR_AMARELO","Bloqueado - WMS"         }) //"Bloqueado - WMS"
Aadd(aLegenda, {"BR_LARANJA","Bloqueado - TMS"         }) //"Bloqueado - TMS"

BrwLegenda(cCadastro, "Legenda", aLegenda)

RestArea(aArea)

Return()


Static Function FATP01_Grv()

For nI := 1 TO Len(aCols)   

	//Grava Volume no TRB
	//-------------------
	TRB->( dbSetOrder(01) )
	If TRB->( dbSeek(gdFieldGet("C5_NUM",nI)) )
		TRB->( RecLock("TRB",.F.) )
			TRB->C5_VOLUME1 := gdFieldGet("C5_VOLUME1",nI)
		TRB->( MsUnLock() )	
	Endif	

    //Grava Volume no SC5
    //-------------------
	SC5->( dbSetOrder(01) )
	If SC5->( dbSeek( Substr(gdFieldGet("C5_FILIAL",nI),1,2) + gdFieldGet("C5_NUM",nI) ) )
		SC5->( RecLock("SC5",.F.) )
			SC5->C5_VOLUME1 := gdFieldGet("C5_VOLUME1",nI)
		SC5->( MsUnLock() )	
	Endif
	
	// Grava TES nos Itens Liberados
	//------------------------------
	SC9->( dbSetOrder(01) )
	If SC9->( dbSeek( Substr(gdFieldGet("C5_FILIAL",nI),1,2) + gdFieldGet("C5_NUM",nI) ) )
		
		While !SC9->(Eof()) .AND. SC9->C9_FILIAL + SC9->C9_PEDIDO == ;
		                          Substr(gdFieldGet("C5_FILIAL",nI),1,2) + gdFieldGet("C5_NUM",nI)
		                          
			SC9->( RecLock("SC9",.F.) )
				SC9->C9_X_TES := Posicione("SC6",1,xFilial("SC9")+SC9->(C9_PEDIDO+C9_ITEM+C9_PRODUTO),"C6_TES")
				SC9->C9_X_VOL := IIf(gdFieldGet("C5_VOLUME1",nI) > 0, '1', '2')
			SC9->( MsUnLock() )
			
			SC9->( dbSkip() )
		                          
		Enddo
	
	Endif 
	
Next nI

Return()




User Function FATP01_Pes(cAlias,nReg,nOpc)

local nOpcA
local oDlg, oOrdem, oChave, oBtOk, oBtCan, oBtPar
local cOrdem
local cChave	:= Space(255)
local aOrdens	:= {}
local aBlocks	:= {}
local nOrder	:= 1

//SIX->( dbSetOrder(1) )
//SIX->( dbSeek(cAlias) )
//
//while SIX->( !eof() .and. INDICE == cAlias )
//	
//	aAdd( aOrdens, Capital( SIXDescricao() ) )
//	aAdd( aBlocks, &("{ || "+cAlias+"->(dbSetOrder("+Str(nOrder,2,0)+")), "+cAlias+"->(dbSeek(xFilial('"+cAlias+"')+Rtrim(cChave))) }") )
//	
//	nOrder++
//	
//	SIX->( dbSkip() )
//end

aAdd( aOrdens, Capital( "Nr.Pedido" ) )
aAdd( aBlocks, &("{ || "+cAlias+"->(dbSetOrder(1)), "+cAlias+"->(dbSeek(Rtrim(cChave))) }") )
//aAdd( aBlocks, &("{ || "+cAlias+"->(dbSetOrder(1)), "+cAlias+"->(dbSeek(xFilial('"+cAlias+"')+Rtrim(cChave))) }") )

define msDialog oDlg title "Pesquisar" from 00,00 TO 100,500 pixel

@ 005, 005 combobox oOrdem var cOrdem items aOrdens size 210,08 of oDlg pixel
@ 020, 005 msget oChave var cChave size 210,08 of oDlg pixel

define sButton oBtOk  from 05,218 type 1 action (nOpcA := 1, oDlg:End()) enable of oDlg pixel
define sButton oBtCan from 20,218 type 2 action (nOpcA := 0, oDlg:End()) enable of oDlg pixel
define sButton oBtPar from 35,218 type 5 when .F. of oDlg pixel

activate msdialog oDlg center

if nOpcA == 1
	
	for nOrder := 1 to len(aOrdens)
		if aOrdens[ nOrder ] == cOrdem
			Eval( aBlocks[ nOrder ] )
		endif
	next i
	
endif

Return


