#include "RwMake.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSF1140I   บAutor  ณJean Cavalcante     บ Data ณ  21/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de Entrada especifico para envio de E-mail de         บฑฑ
ฑฑบ          ณnotificacao de recebimento de material (Pre-Nota).          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Utilizacao especificado do grupo Nytron.                   บฑฑ
ฑฑบ			 ณ www.actualtrend.com.br									  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function SF1140I()

Local c_para 		:= Alltrim(GETMV("MV_XPRENF"))
Local c_para1     := Alltrim(GETMV("MV_XPRENCQ"))
Local cMensagem  	:= ''
Local cMail_usu  	:=  Pega_email(__CUSERID)
Private c_msgerro := ''
Private a_Dados 	:= {}
Private c_Table   := " "
 
//excluido a linha abaixo [Mauro Nagata, Actual Trend, 09/03/2011]
//c_para := c_para + alltrim(cMail_usu)

_lEnvCq	:= .F.  // Produtos nใo sao inspecionados no CQ Inspecao de Entrada

//MsgAlert("Entrou email")


DbSelectarea("SD1")
DbSetOrder(1)
DBSeek(xfilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)


While !Eof()	.and. SF1->F1_FILIAL == SD1->D1_FILIAL .and. SF1->F1_DOC == SD1->D1_DOC;
	.and. SF1->F1_SERIE == SD1->D1_SERIE .and. SF1->F1_FORNECE == SD1->D1_FORNECE;
	.and. SF1->F1_LOJA == SD1->D1_LOJA
	            
	If GetAdvFval("SBZ","BZ_TIPOCQ",xfilial("SBZ")+SD1->D1_COD,1,"M") =  "Q"
	   _lEnvCq	:= .T.  //  Produto e inspecionado por CQ na inspecaoo de entrada
	EndIf
	
	c_Table += '<td width="050"><font size="2" face="Arial">'+SD1->D1_ITEM+'</font></td>'
	c_Table += '<td width="222"><font size="2" face="Arial">'+SD1->D1_COD+' - '+substr(GetAdvFval("SB1","B1_DESC",xfilial("SB1")+SD1->D1_COD,1,"N/A"),1,22)+'</font></td>'
	c_Table += '<td width="113"><font size="2" face="Arial">'+substr(GetAdvFval("SB1","B1_TIPO",xfilial("SB1")+SD1->D1_COD,1,"N/A"),1,4)+'</font></td>'
	c_Table += '<td width="099"><font size="2" face="Arial">'+TRANSFORM( SD1->D1_QUANT,"@E 9,999,999.99")+'</font></td>'
	c_Table += '<td width="032"><font size="2" face="Arial">'+SD1->D1_UM+'</font></td>'
	c_Table += '<td width="222"><font size="2" face="Arial">'+SD1->D1_XFORNE+' / '+SD1->D1_XLOJA+' - '+substr(GetAdvFval("SA2","A2_NOME",xfilial("SA2")+;
					SD1->D1_XFORNE+SD1->D1_XLOJA,1,"N/A"),1,30)+'</font></td>' // Adicionado por Ricardo Batagella - 08/05/2012
	c_Table += '</tr>'
	c_Table += '</tr>'
	
	
	DbSelectArea("SD1")
	DbSkip()
end

If	_lEnvCq
	c_para := c_para+c_para1
//	MsgAlert("c_para: "+c_para)
EndIf


cmensagem := EnvMail("\HTML\SD1140I.htm", "C:\SD1140I.HTML", c_para)

Return(.T.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEnvMail   บAutor  ณAlexandre Martins   บ Data ณ  04/18/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFaz o envio do email para o usuario.                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EnvMail(c_FileOrig, c_FileDest, c_para)

Local l_Continua	:= .T.
Private c_texto 	:= ''
Private c_msgerro	:= ''
fArq(c_FileOrig, c_FileDest)
If !U_FGEN010(c_para,"Aviso de Recebimento de Pr้-Nota Numero: "+SF1->F1_DOC+" S้rie: "+SF1->F1_SERIE+" ",c_texto,,.t.)
	Return c_msgerro
EndIf

Return ""

Static Function fArq(c_FileOrig, c_FileDest)

Local l_Ret 	:= .T.
Local c_Buffer	:= ""
Local n_Posicao	:= 0
Local n_QtdReg	:= 0
Local n_RegAtu	:= 0

If !File(c_FileOrig)
	l_Ret := .F.
	MsgStop("Arquivo [ "+c_FileOrig+" ] nใo localizado.", "Nใo localizou")
Else
	
	Ft_fuse( c_FileOrig ) 		// Abre o arquivo
	Ft_FGoTop()
	n_QtdReg := Ft_fLastRec()
	nHandle	:= MSFCREATE( c_FileDest )
	
	///////////////////////////////////
	// Carregar o array com os itens //
	///////////////////////////////////
	While !ft_fEof() .And. l_Ret
		
		c_Buffer := ft_fReadln()
		
		FWrite(nHandle, &("'" + c_Buffer + "'"))
		c_texto += &("'" + c_Buffer + "'")
		ft_fSkip()
		
	Enddo
	FClose(nHandle)
	
Endif

Return l_Ret

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณpega_emailบAutor  ณJean Cavalcante     บ Data ณ  08/06/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna dados do cadastro dos usuarios (EMAIL).             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC Function Pega_Email(c_User) //__CUSERID

c_user := Iif(c_User=Nil, __CUSERID, c_user)

_aUser := {}
psworder(1)
pswseek(c_user)
_aUser := PSWRET()

_cEMail		:= Substr(_aUser[1,14],1,50)

Return(_cEmail)
