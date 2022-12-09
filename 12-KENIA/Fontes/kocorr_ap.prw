#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function kocorr()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("NORDEM,TAM,LIMITE,TITULO,CDESC1,CDESC2")
SetPrvt("CDESC3,CNATUREZA,CSTRING,LCONTINUA,ARETURN,NOMEPROG")
SetPrvt("NLASTKEY,WNREL,CPERGUNTA,_APERGUNTAS,_NLACO,")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Cliente   ³ Kenia Industrias Texteis Ltda.                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa:#³ KOCORR.prw                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao:³ Programa de sintetizacao de ocorrencias de O.P.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Data:     ³ 04/09/00    ³ Implantacao: ³ 04/09/00                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programad:³ Sergio Oliveira                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Objetivos:³ O cliente trabalha com tipos diferentes de O.P.            ³±±
±±³          ³ Ex.: 0,1,2,3,4,5 e 6 - entao eh necessario a sintetizacao  ³±±
±±³          ³ destas informacoes.                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Arquivos :³ SC2.                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

nOrdem     := 0
tam        := "P"
limite     := 80
titulo     := PADC("ORDEM DE PRODUCAO",71)
cDesc1     := PADC("Este programa ira emitir Relacao das ",71)
cDesc2     := PADC("Ordens de produco no periodo indicado",71)
cDesc3     := ""
cNatureza  := ""
cString    := "SC2"
lContinua  :=  .T.
aReturn    :=  { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog   := "KOCORR"
nLastKey   :=  0
wnrel      := "KOCORR"     
cPergunta  := "K0000A"

ValidPerg()

Pergunte(cPergunta,.F.)

wnrel:=SetPrint(cString,wnrel,cPergUNTA,Titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,tam)

#IFNDEF WINDOWS
        If LastKey() == 27 .or. nLastKey == 27
                __RetProc()
        Endif
#ENDIF

SetDefault(aReturn,cString)

#IFNDEF WINDOWS
        If LastKey() == 27 .OR. nLastKey == 27
                __RetProc()
        Endif
#ENDIF

#IFDEF WINDOWS
        Processa( {|| OPE() }, "Relacao das OP's - Kenia...")// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>         Processa( {|| Execute(OPE) }, "Relacao das OP's - Kenia...")
        __RetProc()
#ENDIF

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function OPE
Static Function OPE()

Store Space(15) to _cRetr, _cTing, _cReting, _cReferv, _cReacab, _cDescarga
Store 0 to _nOcorren, _nOcorrent, _nPeso, _nPesot, _nMetro, _nMetrot

DbSelectArea("SC2")
DbSetOrder(3)
DbSeek(xFilial()+MV_PAR01+DTOS(MV_PAR02),.T.)
ProcRegua(LastRec())

While !Eof() .and. SC2->C2_CC == ALLTRIM(MV_PAR01) .and.;
                   SC2->C2_DATPRF <= MV_PAR03

      IncProc("Aguarde, Selecionando Registros")

      If SC2->C2_TIPO == "1"
         _c

set device to screen
dbcommitAll()

If aReturn[5] == 1
   Set Printer TO 
   ourspool(wnrel)
Endif

MS_FLUSH()
__RetProc()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ValidPerg³ Autor ³                       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria grupo de Perguntas caso nao exista no SX1             ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ PCP - especifico Kenia                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> Function ValidPerg
Static Function ValidPerg()
                  
_aPerguntas := {}             
                  // 01     02       03                  04     05  06 7 8  9      10                               11           12        13 14        15        16 17    18     19 20     21        22 23 24 25  26 
AADD(_aPerguntas,{_cPergunta,"01","Centro de Custo    ?","mv_ch1","C",09,0,0,"G","","mv_par01","","","","              ","","","       ","","","           ","","","","","",})
AADD(_aPerguntas,{_cPergunta,"02","Da data            ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","              ","","","       ","","","           ","","","","","",})
AADD(_aPerguntas,{_cPergunta,"03","Ate a Data         ?","mv_ch3","D",08,0,0,"G","","mv_par03","","","","              ","","","       ","","","           ","","","","","",})

DbSelectArea("SX1")
FOR _nLaco:=1 to LEN(_aPerguntas)
   If !dbSeek(_aPerguntas[_nLaco,1]+_aPerguntas[_nLaco,2])
     RecLock("SX1",.T.)
     SX1->X1_Grupo     := _aPerguntas[_nLaco,01]
     SX1->X1_Ordem     := _aPerguntas[_nLaco,02]
     SX1->X1_Pergunt   := _aPerguntas[_nLaco,03]
     SX1->X1_Variavl   := _aPerguntas[_nLaco,04]
     SX1->X1_Tipo      := _aPerguntas[_nLaco,05]
     SX1->X1_Tamanho   := _aPerguntas[_nLaco,06]
     SX1->X1_Decimal   := _aPerguntas[_nLaco,07]
     SX1->X1_Presel    := _aPerguntas[_nLaco,08]
     SX1->X1_Gsc       := _aPerguntas[_nLaco,09]
     SX1->X1_Valid     := _aPerguntas[_nLaco,10]
     SX1->X1_Var01     := _aPerguntas[_nLaco,11]
     SX1->X1_Def01     := _aPerguntas[_nLaco,12]
     SX1->X1_Cnt01     := _aPerguntas[_nLaco,13]
     SX1->X1_Var02     := _aPerguntas[_nLaco,14]
     SX1->X1_Def02     := _aPerguntas[_nLaco,15]
     SX1->X1_Cnt02     := _aPerguntas[_nLaco,16]
     SX1->X1_Var03     := _aPerguntas[_nLaco,17]
     SX1->X1_Def03     := _aPerguntas[_nLaco,18]
     SX1->X1_Cnt03     := _aPerguntas[_nLaco,19]
     SX1->X1_Var04     := _aPerguntas[_nLaco,20]
     SX1->X1_Def04     := _aPerguntas[_nLaco,21]
     SX1->X1_Cnt04     := _aPerguntas[_nLaco,22]
     SX1->X1_Var05     := _aPerguntas[_nLaco,23]
     SX1->X1_Def05     := _aPerguntas[_nLaco,24]
     SX1->X1_Cnt05     := _aPerguntas[_nLaco,25]
     SX1->X1_F3        := _aPerguntas[_nLaco,26]
     MsUnLock()
   EndIf
NEXT
__RetProc()          

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

