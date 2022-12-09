#include "rwmake.ch"

User Function PesqCEP(_cCampo)

/*                                                      
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PesqCEP   ³ Autor ³ Johnny Osugi          ³ Data ³ 01.12.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Gatilho para preencher os campos ENDERECO, CIDADE, UF e     ³±±
±±³          ³BAIRRO do Cadastro SA1 (Clientes).                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Drogaria Iporanga-Especifico                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//----------------------------------------------//
//          Guarda ambiente original            //
//----------------------------------------------//

    Local _cAlias 	:= Alias()
    Local _cOrder 	:= Indexord()
    Local _cRec   	:= Recno()
    Local _cEnd		:= ""

//----------------------------------------------//
//  Posiciona no arquivo SZA (arquivo de CEP)   //
//----------------------------------------------//

    DbSelectArea( "SZA" )
    DbSetOrder( 1 )

    If _cCampo == "A1_CEP"

        If DbSeek( xFilial("SZA") + M->&_cCampo)

            //If Empty(M->A1_END)
            _cEnd			:=	SZA->ZA_LOGRAD
            M->A1_END     	:=  SZA->ZA_LOGRAD
            M->A1_MUN     	:=  SZA->ZA_CIDADE
            M->A1_EST     	:=  SZA->ZA_UF
            M->A1_BAIRRO  	:=  SZA->ZA_BAIRRO
            //Else
	 	/*
            If !Rtrim(SZA->ZA_LOGRAD) $ M->A1_END
	 			MsgBox("Endereco diferente do cadastro de Logradouros, Verifique !"+CHR(10)+Rtrim(SZA->ZA_LOGRAD),"Atencao !")
            Endif
            If !Rtrim(SZA->ZA_CIDADE) $ M->A1_MUN
	 			MsgBox("Municipio diferente do cadastro de Logradouros, Verifique !"+CHR(10)+Rtrim(SZA->ZA_CIDADE),"Atencao !")
            Endif
            If !Rtrim(SZA->ZA_UF) $ M->A1_EST
	 			MsgBox("Estado diferente do cadastro de Logradouros, Verifique !"+CHR(10)+Rtrim(SZA->ZA_UF),"Atencao !")
            Endif
	 		_cEnd := M->A1_END
        Endif*/
   		
    Else
   			
		MsgBox("CEP nao encontrado !"+M->&_cCampo)   				
	
    EndIf
	
ElseIf _cCampo == "A1_CEPC"  // CEP de Cobrança
	
    If DbSeek( xFilial("SZA") + M->&_cCampo)
 		
 		//If Empty(M->A1_ENDCOB)
			_cEnd			:=	SZA->ZA_LOGRAD
	   		M->A1_ENDCOB   	:=  SZA->ZA_LOGRAD
	   		M->A1_MUNC    :=  SZA->ZA_CIDADE
	   		M->A1_ESTC   	:=  SZA->ZA_UF
	 		M->A1_BAIRROC  	:=  SZA->ZA_BAIRRO
	 	//Else
	 	/*
        If !Rtrim(SZA->ZA_LOGRAD) $ M->A1_ENDCOB
	 			MsgBox("Endereco diferente do cadastro de Logradouros, Verifique !"+CHR(10)+Rtrim(SZA->ZA_LOGRAD),"Atencao !")
        Endif
        If !Rtrim(SZA->ZA_CIDADE) $ M->A1_MUNC
	 			MsgBox("Municipio diferente do cadastro de Logradouros, Verifique !"+CHR(10)+Rtrim(SZA->ZA_CIDADE),"Atencao !")
        Endif
        If !Rtrim(SZA->ZA_UF) $ M->A1_ESTC
	 			MsgBox("Estado diferente do cadastro de Logradouros, Verifique !"+CHR(10)+Rtrim(SZA->ZA_UF),"Atencao !")
        Endif
	 		_cEnd := M->A1_ENDCOB
    Endif*/
   		
Else
   			
		MsgBox("CEP nao encontrado !"+M->&_cCampo)   				
	
EndIf
                                        
ElseIf _cCampo == "A1_CEPE"  // CEP de Entrega
	
    If DbSeek( xFilial("SZA") + M->&_cCampo)

 		//If Empty(M->A1_ENDENT)
	   		_cEnd			:=	SZA->ZA_LOGRAD
	   		M->A1_ENDENT   	:=  SZA->ZA_LOGRAD
	   		M->A1_MUNE	    :=  SZA->ZA_CIDADE
	   		M->A1_ESTE   	:=  SZA->ZA_UF
	 		M->A1_BAIRROE  	:=  SZA->ZA_BAIRRO

	 	//Else
	 	/*
        If !Rtrim(SZA->ZA_LOGRAD) $ M->A1_ENDENT
	 			MsgBox("Endereco diferente do cadastro de Logradouros, Verifique !"+CHR(10)+Rtrim(SZA->ZA_LOGRAD),"Atencao !")
        Endif
        If !Rtrim(SZA->ZA_CIDADE) $ M->A1_MUNE
	 			MsgBox("Municipio diferente do cadastro de Logradouros, Verifique !"+CHR(10)+Rtrim(SZA->ZA_CIDADE),"Atencao !")
        Endif
        If !Rtrim(SZA->ZA_UF) $ M->A1_ESTE
	 			MsgBox("Estado diferente do cadastro de Logradouros, Verifique !"+CHR(10)+Rtrim(SZA->ZA_UF),"Atencao !")
        Endif
	 		_cEnd := M->A1_ENDENT
    Endif*/
   		
Else
   			
		MsgBox("CEP nao encontrado !"+M->&_cCampo)   				
	
EndIf
	

ElseIf _cCampo == "US_CEP" // Prospect
	
    If DbSeek( xFilial("SZA") + M->&_cCampo)
	

 		//If Empty(M->US_END)
			_cEnd			:=	SZA->ZA_LOGRAD
	   		M->US_END     	:=  SZA->ZA_LOGRAD
	   		M->US_MUN     	:=  SZA->ZA_CIDADE
	   		M->US_EST     	:=  SZA->ZA_UF
	 		M->US_BAIRRO  	:=  SZA->ZA_BAIRRO
	 	//Else
	 		/*
        If !Rtrim(SZA->ZA_LOGRAD) $ M->US_END
	 			MsgBox("Endereco diferente do cadastro de Logradouros, Verifique !"+CHR(10)+Rtrim(SZA->ZA_LOGRAD),"Atencao !")
        Endif
        If !Rtrim(SZA->ZA_CIDADE) $ M->US_MUN
	 			MsgBox("Municipio diferente do cadastro de Logradouros, Verifique !"+CHR(10)+Rtrim(SZA->ZA_CIDADE),"Atencao !")
        Endif
        If !Rtrim(SZA->ZA_UF) $ M->US_EST
	 			MsgBox("Estado diferente do cadastro de Logradouros, Verifique !"+CHR(10)+Rtrim(SZA->ZA_UF),"Atencao !")
        Endif
	 		_cEnd := M->US_END
    Endif*/
 		
 		
   		
Else
   			
		MsgBox("CEP nao encontrado !"+M->&_cCampo)   				
	
EndIf

Endif

//----------------------------------------------//
//         Restaura ambiente original           //
//----------------------------------------------//

DbSelectArea( _cAlias )  // .......... >>>----> Area de Arquivo
DbSetOrder( _cOrder )  // ............ >>>----> Area de Indice
DbGoto(_cRec)

Return(_cEnd)