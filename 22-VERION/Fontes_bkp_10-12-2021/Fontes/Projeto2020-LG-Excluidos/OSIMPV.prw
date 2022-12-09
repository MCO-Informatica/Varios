#INCLUDE "rwmake.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "TBICODE.CH"
#INCLUDE "SHELL.CH"

/*/
+---------------------------------------------------------------------------+
| Programa  ³ XMLCCE   º Autor ³                    º Data ³        2012    |
+---------------------------------------------------------------------------+
| Descricao ³ Carta de correção			                                    |
+---------------------------------------------------------------------------+
| Uso       ³ FATURAMENTO                                                   |
|           ³                                                               |
|           ³ ESTE PROGRAMA EMITE A CARTA DE CORRECAO ELETRONICA BASEADO    |
|           ³ NAS TABELAS SPED050 E SPED150, E UTILIZA DUAS SP (STORED      |
|           ³ PROCEDURES) PARA BUSCAR OS DADOS DESSAS TABELAS               |
|           ³                                                               |
|           ³ **** ATENCAO ****                                             |
|           ³ OLHE AS ROTINAS DE FORMATACAO DE TEXTO NO FINAL DESTE PROGRAMA|
+---------------------------------------------------------------------------+
/*/
User Function OSIMPV()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Tamanho  := "P"
wnRel    := 'OSIMPV'
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",0 }
nLastKey := 0
nTipo    := 18
cString  :="SZA"
lEnd     :=.F.
cDesc1   := "Este relatorio ira imprimir a ORDEM DE SERVIÇO"
cDesc2   := ""
cDesc3   := ""
cPerg    := ""
nomeprog := "OSIMPV"
nLastKey := 0
cabec1   := ""
cabec2   := ""
m_pag    := 01
aResult  := {}
aLinhas  := {}
vQuery   := ""
_cTitArq := ""
NmBanco  := ""

// CRIACAO DE PERGUNTAS
cPerg	 := Padr( "OSIMPV", LEN( SX1->X1_GRUPO ) )
XACOS    := 0
ValidPerg(cPerg)

IF !Pergunte(cPerg,.T.)
	Return
Endif

titulo   := "ORDEM DE SERVIÇO"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Mv_par01  -  OS                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa({|| GeraOSS()},"Gera Dados para impressão")
RptStatus({|| ImpOSS()},"Imprimindo Relatório")
Return

//==============================================//
//    GERA OS DADAS DA IMPRESSAO                //
//==============================================//
Static Function GeraOSS()
_CNROS  := mv_par01
_AQRD1   := {}  // QUADRO 01 - ORDEM DE SERVICO
_AQRD2   := {}  // QUADRO 02 - SERVICO EXECUTADO
_AQRD3   := {}  // QUADRO 03 - TESTE
_AQRD4   := {}  // QUADRO 04 - MODIFICACAO
_AQRD5   := {}  // QUADRO 05 - RELATORIO
_AQRD6   := {}  // QUADRO 06 - OBSERVACOES
_AQRD7   := {}  // QUADRO 07 - AREA ENVOLVIDA

// DADOS DO QUADRO 01 - ORDEM DE SERVICO - TABELA SZA
DBSELECTAREA("SZA")
DBSETORDER(1)
IF DBSEEK(XFILIAL("SZA")+_CNROS)
   AADD(_AQRD1,{ZA_IDOS,ZA_CLIENTE,ZA_LOJA,ZA_NOME,ZA_PLANILH,ZA_EMISSAO,ZA_HORAINI,ZA_HORAPRV,ZA_TERMINI,ZA_DTFIM,ZA_EQUIPAM,ZA_DESCEP,ZA_DEFEITO,ZA_NFE,ZA_SERIE,ZA_COMERCI,ZA_ALMOXIR,ZA_OFICINA,ZA_OBSERVA,ZA_DTINICI,ZA_DTPREVI,ZA_PEDVEND,ZA_OP,ZA_TIPO,ZA_XIDOSMA,ZA_XIDOSFI,ZA_VEND,ZA_NOMVED,ZA_OPERADO,ZA_NOMEOPE})
   XACOS := 1
ENDIF

// DADOS DO QUADRO 02 - SERVICO EXECUTADO - TABELA SZB
DBSELECTAREA("SZB")
DBSETORDER(1)
IF DBSEEK(XFILIAL("SZB")+_CNROS)
   WHILE !EOF() .AND. _CNROS == SZB->ZB_IDOS
         AADD(_AQRD2,{ZB_IDOS,ZB_SERVICO,ZB_DESCSR,ZB_QTDADE,ZB_PRODUTO,ZB_DESCRIC,ZB_OBS,ZB_XIDOSMA,ZB_XIDOSFI})
         DBSELECTAREA("SZB")
         DBSKIP()
         LOOP
   END   		
ENDIF

// DADOS DO QUADRO 03 - TESTE - TABELA SZC
DBSELECTAREA("SZC")
DBSETORDER(1)
IF DBSEEK(XFILIAL("SZC")+_CNROS)
   WHILE !EOF() .AND. _CNROS == SZC->ZC_IDOS
         AADD(_AQRD3,{ZC_IDOS,ZC_TESTE,ZC_VAZAO,ZC_RPM,ZC_PRES001,ZC_PRES002,ZC_PRES003,ZC_PRES004,ZC_PRES005,ZC_DRENO,ZC_VALALIV,ZC_PILOTO,ZC_PRESCAR,ZC_TEMPERA,ZC_DTINICI,ZC_HRINI,ZC_DTFIM,ZC_HRFIM,ZC_HRREAL,ZC_OUTROS,ZC_XIDOSMA,ZC_XIDOSFI})
         DBSELECTAREA("SZC")
         DBSKIP()
         LOOP
   END   		
ENDIF

// DADOS DO QUADRO 04 - MODIFICACAO - TABELA SZD
DBSELECTAREA("SZD")
DBSETORDER(1)
IF DBSEEK(XFILIAL("SZD")+_CNROS)
   WHILE !EOF() .AND. _CNROS == SZD->ZD_IDOS
         AADD(_AQRD4,{ZD_IDOS,ZD_QTDSAI,ZD_PRODUTO,ZD_DESCSAI,ZD_QTDEENT,ZD_PRODENT,ZD_DESCENT,ZD_OBS,ZD_XIDOSMA,ZD_XIDOSFI,ZD_TPOPERA})
         DBSELECTAREA("SZD")
         DBSKIP()
         LOOP
   END   		
ENDIF

// DADOS DO QUADRO 05 - RELATORIO - TABELA SZE
DBSELECTAREA("SZE")
DBSETORDER(1)
IF DBSEEK(XFILIAL("SZE")+_CNROS)
   WHILE !EOF() .AND. _CNROS == SZE->ZE_IDOS
         AADD(_AQRD5,{ZE_IDOS,ZE_EMISSAO,ZE_HORAINI,ZE_HORAFIM,ZE_FUNC,ZE_NOME,ZE_OBS,ZE_XIDOSMA,ZE_XIDOSFI})
         DBSELECTAREA("SZE")
         DBSKIP()
         LOOP
   END   		
ENDIF

Return(.t.)       

//============================================//
// IMPRESSAO DO FORMULARIO - ORDEM DE SERVICO //
//============================================//
Static Function ImpOSS()
nLin       := 10000
nCol	   := 800
nPage	   := 1
nHeight    := 08
lBold	   := .F.
lUnderLine := .F.
lPixel	   := .T.
lPrint	   := .F.
aUF        := {}
cParX      := ""

*------------------------------*
* Define Fontes a serem usados *
*------------------------------*
//oFont	:= TFont():New( "Arial"  ,,_xsize ,,_xnegrito,,,,, lUnderLine )
oFtA07	:= TFont():New( "Arial"  ,,07     ,,.f.      ,,,,, .f.  )
oFtA07N	:= TFont():New( "Arial"  ,,07     ,,.t.      ,,,,, .f.  )
oFtA08	:= TFont():New( "Arial"  ,,08     ,,.f.      ,,,,, .f.  )
oFtA08N	:= TFont():New( "Arial"  ,,08     ,,.t.      ,,,,, .f.  )
oFtA09	:= TFont():New( "Arial"  ,,09     ,,.f.      ,,,,, .f.  )
oFtA09N	:= TFont():New( "Arial"  ,,09     ,,.t.      ,,,,, .f.  )
oFtA10	:= TFont():New( "Arial"  ,,10     ,,.f.      ,,,,, .f.  )
oFtA10N	:= TFont():New( "Arial"  ,,10     ,,.t.      ,,,,, .f.  )
oFtA12	:= TFont():New( "Arial"  ,,12     ,,.f.      ,,,,, .f.  )
oFtA12N	:= TFont():New( "Arial"  ,,12     ,,.t.      ,,,,, .f.  )
oFtA14	:= TFont():New( "Arial"  ,,14     ,,.f.      ,,,,, .f.  )
oFtA14N	:= TFont():New( "Arial"  ,,14     ,,.t.      ,,,,, .f.  )

nLin := 3000

lAdjustToLegacy := .F.
lDisableSetup   := .T.
_cTitArq        := MV_PAR01  // ORDEM DE SERVICO

oPrn := FWMSPrinter():New(_cTitArq, 6, lAdjustToLegacy, , lDisableSetup)
oPrn:LPDFASPNG := .F.
oPrn:SetResolution(72)
oPrn:SetPortrait()
oPrn:SetPaperSize(9)  // a4
oPrn:SetMargin(60,60,60,60) // nEsquerda, nSuperior, nDireita, nInferior
oPrn:cPathPDF := "C:\ARQS\" // Caso seja utilizada impressão em IMP_PDF

If nLin > 480
	QDR01()
Endif

//oPrn:Say(nLin ,0180 ,"ORDEM DE SERVIÇO",oFta14N, 100 )
//nlin+=40
//oPrn:Box(118,0005,360,0570)  // quadro geral
//oPrn:Box(118,0005,148,0570)  // quadro serie/nota/emissao
//oPrn:Box(148,0005,210,0570)  // quadro cnpj/chave/orgao
//oPrn:Box(210,0005,239,0570)  // quadro ambiente/id/data-hora
//oPrn:Box(239,0005,275,0570)  // quadro cod evento/seq/protocolo
//oPrn:Box(275,0005,305,0570)  // quadro INFORMAÇÕES DA CARTA DE CORREÇÃO
//oPrn:Box(340,0005,360,0570)  // quadro TEXTO DA CARTA DE CORREÇÃO

//oPrn:Line(118,0115,275,0115)    // linha de vertical  (NF/CHAVE/ID/SEQ)
//oPrn:Line(239,0205,275,0205)    // linha de vertical  (PROTOCOLO)
//oPrn:Line(118,0455,275,0455)    // linha de vertical  (EMISSAO/DATA/VERSAO)

//oPrn:Say(nLin ,0010 ,"Serie/Nota Fiscal" ,oFta12, 100 )
//oPrn:Say(nLin ,0120 ,"Nome/Razão Social" ,oFta12, 100 )
//oPrn:Say(nLin ,0460 ,"Emissão Nota"      ,oFta12, 100 )
//nlin+=10
//oPrn:Say(nLin ,0010 ,MV_PAR01            ,oFta12, 100 )

cClEX       := ""
cLjEX       := ""
cTpEX       := ""
cParX    	:= ""

//oPrn:Say(nLin ,0120 ,cParX  , 	oFta12, 100 )
//oPrn:Say(nLin ,0460 ,DTOC(DDATABASE), 	oFta12, 100 )
//nlin+=20
//oPrn:Say(nLin ,0010 ,"CNPJ"                    , 	oFta12, 100 )
//oPrn:Say(nLin ,0120 ,"Chave de Acesso da NF-E" ,	oFta12, 100 )
//oPrn:Say(nLin ,0460 ,"Orgão"                   ,	oFta12, 100 )
//nlin+=10
//oPrn:Say(nLin ,0010 ,"A"                 ,oFta12, 100 )
//oPrn:Say(nLin ,0120 ,"A"                 ,oFtA12, 100)
//oPrn:Say(nLin ,0460 ,"A"                 ,oFta12, 100 )
//nlin+=30
//oPrn:Code128C(nlin, 0120,SUBSTRING(aResult[3],9,44), 28 )
//nlin+=20
//oPrn:Say(nLin ,0010 ,"Ambiente"  , 	oFta12, 100 )
//oPrn:Say(nLin ,0120 ,"Id"        ,	oFta12, 100 )
//oPrn:Say(nLin ,0460 ,"Data/Hora" ,  oFta12, 100 )
//nlin+=10
//oPrn:Say(nLin ,0010 ,"A"  ,	oFta12, 100 )
//oPrn:Say(nLin ,0120 ,"A"  ,	oFta12, 100 )
//oPrn:Say(nLin ,0460 ,"A"  ,	oFta12, 100 )
//nlin+=25
//oPrn:Say(nLin ,0010 ,"Cod. Evento"  ,	oFta12, 100 )
//oPrn:Say(nLin ,0120 ,"Seq. Evento"  ,	oFta12, 100 )
//oPrn:Say(nLin ,0230 ,"Protocolo"    ,	oFta12, 100 )
//oPrn:Say(nLin ,0460 ,"Versão Evento",	oFta12, 100 )
//nlin+=10
//oPrn:Say(nLin ,0010 ,"A", 	oFta12, 100 )
//oPrn:Say(nLin ,0120 ,"A", 	oFta12, 100 )
//oPrn:Say(nLin ,0230 ,"A", 	oFta12, 100 )
//oPrn:Say(nLin ,0460 ,"A", 	oFta12, 100 )
//nlin+=30
//oPrn:Say(nLin ,0190 ,"INFORMAÇÕES DA CARTA DE CORREÇÃO",		oFta12N, 100 )
//nlin+=20
//oPrn:Say(nLin ,0010 ,"Versão",			oFta12, 100 )
//oPrn:Say(nLin ,0210 ,"Descr. Evento",	oFta12, 100 )
//nlin+=10
//oPrn:Say(nLin ,0010 ,"A", 	oFta12, 100 )
//oPrn:Say(nLin ,0210 ,"A", 	oFta12, 100 )
//nlin+=30
//oPrn:Say(nLin ,0190 ,"TEXTO DA CARTA DE CORREÇÃO",			oFta12N, 100 )
//nlin+=20
//oPrn:Line(nLin-20,0005,nLin+10,0005)    // linha de vertical
//oPrn:Line(nLin-20,0570,nlin+10,0570)    // linha de vertical

/*
vTexto := u_FormatText(aResult[15], 100, aLinhas)

For vInd := 1 to len(aLinhas)
	oPrn:Line(nLin,0005,nLin+10,0005)    // linha de vertical
	oPrn:Say(nLin ,0010 ,aLinhas[vInd, 1], 	oFta12, 100 )  // impresao do que foi corrigido na nota
	oPrn:Line(nLin,0570,nlin+10,0570)    // linha de vertical
	nlin+=10
Next
*/

//aLinhas := {}
//nLin +=30
//oPrn:Line(nLin-30,0005,nLin+10,0005)    // linha de vertical
//oPrn:Line(nLin-30,0570,nlin+10,0570)    // linha de vertical
//oPrn:Box(NLIN-15,0005,NLIN+5,0570)  // quadro CONDICOES
//oPrn:Say(nLin ,0190 ,"CONDIÇÕES DE USO DA CARTA DE CORREÇÃO",	oFta12N, 100 )
//nlin+=20
//oPrn:Line(nLin-20,0005,nLin+10,0005)    // linha de vertical
//oPrn:Line(nLin-20,0570,nlin+10,0570)    // linha de vertical

/*
vTexto := u_FormatText(aResult[16], 130, aLinhas)

For vInd := 1 to len(aLinhas)
	oPrn:Line(nLin,0005,nLin+10,0005)    // linha de vertical
	oPrn:Say(nLin ,0010 ,aLinhas[vInd, 1], 	oFta12, 100 )
	oPrn:Line(nLin,0570,nlin+10,0570)    // linha de vertical
	nlin+=10
Next
*/

//oPrn:Say(nLin-1,0005,Replicate("_",108),oFta12)

oPrn:SaveAllasJpeg("C:\ARQS\"+_cTitArq,1500,1500)

SetPgEject(.F.) // Funcao pra não ejetar pagina em branco
oPrn:Setup()   // para configurar impressora - comentar se quiser gerar o PDF direto.
oPrn:Preview() // Visualiza relatorio na tela
	//	oPrn:Print() // Visualiza relatorio na tela
Ms_Flush()
Return .T.

//========================================//
//    QUADRO 01 - ORDEM DE SERVICO        //
//========================================//
Static function QDR01()
_cNomLogo := FisxLogo("1")
_nLarg    := 150  //ajusta a largura do logo
_nAlt     := 35   //ajusta a altura do logo

If nlin < 10000
   oPrn:EndPage()
   oPrn:StartPage()
Endif

oPrn:Box(020,000,360,570)  // quadro 01
nLin := 30
oPrn:SayBitmap(nlin,0010,_cNomLogo,_nLarg,_nAlt )
oPrn:Say( nLin, 0200 , "ORDEM DE SERVIÇO"        , oFtA12N , 100 )
oPrn:Say( nLin, 0495 , "NR " + _AQRD1[1]         , oFtA12N , 100 )

//nLin += 5
//oPrn:Say( nLin+5, 0495 , "Data : " + Dtoc(dDataBase)   , oFtA07 , 100 )
//nLin += 10
//oPrn:Say( nLin+5, 0495 , "Pagina : " + StrZero(npage,3)     , oFtA07 , 100 )
//nLin += 10
//oPrn:Say(nLin+710 , 0005 , nomeprog                      ,oFtA07, 100)
//oPrn:Say(nLin+710 , 0495 ,"Hora : " + Time()             ,oFtA07, 100)
//oPrn:Say(nLin+720 , 0005 ,"TOTVS/V."+ SubStr(cVersao,1,6),oFtA07, 100)
//npage++
nLin := 190
Return(.t.)

//----------------------------------------------------------------------------
// Objetivo      : Formata linhas do campo memo                               *
// Observacao    :                                                            *
// Sintaxe       : FormatText(@cMemo, nLen)                                   *
// Parametros    : cMemo ----> texto memo a ser formatado                     *
//                 nLen  ----> tamanho de colunas por linha                   *
// Retorno       : array aLinhas - retorna o texto linha a linha              *
// Fun. chamadas : CalcSpaces()                                               *
// Arquivo fonte : Memo.prg                                                   *
// Arq. de dados : -                                                          *
// Veja tamb‚m   : MemoWindow()                                               *
//----------------------------------------------------------------------------
User FUNCTION FormatText(cMemo, nLen)
LOCAL nLin, cLin, lInic, lFim, aWords:={}, cNovo:="", cWord, lContinua, nTotLin

lInic:=.T.
lFim:=.F.
nTotLin:=MLCOUNT(cMemo, nLen)
FOR nLin:=1 TO nTotLin
	
	cLin:=RTRIM(MEMOLINE(cMemo, nLen, nLin)) //recuperar
	
	IF EMPTY(cLin) //Uma linha em branco ->Considerar um par grafo vazio
		IF lInic  //Inicio de paragrafo
			aWords:={}  //Limpar o vetor de palavras
			lInic:=.F.
		ELSE
			AADD(aWords, CHR(13)+CHR(10)) //Incluir quebra de linha
		ENDIF
		AADD(aWords, CHR(13)+CHR(10)) //Incluir quebra de linha
		lFim:=.T.
	ELSE
		IF lInic  //Inicio de paragrafo
			aWords:={} //Limpar o vetor de palavras
			//Incluir a primeira palavra com os espacos que a antecedem
			cWord:=""
			WHILE SUBSTR(cLin, 1, 1)==" "
				cWord+=" "
				cLin:=SUBSTR(cLin, 2)
			END
			IF(nNext:=AT(SPACE(1), cLin))<>0
				cWord+=SUBSTR(cLin, 1, nNext-1)
			ENDIF
			AADD(aWords, cWord)
			cLin:=SUBSTR(cLin, nNext+1)
			lInic:=.F.
		ENDIF
		//Retirar as demais palavras da linha
		WHILE(nNext:=AT(SPACE(1), cLin))<>0
			IF !EMPTY(cWord:=SUBSTR(cLin, 1, nNext-1))
				IF cWord=="," .AND. !EMPTY(aWords)
					aWords[LEN(aWords)]+=cWord
				ELSE
					AADD(aWords, cWord)
				ENDIF
			ENDIF
			cLin:=SUBSTR(cLin, nNext+1)
		END
		IF !EMPTY(cLin) //Incluir a ultima palavra
			IF cLin=="," .AND. !EMPTY(aWords)
				aWords[LEN(aWords)]+=cLin
			ELSE
				AADD(aWords, cLin)
			ENDIF
		ENDIF
		IF nLin==nTotLin  //Foi a ultima linha -> Finalizar o paragrafo
			lFim:=.T.
		ELSEIF RIGHT(cLin, 1)=="." //Considerar que o 'ponto' finaliza paragrafo
			AADD(aWords, CHR(13)+CHR(10))
			lFim:=.T.
		ENDIF
	ENDIF
	
	IF lFim
		IF LEN(aWords)>0
			nNext:=1
			nAuxLin:=1
			WHILE nAuxLin<=LEN(aWords)
				//Montar uma linha formatada
				lContinua:=.T.
				nTot:=0
				WHILE lContinua
					nTot+=(IF(nTot=0, 0, 1)+LEN(aWords[nNext]))
					IF nNext==LEN(aWords)
						lContinua:=.F.
					ELSEIF (nTot+1+LEN(aWords[nNext+1]))>=nLen
						lContinua:=.F.
					ELSE
						nNext++
					ENDIF
				END
				IF nNext==LEN(aWords)  //Ultima linha ->Nao formata
					FOR nAux:=nAuxLin TO nNext
						cNovo+=(IF(nAux==nAuxLin, "", " ")+aWords[nAux])
					NEXT
				ELSE //Formatar
					FOR nAux:=nAuxLin TO nNext
						cNovo+=(CalcSpaces(nNext-nAuxLin, nLen-nTot-1, nAux-nAuxLin)+aWords[nAux])
					NEXT
					cNovo+=" "
				ENDIF
				nNext++
				nAuxLin:=nNext
			END
		ENDIF
		
		lFim:=.F.  //Indicar que o fim do paragrafo foi processado
		lInic:=.T. //Forcar inicio de paragrafo
		
	ENDIF
	
NEXT

//Retirar linhas em branco no final
WHILE LEN(cNovo)>2 .AND. (RIGHT(cNovo, 2)==CHR(13)+CHR(10))
	cNovo:=LEFT(cNovo, LEN(cNovo)-2)
END

For vInd := 0 to (len(cNovo)/nLen)
	AADD(aLinhas, {Substr(cNovo, (vInd*nLen)+1, nLen) } )
Next

RETURN(cNovo)

//----------------------------------------------------------------------------
// Objetivo      : Calcula espacos necessarios para completar a linha         *
// Observacao    :                                                            *
// Sintaxe       : CalcSpaces(nQt, nTot, nPos)                                *
// Parametros    : nQt  ---> quantidade de separacoes que devem existir       *
//                 nTot ---> total de caracteres em branco excedentes a serem *
//                           distribuidos                                     *
//                 nPos ---> a posicao de uma separacao em particular         *
//                           (comecando do zero)                              *
// Retorno       : a separacao ja pronta de posicao nPos                      *
// Fun. chamadas : -                                                          *
// Arquivo fonte : Memo.prg                                                   *
// Arq. de dados : -                                                          *
// Veja tamb‚m   : MemoWindow()                                               *
//----------------------------------------------------------------------------
Static FUNCTION CalcSpaces(nQt, nTot, nPos)
LOCAL cSpaces,; //Retorno de espacos
nDist,;   //Total de espacos excedentes a distribuir em cada separacao
nLim      //Ate que posicao devera conter o resto da divisao

IF nPos==0
	cSpaces:=""
ELSE
	nDist:=INT(nTot/nQt)
	nLim:=nTot-(nQt*nDist)
	cSpaces:=REPL(SPACE(1), 1+nDist+IF(nPos<=nLim, 1, 0))
ENDIF

RETURN cSpaces

//=====================================================//  
// CRIA AS PERGUNTAS NO DICIONARIO DE PERGUNTAS        //
//=====================================================//
Static Function ValidPerg(cPerg)
sAlias := Alias()
aRegs  := {}
i := j := 0

dbSelectArea("SX1")
dbSetOrder(1)
//GRUPO,ORDEM,PERGUNTA              ,PERGUNTA,PERGUNTA,VARIAVEL,TIPO,TAMANHO,DECIMAL,PRESEL,GSC,VALID,VAR01,DEF01,DEFSPA01,DEFING01,CNT01,VAR02,DEF02,DEFSPA02,DEFING02,CNT02,VAR03,DEF03,DEFSPA03,DEFING03,CNT03,VAR04,DEF04,DEFSPA04,DEFING04,CNT04,VAR05,DEF05,DEFSPA05,DEFING05,CNT05,F3,GRPSXG
AADD(aRegs,{cPerg,"01","Da OS             ?","","","mv_ch1","C",009,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(sAlias)
Return