#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "SHELL.CH"
#INCLUDE "FWPrintSetup.ch"
#include "totvs.ch"
#include "fwmvcdef.ch"


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัออออออออออออออปฑฑ
ฑฑบPrograma  ณ RCRMR010  บAutor  ณ Derik Santos      บ Data ณ  22/11/2016  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para impressใo do relatorio de forecast Newforcast   บฑฑ
ฑฑบDesc.     ณ Prozyn - Protheus 12                                        บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Protheus 12 - Prozyn                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออออนฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function RCRMR010()

Local ACLIENTES		:={}
Local ACLIENTES7	:={}
Local aGerAtu		:= {}

Private _aSavArea	:= GetArea()
Private _aSavArea2 	:= GetArea()
Private _aSavArea3 	:= GetArea()
Private _cRotina	:= "RCRMR002"
Private _cAlias		:= ""
Private cAlias		:= ""
Private oFont01		:= TFont():New( "Arial",,20,,.T.,,,,.F.,.F.) //Arial 18 - Negrito
Private oFont02		:= TFont():New( "Arial",,12,,.T.,,,,.F.,.F.) //Arial 11 - Negrito
Private oFont03		:= TFont():New( "Arial",,09,,.T.,,,,.F.,.F.) //Arial 09 - Negrito
Private oFont04		:= TFont():New( "Arial",,08,,.F.,,,,.F.,.F.) //Arial 09 - Normal
Private oFont05		:= TFont():New( "Arial",,14,,.F.,,,,.F.,.F.) //Arial 09 - Normal
Private cDesc 		:= ""
Private _lPreview	:= .T.
Private cPerg		:= "RCRMR002"
Private oGet1
Private oGet2
Private oGet3
Private _cBuscar	:= Space(4)
Private _cDe		:= Space(6)
Private _cAte		:= Space(6)
Private oGroup1
Private oGroup2
Private oSay1
Private oSay3      
private _nBuscar :=Space(04)
Private oComboBo1
Private nComboBo1
Private _aFiltro
Private aDados:={}
Private aTitulos:={}
Private oOkm			:= LoadBitMap(GetResources(),"LBOK")
Private oNom			:= LoadBitMap(GetResources(),"NADA")
Private aLabel	:= {" ","Filtros"}
Private oDlg
Private oList1,oList2,oList4,oList7
Private aGrid2 := {}
Private cGerAtu := ""
Static oDlg2

AAdd(aTitulos,{.F.,;
AllTrim('1 - Geral Empresa')})
AAdd(aTitulos,{.F.,;
AllTrim('2 - Unidade de Neg๓cio')})
AAdd(aTitulos,{.F.,;
AllTrim('3 - Gerente de Conta')})
AAdd(aTitulos,{.F.,;
AllTrim('4 - Segmentos')})
AAdd(aTitulos,{.F.,;
AllTrim('5 - Produtos')})
AAdd(aTitulos,{.F.,;
AllTrim('6 - Clientes')})
AAdd(aTitulos,{.F.,;
AllTrim('7 - Produto x Cliente')})
AAdd(aTitulos,{.F.,;
AllTrim('8 - Grupo de Clientes')})
AAdd(aTitulos,{.F.,;
AllTrim('9 - Nenhum')})

_cMoeda:=''  
_cNet:=''

DEFINE MSDIALOG oDlg TITLE "Filtros do Forecast" FROM 000, 000  TO 600, 800 COLORS 0, 16777215 PIXEL

_dBuscar:= year(ddatabase)
_nBuscar:= cvaltochar(_dBuscar)
_aItcbb := {"1=Real","2=Dolar"}       
_aItcbn := {"1=Net","2=Bruto"}
aGerAtu := {"1=Sim","2=Nใo"}

@ 025,003 LISTBOX oList3 VAR cList3 Fields HEADER ;           //Escreve o titulo das colunas da Grid  inicio
aLabel[1],;
aLabel[2];
SIZE 105,380  PIXEL //Escreve o titulo das colunas da Grid  inicio//SIZE 463,175  NOSCROLL PIXEL //Escreve o titulo das colunas da Grid  inicio
@ 277,002 BUTTON oButton1 PROMPT "Parametros" SIZE 0107, 022 OF oDlg ACTION fParame(aTitulos,oDlg) PIXEL
@ 007, 002 SAY oSay1 PROMPT "Ano:"        	SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 005, 022 MSGET oGet2 VAR _nBuscar 	    SIZE 075, 010 OF oDlg COLORS 0, 16777215 PIXEL 
@ 007, 100 SAY oSay2 PROMPT "Moeda:"        	SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 005, 120 ComboBox _cMoeda Items _aItcbb Size 050,012 PIXEL OF oDlg COLORS 0, 16777215 PIXEL       
@ 007, 175 SAY oSay3 PROMPT "Impostos:"        	SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 005, 203 ComboBox _cNet Items _aItcbn Size 050,012 PIXEL OF oDlg COLORS 0, 16777215 PIXEL 

@ 007, 258 SAY oSay3 PROMPT "Ger.Atual:"        	SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 005, 287 ComboBox cGerAtu Items aGerAtu Size 050,012 PIXEL OF oDlg COLORS 0, 16777215 PIXEL 



oList3:SetArray(aTitulos)


oList3:bLine	:= {|| {	If(aTitulos[oList3:nAt,1], oOkm, oNom),; 	//
aTitulos[oList3:nAt,2]}}


oList3:blDblClick 	:= {|| fValid(aTitulos),, oList3:Refresh() } //Carrega a linha selecionada com o contrario do atual e atualiza o objeto para mostrar ao usuario

lSortOrd := .F. // Ordena ascendente ou descendente


//oList3:bHeaderClick := {|| fSelectAll(aTitulos,oList1)}//:= Ascan(aTitulos,{|x|x[1]==cVarPesq})}


oList3:cToolTip		:= "Duplo click para marcar/desmarcar o produto"



oList3:Refresh()


ACTIVATE MSDIALOG oDlg CENTERED

RestArea(_aSavArea2)

Return()

Static Function fParame(aTitulos,oDlg)

Local nJ		:= 0

Private oOkm			:= LoadBitMap(GetResources(),"LBOK")
Private oNom			:= LoadBitMap(GetResources(),"NADA")
Private aTitu2:={}
Private aLabel7	:= {" ","Cod Cliente","Loja","Descri็ใo","Cnpj/CGC"}
Private aLabel71 := {" ","Cod Cliente","Loja","Nome","Cod Produto", "Produto"}
Private aLabel2	:= {" ","Filtros"}
Private aLabelV	:= {" ","Cod Vend","Nome"}
Private aLabel8	:= {" ","Cod ","Nome","Tipo"}
Private ACLIENTES:={}
Private ACLIENTES7:={}
Private avEND:={}
Private cBusca:=Space(40) 
Private cBusca3:=Space(40)
Close(oDlg)


nLinha:=005
ncoluna := 113
DEFINE MSDIALOG oDlg2 TITLE "Filtros do Forecast" FROM 000, 000  TO 600, 800 COLORS 0, 16777215 PIXEL


@ 005,003 LISTBOX oList3 VAR cList3 Fields HEADER ;           //Escreve o titulo das colunas da Grid  inicio
aLabel[1],;
aLabel[2];
SIZE 105,380   PIXEL //Escreve o titulo das colunas da Grid  inicio//SIZE 463,175  NOSCROLL PIXEL //Escreve o titulo das colunas da Grid  inicio
nVal :=0
For nJ :=  1 To len(aTitulos)
	nVal := 180
	
	If Substr(aTitulos[nJ][2],1,1)=='4' .and.  aTitulos[nJ][1] // FILTRO SEGMENTO
		@ nLinha, ncoluna GROUP oGroup4 TO 180, 490 PROMPT " Filtros Segmento :" 	OF oDlg2 COLOR 0, 16777215 PIXEL
		@ nLinha+40, ncoluna+150 SAY oSay1 PROMPT "Segmento:"        	SIZE 030, 007 OF oDlg2 COLORS 0, 16777215 PIXEL
		@ nLinha+50, ncoluna+150 MSGET oGet2 VAR _cDe 	    SIZE 037, 010 OF oDlg2 COLORS 0, 16777215 PIXEL F3 "AOV"
		//@ nLinha, ncoluna MSGET oGet2 VAR _cDe 	    SIZE 037, 010 OF oDlg2 COLORS 0, 16777215 PIXEL F3 "AOV"
		nLinha:=197
		ncoluna := 113
		
	ElseIf Substr(aTitulos[nJ][2],1,1)=='3' .and.  aTitulos[nJ][1]      // FILTRO VENDEDOR
		
		If Select("TMP") > 0
			TMP->(DBCLOSEAREA())
		EndIf
		cQry := "SELECT * FROM SA3010 where D_E_L_E_T_ = ''"

		/* Alterado por Denis 15/08/2022 */
		cUsuario := RetCodUsr()
		DbSelectArea("SA3")
		SA3->(DbSetOrder(7))
		If SA3->(DbSeek(xFilial("SA3")+cUsuario)) .and. SA3->A3_XTIPO == 'V'
			cQry += " AND A3_COD = '"+SA3->A3_COD+"'
		EndIf

		cQry:= ChangeQuery(cQry)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TMP",.T.,.F.)
		
		
		While !TMP->(EOF())
			Aadd(avEND,{.F.,;
			TMP->A3_COD,;
			TMP->A3_NOME})
			
			TMP->(DBSKIP())
		EndDo

		@ nLinha,ncoluna LISTBOX oList2 VAR cList1 Fields HEADER ;           //Escreve o titulo das colunas da Grid  inicio
		aLabelV[1],;
		aLabelV[2],;
		aLabelV[3];
		SIZE 290,090   PIXEL //Escreve o titulo das colunas da Grid  inicio//SIZE 463,175  NOSCROLL PIXEL //Escreve o titulo das colunas da Grid  inicio
		oList2:SetArray(avEND)
		oList2:cToolTip		:= "Duplo click para marcar/desmarcar o produto"
		oList2:bLine	:= {|| {	If(avEND[oList2:nAt,1], oOkm, oNom),; 	//
		avEND[oList2:nAt,2],;
		avEND[oList2:nAt,3]}}
		oList2:blDblClick 	:= {|| fSelecuni(avEND,oList2), oList2:Refresh() } //Carrega a linha selecionada com o contrario do atual e atualiza o objeto para mostrar ao usuario
		oList2:bHeaderClick := {|| fSelecuni(avEND,oList2)}//:= Ascan(aTitulos,{|x|x[1]==cVarPesq})}
		oList2:Refresh()

		//Pesquisa
		GetPosReg("2-Codigo;3-Nome", @oDlg2, avEND, @oList2, 100+nLinha)

		nLinha:=157
		ncoluna := 113
		
		
	ElseIf Substr(aTitulos[nJ][2],1,1)=='2' .and.  aTitulos[nJ][1]   // FILTRO UNIDADE DE NEGOCIO
		If nLinha == 197
			nVal := 265
		Endif
		@ nLinha, ncoluna GROUP oGroup2 TO nVal, 490 PROMPT " Filtros Unidade de Negocio :" 	OF oDlg2 COLOR 0, 16777215 PIXEL
		@ nLinha+40, ncoluna+150 SAY oSay1 PROMPT "Unid Negocio:"        	SIZE 030, 007 OF oDlg2 COLORS 0, 16777215 PIXEL
		@ nLinha+50, ncoluna+150 MSGET oGet2 VAR _cDe 	    SIZE 037, 010 OF oDlg2 COLORS 0, 16777215 PIXEL F3 "ADK"
		//@ nLinha, ncoluna MSGET oGet2 VAR _cDe 	    SIZE 037, 010 OF oDlg2 COLORS 0, 16777215 PIXEL F3 "ADK"
		nLinha:=157
		ncoluna := 113
	elseIf Substr(aTitulos[nJ][2],1,1)=='6' .and.  aTitulos[nJ][1]   // FILTRO CLIENTE
		
		If Select("TMP") > 0
			TMP->(DBCLOSEAREA())
		EndIf
		cQry := "SELECT A1_COD,A1_LOJA,A1_NOME,A1_NREDUZ,A1_CGC FROM SA1010 where D_E_L_E_T_ = ''"
		cQry:= ChangeQuery(cQry)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TMP",.T.,.F.)
		
		
		While !TMP->(EOF())
			Aadd(aClientes,{.F.,;
			TMP->A1_COD,;
			TMP->A1_LOJA,;
			TMP->A1_NREDUZ,;
			TMP->A1_CGC})
			
			TMP->(DBSKIP())
		EndDo
		@ nLinha,ncoluna LISTBOX oList4 VAR cList1 Fields HEADER ;           //Escreve o titulo das colunas da Grid  inicio
		aLabel71[1],;
		aLabel71[2],;
		aLabel71[3],;
		aLabel71[4],;
		aLabel71[5],;
		aLabel71[6];
		SIZE 290,090   PIXEL //Escreve o titulo das colunas da Grid  inicio//SIZE 463,175  NOSCROLL PIXEL //Escreve o titulo das colunas da Grid  inicio
		
		oList4:SetArray(aClientes)
		oList4:cToolTip		:= "Duplo click para marcar/desmarcar o produto"
		oList4:bLine	:= {|| {	If(aClientes[oList4:nAt,1], oOkm, oNom),; 	//
		aClientes[oList4:nAt,2],;
		aClientes[oList4:nAt,3],;
		aClientes[oList4:nAt,4],;
		aClientes[oList4:nAt,5]}}
		oList4:blDblClick 	:= {|| aClientes[oList4:nAt,1] := !aClientes[oList4:nAt,1], oList4:Refresh() } //Carrega a linha selecionada com o contrario do atual e atualiza o objeto para mostrar ao usuario
		oList4:bHeaderClick := {|| fSelectAll(aClientes,oList4)}//:= Ascan(aTitulos,{|x|x[1]==cVarPesq})}
		oList4:Refresh()

		//Pesquisa
		GetPosReg("2-Codigo;4-Nome", @oDlg2, aClientes, @oList4, 100+nLinha)
		
		ncoluna:=113
		nLinha:=250
		//@ nLinha,ncoluna MSGET olDgg VAR cBusca SIZE 250, 010 OF oDlg2  COLORS 0, 16777215 PIXEL
		//@ nLinha,365 BUTTON "Filtrar" SIZE 025, 011 PIXEL OF oDlg2 ACTION fSort(aClientes,cBusca,oList4,"C",oDlg2)//FTROCAR(aTitulos,oDlg1)
		
		nLinha:=157
		ncoluna := 113
	elseIf Substr(aTitulos[nJ][2],1,1)=='8' .and.  aTitulos[nJ][1]    // FILTRO GRUPO DE CLIENTE
		If nLinha == 197
			nVal := 365
		Endif
		@ nLinha, ncoluna GROUP oGroup8 TO nVal, 490 PROMPT " Filtros Grupo de Clientes :" 	OF oDlg2 COLOR 0, 16777215 PIXEL
		@ nLinha+40, ncoluna+150 SAY oSay1 PROMPT "Grp Clientes:"        	SIZE 030, 007 OF oDlg2 COLORS 0, 16777215 PIXEL
		@ nLinha+50, ncoluna+150 MSGET oGet2 VAR _cDe 	    SIZE 037, 010 OF oDlg2 COLORS 0, 16777215 PIXEL F3 "ACY"
	elseIf Substr(aTitulos[nJ][2],1,1)=='5' .and.  aTitulos[nJ][1]   // FILTRO PRODUTO
		If nLinha == 197
			nVal := 365
		Endif
If Select("TMP") > 0
			TMP->(DBCLOSEAREA())
		EndIf
		cQry := "SELECT B1_COD,B1_DESC,B1_TIPO FROM SB1010 where D_E_L_E_T_ = ''"
		cQry:= ChangeQuery(cQry)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TMP",.T.,.F.)
		
		aProd:={}
		
		While !TMP->(EOF())
			Aadd(aProd,{.F.,;
			TMP->B1_COD,;
			TMP->B1_DESC,;
			TMP->B1_TIPO})
			
			TMP->(DBSKIP())
		EndDo
		@ nLinha,ncoluna LISTBOX oList7 VAR cList1 Fields HEADER ;           //Escreve o titulo das colunas da Grid  inicio
		aLabel8[1],;
		aLabel8[2],;
		aLabel8[3],;
		aLabel8[4];
		SIZE 290,090   PIXEL //Escreve o titulo das colunas da Grid  inicio//SIZE 463,175  NOSCROLL PIXEL //Escreve o titulo das colunas da Grid  inicio
		
		oList7:SetArray(aProd)
		oList7:cToolTip		:= "Duplo click para marcar/desmarcar o produto"
		oList7:bLine	:= {|| {	If(aProd[oList7:nAt,1], oOkm, oNom),; 	//
		aProd[oList7:nAt,2],;
		aProd[oList7:nAt,3],;
		aProd[oList7:nAt,4]}}
		oList7:blDblClick 	:= {|| aProd[oList7:nAt,1] := !aProd[oList7:nAt,1], oList7:Refresh() } //Carrega a linha selecionada com o contrario do atual e atualiza o objeto para mostrar ao usuario
		oList7:bHeaderClick := {|| fSelectAll(aProd,oList7)}//:= Ascan(aTitulos,{|x|x[1]==cVarPesq})}
		oList7:Refresh()
		
		//Pesquisa
		GetPosReg("2-Codigo;3-Nome", @oDlg2, aProd, @oList7, 100+nLinha)

		
		ncoluna:=113
		nLinha:=100 
		//@ nLinha,ncoluna MSGET olDgg VAR cBusca3 SIZE 250, 010 OF oDlg2  COLORS 0, 16777215 PIXEL
		//@ nLinha,365 BUTTON "Filtrar" SIZE 025, 011 PIXEL OF oDlg2 ACTION fSort(aProd,cBusca3,oList7,"P",oDlg2)
			nLinha:=157
		ncoluna := 113
	elseIf Substr(aTitulos[nJ][2],1,1)=='7' .and.  aTitulos[nJ][1]   // FILTRO PRODTO X CLIENTE
		
		If Select("TMP") > 0
			TMP->(DBCLOSEAREA())
		EndIf
		cQry := "SELECT A7_CLIENTE,A7_LOJA,A7_NOMECLI,A7_PRODUTO,A7_NOMEPRO FROM SA7010 A7 where A7.D_E_L_E_T_ = ''"
		cQry:= ChangeQuery(cQry)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TMP",.T.,.F.)
		
		
		While !TMP->(EOF())
			Aadd(aClientes7,{.F.,;
			TMP->A7_CLIENTE,;
			TMP->A7_LOJA,;
			trim(TMP->A7_NOMECLI),;
			TMP->A7_PRODUTO,;
			trim(TMP->A7_NOMEPRO)})
			
			TMP->(DBSKIP())
		EndDo
		@ nLinha,ncoluna LISTBOX oList4 VAR cList1 Fields HEADER ;           //Escreve o titulo das colunas da Grid  inicio
		aLabel71[1],;
		aLabel71[2],;
		aLabel71[3],;
		aLabel71[4],;
		aLabel71[5],;
		aLabel71[6];
		SIZE 290,090   PIXEL //Escreve o titulo das colunas da Grid  inicio//SIZE 463,175  NOSCROLL PIXEL //Escreve o titulo das colunas da Grid  inicio
		
		oList4:SetArray(aClientes7)
		oList4:cToolTip		:= "Duplo click para marcar/desmarcar o produto"
		oList4:bLine	:= {|| {	If(aClientes7[oList4:nAt,1], oOkm, oNom),; 	//
		aClientes7[oList4:nAt,2],;
		aClientes7[oList4:nAt,3],;
		aClientes7[oList4:nAt,4],;
		aClientes7[oList4:nAt,5],;
		aClientes7[oList4:nAt,6]}}
		oList4:blDblClick 	:= {|| aClientes7[oList4:nAt,1] := !aClientes7[oList4:nAt,1], oList4:Refresh() } //Carrega a linha selecionada com o contrario do atual e atualiza o objeto para mostrar ao usuario
		oList4:bHeaderClick := {|| fSelectAll(aClientes7,oList4)}//:= Ascan(aTitulos,{|x|x[1]==cVarPesq})}
		oList4:Refresh()

		//Pesquisa
		GetPosReg("2-Cod.Cliente;4-Nome Cliente;5-Produto;6-Desc.Produto", @oDlg2, aClientes7, @oList4, 100+nLinha)
		
		
		ncoluna:=113
		nLinha:=250
		
		
		//@ nLinha,ncoluna MSGET olDgg VAR cBusca SIZE 250, 010 OF oDlg2  COLORS 0, 16777215 PIXEL
		//@ nLinha,365 BUTTON "Filtrar" SIZE 025, 011 PIXEL OF oDlg2 ACTION fSort(aClientes7,cBusca,oList4,"CP",oDlg2)//FTROCAR(aTitulos,oDlg1)
		
		nLinha:=157
		ncoluna := 113
	/*
		If nLinha == 197
			nVal := 365
		Endif
		@ nLinha, ncoluna GROUP oGroup7 TO nVal, 490 PROMPT " Filtros Prod X Cliente :" 	OF oDlg2 COLOR 0, 16777215 PIXEL
		@ nLinha+40, ncoluna+150 SAY oSay1 PROMPT "Prd x Clientes:"        	SIZE 030, 007 OF oDlg2 COLORS 0, 16777215 PIXEL
		@ nLinha+50, ncoluna+150 MSGET oGet2 VAR _cDe 	    SIZE 037, 010 OF oDlg2 COLORS 0, 16777215 PIXEL F3 "SA71"
		//@ nLinha, ncoluna MSGET oGet2 VAR _cDe 	    SIZE 037, 010 OF oDlg2 COLORS 0, 16777215 PIXEL F3 "SA17"
		nLinha:=197
		ncoluna := 113
	*/		
	elseIf aTitulos[nJ][1]
		
	EndIf
	oList3:SetArray(aTitulos)
	
	
Next

@ 277,002 BUTTON oButton1 PROMPT "Limpar" SIZE 0107, 022 OF oDlg2 ACTION fLimpar(oDlg2) PIXEL
@ 277,113 BUTTON oButton1 PROMPT "Gerar" SIZE 0289, 022 OF oDlg2 ACTION Imp(aTitulos,_cDe,_cAte,oDlg2) PIXEL






oList3:bLine	:= {|| {	If(aTitulos[oList3:nAt,1], oOkm, oNom),; 	//
aTitulos[oList3:nAt,2]}}


//oList3:blDblClick 	:= {|| aTitulos[oList3:nAt,1] := !aTitulos[oList3:nAt,1], oList3:Refresh() } //Carrega a linha selecionada com o contrario do atual e atualiza o objeto para mostrar ao usuario

lSortOrd := .F. // Ordena ascendente ou descendente


//oList3:bHeaderClick := {|| fSelectAll(aTitulos,oList1)}//:= Ascan(aTitulos,{|x|x[1]==cVarPesq})}


oList3:cToolTip		:= "Duplo click para marcar/desmarcar o produto"






oList3:Refresh()
ACTIVATE MSDIALOG oDlg2 CENTERED


Return

Static Function Filtro()

Local _aRet := {}
AAdd(_aRet,AllTrim('1 - Geral Empresa'))
AAdd(_aRet,AllTrim('2 - Unidade de Neg๓cio'))
AAdd(_aRet,AllTrim('3 - Gerente de Conta'))
AAdd(_aRet,AllTrim('4 - Segmentos'))
AAdd(_aRet,AllTrim('5 - Produtos'))
AAdd(_aRet,AllTrim('6 - Clientes'))
AAdd(_aRet,AllTrim('7 - Produto x Cliente'))
AAdd(_aRet,AllTrim('8 - Grupo de Clientes'))
AAdd(_aRet,AllTrim('9 - Nenhum'))
oDlg:refresh()
Return(_aRet)

Static Function Imp(aTitulos,_cDe,_cAte)
  	
  	Local nV	:= 0
  	Local nF	:= 0
  	
	if _nBuscar = " "
	MSGALERT("Parโmetro Periodo, nใo preenchido", "ALERTA")
	Return()
	Endif
	
// verificar parametro preenchido aTitulos
	nTruef:= 0
	For nF := 1 to len(aTitulos)
		If aTitulos[nF][1]
			nCombov:=aTitulos[nF][2]   
			nTruef++
		endif
	next
	
	if nTruef= 0
		MSGALERT("Parโmetro Filtros, nใo preenchido", "ALERTA")
	Return()
	Endif 


	if SubStr(nCombov,1,1) == "2" .or. SubStr(nCombov,1,1) == "4" .or. SubStr(nCombov,1,1) == "8"
		if _cDe =" "
		MSGALERT("Parโmetro Un.Neg. ou Segm. ou Grp.Clientes, nใo preenchido", "ALERTA")
		Return()
		Endif
	Endif	

	// verificar parametro preenchido aVend	

if SubStr(nCombov,1,1) == "3"
	nTruev:= 0
		For nV := 1 to len(aVend)
			If aVend[nV][1]
				nTruev++
			endif
		next
		
		if nTruev= 0
			MSGALERT("Parโmetro Vendedores, nใo preenchido", "ALERTA")
			Return()
		Endif 
Endif	
Close(oDlg2)

//Abre tela de parametros para defini็ใo do usuแrio
Processa({|lEnd| ImpRelat()},_cRotina,"Aguarde... Processando a impressใo do(s) relatorio(s), aguarde...",.T.)



//Restauro a แrea de trabalho original
RestArea(_aSavArea)

Return()

Static Function ImpRelat()


Local _cFile	:= 'Forecast'
Local _nTipoImp	:= IMP_PDF
Local _lPropTMS	:= .F.
Local _lDsbSetup:= .T.
Local _lTReport	:= .F.
Local _cPrinter	:= ""
Local _lServer	:= .F.
Local _lPDFAsPNG:= .T.
Local _lRaw		:= .F.
Local _lViewPDF	:= .T.
Local _nQtdCopy	:= 1
Local nN		:= 0
Local nVend		:= 0
Local nI		:= 0
Local nA		:= 0

Private oPrinter

_cAlias		:= GetNextAlias()
cAlias		:= GetNextAlias()
cAlias2		:= GetNextAlias()        /////////////////////
_nLin   	:= 20
_nVol		:= 0
_nTotal 	:= 0
_nPrect  	:= 0
_nPrec		:= 0
_nNum		:= 0
_nEspPad	:= 020 //Espa็amento padrใo entre linhas
_nLinFin	:= 570 //Linha final para impressใo
oBrush1     := TBrush():New( , CLR_GRAY)
_nBuscar2   := val(_nBuscar)  + 1   
_nBuscar    :=val(_nBuscar)
_cCodCli    := ""
_cLojaCli   := ""
_cCodProd   := ""

_cPrecAtu  := 0
_cPrecPos  := 0
_cPrecBud  := 0

_fTotAtuQt := 0
_fTotPosQt := 0
_bTotAtuQt := 0
_fTotAtuVl := 0
_fTotPosVl := 0
_bTotAtuVl := 0

_fJanAtuQt := 0
_fFevAtuQt := 0
_fMarAtuQt := 0
_fAbrAtuQt := 0
_fMaiAtuQt := 0
_fJunAtuQt := 0
_fJulAtuQt := 0
_fAgoAtuQt := 0
_fSetAtuQt := 0
_fOutAtuQt := 0
_fNovAtuQt := 0
_fDezAtuQt := 0

_fJanPosQt := 0
_fFevPosQt := 0
_fMarPosQt := 0
_fAbrPosQt := 0
_fMaiPosQt := 0
_fJunPosQt := 0
_fJulPosQt := 0
_fAgoPosQt := 0
_fSetPosQt := 0
_fOutPosQt := 0
_fNovPosQt := 0
_fDezPosQt := 0

_bJanAtuQt := 0
_bFevAtuQt := 0
_bMarAtuQt := 0
_bAbrAtuQt := 0
_bMaiAtuQt := 0
_bJunAtuQt := 0
_bJulAtuQt := 0
_bAgoAtuQt := 0
_bSetAtuQt := 0
_bOutAtuQt := 0
_bNovAtuQt := 0
_bDezAtuQt := 0

_fJanAtuVl := 0
_fFevAtuVl := 0
_fMarAtuVl := 0
_fAbrAtuVl := 0
_fMaiAtuVl := 0
_fJunAtuVl := 0
_fJulAtuVl := 0
_fAgoAtuVl := 0
_fSetAtuVl := 0
_fOutAtuVl := 0
_fNovAtuVl := 0
_fDezAtuVl := 0

_fJanPosVl := 0
_fFevPosVl := 0
_fMarPosVl := 0
_fAbrPosVl := 0
_fMaiPosVl := 0
_fJunPosVl := 0
_fJulPosVl := 0
_fAgoPosVl := 0
_fSetPosVl := 0
_fOutPosVl := 0
_fNovPosVl := 0
_fDezPosVl := 0

_bJanAtuVl := 0
_bFevAtuVl := 0
_bMarAtuVl := 0
_bAbrAtuVl := 0
_bMaiAtuVl := 0
_bJunAtuVl := 0
_bJulAtuVl := 0
_bAgoAtuVl := 0
_bSetAtuVl := 0
_bOutAtuVl := 0
_bNovAtuVl := 0
_bDezAtuVl := 0

_PrJanPos := 0
_PrFevPos := 0
_PrMarPos := 0
_PrAbrPos := 0
_PrMaiPos := 0
_PrJunPos := 0
_PrJulPos := 0
_PrAgoPos := 0
_PrSetPos := 0
_PrOutPos := 0
_PrNovPos := 0
_PrDezPos := 0
_PrTotPos := 0

_PrJanBud := 0
_PrFevBud := 0
_PrMarBud := 0
_PrAbrBud := 0
_PrMaiBud := 0
_PrJunBud := 0
_PrJulBud := 0
_PrAgoBud := 0
_PrSetBud := 0
_PrOutBud := 0
_PrNovBud := 0
_PrDezBud := 0
_PrTotBud := 0

_PrJanAtu := 0
_PrFevAtu := 0
_PrMarAtu := 0
_PrAbrAtu := 0
_PrMaiAtu := 0
_PrJunAtu := 0
_PrJulAtu := 0
_PrAgoAtu := 0
_PrSetAtu := 0
_PrOutAtu := 0
_PrNovAtu := 0
_PrDezAtu := 0
_PrTotAtu := 0

_aPJanAtu := {}  
nComboBo2:=''
For nN := 1 to len(aTitulos)
If aTitulos[nN][1]
iF Empty(nComboBo1) 
nComboBo1:=aTitulos[nN][2]   
ElseiF Empty(nComboBo2)
nComboBo2:=aTitulos[nN][2]
EndIf  
EndIf
Next    


For nVend := 1 to len(avEND)
	If avEND[nVend,1] == .T. 
		If trim(_cDe) != ''
			_cDe += "','"
		EndIf
		_cDe += avEND[nVend,2]
	EndIf
Next

//Seleciono as etiquetas a serem impressas
_cQuery	:= " SELECT * "
_cQuery += " FROM " + RetSqlName("SZ2") + " SZ2 "  

//Filtro por Unidade de Neg๓cio
If SubStr(nComboBo1,1,1) == "2" .Or. SubStr(nComboBo2,1,1) == "2"  

	_cQuery += " INNER JOIN " + RetSqlName("SA7") + " A7 "
	_cQuery += " ON  A7.A7_CLIENTE = SZ2.Z2_CLIENTE "                 
	_cQuery += " AND A7.A7_LOJA = SZ2.Z2_LOJA "
	_cQuery += " AND A7.A7_PRODUTO = SZ2.Z2_PRODUTO "
	_cQuery += " AND A7.D_E_L_E_T_='' "
	_cQuery += " AND A7.A7_FILIAL='"+xFilial("SA7")+"' "  
	
	_cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 "
	_cQuery += " ON  SA1.A1_COD = SZ2.Z2_CLIENTE "
	_cQuery += " AND SA1.A1_LOJA = SZ2.Z2_LOJA "
	_cQuery += " AND SA1.D_E_L_E_T_='' "
	_cQuery += " AND SA1.A1_FILIAL='"+xFilial("SA1")+"' "
	
	cUsuario := RetCodUsr()
	DbSelectArea("SA3")
	SA3->(DbSetOrder(7))
	If SA3->(DbSeek(xFilial("SA3")+cUsuario)) .and. SA3->A3_XTIPO == 'V'
		_cQuery += " AND SA1.A1_VEND = '"+SA3->A3_COD+"' "
	EndIf
	
	_cQuery += " INNER JOIN " + RetSqlName("SA3") + " SA3 "
	_cQuery += " ON  SA3.A3_COD = SA1.A1_VEND "
	_cQuery += " AND SA3.D_E_L_E_T_='' "
	_cQuery += " AND SA3.A3_FILIAL='"+xFilial("SA3")+"' " 
	
	_cQuery += " INNER JOIN " + RetSqlName("AOV") + " AOV "
	_cQuery += " ON  AOV.AOV_CODSEG = A7.A7_XSEGMEN "
	_cQuery += " AND AOV.D_E_L_E_T_='' "
	_cQuery += " AND AOV.AOV_FILIAL='"+xFilial("AOV")+"' "     
	
	_cQuery += " WHERE Z2_ANO BETWEEN "+ALLTRIM(STR(_nBuscar))+" AND "+ALLTRIM(STR(_nBuscar2))+" " 
	_cQuery += " AND SUBSTRING(AOV_XUNEG,1,1) = SUBSTRING('" +ALLTRIM(_cDe) + "',6,1) "
	_cQuery += " AND SZ2.Z2_ANO BETWEEN "+ALLTRIM(STR(_nBuscar))+" AND "+ALLTRIM(STR(_nBuscar2))+" "
	_cQuery += " AND SZ2.Z2_FILIAL='"+xFilial("SZ2")+"' "
	_cQuery += " AND SZ2.D_E_L_E_T_='' "
	//_cQuery += " AND SZ2.Z2_TOPICO = 'F' "
	_cQuery += " AND (SZ2.Z2_QTM01>0 OR SZ2.Z2_QTM02>0 OR SZ2.Z2_QTM03>0 OR SZ2.Z2_QTM04>0 OR SZ2.Z2_QTM05>0 OR SZ2.Z2_QTM06>0 OR SZ2.Z2_QTM07>0 OR SZ2.Z2_QTM08>0 OR SZ2.Z2_QTM09>0 OR SZ2.Z2_QTM10>0 OR SZ2.Z2_QTM11>0 OR SZ2.Z2_QTM12>0) " 
	
	_cQuery += " ORDER BY SZ2.Z2_ANO, SZ2.Z2_TOPICO "

//Filtro Vendedor
ELSEIf SubStr(nComboBo1,1,1) == "3" .Or. SubStr(nComboBo2,1,1) == "3"
	_cQuery += " INNER JOIN " + RetSqlName("SA7") + " A7 "
	_cQuery += " ON  A7.A7_CLIENTE = SZ2.Z2_CLIENTE "
	_cQuery += " AND A7.A7_LOJA = SZ2.Z2_LOJA "
	_cQuery += " AND A7.A7_PRODUTO = SZ2.Z2_PRODUTO "
	_cQuery += " AND A7.D_E_L_E_T_='' "
	_cQuery += " AND A7.A7_FILIAL='"+xFilial("SA7")+"' " 
	
	_cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 "
	_cQuery += " ON  SA1.A1_COD = SZ2.Z2_CLIENTE "
	_cQuery += " AND SA1.A1_LOJA = SZ2.Z2_LOJA "
	_cQuery += " AND SA1.D_E_L_E_T_='' "
	_cQuery += " AND SA1.A1_FILIAL='"+xFilial("SA1")+"' "
	
	cUsuario := RetCodUsr()
	DbSelectArea("SA3")
	SA3->(DbSetOrder(7))
	If SA3->(DbSeek(xFilial("SA3")+cUsuario)) .and. SA3->A3_XTIPO == 'V'
		_cQuery += " AND SA1.A1_VEND = '"+SA3->A3_COD+"' "
	EndIf
	
	_cQuery += " INNER JOIN " + RetSqlName("SA3") + " SA3 "
	_cQuery += " ON  SA3.A3_COD = SA1.A1_VEND "
	_cQuery += " AND SA3.D_E_L_E_T_='' "
	_cQuery += " AND SA3.A3_FILIAL='"+xFilial("SA3")+"' " 
	
	_cQuery += " WHERE SA1.A1_VEND IN ('" +ALLTRIM(_cDe) + "') "
	_cQuery += " AND SZ2.Z2_ANO BETWEEN "+ALLTRIM(STR(_nBuscar))+" AND "+ALLTRIM(STR(_nBuscar2))+" "
	_cQuery += " AND SZ2.D_E_L_E_T_='' "
	_cQuery += " AND SZ2.Z2_FILIAL='"+xFilial("SZ2")+"' "
	//_cQuery += " AND SZ2.Z2_TOPICO = 'F' "
	_cQuery += " AND (SZ2.Z2_QTM01>0 OR SZ2.Z2_QTM02>0 OR SZ2.Z2_QTM03>0 OR SZ2.Z2_QTM04>0 OR SZ2.Z2_QTM05>0 OR SZ2.Z2_QTM06>0 OR SZ2.Z2_QTM07>0 OR SZ2.Z2_QTM08>0 OR SZ2.Z2_QTM09>0 OR SZ2.Z2_QTM10>0 OR SZ2.Z2_QTM11>0 OR SZ2.Z2_QTM12>0) " 
	
	_cQuery += " ORDER BY SZ2.Z2_ANO, SZ2.Z2_TOPICO "

//Filtro Segmento	
ELSEIf SubStr(nComboBo1,1,1) == "4".Or. SubStr(nComboBo2,1,1) == "4"
	
	_cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 "
	_cQuery += " ON  SA1.A1_COD = SZ2.Z2_CLIENTE "
	_cQuery += " AND SA1.A1_LOJA = SZ2.Z2_LOJA "
	_cQuery += " AND SA1.D_E_L_E_T_='' "
	_cQuery += " AND SA1.A1_FILIAL='"+xFilial("SA1")+"' "
	
	cUsuario := RetCodUsr()
	DbSelectArea("SA3")
	SA3->(DbSetOrder(7))
	If SA3->(DbSeek(xFilial("SA3")+cUsuario)) .and. SA3->A3_XTIPO == 'V'
		_cQuery += " AND SA1.A1_VEND = '"+SA3->A3_COD+"' "
	EndIf
	
	_cQuery += " INNER JOIN " + RetSqlName("SA3") + " SA3 "
	_cQuery += " ON  SA3.A3_COD = SA1.A1_VEND "
	_cQuery += " AND SA3.D_E_L_E_T_='' "
	_cQuery += " AND SA3.A3_FILIAL='"+xFilial("SA3")+"' " 
	
	_cQuery += " INNER JOIN " + RetSqlName("SA7") + " A7 "
	_cQuery += " ON  A7.A7_CLIENTE = SZ2.Z2_CLIENTE "
	_cQuery += " AND A7.A7_LOJA = SZ2.Z2_LOJA "
	_cQuery += " AND A7.A7_PRODUTO = SZ2.Z2_PRODUTO "
	_cQuery += " AND A7.D_E_L_E_T_='' "     
	_cQuery += " AND A7.A7_FILIAL='"+xFilial("SA7")+"' "
	
	_cQuery += " WHERE A7.A7_XSEGMEN = '" +ALLTRIM(_cDe) + "' "
	_cQuery += " AND SZ2.Z2_ANO BETWEEN "+ALLTRIM(STR(_nBuscar))+" AND "+ALLTRIM(STR(_nBuscar2))+" "
	_cQuery += " AND SZ2.D_E_L_E_T_='' "
	_cQuery += " AND SZ2.Z2_FILIAL='"+xFilial("SZ2")+"' "
	//_cQuery += " AND SZ2.Z2_TOPICO = 'F' "
	_cQuery += " AND (SZ2.Z2_QTM01>0 OR SZ2.Z2_QTM02>0 OR SZ2.Z2_QTM03>0 OR SZ2.Z2_QTM04>0 OR SZ2.Z2_QTM05>0 OR SZ2.Z2_QTM06>0 OR SZ2.Z2_QTM07>0 OR SZ2.Z2_QTM08>0 OR SZ2.Z2_QTM09>0 OR SZ2.Z2_QTM10>0 OR SZ2.Z2_QTM11>0 OR SZ2.Z2_QTM12>0) " 
	
	_cQuery += " ORDER BY SZ2.Z2_ANO, SZ2.Z2_TOPICO " 
	
//Filtro Produto		
ELSEIf SubStr(nComboBo1,1,1) == "5" .Or. SubStr(nComboBo2,1,1) == "5"   
	_cQuery += " INNER JOIN " + RetSqlName("SA7") + " A7 "
	_cQuery += " ON  A7.A7_CLIENTE = Z2_CLIENTE "
	_cQuery += " AND A7.A7_LOJA = Z2_LOJA "
	_cQuery += " AND A7.A7_PRODUTO = Z2_PRODUTO "
	_cQuery += " AND A7.D_E_L_E_T_='' "
	_cQuery += " AND A7.A7_FILIAL='"+xFilial("SA7")+"' " 
	
	cUsuario := RetCodUsr()
	DbSelectArea("SA3")
	SA3->(DbSetOrder(7))
	If SA3->(DbSeek(xFilial("SA3")+cUsuario)) .and. SA3->A3_XTIPO == 'V'
	
		_cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 "
		_cQuery += " ON  SA1.A1_COD = SZ2.Z2_CLIENTE "
		_cQuery += " AND SA1.A1_LOJA = SZ2.Z2_LOJA "
		_cQuery += " AND SA1.D_E_L_E_T_='' "
		_cQuery += " AND SA1.A1_FILIAL='"+xFilial("SA1")+"' "

		_cQuery += " AND SA1.A1_VEND = '"+SA3->A3_COD+"' "
	EndIf
	
	_cQuery += " WHERE SZ2.Z2_ANO BETWEEN "+ALLTRIM(STR(_nBuscar))+" AND "+ALLTRIM(STR(_nBuscar2))+" "
	_cQuery += " AND SZ2.Z2_PRODUTO in ("
		aProdutos2:={}
	For nI := 1 to Len(aProd)  
	If aProd[nI][1]
		Aadd(aProdutos2,{aProd[nI][1],;
		aProd[nI][2],;
		aProd[nI][3],;
		aProd[nI][4]})
	EndIf	
	Next
	
	For nI := 1 to Len(aProdutos2)  
		_cQuery += "'" +aProdutos2[nI][2]+ "'"
		If Len(aProdutos2) > nI
			_cQuery += ","
		EndIf
	Next
	_cQuery += " )    "
	_cQuery += " AND SZ2.D_E_L_E_T_='' "
	_cQuery += " AND SZ2.Z2_FILIAL='"+xFilial("SZ2")+"' "
	//_cQuery += " AND SZ2.Z2_TOPICO = 'F' "
	_cQuery += " AND (SZ2.Z2_QTM01>0 OR SZ2.Z2_QTM02>0 OR SZ2.Z2_QTM03>0 OR SZ2.Z2_QTM04>0 OR SZ2.Z2_QTM05>0 OR SZ2.Z2_QTM06>0 OR SZ2.Z2_QTM07>0 OR SZ2.Z2_QTM08>0 OR SZ2.Z2_QTM09>0 OR SZ2.Z2_QTM10>0 OR SZ2.Z2_QTM11>0 OR SZ2.Z2_QTM12>0) " 
	
	_cQuery += " ORDER BY SZ2.Z2_ANO, SZ2.Z2_TOPICO "

//Filtro Cliente	
ELSEIf SubStr(nComboBo1,1,1) == "6" .Or. SubStr(nComboBo2,1,1) == "6"   

	
	_cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 "
	_cQuery += " ON  SA1.A1_COD = SZ2.Z2_CLIENTE "
	_cQuery += " AND SA1.A1_LOJA = SZ2.Z2_LOJA "
	_cQuery += " AND SA1.D_E_L_E_T_='' "
	_cQuery += " AND SA1.A1_FILIAL='"+xFilial("SA1")+"' "
	
	cUsuario := RetCodUsr()
	DbSelectArea("SA3")
	SA3->(DbSetOrder(7))
	If SA3->(DbSeek(xFilial("SA3")+cUsuario)) .and. SA3->A3_XTIPO == 'V'

		_cQuery += " AND SA1.A1_VEND = '"+SA3->A3_COD+"' "
	EndIf
	
	_cQuery += " INNER JOIN " + RetSqlName("SA7") + " A7 "
	_cQuery += " ON  A7.A7_CLIENTE = SZ2.Z2_CLIENTE "
	_cQuery += " AND A7.A7_LOJA = SZ2.Z2_LOJA "
	_cQuery += " AND A7.A7_PRODUTO = SZ2.Z2_PRODUTO "
	_cQuery += " AND A7.D_E_L_E_T_='' "
	_cQuery += " AND A7.A7_FILIAL='"+xFilial("SA7")+"' " 
	
	_cQuery += " WHERE SZ2.Z2_ANO BETWEEN "+ALLTRIM(STR(_nBuscar))+" AND "+ALLTRIM(STR(_nBuscar2))+" "
	_cQuery += " AND SZ2.Z2_CLIENTE+SZ2.Z2_LOJA in  ("
		aClientes3:={}
	For nI := 1 to Len(aClientes)  
	If aClientes[nI][1]
		Aadd(aClientes3,{aClientes[nI][1],;
		aClientes[nI][2],;
		aClientes[nI][3]})
	EndIf	
	Next
	
	For nI := 1 to Len(aClientes3)  
		_cQuery += "'" +aClientes3[nI][2]+aClientes3[nI][3]+ "'"
		If Len(aClientes3) > nI
			_cQuery += ","
		EndIf
	Next
	_cQuery += " )    "
	_cQuery += " AND SZ2.D_E_L_E_T_='' "
	_cQuery += " AND SZ2.Z2_FILIAL='"+xFilial("SZ2")+"' "
	//_cQuery += " AND SZ2.Z2_TOPICO = 'F' "
	_cQuery += " AND (SZ2.Z2_QTM01>0 OR SZ2.Z2_QTM02>0 OR SZ2.Z2_QTM03>0 OR SZ2.Z2_QTM04>0 OR SZ2.Z2_QTM05>0 OR SZ2.Z2_QTM06>0 OR SZ2.Z2_QTM07>0 OR SZ2.Z2_QTM08>0 OR SZ2.Z2_QTM09>0 OR SZ2.Z2_QTM10>0 OR SZ2.Z2_QTM11>0 OR SZ2.Z2_QTM12>0) " 
	
	_cQuery += " ORDER BY SZ2.Z2_ANO, SZ2.Z2_TOPICO, SZ2.Z2_CLIENTE, SZ2.Z2_LOJA " 
	
	
//Filtro Produto x Cliente	
ELSEIf SubStr(nComboBo1,1,1) == "7".Or. SubStr(nComboBo2,1,1) == "7"
	_cQuery += " INNER JOIN " + RetSqlName("SA7") + " A7 "
	_cQuery += " ON  A7.A7_CLIENTE = Z2_CLIENTE "
	_cQuery += " AND A7.A7_LOJA = Z2_LOJA "
	_cQuery += " AND A7.A7_PRODUTO = Z2_PRODUTO "
	_cQuery += " AND A7.D_E_L_E_T_='' "   
	_cQuery += " AND A7.A7_FILIAL='"+xFilial("SA7")+"' "
	
	cUsuario := RetCodUsr()
	DbSelectArea("SA3")
	SA3->(DbSetOrder(7))
	If SA3->(DbSeek(xFilial("SA3")+cUsuario)) .and. SA3->A3_XTIPO == 'V'
	
		_cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 "
		_cQuery += " ON  SA1.A1_COD = SZ2.Z2_CLIENTE "
		_cQuery += " AND SA1.A1_LOJA = SZ2.Z2_LOJA "
		_cQuery += " AND SA1.D_E_L_E_T_='' "
		_cQuery += " AND SA1.A1_FILIAL='"+xFilial("SA1")+"' "

		_cQuery += " AND SA1.A1_VEND = '"+SA3->A3_COD+"' "
	EndIf
	
	_cQuery += " WHERE Z2_ANO BETWEEN "+ALLTRIM(STR(_nBuscar))+" AND "+ALLTRIM(STR(_nBuscar2))+" "
	_cQuery += " AND A7_CLIENTE+A7_LOJA+A7_PRODUTO in  ("
		aClientes3:={}
	For nI := 1 to Len(aClientes7)  
	If aClientes7[nI][1]
		Aadd(aClientes3,{aClientes7[nI][2],;
		aClientes7[nI][3],;
		aClientes7[nI][5]})
	EndIf	
	Next
	
	For nI := 1 to Len(aClientes3)  
		_cQuery += "'" +aClientes3[nI][1]+aClientes3[nI][2]+aClientes3[nI][3]+ "'"
		If Len(aClientes3) > nI
			_cQuery += ","
		EndIf
	Next
	_cQuery += " )    "
	_cQuery += " AND SZ2.D_E_L_E_T_='' "
	_cQuery += " AND SZ2.Z2_FILIAL='"+xFilial("SZ2")+"' "
	_cQuery += " AND SZ2.Z2_TOPICO = 'F' "
	_cQuery += " AND (SZ2.Z2_QTM01>0 OR SZ2.Z2_QTM02>0 OR SZ2.Z2_QTM03>0 OR SZ2.Z2_QTM04>0 OR SZ2.Z2_QTM05>0 OR SZ2.Z2_QTM06>0 OR SZ2.Z2_QTM07>0 OR SZ2.Z2_QTM08>0 OR SZ2.Z2_QTM09>0 OR SZ2.Z2_QTM10>0 OR SZ2.Z2_QTM11>0 OR SZ2.Z2_QTM12>0) " 
	
	_cQuery += " ORDER BY SZ2.Z2_ANO, SZ2.Z2_TOPICO, SZ2.Z2_PRODUTO, SZ2.Z2_CLIENTE "

//Filtro Grupo de Clientes	
ELSEIf SubStr(nComboBo1,1,1) == "8" .Or. SubStr(nComboBo2,1,1) == "8"
	_cQuery += " INNER JOIN " + RetSqlName("SA7") + " A7 "
	_cQuery += " ON  A7.A7_CLIENTE = Z2_CLIENTE "
	_cQuery += " AND A7.A7_LOJA = Z2_LOJA "
	_cQuery += " AND A7.A7_PRODUTO = Z2_PRODUTO "
	_cQuery += " AND A7.D_E_L_E_T_='' "             
	_cQuery += " AND A7.A7_FILIAL='"+xFilial("SA7")+"' "
	
	_cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 "
	_cQuery += " ON  SA1.A1_COD = Z2_CLIENTE "
	_cQuery += " AND SA1.A1_LOJA = Z2_LOJA "
	_cQuery += " AND SA1.D_E_L_E_T_='' "
	_cQuery += " AND SA1.A1_FILIAL='"+xFilial("SA1")+"' "   
	
	cUsuario := RetCodUsr()
	DbSelectArea("SA3")
	SA3->(DbSetOrder(7))
	If SA3->(DbSeek(xFilial("SA3")+cUsuario)) .and. SA3->A3_XTIPO == 'V'

		_cQuery += " AND SA1.A1_VEND = '"+SA3->A3_COD+"' "
	EndIf    
	
	_cQuery += " WHERE Z2_ANO BETWEEN "+ALLTRIM(STR(_nBuscar))+" AND "+ALLTRIM(STR(_nBuscar2))+" "
	_cQuery += " AND SA1.A1_GRPVEN = '" +ALLTRIM(_cDe) + "' "
	_cQuery += " AND SZ2.D_E_L_E_T_='' "
	_cQuery += " AND SZ2.Z2_FILIAL='"+xFilial("SZ2")+"' "
	//_cQuery += " AND SZ2.Z2_TOPICO = 'F' "
	_cQuery += " AND (SZ2.Z2_QTM01>0 OR SZ2.Z2_QTM02>0 OR SZ2.Z2_QTM03>0 OR SZ2.Z2_QTM04>0 OR SZ2.Z2_QTM05>0 OR SZ2.Z2_QTM06>0 OR SZ2.Z2_QTM07>0 OR SZ2.Z2_QTM08>0 OR SZ2.Z2_QTM09>0 OR SZ2.Z2_QTM10>0 OR SZ2.Z2_QTM11>0 OR SZ2.Z2_QTM12>0) " 
	
	_cQuery += " ORDER BY SZ2.Z2_ANO, SZ2.Z2_TOPICO, SZ2.Z2_CLIENTE, SZ2.Z2_LOJA "

//Sem Filtro
ELSE
	
	cUsuario := RetCodUsr()
	DbSelectArea("SA3")
	SA3->(DbSetOrder(7))
	If SA3->(DbSeek(xFilial("SA3")+cUsuario)) .and. SA3->A3_XTIPO == 'V'
	
		_cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 "
		_cQuery += " ON  SA1.A1_COD = SZ2.Z2_CLIENTE "
		_cQuery += " AND SA1.A1_LOJA = SZ2.Z2_LOJA "
		_cQuery += " AND SA1.D_E_L_E_T_='' "
		_cQuery += " AND SA1.A1_FILIAL='"+xFilial("SA1")+"' "

		_cQuery += " AND SA1.A1_VEND = '"+SA3->A3_COD+"' "
	EndIf
	
	_cQuery += " WHERE SZ2.Z2_ANO BETWEEN "+ALLTRIM(STR(_nBuscar))+" AND "+ALLTRIM(STR(_nBuscar2))+" "
	_cQuery += " AND SZ2.D_E_L_E_T_='' "
	_cQuery += " AND SZ2.Z2_FILIAL='"+xFilial("SZ2")+"' "
	//_cQuery += " AND SZ2.Z2_TOPICO = 'F' "
	_cQuery += " AND (SZ2.Z2_QTM01>0 OR SZ2.Z2_QTM02>0 OR SZ2.Z2_QTM03>0 OR SZ2.Z2_QTM04>0 OR SZ2.Z2_QTM05>0 OR SZ2.Z2_QTM06>0 OR SZ2.Z2_QTM07>0 OR SZ2.Z2_QTM08>0 OR SZ2.Z2_QTM09>0 OR SZ2.Z2_QTM10>0 OR SZ2.Z2_QTM11>0 OR SZ2.Z2_QTM12>0) "    
	
	_cQuery += " ORDER BY SZ2.Z2_ANO, SZ2.Z2_TOPICO "
ENDIf

//Crio memowrite para cada tipo de filtro
MemoWrite("ForecastQuery_"+SubStr(nComboBo1,1,1)+".txt",_cQuery)

_cQuery	:= ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.F.)
dbSelectArea(_cAlias)


oPrinter == Nil
lPreview := .T.

oPrinter := FWMsPrinter():New(_cFile,_nTipoImp,_lPropTMS,,_lDsbSetup,_lTReport,,_cPrinter,_lServer,_lPDFAsPNG,_lRaw,_lViewPDF,_nQtdCopy)
oPrinter:SetLandscape()
oPrinter:SetPaperSize(9)

If !oPrinter:IsFirstPage
	oPrinter:EndPage()
EndIf

oPrinter:StartPage()                  	

oPrinter:SayAlign( _nLin , 0005, "Emissใo: " + DTOC(DDataBase), oFont03, 0800-0005,0060,,2,0)
oPrinter:SayAlign( _nLin , 0080, "Moeda: " + IIF(_cMoeda=="1","Real - R$","Dolar - $"), oFont03, 0800-0005,0060,,2,0)   
oPrinter:SayAlign( _nLin , 0160, "Impostos: " + IIF(_cNet=="1","Net","Bruto"), oFont03, 0800-0005,0060,,2,0)

_nLin += 0020
If SubStr(nComboBo1,1,1) == "2"
	_cUniNeg := RTRIM(Posicione("ADK",1,xFilial("ADK") + _cDe ,"ADK_NOME"))
	oPrinter:SayAlign( _nLin , 0005, "Totaliza็ใo Mensal para a Unidade de Negocio " + trim(_cUniNeg) + " Periodo " + "Jan/" +ALLTRIM(STR(_nBuscar)) + " a " + "Dez/"+ALLTRIM(STR(_nBuscar)),    oFont01, 0800-0005,0060,,2,0)
ElseIf SubStr(nComboBo1,1,1) == "3"
	For nA := 1 to len(avEND)
		If(avEND[nA,1] == .T.)
			_cNome := avEND[nA,3]
			exit
		EndIf	
	Next nA
//	_cNome := RTRIM(Posicione("SA3",1,xFilial("SA3") + _cDe ,"A3_NOME"))
	oPrinter:SayAlign( _nLin , 0005, "Totaliza็ใo Mensal para o(a) Gerente " + trim(_cNome) + " Periodo " + "Jan/" +ALLTRIM(STR(_nBuscar)) + " a " + "Dez/"+ALLTRIM(STR(_nBuscar)),    oFont01, 0800-0005,0060,,2,0)
ElseIf SubStr(nComboBo1,1,1) == "4"
	_cNome := RTRIM(Posicione("AOV",1,xFilial("AOV") + _cDe ,"AOV_DESSEG"))
	oPrinter:SayAlign( _nLin , 0005, "Totaliza็ใo Mensal para o Segmento " + trim(_cNome) + " Periodo " + "Jan/" +ALLTRIM(STR(_nBuscar)) + " a " + "Dez/"+ALLTRIM(STR(_nBuscar)),    oFont01, 0800-0005,0060,,2,0)
ElseIf SubStr(nComboBo1,1,1) == "5"
	_cProd := RTRIM(Posicione("SB1",1,xFilial("SB1") + (_cAlias)->Z2_PRODUTO ,"B1_DESCINT"))
	oPrinter:SayAlign( _nLin , 0005, "Totaliza็ใo Mensal para o Produto " + _cProd + " Periodo " + "Jan/" +ALLTRIM(STR(_nBuscar)) + " a " + "Dez/"+ALLTRIM(STR(_nBuscar)),    oFont01, 0800-0005,0060,,2,0)
ElseIf SubStr(nComboBo1,1,1) == "6"
	_cNCli := RTRIM((_cAlias)->A1_NREDUZ)
	oPrinter:SayAlign( _nLin , 0005, "Totaliza็ใo Mensal para o Cliente "+_cNCli+" Periodo " + "Jan/" +ALLTRIM(STR(_nBuscar)) + " a " + "Dez/"+ALLTRIM(STR(_nBuscar)),    oFont01, 0800-0005,0060,,2,0)
ElseIf SubStr(nComboBo1,1,1) == "7"
	_cPrCl := RTRIM(Posicione("SA1",1,xFilial("SA1") + (_cAlias)->A7_CLIENTE + (_cAlias)->A7_LOJA ,"A1_NOME"))
	_cClPr := RTRIM(Posicione("SB1",1,xFilial("SB1") + (_cAlias)->A7_PRODUTO ,"B1_DESCINT"))
	oPrinter:SayAlign( _nLin , 0005, "Totaliza็ใo Mensal para o Produto x Cliente Periodo " + "Jan/" +ALLTRIM(STR(_nBuscar)) + " a " + "Dez/"+ALLTRIM(STR(_nBuscar)),    oFont01, 0800-0005,0060,,2,0)
ElseIf SubStr(nComboBo1,1,1) == "8"
	_cGrupo := RTRIM(Posicione("ACY",1,xFilial("ACY") + Alltrim(_cDe) ,"ACY_DESCRI"))
	oPrinter:SayAlign( _nLin , 0005, "Totaliza็ใo Mensal para o Grupo de Clientes " + _cGrupo + " Periodo " + "Jan/" +ALLTRIM(STR(_nBuscar)) + " a " + "Dez/"+ALLTRIM(STR(_nBuscar)),    oFont01, 0800-0005,0060,,2,0)
Else
	oPrinter:SayAlign( _nLin , 0005, "Totaliza็ใo Mensal Geral da Empresa Periodo " + "Jan/" +ALLTRIM(STR(_nBuscar)) + " a " + "Dez/"+ALLTRIM(STR(_nBuscar)),    oFont01, 0800-0005,0060,,2,0)
EndIf

_nLin += 0040

//Quadro com os box's
oPrinter:Box(_nLin-5, 0020, 0460+15, 0115, "-4")//TITULOS
oPrinter:Box(_nLin-5, 0115, 0460+15, 0169, "-4")//TOTAL
oPrinter:Box(_nLin-5, 0169, 0460+15, 0223, "-4")//JANEIRO
oPrinter:Box(_nLin-5, 0223, 0460+15, 0277, "-4")//FEVEREIRO
oPrinter:Box(_nLin-5, 0277, 0460+15, 0331, "-4")//MARวO
oPrinter:Box(_nLin-5, 0331, 0460+15, 0385, "-4")//ABRIL
oPrinter:Box(_nLin-5, 0385, 0460+15, 0439, "-4")//MAIO
oPrinter:Box(_nLin-5, 0439, 0460+15, 0493, "-4")//JUNHO
oPrinter:Box(_nLin-5, 0493, 0460+15, 0547, "-4")//JULHO
oPrinter:Box(_nLin-5, 0547, 0460+15, 0601, "-4")//AGOSTO
oPrinter:Box(_nLin-5, 0601, 0460+15, 0655, "-4")//SETEMBRO
oPrinter:Box(_nLin-5, 0655, 0460+15, 0709, "-4")//OUTUBRO
oPrinter:Box(_nLin-5, 0709, 0460+15, 0763, "-4")//NOVEMBRO
oPrinter:Box(_nLin-5, 0763, 0460+15, 0817, "-4")//DEZEMBRO

DbSelectArea(_cAlias)
DbGoTop()
While !Eof()
	If (_cAlias)->Z2_ANO == _nBuscar .AND. ALLTRIM((_cAlias)->Z2_TOPICO) == "F"
		
		_cCodCli   := (_cAlias)->Z2_CLIENTE
		_cLojaCli  := (_cAlias)->Z2_LOJA
		_cCodProd  := (_cAlias)->Z2_PRODUTO
		_cAno      := cValToChar((_cAlias)->Z2_ANO)
		
		IF _cMoeda == "1"
		_cPrec     := U_RCRME007(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)
		Else 
		_cPrec     := U_RCRME019(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)	
		Endif
		
		
		_cPrecAtu  += _cPrec
		
		_fJanAtuQt += (_cAlias)->Z2_QTM01
		If (_cAlias)->Z2_QTM01 > 0
			_PrJanAtu += (_cAlias)->Z2_QTM01 * _cPrec
		EndIf
		_fFevAtuQt += (_cAlias)->Z2_QTM02
		If (_cAlias)->Z2_QTM02 > 0
			_PrFevAtu += (_cAlias)->Z2_QTM02 * _cPrec
		EndIf
		_fMarAtuQt += (_cAlias)->Z2_QTM03
		If (_cAlias)->Z2_QTM03 > 0
			_PrMarAtu += (_cAlias)->Z2_QTM03 * _cPrec
		EndIf
		_fAbrAtuQt += (_cAlias)->Z2_QTM04
		If (_cAlias)->Z2_QTM04 > 0
			_PrAbrAtu += (_cAlias)->Z2_QTM04 * _cPrec
		EndIf
		_fMaiAtuQt += (_cAlias)->Z2_QTM05
		If (_cAlias)->Z2_QTM05 > 0
			_PrMaiAtu += (_cAlias)->Z2_QTM05 * _cPrec
		EndIf
		_fJunAtuQt += (_cAlias)->Z2_QTM06
		If (_cAlias)->Z2_QTM06 > 0
			_PrJunAtu += (_cAlias)->Z2_QTM06 * _cPrec
		EndIf
		_fJulAtuQt += (_cAlias)->Z2_QTM07
		If (_cAlias)->Z2_QTM07 > 0
			_PrJulAtu += (_cAlias)->Z2_QTM07 * _cPrec
		EndIf
		_fAgoAtuQt += (_cAlias)->Z2_QTM08
		If (_cAlias)->Z2_QTM08 > 0
			_PrAgoAtu += (_cAlias)->Z2_QTM08 * _cPrec
		EndIf
		_fSetAtuQt += (_cAlias)->Z2_QTM09
		If (_cAlias)->Z2_QTM09 > 0
			_PrSetAtu += (_cAlias)->Z2_QTM09 * _cPrec
		EndIf
		_fOutAtuQt += (_cAlias)->Z2_QTM10
		If (_cAlias)->Z2_QTM10 > 0
			_PrOutAtu += (_cAlias)->Z2_QTM10 * _cPrec
		EndIf
		_fNovAtuQt += (_cAlias)->Z2_QTM11
		If (_cAlias)->Z2_QTM11 > 0
			_PrNovAtu += (_cAlias)->Z2_QTM11 * _cPrec
		EndIf
		_fDezAtuQt += (_cAlias)->Z2_QTM12
		If (_cAlias)->Z2_QTM12 > 0
			_PrDezAtu += (_cAlias)->Z2_QTM12 * _cPrec
		EndIf
	EndIf
	
	DbSelectArea(_cAlias)
	DbSkip()
Enddo

DbSelectArea(_cAlias)
DbGoTop()
While !Eof()
	If (_cAlias)->Z2_ANO == _nBuscar2 .AND. ALLTRIM((_cAlias)->Z2_TOPICO) == "F"
		
		_cCodCli   := (_cAlias)->Z2_CLIENTE
		_cLojaCli  := (_cAlias)->Z2_LOJA
		_cCodProd  := (_cAlias)->Z2_PRODUTO
		_cAno      := cValToChar((_cAlias)->Z2_ANO)
		
		IF _cMoeda == "1"
		_cPrec     := U_RCRME007(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)
		Else 
		_cPrec     := U_RCRME019(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)	
		Endif
		
		_cPrecPos  += _cPrec
		
		_fJanPosQt += (_cAlias)->Z2_QTM01
		If (_cAlias)->Z2_QTM01 > 0
			_PrJanPos += (_cAlias)->Z2_QTM01 * _cPrec
		EndIf
		_fFevPosQt += (_cAlias)->Z2_QTM02
		If (_cAlias)->Z2_QTM02 > 0
			_PrFevPos += (_cAlias)->Z2_QTM02 * _cPrec
		EndIf
		_fMarPosQt += (_cAlias)->Z2_QTM03
		If (_cAlias)->Z2_QTM03 > 0
			_PrMarPos += (_cAlias)->Z2_QTM03 * _cPrec
		EndIf
		_fAbrPosQt += (_cAlias)->Z2_QTM04
		If (_cAlias)->Z2_QTM04 > 0
			_PrAbrPos += (_cAlias)->Z2_QTM04 * _cPrec
		EndIf
		_fMaiPosQt += (_cAlias)->Z2_QTM05
		If (_cAlias)->Z2_QTM05 > 0
			_PrMaiPos += (_cAlias)->Z2_QTM05 * _cPrec
		EndIf
		_fJunPosQt += (_cAlias)->Z2_QTM06
		If (_cAlias)->Z2_QTM06 > 0
			_PrJunPos += (_cAlias)->Z2_QTM06 * _cPrec
		EndIf
		_fJulPosQt += (_cAlias)->Z2_QTM07
		If (_cAlias)->Z2_QTM07 > 0
			_PrJulPos += (_cAlias)->Z2_QTM07 * _cPrec
		EndIf
		_fAgoPosQt += (_cAlias)->Z2_QTM08
		If (_cAlias)->Z2_QTM08 > 0
			_PrAgoPos += (_cAlias)->Z2_QTM08 * _cPrec
		EndIf
		_fSetPosQt += (_cAlias)->Z2_QTM09
		If (_cAlias)->Z2_QTM09 > 0
			_PrSetPos += (_cAlias)->Z2_QTM09 * _cPrec
		EndIf
		_fOutPosQt += (_cAlias)->Z2_QTM10
		If (_cAlias)->Z2_QTM10 > 0
			_PrOutPos += (_cAlias)->Z2_QTM10 * _cPrec
		EndIf
		_fNovPosQt += (_cAlias)->Z2_QTM11
		If (_cAlias)->Z2_QTM11 > 0
			_PrNovPos += (_cAlias)->Z2_QTM11 * _cPrec
		EndIf
		_fDezPosQt += (_cAlias)->Z2_QTM12
		If (_cAlias)->Z2_QTM12 > 0
			_PrDezPos += (_cAlias)->Z2_QTM12 * _cPrec
		EndIf
		
		DbSkip()
	Else
		DbSkip()
	EndIf
Enddo

DbSelectArea(_cAlias)
DbGoTop()
While !Eof()
	If (_cAlias)->Z2_ANO == _nBuscar .AND. ALLTRIM((_cAlias)->Z2_TOPICO) == "B"
		
		_cCodCli   := (_cAlias)->Z2_CLIENTE
		_cLojaCli  := (_cAlias)->Z2_LOJA
		_cCodProd  := (_cAlias)->Z2_PRODUTO
		_cAno      := cValToChar((_cAlias)->Z2_ANO)
		
	   
			IF _cMoeda == "1"  .and. _cnet == "2"   // moeda real e pre็o bruto, ira buscar o valor gravado no momento do budget
		   
				_cPrec	   := (_cAlias)->Z2_PRECO01
			
			Elseif _cMoeda == "1"  .and. _cnet == "1"	 // moeda real e pre็o net, ira recalcular o valor baseado na tabela de pre็o vigente
	   	   
	   		 	_cPrec     := U_RCRME007(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)
		   
		 	Else// demais condi็๕es, ira recalcular o valor baseado na tabela de pre็o vigente
		 	
	   	   		_cPrec     := U_RCRME019(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)	
		
			Endif
		
						
		//_cPrec     := U_RCRME007(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)
		
		_bJanAtuQt += (_cAlias)->Z2_QTM01
		
		If (_cAlias)->Z2_QTM01 > 0
		//	_cPrec	   := (_cAlias)->Z2_PRECO01
		     
			//	IF _cMoeda == "1"
			  //		_cPrec	   := (_cAlias)->Z2_PRECO01
				//Else 
	   			  //	_cPrec     := U_RCRME019(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)	
				//Endif
			
				
			IF _cMoeda == "1"  .and. _cnet == "2"   // moeda real e pre็o bruto, ira buscar o valor gravado no momento do budget
		   
				_cPrec	   := (_cAlias)->Z2_PRECO01
			
			Elseif _cMoeda == "1"  .and. _cnet == "1"	 // moeda real e pre็o net, ira recalcular o valor baseado na tabela de pre็o vigente
	   	   
	   		 	_cPrec     := U_RCRME007(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)
		   
		 	Else// demais condi็๕es, ira recalcular o valor baseado na tabela de pre็o vigente
		 	
	   	   		_cPrec     := U_RCRME019(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)	
		
			Endif
		
		
			_PrJanBud += (_cAlias)->Z2_QTM01 * _cPrec
		EndIf
		_bFevAtuQt += (_cAlias)->Z2_QTM02
		
		If (_cAlias)->Z2_QTM02 > 0
//			_cPrec	   := (_cAlias)->Z2_PRECO02
			
			 /*
				IF _cMoeda == "1"
					_cPrec	   := (_cAlias)->Z2_PRECO02
				Else 
	   				_cPrec     := U_RCRME019(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)	
				Endif
			*/	
				
								
			IF _cMoeda == "1"  .and. _cnet == "2"   // moeda real e pre็o bruto, ira buscar o valor gravado no momento do budget
		   
				_cPrec	   := (_cAlias)->Z2_PRECO02
			
			Elseif _cMoeda == "1"  .and. _cnet == "1"	 // moeda real e pre็o net, ira recalcular o valor baseado na tabela de pre็o vigente
	   	   
	   		 	_cPrec     := U_RCRME007(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)
		   
		 	Else// demais condi็๕es, ira recalcular o valor baseado na tabela de pre็o vigente
		 	
	   	   		_cPrec     := U_RCRME019(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)	
		
			Endif
				
			
			_PrFevBud += (_cAlias)->Z2_QTM02 * _cPrec
		EndIf
		_bMarAtuQt += (_cAlias)->Z2_QTM03
		If (_cAlias)->Z2_QTM03 > 0
//			_cPrec	   := (_cAlias)->Z2_PRECO03
			/*
			IF _cMoeda == "1"
					_cPrec	   := (_cAlias)->Z2_PRECO03
				Else 
	   				_cPrec     := U_RCRME019(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)	
			Endif
			*/
			
		   IF _cMoeda == "1"  .and. _cnet == "2"   // moeda real e pre็o bruto, ira buscar o valor gravado no momento do budget
		   
				_cPrec	   := (_cAlias)->Z2_PRECO03
			
			Elseif _cMoeda == "1"  .and. _cnet == "1"	 // moeda real e pre็o net, ira recalcular o valor baseado na tabela de pre็o vigente
	   	   
	   		 	_cPrec     := U_RCRME007(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)
		   
		 	Else// demais condi็๕es, ira recalcular o valor baseado na tabela de pre็o vigente
		 	
	   	   		_cPrec     := U_RCRME019(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)	
		
			Endif
			
			
			
			_PrMarBud += (_cAlias)->Z2_QTM03 * _cPrec
		EndIf
		_bAbrAtuQt += (_cAlias)->Z2_QTM04
		If (_cAlias)->Z2_QTM04 > 0
			//_cPrec	   := (_cAlias)->Z2_PRECO04
			/*
			IF _cMoeda == "1"
					_cPrec	   := (_cAlias)->Z2_PRECO04
				Else 
	   				_cPrec     := U_RCRME019(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)	
			Endif
			*/
			
			IF _cMoeda == "1"  .and. _cnet == "2"   // moeda real e pre็o bruto, ira buscar o valor gravado no momento do budget
		   
				_cPrec	   := (_cAlias)->Z2_PRECO04
			
			Elseif _cMoeda == "1"  .and. _cnet == "1"	 // moeda real e pre็o net, ira recalcular o valor baseado na tabela de pre็o vigente
	   	   
	   		 	_cPrec     := U_RCRME007(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)
		   
		 	Else// demais condi็๕es, ira recalcular o valor baseado na tabela de pre็o vigente
		 	
	   	   		_cPrec     := U_RCRME019(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)	
		
			Endif
			
			_PrAbrBud += (_cAlias)->Z2_QTM04 * _cPrec
		EndIf
		_bMaiAtuQt += (_cAlias)->Z2_QTM05
		If (_cAlias)->Z2_QTM05 > 0
//			_cPrec	   := (_cAlias)->Z2_PRECO05       
			/*
			IF _cMoeda == "1"                   
			
					_cPrec	   := (_cAlias)->Z2_PRECO05
				Else 
	   				_cPrec     := U_RCRME019(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)	
			Endif
            */
  		   
  				IF _cMoeda == "1"  .and. _cnet == "2"   // moeda real e pre็o bruto, ira buscar o valor gravado no momento do budget
		   
				_cPrec	   := (_cAlias)->Z2_PRECO05
			
			Elseif _cMoeda == "1"  .and. _cnet == "1"	 // moeda real e pre็o net, ira recalcular o valor baseado na tabela de pre็o vigente
	   	   
	   		 	_cPrec     := U_RCRME007(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)
		   
		 	Else// demais condi็๕es, ira recalcular o valor baseado na tabela de pre็o vigente
		 	
	   	   		_cPrec     := U_RCRME019(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)	
		
			Endif
  
			_PrMaiBud += (_cAlias)->Z2_QTM05 * _cPrec
		EndIf
		_bJunAtuQt += (_cAlias)->Z2_QTM06
		If (_cAlias)->Z2_QTM06 > 0
//			_cPrec	   := (_cAlias)->Z2_PRECO06
		/*
		IF _cMoeda == "1"
					_cPrec	   := (_cAlias)->Z2_PRECO06
				Else 
	   				_cPrec     := U_RCRME019(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)	
		Endif
		*/
		
			IF _cMoeda == "1"  .and. _cnet == "2"   // moeda real e pre็o bruto, ira buscar o valor gravado no momento do budget
		   
				_cPrec	   := (_cAlias)->Z2_PRECO06
			
			Elseif _cMoeda == "1"  .and. _cnet == "1"	 // moeda real e pre็o net, ira recalcular o valor baseado na tabela de pre็o vigente
	   	   
	   		 	_cPrec     := U_RCRME007(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)
		   
		 	Else// demais condi็๕es, ira recalcular o valor baseado na tabela de pre็o vigente
		 	
	   	   		_cPrec     := U_RCRME019(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)	
		
			Endif
		
			_PrJunBud += (_cAlias)->Z2_QTM06 * _cPrec
		EndIf
		_bJulAtuQt += (_cAlias)->Z2_QTM07
		If (_cAlias)->Z2_QTM07 > 0                     
			
		//	_cPrec	   := (_cAlias)->Z2_PRECO07
		/*
		IF _cMoeda == "1"
					_cPrec	   := (_cAlias)->Z2_PRECO07
				Else 
	   				_cPrec     := U_RCRME019(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)	
		Endif
		*/
		
			IF _cMoeda == "1"  .and. _cnet == "2"   // moeda real e pre็o bruto, ira buscar o valor gravado no momento do budget
		   
				_cPrec	   := (_cAlias)->Z2_PRECO07
			
			Elseif _cMoeda == "1"  .and. _cnet == "1"	 // moeda real e pre็o net, ira recalcular o valor baseado na tabela de pre็o vigente
	   	   
	   		 	_cPrec     := U_RCRME007(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)
		   
		 	Else// demais condi็๕es, ira recalcular o valor baseado na tabela de pre็o vigente
		 	
	   	   		_cPrec     := U_RCRME019(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)	
		
			Endif	
		
		
		
			_PrJulBud += (_cAlias)->Z2_QTM07 * _cPrec
		EndIf
		_bAgoAtuQt += (_cAlias)->Z2_QTM08
		If (_cAlias)->Z2_QTM08 > 0
//			_cPrec	   := (_cAlias)->Z2_PRECO08        
        /*
		IF _cMoeda == "1"
					_cPrec	   := (_cAlias)->Z2_PRECO08
				Else 
	   				_cPrec     := U_RCRME019(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)	
		Endif
	    */
			IF _cMoeda == "1"  .and. _cnet == "2"   // moeda real e pre็o bruto, ira buscar o valor gravado no momento do budget
		   
				_cPrec	   := (_cAlias)->Z2_PRECO08
			
			Elseif _cMoeda == "1"  .and. _cnet == "1"	 // moeda real e pre็o net, ira recalcular o valor baseado na tabela de pre็o vigente
	   	   
	   		 	_cPrec     := U_RCRME007(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)
		   
		 	Else// demais condi็๕es, ira recalcular o valor baseado na tabela de pre็o vigente
		 	
	   	   		_cPrec     := U_RCRME019(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)	
		
			Endif
			
					
			_PrAgoBud += (_cAlias)->Z2_QTM08 * _cPrec
		EndIf
		_bSetAtuQt += (_cAlias)->Z2_QTM09
		
		If (_cAlias)->Z2_QTM09 > 0
//			_cPrec	   := (_cAlias)->Z2_PRECO09
		/*
		IF _cMoeda == "1"
					_cPrec	   := (_cAlias)->Z2_PRECO09
				Else 
	   				_cPrec     := U_RCRME019(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)	
		Endif
		*/
			IF _cMoeda == "1"  .and. _cnet == "2"   // moeda real e pre็o bruto, ira buscar o valor gravado no momento do budget
		   
				_cPrec	   := (_cAlias)->Z2_PRECO09
			
			Elseif _cMoeda == "1"  .and. _cnet == "1"	 // moeda real e pre็o net, ira recalcular o valor baseado na tabela de pre็o vigente
	   	   
	   		 	_cPrec     := U_RCRME007(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)
		   
		 	Else// demais condi็๕es, ira recalcular o valor baseado na tabela de pre็o vigente
		 	
	   	   		_cPrec     := U_RCRME019(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)	
		
			Endif
		
		
		
			_PrSetBud += (_cAlias)->Z2_QTM09 * _cPrec
		EndIf
		_bOutAtuQt += (_cAlias)->Z2_QTM10
		If (_cAlias)->Z2_QTM10 > 0
//			_cPrec	   := (_cAlias)->Z2_PRECO10
        /*
		IF _cMoeda == "1"
					_cPrec	   := (_cAlias)->Z2_PRECO10
				Else 
	   				_cPrec     := U_RCRME019(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)	
		Endif
	    */
		
			IF _cMoeda == "1"  .and. _cnet == "2"   // moeda real e pre็o bruto, ira buscar o valor gravado no momento do budget
		   
				_cPrec	   := (_cAlias)->Z2_PRECO10
			
			Elseif _cMoeda == "1"  .and. _cnet == "1"	 // moeda real e pre็o net, ira recalcular o valor baseado na tabela de pre็o vigente
	   	   
	   		 	_cPrec     := U_RCRME007(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)
		   
		 	Else// demais condi็๕es, ira recalcular o valor baseado na tabela de pre็o vigente
		 	
	   	   		_cPrec     := U_RCRME019(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)	
		
			Endif
	
	
				_PrOutBud += (_cAlias)->Z2_QTM10 * _cPrec
		EndIf
		_bNovAtuQt += (_cAlias)->Z2_QTM11
		If (_cAlias)->Z2_QTM11 > 0
//			_cPrec	   := (_cAlias)->Z2_PRECO11        
		 /*	
			IF _cMoeda == "1"
					_cPrec	   := (_cAlias)->Z2_PRECO11
				Else 
	   				_cPrec     := U_RCRME019(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)	
			Endif
	     */
	
	    	IF _cMoeda == "1"  .and. _cnet == "2"   // moeda real e pre็o bruto, ira buscar o valor gravado no momento do budget
		   
				_cPrec	   := (_cAlias)->Z2_PRECO11
			
			Elseif _cMoeda == "1"  .and. _cnet == "1"	 // moeda real e pre็o net, ira recalcular o valor baseado na tabela de pre็o vigente
	   	   
	   		 	_cPrec     := U_RCRME007(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)
		   
		 	Else// demais condi็๕es, ira recalcular o valor baseado na tabela de pre็o vigente
		 	
	   	   		_cPrec     := U_RCRME019(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)	
		
			Endif
	
			
			_PrNovBud += (_cAlias)->Z2_QTM11 * _cPrec
		EndIf
		_bDezAtuQt += (_cAlias)->Z2_QTM12
		If (_cAlias)->Z2_QTM12 > 0
	//		_cPrec	   := (_cAlias)->Z2_PRECO12
			/*
			IF _cMoeda == "1"
					_cPrec	   := (_cAlias)->Z2_PRECO12
				Else 
	   				_cPrec     := U_RCRME019(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)	
			EndIf
			*/
			
			IF _cMoeda == "1"  .and. _cnet == "2"   // moeda real e pre็o bruto, ira buscar o valor gravado no momento do budget
		   
				_cPrec	   := (_cAlias)->Z2_PRECO12
			
			Elseif _cMoeda == "1"  .and. _cnet == "1"	 // moeda real e pre็o net, ira recalcular o valor baseado na tabela de pre็o vigente
	   	   
	   		 	_cPrec     := U_RCRME007(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)
		   
		 	Else// demais condi็๕es, ira recalcular o valor baseado na tabela de pre็o vigente
		 	
	   	   		_cPrec     := U_RCRME019(_cCodCli,_cLojaCli,_cCodProd,_cAno,_cNet)	
		
			Endif
			_PrDezBud += (_cAlias)->Z2_QTM12 * _cPrec
	   
			EndIf
		_cPrecBud  += _cPrec
		
		DbSkip()
	Else
		DbSkip()
	EndIf
Enddo

_PrTotAtu := _PrJanAtu + _PrFevAtu + _PrMarAtu + _PrAbrAtu + _PrMaiAtu + _PrJunAtu + _PrJulAtu + _PrAgoAtu + _PrSetAtu + _PrOutAtu + _PrNovAtu + _PrDezAtu
_PrTotPos := _PrJanPos + _PrFevPos + _PrMarPos + _PrAbrPos + _PrMaiPos + _PrJunPos + _PrJulPos + _PrAgoPos + _PrSetPos + _PrOutPos + _PrNovPos + _PrDezPos
_PrTotBud := _PrJanBud + _PrFevBud + _PrMarBud + _PrAbrBud + _PrMaiBud + _PrJunBud + _PrJulBud + _PrAgoBud + _PrSetBud + _PrOutBud + _PrNovBud + _PrDezBud

_fJanPosVl := _PrJanPos / _fJanPosQt
_fFevPosVl := _PrFevPos / _fFevPosQt
_fMarPosVl := _PrMarPos / _fMarPosQt
_fAbrPosVl := _PrAbrPos / _fAbrPosQt
_fMaiPosVl := _PrMaiPos / _fMaiPosQt
_fJunPosVl := _PrJunPos / _fJunPosQt
_fJulPosVl := _PrJulPos / _fJulPosQt
_fAgoPosVl := _PrAgoPos / _fAgoPosQt
_fSetPosVl := _PrSetPos / _fSetPosQt
_fOutPosVl := _PrOutPos / _fOutPosQt
_fNovPosVl := _PrNovPos / _fNovPosQt
_fDezPosVl := _PrDezPos / _fDezPosQt

_fJanAtuVl := _PrJanAtu / _fJanAtuQt
_fFevAtuVl := _PrFevAtu / _fFevAtuQt
_fMarAtuVl := _PrMarAtu / _fMarAtuQt
_fAbrAtuVl := _PrAbrAtu / _fAbrAtuQt
_fMaiAtuVl := _PrMaiAtu / _fMaiAtuQt
_fJunAtuVl := _PrJunAtu / _fJunAtuQt
_fJulAtuVl := _PrJulAtu / _fJulAtuQt
_fAgoAtuVl := _PrAgoAtu / _fAgoAtuQt
_fSetAtuVl := _PrSetAtu / _fSetAtuQt
_fOutAtuVl := _PrOutAtu / _fOutAtuQt
_fNovAtuVl := _PrNovAtu / _fNovAtuQt
_fDezAtuVl := _PrDezAtu / _fDezAtuQt

_bJanAtuVl += _PrJanBud / _bJanAtuQt
_bFevAtuVl += _PrFevBud / _bFevAtuQt
_bMarAtuVl += _PrMarBud / _bMarAtuQt
_bAbrAtuVl += _PrAbrBud / _bAbrAtuQt
_bMaiAtuVl += _PrMaiBud / _bMaiAtuQt
_bJunAtuVl += _PrJunBud / _bJunAtuQt
_bJulAtuVl += _PrJulBud / _bJulAtuQt
_bAgoAtuVl += _PrAgoBud / _bAgoAtuQt
_bSetAtuVl += _PrSetBud / _bSetAtuQt
_bOutAtuVl += _PrOutBud / _bOutAtuQt
_bNovAtuVl += _PrNovBud / _bNovAtuQt
_bDezAtuVl += _PrDezBud / _bDezAtuQt

_fTotPosVl := (_fJanPosVl + _fFevPosVl + _fMarPosVl + _fAbrPosVl + _fMaiPosVl + _fJunPosVl + _fJulPosVl + _fAgoPosVl + _fSetPosVl + _fOutPosVl + _fNovPosVl + _fDezPosVl)/12
_fTotAtuVl := (_fJanAtuVl + _fFevAtuVl + _fMarAtuVl + _fAbrAtuVl + _fMaiAtuVl + _fJunAtuVl + _fJulAtuVl + _fAgoAtuVl + _fSetAtuVl + _fOutAtuVl + _fNovAtuVl + _fDezAtuVl)/12
_bTotAtuVl := (_bJanAtuVl + _bFevAtuVl + _bMarAtuVl + _bAbrAtuVl + _bMaiAtuVl + _bJunAtuVl + _bJulAtuVl + _bAgoAtuVl + _bSetAtuVl + _bOutAtuVl + _bNovAtuVl + _bDezAtuVl)/12

_fTotPosQt := _fJanPosQt + _fFevPosQt + _fMarPosQt + _fAbrPosQt +  _fMaiPosQt + _fJunPosQt + _fJulPosQt + _fAgoPosQt + _fSetPosQt + _fOutPosQt + _fNovPosQt + _fDezPosQt
_fTotAtuQt := _fJanAtuQt + _fFevAtuQt + _fMarAtuQt + _fAbrAtuQt +  _fMaiAtuQt + _fJunAtuQt + _fJulAtuQt + _fAgoAtuQt + _fSetAtuQt + _fOutAtuQt + _fNovAtuQt + _fDezAtuQt
_bTotAtuQt := _bJanAtuQt + _bFevAtuQt + _bMarAtuQt + _bAbrAtuQt +  _bMaiAtuQt + _bJunAtuQt + _bJulAtuQt + _bAgoAtuQt + _bSetAtuQt + _bOutAtuQt + _bNovAtuQt + _bDezAtuQt

//	_PrTotAtu := _fTotAtuVl * _ftotAtuQt
//	_PrTotPos := _fTotPosVl * _ftotPosQt
//	_PrTotBud := _bTotAtuVl * _btotAtuQt

//Colunas e linhas Ano Posterior
oPrinter:Fillrect( {_nLin-4, 0021, _nLin+14, 0816}, oBrush1, "-2")
oPrinter:SayAlign(_nLin,0025, "Ano Posterior",   oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0120, "Total",   oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0174, "Jan",  oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0228, "Fev", oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0282, "Mar",  oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0336, "Abr", oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0390, "Mai", oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0444, "Jun", oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0498, "Jul", oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0552, "Ago", oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0606, "Set", oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0660, "Out", oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0714, "Nov", oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0768, "Dez", oFont02, 0800-0005,0060,,0,2)
_nLin += _nEspPad

oPrinter:SayAlign(_nLin,0025, "Vol. Fcst.Post.",   oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0120, Transform(_fTotPosQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0174, Transform(_fJanPosQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0228, Transform(_fFevPosQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0282, Transform(_fMarPosQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0336, Transform(_fAbrPosQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0390, Transform(_fMaiPosQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0444, Transform(_fJunPosQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0498, Transform(_fJulPosQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0552, Transform(_fAgoPosQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0606, Transform(_fSetPosQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0660, Transform(_fOutPosQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0714, Transform(_fNovPosQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0768, Transform(_fDezPosQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
_nLin += _nEspPad

oPrinter:SayAlign(_nLin,0025, "Pre็o Fcs.Post.",   oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0120, Transform(_fTotPosVl,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0174, Transform(_fJanPosVl,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0228, Transform(_fFevPosVl,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0282, Transform(_fMarPosVl,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0336, Transform(_fAbrPosVl,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0390, Transform(_fMaiPosVl,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0444, Transform(_fJunPosVl,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0498, Transform(_fJulPosVl,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0552, Transform(_fAgoPosVl,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0606, Transform(_fSetPosVl,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0660, Transform(_fOutPosVl,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0714, Transform(_fNovPosVl,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0768, Transform(_fDezPosVl,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
_nLin += _nEspPad

oPrinter:SayAlign(_nLin,0025, "Receita Fcsr.Post.",   oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0120, Transform(_PrTotPos,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0174, Transform(_PrJanPos,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0228, Transform(_PrFevPos,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0282, Transform(_PrMarPos,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0336, Transform(_PrAbrPos,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0390, Transform(_PrMaiPos,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0444, Transform(_PrJunPos,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0498, Transform(_PrJulPos,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0552, Transform(_PrAgoPos,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0606, Transform(_PrSetPos,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0660, Transform(_PrOutPos,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0714, Transform(_PrNovPos,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0768, Transform(_PrDezPos,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
_nLin += _nEspPad

//Colunas e Linhas Forecast Atual
oPrinter:Fillrect( {_nLin-4, 0021, _nLin+14, 0816}, oBrush1, "-2")
oPrinter:SayAlign(_nLin,0025, "Fcst Atual",   oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0120, "Total",   oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0174, "Jan",  oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0228, "Fev", oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0282, "Mar",  oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0336, "Abr", oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0390, "Mai", oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0444, "Jun", oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0498, "Jul", oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0552, "Ago", oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0606, "Set", oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0660, "Out", oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0714, "Nov", oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0768, "Dez", oFont02, 0800-0005,0060,,0,2)
_nLin += _nEspPad

oPrinter:SayAlign(_nLin,0025, "Real-Fcst Qtde.",   oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0120, Transform(_fTotAtuQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0174, Transform(_fJanAtuQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0228, Transform(_fFevAtuQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0282, Transform(_fMarAtuQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0336, Transform(_fAbrAtuQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0390, Transform(_fMaiAtuQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0444, Transform(_fJunAtuQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0498, Transform(_fJulAtuQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0552, Transform(_fAgoAtuQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0606, Transform(_fSetAtuQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0660, Transform(_fOutAtuQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0714, Transform(_fNovAtuQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0768, Transform(_fDezAtuQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
_nLin += _nEspPad

oPrinter:SayAlign(_nLin,0025, "Real-Fcst Pre็o",   oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0120, Transform(_PrTotAtu/_fTotAtuQt,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0174, Transform(_PrJanAtu/_fJanAtuQt,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0228, Transform(_PrFevAtu/_fFevAtuQt,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0282, Transform(_PrMarAtu/_fMarAtuQt,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0336, Transform(_PrAbrAtu/_fAbrAtuQt,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0390, Transform(_PrMaiAtu/_fMaiAtuQt,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0444, Transform(_PrJunAtu/_fJunAtuQt,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0498, Transform(_PrJulAtu/_fJulAtuQt,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0552, Transform(_PrAgoAtu/_fAgoAtuQt,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0606, Transform(_PrSetAtu/_fSetAtuQt,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0660, Transform(_PrOutAtu/_fOutAtuQt,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0714, Transform(_PrNovAtu/_fNovAtuQt,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0768, Transform(_PrDezAtu/_fDezAtuQt,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
_nLin += _nEspPad

oPrinter:SayAlign(_nLin,0025, "Real-Fcst Receita",   oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0120, Transform(_PrTotAtu,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0174, Transform(_PrJanAtu,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0228, Transform(_PrFevAtu,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0282, Transform(_PrMarAtu,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0336, Transform(_PrAbrAtu,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0390, Transform(_PrMaiAtu,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0444, Transform(_PrJunAtu,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0498, Transform(_PrJulAtu,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0552, Transform(_PrAgoAtu,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0606, Transform(_PrSetAtu,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0660, Transform(_PrOutAtu,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0714, Transform(_PrNovAtu,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0768, Transform(_PrDezAtu,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
_nLin += _nEspPad

_nQTotAtual := 0
_nVTotAtual := 0
/*
//
//cQuery := " SELECT MONTH(D2_EMISSAO) AS MES, SUM(D2_QUANT) AS QUANT, SUM(D2_VALBRUT) AS VALOR "
cQuery := " SELECT MONTH(D2_EMISSAO) AS MES, SUM(D2_QUANT)-SUM(D2_QTDEDEV) AS QUANT, SUM(D2_VALBRUT)-SUM(D2_VALDEV) AS VALOR "
cQuery += " FROM " + RetSqlName("SD2") + " SD2 "
cQuery += " INNER JOIN " + RetSqlName("SF2") + " SF2 "
cQuery += " ON SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_CLIENTE = SF2.F2_CLIENTE AND SD2.D2_LOJA = SF2.F2_LOJA AND SD2.D2_TIPO = SF2.F2_TIPO"
cQuery += " AND SD2.D_E_L_E_T_ = '' "
cQuery += " AND SF2.D_E_L_E_T_ = '' "
cQuery += " AND SD2.D2_FILIAL = '"+xFilial("SD2")+"' "
cQuery += " AND SF2.F2_FILIAL = '"+xFilial("SF2")+"' "
cQuery += " INNER JOIN " + RetSqlName("SF4") + " SF4 "
cQuery += " ON SD2.D_E_L_E_T_='' "
cQuery += " AND SD2.D2_TIPO NOT IN ('D','B') "
cQuery += " AND YEAR(SD2.D2_EMISSAO) = "+ ALLTRIM(STR(_nBuscar)) +" "
cQuery += " AND SF4.D_E_L_E_T_='' "
cQuery += " AND SD2.D2_TES=SF4.F4_CODIGO "
cQuery += " AND SF4.F4_DUPLIC = 'S' "
If SubStr(nComboBo1,1,1) == "2"
	cQuery += " INNER JOIN " + RetSqlName("SA7") + " A7  ON  A7.A7_CLIENTE = D2_CLIENTE  AND "
	cQuery += " A7.A7_LOJA = D2_LOJA  AND A7.A7_PRODUTO = D2_COD  AND "
	cQuery += " A7.D_E_L_E_T_=''  AND A7.A7_FILIAL='  ' AND "
	cQuery += " SUBSTRING(A7.A7_XSEGMEN,1,1) =  SUBSTRING('" +ALLTRIM(_cDe) + "',6,1) "
	cQuery += " GROUP BY MONTH(D2_EMISSAO) "
ELSEIf SubStr(nComboBo1,1,1) == "3"	
   	//	cQuery += " INNER JOIN " + RetSqlName("SA3") + " SA3 "
	//	cQuery += " ON F2_VEND1 = A3_COD "
	cQuery += " LEFT JOIN " + RetSqlName("SA1") + " SA1 "
	cQuery += " ON SD2.D2_CLIENTE = SA1.A1_COD AND "
	cQuery += " SD2.D2_LOJA  = SA1.A1_LOJA "
	cQuery += " INNER JOIN " + RetSqlName("SA3") + " SA3 "
	cQuery += " ON SA1.A1_VEND = A3_COD "
	cQuery += " AND SA3.D_E_L_E_T_ = '' "
	cQuery += " AND SA3.A3_FILIAL = '"+xFilial("SA3")+"' "
	cQuery += " AND SA3.A3_COD  IN ('" +ALLTRIM(_cDe) + "') "
	cQuery += " GROUP BY MONTH(D2_EMISSAO) "
ELSEIf SubStr(nComboBo1,1,1) == "4"
	cQuery += " INNER JOIN " + RetSqlName("SA7") + " A7 "
	cQuery += " ON  A7.A7_CLIENTE = SD2.D2_CLIENTE "
	cQuery += " AND A7.A7_LOJA = SD2.D2_LOJA "
	cQuery += " AND A7.A7_PRODUTO = SD2.D2_COD "
	cQuery += " AND A7.D_E_L_E_T_='' "
	cQuery += " AND A7.A7_FILIAL='"+xFilial("SA7")+"' "
	cQuery += " WHERE A7.A7_XSEGMEN = '" +ALLTRIM(_cDe) + "' "
	cQuery += " GROUP BY MONTH(D2_EMISSAO) "
ELSEIf SubStr(nComboBo1,1,1) == "5"
	cQuery += " WHERE D2_COD in ("
		aProdutos2:={}
	For nI := 1 to Len(aProd)  
	If aProd[nI][1]
		Aadd(aProdutos2,{aProd[nI][1],;
		aProd[nI][2],;
		aProd[nI][3]})
	EndIf	
	Next
	
	For nI := 1 to Len(aProdutos2)  
		cQuery += "'" +aProdutos2[nI][2]+ "'"
		If Len(aProdutos2) > nI
			cQuery += ","
		EndIf
	Next
	cQuery += " )    "
	cQuery += " GROUP BY MONTH(D2_EMISSAO) "
ELSEIf SubStr(nComboBo1,1,1) == "6"
	cQuery += " WHERE D2_CLIENTE+D2_LOJA in  ("
		aClientes3:={}
	For nI := 1 to Len(aClientes)  
	If aClientes[nI][1]
		Aadd(aClientes3,{aClientes[nI][1],;
		aClientes[nI][2],;
		aClientes[nI][3]})
	EndIf	
	Next
	
	For nI := 1 to Len(aClientes3)  
		cQuery += "'" +aClientes3[nI][2]+aClientes3[nI][3]+ "'"
		If Len(aClientes3) > nI
			cQuery += ","
		EndIf
	Next
	cQuery += " )    "
	cQuery += " GROUP BY MONTH(D2_EMISSAO) "
ELSEIf SubStr(nComboBo1,1,1) == "7"
	cQuery += " Left JOIN SA7010 "
	cQuery += " ON A7_CLIENTE = D2_CLIENTE "
	cQuery += " AND A7_LOJA = D2_LOJA "
	cQuery += " AND A7_PRODUTO = D2_COD "
	cQuery += " AND A7_PRODUTO = '" +ALLTRIM(_cDe) + "' "
	cQuery += " WHERE A7_CLIENTE+A7_LOJA+A7_PRODUTO in  ("
		aClientes3:={}
	For nI := 1 to Len(aClientes7)  
	If aClientes7[nI][1]
		Aadd(aClientes3,{aClientes7[nI][2],;
		aClientes7[nI][3],;
		aClientes7[nI][5]})
	EndIf	
	Next
	
	For nI := 1 to Len(aClientes3)  
		cQuery += "'" +aClientes3[nI][1]+aClientes3[nI][2]+aClientes3[nI][3]+ "'"
		If Len(aClientes3) > nI
			cQuery += ","
		EndIf
	Next
	cQuery += " )    "
	cQuery += " GROUP BY MONTH(D2_EMISSAO) "
ELSEIf SubStr(nComboBo1,1,1) == "8"
	cQuery += " INNER JOIN SA1010 SA1
	cQuery += " ON SD2.D2_CLIENTE = SA1.A1_COD "
	cQuery += " AND SD2.D2_LOJA = SA1.A1_LOJA "
	cQuery += " AND SA1.A1_GRPVEN = '" +ALLTRIM(_cDe) + "' "
	cQuery += " GROUP BY MONTH(D2_EMISSAO) " "
Else
	cQuery += " GROUP BY MONTH(D2_EMISSAO) "
EndIf
*/
//*** query buscando da SZR conforme alinhado com Robson e Marcio em 16/11/2018
  
_nCotDmd := SuperGetMv('MV_DOLARMD',, 3.6 )       //cota็ใo m้dia do dolar para conversใo

	IF _cMoeda == "1"
		if _cNet == "1" 
	    	cQuery := " SELECT MONTH(ZR_EMISSAO) AS MES, SUM(ZR_QUANT) AS QUANT, SUM((ZR_TOTAL+ZR_VALIPI)-(ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM)) AS VALOR "		
		else	                                                                                          
       		cQuery := " SELECT MONTH(ZR_EMISSAO) AS MES, SUM(ZR_QUANT) AS QUANT, SUM(ZR_TOTAL+ZR_VALIPI) AS VALOR "
     	endif
     Else  
     
        if _cNet =="1"
	   		cQuery := " SELECT MONTH(ZR_EMISSAO) AS MES, SUM(ZR_QUANT) AS QUANT, SUM((ZR_TOTAL+ZR_VALIPI)-(ZR_TOTAL+ZR_VALIPI)-(ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM)/CASE WHEN ZR_TXMOEDA=0 THEN "+cValtoChar(_nCotDmd)+" ELSE ZR_TXMOEDA END)  AS VALOR "     
        else 
        	cQuery := " SELECT MONTH(ZR_EMISSAO) AS MES, SUM(ZR_QUANT) AS QUANT, SUM((ZR_TOTAL+ZR_VALIPI)/CASE WHEN ZR_TXMOEDA=0 THEN "+cValtoChar(_nCotDmd)+" ELSE ZR_TXMOEDA END)  AS VALOR "     
        endif
    Endif

     cQuery += " FROM SZR010 "
     cQuery += " WHERE "
	 cQuery += " ZR_TPOPER IN ('D','V') "                            
	 cQuery += " AND YEAR(ZR_EMISSAO) = "+ ALLTRIM(STR(_nBuscar)) +" "
	 
//	--COMBO 2 - 2 - Unidade de Neg๓cio
	If SubStr(nComboBo1,1,1) == "2"
		cQuery += " AND SUBSTRING(ZR_CODSEG,1,1) =  SUBSTRING('" +ALLTRIM(_cDe) + "',6,1) "
		cQuery += " GROUP BY MONTH(ZR_EMISSAO) "
		
//	--COMBO 3 - Gerente de Conta
		ELSEIf SubStr(nComboBo1,1,1) == "3"			
		If cGerAtu == "1"
			cQuery += " AND ZR_VATU  IN ('" +ALLTRIM(_cDe) + "') "
		Else
			cQuery += " AND ZR_VCOD  IN ('" +ALLTRIM(_cDe) + "') "
		EndIf
		
		cQuery += " GROUP BY MONTH(ZR_EMISSAO) "

//	--COMBO 4 - Segmentos
		ELSEIf SubStr(nComboBo1,1,1) == "4"		
		cQuery += " AND ZR_CODSEG = '" +ALLTRIM(_cDe) + "' "
		cQuery += " GROUP BY MONTH(ZR_EMISSAO) "

//	--COMBO 5 - Produtos
		ELSEIf SubStr(nComboBo1,1,1) == "5"
		cQuery += " AND ZR_CODPROD in ("
			aProdutos2:={}
		For nI := 1 to Len(aProd)  
		If aProd[nI][1]
			Aadd(aProdutos2,{aProd[nI][1],;
			aProd[nI][2],;
			aProd[nI][3]})
		EndIf	
		Next
	
		For nI := 1 to Len(aProdutos2)  
			cQuery += "'" +aProdutos2[nI][2]+ "'"
			If Len(aProdutos2) > nI
				cQuery += ","
			EndIf
		Next
		cQuery += " )    "
		cQuery += " GROUP BY MONTH(ZR_EMISSAO) "

//	--COMBO 6 - Clientes
		ELSEIf SubStr(nComboBo1,1,1) == "6"	
		cQuery += " AND ZR_COD+ZR_LJCLIFO in  ("
			aClientes3:={}
		For nI := 1 to Len(aClientes)  
		If aClientes[nI][1]
			Aadd(aClientes3,{aClientes[nI][1],;
			aClientes[nI][2],;
			aClientes[nI][3]})
		EndIf	
		Next
	
		For nI := 1 to Len(aClientes3)  
			cQuery += "'" +aClientes3[nI][2]+aClientes3[nI][3]+ "'"
			If Len(aClientes3) > nI
				cQuery += ","
			EndIf
		Next
		cQuery += " )    "
		cQuery += " GROUP BY MONTH(ZR_EMISSAO) "

//	--COMBO 7 - Produto x Cliente
		ELSEIf SubStr(nComboBo1,1,1) == "7"
		cQuery += " AND ZR_CODPROD = '" +ALLTRIM(_cDe) + "' "
		cQuery += " AND ZR_COD+ZR_LJCLIFO+ZR_CODPROD in  ("
			aClientes3:={}
		For nI := 1 to Len(aClientes7)  
		If aClientes7[nI][1]
			Aadd(aClientes3,{aClientes7[nI][2],;
			aClientes7[nI][3],;
			aClientes7[nI][5]})
		EndIf	
		Next
	
		For nI := 1 to Len(aClientes3)  
			cQuery += "'" +aClientes3[nI][1]+aClientes3[nI][2]+aClientes3[nI][3]+ "'"
			If Len(aClientes3) > nI
				cQuery += ","
			EndIf
		Next
		cQuery += " )    "
		cQuery += " GROUP BY MONTH(ZR_EMISSAO) "


//	--COMBO 8 - Grupo de Clientes
		ELSEIf SubStr(nComboBo1,1,1) == "8"	 
		cQuery += " AND ZR_GRPVEN = '" +ALLTRIM(_cDe) + "' "
		cQuery += " GROUP BY MONTH(ZR_EMISSAO) " "

//	--COMBO 9 - SEM FILTRO
		Else
		cQuery += " GROUP BY MONTH(ZR_EMISSAO) "
    Endif


Memowrite("QryAnoAtual.txt",cQuery )
cQuery	:= ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias2,.T.,.F.)
dbSelectArea(cAlias2)

//Colunas e linhas Realizado Ano Ant.
oPrinter:Fillrect( {_nLin-4, 0021, _nLin+14, 0816}, oBrush1, "-2")
oPrinter:SayAlign(_nLin,0025, "Realizado Atual",	oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0120, "Total",				oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0174, "Jan", 				oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0228, "Fev", 				oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0282, "Mar", 				oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0336, "Abr", 				oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0390, "Mai", 				oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0444, "Jun", 				oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0498, "Jul", 				oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0552, "Ago", 				oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0606, "Set", 				oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0660, "Out", 				oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0714, "Nov", 				oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0768, "Dez", 				oFont02, 0800-0005,0060,,0,2)
_nLin += _nEspPad

oPrinter:SayAlign(_nLin,0025, "Vol.Atual",   oFont02, 0800-0005,0060,,0,2)
DbSelectArea(cAlias2)
DbGoTop()
If (cAlias2)->(!EOF())
	While !Eof()
		
		If     (cAlias2)->MES == 1
			oPrinter:SayAlign(_nLin,0174, Transform((cAlias2)->QUANT,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nQTotAtual += (cAlias2)->QUANT
			DbSkip()
		ElseIf (cAlias2)->MES == 2
			oPrinter:SayAlign(_nLin,0228, Transform((cAlias2)->QUANT,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nQTotAtual += (cAlias2)->QUANT
			DbSkip()
		ElseIf (cAlias2)->MES == 3
			oPrinter:SayAlign(_nLin,0282, Transform((cAlias2)->QUANT,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nQTotAtual += (cAlias2)->QUANT
			DbSkip()
		ElseIf (cAlias2)->MES == 4
			oPrinter:SayAlign(_nLin,0336, Transform((cAlias2)->QUANT,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nQTotAtual += (cAlias2)->QUANT
			DbSkip()
		ElseIf (cAlias2)->MES == 5
			oPrinter:SayAlign(_nLin,0390, Transform((cAlias2)->QUANT,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nQTotAtual += (cAlias2)->QUANT
			DbSkip()
		ElseIf (cAlias2)->MES == 6
			oPrinter:SayAlign(_nLin,0444, Transform((cAlias2)->QUANT,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nQTotAtual += (cAlias2)->QUANT
			DbSkip()
		ElseIf (cAlias2)->MES == 7
			oPrinter:SayAlign(_nLin,0498, Transform((cAlias2)->QUANT,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nQTotAtual += (cAlias2)->QUANT
			DbSkip()
		ElseIf (cAlias2)->MES == 8
			oPrinter:SayAlign(_nLin,0552, Transform((cAlias2)->QUANT,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nQTotAtual += (cAlias2)->QUANT
			DbSkip()
		ElseIf (cAlias2)->MES == 9
			oPrinter:SayAlign(_nLin,0606, Transform((cAlias2)->QUANT,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nQTotAtual += (cAlias2)->QUANT
			DbSkip()
		ElseIf (cAlias2)->MES == 10
			oPrinter:SayAlign(_nLin,0660, Transform((cAlias2)->QUANT,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nQTotAtual += (cAlias2)->QUANT
			DbSkip()
		ElseIf (cAlias2)->MES == 11
			oPrinter:SayAlign(_nLin,0714, Transform((cAlias2)->QUANT,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nQTotAtual += (cAlias2)->QUANT
			DbSkip()
		ElseIf (cAlias2)->MES == 12
			oPrinter:SayAlign(_nLin,0768, Transform((cAlias2)->QUANT,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nQTotAtual += (cAlias2)->QUANT
			DbSkip()
		EndIf
	Enddo
EndIf
oPrinter:SayAlign(_nLin,0120, Transform(_nQTotAtual,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)

_nLin += _nEspPad
_nPVAtual := 0
_nPQAtual := 0
oPrinter:SayAlign(_nLin,0025, "Pre็o Atual",   oFont02, 0800-0005,0060,,0,2)
DbSelectArea(cAlias2)
DbGoTop()
If (cAlias2)->(!EOF())
	While !Eof()
		
		If (cAlias2)->MES == 1
			oPrinter:SayAlign(_nLin,0174, Transform((cAlias2)->VALOR / (cAlias2)->QUANT,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
			_nPVAtual += (cAlias2)->VALOR
			_nPQAtual += (cAlias2)->QUANT
			DbSkip()
		ElseIf (cAlias2)->MES == 2
			oPrinter:SayAlign(_nLin,0228, Transform((cAlias2)->VALOR / (cAlias2)->QUANT,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
			_nPVAtual += (cAlias2)->VALOR
			_nPQAtual += (cAlias2)->QUANT
			DbSkip()
		ElseIf (cAlias2)->MES == 3
			oPrinter:SayAlign(_nLin,0282, Transform((cAlias2)->VALOR / (cAlias2)->QUANT,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
			_nPVAtual += (cAlias2)->VALOR
			_nPQAtual += (cAlias2)->QUANT
			DbSkip()
		ElseIf (cAlias2)->MES == 4
			oPrinter:SayAlign(_nLin,0336, Transform((cAlias2)->VALOR / (cAlias2)->QUANT,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
			_nPVAtual += (cAlias2)->VALOR
			_nPQAtual += (cAlias2)->QUANT
			DbSkip()
		ElseIf (cAlias2)->MES == 5
			oPrinter:SayAlign(_nLin,0390, Transform((cAlias2)->VALOR / (cAlias2)->QUANT,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
			_nPVAtual += (cAlias2)->VALOR
			_nPQAtual += (cAlias2)->QUANT
			DbSkip()
		ElseIf (cAlias2)->MES == 6
			oPrinter:SayAlign(_nLin,0444, Transform((cAlias2)->VALOR / (cAlias2)->QUANT,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
			_nPVAtual += (cAlias2)->VALOR
			_nPQAtual += (cAlias2)->QUANT
			DbSkip()
		ElseIf (cAlias2)->MES == 7
			oPrinter:SayAlign(_nLin,0498, Transform((cAlias2)->VALOR / (cAlias2)->QUANT,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
			_nPVAtual += (cAlias2)->VALOR
			_nPQAtual += (cAlias2)->QUANT
			DbSkip()
		ElseIf (cAlias2)->MES == 8
			oPrinter:SayAlign(_nLin,0552, Transform((cAlias2)->VALOR / (cAlias2)->QUANT,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
			_nPVAtual += (cAlias2)->VALOR
			_nPQAtual += (cAlias2)->QUANT
			DbSkip()
		ElseIf (cAlias2)->MES == 9
			oPrinter:SayAlign(_nLin,0606, Transform((cAlias2)->VALOR / (cAlias2)->QUANT,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
			_nPVAtual += (cAlias2)->VALOR
			_nPQAtual += (cAlias2)->QUANT
			DbSkip()
		ElseIf (cAlias2)->MES == 10
			oPrinter:SayAlign(_nLin,0660, Transform((cAlias2)->VALOR / (cAlias2)->QUANT,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
			_nPVAtual += (cAlias2)->VALOR
			_nPQAtual += (cAlias2)->QUANT
			DbSkip()
		ElseIf (cAlias2)->MES == 11
			oPrinter:SayAlign(_nLin,0714, Transform((cAlias2)->VALOR / (cAlias2)->QUANT,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
			_nPVAtual += (cAlias2)->VALOR
			_nPQAtual += (cAlias2)->QUANT
			DbSkip()
		ElseIf (cAlias2)->MES == 12
			oPrinter:SayAlign(_nLin,0768, Transform((cAlias2)->VALOR / (cAlias2)->QUANT,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
			_nPVAtual += (cAlias2)->VALOR
			_nPQAtual += (cAlias2)->QUANT
			DbSkip()
		EndIf
	Enddo
EndIf
oPrinter:SayAlign(_nLin,0120, Transform(_nPVAtual / _nPQAtual,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
_nLin += _nEspPad

oPrinter:SayAlign(_nLin,0025, "Receita Atual",   oFont02, 0800-0005,0060,,0,2)
DbSelectArea(cAlias2)
DbGoTop()
If (cAlias2)->(!EOF())
	While !Eof()
		
		If (cAlias2)->MES == 1
			oPrinter:SayAlign(_nLin,0174, Transform((cAlias2)->VALOR,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nVTotAtual += (cAlias2)->VALOR
			DbSkip()
		ElseIf (cAlias2)->MES == 2
			oPrinter:SayAlign(_nLin,0228, Transform((cAlias2)->VALOR,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nVTotAtual += (cAlias2)->VALOR
			DbSkip()
		ElseIf (cAlias2)->MES == 3
			oPrinter:SayAlign(_nLin,0282, Transform((cAlias2)->VALOR,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nVTotAtual += (cAlias2)->VALOR
			DbSkip()
		ElseIf (cAlias2)->MES == 4
			oPrinter:SayAlign(_nLin,0336, Transform((cAlias2)->VALOR,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nVTotAtual += (cAlias2)->VALOR
			DbSkip()
		ElseIf (cAlias2)->MES == 5
			oPrinter:SayAlign(_nLin,0390, Transform((cAlias2)->VALOR,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nVTotAtual += (cAlias2)->VALOR
			DbSkip()
		ElseIf (cAlias2)->MES == 6
			oPrinter:SayAlign(_nLin,0444, Transform((cAlias2)->VALOR,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nVTotAtual += (cAlias2)->VALOR
			DbSkip()
		ElseIf (cAlias2)->MES == 7
			oPrinter:SayAlign(_nLin,0498, Transform((cAlias2)->VALOR,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nVTotAtual += (cAlias2)->VALOR
			DbSkip()
		ElseIf (cAlias2)->MES == 8
			oPrinter:SayAlign(_nLin,0552, Transform((cAlias2)->VALOR,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nVTotAtual += (cAlias2)->VALOR
			DbSkip()
		ElseIf (cAlias2)->MES == 9
			oPrinter:SayAlign(_nLin,0606, Transform((cAlias2)->VALOR,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nVTotAtual += (cAlias2)->VALOR
			DbSkip()
		ElseIf (cAlias2)->MES == 10
			oPrinter:SayAlign(_nLin,0660, Transform((cAlias2)->VALOR,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nVTotAtual += (cAlias2)->VALOR
			DbSkip()
		ElseIf (cAlias2)->MES == 11
			oPrinter:SayAlign(_nLin,0714, Transform((cAlias2)->VALOR,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nVTotAtual += (cAlias2)->VALOR
			DbSkip()
		ElseIf (cAlias2)->MES == 12
			oPrinter:SayAlign(_nLin,0768, Transform((cAlias2)->VALOR,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nVTotAtual += (cAlias2)->VALOR
			DbSkip()
		EndIf
	Enddo
EndIf
oPrinter:SayAlign(_nLin,0120, Transform(_nVTotAtual,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)

_nLin += _nEspPad

//Colunas e linhas Budget
oPrinter:Fillrect( {_nLin-4, 0021, _nLin+14, 0816}, oBrush1, "-2")
oPrinter:SayAlign(_nLin,0025, "Budget",   oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0120, "Total",   oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0174, "Jan",  oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0228, "Fev", oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0282, "Mar",  oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0336, "Abr", oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0390, "Mai", oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0444, "Jun", oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0498, "Jul", oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0552, "Ago", oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0606, "Set", oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0660, "Out", oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0714, "Nov", oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0768, "Dez", oFont02, 0800-0005,0060,,0,2)
_nLin += _nEspPad

oPrinter:SayAlign(_nLin,0025, "Budg.Vol",   oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0120, Transform(_bTotAtuQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0174, Transform(_bJanAtuQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0228, Transform(_bFevAtuQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0282, Transform(_bMarAtuQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0336, Transform(_bAbrAtuQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0390, Transform(_bMaiAtuQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0444, Transform(_bJunAtuQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0498, Transform(_bJulAtuQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0552, Transform(_bAgoAtuQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0606, Transform(_bSetAtuQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0660, Transform(_bOutAtuQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0714, Transform(_bNovAtuQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0768, Transform(_bDezAtuQt,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
_nLin += _nEspPad

oPrinter:SayAlign(_nLin,0025, "Budg.Pre็o",   oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0120, Transform(_bTotAtuVl,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0174, Transform(_bJanAtuVl,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0228, Transform(_bFevAtuVl,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0282, Transform(_bMarAtuVl,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0336, Transform(_bAbrAtuVl,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0390, Transform(_bMaiAtuVl,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0444, Transform(_bJunAtuVl,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0498, Transform(_bJulAtuVl,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0552, Transform(_bAgoAtuVl,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0606, Transform(_bSetAtuVl,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0660, Transform(_bOutAtuVl,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0714, Transform(_bNovAtuVl,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0768, Transform(_bDezAtuVl,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
_nLin += _nEspPad

oPrinter:SayAlign(_nLin,0025, "Budg.Receita",   oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0120, Transform(_PrTotBud,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0174, Transform(_PrJanBud,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0228, Transform(_PrFevBud,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0282, Transform(_PrMarBud,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0336, Transform(_PrAbrBud,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0390, Transform(_PrMaiBud,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0444, Transform(_PrJunBud,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0498, Transform(_PrJulBud,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0552, Transform(_PrAgoBud,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0606, Transform(_PrSetBud,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0660, Transform(_PrOutBud,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0714, Transform(_PrNovBud,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0768, Transform(_PrDezBud,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
_nLin += _nEspPad


_nQTotReal := 0
_nVTotReal := 0
_nAnoAnt := (_nBuscar - 1)

/*
//Seleciono as etiquetas a serem impressas
	cQuery := " SELECT MONTH(D2_EMISSAO) AS MES, SUM(D2_QUANT)-SUM(D2_QTDEDEV) AS QUANT, SUM(D2_VALBRUT)-SUM(D2_VALDEV) AS VALOR "
//	cQuery := " SELECT MONTH(D2_EMISSAO) AS MES, SUM(D2_QUANT) AS QUANT, SUM(D2_VALBRUT) AS VALOR "
	cQuery += " FROM " + RetSqlName("SD2") + " SD2 "
	cQuery += " INNER JOIN " + RetSqlName("SF2") + " SF2 "
	cQuery += " ON SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_CLIENTE = SF2.F2_CLIENTE AND SD2.D2_LOJA = SF2.F2_LOJA "
	cQuery += " INNER JOIN " + RetSqlName("SF4") + " SF4 "
	cQuery += " ON SD2.D_E_L_E_T_='' "
	cQuery += " AND SD2.D2_TIPO NOT IN ('D','B') "
	cQuery += " AND YEAR(SD2.D2_EMISSAO) = "+ ALLTRIM(STR(_nAnoAnt)) +" "
	cQuery += " AND SF4.D_E_L_E_T_='' "
	cQuery += " AND SD2.D2_TES=SF4.F4_CODIGO "
	cQuery += " AND SF4.F4_DUPLIC = 'S' "
If SubStr(nComboBo1,1,1) == "2"
	cQuery += " INNER JOIN " + RetSqlName("SA7") + " A7  ON  A7.A7_CLIENTE = D2_CLIENTE  AND A7.A7_LOJA = D2_LOJA  AND A7.A7_PRODUTO = D2_COD  AND A7.D_E_L_E_T_=''  AND A7.A7_FILIAL='  ' AND SUBSTRING(A7.A7_XSEGMEN,1,1) =  SUBSTRING('" +ALLTRIM(_cDe) + "',6,1) "
	cQuery += " GROUP BY MONTH(D2_EMISSAO) "
ELSEIf SubStr(nComboBo1,1,1) == "3"
//	cQuery += " INNER JOIN SA3010 "    *** 14/11/18 - ALTERAวรO SOLICITADA PELO ROBSON E MARCIO PARA BUSCAR DONO DO CLIENTE E NAO CLIENTE NO MOMENTO DO FATURAMENTO
//	cQuery += " ON F2_VEND1 = A3_COD "
	cQuery += " INNER JOIN SA1010 SA1 "
	cQuery += " ON SD2.D2_CLIENTE = SA1.A1_COD "
	cQuery += " AND SD2.D2_LOJA = SA1.A1_LOJA "
	cQuery += " INNER JOIN SA3010 "
	cQuery += " ON SA1.A1_VEND = A3_COD "
	cQuery += " AND A3_COD  IN ('" +ALLTRIM(_cDe) + "') "
	cQuery += " GROUP BY MONTH(D2_EMISSAO) "
ELSEIf SubStr(nComboBo1,1,1) == "4"
	cQuery += " INNER JOIN SA7010 A7 "
	cQuery += " ON  A7.A7_CLIENTE = SD2.D2_CLIENTE "
	cQuery += " AND A7.A7_LOJA = SD2.D2_LOJA "
	cQuery += " AND A7.A7_PRODUTO = SD2.D2_COD "
	cQuery += " AND A7.D_E_L_E_T_='' "
	cQuery += " AND A7.A7_FILIAL='' "
	cQuery += " WHERE A7.A7_XSEGMEN = '" +ALLTRIM(_cDe) + "' "
	cQuery += " GROUP BY MONTH(D2_EMISSAO) "
ELSEIf SubStr(nComboBo1,1,1) == "5"
	cQuery += " WHERE D2_COD in ("
		aProdutos2:={}
	For nI := 1 to Len(aProd)  
	If aProd[nI][1]
		Aadd(aProdutos2,{aProd[nI][1],;
		aProd[nI][2],;
		aProd[nI][3]})
	EndIf	
	Next
	
	For nI := 1 to Len(aProdutos2)  
		cQuery += "'" +aProdutos2[nI][2]+ "'"
		If Len(aProdutos2) > nI
			cQuery += ","
		EndIf
	Next
	cQuery += " )    "
	cQuery += " GROUP BY MONTH(D2_EMISSAO) "
ELSEIf SubStr(nComboBo1,1,1) == "6"
	cQuery += " AND D2_CLIENTE+D2_LOJA in  ("
		aClientes3:={}
	For nI := 1 to Len(aClientes)  
	If aClientes[nI][1]
		Aadd(aClientes3,{aClientes[nI][1],;
		aClientes[nI][2],;
		aClientes[nI][3]})
	EndIf	
	Next
	
	For nI := 1 to Len(aClientes3)  
		cQuery += "'" +aClientes3[nI][2]+aClientes3[nI][3]+ "'"
		If Len(aClientes3) > nI
			cQuery += ","
		EndIf
	Next
	cQuery += " )    "
	cQuery += " GROUP BY YEAR(D2_EMISSAO), MONTH(D2_EMISSAO) "
ELSEIf SubStr(nComboBo1,1,1) == "7"
	cQuery += " INNER JOIN SA7010 "
	cQuery += " ON A7_CLIENTE = D2_CLIENTE "
	cQuery += " AND A7_LOJA = D2_LOJA "
	cQuery += " AND A7_PRODUTO = D2_COD "
	cQuery += " AND A7_PRODUTO BETWEEN '" +ALLTRIM(_cDe) + "' AND '" +ALLTRIM(_cAte) + "' "
	cQuery += " WHERE A7_CLIENTE+A7_LOJA+A7_PRODUTO in  ("
		aClientes3:={}
	For nI := 1 to Len(aClientes7)  
	If aClientes7[nI][1]
		Aadd(aClientes3,{aClientes7[nI][2],;
		aClientes7[nI][3],;
		aClientes7[nI][5]})
	EndIf	
	Next
	
	For nI := 1 to Len(aClientes3)  
		cQuery += "'" +aClientes3[nI][1]+aClientes3[nI][2]+aClientes3[nI][3]+ "'"
		If Len(aClientes3) > nI
			cQuery += ","
		EndIf
	Next
	cQuery += " )    "
	cQuery += " GROUP BY MONTH(D2_EMISSAO) "
ELSEIf SubStr(nComboBo1,1,1) == "8"
	cQuery += " INNER JOIN SA1010 SA1
	cQuery += " ON SD2.D2_CLIENTE = SA1.A1_COD "
	cQuery += " AND SD2.D2_LOJA = SA1.A1_LOJA "
	cQuery += " AND SA1.A1_GRPVEN = '" +ALLTRIM(_cDe) + "' "
	cQuery += " GROUP BY MONTH(D2_EMISSAO) " "
Else
	cQuery += " GROUP BY MONTH(D2_EMISSAO) "
EndIf
*/
//*** query buscando da SZR conforme alinhado com Robson e Marcio em 16/11/2018
     

     //	IF _cMoeda == "1"
     //cQuery := " SELECT MONTH(ZR_EMISSAO) AS MES, SUM(ZR_QUANT) AS QUANT, SUM(ZR_TOTAL+ZR_VALIPI) AS VALOR "
     //Else
	 //cQuery := " SELECT MONTH(ZR_EMISSAO) AS MES, SUM(ZR_QUANT) AS QUANT, SUM((ZR_TOTAL+ZR_VALIPI)/CASE WHEN(ZR_TXMOEDA=0) THEN "+cValtoChar(_nCotDmd)+" ELSE ZR_TXMOEDA END) AS VALOR "     
    //Endif
    
    IF _cMoeda == "1"
		if _cNet == "1" 
	    	cQuery := " SELECT MONTH(ZR_EMISSAO) AS MES, SUM(ZR_QUANT) AS QUANT, SUM((ZR_TOTAL+ZR_VALIPI)-(ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM)) AS VALOR "		
		else	                                                                                          
       		cQuery := " SELECT MONTH(ZR_EMISSAO) AS MES, SUM(ZR_QUANT) AS QUANT, SUM(ZR_TOTAL+ZR_VALIPI) AS VALOR "
     	endif
     Else  
     
        if _cNet =="1"
	   		cQuery := " SELECT MONTH(ZR_EMISSAO) AS MES, SUM(ZR_QUANT) AS QUANT, SUM((ZR_TOTAL+ZR_VALIPI)-(ZR_TOTAL+ZR_VALIPI)-(ZR_VALICM + ZR_VALIMP5 + ZR_VALIMP6 + ZR_DIFAL + ZR_ICMSCOM)/CASE WHEN ZR_TXMOEDA=0 THEN "+cValtoChar(_nCotDmd)+" ELSE ZR_TXMOEDA END)  AS VALOR "     
        else 
        	cQuery := " SELECT MONTH(ZR_EMISSAO) AS MES, SUM(ZR_QUANT) AS QUANT, SUM((ZR_TOTAL+ZR_VALIPI)/CASE WHEN ZR_TXMOEDA=0 THEN "+cValtoChar(_nCotDmd)+" ELSE ZR_TXMOEDA END)  AS VALOR "     
        endif
    Endif
    
    
    
        // cQuery := " SELECT MONTH(ZR_EMISSAO) AS MES, SUM(ZR_QUANT) AS QUANT, SUM(ZR_TOTAL+ZR_VALIPI) AS VALOR "
	 cQuery += " FROM " + RetSqlName("SZR") + " SZR "
	 cQuery += " WHERE "
	 cQuery += " ZR_TPOPER IN ('D','V') "
	 cQuery += " AND YEAR(ZR_EMISSAO)= "+ ALLTRIM(STR(_nAnoAnt)) +" "
	 
//	--COMBO 2 - 2 - Unidade de Neg๓cio
	If SubStr(nComboBo1,1,1) == "2"
		cQuery += " AND SUBSTRING(ZR_CODSEG,1,1) =  SUBSTRING('" +ALLTRIM(_cDe) + "',6,1) "
		cQuery += " GROUP BY MONTH(ZR_EMISSAO) "
		
//	--COMBO 3 - Gerente de Conta
		ELSEIf SubStr(nComboBo1,1,1) == "3"			

			If cGerAtu == "1"
				cQuery += " AND ZR_VATU  IN ('" +ALLTRIM(_cDe) + "') "
			Else
				cQuery += " AND ZR_VCOD  IN ('" +ALLTRIM(_cDe) + "') "
			EndIf
		
		
		cQuery += " GROUP BY MONTH(ZR_EMISSAO) "

//	--COMBO 4 - Segmentos
		ELSEIf SubStr(nComboBo1,1,1) == "4"		
		cQuery += " AND ZR_CODSEG = '" +ALLTRIM(_cDe) + "' "
		cQuery += " GROUP BY MONTH(ZR_EMISSAO) "

//	--COMBO 5 - Produtos
		ELSEIf SubStr(nComboBo1,1,1) == "5"
		cQuery += " AND ZR_CODPROD in ("
			aProdutos2:={}
		For nI := 1 to Len(aProd)  
		If aProd[nI][1]
			Aadd(aProdutos2,{aProd[nI][1],;
			aProd[nI][2],;
			aProd[nI][3]})
		EndIf	
		Next
	
		For nI := 1 to Len(aProdutos2)  
			cQuery += "'" +aProdutos2[nI][2]+ "'"
			If Len(aProdutos2) > nI
				cQuery += ","
			EndIf
		Next
		cQuery += " )    "
		cQuery += " GROUP BY MONTH(ZR_EMISSAO) "

//	--COMBO 6 - Clientes
		ELSEIf SubStr(nComboBo1,1,1) == "6"	
		cQuery += " AND ZR_COD+ZR_LJCLIFO in  ("
			aClientes3:={}
		For nI := 1 to Len(aClientes)  
		If aClientes[nI][1]
			Aadd(aClientes3,{aClientes[nI][1],;
			aClientes[nI][2],;
			aClientes[nI][3]})
		EndIf	
		Next
	
		For nI := 1 to Len(aClientes3)  
			cQuery += "'" +aClientes3[nI][2]+aClientes3[nI][3]+ "'"
			If Len(aClientes3) > nI
				cQuery += ","
			EndIf
		Next
		cQuery += " )    "
		cQuery += " GROUP BY MONTH(ZR_EMISSAO) "

//	--COMBO 7 - Produto x Cliente
		ELSEIf SubStr(nComboBo1,1,1) == "7"
		cQuery += " AND ZR_CODPROD = '" +ALLTRIM(_cDe) + "' "
		cQuery += " AND ZR_COD+ZR_LJCLIFO+ZR_CODPROD in  ("
			aClientes3:={}
		For nI := 1 to Len(aClientes7)  
		If aClientes7[nI][1]
			Aadd(aClientes3,{aClientes7[nI][2],;
			aClientes7[nI][3],;
			aClientes7[nI][5]})
		EndIf	
		Next
	
		For nI := 1 to Len(aClientes3)  
			cQuery += "'" +aClientes3[nI][1]+aClientes3[nI][2]+aClientes3[nI][3]+ "'"
			If Len(aClientes3) > nI
				cQuery += ","
			EndIf
		Next
		cQuery += " )    "
		cQuery += " GROUP BY MONTH(ZR_EMISSAO) "


//	--COMBO 8 - Grupo de Clientes
		ELSEIf SubStr(nComboBo1,1,1) == "8"	 
		cQuery += " AND ZR_GRPVEN = '" +ALLTRIM(_cDe) + "' "
		cQuery += " GROUP BY MONTH(ZR_EMISSAO) " "

//	--COMBO 9 - SEM FILTRO
		Else
		cQuery += " GROUP BY MONTH(ZR_EMISSAO) "
    Endif


Memowrite("QryRealAnoAnt.txt",cQuery )
cQuery	:= ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.F.)
dbSelectArea(cAlias)

//Colunas e linhas Realizado Ano Ant.
oPrinter:Fillrect( {_nLin-4, 0021, _nLin+14, 0816}, oBrush1, "-2")
oPrinter:SayAlign(_nLin,0025, "Realizado Ano Ant.",	oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0120, "Total",				oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0174, "Jan", 				oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0228, "Fev", 				oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0282, "Mar", 				oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0336, "Abr", 				oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0390, "Mai", 				oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0444, "Jun", 				oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0498, "Jul", 				oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0552, "Ago", 				oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0606, "Set", 				oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0660, "Out", 				oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0714, "Nov", 				oFont02, 0800-0005,0060,,0,2)
oPrinter:SayAlign(_nLin,0768, "Dez", 				oFont02, 0800-0005,0060,,0,2)
_nLin += _nEspPad

oPrinter:SayAlign(_nLin,0025, "Vol.Act.",   oFont02, 0800-0005,0060,,0,2)
DbSelectArea(cAlias)
DbGoTop()
If (cAlias)->(!EOF())
	While !Eof()
		
		If     (cAlias)->MES == 1
			oPrinter:SayAlign(_nLin,0174, Transform((cAlias)->QUANT,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nQTotReal += (cAlias)->QUANT
			DbSkip()
		ElseIf (cAlias)->MES == 2
			oPrinter:SayAlign(_nLin,0228, Transform((cAlias)->QUANT,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nQTotReal += (cAlias)->QUANT
			DbSkip()
		ElseIf (cAlias)->MES == 3
			oPrinter:SayAlign(_nLin,0282, Transform((cAlias)->QUANT,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nQTotReal += (cAlias)->QUANT
			DbSkip()
		ElseIf (cAlias)->MES == 4
			oPrinter:SayAlign(_nLin,0336, Transform((cAlias)->QUANT,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nQTotReal += (cAlias)->QUANT
			DbSkip()
		ElseIf (cAlias)->MES == 5
			oPrinter:SayAlign(_nLin,0390, Transform((cAlias)->QUANT,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nQTotReal += (cAlias)->QUANT
			DbSkip()
		ElseIf (cAlias)->MES == 6
			oPrinter:SayAlign(_nLin,0444, Transform((cAlias)->QUANT,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nQTotReal += (cAlias)->QUANT
			DbSkip()
		ElseIf (cAlias)->MES == 7
			oPrinter:SayAlign(_nLin,0498, Transform((cAlias)->QUANT,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nQTotReal += (cAlias)->QUANT
			DbSkip()
		ElseIf (cAlias)->MES == 8
			oPrinter:SayAlign(_nLin,0552, Transform((cAlias)->QUANT,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nQTotReal += (cAlias)->QUANT
			DbSkip()
		ElseIf (cAlias)->MES == 9
			oPrinter:SayAlign(_nLin,0606, Transform((cAlias)->QUANT,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nQTotReal += (cAlias)->QUANT
			DbSkip()
		ElseIf (cAlias)->MES == 10
			oPrinter:SayAlign(_nLin,0660, Transform((cAlias)->QUANT,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nQTotReal += (cAlias)->QUANT
			DbSkip()
		ElseIf (cAlias)->MES == 11
			oPrinter:SayAlign(_nLin,0714, Transform((cAlias)->QUANT,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nQTotReal += (cAlias)->QUANT
			DbSkip()
		ElseIf (cAlias)->MES == 12
			oPrinter:SayAlign(_nLin,0768, Transform((cAlias)->QUANT,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nQTotReal += (cAlias)->QUANT
			DbSkip()
		EndIf
	Enddo
EndIf
oPrinter:SayAlign(_nLin,0120, Transform(_nQTotReal,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)

_nLin += _nEspPad
_nPVReal := 0
_nPQReal := 0
oPrinter:SayAlign(_nLin,0025, "Pre็o Act.",   oFont02, 0800-0005,0060,,0,2)
DbSelectArea(cAlias)
DbGoTop()
If (cAlias)->(!EOF())
	While !Eof()
		
		If (cAlias)->MES == 1
			oPrinter:SayAlign(_nLin,0174, Transform((cAlias)->VALOR / (cAlias)->QUANT,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
			_nPVReal += (cAlias)->VALOR
			_nPQReal += (cAlias)->QUANT
			DbSelectArea(cAlias)
			DbSkip()
		ElseIf (cAlias)->MES == 2
			oPrinter:SayAlign(_nLin,0228, Transform((cAlias)->VALOR / (cAlias)->QUANT,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
			_nPVReal += (cAlias)->VALOR
			_nPQReal += (cAlias)->QUANT
			DbSelectArea(cAlias)
			DbSkip()
		ElseIf (cAlias)->MES == 3
			oPrinter:SayAlign(_nLin,0282, Transform((cAlias)->VALOR / (cAlias)->QUANT,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
			_nPVReal += (cAlias)->VALOR
			_nPQReal += (cAlias)->QUANT
			DbSelectArea(cAlias)
			DbSkip()
		ElseIf (cAlias)->MES == 4
			oPrinter:SayAlign(_nLin,0336, Transform((cAlias)->VALOR / (cAlias)->QUANT,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
			_nPVReal += (cAlias)->VALOR
			_nPQReal += (cAlias)->QUANT
			DbSelectArea(cAlias)
			DbSkip()
		ElseIf (cAlias)->MES == 5
			oPrinter:SayAlign(_nLin,0390, Transform((cAlias)->VALOR / (cAlias)->QUANT,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
			_nPVReal += (cAlias)->VALOR
			_nPQReal += (cAlias)->QUANT
			DbSelectArea(cAlias)
			DbSkip()
		ElseIf (cAlias)->MES == 6
			oPrinter:SayAlign(_nLin,0444, Transform((cAlias)->VALOR / (cAlias)->QUANT,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
			_nPVReal += (cAlias)->VALOR
			_nPQReal += (cAlias)->QUANT
			DbSelectArea(cAlias)
			DbSkip()
		ElseIf (cAlias)->MES == 7
			oPrinter:SayAlign(_nLin,0498, Transform((cAlias)->VALOR / (cAlias)->QUANT,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
			_nPVReal += (cAlias)->VALOR
			_nPQReal += (cAlias)->QUANT
			DbSelectArea(cAlias)
			DbSkip()
		ElseIf (cAlias)->MES == 8
			oPrinter:SayAlign(_nLin,0552, Transform((cAlias)->VALOR / (cAlias)->QUANT,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
			_nPVReal += (cAlias)->VALOR
			_nPQReal += (cAlias)->QUANT
			DbSelectArea(cAlias)
			DbSkip()
		ElseIf (cAlias)->MES == 9
			oPrinter:SayAlign(_nLin,0606, Transform((cAlias)->VALOR / (cAlias)->QUANT,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
			_nPVReal += (cAlias)->VALOR
			_nPQReal += (cAlias)->QUANT
			DbSelectArea(cAlias)
			DbSkip()
		ElseIf (cAlias)->MES == 10
			oPrinter:SayAlign(_nLin,0660, Transform((cAlias)->VALOR / (cAlias)->QUANT,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
			_nPVReal += (cAlias)->VALOR
			_nPQReal += (cAlias)->QUANT
			DbSelectArea(cAlias)
			DbSkip()
		ElseIf (cAlias)->MES == 11
			oPrinter:SayAlign(_nLin,0714, Transform((cAlias)->VALOR / (cAlias)->QUANT,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
			_nPVReal += (cAlias)->VALOR
			_nPQReal += (cAlias)->QUANT
			DbSelectArea(cAlias)
			DbSkip()
		ElseIf (cAlias)->MES == 12
			oPrinter:SayAlign(_nLin,0768, Transform((cAlias)->VALOR / (cAlias)->QUANT,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
			_nPVReal += (cAlias)->VALOR
			_nPQReal += (cAlias)->QUANT
			DbSelectArea(cAlias)
			DbSkip()
		EndIf
	Enddo
EndIf
oPrinter:SayAlign(_nLin,0120, Transform(_nPVReal / _nPQReal,"@E 999,999,999.99"), oFont04, 0800-0005,0060,,0,2)
_nLin += _nEspPad

oPrinter:SayAlign(_nLin,0025, "Receita Act.",   oFont02, 0800-0005,0060,,0,2)
DbSelectArea(cAlias)
DbGoTop()
If (cAlias)->(!EOF())
	While !Eof()
		
		If (cAlias)->MES == 1
			oPrinter:SayAlign(_nLin,0174, Transform((cAlias)->VALOR,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nVTotReal += (cAlias)->VALOR
			DbSelectArea(cAlias)
			DbSkip()
		ElseIf (cAlias)->MES == 2
			oPrinter:SayAlign(_nLin,0228, Transform((cAlias)->VALOR,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nVTotReal += (cAlias)->VALOR
			DbSelectArea(cAlias)
			DbSkip()
		ElseIf (cAlias)->MES == 3
			oPrinter:SayAlign(_nLin,0282, Transform((cAlias)->VALOR,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nVTotReal += (cAlias)->VALOR
			DbSelectArea(cAlias)
			DbSkip()
		ElseIf (cAlias)->MES == 4
			oPrinter:SayAlign(_nLin,0336, Transform((cAlias)->VALOR,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nVTotReal += (cAlias)->VALOR
			DbSelectArea(cAlias)
			DbSkip()
		ElseIf (cAlias)->MES == 5
			oPrinter:SayAlign(_nLin,0390, Transform((cAlias)->VALOR,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nVTotReal += (cAlias)->VALOR
			DbSelectArea(cAlias)
			DbSkip()
		ElseIf (cAlias)->MES == 6
			oPrinter:SayAlign(_nLin,0444, Transform((cAlias)->VALOR,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nVTotReal += (cAlias)->VALOR
			DbSelectArea(cAlias)
			DbSkip()
		ElseIf (cAlias)->MES == 7
			oPrinter:SayAlign(_nLin,0498, Transform((cAlias)->VALOR,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nVTotReal += (cAlias)->VALOR
			DbSelectArea(cAlias)
			DbSkip()
		ElseIf (cAlias)->MES == 8
			oPrinter:SayAlign(_nLin,0552, Transform((cAlias)->VALOR,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nVTotReal += (cAlias)->VALOR
			DbSelectArea(cAlias)
			DbSkip()
		ElseIf (cAlias)->MES == 9
			oPrinter:SayAlign(_nLin,0606, Transform((cAlias)->VALOR,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nVTotReal += (cAlias)->VALOR
			DbSelectArea(cAlias)
			DbSkip()
		ElseIf (cAlias)->MES == 10
			oPrinter:SayAlign(_nLin,0660, Transform((cAlias)->VALOR,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nVTotReal += (cAlias)->VALOR
			DbSelectArea(cAlias)
			DbSkip()
		ElseIf (cAlias)->MES == 11
			oPrinter:SayAlign(_nLin,0714, Transform((cAlias)->VALOR,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nVTotReal += (cAlias)->VALOR
			DbSelectArea(cAlias)
			DbSkip()
		ElseIf (cAlias)->MES == 12
			oPrinter:SayAlign(_nLin,0768, Transform((cAlias)->VALOR,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)
			_nVTotReal += (cAlias)->VALOR
			DbSelectArea(cAlias)
			DbSkip()
		EndIf
	Enddo
EndIf
oPrinter:SayAlign(_nLin,0120, Transform(_nVTotReal,"@E 999,999,999"), oFont04, 0800-0005,0060,,0,2)

_nLin += _nEspPad

oPrinter:Line( 80-5, 0115, 0380+15, 0115,,"-4")
oPrinter:Line( 80-5, 0169, 0380+15, 0169,,"-4")
oPrinter:Line( 80-5, 0223, 0380+15, 0223,,"-4")
oPrinter:Line( 80-5, 0277, 0380+15, 0277,,"-4")
oPrinter:Line( 80-5, 0331, 0380+15, 0331,,"-4")
oPrinter:Line( 80-5, 0385, 0380+15, 0385,,"-4")
oPrinter:Line( 80-5, 0439, 0380+15, 0439,,"-4")
oPrinter:Line( 80-5, 0493, 0380+15, 0493,,"-4")
oPrinter:Line( 80-5, 0547, 0380+15, 0547,,"-4")
oPrinter:Line( 80-5, 0601, 0380+15, 0601,,"-4")
oPrinter:Line( 80-5, 0655, 0380+15, 0655,,"-4")
oPrinter:Line( 80-5, 0709, 0380+15, 0709,,"-4")
oPrinter:Line( 80-5, 0763, 0380+15, 0763,,"-4")
oPrinter:Line( 80-5, 0817, 0380+15, 0817,,"-4")

//   EndIf

oPrinter:EndPage()
dbSelectArea(cAlias)
(cAlias)->(dbSkip())

dbSelectArea(_cAlias)
(_cAlias)->(dbSkip())

If lPreview
	oPrinter:Preview()
EndIf

FreeObj(oPrinter)
oPrinter := Nil

dbSelectArea(_cAlias)
dbCloseArea()

Return()

Static Function TelaTitulos(aTitulos,nTotalPV,nPedTot,nCount,nCountProd)

Local nU		:= 0
Local oList1
Local oMark
Local aAreaAtu	:= GetArea()            //C5_FILIAL,C5_NUM,C5_XOS,C5_CLIENTE,A1_NOME,C5_CONDPAG,DESPESA,HONORARIOS,TOTAL,C5_INCISS,C5_RECISS
Local aLabel	:= {" ","Cod Cliente","Loja","Descri็ใo","Cnpj/CGC"}
Local lRetorno	:= .T.
Local lMark		:= .F.
Local cList1
Local oDlg1
Local cBusca :=Space(40)
Local olDgg
Local aTitulos2:={}
//Local cValor := cValor

Private cTitulo := "Clientes"
Private oOkm			:= LoadBitMap(GetResources(),"LBOK")
Private oNom			:= LoadBitMap(GetResources(),"NADA")


DEFINE MSDIALOG oDlg1 TITLE cTitulo From 000,000 To 520,1240 OF oMainWnd PIXEL //Cria Tela//DEFINE MSDIALOG oDlg1 TITLE cTitulo From 000,000 To 420,940 OF oMainWnd PIXEL //Cria Tela

@ 030,003 LISTBOX oList1 VAR cList1 Fields HEADER ;           //Escreve o titulo das colunas da Grid  inicio
aLabel[1],;
aLabel[2],;
aLabel[3],;
aLabel[4],;
aLabel[5];
SIZE 613,210  NOSCROLL PIXEL //Escreve o titulo das colunas da Grid  inicio//SIZE 463,175  NOSCROLL PIXEL //Escreve o titulo das colunas da Grid  inicio

oList1:SetArray(aTitulos)

oList1:bLine	:= {|| {	If(aTitulos[oList1:nAt,1], oOkm, oNom),; 	//
aTitulos[oList1:nAt,2],;
aTitulos[oList1:nAt,3],;
aTitulos[oList1:nAt,4],;
aTitulos[oList1:nAt,5]}}

oList1:blDblClick 	:= {|| aTitulos[oList1:nAt,1] := !aTitulos[oList1:nAt,1], oList1:Refresh() } //Carrega a linha selecionada com o contrario do atual e atualiza o objeto para mostrar ao usuario

lSortOrd := .F. // Ordena ascendente ou descendente

oList1:bHeaderClick := {|| fSelectAll(aTitulos,oList1)}//:= Ascan(aTitulos,{|x|x[1]==cVarPesq})}

oList1:cToolTip		:= "Duplo click para marcar/desmarcar o produto"

oList1:Refresh()


@ 015,260 MSGET olDgg VAR cBusca SIZE 135, 010 OF oDlg1  COLORS 0, 16777215 PIXEL
@ 015,450 BUTTON "Gravar" SIZE 035, 011 PIXEL OF oDlg1 ACTION Close(oDlg1)//FTROCAR(aTitulos,oDlg1)
@ 015,410 BUTTON "Filtrar" SIZE 035, 011 PIXEL OF oDlg1 ACTION fSort(aTitulos,cBusca,oDlg1)//FTROCAR(aTitulos,oDlg1)


ACTIVATE MSDIALOG oDlg1 CENTERED

For nU:= 1 to Len(aTitulos)
	If aTitulos[nU][1]
		aAdd(aTitulos2,{aTitulos[nu][1],;
		aTitulos[nu][2],;
		aTitulos[nu][3],;
		aTitulos[nu][4],;
		aTitulos[nu][5]})
		
	EndIf
Next
Return (aTitulos2)

Static Function fSelectAll(aTitulos,oList1)

Local i := 0

For i:=1 to Len(aTitulos)
	aTitulos[i,1] := !aTitulos[i,1]
Next i
oList1:Refresh()
Return

Static Function fSort(aGrid,cBusca,oList4,cTipo,oDlg2) 

Local nJ := 0

cBusca := UPPER(cBusca) 
If cTipo == "C"
	If UPPER(Alltrim(Substr(cBusca,1,1)))  $ "ABCDEFGHIJLMNOPQRSTUVXZ"
		n := 4
	ELSEIF Len(UPPER(Alltrim(cBusca))) == 2
		n := 3
	Else
		n := 2
	EnDIf
	If n == 4
			If SELECT("TMP2")
				TMP2->(DbCloseArea())
			EndIf
			cQry:="SELECT A1_COD,A1_LOJA,A1_NOME,A1_CGC FROM SA1010 where D_E_L_E_T_ ='' and A1_NOME LIKE '%"+Alltrim(cBusca)+"%' order by A1_COD"
			cQry:=ChangeQuery(cQry)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TMP2",.T.,.F.)
			   
			nResult := 0     
			If ("TMP2")->(!EOF())
			aGrid2 := oList4:aArray  
			aGrid := {}
			EndIf
			While ("TMP2")->(!EOF()) 
			nResult++
				aAdd(aGrid,{.F.,;
				("TMP2")->A1_COD,;
				("TMP2")->A1_LOJA,;
				trim(("TMP2")->A1_NOME),;
				("TMP2")->A1_CGC}) 
				("TMP2")->(dbSkip())
			EndDo   
			If nResult > 0
				For nJ := 1 to nResult
					nrPos := aScan(oList4:aArray, {|x| AllTrim(Upper(x[2]+x[3])) == trim(aGrid[nJ,2])+trim(aGrid[nJ,3])})
					If nrPos > 0
						aGrid[nJ][1] := oList4:aArray[nrPos,1]
					EndIf          
					/*
					aSort(aGrid,,,{|x,y|alltrim(x[2]+x[3])  == alltrim(oList4:aArray[nJ,2]+oList4:aArray[nJ,3])   } )
					If oList4:aArray[nJ,2]  == aGrid[1][2]   .and.  oList4:aArray[nJ,3]  == aGrid[1][3]
						aGrid[1][1] := oList4:aArray[nJ,1]
					Endif
					*/
				Next
				oList4:SetArray(aGrid)
				oList4:cToolTip		:= "Duplo click para marcar/desmarcar o cliente."
				oList4:bLine	:= {|| {	If(aGrid[oList4:nAt,1], oOkm, oNom),; 	//
				aGrid[oList4:nAt,2],;
				aGrid[oList4:nAt,3],;
				aGrid[oList4:nAt,4],;
				aGrid[oList4:nAt,5]}}
				oList4:blDblClick 	:= {|| aGrid[oList4:nAt,1] := !aGrid[oList4:nAt,1], oList4:Refresh() } //Carrega a linha selecionada com o contrario do atual e atualiza o objeto para mostrar ao usuario
				oList4:bHeaderClick := {|| fSelectAll(aGrid,oList4)}//:= Ascan(aTitulos,{|x|x[1]==cVarPesq})}
				oList4:Refresh() 
			Else  
				Alert('Nenhum cliente encontrado com esse nome.')
			EndIf
	Else                                                                  
		
		If Alltrim(cBusca) == ''
			For nJ := 1 to len (oList4:aArray)
				nrPos := aScan(oList4:aArray, {|x| AllTrim(Upper(x[2]+x[3])) == trim(aGrid2[nJ,2])+trim(aGrid2[nJ,3])})
				If nrPos > 0
					aGrid2[nrPos][1] := oList4:aArray[nJ,1]
				EndIf    
				/*
				aSort(aGrid2,,,{|x,y|alltrim(x[2]+x[3])  == alltrim(oList4:aArray[nJ,2]+oList4:aArray[nJ,3])   } )
				If oList4:aArray[nJ,2]  == aGrid2[1][2]   .and.  oList4:aArray[nJ,3]  == aGrid2[1][3]
					aGrid2[1][1] := oList4:aArray[nJ,1]
				Endif
				*/
			Next
			oList4:setArray(aGrid2)
			oList4:cToolTip		:= "Duplo click para marcar/desmarcar o cliente.
			oList4:bLine	:= {|| {	If(aGrid2[oList4:nAt,1], oOkm, oNom),; 	//
			aGrid2[oList4:nAt,2],;
			aGrid2[oList4:nAt,3],;
			aGrid2[oList4:nAt,4],;
			aGrid2[oList4:nAt,5]}}
			oList4:blDblClick 	:= {|| aGrid2[oList4:nAt,1] := !aGrid2[oList4:nAt,1], oList4:Refresh() } //Carrega a linha selecionada com o contrario do atual e atualiza o objeto para mostrar ao usuario
			oList4:bHeaderClick := {|| fSelectAll(aGrid2,oList4)}//:= Ascan(aTitulos,{|x|x[1]==cVarPesq})}
			oList4:Refresh()
		Else
			aSort(aTitulos,,,{|x,y|x[n] == Alltrim(cBusca) })
		EndIf
	EndIf
	
ElseIf cTipo == "P"

	If UPPER(Alltrim(Substr(cBusca,1,1)))  $ "ABCDEFGHIJLMNOPQRSTUVXZ"
		n := 3
	Else
		n := 2
	EnDIf
	If n == 3
		If SELECT("TMP2")
			TMP2->(DbCloseArea())
		EndIf
		cQry:="SELECT B1_COD,B1_DESC,B1_TIPO FROM SB1010 where D_E_L_E_T_ ='' and B1_DESC LIKE '%"+Alltrim(cBusca)+"%' order by B1_COD"
		cQry:=ChangeQuery(cQry)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TMP2",.T.,.F.)
		
			   
			nResult := 0  
			If ("TMP2")->(!EOF())
			aGrid2 := oList4:aArray  
			aGrid := {}
			EndIf
			While ("TMP2")->(!EOF())  
				nResult++
				aAdd(aGrid,{.F.,;
				("TMP2")->B1_COD,;
				trim(("TMP2")->B1_DESC),;
				("TMP2")->B1_TIPO}) 
				("TMP2")->(dbSkip())
			EndDo  
			If nResult > 0
				For nJ := 1 to nResult
					nrPos := aScan(oList4:aArray, {|x| AllTrim(Upper(x[2])) == trim(aGrid[nJ,2])})
					If nrPos > 0
						aGrid[nJ][1] := oList4:aArray[nrPos,1]
					EndIf
				Next    
				oList7 := oList4
				oList7:SetArray(aGrid)
				oList7:cToolTip		:= "Duplo click para marcar/desmarcar o produto."
				oList7:bLine	:= {|| {	If(aGrid[oList7:nAt,1], oOkm, oNom),; 	//
				aGrid[oList7:nAt,2],;
				aGrid[oList7:nAt,3],;
				aGrid[oList7:nAt,4]}}
				oList7:blDblClick 	:= {|| aGrid[oList7:nAt,1] := !aGrid[oList7:nAt,1], oList7:Refresh() } //Carrega a linha selecionada com o contrario do atual e atualiza o objeto para mostrar ao usuario
				oList7:bHeaderClick := {|| fSelectAll(aGrid,oList7)}//:= Ascan(aTitulos,{|x|x[1]==cVarPesq})}
				oList7:Refresh()
			Else  
				Alert('Nenhum produto encontrado com esse nome.')		  
			EndIf
	Else
                                                
		
		If Alltrim(cBusca) == ''
			For nJ := 1 to len (oList7:aArray)
				nrPos := aScan(aGrid2, {|x| AllTrim(Upper(x[2])) == trim(oList7:aArray[nJ,2])})
				If nrPos > 0
					aGrid2[nrPos][1] := oList7:aArray[nJ,1]
				EndIf    
			Next
			oList7:setArray(aGrid2)
			oList7:cToolTip		:= "Duplo click para marcar/desmarcar o cliente.
			oList7:bLine	:= {|| {	If(aGrid2[oList7:nAt,1], oOkm, oNom),; 	//
			aGrid2[oList7:nAt,2],;
			aGrid2[oList7:nAt,3],;
			aGrid2[oList7:nAt,4]}}
			oList7:blDblClick 	:= {|| aGrid2[oList7:nAt,1] := !aGrid2[oList7:nAt,1], oList7:Refresh() } //Carrega a linha selecionada com o contrario do atual e atualiza o objeto para mostrar ao usuario
			oList7:bHeaderClick := {|| fSelectAll(aGrid2,oList7)}//:= Ascan(aTitulos,{|x|x[1]==cVarPesq})}
			oList7:Refresh()		  
		EndIf
	EndIf
	oList7:Refresh()

ElseIf cTipo == "CP"
	If UPPER(Alltrim(Substr(cBusca,1,1)))  $ "ABCDEFGHIJLMNOPQRSTUVXZ"
		n := 4
	Else
		n := 2
	EnDIf
	If n == 4
			If SELECT("TMP2")
				TMP2->(DbCloseArea())
			EndIf
			cQry:="SELECT A7_CLIENTE,A7_LOJA,A7_NOMECLI,A7_PRODUTO,A7_NOMEPRO FROM SA7010 A7 where A7.D_E_L_E_T_ ='' and (A7_NOMECLI LIKE '%"+Alltrim(cBusca)+"%' OR A7_NOMEPRO LIKE '%"+Alltrim(cBusca)+"%') order by A7_NOMECLI,A7_NOMEPRO "
			cQry:=ChangeQuery(cQry)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TMP2",.T.,.F.)
			   
			If ("TMP2")->(!EOF())
			aGrid2 := oList4:aArray  
			aGrid := {}
			EndIf
			nResult := 0
			While ("TMP2")->(!EOF()) 
			nResult++
				aAdd(aGrid,{.F.,;
				("TMP2")->A7_CLIENTE,;
				("TMP2")->A7_LOJA,;
				trim(("TMP2")->A7_NOMECLI),;
				("TMP2")->A7_PRODUTO,;
				trim(("TMP2")->A7_NOMEPRO)}) 
				("TMP2")->(dbSkip())
			EndDo   
			If nResult > 0
				For nJ := 1 to nResult
					nrPos := aScan(oList4:aArray, {|x| AllTrim(Upper(x[2]+x[3]+x[5])) == trim(aGrid[nJ,2])+trim(aGrid[nJ,3])+trim(aGrid[nJ,5])})
					If nrPos > 0
						aGrid[nJ][1] := oList4:aArray[nrPos,1]
					EndIf
				Next
				oList4:SetArray(aGrid)
				oList4:cToolTip		:= "Duplo click para marcar/desmarcar o cliente."
				oList4:bLine	:= {|| {	If(aGrid[oList4:nAt,1], oOkm, oNom),; 	//
				aGrid[oList4:nAt,2],;
				aGrid[oList4:nAt,3],;
				aGrid[oList4:nAt,4],;
				aGrid[oList4:nAt,5],;
				aGrid[oList4:nAt,6]}}
				oList4:blDblClick 	:= {|| aGrid[oList4:nAt,1] := !aGrid[oList4:nAt,1], oList4:Refresh() } //Carrega a linha selecionada com o contrario do atual e atualiza o objeto para mostrar ao usuario
				oList4:bHeaderClick := {|| fSelectAll(aGrid,oList4)}//:= Ascan(aTitulos,{|x|x[1]==cVarPesq})}
				oList4:Refresh() 
			Else  
				Alert('Nenhum cliente ou produto encontrado com esse nome.')
			EndIf
	Else                                                                  
		
		If Alltrim(cBusca) == ''
			For nJ := 1 to len (oList4:aArray)
					nrPos := aScan(aGrid2, {|x| AllTrim(Upper(x[2]+x[3]+x[5])) == trim(oList4:aArray[nJ,2])+trim(oList4:aArray[nJ,3])+trim(oList4:aArray[nJ,5])})
					If nrPos > 0
						aGrid2[nrPos][1] := oList4:aArray[nJ,1]
					EndIf
			Next
			oList4:setArray(aGrid2)
			oList4:cToolTip		:= "Duplo click para marcar/desmarcar o cliente.
			oList4:bLine	:= {|| {	If(aGrid2[oList4:nAt,1], oOkm, oNom),; 	//
			aGrid2[oList4:nAt,2],;
			aGrid2[oList4:nAt,3],;
			aGrid2[oList4:nAt,4],;
			aGrid2[oList4:nAt,5],;
			aGrid2[oList4:nAt,6]}}
			oList4:blDblClick 	:= {|| aGrid2[oList4:nAt,1] := !aGrid2[oList4:nAt,1], oList4:Refresh() } //Carrega a linha selecionada com o contrario do atual e atualiza o objeto para mostrar ao usuario
			oList4:bHeaderClick := {|| fSelectAll(aGrid2,oList4)}//:= Ascan(aTitulos,{|x|x[1]==cVarPesq})}
			oList4:Refresh()
		Else
			aSort(aTitulos,,,{|x,y|x[n] == Alltrim(cBusca) })
		EndIf
	EndIf
Endif

Return

Static Function fValid(aTitulos)

Local i := 0

nT:= 0
aTitulos[oList3:nAt,1] := !aTitulos[oList3:nAt,1]
For i:=1 to Len(aTitulos)
	
	if aTitulos[i,1]
		nT += 1
	Endif
Next i
If nT > 2
	aTitulos[oList3:nAt,1] := .F.
	lRet := .F.
	Alert("Nao ้ Permitido selecinar mais que dois Filtros")
Else
	lRet := .T.
Endif
Return lRet

Static Function fSelecuni(avEND,oList2)

Local i  := 0

avEND[oList2:nAt,1] := !avEND[oList2:nAt,1] 

For i:=1 to Len(avEND)
	
     If oList2:nAt <> i .and. avEND[i,1]
      avEND[i,1] := !avEND[i,1]
      EndIF
		
	
Next i
oList2:Refresh()
return     

Static Function  fLimpar(oDlg2)  
Close(oDlg2)
U_RCRMR010()
return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetPosReg บAutor  ณMicrosiga 	          บ Data ณ 13/02/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna a posi็ใo do registro pesquisado					  บฑฑ
ฑฑบ          ณ												    		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetPosReg(cCombPesq, oObjTel, aDados, oList, nLinha)

Local oCombo	:= Nil
Local cCombo	:= ""
Local oLabel	:= Nil
Local oObjPesq	:= NIL
Local oBtnPesq	:= Nil
Local oTGetPesq	:= Nil
Local cPesq		:= Space(500)
Local nRet		:= 0
Local aItCombo	:= {}
Local oFont 	:= TFont():New("CALIBRI",,10,.F.)	
Local lCHECK	:= .F.
Local oCheck	:= Nil

Default cCombPesq	:= ""
Default oObjTel		:= Nil
Default aDados		:= {}
Default oList		:= Nil
Default nLinha		:= 0

aItCombo 	:= Separa(cCombPesq,";")

//oLabel 		:= TSay():New(nLinha,80,{||"Tp.Pesq: "},oObjTel,,oFont,,,,.T.,CLR_BLUE,CLR_WHITE,100,010)
oCombo		:= TComboBox():New(nLinha,115,{|u| If(PCount()>0,cCombo := u,cCombo)},aItCombo,070,012,oObjTel,,{||},,,,.T.,,,,,,,,,"cCombo")
oTGetPesq	:= TGet():New(nLinha,190 ,bSetGet(cPesq),oObjTel,100,09,"@!", /*&(cBlkVld)*/,,,, .T.,, .T.,, .T., /*&(cBlkWhen)*/, .F., .F.,, .F., .F. ,"","cPesq",,,,.T.)
oCheck 		:= TCheckBox():New(nLinha+3,340,"Palavra Inteira ?",bSETGET(lCHECK),oObjTel,215,10,,,oObjTel:oFONT,,,,,.T.)
oBtnPesq 	:= thButton():New(nLinha-3,290, "Pesquisar"		, oObjTel,  {||; 
																			MsgRun( 'Aguarde...' , '', { || nRet := GetPesq(Val(SubStr(cCombo,1,1)), cPesq, aDados, @oList, lCHECK  ) } );
																			},35,20,)

Return nRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetPesq บAutor  ณMicrosiga 	          บ Data ณ 13/02/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRealiza a pesquisa 										  บฑฑ
ฑฑบ          ณ												    		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetPesq(nOpcPesq, cPesq, aDados, oList, lPalavInt  )

Local nRet		:= 0
Local nX		:= 0
Local lAchou	:= .F.
Local nY		:= 0
Local aDadosAux	:= {}

Default nOpcPesq	:= 0 
Default cPesq		:= "" 
Default aDados		:= {} 
Default lPalavInt	:= .F.

If lPalavInt//Pesquisa pela palavra inteira

	//Realiza a pesquisa a partir do registro posicionado
	For nX := (oList:nAt+1) To Len(aDados)
		aDadosAux	:= {}
		aDadosAux	:= Separa(StrTran(Upper(Alltrim(aDados[nX][nOpcPesq]))," ","|") ,"|")
		
		For nY := 1 To Len(aDadosAux)
			If Upper(Alltrim(cPesq)) == Upper(Alltrim(aDadosAux[nY])) 
				lAchou	:= .T.
				nRet	:= nX 
				Exit
			EndIf
		Next
		
		If lAchou
			Exit
		EndIf
	Next
	
	If !lAchou
		//Realiza a pesquisa em todos os itens
		For nX := 1 To Len(aDados)
			aDadosAux	:= {}
			aDadosAux	:= Separa(StrTran(Upper(Alltrim(aDados[nX][nOpcPesq]))," ","|") ,"|")
			
			For nY := 1 To Len(aDadosAux)
				If Upper(Alltrim(cPesq)) == Upper(Alltrim(aDadosAux[nY])) 
					lAchou	:= .T.
					nRet	:= nX 
					Exit
				EndIf
			Next
			
			If lAchou
				Exit
			EndIf
		Next	
	EndIf


Else//Pesquisa por qualquer parte do da palavra

	//Realiza a pesquisa a partir do registro posicionado
	For nX := (oList:nAt+1) To Len(aDados)
		If Upper(Alltrim(cPesq)) $ UPPER(Alltrim(aDados[nX][nOpcPesq]))
			lAchou	:= .T.
			nRet	:= nX 
			Exit
		EndIf
	Next
	
	If !lAchou
		//Realiza a pesquisa em todos os itens
		For nX := 1 To Len(aDados)
			If Upper(Alltrim(cPesq)) $ UPPER(Alltrim(aDados[nX][nOpcPesq]))
				lAchou	:= .T.
				nRet	:= nX 
				Exit
			EndIf
		Next	
	EndIf

EndIf

If !Empty(cPesq)
	If !lAchou
		Aviso("Aten็ใo","Nenhum item encontrado",{"Ok"},2)
	Else
		oList:nAt := nRet
		oList:Refresh()
	EndIf
EndIf

Return nRet
