#include "rwmake.ch"

User Function INCREMEN()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//? SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//? identificando as variaveis publicas do sistema utilizadas no codigo ?
//? Incluido pelo assistente de conversao do AP5 IDE                    ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?

SetPrvt("NTAMLIN,CARQ,NHDL,CBUFFER,NBYTES,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿛rograma  ? INCREMENTA ? Autor ? Paulo H. R. Mata      ? Data ? 16/10/02 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escri뇚o ? Incremento de Numero de Registro para CNAB a RECEBER       낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
/*/       

Processa({|| AcrTxt()},"Incremento de Numero de Registro para CNAB a RECEBER","Aguarde...")

Return

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽?
굇쿛rograma  ? ACRTXT   ? Autor ? Paulo H. R. Mata      ? Data ? 16/10/02 낢?
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙?
굇쿏escri뇚o ? Incremento de Numero de Registro para CNAB a RECEBER       낢?
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂?
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇?
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽?
/*/       

Static Function ACRTXT

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//? Declara variaveis                                 ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴?
//cArq     := "C:\AP7\AP_DATA\SIGAADV\"+Mv_Par04
cArq     := "C:\AP7\AP_DATA\SIGAADV\"+Mv_ARQ
_cFil01  := _cFil03 := _cFiller := ""
_nSoma   := 1
_nQtde   := 0

If !File(cArq)
   Alert("Arquivo Inexistente !!!")
   Return
Endif   

//旼컴컴컴컴컴컴컴컴컴컴컴컴?
//? Cria arquivo Tempor?rio ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴?
aCampos := {}

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//? Cria arquivo de trabalho                                     ?
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
AADD(aCampos,{"FILLER","C",240,0 } )

_cNomTrb := CriaTrab(aCampos)

dbSelectArea(0)
dbUseArea( .T.,,_cNomTRB,"TRB", if(.F. .OR. .F., !.F., NIL), .F. )
dbSelectArea("TRB")
Append From &cArq SDF

dbGoTop()
ProcRegua(RecCount())

While !Eof()
   IncProc()
   
   If SubStr(TRB->FILLER,8,1) == "3"
      _cFil01 := SubStr(TRB->FILLER,1,8)
      _cFil03 := SubStr(TRB->FILLER,14,226)

      RecLock("TRB",.f.)
      TRB->FILLER := _cFil01+StrZero(_nSoma,5)+_cFil03
      MsUnLock()
      _nSoma++
   Endif
   _nQtde++
      
   If SubStr(TRB->FILLER,8,1) != "5"
      dbSkip()
   Else
      _cFil01 := SubStr(TRB->FILLER,1,17)
      _cFil03 := SubStr(TRB->FILLER,24,216)
      RecLock("TRB",.f.)
      TRB->FILLER := _cFil01+StrZero(_nSoma+1,6)+_cFil03
      MsUnLock()
      _nQtde := _nQtde + 1
      dbSkip()
      If SubStr(TRB->FILLER,8,1) == "9"
         _cFil01 := SubStr(TRB->FILLER,1,23)
         _cFil03 := SubStr(TRB->FILLER,30,210)
         RecLock("TRB",.f.)
         TRB->FILLER := _cFil01+StrZero(_nQtde,6)+_cFil03
         MsUnLock()
      Endif
      Exit
   Endif
Enddo

Copy to &cArq SDF

dbSelectArea("TRB")
dbCloseArea()

Ferase(_cNomTrb+".DBF")
Ferase(_cNomTrb+".MEM")

Return