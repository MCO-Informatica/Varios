#include 'protheus.ch'
#include 'parmtype.ch'

//---------------------------------------------------------------------------------------------------------------
//Autor: Washington Caetano Rodrigues - Libert Solutions (62) 99125-7195 washington@libertsolutions.com.br
//Data: 31/07/2020
//Função: PRZCTB.PRW
//Descrição: Rotina para retornar a conta contabil
//pTipo = "C" Contabiliza conta crédito
//pTipo = "D" Contabiliza conta débito
/*
### Verbas
Conta Crédito 			- RV_XCTAC
Conta Débito 			- RV_XCTAD
Conta Crédito Produtiva - RV_XPCTAC
Conta Débito Produtiva 	- RV_XPCTAD

### Centro de Custo
Produto (Sim ou Não)	- CTT_XPROD
Conta Crédito 			- CTT_XCTAC
Conta Débito 			- CTT_XCTAD
*/
//---------------------------------------------------------------------------------------------------------------
user function PRZCTB(pTipo)
	local pConta := ""

	DbSelectArea("SRV")
	DbSetOrder(1)
	DbSeek(xFilial("SRV")+SRZ->RZ_PD)

	DbSelectArea("CTT")
	DbSetOrder(1)
	DbSeek(xFilial("CTT")+SRZ->RZ_CC)

	//Regra conta crédito
	if(pTipo == "C")
		//Quando é verda do tipo 2(desconto) o sistema inverte as contas contábeis
		if(SRV->RV_TIPOCOD == "2")//Contabiliza verba de desconto
			if(CTT->CTT_XPROD == "S")
				//if(!empty(SRV->RV_XPCTAD))
				//	pConta := SRV->RV_XPCTAD//Pega conta contábil produtiva
				if(!empty(SRV->RV_XPCTAC))
					pConta := SRV->RV_XPCTAC//Pega conta contábil produtiva
				else
					pConta := CTT->CTT_XCTAD
				endif
			ELSE
				//if(!empty(SRV->RV_XCTAD))
				//	pConta := SRV->RV_XCTAD
				if(!empty(SRV->RV_XCTAC))
					pConta := SRV->RV_XCTAC					
				else
					pConta := CTT->CTT_XCTAD
				endif
			ENDIF
		else
			//Valida se centro de custo produtivo
			if(CTT->CTT_XPROD == "S")
				if(!empty(SRV->RV_XPCTAC))
					pConta := SRV->RV_XPCTAC//Pega conta contábil produtiva
				else
					pConta := CTT->CTT_XCTAC
				endif
			ELSE
				if(!empty(SRV->RV_XPCTAC))
					pConta := SRV->RV_XCTAC
				else
					pConta := CTT->CTT_XCTAC
				endif
			ENDIF
		endif
	else//Retorna conta débito
		//Quando é verda do tipo 2(desconto) o sistema inverte as contas contábeis
		if(SRV->RV_TIPOCOD == "2")//Contabiliza verba de desconto
			if(CTT->CTT_XPROD == "S")
				//if(!empty(SRV->RV_XPCTAC))
				//	pConta := SRV->RV_XPCTAC//Pega conta contábil produtiva
				if(!empty(SRV->RV_XPCTAD))
					pConta := SRV->RV_XPCTAD//Pega conta contábil produtiva
				else
					pConta := CTT->CTT_XCTAC
				endif
			ELSE
				//if(!empty(SRV->RV_XCTAC))
				//	pConta := SRV->RV_XCTAC
				if(!empty(SRV->RV_XCTAD))
					pConta := SRV->RV_XCTAD
				else
					//pConta := SRV->RV_XPCTAC
					pConta := CTT->CTT_XCTAC
				endif
			ENDIF
		else
			//Valida se centro de custo produtivo
			if(CTT->CTT_XPROD == "S")
				if(!empty(SRV->RV_XPCTAD))
					pConta := SRV->RV_XPCTAD//Pega conta contábil produtiva
				else
					pConta := CTT->CTT_XCTAD
				endif
			ELSE
				if(!empty(SRV->RV_XCTAC))
					pConta := SRV->RV_XCTAD
				else
					//pConta := SRV->RV_XCTAD
					pConta := CTT->CTT_XCTAD
				endif
			ENDIF
		endif
	endif
return pConta
 