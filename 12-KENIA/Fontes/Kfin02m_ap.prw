#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Kfin02m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_AAREA,_LRET,CTITMSG,_AAREAE1,_CCGC,_CCLIENTE")
SetPrvt("_CLOJA,_CNOMCLI,_DVENCTO,_DVENCREA,_DVENCORI,_DVENCANT")
SetPrvt("_CFORNEC,_CNOMFOR,_CPORTADOR,_CNATUREZA,_OBJ,_AAREAA2")
SetPrvt("_AAREAE2,")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ KFIN02M  ³ Autor ³Ricardo Correa de Souza³ Data ³07/11/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Execblock disparado a partir do programa KFIN01M.PRW       ³±±
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

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

_aArea := GetArea()

_lRet := .T.
cTitMsg := " Atencao!  Sr.(a) "+subs(cusuario,7,14)
If INCLUI
    DbSelectArea('SE1')
    _aAreaE1 := GetArea()
    DbSetOrder(1)
    DbSeek(xFilial('SE1')+M->Z4_PREFIXO+M->Z4_TITULO+M->Z4_PARCELA+M->Z4_TIPO)
    If !Found()
        _lRet := .F.
       MsgBox("Titulo "+M->Z4_PREFIXO+"  "+M->Z4_TITULO+"  "+M->Z4_PARCELA+"  "+M->Z4_TIPO+"  Nao Encontrado...",cTitMsg,"ALERT")
    Else
        _cCGC              :=           Posicione("SA1",1,xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,"A1_CGC")
        _cCliente          :=           SE1->E1_CLIENTE
        _cLoja             :=           SE1->E1_LOJA
        _cNomCli           :=           SE1->E1_NOMCLI
        _dVencto           :=           SE1->E1_VENCTO
        _dVencrea          :=           SE1->E1_VENCREA
        If M->Z4_TIPO == "NDC"
            _dVencOri          :=           SE1->E1_VENCREA
        Else
            _dVencOri          :=           SE1->E1_VENCORI
        EndIf

        _dVencAnt          :=           SE1->E1_VENCTO

       If !Empty(M->Z4_NOVVEN) .And. M->Z4_NOVVEN > E1_VENCTO

          Reclock("SE1",.f.)
          SE1->E1_DTPRORR := _dVencAnt
          SE1->E1_VENCTO  := M->Z4_NOVVEN
          SE1->E1_VENCREA := DataValida(M->Z4_NOVVEN)
          MsUnlock()
       EndIf

       If M->Z4_DEVBXR == 'S' .and. SE1->E1_SITUACA $ "2/3/4/7"
          GetBenef()
       EndIf

       If Round(M->Z4_ABATIM,2) >= 0.01
          MostraTitulo()
       EndIf

    EndIf
    RestArea(_aAreaE1)
EndIf

RestArea(_aArea)
// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return(_lRet)
Return(_lRet)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

*---------------------------------------------------------------------------*
Static Function GetBenef
*---------------------------------------------------------------------------*
_cFornec := space(8)
_cLoja   := space(2)
_cNomFor := space(40)
_cPortador := space(3)
_cNatureza := space(10)

@100,01 to 300,555 DIALOG oDlg1 TITLE 'Dados para a Ordem de Pagamento'

@ 005,10 Say "A T E N C A O !!  Esta Instrucao esta prestes a gerar um Titulo a Pagar."
@ 015,50 Say "Para Confirmar digite abaixo os dados do FAVORECIDO."
@ 030,10 Say "Fornecedor "
@ 040,10 Say "Loja       "
@ 050,10 Say "Portador   "
@ 060,10 Say "Natureza   "
@ 030,50 GET _cFornec PICTURE "@!" F3 "SA2"
@ 040,50 GET _cLoja   PICTURE "@!"
@ 050,50 GET _cPortador PICTURE "@!" F3 "SA6"
@ 060,50 GET _cNatureza PICTURE "@!" F3 "SED" Valid Entre("0406010001","0406029999");  // NaoVazio()
                                 .AND. EXISTCPO("SED") .AND. LEN(_cNatureza) == 10

_Obj := "oDlg1"

@ 75,60 Say "Gera Titulo a Pagar ? "
@ 70,140 BUTTON "_Sim"     size 35,15 ACTION GravaTitPagar()// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> @ 70,140 BUTTON "_Sim"     size 35,15 ACTION Execute(GravaTitPagar)
@ 70,180 BUTTON "_Nao"     size 35,15 ACTION Close(oDlg1)
@ 70,220 BUTTON "_Cancela" size 35,15 ACTION Cancela()// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> @ 70,220 BUTTON "_Cancela" size 35,15 ACTION Execute(Cancela)

ACTIVATE DIALOG oDlg1 CENTER

Return


*---------------------------------------------------------------------------*
Static Function GravaTitPagar
*---------------------------------------------------------------------------*
        DbSelectArea('SA2')
        _aAreaA2 := GetArea()
        DbSetOrder(1)
        DbSeek(xFilial('SA2')+_cFornec+_cLoja)
        If Found()
           _cNomFor := sa2->a2_nreduz
        Else
            MsgBox("Favorecido [ "+_cFornec+"-"+_cLoja+" ] nao encontrado no Cadastro de Fornecedores. Certifique-se de ter digitado a Loja",cTitMsg,"ALERT")
        Return
     EndIf
     RestArea(_aAreaA2)


          DbSelectArea('SE2')
          _aAreaE2 := GetArea()
          DbSetOrder(1)
          DbSeek(xFilial("SE2")+M->Z4_PREFIXO+M->Z4_TITULO+M->Z4_PARCELA+"CH "+_cFornec+_cLoja)
          If Found() == .f.
             _lRet := .T.
             Reclock("SE2",.T.)
                    SE2->E2_FILIAL  := xFilial()
                    SE2->E2_PREFIXO := M->Z4_PREFIXO
                    SE2->E2_NUM     := M->Z4_TITULO
                    SE2->E2_PARCELA := M->Z4_PARCELA
                    SE2->E2_TIPO    := 'CH '
                    SE2->E2_NATUREZ := _cNatureza
                    SE2->E2_PORTADO := _cPortador
                    SE2->E2_FORNECE := _cFornec
                    SE2->E2_LOJA    := _cLoja
                    SE2->E2_NOMFOR  := _cNomFor
                    SE2->E2_EMISSAO := M->Z4_DATA
                    SE2->E2_VENCTO  := If(SE1->E1_VENCTO < M->Z4_DATA,M->Z4_DATA,SE1->E1_VENCTO)
                    SE2->E2_VENCREA := If(SE1->E1_VENCREA < M->Z4_DATA,M->Z4_DATA,SE1->E1_VENCREA)
                    SE2->E2_VALOR   := SE1->E1_SALDO
                    SE2->E2_EMIS1   := M->Z4_DATA
                    SE2->E2_HIST    := 'RECOMPRA TIT.'+M->Z4_PREFIXO+M->Z4_TITULO+M->Z4_PARCELA
                    SE2->E2_LA      := 'S'
                    SE2->E2_SALDO   := SE1->E1_SALDO
                    SE2->E2_VENCORI := If(SE1->E1_VENCORI < M->Z4_DATA,M->Z4_DATA,SE1->E1_VENCORI)
                    SE2->E2_MOEDA   := 1
                    SE2->E2_RATEIO  := 'N'
                    SE2->E2_VLCRUZ  := SE1->E1_SALDO
                    SE2->E2_OCORREN := '01'
                    SE2->E2_ORIGEM  := 'FINA050'
                    SE2->E2_FLUXO   := 'S'
                    SE2->E2_DESDOBR := 'N'
               MsUnlock()
          Else
               MsgBox("Titulo "+M->Z4_PREFIXO+"  "+M->Z4_TITULO+"  "+M->Z4_PARCELA+"  Ja Existe no Contas a Pagar. Nao sera gerada a OP.",cTitMsg,"ALERT")
               _lRet := .f.
               Return
          EndIf

       RestArea(_aAreaE2)
       Close(oDlg1)
       Return

*---------------------------------------------------------------------------*
Static Function MostraTitulo
*---------------------------------------------------------------------------*

@100,01 to 250,500 DIALOG oDlg2 TITLE 'Instrucao de Abatimento sobre Titulo'

@ 005,10 Say "A T E N C A O !!  Esta Instrucao ira gerar um titulo do Tipo [AB-] conforme segue:"
@ 020,10 Say "Cliente: " + _cCliente + " - "+_cLoja+"   CGC : " + _cCGC
@ 030,10 Say "Nome   : " + _cNomCli
@ 040,10 Say "Titulo : " + M->Z4_PREFIXO+"  "+M->Z4_TITULO+"  "+M->Z4_PARCELA+"  "+M->Z4_TIPO
@ 040,100 Say "Valor : " + str(M->Z4_ABATIM)
_Obj := "oDlg2"

@ 55,20 Say "Gera Titulo de Abat.(AB-) ?"
@ 50,120 BUTTON "_Sim"     size 35,15 ACTION GravAbat()// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> @ 50,120 BUTTON "_Sim"     size 35,15 ACTION Execute(GravAbat)
@ 50,160 BUTTON "_Nao"     size 35,15 ACTION Close(oDlg2)
@ 50,200 BUTTON "_Cancela" size 35,15 ACTION Cancela()// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> @ 50,200 BUTTON "_Cancela" size 35,15 ACTION Execute(Cancela)

ACTIVATE DIALOG oDlg2 CENTER

Return

*---------------------------------------------------------------------------*
Static Function GravAbat
*---------------------------------------------------------------------------*

       If Round(M->Z4_ABATIM,2) <= SE1->E1_SALDO

          DbSeek(xFilial('SE1')+M->Z4_PREFIXO+M->Z4_TITULO+M->Z4_PARCELA+"AB-")
          If found() == .f.

               Reclock("SE1",.T.)
                    SE1->E1_FILIAL  := xFilial()
                    SE1->E1_PREFIXO := M->Z4_PREFIXO
                    SE1->E1_NUM     := M->Z4_TITULO
                    SE1->E1_PARCELA := M->Z4_PARCELA
                    SE1->E1_TIPO    := 'AB-'
                    SE1->E1_NATUREZ := '0000'
                    //SE1->E1_CGC     := _cCGC
                    SE1->E1_CLIENTE := _cCliente
                    SE1->E1_LOJA    := _cLoja
                    SE1->E1_NOMCLI  := _cNomCli
                    SE1->E1_EMISSAO := M->Z4_DATA
                    SE1->E1_EMIS1   := M->Z4_DATA
                    SE1->E1_VENCTO  := If(_DVENCTO < M->Z4_DATA,M->Z4_DATA,_DVENCTO)
                    SE1->E1_VENCREA := If(_DVENCREA < M->Z4_DATA,M->Z4_DATA,_DVENCREA)
                    SE1->E1_VENCORI := If(_DVENCORI < M->Z4_DATA,M->Z4_DATA,_DVENCORI)
                    SE1->E1_VALOR   := M->Z4_ABATIM
                    SE1->E1_VLCRUZ  := M->Z4_ABATIM
                    SE1->E1_SALDO   := M->Z4_ABATIM
                    SE1->E1_HIST    := 'INSTR.DE ABATIMENTO'
                    SE1->E1_LA      := 'N'
                    SE1->E1_SITUACA := '0'
                    SE1->E1_MOEDA   := 1
                    SE1->E1_OCORREN := '04'
                    SE1->E1_STATUS  := 'A'
                    SE1->E1_ORIGEM  := 'FINA040'
                    SE1->E1_FLUXO   := 'S'
                    //SE1->E1_DOCORIG := M->Z4_PREFIXO+M->Z4_TITULO+M->Z4_PARCELA+"NF "
                MsUnlock()
          Else
             MsgBox("Este titulo ja possui instrucao de abatimento. Nao podera ser gerado outro [AB-] para o mesmo titulo.",cTitMsg,"ALERT")
             _lRet := .F.
          EndIf

       Else
          MsgBox("O valor do Desconto nao pode superar o valor do Titulo ",cTitMsg,"ALERT")
          _lRet := .F.

       EndIf
       Close(oDlg2)
       Return

*---------------------------------------------------------------------------*
Static Function Cancela
*---------------------------------------------------------------------------*
Close(&_Obj)
_lRet := .F.
Return


