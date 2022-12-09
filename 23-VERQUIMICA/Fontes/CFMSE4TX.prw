#Include "Protheus.Ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: CFMSE4TX   | Autor: Celso Ferrone Martins | Data: 25/11/2014 |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao | Taxa da condicao de pagamento                              |||
||+-----------+------------------------------------------------------------+||
||| Alterado Por: | Danilo Alves Del Busso				| Data: 30/07/2015 |||
||+-----------+------------------------------------------------------------+||
||| Descrição:| Ajustado o código fonte para calcular os juros simples e   |||
|| compostos para o prazo de 30, 35, 60 e 90 dias com base nas porcentagens|||
|| registradas e armazenadas na SX6                                        |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

User Function CFMSE4TX()

Local lRet      := .T.
Local nRet      := 0
Local aCondPgt  := {}
Local nTxJurFin := 0.00 
Local nQtdDiaPd := 30  // Quantidade de Dias Referencial Financeiro Padrão
Local QtdDias   := 0
Local nIndCorre := 0    // Índice de Correção
Local nJurosSe4 := 0

If AllTrim(M->E4_TIPO) == "1" .And. !Empty(M->E4_COND)
	aCondPgt := &("{"+AllTrim(M->E4_COND)+"}")
	If Len(aCondPgt) > 0
		For nX := 1 To Len(aCondPgt)   
			QtdDias += aCondPgt[nX]
		Next nX
		QtdDias := Round(QtdDias / Len(aCondPgt),0)
		IF QtdDias <= 30    
			nTxJurFin = GetMV("VQ_TJUR30") / 100
			nIndCorre :=  1 + (nTxJurFin / nQtdDiaPd)  * QtdDias  
		ElseIF QtdDias > 30 .AND. QtdDias <=35
			nTxJurFin = GetMV("VQ_TJUR30") / 100    
			nIndCorre := ( (1+nTxJurFin)^(1/nQtdDiaPd) )^QtdDias
		ElseIF QtdDias > 35 .AND. QtdDias <= 60     
	   		nTxJurFin = GetMV("VQ_TJUR60") / 100
			nIndCorre := ( (1+nTxJurFin)^(1/nQtdDiaPd) )^QtdDias
		Else            
			nTxJurFin = GetMV("VQ_TJUR90") / 100
			nIndCorre := ( (1+nTxJurFin)^(1/nQtdDiaPd) )^QtdDias
		EndIf
		nJurosSe4 := (nIndCorre-1)*100
		M->E4_VQ_INDI := nIndCorre
	EndIf
EndIf

Return(lRet)