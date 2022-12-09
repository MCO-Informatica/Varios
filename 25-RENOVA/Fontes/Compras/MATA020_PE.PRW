//Bibliotecas
#Include "Protheus.ch"
#Include "FWMVCDef.ch"

/*---------------------------------------------------------------------------------------------------------------------------*
 | P.E.:  MATA020                                                                                                            |
 | Autor: alcouto                                                                                                       |
 | Data:  18/02/2021                                                                                                         |
 | Desc:  Ponto de entrada MVC no cadastro de Fornecedores                                                                   |
 | Obs.:  Ao criar um P.E. em MVC com o mesmo nome do ModelDef, deixe o nome do prw com outro nome, por exemplo,             |
 |        MATAXXX_pe.prw                                                                                                     |
 |https://tdn.totvs.com/display/public/PROT/ADV0044_PE_MVC_MATA020_P12#:~:text=Pontos%20de%20Entrada%20MVC%20MATA020%20na%20P12&text=O%20id%20do%20modelo%20da,ser%20User%20Function%20CUSTOMERVENDOR(). |
 *---------------------------------------------------------------------------------------------------------------------------*/
User Function CUSTOMERVENDOR()
    Local aParam := PARAMIXB
    Local xRet := .T.
    Local oObj := ""
    Local cIdPonto := ""
    Local cIdModel := ""
    Local lIsGrid := .F.
    Local nLinha := 0
    Local nQtdLinhas := 0
    Local cMsg := ""
 
    If aParam <> NIL
        oObj := aParam[1]
        cIdPonto := aParam[2]
        cIdModel := aParam[3]
        lIsGrid := (Len(aParam) > 3)

    //Valida a abertura da tela
		If cIdPonto == "MODELVLDACTIVE"
			nOper := oObj:nOperation
        endif    
	//	If cIdPonto == "MODELPOS"
           // If M->A2_XINBCO ='S' .AND. Empty(M->A2_BANCO)
			//	Alert('Atenção!! Por favor, informe um Banco!')
		//		xRet := .F.
		//	EndIf
	//	EndIf	
 		If cIdPonto == "FORMPOS" //TUDO OK
           If M->A2_XINBCO ='S' .AND. Empty(M->A2_BANCO)
				Help(NIL, NIL, "Validar campo(s)", NIL, "Campo Banco esta vazio",;
                1, 0, NIL, NIL, NIL, NIL, NIL, {"Informe um Banco!!!"})
				xRet := .F.
			EndIf
		EndIf	
			/*	
            If lIsGrid
                cMsg += "É um FORMGRID com " + Alltrim(Str(nQtdLinhas)) + " linha(s)." + CRLF
                cMsg += "Posicionado na linha " + Alltrim(Str(nLinha)) + CRLF
            Else
                cMsg += "É um FORMFIELD" + CRLF
            EndIf
 
            xRet := ApMsgYesNo(cMsg + "Continua?")
 
        ElseIf cIdPonto == "FORMLINEPRE"
            If aParam[5] == "DELETE"
                cMsg := "Chamada na pré validação da linha do formulário. " + CRLF
                cMsg += "Onde esta se tentando deletar a linha" + CRLF
                cMsg += "ID " + cIdModel + CRLF
                cMsg += "É um FORMGRID com " + Alltrim(Str(nQtdLinhas)) + " linha(s)." + CRLF
                cMsg += "Posicionado na linha " + Alltrim(Str(nLinha)) + CRLF
                xRet := ApMsgYesNo(cMsg + " Continua?")
            EndIf
 
        ElseIf cIdPonto == "FORMLINEPOS"
            cMsg := "Chamada na validação da linha do formulário." + CRLF
            cMsg += "ID " + cIdModel + CRLF
            cMsg += "É um FORMGRID com " + Alltrim(Str(nQtdLinhas)) + " linha(s)." + CRLF
            cMsg += "Posicionado na linha " + Alltrim(Str(nLinha)) + CRLF
            xRet := ApMsgYesNo(cMsg + " Continua?")
		*/
        //Pré validações do Commit
		ElseIf cIdPonto == 'FORMCOMMITTTSPRE'
		
		//Pós validações do Commit
		ElseIf cIdPonto == 'FORMCOMMITTTSPOS'
			
		//Commit das operações (antes da gravação)
		ElseIf cIdPonto == 'MODELCOMMITTTS'
			
		//Commit das operações (após a gravação)
		ElseIf cIdPonto == 'MODELCOMMITNTTS'
			nOper := oObj:nOperation
 		
        If cIdPonto == "MODELCANCEL"
            cMsg := "Deseja realmente sair?"
            xRet := ApMsgYesNo(cMsg)
		EndIf
       // ElseIf cIdPonto == "BUTTONBAR"
       //     xRet := {{"Salvar", "SALVAR", {||u_TSMT020()}}}
  EndIf      
Return xRet
