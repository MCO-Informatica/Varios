#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"      


//-----------------------------------------------------------------------
/*/{Protheus.doc} csReenvEmail
Funcao responsavel por Reenviar e-mail para o Cliente com o Link
do ShopLine (Boleto Registrado).


@author	Douglas Parreja
@since	21/12/2016
@version 11.8
/*/
//-----------------------------------------------------------------------
user function csReenvEmail( nRecno, oBrowse )

	local cOServ		:= ""
	local cEmail		:= ""
	local cLink			:= ""   
	local cDataInc		:= ""  
	local cRetEmail		:= ""  
	local cCopiaOculta	:= ""
	local cAssuntoEm 	:= "Solicitação de validação em domicílio - Reenvio do boleto para pagamento" //"Solicitação de atendimento - Reenvio do boleto por E-mail"
	local cCase			:= "REENVIO"
	local REENVIADO		:=  "2"
	local lErro			:= .F.  
	local aEmail		:= {}
	
	default nRecno 	:= 0
	default oBrowse	:= nil
	
	if nRecno > 0 
		if msgYesNo( "Deseja realizar o Reenvio do e-mail ?", "Reenvio de e-mail" )
			if csValidTabela()
								
				cOServ := iif( !empty(PA0->PA0_OS), alltrim(PA0->PA0_OS), "" )
				
				if u_csPodeEnviarEmail(cOServ)
				
					cEmail 		:= iif( !empty(PA0->PA0_EMAIL)	, alltrim(PA0->PA0_EMAIL)	, "" )
					aEmail		:= csTelaReenvEmail( cEmail )
					cRetEmail	:= iif( len(aEmail) > 0, alltrim(aEmail[1]), ""  )
					cCopiaOculta:= iif( len(aEmail[1]) > 0, alltrim(aEmail[2]), "" )
					cLink		:= iif( !empty(PA0->PA0_LINK) 	, alltrim(PA0->PA0_LINK) 	, "" )
					cDataInc	:= iif( !empty(PA0->PA0_DTINC)	, alltrim(PA0->PA0_DTINC) 	, "" )
					
					if ( !empty( cOServ ) .and. !empty( cEmail ) .and. !empty( cLink ) )
					
						if u_CSFSEmail( cOServ, cLink, cEmail+";"+alltrim(cRetEmail), cAssuntoEm, cCase, lErro, cCopiaOculta)
							reclock("PA0", .F. )
							PA0->PA0_STMAIL := REENVIADO
							Aviso( "Solicitação de Atendimento", "Reenviado e-mail com sucesso", {"Ok"} )							
						else
							Aviso( "Solicitação de Atendimento", "Falha ao Reenviar o e-mail.", {"Ok"} )							
						endif
					else
						if ( empty( cOServ ) .and. !empty( cEmail ) .and. !empty( cLink ) )                                                                                        
							Aviso( "Solicitação de Atendimento", "Falha ao Reenviar o e-mail. Ordem de Serviço não consta Preenchido.", {"Ok"} )	 
						elseif ( !empty( cOServ ) .and. empty( cEmail ) .and. !empty( cLink ) )                                                                                        
							Aviso( "Solicitação de Atendimento", "Falha ao Reenviar o e-mail. E-mail não consta Preenchido.", {"Ok"} )
						elseif ( empty( cOServ ) .and. !empty( cEmail ) .and. empty( cLink ) )                        
							if cDataInc < "21/12/2016"                                                                  
								Aviso( "Solicitação de Atendimento", "Falha ao Reenviar o e-mail. Não consta Link ShopLine Preenchido.", {"Ok"} )						
							endif
						else
							Aviso( "Solicitação de Atendimento", "Falha ao Reenviar o e-mail.", {"Ok"} )							
						endif
					endif	
				else
					Aviso( "Solicitação de Atendimento", "Não é possível enviar e-mail, devido que no campo 'FATURA' em nenhum item possui a informação igual a SIM.", {"Ok"} )
				endif		
			endif	
		endif
	endif
		
	if type("oBrowse") <> nil
		oBrowse:Refresh()
	endif

return

//-------------------------------------------------------------------
/*/{Protheus.doc} csValidTabela
Funcao responsavel por verificar se as tabelas estao em uso, caso
nao esteja, realizo a abertura das mesmas.

@return 	lRet	Retorna se as tabelas estao prontas para uso.

@author  Douglas Parreja
@since   21/12/2016
@version 11.8
/*/
//-------------------------------------------------------------------
static function csValidTabela()

	local lRet	:= .F.
	local lRet1	:= .F.
	local lRet2	:= .F.
	
	if select("PA0") > 0 
		lRet1 := .T.
	else
		dbSelectArea("PA0")
		if select("PA0") > 0 
			lRet1 := .T.
		endif 		
	endif
	if select("PA1") > 0 
		lRet2 := .T.
	else
		dbSelectArea("PA1")
		if select("PA1") > 0 
			lRet2 := .T.
		endif 		
	endif
	if lRet1 .and. lRet2
		lRet := .T.
	endif
	
return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} csTelaReenvEmail
Funcao responsavel por exibir a tela com o email enviado e obtendo 
a opcao de informar outro e-mail para envio para o cliente para 
caso o mesmo nao tenha recebido.
                                              
@param		cEmailEnv		e-mail enviado
@return 	cEmail			e-mail a ser reenviado

@author  Douglas Parreja
@since   28/12/2016
@version 11.8
/*/
//-------------------------------------------------------------------
static function csTelaReenvEmail( cEmailEnv )
	
	local _aAreaPV1 	:= GetArea()
	local lRet 			:= .F.  
	local cEmail		:= ""
	local cRet			:= ""
	local cEmail2		:= space(100)  
	local cEmail3		:= space(100)  
	default cEmailEnv 	:= ""
	
	private oDlg1                    
	
	DEFINE MSDIALOG oDlg1 TITLE OemToAnsi( 'Agendamento Externo - Reenvio de E-mail' ) OF oMainWnd FROM 00,00 TO 215,700 PIXEL
	@ 006,003 SAY OemToAnsi( 'Processo para o reenvio de E-mail para o Cliente, neste cenário é possível reenviar para o mesmo ou outro e-mail.' ) OF oDlg1 PIXEL
	@ 026,003 SAY OemToAnsi( 'E-mail enviado:' ) OF oDlg1 PIXEL	
	@ 024,042 MSGET cEmailEnv OF oDlg1 PIXEL SIZE 300,10 WHEN .F. 
	@ 046,003 SAY OemToAnsi( 'E-mail adiconal:' ) OF oDlg1 PIXEL 
	@ 044,042 MSGET cEmail2 OF oDlg1 PIXEL SIZE 300,10 WHEN .T.
	@ 066,003 SAY OemToAnsi( 'Cópia Oculta:' ) OF oDlg1 PIXEL 
	@ 064,042 MSGET cEmail3 OF oDlg1 PIXEL SIZE 300,10 WHEN .T.
	@ 086,010 BUTTON "&Confirma" SIZE 30,12 PIXEL OF oDlg1 ACTION  iif( csValid(cEmailEnv, @cEmail2),oDlg1:End(),NIL )
	@ 086,052 BUTTON "&Cancela"  SIZE 30,12 PIXEL OF oDlg1 ACTION oDlg1:End()	
	Activate msDialog oDlg1 Center
	
	cEmail2 := iif( !empty(cEmail2), alltrim(cEmail2), "") 
	cEmail3 := iif( !empty(cEmail3), alltrim(cEmail3), "") 
	
return {cEmail2,cEmail3}

//-------------------------------------------------------------------
/*/{Protheus.doc} csValid
Funcao responsavel por exibir ao usuario se estah correto o e-mail
digitado.
                                              
@param		cDados1	   		e-mail enviado
@return 	cDados2			e-mail a ser reenviado

@author  Douglas Parreja
@since   28/12/2016
@version 11.8
/*/
//-------------------------------------------------------------------
static function csValid( cDados1, cDados2 )

	local cRet		:= ""
	local lRet		:= .F.
	default cDados1	:= ""
	default cDados2	:= ""
	                     
	if !empty( cDados2 )
		if msgYesNo( "Deseja seguir com reenvio ? " + Chr(13) + Chr(10) + Chr(13) + Chr(10) + "E-mail digitado: "+alltrim(cDados2), "Reenvio de e-mail" )
			lRet := .T.
		else
			lRet := .F. 
		endif
	else
		lRet := .T.
	endif
	
return lRet 

//-------------------------------------------------------------------
/*{Protheus.doc} csPodeEnviarEmail
Funcao responsavel por verificar se algum produto informado para
a determinada Ordem de Servico possui o campo Fatura igual a SIM.
A regra para geracao do boleto eh somente igual a SIM, e com isso 
eh enviado e-mail.
Tratamento realizado para assegurar que o usuario nao envie e-mail 
para o cliente quando o campo eh diferente de SIM, exemplo, Cortesia.

Obs.: Alterado para User Function devido que utilizarei no Envio
de email (Fonte CSFSEmail.prw). @06/04/2017
                                              
@param		cOrdServ	   	Ordem de Servico
@return 	lRet			Retorno se pode ou nao enviar e-mail

@author  Douglas Parreja
@since   03/03/2017
@version 11.8
/*/
//-------------------------------------------------------------------
user function csPodeEnviarEmail( cOrdServ )

	local lRet			:= .F.
	default cOrdServ	:= ""

	dbSelectArea("PA1")
	PA1->(dbSetOrder(1)) //PA1_FILIAL + PA1_OS + PA1_ITEM
	if PA1->( dbSeek( xFilial("PA1") + cOrdServ ))
		while ( !PA1->(eof()) .and. (cOrdServ == alltrim(PA1->PA1_OS)) )
			if alltrim(PA1->PA1_FATURA) == "S"
				lRet := .T.
				exit
			endif 
			PA1->(dbSkip())
		end 
	endif

return lRet




