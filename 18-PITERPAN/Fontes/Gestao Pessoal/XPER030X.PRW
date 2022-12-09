#INCLUDE "PROTHEUS.CH"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"
#IFNDEF CRLF
	#DEFINE CRLF ( chr(13)+chr(10) )
#ENDIF

#DEFINE Imp_Spool      	2
#DEFINE ALIGN_H_LEFT   	0
#DEFINE ALIGN_H_RIGHT  	1
#DEFINE ALIGN_H_CENTER 	2
#DEFINE ALIGN_V_CENTER 	0
#DEFINE ALIGN_V_TOP	   		1
#DEFINE ALIGN_V_BOTTON 	2

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GPER030X ³ Autor ³ R.H. - Ze Maria       ³ Data ³ 14.03.95 	        ³±±
±±³          ³          ³ Adapt ³ Marcelo Franca        ³ Data ³ 25.02.17 	        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao de Recibos de Pagamento                                      ³±±
±±³          ³                                                                      ³±±
±±³          ³ Adaptacao do GPER030 com alteracao do layout do PDF                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GPER030(void)                                             	        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                               		   		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ Chd./Requisito ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Ademar Jr.  ³22/03/13³Requisito:      ³-Unificacao dos fontes da fase padrao com ³±±
±±³            ³        ³RHU210_09_13    ³ a fase 4 (localizacoes).                 ³±±
±±³Sidney O.   ³02/04/14³M_RH007   TPDCQD³Alteracao da funcao f030Roteiro - nao     ³±±
±±³            ³        ³                ³exibe mais os roteiros G e J (INC e MUV)  ³±±
±±³Raquel Hager³02/09/14³TQM075			 ³Utilizacao de tabela S036 para Mensagens. ³±±
±±³Renan Borges³09/10/14³TQNUVG          ³Ajuste para imprimir log de ocorrências   ³±±
±±³			   ³ 		³                ³corretamente e sem gerar um relatório va- ³±±
±±³			   ³ 		³                ³zio após a impressão do log de ocorrências³±±
±±³Wag Mobile  ³31/10/14³TQTXLQ          ³Ajuste para imprimir verificando filtro da³±±
±±³			   ³ 		³                ³aba de filtro corretamente.               ³±±
±±³Allyson M   ³19/02/15³TRMMMT          ³Ajuste na validacao da data de aniversario³±±
±±³			   ³ 		³                ³no recibo enviado por email.	 			³±±
±±³Mariana M   ³08/04/15³TRVPPK        	 ³Ajuste no relatorio Zebrado para que no   ³±±
±±³			   ³ 		³                ³mes do aniversario do funcionario,apresen-³±±
±±³			   ³ 		³                ³tando a mensagem "Feliz Aniversario"		³±±
±±³	Emerson Ca³09/07/15³ PCREQ-4461    ³Criar a opção de envio de PDF por email     ³±±
±±³	          ³        ³               ³Changset 294739                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function XPER030X(lTerminal,cFilTerminal,cMatTerminal,cProcTerminal, nRecTipo, cPerTerminal, cSemanaTerminal)                 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cString:="SRA"        // alias do arquivo principal (Base)
Local aOrd   := {"Matricula","C.Custo","Nome","Chapa","C.Custo + Nome","Depto.","Depto. + Nome"}
Local cDesc1 := "Emissão de Recibos de Pagamento."
Local cDesc2 := "Ser  impresso de acordo com os parametros solicitados pelo"
Local cDesc3 := "usu rio."
Local aDriver:= ReadDriver(.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cIndCond
Local cRotBlank := Space(GetSx3Cache( "RCH_ROTEIR", "X3_TAMANHO" ))
Local Baseaux := "S", cDemit := "N"
Local cHtml 	:= ""

Private cMes	  := ""
Private cAno    := ""
Private aEmail  := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o numero da linha de impressão como 0                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetPrc(0,0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn  := {"Zebrado", 1,"Administra‡„o", 2, 2, 1, "",1 }	//
Private nomeprog :="GPER030"
Private aLinha   := { }
Private nLastKey := 0
//Private cPerg    :="GPER030"
Private cPerg    :="XGPER030"
Private cSem_De  := "  /  /    "
Private cSem_Ate := "  /  /    "
Private nAteLim , nBaseFgts , nFgts , nBaseIr , nBaseIrFe , nTipRel

Private cCompac := aDriver[1]
Private cNormal := aDriver[2]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aLanca 		:= {}
Private aProve 		:= {}
Private aDesco 		:= {}
Private aBases 		:= {}
Private aInfo  		:= {}
Private aCodFol		:= {}
Private li     		:= _PROW()
Private Titulo 		:= "EMISSO DE RECIBOS DE PAGAMENTOS"
Private lEnvioOk 	:= .F.
Private lRetCanc	:= .t.
Private cIRefSem    := GetMv("MV_IREFSEM",,"S")
Private aPerAberto	:= {}
Private aPerFechado	:= {}
Private cProcesso		:= "" // Armazena o processo selecionado na Pergunte GPR040 (mv_par01).
Private cRoteiro		:= "" // Armazena o Roteiro selecionado na Pergunte GPR040 (mv_par02).
Private cPeriodo		:= "" // Armazena o Periodo selecionado na Pergunte GPR040 (mv_par03).
Private cCcto			:= ""
Private cCond			:= ""
Private cRot			:= ""
Private lDepSf		:= Iif(SRA->(FieldPos("RA_DEPSF"))>0,.T.,.F.)
Private lLpt1			:= .F.
Private lFase4  		:= (cPaisLoc $ "ANG|ARG|COL|PTG|VEN")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis da Impressao Grafica                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private oPrint   
Private oArial08	:= TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)//Normal
Private oArial08N	:= TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)//Negrito
Private oArial10	:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)//Normal
Private oArial10N	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)//Negriot
Private oPrinter	:= ""
Private oFont1 		:=	TFont():New( "Verdana", 07, 07, , .F., , , , .T., .F. )//Verbas
Private oFont2 		:=	TFont():New( "Verdana", 09, 09, , .F., , , , .T., .F. )//Cabeçalho e Rodapé
//Private oFont2N 	:= 	TFont():New( "Verdana", 09, 09, , .T., , , , .T., .F. )//Cabeçalho e Rodapé Negrito
Private oFont2N 	:= 	TFont():New( "Arial", 10, 10, , .T., , , , .T., .F. )//Cabeçalho e Rodapé Negrito
Private oFont10  	:= 	TFont():New( "Arial", 10, 10, , .F., , , , .T., .F. )//Cabeçalho e Rodapé Normal
Private oFont3 		:=	TFont():New( "Verdana", 12, 12, , .T., , , , .T., .F. )//Titulo Interno
//Private oFont4 		:=	TFont():New( "Verdana", 14, 14, , .T., , , , .T., .F. )//Titulo Maior
Private oFont4N 	:=	TFont():New( "Arial", 14, 14, , .T., , , , .T., .F. )//Titulo Maior - Negrito
Private oFont4 		:=	TFont():New( "Arial", 14, 14, , .F., , , , .T., .F. )//Titulo Maior - Negrito

Private Semana
Private cSemana
Private lPDFEmail	:= .T. //PDF é por Email quando for .F. Visualizar o PDF no remote

  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="GPER030"            //Nome Default do relatorio em Disco

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o programa foi chamado do terminal - TCF         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lTerminal := If( lTerminal == Nil, .F., lTerminal )

ValidPerg(CPERG)

IF !( lTerminal )
	wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd)
Else           
	If Select("SRC")>0
		SRC->(DbCloseArea())
	EndIf
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define a Ordem do Relatorio                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem := IF( !( lTerminal ), aReturn[8] , 1 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !IsBlind()
	Pergunte(cPerg, .F.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando variaveis mv_par?? para Variaveis do Sistema.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cSemanaTerminal := IF( Empty( cSemanaTerminal ) , Space( Len( SRC->RC_SEMANA ) ) , cSemanaTerminal )
cProcesso  := IF( !( lTerminal ), mv_par01 , cProcTerminal		)   //Processo
cRoteiro   := IF( !( lTerminal ), mv_par02 , nRecTipo			)	//Emitir Recibos(Roteiro)
cPeriodo   := IF( !( lTerminal ), mv_par03 , cPerTerminal		)   //Periodo
Semana     := IF( !( lTerminal ), mv_par04 , cSemanaTerminal	)	//Numero da Semana
cSemana    := Semana

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificar se o sistema esta trabalhando com ou sem roteiro   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea( "RCH" )
DbSetOrder( 4 )
DbSeek(  xFilial( "RCH" ) + cProcesso + cRoteiro + cPeriodo + Semana, .F. )
If Eof()
	DbSeek(  xFilial( "RCH" ) + cProcesso + cRotBlank + cPeriodo + Semana, .F. )
Else
	cRotBlank := cRoteiro
EndIf

//Carregar os periodos abertos (aPerAberto) e/ou 
// os periodos fechados (aPerFechado), dependendo 
// do periodo (ou intervalo de periodos) selecionado
RetPerAbertFech(cProcesso	,; // Processo selecionado na Pergunte.
				cRotBlank	,; // Roteiro selecionado na Pergunte.
				cPeriodo	,; // Periodo selecionado na Pergunte.
				Semana		,; // Numero de Pagamento selecionado na Pergunte.
				NIL			,; // Periodo Ate - Passar "NIL", pois neste relatorio eh escolhido apenas um periodo.
				NIL			,; // Numero de Pagamento Ate - Passar "NIL", pois neste relatorio eh escolhido apenas um numero de pagamento.
				@aPerAberto	,; // Retorna array com os Periodos e NrPagtos Abertos
				@aPerFechado ) // Retorna array com os Periodos e NrPagtos Fechados
				
// Retorna o mes e o ano do periodo selecionado na pergunte.
AnoMesPer(	cProcesso	,; // Processo selecionado na Pergunte.
			cRotBlank	,; // Roteiro selecionado na Pergunte.
			cPeriodo	,; // Periodo selecionado na Pergunte.
			@cMes		,; // Retorna o Mes do Processo + Roteiro + Periodo selecionado
			@cAno		,; // Retorna o Ano do Processo + Roteiro + Periodo selecionado     
			Semana		 ) // Retorna a Semana do Processo + Roteiro + Periodo selecionado
			
dDataRef   := CTOD("01/" + cMes + "/" + cAno)

nTipRel    := IF( !( lTerminal ), mv_par05 , 2				)	//Tipo de Recibo (Pre-Impressão/Zebrado/EMail/PDF)
cFilDe     := IF( !( lTerminal ), mv_par06,cFilTerminal		)	//Filial De
cFilAte    := IF( !( lTerminal ), mv_par07,cFilTerminal		)	//Filial Ate
cCcDe      := IF( !( lTerminal ), mv_par08,SRA->RA_CC		)	//Centro de Custo De
cCcAte     := IF( !( lTerminal ), mv_par09,SRA->RA_CC		)	//Centro de Custo Ate
cMatDe     := IF( !( lTerminal ), mv_par10,cMatTerminal		)	//Matricula Des
cMatAte    := IF( !( lTerminal ), mv_par11,cMatTerminal		)	//Matricula Ate
cNomDe     := IF( !( lTerminal ), mv_par12,SRA->RA_NOME		)	//Nome De
cNomAte    := IF( !( lTerminal ), mv_par13,SRA->RA_NOME		)	//Nome Ate
ChapaDe    := IF( !( lTerminal ), mv_par14,SRA->RA_CHAPA	)	//Chapa De
ChapaAte   := IF( !( lTerminal ), mv_par15,SRA->RA_CHAPA	)	//Chapa Ate
Mensag1    := mv_par16										 	//Mensagem 1
Mensag2    := mv_par17											//Mensagem 2
Mensag3    := mv_par18											//Mensagem 3
cSituacao  := IF( !( lTerminal ),mv_par19, fSituacao( NIL , .F. ) )	//Situacoes a Imprimir
cCategoria := IF( !( lTerminal ),mv_par20, fCategoria( NIL , .F. ))	//Categorias a Imprimir
cBaseAux   := IF( !( lTerminal ),If(mv_par21 == 1,"S","N"),"S")	//Imprimir Bases
cDeptoDe   := IF( !( lTerminal ),mv_par22,SRA->RA_DEPTO 	)	//Depto. De
cDeptoAte  := IF( !( lTerminal ),mv_par23,SRA->RA_DEPTO 	)	//Depto. Ate

//If aReturn[5] == 1 .and. nTipRel == 1
//	li	:=  0
//EndIf

If nTipRel == 1 //Apenas visualizar o PDF
	lPDFEmail	:= .F.
EndIf

limpArqPdf() //Limpar Recibos que por ventura ainda estejam no servidor

cMesAnoRef := StrZero(Month(dDataRef),2) + StrZero(Year(dDataRef),4)
If aReturn[5] == 3	//Impressao Direta na Porta
	lLpt1 := .T.
EndIf

IF !( lTerminal )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa Impressao                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ! fInicia(cString,nTipRel)
		Return
	Endif 
EndIF

DbSelectArea( "SRA" )
/*IF nTipRel==3
	IF lTerminal
		cHtml := R030Imp(.F.,wnRel,cString,cMesAnoRef,lTerminal)
		If Select("SRC")>0
			SRC->(DbCloseArea())
		EndIf
	Else
		ProcGPE({|lEnd| R030IMP(@lEnd,wnRel,cString,cMesAnoRef,.f.)},,,.T.)  // Chamada do Processamento
	EndIF
Else*/
RptStatus({|lEnd| R030Imp(@lEnd,wnRel,cString,cMesAnoRef,.f.)},Titulo)  // Chamada do Relatorio
//EndIF

Return( IF( lTerminal , cHtml , NIL ) )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R030IMP  ³ Autor ³ R.H. - Ze Maria       ³ Data ³ 14.03.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processamento Para emissao do Recibo                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ R030Imp(lEnd,WnRel,cString,cMesAnoRef,lTerminal)			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R030Imp(lEnd,WnRel,cString,cMesAnoRef,lTerminal)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aCodBenef   	:= {}
Local aTInss	  		:= {}
Local cAcessaSR1  	:= &("{ || " + ChkRH("GPER030","SR1","2") + "}")
Local cAcessaSRA  	:= &("{ || " + ChkRH("GPER030","SRA","2") + "}")
Local cAcessaSRC  	:= &("{ || " + ChkRH("GPER030","SRC","2") + "}")
Local cAcessaSRD  	:= &("{ || " + ChkRH("GPER030","SRD","2") + "}")
Local cNroHoras   	:= &("{ || If(aVerbasFunc[nReg,5] > 0 .And. cIRefSem == 'S', aVerbasFunc[nReg,5], aVerbasFunc[nReg,6]) }")
Local cHtml		  	:= ""
Local nHoras      	:= 0
Local nMes, nAno
Local nX
Local nReg		  		:= 0
Local cPerAnt	  		:= ""                    
Local cKey		  		:= ""
Local cInicio	  		:= ""
Local nBInssPA	  	:= 0 //Teto da base de INSS dos pro-labores/autonomos
Local dDataLibRh
Local cPerCorrente	:= ""
Local cSemCorrente	:= ""
Local cMesCorrente 	:= ""
Local cAnoCorrente 	:= ""

Local nTcfDadt		:= if(lTerminal,getmv("MV_TCFDADT",,0),0)		// indica o dia a partir do qual esta liberada a consulta ao TCF 
Local nTcfDfol		:= if(lTerminal,getmv("MV_TCFDFOL",,0),0)		// indica a quantidade de dias a somar ou diminuir no ultimo dia do mes corrente para liberar a consulta do TCF
Local nTcfD131		:= if(lTerminal,getmv("MV_TCFD131",,0),0)		// indica o dia a partir do qual esta liberada a consulta ao TCF
Local nTcfD132		:= if(lTerminal,getmv("MV_TCFD132",,0),0)		// indica o dia a partir do qual esta liberada a consulta ao TCF
Local nTcfDext		:= if(lTerminal,getmv("MV_TCFDEXT",,0),0)		// indica o dia a partir do qual esta liberada a consulta ao TCF
Local nDec
Local nPosMsg1		:= 0
Local nPosMsg2		:= 0
Local nPosMsg3		:= 0
Local cFilter	   		:= aReturn[7]

Private tamanho   	:= "M"
Private limite		:= 132
Private cDtPago   	:= ""
Private cTipoRot 		:= PosAlias("SRY", cRoteiro, SRA->RA_FILIAL, "RY_TIPO")
Private aVerbasFunc 	:= {}
Private cRotBlank
Private nHraExtra 	:= 0
Private nPagoDom		:= 0

Private cPict1		:= "@E 999,999,999.99"
Private cPict2 		:= "@E 99,999,999.99"
Private cPict3 		:= "@E 999,999.99"

Private nSalario		:= 0

//-Ordem 1 -> RCA_FILIAL+RCA_MNEMON
If FPOSREG("RCA", 1, XFILIAL("RCA")+"RHDECIMAIS")
	nDec := Val(Alltrim(RCA->RCA_CONTEU))
Else
	nDec := MsDecimais(1)
EndIf

If nDec = 0
	cPict1	:=	"@E 99,999,999,999"
	cPict2 	:=	"@E 9,999,999,999"
	cPict3 	:=	"@E 99,999,999"
Endif

// Ajuste do tipo da variavel
nTcfDadt	:= if(valtype(ntcfdadt)=="C",val(ntcfdadt),ntcfdadt)
nTcfD131	:= if(valtype(nTcfD131)=="C",val(nTcfD131),nTcfD131)
nTcfD132	:= if(valtype(nTcfD132)=="C",val(nTcfD132),nTcfD132)
nTcfDfol	:= if(valtype(ntcfdfol)=="C",val(ntcfdfol),ntcfdfol)
nTcfDext	:= if(valtype(ntcfdext)=="C",val(ntcfdext),ntcfdext)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Verifica se o Mes solicitado esta liberado para consulta no  |
//| terminal de consulta do funcionario.                         |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lTerminal

	dbSelectArea("RCH")
	dbSetOrder(6)
	cKey    := "xFilial('RCH') + cProcesso" + IIf(cRoteiro == "EXT", "", " + cRoteiro")
	cInicio := "RCH_FILIAL + RCH_PROCES" + IIf(cRoteiro == "EXT", "", " + RCH_ROTEIR")
	
	DbSeek( &(cKey))
	If Eof()
		cRotBlank 	:= Space(GetSx3Cache( "RCH_ROTEIR", "X3_TAMANHO" ))
		cKey := "xFilial('RCH') + cProcesso " + IIf(cRoteiro == "EXT", "", " + cRotBlank")
		cInicio := "RCH_FILIAL + RCH_PROCES " + IIf(cRoteiro == "EXT", "", " + RCH_ROTEIR")
		DbSeek( &(cKey))
	EndIf
	If !Eof()
		While RCH->( !Eof() .and. &(cInicio) == &(cKey))
			If Empty(RCH->RCH_DTFECH)
				cPerCorrente := RCH->RCH_PER
				cSemCorrente := RCH->RCH_NUMPAG
				cMesCorrente := RCH->RCH_MES
				cAnoCorrente := RCH->RCH_ANO
				Exit
			EndIf		
			RCH->( dbSkip() )
		EndDo
	EndIf

	If	(cPerCorrente == cPeriodo .AND. cSemCorrente == Semana)  .OR. ;
		( MesAno(dDataRef) >= (cAnoCorrente + cMesCorrente) )

		If  cTipoRot == "2" //Adiantamento
			If ( MesAno(dDataRef) > (cAnoCorrente + cMesCorrente) ) .Or.;
			   ( If(MesAno(Date()) == (cAnoCorrente + cMesCorrente), Day(Date()) < nTCFDADT,.F.) )
				Return( IF( lTerminal <> NIL .And. lTerminal , cHtml , NIL ) )
			EndIf
		ElseIf cTipoRot == "1" .and. !empty(nTCFDFOL) //Folha
			dDataLibRh := fMontaDtTcf(cMesCorrente + cAnoCorrente,nTCFDFOL)
			If Date() < dDataLibRH 
				Return( IF( lTerminal <> NIL .And. lTerminal , cHtml , NIL ) )
			Endif
		ElseIf cTipoRot == "5" //1a parcela 13o Salario
			If ( MesAno(dDataRef) > (cAnoCorrente + cMesCorrente) ) .Or.;
  			   ( If(MesAno(Date()) == (cAnoCorrente + cMesCorrente), Day(Date()) < nTCFD131,.F.) )
				Return( IF( lTerminal <> NIL .And. lTerminal , cHtml , NIL ) )
			Endif
		ElseIf cTipoRot == "6" //2a parcela 13o Salario
			If ( MesAno(dDataRef) > (cAnoCorrente + cMesCorrente) ) .Or.;
			   ( If(MesAno(Date()) == (cAnoCorrente + cMesCorrente), Day(Date()) < nTCFD132,.F.) )
				Return( IF( lTerminal <> NIL .And. lTerminal , cHtml , NIL ) )
			Endif
		ElseIf cRoteiro == "EXT"  // Valores Extras
			If ( MesAno(dDataRef) > (cAnoCorrente + cMesCorrente) ) .Or.;
			   ( If(MesAno(Date()) == (cAnoCorrente + cMesCorrente), Day(Date()) < nTCFDEXT,.F.) )
				Return( IF( lTerminal <> NIL .And. lTerminal , cHtml , NIL ) )
			Endif
		EndIf
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Selecionando a Ordem de impressao escolhida no parametro.    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SRA")
IF !( lTerminal )
	If nOrdem == 1			//"Matricula"
		dbSetOrder(1)
	ElseIf nOrdem == 2		//"C.Custo"
		dbSetOrder(2)
	ElseIf nOrdem == 3		//"Nome"
		dbSetOrder(3)
	Elseif nOrdem == 4		//"Chapa"
		cArqNtx  := CriaTrab(NIL,.f.)
		cIndCond :="RA_Filial + RA_Chapa + RA_Mat"
		IndRegua("SRA",cArqNtx,cIndCond,,,"Selecionando Registros...")
	
	ElseIf nOrdem == 5		//"C.Custo + Nome"
		dbSetOrder(8)
	ElseIf nOrdem == 6		//"Depto"
		dbSetOrder(21)
	ElseIf nOrdem == 7		//"Depto. + Nome"
		dbSetOrder(22)
	Endif
	
	dbGoTop()
	
	//If nTipRel == 2
		//@ LI,00 PSAY AvalImp(Limite)
	//Endif
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Selecionando o Primeiro Registro e montando Filtro.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOrdem == 1 .or. lTerminal
	cInicio := "SRA->RA_FILIAL + SRA->RA_MAT"
	IF !( lTerminal )
		dbSeek(cFilDe + cMatDe,.T.)
		cFim    := cFilAte + cMatAte
	Else
		cFim    := &(cInicio)
	EndIF
ElseIf nOrdem == 2
	dbSeek(cFilDe + cCcDe + cMatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
	cFim     := cFilAte + cCcAte + cMatAte
ElseIf nOrdem == 3
	dbSeek(cFilDe + cNomDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
	cFim    := cFilAte + cNomAte + cMatAte
ElseIf nOrdem == 4
	dbSeek(cFilDe + ChapaDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_CHAPA + SRA->RA_MAT"
	cFim    := cFilAte + ChapaAte + cMatAte
ElseIf nOrdem == 5
	dbSeek(cFilDe + cCcDe + cNomDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_NOME"
	cFim     := cFilAte + cCcAte + cNomAte
ElseIf nOrdem == 6
	dbSeek(cFilDe + cDeptoDe + cMatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_DEPTO + SRA->RA_MAT"
	cFim     := cFilAte + cDeptoAte + cMatAte
ElseIf nOrdem == 7
	dbSeek(cFilDe + cDeptoDe + cNomDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_DEPTO + SRA->RA_NOME"
	cFim     := cFilAte + cDeptoAte + cNomAte
Endif

dbSelectArea("SRA")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega Regua Processamento                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cAliasTMP := "QNRO"

BeginSql alias cAliasTMP
	SELECT COUNT(*) as NROREG
	FROM %table:SRA% SRA
	WHERE      SRA.RA_FILIAL BETWEEN %exp:cFilDe%   AND %exp:cFilAte% 
		   AND SRA.RA_MAT    BETWEEN %exp:cMatDe%   AND %exp:cMatAte%
		   AND SRA.RA_CC     BETWEEN %exp:cCCDe%    AND %exp:cCCAte% 
		   AND SRA.RA_DEPTO  BETWEEN %exp:cDeptoDe% AND %exp:cDeptoAte% 
		   AND SRA.%notDel%
EndSql

nRegProc := (cAliasTMP)->(NROREG)
( cAliasTMP )->( dbCloseArea() )	
//IF nTipRel # 3
SetRegua(nRegProc)	// Total de elementos da regua
//Else
//	IF !( lTerminal )
//		GPProcRegua(nRegProc)// Total de elementos da regua
//	EndIF
//EndIF
	
dbSelectArea("SRA")

TOTVENC		:= 0
TOTDESC		:= 0
FLAG		:= 0
CHAVE 		:= 0

Desc_Fil 	:= "" 
Desc_End 	:= ""
DESC_CC		:= ""
DESC_FUNC	:= ""
Desc_Comp	:= ""
Desc_Est 	:= ""
Desc_Cid	:= ""
DESC_MSG1	:= Space(01)
DESC_MSG2	:= Space(01)
DESC_MSG3	:= Space(01)
cFilialAnt 	:= Space(FwGetTamFilial)
Vez        	:= 0
OrdemZ     	:= 0

While SRA->( !Eof() .And. &cInicio <= cFim )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Movimenta Regua Processamento                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF !( lTerminal )

		//IF nTipRel # 3
		IncRegua()  // Anda a regua
		//ElseIF !( lTerminal )
		//	GPIncProc(SRA->RA_FILIAL+" - "+SRA->RA_MAT+" - "+SRA->RA_NOME)
		//EndIF

		If lEnd
			@Prow()+1,0 PSAY cCancel
			Exit
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Consiste Filtro da setprint						             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ! Empty(cFilter) .And. ! SRA->(&(cFilter))
			dbSelectArea("SRA")
			dbSkip()
			Loop
		EndI

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Consiste Parametrizacao do Intervalo de Impressao            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (SRA->RA_CHAPA < ChapaDe)   .Or. (SRA->RA_CHAPa > ChapaAte) .Or. ;
			(SRA->RA_NOME < cNomDe)    .Or. (SRA->RA_NOME > cNomAte)   .Or. ;
			(SRA->RA_MAT < cMatDe)     .Or. (SRA->RA_MAT > cMatAte)    .Or. ;
			(SRA->RA_CC < cCcDe)       .Or. (SRA->RA_CC > cCcAte)      .Or. ;
			(SRA->RA_DEPTO < cDeptoDe) .Or. (SRA->RA_DEPTO > cDeptoAte)

			SRA->(dbSkip(1))
			Loop
		EndIf

	EndIF

	aLanca:={}         // Zera Lancamentos
	aProve:={}         // Zera Lancamentos
	aDesco:={}         // Zera Lancamentos
	aBases:={}         // Zera Lancamentos
	nAteLim := nBaseFgts := nFgts := nBaseIr := nBaseIrFe := 0.00
	
	Ordem_rel := 1     // Ordem dos Recibos
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica Data Demissao         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cSitFunc := SRA->RA_SITFOLH
	dDtPesqAf:= CTOD("01/" + Left(cMesAnoRef,2) + "/" + Right(cMesAnoRef,4),"DDMMYY")
	If cSitFunc == "D" .And. (!Empty(SRA->RA_DEMISSA) .And. MesAno(SRA->RA_DEMISSA) > MesAno(dDtPesqAf))
		cSitFunc := " "
	Endif
	
	//-Busca o Salario Base do Funcionario
	nSalario := fBuscaSal(dDataRef,,,.F.)
	If nSalario == 0
		nSalario := SRA->RA_SALARIO
	EndIf
	
	IF !( lTerminal )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Consiste situacao e categoria dos funcionarios			     |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !( cSitFunc $ cSituacao ) .OR.  ! ( SRA->RA_CATFUNC $ cCategoria )
			SRA->(dbSkip())
			Loop
		Endif
		If cSitFunc $ "D" .And. Mesano(SRA->RA_DEMISSA) # Mesano(dDataRef)
			SRA->(dbSkip())
			Loop
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Consiste controle de acessos e filiais validas				 |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
			SRA->(dbSkip())
			Loop
		EndIf
		
	EndIF
	
	If SRA->RA_Filial # cFilialAnt
		If ! Fp_CodFol(@aCodFol,Sra->Ra_Filial) .Or. ! fInfo(@aInfo,Sra->Ra_Filial)
			Return Nil
		Endif      
		Desc_Fil := If( lLpt1, fTAcento(aInfo[3]), aInfo[3] )
		Desc_End := If( lLpt1, fTAcento(aInfo[4]), aInfo[4] )	// Dados da Filial
		Desc_CGC := aInfo[8]
		DESC_MSG1:= DESC_MSG2:= DESC_MSG3:= Space(01)
		Desc_Est := Substr(fDesc("SX5","12"+If( lLpt1, fTAcento(aInfo[6]), aInfo[6] ),"X5DESCRI()"),1,12)
		Desc_Comp:= If( lLpt1, fTAcento(aInfo[14]), aInfo[14] )	// Complemento Cobranca
		Desc_Cid := If( lLpt1, fTAcento(aInfo[5]), aInfo[5] )
		End_Compl:= aInfo[4] + " " + aInfo[13] + " " + aInfo[05] + " " +;
					aInfo[06] + " " + aInfo[07]//endereço + bairro + cidade + estado + cep
		Desc_EndC:= If( lLpt1, fTAcento( End_Compl ), End_Compl )
		// MENSAGENS
		If !Empty(MENSAG1)        
		
			nPosMsg1		:= fPosTab("S036",Alltrim(MENSAG1), "==", 4)
			If nPosMsg1 > 0 
				DESC_MSG1	:= fTabela("S036",nPosMsg1,5)
			EndIf
		Endif   
		
		nPosMsg2		:= fPosTab("S036",Alltrim(MENSAG2), "==", 4)
		If nPosMsg2 > 0 
			DESC_MSG2	:= fTabela("S036",nPosMsg2,5)
		EndIf  
		
		nPosMsg3		:= fPosTab("S036",Alltrim(MENSAG3), "==", 4)
		If nPosMsg3 > 0 
			DESC_MSG3	:= fTabela("S036",nPosMsg3,5)
		EndIf
		
		dbSelectArea("SRA")
		cFilialAnt := SRA->RA_FILIAL
	Endif
	
	Totvenc := Totdesc := 0
	            
	//Carrega tabela de INSS para utilizacao nos pro-labores/autonomos
	If !cPaisLoc $ "CHI|PAR" .AND. !lFase4
		Car_inss(@aTInss,MesAno(dDataRef))
	EndIf
	
	If Len(aTinss) > 0
		nBInssPA := aTinss[Len(aTinss),1]
	EndIf
	
	//Retorna as verbas do funcionario, de acordo com os periodos selecionados
	aVerbasFunc	:= RetornaVerbasFunc(	SRA->RA_FILIAL					,; // Filial do funcionario corrente
										SRA->RA_MAT	  					,; // Matricula do funcionario corrente
										NIL								,; // 
										cRoteiro	  					,; // Roteiro selecionado na pergunte
										NIL			  					,; // Array com as verbas que deverão ser listadas. Se NIL retorna todas as verbas.
										aPerAberto	  					,; // Array com os Periodos e Numero de pagamento abertos
										aPerFechado	 	 				 ) // Array com os Periodos e Numero de pagamento fechados

	If cRoteiro <> "EXT"
		For nReg := 1 to Len(aVerbasFunc)
			If (Len(aPerAberto) > 0 .AND. !Eval(cAcessaSRC)) .OR. (Len(aPerFechado) > 0 .AND. !Eval(cAcessaSRD)) .Or.;
			   ( aVerbasFunc[nReg,7] <= 0 )
				dbSkip()
				Loop
			EndIf
			
			If PosSrv( aVerbasFunc[nReg,3] , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
				nHoras := aVerbasFunc[nReg,6]	//-Eval(cNroHoras)
				fSomaPdRec("P",aVerbasFunc[nReg,3],nHoras,aVerbasFunc[nReg,7])
				TOTVENC += aVerbasFunc[nReg,7]
			Elseif SRV->RV_TIPOCOD == "2"
				fSomaPdRec("D",aVerbasFunc[nReg,3],aVerbasFunc[nReg,6],aVerbasFunc[nReg,7])
				TOTDESC += aVerbasFunc[nReg,7]
			Elseif SRV->RV_TIPOCOD $ "3/4"
				//No Paraguai imprimir somente o valor liquido
				If cPaisLoc <> "PAR" .Or. (aVerbasFunc[nReg,3] == aCodFol[047,1])
					fSomaPdRec("B",aVerbasFunc[nReg,3],aVerbasFunc[nReg,6],aVerbasFunc[nReg,7])
				Endif
			Endif
		
			If (aVerbasFunc[nReg,3] $ aCodFol[10,1]+'*'+aCodFol[15,1]+'*'+aCodFol[27,1])
				nBaseIr += aVerbasFunc[nReg,7]
			ElseIf (aVerbasFunc[nReg,3] $ aCodFol[13,1]+'*'+aCodFol[19,1])
				nAteLim += aVerbasFunc[nReg,7]
			Elseif (aVerbasFunc[nReg,3] $ aCodFol[108,1]+'*'+aCodFol[17,1])
				nBaseFgts += aVerbasFunc[nReg,7]
			Elseif (aVerbasFunc[nReg,3] $ aCodFol[109,1]+'*'+aCodFol[18,1])
				nFgts += aVerbasFunc[nReg,7]
			Elseif (aVerbasFunc[nReg,3] == aCodFol[16,1])
				nBaseIrFe += aVerbasFunc[nReg,7]
			Endif
		Next nReg

	Elseif cRoteiro == "EXT"
		dbSelectArea("SR1")
		dbSetOrder(1)
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
			While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT ==	SR1->R1_FILIAL + SR1->R1_MAT
				If Semana # "99"
					If SR1->R1_SEMANA # Semana
						dbSkip()
						Loop
					Endif
				Endif
				If !Eval(cAcessaSR1)
					dbSkip()
					Loop
				EndIf
				If PosSrv( SR1->R1_PD , SRA->RA_FILIAL , "RV_TIPOCOD" ) == "1"
					fSomaPdRec("P",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
					TOTVENC = TOTVENC + SR1->R1_VALOR  
				Elseif SRV->RV_TIPOCOD == "2"
					fSomaPdRec("D",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
					TOTDESC = TOTDESC + SR1->R1_VALOR
				Elseif SRV->RV_TIPOCOD $ "3/4"
					fSomaPdRec("B",SR1->R1_PD,SR1->R1_HORAS,SR1->R1_VALOR)
				Endif
				dbskip()
			Enddo
		Endif
	Endif             
	     
	dbSelectArea("SRA")
	
	If TOTVENC = 0 .And. TOTDESC = 0
		dbSkip()
		Loop
	Endif
	             
	If Vez == 0 .And. cTipoRot == "1"	//--> Verifica se for FOLHA.
		PerSemana() // Carrega Datas referentes a Semana.
	EndIf
	
	/*If nTipRel == 1 .and. !( lTerminal )
		fImpressao()   // Impressao do Recibo de Pagamento
		IF !( lTerminal )
			If Vez = 0  .and. nTipRel # 3  .and. aReturn[5] # 1
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Descarrega teste de impressao                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				fImpTeste(cString)
				If !lRetCanc
					Exit
				Endif
				TotDesc := TotVenc := 0
				If nTipRel == 2 
					Loop
				Endif
				
			ENDIF
		EndIF
	ElseIf nTipRel == 2 .and. !( lTerminal )
		For nX := 1 to 1
			fImpreZebr()
		Next nX
		ASize(AProve,0)
		ASize(ADesco,0)
		ASize(aBases,0)      
	ElseIf nTipRel == 3 .or. lTerminal
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de entrada para alterar layout do recibo.				 |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ExistBlock("GP030HTM")
			cHtml := ExecBlock("GP030HTM",.F.,.F.)
		Else
			cHtml := fSendDPgto(lTerminal)   //Monta o corpo do e-mail e envia-o
		Endif*/
	If (nTipRel == 1 .OR. nTipRel == 2) .and. !( lTerminal ) //1 Visualizar o PDF 2 Enviar PDF por email
		fImprPDF(lPDFEmail)
		ASize(AProve,0)
		ASize(ADesco,0)
		ASize(aBases,0)    
	Endif
	
	dbSelectArea("SRA")
	SRA->( dbSkip() )
	TOTDESC := TOTVENC := 0
	
EndDo

If nTipRel == 1 .and. !( lTerminal )
	IF ( Type( "oPrinter" ) == "O" )
		oPrinter:Preview()
		oPrinter:EndPage()
		FreeObj(oPrinter)
		oPrinter := Nil
	ElseiF MV_PAR24 == 2
		MSGALERT( "Não foram localizados demonstrativos de pagamentos disponíveis para esta consulta.", "Atenção!" )
	EndIf
ElseIf nTipRel == 2 .and. !( lTerminal )	
	fEnvPDFEmail()
EndIf

IF !( lTerminal )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Termino do relatorio                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SRC")
	dbSetOrder(1)          // Retorno a ordem 1
	dbSelectArea("SRD")
	dbSetOrder(1)          // Retorno a ordem 1
	dbSelectArea("SRA")
	SET FILTER TO
	RetIndex("SRA")
	
	If !(Type("cArqNtx") == "U")
		fErase(cArqNtx + OrdBagExt())
	Endif
	
	Set Device To Screen
	
	If lEnvioOK
		APMSGINFO("Email enviado com Sucesso ")
	//ElseIf nTipRel== 3
	//	APMSGINFO("Email nao pode ser enviado ")
	EndIf
	SeTPgEject(.F.)
	nlin:= 0	
	//If aReturn[5] = 1 .and. (nTipRel == 1 .OR.  nTipRel == 2)
	//	Set Printer To
	//	Commit
	//	ourspool(wnrel)
	//Endif
	MS_FLUSH()
	
EndIF

Return( cHtml )


********************
Static Function PerSemana() // Pesquisa datas referentes a semana.
********************
Local aAreaRCF	:= RCF->(GetArea())
Local cChaveSem	:= ""  

dbSelectArea( "RCF" )
dbSetOrder(1)

If !Empty(Semana)
	// Turno do funcionario
	cChaveSem := StrZero(Year(dDataRef),4)+StrZero(Month(dDataRef),2)+SRA->RA_TNOTRAB  
	
	If !dbSeek(xFilial("RCF") + cChaveSem + Semana, .T. )
		cChaveSem := StrZero(Year(dDataRef),4)+StrZero(Month(dDataRef),2)+"@@@"
		If !dbSeek(xFilial("RCF") + cChaveSem + Semana  )
			HELP( " ",1,"GPCALEND",  )	// "Nao existe calendario cadastrado para a competencia,  Turno ou semana."
			Return(NIL)
		Endif
	Endif
	cSem_De  := DtoC(RCF->RCF_DTINI,'DDMMYY')
	cSem_Ate := DtoC(RCF->RCF_DTFIM,'DDMMYY')
EndIf

RestArea(aAreaRCF)

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fSomaPdRec³ Autor ³ R.H. - Mauro          ³ Data ³ 24.09.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Somar as Verbas no Array                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fSomaPdRec(Tipo,Verba,Horas,Valor)                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fSomaPdRec(cTipo,cPd,nHoras,nValor)

Local Desc_paga

Static lAglutPd // Sera utilizada em todas as chamadas da funcao fSomaPdRec()

If lAglutPd == Nil
	 lAglutPd := ( GetMv("MV_AGLUTPD",,"1") == "1" ) // 1-Aglutina verbas   2-Nao Aglutina
EndIf

Desc_paga := DescPd(cPd,Sra->Ra_Filial)  // mostra como pagto

If cTipo # 'B'
	//--Array para Recibo Pre-Impresso
	nPos := Ascan(aLanca,{ |X| X[2] = cPd })
	If nPos == 0 .Or. !lAglutPd
		Aadd(aLanca,{cTipo,cPd,Desc_Paga,nHoras,nValor})
	Else
		aLanca[nPos,4] += nHoras
		aLanca[nPos,5] += nValor
	Endif
Endif

//--Array para o Recibo Pre-Impresso
If cTipo = 'P'
	cArray := "aProve"
Elseif cTipo = 'D'
	cArray := "aDesco"
Elseif cTipo = 'B'
	cArray := "aBases"
Endif

nPos := Ascan(&cArray,{ |X| X[1] = cPd })
If nPos == 0 .Or. !lAglutPd
	Aadd(&cArray,{cPd+" "+Desc_Paga,nHoras,nValor })
Else
	&cArray[nPos,2] += nHoras
	&cArray[nPos,3] += nValor
Endif
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fInicia   ºAutor  ³Natie               º Data ³  04/12/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inicializa parametros para impressao                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function  fInicia(cString,nTipoRel)

If LastKey() = 27 .Or. nLastKey = 27
	Return  .F.
Endif

//If nTipoRel == 1 .OR. nTipoRel == 2
//	SetDefault(aReturn,cString)
//Endif

If LastKey() = 27 .OR. nLastKey = 27
	Return .F.
Endif

Return .T.

/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o	   ³fMontaDtTcf 	³Autor³Ricardo Duarte     ³ Data ³13/08/2004³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Retorna a data valida para a consulta do Terminal Consulta  ³
³          ³do Funcionario                                         		³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³<Vide Parametros Formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros³<Vide Parametros Formais>									³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Retorno   ³cHtml  														³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Uso	   ³GPER030       										    	³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Static Function fMontaDtTcf(cMesAno,nDia)

Local dDataValida
Default nDia := 0

dDataValida := stod(right(cMesAno,4)+left(cMesAno,2)+"01")
dDataValida := stod(right(cMesAno,4)+left(cMesAno,2)+strzero(f_UltDia(dDataValida),2))+nDia

return(dDataValida)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³f030Roteiro³ Autor ³ Tatiane Matias        ³ Data ³ 28/02/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Selecionar o Roteiro                               		   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ f030Roteiro()											   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function f030Roteiro(l1Elem, lTipoRet, lVExtras)          

Local cTitulo	:="Roteiro de Calculo"
Local nFor		:= 0
Local nElem		:= 0
Local MvPar
Local MvParDef	:=""
Local MvRetor	:= ""

Private aSit:={}
l1Elem := If (l1Elem = Nil , .F. , .T.)

DEFAULT lTipoRet 	:= .T.                    
DEFAULT lVExtras	:= .T.

cAlias := Alias() 					// Salva Alias Anterior

IF lTipoRet
	MvPar:=&(Alltrim(ReadVar()))	// Carrega Nome da Variavel do Get em Questao
	mvRet:=Alltrim(ReadVar())		// Iguala Nome da Variavel ao Nome variavel de Retorno
EndIF

dbSelectArea("SRY")
If dbSeek(cFilial)
	CursorWait()
	While !Eof() .And. SRY->RY_FILIAL == cFilial
		If !(SRY->RY_TIPO $ "3*4*G*J")
			Aadd(aSit, SRY->RY_CALCULO + " - " + Alltrim(SRY->RY_DESC))
			MvParDef += SRY->RY_CALCULO
		EndIf
		dbSkip()
	Enddo  
	If lVExtras
		Aadd(aSit, "EXT - Valores Extras")
		MvParDef += "EXT"
	EndIf
	CursorArrow()
Endif

IF lTipoRet
	IF f_Opcoes(@MvPar,cTitulo,aSit,MvParDef,,,l1Elem, GetSx3Cache("RY_CALCULO","X3_TAMANHO"))  // Chama funcao f_Opcoes
		CursorWait()
		For nFor := 1 To Len( mVpar ) Step 3
			IF ( SubStr( mVpar , nFor , 3 ) # "***" )
				mvRetor += SubStr( mVpar , nFor , 3 )
			Endif
		Next nFor
		&MvRet := Mvretor
		CursorArrow()	
	EndIF	
EndIF

dbSelectArea(cAlias) // Retorna Alias

Return( IF( lTipoRet , .T. , MvParDef ) )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fTrocaCar      ³ Autor ³ Alceu Pereira    ³ Data ³10/12/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Troca carecter da string passada como parametro            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GPER030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fTrocaCar(cTexto) 

Local aAcento:={}
Local aAcSubs:={}
Local cImpCar := Space(01)
Local cImpLin :=""
Local cAux 	  :=""
Local cAux1	  :=""   
Local nTamTxt := Len(cTexto)	
Local nCount  := 0
Local nPos
  
aAcento := 	{	"€","‡","","Å","…","†"," ","„","¦",;
					"É","ˆ","‚","¡","“","”","•","¢","§",;
					"£","a","b","c","d","e","f","g","h",;
					"i","j","k","l","m","n","o","p","q",;
					"r","s","t","u","v","x","z","w","y",;
					"A","B","C","D","E","F","G","H","I",;
					"J","K","L","M","N","O","P","Q","R",;
					"S","T","U","V","X","Z","W","Y","0",;
					"1","2","3","4","5","6","7","8","9",;
					"&"}

aAcSubs := 	{	"C","c","A","A","a","a","a","a","a",;
					"E","e","e","i","o","o","o","o","o",;
					"u","a","b","c","d","e","f","g","h",;
					"i","j","k","l","m","n","o","p","q",;
					"r","s","t","u","v","x","z","w","y",;
					"A","B","C","D","E","F","G","H","I",;
					"J","K","L","M","N","O","P","Q","R",;
					"S","T","U","V","X","Z","W","Y","0",;
					"1","2","3","4","5","6","7","8","9",;
					"E"}

For nCount :=1 TO Len(AllTrim(cTexto))
	cImpCar	:=SubStr(cTexto,nCount,1)
	cAux	:=Space(01)  
    nPos 	:= 0
	nPos 	:= Ascan(aAcento,cImpCar)
	If nPos > 0
		cAux := aAcSubs[nPos]
	Elseif (cAux1 == Space(1) .And. cAux == space(1)) .Or. Len(cAux1) == 0
		cAux :=	""
	EndIf		
    cAux1 	:= 	cAux
	cImpCar	:=	cAux
	cImpLin	:=	cImpLin+cImpCar

Next nCount

cImpLin := Left(cImpLin+Space(nTamTxt),nTamTxt)

Return cImpLin  

/************Impressão PDF**********************************************************************************************/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fImprPDF  ³ Autor ³ R.H. - Emerson Cmapos ³ Data ³30/06/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMRESSAO DO RECIBO EM PDF                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fImprPDF()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fImprPDF(lPDFEmail)
Local nConta 		:= 0
Local cPath		:= ""
Local cFile		:= ""
Local cEmail		:= ""
Local cIdentUni	:= ""

//Gerar o PDF na Tela
If ! lPDFEmail .AND. Empty(oPrinter)
	//oPrinter	:= FWMSPrinter():New(IIF( MV_PAR24==1,"Demonstrativo - " + AllTrim(SRA->RA_NOME),"GPER030" )  ,6,.F.,cPath,.T.,,,,,.F.)
	oPrinter	:= FWMSPrinter():New(IIF( MV_PAR24==1,"Demonstrativo_" + AllTrim(SRA->RA_MAT),"GPER030" )  ,6,.F.,cPath,.T.,,,,,.F.)
	oPrinter:lViewPDF 	:= .T.
EndIf

//Gerar o PDF no Servidor para enviar via email
If lPDFEmail
	cIdentUni	:= DtoS(date())+SUBSTR(TIME()	, 1, 2) +SUBSTR(TIME(), 4, 2) +SUBSTR(TIME(), 7, 2)+AllTrim(Str(Int(Seconds()))) 
	//cFile		:= SRA->RA_FILIAL+SRA->RA_MAT+dtos(dDataRef)+cIdentUni+"RecPag"  
	//cFile		:= "Demonstrativo - " + AllTrim(SRA->RA_NOME)
	cFile		:= "Demonstrativo_" + AllTrim(SRA->RA_MAT)
	oPrinter	:= FWMSPrinter():New(cFile  ,6,.F.,cPath,.T.,,,,,.F.)		
	oPrinter:lInJob 		:= .T.
	//cEmail		:= If(SRA->RA_RECMAIL=="S",SRA->RA_EMAIL,"")
	cEmail		:= If(SRA->RA_RECMAIL=="S",SRA->RA_EMAIL,"    ")
	aAdd(aEmail, {{SRA->RA_NOME, cEmail,If(SRA->RA_RECMAIL=="S",.T.,.F.)},SRA->RA_FILIAL,SRA->RA_MAT,dtos(dDataRef),cIdentUni,DTOS(SRA->RA_NASC),SRA->RA_CIC,SRA->RA_NOME})
EndIf

oPrinter:lServer 			:= .T.
oPrinter:SetResolution(75)
oPrinter:SetPortrait() //SetLandscape() // 
oPrinter:SetPaperSize(DMPAPER_A4)
oPrinter:SetMargin(60,60,60,60)
oPrinter:nDevice 			:= IMP_PDF
oPrinter:StartPage()

If li >= 60
	li := 0
Endif
//Cabeçalho
fCabPDF(oPrinter)
//Corpo
fLancPDF(oPrinter, nConta)

If lPDFEmail .or. MV_PAR24 == 1
	oPrinter:Preview()
	oPrinter:EndPage()
	//oPrinter:Print()                                                           
	FreeObj(oPrinter)
	oPrinter := Nil
Else
	oPrinter:EndPage()
EndIF

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fCabPDF   ³ Autor ³ R.H. - Emerson Campos ³ Data ³30/06/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMRESSAO Cabecalho em PDF                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fCabPDF()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fCabPDF(oPrinter)

Local cCodFunc	:= ""		//-- Codigo da Funcao do funcionario
Local cDescFunc	:= ""		//-- Descricao da Funcao do Funcionario
Local cDescCC	:= ""		//-- Descricao do Centro de Custo
Local nLi		:= 0
Local dDataPagto:= Ctod("//")
Local nSalario  := 0
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Carrega Funcao do Funcion. de acordo com a Dt Referencia     ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
fBuscaFunc(dDataRef, @cCodFunc, @cDescFunc   )

nLi += 30                                           
       
oPrinter:SayBitmap(012,050,"\SYSTEM\"+"lgrl01.bmp",080,025)
oPrinter:SayAlign(nLi-8,004,"Demonstrativo de Pagamento",oFont4N,585,005, /**/, 2, 1 )

nLi += 10

oPrinter:Box(  nLi+5, 001, nLi + 20, 585, "-4" ) // Borda da Primeira Linha

nLi += 15

oPrinter:Say(nLi,003,"Empresa: ",oFont2N,050,Rgb(70,130,180))	
oPrinter:Say(nLi,045, DESC_Fil,oFont10,,)	

nLi += 3

oPrinter:Box(  nLi+5, 001, nLi + 20, 585, "-4" ) // Borda da Segunda Linha
oPrinter:Line(nLi+5,445,nLi+20,445) // | Separador do CNPJ

nLi += 15
         
oPrinter:Say(nLi,003,"Endereço: " ,oFont2N,050,Rgb(70,130,180))
oPrinter:Say(nLi,045,Desc_End,oFont10,,)	

oPrinter:Say(nLi,450,"CNPJ:",oFont2N,050,Rgb(70,130,180))
oPrinter:Say(nLi,477,Transform( Desc_CGC , "@R 99.999.999/9999-99"),oFont10)

nLi += 3

oPrinter:Box(  nLi+5, 001, nLi + 20, 585, "-4" ) // Borda da Terceira Linha
oPrinter:Line(nLi+5,195,nLi+20,195) // | Separador do Banco/Agência/Conta:

nLi += 15

IF  cRoteiro <> "EXT"
	dDataPagto := PosAlias( "RCH" , (cProcesso+cPeriodo+Semana+cRoteiro) , SRA->RA_FILIAL , "RCH_DTPAGO")
EndIf

oPrinter:Say(nLi,003,"Crédito em:",oFont2N,050,Rgb(70,130,180))
oPrinter:Say(nLi,052,Dtoc(dDataPagto),oFont10,,)	

oPrinter:Say(nLi,200,"Banco/Agência/Conta:",oFont2N,050,Rgb(70,130,180))
oPrinter:Say(nLi,290,SubStr(SRA->RA_BCDEPSAL,1,3) + "/" + AllTrim(SubStr(SRA->RA_BCDEPSAL,4)) + "/" + SRA->RA_CTDEPSAL ,oFont10,,)	


nLi += 3

oPrinter:Box(  nLi+5, 001, nLi + 20, 585, "-4" ) // Borda da Quarta Linha

nLi += 15

If !Empty(Semana) .And. Semana # "99" .And.  Upper(SRA->RA_TIPOPGT) == "S"
	oPrinter:Say(nLi,003,"Referência:",oFont2N,050,Rgb(70,130,180))
	oPrinter:Say(nLi,052,"Sem." + Semana + " (" + cSem_De + " a " + cSem_Ate + ")",oFont10)
Else
	oPrinter:Say(nLi,003,"Referência:",oFont2N,050,Rgb(70,130,180))
	oPrinter:Say(nLi,052,MesExtenso(MONTH(dDataRef))+"/"+STR(YEAR(dDataRef),4) + " - ( Folha )",oFont10,,)		
EndIf

nLi += 3

oPrinter:Box(  nLi+5, 001, nLi + 20, 585, "-4" ) // Borda da Quinta Linha
oPrinter:Line(nLi+5,445,nLi+20,445) // | Separador da Matricula

nLi += 15

oPrinter:Say(nLi,003,"Nome:",oFont2N,050,Rgb(70,130,180))
oPrinter:Say(nLi,032,If( lLpt1, fTAcento(SRA->RA_NOME), SRA->RA_NOME ),oFont10,,)		

oPrinter:Say(nLi,450,"Matrícula:",oFont2N,050,Rgb(70,130,180))
oPrinter:Say(nLi,490,SRA->RA_MAT,oFont10)

nLi += 3

oPrinter:Box(  nLi+5, 001, nLi + 20, 585, "-4" ) // Borda da Sexta Linha
oPrinter:Line(nLi+5,145,nLi+20,145) // | Separador da Serie
oPrinter:Line(nLi+5,445,nLi+20,445) // | Separador do CPF

nLi += 15

oPrinter:Say(nLi,003,"CTPS:",oFont2N,050,Rgb(70,130,180))
oPrinter:Say(nLi,030,SRA->RA_NUMCP,oFont10,,)		

oPrinter:Say(nLi,150,"Série:",oFont2N,050,Rgb(70,130,180))
oPrinter:Say(nLi,175,SRA->RA_SERCP,oFont10,,)

oPrinter:Say(nLi,450,"CPF:",oFont2N,050,Rgb(70,130,180))
oPrinter:Say(nLi,472,Transform( SRA->RA_CIC , "@R 999.999.999-99"),oFont10)

nLi += 3

oPrinter:Box(  nLi+5, 001, nLi + 20, 585, "-4" ) // Borda da Setima Linha
oPrinter:Line(nLi+5,445,nLi+20,445) // | Separador do Salario Nominal

nLi += 15

oPrinter:Say(nLi,003,"Função:",oFont2N,050,Rgb(70,130,180))
oPrinter:Say(nLi,040,If( lLpt1, fTAcento(cDescFunc), cDescFunc ),oFont10,,)		

nSalario := fBuscaSal(dDataRef,,,.F.)
If nSalario == 0
	nSalario := SRA->RA_SALARIO
EndIf

oPrinter:Say(nLi,450,"Salário Nominal:",oFont2N,050,Rgb(70,130,180))
oPrinter:Say(nLi,510,Transform( nSalario , "@E 999,999,999.99"),oFont10,,)

nLi += 3

oPrinter:Box(  nLi+5, 001, nLi + 20, 585, "-4" ) // Borda da Oitava Linha

nLi += 15

cDescCC := If( lLpt1, fTAcento(DescCc(SRA->RA_CC,SRA->RA_FILIAL)), DescCc(SRA->RA_CC,SRA->RA_FILIAL) )

oPrinter:Say(nLi,003,"Centro de Custo:",oFont2N,050,Rgb(70,130,180))
oPrinter:Say(nLi,075,AllTrim(SRA->RA_CC) + " - " + cDescCC,oFont10,,)		

nLi += 3

oPrinter:Box(  nLi+5, 001, nLi + 20, 585, "-4" ) // Borda da Nona Linha
oPrinter:Line(nLi+5,145,nLi+20,145) // | Separador do Dep IR
oPrinter:Line(nLi+5,445,nLi+20,445) // | Separador do Dep Sal Familia

nLi += 15

oPrinter:Say(nLi,003,"Admissão:",oFont2N,050,Rgb(70,130,180))
oPrinter:Say(nLi,050,Dtoc( SRA->RA_ADMISSA ),oFont10,,)		

oPrinter:Say(nLi,150,"Dep. IR:",oFont2N,050,Rgb(70,130,180))
oPrinter:Say(nLi,190,SRA->RA_DEPIR,oFont10,,)

oPrinter:Say(nLi,450,"Dep. Sal. Família:",oFont2N,050,Rgb(70,130,180))
oPrinter:Say(nLi,520,SRA->RA_DEPSF,oFont10)

nLi += 18

oPrinter:Say(nLi,001,"Código",oFont2N,050,Rgb(70,130,180))

oPrinter:Say(nLi,040,"Descrição",oFont2N,050,Rgb(70,130,180))

oPrinter:Say(nLi,290,"Referência",oFont2N,050,Rgb(70,130,180))

oPrinter:Say(nLi,450,"Valores",oFont2N,050,Rgb(70,130,180))

oPrinter:Say(nLi,560,"(+/-)",oFont2N,050,Rgb(70,130,180))

ORDEMZ ++
nLi += 05
Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fLancPDF  ³ Autor ³ R.H. - Emerson Campos ³ Data ³01/07/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao das Verbas (Lancamentos) PDF                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fLancPDF()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fLancPDF(oPrinter, nConta)   // Impressao dos Lancamentos

Local nTermina  := 0
Local nCont    	:= 0
Local nCont1   	:= 0
Local nValidos  := 1
Local aPos     	:= {}
Local nSpace    := 0
Local cMsgAniv  := ""
Local nPosFCab	:= 240 //Posição final do cabeçalho fCabPDF()
Local nLi		:= nPosFCab

Local oBrushAzul := TBrush():New(,Rgb(245,245,245)) 

If ( Ascan(aProve , {|aProve| aProve[3] >= 1000000} ) > 0 ) 
	cPict3 := "@E 9999,999.99" // Variavel private criada na funcao R030Imp
  	aPos := {004,006,193,195,388,390,585}
  	nSpace := 1
Else  
  	cPict3 := "@E 999,999.99"
  	aPos := {004,006,195,197,390,392,585}  
EndIf
	
nTermina := LEN(aProve)+ LEN(aDesco)
	
For nCont :=1 To LEN(aProve)

	If nValidos == 27 .and. nTermina >= nValidos
		nLi += 20
		oPrinter:Box(  nLi+5, aPos[1], nLi+40, aPos[7], "-4" )
		nLi += 20		
		oPrinter:SayAlign(nLi-5,aPos[1],"CONTINUA !!!",oFont3,aPos[7],005, /**/, ALIGN_H_CENTER, ALIGN_V_CENTER )
		nLi += 20
		
		oPrinter:EndPage()
		oPrinter:StartPage()
			
		fCabPDF(oPrinter)
			
		nValidos := 1
			
		nLi := nPosFCab   //Posição final do cabeçalho fCabPDF()
		
	EndIf
	
	//Imprime Proventos

	If mod(nValidos,2)==1      
		oPrinter:FillRect({nLi-10, 001, nLi+5,585}, oBrushAzul) 		
	EndIF

	oPrinter:Say(nLi,001,SubStr(aProve[nCont,1],1,3),oFont10)
	oPrinter:Say(nLi,040,AllTrim(SubStr(aProve[nCont,1],4)),oFont10)	
	oPrinter:Say(nLi,290,TRANSFORM(aProve[nCont,2],'999.99'),oFont10)
	oPrinter:Say(nLi,450,TRANSFORM(aProve[nCont,3] ,cPict3 ),oFont10)                                 
	oPrinter:Say(nLi,560,"(+)",oFont10)	

	nLi += 15		
	
	nValidos ++	
	
Next nCont

For nCont :=1 To LEN(aDesco)

	If nValidos == 27 .and. nTermina >= nValidos
		nLi += 20
		oPrinter:Box(  nLi+5, aPos[1], nLi+40, aPos[7], "-4" )
		nLi += 20		
		oPrinter:SayAlign(nLi-5,aPos[1],"CONTINUA !!!",oFont3,aPos[7],005, /**/, ALIGN_H_CENTER, ALIGN_V_CENTER )
		nLi += 20
		
		oPrinter:EndPage()
		oPrinter:StartPage()
			
		fCabPDF(oPrinter)
			
		nValidos := 1
			
		nLi := nPosFCab   //Posição final do cabeçalho fCabPDF()
					
	EndIf

	//Imprime Descontos

	If mod(nValidos,2)==1      
		oPrinter:FillRect({nLi-10, 001, nLi+5,585}, oBrushAzul) 		
	EndIF

	oPrinter:Say(nLi,001,SubStr(aDesco[nCont,1],1,3),oFont10)
	oPrinter:Say(nLi,040,AllTrim(SubStr(aDesco[nCont,1],4)),oFont10)	
	oPrinter:Say(nLi,290,TRANSFORM(aDesco[nCont,2],'999.99'),oFont10)
	oPrinter:Say(nLi,450,TRANSFORM(aDesco[nCont,3] , cPict3 ),oFont10)
	oPrinter:Say(nLi,560,"(-)",oFont10)			

	nLi += 15
                           
	nValidos ++	
	
Next nCont
                
nLi += 10

If mod(nValidos,2)==1      
	oPrinter:FillRect({nLi-10, 001, nLi+5,585}, oBrushAzul) 		
EndIF

oPrinter:Say(nLi,001,"Total Bruto: ",oFont2N,050,Rgb(70,130,180))//dodgerblue
oPrinter:Say(nLi,450,TRANSFORM( TOTVENC,cPict3 ),oFont10)

nLi += 15	
nValidos ++	

If mod(nValidos,2)==1      
	oPrinter:FillRect({nLi-10, 001, nLi+5,585}, oBrushAzul) 		
EndIF

oPrinter:Say(nLi,001,"Total de Descontos: ",oFont2N,050,Rgb(70,130,180))
oPrinter:Say(nLi,450,TRANSFORM( TOTDESC,cPict3 ),oFont10)

nLi += 15	
nValidos ++	

If mod(nValidos,2)==1      
	oPrinter:FillRect({nLi-10, 001, nLi+5,585}, oBrushAzul) 		
EndIF

oPrinter:Say(nLi,001,"Líquido a Receber: ",oFont2N,050,Rgb(70,130,180))
oPrinter:Say(nLi,450,TRANSFORM( (TOTVENC-TOTDESC) , cPict3 ),oFont10)

nLi += 25
nValidos ++	
nValidos ++	

If mod(nValidos,2)==1      
	oPrinter:FillRect({nLi-10, 001, nLi+5,585}, oBrushAzul) 		
EndIF

oPrinter:Say(nLi,001,"Base FGTS/Valor FGTS:",oFont2N,050,Rgb(70,130,180))
oPrinter:Say(nLi,240,Transform(nBaseFgts,cPict3),oFont10)
oPrinter:Say(nLi,380,Transform(nFgts    ,cPict3),oFont10)

nLi += 15	
nValidos ++	

If mod(nValidos,2)==1      
	oPrinter:FillRect({nLi-10, 001, nLi+5,585}, oBrushAzul) 		
EndIF

oPrinter:Say(nLi,001,"Base IRRF Folha/Férias",oFont2N,050,Rgb(70,130,180))
oPrinter:Say(nLi,240,Transform(nBaseIr,cPict3),oFont10)
oPrinter:Say(nLi,380,Transform(nBaseIrfe,cPict3),oFont10)

nLi += 15	
nValidos ++	

If mod(nValidos,2)==1      
	oPrinter:FillRect({nLi-10, 001, nLi+5,585}, oBrushAzul) 		
EndIF

oPrinter:Say(nLi,001,"Base INSS",oFont2N,050,Rgb(70,130,180))
oPrinter:Say(nLi,240,Transform(nAteLim,cPict3),oFont10)

nLi += 20	
nValidos ++	

cMsgAniv := " 	                                     "	
IF MONTH(dDataRef) = MONTH(SRA->RA_NASC)
	cMsgAniv := Space(2)+"F E L I Z   A N I V E R S A R I O  ! "
ENDIF
	
oPrinter:SayAlign(nLi,005,Space(2)+cMsgAniv,oFont4N,585,005, , 2, 0 )	

nLi += 15
oPrinter:SayAlign(nLi,005,Space(2)+If( lLpt1 .And. !Empty(DESC_MSG1), fTAcento(DESC_MSG1), DESC_MSG1 ),oFont4,585,005,,2,0)   //Mensagem //8
nLi += 15
oPrinter:SayAlign(nLi,005,Space(2)+If( lLpt1 .And. !Empty(DESC_MSG2), fTAcento(DESC_MSG2), DESC_MSG2 ),oFont4,585,005,,2,0 )   //Mensagem //23
nLi += 15
oPrinter:SayAlign(nLi,005,Space(2)+If( lLpt1 .And. !Empty(DESC_MSG3), fTAcento(DESC_MSG3), DESC_MSG3 ),oFont4,585,005,,2,0)   //Mensagem //38
nLi += 15

oPrinter:Box(  nLi+5, 001, nLi + 40, 585, "-4" ) // Borda da Primeira Linha

nLi += 5

oPrinter:SayAlign(nLi,005,"  Válido como Comprovante Mensal de Rendimentos",oFont4,585,005, , 2, 0 )   //Mensagem
nLi += 15
oPrinter:SayAlign(nLi,005,"( Artigo no. 41 e 464 da CLT, Portaria MTPS/GM 3.626 de 13/11/1991 )",oFont4,585,005, , 2, 0 )   //Mensagem
	
nLi += 40
                                                                          
oPrinter:EndPage()
	
cPict3 := "@E 999,999.99"  // Restauro o valor original de cPict3, declarado na funcao R030Imp.

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ fEnvPDFEmail³ Autor ³ Emerson Campos     ³ Data ³09/07/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Prepara o envio do email com o PDF Anexado                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fEnvPDFEmail()

Local cEndSpool 	:= ""
Local nI				:= 0
Local cSubject		:= " Demosntrativo de Pagamento "
Local cMsg			:= ""
Local cPathFile		:= "" 
Local cMsgErr1		:= ""	//Erro envio
Local cMsgErr2		:= ""	//Sem email cadastrado
Local cMsgErr3		:= ""	//Opção não envia email habilitada

Private cEmailDP		:= NIL
Private cMailConta	:= NIL
Private cMailServer	:= NIL
Private cMailSenha	:= NIL
	
	// Busca parametros 
	cMailConta		:=If(cMailConta == NIL,GETMV("MV_EMCONTA"),cMailConta)             //Conta utilizada p/envio do email
	cMailServer		:=If(cMailServer == NIL,GETMV("MV_RELSERV"),cMailServer)           //Server
	cMailSenha		:=If(cMailSenha == NIL,GETMV("MV_EMSENHA"),cMailSenha)
	cEmailDP			:=If(cEmailDP == NIL,GETMV("MV_GPEMAIL"),cEmailDP)					//Email do responsável de Depto Pessoal
	
	// Verifica se existe o SMTP Server 
	If 	Empty(cMailServer)
		Help(" ",1,"SEMSMTP")//"O Servidor de SMTP nao foi configurado !!!" ,"Atencao"
		Return(.F.)
	EndIf
	
	// Verifica se existe a CONTA 
	If 	Empty(cMailConta)
		Help(" ",1,"SEMCONTA")//"A Conta do email nao foi configurado !!!" ,"Atencao"
		Return(.F.)
	EndIf
	
	// Verifica se existe a Senha
	If 	Empty(cMailSenha)
		Help(" ",1,"SEMSENHA")	//"A Senha do email nao foi configurado !!!" ,"Atencao"
		Return(.F.)
	EndIf
	
	For nI := 1 To Len(aEmail)

		cPathFile	:= "spool\Demonstrativo_" + AllTrim(aEmail[nI,3])
		cArqZip	:= "Demonstrativo_" + AllTrim(aEmail[nI,3])
 		cSenha		:= SubStr(aEmail[nI,6],7,2)+SubStr(aEmail[nI,6],5,2)+SubStr(aEmail[nI,6],1,4)+AllTrim(aEmail[nI,7])

		If !GeraZip(cPathFile,cArqZip,cSenha)
			//Alert("Nao Gerou o ZIP ")
		EndIf

		If aEmail[nI,1,3]
			If ! Empty(AllTrim(aEmail[nI,1,2]))
				cSubject	:= " Demosntrativo de Pagamento  - " + MesExtenso(MONTH(SToD(aEmail[nI,4])))+"/"+STR(YEAR(StoD(aEmail[nI,4])),4)
				
				cMsg := "Sr.(a)"+chr(13)+ "  " + aEmail[nI,1,1]+","+chr(10)
				cMsg += chr(13)+chr(10)
				cMsg += chr(13)+chr(10)
				cMsg += "Segue em anexo o seu demonstrativo referente a:"+" "+MesExtenso(MONTH(SToD(aEmail[nI,4])))+"/"+STR(YEAR(StoD(aEmail[nI,4])),4)+chr(13)+chr(10)
				cMsg += chr(13)+chr(10)
				cMsg += chr(13)+chr(10)
				cMsg += "Obs : Senha do arquivo - Data de Nascimento + CPF  ddmmaaaa99999999999"+chr(13)+chr(10)
				cMsg += chr(13)+chr(10)
				cMsg += chr(13)+chr(10)
				cMsg += "Atenciosamente,"+chr(13)+chr(10)
				
				// Envia e-mail p/funcionario 
				If !u_GPEMail(cSubject,"",aEmail[nI,1,2],cMsg,.t.,cPathFile+".zip")
				//If !GPEMail(cSubject,cMsg,aEmail[nI,1,2],{cPathFile+".pdf"})
					//Falha no envio
					cMsgErr1	+= "     " + aEmail[nI,2] + " - " + aEmail[nI,3] + " - " + aEmail[nI,1,1] + chr(13) + chr(10)
				EndIf				
			Else
				//Sem Email cadastrado
				cMsgErr2	+= "     " + aEmail[nI,2] + " - " + aEmail[nI,3] + " - " + aEmail[nI,1,1] + chr(13) + chr(10)
			EndIf
		Else
			//Marcado para não receber o email
			cMsgErr3	+= "     " + aEmail[nI,2] + " - " + aEmail[nI,3] + " - " + aEmail[nI,1,1] + chr(13) + chr(10)
		EndIf
		
		If File(cPathFile+".pdf")
			fErase(cPathFile+".pdf")
		EndIf
		
		If File(cPathFile+".rel")
			fErase(cPathFile+".rel")
		EndIf

		If File(cPathFile+".zip")
			fErase(cPathFile+".zip")
		EndIf


	Next nI
	
	If ! Empty(cEmailDP)
		If ! Empty(cMsgErr1) .OR. ! Empty(cMsgErr2)  .OR. ! Empty(cMsgErr2)
			cSubject	:= "Erros ocorridos durante o envio dos demonstrativos de pagamento"
			cMsg := "Sr.(a)"+"," + chr(13) + chr(10)	
			cMsg += chr(13) + chr(10)
			cMsg += chr(13) + chr(10)
			cMsg += "Ocorreram alguns erros durante o envio de demonstrativo de pagamento por email, veja a relação abaixo:" + chr(13) + chr(10)
			cMsg += chr(13) + chr(10)
			cMsg += chr(13) + chr(10)
			If ! Empty(cMsgErr1)
				cMsg += "- "+ "Erro durante o envio da mensagem" +chr(13)+chr(10)
				cMsg += cMsgErr1 + chr(13) + chr(10)
				cMsg += chr(13) + chr(10)
				cMsg += chr(13) + chr(10)
			EndIf
			If ! Empty(cMsgErr2)
				cMsg += "- "+ "Falta de endereço de email cadastrado para o envio:" +chr(13)+chr(10)
				cMsg += cMsgErr2 + chr(13) + chr(10)
				cMsg += chr(13) + chr(10)
				cMsg += chr(13) + chr(10)
			EndIf
			If ! Empty(cMsgErr3)
				cMsg += "- "+ "Marcado a opção de não receber email no caastro do funcionário:" +chr(13)+chr(10)
				cMsg += cMsgErr3 + chr(13) + chr(10)
				cMsg += chr(13) + chr(10)
				cMsg += chr(13) + chr(10)
			EndIf
			cMsg += "Atenciosamente,"+chr(13)+chr(10)

			u_GPEMail(cSubject,"",cEmailDP,cMsg,.t.)    
			//GPEMail(cSubject,cMsg,cEmailDP,{})
		EndIf
	EndIf 
Return Nil 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Scheddef    ³ Autor ³ Emerson Campos     ³ Data ³08/07/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Trazer o grupo de perguntas GPER030 quando houver schedule ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function SchedDef() 
	Local aParam
	Local aOrd     := {OemToAnsi(" Matrícula         ")}
	aParam := { "R",;      // Tipo R para relatorio P para processo   
				"GPER030",;	// Pergunte do relatorio, caso nao use passar ParamDef            
				"",;  	// Alias            
   				aOrd,;   	// Array de ordens   
				""}	
				  
Return aParam  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ limpArqPdf  ³ Autor ³ Emerson Campos     ³ Data ³08/07/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Limpar os arquivos PDF que são gerados pelo schedule       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function limpArqPdf()
Local cPath	:= "\spool\" //GetSrvProfString ("ROOTPATH","")+"\spool\"
	AEVAL(DIRECTORY(cPath+"*RecPag.pdf"), { |aFile| FERASE(cPath+aFile[1]) })	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³VALIDPERG º Autor ³ Marcelo Franca     º Data ³  23/02/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Verifica a existencia das perguntas criando-as caso seja   º±±
±±º          ³ necessario (caso nao existam).                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function ValidPerg(_cPerg)

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

SX1->(DbSetOrder(1))
_cPerg := PADR(_cPerg,10)

// Grupo/Ordem/Pergunta/PS/PE/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{_cPerg,"01","Processo ?"			,"¿Proceso ?"				,"Process ?"			,"mv_ch1","C",05,0,0,"G","Gpr040Valid(mv_par01)"									,"mv_par01",""		,""		,""		,"00001"							,"",""				,""				,""				,"","","","","","","","","","","","","","","","","RCJ"		,"",""		,".GPER03001."	})
aAdd(aRegs,{_cPerg,"02","Roteiro ?"				,"¿Procedimiento ?"			,"Script ?"				,"MV_CH2","C",03,0,0,"G","f030Roteiro() .and. Gpr040Roteiro()"						,"mv_par02",""		,""		,""		,"FOL"								,"",""				,""				,""				,"","","","","","","","","","","","","","","","",""			,"",""		,".GPER03002."	})
aAdd(aRegs,{_cPerg,"03","Periodo ?"				,"¿Periodo ?"	   			,"Period ?"				,"MV_CH3","C",06,0,0,"G","Gpr040Valid(mv_par01 + mv_par02 + mv_par03)"				,"mv_par03",""		,""		,""		,"201608"							,"",""				,""				,""				,"","","","","","","","","","","","","","","","","RCHAUS"	,"",""		,".GPER03003."	})
aAdd(aRegs,{_cPerg,"04","Numero de Pagamento ?"	,"¿Numero de pago ?"		,"Payment Number ?"		,"mv_ch4","C",02,0,0,"G","Gpr040Valid(mv_par01 + mv_par02 + mv_par03 + mv_par04)"	,"mv_par04",""		,""		,""		,"01"								,"",""				,""				,""				,"","","","","","","","","","","","","","","","",""			,"",""		,".RHNPA."		})
aAdd(aRegs,{_cPerg,"05","Tipo Impressão ?"		,"¿Imp. Prev/A rayas/Mail ?","Payment Number ?"		,"MV_CH5","C",01,0,1,"C",""															,"mv_par05","PDF"	,"PDF"	,"PDF"	,""									,"","e-Mail  PDF"	,"e-Mail  PDF"	,"e-Mail  PDF"	,"","","","","","","","","","","","","","","","",""			,"",""		,".RHTPREL."	})
aAdd(aRegs,{_cPerg,"06","Filial De ?"			,"¿De Sucursal ?"			,"From Branch ?"		,"MV_CH6","C",04,0,0,"G",""															,"mv_par06",""		,""		,""		,""									,"",""				,""				,""				,"","","","","","","","","","","","","","","","","XM0"		,"","033"	,".RHFILDE."	})
aAdd(aRegs,{_cPerg,"07","Filial Ate ?"			,"¿A Sucursal ?"			,"To Branch ?"			,"MV_CH7","C",04,0,0,"G","naovazio"													,"mv_par07",""		,""		,""		,"ZZZZ"								,"",""				,""				,""				,"","","","","","","","","","","","","","","","","XM0"		,"","033"	,".RHFILAT."	})
aAdd(aRegs,{_cPerg,"08","Centro de Custo De ?"	,"¿De Centro de Costo ?"	,"From Cost Center ?"	,"MV_CH8","C",09,0,0,"G",""												   			,"mv_par08",""		,""		,""		,""									,"",""				,""				,""				,"","","","","","","","","","","","","","","","","CTT"		,"","004"	,".RHCCDE."		})
aAdd(aRegs,{_cPerg,"09","Centro de Custo Ate ?"	,"¿A Centro de Costo ?"		,"To Cost Center ?"		,"MV_CH9","C",09,0,0,"G","naovazio"												   	,"mv_par09",""		,""		,""		,"ZZZZZZZZZ"						,"",""				,""				,""				,"","","","","","","","","","","","","","","","","CTT"		,"","004"	,".RHCCAT."		})
aAdd(aRegs,{_cPerg,"10","Matricula De ?"		,"¿De Matricula ?"			,"From Registration ?"	,"MV_CHA","C",06,0,0,"G",""												   			,"mv_par10",""		,""		,""		,"000146"							,"",""				,""				,""				,"","","","","","","","","","","","","","","","","SRA"		,"",""		,".RHMATD."		})
aAdd(aRegs,{_cPerg,"11","Matricula Ate ?"		,"¿A Matricula ?"			,"To Registration ?"	,"MV_CHB","C",06,0,0,"G","naovazio"												   	,"mv_par11",""		,""		,""		,"000146"							,"",""				,""				,""				,"","","","","","","","","","","","","","","","","SRA"		,"",""		,".RHMATA."		})
aAdd(aRegs,{_cPerg,"12","Nome De ?"				,"¿De Nombre ?"				,"From Name ?"			,"MV_CHC","C",30,0,0,"G",""												   			,"mv_par12",""		,""		,""		,""									,"",""				,""				,""				,"","","","","","","","","","","","","","","","",""			,"",""		,".RHNOMED."	})
aAdd(aRegs,{_cPerg,"13","Nome Ate ?"			,"¿A Nombre ?"				,"To Name ?"			,"MV_CHD","C",30,0,0,"G","naovazio"												   	,"mv_par13",""		,""		,""		,"ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"	,"",""				,""				,""				,"","","","","","","","","","","","","","","","",""			,"",""		,".RHNOMEA."	})
aAdd(aRegs,{_cPerg,"14","Chapa De ?"			,"¿De Placa ?"				,"From Reg.Badge ?"		,"MV_CHE","C",05,0,0,"G",""														   	,"mv_par14",""		,""		,""		,""									,"",""				,""				,""				,"","","","","","","","","","","","","","","","",""			,"",""		,".RHCHAPAD."	})
aAdd(aRegs,{_cPerg,"15","Chapa Ate ?"			,"¿A Placa ?"				,"To Reg.Badge ?"		,"MV_CHF","C",05,0,0,"G",""														   	,"mv_par15",""		,""		,""		,"ZZZZZ"							,"",""				,""				,""				,"","","","","","","","","","","","","","","","",""			,"",""		,".RHCHAPAT."	})
aAdd(aRegs,{_cPerg,"16","Mensagem 1 ?"			,"¿Mensaje 1 ?"				,"Message 1 ?"	   		,"MV_CHG","C",13,0,0,"G",""														   	,"mv_par16",""		,""		,""		,""									,"",""				,""				,""				,"","","","","","","","","","","","","","","","","S036"		,"",""		,".GPER03016."	})
aAdd(aRegs,{_cPerg,"17","Mensagem 2 ?"			,"¿Mensaje 2 ?"				,"Message 2 ?"			,"MV_CHH","C",13,0,0,"G",""														   	,"mv_par17",""		,""		,""		,""									,"",""				,""				,""				,"","","","","","","","","","","","","","","","","S036"		,"",""		,".GPER03017."	})
aAdd(aRegs,{_cPerg,"18","Mensagem 3 ?"			,"¿Mensaje 3 ?"				,"Message 3 ?"			,"MV_CHI","C",13,0,0,"G",""														   	,"mv_par18",""		,""		,""		,""									,"",""				,""				,""				,"","","","","","","","","","","","","","","","","S036"		,"",""		,".GPER03018."	})
aAdd(aRegs,{_cPerg,"19","Situacoes a Imp. ?"	,"¿Situaciones por Imp. ?"	,"Status to Print ?"	,"MV_CHJ","C",05,0,0,"G","fSituacao"												,"mv_par19",""		,""		,""		," ADFT"							,"",""				,""				,""				,"","","","","","","","","","","","","","","","",""	   		,"",""		,".RHSITUA."	})
aAdd(aRegs,{_cPerg,"20","Categorias a Imp. ?"	,"¿Categorias por Imp. ?"	,"Categories to Print ?","MV_CHK","C",15,0,0,"G","fCategoria"											   	,"mv_par20",""		,""		,""		,"M**************"					,"",""				,""				,""				,"","","","","","","","","","","","","","","","",""			,"",""		,".RHCATEG."	})
aAdd(aRegs,{_cPerg,"21","Imprime Bases ?"		,"¿Imprime bases ?"			,"Print Bases ?"		,"MV_CHL","C",01,0,1,"C",""														   	,"mv_par21","Sim"	,"Si"	,"Yes"	,""									,"","Nao"			,"No"			,"No"			,"","","","","","","","","","","","","","","","",""			,"",""		,".GPR03020."	})
aAdd(aRegs,{_cPerg,"22","Depto. De ?"			,"¿De depto ?"				,"Departm. From ?"		,"MV_CHM","C",09,0,0,"G",""														   	,"mv_par22",""		,""		,""		,""									,"",""				,""				,""				,"","","","","","","","","","","","","","","","","SQB"		,"","025"	,".RHDPTDE."	})
aAdd(aRegs,{_cPerg,"23","Depto. Ate ?"			,"¿A depto ?"				,"Departm. To ?"		,"MV_CHN","C",09,0,0,"G",""														   	,"mv_par23",""		,""		,""		,"ZZZZZZZZZ"						,"",""				,""				,""				,"","","","","","","","","","","","","","","","","SQB"		,"","025"	,".RHDPTAT."	})
aAdd(aRegs,{_cPerg,"24","Quebra p/ Func. ?"		,"¿Division p/ Func. ?"		,"Breakage p/ Func. ?"	,"MV_CHO","N",01,0,2,"C",""														   	,"mv_par24","Sim"	,"Si"	,"Yes"	,""									,"","Nao"			,"No"			,"No"			,"","","","","","","","","","","","","","","","",""			,"",""		,".GPER03024."	})

For i:=1 to Len(aRegs)
	If SX1->(!DbSeek(_cPerg+aRegs[i,2]))

		DbSelectArea("SX1") 
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		SX1->(MsUnlock())
		
	Endif
Next

dbSelectArea(_sAlias)

Return

/*
- MV_RELACNT = holerite@mindlab-brasil.com.br
- MV_RELAPSW = rhml!@#321
- MV_RELAUSR = holerite@mindlab-brasil.com.br
- MV_RELAUTH = .F. 
- MV_RELFROM = holerite@mindlab-brasil.com.br
- MV_RELPSW = rhml!@#321
- MV_RELSERV = email-ssl.com.br:465
- MV_RELTIME = 120
- MV_WFSMTP = email-ssl.com.br:465      995
- MV_WFTCONN = 2
If !GPEMail(cSubject,cRemetente,aEmail[nI,1,2],cMsg,.t.,cPathFile+".pdf")

GPEMail(cSubject,cRemetente,cEmailDP,cMsg,.t.)    
*/

User Function GPEMail(cAssunto,cRemetente,cDestinatario,cMensagem,lMensagem,cArquivo,cCopia)

	Local cMailServer   	:= Alltrim(GetMV("MV_EMSMTP"))        					// substituir por servidor de e-mail  	mail.ita.locaweb.com.br:587
	Local cMailConta    	:= Alltrim(GetMV("MV_EMCONTA"))       					// substituir por conta de e-mail 		protheus@volta.ind.br
	Local cMailSenha    	:= Alltrim(GetMV("MV_EMSENHA"))        					// substituir pela senha da conta 		081sue06
	Local oServer
	Local oMessage
	Local nPortaSMTP    	:= 465
	Local xRet          	:= 0
	Local cMsg          	:= ""
	Local nPosPorta 	  	:= 0

	Default cArquivo 		:= ""
	Default cCopia   		:= ""

	If Empty(cRemetente)
		cRemetente	:= cMailConta  //Alltrim(GetMV("MV_RELFROM"))
	EndIf

	//Verifica se a porta foi informada no servidor smtp
	nPosPorta := At(":",cMailServer)
	If nPosPorta <> 0
		nPortaSMTP		:= Val(substr(cMailServer,nPosPorta+1))
       	cMailServer 	:= left(cMailServer,nPosPorta-1)
	EndIf

	//Alert(cMailServer+" "+cMailConta+" "+cMailSenha+" "+str(nPortaSMTP)) 

  	//Cria a conexão com o server STMP ( Envio de e-mail )
	oServer := TMailManager():New()
	oServer:SetUseSSL( .F. )
	oServer:SetUseTLS( .T. )
	oServer:Init( "", cMailServer, cMailConta, cMailSenha, 0, nPortaSMTP )
   
  	//seta um tempo de time out com servidor de 1min
	If oServer:SetSmtpTimeOut( 60 ) != 0
		If lMensagem
			MsgAlert("Falha ao setar o time out","Atencao")
		Else
			Conout( "Falha ao setar o time out" )
		Endif
		Return .F.
	EndIf
   
  	//realiza a conexão SMTP
	If oServer:SmtpConnect() != 0
		If lMensagem
			MsgAlert("Falha ao conectar no servidor SMTP","Atencao")
		Else
			Conout( "Falha ao conectar no servidor SMTP" )
		Endif
		Return .F.
	EndIf

	// authenticate on the SMTP server (if needed)
	xRet := oServer:SmtpAuth( cMailConta, cMailSenha )
	if xRet <> 0
		cMsg := "Falha na authenticate no SMTP server: " + oServer:GetErrorString( xRet )
		If lMensagem
			MsgAlert(cMsg,"Atencao")
		Else
			Conout( cMsg )
		Endif
		oServer:SMTPDisconnect()
		return .f.
	endif
   
  	//Apos a conexão, cria o objeto da mensagem
	oMessage := TMailMessage():New()
   
  	//Limpa o objeto
	oMessage:Clear()
   
  	//Popula com os dados de envio
	oMessage:cFrom              := cRemetente
	oMessage:cTo                := cDestinatario
	oMessage:cCc                := cCopia
	oMessage:cBcc               := ""
	oMessage:cSubject           := cAssunto
	oMessage:cBody              := cMensagem
   
  	//Adiciona um attach
	If !Empty(cArquivo)
		If oMessage:AttachFile( cArquivo ) < 0
			If lMensagem
				MsgAlert("Erro ao atachar o arquivo","Atencao")
			Else
				Conout( "Erro ao atachar o arquivo" )
			Endif
			Return .F.
		Else
      	//adiciona uma tag informando que é um attach e o nome do arq
			oMessage:AddAtthTag( 'Content-Disposition: attachment; filename='+cArquivo+'')
		EndIf
	EndIf

  	//Envia o e-mail
	xRet := oMessage:Send( oServer )
	if xRet <> 0
		cMsg := "Erro ao enviar o e-mail: " + oServer:GetErrorString( xRet )
		If lMensagem
			MsgAlert(cMsg,"Atencao")
		Else
			Conout( cMsg )
		Endif
		Return .F.
	endif
   
  	//Desconecta do servidor
	If oServer:SmtpDisconnect() != 0
		If lMensagem
			MsgAlert("Erro ao disconectar do servidor SMTP","Atencao")
		Else
			Conout( "Erro ao disconectar do servidor SMTP" )
		Endif
		Return .F.
	EndIf

	//If lMensagem
	//	MsgInfo("EMail enviado com sucesso !!!","Sucesso")
	//Else
	//	Conout( "EMail enviado com sucesso !!!" )
	//Endif

   
Return .T.


Static Function GeraZIP(cPathFile,cArqZip,cSenha)

	//Local cPathRoot	:= GetSrvProfString ("ROOTPATH","")
 	Local cTempPath := GetTempPath(.T.)		//pasta TEMP do usuario
	Local cPathZip	:= "\holerites\"
	Local cComando 	:= "7z.exe a -tzip -p"+cSenha+" "+cArqZip+".zip "+cTempPath+cArqZip+".pdf"
	Local lOk		:= .t.      
	Local lCompacta := .T.

	Iif(File(cPathZip+"7z.exe")		,CpyS2T(cPathZip+"7z.exe"		,cTempPath,lCompacta),nil)  
	Iif(File(cPathZip+"7-zip.dll")	,CpyS2T(cPathZip+"7-zip.dll"	,cTempPath,lCompacta),nil)  
	Iif(File(cPathZip+"7z.dll")	   ,CpyS2T(cPathZip+"7z.dll"	   ,cTempPath,lCompacta),nil)  
	Iif(File("\"+cPathFile+".pdf")	,CpyS2T("\"+cPathFile+".pdf"	,cTempPath,lCompacta),nil)  

	nRet := WaitRun(cTempPath+cComando, 1 )
           
	Iif(File(cTempPath+cArqZip+".zip"),CpyT2S(cTempPath+cArqZip+".zip","\spool"	,lCompacta),nil)  
	Iif(File(cTempPath+cArqZip+".pdf"),FErase(cTempPath+cArqZip+".pdf"),Nil)
	Iif(File(cTempPath+cArqZip+".zip"),FErase(cTempPath+cArqZip+".zip"),Nil)

	If nRet = 0
		lOk := .t.
	//	Alert("Executou ok")
      Else
		lOk := .f.
	//	Alert("nao Executou ok")
    EndIf	

Return(lOk)



//Email/Usuário: holerite@mindlab.com.br
//Servidor SMTP: smtp.mailgun.org 
//Porta: 465 ou 587 SSL/TLS
//Senha: #3@946S3Q&AY