#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Verb1()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//? SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//? identificando as variaveis publicas do sistema utilizadas no codigo ?
//? Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("_AAREA,_CINDSB1,_CREGSB1,")

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴엽?
굇쿎liente   ? Kenia Industrias Texteis Ltda.                             낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇旼컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴엽?
굇쿛rograma:#? VERB1.prw                                                  낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿏escricao:? Execblock que verifica se produto tem rastro.              낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컫컴컴컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿏ata:     ? 31/08/00    ? Implantacao: ? 31/08/00                      낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컨컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿛rogramad:? Sergio Oliveira                                            낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇旼컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴엽?
굇쿚bjetivos:? Este execblock verifica se o produto que esta sendo devol- 낢?
굇?          ? vido possui rastreabilidade(se for PA). Em caso afirmativo 낢?
굇?          ? o usuario devera ser notificado quanto a necessidade de    낢?
굇?          ? incluir um lote manualmente com esta quantidade devolvida. 낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇旼컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴엽?
굇쿌rquivos :? SD1 e SB1.                                                 낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
*/

_aArea := RestArea()

If SM0->M0_CODIGO != "80"
   RestArea(_aArea)
   Return()
EndIf

DbSelectArea("SB1")
_cIndSB1 := IndexOrd()
_cRegSB1 := Recno()

DbSetOrder(1)
If DbSeek(xFilial()+SD1->D1_COD,.F.)
   If SB1->B1_TIPO == "PA"
      If SB1->B1_RASTRO != "L"
         MsgBox("Nao se esqueca de incluir um lote manualmente"+Chr(13)+"na rotina de manutencao de lotes","Info","Atencao")
         RecLock("SB1",.F.)
         SB1->B1_RASTRO  := "L"
         SB1->B1_FORMLOT := "003"
         MsUnLock()
      EndIf
   EndIf
Else
   MsgBox("Produto nao cadastrado","Alert","Atencao")
EndIf
   
DbSelectArea("SB1")
DbSetOrder(_cIndSB1)
DbGoTo(_cRegSB1)

RestArea(_aArea)

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

