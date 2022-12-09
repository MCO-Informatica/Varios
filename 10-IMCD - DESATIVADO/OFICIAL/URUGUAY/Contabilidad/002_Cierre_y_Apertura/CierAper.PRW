#Include "PROTHEUS.Ch"

#DEFINE MAX_LINHA		999
#define STR0014 "Al final del proceso, antes de ejecutar nuevo calculo, procesos o consultas, "
#define STR0015 "sera necesario ejecutar reprocesamiento de saldos"
#define STR0016 "�Continuar?"

Static aFormBatch	:= {} 
Static nTamCta		:= TamSx3("CT1_CONTA")[1]
Static nTamCus		:= TamSx3("CTT_CUSTO")[1]
Static nTamItC		:= TamSx3("CTD_ITEM")[1]
//Static nTamClVl		:= TamSx3("CTH_CLVL")[1]


/*/{Protheus.doc} CierAper
//TODO Asiento de Cierre y Apertura
// CTB > Miscelanea > Cierres > Cierre y Apertura
@author totvs
@since 30/12/2011
@version 1.0
@return ${return}, ${return_description}

@type function
/*/
User Function CierAper()
	Local nOpca := 0
	Local aSays := {}, aButtons := {}
	Local aCols := {}
	Local cPerg := "CIERAPER"

	Private cCadastro := "Generar Asiento de Cierre y Apertura"
	Private cSeqCorr  := ""

	CIERAPERSX1()

	//��������������������������������������������������������������Ŀ
	//� Variaveis utilizadas para parametros                         �
	//� mv_par01 // De Fecha                                         �
	//� mv_par02 // Hasta Fecha                                      �
	//� mv_par03 // Numero de Documento                              �
	//� mv_par04 // Cod. Historial                                   �
	//� mv_par05 // De Cuenta 		        				         �
	//� mv_par06 // Hasta Cuenta                             		 �
	//� mv_par07 // Moneda                                           �
	//� mv_par08 // Tipo de Saldo 				                     �
	//����������������������������������������������������������������

	Pergunte(cPerg,.F.)
	//Ct381Moedas(aCols)
	Ct381Moedas(aCols)

	AADD(aSays, "El Objetivo de este programa es generar el Asiento de Cierre y Apertura")
	AADD(aSays, "se tomar?para generar el c�lculo, todas las cuentas contables")
	AADD(aSays, "y se cerrar?el saldo a la moneda indicada en el par�metro.")

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
		Processa({|lEnd| CieApePro()})
		If FindFunction("CTBSERIALI")
			CtbSerialF("CTBPROC","OFF")
		EndIF
	EndIf

Return

/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Funcion     �CieApePro ?Autor ?TOTVS UY              ?Fecha ?22.04.02 ��?
����������������������������������������������������������������������������Ĵ��
���Descripcion ?Generar Asiento de Cierre y Apertura.                     	 ��?
����������������������������������������������������������������������������Ĵ��
���Sintaxis    ?CieApePro()                                                 ��?
����������������������������������������������������������������������������Ĵ��
���Parametros  ?                                                            ��?
����������������������������������������������������������������������������Ĵ��
��?Uso        ?Cierre y Apertura.                                          ��?
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/
Static Function CieApePro()

	Local lRet 		:= .F.
	Local lTemLcto 	:= .F.
	Local dDataIni 	:= MV_PAR01
	Local dDataFin 	:= MV_PAR02
	Local dDataCA	:= dDataFin
	Local cCampo	:= ""
	Local cNroDoc 	:= Alltrim(MV_PAR03) 
	Local cHistor 	:= Alltrim(MV_PAR04) 
	Local cCtaIni 	:= Alltrim(MV_PAR05) 
	Local cCtaFin 	:= Alltrim(MV_PAR06)
	Local cMoeda 	:= Alltrim(MV_PAR07)
	Local cTpSaldo 	:= Alltrim(MV_PAR08)
	Local cLote 	:= "CIERRE" 
	Local cSublote 	:= "0" + cMoeda
	Local cCuenta	:= "" 
	Local cCC		:= ""
	Local cItemC	:= ""
	Local cCLVL		:= ""
	Local cTipoS	:= "" //para indicar si tiene tipo saldo deudor o acreedor
	Local nSaldo	:= 0
	Local cLinha 	:= "001" 
	Local cMoedaLanc:= "" 
	Local cDebito	:= ""
	Local cCredito	:= ""
	Local cTipoAsie	:= ""
	Local nTotRecs	:= 0
	Local cCostoDeb, cCostoCrd, cItemDeb, cItemCrd, cClVlDeb, cClVlCrd :="" 
	Local cHistCierre:= "Asiento de Cierre" + " " + StrZero(Month(dDataFin),2)+"/" + StrZero(Year(dDataFin),4)
	Local cHistAper  := "Asiento de Apertura" + " " + StrZero(Month(dDataFin+1),2)+"/" + StrZero(Year(dDataFin+1),4)
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

	//����������������������������������������������������������Ŀ
	//?Antes de comenzar el procesamiento valido par�metros     ?
	//������������������������������������������������������������
	Do Case
		Case Empty(dDataIni) // Fecha tiene que tener datos
		MsgInfo("La Fecha no puede estar vac�a.","Atencion!")
		Case Empty(dDataFin) // Fecha tiene que tener datos
		MsgInfo("La Fecha no puede estar vac�a.","Atencion!")
		Case Empty(cNroDoc)// Documento
		MsgInfo("Debe ingresar un N�mero de Documento.","Atencion!")
		Case Empty(cHistor) // Historico
		MsgInfo("Debe ingresar un Hist�rico","Atencion!")
		Case Empty(cCtaFin)// Debe ingresar una cuenta Contable Fin
		MsgInfo("Debe ingresar un rango de Cuenta Contable.","Atencion!")
		Case Empty(cMoeda)	//Moneda
		MsgInfo("Debe seleccionar una Moneda.","Atencion!")
		Case Empty(cTpSaldo) // Tipo de saldo nao preenchido
		MsgInfo("Debe seleccionar un Tipo de Saldo.","Atencion!")
		OtherWise
		lRet := .T.
	EndCase

	If lRet .And. ( !CtbValiDt(1,dDataIni) .Or. !CtbValiDt(1,dDataFin) )
		lRet := .F.
	EndIf

	If !lRet
		Return(lRet)
	EndIf
	aSX5ZC := FWGetSX5("ZC")
	//Chequea en SX5 si ya fue gravado para fecha informada
	/*
	dbSelectarea("SX5")
	dbSetOrder(1)
	If MsSeek(xFilial()+"ZC"+cEmpAnt+cFilAnt)
	While !Eof() .and. SX5->X5_TABELA == "ZC"
	If Subs(&(cCampo),1,8) == Dtos(dDataCa)
	If Subs(&(cCampo),9,2) == cMoeda .And. Subs(&(cCampo),11,1) == cTpSaldo
	CT2->(dbOrderNickName("XDTCA"))
	If CT2->(dbSeek(xFilial("CT2")+DTOS(dDataCa)))
	MsgInfo("Asiento de Cierre y Apertura ya generado en esta fecha. Primero se debe revertir el asiento","Cierre y Apertura")
	Return(.F.)
	EndIf
	EndIf
	Endif
	dbSkip() 
	End			
	EndIf
	*/
	for nx:= 1 tO LEN(aSX5ZC)
		CT2->(dbOrderNickName("XDTCA"))
		If CT2->(dbSeek(xFilial("CT2")+DTOS(dDataCa)))
			MsgInfo("Asiento de Cierre y Apertura ya generado en esta fecha. Primero se debe revertir el asiento","Cierre y Apertura")
			Return(.F.)
		EndIf

	next
	//"Ao final dos Estornos, antes de executar nova apura��o, processos ou consultas,"
	//"executar reprocessamento de saldos !"
	//"Continuar mesmo assim ?"
	//"ATEN��O ! Estorno configurado para n�o atualizar saldos."
	If !MsgYesNo(STR0014+CRLF+STR0015+CRLF+STR0016,"Atencion")
		Return(.F.)
	EndIf

	//////////////////////////
	///////CONSULTA SQL////// 
	/////////////////////////  
	dbSelectArea("CT1")
	CT1->(dbSetOrder(1))  
	dbSelectArea("CT2")
	CT2->(dbSetOrder(1))  
	//Pongo con cero para mostrar algo al usuario mientras la query ejetuca
	ProcRegua(0)
	IncProc()
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
		//FROM CT2020 CT2, CT1020 CT1                                                      ?
		FROM %Table:CT2% CT2, %Table:CT1% CT1
		WHERE
		CT2.CT2_MOEDLC = %Exp:cMoeda% AND
		CT1.%NotDel% AND CT2.%NotDel% AND
		CT2.CT2_DATA >= %Exp:dDataIni% AND
		CT2.CT2_DATA <= %Exp:dDataFin% AND
		CT2.CT2_CREDIT >= %Exp:cCtaIni% AND  CT2.CT2_CREDIT <= %Exp:cCtaFin% AND
		CT2.CT2_TPSALD = %Exp:cTpSaldo% AND  
		CT2.CT2_FILIAL = %Exp:xFilial("CT2")% AND
		CT1.CT1_FILIAL = %Exp:xFilial("CT1")% AND
		CT2.CT2_CREDIT = CT1.CT1_CONTA
		GROUP BY CT2.CT2_CREDIT, CT2.CT2_CCC, CT2.CT2_ITEMC, CT2.CT2_CLVLCR
		UNION
		SELECT CT2.CT2_DEBITO AS CUENTA, CT2.CT2_CCD AS CCOSTO
		,CT2.CT2_ITEMD AS ITEM, CT2.CT2_CLVLDB AS CVALOR
		,SUM(CT2.CT2_VALOR) AS DEBITO 
		,0 AS CREDITO 
		//FROM CT2020 CT2, CT1020 CT1
		FROM %Table:CT2% CT2, %Table:CT1% CT1
		WHERE	
		CT2.CT2_MOEDLC = %Exp:cMoeda% AND
		CT1.%NotDel% AND CT2.%NotDel% AND
		CT2.CT2_DATA >= %Exp:dDataIni% AND
		CT2.CT2_DATA <= %Exp:dDataFin% AND
		CT2.CT2_DEBITO >= %Exp:cCtaIni% AND  CT2.CT2_DEBITO <= %Exp:cCtaFin% AND
		CT2.CT2_TPSALD = %Exp:cTpSaldo% AND
		CT2.CT2_FILIAL = %Exp:xFilial("CT2")% AND
		CT1.CT1_FILIAL = %Exp:xFilial("CT1")% AND  
		//	CT2.CT2_CLVLDB = '7CAMB0100' AND
		//CT2.CT2_FILIAL = %Exp:xFilial("CT2")% AND
		//CT1.CT1_BLOQ <> '1' AND  
		//--JOIN
		CT2.CT2_DEBITO = CT1.CT1_CONTA
		GROUP BY CT2.CT2_DEBITO, CT2.CT2_CCD, CT2.CT2_ITEMD, CT2.CT2_CLVLDB
		) SALDOS
		GROUP BY SALDOS.CUENTA, SALDOS.CCOSTO, SALDOS.ITEM, SALDOS.CVALOR
		ORDER BY SALDOS.CUENTA, SALDOS.CCOSTO, SALDOS.ITEM, SALDOS.CVALOR
	EndSql 


	//////////////////////
	////////FIN SQL////// 
	////////////////////
	COUNT TO nTotRecs
	ProcRegua(nTotRecs)
	(cAlias)->(DbGoTop())
	////////////////////////////////////////////////////
	///Ejecuto la rutina para el asiento de CIERRE  ///
	///////////////////////////////////////////////////

	Do While !(cAlias)->(Eof ())
		//Veo si la cuenta es saldo deudor o acreedor / 1=Deudor, 2=Acreedor
		cTipoS := POSICIONE('CT1',1,xFilial('CT1')+(cAlias)->CUENTA,'CT1_NORMAL')

		If cTipoS == "1" .AND. ((cAlias)->DEBITO - (cAlias)->CREDITO) > 0  			
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
		ElseIf cTipoS == "1" .AND. ((cAlias)->DEBITO - (cAlias)->CREDITO) < 0  			
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
		ElseIf cTipoS == "2" .AND. ((cAlias)->CREDITO - (cAlias)->DEBITO) > 0  			
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
			nSaldo 	  := (cAlias)->CREDITO - (cAlias)->DEBITO                           
		Else //nTipoS == 2 .AND. ((cAlias)->CREDITO - (cAlias)->DEBITO) < 0  			
			If cTipoS == "2" .AND. ((cAlias)->CREDITO - (cAlias)->DEBITO) < 0  			
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
				nSaldo 	  := ((cAlias)->CREDITO - (cAlias)->DEBITO) * -1
			EndIf		
		EndIf
		//Cargo Moneda del asiento que voy a generar
		cMoedaLanc := cMoeda


		BEGIN TRANSACTION
			If Round(nSaldo,2) <> 0
				U_GravAsie(	dDataFin, cLote, cSublote, cNroDoc, cLinha, cTipoAsie, cMoedaLanc, cHistCierre, cDebito,;
				cCredito, cCostoDeb, cCostoCrd, cItemDeb, cItemCrd, cClVlDeb,;
				cClVlCrd, Round(nSaldo,2), cHistCierre, "1", "", 3, .T., aCols,;
				cEmpAnt, cFilAnt,,,,,, "CIERAPER",,,,dDataCA,,,,,dDataCA)

				//Genero linea en blanco////////
				If cMoedaLanc <> '01'
					U_GravAsie(	dDataFin, cLote, cSublote, cNroDoc, cLinha, cTipoAsie, '01', cHistCierre, cDebito,;
					cCredito, cCostoDeb, cCostoCrd, cItemDeb, cItemCrd, cClVlDeb,;
					cClVlCrd, 0, cHistCierre, "1", "", 3, .T., aCols,;
					cEmpAnt, cFilAnt,,,,,, "CIERAPER",,,,dDataCA,,,,,dDataCA) 
				EndIf  

				lTemLcto := .T.

				cLinha := Soma1(cLinha)  
				CT2->(dbCommit())
			EndIf
		END TRANSACTION	


		nSaldo := 0
		///Me muevo de registro y cero valores
		(cAlias)->(dbSkip())
		IncProc()
	EndDo	
	(cAlias)->(DbCloseArea ())


	///Comento esto porque es del cierre solo para probar la actualizacion de saldos

	//////////////////////////
	///////CONSULTA SQL////// 
	/////////////////////////  
	dbSelectArea("CT1")
	CT1->(dbSetOrder(1))  
	dbSelectArea("CT2")
	CT2->(dbSetOrder(1))  
	ProcRegua(0)
	IncProc()
	cAlias	:=	GetNextAlias() 


	BeginSql Alias cAlias   
		SELECT SALDOS.CUENTA, SALDOS.CCOSTO, SALDOS.ITEM, SALDOS.CVALOR
		,ROUND(SUM(SALDOS.DEBITO),2) AS DEBITO, ROUND(SUM(SALDOS.CREDITO),2) AS CREDITO
		FROM (
		SELECT	CT2.CT2_CREDIT AS CUENTA, CT2.CT2_CCC AS CCOSTO
		,CT2.CT2_ITEMC AS ITEM, CT2.CT2_CLVLCR AS CVALOR
		,0 AS DEBITO
		,SUM(CT2.CT2_VALOR) AS CREDITO  
		//FROM CT2020 CT2, CT1020 CT1                                                      ?
		FROM %Table:CT2% CT2, %Table:CT1% CT1
		WHERE
		CT2.CT2_MOEDLC = %Exp:cMoeda% AND
		CT1.%NotDel% AND CT2.%NotDel% AND
		CT2.CT2_DATA >= %Exp:dDataIni% AND
		CT2.CT2_DATA <= %Exp:dDataFin% AND
		CT2.CT2_CREDIT >= %Exp:cCtaIni% AND  CT2.CT2_CREDIT <= %Exp:cCtaFin% AND
		CT2.CT2_TPSALD = %Exp:cTpSaldo% AND
		CT2.CT2_LOTE <> %Exp:cLote% AND       
		CT2.CT2_FILIAL = %Exp:xFilial("CT2")% AND
		CT1.CT1_FILIAL = %Exp:xFilial("CT1")% AND 
		//CT1.CT1_BLOQ <> '1' AND
		//--JOIN
		CT2.CT2_CREDIT = CT1.CT1_CONTA
		GROUP BY CT2.CT2_CREDIT, CT2.CT2_CCC, CT2.CT2_ITEMC, CT2.CT2_CLVLCR
		UNION
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
		CT2.CT2_TPSALD = %Exp:cTpSaldo% AND  
		CT2.CT2_LOTE <> %Exp:cLote% AND
		CT2.CT2_FILIAL = %Exp:xFilial("CT2")% AND
		CT1.CT1_FILIAL = %Exp:xFilial("CT1")% AND 
		CT2.CT2_DEBITO = CT1.CT1_CONTA
		GROUP BY CT2.CT2_DEBITO, CT2.CT2_CCD, CT2.CT2_ITEMD, CT2.CT2_CLVLDB
		) SALDOS

		GROUP BY SALDOS.CUENTA, SALDOS.CCOSTO, SALDOS.ITEM, SALDOS.CVALOR
		ORDER BY SALDOS.CUENTA, SALDOS.CCOSTO, SALDOS.ITEM, SALDOS.CVALOR
	EndSql 
	COUNT TO nTotRecs
	ProcRegua(nTotRecs)
	(cAlias)->(DbGoTop())
	/////////////////////
	////////FIN SQL//////
	/////////////////////

	dDataFin := dDataFin + 1
	cLote := "APERTU"
	cLinha := "001"
	nSaldo := 0

	///////////////////////////////////////////////////
	///Ejecuto la rutina para el asiento de APERTURA///
	///////////////////////////////////////////////////

	Do While !(cAlias)->(Eof ())

		//Veo si la cuenta es saldo deudor o acreedor / 1=Deudor, 2=Acreedor
		cTipoS := POSICIONE('CT1',1,xFilial('CT1')+(cAlias)->CUENTA,'CT1_NORMAL')

		If cTipoS == "1" .AND. ((cAlias)->DEBITO - (cAlias)->CREDITO) > 0  			
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
			nSaldo 	  := (cAlias)->DEBITO - (cAlias)->CREDITO
		ElseIf cTipoS == "1" .AND. ((cAlias)->DEBITO - (cAlias)->CREDITO) < 0  			
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
			nSaldo 	  := ((cAlias)->DEBITO - (cAlias)->CREDITO) * -1		
		ElseIf cTipoS == "2" .AND. ((cAlias)->CREDITO - (cAlias)->DEBITO) > 0  			
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
			nSaldo 	  := (cAlias)->CREDITO - (cAlias)->DEBITO                           
		Else// nTipoS == 2 .AND. ((cAlias)->CREDITO - (cAlias)->DEBITO) < 0  			
			If ((cAlias)->CREDITO - (cAlias)->DEBITO) <> 0 
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
				nSaldo 	  := ((cAlias)->CREDITO - (cAlias)->DEBITO) * -1
			EndIF		
		EndIf

		//Disparo gravaci�n de asiento de Cierre
		BEGIN TRANSACTION
			If Round(nSaldo,2) <> 0
				U_GravAsie(	dDataFin, cLote, cSublote, cNroDoc, cLinha, cTipoAsie, cMoedaLanc, cHistAper, cDebito,;
				cCredito, cCostoDeb, cCostoCrd, cItemDeb, cItemCrd, cClVlDeb,;
				cClVlCrd, Round(nSaldo,2), cHistAper, "1", "", 3, .T., aCols,;
				cEmpAnt, cFilAnt,,,,,, "CIERAPER",,,,dDataCa,,,,,dDataCa)

				//Genero linea en blanco////////
				If cMoedaLanc <> '01'
					U_GravAsie(	dDataFin, cLote, cSublote, cNroDoc, cLinha, cTipoAsie, '01', cHistAper, cDebito,;
					cCredito, cCostoDeb, cCostoCrd, cItemDeb, cItemCrd, cClVlDeb,;
					cClVlCrd, 0, cHistAper, "1", "", 3, .T., aCols,;
					cEmpAnt, cFilAnt,,,,,, "CIERAPER",,,,dDataCa,,,,,dDataCa) 
				EndIf  

				lTemLcto := .T.

				//Incremento nro de documento
				cLinha := Soma1(cLinha)  
				CT2->(dbCommit())
				nSaldo := 0
			EndIf
		END TRANSACTION	

		///Me muevo de registro y cero valores
		(cAlias)->(dbSkip())
		IncProc()
	EndDo

	If lTemLcto
		MsgInfo("Asiento de Cierre/Apertura generado.","Cierre y Apertura")
		//Actualiza fecha del Cierre/Apertura en SX5
		Ct211AtSx5(dDataCA,cMoeda,cTpSaldo)
	Else
		MsgInfo("No se genero ningun asiento, verifique los parametros informados","Cierre y Apertura")
	EndIf

	(cAlias)->(DbCloseArea ())

	Return

	/*
	����������������������������������������������������������������������������?
	����������������������������������������������������������������������������?
	�������������������������������������������������������������������������Ŀ�?
	���Fun��o	 ?FormBatch?Autor ?Juan Jose Pereira	    ?Data ?04/12/98 ��?
	�������������������������������������������������������������������������Ĵ�?
	���Descri��o ?Monta tela generica para processo batch					  ��?
	�������������������������������������������������������������������������Ĵ�?
	���Sintaxe	 ?FormBatch( cTitle, aSays, aButtons, lOk, bValid )		  ��?
	�������������������������������������������������������������������������Ĵ�?
	���Par�metros?cTitle = Titulo da janela								  ��?
	��?		 ?aSays  = Array com Says 									  ��?
	��?		 ?aButtons = Array com bottoes								  ��?
	��?		 ?aButtons[i,1] = Tipo de botao 							  ��?
	��?		 ?aButtons[i,2] = Tipo de enabled							  ��?
	��?		 ?aButtons[i,3] = bAction 									  ��?
	��?		 ?aButtons[i,4] = Hint do Botao							  ��?
	��?		 ?bValid = Bloco de validacao do Form 						  ��?
	��?		 ?nAltura= Altura do Form em Pixel (Default 250)			  ��?
	��?		 ?nLargura = Largura do Form em Pixel (Default 520)		  ��?
	�������������������������������������������������������������������������Ĵ�?
	����������������������������������������������������������������������������?
	����������������������������������������������������������������������������?
	*/
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

/*
����������������������������������������������������������������������������?
����������������������������������������������������������������������������?
�������������������������������������������������������������������������Ŀ�?
��Fun��o	 �FechaBatch?Autor ?Juan Jose Pereira	    ?Data ?04/12/98 ��?
�������������������������������������������������������������������������Ĵ�?
���Descri��o ?Fecha Ultima tela de batch 								  ��?
�������������������������������������������������������������������������Ĵ�?
���Sintaxe	 ?FechaBatch()												  ��?
�������������������������������������������������������������������������Ĵ�?
����������������������������������������������������������������������������?
����������������������������������������������������������������������������?
*/
Static Function FechaBatch()

	Local oDlg:= Atail( aFormBatch )

	oDlg:End()

	ASize( aFormBatch,Len(aFormBatch)-1 )

Return nil

/*
����������������������������������������������������������������������������?
����������������������������������������������������������������������������?
�������������������������������������������������������������������������Ŀ�?
���Fun��o    ?CIERAPERSX1  �Autor �Simone Mie Sato       �Data?24/02/05 ��?
�������������������������������������������������������������������������Ĵ�?
���Descri��o ?Ajusta perguntas do SX1                                    ��?
��������������������������������������������������������������������������ٱ?
����������������������������������������������������������������������������?
����������������������������������������������������������������������������?
*/
Static Function CIERAPERSX1()

	Local aArea 	:= GetArea()

	//��������������������������������������������������������������Ŀ
	//?Variaveis utilizadas para parametros                         ?
	//?mv_par01 // De Fecha                                         ?
	//?mv_par02 // Hasta Fecha                                      ?
	//?mv_par03 // Numero de Documento                              ?
	//?mv_par04 // Cod. Historial                                   ?
	//?mv_par05 // De Cuenta 		        				         ?
	//?mv_par06 // Hasta Cuenta                             		 ?
	//?mv_par07 // Moneda                                           ?
	//?mv_par08 // Tipo de Saldo 				                     ?
	//����������������������������������������������������������������

//	U_UYPutSx1({{"CIERAPER","01","Da Data?","De Fecha ?","From Date ?", "mv_ch1", "D", 8,0,0, "G", "", "", "", "S","mv_par01","","","","", "", "", "", "", "", "", "", "", "", "", "", ""}})
//	U_UYPutSx1({{"CIERAPER","02","Ate a Data ?","A Fecha ?","To Date ?", "mv_ch2", "D", 8,0,0, "G", "", "", "", "S","mv_par02","","","","", "", "", "", "", "", "", "", "", "", "", "", ""}})
//	u_UyPutSx1({{"CIERAPER","03","Numero do Documento ?","Numero de Documento ?","Document Number ?", "mv_ch3", "C", 6,0,0, "G", "", "", "", "S","mv_par03","","","", "", "", "", "", "", "", "", "", "", "", "", "", ""}})
//	u_UyPutSx1({{"CIERAPER","04","Cod.Historico Padrao ?","Cod.Hist.Estandar ?","Standard Hist.Code ?", "mv_ch4", "C", 3,0,0, "G", "",    "CT8", "", "S","mv_par04","","","", "", "", "", "", "", "", "", "", "", "", "", "", ""}})
//	u_UyPutSx1({{"CIERAPER","05","Da Conta ?","De Cuenta ?","From Account ?", "mv_ch5", "C", nTamCta,0,0, "G", "", "CT1", "003", "S","mv_par05","","","","", "", "", "", "", "", "", "", "", "", "", "", ""}})
//	u_UyPutSx1({{"CIERAPER","06","Ate a Conta ?","A Cuenta ?","To Account ?", "mv_ch6", "C", nTamCta,0,0, "G", "", "CT1", "003", "S","mv_par06","","","","", "", "", "", "", "", "", "", "", "", "", "", ""}})
//	u_UyPutSx1({{"CIERAPER","07","Moeda Base ?","Moneda base ?","Currency base ?", "mv_ch7", "C", 2,0,0, "G", "", "CTO", "", "S","mv_par07","","","","", "", "", "", "", "", "", "", "", "", "", "", ""}})
//	u_UyPutSx1({{"CIERAPER","08","Tipo de Saldo ?","Tipo de Saldo ?","Balance Type ?", "mv_ch8", "C", 1,0,0, "G", "", "SLD", "", "S","mv_par08","","","","", "", "", "", "", "", "", "", "", "", "", "", ""}})

	RestArea(aArea)

Return

/*/
����������������������������������������������������������������������������?
����������������������������������������������������������������������������?
�������������������������������������������������������������������������Ŀ�?
���Program   �ACTCT7  ?Autor ?TOTVS UY                ?Data ?04/06/12 ��?
�������������������������������������������������������������������������Ĵ�?
���Descri��o ?Actualiza saldos de las cuentas contables.				  ��?
�������������������������������������������������������������������������Ĵ�?
���Uso       ?Generico                                                   ��?
�������������������������������������������������������������������������Ĵ�?
��������������������������������������������������������������������������ٱ?
����������������������������������������������������������������������������?
����������������������������������������������������������������������������?
/*/
User Function ActCT7(cConta,cTipo,dData,cMoeda,nValor,cTpSald,lReproc,lAtSldBase,lZera,dDataLP)

	//U_ActCT7(cCuenta,cTipo(si es debito o credito),dData,cMoeda,nValor,cTpSald,lReproc(si va a reprocesar actualizar),lAtSldBase,lZera,dDataLP(fecha de Resultado))


	Local aSaveArea	:= GetArea()
	Local lInclui	:= .F.
	Local nAntDeb	:= 0
	Local nAntCrd	:= 0
	Local aSldAntCT7:= {}
	Local cChave	:= ""

	lReproc 		:= Iif(lReproc==Nil,.F.,lReproc)
	lAtSldBase 		:= Iif(lAtSldBase==Nil,.T.,lAtSldBase)                                                                               
	lZera			:= Iif(lZera == Nil,.F.,lZera)
	dDataLP		    := Iif(dDataLP == Nil, CTOD("  /  /  "), dDataLP)

	If Empty(cConta) .Or. nValor <= 0
		Return
	EndIf	         

	DbSelectArea( "CT7" )
	If Empty(dDataLP)
		cChave	:= xFilial()+cMoeda+cTpSald+cConta+Dtos(dData)
	Else
		cChave	:= xFilial()+cMoeda+cTpSald+cConta+Dtos(dData)+"Z"	
	EndIf

	DbSetOrder( 1 )  
	If !dbSeek(cChave,.T.)
		lInclui	:= .T.
	Else
		lInclui := .F.
		//Se nao for lancamento de zeramento e posicionar no saldo de zeramento.
		//Devera ser incluido um novo registro. 		
		If Empty(dDataLP) .And. CT7->CT7_LP == 'Z'
			lInclui := .T.			
		EndIf
	EndIf

	//Rotina para recuperar saldo anterior                  
	If !lInclui .And. lZera 	//Se for CTBA360.
		aSldAntCT7 := SldAntCT7(cConta,dData,cMoeda,cTpSald,,.T.)
	Else
		aSldAntCT7 := SldAntCT7(cConta,dData,cMoeda,cTpSald,,lInclui)
	EndIf                                                                 

	BEGIN TRANSACTION
		// Nao ha registro para o dia -> cria!!
		If lInclui
			RecLock( "CT7", .t. )
			CT7->CT7_FILIAL 	:= xFilial()
			CT7->CT7_CONTA		:= cConta
			CT7->CT7_MOEDA		:= cMoeda
			CT7->CT7_DATA		:= dData
			CT7->CT7_TPSALD		:= cTpSald					// Real / Orcado / Gerencial
			CT7->CT7_STATUS		:= "1"						// Periodo Aberto
			If !Empty(dDataLP)
				CT7->CT7_LP 	:= 'Z'						//Se for lancamento de zeramento
				CT7->CT7_DTLP	:= dDataLP
			Else
				CT7->CT7_LP			:= "N"					// Flag indicando que ainda nao foi zerado
			EndIf
		Else			
			RecLock( "CT7", .f. )
			//Se o programa for CTBA360, devo zerar os movimentos
			If lZera
				If cTipo == "1"
					CT7->CT7_DEBITO	:= 0
				ElseIf cTipo == "2"
					CT7->CT7_CREDIT	:= 0			
				EndIf
			EndIf
		Endif

		nAntDeb	:= aSldAntCT7[1]
		nAntCrd	:= aSldAntCT7[2]

		// Grava valores atuais
		// Soma valores aos ja existentes
		If cTipo == "1"
			CT7->CT7_DEBITO	:= (CT7->CT7_DEBITO + nValor)
			#IFDEF TOP
			CT7->CT7_ANTDEB	:= nAntDeb
			CT7->CT7_ATUDEB	:= CT7->CT7_ANTDEB+CT7->CT7_DEBITO
			CT7->CT7_ANTCRD	:= nAntCrd
			CT7->CT7_ATUCRD	:= CT7->CT7_ANTCRD+CT7->CT7_CREDIT
			#ENDIF		
		ElseIf cTipo == "2"
			CT7->CT7_CREDIT	:= (CT7->CT7_CREDIT + nValor)
			#IFDEF TOP
			CT7->CT7_ANTCRD	:= nAntCrd
			CT7->CT7_ATUCRD	:= CT7->CT7_ANTCRD+CT7->CT7_CREDIT
			CT7->CT7_ANTDEB	:= nAntDeb
			CT7->CT7_ATUDEB	:= CT7->CT7_ANTDEB+CT7->CT7_DEBITO
			#ENDIF		
		EndIf	            	

		//Atualiza flag de saldo basico.	
		#IFDEF TOP
		CT7->CT7_SLBASE	:= "S"
		#ENDIF
		MsUnlock()        
	END TRANSACTION
	//Chama funcao que grava o saldo anterior e o saldo atual
	GRVSLDCT7(cTipo,cConta,cMoeda,cTpSald,dData,nValor,nAntDeb,nAntCrd,lReproc,lAtSldBase,,lZera,"+")
	RestArea(aSaveArea)

Return 


/*/
������������������������������������������������������������������������������?
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Program   �GRVSLDCT7 ?Autor ?TOTVS UY            ?Data ?09/06/2012  ��?
��������������������������������������������������������������������������Ĵ��
���Descri��o ?Grava Saldo Anterior e Saldo Atual do CT7				   ��?
��������������������������������������������������������������������������Ĵ��
���Sintaxe   �GRVSLDCT7(cConta,cMoeda,cTpSald,nAntDeb,nAntCrd,lReproc,	   ��?                                                    
��?         �lAtSldBase,cFilX)                                       	   ��?                                                    
��������������������������������������������������������������������������Ĵ��
���Retorno   ?Nenhum                                                      ��?
��������������������������������������������������������������������������Ĵ��
���Uso       ?Generico                                                    ��?
��������������������������������������������������������������������������Ĵ��
���Parametros?ExpC1 = Conta Contabil                                      ��?
��?         ?ExpC2 = Moeda do Lancamento Contabil                        ��?
��?         ?ExpC3 = Tipo do Saldo                                       ��?
��?         ?ExpN2 = Valor anterior debito                         	   ��?
��?         ?ExpN3 = Valor anterioro credito                       	   ��?
��?         ?ExpL1 = Define se ira atualizar os dias posteriores   	   ��?
��?         ?ExpL2 = Define se devera preencher o flag de atualiz.saldos ��?
��?         ?ExpC1 = Filial											   ��?
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������?
/*/
User Function GRVSLDCT7(cTipo,cConta,cMoeda,cTpSald,dData,nValor,nAntDeb,nAntCrd,lReproc,lAtSldBase,cFilX,lZera,cOperacao)

	Local aSaveArea		:= GetArea()
	Local nRegCT7		:= Recno()

	#IFDEF TOP
	Local cChave		:= ""
	Local cQuery		:= ""
	Local cGrvSldCT7	:= ""	
	Local nCountReg		:= 0               	
	Local nMax			:= 0
	Local nMin			:= 0
	Local nRecCT7		:= 0	
	#ENDIF

	lReproc 	 		:= Iif(lReproc==Nil,.F.,lReproc)
	lAtSldBase			:= Iif(lAtSldBase==Nil,.T.,lAtSldBase)                      
	cFilX				:= Iif(cFilX==Nil,xFilial("CT7"),cFilX)
	lZera				:= Iif(lZera == Nil,.F.,lZera)

	DEFAULT cOperacao	:= "+"

	// Recalcula valores
	nRegCT7 := Recno()

	If lReproc //Se for Reprocessamento, so deve atualizar o registro atual
		If !Eof() .And. CT7->CT7_FILIAL == cFilX .And. ;
		CT7->CT7_TPSALD == cTpSald .And. CT7->CT7_CONTA == cConta .And. ;
		CT7->CT7_MOEDA == cMoeda				
			RecLock("CT7")
			CT7->CT7_ANTDEB	:= nAntDeb 
			CT7->CT7_ANTCRD	:= nAntCrd
			CT7->CT7_ATUDEB	:= nAntDeb + CT7->CT7_DEBITO
			CT7->CT7_ATUCRD	:= nAntCrd + CT7->CT7_CREDIT                      
			//Se for Reprocessamento ou se for CTBA360, devera estar com flag de atualizado			
			//para nao precisar atualizar novamente. 
			If lAtSldBase .Or. lZera
				CT7->CT7_SLBASE	:= "S"
			Else 		   //Flag de Atualizacao de saldo,para identificar que o
				CT7->CT7_SLBASE	:= "N"//saldo devera ser atualizado a partir desse reg.    
			EndIf
			MsUnlock()	
		Endif
	Else	
		#IFDEF TOP                             
		If !lAS400
			CT7->(dbCommit())
			cGrvSldCT7 := "cGrvSldCT7"   		
			cQuery   	:= "SELECT R_E_C_N_O_ RECNO "
			cQuery   	+=" FROM "+RetSqlName("CT7")+" CT7 "
			cQuery		+= "WHERE CT7.CT7_FILIAL = '"+cFilX+"' AND "
			cQuery   	+= "CT7.CT7_TPSALD = '"+cTpSald+"' AND "                  
			cQuery   	+= "CT7.CT7_CONTA ='"+cConta+"' AND "			
			cQuery   	+= "CT7.CT7_MOEDA ='"+cMoeda+"' AND "			
			cQuery 		+= "CT7_DATA > '"+Dtos(dData)+"' AND "		
			cQuery   	+= "D_E_L_E_T_<>'*'" 		
			cQuery   	+= "ORDER BY RECNO" 		
			cQuery		:= ChangeQuery(cQuery)   

			If ( Select ( cGrvSldCT7 ) <> 0 )
				dbSelectArea ( cGrvSldCT7 )
				dbCloseArea ()
			Endif

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cGrvSldCT7,.T.,.F.)

			cQuery := "UPDATE "
			cQuery += RetSqlName("CT7")+" "				
			cQuery += "SET " 
			If cTipo = "1"
				cQuery += "CT7_ANTDEB = CT7_ANTDEB " + cOperacao + (Str(nValor,TAMSX3("CT7_ANTDEB")[1],TAMSX3("CT7_ANTDEB")[2])) +", "
				cQuery += "CT7_ATUDEB = CT7_ATUDEB " + cOperacao + (Str(nValor,TAMSX3("CT7_ATUDEB")[1],TAMSX3("CT7_ATUDEB")[2])) + " "   			
			ElseIf cTipo = "2"	
				cQuery += "CT7_ANTCRD =  CT7_ANTCRD " + cOperacao + (Str(nValor,TAMSX3("CT7_ANTCRD")[1],TAMSX3("CT7_ANTCRD")[2])) + ", "   			
				cQuery += "CT7_ATUCRD =  CT7_ATUCRD " + cOperacao + (Str(nValor,TAMSX3("CT7_ATUCRD")[1],TAMSX3("CT7_ATUCRD")[2])) + " "   			    
			EndIf
			cQuery += "WHERE CT7_FILIAL = '"+cFilX+"' AND "
			cQuery += "CT7_TPSALD = '"+cTpSald+"' AND "                           
			cQuery += "CT7_CONTA ='"+cConta+"' AND "			
			cQuery += "CT7_MOEDA ='"+cMoeda+"' AND "			
			cQuery += "CT7_DATA > '"+Dtos(dData)+"' AND "
			cQuery 	+= "D_E_L_E_T_<>'*' AND " 		

			While cGrvSldCT7->(!EOF())

				nMin := (cGrvSldCT7)->RECNO

				nCountReg := 0

				While cGrvSldCT7->(!EOF()) .and. nCountReg <= 4096

					nMax := (cGrvSldCT7)->RECNO
					nCountReg++
					cGrvSldCT7->(DbSkip())

				End

				cChave := "R_E_C_N_O_>="+Str(nMin,10,0)+" AND R_E_C_N_O_<="+Str(nMax,10,0)+""

				BEGIN TRANSACTION
					TcSqlExec(cQuery+cChave)
				END TRANSACTION

			End

			If ( Select ( cGrvSldCT7 ) <> 0 )
				dbSelectArea ( cGrvSldCT7 )
				dbCloseArea ()
			Endif						

			dbSelectArea("CT7")
			nRecCT7	:= CT7->(Recno())
			dbGoto(0)
			dbGoto(nRecCT7)		

		Else			
			#ENDIF
			While !Eof() .And. CT7->CT7_FILIAL == cFilX .And. ;
			CT7->CT7_TPSALD == cTpSald .And. CT7->CT7_CONTA == cConta .And. ;
			CT7->CT7_MOEDA == cMoeda
				RecLock("CT7")
				CT7->CT7_ANTDEB	:= nAntDeb 
				CT7->CT7_ANTCRD	:= nAntCrd
				CT7->CT7_ATUDEB	:= nAntDeb + CT7->CT7_DEBITO
				CT7->CT7_ATUCRD	:= nAntCrd + CT7->CT7_CREDIT
				CT7->CT7_SLBASE	:= "S"
				MsUnlock()
				nAntDeb 	:= CT7->CT7_ATUDEB
				nAntCrd		:= CT7->CT7_ATUCRD
				dbSkip()
			EndDo
			#IFDEF TOP
		Endif
		#ENDIF								
	Endif

	RestArea(aSaveArea)

Return 


/*/
����������������������������������������������������������������������������?
����������������������������������������������������������������������������?
�������������������������������������������������������������������������Ŀ�?
���Program   �GravaCt3  ?Autor ?TOTVS UY            ?Data ?09/06/2012 ��?
�������������������������������������������������������������������������Ĵ�?
���Descri��o ?Grava Saldos dos Centros de Custo e atualiza saldo dia dia ��?
�������������������������������������������������������������������������Ĵ�?
���Sintaxe   �GRAVACT3(cConta,cCusto,cTipo,dData,cMoeda,nValor,cTpSald)   ��?
�������������������������������������������������������������������������Ĵ�?
���Retorno   ?Nenhum                                                     ��?
�������������������������������������������������������������������������Ĵ�?
���Uso       ?Generico                                                   ��?
�������������������������������������������������������������������������Ĵ�?
���Parametros?ExpC1 = Conta Contabil                                     ��?
��?         ?ExpC2 = Centro de Custo                                    ��?
��?         ?ExpC3 = Tipo do Lancamento Contabil                        ��?
��?         ?ExpD1 = Data do Lancamento Contabil                        ��?
��?         ?ExpC4 = Moeda do Lancamento Contabil                       ��?
��?         ?ExpN1 = Valor do Lancamento Contabil                  	  ��?
��?         ?ExpC5 = Tipo do Saldo                                  	  ��?
��?         ?ExpL1 = Define se foi chamado pelo Reprocessamento     	  ��?
��?         ?ExpL2 = Define se Atualiza Saldo basico na dig. lancamento ��?
��?         ?ExpL3 = Define se zera os movimentos.                  	  ��?
��������������������������������������������������������������������������ٱ?
����������������������������������������������������������������������������?
����������������������������������������������������������������������������?
/*/
User Function GravaCT3(cConta,cCusto,cTipo,dData,cMoeda,nValor,cTpSald,lReproc,lAtSldBase,lZera,dDataLP)

	Local aSaveArea	:= GetArea()
	Local lInclui		:= .F.
	Local nAntDeb		:= 0
	Local nAntCrd		:= 0                                                    
	Local aSldAntCT3	:= {}
	Local cChave		:= ""

	lReproc				:= Iif(lReproc == Nil,.F.,lReproc)
	lAtSldBase 			:= Iif(lAtSldBase == Nil,.T.,lAtSldBase)
	lZera				:= Iif(lZera == Nil,.F.,lZera)
	dDataLP				:= Iif(dDataLp == Nil, CTOD("  /  /  "),dDAtaLP)

	If Empty(cCusto) .Or. nValor <= 0
		Return
	EndIf	

	DbSelectArea("CT3")
	If Empty(dDataLP)
		cChave	:= xFilial()+cMoeda+cTpSald+cConta+cCusto+Dtos(dData)
	Else
		cChave	:= xFilial()+cMoeda+cTpSald+cConta+cCusto+Dtos(dData)+"Z"	
	EndIf

	DbSetOrder(1)
	If !dbSeek(cChave,.T.)
		lInclui 	:= .T.
	Else
		lInclui		:= .F.
		//Se nao for lancamento de zeramento e posicionar no saldo de zeramento.
		//Devera ser incluido um novo registro. 		
		If Empty(dDataLP) .And. CT3->CT3_LP == 'Z'
			lInclui := .T.			
		EndIf		
	EndIf	

	//Rotina para recuperar saldo anterior
	If !lInclui .And. lZera 	//Se for CTBA360.
		aSldAntCT3 := SldAntCT3(cConta,cCusto,dData,cMoeda,cTpSald,,.T.)
	Else
		aSldAntCT3 := SldAntCT3(cConta,cCusto,dData,cMoeda,cTpSald,,lInclui)
	EndIf
	BEGIN TRANSACTION
		// Nao ha registro para o dia -> cria!!
		If lInclui
			RecLock("CT3",.t.)
			CT3->CT3_FILIAL	:= xFilial("CT3")
			CT3->CT3_CONTA		:= cConta
			CT3->CT3_CUSTO		:= cCusto
			CT3->CT3_MOEDA		:= cMoeda
			CT3->CT3_DATA		:= dData
			CT3->CT3_TPSALD		:= cTpSald                               
			CT3->CT3_STATUS		:= "1"					// Periodo Aberto
			If !Empty(dDataLP)
				CT3->CT3_LP			:= 'Z'				//Indica que eh saldo de zeramento
				CT3->CT3_DTLP		:= dDataLP			
			Else
				CT3->CT3_LP			:= 'N'				//Flag indicando que o saldo ainda nao foi zerado
			EndIf
		Else
			RecLock( "CT3", .f. )
			//Se for rotina de atualizacao de saldos compostos, ira zerar os saldos 
			If lZera
				If cTipo == "1"
					CT3->CT3_DEBITO	:= 0
				ElseIf cTipo == "2"
					CT3->CT3_CREDIT	:= 0			
				EndIf
			EndIf		
		EndIf

		nAntDeb	:= aSldAntCT3[1]
		nAntCrd	:= aSldAntCT3[2]

		// Grava valores atuais
		If cTipo == "1"
			CT3->CT3_DEBITO	:= (CT3->CT3_DEBITO + nValor)
			#IFDEF TOP
			CT3->CT3_ANTDEB	:= nAntDeb
			CT3->CT3_ATUDEB	:= CT3->CT3_ANTDEB+CT3->CT3_DEBITO
			CT3->CT3_ANTCRD	:= nAntCrd
			CT3->CT3_ATUCRD	:= CT3->CT3_ANTCRD+CT3->CT3_CREDIT
			#ENDIF				
		ElseIf cTipo == "2"
			CT3->CT3_CREDIT	:= (CT3->CT3_CREDIT + nValor)
			#IFDEF TOP
			CT3->CT3_ANTDEB	:= nAntDeb
			CT3->CT3_ATUDEB	:= CT3->CT3_ANTDEB+CT3->CT3_DEBITO
			CT3->CT3_ANTCRD	:= nAntCrd
			CT3->CT3_ATUCRD	:= CT3->CT3_ANTCRD+CT3->CT3_CREDIT
			#ENDIF				
		EndIf	
		//Atualiza flag de saldo basico.	
		#IFDEF TOP
		CT3->CT3_SLBASE	:= "S"
		#ENDIF	
		MsUnlock()        
	END TRANSACTION
	//Chama funcao que grava o saldo anterior e o saldo atual          
	GRVSLDCT3(cTipo,cConta,cCusto,cMoeda,cTpSald,dData,nValor,nAntDeb,nAntCrd,lReproc,lAtSldBase,,lZera,"+")	
	RestArea(aSaveArea)

Return 


/*/
����������������������������������������������������������������������������?
����������������������������������������������������������������������������?
�������������������������������������������������������������������������Ŀ�?
���Program   �GravaCt4  ?Autor ?TOTVS UY            ?Data ?09/06/2012 ��?
�������������������������������������������������������������������������Ĵ�?
���Descri��o ?Grava Saldos dos Itens Contabeis e atualiza saldo dia dia  ��?
�������������������������������������������������������������������������Ĵ�?
���Sintaxe   �GRAVACT4(cConta,cCusto,cItem,cTipo,dData,cMoeda,nValor,	  ��?
��?		 �cTpSald)                                                    ��?
�������������������������������������������������������������������������Ĵ�?
���Retorno   ?Nenhum                                                     ��?
�������������������������������������������������������������������������Ĵ�?
���Uso       ?Generico                                                   ��?
�������������������������������������������������������������������������Ĵ�?
���Parametros?ExpC1 = Conta Contabil                                     ��?
��?         ?ExpC2 = Centro de Custo                                    ��?
��?         ?ExpC3 = Item Contabil                                      ��?
��?         ?ExpC4 = Tipo do Lancamento Contabil                        ��?
��?         ?ExpD1 = Data do Lancamento Contabil                        ��?
��?         ?ExpC5 = Moeda do Lancamento Contabil                       ��?
��?         ?ExpN1 = Valor do Lancamento Contabil                  	  ��?
��?         ?ExpC6 = Tipo do Saldo                                  	  ��?
��?         ?ExpL1 = Define se foi chamado pelo Reprocessamento     	  ��?
��?         ?ExpL2 = Define se atualiza saldo basico na dig. lancamento ��?
��?         ?ExpL3 = Define se zera os movimentos				     	  ��?
��������������������������������������������������������������������������ٱ?
����������������������������������������������������������������������������?
����������������������������������������������������������������������������?
/*/
User Function GRAVACT4(cConta,cCusto,cItem,cTipo,dData,cMoeda,nValor,cTpSald,lReproc,lAtSldBase,lZera,dDataLP)

	Local aSaveArea		:= GetArea()
	Local lInclui		:= .F.
	Local nAntDeb		 := 0
	Local nAntCrd	 	:= 0
	Local aSldAntCT4	:= {}		
	Local cChave		:= ""

	lReproc 			:= Iif(lReproc==Nil,.F.,lReproc)
	lAtSldBase			:= Iif(lAtSldBase==Nil,.T.,lAtSldBase) 
	lZera				:= Iif(lZera == Nil,.F.,lZera)
	dDataLP				:= Iif(dDataLP == Nil,CTOD("  /  /  "),dDataLP)

	If Empty(cItem) .Or. nValor <= 0
		Return
	EndIf	

	DbSelectArea("CT4")
	If Empty(dDataLP)
		cChave	:= xFilial()+cMoeda+cTpSald+cConta+cCusto+cItem+Dtos(dData)
	Else
		cChave	:= xFilial()+cMoeda+cTpSald+cConta+cCusto+cItem+Dtos(dData)+"Z"	
	EndIf

	DbSetOrder(1)
	If !dbSeek(cChave,.T.)
		lInclui	:= .T.
	Else
		lInclui	:= .F.
		//Se nao for lancamento de zeramento e posicionar no saldo de zeramento.
		//Devera ser incluido um novo registro. 		
		If Empty(dDataLP) .And. CT4->CT4_LP == 'Z'
			lInclui := .T.			
		EndIf				
	EndIf

	//Rotina para recuperar saldo anterior
	If !lInclui .And. lZera 	//Se for CTBA360.
		aSldAntCT4 := SldAntCT4(cConta,cCusto,cItem,dData,cMoeda,cTpSald,,.T.)
	Else	
		aSldAntCT4 := SldAntCT4(cConta,cCusto,cItem,dData,cMoeda,cTpSald,,lInclui)
	EndIf
	BEGIN TRANSACTION
		// Nao ha registro para o dia -> cria!!
		If lInclui
			RecLock( "CT4", .t. )
			CT4->CT4_FILIAL 	:= xFilial()
			CT4->CT4_CONTA		:= cConta
			CT4->CT4_CUSTO		:= cCusto
			CT4->CT4_ITEM		:= cItem
			CT4->CT4_MOEDA		:= cMoeda
			CT4->CT4_DATA		:= dData
			CT4->CT4_TPSALD		:= cTpSald
			CT4->CT4_STATUS		:= "1"					// Periodo Aberto
			If !Empty(dDataLP)
				CT4->CT4_LP 	:= 'Z'						//Se for lancamento de zeramento
				CT4->CT4_DTLP	:= dDataLP			
			Else
				CT4->CT4_LP		:= "N"					// Flag indicando que ainda nao foi zerado
			EndIf
		Else
			RecLock( "CT4", .f. )
			//Se for rotina de atualizacao de saldos compostos (CTBA360),
			// deve zerar os movimentos
			If lZera 
				If cTipo == "1"
					CT4->CT4_DEBITO	:= 0
				ElseIf cTipo == "2"
					CT4->CT4_CREDIT	:= 0			
				EndIf
			EndIf		
		Endif

		nAntDeb	:= aSldAntCT4[1]
		nAntCrd	:= aSldAntCT4[2]	

		// Grava valores atuais
		If cTipo == "1"        
			CT4->CT4_DEBITO	:= (CT4->CT4_DEBITO + nValor)	
			#IFDEF TOP
			CT4->CT4_ANTDEB	:= nAntDeb
			CT4->CT4_ATUDEB	:= CT4->CT4_ANTDEB+CT4->CT4_DEBITO
			CT4->CT4_ANTCRD	:= nAntCrd
			CT4->CT4_ATUCRD	:= CT4->CT4_ANTCRD+CT4->CT4_CREDIT
			#ENDIF		
		ElseIf cTipo == "2"
			CT4->CT4_CREDIT	:= (CT4->CT4_CREDIT + nValor)
			#IFDEF TOP
			CT4->CT4_ANTDEB	:= nAntDeb
			CT4->CT4_ATUDEB	:= CT4->CT4_ANTDEB+CT4->CT4_DEBITO
			CT4->CT4_ANTCRD	:= nAntCrd
			CT4->CT4_ATUCRD	:= CT4->CT4_ANTCRD+CT4->CT4_CREDIT
			#ENDIF				
		EndIf	 
		//Atualiza flag de saldo basico.	
		#IFDEF TOP
		CT4->CT4_SLBASE	:= "S"
		#ENDIF	
		MsUnlock()
	END TRANSACTION
	//Chama funcao que grava o saldo anterior e o saldo atual
	GRVSLDCT4(cTipo,cConta,cCusto,cItem,cMoeda,cTpSald,dData,nValor,nAntDeb,nAntCrd,lReproc,lAtSldBase,,lZera,"+")
	RestArea(aSaveArea)

Return                                


/*/
����������������������������������������������������������������������������?
����������������������������������������������������������������������������?
�������������������������������������������������������������������������Ŀ�?
���Program   �GravaCtI  ?Autor ?TOTVS UY           ?Data ?09/06/2012  ��?
�������������������������������������������������������������������������Ĵ�?
���Descri��o ?Grava Saldos da Classe de Valores  atualiza saldo dia dia  ��?
�������������������������������������������������������������������������Ĵ�?
���Sintaxe   �GRAVACTI(cConta,cCusto,cItem,cClasseVlr,cTipo,dData,cMoeda, ��?
��?		 ?nValor,cTpSald)                                           ��?
�������������������������������������������������������������������������Ĵ�?
���Retorno   ?Nenhum                                                     ��?
�������������������������������������������������������������������������Ĵ�?
���Parametros?ExpC1 = Conta Contabil                                     ��?
��?         ?ExpC2 = Centro de Custo                                    ��?
��?         ?ExpC3 = Item Contabil                                      ��?
��?         ?ExpC3 = Classe de Valores                                  ��?
��?         ?ExpC4 = Tipo do Lancamento Contabil                        ��?
��?         ?ExpD1 = Data do Lancamento Contabil                        ��?
��?         ?ExpC5 = Moeda do Lancamento Contabil                       ��?
��?         ?ExpN1 = Valor do Lancamento Contabil                  	  ��?
��?         ?ExpC6 = Tipo do Saldo                                  	  ��?
��?         ?ExpL1 = Define se foi chamado pelo Reprocessamento     	  ��?
��?         ?ExpL2 = Define se atualiza saldo basico na dig.lancamento  ��?
��?         ?ExpL3 = Define se zera os movimentos debito/credito    	  ��?
��������������������������������������������������������������������������ٱ?
����������������������������������������������������������������������������?
����������������������������������������������������������������������������?
/*/
User Function GRAVACTI(cConta,cCusto,cItem,cClasseVlr,cTipo,dData,cMoeda,nValor,cTpSald,lReproc,lAtSldBase,lZera,dDataLP)

	Local aSaveArea		:= GetArea()
	Local lInclui		:= .F.
	Local nAntDeb		:= 0
	Local nAntCrd		:= 0                     
	Local aSldAntCTI 	:= {}
	Local cChave		:= ""

	lReproc 			:= Iif(lReproc==Nil,.F.,lReproc)
	lAtSldBase			:= Iif(lAtSldBase==Nil,.T.,lAtSldBase) 
	lZera				:= Iif(lZera == Nil,.F.,lZera)
	dDataLP				:= Iif(dDataLP == Nil,CTOD("  /  /  "),dDataLP)

	If Empty(cClasseVlr) .Or. nValor <= 0
		Return
	EndIf	

	DbSelectArea("CTI")

	If Empty(dDataLP)
		cChave	:= xFilial()+cMoeda+cTpSald+cConta+cCusto+cItem+cClasseVlr+Dtos(dData)
	Else
		cChave	:= xFilial()+cMoeda+cTpSald+cConta+cCusto+cItem+cClasseVlr+Dtos(dData)+"Z"	
	EndIf

	DbSetOrder(1)
	If !dbSeek(cChave,.T.)
		lInclui := .T.
	Else
		lInclui	:= .F.
		//Se nao for lancamento de zeramento e posicionar no saldo de zeramento.
		//Devera ser incluido um novo registro. 		
		If Empty(dDataLP) .And. CTI->CTI_LP == 'Z'
			lInclui := .T.			
		EndIf
	EndIf

	//Rotina para recuperar saldo anterior
	If !lInclui .And. lZera 	//Se for CTBA360.
		aSldAntCTI := SldAntCTI(cConta,cCusto,cItem,cClasseVlr,dData,cMoeda,cTpSald,,.T.)
	Else	
		aSldAntCTI := SldAntCTI(cConta,cCusto,cItem,cClasseVlr,dData,cMoeda,cTpSald,,lInclui)
	EndIf                                                            
	BEGIN TRANSACTION
		// Nao ha registro para o dia -> cria!!
		If lInclui
			RecLock( "CTI", .t. )
			CTI->CTI_FILIAL 	:= xFilial()
			CTI->CTI_CLVL		:= cClasseVlr
			CTI->CTI_CONTA		:= cConta
			CTI->CTI_CUSTO		:= cCusto
			CTI->CTI_ITEM		:= cItem
			CTI->CTI_MOEDA		:= cMoeda
			CTI->CTI_DATA		:= dData
			CTI->CTI_TPSALD	:= cTpSald
			CTI->CTI_STATUS	:= "1"					// Periodo Aberto
			If !Empty(dDataLP)
				CTI->CTI_LP 	:= 'Z'						//Se for lancamento de zeramento
				CTI->CTI_DTLP	:= dDataLP			
			Else
				CTI->CTI_LP		:= "N"					// Flag indicando que ainda nao foi zerado
			EndIf

		Else
			RecLock( "CTI", .f. )
			//Se for chamado pela rotina de Atualizacao de Saldos Compostos, 
			// os movimentos devem ser zerados.
			If lZera      
				If cTipo == "1"
					CTI->CTI_DEBITO	:= 0
				ElseIf cTipo == "2"				
					CTI->CTI_CREDIT	:= 0			
				EndIf
			EndIf		
		Endif

		nAntDeb	:= aSldAntCTI[1]
		nAntCrd	:= aSldAntCTI[2]


		// Grava valores atuais
		If cTipo == "1"
			CTI->CTI_ANTDEB	:= nAntDeb	
			CTI->CTI_DEBITO	:= (CTI->CTI_DEBITO + nValor)
			CTI->CTI_ATUDEB	:= CTI->CTI_ANTDEB+CTI->CTI_DEBITO		
			CTI->CTI_ANTCRD	:= nAntCrd		
			CTI->CTI_ATUCRD	:= CTI->CTI_ANTCRD+CTI->CTI_CREDIT
		ElseIf cTipo == "2"                                   
			CTI->CTI_ANTCRD	:= nAntCrd	
			CTI->CTI_CREDIT	:= (CTI->CTI_CREDIT + nValor)
			CTI->CTI_ATUCRD	:= CTI->CTI_ANTCRD+CTI->CTI_CREDIT		
			CTI->CTI_ANTDEB	:= nAntDeb		
			CTI->CTI_ATUDEB	:= CTI->CTI_ANTDEB+CTI->CTI_DEBITO		
		EndIf	
		//Atualiza flag de saldo basico.	
		#IFDEF TOP
		CTI->CTI_SLBASE	:= "S"
		#ENDIF	
		MsUnlock()
	END TRANSACTION
	//Chama funcao que grava o saldo anterior e o saldo atual
	GRVSLDCTI(cTipo,cConta,cCusto,cItem,cClasseVlr,cMoeda,cTpSald,dData,nValor,nAntDeb,nAntCrd,lReproc,lAtSldBase,,lZera,"+")
	RestArea(aSaveArea)

Return

/*/
����������������������������������������������������������������������������?
�������������������������������������������������������������������������Ŀ�?
���Fun��o    �Ct211AtSX5?Autor ?Simone Mie Sato       ?Data ?11.01.02 ��?
�������������������������������������������������������������������������Ĵ�?
���Descri��o �Atualizo a tabela do SX5.                                   ��?
�������������������������������������������������������������������������Ĵ�?
���Sintaxe   �Ct211AtSX5(dDataCa)                                         ��?
�������������������������������������������������������������������������Ĵ�?
��?Uso      �Ct211AtSX5()                                                ��?
��������������������������������������������������������������������������ٱ?
����������������������������������������������������������������������������?
����������������������������������������������������������������������������?
/*/
Static FUNCTION Ct211AtSx5(dDataCa,cMoeda,cTpSaldo)

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

	If !MsSeek(xFilial()+'ZC'+cChave)
		/*
		Reclock("SX5",.T.)
		SX5->X5_FILIAL := xFilial()
		SX5->X5_TABELA	:= 'ZC'
		SX5->X5_CHAVE	:= cChave
		&(cCampo)		:= Dtos(dDataCa)+cMoeda+cTpSaldo+cChar
		MsUnlock()
		*/
		cTexto := Dtos(dDataCa)+cMoeda+cTpSaldo+cChar
		FwPutSX5(/*cFlavour*/, "ZC", cChave, cTexto, cTexto, cTexto, /*cTextoAlt*/)	
	Else
		While !Eof() .And. SX5->X5_FILIAL == xFilial() .And. SX5->X5_TABELA = 'ZC' .And. Subs(SX5->X5_CHAVE,1,4) == cChave

			If Subs(&(cCampo),1,8) == Dtos(dDataCa)
				If Subs(&(cCampo),9,2) == cMoeda .And. Subs(&(cCampo),11,1) = cTpSaldo .And. Subs(&(cCampo),12,1) == cChar
					lExiste	:= .T.
				EndIf
			EndIf

			If !lExiste
				/*
				Reclock("SX5",.T.)
				SX5->X5_FILIAL 	:= xFilial()
				SX5->X5_TABELA	:= 'ZC'
				SX5->X5_CHAVE	:= cChave
				&(cCampo)		:= Dtos(dDataCa)+cMoeda+cTpSaldo+cChar
				MsUnlock()
				*/
				cTexto := Dtos(dDataCa)+cMoeda+cTpSaldo+cChar
				FwPutSX5(/*cFlavour*/, "ZC", cChave, cTexto, cTexto, cTexto, /*cTextoAlt*/)
			EndIf

			dbSkip()
		End
	EndIf

	RestArea(aSaveArea)

Return
