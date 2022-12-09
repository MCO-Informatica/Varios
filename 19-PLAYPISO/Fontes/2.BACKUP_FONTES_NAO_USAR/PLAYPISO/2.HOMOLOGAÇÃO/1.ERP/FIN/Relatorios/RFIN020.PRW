#INCLUDE "Protheus.ch"
#INCLUDE "Finr855.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RFIN020  ³ Autor ³Mauro Nagata           ³ Data ³ 02/08/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio para impressao do titulo principal x titulos de  ³±±
±±³          ³ impostos gerados.                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Lisonda / PlayPiso                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ Relatorio concebido para relacionar o titulos de retencao  ³±±
±±³          ³ de impostos com opcao de considerar o valor original ou    ³±±
±±³          ³ somente o saldo do titulo. Baseado no FINR855              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFIN020()

Local oReport

If FindFunction("TRepInUse") .And. TRepInUse()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:=ReportDef()
	oReport:PrintDialog()
Else
	FINR855R3()
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³Marcel Borges Ferreira ³ Data ³ 08/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local oReport

Pergunte("RFIN020",.F.)

oReport := TReport():New("RFIN020",STR0004,"RFIN020",{|oReport| ReportPrint(oReport)},STR0001+STR0002+STR0003) //"Este programa tem como objetivo imprimir relatorio com a relação Titulo Principal X Impostos, de acordo com os parametros informados pelo usuario."
oReport:SetLandscape()                            

//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Secao 1  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1 := TRSection():New(oReport,STR0028, ("TR1","SA2","SED","SE2"),{OemToAnsi(STR0013),OemToAnsi(STR0014)})  //"Titulo principal"##"Por Codigo Fornecedor" - "Por Nome Fornecedor" 
TRCell():New( oSection1, "TR1_COD"		,,STR0029,,TamSx3('A2_COD' )[1],,)  //"Fornecedor"
TRCell():New( oSection1, "TR1_LOJA"		,,STR0030 ,,TamSx3('A2_LOJA')[1],,)  //"Loja"
TRCell():New( oSection1, "TR1_NOME"		,,STR0016,,50,,) //"Nome Fornecedor"
TRCell():New( oSection1, "TR1_CGC" 		,,STR0017,,20,,) //"CNPJ"
TRCell():New( oSection1, "TR1_PREFIXO"	,,STR0018,,5,,) //"Pref"
TRCell():New( oSection1, "TR1_NUM"		,,STR0019,,5,,) //"Numero"
TRCell():New( oSection1, "TR1_PARCELA"	,,STR0020,,10,,) //"Parc"
TRCell():New( oSection1, "TR1_TIPO"		,,STR0021,,5,,) //"Tipo"
TRCell():New( oSection1, "TR1_NATUREZ"	,,STR0022,,10,,) //"Natureza"
TRCell():New( oSection1, "TR1_EMISSAO"	,,STR0023,,10,,) //"Emissao"
TRCell():New( oSection1, "TR1_VENCREA"	,,STR0024,,15,,) //"Vencimento"
TRCell():New( oSection1, "TR1_VALBASE"	,,STR0025,"@E 99999,999.99",10,,) //"Valor Bruto"
TRCell():New( oSection1, "TR1_VALIMP"	,,STR0026,"@E 99999,999.99",10,,) //"Impostos"
TRCell():New( oSection1, "TR1_VALLIQ"	,,STR0027,"@E 99999,999.99",10,,) //"Valor Lq"

TrPosition():New(oSection1,'SE2',1,{|| xFilial('SE2')+ TR1->PREFIXO+TR1->NUM+TR1->PARCELA+TR1->TIPO+TR1->CODIGO+TR1->LOJA })
TrPosition():New(oSection1,'SA2',1,{|| xFilial('SA2')+ TR1->CODIGO+TR1->LOJA })
TrPosition():New(oSection1,'SED',1,{|| xFilial('SED')+ TR1->NATUREZ })

oSection1:SetHeaderPage()


//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Secao 2  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
oSection2 := TRSection():New(oReport,STR0026, {"TR2","SE2","SA2","SED"} ) //"Impostos"
TRCell():New( oSection2, "TR2_COD"		,,STR0029,,TamSx3('A2_COD' )[1],,)  //"Fornecedor"
TRCell():New( oSection2, "TR2_LOJA"		,,STR0030,,TamSx3('A2_LOJA')[1],,) //"Loja"
TRCell():New( oSection2, "TR2_NOME"		,,STR0016,,50,,)//"Nome Fornecedor"
TRCell():New( oSection2, "TR2_CGC" 		,,STR0017,,20,,)//"CNPJ"
TRCell():New( oSection2, "TR2_PREFIXO"	,,STR0018,,5,,)//"Pref"
TRCell():New( oSection2, "TR2_NUM"		,,STR0019,,5,,)//"Numero"
TRCell():New( oSection2, "TR2_PARCELA"	,,STR0020,,10,,)//"Parc"
TRCell():New( oSection2, "TR2_TIPO"		,,STR0021,,5,,)//"Tipo"
TRCell():New( oSection2, "TR2_NATUREZ"	,,STR0022,,10,,)//"Natureza"
TRCell():New( oSection2, "TR2_EMISSAO"	,,STR0023,,10,,)//"Emissao"
TRCell():New( oSection2, "TR2_VENCREA"	,,STR0024,,15,,)//"Vencimento"
TRCell():New( oSection2, "TR2_VALBASE"	,,STR0025,"@E 99999,999.99",10,,)//"Valor Bruto"
TRCell():New( oSection2, "TR2_VALIMP"	,,STR0026,"@E 99999,999.99",10,,)//"Impostos"
TRCell():New( oSection2, "TR2_VALLIQ"	,,STR0027,"@E 99999,999.99",10,,)//"Valor Lq"

TrPosition():New(oSection2,'SE2',1,{|| xFilial('SE2')+ TR2->PREFIXO+TR2->NUM+TR2->PARCELA+TR2->TIPO+TR2->CODIGO+TR2->LOJA })
TrPosition():New(oSection2,'SA2',1,{|| xFilial('SA2')+ TR2->CODIGO+TR2->LOJA })
TrPosition():New(oSection2,'SED',1,{|| xFilial('SED')+ TR2->NATUREZ })

//oSection2:SetNoFilter({"SED","SA1","SE2"})

oSection2:SetTotalInLine(.F.)
oSection2:SetTotalText(STR0031) //"Totais :"

oSection2:SetHeaderSection(.F.)

TRFunction():New(oSection2:Cell("TR2_VALBASE") ,/*"oTotal"*/ ,"ONPRINT", /*oBreak */,,/*[ cPicture ]*/,{||TR1->VALBASE }/*[ uFormula ]*/,.T.,.F.,,oSection2)
TRFunction():New(oSection2:Cell("TR2_VALIMP" ) ,/*"oTotal"*/ ,"ONPRINT", /*oBreak */,,/*[ cPicture ]*/,{||TR1->VALBASE-TR1->VALLIQ }/*[ uFormula ]*/,.T.,.F.,,oSection2)
TRFunction():New(oSection2:Cell("TR2_VALLIQ") ,/*"oTotal"*/  ,"ONPRINT", /*oBreak */,,/*[ cPicture ]*/,{||TR1->VALLIQ } /*[uFormula ]*/,.T.,.F.,,oSection2)

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³Marcel Borges Ferreira ³ Data ³ 23/06/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportPrint devera ser criada para todos os³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.           ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                            ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport)

Local oSection1 := oReport:Section(1) 
//Local oSection2 := oReport:Section(1):Section(1)
Local oSection2 := oReport:Section(2)
//Local oSection3 := oReport:Section(1):Section(1):Section(1)
Local x   
Local cIndexSe2
Local cChaveSe2   
Local cTx		:= ""   
Local cIss		:= ""   
Local cIns		:= ""   
Local nValImp  := 0
Local aParcela := {}
Local aTamNum	:= TAMSX3("E2_NUM")
Local	aTps 
Local	aParc
Local bCond
Local cFilterSA2	:=	oSection1:GetAdvplExp("SA2")
Local cFilterSED	:=	oSection1:GetAdvplExp("SED")
Local cFilterSE2	:=	oSection1:GetAdvplExp("SE2")
Local cFilterImp	:=	oSection2:GetAdvplExp("SE2")

Local nSizeChav	:=	TamSx3('E2_FILIAL')[1]+TamSx3('E2_PREFIXO')[1]+aTamNum[1]+TamSx3('E2_PARCELA')[1]+TamSx3('E2_TIPO')[1]+TamSx3('E2_FORNECE')[1]+TamSx3('E2_LOJA')[1]
Local aCampos1	:= {	{"CODIGO"	,"C",TamSx3('A2_COD')[1],0 },; 
							{"LOJA"		,"C",TamSx3('A2_LOJA')[1],0 },; 
							{"NOMEFOR"	,"C",40,0 },;
							{"CGC"		,"C",14,0 },;
							{"PREFIXO"	,"C",03,0 },;
							{"NUM"		,"C",aTamNum[1],0 },;
							{"PARCELA"	,"C",TamSx3("E2_PARCELA")[1],0 },;
							{"TIPO"		,"C",03,0 },;
							{"NATUREZ"	,"C",10,0 },;							
							{"EMISSAO"	,"D",08,0 },;
							{"VENCTO"	,"D",08,0 },;
							{"VALBASE"  ,"N",17,2 },;
							{"VALINSS"	,"N",17,2 },;
							{"VALPIS"	,"N",17,2 },;
							{"VALCOF"	,"N",17,2 },;
							{"VALCSLL"	,"N",17,2 },;
							{"VALIRFF"	,"N",17,2 },;
							{"VALISS"	,"N",17,2 },;
							{"VALSEST"	,"N",17,2 },;
							{"PARCSES"	,"C",TamSx3("E2_PARCELA")[1],0 },;
							{"PARCIR"	,"C",TamSx3("E2_PARCELA")[1],0 },;
							{"PARCISS"	,"C",TamSx3("E2_PARCELA")[1],0 },;
							{"PARCINS"	,"C",TamSx3("E2_PARCELA")[1],0 },;
							{"PARCCSS"	,"C",TamSx3("E2_PARCELA")[1],0 },;
							{"PARCCOF"	,"C",TamSx3("E2_PARCELA")[1],0 },;
							{"PARCPIS"	,"C",TamSx3("E2_PARCELA")[1],0 },;
							{"PARCSLL"	,"C",TamSx3("E2_PARCELA")[1],0 },;
							{"VALLIQ"	,"N",17,2 },;
							{"VAL10925V1","N",17,2 }}

Local aCampos2	:= {	{"CODIGO"	,"C",TamSx3('A2_COD' )[1],0 },;
							{"LOJA"		,"C",TamSx3('A2_LOJA')[1],0 },; 
							{"NOMEFOR"	,"C",40,0 },;
							{"CGC"		,"C",14,0 },;
							{"PREFIXO"	,"C",03,0 },;
							{"NUM"		,"C",aTamNum[1],0 },;
							{"PARCELA"	,"C",TamSx3("E2_PARCELA")[1],0 },;
							{"TIPO"		,"C",03,0 },;
							{"NATUREZ"	,"C",10,0 },;							
							{"EMISSAO"	,"D",08,0 },;
							{"VENCTO"	,"D",08,0 },;
							{"VALBASE"  ,"N",17,2 } }

Local lContrRet := !Empty( SE2->( FieldPos( "E2_VRETPIS" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE2->( FieldPos( "E2_VRETCSL" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETPIS" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_PRETCOF" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETCSL" ) ) )

//Controla o Pis Cofins e Csll na baixa
Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )
Local lFirst

Local lAglPCC := SuperGetMv("MV_AG10925",.F.,"2") == "1"

dbSelectArea("SE2")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Efetua filro              													   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cChaveSe2 := IndexKey()
cIndexSe2 := CriaTrab(Nil,.f.)
IndRegua("SE2",cIndexSe2,cChaveSe2,,FR855IndR(),STR0008) //"Selecionando Registros..."

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo temporario 1  													   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqTrab1 := CriaTrab( aCampos1 )
dbUseArea( .T.,, cArqTrab1, "TR1", if(.F. .OR. .F., !.F., NIL), .F. )
If oSection1:GetOrder() == 1
	IndRegua("TR1",cArqTrab1,"CODIGO + LOJA +  PREFIXO + NUM + PARCELA",,,)
Else
	IndRegua("TR1",cArqTrab1,"NOMEFOR + PREFIXO + NUM + PARCELA",,,)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo temporario 2 													   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqTrab2 := CriaTrab( aCampos2 )
dbUseArea( .T.,, cArqTrab2, "TR2", if(.F. .OR. .F., !.F., NIL), .F. )
IndRegua("TR2",cArqTrab2,"PREFIXO + NUM + PARCELA + TIPO",,,)	
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre o SE2 com outro alias para ser localizado o titulo 	 ³
//³ do imposto                   										 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !( ChkFile("SE2",.F.,"NEWSE2") )
	Return(Nil)
EndIf

dbSelectArea("SA2")			
dbSetOrder(1)                                                                         
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega arquivo temporario 1	e 2											   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE2")
dbGoTop()

While SE2->(!Eof())   // SE2        

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega arquivo temporario 1	e 2											   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se o titulo for o principal alimenta o arquivo temporario 1 		   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	If SA2->(dbSeek(xFilial("SA2")+SE2->(E2_FORNECE+E2_LOJA)))
		If !Empty(cFilterSA2) .And. SA2->(!&(cFilterSA2))
			SE2->(DbSkip())		
			Loop
		Endif		
		If !Empty(cFilterSE2) .And. SE2->(!&(cFilterSE2))
			SE2->(DbSkip())		
			Loop
		Endif		
		If !Empty(cFilterSED)                       
			SED->(DbSetOrder(1))
			SED->(MsSeek(xFilial()+SE2->E2_NATUREZ)) 
			If SED->(!&(cFilterSED))
				SE2->(DbSkip())		
				Loop
			Endif
		Endif		
		dbSelectArea("TR1")
		RecLock("TR1",.T.)	
		TR1->CODIGO		:= SA2->A2_COD 
		TR1->LOJA  		:= SA2->A2_LOJA
		TR1->NOMEFOR	:= SA2->A2_NOME 
		TR1->CGC			:= SA2->A2_CGC
		TR1->PREFIXO	:= SE2->E2_PREFIXO
		TR1->NUM			:= SE2->E2_NUM
		TR1->PARCELA	:= SE2->E2_PARCELA
		TR1->TIPO		:= SE2->E2_TIPO
		TR1->NATUREZ	:= SE2->E2_NATUREZ
		TR1->EMISSAO	:= SE2->E2_EMISSAO
		TR1->VENCTO		:= SE2->E2_VENCREA

		If lContrRet .And. (SE2->E2_PRETPIS == "3" .or. SE2->E2_PRETCOF == "3" .or. SE2->E2_PRETCSL == "3")
			TR1->VALBASE	:= SE2->(E2_VALLIQ+E2_INSS+E2_IRRF+E2_ISS+E2_SEST)
		Else
			TR1->VALBASE	:= SE2->(E2_VALOR+E2_INSS+E2_IRRF+E2_ISS+E2_SEST)
		Endif

		If lContrRet
			If SE2->E2_PRETPIS <> "2" .or. SE2->E2_PRETCOF <> "2" .or. SE2->E2_PRETCSL <> "2"
				TR1->VALPIS		:= If(Empty(SE2->E2_VRETPIS), SE2->E2_PIS, SE2->E2_VRETPIS)
				TR1->VALCOF		:= If(Empty(SE2->E2_VRETCOF), SE2->E2_COFINS, SE2->E2_VRETCOF)
				TR1->VALCSLL	:= If(Empty(SE2->E2_VRETCSL), SE2->E2_CSLL, SE2->E2_VRETCSL)
				If !SE2->E2_PRETPIS $ "1#4" .or. !SE2->E2_PRETCOF $ "1#4" .or. !SE2->E2_PRETCSL $ "1#4"
					TR1->VALBASE	+= If(Empty(SE2->E2_VRETPIS), SE2->E2_PIS, SE2->E2_VRETPIS)
					If !lAglPCC			  
						TR1->VALBASE	+= If(Empty(SE2->E2_VRETCOF), SE2->E2_COFINS, SE2->E2_VRETCOF)
						TR1->VALBASE	+= If(Empty(SE2->E2_VRETCSL), SE2->E2_CSLL, SE2->E2_VRETCSL)
					EndIf
				EndIF						
				If SE2->E2_PRETPIS $ "3#4" .or. SE2->E2_PRETCOF $ "3#4" .or. SE2->E2_PRETCSL $ "3#4"
					If SE2->E2_VRETPIS + SE2->E2_VRETCOF + SE2->E2_VRETCSL > 0
						TR1->VAL10925V1 := SE2->E2_VRETPIS + SE2->E2_VRETCOF + SE2->E2_VRETCSL
					Else
						TR1->VAL10925V1 := 0
					Endif 
				Endif
			Else				
				TR1->VALPIS		:= SE2->E2_PIS
				TR1->VALCOF		:= SE2->E2_COFINS
				TR1->VALCSLL	:= SE2->E2_CSLL 
			Endif	
		Endif	

		TR1->PARCPIS	:= SE2->E2_PARCPIS
		TR1->PARCCOF	:= SE2->E2_PARCCOF
		TR1->PARCSLL	:= SE2->E2_PARCSLL
		TR1->VALIRFF	:= SE2->E2_IRRF
		TR1->PARCIR		:= SE2->E2_PARCIR
		TR1->VALISS		:= SE2->E2_ISS        
		TR1->PARCISS	:= SE2->E2_PARCISS
		TR1->VALINSS	:= SE2->E2_INSS
		TR1->PARCINS	:= SE2->E2_PARCINS
		TR1->PARCCSS	:= SE2->E2_PARCCSS
		TR1->VALSEST	:= SE2->E2_SEST  
		TR1->PARCSES	:= SE2->E2_PARCSES

		If SE2->E2_PRETPIS $ "3" .or. SE2->E2_PRETCOF $ "3" .or. SE2->E2_PRETCSL $ "3" .And.;
			SE2->E2_VRETPIS + SE2->E2_VRETCOF + SE2->E2_VRETCSL > 0
			TR1->VALLIQ		:= SE2->E2_VALLIQ
		ElseIf SE2->E2_PRETPIS $ "4" .or. SE2->E2_PRETCOF $ "4" .or. SE2->E2_PRETCSL $ "4" .And.;
			SE2->E2_VRETPIS + SE2->E2_VRETCOF + SE2->E2_VRETCSL > 0
			TR1->VALLIQ		:= SE2->E2_VALOR - TR1->VAL10925V1				
		Else
			TR1->VALLIQ		:= SE2->E2_VALOR
		Endif
		MSUnlock()
	Endif
	
	aTps := {"TX ","INS","ISS"}
	aParc := {SE2->E2_PARCIR,SE2->E2_PARCINS,SE2->E2_PARCISS}
	Aadd(aParc, SE2->E2_PARCPIS)
	Aadd(aParc, SE2->E2_PARCCOF)
	Aadd(aParc, SE2->E2_PARCSLL)
	Aadd(aTps , "TX ")
	Aadd(aTps , "TX ")
	Aadd(aTps , "TX ") // aTps deve ter o mesmo tamanho de aParc
	
	DbSelectArea("NEWSE2")
	For x := 1 to Len(aTps)
		// Procura o titulo de imposto no alias alternativo.
		If NEWSE2->(Dbseek(xFilial("SE2")+SE2->E2_PREFIXO+SE2->E2_NUM+aParc[x]+aTps[x]))
			If !Empty(cFilterImp) .And. NEWSE2->(!&(cFilterImp))
				Loop
			Endif		
			dbSelectArea("TR2")
			RecLock("TR2",.T.)	
			TR2->CODIGO		:= SA2->A2_COD 
			TR2->LOJA  		:= SA2->A2_LOJA
			TR2->NOMEFOR	:= SA2->A2_NOME 
			TR2->CGC			:= SA2->A2_CGC
			TR2->PREFIXO	:= NEWSE2->E2_PREFIXO
			TR2->NUM			:= NEWSE2->E2_NUM
			TR2->PARCELA	:= NEWSE2->E2_PARCELA
			TR2->TIPO		:= NEWSE2->E2_TIPO
			TR2->NATUREZ	:= NEWSE2->E2_NATUREZ
			TR2->EMISSAO	:= NEWSE2->E2_EMISSAO
			TR2->VENCTO		:= NEWSE2->E2_VENCREA  
			If MV_PAR09 = 1  //1,valor original 2,saldo
			   TR2->VALBASE	:= NEWSE2->E2_VALOR
			Else                               
			   TR2->VALBASE	:= NEWSE2->E2_SALDO
			EndIf   
			MSUnlock()
		Endif
	Next
	dbSelectArea("SE2")
	dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Define valores da Secao 1  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1:Cell("TR1_COD"):SetBlock({||TR1->CODIGO})
oSection1:Cell("TR1_LOJA"):SetBlock({||TR1->LOJA})
oSection1:Cell("TR1_NOME"):SetBlock({||TR1->NOMEFOR})
oSection1:Cell("TR1_CGC"):SetBlock({||TR1->CGC})
oSection1:Cell("TR1_PREFIXO"):SetBlock({||TR1->PREFIXO})
oSection1:Cell("TR1_NUM"):SetBlock({||TR1->NUM})
oSection1:Cell("TR1_PARCELA"):SetBlock({||TR1->PARCELA})
oSection1:Cell("TR1_TIPO"):SetBlock({||TR1->TIPO})
oSection1:Cell("TR1_NATUREZ"):SetBlock({||TR1->NATUREZ})
oSection1:Cell("TR1_EMISSAO"):SetBlock({||TR1->EMISSAO})
oSection1:Cell("TR1_VENCREA"):SetBlock({||TR1->VENCTO})
oSection1:Cell("TR1_VALBASE"):SetBlock({||TR1->VALBASE})
oSection1:Cell("TR1_VALLIQ"):Hide()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Define valores da Secao 2  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection2:Cell("TR2_COD"):Hide()
oSection2:Cell("TR2_LOJA"):Hide()
oSection2:Cell("TR2_NOME"):Hide()
oSection2:Cell("TR2_CGC"):Hide()
oSection2:Cell("TR2_PREFIXO"):SetBlock({||TR2->PREFIXO})
oSection2:Cell("TR2_NUM"):SetBlock({||TR2->NUM})
oSection2:Cell("TR2_PARCELA"):SetBlock({||TR2->PARCELA})
oSection2:Cell("TR2_TIPO"):SetBlock({||TR2->TIPO})
oSection2:Cell("TR2_NATUREZ"):SetBlock({||TR2->NATUREZ})
oSection2:Cell("TR2_EMISSAO"):SetBlock({||TR2->EMISSAO})
oSection2:Cell("TR2_VENCREA"):SetBlock({||TR2->VENCTO})
oSection2:Cell("TR2_VALIMP"):SetBlock({||TR2->VALBASE})
oSection2:Cell("TR2_VALLIQ"):Hide()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Define valores da Secao 3  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
oSection3:Cell("TOT_COD"):SetBlock({||STR0011}) //"Totais ------>"
oSection3:Cell("TOT_LOJA"):Hide() 
oSection3:Cell("TOT_NOME"):Hide() 
oSection3:Cell("TOT_CGC"):Hide() 
oSection3:Cell("TOT_PREFIXO"):Hide()
oSection3:Cell("TOT_NUM"):Hide() 
oSection3:Cell("TOT_PARCELA"):Hide() 
oSection3:Cell("TOT_TIPO"):Hide() 
oSection3:Cell("TOT_NATUREZ"):Hide()
oSection3:Cell("TOT_EMISSAO"):Hide()
oSection3:Cell("TOT_VENCREA"):Hide()
oSection3:Cell("TR1_VALBASE"):SetBlock({||TR1->VALBASE})
oSection3:Cell("TOT_VALIMP"):SetBlock({||nValImp})
oSection3:Cell("TR1_VALLIQ"):SetBlock({||TR1->VALLIQ})
*/
dbSelectArea("TR1")
TR1->(dbGoTop())
TR2->(dbGoTop())

oReport:SetMeter(TR1->(RecCount()))

oSection1:NoUserFilter()
oSection2:NoUserFilter()

While !EOF() .AND. !oReport:Cancel()

	If oReport:Cancel()
		Exit
	EndIf              

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica se a emissao dos Tx's estao ocorrendo na baixa.            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lContrRet .And. lPCCBaixa
		bCond := "TR1->VAL10925V1 > 0"
	Else                                       
		bCond := "(TR1->VALLIQ <> TR1->VALBASE)"
	Endif 

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica se a emissao dos Tx's estao ocorrendo na baixa.            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lContrRet .And. lPCCBaixa
		bCond := "TR1->VAL10925V1 > 0"
	Else                                       
		bCond := "(TR1->VALLIQ <> TR1->VALBASE)"
	Endif 
	
	If Len(Alltrim(TR1->CGC)) == 11
		oSection1:Cell("TR1_CGC"):SetPicture("@R 999.999.999-99")
		oSection2:Cell("TR2_CGC"):SetPicture("@R 999.999.999-99")
	Else
		oSection1:Cell("TR1_CGC"):SetPicture("@R 99.999.999/9999-99")
		oSection2:Cell("TR2_CGC"):SetPicture("@R 99.999.999/9999-99")
	EndIf
	
	If &bCond
		oSection1:Init()
		oReport:ThinLine()
		oSection1:PrintLine()
		oReport:ThinLine()
		oSection1:Finish()
	
		cTx	:= Iif(TR1->TIPO $ MVPAGANT+"/"+MV_CPNEG,MVTXA,MVTAXA)
		cIss	:= MVISS
		cIns	:= MVINSS
		
	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³ Adicionar a matriz a referencia do titulo de imposto (caso exista)  ³
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
	   If !Empty(TR1->PARCIR)
			Aadd(aParcela,{TR1->PREFIXO,TR1->NUM,TR1->PARCIR,cTx})
		Endif                 
	   If !Empty(TR1->PARCISS)
			Aadd(aParcela,{TR1->PREFIXO,TR1->NUM,TR1->PARCISS,cIss})
		Endif
		If !Empty(TR1->PARCINS)	
			Aadd(aParcela,{TR1->PREFIXO,TR1->NUM,TR1->PARCINS,cIns})
		Endif
		If !Empty(TR1->PARCCSS)		
			Aadd(aParcela,{TR1->PREFIXO,TR1->NUM,TR1->PARCCSS,cTx})
		Endif                      
		If !Empty(TR1->PARCCOF)		
			Aadd(aParcela,{TR1->PREFIXO,TR1->NUM,TR1->PARCCOF,cTx})
		Endif
		If !Empty(TR1->PARCPIS)				
			Aadd(aParcela,{TR1->PREFIXO,TR1->NUM,TR1->PARCPIS,cTx})
		Endif                            
		If !Empty(TR1->PARCSLL)				
			Aadd(aParcela,{TR1->PREFIXO,TR1->NUM,TR1->PARCSLL,cTx})
		Endif
		If !Empty(TR1->PARCSES)				
			Aadd(aParcela,{TR1->PREFIXO,TR1->NUM,TR1->PARCSLL,"SES"})
		Endif

	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³ Se o titulo nao tiver impostos nao imprime os totais                ³
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
		If Len(aParcela) >= 1

		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³ Faz a busca/impressao do titulo de imposto                          ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		   lFirst := .T.
		   oSection2:Init()   
			For x:= 1 to Len(aParcela)            
		   	If (TR2->(DbSeek(aParcela[x][1] + aParcela[x][2] + aParcela[x][3]+ aParcela[x][4] ))) 
					oSection2:PrintLine()
				Endif
			Next	               
			oSection2:Finish()

			aParcela := {}			   
         oReport:SkipLine()
         
 		Endif
	Endif
   TR1->(dbSkip()) // Avanca o ponteiro do registro no arquivo
  	oReport:IncMeter()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("NEWSE2")
NEWSE2->(DbCloseArea())

dbSelectArea("SE2")
dbClearFil()
RetIndex( "SE2" )
If !Empty(cIndexSE2)
	FErase (cIndexSE2+OrdBagExt())
Endif
dbSetOrder(1)

TR1->(dbCloseArea())
TR2->(dbCloseArea())
fErase( cArqTrab1 + GetDBExtension() )
fErase( cArqTrab1 + OrdBagExt() )
fErase( cArqTrab2 + GetDBExtension() )
fErase( cArqTrab2 + OrdBagExt() )

Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINR855   º Autor ³ Nilton Pereira     º Data ³  04/05/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio para impressao do titulo principal x titulos de  º±±
±±º          ³ impostos gerados                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Finr855R3()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1         := STR0001 //"Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := STR0002 //"com a relação Titulo Principal X Impostos, de "
Local cDesc3         := STR0003 //"acordo com os parametros informados pelo usuario."
Local cPict          := ""
Local titulo         := STR0004 //"Relacao - Titulo Principal X Impostos"
Local nLin         	 := 80
                                                                         
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Regua para impressao                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//                                 10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210
//                       01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local cabec1            := STR0005  //" Codigo/Loja     Nome Fornecedor                               CNPJ                 Pref    Numero   Parc           Tipo   Natureza            Emissao   Vencimento            Valor Bruto       Impostos       Valor Lq"

Local Cabec2         	:= ""
Local imprime       	:= .T.
Local aOrd 				:= {STR0013,STR0014} //"Por Codigo Fornecedor"###"Por Nome Fornecedor"}
Local cPerg				:= "RFIN020"      

Private lEnd			:= .F.
Private lAbortPrint 	:= .F.
Private CbTxt			:= ""
Private limite			:= 220
Private tamanho	     	:= "G"
Private nomeprog        := "RFIN020" 
Private nTipo           := 18
Private aReturn         := { STR0006, 1, STR0007, 2, 2, 1, "", 1} //"Zebrado"###"Administracao"
Private nLastKey        := 0
Private cbcont          := 00
Private CONTFL   	  	:= 01
Private m_pag    	  	:= 01
Private wnrel    	  	:= "RFIN020"
Private cString 		:= "SE2"

dbSelectArea("SE2")
dbSetOrder(1)

Pergunte("RFIN020",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
RptStatus({|| Fa855Imp(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³Fa855Imp  º Autor ³ Nilton Pereira     º Data ³  04/05/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Fa855Imp(Cabec1,Cabec2,Titulo,nLin)

Local x   
Local cIndexSe2
Local cChaveSe2   
Local cTx			:= ""   
Local cIss			:= ""   
Local cIns			:= ""   
Local nValImp  	:= 0
Local nOrdem 		:= aReturn[8]   
Local aParcela 	:= {}
Local aTamNum		:= TAMSX3("E2_NUM")
Local cFilterUser := aReturn[7]
Local	aTps 
Local	aParc
Local bCond
Local aCampos1	:= {	{"CODIGO"	,"C",10,0 },; 
							{"NOMEFOR"	,"C",40,0 },;
							{"CGC"		,"C",14,0 },;
							{"PREFIXO"	,"C",03,0 },;
							{"NUM"		,"C",aTamNum[1],0 },;
							{"PARCELA"	,"C",TamSx3("E2_PARCELA")[1],0 },;
							{"TIPO"		,"C",03,0 },;
							{"NATUREZ"	,"C",10,0 },;							
							{"EMISSAO"	,"D",10,0 },;
							{"VENCTO"	,"D",10,0 },;
							{"VALBASE"  ,"N",17,2 },;
							{"VALINSS"	,"N",17,2 },;
							{"VALPIS"	,"N",17,2 },;
							{"VALCOF"	,"N",17,2 },;
							{"VALCSLL"	,"N",17,2 },;
							{"VALIRFF"	,"N",17,2 },;
							{"VALISS"	,"N",17,2 },;
							{"VALSEST"	,"N",17,2 },;
							{"PARCSES"	,"C",TamSx3("E2_PARCELA")[1],0 },;
							{"PARCIR"	,"C",TamSx3("E2_PARCELA")[1],0 },;
							{"PARCISS"	,"C",TamSx3("E2_PARCELA")[1],0 },;
							{"PARCINS"	,"C",TamSx3("E2_PARCELA")[1],0 },;
							{"PARCCSS"	,"C",TamSx3("E2_PARCELA")[1],0 },;
							{"PARCCOF"	,"C",TamSx3("E2_PARCELA")[1],0 },;
							{"PARCPIS"	,"C",TamSx3("E2_PARCELA")[1],0 },;
							{"PARCSLL"	,"C",TamSx3("E2_PARCELA")[1],0 },;
							{"VALLIQ"	,"N",17,2 },;
							{"VAL10925V1","N",17,2 }}
Local aCampos2	:= {	{"CODIGO"	,"C",10,0 },;
							{"NOMEFOR"	,"C",40,0 },;
							{"CGC"		,"C",14,0 },;
							{"PREFIXO"	,"C",03,0 },;
							{"NUM"		,"C",aTamNum[1],0 },;
							{"PARCELA"	,"C",TamSx3("E2_PARCELA")[1],0 },;
							{"TIPO"		,"C",03,0 },;
							{"NATUREZ"	,"C",10,0 },;							
							{"EMISSAO"	,"D",10,0 },;
							{"VENCTO"	,"D",10,0 },;
							{"VALBASE"  ,"N",17,2 } }
Local lContrRet := !Empty( SE2->( FieldPos( "E2_VRETPIS" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE2->( FieldPos( "E2_VRETCSL" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETPIS" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_PRETCOF" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETCSL" ) ) )

//Controla o Pis Cofins e Csll na baixa
Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )

Local lAglPCC := SuperGetMv("MV_AG10925",.F.,"2") == "1"
							
dbSelectArea(cString)
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Efetua filro              													   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cChaveSe2 := IndexKey()
cIndexSe2 := CriaTrab(Nil,.f.)
IndRegua("SE2",cIndexSe2,cChaveSe2,,FR855IndR(),STR0008) //"Selecionando Registros..."
                                                                         
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo temporario 1  													   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqTrab1 := CriaTrab( aCampos1 )
dbUseArea( .T.,, cArqTrab1, "TR1", if(.F. .OR. .F., !.F., NIL), .F. )
If nOrdem == 1
	IndRegua("TR1",cArqTrab1,"CODIGO + PREFIXO + NUM + PARCELA",,,)
Else
	IndRegua("TR1",cArqTrab1,"NOMEFOR + PREFIXO + NUM + PARCELA",,,)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo temporario 2 													   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqTrab2 := CriaTrab( aCampos2 )
dbUseArea( .T.,, cArqTrab2, "TR2", if(.F. .OR. .F., !.F., NIL), .F. )
IndRegua("TR2",cArqTrab2,"PREFIXO + NUM + PARCELA + TIPO",,,)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre o SE2 com outro alias para ser localizado o titulo 	 ³
//³ do imposto                   										 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !( ChkFile("SE2",.F.,"NEWSE2") )
	Return(Nil)
EndIf

dbSelectArea("SA2")			
dbSetOrder(1)                                                                         
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega arquivo temporario 1	e 2											   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE2")

While SE2->(!Eof())   // SE2        

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega arquivo temporario 1	e 2											   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se o titulo for o principal alimenta o arquivo temporario 1 		   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	If SA2->(dbSeek(xFilial("SA2")+SE2->(E2_FORNECE+E2_LOJA)))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Considera filtro do usuario                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(cFilterUser).and.!(&cFilterUser)
			SE2->(dbSkip())		
			Loop
		Endif		

		dbSelectArea("TR1")
		RecLock("TR1",.T.)	
		TR1->CODIGO		:= SA2->A2_COD +" "+ SA2->A2_LOJA
		TR1->NOMEFOR	:= SA2->A2_NOME 
		TR1->CGC			:= SA2->A2_CGC
		TR1->PREFIXO	:= SE2->E2_PREFIXO
		TR1->NUM			:= SE2->E2_NUM
		TR1->PARCELA	:= SE2->E2_PARCELA
		TR1->TIPO		:= SE2->E2_TIPO
		TR1->NATUREZ	:= SE2->E2_NATUREZ
		TR1->EMISSAO	:= SE2->E2_EMISSAO
		TR1->VENCTO		:= SE2->E2_VENCREA

		If lContrRet .And. (SE2->E2_PRETPIS == "3" .or. SE2->E2_PRETCOF == "3" .or. SE2->E2_PRETCSL == "3")
			TR1->VALBASE	:= SE2->(E2_VALLIQ+E2_INSS+E2_IRRF+E2_ISS+E2_SEST)
		Else
			TR1->VALBASE	:= SE2->(E2_VALOR+E2_INSS+E2_IRRF+E2_ISS+E2_SEST)
		Endif

		If lContrRet
			If SE2->E2_PRETPIS <> "2" .or. SE2->E2_PRETCOF <> "2" .or. SE2->E2_PRETCSL <> "2"
				TR1->VALPIS		:= If(Empty(SE2->E2_VRETPIS), SE2->E2_PIS, SE2->E2_VRETPIS)
				TR1->VALCOF		:= If(Empty(SE2->E2_VRETCOF), SE2->E2_COFINS, SE2->E2_VRETCOF)
				TR1->VALCSLL	:= If(Empty(SE2->E2_VRETCSL), SE2->E2_CSLL, SE2->E2_VRETCSL)
				If !SE2->E2_PRETPIS $ "1#4" .or. !SE2->E2_PRETCOF $ "1#4" .or. !SE2->E2_PRETCSL $ "1#4"				
					TR1->VALBASE	+= If(Empty(SE2->E2_VRETPIS), SE2->E2_PIS, SE2->E2_VRETPIS)
					If !lAglPCC
						TR1->VALBASE	+= If(Empty(SE2->E2_VRETCOF), SE2->E2_COFINS, SE2->E2_VRETCOF)
						TR1->VALBASE	+= If(Empty(SE2->E2_VRETCSL), SE2->E2_CSLL, SE2->E2_VRETCSL)
					EndIf
				EndIF						
				If SE2->E2_PRETPIS $ "3#4" .or. SE2->E2_PRETCOF $ "3#4" .or. SE2->E2_PRETCSL $ "3#4"
					If SE2->E2_VRETPIS + SE2->E2_VRETCOF + SE2->E2_VRETCSL > 0
						TR1->VAL10925V1 := SE2->E2_VRETPIS + SE2->E2_VRETCOF + SE2->E2_VRETCSL
					Else
						TR1->VAL10925V1 := 0
					Endif 
				Endif
			Else				
				TR1->VALPIS		:= SE2->E2_PIS
				TR1->VALCOF		:= SE2->E2_COFINS
				TR1->VALCSLL	:= SE2->E2_CSLL 
			Endif	
		Endif	

		TR1->PARCPIS	:= SE2->E2_PARCPIS
		TR1->PARCCOF	:= SE2->E2_PARCCOF
		TR1->PARCSLL	:= SE2->E2_PARCSLL
		TR1->VALIRFF	:= SE2->E2_IRRF
		TR1->PARCIR		:= SE2->E2_PARCIR
		TR1->VALISS		:= SE2->E2_ISS        
		TR1->PARCISS	:= SE2->E2_PARCISS
		TR1->VALINSS	:= SE2->E2_INSS
		TR1->PARCINS	:= SE2->E2_PARCINS
		TR1->PARCCSS	:= SE2->E2_PARCCSS
		TR1->VALSEST	:= SE2->E2_SEST  
		TR1->PARCSES	:= SE2->E2_PARCSES

		If SE2->E2_PRETPIS $ "3" .or. SE2->E2_PRETCOF $ "3" .or. SE2->E2_PRETCSL $ "3" .And.;
			SE2->E2_VRETPIS + SE2->E2_VRETCOF + SE2->E2_VRETCSL > 0
			TR1->VALLIQ		:= SE2->E2_VALLIQ
		ElseIf SE2->E2_PRETPIS $ "4" .or. SE2->E2_PRETCOF $ "4" .or. SE2->E2_PRETCSL $ "4" .And.;
			SE2->E2_VRETPIS + SE2->E2_VRETCOF + SE2->E2_VRETCSL > 0
			TR1->VALLIQ		:= SE2->E2_VALOR - TR1->VAL10925V1				
		Else
			TR1->VALLIQ		:= SE2->E2_VALOR
		Endif
		MSUnlock()
	Endif
	
	aTps := {"TX ","INS","ISS"}
	aParc := {SE2->E2_PARCIR,SE2->E2_PARCINS,SE2->E2_PARCISS}
	Aadd(aParc, SE2->E2_PARCPIS)
	Aadd(aParc, SE2->E2_PARCCOF)
	Aadd(aParc, SE2->E2_PARCSLL)
	Aadd(aTps , "TX ")
	Aadd(aTps , "TX ")
	Aadd(aTps , "TX ") // aTps deve ter o mesmo tamanho de aParc
	
	DbSelectArea("NEWSE2")
	For x := 1 to Len(aTps)
		// Procura o titulo de imposto no alias alternativo.
		If NEWSE2->(Dbseek(xFilial("SE2")+SE2->E2_PREFIXO+SE2->E2_NUM+aParc[x]+aTps[x]))
			dbSelectArea("TR2")
			RecLock("TR2",.T.)	
			TR2->CODIGO		:= SA2->A2_COD +" "+ SA2->A2_LOJA
			TR2->NOMEFOR	:= SA2->A2_NOME 
			TR2->CGC			:= SA2->A2_CGC
			TR2->PREFIXO	:= NEWSE2->E2_PREFIXO
			TR2->NUM			:= NEWSE2->E2_NUM
			TR2->PARCELA	:= NEWSE2->E2_PARCELA
			TR2->TIPO		:= NEWSE2->E2_TIPO
			TR2->NATUREZ	:= NEWSE2->E2_NATUREZ
			TR2->EMISSAO	:= NEWSE2->E2_EMISSAO
			TR2->VENCTO		:= NEWSE2->E2_VENCREA
			If MV_PAR09 = 1  //1,valor original 2,saldo
			   TR2->VALBASE	:= NEWSE2->E2_VALOR
			Else                               
			   TR2->VALBASE	:= NEWSE2->E2_SALDO
			EndIf   
			MSUnlock()
		Endif
	Next
	dbSelectArea("SE2")
	dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(TR1->(RecCount()))
          
dbSelectArea("TR1")
TR1->(dbGoTop())
TR2->(dbGoTop())

While !EOF()

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If lAbortPrint
      @nLin,00 PSAY STR0009 //"*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If nLin > 55 // Salto de Pagina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica se a emissao dos Tx's estao ocorrendo na baixa.            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lContrRet .And. lPCCBaixa
		bCond := "TR1->VAL10925V1 > 0"
	Else                                       
		bCond := "(TR1->VALLIQ <> TR1->VALBASE)"
	Endif 

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Se o titulo nao tiver impostos, nao imprime o titulo principal      ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If &bCond
	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³ Inicia impressao do titulo principal . .                            ³
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		@nLin,000 PSAY __PrtfatLine()
		nLin++		
		
		@nLin, 001 PSAY TR1->CODIGO     
		@nLin, 017 PSAY TR1->NOMEFOR   
		@nLin, 063 PSAY TR1->CGC       Picture IIF(Len(Alltrim(TR1->CGC)) == 11 , "@R 999.999.999-99","@R 99.999.999/9999-99")
		@nLin, 084 PSAY TR1->PREFIXO   
		@nLin, 092 PSAY TR1->NUM       
		@nLin, 101 PSAY TR1->PARCELA   
		@nLin, 116 PSAY TR1->TIPO      
		@nLin, 123 PSAY TR1->NATUREZ   
		@nLin, 143 PSAY TR1->EMISSAO   
		@nLin, 155 PSAY TR1->VENCTO    
		@nLin, 171 PSAY TR1->VALBASE   Picture Tm(TR1->VALBASE ,15) 
	
	   nLin := nLin + 1 // Avanca a linha de impressao
	        
		@nLin,000 PSAY  __PrtfatLine()
		nLin++		
	                                                        
		cTx	:= Iif(TR1->TIPO $ MVPAGANT+"/"+MV_CPNEG,MVTXA,MVTAXA)
		cIss	:= MVISS
		cIns	:= MVINSS
		
	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³ Adicionar a matriz a referencia do titulo de imposto (caso exista)  ³
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
	   If !Empty(TR1->PARCIR)
			Aadd(aParcela,{TR1->PREFIXO,TR1->NUM,TR1->PARCIR,cTx})
		Endif                 
	   If !Empty(TR1->PARCISS)
			Aadd(aParcela,{TR1->PREFIXO,TR1->NUM,TR1->PARCISS,cIss})
		Endif
		If !Empty(TR1->PARCINS)	
			Aadd(aParcela,{TR1->PREFIXO,TR1->NUM,TR1->PARCINS,cIns})
		Endif
		If !Empty(TR1->PARCCSS)		
			Aadd(aParcela,{TR1->PREFIXO,TR1->NUM,TR1->PARCCSS,cTx})
		Endif                      
		If !Empty(TR1->PARCCOF)		
			Aadd(aParcela,{TR1->PREFIXO,TR1->NUM,TR1->PARCCOF,cTx})
		Endif
		If !Empty(TR1->PARCPIS)				
			Aadd(aParcela,{TR1->PREFIXO,TR1->NUM,TR1->PARCPIS,cTx})
		Endif                            
		If !Empty(TR1->PARCSLL)				
			Aadd(aParcela,{TR1->PREFIXO,TR1->NUM,TR1->PARCSLL,cTx})
		Endif
		If !Empty(TR1->PARCSES)				
			Aadd(aParcela,{TR1->PREFIXO,TR1->NUM,TR1->PARCSLL,"SES"})
		Endif
	
	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³ Se o titulo nao tiver impostos nao imprime os totais                ³
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
		If Len(aParcela) >= 1
		  	@nLin, 000 PSAY STR0010      //"Impostos ---->"		
		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		   //³ Faz a busca/impressao do titulo de imposto                          ³
		   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
			For x:= 1 to Len(aParcela)
			   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			   //³ Impressao do cabecalho do relatorio. . .                            ³
			   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			   If nLin > 55 // Salto de Pagina. Neste caso o formulario tem 55 linhas...
			      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			      nLin := 8                      
		     	  	@nLin, 000 PSAY STR0010      //"Impostos ---->"
			   Endif                              
			   If (TR2->(DbSeek(aParcela[x][1] + aParcela[x][2] + aParcela[x][3]+ aParcela[x][4] ))) 
		//		  	@nLin, 001 PSAY TR2->CODIGO     
		//			@nLin, 017 PSAY TR2->NOMEFOR   
		//			@nLin, 063 PSAY TR2->CGC       Picture IIF(Len(Alltrim(TR2->CGC)) == 11 , "@R 999.999.999-99","@R 99.999.999/9999-99")
					@nLin, 084 PSAY TR2->PREFIXO   
					@nLin, 092 PSAY TR2->NUM       
					@nLin, 101 PSAY TR2->PARCELA   
					@nLin, 116 PSAY TR2->TIPO      
					@nLin, 123 PSAY TR2->NATUREZ   
					@nLin, 143 PSAY TR2->EMISSAO   
					@nLin, 155 PSAY TR2->VENCTO    
					@nLin, 186 PSAY TR2->VALBASE   Picture Tm(TR2->VALBASE ,15) 
					nLin++
				Endif
			Next	                    
			
			aParcela := {}
			
		   If nLin > 53 // Salto de Pagina. Neste caso o formulario tem 55 linhas...
		      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		      nLin := 8
		   Endif
		
			@nLin,000 PSAY __PrtThinLine()
			nLin++			                  
		                  
			nValImp := TR1->VALBASE - TR1->VALLIQ   
		
			@nLin, 000 PSAY STR0011 //"Totais ------>"
			@nLin, 171 PSAY TR1->VALBASE Picture Tm(TR1->VALBASE,15)
			@nLin, 186 PSAY nValImp Picture Tm(TR1->VALBASE,15)
			@nLin, 201 PSAY TR1->VALLIQ Picture Tm(TR1->VALBASE,15)
			nLin++			                  
			   
			@nLin,000 PSAY __PrtThinLine()
			nLin++			                  
	   Endif
	Endif
   TR1->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN      
dbSelectArea("NEWSE2")
DbCloseArea()

dbSelectArea("SE2")
dbClearFil()
RetIndex( "SE2" )
If !Empty(cIndexSE2)
	FErase (cIndexSE2+OrdBagExt())
Endif
dbSetOrder(1)
TR1->(dbCloseArea())
TR2->(dbCloseArea())
fErase( cArqTrab1 + GetDBExtension() )
fErase( cArqTrab1 + OrdBagExt() )
fErase( cArqTrab2 + GetDBExtension() )
fErase( cArqTrab2 + OrdBagExt() )

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


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³FR855IndR ³ Autor ³Nilton Pereira         ³ Data ³ 24.03.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Monta Indregua para impressao do relat¢rio (CodeBase)       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³Financeiro                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FR855IndR()
Local cFiltro

cFiltro := 'E2_FILIAL=="'+xFilial("SE2")+'".And.'
cFiltro += 'E2_FORNECE>="'+mv_par01+'".and.E2_FORNECE<="'+mv_par02+'".And.'
cFiltro += 'E2_LOJA>="'+mv_par03+'".And.E2_LOJA<="'+mv_par04+'".And.'
// Nao inclui os titulos de impostos
cFiltro += '!(E2_TIPO$"'+MVISS+"/"+MVTAXA+"/"+MVTXA+"/"+MVINSS +"/" + "SES"+'").And.'
cFiltro += 'DTOS(E2_EMISSAO)>="'+DTOS(mv_par05)+'".And.DTOS(E2_EMISSAO)<="'+DTOS(mv_par06)+'".And.'
cFiltro += 'DTOS(E2_EMISSAO)<="'+DTOS(dDataBase)+'".And.'
cFiltro += 'DTOS(E2_VENCREA)>="'+DTOS(mv_par07)+'".And.DTOS(E2_VENCREA)<="'+DTOS(mv_par08)+'"'

Return cFiltro