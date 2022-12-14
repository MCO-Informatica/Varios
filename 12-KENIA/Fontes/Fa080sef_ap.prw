#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Fa080sef()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//? SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//? identificando as variaveis publicas do sistema utilizadas no codigo ?
//? Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("_AAREAATU,_CBENEF,_NOPCOES,_AOPCOES,_AAREASA6,_AAREASA2")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿛rograma  ? FA080SEF ? Autor 쿗uciano Lorenzetti     ? Data ?03/09/2000낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escricao ? Permite Selecao do Beneficiario na Baixa a Pagar           낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿢so       ? Kenia Industrias Texteis Ltda                              낢?
굇쳐컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇?            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           낢?
굇쳐컴컴컴컴컴컴컫컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇?   Analista   ?  Data  ?             Motivo da Alteracao               낢?
굇쳐컴컴컴컴컴컴컵컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇?              ?        ?                                               낢?
굇읕컴컴컴컴컴컴컨컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
/*/

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Processamento                                                             *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

//----> valida se o usuario esta na rotina de baixas a pagar
If Alltrim(FunName()) <> 'FINA080' .OR. Empty(SEF->EF_NUM)
   Return
Endif

_aAreaAtu := GetArea()      //----> guarda area/indice/registro atual
_cBenef   := Space(40)      //----> nome do beneficiario
_nOpcoes  := 1              //----> guarda opcao escolhida 
_aOpcoes  := {"Banco","Fornecedor","Sem Beneficiario"}

@ 110,151 To 175,461 Dialog _oDlgBenef TITLE OemToAnsi('Beneficiario do Cheque')
@ 4,7 Radio _aOpcoes Var _nOpcoes
@ 17,107 BMPBUTTON TYPE 1 ACTION Close(_oDlgBenef)
Activate Dialog _oDlgBenef Center

//----> verifica se opcao ? banco
If _nOpcoes == 1
    DbSelectArea("SA6")
    _aAreaSA6 := GetArea()
    DbSetOrder(1)
    If DbSeek(xFilial("SA6")+SEF->EF_BANCO+SEF->EF_AGENCIA+SEF->EF_CONTA)
        _cBenef := SA6->A6_NOME
    Endif
    RestArea(_aAreaSA6)
Else
//----> Fornecedor
    DbSelectArea("SA2")
    _aAreaSA2 := GetArea()
    DbSetOrder(1)
    If DbSeek(xFilial("SA2")+SEF->EF_FORNECE+SEF->EF_LOJA)
        _cBenef := SA2->A2_NOME
    Endif
    RestArea(_aAreaSA2)
Endif

//----> Cheque
DbSelectArea("SEF")
RecLock("SEF",.F.)
SEF->EF_BENEF := IIf(_nOpcoes==3,".",_cBenef)
MsUnlock()

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Retornando a Integridade dos Arquivos Antes da Manipulacao                *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*

RestArea(_aAreaAtu)

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
