
/****************************************************************************************
* Ponto de entrada executado no estorno da classificação de uma Pré-nota
* A finalidade é permitir ou não a exclusão do banco de conhecimento quando for efetuado
* o estorno da classificação de uma pré-nota.
* Porém estamos utilizando este ponto de entrada para atualizar o status do cadastro do 
* XML caso a pré-nota tenha sido gerada por ele.
* Robson Santos - Call System - 20/06/2012
*
* MT103MSD() --> Retorna valor lógico
* Se .T. = Exclui o Banco de Conhecimento, se .F. = Não exclui o Banco de Conhecimento
***************************************************************************************/
USER FUNCTION MT103MSD()   


Local lExc:=.t.     
	
// Muda o status referente a importacao xml   
if  TCCanOpen( "UZQ" + cempant  +'0' ) 
	
	// Verifica se a NF existe no cadastro de XML e altera o status
	UZQ->( DbSetOrder( 3 ))
	If UZQ->( DbSeek( xFilial( "UZQ" ) + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA))
		//If UZQ->UZQ_STATUS $ "1/2/3"   // Se status como pré-nota classificada
			RecLock( "UZQ", .F. )
			UZQ_STATUS := "2"  		// Status passa a ser Pré-nota a classificar
			MsUnLock()
		//Endif
	Endif
	
Endif
	
Return lExc
