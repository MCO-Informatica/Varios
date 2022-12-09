#INCLUDE "Fileio.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Rdmake    �RCOMC01   |Autor  �Cosme da Silva Nunes   |Data  �07/08/2008|��
�������������������������������������������������������������������������Ĵ��
���Descri�ao �Programa p/ construcao da tela de visualizacao do historico ���
���          �de alteracao do custo standard                              ���
�������������������������������������������������������������������������Ĵ��
���Uso       �Gestao de Projetos                                          ���
�������������������������������������������������������������������������Ĵ��
���           Atualiza�oes sofridas desde a constru�ao inicial            ���
�������������������������������������������������������������������������Ĵ��
���Programador �Data      �Motivo da Altera�ao                            ���
�������������������������������������������������������������������������Ĵ��
���            |          |                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function RCOMC01()

Local oDlgPrd	:= Nil    
Local oListPrd	:= Nil       
Local aAreaBKP	:= GetArea()
Local aCoorden	:= MsAdvSize(.T.)
Local aPrds		:= {}       
Local nPosPrd	:= 0
Local cOpcao	:= ""                         

If !Empty(SB1->B1_COD)

	//Busca as ultimas alteracoes do custo standard do produto
	dbselectArea("ZA3")
	ZA3->(dbSetOrder(1))
	ZA3->(dbSeek(xFilial("SB1")+SB1->B1_COD))
	While ZA3->(!Eof()) .And. xFilial("SB1")+SB1->B1_COD == xFilial("ZA3")+ZA3->ZA3_PROD
		Aadd(aPrds,{ZA3->ZA3_CSANT,;
					ZA3->ZA3_CSATU,;
					ZA3->ZA3_DATA,;
					ZA3->ZA3_HORA,;
					ZA3->ZA3_USUAR,;
					IIF(UPPER(AllTrim(ZA3->ZA3_ORIG)) == "MATA010","PRODUTOS","PED.COMPRAS"),;
					ZA3->(RecNo())})
					/*ZA3->ZA3_PROD,;
					AllTrim(Posicione("SB1",1,xFilial("SB1")+AllTrim(ZA3->ZA3_PROD),"B1_DESC")),;*/
		ZA3->(dbSkip())
	EndDo                                                       
	
	If Len(aPrds) <= 0
		MsgAlert("Nenhuma altera�ao foi localizada para esse produto.")
		RestArea(aAreaBKP) //
		Return(Nil)
	EndIf
	
	//Tela com os historicos de alteracao do custo standard do produto
	oDlgPrd := TDialog():New(aCoorden[7],000,aCoorden[6]/1.5,aCoorden[5]/1.2,OemToAnsi("Hist�rico de Altera��o do Custo Standard"),,,,,,,,oMainWnd,.T.)
		@ 001,001 ListBox oListPrd VAR cOpcao Fields Header /*"Produto","Descris�o",*/"C.Std.Anter.","C.Std.Atual","Data","Hora","Usu�rio","Origem" Size oDlgPrd:nWidth/2-5,oDlgPrd:nHeight/2-40 PIXEL OF oDlgPrd
			oListPrd:SetArray(aPrds)
			oListPrd:bLine := {||{	aPrds[oListPrd:nAt][1],;
									aPrds[oListPrd:nAt][2],;
									aPrds[oListPrd:nAt][3],;
									aPrds[oListPrd:nAt][4],;
									aPrds[oListPrd:nAt][5],;
									aPrds[oListPrd:nAt][6]}}  
									/*	aPrds[oListPrd:nAt][1],;
									aPrds[oListPrd:nAt][2],;  */
		TButton():New(oDlgPrd:nHeight/2-27,140,OemToAnsi("&Fechar"),oDlgPrd,{|| oDlgPrd:End() },030,011,,,,.T.,,,,{|| })   									
	oDlgPrd:Activate(,,,.T.) 
EndIf

RestArea(aAreaBKP)
Return(Nil)