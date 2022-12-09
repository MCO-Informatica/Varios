#include "rwmake.ch" 
#include "Ap5Mail.ch"
#INCLUDE "PROTHEUS.CH"
#include "MSGRAPHI.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT120GRV  ºAutor  ³Leonardo Ibelli     º Data ³  27/06/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Ponto de entrada na confirmação do pedido de compras      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP12 -Prozyn                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
                             
User Function MT120GRV()

_cAlias	:= Alias()
_nRec	:= Recno()
_nIndex	:= IndexOrd()

Private 	_cItem :=""	 	
Private	    _cProd :="" 	
Private		_cDescri :="" 	
Private		_cUm	:="" 	
Private		_nQuant	 :=0	
//Private	_nPreco	 		
Private		_cSegUm	 :=""	
Private		_nSegQuant := 0			
//Private		_nTotal	 := 0	
Private    _dEntrega := Ctod("  /  /  ")  

If INCLUI 
 /*	If MsgBox("Deseja enviar por email?","YESNO","YESNO")
		_cCorpo := SPACE(300)
		DEFINE MSDIALOG oDlg5 TITLE "CorpoMail" FROM 000, 000  TO 100, 500 COLORS 0, 16777215 PIXEL
		@ 007, 003 SAY oSay1 PROMPT "Informacoes adicionais no corpo do email:" SIZE 182, 014 OF oDlg5 COLORS 0, 16777215 PIXEL
		@ 019, 003 MSGET cCorpo VAR _cCorpo SIZE 236, 012 OF oDlg5 COLORS 0, 16777215 PIXEL
		DEFINE SBUTTON oOK FROM 034, 212 TYPE 01 OF oDlg5 ENABLE ACTION Close(oDlg5)
		ACTIVATE MSDIALOG oDlg5 CENTERED  */
   
	DbSelectArea("SA2")
    dbSetorder(1)                                                                                                  
	dbSeek(xFilial("SA2") + CA120FORN + CA120LOJ) 
	
	      IF SA2->A2_STATUS = "2"
	      		SendMail()	      			
	      END IF	
		
	   
Endif 
 
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SendMail  ºAutor  ³Microsiga           º Data ³  19/06/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Enviara pedido por email quando fornecedor não é homologado º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/   

// ********** envio de email na inclusao do atendimento

Static Function SendMail()

Local _aSavArea 	:= GetArea() 
Local _aSavSC7  	:= {} 
Local cNum      	:= PARAMIXB[1]
Local lInclui   	:= PARAMIXB[2]
Local lAltera   	:= PARAMIXB[3]
Local lExclui   	:= PARAMIXB[4]
Local lRet      	:= .T.
Local nPosItem		:= aScan(aHeader,{|x|Alltrim(x[2]) == "C7_ITEM"})
Local nPosProd		:= aScan(aHeader,{|x|Alltrim(x[2]) == "C7_PRODUTO"})
Local nPosDescri	:= aScan(aHeader,{|x|Alltrim(x[2]) == "C7_DESCRI"})
Local nPosUm		:= aScan(aHeader,{|x|Alltrim(x[2]) == "C7_UM"})
Local nPosQuant		:= aScan(aHeader,{|x|Alltrim(x[2]) == "C7_QUANT"})
//Local nPosPreco		:= aScan(aHeader,{|x|Alltrim(x[2]) == "C7_PRECO"})
Local nPosSegum		:= aScan(aHeader,{|x|Alltrim(x[2]) == "C7_SEGUM"})
Local nPosQtSeg		:= aScan(aHeader,{|x|Alltrim(x[2]) == "C7_QTSEGUM"})
//Local nPosTotal		:= aScan(aHeader,{|x|Alltrim(x[2]) == "C7_TOTAL"})
Local nPosEntrega	:= aScan(aHeader,{|x|Alltrim(x[2]) == "C7_DATPRF"})
Local i             :=1

DbSelectArea("SC7")
_aSavSC7 := SC7->(GetArea())

_cPedido   := cNum
_cFornece  := CA120FORN
//_cUser     := SC7->C7_USER

_nTotPed := 0	
_nPag		:= 1
/*
PswOrder(1)
PswSeek(AllTrim(_cUser),.T.)
aConfUsr    := PswRet(1)
_cMailUSr   := aConfUsr[1,14]                   
*/
nItem 		:= 0

_cNomFor 	:= Posicione("SA2",1,xFilial("SA2") + CA120FORN + CA120LOJ,"A2_NOME")
_cMunForn   := Posicione("SA2",1,xFilial("SA2") + CA120FORN + CA120LOJ ,"A2_MUN")
_cUFForn    := Posicione("SA2",1,xFilial("SA2") + CA120FORN + CA120LOJ ,"A2_EST")

_nSavNF     := MaFisSave() 

lOk			:= .T.
cAccount	:= GetMv("MV_RELACNT")
cPassword	:= GetMv("MV_RELPSW")
cServer		:= GetMv("MV_RELSERV")
cCC			:= ''
/*
If Substr(Rtrim(_cMailUSr),-12) $ "leonardo@crintelligence.com.br"
	cFrom		:= Rtrim(_cMailUSr)
Else
	cFrom		:= "leonardo@crintelligence.com.br"
Endif
*/
cFrom       := "protheus@prozyn.com.br"
cTo			:= SuperGetMV("MV_EMAILRE",,"")  
//cBCC		:= ''
cSubject	:= "Pedido de Compra para fornecedor não homologado"
cBody		:= "Foi incluído um pedido de compra para um fornecedor não homologado. Abaixo os detalhes: <P>"
cBody		+= " <P>"
cBody		+= " <P>"
cBody		+= "Codigo Fornecedor: " + _cFornece + "   Nome Fornecedor: " + _cNomFor + " <P>"	
cBody		+= "Municipio Fornecedor: " + _cMunForn + "   Estado Fornecedor: " + _cUFForn + " <P>"	


cBody		+= "<TABLE BORDER=1> <P>"
cBody		+= "<TR>"	
cBody       += "<TH>Item</TH>" 
cBody       += "<TH>Codigo</TH>
cBody       += "<TH>Descricao</TH>"
cBody       += "<TH>Un</TH>"
cBody       += "<TH>Quant.</TH>"
cBody       += "<TH>Data de Entrega.</TH>"
//cBody       += "<TH>Valor Total</TH>"
cBody       += "</TR> <P>"

For i:=1 to Len(aCols)
	_cItem	 	:= aCols[i][nPosItem]
	_cProd	 	:= aCols[i][nPosProd]
	_cDescri 	:= aCols[i][nPosDescri]
	_cUm	 	:= aCols[i][nPosUm]
	_nQuant	 	:= aCols[i][nPosQuant]
	//_nPreco	 	:= aCols[i][nPosPreco]	
	_cSegUm	 	:= aCols[i][nPosSegUm]
	_nSegQuant 	:= aCols[i][nPosQtSeg]		
	//_nTotal	 	:= aCols[i][nPosTotal]	
    _dEntrega   := aCols[i][nPosEntrega]

	If CA120NUM == _cPedido
		nItem += 1
		cBody		+= "<TR>"		                                	
		cBody		+= "<TD><b>" + _cItem                               	            + "</b></TD>"
		cBody		+= "<TD><b>" + _cProd                                   		    + "</b></TD>" 
		cBody		+= "<TD><b>" + _cDescri										     	+ "</b></TD>" 
		If Empty(SC7->C7_SEGUM)
 //			cBody		+= "<TR>"		
			cBody		+= "<TD><b>" + _cUm		                                     	+ "</b></TD>"
			cBody		+= "<TD><b>" + STR(_nQuant,9,2)                                	+ "</b></TD>"
	//		cBody		+= "<TD><b>" + STR(_nPreco,11,2)                               	+ "</b></TD>"
			cBody       += "<TD><b>" + DTOC(_dEntrega)   
		Else
	//		cBody		+= "<TR>"		
			cBody		+= "<TD><b>" + _cSegUm		                                 	+ "</b></TD>"
			cBody		+= "<TD><b>" + STR(_nSegQuant,9,2)                              + "</b></TD>"  
			cBody		+= "</TR>" + "<P>"	
		EndIf
	//	cBody		+= "<TR>"		
	//	cBody		+= "<TD><b>" + TRANSFORM(_nTotal,"@E 999,999,999.99")               + "</b></TD>"
	  		
		//_nTotPed 	:= _nTotPed + _nTotal + _nValIpi						
  	EndIf	
Next
	
MaFisEnd()
	
/*cBody		+= "<TH COLSPAN=5>Valor Total: </TH> <TD> " + STR(_nTotPed,12,2) + "</TD> <P>"
cBody		+= " </TABLE> <P>"
cBody		+= " <P>"
cBody		+= " <P>"
cBody		+= "Muito obrigado(a) <P>"
cBody		+= " <P>"
cBody		+= "Atenciosamente, <P>"
cBody		+= " <P>"
cBody		+= "Prozyn <P>"
*/
_cFiles := ""
For i:= 1 to _nPag
	If _cFiles == ""
		_cFiles := "\SendMails\PC"+_cPedido+"_pag"+Alltrim(Str(i)+".jpg")
	Else
		_cFiles := _cFiles + ",\SendMails\PC"+_cPedido+"_pag"+Alltrim(Str(i)+".jpg")
	Endif
Next

MaFisRestore(_nSavNF) 

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

For i:= 1 to _nPag
	Ferase("\SendMails\PC"+_cPedido+"_pag"+Alltrim(Str(i)+".jpg"))
Next
		        
RestArea(_aSavSC7)
RestArea(_aSavArea)
	
DbSelectArea(_cAlias)
DbSetOrder(_nIndex)
DbgoTo(_nRec)

Return(lRet)