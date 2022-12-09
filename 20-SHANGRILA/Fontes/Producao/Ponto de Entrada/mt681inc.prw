#Include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MT681INC ³ Autor ³Ricardo Correa de Souza³ Data ³ 19/07/2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Chama as Rotinas de Apontamento de Perdas / Apontamento de   ³±±
±±³          ³ Horas Improdutivas e Impressao do Saldo das Operacoes.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ Chamado Apos a Confirmacao do Apontamento de Producao        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Shangri-la                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³             ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador   ³  Data  ³              Motivo da Alteracao                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                                 ³±±
±±³              ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function MT681INC()

Local _aArea 		:=		GetArea()
Local _nApontHrs	:=		0
Local _nApontPer	:=		0
Local _nRecSH6		:=		0

LOCAL aVetor		:= {}
local aEmpen		:={}
local aAreaSH6	:= SH6->(GetArea())
local aAreaSC2	:= SC2->(GetArea())
local aAreaSD3	:= SD3->(GetArea())
local aAreaSD4	:= SD4->(GetArea())

Private lMSHelpAuto := .T.
Private lMSErroAuto := .F.

Private aAcho		:=		{}
Private _cRecurso
Private _cFerram
Private _cCtrab
Private _cProdRot
Private _cOPSD3
Private _cOPSH6
Private _nH6Vol
Private _nH6QVol
Private _cD3CF
Private nOpca := 1 ,nOpc := 1
Private _nOpInc		:= 		0
Private cPicOP		:=PesqPict("SBC","BC_OP")
Private cPicProd	:=PesqPict("SBC","BC_PRODUTO")
Private cPicRec		:=PesqPict("SBC","BC_RECURSO")
Private cPicOperac	:=PesqPict("SBC","BC_OPERAC")
//Private cPicQtd   	:=PesqPict("SBC","BC_QTDPERD")

dbSelectArea("SH6")
_nRecSH6	:=	Recno()


//----> VETOR QUE ARMAZENA OS CAMPOS A SEREM MOSTRADOS NO APONTAMENTO DE HORAS IMPRODUTIVAS
//AADD(aAcho,"H6_OP")
//--AADD(aAcho,"H6_OPERAC")
//AADD(aAcho,"H6_PRODUTO")
//--AADD(aAcho,"H6_RECURSO")
//--AADD(aAcho,"H6_FERRAM")
//--AADD(aAcho,"H6_DATAINI")
//--AADD(aAcho,"H6_HORAINI")
//--AADD(aAcho,"H6_DATAFIN")
//--AADD(aAcho,"H6_HORAFIN")
//--AADD(aAcho,"H6_DTAPONT")
//--AADD(aAcho,"H6_TEMPO")
//--AADD(aAcho,"H6_MOTIVO")
//--AADD(aAcho,"H6_DESCRI")
//--AADD(aAcho,"H6_OBSERVA")
//--AADD(aAcho,"H6_OPERADO")
//--AADD(aAcho,"H6_TIPO")
//--AADD(aAcho,"H6_IDENT")                                                                     
//--AADD(aAcho,"H6_TIPOTEM")
// Comentado linhas 85 a 152 pois não está mais em uso a pedido do Norberto - Matheus Totvs 14/10/2016
//----> EXECUTA A ROTINA DE APONTAMENTO DE HORAS IMPRODUTIVAS
/*If MsgBox("Deseja apontar horas improdutivas para OP "+Alltrim(SH6->H6_OP)+" - Operação "+SH6->H6_OPERAC+"?","Horas Improdutivas","YesNo")
	cCadastro := "Apontamento de Horas Improdutivas"
	nOpInc := 0
	
	While nOpInc != 1
		nOpInc := AxInclui("SH6",SH6->(RECNO()),3,aAcho,"U_INISH6")
		
		//----> CONTINUA EXECUTANDO A ROTINA DE APONTAMENTO DE HORAS IMPRODUTIVAS ATE QUE O USUARIO CANCELE
		While _nApontHrs == 0
			If MsgBox("Continuar apontando horas improdutivas para OP "+Alltrim(SH6->H6_OP)+" - Operação "+SH6->H6_OPERAC+"?","Horas Improdutivas - Continua","YesNo")
				_nApontHrs := 0
				nOpInc := AxInclui("SH6",SH6->(RECNO()),3,aAcho,"U_INISH6")
			Else
				_nApontHrs := 1
			EndIf
			//----> VOLTA AO REGISTRO DE APONTAMENTO DE PRODUCAO
			dbGoTo(_nRecSH6)
		EndDo
		//----> VOLTA AO REGISTRO DE APONTAMENTO DE PRODUCAO
		dbGoTo(_nRecSH6)
		Exit
	EndDo
EndIf

cCadastro := "Produção PCP Mod2"
//----> VOLTA AO REGISTRO DE APONTAMENTO DE PRODUCAO
dbGoTo(_nRecSH6)

//----> EXECUTA A ROTINA DE APONTAMENTO DE PERDAS ESPECIFICA JKS
If SH6->H6_QTDPERD > 0
	If MsgBox("Deseja classificar a Perda da OP "+Alltrim(SH6->H6_OP)+" - Operação "+SH6->H6_OPERAC+"?","Classificação da Perda","YesNo")
		cCadastro := "Apontamento de Perdas"
		nOpInc := 0
		
		While nOpInc != 1
			nOpInc := MATA685()

			//----> CONTINUA EXECUTANDO A ROTINA DE APONTAMENTO DE HORAS IMPRODUTIVAS ATE QUE O USUARIO CANCELE
			While _nApontPer == 0
				If MsgBox("Continuar classificando a perda da OP "+Alltrim(SH6->H6_OP)+" - Operação "+SH6->H6_OPERAC+"?","Classificação da Perda - Continua","YesNo")
					_nApontPer := 0
					nOpInc := 	MATA685()
				Else
					_nApontPer := 1
				EndIf
				//----> VOLTA AO REGISTRO DE APONTAMENTO DE PRODUCAO
				dbGoTo(_nRecSH6)
			EndDo
			//----> VOLTA AO REGISTRO DE APONTAMENTO DE PRODUCAO
			dbGoTo(_nRecSH6)
			Exit
		EndDo
		
	EndIf
EndIf
//----> VOLTA AO REGISTRO DE APONTAMENTO DE PRODUCAO
dbGoTo(_nRecSH6)


//----> EXECUTA A ROTINA DE IMPRESSAO DO SALDO DA OPERAÇÃO DA ORDEM DE PRODUÇÃO
//If SH6->H6_PT $ "P"
//	If MsgBox("Deseja imprimir o saldo da OP "+Alltrim(SH6->H6_OP)+" - Operação "+SH6->H6_OPERAC+"?","Impressão do Saldo da Operação","YesNo")
//		Saldo_Op()
//	EndIf
//EndIf
//----> VOLTA AO REGISTRO DE APONTAMENTO DE PRODUCAO
dbGoTo(_nRecSH6)
*/
// Matheus Abrão - Totvs IP Sorocaba 13/10/2016
//		Ajuste saldo empenho
if upper(alltrim(FUNNAME())) == "MATA681"
	SC2->(dbSelectArea("SC2"))
	SC2->(dbSetOrder(1))
	if SC2->(dbSeek(xFilial("SC2") + alltrim(SH6->H6_OP) ))
		if SC2->C2_QUJE < SC2->C2_QUANT
			lOpEncer := .F.	// op  NAÕ encerrada
		else
			lOpEncer := .T.	// op  encerrada
		endif
		
		SD4->(dbSelectArea("SD4"))
		SD4->(dbSetOrder(2)) // D4_FILIAL+D4_OP+D4_COD+D4_LOCAL
		
		if SD4->(dbSeek(xFilial("SD4") + SH6->H6_OP ))
			while SD4->(!eof()) .AND. SD4->D4_OP == SH6->H6_OP
				if "MOD" $ SD4->D4_COD
					//SD3->(dbSelectArea("SD3"))
					//SD3->(dbSetOrder(1))
					//if SD3->(dbSeek(xFilial("SD3") + SD4->D4_OP + SD4->D4_COD))
					
						/*nQtd := SD4->D4_QUANT - SD3->D3_QUANT
				
						if lOpEncer .OR. (nQtd < 0)
							aVetor:={{"D4_COD"     ,SD4->D4_COD,NIL},;
					      {"D4_OP"     ,SD4->D4_OP,NIL},;
					      {"D4_TRT"     ,SD4->D4_TRT,NIL},;
					      {"D4_LOCAL"     ,SD4->D4_LOCAL,NIL},;
					      {"D4_QTDEORI",SD4->D4_QTDEORI,NIL},;
					      {"D4_QUANT"     ,SD4->D4_QUANT,NIL},;
					      {"ZERAEMP"     ,"S",NIL}} //Zera empenho do processo de assistencia
					      
					      lMSHelpAuto := .T.
					      lMSErroAuto := .F.
					      MSExecAuto({|x,y| MATA380(x,y)},aVetor,4)
						else
							aVetor:={{"D4_COD"     ,SD4->D4_COD,NIL},;
					      {"D4_OP"     ,SD4->D4_OP,NIL},;
					      {"D4_TRT"     ,SD4->D4_TRT,NIL},;
					      {"D4_LOCAL"     ,SD4->D4_LOCAL,NIL},;
					      {"D4_QTDEORI",SD4->D4_QTDEORI,NIL},;
					      {"D4_QUANT"     ,nQtd,NIL}}
							
							AADD(aEmpen,{	nQtd	,;	// SD4->D4_QUANT
							""		,;	// DC_LOCALIZ
							""		,;	// DC_NUMSERI
							0		,;	// D4_QTSEGUM
							.F.		})
							
							lMSHelpAuto := .T.
					      	lMSErroAuto := .F.
							MSExecAuto({|x,y,z| mata380(x,y,z)},aVetor,4,aEmpen) 
			
						endif*/
						
						
						if lOpEncer
							aVetor:={{"D4_COD"     ,SD4->D4_COD,NIL},;
					      {"D4_OP"     ,SD4->D4_OP,NIL},;
					      {"D4_TRT"     ,SD4->D4_TRT,NIL},;
					      {"D4_LOCAL"     ,SD4->D4_LOCAL,NIL},;
					      {"D4_QTDEORI",SD4->D4_QTDEORI,NIL},;
					      {"D4_QUANT"     ,SD4->D4_QUANT,NIL},;
					      {"ZERAEMP"     ,"S",NIL}} //Zera empenho do processo de assistencia
					      
					      lMSHelpAuto := .T.
					      lMSErroAuto := .F.
					      MSExecAuto({|x,y| MATA380(x,y)},aVetor,4)
					      
					      If lMsErroAuto
						    //Alert("Erro ao tentar ajustar empenho da MOD")
						    //MostraErro()
						  EndIf
						
						endif
						
						
						
					//endif
				
				endif
				SD4->(dbSkip())
			end
		endif
	
	endif
endif


RestArea(aAreaSH6)
RestArea(aAreaSC2)
RestArea(aAreaSD3)
RestArea(aAreaSD4)
RestArea(_aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ INISH6   ³ Autor ³ Eder Rodrigues        ³ Data ³ 02/06/2003 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Traz os Dados da OP no Apontamento de Horas Improdutivas     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ Executado na Funcao AxInclui()                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function INISH6()

//M->H6_OP			:=				SH6->H6_OP
//M->H6_PRODUTO		:=				SH6->H6_PRODUTO
M->H6_OPERAC		:=				SH6->H6_OPERAC
M->H6_RECURSO		:=				SH6->H6_RECURSO
M->H6_FERRAM		:=				SH6->H6_FERRAM
M->H6_OPERADO		:=				SH6->H6_OPERADO
M->H6_TIPO			:=				"I"
M->H6_IDENT			:=				ProxNum()
M->H6_TIPOTEM       := 1

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ SALDO_OP ³ Autor ³ Eder Rodrigues        ³ Data ³ 02/06/2003 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Imprime o Saldo da Op da Operacao Apos o Apontamento Producao³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ (Nenhum)                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function Saldo_Op()

Local titulo	:=	"ORDEM DE PRODUCAO"
Local cString	:=	"SC2"
Local wnrel		:=	"OP_JKS"
Local cDesc 	:=	"Este programa ira imprimir as Ordens de Producao por Operacao"
Local aOrd		:= {"Por Numero","Por Produto","Por Centro de Custo","Por Prazo de Entrega"}
Local tamanho	:= "P"

Private aReturn :=	{"Zebrado",2,"Administracao", 2, 2, 2, "",2}
Private cPerg   :=	"MTR820"
Private nLastKey:=	0

If !ChkFile("SH8",.F.)
	Help(" ",1,"SH8EmUso")
	Return
EndIf

wnrel:=SetPrint(cString,wnrel,,@titulo,cDesc,"","",.F.,,,Tamanho)

If nLastKey == 27
	dbSelectArea("SH8")
	Set Filter To
	dbCloseArea()
	ClosFile("SH8")
	dbSelectArea("SC2")
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey = 27
	dbSelectArea("SH8")
	Set Filter To
	dbCloseArea()
	ClosFile("SH8")
	dbSelectArea("SC2")
	Return
EndIf

RptStatus({|lEnd| R820Imp(@lEnd,wnRel,titulo,tamanho)},titulo)

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ R820IMP  ³ Autor ³ Eder Rodrigues        ³ Data ³ 02/06/2003 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Chamada do Relatorio de Impressao da OP                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ (Nenhum)                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function R820Imp(lEnd,wnRel,titulo,tamanho)

Local _aArea	:= GetArea()
Local _nRecSH6	:= 0
Local CbCont,cabec1,cabec2
Local limite 	:= 80
Local nQuant 	:= 1
Local nomeprog  := "OP_JKS"
Local cProduto  := SPACE(LEN(SC2->C2_PRODUTO))
Local cQtd		:= ""
LOCAL cIndSC2	:= CriaTrab(NIL,.F.), nIndSC2
Local nOperac	:= 1
Private li 		:= 80
Private cOperac
Private cRecurso
Private cFerram
Private nTipo    := 18
Private _nPerEfic:= 0
Private _nTotProd:= 0
Private _nTotPerd:= 0
Private _nTotSald:= 0
Private _nTotHora:= 0
Private _nValEfic:= 0

dbSelectArea("SH6")
_nRecSH6	:=	Recno()

cbtxt    := SPACE(10)
cbcont   := 0
m_pag    := 1
cabec1	 := ""
cabec2 	 := ""

dbSelectArea("SC2")
dbSetOrder(1)
dbSeek(xFilial()+SH6->H6_OP,.F.)

SetRegua(LastRec())

If lEnd
	@ Prow()+1,001 PSay "CANCELADO PELO OPERADOR"
	Return
EndIf

IncRegua()

_cProdRot	:=	subs(SC2->C2_PRODUTO,1,3)

cProduto  	:= SC2->C2_PRODUTO
nQuant    	:= aSC2Sld()

dbSelectArea("SB1")
dbSeek(xFilial()+cProduto)

cOperac	:=	SH6->H6_OPERAC
cRecurso:=	SH6->H6_RECURSO
cFerram	:=	SH6->H6_FERRAM


dbSelectArea("SG2")
If dbSeek(xFilial()+SC2->(C2_PRODUTO+C2_ROTEIRO)+cOperac,.F.)
	_cCtrab	:=	SG2->G2_CTRAB
	_cRecRot:=	SG2->G2_RECURSO
EndIf

If !Empty(_cCtrab)
	dbSelectArea("SHB")
	dbSetOrder(1)
	dbSeek(xFilial("SHB")+_cCtrab,.f.)
EndIf

dbSelectArea("SH4")
dbSeek(xFilial()+Iif(cFerram <> SG2->G2_FERRAM,cFerram,SG2->G2_FERRAM),.f.)

//----> IMPRIME O CABECALHO DA ORDEM DE PRODUCAO
cabecOp()

//----> IMPRIME O ROTEIRO DE OPERACOES (1 OPERACAO POR PAGINA)
RotOper()

//----> SO IMPRIME PREPARACAO PARA ORDEM DE PRODUCAO DE PRODUTO INTERMEDIARIO
If !SB1->B1_TIPO$"PA"
	//----> IMPRIME O APONTAMENTO DE PREPARACAO (SETUP)
	PrepOper()
EndIf

//----> IMPRIME O APONTAMENTO DE PRODUCAO (POR TURNO)
ProdOper()

If !Subs(SC2->C2_PRODUTO,1,3)$"819" .And. !Alltrim(_cRecRot)$"860000"
	//----> IMPRIME O APONTAMENTO DE PARADAS
	ParadOper()
EndIf

If !Subs(SC2->C2_PRODUTO,1,3)$"819" .And. !Alltrim(_cRecRot)$"860000"
	//----> IMPRIME O APONTAMENTO DE PERDAS
	PerdaOper()
EndIf

//----> SO IMPRIME ESCOPO PARA ORDEM DE PRODUCAO DE PRODUTO INTERMEDIARIO
If SB1->B1_TIPO$"PA"
	Escopo()
EndIf
//----> ZERA VARIAVEIS PARA A PROXIMA OPERACAO
_nTotProd	:= 0
_nTotPerd	:= 0
_nTotSald	:= 0
_nTotHora 	:= 0
_nValEfic	:= 0
_nPerEfic	:= 0

m_pag++

//----> LINHA INICIAL - EJECT AUTOMATICO
Li := 0

dbSelectArea("SH8")
dbCloseArea()

//----> RETIRA O SH8 DA VARIAVEL CFOPENED REFERENTE A ABERTURA NO SIGAPCP.MNU
ClosFile("SH8")

dbSelectArea("SC2")
If aReturn[8] == 4
	RetIndex("SC2")
	Ferase(cIndSC2+OrdBagExt())
EndIf
Set Filter To
dbSetOrder(1)

If aReturn[5] = 1
	Set Printer TO
	dbCommitall()
	ourspool(wnrel)
EndIf

eject

MS_FLUSH()

dbSelectArea("SH6")
dbGoTo(_nRecSH6)

RestArea(_aArea)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CABECOP  ³ Autor ³ Eder Rodrigues        ³ Data ³ 02/06/2003 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Monta o Cabecalho da Ordem de Producao                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ (Nenhum)                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function CabecOp()

Local cCabec1 := "DATA : "+DTOC(DDATABASE)+"       O R D E M   D E   P R O D U C A O       "+"NRO. "+SC2->C2_NUM+" "+SC2->C2_ITEM+" "+SC2->C2_SEQUEN
Local cCabec2 := "OPERACAO: "+cOperac+" - "+Alltrim(SG2->G2_DESCRI)
Local nBegin
Local Limite := 80

If li # 5
	li := 0
EndIf

dbSelectArea("SB1")
dbSetOrder(1)
dbSeek(xFilial("SB1")+SC2->C2_PRODUTO,.f.)

@Li,00 PSay __PrtFatLine()
Li++
@Li,00 PSay Padc(cCabec1,limite)
Li++

//----> SO IMPRIME A OPERACAO SE NAO FOR ORDEM DE PRODUCAO DE PRODUTO ACABADO, SE NAO FOR ORDEM DE PRODUCAO DA FAMILIA 819 E SE NAO FOR ORDEM DE PRODUCAO DE MAO-DE-OBRA TERCEIRIZADA
If !SB1->B1_TIPO $"PA".And.!Subs(SC2->C2_PRODUTO,1,3)$"819" .And. !Alltrim(SG2->G2_RECURSO)$"860000"
	@Li,00 PSay Padc(cCabec2,limite)
	Li++
EndIf

@Li,00 PSay __PrtFatLine()
Li++

If !SB1->B1_TIPO $"PA"
	@Li,00 PSay "|"
	@Li,79 PSay "|"
	Li++
EndIf

@Li,00 PSay "| Produto: "
@Li,Pcol()		Psay Alltrim(SC2->C2_PRODUTO)+" - "+SB1->B1_DESC

If !Subs(SC2->C2_PRODUTO,1,3)$"819" .And. !Alltrim(SG2->G2_RECURSO)$"860000"
	@Li,Pcol()+007 Psay "TP: "+Transform(SG2->G2_LOTEPAD,'@e 99,999')+" "+SB1->B1_UM+"/HS"
EndIf

@Li,79 PSay "|"
Li++
@Li,00 PSay "|"
@Li,79 PSay "|"
Li++

//----> IMPRIME A QUANTIDADE ORIGINAL QUANDO A QUANTIDADE DA ORDEM DE PRODUCAO FOR DIFERENTE DA QUANTIDADE JA PRODUZIDA

ChecaProd()

@Li,00 PSay "| Qtde Original:  "
@Li,20 PSay SC2->C2_QUANT					PICTURE "@e 999,999,999.99"
@Li,36 PSay SB1->B1_UM
@Li,40 PSay "Emissao: "
@Li,64 PSay Dtoc(SC2->C2_EMISSAO)
@Li,79 PSay "|"

Li++
@Li,00 PSay "| Qtde Produzida: "
@Li,20 PSay _nTotProd   					PICTURE "@e 999,999,999.99"
@Li,36 PSay SB1->B1_UM
@Li,40 PSay "Prev Inicio:      "
@Li,64 Psay DTOC(SC2->C2_DATPRI)
@Li,79 PSay "|"

Li++
@Li,00 PSay "| Qtde Perda:     "
@Li,20 PSay _nTotPerd     					PICTURE "@e 999,999,999.99"
@Li,36 PSay SB1->B1_UM
@Li,40 PSay "Prev Termino:     "
@Li,64 Psay DTOC(SC2->C2_DATPRF)
@Li,79 PSay "|"

Li++
@Li,00 PSay "| Eficiencia (TR/TP):"
@Li,24 Psay _nPerEfic						Picture "@E 999,999.99"
@Li,36 PSay "%"
@Li,40 PSay "Saldo a Produzir: "
@Li,58 PSay _nTotSald                       PICTURE "@e 999,999,999.99"
@Li,73 PSay Iif(!Empty(_cCtrab) .Or. Subs(SC2->C2_PRODUTO,1,3)$"819" .Or. Alltrim(SG2->G2_RECURSO)$"860000",SB1->B1_UM,"CICLOS")
@Li,79 PSay "|"

If !SB1->B1_TIPO $"PA"
	Li++
	@Li,00 PSay "|"
	@Li,79 PSay "|"
EndIf

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ROTOPER  ³ Autor ³ Eder Rodrigues        ³ Data ³ 02/06/2003 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Imprime o Roteiro de Operacoes                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ (Nenhum)                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function RotOper()

Local Limite := 80
Local cCabec1 := Iif(Subs(SC2->C2_PRODUTO,1,3)$"819",Iif(!Empty(SC2->C2_SEQPAI),"E M P E N H A D O   P A R A","  U S A R   N O S   S E G U I N T E S   P R O D U T O S"),"R E C U R S O S   U T I L I D A D O S")
Local nBegin, lSH8
local i

Li++
@Li,00 PSay __PrtFatLine()
Li++
@Li,00 PSay Padc(cCabec1,limite)
Li++
@Li,00 PSay __PrtFatLine()
Li++
@Li,00 PSay "|"
@Li,79 PSay "|"

If Empty(_cCtrab)
	Li++
EndIf

//----> PRODUTOS DA FAMILIA 819 E RECURSO 860000 (PUXA O EMPENHO)
If Subs(SC2->C2_PRODUTO,1,3)$"819"
	_nCountEmp	:=	0
	
	//----> POSSUI OP PAI
	If !Empty(SC2->C2_SEQPAI)
		
		_cSeqPai	:=	SC2->C2_SEQPAI
		
		dbSelectArea("SD4")
		dbSetOrder(2)
		If dbSeek(xFilial("SD4")+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD),.F.)
			
			dbSelectArea("SC2")
			_nRecSC2	:=	Recno()
			
			@Li,00 PSay "| "+Posicione("SC2",1,xFilial("SC2")+Subs(SD4->D4_OP,1,6)+"01"+_cSeqPai,"C2_NUM")
			@Li,Pcol()+00 PSay	Posicione("SC2",1,xFilial("SC2")+Subs(SD4->D4_OP,1,6)+"01"+_cSeqPai,"C2_ITEM")
			@Li,Pcol()+00 PSay	Posicione("SC2",1,xFilial("SC2")+Subs(SD4->D4_OP,1,6)+"01"+_cSeqPai,"C2_SEQUEN")
			@Li,Pcol()+00 PSay " - "
			@Li,Pcol()+00 PSay	Alltrim(Posicione("SC2",1,xFilial("SC2")+Subs(SD4->D4_OP,1,6)+"01"+_cSeqPai,"C2_PRODUTO"))
			_cDescPai	:=	Posicione("SC2",1,xFilial("SC2")+Subs(SD4->D4_OP,1,6)+"01"+_cSeqPai,"C2_PRODUTO")
			
			@Li,Pcol()+01	Psay Posicione("SB1",1,xFilial("SB1")+_cDescPai,"B1_DESC")
			@Li,Pcol()+00	Psay (SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA)	PICTURE "@e 999,999,999.99"
			@Li,Pcol()+01	Psay Posicione("SB1",1,xFilial("SB1")+_cDescPai,"B1_UM")
			@Li,79 PSay "|"
			Li++
			@Li,00 PSay "|"
			@Li,79 PSay "|"
			Li++
			
			dbSelectArea("SC2")
			dbGoTo(_nRecSC2)
			
			While SD4->D4_OP	==	SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)
				
				If Subs(SD4->D4_COD,1,3)$"MOD"
					dbSkip()
					Loop
				EndIf
				
				@Li,00 PSay "| "+SD4->D4_COD
				@Li,Pcol()+01	Psay Posicione("SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_DESC")
				@Li,Pcol()+10	Psay SD4->D4_QUANT	 Picture "999,999,999.99"
				@Li,Pcol()+01	Psay Posicione("SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_UM")
				@Li,79 PSay "|"
				Li++
				
				_nCountEmp += 1
				dbSelectArea("SD4")
				dbSkip()
			EndDo
		EndIf
		
		For i:= 1 to ( 29 - _nCountEmp )
			@Li,00 PSay "|"
			@Li,79 PSay "|"
			Li++
		Next
		
		_cProdRot	:=	"819"
		
		//----> SE NAO POSSUI OP PAI, IMPRIME ONDE E USADO
	Else
		dbSelectArea("SG1")
		dbSetOrder(2)
		If dbSeek(xFilial("SG1")+SC2->C2_PRODUTO,.F.)
			While SG1->G1_COMP == SC2->C2_PRODUTO
				@Li,00 PSay "| "+SG1->G1_COD
				@Li,Pcol()+01	Psay Posicione("SB1",1,xFilial("SB1")+SG1->G1_COD,"B1_DESC")
				@Li,79 PSay "|"
				Li++
				
				_nCountEmp += 1
				dbSelectArea("SG1")
				dbSkip()
			EndDo
		Else
			@Li,00 PSay "| O PRODUTO "+Alltrim(SC2->C2_PRODUTO)
			@Li,Pcol()+01	Psay Alltrim(Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_DESC"))
			@Li,Pcol()+01	Psay " NAO FAZ PARTE DE NENHUMA ESTRUTURA"
			@Li,79 PSay "|"
			Li++
		EndIf
		
		For i:= 1 to ( 29 - _nCountEmp )
			@Li,00 PSay "|"
			@Li,79 PSay "|"
			Li++
		Next
		
		_cProdRot	:=	"819"
		
	EndIf
EndIf

dbSelectArea("SG2")
If dbSeek(xFilial("SG2")+SC2->(C2_PRODUTO+C2_ROTEIRO)+cOperac,.F.)
	
	dbSelectArea("SH4")
	dbSeek(xFilial()+Iif(!Empty(_cFerram),_cFerram,SG2->G2_FERRAM),.f.)
	
	dbSelectArea("SH8")
	dbSetOrder(1)
	dbSeek(xFilial("SH8")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD+SG2->G2_OPERAC)
	lSH8 := IIf(Found(),.T.,.F.)
	
	If lSH8
		While !Eof() .And. SH8->H8_FILIAL+SH8->H8_OP+SH8->H8_OPER == xFilial("SH8")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD+SG2->G2_OPERAC
			ImpRot(lSH8)
			dbSelectArea("SH8")
			dbSkip()
		End
	Else
		ImpRot(lSH8)
	EndIf
Else
	@Li,00 PSay "|"
	@Li,79 PSay "|"
	
EndIf

//----> IMPRIME EMPENHO DAS ORDENS DE PRODUCAO DE MAO-DE-OBRA TERCEIRIZADA
If Alltrim(SG2->G2_RECURSO)$"860000"
	EmpMod3()
EndIf

Return (Li)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ IMPROT   ³ Autor ³ Eder Rodrigues        ³ Data ³ 02/06/2003 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Imprime o Roteiro de Operacoes                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ (Nenhum)                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function ImpRot(lSH8)
Local nBegin

dbSelectArea("SH1")
dbSeek(xFilial("SH1")+Iif(!Empty(_cRecurso),_cRecurso,IIf(lSH8,SH8->H8_RECURSO,SG2->G2_RECURSO)))

//----> FAMILIA DE PRODUTOS COM CODIGO INICIAL 819 - IMPRIMIR EMPENHOS
If _cProdRot $"819"
	
	//----> RECURSOS PARA ORDEM DE PRODUCAO DE PRODUTOS INTERMEDIARIOS
ElseIf Empty(_cCtrab)
	@Li,00 PSay "| MAQUINA:    "+Iif(!Empty(_cRecurso),_cRecurso,IIf(lSH8,SH8->H8_RECURSO,SG2->G2_RECURSO))+"      "+SH1->H1_DESCRI
	@Li,79 PSay "|"
	LI ++
	@Li,00 PSay "| FERRAMENTA: "+Iif(!Empty(_cFerram),_cFerram,SG2->G2_FERRAM)+"      "+SH4->H4_DESCRI
	//----> MAO-DE-OBRA TERCEIRIZADA NAO IMPRIME CICLO
	If !SG2->G2_RECURSO$"860000" .Or. !_cRecurso$"860000"
		@Li,Pcol()+06 Psay "PCS/CICLO: "
		@Li,Pcol()+07 Psay SH4->H4_X_CICLO Picture "999"
	EndIf
	@Li,79 PSay "|"
	
	//----> RECURSOS PARA ORDEM DE PRODUCAO DE PRODUTOS ACABADOS
Else
	@Li,00 PSay "| "+Iif(!Empty(_cCtrab),_cCtrab,SG2->G2_CTRAB)+"      "+SHB->HB_NOME
	@Li,79 PSay "|"
	LI ++
	@Li,00 PSay "| "+Iif(!Empty(_cRecurso),_cRecurso,IIf(lSH8,SH8->H8_RECURSO,SG2->G2_RECURSO))+"      "+SH1->H1_DESCRI
	@Li,79 PSay "|"
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ PREPOPER ³ Autor ³ Eder Rodrigues        ³ Data ³ 02/06/2003 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Imprime o Lay Out para Apontamento de Horas Improdutivas     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ (Nenhum)                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function PrepOper()

Local limite  := 80
Local cCabec1 := "P R E P A R A C A O   (PREPARADOR)"

//----> FAMILIA DE PRODUTOS COM CODIGO INICIAL 819 E RECURSO 860000 - IMPRIMIR EMPENHOS
If _cProdRot $"819" .Or. Alltrim(SG2->G2_RECURSO)$"860000"
	//----> NAO IMPRIME PREPARACAO
	//----> PREPARACAO PARA ORDEM DE PRODUCAO DE PRODUTOS INTERMEDIARIOS
ElseIf Empty(_cCtrab)
	Li++
	@Li,00 PSay __PrtFatLine()
	Li++
	@Li,00 PSay Padc(cCabec1,Limite)
	Li++
	@Li,00 PSay __PrtFatLine()
	Li++
	@Li,00 PSay "| DATA   "
	@Li,Pcol()+06 Psay "HORA INICIAL"
	@Li,Pcol()+02 Psay "HORA FINAL  "
	@Li,Pcol()+02 Psay "MAQUINA   "
	@Li,Pcol()+02 Psay "FERRAMENTA"
	@Li,Pcol()+02 Psay "PREPARADOR "
	
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "|"
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "| ___/___"
	@Li,Pcol()+06 Psay "____:____   "
	@Li,Pcol()+02 Psay "____:____   "
	@Li,Pcol()+02 Psay "__________"
	@Li,Pcol()+02 Psay "__________"
	@Li,Pcol()+02 Psay "___________"
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "|"
	@Li,79 PSay "|"
	//----> PREPARACAO PARA ORDEM DE PRODUCAO DE PRODUTOS ACABADOS
Else
	Li++
	@Li,00 PSay __PrtFatLine()
	Li++
	@Li,00 PSay Padc(cCabec1,Limite)
	Li++
	@Li,00 PSay __PrtFatLine()
	Li++
	@Li,00 PSay "| DATA   "
	@Li, Pcol()+05 Psay "  HRS INI"
	@Li, Pcol()+05 Psay "  HRS FIM"
	@Li, Pcol()+05 Psay "  OPERADOR "
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "|        "
	@Li, Pcol()+05 Psay "         "
	@Li, Pcol()+05 Psay "         "
	@Li, Pcol()+05 Psay "           "
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "| ___/___"
	@Li, Pcol()+05 Psay "  ___:___"
	@Li, Pcol()+05 Psay "  ___:___"
	@Li, Pcol()+05 Psay "  _________"
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "|"
	@Li,79 PSay "|"
EndIf

Return(Li)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ PRODOPER ³ Autor ³ Eder Rodrigues        ³ Data ³ 02/06/2003 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Imprime o Lay Out para Apontamento de Producoes              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ (Nenhum)                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function ProdOper()

Local limite  := 80
Local cCabec1 := Iif(Empty(_cCtrab),Iif(_cProdRot$"819" .Or. Alltrim(SG2->G2_RECURSO)$"860000","          A P O N T A M E N T O   (OPERADOR)             P C P   (DIGITADOR)","P R O D U C O E S   (OPERADOR)"),"A P O N T A M E N T O   (OPERADOR(s))")
local _j

Li++
@Li,00 PSay __PrtFatLine()
Li++
@Li,00 PSay Padc(cCabec1,Limite)
Li++
@Li,00 PSay __PrtFatLine()
Li++

//----> PRODUCOES PARA ORDEM DE PRODUCAO DE PRODUTOS FAMILIA 819 E RECURSO 860000
If _cProdRot$"819" .Or. Alltrim(SG2->G2_RECURSO)$"860000"
	@Li,00 PSay "| DATA   "
	@Li, Pcol()+01 Psay "| QTD PREP "
	@Li, Pcol()+01 Psay "| OPERADOR "
	@Li, Pcol()+01 Psay "| QTD PREP/QTD SALDO "
	@Li, Pcol()+01 PSay "| VISTO              "
	@Li, 79			Psay "|"
	Li++
	@Li,00 PSay "|        "
	@Li, Pcol()+01 Psay "|          "
	@Li, Pcol()+01 Psay "|          "
	@Li, Pcol()+01 PSay "|                    "
	@Li, Pcol()+01 PSay "|                    "
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "| ___/___"
	@Li, Pcol()+01 PSay "| _________"
	@Li, Pcol()+01 Psay "| _________"
	@Li, Pcol()+01 Psay "| ________/_________ "
	@Li, Pcol()+01 Psay "| __________________ "
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "|        "
	@Li, Pcol()+01 Psay "|          "
	@Li, Pcol()+01 Psay "|          "
	@Li, Pcol()+01 PSay "|                    "
	@Li, Pcol()+01 PSay "|                    "
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "| DATA   "
	@Li, Pcol()+01 Psay "| QTD PREP "
	@Li, Pcol()+01 Psay "| OPERADOR "
	@Li, Pcol()+01 Psay "| QTD PREP/QTD SALDO "
	@Li, Pcol()+01 PSay "| VISTO              "
	@Li, 79			Psay "|"
	Li++
	@Li,00 PSay "|        "
	@Li, Pcol()+01 Psay "|          "
	@Li, Pcol()+01 Psay "|          "
	@Li, Pcol()+01 PSay "|                    "
	@Li, Pcol()+01 PSay "|                    "
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "| ___/___"
	@Li, Pcol()+01 PSay "| _________"
	@Li, Pcol()+01 Psay "| _________"
	@Li, Pcol()+01 Psay "| ________/_________ "
	@Li, Pcol()+01 Psay "| __________________ "
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "|        "
	@Li, Pcol()+01 Psay "|          "
	@Li, Pcol()+01 Psay "|          "
	@Li, Pcol()+01 PSay "|                    "
	@Li, Pcol()+01 PSay "|                    "
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "| DATA   "
	@Li, Pcol()+01 Psay "| QTD PREP "
	@Li, Pcol()+01 Psay "| OPERADOR "
	@Li, Pcol()+01 Psay "| QTD PREP/QTD SALDO "
	@Li, Pcol()+01 PSay "| VISTO              "
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "|        "
	@Li, Pcol()+01 Psay "|          "
	@Li, Pcol()+01 Psay "|          "
	@Li, Pcol()+01 PSay "|                    "
	@Li, Pcol()+01 PSay "|                    "
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "| ___/___"
	@Li, Pcol()+01 PSay "| _________"
	@Li, Pcol()+01 Psay "| _________"
	@Li, Pcol()+01 Psay "| ________/_________ "
	@Li, Pcol()+01 Psay "| __________________ "
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "|        "
	@Li, Pcol()+01 Psay "|          "
	@Li, Pcol()+01 Psay "|          "
	@Li, Pcol()+01 PSay "|                    "
	@Li, Pcol()+01 PSay "|                    "
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "| DATA   "
	@Li, Pcol()+01 Psay "| QTD PREP "
	@Li, Pcol()+01 Psay "| OPERADOR "
	@Li, Pcol()+01 Psay "| QTD PREP/QTD SALDO "
	@Li, Pcol()+01 PSay "| VISTO              "
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "|        "
	@Li, Pcol()+01 Psay "|          "
	@Li, Pcol()+01 Psay "|          "
	@Li, Pcol()+01 PSay "|                    "
	@Li, Pcol()+01 PSay "|                    "
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "| ___/___"
	@Li, Pcol()+01 PSay "| _________"
	@Li, Pcol()+01 Psay "| _________"
	@Li, Pcol()+01 Psay "| ________/_________ "
	@Li, Pcol()+01 Psay "| __________________ "
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "|        "
	@Li, Pcol()+01 Psay "|          "
	@Li, Pcol()+01 Psay "|          "
	@Li, Pcol()+01 PSay "|                    "
	@Li, Pcol()+01 PSay "|                    "
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "|        "
	@Li, Pcol()+01 Psay "|          "
	@Li, Pcol()+01 Psay "|          "
	@Li, Pcol()+01 PSay "|                    "
	@Li, Pcol()+01 PSay "|                    "
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay __PrtFatLine()
	
	//----> PRODUCOES PARA ORDEM DE PRODUCAO DE PRODUTOS INTERMEDIARIOS
ElseIf Empty(_cCtrab)
	@Li,00 PSay "| DATA   "
	@Li, Pcol()+01 Psay "| HRS INI"
	@Li, Pcol()+01 Psay "| HRS FIM"
	@Li, Pcol()+01 PSay "| QTD INI"
	@Li, Pcol()+01 Psay "| QTD FIM"
	@Li, Pcol()+01 Psay "| OPERADOR "
	@Li, Pcol()+01 Psay "| QTD PRO/QTD SLD"
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "|        "
	@Li, Pcol()+01 Psay "|        "
	@Li, Pcol()+01 Psay "|        "
	@Li, Pcol()+01 PSay "|        "
	@Li, Pcol()+01 Psay "|        "
	@Li, Pcol()+01 Psay "|          "
	@Li, Pcol()+01 Psay "|                "
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "| ___/___"
	@Li, Pcol()+01 Psay "| ___:___"
	@Li, Pcol()+01 Psay "| ___:___"
	@Li, Pcol()+01 PSay "| _______"
	@Li, Pcol()+01 Psay "| _______"
	@Li, Pcol()+01 Psay "| _________"
	@Li, Pcol()+01 Psay "| _______/_______"
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "|        "
	@Li, Pcol()+01 Psay "|        "
	@Li, Pcol()+01 Psay "|        "
	@Li, Pcol()+01 PSay "|        "
	@Li, Pcol()+01 Psay "|        "
	@Li, Pcol()+01 Psay "|          "
	@Li, Pcol()+01 Psay "|                "
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "| DATA   "
	@Li, Pcol()+01 Psay "| HRS INI"
	@Li, Pcol()+01 Psay "| HRS FIM"
	@Li, Pcol()+01 PSay "| QTD INI"
	@Li, Pcol()+01 Psay "| QTD FIM"
	@Li, Pcol()+01 Psay "| OPERADOR "
	@Li, Pcol()+01 Psay "| QTD PRO/QTD SLD"
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "|        "
	@Li, Pcol()+01 Psay "|        "
	@Li, Pcol()+01 Psay "|        "
	@Li, Pcol()+01 PSay "|        "
	@Li, Pcol()+01 Psay "|        "
	@Li, Pcol()+01 Psay "|          "
	@Li, Pcol()+01 Psay "|                "
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "| ___/___"
	@Li, Pcol()+01 Psay "| ___:___"
	@Li, Pcol()+01 Psay "| ___:___"
	@Li, Pcol()+01 PSay "| _______"
	@Li, Pcol()+01 Psay "| _______"
	@Li, Pcol()+01 Psay "| _________"
	@Li, Pcol()+01 Psay "| _______/_______"
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "|        "
	@Li, Pcol()+01 Psay "|        "
	@Li, Pcol()+01 Psay "|        "
	@Li, Pcol()+01 PSay "|        "
	@Li, Pcol()+01 Psay "|        "
	@Li, Pcol()+01 Psay "|          "
	@Li, Pcol()+01 Psay "|                "
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "| DATA   "
	@Li, Pcol()+01 Psay "| HRS INI"
	@Li, Pcol()+01 Psay "| HRS FIM"
	@Li, Pcol()+01 PSay "| QTD INI"
	@Li, Pcol()+01 Psay "| QTD FIM"
	@Li, Pcol()+01 Psay "| OPERADOR "
	@Li, Pcol()+01 Psay "| QTD PRO/QTD SLD"
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "|        "
	@Li, Pcol()+01 Psay "|        "
	@Li, Pcol()+01 Psay "|        "
	@Li, Pcol()+01 PSay "|        "
	@Li, Pcol()+01 Psay "|        "
	@Li, Pcol()+01 Psay "|          "
	@Li, Pcol()+01 Psay "|                "
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "| ___/___"
	@Li, Pcol()+01 Psay "| ___:___"
	@Li, Pcol()+01 Psay "| ___:___"
	@Li, Pcol()+01 PSay "| _______"
	@Li, Pcol()+01 Psay "| _______"
	@Li, Pcol()+01 Psay "| _________"
	@Li, Pcol()+01 Psay "| _______/_______"
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "|        "
	@Li, Pcol()+01 Psay "|        "
	@Li, Pcol()+01 Psay "|        "
	@Li, Pcol()+01 PSay "|        "
	@Li, Pcol()+01 Psay "|        "
	@Li, Pcol()+01 Psay "|          "
	@Li, Pcol()+01 Psay "|                "
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "|        "
	@Li, Pcol()+01 Psay "|        "
	@Li, Pcol()+01 Psay "|        "
	@Li, Pcol()+01 PSay "|        "
	@Li, Pcol()+01 Psay "|        "
	@Li, Pcol()+01 Psay "|          "
	@Li, Pcol()+01 Psay "|                "
	@Li,79 PSay "|"
	
	//----> PRODUCOES PARA ORDEM DE PRODUCAO DE PRODUTOS ACABADOS
Else
	@Li,000			Psay "|         OPERACAO        "
	@Li, Pcol()+00 PSay "|   DATA "
	@Li, Pcol()+01 Psay "| HRS INI"
	@Li, Pcol()+01 Psay "| HRS FIM"
	@Li, Pcol()+01 PSay "| QTD PRO"
	@Li, Pcol()+01 Psay "| OPERADOR"
	@Li,79 PSay "|"
	Li++
	_nCountOper := 0
	
	dbSelectArea("SG2")
	If dbSeek(xFilial("SG2")+SC2->(C2_PRODUTO+C2_ROTEIRO),.F.)
		While SG2->(G2_PRODUTO+G2_CODIGO) == SC2->(C2_PRODUTO+C2_ROTEIRO)
			@Li,000			Psay "|                        "
			@Li, Pcol()+01 PSay "|        "
			@Li, Pcol()+01 Psay "|        "
			@Li, Pcol()+01 Psay "|        "
			@Li, Pcol()+01 PSay "|        "
			@Li, Pcol()+01 Psay "|         "
			@Li,79 PSay "|"
			Li++
			@Li,000			Psay "| "+SG2->G2_OPERAC+"-"+SG2->G2_DESCRI
			@Li, Pcol()+01 PSay "| ___/___"
			@Li, Pcol()+01 Psay "| ___:___"
			@Li, Pcol()+01 Psay "| ___:___"
			@Li, Pcol()+01 PSay "| _______"
			@Li, Pcol()+01 Psay "| ________"
			@Li,79 PSay "|"
			Li++
			
			_nCountOper	:=	_nCountOper + 1
			
			dbSkip()
		EndDo
		
		//----> IMPRIME ESPACOS EM BRANCO CASO O ROTEIRO TENHA MENOS DE 7 OPERACOES
		If _nCountOper < 7
			For _j := 1 To (7 - _nCountOper)
				@Li,000			Psay "|                        "
				@Li, Pcol()+01 PSay "|        "
				@Li, Pcol()+01 Psay "|        "
				@Li, Pcol()+01 Psay "|        "
				@Li, Pcol()+01 PSay "|        "
				@Li, Pcol()+01 Psay "|          "
				@Li,79 PSay "|"
				Li++
				@Li,000			Psay "|                        "
				@Li, Pcol()+01 PSay "|        "
				@Li, Pcol()+01 Psay "|        "
				@Li, Pcol()+01 Psay "|        "
				@Li, Pcol()+01 PSay "|        "
				@Li, Pcol()+01 Psay "|          "
				@Li,79 PSay "|"
				Li++
			Next
		EndIf
	EndIf
	@Li,000			Psay "|                        "
	@Li, Pcol()+01 PSay "|        "
	@Li, Pcol()+01 Psay "|        "
	@Li, Pcol()+01 Psay "|        "
	@Li, Pcol()+01 PSay "|        "
	@Li, Pcol()+01 Psay "|          "
	@Li,79 PSay "|"
	
	Li++
EndIf


Return(Li)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ PARADOPER³ Autor ³ Eder Rodrigues        ³ Data ³ 02/06/2003 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Imprime o Lay Out para Apontamento de Horas Improdutivas     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ (Nenhum)                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function ParadOper()

Local limite  := 80
Local cCabec1 := Iif(Empty(_cCtrab), "P A R A D A S   (OPERADOR)", "P A R A D A S   (OPERADOR(s))")

If Empty(_cCtrab)
	Li++
EndIf

@Li,00 PSay __PrtFatLine()
Li++
@Li,00 PSay Padc(cCabec1,Limite)
Li++
@Li,00 PSay __PrtFatLine()
Li++

//----> PARADAS PARA ORDEM DE PRODUCAO DE PRODUTOS INTERMEDIARIOS
If Empty(_cCtrab)
	@Li,00 PSay "| DATA   "
	@Li,Pcol()+07 Psay "HORA INICIAL"
	@Li,Pcol()+03 Psay "HORA FINAL  "
	@Li,Pcol()+03 Psay "CODIGO"
	@Li,Pcol()+03 Psay "OPERADOR            "
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "|"
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "| ___/___"
	@Li,Pcol()+07 Psay "____:____   "
	@Li,Pcol()+03 Psay "____:____   "
	@Li,Pcol()+03 Psay "______"
	@Li,Pcol()+03 Psay "____________________"
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "|"
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "| DATA   "
	@Li,Pcol()+07 Psay "HORA INICIAL"
	@Li,Pcol()+03 Psay "HORA FINAL  "
	@Li,Pcol()+03 Psay "CODIGO"
	@Li,Pcol()+03 Psay "OPERADOR            "
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "|"
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "| ___/___"
	@Li,Pcol()+07 Psay "____:____   "
	@Li,Pcol()+03 Psay "____:____   "
	@Li,Pcol()+03 Psay "______"
	@Li,Pcol()+03 Psay "____________________"
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "|"
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "| DATA   "
	@Li,Pcol()+07 Psay "HORA INICIAL"
	@Li,Pcol()+03 Psay "HORA FINAL  "
	@Li,Pcol()+03 Psay "CODIGO"
	@Li,Pcol()+03 Psay "OPERADOR            "
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "|"
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "| ___/___"
	@Li,Pcol()+07 Psay "____:____   "
	@Li,Pcol()+03 Psay "____:____   "
	@Li,Pcol()+03 Psay "______"
	@Li,Pcol()+03 Psay "____________________"
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "|"
	@Li,79 PSay "|"
	
	//----> PARADAS PARA ORDEM DE PRODUCAO DE PRODUTOS ACABADOS
Else
	@Li,00 PSay "| DATA   "
	@Li,Pcol()+07 Psay "HORA INICIAL"
	@Li,Pcol()+03 Psay "HORA FINAL  "
	@Li,Pcol()+03 Psay "CODIGO"
	@Li,Pcol()+03 Psay "OPERADOR            "
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "|"
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "| ___/___"
	@Li,Pcol()+07 Psay "____:____   "
	@Li,Pcol()+03 Psay "____:____   "
	@Li,Pcol()+03 Psay "______"
	@Li,Pcol()+03 Psay "____________________"
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "|"
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "| ___/___"
	@Li,Pcol()+07 Psay "____:____   "
	@Li,Pcol()+03 Psay "____:____   "
	@Li,Pcol()+03 Psay "______"
	@Li,Pcol()+03 Psay "____________________"
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "|"
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "| ___/___"
	@Li,Pcol()+07 Psay "____:____   "
	@Li,Pcol()+03 Psay "____:____   "
	@Li,Pcol()+03 Psay "______"
	@Li,Pcol()+03 Psay "____________________"
	@Li,79 PSay "|"
	Li++
	@Li,00 PSay "|"
	@Li,79 PSay "|"
EndIf
Return(Li)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ PERDAOPER³ Autor ³ Eder Rodrigues        ³ Data ³ 02/06/2003 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Imprime o Lay Out para Apontamento de Perdas                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ (Nenhum)                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function PerdaOper()

Local limite  := 80

li++
@Li,00 PSay __PrtFatLine()
Li++
@Li,00 PSay Iif(Empty(_cCtrab),"               P E R D A S   (OPERADOR)                     P C P   (DIGITADOR) ","               P E R D A S   (OPERADOR(s)                   P C P   (DIGITADOR) ")
Li++
@Li,00 PSay __PrtFatLine()
Li++

@Li,00 PSay "| DATA ___/___     | DATA ___/___     | DATA ___/___      | DATA ___/___       |"
Li++
@Li,00 PSay "|                  |                  |                   |                    |"
Li++
@Li,00 Psay "| OPERADOR ________| OPERADOR ________| OPERADOR ________ | VISTO ____________ |"
Li++
@Li,00 PSay "|                  |                  |                   |                    |"
Li++
@Li,00 Psay "| PERDA ____ COD __| PERDA ____ COD __| PERDA ____ COD __ | QTD PROD _________ |"
Li++
@Li,00 PSay "|                  |                  |                   |                    |"
Li++
@Li,00 PSay __PrtFatLine()

Return(Li)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ESCOPO   ³ Autor ³ Eder Rodrigues        ³ Data ³ 30/06/2003 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Imprime o Lay Out para Escopo de Fornecimento                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ (Nenhum)                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function Escopo()

Local limite  := 80
Local cCabec1 := "     E S C O P O   D E   F O R N E C I M E N T O     "+"NRO. "+SC2->C2_NUM+" "+SC2->C2_ITEM+" "+SC2->C2_SEQUEN

Li++
@Li,00 PSay __PrtFatLine()
Li++

@Li,00 PSay Padc(cCabec1,Limite)
Li++
@Li,00 PSay __PrtFatLine()
Li++
@Li,00 PSay "|    C Q    | "+Alltrim(SB1->B1_COD)+" - "+SB1->B1_DESC
@Li,79 Psay "|"
Li++
@Li,00 PSay "|"
@Li,12 PSay "|"
@Li,13 PSay Replicate("_",66)
@Li,79 PSay "|"
Li++
@Li,00 PSay "|           |   Data   |    Lote    | No. Vol. |  Quant. |   Mont.  |  Exped.  |"
Li++
@Li,00 PSay "|"
@Li,12 PSay "|"
@Li,13 PSay Replicate("_",66)
@Li,79 PSay "|"
Li++
@Li,00 PSay "|           |          |   "+SC2->C2_NUM+"   |          |         |          |          |"
Li++
@Li,00 PSay "|           |          |            |          |         |          |          |"
Li++
@Li,00 PSay __PrtFatLine()

Return(Li)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CHECAPROD³ Autor ³ Eder Rodrigues        ³ Data ³ 02/06/2003 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Verifica Apontamentos ja Efetuados para Calculo do Saldo     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ (Nenhum)                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function ChecaProd()

dbSelectArea("SH6")
dbSetOrder(1)
If dbSeek(xFilial("SH6")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD+SC2->C2_PRODUTO+cOperac,.f.)
	
	While SH6->(H6_OP+H6_PRODUTO+H6_OPERAC) == SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_ITEMGRD+SC2->C2_PRODUTO+cOperac
		
		//----> SO INTERESSA REGISTROS DE APONTAMENTO DE PRODUCAO
		If !SH6->H6_TIPO $"P"
			dbSkip()
			Loop
		EndIf
		
		_cRecurso	:= SH6->H6_RECURSO
		_cFerram	:= SH6->H6_FERRAM
		
		_nTotProd	:= _nTotProd + SH6->H6_QTDPROD
		_nTotPerd	:= _nTotPerd + SH6->H6_

		_nTotHora 	:= _nTotHora + Round(Val(Subs(SH6->H6_TEMPO,1,2)+Subs(SH6->H6_TEMPO,4,2)),2)
		
		//----> PRODUTO ACABADO - TODOS
		If !Empty(_cCtrab)
			_nTotSald	:=	Round((SC2->C2_QUANT - _nTotProd - _nTotPerd),2)
			//----> PRODUTO DA FAMILIA 819
		ElseIf Subs(SC2->C2_PRODUTO,1,3)$"819"
			_nTotSald	:=  Round((SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA),2)
			//----> PRODUTO INTERMEDIARIO - TODOS MENOS 819
		Else
			_nTotSald	:=  Round((SC2->C2_QUANT - _nTotProd - _nTotPerd)/SH4->H4_X_CICLO,2)
		EndIf
		
		dbSkip()
	EndDo
	
	_nValEfic	:= Round((_nTotProd - _nTotPerd) * (SG2->G2_TEMPAD * 100) / _nTotHora ,2)
	_nPerEfic	:= Round((_nValEfic / SG2->G2_LOTEPAD) * 100,2)
Else
	
	//----> PRODUTO ACABADO - TODOS
	If !Empty(_cCtrab)
		_nTotProd	:=	SC2->C2_QUJE
		_nTotPerd	:=	SC2->C2_PERDA
		_nTotSald	:=	Round((SC2->C2_QUANT - _nTotProd - _nTotPerd),2)
		//----> PRODUTO DA FAMILIA 819 E RECURSO 860000
	ElseIf Subs(SC2->C2_PRODUTO,1,3)$"819" .Or. Alltrim(SG2->G2_RECURSO)$"860000"
		_nTotProd	:=	SC2->C2_QUJE
		_nTotPerd	:=	SC2->C2_PERDA
		_nTotSald	:=  Round((SC2->C2_QUANT - _nTotProd - _nTotPerd),2)
		//----> PRODUTO INTERMEDIARIO - TODOS MENOS 819
	Else
		_nTotProd	:=	SC2->C2_QUJE
		_nTotPerd	:=	SC2->C2_PERDA
		_nTotSald	:=  Round((SC2->C2_QUANT - _nTotProd - _nTotPerd)/SH4->H4_X_CICLO,2)
	EndIf
	
	_nTotHora	:= 0
	_nValEfic	:= 0
	_nPerEfic	:= 0
	
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ EMPMOD3  ³ Autor ³ Eder Rodrigues        ³ Data ³ 22/10/2003 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Imprime o Roteiro de Operacoes Mao-de-Obra Terceirizada      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ Somente Quando G2_RECURSO = 860000                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

Static Function EmpMod3()

Local Limite := 80
Local cCabec1 := Iif(!Empty(SC2->C2_SEQPAI),"E M P E N H A D O   P A R A","  U S A R   N O S   S E G U I N T E S   P R O D U T O S")
Local _nCountEmp := 0
local i

Li++
@Li,00 PSay __PrtFatLine()
Li++
@Li,00 PSay Padc(cCabec1,limite)
Li++
@Li,00 PSay __PrtFatLine()
Li++
@Li,00 PSay "|"
@Li,79 PSay "|"

//----> POSSUI OP PAI
If !Empty(SC2->C2_SEQPAI)
	
	_cSeqPai	:=	SC2->C2_SEQPAI
	
	dbSelectArea("SD4")
	dbSetOrder(2)
	If dbSeek(xFilial("SD4")+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD),.F.)
		
		dbSelectArea("SC2")
		_nRecSC2	:=	Recno()
		
		@Li,00 PSay "| "+Posicione("SC2",1,xFilial("SC2")+Subs(SD4->D4_OP,1,6)+"01"+_cSeqPai,"C2_NUM")
		@Li,Pcol()+00 PSay	Posicione("SC2",1,xFilial("SC2")+Subs(SD4->D4_OP,1,6)+"01"+_cSeqPai,"C2_ITEM")
		@Li,Pcol()+00 PSay	Posicione("SC2",1,xFilial("SC2")+Subs(SD4->D4_OP,1,6)+"01"+_cSeqPai,"C2_SEQUEN")
		@Li,Pcol()+00 PSay " - "
		@Li,Pcol()+00 PSay	Alltrim(Posicione("SC2",1,xFilial("SC2")+Subs(SD4->D4_OP,1,6)+"01"+_cSeqPai,"C2_PRODUTO"))
		_cDescPai	:=	Posicione("SC2",1,xFilial("SC2")+Subs(SD4->D4_OP,1,6)+"01"+_cSeqPai,"C2_PRODUTO")
		
		@Li,Pcol()+01	Psay Posicione("SB1",1,xFilial("SB1")+_cDescPai,"B1_DESC")
		@Li,Pcol()+00	Psay (SC2->C2_QUANT - SC2->C2_QUJE - SC2->C2_PERDA)	PICTURE "@e 999,999,999.99"
		@Li,Pcol()+01	Psay Posicione("SB1",1,xFilial("SB1")+_cDescPai,"B1_UM")
		@Li,79 PSay "|"
		Li++
		@Li,00 PSay "|"
		@Li,79 PSay "|"
		Li++
		
		dbSelectArea("SC2")
		dbGoTo(_nRecSC2)
		
		While SD4->D4_OP	==	SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD)
			
			If Subs(SD4->D4_COD,1,3)$"MOD"
				dbSkip()
				Loop
			EndIf
			
			@Li,00 PSay "| "+SD4->D4_COD
			@Li,Pcol()+01	Psay Posicione("SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_DESC")
			@Li,Pcol()+10	Psay SD4->D4_QUANT	 Picture "999,999,999.99"
			@Li,Pcol()+01	Psay Posicione("SB1",1,xFilial("SB1")+SD4->D4_COD,"B1_UM")
			@Li,79 PSay "|"
			Li++
			
			_nCountEmp += 1
			dbSelectArea("SD4")
			dbSkip()
		EndDo
	EndIf
	
	For i:= 1 to ( 24 - _nCountEmp )
		@Li,00 PSay "|"
		@Li,79 PSay "|"
		Li++
	Next
	
	//----> SE NAO POSSUI OP PAI, IMPRIME ONDE E USADO
Else
	dbSelectArea("SG1")
	dbSetOrder(2)
	If dbSeek(xFilial("SG1")+SC2->C2_PRODUTO,.F.)
		While SG1->G1_COMP == SC2->C2_PRODUTO
			@Li,00 PSay "| "+SG1->G1_COD
			@Li,Pcol()+01	Psay Posicione("SB1",1,xFilial("SB1")+SG1->G1_COD,"B1_DESC")
			@Li,79 PSay "|"
			Li++
			
			_nCountEmp += 1
			dbSelectArea("SG1")
			dbSkip()
		EndDo
	Else
		@Li,00 PSay "| O PRODUTO "+Alltrim(SC2->C2_PRODUTO)
		@Li,Pcol()+01	Psay Alltrim(Posicione("SB1",1,xFilial("SB1")+SC2->C2_PRODUTO,"B1_DESC"))
		@Li,Pcol()+01	Psay " NAO FAZ PARTE DE NENHUMA ESTRUTURA"
		@Li,79 PSay "|"
		Li++
	EndIf
	
	For i:= 1 to ( 24 - _nCountEmp )
		@Li,00 PSay "|"
		@Li,79 PSay "|"
		Li++
	Next
	
EndIf

@Li,00 PSay "|"
@Li,79 PSay "|"

Return(Li)
