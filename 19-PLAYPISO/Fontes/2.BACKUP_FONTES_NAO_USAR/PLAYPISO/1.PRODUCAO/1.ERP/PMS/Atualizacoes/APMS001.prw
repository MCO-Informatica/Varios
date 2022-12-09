#DEFINE REC_NAO_CONCILIADO 1
#DEFINE REC_CONCILIADO		2
#DEFINE PAG_NAO_CONCILIADO 3                                                                  
#DEFINE PAG_CONCILIADO		4
#include "PROTHEUS.CH"                     
#include "rwmake.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFIN001   บAutor  ณAlexandre Sousa     บ Data ณ  05/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณApontamento de recursos, lista todas as obras para cada     บฑฑ
ฑฑบ          ณrecurso.                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecifico clientes ACTUAL TREND - www.actualtrend.com.br   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function APMS001()

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
Private cPerg		:= "APMS000001"
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

Valid2Perg()

cPerg		:=   "APMS000001"
Pergunte(cPerg, .T.)

RegToMemory("SZZ", .F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMontando aHeader                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SX3")
dbSetOrder(2)
SX3->(dbSeek("AE8_DESCRI"))
AADD(aHeader,{ "Recurso"  , x3_campo   ,""   ,40      , 0,""	,"","C","", "V"} )

Aadd(a_Header,{"DESCGRP"	,"C",60,0})
Aadd(a_Header,{"NATUREZA"	,"C",35,0})

SX3->(dbSeek("E1_VALOR"))
d_dataini	:= StoD(MV_PAR01+MV_PAR02+"01")
d_datafim	:= somames(StoD(MV_PAR01+MV_PAR02+"01"))
d_dtatu		:= d_dataini

d_datafim	:= somames(StoD(MV_PAR01+MV_PAR02+"01"))

n_cont := 1
While d_dtatu <= d_datafim
	Aadd(a_Header,{DtoC(d_dtatu),"C",20,0})
	AADD(aHeader,{ dtoc(d_dtatu),  "VALOR"+STRZERO(n_cont, 2), "@!"     ,10        ,0        ,""	    ,""        , "C"   , "CTT"        , ""} )
	d_dtatu++
	n_cont++
EndDo
AADD(aHeader,{ "CODIGO"    , "CODIGO", "@!",15,0,""	,"", "C", "", ""})

aAlter := {}
For _n1 := 1 to Len(aHeader)-1
	aAdd(aAlter, aHeader[_n1,2] )
Next _n1

oProcess := MsNewProcess():New({|lEnd| CriaAcols(oProcess)},"Apontamento de Recursos - LISONDA","Preparando Roteiro ... ",.F.)
oProcess:Activate()

cCadastro := OemToAnsi(" ** Apontamento de Recursos ** ")

@ aSize[7],0 to aSize[6],aSize[5] DIALOG oDlg TITLE cCadastro

@ aPosObj[1,1],aPosObj[1,2] TO aPosObj[1,3],aPosObj[1,4] MULTILINE  MODIFY object omultiline //ON CHANGE u_MudaLin(oLbx1:nAt) //FREEZE 1
omultiline:NOPC := 4 //altera
omultiline:nfreeze := 1
omultiline:obrowse:nfreeze:=1 // congela a primeira coluna
omultiline:obrowse:aAlter:= aAlter
omultiline:OBROWSE:BLDBLCLICK := {|x| mostraItens(omultiline:OBROWSE:NAT)}

@ aPosObj[2,1],aPosObj[2,4]-65 BMPBUTTON TYPE 13 ACTION GrvDd()
@ aPosObj[2,1],aPosObj[2,4]-30 BMPBUTTON TYPE 02 ACTION Close(oDlg)
@ aPosObj[2,1],aPosObj[2,4]-117 BUTTON  "Gerar Excel" Size 040,009 ACTION FGERAEXCEL() //Adicao do botao gerar excel - By FVS 29/08/2011

ACTIVATE DIALOG oDlg CENTERED

aHeadEscala := AClone(aHeader)
aCOLSEscala := AClone(aCOLS)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCriaAcols บAutor  ณAlexandre Sousa     บ Data ณ  11/01/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarrega os dados da consulta no array.                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCarrega a primeira regua de processamento.    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oObj:SetRegua1(n_tr1)
n_r1at := 1
a_tmp  := {}

nSaldoBco := 0 //a_tmp[1,3]

cQuery :=        " SELECT *
cQuery += CRLF + "   FROM "+ RetSqlName("AE8")+" AE8 "
cQuery += CRLF + "  WHERE AE8.AE8_FILIAL   = '"+ xFilial("AE8") +"'"
cQuery += CRLF + "    AND AE8.AE8_TIPO     = '2'"
cQuery += CRLF + "    AND AE8.AE8_ATIVO   <> '2'"
cQuery += CRLF + "    AND AE8.D_E_L_E_T_  = ' ' 
cQuery += CRLF + "  ORDER BY AE8.AE8_FILIAL, AE8.AE8_DESCRI

nTotReg := 0
cAliasA := GetNextAlias()
cQuery  := ChangeQuery(cQuery)

DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasA , .F., .T.)
aEval( AE8->(DbStruct()),{|x| If(x[2] != "C", TcSetField(cAliasA, AllTrim(x[1]), x[2], x[3], x[4]),Nil)})

DbSelectArea( cAliasA )
(cAliasA)->( DbEval( { || nTotReg++ },,{ || !Eof() } ) )
(cAliasA)->( DbGoTop() )

oObj:IncRegua1("Montando estrutura de recursos.... passo "+Strzero(n_r1at,2)+" de "+StrZero(n_tr1,2))

oObj:SetRegua2(nTotReg)

While (cAliasA)->(!Eof())
	n_r1at++
	oObj:IncRegua2("Carregando Recursos .... passo "+Strzero(n_r1at,6)+" de "+StrZero(nTotReg,6))
	
	aAuxilio := {}
	nDias    := 0
	
	If !Empty((cAliasA)->AE8_DESCRI)
		aAdd(aAuxilio, (cAliasA)->AE8_DESCRI )
		
		For i := 2 to len(aHeader)-1
			DbSelectArea('SZC')
			DbSetOrder(1) //ZC_FILIAL, ZC_RECURSO, ZC_DATA, R_E_C_N_O_, D_E_L_E_T_
			If DbSeek(xFilial('SZC')+(cAliasA)->AE8_RECURS+dtos(ctod(aHeader[i, 1])))
				aAdd(aAuxilio,SZC->ZC_OBRA)
				nDias++
			Else
				aAdd(aAuxilio,Criavar("ZC_OBRA",,.F.) )
			EndIf
		Next i
		aAdd(aAuxilio, (cAliasA)->AE8_RECURS)
		aAdd(aAuxilio, .F. )
		
		//		If nDias <> 0
		Aadd(aCols, aAuxilio)
		//		EndIf
	EndIf
	
	(cAliasA)->(DbSkip())
EndDo
(cAliasA)->(DbCloseArea())

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg บAutor  ณAlexandre Sousa     บ Data ณ  11/11/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida o grupo de perguntas.                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Valid2Perg()

_sAlias := GetArea()
DbSelectArea("SX1")
DbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs:={}
AADD(aRegs,{cPerg,"01","Ano    ?","","","mv_ch1","C",04,0,0,"G","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","M๊s    ?","","","mv_ch2","C",02,0,0,"G","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSomaMes   บAutor  ณAlexandre Martins   บ Data ณ  07/06/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna data do ultimo dia do mes, apartir da data informadaบฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SomaMes(d_data)

Local c_mes := SubStr(DtoS(d_data) ,5,2)

While SubStr(DtoS(d_data) ,5,2) == c_mes
	d_data := d_data + 1
EndDo


d_data := d_data-1

Return d_data




Static Function mostraItens(n_linha)

If omultiline:OBROWSE:NCOLPOS <> Len(aHeader)
	d_tmp := datavalida(ctod(aHeader[omultiline:OBROWSE:NCOLPOS,1]))
	d_col := ctod(aHeader[omultiline:OBROWSE:NCOLPOS,1])
	
	IF d_tmp <> d_col
		msgalert('Nใo ้ possivel agendar nos finais de semana!!!', 'ATENวรO')
		Return
	EndIf
	
	DbSelectArea("AF8")
	
	c_query := " select CTT_CUSTO, CTT_DESC01 from CTT010 where CTT_BLOQ <> '1' and CTT_MSBLQL <> '1' and D_E_L_E_T_ <> '*' order by CTT_CUSTO "
	n_ok 	:= 0
	c_obra 	:= FGEN008(c_query , {{"Obra", "Descri็ao"}, {"CTT_CUSTO", "CTT_DESC01"}}, "OBRAS", 1)
	
	If n_ok > 0
		aCols[n,omultiline:OBROWSE:NCOLPOS] := c_obra
	Else
		aCols[n,omultiline:OBROWSE:NCOLPOS] := Space(10)
	EndIf
	omultiline:REFRESH()
EndIf

Return

Static Function FGEN008(c_Query, a_campos, c_tit, n_pos)

Local aVetor   := {}
Local cTitulo  := Iif( c_tit = Nil, "Tํtulo", c_tit)
Local nPos		:= Iif(n_pos = Nil, 1, n_pos)
Local n_x		:= 0
Local c_Lst		:= ''
//	Local c_Query := "select distinct EA_FILIAL, EA_NUMBOR from "+RetSqlName("SEA")+" where EA_FILIAL = '"+xFilial("SEA")+"' EA_CART = 'R' and D_E_L_E_T_ <> '*'"
//	Local a_campos := {{"Filial", "Bordero" }, {"EA_FILIAL", "EA_NUMBOR"}}
//	Local c_tit := "Consulta de Borderos"

Private oDlg	:= Nil
Private oLbx	:= Nil
Private c_Ret	:= ''
Private aSalvAmb := GetArea()
Private c_Obra  := Iif(!empty(aCols[omultiline:OBROWSE:NROWPOS,omultiline:OBROWSE:NCOLPOS]), aCols[omultiline:OBROWSE:NROWPOS,omultiline:OBROWSE:NCOLPOS], space(15))

If Select("QRX") > 0
	DbSelectArea("QRX")
	DbCloseArea()
EndIf
TcQuery c_Query New Alias "QRX"

//+-------------------------------------+
//| Carrega o vetor conforme a condicao |
//+-------------------------------------+
While QRX->(!EOF())
	aAdd(aVetor, Array(len(a_campos[2])))
	
	For n_x := 1 to len(a_campos[2])
		aVetor[len(aVetor),n_x] := &("QRX->"+a_campos[2,n_x])
	Next
	QRX->(dbSkip())
End

If Len( aVetor ) == 0
	Aviso( cTitulo, "Nao existe dados para a consulta", {"Ok"} )
	Return
Endif

//+-----------------------------------------------+
//| Limitado a dez colunas                        |
//+-----------------------------------------------+
c_A := IIf(len(a_campos[1])>=1,a_campos[1,1],'' )
c_B := IIf(len(a_campos[1])>=2,a_campos[1,2],'' )
c_C := IIf(len(a_campos[1])>=3,a_campos[1,3],'' )
c_D := IIf(len(a_campos[1])>=4,a_campos[1,4],'' )
c_E := IIf(len(a_campos[1])>=5,a_campos[1,5],'' )
c_F := IIf(len(a_campos[1])>=6,a_campos[1,6],'' )
c_G := IIf(len(a_campos[1])>=7,a_campos[1,7],'' )
c_H := IIf(len(a_campos[1])>=8,a_campos[1,8],'' )
c_I := IIf(len(a_campos[1])>=9,a_campos[1,9],'' )
c_J := IIf(len(a_campos[1])>=10,a_campos[1,10],'' )

//+-----------------------------------------------+
//| Monta a tela para usuario visualizar consulta |
//+-----------------------------------------------+
DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000,000 TO 240,500 PIXEL

@ 110,010 Get c_Obra valid valObra() SIZE 40,08 OF oDlg PIXEL

@ 010,010 LISTBOX oLbx FIELDS HEADER c_A, c_B, c_C, c_D, c_E, c_F, c_G, c_H, c_I, c_J On DBLCLICK (c_Ret := oLbx:AARRAY[oLbx:NAT][nPos], n_ok:= 1, oDlg:End()) SIZE 230,095 OF oDlg PIXEL


oLbx:SetArray( aVetor )

c_Lst := '{|| {aVetor[oLbx:nAt,1],'
For n_x := 2 to len(a_campos[2])-1
	c_Lst += '     aVetor[oLbx:nAt,'+Str(n_x)+'],'
Next
c_Lst += '    aVetor[oLbx:nAt,'+Str(len(a_campos[2]))+']}}'

oLbx:bLine := &c_Lst
c_Ret := &c_Lst

DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION (c_Ret := oLbx:AARRAY[oLbx:NAT][nPos], n_ok:= 1, oDlg:End()) ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg Centered

RestArea( aSalvAmb )

Return c_Ret

Static Function valObra()

l_Ret := .F.

nseek := ascan(oLbx:AARRAY, {|x| ALLTRIM(x[1])	 = ALLTRIM(c_Obra)})

If nseek > 0
	oLbx:NAT := nseek
	l_Ret := .T.
endIf

oDlg:Refresh()
oLbx:Refresh()

If !l_Ret .and. !empty(c_Obra)
	c_Obra := padr(c_Obra, 15)
	msgAlert('Obra nใo localizada!!!', 'A T E N ว ร O')
ElseIf empty(c_Obra)
	c_Obra := space(15)
	l_Ret := .T.
EndIf

Return l_Ret


Static Function GrvDd()

For n_x := 1 to len(aCols)
	For n_y := 2 to len(aHeader)-1
		DbSelectArea('SZC')
		DbSetOrder(3) //ZC_FILIAL, ZC_DATA, ZC_RECURSO, ZC_OBRA, R_E_C_N_O_, D_E_L_E_T_
		If DbSeek(xFilial('SZC')+dtos(ctod(aHeader[n_y, 1]))+aCols[n_x, len(aHeader)])
			RecLock('SZC', .F.)
			SZC->ZC_FILIAL	:= xFilial('SZC')
			SZC->ZC_RECURSO	:= aCols[n_x, len(aHeader)]
			SZC->ZC_DATA	:= ctod(aHeader[n_y, 1])
			SZC->ZC_OBRA	:= aCols[n_x, n_y]
			MsUnLock()
		Else
			If !Empty(aCols[n_x, n_y])
				RecLock('SZC', .T.)
				SZC->ZC_FILIAL	:= xFilial('SZC')
				SZC->ZC_RECURSO	:= aCols[n_x, len(aHeader)]
				SZC->ZC_DATA	:= ctod(aHeader[n_y, 1])
				SZC->ZC_OBRA	:= aCols[n_x, n_y]
				MsUnLock()
			EndIf
		EndIf
	Next
Next

msgAlert('A grava็ใo dos dados ocorreu com sucesso!!!')

Return


/*
Funcao        : FGERAEXCEL()
Objetivo       : Gerar em excel
Autor           :     Flavio Valentin dos Santos
Data/Hora    : 29/08/2011 - 12:00
Revisao       : Nenhuma
Observacao: Especifico Actual Trend - Cliente: Lisonda
*/
*=============================*
Static Function FGERAEXCEL()
*=============================*
Local cDirDocs   := MsDocPath()
Local alCab	     := {}
Local cArquivo   := "APMS001"
Local cPath		 := AllTrim(GetTempPath())
Local oExcelApp
Local nHandle
Local cCrLf 	 := Chr(13) + Chr(10)
Local nX
Local cBuffer   := ""
Local aBuffer   := {}
Local cType		:= "Arquivos Excel (*.csv) |*.csv|"
Local nMaskDef  := 2
Local cDirAtu   := "C:\"
Local cAdmArq	:= 	cGetFile(cType,"Digite o nome do arquivo...",@nMaskDef,cDirAtu )

If Empty(cAdmArq)
	Return
Endif

If UPPER(Substr(cAdmArq,Len(cAdmArq)-3,Len(cAdmArq))) # ".CSV"
	cAdmArq += ".CSV"
EndIf

ProcRegua(Len(aCols)+2)
nHandle := MsfCreate(cAdmArq,0)

If nHandle > 0
	//Grava o cabecalho do arquivo
	IncProc("Aguarde! Gerando arquivo de integra็ใo com Excel...")
	aEval(aHeader, {|e, nX| fWrite(nHandle, e[1] + If(nX < Len(aHeader), ";", "") ) } )
	fWrite(nHandle, cCrLf )//Salta uma linha
	 
	//inserido comando FOR por Mauro Nagata 25/06/2012
	For nX := 1 to Len(aCols) 
	    IncProc("Aguarde! Gerando arquivo de integra็ใo com Excel...")
	    For nY := 1 To Len(aHeader)
		    fWrite(nHandle, Transform(aCols[nX,nY],"@!") + ";" )
		Next    
		fWrite(nHandle, cCrLf )//Pula linha 
		
	Next
	
	    
	/*    substituido o comando For por Mauro Nagata 25/06/2012
	For nX := 1 to Len(aCols) 
	    IncProc("Aguarde! Gerando arquivo de integra็ใo com Excel...")
		fWrite(nHandle, Transform(aCols[nX,1],"@!") + ";" )
		fWrite(nHandle, Transform(aCols[nX,2],"@!") + ";" )
		fWrite(nHandle, Transform(aCols[nX,3],"@!") + ";" )
		fWrite(nHandle, Transform(aCols[nX,4],"@!") + ";" )
		fWrite(nHandle, Transform(aCols[nX,5],"@!") + ";" )
		fWrite(nHandle, Transform(aCols[nX,6],"@!") + ";" )
		fWrite(nHandle, Transform(aCols[nX,7],"@!") + ";" )
		fWrite(nHandle, Transform(aCols[nX,8],"@!") + ";" )
		fWrite(nHandle, Transform(aCols[nX,9],"@!") + ";" )
		fWrite(nHandle, Transform(aCols[nX,10],"@!") + ";" )
		fWrite(nHandle, Transform(aCols[nX,11],"@!") + ";" )
		fWrite(nHandle, Transform(aCols[nX,12],"@!") + ";" )
		fWrite(nHandle, Transform(aCols[nX,13],"@!") + ";" )
		fWrite(nHandle, Transform(aCols[nX,14],"@!") + ";" )
		fWrite(nHandle, Transform(aCols[nX,15],"@!") + ";" )
		fWrite(nHandle, Transform(aCols[nX,16],"@!") + ";" )
		fWrite(nHandle, Transform(aCols[nX,17],"@!") + ";" )
		fWrite(nHandle, Transform(aCols[nX,18],"@!") + ";" )
		fWrite(nHandle, Transform(aCols[nX,19],"@!") + ";" )
		fWrite(nHandle, Transform(aCols[nX,20],"@!") + ";" )
		fWrite(nHandle, Transform(aCols[nX,21],"@!") + ";" )
		fWrite(nHandle, Transform(aCols[nX,22],"@!") + ";" )
		fWrite(nHandle, Transform(aCols[nX,23],"@!") + ";" )
		fWrite(nHandle, Transform(aCols[nX,24],"@!") + ";" )
		fWrite(nHandle, Transform(aCols[nX,25],"@!") + ";" )
		fWrite(nHandle, Transform(aCols[nX,26],"@!") + ";" )
		fWrite(nHandle, Transform(aCols[nX,27],"@!") + ";" )
		fWrite(nHandle, Transform(aCols[nX,28],"@!") + ";" )
		fWrite(nHandle, Transform(aCols[nX,29],"@!") + ";" )
		fWrite(nHandle, Transform(aCols[nX,30],"@!") + ";" )
		fWrite(nHandle, Transform(aCols[nX,31],"@!") + ";" )
		fWrite(nHandle, Transform(aCols[nX,32],"@!") + ";" )
		fWrite(nHandle, Transform(aCols[nX,33],"@!") + ";" )
		fWrite(nHandle, Transform(aCols[nX,34],"@!") + ";" )
		fWrite(nHandle, cCrLf )//Pula linha 
		
	Next
	*/

	IncProc("Aguarde! Abrindo o arquivo...")
	
	fClose(nHandle)
	CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )
	
	If !ApOleClient("MsExcel")
		MsgAlert("MsExcel nao instalado")
		Return
	EndIf
	
	MsgInfo("Arquivo gerado em "+cAdmArq)  
	
Else
	MsgAlert( "Falha na cria็ใo do arquivo" )
EndIf

Return