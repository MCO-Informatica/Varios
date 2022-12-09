#Include 'Protheus.ch'
//+-------------------------------------------------------------------+
//| Rotina | CSGCT080 | Autor | Rafael Beghini | Data | 26.02.2018 
//+-------------------------------------------------------------------+
//| Descr. | Manuten��es espec�ficas de Contratos
//|        | Chamado no PE CTA100MNU
//+-------------------------------------------------------------------+
//| Uso    | Certisign Certificadora Digital
//+-------------------------------------------------------------------+
//| Alter. | 20/10/2020 | Luciano Alves de Oliveira
//+-------------------------------------------------------------------+
//| Motivo | Inclus�o de mais uma rotina no array do aOPC, item 15 
//|        | Fun��o u_CSGCT006
//+-------------------------------------------------------------------+
User Function CSGCT080()
	Local aRET	:= {}
	Local aPAR	:= {}
	Local aOPC	:= {}
	Local aXop	:= {}
	Local lUsr	:= .F.
	
	Local cMV_670USER := 'MV_670USER'
	
	If .NOT. GetMv( cMV_670USER, .T. )
		CriarSX6( cMV_670USER, 'C', 'CODIGO DE USUARIOS AUTORIZADO FAZER ALTERACAO ESPECIFICA EM CONTRATOS. CSFA670.prw', '000908' )
	Endif
	
	cMV_670USER := GetMv( cMV_670USER, .F. )
	
	lUsr := RetCodUsr() $ cMV_670USER
	aAdd( aOPC, 'ISO27001')
	
	aAdd( aOPC, 'Status de aprova��o')
	aAdd( aOPC, 'Aprovar legado')
	aAdd( aOPC, 'Aprovar contrato')
	aAdd( aOPC, 'Reenviar WF aprova��o')
	
	aAdd( aOPC, 'Modificar data')
	aAdd( aOPC, 'Modificar vig�ncia')
	aAdd( aOPC, 'Data anivers�rio')
	aAdd( aOPC, 'Tipo Renova��o')
	aAdd( aOPC, 'Reajuste/Indice')
	aAdd( aOPC, 'Notifica��o eMails')
	aAdd( aOPC, 'Notifica��o usu�rios')
	aAdd( aOPC, 'Assinantes do Contrato')
	aAdd( aOPC, '�rea respons�vel')
	aAdd( aOPC, 'Alterar Situa��o para Vigente')
	
	aAdd(aPAR,{9,"Selecione a op��o desejada",150,7,.T.})
	
	aAdd(aPAR,{3,"Op��es",Len(aOPC),aOPC,100,"",.F.})
	
	
	If ParamBox(aPAR,"Manuten��es espec�ficas",@aRET)
   		IF aRET[2] == 1
   			U_CSISO27M1()	
   		ElseIF aRET[2] == 2
   			U_A650STAP()
   		ElseIF aRET[2] == 3
   			U_CSFA640()
   		ElseIF aRET[2] == 4
   			U_A650APROV()
   		ElseIF aRET[2] == 5
   			U_A650APMNU()
   		ElseIF aRET[2] == 6
   			U_A670MNCP( IIF(lUsr,1,0) )
   		ElseIF aRET[2] == 7
   			U_A670VIGE( IIF(lUsr,1,0) )
   		ElseIF aRET[2] == 8
   			U_A670ANIV( IIF(lUsr,1,0) )
   		ElseIF aRET[2] == 9
   			U_A670RENO( IIF(lUsr,1,0) )
   		ElseIF aRET[2] == 10
   			U_A670REAJ( IIF(lUsr,1,0) )
   		ElseIF aRET[2] == 11
			U_CSGCT040(1)
		ElseIF aRET[2] == 12
			U_CSGCT090()
		ElseIF aRET[2] == 13
			U_CSCTA100(1)
		ElseIF aRET[2] == 14
			U_CSCTA100(2)
		ElseIF aRet[2] == 15
			U_CSGCT006()
		EndIF
		
   	Else
   		MsgInfo('Op��o cancelada','[CSGCT080/CTA100MNU]')
   	Endif
	
Return
