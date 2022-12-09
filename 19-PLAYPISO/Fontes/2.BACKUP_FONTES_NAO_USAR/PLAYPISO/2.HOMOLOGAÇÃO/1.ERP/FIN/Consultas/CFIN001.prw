#DEFINE REC_NAO_CONCILIADO 1                                 
#DEFINE REC_CONCILIADO		2
#DEFINE PAG_NAO_CONCILIADO 3
#DEFINE PAG_CONCILIADO		4
#include "PROTHEUS.CH"
#include "rwmake.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFIN001   ºAutor  ³Alexandre Sousa     º Data ³  05/07/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Fluxo de caixa por natureza, permitindo a exportacao para   º±±
±±º          ³o excel.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico clientes ACTUAL TREND - www.actualtrend.com.br   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºMauro     ³Fabio solicitou que o periodo fosse anual e, não mais mensalº±±
±±º05/02/2013³                                                            º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CFIN001()

	Local oProcess

	Private cVar1 := 90
	Private cVar2 := 90
	Private cVar3 := 10
	Private cVar4 := 10 
	Private lCheck1 := .T.
	Private lCheck2 := .T.
	Private lCheck3 := .T.
	Private lCheck4 := .F.
	Private aLista6 := {}

	Private aHeader		:= {}
	Private aCOLS		:= {}
	Private aObjects	:= {}
	Private aPosObj		:= {}
	Private aSize		:= MsAdvSize()
	Private cPerg		:= "CFIN000001"
	Private n			:= 1
	Private a_Header	:={}
	Private a_dados		:= {}
	Private a_xml		:= {}
	Private omultiline	:= Nil
	Private dData01		:= dDataBase
	Private a_nats		:= {}
	
	Aadd( aObjects, { cVar1, cVar2	, lCheck1, lCheck2 })
	Aadd( aObjects, { cVar3, cVar4	, lCheck3, lCheck4 })
	
	aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
	aPosObj := MsObjSize(aInfo, aObjects)

//	Valid2Perg()
	
//	If !Pergunte(cPerg, .T.)
//		Return
//	EndIf

//	If !SelBancos()
//		Return
//	EndIf

	aStringBanco	:= RetStringBanco(aLista6, 1)
	cStringBanco	:= aStringBanco[1]
	cStringAgencia	:= aStringBanco[2]
	cStringConta	:= aStringBanco[3]

	cPerg		:= "CFIN000001"
	Pergunte(cPerg, .F.)
	
	RegToMemory("SZZ", .F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montando aHeader                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX3")
	dbSetOrder(2)
	SX3->(dbSeek("ED_DESCRIC"))
	AADD(aHeader,{ "Grupo"  , x3_campo   ,""   ,40      , 0,""	,"","C","", "V"} )

	Aadd(a_Header,{"DESCGRP"	,"C",60,0})
	Aadd(a_Header,{"NATUREZA"	,"C",35,0})

	SX3->(dbSeek("E1_VALOR"))
	d_dataini	:= StoD(SubStr(DtoS(ddatabase), 1, 6)+"01")
	d_datafim	:= somames(ddatabase)
	d_dtatu		:= d_dataini

//	If MV_PAR02 = "1"
		d_datafim	:= somames(ddatabase)
//	ElseIf MV_PAR02 = "2"
//		d_datafim	:= somames(ddatabase)
//		d_datafim	:= somames(d_datafim+1)
//	Else
//		d_datafim	:= somames(ddatabase)
//		d_datafim	:= somames(d_datafim+1)
//		d_datafim	:= somames(d_datafim+1)
//	EndIf

	a_dcab := {}
	n_cont := 1

	oProcessx := MsNewProcess():New({|lEnd| BusView(oProcess)},"Demonstrativo de Resultados - LISONDA","Extraindo dados ... ",.F.)
	oProcessx:Activate()

	n_cont := 1
	For n_x := 1 to len(a_dcab)
		Aadd(a_Header,{DtoC(a_dcab[n_x]),"N",14,2})
		//AADD(aHeader,{ dtoc(a_dcab[n_x]), "VALOR"+STRZERO(n_cont, 2), "@E 999,999,999,999.99",18,2,""	,"", "N", "", ""} )
		//substituida linha acma pela linha abaixo  [Mauro Nagata, Actual Trend, 20160223]
		AADD(aHeader,{ dtoc(a_dcab[n_x]), "VALOR"+STRZERO(n_cont, 3), "@E 999,999,999,999.99",18,2,""	,"", "N", "", ""} )
		d_dtatu++
		n_cont++
	Next

/*	While d_dtatu <= d_datafim
		Aadd(a_Header,{DtoC(d_dtatu),"N",14,2})
		AADD(aHeader,{ dtoc(d_dtatu), "VALOR"+STRZERO(n_cont, 2), "@E 999,999,999,999.99",18,2,""	,"", "N", "", ""} )
		d_dtatu++
		n_cont++
	EndDo*/
	Aadd(a_Header,{"TOTAL","N",14,2})
	AADD(aHeader,{ "TOTAL"    , "TOTAL", "@E 999,999,999.99",14,2,""	,"", "N", "", ""} )
	AADD(aHeader,{ "NATUR"    , "NATUR", "@!",10,0,""	,"", "C", "", ""} )
	
//	fCabecxml()

	oProcess := MsNewProcess():New({|lEnd| CriaAcols(oProcess)},"Demonstrativo de Resultados - LISONDA","Preparando Roteiro ... ",.F.)

	oProcess:Activate()

	cCadastro := OemToAnsi(" ** Demonstrativo de Resultados ** ")

	@ aSize[7],0 to aSize[6],aSize[5] DIALOG oDlg TITLE cCadastro

	@ aPosObj[1,1],aPosObj[1,2] TO aPosObj[1,3],aPosObj[1,4] MULTILINE object omultiline //FREEZE 1
	omultiline:nfreeze := 1
	omultiline:obrowse:nfreeze:=1 // congela a primeira coluna
	omultiline:OBROWSE:BLDBLCLICK := {|x| mostraItens(omultiline:OBROWSE:NAT)}

	@ aPosObj[2,1],aPosObj[2,4]-65 BMPBUTTON TYPE 13 ACTION If(msgYesNo("Deseja exportar para o Excel?"), Exporta(a_Header, a_dados),)
	@ aPosObj[2,1],aPosObj[2,4]-30 BMPBUTTON TYPE 02 ACTION Close(oDlg)
	
	ACTIVATE DIALOG oDlg CENTERED

	aHeadEscala := AClone(aHeader)
	aCOLSEscala := AClone(aCOLS)

Return
Static Function BusView(oObj)

//	oObj:IncRegua1("Atualizando query... ")


	c_Query := " select * from FLUXOCAIXA_0308X "

 	If Select("QRV") > 0
		DbSelectArea("QRV")
		DbCloseArea()
	EndIf
	TcQuery c_Query New Alias "QRV"

	TCSetField("QRV", "DT_MOV"	, "D")

	n_cont := 0
	a_dcab := {}
	While QRV->(!EOF())
		If ascan(a_dcab, QRV->DT_MOV) <= 0
			Aadd(a_dcab,QRV->DT_MOV)
		EndIf
		
		n_cont++
		QRV->(DbSkip())
	EndDo

	asort(a_dcab)



Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CriaAcols ºAutor  ³Alexandre Sousa     º Data ³  11/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Carrega os dados da consulta no array.                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaAcols(oObj)
	
	Local c_Query	:= ''
	Local c_EOF		:= chr(13)
	Local n_ped		:= Ascan(aHeader, {|x| AllTrim(x[2]) == "ZZ_PEDIDO"})
	Local n_Itpv	:= Ascan(aHeader, {|x| AllTrim(x[2]) == "ZZ_ITEMPV"})
	
	Local n_posDes  := 0
	Local n_posRec  := 0

	Private n_tr1 	:= 10
	Private n_r1at	:= 0

	DbSelectArea("PCV")
	DbSetOrder(1)
	DbGotop()
	
	d_data := StoD(SubStr(DtoS(dDataBase),1,6)+"01")

	d_dataini	:= StoD(SubStr(DtoS(ddatabase), 1, 6)+"01")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Carrega a primeira regua de processamento.    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oObj:SetRegua1(n_tr1)
	n_r1at := 1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Carrega a movimentacao bancaria               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//	a_tmp := U_RTMP001(cStringBanco,cStringAgencia,cStringConta, d_dataini, ddatabase, oObj)

	nSaldoBco := 0 //a_tmp[1,3]

//	Aadd(aCols, Array(len(aHeader)+2))
//	For i := 2 to len(aHeader)
//		aCols[len(aCols), i] := 0
//	Next
//	aCols[len(aCols), 1] := "-SALDO INICIAL"
//	aCols[len(aCols), 2] := nSaldoBco
//	aCols[len(aCols), len(aHeader)] := ""
//	aCols[len(aCols), len(aHeader)+1] := ''
//	aCols[len(aCols), len(aHeader)+2] := .F.

//	Aadd(a_dados, {"-SALDO INICIAL", '',  nSaldoBco, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0,0,0})
    
	n_r1at++
	oObj:IncRegua1("Montando estrutura de naturezas.... passo "+Strzero(n_r1at,2)+" de "+StrZero(n_tr1,2))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Carrega a estrutura de naturezas              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FT070Monta() 

	n_r1at++
	oObj:IncRegua1("Organizando estrutura de naturezas.... passo "+Strzero(n_r1at,2)+" de "+StrZero(n_tr1,2))

	oObj:SetRegua2(len(a_nats))
	For n_x := 1 to len(a_nats)
		Aadd(aCols, Array(len(aHeader)+2))
		aCols[len(aCols), 1] := a_nats[n_x, 1]
		For i := 2 to len(aHeader)
			aCols[len(aCols), i] := 0
		Next
		aCols[len(aCols), len(aHeader)] := Iif(a_nats[n_x, 2] == nil, '', a_nats[n_x, 2])
		aCols[len(aCols), len(aHeader)+1] := a_nats[n_x, 4]
		aCols[len(aCols), len(aHeader)+2] := .F.
                                                        
        //Aadd(a_dados, {a_nats[n_x, 1], a_nats[n_x, 2], 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0, 0, 0, 0,0,0})
        //substituida a linha acima pela abaixo [Mauro Nagata, Actual Trend, 05/02/2013]
	    Aadd(a_dados, {a_nats[n_x, 1], a_nats[n_x, 2], 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0	, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
	   	oObj:IncRegua2("Processando ....")
	    
	Next
	

	DbSelectArea('QRV')
	QRV->(DbGotop())

	While QRV->(!EOF())
	
		n_posacol := Ascan(aCols	, {|x| x[len(aHeader)] == QRV->COD_NAT})
		n_posahed := Ascan(aHeader	, {|x| AllTrim(x[1]) == DtoC(QRV->DT_MOV)})
		
		If n_posacol > 0 .and. n_posahed > 0
			aCols[n_posacol, n_posahed] += QRV->VLR_OBRA
		EndIf
	
		QRV->(DbSkip())
	EndDo


		
	n_r1at++
	oObj:IncRegua1("Totalizando grugpos .... passo "+Strzero(n_r1at,2)+" de "+StrZero(n_tr1,2))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Totaliza os grupos.                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	a_postot := {}	
	a_grp := {}
	n_posgrp := 1
	n_inibus := 1
	oObj:SetRegua2(len(aCols))
	For n_x := 1 to len(aCols)
		n_posgrp := 1
		n_inibus := 1
		While n_posgrp > 0
			n_posgrp := Ascan(a_grp, SubStr(AllTrim(aCols[n_x, 1]),n_inibus,6))
			If !Empty(aCols[n_x][len(aHeader)]) // "-" $ SubStr(AllTrim(aCols[n_x, 1]),n_inibus,10) .and. n_inibus > 1
				Exit
			EndIf
			If n_posgrp = 0
				If AllTrim(aCols[n_x, len(aHeader)+1]) <> ''
					Aadd(a_postot, {n_x, aCols[n_x, len(aHeader)+1]})
				EndIf
				Aadd(a_grp, SubStr(AllTrim(aCols[n_x, 1]),n_inibus,6))
				Exit
			Else
				n_inibus := Iif( n_inibus == 1, 7, n_inibus+6)
			EndIf
		EndDo

		If Empty(aCols[n_x][len(aHeader)]) //!("-" $ SubStr(AllTrim(aCols[n_x, 1]),n_inibus,10) .and. n_inibus > 1)
			For n_y := n_x+1 to len(aCols)
				If SubStr(AllTrim(aCols[n_x, 1]),n_inibus,6) == SubStr(AllTrim(aCols[n_y, 1]),n_inibus,6) .and. SubStr(AllTrim(aCols[n_y, 1]),n_inibus,6) <> 'SALDO' //.and. !("-" $ SubStr(AllTrim(aCols[n_y, 1]),n_inibus,10))
					For n_j := 2 to len(aHeader)-2
						aCols[n_x, n_j] += aCols[n_y, n_j]
					Next
				EndIf
			Next
		EndIf

		
		For n_n := 2 to len(aHeader) -2
			aCols[n_x, len(aHeader)-1] += aCols[n_x, n_n]
		Next
	   	oObj:IncRegua2("Processando ....")
	Next

	n_r1at++
	oObj:IncRegua1("Totalizando saldo final .... passo "+Strzero(n_r1at,2)+" de "+StrZero(n_tr1,2))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Totaliza o SALDO FINAL.                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	n_posini := Ascan(aCols, {|x| x[1] == "-SALDO INICIAL" })
	n_posfim := len(aCols)

/*	oObj:SetRegua2(len(aHeader)-1)
	For n_x := 2 to len(aHeader)-1
		n_sldatu := aCols[n_posini, n_x]
		For n_q := 1 to len(a_postot)
			If a_postot[n_q, 2] == "1"
				n_sldatu += aCols[a_postot[n_q, 1], n_x]
			ElseIf a_postot[n_q, 2] == "2"
				n_sldatu -= aCols[a_postot[n_q, 1], n_x]
			ElseIf a_postot[n_q, 2] == "3"
				aCols[a_postot[n_q, 1], n_x] := n_sldatu
			EndIf 
		Next

		If n_x < len(aHeader)-2
			aCols[n_posini, n_x+1] := aCols[n_posfim, n_x]
		EndIf
	   	oObj:IncRegua2("Processando ....")
	Next
  */
	ADel(aHeader, len(aHeader))
	Aeval(aCols, {|x| ADel(x, len(aHeader)+1)})
	Aeval(aCols, {|x| ADel(x, len(aHeader)+2)})
	Aeval(aCols, {|x| Asize(x, len(aHeader))})
	Asize(aHeader, len(aHeader)-1)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza array para o excel...                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	n_r1at++
	oObj:IncRegua1("Atualizando array excel .... passo "+Strzero(n_r1at,2)+" de "+StrZero(n_tr1,2))
	oObj:SetRegua2(len(aCols)+len(a_dados))

	For n_x := 1 to len(aCols)
		For n_y := 2 to len(aHeader)
			a_dados[n_x, n_y+1] := aCols[n_x, n_y]
		Next
	   	oObj:IncRegua2("Processando ....")
	Next

	fCabecxml()

	For n_x := 1 to len(a_dados)	
		If ('B3'$ a_dados[n_x, 1] .or. 'B4'$ a_dados[n_x, 1]) .and. !('B31'$ a_dados[n_x, 1] .or. 'B32'$ a_dados[n_x, 1] .or. 'B41'$ a_dados[n_x, 1] .or. 'B42'$ a_dados[n_x, 1])
			a_dados[n_x, 1] := Space(len(rtrim(a_dados[n_x, 1])) - len(alltrim(a_dados[n_x, 1]))) + AllTrim(SubStr(a_dados[n_x, 1], at('-', a_dados[n_x, 1])+1, len(a_dados[n_x, 1])))
		   	faddxml(a_dados[n_x], "s80")
		ElseIf 'B1 - Entradas'$ a_dados[n_x, 1] .or. 'B2 - Saidas' $ a_dados[n_x, 1]
			c_formula := '"='
			n_lsum := 0
			a_dados[n_x, 1] := Space(len(rtrim(a_dados[n_x, 1])) - len(alltrim(a_dados[n_x, 1]))) + AllTrim(SubStr(a_dados[n_x, 1], at('-', a_dados[n_x, 1])+1, len(a_dados[n_x, 1])))
			For n_y := n_x+1 to len(a_dados)
				n_lsum++
				If 'B1 - Entradas'$ a_dados[n_x, 1]
					If 'B1'$ a_dados[n_y, 1] 
						c_formula += "R["+strzero(n_lsum,4)+"]C+"
					EndIf
				Else
					If 'B2'$ a_dados[n_y, 1]
						c_formula += "R["+strzero(n_lsum,4)+"]C+"
					EndIf
				EndIf
			Next
			c_formula := substr(c_formula, 1, len(c_formula)-1)+'"'
		   	faddxml(a_dados[n_x], "s74", , c_formula)
		ElseIf 'B2'$ a_dados[n_x, 1] .or. 'B1'$ a_dados[n_x, 1] .or. 'NV22-B - Saldo do Dia' $ a_dados[n_x, 1]
			If 'NV22-B - Saldo do Dia' $ a_dados[n_x, 1]
				c_formula := '"='
				n_lsum := 1
				For n_y := n_x+1 to len(a_dados)
					If 'B1 - Entradas'$ a_dados[n_y, 1] .or. 'B2 - Saidas' $ a_dados[n_y, 1]
						c_formula += "R["+strzero(n_lsum,4)+"]C+"
					EndIf
					n_lsum++
				Next
				c_formula := substr(c_formula, 1, len(c_formula)-1)+'"'
			   	faddxml(a_dados[n_x], "s77", , c_formula)
			Else
				n_lsum := 0
				For n_y := n_x+1 to len(a_dados)
					If 'B1'$ a_dados[n_y, 1] .or. 'B2'$ a_dados[n_y, 1] .or. 'B3'$ a_dados[n_y, 1] .or. 'B4'$ a_dados[n_y, 1]
						exit
					EndIf
					n_lsum++
				Next
				a_dados[n_x, 1] := Space(len(rtrim(a_dados[n_x, 1])) - len(alltrim(a_dados[n_x, 1]))) + AllTrim(SubStr(a_dados[n_x, 1], at('-', a_dados[n_x, 1])+1, len(a_dados[n_x, 1])))
			   	faddxml(a_dados[n_x], "s77", n_lsum)
			 EndIf
		ElseIf SubStr(a_dados[n_x, 1], 1, 1) == 'T'
			a_dados[n_x, 1] := Space(len(rtrim(a_dados[n_x, 1])) - len(alltrim(a_dados[n_x, 1]))) + AllTrim(SubStr(a_dados[n_x, 1], at('-', a_dados[n_x, 1])+1, len(a_dados[n_x, 1])))
		   	faddxml(a_dados[n_x], "s74")
		Else
			a_dados[n_x, 1] := Space(len(rtrim(a_dados[n_x, 1])) - len(alltrim(a_dados[n_x, 1]))) + AllTrim(SubStr(a_dados[n_x, 1], at('-', a_dados[n_x, 1])+1, len(a_dados[n_x, 1])))
		   	faddxml(a_dados[n_x], "s71")
	   	EndIf
	   	oObj:IncRegua2("Processando ....")
	Next

	rdxml()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidPerg ºAutor  ³Alexandre Sousa     º Data ³  11/11/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Valida o grupo de perguntas.                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Valid2Perg()

	_sAlias := GetArea() 
	DbSelectArea("SX1")
	DbSetOrder(1)
	cPerg := PADR(cPerg,10)
	aRegs:={}
	AADD(aRegs,{cPerg,"01","Considerar    ?","","","mv_ch1","C",01,0,0,"C","","mv_par01","Previsto","","","","","Realizado","","","","","Ambos","","","","","","","","","","","","","","","",""})
	AADD(aRegs,{cPerg,"02","Dias do Fluxo ?","","","mv_ch2","C",01,0,0,"C","","mv_par02","30 dias","","","","","60 dias","","","","","90 dias","","","","","","","","","","","","","","","",""})

	For i:=1 To Len(aRegs)
		If !DbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For J:=1 to FCount()
				If J <= Len(aRegs[i])
					FieldPut(J,aRegs[i,j])
				Else
					Exit
				EndIf
			Next
			MsUnlock()
		EndIf
	Next
	RestArea(_sAlias)

Return 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SomaMes   ºAutor  ³Alexandre Martins   º Data ³  07/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna data do ultimo dia do mes, apartir da data informadaº±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SomaMes(d_data)

	Local c_mes := SubStr(DtoS(d_data) ,5,2)
	
	While SubStr(DtoS(d_data) ,5,2) == c_mes
		d_data := d_data + 1
	EndDo
	
	
	d_data := d_data-1
	
Return d_data




Static Function mostraItens(n_linha)
                                                              
	DbSelectArea("PCV")
	
    c_query := " select PCX_GRUPO, PCX_NATUR, PCX_DESC from PCV010 PCV "
    c_query += " inner join PCX010 as PCX on PCX_GRUPO = PCV_GRUPO and PCX.D_E_L_E_T_ <> '*' "
    c_query += " where  PCV_DESC = '"+aCols[n_linha, 1]+"' and PCV.D_E_L_E_T_ <> '*' "

	U_FGEN008(c_query , {{"Grupo", "Natureza", "Descriçao"}, {"PCX_GRUPO", "PCX_NATUR", "PCX_DESC"}}, "Naturezas do grupo")

Return



Static Function SelBancos()

Local cNomeArqSA6 := RetSqlName("SA6")

Private oOk := LoadBitmap(GetResources(),"LBOK")
Private oNo := LoadBitmap(GetResources(),"LBNO")
Private oListBox6
Private nOpc := 0


Aadd(aLista6,{.F.,"Todos"  ,"","","", ""})
Aadd(aLista6,{.F.,"Nenhum" ,"","","", ""})
Aadd(aLista6,{.F.,"Inverte","","","", ""})


If Select("TMP1") > 0
	DbSelectArea("TMP1")
	DbCloseArea()
EndIf

cQuery := "SELECT A6_FILIAL,A6_COD,A6_AGENCIA,A6_NUMCON,A6_NOME,A6_NREDUZ FROM " + cNomeArqSA6
cQuery += " WHERE D_E_L_E_T_ <> '*'"

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP1",.F.,.T.)

TMP1->(DbGoTop())
While TMP1->(!Eof())
	nPos := Ascan(aLista6,{|x|x[2]+x[3]+x[4] == TMP1->A6_COD + TMP1->A6_AGENCIA + TMP1->A6_NUMCON})
	If nPos == 0
		Aadd(aLista6,{.T.,TMP1->A6_COD,TMP1->A6_AGENCIA,TMP1->A6_NUMCON,TMP1->A6_NREDUZ, "N"})
	EndIf
	TMP1->(DbSkip())
EndDo

DbSelectArea("TMP1")
DbCloseArea()

aLista6 := Asort(aLista6,4,,{|x,y|x[2]+x[3]+x[4] < y[2]+y[3]+y[4]})

RFIN91RestPerg()


DEFINE MSDIALOG oDlg FROM 000,000 TO 320,525 TITLE "Informe os parametros - Fluxo de Caixa" PIXEL

@ 10,010 TO 141,253
@ 15,013 SAY "Bancos"
@ 25,013 LISTBOX oListBox6 VAR cLista6 FIELDS HEADER "","Banco","Agencia","Conta","Nome reduzido", "Aplicacao" SIZE 236,112 ;
           ON DBLCLICK (aLista6 := RFIN91Troca(oListBox6:nAt,aLista6, 6),oListBox6:Refresh()) OF oDlg PIXEL
oListBox6:SetArray(aLista6)
oListBox6:bLine := {||{If(aLista6[oListBox6:nAt,1],oOk,oNo),aLista6[oListBox6:nAt,2],aLista6[oListBox6:nAt,3], ;
                                                            aLista6[oListBox6:nAt,4],aLista6[oListBox6:nAt,5], aLista6[oListBox6:nAt,6]}}

DEFINE SBUTTON FROM 145,193 TYPE 1 ENABLE OF oDlg ACTION (nOpc := 1,oDlg:End())
DEFINE SBUTTON FROM 145,223 TYPE 2 ENABLE OF oDlg ACTION (nOpc := 0,oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED

If nOpc = 1

	DbSelectArea("SX1")
	DbSetOrder(1)
	aPerg := {}
	cPerg := "CFIN000001"

	Aadd(aPerg,{cPerg,"01","Bancos 1           ?","","","mv_cha","C",99,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPerg,{cPerg,"02","Bancos 2           ?","","","mv_chb","C",99,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPerg,{cPerg,"03","Bancos 3           ?","","","mv_chc","C",99,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	ValidPerg(aPerg,cPerg)
	
	Pergunte(cPerg,.F.)
	
	cAlias := Alias()
	aAreaAtu := GetArea()
	
	aAreaSX1 := SX1->(GetArea())

	// grupo de perguntas e respostas
	SX1->(DbSetOrder(1))		&& X1_GRUPO+X1_ORDEM
	
	cString := ''
	For nI := 4 to Len(aLista6)
		If (aLista6[nI][1])
			cString := cString + aLista6[nI][2] + "-" + aLista6[nI][3] + "-" + aLista6[nI][4] + "/"
		EndIf
	Next nI	
	
	SX1->(DbSeek(cPerg+"01"))
	RecLock("SX1",.F.)
	SX1->X1_CNT01 := Substr(cString,001,60)
	SX1->X1_CNT02 := Substr(cString,061,60)
	SX1->X1_CNT03 := Substr(cString,121,60)
	SX1->X1_CNT04 := Substr(cString,181,60)
	SX1->X1_CNT05 := Substr(cString,241,60)
	MsUnlock()
	
	SX1->(DbSeek(cPerg+"02"))
	RecLock("SX1",.F.)
	SX1->X1_CNT01 := Substr(cString,301,60)
	SX1->X1_CNT02 := Substr(cString,361,60)
	SX1->X1_CNT03 := Substr(cString,421,60)
	SX1->X1_CNT04 := Substr(cString,481,60)
	SX1->X1_CNT05 := Substr(cString,541,60)
	MsUnlock()
	
	SX1->(DbSeek(cPerg+"03"))
	RecLock("SX1",.F.)
	SX1->X1_CNT01 := Substr(cString,601,60)
	SX1->X1_CNT02 := Substr(cString,661,60)
	SX1->X1_CNT03 := Substr(cString,721,60)
	SX1->X1_CNT04 := Substr(cString,781,60)
	SX1->X1_CNT05 := Substr(cString,841,60)
	MsUnlock()


EndIf

Return Iif(nOpc=0, .F., .T.)

Static Function RFIN91Troca(nItem,aArray, nTipo)

Local nI
Local lExecuta

nTipo := Iif( nTipo = nil, 0, nTipo)

aArray[nItem,1] := !aArray[nItem,1]

lExecuta := aArray[nItem,1]

aArray[1,1] := .F.
aArray[2,1] := .F.
aArray[3,1] := .F.

If nItem == 1			&& Todos

	aArray[1,1] := .T.
	aArray[2,1] := .F.
	aArray[3,1] := .F.

	If lExecuta
		For nI := 4 to Len(aArray)
			aArray[nI,1] := .T.
		Next nI
	EndIf

ElseIf nItem == 2		&& Nenhum

	aArray[1,1] := .F.
	aArray[2,1] := .T.
	aArray[3,1] := .F.

	If lExecuta
		For nI := 4 to Len(aArray)
			aArray[nI,1] := .F.
		Next nI
	EndIf	

ElseIf nItem == 3		&& Inverte

	aArray[1,1] := .F.
	aArray[2,1] := .F.
	aArray[3,1] := .T.

	If lExecuta
		For nI := 4 to Len(aArray)
			aArray[nI,1] := !aArray[nI,1]
		Next nI
	EndIf

EndIf

Return(aArray)

Static Function RFIN91RestPerg()

	Local aAreaSX1 := SX1->(GetArea())
	Local nPos,lOk
	Local cCNT01,cCNT02,cCNT03,cCNT04,cCNT05,cCNT06,cCNT07,cCNT08,cCNT09,cCNT10,cCNT11,cCNT12,cCNT13,cCNT14,cCNT15

	// grupo de perguntas e respostas
	SX1->(DbSetOrder(1))		&& X1_GRUPO+X1_ORDEM
	cPerg := "CFIN000001"
	
	SX1->(DbSeek(cPerg+"01"))
	cCNT01 := SX1->X1_CNT01
	cCNT02 := SX1->X1_CNT02
	cCNT03 := SX1->X1_CNT03
	cCNT04 := SX1->X1_CNT04
	cCNT05 := SX1->X1_CNT05
	
	SX1->(DbSeek(cPerg+"02"))
	cCNT06 := SX1->X1_CNT01
	cCNT07 := SX1->X1_CNT02
	cCNT08 := SX1->X1_CNT03
	cCNT09 := SX1->X1_CNT04
	cCNT10 := SX1->X1_CNT05
	
	SX1->(DbSeek(cPerg+"03"))
	cCNT11 := SX1->X1_CNT01
	cCNT12 := SX1->X1_CNT02
	cCNT13 := SX1->X1_CNT03
	cCNT14 := SX1->X1_CNT04
	cCNT15 := SX1->X1_CNT05

	aLista6 := RFIN91StrArray(aLista6,cCNT01 + cCNT02 + cCNT03 + cCNT04 + cCNT05 + ;
	                                  cCNT06 + cCNT07 + cCNT08 + cCNT09 + cCNT10 + ;
												 cCNT11 + cCNT12 + cCNT13 + cCNT14 + cCNT15,6)


SX1->(RestArea(aAreaSX1))

Return
//-------------------------------------------------------------------------------------------------------------------------------
Static Function RFIN91StrArray(aLista,cString,nLista)

Local nI
Local cCodigo

For nI := 4 to Len(aLista)
	
   
	   cCodigo := aLista[nI][2] + "-" + aLista[nI][3] + "-" + aLista[nI][4]
   	aLista[nI][1] := cCodigo $ cString
   	
	
Next nI

Return(aLista)

Static Function RetStringBanco(aLista, n_tipo)

Local cStringBanco 	:= ""
Local cStringAgencia := ""
Local cStringConta 	:= ""

Local nI

If n_tipo = 1
	For nI := 4 to Len(aLista)
	
		If aLista[nI][1] .and. aLista[nI][6] = 'N'
			cStringBanco 	+= If(Empty(cStringBanco),"'" + aLista[nI][2] + "'","," + "'" + aLista[nI][2] + "'")
			cStringAgencia += If(Empty(cStringAgencia),"'" + aLista[nI][3] + "'","," + "'" + aLista[nI][3] + "'")
			cStringConta 	+= If(Empty(cStringConta),"'" + aLista[nI][4] + "'","," + "'" + aLista[nI][4] + "'")
		EndIf
		
	Next nI
Else
	For nI := 4 to Len(aLista)
	
		If aLista[nI][6] = 'S'
			cStringBanco 	+= If(Empty(cStringBanco),"'" + aLista[nI][2] + "'","," + "'" + aLista[nI][2] + "'")
			cStringAgencia += If(Empty(cStringAgencia),"'" + aLista[nI][3] + "'","," + "'" + aLista[nI][3] + "'")
			cStringConta 	+= If(Empty(cStringConta),"'" + aLista[nI][4] + "'","," + "'" + aLista[nI][4] + "'")
		EndIf
		
	Next nI
EndIf

Return({cStringBanco,cStringAgencia,cStringConta})

//-------------------------------------------------------------------------------------------------------------------------------
Static Function RetSaldoBco(cCodEmp,cCodFil,cStringBanco,cStringAgencia,cStringConta, d_data)

Local nTotReg
Local cFil,cBanco,cAgencia,cConta
Local dDtSalAt := Ctod(Space(8))
Local nSaldoBco := 0
Local nSaldoAtu := 0

If Empty(cCodFil)
	cCodFil := "'" + Space(2) + "'"
EndIf

If Empty(cStringBanco)
	cStringBanco := "'" + Space(3) + "'"
EndIf

If Empty(cStringAgencia)
	cStringAgencia := "'" + Space(5) + "'"
EndIf

If Empty(cStringConta)
	cStringConta := "'" + Space(10) + "'"
EndIf

cQuery := "SELECT SE8.E8_FILIAL E8_FILIAL,SE8.E8_BANCO E8_BANCO,SE8.E8_AGENCIA E8_AGENCIA,SE8.E8_CONTA E8_CONTA, "
cQuery += "       SE8.E8_DTSALAT E8_DTSALAT,SE8.E8_SALATUA E8_SALATUA "
cQuery += " FROM " + RetSqlName("SE8") + " SE8 "
cQuery += " WHERE SE8.E8_FILIAL IN (" + cCodFil + ")"
cQuery += "       AND SE8.E8_BANCO IN (" + cStringBanco + ")"
cQuery += "       AND SE8.E8_AGENCIA IN (" + cStringAgencia + ")"
cQuery += "       AND SE8.E8_CONTA IN (" + cStringConta + ")"
cQuery += "       AND SE8.E8_DTSALAT <= '" + Dtos(d_data) + "'"
cQuery += "       AND SE8.D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY E8_FILIAL,E8_BANCO,E8_AGENCIA,E8_CONTA,E8_DTSALAT"

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP1",.F.,.T.)
nTotReg := TMP1->(RecCount())

ProcRegua(nTotReg)

TMP1->(DbGoTop())
While TMP1->(!Eof())

	cFil 		:= TMP1->E8_FILIAL
	cBanco 	:= TMP1->E8_BANCO
	cAgencia	:= TMP1->E8_AGENCIA
	cConta	:= TMP1->E8_CONTA
	dDtSalAt := Ctod(Space(8))
	
	While TMP1->E8_FILIAL == cFil .And. TMP1->E8_BANCO == cBanco .And. TMP1->E8_AGENCIA == cAgencia .And. ;
	      TMP1->E8_CONTA == cConta .And. Stod(TMP1->E8_DTSALAT) >= dDtSalAt .And. TMP1->(!Eof())
	      
		dDtSalAt := Stod(TMP1->E8_DTSALAT)
		nSaldoBco := TMP1->E8_SALATUA
		TMP1->(DbSkip())
		
		IncProc("Processando saldos bancarios - empresa: " + cCodEmp + "...")
		
	EndDo
	
	nSaldoAtu += nSaldoBco
	
EndDo

DbSelectArea("TMP1")
DbCloseArea()

Return(nSaldoAtu)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFIN013   ºAutor  ³Alexandre Sousa     º Data ³  07/13/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Fonte FINR470 padrao extrato bancario, alterado para        º±±
±±º          ³exportar os dados para o excel.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico cliente DIGIPLAN - www.digiplan.com.br           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RTMP001(cStringBanco,cStringAgencia,cStringConta, d_1, d_2, oObj)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	LOCAL cString:="SE5"

	Private d_dtde	:= d_1 //CtoD("25/04/08")
	Private d_dtate	:= d_2 //CtoD("25/04/08")

	Private cBanco		:= cStringBanco		//"'237'"
	Private cAgencia	:= cStringAgencia	//"'3395'"
	Private cConta		:= cStringConta		//"'0096170-1'"
	
	Private a_dados		:= {}
	Private a_Header	:= {}

	Aadd(a_Header,{"NATUREZA"	,"C",10,0})
	Aadd(a_Header,{"DATAMOV"	,"D",08,0})
	Aadd(a_Header,{"VALOR"		,"N",14,2})

	Fa470Imp(oObj)

Return a_dados

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FA470IMP ³ Autor ³ Wagner Xavier 		³ Data ³ 20.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Extrato Banc rio. 										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA470Imp(oObj)

LOCAL CbCont,CbTxt
//LOCAL tamanho:="M"
//LOCAL cBanco,cNomeBanco,cAgencia,cConta
LOCAL nSaldoAtu:=0,nTipo,nSaldoIni:=0
LOCAL cDOC
LOCAL cFil	  :=""
LOCAL cChave
LOCAL cIndex
LOCAL aRecon := {}
Local nTxMoeda := 1
Local nValor := 0
Local aStru 	:= SE5->(dbStruct())
#IFDEF TOP
	Local ni
#ENDIF	
LOCAL nSalIniStr := 0
LOCAL nSalIniCip := 0
LOCAL nSalIniComp := 0
LOCAL nSalStr := 0
LOCAL nSalCip := 0    
LOCAL nSalComp := 0
LOCAL lSpbInUse := SpbInUse()
Local cFilterUser

AAdd( aRecon, {0,0,0,0} )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis privadas exclusivas deste programa                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCondWhile, lAllFil :=.F.
Private nMoedaBco	:=	1
Private nMoeda		:= GetMv("MV_CENT")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt 	:= SPACE(10)
cbcont	:= 0
li 		:= 80
m_pag 	:= 1


If cPaisLoc	#	"BRA"
	nMoedaBco := 1 //Max(A6_MOEDA,1)
Endif

oObj:IncRegua1("Processando Saldo Bancario.... passo "+Strzero(n_r1at,2)+" de "+StrZero(n_tr1,2))

nSaldoAtu:= SldBcoDt('','',cBanco,cAgencia,cConta, d_dtde)

nSaldoIni:=nSaldoAtu

n_r1at++
oObj:IncRegua1("Processando Saldo Bancario.... passo "+Strzero(n_r1at,2)+" de "+StrZero(n_tr1,2))

If lSpbInUse
	nSalIniStr := 0
	nSalIniCip := 0
	nSalIniComp := 0
Endif		

	Aadd(a_dados, {"", Stod("") , nSaldoAtu, ''})


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra o arquivo por tipo e vencimento							  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(xFilial( "SA6")) .and. !Empty(xFilial("SE5"))
	cChave	:= "DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA"
	lAllFil:= .T.
Else
	cChave  := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA"
EndIf

#IFNDEF TOP	
	dbSelectArea("SE5")
	dbSetOrder(1)
	cIndex	:= CriaTrab(nil,.f.)
	dbSelectArea("SE5")
	IndRegua("SE5",cIndex,cChave,,Nil,OemToAnsi("Selecionando Registros..."))  //
	nIndex	:= RetIndex("SE5")
	dbSetIndex(cIndex+OrdBagExt())
	dbSetOrder(nIndex+1)
	cFil:= Iif(lAllFil,"",xFilial("SE5"))
	dbSeek(cFil+DtoS(d_dtde),.T.)
#ELSE
	If TcSrvType() == "AS/400"
		dbSelectArea("SE5")
		dbSetOrder(1)
		cIndex	:= CriaTrab(nil,.f.)
		dbSelectArea("SE5")
		IndRegua("SE5",cIndex,cChave,,Nil,OemToAnsi("Selecionando Registros..."))  //
		nIndex	:= RetIndex("SE5")
		dbSetOrder(nIndex+1)
		cFil:= Iif(lAllFil,"",xFilial("SE5"))
		dbSeek(cFil+DtoS(d_dtde),.T.)
	EndIf	
#ENDIF


#IFNDEF TOP
	If  lAllFil
		cCondWhile := "!Eof() .And. E5_DTDISPO <= d_dtate"
	Else
		cCondWhile := "!Eof() .And. E5_FILIAL == xFilial('SE5') .And. E5_DTDISPO <= d_dtate"
	EndIf
#ELSE
	If TcSrvType() != "AS/400"
		DbSelectArea("SE5")
		DbSetOrder(1)
		cCondWhile := " !Eof() "
		If	lAllFil
			cChave  := "DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ"
		Else
			cChave  := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ"
		EndIf
		cOrder := SqlOrder(cChave)
		cQuery := "SELECT * "
		cQuery += " FROM " + RetSqlName("SE5") + " WHERE "
		If !lAllFil
			cQuery += "	E5_FILIAL = '" + xFilial("SE5") + "'" + " AND "
		EndIf	
		cQuery += " D_E_L_E_T_ <> '*' "
		cQuery += " AND E5_DTDISPO >=  '"     + DTOS(d_dtde) + "'"
		If lSpbInuse
			cQuery += " AND ((E5_DTDISPO <=  '"+ DTOS(d_dtate) + "') OR "
			cQuery += " (E5_DTDISPO >=  '"     + DTOS(d_dtate) + "' AND "
		   cQuery += " (E5_DATA >=  '"  		  + DTOS(d_dtde) + "' AND " 
			cQuery += "  E5_DATA <=  '"     	  + DTOS(d_dtate) + "')))"			
		Else			
			cQuery += " AND E5_DTDISPO <=  '"     + DTOS(d_dtate) + "'"
		Endif
		cQuery += " AND E5_TIPODOC NOT IN ('DC','JR','MT','CM','D2','J2','M2','C2','V2','CP','TL','BA') "
		cQuery += " AND E5_BANCO    IN (" + cBanco    + ")"
		cQuery += " AND E5_AGENCIA  IN (" + cAgencia + ")"
		cQuery += " AND E5_CONTA    IN (" + cConta   + ")"
		cQuery += " AND E5_SITUACA <> 'C' "
		cQuery += " AND E5_VALOR <> 0 "
		cQuery += " AND E5_NUMCHEQ NOT LIKE '%*' "
		cQuery += " AND E5_VENCTO <= '" + DTOS(d_dtate)  + "'" 
		cQuery += " AND E5_VENCTO <= E5_DATA " 

		cQuery += " ORDER BY " + cOrder
	
		cQuery := ChangeQuery(cQuery)

		dbSelectAre("SE5")
		dbCloseArea()

		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE5', .T., .T.)
	
		For ni := 1 to Len(aStru)
			If aStru[ni,2] != 'C'
				TCSetField('SE5', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
			Endif
		Next
	Else		// Se TOP-AS400
		If lAllFil
			cCondWhile := "!Eof() .And. E5_DTDISPO <= d_dtate"
		Else
			cCondWhile := "!Eof() .And. E5_FILIAL == xFilial('SE5') .And. E5_DTDISPO <= d_dtate"
		EndIf
	EndIf
#ENDIF


	memowrite("C:\CFIN001a.sql", cQuery)
 	

// Monta arquivo de trabalho (apenas quando usa SPB)
If lSpbInUse
	dbSelectArea("SE5")
	cNomeArq:= CriaTrab("",.F.)
	cIndex  := cNomeArq
	AAdd( aStru, {"E5_BLOQ"	,"C", 01, 0} )
	dbCreate( cNomeArq, aStru )
	USE &cNomeArq	Alias Trb  NEW
	dbSelectArea("TRB")
//	IndRegua("TRB",cIndex,cChave,,,"Selecionando Registros...") //
	dbSetIndex( cNomeArq +OrdBagExt())
	Fr470SPB(cChave, aStru)
Endif

//Filtro do usuario
cFilterUser:=''//aReturn[7]

While &(cCondWhile)

//	IncRegua()
	
	#IFNDEF TOP
		If !Fr470Skip()
			dbSkip()
			Loop
		EndIf	
	#ELSE
		If TcSrvType() == "AS/400"
			If !Fr470Skip()
				dbSkip()
				Loop
			EndIf	
		EndIf
	#ENDIF		

	IF E5_MOEDA $ "C1/C2/C3/C4/C5/CH" .and. Empty(E5_NUMCHEQ) .and. !(E5_TIPODOC $ "TR#TE")
		dbSkip()
		Loop
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Na transferencia somente considera nestes numerarios 		  ³
	//³ No Fina100 ‚ tratado desta forma.                    		  ³
	//³ As transferencias TR de titulos p/ Desconto/Cau‡Æo (FINA060) ³
	//³ nÆo sofrem mesmo tratamento dos TR bancarias do FINA100      ³
   //³ Aclaracao : Foi incluido o tipo $ para os movimentos en di-- ³
   //³ nheiro em QUALQUER moeda, pois o R$ nao e representativo     ³
   //³ fora do BRASIL. Bruno 07/12/2000 Paraguai                    ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If E5_TIPODOC $ "TR/TE" .and. Empty(E5_NUMERO)
      If !(E5_MOEDA $ "R$/DO/TB/TC/CH"+IIf(cPaisLoc=="BRA","","/$ "))
			dbSkip()
			Loop
		Endif
	Endif
	If E5_TIPODOC $ "TR/TE" .and. (Substr(E5_NUMCHEQ,1,1)=="*" ;
		.or. Substr(E5_DOCUMEN,1,1) == "*" )
		dbSkip()
		Loop
	Endif

	If E5_MOEDA == "CH" .and. IsCaixaLoja(E5_BANCO)		// Sangria
		dbSkip()
		Loop
	Endif

	If !Empty( E5_MOTBX )
		If !MovBcoBx( E5_MOTBX )
			dbSkip( )
			Loop
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Considera filtro do usuario                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(cFilterUser).and.!(&cFilterUser)
		dbSkip()
		Loop
	Endif

	
	If lSpbInUse	
		dbSelectArea("TRB")
	Else
		dbSelectArea("SE5")
	Endif

	Aadd(a_dados, {E5_NATUREZ, E5_DTDISPO, 0, ''})
//	@li, 0 PSAY E5_DTDISPO
//	@li,12 PSAY SUBSTR(E5_HISTOR,1,30)
	
	cDoc := E5_NUMCHEQ
	
	IF Empty( cDoc )
		cDoc := E5_DOCUMEN
	Endif
	
	IF Len(Alltrim(E5_DOCUMEN)) + Len(Alltrim(E5_NUMCHEQ)) <= 19
		cDoc := Alltrim(E5_DOCUMEN) +if(!empty(Alltrim(E5_DOCUMEN)),"-"," ") + Alltrim(E5_NUMCHEQ )
	Endif
	
	If Substr( cDoc ,1, 1 ) == "*"
		dbSkip( )
		Loop
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³VerIfica se foi utilizada taxa contratada para moeda > 1          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SE5->(FieldPos('E5_TXMOEDA')) > 0
		nTxMoedBc := SE5->E5_TXMOEDA	
	Else  	
		nTxMoedBc := 0
	Endif

	nValor := Round(xMoeda(E5_VALOR,nMoedaBco,1,E5_DTDISPO,nMoeda+1,nTxMoedBc),nMoeda)

	IF E5_RECPAG="R"
	
		If SubStr(E5_NATUREZ,1,1) == '6'
			a_dados[len(a_dados), 3] := -1*nValor
		Else
			a_dados[len(a_dados), 3] := nValor
		EndIf
		a_dados[len(a_dados), 4] := E5_TIPODOC
		
	Else
		If SubStr(E5_NATUREZ,1,1) == '5'
			a_dados[len(a_dados), 3] := -1 * nValor
		Else
			a_dados[len(a_dados), 3] := nValor
		EndIf
		a_dados[len(a_dados), 4] := E5_TIPODOC
	Endif

	If lSpbInUse	
		dbSelectArea("TRB")
	Else
		dbSelectArea("SE5")
	Endif
	dbSkip()
EndDO

#IFNDEF TOP
	dbSelectArea("SE5")
	RetIndex( "SE5" )
	If !Empty(cIndex)
		FErase (cIndex+OrdBagExt())
	Endif
	dbSetOrder(1)
#ELSE
   If TcSrvType() != "AS/400"
		dbSelectArea("SE5")
		dbCloseArea()
		ChKFile("SE5")
   	dbSelectArea("SE5")
		dbSetOrder(1)
	Else
		dbSelectArea("SE5")
		RetIndex( "SE5" )
		If !Empty(cIndex)
			FErase (cIndex+OrdBagExt())
		Endif
		dbSetOrder(1)
	Endif
#ENDIF

If lSpbInUse
	dbSelectArea("TRB")
	dbCloseArea()
	Ferase(cNomeArq+GetDBExtension())
	Ferase(cNomeArq+OrdBagExt())
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fr470Skip ³ Autor ³ Pilar S. Albaladejo	  ³ Data ³ 13.10.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Pula registros de acordo com as condicoes (AS 400/CDX/ADS)  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINR470.PRX																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fr470Skip()
Local lRet := .T.

IF E5_TIPODOC $ "DC/JR/MT/CM/D2/J2/M2/C2/V2/CP/TL"  //Valores de Baixas
	lRet := .F.
//ElseIF E5_BANCO+E5_AGENCIA+E5_CONTA!=cBanco+cAgencia+cConta
//	lRet := .F.
ElseIF E5_SITUACA = "C"    //Cancelado
	lRet := .F.
ElseIF E5_VALOR = 0
	lRet := .F.
ElseIF E5_VENCTO > d_dtate .or. E5_VENCTO > E5_DATA
	lRet := .F.
ElseIf SubStr(E5_NUMCHEQ,1,1)=="*" 
	lRet := .F.
//ElseIf (mv_par07 == 2 .and. Empty(E5_RECONC)) .or. (mv_par07 == 3 .and. !Empty(E5_RECONC))
//	lRet := .F.
ElseIF E5_TIPODOC = "BA"      //Baixa Automatica
	lRet := .F.
Endif

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fr470Spb  ³ Autor ³ Mauricio Pequim Jro	  ³ Data ³ 23.03.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Monta arquivo de tranbalho para SPB                      )  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINR470.PRX																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fr470SPB(cChave, aStruct)

Local cCondTrb := iiF(lAllFil, ".T.",'E5_FILIAL == xFilial("SE5")')
Local nX

DbselectArea("SE5")
While !Eof() .and. &(cCondTrb)
	If (E5_DATA >= d_dtde .and. E5_DATA <= d_dtate .AND.E5_DTDISPO > d_dtate) .OR. (E5_DTDISPO <= d_dtate)
		RecLock( "TRB", .T. )
		For nX := 1 to Len( aStruct )-1   // Até o campo anterior a TRB->E5_BLOQ
			dbSelectArea("SE5")
			xConteudo := FieldGet( nX )
			dbSelectArea("TRB")
			FieldPut( nX,	xConteudo )
		Next nX
		If (E5_DATA <= d_dtate .AND.E5_DTDISPO > d_dtate ) .or. ;
			(E5_DATA <= d_dtate .AND.E5_MODSPB == "2" .and. E5_DTDISPO == d_dtate .AND.;
			(dDataBase == E5_DTDISPO .and. ;
			((E5_RECPAG == "R" .and. E5_TIPODOC != "ES") .or. (E5_RECPAG == "P" .and. E5_TIPODOC == "ES"))) )
			TRB->E5_DTDISPO	:= TRB->E5_DATA
			TRB->E5_BLOQ		:= SE5->E5_MODSPB
		Endif	
		msUnlock()
   Endif                                                     
   DbselectArea("SE5")
   DBsKIP()
Enddo
dbselectArea("TRB")
dbGotop()
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SldBcoDt  ºAutor  ³Alexandre Sousa     º Data ³  05/21/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna o saldo do dia.                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SldBcoDt(cCodEmp,cCodFil,cStringBanco,cStringAgencia,cStringConta, d_data)

Local nTotReg
Local cFil,cBanco,cAgencia,cConta
Local dDtSalAt := Ctod(Space(8))
Local nSaldoBco := 0
Local nSaldoAtu := 0

If Empty(cCodFil)
	cCodFil := "'" + Space(2) + "'"
EndIf

If Empty(cStringBanco)
	cStringBanco := "'" + Space(3) + "'"
EndIf

If Empty(cStringAgencia)
	cStringAgencia := "'" + Space(5) + "'"
EndIf

If Empty(cStringConta)
	cStringConta := "'" + Space(10) + "'"
EndIf

cQuery := "SELECT SE8.E8_FILIAL E8_FILIAL,SE8.E8_BANCO E8_BANCO,SE8.E8_AGENCIA E8_AGENCIA,SE8.E8_CONTA E8_CONTA, E8_SALRECO, "
cQuery += "       SE8.E8_DTSALAT E8_DTSALAT,SE8.E8_SALATUA E8_SALATUA "
cQuery += " FROM " + RetSqlName("SE8") + " SE8 "
cQuery += " WHERE SE8.E8_FILIAL IN (" + xFilial("SE8") + ")"
cQuery += "       AND SE8.E8_BANCO IN (" + cStringBanco + ")"
cQuery += "       AND SE8.E8_AGENCIA IN (" + cStringAgencia + ")"
cQuery += "       AND SE8.E8_CONTA IN (" + cStringConta + ")"
cQuery += "       AND SE8.E8_DTSALAT <= '" + Dtos(d_data) + "'"
cQuery += "       AND SE8.D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY E8_FILIAL,E8_BANCO,E8_AGENCIA,E8_CONTA,E8_DTSALAT"

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP1",.F.,.T.)
nTotReg := TMP1->(RecCount())

//ProcRegua(nTotReg)

TMP1->(DbGoTop())
While TMP1->(!Eof())

	cFil 		:= TMP1->E8_FILIAL
	cBanco 	:= TMP1->E8_BANCO
	cAgencia	:= TMP1->E8_AGENCIA
	cConta	:= TMP1->E8_CONTA
	dDtSalAt := Ctod(Space(8))
	
	While TMP1->E8_FILIAL == cFil .And. TMP1->E8_BANCO == cBanco .And. TMP1->E8_AGENCIA == cAgencia .And. ;
	      TMP1->E8_CONTA == cConta .And. Stod(TMP1->E8_DTSALAT) >= dDtSalAt .And. TMP1->(!Eof())
	      
		dDtSalAt := Stod(TMP1->E8_DTSALAT)
		nSaldoBco := Round(xMoeda(Iif(TMP1->E8_SALATUA=0, TMP1->E8_SALATUA, TMP1->E8_SALATUA),nMoedaBco,1,TMP1->E8_DTSALAT,nMoeda+1),nMoeda) //TMP1->E8_SALATUA
		TMP1->(DbSkip())
		
		IncProc("Processando saldos bancarios - empresa: " + cCodEmp + "...")
		
	EndDo
	
	nSaldoAtu += nSaldoBco
	
EndDo

DbSelectArea("TMP1")
DbCloseArea()

Return(nSaldoAtu)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FT070MontaºAutor  ³Alexandre Sousa     º Data ³  06/26/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monta arvore.                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FT070Monta() 

	Local cCargo    := ""
	Local cSeekSup  := ""                
	Local cMainPref := ""

	Local nLoop     := 0      

	Private n_vez		:= 0
	Private c_grpn		:= ''
	Private c_natpai	:= ''

	cStartGroup := "MAINGR"

	cMainPref := If( cStartGroup == "MAINGR", "0MA", "2GR" ) 
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inclui os grupos que tem este grupo como superior            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ       
                                                
	aRecnoPCV := {}                     
                         
	If cStartGroup == "MAINGR" 
		PCV->( dbSetOrder( 2 ) ) //PCV_FILIAL, PCV_GRPSUP, R_E_C_N_O_, D_E_L_E_T_
		cSeekSup := xFilial( "PCV" ) + cStartGroup
		If PCV->( dbSeek( cSeekSup ) ) 
			While !PCV->( Eof() ) .And. PCV->PCV_FILIAL + PCV->PCV_GRPSUP == cSeekSup
				AAdd( aRecnoPCV, PCV->( RecNo() ) )	
				PCV->( dbSkip() ) 	
			EndDo 
		EndIf                 
	Else 	
		PCV->( dbSetOrder( 1 ) ) //PCV_FILIAL, PCV_GRPNAT, R_E_C_N_O_, D_E_L_E_T_
		cSeekSup := xFilial( "PCV" ) + cStartGroup
		If PCV->( dbSeek( cSeekSup ) ) 
			AAdd( aRecnoPCV, PCV->( RecNo() ) )	
		EndIf                 
	EndIf 
	
	For nLoop := 1 To Len( aRecnoPCV ) 	                  
		PCV->( dbGoto( aRecnoPCV[ nLoop ] ) ) 
		n_vez := 0
		c_grpn := PCV->PCV_GRPNAT
		FT070MonGr(PCV->PCV_GRPNAT, n_vez, c_grpn) 
	Next nLoop 	
                       
Return( .T. ) 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FT070MonGrºAutor  ³Alexandre Sousa     º Data ³  06/26/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monta grupo.                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FT070MonGr(cGrupoInc, n_laco, cGrupo2)
    
	Local aUserAtu   := {}
	Local aRecnoPCV  := {}        
	Local cSeekPCX   := ""
	Local cSeekSup   := ""                
	Local nLoop      := 0 


	#IFDEF TOP
		Local cQuery     := ""   
		Local cAliasQry  := ""
	#ENDIF 	

	PCV->( dbSetOrder( 1 ) ) //PCV_FILIAL, PCV_GRPNAT, R_E_C_N_O_, D_E_L_E_T_
	If PCV->( MsSeek( xFilial( "PCV" ) + cGrupoInc ) )    
	 
		cDesc := PadR( AllTrim(cGrupo2) + "-" + Capital( PCV->PCV_DESC ), 100 ) 
		If n_laco > 0
			Aadd(a_nats, {Space(6*n_laco)+cDesc, , PCV->PCV_DESC, PCV->PCV_TIPO})
		Else
			Aadd(a_nats, {cDesc, , PCV->PCV_DESC, PCV->PCV_TIPO})
		EndIf
		                   
		#IFDEF TOP 
		         
			If TcSrvType() <> "AS/400" 
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Inclui os naturezass                                              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cAliasQry := CriaTrab( ,.F. ) 		

				cQuery := ""                          
				cQuery += "SELECT PCX_NATUR, PCX_DESC FROM " + RetSqlName( "PCX" ) + " PCX "
				cQuery += "WHERE "
				cQuery += "PCX_FILIAL='" + xFilial( "PCX" ) + "' AND "
				cQuery += "PCX_GRPNAT='" + PCV->PCV_GRPNAT  + "' AND "			
				cQuery += "PCX.D_E_L_E_T_<>'*' ORDER BY PCX_NATUR"
		
				dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), cAliasQry, .F., .T. ) 
				
				If Alias() == cAliasQry 
					While !Eof()
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Inclui no array de atuais ( ja existentes )                       ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						AAdd( aUserAtu, PCX_NATUR ) 
						cDesc := "      "+ PadR(  Alltrim(cGrupo2) + AllTrim(PCX_NATUR)+ "-" + AllTrim(Capital( PCX_DESC )), 100 ) 
						If n_laco > 0
							Aadd(a_nats, {Space(6*n_laco)+cDesc, PCX_NATUR, ,})
						Else
							Aadd(a_nats, {cDesc, PCX_NATUR, ,})
						EndIf
						dbSkip()    	
					EndDo 					
					dbCloseArea()
					dbSelectArea( "PCX" ) 
				EndIf 
		
			Else 	
		#ENDIF 
		
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Inclui as naturezas                                               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				PCX->( dbSetOrder( 2 ) ) //PCX_FILIAL, PCX_XGRPNAT, R_E_C_N_O_, D_E_L_E_T_
				cSeekPCX := xFilial( "PCX" ) + PCV->PCV_GRPNAT
				If PCX->( dbSeek( cSeekPCX ) ) 
					While !PCX->( Eof() ) .And. cSeekPCX == PCX->PCX_FILIAL + PCX->PCX_GRPNAT
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Inclui no array de atuais ( ja existentes )                       ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						AAdd( aUserAtu, PCX->PCX_NATUR ) 
						cDesc := "      "+PadR(AllTrim(cGrupo2) + AllTrim(PCX->PCX_NATUR) + "-" + AllTrim(Capital( PCX->PCX_DESC )), 100 ) 
						Aadd(a_nats, {cDesc, PCX->PCX_NATUR, ,})
						
						PCX->( dbSkip() ) 	 
					EndDo 
			    EndIf 
			    
		#IFDEF TOP
			EndIf 	
		#ENDIF		    
				
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inclui os grupos que tem este grupo como superior            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ       
		aRecnoPCV := {} 
	            
		#IFDEF TOP 
		
			If TcSrvType() # "AS/400"
	
				cAliasQry := CriaTrab( ,.F. ) 		
				cQuery    := ""                          
				
				cQuery += "SELECT R_E_C_N_O_ PCVRECNO FROM " + RetSqlName( "PCV" ) + " "
				cQuery += "WHERE "
				cQuery += "PCV_FILIAL='" + xFilial( "PCV" ) + "' AND "
				cQuery += "PCV_GRPSUP='" + cGrupoInc        + "' AND "			
				cQuery += "D_E_L_E_T_<>'*' ORDER BY PCV_GRPNAT"
		
				dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), cAliasQry, .F., .T. ) 
				
				If Alias() == cAliasQry 
					While !Eof()
						AAdd( aRecnoPCV, PCVRECNO ) 
						dbSkip()    	
					EndDo 					
					dbCloseArea()
					dbSelectArea( "PCV" ) 
				EndIf 
		
			Else
		#ENDIF 
				PCV->( dbSetOrder( 2 ) ) //PCV_FILIAL, PCV_GRPNAT, R_E_C_N_O_, D_E_L_E_T_
				cSeekSup := xFilial( "PCV" ) + cGrupoInc
				If PCV->( dbSeek( cSeekSup ) )
					While !PCV->( Eof() ) .And. PCV->PCV_FILIAL + PCV->PCV_GRPSUP == cSeekSup
						AAdd( aRecnoPCV, PCV->(RecNo()))
						PCV->( dbSkip() )
					EndDo 
				EndIf
		#IFDEF TOP
			EndIf 	
		#ENDIF	
	
		For nLoop := 1 To Len( aRecnoPCV )
			PCV->( dbGoto( aRecnoPCV[ nLoop ] ) ) 
			n_vez++
			c_grpn := cGrupoInc+c_grpn
			n_laco++
			cGrupo2 := cGrupo2 + PCV->PCV_GRPNAT
			FT070MonGr(PCV->PCV_GRPNAT, n_laco, cGrupo2)
			cGrupo2 := SubStr(cGrupo2, 1, len(cGrupo2)-6)
			n_laco--
		Next nLoop
	
	EndIf 
	
Return( .T. ) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FGEN002   ºAutor  ³Alexandre Martins   º Data ³  03/17/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao generica para exportacao de dados para o Excel.      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico ACTUAL TREND                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Exporta(a_Header, a_cols)
//Static Function Exporta(a_xml)
	
//	Processa({||ExpExcel(a_Header, a_cols)}, "Exportando Dados")
	Processa({||ExpXML()}, "Exportando Dados")

Return

Static Function ExpXML()

	Local cArqSaida := cGetFile("\", "Selecione o Diretorio p/ Gerar o Arquivo",,,,GETF_RETDIRECTORY+GETF_LOCALHARD+GETF_LOCALFLOPPY/*128+GETF_NETWORKDRIVE*/) //

	cArqSaida += "flcx.xml"	
	Private nHdlSaida  := 0

	ProcRegua(len(a_xml))

	nHdlSaida:=MSFCREATE(cArqSaida,0)
	
	msgalert(cArqSaida)
	
//	If!msgyesno('continua?')
//		Return
//	EndIf
	
	For n_t := 1 to len(a_xml)
		FWRITE(nHdlSaida,a_xml[n_t]+chr(13))
		IncProc("Concluindo ..."+AllTrim(Str((n_t/len(a_xml))*100, 5))+" %")
	Next
	
	FCLOSE(nHdlSaida)
	
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(cArqSaida) // Abre uma planilha
	oExcelApp:SetVisible(.T.)

	c_Cmd := 'C:\Program Files\Microsoft Office\Office12\excel.exe'
	If File(c_Cmd)
		c_Cmd := c_Cmd + cArqSaida
	ElseIf File("C:\Arquivo de programas\Microsoft Office\excel.exe")
		c_Cmd := 'C:\Arquivo de programas\Microsoft Office\excel.exe "' + cArqSaida + '"'
	ElseIf File("C:\Arquivo de programas\Microsoft Office\office11\excel.exe")
		c_Cmd := 'C:\Arquivo de programas\Microsoft Office\office11\excel.exe "' + cArqSaida + '"'
	ElseIf File("C:\Arquivo de programas\Microsoft Office\office12\excel.exe")
		c_Cmd := 'C:\Arquivo de programas\Microsoft Office\office12\excel.exe "' + cArqSaida + '"'
	Else
		c_Cmd := c_Cmd + cArqSaida
	Endif
	WinExec(c_Cmd)

Return

Static Function ExpExcel(a_Header, a_cols)

LOCAL cDirDocs   := MsDocPath() 
Local aStru		:= {}
Local cArquivo := CriaTrab(,.F.)
Local cPath		:= AllTrim(GetTempPath())
Local oExcelApp
Local nX := 0

n_QtdReg := len(a_cols)
n_RegAtu := 0
ProcRegua(n_QtdReg)

For n_x := 1 to len(a_Header)
	Aadd(aStru, {a_Header[n_x,1]	, a_Header[n_x,2], a_Header[n_x, 3], a_Header[n_x, 4]})
Next


dbCreate(cDirDocs+"\"+cArquivo,aStru)
dbUseArea(.T.,,cDirDocs+"\"+cArquivo,cArquivo,.F.,.F.)

For nX := 1 to Len(a_cols)
	RecLock(cArquivo, .T.)
	IncProc("Concluindo ..."+AllTrim(Str((n_RegAtu/n_QtdReg)*100, 5))+" %")
	n_RegAtu++
	For n_y := 1 to len(a_Header)
		(cArquivo)->&(a_Header[n_y, 1])	:= a_cols[nX,n_y]
	Next
Next

dbSelectArea(cArquivo)
dbCloseArea()


CpyS2T( cDirDocs+"\"+cArquivo+".DBF" , cPath, .T. )
msgAlert(cDirDocs+"\"+cArquivo+".xml")
memowrite(cDirDocs+"\"+cArquivo+".xml", c_xml)

If ! ApOleClient( 'MsExcel' ) 
 MsgStop( 'MsExcel nao instalado' ) //
 Return
EndIf

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( cPath+cArquivo+".DBF" ) // Abre uma planilha
oExcelApp:WorkBooks:Open( cPath+cArquivo+".xml" ) // Abre uma planilha
oExcelApp:SetVisible(.T.)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fCabecxml ºAutor  ³Alexandre Sousa     º Data ³  07/25/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cabecalho xml para exportacao para o excel.                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fCabecxml()

	Local c_Ret := ''
	Local c_EOL := chr(13)


	Aadd(a_xml, '<?xml version="1.0"?>')
	Aadd(a_xml, '<?mso-application progid="Excel.Sheet"?>')
	Aadd(a_xml, '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"')
	Aadd(a_xml, ' xmlns:o="urn:schemas-microsoft-com:office:office"')
	Aadd(a_xml, ' xmlns:x="urn:schemas-microsoft-com:office:excel"')
	Aadd(a_xml, ' xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"')
	Aadd(a_xml, ' xmlns:html="http://www.w3.org/TR/REC-html40">')
	Aadd(a_xml, ' <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">')
	Aadd(a_xml, '  <Author>fabio</Author>')
	Aadd(a_xml, '  <LastAuthor>Alexandre</LastAuthor>')
	Aadd(a_xml, '  <Created>2008-07-25T18:25:24Z</Created>')
	Aadd(a_xml, '  <Version>12.00</Version>')
	Aadd(a_xml, ' </DocumentProperties>')
	Aadd(a_xml, ' <OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">')
	Aadd(a_xml, '  <AllowPNG/>')
	Aadd(a_xml, ' </OfficeDocumentSettings>')
	Aadd(a_xml, ' <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">')
	Aadd(a_xml, '  <WindowHeight>10680</WindowHeight>')
	Aadd(a_xml, '  <WindowWidth>18975</WindowWidth>')
	Aadd(a_xml, '  <WindowTopX>120</WindowTopX>')
	Aadd(a_xml, '  <WindowTopY>30</WindowTopY>')
	Aadd(a_xml, '  <TabRatio>429</TabRatio>')
	Aadd(a_xml, '  <ProtectStructure>False</ProtectStructure>')
	Aadd(a_xml, '  <ProtectWindows>False</ProtectWindows>')
	Aadd(a_xml, ' </ExcelWorkbook>')
	Aadd(a_xml, ' <Styles>')
	Aadd(a_xml, '  <Style ss:ID="Default" ss:Name="Normal">')
	Aadd(a_xml, '   <Alignment ss:Vertical="Bottom"/>')
	Aadd(a_xml, '   <Borders/>')
	Aadd(a_xml, '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>')
	Aadd(a_xml, '   <Interior/>')
	Aadd(a_xml, '   <NumberFormat/>')
	Aadd(a_xml, '   <Protection/>')
	Aadd(a_xml, '  </Style>')
	Aadd(a_xml, '  <Style ss:ID="s16" ss:Name="Separador de milhares">')
	Aadd(a_xml, '   <NumberFormat ss:Format="_(* #,##0.00_);_(* \(#,##0.00\);_(* &quot;-&quot;??_);_(@_)"/>')
	Aadd(a_xml, '  </Style>')
	Aadd(a_xml, '  <Style ss:ID="s63" ss:Parent="s16">')
	Aadd(a_xml, '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>')
	Aadd(a_xml, '   <NumberFormat ss:Format="_(* #,##0_);_(* \(#,##0\);_(* &quot;-&quot;??_);_(@_)"/>')
	Aadd(a_xml, '  </Style>')
	Aadd(a_xml, '  <Style ss:ID="s65" ss:Parent="s16">')
	Aadd(a_xml, '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"')
	Aadd(a_xml, '    ss:Bold="1"/>')
	Aadd(a_xml, '   <NumberFormat ss:Format="_(* #,##0_);_(* \(#,##0\);_(* &quot;-&quot;??_);_(@_)"/>')
	Aadd(a_xml, '  </Style>')
	Aadd(a_xml, '  <Style ss:ID="s67" ss:Parent="s16">')
	Aadd(a_xml, '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>')
	Aadd(a_xml, '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"')
	Aadd(a_xml, '    ss:Bold="1"/>')
	Aadd(a_xml, '   <NumberFormat ss:Format="_(* #,##0_);_(* \(#,##0\);_(* &quot;-&quot;??_);_(@_)"/>')
	Aadd(a_xml, '  </Style>')
	Aadd(a_xml, '  <Style ss:ID="s69" ss:Parent="s16">')
	Aadd(a_xml, '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="6" ss:Color="#000000"')
	Aadd(a_xml, '    ss:Bold="1"/>')
	Aadd(a_xml, '   <Interior ss:Color="#B8CCE4" ss:Pattern="Solid"/>')
	Aadd(a_xml, '   <NumberFormat ss:Format="_(* #,##0_);_(* \(#,##0\);_(* &quot;-&quot;??_);_(@_)"/>')
	Aadd(a_xml, '  </Style>')
	Aadd(a_xml, '  <Style ss:ID="s70" ss:Parent="s16">')
	Aadd(a_xml, '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="6" ss:Color="#000000"')
	Aadd(a_xml, '    ss:Bold="1"/>')
	Aadd(a_xml, '   <Interior ss:Color="#D8D8D8" ss:Pattern="Solid"/>')
	Aadd(a_xml, '   <NumberFormat ss:Format="_(* #,##0_);_(* \(#,##0\);_(* &quot;-&quot;??_);_(@_)"/>')
	Aadd(a_xml, '  </Style>')
	Aadd(a_xml, '  <Style ss:ID="s71" ss:Parent="s16">')
	Aadd(a_xml, '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="6" ss:Color="#000000"/>')
	Aadd(a_xml, '   <NumberFormat ss:Format="_(* #,##0_);_(* \(#,##0\);_(* &quot;-&quot;??_);_(@_)"/>')
	Aadd(a_xml, '  </Style>')
	Aadd(a_xml, '  <Style ss:ID="s73" ss:Parent="s16">')
	Aadd(a_xml, '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>')
	Aadd(a_xml, '   <Interior ss:Color="#366092" ss:Pattern="Solid"/>')
	Aadd(a_xml, '   <NumberFormat ss:Format="_(* #,##0_);_(* \(#,##0\);_(* &quot;-&quot;??_);_(@_)"/>')
	Aadd(a_xml, '  </Style>')
	Aadd(a_xml, '  <Style ss:ID="s74" ss:Parent="s16">')
	Aadd(a_xml, '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="6" ss:Color="#000000"/>')
	Aadd(a_xml, '   <Interior ss:Color="#366092" ss:Pattern="Solid"/>')
	Aadd(a_xml, '   <NumberFormat ss:Format="_(* #,##0_);_(* \(#,##0\);_(* &quot;-&quot;??_);_(@_)"/>')
	Aadd(a_xml, '  </Style>')
	Aadd(a_xml, '  <Style ss:ID="s75" ss:Parent="s16">')
	Aadd(a_xml, '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="6" ss:Color="#000000"')
	Aadd(a_xml, '    ss:Bold="1"/>')
	Aadd(a_xml, '   <Interior ss:Color="#366092" ss:Pattern="Solid"/>')
	Aadd(a_xml, '   <NumberFormat ss:Format="_(* #,##0_);_(* \(#,##0\);_(* &quot;-&quot;??_);_(@_)"/>')
	Aadd(a_xml, '  </Style>')
	Aadd(a_xml, '  <Style ss:ID="s76" ss:Parent="s16">')
	Aadd(a_xml, '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>')
	Aadd(a_xml, '   <Interior ss:Color="#8DB4E2" ss:Pattern="Solid"/>')
	Aadd(a_xml, '   <NumberFormat ss:Format="_(* #,##0_);_(* \(#,##0\);_(* &quot;-&quot;??_);_(@_)"/>')
	Aadd(a_xml, '  </Style>')
	Aadd(a_xml, '  <Style ss:ID="s77" ss:Parent="s16">')
	Aadd(a_xml, '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="6" ss:Color="#000000"/>')
	Aadd(a_xml, '   <Interior ss:Color="#8DB4E2" ss:Pattern="Solid"/>')
	Aadd(a_xml, '   <NumberFormat ss:Format="_(* #,##0_);_(* \(#,##0\);_(* &quot;-&quot;??_);_(@_)"/>')
	Aadd(a_xml, '  </Style>')
	Aadd(a_xml, '  <Style ss:ID="s78" ss:Parent="s16">')
	Aadd(a_xml, '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="6" ss:Color="#000000"')
	Aadd(a_xml, '    ss:Bold="1"/>')
	Aadd(a_xml, '   <Interior ss:Color="#8DB4E2" ss:Pattern="Solid"/>')
	Aadd(a_xml, '   <NumberFormat ss:Format="_(* #,##0_);_(* \(#,##0\);_(* &quot;-&quot;??_);_(@_)"/>')
	Aadd(a_xml, '  </Style>')
	Aadd(a_xml, '  <Style ss:ID="s79" ss:Parent="s16">')
	Aadd(a_xml, '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="6" ss:Color="#000000"/>')
	Aadd(a_xml, '   <Interior ss:Color="#FFFF00" ss:Pattern="Solid"/>')
	Aadd(a_xml, '   <NumberFormat ss:Format="_(* #,##0_);_(* \(#,##0\);_(* &quot;-&quot;??_);_(@_)"/>')
	Aadd(a_xml, '  </Style>')
	Aadd(a_xml, '  <Style ss:ID="s80" ss:Parent="s16">')
	Aadd(a_xml, '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="6" ss:Color="#000000"/>')
	Aadd(a_xml, '   <Interior ss:Color="#92D050" ss:Pattern="Solid"/>')
	Aadd(a_xml, '   <NumberFormat ss:Format="_(* #,##0_);_(* \(#,##0\);_(* &quot;-&quot;??_);_(@_)"/>')
	Aadd(a_xml, '  </Style>')
	Aadd(a_xml, '  <Style ss:ID="s81" ss:Parent="s16">')
	Aadd(a_xml, '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>')
	Aadd(a_xml, '   <Interior ss:Color="#538DD5" ss:Pattern="Solid"/>')
	Aadd(a_xml, '   <NumberFormat ss:Format="_(* #,##0_);_(* \(#,##0\);_(* &quot;-&quot;??_);_(@_)"/>')
	Aadd(a_xml, '  </Style>')
	Aadd(a_xml, '  <Style ss:ID="s82" ss:Parent="s16">')
	Aadd(a_xml, '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="6" ss:Color="#000000"/>')
	Aadd(a_xml, '   <Interior ss:Color="#538DD5" ss:Pattern="Solid"/>')
	Aadd(a_xml, '   <NumberFormat ss:Format="_(* #,##0_);_(* \(#,##0\);_(* &quot;-&quot;??_);_(@_)"/>')
	Aadd(a_xml, '  </Style>')
	Aadd(a_xml, '  <Style ss:ID="s83" ss:Parent="s16">')
	Aadd(a_xml, '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="6" ss:Color="#000000"')
	Aadd(a_xml, '    ss:Bold="1"/>')
	Aadd(a_xml, '   <Interior ss:Color="#538DD5" ss:Pattern="Solid"/>')
	Aadd(a_xml, '   <NumberFormat ss:Format="_(* #,##0_);_(* \(#,##0\);_(* &quot;-&quot;??_);_(@_)"/>')
	Aadd(a_xml, '  </Style>')
	Aadd(a_xml, '  <Style ss:ID="s84" ss:Parent="s16">')
	Aadd(a_xml, '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="6" ss:Color="#000000"/>')
	Aadd(a_xml, '   <Interior/>')
	Aadd(a_xml, '   <NumberFormat ss:Format="_(* #,##0_);_(* \(#,##0\);_(* &quot;-&quot;??_);_(@_)"/>')
	Aadd(a_xml, '  </Style>')
	Aadd(a_xml, '  <Style ss:ID="s85" ss:Parent="s16">')
	Aadd(a_xml, '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>')
	Aadd(a_xml, '   <Interior ss:Color="#92D050" ss:Pattern="Solid"/>')
	Aadd(a_xml, '   <NumberFormat ss:Format="_(* #,##0_);_(* \(#,##0\);_(* &quot;-&quot;??_);_(@_)"/>')
	Aadd(a_xml, '  </Style>')
	Aadd(a_xml, '  <Style ss:ID="s86" ss:Parent="s16">')
	Aadd(a_xml, '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="6" ss:Color="#000000"')
	Aadd(a_xml, '    ss:Bold="1"/>')
	Aadd(a_xml, '   <Interior ss:Color="#92D050" ss:Pattern="Solid"/>')
	Aadd(a_xml, '   <NumberFormat ss:Format="_(* #,##0_);_(* \(#,##0\);_(* &quot;-&quot;??_);_(@_)"/>')
	Aadd(a_xml, '  </Style>')
	Aadd(a_xml, ' </Styles>')
	Aadd(a_xml, ' <Names>')
	Aadd(a_xml, '  <NamedRange ss:Name="Database" ss:RefersTo="=sc039990!R6C1:R130C34"/>')
	Aadd(a_xml, ' </Names>')
	Aadd(a_xml, ' <Worksheet ss:Name="sc039990">')
	Aadd(a_xml, '  <Table ss:ExpandedColumnCount="235" ss:ExpandedRowCount="401" x:FullColumns="1"')
	Aadd(a_xml, '   x:FullRows="1" ss:StyleID="s63" ss:DefaultRowHeight="9">')
	Aadd(a_xml, '   <Column ss:StyleID="s63" ss:AutoFitWidth="0" ss:Width="132"/>')
	Aadd(a_xml, '   <Column ss:StyleID="s65" ss:AutoFitWidth="0" ss:Width="36.75"/>')
	Aadd(a_xml, '   <Column ss:StyleID="s63" ss:AutoFitWidth="0" ss:Width="42"/>')
	Aadd(a_xml, '   <Column ss:StyleID="s63" ss:AutoFitWidth="0" ss:Width="42.75"/>')
	Aadd(a_xml, '   <Column ss:StyleID="s63" ss:AutoFitWidth="0" ss:Width="45" ss:Span="28"/>')
	Aadd(a_xml, '   <Column ss:Index="34" ss:StyleID="s65" ss:AutoFitWidth="0" ss:Width="45"/>')
	Aadd(a_xml, '   <Row ss:AutoFitHeight="0" ss:Height="15">')
	Aadd(a_xml, '    <Cell ss:MergeAcross="12" ss:StyleID="s67"><Data ss:Type="String">Demonstrativo de Fluxo de Caixa - LISONDA</Data></Cell>')
	Aadd(a_xml, '   </Row>')
	Aadd(a_xml, '   <Row ss:AutoFitHeight="0" ss:Height="10.5">')
	Aadd(a_xml, '    <Cell ss:StyleID="s69"><Data ss:Type="String">A - Saldo Inicial</Data></Cell>')
	Aadd(a_xml, '    <Cell ss:StyleID="s69"/>')
	For n_x := 1 to len(a_dcab)
		Aadd(a_xml, '    <Cell ss:StyleID="s69"><Data ss:Type="Number">0</Data></Cell>')
	Next
	Aadd(a_xml, '    <Cell ss:StyleID="s70"><Data ss:Type="Number">0</Data></Cell>')
	Aadd(a_xml, '   </Row>')
	Aadd(a_xml, '   <Row ss:AutoFitHeight="0">')
	Aadd(a_xml, '    <Cell ss:StyleID="s71"><Data ss:Type="String">      A1 - Saldo Inicial</Data></Cell>')
	Aadd(a_xml, '    <Cell ss:StyleID="s71"/>')
	Aadd(a_xml, '    <Cell ss:StyleID="s71"/>')
	Aadd(a_xml, '    <Cell ss:StyleID="s71"/>')
	c_formula := ''
	n_lsum := 4
	For n_y := 2 to len(a_dados)
		n_lsum++
		If 'A1 - Saldo Inicial'$ a_dados[n_y, 1]
			c_formula += "=R["+strzero(n_lsum,4)+"]C"
		EndIf
	Next
	Aadd(a_xml, '    <Cell ss:StyleID="s71" ss:Formula="'+c_formula+'"><Data ss:Type="Number">0</Data></Cell>')
	For n_x := 4 to len(a_dcab)
		Aadd(a_xml, '    <Cell ss:StyleID="s71" ss:Formula="=R[2]C[-1]"><Data ss:Type="Number">0</Data></Cell>')
	Next
//	Aadd(a_xml, '    <Cell ss:StyleID="s70"><Data ss:Type="Number">261767.36</Data></Cell>')
	Aadd(a_xml, '    <Cell ss:StyleID="s70" ss:Formula="=R[2]C[-1]"><Data ss:Type="Number">0</Data></Cell>')
	Aadd(a_xml, '   </Row>')
	Aadd(a_xml, '   <Row ss:AutoFitHeight="0">')
	Aadd(a_xml, '    <Cell ss:StyleID="s71"><Data ss:Type="String">Saldo do dia</Data></Cell>')
	Aadd(a_xml, '    <Cell ss:StyleID="s71"/>')
	Aadd(a_xml, '    <Cell ss:StyleID="s71"/>')
	Aadd(a_xml, '    <Cell ss:StyleID="s71"/>')
	c_formula := ''
	n_lsum := 2
	For n_y := 1 to len(a_dados)
		n_lsum++
		If 'NV22-B - Saldo do Dia'$ a_dados[n_y, 1]
			c_formula += "=R["+strzero(n_lsum,4)+"]C"
			exit
		EndIf
	Next
	For n_x := 3 to len(a_dcab)
		Aadd(a_xml, '    <Cell ss:StyleID="s71" ss:Formula="'+c_formula+'"><Data ss:Type="Number">0</Data></Cell>')
	Next
//	Aadd(a_xml, '    <Cell ss:StyleID="s70"><Data ss:Type="Number">261767.36</Data></Cell>')
	Aadd(a_xml, '    <Cell ss:StyleID="s70" ss:Formula="'+c_formula+'"><Data ss:Type="Number">0</Data></Cell>')

	Aadd(a_xml, '   </Row>')
	Aadd(a_xml, '   <Row ss:AutoFitHeight="0">')
	Aadd(a_xml, '    <Cell ss:StyleID="s71"><Data ss:Type="String">Acumulado</Data></Cell>')
	Aadd(a_xml, '    <Cell ss:StyleID="s71"/>')
	Aadd(a_xml, '    <Cell ss:StyleID="s71"/>')
	Aadd(a_xml, '    <Cell ss:StyleID="s71"/>')
	For n_x := 3 to len(a_dcab)
		Aadd(a_xml, '    <Cell ss:StyleID="s71" ss:Formula="=R[-1]C+R[-2]C"><Data ss:Type="Number">0</Data></Cell>')
//		Aadd(a_xml, '    <Cell ss:StyleID="s71"><Data ss:Type="Number">0</Data></Cell>')
	Next
	Aadd(a_xml, '    <Cell ss:StyleID="s70"><Data ss:Type="Number">261767.36</Data></Cell>')
	Aadd(a_xml, '   </Row>')
	Aadd(a_xml, '   <Row ss:AutoFitHeight="0">')
//	Aadd(a_xml, '    <Cell ss:StyleID="s70"><Data ss:Type="String">DESCGRP</Data><NamedCell')
//	Aadd(a_xml, '      ss:Name="Database"/></Cell>')
//	Aadd(a_xml, '    <Cell ss:StyleID="s70"><Data ss:Type="String">NATUREZA</Data><NamedCell')
//	Aadd(a_xml, '      ss:Name="Database"/></Cell>')

	For n_t := 1 to len(a_Header)
		Aadd(a_xml, '        <Cell ss:StyleID="s70"><Data ss:Type="String">'+AllTrim(a_Header[n_t, 1])+'</Data><NamedCell')
		Aadd(a_xml, '      ss:Name="Database"/></Cell>')
	Next


//	Aadd(a_xml, '    <Cell ss:StyleID="s70"><Data ss:Type="String">TOTAL</Data></Cell>')
	Aadd(a_xml, '   </Row>')


Return c_Ret
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³faddxml   ºAutor  ³Alexandre Sousa     º Data ³  07/25/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inclui a linha do excel xml.                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function faddxml(a_linha, c_style, n_lsum, c_form)

	Local c_Ret			:= ''
	Local c_EOL			:= chr(13)
	Local n_somalinha	:= Iif(n_lsum = nil, 0 , n_lsum)
	Local c_formula		:= Iif(c_form = nil, '', c_form)
	
	Aadd(a_xml, '   <Row ss:AutoFitHeight="0" ss:Height="10.5">')
	
	For n_t := 1 to len(a_header)-1
	
		If valtype(a_linha[n_t]) == 'C'
			c_type := '<Data ss:Type="String">'
			c_ftype:= '</Data>'
			c_val  := a_linha[n_t]
		ElseIf valtype(a_linha[n_t]) == 'N'
			c_type := '<Data ss:Type="Number">'
			c_ftype:= '</Data>'
			c_val  := AllTrim(str(a_linha[n_t]))
		ElseIf valtype(a_linha[n_t]) == 'U'
			c_type := ''
			c_ftype:= ''
			c_val  := ""
		Else
			c_type := ''
			c_ftype:= ''
			c_val  := AllTrim(a_linha[n_t])
		EndIf
	
		If n_somalinha > 0 .and. n_t > 2
			Aadd(a_xml, '    <Cell ss:StyleID="'+c_style+'" ss:Formula="=sum(R[1]C:R['+strzero(n_somalinha,4)+']C)">'+c_type+c_val+c_ftype+'<NamedCell')
		ElseIf !Empty(c_formula) .and. n_t > 2
			Aadd(a_xml, '    <Cell ss:StyleID="'+c_style+'" ss:Formula='+c_formula+'>'+c_type+c_val+c_ftype+'<NamedCell')
		Else
			Aadd(a_xml, '    <Cell ss:StyleID="'+c_style+'">'+c_type+c_val+c_ftype+'<NamedCell')
		EndIf
		Aadd(a_xml, '      ss:Name="Database"/></Cell>')
	Next
	
	If valtype(a_linha[len(a_header)]) == 'C'
		c_type := '<Data ss:Type="String">'
		c_ftype:= '</Data>'
		c_val  := a_linha[len(a_header)]
	ElseIf valtype(a_linha[len(a_header)]) == 'N'
		c_type := '<Data ss:Type="Number">'
		c_ftype:= '</Data>'
		c_val  := AllTrim(str(a_linha[len(a_header)]))
	ElseIf valtype(a_linha[len(a_header)]) == 'U'
		c_type := ''
		c_ftype:= ''
		c_val  := ""
	Else
		c_type := ''
		c_ftype:= ''
		c_val  := AllTrim(a_linha[len(a_header)])
	EndIf

//	Aadd(a_xml, '    <Cell ss:StyleID="s70">'+c_type+c_val+c_ftype+'<NamedCell')
	Aadd(a_xml, '    <Cell ss:StyleID="s70" ss:Formula="sum(RC[-'+strzero(len(a_header)-5,5)+']:RC[-1])" >'+c_type+c_val+c_ftype+'<NamedCell')
    //               <Cell ss:StyleID="s70" ss:Formula="=SUM(RC[-31]:RC[-1])"><Data ss:Type="Number">63188.14</Data><NamedCell
	//               <Cell ss:StyleID="s70" ss:Formula="sum(RC[-00029]:RC[-1]) ><Data ss:Type="Number">0</Data><NamedCell
    
	Aadd(a_xml, '      ss:Name="Database"/></Cell>')

	Aadd(a_xml, '   </Row>')
	
Return c_Ret


Static Function rdxml()

	
	Aadd(a_xml, '  </Table>')
	Aadd(a_xml, '  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">')
	Aadd(a_xml, '   <PageSetup>')
	Aadd(a_xml, '    <Header x:Margin="0.4921259845"/>')
	Aadd(a_xml, '    <Footer x:Margin="0.4921259845"/>')
	Aadd(a_xml, '    <PageMargins x:Bottom="0.984251969" x:Left="0.78740157499999996"')
	Aadd(a_xml, '     x:Right="0.78740157499999996" x:Top="0.984251969"/>')
	Aadd(a_xml, '   </PageSetup>')
	Aadd(a_xml, '   <Unsynced/>')
	Aadd(a_xml, '   <Print>')
	Aadd(a_xml, '    <ValidPrinterInfo/>')
	Aadd(a_xml, '    <HorizontalResolution>600</HorizontalResolution>')
	Aadd(a_xml, '    <VerticalResolution>0</VerticalResolution>')
	Aadd(a_xml, '   </Print>')
	Aadd(a_xml, '   <Zoom>150</Zoom>')
	Aadd(a_xml, '   <Selected/>')
	Aadd(a_xml, '   <Panes>')
	Aadd(a_xml, '    <Pane>')
	Aadd(a_xml, '     <Number>3</Number>')
	Aadd(a_xml, '     <ActiveRow>163</ActiveRow>')
	Aadd(a_xml, '     <ActiveCol>3</ActiveCol>')
	Aadd(a_xml, '    </Pane>')
	Aadd(a_xml, '   </Panes>')
	Aadd(a_xml, '   <ProtectObjects>False</ProtectObjects>')
	Aadd(a_xml, '   <ProtectScenarios>False</ProtectScenarios>')
	Aadd(a_xml, '  </WorksheetOptions>')
	Aadd(a_xml, ' </Worksheet>')
	Aadd(a_xml, '</Workbook>')
	

Return