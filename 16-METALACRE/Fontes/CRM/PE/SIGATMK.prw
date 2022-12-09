#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "Protheus.Ch"
#Include "VKEY.Ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SIGATMK  บ Autor ณ Luiz Alberto       * Data ณ  12/05/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de entrada para checagem de Contratos Vencidos       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
	
	If SA3->(dbSetOrder(7), dbSeek(xFilial("SA3")+__cUserID)) .And. !lJaFoi     // Se o Usuario for Vendedor entใo Abre tela de Ciclo Automaticamente.
		U_SelCiclo()                                                       
		lJaFoi := .t.
	Endif
Endif

