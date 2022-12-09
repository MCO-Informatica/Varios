/*
------------------------------------------------------------------------------
Programa : MTA650I			| Tipo: Ponto de Entrada		| Rotina: MATA650
Data     : 03/11/08         | Na geracao de OP 
------------------------------------------------------------------------------
Descricao: Complementar a gravacao do SC2 quando usar opcao VENDAS
------------------------------------------------------------------------------*/
User Function MTA650I()
Local _aArea := GetArea()
 
If !INCLUI
	SC2->C2_CLIENTE := SC6->C6_CLI	//IF(EMPTY(SB1->B1_LCODCLI),SC5->C5_CLIENTE,SB1->B1_LCODCLI)
	SC2->C2_LOJA    := SC6->C6_LOJA	//IF(EMPTY(SB1->B1_LCODCLI),SC5->C5_LOJACLI,SB1->B1_LCODCLI)
	SC2->C2_CICLO   := SB1->B1_LCICLO    
	SC2->C2_CAVIDAD := SB1->B1_LCAV	
	SC2->C2_UTILIZA := SB1->B1_LUTILI		
	SC2->C2_MAQUINA := SB1->B1_LMAQ		
	SC2->C2_DESCPRO := SB1->B1_DESC		
	SC2->C2_COR     := Alltrim(TABELA("EE",SB1->B1_CORPRI,.F.))		//C 25
	SC2->C2_MOLDE   := VAL(ALLTRIM(SB1->B1_MOLDE))	//N 5      TEM Q ALTERAR O SB1!!
	SC2->C2_PESO    := SB1->B1_PESBRU		//N14,8
	SC2->C2_TEMPOES := SB1->B1_LTEMPO		//N 2
	SC2->C2_TEMPOTE := SB1->B1_LTEMPER		//N 3    
	SC2->C2_CODCLI  := SB1->B1_LCODCLI          
	SC2->C2_DESCCLI := POSICIONE("SA1",1,XFILIAL("SA1")+SC6->C6_CLI+SC6->C6_LOJA,"A1_NOME")
	 
	SC2->C2_OBS     := "TESTE OP P/VENDAS"
Else
//  Quando for necessario Atualizar campos especificos na inclusao de OP MANUAL	
//	RecLock("SC2",.F.)
//	SC2->C2_OBS     := "TESTE OP MANUAL"
//	MsUnlock()
EndIf	
RestArea(_aArea)
Return  