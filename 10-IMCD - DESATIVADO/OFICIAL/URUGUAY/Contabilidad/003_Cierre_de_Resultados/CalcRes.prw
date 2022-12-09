#Include "PROTHEUS.Ch"

#DEFINE MAX_LINHA		999

Static aFormBatch	:= {}
Static nTamCta		:= TamSx3("CT1_CONTA")[1]
Static nTamCus		:= TamSx3("CTT_CUSTO")[1]
Static nTamItC		:= TamSx3("CTD_ITEM")[1]
Static nTamClVl		:= TamSx3("CTH_CLVL")[1]


/*/{Protheus.doc} CalcRes
//TODO Calculo de Resultados
// CTB > Miscelanea > Cierres > Calculo de Resultados
@author Liber de Esteban
@since 15/01/2013
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function CalcRes()
Local nOpca := 0
Local aSays := {}
Local aButtons := {}
Local aCols := {}
Local cPerg := "CALCRES"

Private cCadastro := "Calculo de Resultados"
Private cSeqCorr  := ""

CALCRESSX1(cPerg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01 // De Fecha                                         ³
//³ mv_par02 // Hasta Fecha                                      ³
//³ mv_par03 // Numero de Documento                              ³
//³ mv_par04 // Cod. Historial                                   ³
//³ mv_par05 // De Cuenta 		        				         ³
//³ mv_par06 // Hasta Cuenta                             		 ³
//³ mv_par07 // Moneda                                           ³
//³ mv_par08 // Tipo de Saldo 				                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(cPerg,.F.)
//Ct381Moedas(aCols)

AADD(aSays, "El Objetivo de este programa es generar el Calculo de Resultados")
AADD(aSays, "se tomará para generar el cálculo, todas las cuentas contables")
AADD(aSays, "y se cerrará el saldo a la moneda indicada en el parámetro.")

AADD(aButtons, { 5,.T., 	{|| (Pergunte(cPerg,.T. ), .T.) } } )
AADD(aButtons, { 1,.T., 	{|| nOpca:= 1, If( ConaOk(),FechaBatch(), nOpca:=0 ) }} )
AADD(aButtons, { 2,.T., 	{|| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons )


////Procesamiento
If nOpca == 1
	If FindFunction("CTBSERIALI")
		If !CTBSerialI("CTBPROC","OFF")
			Return
		Endif
	EndIf
	Processa({|lEnd| CalcResPro()})
	If FindFunction("CTBSERIALI")
		CtbSerialF("CTBPROC","OFF")
	EndIF
EndIf


Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion     ³CalcResPro³ Autor ³ Liber de Esteban      ³ Fecha ³ 22.04.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripcion ³ Generar Asiento de Calculo de Resultados                	 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxis    ³ CalcResPro()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros  ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ Calculo de Resultados                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CalcResPro()
Local lRet 		:= .F.
Local lTemLcto 	:= .F.
Local dDataIni 	:= MV_PAR01
Local dDataFin 	:= MV_PAR02
Local cNroDoc 	:= Alltrim(MV_PAR03) 
Local cHistor 	:= Alltrim(MV_PAR04) 
Local cCtaIni 	:= Alltrim(MV_PAR05) 
Local cCtaFin 	:= Alltrim(MV_PAR06)
Local cMoeda 	:= Alltrim(MV_PAR07)
Local cTpSaldo 	:= Alltrim(MV_PAR08)
Local cLote 	:= "RESULT" 
Local cSublote 	:= "0" + cMoeda
Local nTipoSal  := Val(cTpSaldo)
Local cFilIni	:= MV_PAR09
Local cFilFin	:= MV_PAR10
Local cCuentaLP	:= MV_PAR11
Local cCostoLP	:= MV_PAR12
Local cItemLP	:= MV_PAR13
Local cClVlLP	:= MV_PAR14
Local dDataCr	:= dDataFin // dDataBase
Local cCampo	:= ""
Local cCuenta	:= ""
Local cCC		:= ""
Local cItemC	:= ""
Local cCLVL		:= ""
Local cTipoS	:= "" //para indicar si tiene tipo saldo deudor o acreedor
Local nSaldo	:= 0
Local nSalDebLP := 0
Local nSalCreLP := 0
Local cLinha 	:= "001" 
Local cMoedaLanc:= "" 
Local cDebito	:= ""
Local cCredito	:= ""
Local cTipoAsie	:= ""
Local cCostoDeb, cCostoCrd, cItemDeb, cItemCrd, cClVlDeb, cClVlCrd := ""
Local cHist		:= "Calculo de Resultados" + " " + StrZero(Month(dDataFin),2)+"/" + StrZero(Year(dDataFin),4)
Local nx := 0
//Local cNroDoc := ""
PRIVATE cAlias := "REP"  
PRIVATE aCols 		:= {}

//Chequea campo del SX5 a ser actualizado
Do Case 
Case __LANGUAGE == "PORTUGUESE"
	cCampo	:= "SX5->X5_DESCRI"
Case __LANGUAGE == "SPANISH"
	cCampo	:= "SX5->X5_DESCSPA"
Case __LANGUAGE ="ENGLISH"
	cCampo	:= "SX5->X5_DESCENG"
EndCase 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Antes de comenzar el procesamiento valido parámetros     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
	Case Empty(dDataIni) // Fecha tiene que tener datos
		MsgInfo("La Fecha no puede estar vacía.","Atencion!")
	Case Empty(dDataFin) // Fecha tiene que tener datos
		MsgInfo("La Fecha no puede estar vacía.","Atencion!")
	Case Empty(cNroDoc)// Documento
		MsgInfo("Debe ingresar un Número de Documento.","Atencion!")
	Case Empty(cHistor) // Historico
		MsgInfo("Debe ingresar un Histórico","Atencion!")
	Case Empty(cCtaIni) .And. Empty(cCtaFin)// Debe ingresar una cuenta Contable Fin
		MsgInfo("Debe ingresar un rango de Cuenta Contable.","Atencion!")
	Case Empty(cMoeda)	//Moneda
		MsgInfo("Debe seleccionar una Moneda.","Atencion!")
	Case Empty(cTpSaldo) // Tipo de saldo nao preenchido
		MsgInfo("Debe seleccionar un Tipo de Saldo.","Atencion!")
	Case Empty(cCuentaLP) // Cuenta LP nao informada
		MsgInfo("Debe seleccionar una Cuenta para el Calculo.","Atencion!")
	OtherWise
		lRet := .T.
EndCase

If lRet .And. ( !CtbValiDt(1,dDataIni) .Or. !CtbValiDt(1,dDataFin) )
	lRet := .F.
EndIf

If !lRet
	Return(lRet)
EndIf

//Chequea en SX5 si ya fue gravado para fecha informada
/*
dbSelectarea("SX5")
dbSetOrder(1)
If MsSeek(xFilial()+"ZR"+cEmpAnt+cFilAnt)
	While !Eof() .and. SX5->X5_TABELA == "ZR"
		If Subs(&(cCampo),1,8) == Dtos(dDataCr)
			If Subs(&(cCampo),9,2) == cMoeda .And. Subs(&(cCampo),11,1) == cTpSaldo
				CT2->(dbOrderNickName("XDTCR"))
				If CT2->(dbSeek(xFilial("CT2")+DTOS(dDataCr)+cTpSaldo+cSublote))
					MsgInfo("Asiento de Calculo de Resultados ya generado en esta fecha. Primero se debe revertir el asiento","Calculo de Resultados")
					Return(.F.)
				Else
					Reclock("SX5",.F.,.T.)
					SX5->(dbDelete())
					SX5->(MsUnlock())
				EndIf
			EndIf
		Endif
		dbSkip() 
	End			
EndIf

*/
cChave := cEmpAnt+cFilAnt
aSX5ZR := FWGetSX5 ( "ZR", cChave ) 

for nX:= 1 to Len(aSX5ZR)
			If SUBSTR( aSX5ZC[nX,4],1,8) == Dtos(dDataCr)
			If Subs( aSX5ZC[nX,4],9,2) == cMoeda .And. Subs( aSX5ZC[nX,4],11,1) == cTpSaldo
				CT2->(dbOrderNickName("XDTCR"))
				If CT2->(dbSeek(xFilial("CT2")+DTOS(dDataCr)+cTpSaldo+cSublote))
					MsgInfo("Asiento de Calculo de Resultados ya generado en esta fecha. Primero se debe revertir el asiento","Calculo de Resultados")
					Return(.F.)
				Else
				cTexto := " "
				FwPutSX5(/*cFlavour*/, "ZC", cChave, cTexto, cTexto, cTexto, /*cTextoAlt*/)	
				EndIf
			EndIf
		Endif
		dbSkip() 
next

If !MsgYesNo("Al final del proceso, antes de ejecutar nuevo calculo, procesos o consultas, "+CRLF+;
             "sera necesario ejecutar reprocesamiento de saldos"+CRLF+"¿Continuar?","Atencion")
	Return(.F.)
EndIf

//////////////////////////
///////CONSULTA SQL////// 
/////////////////////////  
dbSelectArea("CT2")
CT2->(dbSetOrder(1))  

cAlias	:=	GetNextAlias() 

	BeginSql Alias cAlias   
		SELECT SALDOS.CUENTA, SALDOS.CCOSTO, SALDOS.ITEM, SALDOS.CVALOR
				,ROUND(SUM(SALDOS.DEBITO),2) AS DEBITO, ROUND(SUM(SALDOS.CREDITO),2) AS CREDITO
		FROM 
		(	
			SELECT	CT2.CT2_CREDIT AS CUENTA, CT2.CT2_CCC AS CCOSTO
					,CT2.CT2_ITEMC AS ITEM, CT2.CT2_CLVLCR AS CVALOR
					,0 AS DEBITO
					,SUM(CT2.CT2_VALOR) AS CREDITO  
			FROM %Table:CT2% CT2, %Table:CT1% CT1
			WHERE
				CT2.CT2_MOEDLC = %Exp:cMoeda% AND
				CT1.%NotDel% AND CT2.%NotDel% AND
				CT2.CT2_DATA >= %Exp:dDataIni% AND
				CT2.CT2_DATA <= %Exp:dDataFin% AND
				CT2.CT2_CREDIT >= %Exp:cCtaIni% AND  CT2.CT2_CREDIT <= %Exp:cCtaFin% AND
				CT2.CT2_TPSALD = %Exp:nTipoSal% AND
				CT2.CT2_FILIAL >= %Exp:cFilIni% AND
				CT2.CT2_FILIAL <= %Exp:cFilFin% AND
				CT2.CT2_CREDIT = CT1.CT1_CONTA
			GROUP BY CT2.CT2_CREDIT, CT2.CT2_CCC, CT2.CT2_ITEMC, CT2.CT2_CLVLCR
			
			UNION ALL
			
			SELECT CT2.CT2_DEBITO AS CUENTA, CT2.CT2_CCD AS CCOSTO
					,CT2.CT2_ITEMD AS ITEM, CT2.CT2_CLVLDB AS CVALOR
					,SUM(CT2.CT2_VALOR) AS DEBITO 
					,0 AS CREDITO 
			FROM %Table:CT2% CT2, %Table:CT1% CT1
			WHERE	
					CT2.CT2_MOEDLC = %Exp:cMoeda% AND
					CT1.%NotDel% AND CT2.%NotDel% AND
					CT2.CT2_DATA >= %Exp:dDataIni% AND
					CT2.CT2_DATA <= %Exp:dDataFin% AND
					CT2.CT2_DEBITO >= %Exp:cCtaIni% AND  CT2.CT2_DEBITO <= %Exp:cCtaFin% AND
					CT2.CT2_TPSALD = %Exp:nTipoSal% AND  
					CT2.CT2_FILIAL >= %Exp:cFilIni% AND
					CT2.CT2_FILIAL <= %Exp:cFilFin% AND
					CT2.CT2_DEBITO = CT1.CT1_CONTA
			GROUP BY CT2.CT2_DEBITO, CT2.CT2_CCD, CT2.CT2_ITEMD, CT2.CT2_CLVLDB
		) SALDOS
		
		GROUP BY SALDOS.CUENTA, SALDOS.CCOSTO, SALDOS.ITEM, SALDOS.CVALOR
		ORDER BY SALDOS.CUENTA, SALDOS.CCOSTO, SALDOS.ITEM, SALDOS.CVALOR
	EndSql 

///////////////////////
/////// FIN SQL ///////
///////////////////////

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calculo los saldos y gravo el asiento       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
(cAlias)->(DbGoTop())
Do While !(cAlias)->(Eof ())
	nSaldo := 0
	
   	If ( (cAlias)->DEBITO - (cAlias)->CREDITO ) > 0
   	
		cDebito   := ""
		cCredito  := (cAlias)->CUENTA
		cCuenta	  := cCredito
		
		cCostoDeb := ""
		cCostoCrd := (cAlias)->CCOSTO
		cCC		  := cCostoCrd
		
		cItemDeb  := ""
		cItemCrd  := (cAlias)->ITEM
		cItemC	  := cItemCrd
		
		cClVlDeb  := ""
		cClVlCrd  := (cAlias)->CVALOR
		cCLVL	  := cClVlCrd
		
		cTipoAsie := "2"
		nSaldo 	  := (cAlias)->DEBITO - (cAlias)->CREDITO
		nSalDebLP += nSaldo
		
	ElseIf ( (cAlias)->DEBITO - (cAlias)->CREDITO ) < 0
	
		cDebito   := (cAlias)->CUENTA
		cCredito  := ""
		cCuenta	  := cDebito
		
		cCostoDeb := (cAlias)->CCOSTO
		cCostoCrd := ""
		cCC		  := cCostoDeb
		
		cItemDeb  := (cAlias)->ITEM
		cItemCrd  := ""
		cItemC	  := cItemDeb
		
		cClVlDeb  := (cAlias)->CVALOR
		cClVlCrd  := ""
		cCLVL	  := cClVlDeb
		
		cTipoAsie := "1"
		nSaldo 	  := ((cAlias)->DEBITO - (cAlias)->CREDITO) * -1
		nSalCreLP += nSaldo
		
	EndIf
	
	//Cargo Moneda del asiento que voy a generar
	cMoedaLanc := cMoeda
	
	BEGIN TRANSACTION
		If Round(nSaldo,2) <> 0
			U_GravAsie(	dDataFin, cLote, cSublote, cNroDoc, cLinha, cTipoAsie, cMoedaLanc, cHistor, cDebito,;
						cCredito, cCostoDeb, cCostoCrd, cItemDeb, cItemCrd, cClVlDeb,;
						cClVlCrd, Round(nSaldo,2), cHist, "1", "", 3, .T., aCols,;
						cEmpAnt, cFilAnt,,,,,, "CALCRES",,,,dDataCr,,,,,,dDataCr)
			
			//Genero linea en blanco//
			If cMoedaLanc <> '01'
		   		U_GravAsie(	dDataFin, cLote, cSublote, cNroDoc, cLinha, cTipoAsie, '01', cHistor, cDebito,;
						cCredito, cCostoDeb, cCostoCrd, cItemDeb, cItemCrd, cClVlDeb,;
						cClVlCrd, 0, cHist, "1", "", 3, .T., aCols,;
						cEmpAnt, cFilAnt,,,,,, "CALCRES",,,,dDataCr,,,,,,dDataCr) 
			EndIf
			
			lTemLcto := .T.
					  
			cLinha := Soma1(cLinha)  
			CT2->(dbCommit())
		EndIf
    END TRANSACTION	
	
	(cAlias)->(dbSkip())
EndDo	

(cAlias)->(DbCloseArea ())

//Genera patas del asiento para la cuenta de LP
If lTemLcto
    If nSalDebLP > 0
	
		cDebito   := cCuentaLP
		cCredito  := ""
		cCuenta	  := cDebito
		
		cCostoDeb := cCostoLP
		cCostoCrd := ""
		cCC		  := cCostoDeb
		
		cItemDeb  := cItemLP
		cItemCrd  := ""
		cItemC	  := cItemDeb
		
		cClVlDeb  := cClVlLP
		cClVlCrd  := ""
		cCLVL	  := cClVlDeb
		
		cTipoAsie := "1"
		nSaldo 	  := nSalDebLP
		
	EndIf
	
    If nSalCreLP > 0
	
		cDebito   := cCuentaLP
		cCredito  := ""
		cCuenta	  := cDebito
		
		cCostoDeb := cCostoLP
		cCostoCrd := ""
		cCC		  := cCostoDeb
		
		cItemDeb  := cItemLP
		cItemCrd  := ""
		cItemC	  := cItemDeb
		
		cClVlDeb  := cClVlLP
		cClVlCrd  := ""
		cCLVL	  := cClVlDeb
		
		cTipoAsie := "2"
		nSaldo 	  := nSalCreLP
		
	EndIf
	
	//Cargo Moneda del asiento que voy a generar
	cMoedaLanc := cMoeda
	
	BEGIN TRANSACTION
		If Round(nSaldo,2) <> 0
			U_GravAsie(	dDataFin, cLote, cSublote, cNroDoc, cLinha, cTipoAsie, cMoedaLanc, cHistor, cDebito,;
						cCredito, cCostoDeb, cCostoCrd, cItemDeb, cItemCrd, cClVlDeb,;
						cClVlCrd, Round(nSaldo,2), cHist, "1", "", 3, .T., aCols,;
						cEmpAnt, cFilAnt,,,,,, "CALCRES",,,,dDataCr,,,,,,dDataCr)
			
			//Genero linea en blanco//
			If cMoedaLanc <> '01'
		   		U_GravAsie(	dDataFin, cLote, cSublote, cNroDoc, cLinha, cTipoAsie, '01', cHistor, cDebito,;
						cCredito, cCostoDeb, cCostoCrd, cItemDeb, cItemCrd, cClVlDeb,;
						cClVlCrd, 0, cHist, "1", "", 3, .T., aCols,;
						cEmpAnt, cFilAnt,,,,,, "CALCRES",,,,dDataCr,,,,,,dDataCr) 
			EndIf
			
			lTemLcto := .T.
					  
			cLinha := Soma1(cLinha)  
			CT2->(dbCommit())
		EndIf
    END TRANSACTION	
    
	//Actualiza fecha del Cierre/Apertura en SX5
	Ct211AtSx5(dDataCR,cMoeda,cTpSaldo)
	
    MsgInfo("Asiento de Calculo de Resultados generado con exito","Calculo de Resultados")

Else

	MsgInfo("No se genero ningun asiento, verifique los parametros informados","Calculo de Resultados")
	
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FormBatch³ Autor ³ Juan Jose Pereira	    ³ Data ³ 04/12/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Monta tela generica para processo batch					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FormBatch( cTitle, aSays, aButtons, lOk, bValid )		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parƒmetros³ cTitle = Titulo da janela								  ³±±
±±³			 ³ aSays  = Array com Says 									  ³±±
±±³			 ³ aButtons = Array com bottoes								  ³±±
±±³			 ³ aButtons[i,1] = Tipo de botao 							  ³±±
±±³			 ³ aButtons[i,2] = Tipo de enabled							  ³±±
±±³			 ³ aButtons[i,3] = bAction 									  ³±±
±±³			 ³ aButtons[i,4] = Hint do Botao							  ³±±
±±³			 ³ bValid = Bloco de validacao do Form 						  ³±±
±±³			 ³ nAltura= Altura do Form em Pixel (Default 250)			  ³±±
±±³			 ³ nLargura = Largura do Form em Pixel (Default 520)		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
#DEFINE LARGURA_DO_SBUTTON 32

Static Function FormBatch( cTitle, aSays, aButtons, bValid, nAltura, nLargura )

Local nButtons:= Len(aButtons),;
nSays:= Len(aSays),;
oSay,;
i,nTop, nType, lEnabled, oFormPai, oFont,;
nLarguraBox, nAlturaBox, nLarguraSay, cTextSay

DEFAULT aSays:={}, aButtons:={}
DEFAULT nAltura:= 250, nLargura:= 520

// Numero maximo de linhas //
If( nSays>7 )
	nSays:=7
EndIf

// Numero maximo de botoes //
If( nButtons>5 )
	nButtons:= 5
EndIf

oFormPai:= Atail(aFormBatch)
If( oFormPai==NIL )
	oFormPai:= oMainWnd
EndIf

DEFINE FONT oFont NAME "Arial" SIZE 0, -11

DEFINE MSDIALOG oDlg TITLE cTitle FROM 0,0 TO nAltura,nLargura OF oFormPai PIXEL

AADD(aFormBatch,oDlg)

nAlturaBox:= (nAltura-60)/2
nLarguraBox:= (nLargura-20)/2
@ 10,10 TO nAlturaBox,nLarguraBox OF oDlg PIXEL

//======================================================//
// monta says (bof)										//
//======================================================//
nTop:=20

nLarguraSay:= nLarguraBox-30
For i:=1 to nSays
	cTextSay:= "{||'"+aSays[i]+"'}"
	oSay := TSay():New( nTop, 20, MontaBlock(cTextSay),oDlg,, oFont, .F., .F., .F., .T.,,, nLarguraSay, 10, .F., .F., .F., .F., .F. )
	nTop+= 10
Next

//======================================================//
// monta bottoes(bof) 											 //
//======================================================//
nPosIni:= ((nLargura-20)/2) - (nButtons* LARGURA_DO_SBUTTON )
nAlturaButton:= nAlturaBox+10

For i:=1 to nButtons
	nType:= aButtons[i,1]
	lEnabled:= aButtons[i,2]
	
	DEFAULT lEnabled:= .T.
	
	If lEnabled
		If Len(aButtons[i]) > 3 .And. ValType(aButtons[i,4]) == "C"
			SButton():New( nAlturaButton, nPosIni, nType,aButtons[i,3],oDlg,.T.,aButtons[i,4])
		Else
			SButton():New( nAlturaButton, nPosIni, nType,aButtons[i,3],oDlg,.T.,,)
		Endif
	Else
		SButton():New( nAlturaButton, nPosIni, nType,,oDlg,.F.,,)
	EndIf
	
	nPosIni+= LARGURA_DO_SBUTTON
Next
//======================================================//
// monta bottoes(bof) 											 //
//======================================================//
oDlg:Activate( ,,,.T.,bValid,,,, )

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±Fun‡„o	 ³FechaBatch³ Autor ³ Juan Jose Pereira	    ³ Data ³ 04/12/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Fecha Ultima tela de batch 								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ FechaBatch()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function FechaBatch()

Local oDlg:= Atail( aFormBatch )

oDlg:End()

ASize( aFormBatch,Len(aFormBatch)-1 )

Return nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CALCRESSX1   ³Autor ³ TOTVS Uruguay        ³Data³ 15/01/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta perguntas do SX1                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CALCRESSX1(cPerg)

Local aArea 	:= GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01 // De Fecha                                         ³
//³ mv_par02 // Hasta Fecha                                      ³
//³ mv_par05 // Numero de Documento                              ³
//³ mv_par06 // Cod. Historial                                   ³
//³ mv_par07 // De Cuenta 		        				         ³
//³ mv_par08 // Hasta Cuenta                             		 ³
//³ mv_par09 // Moneda                                           ³
//³ mv_par10 // Tipo de Saldo 				                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//AjustaSx1(cPerg,aPergs)
u_UyPutSx1({{"CALCRES","01","Da Data?","De Fecha ?","From Date ?", "mv_ch1", "D", 8,0,0, "G", "", "", "", "S","mv_par01","","","","", "", "", "", "", "", "", "", "", "", "", "", ""}})
u_UyPutSx1({{"CALCRES","02","Ate a Data ?","A Fecha ?","To Date ?", "mv_ch2", "D", 8,0,0, "G", "", "", "", "S","mv_par02","","","","", "", "", "", "", "", "", "", "", "", "", "", ""}})
u_UyPutSx1({{"CALCRES","03","Numero do Documento ?","Numero de Documento ?","Document Number ?", "mv_ch3", "C", 6,0,0, "G", "", "", "", "S","mv_par03","","","", "", "", "", "", "", "", "", "", "", "", "", "", ""}})
u_UyPutSx1({{"CALCRES","04","Cod.Historico Padrao ?","Cod.Hist.Estandar ?","Standard Hist.Code ?", "mv_ch4", "C", 3,0,0, "G", "",    "CT8", "", "S","mv_par04","","","", "", "", "", "", "", "", "", "", "", "", "", "", ""}})
u_UyPutSx1({{"CALCRES","05","Da Conta ?","De Cuenta ?","From Account ?", "mv_ch5", "C", nTamCta,0,0, "G", "", "CT1", "003", "S","mv_par05","","","","", "", "", "", "", "", "", "", "", "", "", "", ""}})
u_UyPutSx1({{"CALCRES","06","Ate a Conta ?","A Cuenta ?","To Account ?", "mv_ch6", "C", nTamCta,0,0, "G", "", "CT1", "003", "S","mv_par06","","","","", "", "", "", "", "", "", "", "", "", "", "", ""}})
u_UyPutSx1({{"CALCRES","07","Moeda Base ?","Moneda base ?","Currency base ?", "mv_ch7", "C", 2,0,0, "G", "", "CTO", "", "S","mv_par07","","","","", "", "", "", "", "", "", "", "", "", "", "", ""}})
u_UyPutSx1({{"CALCRES","08","Tipo de Saldo ?","Tipo de Saldo ?","Balance Type ?", "mv_ch8", "C", 1,0,0, "G", "", "SLD", "", "S","mv_par08","","","","", "", "", "", "", "", "", "", "", "", "", "", ""}})
u_UyPutSx1({{"CALCRES","09","De Sucursal ?","De Sucursal ?","De Sucursal ?", "mv_ch9", "C", 2,0,0, "G", "", "", "", "S","mv_par09","","","","", "", "", "", "", "", "", "", "", "", "", "", ""}})
u_UyPutSx1({{"CALCRES","10","Hasta Sucursal ?","Hasta Sucursal ?","Hasta Sucursal ?", "mv_cha", "C", 2,0,0, "G", "", "", "", "S","mv_par10","","","","", "", "", "", "", "", "", "", "", "", "", "", ""}})
u_UyPutSx1({{"CALCRES","11","Conta Calculo ?","Cuenta Calculo ?","Cuenta Calculo ?", "mv_chb", "C", nTamCta,0,0, "G", "", "CT1", "", "S","mv_par11","","","","", "", "", "", "", "", "", "", "", "", "", "", ""}})
u_UyPutSx1({{"CALCRES","12","C.Costo Calculo ?","C.Costo Calculo ?","C.Costo Calculo ?", "mv_chc", "C", nTamCus,0,0, "G", "", "CTT", "", "S","mv_par12","","","","", "", "", "", "", "", "", "", "", "", "", "", ""}})
u_UyPutSx1({{"CALCRES","13","Item Contab. Calculo ?","Item Contab. Calculo ?","Item Contab. Calculo ?", "mv_chd", "C", nTamItC,0,0, "G", "", "CTD", "", "S","mv_par13","","","","", "", "", "", "", "", "", "", "", "", "", "", ""}})
u_UyPutSx1({{"CALCRES","14","Cl. Valor Calculo ?","Cl. Valor Calculo ?","Cl. Valor Calculo ?", "mv_chr", "C", nTamClVl,0,0, "G", "", "CTH", "", "S","mv_par14","","","","", "", "", "", "", "", "", "", "", "", "", "", ""}})

RestArea(aArea)
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ct211AtSX5³ Autor ³ Simone Mie Sato       ³ Data ³ 11.01.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Atualizo a tabela do SX5.                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ct211AtSX5(dDataCr)                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Ct211AtSX5()                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static FUNCTION Ct211AtSx5(dDataCr,cMoeda,cTpSaldo)

Local aSaveArea	:= GetArea()
Local cChave	:= cEmpAnt+cFilant
Local cCampo	:= ""
Local lExiste	:= .F.
Local cChar		:= "Z"

Do Case 
Case __LANGUAGE == "PORTUGUESE"
	cCampo	:= "SX5->X5_DESCRI"
Case __LANGUAGE == "SPANISH"
	cCampo	:= "SX5->X5_DESCSPA"
Case __LANGUAGE ="ENGLISH"
	cCampo	:= "SX5->X5_DESCENG"
EndCase

dbSelectArea("SX5")
dbSetOrder(1)

If !MsSeek(xFilial()+'ZR'+cChave)
	Reclock("SX5",.T.)
	SX5->X5_FILIAL := xFilial()
	SX5->X5_TABELA	:= 'ZR'
	SX5->X5_CHAVE	:= cChave
	&(cCampo)		:= Dtos(dDataCr)+cMoeda+cTpSaldo+cChar
	MsUnlock()
Else
	While !Eof() .And. SX5->X5_FILIAL == xFilial() .And. SX5->X5_TABELA = 'ZR' .And. Subs(SX5->X5_CHAVE,1,4) == cChave

		If Subs(&(cCampo),1,8) == Dtos(dDataCr)
			If Subs(&(cCampo),9,2) == cMoeda .And. Subs(&(cCampo),11,1) = cTpSaldo .And. Subs(&(cCampo),12,1) == cChar
				lExiste	:= .T.
			EndIf
		EndIf
		
		If !lExiste
			Reclock("SX5",.T.)
			SX5->X5_FILIAL 	:= xFilial()
			SX5->X5_TABELA	:= 'ZR'
			SX5->X5_CHAVE	:= cChave
			&(cCampo)		:= Dtos(dDataCr)+cMoeda+cTpSaldo+cChar
			MsUnlock()
		EndIf
		
		dbSkip()
	End
EndIf

RestArea(aSaveArea)

Return
