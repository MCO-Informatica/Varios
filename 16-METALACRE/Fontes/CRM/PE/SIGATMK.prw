#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "Protheus.Ch"
#Include "VKEY.Ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SIGATMK  � Autor � Luiz Alberto       * Data �  12/05/15   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada para checagem de Contratos Vencidos       ���
�������������������������������������������������������������������������͹��
���Uso       � AP5 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function SIGATMK()
Local lAbreCiclo	:=	GetNewPar("MV_HABCLV",.f.)

/*DPRITMK := GETNewPar("MV_PRITMK",'')

IF ALLTRIM(DPRITMK) < ALLTRIM(DTOS(DDATABASE)) 
   RecLock("SX6",.F.)
   X6_CONTEUD := DTOS(DDATABASE)
   MsUnlock()           
   
   Processa( {|| U_JOBFINAN() } )
   Processa( {|| U_JOBFINBLQ() } )
   Processa( {|| U_JobCiclo() } )
   Processa( {|| U_JobPedOp() } )
ENDIF 
  */

If lAbreCiclo
	SetKey(VK_F11, {|| U_CopyAcols() })		// Funcao para Replicar linha do Acols

	If Type("lJaFoi") == 'U'
		Public lJafoi := .f.
	Endif
	
	If SA3->(dbSetOrder(7), dbSeek(xFilial("SA3")+__cUserID)) .And. !lJaFoi     // Se o Usuario for Vendedor ent�o Abre tela de Ciclo Automaticamente.
		U_SelCiclo()                                                       
		lJaFoi := .t.
	Endif
Endif

