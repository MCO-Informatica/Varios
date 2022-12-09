#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "Ap5Mail.ch"

/*/{Protheus.doc} CSFAT03
Função para alteração do código do vendedor no(s) pedido(s) de venda(s) selecionado(s)
@author Luciano A Oliveira
@since 04/09/2020
@version 1.0
	@return Nil, Função não tem retorno
	@example
	@teste
	u_CSFAT03()
	@obs Não se pode executar função MVC dentro do fórmulas
/*/

user function CSFAT03A()
    /*Private oProcess

	oProcess := MsNewProcess():New({|lEnd|CSFAT03C(@oProcess, @lEnd)},"Atenção","Lendo Registros do Pedido de Vendas",.T.) 
	oProcess:Activate()*/

    Processa( {|| U_CSFAT03C()}, "Aguarde...", "Lendo o arquivo selecionado...",.F.)

return


user function CSFAT03C()
    Local aSAY    := {'Rotina para ALTERAR o vendedor no Pedido de Vendas POR LOTE','Pesquisa efetuada pelo número Pedido de Vendas','','Clique em OK para prosseguir...'}
    Local aBTN    := {}
    Local aPAR    := {}
    Local aRET    := {}
    Local aPedVen := {}
    Local aPVSD   := {} //caso haja pedidos repetidos nesse array será retirado.
    Local nOpc    := 0
    Local cCodVd  := ""
    
    Local lCancel := .F.
    Local cBuff   := ""
    Local i
    
    Private cTitulo := '[CSFAT03A] - Alteração do Vendedor no Pedido de Vendas(Por Lote)'
    Private lAlter  := .F.
    Private lProbl  := .F.
    Private cPVNF   := ""
    Private nCont   := 0
    Private nQuant  := 0

    Default lEnd := .F.

    //rpcsetenv('01','02')

    cCodVd := Space(TamSX3('A3_COD')[01])
    
    aADD( aBTN, { 1, .T., { || nOpc := 1, FechaBatch() } } )
    aADD( aBTN, { 2, .T., { || FechaBatch() } } )

    FormBatch( cTitulo, aSAY, aBTN )

    if nOpc == 1
        aAdd( aPAR, {6,"Selecione Arq.Pedidos?",Space(65),"","","",80,.T.,"Todos os arquivos (*.txt) |*.txt"})
        aAdd( aPAR, {1, "Vendedor?",cCodVd,"","","SA3","",50,.T.})
        
        if ParamBox( aPAR, cTitulo, @aRET )
            if ApMsgYesNo("Tem certeza que deseja continuar?", cTitulo)
                if !file(aRET[1])
                    ApMsgInfo("Arquivo não selecionado ou invalido.", cTitulo )
                    return
                else
                    nHdl := FT_FUSE(aRET[1])
                    if nHdl == -1 
                        ApMsgInfo("Problemas na abertura do arquivo de Pedido de Vendas.", cTitulo)
                        return
                    endif
                    
                    FT_FGoTop()

                    While !FT_FEOF()
                        cBuff += FT_FREADLN()
                        if subs(cBuff,len(cBuff),1) <> ','
                            cBuff += ','
                        endif 
                        FT_FSKIP()
                    End

                    cBuff := subs(cBuff,1,len(cBuff) -1)

                    aPedVen := StrToKarr(cBuff,',')

                    AEval(aPedVen,{|v|iif(aScan(aPVSD,v)=0,AADD(aPVSD,v),.F.)}) //retirando pedidos duplicados se houver

                    DbSelectArea("SC5")
                    SC5->(dbSetOrder(1))
                    SC5->(dbGoTop())

                    //oProcess:SetRegua1(len(aPVSD))
                    ProcRegua(len(aPVSD))

                    for i := 1 to len(aPVSD)
                    	sleep(300)	
                    	//if lEnd	//houve cancelamento do processo		
			            //    Exit	
		                //EndIf	
                        //oProcess:IncRegua1("Lendo Pedido de Venda:" + aPVSD[i]) 
                        IncProc()
                         u_csfat03b(aPVSD,i,aRet)
                    next i
                endif
            else
                lCancel := .T.
            endif
        else
            lCancel := .T.
        endIF

        if lAlter .AND. !lCancel
            ApMsgInfo("Processo finalizado com sucesso." + CRLF + ;
                      "Alterado(s): " + alltrim(str(nCont)) + " pedido(s)." + CRLF + ;
                      iif(nQuant > 0 ,"Pedido(s) de Venda não encontrado(s): " + alltrim(str(nQuant)) + " pedido(s).","") , cTitulo )
        elseif !lAlter .AND. !lCancel
            ApMsgInfo("Nenhum Pedido de Vendas alterado, favor checar o arquivo!!!", cTitulo )                
            lProbl := .F.
        endif

        if lCancel
            MsgInfo('Processo cancelado pelo usuário.',cTitulo)
        endif

        if lProbl .AND. !EMPTY(cPVNF)
           if ApMsgYesNo("Houve Pedidos de Venda que não foram encontrados." + CRLF + ;
                         "Deseja receber e-mail com os pedidos de vendas não encontrados???", cTitulo)
              envMailSC5(cPVNF)        
           endif
        endif
    endIF
return

static function envMailSC5(cPVNF)
	local cEmail   := UsrRetMail(RetCodUsr())
	local cTitulo  := "Códigos de Pedidos de Vendas não encontrados no arquivo de Lote"
	local cHtml    := ""
	local cAnexo   := ""
	local cMsgHTML := ""
	
	cMsgHTML :=	" O(s) Pedidos de Venda: " + cPVNF
	cMsgHTML +=	" não foram encontrados na tabela de Pedidos de Venda. <strong> Favor verificar seu arquivo. </strong>"	

	//Inicia construcao do html
	cHtml += '<!DOCTYPE HTML>'
	cHtml += '<html>'
	cHtml += '	<head>'
	cHtml += '		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /> '
	cHtml += '	</head>'
	cHtml += '	<body style="font-family: Fontin Roman, Lucida Sans Unicode">'
	cHtml += '	<table align="center" border="0" cellpadding="0" cellspacing="0" width="630" >'
	cHtml += '		<tr>'
	cHtml += '			<td valign="top" align="center">'
	cHtml += '				<table width="627">'
	cHtml += '					<tr>'
	cHtml += '						<td valign="middle" align="left" style="border-bottom:2px solid #FE5000;">'
	cHtml += '							<h2>'
	cHtml += '								<span style="color:#FE5000" ><strong>'+cTitulo+'.'+'</strong></span>'
	cHtml += '								<br />'
	cHtml += '								<span style="color:#003087" >Sistemas Corporativos</span>'
	cHtml += '							</h2>'
	cHtml += '						</td>'
	cHtml += '						<td valign="top" align="left" style="border-bottom:2px solid #FE5000;">'
	cHtml += '							<img  alt="Certisign" height="79" src="http://comunicacaocertisign.com.br/email/2013/certisign_logo.png" />'
	cHtml += '						</td>'
	cHtml += '					</tr>'
	cHtml += '				</table>'
	cHtml += '			</td>'
	cHtml += '		</tr>'
	chtml += '		<tr>'
	chtml += '			<td valign="top" style="padding:15px;">'
	chtml += '				<p>'+cMsgHTML+'<br /></p>'
	chtml += '			</td>'
	chtml += '		</tr>'
	cHtml += '		<tr>'
	cHtml += '			<td valign="top" colspan="2" style="padding:5px" width="0">'
	cHtml += '				<p align="left">'
	cHtml += '					<em style="color:#666666;">Esta mensagem foi gerada e enviada automaticamente, n&atilde;o responda a este e-mail.</em>'
	cHtml += '				</p>'
	cHtml += '			</td>'
	cHtml += '		</tr>'
	cHtml += '	</table>'
	cHtml += '	</body>'
	cHtml += '</html>'
	
	fsSendMail( cEmail, cTitulo, cHtml, cAnexo )
return
