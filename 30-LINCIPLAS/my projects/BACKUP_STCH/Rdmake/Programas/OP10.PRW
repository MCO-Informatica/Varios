#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao     ³ OP10    ³ Autor ³ Carlos N. Puerta       ³ Data ³ 09.07.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao  ³ Emissao das OPs                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe    ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Parametros ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ PCP                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function OP10()

Private _aArea      := GetArea()

Private aOrd        := {}
Private CbTxt       := ""
Private cDesc1      := Padc("Este Programa Ira Emitir as Ordens De Producao Com",74)
Private cDesc2      := Padc("Observacoes e Outros Dados Adicionais",74)
Private cDesc3      := ""
Private lEnd        := .F.
Private lAbortPrint := .F.
Private Limite      := 132
Private Tamanho     := "G"
Private Nomeprog    := "OP10"     // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 15
Private aReturn     := {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private _cPerg      := "OP10      "
Private Titulo      := Padc("Ordem de Producao",74)
Private Lin         := 0
Private Cabec1      := ""
Private Cabec2      := ""
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private Imprime     := .T.
Private wnrel       := "OP10"     // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString     := "SC2"
Private _cCodProd   := ""
Private _cDescricao := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ValidPerg()
Pergunte(_cPerg,.F.)              // Pergunta no SX1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,_cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey == 27
	RestArea(_aArea)
	Return
Endif

_lRetorno := .T.
If MV_PAR02 < MV_PAR01
	MsgBox("A Ordem de Producao Final eh menor que a Ordem de Producao Inicial","Atencao")
	Return
Else
	dbSelectArea("SC2")
	dbSetOrder(1)
	dbGoTop()
	If !dbSeek(xFilial("SC2")+MV_PAR01) .And. !Empty(MV_PAR01)
		MsgBox("A Ordem de Producao "+mv_par01+" nao existe !!! Verifique o conteudo do parametro de Ordem de Producao Inicial")
		Return
	Endif
Endif

Processa({|| Impressao()},"Aguarde a Selecao dos Registros")

RestArea(_aArea)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ IMPRESSAO ³ Autor ³ Carlos N. Puerta     ³ Data ³ 09/07/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera a Impressao do Relatorio                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impressao
SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

dbSelectArea("SC6")
dbSetOrder(2)                     // muda a ordem do indice para 2
dbSeek(xFilial("SC6")+MV_PAR01,.T.)

dbSelectArea("SC2")
dbSetOrder(6)                     // C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_PRODUTO+C2_ITEMGRD
ProcRegua(Val(MV_PAR02)-Val(MV_PAR01))

dbSeek(xFilial("SC2")+MV_PAR01,.T.)

_lImpCab  := .T.
_nNumVia  := Space(06)
_aOPSVIAS := {}

Do While SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN >= mv_par01 .AND.;
	SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN <= mv_par02 .AND. !EOF()
	
	If SC2->C2_EMISSAO < MV_PAR03
		DbSkip()
		Loop
	Endif
	
	If SC2->C2_EMISSAO > MV_PAR04
		DbSkip()
		Loop
	Endif
	
	IncProc(OemToAnsi("Imprimindo a Ordem de Producao : "+SC2->C2_NUM))
	
	_cProduto := SC2->C2_PRODUTO
	
	dbSelectArea("SG1")
	dbSetOrder(1)
	
	dbSeek(xFilial("SG1")+_cProduto)
	
	Do While SG1->G1_COD == _cProduto
		
		IncProc(OemToAnsi("Processando : "+Alltrim(SC2->C2_NUM)+" / "+Alltrim(SG1->G1_COD)+" / "+Alltrim(SG1->G1_COMP)))
		
		dbSelectArea("SG1")
		_nRegSG1 := RecNo()
		
		If _lImpCab
			_lImpCab := .F.
			
			_cCodProd := SC2->C2_PRODUTO
			DescProd()
			
			dbSelectArea("SB5")
			If dbSeek(xFilial("SB5")+_cCodProd)
				_cString := Alltrim(Str(SB5->B5_COMPR)) + " X " + Alltrim(Str(SB5->B5_LARG)) + " X " + Alltrim(Str(SB5->B5_ESPESS))
				_cDesen  := Alltrim(SB5->B5_DES)
			Else
				_cString := " "
				_cDesen  := " "
			Endif
			
			If !Empty(SC2->C2_PEDIDO) .And. Substr(SC2->C2_PRODUTO,1,1) == "Y"
				dbSelectArea("SC6")
				dbSeek(xFilial("SC6")+SC2->C2_PRODUTO+SC2->C2_PEDIDO+SC2->C2_ITEMPV)
				_cDescricao := SC6->C6_DESCRI
			EndIf
			
			dbSelectArea("SG1")
			dbSeek(xFilial("SG1")+_cCodProd)
			
			@ lin,00 PSAY Replicate("*",81)
			lin := lin + 1
			
			@ lin,00 PSAY Substr(SM0->M0_NOME,1,30)+"        O R D E M      D E    P R O D U C A O          "+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
			lin := lin + 1
			
			@ lin,00 PSAY Replicate("*",81)
			lin := lin + 1
			
			@ lin,00 PSAY "Produto   : " + _cCodProd + _cDescricao
			lin := lin + 1
			
			@ lin,00 PSAY "Emissao : " + Dtoc(SC2->C2_EMISSAO) // + Space(35) + "Inicio          Fim"
//			_nNumVia := STRZERO((val(SC2->C2_CERQUA) + 1),6)
//			@ lin,00 PSAY "Emissao   : " + Dtoc(SC2->C2_EMISSAO) + Space(36) + "Via numero "+_nNumVia
			lin := lin + 1
//			If _nNumVia <> "000001"
//				AAdd(_aOPSVIAS,{SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN,_nNumVia})
//			EndIf
			
			@ lin,00 PSAY "Quantidade: " + Str(SC2->C2_QUANT,7) + " " + SC2->C2_UM + "(s)" + "    C.Custo : " + SC2->C2_CC
			@ lin,54 PSAY "Inicio        Fim"
			lin := lin + 1
			
			//@ lin,00 PSAY "Dimensao  : " + _cString
			//@ lin,45 PSAY "Prev.: " + Dtoc(SC2->C2_DATPRI) + " - " + Dtoc(SC2->C2_DATPRF)
   			@ lin,00 PSAY "Real.: " + "  /  /     -   /  /    "
   			@ lin,45 PSAY "Prev.: " + Dtoc(SC2->C2_DATPRI) + " - " + Dtoc(SC2->C2_DATPRF)
			lin := lin + 1
			
			//@ lin,00 PSAY "Desenho   : " + _cDesen
			//@ lin,45 PSAY "Real.: " + "  /  /     -   /  /    "
			//lin := lin + 1
			
			@ lin,00 PSAY "Obs. OP   : " + SC2->C2_OBS
			lin := lin + 1
			
			If SM0->M0_CODIGO == "09"
				If !(Empty(SC2->C2_FURACAO))
					@lin,00 PSAY "Furação   : " + SC2->C2_FURACAO
					lin := lin + 1
				Endif
				
				If !Empty(SC2->C2_OPSAGL)
					@ lin,00 PSAY "OPs.Aglut.: " + SC2->C2_OPSAGL
					lin := lin + 1
				EndIf
			EndIf
			
			@ lin,00 PSAY Replicate("*",81)
			lin := lin + 1
			
			/*/@ lin,00 PSAY "CONTROLE DE QUALIDADE: "
			@ lin,57 PSAY "S E M A N A : " + mv_par06
			lin := lin + 1
			
			@ lin,00 PSAY Replicate("-",75)
			lin := lin + 1/*/
			
			@ lin,00 PSAY "Codigo           Descricao                                   Quantidade    UM"
			lin := lin + 1
			@ lin,00 PSAY Replicate("*",81)
			lin := lin + 1
		Endif
		
		dbSelectArea("SG1")
		dbGoTo(_nRegSG1)
		
		_cCodProd := SG1->G1_COMP
		DescProd()
		
		lin := lin + 1
		@ lin,00 PSAY Substr(SG1->G1_COMP,1,15) + "  " + _cDescricao + "        " + Str((SC2->C2_QUANT*SG1->G1_QUANT),10,2) + "          " + SB1->B1_UM
		//@ lin,00 PSAY Substr(SG1->G1_COMP,1,9) + "  " + _cDescricao + "  " + Str((SC2->C2_QUANT*SG1->G1_QUANT),10,2) + "    " + SB1->B1_UM
		//lin := lin + 1
		
		/*/@ lin,00 PSAY "Obs. Operacao : " + SG1->G1_OBSERV
		lin := lin + 1/*/
		//@ lin,00 PSAY Replicate("-",81)
		
		dbSelectArea("SG1")
		dbSkip()
	Enddo
	
	lin      := lin + 1
	@ lin,00 PSAY Replicate(".",81)
	
	lin      := lin + 2
	_lImpCab := .T.
	
	dbSelectArea("SC2")
//	RecLock("SC2",.F.)
//	SC2->C2_CERQUA := _nNumVia
//	MsUnlock()
	dbSkip()
Enddo
/*/
If Len(_aOPSVIAS) > 0
	lin     := lin + 3
	_nI     := 0
	//                   1         2         3         4         5         6         7         8
	//          12345678901234567890123456789012345678901234567890123456789012345678901234567890
	_cCabF  := "Ordem Producao  VIA          Ordem Producao  VIA          Ordem Producao  VIA"
	//          123456-12-123   000001       123456-12-123   000002       123456-12-123   000001
	//
	@ lin,00 PSAY _cCabF
	_nCol   := 0
	_nResto := 0
	
	For _nI := 1 To Len(_aOPSVIAS)
		_nResto := Mod(_nI,3)
		If _nI == 1 .Or. _nResto == 1
			lin   := lin + 1
			_nCol := 0
			@ lin,_nCol PSAY _aOPSVIAS[_nI,1]+"   "+_aOPSVIAS[_nI,2]
		Else
			If _nI == 2 .Or. _nResto == 2
				_nCol := _nCol + 29
				@ lin,_nCol PSAY _aOPSVIAS[_nI,1]+"   "+_aOPSVIAS[_nI,2]
			Else
				If _nResto == 0
					_nCol := _nCol + 29
					@ lin,_nCol PSAY _aOPSVIAS[_nI,1]+"   "+_aOPSVIAS[_nI,2]
				EndIf
			EndIf
		EndIf
	Next
EndIf
/*/
SetPrc(0,0)                  // (Zera o Formulario)
Set Device To Screen
If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	Ourspool(wnrel)
Endif
MS_FLUSH()
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ValidPerg ³ Autor ³  Luiz Carlos Vieira   ³ Data ³ 03/07/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica as perguntas incluindo-as caso nao existam        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Diversos programas especificos                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg()
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)

_cPerg := PADR(_cPerg,10)
aRegs:={}
//          01     02   03                      04                      05                      06       07  08 9 0 11  12 13         14                 15 16 17 18 19               20 21 22 23 24                25 26 27 28 29 30 31 32 33 34 35 36 37 38    39 40 41 42 43
AADD(aRegs,{_cPerg,"01","Da O.P.             ?","Da O.P.             ?","Da O.P.             ?","mv_ch1","C",11,0,0,"G","","mv_par01","                ","","","","","              ","","","","","               ","","","","","","","","","","","","","","SC2","","","","",""})
AADD(aRegs,{_cPerg,"02","Ate a O.P.          ?","Ate a O.P.          ?","Ate a O.P.          ?","mv_ch2","C",11,0,0,"G","","mv_par02","                ","","","","","              ","","","","","               ","","","","","","","","","","","","","","SC2","","","","",""})
AADD(aRegs,{_cPerg,"03","Da data             ?","Da data             ?","Da data             ?","mv_ch3","D", 8,0,0,"G","","mv_par03","                ","","","","","              ","","","","","               ","","","","","","","","","","","","","","   ","","","","",""})
AADD(aRegs,{_cPerg,"04","Ate a data          ?","Ate a data          ?","Ate a data          ?","mv_ch4","D", 8,0,0,"G","","mv_par04","                ","","","","","              ","","","","","               ","","","","","","","","","","","","","","   ","","","","",""})
AADD(aRegs,{_cPerg,"05","Descricao Produto   ?","Descricao Produto   ?","Descricao Produto   ?","mv_ch7","N", 1,0,3,"C","","mv_par05","Descr.Cientifica","","","","","Descr.Generica","","","","","Descr.Ped.Venda","","","","","","","","","","","","","","   ","","","","",""})
AADD(aRegs,{_cPerg,"06","Numero da Semana    ?","Numero da Semana    ?","Numero da Semana    ?","mv_cha","C", 2,0,0,"G","","mv_par06","                ","","","","","              ","","","","","               ","","","","","","","","","","","","","","   ","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(_cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)
Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ DESCPROD ³ Autor ³ Carlos N. Puerta      ³ Data ³ 09/07/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Posiciona os produtos para pegar as descricoes corretas    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function DescProd()
_aArea01 := GetArea()

If MV_PAR05 == 1
	dbSelectArea("SB5")
	dbSetOrder(1)
	If dbSeek(xFilial("SB5")+_cCodProd)
		_cDescricao := Substr(SB5->B5_CEME,1,45)
	EndIf
EndIf

If MV_PAR05 == 2
	dbSelectArea("SB1")
	dbSetOrder(1)
	If dbSeek(xFilial("SB1")+_cCodProd)
		_cDescricao := SB1->B1_DESC
	EndIf
EndIf

If MV_PAR05 == 3
	dbSelectArea("SC6")
	dbSetOrder(2)
	//	If Empty(SC2->C2_SECPED) .Or. Empty(SC2->C2_SECIPV)
	If Empty(SC2->C2_PEDIDO) .Or. Empty(SC2->C2_ITEMPV)
		If dbSeek(xFilial("SC6")+_cCodProd+SC2->C2_NUM+SC2->C2_ITEM)
			_cDescricao := Substr(SC6->C6_DESCRI,1,45)
		Else
			dbSelectArea("SB1")
			dbSetOrder(1)
			If dbSeek(xFilial("SB1")+_cCodProd)
				_cDescricao := SB1->B1_DESC
			EndIf
		EndIf
	Else
		If dbSeek(xFilial("SC6")+_cCodProd+SC2->C2_PEDIDO+SC2->C2_ITEMPV)
			_cDescricao := Substr(SC6->C6_DESCRI,1,45)
		Else
			dbSelectArea("SB1")
			dbSetOrder(1)
			If dbSeek(xFilial("SB1")+_cCodProd)
				_cDescricao := SB1->B1_DESC
			EndIf
		EndIf
	EndIf
	//	Else
	//		If dbSeek(xFilial("SC6")+_cCodProd+SC2->C2_SECPED+SC2->C2_SECIPV)
	//			_cDescricao := Substr(SC6->C6_DESCRI,1,45)
	//		Else
	//			dbSelectArea("SB1")
	//			dbSeek(xFilial("SB1")+_cCodProd)
	//			_cDescricao := SB1->B1_DESC
	//		EndIf
	//	EndIf
EndIf

RestArea(_aArea01)
Return
