#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 10/02/02
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function IMPNFE()        // incluido pelo assistente de conversao do AP6 IDE em 10/02/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//SetPrvt("I,J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPNFE    ³ Autor ³RODRIGO CORREA         ³ Data ³ 20.05.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³  GERA ARQUIVO DE IMPORTACAO PARA PROSOFT                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ NOTAS FISCAIS DE ENTRADA - CABECALHO                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCampos:={}
cString:="SF1"
aLinha := { }
cPerg  :="IMPNFE"
ValidPerg()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a Integridade dos dados de Entrada                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

pergunte("IMPNFE",.T.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                        ³
//³ mv_par01            // Da Data de Emissao                   ³
//³ mv_par02            // Ate Data de Emissao                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa( {|| RunProc() } )
dbcommitAll()

dbSelectArea("cNomeArq")
dbGotop()
cNome := "D:\protheus8\Protheus_data\Import\IMPNFE.TXT"
COPY TO &cNome SDF
dbCloseArea("cNomeArq") //Fecha 
Return

Static Function RunProc()

aCampos:={ {"REGISTRO" ,"C", 922,0}}
cNomeArq:=CriaTrab(aCampos)
Use &cNomeArq Alias cNomeArq New

dbSelectArea("SF1")
dbSetOrder(1)

cFilTrab   := CriaTrab(NIL,.F.)
cCondicao  := " F1_FILIAL == '"+xFilial()+"' .And. "   
cCondicao  += " DTOS(F1_DTDIGIT) >= '" +DTOS(MV_PAR01)+ "' .And. DTOS(F1_DTDIGIT) <= '"+DTOS(MV_PAR02)+ "' " 
cChave := "F1_FILIAL+DTOS(F1_DTDIGIT)"
IndRegua("SF1",cFilTrab,cChave,,cCondicao,"Filtrando")    // "Selecionando Registros..."

dbSelectArea("SF1")
DbGoTop()

cFiller     := space(04) // POSICAO 001 A 004 -> Filler -> Deixar em Branco
cCnpjFor    := space(14) // POSICAO 005 A 018 -> CNPJ do Emitente -> Preencher sem Pontuacao
dDataDig    := space(06) // POSICAO 019 A 024 -> Data da Entrada -> Formato DDMMAA
dDataEmi    := space(06) // POSICAO 025 A 030 -> Data de Emissao da Nota -> Formato DDMMAA
cNumDoc     := space(06) // POSICAO 031 A 036 -> Numero da Nota com Zeros a Esquerda
cEspDoc     := space(03) // POSICAO 037 A 039 -> Especie da Nota 
cSerDoc     := space(03) // POSICAO 040 A 042 -> Serie da Nota 
cItemDes    := space(01) // POSICAO 043 A 043 -> Item de Desdobramento
cCodCont    := space(05) // POSICAO 044 A 048 -> Codigo Contabil (Plano de Contas) -> Numerico com zeros a Esquerda
cCfopAnt    := space(03) // POSICAO 049 A 051 -> Cfop Antigo com 3 digitos -> Numerico com zeros a Esquerda
nValTotMerc := space(14) // POSICAO 052 A 065 -> Valor Total das Mercadorias -> 99999999999.99
nBaseICMS   := space(14) // POSICAO 066 A 079 -> Base de Calculo do ICMS -> 99999999999.99
nValorICMS  := space(14) // POSICAO 080 A 093 -> Valor do ICMS Creditado -> 99999999999.99
nIsentICMS  := space(14) // POSICAO 094 A 107 -> Isentas e Nao Tributadas ICMS -> 99999999999.99
nOutraICMS  := space(14) // POSICAO 108 A 121 -> Outras ICMS -> 99999999999.99
nIPInCred   := space(14) // POSICAO 122 A 135 -> IPI nao Creditado -> 99999999999.99
nAliqICMS   := space(05) // POSICAO 136 A 140 -> Aliquota do ICMS -> 99.99
nBaseIPI    := space(14) // POSICAO 141 A 154 -> Base de Calculo do IPI -> 99999999999.99
nValorIPI   := space(14) // POSICAO 155 A 168 -> Valor do IPI Creditado -> 99999999999.99
nValIPI50   := space(14) // POSICAO 169 A 182 -> Valor do IPI Creditado 50 % -> 99999999999.99
nIsentIPI   := space(14) // POSICAO 183 A 196 -> Isentas e Nao Tributadas IPI -> 99999999999.99
nOutraIPI   := space(14) // POSICAO 197 A 210 -> Outras IPI -> 99999999999.99
nValTotNota := space(14) // POSICAO 211 A 224 -> Valor total da Nota Fiscal -> 99999999999.99
cCondPagto  := space(01) // POSICAO 225 A 225 -> Condicao de Pagamento ->0 ( a vista) 1 ( a prazo)
cClassifCon := space(02) // POSICAO 226 A 227 -> Classificacao Contabil - Integracao -> Numerico com zeros a Esquerda
cSitEspec   := space(03) // POSICAO 228 A 230 -> Situacao Especial - Codigo  -> Numerico com zeros a Esquerda 
nSitVal1    := space(12) // POSICAO 231 A 242 -> Situacao Especial - Valor1  -> 999999999.99 
nSitVal2    := space(12) // POSICAO 243 A 254 -> Situacao Especial - Valor2  -> 999999999.99 
nSitVal3    := space(12) // POSICAO 255 A 266 -> Situacao Especial - Valor3  -> 999999999.99 
nSitVal4    := space(12) // POSICAO 267 A 278 -> Situacao Especial - Valor4  -> 999999999.99 
cObserv     := space(100)// POSICAO 279 A 378 -> Observacao  
d1Vencto    := space(06) // POSICAO 379 A 384 -> 1 Vencimento -> Desativado Ver Faturas
n1Parcela   := space(14) // POSICAO 385 A 398 -> 1 Parcela -> 99999999999.99   
d2Vencto    := space(06) // POSICAO 399 A 404 -> 2 Vencimento -> Desativado Ver Faturas
n2Parcela   := space(14) // POSICAO 405 A 418 -> 2 Parcela -> 99999999999.99   
d3Vencto    := space(06) // POSICAO 419 A 424 -> 3 Vencimento -> Desativado Ver Faturas
n3Parcela   := space(14) // POSICAO 425 A 438 -> 3 Parcela -> 99999999999.99   
d4Vencto    := space(06) // POSICAO 439 A 444 -> 4 Vencimento -> Desativado Ver Faturas
n4Parcela   := space(14) // POSICAO 445 A 458 -> 4 Parcela -> 99999999999.99   
d5Vencto    := space(06) // POSICAO 459 A 464 -> 5 Vencimento -> Desativado Ver Faturas
n5Parcela   := space(14) // POSICAO 465 A 478 -> 5 Parcela -> 99999999999.99   
d6Vencto    := space(06) // POSICAO 479 A 484 -> 6 Vencimento -> Desativado Ver Faturas
n6Parcela   := space(14) // POSICAO 485 A 498 -> 6 Parcela -> 99999999999.99   
cInscEstFor := space(18) // POSICAO 499 A 516 -> Incricao Estadual do Fornecedor
cUFFor      := space(02) // POSICAO 517 A 518 -> UF Incricao Estadual do Fornecedor
cTipoFrete  := space(01) // POSICAO 519 A 519 -> Tipo de Frete -> (1 = CIF  2 = FOB)
//Campos Especificos Para o Estado de Minas Gerais e Espirito Santo
cSigSitT1   := space(05) // POSICAO 520 A 524 -> Sigla Situacao Tributaria Saida 1
nValSitT1   := space(14) // POSICAO 525 A 538 -> Valor Situacao Tributaria Saida 1 -> 99999999999.99
cDigAdicCF  := space(01) // POSICAO 539 A 539 -> Digito adicional para CFOP x99 no Estado de Sao Paulo -> Deixar em Branco para outras CFOPs ou Empresas de Outros Estados
//Campos Especificos Para o Estado de Minas Gerais 
cSigSitT2   := space(05) // POSICAO 540 A 544 -> Sigla Situacao Tributaria Saida 2
nValSitT2   := space(14) // POSICAO 545 A 558 -> Valor Situacao Tributaria Saida 2 -> 99999999999.99
cSigSitT3   := space(05) // POSICAO 559 A 563 -> Sigla Situacao Tributaria Saida 3
nValSitT3   := space(14) // POSICAO 564 A 577 -> Valor Situacao Tributaria Saida 3 -> 99999999999.99
cSigSitT4   := space(05) // POSICAO 578 A 582 -> Sigla Situacao Tributaria Saida 4
nValSitT4   := space(14) // POSICAO 583 A 596 -> Valor Situacao Tributaria Saida 4 -> 99999999999.99
nValParIsen := space(14) // POSICAO 597 A 610 -> Valor Parcela Isenta Saida -> 99999999999.99
cDigAdiCFOP := space(03) // POSICAO 611 A 613 -> Digito adicional para CFOP x99 outros Estados -> Deinxar em branco para outros CFOPs - Alinhado a esquerda com branco a direita
cAnoAIDF    := space(04) // POSICAO 614 A 617 -> Ano da AIDF -> Somente para Sergipe
cNumAIDF    := space(06) // POSICAO 618 A 623 -> Numero da AIDF -> Somente para Sergipe
cCFOP       := space(04) // POSICAO 624 A 627 -> CFOP novo de 4 digitos -> numerico
cCodMunFor  := space(10) // POSICAO 628 A 637 -> Codigo do Municipio do Fornecedor
//TRANSPORTADOR - (SO COMBUSTIVEIS - Local de Saida)
cCnpjTraCO  := space(14) // POSICAO 638 A 651 -> CNPJ da Transportadora -> Preencher sem Pontuacao - COMBUSTIVEL
cInsEstTCO  := space(18) // POSICAO 652 A 669 -> Inscricao Estadual da Transportadora - COMBUSTIVEL
cUFTraspCO  := space(02) // POSICAO 670 A 671 -> UF da Transportadora - COMBUSTIVEL
//Local de Entrega/Recebimento
cCnpjTraER  := space(14) // POSICAO 672 A 685 -> CNPJ da Transportadora -> Preencher sem Pontuacao - ENTREGA/RECEBIMENTO
cInsEstTER  := space(18) // POSICAO 686 A 703 -> Inscricao Estadual da Transportadora - ENTREGA/RECEBIMENTO
cUFTraspER  := space(02) // POSICAO 704 A 705 -> UF da Transportadora - ENTREGA/RECEBIMENTO
//Dados do Transportador
cCnpjTrans  := space(14) // POSICAO 706 A 719 -> CNPJ da Transportadora -> Preencher sem Pontuacao - TRANSPORTADOR
cInsEstTra  := space(18) // POSICAO 720 A 737 -> Inscricao Estadual da Transportadora - TRANSPORTADOR
cUFTrasort  := space(02) // POSICAO 738 A 739 -> UF da Transportadora - TRANSPORTADOR    
cModal      := space(01) // POSICAO 740 A 740 -> Modal Transportador    
cPlaca1     := space(07) // POSICAO 741 A 747 -> Placa Transportador 1    
cUFPlaca1   := space(02) // POSICAO 748 A 749 -> UF Transportador 1   
cPlaca2     := space(07) // POSICAO 750 A 756 -> Placa Transportador 2    
cUFPlaca2   := space(02) // POSICAO 757 A 758 -> UF Transportador 2   
cPlaca3     := space(07) // POSICAO 759 A 765 -> Placa Transportador 3    
cUFPlaca3   := space(02) // POSICAO 766 A 767 -> UF Transportador 3   
cMovFisComb := space(01) // POSICAO 768 A 768 -> Movimentacao Fisica do Combustivel (S/N/' ')
cClassiConI := space(04) // POSICAO 769 A 772 -> Classificacao Contabil - Integracao -> Numerico com zeros a Esquerda
cCodDipam   := space(02) // POSICAO 773 A 774 -> Codigo da Dipam -> 11,12,13,22,23,24,25,26,31,35,36,37,38
nBaseSubTri := space(14) // POSICAO 775 A 788 -> Base  da Substituicao Tributaria -> 999999999.99
nValorSubTr := space(14) // POSICAO 789 A 802 -> Valor da Substituicao Tributaria -> 999999999.99
cCodRecPC   := space(06) // POSICAO 803 A 808 -> Codigo do Recolhimento de Pis e Cofins -> Numerico com zeros a Esquerda
cNotaCanc   := space(01) // POSICAO 809 A 809 -> Nota Fiscal Cancelada (0-Nao cancelada, 1-Cancelada)
cReservado  := space(06) // POSICAO 810 A 815 -> Espaco Reservado -> Preencher com Brancos
nValorFrete := space(14) // POSICAO 816 A 829 -> Valor do Frete -> 999999999.99
nValorSegur := space(14) // POSICAO 830 A 843 -> Valor do Seguro -> 999999999.99
nValorOutra := space(14) // POSICAO 844 A 857 -> Valor de Outras Despesas -> 999999999.99
cEspeciew   := space(05) // POSICAO 858 A 862 -> Especie do Documento(Windows)
cIPIbase    := space(01) // POSICAO 863 A 863 -> IPI na base do ICMS (0-Nao, 1-Sim)
cSerie      := space(03) // POSICAO 864 A 866 -> Serie
cSubSerie   := space(02) // POSICAO 867 A 868 -> SubSerie
cNum10      := space(10) // POSICAO 869 A 878 -> Numero do Documento com 10 Digitos -> Numericos com zeros a Esquerda
cNumDispIni := space(10) // POSICAO 879 A 888 -> Numero do Dispositivo Inicial -> Numericos com zeros a Esquerda
cNumDispFin := space(10) // POSICAO 889 A 898 -> Numero do Dispositivo Final   -> Numericos com zeros a Esquerda
cCentroCust := space(05) // POSICAO 899 A 903 -> Codigo do Centro de Custo -> 99999
cCodTabSimp := space(03) // POSICAO 904 A 906 -> Codigo da Tabela Simples Nacional 999 -> Nao obrigatorio
cHoraEmissa := space(08) // POSICAO 907 A 914 -> Hora da Emissao HH:MM:SS
cHoraEntrad := space(08) // POSICAO 915 A 922 -> Hora da Entrada HH:MM:SS

While !EOF() 
	
	IncProc()
	
	
	dbSelectArea("SA2")
	dbSetOrder(1)
	dbSeek(xFilial()+SF1->F1_FORNECE+SF1->F1_LOJA)
	cCnpjFor := SA2->A2_CGC       // CGC FORNECEDOR
	cInscEstFor := SA2->A2_INSCR  // INSCRICAO ESTADUAL DO FORNECEDOR
	cUFFor := SA2->A2_EST // UF DO FORNECEDOR
	
	dbSelectArea("SA4")
	dbSetOrder(1)
   //	dbSeek(xFilial()+SF1->F1_TRANSP)
	
	dbSelectArea("SD1")
	dbSetOrder(1)
	dbSeek(xFilial()+SF1->F1_DOC+SF1->F1_SERIE) 
	
	dbSelectArea("SF4")
	dbSetOrder(1)
	dbSeek(xFilial()+SD1->D1_TES)
	
	IF SF4->F4_INCIDE = "N"
	cIPIbase := "0"
	ELSE 
	cIPIbase := "1"
	ENDIF

	dbSelectArea("SF3")
	dbSetOrder(5)
	dbSeek(xFilial()+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA)
  
    nBaseICMS  := strzero(SF3->F3_BASEICM,14,2)  // BASE DE ICMS    
    nValorICMS := strzero(SF3->F3_VALICM,14,2)   // VALOR DE ICMS 
    nIsentICMS := strzero(SF3->F3_ISENICM,14,2)  // ISENTAS DE ICMS 
	nOutraICMS := strzero(SF3->F3_OUTRICM,14,2)  // OUTRAS DE ICMS 
	nAliqICMS  := strzero(SF3->F3_ALIQICM,05,2)  // ALIQUOTA DE ICMS
	
    nBaseIPI  := strzero(SF3->F3_BASEIPI,14,2)  // BASE DE ICMS    
    nValorIPI := strzero(SF3->F3_VALIPI,14,2)   // VALOR DE ICMS 
    nIsentIPI := strzero(SF3->F3_ISENIPI,14,2)  // ISENTAS DE ICMS 
	nOutraIPI := strzero(SF3->F3_OUTRIPI,14,2)  // OUTRAS DE ICMS      

	
	nValTotNota := strzero(SF3->F3_VALCONT,14,2)
	cObserv     :=  substr(SF3->F3_OBSERV,1,30) + space(70)
	cCFOP       :=  SUBSTR(SF3->F3_CFO,1,4)


 	dbSelectArea("SF1")             
  
	dDataDig := GRAVADATA(SF1->F1_DTDIGIT,.F.,1)
	dDataEmi := GRAVADATA(SF1->F1_EMISSAO,.F.,1)

	cNumDoc := SUBSTR(SF1->F1_DOC,1,6)     // NUMERO NOTA FISCAL
	cEspDoc := SUBSTR(SF1->F1_ESPECIE,1,3) // ESPECIE NOTA FISCAL
    cSerDoc := SUBSTR(SF1->F1_SERIE,1,3)   // ESPECIE NOTA FISCAL
    
    nValTotMerc := strzero(SF1->F1_VALMERC,14,2)  // VALOR DA MERCADORIA  
    
    IF SF1->F1_COND == "009"
    cCondPagto := "0"
    ELSE
    cCondPagto := "1"
    ENDIF
    
    cNotaCanc := "0"
   	nValorFrete  := strzero(SF1->F1_FRETE,14,2)  // VALOR DO FRETE
   	nValorOutra  := strzero(SF1->F1_DESPESA,14,2)  // VALOR DE OUTRAS DESPESAS
   	cSerie := SF1->F1_SERIE 
   	cNum10 := strzero(VAL(SF1->F1_DOC),10)
   	
   	
xRegistro := cFiller                                  // space(04) // POSICAO 001 A 004 -> Filler -> Deixar em Branco
xRegistro := xRegistro + cCnpjFor                     // space(14) // POSICAO 005 A 018 -> CNPJ do Emitente -> Preencher sem Pontuacao
xRegistro := xRegistro + dDataDig                     // space(06) // POSICAO 019 A 024 -> Data da Entrada -> Formato DDMMAA
xRegistro := xRegistro + dDataEmi                     // space(06) // POSICAO 025 A 030 -> Data de Emissao da Nota -> Formato DDMMAA
xRegistro := xRegistro + cNumDoc                      // space(06) // POSICAO 031 A 036 -> Numero da Nota com Zeros a Esquerda
xRegistro := xRegistro + cEspDoc                      // space(03) // POSICAO 037 A 039 -> Especie da Nota 
xRegistro := xRegistro + cSerDoc                      // space(03) // POSICAO 040 A 042 -> Serie da Nota 
xRegistro := xRegistro + cItemDes                     // space(01) // POSICAO 043 A 043 -> Item de Desdobramento
xRegistro := xRegistro + cCodCont                     // space(05) // POSICAO 044 A 048 -> Codigo Contabil (Plano de Contas) -> Numerico com zeros a Esquerda
xRegistro := xRegistro + cCfopAnt                     // space(03) // POSICAO 049 A 051 -> Cfop Antigo com 3 digitos -> Numerico com zeros a Esquerda
xRegistro := xRegistro + nValTotMerc                  // space(14) // POSICAO 052 A 065 -> Valor Total das Mercadorias -> 99999999999.99
xRegistro := xRegistro + nBaseICMS                    // space(14) // POSICAO 066 A 079 -> Base de Calculo do ICMS -> 99999999999.99
xRegistro := xRegistro + nValorICMS                   // space(14) // POSICAO 080 A 093 -> Valor do ICMS Creditado -> 99999999999.99
xRegistro := xRegistro + nIsentICMS  // space(14) // POSICAO 094 A 107 -> Isentas e Nao Tributadas ICMS -> 99999999999.99
xRegistro := xRegistro + nOutraICMS  // space(14) // POSICAO 108 A 121 -> Outras ICMS -> 99999999999.99
xRegistro := xRegistro + nIPInCred   // space(14) // POSICAO 122 A 135 -> IPI nao Creditado -> 99999999999.99
xRegistro := xRegistro + nAliqICMS   // space(05) // POSICAO 136 A 140 -> Aliquota do ICMS -> 99.99
xRegistro := xRegistro + nBaseIPI    // space(14) // POSICAO 141 A 154 -> Base de Calculo do IPI -> 99999999999.99
xRegistro := xRegistro + nValorIPI   // space(14) // POSICAO 155 A 168 -> Valor do IPI Creditado -> 99999999999.99
xRegistro := xRegistro + nValIPI50   // space(14) // POSICAO 169 A 182 -> Valor do IPI Creditado 50 % -> 99999999999.99
xRegistro := xRegistro + nIsentIPI   // space(14) // POSICAO 183 A 196 -> Isentas e Nao Tributadas IPI -> 99999999999.99
xRegistro := xRegistro + nOutraIPI   // space(14) // POSICAO 197 A 210 -> Outras IPI -> 99999999999.99
xRegistro := xRegistro + nValTotNota // space(14) // POSICAO 211 A 224 -> Valor total da Nota Fiscal -> 99999999999.99
xRegistro := xRegistro + cCondPagto  // space(01) // POSICAO 225 A 225 -> Condicao de Pagamento ->0 ( a vista) 1 ( a prazo)
xRegistro := xRegistro + cClassifCon // space(02) // POSICAO 226 A 227 -> Classificacao Contabil - Integracao -> Numerico com zeros a Esquerda
xRegistro := xRegistro + cSitEspec   // space(03) // POSICAO 228 A 230 -> Situacao Especial - Codigo  -> Numerico com zeros a Esquerda 
xRegistro := xRegistro + nSitVal1    // space(12) // POSICAO 231 A 242 -> Situacao Especial - Valor1  -> 999999999.99 
xRegistro := xRegistro + nSitVal2    // space(12) // POSICAO 243 A 254 -> Situacao Especial - Valor2  -> 999999999.99 
xRegistro := xRegistro + nSitVal3    // space(12) // POSICAO 255 A 266 -> Situacao Especial - Valor3  -> 999999999.99 
xRegistro := xRegistro + nSitVal4    // space(12) // POSICAO 267 A 278 -> Situacao Especial - Valor4  -> 999999999.99 
xRegistro := xRegistro + cObserv     // space(100)// POSICAO 279 A 378 -> Observacao  
xRegistro := xRegistro + d1Vencto    // space(06) // POSICAO 379 A 384 -> 1 Vencimento -> Desativado Ver Faturas
xRegistro := xRegistro + n1Parcela   // space(14) // POSICAO 385 A 398 -> 1 Parcela -> 99999999999.99   
xRegistro := xRegistro + d2Vencto    // space(06) // POSICAO 399 A 404 -> 2 Vencimento -> Desativado Ver Faturas
xRegistro := xRegistro + n2Parcela   // space(14) // POSICAO 405 A 418 -> 2 Parcela -> 99999999999.99   
xRegistro := xRegistro + d3Vencto    // space(06) // POSICAO 419 A 424 -> 3 Vencimento -> Desativado Ver Faturas
xRegistro := xRegistro + n3Parcela   // space(14) // POSICAO 425 A 438 -> 3 Parcela -> 99999999999.99   
xRegistro := xRegistro + d4Vencto    // space(06) // POSICAO 439 A 444 -> 4 Vencimento -> Desativado Ver Faturas
xRegistro := xRegistro + n4Parcela   // space(14) // POSICAO 445 A 458 -> 4 Parcela -> 99999999999.99   
xRegistro := xRegistro + d5Vencto    // space(06) // POSICAO 459 A 464 -> 5 Vencimento -> Desativado Ver Faturas
xRegistro := xRegistro + n5Parcela   // space(14) // POSICAO 465 A 478 -> 5 Parcela -> 99999999999.99   
xRegistro := xRegistro + d6Vencto    // space(06) // POSICAO 479 A 484 -> 6 Vencimento -> Desativado Ver Faturas
xRegistro := xRegistro + n6Parcela   // space(14) // POSICAO 485 A 498 -> 6 Parcela -> 99999999999.99   
xRegistro := xRegistro + cInscEstFor // space(18) // POSICAO 499 A 516 -> Incricao Estadual do Fornecedor
xRegistro := xRegistro + cUFFor      // space(02) // POSICAO 517 A 518 -> UF Incricao Estadual do Fornecedor
xRegistro := xRegistro + cTipoFrete  // space(01) // POSICAO 519 A 519 -> Tipo de Frete -> (1 = CIF  2 = FOB)
//Campos Especificos Para o Estado de Minas Gerais e Espirito Santo
xRegistro := xRegistro + cSigSitT1   // space(05) // POSICAO 520 A 524 -> Sigla Situacao Tributaria Saida 1
xRegistro := xRegistro + nValSitT1   // space(14) // POSICAO 525 A 538 -> Valor Situacao Tributaria Saida 1 -> 99999999999.99
xRegistro := xRegistro + cDigAdicCF  // space(01) // POSICAO 539 A 539 -> Digito adicional para CFOP x99 no Estado de Sao Paulo -> Deixar em Branco para outras CFOPs ou Empresas de Outros Estados
//Campos Especificos Para o Estado de Minas Gerais 
xRegistro := xRegistro + cSigSitT2   // space(05) // POSICAO 540 A 544 -> Sigla Situacao Tributaria Saida 2
xRegistro := xRegistro + nValSitT2   // space(14) // POSICAO 545 A 558 -> Valor Situacao Tributaria Saida 2 -> 99999999999.99
xRegistro := xRegistro + cSigSitT3   // space(05) // POSICAO 559 A 563 -> Sigla Situacao Tributaria Saida 3
xRegistro := xRegistro + nValSitT3   // space(14) // POSICAO 564 A 577 -> Valor Situacao Tributaria Saida 3 -> 99999999999.99
xRegistro := xRegistro + cSigSitT4   // space(05) // POSICAO 578 A 582 -> Sigla Situacao Tributaria Saida 4
xRegistro := xRegistro + nValSitT4   // space(14) // POSICAO 583 A 596 -> Valor Situacao Tributaria Saida 4 -> 99999999999.99
xRegistro := xRegistro + nValParIsen // space(14) // POSICAO 597 A 610 -> Valor Parcela Isenta Saida -> 99999999999.99
xRegistro := xRegistro + cDigAdiCFOP // space(03) // POSICAO 611 A 613 -> Digito adicional para CFOP x99 outros Estados -> Deinxar em branco para outros CFOPs - Alinhado a esquerda com branco a direita
xRegistro := xRegistro + cAnoAIDF    // space(03) // POSICAO 614 A 617 -> Ano da AIDF -> Somente para Sergipe
xRegistro := xRegistro + cNumAIDF    // space(03) // POSICAO 618 A 623 -> Numero da AIDF -> Somente para Sergipe
xRegistro := xRegistro + cCFOP       // space(04) // POSICAO 624 A 627 -> CFOP novo de 4 digitos -> numerico
xRegistro := xRegistro + cCodMunFor  // space(10) // POSICAO 628 A 637 -> Codigo do Municipio do Fornecedor
//TRANSPORTADOR - (SO COMBUSTIVEIS - Local de Saida)
xRegistro := xRegistro + cCnpjTraCO  // space(14) // POSICAO 638 A 651 -> CNPJ da Transportadora -> Preencher sem Pontuacao - COMBUSTIVEL
xRegistro := xRegistro + cInsEstTCO  // space(18) // POSICAO 652 A 669 -> Inscricao Estadual da Transportadora - COMBUSTIVEL
xRegistro := xRegistro + cUFTraspCO  // space(02) // POSICAO 670 A 671 -> UF da Transportadora - COMBUSTIVEL
//Local de Entrega/Recebimento
xRegistro := xRegistro + cCnpjTraER  // space(14) // POSICAO 672 A 685 -> CNPJ da Transportadora -> Preencher sem Pontuacao - ENTREGA/RECEBIMENTO
xRegistro := xRegistro + cInsEstTER  // space(18) // POSICAO 686 A 703 -> Inscricao Estadual da Transportadora - ENTREGA/RECEBIMENTO
xRegistro := xRegistro + cUFTraspER  // space(02) // POSICAO 704 A 705 -> UF da Transportadora - ENTREGA/RECEBIMENTO
//Dados do Transportador
xRegistro := xRegistro + cCnpjTrans  // space(14) // POSICAO 706 A 719 -> CNPJ da Transportadora -> Preencher sem Pontuacao - TRANSPORTADOR
xRegistro := xRegistro + cInsEstTra  // space(18) // POSICAO 720 A 737 -> Inscricao Estadual da Transportadora - TRANSPORTADOR
xRegistro := xRegistro + cUFTrasort  // space(02) // POSICAO 738 A 739 -> UF da Transportadora - TRANSPORTADOR    
xRegistro := xRegistro + cModal      // space(01) // POSICAO 740 A 740 -> Modal Transportador    
xRegistro := xRegistro + cPlaca1     // space(07) // POSICAO 741 A 747 -> Placa Transportador 1    
xRegistro := xRegistro + cUFPlaca1   // space(02) // POSICAO 748 A 749 -> UF Transportador 1   
xRegistro := xRegistro + cPlaca2     // space(07) // POSICAO 750 A 756 -> Placa Transportador 2    
xRegistro := xRegistro + cUFPlaca2   // space(02) // POSICAO 757 A 758 -> UF Transportador 2   
xRegistro := xRegistro + cPlaca3     // space(07) // POSICAO 759 A 765 -> Placa Transportador 3    
xRegistro := xRegistro + cUFPlaca3   // space(02) // POSICAO 766 A 767 -> UF Transportador 3   
xRegistro := xRegistro + cMovFisComb // space(01) // POSICAO 768 A 768 -> Movimentacao Fisica do Combustivel (S/N/' ')
xRegistro := xRegistro + cClassiConI // space(04) // POSICAO 769 A 772 -> Classificacao Contabil - Integracao -> Numerico com zeros a Esquerda
xRegistro := xRegistro + cCodDipam   // space(02) // POSICAO 773 A 774 -> Codigo da Dipam -> 11,12,13,22,23,24,25,26,31,35,36,37,38
xRegistro := xRegistro + nBaseSubTri // space(14) // POSICAO 775 A 788 -> Base  da Substituicao Tributaria -> 999999999.99
xRegistro := xRegistro + nValorSubTr // space(14) // POSICAO 789 A 802 -> Valor da Substituicao Tributaria -> 999999999.99
xRegistro := xRegistro + cCodRecPC   // space(06) // POSICAO 803 A 808 -> Codigo do Recolhimento de Pis e Cofins -> Numerico com zeros a Esquerda
xRegistro := xRegistro + cNotaCanc   // space(01) // POSICAO 809 A 809 -> Nota Fiscal Cancelada (0-Nao cancelada, 1-Cancelada)
xRegistro := xRegistro + cReservado  // space(06) // POSICAO 810 A 815 -> Espaco Reservado -> Preencher com Brancos
xRegistro := xRegistro + nValorFrete // space(14) // POSICAO 816 A 829 -> Valor do Frete -> 999999999.99
xRegistro := xRegistro + nValorSegur // space(14) // POSICAO 830 A 843 -> Valor do Seguro -> 999999999.99
xRegistro := xRegistro + nValorOutra // space(14) // POSICAO 844 A 857 -> Valor de Outras Despesas -> 999999999.99
xRegistro := xRegistro + cEspeciew   // space(05) // POSICAO 858 A 862 -> Especie do Documento(Windows)
xRegistro := xRegistro + cIPIbase    // space(01) // POSICAO 863 A 863 -> IPI na base do ICMS (0-Nao, 1-Sim)
xRegistro := xRegistro + cSerie      // space(03) // POSICAO 864 A 866 -> Serie
xRegistro := xRegistro + cSubSerie   // space(02) // POSICAO 867 A 868 -> SubSerie
xRegistro := xRegistro + cNum10      // space(10) // POSICAO 869 A 878 -> Numero do Documento com 10 Digitos -> Numericos com zeros a Esquerda
xRegistro := xRegistro + cNumDispIni // space(10) // POSICAO 879 A 888 -> Numero do Dispositivo Inicial -> Numericos com zeros a Esquerda
xRegistro := xRegistro + cNumDispFin // space(10) // POSICAO 889 A 898 -> Numero do Dispositivo Final   -> Numericos com zeros a Esquerda
xRegistro := xRegistro + cCentroCust // space(05) // POSICAO 899 A 903 -> Codigo do Centro de Custo -> 99999
xRegistro := xRegistro + cCodTabSimp // space(03) // POSICAO 904 A 906 -> Codigo da Tabela Simples Nacional 999 -> Nao obrigatorio
xRegistro := xRegistro + cHoraEmissa // space(08) // POSICAO 907 A 914 -> Hora da Emissao HH:MM:SS
xRegistro := xRegistro + cHoraEntrad // space(08) // POSICAO 915 A 922 -> Hora da Entrada HH:MM:SS
	
	dbSelectArea("cNomeArq")
	reclock("cNomeArq",.T.)
	cNomeArq->REGISTRO := xRegistro
	
	dbSelectArea("SF1")
	dbSkip()
EndDO

Return

// Substituido pelo assistente de conversao do AP6 IDE em 10/02/02 ==> Function ValidPerg
Static Function ValidPerg()
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
_cPerg := PADR(_cPerg,10)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Data Inicial das NFE","","","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Data Final das NFE  ","","","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
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

dbSelectArea(_sAlias)

Return
