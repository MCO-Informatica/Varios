#include "totvs.ch"

USER FUNCTION COMPADA1()

Local cUpdate1 := ""
Local cUpdate2 := ""

//Abre a conexão com a empresa
RpcSetType(3)
RpcSetEnv("01","02")

// CAMPOS QUE SERÃO ALTERADOS NA SX3
DbSelectArea("SX3")
DbSetOrder(2)

// DA1_CODGAR - Somente adiciona F3 e validações
If DbSeek("DA1_CODGAR")
	
	RecLock("SX3",.F.)
		SX3->X3_VALID  := "ExistCpo('PA8', M->DA1_CODGAR, 1) .And. U_CSTA040() .And. U_CSTA120()"
		SX3->X3_F3     := "PA8"
		SX3->X3_WHEN   := "U_CSTA090()"
	SX3->(MsUnlock())

EndIf 

// DA1_CODGAR - Somente adiciona F3 e validações
If DbSeek("DA1_CODPRO")
	
	RecLock("SX3",.F.)
		SX3->X3_VALID  := "U_CSTA050() .And. U_CSTA120()"
		SX3->X3_WHEN   := "U_CSTA090()"
	SX3->(MsUnlock())

EndIf 

// DA1_CODGAR - Somente adiciona F3 e validações
If DbSeek("DA1_ATIVO")
	
	RecLock("SX3",.F.)
		SX3->X3_VALID  := "U_CSTA100() .And. U_CSTA120()"
		SX3->X3_RELACAO:= "2"
	SX3->(MsUnlock())

EndIf 

Beginsql Alias "TMPTAB"

	SELECT DA1_CODPRO, DA1_DESCRI FROM DA1010
	WHERE
	DA1_FILIAL = ' ' AND
	DA1_CODGAR = ' ' AND
	DA1_ATIVO  = '1' AND
	D_E_L_E_T_ = ' '
	GROUP BY DA1_CODPRO, DA1_DESCRI

Endsql

//Se posiciona
PA8->(DbSetOrder(1))

While !TMPTAB->(EOF())
	
	If !PA8->(DbSeek(xFilial("PA8")+TMPTAB->DA1_CODPRO))
		Reclock("PA8",.T.)
			PA8->PA8_CODBPG := TMPTAB->DA1_CODPRO
			PA8->PA8_DESBPG := TMPTAB->DA1_DESCRI
			PA8->PA8_CODMP8 := TMPTAB->DA1_CODPRO
			PA8->PA8_DESMP8 := TMPTAB->DA1_DESCRI
			PA8->PA8_CLAPRO := "CER"
			PA8->PA8_CATPRO := "01"
		PA8->(MsUnlock())
	Endif
	
	TMPTAB->(DbSkip())
Enddo

//Apaga os registros da Filial 01
cUpdate1 += " UPDATE DA1010 SET DA1_CODGAR = DA1_CODPRO, DA1_DESGAR = DA1_DESCRI "
cUpdate1 += " WHERE "
cUpdate1 += " D_E_L_E_T_ = ' ' AND "
cUpdate1 += " DA1_CODGAR = ' ' AND "
cUpdate1 += " DA1_ATIVO = '1' "
TCSqlExec(cUpdate1) 

//Se o primeiro não deu certo, avisa e finaliza.
if (TCSqlExec(cUpdate1) < 0)
	conout("Erro na atualizacao 1: " + TCSQLError())
Endif

RETURN