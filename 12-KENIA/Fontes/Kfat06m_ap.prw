#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Kfat06m()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//? SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//? identificando as variaveis publicas do sistema utilizadas no codigo ?
//? Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("NPOS,CTES,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿛rograma  ? KFAT06M  ? Autor 쿝icardo Correa de Souza? Data ?22/11/2001낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escricao ? Valida Digitacao do Tes no Pedido de Vendas                낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿢so       ? Kenia Industrias Texteis Ltda                              낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿚bservacao? Gatilho Disparado no Campo C6_TES                          낢?
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

//----> verifica se ? inclusao de pedidos
If Inclui
    nPos  := Ascan(aHeader,{|x|Upper(Alltrim(x[2]))=="C6_TES"})
    cTes  := aCols[n,nPos]

    DbSelectArea("SF4")
    DbSetOrder(1)
    DbSeek(xFilial("SF4")+cTes)

//    If !Alltrim(Subs(cUsuario,7,4))$"Admin/Roge/Albe/Rona/Reja/Euge"
//        If !Alltrim(SF4->F4_CF) $ "5101/5102/5124/5125/6101/6102/6124/6125/7101/7102/7124/7125"  
//            MsgBox("Atencao Sr(a) "+Alltrim(Subs(cUsuario,7,14))+", voce nao tem autorizacao para utilizar tes cuja natureza de operacao seja venda. Informe um tes que nao trate de venda de mercadoria.","Valida Tes - Inclusao","Stop")
//            cTes := Space(03)
//        EndIf
//    EndIf
//----> verifica se ? altera눯o de pedidos
ElseIf Altera
    cTes := SC6->C6_TES

//    If !Alltrim(Subs(cUsuario,7,4))$"Admin/Roge/Albe/Rona/Reja/Euge"
//        MsgBox("Atencao Sr(a) "+Alltrim(Subs(cUsuario,7,14))+", voce nao tem autorizacao para alterar o tes no pedido. Caso seja necessario alterar o tes, solicite ao usuario responsavel pelo cadastramento dos pedidos.","Valida Tes - Alteracao","Stop")
//    Else 
        cTes := M->C6_TES
//    EndIf
EndIf

// Substituido pelo assistente de conversao do AP6 IDE em 12/02/05 ==> __Return(cTes)
Return(cTes)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Fim do Programa                                                           *
*---------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
