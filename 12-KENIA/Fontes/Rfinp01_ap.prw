#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Rfinp01()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//? SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//? identificando as variaveis publicas do sistema utilizadas no codigo ?
//? Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("SAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,NLASTKEY")
SetPrvt("NHDLBCO,NHDLSAI,CARQSAI,CARQENT,CNUMTIT,XNOVALINHA")
SetPrvt("CSAVCUR1,ACA,NOPCAO,NPOSIC,CARQNOV,NLIDOS")
SetPrvt("NTAMARQ,CBUFFER,CLINHA,CBANCO,CTIPOARQ,CPARCELA")
SetPrvt("CPREFIXO,CESPECIE,AARRAY,CPARC,NELEMENT,CTITULO")
SetPrvt("_APERGUNTAS,_NLACO,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿑un뇚o    ? rfinp01  ? Autor ? Marcos Gomes          ? Data ? 07.02.00 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escri뇚o ? Gera뇙o de Novo Arquivo de Retorno da Comunica뇙o Banc쟲ia 낢?
굇?          ? Necessario para arrumar a numeracao dos titulos que foram  낢?
굇?          ? enviados ao Banco antes do inicio das atividades do SIGA,  낢?
굇?          ? nao utilizando o PREFIXO, que e'chave de pesquisa do sist. 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇? Uso      ? Clientes Microsiga                                         낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
/*/

//旼컴컴컴컴컴컴컴컴커
//? Define Variaveis ?
//읕컴컴컴컴컴컴컴컴켸
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

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Salva a Integridade dos dados de Entrada ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
#IFNDEF WINDOWS
        cSavScr1   := SaveScreen(3,0,24,79)
        cSavCur1   := SetCursor(0)
        cSavRow1   := ROW()
        cSavCol1   := COL()
        cSavCor1   := SetColor("bg+/b,,,")
#ENDIF

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Variaveis utilizadas para parametros                         ?
//? mv_par01            // Arquivo de Entrada                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

   Perguntas()

If LastKey() == 27 .Or. nLastKey == 27
   RestScreen(3,0,24,79,cSavScr1)
   Return()
End

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Desenha a tela de pano de fundo                                           ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
#IFNDEF WINDOWS
        aCA := {"Confirma","Abandona"}
        ScreenDraw("SMT050",3,0,0,0)
        SetColor("w/w,,,,")
     
      @ 03,01 Say "Gera놹o de Novo Arquivo de Retorno CNAB" Color "R/w"

        //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
        //? Verifica os parametros                                                    ?
        //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

           Pergunte("CONTXT",.T.)
           SetColor("w/n,,,,")
           SetColor("b/bg,,,")
         @ 11,04 Say "Este programa tem o objetivo de gerar um Novo Arquivo de"
         @ 12,04 SAY "Retorno Bancario a partir do arquivo enviado pelo Banco."
           SetColor("n/w,,,,")
         @ 24,05 Clear To 24,76

           nOpcao := MenuH(aCA,24,6,"B/W,W+/N,R/W","CA","Quanto a gera놹o ?",2)

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

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Abre arquivo enviado pelo banco ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

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

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Cria Arquivo de Saida         ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

    nHdlSai := FCREATE(cArqEnt,0)
    FSEEK(nHdlSai,0,0)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? L? arquivo enviado pelo banco ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

nLidos:=0
FSEEK(nHdlBco,0,0)
nTamArq:=FSEEK(nHdlBco,0,2)
FSEEK(nHdlBco,0,0)

While nLidos < nTamArq

   //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
   //? Tipo qual registro foi lido ?
   //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
   
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

      //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
      //? L? os valores do arquivo Retorno ?
      //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

      cParcela  := Substr(cBuffer,123,2)
      cPrefixo  := Substr(cBuffer,117,3)
      cNumTit   := Substr(cBuffer,120,6)
      cEspecie  := Substr(cBuffer,174,2)
      
      //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
      //? Trata a Parcela do Titulo        ?
      //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

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

      //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
      //? Trata o Prefixo do Titulo        ?
      //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

      If cPrefixo <> "UNI"
         cPrefixo := "   " 
         cNumTit  := "0" + Substr(cBuffer,117,5)
      EndIf

      //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
      //? Monta Novo numero de Titulo      ?
      //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

      cTitulo := cPrefixo + cNumTit + cParc
      
      //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
      //? Trata especie do titulo          ?
      //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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

      //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
      //? Monta Nova Linha do CNAB         ?
      //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
    
      cLinha := Substr(cBuffer,1,116) + cTitulo + Substr(cBuffer,127,402-126)
      cLinha := Substr(cLinha,1,173) + cEspecie + Subs(cLinha,176)
      FWRITE( nHdlSai , cLinha )
   EndIF

   nLidos := nLidos + 402

EndDo
FCLOSE(nHdlBco)
FCLOSE(nHdlSai)

MsgBox("O arquivo foi gerado com sucesso, agora eh necessario proceder com a baixa dos titulos ", "Yes")

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Recupera a Integridade dos dados ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

#IFNDEF WINDOWS
        RestScreen( 0, 0,24,80,cSavScr1)
        SetColor(cSavCor1)
        SetCursor(cSavCur1)
        DevPos(cSavRow1,cSavCol1)
#ENDIF
Return()


/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇? Fun뇚o   ? PERGUNTAS? Autor ? MARCOS GOMES          ? Data ? 29/09/99 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escri뇚o ? Cria grupo de perguntas no SX1.                            낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿢so       ? Exclusivo para Clientes Microsiga - Kenia                  낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
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

