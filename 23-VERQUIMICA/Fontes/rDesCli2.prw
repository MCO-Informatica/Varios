#Include "Protheus.ch"          

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+-------------------+---------------------------------+------------------+||
||| Programa: rDesCli2| Autor: Celso Ferrone Martins    | Data: 10/03/2015 |||
||+-----------+-------+---------------------------------+------------------+||
||| Descricao | Retorna o nome do Cliente/Fornecedor                       |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |Replicado devido a problemas durante execução dos gatilhos. |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

User Function rDesCli2(lMemoria)

Local _cRet 		:= ""   
Local cC5Tipo    	:= ""                                             
Local cC5Cliente 	:= ""
Local cC5Loja    	:= "" 

Default lMemoria := .F.                             

If Type("lForn") == "L" .And. Inclui
	_cRet := Posicione("SA2",1,xFilial("SA2")+cValToChar(cFornece)+cValToChar(cLoja),"A2_NOME")
Else
	If lMemoria
		cC5Tipo    := M->C5_TIPO
		cC5Cliente := M->C5_CLIENTE
		cC5Loja    := M->C5_LOJACLI
	Else
		cC5Tipo    := SC5->C5_TIPO
		cC5Cliente := SC5->C5_CLIENTE
		cC5Loja    := SC5->C5_LOJACLI
	EndIf        
	
	If AllTrim(cC5Tipo) $ "D/B"
		_cRet := Posicione("SA2",1,xFilial("SA2")+cC5Cliente+cC5Loja,"A2_NOME")
	Else
		_cRet := Posicione("SA1",1,xFilial("SA1")+cC5Cliente+cC5Loja,"A1_NOME")
	EndIf
EndIf

Return(_cRet)