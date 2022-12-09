#Include "Protheus.ch"
#Include "RwMake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSFATA004  บAutor  ณFelipe Valenca      บ Data ณ  29/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTela de Consulta de Metas                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SFATA004

Local cTitulo 		:= "Cadastro de Metas por Regiใo -= Shangri-la =- "

Private _oBrwPRD
Private _oBrwREG
Private _oBrwVEN

Private _aBrwPRD	:= {}
Private _aBrwREG	:= {}
Private _aBrwVEN	:= {}

Private cCodSBM		:= Space(TamSX3("B1_GRUPO")[1])
Private cDescSBM	:= Space(TamSX3("B1_DESC")[1])

Private oOK := LoadBitmap(GetResources(),'br_verde')
Private oNO := LoadBitmap(GetResources(),'br_vermelho')

Private _cRegOld := ""
Private _cPrdOld := ""

Private _nSomaMet	:= 0
Private _nSomaQtd	:= 0

Private _nMetReg	:= 0
Private _nQtdReg	:= 0
Private _TotPrev	:= 0
Private nTotQtd		:= 0
Private nTotPerc	:= 0

DEFINE FONT oFont5 NAME "Verdana" SIZE 10,20 BOLD

//ESTRUTURA DA TELA
Define MSDialog oDlg From 00,00 To 34,115 Title cTitulo Of oMainWnd

@030,015 Say oEmToAnsi("Grupo") Size 50,08 Of oDlg Pixel
@030,040 MsGet cCodSBM Picture "@!" F3 "SBM" Valid xGetSB1(cCodSBM,@cDescSBM) Size 30,08 Of oDlg Pixel
@030,090 MsGet cDescSBM When .F. Size 140,08 Of oDlg Pixel
@065,393 BUTTON "Concluir Produto" SIZE 50,10 FONT oDlg:oFont ACTION( oDlg:End() ) OF oDlg PIXEL
@155,393 BUTTON "Incluir Vendedor" SIZE 50,10 FONT oDlg:oFont ACTION( oDlg:End() ) OF oDlg PIXEL
@060,387 To 250,450 Of oDlg Pixel

//********************************** XX **********************************//

//TELA COM DADOS DO PRODUTO
@050,170 Say OemToAnsi("Produtos") FONT oFont5 Of oDlg Pixel Color CLR_HBLUE
@060,007 To 130,387 Of oDlg Pixel

If Len(_aBrwPRD) <= 0
	aADD(_aBrwPRD,{'','','',''})
Endif

// Cria Browse
_oBrwPRD := TCBrowse():New(065,012,370,060,,;
							{"C๓digo","Descri็ใo","Quantidade","Percentual"},;
							{},;
							,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
// Seta vetor para a browse                            
_oBrwPRD:SetArray(_aBrwPRD) 
    
// Monta a linha a ser exibina no Browse
_oBrwPRD:bLine := {||{   _aBrwPRD[_oBrwPRD:nAt,01],;
                         _aBrwPRD[_oBrwPRD:nAt,02],;
                         _aBrwPRD[_oBrwPRD:nAt,03],;
                         _aBrwPRD[_oBrwPRD:nAt,04]}}

_oBrwPRD:bLDblClick   := {|| xDuplPRD(_oBrwPRD:ColPos)}  


//********************************** XX **********************************//

//TELA COM DADOS DA REGIAO
@140,075 Say OemToAnsi("Regi๕es") FONT oFont5 Of oDlg Pixel Color CLR_HBLUE
@150,007 To 250,197 Of oDlg Pixel

If Len(_aBrwREG) <= 0
	aADD(_aBrwREG,{.F.,'','','',''})
Endif

// Cria Browse
_oBrwREG := TCBrowse():New(155,012,180,090,,;
							{"","C๓digo","Descri็ใo","Quantidade","Meta"},;
							{10,25,70,30,25},;
							,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
// Seta vetor para a browse                            
_oBrwREG:SetArray(_aBrwREG) 
    
// Monta a linha a ser exibina no Browse
_oBrwREG:bLine := {||{   Iif(_aBrwREG[_oBrwREG:nAt,01],oOk,oNo),;
                         _aBrwREG[_oBrwREG:nAt,02],;
                         _aBrwREG[_oBrwREG:nAt,03],;
                         _aBrwREG[_oBrwREG:nAt,04],;
                         _aBrwREG[_oBrwREG:nAt,05]}}

_oBrwREG:bLDblClick   := {|| xDuplREG(_oBrwREG:ColPos)}  


//********************************** XX **********************************//

//TELA COM DADOS DOS VENDEDORES
@140,260 Say OemToAnsi("Representantes") FONT oFont5 Of oDlg Pixel Color CLR_HBLUE
@150,197 To 250,387 Of oDlg Pixel

If Len(_aBrwVEN) <= 0
	aADD(_aBrwVEN,{.F.,'','','',''})
Endif

// Cria Browse
_oBrwVEN := TCBrowse():New(155,202,180,090,,;
							{"","C๓digo","Nome","Quantidade","Meta"},;
							{10,25,70,30,25},;
							,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
// Seta vetor para a browse                            
_oBrwVEN:SetArray(_aBrwVEN) 
    
// Monta a linha a ser exibina no Browse
_oBrwVEN:bLine := {||{  Iif(_aBrwVEN[_oBrwVEN:nAt,01],oOk,oNo),;
                        _aBrwVEN[_oBrwVEN:nAt,02],;
                        _aBrwVEN[_oBrwVEN:nAt,03],;
                        _aBrwVEN[_oBrwVEN:nAt,04],;
                        _aBrwVEN[_oBrwVEN:nAt,05]}}

_oBrwVEN:bLDblClick   := {|| xDuplVEN(_oBrwVEN:ColPos)}  

Activate MSDialog oDlg Centered On Init EnchoiceBar(oDlg,{|| oDlg:End()},{|| oDlg:End() })

Return


// BUSCA O PRODUTO DE ACORDO COM O INDICE E PARAMETRO ESPECIFICADO
Static Function xGetSB1(cCodSBM)

Local _aArea		:= GetArea()

dbSelectArea("SBM")
dbSetOrder(1)
If !dbSeek(xFilial("SBM")+cCodSBM,.F.)
	MsgAlert("Grupo de Produtos nใo encontrado.","Atencao!")
Else
	cDescSBM := BM_DESC
Endif
RestArea(_aArea)

_aBrwPRD := {}

cQrySB1 := "Select B1_COD,B1_DESC From "+RetSqlName("SB1")+" "
cQrySB1 += "Where D_E_L_E_T_ = ' ' And B1_GRUPO = '"+cCodSBM+"' "
cQrySB1 += "ORDER BY B1_COD "

If Select("_SB1") > 0
	_SB1->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQrySB1),"_SB1",.F.,.T.) 

dbSelectArea("_SB1")
dbGoTop()

Do While !_SB1->(Eof()) 
	Aadd(_aBrwPRD,{B1_COD,B1_DESC,'',''})
	_SB1->(dbSkip())
EndDo

If Len(_aBrwPRD) <= 0
	MsgAlert("Nenhum produto cadastrado com esse grupo.","Atencao!")
Endif

// Seta vetor para a browse                            
_oBrwPRD:SetArray(_aBrwPRD) 
	    
// Monta a linha a ser exibina no Browse
_oBrwPRD:bLine := {||{  _aBrwPRD[_oBrwPRD:nAt,01],;
                        _aBrwPRD[_oBrwPRD:nAt,02],;
                        _aBrwPRD[_oBrwPRD:nAt,03],;
                        _aBrwPRD[_oBrwPRD:nAt,04]}}


_oBrwPRD:Refresh()

Return

//********************************** XX **********************************//

// FUNCAO PARA TRAZER AS REGIOES
Static Function xGetREG(_CodProd)

Default _CodProd := ""

_cRegOld := ""

If Empty(_cPrdOld)
	_cPrdOld := _CodProd
Endif

If _cPrdOld <> _aBrwPRD[_oBrwPRD:nAt,01]
	If MsgYesNo("Deseja salvar as altera็๕es do produto ?","Aten็ใo!")
		Alert("Nesse momento o sistema grava as altera็๕es do Produto.")
	Endif
	_cPrdOld := _aBrwPRD[_oBrwPRD:nAt,01]
Endif


/*cQrySZ4 := "Select Z4_COD, Z4_DESC, Z4_META From "+RetSqlName("SZ4")+" "
cQrySZ4 += "Where D_E_L_E_T_ = ' ' "
cQrySZ4 += "Order By Z4_COD " */

cQrySZ4 := "Select Z5_CODREG, Z5_NOMREG, Z5_QTDREG, Z4_META from "+RetSqlName("SZ4")+" Z4 "
cQrySZ4 += "Inner Join "+RetSqlName("SZ5")+" Z5 On Z5.D_E_L_E_T_ = ' ' "
cQrySZ4 += " And Z5_FILIAL = Z4_FILIAL "
cQrySZ4 += " And Z5_CODREG = Z4_COD "
cQrySZ4 += "Where Z4.D_E_L_E_T_ = ' ' "
cQrySZ4 += " And Z5_COD = '"+_CodProd+"' "

If Select("_SZ4") > 0
	_SZ4->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQrySZ4),"_SZ4",.F.,.T.) 

dbSelectArea("_SZ4")
dbGoTop()

_aBrwREG := {}

Do While !_SZ4->(Eof())
	Aadd(_aBrwREG,{.T.,Z5_CODREG,Z5_NOMREG,Z5_QTDREG,Z4_META})
	_nQtdReg += _SZ4->Z5_QTDREG
	_nMetReg += _SZ4->Z4_META	
	_SZ4->(dbSkip())
EndDo
//TOTAL DE METAS DA REGIAO
Aadd(_aBrwREG,{Iif(_nMetReg=100,.T.,.F.),"TOTAL",,_nQtdReg,_nMetReg})
_nQtdReg := 0
_nMetReg := 0
// Seta vetor para a browse                            
_oBrwREG:SetArray(_aBrwREG) 
	    
// Monta a linha a ser exibina no Browse
_oBrwREG:bLine := {||{  Iif(_aBrwREG[_oBrwREG:nAt,01],oOk,oNo),;
                        _aBrwREG[_oBrwREG:nAt,02],;
                        _aBrwREG[_oBrwREG:nAt,03],;
                        _aBrwREG[_oBrwREG:nAt,04],;
                        _aBrwREG[_oBrwREG:nAt,05]}}

_oBrwREG:Refresh()

Return

//********************************** XX **********************************//

// FUNCAO PARA TRAZER OS REPRESENTANTES
Static Function xGetVEN(_cRegiao)

Local nQtdVen	:= 0
Local nPercVen	:= 0

Local cCodVen	:= ""
Local cNomVend	:= ""

If Empty(_cRegOld)
	_cRegOld := _cRegiao
Endif

If _cRegOld <> _cRegiao
	If MsgYesNo("Deseja salvar as altera็๕es dos representantes ?","Aten็ใo!")
		Alert("Nesse momento o sistema grava as altera็๕es dos representantes.")
	Endif
	_cRegOld := _cRegiao	
Endif

cQrySZ5 := "Select * From "+RetSqlName("SZ5")+" "
cQrySZ5 += "Where D_E_L_E_T_ = ' ' And Z5_CODREG = '"+_cRegiao+"' "
cQrySZ5 += "Order By Z5_CODVEN "

If Select("_SZ5") > 0
	_SZ5->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQrySZ5),"_SZ5",.F.,.T.) 

dbSelectArea("_SZ5")
dbGoTop()

_aBrwVEN := {}
Do While !_SZ5->(Eof())
    cVendedor := _SZ5->Z5_CODVEN
    Do While !_SZ5->(Eof()) .And. cVendedor == _SZ5->Z5_CODVEN
		cCodVen		:= Z5_CODVEN
		cNomVend	:= Z5_NOMVEND
		nQtdVen 	+= Z5_QTDVEN
		nPercVen	+= Z5_PERCVEN
		
		nTotQtd		+= Z5_QTDVEN
		nTotPerc	+= Z5_PERCVEN
	
		_SZ5->(dbSkip())
    EndDo
    Aadd(_aBrwVEN,{.T.,cCodVen,cNomVend,nQtdVen,nPercVen})
    nPercVen := 0
    nQtdVen	 := 0
EndDo
//TOTAL
Aadd(_aBrwVEN,{Iif(nTotPerc=100,.T.,.F.),"TOTAL",,nTotQtd,nTotPerc})
nTotQtd		:= 0
nTotPerc	:= 0

// Seta vetor para a browse                            
_oBrwVEN:SetArray(_aBrwVEN) 
	    
// Monta a linha a ser exibina no Browse
_oBrwVEN:bLine := {||{  Iif(_aBrwVEN[_oBrwVEN:nAt,01],oOk,oNo),;
                        _aBrwVEN[_oBrwVEN:nAt,02],;
                        _aBrwVEN[_oBrwVEN:nAt,03],;
                        _aBrwVEN[_oBrwVEN:nAt,04],;
                        _aBrwVEN[_oBrwVEN:nAt,05]}}

_oBrwVEN:Refresh()

Return

//ROTINA PARA VALIDAR O DUPLO CLICK DA REGIAO
Static Function xDuplPRD(_xColuna)

If _xColuna == 1
	xDeletePRD(_aBrwREG[_oBrwREG:nAt,01])
ElseIf _xColuna == 4
	xStatusPRD(lEditCell( @_aBrwREG, _oBrwREG,"@E 999,999,999", _oBrwREG:ColPos,,,))
Else
	xGetREG(_aBrwPRD[_oBrwPRD:nAt,01])
Endif

Return


//ROTINA PARA VALIDAR O DUPLO CLICK DA REGIAO
Static Function xDuplREG(_xColuna)

If _xColuna == 1
	xDeleteREG(_aBrwREG[_oBrwREG:nAt,01])
ElseIf _xColuna == 4
	xStatusREG(lEditCell( @_aBrwREG, _oBrwREG,"@E 999,999,999", _oBrwREG:ColPos,,,))
Else
	xGetVEN(_aBrwREG[_oBrwREG:nAt,02])
Endif

Return

//ROTINA PARA VALIDAR O DUPLO CLICK DO REPRESENTANTE
Static Function xDuplVEN(_xColuna)

If _xColuna == 1
	xDeleteVEN(_aBrwVEN[_oBrwVEN:nAt,01])
ElseIf _xColuna == 4
	xStatusVEN(lEditCell( @_aBrwVEN, _oBrwVEN,"@E 999,999,999", _oBrwVEN:ColPos,,,))
Endif

Return



//ROTINA PARA VALIDAR ITENS DELETADOS DA REGIAO
Static Function xDeleteREG(_lStatus)

_nSomaMet := 0
_nSomaQtd := 0

If _oBrwREG:nAt <> Len(_aBrwREG)
	If _lStatus == .T.
		_aBrwREG[_oBrwREG:nAt,01] := .F.
		xStatusREG()
	Else
		_aBrwREG[_oBrwREG:nAt,01] := .T.
		xStatusREG()
	Endif
Endif

Return 
                                               

//ROTINA PARA VALIDAR ITENS DELETADOS DO REPRESENTANTE
Static Function xDeleteVEN(_lStatus)

_nSomaMet := 0
_nSomaQtd := 0

If _oBrwVEN:nAt <> Len(_aBrwVEN)
	If _lStatus == .T.
		_aBrwVEN[_oBrwVEN:nAt,01] := .F.
		xStatusVEN()
	Else
		_aBrwVEN[_oBrwVEN:nAt,01] := .T.
		xStatusVEN()
	Endif
Endif

Return 


//ROTINA PARA VALIDAR O STATUS DA BOLINHA PARA REGIAO
Static Function xStatusREG

_nSomaMet := 0
_nSomaQtd := 0
For _nY := 1 to Len(_aBrwREG)-1
	If _aBrwREG[_nY,01] == .T.
		_nSomaQtd += _aBrwREG[_nY][4]	
		_nSomaMet += _aBrwREG[_nY][5]	
	Endif
Next

_aBrwREG[Len(_aBrwREG)][4] := _nSomaQtd
_aBrwREG[Len(_aBrwREG),05] := _nSomaMet

If _nSomaMet <> 100
	_aBrwREG[Len(_aBrwREG),01] := .F.
Else
	_aBrwREG[Len(_aBrwREG),01] := .T.
Endif
_oBrwREG:Refresh()

Return


//ROTINA PARA VALIDAR O STATUS DA BOLINHA PARA REPRESENTANTE
Static Function xStatusVEN

_nSomaMet := 0
_nSomaQtd := 0
For _nY := 1 to Len(_aBrwVEN)-1
	If _aBrwVEN[_nY,01] == .T.
		_nSomaQtd += _aBrwVEN[_nY][4]	
		_nSomaMet += _aBrwVEN[_nY][5]	
	Endif
Next

_aBrwVEN[Len(_aBrwVEN)][4] := _nSomaQtd
_aBrwVEN[Len(_aBrwVEN),05] := _nSomaMet

If _nSomaMet <> 100
	_aBrwVEN[Len(_aBrwVEN),01] := .F.
Else
	_aBrwVEN[Len(_aBrwVEN),01] := .T.
Endif
_oBrwVEN:Refresh()

Return