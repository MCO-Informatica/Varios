#Include 'Protheus.ch'

/*
Autor: Wellington Mendes

Função que retorna a coluna motivo de baixa
nos relatórios titulos com retenção de impostos e retenção de impostos
15/09/2017
Uso: Exlusivo Renova Energia.

*/

User Function RENMOTBX()


Local _lRetMotbx
aAreaSE5  	:= SE5->(GetArea())

If IsincallStack("FINR855")  //Titulos a pagar com retenção de Impostos
	DbSelectArea("SE5")
	DbSetOrder(7)
	SE5->(MsSeek(xFilial("SE5")+TR1->(PREFIXO+NUM+PARCELA+TIPO+CODIGO+LOJA)))
	WHILE SE5->(!EOF()) .And. SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)== TR1->(PREFIXO+NUM+PARCELA+TIPO+CODIGO+LOJA)
		//	If(dbSeek(xFilial()+TR1->(PREFIXO+NUM+PARCELA+TIPO+CODIGO+LOJA)))
		If Alltrim(SE5->E5_MOTBX) <> 'PCC'
			_lRetMotbx := ALLTRIM(SE5->E5_MOTBX)
		Endif
		SE5->(dbSkip())
	Enddo
	

ElseIf IsincallStack("FINR865") // Retenção de Impostos.
	
	DbSelectArea("SE5")
	DbSetOrder(7)
	SE5->(MsSeek(xFilial("SE5")+TRB->(PREFIXO+NUM+PARCELA+TIPO+CODIGO+LOJA)))
	WHILE SE5->(!EOF()) .And. SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)== TRB->(PREFIXO+NUM+PARCELA+TIPO+CODIGO+LOJA)
		//If(dbSeek(xFilial()+TRB->(PREFIXO+NUM+PARCELA+TIPO+CODIGO+LOJA)))
		If Alltrim(SE5->E5_MOTBX) <> 'PCC'
			_lRetMotbx := ALLTRIM(SE5->E5_MOTBX)
		Endif
		SE5->(dbSkip())
	Enddo
	
Else
	
	Return()
	
Endif
RestArea(aAreaSE5)
Return(_lRetMotbx)
