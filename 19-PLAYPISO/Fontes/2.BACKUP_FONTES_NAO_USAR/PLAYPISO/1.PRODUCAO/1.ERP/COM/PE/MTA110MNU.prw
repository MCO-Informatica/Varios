# include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA110MNU �Autor  �Alexandre Sousa     � Data �  05/19/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para adicionar botoes no cadastro de manut.���
���          �de solicitacoes de compras.                                 ���
�������������������������������������������������������������������������͹��
���Uso       �Utilizado para controlar um novo status de cotacao.         ���
�������������������������������������������������������������������������ͼ��  
���Mauro     � validacao para permitir alterar o status da solicitacao    ���
���08/02/2013�                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MTA110MNU()

Local aEmpres    := {}

AADD(aEmpres,{'01','01'}) 
AADD(aEmpres,{'01','02'})
AADD(aEmpres,{'01','03'})

aRotST :=	{	{ "ALTERAR STATUS","U_MTA1110XCT(,1)", 0 , 3},; 
					{ "FILTRAR","U_MTA1110XCT(,2)", 0 , 4}}

aAdd( aRotina,	{ "Manut.Cota��o",aRotST, 0 , 7})

	
Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA110MNU �Autor  �Microsiga           � Data �  05/19/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Manutencao do status.                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MTA1110XCT(c_alias,n_opc)

	Local aIndexSC1  := {}
                                      
   //incluido bloco abaixo [Mauro Nagata, Actual Trend, 08/02/2013]
   If (SC1->C1_QUANT = SC1->C1_QUJE).Or.!Empty(SC1->C1_RESIDUO)
      MsgBox("Altera��o negada. Solicita��o j� atendida ou eliminada por res�duo","Status","ALERT")
      Return
   EndIf    
   //fim bloco [Mauro Nagata, Actual Trend, 08/02/2013]
   
	cCombo := "C=C-Em Cota��o"
	aCombo := {"P-Pendente","C-Em Cota��o","A-Atendida"}
	cSTATUS := ''

	If n_opc = 1
		n_ok := 0
		@ 331,357 To 457,631 Dialog mkwdlg Title OemToAnsi("Escolha o novo status")
		@ 17,34 ComboBox cCombo Items aCombo Size 76,21
		@ 42,29 BmpButton Type 2 Action close(mkwdlg)
		@ 41,74 BmpButton Type 1 Action (n_ok:=1,close(mkwdlg))
		Activate Dialog mkwdlg
		If n_ok=1
			If cCombo = "P-Pendente"     
				cSTATUS := 'P'
			ElseIf cCombo = "C-Em Cota��o"
			       //incluido bloco abaixo [Mauro Nagata, Actual Trend, 08/02/2013]
				   If SC1->C1_APROV $ "BR"
				      MsgBox("Altera��o negada. Solicita��o est� Bloqueada ou Rejeitada.","Status [COTA��O]","ALERT")
				      Return
				   EndIf
				   //fim bloco [Mauro Nagata, Actual Trend, 08/02/2013]
				   
			       cSTATUS := 'C'
			Else
			   //incluido bloco abaixo [Mauro Nagata, Actual Trend, 08/02/2013]
			   If SC1->C1_QUANT > SC1->C1_QUJE.And.Empty(SC1->C1_RESIDUO)
			      MsgBox("Altera��o negada. Solicita��o n�o atendida completamente ou nem eliminada por res�duo.","Status [ATENDIDA]","ALERT")
			      Return
			   EndIf        
			   If SC1->C1_APROV $ "BR"
			      MsgBox("Altera��o negada. Solicita��o est� Bloqueada ou Rejeitada.","Status [ATENDIDA]","ALERT")
			      Return
			   EndIf
			   //fim bloco [Mauro Nagata, Actual Trend, 08/02/2013]
			   
				cSTATUS := 'A'
			EndIf
			
			a_area := GetArea()
			c_chave := xFilial('SC1')+SC1->C1_NUM
			DbSelectArea('SC1')
			DbSetOrder(1) //C1_FILIAL, C1_NUM, C1_ITEM, R_E_C_N_O_, D_E_L_E_T_
			DbSeek(c_chave)
			While SC1->(C1_FILIAL+C1_NUM) = c_chave
				RecLock('SC1', .F.)
				SC1->C1_STATUS := cSTATUS
				MsUnLock()
				SC1->(DbSkip())
			EndDo
			RestArea(a_area)
		EndIf
	    EndFilBrw('SC1',aIndexSC1)
	Else
		n_ok := 0
		@ 331,357 To 457,631 Dialog mkwdlg Title OemToAnsi("Escolha o novo status")
		@ 17,34 ComboBox cCombo Items aCombo Size 76,21
		@ 42,29 BmpButton Type 2 Action close(mkwdlg)
		@ 41,74 BmpButton Type 1 Action (n_ok:=1,close(mkwdlg))
		Activate Dialog mkwdlg
		If n_ok=1
			If cCombo = "P-Pendente"
				cSTATUS := 'P'
			ElseIf cCombo = "C-Em Cota��o"
				cSTATUS := 'C'
			Else
				cSTATUS := 'A'
			EndIf
			If empty(cSTATUS)
				cFiltraSC1 := ''
			Else
				cFiltraSC1 := 'C1_STATUS = "' + cSTATUS +'"'
			EndIf
		    EndFilBrw('SC1',aIndexSC1)
			bFiltraBrw 	:= {|| FilBrowse("SC1",@aIndexSC1,@cFiltraSC1)}
			Eval(bFiltraBrw)

		EndIf
		
	EndIf

Return                                   
