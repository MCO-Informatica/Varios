//-----------------------------------------------------------------------------------
// Rotina | CSFA530      | Autor | Robson Gonçalves               | Data | 18/11/2014 
//-----------------------------------------------------------------------------------
// Descr. | Rotina que providencia a compensação de título conforme os parâmetros.
//        | 
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
// Update | Parâmetro para considerar abatimentos (PCC) - Rafael Beghini 11.05.2018
//-----------------------------------------------------------------------------------

// ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 
// ------------------------- PROCEDIMENTO PARA UTILIZAÇÃO DA ROTINA MaInBxCR contida no arquivo de código-fonte FINXAPI.prx --------------------------
// 
// ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ---------------------------------------------------------------------------------------------------------------------------------------------------
// MaIntBxCR(nCaso,aSE1,aBaixa,aNCC_RA,aLiquidacao,aParam,bBlock,aEstorno,aSE1Dados,aNewSE1,nSaldoComp,aCpoUser,aNCC_RAvlr,nSomaCheq,nTaxaCM,aTxMoeda)
// ---------------------------------------------------------------------------------------------------------------------------------------------------
// nCaso     - 1=Baixa simples do financeiro.
//             2=Liquidação de títulos.
//             3=Compensação de títulos de mesma carteira (RA/NCC).
// aRecNoSE1 - RecNo dos títulos a serem baixados.
// aBaixa    - Dados com a baixa do título
//             [1]-Motivo da baixa
//             [2]-Valor recebido
//             [3]-Banco
//             [4]-Agência
//             [5]-Conta
//             [6]-Dada do credito
//             [7]-Data da baixa
// aCompensa - RecNo dos títulos a serem compensados.
// aLiquida  - Dados da liquidação.
//             [1]-Prefixo
//             [2]-Banco 
//             [3]-Agência
//             [4]-Conta
//             [5]-Número do cheque
//             [6]-Data boa
//             [7]-Valor
//             [8]-Tipo
//             [9]-Natureza
//             [A]-Moeda
// aParam    - Array com os parametros da rotina.
//             [1]-Contabiliza on-line
//             [2]-Aglutina lançamentos
//             [3]-Digita lançamentos contábeis
//             [4]-Juros para comissão
//             [5]-Desconto para comissão
//             [6]-Calcula comissão s/ NCC
// bBlock     - Bloco de codigo a ser executado apos o processamento
// aEstorno   - Número dos E5_DOCUMEN para estorno.
// aNDFDados  - Dados da nota de debito fornecedor, compátivel com o array aCompensa.
// aNewSE1    - Array dos novos títulos criados.
// nSaldoComp - Ajustar saldo ao compensar.
// aCpoUser   - Array com os campos complementares para ser gravado quando gerar os novos títulos
//              [n,1] = Nome do campo
//              [n,2] = Conteudo para o campo
// aNCC_RAvlr - Exclusivo para uso de NCC_RA para compensacao de valores parciais valores igual ou inferior ao valor do saldo disponivel.
// nSomaCheq  - Total dos Cheques informados na baixa.
// nTaxaCM    - Valor da taxa da moeda corrente - Correção monetária.
// aTxMoeda   - Valores de taxas das moedas - Correção monetária.
// lConsdAbat - Indica se do saldo a ser compensado devem ser diminuídos os abatimentos e os impostos.
// ---------------------------------------------------------------------------------------------------------------------------------------------------

#Include 'Protheus.ch'

User Function CSFA530( nCaso, aSE1, aBaixa, aNCC_RA, aLiquidacao, aParam, bBlock, aEstorno, aNFDDados, aNewSE1, lConsdAbat )
	Local lRet := .F.
	Local cMsg := 'Processo CSFA530 realizado com sucesso.'
	
	DEFAULT aSE1        := {}
	DEFAULT aBaixa      := {}
	DEFAULT aNCC_RA     := {}
	DEFAULT aLiquidacao := {}
	DEFAULT aParam      := {}
	DEFAULT bBlock      := {|| .T. }
	DEFAULT aEstorno    := {}
	DEFAULT aNFDDados   := {}
	DEFAULT aNewSE1     := {}
	DEFAULT lConsdAbat  := .T.
	
	If nCaso > 0 .AND. nCaso <= 3
		IF cValToChar(nCaso) == '3'
			//Devo fazer esta verificação e posicionar no Alias "__SE1", pois na função SomaBat estava
			//desposicionando. - Rafael Beghini 11.05.2018
			IF Select("__SE1") == 0
				ChkFile("SE1",.F.,"__SE1")
			Else
				DbSelectArea("__SE1")
			EndIf
			__SE1->( dbGoTo( aSE1[1] ) )
		EndIF
		lRet := MaIntBxCR( nCaso, aSE1, aBaixa, aNCC_RA, aLiquidacao, aParam, bBlock, aEstorno, aNFDDados, @aNewSE1, NIL, {}, NIL, 0, 0, {}, lConsdAbat )
		If .NOT. lRet
			cMsg := 'Não foi possível efetuar a ' + Iif( nCaso == 1, 'baixa', Iif( nCaso == 2, 'liquidação', 'compensação' ) ) + ' do título.'
		Endif
	Else
		nCaso := 'O valor do parâmetro nCaso é inválido.'
	Endif
Return( { lRet, cMsg } )

//-----------------------------------------------------------------------------------
// Rotina | CSFA531      | Autor | Robson Gonçalves               | Data | 19/11/2014 
//-----------------------------------------------------------------------------------
// Descr. | Rotina que providencia a substituição de título conforme os parâmetros.
//        | 
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------

// Estrutura do array aDEF título definitivo.
// aDEF[ 1 ] = E1_PREFIXO
// aDEF[ 2 ] = E1_NUM
// aDEF[ 3 ] = E1_PARCELA
// aDEF[ 4 ] = E1_TIPO
// aDEF[ 5 ] = E1_NATUREZ
// aDEF[ 6 ] = E1_CLIENTE
// aDEF[ 7 ] = E1_LOJA
// aDEF[ 8 ] = E1_EMISSAO
// aDEF[ 9 ] = E1_VENCTO
// aDEF[ A ] = E1_VALOR

// Estrutra do vetor aSUB títulos que serão susbstituídos.
// aSUB[ ? ] RecNo do título, podem ser vários RecNo.

User Function CSFA531( aSUB, aDEF )
	Local lRet := .T.
	Local cMsg := ''
	Local nI := 0
	Local nE1_VALOR := 0
	Local aTitulo := {}
	Local aTitSubs := {}
	Local aAutoErr := {}
	Local aE5_DOCUMEN := {}
	
	Private lMsErroAuto := .F.
	Private lAutoErrNoFile	:= .T.

	If Len( aDEF ) > 0 .AND. Len( aSUB ) > 0
		For nI := 1 To Len( aSUB )
			SE1->( dbGoTo( aSUB[ nI ] ) )
			If SE1->( RecNo() ) == aSUB[ nI ]
				nE1_VALOR += SE1->E1_VALOR
				AAdd( aTitSubs,{{"E1_FILIAL"  , SE1->E1_FILIAL , NIL },;
					{"E1_PREFIXO" , SE1->E1_PREFIXO, NIL },;
					{"E1_NUM"     , SE1->E1_NUM    , NIL },;
					{"E1_PARCELA" , SE1->E1_PARCELA, NIL },;
					{"E1_TIPO"    , SE1->E1_TIPO   , NIL },;
					{"E1_NATUREZ" , SE1->E1_NATUREZ, NIL },;
					{"E1_CLIENTE" , SE1->E1_CLIENTE, NIL },;
					{"E1_LOJA"    , SE1->E1_LOJA   , NIL },;
					{"E1_EMISSAO" , SE1->E1_EMISSAO, NIL },;
					{"E1_VENCTO"  , SE1->E1_VENCTO , NIL },;
					{"E1_VALOR"   , SE1->E1_VALOR  , NIL },;
					{"E1_MOEDA"   , SE1->E1_MOEDA  , NIL }})
				                
				// Armazenar a chave do título para contemplar uma informação no E5_DOCUMEN do registro de baixa do título provisório.
				AAdd( aE5_DOCUMEN, xFilial( 'SE5' ) + 'BA' + SE1->( E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO + Dtos( dDataBase ) + E1_CLIENTE + E1_LOJA ) )
			Else
				cMsg := 'Imossível prosseguir, o RECNO (SUB)' + LTrim( SE1->( Str( RecNo() ) ) ) +' não foi localido no SE1. Processo completamente interrompido.'
				lRet := .F.
				Exit
			Endif
		Next nI
				
		If lRet
			AAdd( aTitulo ,{ 'E1_FILIAL'  , xFilial('SE1')  , NIL } )
			AAdd( aTitulo ,{ 'E1_PREFIXO' , aDEF[  1 ]      , NIL } )
			AAdd( aTitulo ,{ 'E1_NUM'     , aDEF[  2 ]      , NIL } )
			AAdd( aTitulo ,{ 'E1_PARCELA' , aDEF[  3 ]      , NIL } )
			AAdd( aTitulo ,{ 'E1_TIPO'    , aDEF[  4 ]      , NIL } )
			AAdd( aTitulo ,{ 'E1_NATUREZ' , aDEF[  5 ]      , NIL } )
			AAdd( aTitulo ,{ 'E1_CLIENTE' , aDEF[  6 ]      , NIL } )
			AAdd( aTitulo ,{ 'E1_LOJA'    , aDEF[  7 ]      , NIL } )
			AAdd( aTitulo ,{ 'E1_EMISSAO' , aDEF[  8 ]      , NIL } )
			AAdd( aTitulo ,{ 'E1_VENCTO'  , aDEF[  9 ]      , NIL } )
			AAdd( aTitulo ,{ 'E1_VALOR'   , aDEF[ 10 ]      , NIL } )
			AAdd( aTitulo ,{ 'E1_MOEDA'   , 1               , NIL } )
			
			// Estabelecer o nome da rotina de título a receber.
			SetFunName('FINA040')
			
			// Recarregar os dados dos parâmetros da rotina.
			Pergunte( 'FIN040', .F. )
			
			// Verificar se mostra lançamento contabil. Tem que ser igual a não.
			If MV_PAR01 <> 2
				If SX1->( dbSeek( PadR( 'FIN040', Len( SX1->X1_GRUPO ), ' ' ) + '01' ) )
					SX1->( RecLock( 'SX1', .F. ) )
					SX1->X1_PRESEL := 2
					SX1->( MsUnLock() )
				Endif
			Endif
			
			// Verificar contabiliza on-line. Tem que ser igual a não.
			If MV_PAR03 <> 2
				If SX1->( dbSeek( PadR( 'FIN040', Len( SX1->X1_GRUPO ), ' ' ) + '03' ) )
					SX1->( RecLock( 'SX1', .F. ) )
					SX1->X1_PRESEL := 2
					SX1->( MsUnLock() )
				Endif
			Endif
			
			// Executar a substituição dos títulos.
			MsExecAuto( { |a,b,c| FINA040( a, b, c ) } ,aTitulo, 6, aTitSubs )
			
			// Se houver erro capturar a mensagem.
			If lMsErroAuto
				lRet := .F.
				MostraErro()
				cMsg := 'Inconsistência para substituir título' + CRLF + CRLF
				aAutoErr := GetAutoGRLog()
				For nI := 1 To Len( aAutoErr )
					cMsg += aAutoErr[ nI ] + CRLF
				Next nI
			Else
				// Se não houver erro vincular o título principal com as baixas dos títulos provisórios.
				SE5->( dbSetOrder( 2 ) )
				For nI := 1 To Len( aE5_DOCUMEN )
					If SE5->( dbSeek( aE5_DOCUMEN[ nI ] ) )
						SE5->( RecLock( 'SE5', .F. ) )
						//                 Prefixo     Número      Parcela     Tipo        Cliente     Loja
						SE5->E5_DOCUMEN := aDEF[ 1 ] + aDEF[ 2 ] + aDEF[ 3 ] + aDEF[ 4 ] + aDEF[ 6 ] + aDEF[ 7 ]
						SE5->( MsUnLock() )
					Endif
				Next nI
			Endif
		Endif
	Else
		lRet := .F.
		If Len(aDEF) == 0
			cMsg := 'O array com dados do título definitivo está vazio.'
		Endif
		If Len(aSUB) == 0
			cMsg += CRLF + 'O array com dados do título a ser substituido está vazio.'
		Endif
	Endif
Return( { lRet, cMsg } )

//-----------------------------------------------------------------------------------
// Rotina | My531        | Autor | Robson Gonçalves               | Data | 19/11/2014 
//-----------------------------------------------------------------------------------
// Descr. | Rotina para testar o funcionamento.
//        | 
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
User Function My531()
	Local aSUB := {}
	Local aDEF := {}
	Local aRet := {}
	If MsgYesNo('Confirmar o teste da rotina de Substituição de Títulos a Receber?','MyCSFA531')
		// RecNo dos registros provisórios que serão substituídos.
		// aSUB := { 6499229, 6499230, 6499231 }
		// aSUB := { 6499233, 6499234 }
		// aSUB := { 6499236, 6499237 }
		
		aSUB := { 6499242 } // PR
		
		// Dados do título definitivo que será a substituição dos provisórios.
		// aDEF := { 'TST', '201411205', '  ', 'DP ', 'FT030001  ', '130901', '01', dDataBase, dDataBase, 350.00 }
		// aDEF := { 'TST', '201411208', '  ', 'DP ', 'FT030001  ', '130901', '01', dDataBase, dDataBase, 305.12 }
		// aDEF := { 'TST', '20141120C', '  ', 'DP ', 'FT030001  ', '130901', '01', dDataBase, dDataBase, 432.10 }
		
		aDEF := {'TST', '201411253', '  ', 'NCC', 'FT030001  ', '000015', '01', dDataBase, dDataBase, 1234.56 } // NCC
		
		aRet := U_CSFA531( aSUB, aDEF )
      
		If aRet[ 1 ]
			MsgAlert('Rotina finalizada com sucesso.','MyCSFA531')
		Else
			MsgAlert('Operação realizada com problemas.' + CRLF + aRet[ 2 ],'MyCSFA531')
		Endif
	Endif
Return

User Function My530()
	Local nCaso := 3
	Local aSE1 := { 20887458 } //Recno NF
	Local aSe1NCC := { 20887490 } // Recno NCC
	Local aBaixa := { "CMP", 238.38, '   ','     ', '          ', dDataBase, dDataBase }
	Local aParam := { .F., .F., .F., .F., .F., .F. }
	Local aRet := {}
	Local aSE1Dados := {}
	Local aFAVal := {}
	Local cCLILOJ := ''
   
	SE1->( dbGoTo( aSE1[1] ) )
	
	//aFaVlAtuCR := FaVlAtuCr("SE1",dDataBase)
   
	//AAdd( aSE1Dados, { 6499252, 'TESTE DE BAIXA', AClone( aFAVal ) } )
   	
	//aRet := U_CSFA530( nCaso, aSE1, aBaixa, /*aNCC_RA*/, /*aLiquidacao*/, aParam, /*bBlock*/, /*aEstorno*/, aSE1Dados, /*aNewSE1*/ )
	aRet := U_CSFA530( nCaso, aSE1, /*aBaixa*/, aSe1NCC, /*aLiquidacao*/, aParam, /*bBlock*/, /*aEstorno*/, /*aDadosBaixa*/, /*aNewSE1*/, .T. )
	
	If aRet[1]
		alert( aRet[2] )
	Else
		alert( aRet[2] )
	Endif
Return


