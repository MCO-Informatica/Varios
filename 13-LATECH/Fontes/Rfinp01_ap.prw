#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Rfinp01()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("SAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,NLASTKEY")
SetPrvt("NHDLBCO,NHDLSAI,CARQSAI,CARQENT,CNUMTIT,XNOVALINHA")
SetPrvt("CSAVCUR1,ACA,NOPCAO,NPOSIC,CARQNOV,NLIDOS")
SetPrvt("NTAMARQ,CBUFFER,CLINHA,CBANCO,CTIPOARQ,CPARCELA")
SetPrvt("CPREFIXO,CESPECIE,AARRAY,CPARC,NELEMENT,CTITULO")
SetPrvt("_APERGUNTAS,_NLACO,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ rfinp01  ³ Autor ³ Marcos Gomes          ³ Data ³ 07.02.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera‡„o de Novo Arquivo de Retorno da Comunica‡„o Banc ria ³±±
±±³          ³ Necessario para arrumar a numeracao dos titulos que foram  ³±±
±±³          ³ enviados ao Banco antes do inicio das atividades do SIGA,  ³±±
±±³          ³ nao utilizando o PREFIXO, que e'chave de pesquisa do sist. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Clientes Microsiga                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SavCur1    := Space(1)
cSavRow1   := Space(1)
cSavCol1   := Space(1)
cSavCor1   := Space(1)
cSavScr1   := Space(1)

nLastKey   := 0
nHdlBco    := 0
nHdlSai    := 0

cArqSai    := ""
cArqEnt    := ""
cNumTit    := SPACE(10)
xNovaLinha := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva a Integridade dos dados de Entrada ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFNDEF WINDOWS
        cSavScr1   := SaveScreen(3,0,24,79)
        cSavCur1   := SetCursor(0)
        cSavRow1   := ROW()
        cSavCol1   := COL()
        cSavCor1   := SetColor("bg+/b,,,")
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // Arquivo de Entrada                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   Perguntas()

If LastKey() == 27 .Or. nLastKey == 27
   RestScreen(3,0,24,79,cSavScr1)
   Return()
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Desenha a tela de pano de fundo                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFNDEF WINDOWS
        aCA := {"Confirma","Abandona"}
        ScreenDraw("SMT050",3,0,0,0)
        SetColor("w/w,,,,")
     
      @ 03,01 Say "Gera‡ao de Novo Arquivo de Retorno CNAB" Color "R/w"

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Verifica os parametros                                                    ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

           Pergunte("CONTXT",.T.)
           SetColor("w/n,,,,")
           SetColor("b/bg,,,")
         @ 11,04 Say "Este programa tem o objetivo de gerar um Novo Arquivo de"
         @ 12,04 SAY "Retorno Bancario a partir do arquivo enviado pelo Banco."
           SetColor("n/w,,,,")
         @ 24,05 Clear To 24,76

           nOpcao := MenuH(aCA,24,6,"B/W,W+/N,R/W","CA","Quanto a gera‡ao ?",2)

           IF nOpcao == 2
              Return()
           EndIF
#ELSE         
         Pergunte("CONTXT",.T.)
       @ 96,42 TO 323,505 DIALOG oDlg5 TITLE "Confirma o Processamento"
       @ 8,10 TO 84,222
       @ 91,168 BMPBUTTON TYPE 1 ACTION OkProc()// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>        @ 91,168 BMPBUTTON TYPE 1 ACTION Execute(OkProc)
       @ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
       @ 23,14 SAY "Este programa ira efetuar a leitura do arquivo Txt, contendo informacoes "
       @ 33,14 SAY "do Pedidos de Venda em aberto, e converte-lo para os arquivos do SIGA.   "

         ACTIVATE DIALOG oDlg5
         
         Close(oDlg5)
         Return()

         RptStatus({||OkProc()})// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>          RptStatus({||Execute(OkProc)})

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==>          Function OkProc
Static Function OkProc()

#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre arquivo enviado pelo banco ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cArqEnt := mv_par01
IF !FILE(cArqEnt)
   Help(" ",1,"NOARQENT")
   Return(.F.)
Else
   nPosic  := At(".RET",cArqEnt)
   cArqNov := AllTrim(Substr(cArqEnt,1,(nPosic - 1))) + ".KEN"
   FRENAME(cArqEnt,cArqNov)
   FCLOSE(cArqEnt)
   nHdlBco:=FOPEN(cArqNov,0)
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arquivo de Saida         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    nHdlSai := FCREATE(cArqEnt,0)
    FSEEK(nHdlSai,0,0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Lˆ arquivo enviado pelo banco ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nLidos:=0
FSEEK(nHdlBco,0,0)
nTamArq:=FSEEK(nHdlBco,0,2)
FSEEK(nHdlBco,0,0)

While nLidos < nTamArq

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Tipo qual registro foi lido ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   
   cBuffer:=Space(402)
   FREAD(nHdlBco,@cBuffer,402)

   IF SubStr(cBuffer,1,1) $ "09"
      cLinha := cBuffer
      // grava no arquivo de destino
      cBanco   := Substr(cBuffer,80,8)
      cTipoArq := Substr(cBuffer,03,7)
      FWRITE( nHdlSai , cLinha )
   EndIF
   
   If SubStr(cBuffer,1,1) == "1"

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Lˆ os valores do arquivo Retorno ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

      cParcela  := Substr(cBuffer,123,2)
      cPrefixo  := Substr(cBuffer,117,3)
      cNumTit   := Substr(cBuffer,120,6)
      cEspecie  := Substr(cBuffer,174,2)
      
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Trata a Parcela do Titulo        ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

      aArray := {"A","B","C","D","E","F","G","H","I","J","K",;
                 "L","M","N","O","P","Q","R","S","T","U","V",;
                 "X","Y","Z" }

      If cPrefixo <> "UNI"
         If Substr(cParcela,1,1) == "1"  .OR. Empty( Substr(cParcela,1,1))
            cParc := " "
         Else
            nElement := Val( Substr(cParcela,2,1))
            cParc    := aArray[nElement]
         EndIf
      ElseIf cPrefixo == "UNI"
            cParc := Substr(cBuffer,126,1)
      EndIf

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Trata o Prefixo do Titulo        ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

      If cPrefixo <> "UNI"
         cPrefixo := "   " 
         cNumTit  := "0" + Substr(cBuffer,117,5)
      EndIf

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Monta Novo numero de Titulo      ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

      cTitulo := cPrefixo + cNumTit + cParc
      
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Trata especie do titulo          ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
          // Banco Bradesco
          If cBanco == "BRADESCO" .and. cPrefixo == "UNI"
             cEspecie := "99" 
          ElseIf cBanco == "BRADESCO" .and. cPrefixo <> "UNI"
             cEspecie := "01"
          EndIf

          // Banco do Brasil
          If cBanco == "BANCO DO" .and. cPrefixo == "UNI"
             cEspecie := "08"
          ElseIf cPrefixo == Space(3)
             cEspecie := "01"
          EndIf

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Monta Nova Linha do CNAB         ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    
      cLinha := Substr(cBuffer,1,116) + cTitulo + Substr(cBuffer,127,402-126)
      cLinha := Substr(cLinha,1,173) + cEspecie + Subs(cLinha,176)
      FWRITE( nHdlSai , cLinha )
   EndIF

   nLidos := nLidos + 402

EndDo
FCLOSE(nHdlBco)
FCLOSE(nHdlSai)

MsgBox("O arquivo foi gerado com sucesso, agora eh necessario proceder com a baixa dos titulos ", "Yes")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Integridade dos dados ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

#IFNDEF WINDOWS
        RestScreen( 0, 0,24,80,cSavScr1)
        SetColor(cSavCor1)
        SetCursor(cSavCur1)
        DevPos(cSavRow1,cSavCol1)
#ENDIF
Return()


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ PERGUNTAS³ Autor ³ MARCOS GOMES          ³ Data ³ 29/09/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria grupo de perguntas no SX1.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Exclusivo para Clientes Microsiga - Kenia                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> FUNCTION PERGUNTAS
Static FUNCTION PERGUNTAS()

_aPerguntas:= {}

//                  1       2          3                 4       5  6  7 8  9  10     11       12      13 14     15    16 17    18   19 20 21 22 23 24 25  26
AADD(_aPerguntas,{"CONTXT","01","Nome do Arquivo    ?","mv_ch1","C",30,0,0,"G","","mv_par01","       ","","","       ","","","     ","","","","","","","","   ",})

DbSelectArea("SX1")

FOR _nLaco:=1 to LEN(_aPerguntas)
   If !DbSeek(_aPerguntas[_nLaco,1]+_aPerguntas[_nLaco,2])
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
Return()



Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

