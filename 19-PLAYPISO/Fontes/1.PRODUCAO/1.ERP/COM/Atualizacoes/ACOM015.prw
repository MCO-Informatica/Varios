/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACOM015   บAutor  ณAlexandre Sousa     บ Data ณ  11/08/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณSolicita a aprovacao do pedido de compras de faturamento    บฑฑ
ฑฑบ          ณdireto para o depto FINANCEIRO.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecifico LISONDA.                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ACOM015()
	
	Local a_area := SC7->(GetArea())                                                                	
	Local c_nump := SC7->C7_NUM
   	n_TotalPed := 0		// [incluido por - TOBIAS PENICHE - Actual Trend - 21/08/2013]
   	
	If SC7->C7_XFATD = 'S' //pedido de vendas financeiro
		If SC7->C7_XSTATFI = 'L' //
			If !msgYesNo('O pedido de compras jแ foi aprovado!!! Deseja solicitar nova aprova็ใo?', 'A T E N ว ร O')
				Return
			EndIf
		Endif
		DbSelectArea('SC7')
		DbSetorder(1)
		DbSeek(xFilial('SC7')+c_nump)
		
		While SC7->(!EOF()) .and. SC7->C7_NUM = c_nump
			RecLock('SC7', .f.)
			SC7->C7_XSTATFI := 'P'
		 	MsUnLock()    
		 	
		 	n_Ped := SC7->C7_TOTAL            	//[Incluido por  - TOBIAS PENCIHE - Actual Trend - 21/08/2013]
		 	n_TotalPed += n_Ped					//[Incluido por  - TOBIAS PENCIHE - Actual Trend - 21/08/2013]
		 	
		    	SC7->(DbSkip())  		

		EndDo
		
		RestArea(a_area)

		EnviaEmail()
		msgAlert('O pedido foi enviado para aprova็ใo com sucesso!!!', 'A T E N ว ร O')
		
	Else
		msgAlert('Apenas pedidos de faturamento direto podem ser indicados para aprova็ใo!!!', 'A T E N ว ร O')
	EndIf
	  
	RestArea(a_area)
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTK260ROT  บAutor  ณMicrosiga           บ Data ณ  08/23/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEnvia o email para os responsaveis.                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EnviaEmail()

	Local l_Continua	:= .T.
	
	Private c_texto 	:= ''
	Private c_msgerro	:= ''
	Private c_FileOrig	:= "\HTML\ACOM015.htm"   
	Private c_FileDest	:= "C:\siga.html"
	Private c_para		:= GetMV("MV_XMAILFC") 
	Private c_CodProj   := ''
	Private c_CodEdt    := ''  
	Private c_ccusto    := ''
	Private c_ValObra   := ''


	
    cNome_user := Busca_nome(__cuserid)
    DbSelectArea('CTT')
    DbSetOrder(1)
    DbSeek(xFilial('CTT')+SC7->C7_XCCFTD)
    
	fArq(c_FileOrig, c_FileDest)
	
	If !U_FGEN010(c_para,"Solicita็ใo de aprova็ใo de pedido faturamento direto. Usuario: "+cnome_user+" ",c_texto,,.t.)	
		Return c_msgerro
	EndIf 
   	   	If !U_FGEN010("decio@playpiso.com.br","Solicita็ใo de aprova็ใo de pedido faturamento direto. Usuario: "+cnome_user+" ",c_texto,,.t.)
		 	Return c_msgerro   // [Alterado acima por - TOBIAS PENCIHE - ActualTrend - 21/08/2013]
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
ฑฑบPrograma  ณBusca_NomeบAutor  ณJean Cavalcante     บ Data ณ  09/08/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBusca o Nome do Usuแrio Logado.				              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Busca_Nome(c_User) 

	c_user := Iif(c_User=Nil, __CUSERID, c_user)

	_aUser := {}
	psworder(1)
	pswseek(c_user)
	_aUser := PSWRET()

	_cnome		:= Substr(_aUser[1,4],1,50)

Return(_cnome) 
