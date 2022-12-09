User Function MTA450T()

		
Local _aArea := GetArea()   

RecLock("SC5",.f.)
SC5->C5_XDATALI	:=	dDataBase
MsUnLock()

RestArea(_aArea)

RETURN