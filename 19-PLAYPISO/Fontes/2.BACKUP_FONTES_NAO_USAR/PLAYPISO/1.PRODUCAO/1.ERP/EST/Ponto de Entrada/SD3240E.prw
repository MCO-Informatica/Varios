/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SD3240E   �Autor  �Alexandre Sousa     � Data �  11/17/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �P.E. durante o estorno do mov. interno                      ���
���          �Utilizado para sincronizar os estoques das filiais.         ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico LISONDA / ACTUAL TREND.                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SD3240E()

	If !VerRot("U_AEST001") .and. !VerRot("AEST001")
		If SD3->D3_TM == "499"
			Posicione("SB1",1,xFilial("SB1")+SD3->D3_COD,"B1_COD")
			//{quantidade,custo,ordem de producao,local,entidade,registro,tipo de movimento}      
			//U_AEST001({SD3->D3_QUANT,SD3->D3_CUSTO1,"",SD3->D3_LOCAL,"D3",SD3->(Recno()),"300"})  //[Mauro Nagata, Actual Trend, 19/11/2010]
			U_AEST001({SD3->D3_QUANT,SD3->D3_CUSTO1,"",SD3->D3_LOCAL,"D3",SD3->(Recno()),"011",SD3->D3_DOC})       //definir um TM para esta movimentacao especifica
		Else
			Posicione("SB1",1,xFilial("SB1")+SD3->D3_COD,"B1_COD")
			//{quantidade,custo,ordem de producao,local,entidade,registro,tipo de movimento}
			//U_AEST001({SD3->D3_QUANT,0,"",SD3->D3_LOCAL,"D3",SD3->(Recno()),"501"})   //[Mauro Nagata, Actual Trend, 19/11/2010]    
			U_AEST001({SD3->D3_QUANT,SD3->D3_CUSTO1,"",SD3->D3_LOCAL,"D3",SD3->(Recno()),"511",SD3->D3_DOC})       //definir um TM para esta movimentacao especifica
		EndIf
	EndIf

Return
/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa   � VerRot   � Autor � Jaime Wikanski            �Data�04.11.2002���
����������������������������������������������������������������������������͹��
���Descricao  � Verifica se estou na rotina desejada                         ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Static Function VerRot(cRotina)
//�������������������������������������������������������������������������Ŀ
//� Declaracao de variaveis                     						  		 	 �
//���������������������������������������������������������������������������
Local nActive   	:= 1
Local lExecRot 	:= .F.

//�������������������������������������������������������������������������Ŀ
//� Verifica a origem da rotina               								�
//���������������������������������������������������������������������������
While !(PROCNAME(nActive)) == ""
   If Alltrim(Upper(PROCNAME(nActive))) $ Alltrim(Upper(cRotina))
      lExecRot := .T.
      Exit
   Endif
   nActive++
Enddo

Return(lExecRot)

