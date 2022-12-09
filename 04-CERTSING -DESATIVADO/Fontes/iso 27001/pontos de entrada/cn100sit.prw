#Include "Totvs.ch"

#DEFINE DEF_SCANC '01' //Cancelado
#DEFINE DEF_SELAB '02' //Em Elabora��o
#DEFINE DEF_SEMIT '03' //Emitido
#DEFINE DEF_SAPRO '04' //Em Aprova��o
#DEFINE DEF_SVIGE '05' //Vigente
#DEFINE DEF_SPARA '06' //Paralisado
#DEFINE DEF_SSPAR '07' //Sol Fina.
#DEFINE DEF_SFINA '08' //Finalizado
#DEFINE DEF_SREVS '09' //Revis�o
#DEFINE DEF_SREVD '10'//Revisado

//-----------------------------------------------------------------------
// Rotina | CN100SIT  | Autor | Rafael Beghini    | Data | 15.07.2016
//-----------------------------------------------------------------------
// Descr. | PE - Respons�vel pelo controle de situa��es do contrato. 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function CN100SIT( uAtual, uDestino )
	Local cAtu      := ""
	Local cDst      := ""
	Local cStatAtu  := ""
	Local cStatAnt  := ""
	Local cDest 	 := ""
	Local cRemet	 := ""
	Local cAssunto	 := ""
	Local cMensagem := ""
	Local lReenvio  := .F.
	Local cNomeEnt  := ""
	Local cMV_650PROC := 'MV_650PROC'
	
	If Type("ParamIXB") == "A"
		cAtu := ParamIXB[1]
		cDst := ParamIXB[2]
	Else
		If ValType( uAtual ) == "C"
			cAtu := uAtual
		Endif
		If ValType( uDestino ) == "C"
			cDst := uDestino
		Endif
	Endif
	
	IF Empty( CN9->CN9_NOTVEN )
		MsgInfo('Necess�rio informar o destinat�rio.')
		U_CSGCT040(1)
	EndIF
	
	//Situa��o atual do contrato
	IF     cAtu == DEF_SCANC ; cStatAnt := "Cancelado"
	ElseIF cAtu == DEF_SELAB ; cStatAnt := "Em Elabora��o"
	ElseIF cAtu == DEF_SEMIT ; cStatAnt := "Emitido"
	ElseIF cAtu == DEF_SAPRO ; cStatAnt := "Em Aprova��o"
	ElseIF cAtu == DEF_SVIGE ; cStatAnt := "Vigente"
	ElseIF cAtu == DEF_SPARA ; cStatAnt := "Paralisado"
	ElseIF cAtu == DEF_SSPAR ; cStatAnt := "Sol.Finaliza��o"
	ElseIF cAtu == DEF_SFINA ; cStatAnt := "Finalizado"
	ElseIF cAtu == DEF_SREVS ; cStatAnt := "Revis�o"
	ElseIF cAtu == DEF_SREVD ; cStatAnt := "Revisado"
	EndIF
	
	//Nova situa��o do contrato
	IF  cDst == DEF_SCANC 
		cStatAtu := "Cancelado"
	ElseIF cDst == DEF_SELAB 
		cStatAtu := "Em Elabora��o"
	ElseIF cDst == DEF_SEMIT 
		cStatAtu := "Emitido"
	ElseIF cDst == DEF_SAPRO 
		cStatAtu := "Em Aprova��o"  
		IF CN9->CN9_FLGCAU == '1'
			cStatAtu := "Em Aprova��o para Cau��o"
			IF GetMv( cMV_650PROC, .F. ) == '1' //Par�metro habilitado para envio de e-mail
				U_A650SCau()
			EndIF 
		EndIF
	ElseIF cDst == DEF_SVIGE 
		cStatAtu := "Vigente" 
		If CN9->CN9_OKAY == '1' //.AND. cAtu == DEF_SELAB
			cStatAtu := "Em aprova��o via workflow"
		Endif 
	ElseIF cDst == DEF_SPARA 
		cStatAtu := "Paralisado"
	ElseIF cDst == DEF_SSPAR 
		cStatAtu := "Sol.Finaliza��o"
	ElseIF cDst == DEF_SFINA 
		cStatAtu := "Finalizado"
	ElseIF cDst == DEF_SREVS 
		cStatAtu := "Revis�o"
	ElseIF cDst == DEF_SREVD 
		cStatAtu := "Revisado"
	EndIF
	
	// Se mudar a situa��o para 
	// DEF_SCANC '01' Cancelado | DEF_SSPAR '07' Sol Fina. | DEF_SFINA '08' Finalizado
	If cDst == DEF_SCANC .OR. cDst == DEF_SSPAR .OR. cDst == DEF_SFINA
		U_A650Motivo()
	Endif
	
	If cDst == DEF_SAPRO .OR. cDst == DEF_SVIGE
		Begin Transaction 
			U_A650WFAp( cDst, lReenvio )
		End Transaction 
	EndIF
	
	IF GetMv( cMV_650PROC, .F. ) == '1' //Par�metro habilitado para envio de e-mail
		//Rotina que envia e-mail sobre situa��o de contratos
		U_A650Sit( cStatAnt, cStatAtu )
	EndIF
	
Return