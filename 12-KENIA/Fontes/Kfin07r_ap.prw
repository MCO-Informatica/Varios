#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function Kfin07r()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,TAMANHO,LIMITE")
SetPrvt("CSTRING,ARETURN,NOMEPROG,WNREL,CPERGUNTA,NLASTKEY")
SetPrvt("NLINHA,M_PAG,NTIPO,CBCONT,CABEC1,CABEC2")
SetPrvt("LABORTPRINT,NTOTPAGODIA,NTOTTITULODIA,NTOTNATUREZA,AFILE,CARQTRB")
SetPrvt("CINDTRB,NLIN,CNATUREZA,AREGS,I,J")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KFIN07R  ³ Autor ³                        ³ Data ³20/04/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Demonstrativo de Pagamentos por Natureza Financeira         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Kenia Industrias Texteis Ltda                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/                                                            

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 12/02/05 ==>     #DEFINE PSAY SAY
#ENDIF

*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
* Definicao de Variaveis do Relatorio                                        *
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*

titulo    := 'Demonstrativo de Pagamentos'
cDesc1    := 'Este programa ir  imprimir o Demonstrativo de Pagamentos'
cDesc2    := 'realizado no periodo determinado nos parametros pela'
cDesc3    := 'Kenia Industrias Texteis Ltda'
tamanho   := 'M'
limite    := 132
cString   := 'SE5'
aReturn   := { 'Zebrado', 1,'Financeiro', 2, 2, 1, '',0 }
nomeprog  := 'KFIN07R'
wnrel     := 'KFIN07R'
cPergunta := 'FIN07R    '
nLastKey  := 0
nLinha    := 0
m_pag     := 0
nTipo     := 15
cBcont    := 00
cabec1    := "DATA PAGTO  PREFIXO NUMERO PARC FORNEC/LJ NOME              EMISSAO  VENCTO   VALOR TITULO   VALOR PAGO   "
cabec2    := ""
lAbortPrint := .f.

*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
* Definicao de Variaveis dos Parametros                                      *
*                                                                            *
* mv_par01      Data Inicial                                                 *
* mv_par02      Data Final                                                   *
* mv_par03      Do Fornecedor                                                *
* mv_par04      Da Loja                                                      *
* mv_par05      Ate o Fornecedor                                             *
* mv_par06      Ate a Loja                                                   *
* mv_par07      Da Natureza                                                  *
* mv_par08      Ate a Natureza                                               *
*                                                                            *
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*

*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
* Definicao de Variaveis do Processamento                                    *
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*

nTotPagoDia     := 0    //----> Valor Total Pago no Dia
nTotTituloDia   := 0    //----> Valor Total de Titulos no Dia
nTotNatureza    := 0    //----> Valor Total por Natureza

*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
* Arquivos e Indices Utilizados                                              *
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*

DbSelectArea("SE2")         //----> Titulos a Pagar
DbSetOrder(1)               //----> Prefixo + Numero + Parcela + Tipo + Fornecedor + Loja

DbSelectArea("SE5")         //----> Movimentacao de Baixa
DbSetOrder(17)              //----> Data + Natureza + Prefixo + Numero + Parcela + Tipo + Fornecedor + Loja

*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
* Arquivo Temporario                                                         *
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*

aFile   := {}

Aadd(aFile,{"DATA"     ,"D",08,0})
Aadd(aFile,{"NATUREZ"  ,"C",10,0})
Aadd(aFile,{"PREFIXO"  ,"C",03,0})
Aadd(aFile,{"NUMERO"   ,"C",06,0})
Aadd(aFile,{"PARCELA"  ,"C",01,0})
Aadd(aFile,{"TIPO"     ,"C",03,0})
Aadd(aFile,{"FORNEC"   ,"C",06,0})
Aadd(aFile,{"LOJA"     ,"C",02,0})
Aadd(aFile,{"NOME"     ,"C",20,0})
Aadd(aFile,{"EMISSAO"  ,"D",08,0})
Aadd(aFile,{"VENCTO"   ,"D",08,0})
Aadd(aFile,{"VLTITULO" ,"N",17,2})
Aadd(aFile,{"VLPAGO"   ,"N",17,2})
Aadd(aFile,{"VLMULTA"  ,"N",17,2})
Aadd(aFile,{"VLDESC"   ,"N",17,2})

cArqTRB := CriaTrab(aFile,.T.)
cIndTRB := "DTOS(DATA)+NATUREZ+PREFIXO+NUMERO+PARCELA+TIPO+FORNEC+LOJA"


DbUseArea( .T.,, cArqTRB, "TRB", If(.F. .OR. .F., !.F., NIL), .F. )
IndRegua("TRB",cArqTRB,cIndTRB,,,"Criando Indice ...")

*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
* Processamento                                                              *
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*

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

Processa({|| BuscaDados()},'Demonstrativo de Pagamentos')// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Processa({|| Execute(BuscaDados)},'Demonstrativo de Pagamentos')
Return

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function BuscaDados
Static Function BuscaDados()

Dbselectarea("SE5")
Dbsetorder(17)
Dbseek(xFilial("SE5")+Dtos(mv_par01),.t.)

ProcRegua(RecCount())

While Eof() == .f.  .and.  Dtos(SE5->E5_DATA) <= Dtos(mv_par02) 

    IncProc("Selecionando Dados dos Pagamentos")

    //----> filtrando somente as naturezas definidas nos parametros
    If SE5->E5_NATUREZ < mv_par07 .Or. SE5->E5_NATUREZ > mv_par08
        DbSkip()
        Loop
    EndIf

    //----> filtrando somente os fornecedores definidos nos parametros
    If SE5->(E5_CLIFOR+E5_LOJA) < mv_par03+mv_par04 .Or. SE5->(E5_CLIFOR+E5_LOJA) > mv_par05+mv_par06
        DbSkip()
        Loop
    EndIf

    DbSelectArea("SE2")
    DbSetOrder(1)
    If !DbSeek(xFilial("SE2")+SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA))
        DbSelectArea("SE5")
        DbSkip()
        Loop
    Else
        DbSelectArea("TRB")
        RecLock("TRB",.t.)
          TRB->DATA     :=      SE5->E5_DATA
          TRB->NATUREZ  :=      SE5->E5_NATUREZ
          TRB->PREFIXO  :=      SE5->E5_PREFIXO
          TRB->NUMERO   :=      SE5->E5_NUMERO
          TRB->PARCELA  :=      SE5->E5_PARCELA
          TRB->TIPO     :=      SE5->E5_TIPO   
          TRB->FORNEC   :=      SE5->E5_CLIFOR 
          TRB->LOJA     :=      SE5->E5_LOJA   
          TRB->NOME     :=      SE2->E2_NOMFOR 
          TRB->EMISSAO  :=      SE2->E2_EMISSAO
          TRB->VENCTO   :=      SE2->E2_VENCTO 
          TRB->VLTITULO :=      SE2->E2_VALOR  
          TRB->VLMULTA  :=      SE2->E2_MULTA  
          TRB->VLDESC   :=      SE2->E2_DESCONT
          TRB->VLPAGO   :=      SE5->E5_VALOR
        MsUnLock()
    EndIf

    DbSelectArea("SE5")
    DbSkip()

EndDo
/*

RptStatus({|| Imprime() })// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> RptStatus({|| Execute(Imprime) })
Return 

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function Imprime
Static Function Imprime()

nLin   := 8

@ 000,000 PSAY avalimp(limite)    

cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)

DbSelectArea("TRB")
DbGoTop()
SetRegua(RecCount())

cNatureza   :=  Space(10)

While Eof() == .f.

    IncRegua()

    nLin   := nLin + 1

    If cNatureza <> TRB->NATUREZ
        @ nLin , 000        PSAY "NATUREZA: "
        @ nLin , Pcol()+01  PSAY TRB->NATUREZ+" "+Posicione("SED",1,xFilial("SED")+TRB->NATUREZ,"ED_DESCRIC")
        nLin := nLin + 2
    EndIf

    @ nLin , 000        PSAY DTOC(TRB->DATA)
    @ nLin , Pcol()+01  PSAY TRB->PREFIXO         
    @ nLin , Pcol()+01  PSAY TRB->NUMERO          
    @ nLin , Pcol()+01  PSAY TRB->PARCELA         
    @ nLin , Pcol()+01  PSAY TRB->TIPO            
    @ nLin , Pcol()+01  PSAY TRB->FORNEC          
    @ nLin , Pcol()+01  PSAY TRB->LOJA            
    @ nLin , Pcol()+01  PSAY TRB->NOME            
    @ nLin , Pcol()+01  PSAY DTOC(TRB->EMISSAO)
    @ nLin , Pcol()+01  PSAY DTOC(TRB->VENCTO) 
    @ nLin , Pcol()+01  PSAY TRB->VLTITULO   Picture "@E 999,999,999.99"
    @ nLin , Pcol()+01  PSAY TRB->VLMULTA    Picture "@E 999,999,999.99"
    @ nLin , Pcol()+01  PSAY TRB->VLDESC     Picture "@E 999,999,999.99"
    @ nLin , Pcol()+01  PSAY TRB->VLPAGO     Picture "@E 999,999,999.99"

    cNatureza := TRB->NATUREZ

    DbSkip()

    If nLin > 59
        cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18)
        nLin := 8
    Endif

Enddo

Roda(cbCont,"Pagamentos",tamanho)

If aReturn[5] == 1
   set printer to
   dbcommitall()
   ourspool(wnrel)
EndIf

Ms_Flush()

Return

*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*
* Fim do Programa                                                            *
*----------------------------------------------------------------------------*
*----------------------------------------------------------------------------*

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> function ValidPerg
Static function ValidPerg()


dbselectarea('sx1')
dbsetorder(1)

aRegs := {}
aadd(aRegs,{cPergunta,'01','Data Inicial       ?','mv_ch1','D',08, 0, 0,'G', '', 'mv_par01','','','','','','','','','','','','','','',''})
aadd(aRegs,{cPergunta,'02','Data Final         ?','mv_ch2','D',08, 0, 0,'G', '', 'mv_par02','','','','','','','','','','','','','','',''})
aadd(aRegs,{cPergunta,'03','Do Fornecedor      ?','mv_ch3','C',06, 0, 0,'G', '', 'mv_par03','','','','','','','','','','','','','','','SA2'})
aadd(aRegs,{cPergunta,'04','Da Loja            ?','mv_ch4','C',02, 0, 0,'G', '', 'mv_par04','','','','','','','','','','','','','','',''})
aadd(aRegs,{cPergunta,'05','Ate o Fornecedor   ?','mv_ch5','C',06, 0, 0,'G', '', 'mv_par05','','','','','','','','','','','','','','','SA2'})
aadd(aRegs,{cPergunta,'06','Ate a Loja         ?','mv_ch6','C',02, 0, 0,'G', '', 'mv_par06','','','','','','','','','','','','','','',''})
aadd(aRegs,{cPergunta,'07','Da Natureza        ?','mv_ch7','C',10, 0, 0,'G', '', 'mv_par07','','','','','','','','','','','','','','','SED'})
aadd(aRegs,{cPergunta,'08','Ate a Natureza     ?','mv_ch8','C',10, 0, 0,'G', '', 'mv_par08','','','','','','','','','','','','','','','SED'})

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
*/
