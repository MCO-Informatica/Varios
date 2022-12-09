#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

User Function Ace_b9()        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_DATA,_COD,_NQUANT,")

* ace_b9.prw

alert("inicio")
_data:= ctod("28/06/2001")
dbselectarea("SB7")
dbsetorder(1)
dbseek(xFilial() + dtos(_data))
while B7_DATA < CTOD("02/07/2001")
  if empty(B7_LOTECTL)
     dbskip()
     loop
  endif

  _cod	 := B7_COD
  _nQuant:= 0
  while !eof() .and. B7_COD == _cod
     _nQuant:= _nQuant + B7_QUANT

     dbselectarea("SB8")
     dbsetorder(3)
     dbseek(xFilial() + _cod + "01" + SB7->B7_LOTECTL)
     if !eof()
	reclock("SB8",.F.)
	SB8->B8_SALDO:= SB7->B7_QUANT
	msunlock()
     endif

     dbselectarea("SB7")
     dbskip()
  enddo

  dbselectarea("SB9")
  dbseek(xFilial() + _cod + "01" + "20010701")
  if !eof()
     reclock("SB9",.F.)
     SB9->B9_VINI1:= B9_VINI1 * (_nQuant/B9_QINI)
     SB9->B9_QINI := _nQuant
     msunlock()
  endif

  dbselectarea("SB7")

enddo

alert("fim")


Return(nil)        // incluido pelo assistente de conversao do AP6 IDE em 12/02/05

