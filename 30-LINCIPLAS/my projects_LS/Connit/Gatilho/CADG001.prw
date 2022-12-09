
#Include "Protheus.ch"

/*
+====================================================================================+
|Programa: CADP012		|Autor: Vanilson Souza 						|	01/08/09	 |
+====================================================================================+
|Programa utilizado para gerar c�digo EAN (FAKE) para produtos que n�o possuem       |
| EAN.   																			 |
|													                                 |
+====================================================================================+
|Uso: Laselva                                        								 |
+====================================================================================+  
*/                                                              
     
User Function CADG001( )

Local cCod    := ""
Local cVldCod := .F.
Local cEan    := ""
Local cEdi    := "" 
Local cGrupo  := "" 
Local cEanVld := ""

	cCodBar    := AllTrim( M->B1_CODBAR ) 
	cCod       := AllTrim( M->B1_COD )

   
   	If Inclui
   	
   	   cGrupo := M->B1_GRUPO 
   	
   	Else 
   	
   	   dbSelectArea("SB1")
       SB1->( dbSetOrder(1) )
       SB1->( dbSeek(xFilial("SB1") + B1_COD) )
   	   
   	   cGrupo := SB1-> B1_GRUPO 
   	   
   	   	   	
   	Endif
	
	If !cGrupo $ "104/0104/0103/0102/0101/0100/9999"
	
		If Len ( cCodBar ) < 13 .OR. cCodBar $ "0000000000000000000" .OR. Empty( cCodBar ) 
			
			cCodBar := AllTrim( cCod )
			cEan := geraEAN( AllTrim( cCodBar ) )
		
		Else
	
			cEan := Substr( AllTrim(cCodBar), 1, 13 )
			cEdi := Substr( AllTrim(cCodBar), 14, 19 )
	
		EndIf

		If vldCodBar( cEan )
			cEanVld := Left( AllTrim( cEan ) + AllTrim( cEdi ) + Space( TamSx3( "B1_CODBAR" )[1] ), TamSx3( "B1_CODBAR" )[1] )
			//cVldCod :=	.T.
		Else
			MsgInfo( "O Ean Digitado � inv�lido!" )
			//cVldCod := .F.
		Endif
    
    //cVldCod := .T.
    
    Endif

Return cEanVld



// Fun��o Utilizada para gera��o do codigo EAN a partir de um c�digo com no m�ximo 11 Digitos
Static Function geraEAN( cCodPro )

Local cEan  	:= "2"
Local nCalc 	:= 0
Local nDigito   := 0
                            

If !Len( cCodPro ) > 11
	
	cEan += Strzero( Val( cCodPro ), 11 )
	
	For nX := Len( cEan ) To 1 Step -1 // Multiplica da direita para esquerda as posi��es PAR por 3 e as IMPAR por 1, somando todas no variavel nCalc
		
		If nX % 2 == 0
			
			nCalc += Val( SubsTR( cEan, nx,1 ) ) * 3
			
		Else
			
			nCalc +=  Val( SubsTR( cEan,nx,1 ) )
			
		EndIF
		
	Next
	
	nDigito :=  ( Ceiling(nCalc/10) * 10 ) -  nCalc 
	cEan	+= cValToChar( nDigito )
	
Else
	
	MsgInfo( "Para gera��o do EAN o C�digo deve ter no M�ximo 11 Digitos!" )
	
Endif
Return cEan


// Verifica se EAN digitado � v�lido
Static Function vldCodBar( cCodBar )  //Efetua a Valida��o de C�digo de Barra tipo EAN13

Local nCalc   := 0
Local nDigito := 0
Local lVld    := .F.
//cCodBar       := "4905524523158"

For nX := Len( cCodBar ) -1 To 1 Step -1 // Multiplica da direita para esquerda as posi��es PAR por 3 e as IMPAR por 1, somando todas no variavel nCalc
	
	If nX % 2 == 0
		
		nCalc += Val( SubsTR( cCodBar,nx,1 ) ) * 3
		
	Else
		
		nCalc +=  Val( SubsTR( cCodBar,nx,1 ) )
		
	EndIF
	
Next
     
//Ceiling calcula o valor mais pr�ximo poss�vel de um valor nCalc informado como par�metro para a fun��o.
nDigito :=  ( Ceiling(nCalc/10) * 10 ) -  nCalc // O resultado da soma dos digitos � arredondado para o multiplo de 10 imediatamente superior, logo ap�s subtraido do valor n�o arredondado.
lVld := IIF( SubsTR( cCodBar,13,1 ) == cValTochar( nDigito ), .T. , .F. )

Return lVld

Return

