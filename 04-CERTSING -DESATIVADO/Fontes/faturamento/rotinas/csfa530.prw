//-----------------------------------------------------------------------------------
// Rotina | CSFA530      | Autor | Robson Gon�alves               | Data | 18/11/2014 
//-----------------------------------------------------------------------------------
// Descr. | Rotina que providencia a compensa��o de t�tulo conforme os par�metros.
//        | 
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------
// Update | Par�metro para considerar abatimentos (PCC) - Rafael Beghini 11.05.2018
//-----------------------------------------------------------------------------------

// ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 
// ------------------------- PROCEDIMENTO PARA UTILIZA��O DA ROTINA MaInBxCR contida no arquivo de c�digo-fonte FINXAPI.prx --------------------------
// 
// ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ---------------------------------------------------------------------------------------------------------------------------------------------------
// MaIntBxCR(nCaso,aSE1,aBaixa,aNCC_RA,aLiquidacao,aParam,bBlock,aEstorno,aSE1Dados,aNewSE1,nSaldoComp,aCpoUser,aNCC_RAvlr,nSomaCheq,nTaxaCM,aTxMoeda)
// ---------------------------------------------------------------------------------------------------------------------------------------------------
// nCaso     - 1=Baixa simples do financeiro.
//             2=Liquida��o de t�tulos.
//             3=Compensa��o de t�tulos de mesma carteira (RA/NCC).
// aRecNoSE1 - RecNo dos t�tulos a serem baixados.
// aBaixa    - Dados com a baixa do t�tulo
//             [1]-Motivo da baixa
//             [2]-Valor recebido
//             [3]-Banco
//             [4]-Ag�ncia
//             [5]-Conta
//             [6]-Dada do credito
//             [7]-Data da baixa
// aCompensa - RecNo dos t�tulos a serem compensados.
// aLiquida  - Dados da liquida��o.
//             [1]-Prefixo
//             [2]-Banco 
//             [3]-Ag�ncia
//             [4]-Conta
//             [5]-N�mero do cheque
//             [6]-Data boa
//             [7]-Valor
//             [8]-Tipo
//             [9]-Natureza
//             [A]-Moeda
// aParam    - Array com os parametros da rotina.
//             [1]-Contabiliza on-line
//             [2]-Aglutina lan�amentos
//             [3]-Digita lan�amentos cont�beis
//             [4]-Juros para comiss�o
//             [5]-Desconto para comiss�o
//             [6]-Calcula comiss�o s/ NCC
// bBlock     - Bloco de codigo a ser executado apos o processamento
// aEstorno   - N�mero dos E5_DOCUMEN para estorno.
// aNDFDados  - Dados da nota de debito fornecedor, comp�tivel com o array aCompensa.
// aNewSE1    - Array dos novos t�tulos criados.
// nSaldoComp - Ajustar saldo ao compensar.
// aCpoUser   - Array com os campos complementares para ser gravado quando gerar os novos t�tulos
//              [n,1] = Nome do campo
//              [n,2] = Conteudo para o campo
// aNCC_RAvlr - Exclusivo para uso de NCC_RA para compensacao de valores parciais valores igual ou inferior ao valor do saldo disponivel.
// nSomaCheq  - Total dos Cheques informados na baixa.
// nTaxaCM    - Valor da taxa da moeda corrente - Corre��o monet�ria.
// aTxMoeda   - Valores de taxas das moedas - Corre��o monet�ria.
// lConsdAbat - Indica se do saldo a ser compensado devem ser diminu�dos os abatimentos e os impostos.
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
			//Devo fazer esta verifica��o e posicionar no Alias "__SE1", pois na fun��o SomaBat estava
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
			cMsg := 'N�o foi poss�vel efetuar a ' + Iif( nCaso == 1, 'baixa', Iif( nCaso == 2, 'liquida��o', 'compensa��o' ) ) + ' do t�tulo.'
		Endif
	Else
		nCaso := 'O valor do par�metro nCaso � inv�lido.'
	Endif
Return( { lRet, cMsg } )

//-----------------------------------------------------------------------------------
// Rotina | CSFA531      | Autor | Robson Gon�alves               | Data | 19/11/2014 
//-----------------------------------------------------------------------------------
// Descr. | Rotina que providencia a substitui��o de t�tulo conforme os par�metros.
//        | 
//-----------------------------------------------------------------------------------
// Uso    | CERTISIGN Certificadora Digital S.A.
//-----------------------------------------------------------------------------------

// Estrutura do array aDEF t�tulo definitivo.
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

// Estrutra do vetor aSUB t�tulos que ser�o susbstitu�dos.
// aSUB[ ? ] RecNo do t�tulo, podem ser v�rios RecNo.

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
				                
				// Armazenar a chave do t�tulo para contemplar uma informa��o no E5_DOCUMEN do registro de baixa do t�tulo provis�rio.
				AAdd( aE5_DOCUMEN, xFilial( 'SE5' ) + 'BA' + SE1->( E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO + Dtos( dDataBase ) + E1_CLIENTE + E1_LOJA ) )
			Else
				cMsg := 'Imoss�vel prosseguir, o RECNO (SUB)' + LTrim( SE1->( Str( RecNo() ) ) ) +' n�o foi localido no SE1. Processo completamente interrompido.'
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
			
			// Estabelecer o nome da rotina de t�tulo a receber.
			SetFunName('FINA040')
			
			// Recarregar os dados dos par�metros da rotina.
			Pergunte( 'FIN040', .F. )
			
			// Verificar se mostra lan�amento contabil. Tem que ser igual a n�o.
			If MV_PAR01 <> 2
				If SX1->( dbSeek( PadR( 'FIN040', Len( SX1->X1_GRUPO ), ' ' ) + '01' ) )
					SX1->( RecLock( 'SX1', .F. ) )
					SX1->X1_PRESEL := 2
					SX1->( MsUnLock() )
				Endif
			Endif
			
			// Verificar contabiliza on-line. Tem que ser igual a n�o.
			If MV_PAR03 <> 2
				If SX1->( dbSeek( PadR( 'FIN040', Len( SX1->X1_GRUPO ), ' ' ) + '03' ) )
					SX1->( RecLock( 'SX1', .F. ) )
					SX1->X1_PRESEL := 2
					SX1->( MsUnLock() )
				Endif
			Endif
			
			// Executar a substitui��o dos t�tulos.
			MsExecAuto( { |a,b,c| FINA040( a, b, c ) } ,aTitulo, 6, aTitSubs )
			
			// Se houver erro capturar a mensagem.
			If lMsErroAuto
				lRet := .F.
				MostraErro()
				cMsg := 'Inconsist�ncia para substituir t�tulo' + CRLF + CRLF
				aAutoErr := GetAutoGRLog()
				For nI := 1 To Len( aAutoErr )
					cMsg += aAutoErr[ nI ] + CRLF
				Next nI
			Else
				// Se n�o houver erro vincular o t�tulo principal com as baixas dos t�tulos provis�rios.
				SE5->( dbSetOrder( 2 ) )
				For nI := 1 To Len( aE5_DOCUMEN )
					If SE5->( dbSeek( aE5_DOCUMEN[ nI ] ) )
						SE5->( RecLock( 'SE5', .F. ) )
						//                 Prefixo     N�mero      Parcela     Tipo        Cliente     Loja
						SE5->E5_DOCUMEN := aDEF[ 1 ] + aDEF[ 2 ] + aDEF[ 3 ] + aDEF[ 4 ] + aDEF[ 6 ] + aDEF[ 7 ]
						SE5->( MsUnLock() )
					Endif
				Next nI
			Endif
		Endif
	Else
		lRet := .F.
		If Len(aDEF) == 0
			cMsg := 'O array com dados do t�tulo definitivo est� vazio.'
		Endif
		If Len(aSUB) == 0
			cMsg += CRLF + 'O array com dados do t�tulo a ser substituido est� vazio.'
		Endif
	Endif
Return( { lRet, cMsg } )

//-----------------------------------------------------------------------------------
// Rotina | My531        | Autor | Robson Gon�alves               | Data | 19/11/2014 
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
	If MsgYesNo('Confirmar o teste da rotina de Substitui��o de T�tulos a Receber?','MyCSFA531')
		// RecNo dos registros provis�rios que ser�o substitu�dos.
		// aSUB := { 6499229, 6499230, 6499231 }
		// aSUB := { 6499233, 6499234 }
		// aSUB := { 6499236, 6499237 }
		
		aSUB := { 6499242 } // PR
		
		// Dados do t�tulo definitivo que ser� a substitui��o dos provis�rios.
		// aDEF := { 'TST', '201411205', '  ', 'DP ', 'FT030001  ', '130901', '01', dDataBase, dDataBase, 350.00 }
		// aDEF := { 'TST', '201411208', '  ', 'DP ', 'FT030001  ', '130901', '01', dDataBase, dDataBase, 305.12 }
		// aDEF := { 'TST', '20141120C', '  ', 'DP ', 'FT030001  ', '130901', '01', dDataBase, dDataBase, 432.10 }
		
		aDEF := {'TST', '201411253', '  ', 'NCC', 'FT030001  ', '000015', '01', dDataBase, dDataBase, 1234.56 } // NCC
		
		aRet := U_CSFA531( aSUB, aDEF )
      
		If aRet[ 1 ]
			MsgAlert('Rotina finalizada com sucesso.','MyCSFA531')
		Else
			MsgAlert('Opera��o realizada com problemas.' + CRLF + aRet[ 2 ],'MyCSFA531')
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


