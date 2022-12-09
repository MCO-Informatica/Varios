#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"


/*/{Protheus.doc} User Function CSGCT006
    (long_description)
    @type  Function
    @author Luciano Alves de Oliveira
    @since 20/10/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    Função para trocar o campo CN9_SITUAC para 05 quando este estiver com 08
    Atendendo ao chamado https://csgnddnp.atlassian.net/browse/PROT-272
    /*/

user function CSGCT006()
/* É possível mudar para as situações conforme abaixo:
    "01"=Cancelado
    "03"=Emitido
    "05"=Vigente
    "06"=Paralisado
    "07"=Sol Fina.
    "08"=Finalizado
    "11"=Rejeitado
*/
Local cFilCont  := CN9->CN9_FILIAL
Local cContra   := CN9->CN9_NUMERO
Local cRevisa   := CN9->CN9_REVISA
Local lRet      := .T.

CN9->(DBSetOrder(1))

If CN9->( DbSeek( cFilCont + cContra + cRevisa ))//Deve se posicionar no contrato que terá sua situação alterada
    if CN9->CN9_SITUAC == "08"
		RecLock( "CN9", .F. ) 
		CN9->CN9_SITUAC := "05"
		MsUnlock() 
		ApMsgInfo( "Situação alterada para 05 - Vigente", "ATENÇÃO")
	else
		ApMsgInfo( "Somente altera quando a situação é 08 - Aprovação", "ATENÇÃO")
	endif
else
    ApMsgInfo( "Contrato não encontrado. Favor printar a tela e abrir chamado.", "ATENÇÃO")
EndIf
  
Return lRet

