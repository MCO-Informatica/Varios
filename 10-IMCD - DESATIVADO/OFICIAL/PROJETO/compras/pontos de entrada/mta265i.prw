#include "PROTHEUS.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTGRVLOT  ºAutor  ³  LUIZ OLIVEIRA      º Data ³  02/02/2015º±±
*/
User Function MTA265I()
	Local nLinha := ParamIxb[1]// Atualização de arquivos ou campos do usuário após a Inclusão da Distribuição do Produto      

	if SB8->(!eof())

		if Empty(SB8->B8_DFABRIC)
			RecLock("SB8",.F.)
			SB8->B8_DFABRIC := SD1->D1_DFABRIC   
			msUnlock()
		endif
	endif

Return Nil
