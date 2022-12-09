#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#include "Ap5Mail.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A250ETRAN  ºAutor  ³Edson Nogueira      º Data ³  29/06/16  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validar os valores apresentados na Ordem de Produção em    º±±
±±º          ³ relação aos Valores informados no Apontamento da Produção  º±±   
±±º          ³ e enviar email para o Gestor, quando exceder o limite      º±± 
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 12                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function A250ETRAN ()
   
Local _aSavArea := GetArea()
Local _aSavSD3	:= SD3->(GetArea())
Local _cQuery   := ""  
Private _cAlias   := GETNEXTALIAS() 

Private  cfrom := ""
Private  cTo := "" 
Private  cSubject := ""     
Private  cBody := ""     
Private  _cFiles := ""  


_cQuery := "SELECT SUM(SD3.D3_QUANT) AS [D3_QUANT] FROM "+ Retsqlname("SD3") + " SD3 "
_cQuery += "WHERE SD3.D_E_L_E_T_='' "
_cQuery += "AND SD3.D3_FILIAL='"+xFilial("SD3")+"' "
_cQuery += "AND SD3.D3_OP='"+SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN + SC2->C2_ITEMGRD +"' "
_cQuery += "AND SD3.D3_CF LIKE 'PR%' "
_cQuery += "AND SD3.D3_ESTORNO='' "                                                                
      
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery), _cAlias,.T.,.F.)
dbSelectArea(_cAlias)

If (_cAlias)->(!EOF())

	If (_cAlias)->D3_QUANT > (((SuperGetMV("MV_TOLPROD",,10)/100)+1) * SC2->C2_QUANT)  // COLOCAR E EXPLICAÇÃO DO PARAMETRO PROTHEUS 
		Alert("A Quantidade informada no Apontamento Produção, Número '" + SC2->C2_NUM + "' corresponde a '"  + ALLTRIM (STR((_cAlias)->D3_QUANT))+; 
		"', excedendo a Quantidade informada na Ordem de Produção '" + ALLTRIM (STR(SC2->C2_QUANT)) + "'.")
	   	//SendMail()

		_cTitulo:= "Apontamento Produção excedeu a Ordem de Produção"	   	
	   	_cMsg	:= "A Quantidade informada no Apontamento Produção, Número '" + SC2->C2_NUM + "' corresponde a  '"  + ALLTRIM (STR((_cAlias)->D3_QUANT))+ ; 
	         	"', excedendo a Quantidade informada na Ordem de Produção '" + ALLTRIM (STR(SC2->C2_QUANT)) + "'."
	    
	    _cMail	:= GETMV("MV_MAILAPO")
		//_cMail	:= "ricardo.oliveira@prozyn.com.br;anderson.brito@prozyn.com.br;michel.santos@prozyn.com.br" //+ ";" + Alltrim(UsrRetMail(_cUser))  	              	
		//_cMail	:= "ricardo.oliveira@prozyn.com.br;sandro.javarez@prozyn.com.br;michel.santos@prozyn.com.br" //+ ";" + Alltrim(UsrRetMail(_cUser))  	         	

		If ExistBlock("RCFGM001")
		   	U_RCFGM001(_cTitulo,_cMsg,_cMail)
	   	EndIf
	EndIf
	
EndIf

DBSELECTAREA(_cAlias)
DBCLOSEAREA()
RestArea(_aSavSD3) 
RestArea(_aSavArea) 

Return()


// ********** envio de email na inclusao do Apontamento Produção, quando exceder o limite informado no Parâmetro "MV_TOLPROD"
		
Static Function SendMail()

If ! INCLUI 
Return .F.
Endif  


cAccount	:= GetMv("MV_RELACNT")
cPassword	:= GetMv("MV_RELPSW")
cServer		:= GetMv("MV_RELSERV")
cCC			:= ''   

cFrom       := "protheus@prozyn.com.br"
cTo			:= "ricardo.oliveira@prozyn.com.br;michel.santos@prozyn.com.br;anderson.brito@prozyn.com.br;demandas.totvs@prozyn.com.br" //+ ";" + Alltrim(UsrRetMail(_cUser))  
cSubject	:= "Apontamento Produção excedeu a Ordem de Produção"


cBody		:= "A Quantidade informada no Apontamento Produção, Número '" + SC2->C2_NUM + "' corresponde a  '"  + ALLTRIM (STR((_cAlias)->D3_QUANT))+ ; 
	         	"', excedendo a Quantidade informada na Ordem de Produção '" + ALLTRIM (STR(SC2->C2_QUANT)) + "'."

Connect Smtp Server cServer Account cAccount Password cPassword Result lOk
If	lOk
	If ! MailAuth(cAccount,cPassword)
		Get Mail Error cErrorMsg
		Help("",1,"AVG0001056",,"Error: "+cErrorMsg,2,0)
		Disconnect Smtp Server Result lOk
		If !lOk
			Get Mail Error cErrorMsg
			Help("",1,"AVG0001056",,"Error: "+cErrorMsg,2,0)
		Endif
		Return ( .f. )
	EndIf
	Send Mail From cFrom To cTo CC cCC Subject cSubject Body cBody Format Text Attachment _cFiles Result lOk  //Attachment _aFiles
	If ! lOk
		Get Mail Error cErrorMsg
		Help("",1,"AVG0001056",,"Error: "+cErrorMsg,2,0)
	EndIf
Else
	Get Mail Error cErrorMsg
	Help("",1,"AVG0001057",,"Error: "+cErrorMsg,2,0)
EndIf
Disconnect Smtp Server

Return()
