#Include "PROTHEUS.Ch"   
#INCLUDE "RWMAKE.CH"  
#INCLUDE "finc040.ch"
#include "finr190.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FINR190  ³ Autor ³ Adrianne Furtado      ³ Data ³ 02.09.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rela‡„o das baixas                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FINR190(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFIN001()

Local oReport
/*
Private STR0001 := "Por Data"
Private STR0002 := "Por Banco"
Private STR0003 := "Por Natureza"
Private STR0004 := "Alfabetica"
Private STR0005 := "Dt.Digitacao"
Private STR0006 := "Este programa irá emitir a relaçäo dos titulos baixados."
Private STR0007 := "Poderá ser emitido por data, banco, natureza ou alfabética"
Private STR0008 := "de cliente ou fornecedor e data da digitaçäo."
Private STR0009 := "Relacao de Baixas"
Private STR0010 := "Zebrado"                          
Private STR0011 := "Relacao dos Titulos Recebidos em "
Private STR0012 := "Prf Numero     Prc TP  Client Nome Cliente       Natureza   Obra       Historico             Dt Baixa  Valor Original   Jur/Multa    Correcao   Descontos     Abatim.    Impostos   Total Baixado   Bco   Dt Dig.  Mot Orig "
Private STR0013 := "Relacao dos Titulos Pagos em "
Private STR0014 := "Prf Numero     Prc TP  Fornec Nome Fornecedor    Natureza   Obra       Historico             Dt Baixa  Valor Original   Jur/Multa    Correcao   Descontos     Abatim.    Impostos   Total Baixado   Bco   Dt Dig.  Mot Orig "
Private STR0015 := " por data de pagamento"
Private STR0016 := " por Banco"
Private STR0017 := " por Natureza"
Private STR0018 := "Selecionando Registros..."
Private STR0019 := " Por Data de Digitacao"
Private STR0020 := " Alfabetica"
Private STR0021 := "CANCELADO PELO OPERADOR"
Private STR0022 := "NORMAL"
Private STR0023 := "DEVOLUCAO"
Private STR0024 := "DACAO"                       
Private STR0025 := "VENDOR"
Private STR0026 := "COMPENSAC"
Private STR0027 := "COMP CART"
Private STR0028 := "Baixados"
Private STR0029 := "Total Geral : "
Private STR0030 := "Administracao"
Private STR0031 := "Mov.Fin."
Private STR0032 := "Nro. Titulo"
Private STR0033 := "LIQUIDAC."
Private STR0034 := "DEBITO CC"
Private STR0035 := " Nro. dos Titulos"
Private STR0036 := " Por Lote"
Private STR0037 := "Compens."
Private STR0038 := "Moviment. Financeiras Manuais "
Private STR0039 := "Cliente              Nome Cliente "
Private STR0040 := "                       Prf Numero     Prc TP     Natureza   Obra       Historico          Dt Baixa     Valor Original   Jur/Multa    Correcao   Descontos     Abatim.    Impostos   Total Baixado   Bco   Dt Dig.  Mot Orig "
Private STR0041 := "Fornecedor           Nome do fornecedor"
Private STR0042 := "FATURADO"
Private STR0043 := "Prefixo De"
Private STR0044 := "Prefixo Ate"
Private STR0045 := "Imprimir Tipos"
Private STR0046 := "Nao Imprimir Tipos"
Private STR0047 := "Imprime Nome"
Private STR0048 := "Por Data de Credito"
Private STR0049 := "Prf"
Private STR0050 := "Numero"
Private STR0051 := "Prc"
Private STR0052 := "TP"
Private STR0053 := "Cli/For"
Private STR0054 := "Nome Cli/For"
Private STR0055 := "Natureza"
Private STR0056 := "Obra"
Private STR0057 := "Historico"
Private STR0058 := "Dt Baixa"
Private STR0059 := "Valor Original"
Private STR0060 := "Jur/Multa"
Private STR0061 := "Correcao"
Private STR0062 := "Descontos"
Private STR0063 := "Abatim."
Private STR0064 := "Impostos"
Private STR0065 := "Total Baixado"
Private STR0066 := "Bco"
Private STR0067 := "Dt Dig."
Private STR0068 := "Mot"
Private STR0069 := "Orig"
Private STR0070 := "FILIAL"
Private STR0071 := "Sub Total"
Private STR0072 := "Baixas"
Private STR0073 := "Separe os tipos a imprimir (pergunta 28) por um ; (ponto e virgula) a cada 3 caracteres"
Private STR0074 := "Separe os tipos que não deseja imprimir (pergunta 29) por um ; (ponto e virgula) a cada 3 caracteres"
Private STR0075 := "Geral"
Private STR0076 := "Bx.Fatura"
Private STR0077 := "Baixa Automatica / Lote"
*/
Private cChaveInterFun := ""

Private cObrRestr := GetMV('MV_XOBRRES')
Private cUsuObra  := GetMV('MV_XUSROBR') 
Private cUsuMast  := GetMV('MV_XUSUMST')
Static lFWCodFil := FindFunction("FWCodFil")

FIN01_R3()
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FIN01_R3 ³ Autor ³ Wagner Xavier         ³ Data ³ 05.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rela‡„o das baixas                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FINR190(void)                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FIN01_R3()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local wnrel
Local aOrd:={OemToAnsi(STR0001),OemToAnsi(STR0002),OemToAnsi(STR0003),OemToAnsi(STR0004),OemToAnsi(STR0032),OemToAnsi(STR0005),OemToAnsi(STR0036),STR0048}  //"Por Data"###"Por Banco"###"Por Natureza"###"Alfabetica"###"Nro. Titulo"###"Dt.Digitacao"###"Por Lote" //"Por Data de Credito" 
//Local aOrd		:= {"Por Data","Por Banco","Por Natureza","Alfabetica","Nro. Titulo","Dt.Digitacao","Por Lote" }
Local cDesc1 	:= "Este programa ir  emitir a rela‡„o dos titulos baixados." 
//Local cDesc1 	:= STR0006  //"Este programa ir  emitir a rela‡„o dos titulos baixados."
Local cDesc2 := STR0007  //"Poder  ser emitido por data, banco, natureza ou alfab‚tica" 
//Local cDesc2 	:= "Poder  ser emitido por data, banco, natureza ou alfab‚tica"
Local cDesc3 := STR0008  //"de cliente ou fornecedor e data da digita‡„o." 
//Local cDesc3 	:= "de cliente ou fornecedor e data da digita‡„o."
Local tamanho	:="G"
Local cString	:= "SE5"

Private titulo:=OemToAnsi(STR0009)  //"Relacao de Baixas" 
//Private titulo 		:= "Relacao de Baixas"
Private cabec1
Private cabec2
Private cNomeArq
Private aReturn := { OemToAnsi(STR0010), 1,OemToAnsi(STR0030), 1, 2, 1, "",1 }  //"Zebrado"###"Administracao" 
//Private aReturn 	:= { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
Private nomeprog	:= "RFIN001"
Private aLinha  	:= { },nLastKey := 0
Private cPerg   	:="FIN190"
Private c_Natureza 	:= ""
Private c_DescNatu 	:= ""
     

lFWCodfil := .F.
ajustasx1()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("FIN190",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                     ³
//³ mv_par01            // da data da baixa                  ³
//³ mv_par02            // at‚ a data da baixa               ³
//³ mv_par03            // do banco                          ³
//³ mv_par04            // at‚ o banco                       ³
//³ mv_par05            // da natureza                       ³
//³ mv_par06            // at‚ a natureza                    ³
//³ mv_par07            // do c¢digo                         ³
//³ mv_par08            // at‚ o c¢digo                      ³
//³ mv_par09            // da data de digita‡„o              ³
//³ mv_par10            // ate a data de digita‡„o           ³
//³ mv_par11            // Tipo de Carteira (R/P)            ³
//³ mv_par12            // Moeda                             ³
//³ mv_par13            // Hist¢rico: Baixa ou Emiss„o       ³
//³ mv_par14            // Imprime Baixas Normais / Todas    ³
//³ mv_par15            // Situacao                          ³
//³ mv_par16            // Cons Mov Fin                      ³
//³ mv_par17            // Cons filiais abaixo               ³
//³ mv_par18            // da filial                         ³
//³ mv_par19            // ate a filial                      ³
//³ mv_par20            // Do Lote                           ³
//³ mv_par21            // Ate o Lote                        ³
//³ mv_par22            // da loja                           ³
//³ mv_par23            // Ate a loja                        ³
//³ mv_par24            // NCC Compensados                   ³
//³ mv_par25            // Outras Moedas                     ³
//³ mv_par26            // do prefixo                        ³
//³ mv_par27            // at‚ o prefixo                     ³
//³ mv_par28            // Imprimir os Tipos                 ³
//³ mv_par29            // Nao Imprimir Tipos			       ³
//³ mv_par30            // Imprime nome (Normal ou reduzido) ³
//³ mv_par31            // da data da vencto. do tit         ³
//³ mv_par32            // at‚ a data de vencto do tit.      ³
//³ mv_par33            // da filial origem                  ³
//³ mv_par34            // ate filial origem                 ³
//³ mv_par35            // Impr.Incl. Adiantamentos ?Sim/Nao ³
//³ mv_par36            // Imprime Titulos em Carteira ?     |
//³ mv_par37            // Imp. mov. cheque aglutinado?Cheque/Baixa/Ambos³
//³ mv_par38            // Cons. Nat. Aglutinadas? Sim/Nao   |
//| mv_par39            // Filtrar Natureza Por?             |
//|                                  - Padrao                |
//|                                  - Nat.Principal         |
//|                                  - Mult.Naturezas        |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a fun‡„o SETPRINT                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "RFIN001"            //Nome Default do relat¢rio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey == 27
	Return(Nil)
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	Return(Nil)
EndIf

cFilterUser := aReturn[7]               

//If AllTrim(MV_PAR40) $ cObrRestr .Or. Empty(MV_PAR40)
//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20160315] por padrao foi incluido o MV_PAR40 e MV_PAR41
If AllTrim(MV_PAR42) $ cObrRestr .Or. Empty(MV_PAR42)
	if !(AllTrim(PswRet()[1][1]) $ cUsuObra)
		MsgInfo('Usuário sem permissão para visualizar este Centro de Custo')
		Return
	EndIf
EndIf
       
RptStatus({|lEnd| Fa190Imp(@lEnd,wnRel,cString)},Titulo)
Return(Nil)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ FA190Imp ³ Autor ³ Wagner Xavier         ³ Data ³ 05.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rela‡„o das baixas                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA190Imp(lEnd,wnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd    - A‡Æo do Codeblock                                ³±±
±±³          ³ wnRel   - T¡tulo do relat¢rio                              ³±±
±±³          ³ cString - Mensagem                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Gen‚rico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FA190Imp(lEnd,wnRel,cString)

Local cExp 			:= ""
Local CbTxt,CbCont
Local nValor:=0,nDesc:=0,nJuros:=0,nMulta:=0,nJurMul:=0,nCM:=0,dData,nVlMovFin:=0
Local nTotValor:=0,nTotDesc:=0,nTotJurMul:=0,nTotCm:=0,nTotOrig:=0,nTotBaixado:=0,nTotMovFin:=0,nTotComp:=0,nTotFat:=0
Local nGerValor:=0,nGerDesc:=0,nGerJurMul:=0,nGerCm:=0,nGerOrig:=0,nGerBaixado:=0,nGerMovFin:=0,nGerComp:=0,nGerFat:=0
Local nFilOrig:=0,nFilJurMul:=0,nFilCM:=0,nFilDesc:=0
Local nFilAbLiq:=0,nFilAbImp:=0,nFilValor:=0,nFilBaixado:=0,nFilMovFin:=0,nFilComp:=0, nFilFat:=0
Local nAbatLiq := 0,nTotAbImp := 0,nTotImp := 0,nTotAbLiq := 0,nGerAbLiq := 0,nGerAbImp := 0
Local cBanco,cNatureza,cAnterior,cCliFor,nCT:=0,dDigit,cLoja
Local lContinua		:=.T.
Local lBxTit		:=.F.
Local tamanho		:="G"
Local aCampos:= {},cNomArq1:="",nVlr,cLinha,lOriginal:=.T.
Local nAbat 		:= 0
Local cHistorico
Local lManual 		:= .f.
Local cTipodoc
Local nRecSe5 		:= 0
Local dDtMovFin
Local cRecPag
Local nRecEmp 		:= SM0->(Recno())
Local cMotBaixa		:= CRIAVAR("E5_MOTBX")
Local cCliFor190	:= ""
Local aTam 			:= IIF(mv_par11 == 1,TamSX3("E1_CLIENTE"),TamSX3("E2_FORNECE"))
Local aColu 		:= {}
Local nDecs	   		:= GetMv("MV_CENT"+(IIF(mv_par12 > 1 , STR(mv_par12,1),"")))
Local nMoedaBco		:= 1
Local cCarteira
#IFDEF TOP
	Local aStru		:= SE5->(DbStruct()), nI
	Local cQuery
#ENDIF
Local cFilTrb
Local lAsTop		:= .F.
Local cFilSe5		:= ".T."
Local cChave, bFirst
Local cFilOrig
Local lAchou		:= .F.
Local lF190Qry		:= ExistBlock("F190QRY")
Local cQueryAdd		:= ""
Local lAjuPar15		:= Len(AllTrim(mv_par15))==Len(mv_par15)
Local lAchouEmp		:= .T.
Local lAchouEst		:= .F.
Local nTamEH		:= TamSx3("EH_NUMERO")[1]
Local nTamEI		:= TamSx3("EI_NUMERO")[1]+TamSx3("EI_REVISAO")[1]+TamSx3("EI_SEQ")[1]
Local cCodUlt		:= SM0->M0_CODIGO
Local cFilUlt		:= IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
Local nRecno
Local nSavOrd
Local aAreaSE5
Local cChaveNSE5	:= ""

Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ;
!Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
!Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
!Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )

Local nTaxa:= 0
Local lUltBaixa := .F.
Local cChaveSE1 := ""
Local cChaveSE5 := ""
Local cSeqSE5 := ""
Local cBancoAnt, cAgAnt, cContaAnt
Local lNaturez := .F.

//Controla o Pis Cofins e Csll na baixa (1-Retem PCC na Baixa ou 2-Retem PCC na Emissão(default))
Local lPccBxCr	 := If (FindFunction("FPccBxCr"),FPccBxCr(),.F.)
Local nPccBxCr   := 0

Private nIndexSE5:= 0
Private	cFilAnt  := ""
Private cFilNome := Space(15)
Private aPlanilha  := {}
Private aCabecalho := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vari veis utilizadas para Impress„o do Cabe‡alho e Rodap‚    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1
nOrdem 	:= aReturn[8]
cSuf	:= LTrim(Str(mv_par12))
cMoeda	:= GetMv("MV_MOEDA"+cSuf)
cCond3	:= ".T."

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Quando selecionada a opcao "Multiplas Naturezas" |
//³ forcar a utilizacao do relatorio atraves da      |
//³ funcao FINR199 (Rel.Multiplas Naturezas)         |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par39 == 3
	mv_par38 := 2
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par11 == 1
	titulo := OemToAnsi(STR0011)  + cMoeda  //"Relacao dos Titulos Recebidos em "
	cabec1 := iif(aTam[1] > 6 , OemToAnsi("Cliente              Nome Cliente "),OemToAnsi("Prf Numero     Prc TP  Client Nome Cliente       Natureza   Obra       Historico             Dt Baixa  Valor Original   Jur/Multa    Correcao   Descontos     Abatim.    Impostos   Total Baixado   Bco   Dt Dig.  Mot Orig "))  //"Cliente-Nome Cliente "###"Prf Numero       P TP Client Nome Cliente       Natureza    Vencto  Historico       Dt Baixa  Valor Original    Tx Permanen         Multa      Correcao     Descontos     Abatimentos    Total Rec. Bco Dt Digit. Mot. Baixa"
	cabec2 := iif(aTam[1] > 6 , OemToAnsi("                       Prf Numero     Prc TP     Natureza   Obra       Historico          Dt Baixa     Valor Original   Jur/Multa    Correcao   Descontos     Abatim.    Impostos   Total Baixado   Bco   Dt Dig.  Mot Orig "),"")  //"                       Prf Numero       P TP     Natureza   Vencto     Historico          Dt Baixa   Valor Original  Tx Permanen        Multa     Correcao    Descontos  Abatimentos     Total Rec. Bco Dt Digit.  Mot.Baixa"
	
	aCabecalho :={ "Prefixo","Numero","Parcela","Tipo","Cliente","Nome Cliente","Natureza","Obra","Historico","Dt Baixa","Valor Original","Jur/Multa","Correcao","Descontos","Abatim.","Impostos","Total Baixado","Bco","Dt Dig.","Mot Orig","Filial Orig" }
Else
	titulo := OemToAnsi(STR0013)  + cMoeda  //"Relacao dos Titulos Pagos em "
	cabec1 := iif(aTam[1] > 6 , OemToAnsi(STR0041),OemToAnsi("Prf Numero     Prc TP  Fornec Nome Fornecedor    Natureza   Obra       Historico             Dt Baixa  Valor Original   Jur/Multa    Correcao   Descontos     Abatim.    Impostos   Total Baixado   Bco   Dt Dig.  Mot Orig "))  //"Prf Numero       P TP Fornec Nome Fornecedor    Natureza    Vencto  Historico       Dt Baixa  Valor Original    Tx Permanen         Multa      Correcao     Descontos     Abatimentos    Total Pago Bco Dt Digit. Mot. Baixa"
	cabec2 := iif(aTam[1] > 6 , OemToAnsi("                       Prf Numero     Prc TP     Natureza   Obra       Historico          Dt Baixa     Valor Original   Jur/Multa    Correcao   Descontos     Abatim.    Impostos   Total Baixado   Bco   Dt Dig.  Mot Orig "),"")  //"                       Prf Numero       P TP     Natureza   Vencto     Historico          Dt Baixa   Valor Original  Tx Permanen        Multa     Correcao    Descontos  Abatimentos     Total Rec. Bco Dt Digit.  Mot.Baixa"
	
	aCabecalho := { "Prefixo","Numero","Parcela","Tipo","Fornecedor","Nome Fornecedor","Natureza","Obra","Historico","Dt Baixa","Valor Original","Jur/Multa","Correcao","Descontos","Abatim.","Impostos","Total Baixado","Bco","Dt Dig.","Mot Orig","Filial Orig" }
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui valores as variaveis ref a filiais                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par17 == 2
	cFilDe := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	cFilAte:= IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
Else
	cFilDe := mv_par18	// Todas as filiais
	cFilAte:= mv_par19
EndIf
// Definicao das condicoes e ordem de impressao, de acordo com a ordem escolhida pelo
// usuario.
DbSelectArea("SE5")
Do Case
	Case nOrdem == 1
		cCondicao := "E5_DATA >= mv_par01 .and. E5_DATA <= mv_par02"
		cCond2 := "E5_DATA"
		cChave := IndexKey(1)
		cChaveInterFun := cChave
		titulo += OemToAnsi(STR0015)  //" por data de pagamento"
		bFirst := {|| MsSeek(xFilial("SE5")+Dtos(mv_par01),.T.)}
	Case nOrdem == 2
		cCondicao := "E5_BANCO >= mv_par03 .and. E5_BANCO <= mv_par04"
		cCond2 := "E5_BANCO"
		cChave := IndexKey(3)
		cChaveInterFun := cChave
		titulo += OemToAnsi(STR0016) // " por Banco"
		bFirst := {||MsSeek(xFilial("SE5")+mv_par03,.T.)}
	Case nOrdem == 3
		cCondicao := "E5_MULTNAT = '1' .Or. (E5_NATUREZ >= mv_par05 .and. E5_NATUREZ <= mv_par06)"
		cCond2 := "E5_NATUREZ"
		cChave := IndexKey(4)
		cChaveInterFun := cChave
		titulo += OemToAnsi(STR0017)  //" por Natureza"
		bFirst := {||MsSeek(xFilial("SE5")+mv_par05,.T.)}
	Case nOrdem == 4
		cCondicao := ".T."
		cCond2 := "E5_BENEF"
		cChave := "E5_FILIAL+E5_BENEF+DTOS(E5_DATA)+E5_PREFIXO+E5_NUMERO+E5_PARCELA"
		cChaveInterFun := cChave
		titulo += OemToAnsi(STR0020)  //" Alfabetica"
		bFirst := {||MsSeek(xFilial("SE5"),.T.)}
	Case nOrdem == 5
		cCondicao := ".T."
		cCond2 := "E5_NUMERO"
		cChave := "E5_FILIAL+E5_NUMERO+E5_PARCELA+E5_PREFIXO+DTOS(E5_DATA)"
		cChaveInterFun := cChave
		titulo += OemToAnsi(STR0035) //" Nro. dos Titulos"
		bFirst := {||MsSeek(xFilial("SE5"),.T.)}
	Case nOrdem == 6	//Ordem 6 (Digitacao)
		cCondicao := ".T."
		cCond2 := "E5_DTDIGIT"
		cChave := "E5_FILIAL+DTOS(E5_DTDIGIT)+E5_PREFIXO+E5_NUMERO+E5_PARCELA+DTOS(E5_DATA)"
		cChaveInterFun := cChave
		titulo += OemToAnsi(STR0019)  //" Por Data de Digitacao"
		bFirst := {||MsSeek(xFilial("SE5"),.T.)}
	Case nOrdem == 7 // por Lote
		cCondicao := "E5_LOTE >= mv_par20 .and. E5_LOTE <= mv_par21"
		cCond2 := "E5_LOTE"
		cChave := IndexKey(5)
		cChaveInterFun := cChave
		titulo += OemToAnsi(STR0036)  //" por Lote"
		bFirst := {||MsSeek(xFilial("SE5")+mv_par20,.T.)}
	OtherWise						// Data de Crédito (dtdispo)
		cCondicao := "E5_DTDISPO >= mv_par01 .and. E5_DTDISPO <= mv_par02"
		cCond2 := "E5_DTDISPO"
		cChave := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ"
		cChaveInterFun := cChave
		titulo += OemToAnsi(STR0015)  //" por data de pagamento"
		bFirst := {||MsSeek(xFilial("SE5")+Dtos(mv_par01),.T.)}
EndCase

If !Empty(mv_par28) .And. ! ";" $ mv_par28 .And. Len(AllTrim(mv_par28)) > 3
	ApMsgAlert(STR0073)//"Separe os tipos a imprimir (pergunta 28) por um ; (ponto e virgula) a cada 3 caracteres")
	Return(Nil)
Endif
If !Empty(mv_par29) .And. ! ";" $ mv_par29 .And. Len(AllTrim(mv_par29)) > 3
	ApMsgAlert(STR0074)//"Separe os tipos que não deseja imprimir (pergunta 29) por um ; (ponto e virgula) a cada 3 caracteres")
	Return(Nil)
Endif

#IFDEF TOP
	If TcSrvType() != "AS/400" .and. TCGetDB()!="SYBASE"
		lAsTop := .T.
		cCondicao := ".T."
		DbSelectArea("SE5")
		                                                                  
		cQuery := ""
		aEval(DbStruct(),{|e| cQuery += ","+AllTrim(e[1])})
		// Obtem os registros a serem processados                         
                                                                                                                                                        
		cQue02 := cQuery
		If mv_par11 == 1     // receber
			cQue02 := StrTran(cQue02, "E5_NATUREZ", " (CASE WHEN SED.ED_NATENTR = ' ' THEN E5_NATUREZ ELSE ED_NATENTR END ) AS E5_NATUREZ")
		Elseif mv_par11 == 2 // pagar
			cQue02 := StrTran(cQue02, "E5_NATUREZ", " (CASE WHEN SED.ED_NATSAID = ' ' THEN E5_NATUREZ ELSE ED_NATSAID END ) AS E5_NATUREZ")
		EndIf
		cQue01 := "SELECT " +SubStr(cQue02,2)
		cQue01 +=         ", XXX.SE5RECNO "
		cQue01 += "  FROM ( "

		cQuery := "SELECT " +SubStr(cQuery,2)
		cQuery +=         ",SE5.R_E_C_N_O_ SE5RECNO "
		cQuery += "FROM " + RetSqlName("SE5")+" SE5 "
		cQuery += "WHERE E5_RECPAG = '" + IIF( mv_par11 == 1, "R","P") + "' AND "
		cQuery += "      E5_DATA    between '" + DTOS(mv_par01) + "' AND '" + DTOS(mv_par02) + "' AND "
		cQuery += "      E5_DATA    <= '" + DTOS(dDataBase) + "' AND "
		cQuery += "      E5_BANCO   between '" + mv_par03       + "' AND '" + mv_par04       + "' AND "
		//-- Realiza filtragem pela natureza principal
		If mv_par39 == 2
			cQuery +=  " E5_NATUREZ between '" + mv_par05       + "' AND '" + mv_par06     	+ "' AND "
		Else
			cQuery +=  " (E5_NATUREZ between '" + mv_par05       + "' AND '" + mv_par06     	+ "' OR "
			cQuery +=  " EXISTS (SELECT EV_FILIAL, EV_PREFIXO, EV_NUM, EV_PARCELA, EV_CLIFOR, EV_LOJA "
			cQuery +=            " FROM "+RetSqlName("SEV")+" SEV "
			cQuery +=           " WHERE E5_FILIAL  = EV_FILIAL  AND "
			cQuery +=                  "E5_PREFIXO = EV_PREFIXO AND "
			cQuery +=                  "E5_NUMERO  = EV_NUM     AND "
			cQuery +=                  "E5_PARCELA = EV_PARCELA AND "
			cQuery +=                  "E5_TIPO    = EV_TIPO    AND "
			cQuery +=                  "E5_CLIFOR  = EV_CLIFOR  AND "
			cQuery +=                  "E5_LOJA    = EV_LOJA    AND "
			cQuery +=                  "EV_NATUREZ between '" + mv_par05 + "' AND '" + mv_par06 + "' AND "
			cQuery +=                  "SEV.D_E_L_E_T_ = ' ')) AND "
		EndIf
		cQuery += "      E5_CLIFOR  between '" + mv_par07       + "' AND '" + mv_par08       + "' AND "
		cQuery += "      E5_DTDIGIT between '" + DTOS(mv_par09) + "' AND '" + DTOS(mv_par10) + "' AND "
		cQuery += "      E5_LOTE    between '" + mv_par20       + "' AND '" + mv_par21       + "' AND "
		cQuery += "      E5_LOJA    between '" + mv_par22       + "' AND '" + mv_par23 	    + "' AND "
		cQuery += "      E5_PREFIXO between '" + mv_par26       + "' AND '" + mv_par27 	    + "' AND "
		cQuery += "      SE5.D_E_L_E_T_ = ' '  AND "
		cQuery += "		  E5_TIPODOC NOT IN ('DC','D2','JR','J2','TL','MT','M2','CM','C2','TR','TE') AND "
		cQuery += " 	  E5_SITUACA NOT IN ('C','E','X') AND "
		cQuery += "      ((E5_TIPODOC = 'CD' AND E5_VENCTO <= E5_DATA) OR "
		cQuery += "      (E5_TIPODOC <> 'CD')) "
		cQuery += "		  AND E5_HISTOR NOT LIKE '%"+STR0077+"%'"
		
		//		cQuery += " AND E5_NUMERO = '125 '" //cintia
		
		If mv_par11 == 2
			cQuery += " AND E5_TIPODOC <> 'E2'"
		EndIf
		
		If !Empty(mv_par28) // Deseja imprimir apenas os tipos do parametro 28
			cQuery += " AND E5_TIPO IN "+FormatIn(mv_par28,";")
		ElseIf !Empty(Mv_par29) // Deseja excluir os tipos do parametro 29
			cQuery += " AND E5_TIPO NOT IN "+FormatIn(mv_par29,";")
		EndIf
		
		If mv_par16 == 2
			cQuery += " AND E5_TIPODOC <> '" + SPACE(LEN(E5_TIPODOC)) + "'"
			cQuery += " AND E5_NUMERO  <> '" + SPACE(LEN(E5_NUMERO)) + "'"
			cQuery += " AND E5_TIPODOC <> 'CH'"
		Endif
		   
		//cQuery += "AND E5_NUMERO = '121' "
	   //	cQuery += "AND E5_DATA = '20120229' "


		If mv_par17 == 2
			//cQuery += " AND E5_FILIAL = '" + xFilial("SE5") + "'"
			cQuery += " AND E5_FILIAL = '02'"
		Else
			cQuery += " AND E5_FILIAL between '" + mv_par18 + "' AND '" + mv_par19 + "'"
		Endif
		
		If lF190Qry
			cQueryAdd := ExecBlock("F190QRY", .F., .F., {aReturn[7]})
			If ValType(cQueryAdd) == "C"
				cQuery += " AND (" + cQueryAdd + ")"
			EndIf
		EndIf
		                             
		// seta a ordem de acordo com a opcao do usuario
		cQue01 += cQuery
		cQue01 += "       ) XXX "
		cQue01 += "  LEFT JOIN " + RetSqlName("SED")+" SED "
		cQue01 += "    ON SED.ED_CODIGO  = XXX.E5_NATUREZ
		cQue01 += "   AND SED.D_E_L_E_T_ = ''"
		
		cQuery := cQue01
		cQuery += " ORDER BY " + SqlOrder(cChave)
		cQuery := ChangeQuery(cQuery)
		
		MemoWrite("RFIN001.sql",cQuery)
		
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "NEWSE5", .F., .T.)
		For nI := 1 TO LEN(aStru)
			If aStru[nI][2] != "C"
				TCSetField("NEWSE5", aStru[nI][1], aStru[nI][2], aStru[nI][3], aStru[nI][4])
			EndIf
		Next
		DbGoTop()
	Else
#ENDIF
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Abre o SE5 com outro alias para ser filtrado porque a funcao³
	//³ TemBxCanc() utilizara o SE5 sem filtro.							 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Select("NEWSE5") == 0 .And. !( ChkFile("SE5",.F.,"NEWSE5") )
		Return(Nil)
	EndIf
	lAsTop := .F.
	DbSelectArea("NEWSE5")
	cFilSE5 := 'E5_RECPAG=='+IIF(mv_par11 == 1,'"R"','"P"')+'.and.'
	cFilSE5 += 'DTOS(E5_DATA)>='+'"'+dtos(mv_par01)+'"'+'.and.DTOS(E5_DATA)<='+'"'+dtos(mv_par02)+'".and.'
	cFilSE5 += 'DTOS(E5_DATA)<='+'"'+dtos(dDataBase)+'".and.'
	If nOrdem == 3
		cFilSE5 += '(E5_MULTNAT = "1" .Or. (E5_NATUREZ>='+'"'+mv_par05+'"'+'.and.E5_NATUREZ<='+'"'+mv_par06+'")).and.'
	Else
		cFilSE5 += '(E5_NATUREZ>='+'"'+mv_par05+'"'+'.and.E5_NATUREZ<='+'"'+mv_par06+'").and.'
	Endif
	cFilSE5 += 'E5_CLIFOR>='+'"'+mv_par07+'"'+'.and.E5_CLIFOR<='+'"'+mv_par08+'".and.'
	cFilSE5 += 'DTOS(E5_DTDIGIT)>='+'"'+dtos(mv_par09)+'"'+'.and.DTOS(E5_DTDIGIT)<='+'"'+dtos(mv_par10)+'".and.'
	cFilSE5 += 'E5_LOTE>='+'"'+mv_par20+'"'+'.and.E5_LOTE<='+'"'+mv_par21+'".and.'
	cFilSE5 += 'E5_LOJA>='+'"'+mv_par22+'"'+'.and.E5_LOJA<='+'"'+mv_par23+'".and.'
	cFilSe5 += 'E5_PREFIXO>='+'"'+mv_par26+'"'+'.And.E5_PREFIXO<='+'"'+mv_par27+'"'
	If !Empty(mv_par28) // Deseja imprimir apenas os tipos do parametro 28
		cFilSe5 += '.And.E5_TIPO $'+'"'+ALLTRIM(mv_par28)+Space(1)+'"'
	ElseIf !Empty(Mv_par29) // Deseja excluir os tipos do parametro 29
		cFilSe5 += '.And.!(E5_TIPO $'+'"'+ALLTRIM(mv_par29)+Space(1)+'")'
	EndIf
#IFDEF TOP
	Endif
#ENDIF	
// Se nao for TOP, ou se for TOP e for AS400, cria Filtro com IndRegua
// Pois em SQL os registros ja estao filtrados em uma Query
If !lAsTop
	cNomeArq := CriaTrab(Nil,.F.)
	IndRegua("NEWSE5",cNomeArq,cChave,,cFilSE5,OemToAnsi(STR0018))  //"Selecionando Registros..."
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define array para arquivo de trabalho    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aCampos,{"LINHA","C",80,0 } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de Trabalho   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomArq1 := CriaTrab(aCampos)
dbUseArea( .T.,, cNomArq1, "Trb", if(.F. .OR. .F., !.F., NIL), .F. )
IndRegua("TRB",cNomArq1,"LINHA",,,OemToAnsi(STR0018))  //"Selecionando Registros..."

aColu := Iif(aTam[1] > 6,{023,027,TamParcela("E1_PARCELA",40,39,38),042,000,022},{000,004,TamParcela("E1_PARCELA",17,16,15),019,023,030})

If MV_PAR16 == 1

	dbSelectArea("SE5")
	dbSetOrder(16) //"E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ+E5_TIPODOC+E5_SEQ"
	dbGoTop()

Endif

DbSelectArea("SM0")
DbSeek(cEmpAnt+cFilDe,.T.)

While !Eof() .and. M0_CODIGO == cEmpAnt .and. IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ) <= cFilAte
	cFilAnt := PadL(IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ),2)
	cFilNome:= SM0->M0_FILIAL
	DbSelectArea("NEWSE5")
	SetRegua(RecCount())
	// Se nao for TOP, ou se for TOP e for AS400, posiciona no primeiro registro do escopo	
	// Pois em SQL os registro ja estao filtrados em uma Query e ja esta no inicio do arquivo
	If !lAsTop
		Eval(bFirst) // Posiciona no primeiro registro a ser processado
	Endif

	If ((MV_MULNATR .and. mv_par11 = 1 .and. mv_par38 = 2 .and. !mv_par39 == 2) .or. (MV_MULNATP .and. mv_par11 = 2 .and. mv_par38 = 2 .and. !mv_par39 == 2) )       
		RF199_R3(	@nGerOrig,@nGerValor,@nGerDesc,@nGerJurMul,@nGerCM,@nGerAbLiq,@nGerAbImp,@nGerBaixado,@nGerMovFin,@nGerComp,;
					@nFilOrig,@nFilValor,@nFilDesc,@nFilJurMul,@nFilCM,@nFilAbLiq,@nFilAbImp,@nFilBaixado,@nFilMovFin,@nFilComp,;
					lEnd,cCondicao,cCond2,aColu,lContinua,cFilSe5,lAsTop,Tamanho,nOrdem, @nGerFat, @nFilFat)

		#IFDEF TOP
			If TcSrvType() != "AS/400" .and. TCGetDB()!="SYBASE"
				dbSelectArea("SE5")
				dbCloseArea()
				ChKFile("SE5")
				dbSelectArea("SE5")
				dbSetOrder(1)
			Endif
		#ENDIF
		If Empty(xFilial("SE5"))
			Exit
		Endif
		dbSelectArea("SM0")
		cCodUlt := SM0->M0_CODIGO
		cFilUlt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
		dbSkip()
		Loop                                  
	Else
		While NEWSE5->(!Eof()) .And. NEWSE5->E5_FILIAL==cFilAnt .And. &cCondicao .and. lContinua
			If lEnd
				@PROW()+1,001 PSAY OemToAnsi(STR0021)  //"CANCELADO PELO OPERADOR"
				lContinua:=.F.
				Exit
			EndIf
			
			IncRegua()
			DbSelectArea("NEWSE5")
			// Testa condicoes de filtro	
			If !Fr190TstCond(cFilSe5,.F.)
				NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
				Loop
			Endif						
								 	
			// Se nao for TOP, ou se for TOP e for AS400, posiciona no primeiro registro do escopo	
			// Pois em SQL os registro ja estao filtrados em uma Query e ja esta no inicio do arquivo
			If !lAsTop
				SE2->(dbSetOrder(1))
				SE2->(MsSeek(NEWSE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)))
				If SE2->E2_MULTNAT == '1'
					lNaturez := .F.
					SEV->(dbSetOrder(1))
					SEV->(MsSeek(NEWSE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)))
					While NEWSE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) == SEV->(EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA) .and. !lNaturez
						If SEV->EV_NATUREZ >= mv_par05 .and. SEV->EV_NATUREZ <= mv_par06
							lNaturez := .T.
						EndIf
						SEV->(DbSkip())
					EndDo
					If !lNaturez
						NEWSE5->(dbSkip())
						Loop
					EndIf
				Else
					If !(NEWSE5->E5_NATUREZ >= mv_par05 .and. NEWSE5->E5_NATUREZ <= mv_par06)
						NEWSE5->(dbSkip())
						Loop
					EndIf                                                      
				EndIf
			EndIf			
					 	
			If (NEWSE5->E5_RECPAG == "R" .and. ! (NEWSE5->E5_TIPO $ "PA /"+MV_CPNEG )) .or. ;	//Titulo normal
				(NEWSE5->E5_RECPAG == "P" .and.   (NEWSE5->E5_TIPO $ "RA /"+MV_CRNEG )) 	//Adiantamento
				cCarteira := "R"
			Else
				cCarteira := "P"
			Endif
	
			dbSelectArea("NEWSE5")
			cAnterior 	:= &cCond2
			cBancoAnt	:= NEWSE5->E5_BANCO
			cAgAnt		:= NEWSE5->E5_AGENCIA
			cContaAnt	:= NEWSE5->E5_CONTA
			
			nTotValor	:= 0
			nTotDesc	:= 0
			nTotJurMul  := 0
			nTotCM		:= 0
			nCT			:= 0
			nTotOrig	:= 0
			nTotBaixado	:= 0
			nTotAbLiq  	:= 0
			nTotImp		:= 0
			nTotMovFin	:= 0
			nTotComp	:= 0
			nTotFat	    := 0
	                                    
			While NEWSE5->(!EOF()) .and. &cCond2=cAnterior .and. NEWSE5->E5_FILIAL=cFilAnt .and. lContinua
	
				lManual := .f.
				dbSelectArea("NEWSE5")
				
				IF lEnd
					@PROW()+1,001 PSAY OemToAnsi(STR0021)  //"CANCELADO PELO OPERADOR"
					lContinua:=.F.
					Exit
				EndIF
	
				If (Empty(NEWSE5->E5_TIPODOC) .And. mv_par16 == 1) .Or.;
					(Empty(NEWSE5->E5_NUMERO)  .And. mv_par16 == 1)
					lManual := .t.
				EndIf
				
				// Testa condicoes de filtro	
				If !Fr190TstCond(cFilSe5,.T.)
					dbSelectArea("NEWSE5")
					NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
					Loop
				Endif	               											
				
				// Imprime somente cheques
				If mv_par37 == 1 .And. NEWSE5->E5_TIPODOC == "BA"

					aAreaSE5 := SE5->(GetArea())
					lAchou := .F.

					SE5->(dbSetOrder(11))
					cChaveNSE5	:= NEWSE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)
					SE5->(MsSeek(cFilAnt+cChaveNSE5))					
               
					// Procura o cheque aglutinado, se encontrar, marca lAchou := .T. e despreza 
					WHILE SE5->(!EOF()) .And. SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)	== cChaveNSE5
						If SE5->E5_TIPODOC == "CH"
							lAchou := .T.
							Exit
						Endif
						SE5->(dbSkip())
					Enddo
					RestArea(aAreaSE5)
					// Achou cheque aglutinado para a baixa, despreza o registro
					If lAchou
						NEWSE5->(dbSkip())
						Loop
					Endif  	

				ElseIf mv_par37 == 2 .And. NEWSE5->E5_TIPODOC == "CH" //somente baixas

					aAreaSE5 := SE5->(GetArea())
					lAchou := .F.
					
					SE5->(dbSetOrder(11))
					cChaveNSE5	:= NEWSE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)
					SE5->(MsSeek(cFilAnt+cChaveNSE5))					
               
					// Procura a baixa aglutinada, se encontrar despreza o movimento bancario
					WHILE SE5->(!EOF()) .And. SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)	== cChaveNSE5
						If SE5->E5_TIPODOC $ "BA"
							lAchou := .T.
							Exit
						Endif	
						SE5->(dbSkip())
					Enddo
					RestArea(aAreaSE5)
					// Achou cheque aglutinado para a baixa, despreza o registro
					If lAchou
						NEWSE5->(dbSkip())
						Loop
					Endif
				Endif	

				cFil_NewSE5 := NEWSE5->E5_FILIAL
				cNumero    	:= NEWSE5->E5_NUMERO
				cPrefixo   	:= NEWSE5->E5_PREFIXO
				cParcela   	:= NEWSE5->E5_PARCELA
				dBaixa     	:= NEWSE5->E5_DATA
				cBanco     	:= NEWSE5->E5_BANCO
				cNatureza  	:= NEWSE5->E5_NATUREZ
				cCliFor    	:= NEWSE5->E5_BENEF
				cLoja      	:= NEWSE5->E5_LOJA
				cSeq       	:= NEWSE5->E5_SEQ
				cNumCheq   	:= NEWSE5->E5_NUMCHEQ
				cRecPag 	:= NEWSE5->E5_RECPAG
				cTipodoc   	:= NEWSE5->E5_TIPODOC
				cMotBaixa	:= NEWSE5->E5_MOTBX
				cCheque    	:= NEWSE5->E5_NUMCHEQ
				cTipo      	:= NEWSE5->E5_TIPO
				cFornece   	:= NEWSE5->E5_CLIFOR
				cLoja      	:= NEWSE5->E5_LOJA
				dDigit     	:= NEWSE5->E5_DTDIGIT
				lBxTit	  	:= .F.
				cFilorig    := NEWSE5->E5_FILORIG
				
				If (NEWSE5->E5_RECPAG == "R" .and. ! (NEWSE5->E5_TIPO $ "PA /"+MV_CPNEG )) .or. ;	//Titulo normal
					(NEWSE5->E5_RECPAG == "P" .and.   (NEWSE5->E5_TIPO $ "RA /"+MV_CRNEG )) 	//Adiantamento
					dbSelectArea("SE1")
					dbSetOrder(1)
					lBxTit := MsSeek(cFil_NewSE5+cPrefixo+cNumero+cParcela+cTipo)
					If !lBxTit
						lBxTit := dbSeek(NEWSE5->E5_FILORIG+cPrefixo+cNumero+cParcela+cTipo)
					Endif				
					cCarteira := "R"
					dDtMovFin := IIF (lManual,CTOD("//"), DataValida(SE1->E1_VENCTO,.T.))
					While SE1->(!Eof()) .and. SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO==cPrefixo+cNumero+cParcela+cTipo
						If SE1->E1_CLIENTE == cFornece .And. SE1->E1_LOJA == cLoja	// Cliente igual, Ok
							Exit
						Endif                                
						SE1->( dbSkip() )
					EndDo
					If !SE1->(EOF()) .And. mv_par11 == 1 .and. !lManual .and.  ;
						(NEWSE5->E5_RECPAG == "R" .and. !(NEWSE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG))
						If SE5->(FieldPos("E5_SITCOB")) > 0
							cExp := "NEWSE5->E5_SITCOB"
						Else
							cExp := "SE1->E1_SITUACA"
						Endif 
						
						If mv_par36 == 2 // Nao imprime titulos em carteira 
							// Retira da comparacao as situacoes branco, 0, F e G
							mv_par15 := AllTrim(mv_par15)       
							mv_par15 := StrTran(mv_par15,"0","")
							mv_par15 := StrTran(mv_par15,"F","")
							mv_par15 := StrTran(mv_par15,"G","")
						Else
							If (NEWSE5->E5_RECPAG == "R") .And. lAjuPar15
								mv_par15  += " "
							Endif
						EndIf	
				
						cExp += " $ mv_par15" 
						If !(&cExp)
							dbSelectArea("NEWSE5")
							NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
							Loop
						Endif
					Endif
					cCond3:="E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DtoS(E5_DATA)+E5_SEQ+E5_NUMCHEQ==cPrefixo+cNumero+cParcela+cTipo+DtoS(dBaixa)+cSeq+cNumCheq"
					nDesc := nJuros := nValor := nMulta := nJurMul := nCM := nVlMovFin := 0
				Else
					dbSelectArea("SE2")
					DbSetOrder(1)                                            
					cCarteira := "P"
				    lBxTit := MsSeek(cFil_NewSE5+cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja)
					If !lBxTit
						lBxTit := dbSeek(NEWSE5->E5_FILORIG+cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja)
					Endif				
					dDtMovFin := IIF(lManual,CTOD("//"),DataValida(SE2->E2_VENCTO,.T.))
					cCond3:="E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+DtoS(E5_DATA)+E5_SEQ+E5_NUMCHEQ==cPrefixo+cNumero+cParcela+cTipo+cFornece+DtoS(dBaixa)+cSeq+cNumCheq"
					nDesc := nJuros := nValor := nMulta := nJurMul := nCM := nVlMovFin := 0
					cCheque    := Iif(Empty(NEWSE5->E5_NUMCHEQ),SE2->E2_NUMBCO,NEWSE5->E5_NUMCHEQ)
				Endif
				dbSelectArea("NEWSE5")
				IncRegua()
				cHistorico := Space(40)
				While NEWSE5->( !Eof()) .and. &cCond3 .and. lContinua .And. NEWSE5->E5_FILIAL==cFilAnt
					
					IncRegua()

					c_obra := fbuscaobra(NEWSE5->E5_RECPAG, NEWSE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_FORNECE+E5_LOJA))
					//If !Empty(MV_PAR40)                      
					//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20160315] por padrao foi incluido o MV_PAR40 e MV_PAR41
					If !Empty(MV_PAR42)                      
						//If c_obra <> AllTrim(MV_PAR40) 
						//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20160315] por padrao foi incluido o MV_PAR40 e MV_PAR41
						If c_obra <> AllTrim(MV_PAR42) 
							NEWSE5->(DbSkip())
							Loop                                                            
						EndIf
					EndIf

					dbSelectArea("NEWSE5")
					cTipodoc   := NEWSE5->E5_TIPODOC
					cCheque    := NEWSE5->E5_NUMCHEQ
	
					lAchouEmp := .T.
					lAchouEst := .F.
	
					IF lEnd
						@PROW()+1,001 PSAY OemToAnsi(STR0021)  //"CANCELADO PELO OPERADOR"
						lContinua:=.F.
						Exit
					EndIF	                																		
	
					// Testa condicoes de filtro	
					If !Fr190TstCond(cFilSe5,.T.)
						dbSelectArea("NEWSE5")
						NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
						Loop
					Endif  								
										
					If NEWSE5->E5_SITUACA $ "C/E/X" 
						dbSelectArea("NEWSE5")
						NEWSE5->( dbSkip() )
						Loop
					EndIF
					
					If NEWSE5->E5_LOJA != cLoja
						Exit
					Endif
	
					If NEWSE5->E5_FILORIG < mv_par33 .or. NEWSE5->E5_FILORIG > mv_par34
						dbSelectArea("NEWSE5")
						NEWSE5->( dbSkip() )
						Loop
					Endif
	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Nao imprime os registros de emprestimos excluidos ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ					
					If NEWSE5->E5_TIPODOC == "EP"
						aAreaSE5 := NEWSE5->(GetArea())	
						dbSelectArea("SEH")
						dbSetOrder(1)
						lAchouEmp := MsSeek(xFilial("SEH")+Substr(NEWSE5->E5_DOCUMEN,1,nTamEH))
						RestArea(aAreaSE5)
						If !lAchouEmp
							NEWSE5->(dbSkip())
							Loop
						EndIf
					EndIf
	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Nao imprime os registros de pagamento de emprestimos estornados ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ					
					If NEWSE5->E5_TIPODOC == "PE"
						aAreaSE5 := NEWSE5->(GetArea())	
						dbSelectArea("SEI")
						dbSetOrder(1)
						If	MsSeek(xFilial("SEI")+"EMP"+Substr(NEWSE5->E5_DOCUMEN,1,nTamEI))
							If SEI->EI_STATUS == "C"
								lAchouEst := .T.
							EndIf
						EndIf
						RestArea(aAreaSE5)
						If lAchouEst
							NEWSE5->(dbSkip())
							Loop
						EndIf
					EndIf                                      
	  
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica o vencto do Titulo ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cFilTrb := If(mv_par11==1,"SE1","SE2")
					If (cFilTrb)->(!Eof()) .And.;
						((cFilTrb)->&(Right(cFilTrb,2)+"_VENCREA") < mv_par31 .Or. (!Empty(mv_par32) .And. (cFilTrb)->&(Right(cFilTrb,2)+"_VENCREA") > mv_par32))
						dbSelectArea("NEWSE5")
						NEWSE5->(dbSkip())
						Loop
					Endif
	            
					dBaixa     	:= NEWSE5->E5_DATA
					cBanco     	:= NEWSE5->E5_BANCO
					cNatureza  	:= NEWSE5->E5_NATUREZ
					cCliFor    	:= NEWSE5->E5_BENEF
					cSeq       	:= NEWSE5->E5_SEQ
					cNumCheq   	:= NEWSE5->E5_NUMCHEQ
					cRecPag		:= NEWSE5->E5_RECPAG
					cMotBaixa	:= NEWSE5->E5_MOTBX
					cTipo190	:= NEWSE5->E5_TIPO
					cFilorig    := NEWSE5->E5_FILORIG
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Obter moeda da conta no Banco.                               ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If ( cPaisLoc # "BRA".And.!Empty(NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA) ) .OR. ( FindFunction( "FXMultSld" ) .AND. FXMultSld() )
						SA6->(DbSetOrder(1))
						SA6->(MsSeek(xFilial()+NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA))
						nMoedaBco	:=	Max(SA6->A6_MOEDA,1)
					Else
						nMoedaBco	:=	1
					Endif
	
					If !Empty(NEWSE5->E5_NUMERO)
						If (NEWSE5->E5_RECPAG == "R" .and. !(NEWSE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG)) .or. ;
							(NEWSE5->E5_RECPAG == "P" .and. NEWSE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG) .Or.;
							(NEWSE5->E5_RECPAG == "P" .And. NEWSE5->E5_TIPODOC $ "DB#OD")
							dbSelectArea( "SA1")
							dbSetOrder(1)
							lAchou := .F.
							If Empty(xFilial("SA1"))  //SA1 Compartilhado
								If dbSeek(xFilial("SA1")+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
									lAchou := .T.
								Endif
							Else
								cFilOrig := NEWSE5->E5_FILIAL //Procuro SA1 pela filial do movimento
								If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
									If Upper(Alltrim(SA1->A1_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
										lAchou := .T.
									Else
										cFilOrig := NEWSE5->E5_FILORIG //Procuro SA1 pela filial origem
										If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
											If Upper(Alltrim(SA1->A1_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
												lAchou := .T.
											Endif
										Endif
									Endif
								Else
									cFilOrig := NEWSE5->E5_FILORIG	//Procuro SA1 pela filial origem
									If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
										If Upper(Alltrim(SA1->A1_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
											lAchou := .T.
										Endif
									Endif
								Endif							
							EndIF
							If lAchou 
								cCliFor := Iif(mv_par30==1,SA1->A1_NREDUZ,SA1->A1_NOME)
							Endif
						Else
							dbSelectArea( "SA2")
							dbSetOrder(1)
							lAchou := .F.
							If Empty(xFilial("SA2"))  //SA2 Compartilhado
								If dbSeek(xFilial("SA2")+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
									lAchou := .T.
								Endif
							Else
								cFilOrig := NEWSE5->E5_FILIAL //Procuro SA2 pela filial do movimento
								If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
									If Upper(Alltrim(SA2->A2_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
										lAchou := .T.
									Else
										cFilOrig := NEWSE5->E5_FILORIG //Procuro SA2 pela filial origem
										If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
											If Upper(Alltrim(SA2->A2_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
												lAchou := .T.
											Endif
										Endif
									Endif
								Else
									cFilOrig := NEWSE5->E5_FILORIG	//Procuro SA2 pela filial origem
									If dbSeek(cFilOrig+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
										If Upper(Alltrim(SA2->A2_NREDUZ)) == Upper(Alltrim(NEWSE5->E5_BENEF))
											lAchou := .T.
										Endif
									Endif
								Endif							
							EndIF
							If lAchou 
								cCliFor := Iif(mv_par30==1,SA2->A2_NREDUZ,SA2->A2_NOME)
							Endif
						EndIf
					EndIf
					dbSelectArea("SM2")
					dbSetOrder(1)
					dbSeek(NEWSE5->E5_DATA)
					dbSelectArea("NEWSE5")
					nTaxa:= 0
					If cPaisLoc=="BRA"
						If !Empty(NEWSE5->E5_TXMOEDA)
							nTaxa:=NEWSE5->E5_TXMOEDA
						Else
							nTaxa:=NEWSE5->E5_VALOR /NEWSE5->E5_vlmoed2
						EndIf
					EndIf
					nRecSe5:=If(lAsTop,NEWSE5->SE5RECNO,Recno())
					nDesc+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLDESCO,Round(xMoeda(NEWSE5->E5_VLDESCO,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,nTaxa),nDecs+1))
					nJuros+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLJUROS,Round(xMoeda(NEWSE5->E5_VLJUROS,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,nTaxa),nDecs+1))
					nMulta+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLMULTA,Round(xMoeda(NEWSE5->E5_VLMULTA,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,nTaxa),nDecs+1))
					nJurMul+= nJuros + nMulta
					nCM+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLCORRE,Round(xMoeda(NEWSE5->E5_VLCORRE,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,nTaxa),nDecs+1))
										
					If cCarteira == "R" .and. mv_par12 == SE1->E1_MOEDA					
					   nCM := 0
					
					ElseIf cCarteira == "P" .and. mv_par12 == SE2->E2_MOEDA
					   nCM := 0					   
					Endif					
										
					If lPccBaixa .and. Empty(NEWSE5->E5_PRETPIS) .And. Empty(NEWSE5->E5_PRETCOF) .And. Empty(NEWSE5->E5_PRETCSL)
						nTotAbImp+=(NEWSE5->E5_VRETPIS)+(NEWSE5->E5_VRETCOF)+(NEWSE5->E5_VRETCSL)
					Endif				
					If NEWSE5->E5_TIPODOC $ "VL/V2/BA/RA/PA/CP"
						cHistorico := NEWSE5->E5_HISTOR
						nValor+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VALOR,Round(xMoeda(NEWSE5->E5_VALOR,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,nTaxa),nDecs+1))

						//Pcc Baixa CR
						If cCarteira == "R" .and. lPccBxCr .and. cPaisLoc == "BRA"
							If Empty(NEWSE5->E5_PRETPIS) 
								nPccBxCr += Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VRETPIS,Round(xMoeda(NEWSE5->E5_VRETPIS,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,NEWSE5->E5_TXMOEDA),nDecs+1))
							Endif						
							If Empty(NEWSE5->E5_PRETCOF) 
								nPccBxCr += Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VRETCOF,Round(xMoeda(NEWSE5->E5_VRETCOF,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,NEWSE5->E5_TXMOEDA),nDecs+1))
							Endif						
							If Empty(NEWSE5->E5_PRETCSL) 
								nPccBxCr += Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VRETCSL,Round(xMoeda(NEWSE5->E5_VRETCSL,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,NEWSE5->E5_TXMOEDA),nDecs+1))
							Endif											
						Endif

					Else
						nVlMovFin+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VALOR,Round(xMoeda(NEWSE5->E5_VALOR,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,nTaxa),nDecs+1))
						cHistorico := Iif(Empty(NEWSE5->E5_HISTOR),"MOV FIN MANUAL",NEWSE5->E5_HISTOR)
						cNatureza  	:= NEWSE5->E5_NATUREZ
					Endif	
					dbSkip()
					If lManual		// forca a saida do looping se for mov manual
						Exit
					Endif
				EndDO
	
				If (nDesc+nValor+nJurMul+nCM+nVlMovFin) > 0
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ C lculo do Abatimento        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If cCarteira == "R" .and. !lManual
						dbSelectArea("SE1")
						nRecno := Recno()
						nAbat := 0
						nAbatLiq := 0						
						If !SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG 

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Encontra a ultima sequencia de baixa na SE5 a partir do título da SE1 ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							aAreaSE1 := SE1->(GetArea())
							dbSelectArea("SE5")
							dbSetOrder(7)
							cChaveSE1 := SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)
							SE5->(MsSeek(cFilAnt+cChaveSE1))					
		               
							cSeqSE5 := SE5->E5_SEQ
                     
							While SE5->(!EOF()) .And. cChaveSE1 == SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
								If SE5->E5_SEQ > cSeqSE5
									cSeqSE5 := SE5->E5_SEQ
								Endif	
								SE5->(dbSkip())
							Enddo

							SE5->(MsSeek(cFilAnt+cChaveSE1+cSeqSE5))
							cChaveSE5 := cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja+cSeq							

							If cChaveSE5 == SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ) .And.;
								Empty(SE1->E1_SALDO)
								If SE1->E1_VALOR <> SE1->E1_VALLIQ
									lUltBaixa := .T.
								EndIf
							EndIf                                                      

							RestArea(aAreaSE1)
                                                         
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Calcula o valor total de abatimento do titulo e impostos se houver ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							nTotAbImp := 0
							
							If lUltBaixa
								nAbat := SumAbatRec(cPrefixo,cNumero,cParcela,SE1->E1_MOEDA,"V",dBaixa,@nTotAbImp)
								nAbatLiq := nAbat - nTotAbImp
							EndIf
						                             
							lUltBaixa := .F.
						EndIf			
						dbSelectArea("SE1")
						dbGoTo(nRecno)
					Elseif !lManual
						dbSelectArea("SE2")
						nRecno := Recno()
						nAbat := 0
						nAbatLiq := 0						
						If !SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG
							nAbat :=	SomaAbat(cPrefixo,cNumero,cParcela,"P",mv_par12,,cFornece,cLoja)
							nAbatLiq := nAbat	
						EndIf			
						dbSelectArea("SE2")
						dbGoTo(nRecno)
					EndIF
	
					If li > 60
						cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
					EndIF
	
					xPlan01 := ""
					xPlan02 := ""
					xPlan03 := ""
					xPlan04 := ""
					xPlan05 := ""
					xPlan06 := ""
					xPlan07 := ""
					xPlan08 := ""
					xPlan09 := ""
					xPlan10 := ""
					xPlan11 := ""
					xPlan12 := Ctod("")
					xPlan13 := 0
					xPlan14 := 0
					xPlan15 := 0
					xPlan16 := 0
					xPlan17 := 0
					xPlan19 := 0
					xPlan20 := ""
					xPlan21 := Ctod("")
					xPlan22 := ""
					xPlan23 := ""                   

					IF mv_par11 == 1 .and. aTam[1] > 6 .and. !lManual
						If lBxTit
							@li, aColu[05] PSAY SE1->E1_CLIENTE						
							xPlan01 := SE1->E1_CLIENTE	
						Endif
						@li, aColu[06] PSAY SubStr(cCliFor,1,18)
						li++                                                 
						xPlan02 := SubStr(cCliFor,1,18)
					Elseif mv_par11 == 2 .and. aTam[1] > 6 .and. !lManual
						If lBxTit
							@li, aColu[05] PSAY SE2->E2_FORNECE
							xPlan01 := SE2->E2_FORNECE
						Endif
						@li, aColu[06] PSAY SubStr(cCliFor,1,18)
						li++
						xPlan02 := SubStr(cCliFor,1,18)
					Endif
	
					@li, aColu[01] PSAY cPrefixo
					@li, aColu[02] PSAY cNumero
					
					If cPaisLoc	$ "MEX|PTG"
					   li++
					Endif					
					
					@li, aColu[03] PSAY cParcela
					@li, aColu[04] PSAY cTipo		

					If !lManual
						dbSelectArea("TRB")
						lOriginal := .T.
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Baixas a Receber             ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If cCarteira == "R"
							cCliFor190 := SE1->E1_CLIENTE+SE1->E1_LOJA
							nVlr:= SE1->E1_VLCRUZ
							If mv_par12 > 1
								nVlr := Round(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par12,SE1->E1_BAIXA,nDecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),nDecs+1)
							EndIF
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Baixa de PA                  ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						Else
							cCliFor190 := SE2->E2_FORNECE+SE2->E2_LOJA
							nVlr:= SE2->E2_VLCRUZ
							If mv_par12 > 1
								nVlr := Round(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par12,SE2->E2_BAIXA,nDecs+1,If(cPaisLoc=="BRA",SE2->E2_TXMOEDA,0)),nDecs+1)
							Endif
						Endif
						cFilTrb := If(cCarteira=="R","SE1","SE2")
						IF DbSeek( xFilial(cFilTrb)+cPrefixo+cNumero+cParcela+cCliFor190+cTipo)
							nAbat:=0
							lOriginal := .F.
						Else
							nVlr:=NoRound(nVlr)
							RecLock("TRB",.T.)
							Replace linha With xFilial(cFilTrb)+cPrefixo+cNumero+cParcela+cCliFor190+cTipo
							MsUnlock()
						EndIF
					Else
						If lAsTop
							dbSelectArea("SE5")
						Else
							dbSelectArea("NEWSE5")
						Endif
						dbgoto(nRecSe5)
						nVlr := Round(xMoeda(E5_VALOR,nMoedaBco,mv_par12,E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",E5_TXMOEDA,0)),nDecs+1)
						nAbat:= 0
						lOriginal := .t.
						If lAsTop
							nRecSe5:=NEWSE5->SE5RECNO
						Else
							nRecSe5:=Recno()
							NEWSE5->( dbSkip() )
						Endif
						dbSelectArea("TRB")
					Endif
					IF cCarteira == "R"
						If ( !lManual )
							If mv_par13 == 1  // Utilizar o Hist¢rico da Baixa ou Emiss„o
								cHistorico := Iif(Empty(cHistorico), SE1->E1_HIST, cHistorico )
							Else
								cHistorico := Iif(Empty(SE1->E1_HIST), cHistorico, SE1->E1_HIST )
							Endif
						EndIf
						If aTam[1] <= 6 .and. !lManual
							If lBxTit
								@li, aColu[05] PSAY SE1->E1_CLIENTE
								xPlan01 := SE1->E1_CLIENTE
							Endif
							@li, aColu[06] PSAY SubStr(cCliFor,1,18)
							xPlan02 := SubStr(cCliFor,1,18)
						Endif

						@ li, 49 PSAY cNatureza
						If Empty( dDtMovFin ) .or. dDtMovFin == Nil
							dDtMovFin := CtoD("  /  /  ")
						Endif    
						
						@li, 60 PSAY c_obra   //IIf(lManual,dDtMovFin,DataValida(SE1->E1_VENCTO,.T.)) Cintia
						@li, 71 PSAY SubStr( cHistorico ,1,19)
						@li, 93 PSAY dBaixa
						IF nVlr > 0
							@li,103 PSAY nVlr  Picture tm(nVlr,14,nDecs)
						Endif
					Else
						If mv_par13 == 1  // Utilizar o Hist¢rico da Baixa ou Emiss„o
							cHistorico := Iif(Empty(cHistorico), SE2->E2_HIST, cHistorico )
							xPlan11 := cHistorico
						Else
							cHistorico := Iif(Empty(SE2->E2_HIST), cHistorico, SE2->E2_HIST )
							xPlan11 := cHistorico
						Endif
						If aTam[1] <= 6 .and. !lManual
							If lBxTit
								@li, aColu[05] PSAY SE2->E2_FORNECE
								xPlan01 := SE2->E2_FORNECE
							Endif
							@li, aColu[06] PSAY SubStr(cCliFor,1,18)
							xPlan02 := SubStr(cCliFor,1,18)
						Endif

						@li, 49 PSAY cNatureza
						If Empty( dDtMovFin ) .or. dDtMovFin == Nil
							dDtMovFin := CtoD("  /  /  ")
						Endif
						@li, 60 PSAY c_obra   //IIf(lManual,dDtMovFin,DataValida(SE2->E2_VENCTO,.T.)) Cintia	
						If !Empty(cCheque)
							@li, 71 PSAY SubStr(ALLTRIM(cCheque)+"/"+Trim(cHistorico),1,18)
							xPlan11 := SubStr(ALLTRIM(cCheque)+"/"+Trim(cHistorico),1,18)
						Else
							@li, 71 PSAY SubStr(cHistorico,1,19)
							xPlan11 := SubStr(cHistorico,1,19)
						EndIf
						@li, 93 PSAY dBaixa                                        
						IF nVlr > 0
							@li,103 PSAY nVlr Picture tm(nVlr,14,nDecs)
						Endif
					Endif
					nCT++
					
					//PCC Baixa CR
					//Somo aos abatimentos de impostos, os impostos PCC na baixa.
					//Caso o calculo do PCC CR seja pela emissao, esta variavel estara zerada
					nTotAbImp := nTotAbImp + nPccBxCr

					@li,118 PSAY nJurMul    PicTure tm(nJurMul,11,nDecs)
					@li,130 PSAY nCM        PicTure tm(nCM ,11,nDecs)
					@li,142 PSAY nDesc      PicTure tm(nDesc,11,nDecs)
					@li,154 PSAY nAbatLiq  	Picture tm(nAbatLiq,11,nDecs)
					@li,166 PSAY nTotAbImp 	Picture tm(nTotAbImp,11,nDecs)
					If nVlMovFin > 0
						@li,178 PSAY nVlMovFin     PicTure tm(nVlMovFin,15,nDecs)
						xPlan19 := nVlMovFin
					Else
						@li,178 PSAY nValor			PicTure tm(nValor,15,nDecs)
						xPlan19 := nValor
					Endif
					@li,196 PSAY cBanco
					If Len(DtoC(dDigit)) <= 8
						@li,202 PSAY dDigit
					Else                   
						@li,200 PSAY dDigit
					EndIf
	
					If empty(cMotBaixa)
						cMotBaixa := "NOR"  //NORMAL
					Endif
	
					@li,211 PSAY Substr(cMotBaixa,1,3)
					@li,215 PSAY cFilorig

					xPlan03 := CHR(9) + cPrefixo
					xPlan04 := CHR(9) + cNumero
					xPlan05 := CHR(9) + cParcela
					xPlan06 := CHR(9) + cTipo		
					xPlan07 := CHR(9) + xPlan01
					xPlan08 := CHR(9) + xPlan02
					xPlan09 := CHR(9) + cNatureza
					xPlan10 := CHR(9) + c_obra
					xPlan13 := nVlr
					xPlan12 := dBaixa
					xPlan14 := nJurMul
					xPlan15 := nCM
					xPlan16 := nDesc
					xPlan17 := nAbatLiq
					xPlan18 := nTotAbImp
					xPlan20 := CHR(9) + cBanco
					xPlan21 := dDigit
					xPlan22 := CHR(9) + Substr(cMotBaixa,1,3)
					xPlan23 := CHR(9) + cFilorig

					Aadd(aPlanilha, {xPlan03, xPlan04, xPlan05, xPlan06, xPlan07, xPlan08, xPlan09, xPlan10, xPlan11, xPlan12, xPlan13, xPlan14, xPlan15, xPlan16, xPlan17, xPlan18, xPlan19, xPlan20, xPlan21, xPlan22, xPlan23 })
					
					nTotOrig   += Iif(lOriginal,nVlr,0)
					nTotBaixado+= If(cTipodoc $ "CP/BA" .AND. cMotBaixa $ "CMP/FAT",0,nValor)		// n„o soma, j  somou no principal
					nTotDesc   += nDesc
					nTotJurMul += nJurMul
					nTotCM     += nCM
					nTotAbLiq  += nAbatLiq
					nTotImp    += nTotAbImp                 
					nTotValor  += IIF( nVlMovFin <> 0, nVlMovFin , Iif(MovBcoBx(cMotBaixa),nValor,0))
					nTotMovFin += nVlMovFin
					nTotComp   += Iif(cTipodoc == "CP",nValor,0)
					nTotFat	   += Iif(cMotBaixa $ "FAT",nValor, 0)				
					nDesc := nJurMul := nValor := nCM := nAbat := nTotAbImp := nAbatLiq := nVlMovFin := 0
					nPccBxCr	 := 0			//PCC Baixa
					li++
					
				Endif
				dbSelectArea("NEWSE5")
			Enddo
	
			If (nTotValor+nDesc+nJurMul+nCM+nTotOrig+nTotMovFin+nTotComp)>0
				li++
				IF li > 60
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
				Endif
				If nCT > 0
					IF nOrdem == 1 .or. nOrdem == 6 .or. nOrdem == 8
						@li, 0 PSAY "Sub Total : " + DTOC(cAnterior)
					Elseif nOrdem == 2 .or. nOrdem == 4 .or. nOrdem == 7
						cLinha := "Sub Total : "+cAnterior+" "
						If nOrdem == 4
							If (mv_par11 == 1 .and. (cRecpag == "R" .and. !(cTipo190 $ MVPAGANT+"/"+MV_CPNEG))) .or. ;
								(cRecpag == "P" .and. cTipo190 $ MVRECANT+"/"+MV_CRNEG) .Or.;
								(cRecPag == "P" .And. cTipoDoc $ "DB#OD")
	
								dbSelectArea("SA1")
								DbSetOrder(1)
								If !Empty(cAnterior)
									MsSeek(cFil_NewSE5+cFornece+cLoja)
									cLinha+=" "+A1_CGC
								Else
									cLinha+= OemToAnsi(STR0038)  //"Moviment. Financeiras Manuais "
								Endif
							ElseIF (mv_par11 == 2 .and. (cRecpag == "P" .and. !(cTipo190 $ MVRECANT+"/"+MV_CRNEG))) .or.;
									(cRecpag == "R" .and. cTipo190 $ MVPAGANT+"/"+MV_CPNEG)
								dbSelectArea("SA2")
								DbSetOrder(1)
								If !Empty(cAnterior)
									MsSeek(cFil_NewSE5+cFornece+cLoja)
									cLinha+=TRIM(A2_NOME)+"  "+A2_CGC
								Else
									cLinha+= OemToAnsi(STR0038)  //"Moviment. Financeiras Manuais "
								Endif
							Endif
						Elseif nOrdem == 2
							dbSelectArea("SA6")
							DbSetOrder(1)
							MsSeek(xFilial("SA6")+cBancoAnt+cAgAnt+cContaAnt)
							cLinha+=TRIM(A6_NOME)
						Endif
						@li,0 PSAY cLinha
					Elseif nOrdem == 3
						dbSelectArea("SED")
						DbSetOrder(1)
						MsSeek(cFil_NewSE5+cAnterior)
						@li, 0 PSAY "SubTotal : " + cAnterior + " "+ED_DESCRIC
					Endif
					If nOrdem != 5
						@li,102 PSAY nTotOrig     PicTure tm(nTotOrig,15,nDecs)
						@li,118 PSAY nTotJurMul   PicTure tm(nTotJurMul,11,nDecs)
  						@li,130 PSAY nTotCM       PicTure tm(nTotCM ,11,nDecs)
						@li,142 PSAY nTotDesc     PicTure tm(nTotDesc,11,nDecs)
						@li,154 PSAY nTotAbLiq    Picture tm(nTotAbLiq,11,nDecs)
						@li,166 PSAY nTotImp      Picture tm(nTotImp,11,nDecs)  
						@li,178 PSAY nTotValor    PicTure tm(nTotValor,15,nDecs)
						If nTotBaixado > 0
							@li,195 PSAY STR0028  //"Baixados"
							@li,204 PSAY nTotBaixado  PicTure tm(nTotBaixado,15,nDecs)
						Endif	
						If nTotMovFin > 0
							li++
							@li,195 PSAY STR0031   //"Mov Fin."
							@li,204 PSAY nTotMovFin   PicTure tm(nTotMovFin,15,nDecs)
						Endif
						If nTotComp > 0
							li++
							@li,195 PSAY STR0037  //"Compens."
							@li,204 PSAY nTotComp     PicTure tm(nTotComp,15,nDecs)
						Endif
						If nTotFat > 0
							li++
							@li,195 PSAY STR0076  //"Bx.Fatura"
							@li,204 PSAY nTotFat     PicTure tm(nTotFat,15,nDecs)
						Endif						
						li+=2
					Endif
					dbSelectArea("NEWSE5")
				Endif
			Endif
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Incrementa Totais Gerais ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nGerOrig	   += nTotOrig
			nGerValor	+= nTotValor 
			nGerDesc	   += nTotDesc
			nGerJurMul	+= nTotJurMul
			nGerCM		+= nTotCM                        
			nGerAbLiq	+= nTotAbLiq                                    
			nGerAbImp	+= nTotImp
			nGerBaixado += nTotBaixado
			nGerMovFin	+= nTotMovFin
			nGerComp	+= nTotComp
			nGerFat     += nTotFat			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                                   
			//³Incrementa Totais Filial ³                                  
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nFilOrig	+= nTotOrig               
			nFilValor	+=  nTotValor  
			nFilDesc	+= nTotDesc
			nFilJurMul	+= nTotJurMul
			nFilCM		+= nTotCM
			nFilAbLiq	+= nTotAbLiq 
			nFilAbImp	+= nTotImp 		
			nFilBaixado += nTotBaixado
			nFilMovFin	+= nTotMovFin
			nFilComp	+= nTotComp
			nFilFat	    += nTotFat
		Enddo
	Endif	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprimir TOTAL por filial somente quan-³
	//³ do houver mais do que 1 filial.        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if mv_par17 == 1 .and. SM0->(Reccount()) > 1 .And. li != 80            
		@li,  0 PSAY "FILIAL : " +  cFilAnt + " - " + cFilNome
		@li,102 PSAY nFilOrig       PicTure tm(nFilOrig,15,nDecs)
		@li,118 PSAY nFilJurMul     PicTure tm(nFilJurMul,11,nDecs)
		@li,130 PSAY nFilCM         PicTure tm(nFilCM ,11,nDecs)
		@li,142 PSAY nFilDesc       PicTure tm(nFilDesc,11,nDecs)                                       
		@li,154 PSAY nFilAbLiq       PicTure tm(nFilAbLiq,11,nDecs)
		@li,166 PSAY nFilAbImp       PicTure tm(nFilAbImp,11,nDecs)
		@li,178 PSAY nFilValor      PicTure tm(nFilValor,15,nDecs)
		If nFilBaixado > 0 
			@li,195 PSAY STR0028 // "Baixados"
			@li,204 PSAY nFilBaixado    PicTure tm(nFilBaixado,15,nDecs)
		Endif
		If nFilMovFin > 0
			li++
			@li,195 PSAY STR0031   //"Mov Fin."
			@li,204 PSAY nFilMovFin   PicTure tm(nFilMovFin,15,nDecs)
		Endif
		If nFilComp > 0
			li++
			@li,195 PSAY STR0037  //"Compens."
			@li,204 PSAY nFilComp     PicTure tm(nFilComp,15,nDecs)
		Endif
		If nFilFat > 0
			li++
			@li,195 PSAY STR0076  //"Bx.Fatura"
			@li,204 PSAY nFilFat     PicTure tm(nFilFat,15,nDecs)
		Endif
		li+=2
		If Empty(cFilAnt)
			Exit
		Endif	

		nFilOrig:=nFilJurMul:=nFilCM:=nFilDesc:=nFilAbLiq:=nFilAbImp:=nFilValor:=0
		nFilBaixado:=nFilMovFin:=nFilComp:=nFilFat:=0
	Endif
	dbSelectArea("SM0")
	cCodUlt := SM0->M0_CODIGO
	cFilUlt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	dbSkip()
Enddo

If li != 80 .Or. nGerOrig <> 0
	// Imprime o cabecalho, caso nao tenha espaco suficiente para impressao do total geral
	If (li+4)>=60
		SM0->(MsSeek(cCodUlt+cFilUlt))		
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	Endif
	li+=2                                                                         
	@li,  0 PSAY OemToAnsi(STR0029)  //"Total Geral : "
	@li,102 PSAY nGerOrig       PicTure tm(nGerOrig,15,nDecs)
	@li,118 PSAY nGerJurMul     PicTure tm(nGerJurMul,11,nDecs)
	@li,130 PSAY nGerCM         PicTure tm(nGerCM ,11,nDecs)
	@li,142 PSAY nGerDesc       PicTure tm(nGerDesc,11,nDecs)
	@li,154 PSAY nGerAbLiq       PicTure tm(nGerAbLiq,11,nDecs)
	@li,166 PSAY nGerAbImp       PicTure tm(nGerAbImp,11,nDecs)	
	@li,178 PSAY nGerValor      PicTure tm(nGerValor,15,nDecs)
	If nGerBaixado > 0 
		@li,195 PSAY OemToAnsi(STR0028) // "Baixados"
		@li,204 PSAY nGerBaixado    PicTure tm(nGerBaixado,15,nDecs)
	Endif
	If nGerMovFin > 0
		li++
		@li,195 PSAY OemToAnsi(STR0031)   //"Mov Fin."
		@li,204 PSAY nGerMovFin   PicTure tm(nGerMovFin,15,nDecs)
	Endif
	If nGerComp > 0
		li++
		@li,195 PSAY STR0037  //"Compens."
		@li,204 PSAY nGerComp     PicTure tm(nGerComp,15,nDecs)
	Endif
	If nGerFat > 0
		li++
		@li,195 PSAY STR0076  //"Bx.Fatura"
		@li,204 PSAY nGerFat     PicTure tm(nGerFat,15,nDecs)
	Endif
	li++
	roda(cbcont,cbtxt,"G")
Endif

SM0->(dbgoto(nRecEmp))
//cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ) 
//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20180611]
cFilAnt := PadL(IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL ),2)
dbSelectArea("TRB")                                                                           
dbCloseArea()
Ferase(cNomArq1+GetDBExtension())
dbSelectArea("NEWSE5")
dbCloseArea()
If cNomeArq # Nil
	Ferase(cNomeArq+OrdBagExt())                                                           
Endif
dbSelectArea("SE5")
dbSetOrder(1)

If aReturn[5] == 1
	Set Printer to
	dbCommit()
	OurSpool(wnrel)                            
Endif

MS_FLUSH()

If MsgYesNo(OemToAnsi("Deseja gerar planilha Excel?"),"Geração da Planilha")
	If !ApOleClient( 'MsExcel' )
		MsgAlert("MsExcel nao instalado")
	Else
		If Len(aPlanilha) <> 0
			MsgRun("Gerando Planilha Excel", "Relaçao de baixa", {|| DlgToExcel ({ {"ARRAY", titulo+", emitido em "+Dtoc(dDataBase), aCabecalho, aPlanilha } }) })
		EndIf
	EndIf
EndIf

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Fr190TstCo³ Autor ³ Claudio D. de Souza   ³ Data ³ 22.08.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Testa as condicoes do registro do SE5 para permitir a impr.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ Fr190TstCon(cFilSe5)													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cFilSe5 - Filtro em CodBase										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINR190																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fr190TstCond(cFilSe5,lInterno)
Local lRet := .T.
Local nMoedaBco
Local lManual := .F.

If (Empty(NEWSE5->E5_TIPODOC) .And. mv_par16 == 1) .Or.;
	(Empty(NEWSE5->E5_NUMERO)  .And. mv_par16 == 1)
	lManual := .t.
EndIf

Do Case
Case !&(cFilSe5)           		// Verifico filtro CODEBASE tambem para TOP
	lRet := .F.
Case NEWSE5->E5_TIPODOC $ "DC/D2/JR/J2/TL/MT/M2/CM/C2" 
	lRet := .F.
Case NEWSE5->E5_SITUACA $ "C/E/X" .or. NEWSE5->E5_TIPODOC $ "TR#TE" .or.;
	(NEWSE5->E5_TIPODOC == "CD" .and. NEWSE5->E5_VENCTO > NEWSE5->E5_DATA)
	lRet := .F.
Case NEWSE5->E5_TIPODOC == "E2" .and. mv_par11 == 2
	lRet := .F.
Case Empty(NEWSE5->E5_TIPODOC) .and. mv_par16 == 2
	lRet := .F.
Case Empty(NEWSE5->E5_NUMERO) .and. mv_par16 == 2
	lRet := .F. 
Case mv_par16 == 2 .and. NEWSE5->E5_TIPODOC $ "CH" 
	lRet := .F. 
Case NEWSE5->E5_TIPODOC == "TR"
	lRet := .F.
Case mv_par11 = 1 .And. E5_TIPODOC $ "E2#CB"
	lRet := .F.
Case NEWSE5->E5_BANCO < mv_par03 .Or. NEWSE5->E5_BANCO > MV_PAR04
	lRet := .F.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se escolhido o parƒmetro "baixas normais", apenas imprime as baixas  ³
	//³que gerarem movimenta‡„o banc ria e as movimenta‡”es financeiras     ³
	//³manuais, se consideradas.                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Case mv_par14 == 1 .and. !MovBcoBx(NEWSE5->E5_MOTBX) .and. !lManual	
	lRet := .F.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Considera filtro do usuario                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Case !Empty(cFilterUser).and.!(&cFilterUser)
	lRet := .F.	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe estorno para esta baixa, somente no nivel de quebra ³
	//³ mais interno, para melhorar a performance 										³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Case	lInterno .And.;
		!Empty(NEWSE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ)) .And.;
	  	TemBxCanc(NEWSE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ))	
	lRet := .F.
EndCase

If lRet .And. NEWSE5->E5_RECPAG == "R"
	If ( NEWSE5->E5_TIPODOC = "RA" .And. mv_par35 = 2 ) .Or.;
		(NEWSE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG.and. mv_par24 == 2 .and.;
		NEWSE5->E5_MOTBX == "CMP")
		lRet := .F.
	EndIf
Endif
If lRet .And. NEWSE5->E5_RECPAG == "P"
	If ( NEWSE5->E5_TIPODOC = "PA" .And. mv_par35 = 2 ) .Or.;
		(NEWSE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG .and. mv_par24 == 2 .and.;
		 NEWSE5->E5_MOTBX == "CMP")
		lRet := .F.
	EndIf
Endif	

If lRet .And. mv_par25 == 2
	If ( cPaisLoc # "BRA".And.!Empty(NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA) ) .OR. ( FindFunction( "FXMultSld" ) .AND. FXMultSld() )
	   SA6->(DbSetOrder(1))
	   SA6->(MsSeek(xFilial()+NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA))
	   nMoedaBco	:=	Max(SA6->A6_MOEDA,1)
	ElseIf !Empty(NEWSE5->E5_ORDREC)
		nMoedaBco:= Val(NEWSE5->E5_MOEDA)
	Else
	   nMoedaBco	:=	1
	Endif
	If nMoedaBco <> mv_par12
		lRet := .F.
	EndIf
EndIf 

If lRet
	// Testar se considerar mov bancario e se o cancelamento da baixa tiver sido realizado, não imprimir o mov.						
	If MV_PAR16 == 1			   
		If Fr190MovCan(16,"NEWSE5")
		   lRet := .F.
		Endif   
	Endif
Endif

Return lRet     

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSX1³ Autor ³ Claudio D. de Souza   ³ Data ³ 26/09/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica as perguntas inclu¡ndo-as caso n„o existam        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ FINR190                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1()

Local aArea 	:= GetArea()
Local aHelpPor  := {}
Local aHelpEng  := {}
Local aHelpSpa  := {}

/*------------------ MV_PAR38 -----------------------------*/
PutSx1(	"FIN190",;
		"38",;
		"Cons. Nat. Aglutinadas?",;
		"Cons. Nat. Aglutinadas?",;
		"Cons. Nat. Aglutinadas?",;
		"mv_ch38",;
		"N",;
		01,;
		0,;
		0,;
		"C",;
		"",;
		"",;
		"",;
		"",;
		"mv_par38",;
		"Sim",;
		"Si",;
		"Yes",;
		"",;
		"Nao",;
		"No",;
		"No",;
		"",;
		"",;
		"",;
		"",;
		"",;
		"",;
		"",;
		"",;
		"",;
		, , , )        

aHelpPor := {	"SIM - apresentará as naturezas do "	,;
				"relatório em formato Sintético e "		,;
				"Aglutinado. Caso o título possua "		,;
				"rateio múltiplas naturezas, ele "		,;
				"será apresentado em uma só linha,"		,;
				"constando a sua natureza principal,"	,;
				"ou seja, do SE5."						,;
				"NÃO - apresentará as naturezas do"		,;
				"relatório em formato Sintético."		,;
				"Caso o título possua rateio "			,;
				"múltiplas naturezas, ele será"			,;
				"apresentado no formato do rateio"		,;
				"efetuado, ou seja, conforme consta"	,;
				"no SEV. Somente títulos que não "		,;
				"possuam múltiplas naturezas,"			,;
				"apresentação a informação"				,;
				"existente no SE5."						,;
				"ATENÇÃO: Independente da resposta"		,;
				"escolhida para essa pergunta, o"		,;
				"relatório sempre levará em "			,;
				"consideração, tanto a natureza"		,;
				"do SE5 (baixa do título) quanto"		,;
				"do SEV (múltiplas naturezas do"		,;
				"título), para filtragem das "			,;
				"naturezas."							}

PutHelp("P.FIN19038.",aHelpPor,aHelpEng,aHelpSpa,.T.)

/*------------------ MV_PAR39 -----------------------------*/
aHelpPor := {	"Indica qual o metodo utilizado para"	,;
				"filtragem das naturezas. Os metodos"	,;
				"abaixo se baseiam nos parametros "		,;
				"'Da Natureza' e 'Ate a Natureza' "		,;
				"para realização do filtro."			,;
				"METODOS UTILIZADOS:"					,;
				"-PADRÃO: Este metodo se baseia na"		,;
				" pergunta 'Cons. Nat. Aglutinadas?'"	,;
				" para aplicar a filtragem."			,;				
				"-NAT.PRINCIPAL: Este metodo se "		,;
				" baseia somente na natureza princi-"	,;
				" pal informada na baixa do titulo"		,;
				" (Tabela SE5) para aplicar a fil-"		,;
				" tragem por naturezas."				,;
				"-MULT.NATUREZAS:Este metodo se "		,;
				" baseia somente nas multiplas natu-"	,;
				" rezas geradas na baixa do titulo"		,;
				" (Tabela SEV)."						,;
				" Nesta opção as baixas serão"			,;
				" apresentadas no formato do rateio"	,;
				" efetuado, ou seja, conforme consta"	,;
				" na tabela SEV. "						}

aHelpEng := {}
aHelpSpa := {}

PutSX1("FIN190",;
 	   "39",;
 	   "Filtrar Natureza Por?",;
 	   "Filtrar Natureza Por?",;
 	   "Filtrar Natureza Por?",;
 	   "mv_chz"			,;
 	   "N"				,;
 	   1				,;
 	   0				,;
 	   1				,;
 	   "C"				,;
 	   ""				,;
 	   ""				,;
 	   ""				,;
 	   "S"				,;
 	   "mv_par39"		,;
 	   "Padrão"			,;
 	   "Padrão"			,;
 	   "Padrão"			,;
 	   ""				,;
 	   "Nat.Principal"	,;
 	   "Nat.Principal"	,;
 	   "Nat.Principal"	,;
 	   "Mult.Naturezas"	,;
 	   "Mult.Naturezas"	,;
 	   "Mult.Naturezas"	,;
 	   ""				,;
 	   ""				,;
 	   ""				,;
 	   ""				,;
 	   ""				,;
 	   ""				,;
 	   aHelpPor,;
 	   aHelpEng,;
 	   aHelpSpa)
///*------------------ MV_PAR40 -----------------------------*/
//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20160315] por padrao foi incluido o MV_PAR40 e MV_PAR41
/*------------------ MV_PAR42 -----------------------------*/
aHelpPor := {	"Digite codigo da Obra            "	,;
				"Deixando em branco serão listadas"	,;
				"todas as obras                   "	,;
				"    **** A T E N Ç Ã O *****     "	,;
				"Somente usuário autorizados      "	,;
				"poderão imprimir todas as obras  "		}

aHelpEng := {}
aHelpSpa := {}
PutSX1("FIN190",;
 	   "42",;
 	   "Somente Obra ?",;
 	   "Somente Obra ?",;
 	   "Somente Obra ?",;
 	   "mv_ch@"			,;
 	   "C"				,;
 	   9				,;
 	   0				,;
 	   1				,;
 	   "G"				,;
 	   ""				,;
 	   "CTT"			,;
 	   ""				,;
 	   "S"				,;
 	   "mv_par42"		,;
 	   ""       		,;
 	   ""      			,;
 	   ""        	    ,;
 	   ""				,;
 	   ""             	,;
 	   ""             	,;
 	   ""             	,;
 	   ""	            ,;
 	   ""           	,;
 	   ""              	,;
 	   ""				,;
 	   ""				,;
 	   ""				,;
 	   ""				,;
 	   ""				,;
 	   ""				,;
 	   aHelpPor,;
 	   aHelpEng,;
 	   aHelpSpa)
 	   
RestArea(aArea)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FR190MovCan³ Autor ³ Marcelo Celi Marques ³ Data ³ 05.10.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se o registro selecionado pertente a um titulo    ³±± 
±±³          ³ cuja baixa foi cancelada, mas, que gerou mov bancario      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FR190MovCan(nIndexSE5,_SE5)								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nIndexSE5 - Filtro provisório criado no inicio da rotina	  ³±± 
±±³          ³ E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ    >>	  ³±± 
±±³          ³ +E5_TIPODOC+E5_SEQ                                   	  ³±±
±±³          ³ 															  ³±± 
±±³          ³ _SE5 - Nome da tabela temporária do SE5 gerada       	  ³±±
±±³          ³ no inicio da rotina										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINR190/FINR199											  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FR190MovCan(nIndexSE5,_SE5)
	Local lRet := .F.
	Local aAreaSE5 := (_SE5)->(GetArea())
	If Empty((_SE5)->E5_MOTBX)
		dbSelectArea("SE5")
		dbSetOrder(nIndexSE5)
		If dbSeek((_SE5)->(E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ+"EC"+E5_SEQ))
			lRet := .T.
		Endif
		dbSelectArea(_SE5)
		RestArea(aAreaSE5)
	Endif	
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fbuscaobraºAutor  ³Microsiga           º Data ³  10/27/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna o codigo da obra.                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fbuscaobra(c_cart, c_chave)

	Local a_area	:= GetArea()
	Local c_Ret		:= '    '

	If c_cart = 'P'
		DbSelectArea('SE2')
		DbSetOrder(1) //E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, R_E_C_N_O_, D_E_L_E_T_
		If DbSeek(c_chave)
			c_Ret := SE2->E2_XCC
		EndIf                                                                                            
	Else
		DbSelectArea('SE1')
		DbSetOrder(1) //E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
		//If DbSeek(xFilial('SE1')+c_chave)
		If DbSeek(c_chave)
			c_Ret := SE1->E1_XCC
		EndIf
	EndIf

	RestArea(a_area)

Return c_Ret

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RF199_R3  ºAutor  ³Claudio D. de Souza º Data ³  28/08/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime o relatorio de baixas quando escolhida a ordem por º±±
±±º          ³ por natureza no FINR190, devido a implementacao de         º±±
±±º          ³ multiplas naturezas por baixa de titulos                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINR190                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RF199_R3(nGerOrig,	 nGerValor,	  nGerDesc,	  nGerJurMul, nGerCM,	 nGerAbLiq,;
			     nGerAbImp,	 nGerBaixado, nGerMovFin, nGerComp,	  nFilOrig,  nFilValor,;
			     nFilDesc,	 nFilJurMul,  nFilCM,	  nFilAbLiq,  nFilAbImp, nFilBaixado,;
			     nFilMovFin, nFilComp,	  lEnd,		  cCondicao,  cCond2,	 aColu,;
			     lContinua,	 cFilSE5,	  lAsTop,	  tamanho, nOrdem, nGerFat, nFilFat)

Local aAreaSe5	  := SE5->(GetArea())
Local aStru		  := SE5->(DbStruct())
Local aSaldo	  := {}
Local nValNat
Local nVBxNat
Local nJurNat
Local nAbtNat
Local nAbImpNat
Local nMulNat
Local nCmoNat
Local nDesNat
Local nTamCliFor := TamSx3("E5_CLIFOR")[1]
Local nValor	  := 0
Local nDesc		  := 0
Local nJuros	  := 0
Local nAbat 	  := 0
Local nCM		  := 0
Local nMulta	  := 0
Local nVlr 		  := 0
Local nVlMovFin  := 0
Local cArqTmp
Local nTotOrig   := 0
Local nTotValor  := 0
Local nTotDesc   := 0
Local nTotJurMul := 0
Local nTotCm 	  := 0
Local nTotMulta  := 0
Local nTotAbat   := 0
Local nTotImp 	  := 0
Local nTotBaixado := 0
Local nTotMovFin  := 0
Local nTotComp    := 0
Local nTotFat   := 0
Local nTotAbImp   := 0
Local cAnterior
Local cCliFor190  := ""
Local cCliFor
Local nDecs	  	   := GetMv("MV_CENT"+(IIF(mv_par12 > 1 , STR(mv_par12,1),"")))
Local nMoedaBco   := 1
Local cCarteira
Local lManual 	   :=.F.
Local cBanco
Local cNatureza
Local nCT		   := 0
Local dDigit
// Local cLoja
Local lBxTit	   :=.F.
Local cHistorico
Local nRecSe5 	   := 0
Local dDtMovFin
Local cRecPag
Local cMotBaixa   := CRIAVAR("E5_MOTBX")
Local cFilTrb
Local cChave
Local cFilOrig
Local nX 		   := 0
Local nY 		   := 0
Local lTemTit	   :=.T.
Local lAchouEmp := .T.                                
Local lAchouEst := .F.                                
Local nTamEH    := TamSx3("EH_NUMERO")[1]
Local nTamEI    := TamSx3("EI_NUMERO")[1]+TamSx3("EI_REVISAO")[1]+TamSx3("EI_SEQ")[1]
Local lAjuPar15 := Len(AllTrim(mv_par15))==Len(mv_par15)
Local aImpresso := {}
Local nAscan
Local nRecno  
Local	nSavOrd 
Local lAchou
Local cCondLaco

Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )

Local lUltBaixa := .F.
Local cChaveSE1 := ""
Local cChaveSE5 := ""
Local cSeqSE5 	:= ""
Local cQuery 	:= ""
Local nI
Local cCampos := ""
Local lTemSEV := .F.

//Controla o Pis Cofins e Csll na baixa (1-Retem PCC na Baixa ou 2-Retem PCC na Emissão(default))
Local lPccBxCr	:= If (FindFunction("FPccBxCr"),FPccBxCr(),.F.)
Local nPccBxCr := 0
Local nPccBxNat := 0
	
//Campos adicionais para o arquivo temporario
//E5_VALTIT = Valor do titulo
//E5_VLABLIQ = Valor dos abatimentos
//E5_VLABIMP = Valos dos abatimentos de impostos
AADD(aStru,{"E5_VALTIT","N",17,2})
AADD(aStru,{"E5_VLMOVFI","N",17,2})
AADD(aStru,{"E5_VLABLIQ","N",17,2})
AADD(aStru,{"E5_VLABIMP","N",17,2})
AADD(aStru,{"E5_XCC"    ,"C",10,0})

cArqTmp := CriaTrab(aStru,.T.) //  Cria um arquivo com a mesma estrutura do SE1
dbUseArea(.T.,__LocalDriver,cArqTmp,"cArqTmp",.T.)

If FunName() == "FINR190"
	IndRegua( "cArqTmp",cArqTmp,cChaveInterFun)  //"Selecionando Registros..."
Else
	IndRegua( "cArqTmp",cArqTmp,"E5_FILIAL+E5_NATUREZ+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA")  //"Selecionando Registros..."
Endif
                                                                     
DbSelectArea("NEWSE5")

li := 80

// Gera o arquivo temporario por natureza
While NEWSE5->(!Eof()) .And. NEWSE5->E5_FILIAL == cFilAnt .And. &cCondicao .and. lContinua
	If lEnd
		@PROW()+1,001 PSAY OemToAnsi(STR0021)  //"CANCELADO PELO OPERADOR"
		lContinua:=.F.
		Exit
	EndIf
	
	IncRegua()
	DbSelectArea("NEWSE5")
	// Testa condicoes de filtro
	If !Fr190TstCond(cFilSe5,.F.)                                        
		NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
		Loop
	Endif
	
	If (NEWSE5->E5_RECPAG == "R" .and. ! (NEWSE5->E5_TIPO $ "PA /"+MV_CPNEG )) .or. ;	//Titulo normal
		(NEWSE5->E5_RECPAG == "P" .and.   (NEWSE5->E5_TIPO $ "RA /"+MV_CRNEG )) 	//Adiantamento
		cCarteira := "R"
	Else
		cCarteira := "P"
	Endif
	
	dbSelectArea("NEWSE5")
	cAnterior 	:= &cCond2
	nTotValor	:= 0
	nTotDesc	   := 0
	nTotJurMul	:= 0
	nTotMulta	:= 0
	nTotCM		:= 0
	nCT			:= 0
	nTotOrig	:= 0
	nTotBaixado	:= 0          
	nTotAbat  	:= 0
	nTotImp  	:= 0	
	nTotMovFin	:= 0
	nTotComp	:= 0
	nTotFat		:= 0
	
	While NEWSE5->(!EOF()) .and. &cCond2=cAnterior .and. NEWSE5->E5_FILIAL=cFilAnt .and. lContinua
		
		lManual := .f.
		lTemTit:=.T.
		dbSelectArea("NEWSE5")
		
		IF lEnd
			@PROW()+1,001 PSAY OemToAnsi(STR0021)  //"CANCELADO PELO OPERADOR"
			lContinua:=.F.
			Exit
		EndIF
		
		If (Empty(NEWSE5->E5_TIPODOC) .And. mv_par16 == 1) .Or.;
			(Empty(NEWSE5->E5_NUMERO)  .And. mv_par16 == 1)
			lManual := .t.
		EndIf
		
		// Testa condicoes de filtro
		If !Fr190TstCond(cFilSe5,.T.)
			dbSelectArea("NEWSE5")
			NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
			Loop
		Endif
      

		// testa mv_par37 (Imp. mov. cheque aglutinado?Cheque/Baixa/Ambos)		
		If ((mv_par37 == 1) .And. ;
		   ((NEWSE5->E5_TIPODOC == "VL") .Or. (NEWSE5->E5_TIPODOC == "BA"))) //somente cheques

			nRecno  := SE5->(Recno())
			nSavOrd := SE5->(INDEXORD())
			
			SE5->(dbSetOrder(11))
			SE5->(MsSeek(cFilAnt+NEWSE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)))					
			cChave := SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)
			lAchou := .F.

			// Procura o cheque aglutinado, se encontrar despreza o movimento bancario
			WHILE SE5->(!EOF()) .And. SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)	== cChave
				If SE5->E5_TIPODOC == "CH"
					lAchou := .T.
					Exit
				Endif	
				SE5->(dbSkip())
			Enddo
			
			SE5->(DbSetOrder(nSavOrd))
			SE5->(dbGoTo(nRecno))
			// Achou cheque aglutinado para a baixa, despreza o registro
			If lAchou
				NEWSE5->(dbSkip())
				Loop
			Endif

		ElseIf ((mv_par37 == 2) .And. (NEWSE5->E5_TIPODOC == "CH")) //somente baixas

			nRecno  := SE5->(Recno())
			nSavOrd := SE5->(INDEXORD())
			
			SE5->(dbSetOrder(11))
			SE5->(MsSeek(cFilAnt+NEWSE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)))					
			cChave := SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)
			lAchou := .F.

			// Procura a baixa aglutinada, se encontrar despreza o movimento bancario
			WHILE SE5->(!EOF()) .And. SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)	== cChave
				If SE5->E5_TIPODOC $ "BA#VL"
					lAchou := .T.
					Exit
				Endif	
				SE5->(dbSkip())
			Enddo 
			
			SE5->(DbSetOrder(nSavOrd))
			SE5->(dbGoTo(nRecno))
			// Achou cheque aglutinado para a baixa, despreza o registro
			
			If lAchou
				NEWSE5->(dbSkip())
				Loop
			Endif
		Endif	

		cFil_NEWSE5	:= NEWSE5->E5_FILIAL 
		cNumero    	:= NEWSE5->E5_NUMERO
		cPrefixo   	:= NEWSE5->E5_PREFIXO
		cParcela   	:= NEWSE5->E5_PARCELA
		dBaixa     	:= NEWSE5->E5_DATA
		cBanco     	:= NEWSE5->E5_BANCO
		cNatureza  	:= NEWSE5->E5_NATUREZ
		cCliFor    	:= NEWSE5->E5_BENEF
		cLoja      	:= NEWSE5->E5_LOJA
		cSeq       	:= NEWSE5->E5_SEQ
		cNumCheq   	:= NEWSE5->E5_NUMCHEQ
		cRecPag	 	:= NEWSE5->E5_RECPAG
		cMotBaixa	:= NEWSE5->E5_MOTBX
		cCheque    	:= NEWSE5->E5_NUMCHEQ
		cTipo      	:= NEWSE5->E5_TIPO
		cFornece   	:= NEWSE5->E5_CLIFOR
		cLoja      	:= NEWSE5->E5_LOJA
		dDigit     	:= NEWSE5->E5_DTDIGIT
		lBxTit	  	:= .F.
		cFilorig    := NEWSE5->E5_FILORIG
               
        //incluido bloco abaixo [Mauro Nagata, Actual Trend, 27/06/2012]
		c_obra := fbuscaobra(cCarteira, cFil_NEWSE5+cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja )
		//lIPCCPr :=  (c_obra=MV_PAR40)   
		//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20160315] por padrao foi incluido o MV_PAR40 e MV_PAR41
		lIPCCPr :=  (c_obra=MV_PAR42)   
		lIPCCEZ := .F.
		//fim bloco [Mauro Nagata, Actual Trend, 27/06/2012]
		
		/*
		//excluido bloco abaixo [Mauro Nagata, Actual Trend, 22/06/2012]
		If !Empty(MV_PAR40)                      
			If c_obra <> AllTrim(MV_PAR40) 
				NEWSE5->(DbSkip())
				Loop                                                            
			EndIf
		EndIf
		*/

		If (NEWSE5->E5_RECPAG == "R" .and. ! (NEWSE5->E5_TIPO $ "PA /"+MV_CPNEG )) .or. ;	//Titulo normal
			(NEWSE5->E5_RECPAG == "P" .and.   (NEWSE5->E5_TIPO $ "RA /"+MV_CRNEG )) 	//Adiantamento
			dbSelectArea("SE1")
			dbSetOrder(1)
			lBxTit := MsSeek(cFil_NewSE5+cPrefixo+cNumero+cParcela+cTipo)
			If !lBxTit
				lBxTit := dbSeek(NEWSE5->E5_FILORIG+cPrefixo+cNumero+cParcela+cTipo)
			Endif
			cCarteira := "R"
			dDtMovFin := IIF (lManual,CTOD("//"), DataValida(SE1->E1_VENCTO,.T.))
			While SE1->(!Eof()) .and. SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO==cPrefixo+cNumero+cParcela+cTipo
				If SE1->E1_CLIENTE == cFornece .And. SE1->E1_LOJA == cLoja	// Cliente igual, Ok
					Exit
				Endif
				SE1->( dbSkip() )
			EndDo
			If !SE1->(EOF()) .And. mv_par11 == 1 .and. !lManual .and.  ;
				(NEWSE5->E5_RECPAG == "R" .and. !(NEWSE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG))
				If SE5->(FieldPos("E5_SITCOB")) > 0
					cExp := "NEWSE5->E5_SITCOB"
				Else
					cExp := "SE1->E1_SITUACA"
				Endif 
				
				If mv_par36 == 2 
					mv_par15:=AllTrim(mv_par15)
				EndIf
				
				If (NEWSE5->E5_RECPAG == "R") .And. lAjuPar15
					mv_par15  += " "
				Endif

				cExp += " $ mv_par15" 
				If !(&cExp)
					dbSelectArea("NEWSE5")
					NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
					Loop
				Endif
			Endif

			cCond3:="E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DtoS(E5_DATA)+E5_SEQ+E5_NUMCHEQ==cPrefixo+cNumero+cParcela+cTipo+DtoS(dBaixa)+cSeq+cNumCheq"
			nDesc := nJuros := nValor := nMulta := nCM := nVlMovFin := 0
		Else
			dbSelectArea("SE2")
			DbSetOrder(1)
			cCarteira := "P"
			lBxTit := MsSeek(cFil_NewSE5+cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja)
			If !lBxTit
				lBxTit := dbSeek(NEWSE5->E5_FILORIG+cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja)
			Endif
			dDtMovFin := IIF(lManual,CTOD("//"),DataValida(SE2->E2_VENCTO,.T.))
			cCond3:="E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+DtoS(E5_DATA)+E5_SEQ+E5_NUMCHEQ==cPrefixo+cNumero+cParcela+cTipo+cFornece+DtoS(dBaixa)+cSeq+cNumCheq"
			nDesc := nJuros := nValor := nMulta := nCM := nVlMovFin := 0
			cCheque    := Iif(Empty(NEWSE5->E5_NUMCHEQ),SE2->E2_NUMBCO,NEWSE5->E5_NUMCHEQ)
		Endif
		dbSelectArea("NEWSE5")
		IncRegua()
		cHistorico := Space(40)
		While NEWSE5->( !Eof()) .and. &cCond3 .and. lContinua .And. NEWSE5->E5_FILIAL==cFilAnt
			
			cCampos := ""
			IncRegua()
			dbSelectArea("NEWSE5")
			
			lAchouEmp := .T.
			lAchouEst := .F.
			
			IF lEnd
				@PROW()+1,001 PSAY OemToAnsi(STR0021)  //"CANCELADO PELO OPERADOR"
				lContinua:=.F.
				Exit
			EndIF
			
			// Testa condicoes de filtro
			If !Fr190TstCond(cFilSe5,.T.)
				dbSelectArea("NEWSE5")
				NEWSE5->(dbSkip())		      // filtro de registros desnecessarios
				Loop
			Endif
			
			If NEWSE5->E5_SITUACA $ "C/E/X"
				dbSelectArea("NEWSE5")
				NEWSE5->( dbSkip() )
				Loop
			EndIF
			
			If NEWSE5->E5_LOJA != cLoja
				Exit
			Endif
			
			If NEWSE5->E5_FILORIG < mv_par33 .or. NEWSE5->E5_FILORIG > mv_par34
				dbSelectArea("NEWSE5")
				NEWSE5->( dbSkip() )
				Loop
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Nao imprime os registros de emprestimos excluidos ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ					
			If NEWSE5->E5_TIPODOC == "EP"
				aAreaSE5 := NEWSE5->(GetArea())	
				dbSelectArea("SEH")
				dbSetOrder(1)
				lAchouEmp := MsSeek(xFilial("SEH")+Substr(NEWSE5->E5_DOCUMEN,1,nTamEH))
				RestArea(aAreaSE5)
				If !lAchouEmp
					NEWSE5->(dbSkip())
					Loop
				EndIf
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Nao imprime os registros de pagamento de emprestimos estornados ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ					
			If NEWSE5->E5_TIPODOC == "PE"
				aAreaSE5 := NEWSE5->(GetArea())	
				dbSelectArea("SEI")
				dbSetOrder(1)
				If	MsSeek(xFilial("SEI")+"EMP"+Substr(NEWSE5->E5_DOCUMEN,1,nTamEI))
					If SEI->EI_STATUS == "C"
						lAchouEst := .T.
					EndIf
				EndIf
				RestArea(aAreaSE5)
				If lAchouEst
					NEWSE5->(dbSkip())
					Loop
				EndIf
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica o vencto do Titulo ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cFilTrb := If(mv_par11==1,"SE1","SE2")
			If (cFilTrb)->(!Eof()) .And.;
				((cFilTrb)->&(Right(cFilTrb,2)+"_VENCREA") < mv_par31 .Or. (!Empty(mv_par32) .And. (cFilTrb)->&(Right(cFilTrb,2)+"_VENCREA") > mv_par32))
				dbSelectArea("NEWSE5")
				NEWSE5->(dbSkip())
				Loop
			Endif
			
			dBaixa     	:= NEWSE5->E5_DATA
			cBanco     	:= NEWSE5->E5_BANCO
			cNatureza  	:= NEWSE5->E5_NATUREZ
			cCliFor    	:= NEWSE5->E5_BENEF
			cSeq       	:= NEWSE5->E5_SEQ
			cNumCheq   	:= NEWSE5->E5_NUMCHEQ
			cRecPag		:= NEWSE5->E5_RECPAG
			cMotBaixa	:= NEWSE5->E5_MOTBX
			cTipo190		:= NEWSE5->E5_TIPO
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Obter moeda da conta no Banco.                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If cPaisLoc	# "BRA".And.!Empty(NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA)
				SA6->(DbSetOrder(1))
				SA6->(MsSeek(xFilial()+NEWSE5->E5_BANCO+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA))
				nMoedaBco	:=	Max(SA6->A6_MOEDA,1)
			Else
				nMoedaBco	:=	1
			Endif
			
			If !Empty(NEWSE5->E5_NUMERO)
				If (NEWSE5->E5_RECPAG == "R" .and. !(NEWSE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG)) .or. ;
					(NEWSE5->E5_RECPAG == "P" .and. NEWSE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG)
					dbSelectArea( "SA1")
					dbSetOrder(1)
					If MsSeek(xFilial("SA1")+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
						cCliFor := Iif(mv_par30==1,SA1->A1_NREDUZ,SA1->A1_NOME)
					EndIF
				Else
					dbSelectArea( "SA2")
					dbSetOrder(1)
					If MSSeek(xFilial("SA2")+NEWSE5->E5_CLIFOR+NEWSE5->E5_LOJA)
						cCliFor := Iif(mv_par30==1,SA2->A2_NREDUZ,SA2->A2_NOME)
					EndIF
				EndIf
			EndIf
			
			dbSelectArea("SM2")
			dbSetOrder(1)
			dbSeek(NEWSE5->E5_DATA)
			dbSelectArea("NEWSE5")
			nRecSe5:=If(lAsTop,NEWSE5->SE5RECNO,Recno())
			
			nDesc+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLDESCO,Round(xMoeda(NEWSE5->E5_VLDESCO,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",NEWSE5->E5_TXMOEDA,0)),nDecs+1))
			nJuros+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLJUROS,Round(xMoeda(NEWSE5->E5_VLJUROS,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",NEWSE5->E5_TXMOEDA,0)),nDecs+1))
			nMulta+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLMULTA,Round(xMoeda(NEWSE5->E5_VLMULTA,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",NEWSE5->E5_TXMOEDA,0)),nDecs+1))
			nCM+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VLCORRE,Round(xMoeda(NEWSE5->E5_VLCORRE,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",NEWSE5->E5_TXMOEDA,0)),nDecs+1))

			If lPccBaixa .and. Empty(NEWSE5->E5_PRETPIS) .And. Empty(NEWSE5->E5_PRETCOF) .And. Empty(NEWSE5->E5_PRETCSL)
				nTotAbImp+=(NEWSE5->E5_VRETPIS)+(NEWSE5->E5_VRETCOF)+(NEWSE5->E5_VRETCSL)
			Endif				

			If NEWSE5->E5_TIPODOC $ "VL/V2/BA/RA/PA/CP"
				cHistorico := NEWSE5->E5_HISTOR
				nValor+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VALOR,Round(xMoeda(NEWSE5->E5_VALOR,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",NEWSE5->E5_TXMOEDA,0)),nDecs+1))

				//Pcc Baixa CR
				If cCarteira == "R" .and. lPccBxCr .and. cPaisLoc == "BRA"
					If Empty(NEWSE5->E5_PRETPIS) 
						nPccBxCr += Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VRETPIS,Round(xMoeda(NEWSE5->E5_VRETPIS,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,NEWSE5->E5_TXMOEDA),nDecs+1))
					Endif						
					If Empty(NEWSE5->E5_PRETCOF) 
						nPccBxCr += Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VRETCOF,Round(xMoeda(NEWSE5->E5_VRETCOF,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,NEWSE5->E5_TXMOEDA),nDecs+1))
					Endif						
					If Empty(NEWSE5->E5_PRETCSL) 
						nPccBxCr += Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VRETCSL,Round(xMoeda(NEWSE5->E5_VRETCSL,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,NEWSE5->E5_TXMOEDA),nDecs+1))
					Endif											
				Endif

			Else
				nVlMovFin+=Iif(mv_par12==1.And.nMoedaBco==1,NEWSE5->E5_VALOR,Round(xMoeda(NEWSE5->E5_VALOR,nMoedaBco,mv_par12,NEWSE5->E5_DATA,nDecs+1,,If(cPaisLoc=="BRA",NEWSE5->E5_TXMOEDA,0)),nDecs+1))
				cHistorico := Iif(Empty(NEWSE5->E5_HISTOR),"MOV FIN MANUAL",NEWSE5->E5_HISTOR)
				cNatureza  	:= NEWSE5->E5_NATUREZ
			Endif
			dbSkip()
			If lManual		// forca a saida do looping se for mov manual
				Exit
			Endif
		EndDO
		
		If (nDesc+nValor+nJuros+nCM+nMulta+nVlMovFin) > 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ C lculo do Abatimento        ³                                
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If cCarteira == "R" .and. !lManual
				dbSelectArea("SE1")
				nRecno := Recno()
				nTotAbImp := 0
				nAbat := SumAbatRec(cPrefixo,cNumero,cParcela,SE1->E1_MOEDA,"V",dBaixa,@nTotAbImp) 
				nAbatLiq := nAbat - nTotAbImp					
				aAreaSE1 := SE1->(GetArea())
				dbSelectArea("SE5")
				dbSetOrder(7)
				cChaveSE1 := SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)
				SE5->(MsSeek(cFilAnt+cChaveSE1))					
              
				cSeqSE5 := SE5->E5_SEQ
                     
				While SE5->(!EOF()) .And. cChaveSE1 == SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
					If SE5->E5_SEQ > cSeqSE5
						cSeqSE5 := SE5->E5_SEQ
					Endif	
					SE5->(dbSkip())
				Enddo
                                     
				SE5->(MsSeek(cFilAnt+cChaveSE1+cSeqSE5))
				cChaveSE5 := cPrefixo+cNumero+cParcela+cTipo+cFornece+cLoja+cSeq							

				If cChaveSE5 == SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ) .And.;
					Empty(SE1->E1_SALDO)
					lUltBaixa := .T.
				EndIf

				RestArea(aAreaSE1)
				
				If Empty(nVlMovFin)
				 	If !lUltBaixa
						nTotAbImp := (nValor * nTotAbImp ) / SE1->E1_VALOR
					Else
						nTotAbImp := ((nValor + nTotAbImp) * nTotAbImp ) / SE1->E1_VALOR
					EndIf
				Else
				 	If !lUltBaixa
						nTotAbImp := (nVlMovFin * nTotAbImp ) / SE1->E1_VALOR
					Else
						nTotAbImp := ((nVlMovFin + nTotAbImp) * nTotAbImp ) / SE1->E1_VALOR
					EndIf
				Endif	 
				lUltBaixa := .F.							
				dbSelectArea("SE1")
				dbGoTo(nRecno)
				cCliFor190 := SE1->E1_CLIENTE+SE1->E1_LOJA
				nVlr:= SE1->E1_VLCRUZ
				If mv_par12 > 1
					nVlr := Round(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,mv_par12,SE1->E1_EMISSAO,nDecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),nDesc+1)
				EndIF
				If mv_par13 == 1  // Utilizar o Hist¢rico da Baixa ou Emiss„o
					cHistorico := Iif(Empty(cHistorico), SE1->E1_HIST, cHistorico )
				Else
					cHistorico := Iif(Empty(SE1->E1_HIST), cHistorico, SE1->E1_HIST )
				Endif
				dbSelectArea("SE5")
				dbgoto(nRecSe5)				
			Elseif !lManual
				dbSelectArea("SE2")
				nRecno := Recno()
				nAbat :=	SomaAbat(cPrefixo,cNumero,cParcela,"P",mv_par12,,cFornece,cLoja)
				nAbatLiq := nAbat	
				dbSelectArea("SE2")
				dbGoTo(nRecno)
				cCliFor190 := SE2->E2_FORNECE+SE2->E2_LOJA
				nVlr:= SE2->E2_VLCRUZ
				If mv_par12 > 1
					nVlr := Round(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par12,SE2->E2_EMISSAO,nDecs+1,If(cPaisLoc=="BRA",SE2->E2_TXMOEDA,0)),nDecs+1)
				Endif
				If mv_par13 == 1  // Utilizar o Hist¢rico da Baixa ou Emiss„o
					cHistorico := Iif(Empty(cHistorico), SE2->E2_HIST, cHistorico )
				Else
					cHistorico := Iif(Empty(SE2->E2_HIST), cHistorico, SE2->E2_HIST )
				Endif
				dbSelectArea("SE5")
				dbgoto(nRecSe5)
			Else
				nAbatLiq := 0
				lTemTit:=.F.
				dbSelectArea("SE5")   
				dbgoto(nRecSe5)			
				nVlr := Iif(mv_par12==1.And.nMoedaBco==1,SE5->E5_VALOR,Round(xMoeda(SE5->E5_VALOR,nMoedaBco,mv_par12,SE5->E5_DATA,nDecs+1,If(cPaisLoc=="BRA",SE5->E5_TXMOEDA,0)),nDecs+1))
			EndIF
			
			//Calcula a multnat para cada baixa, se houver
			lMultNat := .F.
			If !lManual
				dbSelectArea("SEV")
				dbSetOrder(2)
				cChave:= xFilial("SEV")+cPrefixo+cNumero+cParcela+cTipo+cCliFor190+"2"+cSeq
				#IFDEF TOP            
					lTemSEV := .F.				
					cQuery := ""
					aEval(DbStruct(),{|e| cCampos += ","+AllTrim(e[1])})
					If SEV->(dbSeek(cChave))
						lMultNat := .T.
						// Obtem os registros a serem processados
						cQuery := "SELECT " +SubStr(cCampos,2)
						cQuery += "FROM " + RetSqlName("SEV")+" SEV "
						cQuery += "WHERE EV_FILIAL = '" + SubStr(cChave,1,Len(xFilial("SEV"))) + "' AND "
						cQuery +=       "EV_PREFIXO= '" + cPrefixo   + "' AND "
						cQuery += 		"EV_NUM    = '" + cNumero    + "' AND "
						cQuery += 		"EV_PARCELA= '" + cParcela   + "' AND "
						cQuery += 		"EV_TIPO   = '" + cTipo      + "' AND "
						cQuery += 		"EV_CLIFOR = '" + SubStr(cCliFor190,1,TamSx3("EV_CLIFOR")[1]) + "' AND "
						cQuery += 		"EV_LOJA   = '" + SubStr(cCliFor190,TamSx3("EV_CLIFOR")[1]+1,TamSx3("EV_LOJA")[1]) + "' AND "
						cQuery += 		"EV_IDENT  = '2' AND "						
						cQuery += 		"EV_SEQ    = '" + cSeq + "' AND "
						cQuery += 		"D_E_L_E_T_ = ''"
					Else
						// Pesquisa pela distribuicao mult. natureza na emissao, sem a sequencia da baixa
						cChave:= xFilial("SEV")+cPrefixo+cNumero+cParcela+cTipo+cCliFor190+"1"
						If SEV->(dbSeek(cChave))
							lMultNat := .T.
							cQuery := "SELECT " +SubStr(cCampos,2)
							cQuery += "FROM " + RetSqlName("SEV")+" SEV "
							cQuery += "WHERE EV_FILIAL = '" + SubStr(cChave,1,Len(xFilial("SEV"))) + "' AND "
							cQuery +=       "EV_PREFIXO= '" + cPrefixo   + "' AND "
							cQuery += 		"EV_NUM    = '" + cNumero    + "' AND "
							cQuery += 		"EV_PARCELA= '" + cParcela   + "' AND "
							cQuery += 		"EV_TIPO   = '" + cTipo      + "' AND "
							cQuery += 		"EV_CLIFOR = '" + SubStr(cCliFor190,1,TamSx3("EV_CLIFOR")[1]) + "' AND "
							cQuery += 		"EV_LOJA   = '" + SubStr(cCliFor190,TamSx3("EV_CLIFOR")[1]+1,TamSx3("EV_LOJA")[1]) + "' AND "
							cQuery += 		"EV_IDENT  = '1' AND "
							cQuery += 		"D_E_L_E_T_ = ''"
						Endif
					Endif	
					If AllTrim(cQuery) <> ""
						cQuery := ChangeQuery(cQuery)
						dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TMPSEV", .F., .T.)
						For nI := 1 TO LEN(aStru)
							If aStru[nI][2] != "C"
								TCSetField("TMPSEV", aStru[nI][1], aStru[nI][2], aStru[nI][3], aStru[nI][4])
							EndIf
						Next
						TMPSEV->(DbGoTop())
						lTemSEV := .T.
					EndIf
                    
					If lMultNat .and. lTemSEV
						aSaldo := {}
						While TMPSEV->(!Eof()) 
							If mv_par39 == 3
								If TMPSEV->EV_NATUREZ < mv_par05 .Or. TMPSEV->EV_NATUREZ > mv_par06
									TMPSEV->(DbSkip())
									Loop
								EndIf           
							EndIf
							If TMPSEV->EV_RATEICC = '2'														
								If TMPSEV->EV_RECPAG == cCarteira .AND. !(TMPSEV->EV_SITUACA $ "X/E")
									//nValNat		:= nValor    * TMPSEV->EV_PERC
									//substituida a linha acima pela abaixo [Mauro Nagata, Actual Trend, 22/06/2012] 
									nValNat		:= nValor                                                           
									
									//incluido bloco abaixo [Mauro Nagata, Actual Trend, 27/06/2012] 
									//If !Empty(MV_PAR40)                                             
									//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20160315] por padrao foi incluido o MV_PAR40 e MV_PAR41
									If !Empty(MV_PAR42)                                             
								      //If c_obra <> AllTrim(MV_PAR40) 
								      //substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20160315] por padrao foi incluido o MV_PAR40 e MV_PAR41
								      If c_obra <> AllTrim(MV_PAR42) 
									     TMPSEV->(DbSkip())
										 Loop                                                            
								       EndIf
								    EndIf    
								    //fim bloco [Mauro Nagata, Actual Trend, 27/06/2012] 
								   								   
									nVBxNat		:= nValor    * TMPSEV->EV_PERC
									nJurNat		:= nJuros    * TMPSEV->EV_PERC
									nAbtNat		:= nAbatLiq  * TMPSEV->EV_PERC
									nAbImpNat	:= nTotAbImp * TMPSEV->EV_PERC
									nMulNat		:= nMulta    * TMPSEV->EV_PERC
									nCmoNat		:= nCm       * TMPSEV->EV_PERC
									nDesNat		:= nDesc     * TMPSEV->EV_PERC
									nPccBxNat	:= nPccBxCr  * TMPSEV->EV_PERC  				//Pcc Baixa CR
									AADD(aSaldo,{TMPSEV->EV_NATUREZ,nValNat,nVBxNat,nJurNat,nMulNat,nDesNat,nCmoNat,nAbtNat,nAbImpNat,nVlMovFin,SE5->E5_NATUREZ,nPccBxNat,c_Obra})
								Endif         
							// Cintia
							Else
								DbSelectArea('SEZ')
								SEZ->(DbSetOrder(1)) //EZ_FILIAL, EZ_PREFIXO, EZ_NUM, EZ_PARCELA, EZ_TIPO, EZ_CLIFOR, EZ_LOJA, EZ_NATUREZ, EZ_CCUSTO, R_E_C_N_O_, D_E_L_E_T_
								If DbSeek(TMPSEV->(EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA+EV_NATUREZ))
									While SEZ->(EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ) = TMPSEV->(EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA+EV_NATUREZ)
										c_obra := SEZ->EZ_CCUSTO                                    
										
										//incluido bloco abaixo [Mauro Nagata, Actual Trend, 27/06/2012] 
										//If !Empty(MV_PAR40)                      
										//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20160315] por padrao foi incluido o MV_PAR40 e MV_PAR41
										If !Empty(MV_PAR42)                      
											//If c_obra <> AllTrim(MV_PAR40)     
											//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20160315] por padrao foi incluido o MV_PAR40 e MV_PAR41
											If c_obra <> AllTrim(MV_PAR42) 
												SEZ->(DbSkip())
												Loop                                                            
											EndIf
										EndIf    
										//lIPCCEZ := .T.  //existe rateio para a Obra igual ao MV_PAR40
										//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20160315] por padrao foi incluido o MV_PAR40 e MV_PAR41
										lIPCCEZ := .T.  //existe rateio para a Obra igual ao MV_PAR42
										//fim bloco [Mauro Nagata, Actual Trend, 27/06/2012] 
										
										
									
										//nValNat		:= nValor   * TMPSEV->EV_PERC * SEZ->EZ_PERC
										//substituida a linha acima pela abaixo [Mauro Nagata, Actual Trend, 22/06/2012]
										nValNat		:= nValor   
										nVBxNat		:= nValor   * TMPSEV->EV_PERC * SEZ->EZ_PERC
										nJurNat		:= nJuros   * TMPSEV->EV_PERC * SEZ->EZ_PERC
										nAbtNat		:= nAbatLiq * TMPSEV->EV_PERC * SEZ->EZ_PERC
										nAbImpNat	:= nTotAbImp* TMPSEV->EV_PERC
										nMulNat		:= nMulta   * TMPSEV->EV_PERC * SEZ->EZ_PERC
										nCmoNat		:= nCm      * TMPSEV->EV_PERC * SEZ->EZ_PERC
										nDesNat		:= nDesc    * TMPSEV->EV_PERC * SEZ->EZ_PERC           
										nPccBxNat	:= nPccBxCr * TMPSEV->EV_PERC  				//Pcc Baixa CR
										AADD(aSaldo,{TMPSEV->EV_NATUREZ,nValNat,nVBxNat,nJurNat,nMulNat,nDesNat,nCmoNat,nAbtNat,nAbImpNat,nVlMovFin,SE5->E5_NATUREZ,nPccBxNat,SEZ->EZ_CCUSTO})
		
										SEZ->(DbSkip())
									EndDo
								Else         
								   //incluido bloco abaixo [Mauro Nagata, Actual Trend, 27/06/2012] 
								   //If !Empty(MV_PAR40)                                             
								   //substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20160315] por padrao foi incluido o MV_PAR40 e MV_PAR41
								   If !Empty(MV_PAR42)                                             
								      //If c_obra <> AllTrim(MV_PAR40)                                                                                        
								      //substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20160315] por padrao foi incluido o MV_PAR40 e MV_PAR41
								      If c_obra <> AllTrim(MV_PAR42)                                                                                        
									     TMPSEV->(DbSkip())
										 Loop                                                            
								       EndIf
								   EndIf
								   //fim bloco [Mauro Nagata, Actual Trend, 27/06/2012] 
								
									//nValNat		:= nValor   * TMPSEV->EV_PERC
									nValNat		:= nValor   
									nVBxNat		:= nValor   * TMPSEV->EV_PERC
									nJurNat		:= nJuros   * TMPSEV->EV_PERC
									nAbtNat		:= nAbatLiq * TMPSEV->EV_PERC
									nAbImpNat	:= nTotAbImp* TMPSEV->EV_PERC
									nMulNat		:= nMulta   * TMPSEV->EV_PERC
									nCmoNat		:= nCm      * TMPSEV->EV_PERC
									nDesNat		:= nDesc    * TMPSEV->EV_PERC
									nPccBxNat	:= nPccBxCr * TMPSEV->EV_PERC  				//Pcc Baixa CR
									AADD(aSaldo,{TMPSEV->EV_NATUREZ,nValNat,nVBxNat,nJurNat,nMulNat,nDesNat,nCmoNat,nAbtNat,nAbImpNat,nVlMovFin,SE5->E5_NATUREZ,nPccBxNat,c_obra}) // Iif(cCarteira='R', SE1->E1_XCC, SE2->E2_XCC)})
								EndIf
							EndIf
								
							TMPSEV->(DbSkip())
							Loop
						Enddo
						TMPSEV->(dbCloseArea())
					Endif
				#ELSE
					bWhile := { || .F. }
					If dbSeek(cChave)                                                          
						lMultNat := .T.
						bWhile := { || cChave == xFilial("SEV")+SEV->(EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA+EV_IDENT+SEV->EV_SEQ) }
					Else	
						// Pesquisa pela distribuicao mult. natureza na emissao, sem a sequencia da baixa
						cChave:= xFilial("SEV")+cPrefixo+cNumero+cParcela+cTipo+cCliFor190+"1"
						If dbSeek(cChave)
							lMultNat := .T.
							bWhile := { || cChave == xFilial("SEV")+SEV->(EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA+EV_IDENT) }
						Endif
					Endif	
					If lMultNat
						aSaldo := {}
						While Eval(bWhile)
							If SEV->EV_RECPAG == cCarteira .AND. !(SEV->EV_SITUACA $ "X/E")
								nValNat   := nVlr //* SEV->EV_PERC
								nVBxNat   := nValor * SEV->EV_PERC
								nJurNat   := nJuros * SEV->EV_PERC
								nAbtNat   := nAbatLiq * SEV->EV_PERC
								nAbImpNat := nTotAbImp * SEV->EV_PERC
								nMulNat   := nMulta * SEV->EV_PERC
								nCmoNat   := nCm * SEV->EV_PERC
								nDesNat   := nDesc * SEV->EV_PERC								
								nPccBxNat := nPccBxCr * If(Select("TMPSEV") > 0,TMPSEV->EV_PERC,SEV->EV_PERC)	//Pcc Baixa CR								
								AADD(aSaldo,{SEV->EV_NATUREZ,nValNat,nVBxNat,nJurNat,nMulNat,nDesNat,nCmoNat,nAbtNat,nAbImpNat,nVlMovFin,SE5->E5_NATUREZ,nPccBxNat,c_Obra})
							Endif
							SEV->(DbSkip())
							Loop
						Enddo
					Endif				
				#ENDIF
			Endif   
			
			//incluido bloco abaixo [Mauro Nagata, Actual Trend, 27/06/2012]              
			//If !Empty(MV_PAR40)
			//substituida linha acima pela abaixo [Mauro Nagata, Actual Trend, 20160315] por padrao foi incluido o MV_PAR40 e MV_PAR41
			If !Empty(MV_PAR42)
			If !lIpCCPr .And. !lIpCCEZ
 		       DbSelectArea("SE5")
 		       DbSkip()     
 		       dbSelectArea("NEWSE5")
 		       Loop
 		    EndIf     
 		    EndIf               
 		    //fim bloco [Mauro Nagata, Actual Trend, 27/06/2012]
 		    
 		    
			If !lMultNat .and. !lManual
				AADD(aSaldo,{cNatureza,nVlr,nValor,nJuros,nMulta,nDesc,nCm,nAbatLiq,nTotAbImp,nVlMovFin,cNatureza,nPccBxCr,c_Obra})
			ElseIf lManual
				AADD(aSaldo,{cNatureza,nVlr,nVlMovFin,nJuros,nMulta,nDesc,nCm,nAbatLiq,nTotAbImp,nVlMovFin,cNatureza,nPccBxCr,c_Obra})
			Endif
			DbSelectArea("cArqTmp")
			For nX := 1 To Len( aSaldo )
				//Verifico a Natureza e gravo no ArqTmp
				If (aSaldo[nX][1] >= MV_PAR05 .And. aSaldo[nX][1]<= MV_PAR06) .or.;
				   (aSaldo[nX][11] >= MV_PAR05 .And. aSaldo[nX][11]<= MV_PAR06)
				   
					RecLock("cArqTmp",.T.) //DbAppend()
					For nY := 1 To SE5->(fCount())
						cArqTmp->(FieldPut(nY,SE5->(FieldGet(nY))))
					Next
					cArqTmp->E5_NATUREZ	:= aSaldo[nX][1]
					cArqTmp->E5_VALTIT	:= aSaldo[nX][2]
					cArqTmp->E5_VALOR	:= aSaldo[nX][3]
					cArqTmp->E5_VLJUROS	:= aSaldo[nX][4]
					cArqTmp->E5_VLMULTA	:= aSaldo[nX][5]
					cArqTmp->E5_VLDESCO	:= aSaldo[nX][6]
					cArqTmp->E5_VLCORRE	:= aSaldo[nX][7]
					cArqTmp->E5_VLABLIQ	:= aSaldo[nX][8]                                     
					cArqTmp->E5_VLABIMP	:= aSaldo[nX][9] + aSaldo[nX][12]
					cArqTmp->E5_VLMOVFI	:= aSaldo[nX][10]                                     					
					cArqTmp->E5_VENCTO	:= dDtMovFin
					cArqTmp->E5_HISTOR	:= cHistorico
					cArqTmp->E5_XCC		:= aSaldo[nX][13]
				Endif
			Next
			aSaldo := {}
			nDesc := nJuros := nValor := nMulta := nCM := nAbatLiq := nTotAbImp := nVlMovFin := 0
			nPccBxCr := 0	//Pcc Baixa CR
			li++
			dbSelectArea("SE5")
			dbSkip()
		Endif                 
		dbSelectArea("NEWSE5")
	Enddo
Enddo
dbSelectArea("cArqTmp")
dbGoTop()
If !EOF() .and. !BOF()
	While !Eof()
		If li > 60
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
		EndIF	
		
		If FunName() == "FINR190"
			cAnterior    := cArqTmp->(&cCond2)						
			cCondLaco    := cCond2
		Else
			cAnterior := cArqTmp->(E5_NATUREZ)
			cCondLaco := "E5_NATUREZ"			
		Endif
		cNatAnterior := cArqTmp->(E5_NATUREZ)
		cBancoAnt    := cArqTmp->(E5_BANCO)
		cAgenAnt     := cArqTmp->(E5_AGENCIA)
		cContaAnt    := cArqTmp->(E5_CONTA)
		cTipoAnt     := cArqTmp->(E5_TIPO)
		cTipoDocAnt  := cArqTmp->(E5_TIPODOC)
				
		While !Eof() .and. cAnterior == cArqTmp->(&cCondLaco)
			xPlan01 := ""
			xPlan02 := ""
			xPlan03 := ""
			xPlan04 := ""
			xPlan05 := ""
			xPlan06 := ""
			xPlan07 := ""
			xPlan08 := ""
			xPlan09 := ""
			xPlan10 := ""
			xPlan11 := ""
			xPlan12 := Ctod("")
			xPlan13 := 0
			xPlan14 := 0
			xPlan15 := 0
			xPlan16 := 0
			xPlan17 := 0
			xPlan19 := 0
			xPlan20 := ""
			xPlan21 := Ctod("")
			xPlan22 := ""
			xPlan23 := ""                   
	
			cMotBaixa := cArqTmp->(E5_MOTBX)			
			lManual := .F.
			If Empty(cArqTmp->E5_TIPODOC) .Or. Empty(cArqTmp->E5_NUMERO)
				lManual := .t.
			EndIf                                        
			
			IF nTamCliFor > 6 .and. !lManual
				@li, aColu[05] PSAY cArqTmp->(E5_CLIFOR)
				@li, aColu[06] PSAY SUBSTR(cArqTmp->(E5_BENEF),1,18)

				xPlan01 := CHR(9) + cArqTmp->(E5_CLIFOR)
				xPlan02 := CHR(9) + SUBSTR(cArqTmp->(E5_BENEF),1,18)
				li++
			Endif
			
			@li, aColu[01] PSAY cArqTmp->(E5_PREFIXO)
			@li, aColu[02] PSAY cArqTmp->(E5_NUMERO)
			@li, aColu[03] PSAY cArqTmp->(E5_PARCELA)
			@li, aColu[04] PSAY cArqTmp->(E5_TIPO)
			
			If nTamCliFor <= 6 .and. !lManual
				@li, aColu[05] PSAY cArqTmp->(E5_CLIFOR)
				@li, aColu[06] PSAY SUBSTR(cArqTmp->(E5_BENEF),1,16)

				xPlan07 := CHR(9) + cArqTmp->(E5_CLIFOR)
				xPlan08 := CHR(9) + SUBSTR(cArqTmp->(E5_BENEF),1,16)                                                       
			Endif                         

			@li, 49 PSAY cArqTmp->(E5_NATUREZ)
			@li, 60 PSAY cArqTmp->(E5_XCC)  //cArqTmp->(E5_VENCTO) // cintia
			
			If !Empty(cArqTmp->(E5_NUMCHEQ))
				@li, 71 PSAY SubStr(ALLTRIM(cArqTmp->(E5_NUMCHEQ))+"/"+Trim(cArqTmp->(E5_HISTOR)),1,18)
			Else
				@li, 71 PSAY SubStr(cArqTmp->(E5_HISTOR),1,18)
			Endif
			
			If "FINR190" $ Funname()                             
				@li, 93 PSAY cArqTmp->(E5_DATA)
			Else			
				@li, 90 PSAY cArqTmp->(E5_DATA)
			Endif	
			
			IF cArqTmp->(E5_VALTIT) > 0
				@li,103 PSAY cArqTmp->(E5_VALTIT) Picture tm(cArqTmp->(E5_VALTIT),14,nDecs)
			Endif         
			
			nJurMul := cArqTmp->(E5_VLJUROS) + cArqTmp->(E5_VLMULTA) 
			
			nCT++
			@li,117 PSAY nJurMul 					PicTure tm(cArqTmp->(E5_VLJUROS),12,nDecs)
			@li,129 PSAY cArqTmp->(E5_VLCORRE) PicTure tm(cArqTmp->(E5_VLCORRE),12,nDecs)
			@li,141 PSAY cArqTmp->(E5_VLDESCO) PicTure tm(cArqTmp->(E5_VLDESCO),12,nDecs)
			@li,153 PSAY cArqTmp->(E5_VLABLIQ) Picture tm(cArqTmp->(E5_VLABLIQ) ,12,nDecs)
			@li,165 PSAY cArqTmp->(E5_VLABIMP) Picture tm(cArqTmp->(E5_VLABIMP) ,12,nDecs)
			@li,179 PSAY cArqTmp->(E5_VALOR)	   PicTure tm(cArqTmp->(E5_VALOR)  ,14,nDecs)
			@li,196 PSAY cArqTmp->(E5_BANCO)
			@li,If(Len(DTOC(cArqTmp->(E5_DTDIGIT))) <= 8, 202,200) PSAY cArqTmp->(E5_DTDIGIT)
			@li,211 PSAY IF(Empty(cArqTmp->(E5_MOTBX)),"NOR",cArqTmp->(E5_MOTBX))
			@li,215 PSAY cArqTmp->(E5_FILORIG)
			
			li++
			If li > 60
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
			EndIF
			nAscan := aScan(aImpresso, cArqTmp->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+If(nOrdem == 3,cArqTmp->E5_NATUREZ,'')) )		
			nTotOrig   += cArqTmp->(E5_VALTIT) //If(nAscan = 0,cArqTmp->(E5_VALTIT),0)   cintia
			nGerOrig   += cArqTmp->(E5_VALTIT) //If(aScan(aImpresso, cArqTmp->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA))=0,cArqTmp->(E5_VALTIT),0)  cintia			
			nFilOrig   += cArqTmp->(E5_VALTIT) //If(aScan(aImpresso, cArqTmp->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA))=0,cArqTmp->(E5_VALTIT),0)  cintia						
			nTotBaixado+= Iif(lManual .or. cArqTmp->(E5_TIPODOC) $ "CP/BA" .AND. cArqTmp->(E5_MOTBX) $ "CMP/FAT",0,cArqTmp->(E5_VALOR))		// n„o soma, j  somou no principal
			nTotDesc   += cArqTmp->(E5_VLDESCO)
			nTotJurMul += nJurMul
			nTotCM     += cArqTmp->(E5_VLCORRE)
			nTotAbat   += cArqTmp->(E5_VLABLIQ)
			nTotImp    += cArqTmp->(E5_VLABIMP)
			nTotValor  += IIF( cArqTmp->(E5_VLMOVFI) <> 0, cArqTmp->(E5_VLMOVFI) , Iif(MovBcoBx(cMotBaixa),cArqTmp->(E5_VALOR),0))
			nTotMovFin += IIF(lManual,cArqTmp->(E5_VLMOVFI),0)
			nTotComp   += Iif(cArqTmp->(E5_TIPODOC) == "CP",cArqTmp->(E5_VALOR),0)
			nTotFat	   += Iif(cArqTmp->(E5_MOTBX) == "FAT",cArqTmp->(E5_VALOR), 0)						
			
			xPlan03 := CHR(9) + cArqTmp->(E5_PREFIXO)
			xPlan04 := CHR(9) + cArqTmp->(E5_NUMERO)
			xPlan05 := CHR(9) + cArqTmp->(E5_PARCELA)            
			xPlan06 := CHR(9) + cArqTmp->(E5_TIPO)
			xPlan09 := CHR(9) + cArqTmp->(E5_NATUREZ) 
			xPlan10 := CHR(9) + cArqTmp->(E5_XCC)
			xPlan11 := CHR(9) + SubStr(ALLTRIM(cArqTmp->(E5_NUMCHEQ))+"/"+Trim(cArqTmp->(E5_HISTOR)),1,18)
			xPlan12 := cArqTmp->(E5_DATA)
			xPlan13 := cArqTmp->(E5_VALTIT)
			xPlan14 := nJurMul
			xPlan15 := cArqTmp->(E5_VLCORRE)
			xPlan16 := cArqTmp->(E5_VLDESCO)
			xPlan17 := cArqTmp->(E5_VLABLIQ)
			xPlan18 := cArqTmp->(E5_VLABIMP)
			xPlan19 := cArqTmp->(E5_VALOR)
			xPlan20 := cArqTmp->(E5_BANCO)
			xPlan21 := cArqTmp->(E5_DTDIGIT)
			xPlan22 := CHR(9) + IF(Empty(cArqTmp->(E5_MOTBX)),"NOR",cArqTmp->(E5_MOTBX))
			xPlan23 := CHR(9) + cArqTmp->(E5_FILORIG)

			If !lManual
				Aadd(aImpresso, cArqTmp->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+If(nOrdem == 3,cArqTmp->E5_NATUREZ,'')) )
			Endif	
			
			Aadd(aPlanilha, {xPlan03, xPlan04, xPlan05, xPlan06, xPlan07, xPlan08, xPlan09, xPlan10, xPlan11, xPlan12, xPlan13, xPlan14, xPlan15, xPlan16, xPlan17, xPlan18, xPlan19, xPlan20, xPlan21, xPlan22, xPlan23 })
			cArqTmp->(dbSkip())
		Enddo
		
		If (nTotValor+nDesc+nJuros+nCM+nTotMulta+nTotOrig+nTotMovFin+nTotComp+nTotFat)>0
			li++
			IF li > 60
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
			Endif
			If nCT > 0												
				If FunName() == "FINR190"				
					@li, 0 PSAY DescQuebra(cAnterior,cBancoAnt,cAgenAnt,cContaAnt,cTipoAnt,cTipoDocAnt,cNatAnterior)												
				Else
					dbSelectArea("SED")
					DbSetOrder(1)
					MsSeek(xFilial("SED")+cAnterior)
					@li, 0 PSAY "SubTotal : " + cNatAnterior + " "+ED_DESCRIC				
				Endif				              	
			Endif
			@li,103 PSAY nTotOrig     PicTure tm(nTotOrig,14,nDecs)
			@li,117 PSAY nTotJurMul   PicTure tm(nTotJurMul,12,nDecs)
			@li,129 PSAY nTotCM       PicTure tm(nTotCM ,12,nDecs)
			@li,141 PSAY nTotDesc     PicTure tm(nTotDesc,12,nDecs)
			@li,153 PSAY nTotAbat     Picture tm(nTotAbat,12,nDecs)
			@li,165 PSAY nTotImp      Picture tm(nTotImp,12,nDecs)
			@li,179 PSAY nTotValor    PicTure tm(nTotValor,14,nDecs)
			If nTotBaixado > 0
				@li,195 PSAY OemToAnsi(STR0028)  //"Baixados"
				@li,205 PSAY nTotBaixado  PicTure tm(nTotBaixado,14,nDecs)
			Endif
			If nTotMovFin > 0
				li++
				@li,195 PSAY OemToAnsi(STR0031)   //"Mov Fin."
				@li,205 PSAY nTotMovFin   PicTure tm(nTotMovFin,14,nDecs)
			Endif
			If nTotComp > 0
				li++
				@li,195 PSAY STR0037  //"Compens."
				@li,205 PSAY nTotComp     PicTure tm(nTotComp,14,nDecs)
			Endif      
			If nTotFat > 0
				li++
				@li,195 PSAY STR0076  //"Bx.Fatura"
				@li,205 PSAY nTotFat     PicTure tm(nTotFat,14,nDecs)
			Endif						
			li+=2
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Incrementa Totais Gerais ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nGerValor	+= nTotValor
		nGerDesc	+= nTotDesc
		nGerJurMul	+= nTotJurMul
		nGerCM		+= nTotCM
		nGerAbLiq	+= nTotAbat
		nGerAbImp	+= nTotImp
		nGerBaixado += nTotBaixado
		nGerMovFin	+= nTotMovFin
		nGerComp	+= nTotComp
		nGerFat     += nTotFat					
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Incrementa Totais Filial ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nFilValor	+= nTotValor
		nFilDesc		+= nTotDesc
		nFilJurMul	+= nTotJurMul
		nFilCM		+= nTotCM
		nFilAbLiq	+= nTotAbat
		nFilAbImp	+= nTotImp
		nFilBaixado += nTotBaixado
		nFilMovFin	+= nTotMovFin
		nFilComp	+= nTotComp
		nFilFat	    += nTotFat

		nTotValor	:= 0
		nTotDesc		:= 0
		nTotJurMul	:= 0
		nTotMulta	:= 0
		nTotCM		:= 0
		nCT			:= 0
		nTotOrig		:= 0
		nTotBaixado	:= 0
		nTotAbat		:= 0
		nTotImp		:= 0
		nTotMovFin	:= 0
		nTotComp	:= 0
		nTotFat		:= 0
		
		dbSelectArea("cArqTmp")
	Enddo
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprimir TOTAL por filial somente quan-³
//³ do houver mais do que 1 filial.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if mv_par17 == 1 .and. SM0->(Reccount()) > 1 .And. li != 80            
	@li,  0 PSAY "FILIAL : " +  cFilAnt + " - " + cFilNome
	@li,102 PSAY nFilOrig       PicTure tm(nFilOrig,15,nDecs)
	@li,118 PSAY nFilJurMul     PicTure tm(nFilJurMul,11,nDecs)
	@li,130 PSAY nFilCM         PicTure tm(nFilCM ,11,nDecs)
	@li,142 PSAY nFilDesc       PicTure tm(nFilDesc,11,nDecs)                                       
	@li,154 PSAY nFilAbLiq       PicTure tm(nFilAbLiq,11,nDecs)
	@li,166 PSAY nFilAbImp       PicTure tm(nFilAbImp,11,nDecs)
	@li,178 PSAY nFilValor      PicTure tm(nFilValor,15,nDecs)
	If nFilBaixado > 0 
		@li,195 PSAY STR0028 // "Baixados"
		@li,204 PSAY nFilBaixado    PicTure tm(nFilBaixado,15,nDecs)
	Endif
	If nFilMovFin > 0
		li++
		@li,195 PSAY STR0031   //"Mov Fin."
		@li,204 PSAY nFilMovFin   PicTure tm(nFilMovFin,15,nDecs)
	Endif
	If nFilComp > 0
		li++
		@li,195 PSAY STR0037  //"Compens."
		@li,204 PSAY nFilComp     PicTure tm(nFilComp,15,nDecs)
	Endif
	If nFilFat > 0
		li++
		@li,195 PSAY STR0076  //"Bx.Fatura"
		@li,204 PSAY nFilFat     PicTure tm(nFilFat,15,nDecs)
	Endif
	li+=2

	nFilOrig:=nFilJurMul:=nFilCM:=nFilDesc:=nFilAbLiq:=nFilAbImp:=nFilValor:=0
	nFilBaixado := nFilMovFin:=nFilComp:=nFilFat:=0
	nFilValor	:= 0
	nFilDesc	:= 0
	nFilJurMul	:= 0
	nFilCM		:= 0
	nFilAbLiq	:= 0
	nFilAbImp	:= 0
	nFilBaixado := 0
	nFilMovFin	:= 0
	nFilComp	:= 0
	nFilFat	    := 0  
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga arquivos tempor rios  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectarea("cArqTmp")                                                  
cArqTmp->( dbCloseArea() )
FErase(cArqTmp+OrdBagExt())
FErase(cArqTmp+GetDbExtension())

SE5->(RestArea(aAreaSe5))

Return 

/*                                                                                                
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³DescQuebraºAutor  ³Marcelo Celi Marquesº Data ³  07/30/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna o texto que será impresso no subtotal do relatorio º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DescQuebra(cAnterior,cBancoAnt,cAgAnt,cContaAnt,cTipo190,cTipoDoc,cNatAnt)

Local cRecpag := E5_RECPAG 

IF nOrdem == 1 .or. nOrdem == 6 .or. nOrdem == 8
	Return("Sub Total : " + DTOC(cAnterior))
Elseif nOrdem == 2 .or. nOrdem == 4 .or. nOrdem == 7
	cLinha := "Sub Total : "+cAnterior+" "
	If nOrdem == 4
		If (mv_par11 == 1 .and. (cRecpag == "R" .and. !(cTipo190 $ MVPAGANT+"/"+MV_CPNEG))) .or. ;
			(cRecpag == "P" .and. cTipo190 $ MVRECANT+"/"+MV_CRNEG) .Or.;
			(cRecPag == "P" .And. cTipoDoc $ "DB#OD")
	
			dbSelectArea("SA1")
			DbSetOrder(1)
			If !Empty(cAnterior)
				MsSeek(cFil_NewSE5+cFornece+cLoja)
				cLinha+=" "+A1_CGC
			Else
				cLinha+= "Moviment. Financeiras Manuais "
			Endif
		ElseIF (mv_par11 == 2 .and. (cRecpag == "P" .and. !(cTipo190 $ MVRECANT+"/"+MV_CRNEG))) .or.;
				(cRecpag == "R" .and. cTipo190 $ MVPAGANT+"/"+MV_CPNEG)
			dbSelectArea("SA2")
			DbSetOrder(1)
			If !Empty(cAnterior)
				MsSeek(cFil_NewSE5+cFornece+cLoja)
				cLinha+=TRIM(A2_NOME)+"  "+A2_CGC
			Else
				cLinha+= "Moviment. Financeiras Manuais "
			Endif
		Endif
	Elseif nOrdem == 2
		dbSelectArea("SA6")
		DbSetOrder(1)                                                         
		MsSeek(xFilial("SA6")+cBancoAnt+cAgAnt+cContaAnt)
		cLinha+=TRIM(A6_NOME)
	Endif
	Return(cLinha)
	                                                                                    
Elseif nOrdem == 3
	dbSelectArea("SED")
	DbSetOrder(1)
	MsSeek(cFil_NewSE5+cAnterior)
	Return("SubTotal : " + cAnterior + " "+ED_DESCRIC)
Endif
If nOrdem != 5
	Return("")
Endif