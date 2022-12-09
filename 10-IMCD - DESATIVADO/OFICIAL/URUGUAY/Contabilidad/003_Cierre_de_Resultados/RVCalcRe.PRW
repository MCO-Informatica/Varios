#Include "PROTHEUS.CH"

	#define STR0001 "Reversion de Calculo de Resultados"
	#define STR0002 "Esta rutina borrara los registros contables de Calculo de Resultados."
	#define STR0003 "Seleccionando registros..."
	#define STR0004 "Verifique si la fecha solicitada se refiere al ultimo calculo de resultados efectuado."
	#define STR0005 "No se ubicaron registros de calculo en el periodo, ¿forzar reprocesamiento de saldos?"
	#define STR0006 "¿Actualiza Saldos?"
	#define STR0007 "Si se revirtieran calculos seguidos,"
	#define STR0008 "para incrementar desempeno, "
	#define STR0009 "opte por no actualizar los saldos."
	#define STR0010 "En la ultima reversion utilice "
	#define STR0011 "atualizacion de saldos, o antes de "
	#define STR0012 "otros procesos/consultas efectuar"
	#define STR0013 "reprocesamiento de saldos."
	#define STR0014 "Al final del proceso, antes de ejecutar nuevo calculo, procesos o consultas, "
	#define STR0015 "sera necesario ejecutar reprocesamiento de saldos"
	#define STR0016 "¿Continuar?"
	#define STR0017 "¡ATENCION! Reversion configurada para no actualizar saldos."
	#define STR0018 "Fecha: "
	#define STR0019 " Moneda: "
	#define STR0020 " Tp. Saldo: "
	#define STR0021 "EJECUTANDO EL CALCULO DE LA SUCURSAL "

STATIC __aJaClean := {}
STATIC lFWCodFil := FindFunction("FWCodFil")



/*/{Protheus.doc} RvCalcRe
//TODO Estorno de Apuracao de Resultados -Lucros/Perdas
// CTB > Miscelanea > Cierres > Rv.Calc.Resultados
@author Simone Mie Sato
@since 06/12/2002
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User FUNCTION RvCalcRe()

Local aSays 		:= {}
Local aButtons		:= {}
LOCAL nOpca    		:= 0
Local oProcess 

Private cCadastro 	:= OemToAnsi(STR0001)  //"Estorno de Apuracao Lucros/Perdas"
PRIVATE cString   	:= "CT2"
PRIVATE cDesc1    	:= OemToAnsi(STR0002)  //"Esta rotina ir  excluir os lancamentos contabeis de lucros e perdas."
PRIVATE cDesc2    	:= ""
PRIVATE cDesc3    	:= ""
PRIVATE nomeprog  	:= "RVCALCRE"
PRIVATE aLinha    	:= { },nLastKey := 0
PRIVATE cPerg		:= "RVCIAP"

PRIVATE cCampo	:= ""

Do Case 
Case __LANGUAGE == "PORTUGUESE"
	cCampo	:= "SX5->X5_DESCRI"
Case __LANGUAGE == "SPANISH"
	cCampo	:= "SX5->X5_DESCSPA"
Case __LANGUAGE ="ENGLISH"
	cCampo	:= "SX5->X5_DESCENG"
EndCase

If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01 // Data de Apuracao                                 ³
//³ mv_par02 // Qual Moeda?                                      ³
//³ mv_par03 // Tipo de Saldo 				                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
//AjustaSX1( cPerg )

//Carga las preguntas
Pergunte(cPerg,.f.)

AADD(aSays,OemToAnsi( "Este programa ira revertir los asientos contables de Calculo de Resultados" ) )

//AADD(aButtons, { 9,.T.,{|| MostraSX5ZR() } } )		/// MOSTRA APURACOES JA EFETUADAS.
AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
AADD(aButtons, { 1,.T.,{|| nOpca:= 1, If( CtbOk(), FechaBatch(), nOpca:=0 ) }} )
AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )

If nOpca == 1

	oProcess := MsNewProcess():New({|lEnd| RvCalcRePr(oProcess)},"","",.F.)
	
	oProcess:Activate()		

Endif

Return
	
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³RvCalcRePr³ Autor ³ Simone Mie Sato       ³ Data ³ 06.12.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Estorno da rotina de Apuracao de Lucros Perdas              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RvCalcRePr()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RvCalcRePr                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
STATIC FUNCTION RvCalcRePr(oObj)

Local dDataCR		:= mv_par01
Local cMoeda		:= mv_par02
Local cTpSaldo		:= mv_par03
Local cSublote 		:= "0" + cMoeda	//Alltrim(MV_PAR04)
Local aCtbMoeda 	:= {}
Local nInicio		:= 0
Local nFinal		:= 0
Local dDataFim
Local dDataIni		
Local cFilDe		:= 	""
Local lAtuSaldos	:= .F.
Local dDTIFlg		:= CTOD("  /  /  ")				//DATA PARA INICIO DA REMARCAÇAO DE FLAGS (APURACAO ANTERIOR +1)
Local lPergOk 		:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Antes de comenzar el procesamiento valido parámetros     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
	Case Empty(mv_par01) // Fecha tiene que tener datos
		MsgInfo("La Fecha no puede estar vacía.","Atencion!")
	Case Empty(mv_par02)	//Moneda
		MsgInfo("Debe seleccionar una Moneda.","Atencion!")
	Case Empty(mv_par03) // Tipo de saldo nao preenchido
		MsgInfo("Debe seleccionar un Tipo de Saldo.","Atencion!")
	OtherWise
		lPergOk := .T.
EndCase

If lPergOk .And. !CtbValiDt(1,mv_par01)
	MsgInfo(" ",1," ",,"El Calendario Contable para la fecha ingresada se encuentra cerrado.","Atencion!")	
	lPergOk := .F.
EndIf

aCtbMoeda := CtbMoeda(cMoeda)
If lPergOk .And. Empty(aCtbMoeda[1])
	Help(" ",1,"NOMOEDA")
	lPergOk := .F.
EndIf
 
If lPergOk
	//Verificar se a data solicitada eh o ultimo zeramento.
	lPergOk	:= Ct215VldDt(dDataCR,cTpSaldo,cMoeda)
EndIf

dDTIFlg := Ct215LPAnt(dDataCR,cTpSaldo,cMoeda)

If !lPergOk 
	Return
EndIf

//"Ao final dos Estornos, antes de executar nova apuração, processos ou consultas,"
//"executar reprocessamento de saldos !"
//"Continuar mesmo assim ?"
//"ATENÇÃO ! Estorno configurado para não atualizar saldos."
If !MsgYesNo(STR0014+STR0015+CRLF+STR0016,"Atencion")
	Return
EndIf

//Zerar os valores dos lancamentos de apuracao de lucros/perdas que deverao ser estornados.
Ct215Atual(dDataCR,cMoeda,cTpSaldo,cSublote,oObj,dDTIFlg)

//Atualizar a tabela SX5
Ct215AtSX5(dDataCR,cMoeda,cTpSaldo)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ct215Atual³ Autor ³ Simone Mie Sato       ³ Data ³ 06.12.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Zera/Exclui os lancamentos contabeis de apuracao LP.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ct215Atual()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Ct215Atual())                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Ct215Atual(dDataCR,cMoeda,cTpSaldo,cSublote,oObj,dDTIFlg)

Local aSaveArea	:= GetArea()
Local nMoeda	:= 0
Local nTotRegua	:= CTI->(Reccount())
Local cFilCT2	:= xFilial("CT2")
Local cLoteAtu	:= "" 
Local lTemLcto	:= .F.

DEFAULT dDTIFlg := dDataCR

///////////////////////////////////
//// APAGA REGISTROS DE LANÇAMENTO NO CT2
///////////////////////////////////
dbSelectArea("CT2")     
CT2->(dbOrderNickName("XDTCR"))

If CT2->(dbSeek(xFilial("CT2")+DTOS(dDataCR)+cTpSaldo+cSublote))
	oObj:SetRegua1(nTotRegua)
	cLoteAtu := CT2->CT2_LOTE
		
	While CT2->(!Eof()) .And. CT2->CT2_FILIAL == cFilCT2 .And.;
			CT2->CT2_XDTCR == dDataCR .And. CT2->CT2_TPSALD == cTpSaldo .And. CT2->CT2_SBLOTE == cSublote
		
		lTemLcto := .T.
		oObj:IncRegua1(OemToAnsi(STR0003))
		
		/// LIMPA OS FLAGS DE APURACAO NAS TABELAS DE SALDO
		//CT215FlgLp(CT2->CT2_DEBITO,CT2->CT2_CCD,CT2->CT2_ITEMD,CT2->CT2_CLVLDB, CT2->CT2_MOEDLC, CT2->CT2_TPSALD, dDTIFlg, CT2->CT2_DATA)
		//CT215FlgLp(CT2->CT2_CREDIT,CT2->CT2_CCC,CT2->CT2_ITEMC,CT2->CT2_CLVLCR, CT2->CT2_MOEDLC, CT2->CT2_TPSALD, dDTIFlg, CT2->CT2_DATA)
		
		Reclock("CT2",.F.,.T.)
		dbDelete()
		MsUnlock()
		
	 	CT2->(dbSkip())
	 	
	EndDo
		
EndIf

If lTemLcto
	MsgInfo("Asiento de Calculo de Resultados revertido","Reversion")
Else
	MsgInfo("No existen asientos a seren revertidos, verifique los parametros informados","Reversion")
EndIf

RestArea(aSaveArea)	
Return lTemLcto

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ct215AtSX5³ Autor ³ Simone Mie Sato       ³ Data ³ 06.12.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Atualizo a tabela do SX5.                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ct215AtSX5(dDataCR)                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Ct210AtSX5()                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static FUNCTION Ct215AtSX5(dDataCR,cMoeda,cTpSaldo)

Local aSaveArea	:= GetArea()
Local cChave	:= cEmpAnt+cFilant
Local nX        := 0

//dbSelectArea("SX5")
//dbSetOrder(1)                      
//If MsSeek(xFilial()+'ZR'+cChave)	
//	While !Eof() .And.	SX5->X5_FILIAL == xFilial("SX5") .And.;
//		Subs(SX5->X5_TABELA,1,2) == "ZR" .And.  ;
//		Subs(SX5->X5_CHAVE,1,2) == cEmpAnt .And. ;
//		Subs(SX5->X5_CHAVE,3,2) == cFilAnt 
//		
//		If Subs(&(cCampo),1,8) == Dtos(dDataCR) .And. Subs(&(cCampo),11,1) == cTpSaldo //  .And.  Subs(&(cCampo),9,2) == cMoeda
//			Reclock("SX5",.F.,.T.)
//			dbDelete()
//			MsUnlock()
//		EndIf
//		
//		dbSkip()
//	End
//EndIf


cChave := cEmpAnt+cFilAnt
aSX5ZR := FWGetSX5 ( "ZR", cChave ) 

for nX:= 1 to Len(aSX5ZR)
cTexto := " "
FwPutSX5(/*cFlavour*/, "ZC", cChave, cTexto, cTexto, cTexto, /*cTextoAlt*/)	
Next

RestArea(aSaveArea)
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ct215VldDt³ Autor ³ Simone Mie Sato       ³ Data ³ 09.12.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Verifica se a data solicitada eh ref. o ult. zeramento      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³				                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static FUNCTION Ct215VldDt(dDataCR,cTpSaldo,cMoeda)

Local aSaveArea	:= GetArea()
Local lRet		:= .T.
Local cDataLP	:= DTOS(dDataCR)
Local lSaiW		:= .F.
Local cEmpFil	:= cEmpAnt+cFilAnt
Local cFilSX5	:= ""
Local nX        := 0

dbSelectArea("SX5")
dbSetOrder(1)
cFilSX5	:= xFilial("SX5")

cChave := cEmpAnt+cFilAnt
aSX5ZR := FWGetSX5 ( "ZR", cChave ) 

for nX:= 1 to Len(aSX5ZR)

	If cTpSaldo == SubStr(aSX5ZR[nX,4],11,1)	/// TIPO DE SALDO DEVE SER VERIFICADO INDEPENDENTE DA MOEDA
		lMoedaChk := .T.
		
		If cMoeda <> SubStr(aSX5ZR[nX,4],9,2)
			lMoedaChk := .F.
		Endif
		
		If lMoedaChk	/// SE FOR A MESMA MOEDA / OU PROCESSAMENTO DE TODAS AS MOEDAS
			lSaiW := .T.
			Exit		/// FORÇA SAIDA PRA NAO DESPOSICIONAR O X5 (VAI PEGAR A DATA)
		EndIf
		
	EndIf


Next

if len(aSX5ZR)> 0
If lSaiW .AND. aSX5ZR[nX,1]== cFilSX5 .and. ALLTRIM(aSX5ZR[nX,2]) == "ZR" .and. ALLTRIM(aSX5ZR[nX,3]) == cEmpFil 
	If cDataLP < Substr(aSX5ZR[nX,4],1,8)
		/// SE NÃO FOR A ÚLTIMA DATA DE APURAÇÃO NA EMPRESA E FILIAL
		lRet	:= .F.
		MsgInfo(STR0004,STR0018+DTOC(dDataCR)+STR0019+cMoeda+STR0020+cTpSaldo)//"Verifique se a data solicitada refere-se ao ultimo zeramento efetuado..."//"Data: "//" Moeda: "//" Tp.Saldo: "
	EndIf
EndIf
Endif

//
//dbSeek(xFilial("SX5")+"ZR"+cEmpAnt+Soma1(cFilAnt),.T.)
//SX5->(dbSkip(-1))
//While !lSaiW .AND. SX5->X5_FILIAL == cFilSX5 .and. ALLTRIM(SX5->X5_TABELA) == "ZR" .and. ALLTRIM(SX5->X5_CHAVE) == cEmpFil 
//	If cTpSaldo == SubStr(&(cCampo),11,1)	/// TIPO DE SALDO DEVE SER VERIFICADO INDEPENDENTE DA MOEDA
//		lMoedaChk := .T.
//		
//		If cMoeda <> SubStr(&(cCampo),9,2)
//			lMoedaChk := .F.
//		Endif
//		
//		If lMoedaChk	/// SE FOR A MESMA MOEDA / OU PROCESSAMENTO DE TODAS AS MOEDAS
//			lSaiW := .T.
//			Exit		/// FORÇA SAIDA PRA NAO DESPOSICIONAR O X5 (VAI PEGAR A DATA)
//		EndIf
//		
//	EndIf
//	SX5->(dbSkip(-1))
//EndDo
//
//If lSaiW .AND. SX5->X5_FILIAL == cFilSX5 .and. ALLTRIM(SX5->X5_TABELA) == "ZR" .and. ALLTRIM(SX5->X5_CHAVE) == cEmpFil 
//	If cDataLP < Substr(&(cCampo),1,8)
//		/// SE NÃO FOR A ÚLTIMA DATA DE APURAÇÃO NA EMPRESA E FILIAL
//		lRet	:= .F.
//		MsgInfo(STR0004,STR0018+DTOC(dDataCR)+STR0019+cMoeda+STR0020+cTpSaldo)//"Verifique se a data solicitada refere-se ao ultimo zeramento efetuado..."//"Data: "//" Moeda: "//" Tp.Saldo: "
//	EndIf
//EndIf

RestArea(aSaveArea)/// ATENÇÃO ! MANTER SX5 POSICIONADO NO RETORNO Ct215LPAnt( OBTEM DATA ANTERIOR E IRA DESPOSICIONAR )
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³          ºAutor  ³Microsiga           º Data ³  09/26/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CT215FlgLp(cConta,cCusto,cItem,cCLVL, cMoeda, cTpSaldo, dDataILP, dDataFLP)

Local cKeyJaClean := Alltrim(cMoeda+cTpSaldo+cConta+cCusto+cItem+cClVL)
Local nLenKey	  := Len(alltrim(cKeyJaClean))

If AsCan(__aJaClean,{|x| Substr(x,1,nLenKey) == cKeyJaClean }) <= 0
	
	If !Empty(cCLVL)
		Ct190FlgLP(cFilAnt, "CTI", cConta,cCusto,cItem,cCLVL, dDataILP, cTpSaldo, dDataFLP, cMoeda,,"N")
	EndIf
	If !Empty(cITEM)
		Ct190FlgLP(cFilAnt, "CT4", cConta,cCusto,cItem,"", dDataILP, cTpSaldo, dDataFLP, cMoeda,,"N")
	EndIf
	If !Empty(cCUSTO)
		Ct190FlgLP(cFilAnt, "CT3", cConta,cCusto,"","", dDataILP, cTpSaldo, dDataFLP, cMoeda,,"N")
	EndIf
	If !Empty(cConta)
		Ct190FlgLP(cFilAnt, "CT7", cConta,"","","", dDataILP, cTpSaldo, dDataFLP, cMoeda,,"N")
	EndIf
	
	/// REMARCA FLAG NAS TABELAS DE SALDOS COMPOSTOS
	If !Empty(cCLVL)
		Ct190FlgLP(cFilAnt, "CTU", "","","",cCLVL, dDataILP, cTpSaldo, dDataFLP, cMoeda,,"N")
	EndIf
	If !Empty(cITEM)
		Ct190FlgLP(cFilAnt, "CTU", "","",cITEM,"", dDataILP, cTpSaldo, dDataFLP, cMoeda,,"N")
	EndIf
	If !Empty(cCUSTO)
		Ct190FlgLP(cFilAnt, "CTU", "",cCUSTO,"","", dDataILP, cTpSaldo, dDataFLP, cMoeda,,"N")
	EndIf
	If !Empty(cItem) .and. !Empty(cCUSTO)
		Ct190FlgLP(cFilAnt, "CTV", "",cCUSTO,cITEM,"", dDataILP, cTpSaldo, dDataFLP, cMoeda,,"N")
    EndIf
  	If !Empty(cCLVL) .and. !Empty(cCUSTO)
		Ct190FlgLP(cFilAnt, "CTW", "",cCUSTO,"",cCLVL, dDataILP, cTpSaldo, dDataFLP, cMoeda,,"N")
    EndIf
   	If !Empty(cCLVL) .and. !Empty(cITEM)
		Ct190FlgLP(cFilAnt, "CTW", "","",cITEM,cCLVL, dDataILP, cTpSaldo, dDataFLP, cMoeda,,"N")
    EndIf
   	If !Empty(cCLVL) .and. !Empty(cITEM) .and. !Empty(cCUSTO)
		Ct190FlgLP(cFilAnt, "CTY", "",cCUSTO,cITEM,cCLVL, dDataILP, cTpSaldo, dDataFLP, cMoeda,,"N")
    EndIf
	
	AAdd(__aJaClean,cKeyJaClean)
	
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Ct215LPAntºAutor  ³Microsiga           º Data ³  09/26/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Ct215LPAnt(dDataCR,cTpSaldo,cMoeda)

Local dDTLPAnt := CTOD('  /  /  ')
Local cEmpFil	:= cEmpAnt+cFilAnt
Local cDataLP  := DTOS(dDataCR)
Local cFilSX5  := ""
Local lMoedaChk:= .T.
Local nX       := 0

dbSelectArea("SX5")
cFilSX5 := xFilial("SX5")

//If !Eof() .AND. SX5->X5_FILIAL == cFilSX5 .and. ALLTRIM(SX5->X5_TABELA) == "ZR" .and.;
//	ALLTRIM(SX5->X5_CHAVE) == cEmpFil .and. cDataLP == Substr(&(cCampo),1,8)
//	/// SE JA ESTIVER POSICIONADO NA ÚLTIMA DATA NAO PRECISA PESQUISAR	
//Else
//	/// SE NÃO ESTIVER POSICIONADO LOCALIZA A ÚLTIMA DATA PARA USAR A MESMA LOGICA
//	dbSelectArea("SX5")
//	dbSetOrder(1)
//	dbSeek(cFilSX5+"ZR"+cEmpAnt+Soma1(cFilAnt),.T.)
//	dbSkip(-1)
//	dDataCR := STOD(Substr(&(cCampo),1,8))
//EndIf
//
//SX5->(dbSkip(-1))
//While SX5->X5_FILIAL == cFilSX5 .and. ALLTRIM(SX5->X5_TABELA) == "ZR" .and. ALLTRIM(SX5->X5_CHAVE) == cEmpFil
//	If cTpSaldo == SubStr(&(cCampo),11,1)	/// TIPO DE SALDO DEVE SER VERIFICADO INDEPENDENTE DA MOEDA
//		lMoedaChk := .T.
//		/// SE FOR APURACAO DE MOEDA ESPECIFICA
//		If cMoeda <> SubStr(&(cCampo),9,2)
//			lMoedaChk := .F.	
//		Endif
//		If lMoedaChk	/// SE FOR A MESMA MOEDA / OU PROCESSAMENTO DE TODAS AS MOEDAS
//			If Substr(&(cCampo),1,8) < cDataLP
//				/// SE A DATA DE APURACAO FOR MENOR QUE A DATA FINAL DE APURACAO
//				/// OBTEM A DATA DA APURACAO ANTERIOR
//				dDTLPAnt := STOD(Substr(&(cCampo),1,8))
//				Exit
//			EndIf	
//		EndIf
//	EndIf
//	SX5->(dbSkip(-1))
//EndDo


cChave := cEmpAnt+cFilAnt
aSX5ZR := FWGetSX5 ( "ZR", cChave ) 

for nX:= 1 to Len(aSX5ZR)
	
	dDataCR := STOD(Substr(aSX5ZR[nX,4],1,8))
	
	If cTpSaldo == SubStr(aSX5ZR[nX,4],11,1)	/// TIPO DE SALDO DEVE SER VERIFICADO INDEPENDENTE DA MOEDA
		lMoedaChk := .T.
		/// SE FOR APURACAO DE MOEDA ESPECIFICA
		If cMoeda <> SubStr(aSX5ZR[nX,4],9,2)
			lMoedaChk := .F.	
		Endif
		If lMoedaChk	/// SE FOR A MESMA MOEDA / OU PROCESSAMENTO DE TODAS AS MOEDAS
			If Substr(aSX5ZR[nX,4],1,8) < cDataLP
				/// SE A DATA DE APURACAO FOR MENOR QUE A DATA FINAL DE APURACAO
				/// OBTEM A DATA DA APURACAO ANTERIOR
				dDTLPAnt := STOD(Substr(aSX5ZR[nX,4],1,8))
				Exit
			EndIf	
		EndIf
	EndIf

Next

if len(aSX5ZR)> 0
If lSaiW .AND. aSX5ZR[nX,1]== cFilSX5 .and. ALLTRIM(aSX5ZR[nX,2]) == "ZR" .and. ALLTRIM(aSX5ZR[nX,3]) == cEmpFil 
	If cDataLP < Substr(aSX5ZR[nX,4],1,8)
		/// SE NÃO FOR A ÚLTIMA DATA DE APURAÇÃO NA EMPRESA E FILIAL
		lRet	:= .F.
		MsgInfo(STR0004,STR0018+DTOC(dDataCR)+STR0019+cMoeda+STR0020+cTpSaldo)//"Verifique se a data solicitada refere-se ao ultimo zeramento efetuado..."//"Data: "//" Moeda: "//" Tp.Saldo: "
	EndIf
EndIf
Endif

Return(dDTLPAnt)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSX1    ³Autor ³Simone Mie Sato       ³Data³ 24/02/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta perguntas do SX1                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AjustaSX1(cPerg)

Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01 // Data de Apuracao                                 ³
//³ mv_par02 // Qual Moeda?                                      ³
//³ mv_par03 // Tipo de Saldo 				                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*-----------------------MV_PAR01--------------------------*/
aHelpPor	:=	{}
Aadd( aHelpPor, "Fecha del asiento de Calculo de Resultados" )
aHelpEng	:=	aHelpSpa	:=	aHelpPor
//U_PutSx1UY(cPerg, "01","Fecha Asiento ?","Fecha Asiento ?","Fecha Asiento ?","mv_ch1","D", 8, 0, 0,"G","","","",    "S","mv_par01","","","","","","","","","","","","","","","","",aHelpPor ,aHelpEng ,aHelpSpa)

/*-----------------------MV_PAR02--------------------------*/
aHelpPor	:=	{}
Aadd( aHelpPor, "Moneda del asiento de Calculo de Resultados" )
aHelpEng	:=	aHelpSpa	:=	aHelpPor
//U_PutSx1UY(cPerg, "02","Moneda ?","Moneda ?","Moneda ?","mv_ch2","C",2, 0, 0,"G","","CTO","","S","mv_par02","","","","","","","","","","","","","","","","",aHelpPor ,aHelpEng ,aHelpSpa)

/*-----------------------MV_PAR03--------------------------*/
aHelpPor	:=	{}
Aadd( aHelpPor, "Tipo de saldo del asiento de Calculo de Resultados" )
aHelpEng	:=	aHelpSpa	:=	aHelpPor
//U_PutSx1UY(cPerg, "03","Tipo de Saldo ?","Tipo de Saldo ?","Tipo de Saldo ?","mv_ch3","C",1, 0, 0,"G","","SLW","","S","mv_par03","","","","","","","","","","","","","","","","",aHelpPor ,aHelpEng ,aHelpSpa)


u_UyPutSx1({{cPerg, "01","Fecha Asiento ?","Fecha Asiento ?","Fecha Asiento ?","mv_ch1","D", 8, 0, 0,"G","","","",    "S","mv_par01","","","","","","","","","","","","","","","",""}})
u_UyPutSx1({{cPerg, "02","Moneda ?","Moneda ?","Moneda ?","mv_ch2","C",2, 0, 0,"G","","CTO","","S","mv_par02","","","","","","","","","","","","","","","",""}})
u_UyPutSx1({{cPerg, "03","Tipo de Saldo ?","Tipo de Saldo ?","Tipo de Saldo ?","mv_ch3","C",1, 0, 0,"G","","SLW","","S","mv_par03","","","","","","","","","","","","","","","",""}})

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBA211   ºAutor  ³Marcos S. Lobo      º Data ³  26/09/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MostraSX5ZR()

Local a
Local b
Local c
Local aAreaOri := GetArea()
Local aAreaX5  := {}


dbSelectArea("SX5")
aAreax5 := GetArea()
dbSetOrder(1)
If !MsSeek(xFilial("SX5")+"ZR",.F.)
	MsgInfo("No existen registros","Tabla ZR - Calculo de Resultados")
Else
	ConPad1(a,b,c,"ZR",,,.F.)
EndIf

RestArea(aAreaX5)
RestArea(aAreaOri)

Return
