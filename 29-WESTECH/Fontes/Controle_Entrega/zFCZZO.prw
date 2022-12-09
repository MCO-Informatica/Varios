#Include 'Protheus.ch'

User Function zFCZZO()
Local _cRetorno 
Local cTipo := M->ZZO_TPCF
Local cFornCli := ""

	
	If M->ZZO_TPCF == "1"
        cFornCli := Posicione("SA1",1,xFilial("SA1")+alltrim(M->ZZO_CODCF),"SA1->A1_NREDUZ") 
	  	
	Else
	  	cFornCli := Posicione("SA2",1,xFilial("SA2")+alltrim(M->ZZO_CODCF),"SA2->A2_NREDUZ")
	End if
    _cRetorno := cFornCli 
    //msginfo(cFornCli)

Return ( _cRetorno )
