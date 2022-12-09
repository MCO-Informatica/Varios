//-----------------------------------------------------------------------
// Rotina | CNCFLDESP  | Autor | Robson Gonçalves     | Data | 12.01.2013
//-----------------------------------------------------------------------
// Descr. | Ponto de entrada. 
//        | 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
User Function CNCFLDESP()
	
	Local aCab  := AClone( ParamIXB[ 1 ] )
	Local aDad  := AClone( ParamIXB[ 2 ] )
	Local aArea := SA2->( GetArea() )
	
	If aCab[1,2] == "CNC_CODIGO" .And. Alltrim( aCab[2,2] ) == "CNC_LOJA"
		
		//-- Criar um novo elemento no vetor.
		AAdd( aCab, NIL )
		
		//-- Colocar este novo elemento na posição desejada.
		AIns( aCab, 4 )
		
		//-- Criar colunas para o elemento do vetor.
		aCab[ 4 ] := Array( 10 )
		
		//-- Posicionar no campo do dicionário para capturar os atributos do campo.
		aCab[ 4 ] := SX3->( GetAdvFVal( 'SX3',;
										{'X3_TITULO','X3_CAMPO','X3_PICTURE','X3_TAMANHO','X3_DECIMAL','X3_VALID','X3_USADO','X3_TIPO','X3_F3','X3_CONTEXT'},;
										'A2_CGC', 2 ) )
		
		//-- Para todos os registros do vetor adicionar o dado CNPJ/CPF do fornecedor.
		AEval( aDad, { |p| AAdd( p, NIL ),;
		AIns( p, 4 ),;
		p[ 4 ] := SA2->( Posicione( 'SA2', 1, xFilial( 'SA2' ) + ;
												p[ AScan( aCab, {|a| RTrim( a[ 2 ] ) == 'CNC_CODIGO' } ) ] + ;
												p[ AScan( aCab, {|a| RTrim( a[ 2 ] ) == 'CNC_LOJA' } ) ],;
												'A2_CGC' ) ) } )
		SA2->( RestArea( aArea ) )
	EndIf

Return( { aCab, aDad } ) //-- Retornar os vetores alterados. 