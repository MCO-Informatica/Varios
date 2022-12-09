/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºArquivo   ³AFU       ºAutor  ³Cosme da Silva Nunesº Data ³  /  /2007   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Arquivo de Funcoes de usuario                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

/*
VERIFICA O COD. DA FORMA DE PAGAMENTO
------------------------------------------------------------------------------
FORMAS DE PAGAMENTO TRATADAS PELO BANCO REAL:
------------------------------------------------------------------------------
'1' - CHEQUE ADM OBR
------------------------------------------------------------------------------
'2' - CREDITO EM CONTA
------------------------------------------------------------------------------
'3' – CARTÃO SALÁRIO ELETRÔNICO
------------------------------------------------------------------------------
'4' – DOC / TED (obrigatório preencher cod.camara centralizadora)
------------------------------------------------------------------------------
'5' - RECIBO
------------------------------------------------------------------------------
'6' - CAIXA / TIT. COBRANCA (registro tipo '4').
------------------------------------------------------------------------------
‘7’ - NÃO DEFINIDA (A utilização desta forma depende de negociação prévia)    
------------------------------------------------------------------------------
*/
User Function RCFPgto()

Local ucCFPgto := ""
Local aAreaAtu := GetArea()
Local aAreaSEA := SEA->( GetArea() )
/*
Conforme tabela acima do banco Real, item 1 ate item 7, 
para modelo do bordero (SEA->EA_MODELO $ conteudo da tabela 58),
variavel com codigo da forma de pagamento (ucCFPgto) recebe seu respectivo item.*/
If SEA->EA_MODELO == "02"
	ucCFPgto := "1" //CHEQUE ADM OBR
ElseIf SEA->EA_MODELO == "01"
	ucCFPgto := "2" //CREDITO EM CONTA
ElseIf SEA->EA_MODELO == GetMV("MV_MPCSE") //MODALIDADE DE PAGTO P/ CARTÃO SALÁRIO ELETRÔNICO
	ucCFPgto := "3" //CARTÃO SALÁRIO ELETRÔNICO
ElseIf SEA->EA_MODELO == "03" .Or. SEA->EA_MODELO == "41" .Or. SEA->EA_MODELO == "43"
	ucCFPgto := "4" //DOC / TED (obrigatório preencher cod.camara centralizadora)
ElseIf SEA->EA_MODELO == GetMV("MV_MPREC") //MODALIDADE DE PAGTO P/ RECIBO
	ucCFPgto := "5" //RECIBO
ElseIf SEA->EA_MODELO == "30" .Or. SEA->EA_MODELO == "31" .Or. SEA->EA_MODELO == GetMV("MV_MPCTC") //MODALIDADE DE PAGTO P/ CAIXA / TIT. COBRANCA
	ucCFPgto := "6" //CAIXA/TIT. COBRANCA (para pagamento de titulo de cobrança é  necessario enviar o registro tipo '4').
ElseIf SEA->EA_MODELO == GetMV("MV_MPND") //MODALIDADE DE PAGTO NAO DEFINIDA
	ucCFPgto := "7" //NÃO DEFINIDA (A utilização desta forma depende de negociação
EndIf

RestArea(aAreaSEA)
RestArea(aAreaAtu)

Return(ucCFPgto)



/*
RETORNA O CODIGO DE INSCRICAO DO SACADO
*/
User Function CodInsSac()

Local ucCIS := ""

If Len(AllTrim(SA1->A1_CGC)) < 14
	ucCIS := SubStr(AllTrim(SA1->A1_CGC),1,9) + "000" + Right(AllTrim(SA1->A1_CGC),2)
Else
	ucCIS := SubStr(AllTrim(SA1->A1_CGC),1,14)
EndIf

Return(ucCIS)



/*
RETORNA O NUMERO DA CONTA DO FORNECEDOR
IF(SEA->EA_MODELO $ "01/02/03/05/41/43" .OR. SEA->EA_MODELO == GETMV("MV_MPCSE"),STRZERO(VAL(STUFF(SA2->A2_NUMCON,AT("-",SA2->A2_NUMCON),1,"")),10),"")
*/
User Function NroCtaFor()

Local ucCtacDig := ""
Local ucCta     := ""
Local ucNCF     := ""

If SEA->EA_MODELO $"01/02/03/05/41/43" .OR. SEA->EA_MODELO==GETMV("MV_MPCSE")
	
	If !Empty(SA2->A2_BANCO) .And. SA2->A2_BANCO<>"257" .AND. SA2->A2_BANCO<>"356" //NAO EH BCO REAL
		ucNCF := StrZero(Val(Stuff(SA2->A2_NUMCON,At("-",SA2->A2_NUMCON),1,"")),10)
	ElseIf !Empty(SA2->A2_BANCO)//BCO REAL
		ucCtacDig := Stuff(SA2->A2_NUMCON,At("-",SA2->A2_NUMCON),1,"")
		unCDTam   := Len(AllTrim(ucCtacDig))-1
		ucCta     := SubStr(ucCtacDig,1,unCDTam)
		ucNCF     := StrZero(Val(ucCta),10)	
	Else
		ucNCF := ""
	EndIf

EndIf

Return(ucNCF)