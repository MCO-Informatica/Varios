#INCLUDE "RWMAKE.CH"

USER FUNCTION MT103FRT()

//Exemplo Raiz do CNPJ da empresa (SIGAMAT.EMP)
aFilial := {}
nRegSM0 := SM0->(RECNO())
cEmpAtu := SM0->M0_CODIGO
cCnpj	  := Substr(SM0->M0_CGC,1,8)
//cEmpAtu := SM0->M0_CODFIL
aArea := GetArea()
dbselectArea ("SM0")
dbSeek(cEmpAtu)
While !Eof() .and. SM0->M0_CODIGO == cEmpAtu
   If Substr(SM0->M0_CODFIL,1,5) == Substr(cfilant,1,5)
		AADD(AFILIAL,SM0->M0_CODFIL)
   Endif
	dbSkip()
Enddo			
SM0->(dbGoto(nRegSM0))
Return (aFilial)
