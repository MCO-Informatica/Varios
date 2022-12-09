#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#DEFINE CHRCOMP If(aReturn[4]==1,15,18)

/*/
�������������������������������������������������������������������������Ŀ��
���Programa  � MATR730  � Autor � Ricardo Cavalini  � Data � 14/06/2006   ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Emissao de nota faturadas                                    ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
/*/
User Function fat004()
//������������������������������������������������������������������������Ŀ
//�Define Variaveis                                                        �
//��������������������������������������������������������������������������
Local Titulo  := "Emissao de Titulos do Contas a Pagar"
Local cDesc1  := "Emissao de titulos conforme parametros."
Local cDesc2  := ""
Local cDesc3  := ""
Local cString := "SE2"  // Alias utilizado na Filtragem
Local lDic    := .F. // Habilita/Desabilita Dicionario
Local lComp   := .F. // Habilita/Desabilita o Formato Comprimido/Expandido
Local lFiltro := .F. // Habilita/Desabilita o Filtro
Local wnrel   := "RFAT004" // Nome do Arquivo utilizado no Spool
Local nomeprog:= "RFAT004"
Local cPerg   := "FAT004    "
Private Tamanho := "G" // P/M/G
Private Limite  := 220 // 80/132/220
Private aOrdem  := {}  // Ordem do Relatorio
Private aReturn := { "Zebrado", 2,"Administracao", 1, 2, 1, "",0 } //"Zebrado"###"Administracao"
//[1] Reservado para Formulario
//[2] Reservado para N� de Vias
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
_CMOT := ""
_CBCO := ""
_CCHQ := ""
_NCMP := 0

//������������������������������������������������������������������������Ŀ
//�Verifica as Perguntas Seleciondas                                       �
//��������������������������������������������������������������������������
Pergunte(cPerg,.F.)
//������������������������������������������������������������������������Ŀ
//�Envia para a SetPrinter                                                 �
//��������������������������������������������������������������������������

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

RptStatus({|lEnd| FAT004(@lEnd,wnRel,cString,nomeprog,Titulo)},Titulo)
RptStatus({|lEnd| FAT04A(@lEnd,wnRel,cString,nomeprog,Titulo)},Titulo)

Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Program   � FAT004    � Autor � Eduardo J. Zanardo   � Data �26.12.2001���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Controle de Fluxo do Relatorio.                             ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function FAT004(lEnd,wnrel,cString,nomeprog,Titulo)

Local aPedCli    := {}
Local aStruSC5   := {}
Local aStruSC6   := {}
Local aC5Rodape  := {}
Local aRelImp    := MaFisRelImp("MT100",{"SF1","SD1"})
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
aCampos:={  {"SERIE  "  ,"C",03,0},;
			{"NOTA   "  ,"C",06,0},;
			{"PARCELA"  ,"C",01,0},;
			{"TIPO"     ,"C",03,0},;
			{"PORTADOR" ,"C",04,0},;
			{"CLIENTE"  ,"C",06,0},;
			{"NOME"     ,"C",40,0},;
			{"EMISSAO"  ,"D",08,0},;
			{"VENCTO "  ,"D",08,0},;
			{"BAIXA "   ,"D",08,0},;
			{"VLRBRUT"  ,"N",14,2},;
			{"MULTA"    ,"N",14,2},;
			{"JUROS"    ,"N",14,2},;
			{"DESCONT"  ,"N",14,2},;
			{"CMP"      ,"N",14,2},;
			{"VLRLIQ"   ,"N",14,2},;
			{"SALDO"    ,"N",14,2},;
			{"BXBCO"    ,"C",06,0},;
			{"CHEQUE"   ,"C",15,0},;
			{"SITUACA"  ,"C",01,0},;
			{"MOTIVO"   ,"C",05,0}}
			
If ( Select ( "cNomeArq" ) <> 0 )
	dbSelectArea ( "cNomeArq" )
	dbCloseArea ()
End

// Cria arquivo e index
W_ARQ := CriaTrab(aCampos)
MSGSTOP(W_ARQ)
W_IND1 := criatrab(NIL,.f.)+".1"

// Arquivo Temporario Principal
dbUseArea( .t.,, W_ARQ, 'TRAB', .F. )

index on TRAB->SITUACA+DTOS(TRAB->BAIXA)+DTOS(TRAB->EMISSAO) to &W_IND1
set index to &W_IND1

//USE &cNomeArq Alias "TRAB" New
 
DBSELECTAREA("SE2")
DBSETORDER(1)
DBGOTOP()

SetRegua(RecCount())		// Total de Elementos da regua

While !EOF()
	
	IF SE2->E2_EMISSAO < mv_par01 .OR. SE2->E2_EMISSAO > mv_par02
		DBSELECTAREA("SE2")
		DBSKIP()
		LOOP
	ENDIF
	
	IF SE2->E2_VENCREA < mv_par03 .OR. SE2->E2_VENCREA > mv_par04
		DBSELECTAREA("SE2")
		DBSKIP()
		LOOP
	ENDIF
	IF SE2->E2_FORNECE < mv_par05 .OR. SE2->E2_FORNECE > mv_par06
		DBSELECTAREA("SE2")
		DBSKIP()
		LOOP
	ENDIF
	IF SE2->E2_PORTADO < mv_par07 .OR. SE2->E2_PORTADO > mv_par08
		DBSELECTAREA("SE2")
		DBSKIP()
		LOOP
	ENDIF
	
	IF SE2->E2_TIPO $ "PA /NCC/AB-"
		DBSELECTAREA("SE2")
		DBSKIP()
		LOOP
	ENDIF
	
	If lEnd
		@ Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	EndIf
    
	_CPRF  := SE2->E2_PREFIXO
	_CTIT  := SE2->E2_NUM
	_CPARC := SE2->E2_PARCELA                
    _NCMP  := 0
    _NVLRX := SE2->E2_VALOR
	
    IF !EMPTY(SE2->E2_BAIXA)
       DBSELECTAREA("SE5")
       DBSETORDER(7)
       DBSEEK(XFILIAL()+_CPRF+_CTIT+_CPARC)
       WHILE !EOF() .AND. _CPRF == SE5->E5_PREFIXO .AND. _CTIT == SE5->E5_NUMERO .AND. _CPARC == SE5->E5_PARCELA

             IF SE5->E5_TIPODOC == "CP"
 			       _NCMP := _NCMP + SE5->E5_VALOR
             ELSEIF SE5->E5_TIPODOC == "VL"
		       _CMOT := SE5->E5_MOTBX
		       _CBCO := SE5->E5_BANCO
		       _CCHQ := SE5->E5_NUMCHEQ
             ENDIF

             DBSELECTAREA("SE5")
             DBSKIP()
       END      
    ENDIF

    DBSELECTAREA("SE2")
    
	DBSELECTAREA("TRAB")
	RECLOCK("TRAB",.T.)
	TRAB->SERIE    := SE2->E2_PREFIXO
	TRAB->NOTA     := SE2->E2_NUM
	TRAB->PARCELA  := SE2->E2_PARCELA
	TRAB->TIPO     := SE2->E2_TIPO
	TRAB->PORTADOR := SE2->E2_PORTADO
	TRAB->CLIENTE  := SE2->E2_FORNECE
	TRAB->NOME     := SE2->E2_NOMFOR
	TRAB->EMISSAO  := SE2->E2_EMISSAO
	TRAB->VENCTO   := SE2->E2_VENCTO
	TRAB->BAIXA    := SE2->E2_BAIXA
	TRAB->VLRBRUT  := SE2->E2_VALOR
	TRAB->VLRLIQ   := SE2->E2_VALLIQ
	TRAB->MULTA    := SE2->E2_MULTA
	TRAB->JUROS    := SE2->E2_JUROS
	TRAB->DESCONT  := SE2->E2_DESCONT
//  TRAB->SITUACA  := SE2->E2_SITUACA
    TRAB->BXBCO    := _CBCO
    TRAB->CHEQUE   := _CCHQ
    TRAB->MOTIVO   := _CMOT
    TRAB->CMP      := _NCMP
    TRAB->SALDO    := SE2->E2_SALDO
	MSUNLOCK("TRAB")
	
	dbSelectArea("SE2")
	dbSkip()
End
RETURN

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Program   � FAT003    � Autor � Eduardo J. Zanardo   � Data �26.12.2001���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Controle de Fluxo do Relatorio.                             ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function FAT04A(lEnd,wnrel,cString,nomeprog,Titulo)

// TITULOS BAIXADOS
DBSELECTAREA("TRAB")
DBSETORDER(1)
DBGOTOP()

SetRegua(RecCount())		// Total de Elementos da regua
LI       := 100
_NVLRBRT := 0
_NVLRLIQ := 0  
_NCMPXX  := 0
_NDESCX  := 0
_NMULTAX := 0
_NJUROSX := 0
_NSALDOX := 0
_NVLRZER := 0
titulo := titulo + " - Pagos"
While !EOF()
	
	If lEnd
		@ Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	EndIf

	//PRF NUM    PARC TIPO PORTADOR CLIENTE NOME                                     EMISSAO  DT.VENCTO DT.BAIXA  VLR.BRUTO  VLR.MULTA  VLR.JUROS  VLR.DESC   VLR.COMP   V.RECEBTO  SDO RECEB  MOT SITUAC"
	//123 123456 1    123  123      123456  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/99/99 99/99/99  99/99/99  999999.99  999999.99  999999.99  999999.99  999999.99  999999.99  999999.99  XXX X
	//123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	//         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6
	//                                                                                                   1                                                                                                   2
	cabec1 := "PRF NUM    PARC TIPO PORTADOR FORNEC  NOME                                     EMISSAO  DT.VENCTO DT.BAIXA  VLR.BRUTO  VLR.MULTA  VLR.JUROS  VLR.DESC   VLR.COMP   V.RECEBTO  SDO RECEB  MOT SITUAC"
	cabec2 := ""
	
	IF li > 55
		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
		Li:=08
	Endif

    IF EMPTY(TRAB->BAIXA)
       DBSELECTAREA("TRAB")
       DBSKIP()
       LOOP
    ENDIF

    IF TRAB->VLRLIQ = 0
       DBSELECTAREA("TRAB")
       DBSKIP()
       LOOP
    ENDIF    
    
    IF TRAB->BAIXA == CTOD("  /  /  ")
       DBSELECTAREA("TRAB")
       DBSKIP()
       LOOP
    ENDIF

	@li,000 psay CHR(15)
	@li,001 psay TRAB->SERIE
	@li,005 psay TRAB->NOTA
	@li,012 psay TRAB->PARCELA
	@li,017 psay TRAB->TIPO
	@li,022 psay TRAB->PORTADOR
	@li,031 psay TRAB->CLIENTE
	@li,039 psay TRAB->NOME
	@li,080 psay TRAB->EMISSAO
	@li,089 psay TRAB->VENCTO
	@li,099 psay TRAB->BAIXA
	@li,109 psay TRAB->VLRBRUT  Picture PesqPict("SE2","E2_VALOR"   ,10)
	@li,120 psay TRAB->MULTA    Picture PesqPict("SE2","E2_MULTA"   ,10) 
	@li,131 psay TRAB->JUROS    Picture PesqPict("SE2","E2_JUROS"   ,10) 
	@li,142 psay TRAB->DESCONT  Picture PesqPict("SE2","E2_DESCONT" ,10) 
	@li,153 psay TRAB->CMP      Picture PesqPict("SE2","E2_VALLIQ"  ,10)

    IF TRAB->CMP > 0
        IF (TRAB->CMP-TRAB->VLRLIQ) < 0
  	       @li,164 psay TRAB->VLRLIQ   Picture PesqPict("SE2","E2_VALLIQ"  ,10)
        ELSEIF (TRAB->VLRLIQ-TRAB->CMP) < 0
  	       @li,164 psay TRAB->VLRLIQ   Picture PesqPict("SE2","E2_VALLIQ"  ,10)
        ELSE
           @li,164 psay _NVLRZER       Picture PesqPict("SE2","E2_VALLIQ"  ,10)
        ENDIF
    ELSEIF TRAB->CMP = 0
 	   @li,164 psay TRAB->VLRLIQ   Picture PesqPict("SE2","E2_VALLIQ"  ,10)    
    ENDIF

	@li,175 psay TRAB->SALDO    Picture PesqPict("SE2","E2_VALLIQ"  ,10)
	@li,186 psay TRAB->MOTIVO

	LI++
    _NVLRBRT := _NVLRBRT + TRAB->VLRBRUT

    IF TRAB->CMP > 0
	    IF (TRAB->CMP-TRAB->VLRLIQ) < 0
	       _NVLRLIQ := _NVLRLIQ + TRAB->VLRLIQ
	    ELSEIF (TRAB->VLRLIQ-TRAB->CMP) < 0
	       _NVLRLIQ := _NVLRLIQ + TRAB->VLRLIQ
	    ELSE
		    _NVLRLIQ := _NVLRLIQ + _NVLRZER
	    ENDIF
    ELSEIF TRAB->CMP = 0
       _NVLRLIQ := _NVLRLIQ + TRAB->VLRLIQ
    ENDIF


    _NDESCX  := _NDESCX  + TRAB->DESCONT
    _NMULTAX := _NMULTAX + TRAB->MULTA
    _NJUROSX := _NJUROSX + TRAB->JUROS
    _NCMPXX  := _NCMPXX  + TRAB->CMP
    _NSALDOX := _NSALDOX + TRAB->SALDO
	DBSELECTAREA("TRAB")
	dbSkip()
End
IF _NVLRBRT > 0
	@li,000 PSAY REPLICATE("*",220)
	LI++
	@li,000 psay "TOTAL DE TITULOS PAGOS     --> "
	@li,109 psay _NVLRBRT  Picture PesqPict("SE2","E2_VALOR"   ,10)
	@li,120 psay _NDESCX   Picture PesqPict("SE2","E2_DESCONT" ,10)
	@li,131 psay _NMULTAX  Picture PesqPict("SE2","E2_MULTA"   ,10)
	@li,142 psay _NJUROSX  Picture PesqPict("SE2","E2_JUROS"   ,10)
	@li,153 psay _NVLRLIQ  Picture PesqPict("SE2","E2_VALLIQ"  ,10)
	@li,164 psay _NCMPXX   Picture PesqPict("SE2","E2_VALLIQ"  ,10)
	@li,175 psay _NSALDOX  Picture PesqPict("SE2","E2_VALLIQ"  ,10)
ENDIF


// TITULOS EM ABERTO
DBSELECTAREA("TRAB")
DBSETORDER(1)
DBGOTOP()

SetRegua(RecCount())		// Total de Elementos da regua
li       := 100
_NVLRBRT := 0
_NVLRLIQ := 0
titulo := titulo + " - a Pagar"
While !EOF()
	
	If lEnd
		@ Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	EndIf


	//PRF NUM    PARC TIPO PORTADOR CLIENTE NOME                                     EMISSAO  DT.VENCTO DT.BAIXA  VLR.BRUTO  VLR. DESC  VLR.MULTA  VLR.JUROS  VLR.LIQUIDO"
	//123 123456 1    123  123      123456  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/99/99 99/99/99  99/99/99  999999.99  999999.99  999999.99  999999.99  999999.99
	//123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	//         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6
	//                                                                                                   1                                                                                                   2
	cabec1 := "PRF NUM    PARC TIPO PORTADOR FORNEC  NOME                                     EMISSAO  DT.VENCTO DT.BAIXA  VLR.BRUTO  VLR. DESC  VLR.MULTA  VLR.JUROS  VLR.LIQUIDO"
	cabec2 := ""
	
	IF li > 55
		Cabec(titulo,cabec1,cabec2,nomeprog,tamanho)
		Li:=08
	Endif

    IF !EMPTY(TRAB->BAIXA)
       DBSELECTAREA("TRAB")
       DBSKIP()
       LOOP
    ENDIF

    IF TRAB->VLRLIQ <> 0
       DBSELECTAREA("TRAB")
       DBSKIP()
       LOOP
    ENDIF

	@li,000 psay CHR(15)
	@li,001 psay TRAB->SERIE
	@li,005 psay TRAB->NOTA
	@li,012 psay TRAB->PARCELA
	@li,017 psay TRAB->TIPO
	@li,022 psay TRAB->PORTADOR
	@li,031 psay TRAB->CLIENTE
	@li,039 psay TRAB->NOME
	@li,080 psay TRAB->EMISSAO
	@li,089 psay TRAB->VENCTO
	@li,099 psay TRAB->BAIXA
	@li,109 psay TRAB->VLRBRUT  Picture PesqPict("SE2","E2_VALOR"   ,10)
	@li,120 psay TRAB->DESCONT  Picture PesqPict("SE2","E2_DESCONT" ,10)
	@li,131 psay TRAB->MULTA    Picture PesqPict("SE2","E2_MULTA"   ,10)
	@li,142 psay TRAB->JUROS    Picture PesqPict("SE2","E2_JUROS"   ,10)
	@li,153 psay TRAB->VLRLIQ   Picture PesqPict("SE2","E2_VALLIQ"  ,10)
	@li,175 psay TRAB->MOTIVO

	LI++
    _NVLRBRT := _NVLRBRT + TRAB->VLRBRUT
    _NVLRLIQ := _NVLRLIQ + TRAB->VLRLIQ

	DBSELECTAREA("TRAB")
	dbSkip()
End
IF _NVLRBRT > 0
	@li,000 PSAY REPLICATE("*",220)
	LI++
	@li,000 psay "TOTAL DE TITULOS A PAGAR  --> "
	@li,109 psay _NVLRBRT  Picture PesqPict("SE2","E2_VALOR"   ,10)
	@li,153 psay _NVLRLIQ  Picture PesqPict("SE2","E2_VALLIQ"  ,10)
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
