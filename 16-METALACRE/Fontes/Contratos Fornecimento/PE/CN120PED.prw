#Include "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � CN120PED � Autor � Luiz Alberto V Alves � Data � Abril/2014���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto Entrada Para Bloqueio de Pedidos de Compras
				Gerados atraves do m�dulo de gest�o de contratosg  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Metalacre                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                   
User Function CN120PED()

Local aCab := PARAMIXB[1] 
Local aItm := PARAMIXB[2] 
Local aArea:= GetArea() 

If	CN1->(dbSetOrder(1), dbSeek(xFilial("CN1")+CN9->CN9_TPCTO))
	If CN1->CN1_ESPCTR == '1' // Tipo Contrato Compras
		For Nx:=1 to Len(aItm) 
			If aScan(aItm[Nx],{|x|x[1]=="C7_CC"}) > 0     // Se Localizar o Campo C7_CC ent�o trata-se de Pedido de Compras
				aAdd(aItm[Nx],{"C7_CONAPRO",'B',nil})     // Ira sempre Gerar o Pedido de Compras Com Bloqueio
				aAdd(aItm[Nx],{"C7_APROV",CN1->CN1_GRPAPR,nil}) 
			EndIf 
		Next 
	Endif
Endif
RestArea(aArea) 
Return({aCab,aItm}) 