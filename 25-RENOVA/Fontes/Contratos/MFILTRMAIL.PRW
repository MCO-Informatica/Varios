/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o ³ MFILTRMAIL	³ Autor ³ Gileno Pereira   ³ Data ³ 26/08/2019³    ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de entrada para mandar msg apenas para o gestor      ³±±
±± do contrato.								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe:MFILTRMAIL - Filtro de e-mail ( [ cParUsuario ], 		  ³±±
±± [cParGrUsuario ], [ cParEmails ] ) --> aRetorMail                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cParGrUsuario/cParEmails/ cParUsuario                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno : aRetorMail(vetor)                      			  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                       

#INCLUDE "PROTHEUS.CH"   

User Function MFILTRMAIL()

Local cParUsuario 	:= PARAMIXB[1]			//   String com os usuários que devem receber o e-mail do Messenger 
Local cParGrUsuario	:= PARAMIXB[2]			//   String com os grupos de usuários que devem receber o e-mail do Messenger 
Local cParEmails 	:= PARAMIXB[3]			//   String com as contas de e-mail avulsas que devem receber o e-mail do Messenger  
Local aArray 		:= {}			    	//   Array com informações do usuário do campo CN9->CN9_XCODGE   
Local cUnidade  	
  
	If cmodulo=="GCT"   
		cUnidade  	:= CN9->CN9_XUNIDR
		If !EMPTY(cUnidade)// se o contrato estiver com o campo unidade requisitante vazio, pula o contrato
			dbSelectArea("SY3")
			dbSetOrder(1) //Y3_FILIAL + Y3_COD
			dbSeek(xFilial("SY3") + cUnidade)//Uso a unidade requisitante do contrato(cn9_xunidir) para dar o seek na unidade requisitante
			If cFormEvent == "038" .OR. cFormEvent == "039" .or. cFormEvent == "040" .or. cFormEvent == "041"
				cParUsuario     := Y3_XAPROV
				cParEmails 		:= alltrim(FWSFALLUSERS({SY3->Y3_XAPROV})[1][5]) 
			EndIf
		EndIf
		// se o usuário estiver sem email cadastrado, mande o aviso para o email do administrador do ambiente
		If Empty(cParEmails)
	    	cParUsuario:=GetNewPar('REN_USRCT','000091')
	    	cParEmails :=alltrim(FWSFALLUSERS({cParUsuario})[1][5]) 
	  	End     
    Endif
Return({cParUsuario,cParGrUsuario,cParEmails}) // Pâmetros para a função(no fonte matxfunc) 


