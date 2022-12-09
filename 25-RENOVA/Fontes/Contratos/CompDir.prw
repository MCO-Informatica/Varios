#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CompDir  ³ Autor ³ Totvs                 ³ Data ³ 09/11    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Painel para consulta das compras diretas.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Renova                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CompDir(_cContra)

Local _cQuery := ""
Local _nValor := 0
Local lMark   := .F.
Local oOk     := LoadBitmap( GetResources(), "LBOK" )   //CHECKED    //LBOK  //LBTIK
Local oNo     := LoadBitmap( GetResources(), "LBNO" ) //UNCHECKED  //LBNO
Local oChk1
Local oChk2
Local lChk1   := .F.
Local lChk2   := .F.
Local nOpca   := 0
Local _nDesc  := 0
Local aForn   := {}

Private _aItens := {}
Private oLbx
Private oDlg
Private cPic   := PA2->(X3Picture("PA2_SALDO"))


If aArrGrvPA2 == Nil .Or. aArrGrvPA2[1] <> _cContra
	_cQuery := "SELECT * FROM " + RetSqlName("PA2") + " PA2 "
	_cQuery += "WHERE PA2.PA2_FILIAL = '" + xFilial("PA2") + "' AND "
	_cQuery += "PA2.PA2_CONTRA = '" + _cContra + "' AND "
	_cQuery += "PA2.PA2_NUMNFE <> '' AND "
	_cQuery += "(PA2.PA2_USADO = '2' OR PA2.PA2_USADO = '3') AND "
	_cQuery += "PA2.D_E_L_E_T_ = ' '"

	_cQuery := ChangeQuery(_cQuery)
	dbUseArea( .T., 'TOPCONN', TcGenQry( ,, _cQuery ), "TPA2", .F., .T. )

	While TPA2->(!EOF())
		aForn := GetAdvFVal("SA2",{"A2_NOME","A2_CGC"},xFilial("SA2")+TPA2->PA2_FORN+TPA2->PA2_LOJA,1,"")
		aAdd(_aItens, { lMark,;
						TransForm(TPA2->PA2_VALOR,X3Picture("PA2_VALOR")),;
						TransForm(0,X3Picture("PA2_VALOR")),;
						TransForm(TPA2->PA2_SALDO,X3Picture("PA2_SALDO")),;
						TPA2->PA2_NUMPC,;
						TPA2->PA2_ITPC,;
						TPA2->PA2_NUMNFE,;
						TPA2->PA2_SERNFE,;
						TPA2->PA2_FORN+"/"+TPA2->PA2_LOJA,;
						AllTrim(aForn[1]),;
						Transform(aForn[2],X3Picture("A2_CGC"))})
		dbSkip()
	EndDo
	aArrGrvPA2 := {_cContra, _aItens, .F.}
Else
	_aItens := aArrGrvPA2[2]
Endif

If Len( _aItens ) == 0
	Aviso( "U_CompDir", "Nao existem compras diretas para este contrato.", {"Ok"} )
	If Select("TPA2") > 0
		TPA2->(dbCloseArea())
	Endif
 	Return
Endif

DEFINE MSDIALOG oDlg TITLE "Compra Direta" FROM 0,0 TO 240,500 PIXEL

@ 10,10 LISTBOX oLbx FIELDS HEADER ;
   " ", "Valor Compra", "Desconto", "Saldo", "Ped. Compras", "Item Pedido", "Nota Fiscal", "Série NF", "Cod. Fornec", "Nome Fornec", "CNPJ Forn" ;
   SIZE 230,095 OF oDlg PIXEL ON dblClick(PegaVlr()) //dblClick(_aItens[oLbx:nAt,1] := !_aItens[oLbx:nAt,1])

oLbx:SetArray( _aItens )
oLbx:bLine := {|| {Iif(_aItens[oLbx:nAt,1],oOk,oNo),;
                        _aItens[oLbx:nAt,2],;
                        _aItens[oLbx:nAt,3],;
                        _aItens[oLbx:nAt,4],;
                        _aItens[oLbx:nAt,5],;
                        _aItens[oLbx:nAt,6],;
                        _aItens[oLbx:nAt,7],;
                        _aItens[oLbx:nAt,8],;
                        _aItens[oLbx:nAt,9],;
                        _aItens[oLbx:nAt,10],;
                        _aItens[oLbx:nAt,11]}}

DEFINE SBUTTON FROM 107,183 TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oDlg
DEFINE SBUTTON FROM 107,213 TYPE 2 ACTION (nOpca := 0,oDlg:End()) ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTER

If nOpca == 1
	aArrGrvPA2 := {_cContra, _aItens, .T.}
EndIf

If Select("TPA2") > 0
	TPA2->(dbCloseArea())
Endif

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ PegaVlr  ³ Autor ³ Totvs                 ³ Data ³ 09/11    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Digitacao do valor do desconto                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Renova                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PegaVlr()

Local lMark  := _aItens[oLbx:nAt,1]
Local nValor := 0
Local nOpca  := 0
Local nSaldo := 0
Local nValDesc := 0

cSaldo := StrTran(_aItens[oLbx:nAt,4], ".", "")
cSaldo := StrTran(cSaldo, ",", ".")
nSaldo := Val(cSaldo)

If !lMark
	DEFINE MSDIALOG oDlgA FROM  50,4 TO 190,348 TITLE "Valor Desconto" PIXEL
		@ 003,004 TO 48, 170 LABEL "" OF oDlgA  PIXEL
		@ 008,010 SAY "Informe o valor a ser utilizado no desconto." OF oDlgA PIXEL
		@ 034,010 SAY "Valor Desconto: " OF oDlgA PIXEL
		@ 034,055 MsGet nValDesc Picture cPic Valid nValDesc <= nSaldo Size 90,4 OF oDlgA PIXEL

		DEFINE SBUTTON FROM 053, 113 TYPE 1 ACTION ( nOpca:=1,oDlgA:End() ) ENABLE OF oDlgA
		DEFINE SBUTTON FROM 053, 143 TYPE 2 ACTION oDlgA:End() ENABLE OF oDlgA
	ACTIVATE MSDIALOG oDlgA Center

	If nOpca == 1
		nSaldo -= nValDesc
		_aItens[oLbx:nAt,1] := !_aItens[oLbx:nAt,1]
		_aItens[oLbx:nAt,4] := Transform(nSaldo,cPic)
		_aItens[oLbx:nAt,3] := Transform(nValDesc,cPic)
	EndIf
Else
	cValDesc := StrTran(_aItens[oLbx:nAt,3], ".", "")
	cValDesc := StrTran(cValDesc, ",", ".")
	nValDesc := Val(cValDesc)

	nSaldo += nValDesc
	_aItens[oLbx:nAt,1] := !_aItens[oLbx:nAt,1]
	_aItens[oLbx:nAt,4] := Transform(nSaldo,cPic)
	_aItens[oLbx:nAt,3] := Transform(0,cPic)
EndIf

Return

