#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function Kfin06r()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,TAMANHO,LIMITE")
SetPrvt("CSTRING,ARETURN,NOMEPROG,WNREL,CPERGUNTA,NLASTKEY")
SetPrvt("NLINHA,M_PAG,NTIPO,CBCONT,CABEC1,CABEC2")
SetPrvt("LABORTPRINT,NTOTBOR,NCOUNT,NLIN,CBORDERO,DDATABOR")
SetPrvt("AREGS,I,J,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KFIN06R  ³ Autor ³                       ³ Data ³11/02/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Emissao do Bordero de Cobrancas                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Kenia Industrias Texteis Ltda                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/                                                            

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==>     #DEFINE PSAY SAY
#ENDIF

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Definicao de Variaveis do Relatorio                                       *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

titulo    := 'Bordero de Cobranca'
cDesc1    := 'Este programa ir  imprimir o Bordero de Cobranca de acordo com o numero selecionado.'
cDesc2    := ' '
cDesc3    := ' '
tamanho   := 'P'
limite    := 80
cString   := 'SEA'
aReturn   := { 'Zebrado', 1,'Financeiro', 2, 2, 1, '',0 }
nomeprog  := 'KFIN06R'
wnrel     := 'KFIN06R'
cPergunta := 'FIN06R    '
nLastKey  := 0
nLinha    := 0
m_pag     := 0
nTipo     := 18
cBcont    := 00
cabec1    := "NUM DUPLIC P    CODIGO  RAZAO SOCIAL                   VENCTO              VALOR"
cabec2    := ""
lAbortPrint := .f.
nTotBor   := 0
nCount    := 0

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Definicao de Variaveis dos Parametros                                     *
*                                                                           *
* mv_par01      Numero do Bordero                                           *
*                                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

ValidPerg()

pergunte(cPergunta,.f.)

wnrel := SetPrint(cString,wnrel,cPergunta,@titulo,cDesc1,cDesc2,cDesc3,.f.,.f.)

if nLastkey == 27
    return
endif

SetDefault(aReturn,cString,.f.)

if nLastkey == 27
    return
endif

nTipo := 18


*-------------------------------------------------------------------------*
*-------------------------------------------------------------------------*
* Processamento                                                           *
*-------------------------------------------------------------------------*
*-------------------------------------------------------------------------*

Processa({|| Imprime()},'Emissao do Bordero de Cobranca')// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({|| Execute(Imprime)},'Emissao do Bordero de Cobranca')
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Imprime
Static Function Imprime()

Dbselectarea('SEA')
Dbsetorder(1)
Dbseek(xFilial('SEA')+mv_par01)

ProcRegua(RecCount() - Recno())

nLin   := 8

@00,000 PSAY avalimp(limite)    

cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)

while eof() == .f.  .and.  SEA->EA_NUMBOR == mv_par01

    IncProc('Processando o Bordero: '+SEA->EA_NUMBOR)

    //----> filtrando somente borderos do contas a receber
    If !SEA->EA_CART $"R"
        DbSkip()
        Loop
    EndIf

    DbSelectArea('SA6')
    DbSetOrder(1)
    DbSeek(xfilial('SA6')+SEA->EA_PORTADO+SEA->EA_AGEDEP+SEA->EA_NUMCON)

    nLin := nLin + 1

    @ nLin , 000        PSAY "AO"
    @ nLin , Pcol()+01  PSAY SA6->A6_NOME

    nLin := nLin + 1

    @ nLin , 000        PSAY "AGENCIA "+SA6->A6_AGENCIA
    @ nLin , Pcol()+01  PSAY "C/C "+SA6->A6_CONTA

    nLin := nLin + 1

    @ nLin , 000        PSAY Alltrim(SA6->A6_BAIRRO)+" - "+Alltrim(SA6->A6_MUN)+" - "+SA6->A6_EST

    nLin := nLin + 1

    @ nLin , 000        PSAY "BORDERO NRo."+MV_PAR01

    nLin := nLin + 2

    @ nLin , 000        PSAY PADC("SOLICITAMOS PROCEDER O RECEBIMENTO DAS DUPLICATAS ABAIXO RELACIONADAS,",80)

    nLin := nLin + 1

    @ nLin , 000        PSAY PADC("CREDITANDO-NOS OS VALORES CORRESPONDENTES.",80)

    nLin := nLin + 3

    cBordero := SEA->EA_NUMBOR
    dDataBor := SEA->EA_DATABOR

    While SEA->EA_NUMBOR == cBordero

        DbSelectArea('se1')
        DbSetOrder(1)
        DbSeek(xfilial('SE1')+SEA->EA_PREFIXO+SEA->EA_NUM+SEA->EA_PARCELA+SEA->EA_TIPO)

        DbSelectArea('sa1')
        DbSetOrder(1)
        DbSeek(xfilial('SA1')+se1->e1_cliente+se1->e1_loja)

        nCount  := nCount + 1

        nTotBor := nTotBor + SE1->E1_VALOR

        @ nLin, 000         PSAY SEA->EA_PREFIXO
        @ nLin, Pcol()+01   PSAY Alltrim(SEA->EA_NUM)
        @ nLin, Pcol()+01   PSAY SEA->EA_PARCELA
        @ nLin, Pcol()+03   PSAY SE1->E1_CLIENTE
        @ nLin, Pcol()+02   PSAY Subs(SA1->A1_NOME,1,26)
        @ nLin, Pcol()+05   PSAY DTOC(SE1->E1_VENCTO)
        @ nLin, Pcol()+01   PSAY SE1->E1_VALOR          Picture "@E 999,999,999.99"

        nLin := nLin + 1

        If nLin > 59
            cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
            nLin := 8
        Endif

        DbSelectArea("SEA")
        DbSkip()
    EndDo

    nLin := nLin + 1

    @ nLin , 000         PSAY "TOTAL DA RELACAO A CREDITO DE NOSSA CONTA CORRENTE           "
    @ nLin , Pcol()+05   PSAY nTotBor        Picture "@E 999,999,999.99"

    nLin := nLin + 1

    @ nLin , 000         PSAY "QUANTIDADE DE TITULOS IMPRESSOS                              "
    @ nLin , Pcol()+16   PSAY nCount         Picture "999"

    nLin := nLin + 1

    If nLin > 59
        cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
        nLin := 8
    Endif
Enddo

If nLin > 59
    cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
    nLin := 8
Endif

nLin := nLin + 4

@ nLin , 000        PSAY "Data: "+Dtoc(dDataBor)

nLin := nLin + 4

@ nLin , 000        PSAY PADC("-----------------------------",80)

nLin := nLin + 1

@ nLin , 000        PSAY PADC("KENIA INDUSTRIAS TEXTEIS LTDA",80)

Roda(cbCont,"Borderos",tamanho)

if aReturn[5] == 1
   set printer to
   dbcommitall()
   ourspool(wnrel)
endif

ms_flush()

return

*-------------------------------------------------------------------------*
*-------------------------------------------------------------------------*
* Fim do Programa                                                         *
*-------------------------------------------------------------------------*
*-------------------------------------------------------------------------*

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> function ValidPerg
Static function ValidPerg()


dbselectarea('sx1')
dbsetorder(1)

aRegs := {}
aadd(aRegs,{cPergunta,'01','Numero do Bordero  ?','mv_ch1','C',06, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','','SEA'})
for i:=1 to len(aRegs)
    dbseek(cPergunta+strzero(i,2))
    if found() == .f.
         reclock('sx1',.t.)

         for j:=1 to fcount()
              FieldPut(j,aRegs[i,j])
        next

        msunlock()
    endif
next

return

