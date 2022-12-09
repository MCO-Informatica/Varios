#include 'Protheus.ch'
#INCLUDE "TopConn.ch"
#INCLUDE "ap5mail.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MailExp  ºAutor  ³Luiz Alberto          º Data ³  29/04/14 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Envia Email aos Responsaveis da Expedicao sobre o Enderecto.
				dos Pedidos de Venda/Notas Fiscais         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MailExp(aNotas)
Local aAreaSF2 := SF2->(GetArea())
Local aAreaSD2 := SD2->(GetArea())
Local aAreaSC5 := SC5->(GetArea())
Local aAreaSC6 := SC6->(GetArea())
Private nLineSize    := 60
Private nTabSize     := 3
Private lWrap        := .T. 
Private nLine        := 0
Private lServErro	   := .T.
Private aProds			:= {}
Private _cAnexo    := 'EXP'+DtoS(dDataBase)+'.HTML'

For nNotas := 1 To Len(aNotas)
	If SF2->(dbSetOrder(1), dbSeek(xFilial("SF2")+aNotas[nNotas,1]+aNotas[nNotas,2])) .And. SF2->F2_TIPO == 'N' .And. SF2->F2_VALFAT > 0.00
		SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
		SA4->(dbSetOrder(1), dbSeek(xFilial("SA4")+SF2->F2_TRANSP))
		
		If SD2->(dbSetOrder(3), dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
			While SD2->(!Eof()) .And. SD2->D2_DOC == SF2->F2_DOC .And. SD2->D2_SERIE == SF2->F2_SERIE .And. SD2->D2_CLIENTE == SF2->F2_CLIENTE .And. SD2->D2_LOJA == SF2->F2_LOJA
				If SC6->(dbSetOrder(2), dbSeek(xFilial("SC6")+SD2->D2_COD+SD2->D2_PEDIDO+SD2->D2_ITEMPV))
					SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+SC6->C6_NUM))
	
					If SC5->(FieldPos("C5_PEDWEB")) > 0
						If !Empty(SC5->C5_PEDWEB) // Pedido Sealbag Não ENTRA
							SD2->(dbSkip(1));Loop
						Endif
					Endif                              
					
					If SC6->(FieldPos("C6_XENDPRO")) > 0   
						If Empty(SC6->C6_XENDPRO)
							SD2->(dbSkip(1));Loop
						Endif
					Endif
					
					AAdd(aProds,{SF2->F2_DOC,;   			// 1
									SF2->F2_SERIE,;         // 2
									SF2->F2_CLIENTE,;       // 3
									SF2->F2_LOJA,;          // 4
									SC6->C6_NUM,;           // 5
									SC6->C6_PRODUTO,;       // 6
									SC6->C6_DESCRI,;        // 7
									SD2->D2_QUANT,;         // 8
									Iif(SC6->(FieldPos("C6_XENDPRO")) > 0,SC6->C6_XENDPRO,'XYZ')}) // 9
				Endif
				
				SD2->(dbSkip(1))
			Enddo
		Endif
	Endif
Next

// Se Localizar os Produtos da Nota Fiscal Então Monta o Corpo do Email e Envia
If !Empty(Len(aProds))                                                 
	GeraHtml(_cAnexo,aProds) //Gera HTML

	cAccount	:= RTrim(SuperGetMV("MV_RELACNT"))
	cFrom		:= RTrim(SuperGetMV("MV_RELFROM"))
	cPara		:= SuperGetMV('MV_USREND', .F., 'expedicao@metalacre.com.br;eduardo.silva@metalacre.com.br;mariana@metalacre.com.br') 
	cAssunto	:= 'Localização Notas Fiscais/Pedidos por Endereço'
	cPassword	:= Rtrim(SuperGetMv("MV_RELAPSW"))
	cServer   	:= Rtrim(SuperGetMv("MV_RELSERV"))
	aAnexos		:= {}
	cEmailTo := cPara						// E-mail de destino
	cEmailBcc:= ""							// E-mail de copia
	lResult  := .F.							// Se a conexao com o SMPT esta ok
	cError   := ""							// String de erro
	lRelauth := SuperGetMv("MV_RELAUTH")		// Parametro que indica se existe autenticacao no e-mail
	lRet	   := .F.							// Se tem autorizacao para o envio de e-mail
	cConta   := GetMV("MV_RELACNT") //ALLTRIM(cAccount)				// Conta de acesso 
	cSenhaTK := GetMV("MV_RELPSW") //ALLTRIM(cPassword)	        // Senha de acesso
	
	_cAnexo	:= Rtrim(_cAnexo) 
	cMensagem  := AllTrim(MemoRead(_cAnexo))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Envia o mail para a lista selecionada. Envia como BCC para que a pessoa pense³
	//³que somente ela recebeu aquele email, tornando o email mais personalizado.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	CONNECT SMTP SERVER cServer ACCOUNT cConta PASSWORD cSenhaTK RESULT lResult
	
	// Se a conexao com o SMPT esta ok
	If lResult
	
		// Se existe autenticacao para envio valida pela funcao MAILAUTH
		If lRelauth
			lRet := Mailauth(cConta,cSenhaTK)	
		Else
			lRet := .T.	
	    Endif    
		
		If lRet
			SEND MAIL FROM cFrom ;
			TO      	cEmailTo;
			SUBJECT 	cAssunto;
			BODY    	cMensagem;
			RESULT lResult
	
			If !lResult
				//Erro no envio do email
				GET MAIL ERROR cError
					Help(" ",1,'Erro no Envio do Email',,cError+ " " + cEmailTo,4,5)	//Atenção
			Else
				FErase(_cAnexo)
			Endif
	
		Else
			GET MAIL ERROR cError
			Help(" ",1,'Autenticação',,cError,4,5)  //"Autenticacao"
			MsgStop('Erro de Autenticação','Verifique a conta e a senha para envio') 		 //"Erro de autenticação","Verifique a conta e a senha para envio"
		Endif
			
		DISCONNECT SMTP SERVER
		
	Else
		//Erro na conexao com o SMTP Server
		GET MAIL ERROR cError
		Help(" ",1,'Erro no Envio do Email',,cError,4,5)      //Atencao
	Endif
Endif
RestArea(aAreaSF2)
RestArea(aAreaSD2)
RestArea(aAreaSC5)
RestArea(aAreaSC6)
Return        

Static Function GeraHtml(cArqOrc,aProds)
Private nTotOrc		:= 0
Private nLin 		:= 0
//Private cOrc		:= "000010"

nHdl := Fcreate(cArqOrc)

//+CHR(13)+CHR(10)

cLin := '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'
cLin += '<html>'
cLin += '<head>'
cLin += '  <meta '
cLin += ' content="text/html; charset=ISO-8859-1" '
cLin += ' http-equiv="content-type"> '
cLin += '  <title>emailexpedicaometalacre</title> '
cLin += '</head> '
cLin += '<body> '

cDoc := ''
cSer := ''
nNotas := 1

While nNotas <= Len(aProds)
	SF2->(dbSetOrder(1), dbSeek(xFilial("SF2")+aProds[nNotas,1]+aProds[nNotas,2]+aProds[nNotas,3]+aProds[nNotas,4]))
	SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+aProds[nNotas,5]))
	SA1->(dbSetOrder(1), dbSeek(xFilial("SA1")+aProds[nNotas,3]+aProds[nNotas,4]))
	
	If cDoc+cSer <> SF2->F2_DOC+SF2->F2_SERIE
		If nNotas > 1
			For NN := 1 To 5
				cLin += '     </tr> '
				cLin += '     <tr align="center"> '
				cLin += '       <td '
				cLin += '  style="background-color: rgb(153, 153, 153); width: 146px;" '
				cLin += '  colspan="4" rowspan="1"></td> '
				cLin += '     </tr> '
			Next
			cLin += '   </tbody> '
			cLin += ' </table> '
		Endif		
		cLin += '<table style="text-align: left; width: 100%;" '
		cLin += ' border="1" cellpadding="2" cellspacing="2"> '
		cLin += '  <tbody> '
		cLin += '    <tr> '
		cLin += '      <td '
		cLin += ' style="text-align: center; background-color: rgb(192, 192, 192); font-weight: bold;"><big><big>Metalacre</big></big></td> '
		cLin += '      <td '
		cLin += ' style="text-align: center; background-color: rgb(192, 192, 192); width: 146px;" '
		cLin += ' colspan="2" rowspan="1"><big><big>Dados '
		cLin += 'da Nota Fiscal/Pedido de Venda para Expedi&ccedil;&atilde;o</big></big></td> '
		cLin += '      <td '
		cLin += ' style="background-color: rgb(192, 192, 192);">Data: ' + DtoC(dDataBase)
		cLin += '<br> '
		cLin += 'Hora: ' + Left(Time(),5) + '</td> '
		cLin += '</tr> '
		cLin += '    <tr> '
		cLin += '      <td style="text-align: right;">Nota '
		cLin += 'Fiscal No.:</td> '
		cLin += '      <td style="width: 605px;"> ' + SF2->F2_DOC + '/' + SF2->F2_SERIE + '</td> '
		cLin += '      <td '
		cLin += ' style="text-align: right; width: 146px;">Pedido de '
		cLin += 'Venda:</td> '
		cLin += '      <td>' + SC5->C5_NUM + '</td> '
		cLin += '    </tr> '
		cLin += '    <tr> '
		cLin += '      <td style="text-align: right;">Cliente:</td> '
		cLin += '      <td style="width: 146px;" '
		cLin += ' colspan="3" rowspan="1">' + SA1->A1_NOME + '</td> '
		cLin += '    </tr> '
		cLin += '    <tr> '
		cLin += '      <td style="text-align: right;">Transportadora:</td> '
		cLin += '      <td style="width: 146px;" '
		cLin += ' colspan="3" rowspan="1">' + SA4->A4_NOME + '</td> '
		cLin += '    </tr> '
		cLin += '    <tr> '
		cLin += '      <td style="text-align: right;">Qtde '
		cLin += 'Volumes:</td> '
		cLin += '      <td style="width: 605px;">' + Str(SF2->F2_VOLUME1) + '</td> '
		cLin += '      <td '
		cLin += ' style="text-align: right; width: 146px;">Peso Bruto:</td> '
		cLin += '      <td>' + TransForm(SC5->C5_PBRUTO,"@E 999,999.9999") +' </td> '
		cLin += '    </tr> '
		cLin += '    <tr> '
		cLin += '      <td style="text-align: right;"></td> '
		cLin += '      <td style="width: 146px;" '
		cLin += ' colspan="3" rowspan="1"></td> '
		cLin += '     </tr> '
		cLin += '     <tr align="center"> '
		cLin += '       <td '
		cLin += '  style="background-color: rgb(153, 153, 153); width: 146px;" '
		cLin += '  colspan="4" rowspan="1">PRODUTOS</td> '
		cLin += '     </tr> '
		cLin += '     <tr> '
		cLin += '       <td '
		cLin += '  style="text-align: left; background-color: rgb(255, 204, 153);">C&oacute;digo</td> '
		cLin += '       <td '
		cLin += '  style="background-color: rgb(255, 204, 153); width: 605px;">Descri&ccedil;&atilde;o</td> '
		cLin += '       <td '
		cLin += '  style="text-align: center; background-color: rgb(255, 204, 153); width: 146px;">Quantidade</td> '
		cLin += '       <td '
		cLin += '  style="background-color: rgb(255, 204, 153);">Endere&ccedil;o</td> '
		cLin += '     </tr> '
	
		cDoc	:= SF2->F2_DOC
		cSer	:= SF2->F2_SERIE
	Endif
	
	If aProds[nNotas,1] == cDoc .And. aProds[nNotas,2] == cSer
		cLin += '      <tr>
		cLin += '           <td style="text-align: center;">' + aProds[nNotas,6] + '</td>'
		cLin += '           <td style="width: 605px;">' + aProds[nNotas,7] + '</td>'
		cLin += '           <td
		cLin += '      style="text-align: center; width: 146px;">' + TransForm(aProds[nNotas,8],"@E 999,999.99") + '</td>'
		cLin += '           <td style="text-align: center;">' + aProds[nNotas,9] + '</td>'
		cLin += '         </tr>'
	Endif
    nNotas++
Enddo
cLin += ' <br> '
cLin += ' </body> '
cLin += ' </html> '

FWrite(nHdl,cLin,Len(cLin)) 
FClose(nHdl)       
//cCom := "Explorer "+cDirHTML+cArqOrc
//WinExec(cCom)                                                                                 

Return (cArqOrc)