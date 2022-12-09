#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RPMSA001  �Autor  �Alexandre Sousa     � Data �  09/27/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Chamada da funcao padrao de manutencao de orcamentos        ���
���          �chama antes o lembrete do vendedor.                         ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico LISONDA.                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RPMSA001(cAlias, nReno, nopc)
	
	Private l_alterou := .T.

	While l_alterou
                   
		l_alterou := .F.
		
		DbSelectArea('SA3')
		DbSetorder(7) // A3_FILIAL, A3_CODUSR, R_E_C_N_O_, D_E_L_E_T_  
		If DbSeek(xFilial('SA3')+__cuserid)
		    c_query := " select convert(varchar(10), convert(datetime, AF1_DATA), 103)  as DATA, * "
		    c_query += "	    from "+RetSqlName('AF1')+" AF1 
		    c_query += "where AF1_XVEND = '"+SA3->A3_COD+"' and AF1_FASE = '04' and AF1_XDTRET <= '"+DtoS(dDataBase)+"'and AF1.D_E_L_E_T_ <> '*'
		    
			FGEN008(c_query , {{"ORCAMENTO", "CLIENTE", "DESCRICAO", "DATA"}, {"AF1_ORCAME", "AF1_CLIENT", "AF1_DESCRI", "DATA"}}, "Atualiza��o de Or�amentos", 1)
	
		EndIf
	EndDo

	U_PMSAL100(cAlias, nReno, nopc)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FGEN008   �Autor  �Alexandre Sousa     � Data �  04/13/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao generica para mostrar o resultado de uma query.      ���
�������������������������������������������������������������������������͹��
���Parametros�c_Query: Query a ser excutada para obter informacoes.       ���
���          �a_campos:Array contendo uma coluna com a descricao dos cam- ���
���          �pos que sera mostrada na List, e outra contendo o nome dos  ���
���          �campos que serao retornados pela query.                     ���
���          �c_tit: Titulo da janela.                                    ���
���          �n_pos: Posicao do campo a ser retornado pela consulta.      ���
���          �c_Ret: String com o valor do campo informado.               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FGEN008(c_Query, a_campos, c_tit, n_pos)

	Local aSalvAmb	:= GetArea()
	Local cTitulo 	:= Iif( c_tit = Nil, "T�tulo", c_tit)
	Local nPos		:= Iif(n_pos = Nil, 1, n_pos)
	Local n_x		:= 0
	Local c_Lst		:= ''
//	Local c_Query	:= "select distinct EA_FILIAL, EA_NUMBOR from "+RetSqlName("SEA")+" where EA_FILIAL = '"+xFilial("SEA")+"' EA_CART = 'R' and D_E_L_E_T_ <> '*'"
//	Local a_campos	:= {{"Filial", "Bordero" }, {"EA_FILIAL", "EA_NUMBOR"}}
//	Local c_tit		:= "Consulta de Borderos"
	Private aVetor 	:= {}

	Private oDlg	:= Nil
	Private oLbx	:= Nil
	Private c_Ret	:= ''

 	If Select("QRX") > 0
		DbSelectArea("QRX")
		DbCloseArea()
	EndIf
	TcQuery c_Query New Alias "QRX"

	//+-------------------------------------+
	//| Carrega o vetor conforme a condicao |
	//+-------------------------------------+
	While QRX->(!EOF())
		aAdd(aVetor, Array(len(a_campos[2])))
		
		For n_x := 1 to len(a_campos[2])
			aVetor[len(aVetor),n_x] := ALLTRIM(&("QRX->"+a_campos[2,n_x]))
		Next
		QRX->(dbSkip())
	End

	If Len( aVetor ) == 0
//	   Aviso( cTitulo, "Nao existe dados para a consulta", {"Ok"} )
	   Return
	Endif

	//+-----------------------------------------------+
	//| Limitado a dez colunas                        |
	//+-----------------------------------------------+
	c_A := IIf(len(a_campos[1])>=1,a_campos[1,1],'' )
	c_B := IIf(len(a_campos[1])>=2,a_campos[1,2],'' )
	c_C := IIf(len(a_campos[1])>=3,a_campos[1,3],'' )
	c_D := IIf(len(a_campos[1])>=4,a_campos[1,4],'' )
	c_E := IIf(len(a_campos[1])>=5,a_campos[1,5],'' )
	c_F := IIf(len(a_campos[1])>=6,a_campos[1,6],'' )
	c_G := IIf(len(a_campos[1])>=7,a_campos[1,7],'' )
	c_H := IIf(len(a_campos[1])>=8,a_campos[1,8],'' )
	c_I := IIf(len(a_campos[1])>=9,a_campos[1,9],'' )
	c_J := IIf(len(a_campos[1])>=10,a_campos[1,10],'' )    


	//+-----------------------------------------------+
	//| Monta a tela para usuario visualizar consulta |
	//+-----------------------------------------------+
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000,000 TO 240,500 PIXEL
//	@ 010,010 LISTBOX oLbx FIELDS HEADER c_A, c_B, c_C, c_D, c_E, c_F, c_G, c_H, c_I, c_J On DBLCLICK (c_Ret := oLbx:AARRAY[oLbx:NAT][nPos], oDlg:End()) SIZE 230,095 OF oDlg PIXEL 
	@ 010,010 LISTBOX oLbx FIELDS HEADER c_A, c_B, c_C, c_D,c_E, c_F, c_G, c_H, c_I, c_J On DBLCLICK (ALTSTATUS(oLbx:nAt), oDlg:End()) SIZE 230,095 OF oDlg PIXEL        //henrique
	                                                			
	oLbx:SetArray( aVetor )
		                    
	c_Lst := '{|| {aVetor[oLbx:nAt,1],'
	For n_x := 2 to len(a_campos[2])-1
		c_Lst += '     aVetor[oLbx:nAt,'+Str(n_x)+'],'
	Next
	c_Lst += '    aVetor[oLbx:nAt,'+Str(len(a_campos[2]))+']}}'

	oLbx:bLine := &c_Lst
	c_Ret := &c_Lst
	
	DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION (c_Ret := oLbx:AARRAY[oLbx:NAT][nPos], oDlg:End()) ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg Centered
	
	RestArea( aSalvAmb )

Return c_Ret


Static Function ALTSTATUS(nPos)

	l_alterou := .T.
	
    c_query := " select  * "
    c_query += " from "+RetSqlName('ZA1')+" ZA1 "
    c_query += " where ZA1.D_E_L_E_T_ <> '*' order by  ZA1_CODSTA "
    
	c_Ret := MOSTRALT( nPos) //c_query , {{"CODIGO", "DESCRICAO"}, {"ZA1_CODSTA", "ZA1_DESSTA"}}, "Selecione o novo Status", 1)
	
	DbSelectArea('AF1')
	DbSetOrder(1)
	DbSeek(xFilial('AF1')+avetor[nPos, 1])

	RecLock('AF1', .F.)
	AF1->AF1_XSTAT := c_Ret
	If c_Ret = '09'
		If msgYesNo('Confirma a atualiza��o como proposta aprovada? Ser� possivel gerar um projeto com esse status!', 'A T E N � � O')
			AF1->AF1_FASE := '07'
		EndIf
	EndIf
	If c_Ret $ '05/06'
		AF1->AF1_FASE := '05'
	EndIf
	If c_Ret $ '07/08'
		AF1->AF1_FASE := '06'
	EndIf
	MsUnLock()

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FGEN008   �Autor  �Alexandre Sousa     � Data �  04/13/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao generica para mostrar o resultado de uma query.      ���
�������������������������������������������������������������������������͹��
���Parametros�c_Query: Query a ser excutada para obter informacoes.       ���
���          �a_campos:Array contendo uma coluna com a descricao dos cam- ���
���          �pos que sera mostrada na List, e outra contendo o nome dos  ���
���          �campos que serao retornados pela query.                     ���
���          �c_tit: Titulo da janela.                                    ���
���          �n_pos: Posicao do campo a ser retornado pela consulta.      ���
���          �c_Ret: String com o valor do campo informado.               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MOSTRALT(nPos) //c_Query, a_campos, c_tit, n_pos)

	Local aSalvAmb	:= GetArea()
	Local cTitulo 	:= 'Informe novo STATUS do Or�amento'//Iif( c_tit = Nil, "T�tulo", c_tit)
	Local nPos		:= 1 //Iif(n_pos = Nil, 1, n_pos)
	Local n_x		:= 0
	Local c_Lst		:= ''
//	Private aVetor 	:= {}

//	MSGALERT(oLbx:AARRAY[oLbx:NAT][nPos])
	DbSelectArea('AF1')
	DbSetOrder(1)
	DbSeek(xFilial('AF1')+oLbx:AARRAY[oLbx:NAT][nPos])

	Private oDlg	:= Nil
//	Private oLbx	:= Nil
	Private c_Ret	:= ''
	Private c_termom:= '      '
	Private d_dtRet	:= AF1->AF1_XDTRET 
	Private d_dtFollow := ddatabase      // INCLUIDO PARA RECEBER DATABASE DO DIA DE ALTERA��O NO FOLLOWUP
	Private c_texto := ''

// 	If Select("QRX") > 0
//		DbSelectArea("QRX")
//		DbCloseArea()
//	EndIf
//	TcQuery c_Query New Alias "QRX"

	//+-------------------------------------+
	//| Carrega o vetor conforme a condicao |
	//+-------------------------------------+
//	While QRX->(!EOF())
//		aAdd(aVetor, Array(len(a_campos[2])))
//		
//		For n_x := 1 to len(a_campos[2])
//			aVetor[len(aVetor),n_x] := ALLTRIM(&("QRX->"+a_campos[2,n_x]))
//		Next
//		QRX->(dbSkip())
//	End

//	If Len( aVetor ) == 0
//	   Aviso( cTitulo, "Nao existe dados para a consulta", {"Ok"} )
//	   Return
//	Endif

	//+-----------------------------------------------+
	//| Limitado a dez colunas                        |
	//+-----------------------------------------------+
//	c_A := IIf(len(a_campos[1])>=1,a_campos[1,1],'' )
//	c_B := IIf(len(a_campos[1])>=2,a_campos[1,2],'' )
//	c_C := IIf(len(a_campos[1])>=3,a_campos[1,3],'' )
//	c_D := IIf(len(a_campos[1])>=4,a_campos[1,4],'' )
//	c_E := IIf(len(a_campos[1])>=5,a_campos[1,5],'' )
//	c_F := IIf(len(a_campos[1])>=6,a_campos[1,6],'' )
//	c_G := IIf(len(a_campos[1])>=7,a_campos[1,7],'' )
//	c_H := IIf(len(a_campos[1])>=8,a_campos[1,8],'' )
//	c_I := IIf(len(a_campos[1])>=9,a_campos[1,9],'' )
//	c_J := IIf(len(a_campos[1])>=10,a_campos[1,10],'' )

	//+-----------------------------------------------+
	//| Monta a tela para usuario visualizar consulta |
	//+-----------------------------------------------+
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000,000 TO 270,500 PIXEL

	@ 01, 01.3  Get c_texto MEMO Size 230,065

	@ 06.8, 01 say "Status(Termometro)" OF oDlg 

//@ 98,21 Get cVar F3 "SA1" Size 76,10

	@ 90, 64 get c_termom F3 'ZA1'  Size 40,10 //OF oDlg 
                           

	@ 08, 01 say "Data de Retorno" OF oDlg 
	@ 08, 08 get d_dtRet OF oDlg 

//	@ 010,010 LISTBOX oLbx FIELDS HEADER c_A, c_B, c_C, c_D, c_E, c_F, c_G, c_H, c_I, c_J On DBLCLICK (c_Ret := oLbx:AARRAY[oLbx:NAT][nPos], oDlg:End()) SIZE 230,095 OF oDlg PIXEL 
	                                                			
//	oLbx:SetArray( aVetor )
		                    
//	c_Lst := '{|| {aVetor[oLbx:nAt,1],'
//	For n_x := 2 to len(a_campos[2])-1
//		c_Lst += '     aVetor[oLbx:nAt,'+Str(n_x)+'],'
//	Next
//	c_Lst += '    aVetor[oLbx:nAt,'+Str(len(a_campos[2]))+']}}'

//	oLbx:bLine := &c_Lst
//	c_Ret := &c_Lst
	
//	DEFINE SBUTTON FROM 127,213 TYPE 1 ACTION (c_Ret := oLbx:AARRAY[oLbx:NAT][nPos], oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 107,183 TYPE 2 ACTION  (oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION (Iif(gravatudo(),oDlg:End(),)) ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg Centered
	
	RestArea( aSalvAmb )

Return c_Ret


Static Function gravatudo()
                                 
	Local l_Ret := .T.

	If Empty(c_termom)
		msgalert('Informe um novo status para o or�amento!!', "A T E N � � O")
		Return .F.
	EndIf
	If d_dtRet <= dDataBase  
		msgalert('A data de retorno n�o pode ser menor que a data atual!!', "A T E N � � O")
		Return .F.
	EndIf 
	// luiz henrique - 26/10/2015 .... criado expressao abaixo Solicitado pelo Sr.Edson data do retorno no max 60 dias !
	If d_dtRet >= dDataBase + 61  
		msgalert('A data de retorno n�o pode ser maior que 60 dias !!', "A T E N � � O")
		Return .F.
	EndIf
	If Empty(c_texto)
		msgAlert('Informe os detalhes do contato com o cliente!!', "A T E N � � O")
		Return .F.
	EndIf    
	//incluido bloco abaixo [Mauro Nagata, Actual Trend, 20170110]
	If c_termom $ GetMV("LP_STNAPRV")  //status da tabela ZA1 que ira atribuir a fase 05
		Return(MsgBox("Ser� atribu�da esta proposta a fase 05-PROP. NAO APROVADA. Manter este STATUS ?","STATUS","YESNO"))
	EndIf	
	//fim bloco [Mauro Nagata, Actual Trend, 20170110]
	
	RecLock("AF1", .F.)       
	AF1->AF1_XDTFOL := d_dtFollow
	AF1->AF1_XDTRET	:= d_dtRet
	AF1->AF1_XSTAT	:= c_termom
	AF1->AF1_XHIST	:= AF1->AF1_XHIST  + chr(10) + chr(13) + chr(10) + chr(13) +"==>>Contato em "+DtoC(dDataBase)+" por " + AllTrim(cusername) + ": " + c_texto
	//incluida linha abaixo [Mauro Nagata, Actual Trend, 20170110]
	//quando AF1_XSTAT igua a MV_STAPRV gravar 05 PROP. NAO APROVADA  - Artur
	AF1->AF1_FASE   := If(c_termom$GetMV("LP_STNAPRV"),"05",AF1->AF1_FASE)
	MsUnLock()

Return l_ret