#include "protheus.ch"  
#include "colors.ch"  
#include "font.ch"  


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FISP001   �Autor  �Henio Brasil        � Data �  03/09/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Processo para tratar Data de Movimentacao Financeira e      ���
���          �Fiscal no sistema : MV_DataFis e MV_DataFin                 ���
�������������������������������������������������������������������������͹��
���Uso       �CertiSign Certificados                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FISP001() 
Local aAreaSx6	:= GetArea()
Local dDataFis := GetMv("MV_DATAFIS")
Local dDataFin := GetMv("MV_DATAFIN")
Private cCadastro := "Alterar par�metros Fiscal/Financeiro"

DEFINE FONT oBold  NAME "Verdana" SIZE  0, -12 Bold
DEFINE MSDIALOG oDlg TITLE cCadastro OF oMainWnd PIXEL FROM 120,170 TO 245,635 STYLE DS_MODALFRAME STATUS
oDlg:lEscClose := .F.

@ 015,010 Say "Fiscal bloqueado at�:"     SIZE 100,15 PIXEL OF oDlg FONT oBold
@ 030,010 Say "Financeira bloqueado at�:" SIZE 100,15 PIXEL OF oDlg FONT oBold

@ 014,100 MSGET dDataFis  SIZE 50, 10 OF oDlg PIXEL HASBUTTON Valid (dDataFis <= dDataBase) 
@ 029,100 MSGET dDataFin  SIZE 50, 10 OF oDlg PIXEL HASBUTTON Valid ValidarData( @dDataFin )

@ 020,190 BUTTON "&Confirma" SIZE 36,16 PIXEL ACTION (FWMsgRun(,{|| Iif(ValidarData(@dDataFin),(AtuDataFis(dDataFis,dDataFin),oDlg:End()),NIL)},,'Atualizando par�metros...'))
@ 040,190 BUTTON "C&ancela"  SIZE 36,16 PIXEL ACTION (Iif(MsgYesNo('Quer realmente sair da rotina?',cCadastro),(oDlg:End()),NIL))

ACTIVATE MSDIALOG oDlg  CENTERED

RestArea(aAreaSx6)
Return

Static Function ValidarData( dDataFin )
	Local dLastDay := Ctod('')
	Local lRet := .F.
	// Data informada � menor ou igual database?
	If dDataFin <= dDataBase
		// Capturar o �ltimo dia do m�s da data informada.
		dLastDay := LastDay( dDataFin )
		// O �ltimo dia da data informada � maior que a database?
		If dLastDay >= dDataBase
			// Capturar o �ltimo dia da data informada menos 1 m�s.
			dLastDay := LastDay( MonthSub( dDataFin, 1 ) )
		Endif	
		If dDataFin <> dLastDay
			MsgAlert('A data do par�metro financeiro n�o pode ser diferente do �ltimo dia do m�s ('+Dtoc(dLastDay)+').',cCadastro)
		Else
			lRet := .T.
		Endif
	Else
		MsgAlert('A data informada tem que ser o �ltimo dia do m�s anterior.',cCadastro)
	Endif
Return( lRet )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FISP001   �Autor  �Henio Brasil        � Data �  03/09/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Processo para tratar Data de Movimentacao Financeira e      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function AtuDataFis(dFis,dFin) 

Local dDataFis2	:= GetMv("MV_DATAFIS")
Local dDataFin2	:= GetMv("MV_DATAFIN")

If dDataFis2<>dFis
	PutMv("MV_DATAFIS",dFis)
Endif 

If dDataFin2<>dFin
    PutMv("MV_DATAFIN",dFin)
Endif

Return 