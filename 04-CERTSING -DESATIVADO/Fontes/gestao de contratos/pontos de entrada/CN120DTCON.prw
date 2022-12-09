//+--------+------------------+-----------------------------------------------------------------------------+------------+
//| JIRA   | OTRS             | DESCRICAO                                                                   | DATAA      |
//+--------+------------------+-----------------------------------------------------------------------------+------------+
//| PROT-3 | 2020030310001664 | Retira planilha fixa na inclusao de medicao.                                | 06/05/2020 |
//+--------+------------------+-----------------------------------------------------------------------------+------------+

#include 'protheus.ch'
#include 'parmtype.ch'

//Ponto de Entrada no CNTA120
user function CN120DTC()
	if select( "TRBCNA" ) > 0
		//alert("filtra planilha fixa")
		dbSelectArea("TRBCNA")
		filtPlFixa()
	endif	
return

//Retira planilha fixa na inclusao de medicao.
static function filtPlFixa()
	local cCodPlani := ""
	local cTipoPlan := ""
	local cRevisao  := ""
	#define cPLANILHA_FIXA 		"1"
	#define cMEDICAO_AUTOMATICA "1"

	//Ignora a validacao quando o usuario faz parte do grupo juridico
	if ignorarVld()
		return
	endif

	
	TRBCNA->(dbGoTop())
	while TRBCNA->(!Eof() )
		cCodPlani := TRBCNA->CNA_NUMERO
		cRevisao  := TRBCNA->CNA_REVISA
		CNA->(dbSetOrder(1))
		if CNA->( dbSeek( xFilial("CNA") + cContra + cRevisao + cCodPlani ) )
			cTipoPlan := CNA->CNA_TIPPLA
			CNL->(dbSetOrder(1))
			if CNL->( dbSeek( xFilial("CNL") + cTipoPlan ) )
				if CNL->CNL_CTRFIX == cPLANILHA_FIXA .and. CNL->CNL_MEDAUT == cMEDICAO_AUTOMATICA
					RecLock("TRBCNA",.F.)
					TRBCNA->( dbDelete() )
					TRBCNA->( MsUnlock() )
				endif 
			endif
		endif
		TRBCNA->(dbSkip())
	end
	TRBCNA->(dbGoTop())
	oBrowse:Refresh()
	oBrowse:SetFocus()
return

//Ignora a validacao quando o usuario faz parte do grupo juridico
static function ignorarVld()
	#define cSX6_GRUPO "GCT_GRUPOJUR" //Codigo do parametro SX6
	
	local lIgnora := .F. //Retorno da rotina
	local cGrupo  := ""  //Grupo do juridico que pode lançar planilha fixa
	local aGrp 	  := UsrRetGrp(UsrRetName(RetCodUsr())) //Array com grupos do usuário logado
	
	//Cria parametro caso nao exista
	if !GetMv( cSX6_GRUPO, .T. )
		CriarSX6( cSX6_GRUPO, 'C', 'CUSTOMIZADO. GRUPO DE APROVACAO TOTAL DO GCT', '000291' )
	endif
	cGrupo := GetMv( cSX6_GRUPO, .F. ) //Código do grupo do juridico
	
	//Busca no array o codigo do juridico
	lIgnora := ( aScan( aGrp, {|x| x == cGrupo } ) > 0)
return lIgnora
