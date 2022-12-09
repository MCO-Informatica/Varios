#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 09/04/03
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function MTR730()        // incluido pelo assistente de conversao do AP6 IDE em 09/04/03

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcaao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("WNREL,TAMANHO,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("NREGISTRO,CKEY,NINDEX,CINDEX,CCONDICAO,LEND")
SetPrvt("CPERG,ARETURN,NOMEPROG,NLASTKEY,NBEGIN,ALINHA")
SetPrvt("LI,LIMITE,LRODAPE,CPICTQTD,NTOTQTD,NTOTVAL")
SetPrvt("APEDCLI,CSTRING,CFILTER,CPEDIDO,_COBSERV,CHEADER")
SetPrvt("NPED,CMOEDA,CCAMPO,CCOMIS,I,NIPI")
SetPrvt("NVIPI,NBASEIPI,NVALBASE,LIPIBRUTO,NPERRET,CESTADO")
SetPrvt("TNORTE,CESTCLI,CINSCRCLI,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 09/04/03 ==>     #DEFINE PSAY SAY
#ENDIF
/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Funcao    ³ MATR730  ³ Autor ³ Tadeu Henrique        ³ Data ³ 23.12.98 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descricao ³ Emissao da Pr‚-Nota                                        ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Sintaxe   ³ MATR730(void)                                              ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Uso      ³ Generico                                                   ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*/
wnrel            :=""
tamanho          :="P"
titulo           :="Emissao da Confirmacao do Pedido"
cDesc1           :="Emiss„o da confirmac„o dos pedidos de venda, de acordo com"
cDesc2           :="intervalo informado na op‡„o Parƒmetros."
cDesc3           :=" "
nRegistro        := 0
cKey             :=""
nIndex           :=""
cIndex           :=""  //  && Variaveis para a criacao de Indices Temp.
cCondicao        :=""
lEnd             := .T.
cPerg            :="MTR730"
aReturn          := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
nomeprog         :="MATR730"
nLastKey         := 0
nBegin           :=0
aLinha           :={ }
li               :=80
limite           :=132
lRodape          :=.F.
cPictQtd         :=""
nTotQtd          :=nTotVal:=0
aPedCli          := {}
wnrel            := "MTR730p"
cString          := "SC6"
Private _nTotPeso	:= 0

pergunte("MTR730",.F.)

// mv_par01              Do Pedido                          
// mv_par02              Ate o Pedido                         

wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.)
If nLastKey==27
   Return
Endif
SetDefault(aReturn,cString)
If nLastKey==27
   Return
Endif
#IFDEF WINDOWS
    RptStatus({||C730Imp()})// Substituido pelo assistente de conversao do AP6 IDE em 09/04/03 ==>     RptStatus({||Execute(C730Imp)})
    Return
// Substituido pelo assistente de conversao do AP6 IDE em 09/04/03 ==>     Function C730IMP
Static Function C730IMP()
#ENDIF
tamanho        :="P"
titulo         :="EMISSAO DO CONFIRMACAO DO PEDIDO"
cDesc1         :="Emiss„o da confirmac„o dos pedidos de venda, de acordo com"
cDesc2         :="intervalo informado na opcao Parƒmetros."
cDesc3         :=" "
nRegistro      := 0
cKey           :=""
nIndex         :=""
cIndex         :=""//  && Variaveis para a criacao de Indices Temp.
cCondicao      :=""

pergunte("MTR730",.F.)
cIndex  := CriaTrab(nil,.f.)
dbSelectArea("SC5")
cKey    := IndexKey()
cFilter := dbFilter()
cFilter := cFilter := If( Empty( cFilter ),""," .And. " )
#IFDEF AS400
    cFilter := cFilter:= 'C5_FILIAL == "'+xFilial("SC5")+'" .And. C5_NUM >= "'+mv_par01+'" .And. C5_NUM <= "'+mv_par02+'" '
#ELSE
    cFilter := cFilter:= "C5_FILIAL==xFilial('SC5') .And. C5_NUM >= mv_par01 .AND. C5_NUM <= mv_par02 "
#ENDIF
IndRegua("SC5",cIndex,cKey,,cFilter,"Selecionando Registros...")
nIndex := RetIndex("SC5")
DbSelectArea("SC5")
//#IFNDEF AS400
//    DbSetIndex(cIndex)
//#ENDIF

DbSetOrder(nIndex+1)
DbGoTop()
SetRegua(RecCount())		// Total de Elementos da regua
While !Eof() .And. C5_NUM <= mv_par02
	nTotQtd:=0
	nTotVal:=0
	cPedido := C5_NUM
*        _cObserv:= c5_teste
	dbSelectArea("SA4")
	dbSeek(xFilial()+SC5->C5_TRANSP)
	dbSelectArea("SA3")
	dbSeek(xFilial()+SC5->C5_VEND1)
	dbSelectArea("SE4")
	dbSeek(xFilial()+SC5->C5_CONDPAG)
	
	dbSelectArea("SC6")
	dbSeek(xFilial()+cPedido)
	cPictQtd := PESQPICTQT("C6_QTDVEN",10)
	nRegistro:= RECNO()
	#IFNDEF WINDOWS
	If LastKey() == 286    //ALT_A
		lEnd := .t.
		exit
	End
	#ENDIF
	
	IF LastKey() == 286
		@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta tabela de pedidos do cliente p/ o cabe‡alho            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aPedCli:= {}
	While !Eof() .And. C6_NUM == SC5->C5_NUM
		IF !Empty(SC6->C6_PEDCLI) .and. Ascan(aPedCli,SC6->C6_PEDCLI) == 0
			AAdd(aPedCli,SC6->C6_PEDCLI)
		ENDIF
		dbSkip()
	Enddo
	aSort(aPedCli)
	
	dbGoTo( nRegistro )
	While !Eof() .And. C6_NUM == SC5->C5_NUM
		#IFNDEF WINDOWS
		If LastKey() == 286    //ALT_A
			lEnd := .t.
		End
		#ENDIF
		
		IF LastKey()==27
			@Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
			Exit
		Endif
		
        If li > 48
            If lRodape
                ImpRodape()
                lRodape := .F.
            Endif
            li := 0
            ImpCabec()
        Endif

		ImpItem()
		dbSkip()
		li:=li+1
	Enddo
	
	IF lRodape
		ImpRodape()
		lRodape:=.F.
	Endif

	_nTotPeso := 0
	dbSelectArea("SC5")
	dbSkip()
	
	IncRegua()
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta Arquivo Temporario e Restaura os Indices Nativos.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RetIndex("SC5")
DBClearFilter()

Ferase(cIndex+OrdBagExt())

dbSelectArea("SC6")
DBClearFilter()
dbSetOrder(1)
dbGotop()
Set device to screen

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCabec ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 05.11.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissao da Pr‚-Nota                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpCabec(void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Matr730                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 09/04/03 ==> Function ImpCabec
Static Function ImpCabec()

Local nPed := 0
Local i := 0

lRodape     := .T.
cHeader     :=""
nPed        :=""
cMoeda      :=""
cCampo      :=""
cComis      :=""
cHeader     := "It Codigo          Desc. do Material       UM      Quant.   Prc Unitario     Total-Desc+IPI       Entrega    Loc.             Saldo "
*It Codigo          Desc. do Material     UM    Quant.  Valor Unit.             Vl.Tot.C/IPI Entrega       Loc.                   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona registro no cliente do pedido                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


IF !(SC5->C5_TIPO$"DB")
	dbSelectArea("SA1")
	dbSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
Else
	dbSelectArea("SA2")
	dbSeek(xFilial()+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
Endif
* Compressao de dados
@ 0,0 PSAY CHR(15)
@ 01,000 PSAY Replicate("-",limite)

If xFilial("SC5") <> "90"
@ 02,000 PSAY 'PRIORIDADE: '+SC5->C5_X_PRIOR
Else

@ 02,000 PSAY 'HERMES'

EndIf
//@ 05,000 BITMAP SIZE 050,050 FILE "\system\lgrl90.bmp"


IF !(SC5->C5_TIPO$"DB")
   @ 02,041 PSAY "| "+SA1->A1_COD+"/"+SA1->A1_LOJA+" - "+Alltrim(Substr(SA1->A1_NOME,1,40))
   @ 02,100 PSAY "| CONFIRMACAO DO PEDIDO "
// @ 03,041 PSAY "| "+IF(!Empty(SA1->A1_ENDENT).And.SA1->A1_ENDENT#SA1->A1_END, SA1->A1_ENDENT,SA1->A1_END)
   @ 03,041 PSAY "| "+Alltrim(SA1->A1_END)
   @ 03,100 PSAY "|"
   @ 04,041 PSAY "| "+Alltrim(SA1->A1_CEP)
   @ 04,053 PSAY Alltrim(SA1->A1_MUN)
   @ 04,077 PSAY Alltrim(SA1->A1_EST)
   @ 04,080 PSAY SA1->A1_DDD + SA1->A1_TEL
   @ 04,100 PSAY "| EMISSAO: "
   @ 04,110 PSAY SC5->C5_EMISSAO
   @ 05,041 PSAY "|"
   @ 05,043 PSAY Alltrim(SA1->A1_CGC)    Picture "@R 99.999.999/9999-99"
   @ 05,062 PSAY "IE: "+Alltrim(SA1->A1_INSCR)
   @ 05,100 PSAY "| PEDIDO N. "+SC5->C5_NUM
   @ 06,043 PSAY "SUSPENSAO DE I P I :  "+Alltrim(SA1->A1_SUSPIPI)
         
Else
   @ 02,041 PSAY "| "+SA2->A2_COD+"/"+SA2->A2_LOJA+" - "+SA2->A2_NOME
   @ 02,100 PSAY "| CONFIRMACAO DO PEDIDO "
   @ 03,000 PSAY SM0->M0_ENDCOB
   @ 03,041 PSAY "| "+ SA2->A2_END
   @ 03,100 PSAY "|"
   @ 04,000 PSAY "TEL: "+SM0->M0_TEL
   @ 04,041 PSAY "| "+SA2->A2_CEP
   @ 04,053 PSAY SA2->A2_MUN
   @ 04,077 PSAY SA2->A2_EST
   @ 04,080 PSAY SA1->A1_DDD + SA1->A1_TEL
   @ 04,100 PSAY "| EMISSAO: "
   @ 04,111 PSAY SC5->C5_EMISSAO
   @ 05,000 PSAY "CGC: "
   @ 05,005 PSAY SM0->M0_CGC    Picture "@R 99.999.999/9999-99"
   @ 05,025 PSAY Subs(SM0->M0_CIDCOB,1,15)
   @ 05,041 PSAY "|"
   @ 05,043 PSAY SA2->A2_CGC    Picture "@R 99.999.999/9999-99"
   @ 05,062 PSAY "IE: "+SA2->A2_INSCR
   @ 05,100 PSAY "| PEDIDO N. "+SC5->C5_NUM
Endif

li:= 6
For nPed := 1 To Len(aPedCli)
//	@ li,044 PSAY "|"
	@ li,100 PSAY "| S/PEDIDO  "+Alltrim(aPedCli[nPed])
//	li:=Li+1
Next

li:=Li+1

@ li,000 PSAY Replicate("-",limite)                                                                                                              
li:=li+1
@ li,000 PSAY "TRANSP...: "+SC5->C5_TRANSP+" - "+SA4->A4_NOME + " - " + "FONE: " + SA4->A4_TEL + "                  " + "PV PORTAL ?: " + SC5->C5_PORTAL
li:=li+1                                                                                                                                                                  
@ li,000 PSAY "End.Transp.: "+SA4->A4_END + " - " + SA4->A4_MUN + " - " + SA4->A4_EST + "."

li:=li+1
For i := 1 to 5
   cCampo := "SC5->C5_VEND" + Str(i,1,0)
   cComis := "SC5->C5_COMIS" + Str(i,1,0)   
   cOrigem := SC5->C5_X_ORIG
   dbSelectArea("SX3")
   dbSetOrder(2)
   dbSeek(cCampo)
   If !Eof()
       Loop
   Endif
   If !Empty(&cCampo)
      dbSelectArea("SA3")
      dbSeek(xFilial()+&cCampo)
      If i == 1
         @ li,000 PSAY "VENDEDOR.: "
      EndIf
      @ li,013 PSAY &cCampo + " - "+Alltrim(SA3->A3_NOME)
      If i == 1
         @ li,065 PSAY "COMISSAO: "
      EndIf    
      
       if cOrigem == 'W'
       @ li,102 PSAY "PEDIDO DE VENDA = WCA  
	   ElseIf cOrigem == 'H'
	   @ li,102 PSAY "PEDIDO DE VENDA = HRM  
       endif
      
       @ li,075 PSAY &cComis Picture "99.99"
      li:=li+1  
        
  
      
      
   Endif
Next
li:=li+1

@ li,000 PSAY "End.Entrega: " + SA1->A1_ENDENT + " - " + SA1->A1_BAIRENT + " - " + SA1->A1_CEPENT + " - " + SA1->A1_MUNENT + " - " + SA1->A1_UFENT + "."

li:=li+1
@ li,000 PSAY "COND.PGTO: "+SC5->C5_CONDPAG+" - "+SE4->E4_DESCRI
@ li,065 PSAY "FRETE...: "
@ li,075 PSAY SC5->C5_FRETE  Picture "@EZ 999,999,999.99"
  li:=li+1
@ li,065 PSAY "VOLUMES.: "
@ li,075 PSAY SC5->C5_VOLUME1    Picture "@EZ 999,999"
@ li,090 PSAY "ESPECIE: "+SC5->C5_ESPECI1
  li:=li+1
@ li,000 PSAY "Tipo do Frete"
@ li,015 PSAY SC5->C5_TPFRETE
  cMoeda:=Strzero(SC5->C5_MOEDA,1,0)
  li:=li+1
@ li,000 PSAY Replicate("-",limite)
  li:=li+1
@ li,000 PSAY cHeader
  li:=li+1
@ li,000 PSAY Replicate("-",limite)
  li:=li+1
// Substituido pelo assistente de conversao do AP6 IDE em 09/04/03 ==> __Return( .T. )
Return( .T. )        // incluido pelo assistente de conversao do AP6 IDE em 09/04/03


* +-------------------------------------------------------------------+
* |           Imprime item do pedido                                  |
* +-------------------------------------------------------------------+

// Substituido pelo assistente de conversao do AP6 IDE em 09/04/03 ==> Function ImpItem
Static Function ImpItem()
nIPI     :=0
nVipi    :=0
nBaseIPI :=100
nValBase := 0
lIpiBruto:=IIF(GETMV("MV_IPIBRUT")=="S",.T.,.F.)

dbSelectArea("SB1")
dbSeek(xFilial()+SC6->C6_PRODUTO)

dbSelectArea("SF4")
dbSeek(xFilial()+SC6->C6_TES)
IF SF4->F4_IPI == "S"
	nBaseIPI        := IIF(SF4->F4_BASEIPI > 0,SF4->F4_BASEIPI,100)
	nIPI 		:= SB1->B1_IPI
	nValBase	:= If(lIPIBruto .And. SC6->C6_PRUNIT > 0,SC6->C6_PRUNIT,SC6->C6_PRCVEN)*SC6->C6_QTDVEN
	nVipi		:= nValBase * (nIPI/100)*(nBaseIPI/100)
Endif

@li,000 PSAY SC6->C6_ITEM
@li,003 PSAY SC6->C6_PRODUTO
@li,019 PSAY SUBS(IIF(Empty(SC6->C6_DESCRI),SB1->B1_DESC,SC6->C6_DESCRI),1,40)
*      (estava com 1,20)
li := li + 1
@li,001 PSAY "P.Cliente:"
@li,012 PSAY SC6->C6_PEDCLI
@li,020 PSAY "CFO: "
@li,025 PSAY SC6->C6_CF
@li,031 PSAY "TES:"
@li,036 PSAY SC6->C6_TES
@li,043 PSAY SC6->C6_UM         Picture "!!"
@li,047 PSAY SC6->C6_QTDVEN     Picture "999999.9999"
@li,057 PSAY SC6->C6_PRCVEN     Picture PesqPict("SC6","C6_PRCVEN",12)
a730VerIcm()
//@li,070 PSAY NoRound(SC6->C6_VALOR - SC6->C6_VALDESC + nVIPI) Picture PesqPict("SC6","C6_VALOR",14)
@li,070 PSAY NoRound(SC6->C6_VALOR + nVIPI) Picture PesqPict("SC6","C6_VALOR",14)
@li,095 PSAY SC6->C6_ENTREG
@li,109 PSAY SC6->C6_LOCAL
@li,115 PSAY SC6->C6_QTDVEN - SC6->C6_QTDEMP + SC6->C6_QTDLIB - SC6->C6_QTDENT Picture PesqPict("SC6","C6_QTDLIB",10)
li := li + 1
//@li,001 PSAY "Cod.Cliente-"
@li,001 PSAY SC6->C6_CODCLI
@li,015 PSAY SC6->c6_acab
@li,035 PSAY SC6->c6_ton
@li,055 PSAY sc6->c6_codcor
@li,075 PSAY sc6->c6_tabcor
@li,095 PSAY "N.C.M.:" + SB1->B1_POSIPI
li:=li+2

dbSelectArea("SB2")
dbSetOrder(1)
dbSeek(SC6->C6_FILIAL+SC6->C6_PRODUTO+SC6->C6_LOCAL,.F.)
_nEstoque := SaldoSB2()
_nTotPeso := _nTotPeso + (SB1->B1_PESO * SC6->C6_QTDVEN)
@li,001        PSAY "Peso Unit.: "+Transform(SB1->B1_PESO,"@E 999.9999")
@li,Pcol()+003 PSAY "Peso Total: "+Transform(SB1->B1_PESO * SC6->C6_QTDVEN,"@E 999.9999")
@li,Pcol()+003 PSAY "Estoque: "+Transform(_nEstoque,"@E 999,999.9999")
@li,Pcol()+003 PSAY "L O T E : ____________________"       
@li,Pcol()+003 PSAY SC6->C6_OBS

li:=li+1
*nTotQtd := nTotQtd:= SC6->C6_QTDVEN  
*nTotVal := nTotVal:= NoRound(SC6->C6_VALOR+nVipi)

nTotQtd := nTotQtd + SC6->C6_QTDVEN  
//nTotVal := nTotVal + NoRound(SC6->C6_VALOR - SC6->C6_VALDESC +nVipi)
nTotVal := nTotVal + NoRound(SC6->C6_VALOR + nVipi)

dbSelectArea("SC6")








* +-------------------------------------------------------------------+
* |           IMPRIME RODAPE DO PEDIDO                                |
* +-------------------------------------------------------------------+


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 09/04/03

// Substituido pelo assistente de conversao do AP6 IDE em 09/04/03 ==> Function ImpRodape
Static Function ImpRodape()
li:=li+1
@ li,000 PSAY Replicate("-",limite)
li:=li+1
@ li,000 PSAY " T O T A I S "
@ li,047 PSAY nTotQtd    Picture "999999.9999"
@ li,070 PSAY nTotVal    Picture PesqPict("SC6","C6_VALOR",17)
@ 48,005 PSAY " PEDIDO  DE  VENDA  DIGITADO POR: " + SC5->C5_USUARIO    
@ 49,005 PSAY " PEDIDO IMPRESSO E CONFERIDO POR: " + SUBSTR(CUSUARIO,7,15)                             
@ 49,070 PSAY " RISCO DO CLIENTE: " + SA1->A1_RISCO
@ 50,005 PSAY "+--------------------------------------------------------------------------------------------+"
@ 51,005 PSAY "|                                            |                                               |"
@ 52,005 PSAY "| PESO BRUTO ----->   ____________________   |  PESO LIQUIDO ----->   "+Transform(_nTotPeso,"@E 999,999.9999")+"           |"
@ 53,005 PSAY "|                                            |                                               |"
@ 54,005 PSAY "| QTDE VOLUME ---->   ____________________   |  ESPECIE ---------->   ____________________   |"
@ 55,005 PSAY "|                                            |                                               |"
@ 56,005 PSAY "| CONFERENCIA ---->   ____________________   |  D A T A ---------->      _____/_____/_____   |"
@ 57,005 PSAY "|--------------------------------------------------------------------------------------------|"
@ 58,005 PSAY "| AUTORIZADA LIBERACAO DE CREDITO  __________________  DATA DA LIBERACAO _____/_____/_____   |"
@ 59,005 PSAY "+--------------------------------------------------------------------------------------------+"
@ 60,005 PSAY " MENSAGEM PARA NOTA FISCAL: "+AllTrim(SC5->C5_MENNOTA)
@ 63,005 PSAY " Impressão realizada em "+Dtoc(dDataBase)+" às "+Time() 
@ 65,000 PSAY ""
li := 80
// Substituido pelo assistente de conversao do AP6 IDE em 09/04/03 ==> __Return( NIL )
Return( NIL )        // incluido pelo assistente de conversao do AP6 IDE em 09/04/03

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A730verIcm³ Autor ³ Claudinei M. Benzi    ³ Data ³ 11.02.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina para verificar qual e o ICM do Estado               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA460                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 09/04/03 ==> Function A730VerIcm
Static Function A730VerIcm()

nPerRet:=0                // Percentual de retorno
cEstado:=GetMV("mv_estado")
tNorte:=GetMV("MV_NORTE")
cEstCli:=IIF(SC5->C5_TIPO$"DB",SA2->A2_EST,SA1->A1_EST)
cInscrCli:=IIF(SC5->C5_TIPO$"DB",SA2->A2_INSCR,SA1->A1_INSCR)

If SF4->F4_ICM == "S"
	IF !(SC5->C5_TIPO $ "D")
		If SC5->C5_TIPOCLI == "F" .and. Empty(cInscrCli)
			nPerRet := iif(SB1->B1_PICM>0,SB1->B1_PICM,GetMV("MV_ICMPAD"))
		Elseif SB1->B1_PICM > 0 .And. cEstCli == cEstado
			nPerRet := SB1->B1_PICM
		Elseif cEstCli == cEstado
			nPerRet := GetMV("MV_ICMPAD")
		Elseif cEstCli $ tNorte .And. At(cEstado,tNorte) == 0
			nPerRet := 7
		Elseif SC5->C5_TIPOCLI == "X"
			nPerRet := 13
		Else
			nPerRet := 12
		Endif
	Else
		If cEstCLI == GetMV("MV_ESTADO")
			nPerRet := GetMV("MV_ICMPAD")
		Elseif !(cEstCli $ GetMV("MV_NORTE")) .And. ;
				GetMv("mv_estado") $ GetMV("MV_NORTE")
			nPerRet := 7
		Else
			nPerRet := 12
		Endif
		If SB1->B1_PICM != 0 .And. (cEstCli==GetMv("MV_ESTADO"))
			nPerRet := SB1->B1_PICM
		Endif
	Endif
Endif
// Substituido pelo assistente de conversao do AP6 IDE em 09/04/03 ==> __Return(nPerRet)
Return(nPerRet)        // incluido pelo assistente de conversao do AP6 IDE em 09/04/03

