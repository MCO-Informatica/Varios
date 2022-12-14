#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Conslot()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//? SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//? identificando as variaveis publicas do sistema utilizadas no codigo ?
//? Incluido pelo assistente de conversao do AP6 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("_NSALDO,_AAREA,NPOSCODIGO,NPOSQTDLIB,NPOSLOTCTL,_CINDSB8")
SetPrvt("_CREGSB8,ACOLS,")

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴엽?
굇쿎liente   ? Kenia Industrias Texteis Ltda.                             낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇旼컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴엽?
굇쿛rograma:#? CONSLOT.prw                                                낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿏escricao:? Gatilho para verificar lote.                               낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컫컴컴컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿏ata:     ? 08/09/00    ? Implantacao: ? 08/09/00                      낢?
굇쳐컴컴컴컴컵컴컴컴컴컴컴컨컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙?
굇쿛rogramad:? Sergio Oliveira                                            낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇旼컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴엽?
굇쿚bjetivos:?     Este excblock recebe como parametro o numero do lote   낢?
굇?          ? obtido na leitura do codigo de barras e verifica se a eti- 낢?
굇?          ? queta confere com o produto indicado. Caso nao confira, se-낢?
굇?          ? ra acionado um alerta ao usuario.                          낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇旼컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴엽?
굇쿌rquivos :?                                                            낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
*/

_nSaldo  := 0
_aArea   := GetArea()

nPosCodigo := ASCAN(aHEADER,{|x| Upper(AllTrim(x[2])) == "C6_PRODUTO" })
nPosQtdLib := ASCAN(aHEADER,{|x| Upper(AllTrim(x[2])) == "C6_QTDLIB" })
nPosLotCtl := ASCAN(aHEADER,{|x| Upper(AllTrim(x[2])) == "C6_LOTECTL" })

DbSelectArea("SB8")
_cIndSB8 := IndexOrd()
_cRegSB8 := Recno()
   
DbSelectArea("SB8")
DbSetOrder(3)                  
Set SoftSeek Off   
If !DbSeek(xFilial()+Acols[N,nPosCodigo]+"01"+Acols[N,nPosLotCtl])
   
   MsgBox("Lote x Produto nao confere. Verifique.","Atencao","ALERT")
   
Else

   Set SoftSeek on
   While !Eof() .and. SB8->B8_LOCAL   == "01" .and.;
                      SB8->B8_PRODUTO == Acols[N,nPosCodigo] .and.;
                      SB8->B8_LOTECTL == Acols[N,nPosLotCtl]

          _nSaldo := _nSaldo + SB8->B8_SALDO

          DbSkip()

   End
   
EndIf

If _nSaldo == 0
   MsgBox("Este lote nao contem saldo no sistema. Verifique.","Atencao","ALERT")
Else
   Acols[n,nPosQtdLib] := _nSaldo       
EndIf

DbselectArea("SB8")
DbSetOrder(_cIndSB8)
DbGoTo(_cRegSB8)

RestArea(_aArea)

Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

