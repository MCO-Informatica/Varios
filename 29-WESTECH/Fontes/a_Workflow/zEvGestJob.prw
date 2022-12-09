#include "rwmake.ch"
#include "topconn.ch"
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'
#include "ap5mail.ch"
#INCLUDE "TOTVS.CH"


//����������������������������������������������������������������������������// 
//                        Low Intensity colors 
//����������������������������������������������������������������������������// 

#define CLR_BLACK             0               // RGB(   0,   0,   0 ) 
#define CLR_BLUE        8388608               // RGB(   0,   0, 128 ) 
#define CLR_GREEN        32768               // RGB(   0, 128,   0 ) 
#define CLR_CYAN        8421376               // RGB(   0, 128, 128 ) 
#define CLR_RED             128               // RGB( 128,   0,   0 ) 
#define CLR_MAGENTA     8388736               // RGB( 128,   0, 128 ) 
#define CLR_BROWN        32896               // RGB( 128, 128,   0 ) 
#define CLR_HGRAY      12632256               // RGB( 192, 192, 192 ) 
#define CLR_LIGHTGRAY CLR_HGRAY 

//����������������������������������������������������������������������������// 
//                      High Intensity Colors 
//����������������������������������������������������������������������������// 

#define CLR_GRAY        8421504               // RGB( 128, 128, 128 ) 
#define CLR_HBLUE      16711680               // RGB(   0,   0, 255 ) 
#define CLR_HGREEN        65280               // RGB(   0, 255,   0 ) 
#define CLR_HCYAN      16776960               // RGB(   0, 255, 255 ) 
#define CLR_HRED            255               // RGB( 255,   0,   0 ) 
#define CLR_HMAGENTA   16711935               // RGB( 255,   0, 255 ) 
#define CLR_YELLOW        65535               // RGB( 255, 255,   0 ) 
#define CLR_WHITE      16777215               // RGB( 255, 255, 255 ) 
/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Gera arquivo de Gestao de Contratos                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico 		                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function zEvGestJob()

	zProcFunc()
	zEvMail()

RETURN

Static Function SchedDef()

    Local aOrd      := {}
    Local aParam    := {}

    aParam := { "P" ,;
    "PARAMDEF"      ,;
    ""              ,;
    aOrd            ,;
    } 
    
Return aParam

//Envia E-mail
Static Function zEvMail(cTo, cCc, cAssunto, cMsg, aAnexo)
    local _cQuery := ""
	Local oServer
	Local oMessage
	Local cUsr := GetMv("MV_RELACNT") //Conta de autenticao do email
	Local cPsw := GetMv("MV_RELPSW") //Senha para autenticao no servidor de e-mail
	Local cSrv := GetMv("MV_RELSERV") //Servidor SMTP
	Local lAut := GetMv("MV_RELAUTH") //Servidor SMTP necessite de AUTENTICAΗAO para envio de e-mails
	Local nPrt := 587
	local nI
	local cForCTD	:= "QUERYCTD->CTD_DTEXSF >= Date() .AND. QUERYCTD->CTD_XIDPM = cIdCoord .AND. !QUERYCTD->CTD_ITEM $ ('ADMINISTRACAO/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/OPERACOES')"

	Local cIDUser 	:= ""
	Local cEmail 	:= ""
	Local cIDUserCC := ""
	Local cEmailCC 	:= ""
    local cFiltro1A 	:= ""

    Local aMatriz2 		:= {}
	Local aMatriz		:= {}
	Local nI 			:= 0
	Local nI2 			:= 0
	Local nI3 			:= 0
	Local nI5 			:= 0

	Local nPERVD := 0
	Local nPEREMP := 0
	Local cDesUSA := ""

	Local cProjeto 	:= ""
	Local cLocal	:= ""

	Private n1 := 0

	//ChkFile("CTD",.F.,"QUERYCTD")
	//IndRegua("QUERYCTD",CriaTrab(NIL,.F.),"CTD_FILIAL+CTD_XIDPM+CTD_ITEM",,cForCTD,"Selecionando Registros...")
	//ProcRegua(QUERYCTD->(reccount()))

	//Local aAnexo := StrTokArr(cAnexo, ";")

	//Cria a conexγo com o server STMP ( Envio de e-mail )
	oServer := TMailManager():New()
	//oServer:SetUseTLS( .T. )
	//O servidor esta com a porta
		
	If ":" $ cSrv
		nPrt := Val(Substr(cSrv, At(":",cSrv)+1))
		cSrv := Substr(cSrv, 1 , At(":",cSrv)-1)
	EndIf

	oServer:Init( "", cSrv, cUsr, cPsw, , nPrt )

	//seta um tempo de time out com servidor de 1min
	If oServer:SetSmtpTimeOut( 60 ) != 0
		 MsgAlert( "Falha ao setar o time out", "Email nao enviado!" )
		Return .F.
	EndIf

	//realiza a conexγo SMTP
	If oServer:SmtpConnect() != 0
		 MsgAlert( "Falha ao conectar", "Email nao enviado!" )
		Return .F.
	EndIf

	If lAut
		If oServer:SmtpAuth( cUsr, cPsw ) != 0
			 MsgAlert( "Falha ao autenticar", "Email nao enviado!" )
			Return .F.
		EndIf
	EndIf
	//Apos a conexγo, cria o objeto da mensagem
	oMessage := TMailMessage():New()

	//Limpa o objeto
	oMessage:Clear()

	dbSelectArea("ZZP")
	ZZP->(dbGoTop())

    // matriz com IDs de Coordenadores
    nI := 1
    while ZZP->(!eof()) //for nI=1 to Len( "_cQuery" )
        cXIDPM := alltrim(ZZP->ZZP_XIDPM)
        AAdd( aMatriz, cXIDPM ,nI ) // Posicione("CTD",1,xFilial("CTD") +  ALLTRIM(aCols[nI][3]),"CTD_XIDPM")
        if ascan(aMatriz2,aMatriz[nI]) = 0 
            aadd(aMatriz2,aMatriz[nI]) 
        endif
    //cNum := ALLTRIM(aCols[nI][1])	
        nI++
        ZZP->(dbskip())

    enddo//next   

    /*for nI=1 to len(aMatriz2) 
		alert(aMatriz2[nI]+" PM")
		cMensagem := aMatriz[nI] + chr(13) + chr(10)
	next  */

    for nI=1 to len(aMatriz2) 

		cEmail := UsrRetMail(aMatriz2[nI])
        cIdCoord := Alltrim(aMatriz2[nI])

		ChkFile("CTD",.F.,"QUERYCTD")
		IndRegua("QUERYCTD",CriaTrab(NIL,.F.),"CTD_FILIAL+CTD_XIDPM+CTD_ITEM",,cForCTD,"Selecionando Registros...")
		ProcRegua(QUERYCTD->(reccount()))

		cMsg:=' <!DOCTYPE html>
		cMsg+='	<html>
		cMsg+='	<head>
		cMsg+='		<meta charset="utf-8">
		cMsg+='		<title> Westech - Pedidos em Atraso</title>
		cMsg+='		<style type="text/css">
		cMsg+='			*{
		cMsg+='				margin: 0;
		cMsg+='				padding: 0;
		cMsg+='				background: #fff;
		cMsg+='			}

		cMsg+='			body{
		cMsg+='				font-family: "Trebuche MS", Helvetica, sans-serif;
		cMsg+='				background: #f2f2f2;
		cMsg+='				min-width: 750px;
		cMsg+='			}

		cMsg+='			#cabecalho{
		cMsg+='				background: rgb(1, 86, 151);
		cMsg+='				height: 130px;
		cMsg+='			}

		cMsg+='			#topo{
		cMsg+='				width: 90%;
		cMsg+='				margin: 0 auto;
		cMsg+='				background: rgb(1, 86, 151);
		cMsg+='			}

		cMsg+='			#conteudo{
		cMsg+='				margin: 0 auto;
		cMsg+='				margin-top:30px;
		cMsg+='				width: 80%;
		cMsg+='			}

		cMsg+='			#rodape{
		cMsg+='				padding: 20px;
		cMsg+='				text-align: center;
		cMsg+='				background: rgb(1, 86, 151);
		cMsg+='				min-width: 750px;
		cMsg+='				margin-top: 20px;
		cMsg+='			}

		cMsg+='			#rodape h5{
		cMsg+='				background: rgb(1, 86, 151);
		cMsg+='				color: #fff;
		cMsg+='			}

		cMsg+='			.logo {
		cMsg+='				font-family: "Arial Black";
		cMsg+='				font-weight: bold;
		cMsg+='				font-size: 1.5em;
		cMsg+='				background: rgb(1, 86, 151);
		cMsg+='				color: #fff;
		cMsg+='				top: 35px;
		cMsg+='				padding: 0px 0 0 0;
		cMsg+='			}

		cMsg+='			#titulo{
		cMsg+='				font-size: 0.8em;
		cMsg+='				padding: 0px;
		cMsg+='				text-align: center;
		cMsg+='				background: #F0FFFF /* rgb(1, 86, 151); */
		cMsg+='				color: #fff;
		cMsg+='				padding-top: 10px;
		cMsg+='			}

		cMsg+='			span{
		cMsg+='				font-size: 0.4em;
		cMsg+='				background: rgb(1, 86, 151);
		cMsg+='				color: #fff;
		cMsg+='				padding-top: 3px;
		cMsg+='			}

		cMsg+='			.titulo-topo{
		cMsg+='				background: #F0FFFF /* rgb(1, 86, 151); */
		cMsg+='				text-shadow: -5.54px 5.5px 5px rgba(0,0,0,0.5);
		cMsg+='				text-transform: uppercase;
		cMsg+='			}
				
		cMsg+='			table{
		cMsg+='				font-size: 0.8em;
		cMsg+='				border-collapse:collapse;
		cMsg+='				width: 100%;
		cMsg+='			}


		cMsg+='			th, td{
		cMsg+='				border: 1px solid rgb(1, 86, 151);
		cMsg+='				padding: 7px;
		cMsg+='				border: 1px solid rgb(1, 86, 151);
		cMsg+='			}

		cMsg+='			th {
		cMsg+='				text-transform: uppercase;
		cMsg+='				border-top: 1px solid #999 ;
		cMsg+='				border-bottom: 1px solid #111;
		cMsg+='				text-align: left;
		cMsg+='				font-size: 80%;
		cMsg+='				letter-spacing: 0.1em;
		cMsg+='				background: #F0FFFF;
		cMsg+='			}

		cMsg+='			tr:hover{
		cMsg+='				color: blue;
		cMsg+='				background: rgb(1, 86, 151);
		cMsg+='			}

		cMsg+='			.numero{
		cMsg+='				text-align: cemter;
		cMsg+='			}

		cMsg+='		</style>
		cMsg+='	</head>
		cMsg+='	<body>
		cMsg+='		<div id="container"> 
		cMsg+='			<div id="cabecalho">

		cMsg+='				<div id="topo">
		cMsg+='					<h1 class="logo"> 
		cMsg+='						WesTech <span> Equipamentos Industriais Ltds</span>
		cMsg+='					</h1>
		cMsg+='					<h1 class="logo" style="text-align: center;"> 
		cMsg+='						Resumo Contratos - Custos / Margens
		cMsg+='					</h1>
		cMsg+='				</div>
					

		cMsg+='				<div style="clear: both;"></div>

	
		while QUERYCTD->(!eof())

		_cItemConta := QUERYCTD->CTD_ITEM
		if empty(alltrim(POSICIONE("SZ9",1,XFILIAL("SZ9")+ POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_NPROP"),"Z9_PROJETO")))
			cProjeto := ""
		else
			cProjeto := " - " + POSICIONE("SZ9",1,XFILIAL("SZ9")+ POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_NPROP"),"Z9_PROJETO")   
		endif

		if empty(alltrim(POSICIONE("SZ9",1,XFILIAL("SZ9")+ POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_NPROP"),"Z9_LOCAL")))
			cLocal := ""
		else
			cLocal	 := " - " + POSICIONE("SZ9",1,XFILIAL("SZ9")+ POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_NPROP"),"Z9_LOCAL")
		endif
					
		cMsg+='				<div id="conteudo">
		cMsg+='					<table>
		cMsg+='						<tr>
		cMsg+='							<th colspan="13">
		cMsg+='								<div id="titulo">
		cMsg+='									<h1 class="titulo-topo">'  + _cItemConta + '<strong style="font-size: 0.5em">' + cProjeto + cLocal + '</strong> </h1> 
		cMsg+='								</div>
		cMsg+='							</th>
		cMsg+='						</tr>
		cMsg+='						<tr>
		cMsg+='							<td colspan="4"> <b> Cliente: </b>' + POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XCLIEN") + " - " + POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XNREDU") + '</th>
		cMsg+='							<td colspan="4"> <b> Coordenador: </b>'  + POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XIDPM") +  " - "  + POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XNOMPM") + '</th>	
		cMsg+='							<td colspan="3"> <b> Emiss�o Relat�rio: </b>' + dtoc(DATE()) + '</th>
		cMsg+='						</tr>

		cMsg+='						<tr>
		cMsg+='							<td colspan="7"> <b> Opera��o Unit�ria: </b>' + POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XEQUIP") + '</th>
		cMsg+='							<td colspan="2"> <b> Data abertura: </b> ' + DTOC(POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_DTEXIS")) + '</th>
		cMsg+='							<td colspan="2"> <b> Data final: </b> ' + DTOC(POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_DTEXSF")) + '</th>
		cMsg+='						</tr>

		cMsg+='						<tr>
		cMsg+='							<th colspan="1.5" style="text-align: center;">Venda c/ Tributos</th>
		cMsg+='							<th colspan="2" style="text-align: center;">s/ Tributos</th>
		cMsg+='							<th colspan="2" style="text-align: center;">s/ Tributos (s/ Frete)</th>
		cMsg+='							<th colspan="2" style="text-align: center;">Venda c/ Tributos (Rev.)</th>
		cMsg+='							<th colspan="2" style="text-align: center;">s/ Tributos (Rev.)</th>
		cMsg+='							<th colspan="2" style="text-align: center;">s/ Tributos (s/ Frete)</th>
		cMsg+='						</tr>

		cMsg+='						<tr>
		cMsg+='							<td colspan="1.5" style="text-align: center;">' + TRANSFORM(POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XVDCI"), '@E 99,999,999.99') + '</th>
		cMsg+='							<td colspan="2" style="text-align: center;">' + TRANSFORM(POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XVDSI"), '@E 99,999,999.99') + '</th>
		cMsg+='							<td colspan="2" style="text-align: center;">' + TRANSFORM(POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XSISFV"), '@E 99,999,999.99') + '</th>
		cMsg+='							<td colspan="2" style="text-align: center;">' + TRANSFORM(POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XVDCIR"), '@E 99,999,999.99') + '</th>
		cMsg+='							<td colspan="2" style="text-align: center;">' + TRANSFORM(POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XVDSIR"), '@E 99,999,999.99') + '</th>
		cMsg+='							<td colspan="2" style="text-align: center;">' + TRANSFORM(POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XSISFR"), '@E 99,999,999.99') + '</th>
		cMsg+='						</tr>
							
		cMsg+='						<tr>
		cMsg+='							<th rowspan="2" style="text-align: center;">Descri��o</th>
		cMsg+='							<th colspan="2" style="text-align: center;">Vendido</th>
		cMsg+='							<th colspan="2" style="text-align: center;">Planejado</th>
		cMsg+='							<th colspan="2" style="text-align: center;">Realizado</th>
		cMsg+='							<th colspan="2" style="text-align: center;">Custo Contabil</th>
		cMsg+='							<th colspan="2" style="text-align: center;">Estoque</th>
		cMsg+='						</tr>

		cMsg+='					<tr>
		cMsg+='						<th style="text-align: center;">Valor</th>
		cMsg+='						<th style="text-align: center;">%</th>
		cMsg+='						<th style="text-align: center;">Valor</th>
		cMsg+='						<th style="text-align: center;">%</th>
		cMsg+='						<th style="text-align: center;">Valor</th>
		cMsg+='						<th style="text-align: center;">%</th>
		cMsg+='						<th style="text-align: center;">Valor</th>
		cMsg+='						<th style="text-align: center;">%</th>
		cMsg+='						<th style="text-align: center;">Valor</th>
		cMsg+='						<th style="text-align: center;">%</th>
		cMsg+='					</tr>

		
		ZZP->(dbclearfil())
		ZZP->(dbGoTop())
		// Monta filtro no TRB1 para mostrar apenas os movimentos grupo e dia/periodo selecionado
		cFiltro1A := " ZZP->ZZP_XIDPM  = cIdCoord .AND. ZZP->ZZP_ITEMCT = _cItemConta " 
		ZZP->(dbsetfilter({|| &(cFiltro1A)} , cFiltro1A))
		ZZP->(dbGoTop())

		while ZZP->(!eof())

			nPERVD := ZZP->ZZP_PERVD
			nPEREMP := ZZP->ZZP_PEREMP
			cDesUSA := ZZP->ZZP_DESUSA

			if nPEREMP < nPERVD .AND. cDesUSA = "MARGEM CONTRIB."
				cMsg+='					<tr>
				cMsg+='						<td><b>' + ZZP->ZZP_DESUSA + '</b></td>
				cMsg+='						<td style="text-align: right;">' + TRANSFORM(ZZP->ZZP_VLRVD, '@E 99,999,999.99') + '</td>
				cMsg+='						<td style="text-align: center; background: #8B0000; color:  #FFFFFF; font-weight: bold ;">' + TRANSFORM(ZZP->ZZP_PERVD, '@E 99,999,999.99') + '</td>
				cMsg+='						<td style="text-align: right;">' + TRANSFORM(ZZP->ZZP_VLRPLN, '@E 99,999,999.99') + '</td>
				cMsg+='						<td style="text-align: center;">' + TRANSFORM(ZZP->ZZP_PERPLN, '@E 99,999,999.99') + '</td>
				cMsg+='						<td style="text-align: right;">' + TRANSFORM(ZZP->ZZP_VLREMP, '@E 99,999,999.99') + '</td>
				cMsg+='						<td style="text-align: center;background: #8B0000; color:  #FFFFFF; font-weight: bold ;">' + TRANSFORM(ZZP->ZZP_PEREMP, '@E 99,999,999.99') + '</td>
				cMsg+='						<td style="text-align: right;">' + TRANSFORM(ZZP->ZZP_VLRCTB, '@E 99,999,999.99') + '</td>
				cMsg+='						<td style="text-align: center;">' + TRANSFORM(ZZP->ZZP_PERCTB, '@E 99,999,999.99') + '</td>
				cMsg+='						<td style="text-align: right;">' + TRANSFORM(ZZP->ZZP_VLRCTE, '@E 99,999,999.99') + '</td>
				cMsg+='						<td style="text-align: center;">' + TRANSFORM(ZZP->ZZP_PERCTE, '@E 99,999,999.99') + '</td>
				cMsg+='					</tr>
			ELSE
				cMsg+='					<tr>
				cMsg+='						<td><b>' + ZZP->ZZP_DESUSA + '</b></td>
				cMsg+='						<td style="text-align: right;">' + TRANSFORM(ZZP->ZZP_VLRVD, '@E 99,999,999.99') + '</td>
				cMsg+='						<td style="text-align: center;">' + TRANSFORM(ZZP->ZZP_PERVD, '@E 99,999,999.99') + '</td>
				cMsg+='						<td style="text-align: right;">' + TRANSFORM(ZZP->ZZP_VLRPLN, '@E 99,999,999.99') + '</td>
				cMsg+='						<td style="text-align: center;">' + TRANSFORM(ZZP->ZZP_PERPLN, '@E 99,999,999.99') + '</td>
				cMsg+='						<td style="text-align: right;">' + TRANSFORM(ZZP->ZZP_VLREMP, '@E 99,999,999.99') + '</td>
				cMsg+='						<td style="text-align: center;">' + TRANSFORM(ZZP->ZZP_PEREMP, '@E 99,999,999.99') + '</td>
				cMsg+='						<td style="text-align: right;">' + TRANSFORM(ZZP->ZZP_VLRCTB, '@E 99,999,999.99') + '</td>
				cMsg+='						<td style="text-align: center;">' + TRANSFORM(ZZP->ZZP_PERCTB, '@E 99,999,999.99') + '</td>
				cMsg+='						<td style="text-align: right;">' + TRANSFORM(ZZP->ZZP_VLRCTE, '@E 99,999,999.99') + '</td>
				cMsg+='						<td style="text-align: center;">' + TRANSFORM(ZZP->ZZP_PERCTE, '@E 99,999,999.99') + '</td>
				cMsg+='					</tr>
			ENDIF
			ZZP->(dbskip())
		ENDDO					
		cMsg+='				</table>
		cMsg+='				<table>
		cMsg+='					<tr>
		cMsg+='						<th colspan="13"></th>
		cMsg+='					</tr>
		cMsg+='				</table>
						
		cMsg+='			</div>

		QUERYCTD->(dbskip())

		ENDDO
		QUERYCTD->(dbclosearea())

		cMsg+='			<div id="rodape">
		cMsg+='				<h5> Westech Equipamentos Industriais Ldta - Fonte de dados Protheus (WestechP12)</h3>
		cMsg+='			</div>
					

		cMsg+='		</div>
			
		cMsg+='	</div>
		cMsg+='</body>
		cMsg+='</html>


        //Popula com os dados de envio
        oMessage:cFrom              := cUsr
        oMessage:cTo                :=  cEmail
        oMessage:cCc                :=  "rvalerio@westech.com.br" // cEmailCC
        //oMessage:cBcc               := "rvalerio@westech.com.br"
        oMessage:cSubject           := "Resumo Contratos - Custos / Margens" //cAssunto
        oMessage:cBody              := cMsg

        //Adiciona um attach
        If !Empty(aAnexo) //.AND. !Empty(cAnexo)
            For nI:= 1 To Len(aAnexo)
                If oMessage:AttachFile(aAnexo[nI]) < 0
                    //MsgAlert( "Erro ao anexar o arquivo", "Email nao enviado!")
                    Return .F.
                    //Else
                    //adiciona uma tag informando que e um attach e o nome do arq
                    //oMessage:AddAtthTag( 'Content-Disposition: attachment; filename=arquivo.txt')
                EndIf
            Next nI
        EndIf
        //Envia o e-mail
        If oMessage:Send( oServer ) != 0
            //MsgAlert( "Erro ao enviar o e-mail", "Email nao enviado!")
            Return .F.
        else
            //MsgInfo("E-mail enviado com sucesso.", "Westech")
        EndIf

        //MsgAlert(cEmail)
	next
    
	//Desconecta do servidor
	If oServer:SmtpDisconnect() != 0
		 //MsgAlert( "Erro ao disconectar do servidor SMTP", "Email nao enviado!")
		Return .F.
	EndIf

	
	

Return .T.

static function zProcFunc()

local cQCZZM := ""
local cQCZZN := ""
local cQCZZN2 := ""
local cForZZN	:= "ALLTRIM(QUERYZZN->ZZN_ITEMCT) == _cItemConta "
local cForCTD	:= "QUERYCTD->CTD_DTEXSF >= Date() .AND. !QUERYCTD->CTD_ITEM $ ('ADMINISTRACAO/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/OPERACOES')"

local cContador := 1

private cPerg 	:= 	"GCIN01"
private _cArq	:= 	"GCIN01.XLS"
private CR 		:= chr(13)+chr(10)
private _cFilCTD:= xFilial("CTD")

private _aCpos	:= {} // Campos de datas criados no TRB2
private _nCampos:= 0 // numero de campos de data - len(_aCpos)
private _nRecSaldo 	:= 0 // Recno da linha de saldo
//private _cItemConta
private _cCodCli
private _cNomCli
private _cItemConta := ""
private _nPComiss 	:= 0
private _nXSISFV 	:= 0

private _xCTCT 		:= ""
private _cFilial 	:= ""

private _cNProp
private _cCodCoord
private _cNomCoord

private cArqTrb1 := CriaTrab(NIL,.F.)
private cArqTrb2 := CriaTrab(NIL,.F.)
private cArqTrb4 := CriaTrab(NIL,.F.)

private oGet6
private nGet6	:= SZC->ZC_UNITR

private oGet4
private nGet4	:= SZC->ZC_QUANTR

private oGet7
private nGet7	:= SZC->ZC_TOTALR

private oTree
private aNodes
Private _aGrpSint:= {}

private nTotRegZZM := 0
private nTotRegZZN := 0

//ValidPerg()

//FormBatch( cCadastro, aSays, aButtons )

// Se confirmado o processamento
//if nOpcA == 1

dbSelectArea("ZZP")
ZZP->( dbGoTop() )
ZZP->(dbSetOrder(1) ) 
While ZZP->(!EoF()) 
	ZZP->(RecLock("ZZP",.F.))
	ZZP->(DbDelete())
	ZZP->(MsUnLock())
	ZZP->(DbSkip(1))
EndDo

cDELZZP := TCSqlExec("DELETE from ZZP010 WHERE D_E_L_E_T_ = '*' ")



    ChkFile("CTD",.F.,"QUERYCTD")
	IndRegua("QUERYCTD",CriaTrab(NIL,.F.),"CTD_FILIAL+CTD_ITEM",,cForCTD,"Selecionando Registros...")
	ProcRegua(QUERYCTD->(reccount()))

	

    while QUERYCTD->(!eof())//cContador <= 2 

        _cItemConta := QUERYCTD->CTD_ITEM
        _nPComiss 	:= QUERYCTD->CTD_XPCOM
        _nXSISFV 	:= QUERYCTD->CTD_XSISFV

        _xCTCT 		:= QUERYCTD->CTD_XCTCT
        _cFilial 	:= ALLTRIM(QUERYCTD->CTD_FILIAL)

        // Faz consistencias iniciais para permitir a execucao da rotina
        if !VldParam() .or. !AbreArq()
            return
        endif

        cQCZZN2 := " SELECT DISTINCT ZZN_PL FROM ZZN010 WHERE ZZN_ITEMCT = '" + _cItemConta + "' AND D_E_L_E_T_ <> '*' "
        TCQuery cQCZZN2 New Alias "TZZNG2"
        TZZNG2->(DbGoTop())
        cPlan := TZZNG2->ZZN_PL

        //MsgInfo (cPlan)

        //**********************************************************//
        //cQCZZM := " SELECT * FROM ZZM010 WHERE ZZM_ITEMCT = '" + _cItemConta + "' AND D_E_L_E_T_ <> '*' "

            if cPlan = "P1"
                cQCZZM := " SELECT * FROM ZZM010 WHERE ZZM_ITEMCT = '" + _cItemConta + "' AND D_E_L_E_T_ <> '*' "
            elseif cPlan = "P2"
                cQCZZM := " SELECT * FROM ZZM010 WHERE ZZM_ITEMC2 = '" + _cItemConta + "' AND D_E_L_E_T_ <> '*' "
            elseif cPlan = "P3"
                cQCZZM := " SELECT * FROM ZZM010 WHERE ZZM_ITEMC3 = '" + _cItemConta + "' AND D_E_L_E_T_ <> '*' "
            elseif cPlan = "P4"
                cQCZZM := " SELECT * FROM ZZM010 WHERE ZZM_ITEMC4 = '" + _cItemConta + "' AND D_E_L_E_T_ <> '*' "
            elseif cPlan = "P5" 
                cQCZZM := " SELECT * FROM ZZM010 WHERE ZZM_ITEMC5 = '" + _cItemConta + "' AND D_E_L_E_T_ <> '*' "
            elseif cPlan = "P6"
                cQCZZM := " SELECT * FROM ZZM010 WHERE ZZM_ITEMC6 = '" + _cItemConta + "' AND D_E_L_E_T_ <> '*' "
            elseif cPlan = "P7"
                cQCZZM := " SELECT * FROM ZZM010 WHERE ZZM_ITEMC7 = '" + _cItemConta + "' AND D_E_L_E_T_ <> '*' "
            elseif cPlan = "P8"
                cQCZZM := " SELECT * FROM ZZM010 WHERE ZZM_ITEMC8 = '" + _cItemConta + "' AND D_E_L_E_T_ <> '*' "
            eLSE
                cQCZZM := " SELECT * FROM ZZM010 WHERE ZZM_ITEMCT = '" + _cItemConta + "' AND D_E_L_E_T_ <> '*' "
            endif

        TCQuery cQCZZM New Alias "TZZMG"
        Count To nTotRegZZM
        TZZMG->(DbGoTop())

        IF nTotRegZZM > 0
            MSAguarde({||VendSLC()},"Processando Vendido ")
            //msginfo( "VendSLC")
        else
            MSAguarde({||VEND02()},"Processando Vendido ")
            //msginfo( "Venda Antigo")
        ENDIF
        TZZMG->(dbclosearea())
        
        //**********************************************************//
        cQCZZN := " SELECT * FROM ZZN010 WHERE ZZN_ITEMCT = '" + _cItemConta + "' AND D_E_L_E_T_ <> '*'"
        TCQuery cQCZZN New Alias "TZZNG"
        Count To nTotRegZZN
        TZZNG->(DbGoTop())

        IF nTotRegZZN > 0
            MSAguarde({||PlanSLC()},"Processando Planejamento de Contrato...... ")
        else
            if alltrim(substr(_cItemConta,1,2)) == "PR" .OR. alltrim(substr(_cItemConta,1,2)) == "AT" .OR. alltrim(substr(_cItemConta,1,2)) == "CM" .OR. ;
                        alltrim(substr(_cItemConta,1,2)) == "EN" .OR. alltrim(substr(_cItemConta,1,2)) == "GR" .OR. _xCTCT == "N3" 
                MSAguarde({||PLANEJ03()},"Processando Planejamento de Contrato...... ")
            //	MSAguarde({||VEND01()},"Processando Vendido (PR/AT/EN/GR)")
            else
                MSAguarde({||PLANEJ02()},"Processando Planejamento de Contrato... ")	
            endif
        ENDIF
        TZZNG->(dbclosearea())
        //**********************************************************//

        MSAguarde({||PFIN01REAL()},"Processando Ordem de Compra")

        MSAguarde({||D101REAL()},"Processando Documento de Entrada")

        MSAguarde({||DE01REAL()},"Processando Rateio Documento de Entrada")

        MSAguarde({||FIN01REAL()},"Processando Financeiro")

        MSAguarde({||CV401REAL()},"Processando Financeiro Rateio")
        
        MSAguarde({||HR01REAL()},"Processando Apontamento de Horas")

        MSAguarde({||CUDIV01REAL()},"Processando Custos Diversos ")

        MSAguarde({||CT401REAL()},"Processando Custo Contabil")

        MSAguarde({||CT401EST()},"Processando Estoque Contabil")
        
        MSAguarde({||CT401REC()},"Processando Receita Contabil")

		MSAguarde({||GC01SINT()},"Gerando arquivo sintetico.") // *** Funcao de gravacao do arquivo sintetico ***

		QUERYCTD->(dbskip())
		//cContador++
		
		TRB1->(dbclosearea())
		TRB4->(dbclosearea())
		TZZNG2->(dbclosearea())
		
		
    ENDDO

	QUERYCTD->(dbclosearea())
	ZZP->(dbclosearea())

	//QUERYCTD->(dbgotop())
	//MontaTela()
	//TRB1->(dbclosearea())
	//TRB11->(dbclosearea())
	//TRB2->(dbclosearea())
	//TRB4->(dbclosearea())
	//TZZNG2->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Processa Vendido slc																				              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function VendSLC()
	local _cQuery := ""
	Local _cFilZZM := xFilial("ZZM")
	local cPlan := ""
	local cFor := ""
	local cForZZN	:= "ALLTRIM(QUERYZZN->ZZN_ITEMCT) == _cItemConta"
	local cPlan		:= ""
	local cICta		:= ""
	ZZM->(dbsetorder(2))


	ChkFile("ZZN",.F.,"QUERYZZN")
	IndRegua("QUERYZZN",CriaTrab(NIL,.F.),"ZZN_FILIAL+ZZN_ITEMCT",,cForZZN,"Selecionando Registros...")
	ProcRegua(QUERYZZN->(reccount()))
	cPlan := QUERYZZN->ZZN_PL

	//msginfo( "teste 3")

	ChkFile("ZZM",.F.,"QUERY")
	//IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_ITEMCT",,cFor,"Selecionando Registros...")
	
		if cPlan = "P1"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMCT) == _cItemConta .AND. LEN(QUERY->ZZM_GRUPO) > 3 .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) $ '1/3/5/6/7' " //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMCT",,cFor,"Selecionando Registros...")
		elseif cPlan = "P2"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC2) == _cItemConta .AND. LEN(QUERY->ZZM_GRUPO) > 3 .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) $ '1/3/5/6/7'" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC2",,cFor,"Selecionando Registros...")
		elseif cPlan = "P3"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC3) == _cItemConta .AND. LEN(QUERY->ZZM_GRUPO) > 3 .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) $ '1/3/5/6/7'" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC3",,cFor,"Selecionando Registros...")
		elseif cPlan = "P4"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC4) == _cItemConta .AND. LEN(QUERY->ZZM_GRUPO) > 3 .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) $ '1/3/5/6/7'" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC4",,cFor,"Selecionando Registros...")
		elseif cPlan = "P5" 

			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC5) == _cItemConta .AND. LEN(QUERY->ZZM_GRUPO) > 3 .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) $ '1/3/5/6/7'" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC5
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC5",,cFor,"Selecionando Registros...")

		elseif cPlan = "P6"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC6) == _cItemConta .AND. LEN(QUERY->ZZM_GRUPO) > 3 .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) $ '1/3/5/6/7'" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC6
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC6",,cFor,"Selecionando Registros...")

		elseif cPlan = "P7"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC7) == _cItemConta .AND. LEN(QUERY->ZZM_GRUPO) > 3 .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) $ '1/3/5/6/7'" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC7
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC7",,cFor,"Selecionando Registros...")

		elseif cPlan = "P8"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC8) == _cItemConta .AND. LEN(QUERY->ZZM_GRUPO) > 3 .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) $ '1/3/5/6/7'" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC8
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC8",,cFor,"Selecionando Registros...")
		eLSE
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMCT) == _cItemConta .AND. LEN(QUERY->ZZM_GRUPO) > 3 .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) $ '1/3/5/6/7'" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMCT
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMCT",,cFor,"Selecionando Registros...")

		endif
	ProcRegua(QUERY->(reccount()))
	QUERY->(dbgotop())

	while QUERY->(!eof())

		RecLock("TRB1",.T.)

		//IncProc("Processando registro: "+alltrim(QUERY->ZZM_GRUPO))
		//MsProcTxt("Processando registro: "+alltrim(QUERY->ZG_IDVDSUB))
		//ProcessMessage()

		if SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3) == "101"
			TRB1->IDUSA		:= "101"
			TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3) == "102"
			TRB1->IDUSA		:= "102"
			TRB1->DESCUSA	:= "TINTAS / REVESTIMENTOS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)== "103"
			TRB1->IDUSA		:= "103"
			TRB1->DESCUSA	:= "BARREIRAS E DEFLETORES"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)== "104"
			TRB1->IDUSA		:= "104"
			TRB1->DESCUSA	:= "UNIDADE(S) DE ACIONAMENTO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3) == "105"
			TRB1->IDUSA		:= "105"
			TRB1->DESCUSA	:= "PARAFUSOS E ELELEMENTOS DE FIXACAO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3) == "106"
			TRB1->IDUSA		:= "106"
			TRB1->DESCUSA	:= "CONTROLES ELETRICOS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3) == "107"
			TRB1->IDUSA		:= "107"
			TRB1->DESCUSA	:= "INSTRUMENTACAO"
		Elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3) == "108"
			TRB1->IDUSA		:= "108"
			TRB1->DESCUSA	:= "OUTRAS AQUISICOES"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3) == "109"
			TRB1->IDUSA		:= "109"
			TRB1->DESCUSA	:= "FRETE INTERNO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3) == "201"
			TRB1->IDUSA		:= "201"
			TRB1->DESCUSA	:= "SUBMITTALS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "202"
			TRB1->IDUSA		:= "202"
			TRB1->DESCUSA	:= "PROJETO / LAYOUT / CALCULOS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "204"
			TRB1->IDUSA		:= "204"
			TRB1->DESCUSA	:= "DETALHAMENTO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "205"
			TRB1->IDUSA		:= "205"
			TRB1->DESCUSA	:= "VERIFICAO / APROVACAO"
		Elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "206"
			TRB1->IDUSA		:= "206"
			TRB1->DESCUSA	:= "ENGENHARIA DE ACIONAMENTO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "207"
			TRB1->IDUSA		:= "207"
			TRB1->DESCUSA	:= "ENGENHARIA ELETRICA"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "210"
			TRB1->IDUSA		:= "210"
			TRB1->DESCUSA	:= "GERENCIAMENTO DE PROJETOS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "211"
			TRB1->IDUSA		:= "211"
			TRB1->DESCUSA	:= "COMPRAS / EXPEDICAO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "212"
			TRB1->IDUSA		:= "212"
			TRB1->DESCUSA	:= "MONTAGEM ELETRICA"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "213"
			TRB1->IDUSA		:= "213"
			TRB1->DESCUSA	:= "OUTRA MONTAGEM / TESTE"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3) == "217"
			TRB1->IDUSA		:= "217"
			TRB1->DESCUSA	:= "INSPECAO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "218"
			TRB1->IDUSA		:= "218"
			TRB1->DESCUSA	:= "SERVICO / TESTE DE CAMPO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "220"
			TRB1->IDUSA		:= "220"
			TRB1->DESCUSA	:= "OUTRO, O&M, COPIA, EMBARQUE"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "221"
			TRB1->IDUSA		:= "221"
			TRB1->DESCUSA	:= "TESTES / MODIFICACOES ELETRICAS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "222"
			TRB1->IDUSA		:= "222"
			TRB1->DESCUSA	:= "PROGRAMACAO PLC"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "301"
			TRB1->IDUSA		:= "301"
			TRB1->DESCUSA	:= "FRETE, EMBALAGEM, AFINS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "501"
			TRB1->IDUSA		:= "501"
			TRB1->DESCUSA	:= "SERVICOS EXTERNOS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "601"
			TRB1->IDUSA		:= "601"
			TRB1->DESCUSA	:= "DESPESAS DE INSPECAO DE FABRICA"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "701"
			TRB1->IDUSA		:= "701"
			TRB1->DESCUSA	:= "DESPESAS DE SERVICO DE CAMPO / SUPERVISAO"		
		endif

		TRB1->ORIGEM 		:= "VD"
		TRB1->NUMERO 		:= ALLTRIM(QUERY->ZZM_GRUPO)
		TRB1->HISTORICO 	:=  QUERY->ZZM_ITEM

		
		if LEN(QUERY->ZZM_GRUPO) > 3 .AND. SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),5,1) = "1" .AND. QUERY->ZZM_TOTAL > 0
			
				if cPlan = "P1"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP1
					TRB1->VALOR		:= QUERY->ZZM_TOTP1
					TRB1->VALOR2	:= QUERY->ZZM_TOTP1
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMCT
				elseif cPlan = "P2"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP2
					TRB1->VALOR		:= QUERY->ZZM_TOTP2
					TRB1->VALOR2	:= QUERY->ZZM_TOTP2
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC2
				elseif cPlan = "P3"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP3
					TRB1->VALOR		:= QUERY->ZZM_TOTP3
					TRB1->VALOR2	:= QUERY->ZZM_TOTP3
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC3
				elseif cPlan = "P4"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP4
					TRB1->VALOR		:= QUERY->ZZM_TOTP4
					TRB1->VALOR2	:= QUERY->ZZM_TOTP4
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC4
				elseif cPlan = "P5"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP5
					TRB1->VALOR		:= QUERY->ZZM_TOTP5
					TRB1->VALOR2	:= QUERY->ZZM_TOTP5
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC5
				elseif cPlan = "P6"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP6
					TRB1->VALOR		:= QUERY->ZZM_TOTP6
					TRB1->VALOR2	:= QUERY->ZZM_TOTP6
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC6
				elseif cPlan = "P7"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP7
					TRB1->VALOR		:= QUERY->ZZM_TOTP7
					TRB1->VALOR2	:= QUERY->ZZM_TOTP7
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC7
				elseif cPlan = "P8"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP8
					TRB1->VALOR		:= QUERY->ZZM_TOTP8
					TRB1->VALOR2	:= QUERY->ZZM_TOTP8
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC8
				else
					TRB1->QUANTIDADE:= QUERY->ZZM_QUANT
					TRB1->VALOR		:= QUERY->ZZM_TOTAL
					TRB1->VALOR2	:= QUERY->ZZM_TOTAL
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMCT
				endif

				//TRB1->QUANTIDADE:= QUERY->ZZM_QUANT
			//TRB1->VALOR		:= QUERY->ZZM_TOTAL
			//TRB1->VALOR2	:= QUERY->ZZM_TOTAL


		ELSEIF LEN(QUERY->ZZM_GRUPO) > 3 .AND. SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),5,1) = "2" .AND. QUERY->ZZM_TOTLB > 0
			//TRB1->QUANTIDADE:= QUERY->ZZM_QTDLB
			//TRB1->VALOR		:= QUERY->ZZM_TOTLB
			//TRB1->VALOR2	:= QUERY->ZZM_TOTLB

				if cPlan = "P1"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP1L
					TRB1->VALOR		:= QUERY->ZZM_TOTP1L
					TRB1->VALOR2	:= QUERY->ZZM_TOTP1L
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMCT
				elseif cPlan = "P2"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP2L
					TRB1->VALOR		:= QUERY->ZZM_TOTP2L
					TRB1->VALOR2	:= QUERY->ZZM_TOTP2L
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC2
				elseif cPlan = "P3"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP3L
					TRB1->VALOR		:= QUERY->ZZM_TOTP3L
					TRB1->VALOR2	:= QUERY->ZZM_TOTP3L
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC3
				elseif cPlan = "P4"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP4L
					TRB1->VALOR		:= QUERY->ZZM_TOTP4L
					TRB1->VALOR2	:= QUERY->ZZM_TOTP4L
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC4
				elseif cPlan = "P5"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP5L
					TRB1->VALOR		:= QUERY->ZZM_TOTP5L
					TRB1->VALOR2	:= QUERY->ZZM_TOTP5L
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC5
				elseif cPlan = "P6"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP6L
					TRB1->VALOR		:= QUERY->ZZM_TOTP6L
					TRB1->VALOR2	:= QUERY->ZZM_TOTP6L
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC6
				elseif cPlan = "P7"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP7L
					TRB1->VALOR		:= QUERY->ZZM_TOTP7L
					TRB1->VALOR2	:= QUERY->ZZM_TOTP7L
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC7
				elseif cPlan = "P8"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP8L
					TRB1->VALOR		:= QUERY->ZZM_TOTP8L
					TRB1->VALOR2	:= QUERY->ZZM_TOTP8L
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC8
				else
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDLB
					TRB1->VALOR		:= QUERY->ZZM_TOTLB
					TRB1->VALOR2	:= QUERY->ZZM_TOTLB
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMCT
				endif
				//TRB1->QUANTIDADE:= QUERY->ZZM_QTDLB
			//TRB1->VALOR		:= QUERY->ZZM_TOTLB
			//TRB1->VALOR2	:= QUERY->ZZM_TOTLB

		ELSEIF LEN(QUERY->ZZM_GRUPO) > 3 .AND. SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),5,1) = "3" .AND. QUERY->ZZM_TOTEF > 0
			//TRB1->QUANTIDADE:= QUERY->ZZM_QTDEF
			//TRB1->VALOR		:= QUERY->ZZM_TOTEF
			//TRB1->VALOR2	:= QUERY->ZZM_TOTEF
				if cPlan = "P1"
					TRB2->VQUANTEF	:= QUERY->ZZM_QTDP1E
					TRB2->VVUNITEF	:= QUERY->ZZM_TOTP1E
					TRB2->VTOTEF	:= QUERY->ZZM_TOTP1E
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMCT
				elseif cPlan = "P2"
					TRB2->VQUANTEF	:= QUERY->ZZM_QTDP2E
					TRB2->VVUNITEF	:= QUERY->ZZM_TOTP2E
					TRB2->VTOTEF	:= QUERY->ZZM_TOTP2E
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC1
				elseif cPlan = "P3"
					TRB2->VQUANTEF	:= QUERY->ZZM_QTDP3E
					TRB2->VVUNITEF	:= QUERY->ZZM_TOTP3E
					TRB2->VTOTEF	:= QUERY->ZZM_TOTP3E
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC2
				elseif cPlan = "P4"
					TRB2->VQUANTEF	:= QUERY->ZZM_QTDP4E
					TRB2->VVUNITEF	:= QUERY->ZZM_TOTP4E
					TRB2->VTOTEF	:= QUERY->ZZM_TOTP4E
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC4
				elseif cPlan = "P5"
					TRB2->VQUANTEF	:= QUERY->ZZM_QTDP5E
					TRB2->VVUNITEF	:= QUERY->ZZM_TOTP5E
					TRB2->VTOTEF	:= QUERY->ZZM_TOTP5E
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC5
				elseif cPlan = "P6"
					TRB2->VQUANTEF	:= QUERY->ZZM_QTDP6E
					TRB2->VVUNITEF	:= QUERY->ZZM_TOTP6E
					TRB2->VTOTEF	:= QUERY->ZZM_TOTP6E
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC6
				elseif cPlan = "P7"
					TRB2->VQUANTEF	:= QUERY->ZZM_QTDP7E
					TRB2->VVUNITEF	:= QUERY->ZZM_TOTP7E
					TRB2->VTOTEF	:= QUERY->ZZM_TOTP7E
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC7
				elseif cPlan = "P8"
					TRB2->VQUANTEF	:= QUERY->ZZM_QTDP8E
					TRB2->VVUNITEF	:= QUERY->ZZM_TOTP8E
					TRB2->VTOTEF	:= QUERY->ZZM_TOTP8E
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC8
				else
					TRB2->VQUANTEF	:= QUERY->ZZM_QTDEF
					TRB2->VVUNITEF	:= QUERY->ZZM_TOTEF
					TRB2->VTOTEF	:= QUERY->ZZM_TOTP1E
					TRB1->ITEMCONTA	:= QUERY->ZZM_TOTEF
				endif
				//TRB1->QUANTIDADE:= QUERY->ZZM_QTDEF
			//TRB1->VALOR		:= QUERY->ZZM_TOTEF
			//TRB1->VALOR2	:= QUERY->ZZM_TOTEF
		ENDIF

		
		TRB1->CAMPO			:= "VLRVD"

		MsUnlock()

		QUERY->(dbskip())

	enddo
	//*********** GRUPOS 200

	//cFor := "ALLTRIM(QUERY->ZZM_ITEMCT) == _cItemConta .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) = '2' .AND. QUERY->ZZM_TOTGR > 0"
	//IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_ITEMCT",,cFor,"Selecionando Registros...")
		if cPlan = "P1"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMCT) == _cItemConta .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) = '2' .AND. QUERY->ZZM_TOTGR > 0" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMCT
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMCT",,cFor,"Selecionando Registros...")

		elseif cPlan = "P2"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC2) == _cItemConta .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) = '2' .AND. QUERY->ZZM_TOTGR > 0" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC2
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC2",,cFor,"Selecionando Registros...")

		elseif cPlan = "P3"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC3) == _cItemConta .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) = '2' .AND. QUERY->ZZM_TOTGR > 0" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC3
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC3",,cFor,"Selecionando Registros...")

		elseif cPlan = "P4"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC4) == _cItemConta .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) = '2' .AND. QUERY->ZZM_TOTGR > 0" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC4
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC4",,cFor,"Selecionando Registros...")

		elseif cPlan = "P5" 
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC5) == _cItemConta .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) = '2' .AND. QUERY->ZZM_TOTGR > 0" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC5
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC5",,cFor,"Selecionando Registros...")

		elseif cPlan = "P6"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC6) == _cItemConta .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) = '2' .AND. QUERY->ZZM_TOTGR > 0" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC6
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC6",,cFor,"Selecionando Registros...")

		elseif cPlan = "P7"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC7) == _cItemConta .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) = '2' .AND. QUERY->ZZM_TOTGR > 0" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC7
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC7",,cFor,"Selecionando Registros...")

		elseif cPlan = "P8"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC8) == _cItemConta .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) = '2' .AND. QUERY->ZZM_TOTGR > 0" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC8
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC8",,cFor,"Selecionando Registros...")
		eLSE
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMCT) == _cItemConta .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) = '2' .AND. QUERY->ZZM_TOTGR > 0" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMCT
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMCT",,cFor,"Selecionando Registros...")

		endif
	ProcRegua(QUERY->(reccount()))

	QUERY->(dbgotop())

	while QUERY->(!eof())

		RecLock("TRB1",.T.)

		//IncProc("Processando registro: "+alltrim(QUERY->ZZM_GRUPO))
		//MsProcTxt("Processando registro: "+alltrim(QUERY->ZG_IDVDSUB))
		//ProcessMessage()

		if alltrim(QUERY->ZZM_GRUPO) = "200"
			QUERY->(dbskip())
			loop
		endif
		
		if SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3) == "201"
			TRB1->IDUSA		:= "201"
			TRB1->DESCUSA	:= "SUBMITTALS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "202"
			TRB1->IDUSA		:= "202"
			TRB1->DESCUSA	:= "PROJETO / LAYOUT / CALCULOS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "204"
			TRB1->IDUSA		:= "204"
			TRB1->DESCUSA	:= "DETALHAMENTO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "205"
			TRB1->IDUSA		:= "205"
			TRB1->DESCUSA	:= "VERIFICAO / APROVACAO"
		Elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "206"
			TRB1->IDUSA		:= "206"
			TRB1->DESCUSA	:= "ENGENHARIA DE ACIONAMENTO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "207"
			TRB1->IDUSA		:= "207"
			TRB1->DESCUSA	:= "ENGENHARIA ELETRICA"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "210"
			TRB1->IDUSA		:= "210"
			TRB1->DESCUSA	:= "GERENCIAMENTO DE PROJETOS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "211"
			TRB1->IDUSA		:= "211"
			TRB1->DESCUSA	:= "COMPRAS / EXPEDICAO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "212"
			TRB1->IDUSA		:= "212"
			TRB1->DESCUSA	:= "MONTAGEM ELETRICA"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "213"
			TRB1->IDUSA		:= "213"
			TRB1->DESCUSA	:= "OUTRA MONTAGEM / TESTE"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3) == "217"
			TRB1->IDUSA		:= "217"
			TRB1->DESCUSA	:= "INSPECAO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "218"
			TRB1->IDUSA		:= "218"
			TRB1->DESCUSA	:= "SERVICO / TESTE DE CAMPO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "220"
			TRB1->IDUSA		:= "220"
			TRB1->DESCUSA	:= "OUTRO, O&M, COPIA, EMBARQUE"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "221"
			TRB1->IDUSA		:= "221"
			TRB1->DESCUSA	:= "TESTES / MODIFICACOES ELETRICAS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "222"
			TRB1->IDUSA		:= "222"
			TRB1->DESCUSA	:= "PROGRAMACAO PLC"
		endif
		
		TRB1->ORIGEM 		:= "VD"
		TRB1->NUMERO 		:= ALLTRIM(QUERY->ZZM_GRUPO)
		TRB1->HISTORICO 	:=  QUERY->ZZM_ITEM

		if  QUERY->ZZM_TOTGR > 0 .AND. QUERY->ZZM_GRUPO <> "200"
			
			if cPlan = "P1"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP1 + QUERY->ZZM_QTDP1L + QUERY->ZZM_QTDP1E
					TRB1->VALOR		:= QUERY->ZZM_TOTP1 + QUERY->ZZM_TOTP1L + QUERY->ZZM_TOTP1E //QUERY->ZZM_TOTGR
					TRB1->VALOR2	:= QUERY->ZZM_TOTP1 + QUERY->ZZM_TOTP1L + QUERY->ZZM_TOTP1E //QUERY->ZZM_TOTGR
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMCT
				elseif cPlan = "P2"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP2 + QUERY->ZZM_QTDP2L + QUERY->ZZM_QTDP2E
					TRB1->VALOR		:= QUERY->ZZM_TOTP2 + QUERY->ZZM_TOTP2L + QUERY->ZZM_TOTP2E //QUERY->ZZM_TOTGR
					TRB1->VALOR2	:= QUERY->ZZM_TOTP2 + QUERY->ZZM_TOTP2L + QUERY->ZZM_TOTP2E //QUERY->ZZM_TOTGR
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC2
				elseif cPlan = "P3"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP3 + QUERY->ZZM_QTDP3L + QUERY->ZZM_QTDP3E
					TRB1->VALOR		:= QUERY->ZZM_TOTP3 + QUERY->ZZM_TOTP3L + QUERY->ZZM_TOTP3E //QUERY->ZZM_TOTGR
					TRB1->VALOR2	:= QUERY->ZZM_TOTP3 + QUERY->ZZM_TOTP3L + QUERY->ZZM_TOTP3E //QUERY->ZZM_TOTGR
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC3
				elseif cPlan = "P4"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP4 + QUERY->ZZM_QTDP4L + QUERY->ZZM_QTDP4E
					TRB1->VALOR		:= QUERY->ZZM_TOTP4 + QUERY->ZZM_TOTP4L + QUERY->ZZM_TOTP4E //QUERY->ZZM_TOTGR
					TRB1->VALOR2	:= QUERY->ZZM_TOTP4 + QUERY->ZZM_TOTP4L + QUERY->ZZM_TOTP4E //QUERY->ZZM_TOTGR
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC4
				elseif cPlan = "P5"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP5 + QUERY->ZZM_QTDP5L + QUERY->ZZM_QTDP5E
					TRB1->VALOR		:= QUERY->ZZM_TOTP5 + QUERY->ZZM_TOTP5L + QUERY->ZZM_TOTP5E //QUERY->ZZM_TOTGR
					TRB1->VALOR2	:= QUERY->ZZM_TOTP5 + QUERY->ZZM_TOTP5L + QUERY->ZZM_TOTP5E //QUERY->ZZM_TOTGR
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC5
				elseif cPlan = "P6"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP6 + QUERY->ZZM_QTDP6L + QUERY->ZZM_QTDP6E
					TRB1->VALOR		:= QUERY->ZZM_TOTP6 + QUERY->ZZM_TOTP6L + QUERY->ZZM_TOTP6E //QUERY->ZZM_TOTGR
					TRB1->VALOR2	:= QUERY->ZZM_TOTP6 + QUERY->ZZM_TOTP6L + QUERY->ZZM_TOTP6E //QUERY->ZZM_TOTGR
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC6
				elseif cPlan = "P7"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP7 + QUERY->ZZM_QTDP7L + QUERY->ZZM_QTDP7E
					TRB1->VALOR		:= QUERY->ZZM_TOTP7 + QUERY->ZZM_TOTP7L + QUERY->ZZM_TOTP7E //QUERY->ZZM_TOTGR
					TRB1->VALOR2	:= QUERY->ZZM_TOTP7 + QUERY->ZZM_TOTP7L + QUERY->ZZM_TOTP7E //QUERY->ZZM_TOTGR
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC7
				elseif cPlan = "P8"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP8 + QUERY->ZZM_QTDP8L + QUERY->ZZM_QTDP8E
					TRB1->VALOR		:= QUERY->ZZM_TOTP8 + QUERY->ZZM_TOTP8L + QUERY->ZZM_TOTP8E //QUERY->ZZM_TOTGR
					TRB1->VALOR2	:= QUERY->ZZM_TOTP8 + QUERY->ZZM_TOTP8L + QUERY->ZZM_TOTP8E //QUERY->ZZM_TOTGR
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC8
				else
					TRB1->QUANTIDADE:= QUERY->ZZM_QUANT + QUERY->ZZM_QTDLB + QUERY->ZZM_QTDEF
					TRB1->VALOR		:= QUERY->ZZM_TOTGR
					TRB1->VALOR2	:= QUERY->ZZM_TOTGR
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMCT
				endif

				//TRB1->QUANTIDADE:= QUERY->ZZM_QUANT + QUERY->ZZM_QTDLB + QUERY->ZZM_QTDEF
			//TRB1->VALOR		:= QUERY->ZZM_TOTGR
			//TRB1->VALOR2	:= QUERY->ZZM_TOTGR
		ENDIF

		//TRB1->ITEMCONTA		:= QUERY->ZZM_ITEMCT
		TRB1->CAMPO			:= "VLRVD"

		MsUnlock()

		QUERY->(dbskip())

	enddo

	//*********** GRUPOS 801/900/901/902/903/904/905/906/908
	//cFor := "ALLTRIM(QUERY->ZZM_ITEMCT) == _cItemConta .AND. alltrim(QUERY->ZZM_GRUPO) $ ('801/900/901/902/903/904/905/906/908') .AND. QUERY->ZZM_TOTGR > 0 "

	//IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_ITEMCT",,cFor,"Selecionando Registros...")
		if cPlan = "P1"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMCT) == _cItemConta .AND. alltrim(QUERY->ZZM_GRUPO) $ ('801/900/901/902/903/904/905/906/908') " //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMCT
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMCT",,cFor,"Selecionando Registros...")
			
		elseif cPlan = "P2"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC2) == _cItemConta .AND. alltrim(QUERY->ZZM_GRUPO) $ ('801/900/901/902/903/904/905/906/908') " //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC2
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC2",,cFor,"Selecionando Registros...")

		elseif cPlan = "P3"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC3) == _cItemConta .AND. alltrim(QUERY->ZZM_GRUPO) $ ('801/900/901/902/903/904/905/906/908') " //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC3
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC3",,cFor,"Selecionando Registros...")

		elseif cPlan = "P4"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC4) == _cItemConta .AND. alltrim(QUERY->ZZM_GRUPO) $ ('801/900/901/902/903/904/905/906/908') " //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC4
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC4",,cFor,"Selecionando Registros...")

		elseif cPlan = "P5" 
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC5) == _cItemConta .AND. alltrim(QUERY->ZZM_GRUPO) $ ('801/900/901/902/903/904/905/906/908') " //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC5
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC5",,cFor,"Selecionando Registros...")

		elseif cPlan = "P6"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC6) == _cItemConta .AND. alltrim(QUERY->ZZM_GRUPO) $ ('801/900/901/902/903/904/905/906/908') " //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC6
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC6",,cFor,"Selecionando Registros...")

		elseif cPlan = "P7"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC7) == _cItemConta .AND. alltrim(QUERY->ZZM_GRUPO) $ ('801/900/901/902/903/904/905/906/908') " //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC7
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC7",,cFor,"Selecionando Registros...")

		elseif cPlan = "P8"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC8) == _cItemConta .AND. alltrim(QUERY->ZZM_GRUPO) $ ('801/900/901/902/903/904/905/906/908') " //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC8
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC8",,cFor,"Selecionando Registros...")
		eLSE
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMCT) == _cItemConta .AND. alltrim(QUERY->ZZM_GRUPO) $ ('801/900/901/902/903/904/905/906/908') " //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMCT
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMCT",,cFor,"Selecionando Registros...")

		endif

	ProcRegua(QUERY->(reccount()))
	QUERY->(dbgotop())
	while QUERY->(!eof())

		RecLock("TRB1",.T.)

		//IncProc("Processando registro: "+alltrim(QUERY->ZZM_GRUPO))
		//MsProcTxt("Processando registro: "+alltrim(QUERY->ZG_IDVDSUB))
		//ProcessMessage()
		
		if SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3) == "801"
			TRB1->IDUSA		:= "801"
			TRB1->DESCUSA	:= "CONTINGENCIAS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "900"
			TRB1->IDUSA		:= "900"
			TRB1->DESCUSA	:= "OUTROS ITENS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "901"
			TRB1->IDUSA		:= "901"
			TRB1->DESCUSA	:= "TRIBUTOS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "902"
			TRB1->IDUSA		:= "902"
			TRB1->DESCUSA	:= "OBRIGACOES / CARTA DE CREDITO"
		Elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "903"
			TRB1->IDUSA		:= "903"
			TRB1->DESCUSA	:= "TAXAS DE PATENTE / LICENCA"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "904"
			TRB1->IDUSA		:= "904"
			TRB1->DESCUSA	:= "STANDBY LETTER OF CREDIT / BOUNDS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "905"
			TRB1->IDUSA		:= "905"
			TRB1->DESCUSA	:= "FRETE PRE-PAGO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "906"
			TRB1->IDUSA		:= "906"
			TRB1->DESCUSA	:= "OUTROS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  = "908"
			TRB1->IDUSA		:= "908"
			TRB1->DESCUSA	:= "COMISSAO"
		endif
		
		TRB1->ORIGEM 		:= "VD"
		TRB1->NUMERO 		:= ALLTRIM(QUERY->ZZM_GRUPO)
		TRB1->HISTORICO 	:=  QUERY->ZZM_ITEM

		if  QUERY->ZZM_TOTGR > 0 .AND. alltrim(QUERY->ZZM_GRUPO) $ ('801/900/901/902/903/904/905/906/908') 
				//msginfo("teste 1")
				if cPlan = "P1"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP1 + QUERY->ZZM_QTDP1L + QUERY->ZZM_QTDP1E
					TRB1->VALOR		:= QUERY->ZZM_TOTP1 + QUERY->ZZM_TOTP1L + QUERY->ZZM_TOTP1E //QUERY->ZZM_TOTGR
					TRB1->VALOR2	:= QUERY->ZZM_TOTP1 + QUERY->ZZM_TOTP1L + QUERY->ZZM_TOTP1E //QUERY->ZZM_TOTGR
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMCT
					//msginfo("teste 2")
				elseif cPlan = "P2"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP2 + QUERY->ZZM_QTDP2L + QUERY->ZZM_QTDP2E
					TRB1->VALOR		:= QUERY->ZZM_TOTP2 + QUERY->ZZM_TOTP2L + QUERY->ZZM_TOTP2E //QUERY->ZZM_TOTGR
					TRB1->VALOR2	:= QUERY->ZZM_TOTP2 + QUERY->ZZM_TOTP2L + QUERY->ZZM_TOTP2E //QUERY->ZZM_TOTGR
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC2
				elseif cPlan = "P3"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP3 + QUERY->ZZM_QTDP3L + QUERY->ZZM_QTDP3E
					TRB1->VALOR		:= QUERY->ZZM_TOTP3 + QUERY->ZZM_TOTP3L + QUERY->ZZM_TOTP3E //QUERY->ZZM_TOTGR
					TRB1->VALOR2	:= QUERY->ZZM_TOTP3 + QUERY->ZZM_TOTP3L + QUERY->ZZM_TOTP3E //QUERY->ZZM_TOTGR
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC3
				elseif cPlan = "P4"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP4 + QUERY->ZZM_QTDP4L + QUERY->ZZM_QTDP4E
					TRB1->VALOR		:= QUERY->ZZM_TOTP4 + QUERY->ZZM_TOTP4L + QUERY->ZZM_TOTP4E //QUERY->ZZM_TOTGR
					TRB1->VALOR2	:= QUERY->ZZM_TOTP4 + QUERY->ZZM_TOTP4L + QUERY->ZZM_TOTP4E //QUERY->ZZM_TOTGR
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC4
				elseif cPlan = "P5"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP5 + QUERY->ZZM_QTDP5L + QUERY->ZZM_QTDP5E
					TRB1->VALOR		:= QUERY->ZZM_TOTP5 + QUERY->ZZM_TOTP5L + QUERY->ZZM_TOTP5E //QUERY->ZZM_TOTGR
					TRB1->VALOR2	:= QUERY->ZZM_TOTP5 + QUERY->ZZM_TOTP5L + QUERY->ZZM_TOTP5E //QUERY->ZZM_TOTGR
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC5
				elseif cPlan = "P6"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP6 + QUERY->ZZM_QTDP6L + QUERY->ZZM_QTDP6E
					TRB1->VALOR		:= QUERY->ZZM_TOTP6 + QUERY->ZZM_TOTP6L + QUERY->ZZM_TOTP6E //QUERY->ZZM_TOTGR
					TRB1->VALOR2	:= QUERY->ZZM_TOTP6 + QUERY->ZZM_TOTP6L + QUERY->ZZM_TOTP6E //QUERY->ZZM_TOTGR
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC6
				elseif cPlan = "P7"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP7 + QUERY->ZZM_QTDP7L + QUERY->ZZM_QTDP7E
					TRB1->VALOR		:= QUERY->ZZM_TOTP7 + QUERY->ZZM_TOTP7L + QUERY->ZZM_TOTP7E //QUERY->ZZM_TOTGR
					TRB1->VALOR2	:= QUERY->ZZM_TOTP7 + QUERY->ZZM_TOTP7L + QUERY->ZZM_TOTP7E //QUERY->ZZM_TOTGR
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC7
				elseif cPlan = "P8"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP8 + QUERY->ZZM_QTDP8L + QUERY->ZZM_QTDP8E
					TRB1->VALOR		:= QUERY->ZZM_TOTP8 + QUERY->ZZM_TOTP8L + QUERY->ZZM_TOTP8E //QUERY->ZZM_TOTGR
					TRB1->VALOR2	:= QUERY->ZZM_TOTP8 + QUERY->ZZM_TOTP8L + QUERY->ZZM_TOTP8E //QUERY->ZZM_TOTGR
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC8
				else
					TRB1->QUANTIDADE:= QUERY->ZZM_QUANT + QUERY->ZZM_QTDLB + QUERY->ZZM_QTDEF
					TRB1->VALOR		:= QUERY->ZZM_TOTAL + QUERY->ZZM_TOTLB + QUERY->ZZM_TOTEF 
					TRB1->VALOR2	:= QUERY->ZZM_TOTAL + QUERY->ZZM_TOTLB + QUERY->ZZM_TOTEF
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMCT
				endif
		endif
		//TRB1->QUANTIDADE:= QUERY->ZZM_QUANT + QUERY->ZZM_QTDLB + QUERY->ZZM_QTDEF
		//TRB1->VALOR		:= QUERY->ZZM_TOTGR
		//TRB1->VALOR2	:= QUERY->ZZM_TOTGR

		//TRB1->ITEMCONTA		:= QUERY->ZZM_ITEMCT
		TRB1->CAMPO			:= "VLRVD"

		MsUnlock()

		QUERY->(dbskip())

	enddo

	QUERY->(dbclosearea())
	QUERYZZN->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Processa planejado slc																				              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function PlanSLC()
	local _cQuery := ""
	Local _cFilZZN := xFilial("ZZN")
	local cFor := "ALLTRIM(QUERY->ZZN_ITEMCT) == _cItemConta .AND. QUERY->ZZN_GS = 'S' .AND. QUERY->ZZN_TOTGR > 0 .AND. substr(alltrim(QUERY->ZZN_GRUPO),1,3) $ ('101/102/103/104/105/106/107/108/109/301/501/601/701')" //
	ZZN->(dbsetorder(2))

	ChkFile("ZZN",.F.,"QUERY")
	IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZN_ITEMCT",,cFor,"Selecionando Registros...")

	ProcRegua(QUERY->(reccount()))

	QUERY->(dbgotop())

	while QUERY->(!eof())

		RecLock("TRB1",.T.)

		//IncProc("Processando registro: "+alltrim(QUERY->ZZN_GRUPO))
		//MsProcTxt("Processando registro: "+alltrim(QUERY->ZG_IDVDSUB))
		//ProcessMessage()

		if SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3) == "101"
			TRB1->IDUSA		:= "101"
			TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3) == "102"
			TRB1->IDUSA		:= "102"
			TRB1->DESCUSA	:= "TINTAS / REVESTIMENTOS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)== "103"
			TRB1->IDUSA		:= "103"
			TRB1->DESCUSA	:= "BARREIRAS E DEFLETORES"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)== "104"
			TRB1->IDUSA		:= "104"
			TRB1->DESCUSA	:= "UNIDADE(S) DE ACIONAMENTO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3) == "105"
			TRB1->IDUSA		:= "105"
			TRB1->DESCUSA	:= "PARAFUSOS E ELELEMENTOS DE FIXACAO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3) == "106"
			TRB1->IDUSA		:= "106"
			TRB1->DESCUSA	:= "CONTROLES ELETRICOS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3) == "107"
			TRB1->IDUSA		:= "107"
			TRB1->DESCUSA	:= "INSTRUMENTACAO"
		Elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3) == "108"
			TRB1->IDUSA		:= "108"
			TRB1->DESCUSA	:= "OUTRAS AQUISICOES"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3) == "109"
			TRB1->IDUSA		:= "109"
			TRB1->DESCUSA	:= "FRETE INTERNO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3) == "201"
			TRB1->IDUSA		:= "201"
			TRB1->DESCUSA	:= "SUBMITTALS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "202"
			TRB1->IDUSA		:= "202"
			TRB1->DESCUSA	:= "PROJETO / LAYOUT / CALCULOS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "204"
			TRB1->IDUSA		:= "204"
			TRB1->DESCUSA	:= "DETALHAMENTO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "205"
			TRB1->IDUSA		:= "205"
			TRB1->DESCUSA	:= "VERIFICAO / APROVACAO"
		Elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "206"
			TRB1->IDUSA		:= "206"
			TRB1->DESCUSA	:= "ENGENHARIA DE ACIONAMENTO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "207"
			TRB1->IDUSA		:= "207"
			TRB1->DESCUSA	:= "ENGENHARIA ELETRICA"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "210"
			TRB1->IDUSA		:= "210"
			TRB1->DESCUSA	:= "GERENCIAMENTO DE PROJETOS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "211"
			TRB1->IDUSA		:= "211"
			TRB1->DESCUSA	:= "COMPRAS / EXPEDICAO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "212"
			TRB1->IDUSA		:= "212"
			TRB1->DESCUSA	:= "MONTAGEM ELETRICA"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "213"
			TRB1->IDUSA		:= "213"
			TRB1->DESCUSA	:= "OUTRA MONTAGEM / TESTE"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3) == "217"
			TRB1->IDUSA		:= "217"
			TRB1->DESCUSA	:= "INSPECAO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "218"
			TRB1->IDUSA		:= "218"
			TRB1->DESCUSA	:= "SERVICO / TESTE DE CAMPO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "220"
			TRB1->IDUSA		:= "220"
			TRB1->DESCUSA	:= "OUTRO, O&M, COPIA, EMBARQUE"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "221"
			TRB1->IDUSA		:= "221"
			TRB1->DESCUSA	:= "TESTES / MODIFICACOES ELETRICAS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "222"
			TRB1->IDUSA		:= "222"
			TRB1->DESCUSA	:= "PROGRAMACAO PLC"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "301"
			TRB1->IDUSA		:= "301"
			TRB1->DESCUSA	:= "FRETE, EMBALAGEM, AFINS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "501"
			TRB1->IDUSA		:= "501"
			TRB1->DESCUSA	:= "SERVICOS EXTERNOS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "601"
			TRB1->IDUSA		:= "601"
			TRB1->DESCUSA	:= "DESPESAS DE INSPECAO DE FABRICA"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "701"
			TRB1->IDUSA		:= "701"
			TRB1->DESCUSA	:= "DESPESAS DE SERVICO DE CAMPO / SUPERVISAO"		
		endif

		TRB1->ORIGEM 		:= "PL"
		TRB1->NUMERO 		:= ALLTRIM(QUERY->ZZN_GRUPO)
		TRB1->HISTORICO 	:=  QUERY->ZZN_ITEM

		if LEN(QUERY->ZZN_GRUPO) > 3 .AND. SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),5,1) = "1" .AND. QUERY->ZZN_TOTAL > 0
			TRB1->QUANTIDADE:= QUERY->ZZN_QUANT
			TRB1->VALOR		:= QUERY->ZZN_TOTAL
			TRB1->VALOR2	:= QUERY->ZZN_TOTAL
		ELSEIF LEN(QUERY->ZZN_GRUPO) > 3 .AND. SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),5,1) = "2" .AND. QUERY->ZZN_TOTLB > 0
			TRB1->QUANTIDADE:= QUERY->ZZN_QTDLB
			TRB1->VALOR		:= QUERY->ZZN_TOTLB
			TRB1->VALOR2	:= QUERY->ZZN_TOTLB
		ELSEIF LEN(QUERY->ZZN_GRUPO) > 3 .AND. SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),5,1) = "3" .AND. QUERY->ZZN_TOTEF > 0
			TRB1->QUANTIDADE:= QUERY->ZZN_QTDEF
			TRB1->VALOR		:= QUERY->ZZN_TOTEF
			TRB1->VALOR2	:= QUERY->ZZN_TOTEF
		ENDIF

		TRB1->ITEMCONTA		:= QUERY->ZZN_ITEMCT
		TRB1->CAMPO			:= "VLRPLN"

		MsUnlock()

		QUERY->(dbskip())

	enddo
	//*********** GRUPOS 200
	cFor := "ALLTRIM(QUERY->ZZN_ITEMCT) == _cItemConta .AND. SUBSTR(QUERY->ZZN_GRUPO,1,1) = '2' .AND. QUERY->ZZN_TOTGR > 0"

	IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZN_ITEMCT",,cFor,"Selecionando Registros...")

	ProcRegua(QUERY->(reccount()))

	QUERY->(dbgotop())

	while QUERY->(!eof())

		RecLock("TRB1",.T.)

		//IncProc("Processando registro: "+alltrim(QUERY->ZZN_GRUPO))
		//MsProcTxt("Processando registro: "+alltrim(QUERY->ZG_IDVDSUB))
		//ProcessMessage()

		if alltrim(QUERY->ZZN_GRUPO) = "200"
			QUERY->(dbskip())
			loop
		endif
		
		if SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3) == "201"
			TRB1->IDUSA		:= "201"
			TRB1->DESCUSA	:= "SUBMITTALS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "202"
			TRB1->IDUSA		:= "202"
			TRB1->DESCUSA	:= "PROJETO / LAYOUT / CALCULOS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "204"
			TRB1->IDUSA		:= "204"
			TRB1->DESCUSA	:= "DETALHAMENTO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "205"
			TRB1->IDUSA		:= "205"
			TRB1->DESCUSA	:= "VERIFICAO / APROVACAO"
		Elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "206"
			TRB1->IDUSA		:= "206"
			TRB1->DESCUSA	:= "ENGENHARIA DE ACIONAMENTO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "207"
			TRB1->IDUSA		:= "207"
			TRB1->DESCUSA	:= "ENGENHARIA ELETRICA"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "210"
			TRB1->IDUSA		:= "210"
			TRB1->DESCUSA	:= "GERENCIAMENTO DE PROJETOS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "211"
			TRB1->IDUSA		:= "211"
			TRB1->DESCUSA	:= "COMPRAS / EXPEDICAO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "212"
			TRB1->IDUSA		:= "212"
			TRB1->DESCUSA	:= "MONTAGEM ELETRICA"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "213"
			TRB1->IDUSA		:= "213"
			TRB1->DESCUSA	:= "OUTRA MONTAGEM / TESTE"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3) == "217"
			TRB1->IDUSA		:= "217"
			TRB1->DESCUSA	:= "INSPECAO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "218"
			TRB1->IDUSA		:= "218"
			TRB1->DESCUSA	:= "SERVICO / TESTE DE CAMPO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "220"
			TRB1->IDUSA		:= "220"
			TRB1->DESCUSA	:= "OUTRO, O&M, COPIA, EMBARQUE"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "221"
			TRB1->IDUSA		:= "221"
			TRB1->DESCUSA	:= "TESTES / MODIFICACOES ELETRICAS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "222"
			TRB1->IDUSA		:= "222"
			TRB1->DESCUSA	:= "PROGRAMACAO PLC"
		endif
		
		TRB1->ORIGEM 		:= "PL"
		TRB1->NUMERO 		:= ALLTRIM(QUERY->ZZN_GRUPO)
		TRB1->HISTORICO 	:=  QUERY->ZZN_ITEM

		if  QUERY->ZZN_TOTGR > 0 .AND. QUERY->ZZN_GRUPO <> "200"
			TRB1->QUANTIDADE:= QUERY->ZZN_QUANT + QUERY->ZZN_QTDLB + QUERY->ZZN_QTDEF
			TRB1->VALOR		:= QUERY->ZZN_TOTGR
			TRB1->VALOR2	:= QUERY->ZZN_TOTGR
		ENDIF

		TRB1->ITEMCONTA		:= QUERY->ZZN_ITEMCT
		TRB1->CAMPO			:= "VLRPLN"

		MsUnlock()

		QUERY->(dbskip())

	enddo

	//*********** GRUPOS 801/900/901/902/903/904/905/906/908
	cFor := "ALLTRIM(QUERY->ZZN_ITEMCT) == _cItemConta .AND. alltrim(QUERY->ZZN_GRUPO) $ ('801/900/901/902/903/904/905/906/908')  "

	IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZN_ITEMCT",,cFor,"Selecionando Registros...")

	ProcRegua(QUERY->(reccount()))

	QUERY->(dbgotop())

	while QUERY->(!eof())

		RecLock("TRB1",.T.)

		//IncProc("Processando registro: "+alltrim(QUERY->ZZN_GRUPO))
		//MsProcTxt("Processando registro: "+alltrim(QUERY->ZG_IDVDSUB))
		//ProcessMessage()
		
		if SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3) == "801"
			TRB1->IDUSA		:= "801"
			TRB1->DESCUSA	:= "CONTINGENCIAS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "900"
			TRB1->IDUSA		:= "900"
			TRB1->DESCUSA	:= "OUTROS ITENS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "901"
			TRB1->IDUSA		:= "901"
			TRB1->DESCUSA	:= "TRIBUTOS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "902"
			TRB1->IDUSA		:= "902"
			TRB1->DESCUSA	:= "OBRIGACOES / CARTA DE CREDITO"
		Elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "903"
			TRB1->IDUSA		:= "903"
			TRB1->DESCUSA	:= "TAXAS DE PATENTE / LICENCA"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "904"
			TRB1->IDUSA		:= "904"
			TRB1->DESCUSA	:= "STANDBY LETTER OF CREDIT / BOUNDS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "905"
			TRB1->IDUSA		:= "905"
			TRB1->DESCUSA	:= "FRETE PRE-PAGO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "906"
			TRB1->IDUSA		:= "906"
			TRB1->DESCUSA	:= "OUTROS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "908"
			TRB1->IDUSA		:= "908"
			TRB1->DESCUSA	:= "COMISSAO"
		endif
		
		TRB1->ORIGEM 		:= "PL"
		TRB1->NUMERO 		:= ALLTRIM(QUERY->ZZN_GRUPO)
		TRB1->HISTORICO 	:=  QUERY->ZZN_ITEM

		TRB1->QUANTIDADE:= QUERY->ZZN_QUANT + QUERY->ZZN_QTDLB + QUERY->ZZN_QTDEF
		TRB1->VALOR		:= QUERY->ZZN_TOTGR
		TRB1->VALOR2	:= QUERY->ZZN_TOTGR

		TRB1->ITEMCONTA		:= QUERY->ZZN_ITEMCT
		TRB1->CAMPO			:= "VLRPLN"

		MsUnlock()

		QUERY->(dbskip())

	enddo

	QUERY->(dbclosearea())
	
	

return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Processa Vendido 01 Percas					              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function VEND01()

local _cQuery := ""
Local _cFilSZG := xFilial("SZG")
local cFor := "ALLTRIM(QUERY->ZG_ITEMIC) == _cItemConta"
SZG->(dbsetorder(3))

ChkFile("SZG",.F.,"QUERY")
IndRegua("QUERY",CriaTrab(NIL,.F.),"ZG_ITEMIC",,cFor,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())

while QUERY->(!eof())

	if ALLTRIM(QUERY->ZG_ITEMIC) == alltrim(_cItemConta)

		RecLock("TRB1",.T.)
		
		//IncProc("Processando registro: "+alltrim(QUERY->ZG_IDVDSUB))
		//MsProcTxt("Processando registro: "+alltrim(QUERY->ZG_IDVDSUB))
		//ProcessMessage()

		TRB1->TIPO		:= "N2"
		TRB1->NUMERO	:= QUERY->ZG_IDVDSUB
		TRB1->ID		:= "MPR"
		TRB1->DESCRICAO	:= "MATERIA PRIMA"
		

		if empty(QUERY->ZG_GRUSA)
			if alltrim(QUERY->ZG_GRUPO) == "MPR"
				TRB1->ID		:= "MPR"
				TRB1->DESCRICAO	:= "MATERIA PRIMA"
			elseif alltrim(QUERY->ZG_GRUPO) == "FAB"
				TRB1->ID		:= "FAB"
				TRB1->DESCRICAO	:= "FABRICACAO"
			elseif alltrim(QUERY->ZG_GRUPO) == "COM"
				TRB1->ID		:= "COM"
				TRB1->DESCRICAO	:= "COMERCIAIS"
			elseif alltrim(QUERY->ZG_GRUPO) == "SRV"
				TRB1->ID		:= "SRV"
				TRB1->DESCRICAO	:= "SERVICOS"
			elseif alltrim(QUERY->ZG_GRUPO) == "ESL"
				TRB1->ID		:= "ESL"
				TRB1->DESCRICAO	:= "ENGENHARIA SLC"
			elseif alltrim(QUERY->ZG_GRUPO) == "EBR"
				TRB1->ID		:= "EBR"
				TRB1->DESCRICAO	:= "ENGENHARIA BR"
			elseif alltrim(QUERY->ZG_GRUPO) == "CTR"
				TRB1->ID		:= "CTR"
				TRB1->DESCRICAO	:= "CONTRATOS"
			elseif alltrim(QUERY->ZG_GRUPO) == "IDL"
				TRB1->ID		:= "IDL"
				TRB1->DESCRICAO	:= "INSPECAO / DILIGENCIAMENTO"
			/*elseif alltrim(QUERY->ZD_GRUPO) == "FIN"
				TRB1->ID		:= "FIN"
				TRB1->DESCRICAO	:= "FINANCEIRO"*/
			elseif alltrim(QUERY->ZG_GRUPO) == "CMS"
				TRB1->ID		:= "CMS"
				TRB1->DESCRICAO	:= "COMISSAO"
			elseif alltrim(QUERY->ZG_GRUPO) == "RDV"
				TRB1->ID		:= "RDV"
				TRB1->DESCRICAO	:= "RELATORIO DE VIAGEM"
			elseif alltrim(QUERY->ZG_GRUPO) == "FRT"
				TRB1->ID		:= "FRT"
				TRB1->DESCRICAO	:= "FRETE"
			elseif alltrim(QUERY->ZG_GRUPO) == "CDV"
				TRB1->ID		:= "CDV"
				TRB1->DESCRICAO	:= "CUSTO DIVERSOS"
			endif
		endif

		TRB1->PRODUTO		:= ""
		TRB1->QUANTIDADE	:= QUERY->ZG_QUANT
		TRB1->UNIDADE		:= QUERY->ZG_UM
		TRB1->HISTORICO		:= QUERY->ZG_DESCRI
		TRB1->VALOR			:= QUERY->ZG_TOTAL

		TRB1->ORIGEM		:= "VD"
		TRB1->ITEMCONTA 	:= QUERY->ZG_ITEMIC
		TRB1->CAMPO		 	:= "VLRVD"

		MsUnlock()

	endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Processa Vendido 01 Equipamento / Sistema	              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function VEND02()

local _cQuery := ""
Local _cFilSZP := xFilial("SZP")
Local cIDSZF := ""
Local cIDSZG := ""
Local cIDSZP := ""

Local nQTDSZF := 0
Local nQTDSZG := 0 
Local nQTDSZP := 0

Local nQTSZG := 0

Local cDescSZP := ""
Local cDescSZG := ""
local cFor := "ALLTRIM(QUERY->ZP_ITEMIC) == _cItemConta"

Local aInd:={}
Local cCondicao
Local bFiltraBrw

dbSelectArea("SZF")
SZF->( dbSetOrder(1)) 
SZF->(dbgotop())

dbSelectArea("SZG")
SZG->( dbSetOrder(1))
SZG->(dbgotop())
 
SZP->(dbsetorder(3))

ChkFile("SZP",.F.,"QUERY")
IndRegua("QUERY",CriaTrab(NIL,.F.),"ZP_ITEMIC",,cFor,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())

while QUERY->(!eof())

	if ALLTRIM(QUERY->ZP_ITEMIC) == alltrim(_cItemConta)

		RecLock("TRB1",.T.)
		
		//MsProcTxt("Processando registro: "+alltrim(QUERY->ZP_IDVDSUB))
		//ProcessMessage()

		TRB1->TIPO		:= "N3"
		TRB1->NUMERO	:= QUERY->ZP_IDVDSUB
		TRB1->ID		:= "MPR"
		TRB1->DESCRICAO	:= "MATERIA PRIMA"
		TRB1->IDUSA		:= "108"
		TRB1->DESCUSA	:= "OUTRAS AQUISICOES"

		if empty(alltrim(QUERY->ZP_GRUSA))
			if alltrim(QUERY->ZP_GRUPO) == "MPR"
				TRB1->ID		:= "MPR"
				TRB1->DESCRICAO	:= "MATERIA PRIMA"
				TRB1->IDUSA		:= "101"
				TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
			elseif alltrim(QUERY->ZP_GRUPO) == "FAB"
				TRB1->ID		:= "FAB"
				TRB1->DESCRICAO	:= "FABRICACAO"
				TRB1->IDUSA		:= "101"
				TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
			elseif alltrim(QUERY->ZP_GRUPO) == "COM"
				TRB1->ID		:= "COM"
				TRB1->DESCRICAO	:= "COMERCIAIS"
				TRB1->IDUSA		:= "101"
				TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
			elseif alltrim(QUERY->ZP_GRUPO) == "SRV"
				TRB1->ID		:= "SRV"
				TRB1->DESCRICAO	:= "SERVICOS"
				TRB1->IDUSA		:= "501"
				TRB1->DESCUSA	:= "SERVICOS EXTERNOS"
			elseif alltrim(QUERY->ZP_GRUPO) == "ESL"
				TRB1->ID		:= "ESL"
				TRB1->DESCRICAO	:= "ENGENHARIA SLC"
				TRB1->IDUSA		:= "201"
				TRB1->DESCUSA	:= "SUBMITTALS"
			elseif alltrim(QUERY->ZP_GRUPO) == "EBR"
				TRB1->ID		:= "EBR"
				TRB1->DESCRICAO	:= "ENGENHARIA BR"
				TRB1->IDUSA		:= "201"
				TRB1->DESCUSA	:= "SUBMITTALS"
			elseif alltrim(QUERY->ZP_GRUPO) == "LAB"
				TRB1->ID		:= "LAB"
				TRB1->DESCRICAO	:= "LABORATORIO"
				TRB1->IDUSA		:= "213"
				TRB1->DESCUSA	:= "OUTRA MONTAGEM / TESTE"
			elseif alltrim(QUERY->ZP_GRUPO) == "CTR"
				TRB1->ID		:= "CTR"
				TRB1->DESCRICAO	:= "CONTRATOS"
				TRB1->IDUSA		:= "210"
				TRB1->DESCUSA	:= "GERENCIAMENTO DE PROJETOS"
			elseif alltrim(QUERY->ZP_GRUPO) == "IDL"
				TRB1->ID		:= "IDL"
				TRB1->DESCRICAO	:= "INSPECAO / DILIGENCIAMENTO"
				TRB1->IDUSA		:= "217"
				TRB1->DESCUSA	:= "INSPECAO"
			/*elseif alltrim(QUERY->ZD_GRUPO) == "FIN"
				TRB1->ID		:= "FIN"
				TRB1->DESCRICAO	:= "FINANCEIRO"*/
			elseif alltrim(QUERY->ZP_GRUPO) == "CMS"
				TRB1->ID		:= "CMS"
				TRB1->DESCRICAO	:= "COMISSAO"
				TRB1->IDUSA		:= "501"
				TRB1->DESCUSA	:= "SERVICOS EXTERNOS"
			elseif alltrim(QUERY->ZP_GRUPO) == "RDV"
				TRB1->ID		:= "RDV"
				TRB1->DESCRICAO	:= "RELATORIO DE VIAGEM"
				TRB1->IDUSA		:= "701"
				TRB1->DESCUSA	:= "DESPESAS DE INSPECAO DE FABRICA"
			elseif alltrim(QUERY->ZP_GRUPO) == "FRT"
				TRB1->ID		:= "FRT"
				TRB1->DESCRICAO	:= "FRETE"
				TRB1->IDUSA		:= "301"
				TRB1->DESCUSA	:= "FRETE, EMBALAGEM, AFINS"
			elseif alltrim(QUERY->ZP_GRUPO) == "CDV"
				TRB1->ID		:= "CDV"
				TRB1->DESCRICAO	:= "CUSTO DIVERSOS"
				TRB1->IDUSA		:= "108"
				TRB1->DESCUSA	:= "OUTRAS AQUISICOES"
			endif
		else
			if alltrim(QUERY->ZP_GRUSA) == "101"
					TRB1->IDUSA		:= "101"
					TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
			elseif alltrim(QUERY->ZP_GRUSA) == "102"
					TRB1->IDUSA		:= "101"
					TRB1->DESCUSA	:= "TINTAS / REVESTIMENTOS"
			elseif alltrim(QUERY->ZP_GRUSA) == "103"
					TRB1->IDUSA		:= "103"
					TRB1->DESCUSA	:= "BARREIRAS E DEFLETORES"
			elseif alltrim(QUERY->ZP_GRUSA) == "104"
					TRB1->IDUSA		:= "104"
					TRB1->DESCUSA	:= "UNIDADE(S) DE ACIONAMENTO"
			elseif alltrim(QUERY->ZP_GRUSA) == "105"
					TRB1->IDUSA		:= "105"
					TRB1->DESCUSA	:= "PARAFUSOS E ELELEMENTOS DE FIXACAO"
			elseif alltrim(QUERY->ZP_GRUSA) == "106"
					TRB1->IDUSA		:= "106"
					TRB1->DESCUSA	:= "CONTROLES ELETRICOS"
			elseif alltrim(QUERY->ZP_GRUSA) == "107"
					TRB1->IDUSA		:= "107"
					TRB1->DESCUSA	:= "INSTRUMENTACAO"
			elseif alltrim(QUERY->ZP_GRUSA) == "108"
					TRB1->IDUSA		:= "108"
					TRB1->DESCUSA	:= "OUTRAS AQUISICOES"
			elseif alltrim(QUERY->ZP_GRUSA) == "109"
					TRB1->IDUSA		:= "109"
					TRB1->DESCUSA	:= "FRETE INTERNO"
			elseif alltrim(QUERY->ZP_GRUSA) == "201"
					TRB1->IDUSA		:= "201"
					TRB1->DESCUSA	:= "SUBMITTALS"
			elseif alltrim(QUERY->ZP_GRUSA) == "202"
					TRB1->IDUSA		:= "202"
					TRB1->DESCUSA	:= "PROJETO / LAYOUT / CALCULOS"
			elseif alltrim(QUERY->ZP_GRUSA) == "204"
					TRB1->IDUSA		:= "204"
					TRB1->DESCUSA	:= "DETALHAMENTO"
			elseif alltrim(QUERY->ZP_GRUSA) == "205"
					TRB1->IDUSA		:= "205"
					TRB1->DESCUSA	:= "VERIFICAO / APROVACAO"
			elseif alltrim(QUERY->ZP_GRUSA) == "206"
					TRB1->IDUSA		:= "206"
					TRB1->DESCUSA	:= "ENGENHARIA DE ACIONAMENTO"
			elseif alltrim(QUERY->ZP_GRUSA) == "207"
					TRB1->IDUSA		:= "207"
					TRB1->DESCUSA	:= "ENGENHARIA ELETRICA"
			elseif alltrim(QUERY->ZP_GRUSA) == "210"
					TRB1->IDUSA		:= "210"
					TRB1->DESCUSA	:= "GERENCIAMENTO DE PROJETOS"
			elseif alltrim(QUERY->ZP_GRUSA) == "211"
					TRB1->IDUSA		:= "211"
					TRB1->DESCUSA	:= "COMPRAS / EXPEDICAO"
			elseif alltrim(QUERY->ZP_GRUSA) == "212"
					TRB1->IDUSA		:= "212"
					TRB1->DESCUSA	:= "MONTAGEM ELETRICA"
			elseif alltrim(QUERY->ZP_GRUSA) == "213"
					TRB1->IDUSA		:= "213"
					TRB1->DESCUSA	:= "OUTRA MONTAGEM / TESTE"
			elseif alltrim(QUERY->ZP_GRUSA) == "217"
					TRB1->IDUSA		:= "217"
					TRB1->DESCUSA	:= "INSPECAO"
			elseif alltrim(QUERY->ZP_GRUSA) == "218"
					TRB1->IDUSA		:= "218"
					TRB1->DESCUSA	:= "SERVICO / TESTE DE CAMPO"
			elseif alltrim(QUERY->ZP_GRUSA) == "220"
					TRB1->IDUSA		:= "220"
					TRB1->DESCUSA	:= "OUTRO, O&M, COPIA, EMBARQUE"
			elseif alltrim(QUERY->ZP_GRUSA) == "221"
					TRB1->IDUSA		:= "221"
					TRB1->DESCUSA	:= "TESTES / MODIFICACOES ELETRICAS"
			elseif alltrim(QUERY->ZP_GRUSA) == "222"
					TRB1->IDUSA		:= "222"
					TRB1->DESCUSA	:= "PROGRAMACAO PLC"
			elseif alltrim(QUERY->ZP_GRUSA) == "301"
					TRB1->IDUSA		:= "301"
					TRB1->DESCUSA	:= "FRETE, EMBALAGEM, AFINS"
			elseif alltrim(QUERY->ZP_GRUSA) == "501"
					TRB1->IDUSA		:= "501"
					TRB1->DESCUSA	:= "SERVICOS EXTERNOS"
			elseif alltrim(QUERY->ZP_GRUSA) == "601"
					TRB1->IDUSA		:= "601"
					TRB1->DESCUSA	:= "DESPESAS DE INSPECAO DE FABRICA"
			elseif alltrim(QUERY->ZP_GRUSA) == "701"
					TRB1->IDUSA		:= "701"
					TRB1->DESCUSA	:= "DESPESAS DE SERVICO DE CAMPO / SUPERVISAO"		
			endif
			
		endif
		
		cIDSZP := alltrim(QUERY->ZP_IDVDSUB)
		cDescSZP := alltrim(QUERY->ZP_DESCRI)
		
		dbSelectArea("SZG")
		SZG->( dbSetOrder(1))
		SZG->(dbgotop())
		
		//msginfo (cValtoChar(nQTDSZD) + " " + cIDSZO )
		cCondicao:= "ALLTRIM(SZG->ZG_ITEMIC) == _cItemConta  "
		bFiltraBrw := {|| FilBrowse("SZG",@aInd,@cCondicao) }
		Eval(bFiltraBrw)
		
		While SZG->(!eof())	
		
			if cIDSZP == alltrim(SZG->ZG_IDVDSUB)
				nQTSZG := SZG->ZG_QUANT //Posicione("SZD",1,xFilial("SZD")+cIDSZO,"ZD_QUANTR") 
			
				cDescSZG := ALLTRIM(SZG->ZG_DESCRI) + " <-> " + cDescSZP  //alltrim(Posicione("SZD",1,xFilial("SZD") + cIDSZO,"ZD_DESCRI")) 
				TRB1->UNIDADE		:= QUERY->ZP_UM
				exit
			endif
			SZG->(dbskip())
		
		enddo
		TRB1->HISTORICO		:= cDescSZG 
		TRB1->PRODUTO		:= ""
		
		TRB1->QUANTIDADE	:= nQTSZG
		TRB1->VALOR			:= (QUERY->ZP_TOTAL * nQTSZG)

		TRB1->PRODUTO		:= ""
		//TRB1->QUANTIDADE	:= QUERY->ZP_QUANT
		//TRB1->UNIDADE		:= QUERY->ZP_UM
		//TRB1->HISTORICO		:= QUERY->ZP_DESCRI
		//TRB1->VALOR			:= (QUERY->ZP_TOTAL*nQTDSZG) //*nQTDSZF

		TRB1->ORIGEM		:= "VD"
		TRB1->ITEMCONTA 	:= QUERY->ZP_ITEMIC
		TRB1->CAMPO		 	:= "VLRVD"

		MsUnlock()

	endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())
SZF->(dbclosearea())
SZG->(dbclosearea())
SZP->(dbclosearea())
return


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Processa Plajemento							              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function PLANEJ01()

local _cQuery := ""
Local _cFilSZD := xFilial("SZD")

Local cIDSZC := ""
Local cIDSZD := ""
Local cIDSZO := ""

Local nQTDSZC := 0
Local nQTDSZD := 0
Local nQTDSZO := 0

local cFor := "ALLTRIM(QUERY->ZD_ITEMIC) == _cItemConta"

dbSelectArea("SZC")
SZC->( dbSetOrder(1)) 
SZC->(dbgotop())

dbSelectArea("SZD")
SZD->( dbSetOrder(1))
SZD->(dbgotop())
 

SZD->(dbsetorder(2))

ChkFile("SZD",.F.,"QUERY")
IndRegua("QUERY",CriaTrab(NIL,.F.),"ZD_ITEMIC",,cFor,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())

while QUERY->(!eof())

	if ALLTRIM(QUERY->ZD_ITEMIC) == alltrim(_cItemConta)

		RecLock("TRB1",.T.)
		
		//MsProcTxt("Processando registro: "+alltrim(QUERY->ZD_IDPLSUB))
		//ProcessMessage()

		TRB1->TIPO		:= "N2"
		TRB1->NUMERO	:= QUERY->ZD_IDPLSUB
		TRB1->ID		:= "MPR"
		TRB1->DESCRICAO	:= "MATERIA PRIMA"

		if alltrim(QUERY->ZD_GRUPO) == "MPR"
			TRB1->ID		:= "MPR"
			TRB1->DESCRICAO	:= "MATERIA PRIMA"
		elseif alltrim(QUERY->ZD_GRUPO) == "FAB"
			TRB1->ID		:= "FAB"
			TRB1->DESCRICAO	:= "FABRICACAO"
		elseif alltrim(QUERY->ZD_GRUPO) == "COM"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(QUERY->ZD_GRUPO) == "SRV"
			TRB1->ID		:= "SRV"
			TRB1->DESCRICAO	:= "SERVICOS"
		elseif alltrim(QUERY->ZG_GRUPO) == "ESL"
			TRB1->ID		:= "ESL"
			TRB1->DESCRICAO	:= "ENGENHARIA SLC"
		elseif alltrim(QUERY->ZD_GRUPO) == "EBR"
			TRB1->ID		:= "EBR"
			TRB1->DESCRICAO	:= "ENGENHARIA BR"
		elseif alltrim(QUERY->ZD_GRUPO) == "CTR"
			TRB1->ID		:= "CTR"
			TRB1->DESCRICAO	:= "CONTRATOS"
		elseif alltrim(QUERY->ZD_GRUPO) == "IDL"
			TRB1->ID		:= "IDL"
			TRB1->DESCRICAO	:= "INSPECAO / DILIGENCIAMENTO"
		/*elseif alltrim(QUERY->ZD_GRUPO) == "FIN"
			TRB1->ID		:= "FIN"
			TRB1->DESCRICAO	:= "FINANCEIRO"*/
		elseif alltrim(QUERY->ZD_GRUPO) == "CMS"
			TRB1->ID		:= "CMS"
			TRB1->DESCRICAO	:= "COMISSAO"
		elseif alltrim(QUERY->ZD_GRUPO) == "RDV"
			TRB1->ID		:= "RDV"
			TRB1->DESCRICAO	:= "RELATORIO DE VIAGEM"
		elseif alltrim(QUERY->ZD_GRUPO) == "FRT"
			TRB1->ID		:= "FRT"
			TRB1->DESCRICAO	:= "FRETE"
		elseif alltrim(QUERY->ZD_GRUPO) == "CDV"
			TRB1->ID		:= "CDV"
			TRB1->DESCRICAO	:= "CUSTO DIVERSOS"
		endif
		
		cIDSZP := QUERY->ZP_IDVDSUB
		while SZG->(!eof()) //.AND. SZG->ZG_IDVDSUB <> ALLTRIM(cIDSZP) .AND. SZG->ZG_ITEMIC <> alltrim(_cItemConta)
			
			if ALLTRIM(SZG->ZG_IDVDSUB) == ALLTRIM(cIDSZP) .AND. ALLTRIM(SZG->ZG_ITEMIC) == alltrim(_cItemConta)
				nQTDSZG := SZG->ZG_QUANT
				cIDSZG := SZG->ZG_IDVEND
				
				while SZF->(!eof()) //.AND. SZF->ZF_IDVEND <> ALLTRIM(cIDSZG) .AND. SZF->ZF_ITEMIC <> alltrim(_cItemConta)
					
					if ALLTRIM(SZF->ZF_IDVEND) == ALLTRIM(cIDSZG) .AND. ALLTRIM(SZF->ZF_ITEMIC) == alltrim(_cItemConta)
						nQTDSZF := SZF->ZF_QUANT
					endif
					SZF->(dbSkip())
				enddo
				
			endif
			SZG->(dbSkip())
		enddo

		TRB1->PRODUTO		:= ""
		TRB1->QUANTIDADE	:= QUERY->ZD_QUANTR
		TRB1->UNIDADE		:= QUERY->ZD_UMR
		TRB1->HISTORICO		:= QUERY->ZD_DESCRI
		TRB1->VALOR			:= QUERY->ZD_TOTALR

		TRB1->ORIGEM		:= "PL"
		TRB1->ITEMCONTA 	:= QUERY->ZD_ITEMIC
		TRB1->CAMPO		 	:= "VLRPLN"

		MsUnlock()

	endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Processa Plajemento							              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function PLANEJ02()

local _cQuery := ""
Local _cFilSZO := xFilial("SZU")

Local cIDSZC := ""
Local cIDSZD := ""
Local cIDSZO := ""
Local cIDSZU := ""

Local nQTDSZC := 0
Local nQTDSZD := 0
Local nQTDSZO := 0
Local nQTDSZU := 0

Local nQTSZD := 0
Local nQTSZO := 0
Local nQTSZU := 0

Local cDescSZO := ""
Local cDescSZD := ""
//Local cDescSZO := ""
Local cDescSZU := ""

Local aInd:={}
 Local cCondicao
 Local bFiltraBrw
 
 Local aInd2:={}
 Local cCondicao2
 Local bFiltraBrw2
 
 Local aInd3:={}
 Local cCondicao3
 Local bFiltraBrw3
 
 local cFor := "ALLTRIM(QUERY->ZU_ITEMIC) == _cItemConta"

dbSelectArea("SZC")
SZC->( dbSetOrder(1)) 
SZC->(dbgotop())

dbSelectArea("SZD")
SZD->( dbSetOrder(1))
SZD->(dbgotop())
 
dbSelectArea("SZO")
SZO->(dbsetorder(3))
SZO->(dbgotop())

dbSelectArea("SZU")
SZU->(dbsetorder(2))
SZU->(dbgotop())

ChkFile("SZU",.F.,"QUERY")
IndRegua("QUERY",CriaTrab(NIL,.F.),"ZU_ITEMIC",,cFor,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())

while QUERY->(!eof())

	if ALLTRIM(QUERY->ZU_ITEMIC) == alltrim(_cItemConta)

		RecLock("TRB1",.T.)
		
		//MsProcTxt("Processando registro: "+alltrim(QUERY->ZU_IDPLSB2))
		//ProcessMessage()

		TRB1->TIPO		:= "N4"
		//TRB1->NUMERO	:= QUERY->ZO_IDPLSB2
		TRB1->NUMERO	:= QUERY->ZU_IDPLSB2
		TRB1->ID		:= "MPR"
		TRB1->DESCRICAO	:= "MATERIA PRIMA"
		TRB1->IDUSA		:= "108"
		TRB1->DESCUSA	:= "OUTRAS AQUISICOES"

		if empty(alltrim(QUERY->ZU_GRUSA))
			if alltrim(QUERY->ZU_GRUPO) == "MPR"
				TRB1->ID		:= "MPR"
				TRB1->DESCRICAO	:= "MATERIA PRIMA"
				TRB1->IDUSA		:= "101"
				TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
			elseif alltrim(QUERY->ZU_GRUPO) == "FAB"
				TRB1->ID		:= "FAB"
				TRB1->DESCRICAO	:= "FABRICACAO"
				TRB1->IDUSA		:= "101"
				TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
			elseif alltrim(QUERY->ZU_GRUPO) == "COM"
				TRB1->ID		:= "COM"
				TRB1->DESCRICAO	:= "COMERCIAIS"
				TRB1->IDUSA		:= "101"
				TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
			elseif alltrim(QUERY->ZU_GRUPO) == "SRV"
				TRB1->ID		:= "SRV"
				TRB1->DESCRICAO	:= "SERVICOS"
				TRB1->IDUSA		:= "501"
				TRB1->DESCUSA	:= "SERVICOS EXTERNOS"
			elseif alltrim(QUERY->ZU_GRUPO) == "ESL"
				TRB1->ID		:= "ESL"
				TRB1->DESCRICAO	:= "ENGENHARIA SLC"
				TRB1->IDUSA		:= "201"
				TRB1->DESCUSA	:= "SUBMITTALS"
			elseif alltrim(QUERY->ZU_GRUPO) == "EBR"
				TRB1->ID		:= "EBR"
				TRB1->DESCRICAO	:= "ENGENHARIA BR"
				TRB1->IDUSA		:= "201"
				TRB1->DESCUSA	:= "SUBMITTALS"
			elseif alltrim(QUERY->ZU_GRUPO) == "LAB"
				TRB1->ID		:= "LAB"
				TRB1->DESCRICAO	:= "LABORATORIO"
				TRB1->IDUSA		:= "213"
				TRB1->DESCUSA	:= "OUTRA MONTAGEM / TESTE"
			elseif alltrim(QUERY->ZU_GRUPO) == "CTR"
				TRB1->ID		:= "CTR"
				TRB1->DESCRICAO	:= "CONTRATOS"
				TRB1->IDUSA		:= "210"
				TRB1->DESCUSA	:= "GERENCIAMENTO DE PROJETOS"
			elseif alltrim(QUERY->ZU_GRUPO) == "IDL"
				TRB1->ID		:= "IDL"
				TRB1->DESCRICAO	:= "INSPECAO / DILIGENCIAMENTO"
				TRB1->IDUSA		:= "217"
				TRB1->DESCUSA	:= "INSPECAO"
			/*elseif alltrim(QUERY->ZU_GRUPO) == "FIN"
				TRB1->ID		:= "FIN"
				TRB1->DESCRICAO	:= "FINANCEIRO"*/
			elseif alltrim(QUERY->ZU_GRUPO) == "CMS"
				TRB1->ID		:= "CMS"
				TRB1->DESCRICAO	:= "COMISSAO"
				TRB1->IDUSA		:= "501"
				TRB1->DESCUSA	:= "SERVICOS EXTERNOS"
			elseif alltrim(QUERY->ZU_GRUPO) == "RDV"
				TRB1->ID		:= "RDV"
				TRB1->DESCRICAO	:= "RELATORIO DE VIAGEM"
				TRB1->IDUSA		:= "701"
				TRB1->DESCUSA	:= "DESPESAS DE INSPECAO DE FABRICA"
			elseif alltrim(QUERY->ZU_GRUPO) == "FRT"
				TRB1->ID		:= "FRT"
				TRB1->DESCRICAO	:= "FRETE"
				TRB1->IDUSA		:= "301"
				TRB1->DESCUSA	:= "FRETE, EMBALAGEM, AFINS"
			elseif alltrim(QUERY->ZU_GRUPO) == "CDV"
				TRB1->ID		:= "CDV"
				TRB1->DESCRICAO	:= "CUSTO DIVERSOS"
				TRB1->IDUSA		:= "108"
				TRB1->DESCUSA	:= "OUTRAS AQUISICOES"
			endif
		else
			if alltrim(QUERY->ZU_GRUSA) == "101"
					TRB1->IDUSA		:= "101"
					TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
			elseif alltrim(QUERY->ZU_GRUSA) == "102"
					TRB1->IDUSA		:= "101"
					TRB1->DESCUSA	:= "TINTAS / REVESTIMENTOS"
			elseif alltrim(QUERY->ZU_GRUSA) == "103"
					TRB1->IDUSA		:= "103"
					TRB1->DESCUSA	:= "BARREIRAS E DEFLETORES"
			elseif alltrim(QUERY->ZU_GRUSA) == "104"
					TRB1->IDUSA		:= "104"
					TRB1->DESCUSA	:= "UNIDADE(S) DE ACIONAMENTO"
			elseif alltrim(QUERY->ZU_GRUSA) == "105"
					TRB1->IDUSA		:= "105"
					TRB1->DESCUSA	:= "PARAFUSOS E ELELEMENTOS DE FIXACAO"
			elseif alltrim(QUERY->ZU_GRUSA) == "106"
					TRB1->IDUSA		:= "106"
					TRB1->DESCUSA	:= "CONTROLES ELETRICOS"
			elseif alltrim(QUERY->ZU_GRUSA) == "107"
					TRB1->IDUSA		:= "107"
					TRB1->DESCUSA	:= "INSTRUMENTACAO"
			elseif alltrim(QUERY->ZU_GRUSA) == "108"
					TRB1->IDUSA		:= "108"
					TRB1->DESCUSA	:= "OUTRAS AQUISICOES"
			elseif alltrim(QUERY->ZU_GRUSA) == "109"
					TRB1->IDUSA		:= "109"
					TRB1->DESCUSA	:= "FRETE INTERNO"
			elseif alltrim(QUERY->ZU_GRUSA) == "201"
					TRB1->IDUSA		:= "201"
					TRB1->DESCUSA	:= "SUBMITTALS"
			elseif alltrim(QUERY->ZU_GRUSA) == "202"
					TRB1->IDUSA		:= "202"
					TRB1->DESCUSA	:= "PROJETO / LAYOUT / CALCULOS"
			elseif alltrim(QUERY->ZU_GRUSA) == "204"
					TRB1->IDUSA		:= "204"
					TRB1->DESCUSA	:= "DETALHAMENTO"
			elseif alltrim(QUERY->ZU_GRUSA) == "205"
					TRB1->IDUSA		:= "205"
					TRB1->DESCUSA	:= "VERIFICAO / APROVACAO"
			elseif alltrim(QUERY->ZU_GRUSA) == "206"
					TRB1->IDUSA		:= "206"
					TRB1->DESCUSA	:= "ENGENHARIA DE ACIONAMENTO"
			elseif alltrim(QUERY->ZU_GRUSA) == "207"
					TRB1->IDUSA		:= "207"
					TRB1->DESCUSA	:= "ENGENHARIA ELETRICA"
			elseif alltrim(QUERY->ZU_GRUSA) == "210"
					TRB1->IDUSA		:= "210"
					TRB1->DESCUSA	:= "GERENCIAMENTO DE PROJETOS"
			elseif alltrim(QUERY->ZU_GRUSA) == "211"
					TRB1->IDUSA		:= "211"
					TRB1->DESCUSA	:= "COMPRAS / EXPEDICAO"
			elseif alltrim(QUERY->ZU_GRUSA) == "212"
					TRB1->IDUSA		:= "212"
					TRB1->DESCUSA	:= "MONTAGEM ELETRICA"
			elseif alltrim(QUERY->ZU_GRUSA) == "213"
					TRB1->IDUSA		:= "213"
					TRB1->DESCUSA	:= "OUTRA MONTAGEM / TESTE"
			elseif alltrim(QUERY->ZU_GRUSA) == "217"
					TRB1->IDUSA		:= "217"
					TRB1->DESCUSA	:= "INSPECAO"
			elseif alltrim(QUERY->ZU_GRUSA) == "218"
					TRB1->IDUSA		:= "218"
					TRB1->DESCUSA	:= "SERVICO / TESTE DE CAMPO"
			elseif alltrim(QUERY->ZU_GRUSA) == "220"
					TRB1->IDUSA		:= "220"
					TRB1->DESCUSA	:= "OUTRO, O&M, COPIA, EMBARQUE"
			elseif alltrim(QUERY->ZU_GRUSA) == "221"
					TRB1->IDUSA		:= "221"
					TRB1->DESCUSA	:= "TESTES / MODIFICACOES ELETRICAS"
			elseif alltrim(QUERY->ZU_GRUSA) == "222"
					TRB1->IDUSA		:= "222"
					TRB1->DESCUSA	:= "PROGRAMACAO PLC"
			elseif alltrim(QUERY->ZU_GRUSA) == "301"
					TRB1->IDUSA		:= "301"
					TRB1->DESCUSA	:= "FRETE, EMBALAGEM, AFINS"
			elseif alltrim(QUERY->ZU_GRUSA) == "501"
					TRB1->IDUSA		:= "501"
					TRB1->DESCUSA	:= "SERVICOS EXTERNOS"
			elseif alltrim(QUERY->ZU_GRUSA) == "601"
					TRB1->IDUSA		:= "601"
					TRB1->DESCUSA	:= "DESPESAS DE INSPECAO DE FABRICA"
			elseif alltrim(QUERY->ZU_GRUSA) == "701"
					TRB1->IDUSA		:= "701"
					TRB1->DESCUSA	:= "DESPESAS DE SERVICO DE CAMPO / SUPERVISAO"		
			endif
			
		endif
				
		cIDSZU 		:= alltrim(QUERY->ZU_IDPLSB2)
		cDescSZU	:= alltrim(QUERY->ZU_DESCRI)
		
		dbSelectArea("SZO")
		SZO->( dbSetOrder(3))
		SZO->(dbgotop())
		
		cCondicao2:= "ALLTRIM(SZO->ZO_ITEMIC) == _cItemConta  "
		bFiltraBrw2 := {|| FilBrowse("SZO",@aInd2,@cCondicao2) }
		Eval(bFiltraBrw2)
		
		While SZO->(!eof())	
			if cIDSZU == alltrim(SZO->ZO_IDPLSB2)
				nQTSZO 		:= SZO->ZO_QUANTR
				cIDSZO		:= alltrim(SZO->ZO_IDPLSUB)
				cDescSZO 	:= "(" + cValtoChar(nQTSZO) + ") " + ALLTRIM(SZO->ZO_DESCRI)  + " <-> " + cDescSZU
				exit 
			endif
			SZO->(dbskip())
		enddo
		
		//*********************
		
		cCondicao3:= "ALLTRIM(SZD->ZD_ITEMIC) == _cItemConta  "
		bFiltraBrw3 := {|| FilBrowse("SZD",@aInd3,@cCondicao3) }
		Eval(bFiltraBrw3)
		
		//msginfo (cValtoChar(nQTSZO) + " " + cIDSZO )
		dbSelectArea("SZD")
		SZD->( dbSetOrder(1))
		SZD->(dbgotop())
		While SZD->(!eof())
			if cIDSZO == alltrim(SZD->ZD_IDPLSUB)
				nQTSZD 		:= SZD->ZD_QUANTR
				cDescSZD 	:= "(" + cValtoChar(nQTSZD) + ") " + ALLTRIM(SZD->ZD_DESCRI)  + " <-> " + cDescSZO  //+ " <-> " + cDescSZU
				exit
			endif
			SZD->(dbskip())
		enddo
		
		TRB1->HISTORICO		:= cDescSZD 
		TRB1->PRODUTO		:= ""
		
		TRB1->QUANTIDADE	:= nQTSZD
		TRB1->VALOR			:= (QUERY->ZU_TOTALR * nQTSZO) * nQTSZD

		TRB1->ORIGEM		:= "PL"
		TRB1->ITEMCONTA 	:= QUERY->ZU_ITEMIC
		TRB1->CAMPO		 	:= "VLRPLN"

		MsUnlock()

	endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())
SZC->(dbclosearea())
SZD->(dbclosearea())
SZO->(dbclosearea())
SZU->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Processa Plajemento							              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function PLANEJ03()

local _cQuery := ""
Local _cFilSZO := xFilial("SZO")

Local cIDSZC := ""
Local cIDSZD := ""
Local cIDSZO := ""
Local cIDSZU := ""

Local nQTDSZC := 0
Local nQTDSZD := 0
Local nQTDSZO := 0
Local nQTDSZU := 0

Local nQTSZD := 0
Local nQTSZO := 0
Local nQTSZU := 0

Local cDescSZO := ""
Local cDescSZD := ""
//Local cDescSZO := ""
Local cDescSZU := ""

Local aInd:={}
 Local cCondicao
 Local bFiltraBrw

 local cFor := "ALLTRIM(QUERY->ZO_ITEMIC) == _cItemConta"

dbSelectArea("SZC")
SZC->( dbSetOrder(1)) 
SZC->(dbgotop())

dbSelectArea("SZD")
SZD->( dbSetOrder(1))
SZD->(dbgotop())
 
dbSelectArea("SZO")
SZO->(dbsetorder(3))
SZO->(dbgotop())

dbSelectArea("SZU")
SZU->(dbsetorder(1))
SZU->(dbgotop())



ChkFile("SZO",.F.,"QUERY")
IndRegua("QUERY",CriaTrab(NIL,.F.),"ZO_ITEMIC",,cFor,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())

while QUERY->(!eof())

	if ALLTRIM(QUERY->ZO_ITEMIC) == alltrim(_cItemConta)

		RecLock("TRB1",.T.)
		
		//MsProcTxt("Processando registro: "+alltrim(QUERY->ZO_IDPLSB2))
		//ProcessMessage()

		TRB1->TIPO		:= "N3"
		TRB1->NUMERO	:= QUERY->ZO_IDPLSB2
		TRB1->ID		:= "MPR"
		TRB1->DESCRICAO	:= "MATERIA PRIMA"
		TRB1->IDUSA		:= "108"
		TRB1->DESCUSA	:= "OUTRAS AQUISICOES"

		if empty(alltrim(QUERY->ZO_GRUSA))
			if alltrim(QUERY->ZO_GRUPO) == "MPR"
				TRB1->ID		:= "MPR"
				TRB1->DESCRICAO	:= "MATERIA PRIMA"
				TRB1->IDUSA		:= "101"
				TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
			elseif alltrim(QUERY->ZO_GRUPO) == "FAB"
				TRB1->ID		:= "FAB"
				TRB1->DESCRICAO	:= "FABRICACAO"
				TRB1->IDUSA		:= "101"
				TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
			elseif alltrim(QUERY->ZO_GRUPO) == "COM"
				TRB1->ID		:= "COM"
				TRB1->DESCRICAO	:= "COMERCIAIS"
				TRB1->IDUSA		:= "101"
				TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
			elseif alltrim(QUERY->ZO_GRUPO) == "SRV"
				TRB1->ID		:= "SRV"
				TRB1->DESCRICAO	:= "SERVICOS"
				TRB1->IDUSA		:= "501"
				TRB1->DESCUSA	:= "SERVICOS EXTERNOS"
			elseif alltrim(QUERY->ZO_GRUPO) == "ESL"
				TRB1->ID		:= "ESL"
				TRB1->DESCRICAO	:= "ENGENHARIA SLC"
				TRB1->IDUSA		:= "201"
				TRB1->DESCUSA	:= "SUBMITTALS"
			elseif alltrim(QUERY->ZO_GRUPO) == "EBR"
				TRB1->ID		:= "EBR"
				TRB1->DESCRICAO	:= "ENGENHARIA BR"
				TRB1->IDUSA		:= "201"
				TRB1->DESCUSA	:= "SUBMITTALS"
			elseif alltrim(QUERY->ZO_GRUPO) == "LAB"
				TRB1->ID		:= "LAB"
				TRB1->DESCRICAO	:= "LABORATORIO"
				TRB1->IDUSA		:= "213"
				TRB1->DESCUSA	:= "OUTRA MONTAGEM / TESTE"
			elseif alltrim(QUERY->ZO_GRUPO) == "CTR"
				TRB1->ID		:= "CTR"
				TRB1->DESCRICAO	:= "CONTRATOS"
				TRB1->IDUSA		:= "210"
				TRB1->DESCUSA	:= "GERENCIAMENTO DE PROJETOS"
			elseif alltrim(QUERY->ZO_GRUPO) == "IDL"
				TRB1->ID		:= "IDL"
				TRB1->DESCRICAO	:= "INSPECAO / DILIGENCIAMENTO"
				TRB1->IDUSA		:= "217"
				TRB1->DESCUSA	:= "INSPECAO"
			/*elseif alltrim(QUERY->ZU_GRUPO) == "FIN"
				TRB1->ID		:= "FIN"
				TRB1->DESCRICAO	:= "FINANCEIRO"*/
			elseif alltrim(QUERY->ZO_GRUPO) == "CMS"
				TRB1->ID		:= "CMS"
				TRB1->DESCRICAO	:= "COMISSAO"
				TRB1->IDUSA		:= "501"
				TRB1->DESCUSA	:= "SERVICOS EXTERNOS"
			elseif alltrim(QUERY->ZO_GRUPO) == "RDV"
				TRB1->ID		:= "RDV"
				TRB1->DESCRICAO	:= "RELATORIO DE VIAGEM"
				TRB1->IDUSA		:= "701"
				TRB1->DESCUSA	:= "DESPESAS DE INSPECAO DE FABRICA"
			elseif alltrim(QUERY->ZO_GRUPO) == "FRT"
				TRB1->ID		:= "FRT"
				TRB1->DESCRICAO	:= "FRETE"
				TRB1->IDUSA		:= "301"
				TRB1->DESCUSA	:= "FRETE, EMBALAGEM, AFINS"
			elseif alltrim(QUERY->ZO_GRUPO) == "CDV"
				TRB1->ID		:= "CDV"
				TRB1->DESCRICAO	:= "CUSTO DIVERSOS"
				TRB1->IDUSA		:= "108"
				TRB1->DESCUSA	:= "OUTRAS AQUISICOES"
			endif
		else
			if alltrim(QUERY->ZO_GRUSA) == "101"
					TRB1->IDUSA		:= "101"
					TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
			elseif alltrim(QUERY->ZO_GRUSA) == "102"
					TRB1->IDUSA		:= "101"
					TRB1->DESCUSA	:= "TINTAS / REVESTIMENTOS"
			elseif alltrim(QUERY->ZO_GRUSA) == "103"
					TRB1->IDUSA		:= "103"
					TRB1->DESCUSA	:= "BARREIRAS E DEFLETORES"
			elseif alltrim(QUERY->ZO_GRUSA) == "104"
					TRB1->IDUSA		:= "104"
					TRB1->DESCUSA	:= "UNIDADE(S) DE ACIONAMENTO"
			elseif alltrim(QUERY->ZO_GRUSA) == "105"
					TRB1->IDUSA		:= "105"
					TRB1->DESCUSA	:= "PARAFUSOS E ELELEMENTOS DE FIXACAO"
			elseif alltrim(QUERY->ZO_GRUSA) == "106"
					TRB1->IDUSA		:= "106"
					TRB1->DESCUSA	:= "CONTROLES ELETRICOS"
			elseif alltrim(QUERY->ZO_GRUSA) == "107"
					TRB1->IDUSA		:= "107"
					TRB1->DESCUSA	:= "INSTRUMENTACAO"
			elseif alltrim(QUERY->ZO_GRUSA) == "108"
					TRB1->IDUSA		:= "108"
					TRB1->DESCUSA	:= "OUTRAS AQUISICOES"
			elseif alltrim(QUERY->ZO_GRUSA) == "109"
					TRB1->IDUSA		:= "109"
					TRB1->DESCUSA	:= "FRETE INTERNO"
			elseif alltrim(QUERY->ZO_GRUSA) == "201"
					TRB1->IDUSA		:= "201"
					TRB1->DESCUSA	:= "SUBMITTALS"
			elseif alltrim(QUERY->ZO_GRUSA) == "202"
					TRB1->IDUSA		:= "202"
					TRB1->DESCUSA	:= "PROJETO / LAYOUT / CALCULOS"
			elseif alltrim(QUERY->ZO_GRUSA) == "204"
					TRB1->IDUSA		:= "204"
					TRB1->DESCUSA	:= "DETALHAMENTO"
			elseif alltrim(QUERY->ZO_GRUSA) == "205"
					TRB1->IDUSA		:= "205"
					TRB1->DESCUSA	:= "VERIFICAO / APROVACAO"
			elseif alltrim(QUERY->ZO_GRUSA) == "206"
					TRB1->IDUSA		:= "206"
					TRB1->DESCUSA	:= "ENGENHARIA DE ACIONAMENTO"
			elseif alltrim(QUERY->ZO_GRUSA) == "207"
					TRB1->IDUSA		:= "207"
					TRB1->DESCUSA	:= "ENGENHARIA ELETRICA"
			elseif alltrim(QUERY->ZO_GRUSA) == "210"
					TRB1->IDUSA		:= "210"
					TRB1->DESCUSA	:= "GERENCIAMENTO DE PROJETOS"
			elseif alltrim(QUERY->ZO_GRUSA) == "211"
					TRB1->IDUSA		:= "211"
					TRB1->DESCUSA	:= "COMPRAS / EXPEDICAO"
			elseif alltrim(QUERY->ZO_GRUSA) == "212"
					TRB1->IDUSA		:= "212"
					TRB1->DESCUSA	:= "MONTAGEM ELETRICA"
			elseif alltrim(QUERY->ZO_GRUSA) == "213"
					TRB1->IDUSA		:= "213"
					TRB1->DESCUSA	:= "OUTRA MONTAGEM / TESTE"
			elseif alltrim(QUERY->ZO_GRUSA) == "217"
					TRB1->IDUSA		:= "217"
					TRB1->DESCUSA	:= "INSPECAO"
			elseif alltrim(QUERY->ZO_GRUSA) == "218"
					TRB1->IDUSA		:= "218"
					TRB1->DESCUSA	:= "SERVICO / TESTE DE CAMPO"
			elseif alltrim(QUERY->ZO_GRUSA) == "220"
					TRB1->IDUSA		:= "220"
					TRB1->DESCUSA	:= "OUTRO, O&M, COPIA, EMBARQUE"
			elseif alltrim(QUERY->ZO_GRUSA) == "221"
					TRB1->IDUSA		:= "221"
					TRB1->DESCUSA	:= "TESTES / MODIFICACOES ELETRICAS"
			elseif alltrim(QUERY->ZO_GRUSA) == "222"
					TRB1->IDUSA		:= "222"
					TRB1->DESCUSA	:= "PROGRAMACAO PLC"
			elseif alltrim(QUERY->ZO_GRUSA) == "301"
					TRB1->IDUSA		:= "301"
					TRB1->DESCUSA	:= "FRETE, EMBALAGEM, AFINS"
			elseif alltrim(QUERY->ZO_GRUSA) == "501"
					TRB1->IDUSA		:= "501"
					TRB1->DESCUSA	:= "SERVICOS EXTERNOS"
			elseif alltrim(QUERY->ZO_GRUSA) == "601"
					TRB1->IDUSA		:= "601"
					TRB1->DESCUSA	:= "DESPESAS DE INSPECAO DE FABRICA"
			elseif alltrim(QUERY->ZO_GRUSA) == "701"
					TRB1->IDUSA		:= "701"
					TRB1->DESCUSA	:= "DESPESAS DE SERVICO DE CAMPO / SUPERVISAO"		
			endif
			
		endif

		cIDSZO := alltrim(QUERY->ZO_IDPLSUB)
		cDescSZO := alltrim(QUERY->ZO_DESCRI)
		
		dbSelectArea("SZD")
		SZD->( dbSetOrder(1))
		SZD->(dbgotop())
		
		//msginfo (cValtoChar(nQTDSZD) + " " + cIDSZO )
		
		cCondicao:= "ALLTRIM(SZD->ZD_ITEMIC) == _cItemConta  "
		bFiltraBrw := {|| FilBrowse("SZD",@aInd,@cCondicao) }
		Eval(bFiltraBrw)
		
		While SZD->(!eof())	
		
			if cIDSZO == alltrim(SZD->ZD_IDPLSUB)
				nQTSZD := SZD->ZD_QUANTR //Posicione("SZD",1,xFilial("SZD")+cIDSZO,"ZD_QUANTR") 
			
				cDescSZD := ALLTRIM(SZD->ZD_DESCRI)  + " <-> " + cDescSZO  //alltrim(Posicione("SZD",1,xFilial("SZD") + cIDSZO,"ZD_DESCRI")) 
				TRB1->UNIDADE		:= QUERY->ZO_UMR
				
				exit
			endif
			SZD->(dbskip())
		
		enddo
		
		TRB1->HISTORICO		:= cDescSZD 
		TRB1->PRODUTO		:= ""
		
		TRB1->QUANTIDADE	:= nQTSZD
		TRB1->VALOR			:= (QUERY->ZO_TOTALR * nQTSZD) 

		TRB1->ORIGEM		:= "PL"
		TRB1->ITEMCONTA 	:= QUERY->ZO_ITEMIC
		TRB1->CAMPO		 	:= "VLRPLN"

		MsUnlock()
		
	endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())
SZC->(dbclosearea())
SZD->(dbclosearea())
SZO->(dbclosearea())
SZU->(dbclosearea())

return


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Processa Ordens de compra   			                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function PFIN01REAL()

local _cQuery := ""
Local _cFilSC7 := xFilial("SC7")
Local dData
Local nValor := 0
local dDataM2
local cGrProd	:= ""
local cGrUSA	:= ""
local cFor := "ALLTRIM(QUERY->C7_ITEMCTA) == _cItemConta"

SC7->(dbsetorder(23)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("SC7",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"C7_EMISSAO",,cFor,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())

//******************************
	dbSelectArea("SM2")
	//SM2->( dbSetOrder(1) )

	_cQuery := "SELECT CAST(M2_DATA AS DATE) AS 'TMP_DATA', M2_MOEDA1, M2_MOEDA2, M2_MOEDA3, M2_MOEDA4 FROM SM2010  WHERE  D_E_L_E_T_ <> '*' ORDER BY M2_DATA"

	IF Select("_cQuery") <> 0
		DbSelectArea("_cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery NEW ALIAS "QUERY2"

	dbSelectArea("QUERY2")
	QUERY2->(dbGoTop())

//*************************
while QUERY->(!eof())

	if QUERY->C7_ITEMCTA == _cItemConta .and. alltrim(QUERY->C7_ENCER) == ""

		RecLock("TRB1",.T.)
		//IncProc("Processando registro: "+alltrim(QUERY->C7_NUM))
		//MsProcTxt("Processando registro: "+alltrim(QUERY->C7_NUM))
		//ProcessMessage()
		
		TRB1->DATAMOV	:= QUERY->C7_EMISSAO
		TRB1->DATAENT	:= QUERY->C7_DATPRF
		TRB1->TIPO		:= alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO"))
		TRB1->NUMERO	:= QUERY->C7_NUM
		TRB1->ID		:= "MPR"
		TRB1->DESCRICAO	:= "MATERIA PRIMA"
		

		if alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) == "MO" ;
									.AND. ALLTRIM(QUERY->C7_FORNECE) == "000022"
			TRB1->IDUSA		:= "201"
			TRB1->DESCUSA	:= "SUBMITTALS"
			
		elseif ALLTRIM(QUERY->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->IDUSA		:= "301"
			TRB1->DESCUSA	:= "FRETE, EMBALAGEM, AFINS"

		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) $ ("SV/MP/SL/PV/PP/PI/PA/OI/MO/ME/MC/GG/AI/EM/GE/GC") ;
									.AND. SUBSTR(ALLTRIM(QUERY->C7_PRODUTO),1,2) == "22"  .AND. ALLTRIM(QUERY->C7_PRODUTO) $ ("22220018/2219005")							
			TRB1->IDUSA		:= "101"
			TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
		else
			cGrProd			:= POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_GRUPO")
			TRB1->IDUSA		:= POSICIONE("SBM",1,XFILIAL("SBM")+cGrProd,"BM_XIDUSA")
			
			cGrUSA			:= POSICIONE("SBM",1,XFILIAL("SBM")+cGrProd,"BM_XIDUSA")
			TRB1->DESCUSA	:= alltrim(POSICIONE("ZZL",1,XFILIAL("ZZL")+cGrUSA,"ZZL_DESC"))
		endif
		
		TRB1->GRPROD	:= POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_GRUPO")	
			
			
		if alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) == "MP" ;
										.AND. !SUBSTR(ALLTRIM(QUERY->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERY->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "MPR"
			TRB1->DESCRICAO	:= "MATERIA PRIMA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) == "AI" ;
										.AND. !SUBSTR(ALLTRIM(QUERY->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERY->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) == "EM" ;
										.AND. !SUBSTR(ALLTRIM(QUERY->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERY->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) == "GE" ;
										.AND. !SUBSTR(ALLTRIM(QUERY->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERY->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) == "GG" ;
										.AND. !SUBSTR(ALLTRIM(QUERY->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERY->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) == "MC" ;
										.AND. !SUBSTR(ALLTRIM(QUERY->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERY->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) == "ME" ;
										.AND. !SUBSTR(ALLTRIM(QUERY->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERY->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "MPR"
			TRB1->DESCRICAO	:= "MATERIA PRIMA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) == "MO" ;
										.AND. !SUBSTR(ALLTRIM(QUERY->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERY->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003") 
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) == "OI" ;
										.AND. !SUBSTR(ALLTRIM(QUERY->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERY->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "MPR"
			TRB1->DESCRICAO	:= "MATERIA PRIMA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) == "PA" ;
										.AND. !SUBSTR(ALLTRIM(QUERY->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERY->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) == "PI" ;
										.AND. !SUBSTR(ALLTRIM(QUERY->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERY->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) == "PP" ;
										.AND. !SUBSTR(ALLTRIM(QUERY->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERY->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) == "PV" ;
										.AND. !SUBSTR(ALLTRIM(QUERY->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERY->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) == "SL" ;
										.AND. SUBSTR(ALLTRIM(QUERY->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERY->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) $ ("SV/MP/SL/PV/PP/PI/PA/OI/MO/ME/MC/GG/AI/EM/GE/GC") ;
									.AND. SUBSTR(ALLTRIM(QUERY->C7_PRODUTO),1,2) == "22"  .AND. !ALLTRIM(QUERY->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003/22220018/2219005");
									.AND. ALLTRIM(QUERY->C7_FORNECE) <> "000022"
									
			TRB1->ID		:= "SRV"
			TRB1->DESCRICAO	:= "SERVICOS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) $ ("SV/MP/SL/PV/PP/PI/PA/OI/MO/ME/MC/GG/AI/EM/GE/GC") ;
									.AND. SUBSTR(ALLTRIM(QUERY->C7_PRODUTO),1,2) == "22"  .AND. ALLTRIM(QUERY->C7_PRODUTO) $ ("22220018/2219005")
									
			TRB1->ID		:= "FAB"
			TRB1->DESCRICAO	:= "FABRICACAO"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) == "MO" ;
									.AND. ALLTRIM(QUERY->C7_FORNECE) == "000022"
			TRB1->ID		:= "ESL"
			TRB1->DESCRICAO	:= "ENGENHARIA SLC"
		elseif ALLTRIM(QUERY->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "FRT"
			TRB1->DESCRICAO	:= "FRETE"

		endif

		TRB1->PRODUTO	:= QUERY->C7_PRODUTO
		if QUERY->C7_QUJE > 0
			TRB1->QUANTIDADE:= QUERY->C7_QUANT-QUERY->C7_QUJE
		else
			TRB1->QUANTIDADE:= QUERY->C7_QUANT
		endif
		TRB1->UNIDADE	:= QUERY->C7_UM
		TRB1->HISTORICO	:= QUERY->C7_DESCRI
	

		if QUERY->C7_MOEDA = 2
			dData := QUERY->C7_EMISSAO
			//msginfo ( dData )
			while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

				while  QUERY2->(!eof())
					
					nValor := QUERY2->M2_MOEDA2
				
					if dData == QUERY2->TMP_DATA .AND. nValor > 0
						nValor := QUERY2->M2_MOEDA2
						Exit
					else
						QUERY2->(dbSkip())
					endif

				enddo
				if dData == QUERY2->TMP_DATA .AND. nValor > 0
					exit
				ENDIF
				dData--
				
			enddo
			IF QUERY->C7_QUJE > 0
				TRB1->VALOR		:= ((QUERY->C7_QUANT-QUERY->C7_QUJE)/QUERY->C7_QUANT) * (QUERY->C7_XTOTSI * nValor)
				TRB1->VALOR2	:= ((QUERY->C7_QUANT-QUERY->C7_QUJE)/QUERY->C7_QUANT) * (QUERY->C7_TOTAL * nValor)
			ELSE
				TRB1->VALOR		:= QUERY->C7_XTOTSI * nValor
				TRB1->VALOR2	:= QUERY->C7_TOTAL * nValor
			ENDIF

		elseif QUERY->C7_MOEDA = 3
			dData := QUERY->C7_EMISSAO
			//msginfo ( dData )
			while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

				while  QUERY2->(!eof())
					
					nValor := QUERY2->M2_MOEDA3
				
					if dData == QUERY2->TMP_DATA .AND. nValor > 0
						nValor := QUERY2->M2_MOEDA3
						Exit
					else
						QUERY2->(dbSkip())
					endif

				enddo
				if dData == QUERY2->TMP_DATA .AND. nValor > 0
					exit
				ENDIF
				dData--
			enddo
			IF QUERY->C7_QUJE > 0
				TRB1->VALOR		:= ((QUERY->C7_QUANT-QUERY->C7_QUJE)/QUERY->C7_QUANT) * (QUERY->C7_XTOTSI * nValor)
				TRB1->VALOR2	:= ((QUERY->C7_QUANT-QUERY->C7_QUJE)/QUERY->C7_QUANT) * (QUERY->C7_TOTAL * nValor)
			ELSE
				TRB1->VALOR		:= QUERY->C7_XTOTSI * nValor
				TRB1->VALOR2	:= QUERY->C7_TOTAL * nValor
			ENDIF

		elseif QUERY->C7_MOEDA = 4
			dData := QUERY->C7_EMISSAO
			//msginfo ( dData )
			while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

				while  QUERY2->(!eof())
					
					nValor := QUERY2->M2_MOEDA4
				
					if dData == QUERY2->TMP_DATA .AND. nValor > 0
						nValor := QUERY2->M2_MOEDA4
						Exit
					else
						QUERY2->(dbSkip())
					endif

				enddo
				if dData == QUERY2->TMP_DATA .AND. nValor > 0
					exit
				ENDIF
				dData--
			enddo
			IF QUERY->C7_QUJE > 0
				TRB1->VALOR		:= ((QUERY->C7_QUANT-QUERY->C7_QUJE)/QUERY->C7_QUANT) * (QUERY->C7_XTOTSI * nValor)
				TRB1->VALOR2	:= ((QUERY->C7_QUANT-QUERY->C7_QUJE)/QUERY->C7_QUANT) * (QUERY->C7_TOTAL * nValor)
			ELSE
				TRB1->VALOR		:= QUERY->C7_XTOTSI * nValor
				TRB1->VALOR2	:= QUERY->C7_TOTAL * nValor
			ENDIF
		else
			IF QUERY->C7_QUJE > 0
				TRB1->VALOR		:= ((QUERY->C7_QUANT-QUERY->C7_QUJE)/QUERY->C7_QUANT) * (QUERY->C7_XTOTSI) 
				TRB1->VALOR2	:= ((QUERY->C7_QUANT-QUERY->C7_QUJE)/QUERY->C7_QUANT) * (QUERY->C7_TOTAL) 
			ELSE
				
				TRB1->VALOR		:= QUERY->C7_XTOTSI 
				TRB1->VALOR2	:= QUERY->C7_TOTAL 
			ENDIF
		endif

		TRB1->CODFORN	:= QUERY->C7_FORNECE
		TRB1->FORNECEDOR:= alltrim(POSICIONE("SA2",1,XFILIAL("SA2")+QUERY->C7_FORNECE,"A2_NOME"))
		TRB1->CFOP		:= ""
		TRB1->NATUREZA	:= ""
		TRB1->DNATUREZA := ""
		TRB1->ORIGEM	:= "OC"
		TRB1->ITEMCONTA := QUERY->C7_ITEMCTA
		TRB1->CAMPO		:= "VLREMP"

		MsUnlock()

	endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())
QUERY2->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Processa Documentos de Entrada		                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function D101REAL()

local _cQuery := ""
Local _cFilSD1 := xFilial("SD1")

_cQuery := "SELECT D1_ITEMCTA, cast(D1_EMISSAO AS DATE) AS 'TMP_EMISSAO' , D1_DOC, D1_CF, D1_XNATURE, D1_RATEIO, D1_COD, D1_QUANT, D1_UM, D1_TOTAL, D1_BASEICM,D1_GRUPO, D1_CUSTO, D1_FORNECE, D1_VALIPI,D1_VALICM,D1_VALIMP5,D1_VALIMP6,D1_DESPESA  FROM SD1010  WHERE  D_E_L_E_T_ <> '*' AND D1_ITEMCTA = '" + _cItemConta + "' ORDER BY D1_EMISSAO"

	IF Select("_cQuery") <> 0
		DbSelectArea("_cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery NEW ALIAS "QUERY"

	dbSelectArea("QUERY")
	QUERY->(dbGoTop())

/*
SD1->(dbsetorder(13)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("SD1",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"D1_EMISSAO",,,"Selecionando Registros...")


ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())
*/
while QUERY->(!eof())

	if QUERY->D1_ITEMCTA == _cItemConta;
		.AND. ! alltrim(QUERY->D1_CF) $ ('1201/1554/1902/1903/1906/1911/1912/1913/1915/1916/1920/1921/1922/1924/1925/1949/2201/2554/2902/2903/2906/2911/2912/2913/2915/2916/2920/2921/2924/2925/2949') .AND. QUERY->D1_RATEIO == '2';
		.AND. QUERY->D1_RATEIO == '2'
		
		//.OR. QUERY->D1_ITEMCTA == _cItemConta .AND. ! alltrim(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00') .AND. QUERY->D1_RATEIO == '2';
		//.AND. !alltrim(QUERY->D1_CF) $ ('1201/1554/1902/1903/1906/1911/1912/1913/1915/1916/1920/1921/1922/1924/1925/1949/2201/2554/2902/2903/2906/2911/2912/2913/2916/2920/2921/2924/2925/2949')

		//if alltrim(QUERY->E5_TIPODOC) <> "CH"
		RecLock("TRB1",.T.)
		
		//MsProcTxt("Processando registro: "+alltrim(QUERY->D1_DOC))
		//ProcessMessage()
		
		TRB1->DATAMOV	:= QUERY->TMP_EMISSAO
		TRB1->TIPO		:= alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO"))
		TRB1->NUMERO	:= QUERY->D1_DOC
		TRB1->ID		:= "MPR"
		TRB1->DESCRICAO	:= "MATERIA PRIMA"
		TRB1->IDUSA		:= "101"
		TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
				
		if ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00')
			TRB1->IDUSA		:= "908"
			TRB1->DESCUSA	:= "COMISSAO"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "SV" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00');
				.AND. SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) == "22"  .AND. !ALLTRIM(QUERY->D1_COD) $ ("224001/224004/224002/2212004/224003");
				.OR.;
				!ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00');
				.AND. SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) == "22"  .AND. !ALLTRIM(QUERY->D1_COD) $ ("224001/224004/224002/2212004/224003/22220018/2219005") ;
				.AND. ALLTRIM(QUERY->D1_FORNECE) <> "000022"
			TRB1->IDUSA		:= "501"
			TRB1->DESCUSA	:= "SERVICOS EXTERNOS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "SV/MP/SL/PV/PP/PI/PA/OI/MO/ME/MC/GG/AI/EM/GE/GC" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00');
				.AND. SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) == "22"  .AND. !ALLTRIM(QUERY->D1_COD) $ ("22220018/2219005")	
			TRB1->IDUSA		:= "101"
			TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "MO" ;
									.AND. ALLTRIM(QUERY->D1_FORNECE) == "000022"
			TRB1->IDUSA		:= "501"
			TRB1->DESCUSA	:= "SERVICOS EXTERNOS"			
		elseif ALLTRIM(QUERY->D1_COD) $ ("224001/224004/224002/2212004/224003")
			TRB1->IDUSA		:= "301"
			TRB1->DESCUSA	:= "FRETE, EMBALAGEM, AFINS"
			
		elseif EMPTY(ALLTRIM(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_GRUPO"))) 
			TRB1->IDUSA		:= "101"
			TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
		
		else
			cGrProd			:= POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_GRUPO")
			TRB1->IDUSA		:= POSICIONE("SBM",1,XFILIAL("SBM")+cGrProd,"BM_XIDUSA")
				
			cGrUSA			:= POSICIONE("SBM",1,XFILIAL("SBM")+cGrProd,"BM_XIDUSA")
			TRB1->DESCUSA	:= alltrim(POSICIONE("ZZL",1,XFILIAL("ZZL")+cGrUSA,"ZZL_DESC"))
				
		endif
		
		TRB1->GRPROD	:= POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_GRUPO")	
		
		if alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "MP" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) $ "22"
			TRB1->ID		:= "MPR"
			TRB1->DESCRICAO	:= "MATERIA PRIMA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "AI" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "EM" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "GE" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "GG" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "MC" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00') ;
							.AND. !SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "ME" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00') ;
							.AND. !SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) $ "22"
			TRB1->ID		:= "MPR"
			TRB1->DESCRICAO	:= "MATERIA PRIMA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "MO" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00') ;
							.AND. !SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "OI" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00') ;
							.AND. !SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "PA" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00') ;
							.AND. !SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "PI" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00') ;
							.AND. !SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "PP" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00') ;
							.AND. !SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "PV" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00') ;
							.AND. !SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "SL" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00') ;
							.AND. !SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "SV" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00');
				.AND. SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) == "22"  .AND. !ALLTRIM(QUERY->D1_COD) $ ("224001/224004/224002/2212004/224003");
				.OR.;
				!ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00');
				.AND. SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) == "22"  .AND. !ALLTRIM(QUERY->D1_COD) $ ("224001/224004/224002/2212004/224003/22220018/2219005") ;
				.AND. ALLTRIM(QUERY->D1_FORNECE) <> "000022"
			TRB1->ID		:= "SRV"
			TRB1->DESCRICAO	:= "SERVICOS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "SV/MP/SL/PV/PP/PI/PA/OI/MO/ME/MC/GG/AI/EM/GE/GC" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00');
				.AND. SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) == "22"  .AND. !ALLTRIM(QUERY->D1_COD) $ ("22220018/2219005")	
			TRB1->ID		:= "FAB"
			TRB1->DESCRICAO	:= "FABRICACAO"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "MO" ;
									.AND. ALLTRIM(QUERY->D1_FORNECE) == "000022"
			TRB1->ID		:= "ESL"
			TRB1->DESCRICAO	:= "ENGENHARIA SLC"
		elseif ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00')
			TRB1->ID		:= "CMS"
			TRB1->DESCRICAO	:= "COMISSAO"
		elseif ALLTRIM(QUERY->D1_COD) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "FRT"
			TRB1->DESCRICAO	:= "FRETE"
		else
			TRB1->ID		:= "CDV"
			TRB1->DESCRICAO	:= "CUSTOS DIVERSOS"
		endif
		
		TRB1->PRODUTO	:= QUERY->D1_COD
		TRB1->HISTORICO	:= alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_DESC"))
		TRB1->QUANTIDADE:= QUERY->D1_QUANT
		TRB1->UNIDADE 	:= QUERY->D1_UM
		TRB1->VALOR		:= QUERY->D1_CUSTO
		if SUBSTR(ALLTRIM(QUERY->D1_CF),1,1) = "3"
			TRB1->VALOR2	:= QUERY->D1_TOTAL + QUERY->D1_VALIPI + QUERY->D1_VALICM + QUERY->D1_VALIMP5 + QUERY->D1_VALIMP6 + QUERY->D1_DESPESA //QUERY->D1_BASEICM
		ELSE
			TRB1->VALOR2	:= QUERY->D1_TOTAL
		END
		
		TRB1->CODFORN	:= QUERY->D1_FORNECE
		TRB1->FORNECEDOR:= alltrim(POSICIONE("SA2",1,XFILIAL("SA2")+QUERY->D1_FORNECE,"A2_NOME"))
		TRB1->CFOP		:= QUERY->D1_CF
		TRB1->NATUREZA	:= QUERY->D1_XNATURE
		TRB1->DNATUREZA := alltrim(POSICIONE("SED",1,XFILIAL("SED")+QUERY->D1_XNATURE,"ED_DESCRIC"))
		TRB1->ORIGEM	:= "DE"
		TRB1->ITEMCONTA := QUERY->D1_ITEMCTA
		TRB1->CAMPO		:= "VLREMP"
		MsUnlock()

	endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())

return


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Processa Documentos de Entrada		                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function DE01REAL()

local _cQuery := ""
Local _cFilSDE := xFilial("SDE")
Local cProdD1 	:= ""
Local cDoc		:= ""
Local cSerie	:= ""
Local cFornece	:= ""
Local cLoja		:= ""
Local cItemNF	:= ""
local cFor := "ALLTRIM(QUERY->DE_ITEMCTA) == _cItemConta"
/*
_cQuery := "SELECT DE_ITEMCTA, DE_DOC, DE_FORNECE, DE_CUSTO1, DE_ITEMNF FROM SDE010  WHERE  D_E_L_E_T_ <> '*' AND DE_ITEMCTA = '" + _cItemConta + "' "


	IF Select("_cQuery") <> 0
		DbSelectArea("_cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery NEW ALIAS "QUERY"

	dbSelectArea("QUERY")
	QUERY->(dbGoTop())
*/

SD1->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("SDE",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"QUERY->DE_DOC",,cFor,"Selecionando Registros...")
ProcRegua(QUERY->(reccount()))
QUERY->(dbgotop())

cDoc		:= QUERY->DE_DOC
//cSerie		:= QUERY->DE_SERIE
cFornece	:= QUERY->DE_FORNECE
//cLoja		:= QUERY->DE_LOJA
cItemNF		:= QUERY->DE_ITEMNF

while QUERY->(!eof())

	if QUERY->DE_ITEMCTA == _cItemConta;
		.AND. ! alltrim(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_CF")) $ ('1201/1554/1901/1902/1903/1906/1911/1912/1913/1915/1916/1920/1921/1922/1924/1925/1949/2201/2554/2901/2902/2903/2906/2911/2912/2913/2915/2916/2920/2921/2924/2925/2949') 
		
		cDoc		:= QUERY->DE_DOC
		cSerie		:= QUERY->DE_SERIE
		cFornece	:= QUERY->DE_FORNECE
		cLoja		:= QUERY->DE_LOJA
		cItemNF		:= QUERY->DE_ITEMNF
	
		//if alltrim(QUERY->E5_TIPODOC) <> "CH"
		RecLock("TRB1",.T.)
		
		//MsProcTxt("Processando registro: "+alltrim(QUERY->DE_DOC))
		//ProcessMessage()

		cProdD1 		:= ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_COD"))
		
		TRB1->DATAMOV	:= POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_EMISSAO")
		TRB1->TIPO		:= alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO"))
		TRB1->NUMERO	:= QUERY->DE_DOC
		TRB1->ID		:= "MPR"
		TRB1->DESCRICAO	:= "MATERIA PRIMA"
		TRB1->IDUSA		:= "101"
		TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
		TRB1->IDUSA		:= alltrim(POSICIONE("SBM",1,XFILIAL("SBM")+alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_GRUPO")),"BM_XIDUSA")) 
		TRB1->DESCUSA	:= alltrim(POSICIONE("ZZL",1,XFILIAL("ZZL")+alltrim(POSICIONE("SBM",1,XFILIAL("SBM")+alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_GRUPO")),"BM_XIDUSA")),"ZZL_DESC"))
		TRB1->GRPROD	:= POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_GRUPO")
		
		if alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "SV/MP/SL/PV/PP/PI/PA/OI/MO/ME/MC/GG/AI/EM/GE/GC" ;
				.AND. SUBSTR(ALLTRIM(cProdD1),1,2) == "22"  .AND. ALLTRIM(cProdD1) $ ("22220018/2219005")
			TRB1->ID		:= "FAB"
			TRB1->DESCRICAO	:= "FABRICACAO"
			TRB1->IDUSA		:= "101" 
			TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"	
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "SV/MP/SL/PV/PP/PI/PA/OI/MO/ME/MC/GG/AI/EM/GE/GC" ;
				.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
				.AND. SUBSTR(ALLTRIM(cProdD1),1,2) == "22"  .AND. !ALLTRIM(cProdD1) $ ("224001/224004/224002/2212004/224003/22220018/2219005")
			TRB1->IDUSA		:= "501" 
			TRB1->DESCUSA	:= "SERVICOS EXTERNOS"	
		elseif ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00')
			TRB1->IDUSA		:= "908" 
			TRB1->DESCUSA	:= "COMISSAO"
		elseif ALLTRIM(cProdD1) $ ("224001/224004/224002/2212004/224003")
			TRB1->IDUSA		:= "301" 
			TRB1->DESCUSA	:= "FRETE, EMBALAGEM, AFINS"
		else
			cGrProd			:= POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_GRUPO")
			TRB1->IDUSA		:= POSICIONE("SBM",1,XFILIAL("SBM")+cGrProd,"BM_XIDUSA")
				
			cGrUSA			:= POSICIONE("SBM",1,XFILIAL("SBM")+cGrProd,"BM_XIDUSA")
			TRB1->DESCUSA	:= alltrim(POSICIONE("ZZL",1,XFILIAL("ZZL")+cGrUSA,"ZZL_DESC"))
		endif
		
		if ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00')
			TRB1->ID		:= "CMS"
			TRB1->DESCRICAO	:= "COMISSAO"
			
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "MP" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "MPR"
			TRB1->DESCRICAO	:= "MATERIA PRIMA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "AI" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "EM" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "GE" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "CDV"
			TRB1->DESCRICAO	:= "CUSTOS DIVERSOS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "GG" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "CDV"
			TRB1->DESCRICAO	:= "CUSTOS DIVERSOS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "MC" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "ME" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "MO" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "SRV"
			TRB1->DESCRICAO	:= "SERVICOS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "OI" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "PA" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "PI" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "PP" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO"))== "PV" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "CDV"
			TRB1->DESCRICAO	:= "CUSTOS DIVERSOS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "SL" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "SV/MP/SL/PV/PP/PI/PA/OI/MO/ME/MC/GG/AI/EM/GE/GC" ;
				.AND. SUBSTR(ALLTRIM(cProdD1),1,2) == "22"  .AND. ALLTRIM(cProdD1) $ ("22220018/2219005");
				
			TRB1->ID		:= "FAB"
			TRB1->DESCRICAO	:= "FABRICACAO"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "SV/MP/SL/PV/PP/PI/PA/OI/MO/ME/MC/GG/AI/EM/GE/GC" ;
				.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
				.AND. SUBSTR(ALLTRIM(cProdD1),1,2) == "22"  .AND. !ALLTRIM(cProdD1) $ ("224001/224004/224002/2212004/224003/22220018/2219005")
			TRB1->ID		:= "SRV"
			TRB1->DESCRICAO	:= "SERVICOS"	
		elseif ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00')
			TRB1->ID		:= "CMS"
			TRB1->DESCRICAO	:= "COMISSAO"
		elseif ALLTRIM(cProdD1) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "FRT"
			TRB1->DESCRICAO	:= "FRETE"
		else
			TRB1->ID		:= "CDV"
			TRB1->DESCRICAO	:= "CUSTOS DIVERSOS"
		endif

		TRB1->PRODUTO	:= cProdD1
		TRB1->HISTORICO	:= alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_DESC"))
		TRB1->QUANTIDADE:= 0
		TRB1->UNIDADE 	:= ""
		TRB1->VALOR		:= QUERY->DE_CUSTO1
		TRB1->VALOR2	:= QUERY->DE_CUSTO1
		TRB1->CODFORN	:= QUERY->DE_FORNECE
		TRB1->FORNECEDOR:= alltrim(POSICIONE("SA2",1,XFILIAL("SA2")+QUERY->DE_FORNECE,"A2_NOME"))
		TRB1->CFOP		:= POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_CF")
		
		TRB1->NATUREZA	:= POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")
		
		TRB1->DNATUREZA := alltrim(POSICIONE("SED",1,XFILIAL("SED")+POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE"),"ED_DESCRIC"))
		TRB1->ORIGEM	:= "DR"
		TRB1->ITEMCONTA := QUERY->DE_ITEMCTA
		TRB1->CAMPO		:= "VLREMP"
		MsUnlock()

	endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())

return


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Processa FINANCEIRO					                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function FIN01REAL()

local _cQuery := ""
Local _cFilSE2 := xFilial("SE2")
Local nXIPI := 0
Local nXII := 0
Local nXCOFINS := 0
Local nXPIS := 0
Local nXICMS := 0
Local nXSISCO := 0
Local nXSDA := 0
Local nXTERM := 0
Local nXTRANSP := 0
Local nXFRETE := 0
Local nXFUMIG := 0
Local nXARMAZ := 0
Local nXAFRMM := 0
Local nXCAPA := 0
Local nXCOMIS := 0
Local nXISS := 0
Local nXIRRF := 0
Local nCustoFin := 0


_cQuery := "SELECT CAST(E2_BAIXA AS DATE) TMP_BAIXA, E2_TIPO, E2_NUM, E2_NATUREZ, E2_HIST, E2_VLCRUZ, E2_FORNECE, E2_NATUREZ, E2_XXIC, E2_RATEIO, E2_SALDO, E2_BAIXA, "
_cQuery += " E2_TIPO,E2_XIPI,E2_XII,E2_XCOFINS,E2_XPIS,E2_XICMS,E2_XSISCO,E2_XSDA,E2_XTERM,E2_XTRANSP,E2_XFRETE,E2_XFUMIG,E2_XARMAZ,E2_XAFRMM,E2_XCAPA,E2_XCOMIS,E2_XISS,E2_XIRRF, "
_cQuery += " E2_XCTII,E2_XCTIPI,E2_XCTCOF,E2_XCTPIS,E2_XCTICMS,E2_XCTSISC,E2_XCTSDA,E2_XCTTEM,E2_XCTTRAN,E2_XCTFRET,E2_XCTFUM,E2_XCTARM,E2_XCTAFRM,E2_XCTCAPA,E2_XCTCOM,E2_XCTISS,E2_XCTIRRF "
_cQuery += " FROM SE2010  WHERE  D_E_L_E_T_ <> '*' AND E2_XXIC = '" + _cItemConta + "' ORDER BY E2_BAIXA "

	IF Select("_cQuery") <> 0
		DbSelectArea("_cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery NEW ALIAS "QUERY"

	dbSelectArea("QUERY")
	QUERY->(dbGoTop())

while QUERY->(!eof())

	IF ALLTRIM(QUERY->E2_TIPO) = "PA" .AND. QUERY->E2_BAIXA <> "" .AND. QUERY->E2_SALDO = 0
		QUERY->(dbsKip())
		loop
	ENDIF
	
	if QUERY->E2_XXIC == _cItemConta .AND. !ALLTRIM(QUERY->E2_TIPO) $ ("NF/PR/TX/ISS/INS/INV") .AND. ALLTRIM(QUERY->E2_RATEIO) == "N" //.AND. !EMPTY(QUERY->E2_BAIXA)

		IF  !EMPTY(QUERY->E2_BAIXA) .AND. QUERY->E2_TIPO = "PA" //= "" -> CONSIDERA PA
			QUERY->(dbsKip())
			loop
		ENDIF

		RecLock("TRB1",.T.)
		
		//MsProcTxt("Processando registro: "+alltrim(QUERY->E2_NUM))
		//ProcessMessage()
		
		TRB1->DATAMOV	:= QUERY->TMP_BAIXA
		TRB1->TIPO		:= QUERY->E2_TIPO
		TRB1->NUMERO	:= QUERY->E2_NUM

		TRB1->ID		:= "CDV"
		TRB1->DESCRICAO	:= "CUSTOS DIVERSOS"
		
		TRB1->IDUSA		:= alltrim(POSICIONE("SED",1,XFILIAL("SED")+ALLTRIM(QUERY->E2_NATUREZ),"ED_XIDUSA"))
		TRB1->DESCUSA	:= alltrim(POSICIONE("ZZL",1,XFILIAL("ZZL")+alltrim(POSICIONE("SED",1,XFILIAL("SED")+ALLTRIM(QUERY->E2_NATUREZ),"ED_XIDUSA")),"ZZL_DESC"))
		
		//TRB1->GRPROD	:= alltrim(POSICIONE("SED",1,XFILIAL("SED")+ALLTRIM(QUERY->E2_NATUREZ),"ED_XIDUSA"))
		
		if ALLTRIM(QUERY->E2_NATUREZ) $ "2.00.00/2.20.00/2.24.00/2.25.00/2.25.02/3.00.00/3.11.01/3.11.02/3.12.01/3.12.02/3.13.01/3.13.02/3.14.01/" + ;
   										"3.16.01/3.16.02/3.17.01/3.17.02/3.18.00/3.19.00/3.20.00/3.21.00/3.22.00/3.23.00/3.23.01/3.23.02/3.30.00/" + ;
   										"3.14.02/3.31.00/3.32.00/3.33.00/3.34.00/3.41.00/3.42.00/3.50.00/3.51.00/3.53.00/3.55.00/3.56.01/3.56.02/" + ;
   										"3.60.00/3.61.00/3.62.00/3.63.00/3.71.00/3.76.00/3.80.00/3.81.00/3.82.00/3.83.00/3.84.00/3.86.00/3.87.00/" + ;
   										"4.00.00/4.40.00/4.41.00/4.42.00/4.43.00/4.44.00/4.45.00/4.47.00/4.48.00/4.50.00/4.52.00/4.53.00/4.54.00/" + ;
   										"4.55.00/4.56.00/4.57.01/4.57.02/4.58.00/4.59.00/5.00.00/5.60.00/5.61.00/5.62.00/5.63.00/5.80.00/5.82.00/" + ;
   										"6.00.00/6.10.00/6.11.00/6.12.00/6.13.00/6.14.00/6.15.00/6.16.00/6.17.00/6.18.00/6.19.00/6.20.00/7.00.00/" + ;
   										"9.00.00/9.10.00/9.11.00/9.12.00/9.13.00/9.14.00/9.15.00/9.16.00/9.17.00/9.18.00/9.20.00/9.21.00/9.22.00/" + ;
   										"9.23.00/9.24.00/9.25.00/9.26.00/9.30.00/9.31.00/9.32.00/9.33.00/9.34.00/9.35.00/9.36.00/9.40.00/9.41.00/" + ;
   										"9.42.00/9.43.00/9.50.00/9.51.00/9.52.00/9.53.00/9.54.00/9.55.00/APLICACAO/CARTAO/CHEQUE/COFINS/CONVENIO/" + ;
   										"CREDITO/CSLL/DEV./TROCA/DINHEIRO/FINAN/ICMS/INSS/IRF/ISS/NCC/OUTROS/PIS/RECEBIMENT/RESG.APLIC/SANGRIA/TEF/" + ;
   										"TROCO/VALE/"
   			TRB1->ID		:= "CDV"
			TRB1->DESCRICAO	:= "CUSTOS DIVERSOS"
		endif

		if ALLTRIM(QUERY->E2_NATUREZ) $ "6.21.00/6.22.00/COMISSOES"
			TRB1->ID		:= "CMS"
			TRB1->DESCRICAO	:= "COMISSAO"
		endif

		if ALLTRIM(QUERY->E2_NATUREZ) $ "3.15.01/3.15.02/7.10.00/7.20.00/7.30.00/7.40.00/7.50.00/7.60.00/7.70.00/7.80.00/7.90.00"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		endif

		if ALLTRIM(QUERY->E2_NATUREZ) $ "8.24.00"
			TRB1->ID		:= "FRT"
			TRB1->DESCRICAO	:= "FRETE"
		endif

		if ALLTRIM(QUERY->E2_NATUREZ) $ "2.10.00/2.11.00/2.12.00/2.13.00/2.14.00/2.15.00/2.16.00/2.17.00/2.18.00/2.19.00/2.21.00/2.22.00/2.23.00/2.25.01/3.10.00/3.57.00"
			TRB1->ID		:= "MPR"
			TRB1->DESCRICAO	:= "MATERIA PRIMA"
		endif

		if ALLTRIM(QUERY->E2_TIPO) $ ("RDV") .OR. ALLTRIM(QUERY->E2_NATUREZ) $ "3.70.00/3.72.00/3.73.00/3.74.01/3.74.02/3.75.00/3.77.00/3.85.00/4.51.00/5.64.00/5.70.00" + ;
																			"5.71.00/5.72.00/5.73.00/5.74.00/5.75.00/5.76.00/5.77.00/5.78.00/5.79.00/5.81.00/5.83.00/5.84.00"
			TRB1->ID		:= "RDV"
			TRB1->DESCRICAO	:= "RELATORIO DE VIAGEM"
		endif

		if ALLTRIM(QUERY->E2_NATUREZ) $ "3.40.00/8.00.00/8.10.00/8.10.01/8.11.00/8.12.00/8.12.01/8.13.00/8.14.00/8.15.00/8.15.01/8.15.02/8.16.00/8.17.00/8.17.01/8.18.00/" + ;
										"8.19.00/8.19.01/8.19.02/8.20.00/8.20.01/8.20.02/8.20.03/8.21.00/8.21.01/8.21.02/8.22.00/8.23.00/8.23.01/8.23.02/8.23.03/8.23.04/" + ;
										"8.23.05/8.23.06/8.23.07/8.25.00/8.26.00/8.27.00/8.28.00/8.28.01/8.29.00/8.30.00/8.31.00"
			TRB1->ID		:= "SRV"
			TRB1->DESCRICAO	:= "SERVICOS"
		endif

		TRB1->PRODUTO	:= ""
		TRB1->HISTORICO	:= QUERY->E2_HIST
		TRB1->QUANTIDADE:= 0
		TRB1->UNIDADE 	:= ""
		
				
		if QUERY->E2_XCTIPI = "2"
			nXIPI := QUERY->E2_XIPI
		else
			nXIPI := 0
		endif
		
		if QUERY->E2_XCTII = "2"
			nXII := QUERY->E2_XII
		else
			nXII := 0
		endif
		
		if QUERY->E2_XCTCOF = "2"
			nXCOFINS := QUERY->E2_XCOFINS
		else
			nXCOFINS := 0
		endif
		
		if QUERY->E2_XCTPIS = "2"
			nXPIS := QUERY->E2_XPIS
		else
			nXPIS := 0
		endif
		
		if QUERY->E2_XCTICMS = "2"
			nXICMS := QUERY->E2_XICMS
		else
			nXICMS := 0
		endif
		
		if QUERY->E2_XCTSISC = "2"
			nXSISCO := QUERY->E2_XSISCO
		else
			nXSISCO := 0
		endif
		
		if QUERY->E2_XCTSDA = "2"
			nXSDA := QUERY->E2_XSDA
		else
			nXSDA := 0
		endif
		
		if QUERY->E2_XCTTEM = "2"
			nXTERM := QUERY->E2_XTERM
		else
			nXTERM := 0
		endif
		
		if QUERY->E2_XCTTRAN = "2"
			nXTRANSP := QUERY->E2_XTRANSP
		else
			nXTRANSP := 0
		endif
		
		if QUERY->E2_XCTFRET = "2"
			nXFRETE := QUERY->E2_XFRETE
		else
			nXFRETE := 0
		endif
		
		if QUERY->E2_XCTFUM = "2"
			nXFUMIG := QUERY->E2_XFUMIG
		else
			nXFUMIG := 0
		endif
		
		if QUERY->E2_XCTARM = "2"
			nXARMAZ := QUERY->E2_XARMAZ
		else
			nXARMAZ := 0
		endif
		
		if QUERY->E2_XCTAFRM = "2"
			nXAFRMM := QUERY->E2_XAFRMM
		else
			nXAFRMM := 0
		endif
		
		if QUERY->E2_XCTCAPA = "2"
			nXCAPA := QUERY->E2_XCAPA
		else
			nXCAPA := 0
		endif
		
		if QUERY->E2_XCTCOM = "2"
			nXCOMIS := QUERY->E2_XCOMIS
		else
			nXCOMIS := 0
		endif
		
		if QUERY->E2_XCTISS = "2"
			nXISS := QUERY->E2_XISS
		else
			nXISS := 0
		endif
		
		if QUERY->E2_XCTIRRF = "2"
			nXIRRF := QUERY->E2_XIRRF
		else
			nXIRRF := 0
		endif
		
		nCustoFin := QUERY->E2_VLCRUZ - nXIPI - nXII - nXCOFINS - nXPIS - nXICMS - nXSISCO - nXSDA - nXTERM - nXTRANSP - nXFRETE - nXFUMIG - nXARMAZ - nXAFRMM - nXCAPA - nXCOMIS - nXISS - nXIRRF
		if QUERY->E2_TIPO = "PA"
			TRB1->VALOR		:= QUERY->E2_SALDO
			TRB1->VALOR2	:= QUERY->E2_SALDO
		ELSE
			TRB1->VALOR		:= nCustoFin
			TRB1->VALOR2	:= nCustoFin
		endiF
		TRB1->CODFORN	:= QUERY->E2_FORNECE
	
		TRB1->FORNECEDOR:= alltrim(POSICIONE("SA2",1,XFILIAL("SA2")+QUERY->E2_FORNECE,"A2_NOME"))
		TRB1->CFOP		:= ""
		TRB1->NATUREZA	:= QUERY->E2_NATUREZ
		TRB1->DNATUREZA := alltrim(POSICIONE("SED",1,XFILIAL("SED")+QUERY->E2_NATUREZ,"ED_DESCRIC"))
		TRB1->ORIGEM	:= "FN"
		TRB1->ITEMCONTA := QUERY->E2_XXIC
		TRB1->CAMPO		:= "VLREMP"

		MsUnlock()

	endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Processa FINANCEIRO RATEIO			                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function CV401REAL()

local _cQuery := ""
local cQuery := ""
Local _cFilCV4 := xFilial("CV4")
Local nXIPI := 0
Local nXII := 0
Local nXCOFINS := 0
Local nXPIS := 0
Local nXICMS := 0
Local nXSISCO := 0
Local nXSDA := 0
Local nXTERM := 0
Local nXTRANSP := 0
Local nXFRETE := 0
Local nXFUMIG := 0
Local nXARMAZ := 0
Local nXAFRMM := 0
Local nXCAPA := 0
Local nXCOMIS := 0
Local nXISS := 0
Local nXIRRF := 0
Local nCustoFin := 0
Local nPropVlr := 0


cQuery := "	SELECT DISTINCT E2_FORNECE, E2_NOMFOR, E2_LOJA, E2_RATEIO,E2_XXIC, E2_NUM, E2_VENCREA, E2_VENCTO, E2_VLCRUZ, E2_NATUREZ,  " 
cQuery += "	CAST(CV4_DTSEQ AS DATE) AS 'TMP_DTSEQ', CV4_PERCEN,CV4_VALOR,CV4_ITEMD, CV4_HIST, CV4_SEQUEN,"
cQuery += "		CV4_FILIAL+CV4_DTSEQ+CV4_SEQUEN AS 'TMP_ARQRAT',E2_ARQRAT, E2_TIPO, E2_BAIXA, " 
cQuery += " E2_TIPO,E2_XIPI,E2_XII,E2_XCOFINS,E2_XPIS,E2_XICMS,E2_XSISCO,E2_XSDA,E2_XTERM,E2_XTRANSP,E2_XFRETE,E2_XFUMIG,E2_XARMAZ,E2_XAFRMM,E2_XCAPA,E2_XCOMIS,E2_XISS,E2_XIRRF, "
cQuery += " E2_XCTII,E2_XCTIPI,E2_XCTCOF,E2_XCTPIS,E2_XCTICMS,E2_XCTSISC,E2_XCTSDA,E2_XCTTEM,E2_XCTTRAN,E2_XCTFRET,E2_XCTFUM,E2_XCTARM,E2_XCTAFRM,E2_XCTCAPA,E2_XCTCOM,E2_XCTISS,E2_XCTIRRF " 
cQuery += "		FROM CV4010 "
cQuery += "		INNER JOIN SE2010 ON SE2010.E2_ARQRAT = CV4_FILIAL+CV4_DTSEQ+CV4_SEQUEN "
cQuery += "		WHERE E2_RATEIO = 'S' AND SE2010.D_E_L_E_T_ <> '*' AND CV4010.D_E_L_E_T_ <> '*' "
cQuery += "				ORDER BY E2_XXIC "

	IF Select("cQuery") <> 0
		DbSelectArea("cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "QUERY"

	dbSelectArea("QUERY")
	QUERY->(dbGoTop())

/*
CV4->(dbsetorder(2)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CV4",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"CV4_DTSEQ",,,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))
*/
QUERY->(dbgotop())

while QUERY->(!eof())

	IF ALLTRIM(QUERY->E2_TIPO) = "PA" .AND. QUERY->E2_BAIXA <> "" 
		QUERY->(dbsKip())
		loop
	ENDIF

	if QUERY->CV4_ITEMD == _cItemConta

		RecLock("TRB1",.T.)
		
		//MsProcTxt("Processando registro: "+alltrim(QUERY->CV4_SEQUEN))
		//ProcessMessage()
		
		TRB1->DATAMOV	:= QUERY->TMP_DTSEQ
		TRB1->NUMERO	:= QUERY->CV4_SEQUEN
		TRB1->TIPO		:= QUERY->E2_TIPO
		TRB1->ID		:= "CDV"
		TRB1->DESCRICAO	:= "CUSTOS DIVERSOS"
		
		TRB1->IDUSA		:= alltrim(POSICIONE("SED",1,XFILIAL("SED")+ALLTRIM(QUERY->E2_NATUREZ),"ED_XIDUSA"))
		TRB1->DESCUSA	:= alltrim(POSICIONE("ZZL",1,XFILIAL("ZZL")+alltrim(POSICIONE("SED",1,XFILIAL("SED")+ALLTRIM(QUERY->E2_NATUREZ),"ED_XIDUSA")),"ZZL_DESC"))
		
		//TRB1->GRPROD	:= alltrim(POSICIONE("SED",1,XFILIAL("SED")+ALLTRIM(QUERY->E2_NATUREZ),"ED_XIDUSA"))

		if ALLTRIM(QUERY->E2_NATUREZ) $ "2.00.00/2.20.00/2.24.00/2.25.00/2.25.02/3.00.00/3.11.01/3.11.02/3.12.01/3.12.02/3.13.01/3.13.02/3.14.01/" + ;
   										"3.16.01/3.16.02/3.17.01/3.17.02/3.18.00/3.19.00/3.20.00/3.21.00/3.22.00/3.23.00/3.23.01/3.23.02/3.30.00/" + ;
   										"3.14.02/3.31.00/3.32.00/3.33.00/3.34.00/3.41.00/3.42.00/3.50.00/3.51.00/3.53.00/3.55.00/3.56.01/3.56.02/" + ;
   										"3.60.00/3.61.00/3.62.00/3.63.00/3.71.00/3.76.00/3.80.00/3.81.00/3.82.00/3.83.00/3.84.00/3.86.00/3.87.00/" + ;
   										"4.00.00/4.40.00/4.41.00/4.42.00/4.43.00/4.44.00/4.45.00/4.47.00/4.48.00/4.50.00/4.52.00/4.53.00/4.54.00/" + ;
   										"4.55.00/4.56.00/4.57.01/4.57.02/4.58.00/4.59.00/5.00.00/5.60.00/5.61.00/5.62.00/5.63.00/5.80.00/5.82.00/" + ;
   										"6.00.00/6.10.00/6.11.00/6.12.00/6.13.00/6.14.00/6.15.00/6.16.00/6.17.00/6.18.00/6.19.00/6.20.00/7.00.00/" + ;
   										"9.00.00/9.10.00/9.11.00/9.12.00/9.13.00/9.14.00/9.15.00/9.16.00/9.17.00/9.18.00/9.20.00/9.21.00/9.22.00/" + ;
   										"9.23.00/9.24.00/9.25.00/9.26.00/9.30.00/9.31.00/9.32.00/9.33.00/9.34.00/9.35.00/9.36.00/9.40.00/9.41.00/" + ;
   										"9.42.00/9.43.00/9.50.00/9.51.00/9.52.00/9.53.00/9.54.00/9.55.00/APLICACAO/CARTAO/CHEQUE/COFINS/CONVENIO/" + ;
   										"CREDITO/CSLL/DEV./TROCA/DINHEIRO/FINAN/ICMS/INSS/IRF/ISS/NCC/OUTROS/PIS/RECEBIMENT/RESG.APLIC/SANGRIA/TEF/" + ;
   										"TROCO/VALE/"
   			TRB1->ID		:= "CDV"
			TRB1->DESCRICAO	:= "CUSTOS DIVERSOS"
		endif

		if ALLTRIM(QUERY->E2_NATUREZ) $ "6.21.00/6.22.00/COMISSOES"
			TRB1->ID		:= "CMS"
			TRB1->DESCRICAO	:= "COMISSAO"
		endif

		if ALLTRIM(QUERY->E2_NATUREZ) $ "3.15.01/3.15.02/7.10.00/7.20.00/7.30.00/7.40.00/7.50.00/7.60.00/7.70.00/7.80.00/7.90.00"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		endif

		if ALLTRIM(QUERY->E2_NATUREZ) $ "8.24.00"
			TRB1->ID		:= "FRT"
			TRB1->DESCRICAO	:= "FRETE"
		endif

		if ALLTRIM(QUERY->E2_NATUREZ) $ "2.10.00/2.11.00/2.12.00/2.13.00/2.14.00/2.15.00/2.16.00/2.17.00/2.18.00/2.19.00/2.21.00/2.22.00/2.23.00/2.25.01/3.10.00/3.57.00"
			TRB1->ID		:= "MPR"
			TRB1->DESCRICAO	:= "MATERIA PRIMA"
		endif

		if  ALLTRIM(QUERY->E2_NATUREZ) $ "3.70.00/3.72.00/3.73.00/3.74.01/3.74.02/3.75.00/3.77.00/3.85.00/4.51.00/5.64.00/5.70.00" + ;
																			"5.71.00/5.72.00/5.73.00/5.74.00/5.75.00/5.76.00/5.77.00/5.78.00/5.79.00/5.81.00/5.83.00/5.84.00"
			TRB1->ID		:= "RDV"
			TRB1->DESCRICAO	:= "RELATORIO DE VIAGEM"
		endif

		if ALLTRIM(QUERY->E2_NATUREZ) $ "3.40.00/8.00.00/8.10.00/8.10.01/8.11.00/8.12.00/8.12.01/8.13.00/8.14.00/8.15.00/8.15.01/8.15.02/8.16.00/8.17.00/8.17.01/8.18.00/" + ;
										"8.19.00/8.19.01/8.19.02/8.20.00/8.20.01/8.20.02/8.20.03/8.21.00/8.21.01/8.21.02/8.22.00/8.23.00/8.23.01/8.23.02/8.23.03/8.23.04/" + ;
										"8.23.05/8.23.06/8.23.07/8.25.00/8.26.00/8.27.00/8.28.00/8.28.01/8.29.00/8.30.00/8.31.00"
			TRB1->ID		:= "SRV"
			TRB1->DESCRICAO	:= "SERVICOS"
		endif

		if QUERY->E2_XCTIPI = "2"
			nXIPI := QUERY->E2_XIPI * (QUERY->CV4_PERCEN/100)
		else
			nXIPI := 0
		endif
		
		if QUERY->E2_XCTII = "2"
			nXII := QUERY->E2_XII * (QUERY->CV4_PERCEN/100)
		else
			nXII := 0
		endif
		
		if QUERY->E2_XCTCOF = "2"
			nXCOFINS := QUERY->E2_XCOFINS * (QUERY->CV4_PERCEN/100)
		else
			nXCOFINS := 0
		endif
		
		if QUERY->E2_XCTPIS = "2"
			nXPIS := QUERY->E2_XPIS * (QUERY->CV4_PERCEN/100)
		else
			nXPIS := 0
		endif
		
		if QUERY->E2_XCTICMS = "2"
			nXICMS := QUERY->E2_XICMS * (QUERY->CV4_PERCEN/100)
		else
			nXICMS := 0
		endif
		
		if QUERY->E2_XCTSISC = "2"
			nXSISCO := QUERY->E2_XSISCO * (QUERY->CV4_PERCEN/100)
		else
			nXSISCO := 0
		endif
		
		if QUERY->E2_XCTSDA = "2"
			nXSDA := QUERY->E2_XSDA * (QUERY->CV4_PERCEN/100)
		else
			nXSDA := 0
		endif
		
		if QUERY->E2_XCTTEM = "2"
			nXTERM := QUERY->E2_XTERM * (QUERY->CV4_PERCEN/100)
		else
			nXTERM := 0
		endif
		
		if QUERY->E2_XCTTRAN = "2"
			nXTRANSP := QUERY->E2_XTRANSP * (QUERY->CV4_PERCEN/100)
		else
			nXTRANSP := 0
		endif
		
		if QUERY->E2_XCTFRET = "2"
			nXFRETE := QUERY->E2_XFRETE * (QUERY->CV4_PERCEN/100)
		else
			nXFRETE := 0
		endif
		
		if QUERY->E2_XCTFUM = "2"
			nXFUMIG := QUERY->E2_XFUMIG * (QUERY->CV4_PERCEN/100)
		else
			nXFUMIG := 0
		endif
		
		if QUERY->E2_XCTARM = "2"
			nXARMAZ := QUERY->E2_XARMAZ * (QUERY->CV4_PERCEN/100)
		else
			nXARMAZ := 0
		endif
		
		if QUERY->E2_XCTAFRM = "2"
			nXAFRMM := QUERY->E2_XAFRMM * (QUERY->CV4_PERCEN/100)
		else
			nXAFRMM := 0
		endif
		
		if QUERY->E2_XCTCAPA = "2"
			nXCAPA := QUERY->E2_XCAPA * (QUERY->CV4_PERCEN/100)
		else
			nXCAPA := 0
		endif
		
		if QUERY->E2_XCTCOM = "2"
			nXCOMIS := QUERY->E2_XCOMIS * (QUERY->CV4_PERCEN/100)
		else
			nXCOMIS := 0
		endif
		
		if QUERY->E2_XCTISS = "2"
			nXISS := QUERY->E2_XISS * (QUERY->CV4_PERCEN/100)
		else
			nXISS := 0
		endif
		
		if QUERY->E2_XCTIRRF = "2"
			nXIRRF := QUERY->E2_XIRRF * (QUERY->CV4_PERCEN/100)
		else
			nXIRRF := 0
		endif

		TRB1->PRODUTO	:= ""
		TRB1->HISTORICO	:= QUERY->CV4_HIST
		TRB1->QUANTIDADE:= 0
		TRB1->UNIDADE 	:= ""
		TRB1->VALOR		:= QUERY->CV4_VALOR - nXIPI - nXII - nXCOFINS - nXPIS - nXICMS - nXSISCO - nXSDA - nXTERM - nXTRANSP - nXFRETE - nXFUMIG - nXARMAZ - nXAFRMM - nXCAPA - nXCOMIS - nXISS - nXIRRF
		TRB1->VALOR2	:= QUERY->CV4_VALOR - nXIPI - nXII - nXCOFINS - nXPIS - nXICMS - nXSISCO - nXSDA - nXTERM - nXTRANSP - nXFRETE - nXFUMIG - nXARMAZ - nXAFRMM - nXCAPA - nXCOMIS - nXISS - nXIRRF
		TRB1->CODFORN	:= QUERY->E2_FORNECE
		TRB1->FORNECEDOR:= QUERY->E2_NOMFOR
		TRB1->CFOP		:= ""
		TRB1->NATUREZA	:= QUERY->E2_NATUREZ
		TRB1->DNATUREZA := alltrim(POSICIONE("SED",1,XFILIAL("SED")+QUERY->E2_NATUREZ,"ED_DESCRIC"))
		TRB1->ORIGEM	:= "FR"
		TRB1->ITEMCONTA := QUERY->CV4_ITEMD
		TRB1->CAMPO		:= "VLREMP"
		MsUnlock()

	endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFIN01REAL�Autor  �Marcos Zanetti GZ   � Data �  01/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Processa HORAS DE CONTRATO				                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


static function HR01REAL()

local _cQuery := ""
Local _cFilSZ4 := xFilial("SZ4")
Local nTarefa
local cFor := "ALLTRIM(QUERY->Z4_ITEMCTA) == _cItemConta"

//SZ4->(dbsetorder(9)) 

ChkFile("SZ4",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"Z4_FILIAL+Z4_ITEMCTA",,cFor,"Selecionando Registros...")


ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())
//SC7->(dbgotop())
//QUERY->(dbseek( ALLTRIM(MV_PAR01),.T.))

while QUERY->(!eof())

	if QUERY->Z4_ITEMCTA == _cItemConta

		//if alltrim(QUERY->E5_TIPODOC) <> "CH"
		RecLock("TRB1",.T.)
		
		//MsProcTxt("Processando registro: "+alltrim(QUERY->Z4_COLAB))
		//ProcessMessage()
		
		TRB1->DATAMOV	:= QUERY->Z4_DATA
		TRB1->TIPO		:= QUERY->Z4_TAREFA
		TRB1->NUMERO	:= ""

		TRB1->ID		:= "CTR"
		TRB1->DESCRICAO	:= "CONTRATOS"
		TRB1->IDUSA		:= "210"
		TRB1->DESCUSA	:= "GERENCIAMENTO DE PROJETOS"

		if ALLTRIM(QUERY->Z4_TAREFA) == "CE"
			TRB1->ID		:= "EBR"
			TRB1->DESCRICAO	:= "ENGENHARIA BR"
			TRB1->IDUSA		:= "210"
			TRB1->DESCUSA	:= "GERENCIAMENTO DE PROJETOS"
			
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "EE"
			TRB1->ID		:= "EBR"
			TRB1->DESCRICAO	:= "ENGENHARIA BR"
			TRB1->IDUSA		:= "204"
			TRB1->DESCUSA	:= "DETALHAMENTO"
			
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "LB"
			TRB1->ID		:= "LAB"
			TRB1->DESCRICAO	:= "LABORATORIO"
			TRB1->IDUSA		:= "213"
			TRB1->DESCUSA	:= "OUTRA MONTAGEM / TESTE"
		
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "PB"
			TRB1->ID		:= "EBR"
			TRB1->DESCRICAO	:= "ENGENHARIA BR"
			TRB1->IDUSA		:= "202"
			TRB1->DESCUSA	:= "PROJETO / LAYOUT / CALCULOS"
		
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "DT"
			TRB1->ID		:= "EBR"
			TRB1->DESCRICAO	:= "ENGENHARIA BR"
			TRB1->IDUSA		:= "204"
			TRB1->DESCUSA	:= "DETALHAMENTO"
			
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "DC"
			TRB1->ID		:= "EBR"
			TRB1->DESCRICAO	:= "ENGENHARIA BR"
			TRB1->IDUSA		:= "220"
			TRB1->DESCUSA	:= "OUTRO, O&M, COPIA, EMBARQUE"
	
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "OP"
			TRB1->ID		:= "EBR"
			TRB1->DESCRICAO	:= "ENGENHARIA BR"
			TRB1->IDUSA		:= "201"
			TRB1->DESCUSA	:= "SUBMITTALS"
		
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "DI"
			TRB1->ID		:= "IDL"
			TRB1->DESCRICAO	:= "INSPECAO / DILIGENCIAMENTO"
			TRB1->IDUSA		:= "217"
			TRB1->DESCUSA	:= "INSPECAO"
		
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "SC"
			TRB1->ID		:= "IDL"
			TRB1->DESCRICAO	:= "INSPECAO / DILIGENCIAMENTO"
			TRB1->IDUSA		:= "218"
			TRB1->DESCUSA	:= "SERVICO / TESTE DE CAMPO"
		
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "CR"
			TRB1->ID		:= "CTR"
			TRB1->DESCRICAO	:= "CONTRATOS"
			TRB1->IDUSA		:= "211"
			TRB1->DESCUSA	:= "COMPRAS / EXPEDICAO"
			
		endif

		if ALLTRIM(QUERY->Z4_TAREFA) == "VD"
			nTarefa := ":Vendas"
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "OP"
			nTarefa := ":Operacoes"
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "LB"
			nTarefa := ":Laboratorio"
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "EX"
			nTarefa := ":Expedicao"
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "DT"
			nTarefa := ":Detalhamento"
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "AD"
			nTarefa := ":Administracao"
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "CP"
			nTarefa := ":Coordenacao de Contrato"
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "CR"
			nTarefa := ":Compras"
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "DC"
			nTarefa := ":Outros Documentos"
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "CE"
			nTarefa := ":Coordenacao de Engenharia"
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "EE"
			nTarefa := ":Estudo de Engenharia"
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "PB"
			nTarefa := ":Projeto Basico"
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "DI"
			nTarefa := ":Diligenciamento / Inspecao"
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "SC"
			nTarefa := ":Servico de Campo"
		elseif EMPTY(ALLTRIM(QUERY->Z4_TAREFA))
			nTarefa := "ST:Sem Tarfa"
		else
			nTarefa := "ST:Sem Tarfa"
		endif

		TRB1->PRODUTO	:= QUERY->Z4_IDAPTHR
		TRB1->HISTORICO	:= ALLTRIM(QUERY->Z4_TAREFA) + nTarefa + " - " + QUERY->Z4_COLAB
		TRB1->QUANTIDADE:= QUERY->Z4_QTDHRS
		TRB1->UNIDADE	:= "HR"
		TRB1->VALOR		:= QUERY->Z4_TOTVLR
		TRB1->VALOR2	:= QUERY->Z4_TOTVLR
		TRB1->CODFORN	:= ""
		TRB1->FORNECEDOR:= ""
		TRB1->CFOP		:= ""
		TRB1->NATUREZA	:= ""
		TRB1->DNATUREZA := ""
		TRB1->ORIGEM	:= "HR"
		TRB1->ITEMCONTA := QUERY->Z4_ITEMCTA
		TRB1->CAMPO		:= "VLREMP"
		MsUnlock()

	endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFIN01REAL�Autor  �Marcos Zanetti GZ   � Data �  01/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Processa CUSTOS DIVERSOS 2				                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function CUDIV01REAL()

local _cQuery := ""
Local _cFilZZA := xFilial("ZZA")
Local nTarefa
local cFor := "ALLTRIM(QUERY->ZZA_ITEMIC) == _cItemConta"
/*
_cQuery := "SELECT * FROM ZZA010  WHERE  D_E_L_E_T_ <> '*' AND ZZA_ITEMIC = '" + _cItemConta + "' ORDER BY ZZA_DATA"

	IF Select("_cQuery") <> 0
		DbSelectArea("_cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery NEW ALIAS "QUERY"

	dbSelectArea("QUERY")
	QUERY->(dbGoTop())
*/

ZZA->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("ZZA",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZA_DATA",,cFor,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())

while QUERY->(!eof())

	if QUERY->ZZA_ITEMIC == _cItemConta

		//if alltrim(QUERY->E5_TIPODOC) <> "CH"
		RecLock("TRB1",.T.)
		
		//MsProcTxt("Processando registro: "+alltrim(QUERY->ZZA_NUM))
		//ProcessMessage()
		
		TRB1->DATAMOV	:= QUERY->ZZA_DATA
		TRB1->TIPO		:= QUERY->ZZA_TIPO
		TRB1->NUMERO	:= QUERY->ZZA_NUM

		TRB1->ID		:= "CDV"
		TRB1->DESCRICAO	:= "CUSTOS DIVERSOS 2"
		
		TRB1->IDUSA		:= "108"
		TRB1->DESCUSA	:= "OUTRAS AQUISICOES"

		TRB1->PRODUTO	:= ""
		TRB1->HISTORICO	:= QUERY->ZZA_DESCR
		TRB1->QUANTIDADE:= 0
		TRB1->UNIDADE	:= ""
		TRB1->VALOR		:= QUERY->ZZA_VALOR
		TRB1->VALOR2	:= QUERY->ZZA_VALOR
		TRB1->CODFORN	:= ""
		TRB1->FORNECEDOR:= ""
		TRB1->CFOP		:= ""
		TRB1->NATUREZA	:= ""
		TRB1->DNATUREZA := ""
		TRB1->ORIGEM	:= "CD"
		TRB1->ITEMCONTA := QUERY->ZZA_ITEMIC
		TRB1->CAMPO		:= "VLREMP"
		MsUnlock()

	endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Processa Custo Contabil				                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function CT401REAL()

Local nSaldoAnt := 0
local _cQuery := ""
Local _cFilCQ5 := xFilial("CQ5")
Local cFor

_cQuery := "SELECT CQ5_FILIAL, CQ5_ITEM, CQ5_MOEDA, CQ5_LP, CQ5_CONTA, CAST(CQ5_DATA AS DATE) AS TMP_DTCQ5, CQ5_DEBITO, CQ5_CREDIT   FROM CQ5010  WHERE  D_E_L_E_T_ <> '*' AND CQ5_ITEM = '" + _cItemConta + "' ORDER BY CQ5_DATA"

	IF Select("_cQuery") <> 0
		DbSelectArea("_cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery NEW ALIAS "QUERY"

	dbSelectArea("QUERY")
	QUERY->(dbGoTop())

/*
CQ5->(dbsetorder(7))

ChkFile("CQ5",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"CQ5_DATA",,,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))
*/
QUERY->(dbgotop())
//if CQ5->(msseek(ALLTRIM(_cFilial+_cItemConta)))

	while QUERY->(!eof()) 
		if QUERY->CQ5_ITEM <> _cItemConta 
			QUERY->(dbskip())
		else
		if  QUERY->CQ5_FILIAL == "01" .AND. QUERY->CQ5_ITEM == _cItemConta .AND. ALLTRIM(QUERY->CQ5_MOEDA) == "01" .AND. ALLTRIM(QUERY->CQ5_LP) <> "Z" .AND. LEFT(ALLTRIM(QUERY->CQ5_CONTA),1) == "5" ;
			.OR.;
			 QUERY->CQ5_FILIAL == "01" .AND. QUERY->CQ5_ITEM == _cItemConta .AND. ALLTRIM(QUERY->CQ5_MOEDA) == "01" .AND. ALLTRIM(QUERY->CQ5_LP) <> "Z" .AND. ALLTRIM(QUERY->CQ5_CONTA) == "621020001"
	
			RecLock("TRB1",.T.)
			
			//MsProcTxt("Processando registro: "+alltrim(QUERY->CQ5_CONTA))
			//ProcessMessage()
			
			TRB1->DATAMOV	:= QUERY->TMP_DTCQ5
			TRB1->ORIGEM	:= "CC"
			TRB1->CONTA	:= QUERY->CQ5_CONTA
			TRB1->ID		:= "MPR"
			TRB1->DESCRICAO:= "MATERIA-PRIMA"
			
			cGrProd			:= POSICIONE("CT1",1,XFILIAL("CT1")+QUERY->CQ5_CONTA,"CT1_XIDUSA")
			TRB1->IDUSA		:= POSICIONE("CT1",1,XFILIAL("CT1")+QUERY->CQ5_CONTA,"CT1_XIDUSA")
		
			TRB1->DESCUSA	:= alltrim(POSICIONE("ZZL",1,XFILIAL("ZZL")+cGrProd,"ZZL_DESC"))
	
			if alltrim(QUERY->CQ5_CONTA) == "621020001"
				TRB1->ID		:= "CMS"
				TRB1->DESCRICAO:= "COMISSAO"
			endif
	
			if alltrim(QUERY->CQ5_CONTA) $ ;
						"511010004/511020004/511030004/511040004/512010004/512020004/512030004/513010004/513020004/" + ;
	  					"514010004/514020004/514030004/515010001/515010002/518010004/518020004/518030004/518040004/" + ;
	  					"518050004/518060004/518070004/518080004/518090004/516010002/516020002/518100002/518110002"
	  			TRB1->ID		:= "CDV"
				TRB1->DESCRICAO:= "CUSTO DIVERSOS"
	  		endif
	
	  		if alltrim(QUERY->CQ5_CONTA) $ ;
						"511010002/511020002/511030002/511040002/512010002/512020002/512030002/513010002/513020002/514010002/" + ;
						"514020002/514030002/518010002/518020002/518030002/518040002/518050002/518060002/518070002/518080002/518090002"
	  			TRB1->ID		:= "EBR"
				TRB1->DESCRICAO:= "ENGENHARIA BR"
	  		endif
	
	  		if alltrim(QUERY->CQ5_CONTA) $ ;
						"511010003/511020003/511030003/511040003/512010003/512020003/512030003/513010003/513020003/514010003"  + ;
						"514020003/514030003/518010003/518020003/518030003/518040003/518050003/518060003/518070003/518080003/518090003"
	  			TRB1->ID		:= "FRT"
				TRB1->DESCRICAO:= "FRETE"
	  		endif
	
	  		if alltrim(QUERY->CQ5_CONTA) $ ;
						"511010006/511010007/511020006/511020007/511030006/511030007/511040006/511040007/512010006/512010007/" +  ;
						"512020006/512020007/512030006/512030007/513010006/513010007/513020006/513020007/514010006/514010007/" +  ;
						"514020006/514020007/514030006/514030007/518010006/518010007/518020006/518020007/518030006/518030007/" +  ;
						"518040006/518040007/518050006/518050007/518060006/518060007/518070006/518070007/518080006/518080007/" +  ;
						"518090006/518090007"
	  			TRB1->ID		:= "IDL"
				TRB1->DESCRICAO:= "INSPECAO / DILIGENCIAMENTO"
	  		endif
	
	  		if alltrim(QUERY->CQ5_CONTA) $ ;
						"511010001/511020001/511030001/511040001/512010001/512020001/512030001/514010001/514020001/518010001" + ;
						"518020001/518030001/518040001/518050001/518060001/518070001/513010001"
	  			TRB1->ID		:= "MPR"
				TRB1->DESCRICAO:= "MATERIA PRIMA"
	  		endif
	
	  		if alltrim(QUERY->CQ5_CONTA) $ ;
						"511010008/511020008/511030008/511040008/512010008/512020008/512030008/513010008/513020008/514010008/" + ;
						"514020008/514030008/518010008/518020008/518030008/518040008/518050008/518060008/518070008/518080008/518090008"
	  			TRB1->ID		:= "RDV"
				TRB1->DESCRICAO:= "RELATORIO DE VIAGEM"
	  		endif
	
			if alltrim(QUERY->CQ5_CONTA) $ ;
						"511010005/511020005/511030005/511040005/512010005/512020005/512030005/513010005/513020005/514010005/" + ;
						"514020005/514030005/518010005/518020005/518030005/518040005/518050005/518060005/518070005/518080005/518090005"
	  			TRB1->ID		:= "SRV"
				TRB1->DESCRICAO:= "SERVICOS"
	  		endif
	
			TRB1->HISTORICO:= alltrim(POSICIONE("CT1",1,XFILIAL("CT1")+QUERY->CQ5_CONTA,"CT1_DESC01"))
			TRB1->VDEBITO	:= QUERY->CQ5_DEBITO
			TRB1->VCREDITO := QUERY->CQ5_CREDIT
	
			TRB1->VSALDO	:= nSaldoAnt + (QUERY->CQ5_DEBITO - QUERY->CQ5_CREDIT)
	
			nSaldoAnt :=  nSaldoAnt + (QUERY->CQ5_DEBITO - QUERY->CQ5_CREDIT)
	
			TRB1->ITEMCONTA:= QUERY->CQ5_ITEM
			TRB1->CAMPO		:= "VLRCTB"
	
			MsUnlock()

		endif
	
		QUERY->(dbskip())
		
		endif
	
	enddo

//endif

QUERY->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Processa Custo Contabil				                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function CT401EST()

Local nSaldoAnt := 0
local _cQuery := ""
Local _cFilCQ5 := xFilial("CQ5")

_cQuery := "SELECT CQ5_FILIAL, CQ5_ITEM, CQ5_MOEDA, CQ5_LP, CQ5_CONTA, CAST(CQ5_DATA AS DATE) AS TMP_DTCQ5, CQ5_DEBITO, CQ5_CREDIT  FROM CQ5010  WHERE  D_E_L_E_T_ <> '*' AND CQ5_ITEM = '" + _cItemConta + "'  ORDER BY CQ5_DATA"

	IF Select("_cQuery") <> 0
		DbSelectArea("_cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery NEW ALIAS "QUERY"

	dbSelectArea("QUERY")
	QUERY->(dbGoTop())

/*
//CQ5->(dbsetorder(7)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CQ5",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"CQ5_DATA",,,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())
*/
//if CQ5->(msseek(ALLTRIM(_cFilial+_cItemConta)))



	while QUERY->(!eof())
	
	if QUERY->CQ5_ITEM <> _cItemConta 
		QUERY->(dbskip())
	else
		if QUERY->CQ5_FILIAL == "01" .AND. QUERY->CQ5_ITEM == _cItemConta .AND. ALLTRIM(QUERY->CQ5_MOEDA) == "01" .AND. ALLTRIM(QUERY->CQ5_LP) <> "Z" .AND. LEFT(ALLTRIM(QUERY->CQ5_CONTA),3) == "113" ;
			.OR.;
			 QUERY->CQ5_FILIAL == "01" .AND. QUERY->CQ5_ITEM == _cItemConta .AND. ALLTRIM(QUERY->CQ5_MOEDA) == "01" .AND. ALLTRIM(QUERY->CQ5_LP) <> "Z" .AND. ALLTRIM(QUERY->CQ5_CONTA) == "113060008"
	
	
			RecLock("TRB1",.T.)
			
			//MsProcTxt("Processando registro: "+alltrim(QUERY->CQ5_CONTA))
			//ProcessMessage()
			
			TRB1->DATAMOV	:= QUERY->TMP_DTCQ5
			TRB1->ORIGEM	:= "CE"
			TRB1->CONTA		:= QUERY->CQ5_CONTA
			TRB1->ID		:= "MPR"
			TRB1->DESCRICAO	:= "MATERIA-PRIMA"
			
	
			cGrProd			:= POSICIONE("CT1",1,XFILIAL("CT1")+QUERY->CQ5_CONTA,"CT1_XIDUSA")
			TRB1->IDUSA		:= POSICIONE("CT1",1,XFILIAL("CT1")+QUERY->CQ5_CONTA,"CT1_XIDUSA")
		
			TRB1->DESCUSA	:= alltrim(POSICIONE("ZZL",1,XFILIAL("ZZL")+cGrProd,"ZZL_DESC"))
	
			if alltrim(QUERY->CQ5_CONTA) == "113060008"
				TRB1->ID		:= "CMS"
				TRB1->DESCRICAO:= "COMISSAO"
			endif
	
			if alltrim(QUERY->CQ5_CONTA) $ ;
						"113070002/113080024/113080025/113080026/113060007"
	  			TRB1->ID		:= "CDV"
				TRB1->DESCRICAO:= "CUSTO DIVERSOS"
	  		endif
	
	  		if alltrim(QUERY->CQ5_CONTA) $ ;
						"113010002/113030017/113030018/113040016/113080021"
	  			TRB1->ID		:= "COM"
				TRB1->DESCRICAO:= "COMERCIAIS"
	  		endif
	
	  		if alltrim(QUERY->CQ5_CONTA) $ ;
	  					"113060001/113060006"
	  			TRB1->ID		:= "EBR"
				TRB1->DESCRICAO:= "ENGENHAR�IA BR"
	  		endif
	
	  		if alltrim(QUERY->CQ5_CONTA) $ ;
						"113060002"
	  			TRB1->ID		:= "FRT"
				TRB1->DESCRICAO:= "FRETE"
	  		endif
	
	  		if alltrim(QUERY->CQ5_CONTA) $ ;
	  					"113020002/113050002/113080022"
	  			TRB1->ID		:= "MPR"
				TRB1->DESCRICAO:= "MATERIA PRIMA"
	  		endif
	
	  		if alltrim(QUERY->CQ5_CONTA) $ ;
	  					"113060004/113060005"
	  			TRB1->ID		:= "RDV"
				TRB1->DESCRICAO:= "RELATORIO DE VIAGEM"
	  		endif
	
			if alltrim(QUERY->CQ5_CONTA) $ ;
						"113060003/113080023"
	  			TRB1->ID		:= "SRV"
				TRB1->DESCRICAO:= "SERVICOS"
	  		endif
	
			TRB1->HISTORICO:= alltrim(POSICIONE("CT1",1,XFILIAL("CT1")+QUERY->CQ5_CONTA,"CT1_DESC01"))
			TRB1->VDEBITO	:= QUERY->CQ5_DEBITO
			TRB1->VCREDITO := QUERY->CQ5_CREDIT
	
			TRB1->VSALDO	:= nSaldoAnt + (QUERY->CQ5_DEBITO - QUERY->CQ5_CREDIT)
	
			nSaldoAnt :=  nSaldoAnt + (QUERY->CQ5_DEBITO - QUERY->CQ5_CREDIT)
	
			TRB1->ITEMCONTA:= QUERY->CQ5_ITEM
			TRB1->CAMPO		:= "VLRCTBE"
	
			MsUnlock()
	
	
		endif
	
		QUERY->(dbskip())
	endif
	enddo
//endif
 

QUERY->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Processa Custo Contabil				                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function CT401REC()

Local nSaldoAnt := 0
local cQuery := ""
Local _cFilCQ5 := xFilial("CQ5")

//_cItemConta 	:= ALLTRIM(MV_PAR01)

//msginfo ( _cItemConta )

//local _cNatureza

_cQuery := "SELECT CQ5_FILIAL, CQ5_ITEM, CQ5_MOEDA, CQ5_LP, CQ5_CONTA, CAST(CQ5_DATA AS DATE) AS TMP_DTCQ5, CQ5_DEBITO, CQ5_CREDIT  FROM CQ5010  WHERE  D_E_L_E_T_ <> '*' AND CQ5_ITEM = '" + _cItemConta + "' ORDER BY CQ5_DATA"

	IF Select("_cQuery") <> 0
		DbSelectArea("_cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery NEW ALIAS "QUERY"

	dbSelectArea("QUERY")
	QUERY->(dbGoTop())

/*
CQ5->(dbsetorder(7)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CQ5",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"CQ5_DATA",,,"Selecionando Registros...")


ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())
*/
//if CQ5->(msseek(ALLTRIM(_cFilial+_cItemConta)))

	while QUERY->(!eof()) 
	
	if QUERY->CQ5_ITEM <> _cItemConta
		QUERY->(dbskip())
	else
	
		if QUERY->CQ5_FILIAL == "01" .AND. QUERY->CQ5_ITEM == _cItemConta .AND. ALLTRIM(QUERY->CQ5_MOEDA) == "01" .AND. ALLTRIM(QUERY->CQ5_LP) <> "Z" .AND. LEFT(ALLTRIM(QUERY->CQ5_CONTA),1) == "4"
	
			RecLock("TRB4",.T.)
			
			//MsProcTxt("Processando registro: "+alltrim(QUERY->CQ5_CONTA))
			//ProcessMessage()
			
			TRB4->RDATAMOV	:= QUERY->TMP_DTCQ5
			TRB4->RORIGEM	:= "CB"
			TRB4->RCONTA	:= QUERY->CQ5_CONTA
			TRB4->RID		:= "REC"
			TRB4->RDESCRICAO:= "RECEITA CONTABIL"
			TRB4->RHISTORICO:= alltrim(POSICIONE("CT1",1,XFILIAL("CT1")+QUERY->CQ5_CONTA,"CT1_DESC01"))
			TRB4->RVDEBITO	:= QUERY->CQ5_DEBITO
			TRB4->RVCREDITO := QUERY->CQ5_CREDIT
	
			TRB4->RVSALDO	:= nSaldoAnt + (QUERY->CQ5_CREDIT - QUERY->CQ5_DEBITO  )
	
			nSaldoAnt :=  nSaldoAnt + (QUERY->CQ5_CREDIT - QUERY->CQ5_DEBITO )
	
			TRB4->RITEMCONTA:= QUERY->CQ5_ITEM
			TRB4->RCAMPO		:= "RECCTB"
	
			MsUnlock()
	
	
		endif
	
		QUERY->(dbskip())
	endif
	enddo

//endif

QUERY->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Gera o Arquivo Sintetico                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function GC01SINT()
local _nPos 	:= 0
local _cQuery 	:= ""
local _nSaldo 	:= 0

Local nMPRVal 	:= 0
Local nMPRTot	:= 0

Local nMPRValC 	:= 0
Local nMPRTotC	:= 0

Local nMPRValE 	:= 0
Local nMPRTotE	:= 0

Local nMPRValP 	:= 0
Local nMPRTotP	:= 0

Local nMPRValV 	:= 0
Local nMPRTotV	:= 0

Local nFABVal 	:= 0
Local nFABTot	:= 0

Local nFABValC 	:= 0
Local nFABTotC	:= 0

Local nFABValE 	:= 0
Local nFABTotE	:= 0

Local nFABValV 	:= 0
Local nFABTotV	:= 0

Local nFABValP 	:= 0
Local nFABTotP	:= 0

Local nCOMVal 	:= 0
Local nCOMTot	:= 0

Local nCOMValC 	:= 0
Local nCOMTotC	:= 0

Local nCOMValE 	:= 0
Local nCOMTotE	:= 0

Local nCOMValP 	:= 0
Local nCOMTotP	:= 0

Local nCOMValV 	:= 0
Local nCOMTotV	:= 0

Local nEBRVal 	:= 0
Local nEBRTot	:= 0

Local nEBRValC 	:= 0
Local nEBRTotC	:= 0

Local nEBRValE 	:= 0
Local nEBRTotE	:= 0

Local nEBRValP 	:= 0
Local nEBRTotP	:= 0

Local nEBRValV 	:= 0
Local nEBRTotV	:= 0

Local nESLVal 	:= 0
Local nESLTot	:= 0

Local nESLValC 	:= 0
Local nESLTotC	:= 0

Local nESLValE 	:= 0
Local nESLTotE	:= 0

Local nESLValP 	:= 0
Local nESLTotP	:= 0

Local nESLValV 	:= 0
Local nESLTotV	:= 0

Local nCTRVal 	:= 0
Local nCTRTot	:= 0

Local nCTRValC 	:= 0
Local nCTRTotC	:= 0

Local nCTRValE 	:= 0
Local nCTRTotE	:= 0

Local nCTRValP 	:= 0
Local nCTRTotP	:= 0

Local nCTRValV 	:= 0
Local nCTRTotV	:= 0

Local nIDLVal 	:= 0
Local nIDLTot	:= 0

Local nIDLValC 	:= 0
Local nIDLTotC	:= 0

Local nIDLValE 	:= 0
Local nIDLTotE	:= 0

Local nIDLValP 	:= 0
Local nIDLTotP	:= 0

Local nIDLValV 	:= 0
Local nIDLTotV	:= 0

Local nLABVal 	:= 0
Local nLABTot	:= 0

Local nLABValC 	:= 0
Local nLABTotC	:= 0

Local nLABValE 	:= 0
Local nLABTotE	:= 0

Local nLABValP 	:= 0
Local nLABTotP	:= 0

Local nLABValV 	:= 0
Local nLABTotV	:= 0

Local nFINVal 	:= 0
Local nFINTot	:= 0

Local nFINValC 	:= 0
Local nFINTotC	:= 0

Local nFINValE 	:= 0
Local nFINTotE	:= 0

Local nFINValP 	:= 0
Local nFINTotP	:= 0

Local nFINValV 	:= 0
Local nFINTotV	:= 0

Local nCMSVal 	:= 0
Local nCMSTot	:= 0

Local nCMSValE 	:= 0
Local nCMSTotE	:= 0

Local nCMSValC 	:= 0
Local nCMSTotC	:= 0

Local nCMSValP 	:= 0
Local nCMSTotP	:= 0

Local nCMSValV 	:= 0
Local nCMSTotV	:= 0

Local nRDVVal 	:= 0
Local nRDVTot	:= 0

Local nRDVValC 	:= 0
Local nRDVTotC	:= 0

Local nRDVValE 	:= 0
Local nRDVTotE	:= 0

Local nRDVValP 	:= 0
Local nRDVTotP	:= 0

Local nRDVValV 	:= 0
Local nRDVTotV	:= 0

Local nFRTVal 	:= 0
Local nFRTTot	:= 0

Local nFRTValC 	:= 0
Local nFRTTotC	:= 0

Local nFRTValE 	:= 0
Local nFRTTotE	:= 0

Local nFRTValP 	:= 0
Local nFRTTotP	:= 0

Local nFRTValV 	:= 0
Local nFRTTotV	:= 0

Local nCDVVal 	:= 0
Local nCDVTot	:= 0

Local nCDVValC 	:= 0
Local nCDVTotC	:= 0

Local nCDVValE 	:= 0
Local nCDVTotE	:= 0

Local nCDVValP	:= 0
Local nCDVTotP	:= 0

Local nCDVValV	:= 0
Local nCDVTotV	:= 0

Local nSRVVal 	:= 0
Local nSRVTot	:= 0

Local nSRVValC 	:= 0
Local nSRVTotC	:= 0

Local nSRVValE 	:= 0
Local nSRVTotE	:= 0

Local nSRVValP 	:= 0
Local nSRVTotP 	:= 0

Local nSRVValV 	:= 0
Local nSRVTotV 	:= 0

Local nCPRVal	:= 0
Local nCPRTot	:= 0
Local nCTOVal	:= 0
Local nCTOTot	:= 0
Local nCTOTotC	:= 0
Local nCPRTotC	:= 0

Local nCTOTotE	:= 0
Local nCPRTotE	:= 0

Local nCTOTotP	:= 0
Local nCPRTotP	:= 0

Local nCTOTotV	:= 0
Local nCPRTotV	:= 0

Local nCPRTotR	:= 0

Local nCPRVal2	:= 0
Local nCPRTot2	:= 0
Local nCTOVal2	:= 0
Local nCTOTot2	:= 0
Local nCTOTotC2	:= 0
Local nCPRTotC2	:= 0

Local nCTOTotE2	:= 0
Local nCPRTotE2	:= 0

Local nCTOTotP2	:= 0
Local nCPRTotP2	:= 0

Local nCTOTotV2	:= 0
Local nCPRTotV2	:= 0

Local nCPRTotR2	:= 0

Local nXSISFV	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XSISFV")
Local nXSISFR	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XSISFR")


Local nXVDSIR	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XVDSIR")
Local nXVDSI	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XVDSI")
Local nXCUSTO	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XCUSTO")
Local nOUTCUS1	:= 0
Local nOUTCUS2	:= 0


//Variaveis Vendido
Local  nGT101 := 0, nGT102 := 0, nGT103 := 0, nGT104 := 0, nGT105 := 0, nGT106 := 0, nGT107 := 0, nGT108 := 0, nGT109 := 0, nGT199 := 0
Local  nGT201 := 0, nGT202 := 0, nGT204 := 0, nGT205 := 0, nGT206 := 0, nGT207 := 0, nGT209 := 0
Local  nGT210 := 0, nGT211 := 0, nGT212 := 0, nGT213 := 0, nGT217 := 0, nGT218 := 0, nGT220 := 0, nGT221 := 0, nGT222 := 0, nGT299 := 0
Local  nGT301 := 0, nGT501 := 0, nGT601 := 0, nGT701 := 0
//Variaveis planejado
Local  nGP101 := 0, nGP102 := 0, nGP103 := 0, nGP104 := 0, nGP105 := 0, nGP106 := 0, nGP107 := 0, nGP108 := 0, nGP109 := 0, nGP199 := 0
Local  nGP201 := 0, nGP202 := 0, nGP204 := 0, nGP205 := 0, nGP206 := 0, nGP207 := 0, nGP209 := 0
Local  nGP210 := 0, nGP211 := 0, nGP212 := 0, nGP213 := 0, nGP217 := 0, nGP218 := 0, nGP220 := 0, nGP221 := 0, nGP222 := 0, nGP299 := 0
Local  nGP301 := 0, nGP501 := 0, nGP601 := 0, nGP701 := 0
//Variaveis empenhado
Local  nGE101 := 0, nGE102 := 0, nGE103 := 0, nGE104 := 0, nGE105 := 0, nGE106 := 0, nGE107 := 0, nGE108 := 0, nGE109 := 0, nGE199 := 0
Local  nGE201 := 0, nGE202 := 0, nGE204 := 0, nGE205 := 0, nGE206 := 0, nGE207 := 0, nGE209 := 0
Local  nGE210 := 0, nGE211 := 0, nGE212 := 0, nGE213 := 0, nGE217 := 0, nGE218 := 0, nGE220 := 0, nGE221 := 0, nGE222 := 0, nGE299 := 0
Local  nGE301 := 0, nGE501 := 0, nGE601 := 0, nGE701 := 0
Local  nGE801 := 0, nGE802 := 0, nGE803 := 0, nGE804 := 0, nGE805 := 0, nGE806 := 0
Local  nGE901 := 0, nGE902 := 0, nGE903 := 0, nGE904 := 0, nGE905 := 0, nGE906 := 0, nGE908 := 0
//Variaveis contabil estoque
Local  nGCE101 := 0, nGCE102 := 0, nGCE103 := 0, nGCE104 := 0, nGCE105 := 0, nGCE106 := 0, nGCE107 := 0, nGCE108 := 0, nGCE109 := 0, nGCE199 := 0
Local  nGCE201 := 0, nGCE202 := 0, nGCE204 := 0, nGCE205 := 0, nGCE206 := 0, nGCE207 := 0, nGCE209 := 0
Local  nGCE210 := 0, nGCE211 := 0, nGCE212 := 0, nGCE213 := 0, nGCE217 := 0, nGCE218 := 0, nGCE220 := 0, nGCE221 := 0, nGCE222 := 0, nGCE299 := 0
Local  nGCE301 := 0, nGCE501 := 0, nGCE601 := 0, nGCE701 := 0
//Variaveis contabil reconhecido
Local  nGCR101 := 0, nGCR102 := 0, nGCR103 := 0, nGCR104 := 0, nGCR105 := 0, nGCR106 := 0, nGCR107 := 0, nGCR108 := 0, nGCR109 := 0, nGCR199 := 0
Local  nGCR201 := 0, nGCR202 := 0, nGCR204 := 0, nGCR205 := 0, nGCR206 := 0, nGCR207 := 0, nGCR209 := 0
Local  nGCR210 := 0, nGCR211 := 0, nGCR212 := 0, nGCR213 := 0, nGCR217 := 0, nGCR218 := 0, nGCR220 := 0, nGCR221 := 0, nGCR222 := 0, nGCR299 := 0
Local  nGCR301 := 0, nGCR501 := 0, nGCR601 := 0, nGCR701 := 0
Local nTotReg := 0
private _cOrdem := "000001"

/*DbSelectArea("ZZP")
Reclock("ZZP",.F.)
	ZZP->(DbDelete())
MsUnlock()*/

dbSelectArea("ZZP")
ZZP->( dbGoTop() )
ZZP->(dbSetOrder(1) ) 


cQuery2 := " SELECT R_E_C_N_O_ AS 'RECNO' FROM ZZP010 WHERE R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_)  FROM ZZP010) "
TCQuery cQuery2 New Alias "TZZP"

//_cItemConta 	:= ALLTRIM(MV_PAR01)

	//Reclock("ZZP",.F.)
	//*********************** CUSTO DE PRODUCAO******************************
	ZZP->( DBAppend( .F. ) )
		R_E_C_N_O_			:= TZZP->RECNO+1
		ZZP->ZZP_FILIAL		:= "01"
		ZZP->ZZP_DESUSA		:= "CUSTO PRODUCAO"
		ZZP->ZZP_IDUSA		:= "000"
		ZZP->ZZP_ID			:= "XX1"
		ZZP->ZZP_ORDEM		:= _cOrdem
		ZZP->ZZP_XIDPM		:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XIDPM")
		//ZZP->ZZP_XNOMPM	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XNOMPM")
		ZZP->ZZP_ITEMCT := _cItemConta
		// VENDIDO
		IF nTotRegZZM > 0
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if !TRB1->IDUSA $ ("801/900/901/902/903/904/905/906/908")  .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD" 
					nCPRValV		:= TRB1->VALOR
					nCPRTotV		+= nCPRValV
				endif
				TRB1->(dbskip())
			EndDo
		else
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if TRB1->ID <> "CMS"  .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD" 
					nCPRValV		:= TRB1->VALOR
					nCPRTotV		+= nCPRValV
				endif
				TRB1->(dbskip())
			EndDo
		endif

		ZZP->ZZP_VLRVD	:= nCPRTotV  // nCPRTotV + (nXCUSTO * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCONT")/100))
		ZZP->ZZP_PERVD 	:= (nCPRTotV   / nXVDSIR )*100 //((nCPRTotV + (nXCUSTO * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCONT")/100)))  / nXVDSIR )*100

		// PLNAJEDO
		IF nTotRegZZN > 0
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if !TRB1->IDUSA $ ("801/900/901/902/903/904/905/906/908")  .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
					nCPRValP		:= TRB1->VALOR
					nCPRTotP		+= nCPRValP
				endif
				TRB1->(dbskip())
			EndDo
		ELSE
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if TRB1->ID <> "CMS"  .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
					nCPRValP		:= TRB1->VALOR
					nCPRTotP		+= nCPRValP
				endif
				TRB1->(dbskip())
			EndDo
		ENDIF

		ZZP->ZZP_VLRPLN := nCPRTotP //+ (nXCUSTO * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCONT")/100))
		ZZP->ZZP_PERPLN := (nCPRTotP  / nXVDSIR )*100  // ((nCPRTotP + (nXCUSTO * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCONT")/100)))  / nXVDSIR )*100 

		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if !TRB1->IDUSA $ ("801/802/803/804/805/806/908") .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP" // TRB1->ID <> "CMS"  .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP" .OR. 
				nCPRVal		:= TRB1->VALOR  //SC7->C7_XTOTSI
				nCPRTot		+= nCPRVal
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo

		ZZP->ZZP_VLREMP := nCPRTot
		ZZP->ZZP_PEREMP	:= (nCPRTot / nXVDSIR )*100

		//  CUSTO CONTABIL
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->ID <> "CMS"  .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTB"
				nCPRTotC	+= (TRB1->VDEBITO - TRB1->VCREDITO)
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo

		//  CUSTO CONTABIL ESTOQUE
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->ID <> "CMS" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
				nCPRTotE	+= (TRB1->VDEBITO - TRB1->VCREDITO)
			endif
			TRB1->(dbskip())
		EndDo

		// RECEITA CONTABIL
		TRB4->(dbgotop())
		While TRB4->( ! EOF() )
			if TRB4->RID == "REC"
				nCPRTotR	+= (TRB4->RVCREDITO - TRB4->RVDEBITO )
			endif
			TRB4->(dbskip()) //SC7->(dbskip())
		EndDo

		ZZP->ZZP_VLRCTB := nCPRTotC
		ZZP->ZZP_PERCTB	:= (nCPRTotC / nCPRTotR )*100

		ZZP->ZZP_VLRCTBE := nCPRTotE
		ZZP->ZZP_PERCTBE	:= (nCPRTotE / nXVDSIR )*100

	
		//_nRecSaldo 	:= ZZP->(recno()) // Guarda o recno da linha de saldo
		//_cOrdem := soma1(_cOrdem)
	ZZP->( DBCommit() )
	TZZP->(dbclosearea())
	//MsUnlock()	

		//*********************** MARGEM BRUTA ********************************
	cQuery2 := " SELECT R_E_C_N_O_ AS 'RECNO' FROM ZZP010 WHERE R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_)  FROM ZZP010) "
	TCQuery cQuery2 New Alias "TZZP"

	ZZP->( DBAppend( .F. ) )
		ZZP->ZZP_FILIAL		:= "01"
		ZZP->ZZP_DESUSA		:= "MARGEM BRUTA"
		ZZP->ZZP_IDUSA		:= "000"
		ZZP->ZZP_ID		:= "MKB"
		ZZP->ZZP_DESCRI	:= ""
		ZZP->ZZP_ORDEM		:= _cOrdem
		ZZP->ZZP_XIDPM		:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XIDPM")
		//ZZP->ZZP_XNOMPM	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XNOMPM")
		ZZP->ZZP_ITEMCT := _cItemConta

		ZZP->ZZP_VLRVD	:= nXVDSI - nCPRTotV 
		ZZP->ZZP_PERVD	:= ((nXVDSI - nCPRTotV) / nXVDSI )*100

		ZZP->ZZP_VLRPLN	:= nXVDSIR - nCPRTotP 
		ZZP->ZZP_PERPLN	:= ((nXVDSIR - nCPRTotP) / nXVDSIR )*100

		ZZP->ZZP_VLREMP	:= nXVDSIR - nCPRTot
		ZZP->ZZP_PEREMP	:= ((nXVDSIR - nCPRTot) / nXVDSIR )*100

		ZZP->ZZP_VLRCTB	:= nCPRTotR - nCPRTotC
		ZZP->ZZP_PERCTB	:= ((nCPRTotR - nCPRTotC) / nCPRTotR ) *100
		ZZP->( DBCommit() )
	//_nRecSaldo 	:= ZZP->(recno()) // Guarda o recno da linha de saldo
	//_cOrdem := soma1(_cOrdem)
		TZZP->(dbclosearea())
	
	//*********************** CALCULO GRUPO 801/901/902/903/904/905/906/908 NOVO SISTEMA ********************************
	// 901 OUTROS CUSTOS NOVOS
	IF nTotRegZZM > 0 .OR. nTotRegZZN > 0
		
		//*********************** COGS ********************************
		cQuery2 := " SELECT R_E_C_N_O_ AS 'RECNO' FROM ZZP010 WHERE R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_)  FROM ZZP010) "
		TCQuery cQuery2 New Alias "TZZP"
	
		ZZP->( DBAppend( .F. ) )
			ZZP->ZZP_FILIAL		:= "01"
			ZZP->ZZP_ID			:= "XX1"
			ZZP->ZZP_IDUSA		:= "000"
			ZZP->ZZP_DESUSA		:= "COGS"
			ZZP->ZZP_ORDEM		:= _cOrdem
			ZZP->ZZP_XIDPM		:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XIDPM")
			//ZZP->ZZP_XNOMPM	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XNOMPM")
			ZZP->ZZP_ITEMCT := _cItemConta
			
			// VENDIDO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if ALLTRIM(TRB1->CAMPO) == "VLRVD" .AND. !TRB1->IDUSA $ ('901/908')
					nCTOValV2		:= TRB1->VALOR  //SC7->C7_XTOTSI
					nCTOTotV2		+= nCTOValV2
				endif
				TRB1->(dbskip()) //SC7->(dbskip())
			EndDo

			ZZP->ZZP_VLRVD := nCTOTotV2
			ZZP->ZZP_PERVD	:= (nCTOTotV2 / nXVDSI )*100
			
			// PLANEJADO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if ALLTRIM(TRB1->CAMPO) == "VLRPLN" .AND. !TRB1->IDUSA $ ('901/908')
					nCTOValP2		:= TRB1->VALOR  //SC7->C7_XTOTSI
					nCTOTotP2		+= nCTOValP2
				endif
				TRB1->(dbskip()) //SC7->(dbskip())
			EndDo

			ZZP->ZZP_VLRPLN := (nCTOTotP2 )
			ZZP->ZZP_PERPLN	:= ((nCTOTotP2) / nXVDSIR )*100
			
			// EMPENHADO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				
				if  ALLTRIM(TRB1->CAMPO) == "VLREMP" .AND. ALLTRIM(TRB1->ID) <> "CMS" .AND. !TRB1->IDUSA $ ('901/908')
					nCTOTot2		+= TRB1->VALOR
				endif

				TRB1->(dbskip())
			EndDo
			ZZP->ZZP_VLREMP 	:= nCTOTot2
			ZZP->ZZP_PEREMP	:= (nCTOTot2 / nXVDSIR )*100
			
			// CUSTO CONTABIL
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if  ALLTRIM(TRB1->CAMPO) == "VLRCTB" .AND. ALLTRIM(TRB1->ID) <> "CMS" .AND. !TRB1->IDUSA $ ('901/908')
					nCTOTotC2		+= (TRB1->VDEBITO - TRB1->VCREDITO)
				endif
				TRB1->(dbskip())
			EndDo
			
			// CUSTO CONTABIL ESTOQUE	
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if  ALLTRIM(TRB1->CAMPO) == "VLRCTBE" .AND. ALLTRIM(TRB1->ID) <> "CMS" .AND. !TRB1->IDUSA $ ('901/908')
					nCTOTotE2		+= (TRB1->VDEBITO - TRB1->VCREDITO)
				endif
				TRB1->(dbskip())
			EndDo

			ZZP->ZZP_VLRCTB := nCTOTotC2
			ZZP->ZZP_PERCTB	:= (nCTOTotC2 / nCPRTotR2 )*100

			ZZP->ZZP_VLRCTBE := nCTOTotE2
			ZZP->ZZP_PERCTBE	:= (nCTOTotE2 / nXVDSIR )*100

		
			//_nRecSaldo 	:= ZZP->(recno()) // Guarda o recno da linha de saldo
			//_cOrdem := soma1(_cOrdem)
			
		ZZP->( DBCommit() )
		TZZP->(dbclosearea())

		//*********************** CUSTO TOTAL ********************************
		cQuery2 := " SELECT R_E_C_N_O_ AS 'RECNO' FROM ZZP010 WHERE R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_)  FROM ZZP010) "
		TCQuery cQuery2 New Alias "TZZP"
		ZZP->( DBAppend( .F. ) )
			ZZP->ZZP_FILIAL		:= "01"
			ZZP->ZZP_DESUSA		:= "CUSTO TOTAL"
			ZZP->ZZP_ID				:= "XX2"
			ZZP->ZZP_IDUSA		:= "999"
			ZZP->ZZP_ORDEM		:= _cOrdem
			ZZP->ZZP_XIDPM		:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XIDPM")
			//ZZP->ZZP_XNOMPM	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XNOMPM")
			ZZP->ZZP_ITEMCT := _cItemConta
											
			// VENDIDO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if ALLTRIM(TRB1->CAMPO) == "VLRVD" .AND. !TRB1->IDUSA $ ("199/209/299/799/200/299/900/901/999") 
					nCTOValV		:= TRB1->VALOR  //SC7->C7_XTOTSI
					nCTOTotV		+= nCTOValV
				endif
				TRB1->(dbskip()) //SC7->(dbskip())
			EndDo

			ZZP->ZZP_VLRVD := nCTOTotV
			ZZP->ZZP_PERVD	:= ((nCTOTotV) / nXVDSIR )*100

			// PLANEJADO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if ALLTRIM(TRB1->CAMPO) == "VLRPLN" .AND. !TRB1->IDUSA $ ("199/209/299/799/200/299/900/901/999") 
					nCTOValP		:= TRB1->VALOR  //SC7->C7_XTOTSI
					nCTOTotP		+= nCTOValP
				endif
				TRB1->(dbskip()) //SC7->(dbskip())

			EndDo

			ZZP->ZZP_VLRPLN := nCTOTotP
			ZZP->ZZP_PERPLN	:= (nCTOTotP / nXVDSIR )*100

			// EMPENHADO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if  ALLTRIM(TRB1->CAMPO) == "VLREMP" .AND. ALLTRIM(TRB1->ID) <> "CMS"
					nCTOTot		+= TRB1->VALOR
				endif

				TRB1->(dbskip())
			EndDo
			ZZP->ZZP_VLREMP 	:= nCTOTot
			ZZP->ZZP_PEREMP	:= (nCTOTot / nXVDSIR )*100

			// CUSTO CONTABIL
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if  ALLTRIM(TRB1->CAMPO) == "VLRCTB"
					nCTOTotC		+= (TRB1->VDEBITO - TRB1->VCREDITO)
				endif
				TRB1->(dbskip())
			EndDo

			// CUSTO CONTABIL ESTOQUE
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if  ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
					nCTOTotE		+= (TRB1->VDEBITO - TRB1->VCREDITO)
				endif
				TRB1->(dbskip())
			EndDo

			ZZP->ZZP_VLRCTB := nCTOTotC
			ZZP->ZZP_PERCTB	:= (nCTOTotC / nCPRTotR )*100

			ZZP->ZZP_VLRCTBE := nCTOTotE
			ZZP->ZZP_PERCTBE	:= (nCTOTotE / nXVDSIR )*100

			
			//_nRecSaldo 	:= ZZP->(recno()) // Guarda o recno da linha de saldo
			//_cOrdem := soma1(_cOrdem)
			
			ZZP->( DBCommit() )
		 	TZZP->(dbclosearea())
		//*********************** MARGEM CONTRIBUICAO ********************************
	 	cQuery2 := " SELECT R_E_C_N_O_ AS 'RECNO' FROM ZZP010 WHERE R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_)  FROM ZZP010) "
		TCQuery cQuery2 New Alias "TZZP"
		ZZP->( DBAppend( .F. ) )
			ZZP->ZZP_FILIAL		:= "01"
			ZZP->ZZP_DESUSA	:= "MARGEM CONTRIB."
			ZZP->ZZP_ID		:= "MKC"
			ZZP->ZZP_IDUSA		:= "000"
			ZZP->ZZP_ORDEM		:= _cOrdem
			ZZP->ZZP_XIDPM		:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XIDPM")
			//ZZP->ZZP_XNOMPM	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XNOMPM")
			ZZP->ZZP_ITEMCT := _cItemConta

			ZZP->ZZP_VLRVD		:= nXVDSI - (nCTOTotV )
			ZZP->ZZP_PERVD		:= ((nXVDSI - (nCTOTotV )) / nXVDSI )*100

			ZZP->ZZP_VLRPLN	:= nXVDSIR - (nCTOTotP )
			ZZP->ZZP_PERPLN	:= ((nXVDSIR - (nCTOTotP )) / nXVDSIR )*100

			ZZP->ZZP_VLREMP	:= nXVDSIR - nCTOTot
			ZZP->ZZP_PEREMP	:= ((nXVDSIR - nCTOTot) / nXVDSIR )*100

			ZZP->ZZP_VLRCTB	:= nCPRTotR - nCTOTotC
			ZZP->ZZP_PERCTB	:= ((nCPRTotR - nCTOTotC) / nCPRTotR )*100
		ZZP->( DBCommit() )
		//_nRecSaldo 	:= ZZP->(recno()) // Guarda o recno da linha de saldo
		//_cOrdem := soma1(_cOrdem)
	 	TZZP->(dbclosearea())
		
	ELSE
		//*********************** COGS ********************************
		

		nOUTCUS3 := (nXCUSTO * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCONT")/100)) + (nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XFIANC")/100)) + ;
					(nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XCUSFI")/100)) + (nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPROVG")/100)) + ;
					(nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPERDI")/100)) +  (nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XROYAL")/100)) 
		
		cQuery2 := " SELECT R_E_C_N_O_ AS 'RECNO' FROM ZZP010 WHERE R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_)  FROM ZZP010) "
		TCQuery cQuery2 New Alias "TZZP"
		ZZP->( DBAppend( .F. ) )

			ZZP->ZZP_FILIAL		:= "01"
			ZZP->ZZP_ID			:= "XX1"
			ZZP->ZZP_IDUSA		:= "000"
			ZZP->ZZP_DESUSA		:= "COGS"
			ZZP->ZZP_ORDEM		:= _cOrdem
			ZZP->ZZP_XIDPM		:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XIDPM")
			//ZZP->ZZP_XNOMPM	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XNOMPM")
			ZZP->ZZP_ITEMCT 	:= _cItemConta
			
			// VENDIDO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if ALLTRIM(TRB1->CAMPO) == "VLRVD"
					nCTOValV2		:= TRB1->VALOR  //SC7->C7_XTOTSI
					nCTOTotV2		+= nCTOValV2
				endif
				TRB1->(dbskip()) //SC7->(dbskip())
			EndDo

			ZZP->ZZP_VLRVD := (nCTOTotV2 + nOUTCUS3)
			ZZP->ZZP_PERVD	:= ((nCTOTotV2+nOUTCUS3) / nXVDSI )*100

			// PLANEJADO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if ALLTRIM(TRB1->CAMPO) == "VLRPLN"
					nCTOValP2		:= TRB1->VALOR  //SC7->C7_XTOTSI
					nCTOTotP2		+= nCTOValP2
				endif
				TRB1->(dbskip()) //SC7->(dbskip())
			EndDo

			ZZP->ZZP_VLRPLN := (nCTOTotP2 + nOUTCUS3)
			ZZP->ZZP_PERPLN	:= ((nCTOTotP2+nOUTCUS3) / nXVDSIR )*100
			
			// EMPENHADO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				
				if  ALLTRIM(TRB1->CAMPO) == "VLREMP" .AND. ALLTRIM(TRB1->ID) <> "CMS"
					nCTOTot2		+= TRB1->VALOR
				endif

				TRB1->(dbskip())
			EndDo
			ZZP->ZZP_VLREMP 	:= nCTOTot2
			ZZP->ZZP_PEREMP	:= (nCTOTot2 / nXVDSIR )*100
			
			// CUSTO CONTABIL
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if  ALLTRIM(TRB1->CAMPO) == "VLRCTB" .AND. ALLTRIM(TRB1->ID) <> "CMS"
					nCTOTotC2		+= (TRB1->VDEBITO - TRB1->VCREDITO)
				endif
				TRB1->(dbskip())
			EndDo
				
			// CUSTO CONTABIL ESTOQUE	
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if  ALLTRIM(TRB1->CAMPO) == "VLRCTBE" .AND. ALLTRIM(TRB1->ID) <> "CMS"
					nCTOTotE2		+= (TRB1->VDEBITO - TRB1->VCREDITO)
				endif
				TRB1->(dbskip())
			EndDo

			ZZP->ZZP_VLRCTB := nCTOTotC2
			ZZP->ZZP_PERCTB	:= (nCTOTotC2 / nCPRTotR2 )*100

			ZZP->ZZP_VLRCTE := nCTOTotE2
			ZZP->ZZP_PERCTE	:= (nCTOTotE2 / nXVDSIR )*100

		
			ZZP->( DBCommit() )
		//_nRecSaldo 	:= ZZP->(recno()) // Guarda o recno da linha de saldo
		//_cOrdem := soma1(_cOrdem)
	 	TZZP->(dbclosearea())
		
		//*********************** CUSTO TOTAL ********************************
			cQuery2 := " SELECT R_E_C_N_O_ AS 'RECNO' FROM ZZP010 WHERE R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_)  FROM ZZP010) "
			TCQuery cQuery2 New Alias "TZZP"

			ZZP->( DBAppend( .F. ) )
			ZZP->ZZP_FILIAL		:= "01"
			ZZP->ZZP_DESUSA		:= "CUSTO TOTAL"
			ZZP->ZZP_ID			:= "XX2"
			ZZP->ZZP_IDUSA		:= "999"
			ZZP->ZZP_ORDEM		:= _cOrdem
			ZZP->ZZP_XIDPM		:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XIDPM")
			//ZZP->ZZP_XNOMPM	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XNOMPM")
			ZZP->ZZP_ITEMCT := _cItemConta

			nOUTCUS1 := (nXCUSTO * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCONT")/100)) + (nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XFIANC")/100)) + ;
					(nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XCUSFI")/100)) + (nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPROVG")/100)) + ;
					(nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPERDI")/100)) +  (nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XROYAL")/100)) + ;
					(nXVDSIR * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCOM")/100))
					
			// VENDIDO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if ALLTRIM(TRB1->CAMPO) == "VLRVD"
					nCTOValV		:= TRB1->VALOR  //SC7->C7_XTOTSI
					nCTOTotV		+= nCTOValV
				endif
				TRB1->(dbskip()) //SC7->(dbskip())
			EndDo

			ZZP->ZZP_VLRVD := (nCTOTotV + nOUTCUS1)
			ZZP->ZZP_PERVD	:= ((nCTOTotV+nOUTCUS1) / nXVDSIR )*100

			// PLANEJADO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if ALLTRIM(TRB1->CAMPO) == "VLRPLN"
					nCTOValP		:= TRB1->VALOR  //SC7->C7_XTOTSI
					nCTOTotP		+= nCTOValP
				endif
				TRB1->(dbskip()) //SC7->(dbskip())

			EndDo

			ZZP->ZZP_VLRPLN := (nCTOTotP + nOUTCUS1)
			ZZP->ZZP_PERPLN	:= ((nCTOTotP+nOUTCUS1) / nXVDSIR )*100

			// EMPENHADO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if  ALLTRIM(TRB1->CAMPO) == "VLREMP" .AND. ALLTRIM(TRB1->ID) <> "CMS"
					nCTOTot		+= TRB1->VALOR
				endif

				TRB1->(dbskip())
			EndDo
			ZZP->ZZP_VLREMP 	:= nCTOTot
			ZZP->ZZP_PEREMP	:= (nCTOTot / nXVDSIR )*100

			// CUSTO CONTABIL
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if  ALLTRIM(TRB1->CAMPO) == "VLRCTB"
					nCTOTotC		+= (TRB1->VDEBITO - TRB1->VCREDITO)
				endif
				TRB1->(dbskip())
			EndDo

			// CUSTO CONTABIL ESTOQUE
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if  ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
					nCTOTotE		+= (TRB1->VDEBITO - TRB1->VCREDITO)
				endif
				TRB1->(dbskip())
			EndDo

			ZZP->ZZP_VLRCTB := nCTOTotC
			ZZP->ZZP_PERCTB	:= (nCTOTotC / nCPRTotR )*100

			ZZP->ZZP_VLRCTE := nCTOTotE
			ZZP->ZZP_PERCTE	:= (nCTOTotE / nXVDSIR )*100

		
			//_nRecSaldo 	:= ZZP->(recno()) // Guarda o recno da linha de saldo
			//_cOrdem := soma1(_cOrdem)
			ZZP->( DBCommit() )
			TZZP->(dbclosearea())
	
		//*********************** MARGEM CONTRIBUICAO ********************************
			cQuery2 := " SELECT R_E_C_N_O_ AS 'RECNO' FROM ZZP010 WHERE R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_)  FROM ZZP010) "
			TCQuery cQuery2 New Alias "TZZP"

			ZZP->( DBAppend( .F. ) )
			ZZP->ZZP_FILIAL		:= "01"
			ZZP->ZZP_DESUSA	:= "MARGEM CONTRIB."
			ZZP->ZZP_ID		:= "MKC"
			ZZP->ZZP_IDUSA		:= "000"
			ZZP->ZZP_ORDEM		:= _cOrdem
			ZZP->ZZP_XIDPM		:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XIDPM")
			//ZZP->ZZP_XNOMPM	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XNOMPM")
			ZZP->ZZP_ITEMCT := _cItemConta

			ZZP->ZZP_VLRVD		:= nXVDSI - (nCTOTotV + nOUTCUS1)
			ZZP->ZZP_PERVD		:= ((nXVDSI - (nCTOTotV + nOUTCUS1)) / nXVDSI )*100

			ZZP->ZZP_VLRPLN	:= nXVDSIR - (nCTOTotP + nOUTCUS1)
			ZZP->ZZP_PERPLN	:= ((nXVDSIR - (nCTOTotP + nOUTCUS1)) / nXVDSIR )*100

			ZZP->ZZP_VLREMP	:= nXVDSIR - nCTOTot
			ZZP->ZZP_PEREMP	:= ((nXVDSIR - nCTOTot) / nXVDSIR )*100

			ZZP->ZZP_VLRCTB	:= nCPRTotR - nCTOTotC
			ZZP->ZZP_PERCTB	:= ((nCPRTotR - nCTOTotC) / nCPRTotR )*100
			ZZP->( DBCommit() )
			//_nRecSaldo 	:= ZZP->(recno()) // Guarda o recno da linha de saldo
			//_cOrdem := soma1(_cOrdem)
			TZZP->(dbclosearea())
		
	ENDIF
// Gravacao de uma linha para movimentos sem natureza ou grupo de naturezas

cDELZZP := TCSqlExec("DELETE from ZZP010 WHERE ZZP_ITEMCT = 'PROPOSTA' ")

return





/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Abre os arquivos necessarios                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function AbreArq()
local aStru 	:= {}

local _cCpoAtu
local _ni

if file(_cArq) .and. ferase(_cArq) == -1
	msgstop("Nao foi possivel abrir o arquivo GCIN01.XLS pois ele pode estar aberto por outro usuario.")
	return(.F.)
endif

// monta arquivo analitico TRB1

aAdd(aStru,{"DATAMOV"	,"D",08,0}) // Data de movimentacao
aAdd(aStru,{"DATAENT"	,"D",08,0}) // Data de entrega
aAdd(aStru,{"ORIGEM"	,"C",02,0}) // Origem do lancamento (MB - movimento bancario, PC - pedido de compra, CR - Contas a receber e CP - Contas a pagar)
aAdd(aStru,{"TIPO"		,"C",03,0}) // Origem do lancamento (MB - movimento bancario, PC - pedido de compra, CR - Contas a receber e CP - Contas a pagar)
aAdd(aStru,{"GRPROD"	,"C",03,0})
aAdd(aStru,{"CONTA"		,"C",15,0}) // Data de movimentacao
aAdd(aStru,{"VDEBITO"	,"N",15,2}) // Valor do movimento
aAdd(aStru,{"VCREDITO"	,"N",15,2}) // Valor do movimento
aAdd(aStru,{"VSALDO"	,"N",15,2}) // Valor do movimento
aAdd(aStru,{"NUMERO"	,"C",15,0}) // Data de movimentacao
aAdd(aStru,{"PRODUTO"	,"C",30,0}) // Historico
aAdd(aStru,{"HISTORICO"	,"C",120,0}) // Historico
aAdd(aStru,{"QUANTIDADE","N",15,2}) // Data de movimentacao
aAdd(aStru,{"UNIDADE","C",02,0}) // Data de movimentacao
aAdd(aStru,{"VALOR"		,"N",15,2}) // Valor do movimento
aAdd(aStru,{"VALOR2"	,"N",15,2}) // Valor do movimento
aAdd(aStru,{"ITEMCONTA"	,"C",13,0}) // Origem do lancamento (MB - movimento bancario, PC - pedido de compra, CR - Contas a receber e CP - Contas a pagar)
aAdd(aStru,{"CODFORN"	,"C",15,0}) // Origem do lancamento (MB - movimento bancario, PC - pedido de compra, CR - Contas a receber e CP - Contas a pagar)
aAdd(aStru,{"FORNECEDOR","C",60,0}) // Origem do lancamento (MB - movimento bancario, PC - pedido de compra, CR - Contas a receber e CP - Contas a pagar)
aAdd(aStru,{"CFOP"		,"C",13,0})
aAdd(aStru,{"NATUREZA"	,"C",13,0})
aAdd(aStru,{"DNATUREZA"	,"C",40,0})
aAdd(aStru,{"ID"		,"C",03,0}) // Historico
aAdd(aStru,{"DESCRICAO"	,"C",20,0}) // Historico
aAdd(aStru,{"IDUSA"		,"C",03,0}) // Historico
aAdd(aStru,{"DESCUSA"	,"C",50,0}) // Historico
aAdd(aStru,{"CAMPO"		,"C",10,0}) // Campo de gravacao (periodo) no arquivo sintetico
aAdd(aStru,{"SIMULADO"	,"C",01,0}) // Indica se o registro foi gerado por uma simulacao

dbcreate(cArqTrb1,aStru)
dbUseArea(.T.,,cArqTrb1,"TRB1",.T.,.F.)

//monta arquivo analitico TRB4
aAdd(aStru,{"RDATAMOV"	,"D",08,0}) // Data de movimentacao
aAdd(aStru,{"RORIGEM"	,"C",02,0}) // Origem do lancamento (MB - movimento bancario, PC - pedido de compra, CR - Contas a receber e CP - Contas a pagar)
aAdd(aStru,{"RCONTA"	,"C",15,0}) // Data de movimentacao
aAdd(aStru,{"RHISTORICO"	,"C",80,0}) // Historico
aAdd(aStru,{"RVDEBITO"	,"N",15,2}) // Valor do movimento
aAdd(aStru,{"RVCREDITO"	,"N",15,2}) // Valor do movimento
aAdd(aStru,{"RVSALDO"	,"N",15,2}) // Valor do movimento
aAdd(aStru,{"RITEMCONTA"	,"C",13,0}) // Origem do lancamento (MB - movimento bancario, PC - pedido de compra, CR - Contas a receber e CP - Contas a pagar)
aAdd(aStru,{"RID"		,"C",03,0}) // Historico
aAdd(aStru,{"RDESCRICAO"	,"C",20,0}) // Historico
aAdd(aStru,{"RCAMPO"		,"C",10,0}) // Campo de gravacao (periodo) no arquivo sintetico
aAdd(aStru,{"RSIMULADO"	,"C",01,0}) // Indica se o registro foi gerado por uma simulacao

dbcreate(cArqTrb4,aStru)
dbUseArea(.T.,,cArqTrb4,"TRB4",.T.,.F.)

//***************************************************************
/*aStru := {}
//aAdd(aStru,{"OK"		,"C",01,0}) // Descricao da Natureza
aAdd(aStru,{"GRUPO"		,"C",20,0}) // Descricao da Natureza
aAdd(aStru,{"DESCRI"    ,"C",30,0}) // Descricao da Natureza DESCRICAO
aAdd(aStru,{"VLRVD"		,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"PERVD"		,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"VLRPLN"	,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"PERPLN"	,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"VLREMP"	,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"PEREMP"	,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"VLRSLD"	,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"PERSLD"	,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"VLRCTB"	,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"PERCTB"	,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"VLRCTE"	,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"PERCTE"	,"N",15,2}) // Valor total dos movimentos VLRCTBE
aAdd(aStru,{"ID"		,"C",5,0}) // Codigo da Natureza PERCTBE
aAdd(aStru,{"IDUSA"		,"C",3,0}) // Codigo da Natureza
aAdd(aStru,{"DESUSA"	,"C",50,0}) // Descricao da Natureza DESCUSA
aAdd(aStru,{"ORDEM"		,"C",10,0}) // Ordem de apresentacao
aAdd(aStru,{"XIDPM"		,"C",06,0}) // Ordem de apresentacao
aAdd(aStru,{"XNOMPM"	,"C",50,0}) // Ordem de apresentacao

dbcreate(cArqTrb2,aStru)
dbUseArea(.T.,,cArqTrb2,"TRB2",.F.,.F.)

aadd(_aCpos , "DESCRICAO")
aadd(_aCpos , "VLRVD")
aadd(_aCpos , "PERVD")
aadd(_aCpos , "VLRPLN")
aadd(_aCpos , "PERPLN")
aadd(_aCpos , "VLREMP")
aadd(_aCpos , "PEREMP")
aadd(_aCpos , "VLRSLD")
aadd(_aCpos , "PERSLD")
aadd(_aCpos , "VLRCTB")
aadd(_aCpos , "PERCTB")
aadd(_aCpos , "VLRCTBE")
aadd(_aCpos , "PERCTBE")

_nCampos := len(_aCpos)

index on ORDEM to &(cArqTrb2+"2")
index on ORDEM to &(cArqTrb2+"1")
index on ORDEM to &(cArqTrb4+"1")

set index to &(cArqTrb2+"1")
set index to &(cArqTrb4+"1")*/


return(.T.)


static function VldParam()

/*
if empty(_dDataIni) .or. empty(_dDataFim) .or. empty(_dDtRef) // Alguma data vazia
	msgstop("Todas as datas dos par�metros devem ser informadas.")
	return(.F.)
endif

if _dDataIni > _dDtRef // Data de inicio maior que data de referencia
	msgstop("A data de in�cio do processamento deve ser menor ou igual a data de refer�ncia.")
	return(.F.)
endif

if _dDataFim < _dDtRef // Data de fim menor que data de referencia
	msgstop("A data de final do processamento deve ser maior ou igual a data de refer�ncia.")
	return(.F.)
endif
*/
return(.T.)


/*
static function GC01SINT()
local _nPos 	:= 0
local _cQuery 	:= ""
local _nSaldo 	:= 0

Local nMPRVal 	:= 0
Local nMPRTot	:= 0

Local nMPRValC 	:= 0
Local nMPRTotC	:= 0

Local nMPRValE 	:= 0
Local nMPRTotE	:= 0

Local nMPRValP 	:= 0
Local nMPRTotP	:= 0

Local nMPRValV 	:= 0
Local nMPRTotV	:= 0

Local nFABVal 	:= 0
Local nFABTot	:= 0

Local nFABValC 	:= 0
Local nFABTotC	:= 0

Local nFABValE 	:= 0
Local nFABTotE	:= 0

Local nFABValV 	:= 0
Local nFABTotV	:= 0

Local nFABValP 	:= 0
Local nFABTotP	:= 0

Local nCOMVal 	:= 0
Local nCOMTot	:= 0

Local nCOMValC 	:= 0
Local nCOMTotC	:= 0

Local nCOMValE 	:= 0
Local nCOMTotE	:= 0

Local nCOMValP 	:= 0
Local nCOMTotP	:= 0

Local nCOMValV 	:= 0
Local nCOMTotV	:= 0

Local nEBRVal 	:= 0
Local nEBRTot	:= 0

Local nEBRValC 	:= 0
Local nEBRTotC	:= 0

Local nEBRValE 	:= 0
Local nEBRTotE	:= 0

Local nEBRValP 	:= 0
Local nEBRTotP	:= 0

Local nEBRValV 	:= 0
Local nEBRTotV	:= 0

Local nESLVal 	:= 0
Local nESLTot	:= 0

Local nESLValC 	:= 0
Local nESLTotC	:= 0

Local nESLValE 	:= 0
Local nESLTotE	:= 0

Local nESLValP 	:= 0
Local nESLTotP	:= 0

Local nESLValV 	:= 0
Local nESLTotV	:= 0

Local nCTRVal 	:= 0
Local nCTRTot	:= 0

Local nCTRValC 	:= 0
Local nCTRTotC	:= 0

Local nCTRValE 	:= 0
Local nCTRTotE	:= 0

Local nCTRValP 	:= 0
Local nCTRTotP	:= 0

Local nCTRValV 	:= 0
Local nCTRTotV	:= 0

Local nIDLVal 	:= 0
Local nIDLTot	:= 0

Local nIDLValC 	:= 0
Local nIDLTotC	:= 0

Local nIDLValE 	:= 0
Local nIDLTotE	:= 0

Local nIDLValP 	:= 0
Local nIDLTotP	:= 0

Local nIDLValV 	:= 0
Local nIDLTotV	:= 0

Local nLABVal 	:= 0
Local nLABTot	:= 0

Local nLABValC 	:= 0
Local nLABTotC	:= 0

Local nLABValE 	:= 0
Local nLABTotE	:= 0

Local nLABValP 	:= 0
Local nLABTotP	:= 0

Local nLABValV 	:= 0
Local nLABTotV	:= 0

Local nFINVal 	:= 0
Local nFINTot	:= 0

Local nFINValC 	:= 0
Local nFINTotC	:= 0

Local nFINValE 	:= 0
Local nFINTotE	:= 0

Local nFINValP 	:= 0
Local nFINTotP	:= 0

Local nFINValV 	:= 0
Local nFINTotV	:= 0

Local nCMSVal 	:= 0
Local nCMSTot	:= 0

Local nCMSValE 	:= 0
Local nCMSTotE	:= 0

Local nCMSValC 	:= 0
Local nCMSTotC	:= 0

Local nCMSValP 	:= 0
Local nCMSTotP	:= 0

Local nCMSValV 	:= 0
Local nCMSTotV	:= 0

Local nRDVVal 	:= 0
Local nRDVTot	:= 0

Local nRDVValC 	:= 0
Local nRDVTotC	:= 0

Local nRDVValE 	:= 0
Local nRDVTotE	:= 0

Local nRDVValP 	:= 0
Local nRDVTotP	:= 0

Local nRDVValV 	:= 0
Local nRDVTotV	:= 0

Local nFRTVal 	:= 0
Local nFRTTot	:= 0

Local nFRTValC 	:= 0
Local nFRTTotC	:= 0

Local nFRTValE 	:= 0
Local nFRTTotE	:= 0

Local nFRTValP 	:= 0
Local nFRTTotP	:= 0

Local nFRTValV 	:= 0
Local nFRTTotV	:= 0

Local nCDVVal 	:= 0
Local nCDVTot	:= 0

Local nCDVValC 	:= 0
Local nCDVTotC	:= 0

Local nCDVValE 	:= 0
Local nCDVTotE	:= 0

Local nCDVValP	:= 0
Local nCDVTotP	:= 0

Local nCDVValV	:= 0
Local nCDVTotV	:= 0

Local nSRVVal 	:= 0
Local nSRVTot	:= 0

Local nSRVValC 	:= 0
Local nSRVTotC	:= 0

Local nSRVValE 	:= 0
Local nSRVTotE	:= 0

Local nSRVValP 	:= 0
Local nSRVTotP 	:= 0

Local nSRVValV 	:= 0
Local nSRVTotV 	:= 0

Local nCPRVal	:= 0
Local nCPRTot	:= 0
Local nCTOVal	:= 0
Local nCTOTot	:= 0
Local nCTOTotC	:= 0
Local nCPRTotC	:= 0

Local nCTOTotE	:= 0
Local nCPRTotE	:= 0

Local nCTOTotP	:= 0
Local nCPRTotP	:= 0

Local nCTOTotV	:= 0
Local nCPRTotV	:= 0

Local nCPRTotR	:= 0

Local nCPRVal2	:= 0
Local nCPRTot2	:= 0
Local nCTOVal2	:= 0
Local nCTOTot2	:= 0
Local nCTOTotC2	:= 0
Local nCPRTotC2	:= 0

Local nCTOTotE2	:= 0
Local nCPRTotE2	:= 0

Local nCTOTotP2	:= 0
Local nCPRTotP2	:= 0

Local nCTOTotV2	:= 0
Local nCPRTotV2	:= 0

Local nCPRTotR2	:= 0

Local nXSISFV	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XSISFV")
Local nXSISFR	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XSISFR")


Local nXVDSIR	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XVDSIR")
Local nXVDSI	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XVDSI")
Local nXCUSTO	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XCUSTO")
Local nOUTCUS1	:= 0
Local nOUTCUS2	:= 0


//Variaveis Vendido
Local  nGT101 := 0, nGT102 := 0, nGT103 := 0, nGT104 := 0, nGT105 := 0, nGT106 := 0, nGT107 := 0, nGT108 := 0, nGT109 := 0, nGT199 := 0
Local  nGT201 := 0, nGT202 := 0, nGT204 := 0, nGT205 := 0, nGT206 := 0, nGT207 := 0, nGT209 := 0
Local  nGT210 := 0, nGT211 := 0, nGT212 := 0, nGT213 := 0, nGT217 := 0, nGT218 := 0, nGT220 := 0, nGT221 := 0, nGT222 := 0, nGT299 := 0
Local  nGT301 := 0, nGT501 := 0, nGT601 := 0, nGT701 := 0
//Variaveis planejado
Local  nGP101 := 0, nGP102 := 0, nGP103 := 0, nGP104 := 0, nGP105 := 0, nGP106 := 0, nGP107 := 0, nGP108 := 0, nGP109 := 0, nGP199 := 0
Local  nGP201 := 0, nGP202 := 0, nGP204 := 0, nGP205 := 0, nGP206 := 0, nGP207 := 0, nGP209 := 0
Local  nGP210 := 0, nGP211 := 0, nGP212 := 0, nGP213 := 0, nGP217 := 0, nGP218 := 0, nGP220 := 0, nGP221 := 0, nGP222 := 0, nGP299 := 0
Local  nGP301 := 0, nGP501 := 0, nGP601 := 0, nGP701 := 0
//Variaveis empenhado
Local  nGE101 := 0, nGE102 := 0, nGE103 := 0, nGE104 := 0, nGE105 := 0, nGE106 := 0, nGE107 := 0, nGE108 := 0, nGE109 := 0, nGE199 := 0
Local  nGE201 := 0, nGE202 := 0, nGE204 := 0, nGE205 := 0, nGE206 := 0, nGE207 := 0, nGE209 := 0
Local  nGE210 := 0, nGE211 := 0, nGE212 := 0, nGE213 := 0, nGE217 := 0, nGE218 := 0, nGE220 := 0, nGE221 := 0, nGE222 := 0, nGE299 := 0
Local  nGE301 := 0, nGE501 := 0, nGE601 := 0, nGE701 := 0
Local  nGE801 := 0, nGE802 := 0, nGE803 := 0, nGE804 := 0, nGE805 := 0, nGE806 := 0
Local  nGE901 := 0, nGE902 := 0, nGE903 := 0, nGE904 := 0, nGE905 := 0, nGE906 := 0, nGE908 := 0
//Variaveis contabil estoque
Local  nGCE101 := 0, nGCE102 := 0, nGCE103 := 0, nGCE104 := 0, nGCE105 := 0, nGCE106 := 0, nGCE107 := 0, nGCE108 := 0, nGCE109 := 0, nGCE199 := 0
Local  nGCE201 := 0, nGCE202 := 0, nGCE204 := 0, nGCE205 := 0, nGCE206 := 0, nGCE207 := 0, nGCE209 := 0
Local  nGCE210 := 0, nGCE211 := 0, nGCE212 := 0, nGCE213 := 0, nGCE217 := 0, nGCE218 := 0, nGCE220 := 0, nGCE221 := 0, nGCE222 := 0, nGCE299 := 0
Local  nGCE301 := 0, nGCE501 := 0, nGCE601 := 0, nGCE701 := 0
//Variaveis contabil reconhecido
Local  nGCR101 := 0, nGCR102 := 0, nGCR103 := 0, nGCR104 := 0, nGCR105 := 0, nGCR106 := 0, nGCR107 := 0, nGCR108 := 0, nGCR109 := 0, nGCR199 := 0
Local  nGCR201 := 0, nGCR202 := 0, nGCR204 := 0, nGCR205 := 0, nGCR206 := 0, nGCR207 := 0, nGCR209 := 0
Local  nGCR210 := 0, nGCR211 := 0, nGCR212 := 0, nGCR213 := 0, nGCR217 := 0, nGCR218 := 0, nGCR220 := 0, nGCR221 := 0, nGCR222 := 0, nGCR299 := 0
Local  nGCR301 := 0, nGCR501 := 0, nGCR601 := 0, nGCR701 := 0

private _cOrdem := "000001"

//_cItemConta 	:= ALLTRIM(MV_PAR01)
	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)
	
	

	//*********************** CUSTO DE PRODUCAO******************************
	RecLock("TRB2",.T.)
		TRB2->DESCUSA		:= "CUSTO PRODUCAO"
		TRB2->IDUSA		:= "000"
		TRB2->ID		:= "XX1"
		TRB2->ORDEM		:= _cOrdem
		TRB2->XIDPM		:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XIDPM")
		TRB2->XNOMPM	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XNOMPM")

		// VENDIDO
		IF nTotRegZZM > 0
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if !TRB1->IDUSA $ ("801/900/901/902/903/904/905/906/908")  .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD" 
					nCPRValV		:= TRB1->VALOR
					nCPRTotV		+= nCPRValV
				endif
				TRB1->(dbskip())
			EndDo
		else
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if TRB1->ID <> "CMS"  .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD" 
					nCPRValV		:= TRB1->VALOR
					nCPRTotV		+= nCPRValV
				endif
				TRB1->(dbskip())
			EndDo
		endif

		TRB2->VLRVD		 := nCPRTotV  // nCPRTotV + (nXCUSTO * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCONT")/100))
		TRB2->PERVD 	:= (nCPRTotV   / nXVDSIR )*100 //((nCPRTotV + (nXCUSTO * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCONT")/100)))  / nXVDSIR )*100

		// PLNAJEDO
		IF nTotRegZZN > 0
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if !TRB1->IDUSA $ ("801/900/901/902/903/904/905/906/908")  .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
					nCPRValP		:= TRB1->VALOR
					nCPRTotP		+= nCPRValP
				endif
				TRB1->(dbskip())
			EndDo
		ELSE
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if TRB1->ID <> "CMS"  .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
					nCPRValP		:= TRB1->VALOR
					nCPRTotP		+= nCPRValP
				endif
				TRB1->(dbskip())
			EndDo
		ENDIF

		TRB2->VLRPLN := nCPRTotP //+ (nXCUSTO * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCONT")/100))
		TRB2->PERPLN := (nCPRTotP  / nXVDSIR )*100  // ((nCPRTotP + (nXCUSTO * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCONT")/100)))  / nXVDSIR )*100 

		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if !TRB1->IDUSA $ ("801/802/803/804/805/806/908") .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP" // TRB1->ID <> "CMS"  .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP" .OR. 
				nCPRVal		:= TRB1->VALOR  //SC7->C7_XTOTSI
				nCPRTot		+= nCPRVal
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo

		TRB2->VLREMP := nCPRTot
		TRB2->PEREMP	:= (nCPRTot / nXVDSIR )*100

		//  CUSTO CONTABIL
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->ID <> "CMS"  .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTB"
				nCPRTotC	+= (TRB1->VDEBITO - TRB1->VCREDITO)
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo

		//  CUSTO CONTABIL ESTOQUE
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->ID <> "CMS" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
				nCPRTotE	+= (TRB1->VDEBITO - TRB1->VCREDITO)
			endif
			TRB1->(dbskip())
		EndDo

		// RECEITA CONTABIL
		TRB4->(dbgotop())
		While TRB4->( ! EOF() )
			if TRB4->RID == "REC"
				nCPRTotR	+= (TRB4->RVCREDITO - TRB4->RVDEBITO )
			endif
			TRB4->(dbskip()) //SC7->(dbskip())
		EndDo

		TRB2->VLRCTB := nCPRTotC
		TRB2->PERCTB	:= (nCPRTotC / nCPRTotR )*100

		TRB2->VLRCTBE := nCPRTotE
		TRB2->PERCTBE	:= (nCPRTotE / nXVDSIR )*100

		MsUnlock()
		_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
		_cOrdem := soma1(_cOrdem)
		MsUnlock()
	

		//*********************** MARGEM BRUTA ********************************
	RecLock("TRB2",.T.)
		TRB2->DESCUSA		:= "MARGEM BRUTA"
		TRB2->IDUSA		:= "000"
		TRB2->ID		:= "MKB"
		TRB2->DESCRICAO	:= ""
		TRB2->ORDEM		:= _cOrdem
		TRB2->XIDPM		:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XIDPM")
		TRB2->XNOMPM	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XNOMPM")

		TRB2->VLRVD	:= nXVDSI - nCPRTotV 
		TRB2->PERVD	:= ((nXVDSI - nCPRTotV) / nXVDSI )*100

		TRB2->VLRPLN	:= nXVDSIR - nCPRTotP 
		TRB2->PERPLN	:= ((nXVDSIR - nCPRTotP) / nXVDSIR )*100

		TRB2->VLREMP	:= nXVDSIR - nCPRTot
		TRB2->PEREMP	:= ((nXVDSIR - nCPRTot) / nXVDSIR )*100

		TRB2->VLRCTB	:= nCPRTotR - nCPRTotC
		TRB2->PERCTB	:= ((nCPRTotR - nCPRTotC) / nCPRTotR ) *100
	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)

	
	//*********************** CALCULO GRUPO 801/901/902/903/904/905/906/908 NOVO SISTEMA ********************************
	// 901 OUTROS CUSTOS NOVOS
	IF nTotRegZZM > 0 .OR. nTotRegZZN > 0
		
		//*********************** COGS ********************************
		/*****
		nOUTCUS3 := (nXCUSTO * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCONT")/100)) + (nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XFIANC")/100)) + ;
					(nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XCUSFI")/100)) + (nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPROVG")/100)) + ;
					(nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPERDI")/100)) +  (nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XROYAL")/100)) 
		*******/
		/*RecLock("TRB2",.T.)
			TRB2->ID		:= "XX1"
			TRB2->IDUSA		:= "000"
			TRB2->DESCUSA	:= "COGS"
			TRB2->ORDEM		:= _cOrdem
			TRB2->XIDPM		:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XIDPM")
			TRB2->XNOMPM	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XNOMPM")
			
			// VENDIDO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if ALLTRIM(TRB1->CAMPO) == "VLRVD" .AND. !TRB1->IDUSA $ ('901/908')
					nCTOValV2		:= TRB1->VALOR  //SC7->C7_XTOTSI
					nCTOTotV2		+= nCTOValV2
				endif
				TRB1->(dbskip()) //SC7->(dbskip())
			EndDo

			TRB2->VLRVD := nCTOTotV2
			TRB2->PERVD	:= (nCTOTotV2 / nXVDSI )*100
			
			// PLANEJADO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if ALLTRIM(TRB1->CAMPO) == "VLRPLN" .AND. !TRB1->IDUSA $ ('901/908')
					nCTOValP2		:= TRB1->VALOR  //SC7->C7_XTOTSI
					nCTOTotP2		+= nCTOValP2
				endif
				TRB1->(dbskip()) //SC7->(dbskip())
			EndDo

			TRB2->VLRPLN := (nCTOTotP2 )
			TRB2->PERPLN	:= ((nCTOTotP2) / nXVDSIR )*100
			
			// EMPENHADO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				
				if  ALLTRIM(TRB1->CAMPO) == "VLREMP" .AND. ALLTRIM(TRB1->ID) <> "CMS" .AND. !TRB1->IDUSA $ ('901/908')
					nCTOTot2		+= TRB1->VALOR
				endif

				TRB1->(dbskip())
			EndDo
			TRB2->VLREMP 	:= nCTOTot2
			TRB2->PEREMP	:= (nCTOTot2 / nXVDSIR )*100
			
			// CUSTO CONTABIL
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if  ALLTRIM(TRB1->CAMPO) == "VLRCTB" .AND. ALLTRIM(TRB1->ID) <> "CMS" .AND. !TRB1->IDUSA $ ('901/908')
					nCTOTotC2		+= (TRB1->VDEBITO - TRB1->VCREDITO)
				endif
				TRB1->(dbskip())
			EndDo
			
			// CUSTO CONTABIL ESTOQUE	
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if  ALLTRIM(TRB1->CAMPO) == "VLRCTBE" .AND. ALLTRIM(TRB1->ID) <> "CMS" .AND. !TRB1->IDUSA $ ('901/908')
					nCTOTotE2		+= (TRB1->VDEBITO - TRB1->VCREDITO)
				endif
				TRB1->(dbskip())
			EndDo

			TRB2->VLRCTB := nCTOTotC2
			TRB2->PERCTB	:= (nCTOTotC2 / nCPRTotR2 )*100

			TRB2->VLRCTBE := nCTOTotE2
			TRB2->PERCTBE	:= (nCTOTotE2 / nXVDSIR )*100

		
			_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
			_cOrdem := soma1(_cOrdem)
			
		MsUnlock()
	

		

		//*********************** CUSTO TOTAL ********************************
		RecLock("TRB2",.T.)
			TRB2->DESCUSA		:= "CUSTO TOTAL"
			TRB2->ID		:= "XX2"
			TRB2->IDUSA		:= "999"
			TRB2->ORDEM		:= _cOrdem
			TRB2->XIDPM		:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XIDPM")
			TRB2->XNOMPM	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XNOMPM")
											
			// VENDIDO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if ALLTRIM(TRB1->CAMPO) == "VLRVD" .AND. !TRB1->IDUSA $ ("199/209/299/799/200/299/900/901/999") 
					nCTOValV		:= TRB1->VALOR  //SC7->C7_XTOTSI
					nCTOTotV		+= nCTOValV
				endif
				TRB1->(dbskip()) //SC7->(dbskip())
			EndDo

			TRB2->VLRVD := nCTOTotV
			TRB2->PERVD	:= ((nCTOTotV) / nXVDSIR )*100

			// PLANEJADO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if ALLTRIM(TRB1->CAMPO) == "VLRPLN" .AND. !TRB1->IDUSA $ ("199/209/299/799/200/299/900/901/999") 
					nCTOValP		:= TRB1->VALOR  //SC7->C7_XTOTSI
					nCTOTotP		+= nCTOValP
				endif
				TRB1->(dbskip()) //SC7->(dbskip())

			EndDo

			TRB2->VLRPLN := nCTOTotP
			TRB2->PERPLN	:= (nCTOTotP / nXVDSIR )*100

			// EMPENHADO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if  ALLTRIM(TRB1->CAMPO) == "VLREMP" .AND. ALLTRIM(TRB2->ID) <> "CMS"
					nCTOTot		+= TRB1->VALOR
				endif

				TRB1->(dbskip())
			EndDo
			TRB2->VLREMP 	:= nCTOTot
			TRB2->PEREMP	:= (nCTOTot / nXVDSIR )*100

			// CUSTO CONTABIL
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if  ALLTRIM(TRB1->CAMPO) == "VLRCTB"
					nCTOTotC		+= (TRB1->VDEBITO - TRB1->VCREDITO)
				endif
				TRB1->(dbskip())
			EndDo

			// CUSTO CONTABIL ESTOQUE
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if  ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
					nCTOTotE		+= (TRB1->VDEBITO - TRB1->VCREDITO)
				endif
				TRB1->(dbskip())
			EndDo

			TRB2->VLRCTB := nCTOTotC
			TRB2->PERCTB	:= (nCTOTotC / nCPRTotR )*100

			TRB2->VLRCTBE := nCTOTotE
			TRB2->PERCTBE	:= (nCTOTotE / nXVDSIR )*100

			MsUnlock()
			_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
			_cOrdem := soma1(_cOrdem)
			MsUnlock()
		MsUnlock()

		//*********************** MARGEM CONTRIBUICAO ********************************
		RecLock("TRB2",.T.)
			TRB2->DESCUSA	:= "MARGEM CONTRIB."
			TRB2->ID		:= "MKC"
			TRB2->IDUSA		:= "000"
			TRB2->ORDEM		:= _cOrdem
			TRB2->XIDPM		:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XIDPM")
			TRB2->XNOMPM	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XNOMPM")

			TRB2->VLRVD		:= nXVDSI - (nCTOTotV )
			TRB2->PERVD		:= ((nXVDSI - (nCTOTotV )) / nXVDSI )*100

			TRB2->VLRPLN	:= nXVDSIR - (nCTOTotP )
			TRB2->PERPLN	:= ((nXVDSIR - (nCTOTotP )) / nXVDSIR )*100

			TRB2->VLREMP	:= nXVDSIR - nCTOTot
			TRB2->PEREMP	:= ((nXVDSIR - nCTOTot) / nXVDSIR )*100

			TRB2->VLRCTB	:= nCPRTotR - nCTOTotC
			TRB2->PERCTB	:= ((nCPRTotR - nCTOTotC) / nCPRTotR )*100
		MsUnlock()
		_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
		_cOrdem := soma1(_cOrdem)

		
	ELSE
	
		//*********************** CUSTO TOTAL ********************************
		RecLock("TRB2",.T.)
			TRB2->DESCUSA		:= "CUSTO TOTAL"
			TRB2->ID		:= "XX2"
			TRB2->IDUSA		:= "999"
			TRB2->ORDEM		:= _cOrdem
			TRB2->XIDPM		:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XIDPM")
			TRB2->XNOMPM	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XNOMPM")

			nOUTCUS1 := (nXCUSTO * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCONT")/100)) + (nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XFIANC")/100)) + ;
					(nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XCUSFI")/100)) + (nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPROVG")/100)) + ;
					(nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPERDI")/100)) +  (nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XROYAL")/100)) + ;
					(nXVDSIR * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCOM")/100))
					
			// VENDIDO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if ALLTRIM(TRB1->CAMPO) == "VLRVD"
					nCTOValV		:= TRB1->VALOR  //SC7->C7_XTOTSI
					nCTOTotV		+= nCTOValV
				endif
				TRB1->(dbskip()) //SC7->(dbskip())
			EndDo

			TRB2->VLRVD := (nCTOTotV + nOUTCUS1)
			TRB2->PERVD	:= ((nCTOTotV+nOUTCUS1) / nXVDSIR )*100

			// PLANEJADO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if ALLTRIM(TRB1->CAMPO) == "VLRPLN"
					nCTOValP		:= TRB1->VALOR  //SC7->C7_XTOTSI
					nCTOTotP		+= nCTOValP
				endif
				TRB1->(dbskip()) //SC7->(dbskip())

			EndDo

			TRB2->VLRPLN := (nCTOTotP + nOUTCUS1)
			TRB2->PERPLN	:= ((nCTOTotP+nOUTCUS1) / nXVDSIR )*100

			// EMPENHADO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if  ALLTRIM(TRB1->CAMPO) == "VLREMP" .AND. ALLTRIM(TRB2->ID) <> "CMS"
					nCTOTot		+= TRB1->VALOR
				endif

				TRB1->(dbskip())
			EndDo
			TRB2->VLREMP 	:= nCTOTot
			TRB2->PEREMP	:= (nCTOTot / nXVDSIR )*100

			// CUSTO CONTABIL
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if  ALLTRIM(TRB1->CAMPO) == "VLRCTB"
					nCTOTotC		+= (TRB1->VDEBITO - TRB1->VCREDITO)
				endif
				TRB1->(dbskip())
			EndDo

			// CUSTO CONTABIL ESTOQUE
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if  ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
					nCTOTotE		+= (TRB1->VDEBITO - TRB1->VCREDITO)
				endif
				TRB1->(dbskip())
			EndDo

			TRB2->VLRCTB := nCTOTotC
			TRB2->PERCTB	:= (nCTOTotC / nCPRTotR )*100

			TRB2->VLRCTBE := nCTOTotE
			TRB2->PERCTBE	:= (nCTOTotE / nXVDSIR )*100

			MsUnlock()
			_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
			_cOrdem := soma1(_cOrdem)
			MsUnlock()
		MsUnlock()

		//*********************** MARGEM CONTRIBUICAO ********************************
		RecLock("TRB2",.T.)
			TRB2->DESCUSA	:= "MARGEM CONTRIB."
			TRB2->ID		:= "MKC"
			TRB2->IDUSA		:= "000"
			TRB2->ORDEM		:= _cOrdem
			TRB2->XIDPM		:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XIDPM")
			TRB2->XNOMPM	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XNOMPM")

			TRB2->VLRVD		:= nXVDSI - (nCTOTotV + nOUTCUS1)
			TRB2->PERVD		:= ((nXVDSI - (nCTOTotV + nOUTCUS1)) / nXVDSI )*100

			TRB2->VLRPLN	:= nXVDSIR - (nCTOTotP + nOUTCUS1)
			TRB2->PERPLN	:= ((nXVDSIR - (nCTOTotP + nOUTCUS1)) / nXVDSIR )*100

			TRB2->VLREMP	:= nXVDSIR - nCTOTot
			TRB2->PEREMP	:= ((nXVDSIR - nCTOTot) / nXVDSIR )*100

			TRB2->VLRCTB	:= nCPRTotR - nCTOTotC
			TRB2->PERCTB	:= ((nCPRTotR - nCTOTotC) / nCPRTotR )*100
		MsUnlock()
		_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
		_cOrdem := soma1(_cOrdem)

		/*
		dbSelectArea("CTD")
		CTD->( dbSetOrder(1) )
		
		If CTD->( dbSeek(xFilial("CTD")+_cItemConta) )
			RecLock("CTD",.F.)
				CTD->CTD_XACPR  := nCPRTot
				CTD->CTD_XACTO  := nCTOTot
				CTD->CTD_XCUPRR := nCPRTotP
				CTD->CTD_XCUTOR := nCTOTotP + nOUTCUS1
				CTD->CTD_XCOGSR := nCTOTotP2 + nOUTCUS3
				CTD->CTD_XCOGSV := nCTOTotV2 + nOUTCUS3

			MsUnLock()
		endif
		*/
	/*ENDIF
// Gravacao de uma linha para movimentos sem natureza ou grupo de naturezas

return


*/
