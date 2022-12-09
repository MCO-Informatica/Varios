User Function MTA455NL()

		
Local _aArea := GetArea()   

RecLock("SC5",.f.)
SC5->C5_XDATALI	:=	dDataBase
MsUnLock()

RestArea(_aArea)

RETURN