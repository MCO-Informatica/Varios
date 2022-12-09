#Include 'topconn.ch'
#Include "vkey.ch"
#Include 'protheus.ch'
#Include 'rwmake.ch'
#Include 'font.ch'
#Include 'colors.ch'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa   ³ TabPrec2   ³ Autor ³ Luiz Alberto					   ³ Data ³ 15/02/14 º±±
±±ÇÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ¶±±
±±º Descricao  ³ Cadastro de Tabela de Precos Metalacre                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Analista Resp. ³   Data   ³ Manutencao Efetuada                                      º±±
±±ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶±±
±±º                ³   /  /   ³                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function TabPrec2
Local aCores

Private cCadastro := "Tabela de Preços Quantidades"
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Os parametros do aRotina sao:                                             ³±±
±±³ 1 - Pesquisar                                                             ³±±
±±³ 2 - Visualizar                                                            ³±±
±±³ 3 - Incluir                                                               ³±±
±±³ 4 - Alterar                                                               ³±±
±±³ 5 - Excluir                                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Private aRotina   := {	{"Pesquisar"   , "AxPesqui"   , 0, 1},;
						{"Visualizar"  , "U_TabPrc2Vis", 0, 2},;
						{"Incluir"     , "U_TabPrc2Inc", 0, 3},;
						{"Alterar"     , "U_TabPrc2Alt", 0, 4},;
						{"Excluir"     , "U_TabPrc2Exc", 0, 5},;
						{"Ativa/Inativa", "U_TBATIINAT", 0, 6},;
						{"Tabela Default", "U_TBDEFAULT", 0, 6},;
						{"Copia"       , "U_TBCOPIA", 0, 7},;
						{"Reajusta    ", "U_TBREAJU", 0, 8},;
						{"Legenda"     , "U_TabPrc2Leg", 0, 9}  }

Private INCLUI := .F.

SZ7->(dbSetOrder(1))
SZ7->(dbGotop())

// Insere um SetKey
SetKey(VK_F11, {|| U_CopyAcols() })		// Funcao para Replicar linha do Acols


aCores := {	{"Z7_ATIVA  = 'I' .And. Z7_DEFAULT = 'N'"                      , "BR_VERMELHO"    },;
			{"Z7_ATIVA  = 'A' .And. Z7_DEFAULT = 'N'"                      , "BR_VERDE"} ,;
			{"Z7_ATIVA  = 'A' .And. Z7_DEFAULT = 'S'"                      , "BR_AZUL"} }

mBrowse(6, 1, 22, 75, "SZ7", , , , , 2, aCores)

Return


// Exibe legenda do browse
User Function TabPrc2Leg()

BrwLegenda(cCadastro, "Legenda", {	{"BR_VERMELHO"    , "Tabela Inativa"                  },;
									{"BR_VERDE"  , "Tabela Ativa"    },;
									{"BR_AZUL"  , "Tabela Ativa DEFAULT "    }})

Return


// Visualizacao da Lista
User Function TabPrc2Vis()

Local _cTit    := "Tabela de Preços Quantidades"
Local _aCabec  := {}
Local _aReq    := {}
Local _aGD     := {70, 0, 30, 30}
Local cLinOk := "AllwaysTrue()"
Local cTudOk := "AllwaysTrue()"
Local aCordW := {10,10,500,1000}
Local _aGetsGD := {}
Local _nI, _lRet

aObjects     := {}
aPosObj      :={}
aSize        := MsAdvSize()

AADD(aObjects,{100,100,.T.,.T.})
AADD(aObjects,{200,200,.T.,.T.})     

aInfo          := {aSize[1],aSize[2],aSize[3],aSize[4],3,3,3,3}

aPosObj      := MsObjSize(aInfo,aObjects,.T.)

//aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }

aCordW := {aSize[7],0,aSize[6],aSize[5]}


_aSaveArea := GetArea()

Private cCodigo, cStatus, cDescricao, cReajuste, dDtRea
Private aHeader  := {}
Private aCols    := {}
Private _aButtons := {}

// Variaveis de parametros para geracao de volumes

//aAdd(_aButtons, {"FERRAM.BMP"      , {|| U_PCP06Par(.F.)}	, "Parâmetros"})
aAdd(_aButtons, {"LOCALIZA_MDI.BMP", {|| U_PCP06Pesq()}		, "Localizar Item"})

// _aCabec[n, 1] = Nome da Variavel Ex.:"cCliente"
// _aCabec[n, 2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// _aCabec[n, 3] = Titulo do Campo
// _aCabec[n, 4] = Picture
// _aCabec[n, 5] = Validacao
// _aCabec[n, 6] = F3
// _aCabec[n, 7] = Se campo e' editavel .T. se nao .F.
aAdd(_aCabec, {"cCodigo"   , {17,  10}, "Codigo:"   , "", "", "", .F.})
aAdd(_aCabec, {"cStatus"   , {17,  90}, "Status:", "", "", "", .F.})
aAdd(_aCabec, {"cDescricao", {17, 180}, "Descrição:", "@!", "", "", .F.})
aAdd(_aCabec, {"cReajuste" , {17, 420}, "Reajustada:"  , "", "", "", .F.})
aAdd(_aCabec, {"dDtRea"    , {17, 520}, "Data Reaj:"     , "", "", "", .F.})

aAdd(aHeader, {"Produto"   , "Z8_PRODUTO", "", 15, 0, , "", "C", "", ""})
aAdd(aHeader, {"Descricao" , "Z8_DESCR"   , "", 50, 0, , "", "C", "", ""})
aAdd(aHeader, {"Und"       , "Z8_UM"      , "",  2, 0, , "", "C", "", ""})
aAdd(aHeader, {"Ate 1.000" , "Z8_P00500"  , "@E 99,999,999.99"    , 12, 2, , "", "N", "", ""})
//aAdd(aHeader, {"Ate 3.000" , "Z8_P01500"  , "@E 99,999,999.99"    , 12, 2, , "", "N", "", ""})
aAdd(aHeader, {"Ate 5.000" , "Z8_P03000"  , "@E 99,999,999.99"    , 12, 2, , "", "N", "", ""})
aAdd(aHeader, {"Ate 10000" , "Z8_P05000"  , "@E 99,999,999.99"    , 12, 2, , "", "N", "", ""})
//aAdd(aHeader, {"Ate 20000" , "Z8_P10000"  , "@E 99,999,999.99"    , 12, 2, , "", "N", "", ""})
aAdd(aHeader, {"Ate 50000" , "Z8_P20000"  , "@E 99,999,999.99"    , 12, 2, , "", "N", "", ""})
aAdd(aHeader, {"Acima 50K" , "Z8_P20001"  , "@E 99,999,999.99"    , 12, 2, , "", "N", "", ""})

cCodigo  := SZ7->Z7_CODIGO
cStatus  := SZ7->Z7_ATIVA
cDescricao := SZ7->Z7_DESCR
cReajuste := SZ7->Z7_REAJ
dDtRea		:= SZ7->Z7_DTREA

INCLUI := .F.
SZ8->(dbSetOrder(1), dbSeek(xFilial("SZ8") + cCodigo + cStatus))
While !SZ8->(Eof()) .And. SZ8->Z8_FILIAL = xFilial("SZ8") .And. SZ8->Z8_CODIGO+SZ8->Z8_ATIVA = cCodigo+cStatus
	SB1->(dbSetOrder(1), dbSeek(xFilial("SB1") + SZ8->Z8_PRODUTO))
	
	aAdd(aCols, {SZ8->Z8_PRODUTO, SB1->B1_DESC, SB1->B1_UM, SZ8->Z8_P00500, SZ8->Z8_P03000, SZ8->Z8_P05000, SZ8->Z8_P20000, SZ8->Z8_P20001,.f.})
	
	SZ8->(dbSkip())
EndDo

_lRet := Modelo2(_cTit, _aCabec,       {},    ,   2, "U_PCPA06VLin()",       , {"Z8_PRODUTO", "Z8_P00500", "Z8_P03000", 'Z8_P05000', 'Z8_P20000', 'Z8_P20001' },    ,         , 999   , aCordW, .T.     ,.t. , _aButtons)
//_lRet := Modelo2(_cTit, _aCabec, {}, , 1, , , , {|| }, , Len(aCols), , .F., , _aButtons)
//         Modelo2(cTitulo, aCabec, aRodape, aGD, nOp, cLineOk         , cAllOk, aGetsGD                                                                                                                , bF4, cIniCpos, nMax, aCordW, lDelGetD, lMaximized, aButtons)

If _lRet
EndIf

RestArea(_aSaveArea)
Return


// Inclusao de Lista
User Function TabPrc2Inc()

Local _cTit    := "Tabela de Preços Quantidades"
Local _aCabec  := {}
Local _aReq    := {}
Local _aGD     := {70, 0, 30, 30}
Local cLinOk := "AllwaysTrue()"
Local cTudOk := "AllwaysTrue()"
Local aCordW := {10,10,500,1000}
Local _aGetsGD := {}
Local _nI, _lRet

aObjects     := {}
aPosObj      :={}
aSize        := MsAdvSize()

AADD(aObjects,{100,100,.T.,.T.})
AADD(aObjects,{200,200,.T.,.T.})     

aInfo          := {aSize[1],aSize[2],aSize[3],aSize[4],3,3,3,3}

aPosObj      := MsObjSize(aInfo,aObjects,.T.)

//aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }

aCordW := {aSize[7],0,aSize[6],aSize[5]}


_aSaveArea := GetArea()

Private cCodigo, cStatus, cDescricao, cReajuste, dDtRea
Private aHeader  := {}
Private aCols    := {}
Private _aButtons := {}

// Variaveis de parametros para geracao de volumes

//aAdd(_aButtons, {"FERRAM.BMP"      , {|| U_PCP06Par(.F.)}	, "Parâmetros"})
aAdd(_aButtons, {"LOCALIZA_MDI.BMP", {|| U_PCP06Pesq()}		, "Localizar Item"})

// _aCabec[n, 1] = Nome da Variavel Ex.:"cCliente"
// _aCabec[n, 2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// _aCabec[n, 3] = Titulo do Campo
// _aCabec[n, 4] = Picture
// _aCabec[n, 5] = Validacao
// _aCabec[n, 6] = F3
// _aCabec[n, 7] = Se campo e' editavel .T. se nao .F.
aAdd(_aCabec, {"cCodigo"   , {17,  10}, "Codigo:"   , "", "", "", .F.})
aAdd(_aCabec, {"cStatus"   , {17,  90}, "Status:", "", "", "", .F.})
aAdd(_aCabec, {"cDescricao", {17, 180}, "Descrição:", "@!", "", "", .T.})
aAdd(_aCabec, {"cReajuste" , {17, 420}, "Reajustada:"  , "", "", "", .F.})
aAdd(_aCabec, {"dDtRea"    , {17, 520}, "Data Reaj:"     , "", "", "", .F.})

aAdd(aHeader, {"Produto"   , "Z8_PRODUTO", "", 15, 0, , "", "C", "", ""})
aAdd(aHeader, {"Descricao" , "Z8_DESCR"   , "", 50, 0, , "", "C", "", ""})
aAdd(aHeader, {"Und"       , "Z8_UM"      , "",  2, 0, , "", "C", "", ""})
aAdd(aHeader, {"Ate 1.000"  , "Z8_P00500"  , "@E 99,999,999.99"    , 12, 2, , "", "N", "", ""})
//aAdd(aHeader, {"Ate 3.000" , "Z8_P01500"  , "@E 99,999,999.99"    , 12, 2, , "", "N", "", ""})
aAdd(aHeader, {"Ate 5.000" , "Z8_P03000"  , "@E 99,999,999.99"    , 12, 2, , "", "N", "", ""})
aAdd(aHeader, {"Ate 10000" , "Z8_P05000"  , "@E 99,999,999.99"    , 12, 2, , "", "N", "", ""})
//aAdd(aHeader, {"Ate 20000" , "Z8_P10000"  , "@E 99,999,999.99"    , 12, 2, , "", "N", "", ""})
aAdd(aHeader, {"Ate 50000" , "Z8_P20000"  , "@E 99,999,999.99"    , 12, 2, , "", "N", "", ""})
aAdd(aHeader, {"Acima 50K" , "Z8_P20001"  , "@E 99,999,999.99"    , 12, 2, , "", "N", "", ""})

cCodigo      := GetSX8Num("SZ7", "Z7_CODIGO")
cStatus		 := 'A'
cDescricao   := Space(30)
cReajuste	 := ''
dDtRea		 := CtoD('')

INCLUI := .T.

SB1->(dbGoBoTTom())
SZ8->(dbGoBoTTom())

//Modelo2(cTitulo, aCabec, aRodape, aGD, nOp, cLineOk, cAllOk, aGetsGD, bF4, cIniCpos, nMax, aCordW, lDelGetD, lMaximized, aButtons)
_lRet := Modelo2(_cTit, _aCabec,       {},    ,   3, "U_PCPA06VLin()",       , {"Z8_PRODUTO", "Z8_P00500", "Z8_P03000", 'Z8_P05000', 'Z8_P20000', 'Z8_P20001' },    ,         , 999   , aCordW, .T.     ,.t. , _aButtons)
//         Modelo2(cTitulo, aCabec, aRodape, aGD, nOp, cLineOk         , cAllOk, aGetsGD                                                                                                                , bF4, cIniCpos, nMax, aCordW, lDelGetD, lMaximized, aButtons)

If _lRet
	RecLock("SZ7", .T.)
	SZ7->Z7_FILIAL  := xFilial("SZ7")
	SZ7->Z7_CODIGO  := cCodigo        
	SZ7->Z7_ATIVA	:= 'A'
	SZ7->Z7_DESCR   := cDescricao
	SZ7->Z7_DATA	:= dDataBase
	SZ7->Z7_REAJ	:= 'N'                   
	SZ7->Z7_DEFAULT	:= 'N'                   
	MsUnlock()
	
	For _nI := 1 To Len(aCols)
		If !GdDeleted(_nI)
			RecLock("SZ8", .T.)
			SZ8->Z8_FILIAL  := xFilial("SZ8")
			SZ8->Z8_CODIGO  := cCodigo
			SZ8->Z8_ATIVA	:= 'A'
			SZ8->Z8_PRODUTO := aCols[_nI, GdFieldPos("Z8_PRODUTO", aHeader)]
			SZ8->Z8_DESCR   := aCols[_nI, GdFieldPos("Z8_DESCR"  , aHeader)]
			SZ8->Z8_UM      := aCols[_nI, GdFieldPos("Z8_UM"     , aHeader)]
			SZ8->Z8_P00500  := aCols[_nI, GdFieldPos("Z8_P00500"     , aHeader)]
//			SZ8->Z8_P01500  := aCols[_nI, GdFieldPos("Z8_P01500"     , aHeader)]
			SZ8->Z8_P03000  := aCols[_nI, GdFieldPos("Z8_P03000"     , aHeader)]
			SZ8->Z8_P05000  := aCols[_nI, GdFieldPos("Z8_P05000"     , aHeader)]
			//SZ8->Z8_P10000  := aCols[_nI, GdFieldPos("Z8_P10000"     , aHeader)]
			SZ8->Z8_P20000  := aCols[_nI, GdFieldPos("Z8_P20000"     , aHeader)]
			SZ8->Z8_P20001  := aCols[_nI, GdFieldPos("Z8_P20001"     , aHeader)]
			MsUnlock()
		EndIf
	Next
	
	ConfirmSX8()
Else
	RollBackSX8()
EndIf

RestArea(_aSaveArea)

Return


// Alteracao de lista
User Function TabPrc2Alt

Local _cTit    := "Tabela de Preços Quantidades"
Local _aCabec  := {}
Local _aReq    := {}
Local _aGD     := {70, 0, 30, 30}
Local cLinOk := "AllwaysTrue()"
Local cTudOk := "AllwaysTrue()"
Local aCordW := {10,10,500,1000}
Local _aGetsGD := {}
Local _nI, _lRet

If SZ7->Z7_REAJ == 'S'
	Alert("Atencao esta Tabela Foi Reajustada, Por Isso Nâo podera Ser Alterada !")
	Return .f.
Endif

If SZ7->Z7_ATIVA <> 'A'
	Alert("Atencao esta Tabela Esta Inativa, Por Isso Nâo podera Ser Alterada !")
	Return .f.
Endif

aObjects     := {}
aPosObj      :={}
aSize        := MsAdvSize()

AADD(aObjects,{100,100,.T.,.T.})
AADD(aObjects,{200,200,.T.,.T.})     

aInfo          := {aSize[1],aSize[2],aSize[3],aSize[4],3,3,3,3}

aPosObj      := MsObjSize(aInfo,aObjects,.T.)

//aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }

aCordW := {aSize[7],0,aSize[6],aSize[5]}


_aSaveArea := GetArea()

Private cCodigo, cStatus, cDescricao, cReajuste, dDtRea
Private aHeader  := {}
Private aCols    := {}
Private _aButtons := {}

// Variaveis de parametros para geracao de volumes

//aAdd(_aButtons, {"FERRAM.BMP"      , {|| U_PCP06Par(.F.)}	, "Parâmetros"})
aAdd(_aButtons, {"LOCALIZA_MDI.BMP", {|| U_PCP06Pesq()}		, "Localizar Item"})

// _aCabec[n, 1] = Nome da Variavel Ex.:"cCliente"
// _aCabec[n, 2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// _aCabec[n, 3] = Titulo do Campo
// _aCabec[n, 4] = Picture
// _aCabec[n, 5] = Validacao
// _aCabec[n, 6] = F3
// _aCabec[n, 7] = Se campo e' editavel .T. se nao .F.
aAdd(_aCabec, {"cCodigo"   , {17,  10}, "Codigo:"   , "", "", "", .F.})
aAdd(_aCabec, {"cStatus"   , {17,  90}, "Status:", "", "", "", .F.})
aAdd(_aCabec, {"cDescricao", {17, 180}, "Descrição:", "@!", "", "", .T.})
aAdd(_aCabec, {"cReajuste" , {17, 420}, "Reajustada:"  , "", "", "", .F.})
aAdd(_aCabec, {"dDtRea"    , {17, 520}, "Data Reaj:"     , "", "", "", .F.})

aAdd(aHeader, {"Produto"   , "Z8_PRODUTO", "", 15, 0, , "", "C", "", ""})
aAdd(aHeader, {"Descricao" , "Z8_DESCR"   , "", 50, 0, , "", "C", "", ""})
aAdd(aHeader, {"Und"       , "Z8_UM"      , "",  2, 0, , "", "C", "", ""})
aAdd(aHeader, {"Ate 1.000"  , "Z8_P00500"  , "@E 99,999,999.99"    , 12, 2, , "", "N", "", ""})
//aAdd(aHeader, {"Ate 3.000" , "Z8_P01500"  , "@E 99,999,999.99"    , 12, 2, , "", "N", "", ""})
aAdd(aHeader, {"Ate 5.000" , "Z8_P03000"  , "@E 99,999,999.99"    , 12, 2, , "", "N", "", ""})
aAdd(aHeader, {"Ate 10000" , "Z8_P05000"  , "@E 99,999,999.99"    , 12, 2, , "", "N", "", ""})
//aAdd(aHeader, {"Ate 20000" , "Z8_P10000"  , "@E 99,999,999.99"    , 12, 2, , "", "N", "", ""})
aAdd(aHeader, {"Ate 50000" , "Z8_P20000"  , "@E 99,999,999.99"    , 12, 2, , "", "N", "", ""})
aAdd(aHeader, {"Acima 50K" , "Z8_P20001"  , "@E 99,999,999.99"    , 12, 2, , "", "N", "", ""})

cCodigo  := SZ7->Z7_CODIGO
cStatus  := SZ7->Z7_ATIVA
cDescricao := SZ7->Z7_DESCR
cReajuste := SZ7->Z7_REAJ
dDtRea		:= SZ7->Z7_DTREA

INCLUI := .F.
ALTERA := .t.
SZ8->(dbSetOrder(1), dbSeek(xFilial("SZ8") + cCodigo + cStatus))
While !SZ8->(Eof()) .And. SZ8->Z8_FILIAL = xFilial("SZ8") .And. SZ8->Z8_CODIGO+SZ8->Z8_ATIVA = cCodigo+cStatus
	SB1->(dbSetOrder(1), dbSeek(xFilial("SB1") + SZ8->Z8_PRODUTO))
	
	aAdd(aCols, {SZ8->Z8_PRODUTO, SB1->B1_DESC, SB1->B1_UM, SZ8->Z8_P00500, SZ8->Z8_P03000, SZ8->Z8_P05000, SZ8->Z8_P20000, SZ8->Z8_P20001,.f.})
	
	SZ8->(dbSkip())
EndDo

_lRet := Modelo2(_cTit, _aCabec,       {},    ,   4, "U_PCPA06VLin()",       , {"Z8_PRODUTO", "Z8_P00500", "Z8_P03000", 'Z8_P05000', 'Z8_P20000', 'Z8_P20001' },    ,         , 999   , aCordW, .T.     ,.t. , _aButtons)

If _lRet
	// Acerta os registros existentes
	SZ8->(dbSetOrder(1), dbSeek(xFilial("SZ8") + cCodigo))
	While !SZ8->(Eof()) .And. SZ8->Z8_FILIAL = xFilial("SZ8") .And. SZ8->Z8_CODIGO+SZ8->Z8_ATIVA = cCodigo+cStatus
		RecLock("SZ8", .F.)
		SZ8->(dbDelete())
		MsUnlock()
		
		SZ8->(dbSkip())
	EndDo
	
	For _nI := 1 To Len(aCols)
		If !GdDeleted(_nI)
			RecLock("SZ8", .T.)
			SZ8->Z8_FILIAL  := xFilial("SZ8")
			SZ8->Z8_CODIGO  := cCodigo
			SZ8->Z8_ATIVA	:= 'A'
			SZ8->Z8_PRODUTO := aCols[_nI, GdFieldPos("Z8_PRODUTO", aHeader)]
			SZ8->Z8_DESCR   := aCols[_nI, GdFieldPos("Z8_DESCR"  , aHeader)]
			SZ8->Z8_UM      := aCols[_nI, GdFieldPos("Z8_UM"     , aHeader)]
			SZ8->Z8_P00500  := aCols[_nI, GdFieldPos("Z8_P00500"     , aHeader)]
//			SZ8->Z8_P01500  := aCols[_nI, GdFieldPos("Z8_P01500"     , aHeader)]
			SZ8->Z8_P03000  := aCols[_nI, GdFieldPos("Z8_P03000"     , aHeader)]
			SZ8->Z8_P05000  := aCols[_nI, GdFieldPos("Z8_P05000"     , aHeader)]
//			SZ8->Z8_P10000  := aCols[_nI, GdFieldPos("Z8_P10000"     , aHeader)]
			SZ8->Z8_P20000  := aCols[_nI, GdFieldPos("Z8_P20000"     , aHeader)]
			SZ8->Z8_P20001  := aCols[_nI, GdFieldPos("Z8_P20001"     , aHeader)]
			MsUnlock()
		EndIf
	Next
	
	RecLock("SZ7", .F.)
	SZ7->Z7_DESCR   := cDescricao
	MsUnlock()
EndIf

RestArea(_aSaveArea)

Return


// Exclusao de Lista
User Function TabPrc2Exc

Local _cTit    := "Tabela de Preços Quantidades"
Local _aCabec  := {}
Local _aReq    := {}
Local _aGD     := {70, 0, 30, 30}
Local cLinOk := "AllwaysTrue()"
Local cTudOk := "AllwaysTrue()"
Local aCordW := {10,10,500,1000}
Local _aGetsGD := {}
Local _nI, _lRet

If SZ7->Z7_REAJ == 'S'
	Alert("Atencao esta Tabela Foi Reajustada, Por Isso Nâo podera Ter seu Status Modificado !")
	Return .f.
Endif

aObjects     := {}
aPosObj      :={}
aSize        := MsAdvSize()

AADD(aObjects,{100,100,.T.,.T.})
AADD(aObjects,{200,200,.T.,.T.})     

aInfo          := {aSize[1],aSize[2],aSize[3],aSize[4],3,3,3,3}

aPosObj      := MsObjSize(aInfo,aObjects,.T.)

//aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }

aCordW := {aSize[7],0,aSize[6],aSize[5]}


_aSaveArea := GetArea()

Private cCodigo, cStatus, cDescricao, cReajuste, dDtRea
Private aHeader  := {}
Private aCols    := {}
Private _aButtons := {}

// Variaveis de parametros para geracao de volumes

//aAdd(_aButtons, {"FERRAM.BMP"      , {|| U_PCP06Par(.F.)}	, "Parâmetros"})
aAdd(_aButtons, {"LOCALIZA_MDI.BMP", {|| U_PCP06Pesq()}		, "Localizar Item"})

// _aCabec[n, 1] = Nome da Variavel Ex.:"cCliente"
// _aCabec[n, 2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// _aCabec[n, 3] = Titulo do Campo
// _aCabec[n, 4] = Picture
// _aCabec[n, 5] = Validacao
// _aCabec[n, 6] = F3
// _aCabec[n, 7] = Se campo e' editavel .T. se nao .F.
aAdd(_aCabec, {"cCodigo"   , {17,  10}, "Codigo:"   , "", "", "", .F.})
aAdd(_aCabec, {"cStatus"   , {17,  90}, "Status:", "", "", "", .F.})
aAdd(_aCabec, {"cDescricao", {17, 180}, "Descrição:", "@!", "", "", .T.})
aAdd(_aCabec, {"cReajuste" , {17, 420}, "Reajustada:"  , "", "", "", .F.})
aAdd(_aCabec, {"dDtRea"    , {17, 520}, "Data Reaj:"     , "", "", "", .F.})

aAdd(aHeader, {"Produto"   , "Z8_PRODUTO", "", 15, 0, , "", "C", "", ""})
aAdd(aHeader, {"Descricao" , "Z8_DESCR"   , "", 50, 0, , "", "C", "", ""})
aAdd(aHeader, {"Und"       , "Z8_UM"      , "",  2, 0, , "", "C", "", ""})
aAdd(aHeader, {"Ate 1.000"  , "Z8_P00500"  , "@E 99,999,999.99"    , 12, 2, , "", "N", "", ""})
//dd(aHeader, {"Ate 3.000" , "Z8_P01500"  , "@E 99,999,999.99"    , 12, 2, , "", "N", "", ""})
aAdd(aHeader, {"Ate 5.000" , "Z8_P03000"  , "@E 99,999,999.99"    , 12, 2, , "", "N", "", ""})
aAdd(aHeader, {"Ate 10000" , "Z8_P05000"  , "@E 99,999,999.99"    , 12, 2, , "", "N", "", ""})
//aAdd(aHeader, {"Ate 20000" , "Z8_P10000"  , "@E 99,999,999.99"    , 12, 2, , "", "N", "", ""})
aAdd(aHeader, {"Ate 50000" , "Z8_P20000"  , "@E 99,999,999.99"    , 12, 2, , "", "N", "", ""})
aAdd(aHeader, {"Acima 50K" , "Z8_P20001"  , "@E 99,999,999.99"    , 12, 2, , "", "N", "", ""})

cCodigo  	:= SZ7->Z7_CODIGO
cStatus  	:= SZ7->Z7_ATIVA
cDescricao 	:= SZ7->Z7_DESCR
cReajuste 	:= SZ7->Z7_REAJ
dDtRea		:= SZ7->Z7_DTREA

INCLUI := .F.
SZ8->(dbSetOrder(1), dbSeek(xFilial("SZ8") + cCodigo + cStatus))
While !SZ8->(Eof()) .And. SZ8->Z8_FILIAL = xFilial("SZ8") .And. SZ8->Z8_CODIGO+SZ8->Z8_ATIVA = cCodigo+cStatus
	SB1->(dbSetOrder(1), dbSeek(xFilial("SB1") + SZ8->Z8_PRODUTO))
	
	aAdd(aCols, {SZ8->Z8_PRODUTO, SB1->B1_DESC, SB1->B1_UM, SZ8->Z8_P00500, SZ8->Z8_P03000, SZ8->Z8_P05000, SZ8->Z8_P20000, SZ8->Z8_P20001,.f.})
	
	SZ8->(dbSkip())
EndDo

_lRet := Modelo2(_cTit, _aCabec,       {},    ,   5, "U_PCPA06VLin()",       , {"Z8_PRODUTO", "Z8_P00500", "Z8_P03000", 'Z8_P05000', 'Z8_P20000', 'Z8_P20001' },    ,         , 999   , aCordW, .T.     ,.t. , _aButtons)

If _lRet
	IF MsgYesNo("Confirma a Exclusão da Tabela de Preços " + SZ7->Z7_CODIGO + " ?")
		// Acerta os registros existentes
		SZ8->(dbSeek(xFilial("SZ8") + cCodigo + cStatus))
		While !SZ8->(Eof()) .And. SZ8->Z8_FILIAL = xFilial("SZ8") .And. SZ8->Z8_CODIGO+SZ8->Z8_ATIVA = cCodigo+cStatus
			RecLock("SZ8", .F.)
			SZ8->(dbDelete())
			MsUnlock()
			
			SZ8->(dbSkip())
		EndDo
		
		If RecLock("SZ7",.f.)
			SZ7->(dbDelete())
			SZ7->(MsUnlock())
		Endif
	Endif
EndIf

RestArea(_aSaveArea)
Return


// Validacao da Inclusao
User Function PCPA06VInc()

Local _lOK

SZ7->(dbSetOrder(2))	// Filial + Produto
_lOK := !SZ7->(dbSeek(xFilial("SZ7") + cLote))

If !_lOK
	Alert("Não é possível concluir a operação, pois já foram criadas as bases do lote informado.")
EndIf

Return(_lOK)


User Function PCP06Pesq

Local aSvKeys   := GetKeys()
Local aArea     := GetArea()
Local aAreaSX3  := SX3->(GetArea())
Local aCpoBusca := {}
Local aComboBox := {"Exata", "Parcial", "Contém"}

Local bScan := {|| .F.}
Local bGdChgPict, bSet15, bSet24, bDialogInit

Local cOpcAsc := aComboBox[2]
Local cPesq, cBusca, cScan

Local nOpca := 0
Local nTipo := 1
//Local n     := aScan(aCols, {|x| x[GdFieldPos("ZG_VOLUME", oGetD2:aHeader)] == oGetD1:aCols[oGetD1:nAt, GdFieldPos("ZF_NUM", oGetD1:aHeader)]})
Local nPos, nBegin, nEnd, nLoop, nLoops

Local lTpBusca := .T.
Local lAcima   := .F.

Local oDlg, oPesq, oBusca, oTpBusca, oComboBox, oAcima, oGD

oGD := CallMod2Obj()

nLoops := Len(aHeader)
For nLoop := 1 To nLoops
	aAdd(aCpoBusca, aHeader[nLoop][1])
Next

cBusca	:= aCpoBusca[1]
bGdChgPict := {|| GdChgPict(@oDlg, nTipo, @oPesq, @cPesq, @oComboBox)}
Define MsDialog oDlg Title "Localizar Item" From 0, 0 To 130, 490 Of oMainWnd Pixel

@ 005, 005 MsComboBox oBusca Var cBusca Items aCpoBusca Size 206, 36 Of oDlg Pixel On Change (nTipo := oBusca:nAt, Eval(bGdChgPict))
@ 041, 005 Say "Linha Atual: " + AllTrim(Str(n)) Size 020, 020 Of oDlg Pixel
@ 039, 065 CheckBox oTpBusca Var lTpBusca Prompt "Busca a partir da linha atual" Size 150, 10 Of oDlg Pixel
@ 039, 161 CheckBox oAcima Var lAcima Prompt "Acima" Size 050,10 Of oDlg Pixel When (If(!lTpBusca, lAcima := .F., lAcima), lTpBusca .And. n > 1)
@ 039, 194 MsComboBox oComboBox Var cOpcAsc Items aComboBox Size 050,10 Of oDlg Pixel

bSet15 := {|| nOpca := 1, RestKeys(aSvKeys, .T.), oDlg:End()}
oDlg:bSet15 := bSet15
bSet24 := {|| nOpca := 0, RestKeys(aSvKeys, .T.), oDlg:End()}
oDlg:bSet24 := bSet24

bDialogInit := {|| SetKey(15, bSet15), SetKey(24, bSet24), Eval(bGdChgPict)}

Define SButton oBut1 From 005, 215 Type 1 Action Eval(bSet15) Enable Of oDlg
Define SButton oBut2 From 020, 215 Type 2 Action Eval(bSet24) Enable Of oDlg

Activate MsDialog oDlg Centered On Init Eval(bDialogInit)

If nOpca == 1
	If lTpBusca
		If lAcima
			nBegin := 1
			nEnd   := Max(n - 1, 1)
		Else
			nBegin := Min(n + 1, Len(aCols))
			nEnd   := Len(aCols)
		EndIF
	Else
		nBegin := 1
		nEnd   := Len(aCols)
	EndIF
	
	Do Case
		Case aHeader[nTipo][8] $ "CM"
			If cOpcAsc == aComboBox[1]	//Exata
				cScan := Padr(Upper(cPesq), TamSx3(aHeader[nTipo][2])[1])
				bScan := {|x| cScan == Upper(x[nTipo])}
			ElseIf cOpcAsc == aComboBox[2]	//Parcial
				cScan := Upper(AllTrim(cPesq))
				bScan := {|x| cScan == Upper(SubStr(Alltrim(x[nTipo]), 1, Len(cScan)))}
			ElseIf cOpcAsc == aComboBox[3]	//Contem
				cScan := Upper(AllTrim(cPesq))
				bScan := {|x| cScan $ Upper(Alltrim(x[nTipo]))}
			EndIf
		Case aHeader[nTipo][8] == "N"
			bScan := {|x| cPesq == x[nTipo]}
		Case aHeader[nTipo][8] == "D"
			bScan := {|x| DToS(cPesq) == DToS(x[nTipo])}
		OtherWise
			Break
	EndCase
	
	nPos := aScan(aCols, bScan, nBegin, nEnd)
	
	If nPos > 0
		oGD:Goto(nPos)
		oGD:oBrowse:Refresh()
		oGD:oBrowse:SetFocus()
		If ValType(oGD:oBrowse:bChange) == "B"
			Eval(oGD:oBrowse:bChange)
		EndIf
	Else
		Help(" ", 1, "REGNOIS")
	EndIf
EndIf

RestArea(aAreaSX3)
RestArea(aArea)
RestKeys(aSvKeys, .T.)

Return


// Validacao da linha inteira
User Function PCPA06VLin()
Local _aSave := GetArea()
Local _aSaveSB1 := SB1->(GetArea())
Local _lOK := .F.

If !GdDeleted(n)
	nPos := Ascan(aCols,{|x| x[GdFieldPos("Z8_PRODUTO")] == aCols[n, GdFieldPos("Z8_PRODUTO")]})
	If !Empty(nPos) .And. nPos <> n
		Alert("Atenção o Produto " + AllTrim(aCols[n, GdFieldPos("Z8_PRODUTO")]) + " Já Esta Cadastrado na Tabela !")
		RestArea(_aSave)
		RestArea(_aSaveSB1)
		Return(_lOK)
	Endif	
	
	SB1->(dbSetOrder(1))	// Filial + Codigo
	If SB1->(dbSeek(xFilial("SB1") + aCols[n, GdFieldPos("Z8_PRODUTO")]))
		aCols[n, GdFieldPos("Z8_DESCR")] := SB1->B1_DESC
		aCols[n, GdFieldPos("Z8_UM")] := SB1->B1_UM
		_lOk := .t.
	Else
		Alert("Atenção o Produto " + AllTrim(aCols[n, GdFieldPos("Z8_PRODUTO")]) + " Não Foi Localizado no Cadastro !")
		RestArea(_aSave)
		RestArea(_aSaveSB1)
		Return(_lOK)
	Endif
ElseIf GdDeleted(n)
	_lOk := .t.
Endif
RestArea(_aSave)
RestArea(_aSaveSB1)
Return(_lOK)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TBCOPIA º Autor ³ Luiz Alberto      º Data ³  15/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Copia de Tabela de Preços                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento x CRM (Metalacre)                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                        
User Function TBATIINAT()
Local aArea := GetArea()                      

If SZ7->Z7_REAJ == 'S'
	Alert("Atencao esta Tabela Foi Reajustada, Por Isso Nâo podera Ter seu Status Modificado !")
	RestArea(aArea)
	Return .f.
Endif

IF MsgYesNo("Deseja Mudar o Status da Tabela de Preços " + SZ7->Z7_CODIGO + " ?")
	If SZ8->(dbSetOrder(1), dbSeek(xFilial("SZ8")+SZ7->Z7_CODIGO+SZ7->Z7_ATIVA))
		While SZ8->(!Eof()) .And. SZ8->Z8_CODIGO+SZ8->Z8_ATIVA == SZ7->Z7_CODIGO+SZ7->Z7_ATIVA .And. SZ8->Z8_FILIAL == xFilial("SZ8")
			If RecLock("SZ8",.f.)
				If SZ7->Z7_ATIVA == 'A' // Tabela Ativa
					SZ8->Z8_ATIVA := 'I'
				Else
					SZ8->Z8_ATIVA := 'A'
				Endif
				SZ8->(MsUnlock())
			Endif
			
			SZ8->(dbSkip(1))
		Enddo
	Endif
	
	If RecLock("SZ7",.f.)
		If SZ7->Z7_ATIVA == 'A' // Tabela Ativa
			SZ7->Z7_ATIVA := 'I'
		Else
			SZ7->Z7_ATIVA := 'A'
		Endif
		SZ7->(MsUnlock())
	Endif
	Aviso( 'Ativa ou Inativa', Iif(SZ7->Z7_ATIVA=='A','Tabela Ativada com Sucesso !','Tabela Inativada Com Sucesso 1'), {"Ok"} )
Endif
RestArea(aArea)
Return .t.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TBDEFAULTº Autor ³ Luiz Alberto      º Data ³  15/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Copia de Tabela de Preços                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento x CRM (Metalacre)                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                        
User Function TBDEFAULT()
Local aArea := GetArea()                      

If SZ7->Z7_REAJ == 'S'
	Alert("Atencao esta Tabela Foi Reajustada, Por Isso Nâo podera Ser a Tabela DEFAULT !")
	RestArea(aArea)
	Return .f.
Endif

If SZ7->Z7_ATIVA == 'I'
	Alert("Atencao esta Tabela Esta Inativa, Por Isso Nâo podera Ser a Tabela DEFAULT !")
	RestArea(aArea)
	Return .f.
Endif

IF MsgYesNo("Deseja Deixar a Tabela de Preços " + SZ7->Z7_CODIGO + " Como Tabela DEFAULT ?")

	// Muda parametro para liberacao automatica dos pedidos de venda web

	//Parametro 002 - Produção Usuário
	If !fExistMV("MV_TBQPAD")
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial( "SX6" )
		SX6->X6_VAR     := "MV_TBQPAD"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Tabela DEFAULT de Quantidades"
		SX6->(MsUnLock())
	EndIf

	nRec := SZ7->(Recno())
	SZ7->(dbGoTop())
	While SZ7->(!Eof()) .And. SZ7->Z7_FILIAL == xFilial("SZ7")
		If RecLock("SZ7",.f.)
			SZ7->Z7_DEFAULT := 'N'
			SZ7->(MsUnlock())
		Endif                    
		
		SZ7->(dbSkip(1))
	Enddo
	SZ7->(dbGoTo(nRec))
	If RecLock("SZ7",.f.)
		SZ7->Z7_DEFAULT := 'S'
		SZ7->(MsUnlock())
	Endif
	PutMV("MV_TBQPAD",SZ7->Z7_CODIGO+SZ7->Z7_ATIVA) // cMvAvalEst
	
	Aviso( 'Tabela Default', 'Tabela Marcada Como Default com Sucesso !', {"Ok"} )
Endif
RestArea(aArea)
Return .t.



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TBCOPIA º Autor ³ Luiz Alberto      º Data ³  15/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Copia de Tabela de Preços                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento x CRM (Metalacre)                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                        
User Function TBCOPIA()
Local aArea := GetArea()

IF MsgYesNo("Confirma a Cópia da Tabela de Preços " + SZ7->Z7_CODIGO + " ?")
	
	cTabela := SZ7->Z7_CODIGO + SZ7->Z7_ATIVA
	
	aCampos := {}
	For nI := 1 To SZ7->(FCount())
		AAdd(aCampos,{SZ7->(FieldName(nI)),SZ7->(FieldGet(nI))})
	Next
	
	cCodNew := GetSx8Num("SZ7","Z7_CODIGO")
	If RecLock("SZ7",.t.)
		SZ7->Z7_FILIAL	:= xFilial("SZ7")
		SZ7->Z7_CODIGO	:= cCodNew
		SZ7->Z7_ATIVA	:= 'A'
		SZ7->Z7_REAJ	:= 'N'                   
		SZ7->Z7_DATA	:= dDataBase
		SZ7->Z7_DTREA	:= CtoD('')
		SZ7->Z7_DEFAULT	:= 'N'                   
		For nI := 1 To Len(aCampos)
			If !aCampos[nI,1] $ 'Z7_FILIAL*Z7_CODIGO*Z7_ATIVA*Z7_REAJ*Z7_DTREA*Z7_DEFAULT'
				SZ7->(FieldPut(FieldPos(aCampos[nI,1]),aCampos[nI,2]))
			Endif
		Next
		SZ7->(MsUnlock())
	Endif                      
	ConfirmSX8()
	
	// Efetua Copia dos Itens
	
	If SZ8->(dbSetOrder(1), dbSeek(xFilial("SZ8")+cTabela))
		While SZ8->(!Eof()) .And. SZ8->Z8_FILIAL == xFilial("SZ8") .And. SZ8->Z8_CODIGO+SZ8->Z8_ATIVA == cTabela
			nRec := SZ8->(Recno())
			
			aCampos := {}
			For nI := 1 To SZ8->(FCount())
				If !SZ8->(FieldName(nI))$'Z8_P01500*Z8_P10000'
					AAdd(aCampos,{SZ8->(FieldName(nI)),SZ8->(FieldGet(nI))})
				Endif
			Next
	
			If RecLock("SZ8",.t.)
				SZ8->Z8_FILIAL	:= xFilial("SZ8")
				SZ8->Z8_CODIGO	:= cCodNew
				SZ8->Z8_ATIVA	:= 'A'
				For nI := 1 To Len(aCampos)
					If !aCampos[nI,1] $ 'Z8_FILIAL*Z8_CODIGO*Z8_ATIVA*Z8_P01500*Z8_P10000'
						SZ8->(FieldPut(FieldPos(aCampos[nI,1]),aCampos[nI,2]))
					Endif
				Next
				SZ8->(MsUnlock())
			Endif  
			
			SZ8->(dbGoTo(nRec))
			SZ8->(dbSkip(1))
		Enddo
	Endif                    
	
	Aviso( 'Copia Tabelas', "Copia da Tabela Executada com Sucesso !!!", {"Ok"} )
Endif
RestArea(aArea)
SZ7->(dbSetOrder(1), dbSeek(xFilial("SZ7")+cCodNew+'A'))
Return .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VLDPERGºAutor  ³MARCIO TORRESSON       					  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PERGUNTAS DE USO DA ROTINA                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VldPerg01()

SX1->(DbSetOrder(1))
If !SX1->(DbSeek(cPerg+"01"))
	PutSX1(cPerg, "01", "% Ate 1.000 ?","","","mv_ch1","N",06,2,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","",,,,)
Endif
If !SX1->(DbSeek(cPerg+"02"))
	PutSX1(cPerg, "02", "% Ate 5.000 ?","","","mv_ch2","N",06,2,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","",,,,)
Endif
If !SX1->(DbSeek(cPerg+"03"))
	PutSX1(cPerg, "03", "% Ate 10.000 ?","","","mv_ch3","N",06,2,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","",,,,)
Endif
If !SX1->(DbSeek(cPerg+"04"))
	PutSX1(cPerg, "04", "% Ate 50.000 ?","","","mv_ch4","N",06,2,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","",,,,)
Endif
If !SX1->(DbSeek(cPerg+"05"))
	PutSX1(cPerg, "05", "% Acima 50.000 ?","","","mv_ch5","N",06,2,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","",,,,)
Endif
If !SX1->(DbSeek(cPerg+"06"))
	PutSX1(cPerg, "06", "Produto de ?   ","","","mv_ch6","C",15,0,0,"G","","SB1","","","mv_par06","","","","","","","","","","","","","","","",,,,)
Endif
If !SX1->(DbSeek(cPerg+"07"))
	PutSX1(cPerg, "07", "Produto Ate ?","","","mv_ch7","C",15,0,0,"G","","SB1","","","mv_par07","","","","","","","","","","","","","","","",,,,)
Endif
Return




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TBCOPIA º Autor ³ Luiz Alberto      º Data ³  15/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Copia de Tabela de Preços                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento x CRM (Metalacre)                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                        
User Function TBREAJU()
Local aArea := GetArea()
Local cCodigo := SZ7->Z7_CODIGO
Private cPerg := 'TBREAJU'

If SZ7->Z7_ATIVA <> 'A'
	Alert("Atencao esta Tabela Esta Inativa, Por Isso Nâo podera Ser Reajustada !")
	Return .f.
Endif

VldPerg01()
If !Pergunte(cPerg,.t.)
	Return .f.
Endif

IF MsgYesNo("Confirma o Reajuste da Tabela de Preços " + SZ7->Z7_CODIGO + " ?")
	cCodigo := SZ7->Z7_CODIGO
	cDescri := SZ7->Z7_DESCR
	cTabela := SZ7->Z7_CODIGO + SZ7->Z7_ATIVA

	If RecLock("SZ7",.f.)
		SZ7->Z7_ATIVA := 'I'
		SZ7->Z7_REAJ  := 'S'
		SZ7->Z7_DTREA := dDataBase
		SZ7->(MsUnlock())
	Endif

	If SZ8->(dbSetOrder(1), dbSeek(xFilial("SZ8")+cTabela))
		aItens := {}
		While SZ8->(!Eof()) .And. SZ8->Z8_FILIAL == xFilial("SZ8") .And. SZ8->Z8_CODIGO+SZ8->Z8_ATIVA == cTabela
			AAdd(aItens,{SZ8->Z8_PRODUTO,SZ8->Z8_DESCR,SZ8->Z8_UM,SZ8->Z8_P00500,SZ8->Z8_P03000,SZ8->Z8_P05000,SZ8->Z8_P20000,SZ8->Z8_P20001,SZ8->(Recno())})
			
			SZ8->(dbSkip(1))
		Enddo
		
		For nI := 1 To Len(aItens)
			If RecLock("SZ8",.t.)
				SZ8->Z8_FILIAL	:= xFilial("SZ8")
				SZ8->Z8_CODIGO	:= cCodigo
				SZ8->Z8_ATIVA	:= 'A'
				SZ8->Z8_PRODUTO := aItens[nI,1]
				SZ8->Z8_DESCR   := aItens[nI,2]
				SZ8->Z8_UM      := aItens[nI,3]
				SZ8->Z8_P00500  := aItens[nI,4]
				SZ8->Z8_P03000  := aItens[nI,5]
				SZ8->Z8_P05000  := aItens[nI,6]
				SZ8->Z8_P20000  := aItens[nI,7]
				SZ8->Z8_P20001  := aItens[nI,8]
				
				If SZ8->Z8_PRODUTO >= MV_PAR06 .And. SZ8->Z8_PRODUTO <= MV_PAR07
					If MV_PAR01 > 0
						SZ8->Z8_P00500 := Round(SZ8->Z8_P00500 + ((SZ8->Z8_P00500 * MV_PAR01)/100),2)
					Endif
					If MV_PAR02 > 0
						SZ8->Z8_P03000 := Round(SZ8->Z8_P03000 + ((SZ8->Z8_P03000 * MV_PAR02)/100),2)
					Endif
					If MV_PAR03 > 0
						SZ8->Z8_P05000 := Round(SZ8->Z8_P05000 + ((SZ8->Z8_P05000 * MV_PAR03)/100),2)
					Endif
					If MV_PAR04 > 0
						SZ8->Z8_P20000 := Round(SZ8->Z8_P20000 + ((SZ8->Z8_P20000 * MV_PAR04)/100),2)
					Endif
					If MV_PAR05 > 0
						SZ8->Z8_P20001 := Round(SZ8->Z8_P20001 + ((SZ8->Z8_P20001 * MV_PAR05)/100),2)
					Endif
                Endif
			Endif
			
			SZ8->(dbGoTo(aItens[nI,9]))
			If RecLock("SZ8",.f.)
				SZ8->Z8_ATIVA := 'I'
				SZ8->(MsUnlock())
			Endif
		Next
	Endif                    
	
	If RecLock("SZ7",.t.)
		SZ7->Z7_FILIAL := xFilial("SZ7")
		SZ7->Z7_CODIGO := cCodigo
		SZ7->Z7_ATIVA  := 'A'
		SZ7->Z7_DESCR  := cDescri
		SZ7->Z7_DATA	:= dDataBase
		SZ7->Z7_DEFAULT	:= 'N'                   
		SZ7->(MsUnlock())
	Endif

	Aviso( 'Reajuste Tabelas', "Reajuste da Tabela Executado com Sucesso !!!", {"Ok"} )
Endif
RestArea(aArea)
SZ7->(dbSetOrder(1), dbSeek(xFilial("SZ7")+cCodigo+'A'))
Return .t.


Static Function GdChgPict(oDlg, nTipo, oPesq, cPesq, oComboBox)

Local aCombo, aX3cBox, cF3, cBox, cPicture, cAlias, cSxbRet, lGdChgPict, nLoop, nLoops, nAt

If ValType(oPesq) == "O"
	oPesq:Disable()
	oPesq:Hide()
	oPesq:End()
	oPesq := Nil
	oDlg:Refresh()
EndIf

oComboBox:Disable()
oComboBox:Hide()

If !(lGdChgPict := (nTipo > 0))
	Break
EndIf

cF3 := GetSx3Cache(aHeader[nTipo][2], "X3_F3")
If !(lGdChgPict := (cF3 <> Nil))
	Break
EndIf

If Empty(cF3)
	nAt := At("_", aHeader[nTipo][2])
	If Len(SubStr(aHeader[nTipo][2], 1, nAt)) == 3
		cAlias := "S" + SubStr(aHeader[nTipo][2], 1, nAt - 1)
	Else
		cAlias := SubStr(aHeader[nTipo][2], 1, nAt - 1)
	EndIf
	cBox := AllTrim(fDesc("SX3", aHeader[nTipo][2], "X3CBox()", Len(SX3->X3_CBOX), "", 2, .F.))
	If !Empty(cBox)
		aX3cBox	:= RetSx3Box(cBox, Nil, Nil, GetSx3Cache(aHeader[nTipo][2], "X3_TAMANHO"))
		nLoops	:= Len(aX3cBox)
		aCombo	:= Array(nLoops)
		For nLoop := 1 To nLoops
			aCombo[nLoop] := aX3cBox[nLoop, 1]
		Next nLoop
	ElseIf SXB->(dbSeek(cAlias, .F.))
		cAlias := Upper(AllTrim(cAlias))
		While SXB->(!Eof() .And. Upper(SubStr(AllTrim(XB_ALIAS), 1, 3)) == cAlias)
			If SXB->XB_TIPO == "5"
				cSxbRet := Upper(AllTrim(SXB->XB_CONTEM))
				Exit
			EndIf
			SXB->(dbSkip())
		End While
		If Upper(AllTrim(aHeader[nTipo][2])) $ cSxbRet
			cF3 := cAlias
		EndIf
	ElseIf "_FILIAL" $ Upper(AllTrim(aHeader[nTipo][2]))
		If SXB->(dbSeek("XM0", .F.))
			cF3 := "XM0"
		EndIf
	EndIf
EndIf

If aHeader[nTipo][8] <> "M"
	cPesq := CriaVar(aHeader[nTipo][2], .F.)
Else
	cPesq := Space(80)
EndIf
cPicture := aHeader[nTipo][3]

If !Empty(cBox)
	@ 022, 005 ComboBox oPesq Var cPesq Items aCombo Size 206, 10 Of oDlg Pixel
Else
	@ 022, 005 MsGet oPesq Var cPesq Size 206, 10 Picture cPicture Of oDlg Pixel
	If !Empty(cF3)
		oPesq:cF3 := cF3
	EndIf
EndIf

If aHeader[nTipo][8] $ "CM"
	oComboBox:Show()
	oComboBox:Enable()
EndIf

oDlg:Refresh()

Return(lGdChgPict)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fExistMV ºAutor  ³ Felipe A. Melo     º Data ³  03/10/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP10 - Filtro registros no Browse conforme Pergunte        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fExistMV(cMV)

Local lRet 	:= .F.
Local aAr	:= GetArea()

DbSelectArea("SX6")
SX6->(DbSetOrder(1))
If SX6->(DbSeek(xFilial("SX6")+cMV))
	lRet := .T.
Endif

RestArea(aAr)

Return(lRet)