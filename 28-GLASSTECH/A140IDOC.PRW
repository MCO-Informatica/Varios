#Include 'Protheus.ch'

 
User Function A140IDOC()


Local cDoc := PARAMIXB[1]

Local cSerie  := PARAMIXB[2]

Local cCodFor := PARAMIXB[3]

Local cLojaFor := PARAMIXB[4]

Local aRet  := {}


If !Empty(cSerie) .AND. VAL(cSerie) >= 0 .AND. VAL(cSerie) <= 9
 
cSerie := StrZero(VAL(cSerie),3)
cSerie := StrZero(VAL(cSerie),3)
Endif  


Return aRet
