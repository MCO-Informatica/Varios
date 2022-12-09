#Include 'Protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFINV01A  ºAutor  ³Loop Consultoria     º Data ³  01/03/2018º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina que grava o Envio do Tempo de Relacionamento com o   º±±
±±º          ³cliente para o Serasa Relato                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Verquimica                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFINV01A(cCod,cLoja)	

Local aAreaAtu := GetArea()
Local aAreaSA1 := SA1->(GetArea())

If SA1->A1_XRELATO <> "1" //Enviado 1-SIM

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Registros de tempo de relacionamento: informar apenas quando encaminhar informações            ³
	//³  do CNPJ pela primeira vez.                                                                    ³
	//³ Marcar em seu sistema os CNPJs que já tiveram essa informação enviada para Serasa Experian.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	RecLock("SA1",.F.)
	
	SA1->A1_XRELATO := "1"  //Enviado 1-SIM 
	SA1->A1_XDTENV  := Date()
	SA1->A1_XUSRENV := UsrRetName(RetCodUsr())
	
	MsUnlock()

EndIf

RestArea(aAreaAtu)
RestArea(aAreaSA1)
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFINV01B ºAutor  ³Loop Consultoria     º Data ³  05/04/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina que grava o Envio do Status do Relato no Título      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Verquimica                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFINV01B(_nRecSE1)

Local cDtEnv	:= DtoS(Date())
Local cUsrEnv	:= UsrRetName(RetCodUsr())
Local cValRet	:= 0

//Gravando o Envio do Título para o Serasa Relato
If Empty(SE1->E1_XRELATO) .OR. SE1->E1_XRELATO == "2" 
	
	cUpd := " UPDATE " + RetSqlName("SE1")
	cUpd += " SET 	E1_XRELATO = '1', "
	cUpd += " 	 	E1_XDTENV  = '"	+ cDtEnv + "', "
	cUpd += "       E1_XUSRENV = '"	+ cUsrEnv + "' "
	cUpd += " WHERE R_E_C_N_O_ = '" + cValToChar(_nRecSE1) + "' "
	cUpd += " AND D_E_L_E_T_ = ' '"
		
	TCSQLEXEC(cUpd)
	
	cValRet := SE1->E1_VALOR*100
			
//Gravando a Exclusão do Título no Serasa Relato
ElseIf SE1->E1_XRELATO == "1" .AND. E1_XSOLEXL == "1"

	cUpd := " UPDATE " + RetSqlName("SE1")
	cUpd += " SET 	E1_XDTEXCL = '"	+ cDtEnv + "', " 	 	
	cUpd += "       E1_XUSREXC = '"	+ cUsrEnv + "' "
	cUpd += " WHERE R_E_C_N_O_ = '" + cValToChar(_nRecSE1) + "' "
	cUpd += " AND D_E_L_E_T_ = ' '"
	
	TCSQLEXEC(cUpd)
	
	cValRet	:= 9999999999999
Else
	cValRet := SE1->E1_VALOR*100
EndIf

Return cValRet