#INCLUDE "PROTHEUS.CH"
#INCLUDE "MATA332.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ MATA332  ³ Autor ³ Microsiga S/A         ³ Data ³ 06/09/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de Ajuste Cambial (Bolivia)                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA332                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³Data    ³ BOPS     ³ Motivo da Alteracao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Jonathan Glz³08/07/15³PCREQ-4256³Se elimina la funcion AjustaSX1() que ³±±
±±³            ³        ³          ³hace modificacion a SX1 por motivo de ³±±
±±³            ³        ³          ³adecuacion a fuentes a nuevas estruc- ³±±
±±³            ³        ³          ³turas SX para Version 12.             ³±±
±±³M.Camargo   ³09.11.15³PCREQ-4262³Merge sistemico v12.1.8		           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function UMTA332()
Local nX         := 0	
Local nI         := 0
Local nTaxa2     := 0
Local nTaxa3     := 0
Local nTaxa4     := 0
Local nTaxa5     := 0
Local cTipoOper  := ''
Local cMoeda332C := GetMv('MV_MOEDACM',.F.,"2345")
Local dDtAjuste  := CTOD('  /  /  ')
Local lChkMsg    := .F.
Local oComboBox
Local oDlg
Local oChkMsg

Private a332ParamZX := Array(4)
Private cCadastro   := STR0001 //"Ajuste Cambial de Custo de Estoque"	 
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega o grupo de pergunta MTA330 somente para verificar a  ³
//| data de fechamento de estoque.                               |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("MTA330",.F.)
dDataFec  := mv_par01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega as perguntas selecionadas                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 - Do Produto                                        ³
//³ mv_par02 - Ate o Produto                                     ³
//³ mv_par03 - Do Armazem                                        ³
//³ mv_par04 - Ate o Armazem                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MTA332Perg(.F.)

dbSelectArea("SM2")
dbSetOrder(1)
If dbSeek(DTOS(dDataFec))
	nTaxa2 := SM2->M2_MOEDA2
	nTaxa3 := SM2->M2_MOEDA3
	nTaxa4 := SM2->M2_MOEDA4
	nTaxa5 := SM2->M2_MOEDA5
Else
	Aviso(STR0002,STR0003 + DTOC(dDataFec) + STR0004,{"Ok"}) //"Sem Taxa"###"Não foi localizada as taxas das moedas na data de ##/##/##. Favor verificar o cadastro de moedas ou informe a taxa de fechamento."
EndIf
	

DEFINE MSDIALOG oDlg FROM  096,9 TO 400,600 TITLE STR0005 PIXEL //"Ajuste Cambial para Custo de Estoque"
@ 011,006  TO 120,287 LABEL "" OF oDlg  PIXEL
@ 016, 015 SAY STR0006 SIZE 268, 8 OF oDlg PIXEL //"Esta rotina ira realizar o acerto cambial no custo de fechamento de estoque baseado na moeda forte informada"
@ 026, 015 SAY STR0007 SIZE 268, 8 OF oDlg PIXEL //"no cadastro do produto. Para realizar o acerto cambial serão consideradas as taxas abaixo:"

@ 046, 015 SAY STR0008 SIZE 268, 8 OF oDlg PIXEL //"Taxa da Moeda 2 :"
@ 046, 070 MSGET nTaxa2 Picture PesqPict("SM2","M2_MOEDA2") SIZE 050,10 OF oDlg PIXEL WHEN "2" $ cMoeda332C

@ 046, 130 SAY STR0009 SIZE 268, 8 OF oDlg PIXEL //"Taxa da Moeda 3 :"
@ 046, 185 MSGET nTaxa3 Picture PesqPict("SM2","M2_MOEDA3") SIZE 050,10 OF oDlg PIXEL WHEN "3" $ cMoeda332C

@ 066, 015 SAY STR0010 SIZE 268, 8 OF oDlg PIXEL //"Taxa da Moeda 4 :"
@ 066, 070 MSGET nTaxa4 Picture PesqPict("SM2","M2_MOEDA4") SIZE 050,10 OF oDlg PIXEL WHEN "4" $ cMoeda332C

@ 066, 130 SAY STR0011 SIZE 268, 8 OF oDlg PIXEL //"Taxa da Moeda 5 :"
@ 066, 185 MSGET nTaxa5 Picture PesqPict("SM2","M2_MOEDA5") SIZE 050,10 OF oDlg PIXEL WHEN "5" $ cMoeda332C

@ 086, 015 SAY STR0012 SIZE 050,10 OF oDlg PIXEL //"Tipo de Operação :"
@ 086, 070 MSCOMBOBOX oComboBox VAR cTipoOper ITEMS {STR0013,STR0014} SIZE 050,10 OF oDlg PIXEL //"Inclusao"##"Exclusao"

@ 086, 130 SAY "Dt. do movimento:" SIZE 268, 8 OF oDlg PIXEL //"Dt. do movimento:"
@ 086, 185 MSGET dDtAjuste SIZE 050,10 OF oDlg PIXEL WHEN Upper(STR0014) $ Upper(cTipoOper)

//"Exibe mensagem de movimento de variacao gerado."
@ 100,015 CheckBox oChkMsg VAR lChkMsg Prompt "Exibe mensagem de movimento de variacao gerado." SIZE 200,10 OF oDlg PIXEL WHEN Upper(STR0013) $ Upper(cTipoOper)

@ 130,015 SAY STR0015+ DTOC(dDataFec) SIZE 268, 8 OF oDlg PIXEL //"Data de Fechamento de Estoque: "


DEFINE SBUTTON FROM 133, 163 TYPE 6  ACTION MTA330Imp(.T.) ENABLE OF oDlg
DEFINE SBUTTON FROM 133, 193 TYPE 5  ACTION MTA332Perg(.T.) ENABLE OF oDlg
DEFINE SBUTTON FROM 133, 223 TYPE 1  ACTION If(MTA332TOk(dDataFec,nTaxa2,nTaxa3,nTaxa4,nTaxa5,cTipoOper,dDtAjuste),(Processa({|lEnd| MA332Process(@lEnd,cTipoOper,dDataFec,nTaxa2,nTaxa3,nTaxa4,nTaxa5,dDtAjuste,lChkMsg)},STR0016,STR0017,.F.),oDlg:End()),) ENABLE OF oDlg //"Acerto Cambial de Estoque"##"Processando ..."
DEFINE SBUTTON FROM 133, 253 TYPE 2  ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MA332Process³ Autor ³ Microsiga S/A         ³ Data ³06/09/09³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processa o ajuste de cambial para o Estoque                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd      = Variavel que controla interrupcao do processo  ³±±
±±³          ³ cTipoOper = Tipo de Operacao = Inclusao / Exclusao         ³±±
±±³          ³ dDataFec  = Data de Fechamento de Estoque                  ³±±
±±³          ³ nTaxa2    = Taxa da Moeda 2                                ³±±
±±³          ³ nTaxa3    = Taxa da Moeda 3                                ³±±
±±³          ³ nTaxa4    = Taxa da Moeda 4                                ³±±
±±³          ³ nTaxa5    = Taxa da Moeda 5                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA332                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function MA332Process(lEnd,cTipoOper,dDataFec,nTaxa2,nTaxa3,nTaxa4,nTaxa5,dDtAjuste,lChkMsg)
Local aAreaAnt   := GetArea()
Local aAreaSB2   := SB2->(GetArea())
Local aAreaSD3   := SD3->(GetArea())
Local nVFim		 := 0
Local nVFimForte := 0
Local nCusto   	 := 0
Local nX         := 0
Local nMoeda     := 1
Local aTaxa      := {1,nTaxa2,nTaxa3,nTaxa4,nTaxa5}
Local cMoeda332C := GetMv('MV_MOEDACM',.F.,"2345")
Local lCusFifo   := GetMv('MV_CUSFIFO',.F.,.F.)
Local lCusLifo   := GetMv('MV_CUSLIFO',.F.,.F.)
Local cDocumento := ''
Local cSeek      := ''
local lExclui 	 := .F.
Local aCusto     := {{0,0,0,0,0},{0,0,0,0,0}}
Local lAchou     := .F.

Default lChkMsg := .F.

Private l240Auto := .T.
Private cCusMed  := GetMv("MV_CUSMED")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estas variaveis indicam para as funcoes de validacao qual    ³
//³ programa as esta' chamando                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private l240:=.T.,l250:=.F.,l241:=.F.,l242:=.F.,l261:=.F.,l185 :=.F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega as perguntas selecionadas                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MTA332Perg(.F.)

dbSelectArea("SB2")
dbSetOrder(1)
dbGoTop()
Do While !Eof() 

	IncProc(STR0018) //"Processando Ajuste Cambial ..."
	
	If lEnd
		@PROW()+1,001 PSay STR0019 //"CANCELADO PELO OPERADOR"
		Exit
	EndIf

	If SB2->B2_COD < a332ParamZX[1] .Or. SB2->B2_COD > a332ParamZX[2]
		dbSkip()
		Loop
	EndIf	
	If SB2->B2_LOCAL < a332ParamZX[3] .Or. SB2->B2_LOCAL > a332ParamZX[4]
		dbSkip()
		Loop
	EndIf	

	//-- Posiciona na tabela SB1
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+SB2->B2_COD)

	//-- Processa Inclusao do ajuste cambial  
	If Upper(cTipoOper) == Upper(STR0013) //"INCLUSAO"

		// Verifica se ja foi processado o ajuste cambial para o produto
		lAchou := .F.
		dbSelectArea("SD3")
		dbSetOrder(7)
		dbSeek(cSeek:=xFilial("SD3")+SB2->B2_COD+SB2->B2_LOCAL+DTOS(dDataFec + 1))
		Do While !Eof() .And. cSeek == SD3->D3_FILIAL+SD3->D3_COD+SD3->D3_LOCAL+DTOS(SD3->D3_EMISSAO)
			If (SD3->D3_CF $ 'RE6|DE6') .And. SD3->D3_STATUS == 'AC' .And. SD3->D3_ESTORNO # 'S'
				lAchou := .T.
				Exit
			EndIf
			dbSkip()
		EndDo
		
		// Emite alerta ao usuario caso seja especificado
		dbSelectArea("SB2")
		If lAchou
			If lChkMsg
				//Aviso(STR0031,STR0032+AllTrim(SB1->B1_COD)+"-"+AllTrim(SB1->B1_DESC)+STR0033,{"OK"})
				Aviso(AllTrim(SB1->B1_COD)+"-"+AllTrim(SB1->B1_DESC),{"OK"})
			EndIf
			dbSkip()
			Loop
		EndIf
		
		// Restaura a area correta
		dbSelectArea("SB1")
		
		//-- Reinicia variaveis
		aCusto := {{0,0,0,0,0},{0,0,0,0,0}}
		//-- Obtenho o valor atual da moeda 2 atraves da taxa informada
		Do Case
			Case SB1->B1_MFORTE $ '1| '
				nVfimForte	:=	SB2->B2_VFIM1			
				nMoeda	:=	1
			Case SB1->B1_MFORTE == '2'
				nVfimForte	:=	SB2->B2_VFIM2			
				nMoeda	:=	2
			Case SB1->B1_MFORTE == '3'
				nVfimForte	:=	SB2->B2_VFIM3
				nMoeda	:=	3
			Case SB1->B1_MFORTE == '4'
				nVfimForte	:=	SB2->B2_VFIM4			
				nMoeda	:=	4
			Case SB1->B1_MFORTE == '5'
				nVfimForte	:=	SB2->B2_VFIM5			
				nMoeda	:=	5
		EndCase			

		//Acerta moeda 1
		If SB1->B1_MFORTE <> '1'
			nVFim  := xMoeda(nVfimForte,nMoeda,1,dDataFec,MsDecimais(1),aTaxa[nMoeda])
			nCusto := nVFim - SB2->B2_VFIM1
			If nCusto > 0
				aCusto[1,1] := nCusto
			Else
				aCusto[2,1] := nCusto
			EndIf
		Endif
		//Acerta moeda 2
		If	SB1->B1_MFORTE <> "2" .And. "2"$ cMoeda332C
			nVFim  := xMoeda(nVfimForte,nMoeda,2,dDataFec,MsDecimais(2),aTaxa[nMoeda],aTaxa[2])
			nCusto := nVFim - SB2->B2_VFIM2
			If nCusto > 0
				aCusto[1,2] := nCusto
			Else
				aCusto[2,2] := nCusto
			EndIf
		EndIf	
		//Acerta moeda 3
		If	SB1->B1_MFORTE <> "3" .And. "3"$ cMoeda332C
			nVFim  := xMoeda(nVfimForte,nMoeda,3,dDataFec,MsDecimais(3),aTaxa[nMoeda],aTaxa[3])
			nCusto := nVFim - SB2->B2_VFIM3
			If nCusto > 0
				aCusto[1,3] := nCusto
			Else
				aCusto[2,3] := nCusto
			EndIf
		EndIf	

		//Acerta moeda 4
		If	SB1->B1_MFORTE <> "4" .And. "4"$ cMoeda332C
			nVFim  := xMoeda(nVfimForte,nMoeda,4,dDataFec,MsDecimais(4),aTaxa[nMoeda],aTaxa[4])
			nCusto := nVFim - SB2->B2_VFIM4
			If nCusto > 0
				aCusto[1,4] := nCusto
			Else
				aCusto[2,4] := nCusto
			EndIf
		EndIf	

		//Acerta moeda 5
		If	SB1->B1_MFORTE <> "5" .And. "5"$ cMoeda332C
			nVFim  := xMoeda(nVfimForte,nMoeda,5,dDataFec,MsDecimais(5),aTaxa[nMoeda],aTaxa[5])
			nCusto := nVFim - SB2->B2_VFIM5
			If nCusto > 0
				aCusto[1,5] := nCusto
			Else
				aCusto[2,5] := nCusto
			EndIf                             
		EndIf	
		//-- Processando o ajuste cambial de estoque
		For nX := 1 to Len(aCusto)
			If aCusto[nX,1] == 0 .And. ;
			   aCusto[nX,2] == 0 .And. ;
			   aCusto[nX,3] == 0 .And. ;
			   aCusto[nX,4] == 0 .And. ;
			   aCusto[nX,5] == 0
				Loop
			EndIf
			Begin Transaction
				cDocumento := NextNumero("SD3",2,"D3_DOC",.T.)
				RecLock("SD3",.T.)
				SD3->D3_FILIAL	:= xFilial("SD3")
				SD3->D3_COD		:= SB2->B2_COD
				SD3->D3_TM		:= IIf(nX == 1,"499","999")
				SD3->D3_LOCAL	:= SB2->B2_LOCAL
				SD3->D3_DOC		:= cDocumento
				SD3->D3_EMISSAO	:= dDataFec + 1 // por padrao sera o dia seguinte ao recalculo
				SD3->D3_NUMSEQ	:= ProxNum()
				SD3->D3_UM		:= SB1->B1_UM
				SD3->D3_GRUPO	:= SB1->B1_GRUPO
				SD3->D3_TIPO	:= SB1->B1_TIPO
				SD3->D3_SEGUM	:= SB1->B1_SEGUM
				SD3->D3_CONTA	:= SB1->B1_CONTA
				SD3->D3_CF		:= IIf(nX == 1,"DE6","RE6")
				SD3->D3_STATUS	:= "AC" //AJUSTE CAMBIAL
				SD3->D3_USUARIO	:= SubStr(cUsuario,7,15)
				SD3->D3_CUSTO1	:= Abs(aCusto[nX,1])
				SD3->D3_CUSTO2	:= Abs(aCusto[nX,2])
				SD3->D3_CUSTO3	:= Abs(aCusto[nX,3])
				SD3->D3_CUSTO4	:= Abs(aCusto[nX,4])
				SD3->D3_CUSTO5	:= Abs(aCusto[nX,5])
				SD3->D3_SEQCALC := DTOS(dDataFec)+"999999"
				MsUnLock()
				dbSelectArea("SB2")
				B2AtuComD3({SD3->D3_CUSTO1,SD3->D3_CUSTO2,SD3->D3_CUSTO3,SD3->D3_CUSTO4,SD3->D3_CUSTO5})
				MsUnLock()
				RecLock("SB2",.F.)
				Replace B2_VFIM1 With B2_VFIM1 + aCusto[nX,1]
				Replace B2_VFIM2 With B2_VFIM2 + aCusto[nX,2]
				Replace B2_VFIM3 With B2_VFIM3 + aCusto[nX,3]
				Replace B2_VFIM4 With B2_VFIM4 + aCusto[nX,4]
				Replace B2_VFIM5 With B2_VFIM5 + aCusto[nX,5]
				MsUnLock()
				If lCusFifo .Or. lCusLifo
					If SD3->D3_TM < '501'
						//-- Atualizacao do Lote FIFO/LIFO
						GravaSBD("SD3",{SD3->D3_CUSTO1,SD3->D3_CUSTO2,SD3->D3_CUSTO3,SD3->D3_CUSTO4,SD3->D3_CUSTO5},,,,.T.)
					Else
						//-- Baixa do Lote FIFO/LIFO
						BaixaSBD('SD3',Nil,SD3->D3_CF=='RE5',SD3->D3_CF=='RE6',.T.)
					EndIf	
				EndIf
			End Transaction
		Next nX	
	
	ElseIf Upper(cTipoOper) == Upper(STR0014) //"EXCLUSAO"
	    
		dbSelectArea("SD3")
		dbSetOrder(7)
		dbSeek(cSeek:=xFilial("SD3")+SB2->B2_COD+SB2->B2_LOCAL+DTOS(dDtAjuste))
		Do While !Eof() .And. cSeek == SD3->D3_FILIAL+SD3->D3_COD+SD3->D3_LOCAL+DTOS(SD3->D3_EMISSAO)
			If SD3->D3_ESTORNO == 'S' .Or.;
			   !(SD3->D3_CF $ 'RE6|DE6') .Or.;
			   SD3->D3_STATUS # 'AC'
				dbSkip()
				Loop
			EndIf            
			lExclui := .T.
			Begin Transaction
				If SD3->D3_CF == "RE6"
					RecLock("SB2",.F.)
					Replace B2_VFIM1 With B2_VFIM1 + SD3->D3_CUSTO1
					Replace B2_VFIM2 With B2_VFIM2 + SD3->D3_CUSTO2
					Replace B2_VFIM3 With B2_VFIM3 + SD3->D3_CUSTO2
					Replace B2_VFIM4 With B2_VFIM4 + SD3->D3_CUSTO4
					Replace B2_VFIM5 With B2_VFIM5 + SD3->D3_CUSTO5
					MsUnLock()
				ElseIf SD3->D3_CF == "DE6"
					RecLock("SB2",.F.)
					Replace B2_VFIM1 With B2_VFIM1 - SD3->D3_CUSTO1
					Replace B2_VFIM2 With B2_VFIM2 - SD3->D3_CUSTO2
					Replace B2_VFIM3 With B2_VFIM3 - SD3->D3_CUSTO3
					Replace B2_VFIM4 With B2_VFIM4 - SD3->D3_CUSTO4
					Replace B2_VFIM5 With B2_VFIM5 - SD3->D3_CUSTO5
					MsUnLock()
				EndIf 
				dbSelectArea("SD3")
				a240Estorn("SD3",SD3->(Recno()),4) //-- Estornar Movimentos
				If lCusFifo .Or. lCusLifo
					If SD3->D3_TM < '501'
						//-- Atualizacao do Lote FIFO/LIFO
						GravaSBD("SD3",{SD3->D3_CUSTO1,SD3->D3_CUSTO2,SD3->D3_CUSTO3,SD3->D3_CUSTO4,SD3->D3_CUSTO5},,,,.T.)
					Else
						//-- Baixa do Lote FIFO/LIFO
						BaixaSBD('SD3',Nil,SD3->D3_CF=='RE5',SD3->D3_CF=='RE6',.T.)
					EndIf	
				EndIf
			End Transaction
			dbSkip()
		EndDo
	EndIf
	dbSelectArea("SB2")
	dbSkip()
EndDo


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se foi executado procedimento de exclusao/estorno e caso    ³
//³nao tenha encontrado nenhum movimento para excluir/estornar ³
//³entao emite alerta                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Upper(cTipoOper) == Upper(STR0014) .And. !lExclui
	Aviso("Sin Movimientos","No fueron encontrados movimientos en la fecha " + DTOC(dDtAjuste),{"Ok"}) //"Sin Movimientos" // "No fueron encontrados movimientos en la fecha "
EndIf

RestArea(aAreaSB2)
RestArea(aAreaSD3)
RestArea(aAreaAnt)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MTA332TOk ³ Autor ³Microsiga S/A          ³ Data ³ 06/09/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida se pode efetuar o ajuste cambial de estoque          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ dDataFec  = Data de Fechamento de Estoque                  ³±±
±±³          ³ nTaxa2    = Taxa da Moeda 2                                ³±±
±±³          ³ nTaxa3    = Taxa da Moeda 3                                ³±±
±±³          ³ nTaxa4    = Taxa da Moeda 4                                ³±±
±±³          ³ nTaxa5    = Taxa da Moeda 5                                ³±±
±±³          ³ cTipoOper = Tipo de Operacao = Inclusao / Exclusao         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA332                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MTA332TOk(dDataFec,nTaxa2,nTaxa3,nTaxa4,nTaxa5,cTipoOper,dDtAjuste)
Local aAreaAnt   := GetArea()
Local aAreaSD3   := SD3->(GetArea())
Local dUlMes     := GetMv("MV_ULMES",.F.,.F.)
Local cMoeda332C := GetMv('MV_MOEDACM',.F.,"2345")
Local lRet       := .T.
Local cSeek      := ''

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega as perguntas selecionadas                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MTA332Perg(.F.)

//-- Verifica se existem os campos utilizados para o ajuste cambial
If SB1->(FieldPos("B1_MFORTE")) <= 0 .Or. SD3->(FieldPos("D3_STATUS")) <= 0
	Help(" ",1,"A332MFORTE")
	lRet := .F.
EndIf

//If lRet //.And. cPaisLoc # "BOL"
//	Help(" ",1,"A332NOBOL")
//	lRet := .F.
//EndIf

//-- Verifica se a data de fechamento esta correta
If lRet .And. dUlMes > dDataFec
	Help(" ",1,"A332DTFEC")
	lRet := .F.
EndIf

//-- Verifica se a taxa das moedas foram informadas
If Upper(cTipoOper) == Upper(STR0013) //"INCLUSAO"
	If lRet .And. nTaxa2 == 0     .And. "2" $ cMoeda332C
		Help(" ",1,"A332TAXA2")
		lRet := .F.
	ElseIf lRet .And. nTaxa3 == 0 .And. "3" $ cMoeda332C
		Help(" ",1,"A332TAXA3")
		lRet := .F.
	ElseIf lRet .And. nTaxa4 == 0 .And. "4" $ cMoeda332C
		Help(" ",1,"A332TAXA4")
		lRet := .F.
	ElseIf lRet .And. nTaxa5 == 0 .And. "5" $ cMoeda332C
		Help(" ",1,"A332TAXA5")
		lRet := .F.
	EndIf
EndIf	

//-- Verifica se pode incluir um novo ajuste cambial
If lRet .And. Upper(cTipoOper) == Upper(STR0013) //"INCLUSAO"
	dbSelectArea("SD3")
	dbSetOrder(6)
	dbSeek(cSeek:=xFilial("SD3")+DTOS(dDataFec))
	Do While !Eof() .And. cSeek == SD3->D3_FILIAL+DTOS(SD3->D3_EMISSAO)
		If SD3->D3_ESTORNO == 'S' .Or. !(SD3->D3_CF $ 'RE6|DE6')
			dbSkip()
			Loop
		EndIf
		If SD3->D3_COD < a332ParamZX[1] .Or. SD3->D3_COD > a332ParamZX[2]
			dbSkip()
			Loop
		EndIf	
		If SD3->D3_LOCAL < a332ParamZX[3] .Or. SD3->D3_LOCAL > a332ParamZX[4]
			dbSkip()
			Loop
		EndIf	
		If SD3->D3_STATUS == 'AC'
			Help(" ",1,"A332EXIST")
			lRet := .F.
			Exit
		EndIf
		dbSkip()
	EndDo	
EndIf

If lRet .And. Upper(cTipoOper) == Upper(STR0014) // EXCLUSAO
	If Empty(dDtAjuste)
		Help(" ",1,"A332DTAJU")
		lRet := .F.
	EndIf
EndIf

RestArea(aAreaSD3)
RestArea(aAreaAnt)
Return lRet 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MTA330Imp ³ Autor ³Microsiga S/A          ³ Data ³ 06/09/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao do acerto de cambial de Estoque                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA332                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MTA330Imp()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis obrigatorias dos programas de relatorio            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local titulo   := STR0020 //"Relatorio de Conferencia de Custo de Fechamento"
Local cDesc1   := STR0021 //"O relatorio ira listar o custo de fechamento de estoque para conferencia dos"
Local cDesc2   := STR0022 //"valores ajustados pela rotina 'Ajuste Cambial de Estoque'."
Local cString  := "SB2"
Local wnrel    := "MATA332"
Local cPerg    := "MTR332"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Private padrao de todos os relatorios         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aReturn := {STR0023,1,STR0024, 2, 2, 1, "", 1 } //"Zebrado"###"Administracao"
PRIVATE nLastKey:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,,.F.,/*aOrd*/,/*lCompres*/,/*cSize*/,/*aFilter*/,.F.)

If nLastKey = 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter to
	Return
Endif

RptStatus({|lEnd| A332Rel(@lEnd,wnRel,titulo,dDataFec)},titulo)


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A332Rel   ³ Autor ³Microsiga S/A          ³ Data ³ 06/09/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao do relatorio de ajuste cambial de estoque         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA332                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A332Rel(lEnd,wnrel,titulo,dDataFec)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis locais exclusivas deste programa                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local Tamanho  := "G"
Local nTipo    := 0
Local nCntImpr := 0
Local cPictQFim  := PesqPict("SB2","B2_QFIM" )
Local cPictVFim1 := PesqPict("SB2","B2_VFIM1")
Local cPictVFim2 := PesqPict("SB2","B2_VFIM2")
Local cPictVFim3 := PesqPict("SB2","B2_VFIM3")
Local cPictVFim4 := PesqPict("SB2","B2_VFIM4")
Local cPictVFim5 := PesqPict("SB2","B2_VFIM5")
Local cRodaTxt := STR0025 //"REGISTRO(S)"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os codigos de caracter Comprimido/Normal da impressora ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTipo := IIF(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Contadores de linha e pagina                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private li    := 80
Private m_pag := 01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega as perguntas selecionadas                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("MTR332",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o cabecalho.                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//                   01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                            1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
cabec1 := STR0026 //"DATA      FL  PRODUTO         AMZ QTDE FECHAMENTO     CUSTO FECHAMENTO    CUSTO FECHAMENTO    CUSTO FECHAMENTO    CUSTO FECHAMENTO    CUSTO FECHAMENTO "
cabec2 := STR0027 //"EMISSAO                                                        MOEDA 1             MOEDA 2             MOEDA 3             MOEDA 4             MOEDA 5 "

dbSelectArea("SB2")
dbSetOrder(1)
dbGoTop()
Do While !Eof() 
	If lEnd
		@ Prow()+1,001 PSAY STR0019 //"CANCELADO PELO OPERADOR"
		Exit
	EndIf
	If SB2->B2_COD < mv_par01 .Or. SB2->B2_COD > mv_par02
		dbSkip()
		Loop
	EndIf	
	If SB2->B2_LOCAL < mv_par03 .Or. SB2->B2_LOCAL > mv_par04
		dbSkip()
		Loop
	EndIf	
	If li > 58
		cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
	EndIf
	@ Li, 000 PSay DTOC(dDataFec)
	@ Li, 010 PSay SB2->B2_FILIAL
	@ Li, 014 PSay SB2->B2_COD
	@ Li, 030 PSay SB2->B2_LOCAL
	@ Li, 037 PSay SB2->B2_QFIM  Picture cPictQFim
	@ Li, 054 PSay SB2->B2_VFIM1 Picture cPictVFim1
	@ Li, 074 PSay SB2->B2_VFIM2 Picture cPictVFim2
	@ Li, 094 PSay SB2->B2_VFIM3 Picture cPictVFim3
	@ Li, 114 PSay SB2->B2_VFIM4 Picture cPictVFim4
	@ Li, 134 PSay SB2->B2_VFIM5 Picture cPictVFim5
	Li++
	dbSelectArea("SB2")
	dbSkip()
EndDo

If li != 80
	Roda(nCntImpr,cRodaTxt,Tamanho)
EndIf

Set Device to Screen

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
EndIf

MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MTA332PERG³ Autor ³ Microsiga S/A         ³ Data ³ 08/09/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chama a pergunte para o programa e inicializa variaveis    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MTA332Perg()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lTela = Variavel que verifica se visualiza na tela         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA332                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MTA332Perg(lTela)
Local ni      := 0

Default lTela := .T.

If lTela
	If pergunte("MTA332",.T.)
		For ni := 1 to 4
			a332ParamZX[ni] := &("mv_par"+StrZero(ni,2))
		Next ni
	Else
		Return .F.
	EndIf      
Else
	Pergunte("MTA332",.F.)
	For ni := 1 to 4
		a332ParamZX[ni] := &("mv_par"+StrZero(ni,2))
	Next ni
EndIf

Return .T.
