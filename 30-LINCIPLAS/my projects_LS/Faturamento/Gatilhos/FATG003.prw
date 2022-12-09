

#Include "Protheus.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³    º Autor ³ Vanilson Souza     º Data ³  07/05/10         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gatilho responsável pela gravação do CFOP conforme          ±±
±±º          ³ TES, caso tentem digitar um CFOP diferente do informado     ±±
±±º          ³ Na TES.	                         				          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function FATG003( )



Local 	cAlias			:= "SM0"
Local 	cEstado	   		:= Alltrim( SM0->M0_ESTENT )
Local	cCF4			:= ""
Private _cCliente		:= M->C5_CLIENTE
Private _cLoja   		:= M->C5_LOJACLI
Private _cCF      		:= ""
Private nPosCF     		:= 0
Private nPosTES    		:= 0



For nLinha := 1 To Len( aCols )  //Percore as linhas da C6
	nitem:=aScan( aHeader, { |x| Alltrim( X[ 2 ] ) == "C6_ITEM" } ) // Recebe ITEM
	nPosCF   	:= aScan( aHeader, { |x| Alltrim( X[ 2 ] ) == "C6_CF" } ) // Recebe a posição da coluna CFOP
	nPosTES 	:= aScan(aHeader, { |x| Alltrim( x[ 2 ] ) == "C6_TES" } ) // Recebe a posição da coluna TES
	_cCF      	:= cValToChar(aCols[ nLinha ][ nPosCF ])                  // Recebe o CFOP informado
	
	If aCols[ nLinha ][ Len( aHeader ) + 1 ] == .F. // Verifica se a linha não foi deletada
		
		dbSelectArea( "SF4" )
		dbSetOrder( 1 )
		If dbSeek( xFilial( "SF4" ) + aCols[nLinha][nPosTES] )
			
			cCF4 := SF4->F4_CF
			
			If M->C5_TIPO == "B" .OR. M->C5_TIPO == "D"  // Verifica se trata-se de Devolucao ou Utiliza Fornecedor
				
				dbSelectArea( "SA2" )
				dbSetOrder( 1 )
				If dbSeek( xFilial( "SA2" )+_cCliente+_cLoja )
					
					If Alltrim( SA2->A2_EST ) <> cEstado // 	//Verifica que se o cliente é de fora de São Paulo, caso seja muda o primeiro digito para 6
						
						_cCF  := "6" + Substr(cValToChar(cCF4), 2,4)
						aCols[nLinha,nPosCF] := _cCF
						
						If nLinha == 1
							_cVani := _cCF
						EndIf
						
					Else
						_cCF := cValToChar(cCF4)
						aCols[nLinha,nPosCF] := _cCF
						
					Endif
					
				Endif
				
			Else
				
				dbSelectArea( "SA1" )
				dbSetOrder( 1 )
				If dbSeek( xFilial( "SA1" )+_cCliente+_cLoja )
					
					If Alltrim( SA1->A1_EST ) <> cEstado // 	//Verifica que se o cliente é de fora de São Paulo, caso seja muda o primeiro digito para 6
						
						_cCF  := "6" + Substr(cValToChar(cCF4), 2,4)
						aCols[nLinha,nPosCF] := _cCF
						
					Else
						
						_cCF := cValToChar(cCF4)
						aCols[nLinha,nPosCF] := _cCF
						
					Endif
					
				Endif
				
			Endif
			
		Endif
		
	EndIf

Next

aCols[1,nPosCF] := _cVani

Return  aCols[1,nPosCF] 


