
/*********************************************************************************************************
* Ponto de entrada executado antes de iniciar o processo de grava??o/exclus?o de Nota de entrada
* Ser? utilizado para ajustar o status no cadastro de XML caso a NF tenha sido gerada automaticamente 
* atrav?s da importa??o do XML.
* Robson Santos - Call System - 20/06/2012
*
* MT100GRV(<recebe valor l?gico>) --> Retorna valor l?gico
* Se valor recebido for verdadeiro (.T.) trata-se de uma exclus?o, caso contr?rio, ? uma grava??o;
* Se retornar valor falso (.F.) n?o permite a exclus?o ou grava??o.
**********************************************************************************************************/
User Function MT100GRV()
	Local lExp01 := PARAMIXB[1]
	Local lExp02 := .T.
                        

// Muda o status referente a importacao xml   
if  TCCanOpen( "UZQ" + cempant  +'0' ) 

	If lExp01    // se for processo de exclus?o
		// Verifica se a NF existe no cadastro de XML e altera o status
		UZQ->( DbSetOrder( 3 ))
		If UZQ->( DbSeek( xFilial( "UZQ" ) + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA))
			If UZQ->UZQ_STATUS $ "2/3/6"   // Se status como pr?-nota a classificar ou classificada
				RecLock( "UZQ", .F. )
					UZQ_STATUS := "1"  		// Status passa a ser XML Importado.  
					UZQ_NFGER  := ""
					UZQ_SERGER := ""						
				MsUnLock()
			Endif
		Endif
	Else
	
		// Verifica se a NF existe no cadastro de XML e altera o status
		UZQ->( DbSetOrder( 3 ))
		If UZQ->( DbSeek( xFilial( "UZQ" ) + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA))
			If UZQ->UZQ_STATUS == "2|6"   // Se status como pr?-nota a classificar
				RecLock( "UZQ", .F. )
				UZQ_STATUS := "3"  		// Status passa a ser pr?-nota classificada. 
			 	MsUnLock()
			Endif
		Endif

	Endif
	
Endif
	
Return lExp02
