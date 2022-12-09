#INCLUDE "rwmake.ch"
#Include "Protheus.ch"       // (04/12/2019 - Luiz M. Suguiura)
#Include "TopConn.ch"        // (04/12/2019 - Luiz M. Suguiura)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RFATR20  ³ Autor ³ Ricardo Correa de Souza ³ Data ³ 01/04/2016 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de Faturamento por Periodo                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MAXLOVE                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³             ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador   ³  Data  ³              Motivo da Alteracao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATR20()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Programa que tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relacao de Faturamento por Nota Fiscal"
Local cPict          := ""
Local titulo         := "Relacao de Faturamento por Nota Fiscal"
Local nLin         	 := 80
Local Cabec1       	 := ""
Local Cabec2       	 := ""
Local imprime      	 := .T.

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "FATR20"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RFATR20"
Private cString 	 := "SF2"
Private cPerg   	 := "FATR20"
Private nOrdem

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_aRegs := {}

AAdd(_aRegs,{cPerg,"01","Data Inicial ?   		","Data Inicial ?   		","Data Inicial ?   		","mv_ch0","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"02","Data Final ?     		","Data Final ?     		","Data Final ?     		","mv_ch0","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"03","Da Serie ?       		","Da Serie ?     ? 		","Da Serie ?       		","mv_ch0","C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"04","Ate a Serie ?    		","Ate a Serie ?    		","Ate a Serie ?    		","mv_ch0","C",03,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"05","Formato ?        		","Formato ?        		","Formato ?        		","mv_ch0","N",01,0,0,"C","","mv_par05","Sintetico","","","","","Analitico","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"06","Gera Excel ?     		","Gera Excel ?     		","Gera Excel ?     		","mv_ch0","N",01,0,0,"C","","mv_par06","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"07","Inclui Devol ?   		","Gera Excel ?     		","Gera Excel ?     		","mv_ch0","N",01,0,0,"C","","mv_par07","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"08","Do Cliente ?     		","Da Serie ?     ? 		","Da Serie ?       		","mv_ch0","C",06,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"09","Da Loja ?        		","Ate a Serie ?    		","Ate a Serie ?    		","mv_ch0","C",02,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"10","Ate o Cliente ?  		","Da Serie ?     ? 		","Da Serie ?       		","mv_ch0","C",06,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"11","Ate a Loja ?     		","Ate a Serie ?    "		,"Ate a Serie ?    			","mv_ch0","C",02,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","",""})
//AAdd(_aRegs,{cPerg,"13","Considera Impostos ?     		","Considera Impostos ?    "		,"Considera Impostos ? ?    			","mv_ch0","C",02,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","",""})

//ValidPerg(_aRegs,cPerg)

Pergunte(cPerg,.F.)

dbSelectArea(cString)
dbSetOrder(1)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)
nOrdem:= aReturn[8]

//----> pega as propriedades do usuario para formatar relatorio (nf/pf)  __cUserID
//_aRetUser := PswRet(1)
//_cGrupo   := Iif(Len(_aRetUser)>0,upper(alltrim(_aRetUser[1,10,1])),"")
_cGrupo:="000000/000001"


//----> FORMATO SINTETICO
If mv_par05 == 1
	Cabec1       	 := "DATA            VALOR DO       VALOR DO       VALOR DO       VALOR DO         TOTAL        TOTAL           TOTAL  "
	Cabec2       	 := "EMISSAO         PRODUTO        IPI            ICMS ST        ICMS             NORMAL       ESPECIAL        FAT BRU"

//----> FORMATO ANALITICO
Else
	Cabec1       	 := "DATA      NOTA       PEDIDO  CODCLI  CLIENTE          VALOR DO       VALOR DO       VALOR DO       VALOR DO         TOTAL        TOTAL           TOTAL       CFOP    VENCTOS"
	Cabec2       	 := "EMISSAO                                               PRODUTO        IPI            ICMS ST        ICMS             NORMAL       ESPECIAL        FAT BRU                    "
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  23/05/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local	_cNomEmp	:=	""
Local   i 			:= 0 
Local	_nEmpFAT	:=	0
Local	_nEmpIPI	:=	0
Local	_nEmpICM	:=	0
Local	_nEmpSUB 	:=	0
Local	_nEmpSSP	:=	0
Local	_nEmpCNF	:=	0
Local	_nEmpSNF	:=	0

Local	_nEmpFAT2	:=	0
Local	_nEmpIPI2	:=	0
Local	_nEmpICM2	:=	0
Local	_nEmpSUB2 	:=	0
Local	_nEmpSSP2	:=	0
Local	_nEmpCNF2	:=	0
Local	_nEmpSNF2	:=	0

Local	_nGloFAT	:=	0
Local	_nGloIPI	:=	0
Local	_nGloICM	:=	0
Local	_nGloSUB	:=	0
Local	_nGloSSP	:=	0
Local	_nGloCNF	:=	0
Local	_nGloSNF	:=	0

Local	_nGloFAT2	:=	0
Local	_nGloIPI2	:=	0
Local	_nGloICM2	:=	0
Local	_nGloSUB2	:=	0
Local	_nGloSSP2	:=	0
Local	_nGloCNF2	:=	0
Local	_nGloSNF2	:=	0

Private	_cCodCli	:=	""
Private	_cLojCli	:=	""
Private	_cCliente	:=	""
Private	_dData		:=	CTOD("  /  /  ")
Private	_cCodEmp	:=	""
Private _cNota		:=	""
Private _cPedido	:=	""
Private _cCFOP		:=	""

Private	_nTotFAT	:=	0
Private	_nTotIPI	:=	0
Private	_nTotICM	:=	0
Private	_nTotSUB	:=	0
Private	_nTotSSP	:=	0
Private	_nTotCNF	:=	0
Private	_nTotSNF	:=	0

Private	_nTotFAT2	:=	0
Private	_nTotIPI2	:=	0
Private	_nTotICM2	:=	0
Private	_nTotSUB2	:=	0
Private	_nTotSSP2	:=	0
Private	_nTotCNF2	:=	0
Private	_nTotSNF2	:=	0


Private _aCFOP_1		:=	{}
Private _aCFOP_2		:=	{}
Private _aVencto		:=	{}


BuscaFat()	//----> query para busca dos dados de faturamento
BuscaDev()	//----> query para busca dos dados de Devolucao

//----> FORMATO SINTETICO
If mv_par05 == 1
	dbSelectArea("QUERY")
	SetRegua(RecCount())
	dbGoTop()
	
	While !Eof()
		
		If lAbortPrint
			@nLin,000		 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		If !Empty(aReturn[7]) .And. !&(aReturn[7])
			dbSelectArea("QUERY")
			dbSkip()
			Loop
		EndIf
		
		dbSelectArea("QUERY")
		
		_dData		:=	QUERY->D2_EMISSAO
		
		dbSelectArea("QUERY")
		
		While Eof() == .f. .And. _dData	==	QUERY->(D2_EMISSAO)
			
			
			If !Empty(aReturn[7]) .And. !&(aReturn[7])
				dbSelectArea("QUERY")
				dbSkip()
				Loop
			EndIf
			
			
			If QUERY->D2_SERIE$"BOL/REC"
				
				_nTotFAT	+=0
				_nTotIPI	+=QUERY->D2_VALIPI
				_nTotICM	+=QUERY->D2_VALICM
				_nTotSSP	+=Iif(QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0)
				_nTotSUB	+=Iif(!QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0)
				_nTotCNF	+=0
				_nTotSNF	+=(QUERY->D2_TOTAL + QUERY->D2_VALIPI + QUERY->D2_ICMSRET)
				
			Else
				
				_nTotFAT	+=QUERY->D2_TOTAL
				_nTotIPI	+=QUERY->D2_VALIPI
				_nTotICM	+=QUERY->D2_VALICM
				_nTotSSP	+=Iif(QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0)
				_nTotSUB	+=Iif(!QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0)
				_nTotCNF	+=(QUERY->D2_TOTAL + QUERY->D2_VALIPI + QUERY->D2_ICMSRET + QUERY->D2_DESPESA + QUERY->D2_VALFRE + QUERY->D2_SEGURO)
				_nTotSNF	+=(QUERY->C6_PRCVEN2 * QUERY->D2_QUANT)
				
			EndIf
			
			
			If QUERY->D2_SERIE$"BOL/REC"
				If aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF }) == 0
					AADD(_aCFOP_1,{QUERY->D2_CF,;
					0,;
					QUERY->D2_VALIPI,;
					QUERY->D2_VALICM,;
					Iif(QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0),;
					Iif(!QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0),;
					0,;
					(QUERY->D2_TOTAL + QUERY->D2_VALIPI + QUERY->D2_ICMSRET + QUERY->D2_DESPESA + QUERY->D2_VALFRE + QUERY->D2_SEGURO),;
					(0+(QUERY->D2_TOTAL + QUERY->D2_VALIPI + QUERY->D2_ICMSRET)-QUERY->D2_VALIPI-QUERY->D2_VALICM-Iif(QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0)-Iif(!QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0) - QUERY->D2_DESPESA - QUERY->D2_VALFRE - QUERY->D2_SEGURO),;
					(0+(QUERY->D2_TOTAL + QUERY->D2_VALIPI + QUERY->D2_ICMSRET + QUERY->D2_DESPESA + QUERY->D2_VALFRE + QUERY->D2_SEGURO))})
				Else
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][02]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][02] + 0
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][03]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][03] + QUERY->D2_VALIPI
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][04]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][04] + QUERY->D2_VALICM
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][05]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][05] + Iif(QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0)
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][06]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][06] + Iif(!QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0)
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][07]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][07] + 0
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][08]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][08] + (QUERY->D2_TOTAL + QUERY->D2_VALIPI + QUERY->D2_ICMSRET)
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][09]	:=	(_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][08] + _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][07]) - _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][03] - _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][04] - _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][05] - _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][06]
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][10]	:=	(_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][08] + IIf( _cGrupo$"000000/000001",_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][07],0))
				EndIf
			Else
				If aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF }) == 0

					If MV_PAR13 == 1
						AADD(_aCFOP_1,{QUERY->D2_CF,;
						QUERY->D2_TOTAL,;
						QUERY->D2_VALIPI,;
						QUERY->D2_VALICM,;
						Iif(QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0),;
						Iif(!QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0),;
						(QUERY->D2_TOTAL + QUERY->D2_VALIPI + QUERY->D2_ICMSRET + QUERY->D2_DESPESA + QUERY->D2_VALFRE + QUERY->D2_SEGURO),;
						(QUERY->C6_PRCVEN2 * QUERY->D2_QUANT),;
						((QUERY->D2_TOTAL + QUERY->D2_VALIPI + QUERY->D2_ICMSRET + QUERY->D2_DESPESA + QUERY->D2_VALFRE + QUERY->D2_SEGURO)+(QUERY->C6_PRCVEN2 * QUERY->D2_QUANT)-QUERY->D2_VALIPI-QUERY->D2_VALICM-Iif(QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0)-Iif(!QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0) - QUERY->D2_DESPESA - QUERY->D2_VALFRE - QUERY->D2_SEGURO),;
						((QUERY->D2_TOTAL + QUERY->D2_VALIPI + QUERY->D2_ICMSRET+ QUERY->D2_DESPESA + QUERY->D2_VALFRE + QUERY->D2_SEGURO)+IIf( _cGrupo$"000000/000001",(QUERY->C6_PRCVEN2 * QUERY->D2_QUANT),0))})
					Else
						AADD(_aCFOP_1,{QUERY->D2_CF,;
						QUERY->D2_TOTAL,;
						QUERY->D2_VALIPI,;
						QUERY->D2_VALICM,;
						Iif(QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0),;
						Iif(!QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0),;
						(QUERY->D2_TOTAL + QUERY->D2_VALIPI + QUERY->D2_ICMSRET + QUERY->D2_DESPESA + QUERY->D2_VALFRE + QUERY->D2_SEGURO),;
						(QUERY->C6_PRCVEN2 * QUERY->D2_QUANT),;
						((QUERY->D2_TOTAL + QUERY->D2_VALIPI + QUERY->D2_ICMSRET + QUERY->D2_DESPESA + QUERY->D2_VALFRE + QUERY->D2_SEGURO)+(QUERY->C6_PRCVEN2 * QUERY->D2_QUANT)-QUERY->D2_VALIPI-QUERY->D2_VALICM-Iif(QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0)-Iif(!QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0) - QUERY->D2_DESPESA - QUERY->D2_VALFRE - QUERY->D2_SEGURO),;
						((QUERY->D2_TOTAL + QUERY->D2_VALIPI + QUERY->D2_ICMSRET + QUERY->D2_DESPESA + QUERY->D2_VALFRE + QUERY->D2_SEGURO)+IIf( _cGrupo$"000000/000001",(QUERY->C6_PRCVEN2 * QUERY->D2_QUANT),0))})
					EndIf					

				Else
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][02]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][02] + QUERY->D2_TOTAL
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][03]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][03] + QUERY->D2_VALIPI
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][04]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][04] + QUERY->D2_VALICM
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][05]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][05] + Iif(QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0)
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][06]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][06] + Iif(!QUERY->A1_EST$"SP",QUERY->D2_ICMSRET ,0)
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][07]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][07] + (QUERY->D2_TOTAL + QUERY->D2_VALIPI + QUERY->D2_ICMSRET + QUERY->D2_DESPESA + QUERY->D2_VALFRE + QUERY->D2_SEGURO) 
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][08]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][08] + (QUERY->C6_PRCVEN2 * QUERY->D2_QUANT)
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][09]	:=	(_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][08] + _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][07]) - _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][03] - _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][04] - _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][05] - _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][06]
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][10]	:=	(_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][08] + _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][07])
				EndIf
			EndIf
			
			dbSelectArea("QUERY")
	        dbSkip()			
		EndDo
		
		//----> GERAR PLANILHA EXCEL
		If MV_PAR06 == 1
		    // Alert("Gera Excel - QUERY - Sintetico")
			GeraExcel(.T.)
		EndIf
		
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		@ nLin, 000			PSAY _dData
		@ nLin, Pcol()+002	PSAY _nTotFAT													Picture "@E 999,999,999.99"
		@ nLin, Pcol()+001	PSAY _nTotIPI													Picture "@E 999,999,999.99"
		@ nLin, Pcol()+001	PSAY _nTotSSP+_nTotSUB											Picture "@E 999,999,999.99"
		@ nLin, Pcol()+001	PSAY _nTotICM													Picture "@E 999,999,999.99"
		//		@ nLin, Pcol()+001	PSAY _nTotSUB													Picture "@E 999,999,999.99"
		@ nLin, Pcol()+001	PSAY _nTotCNF													Picture "@E 999,999,999.99"
		@ nLin, Pcol()+001	PSAY _nTotSNF													Picture "@E 999,999,999.99"
		//		@ nLin, Pcol()+002	PSAY ((_nTotCNF + _nTotSNF) - _nTotIpi - _nTotSSP - _nTotSUB - _nTotICM)	Picture "@E 999,999,999.99"
		@ nLin, Pcol()+001	PSAY (_nTotCNF+_nTotSNF)										Picture "@E 999,999,999.99"
		
		nLin += 1
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		_nEmpFAT	+=	_nTotFAT
		_nEmpIPI	+=	_nTotIPI
		_nEmpSUB	+=	_nTotSUB
		_nEmpSSP	+=	_nTotSSP
		_nEmpICM	+=	_nTotICM
		_nEmpCNF	+=	_nTotCNF
		_nEmpSNF	+=	_nTotSNF
		
		_nGloFAT	+=	_nTotFAT
		_nGloIPI	+=	_nTotIPI
		_nGloSUB	+=	_nTotSUB
		_nGloSSP	+=	_nTotSSP
		_nGloICM	+=	_nTotICM
		_nGloCNF	+=	_nTotCNF
		_nGloSNF	+=	_nTotSNF
		
		_nTotFAT	:=	0
		_nTotIPI	:=	0
		_nTotSUB	:=	0
		_nTotSSP	:=	0
		_nTotICM	:=	0
		_nTotCNF	:=	0
		_nTotSNF	:=	0
		
		dbSelectArea("QUERY")
		//dbskip()
		
	EndDo
	
	
	//----> INCLUI DEVOLUCAO
	If mv_par07 == 1
		dbSelectArea("QUERY2")
		SetRegua(RecCount())
		dbGoTop()
		
		While !Eof()
			
			If lAbortPrint
				@nLin,000		 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif
			
			If nLin > 60
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
			
			If !Empty(aReturn[7]) .And. !&(aReturn[7])
				dbSelectArea("QUERY2")
				dbSkip()
				Loop
			EndIf
			
			dbSelectArea("QUERY2")
			
			_dData		:=	QUERY2->D1_DTDIGIT
			
			dbSelectArea("QUERY2")
			
			While Eof() == .f. .And. _dData	==	QUERY2->(D1_DTDIGIT)
				
				If !Empty(aReturn[7]) .And. !&(aReturn[7])
					dbSelectArea("QUERY2")
					dbSkip()
					Loop
				EndIf
				
				If QUERY2->D1_SERIE$"BOL/REC"
					
					_nTotFAT2	+=0
					_nTotIPI2	+=((-1)*QUERY2->D1_VALIPI)
					_nTotICM2	+=((-1)*QUERY2->D1_VALICM)
					_nTotSSP2	+=Iif(QUERY2->A1_EST$"SP",((-1)*QUERY2->D1_ICMSRET),0)
					_nTotSUB2	+=Iif(!QUERY2->A1_EST$"SP",((-1)*QUERY2->D1_ICMSRET),0)
					_nTotCNF2	+=0
					_nTotSNF2	+=((-1)*(QUERY2->D1_TOTAL + QUERY2->D1_VALIPI + QUERY2->D1_ICMSRET))
					
				Else
					
					_nTotFAT2	+=((-1)*QUERY2->D1_TOTAL)
					_nTotIPI2	+=((-1)*QUERY2->D1_VALIPI)
					_nTotICM2	+=((-1)*QUERY2->D1_VALICM)
					_nTotSSP2	+=Iif(QUERY2->A1_EST$"SP",((-1)*QUERY2->D1_ICMSRET),0)
					_nTotSUB2	+=Iif(!QUERY2->A1_EST$"SP",((-1)*QUERY2->D1_ICMSRET),0)
						IF MV_PAR13 == 1
							_nTotCNF2	+=((-1)*(QUERY2->D1_TOTAL + QUERY2->D1_VALIPI + QUERY2->D1_ICMSRET + QUERY2->D1_DESPESA + QUERY2->D1_VALFRE + QUERY2->D1_SEGURO))
						Else
							_nTotCNF2	+=((-1)*(QUERY2->D1_TOTAL + QUERY2->D1_VALIPI + QUERY2->D1_ICMSRET))
						EndIf
					_nTotSNF2	+=0		//(QUERY2->C6_PRCVEN2 * QUERY->D1_QUANT)
					
				EndIf
				
				
				If QUERY2->D1_SERIE$"BOL/REC"
					If aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF }) == 0
						AADD(_aCFOP_1,{QUERY2->D1_CF,;
						0,;
						((-1)*QUERY2->D1_VALIPI),;
						((-1)*QUERY2->D1_VALICM),;
						Iif(QUERY2->A1_EST$"SP",((-1)*QUERY2->D1_ICMSRET),0),;
						Iif(!QUERY2->A1_EST$"SP",QUERY2->D1_ICMSRET,0),;
						0,;
						(QUERY2->D1_TOTAL + QUERY2->D1_VALIPI + QUERY2->D1_ICMSRET + QUERY2->D1_DESPESA + QUERY2->D1_VALFRE + QUERY2->D1_SEGURO),;
						(0+(QUERY2->D1_TOTAL + QUERY2->D1_VALIPI + QUERY2->D1_ICMSRET + QUERY2->D1_DESPESA + QUERY2->D1_VALFRE + QUERY2->D1_SEGURO)-QUERY2->D1_VALIPI-QUERY2->D1_VALICM-Iif(QUERY2->A1_EST$"SP",((-1)*QUERY2->D1_ICMSRET),0)-Iif(!QUERY2->A1_EST$"SP",((-1)*QUERY2->D1_ICMSRET),0) - ((-1)*(QUERY2->D1_DESPESA - QUERY2->D1_VALFRE - QUERY2->D1_SEGURO))),;
						(0+((-1)*(QUERY2->D1_TOTAL + QUERY2->D1_VALIPI + QUERY2->D1_ICMSRET + QUERY2->D1_DESPESA + QUERY2->D1_VALFRE + QUERY2->D1_SEGURO )))})
					Else
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][02]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][02] + 0
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][03]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][03] + ((-1)*QUERY2->D1_VALIPI)
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][04]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][04] + ((-1)*QUERY2->D1_VALICM)
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][05]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][05] + Iif(QUERY2->A1_EST$"SP",((-1)*QUERY2->D1_ICMSRET),0)
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][06]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][06] + Iif(!QUERY2->A1_EST$"SP",((-1)*QUERY2->D1_ICMSRET),0)
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][07]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][07] + 0
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][08]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][08] + ((-1)*(QUERY2->D1_TOTAL + QUERY2->D1_VALIPI + QUERY2->D1_ICMSRET))
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][09]	:=	(_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][08] + _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][07]) - _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][03] - _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][04] - _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][05] - _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][06]
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][10]	:=	(_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][08] + IIf( _cGrupo$"000000/000001",_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][07],0))
					EndIf
				Else
					If aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF }) == 0

						If MVPAR13 == '1' 
							AADD(_aCFOP_1,{QUERY2->D1_CF,;
							((-1)*QUERY2->D1_TOTAL),;
							((-1)*QUERY2->D1_VALIPI),;
							((-1)*QUERY2->D1_VALICM),;
							Iif(QUERY2->A1_EST$"SP",((-1)*QUERY2->D1_ICMSRET),0),;
							Iif(!QUERY2->A1_EST$"SP",((-1)*QUERY2->D1_ICMSRET),0),;
							((-1)*(QUERY2->D1_TOTAL + QUERY2->D1_VALIPI + QUERY2->D1_ICMSRET + QUERY2->D1_DESPESA + QUERY2->D1_VALFRE + QUERY2->D1_SEGURO)),;
							(0),;
							((-1)*((QUERY2->D1_TOTAL + QUERY2->D1_VALIPI + QUERY2->D1_ICMSRET + QUERY2->D1_DESPESA + QUERY2->D1_VALFRE + QUERY2->D1_SEGURO)+(0)-QUERY2->D1_VALIPI-QUERY2->D1_VALICM-Iif(QUERY2->A1_EST$"SP",QUERY2->D1_ICMSRET,0)-Iif(!QUERY2->A1_EST$"SP",QUERY2->D1_ICMSRET,0) - QUERY2->D1_DESPESA - QUERY2->D1_VALFRE - QUERY2->D1_SEGURO)),;
							((-1)*((QUERY2->D1_TOTAL + QUERY2->D1_VALIPI + QUERY2->D1_ICMSRET + QUERY2->D1_VALFRE + QUERY2->D1_DESPESA + QUERY2->D1_SEGURO )+IIf( _cGrupo$"000000/000001",(0),0)))})
						Else
							AADD(_aCFOP_1,{QUERY2->D1_CF,;
							((-1)*QUERY2->D1_TOTAL),;
							((-1)*QUERY2->D1_VALIPI),;
							((-1)*QUERY2->D1_VALICM),;
							Iif(QUERY2->A1_EST$"SP",((-1)*QUERY2->D1_ICMSRET),0),;
							Iif(!QUERY2->A1_EST$"SP",((-1)*QUERY2->D1_ICMSRET),0),;
							((-1)*(QUERY2->D1_TOTAL + QUERY2->D1_VALIPI + QUERY2->D1_ICMSRET + QUERY2->D1_VALFRE + QUERY2->D1_DESPESA + QUERY2->D1_SEGURO)),;
							(0),;
							((-1)*((QUERY2->D1_TOTAL + QUERY2->D1_VALIPI + QUERY2->D1_ICMSRET + QUERY2->D1_DESPESA + QUERY2->D1_VALFRE + QUERY2->D1_SEGURO)+(0)-QUERY2->D1_VALIPI-QUERY2->D1_VALICM-Iif(QUERY2->A1_EST$"SP",QUERY2->D1_ICMSRET,0)-Iif(!QUERY2->A1_EST$"SP",QUERY2->D1_ICMSRET,0) - QUERY2->D1_DESPESA - QUERY2->D1_VALFRE - QUERY2->D1_SEGURO)),;
							((-1)*((QUERY2->D1_TOTAL + QUERY2->D1_VALIPI + QUERY2->D1_ICMSRET + QUERY2->D1_DESPESA + QUERY2->D1_VALFRE + QUERY2->D1_SEGURO)+IIf( _cGrupo$"000000/000001",(0),0)))})
						EndIf

					Else
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][02]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][02] + ((-1)*QUERY2->D1_TOTAL)
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][03]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][03] + ((-1)*QUERY2->D1_VALIPI)
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][04]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][04] + ((-1)*QUERY2->D1_VALICM)
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][05]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][05] + Iif(QUERY2->A1_EST$"SP",((-1)*QUERY2->D1_ICMSRET),0)
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][06]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][06] + Iif(!QUERY2->A1_EST$"SP",((-1)*QUERY2->D1_ICMSRET),0)
							If MVPAR13 == 1
								_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][07]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][07] + ((-1)*(QUERY2->D1_TOTAL + QUERY2->D1_VALIPI + QUERY2->D1_ICMSRET + QUERY2->D1_VALFRE + QUERY2->D1_DESPESA + QUERY2->D1_SEGURO ))
							Else
								_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][07]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][07] + ((-1)*(QUERY2->D1_TOTAL + QUERY2->D1_VALIPI + QUERY2->D1_ICMSRET))
							EndIf
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][08]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][08] + ((-1)*(QUERY2->D1_VUNIT * QUERY2->D1_QUANT))
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][09]	:=	(_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][08] + _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][07]) - _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][03] - _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][04] - _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][05] - _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][06]						
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][10]	:=	(_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][08] + _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][07])
						

					EndIf
				EndIf
				
				dbSelectArea("QUERY2")
				dbSkip()
				
			EndDo
			
			//----> GERAR PLANILHA EXCEL
			If MV_PAR06 == 1
			    // Alert("Gera Excel - QUERY2 - Sintetico")
				GeraExcel(.F.)
			EndIf
			
			If nLin > 60
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
			
			@ nLin, 000			PSAY _dData
			@ nLin, Pcol()+002	PSAY _nTotFAT2													Picture "@E 999,999,999.99"
			@ nLin, Pcol()+001	PSAY _nTotIPI2													Picture "@E 999,999,999.99"
			@ nLin, Pcol()+001	PSAY _nTotSSP2+_nTotSUB2										Picture "@E 999,999,999.99"
			@ nLin, Pcol()+001	PSAY _nTotICM2													Picture "@E 999,999,999.99"
			//		@ nLin, Pcol()+001	PSAY _nTotSUB2													Picture "@E 999,999,999.99"
			//----> USUARIOS GRUPO GESTORES
			@ nLin, Pcol()+001	PSAY _nTotCNF2													Picture "@E 999,999,999.99"
			@ nLin, Pcol()+001	PSAY _nTotSNF2													Picture "@E 999,999,999.99"
			//		@ nLin, Pcol()+002	PSAY ((_nTotCNF + _nTotSNF) - _nTotIpi - _nTotSSP - _nTotSUB - _nTotICM)	Picture "@E 999,999,999.99"
			@ nLin, Pcol()+001	PSAY _nTotCNF2+_nTotSNF2										Picture "@E 999,999,999.99"
			
			nLin += 1
			If nLin > 60
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
			
			_nEmpFAT2	+=	_nTotFAT2
			_nEmpIPI2	+=	_nTotIPI2
			_nEmpSUB2	+=	_nTotSUB2
			_nEmpSSP2	+=	_nTotSSP2
			_nEmpICM2	+=	_nTotICM2
			_nEmpCNF2	+=	_nTotCNF2
			_nEmpSNF2	+=	_nTotSNF2
			
			_nGloFAT2	+=	_nTotFAT2
			_nGloIPI2	+=	_nTotIPI2
			_nGloSUB2	+=	_nTotSUB2
			_nGloSSP2	+=	_nTotSSP2
			_nGloICM2	+=	_nTotICM2
			_nGloCNF2	+=	_nTotCNF2
			_nGloSNF2	+=	_nTotSNF2
			
			_nTotFAT2	:=	0
			_nTotIPI2	:=	0
			_nTotSUB2	:=	0
			_nTotSSP2	:=	0
			_nTotICM2	:=	0
			_nTotCNF2	:=	0
			_nTotSNF2	:=	0
			
			dbSelectArea("QUERY2")
		EndDo
	EndIf
	
	If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	
	If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	nLin += 2
	If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	@ nLin, 000			PSAY "TOTAL -->"
	@ nLin, Pcol()+001	PSAY _nGloFAT+_nGloFAT2													Picture "@E 999,999,999.99"
	@ nLin, Pcol()+001	PSAY _nGloIPI+_nGloIPI2													Picture "@E 999,999,999.99"
	@ nLin, Pcol()+001	PSAY _nGloSSP+_nGloSUB+_nGloSSP2+_nGloSUB2								Picture "@E 999,999,999.99"
	@ nLin, Pcol()+001	PSAY _nGloICM+_nGloICM2													Picture "@E 999,999,999.99"
	@ nLin, Pcol()+001	PSAY _nGloCNF+_nGloCNF2												Picture "@E 999,999,999.99"
	@ nLin, Pcol()+001	PSAY _nGloSNF+_nGloSNF2												Picture "@E 999,999,999.99"
	//	@ nLin, Pcol()+001	PSAY ((_nGloCNF + _nGloSNF) - _nGloIpi - _nGloSSP - _nGloSUB - _nGloICM)	Picture "@E 999,999,999.99"
	@ nLin, Pcol()+001	PSAY (_nGloCNF+_nGloCNF2+_nGloSNF+_nGloSNF2)										Picture "@E 999,999,999.99"
	
	dbSelectArea("QUERY")
	dbCloseArea("QUERY")
	
	dbSelectArea("QUERY2")
	dbCloseArea("QUERY2")
	
	nLin += 1
	
	@ nLin, 000			PSAY __PrtThinLine()
	
	nLin += 1
	If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	@ nLin, 000			PSAY PADC("R E S U M O    P O R    C F O P",220)
	nLin += 2
	If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	_aCFOP_1 := aSort( _aCFOP_1,,,{|x,y| x[1] < y[1]})
	
	For i := 1 to Len(_aCFOP_1)
		
		@ nLin, 000			PSAY _aCFOP_1[i,01]
		@ nLin, Pcol()+005	PSAY _aCFOP_1[i,02]													Picture "@E 999,999,999.99"
		@ nLin, Pcol()+001	PSAY _aCFOP_1[i,03]													Picture "@E 999,999,999.99"
		@ nLin, Pcol()+001	PSAY _aCFOP_1[i,05]+_aCFOP_1[i,06]									Picture "@E 999,999,999.99"
		@ nLin, Pcol()+001	PSAY _aCFOP_1[i,04]													Picture "@E 999,999,999.99"
		//		@ nLin, Pcol()+001	PSAY _aCFOP_1[i,06]													Picture "@E 999,999,999.99"
		
		@ nLin, Pcol()+001	PSAY _aCFOP_1[i,07]													Picture "@E 999,999,999.99"
		@ nLin, Pcol()+001	PSAY _aCFOP_1[i,08]													Picture "@E 999,999,999.99"
		
		//		@ nLin, Pcol()+002	PSAY _aCFOP_1[i,09]													Picture "@E 999,999,999.99"
		@ nLin, Pcol()+001	PSAY _aCFOP_1[i,10]													Picture "@E 999,999,999.99"
		
		nLin += 1
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
	Next
	
	nLin += 1
	
	@ nLin, 000			PSAY __PrtThinLine()
	
	
	//----> FORMATO ANALITICO
Else
	dbSelectArea("QUERY")
	SetRegua(RecCount())
	dbGoTop()
	
	While !Eof()
		
		If lAbortPrint
			@nLin,000		 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		If !Empty(aReturn[7]) .And. !&(aReturn[7])
			dbSelectArea("QUERY")
			dbSkip()
			Loop
		EndIf
		
		
		_dData		:=	QUERY->D2_EMISSAO
		
		dbSelectArea("QUERY")
		
		_cChave		:=	QUERY->(D2_FILIAL+DTOS(D2_EMISSAO)+D2_DOC+D2_SERIE)
		_cChavSE1	:=	QUERY->(D2_CLIENTE+D2_LOJA+D2_SERIE+D2_DOC)
		_cCodCli	:=	QUERY->D2_CLIENTE
		_cCliente	:=	SUBS(QUERY->A1_NREDUZ,1,10)
		_cPedido	:=	QUERY->D2_PEDIDO
		_cNota		:=	QUERY->D2_DOC
		_cCFOP		:=	QUERY->D2_CF
		
		dbSelectArea("QUERY")
		While Eof() == .f. .And. _cChave == QUERY->(D2_FILIAL+DTOS(D2_EMISSAO)+D2_DOC+D2_SERIE)
			
			If QUERY->D2_SERIE$"BOL/REC"
				_nTotFAT	+=0
				_nTotIPI	+=QUERY->D2_VALIPI
				_nTotICM	+=QUERY->D2_VALICM
				_nTotSSP	+=Iif(QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0)
				_nTotSUB	+=Iif(!QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0)
				_nTotCNF	+=0
				_nTotSNF	+=(QUERY->D2_TOTAL + QUERY->D2_VALIPI + QUERY->D2_ICMSRET)
			Else
				_nTotFAT	+=QUERY->D2_TOTAL
				_nTotIPI	+=QUERY->D2_VALIPI
				_nTotICM	+=QUERY->D2_VALICM
				_nTotSSP	+=Iif(QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0)
				_nTotSUB	+=Iif(!QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0)

				If MV_PAR13 == 1
					_nTotCNF	+= (QUERY->D2_TOTAL + QUERY->D2_VALIPI + QUERY->D2_ICMSRET + QUERY->D2_DESPESA + QUERY->D2_SEGURO + QUERY->D2_VALFRE) 
				ELSE
					_nTotCNF	+=(QUERY->D2_TOTAL + QUERY->D2_VALIPI + QUERY->D2_ICMSRET)
				ENDIF
				_nTotSNF	+=(QUERY->C6_PRCVEN2 * QUERY->D2_QUANT)
			EndIf
			
			If QUERY->D2_SERIE$"BOL/REC"
				If aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF }) == 0
					AADD(_aCFOP_1,{QUERY->D2_CF,;
					0,;
					QUERY->D2_VALIPI,;
					QUERY->D2_VALICM,;
					Iif(QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0),;
					Iif(!QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0),;
					0,;
					(QUERY->D2_TOTAL + QUERY->D2_VALIPI + QUERY->D2_ICMSRET + QUERY->D2_DESPESA + QUERY->D2_VALFRE + QUERY->D2_SEGURO),;
					(0+(QUERY->D2_TOTAL + QUERY->D2_VALIPI + QUERY->D2_ICMSRET + QUERY->D2_DESPESA + QUERY->D2_VALFRE + QUERY->D2_SEGURO)-QUERY->D2_VALIPI-QUERY->D2_VALICM-Iif(QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0)-Iif(!QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0) - QUERY->D2_DESPESA - QUERY->D2_VALFRE - QUERY->D2_SEGURO),;
					(0+(QUERY->D2_TOTAL + QUERY->D2_VALIPI + QUERY->D2_ICMSRET + QUERY->D2_DESPESA + QUERY->D2_VALFRE + QUERY->D2_SEGURO))})				
				Else
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][02]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][02] + 0
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][03]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][03] + QUERY->D2_VALIPI
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][04]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][04] + QUERY->D2_VALICM
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][05]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][05] + Iif(QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0)
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][06]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][06] + Iif(!QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0)				
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][07]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][07] + 0
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][08]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][08] + (QUERY->D2_TOTAL + QUERY->D2_VALIPI + QUERY->D2_ICMSRET)
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][09]	:=	(_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][08] + _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][07]) - _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][03] - _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][04] - _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][05] - _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][06]
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][10]	:=	(_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][08] + _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][07])
				EndIf
			Else
				If aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF }) == 0

					If MV_PAR13 == 1
						AADD(_aCFOP_1,	{QUERY->D2_CF,;
										QUERY->D2_TOTAL,;
										QUERY->D2_VALIPI,;
										QUERY->D2_VALICM,;
										Iif(QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0),;
										Iif(!QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0),;
										(QUERY->D2_TOTAL + QUERY->D2_VALIPI + QUERY->D2_ICMSRET + QUERY->D2_DESPESA + QUERY->D2_VALFRE + QUERY->D2_SEGURO),;
										(QUERY->C6_PRCVEN2 * QUERY->D2_QUANT),;
										((QUERY->D2_TOTAL + QUERY->D2_VALIPI + QUERY->D2_ICMSRET + QUERY->D2_DESPESA + QUERY->D2_VALFRE + QUERY->D2_SEGURO)+(QUERY->C6_PRCVEN2 * QUERY->D2_QUANT)-QUERY->D2_VALIPI-QUERY->D2_VALICM-Iif(QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0)-Iif(!QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0) - QUERY->D2_DESPESA - QUERY->D2_VALFRE - QUERY->D2_SEGURO),;
										((QUERY->D2_TOTAL + QUERY->D2_VALIPI + QUERY->D2_ICMSRET + QUERY->D2_DESPESA + QUERY->D2_VALFRE + QUERY->D2_SEGURO)+IIf( _cGrupo$"000000/000001",(QUERY->C6_PRCVEN2 * QUERY->D2_QUANT),0))})
					ELSE
						AADD(_aCFOP_1,{QUERY->D2_CF,;
						QUERY->D2_TOTAL,;
						QUERY->D2_VALIPI,;
						QUERY->D2_VALICM,;
						Iif(QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0),;
						Iif(!QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0),;
						(QUERY->D2_TOTAL + QUERY->D2_VALIPI + QUERY->D2_ICMSRET + QUERY->D2_DESPESA + QUERY->D2_VALFRE + QUERY->D2_SEGURO),;
						(QUERY->C6_PRCVEN2 * QUERY->D2_QUANT),;
						((QUERY->D2_TOTAL + QUERY->D2_VALIPI + QUERY->D2_ICMSRET + QUERY->D2_DESPESA + QUERY->D2_VALFRE + QUERY->D2_SEGURO)+(QUERY->C6_PRCVEN2 * QUERY->D2_QUANT)-QUERY->D2_VALIPI-QUERY->D2_VALICM-Iif(QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0)-Iif(!QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0) - QUERY->D2_DESPESA - QUERY->D2_VALFRE - QUERY->D2_SEGURO),;
						((QUERY->D2_TOTAL + QUERY->D2_VALIPI + QUERY->D2_ICMSRET + QUERY->D2_DESPESA + QUERY->D2_VALFRE + QUERY->D2_SEGURO)+IIf( _cGrupo$"000000/000001",(QUERY->C6_PRCVEN2 * QUERY->D2_QUANT),0))})
					ENDIF

				Else
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][02]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][02] + QUERY->D2_TOTAL
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][03]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][03] + QUERY->D2_VALIPI
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][04]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][04] + QUERY->D2_VALICM
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][05]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][05] + Iif(QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0)
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][06]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][06] + Iif(!QUERY->A1_EST$"SP",QUERY->D2_ICMSRET,0)

				If MV_PAR13 == 1
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][07]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][07] + (QUERY->D2_TOTAL + QUERY->D2_VALIPI + QUERY->D2_ICMSRET + QUERY->D2_DESPESA + QUERY->D2_VALFRE + QUERY->D2_SEGURO )  
				ELSE
					aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][07]		:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][07] + (QUERY->D2_TOTAL + QUERY->D2_VALIPI + QUERY->D2_ICMSRET)
				ENDIF					
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][08]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][08] + (QUERY->C6_PRCVEN2 * QUERY->D2_QUANT)
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][09]	:=	(_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][08] + _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][07]) - _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][03] - _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][04] - _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][05] - _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][06]
					_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][10]	:=	(_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][08] + IIf( _cGrupo$"000000/000001",_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY->D2_CF })][07],0))
				EndIf
			EndIf
			
			dbSelectArea("QUERY")
			dbSkip()
		EndDo
		
		//----> GERAR PLANILHA EXCEL
		If MV_PAR06 == 1
		    // Alert("Gera Excel - QUERY - Analitico")
			GeraExcel(.T.)
		EndIf
		
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		@ nLin, 000			PSAY _dData
		@ nLin, Pcol()+002	PSAY _cNota
		@ nLin, Pcol()+002	PSAY _cPedido
		@ nLin, Pcol()+002	PSAY _cCodCli
		@ nLin, Pcol()+002	PSAY _cCliente
		@ nLin, Pcol()+001	PSAY _nTotFAT			Picture "@E 999,999,999.99"
		@ nLin, Pcol()+001	PSAY _nTotIPI			Picture "@E 999,999,999.99"
		@ nLin, Pcol()+001	PSAY _nTotSSP+_nTotSUB	Picture "@E 999,999,999.99"
		@ nLin, Pcol()+001	PSAY _nTotICM			Picture "@E 999,999,999.99"
		//		@ nLin, Pcol()+001	PSAY _nTotSUB			Picture "@E 999,999,999.99"
		
		@ nLin, Pcol()+001	PSAY _nTotCNF			Picture "@E 999,999,999.99"
		@ nLin, Pcol()+001	PSAY _nTotSNF			Picture "@E 999,999,999.99"
		//		@ nLin, Pcol()+002	PSAY ((_nTotCNF + _nTotSNF) - _nTotIpi - _nTotSSP - _nTotSUB - _nTotICM)	Picture "@E 999,999,999.99"
		@ nLin, Pcol()+001	PSAY (_nTotCNF+_nTotSNF)Picture "@E 999,999,999.99"
		@ nLin, Pcol()+005	PSAY _cCFOP
		@ nLin, Pcol()+002	PSAY ""
		
		dbSelectArea("SE1")
		dbSetOrder(2)
		If dbSeek(xFilial("SE1")+_cChavSE1,.f.)
			
			While Eof() == .f. .And. _cChavSE1 ==  SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM)
				
				AADD(_aVencto,SE1->E1_VENCTO)
				
				dbSelectArea("SE1")
				dbSkip()
			EndDo
		EndIf
		
		For n:= 1 To Len(_aVencto)
			
			@ nLin, Pcol()+001	PSAY DTOC(_aVencto[n])+Iif(n<Len(_aVencto),",","")
			
		Next
		
		_aVencto := {}
		
		nLin += 1
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		_nEmpFAT	+=	_nTotFAT
		_nEmpIPI	+=	_nTotIPI
		_nEmpICM	+=	_nTotICM
		_nEmpSSP	+=	_nTotSSP
		_nEmpSUB	+=	_nTotSUB
		_nEmpCNF	+=	_nTotCNF
		_nEmpSNF	+=	_nTotSNF
		
		_nGloFAT	+=	_nTotFAT
		_nGloIPI	+=	_nTotIPI
		_nGloICM	+=	_nTotICM
		_nGloSSP	+=	_nTotSSP
		_nGloSUB	+=	_nTotSUB
		_nGloCNF	+=	_nTotCNF
		_nGloSNF	+=	_nTotSNF
		
		_nTotFAT	:=	0
		_nTotIPI	:=	0
		_nTotICM	:=	0
		_nTotSSP	:=	0
		_nTotSUB	:=	0
		_nTotCNF	:=	0
		_nTotSNF	:=	0
		
		dbSelectArea("QUERY")
		//dbSkip()
	EndDo
	
	//----> INCLUI DEVOLUCAO
	If mv_par07 == 1
		dbSelectArea("QUERY2")
		SetRegua(RecCount())
		dbGoTop()
		
		While !Eof()
			
			If lAbortPrint
				@nLin,000		 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif
			
			If nLin > 60
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
			
			If !Empty(aReturn[7]) .And. !&(aReturn[7])
				dbSelectArea("QUERY2")
				dbSkip()
				Loop
			EndIf
			
			
			_dData		:=	QUERY2->D1_DTDIGIT
			
			dbSelectArea("QUERY2")
			
			_cChave		:=	QUERY2->(D1_FILIAL+DTOS(D1_DTDIGIT)+D1_DOC+D1_SERIE)
			_cChavSE1	:=	QUERY2->(D1_FORNECE+D1_LOJA+D1_SERIE+D1_DOC)
			_cCodCli	:=	QUERY2->D1_FORNECE
			_cCliente	:=	SUBS(QUERY2->A1_NREDUZ,1,10)
			_cPedido	:=	QUERY2->D1_PEDIDO
			_cNota		:=	QUERY2->D1_DOC
			_cCFOP		:=	QUERY2->D1_CF
			
			dbSelectArea("QUERY2")
			While Eof() == .f. .And. _cChave == QUERY2->(D1_FILIAL+DTOS(D1_DTDIGIT)+D1_DOC+D1_SERIE)
				
				If QUERY2->D1_SERIE$"BOL/REC"
					_nTotFAT2	+=0
					_nTotIPI2	+=((-1)*QUERY2->D1_VALIPI)
					_nTotICM2	+=((-1)*QUERY2->D1_VALICM)
					_nTotSSP2	+=Iif(QUERY2->A1_EST$"SP",((-1)*QUERY2->D1_ICMSRET),0)
					_nTotSUB2	+=Iif(!QUERY2->A1_EST$"SP",((-1)*QUERY2->D1_ICMSRET),0)
					_nTotCNF2	+=0
					_nTotSNF2	+=((-1)*(QUERY2->D1_TOTAL + QUERY2->D1_VALIPI + QUERY2->D1_ICMSRET))
				Else
					_nTotFAT2	+=((-1)*QUERY2->D1_TOTAL)
					_nTotIPI2	+=((-1)*QUERY2->D1_VALIPI)
					_nTotICM2	+=((-1)*QUERY2->D1_VALICM)
					_nTotSSP2	+=Iif(QUERY2->A1_EST$"SP",((-1)*QUERY2->D1_ICMSRET),0)
					_nTotSUB2	+=Iif(!QUERY2->A1_EST$"SP",((-1)*QUERY2->D1_ICMSRET),0)
					_nTotCNF2	+=((-1)*(QUERY2->D1_TOTAL + QUERY2->D1_VALIPI + QUERY2->D1_ICMSRET + QUERY2->D1_DESPESA + QUERY2->D1_VALFRE + QUERY2->D1_SEGURO))
					_nTotSNF2	+=0	//(QUERY2->C6_PRCVEN2 * QUERY2->D1_QUANT)
				EndIf
				
				If QUERY2->D1_SERIE$"BOL/REC"
					If aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF }) == 0
						AADD(_aCFOP_1,{QUERY2->D1_CF,;
						0,;
						((-1)*QUERY2->D1_VALIPI),;
						((-1)*QUERY2->D1_VALICM),;
						Iif(QUERY2->A1_EST$"SP",((-1)*QUERY2->D1_ICMSRET),0),;
						Iif(!QUERY2->A1_EST$"SP",((-1)*QUERY2->D1_ICMSRET),0),;
						0,;
						((-1)*(QUERY2->D1_TOTAL + QUERY2->D1_VALIPI + QUERY2->D1_ICMSRET + QUERY2->D1_DESPESA + QUERY2->D1_VALFRE + QUERY2->D1_SEGURO)),;
						((-1)*(0+(QUERY2->D1_TOTAL + QUERY2->D1_VALIPI + QUERY2->D1_ICMSRET + QUERY2->D1_DESPESA + QUERY2->D1_VALFRE + QUERY2->D1_SEGURO)-QUERY2->D1_VALIPI-QUERY2->D1_VALICM-Iif(QUERY2->A1_EST$"SP",QUERY2->D1_ICMSRET,0)-Iif(!QUERY2->A1_EST$"SP",QUERY2->D1_ICMSRET,0) - QUERY2->D1_DESPESA - QUERY2->D1_VALFRE - QUERY2->D1_SEGURO)),;
						((-1)*(0+(QUERY2->D1_TOTAL + QUERY2->D1_VALIPI + QUERY2->D1_ICMSRET + QUERY2->D1_DESPESA + QUERY2->D1_VALFRE + QUERY2->D1_SEGURO)))})
					Else
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][02]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][02] + 0
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][03]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][03] + ((-1)*QUERY2->D1_VALIPI)
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][04]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][04] + ((-1)*QUERY2->D1_VALICM)
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][05]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][05] + Iif(QUERY2->A1_EST$"SP",((-1)*QUERY2->D1_ICMSRET),0)
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][06]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][06] + Iif(!QUERY2->A1_EST$"SP",((-1)*QUERY2->D1_ICMSRET),0)
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][07]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][07] + 0
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][08]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][08] + ((-1)*(QUERY2->D1_TOTAL + QUERY2->D1_VALIPI + QUERY2->D1_ICMSRET))
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][09]	:=	(_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][08] + _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][07]) - _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][03] - _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][04] - _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][05] - _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][06]
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][10]	:=	(_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][08] + _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][07])
					EndIf
				Else
					If aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF }) == 0
						AADD(_aCFOP_1,{QUERY2->D1_CF,;
						((-1)*QUERY2->D1_TOTAL),;
						((-1)*QUERY2->D1_VALIPI),;
						((-1)*QUERY2->D1_VALICM),;
						Iif(QUERY2->A1_EST$"SP",((-1)*QUERY2->D1_ICMSRET),0),;
						Iif(!QUERY2->A1_EST$"SP",((-1)*QUERY2->D1_ICMSRET),0),;
						((-1)*(QUERY2->D1_TOTAL + QUERY2->D1_VALIPI + QUERY2->D1_ICMSRET + QUERY2->D1_DESPESA + QUERY2->D1_VALFRE + QUERY2->D1_SEGURO)),;
						((-1)*(0)),;
						((-1)*((QUERY2->D1_TOTAL + QUERY2->D1_VALIPI + QUERY2->D1_ICMSRET + QUERY2->D1_DESPESA + QUERY2->D1_VALFRE + QUERY2->D1_SEGURO)+(0)-QUERY2->D1_VALIPI-QUERY2->D1_VALICM-Iif(QUERY2->A1_EST$"SP",QUERY2->D1_ICMSRET,0)-Iif(!QUERY2->A1_EST$"SP",QUERY2->D1_ICMSRET,0) - QUERY2->D1_DESPESA - QUERY2->D1_VALFRE - QUERY2->D1_SEGURO)),;
						((-1)*((QUERY2->D1_TOTAL + QUERY2->D1_VALIPI + QUERY2->D1_ICMSRET + QUERY2->D1_DESPESA + QUERY2->D1_VALFRE + QUERY2->D1_SEGURO)+IIf( _cGrupo$"000000/000001",(0),0)))})
					Else
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][02]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][02] + ((-1)*QUERY2->D1_TOTAL)
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][03]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][03] + ((-1)*QUERY2->D1_VALIPI)
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][04]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][04] + ((-1)*QUERY2->D1_VALICM)
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][05]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][05] + Iif(QUERY2->A1_EST$"SP",((-1)*QUERY2->D1_ICMSRET),0)
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][06]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][06] + Iif(!QUERY2->A1_EST$"SP",((-1)*QUERY2->D1_ICMSRET),0)
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][07]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][07] + ((-1)*(QUERY2->D1_TOTAL + QUERY2->D1_VALIPI + QUERY2->D1_ICMSRET  ))
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][08]	:=	_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][08] + (0)
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][09]	:=	(_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][08] + _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][07]) - _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][03] - _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][04] - _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][05] - _aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][06]
						_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][10]	 :=	(_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][08] + QUERY2->D1_VALFRE + QUERY2->D1_SEGURO + QUERY2->D1_DESPESA + IIf( _cGrupo$"000000/000001",_aCFOP_1 [aScan(_aCFOP_1,{|x| x[1]==QUERY2->D1_CF })][07],0)) 
					EndIf
				EndIf
				
				dbSelectArea("QUERY2")
				dbSkip()
			EndDo
			
			//----> GERAR PLANILHA EXCEL
			If MV_PAR06 == 1
			    // Alert("Gera Excel - QUERY2 - Analitico")
				GeraExcel(.F.)
			EndIf
			
			If nLin > 60
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
			
			@ nLin, 000			PSAY _dData
			@ nLin, Pcol()+002	PSAY _cNota
			@ nLin, Pcol()+002	PSAY _cPedido
			@ nLin, Pcol()+002	PSAY _cCodCli
			@ nLin, Pcol()+002	PSAY _cCliente
			@ nLin, Pcol()+001	PSAY _nTotFAT2				Picture "@E 999,999,999.99"
			@ nLin, Pcol()+001	PSAY _nTotIPI2				Picture "@E 999,999,999.99"
			@ nLin, Pcol()+001	PSAY _nTotSSP2+_nTotSUB2	Picture "@E 999,999,999.99"
			@ nLin, Pcol()+001	PSAY _nTotICM2				Picture "@E 999,999,999.99"
			//		@ nLin, Pcol()+001	PSAY _nTotSUB			Picture "@E 999,999,999.99"
			
			@ nLin, Pcol()+001	PSAY _nTotCNF2			Picture "@E 999,999,999.99"
			@ nLin, Pcol()+001	PSAY _nTotSNF2			Picture "@E 999,999,999.99"
			//		@ nLin, Pcol()+002	PSAY ((_nTotCNF + _nTotSNF) - _nTotIpi - _nTotSSP - _nTotSUB - _nTotICM)	Picture "@E 999,999,999.99"
			@ nLin, Pcol()+001	PSAY (_nTotCNF2+_nTotSNF2)Picture "@E 999,999,999.99"
			@ nLin, Pcol()+005	PSAY _cCFOP
			@ nLin, Pcol()+002	PSAY ""
			
			dbSelectArea("SE1")
			dbSetOrder(2)
			If dbSeek(xFilial("SE1")+_cChavSE1,.f.)
				
				While Eof() == .f. .And. _cChavSE1 ==  SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM)
					
					AADD(_aVencto,SE1->E1_VENCTO)
					
					dbSelectArea("SE1")
					dbSkip()
				EndDo
			EndIf
			
			For n:= 1 To Len(_aVencto)
				
				@ nLin, Pcol()+001	PSAY DTOC(_aVencto[n])+Iif(n<Len(_aVencto),",","")
				
			Next
			
			_aVencto := {}
			
			nLin += 1
			If nLin > 60
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif
			
			_nEmpFAT2	+=	_nTotFAT2
			_nEmpIPI2	+=	_nTotIPI2
			_nEmpICM2	+=	_nTotICM2
			_nEmpSSP2	+=	_nTotSSP2
			_nEmpSUB2	+=	_nTotSUB2
			_nEmpCNF2	+=	_nTotCNF2
			_nEmpSNF2	+=	_nTotSNF2
			
			_nGloFAT2	+=	_nTotFAT2
			_nGloIPI2	+=	_nTotIPI2
			_nGloICM2	+=	_nTotICM2
			_nGloSSP2	+=	_nTotSSP2
			_nGloSUB2	+=	_nTotSUB2
			_nGloCNF2	+=	_nTotCNF2
			_nGloSNF2	+=	_nTotSNF2
			
			_nTotFAT2	:=	0
			_nTotIPI2	:=	0
			_nTotICM2	:=	0
			_nTotSSP2	:=	0
			_nTotSUB2	:=	0
			_nTotCNF2	:=	0
			_nTotSNF2	:=	0
			
			dbSelectArea("QUERY2")
			//dbSkip()
		EndDo
		
		
	EndIf
	If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	nLin += 2
	If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	@ nLin, 000			PSAY "TOTAL -->"
	@ nLin, Pcol()+039	PSAY _nGloFat+_nGloFAT2				Picture "@E 999,999,999.99"
	@ nLin, Pcol()+001	PSAY _nGloIPI+_nGloIPI2				Picture "@E 999,999,999.99"
	@ nLin, Pcol()+001	PSAY _nGloSSP+_nGloSSP2+_nGloSUB+_nGloSUB2		Picture "@E 999,999,999.99"
	//	@ nLin, Pcol()+001	PSAY _nGloSUB				Picture "@E 999,999,999.99"
	@ nLin, Pcol()+001	PSAY _nGloICM+_nGloICM2				Picture "@E 999,999,999.99"
	@ nLin, Pcol()+001	PSAY _nGloCNF+_nGloCNF2				Picture "@E 999,999,999.99"
	@ nLin, Pcol()+001	PSAY _nGloSNF+_nGloSNF2				Picture "@E 999,999,999.99"
	
	//  @ nLin, Pcol()+001	PSAY ((_nGloCNF + _nGloSNF) - _nGloIpi - _nGloSSP - _nGloSUB - _nGloICM)	Picture "@E 999,999,999.99"
	@ nLin, Pcol()+001	PSAY (_nGloCNF+_nGloCNF2+_nGloSNF+_nGloSNF2)	Picture "@E 999,999,999.99"
	
	dbSelectArea("QUERY")
	dbCloseArea("QUERY")
	
	dbSelectArea("QUERY2")
	dbCloseArea("QUERY2")
	
	nLin += 1
	
	@ nLin, 000			PSAY __PrtThinLine()
	
	nLin += 1
	If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	@ nLin, 000			PSAY PADC("R E S U M O    P O R    C F O P",220)
	nLin += 2
	If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	_aCFOP_1 := aSort( _aCFOP_1,,,{|x,y| x[1] < y[1]})
	
	For i := 1 to Len(_aCFOP_1)
		
		@ nLin, 000			PSAY _aCFOP_1[i,01]
		@ nLin, Pcol()+043	PSAY _aCFOP_1[i,02]													Picture "@E 999,999,999.99"
		@ nLin, Pcol()+001	PSAY _aCFOP_1[i,03]                									Picture "@E 999,999,999.99"
		@ nLin, Pcol()+001	PSAY _aCFOP_1[i,05]+_aCFOP_1[i,06]									Picture "@E 999,999,999.99"
		@ nLin, Pcol()+001	PSAY _aCFOP_1[i,04]													Picture "@E 999,999,999.99"
		//		@ nLin, Pcol()+001	PSAY _aCFOP_1[i,06]													Picture "@E 999,999,999.99"
		
		@ nLin, Pcol()+001	PSAY _aCFOP_1[i,07]													Picture "@E 999,999,999.99"
		@ nLin, Pcol()+001	PSAY _aCFOP_1[i,08]													Picture "@E 999,999,999.99"
		//		@ nLin, Pcol()+001	PSAY _aCFOP_1[i,09]													Picture "@E 999,999,999.99"
		@ nLin, Pcol()+001	PSAY _aCFOP_1[i,10]													Picture "@E 999,999,999.99"
		
		nLin += 1
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
	Next
	
	nLin += 1
	
	@ nLin, 000			PSAY __PrtThinLine()
	
	nLin += 1
	If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
EndIf


If nLin > 60
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
Endif

nLin += 2
If nLin > 60
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
Endif

@ nLin, 000			PSAY "TOTAL -->"
If mv_par05 == 1
	@ nLin, Pcol()+001	PSAY _nGloFAT+_nGloFat2				Picture "@E 999,999,999.99"
Else
	@ nLin, Pcol()+039	PSAY _nGloFAT+_nGloFat2				Picture "@E 999,999,999.99"
EndIf
@ nLin, Pcol()+001	PSAY _nGloIPI+_nGloIPI2				Picture "@E 999,999,999.99"
@ nLin, Pcol()+001	PSAY _nGloSSP+_nGloSUB+_nGloSSP2+_nGloSUB2		Picture "@E 999,999,999.99"
//	@ nLin, Pcol()+001	PSAY _nGloSUB				Picture "@E 999,999,999.99"
@ nLin, Pcol()+001	PSAY _nGloICM+_nGloICM2				Picture "@E 999,999,999.99"
@ nLin, Pcol()+001	PSAY _nGloCNF+_nGloCNF2				Picture "@E 999,999,999.99"
@ nLin, Pcol()+001	PSAY _nGLoSNF+_nGloSNF2				Picture "@E 999,999,999.99"

//  @ nLin, Pcol()+001	PSAY ((_nGloCNF + _nGloSNF) - _nGloIpi - _nGloSSP - _nGloSUB - _nGloICM)	Picture "@E 999,999,999.99"
@ nLin, Pcol()+001	PSAY (_nGloCNF+_nGloCNF2+_nGloSNF+_nGloSNF2)	Picture "@E 999,999,999.99"

nLin += 1

@ nLin, 000			PSAY __PrtThinLine()

nLin += 1
If nLin > 60
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
Endif

//----> GERA PLANILHA EXCEL
If MV_PAR06 == 1

//	_cArquivo := "RFATR20.DBF"         DESABILITADO EM 04/12/2019 POR INCOMPATIBILIDADE - LUIZ M. SUGUIURA 
//	dbSelectArea("XLS")
//	Copy To &(_cArquivo) VIA "DBFCDXADS"
//	__COPYFILE (_cArquivo,"C:\RELAXLS\RFATR20.XLS")
//	MSGAlert("Planilha gerada: C:\RELAXLS\RFATR20.XLS")
//	dbCloseArea("XLS")

   GravaExcel()                        // Nova função para gravar e abrir o arquivo temporário em Excel (XML) - 04/12/2019 - Luiz M. Suguiura
   dbCloseArea("XLS")
   
EndIf


SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

Static function BuscaDev()

Local _cQuery2 := ""

_cQuery2	+=	"SELECT DISTINCT    SD1010.D1_FILIAL, SD1010.D1_ITEM, SD1010.D1_DTDIGIT, SD1010.D1_DOC, SD1010.D1_SERIE, SD1010.D1_FORNECE, SD1010.D1_LOJA, SA1010.A1_NOME, SA1010.A1_NREDUZ, SA1010.A1_EST, SD1010.D1_TOTAL, SD1010.D1_PEDIDO, "
_cQuery2	+=	"SD1010.D1_VALIPI, SD1010.D1_VALICM, SD1010.D1_ICMSRET, SD1010.D1_CF, SD1010.D1_TIPO, SD1010.D1_TOTAL, SD1010.D1_SEGURO, SD1010.D1_VALFRE, SD1010.D1_DESPESA, SD1010.D1_QUANT, SD1010.D1_VUNIT "
_cQuery2	+=	"FROM         SD1010 INNER JOIN "
_cQuery2	+=	"SA1010 ON SD1010.D1_FORNECE = SA1010.A1_COD AND SD1010.D1_LOJA = SA1010.A1_LOJA "
_cQuery2	+=	"WHERE     SD1010.D1_TIPO IN ('D', 'B') AND SD1010.D1_CF IN ('1201', '1202', '2201', '2202', '1411', '2411')
_cQuery2	+=	"AND SD1010.D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND SD1010.D_E_L_E_T_ = '' AND (SA1010.D_E_L_E_T_ = '') AND "
_cQuery2	+=	"                      SD1010.D1_SERIE   BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND "
_cQuery2	+=	"                      SD1010.D1_FORNECE   BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR10+"' AND "
_cQuery2	+=	"                      SD1010.D1_LOJA      BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR11+"' "
_cQuery2	+=	"ORDER BY  SD1010.D1_FILIAL,  SD1010.D1_DTDIGIT,   SD1010.D1_SERIE,  SD1010.D1_DOC,   SA1010.A1_NOME, SD1010.D1_CF "

//_cQuery2	:=	ChangeQuery(_cQuery2)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),"QUERY2",.T.,.T.)

TcSetField("QUERY2","D1_DTDIGIT","D",TamSX3("D1_DTDIGIT")[1],TamSX3("D1_DTDIGIT")[2])
TcSetField("QUERY2","D1_TOTAL"  ,"N",TamSX3("D1_TOTAL"  )[1],TamSX3("D1_TOTAL"  )[2])
TcSetField("QUERY2","D1_VALIPI" ,"N",TamSX3("D1_VALIPI" )[1],TamSX3("D1_VALIPI" )[2])
TcSetField("QUERY2","D1_VALFRE" ,"N",TamSX3("D1_VALFRE" )[1],TamSX3("D1_VALFRE" )[2])
TcSetField("QUERY2","D1_VALICM" ,"N",TamSX3("D1_VALICM" )[1],TamSX3("D1_VALICM" )[2])
TcSetField("QUERY2","D1_ICMSRET","N",TamSX3("D1_ICMSRET")[1],TamSX3("D1_ICMSRET")[2])
TcSetField("QUERY2","D1_SEGURO" ,"N",TamSX3("D1_SEGURO" )[1],TamSX3("D1_SEGURO" )[2])
TcSetField("QUERY2","D1_DESPESA","N",TamSX3("D1_DESPESA")[1],TamSX3("D1_DESPESA")[2])
//TcSetField("QUERY2","C6_PRCVEN2","N",TamSX3("C6_PRCVEN2")[1],TamSX3("C6_PRCVEN2")[2])




Return

Static Function BuscaFat()

Local _cQuery := ""

_cQuery	+=	"SELECT DISTINCT "
_cQuery	+=	"                      SD2010.D2_FILIAL, SD2010.D2_ITEM, SD2010.D2_COD, SD2010.D2_TOTAL, SD2010.D2_VALIPI, SD2010.D2_TES, SD2010.D2_CF, "
_cQuery	+=	"                      SD2010.D2_CLIENTE, SD2010.D2_LOJA, SA1010.A1_NOME, SD2010.D2_DOC, SD2010.D2_SERIE, SD2010.D2_EMISSAO, "
_cQuery	+=	"                      SD2010.D2_ICMSRET, SD2010.D2_SEGURO, SD2010.D2_VALFRE, SD2010.D2_DESPESA, SD2010.D_E_L_E_T_ AS D2_DEL, "
_cQuery	+=	"                      SA1010.D_E_L_E_T_ AS A1_DEL, SF4010.F4_DUPLIC, SF4010.D_E_L_E_T_ AS F4_DEL, SD2010.D2_QUANT, SA1010.A1_NREDUZ, "
_cQuery	+=	"                      SD2010.D2_PEDIDO, SA1010.A1_EST, SD2010.D2_VALICM, SC6010.C6_PRCVEN, SC6010.C6_PRCVEN2, SC6010.D_E_L_E_T_ AS C6_DEL "
_cQuery	+=	"FROM         SD2010 INNER JOIN "
_cQuery	+=	"                      SA1010 ON SD2010.D2_CLIENTE = SA1010.A1_COD AND SD2010.D2_LOJA = SA1010.A1_LOJA INNER JOIN "
_cQuery	+=	"                      SF4010 ON SD2010.D2_TES = SF4010.F4_CODIGO INNER JOIN "
//_cQuery	+=	"                      SF4010 ON SD2010.D2_TES = SF4010.F4_CODIGO AND SD2010.D2_FILIAL = SF4010.F4_FILIAL INNER JOIN "
_cQuery	+=	"                      SC6010 ON SD2010.D2_FILIAL = SC6010.C6_FILIAL AND SD2010.D2_COD = SC6010.C6_PRODUTO AND "
_cQuery	+=	"                      SD2010.D2_PEDIDO = SC6010.C6_NUM AND SD2010.D2_ITEMPV = SC6010.C6_ITEM "
If MV_PAR14 == 1
	_cQuery	+=	"WHERE     (SD2010.D_E_L_E_T_ = '') AND (SA1010.D_E_L_E_T_ = '') AND (SF4010.D_E_L_E_T_ = '') AND (SC6010.D_E_L_E_T_ = '') AND "
Else
	_cQuery	+=	"WHERE     (SD2010.D_E_L_E_T_ = '') AND (SA1010.D_E_L_E_T_ = '') AND (SF4010.F4_DUPLIC = 'S' OR SF4010.F4_CODIGO = '995') AND (SF4010.D_E_L_E_T_ = '') AND (SC6010.D_E_L_E_T_ = '') AND "
EndIf	

//_cQuery	+=	"WHERE     (SD2010.D_E_L_E_T_ = '') AND (SA1010.D_E_L_E_T_ = '') AND (SF4010.D_E_L_E_T_ = '') AND (SC6010.D_E_L_E_T_ = '') AND "
_cQuery	+=	"                      (SD2010.D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"') AND "
_cQuery	+=	"                      (SD2010.D2_SERIE   BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"') AND"
_cQuery	+=	"                      (SD2010.D2_CLIENTE   BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR10+"') AND "
_cQuery	+=	"                      (SD2010.D2_LOJA      BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR11+"') "

If MV_PAR12 == 2
	_cQuery	+=	"                      AND (SD2010.D2_LOCAL NOT IN ('05','06')) "
ElseIf MV_PAR12 == 3
	_cQuery	+=	"                      AND (SD2010.D2_LOCAL IN ('05',''06')) "
EndIf


_cQuery	+=	"ORDER BY  SD2010.D2_FILIAL,  SD2010.D2_EMISSAO,   SD2010.D2_SERIE,  SD2010.D2_DOC,   SA1010.A1_NOME, SD2010.D2_CF "

//_cQuery	:=	ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QUERY",.T.,.T.)


MemoWrite( "c:\temp\testSave.txt", _cQuery )

TcSetField("QUERY","D2_EMISSAO","D",TamSX3("D2_EMISSAO")[1],TamSX3("D2_EMISSAO")[2])
TcSetField("QUERY","D2_TOTAL"  ,"N",TamSX3("D2_TOTAL"  )[1],TamSX3("D2_TOTAL"  )[2])
TcSetField("QUERY","D2_VALIPI" ,"N",TamSX3("D2_VALIPI" )[1],TamSX3("D2_VALIPI" )[2])
TcSetField("QUERY","D2_VALFRE" ,"N",TamSX3("D2_VALFRE" )[1],TamSX3("D2_VALFRE" )[2])
TcSetField("QUERY","D2_VALICM" ,"N",TamSX3("D2_VALICM" )[1],TamSX3("D2_VALICM" )[2])
TcSetField("QUERY","D2_ICMSRET","N",TamSX3("D2_ICMSRET")[1],TamSX3("D2_ICMSRET")[2])
TcSetField("QUERY","D2_SEGURO" ,"N",TamSX3("D2_SEGURO" )[1],TamSX3("D2_SEGURO" )[2])
TcSetField("QUERY","D2_DESPESA","N",TamSX3("D2_DESPESA")[1],TamSX3("D2_DESPESA")[2])
TcSetField("QUERY","C6_PRCVEN2","N",TamSX3("C6_PRCVEN2")[1],TamSX3("C6_PRCVEN2")[2])

Return


Static Function GeraExcel(lVen)

_aDados := {}

If mv_par05 == 1
	
	aAdd(_aDados,{'EMISSAO'    	,'D',08,0})
	aAdd(_aDados,{'VLPROD'     	,'N',12,2})
	aAdd(_aDados,{'VLIPI'      	,'N',12,2})
	aAdd(_aDados,{'VLSTSP'     	,'N',12,2})
	aAdd(_aDados,{'VLSTOU'     	,'N',12,2})
	aAdd(_aDados,{'VLICMS'     	,'N',12,2})
	aAdd(_aDados,{'VLCNF'      	,'N',12,2})
	aAdd(_aDados,{'VLSNF'      	,'N',12,2})
	aAdd(_aDados,{'TOTLIQ'     	,'N',12,2})
	aAdd(_aDados,{'TOTBRU'     	,'N',12,2})
	//	aAdd(_aDados,{'ORIGEM'     	,'C',08,0})
Else
	aAdd(_aDados,{'EMISSAO'    	,'D',08,0})
	aAdd(_aDados,{'NOTA'	   	,'C',09,0})
	aAdd(_aDados,{'PEDIDO'     	,'C',06,0})
	aAdd(_aDados,{'CODCLI'	   	,'C',06,0})
	aAdd(_aDados,{'CLIENTE'    	,'C',30,0})
	aAdd(_aDados,{'VLPROD'     	,'N',12,2})
	aAdd(_aDados,{'VLIPI'      	,'N',12,2})
	aAdd(_aDados,{'VLSTSP'     	,'N',12,2})
	aAdd(_aDados,{'VLSTOU'     	,'N',12,2})
	aAdd(_aDados,{'VLICMS'     	,'N',12,2})
	aAdd(_aDados,{'VLCNF'      	,'N',12,2})
	aAdd(_aDados,{'VLSNF'      	,'N',12,2})
	aAdd(_aDados,{'TOTLIQ'     	,'N',12,2})
	aAdd(_aDados,{'TOTBRU'     	,'N',12,2})
	aAdd(_aDados,{'CFOP'       	,'C',04,0})
	//	aAdd(_aDados,{'ORIGEM'     	,'C',08,0})
EndIf

_cTemp 		:= CriaTrab(_aDados,.T.)
_cIndTrb  	:= CriaTrab(Nil,.F.)

IF 	SELECT("XLS")>0
	dbSelectArea("XLS")
Else
	dbUseArea(.T.,,_cTemp,"XLS",.F.,.F.)
	IndRegua("XLS",_cIndTrb,"EMISSAO",,,"")
	dbSelectArea("XLS")
EndIf

If mv_par05 == 1
	RecLock("XLS",.T.)
	If mv_par07 == 1 .and. !lVen
		XLS->EMISSAO	:=	_dData
		XLS->VLPROD		:=	_nTotFAT2
		XLS->VLIPI 		:=	_nTotIPI2
		XLS->VLSTSP		:=	_nTotSSP2
		XLS->VLSTOU 	:=	_nTotSUB2
		XLS->VLICMS 	:=	_nTotICM2
		XLS->VLCNF		:=	_nTotCNF2
		XLS->VLSNF		:=	_nTotSNF2
		XLS->TOTLIQ		:=	((_nTotCNF2 + _nTotSNF2) - _nTotIpi2 - _nTotSSP2 - _nTotSUB2 - _nTotICM2)
		XLS->TOTBRU		:=	(_nTotCNF2 + _nTotSNF2)
	Else
		XLS->EMISSAO	:=	_dData
		XLS->VLPROD		:=	_nTotFAT
		XLS->VLIPI 		:=	_nTotIPI
		XLS->VLSTSP		:=	_nTotSSP
		XLS->VLSTOU 	:=	_nTotSUB
		XLS->VLICMS 	:=	_nTotICM
		XLS->VLCNF		:=	_nTotCNF
		XLS->VLSNF		:=	_nTotSNF
		XLS->TOTLIQ		:=	((_nTotCNF + _nTotSNF) - _nTotIpi - _nTotSSP - _nTotSUB - _nTotICM)
		XLS->TOTBRU		:=	(_nTotCNF + _nTotSNF)
	EndIf
	XLS->(MsUnlock())
Else
	RecLock("XLS",.T.)
	If mv_par07 == 1 .and. !lVen
		XLS->EMISSAO	:=	_dData
		XLS->NOTA    	:=	_cNota
		XLS->PEDIDO		:=	_cPedido
		XLS->CODCLI		:=	_cCodCli
		XLS->CLIENTE	:=	_cCliente
		XLS->VLPROD		:=	_nTotFAT2
		XLS->VLIPI 		:=	_nTotIPI2
		XLS->VLSTSP		:=	_nTotSSP2
		XLS->VLSTOU 	:=	_nTotSUB2
		XLS->VLICMS 	:=	_nTotICM2
		XLS->VLCNF		:=	_nTotCNF2
		XLS->VLSNF		:=	_nTotSNF2
		XLS->TOTLIQ		:=	((_nTotCNF2 + _nTotSNF2) - _nTotIpi2 - _nTotSSP2 - _nTotSUB2 - _nTotICM2)
		XLS->TOTBRU		:=	(_nTotCNF2 + _nTotSNF2)
		XLS->CFOP 		:=	_cCFOP
	Else
		XLS->EMISSAO	:=	_dData
		XLS->NOTA    	:=	_cNota
		XLS->PEDIDO		:=	_cPedido
		XLS->CODCLI		:=	_cCodCli
		XLS->CLIENTE	:=	_cCliente
		XLS->VLPROD		:=	_nTotFAT
		XLS->VLIPI 		:=	_nTotIPI
		XLS->VLSTSP		:=	_nTotSSP
		XLS->VLSTOU 	:=	_nTotSUB
		XLS->VLICMS 	:=	_nTotICM
		XLS->VLCNF		:=	_nTotCNF
		XLS->VLSNF		:=	_nTotSNF
		XLS->TOTLIQ		:=	((_nTotCNF + _nTotSNF) - _nTotIpi - _nTotSSP - _nTotSUB - _nTotICM)
		XLS->TOTBRU		:=	(_nTotCNF + _nTotSNF)
		XLS->CFOP 		:=	_cCFOP
	EndIf
	XLS->(MsUnlock())
EndIf

Return()


// Função para gravar o arquivo temporário em XML e sua abertura em seguida - 04/12/2019 - Luiz
Static Function GravaExcel()

Local oFWMsExcel
Local oExcel
Local cArquivo := GetTempPath()+"RFATR20.XML"

// Criando o objeto que ira gerar o conteudo do Excel
oFWMsExcel := FWMSExcel():New()
     
// Aba 01 - Relatorio
oFWMsExcel:AddworkSheet("Relatorio")

// Início do bloco de criação do objeto Excel
// Criando a Tabela
// FWMsExcelEx():AddColumn(< cWorkSheet >, < cTable >, < cColumn >, < nAlign >, < nFormat >, < lTotal >)
// Alinhamento: 1=esquerda, 2=centro, 3=direita
// Formato: 1=geral, 2=numero, 3=monetario, 4=data

If mv_par05 == 1
   oFWMsExcel:AddTable("Relatorio","Sintetico")
   oFWMsExcel:AddColumn("Relatorio","Sintetico","Emissao"    ,2,4)  
   oFWMsExcel:AddColumn("Relatorio","Sintetico","Vlr Produto",3,2)
   oFWMsExcel:AddColumn("Relatorio","Sintetico","Vlr IPI"    ,3,2)
   oFWMsExcel:AddColumn("Relatorio","Sintetico","Vlr ST SP"  ,3,2)
   oFWMsExcel:AddColumn("Relatorio","Sintetico","Vlr ST Out" ,3,2)
   oFWMsExcel:AddColumn("Relatorio","Sintetico","Vlr ICMS"   ,3,2)
   oFWMsExcel:AddColumn("Relatorio","Sintetico","Vlr CNF"    ,3,2)
   oFWMsExcel:AddColumn("Relatorio","Sintetico","Vlr SNF"    ,3,2)
   oFWMsExcel:AddColumn("Relatorio","Sintetico","Tot Liq"    ,3,2)
   oFWMsExcel:AddColumn("Relatorio","Sintetico","Tot Bru"    ,3,2)
Else
   oFWMsExcel:AddTable("Relatorio","Analitico")
   oFWMsExcel:AddColumn("Relatorio","Analitico","Emissao"    ,2,4)  
   oFWMsExcel:AddColumn("Relatorio","Analitico","Nota"       ,2,1)   
   oFWMsExcel:AddColumn("Relatorio","Analitico","Pedido"     ,2,1)
   oFWMsExcel:AddColumn("Relatorio","Analitico","Cod Cliente",2,1)
   oFWMsExcel:AddColumn("Relatorio","Analitico","Cliente"    ,1,1)
   oFWMsExcel:AddColumn("Relatorio","Analitico","Vlr Produto",3,2)
   oFWMsExcel:AddColumn("Relatorio","Analitico","Vlr IPI"    ,3,2)
   oFWMsExcel:AddColumn("Relatorio","Analitico","Vlr ST SP"  ,3,2)
   oFWMsExcel:AddColumn("Relatorio","Analitico","Vlr ST Out" ,3,2)
   oFWMsExcel:AddColumn("Relatorio","Analitico","Vlr ICMS"   ,3,2)
   oFWMsExcel:AddColumn("Relatorio","Analitico","Vlr CNF"    ,3,2)
   oFWMsExcel:AddColumn("Relatorio","Analitico","Vlr SNF"    ,3,2)
   oFWMsExcel:AddColumn("Relatorio","Analitico","Tot Liq"    ,3,2)
   oFWMsExcel:AddColumn("Relatorio","Analitico","Tot Bru"    ,3,2)
   oFWMsExcel:AddColumn("Relatorio","Analitico","CFOP"       ,2,1)
Endif

// Final do bloco de criação do objeto Excel


IF SELECT("XLS")>0
   dbSelectArea("XLS")
Else
   Alert("Atenção: Erro área XLS. Informe ao suporte o erro apresentado")
   Return()
EndIf

XLS->(dbGoTop())

nCont:= 0

While !XLS->(EOF())

   nCont += 1

   // Incluindo a linha da tabela conforme Sintético ou Analítico 

   If mv_par05 == 1
      oFWMsExcel:AddRow("Relatorio","Sintetico",{ XLS->EMISSAO,;
                                                  XLS->VLPROD,;
                                                  XLS->VLIPI,;
                                                  XLS->VLSTSP,;
                                                  XLS->VLSTOU,;  
                                                  XLS->VLICMS,;  
                                                  XLS->VLCNF,;
                                                  XLS->VLSNF,;  
                                                  XLS->TOTLIQ,;    
                                                  XLS->TOTLIQ})
   Else  
      oFWMsExcel:AddRow("Relatorio","Analitico",{ XLS->EMISSAO,;
                                                  XLS->NOTA,;
                                                  XLS->PEDIDO,;
                                                  XLS->CODCLI,;
                                                  XLS->CLIENTE,;  
                                                  XLS->VLPROD,;  
                                                  XLS->VLIPI,;
                                                  XLS->VLSTSP,;  
                                                  XLS->VLSTOU,;    
                                                  XLS->VLICMS,;
                                                  XLS->VLCNF,;
                                                  XLS->VLSNF,;
                                                  XLS->TOTLIQ,;
                                                  XLS->TOTBRU,;
                                                  XLS->CFOP})
   Endif
  
   XLS->(DbSkip())

Enddo

// Alert("Geradas "+str(nCont)+" Linhas")
// Alert("Arquivo "+cArquivo)
// Finalização da Criação do Excel

// Ativando o arquivo e gerando o xml
oFWMsExcel:Activate()
oFWMsExcel:GetXMLFile(cArquivo)
        
//Abrindo o excel e abrindo o arquivo xml
oExcel := MsExcel():New()            //Abre uma nova conexão com Excel
oExcel:WorkBooks:Open(cArquivo)      //Abre uma planilha
oExcel:SetVisible(.T.)               //Visualiza a planilha

Return()



