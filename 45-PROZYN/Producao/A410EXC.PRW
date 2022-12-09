#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02
#Include "Protheus.ch"
#Include "Topconn.ch"           

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿ ±±
±±³Programa: A410EXC   ³Autor: NEWBRIDGE              ³ Data:   14/10/18 ³ ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ ±±
±±³Descri‡ao: Bloqueio na EXCLUSAO  de Pedidos de Venda.                 ³ ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ ±±
±±³Uso      : Especifico PROZYN.                                         ³ ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function A410EXC()        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*SetPrvt("_CALIAS,_NINDEX,_NREG,_LRET,")

Private oGrpLog
Private oBtnConf
Private lRetorno := .F.
Private oDlgPvt
//Says e Gets
Private oSayUsr
Private oGetUsr, cGetUsr := Space(25)
Private oSayPsw
Private oGetPsw, cGetPsw := Space(20)
Private oGetErr, cGetErr := ""
//Dimensões da janela
Private nJanLarg := 200
Private nJanAltu := 200


cAprCc := SuperGetMv('MV_APROVCL',,"newbridge") 
cPrzAl := SuperGetMv('MV_PRZALT',,15)  


lReturn   := .T.

		If (SC5->C5_FECENT <= ddatabase + cPrzAl)
      
    		If !Upper(AllTrim(Subs(cUsuario,7,15))) $ upper(cAprCc)   
    			If MSGYESNO( "Esse Pedido está Fora do Prazo de Exclusão!!! "+ chr(13) + chr(10) +" Deseja Continuar!","Atenção" ," Tempo de Produção + Laudo Externo"  )
    			 	   			 	
    			 		//Criando a janela de autoriação superior
				  			DEFINE MSDIALOG oDlgPvt TITLE "Solic.Autoriz.Superior" FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
				        	//Grupo de Login
				        	@ 003, 001     GROUP oGrpLog TO (nJanAltu/2)-1, (nJanLarg/2)-3         PROMPT "Autoriz.Exclusão.Pedido: "     OF oDlgPvt COLOR 0, 16777215 PIXEL
				            //Label e Get de Usuário
				            @ 013, 006   SAY   oSayUsr PROMPT "Usuário:"        SIZE 030, 007 OF oDlgPvt                    PIXEL
				            @ 020, 006   MSGET oGetUsr VAR    cGetUsr           SIZE (nJanLarg/2)-12, 007 OF oDlgPvt COLORS 0, 16777215 PIXEL
				         
				            //Label e Get da Senha
				            @ 033, 006   SAY   oSayPsw PROMPT "Senha:"          SIZE 030, 007 OF oDlgPvt                    PIXEL
				            @ 040, 006   MSGET oGetPsw VAR    cGetPsw           SIZE (nJanLarg/2)-12, 007 OF oDlgPvt COLORS 0, 16777215 PIXEL PASSWORD
				         
				            //Get de Log, pois se for Say, não da para definir a cor
				            @ 060, 006   MSGET oGetErr VAR    cGetErr        SIZE (nJanLarg/2)-12, 007 OF oDlgPvt COLORS 0, 16777215 NO BORDER PIXEL
				            oGetErr:lActive := .F.
				            oGetErr:setCSS("QLineEdit{color:#FF0000; background-color:#FEFEFE;}")
				         
				            //Botões
				            @ (nJanAltu/2)-18, 006 BUTTON oBtnConf PROMPT "Confirmar"             SIZE (nJanLarg/2)-12, 015 OF oDlgPvt ACTION (fVlUr3()) PIXEL
				            oBtnConf:SetCss("QPushButton:pressed { background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #dadbde, stop: 1 #f6f7fa); }")
	    					ACTIVATE MSDIALOG oDlgPvt CENTERED
	     
	    					//Se a rotina foi confirmada e deu certo, atualiza o usuário e a senha E AS DATAS FORÇADAS
	    					If lRetorno
        						
        						cUsrLog := Alltrim(cGetUsr)
        						cPswLog := Alltrim(cGetPsw)
	        				   
	        					RECLOCK("SC5",.F.)
	        					SC5->C5_LGEXCLP:= CVALTOCHAR("EXC"+dtoc(ddatabase)+"-"+cUsrLog)
	        					SC5->(MsUnlock())

        					lReturn := .T.
        				
        					Else
        					lReturn := .F.	
    					
    						EndIf
    			 	
    			 	
    			 	
    		 	Else
        		
        		lReturn := .F.
        		
        		Endif
        		
    		EndIf
		
		EndIf

Return(lReturn)        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02
*/
Return .T.

//função criada para validar o login e comparar com o parametro que identifica se o usuario é um aprovador do ciclo do pedido. 

Static Function fVlUr3()       
	Local cAprCic 	:= SuperGetMv('MV_APRVCL1',,"newbridge") //definir os aprovadores 
    Local cUsrAux := Alltrim(cGetUsr)
    Local cPswAux := Alltrim(cGetPsw)
    Local cCodAux := ""
     
    //Pega o código do usuário
    PswOrder(2)
    If !Empty(cUsrAux) .And. PswSeek(cUsrAux) .And. cUsrAux $ cAprCic //compara com o parametro de aprovadores 
         cCodAux := PswRet(1)[1][1]
      
         //Agora verifica se a senha bate com o usuário
         If !PswName(cPswAux)
             cGetErr := "Senha inválida!"
             oGetErr:Refresh()
            Return
         
        //Senão, atualiza o retorno como verdadeiro
        Else
            lRetorno := .T.
        endif
      
     //Senão atualiza o erro e retorna para a rotina
     Else
         cGetErr := "Usuário não Autorizado!"
         oGetErr:Refresh()
         Return
    EndIf
    				
     
    //Se o retorno for válido, fecha a janela
    If lRetorno
       oDlgPvt:End()
    EndIf
Return



