#include "rwmake.ch"
/*    
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±º Programa  ºTMKVFIM ºAutor  LMSuguiura          º Data º 19/12/2018    ±±
±±º  Ponto de Entrada para efetuar a gravação de campos customizados      ±±
±±º  do orcamento do Call Center para o Pedido de Venda                   ±±
±±º Uso Especifico Lifeskin                                               ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//
USER FUNCTION TMKVFIM(_cNumOrc, _cPed)

    Local _aAlias := {Alias(), IndexOrd(), RecNo()}
    Local _xRet

    IF !Empty(Alltrim(_cPed))
        //
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ A função abaixo garante o posicionamento do cabeçalho do pedido de vendas. ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        //
        DbSelectArea("SC5")	                        //Seleciona o arquivo do cabeçalho
        DbSetOrder(1)		                //Estabelece a ordem de pesquisa
        IF DbSeek(xFilial("SC5") + _cPed, .F.)	//Pesquisa o nº do pedido gerado gravado no cabeçalho do
            fTransCmp(_cNumOrc, _cPed)	        //Rotina auxiliar que grava os campos no pedido de vendas
        ELSE
            MsgBox("ERRO: Não foi possível localizar o pedido de vendas " + _cPed)
        ENDIF
    ELSE
        if SUA->UA_OPER = '1'
            MsgBox("ERRO: O número do pedido de vendas veio em branco!")
        endif
    ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura o ambiente original. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    DbSelectArea(_aAlias[1])
    DbSetOrder(_aAlias[2])
    DbGoTo(_aAlias[3])

RETURN


//ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
//º Funcao para transportar os campos customizados do SUA para o SC5 e do SUB para o SC6 e tambem manipular os dados º
//º relativos as reservas efetuadas nos lotes a partir do Call Center - TLV                                          º 
//ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
//
STATIC FUNCTION fTransCmp(_cNumOrc, _cPed)

    dbSelectArea("SC5")

    RecLock("SC5", .f.)	//Trava o arquivo SC5 para efetuar a gravação

    SC5->C5_MENNOTA	:= SUA->UA_MENNOTA
    SC5->C5_MENPAD  := SUA->UA_MENPAD

    C5_X_USERS      := SUA->UA_X_USERS
    C5_X_EMPFA      := SUA->UA_X_EMPFA
    C5_DF           := SUA->UA_DF
    C5_VENDE        := SUA->UA_VENDE
    C5_FORMAPG      := SUA->UA_FORMAPG
    C5_XDIA         := SUA->UA_XDIA
    C5_HORA         := SUA->UA_HORA
    C5_HORA1        := SUA->UA_HORA1
    C5_HORA2        := SUA->UA_HORA2
    C5_ENTREGA      := SUA->UA_ENTREGA
    C5_OBS1         := SUA->UA_OBS1
    C5_OBS2         := SUA->UA_OBS2
    C5_OBS3         := SUA->UA_OBS3

    SC5->C5_VEND2   := SUA->UA_VEND2
    SC5->C5_COMIS2  := SUA->UA_COMIS2

    SC5->C5_VEND3   := SUA->UA_VEND3
    SC5->C5_COMIS3  := SUA->UA_COMIS3


    SC5->C5_VEND4   := SUA->UA_VEND4
    SC5->C5_COMIS4  := SUA->UA_COMIS4


    SC5->C5_TIPLIB  := "2"
    SC5->C5_FECENT  := SUA->UA_FECENT
    SC5->C5_X_PROGR	:= "N"
    MSUnlock()

Return()
