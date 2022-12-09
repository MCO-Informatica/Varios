#include "rwmake.ch"

User Function CNABFOL(nParam)
	Local cRet  := ''

	If nParam == 1 //Banco
		cRet    :=  IIF(MV_PAR24 == 2,SUBSTR(SRQ->RQ_BCDEPBE,1,3),SUBSTR(SRA->RA_BCDEPSA,1,3))
	ElseIf nParam == 2 //AgÃªncia
		cRet    :=  IIF(MV_PAR24 == 2,STRZERO(VAL(SUBSTR(SRQ->RQ_BCDEPBE,4,5)),5),STRZERO(VAL(SUBSTR(SRA->RA_BCDEPSA,4,5)),5))
	elseif nParam == 3 //Conta Corrente
		cRet    :=  IIF(MV_PAR24 == 2,PADL(SUBSTR(RQ_CTDEPBE,1,Len(Rtrim(RA_CTDEPBE))-1),7,"0"),PADL(SUBSTR(RA_CTDEPSA,1,Len(Rtrim(RA_CTDEPSA))-1),7,"0"))
	elseif nParam == 4 //Dígito Conta
		cRet    :=  IIF(MV_PAR24 == 2,Right(Rtrim(RQ_CTDEPBE),1),Right(Rtrim(RA_CTDEPSA),1))
	elseif nParam == 5 //Nome
		cRet    :=  IIF(MV_PAR24 == 2,SUBS(SRQ->RQ_NOME,1,30),SUBS(SRA->RA_NOME,1,30))
	elseif nParam == 6 //Informações Complementares
		If Alltrim(MV_PAR01) == 'FOL'
			cRet    := 'HP01'+SPACE(16)
		ElseIf Alltrim(MV_PAR01) == 'FER'
			cRet    := 'HP02'+SPACE(16)
		ElseIf Alltrim(MV_PAR01) == '131' .OR. Alltrim(MV_PAR01) == '132'
			cRet    := 'HP03'+SPACE(16)
		ElseIf Alltrim(MV_PAR01) == 'ADI'
			cRet    := 'HP06'+SPACE(16)
		ElseIf Alltrim(MV_PAR01) == 'RES'
			cRet    := 'HP07'+SPACE(16)
		ElseIf Alltrim(MV_PAR01) == 'VTR'
			cRet    := 'HP08'+SPACE(16)
		ElseIf Alltrim(MV_PAR01) == 'VAL'
			cRet    := 'HP09'+SPACE(16)
		Else
			cRet    := SPACE(20)
		Endif
	elseif nParam == 7 //CPF
		cRet    :=  IIF(MV_PAR24 == 2,STRZERO(VAL(SRQ->RQ_CIC),14),STRZERO(VAL(SRA->RA_CIC),14))
	EndIf


Return cRet
