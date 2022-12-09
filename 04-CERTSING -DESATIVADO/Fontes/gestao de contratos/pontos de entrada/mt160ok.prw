//--------------------------------------------------------------------------
// Rotina | MT160OK    | Autor | Robson Goncalves        | Data | 07.05.2015
//--------------------------------------------------------------------------
// Descr. | Ponto de entrada para validar se a análise da cotação deve 
//        | continuar.
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
User Function MT160OK()
	Local nI := 0
	Local lMark := .F.
	Local lRetorno := .F.
	Local aParam := AClone( ParamIXB ) // [1] - Planilhas com os dados da cotação.
	Local cMsg := 'Iniciando o processo de preenchimento dos dados da Capa de Despesa, por favor, aguarde...'
	Local cMV_610COT := 'MV_610COT'
	If .NOT. GetMv( cMV_610COT, .T. )
		CriarSX6( cMV_610COT, 'N', 'HABILITAR O PROCESSO DA CAPA DE DESPESA NO PROCESSO DE COTACAO GERA PEDIDO DE COMPRAS. 0=DESABILITADO E 1=HABILITADO - ROTINA MT160WF.prw', '0' )
	Endif
	If GetMv( cMV_610COT, .F. ) == 1 // Se o processo estiver habilitado.
		For nI := 1 To Len( aParam[ 1 ] )
			If aParam[ 1, nI, 1 ] == 'XX'
				lMark := .T.
				Exit
			Endif
		Next nI
		If lMark
			U_AvisoRun('Capa de Despesa',cMsg,{|| lRetorno:=U_CSFA610('COM','MATA160','')},3000)
		Endif
	Endif
Return( lRetorno .AND. lMark )