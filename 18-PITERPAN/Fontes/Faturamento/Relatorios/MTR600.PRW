#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 09/04/03
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function MTR600()        // incluido pelo assistente de conversao do AP6 IDE em 09/04/03

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//? SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//? identificando as variaveis publicas do sistema utilizadas no codigo ?
//? Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("CBTXT,TITULO,CDESC1,CDESC2,CDESC3,CBCONT")
SetPrvt("CABEC1,CABEC2,CABEC3,_NREGPED,_NREGTOT,WNREL")
SetPrvt("TAMANHO,LIMITE,CSTRING,LCONTINUA,ACAMPOS,ATAM")
SetPrvt("ARETURN,NOMEPROG,ALINHA,NLASTKEY,CPERG,LEND")
SetPrvt("LI,M_PAG,CNOMARQ,J,SUF,_CVAR")
SetPrvt("_CVAR2VD,CVENDCH,NTOTGER1,CVEND,NTOTVEND1,NTOTCLI1")
SetPrvt("CCLI,NCONTCLI,NTOTPED1,CEXT,_CREPVAR,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 09/04/03 ==> 	#DEFINE PSAY SAY
#ENDIF
/*/
旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴?
쿑uncao    ? MATR600  ? Autor ? Wagner Xavier         ? Data ? 14.04.92 ?
쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴?
쿏escricao ? Relacao de Pedidos de Vendas por Vendedor/Cliente          ?
쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
쿞intaxe   ? MATR600(void)                                              ?
쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
? Uso      ? Generico                                                   ?
쳐컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
? ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ?
쳐컴컴컴컴컴컴컫컴컴컴컴쩡컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
? PROGRAMADOR  ? DATA   ? BOPS ?  MOTIVO DA ALTERACAO                   ?
쳐컴컴컴컴컴컴컵컴컴컴컴탠컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
? Viviani      ?02/02/99?19573A? Acerto do lay-out (campo A1-CLIENTE)   ?
쳐컴컴컴컴컴컴컵컴컴컴컴탠컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
? Rdmake       ?03/08/99?      ? Convertido por M쟲cia S. S. Tokura     ?
읕컴컴컴컴컴컴컨컴컴컴컴좔컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
/*/
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Define Variaveis                                             ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
CbTxt:=""
titulo := OemToAnsi("Pedidos Por Vendedor/Cliente")
cDesc1 := OemToAnsi("Este relatorio ira emitir a relacao de Pedidos por")
cDesc2 := OemToAnsi("ordem de Vendedor/Cliente.")
cDesc3 := ""
CbCont := ""
cabec1 := ""
cabec2 := ""
cabec3 := ""
_nregped  := 0
_nregtot := 0
wnrel  := ""
tamanho:="P"
limite := 80
cString:="SA3"
lContinua := .T.
aCampos := {}
aTam    := {}
aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog:="MTR600"
aLinha  := { }
nLastKey := 0
cPerg   :="MTR600"
lend:=.F.
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Verifica as perguntas selecionadas                           ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
pergunte("MTR600",.F.)
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Variaveis utilizadas para parametros                         ?
//? mv_par01            // A partir da data                      ?
//? mv_par02            // Ate a data                            ?
//? mv_par03            // Vendedor de                           ?
//? mv_par04 	      	// Vendedor ate                          ?
//? mv_par05	      	// Cliente de                            ?
//? mv_par06            // Cliente ate                           ?
//? mv_par07            // Salta pagina entre vendedores(Sim/Nao)?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Envia controle para a funcao SETPRINT                        ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
wnrel:="MATR600"            //Nome Default do relatorio em Disco

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"")

If nLastKey==27
   Set Filter to
   Return
Endif
SetDefault(aReturn,cString)
If nLastKey==27
   Set Filter to
   Return
Endif
#IFDEF WINDOWS
       RptStatus({|| RD600Imp()},Titulo)// Substituido pelo assistente de conversao do AP6 IDE em 09/04/03 ==>        RptStatus({|| Execute(RD600Imp)},Titulo)
#ELSE
       RD600Imp()
#ENDIF
Return
/*/
旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴?
쿑uncao    ? RD600IMP ? Autor ? Rosane Luciane Chene  ? Data ? 09.11.95 ?
쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴?
쿏escricao ? Chamada do Relatorio                                       ?
쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
? Uso      ? MATR600                                                    ?
읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 09/04/03 ==> Function RD600Imp
Static Function RD600Imp()
CbTxt       := ""
titulo      := OemToAnsi("Pedidos Por Vendedor/Cliente")
cDesc1      := OemToAnsi("Este relatorio ira emitir a relacao de Pedidos por")
cDesc2      := OemToAnsi("ordem de Vendedor/Cliente.")
cDesc3      := ""
tamanho     :="P"
limite      := 80
lContinua   := .T.
aCampos     := {}
aTam        := {}
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Variaveis utilizadas para Impressao do Cabecalho e Rodape    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Define array para arquivo de trabalho                        ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
aTam:=TamSX3("C5_VEND1")
AADD(aCampos,{ "VENDEDOR","C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_NUM")
AADD(aCampos,{ "NUMPED"  ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_CLIENTE")
AADD(aCampos,{ "CLIENTE" ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_EMISSAO")
AADD(aCampos,{ "EMISSAO" ,"D",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_LOJACLI")
AADD(aCampos,{ "LOJA"    ,"C",aTam[1],aTam[2] } )
// aTam:=TamSX3("C5_VENDLJ")
// AADD(aCampos,{ "VENDLJ"  ,"C",aTam[1],aTam[2] } )



//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Definicao dos cabecalhos                                     ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
titulo := "PEDIDO DE VENDAS VEND/CLI"
cabec1 := "CODIGO  RAZAO SOCIAL                  PRACA        PEDIDO LJ           TOTAL"
cabec2 := ""
cabec3 := Repl("-",80)
_nregped  := 0
_nregtot  := 0
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Cria arquivo de Trabalho                                     ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
cNomArq := CriaTrab(aCampos)
Use &cNomArq	Alias TRB   NEW
IndRegua("TRB",cNomArq,"VENDEDOR+CLIENTE+NUMPED",,,"Selecionando Registros...")             

dbSelectArea("SC5")
dbSetOrder(2)
dbSeek(xFilial()+DTOS(mv_par01),.T.)

SetRegua(RecCount())		// Total de Elementos da regua

While !EOF() .And. lContinua .And. C5_EMISSAO >= mv_par01 .And. C5_EMISSAO <= mv_par02
    If AT(C5_TIPO,"DBEA") != 0
       dbSkip()
       Loop
    EndIf
    IncRegua()
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//? Verifica se Vendedor devera ser impresso                     ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
       
	FOR j:=1 TO 5
          suf := Str(j,1)
          _cVar:="C5_VEND"+suf
          _cVar2vd:="C5_VEND2" // Variavel com campo vend 2 - Inc 09/09/02
          dbSelectArea("SC5")
          IF Empty(&(_cVar))
             Exit
          EndIF
          // incluido para Conciderar o pedido apenas para o Vend 2, caso exista
          If AllTrim(suf) == "1" .and. !Empty(&(_cVar2vd))
            Loop
          EndIf
          cVendCh := &(_cVar)
          dbSelectArea("SA3")
          dbSeek(xfilial()+cVendCH)
          IF !Eof()
            dbSelectArea("SC5")
            IF &(_cVar) >= mv_par03 .And. &(_cVar) <= mv_par04
              RDTrab()
            EndIF
          Endif
	NEXT j
	
	dbSelectArea("SC5")
	dbSkip()
End

dbSelectArea("TRB")
dbGoTop()
nTotGer1 := 0
SetRegua(RecCount())        // Total de Elementos da regua
While !Eof() .And. lContinua
	#IFNDEF WINDOWS
       If LastKey() == 286    //ALT_A
          lEnd := .t.
       End
	#ENDIF
    IF lend
       @PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
       lContinua := .F.
       Exit
	Endif
    cVend := VENDEDOR
	dbSelectArea("SA3")
	dbSetOrder(1)	
	dbSeek( xFilial() + cVend )
	IF li > 55
       cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
	EndIF
    @ li,000 PSAY "VENDEDOR : "+ cVend + "  " + SA3->A3_NOME
    li:=li+1
	dbSelectArea("TRB")
	nTotVend1 := 0
	While !Eof() .And. lContinua .And. VENDEDOR == cVend
		#IFNDEF WINDOWS
                If LastKey() == 286    //ALT_A
                   lEnd := .t.
                End
		#ENDIF
		IF lEnd
           @PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
           lContinua := .F.
           Exit
		Endif
		IF CLIENTE < mv_par05 .Or. CLIENTE > mv_par06
			dbSkip()
			Loop
		EndIF
		nTotCli1 := 0
		cCli := CLIENTE
		nContCli := 0
        While !Eof() .And. lContinua .And.;
                   VENDEDOR == cVend .And.;
                   CLIENTE == cCli
			#IFNDEF WINDOWS
                    If LastKey() == 286    //ALT_A
                       lEnd := .t.
                    End
			#ENDIF
			IF lEnd
               @PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
               lContinua := .F.
               EXIT
			ENDIF
			IncRegua()
			IF li > 55
               cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
               li:=li+2
			EndIF
            dbSelectArea("SC6")
			dbSeek( xFilial()+TRB->NUMPED )
			nTotPed1 := 0
            While !Eof() .And. TRB->NUMPED == SC6->C6_NUM
                  nTotPed1 := nTotPed1 +C6_VALOR
                  dbSkip()
			End
            dbSelectArea("SA1")
			dbSetOrder(1)
			dbSeek( xFilial() + TRB->CLIENTE+TRB->LOJA )
            @li,  0 PSAY TRB->CLIENTE + " "
            @li,  7 PSAY SubStr(A1_NOME, 1,22)
            @li, 32 PSAY SubStr(A1_MUN, 1,20)
            dbSelectArea("TRB")
            // @li, 59 PSAY VENDLJ
            @li, 52 PSAY NUMPED
            @li, 62 PSAY nTotPed1   PicTure tm(nTotPed1,16)
            _nregped := _nregped + 1
            LI:=LI+1
            nTotCli1 := nTotCli1 +nTotPed1
            nContCLI:=nContCLI+1
			dbSkip()
		End
		IF li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
		EndIF
		IF nContCli > 1
           @li, 000 PSAY "TOTAL CLIENTE   ---> "+ cCli
           @li, 061 PSAY nTotCli1              PicTure  tm(nTotCli1,16)
           li := li + 1
		EndIF
        nTotVend1 := nTotVend1 +nTotCli1
        li:=li + 1
		dbSelectArea("TRB")
    Enddo
        li := li + 1
        @li, 000 PSAY "TOTAL VENDEDOR  ---> "+ cVend
        @li, 061 PSAY nTotVend1          PicTure tm(nTotVend1,16)
        li := li + 1
        @li, 000 PSAY "Qtde de Pedidos --->" + str(_nregped,5)
        _nregtot := _nregtot + _nregped
        _nregped := 0
        li := li + 1
	If mv_par07 == 1
       li := 90
	Else
       li:=li + 1
       @li,00 PSAY Repl("-",80)
       li:=li + 1
	Endif
    nTotGer1 := nTotGer1 +nTotVend1
	dbSelectArea("TRB")
EndDo

If mv_par07 == 2
   li := 90
Endif

IF li >= 80
   Cabec(titulo,cabec3,cabec2,nomeprog,tamanho,18)
   @  035, 000 PSAY Repl("-",80)
   @  040, 000 PSAY "T O T A L    G E R A L  "
   @  040, 062 PSAY nTotGer1   PicTure tm(nTotGer1,16)
   @  042, 000 PSAY "Total de Pedidos Digitados -->>" + Str(_nregtot,5)
   @  045, 000 PSAY Repl("-",80)
   roda(cbcont,cbtxt,"P")
EndIF

dbSelectArea("TRB")
cExt := OrdBagExt()
dbCloseArea()
If File(cNomArq+".DBF")
	FERASE(cNomArq+".DBF")    //arquivo de trabalho
Endif

If File(cNomArq + cExt)
	FERASE(cNomArq+cExt)    //indice gerado
Endif

dbSelectArea("SC5")
dbSetOrder(1)

dbSelectArea("SA3")
Set Filter To
dbSetOrder(1)
Set Device To Screen

If aReturn[5] == 1
	Set Printer TO
	dbCommitall()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return

/*/
旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴?
쿑uncao    ?  RDTRAB  ? Autor ?                       ? Data ?          ?
쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴?
쿏escricao ? Grava Arquivo de Trabalho                                  ?
쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
쿛arametros? nEl - Ordem do Vendedor                                    ?
쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
? Uso      ? MATR600                                                    ?
읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
/*/

// Substituido pelo assistente de conversao do AP6 IDE em 09/04/03 ==>  FuncTion RDTRAB
Static FuncTion RDTRAB()

suf := Str(j,1)
dbSelectArea("TRB")
RecLock("TRB",.t.)

_cRepVar:="SC5->C5_VEND"+suf
Replace VENDEDOR With &(_cRepVar)
Replace NUMPED   With SC5->C5_NUM
Replace CLIENTE  With SC5->C5_CLIENTE
Replace EMISSAO  With SC5->C5_EMISSAO
Replace LOJA     With SC5->C5_LOJACLI
// Replace VENDLJ   With SC5->C5_VENDLJ
MsUnlock()

dbSelectArea("SC5")

Return .T.

