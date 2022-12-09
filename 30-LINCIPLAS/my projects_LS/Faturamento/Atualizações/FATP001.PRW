#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATP001   º Autor ³ Antonio Carlos     º Data ³  07/03/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina responsavel pelo processamento dos itens para Acertoº±±
±±º          ³ de Consignacao.                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATP001()

Local aArea			:= GetArea()
Local aAreaSM0		:= SM0->( GetArea() )

Local oOk       	:= LoadBitmap( GetResources(), "LBOK")
Local oNo       	:= LoadBitmap( GetResources(), "LBNO")

Local _lFecha		:= .T.

Private oProcess
Private oFornece
Private oLoja
Private oNomFor
Private _oDataDe, _oDataAte

Private nOpcA		:= 0

Private lInvFil 	:= .F.
Private lInvGrp 	:= .F.

Private aFilial		:= {}
Private aGrupoMat	:= {}

Private _cFornece	:= Space(6)
Private _cLoja		:= Space(2)
Private _cNomFor	:= Space(150)
Private _dDataDe	:= _dDataAte := CTOD("")
Private cStrFilia	:= ""
Private cStrFil		:= ""
Private cStrGrupo	:= ""
Private cStrGrp		:= ""
Private cFiltrUsr	:= ""
Private cCadastro	:= "Acerto de Consignação - Não Periódicos"

Conout("*** La Selva - User Function FATP001 - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

DEFINE MSDIALOG oDlg TITLE cCadastro FROM 0,0 To 410,680 OF oMainWnd PIXEL

@ 10,10 SAY "Fornecedor: " 																	OF oDlg PIXEL
@ 20,10 MSGET oFornece 		VAR _cFornece 			SIZE 040,10 F3 "SA2" VALID( PsqCli() ) 	OF oDlg PIXEL ON CHANGE VDtFec()
@ 10,60 SAY "Loja: " 																   		OF oDlg PIXEL
//@ 20,60 MSGET oLoja 		VAR _cLoja PICTURE "@!" SIZE 020,10 		 VALID( VDtFec() )  OF oDlg PIXEL
@ 20,60 MSGET oLoja 		VAR _cLoja PICTURE "@!" SIZE 020,10 		 VALID( PsqCli() )	OF oDlg PIXEL ON CHANGE VDtFec()
@ 20,90 MSGET oNomFor 		VAR _cNomFor 			SIZE 180,10 WHEN .F. 					OF oDlg PIXEL

@ 10,280 SAY "Emissão: " 																	OF oDlg PIXEL
@ 20,280 MSGET _oDataDe  	VAR _dDataDe  			SIZE 040,10 							OF oDlg PIXEL
@ 35,280 MSGET _oDataAte	VAR _dDataAte 			SIZE 040,10 							OF oDlg PIXEL

//Group Box de Filiais
@ 60,10  TO 180,197 LABEL "Filiais" 														OF oDlg PIXEL

//Grid de Filiais
/*
DbSelectArea("SM0")
DbGoTop()
While SM0->(!Eof())
Aadd(aFilial,{.T.,M0_CODFIL,SM0->M0_FILIAL})
DbSkip()
EndDo
*/
cQry := " SELECT M0_CODFIL, M0_FILIAL "
cQry += " FROM SIGA.dbo.sigamat_copia "
cQry += " WHERE ativo_pdv = 1 "
cQry += " ORDER BY M0_CODFIL "

If Select("AFIL") > 0
	DbSelectArea("AFIL")
	DbCloseArea()
EndIf

dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQry), "AFIL", .F., .T.)

DbSelectArea("AFIL")
While AFIL->(!Eof())
	Aadd(aFilial,{.T.,AFIL->M0_CODFIL,AFIL->M0_FILIAL})
	DbSkip()
EndDo



RestArea(aAreaSM0)

@ 70,30  CHECKBOX oChkInvFil VAR lInvFil PROMPT "Inverter Seleção" SIZE 50, 10 OF oDlg PIXEL ON CLICK (AEval(aFilial , {|z| z[1] := If(z[1]==.T.,.F.,.T.)}), oLstFilial:Refresh(.F.)) //"Inverter Selecao"
@ 80,25  LISTBOX  oLstFilial VAR cVarFil Fields HEADER "","Filial","Descrição" SIZE 160,91 ON DBLCLICK (aFilial:=LSVTroca(oLstFilial:nAt,aFilial),oLstFilial:Refresh()) ON RIGHT CLICK ListBoxAll(nRow,nCol,@oLstFilial,oOk,oNo,@aFilial) OF oDlg PIXEL	//"Filial" / "Descricao"
oLstFilial:SetArray(aFilial)
oLstFilial:bLine := { || {If(aFilial[oLstFilial:nAt,1],oOk,oNo),aFilial[oLstFilial:nAt,2],aFilial[oLstFilial:nAt,3]}}

//Group Box de Grupos
@ 60,210 TO 180,320 LABEL "Grupos" OF oDlg PIXEL

//Grid de Grupos
DbSelectArea("SBM")
DbSeek(xFilial("SBM"))
While (BM_FILIAL == xFilial("SBM")) .and. !Eof()
	cCapital := Capital(BM_DESC)
	aAdd(aGrupoMat,{.T.,SubStr(BM_GRUPO,1,TamSX3("B1_GRUPO")[1])+" "+cCapital})
	DbSkip()
EndDo

@ 70,225 CHECKBOX oChkInvGrp	VAR lInvGrp PROMPT "Inverter Seleção" 				SIZE 50, 10 OF oDlg PIXEL ON CLICK (AEval(aGrupoMat, {|z| z[1] := If(z[1]==.T.,.F.,.T.)}),oLstGrp:Refresh(.F.)) //"Inverter Selecao"
@ 80,220 LISTBOX oLstGrp 		VAR cVarGrp Fields HEADER "","Grupos de Material"	SIZE 78,091 ON DBLCLICK (aGrupoMat:=LSVTroca(oLstGrp:nAt,aGrupoMat),oLstGrp:Refresh()) ON RIGHT CLICK ListBoxAll(nRow,nCol,@oLstGrp,oOk,oNo,@aGrupoMat) OF oDlg PIXEL	//"Grupos de Material"
oLstGrp:SetArray(aGrupoMat)
oLstGrp:bLine := { || {If(aGrupoMat[oLstGrp:nAt,1],oOk,oNo),aGrupoMat[oLstGrp:nAt,2]}}

DEFINE SBUTTON FROM 190,210 TYPE 1 ACTION(Processa({|lEnd| LSVGDados(@lEnd)},"Aguarde","Processando registros...",.T.),oDlg:End())  ENABLE OF oDlg
DEFINE SBUTTON FROM 190,250 TYPE 2 ACTION(oDlg:End()) ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED

RestArea(aArea)

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function PsqCli()
////////////////////////
Conout("*** La Selva - Static Function PSQCLI - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

_cLoja			:= IIF(EMPTY(ALLTRIM(_cLoja)),Posicione("SA2",1,xFilial("SA2")+_cFornece,"A2_LOJA"),_cLoja) // space(2))
_cNomFor		:= Posicione("SA2",1,xFilial("SA2")+_cFornece,"A2_NOME")

cQry := " SELECT TOP 1 SZA.ZA_DATAATE, *
cQry += " FROM " + RetSqlName("SZA") + " SZA (NOLOCK) "
cQry += " WHERE ZA_FORNECE		= '"+_cFornece+"'
cQry += " AND ZA_LOJAFOR		= '"+_cLoja+"'
cQry += " AND SZA.D_E_L_E_T_	= ''
cQry += " ORDER BY SZA.ZA_DATAATE DESC

If Select("DTFEC") > 0
	DbSelectArea("DTFEC")
	DbCloseArea()
EndIf

dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQry), "DTFEC", .F., .T.)

DbSelectArea("DTFEC")

IF SELECT("DTFEC")>0
	While DTFEC->(!Eof())
		_dDataDe 	:= STOD(DTFEC->ZA_DATAATE)+1
		dbSkip()
	ENDDO
ELSE
	_dDataDe	:= UltDt() //ctod("")
	_oDataAte:Enable()
	_oDataDe:Enable()
	_oDataDe:SetFocus()
ENDIF

/*
DbSelectArea("SZC")
SZC->( DbSetOrder(1) )
If SZC->( DbSeek(xFilial("SZC")+_cFornece+iif(empty(_cLoja),space(2),_cLoja) ) )
_dDataDe 	:= SZC->ZC_DTACERT
Else
_dDataDe	:= UltDt() //ctod("")
_oDataAte:Enable()
_oDataDe:Enable()
_oDataDe:SetFocus()
EndIf
*/


Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function VDtFec()
Conout("*** La Selva - Static Function VDTFEC - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

//Se a chave FORNECEDOR+LOJA não existir limpa a variavel LOJA para realizar nova pesquisa
dbSelectArea("SA2")
dbSetOrder(1)
IF dbSeek(xFilial("SA2")+_cFornece+IIF(EMPTY(ALLTRIM(_cLOJA)),"",_cLoja)    )
	_cLoja 		:= SA2->A2_LOJA //_cLoja
	//ELSEIF dbSeek(xFilial("SA2")+_cFornece)
	//	_cLoja 		:= _cLoja
ELSE
	_cLoja 		:= space(2)
	_dDataDe	:= ctod("")
ENDIF

cQry := " SELECT TOP 1 SZA.ZA_DATAATE, *
cQry += " FROM " + RetSqlName("SZA") + " SZA (NOLOCK) "
cQry += " WHERE ZA_FORNECE		= '"+_cFornece+"'
cQry += " AND ZA_LOJAFOR		= '"+_cLoja+"'
cQry += " AND SZA.D_E_L_E_T_	= ''
cQry += " ORDER BY SZA.ZA_DATAATE DESC

If Select("DTFEC") > 0
	DbSelectArea("DTFEC")
	DbCloseArea()
EndIf

dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQry), "DTFEC", .F., .T.)

DbSelectArea("DTFEC")

IF SELECT("DTFEC")>0
	While DTFEC->(!Eof())
		_dDataDe 	:= STOD(DTFEC->ZA_DATAATE)+1
		dbSkip()
	ENDDO
ELSE
	_dDataDe	:= UltDt() //ctod("")
	_oDataAte:Enable()
	_oDataDe:Enable()
	_oDataDe:SetFocus()
ENDIF

/*
DbSelectArea("SZC")
SZC->( DbSetOrder(1) )
If SZC->( DbSeek(xFilial("SZC")+_cFornece+_cLoja))
_dDataDe 	:= SZC->ZC_DTACERT
Else
_dDataDe	:= UltDt() //ctod("")
_oDataAte:Enable()
_oDataDe:Enable()
_oDataDe:SetFocus()
EndIf
*/
Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function UltDt()

cQry := " SELECT TOP 1 C5_EMISSAO, *  "
cQry += " FROM " + RetSqlName("SC5") + " SC5 (NOLOCK) "
//cQry += " WHERE C5_FILIAL 		= '" + xFilial("SC5") + "'"
cQry += " WHERE C5_CLIENTE 		= '" + _cFornece + "'"
cQry += " AND C5_LOJACLI 		= '" + _cLoja + "'"
cQry += " AND C5_TIPO	 		= 'B' "
cQry += " AND SC5.D_E_L_E_T_ 	= '' "
cQry += " ORDER BY R_E_C_N_O_ ASC "

If Select("ULTDT") > 0
	DbSelectArea("ULTDT")
	DbCloseArea()
EndIf

dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQry), "ULTDT", .F., .T.)

DbSelectArea("ULTDT")

If ULTDT->( !Eof() )
	_dTMPDataDe := StoD(ULTDT->C5_EMISSAO)
ELSE
	_dTMPDataDe := CtoD("")
EndIf

Return _dTMPDataDe

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LSVTroca(nIt,aArray)
Conout("*** La Selva - Static Function LSVTROCA - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

aArray[nIt,1] := !aArray[nIt,1]
Return aArray

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LSVGDados()
///////////////////////////

Local nItens		:= "00001"
Local _cNumFec 		:=  Space(6)
Local _dDtAcert
//Local _dDataAte

Local _nSldPag		:= 0
Local _nVlrUnit		:= 0
Local _nVlrTot		:= 0
Local _nReg			:= 0
Local _nSldSB6		:= 0
Local _nQuant		:= 0
Local _nEstoque		:= 0
Local _nVendas		:= 0
Local _nCompras		:= 0
Local _nQtdPg		:= 0
Local _nQtdPag		:= 0
Local _nSaldo		:= 0
Local nTotRec		:= 0

Local _lAbert		:= .F.
Local lGrava		:= .T.
Local _lColiga		:= .F.

Local _aItemSZB		:= {}
Local _aItemSZE		:= {}
Local _aItemTemp	:= {}
Local _cUser		:= RetCodUsr()
Local _cUsrName		:= UsrRetName(_cUser)
Local _aArea		:= GetArea()

Conout("*** La Selva - Static Function LSVGDADOS - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

AEval(aGrupoMat, {|x| If(x[1]==.T.,cStrGrupo+="'"+SubStr(x[2],1,TamSX3("B1_GRUPO")[1])+"'"+",",Nil)})
cStrGrp 			:= Substr(cStrgrupo,1,Len(cstrgrupo)-1)

AEval(aFilial, {|x| If(x[1]==.T.,cStrFilia+="'"+SubStr(x[2],1,TamSX3("B1_FILIAL")[1])+"'"+",",Nil)})
cStrFil 			:= Substr(cStrFilia,1,Len(cstrFilia)-1)

//_dDataAte := dDataBase - 2

If Empty(cStrFil)
	Aviso("Acerto de Consignação","Informe uma filial para o procesamento!",{"Ok"})
	Return(.F.)
EndIf

If Empty(_dDataDe)
	Aviso("Acerto de Consignação","Informe uma data para o início do procesamento!",{"Ok"})
	Return(.F.)
EndIf

cQry := " SELECT ZA_FORNECE, ZA_LOJAFOR, ZA_STATUS "
cQry += " FROM " + RetSqlName("SZA") + " SZA (NOLOCK) "
cQry += " WHERE ZA_FILIAL 		= '" + xFilial("SZA") + "'"
cQry += " AND ZA_FORNECE 		= '" + _cFornece + "'"
cQry += " AND ZA_LOJAFOR 		= '" + _cLoja + "'"
cQry += " AND ZA_STATUS 		= 'A'"
cQry += " AND SZA.D_E_L_E_T_ 	= '' "

dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQry), "TRB", .F., .T.)

DbSelectArea("TRB")
TRB->( DbGoTop() )
If TRB->( !Eof() )
	_lAbert := .T.
EndIf

If !_lAbert
	
	cQuery := " SELECT COALESCE(B6_EMISSAO, '19900101'), B6_FILIAL, B6_CLIFOR,B6_LOJA,B6_PRODUTO,B1_DESC, SUM(B6_SALDO) AS SLDSB6 "
	
	cQuery += _cEnter + " , COALESCE((SELECT SUM(B2_QATU) "
	cQuery += _cEnter + " 		FROM " + RetSqlName("SB2") + " SB2 (NOLOCK) "
	cQuery += _cEnter + " 		WHERE B6_PRODUTO 		= B2_COD "
	cQuery += _cEnter + " 		AND B2_FILIAL 		IN (" + cStrFil + ") "
	//cQuery += _cEnter + " 	AND B2_LOCAL 			<> '90' "
	cQuery += _cEnter + " 		AND SB2.D_E_L_E_T_ 	= '' ),0) AS ESTOQUE "
	
	cQuery += _cEnter + " , COALESCE((SELECT SUM(D2_QUANT) "
	cQuery += _cEnter + " 		FROM " + RetSqlName("SF2") + " SF2 (NOLOCK) "
	
	cQuery += _cEnter + " 		INNER JOIN " + RetSqlName("SD2") + " SD2 (NOLOCK) ON D2_FILIAL 			= F2_FILIAL"
	cQuery += _cEnter + " 													AND D2_DOC 			= F2_DOC"
	cQuery += _cEnter + " 													AND D2_SERIE 			= F2_SERIE"
	cQuery += _cEnter + " 													AND D2_COD 			= B6_PRODUTO "
	
	cQuery += _cEnter + " 		WHERE SD2.D_E_L_E_T_ 	= ''"
	cQuery += _cEnter + " 		AND (F2_EMINFE BETWEEN '" + DTOS(_dDataDe) + "' AND '" + DTOS(_dDataAte) + "' OR (F2_EMINFE = '' AND F2_EMISSAO BETWEEN '" + DTOS(_dDataDe) + "' AND '" + DTOS(_dDataAte) + "')) "
	cQuery += _cEnter + " 		AND F2_FILIAL 		IN (" + cStrFil + ") "
	cQuery += _cEnter + " 		AND F2_TIPO 			= 'N' "
	cQuery += _cEnter + " 		AND F2_ESPECIE 		= 'CF' "
	cQuery += _cEnter + " 		AND SF2.D_E_L_E_T_ 	= '' ),0) AS VENDAS "
	
	cQuery += _cEnter + " , COALESCE((SELECT SUM(Z9_QUANT) "
	cQuery += _cEnter + " 		FROM " + RetSqlName("SZ9") + " SZ9 (NOLOCK) "
	//Alterado por: Antonio Carlos - 16/08/11 - Considerar apenas a filial 01
	cQuery += _cEnter + " 		WHERE Z9_FILIAL 		= '" + xFilial("SB6") + "'"
	cQuery += _cEnter + " 		AND Z9_FILIAL 		= B6_FILIAL "
	cQuery += _cEnter + " 		AND Z9_PRODUTO 		= B6_PRODUTO "
	cQuery += _cEnter + " 		AND Z9_QUANT 			> 0 "
	cQuery += _cEnter + " 		AND SZ9.D_E_L_E_T_ 	= '' ),0) AS COMPRAS "
	
	cQuery += _cEnter + " FROM " + RetSqlName("SB6")+" SB6 (NOLOCK) "
	
	cQuery += _cEnter + " INNER JOIN " + RetSqlName("SA2") + " SA2 (NOLOCK)  ON B6_CLIFOR 			= A2_COD"
	cQuery += _cEnter + " 														AND B6_LOJA 			= A2_LOJA "
	cQuery += _cEnter + " 														AND SA2.D_E_L_E_T_ 	= '' "
	
	cQuery += _cEnter + " INNER JOIN " + RetSqlName("SB1") + " SB1 (NOLOCK)  ON B6_PRODUTO 		= B1_COD "
	cQuery += _cEnter + " 														AND SB1.D_E_L_E_T_ 	= '' "
	
	cQuery += _cEnter + " WHERE B6_FILIAL 		= '" + xFilial("SB6") + "'"
	cQuery += _cEnter + " AND B6_PODER3 		= 'R' "
	cQuery += _cEnter + " AND B6_ATEND 			<> 'S' "
	cQuery += _cEnter + " AND B6_TPCF 			= 'F' "
	cQuery += _cEnter + " AND B6_SALDO 			> 0 "
	cQuery += _cEnter + " AND SB6.D_E_L_E_T_ 	= '' "
	
	If !Empty(cStrGrp)
		cQuery	+= _cEnter + " AND B1_GRUPO 	IN (" + cStrGrp + ")"
	EndIf
	
	If !Empty(_cFornece)
		cQuery += _cEnter + " AND B6_CLIFOR 	= '" + _cFornece + "'"
		cQuery += _cEnter + " AND B6_LOJA 		= '" + _cLoja + "' "
	EndIf
	
	cQuery += _cEnter + " GROUP BY B6_EMISSAO, B6_FILIAL, B6_CLIFOR, B6_LOJA, B6_PRODUTO, B1_DESC "
	//cQuery += _cEnter + " ORDER BY B1_DESC "
	cQuery += _cEnter + " ORDER BY B1_DESC ASC, B6_EMISSAO DESC "
	
	DbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), "TMP", .F., .T.)
	
	Count To nTotRec
	ProcRegua(nTotRec)
	
	Begin Transaction
	
	DbSelectArea("TMP")
	TMP->( DbGoTop() )
	
	If TMP->( !Eof() )
		Do While TMP->( !Eof() )
			
			_lColiga	:= .F.
			_nReg 		:= 0
			nItem		:= "00001"
			_aItemSZB	:= {}
			_aItemSZE	:= {}
			
			cFornece	:= TMP->B6_CLIFOR
			cLoja		:= TMP->B6_LOJA
			_cNumFec	:= Space(6)
			
			Do While TMP->( !Eof() ) .and. TMP->B6_CLIFOR + TMP->B6_LOJA == cFornece + cLoja
				
				IncProc(nTotRec)
				
				If Empty(_cNumFec)
					
					_cNumFec := GetSxeNum("SZA","ZA_NUMFEC")
					While .T.
						DbSelectArea("SZA")
						DbSetOrder(1)
						If DbSeek(xFilial("SZA") + _cNumFec)
							RollBackSX8()
							_cNumFec := GetSxeNum("SZA","C5_NUM")
						Else
							ConfirmSX8()
							Exit
						EndIf
					EndDo
					
				EndIf
				
				DbSelectArea("SA2")
				DbSetOrder(1)
				DbSeek(xFilial("SA2") + TMP->B6_CLIFOR + TMP->B6_LOJA)
				
				If SA2->A2_CGC $ GetMv("MV_LSVCNPJ")
					_lColiga := .T.
				EndIf
				
				cProduto := TMP->B6_PRODUTO
				
				Do While TMP->( !Eof() ) .and. TMP->B6_PRODUTO == cProduto
					
					_nEstoque	:=	Round(TMP->ESTOQUE,2)
					_nVendas	:=	Round(TMP->VENDAS,2)
					_nCompras	:=	Round(TMP->COMPRAS,2)
					
					_nSldSB6 := TMP->SLDSB6
					_nQtdPg  := _nVendas - _nCompras
					
					IncProc("Fornecedor/Loja: " + TMP->B6_CLIFOR + " - " + TMP->B6_LOJA )
					
					TMP->( DbSkip() )
					
				EndDo
				
				If _nQtdPg > 0
					_nQtdPag := Min(_nSldSB6,_nQtdPg)
				Else
					_nQtdPag := _nQtdPg
				EndIf
				
				If _nCompras > 0
					
					If _nVendas >= _nCompras
						_nSaldo := _nCompras
					Else
						_nSaldo := _nVendas
					EndIf
					
					DbSelectArea("SZ9")
					SZ9->( DbSetOrder(3) )
					If SZ9->( DbSeek(xFilial("SZ9")+cProduto) )
						If SZ9->Z9_QUANT > 0
							RecLock("SZ9",.F.)
							SZ9->Z9_QUANT	:= iif(SZ9->Z9_QUANT >= _nSaldo, SZ9->Z9_QUANT - _nSaldo, 0)
							MsUnLock()
						EndIf
					EndIf
					
				EndIf
				
				//Alterado para permitir controle dos saldos de compras
				
				If _nVendas > 0
					_nReg++
					Aadd(_aItemSZB, {_cNumFec,cProduto,_nSldSB6, _nEstoque, _nVendas, _nCompras, IIf(_nQtdPag>0,_nQtdPag,0), SA2->A2_COD, SA2->A2_LOJA,_nSaldo})
				EndIf
				
				_nSaldo := 0
				
				If _lColiga
					Aadd(_aItemSZE, {cProduto,_nQtdPag, _cNumFec, SA1->A1_COD, SA1->A1_LOJA})
				EndIf
				
				_nSldSB6	:= 0
				_nEstoque	:= 0
				_nVendas	:= 0
				_nCompras	:= 0
				_nQtdPag	:= 0
				
			EndDo
			
			If _nReg > 0
				
				//Grava a SZA
				DbSelectArea("SZA")
				Reclock("SZA",.T.)
				SZA->ZA_FILIAL	:= xFilial("SZA")
				SZA->ZA_NUMFEC	:= _cNumFec
				SZA->ZA_FORNECE	:= SA2->A2_COD
				SZA->ZA_LOJAFOR	:= SA2->A2_LOJA
				SZA->ZA_EMISSAO	:= dDataBase
				SZA->ZA_USUARIO	:= _cUsrName
				SZA->ZA_STATUS  := "A"
				SZA->ZA_DATADE  := _dDataDe
				SZA->ZA_DATAATE := _dDataAte
				SZA->( MsUnlock() )
				
				//Grava a SZB
				nItem := "00001"
				DbSelectArea("SZB")
				For _nI := 1 To Len(_aItemSZB)
					RecLock("SZB",.T.)
					SZB->ZB_FILIAL	:= xFilial("SZB")
					SZB->ZB_ITEM   	:= nItem
					SZB->ZB_NUMFEC	:= _aItemSZB[_nI,1]
					SZB->ZB_PRODUTO	:= _aItemSZB[_nI,2]
					SZB->ZB_SALDOPT := _aItemSZB[_nI,3]
					SZB->ZB_ESTOQUE := _aItemSZB[_nI,4]
					SZB->ZB_VENDAS  := _aItemSZB[_nI,5]
					SZB->ZB_COMPRAS := _aItemSZB[_nI,6]
					SZB->ZB_QTDPAG  := _aItemSZB[_nI,7]
					SZB->ZB_FORNECE := _aItemSZB[_nI,8]
					SZB->ZB_LOJA  	:= _aItemSZB[_nI,9]
					SZB->ZB_SALDO  	:= _aItemSZB[_nI,10]
					MsUnLock()
					nItem := Soma1(nItem)
				Next _nI
				_nQuant++
				
				If _lColiga
					//Grava a SZD
					DbSelectArea("SA1")
					SA1->( DbSetOrder(9) )
					If SA1->( DbSeek(SM0->M0_CGC+SM0->M0_CODFIL) )
						DbSelectArea("SZD")
						Reclock("SZD",.T.)
						SZD->ZD_FILIAL	:= "01"
						SZD->ZD_NUMAC	:= _cNumFec
						SZD->ZD_CODIGO	:= SA1->A1_COD
						SZD->ZD_LOJA	:= SA1->A1_LOJA
						SZD->ZD_CGC		:= SA1->A1_CGC
						SZD->ZD_EMISSAO	:= dDataBase
						SZD->ZD_FILORI	:= SM0->M0_CODFIL
						SZD->ZD_STATUS	:= "A"
					EndIf
					MsUnlock()
					
					//Grava a SZE
					nItem := "00001"
					DbSelectArea("SZE")
					For _nI := 1 To Len(_aItemSZE)
						RecLock("SZE",.T.)
						SZE->ZE_FILIAL	:= "01"
						SZE->ZE_ITEM	:= nItem
						SZE->ZE_PRODUTO	:= _aItemSZE[_nI,1]
						SZE->ZE_QUANT	:= _aItemSZE[_nI,2]
						SZE->ZE_NUMAC	:= _aItemSZE[_nI,3]
						SZE->ZE_CODIGO	:= _aItemSZE[_nI,4]
						SZE->ZE_LOJA 	:= _aItemSZE[_nI,5]
						SZD->( MsUnLock() )
						nItem := Soma1(nItem)
					Next _nI
				EndIf
				
			EndIf
			
		EndDo
		
		If _nQuant > 0
			
			DbSelectArea("SZC")
			SZC->( DbSetOrder(1) )
			If SZC->( DbSeek(xFilial("SZC")+_cFornece+_cLoja) )
				RecLock("SZC",.F.)
				SZC->ZC_DTACERT	:= SZC->ZC_DTACERT
				SZC->ZC_DTACERT	:= _dDataAte + 1
				SZC->( MsUnLock() )
			Else
				RecLock("SZC",.T.)
				SZC->ZC_FILIAL	:= xFilial("SZC")
				SZC->ZC_FORNECE	:= _cFornece
				SZC->ZC_LOJAFOR	:= _cLoja
				SZC->ZC_DTACERT	:= _dDataAte + 1
				SZC->( MsUnLock() )
			EndIf
			
			Aviso("Acerto de Consignação","Acerto: " + _cNumFec + " - Processamento realizado com sucesso!",{"Ok"})
			LimpTela()
		Else
			Aviso("Acerto de Consignação","Não há registros para processamento!",{"Ok"})
			LimpTela()
		EndIf
		
	Else
		Aviso("Acerto de Consignação","Náo há registros para processamento!",{"Ok"})
		LimpTela()
		
	EndIf
	
	End Transaction
	
	DbSelectArea("TMP")
	DbCloseArea()
	
Else
	Aviso("Acerto de Consignação","Existem acertos de consignação em aberto para esse Fornecedor!",{"Ok"})
	LimpTela()
EndIf

DbSelectArea("TRB")
DbCloseArea()

RestArea(_aArea)

Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LimpTela()
//////////////////////////

Conout("*** La Selva - Static Function LIMPTELA - User: "+Substr(cUsuario,7,15)+"-"+DtoC(dDatabase))

_cFornece	:= Space(6)
_cLoja		:= Space(2)
_cNomFor	:= Space(150)
_dDataDe	:= _dDataAte := CTOD("")

oFornece:Refresh()
oLoja:Refresh()
oNomFor:Refresh()
_oDataDe:Refresh()
_oDataAte:Refresh()

oDlg:Refresh()

Return
