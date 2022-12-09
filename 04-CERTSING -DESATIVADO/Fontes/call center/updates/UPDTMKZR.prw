#Include "Totvs.ch"

//Renato Ruy - 18/05/2018
//Atualizar a descrição dos produtos da tabela com a mesma do site.
User Function UPDTMKZR()

RpcSetType(3)
RpcSetEnv("01","02")

Beginsql Alias "TMPZZR"
	SELECT ZZR_ITEM, ZZR_CDGAR, PA8_CODBPG, PA8_DESBPG, PA8_CODMP8, ZZR.R_E_C_N_O_ RECNOZZR 
	FROM ZZR010 ZZR
	LEFT JOIN PA8010 PA8 
	ON PA8_CODBPG = ZZR_CDGAR AND PA8.D_E_L_E_T_ = ' ' 
	WHERE
	ZZR_FILIAL = ' ' AND
	ZZR.D_E_L_E_T_ = ' '
Endsql

While !TMPZZR->(EOF())
	
	ZZR->(DbGoTo(TMPZZR->RECNOZZR))
	
	If TMPZZR->ZZR_CDGAR == ZZR->ZZR_CDGAR
		
		RecLock("ZZR",.F.)
			ZZR->ZZR_DESC := TMPZZR->PA8_DESBPG
		ZZR->(MsUnlock())
		
	
	Endif
	
	TMPZZR->(DBSKIP())
Enddo

return