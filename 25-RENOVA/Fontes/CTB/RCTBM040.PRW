//#Include "Ctbr040.Ch"
#Include "PROTHEUS.Ch"

#DEFINE 	COL_SEPARA1			1
#DEFINE 	COL_CONTA 			2
#DEFINE 	COL_SEPARA2			3
#DEFINE 	COL_DESCRICAO		4
#DEFINE 	COL_SEPARA3			5
#DEFINE 	COL_SALDO_ANT    	6
#DEFINE 	COL_SEPARA4			7           

#DEFINE 	COL_VLR_DEBITO   	8
#DEFINE 	COL_SEPARA5			9 
#DEFINE 	COL_VLR_CREDITO  	10
#DEFINE 	COL_SEPARA6			11
#DEFINE 	COL_MOVIMENTO 		12
#DEFINE 	COL_SEPARA7			13                                                                                       
#DEFINE 	COL_SALDO_ATU 		14
#DEFINE 	COL_SEPARA8			15   

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ Ctbr040	³ Autor ³ Pilar S Albaladejo	³ Data ³ 12.09.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Balancete Analitico Sintetico Modelo 1			 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctbr040()                               			 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso    	 ³ Generico     											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RCtbM040()

PRIVATE titulo		:= ""
Private nomeprog	:= "RCTBM040"

//AjustSx1()
/*
If FindFunction("TRepInUse") .And. TRepInUse() 
	U_CTBR040R4()
Else
	Return U_CTBR040R3()
*/
	//U_CTBR040R3() //03-05-2010
	U_CTBR040R3() //07-05-2010

//EndIf

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ CTBR040R4 ³ Autor³ Daniel Sakavicius		³ Data ³ 01/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Balancete Analitico Sintetico Modelo 1 - R4                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ CTBR040R4												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGACTB                                    				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

User Function CTBR040R4()

Local nQuadro

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aQuadro := { "","","","","","","",""}              

For nQuadro :=1 To Len(aQuadro)
	aQuadro[nQuadro] := Space(Len(CriaVar("CT1_CONTA")))
Next	

CtbCarTxt()


//Pergunte("RCTBM040",.F.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria as perguntas no SX1                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cPerg := PADR( "RCTBM040" , LEN( SX1->X1_GRUPO ) )
ValidPerg()
If !Pergunte(cPerg,.T.)
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros								  ³
//³ u_mv_par01				// Data Inicial                  	  		  ³
//³ u_mv_par02				// Data Final                        		  ³
//³ u_mv_par03				// Conta Inicial                         	  ³
//³ u_mv_par04				// Conta Final  							  ³
//³ u_mv_par05				// Imprime Contas: Sintet/Analit/Ambas   	  ³
//³ u_mv_par06				// Set Of Books				    		      ³
//³ u_mv_par07				// Saldos Zerados?			     		      ³
//³ u_mv_par08				// Moeda?          			     		      ³
//³ u_mv_par09				// Pagina Inicial  		     		    	  ³
//³ u_mv_par10				// Saldos? Reais / Orcados	/Gerenciais   	  ³
//³ u_mv_par11				// Quebra por Grupo Contabil?		    	  ³
//³ u_mv_par12				// Filtra Segmento?					    	  ³
//³ u_mv_par13				// Conteudo Inicial Segmento?		   		  ³
//³ u_mv_par14				// Conteudo Final Segmento?		    		  ³
//³ u_mv_par15				// Conteudo Contido em?				    	  ³
//³ u_mv_par16				// Imprime Coluna Mov ?				    	  ³
//³ u_mv_par17				// Salta linha sintetica ?			    	  ³
//³ u_mv_par18				// Imprime valor 0.00    ?			    	  ³
//³ u_mv_par19				// Imprimir Codigo? Normal / Reduzido  		  ³
//³ u_mv_par20				// Divide por ?                   			  ³
//³ u_mv_par21				// Imprimir Ate o segmento?			   		  ³
//³ u_mv_par22				// Posicao Ant. L/P? Sim / Nao         		  ³
//³ u_mv_par23				// Data Lucros/Perdas?                 		  ³
//³ u_mv_par24				// Imprime Quadros Contábeis?				  ³		
//³ u_mv_par25				// Rec./Desp. Anterior Zeradas?				  ³		
//³ u_mv_par26				// Grupo Receitas/Despesas?      			  ³		
//³ u_mv_par27				// Data de Zeramento Receita/Despesas?		  ³		
//³ u_mv_par28              // Num.linhas p/ o Balancete Modelo 1		  ³ 
//³ u_mv_par29				// Descricao na moeda?						  ³		
//³ u_mv_par30				// Filial ?					             	  ³		
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cMes 	:= StrZero( Month( MV_Par05 ), 2 )
cAno 	:= StrZero( Year( MV_Par05 ), 4 )
dDataI 	:= CToD( "01" + "/" + cMes + "/" + cAno )

u_mv_par01	:= dDataI 					// Data Inicial                  	  	
u_mv_par02	:= MV_Par05 				// Data Final                        		
u_mv_par03	:= "1                   " 	// Conta Inicial                         	
u_mv_par04	:= "99999999999999999999" 	// Conta Final  				
u_mv_par05	:= 3 						// Imprime Contas: Sintet/Analit/Ambas   	
u_mv_par06	:= Space(03) 				// Set Of Books				    	
u_mv_par07	:= 1 						// Saldos Zerados: Sim/Nao
u_mv_par08	:= "01"						// Moeda?          			     	
u_mv_par09	:= "     2" 				// Pagina Inicial  		     		
u_mv_par10	:= "1"						// Saldos? Reais / Orcados	/Gerenciais   	
u_mv_par11	:= 3 						// Quebra por Grupo Contabil?: por Grupo      / por Codigo     /Nao Quebra     
u_mv_par12	:= Space(02) 				// Filtra Segmento?				
u_mv_par13	:= Space(20) 				// Conteudo Inicial Segmento?		   	
u_mv_par14	:= Space(20) 				// Conteudo Final Segmento?		    	
u_mv_par15	:= Space(30) 				// Conteudo Contido em?				
u_mv_par16	:= 1 						// Imprime Coluna Mov ? : Sim / Nao
u_mv_par17	:= 2 						// Salta linha sintetica ?	: Sim / Nao		
u_mv_par18	:= 1 						// Imprime valor 0.00    ?	:		Sim / Nao		
u_mv_par19	:= 1 						// Imprimir Codigo? Normal / Reduzido 
u_mv_par20	:= 1 						// Divide por ? : Nao se aplica / Cem / Mil / Milhao         
u_mv_par21	:= Space(01) 				// Imprimir Ate o segmento?			
u_mv_par22	:= 2 						// Posicao Ant. L/P? Sim / Nao         		
u_mv_par23	:= CToD("  /  /  ") 		// Data Lucros/Perdas?                 		
u_mv_par24	:= 2 						// Imprime Quadros Contábeis? : Sim / Nao
u_mv_par25	:= 2 						// Rec./Desp. Anterior Zeradas? : Sim / Nao
u_mv_par26	:= Space(9) 				// Grupo Receitas/Despesas?      		
u_mv_par27	:= CToD("  /  /  ") 		// Data de Zeramento Receita/Despesas?		
u_mv_par28	:= 40 						//Num.linhas p/ o Balancete Modelo 1		
u_mv_par29	:= "01" 					// Descricao na moeda?			
u_mv_par30	:= "CT7_FILIAL >= '01' AND CT7_FILIAL <= 'ZZ' " // Filiais? : "CT7_FILIAL" / "01-ZZ"

oReport := ReportDef()

If Valtype( oReport ) == 'O'
	If ! Empty( oReport:uParam )
		Pergunte( oReport:uParam, .F. )
	EndIf	
	
	oReport:PrintDialog()      
Endif
	
oReport := Nil

Return()
*/

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Daniel Sakavicius		³ Data ³ 28/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Esta funcao tem como objetivo definir as secoes, celulas,   ³±±
±±³          ³totalizadores do relatorio que poderao ser configurados     ³±±
±±³          ³pelo relatorio.                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGACTB                                    				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

local aArea	   		:= GetArea()   
Local CREPORT		:= "RCTBM040"
Local CTITULO		:= "Emissao Balancete Modelo Padrao "
Local CDESC			:= "Este programa ira gerar o arquivo para exportação"
Local cPerg	   		:= "RCTBM040" 
Local CCOLBAR		:= "|"                   
Local aTamConta		:= TAMSX3("CT1_CONTA")    
Local aTamVal		:= TAMSX3("CT2_VALOR")
Local aTamDesc		:= {40}  
Local cPictVal 		:= PesqPict("CT2","CT2_VALOR")
Local nDecimais
Local cMascara		:= ""
Local cSeparador	:= ""
Local nTamConta		:= 30
Local nSomaCol		:= 5
Local aSetOfBook
Local nMaskFator 	:= 1
Private oReport		:= Nil

// Efetua a pergunta antes de montar a configuração do relatorio, afim de poder definir o layout a ser impresso
//Pergunte( "RCTBM040" , .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria as perguntas no SX1                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cPerg := PADR( "RCTBM040" , LEN( SX1->X1_GRUPO ) )
ValidPerg()
If !Pergunte(cPerg,.T.)
	Return()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros								  ³
//³ u_mv_par01				// Data Inicial                  	  		  ³
//³ u_mv_par02				// Data Final                        		  ³
//³ u_mv_par03				// Conta Inicial                         	  ³
//³ u_mv_par04				// Conta Final  							  ³
//³ u_mv_par05				// Imprime Contas: Sintet/Analit/Ambas   	  ³
//³ u_mv_par06				// Set Of Books				    		      ³
//³ u_mv_par07				// Saldos Zerados?			     		      ³
//³ u_mv_par08				// Moeda?          			     		      ³
//³ u_mv_par09				// Pagina Inicial  		     		    	  ³
//³ u_mv_par10				// Saldos? Reais / Orcados	/Gerenciais   	  ³
//³ u_mv_par11				// Quebra por Grupo Contabil?		    	  ³
//³ u_mv_par12				// Filtra Segmento?					    	  ³
//³ u_mv_par13				// Conteudo Inicial Segmento?		   		  ³
//³ u_mv_par14				// Conteudo Final Segmento?		    		  ³
//³ u_mv_par15				// Conteudo Contido em?				    	  ³
//³ u_mv_par16				// Imprime Coluna Mov ?				    	  ³
//³ u_mv_par17				// Salta linha sintetica ?			    	  ³
//³ u_mv_par18				// Imprime valor 0.00    ?			    	  ³
//³ u_mv_par19				// Imprimir Codigo? Normal / Reduzido  		  ³
//³ u_mv_par20				// Divide por ?                   			  ³
//³ u_mv_par21				// Imprimir Ate o segmento?			   		  ³
//³ u_mv_par22				// Posicao Ant. L/P? Sim / Nao         		  ³
//³ u_mv_par23				// Data Lucros/Perdas?                 		  ³
//³ u_mv_par24				// Imprime Quadros Contábeis?				  ³		
//³ u_mv_par25				// Rec./Desp. Anterior Zeradas?				  ³		
//³ u_mv_par26				// Grupo Receitas/Despesas?      			  ³		
//³ u_mv_par27				// Data de Zeramento Receita/Despesas?		  ³		
//³ u_mv_par28              // Num.linhas p/ o Balancete Modelo 1		  ³ 
//³ u_mv_par29				// Descricao na moeda?						  ³		
//³ u_mv_par30				// Filial ?					             	  ³		
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cMes 	:= StrZero( Month( MV_Par05 ), 2 )
cAno 	:= StrZero( Year( MV_Par05 ), 4 )
dDataI 	:= CToD( "01" + "/" + cMes + "/" + cAno )

u_mv_par01	:= dDataI 					// Data Inicial                  	  	
u_mv_par02	:= MV_Par05 				// Data Final                        		
u_mv_par03	:= "1                   " 	// Conta Inicial                         	
u_mv_par04	:= "99999999999999999999" 	// Conta Final  				
u_mv_par05	:= 3 						// Imprime Contas: Sintet/Analit/Ambas   	
u_mv_par06	:= Space(03) 				// Set Of Books				    	
u_mv_par07	:= 1 						// Saldos Zerados: Sim/Nao
u_mv_par08	:= "01"						// Moeda?          			     	
u_mv_par09	:= "     2" 				// Pagina Inicial  		     		
u_mv_par10	:= "1"						// Saldos? Reais / Orcados	/Gerenciais   	
u_mv_par11	:= 3 						// Quebra por Grupo Contabil?: por Grupo      / por Codigo     /Nao Quebra     
u_mv_par12	:= Space(02) 				// Filtra Segmento?				
u_mv_par13	:= Space(20) 				// Conteudo Inicial Segmento?		   	
u_mv_par14	:= Space(20) 				// Conteudo Final Segmento?		    	
u_mv_par15	:= Space(30) 				// Conteudo Contido em?				
u_mv_par16	:= 1 						// Imprime Coluna Mov ? : Sim / Nao
u_mv_par17	:= 2 						// Salta linha sintetica ?	: Sim / Nao		
u_mv_par18	:= 1 						// Imprime valor 0.00    ?	:		Sim / Nao		
u_mv_par19	:= 1 						// Imprimir Codigo? Normal / Reduzido 
u_mv_par20	:= 1 						// Divide por ? : Nao se aplica / Cem / Mil / Milhao         
u_mv_par21	:= Space(01) 				// Imprimir Ate o segmento?			
u_mv_par22	:= 2 						// Posicao Ant. L/P? Sim / Nao         		
u_mv_par23	:= CToD("  /  /  ") 		// Data Lucros/Perdas?                 		
u_mv_par24	:= 2 						// Imprime Quadros Contábeis? : Sim / Nao
u_mv_par25	:= 2 						// Rec./Desp. Anterior Zeradas? : Sim / Nao
u_mv_par26	:= Space(9) 				// Grupo Receitas/Despesas?      		
u_mv_par27	:= CToD("  /  /  ") 		// Data de Zeramento Receita/Despesas?		
u_mv_par28	:= 40 						//Num.linhas p/ o Balancete Modelo 1		
u_mv_par29	:= "01" 					// Descricao na moeda?			
u_mv_par30	:= "CT7_FILIAL >= '01' AND CT7_FILIAL <= 'ZZ' " // Filiais? : "CT7_FILIAL" / "01-ZZ"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
//³ Gerencial -> montagem especifica para impressao)	    	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ! U_ct040Valid( u_mv_par06 )
	Return .F.
Else
   aSetOfBook := CTBSetOf( u_mv_par06 )
Endif

cMascara := RetMasCtb( aSetOfBook[2], @cSeparador )

If ! Empty( cMascara )
	nTamConta := aTamConta[1] + ( Len( Alltrim( cMascara ) ) / 2 )
Else
	nTamConta := aTamConta[1]
EndIf

cPicture := aSetOfBook[4]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//"Este programa tem o objetivo de emitir o Cadastro de Itens Classe de Valor "
//"Sera impresso de acordo com os parametros solicitados pelo"
//"usuario"
oReport	:= TReport():New( cReport,Capital(CTITULO),CPERG, { |oReport| Pergunte(cPerg , .F. ), If(! ReportPrint( oReport ), oReport:CancelPrint(), .T. ) }, CDESC ) 
oReport:ParamReadOnly()

IF GETNEWPAR("MV_CTBPOFF",.T.)
	oReport:SetEdit(.F.)
ENDIF	

// Controle do tamanho da conta, caso a mesma ultrapasse o tamanho definido de 20, muda o relatorio para o modo paisagem
If nTamConta > 30
	oReport:SetLandScape(.T.)
    nSomaCol := 20
Endif     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1  := TRSection():New( oReport, "Plano de Contas", {"cArqTmp","CT1"},, .F., .F. ) //"Plano de contas"

TRCell():New( oSection1, "CONTA"	,,"CONTA"/*Titulo*/	,/*Picture*/, nTamConta	 + 5		/*Tamanho*/, /*lPixel*/, /*CodeBlock*/  )
TRCell():New( oSection1, "DESCCTA"  ,,"DECCTA"/*Titulo*/	,/*Picture*/, aTamDesc[1]+ nSomaCol	/*Tamanho*/, /*lPixel*/, /*CodeBlock*/  )
TRCell():New( oSection1, "SALDOANT" ,,"SALDOANT"/*Titulo*/	,/*Picture*/, aTamVal[1] + nSomaCol	/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"RIGHT")
TRCell():New( oSection1, "SALDODEB" ,,"SALDODEB"/*Titulo*/	,/*Picture*/, aTamVal[1] + nSomaCol	/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"RIGHT")
TRCell():New( oSection1, "SALDOCRD" ,,"SALDOCRD"/*Titulo*/	,/*Picture*/, aTamVal[1] + nSomaCol	/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"RIGHT")
TRCell():New( oSection1, "MOVIMENTO",,"MOVIMENTO"/*Titulo*/	,/*Picture*/, aTamVal[1] + nSomaCol	/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"RIGHT")
TRCell():New( oSection1, "SALDOATU" ,,"SALDOATU"/*Titulo*/	,/*Picture*/, aTamVal[1] + nSomaCol	/*Tamanho*/, /*lPixel*/, /*CodeBlock*/, "RIGHT",,"RIGHT")
                                                                                 
TRPosition():New( oSection1, "CT1", 1, {|| xFilial( "CT1" ) + cArqTMP->CONTA })

oSection1:SetTotalInLine(.F.)          
oSection1:SetTotalText('') //STR0011) //"T O T A I S  D O  P E R I O D O: "

Return( oReport )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³ Daniel Sakavicius	³ Data ³ 28/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Imprime o relatorio definido pelo usuario de acordo com as  ³±±
±±³          ³secoes/celulas criadas na funcao ReportDef definida acima.  ³±±
±±³          ³Nesta funcao deve ser criada a query das secoes se SQL ou   ³±±
±±³          ³definido o relacionamento e filtros das tabelas em CodeBase.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ReportPrint(oReport)                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³EXPO1: Objeto do relatório                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint( oReport )  

Local oSection1 	:= oReport:Section(1) 
Local lExterno		:= .F.   
Local aSetOfBook
Local dDataFim 		:= u_mv_par02
Local lFirstPage	:= .T.
Local lJaPulou		:= .F.
Local lRet			:= .T.
Local lPrintZero	:= (u_mv_par18==1)
Local lPula			:= (u_mv_par17==1) 
Local lNormal		:= (u_mv_par19==1)
Local lVlrZerado	:= (u_mv_par07==1)
Local lQbGrupo		:= (u_mv_par11==1) 
Local lQbConta		:= (u_mv_par11==2)
Local l132			:= .T.
Local nDecimais
Local nDivide		:= 1
Local nTotDeb		:= 0
Local nTotCrd		:= 0
Local nTotMov		:= 0
Local nGrpDeb		:= 0
Local nGrpCrd		:= 0                     
Local cSegAte   	:= u_mv_par21
Local nDigitAte		:= 0
Local lImpAntLP		:= (u_mv_par22 == 1)
Local dDataLP		:= u_mv_par23
Local lImpSint		:= Iif(u_mv_par05=1 .Or. u_mv_par05 ==3,.T.,.F.)
Local lRecDesp0		:= (u_mv_par25 == 1)
Local lImpMov		:= (u_mv_par16 == 1)
Local cRecDesp		:= u_mv_par26
Local dDtZeraRD		:= u_mv_par27
Local n
Local oMeter
Local oText
Local oDlg
Local oBreak
Local lImpPaisgm	:= .F.	
Local nMaxLin   	:= u_mv_par28
Local cMoedaDsc		:= u_mv_par29
Local aCtbMoeda		:= {}
Local aCtbMoedadsc	:= {}
Local CCOLBAR		:= "|"                   
Local cTipoAnt		:= ""
Local cGrupoAnt		:= ""
Local cArqTmp		:= ""
Local Tamanho		:= "M"
Local cSeparador	:= ""
Local aTamVal		:= TAMSX3("CT2_VALOR")
Local oTotDeb		
Local oTotCrd
Local oTotGerDeb		
Local oTotGerCrd
Local cPicture
Local cContaSint
Local cBreak		:= "2"
Local cGrupo		:= ""
Local nTotGerDeb	:= 0
Local nTotGerCrd	:= 0
Local nTotGerMov	:= 0
Local nCont			:= 0
Local cFilUser		:= ""
Local cRngFil		:= Nil // GetRngFil( "CTR040" , "u_mv_par30" )
Local nMasc			:= 0
Local cMasc			:= ""

Private nLinReport    := 9




//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
//³ Gerencial -> montagem especifica para impressao)	    	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ! U_ct040Valid( u_mv_par06 )
	Return .F.
Else
   aSetOfBook := CTBSetOf(u_mv_par06)
Endif

If u_mv_par20 == 2			// Divide por cem
	nDivide := 100
ElseIf u_mv_par20 == 3		// Divide por mil
	nDivide := 1000
ElseIf u_mv_par20 == 4		// Divide por milhao
	nDivide := 1000000
EndIf	     

If lRet
	aCtbMoeda := CtbMoeda( u_mv_par08 , nDivide )

	If Empty(aCtbMoeda[1])                       
		Help(" ",1,"NOMOEDA")
		lRet := .F.
		Return lRet
	Endif

    // validação da descrição da moeda
	if lRet .And. ! Empty( u_mv_par29 ) .and. u_mv_par29 <> nil
		aCtbMoedadsc := CtbMoeda( u_mv_par29 , nDivide )

		If Empty( aCtbMoedadsc[1] )                       
    		Help( " " , 1 , "NOMOEDA")
	        lRet := .F.
    	    Return lRet
	    Endif
	Endif
Endif

If lRet
	If (u_mv_par25 == 1) .and. ( Empty(u_mv_par26) .or. Empty(u_mv_par27) )
		cMensagem	:= "Favor preencher os parametros Grupos Receitas/Despesas e "
		cMensagem	+= "Data Sld Ant. Receitas/Desp. "
		MsgAlert(cMensagem,"Ignora Sl Ant.Rec/Des")
		lRet    	:= .F.	
	    Return lRet
    EndIf
EndIf

aCtbMoeda  	:= CtbMoeda(u_mv_par08,nDivide)                

cDescMoeda 	:= Alltrim(aCtbMoeda[2])
nDecimais 	:= DecimalCTB(aSetOfBook,u_mv_par08)

If Empty(aSetOfBook[2])
	cMascara := GetMv("MV_MASCARA")
Else
	cMascara 	:= RetMasCtb(aSetOfBook[2],@cSeparador)
EndIf
cPicture 		:= aSetOfBook[4]

lPrintZero	:= Iif(u_mv_par18==1,.T.,.F.)

IF u_mv_par05 == 1
	Titulo:=	OemToAnsi("BALANCETE MODELO PADRAO")
ElseIf u_mv_par05 == 2
	Titulo:=	OemToAnsi("BALANCETE MODELO PADRAO")
ElseIf u_mv_par05 == 3
	Titulo:=	OemToAnsi("BALANCETE MODELO PADRAO")
EndIf
Titulo += 	DTOC(u_mv_par01) + OemToAnsi("") + Dtoc(u_mv_par02) + ;
			OemToAnsi("") + cDescMoeda + CtbTitSaldo(u_mv_par10)           

oReport:SetPageNumber( u_mv_par09 )
oReport:SetCustomText( {|| nCtCGCCabTR(dDataFim,titulo,oReport)})

cFilUser := oSection1:GetAdvplExpr("CT1")    
If Empty(cFilUser)
	cFilUser := ".T."
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Arquivo Temporario para Impressao			  		     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lExterno  .or. IsBlind()
	CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
				u_mv_par01,u_mv_par02,"CT7","",u_mv_par03,u_mv_par04,,,,,,,u_mv_par08,;
				u_mv_par10,aSetOfBook,u_mv_par12,u_mv_par13,u_mv_par14,u_mv_par15,;
				.F.,.F.,u_mv_par11,,lImpAntLP,dDataLP,nDivide,lVlrZerado,,,,,,,,,,,,,,lImpSint,cFilUser,lRecDesp0,;
				cRecDesp,dDtZeraRD,,,,,,,cMoedaDsc,,cRngFil)
Else
	MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
					CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
					u_mv_par01,u_mv_par02,"CT7","",u_mv_par03,u_mv_par04,,,,,,,u_mv_par08,;
					u_mv_par10,aSetOfBook,u_mv_par12,u_mv_par13,u_mv_par14,u_mv_par15,;
					.F.,.F.,u_mv_par11,,lImpAntLP,dDataLP,nDivide,lVlrZerado,,,,,,,,,,,,,,lImpSint,cFilUser,lRecDesp0,;
					cRecDesp,dDtZeraRD,,,,,,,cMoedaDsc,,cRngFil)},;
					OemToAnsi(OemToAnsi("Criando Arquivo Tempor rio...")),;  //
					OemToAnsi("Balancete Modelo Padrao"))  				//
EndIf                                                          
                
nCount := cArqTmp->(RecCount())

oReport:SetMeter(nCont)

lRet := !(nCount == 0 .And. !Empty(aSetOfBook[5]))

If lRet
	                          
	// Verifica Se existe filtragem Ate o Segmento
	If ! Empty( cSegAte )
		
		//Efetua tratamento da mascara para consegui efetuar o controle do segmento 
		For nMasc := 1 to Len( cMascara )
			
			cMasc += "0"+SubStr( cMascara,nMasc,1 )
			
		Next nMasc
	
	
		nDigitAte := CtbRelDig( cSegAte, cMasc ) 	

		oSection1:SetFilter( 'Len(Alltrim(cArqTmp->CONTA)) <= ' + alltrim( Str( nDigitAte )) )  
	EndIf	

	cArqTmp->(dbGoTop())
	
	If lNormal
		oSection1:Cell("CONTA"):SetBlock( {|| EntidadeCTB(cArqTmp->CONTA,000,000,030,.F.,cMascara,cSeparador,,,.F.,,.F.)} )
	Else
		oSection1:Cell("CONTA"):SetBlock( {|| cArqTmp->CTARES } )
	EndIf	
	
	oSection1:Cell("DESCCTA"):SetBlock( { || cArqTMp->DESCCTA } )
	
	oSection1:Cell("SALDOANT"):SetBlock( { || ValorCTB(cArqTmp->SALDOANT,,,aTamVal[1],nDecimais,.T.,cPicture,"2",,,,,,lPrintZero,.F.) } )
	oSection1:Cell("SALDODEB"):SetBlock( { || ValorCTB(cArqTmp->SALDODEB,,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) } )
	oSection1:Cell("SALDOCRD"):SetBlock( { || ValorCTB(cArqTmp->SALDOCRD,,,aTamVal[1],nDecimais,.F.,cPicture,"2",,,,,,lPrintZero,.F.) } )
	oSection1:Cell("SALDOATU"):SetBlock( { || ValorCTB(cArqTmp->SALDOATU,,,aTamVal[1],nDecimais,.T.,cPicture,"2",,,,,,lPrintZero,.F.) } )
	    
	// Imprime Movimento
	If !lImpMov
		oSection1:Cell("MOVIMENTO"):Disable()
	Else
		oSection1:Cell("MOVIMENTO"):SetBlock( { || ValorCTB(cArqTmp->MOVIMENTO,,,aTamVal[1],nDecimais,.T.,cPicture,cArqTmp->NORMAL,,,,,, lPrintZero,.F.) } )
	EndIf
	
	If lQbGrupo
	
		oBreak := TRBreak():New(oSection1, { || cArqTmp->GRUPO },{|| " T O T A I S "+" "+ RTrim( Upper(AllTrim(cGrupo) )) + " )" },,,.T.)	//	
		oBreak:OnBreak( { |x| cGrupo := x } )
	
		oTotDeb := TRFunction():New(oSection1:Cell("SALDODEB"),,"SUM",oBreak/*oBreak*/,/*Titulo*/,/*cPicture*/,;
			{ || Iif(cArqTmp->TIPOCONTA="1",0,cArqTmp->SALDODEB) },.T.,.F.,.F.,oSection1)
		
		oTotCrd := TRFunction():New(oSection1:Cell("SALDOCRD"),,"SUM",oBreak/*oBreak*/,/*Titulo*/,/*cPicture*/,;
			{ || Iif(cArqTmp->TIPOCONTA="1",0,cArqTmp->SALDOCRD) },.T.,.F.,.F.,oSection1)
		
		oTotGerDeb := TRFunction():New(oSection1:Cell("SALDODEB"),,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
			{ || Iif(cArqTmp->TIPOCONTA="1",0,cArqTmp->SALDODEB) },.F.,.F.,.F.,oSection1)
		
		oTotGerCrd := TRFunction():New(oSection1:Cell("SALDOCRD"),,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
			{ || Iif(cArqTmp->TIPOCONTA="1",0,cArqTmp->SALDOCRD) },.F.,.F.,.F.,oSection1)
	
		TRFunction():New(oSection1:Cell("SALDODEB"),,"ONPRINT",oBreak/*oBreak*/,/*Titulo*/,/*cPicture*/,;
			{ |lSection,lReport,lPage| If(!lSection,ValorCTB(oTotDeb:GetValue(),,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.),;
			ValorCTB(oTotGerDeb:GetValue(),,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.)) },.T.,.F.,.F.,oSection1 )
		
		TRFunction():New(oSection1:Cell("SALDOCRD"),,"ONPRINT",oBreak/*oBreak*/,/*Titulo*/,/*cPicture*/,;
			{ |lSection,lReport,lPage| If(!lSection,ValorCTB(oTotCrd:GetValue(),,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.),;
			ValorCTB(oTotGerCrd:GetValue(),,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.)) },.T.,.F.,.F.,oSection1 )
		                                                              
		If lImpMov
		
			// Totais de Movimentos                           
			TRFunction():New(oSection1:Cell("MOVIMENTO"),,"ONPRINT", oBreak/*oBreak*/,/*cTitulo*/,/*[ cPicture ]*/,;
				{ |lSection,lReport,lPage| If( !lSection,;
				(nTotMov := (oTotCrd:GetValue() - oTotDeb:GetValue())),;
				(nTotMov := (oTotGerCrd:GetValue()-oTotGerDeb:GetValue())) ),;
				ValorCTB(nTotMov,,,aTamVal[1]+3,nDecimais,.T.,cPicture,Iif( nTotMov < 0,"1","2"),,,,,, lPrintZero,.F.)},.T.,;
				.F.,.F.,oSection1)
		
		EndIf
		
		oTotGerDeb:Disable()
		oTotGerCrd:Disable()
	
	Else
	           
		oTotDeb := TRFunction():New(oSection1:Cell("SALDODEB"),,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
			{ || Iif(cArqTmp->TIPOCONTA="1",0,cArqTmp->SALDODEB) },.T.,.F.,.F.,oSection1)
	
		oTotCrd := TRFunction():New(oSection1:Cell("SALDOCRD"),,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
			{ || Iif(cArqTmp->TIPOCONTA="1",0,cArqTmp->SALDOCRD) },.T.,.F.,.F.,oSection1)
	
		TRFunction():New(oSection1:Cell("DESCCTA"),,"ONPRINT",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
			{ || "" },.T.,.F.,.F.,oSection1 )

		TRFunction():New(oSection1:Cell("SALDODEB"),,"ONPRINT",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
			{ || ValorCTB(oTotDeb:GetValue(),,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) },.T.,.F.,.F.,oSection1 )
		
		TRFunction():New(oSection1:Cell("SALDOCRD"),,"ONPRINT",/*oBreak*/,/*Titulo*/,/*cPicture*/,;
			{ || ValorCTB(oTotCrd:GetValue(),,,aTamVal[1],nDecimais,.F.,cPicture,"1",,,,,,lPrintZero,.F.) },.T.,.F.,.F.,oSection1 )
		                                                              
		If lImpMov
			// Totais de Movimentos                           
			TRFunction():New(oSection1:Cell("MOVIMENTO"),,"ONPRINT", oBreak/*oBreak*/,/*cTitulo*/,/*[ cPicture ]*/,;
				{ || (nTotMov := (oTotCrd:GetValue() - oTotDeb:GetValue())),;
				ValorCTB(nTotMov,,,aTamVal[1]+3,nDecimais,.T.,cPicture,Iif( nTotMov < 0,"1","2"),,,,,, lPrintZero,.F.)},.T.,.F.,.F.,oSection1)
		EndIf
	
	Endif

	oSection1:OnPrintLine( {|| 	U_CTR040OnPrint( lPula, lQbConta, nMaxLin, @cTipoAnt, @nLinReport, @cGrupoAnt ) } )

	oTotDeb:Disable()
	oTotCrd:Disable()
	                                                                
	oSection1:Print()
	
	If u_mv_par24 ==1     
	    oReport:Section(1):SetHeaderSection(.F.)                                                       
		ImpQuadro(Tamanho,X3USO("CT2_DCD"),dDataFim,u_mv_par08,aQuadro,cDescMoeda,oReport:ClassName(),(If (lImpAntLP,dDataLP,cTod(""))),cPicture,nDecimais,lPrintZero,u_mv_par10,oReport)
	EndIf	

EndIf

dbSelectArea("cArqTmp")
Set Filter To
dbCloseArea()
If Select("cArqTmp") == 0
	FErase(cArqTmp+GetDBExtension())
	FErase(cArqTmp+OrdBagExt())
EndIF	

Return .T.

  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTR040OnPrint ºAutor ³ Gustavo Henrique º Data ³ 07/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Executa acoes especificadas nos parametros do relatorio,   º±±
±±º          ³ antes de imprimir cada linha.                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ EXPL1 - Indicar se deve saltar linha entre conta sintetica º±±
±±º          ³ EXPL2 - Indicar se deve quebrar pagina por conta           º±±
±±º          ³ EXPN3 - Informar o total de linhas por pagina do balancete º±±
±±º          ³ EXPC4 - Guardar o tipo da conta impressa (sint./analitica) º±±
±±º          ³ EXPN5 - Guardar linha atual do relatorio para validacao    º±±
±±º          ³         com o valor do parametro EXPN3.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ EXPL1 - Indicar se deve imprimir a linha (.T.)             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Contabilidade Gerencial                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CTR040OnPrint( lPula, lQbConta, nMaxLin, cTipoAnt, nLinReport )
                                                                        
Local lRet := .T.           

// Verifica salto de linha para conta sintetica (u_mv_par17)
If lPula .And. (cTipoAnt == "1" .Or. (cArqTmp->TIPOCONTA == "1" .And. cTipoAnt == "2"))
	oReport:SkipLine()
EndIf	

// Verifica quebra de pagina por conta (u_mv_par11)
If lQbConta .And. cArqTmp->NIVEL1
	oReport:EndPage()
	nLinReport := 9
	Return
EndIf	

// Verifica numero maximo de linhas por pagina (u_mv_par28)
If ! Empty(nMaxLin)
	CTR040MaxL(nMaxLin,@nLinReport)
EndIf	

cTipoAnt := cArqTmp->TIPOCONTA

If u_mv_par05 == 1		// Apenas sinteticas
	lRet := (cArqTmp->TIPOCONTA == "1")
ElseIf u_mv_par05 == 2	// Apenas analiticas
	lRet := (cArqTmp->TIPOCONTA == "2")
EndIf

Return lRet


/*
------------------------------------------------------------------------- RELEASE 3 -------------------------------------------------------------------------------
*/



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ Ctbr040R3³ Autor ³ Pilar S Albaladejo	³ Data ³ 12.09.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Balancete Analitico Sintetico Modelo 1			 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Ctbr040()                               			 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso    	 ³ Generico     											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CtbR040R3( wnRel )

Local aSetOfBook
Local aCtbMoeda	:= {}
LOCAL cDesc1 		:= OemToAnsi("Este programa ira gerar o arquivo Balancete Modelo Padrao (78 Colunas)") //, a")
LOCAL cDesc2 		:= ""//OemToansi("conta eh impressa limitando-se a 20 caracteres e sua descricao 30 caracteres,")
LOCAL cDesc3		:= ""//OemToansi("os valores impressao sao saldo anterior, debito, credito e saldo atual do periodo.")
LOCAL cString		:= "CT1"
Local cTitOrig		:= ""
Local lRet			:= .T.
Local nDivide		:= 1
Local lExterno 		:= wnRel <> Nil
Local nQuadro

PRIVATE Tamanho		:= "M"
PRIVATE nLastKey 	:= 0
PRIVATE cPerg	 	:= ""//"CTR040"
PRIVATE aReturn 	:= { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE aLinha		:= {}
PRIVATE nomeProg  	:= "RCTBM040"
PRIVATE titulo 		:= OemToAnsi("Balancete Modelo Padrao")
cTitOrig	:= titulo


Private aStructure 	:= {}
Private cArqTRB    	:= ""
Private cMes    	:= ""
Private cAno    	:= ""
Private _aStru		:= {}
Private _cArqTRB  	:= ""
Private cLinha  	:= ""
Private _cDirExp  	:= ""
Private cArquivo   	:= ""
Private _cArqExp  	:= ""
Private cDirDestino := ""
Private cMemo1 		:= ""
Private lCopiou 	:= .F.


If ( !AMIIn(34) )		// Acesso somente pelo SIGACTB
	Return
EndIf

li	:= 60 //80 

Private aQuadro := { "","","","","","","",""}              

For nQuadro :=1 To Len(aQuadro)
	aQuadro[nQuadro] := Space(Len(CriaVar("CT1_CONTA")))
Next	

CtbCarTxt()

//Pergunte("CTR040",.F.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria as perguntas no SX1                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cPerg := PADR( "RCTBM040" , LEN( SX1->X1_GRUPO ) )
ValidPerg()
If !Pergunte(cPerg,.T.)
	Return()
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros								  ³
//³ u_mv_par01				// Data Inicial                  	  		  ³
//³ u_mv_par02				// Data Final                        		  ³
//³ u_mv_par03				// Conta Inicial                         	  ³
//³ u_mv_par04				// Conta Final  							  ³
//³ u_mv_par05				// Imprime Contas: Sintet/Analit/Ambas   	  ³
//³ u_mv_par06				// Set Of Books				    		      ³
//³ u_mv_par07				// Saldos Zerados?			     		      ³
//³ u_mv_par08				// Moeda?          			     		      ³
//³ u_mv_par09				// Pagina Inicial  		     		    	  ³
//³ u_mv_par10				// Saldos? Reais / Orcados	/Gerenciais   	  ³
//³ u_mv_par11				// Quebra por Grupo Contabil?		    	  ³
//³ u_mv_par12				// Filtra Segmento?					    	  ³
//³ u_mv_par13				// Conteudo Inicial Segmento?		   		  ³
//³ u_mv_par14				// Conteudo Final Segmento?		    		  ³
//³ u_mv_par15				// Conteudo Contido em?				    	  ³
//³ u_mv_par16				// Imprime Coluna Mov ?				    	  ³
//³ u_mv_par17				// Salta linha sintetica ?			    	  ³
//³ u_mv_par18				// Imprime valor 0.00    ?			    	  ³
//³ u_mv_par19				// Imprimir Codigo? Normal / Reduzido  		  ³
//³ u_mv_par20				// Divide por ?                   			  ³
//³ u_mv_par21				// Imprimir Ate o segmento?			   		  ³
//³ u_mv_par22				// Posicao Ant. L/P? Sim / Nao         		  ³
//³ u_mv_par23				// Data Lucros/Perdas?                 		  ³
//³ u_mv_par24				// Imprime Quadros Contábeis?				  ³		
//³ u_mv_par25				// Rec./Desp. Anterior Zeradas?				  ³		
//³ u_mv_par26				// Grupo Receitas/Despesas?      			  ³		
//³ u_mv_par27				// Data de Zeramento Receita/Despesas?		  ³		
//³ u_mv_par28              // Num.linhas p/ o Balancete Modelo 1		  ³ 
//³ u_mv_par29				// Descricao na moeda?						  ³		
//³ u_mv_par30				// Filial ?					             	  ³		
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cMes 	:= StrZero( Month( MV_Par05 ), 2 )
cAno 	:= StrZero( Year( MV_Par05 ), 4 )
dDataI 	:= CToD( "01" + "/" + cMes + "/" + cAno )

u_mv_par01	:= dDataI 					// Data Inicial                  	  	
u_mv_par02	:= MV_Par05 				// Data Final                        		
u_mv_par03	:= "1                   " 	// Conta Inicial                         	
u_mv_par04	:= "99999999999999999999" 	// Conta Final  				
u_mv_par05	:= 3 						// Imprime Contas: Sintet/Analit/Ambas   	
u_mv_par06	:= Space(03) 				// Set Of Books				    	
u_mv_par07	:= 1 						// Saldos Zerados: Sim/Nao
u_mv_par08	:= "01"						// Moeda?          			     	
u_mv_par09	:= "     2" 				// Pagina Inicial  		     		
u_mv_par10	:= "1"						// Saldos? Reais / Orcados	/Gerenciais   	
u_mv_par11	:= 3 						// Quebra por Grupo Contabil?: por Grupo      / por Codigo     /Nao Quebra     
u_mv_par12	:= Space(02) 				// Filtra Segmento?				
u_mv_par13	:= Space(20) 				// Conteudo Inicial Segmento?		   	
u_mv_par14	:= Space(20) 				// Conteudo Final Segmento?		    	
u_mv_par15	:= Space(30) 				// Conteudo Contido em?				
u_mv_par16	:= 1 						// Imprime Coluna Mov ? : Sim / Nao
u_mv_par17	:= 2 						// Salta linha sintetica ?	: Sim / Nao		
u_mv_par18	:= 1 						// Imprime valor 0.00    ?	:		Sim / Nao		
u_mv_par19	:= 1 						// Imprimir Codigo? Normal / Reduzido 
u_mv_par20	:= 1 						// Divide por ? : Nao se aplica / Cem / Mil / Milhao         
u_mv_par21	:= Space(01) 				// Imprimir Ate o segmento?			
u_mv_par22	:= 2 						// Posicao Ant. L/P? Sim / Nao         		
u_mv_par23	:= CToD("  /  /  ") 		// Data Lucros/Perdas?                 		
u_mv_par24	:= 2 						// Imprime Quadros Contábeis? : Sim / Nao
u_mv_par25	:= 2 						// Rec./Desp. Anterior Zeradas? : Sim / Nao
u_mv_par26	:= Space(9) 				// Grupo Receitas/Despesas?      		
u_mv_par27	:= CToD("  /  /  ") 		// Data de Zeramento Receita/Despesas?		
u_mv_par28	:= 40 						//Num.linhas p/ o Balancete Modelo 1		
u_mv_par29	:= "01" 					// Descricao na moeda?			
u_mv_par30	:= "CT7_FILIAL >= '01' AND CT7_FILIAL <= 'ZZ' " // Filiais? : "CT7_FILIAL" / "01-ZZ"

If ! lExterno
	wnrel	:= "RCTBM040"            //Nome Default do relatorio em Disco
	wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)
Endif

If nLastKey == 27
	Set Filter To
	Return
Endif  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se usa Set Of Books + Plano Gerencial (Se usar Plano³
//³ Gerencial -> montagem especifica para impressao)				  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !U_ct040Valid(u_mv_par06)
	lRet := .F.
Else
   aSetOfBook := CTBSetOf(u_mv_par06)
Endif

If u_mv_par20 == 2			// Divide por cem
	nDivide := 100
ElseIf u_mv_par20 == 3		// Divide por mil
	nDivide := 1000
ElseIf u_mv_par20 == 4		// Divide por milhao
	nDivide := 1000000
EndIf	

If lRet
	aCtbMoeda  	:= CtbMoeda(u_mv_par08,nDivide)
	If Empty(aCtbMoeda[1])                       
      Help(" ",1,"NOMOEDA")
      lRet := .F.
   Endif
Endif

If lRet
	If (u_mv_par25 == 1) .and. ( Empty(u_mv_par26) .or. Empty(u_mv_par27) )
		cMensagem	:= "Favor preencher os parametros Grupos Receitas/Despesas e "
		cMensagem	+= "Data Sld Ant. Receitas/Desp. "
		MsgAlert(cMensagem,"Ignora Sl Ant.Rec/Des")	
		lRet    	:= .F.	
    EndIf
EndIf

If !lRet
	Set Filter To
	Return
EndIf

/*If u_mv_par16 == 1 .And. ! lExterno	// Se imprime saldo movimento do periodo -> tamanho relatorio = 220
	tamanho := "G"
EndIf	
*/
If !lExterno .And. ( u_mv_par16 == 1 .Or. ( u_mv_par16 == 2 .And.	aReturn[4] == 2 ))	//Se nao imprime coluna mov. e eh paisagem
	tamanho := "G"
EndIf	

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| U_CTR040Imp(@lEnd,wnRel,cString,aSetOfBook,aCtbMoeda,nDivide,lExterno,cTitorig)})

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CTR040IMP ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime relatorio -> Balancete Verificacao Modelo 1        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CTR040Imp(lEnd,WnRel,cString,aSetOfBook,aCtbMoeda)          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd       - A‡ao do Codeblock                             ³±±
±±³          ³ WnRel      - T¡tulo do relat¢rio                           ³±±
±±³          ³ cString    - Mensagem                                      ³±±
±±³          ³ aSetOfBook - Matriz ref. Config. Relatorio                 ³±±
±±³          ³ aCtbMoeda  - Matriz ref. a moeda                           ³±±
±±³          ³ nDivide    - Valor para divisao de valores                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CTR040Imp(lEnd,WnRel,cString,aSetOfBook,aCtbMoeda,nDivide,lExterno,cTitOrig)

Local aColunas		:= {}
LOCAL CbTxt			:= Space(10)
Local CbCont		:= 0
LOCAL limite		:= 132
Local cabec1   	:= ""
Local cabec2   	:= ""
Local cSeparador	:= ""
Local cPicture
Local cDescMoeda
Local cCodMasc
Local cMascara
Local cGrupo		:= ""
Local cArqTmp
Local dDataFim 	:= u_mv_par02
Local lFirstPage	:= .T.
Local lJaPulou		:= .F.
Local lPrintZero	:= Iif(u_mv_par18==1,.T.,.F.)
Local lPula			:= Iif(u_mv_par17==1,.T.,.F.) 
Local lNormal		:= Iif(u_mv_par19==1,.T.,.F.)
Local lVlrZerado	:= Iif(u_mv_par07==1,.T.,.F.)
Local l132			:= .T.
Local nDecimais
Local nTotDeb		:= 0
Local nTotCrd		:= 0
Local nTotMov		:= 0
Local nGrpDeb		:= 0
Local nGrpCrd		:= 0                     
Local cSegAte   	:= u_mv_par21
Local nDigitAte	:= 0
Local lImpAntLP	:= Iif(u_mv_par22 == 1,.T.,.F.)
Local dDataLP		:= u_mv_par23
Local lImpSint		:= Iif(u_mv_par05=1 .Or. u_mv_par05 ==3,.T.,.F.)
Local lRecDesp0		:= Iif(u_mv_par25==1,.T.,.F.)
Local cRecDesp		:= u_mv_par26
Local dDtZeraRD		:= u_mv_par27
Local n
Local oMeter
Local oText
Local oDlg
Local lImpPaisgm	:= .F.	
Local nMaxLin   	:= iif( u_mv_par28 > 58 , 58 , u_mv_par28 )
Local cMoedaDsc		:= u_mv_par29
Local cRngFil		:= Nil // GetRngFil( "RCTBM040" , "u_mv_par30" )
Local nMasc			:= 0 
Local cMasc			:= ""

Local cTransf 		:= ""
Local cSATran 		:= ""

Local cSA 		:= ""
Local cDeb 		:= ""
Local cCrd 		:= ""

Store 0 To nDeb, nCrd, nSA

cDescMoeda 	:= Alltrim(aCtbMoeda[2])
nDecimais 	:= DecimalCTB(aSetOfBook,u_mv_par08)

If Empty(aSetOfBook[2])
	cMascara := GetMv("MV_MASCARA")
Else
	cMascara 	:= RetMasCtb(aSetOfBook[2],@cSeparador)
EndIf
cPicture 		:= aSetOfBook[4]

If u_mv_par16 == 2 .And. !lExterno .And. 	aReturn[4] == 2	//Se nao imprime coluna mov. e eh paisagem
	lImpPaisgm	:= .T.
	limite		:= 220
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega titulo do relatorio: Analitico / Sintetico			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Alltrim(Titulo) == Alltrim(cTitorig) // Se o titulo do relatorio nao foi alterado pelo usuario
	IF u_mv_par05 == 1
		Titulo:=	OemToAnsi("BALANCETE MODELO PADRAO")
	ElseIf u_mv_par05 == 2
		Titulo:=	OemToAnsi("BALANCETE MODELO PADRAO")
	ElseIf u_mv_par05 == 3
		Titulo:=	OemToAnsi("BALANCETE MODELO PADRAO")
	EndIf
EndIf	
Titulo += 	DTOC(u_mv_par01) + OemToAnsi("") + Dtoc(u_mv_par02) + ;
			OemToAnsi("") + cDescMoeda + CtbTitSaldo(u_mv_par10)
			
If nDivide > 1			
	Titulo += " (" + OemToAnsi("") + Alltrim(Str(nDivide)) + ")"
EndIf	

If u_mv_par16 == 1 .And. ! lExterno		// Se imprime saldo movimento do periodo

	//cabec1 := OemToAnsi("|  CODIGO              |   D  E  S  C  R  I  C  A  O    |   SALDO ANTERIOR  |    DEBITO     |    CREDITO   | MOVIMENTO DO PERIODO |   SALDO ATUAL    |")
	cabec1 := OemToAnsi("|  CODIGO                     |   D  E  S  C  R  I  C  A  O                     |   SALDO ANTERIOR              |   DEBITO         |    CREDITO        | MOVIMENTO DO PERIODO          |   SALDO ATUAL                     |")
	tamanho := "G"
	limite	:= 220        
	l132	:= .F.

Else	  
	If lImpPaisgm		//Se imprime em formato paisagem
		cabec1 := "|  CODIGO                     |      D E S C R I C A O                       |        SALDO ANTERIOR                     |           DEBITO             |            CREDITO                |         SALDO ATUAL               |"
	Else	
		cabec1 := OemToAnsi("|  CODIGO               |   D  E  S  C  R  I  C  A  O    |   SALDO ANTERIOR  |      DEBITO    |      CREDITO   |   SALDO ATUAL     |")
	EndIf
Endif

If ! lExterno
	SetDefault(aReturn,cString,,,Tamanho,If(Tamanho="G",2,1))
Endif

If l132
	If lImpPaisgm
		aColunas := { 000,001, 030, 032, 080,086, 116, 118, 147, 151, 183, , ,187,219}
	Else	
		aColunas := { 000,001, 024, 025, 057,058, 077, 078, 094, 095, 111, , , 112, 131 }
	EndIf
Else                   
	aColunas := { 000,001, 030, 032, 080,082, 112, 114, 131, 133, 151, 153, 183,185,219}
Endif

If ! lExterno
	m_pag := u_mv_par09
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta Arquivo Temporario para Impressao							  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lExterno  .or. IsBlind()
	CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
				u_mv_par01,u_mv_par02,"CT7","",u_mv_par03,u_mv_par04,,,,,,,u_mv_par08,;
				u_mv_par10,aSetOfBook,u_mv_par12,u_mv_par13,u_mv_par14,u_mv_par15,;
				.F.,.F.,u_mv_par11,,lImpAntLP,dDataLP,nDivide,lVlrZerado,,,,,,,,,,,,,,lImpSint,aReturn[7],lRecDesp0,;
				cRecDesp,dDtZeraRD,,,,,,,cMoedaDsc,,cRngFil)
Else

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Criacao de arquivo temporario                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Aadd(_aStru,{"LINHA"     ,"C",78,0})
	_cArqTRB  := CriaTrab(_aStru,.T.)
	dbUseArea(.T.,__LocalDriver,_cArqTRB,"LIN",.F.,.F.)	


	MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
					CTGerPlan(oMeter, oText, oDlg, @lEnd,@cArqTmp,;
					u_mv_par01,u_mv_par02,"CT7","",u_mv_par03,u_mv_par04,,,,,,,u_mv_par08,;
					u_mv_par10,aSetOfBook,u_mv_par12,u_mv_par13,u_mv_par14,u_mv_par15,;
					.F.,.F.,u_mv_par11,,lImpAntLP,dDataLP,nDivide,lVlrZerado,,,,,,,,,,,,,,lImpSint,aReturn[7],lRecDesp0,;
					cRecDesp,dDtZeraRD,,,,,,,cMoedaDsc,,cRngFil)},;
					OemToAnsi(OemToAnsi("Criando Arquivo Tempor rio...")),;  //"Criando Arquivo Tempor rio..."
					OemToAnsi("Balancete Modelo Padrao"))  				//"Balancete Verificacao"
EndIf

// Verifica Se existe filtragem Ate o Segmento
If !Empty(cSegAte)
	
	//Efetua tratamento da mascara para consegui efetuar o controle do segmento 
	For nMasc := 1 to Len( cMascara )
			
		cMasc += "0"+SubStr( cMascara,nMasc,1 )
			
	Next nMasc


	nDigitAte := CtbRelDig(cSegAte,cMasc) 	
	
EndIf				

dbSelectArea("cArqTmp")
//dbSetOrder(1)
dbGoTop()

SetRegua(RecCount())

cGrupo := GRUPO


/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criacao de arquivo temporario                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(_aStru,{"LINHA"     ,"C",78,0})
_cArqTRB  := CriaTrab(_aStru,.T.)
dbUseArea(.T.,__LocalDriver,_cArqTRB,"LIN",.F.,.F.)	
*/


While !Eof()

	If lEnd
		@Prow()+1,0 PSAY OemToAnsi("***** CANCELADO PELO OPERADOR *****")   //"***** CANCELADO PELO OPERADOR *****"
		Exit
	EndIF

	IncRegua()

	******************** "FILTRAGEM" PARA IMPRESSAO *************************

	If u_mv_par05 == 1					// So imprime Sinteticas
		If TIPOCONTA == "2"
			dbSkip()
			Loop
		EndIf
	ElseIf u_mv_par05 == 2				// So imprime Analiticas
		If TIPOCONTA == "1"
			dbSkip()
			Loop
		EndIf
	EndIf

	//Filtragem ate o Segmento ( antigo nivel do SIGACON)		
	If !Empty(cSegAte)
		If Len(Alltrim(CONTA)) > nDigitAte
			dbSkip()
			Loop
		Endif
	EndIf
	

	************************* ROTINA DE IMPRESSAO *************************
	
	If u_mv_par11 == 1 							// Grupo Diferente - Totaliza e Quebra
		If cGrupo != GRUPO
			@li,00 PSAY REPLICATE("-",limite)
			li+=2
			@li,00 PSAY REPLICATE("-",limite)
			li++
			@li,aColunas[COL_SEPARA1] PSAY "|"
			@li,39 PSAY OemToAnsi("T O T A I S  D O  G R U P O: " ) + cGrupo + ") : "  		//"T O T A I S  D O  G R U P O: "       
			@li,aColunas[COL_SEPARA4] PSAY "|"
			ValorCTB(nGrpDeb,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
			@li,aColunas[COL_SEPARA5] PSAY "|"
			ValorCTB(nGrpCrd,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)
			@li,aColunas[COL_SEPARA6] PSAY "|"
			@li,aColunas[COL_SEPARA8] PSAY "|"
			li++      
			li		:= 60
			cGrupo	:= GRUPO
			nGrpDeb	:= 0
			nGrpCrd	:= 0		
		EndIf		

	ElseIf  u_mv_par11 == 2
		If NIVEL1				// Sintetica de 1o. grupo
			li := 60
		EndIf
	EndIf

	IF li > nMaxLin
		If !lFirstPage
			@Prow()+1,00 PSAY	Replicate("-",limite)
		EndIf
		CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
		lFirstPage := .F.
	EndIf

	@ li,aColunas[COL_SEPARA1] 		PSAY "|"
	If lNormal
		If TIPOCONTA == "2" 		// Analitica -> Desloca 2 posicoes
			If l132
				EntidadeCTB(CONTA,li,aColunas[COL_CONTA]+2,21,.F.,cMascara,cSeparador)			
			Else
				EntidadeCTB(CONTA,li,aColunas[COL_CONTA]+2,27,.F.,cMascara,cSeparador)
			EndIf
		Else	                                              
			If l132
				EntidadeCTB(CONTA,li,aColunas[COL_CONTA],23,.F.,cMascara,cSeparador)
			Else                                                                     
				EntidadeCTB(CONTA,li,aColunas[COL_CONTA],29,.F.,cMascara,cSeparador)
			EndIf			
		EndIf	
	Else
		If TIPOCONTA == "2"		// Analitica -> Desloca 2 posicoes
			@li,aColunas[COL_CONTA] PSAY Alltrim(CTARES)
		Else
			@li,aColunas[COL_CONTA] PSAY Alltrim(CONTA)
		EndIf						
	EndIf	

	//MsgInfo(CONTA)
	//MsgInfo("Conta " + CONTA)	
	
	
	CT1_CODBMP := ""
	cLinha 	:= 	MV_Par07
	cLinha 	+=	cMes 
	cLinha 	+=	cAno
	//cLinha 	+=	SubStr(CONTA,1,9)	//Alterado em 28/05/2010

	//cLinha 	+=	Posicione("CT1",1,xFilial("CT1")+CONTA,"CT1_CODBMP")
	CT1_CODBMP := Posicione("CT1",1,xFilial("CT1")+CONTA,"CT1_CODBMP")
	cLinha 	+= CT1_CODBMP

	@ li,aColunas[COL_SEPARA2] 		PSAY "|"
	If !l132
		@ li,aColunas[COL_DESCRICAO] 	PSAY Substr(DESCCTA,1,60)
	Else		
	@ li,aColunas[COL_DESCRICAO] 	PSAY Substr(DESCCTA,1,31)
	Endif	
	@ li,aColunas[COL_SEPARA3]		PSAY "|"
	ValorCTB(SALDOANT,li,aColunas[COL_SALDO_ANT],17,nDecimais,.T.,cPicture,NORMAL, , , , , ,lPrintZero)
	@ li,aColunas[COL_SEPARA4]		PSAY "|"
	ValorCTB(SALDODEB,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,NORMAL, , , , , ,lPrintZero)
	nDeb := SALDODEB //cDeb := Str(SALDODEB) //ValorCTB(SALDODEB,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,NORMAL, , , , , ,.F.)
	//MsgInfo(SALDODEB)
	//MsgInfo(cDeb)



	//cLinha 	+=	StrZero(nDeb,20) //cDeb //StrZero(cDeb,20)	
	//cLinha 	+=	Str(nDeb)
	//cDeb := AllTrim(Str(nDeb))
	cDeb := StrZero(nDeb,20)
	//cLinha 	+=	STUFF( cDeb , AT(".",cDeb) , 1 , "" )
	cLinha 	+=	StrZero( 0 , 21 - (Len(cDeb)) ) + Stuff( 	cDeb, 	AT(".",cDeb) , 1 , "" )
	

	
	@ li,aColunas[COL_SEPARA5]		PSAY "|"
	ValorCTB(SALDOCRD,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,NORMAL, , , , , ,lPrintZero)
	nCrd := SALDOCRD//cCre := Str(SALDOCRD) //ValorCTB(SALDOCRD,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,NORMAL, , , , , ,.F.)
	//MsgInfo(SALDOCRD)
	//MsgInfo("cCrd " + cCre)
	
	


	//cLinha 	+=	StrZero(nCrd,20) //cCre //StrZero(cCre,20)	
	//cLinha 	+=	Str(nCrd)
	//cCrd := AllTrim(Str(nCrd))
	cCrd := StrZero(nCrd,20)
	//cLinha 	+=	STUFF( cCrd , AT(".",cCrd) , 1 , "" )
	cLinha 	+=	StrZero( 0 , 21 - (Len(cCrd)) ) + Stuff( 	cCrd, 	AT(".",cCrd) , 1 , "" )
	

	
	@ li,aColunas[COL_SEPARA6]		PSAY "|"
	If !l132
		ValorCTB(MOVIMENTO,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,NORMAL, , , , , ,lPrintZero)
		@ li,aColunas[COL_SEPARA7] PSAY "|"	
	Endif
	ValorCTB(SALDOATU,li,aColunas[COL_SALDO_ATU],17,nDecimais,.T.,cPicture,NORMAL, , , , , ,lPrintZero)
	nSA := SALDOATU //cSA := Str(SALDOATU) // ValorCTB(SALDOATU,li,aColunas[COL_SALDO_ATU],17,nDecimais,.T.,cPicture,NORMAL, , , , , ,.F.)
	//MsgInfo(SALDOATU)
	//MsgInfo("cSA " + StrZero(cSA,20) )



	//cLinha 	+=	cSA
	//cTRBSALDO := StrZero(SALDOATU,20) //cSA //StrZero(cSA,20)

	cTRBSALDO := StrZero(nSA,20)

	//cSA := AllTrim(Str(nSA))

	//cSA := StrZero(nSA,20)//
	//cSA := SubStr( nSA, AT("-",cSA)+1 )
	cSA := StrZero(nSA,19)

	//If cTRBSALDO $ "-" //Valor Negativo
	If nSA < 0 //Valor Negativo  -> DEBITO
		//MsgInfo("cTRBSALDO "+cTRBSALDO)
		//cLinha 	+=	cTRBSALDO
		//MsgInfo("cLinha (-) "+cLinha)

		//cTransf := Transform(nSA,"@E 9999999999999999999")
		//cSATran := "-"	+	Replicate("0", (19 - (Len(cTransf))) )	+	cTransf
		//cLinha 	+= cSATran

		//cLinha 	+= "+" + Str(nSA)		
		//cLinha 	+= "+" + Stuff( cSA , AT("-",cSA) , 1,	StrZero( Len( Stuff(cSA, AT("-",cSA) , 1 , "" ) ) ) )
		
        /*
		cABS    := Stuff( cSA , AT("-",cSA) , 1 , "" )
		c0      := StrZero( 0 , 20 - (Len(cABS)) )
		cStrSA  := Stuff( cABS , AT(".",cABS) , 1 ,	"" )

		cLinha 	+= "+" + c0 + cStrSA
		*/
		cABS    := Stuff( cSA , AT("-",cSA) , 1 , "" )
		c0      := StrZero( 0 , 21 - (Len(cSA)) )
		cStrSA  := Stuff( cABS , AT(".",cABS) , 1 ,	"" )

		cLinha 	+= "+" + c0 + cStrSA		
		
	//ElseIf cTRBSALDO == "00000000000000000000" //Valor Zero
	ElseIf nSA = 0 //Valor Zero
		//MsgInfo("cTRBSALDO "+cTRBSALDO)
		cLinha 	+=	cTRBSALDO
		//MsgInfo("cLinha 0 "+cLinha)

	Else//If  cTRBSALDO $ "123456789" //Valor Positivo -> CREDITO
		//MsgInfo("cTRBSALDO "+cTRBSALDO)
		//cLinha 	+=	("+"+SubStr(cTRBSALDO,2,19))
		//MsgInfo("cLinha (+) "+cLinha)

		//cTransf := Transform(nSA,"@E 9999999999999999999")
		//cSATran := "-"	+	Replicate("0", (19 - (Len(cTransf))) )	+	cTransf
		//cLinha 	+= cSATran
		
		//cLinha 	+= "-" + Str(nSA)
		//cLinha 	+= "-" + StrZero( 0 , (Len(cSA)-1) ) + Stuff( cSA, AT(".",cSA) , 1 , "" )
		//cLinha 	+= "-" + StrZero( 0 , (Len(cSA)+1) ) + Stuff( cSA, AT(".",cSA) , 1 , "" )

		//cCount := StrZero( 0 , (Len(cSA)+1) ) + Stuff( cSA, AT(".",cSA) , 1 , "" )//Len(cSA)
		cCount := Stuff( cSA, AT(".",cSA) , 1 , "" )//Len(cSA)
		nChars := Len(cCount)
		If nChars < 19
			cLinha 	+= "-" + StrZero( 0 , 19 - nChars ) + cCount
		Else
			cLinha 	+= "-" + StrZero( 0 , 19 - (Len(cCount)) ) + cCount
		EndIf

	EndIf			
	
	//cTransf := ""
	//cSATran := ""

	//If !Empty(CT1_CODBMP) //Atualiza registro apenas se tiver o codigo BMP	
		//MsgInfo("cLinha -> "+cLinha)
		dbSelectArea("LIN")
	    dbAppend()
	    LIN->LINHA := cLinha
		dbSelectArea("cArqTmp")
		//MsgInfo(SALDOATU)
	//EndIf
	
	@ li,aColunas[COL_SEPARA8] PSAY "|"
	
	lJaPulou := .F.
	
	If lPula .And. TIPOCONTA == "1"				// Pula linha entre sinteticas
		li++
		@ li,aColunas[COL_SEPARA1] PSAY "|"
		@ li,aColunas[COL_SEPARA2] PSAY "|"
		@ li,aColunas[COL_SEPARA3] PSAY "|"	
		@ li,aColunas[COL_SEPARA4] PSAY "|"
		@ li,aColunas[COL_SEPARA5] PSAY "|"
		@ li,aColunas[COL_SEPARA6] PSAY "|"
		If !l132  
			@ li,aColunas[COL_SEPARA7] PSAY "|"
			@ li,aColunas[COL_SEPARA8] PSAY "|"
		Else
			@ li,aColunas[COL_SEPARA8] PSAY "|"
		EndIf	
		li++
		lJaPulou := .T.
	Else
		li++
	EndIf			
	
	//---
	//---
	//---
	/*
	MsgInfo("Valtype MV_Par07 	-> 	" 	+ Valtype( MV_Par07 )	+ chr(13)+chr(10) + ;
			"Valtype cMes 		-> 	" 	+ Valtype( cMes 	) 	+ chr(13)+chr(10) + ;
			"Valtype cAno 		-> 	" 	+ Valtype( cAno 	) 	+ chr(13)+chr(10) + ;
			"Valtype CONTA 		-> 	" 	+ Valtype( CONTA 	) 	+ chr(13)+chr(10) + ;
			"Valtype SALDODEB 	-> 	" 	+ Valtype( SALDODEB ) 	+ chr(13)+chr(10) + ;
			"Valtype SALDOCRD 	-> 	" 	+ Valtype( SALDOCRD ) 	+ chr(13)+chr(10) + ;
			"Valtype SALDOATU 	-> 	" 	+ Valtype( SALDOATU )						;
			)
	*/

	/*
	cLinha 	:= 	MV_Par07
	cLinha 	+=	cMes 
	cLinha 	+=	cAno
	cLinha 	+=	SubStr(CONTA,1,9)
	cLinha 	+=	StrZero(nDeb,20) //cDeb //StrZero(cDeb,20)
	cLinha 	+=	StrZero(nCrd,20) //cCre //StrZero(cCre,20)
	//cLinha 	+=	cSA

	//cTRBSALDO := StrZero(SALDOATU,20) //cSA //StrZero(cSA,20)
	cTRBSALDO := StrZero(nSA,20)

	If cTRBSALDO $ "-" //Valor Negativo

		cLinha 	+=	cTRBSALDO

	ElseIf cTRBSALDO == "00000000000000000000" //Valor Zero

		cLinha 	+=	cTRBSALDO

	ElseIf cTRBSALDO $ "123456789" //Valor Positivo

		cLinha 	+=	"+" + StrStr(cTRBSALDO,19)

	EndIf	
	*/
	
	//---
	//---
	//---

	************************* FIM   DA  IMPRESSAO *************************

	If u_mv_par05 == 1					// So imprime Sinteticas - Soma Sinteticas
		If TIPOCONTA == "1"
			If NIVEL1
				nTotDeb += SALDODEB
				nTotCrd += SALDOCRD
				nGrpDeb += SALDODEB
				nGrpCrd += SALDOCRD
			EndIf
		EndIf
	Else									// Soma Analiticas
		If Empty(cSegAte)				//Se nao tiver filtragem ate o nivel
			If TIPOCONTA == "2"
				nTotDeb += SALDODEB
				nTotCrd += SALDOCRD
				nGrpDeb += SALDODEB
				nGrpCrd += SALDOCRD
			EndIf
		Else							//Se tiver filtragem, somo somente as sinteticas
			If TIPOCONTA == "1"
				If NIVEL1
					nTotDeb += SALDODEB
					nTotCrd += SALDOCRD
					nGrpDeb += SALDODEB
					nGrpCrd += SALDOCRD
				EndIf
			EndIf	
    	Endif			
	EndIf
	//---

//	dbSelectArea("LIN")
//    dbAppend()
//    LIN->LINHA := cLinha


	dbSelectArea("cArqTmp")
	//---
	dbSkip()       

	If lPula .And. TIPOCONTA == "1" 			// Pula linha entre sinteticas
		If !lJaPulou
			@ li,aColunas[COL_SEPARA1] PSAY "|"
			@ li,aColunas[COL_SEPARA2] PSAY "|"
			@ li,aColunas[COL_SEPARA3] PSAY "|"	
			@ li,aColunas[COL_SEPARA4] PSAY "|"
			@ li,aColunas[COL_SEPARA5] PSAY "|"
			@ li,aColunas[COL_SEPARA6] PSAY "|"
			If !l132  
				@ li,aColunas[COL_SEPARA7] PSAY "|"
				@ li,aColunas[COL_SEPARA8] PSAY "|"
			Else
				@ li,aColunas[COL_SEPARA8] PSAY "|"
			EndIf	
			li++
		EndIf	
	EndIf		

EndDO

//IF li != 80 .And. !lEnd
IF li <= 58 .OR. li >= 58 .And. !lEnd
	IF li > nMaxLin
		@Prow()+1,00 PSAY	Replicate("-",limite)
		CtCGCCabec(,,,Cabec1,Cabec2,dDataFim,Titulo,,"2",Tamanho)
		li++
	End
	If u_mv_par11 == 1							// Grupo Diferente - Totaliza e Quebra
		If cGrupo != GRUPO
			@li,00 PSAY REPLICATE("-",limite)
			li++
			@li,aColunas[COL_SEPARA1] PSAY "|"
			@li,39 PSAY OemToAnsi("T O T A I S  D O  G R U P O: ") + cGrupo + ") : "  		//"T O T A I S  D O  G R U P O: "
			@li,aColunas[COL_SEPARA4] PSAY "|"
			ValorCTB(nGrpDeb,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
			@li,aColunas[COL_SEPARA5] PSAY "|"
			ValorCTB(nGrpCrd,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)
			@li,aColunas[COL_SEPARA6] PSAY "|"
			If !l132
				nTotMov := nTotMov + (nGrpCrd - nGrpDeb)
				If Round(NoRound(nTotMov,3),2) < 0
					ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"1", , , , , ,lPrintZero)
				ElseIf Round(NoRound(nTotMov,3),2) > 0
					ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"2", , , , , ,lPrintZero)
                EndIf
				@ li,aColunas[COL_SEPARA7] PSAY "|"	
			Endif
			@li,aColunas[COL_SEPARA8] PSAY "|"
			li++
			@li,00 PSAY REPLICATE("-",limite)
			li+=2
		EndIf		
	EndIf

	@li,00 PSAY REPLICATE("-",limite)
	li++
	@li,aColunas[COL_SEPARA1] PSAY "|"
	@li,39 PSAY OemToAnsi("T O T A I S  D O  M E S : ")  		//"T O T A I S  D O  M E S : "
	@li,aColunas[COL_SEPARA4] PSAY "|"
	ValorCTB(nTotDeb,li,aColunas[COL_VLR_DEBITO],16,nDecimais,.F.,cPicture,"1", , , , , ,lPrintZero)
	@li,aColunas[COL_SEPARA5] PSAY "|"
	ValorCTB(nTotCrd,li,aColunas[COL_VLR_CREDITO],16,nDecimais,.F.,cPicture,"2", , , , , ,lPrintZero)
	@li,aColunas[COL_SEPARA6] PSAY "|"
 	If !l132	
		nTotMov := nTotMov + (nTotCrd - nTotDeb)
		If Round(NoRound(nTotMov,3),2) < 0
			ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"1", , , , , ,lPrintZero)
		ElseIf Round(NoRound(nTotMov,3),2) > 0
			ValorCTB(nTotMov,li,aColunas[COL_MOVIMENTO],17,nDecimais,.T.,cPicture,"2", , , , , ,lPrintZero)
		EndIf
		@li,aColunas[COL_SEPARA7] PSAY "|"	
	EndIf		                                
	@li,aColunas[COL_SEPARA8] PSAY "|"
	li++
	@li,00 PSAY REPLICATE("-",limite)
	li++
	@li,0 PSAY " "

	IF lExterno 
		If (li + 3) < 60 
			@57,00 PSAY __PrtfatLine()
  		  	@58,01 Psay "Microsiga Software S/A"   //  "Microsiga Software S/A"
 		   	If Tamanho == "M"
   		 		@58,100 Psay "Hora Termino: " + " " + Time()      //"Hora Termino: "
   	 		ElseIf Tamanho == "G"
	   		 	@58,190 Psay "Hora Termino: " + " "+ Time()  //"Hora Termino: "
    		Else
	    		@58,050 Psay "Hora Termino: " + " "+ Time()	   //"Hora Termino: "
			EndIf               
			@59,00 PSAY __PrtfatLine()
		EndIf	
	Endif
	Set Filter To
EndIF

If u_mv_par24 ==1
	ImpQuadro(Tamanho,X3USO("CT2_DCD"),dDataFim,u_mv_par08,aQuadro,cDescMoeda,nomeprog,(If (lImpAntLP,dDataLP,cTod(""))),cPicture,nDecimais,lPrintZero,u_mv_par10)
EndIf	
	
If aReturn[5] = 1 .And. ! lExterno
	Set Printer To
	Commit
	Ourspool(wnrel)
EndIf

dbSelectArea("cArqTmp")
Set Filter To
dbCloseArea() 
If Select("cArqTmp") == 0
	FErase(cArqTmp+GetDBExtension())
	FErase(cArqTmp+OrdBagExt())
EndIF	
dbselectArea("CT2")

If ! lExterno
	MS_FLUSH()
Endif


//Exporta arquivo de trabalho para txt
dbSelectArea("LIN")
_cDirExp  := "\bmp\" //GETMV("MV_DIREXP")  // "\EXPORT\"
cArquivo  := MV_Par01 + MV_Par02 + MV_Par03 + "_" + AllTrim(MV_Par04) +"_" + cAno+cMes + MV_Par06 + ".txt"
_cArqExp  := _cDirExp + cArquivo
Copy to &_cArqExp SDF
dbCloseArea()

//Transferencia de Arquivos
cDirDestino := cGetFile(OemtoAnsi("Transferência do Arquivo BMP"),OemToAnsi("Selecione o Diretório Destino"),0,,.F.,GETF_RETDIRECTORY+GETF_LOCALHARD)
lCopiou 	:=  CpyS2T( _cArqExp , IIf( Empty(cDirDestino) , "c:\" ,cDirDestino ) , .T. )
cMemo1 		:= "ARQUIVO " + cArquivo + IIF(lCopiou,"  TRANSFERIDO PARA " + cDirDestino , "  ERRO TRANSF... ")+Chr(13)+Chr(10)
MsgInfo(cMemo1)

Return( .T. )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³CT040Valid³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida Perguntas                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ct040Valid(cSetOfBook)                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T./.F.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Codigo da Config. Relatorio                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Ct040Valid(cSetOfBook)

Local aSaveArea:= GetArea()
Local lRet		:= .T.	

If !Empty(cSetOfBook)
	dbSelectArea("CTN")
	dbSetOrder(1)
	If !dbSeek(xfilial()+cSetOfBook)
		aSetOfBook := ("","",0,"","")
		Help(" ",1,"NOSETOF")
		lRet := .F.
	EndIf
EndIf
	
RestArea(aSaveArea)

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CTR040MAXL ºAutor ³ Eduardo Nunes Cirqueira º Data ³  31/01/07 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Baseado no parametro u_MV_PAR28 ("Num.linhas p/ o Balancete      º±±
±±º          ³ Modelo 1"), cujo conteudo esta na variavel "nMaxLin", controla º±±
±±º          ³ a quebra de pagina no TReport                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CTR040MaxL(nMaxLin,nLinReport)

nLinReport++

If nLinReport > nMaxLin
	oReport:EndPage()
	nLinReport := 10
EndIf

Return Nil
                                                                          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ nCtCGCCabTR  º Autor ³ Fabio Jadao Caires      º Data ³ 31/01/07º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Chama a funcao padrao CtCGCCabTR reiniciando o contador de      º±±
±±º          ³ linhas para o controle do relatorio.                            º±±
±±º          ³                                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION nCtCGCCabTR(dDataFim,titulo,oReport)

nLinReport := 10

RETURN CtCGCCabTR(,,,,,dDataFim,titulo,,,,,oReport)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBR040   ºAutor  ³Microsiga           º Data ³  05/27/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION AjustSx1()
Local aPergs 	:= {}    
Local aHelpPor	:= {} 
Local aHelpEng	:= {}	
Local aHelpSpa	:= {}

Aadd(aHelpPor,"")			
Aadd(aHelpEng,"")
Aadd(aHelpSpa,"")

#IFDEF TOP
	aadd(aPergs,{"Filiais?"							,	"¿Filiais?"						,	"Filiais?"						,	"mv_chu",	"C",	99	,0	,0	,"R",							,	"mv_par30",	""				,""					,""					,"CT7_FILIAL"			,""			,""					,""					,"CT7_FILIAL"					,""			,""					,""				,"CT7_FILIAL"				,""				,""			,""					,""				,""				,""				,""				,""				,""				,""				,"","",""		,""		,"S"})

	AjustaSx1( "CTR040" , aPergs )  
#ENDIF

RETURN


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ValidPerg ³Autor  ³Cosme da Silva Nunes   ³Data  ³27/04/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Cria Pergunta no SX1                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³nomeprog                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg()

Local aRegs := {}

//Estrutura	{Grupo	/Ordem	/Pergunta				/Pergunta Espanhol		/Pergunta Ingles		/Variavel	/Tipo	/Tamanho	/Decimal	/Presel	/GSC	/Valid									   			   		/Var01		/Def01		/DefSpa1	/DefEng1	/Cnt01							/Var02	/Def02		/DefSpa2	/DefEng2	/Cnt02	/Var03	/Def03	/DefSpa3	/DefEng3	/Cnt03	/Var04	/Def04	/DefSpa4	/DefEng4	/Cnt04	/Var05	/Def05	/DefSpa5	/DefEng5	/Cnt05	/F3		/PYME	/GRPSX6	/HELP	}
//Aadd(aRegs,{cPerg	,"01"	,"Mes"					,"Mes"					,"Mes"					,"mv_ch1"	,"C"	, 2			,0			,0		,"G"	,"Pertence('01/02/03/04/05/06/07/08/09/10/11/12')"			,"mv_par01"	,""			,""			,""			,"Str(Month(dDataBase))"		,""		,""			,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""		,""		}	)
//Aadd(aRegs,{cPerg	,"02"	,"Ano"					,"Ano"					,"Ano"					,"mv_ch2"	,"C"	, 4			,0			,0		,"G"	,""									   	  					,"mv_par02"	,""			,""			,""			,"Str(Year(dDataBase))"			,""		,""			,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""		,""		}	)

//Aadd(aRegs,{cPerg	,"01"	,"Periodo De ?"			,"Periodo De ?"			,"Periodo De ?"			,"mv_ch1"	,"D"	, 8			,0			,0		,"G"	,'NAOVAZIO'													,"mv_par01"	,""			,""			,""	   		,""								,""		,""			,""			,""			,""		,""		,""		,""	   		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""	   		,""			,""		,""		,"S"	,""		,""	 	}	)
//Aadd(aRegs,{cPerg	,"02"	,"Periodo Ate ?"  		,"Periodo Ate ?"		,"Periodo Ate ?"		,"mv_ch2"	,"D"	, 8			,0			,0		,"G"	,'NAOVAZIO'													,"mv_par02"	,""			,""			,""	   		,""								,""		,""			,""			,""			,""		,""		,""		,""	   		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""	   		,""			,""		,""		,"S"	,""		,""	 	}	)

//Aadd(aRegs,{cPerg	,"01"	,"Cód.Empresa ?"  		,"Cód.Empresa ?"		,"Cód.Empresa ?"		,"mv_ch1"	,"C"	, 3			,0			,0		,"G"	,"NAOVAZIO"                                         		,"mv_par01"	,""			,""			,""			,""                  			,""		,""			,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,"S"	,""		,""		}	)
//Aadd(aRegs,{cPerg	,"02"	,"Data Fecham. ?" 		,"Data Fecham. ?"		,"Data Fecham. ?"		,"mv_ch2"	,"D"	, 8			,0			,0		,"G"	,'NAOVAZIO'													,"mv_par02"	,""			,""			,""	   		,""								,""		,""			,""			,""			,""		,""		,""		,""	   		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""	   		,""			,""		,""		,"S"	,""		,""	 	}	)

Aadd(aRegs,{cPerg	,"01"	,"Padrão do DUTO ?"		,"Padrão do DUTO ?"		,"Padrão do DUTO ?"		,"mv_ch1"	,"C"	, 3			,0			,0		,"G"	,'NAOVAZIO'                                            		,"mv_par01"	,""			,""			,""			,"APL"                 			,""		,""			,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,"S"	,""		,""		}	)
Aadd(aRegs,{cPerg	,"02"	,"Aplicação	 ?" 		,"Aplicação ?"			,"Aplicação ?"			,"mv_ch2"	,"C"	, 3			,0			,0		,"G"	,'NAOVAZIO'													,"mv_par02"	,""			,""			,""	   		,"BMP"							,""		,""			,""			,""			,""		,""		,""		,""	   		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""	   		,""			,""		,""		,"S"	,""		,""	 	}	)
Aadd(aRegs,{cPerg	,"03"	,"Ident. do Agente ?" 	,"Ident. do Agente ?"	,"Ident. do Agente ?"	,"mv_ch3"	,"C"	, 4			,0			,0		,"G"	,"NAOVAZIO"                                         		,"mv_par03"	,""			,""			,""			,""                  			,""		,""			,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,"S"	,""		,""		}	)
Aadd(aRegs,{cPerg	,"04"	,"Sigla do Agente ?" 	,"Sigla do Agente ?"	,"Sigla do Agente ?"	,"mv_ch4"	,"C"	,60			,0			,0		,"G"	,'NAOVAZIO'													,"mv_par04"	,""			,""			,""	   		,""								,""		,""			,""			,""			,""		,""		,""		,""	   		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""	   		,""			,""		,""		,"S"	,""		,""	 	}	)
Aadd(aRegs,{cPerg	,"05"	,"Data Fecham. ?" 		,"Data Fecham. ?"		,"Data Fecham. ?"		,"mv_ch5"	,"D"	, 8			,0			,0		,"G"	,'NAOVAZIO'													,"mv_par05"	,""			,""			,""	   		,""								,""		,""			,""			,""			,""		,""		,""		,""	   		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""	   		,""			,""		,""		,"S"	,""		,""	 	}	)
Aadd(aRegs,{cPerg	,"06"	,"Versão Arquivo ?"  	,"Versão Arquivo ?"		,"Versão Arquivo ?"		,"mv_ch6"	,"C"	, 1			,0			,0		,"G"	,'Pertence("ABCDEFGHIJKLMNOPQRSTUVWXYZ")'					,"mv_par06"	,""			,""			,""			,""                  			,""		,""			,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,"S"	,""		,""		}	)
Aadd(aRegs,{cPerg	,"07"	,"Cód.Empresa ?"  		,"Cód.Empresa ?"		,"Cód.Empresa ?"		,"mv_ch7"	,"C"	, 3			,0			,0		,"G"	,'NAOVAZIO'                                         		,"mv_par07"	,""			,""			,""			,""                  			,""		,""			,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,""		,"S"	,""		,""		}	)

lValidPerg( aRegs )

Return()