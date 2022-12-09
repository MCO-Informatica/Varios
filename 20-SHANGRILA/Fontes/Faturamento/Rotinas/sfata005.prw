#Include "Protheus.ch"
#Include "RwMake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SFATA005  ºAutor  ³Felipe Valenca      º Data ³  29/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Tela de Consulta de Metas                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SFATA005

Local cTitulo 		:= "Cadastro de Metas por Região -= Shangri-la =- "

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
Private cProduto := ""
Private _cReg	 := ""

Private _nSomaMet	:= 0
Private _nSomaQtd	:= 0

Private _cRegiao	:= ""
Private lPassou		:= .F.

Private _nMetVen	:= 0
Private _nQtdVen	:= 0
Private _TotPrev	:= 0
Private nTotQtd		:= 0
Private nTotPerc	:= 0
Private _nQtdVenTot := 0
Private _nMetVenTot := 0
Private _nPercVen	:= 0
Private nAlt		:= 0
Private _nQtdReg	:= 0
Private cPerg		:= PADR("SFATA005",LEN(SX1->X1_GRUPO))
Private cMes		:= ""
Private nAno		:= 0
DEFINE FONT oFont5 NAME "Verdana" SIZE 10,20 BOLD

ValidPerg()

If !pergunte(cPerg,.T.)
	Return
Endif

cMes := MesExtenso(Month(MV_PAR01))
nAno := YEAR(MV_PAR01) 
//ESTRUTURA DA TELA
Define MSDialog oDlg From 00,00 To 34,99 Title cTitulo Of oMainWnd

@030,015 Say oEmToAnsi("Grupo") Size 50,08 Of oDlg Pixel
@030,040 MsGet cCodSBM Picture "@!" F3 "SBM" Valid xGetSB1(cCodSBM,@cDescSBM) Size 30,08 Of oDlg Pixel
@030,090 MsGet cDescSBM When .F. Size 140,08 Of oDlg Pixel
@030,315 Say OemToAnsi(cMes+"/"+Transform(nAno,"@E 9999")) FONT oFont5 Of oDlg Pixel Color CLR_HRED
//@025,270 BUTTON "Incluir Vendedor" SIZE 50,10 FONT oDlg:oFont ACTION( IncVend() ) OF oDlg PIXEL
//********************************** XX **********************************//

//TELA COM DADOS DO PRODUTO
@050,170 Say OemToAnsi("Produtos") FONT oFont5 Of oDlg Pixel Color CLR_HBLUE
@060,007 To 130,387 Of oDlg Pixel

If Len(_aBrwPRD) <= 0
	aADD(_aBrwPRD,{'','',''})
Endif

// Cria Browse
_oBrwPRD := TCBrowse():New(065,012,370,060,,;
							{"Código","Descrição","Quantidade"},;
							{},;
							,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
// Seta vetor para a browse                            
_oBrwPRD:SetArray(_aBrwPRD) 
    
// Monta a linha a ser exibina no Browse
_oBrwPRD:bLine := {||{   _aBrwPRD[_oBrwPRD:nAt,01],;
                         _aBrwPRD[_oBrwPRD:nAt,02],;
                         _aBrwPRD[_oBrwPRD:nAt,03]}}

_oBrwPRD:bLDblClick   := {|| xDuplPRD(_oBrwPRD:ColPos)}  


//********************************** XX **********************************//

//TELA COM DADOS DA REGIAO
@140,075 Say OemToAnsi(cProduto) FONT oFont5 Of oDlg Pixel Color CLR_HBLUE
@150,007 To 250,387 Of oDlg Pixel

If Len(_aBrwREG) <= 0
	aADD(_aBrwREG,{.F.,'','','','','','','',''})
Endif

// Cria Browse
_oBrwREG := TCBrowse():New(155,012,370,090,,;
							{"","Código","Descrição","Regiao","Qtd Regiao","Perc. Regiao","Vendedor","Qtd Vendedor","Perc. Vendedor"},;
							{10,30,80,60,35,15,50,35,15},;
							,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

// Seta vetor para a browse                            
_oBrwREG:SetArray(_aBrwREG) 
    
// Monta a linha a ser exibina no Browse
_oBrwREG:bLine := {||{   Iif(_aBrwREG[_oBrwREG:nAt,01],oOk,oNo),;
                         _aBrwREG[_oBrwREG:nAt,02],;
                         _aBrwREG[_oBrwREG:nAt,03],;
                         _aBrwREG[_oBrwREG:nAt,04],;
                         _aBrwREG[_oBrwREG:nAt,05],;
                         _aBrwREG[_oBrwREG:nAt,06],;
                         _aBrwREG[_oBrwREG:nAt,07],;
                         _aBrwREG[_oBrwREG:nAt,08],;
                         Transform(_aBrwREG[_oBrwREG:nAt,09],"@E 999.99")}}

_oBrwREG:bLDblClick   := {|| xDuplREG(_oBrwREG:ColPos,_aBrwREG[_oBrwREG:nAt,02])}  


//********************************** XX **********************************//

Activate MSDialog oDlg Centered On Init EnchoiceBar(oDlg,{|| Iif(xGravaOk(),oDlg:End(),.F.)},{|| oDlg:End() })

Return


// BUSCA O PRODUTO DE ACORDO COM O3 INDICE E PARAMETRO ESPECIFICADO
Static Function xGetSB1(cCodSBM)

Local _aArea		:= GetArea()

dbSelectArea("SBM")
dbSetOrder(1)
If !dbSeek(xFilial("SBM")+cCodSBM,.F.)
	MsgAlert("Grupo de Produtos não encontrado.","Atencao!")
Else
	cDescSBM := BM_DESC
Endif
RestArea(_aArea)

_aBrwPRD := {}

cQrySB1 := "Select B1_COD,B1_DESC,Z5_QTDPRO From "+RetSqlName("SB1")+" B1 "
cQrySB1 += "Inner Join SZ5010 Z5 On Z5.D_E_L_E_T_ = ' ' "
cQrySB1 += "And Z5_COD = B1_COD "
cQrySB1 += "Where B1.D_E_L_E_T_ = ' ' And B1_GRUPO = '"+cCodSBM+"' "
cQrySB1 += "Group By B1_COD,B1_DESC,Z5_QTDPRO "
cQrySB1 += "ORDER BY B1_COD "

If Select("_SB1") > 0
	_SB1->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQrySB1),"_SB1",.F.,.T.) 

dbSelectArea("_SB1")
dbGoTop()

Do While !_SB1->(Eof()) 
	Aadd(_aBrwPRD,{B1_COD,B1_DESC,Z5_QTDPRO})
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
                        _aBrwPRD[_oBrwPRD:nAt,03]}}


_oBrwPRD:Refresh()

Return

//********************************** XX **********************************//

// FUNCAO PARA TRAZER AS REGIOES
Static Function xGetREG(_CodProd)

Local _nTotMet := 0
Default _CodProd := ""

_cRegOld := ""

If Empty(_cPrdOld)
	_cPrdOld := _CodProd
Endif

If _cPrdOld <> _aBrwPRD[_oBrwPRD:nAt,01]
	If MsgYesNo("Deseja salvar as alterações do produto ?","Atenção!")
		Alert("Nesse momento o sistema grava as alterações do Produto.")
	Endif
	_cPrdOld := _aBrwPRD[_oBrwPRD:nAt,01]
Endif


cQrySZ4 := "Select Z5_COD, Z5_DESC, Z5_NOMREG, Z5_QTDREG, Z5_PERCREG, Z5_NOMVEND, Z5_QTDVEN, Z5_PERCVEN,Z5_CODREG From "+RetSqlName("SZ5")+" "
cQrySZ4 += "Where D_E_L_E_T_ = ' ' "
cQrySZ4 += "And Z5_COD = '"+_CodProd+"' "
cQrySZ4 += "Order By Z5_COD "


If Select("_SZ4") > 0
	_SZ4->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQrySZ4),"_SZ4",.F.,.T.) 

dbSelectArea("_SZ4")
dbGoTop()

cProduto := Posicione("SB1",1,xFilial("SB1")+_CodProd,"B1_DESC")
@140,115 Say OemToAnsi(cProduto) FONT oFont5 Of oDlg Pixel Color CLR_HBLUE
_aBrwREG := {}
Do While !_SZ4->(Eof())
	_cReg := Z5_CODREG
	_nTotMet := xCalcMet(_CodProd,_cReg)
	Do While !_SZ4->(Eof()) .And. _cReg == Z5_CODREG
		Aadd(_aBrwREG,{.T.,Alltrim(Z5_COD), Alltrim(Z5_DESC), Alltrim(Z5_NOMREG), Z5_QTDREG, Z5_PERCREG, Alltrim(Z5_NOMVEND), Z5_QTDVEN, Round(((Z5_QTDVEN/_nTotMet)*100),0)})
		_nQtdVen += _SZ4->Z5_QTDVEN
		_nMetVen += _SZ4->Z5_PERCVEN
		_nQtdVenTot += _SZ4->Z5_QTDVEN

		_nPercVen := _SZ4->Z5_PERCREG
		_SZ4->(dbSkip())
	EndDo
	//TOTAL DE METAS DA REGIAO
	Aadd(_aBrwREG,{Iif((_nQtdVen=_aBrwPRD[_oBrwPRD:nAt,03]*(_nPercVen/100)),.T.,.F.),"TOTAL",,,,,,_nQtdVen,_nMetVen})	

	_nQtdVen := 0
	_nMetVen := 0
EndDo
//TOTAL GERAL DE METAS DA REGIAO
Aadd(_aBrwREG,{Iif(_nQtdVenTot=_aBrwPRD[_oBrwPRD:nAt,03],.T.,.F.),"TOTAL",,,,,,_nQtdVenTot,})	
_nQtdVenTot := 0


// Seta vetor para a browse                            
_oBrwREG:SetArray(_aBrwREG) 
	    
// Monta a linha a ser exibina no Browse
_oBrwREG:bLine := {||{  Iif(_aBrwREG[_oBrwREG:nAt,01],oOk,oNo),;
                        _aBrwREG[_oBrwREG:nAt,02],;
                        _aBrwREG[_oBrwREG:nAt,03],;
                        _aBrwREG[_oBrwREG:nAt,04],;
                        _aBrwREG[_oBrwREG:nAt,05],;
                        _aBrwREG[_oBrwREG:nAt,06],;
                        _aBrwREG[_oBrwREG:nAt,07],;
                        _aBrwREG[_oBrwREG:nAt,08],;
                        Transform(_aBrwREG[_oBrwREG:nAt,09],"@E 999.99")}}

_oBrwREG:Refresh()

Return

//********************************** XX **********************************//


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
Static Function xDuplREG(_xColuna,_xColuna2)

If _xColuna == 1
	xDeleteREG(_aBrwREG[_oBrwREG:nAt,01])
ElseIf _xColuna == 8 .And. _xColuna2 <> "TOTAL"
	xStatusREG(lEditCell( @_aBrwREG, _oBrwREG,"@E 999,999,999", _oBrwREG:ColPos,,,))
Endif

Return


//ROTINA PARA VALIDAR ITENS DELETADOS DA REGIAO
Static Function xDeleteREG(_lStatus)

_nSomaMet := 0
_nSomaQtd := 0

If _aBrwREG[_oBrwREG:nAt,02] <> "TOTAL"
	If _lStatus == .T.
		_aBrwREG[_oBrwREG:nAt,01] := .F.
		_aBrwREG[_oBrwREG:nAt,09] := 0
		xStatusREG()
	Else
		_aBrwREG[_oBrwREG:nAt,01] := .T.
		xStatusREG()
	Endif
Endif

Return 
                                               

//ROTINA PARA VALIDAR O STATUS DA BOLINHA PARA REGIAO
Static Function xStatusREG

Local nTotLin		:= 0
Local _nTotalGer	:= 0
Local _nSQtdVen		:= 0
Local nQtdAnt		:= 0
_nSomaMet := 0
_nSomaQtd := 0

cIndice  := _aBrwREG[_oBrwREG:nAt,04]

For _nX := _oBrwREG:nAt to Len(_aBrwREG)
	if(_aBrwREG[_nX,02] == "TOTAL")
		nTotLin := _nX
		Exit
	Endif
Next

For _xCont := 1 to Len(_aBrwREG)
	If cIndice == _aBrwREG[_xCont,04] 
		If _aBrwREG[_xCont,01] == .T.
			If(_aBrwREG[_xCont,02] <> "TOTAL")
				_nSQtdVen += _aBrwREG[_xCont,08]
			Endif
		Endif
	Endif
Next


For _nY := 1 to Len(_aBrwREG)

	If cIndice == _aBrwREG[_nY,04] 
		_aBrwREG[_nY,05] := _nSQtdVen
		If _aBrwREG[_nY,01] == .T.

	
			If !Empty(_aBrwREG[_nY,05])
				//_aBrwREG[_nY,09] := Round((_aBrwREG[_nY,08]/_aBrwREG[_nY,05])*100,0)                     
				_aBrwREG[_nY,09] := (_aBrwREG[_nY,08]/_aBrwREG[_nY,05])*100
			Endif

			_nSomaQtd += _aBrwREG[_nY][8]	
			_nSomaMet += (_aBrwREG[_nY,08]/_aBrwREG[_nY,05])*100//Round((_aBrwREG[_nY,08]/_aBrwREG[_nY,05])*100,0)                     //_aBrwREG[_nY,09]
		Endif
	Endif
Next

_nSQtdVen := 0

For _nZ := 1 to Len(_aBrwREG)

	If _aBrwREG[_nZ,02] <> "TOTAL" .And. _aBrwREG[_nZ,01] == .T.
		_nTotalGer += _aBrwREG[_nZ][8]	
	Endif
Next

_aBrwREG[nTotLin,08] := _nSomaQtd
_aBrwREG[nTotLin,09] := _nSomaMet
_aBrwREG[Len(_aBrwREG),08] := _nTotalGer

_nTotalGer := 0

If _nSomaMet <> 100
	_aBrwREG[nTotLin,01] := .F.
Else
	_aBrwREG[nTotLin,01] := .T.
Endif

If _aBrwREG[Len(_aBrwREG),08] <> _aBrwPRD[_oBrwPRD:nAt,03]
	_aBrwREG[Len(_aBrwREG),01] := .F.
Else
	_aBrwREG[Len(_aBrwREG),01] := .T.
Endif                                                                          

//Tratamento para divisão de itens por região
nQtdAnt := _aBrwREG[nTotLin,08]
If _cRegiao <> _aBrwREG[_oBrwREG:nAt,04]
	If lPassou

		If _aBrwREG[nAlt-1,05]<>(_aBrwREG[nAlt-1,06]/100)*_aBrwPRD[_oBrwPRD:nAt,03]//_aBrwREG[nAlt,01] == .F.
        	If MsgYesNo("O Total não esta 100%, deseja dividir a quantidade pelos itens da região "+_cRegiao + " ?")
        		Alert("Grava os dados na tabela")
        	Else
// CALCULO DE QUANTIDADE E METAS QUANDO MUDAR DE REGIAO
				
        		For _nP := 1 to Len(_aBrwREG)

        			If _aBrwREG[_nP,04] == _cRegiao 
        				_aBrwREG[_nP,05] := _aBrwREG[nAlt,08] //nQtdAnt
        				_aBrwREG[nAlt,01] := .T.
        				
						If _aBrwREG[_nP,01] == .T.	
//        					_aBrwREG[_nP,09] := Round((_aBrwREG[_nP,08]/_aBrwREG[_nP,05])*100,0)
							_aBrwREG[_nP,09] := (_aBrwREG[_nP,08]/_aBrwREG[_nP,05])*100
			   			Endif
        			Else
						
						If _aBrwREG[_nP,02] == "TOTAL"
							If _aBrwREG[_nP-1,02] <> "TOTAL"
//								_aBrwREG[_nP,09] := Round((_aBrwREG[_nP,08]/_aBrwREG[_nP-1,05])*100,0)//_nSomaMet
								_aBrwREG[_nP,09] := (_aBrwREG[_nP,08]/_aBrwREG[_nP-1,05])*100//_nSomaMet
							Endif
	                    Else
		                    If _aBrwREG[_nP,01] == .T.	
			                    //_aBrwREG[_nP,09] := Round((_aBrwREG[_nP,08]/_aBrwREG[_nP,05])*100,0)
			                    _aBrwREG[_nP,09] := (_aBrwREG[_nP,08]/_aBrwREG[_nP,05])*100
		                    Endif
	                    Endif
        			Endif
	    
        		Next
  				_nSomaMet := 0
				_nSomaQtd := 0        			        		
        	Endif
		Else

		Endif
	Endif

	nAlt := nTotLin
	lPassou := .T.
	_cRegiao := _aBrwREG[_oBrwREG:nAt,04]
Else



Endif 


_oBrwREG:Refresh()

Return


Return


Static Function xCalcMet(_CodProd,_cReg)

Local nRet	:= 0
Local _aArea := GetArea()
cQryMet := "Select SUM(Z5_QTDVEN) TOTVEN From "+RetSqlName("SZ5")+" "
cQryMet += "Where D_E_L_E_T_ = ' ' "
cQryMet += "And Z5_COD = '"+_CodProd+"' AND Z5_CODREG = '"+_cReg+"' "
cQryMet += "Order By Z5_COD "

If Select("_MET") > 0
	_MET->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQryMet),"_MET",.F.,.T.) 

nRet := _MET->TOTVEN
RestArea(_aArea)
Return nRet


Static Function xGravaOK
Local lReturn 	:= .F.
Local _aArea	:= GetArea()
Local cSeq		:= "000"
Local cDoc		:= ""
If _aBrwREG[Len(_aBrwREG),08] == _aBrwPRD[_oBrwPRD:nAt,03]
	dbSelectArea("SCT")
	dbSetOrder(4)
	If !dbSeek(xFilial("SCT")+DtoS(MV_PAR01)+cCodSBM+_aBrwPRD[_oBrwPRD:nAt,01],.F.)
		For nX := 1 to Len(_aBrwREG)
			If _aBrwREG[nX,02] <> "TOTAL"
				If _aBrwREG[nX,01] == .T.
					cSeq := Soma1(cSeq)
					RecLock("SCT",.T.)
					SCT->CT_FILIAL 	:= xFilial("SCT")
					SCT->CT_DOC		:= "SFATA005"
					SCT->CT_DESCRI	:= "METAS ROTINA AUTOMATICA"
					SCT->CT_SEQUEN	:= cSeq
					SCT->CT_REGIAO	:= Posicione("SZ4",2,xFilial("SZ4")+_aBrwREG[nX,04],"Z4_COD")
					SCT->CT_VEND	:= Posicione("SA3",11,xFilial("SA3")+_aBrwREG[nX,07],"A3_COD")
					SCT->CT_DATA	:= MV_PAR01
					SCT->CT_GRUPO	:= cCodSBM
					SCT->CT_TIPO	:= Posicione("SB1",1,xFilial("SB1")+_aBrwPRD[_oBrwPRD:nAt,01],"B1_TIPO")
					SCT->CT_PRODUTO	:= _aBrwPRD[_oBrwPRD:nAt,01]
	                SCT->CT_QUANT	:= _aBrwREG[nX,08]
					MsUnlock()
				Endif
			Endif
		Next
	Else
		If MsgYesNo("Metas ja existente para essa data! Deseja alterar ?","Atencao!")
			cQry := "UPDATE SCT010 SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ WHERE D_E_L_E_T_ = ' ' AND CT_DOC = '"+SCT->CT_DOC+"' "
			cQry += "AND CT_GRUPO = '"+cCodSBM+"' AND CT_PRODUTO = '"+_aBrwPRD[_oBrwPRD:nAt,01]+"' "
			TcSqlExec(cQry)

			For nX := 1 to Len(_aBrwREG)
				If _aBrwREG[nX,02] <> "TOTAL"
					If _aBrwREG[nX,01] == .T.
						cSeq := Soma1(cSeq)
						RecLock("SCT",.T.)
						SCT->CT_FILIAL 	:= xFilial("SCT")
						SCT->CT_DOC		:= "SFATA005"
						SCT->CT_DESCRI	:= "METAS ROTINA AUTOMATICA"
						SCT->CT_SEQUEN	:= cSeq
						SCT->CT_REGIAO	:= Posicione("SZ4",2,xFilial("SZ4")+_aBrwREG[nX,04],"Z4_COD")
						SCT->CT_VEND	:= Posicione("SA3",11,xFilial("SA3")+_aBrwREG[nX,07],"A3_COD")
						SCT->CT_DATA	:= MV_PAR01
						SCT->CT_GRUPO	:= cCodSBM
						SCT->CT_TIPO	:= Posicione("SB1",1,xFilial("SB1")+_aBrwPRD[_oBrwPRD:nAt,01],"B1_TIPO")
						SCT->CT_PRODUTO	:= _aBrwPRD[_oBrwPRD:nAt,01]
		                SCT->CT_QUANT	:= _aBrwREG[nX,08]
						MsUnlock()
					Endif
				Endif
			Next
		Endif
	Endif
	lReturn := .T.
Else
	Alert("A Quantidade de Meta do produto não corresponde.")
Endif

Return lReturn


*---------------------------------*
Static Function ValidPerg()
*---------------------------------*

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

DBSelectArea("SX1") ; DBSetOrder(1)
cPerg := PADR(cPerg,10)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cperg,"01","Qual mes ?"				,"","","mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			EndIf
		Next
		MsUnlock()
		
		
	EndIf
Next

dBSelectArea(_sAlias)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IncVend  ºAutor  ³Felipe Valenca      º Data ³  29/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inclui Vendedor na tela de metas.                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function IncVend()

Private _cVend		:= Space(6)
Private _cLoja		:= Space(2)
Private _cNomeVend	:= Space(30)
Private _cCodReg	:= Space(4)
Private _cDescReg	:= Space(20)
Private _oDlg

DEFINE MSDIALOG _oDlg FROM 015,015 TO 240,515 TITLE "Incluir Vendedor" OF oMainWnd PIXEL
@ 018,007 TO 055, 245 LABEL "Informe o Vendedor" OF _oDlg	PIXEL

@ 030,016 SAY   "Vendedor" OF _oDlg PIXEL SIZE 038,006
@ 040,015 MSGET _cVend  PICTURE "@!" F3 "SA3" VALID xGetVend(_cVend,@_cNomeVend) OF _oDlg PIXEL SIZE 040,006

@ 030,071 SAY   "Nome" OF _oDlg PIXEL SIZE 038,006
@ 040,070 MSGET _cNomeVend  PICTURE "@!" WHEN .F. OF _oDlg PIXEL SIZE 135,006

@ 060,007 TO 097, 245 LABEL "Informe a Regiao" OF _oDlg	PIXEL

@ 072,016 SAY   "Regiao" OF _oDlg PIXEL SIZE 016,006
@ 082,015 MSGET _cCodReg  PICTURE "@!" F3 "SZ4" VALID xGetRegi(_cCodReg,@_cDescReg) OF _oDlg PIXEL SIZE 040,006

@ 072,071 SAY   "Descricao" OF _oDlg PIXEL SIZE 48,006
@ 082,070 MSGET _cDescReg  PICTURE "@!" OF _oDlg PIXEL SIZE 135,006

ACTIVATE MSDIALOG _oDlg ON INIT EnchoiceBar( _oDlg, { || Processa( {|| xReload()},"Inserindo Vendedor..."  ),_oDlg:End()}, {||_oDlg:End()},,) CENTERED	

Return


Static Function xGetVend(_cVend)

_cNomeVend := Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_NOME")

Return .T.

Static Function xGetRegi(_cCodReg)

_cDescReg := Posicione("SZ4",1,xFilial("SZ4")+_cCodReg,"Z4_DESC")

Return .T.

Static Function xReload

Local _aArea := GetArea()

_aBrwREG := {}
dbSelectArea("SZ5")
dbSetOrder(1)
RecLock("SZ5",.T.)
Z5_DATA		:= StoD ("20120628")
Z5_COD		:= _aBrwPRD[_oBrwPRD:nAt,01]
Z5_DESC		:= Posicione("SB1",1,xFilial("SB1")+_aBrwPRD[_oBrwPRD:nAt,01],"B1_DESC")
Z5_CODREG	:= _cCodReg
Z5_NOMREG	:= Posicione("SZ4",1,xFilial("SZ4")+_cCodReg,"Z4_DESC")
Z5_CODVEN	:= _cVend
Z5_NOMVEND	:= Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_NOME")
MsUnlock()
RestArea(_aArea)

xGetREG(_aBrwPRD[_oBrwPRD:nAt,01])  

_oBrwREG:Refresh()
Return