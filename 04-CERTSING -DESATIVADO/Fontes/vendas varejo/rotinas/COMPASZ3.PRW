#include "totvs.ch"

USER FUNCTION COMPASZ3()

Local cUpdate1 := ""

//Abre a conexão com a empresa
RpcSetType(3)
RpcSetEnv("01","02")

CONOUT("INICIANDO ATUALIZACAO COMPASZ3!")


// CAMPOS QUE SERÃO ALTERADO NA DESCRICAO
// PA8_CODMP8 - De: Produto Totvs - Para: Produto
DbSelectArea("SX3")
DbSetOrder(2)
If DbSeek("Z3_ESTADO")
	
	RecLock("SX3",.F.)
		SX3->X3_VISUAL := "A"
		SX3->X3_F3  	 := "12" 
	SX3->(MsUnlock())

EndIf 

//Apaga os registros da Filial 01
cUpdate1 += " UPDATE SZ3010 SET Z3_ESTADO = ' ' "
cUpdate1 += " WHERE "
cUpdate1 += " Z3_FILIAL = ' ' AND "
cUpdate1 += " Z3_TIPENT = '5' AND "
cUpdate1 += " Z3_ESTADO > ' ' AND "
cUpdate1 += " D_E_L_E_T_ = ' ' "

//Se o primeiro não deu certo, avisa e finaliza.
if (TCSqlExec(cUpdate1) < 0)
	conout("Erro na atualizacao 1: " + TCSQLError())
Endif

CONOUT("ATUALIZACAO COMPASZ3 FINALIZADA!")

RETURN