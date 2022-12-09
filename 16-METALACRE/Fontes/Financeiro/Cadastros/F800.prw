#INCLUDE "fina800.ch"
#INCLUDE "PROTHEUS.CH"

Static lFWCodFil := FindFunction("FWCodFil")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FINA800  ³ Autor ³ Totvs                 ³ Data ³ 25/05/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de recalculo de Saldos de Naturezas 	           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FINA800()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Gen‚rico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function F800(lDireto)

LOCAL nOpca			:=0
LOCAL aSays			:={}
LOCAL aButtons		:={}
LOCAL cProcessa		:= ""
LOCAL cFunction		:= "FINA800"
LOCAL cTitle		:= STR0001 //"Recálculo de Saldos de Naturezas Financeiras"
Local cDescricao	:=	STR0002 +;  //"Este programa tem por objetivo recalcular e atualizar os saldos das "
						STR0003 +; //"naturezas financeiras."
						STR0004 +; //"Utilizar para a carga inicial dos arquivos de saldos de naturezas   "
						STR0005						 	 //"financeiras ou em caso de defasagem nos saldos das naturezas."

Local bProcess
Local cPerg			:= "AFI800"
Local lFWModAc		:= FindFunction("FWModeAccess")
Local lGestCorp		:= .F.
Local lPrjCni 		:= FindFunction("ValidaCNI") .And. ValidaCNI()
Local cModoFilial 	:= ""
Local cModoUnNeg	:= ""
DEFAULT lDireto := .F.

Private cCadastro := STR0001 //"Recálculo de Saldos de Naturezas Financeiras"
/*
 * Verifica se o ambiente trabalha com a Gestão Corporativa
 */
If FindFunction("FWSizeFilial")
	lGestCorp := FWSizeFilial() > 2
EndIf

/*
 * Validação do compartilhamento das tabelas do fluxo de caixa por natureza financeira.
 * Compartilhamento de tabelas deve ser o mesmo para as seguintes tabelas:
 *
 * - FIV - Movimentos Diários Fluxo de Caixa por Natureza Financeira
 * - FIW - Movimentos Mensais Fluxo de Caixa por Natureza Financeira
 * - FIX - Cabeçalho Histórico Fluxo de Caixa por Natureza Financeira
 * - FIY - Itens Histórico Fluxo de Caixa por Natureza Financeira  
 */

cModoFilial := FWModeAccess("FIV",2)
cModoUnNeg	:= FWModeAccess("FIV",3)
                
If lPrjCni
	// Todas as tabelas do fluxo de caixa e a de naturezas financeiras com o compartilhamento "EXCLUSIVO"
	If FWModeAccess("FIV",2) == "E"  .AND. FWModeAccess("FIV",3) == "E"	.AND.;
		FWModeAccess("FIW",2) == "E" .AND. FWModeAccess("FIW",3) == "E"	.AND.;
		FWModeAccess("FIX",2) == "E" .AND. FWModeAccess("FIX",3) == "E"	.AND.;
		FWModeAccess("FIY",2) == "E" .AND. FWModeAccess("FIY",3) == "E"
		lProcessa := .T.
	// Todas as tabelas do fluxo de caixa e a de naturezas financeiras com o compartilhamento "COMPARTILHADO"
	ElseIf FWModeAccess("FIV",2) == "C"	.AND. FWModeAccess("FIV",3) == "C"	.AND.;
		FWModeAccess("FIW",2) == "C"	.AND. FWModeAccess("FIW",3) == "C" 	.AND.;
		FWModeAccess("FIX",2) == "C"	.AND. FWModeAccess("FIX",3) == "C" 	.AND.;
		FWModeAccess("FIY",2) == "C" 	.AND. FWModeAccess("FIY",3) == "C"
		lProcessa := .T.
	// Se o Compartilhamento não atende a forma correta, não permite execução
	Else
		lProcessa := .F.	
	EndIf
Else
	If  FWModeAccess("FIW",2) == cModoFilial .AND. 	FWModeAccess("FIX",2) == cModoFilial .AND. FWModeAccess("FIY",2) == cModoFilial .AND.; 
		FWModeAccess("FIW",3) == cModoUnNeg  .AND. FWModeAccess("FIX",3) == cModoUnNeg  .AND. FWModeAccess("FIY",3) == cModoUnNeg	
		lProcessa := .T.
	Else
		//-----------------------------------------------------------
		// Se o Compartilhamento não atende a forma correta, não permite execução
		//-----------------------------------------------------------
		lProcessa := .F.
	EndIf
EndIf

// Se o Compartilhamento não atende a forma correta, não permite execução	 
If !lProcessa
	Help(" ",1,"RECALSLDFC",,STR0017,1,0) //"Compartilhamento incorreto de tabelas do fluxo de caixa. Consulte o administrador de banco de dados."
	Return()
EndIf

//Verifica se o ambiente eh Top
If !IfDefTop()
	HELP(" ",1,"ONLYTOP")
	Return .F.
Endif

If !(AliasInDic("FIV") .AND. AliasInDic("FIW"))
	HELP(STR0016,1)
	Return .F.
EndIf

//Ajusta o grupo de perguntas
AjustaSX1()         

//====================================================================================================
// Grupo - AFI800
//----------------------------------------------------------------------------------------------------
// MV_PAR01 - Seleciona Filiais
// MV_PAR02 - Filial De
// MV_PAR03 - Filial Ate
// MV_PAR04 - Data De
// MV_PAR05 - Data Ate
// MV_PAR06 - Natureza De
// MV_PAR07 - Natureza Ate
// MV_PAR08 - Tipo de saldo a recalcular (1 = Todos / 2 = Orcados / 3 = Previstos / 4 = Realizados)
//====================================================================================================

Pergunte("AFI800",.F.)

If AdmGetRpo( "R1.1" )

	tNewProcess():New( cFunction, cTitle, {|oSelf| FA800FIL( MV_PAR02, MV_PAR03, oSelf, lGestCorp ) }, cDescricao, cPerg ) 

Else
	ProcLogIni( aButtons )

	AADD (aSays, STR0002) //"Este programa tem por objetivo recalcular e atualizar os saldos das "
	AADD (aSays, STR0003) //"naturezas financeiras."
	AADD (aSays, STR0004) //"Utilizar para a carga inicial dos arquivos de saldos de naturezas   "
	AADD (aSays, STR0005)  //"financeiras ou em caso de defasagem nos saldos das naturezas."
	
	AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}} )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
	AADD(aButtons, { 5,.T.,{|| Pergunte("AFI800",.T. ) } } )
	FormBatch( cCadastro, aSays, aButtons ,,,420)

	
	If nOpcA == 1
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o log de processamento   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ProcLogAtu("INICIO")

		Processa({|lEnd| FA800Fil( MV_PAR02, MV_PAR03, lGestCorp ) })

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o log de processamento   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ProcLogAtu("FIM")
	
	Endif
EndIf

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA800Fil  ºAutor  ³Mauricio Pequim Jr  º Data ³  21/09/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Executa o processamento para cada filial                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINA800                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA800Fil(cFilDe,cFilAte,oSelf,lGestCorp)
Local cFilIni 	:= cFIlAnt
Local aArea		:= GetArea()
Local nInc		:= 0
Local aSM0		:= AdmAbreSM0()
Local lRpo1_1	:= Iif(AdmGetRpo("R1.1") == .T.,.T.,.F.) 
Local nProcess	:= Len( aSM0 )
Local lSelecFil	:= .F.   

Default lGestCorp := .F.

If (!lGestCorp .AND. EMPTY(XFILIAL("FIV"))) .OR. (lGestCorp .AND. FwModeAccess("FIV",2) == "C")
	nProcess := 1
EndIf

If lRpo1_1
	oSelf:Savelog("INICIO")
	oSelf:SetRegua1(nProcess)
Else
	ProcRegua(nProcess)
Endif 

lSelecFil := MV_PAR01 == 1


If !lSelecFil 
	If lGestCorp
		cFilde := FWGETCODFILIAL
		cFiate := cFilde
	Else
		cFilde := xFilial("FIV" ) 
		cFiate := cFilde
	EndIf	
EndIf 


For nInc := 1 To nProcess
	If aSM0[nInc][1] == cEmpAnt .AND. IIf(lSelecFil,aSM0[nInc][2] >= cFilDe .AND. aSM0[nInc][2] <= cFilAte,aSM0[nInc][2] == cFilDe)
		cFilAnt := aSM0[nInc][2]
		If lRpo1_1
			oSelf:SaveLog( STR0006 + cFilAnt) //"MENSAGEM: Executando a apuracao da filial  "
	  	Else
			ProcLogAtu(STR0007,STR0008 + cFilAnt) //"MENSAGEM"###"Executando a apuracao da filial "
		EndIf	

		If lRpo1_1
			oSelf:IncRegua1(STR0008 + cFilAnt) //"Executando a apuracao da filial "
		Else
			IncProc()
		EndIf	

		If !FA800Proc(oSelf, nInc) 
			Exit
		EndIf

	EndIf
Next

If lRpo1_1
	oSelf:Savelog("FIM")
Endif

cFIlAnt := cFilIni
RestArea(aArea)
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AdmAbreSM0³ Autor ³ Orizio                ³ Data ³ 22/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna um array com as informacoes das filias das empresas ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AdmAbreSM0()
Local aArea			:= SM0->( GetArea() )
Local aAux			:= {}
Local aRetSM0		:= {}
Local lFWLoadSM0	:= FindFunction( "FWLoadSM0" )
Local lFWCodFilSM0 	:= FindFunction( "FWCodFil" )

If lFWLoadSM0
	aRetSM0	:= FWLoadSM0()
Else
	DbSelectArea( "SM0" )
	SM0->( DbGoTop() )
	While SM0->( !Eof() )
		aAux := { 	SM0->M0_CODIGO,;
					IIf( lFWCodFilSM0, FWGETCODFILIAL, SM0->M0_CODFIL ),;
					"",;
					"",;
					"",;
					SM0->M0_NOME,;
					SM0->M0_FILIAL }

		aAdd( aRetSM0, aClone( aAux ) )
		SM0->( DbSkip() )
	End
EndIf

RestArea( aArea )
Return aRetSM0


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Fa800Proc ³ Autor ³ Mauricio Pequim Jr   ³ Data ³ 25.05.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Recalcula os saldos das naturezas                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Fa800Proc()		                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Void                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fa800Proc( oSelf, nInc)
Local lPrjCni := FindFunction("ValidaCNI") .And. ValidaCNI()
DEFAULT oSelf := NIL    


//Excluir as naturezas de cada data (diario)
F800DelSND(oSelf ,nInc)		

//Excluir as naturezas de cada data (mensal)
F800DelSNM(oSelf ,nInc)		
If lPrjCni
	//Excluir as naturezas de cada data (mensal) FJV - Analitico
	F800DelFJV(oSelf ,nInc)		
EndIf	

//Calculo dos saldos Orcados 
//SE7 - Orcamentos por Naturezas
If mv_par08 < 3 
	If  !F800VLDSE7()
		Return(.F.)
	EndIf
	F800SOSE7(oSelf ,nInc)	
Endif

//Calculo dos saldos Previstos - DIARIO
If mv_par08 == 1 .or. mv_par08 == 3

	//Calculo dos saldos Previstos - Receber (SE1 exceto Multinatureza)			
	F800SPSE1(oSelf ,nInc)

	//Calculo dos saldos Previstos - Pagar (SE2 exceto Multinatureza)			
	F800SPSE2(oSelf ,nInc)
	
	//Calculo dos saldos Previstos - Multinaturezas Receber Emissao
	F800SPSEV(oSelf ,nInc)

	//Calculo dos saldos Previstos - Comissoes	
	F800SPSE3(oSelf ,nInc)

Endif	

//Calculo dos saldos Realizados - DIARIO
If mv_par08 == 1 .or. mv_par08 == 4

	//Calculo dos saldos Realizados / Aplicacao / Emprestimo
	F800SRSE5(oSelf ,nInc)

	//Calculo dos saldos Realizados - Movimentos bancarios manuais
	F800SRMOV(oSelf ,nInc)
	
	//Calculo dos saldos Realizados - Multinaturezas Receber Baixas
	F800SRSEV(oSelf ,nInc)
Endif

//Calculo dos saldos - MENSAIS
F800SNMES(oSelf ,nInc)


Return(.T.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ F800DelSND ³ Autor ³ Mauricio Pequim Jr  ³ Data ³ 25.05.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Exclui saldos diarios das naturezas p/ reprocessamento	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ F800DelSND()	                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Void                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function F800DelSND(oSelf ,nInc)		

Local aArea			:= GetArea()
Local cQuery		:= ""
Local lProcessa	:= !(Empty(xFilial("FIV")) .And. nInc > 1)
Local cAliasQry	:= "TRB800A"

DEFAULT oSelf := NIL

dbSelectArea("FIV")
dbSetOrder(1)

If AdmGetRpo("R1.1") .and. oSelf <> nil
	oSelf:SetRegua2(RecCount())
EndIf

IF lProcessa

	cQuery := "SELECT FIV_FILIAL, FIV_NATUR, FIV_TPSALD, FIV_DATA, "
	cQuery += "	R_E_C_N_O_ RECNO FROM " + RetSQLTab('FIV')
	cQuery += " WHERE "
	cQuery += 	"FIV_DATA >='"+Dtos(mv_par04)+"' AND "
	cQuery += 	"FIV_DATA <='"+Dtos(mv_par05)+"' AND "
	cQuery += 	"FIV_NATUR >='"+ mv_par06 +"' AND "
	cQuery += 	"FIV_NATUR <='"+ mv_par07 +"' AND "
	
	Do Case
	//Orcado
	Case mv_par08 == 2
		cQuery += "FIV_TPSALD = '1' AND "
	//Previsto
	Case mv_par08 == 3
		cQuery += "FIV_TPSALD = '2' AND "   
	//Realizado
	Case mv_par08 == 4
		cQuery += "FIV_TPSALD = '3' AND "
	EndCase
	
	cQuery += RetSqlCond("FIV")

	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
	TcSetField(cAliasQry, "FIV_DATA", "D")
	
	
	dbSelectArea(cAliasQry)

	DbGotop()
	If !EOF() .AND. !BOF()	
		While !(cAliasQry)->(Eof())

			If AdmGetRpo("R1.1") .and. oSelf <> nil
				oSelf:IncRegua2(STR0009) //"Excluindo saldos diários das naturezas para recalculo..."
			EndIf	

			FIV->(dbGoto( (cAliasQry)->RECNO ) )
			RecLock("FIV")		
			dbDelete()
			Msunlock()
				
			dbSelectArea(cAliasQry)
			dbSkip()
		EndDo
	Endif	

	dbSelectArea(cAliasQry)
	dbCloseArea()
	fErase(cAliasQry + OrdBagExt())
	fErase(cAliasQry + GetDbExtension())

	dbSelectArea("FIV")
Endif

RestArea(aArea)
Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ F800DelSNM ³ Autor ³ Mauricio Pequim Jr  ³ Data ³ 25.05.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Exclui saldos mensais das naturezas p/ reprocessamento	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ F800DelSNM()	                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Void                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function F800DelSNM(oSelf ,nInc)		

Local aArea			:= GetArea()
Local cQuery		:= ""
Local lProcessa	:= !(Empty(xFilial("FIW")) .And. nInc > 1)
Local cAliasQry	:= "TRB800B"

DEFAULT oSelf := NIL

dbSelectArea("FIW")
dbSetOrder(1)

If AdmGetRpo("R1.1") .and. oSelf <> nil
	oSelf:SetRegua2(RecCount())
EndIf

IF lProcessa

	cQuery := "SELECT FIW_FILIAL, FIW_NATUR, FIW_TPSALD, FIW_DATA, "
	cQuery += "	R_E_C_N_O_ RECNO FROM " + RetSQLTab('FIW')
	cQuery += " WHERE "
	cQuery += 	"FIW_DATA >='"+Dtos(LastDay(mv_par04))+"' AND "
	cQuery += 	"FIW_DATA <='"+Dtos(LastDay(mv_par05))+"' AND "
	cQuery += 	"FIW_NATUR >='"+ mv_par06 +"' AND "
	cQuery += 	"FIW_NATUR <='"+ mv_par07 +"' AND "
	
	Do Case
	//Orcado
	Case mv_par08 == 2
		cQuery += "FIW_TPSALD = '1' AND "
	//Previsto
	Case mv_par08 == 3
		cQuery += "FIW_TPSALD = '2' AND "
	//Realizado
	Case mv_par08 == 4
		cQuery += "FIW_TPSALD = '3' AND "
	EndCase
	
	cQuery += RetSqlCond("FIW")

	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
	TcSetField(cAliasQry, "FIW_DATA", "D")
	
	
	dbSelectArea(cAliasQry)

	DbGotop()
	If !EOF() .AND. !BOF()	
		While !(cAliasQry)->(Eof())

			If AdmGetRpo("R1.1") .and. oSelf <> nil
				oSelf:IncRegua2(STR0010) //"Excluindo saldos mensais das naturezas para recalculo..."
			EndIf	

			FIW->(dbGoto( (cAliasQry)->RECNO ) )
			RecLock("FIW")		
			dbDelete()
			Msunlock()
				
			dbSelectArea(cAliasQry)
			dbSkip()
		EndDo
	Endif	

	dbSelectArea(cAliasQry)
	dbCloseArea()
	fErase(cAliasQry + OrdBagExt())
	fErase(cAliasQry + GetDbExtension())

	dbSelectArea("FIW")
Endif

RestArea(aArea)
Return(.T.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ F800SOSE7  ³ Autor ³ Mauricio Pequim Jr  ³ Data ³ 25.05.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Reprocessa Saldos Orcados                               	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ F800SOSE7() 	                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Void                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function F800SOSE7(oSelf ,nInc)		

Local aArea			:= GetArea()
Local cQuery		:= ""
Local lProcessa	:= !(Empty(xFilial("SE7")) .And. nInc > 1)
Local cAliasQry	:= "TRB800C"
Local dData			:= CTOD("")
Local nMes			:= 0
Local aValores		:= {}  


DEFAULT oSelf := NIL

dbSelectArea("SE7")
dbSetOrder(1)

If AdmGetRpo("R1.1") .and. oSelf <> nil
	oSelf:SetRegua2(RecCount())
EndIf

IF lProcessa

	cQuery := "SELECT R_E_C_N_O_ RECNO FROM " + RetSQLTab('SE7')
	cQuery += " WHERE "
	cQuery += 	"E7_ANO >='"+RIGHT(STR(YEAR(mv_par04)),4)+"' AND "
	cQuery += 	"E7_ANO <='"+RIGHT(STR(YEAR(mv_par05)),4)+"' AND "
	cQuery += 	"E7_NATUREZ >='"+ mv_par06 +"' AND "
	cQuery += 	"E7_NATUREZ <='"+ mv_par07 +"' AND "
	cQuery += RetSqlCond("SE7")

	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
	
	dbSelectArea(cAliasQry)
	SED->(DbSetOrder(1))

	DbGotop()
	If !EOF() .AND. !BOF()	
		While !(cAliasQry)->(Eof())

			If AdmGetRpo("R1.1") .and. oSelf <> nil
				oSelf:IncRegua2(STR0011) //"Atualizando saldos Orçados das naturezas..."
			EndIf	

			//Controle de Saldo de Naturezas
			SE7->(dbGoto( (cAliasQry)->RECNO ) )
			SED->(MsSeek(xFilial("SED") + SE7->E7_NATUREZ ))  
			aValores	:= {	SE7->E7_VALJAN1,;
								SE7->E7_VALFEV1,;
								SE7->E7_VALMAR1,;
								SE7->E7_VALABR1,;
								SE7->E7_VALMAI1,;
								SE7->E7_VALJUN1,;
								SE7->E7_VALJUL1,;
								SE7->E7_VALAGO1,;
								SE7->E7_VALSET1,;
								SE7->E7_VALOUT1,;
								SE7->E7_VALNOV1,;
								SE7->E7_VALDEZ1}

			For nMes := 1 to 12
				//Ultimo dia do mes (data do Orcado)
				dData := (LastDay(Ctod("01"+"/"+StrZero(nMes,2)+"/"+SE7->E7_ANO, "ddmmyy")))

				//Atualizo o valor atual para o saldo da natureza
				AtuSldNat(SE7->E7_NATUREZ, dData , SE7->E7_MOEDA, "1", If(SED->ED_COND=="D","P",SED->ED_COND), aValores[nMes], aValores[nMes],"+",,FunName(),"SE7",SE7->(Recno()))
			Next

			dbSelectArea(cAliasQry)
			dbSkip()
		EndDo
	Endif	

	dbSelectArea(cAliasQry)
	dbCloseArea()
	fErase(cAliasQry + OrdBagExt())
	fErase(cAliasQry + GetDbExtension())

	dbSelectArea("SE7")
Endif

RestArea(aArea)
Return(.T.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ F800SPSE1  ³ Autor ³ Mauricio Pequim Jr  ³ Data ³ 25.05.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Reprocessa Saldos Previstos - Receber                   	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ F800SPSE1() 	                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Void                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function F800SPSE1(oSelf ,nInc)		

Local aArea			:= GetArea()
Local cQuery		:= ""
Local lProcessa	:= !(Empty(xFilial("SE1")) .And. nInc > 1)
Local cAliasQry	:= "TRB800D"  

//Local lDecstPrv := SuperGetMv("MV_FLXPRVD",.T.,.F.) 

DEFAULT oSelf := NIL

dbSelectArea("SE1")
dbSetOrder(1)

If AdmGetRpo("R1.1") .and. oSelf <> nil
	oSelf:SetRegua2(0)
EndIf

IF lProcessa

	cQuery := "SELECT E1_VENCREA, E1_TIPO , E1_NATUREZ, E1_MOEDA, " 
	cQuery += " SUM(E1_VALOR) NVALOR, SUM(E1_VLCRUZ) NVLCRUZ  " 
	cQuery += "FROM " + RetSQLTab('SE1')
	cQuery += " WHERE "
	cQuery += 	"E1_VENCREA >='" + DTOS(mv_par04)	+"' AND "
	cQuery += 	"E1_VENCREA <='" + DTOS(mv_par05)	+"' AND "
	cQuery += 	"E1_NATUREZ >='" + mv_par06			+"' AND "
	cQuery += 	"E1_NATUREZ <='" + mv_par07			+"' AND "                                   
	cQuery += 	"E1_MULTNAT <> '1' AND "
	cQuery +=	"E1_TIPOFAT = '   ' AND "  	// Desconsidera títulos utilizados em geração de faturas a receber
	cQuery +=	"E1_TIPOLIQ = '   ' AND "  	// Desconsidera títulos utilizados em geração de títulos de liquidação a receber 
	cQuery +=	"E1_FLUXO 	= 'S' AND "  	// Considera apenas os documentos com o campo Fluxo de caixa = Sim e campos em branco
	cQuery +=	"E1_TIPO <>  'RA' AND "  	// Não considera RA, pois já vai pro saldo realizado	
	cQuery += RetSqlCond("SE1")
	cQuery += "GROUP BY E1_VENCREA, E1_TIPO, E1_NATUREZ ,E1_MOEDA"
                      
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
	TcSetField(cAliasQry, "E1_VENCREA" , "D")
		
	dbSelectArea(cAliasQry)

	DbGotop()
	If !EOF() .AND. !BOF()	
		While !(cAliasQry)->(Eof())

			If AdmGetRpo("R1.1") .and. oSelf <> nil
				oSelf:IncRegua2(STR0012) //"Atualizando saldos Previstos CR das naturezas..."
			EndIf	

			//Atualizo o valor atual para o saldo da natureza
			AtuSldNat(	(cAliasQry)->E1_NATUREZ,;
						 	(cAliasQry)->E1_VENCREA,;
						 	(cAliasQry)->E1_MOEDA,;
							If((cAliasQry)->E1_TIPO $ MVRECANT+"/"+MV_CRNEG,"3","2"),;
							"R",;
							(cAliasQry)->NVALOR,; 
							(cAliasQry)->NVLCRUZ,;
							If((cAliasQry)->E1_TIPO $ MVABATIM,"-","+"),;
							"D",;
							FunName(),;
							cAliasQry)

			dbSelectArea(cAliasQry)
			dbSkip()

		EndDo
	Endif	

	dbSelectArea(cAliasQry)
	dbCloseArea()
	fErase(cAliasQry + OrdBagExt())
	fErase(cAliasQry + GetDbExtension())

	dbSelectArea("SE1")

Endif

RestArea(aArea)
Return(.T.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ F800SPSE2  ³ Autor ³ Mauricio Pequim Jr  ³ Data ³ 25.05.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Reprocessa Saldos Previstos - Pagar                   	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ F800SPSE2() 	                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Void                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function F800SPSE2(oSelf ,nInc)		

Local aArea			:= GetArea()
Local cQuery		:= ""
Local lProcessa	:= !(Empty(xFilial("SE2")) .And. nInc > 1)
Local cAliasQry	:= "TRB800E"    

DEFAULT oSelf := NIL

dbSelectArea("SE2")
dbSetOrder(1)

If AdmGetRpo("R1.1") .and. oSelf <> nil
	oSelf:SetRegua2(0)
EndIf

IF lProcessa

	cQuery := "SELECT E2_VENCREA, E2_TIPO, E2_NATUREZ, E2_MOEDA, "
	cQuery += " SUM(E2_VALOR) NVALOR, SUM(E2_VLCRUZ) NVLCRUZ  " 	
	cQuery += "FROM " + RetSQLTab('SE2')
	cQuery += " WHERE "
	cQuery += 	"E2_VENCREA >='" + DTOS(mv_par04)	+"' AND "
	cQuery +=	"E2_VENCREA <='" + DTOS(mv_par05)	+"' AND "
	cQuery += 	"E2_NATUREZ >='" + mv_par06			+"' AND "
	cQuery += 	"E2_NATUREZ <='" + mv_par07			+"' AND "                                   
	cQuery += 	"E2_MULTNAT <> '1' AND "
	cQuery +=	"E2_TIPOFAT = '   ' AND " // Desconsidera títulos utilizados em geração de Faturas a Pagar
	cQuery +=	"E2_TIPOLIQ = '   ' AND " // Desconsidera títulos utilizados em geração de títulos de Liquidação a Pagar   
	cQuery +=	"E2_FLUXO 	<> 'N' AND "  	// Considera apenas os documentos com o campo Fluxo de caixa diferente de N
	cQuery +=	"E2_TIPO NOT IN ('PA') AND "
	cQuery += RetSqlCond("SE2") 
	cQuery += "GROUP BY E2_VENCREA, E2_TIPO, E2_NATUREZ ,E2_MOEDA"
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
	TcSetField(cAliasQry, "E2_VENCREA" , "D")

	dbSelectArea(cAliasQry)

	DbGotop()
	If !EOF() .AND. !BOF()	
		While !(cAliasQry)->(Eof())

			If AdmGetRpo("R1.1") .and. oSelf <> nil
				oSelf:IncRegua2(STR0013) //"Atualizando saldos Previstos C.PAGAR das naturezas..."
			EndIf	

			//Atualizo o valor atual para o saldo da natureza
			AtuSldNat(	(cAliasQry)->E2_NATUREZ,;
						 	(cAliasQry)->E2_VENCREA,;
						 	(cAliasQry)->E2_MOEDA,;
							If((cAliasQry)->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG,"3","2"),;
							"P",;
							(cAliasQry)->NVALOR,; 
							(cAliasQry)->NVLCRUZ,;
							If((cAliasQry)->E2_TIPO $ MVABATIM,"-","+"),;
							"D",;
							FunName(),;
							cAliasQry)

			dbSelectArea(cAliasQry)
			dbSkip()

		EndDo
	Endif	

	dbSelectArea(cAliasQry)
	dbCloseArea()
	fErase(cAliasQry + OrdBagExt())
	fErase(cAliasQry + GetDbExtension())

	dbSelectArea("SE2")

Endif

RestArea(aArea)
Return(.T.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ F800SPSEV  ³ Autor ³ Mauricio Pequim Jr  ³ Data ³ 25.05.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Reprocessa Saldos Previstos - MultiNaturezas Receber    	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ F800SPSEV()		                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Void                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function F800SPSEV(oSelf ,nInc)

Local aArea			:= GetArea()
Local cQuery		:= ""
Local lProcessa	:= !(Empty(xFilial("SEV")) .And. nInc > 1)
Local cAliasQry	:= "TRB800F"

DEFAULT oSelf := NIL

dbSelectArea("SEV")
dbSetOrder(2)

If AdmGetRpo("R1.1") .and. oSelf <> nil
	oSelf:SetRegua2(0)
EndIf

IF lProcessa

	cQuery := "SELECT EV_NATUREZ, E1_VENCREA VENCREA, EV_TIPO, E1_MOEDA MOEDA, 'R' CARTEIRA, "
	cQuery += "SUM(EV_VALOR) NVALOR, SUM(E1_VLCRUZ * EV_PERC) NVLCRUZ " 
	cQuery += "FROM " +RetSQLTab('SEV')

	cQuery += "JOIN " + RetSQLTab('SE1')
	cQuery += "  ON  SEV.EV_FILIAL  = SE1.E1_FILIAL AND "
	cQuery += "      SEV.EV_PREFIXO = SE1.E1_PREFIXO AND "
	cQuery += "      SEV.EV_NUM	  = SE1.E1_NUM AND "
	cQuery += "      SEV.EV_PARCELA = SE1.E1_PARCELA AND "
	cQuery += "      SEV.EV_TIPO	  = SE1.E1_TIPO AND "
	cQuery += "      SEV.EV_CLIFOR  = SE1.E1_CLIENTE AND "
	cQuery += "      SEV.EV_LOJA	  = SE1.E1_LOJA "

	cQuery += " WHERE "
	cQuery += 	"E1_VENCREA >='" + DTOS(mv_par04)	+"' AND "
	cQuery += 	"E1_VENCREA <='" + DTOS(mv_par05)	+"' AND "
	cQuery += 	"EV_NATUREZ >='" + mv_par06			+"' AND "
	cQuery += 	"EV_NATUREZ <='" + mv_par07			+"' AND "                                   
	cQuery += 	"EV_IDENT	= '1' AND "                                   
	cQuery += 	"EV_RECPAG	= 'R' AND "                                   
	cQuery += 	RetSqlCond("SEV,SE1") 

	cQuery += "GROUP BY EV_NATUREZ, E1_VENCREA, EV_TIPO, E1_MOEDA"

	cQuery += " UNION ALL "

	cQuery += "SELECT EV_NATUREZ, E2_VENCREA VENCREA, EV_TIPO, E2_MOEDA MOEDA, 'P' CARTEIRA, "
	cQuery += "SUM(EV_VALOR) NVALOR, SUM(E2_VLCRUZ * EV_PERC) NVLCRUZ " 
	cQuery += "FROM " +RetSQLTab('SEV')

	cQuery += "JOIN " + RetSQLTab('SE2')
	cQuery += "  ON  SEV.EV_FILIAL  = SE2.E2_FILIAL AND "
	cQuery += "      SEV.EV_PREFIXO = SE2.E2_PREFIXO AND "
	cQuery += "      SEV.EV_NUM	  = SE2.E2_NUM AND "
	cQuery += "      SEV.EV_PARCELA = SE2.E2_PARCELA AND "
	cQuery += "      SEV.EV_TIPO	  = SE2.E2_TIPO AND "
	cQuery += "      SEV.EV_CLIFOR  = SE2.E2_FORNECE AND "
	cQuery += "      SEV.EV_LOJA	  = SE2.E2_LOJA "

	cQuery += "WHERE "
	cQuery += 	"E2_VENCREA >='" + DTOS(mv_par04)	+"' AND "
	cQuery += 	"E2_VENCREA <='" + DTOS(mv_par05)	+"' AND "
	cQuery += 	"EV_NATUREZ >='" + mv_par06			+"' AND "
	cQuery += 	"EV_NATUREZ <='" + mv_par07			+"' AND "                                   
	cQuery += 	"EV_IDENT	= '1' AND "                                   
	cQuery += 	"EV_RECPAG	= 'P' AND "                                   
	cQuery += 	RetSqlCond("SEV,SE2") 

	cQuery += "GROUP BY EV_NATUREZ, E2_VENCREA, EV_TIPO, E2_MOEDA"

	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
	TcSetField(cAliasQry, "VENCREA" , "D")
		
	dbSelectArea(cAliasQry)

	DbGotop()
	If !EOF() .AND. !BOF()	
		While !(cAliasQry)->(Eof())

			If AdmGetRpo("R1.1") .and. oSelf <> nil
				oSelf:IncRegua2(STR0014) //"Atualizando Saldos Previstos Multinaturezas..."
			EndIf	

			//Atualizo o valor atual para o saldo da natureza
			AtuSldNat(	(cAliasQry)->EV_NATUREZ,;
						 	(cAliasQry)->VENCREA,;
						 	(cAliasQry)->MOEDA,;
							If((cAliasQry)->EV_TIPO $ MVRECANT+"/"+MV_CRNEG+"/"+MVPAGANT+"/"+MV_CPNEG,"3","2"),;
							(cAliasQry)->CARTEIRA,;
							(cAliasQry)->NVALOR,; 
							(cAliasQry)->NVLCRUZ,;
							"+",;
							"D",;
							FunName(),;
							cAliasQry)

				
			dbSelectArea(cAliasQry)
			dbSkip()

		EndDo
	Endif	

	dbSelectArea(cAliasQry)
	dbCloseArea()
	fErase(cAliasQry + OrdBagExt())
	fErase(cAliasQry + GetDbExtension())

	dbSelectArea("SE1")

Endif

RestArea(aArea)
Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ F800SPSE3  ³ Autor ³ Marylly A. Silva	³ Data ³ 14.12.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Reprocessa Saldos Previstos - Comissões                 	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ F800SPSE3() 	                          		              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Void                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function F800SPSE3(oSelf ,nInc)		
Local lPrjCni 	:= FindFunction("ValidaCNI") .And. ValidaCNI()
Local aArea		:= GetArea()
Local cQuery	:= ""
Local lProcessa	:= !(Empty(xFilial("SE1")) .And. nInc > 1)
Local cAliasQry	:= GetNextAlias()
Local cNatComis	:= STRTRAN(GetNewPar("MV_NATCOM",""),'"',"")

DEFAULT oSelf := NIL

dbSelectArea("SE3")
SE3->(dbSetOrder(1)) // Filial + Prefixo + Número + Parcela + Sequência + Vendedor

If AdmGetRpo("R1.1") .and. oSelf <> nil
	oSelf:SetRegua2(0)
EndIf

IF lProcessa .AND. mv_par06 <= cNatComis .AND. cNatComis <= mv_par07
	cQuery := "SELECT "
	cQuery += " SE3.E3_COMIS "
	cQuery += ", SE3.E3_VENCTO "
	cQuery += ", SE3.E3_DATA "
	If SE3->(FieldPos("E3_MOEDA")) > 0
		cQuery += " , SE3.E3_MOEDA "
	EndIf 
	cQuery += " FROM " +  RetSQLTab('SE3') + " "
	cQuery += " WHERE "
	cQuery += " 	SE3.D_E_L_E_T_ = ' ' "
	cQuery += "AND	SE3.E3_VENCTO >= '" + DTOS(mv_par04) + "' "
	cQuery += "AND	SE3.E3_VENCTO <= '" + DTOS(mv_par05) + "' "
	cQuery += "AND " + RetSqlCond("SE3")               
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
	TcSetField(cAliasQry, "E3_VENCTO" , "D")
	TcSetField(cAliasQry, "E3_DATA" , "D")
		
	dbSelectArea(cAliasQry)

	DbGotop()
	If !EOF() .AND. !BOF()	
		While !(cAliasQry)->(Eof())

			If AdmGetRpo("R1.1") .and. oSelf <> nil
				oSelf:IncRegua2(STR0012) //"Atualizando saldos Previstos CR das naturezas..."
			EndIf	
   
			//Atualizo o valor atual para o saldo da natureza
			If lPrjCni
				AtuSldNat(	cNatComis,;
							(cAliasQry)->E3_VENCTO,;
						IIf(SE3->(FieldPos("E3_MOEDA")) > 0,(cAliasQry)->E3_MOEDA,"01"),;
						"2",; // Previsto
						"P",; // Carteira = Pagar
						(cAliasQry)->E3_COMIS,;
						Iif(SE3->(FieldPos("E3_MOEDA")) > 0 .AND. VAL((cAliasQry)->E3_MOEDA) > 1,NOROUND(XMOEDA((cAliasQry)->E3_COMIS,"01",(cAliasQry)->E3_MOEDA,(cAliasQry)->E3_EMISSAO)),(cAliasQry)->E3_COMIS),; 
						"+",;
						"D",;
						FunName(),;
						"SE3")

			If !EMPTY((cAliasQry)->E3_DATA)
					AtuSldNat(cNatComis,;
							(cAliasQry)->E3_VENCTO,;
							IIf(SE3->(FieldPos("E3_MOEDA")) > 0,(cAliasQry)->E3_MOEDA,"01"),;
							"3",; // Realizado
							"P",; // Carteira = Pagar
							(cAliasQry)->E3_COMIS,; 
							(cAliasQry)->E3_COMIS,;
							"+",;
							"D",;
							FunName(),;
							"SE3")
			EndIf
			Else
			AtuSldNat(	cNatComis,;
						(cAliasQry)->E3_VENCTO,;
						IIf(SE3->(FieldPos("E3_MOEDA")) > 0,(cAliasQry)->E3_MOEDA,"01"),;
						"2",; // Previsto
						"P",; // Carteira = Pagar
						(cAliasQry)->E3_COMIS,;
						Iif(SE3->(FieldPos("E3_MOEDA")) > 0 .AND. VAL((cAliasQry)->E3_MOEDA) > 1,NOROUND(XMOEDA((cAliasQry)->E3_COMIS,"01",(cAliasQry)->E3_MOEDA,(cAliasQry)->E3_EMISSAO)),(cAliasQry)->E3_COMIS),; 
						"+",;
						"D",;
						FunName())

			If !EMPTY((cAliasQry)->E3_DATA)
					AtuSldNat(cNatComis,;
							(cAliasQry)->E3_VENCTO,;
							IIf(SE3->(FieldPos("E3_MOEDA")) > 0,(cAliasQry)->E3_MOEDA,"01"),;
							"3",; // Realizado
							"P",; // Carteira = Pagar
							(cAliasQry)->E3_COMIS,; 
							(cAliasQry)->E3_COMIS,;
							"+",;
							"D",;
							FunName())
			EndIf
			EndIf
			dbSelectArea(cAliasQry)
			dbSkip()
		EndDo
	Endif	

	dbSelectArea(cAliasQry)
	dbCloseArea()
	fErase(cAliasQry + OrdBagExt())
	fErase(cAliasQry + GetDbExtension())

	dbSelectArea("SE3")

Endif

RestArea(aArea)
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ F800SRSE5  ³ Autor ³ Mauricio Pequim Jr  ³ Data ³ 25.05.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Reprocessa Saldos Realizados - Receber                  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ F800SRSE5() 	                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Void                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function F800SRSE5(oSelf ,nInc)		

Local aArea		:= GetArea()
Local cQuery	:= ""
Local lProcessa	:= !(Empty(xFilial("SE5")) .And. nInc > 1)
Local cAliasQry	:= "TRB800G"
Local cCliVazio	:= Space(TamSx3("E1_CLIENTE")[1])
Local cDb		:= UPPER(AllTrim(TcGetDb()))
Local cFuncao	:= ""
Local lPrjCni 	:= FindFunction("ValidaCNI") .And. ValidaCNI()

DEFAULT oSelf 	:= NIL

dbSelectArea("SE5")
dbSetOrder(1)

If AdmGetRpo("R1.1") .and. oSelf <> nil
	oSelf:SetRegua2(0)
EndIf

/*
 * Tratamento da função SUBSTRING() no SQL para adequação com os bancos de dados possíveis.
 * Ex.: DB2, SQL Server, Oracle
 */
If cDb $ "DB2|ORACLE" 
	cFuncao := "SUBSTR"
Else
	cFuncao := "SUBSTRING"
EndIf

IF lProcessa
    
	/*
	 * Baixas por Contas a Receber
	 */
	If lPrjCni
		cQuery += "SELECT E5_NATUREZ, E5_DATA, E5_TIPO,E5_TIPODOC, E5_RECPAG, E5_MOEDA MOEDA, 'R' CARTEIRA, "
 	Else
		cQuery += "SELECT E5_NATUREZ, E5_DATA, E5_TIPO, E5_MOEDA MOEDA, E5_RECPAG CARTEIRA, SUM(0) ABATI, "
	EndIf
 
	cQuery += "SUM(E5_VALOR) NVALOR, SUM(E5_VALOR) NVLCRUZ  " 	
	cQuery += "FROM " +RetSQLTab('SE5')
    
	cQuery += "JOIN " + RetSQLTab('SE1')
	cQuery += "  ON  SE5.E5_FILIAL  = SE1.E1_FILIAL		AND "
	cQuery += "      SE5.E5_PREFIXO = SE1.E1_PREFIXO	AND "
	cQuery += "      SE5.E5_NUMERO  = SE1.E1_NUM		AND "
	cQuery += "      SE5.E5_PARCELA = SE1.E1_PARCELA AND "
	cQuery += "      SE5.E5_TIPO	= SE1.E1_TIPO AND "
	cQuery += "      SE5.E5_CLIFOR = SE1.E1_CLIENTE AND "
	cQuery += "      SE5.E5_LOJA	= SE1.E1_LOJA "
	cQuery += " WHERE "
	cQuery += 	"E5_DATA >='" + DTOS(mv_par04)	+"' AND "
	cQuery += 	"E5_DATA <='" + DTOS(mv_par05)	+"' AND "
	cQuery += 	"E5_NATUREZ >='" + mv_par06		+"' AND "
	cQuery += 	"E5_NATUREZ <='" + mv_par07		+"' AND "                                   
	cQuery += 	"E5_SITUACA	<> 'C' AND "                                  
	cQuery += 	"E5_MULTNAT	= ' ' AND "
	cQuery +=	" E5_MOTBX NOT IN ('FAT','LIQ','CMP') AND " // Desconsidera movimentos por geração de Fatura/Liquidação a Receber  
	If GETMV("MV_BXCNAB")=='S'
		cQuery +=	"E5_TIPODOC NOT IN ('V2','JR','MT','DC','D2','ES') AND "
	Else
		cQuery +=	"E5_TIPODOC NOT IN ('BA','V2','JR','MT','DC','D2','ES') AND "
	Endif
	cQuery += 	"E5_CLIENTE	<> '" + cCliVazio		+ "' AND "  
	cQuery += "NOT EXISTS (SELECT A.E5_NUMERO FROM " + RetSqlName("SE5") + " A " 
   	cQuery += "WHERE "
	cQuery += "A.E5_FILIAL  = SE5.E5_FILIAL		AND "
	cQuery += "A.E5_PREFIXO = SE5.E5_PREFIXO	AND "
	cQuery += "A.E5_NUMERO  = SE5.E5_NUMERO	AND "
	cQuery += "A.E5_PARCELA = SE5.E5_PARCELA AND "
	cQuery += "A.E5_TIPO	= SE5.E5_TIPO AND "
	cQuery += "A.E5_CLIFOR = SE5.E5_CLIFOR AND "
	cQuery += "A.E5_LOJA	= SE5.E5_LOJA AND "
   	cQuery += "A.E5_DATA >='" + DTOS(mv_par04)	+"' AND "
	cQuery += 	"A.E5_DATA <='" + DTOS(mv_par05)	+"' AND "
	cQuery += 	"A.E5_MULTNAT	= ' ' AND "
	cQuery +=  "A.E5_TIPODOC ='ES' AND "
	cQuery +=  "A.E5_RECPAG = 'P' AND "
	cQuery += 	"A.E5_SEQ	= se5.E5_SEQ AND "
	cQuery +=  "A.D_E_L_E_T_<>'*') AND "
	cQuery += 	RetSqlCond("SE5,SE1") 
	If lPrjCni
		cQuery += " GROUP BY E5_NATUREZ, E5_DATA, E5_TIPO, E5_TIPODOC, E5_RECPAG, E5_MOEDA"
 	Else
		cQuery += " GROUP BY E5_NATUREZ, E5_DATA, E5_TIPO, E5_RECPAG, E5_MOEDA " 
	EndIf
	cQuery += " UNION ALL "
   
	 // Baixas por Contas a Receber dos Impostos
	
	If !lPrjCni
		cQuery += "SELECT E1_NATUREZ, E1_BAIXA, E1_TIPO, CAST('0'||CAST(E1_MOEDA AS CHAR(1)) AS CHAR(2)) MOEDA,  'R' CARTEIRA, SUM(0) ABATI,"
		cQuery += "SUM(E1_VALOR) NVALOR, SUM(E1_VALOR) NVLCRUZ  " 	
		cQuery += "FROM " +RetSQLTab('SE1')
		cQuery += " WHERE "
		cQuery += 	"E1_BAIXA >='" + DTOS(mv_par04)	+"' AND "
		cQuery += 	"E1_BAIXA <='" + DTOS(mv_par05)	+"' AND "
		cQuery += 	"E1_NATUREZ >='" + mv_par06		+"' AND "
		cQuery += 	"E1_NATUREZ <='" + mv_par07		+"' AND "                                   
		cQuery +=	"E1_TIPO IN ('CF-','PI-','CS-') AND "
		cQuery +=	"E1_SALDO = 0 "
	 
		cQuery += " GROUP BY E1_NATUREZ, E1_BAIXA, E1_TIPO, E1_MOEDA " 
   
 		cQuery += " UNION ALL "
   
		// Abatimentos por Contas a Receber de Impostos
	
		cQuery += "SELECT E1_NATUREZ, E1_BAIXA, E1_TIPO, CAST('0'||CAST(E1_MOEDA AS CHAR(1)) AS CHAR(2)) MOEDA,  'R' CARTEIRA, SUM(E1_COFINS+E1_CSLL+E1_PIS) ABATI, "
				 
		cQuery += "SUM(0) NVALOR, SUM(0) NVLCRUZ  " 	
		cQuery += "FROM " +RetSQLTab('SE1')
		cQuery += " WHERE "
		cQuery += 	"E1_BAIXA >='" + DTOS(mv_par04)	+"' AND "
		cQuery += 	"E1_BAIXA <='" + DTOS(mv_par05)	+"' AND "
		cQuery += 	"E1_NATUREZ >='" + mv_par06		+"' AND "
		cQuery += 	"E1_NATUREZ <='" + mv_par07		+"' AND "                                   
		cQuery +=	"E1_TIPO NOT IN ('CF-','PI-','CS-') AND "
		cQuery +=	"E1_SALDO = 0 "
 
		cQuery += " GROUP BY E1_NATUREZ, E1_BAIXA, E1_TIPO, E1_MOEDA " 
   
	   	cQuery += " UNION ALL "

	Endif
	/*
	* Baixas por Contas Pagar
	*/
	If lPrjCni
		cQuery += " SELECT E5_NATUREZ, E5_DATA, E5_TIPO, E5_TIPODOC, E5_RECPAG, E5_MOEDA MOEDA, 'P' CARTEIRA, "
	Else
	 	cQuery += " SELECT E5_NATUREZ, E5_DATA, E5_TIPO,E5_MOEDA MOEDA, E5_RECPAG CARTEIRA, SUM(0) ABATI,"
	EndIf
	cQuery += "SUM(E5_VLMOED2 - ((E5_VLJUROS+E5_VLMULTA+E5_VLCORRE)  - (E5_VLDECRE - E5_VLDESCO)) ) NVALOR, SUM(E5_VALOR - ((E5_VLJUROS+E5_VLMULTA+E5_VLCORRE)  - (E5_VLDECRE - E5_VLDESCO)) ) NVLCRUZ  " 
	cQuery += "FROM " +RetSQLTab('SE5')

	cQuery += "JOIN " + RetSQLTab('SE2')
	cQuery += "  ON  SE5.E5_FILIAL  = SE2.E2_FILIAL AND "
	cQuery += "      SE5.E5_PREFIXO = SE2.E2_PREFIXO AND "
	cQuery += "      SE5.E5_NUMERO  = SE2.E2_NUM AND "
	cQuery += "      SE5.E5_PARCELA = SE2.E2_PARCELA AND "
	cQuery += "      SE5.E5_TIPO	= SE2.E2_TIPO AND "
	cQuery += "      SE5.E5_FORNECE = SE2.E2_FORNECE AND "
	cQuery += "      SE5.E5_LOJA	= SE2.E2_LOJA "

	cQuery += " WHERE "
	cQuery += 	"E5_DATA >='" + DTOS(mv_par04)	+"' AND "
	cQuery += 	"E5_DATA <='" + DTOS(mv_par05)	+"' AND "
	cQuery += 	"E5_NATUREZ >='" + mv_par06		+"' AND "
	cQuery += 	"E5_NATUREZ <='" + mv_par07		+"' AND "                                   
	cQuery += 	"E5_SITUACA	<> 'C' AND "                                  
	cQuery += 	"E5_MULTNAT	= ' ' AND "
	cQuery +=	"E5_MOTBX NOT IN ('FAT','LIQ','CMP') AND " // Desconsidera movimentos por geração de Fatura/Liquidação a Pagar  
	If GETMV("MV_BXCNAB")=='S'
		cQuery +=	"E5_TIPODOC NOT IN ('V2','JR','MT','DC','D2','ES') AND "
	Else
		cQuery +=	"E5_TIPODOC NOT IN ('BA','V2','JR','MT','DC','D2','ES') AND "
	Endif
	cQuery += 	"E5_FORNECE	<> '" + cCliVazio		+"' AND "
	cQuery += 	" NOT EXISTS ("
	cQuery += 		" SELECT ESTOR.E5_NUMERO"
	cQuery += 		" FROM " + RetSqlName("SE5") + " ESTOR "
	cQuery += 		" WHERE ESTOR.E5_FILIAL = '" + xFilial("SE5")+ "' "
	cQuery +=		" AND ESTOR.E5_PREFIXO = SE5.E5_PREFIXO "
	cQuery +=		" AND ESTOR.E5_NUMERO = SE5.E5_NUMERO "
	cQuery +=		" AND ESTOR.E5_PARCELA = SE5.E5_PARCELA "
	cQuery +=		" AND ESTOR.E5_TIPO = SE5.E5_TIPO "
	cQuery +=		" AND ESTOR.E5_CLIFOR = SE5.E5_CLIFOR "
	cQuery +=		" AND ESTOR.E5_LOJA = SE5.E5_LOJA "
	cQuery +=		" AND ESTOR.E5_SEQ = SE5.E5_SEQ "
	cQuery +=		" AND ESTOR.E5_TIPODOC = 'ES' "
	cQuery +=		" AND ESTOR.E5_RECPAG <> SE5.E5_RECPAG "
	cQuery +=		" AND ESTOR.D_E_L_E_T_ <> '*' ) AND "
	cQuery += 	RetSqlCond("SE5,SE2")
	If lPrjCni
		cQuery += " GROUP BY E5_NATUREZ, E5_DATA, E5_TIPO, E5_TIPODOC, E5_RECPAG, E5_MOEDA "  
	Else
		cQuery += " GROUP BY E5_NATUREZ, E5_DATA, E5_TIPO, E5_RECPAG, E5_MOEDA "  
	EndIf
    
	cQuery += " UNION ALL "
    
	/*
	 * Baixas por Inclusão de Empréstimos Financeiros
	 */
	If lPrjCni
		cQuery += " SELECT E5_NATUREZ, E5_DATA, E5_TIPO, E5_TIPODOC, E5_RECPAG, E5_MOEDA MOEDA, E5_RECPAG CARTEIRA, E5_VALOR NVALOR, E5_VLMOED2 NVLCRUZ FROM  " + RetSQLTab('SEH') + " "
	Else
		cQuery += " SELECT E5_NATUREZ, E5_DATA, E5_TIPO, E5_MOEDA MOEDA, E5_RECPAG CARTEIRA, SUM(0) ABATI, E5_VALOR NVALOR, E5_VLMOED2 NVLCRUZ FROM  " + RetSQLTab('SEH') + " "
	EndIf
	cQuery += "INNER JOIN  "
	cQuery += "	" + RetSQLTab('SE5') + "  ON SE5.D_E_L_E_T_ = ' ' AND  "
	cQuery += "	" + cFuncao + "(SE5.E5_DOCUMEN, 1, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1]) + " ) = SEH.EH_NUMERO AND  "
	cQuery += "	" + cFuncao + "(SE5.E5_DOCUMEN, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1] + 1) + ", " + CVALTOCHAR(TamSX3("EH_REVISAO")[1]) + "  ) = SEH.EH_REVISAO "
	cQuery += "WHERE "
	cQuery += "	E5_DATA >='" +	DTOS(mv_par04)	+ "' AND "
	cQuery += "	E5_DATA <='" +	DTOS(mv_par05)	+ "' AND "
	cQuery += "	E5_NATUREZ >='" +	mv_par06	+ "' AND "
	cQuery += "	E5_NATUREZ <='" +	mv_par07	+ "' AND "
	cQuery += "	E5_TIPODOC = 'EP' AND  "
	cQuery += " E5_FORNECE	= '" + cCliVazio	+"' AND "
	cQuery += " NOT EXISTS ("
	cQuery += 		" SELECT ESTOR.E5_NUMERO"
	cQuery += 		" FROM " + RetSqlName("SE5") + " ESTOR "
	cQuery += 		" WHERE ESTOR.E5_FILIAL = '" + xFilial("SE5")+ "' "
	cQuery +=		" AND ESTOR.E5_PREFIXO = SE5.E5_PREFIXO "
	cQuery +=		" AND ESTOR.E5_NUMERO = SE5.E5_NUMERO "
	cQuery +=		" AND ESTOR.E5_PARCELA = SE5.E5_PARCELA "
	cQuery +=		" AND ESTOR.E5_TIPO = SE5.E5_TIPO "
	cQuery +=		" AND ESTOR.E5_CLIFOR = SE5.E5_CLIFOR "
	cQuery +=		" AND ESTOR.E5_LOJA = SE5.E5_LOJA "
	cQuery +=		" AND ESTOR.E5_SEQ = SE5.E5_SEQ "
	cQuery +=		" AND ESTOR.E5_TIPODOC = 'ES' "
	cQuery +=		" AND ESTOR.E5_RECPAG = SE5.E5_RECPAG "
	cQuery +=		" AND ESTOR.D_E_L_E_T_ <> '*' ) AND "
	cQuery += RetSqlCond("SEH")
	If lPrjCni
		cQuery += " GROUP BY E5_NATUREZ, E5_DATA, E5_TIPO, E5_TIPODOC, E5_RECPAG, E5_MOEDA, E5_RECPAG, E5_VLMOED2, E5_VALOR ""
 	Else
		cQuery += " GROUP BY E5_NATUREZ, E5_DATA, E5_TIPO, E5_MOEDA, E5_RECPAG, E5_VLMOED2, E5_VALOR "
    EndIf
   	cQuery += " UNION ALL "
	
	/*                                                                                                        
	 * Baixas por Pagamentos de Empréstimos Financeiros
	 */
	 If lPrjCni
		cQuery += " SELECT E5_NATUREZ, E5_DATA, E5_TIPO, E5_TIPODOC, E5_RECPAG, E5_MOEDA MOEDA, 'P' CARTEIRA, "
		cQuery += " SUM(E5_VLMOED2) NVALOR, SUM(E5_VALOR) NVLCRUZ  " 
	 Else
		cQuery += " SELECT E5_NATUREZ, E5_DATA, E5_TIPO, E5_MOEDA MOEDA, E5_RECPAG CARTEIRA, SUM(0) ABATI, "
		cQuery += " E5_VALOR NVALOR, E5_VLMOED2 NVLCRUZ  " 
	 EndIf
	cQuery += " FROM " + RetSQLTab('SE5') + " "
	cQuery += " INNER JOIN " + RetSqlTab("SEH") + " ON "
	cQuery += " SEH.D_E_L_E_T_ 	= ' ' AND "
	cQuery += " " + cFuncao + "(SE5.E5_DOCUMEN, 1, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1]) + " ) = SEH.EH_NUMERO AND "
 	cQuery += " " + cFuncao + "(SE5.E5_DOCUMEN, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1] + 1) + ", " + CVALTOCHAR(TamSX3("EH_REVISAO")[1]) + " ) = SEH.EH_REVISAO "
	cQuery += " INNER JOIN " + RetSqlTab("SEI") + " ON "
	cQuery += " SEI.D_E_L_E_T_ 	= ' ' AND "
	cQuery += " SEH.EH_NUMERO	= SEI.EI_NUMERO AND "
	cQuery += " SEH.EH_REVISAO	= SEI.EI_REVISAO AND "
	cQuery += " SEI.EI_STATUS	!= 	'C' AND "
	cQuery += " SEI.EI_TIPODOC 	= 	'VL' AND " 
	cQuery += " " + cFuncao + "(SE5.E5_DOCUMEN, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1] + TamSX3("EH_REVISAO")[1] + 1) + "," + CVALTOCHAR(TamSX3("EI_SEQ")[1]) + ") = SEI.EI_SEQ "
	cQuery += " WHERE "
	cQuery += 	"E5_DATA >='" + DTOS(mv_par04)	+"' AND "
	cQuery += 	"E5_DATA <='" + DTOS(mv_par05)	+"' AND "
	cQuery += 	"E5_NATUREZ >='" + mv_par06		+"' AND "
	cQuery += 	"E5_NATUREZ <='" + mv_par07		+"' AND "                                   
	cQuery += 	"E5_SITUACA	<> 'C' AND "                                  
	cQuery +=	"E5_TIPODOC = 'PE' AND "                                      
	cQuery += 	"E5_FORNECE	= '" + cCliVazio	+"' AND "
	cQuery +=	" NOT EXISTS ("
	cQuery += 		" SELECT ESTOR.E5_NUMERO "
	cQuery += 		" FROM " + RetSqlName("SE5") + " ESTOR "
	cQuery += 		" WHERE ESTOR.E5_FILIAL = '" + xFilial("SE5")+ "' "
	cQuery +=		" AND ESTOR.E5_PREFIXO = SE5.E5_PREFIXO "
	cQuery +=		" AND ESTOR.E5_NUMERO = SE5.E5_NUMERO "
	cQuery +=		" AND ESTOR.E5_PARCELA = SE5.E5_PARCELA "
	cQuery +=		" AND ESTOR.E5_TIPO = SE5.E5_TIPO "
	cQuery +=		" AND ESTOR.E5_CLIFOR = SE5.E5_CLIFOR "
	cQuery +=		" AND ESTOR.E5_LOJA = SE5.E5_LOJA "
	cQuery +=		" AND ESTOR.E5_SEQ = SE5.E5_SEQ "
	cQuery +=		" AND ESTOR.E5_TIPODOC = 'PE' "
	cQuery +=		" AND ESTOR.E5_RECPAG != SE5.E5_RECPAG "
	cQuery +=		" AND ESTOR.D_E_L_E_T_ <> '*' "
	cQuery +=		" AND " + cFuncao + "(ESTOR.E5_DOCUMEN, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1] + TamSX3("EH_REVISAO")[1] + 1) + "," + CVALTOCHAR(TamSX3("EI_SEQ")[1]) + ") = "
	cQuery +=		" " + cFuncao + "(SE5.E5_DOCUMEN, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1] + TamSX3("EH_REVISAO")[1] + 1) + "," + CVALTOCHAR(TamSX3("EI_SEQ")[1]) + ")"
	cQuery += 		" AND " + cFuncao + "(ESTOR.E5_DOCUMEN, 1, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1]) + " ) = SEH.EH_NUMERO "
	cQuery += 		" AND " + cFuncao + "(ESTOR.E5_DOCUMEN, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1] + 1) + ", " + CVALTOCHAR(TamSX3("EH_REVISAO")[1]) + " ) = SEH.EH_REVISAO ) "
	cQuery += 		" AND " + RetSqlCond("SE5")
	If lPrjCni
		cQuery += " GROUP BY E5_NATUREZ, E5_DATA, E5_TIPO, E5_TIPODOC, E5_RECPAG, E5_MOEDA, E5_RECPAG, E5_VLMOED2, E5_VALOR ""
 	Else
		cQuery += " GROUP BY E5_NATUREZ, E5_DATA, E5_TIPO, E5_RECPAG, E5_MOEDA, E5_VLMOED2, E5_VALOR "
	EndIf
	cQuery += " UNION ALL " 
	
	/*
	 * Baixas por Inclusão de Aplicações Financeiras
	 */
	If lPrjCni
		cQuery += " SELECT E5_NATUREZ, E5_DATA, E5_TIPO, E5_TIPODOC, E5_RECPAG, E5_MOEDA MOEDA, E5_RECPAG CARTEIRA, E5_VALOR NVALOR, E5_VLMOED2 NVLCRUZ FROM  " + RetSQLTab('SEH') + " "
	Else
		cQuery += "	SELECT E5_NATUREZ, E5_DATA, E5_TIPO, E5_MOEDA MOEDA, E5_RECPAG CARTEIRA, SUM(0) ABATI, E5_VALOR NVALOR, E5_VLMOED2 NVLCRUZ FROM  " + RetSQLTab('SEH') + " "
	EndIf
	cQuery += "INNER JOIN  "
	cQuery += "	" + RetSQLTab('SE5') + "  ON SE5.D_E_L_E_T_ = ' ' AND  "
	cQuery += "	" + cFuncao + "(SE5.E5_DOCUMEN, 1, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1]) + " ) = SEH.EH_NUMERO AND  "
	cQuery += "	" + cFuncao + "(SE5.E5_DOCUMEN, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1] + 1) + ", " + CVALTOCHAR(TamSX3("EH_REVISAO")[1]) + "  ) = SEH.EH_REVISAO "
	cQuery += "WHERE "
	cQuery += 	"E5_DATA >='" + DTOS(mv_par04)	+"' AND "
	cQuery += 	"E5_DATA <='" + DTOS(mv_par05)	+"' AND "
	cQuery += 	"E5_NATUREZ >='" + mv_par06		+"' AND "
	cQuery += 	"E5_NATUREZ <='" + mv_par07		+"' AND "
	cQuery += 	"E5_SITUACA	<> 'C' AND "           
	cQuery += "	E5_TIPODOC = 'AP' AND  "
	cQuery += " E5_FORNECE	= '" + cCliVazio	+"' AND "
	cQuery += RetSqlCond("SEH")
	If lPrjCni
		cQuery += " GROUP BY E5_NATUREZ, E5_DATA, E5_TIPO, E5_TIPODOC, E5_MOEDA, E5_RECPAG, E5_RECPAG, E5_VLMOED2, E5_VALOR ""
 	Else
		cQuery += " GROUP BY E5_NATUREZ, E5_DATA, E5_TIPO, E5_MOEDA, E5_RECPAG, E5_VLMOED2, E5_VALOR "
	EndIf
	cQuery += " UNION ALL "
	
	If lPrjCni
		/*
		 * Baixas por Empréstimos
		 */
		cQuery += " SELECT E5_NATUREZ, E5_DATA, E5_TIPO, E5_TIPODOC,  E5_RECPAG, E5_MOEDA MOEDA, 'R' CARTEIRA, "
		cQuery += " SUM(E5_VLMOED2) NVALOR, SUM(E5_VALOR) NVLCRUZ  " 
		cQuery += " FROM " + RetSQLTab('SE5') + " "
		cQuery += " INNER JOIN " + RetSqlTab("SEH") + " ON SEH.D_E_L_E_T_ = ' ' AND " + cFuncao + "(SE5.E5_DOCUMEN, 1, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1]) + " ) = SEH.EH_NUMERO AND "
		cQuery += " " + cFuncao + "(SE5.E5_DOCUMEN, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1] + 1) + ", " + CVALTOCHAR(TamSX3("EH_REVISAO")[1]) + " ) = SEH.EH_REVISAO "
		cQuery += " WHERE "
		cQuery += " E5_DATA >='" + DTOS(mv_par04)	+"' AND "
		cQuery += " E5_DATA <='" + DTOS(mv_par05)	+"' AND "
		cQuery += " E5_NATUREZ >='" + mv_par06		+"' AND "
		cQuery += " E5_NATUREZ <='" + mv_par07		+"' AND "                                   
		cQuery += " E5_SITUACA	<> 'C' AND "                                  
		cQuery += " E5_TIPODOC = 'EP' AND "                                    
		cQuery += " E5_FORNECE	= '" + cCliVazio		+"' AND "
		cQuery += 	RetSqlCond("SE5")	
		cQuery += " GROUP BY E5_NATUREZ, E5_DATA, E5_TIPO, E5_TIPODOC, E5_RECPAG, E5_MOEDA "

	   	cQuery += " UNION ALL "
	
		/*                                                                                                       
		* Baixas por Pagamentos de Empréstimos
		*/
		cQuery += " SELECT E5_NATUREZ, E5_DATA, E5_TIPO, E5_TIPODOC, E5_RECPAG, E5_MOEDA MOEDA, 'P' CARTEIRA, "
		cQuery += " SUM(E5_VLMOED2) NVALOR, SUM(E5_VALOR) NVLCRUZ  " 
		cQuery += " FROM " + RetSQLTab('SE5') + " "
		cQuery += " INNER JOIN " + RetSqlTab("SEH") + " ON SEH.D_E_L_E_T_ = ' ' AND " + cFuncao + "(SE5.E5_DOCUMEN, 1, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1]) + " ) = SEH.EH_NUMERO AND "
		cQuery += " " + cFuncao + "(SE5.E5_DOCUMEN, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1] + 1) + ", " + CVALTOCHAR(TamSX3("EH_REVISAO")[1]) + " ) = SEH.EH_REVISAO "
		cQuery += " INNER JOIN " + RetSqlTab("SEI") + " ON SEI.D_E_L_E_T_ = ' ' AND SEH.EH_NUMERO = SEI.EI_NUMERO AND SEH.EH_REVISAO = SEI.EI_REVISAO AND SEI.EI_STATUS != 'C' AND SEI.EI_TIPODOC = 'VL' " 
		cQuery += " WHERE "
		cQuery += 	"E5_DATA >='" + DTOS(mv_par04)	+"' AND "
		cQuery += 	"E5_DATA <='" + DTOS(mv_par05)	+"' AND "
		cQuery += 	"E5_NATUREZ >='" + mv_par06		+"' AND "
		cQuery += 	"E5_NATUREZ <='" + mv_par07		+"' AND "                                   
		cQuery += 	"E5_SITUACA	<> 'C' AND "                                  
		cQuery +=	"E5_TIPODOC = 'PG' AND "                                      
		cQuery += 	"E5_FORNECE	= '" + cCliVazio	+"' AND "
		cQuery += 	RetSqlCond("SE5")
		cQuery += " GROUP BY E5_NATUREZ, E5_DATA, E5_TIPO, E5_TIPODOC, E5_RECPAG, E5_MOEDA "
	
		cQuery += " UNION ALL "
	
		/*
		* Baixas por Resgate de Aplicações Financeiras
		*/
		cQuery += " SELECT E5_NATUREZ, E5_DATA, E5_TIPO, E5_TIPODOC, E5_RECPAG, E5_MOEDA MOEDA, E5_RECPAG CARTEIRA, "
		cQuery += " SUM(E5_VLMOED2) NVALOR, SUM(E5_VALOR) NVLCRUZ  " 
		cQuery += " FROM " + RetSQLTab('SE5') + " "
		cQuery += " INNER JOIN " + RetSqlTab("SEH") + " ON SEH.D_E_L_E_T_ = ' ' AND " + cFuncao + "(SE5.E5_DOCUMEN, 1, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1]) + " ) = SEH.EH_NUMERO AND "
		cQuery += " " + cFuncao + "(SE5.E5_DOCUMEN, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1] + 1) + ", " + CVALTOCHAR(TamSX3("EH_REVISAO")[1]) + " ) = SEH.EH_REVISAO "
		cQuery += " INNER JOIN " + RetSqlTab("SEI") + " ON SEI.D_E_L_E_T_ = ' ' AND SEH.EH_NUMERO = SEI.EI_NUMERO AND SEH.EH_REVISAO = SEI.EI_REVISAO AND SEI.EI_STATUS != 'C' AND SEI.EI_TIPODOC IN ('RG') " 
		cQuery += " WHERE "
		cQuery += 	"E5_DATA >='" + DTOS(mv_par04)	+"' AND "
		cQuery += 	"E5_DATA <='" + DTOS(mv_par05)	+"' AND "
		cQuery += 	"E5_NATUREZ >='" + mv_par06		+"' AND "
		cQuery += 	"E5_NATUREZ <='" + mv_par07		+"' AND "                                   
		cQuery += 	"E5_SITUACA	<> 'C' AND "                                  
		cQuery +=	"E5_TIPODOC = 'RF' AND "                                   
		cQuery += 	"E5_FORNECE	= '" + cCliVazio	+"' AND "
		cQuery += 	RetSqlCond("SE5")
		cQuery += " GROUP BY E5_NATUREZ, E5_DATA, E5_TIPO, E5_TIPODOC, E5_RECPAG, E5_MOEDA "

	Else
		/*
		 * Baixas por Resgate de Aplicações Financeiras
		 */
		cQuery += "	SELECT E5_NATUREZ, E5_DATA, E5_TIPO, E5_MOEDA MOEDA, E5_RECPAG CARTEIRA, SUM(0) ABATI, E5_VALOR NVALOR, E5_VLMOED2 NVLCRUZ FROM  " + RetSQLTab('SEH') + " "
		cQuery += "INNER JOIN  "
		cQuery += "	" + RetSQLTab('SEI') + " ON SEI.D_E_L_E_T_ = ' ' AND  "
		cQuery += "	SEH.EH_NUMERO = SEI.EI_NUMERO AND "
		cQuery += "	SEH.EH_REVISAO = SEI.EI_REVISAO AND  "
		cQuery += "	SEI.EI_STATUS <> 'C' AND "
		cQuery += "	SEI.EI_TIPODOC IN ('VL') "
		cQuery += "INNER JOIN  "
		cQuery += "	" + RetSQLTab('SE5') + "  ON SE5.D_E_L_E_T_ = ' ' AND  "
		cQuery += "	" + cFuncao + "(SE5.E5_DOCUMEN, 1, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1]) + " ) = SEH.EH_NUMERO AND  "
		cQuery += "	" + cFuncao + "(SE5.E5_DOCUMEN, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1] + 1) + ", " + CVALTOCHAR(TamSX3("EH_REVISAO")[1]) + "  ) = SEH.EH_REVISAO AND "
		cQuery += "	" + cFuncao + "(SE5.E5_DOCUMEN, " + CVALTOCHAR(TamSX3("EH_NUMERO")[1] + TamSX3("EH_REVISAO")[1] + 1) + ", " + CVALTOCHAR(TamSX3("EI_SEQ")[1]) + "  ) = SEI.EI_SEQ "
		cQuery += "WHERE "
		cQuery += "	EI_DTDIGIT >='" +	DTOS(mv_par04)	+ "' AND "
		cQuery += "	EI_DTDIGIT <='" +	DTOS(mv_par05)	+ "' AND "
		cQuery += "	EI_NATUREZ >='" +	mv_par06			+ "' AND "
		cQuery += "	EI_NATUREZ <='" +	mv_par07			+ "' AND "
		cQuery += "	EI_STATUS <> 'C' AND "
		cQuery += "	E5_TIPODOC = 'RF' AND  "
		cQuery += " E5_FORNECE	= '" + cCliVazio	+"' AND "
		cQuery += RetSqlCond("SEI")
		cQuery += "GROUP BY "
		cQuery += "	E5_NATUREZ, E5_DATA, E5_TIPO, E5_MOEDA, E5_RECPAG, E5_VLMOED2, E5_VALOR "
	
		cQuery += " UNION ALL "
	
		/*
		 * Movimentos de Caixa (Pagar/Receber)
		 */
		cQuery += "	SELECT E5_NATUREZ, E5_DATA, E5_TIPO, '01' MOEDA, E5_RECPAG CARTEIRA, SUM(0) ABATI, E5_VALOR NVALOR, E5_VLMOED2 NVLCRUZ FROM  " + RetSQLTab('SE5') + " "
		cQuery += "WHERE "
		cQuery += "	E5_DATA >='" +	DTOS(mv_par04)	+ "' AND "
		cQuery += "	E5_DATA <='" +	DTOS(mv_par05)	+ "' AND "
		cQuery += "	E5_NATUREZ >='" +	mv_par06			+ "' AND "
		cQuery += "	E5_NATUREZ <='" +	mv_par07			+ "' AND "
		cQuery += "	E5_TIPODOC = '" + Space( TamSX3('E5_TIPODOC')[1] ) + "' AND  " 
		cQuery += 	"E5_SITUACA	<> 'C' AND "                                  
		cQuery += RetSqlCond("SE5")
		cQuery += "GROUP BY "
		cQuery += "	E5_NATUREZ, E5_DATA, E5_TIPO, E5_RECPAG, E5_VLMOED2, E5_VALOR "
	EndIf
	
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
	TcSetField(cAliasQry, "E5_DATA" , "D")
	
	DbGotop()
	If !EOF() .AND. !BOF()	
		While !(cAliasQry)->(Eof())

			If AdmGetRpo("R1.1") .and. oSelf <> nil
				oSelf:IncRegua2(STR0015) //"Atualizando saldos Realizados das naturezas..."
			EndIf	

			//Movimento de adiantamento no SE5 DEVE ser desconsiderado
			//Foram realizados na emissao
			If (cAliasQry)->E5_TIPO $ MV_CRNEG+"/"+MV_CPNEG
				(cAliasQry)->(dbSkip())
				Loop
			Endif


			//Atualizo o valor atual para o saldo da natureza
			If lPrjCni
				AtuSldNat(	(cAliasQry)->E5_NATUREZ,;
							 	(cAliasQry)->E5_DATA,;
							 	(cAliasQry)->MOEDA,;
								"3",;
								(cAliasQry)->CARTEIRA,;
								(cAliasQry)->NVALOR,; 
								(cAliasQry)->NVLCRUZ,;
								"+",;
								"D",;
								FunName(),;
								"SE5",;       
								,;
								,;
								(cAliasQry)->E5_TIPODOC)

			Else
				If AllTrim((cAliasQry)->E5_TIPO) $ "CF-|PI-|CS-"
					
					AtuSldNat(	(cAliasQry)->E5_NATUREZ,;
								 	(cAliasQry)->E5_DATA,;
								 	(cAliasQry)->MOEDA,;
									"3",;
									(cAliasQry)->CARTEIRA,;
									(cAliasQry)->NVALOR,; 
									(cAliasQry)->NVLCRUZ,;
									"-",;
									"D",;
									FunName())
				Else
									
					AtuSldNat(	(cAliasQry)->E5_NATUREZ,;
								 	(cAliasQry)->E5_DATA,;
								 	(cAliasQry)->MOEDA,;
									"3",;
									(cAliasQry)->CARTEIRA,;
									(cAliasQry)->NVALOR,; 
									(cAliasQry)->NVLCRUZ,;
									"+",;
									"D",;
									FunName(),;
									,;       
									,;
									,;
									,;          
									Iif((cAliasQry)->(FieldPos("ABATI"))>0,(cAliasQry)->ABATI,0))
				Endif
			EndIf	
			dbSelectArea(cAliasQry)
			dbSkip()

		EndDo
	Endif	

	dbSelectArea(cAliasQry)
	dbCloseArea()
	fErase(cAliasQry + OrdBagExt())
	fErase(cAliasQry + GetDbExtension())

	dbSelectArea("SE5")

Endif

RestArea(aArea)
Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ F800SRMOV  ³ Autor ³ Mauricio Pequim Jr  ³ Data ³ 25.05.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Reprocessa Saldos Realizados - Movimentos Bancariso Manuais³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ F800SRMOV() 	                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Void                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function F800SRMOV(oSelf ,nInc)		

Local aArea			:= GetArea()
Local cQuery		:= ""
Local lProcessa		:= !(Empty(xFilial("SE5")) .And. nInc > 1)
Local cAliasQry		:= "TRB800K"
Local cCliVazio		:= Space(TamSx3("E5_CLIFOR")[1])
Local cLoteVazio	:= Space(TamSx3("E5_LOTE")[1])
Local lPrjCni 		:= FindFunction("ValidaCNI") .And. ValidaCNI()

DEFAULT oSelf := NIL

dbSelectArea("SE5")
dbSetOrder(1)

If AdmGetRpo("R1.1") .and. oSelf <> nil
	oSelf:SetRegua2(0)
EndIf

IF lProcessa

	cQuery += "SELECT E5_NATUREZ, E5_DATA, E5_RECPAG CARTEIRA, A6_MOEDA MOEDA, "
	cQuery += "SUM(E5_VALOR) NVALOR, SUM(E5_VLMOED2) NVLCRUZ  " 
	cQuery += "FROM " +RetSQLTab('SE5')

	cQuery += "JOIN " + RetSQLTab('SA6')
	cQuery += "  ON  SE5.E5_BANCO   = SA6.A6_COD AND "
	cQuery += "      SE5.E5_AGENCIA = SA6.A6_AGENCIA AND "
	cQuery += "      SE5.E5_CONTA   = SA6.A6_NUMCON "

	//Se SA6 Exclusivo - considero a filial
	If !Empty(xFilial("SA6")) .AND. !Empty(xFilial("SE5"))
		cQuery += "AND SE5.E5_FILIAL  = SA6.A6_FILIAL "
	Endif

	cQuery += " WHERE "
	cQuery += 	"E5_DATA >='" + DTOS(mv_par04)	+"' AND "
	cQuery += 	"E5_DATA <='" + DTOS(mv_par05)	+"' AND "
	cQuery += 	"E5_NATUREZ >='" + mv_par06		+"' AND "
	cQuery += 	"E5_NATUREZ <='" + mv_par07		+"' AND "                                   
	cQuery += 	"E5_SITUACA	<> 'C' AND "                                  
	cQuery += 	"E5_SITUACA	<> 'X' AND "                                  
	cQuery += 	"E5_SITUACA	<> 'E' AND "                                  
	cQuery += 	"E5_MULTNAT	= ' ' AND "                                  
	cQuery += 	"E5_CLIFOR	= '" + cCliVazio		+"' AND "
	cQuery += 	"E5_LOTE		= '" + cLoteVazio		+"' AND "
	cQuery +=	"E5_TIPODOC NOT IN ('AP','EP','RF','PE','" + Space( TamSX3('E5_TIPODOC')[1] )  + "' ) AND "
	cQuery += 	RetSqlCond("SE5,SA6") 
	cQuery += "GROUP BY E5_NATUREZ, E5_DATA, E5_RECPAG, A6_MOEDA"

	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
	TcSetField(cAliasQry, "E5_DATA" , "D")
		
	dbSelectArea(cAliasQry)

	DbGotop()
	If !EOF() .AND. !BOF()	
		While !(cAliasQry)->(Eof())

			If AdmGetRpo("R1.1") .and. oSelf <> nil
				oSelf:IncRegua2(STR0015) //"Atualizando saldos Realizados das naturezas..."
			EndIf	

			//Atualizo o valor atual para o saldo da natureza
			If lPrjCni 
				AtuSldNat(	(cAliasQry)->E5_NATUREZ,;
							 	(cAliasQry)->E5_DATA,;
							 	(cAliasQry)->MOEDA,;
								"3",;
								(cAliasQry)->CARTEIRA,;
								(cAliasQry)->NVALOR,; 
								(cAliasQry)->NVLCRUZ,;
								"+",;
								"D",;
								FunName(),;
								"SE5")

			Else
				AtuSldNat(	(cAliasQry)->E5_NATUREZ,;
							 	(cAliasQry)->E5_DATA,;
							 	(cAliasQry)->MOEDA,;
								"3",;
								(cAliasQry)->CARTEIRA,;
								(cAliasQry)->NVALOR,; 
								(cAliasQry)->NVLCRUZ,;
								"+",;
								"D",;
								FunName(),;
								,;       
								,;
								,;
								,;         
								Iif((cAliasQry)->(FieldPos("ABATI"))>0,(cAliasQry)->ABATI,0))								
			EndIf	
			dbSelectArea(cAliasQry)
			dbSkip()

		EndDo
	Endif	

	dbSelectArea(cAliasQry)
	dbCloseArea()
	fErase(cAliasQry + OrdBagExt())
	fErase(cAliasQry + GetDbExtension())

	dbSelectArea("SE5")

Endif

RestArea(aArea)
Return(.T.)





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ F800SRSEV  ³ Autor ³ Mauricio Pequim Jr  ³ Data ³ 25.05.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Reprocessa Saldos Realizados - MultiNaturezas 		    	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ F800SPSEV()		                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Void                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function F800SRSEV(oSelf ,nInc)

Local aArea		:= GetArea()
Local cQuery	:= ""
Local lProcessa	:= !(Empty(xFilial("SEV")) .And. nInc > 1)
Local cAliasQry	:= "TRB800H"
Local lPrjCni 	:= FindFunction("ValidaCNI") .And. ValidaCNI()

DEFAULT oSelf := NIL

dbSelectArea("SEV")
dbSetOrder(2)

If AdmGetRpo("R1.1") .and. oSelf <> nil
	oSelf:SetRegua2(0)
EndIf

IF lProcessa

	cQuery := "SELECT EV_NATUREZ, E5_DATA, EV_TIPO, E1_MOEDA MOEDA, 'R' CARTEIRA, "
	cQuery += "SUM(EV_VALOR) NVALOR, SUM(E5_VALOR * EV_PERC) NVLCRUZ " 
	cQuery += "FROM " +RetSQLTab('SEV')

	cQuery += "JOIN " + RetSQLTab('SE5')
	cQuery += "  ON  SEV.EV_FILIAL  = SE5.E5_FILIAL AND "
	cQuery += "      SEV.EV_PREFIXO = SE5.E5_PREFIXO AND "
	cQuery += "      SEV.EV_NUM	  = SE5.E5_NUMERO AND "
	cQuery += "      SEV.EV_PARCELA = SE5.E5_PARCELA AND "
	cQuery += "      SEV.EV_TIPO	  = SE5.E5_TIPO AND "
	cQuery += "      SEV.EV_CLIFOR  = SE5.E5_CLIENTE AND "
	cQuery += "      SEV.EV_LOJA	  = SE5.E5_LOJA "

	cQuery += "JOIN " + RetSQLTab('SE1')
	cQuery += "  ON  SEV.EV_FILIAL  = SE1.E1_FILIAL AND "
	cQuery += "      SEV.EV_PREFIXO = SE1.E1_PREFIXO AND "
	cQuery += "      SEV.EV_NUM	  = SE1.E1_NUM AND "
	cQuery += "      SEV.EV_PARCELA = SE1.E1_PARCELA AND "
	cQuery += "      SEV.EV_TIPO	  = SE1.E1_TIPO AND "
	cQuery += "      SEV.EV_CLIFOR  = SE1.E1_CLIENTE AND "
	cQuery += "      SEV.EV_LOJA	  = SE1.E1_LOJA "

	cQuery += " WHERE "
	cQuery += 	"E5_DATA		>='" + DTOS(mv_par04)	+"' AND "
	cQuery += 	"E5_DATA		<='" + DTOS(mv_par05)	+"' AND "
	cQuery += 	"EV_NATUREZ >='" + mv_par06			+"' AND "
	cQuery += 	"EV_NATUREZ <='" + mv_par07			+"' AND "                                   
	cQuery += 	"EV_IDENT	= '2' AND "                                   
	cQuery += 	"EV_RECPAG	= 'R' AND "                                   
	cQuery += 	RetSqlCond("SEV,SE1,SE5") 
	cQuery += "GROUP BY EV_NATUREZ, E5_DATA, EV_TIPO, E1_MOEDA"

	cQuery += " UNION ALL "

	cQuery += "SELECT EV_NATUREZ, E5_DATA, EV_TIPO, E2_MOEDA MOEDA, 'P' CARTEIRA, "
	cQuery += "SUM(EV_VALOR) NVALOR, SUM(E5_VALOR * EV_PERC) NVLCRUZ " 
	cQuery += "FROM " +RetSQLTab('SEV')

	cQuery += "JOIN " + RetSQLTab('SE5')
	cQuery += "  ON  SEV.EV_FILIAL  = SE5.E5_FILIAL AND "
	cQuery += "      SEV.EV_PREFIXO = SE5.E5_PREFIXO AND "
	cQuery += "      SEV.EV_NUM	  = SE5.E5_NUMERO AND "
	cQuery += "      SEV.EV_PARCELA = SE5.E5_PARCELA AND "
	cQuery += "      SEV.EV_TIPO	  = SE5.E5_TIPO AND "
	cQuery += "      SEV.EV_CLIFOR  = SE5.E5_FORNECE AND "
	cQuery += "      SEV.EV_LOJA	  = SE5.E5_LOJA "

	cQuery += "JOIN " + RetSQLTab('SE2')
	cQuery += "  ON  SEV.EV_FILIAL  = SE2.E2_FILIAL AND "
	cQuery += "      SEV.EV_PREFIXO = SE2.E2_PREFIXO AND "
	cQuery += "      SEV.EV_NUM	  = SE2.E2_NUM AND "
	cQuery += "      SEV.EV_PARCELA = SE2.E2_PARCELA AND "
	cQuery += "      SEV.EV_TIPO	  = SE2.E2_TIPO AND "
	cQuery += "      SEV.EV_CLIFOR  = SE2.E2_FORNECE AND "
	cQuery += "      SEV.EV_LOJA	  = SE2.E2_LOJA "

	cQuery += " WHERE "
	cQuery += 	"E5_DATA		>='" + DTOS(mv_par04)	+"' AND "
	cQuery += 	"E5_DATA		<='" + DTOS(mv_par05)	+"' AND "
	cQuery += 	"EV_NATUREZ >='" + mv_par06			+"' AND "
	cQuery += 	"EV_NATUREZ <='" + mv_par07			+"' AND "                                   
	cQuery += 	"EV_IDENT	= '2' AND "                                   
	cQuery += 	"EV_RECPAG	= 'P' AND "                                   
	cQuery += 	RetSqlCond("SEV,SE2,SE5") 

	cQuery += "GROUP BY EV_NATUREZ, E5_DATA, EV_TIPO, E2_MOEDA"


	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
	TcSetField(cAliasQry, "E5_DATA" , "D")
		
	dbSelectArea(cAliasQry)

	DbGotop()
	If !EOF() .AND. !BOF()	
		While !(cAliasQry)->(Eof())

			If AdmGetRpo("R1.1") .and. oSelf <> nil
				oSelf:IncRegua2(STR0014) //"Atualizando Saldos Previstos Multinaturezas..."
			EndIf	

			//Atualizo o valor atual para o saldo da natureza
			If lPrjCni
				AtuSldNat(	(cAliasQry)->EV_NATUREZ,;
							 	(cAliasQry)->E5_DATA,;
							 	(cAliasQry)->MOEDA,;
								If((cAliasQry)->EV_TIPO $ MVRECANT+"/"+MV_CRNEG+"/"+MVPAGANT+"/"+MV_CPNEG,"2","3"),;
								(cAliasQry)->CARTEIRA,;
								(cAliasQry)->NVALOR,; 
								(cAliasQry)->NVLCRUZ,; 
								If((cAliasQry)->EV_TIPO $ MVRECANT+"/"+MV_CRNEG+"/"+MVPAGANT+"/"+MV_CPNEG,"-","+"),;
								"D",;
								FunName(),;
								"SEV")
			Else
				AtuSldNat(	(cAliasQry)->EV_NATUREZ,;
							 	(cAliasQry)->E5_DATA,;
							 	(cAliasQry)->MOEDA,;
								If((cAliasQry)->EV_TIPO $ MVRECANT+"/"+MV_CRNEG+"/"+MVPAGANT+"/"+MV_CPNEG,"2","3"),;
								(cAliasQry)->CARTEIRA,;
								(cAliasQry)->NVALOR,; 
								(cAliasQry)->NVLCRUZ,; 
								If((cAliasQry)->EV_TIPO $ MVRECANT+"/"+MV_CRNEG+"/"+MVPAGANT+"/"+MV_CPNEG,"-","+"),;
								"D",;
								FunName())
			EndIf
				
			dbSelectArea(cAliasQry)
			dbSkip()

		EndDo
	Endif	

	dbSelectArea(cAliasQry)
	dbCloseArea()
	fErase(cAliasQry + OrdBagExt())
	fErase(cAliasQry + GetDbExtension())

	dbSelectArea("SE1")

Endif

RestArea(aArea)
Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ F800SNMES  ³ Autor ³ Mauricio Pequim Jr  ³ Data ³ 25.05.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Reprocessa Saldos Previstos - Receber                   	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ F800SNMES() 	                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Void                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function F800SNMES(oSelf ,nInc)		

Local aArea			:= GetArea()
Local cQuery		:= ""
Local lProcessa	:= !(Empty(xFilial("SEW")) .And. nInc > 1)
Local cAliasQry	:= "TRB800H"
Local cDataDe		:= DTOS(FirstDay(mv_par04))
Local cDataAte		:= DTOS(LastDay(mv_par05))
Local lPrjCni 	:= FindFunction("ValidaCNI") .And. ValidaCNI()

DEFAULT oSelf := NIL

dbSelectArea("SEV")
dbSetOrder(1)

If AdmGetRpo("R1.1") .and. oSelf <> nil
	oSelf:SetRegua2(0)
EndIf

IF lProcessa 
	If FIV->(FieldPos("FIV_ABATI")) > 0
		cQuery := "SELECT FIV_FILIAL, FIV_NATUR,FIV_MOEDA, FIV_TPSALD, FIV_CARTEI, FIV_DATA, FIV_VALOR, FIV_ABATI
	Else
		cQuery := "SELECT FIV_FILIAL, FIV_NATUR,FIV_MOEDA, FIV_TPSALD, FIV_CARTEI, FIV_DATA, FIV_VALOR"
	Endif
	cQuery += "FROM " + RetSQLTab('FIV')
	cQuery += " WHERE "
	cQuery += 	"FIV_DATA  >='" + cDataDe	+"' AND "
	cQuery += 	"FIV_DATA  <='" + cDataAte	+"' AND "
	cQuery += 	"FIV_NATUR >='" + mv_par06	+"' AND "
	cQuery += 	"FIV_NATUR <='" + mv_par07	+"' AND " 
	Do Case
	//Orcado	                                  
	Case mv_par08 == 2
		cQuery += "FIV_TPSALD = '1' AND "
	//Previsto
	Case mv_par08 == 3
		cQuery += "FIV_TPSALD = '2' AND "
	//Realizado
	Case mv_par08 == 4
		cQuery += "FIV_TPSALD = '3' AND "
	Endcase
	cQuery += RetSqlCond("FIV")
	cQuery += "ORDER BY FIV_FILIAL,FIV_DATA,FIV_NATUR,FIV_MOEDA,FIV_TPSALD,FIV_CARTEI"
                      
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
	TcSetField(cAliasQry, "FIV_DATA" , "D")
		
	dbSelectArea(cAliasQry)

	DbGotop()
	If !EOF() .AND. !BOF()	
		While !(cAliasQry)->(Eof())

			If AdmGetRpo("R1.1") .and. oSelf <> nil
				oSelf:IncRegua2(STR0012) //"Atualizando saldos Previstos CR das naturezas..."
			EndIf	

			//Atualizo o valor atual para o saldo da natureza 
			If lPrjCni
				AtuSldNat(	(cAliasQry)->FIV_NATUR ,;
						 	(cAliasQry)->FIV_DATA ,;
						 	(cAliasQry)->FIV_MOEDA ,;
							(cAliasQry)->FIV_TPSALD ,;
							(cAliasQry)->FIV_CARTEI ,;
							(cAliasQry)->FIV_VALOR ,; 
							(cAliasQry)->FIV_VALOR ,;
							"+" ,;
							"M",;
							FunName())
			Else
				AtuSldNat(	(cAliasQry)->FIV_NATUR ,;
						 	(cAliasQry)->FIV_DATA ,;
						 	(cAliasQry)->FIV_MOEDA ,;
							(cAliasQry)->FIV_TPSALD ,;
							(cAliasQry)->FIV_CARTEI ,;
							(cAliasQry)->FIV_VALOR ,; 
							(cAliasQry)->FIV_VALOR ,;
							"+" ,;
							"M",;
							FunName(),;
							,;       
							,;
							,;
							,;
							Iif((cAliasQry)->(FieldPos("FIV_ABATI"))>0,(cAliasQry)->FIV_ABATI,0))
			Endif			

			dbSelectArea(cAliasQry)
			dbSkip()

		EndDo
	Endif	

	dbSelectArea(cAliasQry)
	dbCloseArea()
	fErase(cAliasQry + OrdBagExt())
	fErase(cAliasQry + GetDbExtension())

	dbSelectArea("SE1")

Endif

RestArea(aArea)
Return(.T.)





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ AjustaSX1 ³ Autor ³ Mauricio Pequim Jr   ³ Data ³ 25.05.10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Realizar ajustes nos grupos de pergunta do dicionario SX1  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ AjustaSX1()		                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Void                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function AjustaSX1()

LOCAL	aHelpPor := {}
LOCAL	aHelpSpa := {}
LOCAL	aHelpEng := {}
LOCAL nTamNatur:= TamSx3("E2_NATUREZ")[1]
LOCAL cPerg		:= PadR( "AFI800", Len( SX1->X1_GRUPO ) )
Local nTamFilial 	:= IIf( lFWCodFil, FWGETTAMFILIAL, TamSx3( "SE2_FILIAL" )[1] ) 

// Inclusão de pergunta "Modelo de Cadastro"
SX1->( dbSetOrder( 1 ) )

If !SX1->( dbSeek( PadR( "AFI800", Len( X1_GRUPO ) ) ) )

	PutSx1( cPerg, "01","Cons.Filiais Abaixo","Considera Siguientes Suc","Cons.Branches Below",;
				"mv_ch1","N",1,0,1,"C","","","","","mv_par01","Sim","Si","Yes","","Nao","No","No",;
				"","","","","","","","","")
	aAdd( aHelpPor, 'Informe "Sim" caso deseje considerar o ')
	aAdd( aHelpPor, 'intervalo de filiais abaixo, ou "Não" ') 
	aAdd( aHelpPor, 'para considerar apenas a filial corrente.')
	aHelpEng := aHelpSpa := aHelpPor
	PutSX1Help("P.AFI80001.",aHelpPor,aHelpEng,aHelpSpa)
	aHelpEng:= aHelpSpa := aHelpPor := {}


	PutSx1( cPerg, "02","Filial De","De Sucursal","From Branch",;
				"mv_ch2","C",nTamFilial,0,0,"G","","SM0_01","033","","mv_par02","","","","","","","",;
				"","","","","","","","","")
	aAdd( aHelpPor, 'Filial inicial do intervalo de filiais ') 
	aAdd( aHelpPor, 'a serem consideradas na seleção dos' )
	aAdd( aHelpPor, 'dados para o processo.' )
	aHelpEng := aHelpSpa := aHelpPor
	PutSX1Help("P.AFI80002.",aHelpPor,aHelpEng,aHelpSpa)
	aHelpEng:= aHelpSpa := aHelpPor := {}


	PutSx1( cPerg, "03","Filial Ate","A Sucursal","To Branch",;
				"mv_ch3","C",nTamFilial,0,0,"G","","SM0_01","033","","mv_par03","","","","zz","","","",;
				"","","","","","","","","")
	aAdd( aHelpPor, 'Filial final do intervalo de filiais ') 
	aAdd( aHelpPor, 'a serem consideradas na seleção dos' )
	aAdd( aHelpPor, 'dados para o processo.' )
	aHelpEng := aHelpSpa := aHelpPor
	PutSX1Help("P.AFI80003.",aHelpPor,aHelpEng,aHelpSpa)
	aHelpEng:= aHelpSpa := aHelpPor := {}


	PutSx1( cPerg , "04", "Data Inicial","De Data","From Date",;
				"MV_CH4","D",8,0,0,"G","","","","","MV_PAR04","","","","01/01/2010","","","",;
				"","","","","","","","","")
	aAdd( aHelpPor, 'Data inicial do periodo de recalculo  ')
	aAdd( aHelpPor, 'dos saldos das naturezas financeiras.')
	aHelpEng := aHelpSpa := aHelpPor
	PutSX1Help("P.AFI80004.",aHelpPor,aHelpEng,aHelpSpa)
	aHelpEng:= aHelpSpa := aHelpPor := {}


	PutSx1( cPerg , "05", "Data Final","A Fecha","Final Date",;
				"MV_CH5","D",8,0,0,"G","","","","","MV_PAR05","","","","31/12/2010","","","",;
				"","","","","","","","","")
	aAdd( aHelpPor, 'Data final do periodo de recalculo  ')
	aAdd( aHelpPor, 'dos saldos das naturezas financeiras.')
	aHelpEng := aHelpSpa := aHelpPor
	PutSX1Help("P.AFI80005.",aHelpPor,aHelpEng,aHelpSpa)
	aHelpEng:= aHelpSpa := aHelpPor := {}


	PutSx1( cPerg , "06", "Da Natureza","De Naturaleza","From Class",;
				"MV_CH6","C",nTamNatur,0,0,"G","","SED","","","MV_PAR06","","","","","","","",;
				"","","","","","","","","")
	aAdd( aHelpPor, 'Natureza inicial do intervalo de       ')
	aAdd( aHelpPor, 'naturezas para recálculo dos saldos    ')
	aAdd( aHelpPor, 'de naturezas.') 
	aHelpEng := aHelpSpa := aHelpPor
	PutSX1Help("P.AFI80006.",aHelpPor,aHelpEng,aHelpSpa)
	aHelpEng:= aHelpSpa := aHelpPor := {}


	PutSx1( cPerg , "07", "Até a Natureza","A Natureza","To Class",;
				"MV_CH7","C",nTamNatur,0,0,"G","","SED","","","MV_PAR07","","","","ZZZZZZZZZ","","","",;
				"","","","","","","","","")
	aAdd( aHelpPor, 'Natureza final do intervalo de       ')
	aAdd( aHelpPor, 'naturezas para recálculo dos saldos    ')
	aAdd( aHelpPor, 'de naturezas.') 
	aHelpEng := aHelpSpa := aHelpPor
	PutSX1Help("P.AFI80007.",aHelpPor,aHelpEng,aHelpSpa)
	aHelpEng:= aHelpSpa := aHelpPor := {}


	PutSx1( cPerg , "08", "Tipo de Saldo a Recalcular","Tipo de Saldo a Recalcular","Tipo de Saldo a Recalcular",;
				"MV_CH8","N",1,0,1,"C","","","","","MV_PAR08","Todos","Todos","Todos","","Orçados","Orçados","Orçados",;
				"Previstos","Previstos","Previstos","Realizados","Realizados","Realizados")
	aAdd( aHelpPor, 'Escolha o tipo de saldo de naturezas devem ')
	aAdd( aHelpPor, 'ser recalculados pela rotina:')
	aAdd( aHelpPor, 'Todos - Todos os tipos de saldos serão     ')
	aAdd( aHelpPor, '  recalculados (Orçado, Previsto e Realizado)')
	aAdd( aHelpPor, 'Orçados - Apenas saldos orçados serão      ')
	aAdd( aHelpPor, '  recalculados')
	aAdd( aHelpPor, 'Previstos - Apenas saldos previstos serão ')
	aAdd( aHelpPor, '  recalculados ')
	aAdd( aHelpPor, 'Realizados - Apenas saldos realizados serão')
	aAdd( aHelpPor, '  recalculados ')
	aHelpEng := aHelpSpa := aHelpPor
	PutSX1Help("P.AFI80008.",aHelpPor,aHelpEng,aHelpSpa)
	aHelpEng:= aHelpSpa := aHelpPor := {}

Else
	//Corrijo as perguntas 06 e 07 
	If SX1->( dbSeek( PadR( "AFI800", Len( X1_GRUPO ) )+"06" ) )
		RecLock("SX1")
		X1_F3 := "SED"
		MsUnlock()
	Endif
	If SX1->( dbSeek( PadR( "AFI800", Len( X1_GRUPO ) )+"07" ) )
		RecLock("SX1")
		X1_F3 := "SED"
		MsUnlock()
	Endif

EndIf

Return


Static Function PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa,lUpdate,cStatus)
Local cFilePor := "SIGAHLP.HLP"
Local cFileEng := "SIGAHLE.HLE"
Local cFileSpa := "SIGAHLS.HLS"
Local nRet
Local nT
Local nI
Local cLast
Local cNewMemo
Local cAlterPath := ''
Local nPos	

If ( ExistBlock('HLPALTERPATH') )
	cAlterPath := Upper(AllTrim(ExecBlock('HLPALTERPATH', .F., .F.)))
	If ( ValType(cAlterPath) != 'C' )
        cAlterPath := ''
	ElseIf ( (nPos:=Rat('\', cAlterPath)) == 1 )
		cAlterPath += '\'
	ElseIf ( nPos == 0	)
		cAlterPath := '\' + cAlterPath + '\'
	EndIf
	
	cFilePor := cAlterPath + cFilePor
	cFileEng := cAlterPath + cFileEng
	cFileSpa := cAlterPath + cFileSpa
	
EndIf

Default aHelpPor := {}
Default aHelpEng := {}
Default aHelpSpa := {}
Default lUpdate  := .T.
Default cStatus  := ""

If Empty(cKey)
	Return
EndIf

If !(cStatus $ "USER|MODIFIED|TEMPLATE")
	cStatus := NIL
EndIf

cLast 	 := ""
cNewMemo := ""

nT := Len(aHelpPor)

For nI:= 1 to nT
   cLast := Padr(aHelpPor[nI],40)
   If nI == nT
      cLast := RTrim(cLast)
   EndIf
   cNewMemo+= cLast
Next

If !Empty(cNewMemo)
	nRet := SPF_SEEK( cFilePor, cKey, 1 )
	If nRet < 0
		SPF_INSERT( cFilePor, cKey, cStatus,, cNewMemo )
	Else
		If lUpdate
			SPF_UPDATE( cFilePor, nRet, cKey, cStatus,, cNewMemo )
		EndIf
	EndIf
EndIf

cLast 	 := ""
cNewMemo := ""

nT := Len(aHelpEng)

For nI:= 1 to nT
   cLast := Padr(aHelpEng[nI],40)
   If nI == nT
      cLast := RTrim(cLast)
   EndIf
   cNewMemo+= cLast
Next

If !Empty(cNewMemo)
	nRet := SPF_SEEK( cFileEng, cKey, 1 )
	If nRet < 0
		SPF_INSERT( cFileEng, cKey, cStatus,, cNewMemo )
	Else
		If lUpdate
			SPF_UPDATE( cFileEng, nRet, cKey, cStatus,, cNewMemo )
		EndIf
	EndIf
EndIf

cLast 	 := ""
cNewMemo := ""

nT := Len(aHelpSpa)

For nI:= 1 to nT
   cLast := Padr(aHelpSpa[nI],40)
   If nI == nT
      cLast := RTrim(cLast)
   EndIf
   cNewMemo+= cLast
Next

If !Empty(cNewMemo)
	nRet := SPF_SEEK( cFileSpa, cKey, 1 )
	If nRet < 0
		SPF_INSERT( cFileSpa, cKey, cStatus,, cNewMemo )
	Else
		If lUpdate
			SPF_UPDATE( cFileSpa, nRet, cKey, cStatus,, cNewMemo )
		EndIf
	EndIf
EndIf
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ F800DelFJV ³ Autor ³ Alessandro Afonso   ³ Data ³ 15.12.11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Exclui saldos diarios das naturezas p/ reprocessamento	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ F800DelFjv()	                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Void                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function F800DelFJV(oSelf ,nInc)		

Local aArea			:= GetArea()
Local cQuery		:= ""
Local lProcessa	:= !(Empty(xFilial("FJV")) .And. nInc > 1)
Local cAliasQry	:= "TRB800A"

DEFAULT oSelf := NIL

dbSelectArea("FJV")
dbSetOrder(1)

If AdmGetRpo("R1.1") .and. oSelf <> nil
	oSelf:SetRegua2(RecCount())
EndIf

IF lProcessa

	cQuery := "SELECT FJV_FILIAL, FJV_NATUR, FJV_TPSALD, FJV_DATA, "
	cQuery += "	R_E_C_N_O_ RECNO FROM " + RetSQLTab('FJV')
	cQuery += " WHERE "
	cQuery += 	"FJV_DATA >='"+Dtos(mv_par04)+"' AND "
	cQuery += 	"FJV_DATA <='"+Dtos(mv_par05)+"' AND "
	cQuery += 	"FJV_NATUR >='"+ mv_par06 +"' AND "
	cQuery += 	"FJV_NATUR <='"+ mv_par07 +"' AND "
	
	Do Case
	//Orcado
	Case mv_par08 == 2
		cQuery += "FJV_TPSALD = '1' AND "
	//Previsto
	Case mv_par08 == 3
		cQuery += "FJV_TPSALD = '2' AND "   
	//Realizado
	Case mv_par08 == 4
		cQuery += "FJV_TPSALD = '3' AND "
	EndCase
	
	cQuery += RetSqlCond("FJV")

	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
	TcSetField(cAliasQry, "FJV_DATA", "D")
	
	
	dbSelectArea(cAliasQry)

	DbGotop()
	If !EOF() .AND. !BOF()	
		While !(cAliasQry)->(Eof())

			If AdmGetRpo("R1.1") .and. oSelf <> nil
				oSelf:IncRegua2(STR0009) //"Excluindo saldos diários das naturezas para recalculo..."
			EndIf	

			FJV->(dbGoto( (cAliasQry)->RECNO ) )
			RecLock("FJV")		
			dbDelete()
			Msunlock()
				
			dbSelectArea(cAliasQry)
			dbSkip()
		EndDo
	Endif	

	dbSelectArea(cAliasQry)
	dbCloseArea()
	fErase(cAliasQry + OrdBagExt())
	fErase(cAliasQry + GetDbExtension())

	dbSelectArea("FJV")
Endif

RestArea(aArea)
Return(.T.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ F800VLDSE7 ³ Autor ³ Rodrigo Gimenes     ³ Data ³ 31.07.12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida se os saldos orçados não tem natureza sem condição  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ F800VLDSE7 	                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Void                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function F800VLDSE7()		

Local aArea			:= GetArea()
Local cQuery		:= ""
Local cAliasQry	:= "TRB800VLD"
Local cMensagem		:= ""

 
cQuery := "SELECT SE7.E7_ANO,SED.ED_CODIGO "
cQuery += "FROM " + RetSQLTab('SE7')  + " JOIN " + RetSQLTab('SED')  + "  ON (SE7.E7_FILIAL = SED.ED_FILIAL AND SE7.E7_NATUREZ = SED.ED_CODIGO) " 
cQuery += " WHERE "
cQuery += "E7_ANO >='"+RIGHT(STR(YEAR(mv_par04)),4)+"' AND "
cQuery += "E7_ANO <='"+RIGHT(STR(YEAR(mv_par05)),4)+"' AND "
cQuery += "E7_NATUREZ >='"+ mv_par06 +"' AND "
cQuery += "E7_NATUREZ <='"+ mv_par07 +"' AND "
cQuery += "E7_NATUREZ <='"+ mv_par07 +"' AND "
cQuery += " SED.ED_COND NOT  IN ('R', 'D') AND "
cQuery += RetSqlCond("SE7")                
cQuery += " GROUP BY SED.ED_CODIGO, SE7.E7_ANO  "

cQuery := ChangeQuery(cQuery)

cMensagem := ""	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
DbGotop()
If !EOF() .AND. !BOF()	
	cMensagem := STR0020 //"O reprocessamento não pode ser efetuado, pois o(s) seguinte(s) orçamento(s) contém naturezas sem a condição (Receita ou Despesa) :"                                                                                                                                                                                                                                                                                                                                                                                
	While !(cAliasQry)->(Eof())
		cMensagem += CRLF + STR0018 + " " + (cAliasQry)->(E7_ANO) +  STR0019 +  (cAliasQry)->(ED_CODIGO) // Ano : +  + Natureza 
		dbSelectArea(cAliasQry)
		dbSkip()
	EndDo                      
	cMensagem += CRLF +CRLF +  STR0021 //" "Para efetuar o processamento dos saldos orçados, informe a condição (Receita ou Despesa) para no cadastro das naturezas informadas nessa mensagem"                                                                                                                                                                                                                                                                                                                                                                 
	Help(" ",1,"CARTNAT",,cMensagem,1,0)
	
Endif	

dbSelectArea(cAliasQry)
dbCloseArea()
fErase(cAliasQry + OrdBagExt())
fErase(cAliasQry + GetDbExtension())



RestArea(aArea)
Return(Empty(cMensagem)) 