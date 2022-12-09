#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

/*
+ =========================================================+
|Programa: LSMID003 |Autor: Antonio Carlos |Data: 29/03/11 |
+ =========================================================+
|Descrição: Gera Pedidos de Venda - Midia                  |
+ =========================================================+
|Uso: Especifico Laselva                                   |
+ =========================================================+
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LSMID003(aParam)
//////////////////////////////

Local cCadastro    	:= "Processa - Mídia (Locação de Espaço)"
Local aSays        	:= {}
Local aButtons     	:= {}
Local nOpc        	:= 0

Private oDlg
Private _dDatD		:= CTOD("  /  /  ")
Private _dDatA		:= CTOD("  /  /  ")
Private oProcess
Private _lJob		:= (aParam <> Nil .Or. ValType(aParam) == "A")
_cEnter := chr(13) + chr(10)

If !_lJob
	DEFINE MSDIALOG oDlg FROM 000,000 TO 220,400 TITLE cCadastro PIXEL
	
	@ 05,05 TO 80,200 PIXEL
	
	@ 010,010 SAY " Esta rotina tem como objetivo gerar os Pedidos de Venda/Nota Fiscal referente " PIXEL OF oDlg
	@ 020,010 SAY " a locação de espaços nas Lojas. " 												PIXEL OF oDlg
	
	@ 040,050 SAY "Data de : " PIXEL OF oDlg
	@ 040,090 MSGET oDat1 VAR _dDatD SIZE 65,10 PIXEL OF oDlg
	
	@ 060,050 SAY "Data até : " PIXEL OF oDlg
	@ 060,090 MSGET oDat2 VAR _dDatA SIZE 65,10 PIXEL OF oDlg
	
	//@ 90,055 	BUTTON "Processa"		SIZE 040,015 OF oDlg PIXEL ACTION( Processa( { |lEnd| ProcCtr(@lEnd) },"Aguarde","Processando registros...",.T.) )
	@ 90,055 	BUTTON "Processa"		SIZE 040,015 OF oDlg PIXEL ACTION( ProcCtr(), oDlg:End() )
	@ 90,110 	BUTTON "Fechar"  		SIZE 040,015 OF oDlg PIXEL ACTION( oDlg:End() )
	
	ACTIVATE MSDIALOG oDlg CENTERED
Else
	_dDatD := date()
	_dDatA := date()	
EndIf

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function AtuDados()
//////////////////////////

Local aparam   := {"01","01"}
Local nHdlLock := 0
Local cArqLock := "LSMID003.lck"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Efetua o Lock de gravacao da Rotina - Monousuario            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FErase(cArqLock)
nHdlLock := MsFCreate(cArqLock)
If nHdlLock < 0
	Conout("Rotina " + FunName() + " ja em execução.")
	Return(.T.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa ambiente.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RpcSetType(3)
IF FindFunction('WFPREPENV')
	WfPrepEnv( aParam[1], aParam[2])
Else
	Prepare Environment Empresa aParam[1] Filial aParam[2]
EndIF
ChkFile("SM0")

Integra()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha filial corrente.						   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _lJob
	Reset Environment
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cancela o Lock de gravacao da rotina                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FClose(nHdlLock)
FErase(cArqLock)

Return(.T.)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ProcCtr()
/////////////////////////

Local oOk       	:= LoadBitmap( GetResources(), "LBOK")
Local oNo       	:= LoadBitmap( GetResources(), "LBNO")
Local _lFecha		:= .T.

Private lInvFil		:= .F.
Private lInvCtr		:= .F.
Private _aRegP		:= {}
Private cStrCon		:= ""
Private cStrCona	:= ""
Private cCadastro	:= "Contratos Mídia"

_cQryI := " SELECT PAE_FILIAL, PAE_NUMCON, PAC_CLIENT, PAC_LOJACL, A1_NOME, PAE_PARCEL, PAE_DATA "
_cQryI += _cEnter + " FROM " + RetSqlname("PAE") + " PAE (NOLOCK) "

_cQryI += _cEnter + " INNER JOIN " + RetSqlname("PAC") + " PAC (NOLOCK) "
_cQryI += _cEnter + " ON PAC_FILIAL			= PAE_FILIAL"
_cQryI += _cEnter + " AND PAC_NUM 			= PAE_NUMCON"
_cQryI += _cEnter + " AND PAC.D_E_L_E_T_	= '' "

_cQryI += _cEnter + " INNER JOIN " + RetSqlName("SA1") + " SA1 (NOLOCK) "
_cQryI += _cEnter + " ON A1_COD 			= PAC_CLIENT"
_cQryI += _cEnter + " AND PAC_LOJACL 		= A1_LOJA"
_cQryI += _cEnter + " AND SA1.D_E_L_E_T_ 	= '' "

_cQryI += _cEnter + " WHERE PAE_DATA BETWEEN '" + DTOS(_dDatD) + "'"
_cQryI += _cEnter + " AND '" + DTOS(_dDatA) + "'"
_cQryI += _cEnter + " AND PAE_SITUA 		= '' AND "
_cQryI += _cEnter + " PAE.D_E_L_E_T_ 		= '' "

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQryI), 'TMPI', .F., .T.)

DbSelectArea("TMPI")
Do While TMPI->( !Eof() )
	Aadd(_aRegP, {.F., TMPI->PAE_NUMCON, TMPI->PAC_CLIENT, TMPI->PAC_LOJACL,Substr(TMPI->A1_NOME,1,30), TMPI->PAE_PARCEL, STOD(TMPI->PAE_DATA) } )
	TMPI->( DbSkip() )
EndDo

If Len(_aRegP) > 0
	DEFINE MSDIALOG oDlgCtr TITLE cCadastro STYLE DS_MODALFRAME FROM 0,0 To 450,680 OF oMainWnd PIXEL
	oDlgCtr:lEscClose := .F.
	
	//Group Box de Contrato
	@ 05,10 TO 200,335 LABEL "Contratos:" OF oDlgCtr PIXEL
	
	//"Inverter Selecao"
	@ 15,15 CHECKBOX oChkInvFil VAR lInvFil PROMPT "Inverter Selecao" SIZE 50,10 OF oDlgCtr PIXEL ON CLICK (AEval(_aRegP , {|z| z[1] := !z[1]}), oLstCtr:Refresh(.F.))
	
	//"Contratos"
	@ 30,15 LISTBOX oLstCtr VAR cVarCtr Fields HEADER "","Contrato","Cliente","Loja","Nome","Parcela","Data", SIZE 310,160;
	ON DBLCLICK ( _aRegP[oLstCtr:nAt,1] := !_aRegP[oLstCtr:nAt,1], oLstCtr:Refresh());
	ON RIGHT CLICK ListBoxAll(nRow,nCol,@oLstCtr,oOk,oNo,@_aRegP) OF oDlgCtr PIXEL

	oLstCtr:SetArray(_aRegP)
	oLstCtr:bLine := { || { If(_aRegP[oLstCtr:nAt,1],oOk,oNo),_aRegP[oLstCtr:nAt,2],_aRegP[oLstCtr:nAt,3],_aRegP[oLstCtr:nAt,4],;
	_aRegP[oLstCtr:nAt,5],_aRegP[oLstCtr:nAt,6],_aRegP[oLstCtr:nAt,7] }}
	
	DEFINE SBUTTON FROM 210,180 TYPE 1 ACTION(Processa({|lEnd| Integra(@lEnd)},"Aguarde","Processando registros...",.T.),oDlgCtr:End())  ENABLE OF oDlgCtr
	DEFINE SBUTTON FROM 210,210 TYPE 2 ACTION( oDlgCtr:End() )  ENABLE OF oDlgCtr
	
	ACTIVATE MSDIALOG oDlgCtr CENTERED
Else
	MsgStop("Não existem registros para processamento!")
EndIf

TMPI->( DbCloseArea() )

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Integra()
/////////////////////////

Local aArea		:= GetArea()
Local _aNFisc	:= {}
Local _nReg		:= 0
Local nTotRec	:= 0

Private _Arq
Private nFal
Private _aRegis	:= {}
Private _aRegi	:= {}
Private _nValCtr:= 0
Private _cNumPV	:= Space(6)
Private _cNota	:= Space(9)
Private cSerie	:= GetMv("LS_SERSERV")
Private cPath	:= "d:\protheus_data\midia\"

AEval(_aRegP, {|x| If(x[1]==.T.,cStrCona+="'" + SubStr(x[2],1,TamSX3("PAE_NUMCON")[1]) + "'" + ",",Nil)})
cStrCon := Substr(cStrCona,1,Len(cStrCona)-1)

If !_lJob .and. Empty(cStrCon)
	MsgStop("Selecione o(s) contratos para processamento!")
	Return(.F.)
EndIf

cQry := " SELECT * "
cQry += _cEnter + " FROM " + RetSqlName("PAE") + " PAE (NOLOCK) "

If _lJob
	cQry += _cEnter + " WHERE PAE_DATA = '" + DTOS(dDatabase) + "' AND PAE_SITUA = '' "
Else
	cQry += _cEnter + " WHERE PAE_DATA BETWEEN '" + DTOS(_dDatD) + "' AND '" + DTOS(_dDatA) + "' AND PAE_SITUA = '' AND "
	cQry += _cEnter + " PAE_NUMCON IN (" + cStrCon + ") AND PAE_SITUA = '' "
EndIf
cQry += _cEnter + " AND PAE.D_E_L_E_T_ = '' "

DbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), 'PEDVEN', .F., .T.)

Count To nTotRec
DbGoTop()
If !Eof()
	
	Do While !Eof()
		
		If !_lJob
			ProcRegua(nTotRec)
		EndIf
		
		Begin Transaction
		GeraPed(PEDVEN->PAE_FILIAL,PEDVEN->PAE_NUMCON)
		GravaNFS(_cNumPV)
		
		
		DbSelectArea("PAE")
		PAE->( DbSetOrder(1) )
		If PAE->( DbSeek( PEDVEN->PAE_FILIAL + PEDVEN->PAE_NUMCON + PEDVEN->PAE_PARCEL ) )
			RecLock("PAE",.F.)
			PAE->PAE_PEDVEN := _cNumPV
			PAE->PAE_SITUA	:= "P"
			PAE->( MsUnLock() )
		EndIf
		
		DbSelectArea("PAC")
		PAC->( DbSetOrder(1) )
		If PAC->( DbSeek( PEDVEN->PAE_FILIAL + PEDVEN->PAE_NUMCON ) )
			
			_nValCtr := PAC->PAC_VALOR
			
			Aadd( _aRegi,{ PAC->PAC_NUM,;
			PAC->PAC_CLIENT + "-" + PAC->PAC_LOJACL,;
			Posicione("SA1",1,xFilial("SA1") + PAC->PAC_CLIENT + PAC->PAC_LOJACL,Alltrim("A1_NOME")),PEDVEN->PAE_DATA,;
			PEDVEN->PAE_PARCEL,;
			_cNumPV,;
			_cNota,;
			Alltrim(cSerie),;
			PAC->PAC_VALOR,;
			Posicione("SX5",1,Space(2) + "ZS" + PAC->PAC_FORMA,Alltrim("X5_DESCRI")) } )
			
			If PAC->PAC_STATUS == "I"
				RecLock("PAC",.F.)
				PAC->PAC_STATUS := "P"
				PAC->( MsUnLock() )
			EndIf
		EndIf
		
		DbSelectArea("SC5")
		SC5->( DbSetOrder(1) )
		If SC5->( DbSeek( PEDVEN->PAE_FILIAL + _cNumPV ) )
			If !Empty(SC5->C5_NOTA)
				Aadd( _aNFisc, { PEDVEN->PAE_FILIAL,PEDVEN->PAE_NUMCON,PEDVEN->PAE_PARCEL,SC5->C5_NOTA,SC5->C5_CLIENTE,SC5->C5_LOJACLI,_nValCtr } )
			EndIf
		EndIf
		
		cQryA := " SELECT COALESCE(COUNT(*),0) AS REG "
		cQryA += _cEnter + " FROM " + RetSqlName("PAE") + " PAE (NOLOCK) "
		cQryA += _cEnter + " WHERE PAE_FILIAL = '" + xFilial("PAE") + "'"
		cQryA += _cEnter + " AND PAE_NUMCON = '" + PEDVEN->PAE_NUMCON + "'"
		cQryA += _cEnter + " AND PAE_SITUA = '' "
		cQryA += _cEnter + " AND PAE.D_E_L_E_T_ = '' "
		DbUseArea(.T., "TOPCONN", TCGenQry(,,cQryA), 'TMPA', .F., .T.)
		
		If TMPA->REG == 0
			DbSelectArea("PAC")
			DbSetOrder(1)
			If DbSeek( PEDVEN->PAE_FILIAL + PEDVEN->PAE_NUMCON )
				RecLock("PAC",.F.)
				PAC->PAC_STATUS := "F"
				MsUnLock()
			EndIf
		EndIf
		DbCloseArea()

		End Transaction
		
		DbSelectArea('PEDVEN')
		DbSkip()
		
	EndDo
	
Else
	
	If !_lJob
		MsgStop("Não há registros para processamento...")
	EndIf
	
EndIf

DbCloseArea()
RestArea(aArea)

For _nI := 1 To Len(_aNFisc)
	
	_cHtml := ""
	_cHtml += _cEnter + "<html>"
	
	_cHtml += _cEnter + "<TABLE border=0 width=800>"
	_cHtml += _cEnter + "   <tr>"
	_cHtml += _cEnter + "      <td width=180><img src=\\192.168.0.197\Protheus_Data\workflow\laselva.jpg></img></td>"
	_cHtml += _cEnter + "   </tr>"
	_cHtml += _cEnter + "</TABLE>"
	
	_cHtml += _cEnter + "<BR>"
	
	_cHtml += _cEnter + "<p1>" + SM0->M0_ENDCOB + "</p1>"
	_cHtml += _cEnter + "<BR>"
	_cHtml += _cEnter + "<p1>" + SM0->M0_CIDCOB + "-" + SM0->M0_CEPCOB + "</p1>"
	_cHtml += _cEnter + "<BR>"
	_cHtml += _cEnter + "<p1>Telefone:" + SM0->M0_CIDCOB + "-" + SM0->M0_CIDCOB + "</p1>"
	_cHtml += _cEnter + "<BR>"
	_cHtml += _cEnter + "<p1>CNPJ:" + SM0->M0_CGC + "</p1>"
	
	_cHtml += _cEnter + "<BR>"
	_cHtml += _cEnter + "<BR>"
	
	_cHtml += _cEnter + "<p1>FATURA</p1>"
	_cHtml += _cEnter + "<BR>"
	_cHtml += _cEnter + "<p1>Nº DA FATURA: " + _aNFisc[_nI,4] + "</p1>"
	_cHtml += _cEnter + "<BR>"
	_cHtml += _cEnter + "<p1>DATA: " + DTOC(dDatabase) + "</p1>
	_cHtml += _cEnter + "<BR>"
	
	_cHtml += _cEnter + "<BR>"
	_cHtml += _cEnter + "<BR>"
	
	_cHtml += _cEnter + "<p1>Fatura para:</p1>"
	_cHtml += _cEnter + "<BR>"
	_cHtml += _cEnter + "<BR>"
	
	DbSelectArea("SA1")
	SA1->( DbSetOrder(1) )
	SA1->( DbSeek( xFilial("SA1") + _aNFisc[_nI,5] + _aNFisc[_nI,6] ) )
	
	_cHtml += _cEnter + "<p1>" + Substr(SA1->A1_NOME,1,30) + "</p1>"
	_cHtml += _cEnter + "<BR>"
	_cHtml += _cEnter + "<p1>" + SA1->A1_END + "-" + SA1->A1_BAIRRO + "</p1>"
	_cHtml += _cEnter + "<BR>"
	_cHtml += _cEnter + "<p1>" + SA1->A1_MUN + "-" + SA1->A1_EST + "-" + SA1->A1_CEP + "</p1>"
	_cHtml += _cEnter + "<BR>"
	_cHtml += _cEnter + "<p1>" + SA1->A1_CGC + "</p1>"
	_cHtml += _cEnter + "<BR>"
	_cHtml += _cEnter + "<BR>"
	_cHtml += _cEnter + "<BR>"
	
	_cHtml += _cEnter + "<table border=1 >"
	
	_cHtml += _cEnter + "<tr>"
	_cHtml += _cEnter + "	<th>Descricao</th>"
	_cHtml += _cEnter + "	<th>Valor</th>"
	_cHtml += _cEnter + "</tr>"
	
	_cHtml += _cEnter + "<tr>"
	_cHtml += _cEnter + "	<td> LOCACAO DE BEM MOVEL COM ESPACO FISICO DISPONIVEL PARA VEICULACAO DE PROPAGANDA</td>"
	_cHtml += _cEnter + "	<td>" + Transform(_aNFisc[_nI,7],"@E 999,999,999.99") + "</td>"
	_cHtml += _cEnter + "</tr>"
	
	_cHtml += _cEnter + "<tr>"
	_cHtml += _cEnter + "	<th>Total</th>"
	_cHtml += _cEnter + "	<th>" + Transform(_aNFisc[_nI,7],"@E 999,999,999.99") + "</th>"
	_cHtml += _cEnter + "</tr>"
	
	_cHtml += _cEnter + "</table>"
	
	_cHtml += _cEnter + "<BR>"
	_cHtml += _cEnter + "<BR>"
	_cHtml += _cEnter + "<BR>"
	
	_cHtml += _cEnter + "<table border=1 >"
	
	_cHtml += _cEnter + "<tr>"
	_cHtml += _cEnter + "	<th>Referente a Locação de Espaço</th>"
	_cHtml += _cEnter + "</tr>"
	
	cQryB := " SELECT DISTINCT(PAD_LOJA) AS LOJA "
	cQryB += _cEnter + " FROM " + RetSqlName("PAD") + " PAD (NOLOCK) "
	cQryB += _cEnter + " WHERE PAD_FILIAL = '" + _aNFisc[_nI,1] + "' "
	cQryB += _cEnter + " AND PAD_NUM = '" + _aNFisc[_nI,2] + "' "
	cQryB += _cEnter + " AND PAD.D_E_L_E_T_ = '' "
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQryB), 'TMPB', .F., .T.)
	
	Do While Eof()
		
		_cHtml += _cEnter + "<tr>"
		_cHtml += _cEnter + "	<td>" + GetAdvFval("SM0",Alltrim("M0_FILIAL"), _aNFisc[_nI,1] + TMPB->LOJA) + "</td>"
		_cHtml += _cEnter + "</tr>"
		
		DbSkip()
		
	EndDo
	DbCloseArea()
	
	_cHtml += _cEnter + "</table>"
	
	_cHtml += _cEnter + "<BR>"
	_cHtml += _cEnter + "<BR>"
	_cHtml += _cEnter + "<BR>"
	
	_cHtml += _cEnter + "<p1>OBS: Atividade fora do campo de atuação do ISS - Imposto sobre Serviço de Qualquer Natureza</p1>"
	_cHtml += _cEnter + "<BR>"
	_cHtml += _cEnter + "<p1>conforme itens  3.01 e 17.07 da Lista de Serviços anexa a Lei Complementar nº 116/2003.</p1>"
	_cHtml += _cEnter + "<BR>"
	_cHtml += _cEnter + "<p1>Dispensa de emissão de Nota Fiscal, conforme determinações dos artigos 1º e 82 do Decreto nº</p1>"
	_cHtml += _cEnter + "<BR>"
	_cHtml += _cEnter + "<p1>50896/2009 (RISS - Municipio de São Paulo).</p1>"
	_cHtml += _cEnter + "<BR>"
	
	_cHtml += _cEnter + "</html>"
	
	_cSubjep := "Processamento - Midia Locacao de Espacos"
	_cTo := GetMv("LS_EMMIDFI")
	
	U_EnvMail(_cTo, _cSubjep, _cHtml)
	
Next _nI

If Len(_aRegi) > 0
	
	_cHtmp := ""
	_cHtmp += _cEnter + "<html>"
	
	_cHtmp += _cEnter + "	<TABLE border=0 width=800>"
	_cHtmp += _cEnter + "		<tr>"
	_cHtmp += _cEnter + "			<td width=180><img src=192.168.0.197\Protheus_Data\workflow\laselva.jpg></img></td>"
	_cHtmp += _cEnter + "		</tr>"
	_cHtmp += _cEnter + " </TABLE>"
	
	_cHtmp += _cEnter + "<BR>"
	
	_cHtmp += _cEnter + "<p1>Midia - Processamento Locacao de Espacos</p1>"
	_cHtmp += _cEnter + "<BR>"
	_cHtmp += _cEnter + "<BR>"
	
	_cHtmp += _cEnter + "<table border=1 >"
	
	_cHtmp += _cEnter + "<tr>"
	_cHtmp += _cEnter + "	<th>Contrato</th>"
	_cHtmp += _cEnter + "	<th>Cliente/Loja</th>"
	_cHtmp += _cEnter + "	<th>Nome</th>"
	_cHtmp += _cEnter + "	<th>Data</th>"
	_cHtmp += _cEnter + "	<th>Parcela</th>"
	_cHtmp += _cEnter + "	<th>Pedido</th>"
	_cHtmp += _cEnter + "	<th>Nota Fiscal</th>"
	_cHtmp += _cEnter + "	<th>Serie</th>"
	_cHtmp += _cEnter + "	<th>Valor</th>"
	_cHtmp += _cEnter + "	<th>Forma Pagto</th>"
	
	For _nI := 1 To Len(_aRegi)
		
		_cHtmp += _cEnter + "<tr>"
		_cHtmp += _cEnter + "	<td>" + _aRegi[_nI,1] + "</td>"
		_cHtmp += _cEnter + "	<td>" + _aRegi[_nI,2] + "</td>"
		_cHtmp += _cEnter + "	<td>" + _aRegi[_nI,3] + "</td>"
		_cHtmp += _cEnter + "	<td>" + DTOC(STOD(_aRegi[_nI,4])) + "</td>"
		_cHtmp += _cEnter + "	<td>" + _aRegi[_nI,5] + "</td>"
		_cHtmp += _cEnter + "	<td>" + _aRegi[_nI,6] + "</td>"
		_cHtmp += _cEnter + "	<td>" + _aRegi[_nI,7] + "</td>"
		_cHtmp += _cEnter + "	<td>" + _aRegi[_nI,8] + "</td>"
		_cHtmp += _cEnter + "	<td>" + Transform(_aRegi[_nI,9],"@E 999,999,999.99") + "</td>"
		_cHtmp += _cEnter + "	<td>" + _aRegi[_nI,10] + "</td>"
		_cHtmp += _cEnter + "</tr>"
		
	Next _nI
	
	_cHtmp += _cEnter + "</table>"
	
	_cHtmp += _cEnter + "</html>"
	
	_cSubjep := "Processamento - Midia Locacao de Espacos"
	_cTo := GetMv("LS_EMMIDFI")
	
	U_EnvMail(_cTo, _cSubjep, _cHtmp)
	
EndIf

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GeraPed(_cFilial,_cNumCont)
///////////////////////////////////////////

Local aArea		:= GetArea()
Local _aCabPv	:= {}
Local _aItemPv	:= {}
//Local nItePV	:= "01"
Local nItePV	:= "0001"

_cNumPV	:= Space(6)

DbSelectArea("PAC")
DbSetOrder(1)
DbSeek( _cFilial + _cNumCont )

DbSelectArea("SC5")
DbSetOrder(1)
_cNumPV := GetSxeNum("SC5","C5_NUM")
Do While DbSeek(xFilial("SC5") + _cNumPV)
	RollBackSX8()
	_cNumPV := GetSxeNum("SC5","C5_NUM")
EndDo
ConfirmSX8()

cEstado := Posicione('SA1',1, xFilial("SA1") + PAC->PAC_CLIENTE + PAC->PAC_LOJACL,'A1_EST')

//Grava o SC5
Reclock("SC5",.T.)

SC5->C5_FILIAL 	:= xFilial("SC5")
SC5->C5_NUM		:= _cNumPV
SC5->C5_TIPO	:= 'N'
SC5->C5_CLIENTE	:= SA1->A1_COD
SC5->C5_LOJACLI	:= SA1->A1_LOJA
SC5->C5_CLIENT	:= SA1->A1_COD
SC5->C5_LOJAENT	:= SA1->A1_LOJA
SC5->C5_TIPOCLI	:= "R"
SC5->C5_TRANSP	:= "000001"
SC5->C5_TPFRETE	:= 'F'
SC5->C5_MOEDA	:= 1
SC5->C5_CONDPAG	:= SA1->A1_COND
SC5->C5_EMISSAO	:= date()
SC5->C5_HRCALC	:= Time()
SC5->C5_DTCALC  := date()
SC5->C5_MOEDA	:= 1
SC5->C5_TIPLIB	:= '1'
SC5->C5_TXMOEDA	:= 1
SC5->C5_TPCARGA	:= '2'
SC5->C5_VEND1	:= "000001"
SC5->C5_LIBEROK := "S"
MsUnlock()

DbSelectArea("SB1")
SB1->( DbSetOrder(1) )
DbSeek( xFilial("SB1") + Alltrim( GetMv("LS_CODMID") ) )

_cTes	:= Alltrim( GetMv("LS_TESMID") )
cCf		:= Posicione("SF4",1,xFilial("SF4") + _cTes,"F4_CF")

If SM0->M0_ESTENT <> cEstado
	cCf := "6" + Substr(cCf,2,3)
EndIf

Reclock("SC6",.T.)
SC6->C6_NUM			:=	_cNumPV
SC6->C6_FILIAL		:=	xFilial("SC6")
SC6->C6_ITEM		:=	nItePV
SC6->C6_PRODUTO		:=	SB1->B1_COD
SC6->C6_DESCRI		:=	SB1->B1_DESC
SC6->C6_UM			:=	SB1->B1_UM
SC6->C6_QTDVEN		:=	1
SC6->C6_PRUNIT		:=	PAC->PAC_VALOR
SC6->C6_PRCVEN		:=	PAC->PAC_VALOR
SC6->C6_VALOR		:=	PAC->PAC_VALOR
SC6->C6_TES			:=	_cTes
SC6->C6_CF			:=	cCf
SC6->C6_LOCAL		:=	SB1->B1_LOCPAD
SC6->C6_CLASFIS		:=	SB1->B1_ORIGEM
SC6->C6_CLI			:=	SA1->A1_COD
SC6->C6_ENTREG		:=	dDataBase
SC6->C6_LOJA		:=	SA1->A1_LOJA
SC6->C6_OP			:=	'02'
SC6->C6_TPOP		:=	'F'
SC6->C6_SUGENTR		:=	dDataBase
SC6->C6_FILIAL		:= xFilial("SC6")
MsUnlock()

Reclock("SC9",.T.)
SC9->C9_FILIAL 	:= xFilial("SC9")
SC9->C9_PEDIDO	:= SC6->C6_NUM
SC9->C9_ITEM	:= SC6->C6_ITEM
SC9->C9_CLIENTE	:= SC6->C6_CLI
SC9->C9_LOJA	:= SC6->C6_LOJA
SC9->C9_PRODUTO	:= SC6->C6_PRODUTO
SC9->C9_QTDLIB	:= SC6->C6_QTDVEN
SC9->C9_DATALIB	:= dDatabase
SC9->C9_SEQUEN	:= "01"
SC9->C9_PRCVEN	:= SC6->C6_PRCVEN
SC9->C9_LOCAL	:= "01"
SC9->C9_TPCARGA	:= "2"
SC9->C9_BLEST  	:= ""
SC9->C9_BLCRED 	:= ""
SC9->( Msunlock() )

RestArea(aArea)

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GravaNFS(cPedido)
/////////////////////////////////

Local aAreaAnt	 	:= GetArea()
Local aAreaSC5	 	:= SC5->( GetArea() )
Local aAreaSC6	 	:= SC6->( GetArea() )
Local aAreaSC9	 	:= SC9->( GetArea() )
Local aAreaSE4	 	:= SE4->( GetArea() )
Local aAreaSB1	 	:= SB1->( GetArea() )
Local aAreaSB2	 	:= SB2->( GetArea() )
Local aAreaSF4	 	:= SF4->( GetArea() )

Local aPvlNfs	 	:= {}
Local _nPrcVen    	:= 0
Local _nRegDAK   	:= 0
Local lMostraCtb 	:= .F.
Local lAglutCtb  	:= .F.
Local lCtbOnLine 	:= .F.
Local lCtbCusto  	:= .F.
Local lReajuste  	:= .F.
Local lAtuSA7    	:= .F.
Local lECF       	:= .F.
Local nCalAcrs   	:= 1
Local nArredPrcLis 	:= 1
Local cRot       	:= ProcName()

// PREPARANDO A NOTA FISCAL
MV_PAR01 := 2           // Mostra Lan‡.Contab ?  Sim/Nao
MV_PAR02 := 2           // Aglut. Lan‡amentos ?  Sim/Nao
MV_PAR03 := 2           // Lan‡.Contab.On-Line?  Sim/Nao
MV_PAR04 := 2           // Contb.Custo On-Line?  Sim/Nao
MV_PAR05 := 2           // Reaj. na mesma N.F.?  Sim/Nao
MV_PAR06 := 0           // Taxa deflacao ICMS ?  Numerico
MV_PAR07 := 3           // Metodo calc.acr.fin?  Taxa defl/Dif.lista/% Acrs.ped
MV_PAR08 := 3           // Arred.prc unit vist?  Sempre/Nunca/Consumid.final
MV_PAR09 := Space( 04 ) // Agreg. liberac. de ?  Caracter
MV_PAR10 := Space( 04 ) // Agreg. liberac. ate?  Caracter
MV_PAR11 := 1           // Aglut.Ped. Iguais  ?  Sim/Nao
MV_PAR12 := 0           // Valor Minimo p/fatu?
MV_PAR13 := Space( 06 ) // Transportadora de  ?
MV_PAR14 := 'ZZZZZZ'    // Transportadora ate ?
MV_PAR15 := 2           // Atualiza Cli.X Prod?  Sim/Nao
MV_PAR16 := 1           // Emitir             ?  Nota/Cupom Fiscal

lMostraCtb  := MV_PAR01 == 1
lAglutCtb   := MV_PAR02 == 1
lCtbOnLine  := MV_PAR03 == 1
lCtbCusto   := MV_PAR04 == 1
lReajuste   := MV_PAR05 == 1

LAtuSA7lECF := .F.

// Gera nota.
SC5->( dbSetOrder( 1 ) ) //C5_FILIAL + C5_NUM
If SC5->( MsSeek( xFilial( 'SC5' ) + cPedido, .F. ) )
	
	SC6->( DbSetOrder(1) ) //C6_FILIAL + C6_NUM + C6_ITEM + C6_PRODUTO
	
	SC9->( DbSetOrder(1) ) //C9_FILIAL + C9_PEDIDO + C9_ITEM + C9_SEQUEN + C9_PRODUTO
	
	If SC9->( DbSeek( xFilial("SC9") + cPedido ) )
		
		Do While !SC9->(EOF()) .AND. SC9->C9_PEDIDO == cPedido
			
			If SC6->( DbSeek( xFilial("SC6") + SC9->C9_PEDIDO + SC9->C9_ITEM + SC9->C9_PRODUTO ) )
				
				SE4->( dbSetOrder( 1 ) )
				SE4->( MsSeek( xFilial( 'SE4' ) + SC5->C5_CONDPAG, .F. ) )
				
				// Posiciona no produto
				SB1->( dbSetOrder( 1 ) )
				SB1->( MsSeek( xFilial( 'SB1' ) + SC6->C6_PRODUTO, .F. ) )
				
				// Posiciona no saldo em estoque
				SB2->( dbSetOrder( 1 ) )
				SB2->( MsSeek( xFilial( 'SB2' ) + SC6->C6_PRODUTO + SC6->C6_LOCAL, .F. ) )
				
				// Posiciona no TES
				cTes := SC6->C6_TES
				SF4->( dbSetOrder( 1 ) )
				SF4->( MsSeek( xFilial( 'SF4' ) + cTes, .F. ) )
				
				// Converte o valor unitario em Reais quando pedido em outra moeda
				_nPrcVen := SC9->C9_PRCVEN
				If ( SC5->C5_MOEDA <> 1 )
					dbSelectArea( 'SM2' )
					dbSetOrder( 1 )
					If dbSeek( DTOS( dDataBase ) )
						_nPrcVen := SC9->C9_PRCVEN * SM2->M2_MOEDA2
					Else
						_nPrcVen := xMoeda( _nPrcVen, SC5->C5_MOEDA, 1, dDataBase )
					EndIf
					
				EndIf
				
				// Monta array para gerar a nota fiscal
				
				Aadd( aPvlNfs, { SC9->C9_PEDIDO, ;
				SC9->C9_ITEM, ;
				SC9->C9_SEQUEN, ;
				SC9->C9_QTDLIB, ;
				_nPrcVen, ;
				SC9->C9_PRODUTO, ;
				.F., ;
				SC9->( RecNo() ), ;
				SC5->( RecNo() ), ;
				SC6->( RecNo() ), ;
				SE4->( RecNo() ), ;
				SB1->( RecNo() ), ;
				SB2->( RecNo() ), ;
				SF4->( RecNo() ), ;
				SC6->C6_LOCAL, ;
				_nRegDAK, ;
				SC9->C9_QTDLIB2} )
				
			EndIf
			
			SC9->( DbSkip() )
			
		EndDo
		
	Else
		
		If !_lJob
			MsgBox('Pedido de vendas não liberado','ATENÇÃO!!!','ALERT')
		EndIf
		
	EndIf
	
Else
	
	If !_lJob
		MsgBox('Pedido de vendas não encontrado','ATENÇÃO!!!','ALERT')
	EndIf
	
EndIf

If !Empty( aPvlNfs )
	
	LimpaMoeda()
	
	//////////////////////////////////////////////////////////////////////
	_cNota := MaPvlNfs(aPvlNfs,;
	cSerie,;
	lMostraCtb,;
	lAglutCtb,;
	lCtbOnLine,;
	lCtbCusto,;
	lReajuste,;
	nCalAcrs,;
	nArredPrcLis,;
	lAtuSA7,;
	lECF,;
	'',;
	,;
	NIL )
	
	Aadd( _aRegis, {_cNumPv,_cNota} )
	
EndIf

Return()