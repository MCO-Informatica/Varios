#INCLUDE 'PROTHEUS.CH'
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fMotivoP � Autor � Giane - ADV Brasil � Data �  22/02/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Tela para usuario digitar motivo de inclusao/altera��o do  ���
���          � pedido de vendas.                                          ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico MAKENI / televendas /pedido de vendas           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function fMotivoP(cTipo)
	Local _i    := 0
	Local _oDlg		// Tela
	Local cOper := ""   

	Private _cMotivo := "" 

	If cTipo == 'I'
		cOper := 'Inclusao'
	elseif cTipo == 'A'
		cOper := 'Altera��o'
	endif

	//Declara��o de Variaveis Private dos Objetos
	SetPrvt("_oDlg","_oSay1","_oSay2","_oSay3","_oSay4","_oMotivo","_oSBtnOk","_oSBtnCancel")

	_cMotivo := space(300)

	//Definicao do Dialog e todos os seus componentes.
	_oDlg      := MSDialog():New( 089,232,374,1033,"Digite o Motivo da " + cOper + " do Pedido",,,.F.,,,,,,.T.,,,.T. )
	_oSay1     := TSay():New( 032,010,{|| dtoc( dDataBase ) },_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,068,008)
	_oSay2     := TSay():New( 032,080,{|| time() },_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
	_oSay4     := TSay():New( 056,010,{|| cUserName },_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,292,008)
	_oSay3     := TSay():New( 080,010,{||"Motivo :"},_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,070,008)
	_oMotivo   := TGet():New( 076,090,{|u| If(PCount()>0,_cMotivo:=u,_cMotivo)},_oDlg,310,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cMotivo",,)
	_oSBtnOk   := tButton():New( 104,320,"Ok",_oDlg,{||_lRet:=.T.,_oDlg:End()},30,10,,,,.T.)
	_oSBtnCanc := tButton():New( 104,360,"Cancelar",_oDlg,{||_lRet:=.F.,_oDlg:End()},30,10,,,,.T.)

	_oDlg:Activate(,,,.T.)

Return(_cMotivo)      