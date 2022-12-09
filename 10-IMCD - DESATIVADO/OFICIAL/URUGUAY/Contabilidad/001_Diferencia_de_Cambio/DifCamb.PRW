#Include "PROTHEUS.Ch"

#DEFINE MAX_LINHA		999

Static aFormBatch:={} 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion     ?DIFCAMB  ?Autor ?TOTVS UY            ?Fecha ?01/04/2013 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripcion ?Calculo de Diferencia de Cambio                             ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxis    ?DIFCAMB(void)                                               ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±?Uso        ?Generico                                                    ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function DifCamb()
Local nOpca := 0
Local aSays := {}, aButtons := {}
Local aCols := {}
Local lCC	:= .F.
Local lIT	:= .F.
Local lCL	:= .F.  
Local lMV	:= .F.

Private cCadastro := "Calculo de Diferencia de Cambio"
Private cSeqCorr  := ""


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//?Variaveis utilizadas para parametros                         ?
//?mv_par01 // Hasta Fecha                                      ?
//?mv_par02 // Numero de Lote			                         ?
//?mv_par03 // Numero de SubLote		                         ?
//?mv_par04 // Numero de Documento                              ?
//?mv_par05 // Cod. Historial                                   ?
//?mv_par06 // De Cuenta 		        				         ?
//?mv_par07 // Hasta Cuenta                             		 ?
//?mv_par08 // Moneda                                           ?
//?mv_par09 // Tipo de Saldo 				                     ?
//?mv_par10 // Cuentas de Dif. de Cambio                        ?
//?mv_par11 // Cuenta Dif. Cambio Ganancias                     ?
//?mv_par12 // Cuenta Dif. Cambio Perdidas     				 ?
//?mv_par13 // Considera CC     				 				 ?
//?mv_par14 // Considera Item Contable    						 ?
//?mv_par15 // Considera Clase Valor		     				 ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte("DIFCAMB",.T.)
//Ct381Moedas(aCols)
Ct381Moedas(aCols)

AADD(aSays, "El Objetivo de este programa es generar los asientos de Diferencia de Cambio")
AADD(aSays, "Se tomar?para generar el cálculo, el Tipo de Cambio de cada moneda")
AADD(aSays, "al último día del período correspondiente.")
AADD(aSays, "Una vez finalizado el proceso deber?ejecutar el proceso para la ")
AADD(aSays, "actualización de los Saldos Contables.")

AADD(aButtons, { 5,.T., 	{|| (Pergunte("DIFCAMB",.T. ), .T.) } } )
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
	Processa({|lEnd| DifCProc()})
	If FindFunction("CTBSERIALI")
		CtbSerialF("CTBPROC","OFF")
	EndIF
EndIf


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion     ³DifCProc  ?Autor ?TOTVS UY            ?Fecha ?01/04/2013 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripcion ?Calculo de Diferencia de Cambio                        	 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxis    ?DifCProc()                                                  ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros  ?                                                            ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±?Uso        ?Diferencia de Cambio                                        ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function DifCProc()

Local lRet := .F.
Local cDataFin 	:= MV_PAR01
Local cLote 	:= MV_PAR02
Local cSublote 	:= MV_PAR03
Local cNroDoc 	:= MV_PAR04 
Local cHistor 	:= MV_PAR05 
Local cCtaIni 	:= MV_PAR06 
Local cCtaFin 	:= MV_PAR07
Local cMoeda 	:= MV_PAR08
Local nMoeda 	:= Val(MV_PAR08)
Local nTipoSal  := Val(MV_PAR09)
Local lCuentas 	:= IIF(MV_PAR10 == 1,.T.,.F.) //Dif. de Cambio: Uno es que utiliza Cuentas Genéricas, 2 por Cuenta Contable.  
Local lCtaRxC	:= IIF(MV_PAR20 == 1,.T.,.F.) //Result. x Conversion: Uno es que utiliza Cuentas Genéricas, 2 por Cuenta Contable.  
Local cCtaGanMN	:= MV_PAR11
Local cCtaPerMN	:= MV_PAR12 
Local cCtaGanME	:= MV_PAR13 
Local cCtaPerME	:= MV_PAR14 
Local lUsaCC	:= IIF(MV_PAR15 == 1,.T.,.F.) 
Local lUsaIC	:= IIF(MV_PAR16 == 1,.T.,.F.)
Local lUsaCV	:= IIF(MV_PAR17 == 1,.T.,.F.)
Local cCCGan	:= MV_PAR18
Local cCCPer	:= MV_PAR19 
//Variables para indicar en que moneda se genera la Diferencia de Cambio
Local lUsaM3 	:= IIF(MV_PAR21 == 1,.T.,.F.) 
Local lUsaM4 	:= IIF(MV_PAR22 == 1,.T.,.F.) 
Local lUsaM5 	:= IIF(MV_PAR23 == 1,.T.,.F.) 
//Variables con cotizaciones especiales o por defecto. 
//Posicione('CTP',1,xFilial('CTP')+DTOS(cDataFin)+'01','CTP_TAXA')//CTP_TAXA indice CTP_FILIAL+DTOS(CTP_DATA)+CTP_MOEDA
Local nTCM02	:= IIF(MV_PAR24>0, MV_PAR24, RecMoeda(cDataFin,'02'))
Local nTCM03	:= IIF(lUsaM3,IIF(MV_PAR25>0, MV_PAR25, RecMoeda(cDataFin,'03')),0)
Local nTCM04	:= IIF(lUsaM4,IIF(MV_PAR26>0, MV_PAR26, RecMoeda(cDataFin,'04')),0)
Local nTCM05	:= IIF(lUsaM5,IIF(MV_PAR27>0, MV_PAR27, RecMoeda(cDataFin,'05')),0)
Local nValOri1,nValOri2,nValOri3,nValOri4,nValOri5	:= 0
Local nValAct1,nValAct2,nValAct3,nValAct4,nValAct5 	:= 0
Local nValDC1,nValDC2,nValDC3,nValDC4,nValDC5 	:= 0
Local nTipoS	:= 0 //para indicar si tiene tipo saldo deudor o acreedor
Local cCuentaDC := ""
Local cCtaRed := ""
Local cCCDC := ""
Local lPerGan
Local cLinha 	:= "001" 
Local cMoedaLanc := "" 
Local cDebito	:= ""
Local cCredito	:= ""
Local cCostoDeb, cCostoCrd, cItemDeb, cItemCrd, cClVlDeb, cClVlCrd :="" 
Local cHistorico:= "Diferencia de Cambio" + " " + StrZero(Month(mv_par01),2)+"/" + StrZero(Year(mv_par01),4)
Local cNroDocM1 := ""
Local cNroDocM2 := ""
Local cNroDocM3 := ""
Local cNroDocM4 := ""
Local cNroDocM5 := ""
Local nTotRec	:= 0
PRIVATE cAlias := "REP"  
PRIVATE aCols 		:= {}

If nTCM02 == 0
	Help(" ",1," ", ,"No hay cotización para la moneda 02.",1,0)
	Return .F. 
ElseIf lUsaM3 .And. nTCM03 == 0
	Help(" ",1," ", ,"No hay cotización para la moneda 03.",1,0)
	Return .F.
ElseIf lUsaM4 .And. nTCM04 == 0
	Help(" ",1," ", ,"No hay cotización para la moneda 04.",1,0)
	Return .F.
ElseIf lUsaM5 .And. nTCM05 == 0
	Help(" ",1," ", ,"No hay cotización para la moneda 05.",1,0)
	Return .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//?Antes de comenzar el procesamiento valido parámetros     ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
	Case Empty(mv_par01) // Fecha tiene que tener datos
		Help(" ",1," ", ,"La Fecha no puede estar vacía.",1,0)
		Return .F.
	Case Empty(mv_par02)	// Lote
		Help(" ",1," ", ,"Debe ingresar un Lote.",1,0)
		Return .F.
	Case Empty(mv_par03) // Sub Lote 
		Help(" ",1," ", ,"Debe ingresar un Sublote.",1,0)
		Return .F.
	Case Empty(mv_par04)// Documento
		Help(" ",1," ", ,"Debe ingresar un Número de Documento.",1,0)
		Return .F.
	Case Empty(mv_par05) // Historico
		Help(" ",1," ", ,"Debe ingresar un Histórico",1,0)
		Return .F.
	Case Empty(mv_par06) .And. Empty(mv_par07)// Debe ingresar una cuenta Contable Fin
		Help(" ",1," ", ,"Debe ingresar un rango de Cuenta Contable.",1,0)
		Return .F.
	Case Empty(mv_par08)	//Moneda
		Help(" ",1," ", ,"Debe seleccionar una Moneda.",1,0)
		Return .F.
	Case Empty(mv_par09) // Tipo de saldo nao preenchido
		Help(" ",1," ", ,"Debe seleccionar un Tipo de Saldo.",1,0)
		Return .F.
	OtherWise
		lRet := .T.
EndCase

If !CtbValiDt(1,mv_par01)
	//Help(" ",1,"El Calendario Contable para la fecha ingresada se encuentra cerrado.")
	Help(" ",1," ",,"El Calendario Contable para la fecha ingresada se encuentra cerrado.",1,0)	
	Return .F.
EndIf

If lCuentas .AND. (Empty(cCtaGanMN) .OR. Empty(cCtaPerMN))
	//Help("",1,"Debe ingresar las Cuentas Contables de Pérdida y Ganancias.")
	Help(" ",1,"Cuentas de Dif. Cambio",,"Debe ingresar las Cuentas Contables de Pérdida y Ganancias.",1,0)	
	Return .F.
EndIf

//////////////////////////
///////CONSULTA SQL////// 
/////////////////////////  
dbSelectArea("CT1")
CT1->(dbSetOrder(1))  
dbSelectArea("CT2")
CT1->(dbSetOrder(1))  

cAlias	:=	GetNextAlias() 
ProcRegua(0)                 
IncProc()
IncProc("Buscando datos ...")
If lUsaCC .AND. lUsaIC .AND. lUsaCV ////Si quiere que los asientos se abran por CC/IC/CV
	BeginSql Alias cAlias
		SELECT CONSULTA.CUENTA, CONSULTA.CCOSTO, CONSULTA.ITEM, CONSULTA.CVALOR, CONSULTA.MONEDACTA
				,ROUND(SUM(CONSULTA.DEBITOM1 - CONSULTA.CREDITOM1),2) AS SALDOM1
				,ROUND(SUM(CONSULTA.DEBITOM2 - CONSULTA.CREDITOM2),2) AS SALDOM2
				,ROUND(SUM(CONSULTA.DEBITOM3 - CONSULTA.CREDITOM3),2) AS SALDOM3
				,ROUND(SUM(CONSULTA.DEBITOM4 - CONSULTA.CREDITOM4),2) AS SALDOM4
				,ROUND(SUM(CONSULTA.DEBITOM5 - CONSULTA.CREDITOM5),2) AS SALDOM5
		FROM (
			SELECT	CT2.CT2_CREDIT AS CUENTA, CT1.CT1_MOEDVM AS MONEDACTA, CT2.CT2_CCC AS CCOSTO
					,CT2.CT2_ITEMC AS ITEM, CT2.CT2_CLVLCR AS CVALOR
					,CT2.CT2_MOEDLC AS MONMOV
					,0 AS DEBITOM1
					,0 AS DEBITOM2
					,0 AS DEBITOM3
					,0 AS DEBITOM4
					,0 AS DEBITOM5
					,SUM(CT2.CT2_VALOR) AS CREDITOM1  
					,0 AS CREDITOM2
					,0 AS CREDITOM3
					,0 AS CREDITOM4
					,0 AS CREDITOM5
			FROM 
			(
				SELECT CT2_CREDIT, CT2_CCC, CT2_ITEMC, CT2_CLVLCR, CT2_MOEDLC, CT2_VALOR
				FROM %Table:CT2%
				WHERE CT2_FILIAL = %Exp:xFilial("CT2")%
				  AND CT2_CREDIT >= %Exp:cCtaIni% AND CT2_CREDIT <= %Exp:cCtaFin%
				  AND CT2_MOEDLC = '01'
				  AND CT2_DATA <= %Exp:cDataFin%
				  AND CT2_TPSALD = %Exp:MV_PAR09%
				  AND %NotDel%
			) CT2
			JOIN
			(
				SELECT CT1_CONTA, CT1_MOEDVM 
				FROM %Table:CT1%
				WHERE CT1_FILIAL = %Exp:xFilial("CT1")%
				  AND CT1_CONTA >= %Exp:cCtaIni% AND CT1_CONTA <= %Exp:cCtaFin%
				  AND CT1_MOEDVM = %Exp:cMoeda%
				  AND CT1_BLOQ <> '1'
				  AND CT1_CTARED <> ' '
				  AND %NotDel%
			) CT1 ON CT1.CT1_CONTA = CT2.CT2_CREDIT
			GROUP BY CT2.CT2_CREDIT, CT2.CT2_CCC, CT2.CT2_ITEMC, CT2.CT2_CLVLCR, CT1.CT1_MOEDVM, CT2.CT2_MOEDLC
			UNION
			SELECT  CT2.CT2_CREDIT AS CUENTA, CT1.CT1_MOEDVM AS MONEDACTA, CT2.CT2_CCC AS CCOSTO
					,CT2.CT2_ITEMC AS ITEM, CT2.CT2_CLVLCR AS CVALOR
					,CT2.CT2_MOEDLC AS MONMOV
					,0 AS DEBITOM1
					,0 AS DEBITOM2
					,0 AS DEBITOM3
					,0 AS DEBITOM4
					,0 AS DEBITOM5
					,0 AS CREDITOM1  
					,SUM(CT2.CT2_VALOR) AS CREDITOM2
					,0 AS CREDITOM3
					,0 AS CREDITOM4
					,0 AS CREDITOM5
			FROM 
			(
				SELECT CT2_CREDIT, CT2_CCC, CT2_ITEMC, CT2_CLVLCR, CT2_MOEDLC, CT2_VALOR
				FROM %Table:CT2%
				WHERE CT2_FILIAL = %Exp:xFilial("CT2")%
				  AND CT2_CREDIT >= %Exp:cCtaIni% AND CT2_CREDIT <= %Exp:cCtaFin%
				  AND CT2_MOEDLC = '02'
				  AND CT2_DATA <= %Exp:cDataFin%
				  AND CT2_TPSALD = %Exp:MV_PAR09%
				  AND %NotDel%
			) CT2
			JOIN
			(
				SELECT CT1_CONTA, CT1_MOEDVM 
				FROM %Table:CT1%
				WHERE CT1_FILIAL = %Exp:xFilial("CT1")%
				  AND CT1_CONTA >= %Exp:cCtaIni% AND CT1_CONTA <= %Exp:cCtaFin%
				  AND CT1_MOEDVM = %Exp:cMoeda%
				  AND CT1_BLOQ <> '1'
				  AND CT1_CTARED <> ' '
				  AND %NotDel%
			) CT1 ON CT1.CT1_CONTA = CT2.CT2_CREDIT
			GROUP BY CT2.CT2_CREDIT, CT2.CT2_CCC, CT2.CT2_ITEMC, CT2.CT2_CLVLCR, CT1.CT1_MOEDVM, CT2.CT2_MOEDLC
			UNION
			SELECT	CT2.CT2_CREDIT AS CUENTA, CT1.CT1_MOEDVM AS MONEDACTA, CT2.CT2_CCC AS CCOSTO
					,CT2.CT2_ITEMC AS ITEM, CT2.CT2_CLVLCR AS CVALOR
					,CT2.CT2_MOEDLC AS MONMOV
					,0 AS DEBITOM1
					,0 AS DEBITOM2
					,0 AS DEBITOM3
					,0 AS DEBITOM4
					,0 AS DEBITOM5
					,0 AS CREDITOM1  
					,0 AS CREDITOM2
					,SUM(CT2.CT2_VALOR) AS CREDITOM3
					,0 AS CREDITOM4
					,0 AS CREDITOM5
			FROM 
			(
				SELECT CT2_CREDIT, CT2_CCC, CT2_ITEMC, CT2_CLVLCR, CT2_MOEDLC, CT2_VALOR
				FROM %Table:CT2%
				WHERE CT2_FILIAL = %Exp:xFilial("CT2")%
				  AND CT2_CREDIT >= %Exp:cCtaIni% AND CT2_CREDIT <= %Exp:cCtaFin%
				  AND CT2_MOEDLC = '03'
				  AND CT2_DATA <= %Exp:cDataFin%
				  AND CT2_TPSALD = %Exp:MV_PAR09%
				  AND %NotDel%
			) CT2
			JOIN
			(
				SELECT CT1_CONTA, CT1_MOEDVM 
				FROM %Table:CT1%
				WHERE CT1_FILIAL = %Exp:xFilial("CT1")%
				  AND CT1_CONTA >= %Exp:cCtaIni% AND CT1_CONTA <= %Exp:cCtaFin%
				  AND CT1_MOEDVM = %Exp:cMoeda%
				  AND CT1_BLOQ <> '1'
				  AND CT1_CTARED <> ' '
				  AND %NotDel%
			) CT1 ON CT1.CT1_CONTA = CT2.CT2_CREDIT
			GROUP BY CT2.CT2_CREDIT, CT2.CT2_CCC, CT2.CT2_ITEMC, CT2.CT2_CLVLCR, CT1.CT1_MOEDVM, CT2.CT2_MOEDLC
			UNION
			SELECT  CT2.CT2_CREDIT AS CUENTA, CT1.CT1_MOEDVM AS MONEDACTA, CT2.CT2_CCC AS CCOSTO
					,CT2.CT2_ITEMC AS ITEM, CT2.CT2_CLVLCR AS CVALOR
					,CT2.CT2_MOEDLC AS MONMOV
					,0 AS DEBITOM1
					,0 AS DEBITOM2
					,0 AS DEBITOM3
					,0 AS DEBITOM4
					,0 AS DEBITOM5
					,0 AS CREDITOM1  
					,0 AS CREDITOM2
					,0 AS CREDITOM3
					,SUM(CT2.CT2_VALOR) AS CREDITOM4
					,0 AS CREDITOM5
			FROM 
			(
				SELECT CT2_CREDIT, CT2_CCC, CT2_ITEMC, CT2_CLVLCR, CT2_MOEDLC, CT2_VALOR
				FROM %Table:CT2%
				WHERE CT2_FILIAL = %Exp:xFilial("CT2")%
				  AND CT2_CREDIT >= %Exp:cCtaIni% AND CT2_CREDIT <= %Exp:cCtaFin%
				  AND CT2_MOEDLC = '04'
				  AND CT2_DATA <= %Exp:cDataFin%
				  AND CT2_TPSALD = %Exp:MV_PAR09%
				  AND %NotDel%
			) CT2
			JOIN
			(
				SELECT CT1_CONTA, CT1_MOEDVM 
				FROM %Table:CT1%
				WHERE CT1_FILIAL = %Exp:xFilial("CT1")%
				  AND CT1_CONTA >= %Exp:cCtaIni% AND CT1_CONTA <= %Exp:cCtaFin%
				  AND CT1_MOEDVM = %Exp:cMoeda%
				  AND CT1_BLOQ <> '1'
				  AND CT1_CTARED <> ' '
				  AND %NotDel%
			) CT1 ON CT1.CT1_CONTA = CT2.CT2_CREDIT
			GROUP BY CT2.CT2_CREDIT, CT2.CT2_CCC, CT2.CT2_ITEMC, CT2.CT2_CLVLCR, CT1.CT1_MOEDVM, CT2.CT2_MOEDLC
			UNION
			SELECT	CT2.CT2_CREDIT AS CUENTA, CT1.CT1_MOEDVM AS MONEDACTA, CT2.CT2_CCC AS CCOSTO
					,CT2.CT2_ITEMC AS ITEM, CT2.CT2_CLVLCR AS CVALOR
					,CT2.CT2_MOEDLC AS MONMOV
					,0 AS DEBITOM1
					,0 AS DEBITOM2
					,0 AS DEBITOM3
					,0 AS DEBITOM4
					,0 AS DEBITOM5
					,0 AS CREDITOM1  
					,0 AS CREDITOM2
					,0 AS CREDITOM3
					,0 AS CREDITOM4
					,SUM(CT2.CT2_VALOR) AS CREDITOM5
			FROM 
			(
				SELECT CT2_CREDIT, CT2_CCC, CT2_ITEMC, CT2_CLVLCR, CT2_MOEDLC, CT2_VALOR
				FROM %Table:CT2%
				WHERE CT2_FILIAL = %Exp:xFilial("CT2")%
				  AND CT2_CREDIT >= %Exp:cCtaIni% AND CT2_CREDIT <= %Exp:cCtaFin%
				  AND CT2_MOEDLC = '05'
				  AND CT2_DATA <= %Exp:cDataFin%
				  AND CT2_TPSALD = %Exp:MV_PAR09%
				  AND %NotDel%
			) CT2
			JOIN
			(
				SELECT CT1_CONTA, CT1_MOEDVM 
				FROM %Table:CT1%
				WHERE CT1_FILIAL = %Exp:xFilial("CT1")%
				  AND CT1_CONTA >= %Exp:cCtaIni% AND CT1_CONTA <= %Exp:cCtaFin%
				  AND CT1_MOEDVM = %Exp:cMoeda%
				  AND CT1_BLOQ <> '1'
				  AND CT1_CTARED <> ' '
				  AND %NotDel%
			) CT1 ON CT1.CT1_CONTA = CT2.CT2_CREDIT
			GROUP BY CT2.CT2_CREDIT, CT2.CT2_CCC, CT2.CT2_ITEMC, CT2.CT2_CLVLCR, CT1.CT1_MOEDVM, CT2.CT2_MOEDLC
			UNION
			SELECT CT2.CT2_DEBITO AS CUENTA, CT1.CT1_MOEDVM AS MONEDACTA, CT2.CT2_CCD AS CCOSTO
					,CT2.CT2_ITEMD AS ITEM, CT2.CT2_CLVLDB AS CVALOR
					,CT2.CT2_MOEDLC AS MONMOV
					,SUM(CT2.CT2_VALOR) AS DEBITOM1  
					,0 AS DEBITOM2
					,0 AS DEBITOM3
					,0 AS DEBITOM4
					,0 AS DEBITOM5
					,0 AS CREDITOM1
					,0 AS CREDITOM2
					,0 AS CREDITOM3
					,0 AS CREDITOM4
					,0 AS CREDITOM5
			FROM 
			(
				SELECT CT2_DEBITO, CT2_CCD, CT2_ITEMD, CT2_CLVLDB, CT2_MOEDLC, CT2_VALOR
				FROM %Table:CT2%
				WHERE CT2_FILIAL = %Exp:xFilial("CT2")%
				  AND CT2_DEBITO >= %Exp:cCtaIni% AND CT2_DEBITO <= %Exp:cCtaFin%
				  AND CT2_MOEDLC = '01'
				  AND CT2_DATA <= %Exp:cDataFin%
				  AND CT2_TPSALD = %Exp:MV_PAR09%
				  AND %NotDel%
			) CT2
			JOIN
			(
				SELECT CT1_CONTA, CT1_MOEDVM 
				FROM %Table:CT1%
				WHERE CT1_FILIAL = %Exp:xFilial("CT1")%
				  AND CT1_CONTA >= %Exp:cCtaIni% AND CT1_CONTA <= %Exp:cCtaFin%
				  AND CT1_MOEDVM = %Exp:cMoeda%
				  AND CT1_BLOQ <> '1'
				  AND CT1_CTARED <> ' '
				  AND %NotDel%
			) CT1 ON CT1.CT1_CONTA = CT2.CT2_DEBITO
			GROUP BY CT2.CT2_DEBITO, CT2.CT2_CCD, CT2.CT2_ITEMD, CT2.CT2_CLVLDB, CT1.CT1_MOEDVM, CT2.CT2_MOEDLC
			UNION
			SELECT CT2.CT2_DEBITO AS CUENTA, CT1.CT1_MOEDVM AS MONEDACTA, CT2.CT2_CCD AS CCOSTO
					,CT2.CT2_ITEMD AS ITEM, CT2.CT2_CLVLDB AS CVALOR
					,CT2.CT2_MOEDLC AS MONMOV
					,0 AS DEBITOM1  
					,SUM(CT2.CT2_VALOR) AS DEBITOM2
					,0 AS DEBITOM3
					,0 AS DEBITOM4
					,0 AS DEBITOM5
					,0 AS CREDITOM1
					,0 AS CREDITOM2
					,0 AS CREDITOM3
					,0 AS CREDITOM4
					,0 AS CREDITOM5
			FROM 
			(
				SELECT CT2_DEBITO, CT2_CCD, CT2_ITEMD, CT2_CLVLDB, CT2_MOEDLC, CT2_VALOR
				FROM %Table:CT2%
				WHERE CT2_FILIAL = %Exp:xFilial("CT2")%
				  AND CT2_DEBITO >= %Exp:cCtaIni% AND CT2_DEBITO <= %Exp:cCtaFin%
				  AND CT2_MOEDLC = '02'
				  AND CT2_DATA <= %Exp:cDataFin%
				  AND CT2_TPSALD = %Exp:MV_PAR09%
				  AND %NotDel%
			) CT2
			JOIN
			(
				SELECT CT1_CONTA, CT1_MOEDVM 
				FROM %Table:CT1%
				WHERE CT1_FILIAL = %Exp:xFilial("CT1")%
				  AND CT1_CONTA >= %Exp:cCtaIni% AND CT1_CONTA <= %Exp:cCtaFin%
				  AND CT1_MOEDVM = %Exp:cMoeda%
				  AND CT1_BLOQ <> '1'
				  AND CT1_CTARED <> ' '
				  AND %NotDel%
			) CT1 ON CT1.CT1_CONTA = CT2.CT2_DEBITO
			GROUP BY CT2.CT2_DEBITO, CT2.CT2_CCD, CT2.CT2_ITEMD, CT2.CT2_CLVLDB, CT1.CT1_MOEDVM, CT2.CT2_MOEDLC
			UNION
			SELECT CT2.CT2_DEBITO AS CUENTA, CT1.CT1_MOEDVM AS MONEDACTA, CT2.CT2_CCD AS CCOSTO
					,CT2.CT2_ITEMD AS ITEM, CT2.CT2_CLVLDB AS CVALOR
					,CT2.CT2_MOEDLC AS MONMOV
					,0 AS DEBITOM1  
					,0 AS DEBITOM2
					,SUM(CT2.CT2_VALOR) AS DEBITOM3
					,0 AS DEBITOM4
					,0 AS DEBITOM5
					,0 AS CREDITOM1
					,0 AS CREDITOM2
					,0 AS CREDITOM3
					,0 AS CREDITOM4
					,0 AS CREDITOM5
			FROM 
			(
				SELECT CT2_DEBITO, CT2_CCD, CT2_ITEMD, CT2_CLVLDB, CT2_MOEDLC, CT2_VALOR
				FROM %Table:CT2%
				WHERE CT2_FILIAL = %Exp:xFilial("CT2")%
				  AND CT2_DEBITO >= %Exp:cCtaIni% AND CT2_DEBITO <= %Exp:cCtaFin%
				  AND CT2_MOEDLC = '03'
				  AND CT2_DATA <= %Exp:cDataFin%
				  AND CT2_TPSALD = %Exp:MV_PAR09%
				  AND %NotDel%
			) CT2
			JOIN
			(
				SELECT CT1_CONTA, CT1_MOEDVM 
				FROM %Table:CT1%
				WHERE CT1_FILIAL = %Exp:xFilial("CT1")%
				  AND CT1_CONTA >= %Exp:cCtaIni% AND CT1_CONTA <= %Exp:cCtaFin%
				  AND CT1_MOEDVM = %Exp:cMoeda%
				  AND CT1_BLOQ <> '1'
				  AND CT1_CTARED <> ' '
				  AND %NotDel%
			) CT1 ON CT1.CT1_CONTA = CT2.CT2_DEBITO
			GROUP BY CT2.CT2_DEBITO, CT2.CT2_CCD, CT2.CT2_ITEMD, CT2.CT2_CLVLDB, CT1.CT1_MOEDVM, CT2.CT2_MOEDLC
			UNION
			SELECT CT2.CT2_DEBITO AS CUENTA, CT1.CT1_MOEDVM AS MONEDACTA, CT2.CT2_CCD AS CCOSTO
					,CT2.CT2_ITEMD AS ITEM, CT2.CT2_CLVLDB AS CVALOR
					,CT2.CT2_MOEDLC AS MONMOV
					,0 AS DEBITOM1  
					,0 AS DEBITOM2
					,0 AS DEBITOM3
					,SUM(CT2.CT2_VALOR) AS DEBITOM4
					,0 AS DEBITOM5
					,0 AS CREDITOM1
					,0 AS CREDITOM2
					,0 AS CREDITOM3
					,0 AS CREDITOM4
					,0 AS CREDITOM5
			FROM
			(
				SELECT CT2_DEBITO, CT2_CCD, CT2_ITEMD, CT2_CLVLDB, CT2_MOEDLC, CT2_VALOR
				FROM %Table:CT2%
				WHERE CT2_FILIAL = %Exp:xFilial("CT2")%
				  AND CT2_DEBITO >= %Exp:cCtaIni% AND CT2_DEBITO <= %Exp:cCtaFin%
				  AND CT2_MOEDLC = '04'
				  AND CT2_DATA <= %Exp:cDataFin%
				  AND CT2_TPSALD = %Exp:MV_PAR09%
				  AND %NotDel%
			) CT2
			JOIN
			(
				SELECT CT1_CONTA, CT1_MOEDVM 
				FROM %Table:CT1%
				WHERE CT1_FILIAL = %Exp:xFilial("CT1")%
				  AND CT1_CONTA >= %Exp:cCtaIni% AND CT1_CONTA <= %Exp:cCtaFin%
				  AND CT1_MOEDVM = %Exp:cMoeda%
				  AND CT1_BLOQ <> '1'
				  AND CT1_CTARED <> ' '
				  AND %NotDel%
			) CT1 ON CT1.CT1_CONTA = CT2.CT2_DEBITO
			GROUP BY CT2.CT2_DEBITO, CT2.CT2_CCD, CT2.CT2_ITEMD, CT2.CT2_CLVLDB, CT1.CT1_MOEDVM, CT2.CT2_MOEDLC
			UNION
			SELECT CT2.CT2_DEBITO AS CUENTA, CT1.CT1_MOEDVM AS MONEDACTA, CT2.CT2_CCD AS CCOSTO
					,CT2.CT2_ITEMD AS ITEM, CT2.CT2_CLVLDB AS CVALOR
					,CT2.CT2_MOEDLC AS MONMOV
					,0 AS DEBITOM1  
					,0 AS DEBITOM2
					,0 AS DEBITOM3
					,0 AS DEBITOM4
					,SUM(CT2.CT2_VALOR) AS DEBITOM5
					,0 AS CREDITOM1
					,0 AS CREDITOM2
					,0 AS CREDITOM3
					,0 AS CREDITOM4
					,0 AS CREDITOM5
			FROM 
			(
				SELECT CT2_DEBITO, CT2_CCD, CT2_ITEMD, CT2_CLVLDB, CT2_MOEDLC, CT2_VALOR
				FROM %Table:CT2%
				WHERE CT2_FILIAL = %Exp:xFilial("CT2")%
				  AND CT2_DEBITO >= %Exp:cCtaIni% AND CT2_DEBITO <= %Exp:cCtaFin%
				  AND CT2_MOEDLC = '05'
				  AND CT2_DATA <= %Exp:cDataFin%
				  AND CT2_TPSALD = %Exp:MV_PAR09%
				  AND %NotDel%
			) CT2
			JOIN
			(
				SELECT CT1_CONTA, CT1_MOEDVM 
				FROM %Table:CT1%
				WHERE CT1_FILIAL = %Exp:xFilial("CT1")%
				  AND CT1_CONTA >= %Exp:cCtaIni% AND CT1_CONTA <= %Exp:cCtaFin%
				  AND CT1_MOEDVM = %Exp:cMoeda%
				  AND CT1_BLOQ <> '1'
				  AND CT1_CTARED <> ' '
				  AND %NotDel%
			) CT1 ON CT1.CT1_CONTA = CT2.CT2_DEBITO
			GROUP BY CT2.CT2_DEBITO, CT2.CT2_CCD, CT2.CT2_ITEMD, CT2.CT2_CLVLDB, CT1.CT1_MOEDVM, CT2.CT2_MOEDLC
			) CONSULTA
		GROUP BY CUENTA, CCOSTO, ITEM, CVALOR, MONEDACTA
	EndSql 
	
///Fin si usa todo, hay que hacer el resto de las convinaciones 
ElseIf lUsaCC .AND. lUsaIC .AND. !lUsaCV////No usa Clase Valor
////////////Fin no usa clase valor  
	MsgAlert("Debe seleccionar en SI las opciones Usa Centro de Costo, Usa Item Contable y Usa Clase Valor")
	Return
ElseIf !lUsaCC .AND. lUsaIC .AND.  lUsaCV
	MsgAlert("Debe seleccionar en SI las opciones Usa Centro de Costo, Usa Item Contable y Usa Clase Valor")
	Return
///Fin no usa Centros de Costos          
ElseIf !lUsaCC .AND. !lUsaIC .AND.  lUsaCV //No usa ni Centros de Costos ni Item Contable
	MsgAlert("Debe seleccionar en SI las opciones Usa Centro de Costo, Usa Item Contable y Usa Clase Valor")
	Return
ElseIf !lUsaCC .AND. lUsaIC .AND.  !lUsaCV//No usa ni Centros de Costos ni Clase Valor
	MsgAlert("Debe seleccionar en SI las opciones Usa Centro de Costo, Usa Item Contable y Usa Clase Valor")
	Return
ElseIf  lUsaCC .AND. !lUsaIC .AND.  !lUsaCV//No usa ni Clase Valor ni Item Contable
	MsgAlert("Debe seleccionar en SI las opciones Usa Centro de Costo, Usa Item Contable y Usa Clase Valor")
	Return
ElseIf !lUsaCC .AND. !lUsaIC .AND.  !lUsaCV // //No usa ni Centros de Costos ni Item Contable ni Clase valor
	MsgAlert("Debe seleccionar en SI las opciones Usa Centro de Costo, Usa Item Contable y Usa Clase Valor")
	Return
EndIF
//////////////////////
////////FIN SQL////// 
////////////////////

///Me fijo si ya se genero la dif de cambio para incrementar el nro de documento
//cDataFin, cLote, cSublote, cNroDoc, cLinha,
//clave: CT2_FILIAL+DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_TPSALD+CT2_EMPORI+CT2_FILORI+CT2_MOEDLC                                                                                                         
CT2->(DbSetOrder(1))        
while CT2->(MsSeek( xFilial("CT2")+DTOS(cDataFin)+cLote+cSublote+cNroDoc+cLinha))
	cNroDoc := Soma1(cNroDoc)        
End
/////
nTotRec := GetTotRec(cAlias)
ProcRegua(nTotRec)
Do While !(cAlias)->(Eof ())
	IncProc("Procesando datos ...")
	//Veo si la cuenta es saldo deudor o acreedor / 1=Deudor, 2=Acreedor
	nTipoS := val(POSICIONE('CT1',1,xFilial('CT1')+(cAlias)->CUENTA,'CT1_NORMAL'))
	//Cargo cuenta reductora
    cCtaRed := POSICIONE('CT1',1,xFilial('CT1')+(cAlias)->CUENTA,'CT1_CTARED')

	//////////////////////////////////////////////
	///CALCULO VALORES DE DIFERENCIA DE CAMBIO/// 
	////////////////////////////////////////////
	//Cargo valores originales en cada moneda
   	nValOrig1 := (cAlias)->SALDOM1
	nValOrig2 := (cAlias)->SALDOM2
	nValOrig3 := (cAlias)->SALDOM3
	nValOrig4 := (cAlias)->SALDOM4
	nValOrig5 := (cAlias)->SALDOM5
	
	If nMoeda == 1
		//Cargo Valores actualizados en cada moneda
		nValAct2 := (cAlias)->SALDOM1 / nTCM02
		nValAct3 := (cAlias)->SALDOM1 / nTCM03
		nValAct4 := (cAlias)->SALDOM1 / nTCM04
		nValAct5 := (cAlias)->SALDOM1 / nTCM05 
	ElseIf nMoeda == 2 
		nValAct1 := (cAlias)->SALDOM2 * nTCM02
		nValAct3 := nValAct1/nTCM03
		nValAct4 := nValAct1/nTCM04
		nValAct5 := nValAct1/nTCM05
	ElseIf nMoeda == 3 .AND. lUsaM3
		nValAct1 := (cAlias)->SALDOM3 * nTCM03
		nValAct2 := nValAct1/nTCM02
		nValAct4 := nValAct1/nTCM04
		nValAct5 := nValAct1/nTCM05
	ElseIf nMoeda == 4 .AND. lUsaM4
		nValAct1 := (cAlias)->SALDOM4 * nTCM04
		nValAct2 := nValAct1/nTCM02
		nValAct3 := nValAct1/nTCM03
		nValAct5 := nValAct1/nTCM05
	ElseIf nMoeda == 5 .AND. lUsaM5
		nValAct1 := (cAlias)->SALDOM5 * nTCM05
		nValAct2 := nValAct1/nTCM02
		nValAct3 := nValAct1/nTCM03
		nValAct4 := nValAct1/nTCM04
	EndIf		
	//Cargo los valores de Diferencias
	If nMoeda <> 1 
		//nValDC1 := nValAct1 - nValOrig1
		If nTipoS == 1
			nValDC1 := nValAct1 - nValOrig1
		Elseif nTipoS == 2 
			nValDC1 := nValOrig1 - nValAct1
		EndIf
	EndIf
	If nMoeda <> 2
		//nValDC2 := nValAct2 - nValOrig2
		If nTipoS == 1
			nValDC2 := nValAct2 - nValOrig2
		Elseif nTipoS == 2 
			nValDC2 := nValOrig2 - nValAct2
		EndIf
	EndIf
	If nMoeda <> 3 .AND. lUsaM3
		//nValDC3 := nValAct3 - nValOrig3 
		If nTipoS == 1
			nValDC3 := nValAct3 - nValOrig3
		Elseif nTipoS == 2 
			nValDC3 := nValOrig3 - nValAct3
		EndIf
	EndIf
	If nMoeda <> 4 .AND. lUsaM4
		//nValDC4 := nValAct4 - nValOrig4 
		If nTipoS == 1
			nValDC4 := nValAct4 - nValOrig4
		Elseif nTipoS == 2 
			nValDC4 := nValOrig4 - nValAct4
		EndIf
	EndIF
	If nMoeda <> 5 .AND. lUsaM5
		//nValDC5 := nValAct5	- nValOrig5
		If nTipoS == 1
			nValDC5 := nValAct5 - nValOrig5
		Elseif nTipoS == 2 
			nValDC5 := nValOrig5 - nValAct5
		EndIf
	EndIF

////////////////////////////////////////////////////////////////////////////	
///Ejecuto la rutina que genera los asientos  contables para la moneda 1 ///
////////////////////////////////////////////////////////////////////////////
	If nMoeda <> 1    
		If (nValDC1 < 0 .AND. nTipoS == 1) .OR. (nValDC1 > 0 .AND. nTipoS == 2)//Indica que hay perdida en esta moneda  
			If lCuentas
				cCuentaDC := cCtaPerMN
				cCCDC := cCCPer	
			Else
				cCuentaDC := POSICIONE('CT1',1,xFilial('CT1')+(cAlias)->CUENTA,'CT1_XPERDC')//ver de cambiar si es perdida o ganancia
				cCCDC := cCCPer
			EndIf
			lPerGan	  := .T.//T perdida F Ganancia
			cDebito   := cCuentaDC
			cCredito  := cCtaRed   
			cCostoDeb := cCCDC 
			cCostoCrd := (cAlias)->CCOSTO
			cItemDeb  := ""
			cItemCrd  := (cAlias)->ITEM 
			cClVlDeb  := ""
			cClVlCrd  := (cAlias)->CVALOR
		ElseIf (nValDC1 < 0 .AND. nTipoS == 2) .OR. (nValDC1 > 0 .AND. nTipoS == 1)//indica que hay ganancia en esta moneda 
			If lCuentas
				cCuentaDC := cCtaGanMN
				cCCDC := cCCGan	
			Else
				cCuentaDC := POSICIONE('CT1',1,xFilial('CT1')+(cAlias)->CUENTA,'CT1_CTAVM')//ver de cambiar si es perdida o ganancia
				cCCDC := cCCGan
			EndIf
			lPerGan	  := .F.//T perdida F Ganancia
			cDebito   := cCtaRed
			cCredito  := cCuentaDC
			cCostoDeb := (cAlias)->CCOSTO 
			cCostoCrd := cCCDC
			cItemDeb  := (cAlias)->ITEM
			cItemCrd  := "" 
			cClVlDeb  := (cAlias)->CVALOR
			cClVlCrd  := ""
		EndIf
		If nValDC1 < 0
			nValDC1   := nValDC1 * -1
		EndIf
		//Cargo Moneda del asiento que voy a generar
		cMoedaLanc := "01"
		//cNroDoc := cNroDocM1
		//Disparo gravación de asientos
		BEGIN TRANSACTION
			If Round(nValDC1,2) <> 0
				U_GravAsie(	cDataFin, cLote, cSublote, cNroDoc, cLinha, "3", cMoedaLanc, cHistor, cDebito,;
							cCredito, cCostoDeb, cCostoCrd, cItemDeb, cItemCrd, cClVlDeb,;
							cClVlCrd, Round(nValDC1,2), cHistorico, "1", "", 3, .T., aCols,;
							cEmpAnt, cFilAnt,,,,,, "DIFCAMB",,,,,,,,)    
			
                //Incremento nro de documento
				cLinha := Soma1(cLinha)  
				CT2->(dbCommit())
			EndIf
	    END TRANSACTION	
	EndIf

	////////////////////////////////////////////////////////
	///////////FIN CALCULOS PARA LA MONEDA 1///////////////
	///////////////////////////////////////////////////////	
	
	
////////////////////////////////////////////////////////////////////////////	
///Ejecuto la rutina que genera los asientos  contables para la moneda 2///
////////////////////////////////////////////////////////////////////////////	
	If nMoeda <> 2	
		If (nValDC2 < 0 .AND. nTipoS == 1) .OR. (nValDC2 > 0 .AND. nTipoS == 2)//Indica que hay perdida en esta moneda  
			If lCuentas 
				cCuentaDC := cCtaPerME
				cCCDC := cCCPer	
			Else
				cCuentaDC := POSICIONE('CT1',1,xFilial('CT1')+(cAlias)->CUENTA,'CT1_XPERDC')//ver de cambiar si es perdida o ganancia
				cCCDC := cCCPer
			EndIf
			lPerGan	  := .T.//T perdida F Ganancia
			cDebito   := cCuentaDC
			cCredito  := cCtaRed   
			cCostoDeb := cCCDC 
			cCostoCrd := (cAlias)->CCOSTO
			cItemDeb  := ""
			cItemCrd  := (cAlias)->ITEM 
			cClVlDeb  := ""
			cClVlCrd  := (cAlias)->CVALOR
		ElseIf (nValDC2 < 0 .AND. nTipoS == 2) .OR. (nValDC2 > 0 .AND. nTipoS == 1)//indica que hay ganancia en esta moneda 
			If lCuentas
				cCuentaDC := cCtaGanME
				cCCDC := cCCGan	
			Else
				cCuentaDC := POSICIONE('CT1',1,xFilial('CT1')+(cAlias)->CUENTA,'CT1_CTAVM')//ver de cambiar si es perdida o ganancia
				cCCDC := cCCGan
			EndIf
			lPerGan	  := .F.//T perdida F Ganancia
			cDebito   := cCtaRed
			cCredito  := cCuentaDC
			cCostoDeb := (cAlias)->CCOSTO 
			cCostoCrd := cCCDC
			cItemDeb  := (cAlias)->ITEM
			cItemCrd  := "" 
			cClVlDeb  := (cAlias)->CVALOR
			cClVlCrd  := ""
		EndIf
		If nValDC2 < 0
			nValDC2   := nValDC2 * -1
		EndIf
		//Cargo Moneda del asiento que voy a generar
		cMoedaLanc := "02"
		//Disparo gravación de asientos
		BEGIN TRANSACTION
			If Round(nValDC2,2) <> 0
				U_GravAsie(	cDataFin, cLote, cSublote, cNroDoc, cLinha, "3", cMoedaLanc, cHistor, cDebito,;
							cCredito, cCostoDeb, cCostoCrd, cItemDeb, cItemCrd, cClVlDeb,;
							cClVlCrd, Round(nValDC2,2), cHistorico, "1", "", 3, .T., aCols,;
							cEmpAnt, cFilAnt,,,,,, "DIFCAMB",,,,,,,,)    
				//Genero linea en blanco////////
				U_GravAsie(	cDataFin, cLote, cSublote, cNroDoc, cLinha, "3", '01', cHistor, cDebito,;
							cCredito, cCostoDeb, cCostoCrd, cItemDeb, cItemCrd, cClVlDeb,;
							cClVlCrd, 0, cHistorico, "1", "", 3, .T., aCols,;
							cEmpAnt, cFilAnt,,,,,, "DIFCAMB",,,,,,,,)  
				//Incremento nro de documento
				cLinha := Soma1(cLinha) 
				CT2->(dbCommit())
			EndIf
	    END TRANSACTION
	EndIf		
	////////////////////////////////////////////////////////
	///////////FIN CALCULOS PARA LA MONEDA 2///////////////
	///////////////////////////////////////////////////////
		
	////////////////////////////////////////////////////////////////////////////	
	///Ejecuto la rutina que genera los asientos  contables para la moneda 3///
	////////////////////////////////////////////////////////////////////////////
	If nMoeda <> 3 .AND. lUsaM3	
		If (nValDC3 < 0 .AND. nTipoS == 1) .OR. (nValDC3 > 0 .AND. nTipoS == 2)//Indica que hay perdida en esta moneda  
			If lCuentas 
				cCuentaDC := cCtaPerME
				cCCDC := cCCPer	
			Else
				cCuentaDC := POSICIONE('CT1',1,xFilial('CT1')+(cAlias)->CUENTA,'CT1_XPERDC')//ver de cambiar si es perdida o ganancia
				cCCDC := cCCPer
			EndIf
			lPerGan	  := .T.//T perdida F Ganancia
			cDebito   := cCuentaDC
			cCredito  := cCtaRed   
			cCostoDeb := cCCDC 
			cCostoCrd := (cAlias)->CCOSTO
			cItemDeb  := ""
			cItemCrd  := (cAlias)->ITEM 
			cClVlDeb  := ""
			cClVlCrd  := (cAlias)->CVALOR
		ElseIf (nValDC3 < 0 .AND. nTipoS == 2) .OR. (nValDC3 > 0 .AND. nTipoS == 1)//indica que hay ganancia en esta moneda 
			If lCuentas
				cCuentaDC := cCtaGanME
				cCCDC := cCCGan	
			Else
				cCuentaDC := POSICIONE('CT1',1,xFilial('CT1')+(cAlias)->CUENTA,'CT1_CTAVM')//ver de cambiar si es perdida o ganancia
				cCCDC := cCCGan
			EndIf
			lPerGan	  := .F.//T perdida F Ganancia
			cDebito   := cCtaRed
			cCredito  := cCuentaDC
			cCostoDeb := (cAlias)->CCOSTO 
			cCostoCrd := cCCDC
			cItemDeb  := (cAlias)->ITEM
			cItemCrd  := "" 
			cClVlDeb  := (cAlias)->CVALOR
			cClVlCrd  := ""
		EndIf
		If nValDC3 < 0
			nValDC3   := nValDC3 * -1
		EndIf
		//Cargo Moneda del asiento que voy a generar
		cMoedaLanc := "03"

		//Disparo gravación de asientos
		BEGIN TRANSACTION
			If Round(nValDC3,2) <> 0
				U_GravAsie(	cDataFin, cLote, cSublote, cNroDoc, cLinha, "3", cMoedaLanc, cHistor, cDebito,;
							cCredito, cCostoDeb, cCostoCrd, cItemDeb, cItemCrd, cClVlDeb,;
							cClVlCrd, Round(nValDC3,2), cHistorico, "1", "", 3, .T., aCols,;
							cEmpAnt, cFilAnt,,,,,, "DIFCAMB",,,,,,,,)    
				//Genero linea en blanco////////
				U_GravAsie(	cDataFin, cLote, cSublote, cNroDoc, cLinha, "3", '01', cHistor, cDebito,;
							cCredito, cCostoDeb, cCostoCrd, cItemDeb, cItemCrd, cClVlDeb,;
							cClVlCrd, 0, cHistorico, "1", "", 3, .T., aCols,;
							cEmpAnt, cFilAnt,,,,,, "DIFCAMB",,,,,,,,)    

                //Incremento nro de documento
				cLinha := Soma1(cLinha) 
				CT2->(dbCommit())
			EndIf
	    END TRANSACTION
	EndIf
	////////////////////////////////////////////////////////
	///////////FIN CALCULOS PARA LA MONEDA 3///////////////
	///////////////////////////////////////////////////////
	

	////////////////////////////////////////////////////////////////////////////	
	///Ejecuto la rutina que genera los asientos  contables para la moneda 4///
	////////////////////////////////////////////////////////////////////////////
	If nMoeda <> 4 .AND. lUsaM4	
		If (nValDC4 < 0 .AND. nTipoS == 1) .OR. (nValDC4 > 0 .AND. nTipoS == 2)//Indica que hay perdida en esta moneda  
			If lCuentas 
				cCuentaDC := cCtaPerME
				cCCDC := cCCPer	
			Else
				cCuentaDC := POSICIONE('CT1',1,xFilial('CT1')+(cAlias)->CUENTA,'CT1_XPERDC')//ver de cambiar si es perdida o ganancia
				cCCDC := cCCPer
			EndIf
			lPerGan	  := .T.//T perdida F Ganancia
			cDebito   := cCuentaDC
			cCredito  := cCtaRed   
			cCostoDeb := cCCDC 
			cCostoCrd := (cAlias)->CCOSTO
			cItemDeb  := ""
			cItemCrd  := (cAlias)->ITEM 
			cClVlDeb  := ""
			cClVlCrd  := (cAlias)->CVALOR
		ElseIf (nValDC4 < 0 .AND. nTipoS == 2) .OR. (nValDC4 > 0 .AND. nTipoS == 1)//indica que hay ganancia en esta moneda 
			If lCuentas
				cCuentaDC := cCtaGanME
				cCCDC := cCCGan	
			Else
				cCuentaDC := POSICIONE('CT1',1,xFilial('CT1')+(cAlias)->CUENTA,'CT1_CTAVM')//ver de cambiar si es perdida o ganancia
				cCCDC := cCCGan
			EndIf
			lPerGan	  := .F.//T perdida F Ganancia
			cDebito   := cCtaRed
			cCredito  := cCuentaDC
			cCostoDeb := (cAlias)->CCOSTO 
			cCostoCrd := cCCDC
			cItemDeb  := (cAlias)->ITEM
			cItemCrd  := "" 
			cClVlDeb  := (cAlias)->CVALOR
			cClVlCrd  := ""
		EndIf
		If nValDC4 < 0
			nValDC4   := nValDC4 * -1 
		EndIf
		//Cargo Moneda del asiento que voy a generar
		cMoedaLanc := "04" 
	
		//Disparo gravación de asientos
		BEGIN TRANSACTION
		   If Round(nValDC4,2) <> 0
				U_GravAsie(	cDataFin, cLote, cSublote, cNroDoc, cLinha, "3", cMoedaLanc, cHistor, cDebito,;
							cCredito, cCostoDeb, cCostoCrd, cItemDeb, cItemCrd, cClVlDeb,;
							cClVlCrd, Round(nValDC4,2), cHistorico, "1", "", 3, .T., aCols,;
							cEmpAnt, cFilAnt,,,,,, "DIFCAMB",,,,,,,,)    
				//Genero linea en blanco////////
				U_GravAsie(	cDataFin, cLote, cSublote, cNroDoc, cLinha, "3", '01', cHistor, cDebito,;
							cCredito, cCostoDeb, cCostoCrd, cItemDeb, cItemCrd, cClVlDeb,;
							cClVlCrd, 0, cHistorico, "1", "", 3, .T., aCols,;
							cEmpAnt, cFilAnt,,,,,, "DIFCAMB",,,,,,,,)    
					  		
                //Incremento nro de documento
				cLinha := Soma1(cLinha) 
				CT2->(dbCommit())
			EndIf
	    END TRANSACTION
	EndIf
	////////////////////////////////////////////////////////
	///////////FIN CALCULOS PARA LA MONEDA 4///////////////
	///////////////////////////////////////////////////////
	
	////////////////////////////////////////////////////////////////////////////	
	///Ejecuto la rutina que genera los asientos  contables para la moneda 5///
	////////////////////////////////////////////////////////////////////////////
	If nMoeda <> 5 .AND. lUsaM5	
		If (nValDC5 < 0 .AND. nTipoS == 1) .OR. (nValDC5 > 0 .AND. nTipoS == 2)//Indica que hay perdida en esta moneda  
			If lCuentas 
				cCuentaDC := cCtaPerME	
				cCCDC := cCCPer
			Else
				cCuentaDC := POSICIONE('CT1',1,xFilial('CT1')+(cAlias)->CUENTA,'CT1_XPERDC')//ver de cambiar si es perdida o ganancia
				cCCDC := cCCPer
			EndIf
			lPerGan	  := .T.//T perdida F Ganancia
			cDebito   := cCuentaDC
			cCredito  := cCtaRed   
			cCostoDeb := cCCDC 
			cCostoCrd := (cAlias)->CCOSTO
			cItemDeb  := ""
			cItemCrd  := (cAlias)->ITEM 
			cClVlDeb  := ""
			cClVlCrd  := (cAlias)->CVALOR
		ElseIf (nValDC5 < 0 .AND. nTipoS == 2) .OR. (nValDC5 > 0 .AND. nTipoS == 1)//indica que hay ganancia en esta moneda 
			If lCuentas
				cCuentaDC := cCtaGanME	
				cCCDC := cCCGan
			Else
				cCuentaDC := POSICIONE('CT1',1,xFilial('CT1')+(cAlias)->CUENTA,'CT1_CTAVM')//ver de cambiar si es perdida o ganancia 
				cCCDC := cCCGan
			EndIf
			lPerGan	  := .F.//T perdida F Ganancia
			cDebito   := cCtaRed
			cCredito  := cCuentaDC
			cCostoDeb := (cAlias)->CCOSTO 
			cCostoCrd := cCCDC
			cItemDeb  := (cAlias)->ITEM
			cItemCrd  := "" 
			cClVlDeb  := (cAlias)->CVALOR
			cClVlCrd  := ""
		EndIf
		If nValDC5 < 0
			nValDC5   := nValDC5 * -1
		EndIf
		//Cargo Moneda del asiento que voy a generar
		cMoedaLanc := "05"

		//Disparo gravación de asientos
		BEGIN TRANSACTION
		   If Round(nValDC5,2) <> 0
				U_GravAsie(cDataFin, cLote, cSublote, cNroDoc, cLinha, "3", cMoedaLanc, cHistor, cDebito,;
							cCredito, cCostoDeb, cCostoCrd, cItemDeb, cItemCrd, cClVlDeb,;
							cClVlCrd, Round(nValDC5,2), cHistorico, "1", "", 3, .T., aCols,;
							cEmpAnt, cFilAnt,,,,,, "DIFCAMB",,,,,,,,)    
				//Genero linea en blanco////////
				U_GravAsie(cDataFin, cLote, cSublote, cNroDoc, cLinha, "3", '01', cHistor, cDebito,;
							cCredito, cCostoDeb, cCostoCrd, cItemDeb, cItemCrd, cClVlDeb,;
							cClVlCrd, 0, cHistorico, "1", "", 3, .T., aCols,;
							cEmpAnt, cFilAnt,,,,,, "DIFCAMB",,,,,,,,)    
				  		
                //Incremento nro de documento
				cLinha	:= Soma1(cLinha) 
				CT2->(dbCommit())
			EndIf
	    END TRANSACTION
	EndIf	
	////////////////////////////////////////////////////////
	///////////FIN CALCULOS PARA LA MONEDA 5///////////////
	///////////////////////////////////////////////////////
	
	///Me muevo de registro y cero valores
	(cAlias)->(dbSkip())
	///cerar variables de diferencia
	nValDC2 := 0
	nValDC2 := 0
	nValDC3 := 0
	nValDC4 := 0
	nValDC5 := 0

EndDo	


(cAlias)->(DbCloseArea ())
 
Return
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±?
±±³Fun‡„o	 ?FormBatch?Autor ?Juan Jose Pereira	    ?Data ?04/12/98 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±?
±±³Descri‡„o ?Monta tela generica para processo batch					  ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±³Sintaxe	 ?FormBatch( cTitle, aSays, aButtons, lOk, bValid )		  ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±³Parƒmetros?cTitle = Titulo da janela								  ³±?
±±?		 ?aSays  = Array com Says 									  ³±?
±±?		 ?aButtons = Array com bottoes								  ³±?
±±?		 ?aButtons[i,1] = Tipo de botao 							  ³±?
±±?		 ?aButtons[i,2] = Tipo de enabled							  ³±?
±±?		 ?aButtons[i,3] = bAction 									  ³±?
±±?		 ?aButtons[i,4] = Hint do Botao							  ³±?
±±?		 ?bValid = Bloco de validacao do Form 						  ³±?
±±?		 ?nAltura= Altura do Form em Pixel (Default 250)			  ³±?
±±?		 ?nLargura = Largura do Form em Pixel (Default 520)		  ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
#DEFINE LARGURA_DO_SBUTTON 32

Static Function FormBatch( cTitle, aSays, aButtons, bValid, nAltura, nLargura )

Local nButtons:= Len(aButtons),;
nSays:= Len(aSays),;
oSay,;
i,nTop, nType, lEnabled, oFormPai, oFont
Local nLarguraBox	:= 0
Local nAlturaBox	:= 0
Local nLarguraSay	:= 0
Local cTextSay

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
// monta says (bof)												 //
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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±?
±±Fun‡„o	 ³FechaBatch?Autor ?Juan Jose Pereira	    ?Data ?04/12/98 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±?
±±³Descri‡„o ?Fecha Ultima tela de batch 								  ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±³Sintaxe	 ?FechaBatch()												  ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
Static Function FechaBatch()

Local oDlg:= Atail( aFormBatch )

oDlg:End()

ASize( aFormBatch,Len(aFormBatch)-1 )

Return nil

/*/{Protheus.doc} GetTotRec
Conta total de registros en la query
@author Rodrigo Godinho
@since 09/11/2017
@version 1.0                       
@param cAlias, characters, Alias de la query
@return numeric, total de registros
@type function
/*/
Static Function GetTotRec(cAlias, lProcessa)
Local nRet	:= 0
Local aArea	:= {}
Default lProcessa	:= .F.
If Select(cAlias) > 0
	aArea := GetArea()
	dbSelectArea(cAlias)
	If lProcessa
		IncProc()
	EndIf
	Count To nRet
	(cAlias)->(dbGoTop())
	RestArea(aArea)
EndIf
Return nRet