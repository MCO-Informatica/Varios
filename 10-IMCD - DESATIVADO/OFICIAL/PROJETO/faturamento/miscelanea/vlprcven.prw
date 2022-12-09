#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO3     �Autor  �Microsiga           � Data �  03/25/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VLPRCVEN

	Local aAreaAtu := GetArea()
	Local aAreaSC6 := SC6->( GetArea() )

	Local nValRet   := 0
	Local nPProduto	:= aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_PRODUTO" } )
	Local nPItem	:= aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_ITEM" } )
	Local nPPrcVen	:= aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_PRCVEN" } )
	Local nPPrcUni	:= aScan( aHeader, { |x| AllTrim( x[2] ) == "C6_PRUNIT" } )

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "VLPRCVEN" , __cUserID )

	If !Inclui .and. Altera
		SC6->( dbSetOrder( 1 ) )
		If SC6->( dbSeek( xFilial("SC6") + M->C5_NUM + aCols[n][nPItem] + aCols[n][nPProduto] ) )
			GDFieldPut( "C6_PRCVEN", SC6->C6_PRCVEN, n )
			//		MCMExecX3( "C6_PRCVEN", n )

			GDFieldPut( "C6_PRUNIT", SC6->C6_PRCVEN, n )
			//		MCMExecX3( "C6_PRUNIT", n )
		Endif
	Endif

	RestArea( aAreaSC6 )
	RestArea( aAreaAtu )

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MCMExecX3 �Autor  �Ivan Morelatto Tore � Data �  18/08/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Executa Valid, Valid de Usuario e Trigger do campo         ���
���          � informado                                                  ���
�������������������������������������������������������������������������͹��
���Uso       � MCOM002                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MCMExecX3( cCpoInf, nCntFor1 )

	Local aAreaAtu := GetArea()
	Local aAreaSX3 :=  GetArea() 
	Local cOldVar	:= __ReadVar

	cCpoInf := Left( cCpoInf + Space(10), 10 )

	__ReadVar := "M->" + cCpoInf
	&( "M->" + cCpoInf ) := GDFieldGet( cCpoInf, nCntFor1 )

	GetSx3Cache(cCpoInf,"X3_VALID")
	GetSx3Cache(cCpoInf,"X3_VLDUSER")
	
	RunTrigger( 2 )

	__ReadVar := cOldVar

	RestArea( aAreaSX3 )
	RestArea( aAreaAtu )

Return