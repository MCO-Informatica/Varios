#Include 'Protheus.ch'
//--------------------------------------------------------------------------
// Rotina | MT161OK    | Autor | Rafael Beghini        | Data | 22.11.2019
//--------------------------------------------------------------------------
// Descr. | Ponto de entrada utilizado para chamar a Capa de Despesa
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function MT161OK()
	Local nI := 0
	Local lMark := .F.
	Local lRetorno := .F.
	Local aParam := AClone( ParamIXB[ 1 ] ) // [1] - Planilhas com os dados da cotação.
	Local cMsg := 'Iniciando o processo de preenchimento dos dados da Capa de Despesa, por favor, aguarde...'
	Local cMV_610COT := 'MV_610COT'
    
    Private cA161num := SC8->C8_NUM

    If .NOT. GetMv( cMV_610COT, .T. )
		CriarSX6( cMV_610COT, 'N', 'HABILITAR O PROCESSO DA CAPA DE DESPESA NO PROCESSO DE COTACAO GERA PEDIDO DE COMPRAS. 0=DESABILITADO E 1=HABILITADO - ROTINA MT160WF.prw', '0' )
	Endif
	
    If GetMv( cMV_610COT, .F. ) == 1 // Se o processo estiver habilitado.
		For nX := 1 To Len( aParam ) 
            For nY := 1 To Len( aParam[ nX, nY ] ) //-- Quantas propostas possuem (Fornecedores)
                For nZ := 1 To Len( aParam[ nX, nY, 2 ] ) //-- Quantos itens por proposta
                    If aParam[ nX, nY, 2, nZ, 1 ]
				        lMark := .T.
				        Exit
			        Endif
                Next nZ
            Next nY
		Next nX
		If lMark
		    U_AvisoRun('Capa de Despesa',cMsg,{|| lRetorno := U_CSFA610('COM','MATA161','')},3000)
		Endif
	Endif
Return( lRetorno .AND. lMark )