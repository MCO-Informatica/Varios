#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#DEFINE CHRCOMP If(aReturn[4]==1,15,18)

/*/
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MATR730  ³ Autor ³ Ricardo Cavalini  ³ Data ³ 14/06/2006   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Emissao de nota faturadas                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/
User Function fat002()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define Variaveis                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local Titulo  := "Emissao de Notas Fiscais de Saidas"
Local cDesc1  := "Emissao de nota fiscais de saidas conforme parametros."
Local cDesc2  := ""
Local cDesc3  := ""
Local cString := "SD2"  // Alias utilizado na Filtragem
Local lDic    := .F. // Habilita/Desabilita Dicionario
Local lComp   := .F. // Habilita/Desabilita o Formato Comprimido/Expandido
Local lFiltro := .F. // Habilita/Desabilita o Filtro
Local wnrel   := "RFAT002" // Nome do Arquivo utilizado no Spool
Local nomeprog:= "RFAT002"
Local cPerg   := "FAT002    "
Private Tamanho := "G" // P/M/G
Private Limite  := 220 // 80/132/220
Private aOrdem  := {}  // Ordem do Relatorio
Private aReturn := { "Zebrado", 2,"Administracao", 1, 2, 1, "",0 } //"Zebrado"###"Administracao"
//[1] Reservado para Formulario
//[2] Reservado para N§ de Vias
//[3] Destinatario
//[4] Formato => 1-Comprimido 2-Normal
//[5] Midia   => 1-Disco 2-Impressora
//[6] Porta ou Arquivo 1-LPT1... 4-COM1...
//[7] Expressao do Filtro
//[8] Ordem a ser selecionada
//[9]..[10]..[n] Campos a Processar (se houver)

Private lEnd    := .F.// Controle de cancelamento do relatorio
Private m_pag   := 1  // Contador de Paginas
Private nLastKey:= 0  // Controla o cancelamento da SetPrint e SetDefault

_NTOTAL := 0 
_NICM   := 0
_NIPI   := 0


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica as Perguntas Seleciondas                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia para a SetPrinter                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
	lFiltro := .F.
#ENDIF


wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,lDic,aOrdem,lComp,Tamanho,lFiltro)
If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	dbClearFilter()
	Return
Endif
SetDefault(aReturn,cString)
If ( nLastKey==27 )
	dbSelectArea(cString)
	dbSetOrder(1)
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| FAT002(@lEnd,wnRel,cString,nomeprog,Titulo)},Titulo)


Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³ FAT002    ³ Autor ³ Eduardo J. Zanardo   ³ Data ³26.12.2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Controle de Fluxo do Relatorio.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function FAT002(lEnd,wnrel,cString,nomeprog,Titulo)

Local aPedCli    := {}
Local aStruSC5   := {}
Local aStruSC6   := {}
Local aC5Rodape  := {}
Local aRelImp    := MaFisRelImp("MT100",{"SF2","SD2"})
Local li         := 100 // Contador de Linhas
Local lImp       := .F. // Indica se algo foi impresso
Local lRodape    := .F.
Local cbCont     := 0   // Numero de Registros Processados
Local cbText     := ""  // Mensagem do Rodape
Local cKey 	     := ""
Local cFilter    := ""
Local cAliasSD2  := ""
Local cIndex     := CriaTrab(nil,.f.)
Local ccAliasSD2     := ""
Local cQryAd     := ""
Local cName      := ""
Local cPedido    := ""
Local cCliEnt	 := ""
Local cNfOri     := Nil
Local cSeriOri   := Nil
Local nItem      := 0
Local nTotQtd    := 0
Local nTotVal    := 0
Local nDesconto  := 0
Local nPesLiq    := 0
Local nSC5       := 0
Local nSC6       := 0
Local nX         := 0
Local nRecnoSD1  := Nil
LOCAL lQuery     := .T.
aCampos:={ {"EMISSAO   "  ,"D",08,0},;
{"NOTA   "  ,"C",06,0},;
{"SERIE  "  ,"C",03,0},;
{"CLIENTE"  ,"C",06,0},;
{"NOME"     ,"C",40,0},;
{"PRODUTO"  ,"C",15,0},;
{"DESC"     ,"C",50,0},;
{"POSIPI"   ,"C",10,0},;
{"UF"       ,"C",02,0},;
{"CFOP"     ,"C",05,0},;
{"VLRBRUT"  ,"N",14,2},;
{"ICMS"     ,"N",14,2},;
{"BASEICM"  ,"N",14,2},;
{"VLRICM"   ,"N",14,2},;
{"IPI"      ,"N",14,2},;
{"BASEIPI"  ,"N",14,2},;
{"VLRIPI"   ,"N",14,2},;
{"BASEISS"  ,"N",14,2},;
{"VLRISS"   ,"N",14,2},;
{"COFINS"   ,"N",14,2},;
{"VLRCOF"   ,"N",14,2},;
{"PIS"      ,"N",14,2},;
{"VLRPIS"   ,"N",14,2},;
{"VEND"     ,"C",06,0},;
{"NVEN"     ,"C",30,0},;
{"REPR"     ,"C",06,0},;
{"NREP"     ,"C",30,0}}


If ( Select ( "cNomeArq" ) <> 0 )
	dbSelectArea ( "cNomeArq" )
	dbCloseArea ()
End

cNomeArq := CriaTrab(aCampos)
MSGSTOP(cNomeArq)
//dbUseArea( .T.,, cNomeArq, "cNomeArq", NIL, .F. )

USE &cNomeArq Alias "TRAB" New

DBSELECTAREA("SD2")
DBSETORDER(5)
DBGOTOP()

SetRegua(RecCount())		// Total de Elementos da regua

While !EOF()
	
	IF SD2->D2_EMISSAO < mv_par01 .OR. SD2->D2_EMISSAO > mv_par02
		DBSELECTAREA("SD2")
		DBSKIP()
		LOOP
	ENDIF
	
	IF SD2->D2_COD < mv_par03 .OR. SD2->D2_COD > mv_par04
		DBSELECTAREA("SD2")
		DBSKIP()
		LOOP
	ENDIF
	IF SD2->D2_CF < mv_par05 .OR. SD2->D2_CF > mv_par06
		DBSELECTAREA("SD2")
		DBSKIP()
		LOOP
	ENDIF
	IF SD2->D2_EST < mv_par07 .OR. SD2->D2_EST > mv_par08
		DBSELECTAREA("SD2")
		DBSKIP()
		LOOP
	ENDIF
	
	IF SD2->D2_TIPO <> "N"
		DBSELECTAREA("SD2")
		DBSKIP()
		LOOP
	ENDIF
	
	DBSELECTAREA("SB1")
	DBSETORDER(1)
	DBSEEK(XFILIAL()+SD2->D2_COD)
	_CDESC := SB1->B1_DESC
	_CIPI  := SB1->B1_POSIPI
	
	IF SB1->B1_POSIPI < mv_par09 .OR. SB1->B1_POSIPI > mv_par10
		DBSELECTAREA("SD2")
		DBSKIP()
		LOOP
	ENDIF
	
	DBSELECTAREA("SF2")
	DBSETORDER(1)
	DBSEEK(XFILIAL()+SD2->D2_DOC)
	_CVEND := SF2->F2_VEND1
	_CREPR := SF2->F2_VEND2
	_CNVEN := POSICIONE("SA3",1,XFILIAL("SA3")+SF2->F2_VEND1,"A3_NOME")
	_CNREP := POSICIONE("SA3",1,XFILIAL("SA3")+SF2->F2_VEND2,"A3_NOME")

	DBSELECTAREA("SD2")
	
	If lEnd
		@ Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	EndIf
	//EMISSAO  NOTA   SER CLIENTE                             PRODUTO         CLAS.IPI   UF CFOP  VLR.BRUTO A.ICM BSE ICMS  VLR.ICMS  A.IPI BASE IPI  VLR.IPI   BASE ISS VLR.ISS  %COF  VLR.COFI % PIS VLR. PIS
	//99/99/99 123456 123 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXX XXXXXXXXXX XX XXXXX 999999.99 99.99 999999.99 999999.99 99.99 999999.99 999999.99 99999.99 99999.99 99.99 99999.99 99.99 999999.99
	//123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	//         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6
	//                                                                                                   1                                                                                                   2
	cabec1 := "EMISSAO  NOTA   SER CLIENTE                             PRODUTO         CLAS.IPI    UF CFOP  VLR.BRUTO A.ICM BSE ICMS  VLR.ICMS  A.IPI BASE IPI  VLR.IPI   BASE ISS VLR.ISS  %COF  VLR.COFI % PIS VLR. PIS"
	cabec2 := ""
	
	IF li > 55
		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
		
		Li:=08
	Endif
	
	@li,000 psay CHR(15)
	@li,001 psay D2_EMISSAO
	@li,010 psay SD2->D2_DOC
	@li,017 psay SD2->D2_SERIE
	_CNOME := POSICIONE("SA1",1,XFILIAL("SA1")+SD2->D2_CLIENTE+SD2->D2_LOJA,"A1_NOME")
	@li,021 psay SUBSTR(_CNOME,1,35)
	@li,057 psay SD2->D2_COD
    //li,072 psay SUBSTR(_CDESC,1,40)
	@li,073 psay _CIPI
	@li,084 psay SD2->D2_EST
	@li,087 psay SD2->D2_CF
	@li,093 psay SD2->D2_VALBRUT Picture PesqPict("SD2","D2_VALBRUT",09)
	@li,103 psay SD2->D2_PICM  	 Picture PesqPict("SD2","D2_PICM"   ,05)
	@li,109 psay SD2->D2_BASEICM Picture PesqPict("SD2","D2_BASEICM",09)
	@li,119 psay SD2->D2_VALICM  Picture PesqPict("SD2","D2_VALICM" ,09)
	@li,129 psay SD2->D2_IPI     Picture PesqPict("SD2","D2_IPI"    ,05)
	@li,135 psay SD2->D2_BASEIPI Picture PesqPict("SD2","D2_BASEIPI",09)
	@li,145 psay SD2->D2_VALIPI  Picture PesqPict("SD2","D2_VALIPI" ,09)
	@li,155 psay SD2->D2_BASEISS Picture PesqPict("SD2","D2_BASEISS",09)
	@li,164 psay SD2->D2_VALISS  Picture PesqPict("SD2","D2_VALISS" ,09)
	@li,173 psay SD2->D2_ALQIMP5 Picture PesqPict("SD2","D2_ALQIMP5",05)
	@li,179 psay SD2->D2_VALIMP5 Picture PesqPict("SD2","D2_VALIMP5",09)
	@li,188 psay SD2->D2_ALQIMP6 Picture PesqPict("SD2","D2_ALQIMP6",05)
	@li,194 psay SD2->D2_VALIMP6 Picture PesqPict("SD2","D2_VALIMP6",09)
	@li,213 psay _CVEND

	LI++
	
    _NTOTAL := _NTOTAL + SD2->D2_VALBRUT  //93
    _NICM   := _NICM   + SD2->D2_VALICM   //119
    _NIPI   := _NIPI   + SD2->D2_VALIPI   //145

	DBSELECTAREA("TRAB")
	RECLOCK("TRAB",.T.)
	TRAB->EMISSAO:= SD2->D2_EMISSAO
	TRAB->NOTA   := SD2->D2_DOC
	TRAB->SERIE  := SD2->D2_SERIE
	TRAB->CLIENTE:= SD2->D2_CLIENTE
	TRAB->NOME   := _CNOME
	TRAB->PRODUTO:= SD2->D2_COD
	TRAB->DESC   := _CDESC
	TRAB->POSIPI := _CIPI
	TRAB->UF     := SD2->D2_EST
	TRAB->CFOP   := SD2->D2_CF
	TRAB->VLRBRUT:= SD2->D2_VALBRUT
	TRAB->ICMS   := SD2->D2_PICM
	TRAB->BASEICM:= SD2->D2_BASEICM
	TRAB->VLRICM := SD2->D2_VALICM
	TRAB->IPI    := SD2->D2_IPI
	TRAB->BASEIPI:= SD2->D2_BASEIPI
	TRAB->VLRIPI := SD2->D2_VALIPI
	TRAB->BASEISS:= SD2->D2_BASEISS
	TRAB->VLRISS := SD2->D2_VALISS
	TRAB->COFINS := SD2->D2_ALQIMP5
	TRAB->VLRCOF := SD2->D2_VALIMP5
	TRAB->PIS    := SD2->D2_ALQIMP6
	TRAB->VLRPIS := SD2->D2_VALIMP6
    TRAB->VEND   := _CVEND
    TRAB->NVEN   := _CNVEN
    TRAB->REPR   := _CREPR
    TRAB->NREP   := _CNREP

	MSUNLOCK("TRAB")
	
	dbSelectArea("SD2")
	dbSkip()
End

IF _NTOTAL > 0
	@li,000 PSAY REPLICATE("*",220)
	LI++
	@li,000 psay "TOTAL GERAL --> "
	@li,093 psay _NTOTAL  Picture PesqPict("SE1","E1_VALOR"   ,10)
	@li,119 psay _NICM    Picture PesqPict("SE1","E1_VALLIQ"  ,10)
	@li,145 psay _NIPI    Picture PesqPict("SE1","E1_VALLIQ"  ,10)
ENDIF


Set Device To Screen
dbCommitAll()
If aReturn[5] == 1
	Set Printer TO
	//	dbcommitAll()
	ourspool(wnrel)
Endif
DBSELECTAREA("TRAB")
DBCLOSEAREA()

MS_FLUSH()