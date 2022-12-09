#INCLUDE "CTGPM050.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE cID_PONTO_FALTA "010A"

/*/{Protheus.doc} CSRH080
Beneficios - Cálcula faltas integrais para desconto de beneficios, o padrão utiliza as tabelas
SRC, SRD e RGB para encontrar as faltas. Na Ceritisign a regra é de encontrar as faltas 
no último período fechado, e olhar todas as faltas com id de ponto 010A e desconsiderar
as faltas com os abonos configurados na tabela RCC (manutenção de tabelas da folha)
para o registro ""
Este fonte será lido nos seguintes roteiros de cálculos: VTR, VAL e VRF
@type function
@author BrunoNunes
@since 07/12/2017
@version P12 1.12.17 
@return null, Nulo
/*/
User Function CSRH080()
	//Encontrar último período fechado
  	FindPerFec()
   
   	//Carregar evento de falta
   	FindEveFal()
   	
   	//Carregar abonos que não descontam benefícios VT / VR / VA
   	fAboBen()
   	
   	//Cálcular faltas considerando o período fechado do ponto
   	fCkFtBen()   	
Return

/*/{Protheus.doc} FindPerFec
Pesquisa pelo o último período fechado do ponto e guarda nos mnemônicos m_dPerIni e m_dPerFim
@type function
@author BrunoNunes
@since 11/12/2017
@version P12 1.12.17
@return null, Nulo
/*/
Static Function FindPerFec()	
	//Se o período já foi encontrado não lê novamente
	if !empty(m_dPerIni) .and. !empty(m_dPerFim)
		return()
	endif
	
	//Busca pelo último período fechado do ponto
	SPO->( dbSetOrder(2) )
 	SPO->( dbGoTop() )
	While SPO->( !EOF() )
	   	m_dPerIni := DToS(SPO->PO_DATAINI)
	   	m_dPerFim := DToS(SPO->PO_DATAFIM)	   	
   		SPO->( dbSkip() )
	EndDo
Return

/*/{Protheus.doc} FindEveFal
Pesquisa pelo id de ponto A010 "Falta autorizada" e guarda no mnemônico m_cEveFlt, o código evento. 
@type function
@author BrunoNunes
@since 11/12/2017
@version P12 1.12.17
@return null, Nulo
/*/
Static Function FindEveFal()
	if empty(m_cEveFlt)
   		m_cEveFlt := Posicione("SP9",2,xFilial("SP9")+cID_PONTO_FALTA,"P9_CODIGO")
   	endif
Return

/*/{Protheus.doc} fAboBen
Busca Codigos de Abonos para Abono de Faltas a Descontar nos Beneficios.
Resgatar os codigos dos abonos que abonam de fato as faltas integrais, que abateriam os beneficios.  
Esses codigos de abonos devem estar informados na tabela da folhas (Manutenção Tabelas). Detalhes na documentação do projeto.
Observacoes.: Essa rotina foi desenvolvida com base na rotina padrao de calculo de Vale Transporte (GPEM050).
@type function
@author Alexandre Alves da Silva - OPVS
@since 06/06/2016 
@version P12 1.12.17
@return null, Nulo
/*/
Static Function fAboBen()
	Local cMV_CTABBEN := GetMv("MV_CTABBEN")
	
	If !empty(cMV_CTABBEN) .and. empty(m_cCodAbo)
	
		RCC->( dbSetOrder(1) )
		RCC->( dbGoTop()      )
		RCC->( dbSeek( xFilial("RCC") + cMV_CTABBEN ) )
		While RCC->( !EOF() ) .And. RCC->(RCC_FILIAL+RCC_CODIGO) == ( xFilial("RCC") + cMV_CTABBEN )
			if !empty(m_cCodAbo)
				m_cCodAbo += ","
			endif
			m_cCodAbo += "'"+AllTrim(Substr(RCC->RCC_CONTEUDO,1,3))+"'"
			RCC->( dbSkip() )      
	    EndDo
	EndIf
Return()

/*/{Protheus.doc} fCkFtBen
Resgatar faltas ocorridas no ultimo periodo de ponto fechado, verificando os motivos de abono, 
se existirem e processando os dias de beneficios, conforme o  numero de faltas. 
@type function
@author Alexandre A. Silva - OPVS
@since 06/06/2016 
@version P12 1.12.17
@return null, Nulo
/*/
Static Function fCkFtBen()
	Local cQuery   	:= ""
	Local cAliasSPH  	:= GetNextAlias()

	//Monta query olhando a tabela SPH
	cQuery := "SELECT PH_FILIAL, PH_MAT, COUNT(1) AS PH_FLT "
	cQuery += "FROM "+RetSqlName("SPH")+"         	"
	cQuery += "WHERE D_E_L_E_T_ <> '*'            	"
	cQuery += "AND PH_FILIAL	= '"+SRA->RA_FILIAL	+"'	"
	cQuery += "AND PH_MAT   	= '"+SRA->RA_MAT		+"'	"
	cQuery += "AND PH_PD		= '"+AllTrim(m_cEveFlt)+"'	"
	cQuery += "AND PH_DATA BETWEEN '"+m_dPerIni+"'  AND '"+m_dPerFim+"' "       

	//18/02/2021 - Tratamento para não descontar Faltas que estiverem em banco de horas - Maiara
	cQuery += "AND NOT EXISTS (SELECT PI_PD FROM  "+RetSqlName("SPI")+"  WHERE D_E_L_E_T_ = ' ' AND PI_FILIAL = PH_FILIAL AND PI_MAT = PH_MAT AND PI_DATA = PH_DATA AND PI_PD = PH_PD) "

	//Se houver abonos (especificos) para Faltas Integrais, considera-os.
	If !Empty( m_cCodAbo )
	   cQuery += "AND PH_ABONO NOT IN ("+m_cCodAbo+") "
	EndIf	       
	cQuery += "GROUP BY PH_FILIAL, PH_MAT "
	cQuery += "ORDER BY PH_FILIAL, PH_MAT "
	       
	//Monta tabela temporaria cAliasSPH
	cQuery := ChangeQuery(cQuery)	       
	TCQUERY cQuery NEW ALIAS (cAliasSPH)
	       
	//Soma faltas do ponto a demaais faltas...
	nFaltas += (cAliasSPH)->PH_FLT	       
	
	//Fecha tabela temporaria
	(cAliasSPH)->( DbCloseArea() )
Return()
