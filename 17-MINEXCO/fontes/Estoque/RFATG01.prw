#include "rwmake.ch"

User Function RFATG01()

Local _cCodProd	:=	Space(15)
Local _cSequenc	:=	Space(04)	


dbSelectArea("SB1")
dbSetOrder(1)
If dbSeek(xFilial("SB1")+M->B1_TIPO+M->B1_GRUPO,.f.)

	While Subs(SB1->B1_COD,1,6) == M->B1_TIPO+M->B1_GRUPO
		_cSequenc	:=	Subs(SB1->B1_COD,7,4)
		
		dbSkip()
	EndDo
	
	_cSequenc	:=	StrZero((Val(_cSequenc)+1),4)	
Else
	_cSequenc	:=	"0001"
EndIf

_cCodProd	:=	Alltrim(M->B1_TIPO+M->B1_GRUPO+_cSequenc)

Return(_cCodProd)
