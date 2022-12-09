#INCLUDE "PROTHEUS.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MA410LEG  � Autor � Eneovaldo Roveri Juni � Data �16/11/2009���
�������������������������������������������������������������������������Ĵ��
���Descricao � adicionar cor a legenda                                    ���
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function MA410LEG()
Local aCores := {}	

IF TYPE( "PARAMIXB" ) == "A"
	aCores := PARAMIXB
ENDIF
	nPos := ascan(aCores, {|x| x[1] = "BR_AZUL"})
	aCores[nPos,2] :=  "Pedido de Venda com Bloqueio de Cr�dito"
	nPosLar := ascan(aCores, {|x| x[1] = "BR_LARANJA"})
	aCores[nPosLar,2] :=  "Pedido de Venda Liberado no Cr�dito"
	Aadd( aCores,{ "BR_CINZA" ,"Cancelado" } )
	Aadd( aCores,{ "BR_PINK"  ,"Reprovado" } )
	Aadd( aCores,{ "BR_BRANCO"  ,"Bloqueio de Margem" } )
	Aadd( aCores,{ "BR_VIOLETA"  ,"Bloqueio Risco de Fraude" } )

Return( aCores )
