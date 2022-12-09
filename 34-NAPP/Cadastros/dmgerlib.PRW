#include "TOTVS.CH"

/*
  	PE após a inclusão do Cliente
*/
User Function M030INC()
/*
	Chamada a rotina de inclusão automática de Item Contábil
*/
//If PARAMIXB <> 3 // Cancelou a Inclusao
	If ExistBlock("DMCTBCTD")
		u_DMCTBCTD("C")
	EndIf
//EndIf
Return(Nil)
/*
	PE após a alteração do Cliente
*/
User Function MALTCLI()
/*
	Chamada a rotina de inclusão automática de Item Contábil
*/             

	If ExistBlock("DMCTBCTD")
		u_DMCTBCTD("C")
	EndIf

Return(Nil)
/*
	PE após a exclusão do Cliente
*/
User Function MALTEXC()
/*
	Chamada a rotina de exclusão automática de Item Contábil
*/

	if ExistBlock("DMCTBCTD")
		u_DMCTBCTD("C",.T.)
	EndIf

Return(Nil)
/*
  	PE após a inclusão do Fornecedor
*/
User Function M020INC()
	Local aArea := GetArea()
//Chamada a rotina de inclusão automática de Item Contábil
	If ExecBlock("DMCTBCTD")
		u_DMCTBCTD("F")
	EndIf
	RestArea(aArea)
Return(Nil)
/*
	PE após a alteração do Fornecedor
*/
User Function M020ALT()
	Local aArea := GetArea()

/*
	Chamada a rotina de inclusão automática de Item Contábil
*/
	If ExecBlock("DMCTBCTD")
		u_DMCTBCTD("F")
	EndIf

	RestArea(aArea)

Return(Nil)
/*
	Validação da exclusão do Fornecedor
*/                                     
User Function A020DELE()
	Local lRetor:=.T.
	If ExecBlock("DMCTBCTD")
		u_DMCTBCTD("F",.T.)
	EndIf
Return(lRetor)

/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Ponto de Entrada para selecionar filial das series das NF  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ Empresas que possuem varias filiais com serie iguais       ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
/*User Function CHGX5FIL()
Return(cFilAnt)*/
