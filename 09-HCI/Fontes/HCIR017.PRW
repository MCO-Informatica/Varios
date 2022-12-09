#INCLUDE "rwmake.ch"       
#INCLUDE "Protheus.Ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ HCIR017  º Autor ³Darlan Angelo F. Maciel º Data ³  30/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao para selecionar cliente, pedido e itens para impressao  º±±
±±º          ³ de minuta de despacho                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³HCI - Relatorio de Emissao de Minuta                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function HCIR017

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis do List Mark               				                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oDlg
Local cVar     := ""
Local cTit     := "Lista de Pedido"
Local lMark    := .T.
Local oOk      := LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
Local oNo      := LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO
Local oChk1
Local oChk2
Local oTPane1
Local oTPane2     
Local oBtnOK
Local oBtnCancel
Local nOpcA   := 0
Local nQtdReg := 0 // variavel relatorio
Private lChk1 := .F.
Private lChk2 := .F.
Private oLbx
Private aVetor := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis do relatorio               				                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private nLargura   := 132
Private nTamanho   := "M"
Private nomeprog   := "HCIR017" 
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "HCIR017" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString    := "SC6"
Private cPerg      
Private aNreg      := {}
Private _nPos      := 0
Private _cNumMinuta := alltrim(GETMV("ES_MINUTA")) // NUMERO DA MINUTA
Private _cNumPed   := ""
Private _cFil
Private _cCli
Private _cLoja
Private _cPref
Private _cTit
Private _cMsgCert
Private _lOpc := .F. // .F.=Impressao / .T.=Reimpressao

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pergunta se e reimpressao de minuta ou minuta nova                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if MsgBox("D E S E J A    R E I M P R E S S Ã O    D E    M I N U T A ???","ATENÇÃO","YESNO")
	_lOpc := .T. //reimpressao
else
	_lOpc := .F. //impressao	
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define se pergunta sera para impressao ou reimpressao               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cPerg := IIF(_lOpc,"HCI17B","HCI017")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem e atribuicao das perguntas... 				                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if _lOpc //reimpressao
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ mv_par01 - Minuta        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AjustaSx1(cPerg)
	if !Pergunte(cPerg,.T.)
		return
	endif
else  //impressao
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ mv_par01 - Cliente       ³
	//³ mv_par02 - Loja          ³
	//³ mv_par03 - Pedido de     ³
	//³ mv_par04 - Pedido até    ³
	//³ mv_par05 - Periodo de    ³
	//³ mv_par06 - Periodo até   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AjustaSx1(cPerg)
	if !Pergunte(cPerg,.T.)
		return
	endif
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da query principal...(TRB)      		                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT "
	cQuery += "C6_NUM,C6_ITEM,C6_PRODUTO,C6_DESCRI,C6_MINUTA,C6_CLI,C6_LOJA, "
	cQuery += "D2_UM,D2_QUANT,D2_PRCVEN,D2_TOTAL,D2_VALIPI,D2_IPI,D2_VALBRUT,D2_DOC,D2_SERIE, "
	cQuery += "F2_DUPL,F2_PREFIXO,F2_EMISSAO, "
	cQuery += "A1_NOME,A1_NREDUZ,A1_END,A1_MUN,A1_EST,A1_BAIRRO,A1_CEP,A1_DDD,A1_TEL,A1_FAX,A1_CGC,A1_INSCR, "
	cQuery += "C5_MSGCERT "

cQuery += "FROM " + RetSqlName("SC6") + " SC6 "

cQuery += "INNER JOIN " + RetSqlName("SC5") + " SC5 ON "
	cQuery += "SC6.C6_CLI = SC5.C5_CLIENTE AND "
	cQuery += "SC6.C6_LOJA = SC5.C5_LOJACLI AND "
	cQuery += "SC6.C6_NUM = SC5.C5_NUM AND "
	cQuery += "SC6.C6_FILIAL = SC5.C5_FILIAL " 

cQuery += "INNER JOIN " + RetSqlName("SD2") + " SD2 ON "
	cQuery += "SC6.C6_ITEM = SD2.D2_ITEMPV AND "
	cQuery += "SC6.C6_PRODUTO = SD2.D2_COD AND "
	cQuery += "SC6.C6_CLI = SD2.D2_CLIENTE AND "
	cQuery += "SC6.C6_LOJA = SD2.D2_LOJA AND "
	cQuery += "SC6.C6_NOTA = SD2.D2_DOC AND "
	cQuery += "SC6.C6_SERIE = SD2.D2_SERIE AND "
	cQuery += "SC6.C6_NUM = SD2.D2_PEDIDO AND "
	cQuery += "SC6.C6_FILIAL = SD2.D2_FILIAL " 

cQuery += "LEFT OUTER JOIN " + RetSqlName("SF2") + " SF2 ON "
	cQuery += "SC6.C6_NOTA = SF2.F2_DOC AND "
	cQuery += "SC6.C6_SERIE = SF2.F2_SERIE AND "
	cQuery += "SC6.C6_CLI = SF2.F2_CLIENTE AND "
	cQuery += "SC6.C6_LOJA = SF2.F2_LOJA AND "
	cQuery += "SC6.C6_FILIAL = SF2.F2_FILIAL "

cQuery += "LEFT OUTER JOIN " + RetSqlName("SA1") + " SA1 ON "
	cQuery += "SC6.C6_CLI = SA1.A1_COD AND "
	cQuery += "SC6.C6_LOJA = SA1.A1_LOJA "

if _lOpc //reimpressao

	cQuery += "WHERE "
		cQuery += "SC6.D_E_L_E_T_ = '' AND "
		cQuery += "SC5.D_E_L_E_T_ = '' AND "	
		cQuery += "SD2.D_E_L_E_T_ = '' AND "
		cQuery += "SF2.D_E_L_E_T_ = '' AND "
		cQuery += "SA1.D_E_L_E_T_ = '' AND "
		cQuery += "SC6.C6_MINUTA = '" + mv_par01 + "' "

else //impressao

	cQuery += "WHERE "
		cQuery += "SC6.D_E_L_E_T_ = '' AND "
		cQuery += "SC5.D_E_L_E_T_ = '' AND "	
		cQuery += "SD2.D_E_L_E_T_ = '' AND "
		cQuery += "SF2.D_E_L_E_T_ = '' AND "
		cQuery += "SA1.D_E_L_E_T_ = '' AND "
		cQuery += "SC6.C6_MINUTA = '' AND "
		cQuery += "SC6.C6_NOTA <> '' AND "
		cQuery += "SC6.C6_CLI = '" + mv_par01 + "' AND "
		cQuery += "SC6.C6_LOJA = '" + mv_par02 + "' AND "
		cQuery += "SC6.C6_NUM BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' AND "
		cQuery += "SF2.F2_EMISSAO BETWEEN '" + DTOS(mv_par05) + "' AND '" + DTOS(mv_par06) + "' "

endif

cQuery += "ORDER BY SC6.C6_NUM, SC6.C6_ITEM, SC6.C6_CLI, SC6.C6_LOJA"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)

TCSetField( "TRB", "D2_QUANT"   , "N" , 11 , 2 )
TCSetField( "TRB", "D2_PRCVEN"  , "N" , 14 , 2 )
TCSetField( "TRB", "D2_TOTAL"   , "N" , 14 , 2 )  
TCSetField( "TRB", "D2_VALIPI"  , "N" , 14 , 2 )  
TCSetField( "TRB", "D2_IPI"     , "N" ,  5 , 2 )  
TCSetField( "TRB", "D2_VALBRUT" , "N" , 14 , 2 )  
TCSetField( "TRB", "F2_EMISSAO" , "D" ,  8 , 0 )  

dbSelectArea("TRB")
dbGoTop()

if _lOpc //reimpressao

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe registro a ser impresso                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	TRB->( dbEval( { || nQtdReg++ },, { || !EOF() } ) )
	TRB->( dbGoTop() )

	If nQtdReg == 0
		MsgAlert( "Não existe Minuta impressa com o código: " + mv_par01 , "ATENÇÃO" )
		TRB->( dbCloseArea() )
		return 
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Rotina para tratamento de reimpressao de minuta                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ImpMinuta()

	dbselectarea("TRB")
	dbclosearea()

else //impressao

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega o vetor na ListMark conforme parametros                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !Eof() 
	   aAdd( aVetor, { lMark,C6_NUM,C6_ITEM,C6_PRODUTO,C6_DESCRI,D2_UM,;
	   				   MsPadL(alltrim(transform(D2_QUANT,"@E 99,999,999.99")),10),;
	   				   MsPadL(alltrim(transform(D2_PRCVEN,"@E 999,999,999.99")),80),;
	   				   MsPadL(alltrim(transform(D2_TOTAL,"@E 999,999,999.99")),80),;
	   				   D2_DOC,D2_SERIE,F2_EMISSAO,C6_MINUTA,C6_CLI,C6_LOJA,D2_VALIPI,D2_IPI,;
	   				   D2_VALBRUT,D2_QUANT,D2_PRCVEN,D2_TOTAL,F2_DUPL,F2_PREFIXO,A1_NOME,A1_NREDUZ,;
	   				   A1_END,A1_MUN,A1_EST,A1_BAIRRO,A1_CEP,A1_DDD,A1_TEL,A1_FAX,A1_CGC,A1_INSCR,C5_MSGCERT })
	   dbSkip()
	End

	dbSelectArea("TRB")
	dbGoTop()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se nao houver itens no vetor sai da rotina                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len( aVetor ) == 0
	   Aviso( "Erro no filtro de registros", "Nao existe pedidos a consultar", {"Ok"} )
		dbSelectArea("TRB")
		dbCloseArea()
	   Return
	Endif

	DEFINE MSDIALOG oDlg TITLE cTit FROM 0,0 TO 240,500 PIXEL
	oDlg:lMaximized := .T.

	oTPane1 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,25,.T.,.F.)
	oTPane1:Align := CONTROL_ALIGN_TOP

		@ 4, 006 SAY "Cliente:"  SIZE 70,7 PIXEL OF oTPane1
		@ 4, 065 SAY "Loja:"     SIZE 70,7 PIXEL OF oTPane1
		@ 4, 105 SAY "Nome:"     SIZE 70,7 PIXEL OF oTPane1

		@ 3, 026 MSGET TRB->C6_CLI    When .F. SIZE 30,7 PIXEL OF oTPane1
		@ 3, 080 MSGET TRB->C6_LOJA   When .F. SIZE 15,7 PIXEL OF oTPane1
		@ 3, 125 MSGET TRB->A1_NOME   When .F. SIZE 150,7 PIXEL OF oTPane1
	
	oTPane2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,20,.T.,.F.)
	oTPane2:Align := CONTROL_ALIGN_BOTTOM
  
	@ 35,00 LISTBOX oLbx FIELDS HEADER ;
		" ", "Pedido", "Item", "Produto", "Descrição", "Unid.", "Qtde.", "Vlr. Unit.", "Vlr. Total", "Nota", "Série", "Emissão" ;
		SIZE 508,235 OF oDlg PIXEL ON dblClick(aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1])

	oLbx:SetArray( aVetor )
	oLbx:bLine := {|| {Iif(aVetor[oLbx:nAt,1],oOk,oNo),;
	                       aVetor[oLbx:nAt, 2],;
	                       aVetor[oLbx:nAt, 3],;
	                       aVetor[oLbx:nAt, 4],;
	                       aVetor[oLbx:nAt, 5],;
	                       aVetor[oLbx:nAt, 6],;
	                       aVetor[oLbx:nAt, 7],;
	                       aVetor[oLbx:nAt, 8],;
	                       aVetor[oLbx:nAt, 9],;
	                       aVetor[oLbx:nAt,10],;
	                       aVetor[oLbx:nAt,11],;
	                       aVetor[oLbx:nAt,12]}}

	oLbx:Refresh()
 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tratamento de Marca/Desmarca Todos                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 05,10 CHECKBOX oChk1 VAR lChk1 PROMPT "Marca/Desmarca Todos" SIZE 70,7 PIXEL OF oTPane2 ;
	         ON CLICK( aEval( aVetor, {|x| x[1] := lChk1 } ),oLbx:Refresh() )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tratamento de Iverter a selecao                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 05,95 CHECKBOX oChk2 VAR lChk2 PROMPT "Iverter a seleção" SIZE 70,7 PIXEL OF oTPane2 ;
	         ON CLICK( aEval( aVetor, {|x| x[1] := !x[1] } ), oLbx:Refresh() )

	ACTIVATE MSDIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,Iif(ValItem(),oDlg:End(),nOpcA:=0)},{||oDlg:End()})

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Rotina de impressao de minuta                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if nOpcA == 1
		ImpMinuta()
	endif

	dbSelectArea("TRB")
	dbCloseArea()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza parametro                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nAlt := val(_cNumMinuta)
	nAlt := nAlt + 1
	_cNumMinuta := STRZERO(nAlt,6)

	PutMv("ES_MINUTA" , _cNumMinuta )

endif

Return



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpMinuta º Autor ³Darlan Angelo F. Maciel º Data ³  30/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Relatorio - Emissao de Minuta                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³HCI                                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ImpMinuta

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Emissão de Minuta de despacho"
Local cPict        := ""
Local titulo       := "Minuta de Despacho"
Local nLin         := 80
Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}

Private cNomArq

if !_lOpc //impressao
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria arquivo temporario  TMP.DBF                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	CriaTMP()
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,NomeProg,,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,nTamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

if !_lOpc //impressao
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ GRAVA O NUMERO DA MINUTA NOS REGISTROS SELECIONADOS DO SC6          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("TMP")
	dbgotop()
	do while !eof()
		dbselectarea("SC6")
		dbsetorder(1)
		dbseek( xFilial("SC6") + TMP->PEDIDO + TMP->ITEM + TMP->PRODUTO )
		if found()
			RecLock("SC6",.F.)
		    	SC6->C6_MINUTA := _cNumMinuta
			MsUnlock()	
		endif
		dbSelectArea("TMP")
		dbskip()
	enddo
	dbSelectArea("TMP")
	dbCloseArea()
	Ferase(cNomArq+".dbf")
	Ferase(cNomArq+OrdBagExt())
endif

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³Darlan Angelo F. Maciel º Data ³  30/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS     º±±
±±º          ³ monta a janela com a regua de processamento.                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)


Local _cNum
Local _nVlrItem  := 0
Local _nVlrIPI   := 0
Local _nVlrTotal := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(0)

if _lOpc //reimpressao
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tratamento da reimpressao					                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbselectarea("TRB")
	dbgotop()

	_cNum  := TRB->C6_NUM 
	_cCli  := TRB->C6_CLI
	_cLoja := TRB->C6_LOJA
	_cPref := TRB->F2_PREFIXO 
	_cTit  := TRB->F2_DUPL
	_cMsgCert := TRB->C5_MSGCERT

	While !EOF()
		IncRegua()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho na quebra de pagina                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nLin > 48 // Salto de Página
			ImpCabec(_cNum)
			nLin := 14
		Endif
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
    
	    do while !eof() .and. TRB->C6_NUM == _cNum

			@ nLin,01 PSAY ALLTRIM(C6_DESCRI)  //Descricao do produto	
			@ nLin,33 PSAY ALLTRIM(D2_UM)       //Unidade de medida
			@ nLin,38 PSAY D2_QUANT     PICTURE "@E 99,999,999.99"  // Quantidade
			@ nLin,54 PSAY D2_PRCVEN    PICTURE "@E 999,999,999.99" // Vlr. Unitario
			@ nLin,71 PSAY D2_TOTAL     PICTURE "@E 999,999,999.99" // Vlr. Total
			@ nLin,88 PSAY D2_IPI       PICTURE "@E 99.99"          // % IPI
			@ nLin,96 PSAY D2_VALIPI    PICTURE "@E 999,999,999.99" // Vlr. IPI	

			_nVlrItem  := _nVlrItem  + D2_TOTAL
			_nVlrIPI   := _nVlrIPI   + D2_VALIPI
			_nVlrTotal := _nVlrTotal + D2_VALBRUT

			nLin := nLin + 1
					
			dbskip()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressao do cabecalho na quebra de pagina para mesmo item          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nLin > 48 .and. TRB->C6_NUM == _cNum // Salto de Página
				ImpCabec(_cNum)
				nLin := 14
			Endif         		

			If (nLin > 48 .and. TRB->C6_NUM != _cNum .and. !eof()) .or. (nLin < 48 .and. TRB->C6_NUM != _cNum .and. !eof()) // Salto de Página
			
				ImpRodap(nLin,_nVlrItem,_nVlrIPI,_nVlrTotal,_cMsgCert)
			
				_cNum  := TRB->C6_NUM 
				_cCli  := TRB->C6_CLI
				_cLoja := TRB->C6_LOJA
				_cPref := TRB->F2_PREFIXO 
				_cTit  := TRB->F2_DUPL
				_cMsgCert := TRB->C5_MSGCERT
				_nVlrItem  := 0
				_nVlrIPI   := 0
				_nVlrTotal := 0

				ImpCabec(_cNum)
				nLin := 14
			
			Endif         		
		
			if eof()
				ImpRodap(nLin,_nVlrItem,_nVlrIPI,_nVlrTotal,_cMsgCert)		
			endif
		enddo
	enddo

else //impressao
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tratamento da impressao					                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbselectarea("TMP")
	dbsetorder(1)
	dbgotop()

	_cNum     := TMP->PEDIDO 
	_cCli     := TMP->CLIENTE
	_cLoja    := TMP->LOJA
	_cPref    := TMP->PREFIXO 
	_cTit     := TMP->DUPLIC
	_cMsgCert := TMP->MSGCERT

	While !EOF()
		IncRegua()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho na quebra de pagina                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nLin > 48 // Salto de Página
			ImpCabec(_cNum)
			nLin := 14
		Endif
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
    
	    do while !eof() .and. TMP->PEDIDO == _cNum

			@ nLin,01 PSAY ALLTRIM(DESCRICAO)  //Descricao do produto	
			@ nLin,33 PSAY ALLTRIM(UNID)       //Unidade de medida
			@ nLin,38 PSAY QUANT     PICTURE "@E 99,999,999.99"  // Quantidade
			@ nLin,54 PSAY PRCVEN    PICTURE "@E 999,999,999.99" // Vlr. Unitario
			@ nLin,71 PSAY VLRTOTAL  PICTURE "@E 999,999,999.99" // Vlr. Total
			@ nLin,88 PSAY IPI       PICTURE "@E 99.99"          // % IPI
			@ nLin,96 PSAY VALIPI    PICTURE "@E 999,999,999.99" // Vlr. IPI	

			_nVlrItem  := _nVlrItem  + VLRTOTAL
			_nVlrIPI   := _nVlrIPI   + VALIPI
			_nVlrTotal := _nVlrTotal + VALBRUT

			nLin := nLin + 1
					
			dbskip()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressao do cabecalho na quebra de pagina para mesmo item          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nLin > 48 .and. TMP->PEDIDO == _cNum // Salto de Página
				ImpCabec(_cNum)
				nLin := 14
			Endif         		

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Imprime rodape e trata salto de pagina para pedido diferente        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If (nLin > 48 .and. TMP->PEDIDO != _cNum .and. !eof()) .or. (nLin < 48 .and. TMP->PEDIDO != _cNum .and. !eof()) 
				
				ImpRodap(nLin,_nVlrItem,_nVlrIPI,_nVlrTotal,_cMsgCert)
			
				_cNum := TMP->PEDIDO 			
				_cCli  := TMP->CLIENTE
				_cLoja := TMP->LOJA
				_cPref := TMP->PREFIXO 
				_cTit  := TMP->DUPLIC
				_cMsgCert := TMP->MSGCERT
				_nVlrItem  := 0
				_nVlrIPI   := 0
				_nVlrTotal := 0

				ImpCabec(_cNum)
				nLin := 14
			
			Endif         		
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Imprime rodape ao final da impressao dos registros                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			if eof()
				ImpRodap(nLin,_nVlrItem,_nVlrIPI,_nVlrTotal,_cMsgCert)		
			endif
		enddo
	enddo
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³AjustaSX1 ³ Autor ³Darlan Angelo F. Maciel³ Data ³ 30/01/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Monta perguntas no SX1 para impressao da minuta.            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AjustaSx1(cPerg)


Local  i

_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)

 cPerg   := PADR(cPerg,6)
 aHelp   :={}
 aRegs   :={}


if _lOpc //reimpressao

	aAdd(aHelp,{"Informe o número de Minuta a ser reimpresso."})

	aAdd(aRegs,{"Minuta ?"   	,"C" ,06 ,0 ,"G" ,"" ,"" ,"" ,"" ,"" ,"" ,"" })

	For i:=1 To Len(aRegs)
		cSeq   := StrZero(i,2,0)
		cMvPar := "mv_par"+cSeq
		cMvCh  := "mv_ch"+IIF(i<=9,Chr(i+48),Chr(i+87))
	
		PutSx1(cPerg,;
		cSeq,;
		aRegs[i,1],aRegs[i,1],aRegs[i,1],;
		cMvCh,;
		aRegs[i,2],;
		aRegs[i,3],;
		aRegs[i,4],;
		0,;
		aRegs[i,5],;
		aRegs[i,6],;
		aRegs[i,7],;
		"",;
		"",;
		cMvPar,;
		aRegs[i,8],aRegs[i,8],aRegs[i,8],;
		"",;
		aRegs[i,9],aRegs[i,9],aRegs[i,9],;
		aRegs[i,10],aRegs[i,10],aRegs[i,10],;
		aRegs[i,11],aRegs[i,11],aRegs[i,11],;
		aRegs[i,12],aRegs[i,12],aRegs[i,12],;
		aHelp[i],;
		{},;
		{},;
		"")
	Next i

else //impressao

	aAdd(aHelp,{"Informe o código do cliente."})
	aAdd(aHelp,{"Informe a loja do cliente."})
	aAdd(aHelp,{"Informe o número de pedido INICIAL a ser considerado na impressão da Minuta."})
	aAdd(aHelp,{"Informe o número de pedido FINAL a ser considerado na impressão da Minuta."})
	aAdd(aHelp,{"Informe o período INICIAL. Data referente ao faturamento do pedido"})
	aAdd(aHelp,{"Informe o período FINAL. Data referente ao faturamento do pedido"})
	
	aAdd(aRegs,{"Cliente ?"   	,"C" ,06 ,0 ,"G" ,"" ,"SA1" ,""	 ,"" ,"" ,"" ,"" })
	aAdd(aRegs,{"Loja ?"    	,"C" ,02 ,0 ,"G" ,"" ,""   	 ,"" ,"" ,"" ,"" ,"" })
	aAdd(aRegs,{"Pedido de ?"  	,"C" ,06 ,0 ,"G" ,"" ,"SC5"	 ,"" ,"" ,"" ,"" ,"" })
	aAdd(aRegs,{"Pedido até ?" 	,"C" ,06 ,0 ,"G" ,"" ,"SC5"	 ,"" ,"" ,"" ,"" ,"" })
	aAdd(aRegs,{"Período de ?" 	,"D" ,08 ,0 ,"G" ,"" ,""   	 ,"" ,"" ,"" ,"" ,"" })
	aAdd(aRegs,{"Período até ?"	,"D" ,08 ,0 ,"G" ,"" ,""   	 ,"" ,"" ,"" ,"" ,"" })

	For i:=1 To Len(aRegs)
		cSeq   := StrZero(i,2,0)
		cMvPar := "mv_par"+cSeq
		cMvCh  := "mv_ch"+IIF(i<=9,Chr(i+48),Chr(i+87))
	
		PutSx1(cPerg,;
		cSeq,;
		aRegs[i,1],aRegs[i,1],aRegs[i,1],;
		cMvCh,;
		aRegs[i,2],;
		aRegs[i,3],;
		aRegs[i,4],;
		0,;
		aRegs[i,5],;
		aRegs[i,6],;
		aRegs[i,7],;
		"",;
		"",;
		cMvPar,;
		aRegs[i,8],aRegs[i,8],aRegs[i,8],;
		"",;
		aRegs[i,9],aRegs[i,9],aRegs[i,9],;
		aRegs[i,10],aRegs[i,10],aRegs[i,10],;
		aRegs[i,11],aRegs[i,11],aRegs[i,11],;
		aRegs[i,12],aRegs[i,12],aRegs[i,12],;
		aHelp[i],;
		{},;
		{},;
		"")
	Next i

endif

dbSelectArea(_sAlias)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ImpCabec  ³ Autor ³Darlan Angelo F. Maciel³ Data ³ 31/01/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao do cabecalho secundario do relatorio              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ImpCabec(_cPed)

Local _xAlias  := Alias()
Local aDriver  := ReadDriver( )
Local nLin     := 0
Local _cTitulo := "M I N U T A    D E    D E S P A C H O    Nº: "

//                              1         2         3         4         5         6         7         8         9         0         1
//                     12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local Cabec1       := "Descrição                       Und.        Qtde.        Vlr. Unit.       Vlr. Tot.     %IPI        Vlr. IPI"
//                     AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA  AA   99,999,999.99   999,999,999.99   999,999,999.99   99,99   999,999,999.99

if nTipo == NIL
	cCtl := if(nTamanho=="P",aDriver[1],if(nTamanho=="G",aDriver[1],aDriver[3]))
	cCtl := &cCtl
else
	if nTipo == 15
		cCtl := if(nTamanho=="P",aDriver[1],if(nTamanho=="G",aDriver[1],aDriver[3]))
		cCtl := &cCtl
	else
		cCtl := if(nTamanho=="P",aDriver[2],if(nTamanho=="G",aDriver[1],aDriver[4]))
		cCtl := &cCtl
	endif
endif

@ 00,00 PSAY cCtl
DbSelectArea( "SM0" )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Titulo,data e hora de emissao e numero da minuta    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLin := nLin + 1
@ nLin, 00 PSAY Replicate("-",nlargura)
nLin := nLin + 1
@ nLin, 00 PSAY "|"
@ nLin, 01 PSAY ALLTRIM(SM0->M0_NOME)+"/"+nomeprog

if _lOpc //reimpressao
	@ nLin, Int((nlargura - (Len(AllTrim(_cTitulo + mv_par01))))/2) PSAY _cTitulo + mv_par01
else //impressao
	@ nLin, Int((nlargura - (Len(AllTrim(_cTitulo + _cNumMinuta ))))/2) PSAY _cTitulo + _cNumMinuta 
endif

@ nLin, nlargura-19 PSAY "Dt.Ref.: "+DtoC(dDataBase)
@ nLin, nLargura-1 PSAY "|"
nLin := nLin + 1
@ nLin, 00 PSAY "|"
@ nLin, 01 PSAY "Horas:" + Time()

if _lOpc //reimpressao
	@ nLin, Int((nlargura - (Len(AllTrim(".PEDIDO: "+_cPed+ " - (REIMPRESSÃO)"))))/2) PSAY "PEDIDO: " + _cPed + " - (REIMPRESSÃO)"
else //impressao
	@ nLin, Int((nlargura - (Len(AllTrim(".PEDIDO: "+_cPed))))/2) PSAY "PEDIDO: "+_cPed
endif

@ nLin, nlargura-19 PSAY "Emissão: "+DtoC(date())
@ nLin, nLargura-1 PSAY "|"
nLin := nLin + 1
@ nLin, 00 PSAY Replicate("-",nlargura)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Dados da empresa emitente, cliente, pedido e duplicata   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLin := nLin + 1
if _lOpc //reimpressao
	@ nLin, 00 PSAY "|" + Upper(ALLTRIM(SM0->M0_NOMECOM))
	@ nLin, Int((nlargura)/2) PSAY "|" + alltrim(TRB->A1_NOME) //nome cliente
	@ nLin, nLargura-1 PSAY "|"
	nLin := nLin + 1
	@ nLin, 00 PSAY "|" + Upper(ALLTRIM(SM0->M0_ENDCOB))
	@ nLin, Int((nlargura)/2) PSAY "|" + alltrim(TRB->A1_END) //endereco cliente
	@ nLin, nLargura-1 PSAY "|"
	nLin := nLin + 1
	@ nLin, 00 PSAY "|" + Upper(ALLTRIM(SM0->M0_BAIRCOB)) + " - CEP: " + Transform(SM0->M0_CEPCOB,"@R #####-###") 
	@ nLin, Int((nlargura)/2) PSAY "|" + alltrim(TRB->A1_BAIRRO) + " - CEP: " + Transform(TRB->A1_CEP,"@R #####-###") // bairro e cep cliente
	@ nLin, nLargura-1 PSAY "|"
	nLin := nLin + 1
	@ nLin, 00 PSAY "|" + Upper(ALLTRIM(SM0->M0_CIDCOB)) + " - " + Upper(ALLTRIM(SM0->M0_ESTCOB))
	@ nLin, Int((nlargura)/2) PSAY "|" + alltrim(TRB->A1_MUN) + " - " + ALLTRIM(TRB->A1_EST) //cidade e estado cliente
	@ nLin, nLargura-1 PSAY "|"                                   
	nLin := nLin + 1
	@ nLin, 00 PSAY "|CGC: " + Transform(SM0->M0_CGC,"@R ##.###.###/####-##") + " - I.E.: " + ALLTRIM(SM0->M0_INSC)
	@ nLin, Int((nlargura)/2) PSAY "|CGC: " + Transform(TRB->A1_CGC,"@R ##.###.###/####-##") + " - I.E.: " + ALLTRIM(TRB->A1_INSCR) //cgc e IE cliente
	@ nLin, nLargura-1 PSAY "|"
	nLin := nLin + 1
	@ nLin, 00 PSAY "|TEL.: " + ALLTRIM(SM0->M0_TEL) + " - FAX: " + ALLTRIM(SM0->M0_FAX)
	@ nLin, Int((nlargura)/2) PSAY "|TEL.: (" + ALLTRIM(TRB->A1_DDD) + ")" + Transform(TRB->A1_TEL,"@R ####-####") + " - FAX: " + Transform(TRB->A1_FAX,"@R ####-####") // tel e fax cliente
	@ nLin, nLargura-1 PSAY "|"
	nLin := nLin + 1
	@ nLin, 00 PSAY Replicate("-",nlargura)
else //impressao
	@ nLin, 00 PSAY "|" + Upper(ALLTRIM(SM0->M0_NOMECOM))
	@ nLin, Int((nlargura)/2) PSAY "|" + alltrim(TMP->NOME) //nome cliente
	@ nLin, nLargura-1 PSAY "|"
	nLin := nLin + 1
	@ nLin, 00 PSAY "|" + Upper(ALLTRIM(SM0->M0_ENDCOB))
	@ nLin, Int((nlargura)/2) PSAY "|" + alltrim(TMP->ENDEREC) //endereco cliente
	@ nLin, nLargura-1 PSAY "|"
	nLin := nLin + 1
	@ nLin, 00 PSAY "|" + Upper(ALLTRIM(SM0->M0_BAIRCOB)) + " - CEP: " + Transform(SM0->M0_CEPCOB,"@R #####-###") 
	@ nLin, Int((nlargura)/2) PSAY "|" + alltrim(TMP->BAIRRO) + " - CEP: " + Transform(TMP->CEP,"@R #####-###") // bairro e cep cliente
	@ nLin, nLargura-1 PSAY "|"
	nLin := nLin + 1
	@ nLin, 00 PSAY "|" + Upper(ALLTRIM(SM0->M0_CIDCOB)) + " - " + Upper(ALLTRIM(SM0->M0_ESTCOB))
	@ nLin, Int((nlargura)/2) PSAY "|" + alltrim(TMP->CIDADE) + " - " + ALLTRIM(TMP->ESTADO) //cidade e estado cliente
	@ nLin, nLargura-1 PSAY "|"                                   
	nLin := nLin + 1
	@ nLin, 00 PSAY "|CGC: " + Transform(SM0->M0_CGC,"@R ##.###.###/####-##") + " - I.E.: " + ALLTRIM(SM0->M0_INSC)
	@ nLin, Int((nlargura)/2) PSAY "|CGC: " + Transform(TMP->CGC,"@R ##.###.###/####-##") + " - I.E.: " + ALLTRIM(TMP->IE) //cgc e IE cliente
	@ nLin, nLargura-1 PSAY "|"
	nLin := nLin + 1
	@ nLin, 00 PSAY "|TEL.: " + ALLTRIM(SM0->M0_TEL) + " - FAX: " + ALLTRIM(SM0->M0_FAX)
	@ nLin, Int((nlargura)/2) PSAY "|TEL.: (" + ALLTRIM(TMP->DDD) + ")" + Transform(TMP->TEL,"@R ####-####") + " - FAX: " + Transform(TMP->FAX,"@R ####-####") // tel e fax cliente
	@ nLin, nLargura-1 PSAY "|"
	nLin := nLin + 1
	@ nLin, 00 PSAY Replicate("-",nlargura)
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cabecalho 2 - itens                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLin := nLin + 1
@ nLin, 00 PSAY "|" + Cabec1
@ nLin, nLargura-1 PSAY "|"
nLin := nLin + 1
@ nLin, 00 PSAY Replicate("-",nlargura)

dbSelectArea( _xAlias )

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ImpRodap  ³ Autor ³Darlan Angelo F. Maciel³ Data ³ 31/01/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao do rodape do relatorio                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ImpRodap(_nLin,_nItem,_nIPI,_nTotal,_cMsg)

Local _xAlias  := Alias()
Local cRecebi  := "DECLARO TER RECEBIDO AS MERCADORIAS DESTA MINUTA DE DESPACHO EM _____/_____/_______"
Local cAssina  := "_______________________________________________"
Local cRespon  := "CARIMBO DA EMPRESA E ASSINATURA DO RESPONSÁVEL."


//_nLin := 49

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Totalizadores e duplicatas                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ _nLin, 00 PSAY Replicate("-",nlargura)
_nLin := _nLin + 2

@ _nLin, 00 PSAY "VALOR TOTAL DAS MERCADORIAS --> " 
@ _nLin, 33 PSAY _nItem PICTURE "@E 999,999,999.99" 
@ _nLin, Int((nlargura-27)/2) PSAY "| " + "MENSAGENS: " + alltrim(substr(_cMsg,1,65))
_nLin := _nLin + 1
@ _nLin, 00 PSAY "VALOR TOTAL DO IPI -----------> " 
@ _nLin, 33 PSAY _nIPI PICTURE "@E 999,999,999.99" 
@ _nLin, Int((nlargura-27)/2) PSAY "|"
@ _nLin, 65 PSAY alltrim(substr(_cMsg,66,15))
_nLin := _nLin + 1
@ _nLin, 00 PSAY "VALOR TOTAL DA MINUTA --------> " 
@ _nLin, 33 PSAY _nTotal PICTURE "@E 999,999,999.99" 
@ _nLin, Int((nlargura-27)/2) PSAY "|"
_nLin := _nLin + 2

@ _nLin, 00 PSAY "DUPLICATA(S): "

dbselectarea("SE1")
dbsetorder(2)
_cFil:=xFilial("SE1")
dbseek(_cFil+_cCli+_cLoja+_cPref+_cTit)
if found()
	do while !eof() .and. xFilial("SE1")+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM == _cFil+_cCli+_cLoja+_cPref+_cTit

		@ _nLin, 15 PSAY alltrim(E1_NUM) + alltrim(E1_PARCELA) + " -"
		@ _nLin, 25 PSAY DtoC(E1_VENCREA) + " -"
		@ _nLin, 36 PSAY E1_VALOR PICTURE "@E 99,999,999.99"
		@ _nLin, 52 PSAY "|"
		dbskip()
		
		if eof() .or. xFilial("SE1")+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM != _cFil+_cCli+_cLoja+_cPref+_cTit
			exit
		endif

		@ _nLin, 56 PSAY alltrim(E1_NUM) + alltrim(E1_PARCELA) + " -"
		@ _nLin, 66 PSAY DtoC(E1_VENCREA) + " -"
		@ _nLin, 77 PSAY E1_VALOR PICTURE "@E 99,999,999.99"
		@ _nLin, 93 PSAY "|"
		dbskip()

		if eof() .or. xFilial("SE1")+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM != _cFil+_cCli+_cLoja+_cPref+_cTit
			exit
		endif

		@ _nLin, 97 PSAY alltrim(E1_NUM) + alltrim(E1_PARCELA) + " -"
		@ _nLin,107 PSAY DtoC(E1_VENCREA) + " -"
		@ _nLin,118 PSAY E1_VALOR PICTURE "@E 99,999,999.99"

		dbskip()
		_nLin := _nLin + 1
	enddo()
endif  

_nLin := _nLin + 3
@ _nLin, Int((nlargura - (Len(AllTrim(cRecebi))))/2) PSAY cRecebi  
_nLin := _nLin + 3
@ _nLin, Int((nlargura - (Len(AllTrim(cAssina))))/2) PSAY cAssina   
_nLin := _nLin + 1                                                    
@ _nLin, Int((nlargura - (Len(AllTrim(cRespon))))/2) PSAY cRespon

dbSelectArea( _xAlias )

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ ValItem  ³ Autor ³Darlan Angelo F. Maciel³ Data ³ 30/01/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida se existe itens selecionados para impressao da minuta³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ValItem()
Local lRet  := .F.
Local _nCont := 0 
Local i

For i:=1 To Len(aVetor)
	if aVetor[i][1] = .T.
		_nCont := _nCont + 1
	endif
Next i

if _nCont > 0
	lRet := .T.	
endif

return(lRet)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CriaTMP  ³ Autor ³Darlan Angelo F. Maciel³ Data ³ 30/01/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria arquivo dbf temporario para impressao da minuta        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CriaTMP()

Local aAssoc := {}
Local aArqTRB := {}
Local aVetor := {}
Local nI := 0
Local _nI := 0
Local cIndTRB
Local i

aAdd( aAssoc, { "MARK"      ,"EC7_BLOQ"   } )
aAdd( aAssoc, { "PEDIDO"    ,"C6_NUM"     } )
aAdd( aAssoc, { "ITEM"      ,"C6_ITEM"    } )
aAdd( aAssoc, { "PRODUTO"   ,"C6_PRODUTO" } )
aAdd( aAssoc, { "DESCRICAO" ,"C6_DESCRI"  } )
aAdd( aAssoc, { "UNID"      ,"D2_UM"      } )
aAdd( aAssoc, { "CQTD"      ,"C6_PRODUTO" } )
aAdd( aAssoc, { "CPRC"      ,"C6_PRODUTO" } )
aAdd( aAssoc, { "CTOT"      ,"C6_PRODUTO" } )
aAdd( aAssoc, { "NOTA"      ,"D2_DOC"     } )
aAdd( aAssoc, { "SERIE"     ,"D2_SERIE"   } )
aAdd( aAssoc, { "EMISSAO"   ,"F2_EMISSAO" } )
aAdd( aAssoc, { "MINUTA"    ,"C6_MINUTA"  } )
aAdd( aAssoc, { "CLIENTE"   ,"C6_CLI"     } )
aAdd( aAssoc, { "LOJA"      ,"C6_LOJA"    } )
aAdd( aAssoc, { "VALIPI"    ,"D2_VALIPI"  } )
aAdd( aAssoc, { "IPI"       ,"D2_IPI"     } )
aAdd( aAssoc, { "VALBRUT"   ,"D2_VALBRUT" } )
aAdd( aAssoc, { "QUANT"     ,"D2_QUANT"   } )
aAdd( aAssoc, { "PRCVEN"    ,"D2_PRCVEN"  } )
aAdd( aAssoc, { "VLRTOTAL"  ,"D2_TOTAL"   } )
aAdd( aAssoc, { "DUPLIC"    ,"F2_DUPL"    } )
aAdd( aAssoc, { "PREFIXO"   ,"F2_PREFIXO" } )
aAdd( aAssoc, { "NOME"      ,"A1_NOME"    } )
aAdd( aAssoc, { "NREDUZ"    ,"A1_NREDUZ"  } )
aAdd( aAssoc, { "ENDEREC"   ,"A1_END"     } )
aAdd( aAssoc, { "CIDADE"    ,"A1_MUN"     } )
aAdd( aAssoc, { "ESTADO"    ,"A1_EST"     } )
aAdd( aAssoc, { "BAIRRO"    ,"A1_BAIRRO"  } )
aAdd( aAssoc, { "CEP"       ,"A1_CEP"     } )
aAdd( aAssoc, { "DDD"       ,"A1_DDD"     } )
aAdd( aAssoc, { "TEL"       ,"A1_TEL"     } )
aAdd( aAssoc, { "FAX"       ,"A1_FAX"     } )
aAdd( aAssoc, { "CGC"       ,"A1_CGC"     } )
aAdd( aAssoc, { "IE"        ,"A1_INSCR"   } )
aAdd( aAssoc, { "MSGCERT"   ,"C5_MSGCERT" } )

dbSelectArea("SX3")
dbSetOrder(2)
For nI := 1 To Len( aAssoc )
	dbSeek( aAssoc[nI,2] )
	aAdd( aArqTRB, { aAssoc[nI,1], X3_TIPO, X3_TAMANHO, X3_DECIMAL } )
Next nI

cIndTRB := "PEDIDO+ITEM+CLIENTE+LOJA"
cNomArq := CriaTrab( aArqTRB, .T. )
dbUseArea( .T., "DBFCDX", cNomArq, "TMP", .T. ,.F. )

IndRegua( "TMP", cNomArq, cIndTRB )
dbSetOrder(1)

For i:=1 To Len(aVetor)
	if aVetor[i][1] = .T.
		dbselectarea("TMP")
		RecLock("TMP",.T.)
		For _nI := 1 To FCount()
			_cCmp1 := "TMP->"+FieldName(_nI)
			&_cCmp1 := aVetor[i][_nI]
		Next
		MsUnlock()
	endif
Next i

Return ()