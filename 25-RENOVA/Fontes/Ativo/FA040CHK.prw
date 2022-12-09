#INCLUDE 'PROTHEUS.CH'                 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA040CHK  �Autor  �                				22/05/2015���
�������������������������������������������������������������������������͹��
���Desc.     �Filtra Projeto Imobilziado em Curso						  ���
��           �						                                      ���
�������������������������������������������������������������������������͹��
���Uso       � Renova                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FA040CHK()
 
Local _cFiltro  := ''
Local _aAreaSN1 := SN1->(GetArea())
Local _aAreaSN3 := SN3->(GetArea())
Local oDlg
Local cOk	   := "Ok"
Local cCanc    := "Cancelar"
Local aAdvSize := MsAdvSize( .T. , .T. )

Public __cProjImb := Space(10) 
//Montagem da tela
DEFINE MSDIALOG oDlg TITLE "C�digo Projeto Imobilizado em Curso" STYLE DS_MODALFRAME FROM aAdvSize[7],0 TO aAdvSize[6] - 140 ,aAdvSize[5] - 200 PIXEL

oSay := TSay():New( 28, 10, {|| 'Cod. Proj Imob. em Curso: '},oDlg,,,,,, .T. )
@ 025, 075 MSGET __cProjImb	F3 "SZ0" SIZE 40, 11 OF oDlg PIXEL

@ 045, 100 BUTTON cOk	SIZE 30, 15 PIXEL OF oDlg ACTION {||oDlg:End(), lEnc := .T. }
@ 045, 150 BUTTON cCanc	SIZE 30, 15 PIXEL ACTION oDlg:End()      //precisa ajustar o retorno do cancelar

ACTIVATE MSDIALOG oDlg CENTERED
   

//Se o campo da tela acima for preenchido filtra personalziado, Sen�o filtra padr�o!
If !Empty(__cProjImb) //Fitro personalizado Renova Energias (Projeto Imobilizado em Curso) 
	_cFiltro := 'N3_FILIAL = "' + cMyFilial + '" .AND. '
	_cFiltro += 'N3_XPROJIM = "' + __cProjImb + '" .AND. '
	_cFiltro += 'N3_BAIXA != "1" .AND. N3_BAIXA != "2" .AND. '
	_cFiltro += 'N3_TIPO = "03" '
Else //Filtro Padr�o Protheus 11 
	_cFiltro := 'N3_FILIAL = "' + cMyFilial + '" .AND. '
	_cFiltro += 'N3_CBASE = "' + cBaseAdt + '" .AND. '
	_cFiltro += 'N3_BAIXA != "1" .AND. N3_BAIXA != "2" .AND. '
	_cFiltro += 'N3_TIPO = "03" 
EndIf
                      
RestArea(_aAreaSN1)
RestArea(_aAreaSN3)

Return(_cFiltro)