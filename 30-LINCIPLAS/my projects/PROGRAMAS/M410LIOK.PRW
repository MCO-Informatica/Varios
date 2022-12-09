#include "rwmake.ch"
#include "protheus.ch"
//-----------------------------------------------------------------
// TIPO :  PONTO DE ENTRADA NO PEDIDO DE VENDA (SC6)
// Autor: Marcus Feixas   Data: 17/03/2006
// Solicitado por: Cris / VAldivia
// Motivo: COndição de Pagamento tipo 9 (Digitado) se voce nao
//         observar e colocar o valor no campo do valor da parcela 
//         o sistema nao gera a duplicata....   
//-----------------------------------------------------------------
user Function M410LIOK(_PAR)
//---------------------
//
dbselectarea("SE4")
dbseek(xfilial("SE4")+M->C5_CONDPAG)
//
if SE4->E4_TIPO <> '9'
   if valtype(_PAR) <> 'U'
      if _PAR = '1'  // veio do gatilho no campo C5_DATA1
         return(M->C5_DATA1)
      endif
   endif
   return .t.
endif
// 
nPosQLIB  := Ascan( aHeader, { |x| Alltrim(x[2]) == "C6_QTDLIB"   } )
nPosPRECV := Ascan( aHeader, { |x| Alltrim(x[2]) == "C6_PRCVEN"   } )
nPosCOD   := Ascan( aHeader, { |x| Alltrim(x[2]) == "C6_PRODUTO"   } )

//
_nValor := 0
_ctd 	:= 1
for _ctd = 1 To len(aCols)
   // Olhando o IPI
   dbselectarea("SB1")
   dbseek(xfilial("SB1")+aCols[_ctd][nPosCod])
   // ----
   _nValIpi := (aCols[_ctd][nPosQLIB] * aCols[_ctd][nPosPRECV]) * (SB1->B1_IPI/100)
   _nValor += (aCols[_ctd][nPosQLIB] * aCols[_ctd][nPosPRECV]) + _nValIpi
   //
next _ctd
//
M->C5_PARC1 := _nValor
//
if valtype(_PAR) <> 'U'
   if _PAR = '1'  // veio do gatilho no campo C5_DATA1
//      return(M->C5_DATA1)
      RETURN('1')
   endif
endif   

return .t.


