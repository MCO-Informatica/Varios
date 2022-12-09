#Include "Protheus.ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: MT103COR  | Autor: Celso Ferrone Martins  | Data: 30/10/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | PE para alterar as cores do Browser da NF de entrada       |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

User Function MT103COR()

Local aNewCores := {}

AAdd(aNewCores,{ 'Empty(F1_STATUS) .And.(F1_STATCON == "1" .Or. Empty(F1_STATCON))','ENABLE'		})	// NF Nao Classificada
AAdd(aNewCores,{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="N" .AND. (F1_STATUS<>"B" .AND. F1_STATUS<>"C") .AND. AllTrim(F1_ESPECIE)!="CTE"', 'DISABLE'		})  // NF Normal
AAdd(aNewCores,{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="N" .AND. (F1_STATUS<>"B" .AND. F1_STATUS<>"C") .AND. AllTrim(F1_ESPECIE)=="CTE"', 'BR_BRANCO'	})  // NF de Compl. Preco/Frete
AAdd(aNewCores,{ 'F1_STATUS=="B"'													, 'BR_LARANJA'	})  // NF Bloqueada
AAdd(aNewCores,{ 'F1_STATUS=="C"'													, 'BR_VIOLETA'	})  // NF Bloqueada s/classf.
AAdd(aNewCores,{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="P"'	 	, 'BR_AZUL'		})  // NF de Compl. IPI
AAdd(aNewCores,{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="I"'	 	, 'BR_MARROM'	})  // NF de Compl. ICMS
AAdd(aNewCores,{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="C"'	 	, 'BR_PINK'		})  // NF de Compl. Preco/Frete
AAdd(aNewCores,{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="B"'	 	, 'BR_CINZA'	})  // NF de Beneficiamento
AAdd(aNewCores,{ '(F1_STATCON=="1" .OR. EMPTY(F1_STATCON)) .AND. F1_TIPO=="D"'    	, 'BR_AMARELO'	})  // NF de Devolucao
AAdd(aNewCores,{ 'F1_STATCON<>"1" .AND. !EMPTY(F1_STATCON)'							, 'BR_PRETO'	})  // NF Bloq. para Conferencia

Return(aNewCores)
