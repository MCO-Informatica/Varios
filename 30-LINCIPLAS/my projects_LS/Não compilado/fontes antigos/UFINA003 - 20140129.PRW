#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FINA003  º Autor ³ Ricardo Felipelli  º Data ³  16/12/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ inclusao de movimentos bancarios - Venda dia               º±±
±±º          ³ CAMARA CONCILIADORA                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ mp8 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function UFINA003()
///////////////////////

Local aSays        	:= {}
Local aButtons     	:= {}
Local nOpc        	:= 0
Local oDlg
Private oProcess
cCadastro    	    := "Importa Movimentacao Bancaria - Venda Diaria"

If !(cFilAnt $ GetMv('LS_MATRIZ'))
	MsgBox('Esta rotina deve ser executada em uma filial centralizadora','ATENÇÃO!!!!','ALERT')
Else
	aAdd(aSays,"Esta rotina realiza a importacao dos registros de movimentacao")
	aAdd(aSays,"bancaria do Socim para a tabela SE5 do Protheus.")
	aAdd(aSays,"Somente os registros selecionados.")
	
	aAdd(aButtons, { 1,.T.,{|o| nOpc:= 1,iif(MsgYesNo(OemToAnsi("Confirma processamento?"),OemToAnsi("Atenção")),o:oWnd:End(),nOpc:=0) } } )
	aAdd(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
	FormBatch( cCadastro, aSays, aButtons,,200,405 )
	
	If nOpc == 1
		oProcess := MsNewProcess():New({|lEnd| Integra(@lEnd)},"Processando","Transferindo...",.T.)
		oProcess:Activate()
	EndIf
EndIf

Return()

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Integra()
/////////////////////////

Local aArea := GetArea()
cMarca		:= GetMark()
aCampos		:= {}
aCpos		:= {}
lINVERTE	:= .F.

bPesqui		:= {|| Pesqui()}
bLibera		:= {|| Libera()}

aRotina 	:= {{ "Pesquisar"	, "Eval(bPesqui)"	, 0 , 1} , { "Liberacao"	, "Eval(bLibera)"	, 0 , 3}}

If !__cUserId $ GetMv("MV_USRVEND") + GetMv('LA_PODER')
	
	MsgStop("Usuário sem permissão para utilizar a rotina!" + _cEnter + " Configure o parâmetro: MV_USRVEND")
	
Else
	
	cPergData:= Padr("FINA03DT" + cFilAnt,len(SX1->X1_GRUPO)," ")
	ValidPerg1()
	If !Pergunte(cPergData, .T.)
		MsgBox('Rotina abortada pelo usuário','Câmara Conciliadora','INFO')
		Return()
	EndIf
	
	_ddadata	:= mv_par01
	_datedata	:= mv_par02
	
	If Select("XTP") > 0
		XTP->(DbCloseArea())
	EndIf
	
	If Select("TMP") > 0
		TMP->(DbCloseArea())
	EndIf
	
	If Select("QRY") > 0
		QRY->(DbCloseArea())
	EndIf
	
	
	//XTP
	//Tabela temporaria com o distinct dos tipos de pagamentos na pat
	axpto := {}
	aAdd(axpto, {"OK"         , "C" ,  2, 0})
	aAdd(axpto, {"PAT_FORMA"  , "C" ,  3, 0})
	aAdd(axpto, {"PAT_DESFOR" , "C" , 25, 0})
	cTrab := CriaTrab(axpto,.t.)
	//DBCreate(cTrab, axpto)
	DBUseArea( .T.,, cTrab, "XTP", .F., .F. )
	
	// verifica quantas formas de pagto existem na tabela PAT para importar pro SE5
	cQuery1 := " SELECT DISTINCT PAT_FORMA, PAT_DESFOR FROM "+RetSqlName("PAT")+" PAT (NOLOCK)"
	cQuery1 += " WHERE D_E_L_E_T_ 	= '' "
	cQuery1 += " AND PAT_DTFECH 	BETWEEN '" +DTOS(_ddadata)+"' AND '"+DTOS(_datedata)+"'"
	cQuery1 += " AND PAT_STATUS 	<> 'S' "
	cQuery1 += " AND PAT_FORMA 		IN ('R$','CH','U$','E$','FI','$')"
	//cQuery1 += " AND PAT_FILIAL IN " + FormatIn(alltrim(GetMV('MV_EMPFIL')),'/')
	cQuery1 += " GROUP BY PAT_FORMA, PAT_DESFOR "
	cQuery1 += " ORDER BY PAT_FORMA, PAT_DESFOR "
	
	/*
	CO	CONVENIO
	CD	CARTAO DE DEB AUTOMA
	CR	CREDITO
	CC	CARTAO DE CREDITO
	FI	FINANCIADO
	CH	CHEQUE
	VA	VALES
	R$	DINHEIRO
	DC	DEBITO EM CC
	U$	Dólar
	E$	Euro
	*/
	
	memowrite("FINA003a.SQL",cQuery1)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery1), "QRY", .F., .T.)
	
	DbSelectArea("XTP")
	
	DbSelectArea("QRY")
	DbGoTop()
	
	//CONFORME ORIENTACAO DO MARCELO
	//FORMA DE PAG.	DESCRIÇÃO	ACRESCENTAR	DESCRIÇÃO ATUALALIZADA
	//CH			CHEQUE		Á VISTA	CHEQUE (Á VISTA)
	//CO			CONVENIO	CIAS	CONVENIO (CIAS)
	//FI			FINANCIADO	CHEQUE-PRÉ-DATADO	FINANCIADO (CHEQUE-PRÉ-DATADO)
	//VA			VALES		PROMOÇÕES/ VOUCHER	VALES (PROMOÇÕES/ VOUCHERS)
	
	Do While QRY->(!eof())
		RecLock("XTP",.T.)
		XTP->PAT_FORMA  := QRY->PAT_FORMA
		If alltrim(XTP->PAT_FORMA) == 'FI' 		//	FINANCIADO
			XTP->PAT_DESFOR := 'FINANCIADO/CHEQUE PREDATADO'
		ElseIf alltrim(XTP->PAT_FORMA) == 'CO' 	//	CONVENIO
			XTP->PAT_DESFOR := 'CONVENIO/CIAS'
		ElseIf alltrim(XTP->PAT_FORMA) == 'CH' 	//	CHEQUE
			XTP->PAT_DESFOR := 'CHEQUE A VISTA'
		ElseIf alltrim(XTP->PAT_FORMA) == 'VA' 	//	VALE
			XTP->PAT_DESFOR := 'VALES (PROMOCOES/ VOUCHERS)'
		Else
			XTP->PAT_DESFOR := QRY->PAT_DESFOR
		EndIf
		MsUnLock()
		QRY->(DbSkip())
	EndDo
	
	DbSelectArea("QRY")
	QRY->(DbCloseArea())
	
	aCposX		:= {}
	aAdd(aCposX, {"OK"	   			,,  					})
	aAdd(aCposX, {"PAT_FORMA"	 	,, "Forma de Pagto."	})
	aAdd(aCposX, {"PAT_DESFOR"	    ,, "Descricao"			})
	
	bproces		:= {|| Process()}
	aRotina 	:= { { "Processa"	, "Eval(bproces)"	, 0 , 3} }
	
	DbSelectArea("XTP")
	DbGoTop()
	MarkBrow("XTP","OK","",aCposX,lINVERTE,cMarca,,,,,,,)
	//MarkBrow ( [ cAlias ] [ cCampo ] [ cCpo ] [ aCampo ] [ lInvert ] [ cMarca ] [ cCtrlM ] [ uPar8 ] [ cExpIni ] [ cExpFim ] [ cAval ] [ bParBloco ] [ cExprFilTop ] [ uPar14 ] [ aColors ] [ uPar16 ] [ uPar17 ] )
	RestArea(aArea)
EndIf

Return()


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Process()
/////////////////////////

//verificar se o usuario escolheu mais de uma forma. ou formas não disponiveis pra processamento ainda...
DbSelectArea("XTP")
DbGoTop()
_xcount := 0
Do While !Eof()
	If Marked("OK")
		_xcount++
	EndIf
	XTP->(dbskip())
EndDo
If _xcount = 0
	MsgInfo("Necessário escolher uma forma de pagamento !")
	return nil
EndIf

If _xcount > 1
	MsgInfo("Favor escolher apenas uma forma de pagamento !")
	return nil
EndIf
//verifica qual foi a escolha
DbGoTop()
_escolha:=''
Do While !Eof()
	If Marked("OK")
		_escolha:=XTP->PAT_FORMA
	EndIf
	XTP->(dbskip())
EndDo
If _escolha <> 'R$' .and. _escolha <> 'CH' .and. _escolha <> 'U$' .and. _escolha <> 'E$' .and. _escolha <> 'FI' .and. _escolha <> '$'
	MsgInfo("Forma de pagamento ainda não definida para integração !")
	return nil
EndIf

//oProcess := MsNewProcess():New({|lEnd| Integra3(@lEnd)},"Processando","Transferindo...",.T.)
Processa({|| INTEGRA3() },"Processando...")

//oProcess:Activate()

return nil

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Integra2()
//////////////////////////
lINVERTE	:= .F.
bPesqui		:= {|| Pesqui()}
bLibera		:= {|| Libera()}
aRotina 	:= {{ "Pesquisar"	, "Eval(bPesqui)"	, 0 , 1} , { "Liberacao"	, "Eval(bLibera)"	, 0 , 3}}

aCampos 	:= {}
aAdd(aCampos, {"E_OK"      , "C" ,  2, 0})
aAdd(aCampos, {"E_FILIAL"  , "C" ,  2, 0})
aAdd(aCampos, {"E_DATA"    , "D" ,  8, 0})
aAdd(aCampos, {"E_MOEDA"   , "C" ,  3, 0})
aAdd(aCampos, {"E_VALOR"   , "N" , 17, 2})
aAdd(aCampos, {"E_VALORDIG", "N" , 17, 2})
aAdd(aCampos, {"E_NATUREZ" , "C" , 10, 0})
aAdd(aCampos, {"E_BANCO"   , "C" ,  3, 0})
aAdd(aCampos, {"E_AGENCIA" , "C" ,  2, 0})
aAdd(aCampos, {"E_CONTA"   , "C" , 10, 0})
aAdd(aCampos, {"E_DOCUMEN" , "C" , 50, 0})
aAdd(aCampos, {"E_VENCTO"  , "D" ,  8, 0})
aAdd(aCampos, {"E_RECPAG"  , "C" ,  1, 0})
aAdd(aCampos, {"E_BENEF"   , "C" , 30, 0})
aAdd(aCampos, {"E_HISTOR"  , "C" ,100, 0})
aAdd(aCampos, {"E_DTDIGIT" , "D" ,  8, 0})
aAdd(aCampos, {"E_DTDISPO" , "D" ,  8, 0})
aAdd(aCampos, {"E_FILORIG" , "C" ,  2, 0})
aAdd(aCampos, {"E_MODSPB"  , "C" ,  1, 0})
aAdd(aCampos, {"E_DEBITO"  , "C" , 20, 0})
aAdd(aCampos, {"E_SERREC"  , "C" ,  6, 0})
aAdd(aCampos, {"E_TURNO"   , "C" ,  1, 0})
aAdd(aCampos, {"E_OPERAD"  , "C" , 10, 0})
aAdd(aCampos, {"E_PDV"     , "C" , 10, 0})
aAdd(aCampos, {"E_NUMCFI"  , "C" ,  6, 0})
aAdd(aCampos, {"VALOR"     , "N" , 17, 2})
aAdd(aCampos, {"VALORDIG"  , "N" , 17, 2})
aAdd(aCampos, {"DIFF"      , "N" , 17, 2})
aAdd(aCampos, {"PAT_FORMA" , "C" ,  2, 0})
aAdd(aCampos, {"QTD_MOEDA" , "N" , 10, 2})

aCpos		:= {}
aAdd(aCpos, {"E_OK"	   			,,  		})
aAdd(aCpos, {"E_FILIAL"	 		,, "Filial"	})
aAdd(aCpos, {"E_PDV"	    	,, "PDV"	})
aAdd(aCpos, {"E_DATA"	    	,, "Data"	})
aAdd(aCpos, {"E_VALOR"			,, "Valor Sistema"	})
aAdd(aCpos, {"E_VALORDIG"		,, "Valor Digitado"	})
aAdd(aCpos, {"DIFF"        		,, "Diferenca" })
If alltrim(_escolha)== "U$" .or. alltrim(_escolha) == "E$"
	aAdd(aCpos, {"QTD_MOEDA"   	,, "Qtd. Moeda" })
EndIf
aAdd(aCpos, {"E_DATA"			,, "Dta Operacao" })
aAdd(aCpos, {"E_DATA" 			,, "Dta Digt"	})
aAdd(aCpos, {"E_DATA" 			,, "Dta Dispon"	})
aAdd(aCpos, {"E_TURNO" 			,, "Turno"	})
aAdd(aCpos, {"PAT_FORMA"    	,, "Forma Pagto."})

cTrab := CriaTrab(aCampos,.t.)
DBUseArea( .T.,, cTrab, "TMP", .F., .F. )

IndRegua("TMP",cTrab,"E_FILIAL+DTOC(E_DATA)+E_PDV",,,"Ordenando por Numero")

GeraSql()

DbSelectArea("TMP")
DbGoTop()
//MarkBrow("TMP","OK","",aCpos,,cMarca)
MarkBrow("XTP","E_OK","",aCpos,lINVERTE,cMarca,,,,,,,)
Return nil

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Integra3()
//////////////////////////
public oDet

Private cTitulo

Private oValor
Private nValor		:= 0
Private oQtda
Private nQtdTit		:= 0

Private cMarca		:= GetMark()
Private lInverte	:= .F.

private oDlg1
private oBtnDet1
private oBtnDet2
private oBtnDet3
private oBtnDet4

Private oOk         := LoadBitmap( GetResources(), "LBOK")
Private oNo         := LoadBitmap( GetResources(), "LBNO")

Do Case
	Case alltrim(_escolha) == '$'
		cTitulo 	:= "PROCESSA MOVIMENTOS EM PESO ARGENTINO "
	Case alltrim(_escolha) == 'CC'
		cTitulo 	:= "PROCESSA MOVIMENTOS CARTAO DE CREDITO "
	Case alltrim(_escolha) == 'CD'
		cTitulo 	:= "PROCESSA MOVIMENTOS CARTAO DE DEB AUTOMATICO "
	Case alltrim(_escolha) == 'CO'
		cTitulo 	:= "PROCESSA MOVIMENTOS COVENIO/CIAS "
	Case alltrim(_escolha) == 'CR'
		cTitulo 	:= "PROCESSA MOVIMENTOS CREDITO "
	Case alltrim(_escolha) == 'DC'
		cTitulo 	:= "PROCESSA MOVIMENTOS DEBITO EM CC "
	Case alltrim(_escolha) == 'R$'
		cTitulo 	:= "PROCESSA MOVIMENTOS EM REAL "
	Case alltrim(_escolha) == 'U$'
		cTitulo 	:= "PROCESSA MOVIMENTOS EM DOLAR"
	Case alltrim(_escolha) == 'E$'
		cTitulo  	:= "PROCESSA MOVIMENTOS EM EURO "
	Case alltrim(_escolha) == 'CH'
		cTitulo 	:= "PROCESSA MOVIMENTOS EM CHEQUE "
	Case alltrim(_escolha) == 'FI'
		cTitulo 	:= "PROCESSA MOVIMENTOS CHEQUE PRE "
	Case alltrim(_escolha) == 'VA'
		cTitulo 	:= "PROCESSA MOVIMENTOS EM VALE (PROMOCOES/VOUCHER) "
	Case alltrim(_escolha) == 'MK'
		cTitulo 	:= "PROCESSA MOVIMENTO EM MAKTOUR "
EndCase

If Select("TMP") > 0
	TMP->( DbCloseArea() )
EndIf

aCampos := {}
aAdd(aCampos, {"E_OK"      , "C" ,  2, 0})
aAdd(aCampos, {"E_FILIAL"  , "C" ,  2, 0})
aAdd(aCampos, {"E_DATA"    , "D" ,  8, 0})
aAdd(aCampos, {"E_MOEDA"   , "C" ,  3, 0})
aAdd(aCampos, {"E_VALOR"   , "N" , 17, 2})
aAdd(aCampos, {"E_VALORDIG", "N" , 17, 2})
aAdd(aCampos, {"E_NATUREZ" , "C" , 10, 0})
aAdd(aCampos, {"E_BANCO"   , "C" ,  3, 0})
aAdd(aCampos, {"E_AGENCIA" , "C" ,  2, 0})
aAdd(aCampos, {"E_CONTA"   , "C" , 10, 0})
aAdd(aCampos, {"E_DOCUMEN" , "C" , 50, 0})
aAdd(aCampos, {"E_VENCTO"  , "D" ,  8, 0})
aAdd(aCampos, {"E_RECPAG"  , "C" ,  1, 0})
aAdd(aCampos, {"E_BENEF"   , "C" , 30, 0})
aAdd(aCampos, {"E_HISTOR"  , "C" ,100, 0})
aAdd(aCampos, {"E_DTDIGIT" , "D" ,  8, 0})
aAdd(aCampos, {"E_DTDISPO" , "D" ,  8, 0})
aAdd(aCampos, {"E_FILORIG" , "C" ,  2, 0})
aAdd(aCampos, {"E_MODSPB"  , "C" ,  1, 0})
aAdd(aCampos, {"E_DEBITO"  , "C" , 20, 0})
aAdd(aCampos, {"E_SERREC"  , "C" ,  6, 0})
aAdd(aCampos, {"E_TURNO"   , "C" ,  1, 0})
aAdd(aCampos, {"E_OPERAD"  , "C" , 10, 0})
aAdd(aCampos, {"E_PDV"     , "C" , 10, 0})
aAdd(aCampos, {"E_NUMCFI"  , "C" ,  6, 0})
aAdd(aCampos, {"VALOR"     , "N" , 17, 2})
aAdd(aCampos, {"VALORDIG"  , "N" , 17, 2})
aAdd(aCampos, {"DIFF"      , "N" , 17, 2})
aAdd(aCampos, {"PAT_FORMA" , "C" ,  2, 0})
aAdd(aCampos, {"QTD_MOEDA" , "N" , 10, 2})

aCpos		:= {}
aAdd(aCpos, {"E_OK"	   			,,  		})
aAdd(aCpos, {"E_FILIAL"	 		,, "Filial"	})
aAdd(aCpos, {"E_PDV"	    	,, "PDV"	})
aAdd(aCpos, {"E_DATA"	    	,, "Data"	})
aAdd(aCpos, {"E_VALOR"			,, "Valor Sistema"	})
aAdd(aCpos, {"E_VALORDIG"		,, "Valor Digitado"	})
aAdd(aCpos, {"DIFF"        		,, "Diferenca" })

If Alltrim(_escolha)== "U$" .Or. Alltrim(_escolha) == "E$"
	aAdd(aCpos, {"QTD_MOEDA"   	,, "Qtd. Moeda" })
EndIf

aAdd(aCpos, {"E_DATA"			,, "Dta Operacao" })
aAdd(aCpos, {"E_DATA" 			,, "Dta Digt"	})
aAdd(aCpos, {"E_DATA" 			,, "Dta Dispon"	})
aAdd(aCpos, {"E_TURNO" 			,, "Turno"	})
Aadd(aCpos, {"PAT_FORMA"    	,, "Forma Pagto."})

cTrab := CriaTrab(aCampos,.t.)
DbUseArea( .T.,, cTrab, "TMP", .F., .F. )

IndRegua("TMP",cTrab,"E_FILIAL+DTOC(E_DATA)+E_PDV",,,"Ordenando por Numero")

GeraSql()

DbSelectArea("TMP")
TMP->( DbGoTop() )

DEFINE MSDIALOG oDlg1 TITLE cTitulo  From 10,10 To 600,1300 PIXEL
//oDlg1:LMAXIMIZED := .T.

@1.4,.8 SAY "Valor Total:"
@1.4, 7 SAY oValor VAR nValor Picture "@E 999,999,999.99"
@1.9,.8 SAY "Quantidade:"
@1.9, 9 SAY oQtda VAR nQtdTit Picture "@E 99999" SIZE 50,10

//oMark 						:= MsSelect():New("TMP","E_OK",,aCpos,@lInverte,@cMarca,{35,5,250,595})
//oMark:bMark 					:= {|| fa160Display(cMarca,lInverte,oValor,oQtda)}
//oMark:oBrowse:lhasMark 		= .t.
//oMark:oBrowse:lCanAllmark 	:= .t.
//OMARK:OBROWSE:BLDBLCLICK 		:= {|| U_Fin3Clik() } //,TMP->OK:=cMarca }

@ 050, 008 LISTBOX oDet Fields HEADER ;
"","Filial","PDV","Data","Valor Sistema","Valor Digitado","Diferenca","Dta Operacao","Dta Digt","Dta Dispon","Turno","Forma Pagto";
SIZE 600, 200 OF oDlg1 PIXEL ColSizes 10,20,70,50,70,70,70,50,50,50,20,20
oDet:SetArray(_aTemp)
oDet:Refresh()
oDet:AddColumn( TCColumn():New('' 				,{ || Iif(_aTemp[oDet:nAT,01],oOk,oNo) }				   	,,,,"LEFT" ,10,.T.,.T.,,,,.F.,) )
oDet:AddColumn( TCColumn():New('Filial' 		,{ || _aTemp[oDet:nAt,02] }									,,,,"LEFT" ,20,.F.,.T.,,,,.F.,) )
oDet:AddColumn( TCColumn():New('PDV' 			,{ || _aTemp[oDet:nAt,25] }									,,,,"LEFT" ,70,.F.,.T.,,,,.F.,) )
oDet:AddColumn( TCColumn():New('Data' 			,{ || DtoC(_aTemp[oDet:nAt,03]) }							,,,,"LEFT" ,50,.F.,.T.,,,,.F.,) )
oDet:AddColumn( TCColumn():New('Valor Sistema' 	,{ || transform(_aTemp[oDet:nAt,05],"@E 999,999,999.99") }	,,,,"RIGHT",70,.F.,.T.,,,,.F.,) )
oDet:AddColumn( TCColumn():New('Valor Digitado' ,{ || transform(_aTemp[oDet:nAt,06],"@E 999,999,999.99") }	,,,,"RIGHT",70,.F.,.T.,,,,.F.,) )
oDet:AddColumn( TCColumn():New('Diferenca' 		,{ || transform(_aTemp[oDet:nAt,11],"@E 999,999,999.99") }	,,,,"RIGHT",70,.F.,.T.,,,,.F.,) )
oDet:AddColumn( TCColumn():New('Dta Operacao' 	,{ || DtoC(_aTemp[oDet:nAt,03]) }							,,,,"LEFT" ,50,.F.,.T.,,,,.F.,) )
oDet:AddColumn( TCColumn():New('Dta Digt' 		,{ || DtoC(_aTemp[oDet:nAt,03]) }							,,,,"LEFT" ,50,.F.,.T.,,,,.F.,) )
oDet:AddColumn( TCColumn():New('Dta Dispon' 	,{ || DtoC(_aTemp[oDet:nAt,03]) }							,,,,"LEFT" ,50,.F.,.T.,,,,.F.,) )
oDet:AddColumn( TCColumn():New('Turno' 			,{ || _aTemp[oDet:nAt,23] }									,,,,"LEFT" ,20,.F.,.T.,,,,.F.,) )
oDet:AddColumn( TCColumn():New('Forma Pagto' 	,{ || _aTemp[odet:nat][4] }									,,,,"LEFT" ,20,.F.,.T.,,,,.F.,) )

// DoubleClick event
//oDet:blDblClick 	:= { || _aTemp[oDet:nAT,01]:=!_aTemp[oDet:nAT,01] }
oDet:bLDblClick 	:= {|| _aTemp[oDet:nAt,1] := !_aTemp[oDet:nAt,1],oDet:DrawSelect(),U_Fin3Clik(_aTemp[oDet:nAt,1])}

//@ 270,5	 BUTTON "Pesquisa" 	SIZE 30,15 ACTION( Pesqui() )  															OF oDlg1 PIXEL
//@ 270,45 BUTTON "Processa"	SIZE 30,15 ACTION(LjMsgRun("Aguarde..., Liberando movimentos...",, {|| Libera() }) ) 	OF oDlg1 PIXEL
//@ 270,85 BUTTON "Imprime"	SIZE 30,15 ACTION(Imprime())  																OF oDlg1 PIXEL

@ 270, 005 BUTTON oBtnDet1           PROMPT "Pesquisa"    ACTION(Pesqui())															SIZE 037, 012 OF oDlg1 PIXEL
@ 270, 045 BUTTON oBtnDet2           PROMPT "Processa"    ACTION(LjMsgRun("Aguarde..., Liberando movimentos...",, {|| Libera() }))	SIZE 037, 012 OF oDlg1 PIXEL
@ 270, 085 BUTTON oBtnDet3           PROMPT "Imprime"     ACTION(Imprime())															SIZE 037, 012 OF oDlg1 PIXEL
@ 270, 125 BUTTON oBtnDet4           PROMPT "Zerados"     ACTION(LjMsgRun("Aguarde..., Liberando movimentos...",, {|| ProcZero() }))SIZE 037, 012 OF oDlg1 PIXEL

ACTIVATE MSDIALOG oDlg1 //CENTERED //ON INIT EnchoiceBar(oDlg1,{|| nOpca := 1,oDlg1:End()},{|| nOpca := 2,oDlg1:End()})

Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function Fin3Clik(lMarcado)
////////////////////////

Local _lret

//If !(TMP->E_FILIAL $ GetMV('MV_EMPFIL')) .and. TMP->E_OK <> cMarca
If !(_aTemp[oDet:nAt,2] $ GetMV('MV_EMPFIL')) .and. lMarcado
	_lRet := MsgBox('Loja selecionada não pertence à Centralizadora logada.' + _cEnter + _cEnter + 'Confirma movimentação?','ATENÇÃO!!!','YESNO')
Else
	_lRet := .t.
EndIf

If _lRet
	
	//RecLock('TMP',.F.)
	//TMP->E_OK := iif(TMP->E_OK == cMarca, '', cMarca)
	//MsUnLock()
	
	oMark:oBrowse:REFRESH()
	fa160Display(cMarca,lInverte,oValor,oQtda,lMarcado,.F.)
EndIf

Return(_lRet)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FinZClik(lMarcado)
////////////////////////

Local _lret

//If !(TMP->E_FILIAL $ GetMV('MV_EMPFIL')) .and. TMP->E_OK <> cMarca
If !(_aTempZero[oDet2:nAt,2] $ GetMV('MV_EMPFIL')) .and. lMarcado
	_lRet := MsgBox('Loja selecionada não pertence à Centralizadora logada.' + _cEnter + _cEnter + 'Confirma movimentação?','ATENÇÃO!!!','YESNO')
Else
	_lRet := .t.
EndIf

If _lRet
	
	//RecLock('TMP',.F.)
	//TMP->E_OK := iif(TMP->E_OK == cMarca, '', cMarca)
	//MsUnLock()
	
	oMark:oBrowse:REFRESH()
	fa160Display(cMarca,lInverte,oValor,oQtda,lMarcado,.T.)
EndIf

Return(_lRet)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function AtuValZero(aArray, lMARCADO)
////////////////////////

If lMarcado // IsMark("E_OK",cMarca,lInverte)
	nValorZero := 0
	FOR nX := 1 TO LEN(aARRAY)
		nValorZero += aARRAY[nX][6] //TMP->E_VALORDIG
		//nQtdTitZero++
	NEXT
	nQtdTitZero := LEN(aARRAY)
Else
	nValorZero  := 0
	nQtdTitZero := 0
EndIf


oValorZero:Refresh()
oQtdaZero:Refresh()

Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GeraSql()
/////////////////////////

Public _aTemp 		:= {}
Public _aTempZero	:= {}

If Select("QRY") > 0
	QRY->( DbCloseArea() )
EndIf

cQuery1 := " SELECT PAT_FILIAL, PAT_DTFECH, SUM(PAT_VLRSIS) AS VALOR, SUM(PAT_VLRDIG) AS VALORDIG, PAT_TURNO, PAT_FORMA, PAT_BANCO, PAT_AGENCI, PAT_CONTA, PAT_NUMCFI, PAT_OPERAD, PAT_PDV, PAT_FORMA  "
cQuery1 += " FROM "+RetSqlName("PAT")+" PAT (NOLOCK)"
cQuery1 += " WHERE PAT_FORMA 		= '" + _escolha + "' AND "
cQuery1 += " PAT.D_E_L_E_T_ 		= '' "
cQuery1 += " AND PAT_STATUS 		<> 'S' "
//cQuery1 += " AND PAT_FILIAL 		IN " + FormatIn(alltrim(GetMV('MV_EMPFIL')),'/')
cQuery1 += " AND PAT_DTFECH 		BETWEEN '" +DTOS(_ddadata)+"' AND '"+DTOS(_datedata)+"'"
cQuery1 += " GROUP BY PAT_FILIAL, PAT_DTFECH, PAT_TURNO, PAT_FORMA, PAT_BANCO, PAT_AGENCI, PAT_CONTA, PAT_NUMCFI, PAT_OPERAD, PAT_PDV, PAT_FORMA "
cQuery1 += " ORDER BY PAT_FILIAL, PAT_DTFECH, PAT_TURNO "

DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery1), "QRY", .F., .T.)

DbSelectArea("TMP")

DbSelectArea("QRY")
DbGoTop()
If !Eof()
	Do While !Eof()
		DbSelectArea("SX5")
		Dbsetorder(01)
		SX5->(DbSeek(space(02)+'ZD'+QRY->PAT_FILIAL))
		If SX5->(found())
			_conta := alltrim(SX5->X5_DESCRI)
		Else
			_conta := ''
		EndIf
		
		DbSelectArea("SM2")
		Dbsetorder(01)
		SM2->(DbSeek(STOD(QRY->PAT_DTFECH)))
		If SM2->(found())
			If alltrim(_escolha) == "U$"
				_qtdmoeda := QRY->VALORDIG/SM2->M2_MOEDA2
			ElseIf alltrim(_escolha) == "E$"
				_qtdmoeda := QRY->VALORDIG/SM2->M2_MOEDA4
			Else
				_qtdmoeda := 0
			EndIf
		Else
			_qtdmoeda := 0
		EndIf
		/*
		RecLock("TMP",.T.)
		
		TMP->E_FILIAL 	:= QRY->PAT_FILIAL
		TMP->E_DATA 	:= STOD(QRY->PAT_DTFECH)
		TMP->E_MOEDA 	:= QRY->PAT_FORMA
		TMP->E_VALOR 	:= QRY->VALOR
		TMP->E_VALORDIG	:= QRY->VALORDIG
		TMP->E_NATUREZ  := "DEPOSITO"
		TMP->E_BANCO 	:= QRY->PAT_BANCO
		TMP->E_AGENCIA  := QRY->PAT_AGENCI
		TMP->E_CONTA 	:= QRY->PAT_CONTA
		TMP->DIFF       := QRY->VALORDIG-QRY->VALOR
		
		TMP->E_DOCUMEN	:= QRY->PAT_FILIAL+QRY->PAT_DTFECH+QRY->PAT_TURNO
		TMP->E_VENCTO   := STOD(QRY->PAT_DTFECH)
		TMP->E_RECPAG  	:= "R"
		TMP->E_BENEF 	:= Alltrim(GetAdvFVal("SM0","M0_NOME",cEmpAnt + QRY->PAT_FILIAL,1))+" - "+Alltrim(GetAdvFVal("SM0","M0_FILIAL",cEmpAnt + QRY->PAT_FILIAL,1))
		do case
		case alltrim(_escolha) == 'R$'
		TMP->E_HISTOR 	:= "MOVTO EM REAIS - "				+DTOC(STOD(QRY->PAT_DTFECH))//+" PERIODO: "+QRY->PAT_TURNO
		case alltrim(_escolha) == 'U$'
		TMP->E_HISTOR 	:= "MOVTO EM REAIS (DOLARES) - "	+DTOC(STOD(QRY->PAT_DTFECH))//+" PERIODO: "+QRY->PAT_TURNO
		case alltrim(_escolha) == 'E$'
		TMP->E_HISTOR 	:= "MOVTO EM REAIS (EURO) - "		+DTOC(STOD(QRY->PAT_DTFECH))//+" PERIODO: "+QRY->PAT_TURNO
		case alltrim(_escolha) == 'CH'
		TMP->E_HISTOR 	:= "MOVTO EM REAIS (CHEQUE) - "		+DTOC(STOD(QRY->PAT_DTFECH))//+" PERIODO: "+QRY->PAT_TURNO
		case alltrim(_escolha) == 'FI'
		TMP->E_HISTOR 	:= "MOVTO EM REAIS (CHEQUE PRE) - "	+DTOC(STOD(QRY->PAT_DTFECH))//)+" PERIODO: "+QRY->PAT_TURNO
		endcase
		TMP->E_DTDIGIT	:= STOD(QRY->PAT_DTFECH)
		TMP->E_DTDISPO	:= STOD(QRY->PAT_DTFECH)
		TMP->E_FILORIG  := QRY->PAT_FILIAL
		TMP->E_MODSPB   := "4"
		TMP->E_DEBITO   := _conta
		TMP->E_SERREC   := Right(QRY->PAT_PDV,6)	//QRY->PAT_NUMCFI
		TMP->E_TURNO    := QRY->PAT_TURNO
		TMP->E_OPERAD   := QRY->PAT_OPERAD
		TMP->E_PDV		:= QRY->PAT_PDV
		TMP->E_NUMCFI   := QRY->PAT_NUMCFI
		TMP->PAT_FORMA  := QRY->PAT_FORMA
		TMP->QTD_MOEDA  := _qtdmoeda
		
		MsUnLock()
		*/
		cHist	:= "Não Especificado"
		do case
			case alltrim(_escolha) == 'R$'
				cHist 	:= "MOVTO EM REAIS - "				+DTOC(STOD(QRY->PAT_DTFECH))//+"  PERIODO: "+QRY->PAT_TURNO
			case alltrim(_escolha) == 'U$'
				cHist 	:= "MOVTO EM REAIS (DOLARES) - "	+DTOC(STOD(QRY->PAT_DTFECH))//+"  PERIODO: "+QRY->PAT_TURNO
			case alltrim(_escolha) == 'E$'
				cHist 	:= "MOVTO EM REAIS (EURO) - "		+DTOC(STOD(QRY->PAT_DTFECH))//+"  PERIODO: "+QRY->PAT_TURNO
			case alltrim(_escolha) == 'CH'
				cHist 	:= "MOVTO EM REAIS (CHEQUE) - "		+DTOC(STOD(QRY->PAT_DTFECH))//+"  PERIODO: "+QRY->PAT_TURNO
			case alltrim(_escolha) == 'FI'
				cHist 	:= "MOVTO EM REAIS (CHEQUE PRE) - "	+DTOC(STOD(QRY->PAT_DTFECH))//)+" PERIODO: "+QRY->PAT_TURNO
		endcase
		
		IF (QRY->VALORDIG-QRY->VALOR) != 0
			
			aadd(_aTemp, {.F.								,;
			QRY->PAT_FILIAL									,;
			STOD(QRY->PAT_DTFECH)							,;
			QRY->PAT_FORMA									,;
			QRY->VALOR										,;
			QRY->VALORDIG									,;
			"DEPOSITO"										,;
			QRY->PAT_BANCO									,;
			QRY->PAT_AGENCI									,;
			QRY->PAT_CONTA									,;
			QRY->VALORDIG-QRY->VALOR						,;
			QRY->PAT_FILIAL+QRY->PAT_DTFECH+QRY->PAT_TURNO	,;
			STOD(QRY->PAT_DTFECH)							,;
			"R"												,;
			Alltrim(GetAdvFVal("SM0","M0_NOME",cEmpAnt + QRY->PAT_FILIAL,1))+" - "+Alltrim(GetAdvFVal("SM0","M0_FILIAL",cEmpAnt + QRY->PAT_FILIAL,1)),;
			cHist											,;
			STOD(QRY->PAT_DTFECH)							,;
			STOD(QRY->PAT_DTFECH)							,;
			QRY->PAT_FILIAL									,;
			"4"												,;
			_conta											,;
			Right(QRY->PAT_PDV,6)							,;	//QRY->PAT_NUMCFI
			QRY->PAT_TURNO									,;
			QRY->PAT_OPERAD									,;
			QRY->PAT_PDV									,;
			QRY->PAT_NUMCFI									,;
			QRY->PAT_FORMA									,;
			_qtdmoeda										})
		ELSE
			aadd(_aTempZero, {.F.							,;
			QRY->PAT_FILIAL									,;
			STOD(QRY->PAT_DTFECH)							,;
			QRY->PAT_FORMA									,;
			QRY->VALOR										,;
			QRY->VALORDIG									,;
			"DEPOSITO"										,;
			QRY->PAT_BANCO									,;
			QRY->PAT_AGENCI									,;
			QRY->PAT_CONTA									,;
			QRY->VALORDIG-QRY->VALOR						,;
			QRY->PAT_FILIAL+QRY->PAT_DTFECH+QRY->PAT_TURNO	,;
			STOD(QRY->PAT_DTFECH)							,;
			"R"												,;
			Alltrim(GetAdvFVal("SM0","M0_NOME",cEmpAnt + QRY->PAT_FILIAL,1))+" - "+Alltrim(GetAdvFVal("SM0","M0_FILIAL",cEmpAnt + QRY->PAT_FILIAL,1)),;
			cHist											,;
			STOD(QRY->PAT_DTFECH)							,;
			STOD(QRY->PAT_DTFECH)							,;
			QRY->PAT_FILIAL									,;
			"4"												,;
			_conta											,;
			Right(QRY->PAT_PDV,6)							,;	//QRY->PAT_NUMCFI
			QRY->PAT_TURNO									,;
			QRY->PAT_OPERAD									,;
			QRY->PAT_PDV									,;
			QRY->PAT_NUMCFI									,;
			QRY->PAT_FORMA									,;
			_qtdmoeda										})
		ENDIF
		
		DbSelectArea("QRY")
		DbSkip()
	EndDo
EndIf

// VALIDAÇÃO FAIL SAFE PARA QUANDO NÃO HOUVER VALORES DISPONÍVEIS
IF Len(_aTemp) == 0
	aadd(_aTemp, {.F.			,;
	""				,;
	STOD("")		,;
	""				,;
	0				,;
	0				,;
	""				,;
	""				,;
	""				,;
	""				,;
	0				,;
	""				,;
	STOD("")		,;
	""				,;
	""				,;
	""				,;
	STOD("")		,;
	STOD("")		,;
	""				,;
	""				,;
	""				,;
	""				,;	//QRY->PAT_NUMCFI
	""				,;
	""				,;
	""				,;
	""				,;
	""				,;
	0				})
ENDIF

Return nil

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Pesqui()
////////////////////////

Private cRom	:= Space(8)
Private oDlgPsq

DEFINE MSDIALOG oDlgPsq TITLE "Pesquisa" FROM 129,047 TO 250,280 PIXEL

@ 08,20 SAY OemToAnsi("Filial")	PIXEL OF oDlgPsq
@ 06,50 MSGET oRom VAR cRom PICTURE "@!"	PIXEL OF oDlgPsq
@ 30,20 BUTTON "Ok"  		SIZE 31,10 ACTION PsqRom()			PIXEL OF oDlgPsq
@ 30,70 BUTTON "Cancela"	SIZE 30,10 ACTION oDlgPsq:End()		PIXEL OF oDlgPsq

ACTIVATE MSDIALOG oDlgPsq CENTERED
Return nil


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function PsqRom()
////////////////////////
/*
DbSelectArea("TMP")
IndRegua("TMP",cTrab,"E_FILIAL",,,"Ordenando por Números")
If !DbSeek(cRom,.F.)
MsgStop("Não encontrado!")
EndIf
MarkBRefresh()
oDlgPsq:End()
*/
nPos := ASCAN(_aTemp,{|x| alltrim(x[2])==alltrim(cRom) })

oDet:goTop()
oDet:setFocus()
//oDet:nRowPos := nPos
IF nPOS > 0
	oDET:NAT := nPOS
ELSE
	MsgStop("Não encontrado!")
ENDIF
oDet:setFocus()
oDet:Refresh(.T.)
oDlgPsq:End()

Return(Nil)


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Libera()
////////////////////////

Local aArea  := GetArea()
Local aaArea := SE5->(GetArea())

Private cPergConta := Padr("FINA03BC"+cFilAnt,len(SX1->X1_GRUPO)," ")
ValidPerg2()

// posiciona o ponteiro no primeiro registro selecionado para pegar os dados do banco.
/*
DbSelectArea("TMP")
DbGoTop()
Do While !Eof()
If !Marked("E_OK")
DbSelectArea("TMP")
DbSkip()
Loop
Else
exit
EndIf
EndDo
*/
// executo o seek antes de criar as perguntas para pegar os dados do banco escolhido no momento do fechamento de caixa.
DbSelectArea("PAT")
//PAT->(DbSetOrder(1))
//PAT->(DbSeek( TMP->E_FILIAL+ dtos(TMP->E_DATA)+ TMP->E_OPERAD+  TMP->E_PDV+ TMP->E_TURNO+ TMP->E_NUMCFI+ TMP->E_MOEDA ))

Do While .t.
	If !Pergunte(cPergConta, .T.)
		MsgBox('Rotina abortada pelo usuário','Câmara Conciliadora','INFO')
		Return()
	EndIf
	If Posicione('SA6',1,xFilial('SA6') + mv_par02 + mv_par03 + mv_par04,'A6_EMPRESA') $ GETMV("MV_EMPGRP")
		Exit
	EndIf
EndDo

Begin Transaction

//DbSelectArea("TMP")
//DbGoTop()
_nValor := 0
_nDiff  := 0
//NX		:= 0
//Do While TMP->(!Eof())
For nX := 1 To Len(_aTemp)
	
	If !_aTemp[nX][01] //!TMP->(Marked("E_OK"))
		//DbSelectArea("TMP")
		//TMP->(DbSkip())
		Loop
	EndIf
	
	//MsAguarde({|lEnd| },"Aguarde...","Liberando Movimento: "+Alltrim(TMP->E_FILIAL+dtoc(TMP->E_DATA)+TMP->E_TURNO),.T.)
	MsAguarde({|lEnd| },"Aguarde...","Liberando Movimento: "+Alltrim(_aTemp[nX][02]+DtoC(_aTemp[nX][03])+_aTemp[nX][23]),.T.)
	
	DbSelectArea("PAT")
	DbSetOrder(1)
	//If PAT->(DbSeek(TMP->E_FILIAL+ dtos(TMP->E_DATA)+ TMP->E_OPERAD+  TMP->E_PDV+ TMP->E_TURNO+ TMP->E_NUMCFI+ TMP->E_MOEDA ))
	IF dbSeek(_aTemp[nX][02]+DTOS(_aTemp[nX][03])+_aTemp[nX][24]+_aTemp[nX][25]+_aTemp[nX][23]+_aTemp[nX][26]+_aTemp[nX][27])
		
		If empty(PAT->PAT_STATUS)
			RecLock("PAT",.F.)
			PAT ->PAT_STATUS := "S"
			MsUnLock()
		EndIf
	EndIf
	
	//DbSelectArea('TMP')
	
	_nValor += _aTemp[nX][06] //TMP->E_VALORDIG
	_nDiff  += _aTemp[nX][11] //TMP->DIFF
	
	//RecLock('TMP',.f.)
	//DbDelete()
	//MsUnLock()
	
	If alltrim(_escolha) $ 'R$/CH'
		_cMoeda	:= 'R$'
	Else
		_cMoeda	:= _aTemp[nX][27] 		// TMP->E_MOEDA
	EndIf
	
	_cDocumen 		:= _aTemp[nX][02]+DTOS(_aTemp[nX][03])+_aTemp[nX][23]+"_"+_aTemp[nX][25]// TMP->E_FILIAL + DTOS(TMP->E_DATA) + TMP->E_TURNO + '_' +TMP->E_PDV
	_cData 			:= MV_PAR01 		// TMP->E_DATA
	_cBenef 		:= _aTemp[nX][15] 	// TMP->E_BENEF
	_cHistor	   	:= _aTemp[nX][16] 	// TMP->E_HISTOR
	_cFilOri	    := _aTemp[nX][02] 	// TMP->E_FILIAL
	_cDebito	    := _aTemp[nX][10] 	// TMP->E_DEBITO
	_cNumCheque     := _aTemp[nX][02] +" "+DTOS(_aTemp[nX][03]) //TMP->E_FILIAL + ' ' + dtos(TMP->E_DATA)
	_cFilial        := cFilAnt
	
Next nX
//	DbSkip()
//EndDo

If _nValor <> 0 //!eof()
	
	RecLock("SE5",.t.)
	MsUnLock()
	
	RecLock("SE5",.f.)
	SE5->E5_FILIAL 	    	:= _cFilial
	SE5->E5_DATA 			:= MV_PAR01
	SE5->E5_VALOR 			:= _nValor// + max(_nDiff,0)
	SE5->E5_MOEDA 			:= _cMoeda
	do case
		case alltrim(_escolha) == 'R$'
			SE5->E5_NATUREZ 	:= "DEPOSITO"
			//SE5->E5_TIPODOC		:= 'VL'
		case alltrim(_escolha) == 'CH'
			SE5->E5_NATUREZ 	:= "CHEQUE"
			SE5->E5_TIPODOC		:= 'CH'
		case alltrim(_escolha) == 'FI'
			SE5->E5_NATUREZ 	:= "CHQPRER" // cheque pre a receber
			SE5->E5_TIPODOC		:= 'CH'
	endcase
	
	SE5->E5_BANCO 				:= MV_PAR02
	SE5->E5_AGENCIA 			:= MV_PAR03
	SE5->E5_CONTA 				:= MV_PAR04
	
	SE5->E5_DOCUMEN				:= _cDocumen
	SE5->E5_VENCTO      		:= _cData
	SE5->E5_RECPAG   			:= "R"
	SE5->E5_BENEF 				:= _cBenef
	SE5->E5_HISTOR   			:= _cHistor
	SE5->E5_DTDIGIT				:= MV_PAR01
	SE5->E5_DTDISPO				:= MV_PAR01
	SE5->E5_FILORIG	    		:= _cFilOri
	SE5->E5_MODSPB	    		:= "1"
	SE5->E5_TIPODOC     		:= ''
	SE5->E5_MOTBX       		:= ''
	SE5->E5_RATEIO      		:= 'N'
	SE5->E5_DEBITO      		:= _cDebito
	If _escolha == 'CH'
		SE5->E5_NUMCHE 			:=  _cNumCheque
	EndIf
	
	If _nDiff < 0
		SE5->E5_VLDESCO			:= abs(_nDiff)
		SE5->E5_VLDECRE			:= abs(_nDiff)
	Else
		SE5->E5_VLJUROS			:= _nDiff
		SE5->E5_VLACRES			:= _nDiff
	END
	
	SE5->(MsUnlock())
EndIf

End Transaction

nValor	:= 0
nQtdTi	:= 0

// atualizo o array após o processamento dos dados e gravação dos registros na SE5
RefreshArray(_aTemp)

RestArea(aArea)

Return NIL

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ProcZero()
////////////////////////

Local aArea  		:= GetArea()
Local aaArea 		:= SE5->(GetArea())
Local lConfirma		:= .T.

Private oDlg2
Private oBtnZero1
Private oBtnZero2
Private lInvGrp		:= .F.
Private oInverte
Private oValorZero
Private oQtdaZero
Private nValorZero	:= 0
Private nQtdTitZero	:= 0

Private cPergConta 	:= Padr("FINA03BC"+cFilAnt,len(SX1->X1_GRUPO)," ")

ValidPerg2()

nOpcao				:= Aviso("Zerados","Deseja processar automaticamente ou visualizar os dados para confirmação ? ",{"Processa","Visualiza"},2)

// SE APERTOU "ESC" PROCESSA AUTOMATICAMENTE
IIF(nOPCAO==0,1,nOPCAO)

IF nOpcao == 2

	lConfirma	:= .F.

	DEFINE MSDIALOG oDlg2 TITLE "Valores Zerados"  From 00,10 To 600,1300 PIXEL
	
	@ 1.4,.9 SAY "Valor Total:"
	@ 1.4, 7 SAY oValorZero VAR nValorZero Picture "@E 999,999,999.99"
	@ 1.9,.9 SAY "Quantidade:"
	@ 1.9, 9 SAY oQtdaZero VAR nQtdTitZero Picture "@E 99999" SIZE 50,10
	
	//@ 010,10 CHECKBOX oInverte			VAR lInvGrp 	PROMPT "Marcar/Desmarcar Todos"		SIZE 050, 010 OF oDlg2 PIXEL ON CLICK  (AEval(_aTempZero  ,{|z| z[1] := lInvGrp }),oDlg2:Refresh() ) //"Inverter Selecao"
	@ 040, 10 CHECKBOX oInverte VAR lInvGrp 	PROMPT "Marcar/Desmarcar Todos"	SIZE 105, 008 OF oDlg2  PIXEL ON CHANGE {|| aEval(_aTempZero,{|x| x[1] := lInvGrp }) ,oDet2:Refresh(), atuValZero(_aTempZero,lInvGrp) }
	
	@ 050, 008 LISTBOX oDet2 Fields HEADER ;
	"","Filial","PDV","Data","Valor Sistema","Valor Digitado","Diferenca","Dta Operacao","Dta Digt","Dta Dispon","Turno","Forma Pagto";
	SIZE 600, 200 OF oDlg2 PIXEL ColSizes 10,20,70,50,70,70,70,50,50,50,20,20
	oDet2:SetArray(_aTempZero)
	oDet2:Refresh()
	oDet2:AddColumn( TCColumn():New('' 					,{ || Iif(_aTempZero[oDet2:nAT,01],oOk,oNo) }				   	,,,,"LEFT" ,10,.T.,.T.,,,,.F.,) )
	oDet2:AddColumn( TCColumn():New('Filial' 			,{ || _aTempZero[oDet2:nAt,02] }								,,,,"LEFT" ,20,.F.,.T.,,,,.F.,) )
	oDet2:AddColumn( TCColumn():New('PDV' 				,{ || _aTempZero[oDet2:nAt,25] }								,,,,"LEFT" ,70,.F.,.T.,,,,.F.,) )
	oDet2:AddColumn( TCColumn():New('Data' 				,{ || DtoC(_aTempZero[oDet2:nAt,03]) }							,,,,"LEFT" ,50,.F.,.T.,,,,.F.,) )
	oDet2:AddColumn( TCColumn():New('Valor Sistema' 	,{ || transform(_aTempZero[oDet2:nAt,05],"@E 999,999,999.99") }	,,,,"RIGHT",70,.F.,.T.,,,,.F.,) )
	oDet2:AddColumn( TCColumn():New('Valor Digitado' 	,{ || transform(_aTempZero[oDet2:nAt,06],"@E 999,999,999.99") }	,,,,"RIGHT",70,.F.,.T.,,,,.F.,) )
	oDet2:AddColumn( TCColumn():New('Diferenca' 		,{ || transform(_aTempZero[oDet2:nAt,11],"@E 999,999,999.99") }	,,,,"RIGHT",70,.F.,.T.,,,,.F.,) )
	oDet2:AddColumn( TCColumn():New('Dta Operacao' 		,{ || DtoC(_aTempZero[oDet2:nAt,03]) }							,,,,"LEFT" ,50,.F.,.T.,,,,.F.,) )
	oDet2:AddColumn( TCColumn():New('Dta Digt' 			,{ || DtoC(_aTempZero[oDet2:nAt,03]) }							,,,,"LEFT" ,50,.F.,.T.,,,,.F.,) )
	oDet2:AddColumn( TCColumn():New('Dta Dispon' 		,{ || DtoC(_aTempZero[oDet2:nAt,03]) }							,,,,"LEFT" ,50,.F.,.T.,,,,.F.,) )
	oDet2:AddColumn( TCColumn():New('Turno' 			,{ || _aTempZero[oDet2:nAt,23] }								,,,,"LEFT" ,20,.F.,.T.,,,,.F.,) )
	oDet2:AddColumn( TCColumn():New('Forma Pagto' 		,{ || _aTempZero[oDet2:nat][4] }								,,,,"LEFT" ,20,.F.,.T.,,,,.F.,) )
	
	// DoubleClick event
	oDet2:bLDblClick 	:= {|| _aTempZero[oDet2:nAt,1] := !_aTempZero[oDet2:nAt,1],oDet2:DrawSelect(),U_FinZClik(_aTempZero[oDet2:nAt,1])}
	
	@ 270, 005 BUTTON oBtnZero1          PROMPT "Confirmar"    	ACTION( lConfirma := .T.,oDlg2:End() )		SIZE 037, 012 OF oDlg2 PIXEL
	@ 270, 045 BUTTON oBtnZero2          PROMPT "Cancelar"		ACTION( lConfirma := .F.,oDlg2:End() )		SIZE 037, 012 OF oDlg2 PIXEL
	
	ACTIVATE MSDIALOG oDlg2 //CENTERED //ON INIT EnchoiceBar(oDlg2,{|| nOpca := 1,oDlg2:End()},{|| nOpca := 2,oDlg2:End()})
	
ENDIF

//IF nOpcao == 2 // TYPE("oDlg2") != "U"
//	oDlg2:End()
//ENDIF

IF lCONFIRMA
	
	// executo o seek antes de criar as perguntas para pegar os dados do banco escolhido no momento do fechamento de caixa.
	DbSelectArea("PAT")
	//PAT->(DbSetOrder(1))
	//PAT->(DbSeek( TMP->E_FILIAL+ dtos(TMP->E_DATA)+ TMP->E_OPERAD+  TMP->E_PDV+ TMP->E_TURNO+ TMP->E_NUMCFI+ TMP->E_MOEDA ))
	
	Do While .t.
		If !Pergunte(cPergConta, .T.)
			MsgBox('Rotina abortada pelo usuário','Câmara Conciliadora','INFO')
			Return()
		EndIf
		If Posicione('SA6',1,xFilial('SA6') + mv_par02 + mv_par03 + mv_par04,'A6_EMPRESA') $ GETMV("MV_EMPGRP")
			Exit
		EndIf
	EndDo
	
	Begin Transaction
	
	_nValor := 0
	_nDiff  := 0

	For nX := 1 To Len(_aTempZero)
		
		// SÓ VALIDA MARCADOS SE ESCOLHER A OPÇÃO PARA VISUALIZAR OS DADOS
		// CASO CONTRÁRIO IRÁ PROCESSAR TODOS OS REGISTROS
		IF nOpcao == 2
			If !_aTempZero[nX][01] //!TMP->(Marked("E_OK"))
				Loop
			EndIf
		ENDIF
		
		MsAguarde({|lEnd| },"Aguarde...","Liberando Movimento: "+Alltrim(_aTempZero[nX][02]+DtoC(_aTempZero[nX][03])+_aTempZero[nX][23]),.T.)
		
		DbSelectArea("PAT")
		DbSetOrder(1)

		IF dbSeek(_aTempZero[nX][02]+DTOS(_aTempZero[nX][03])+_aTempZero[nX][24]+_aTempZero[nX][25]+_aTempZero[nX][23]+_aTempZero[nX][26]+_aTempZero[nX][27])
			
			If empty(PAT->PAT_STATUS)
				RecLock("PAT",.F.)
				PAT ->PAT_STATUS := "S"
				MsUnLock()
			EndIf
		EndIf
		
		_nValor += _aTempZero[nX][06] //TMP->E_VALORDIG
		_nDiff  += _aTempZero[nX][11] //TMP->DIFF
		
		If alltrim(_escolha) $ 'R$/CH'
			_cMoeda	:= 'R$'
		Else
			_cMoeda	:= _aTempZero[nX][27] 		// TMP->E_MOEDA
		EndIf
		
		_cDocumen 		:= _aTempZero[nX][02]+DTOS(_aTempZero[nX][03])+_aTempZero[nX][23]+"_"+_aTempZero[nX][25]// TMP->E_FILIAL + DTOS(TMP->E_DATA) + TMP->E_TURNO + '_' +TMP->E_PDV
		_cData 			:= MV_PAR01 			// TMP->E_DATA
		_cBenef 		:= _aTempZero[nX][15] 	// TMP->E_BENEF
		_cHistor	   	:= _aTempZero[nX][16] 	// TMP->E_HISTOR
		_cFilOri	    := _aTempZero[nX][02] 	// TMP->E_FILIAL
		_cDebito	    := _aTempZero[nX][10] 	// TMP->E_DEBITO
		_cNumCheque     := _aTempZero[nX][02] +" "+DTOS(_aTempZero[nX][03]) //TMP->E_FILIAL + ' ' + dtos(TMP->E_DATA)
		_cFilial        := cFilAnt
		
	Next nX
	
	If _nValor <> 0 //!eof()
		
		RecLock("SE5",.t.)
		MsUnLock()
		
		RecLock("SE5",.f.)
		SE5->E5_FILIAL 	    	:= _cFilial
		SE5->E5_DATA 			:= MV_PAR01
		SE5->E5_VALOR 			:= _nValor// + max(_nDiff,0)
		SE5->E5_MOEDA 			:= _cMoeda
		do case
			case alltrim(_escolha) == 'R$'
				SE5->E5_NATUREZ 	:= "DEPOSITO"
				//SE5->E5_TIPODOC		:= 'VL'
			case alltrim(_escolha) == 'CH'
				SE5->E5_NATUREZ 	:= "CHEQUE"
				SE5->E5_TIPODOC		:= 'CH'
			case alltrim(_escolha) == 'FI'
				SE5->E5_NATUREZ 	:= "CHQPRER" // cheque pre a receber
				SE5->E5_TIPODOC		:= 'CH'
		endcase
		
		SE5->E5_BANCO 				:= MV_PAR02
		SE5->E5_AGENCIA 			:= MV_PAR03
		SE5->E5_CONTA 				:= MV_PAR04
		
		SE5->E5_DOCUMEN				:= _cDocumen
		SE5->E5_VENCTO      		:= _cData
		SE5->E5_RECPAG   			:= "R"
		SE5->E5_BENEF 				:= _cBenef
		SE5->E5_HISTOR   			:= _cHistor
		SE5->E5_DTDIGIT				:= MV_PAR01
		SE5->E5_DTDISPO				:= MV_PAR01
		SE5->E5_FILORIG	    		:= _cFilOri
		SE5->E5_MODSPB	    		:= "1"
		SE5->E5_TIPODOC     		:= ''
		SE5->E5_MOTBX       		:= ''
		SE5->E5_RATEIO      		:= 'N'
		SE5->E5_DEBITO      		:= _cDebito
		If _escolha == 'CH'
			SE5->E5_NUMCHE 			:=  _cNumCheque
		EndIf
		
		If _nDiff < 0
			SE5->E5_VLDESCO			:= abs(_nDiff)
			SE5->E5_VLDECRE			:= abs(_nDiff)
		Else
			SE5->E5_VLJUROS			:= _nDiff
			SE5->E5_VLACRES			:= _nDiff
		END
		
		SE5->(MsUnlock())
	EndIf
	
	End Transaction
	
	nValor	:= 0
	nQtdTi	:= 0
	
	// atualizo o array após o processamento dos dados e gravação dos registros na SE5
	//RefreshArray(_aTempZero)
	
ENDIF

RestArea(aArea)

Return NIL

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RefreshArray(_aOri)
//////////////////////////////////////////////////////////

// faço uma copia/backup do array
aCopy := {}
aCopy := aClone(_aOri)

// limpo o array original
_aTemp := {}

nCont := 1

FOR NCOPY := 1 TO LEN(aCOPY)
	
	// mantenho apenas os que não estavam selecionados
	IF ACOPY[NCOPY][01]
		nCont++
	ELSE
		aadd(_aTemp, {ACOPY[NCOPY][01]						,;
		ACOPY[NCOPY][02]									,;
		ACOPY[NCOPY][03]									,;
		ACOPY[NCOPY][04]									,;
		ACOPY[NCOPY][05]									,;
		ACOPY[NCOPY][06]									,;
		ACOPY[NCOPY][07]									,;
		ACOPY[NCOPY][08]									,;
		ACOPY[NCOPY][09]									,;
		ACOPY[NCOPY][10]									,;
		ACOPY[NCOPY][11]									,;
		ACOPY[NCOPY][12]									,;
		ACOPY[NCOPY][13]									,;
		ACOPY[NCOPY][14]									,;
		ACOPY[NCOPY][15]									,;
		ACOPY[NCOPY][16]									,;
		ACOPY[NCOPY][17]									,;
		ACOPY[NCOPY][18]									,;
		ACOPY[NCOPY][19]									,;
		ACOPY[NCOPY][20]									,;
		ACOPY[NCOPY][21]									,;	//QRY->PAT_NUMCFI
		ACOPY[NCOPY][22]									,;
		ACOPY[NCOPY][23]									,;
		ACOPY[NCOPY][24]									,;
		ACOPY[NCOPY][25]									,;
		ACOPY[NCOPY][26]									,;
		ACOPY[NCOPY][27]									,;
		ACOPY[NCOPY][28]									})
		
	ENDIF
	
NEXT nCOPY

oDet:SetArray(_aTemp)
oDet:nAt 		:= 1
//oDet:nRowCount 	:= oDet:nRowCount-nCont
//oDet:nLen		:= oDet:nLen-nCont
oDet:Refresh()

Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fa160display(cMarca,lInverte,oValor,oQtda,lMarcado,lWndZero)
//////////////////////////////////////////////////////////

IF lWndZero
	If lMarcado // IsMark("E_OK",cMarca,lInverte)
		nValorZero += _aTemp[odet:nat][6] //TMP->E_VALORDIG
		nQtdTitZero ++
	Else
		nValorZero  -= _aTemp[odet:nat][6] //TMP->E_VALORDIG
		nQtdTitZero --
		nQtdTitZero := iif(nQtdTitZero<0,0,nQtdTitZero)
	EndIf
	
	oValorZero:Refresh()
	oQtdaZero:Refresh()

ELSE
	If lMarcado // IsMark("E_OK",cMarca,lInverte)
		nValor += _aTemp[odet:nat][6] //TMP->E_VALORDIG
		nQtdTit ++
	Else
		nValor  -= _aTemp[odet:nat][6] //TMP->E_VALORDIG
		nQtdTit --
		nQtdTit := iif(nQtdTit<0,0,nQtdTit)
	EndIf
	
	oValor:Refresh()
	oQtda:Refresh()

ENDIF

Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
static function VALIDPERG1()
///////////////////////////

PutSX1(cPergData,"01","Da Data"			,"Data"			    ,"Data" 			,"mv_ch1","D",08,0,0,"G","",""	 ,"",,"mv_par01","","","","","","","","","","","","","","","","")
PutSX1(cPergData,"02","Ate aData"       ,"Data"     	    ,"Data"    	    	,"mv_ch2","D",08,0,0,"G","",""	 ,"",,"mv_par02","","","","","","","","","","","","","","","","")

return()
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
static function VALIDPERG2()
///////////////////////////

PutSX1(cPergConta,"01","Da Data"		 ,"Data"			,"Data" 		   ,"mv_ch1","D",08,0,0,"G","",""	 ,"",,"mv_par01","","","","","","","","","","","","","","","","")
PutSX1(cPergConta,"02","Banco Portador"  ,"Banco Portador"  ,"Banco Portador"  ,"mv_ch2","C",03,0,0,"G","","SA6"	 ,"",,"mv_par02","","","","","","","","","","","","","","","","")
PutSX1(cPergConta,"03","Agência       "  ,"Agência       "  ,"Agência       "  ,"mv_ch3","C",05,0,0,"G","",""	 ,"",,"mv_par03","","","","","","","","","","","","","","","","")
PutSX1(cPergConta,"04","Conta Corrente"  ,"Conta Corrente"  ,"Conta Corrente"  ,"mv_ch4","C",10,0,0,"G","",""	 ,"",,"mv_par04","","","","","","","","","","","","","","","","")

return()

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
static function VALIDPERG3()
///////////////////////////

PutSX1(cPergImp,"01","Filiais (separadas por virgula)" ,"","" 		   ,"mv_ch1","C",60,0,0,"G","",""	 ,"",,"mv_par01","","","","","","","","","","","","","","","","")

return()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function Imprime()
/////////////////////////

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Integração PDV"
Local cPict         := ""
Local titulo       	:= "Integração PDV"
Local nLin         	:= 80
//					   xxxxxxx xxx xxxxxxxxxx  xxx.xxx.xx     xxx.xxx.xx     xxx.xxx.xx x
Local Cabec1       	:= "Filial PDV Data        Valor Sistema  Valor Digitado  Diferença Turno"
Local Cabec2       	:= ''
Local imprime      	:= .T.
Local aOrd 			:= {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 80
Private tamanho     := "P"
Private nomeprog    := "FINA003" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "FINA003" // Coloque aqui o nome do arquivo usado para impressao em disco
Private Caracter  	:= 15
Private _aAlias     := GetArea()
Private cString 	:= "SB1"
DbSelectArea('SB1')

cPergImp := 'FINA003   '
ValidPerg3()
Pergunte(cPergImp,.t.)
wnrel := SetPrint(cString,NomeProg,cPergImp,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.f.)

If nLastKey == 27
	Return
Endif

fErase(__RelDir + wnrel + '.##r')
SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

RestArea(_aAlias)
Return

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
////////////////////////////////////////////////////

Local nOrdem

DbSelectArea('QRY')
_nRecno := Recno()
Count to _nLastRec
DbGoTop()
_nTotSis := 0
_nTotDig := 0
SetRegua(_nLastRec)
Do While !EOF()
	
	IncRegua()
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	If QRY->PAT_FILIAL $ mv_par01
		
		_cLinha := QRY->PAT_FILIAL + '     '
		_cLinha += right(QRY->PAT_PDV,3) + ' '
		_cLinha += dtoc(stod(QRY->PAT_DTFECH)) + space(iif(len(dtoc(stod(QRY->PAT_DTFECH))) == 8,3,1)) + ' '
		_cLinha += trans(QRY->VALOR,"@E 999,999,999.99") + ' '
		_cLinha += trans(QRY->VALORDIG,"@E 999,999,999.99") + '  '
		_cLinha += trans(QRY->VALOR - QRY->VALORDIG,"@E 999,999.99") + ' '
		_cLinha += QRY->PAT_TURNO
		
		_nTotSis += QRY->VALOR
		_nTotDig += QRY->VALORDIG
		@ ++nlin,00 pSay _cLinha
		
	EndIf
	
	dbSkip()
	
EndDo

_cLinha := trans(_nTotSis,"@E 999,999,999.99") + ' '
_cLinha += trans(_nTotDig,"@E 999,999,999.99") + '  '
_cLinha += trans(_nTotSis-_nTotDig,"@E 999,999.99")

@ ++nlin,23 pSay _cLinha

DbGoTo(_nRecno)

If aReturn[5]==1
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

