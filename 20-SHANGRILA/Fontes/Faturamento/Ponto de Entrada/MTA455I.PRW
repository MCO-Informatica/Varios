User Function MTA455I()

		
Local _aArea := GetArea()   

RecLock("SC5",.f.)
SC5->C5_XDATALI	:=	dDataBase
MsUnLock()

RestArea(_aArea)

RETURN