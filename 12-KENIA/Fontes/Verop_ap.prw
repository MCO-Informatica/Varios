#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Verop()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//? SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//? identificando as variaveis publicas do sistema utilizadas no codigo ?
//? Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("_AAREA,_CINDSC2,_CREGSC2,")

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴엽?
굇쿎liente   ? Kenia Industrias Texteis Ltda.                             낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇旼컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴엽?
굇쿛rograma:#? VEROP.prw                                                  낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿏escricao:? Gatilho que verifica se a quantidade apontada na producao  낢?
굇?          ? esta maior do que a op.(CAMPO->D3_QUANT)                   낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컫컴컴컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿏ata:     ? 31/08/00    ? Implantacao: ? 31/08/00                      낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컨컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿛rogramad:? Sergio Oliveira                                            낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇旼컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴엽?
굇쿌rquivos :? SD3 e SC2.                                                 낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
*/

_aArea    := GetArea()

DbSelectArea("SC2")
_cIndSC2 := IndexOrd()
_cRegSC2 := Recno()

DbSetOrder(1)
DbSeek(xFilial()+M->D3_OP,.F.)
   
If M->D3_QUANT > SC2->C2_QUANT 
      
   MsgBox("Quantidade Incompatibilizada com a O.P","ALERT","PRODUCAO")
      
   DbSelectArea("SC2")
   DbSetOrder(_cIndSC2)
   DbGoTo(_cRegSC2)

   RestArea(_aArea)
   
   Return(SC2->C2_QUANT)

EndIf

RestArea(_aArea)

Return(M->D3_QUANT)

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

