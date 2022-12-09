#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "topconn.ch"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	LS_TSS
// Autor 		Alexandre Dalpiaz
// Data 		07/03/2013
// Descricao  	Reinicia os servicos do TSS / central de compras
// Uso         	LaSelva
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_TSS()
//////////////////////

If __cUserId $ GetMv('LA_PODER') + '/' + GetMv('LS_TSS')
	
	MsAguarde({|| WaitRun('taskkill /S terra /U ADMINISTRADOR /P _book5t0r3_ /F /IM TotvsAppServer_sped_tss1.exe', 0)},'Parando TSS 1')
	MsAguarde({|| WaitRun('taskkill /S terra /U ADMINISTRADOR /P _book5t0r3_ /F /IM TotvsAppServer_sped_tss2.exe', 0)},'Parando TSS 2')
	MsAguarde({|| WaitRun('taskkill /S terra /U ADMINISTRADOR /P _book5t0r3_ /F /IM TotvsAppServer_sped_tss3.exe', 0)},'Parando TSS 3')
	MsAguarde({|| WaitRun('taskkill /S terra /U ADMINISTRADOR /P _book5t0r3_ /F /IM TotvsAppServer_sped_tss4.exe', 0)},'Parando TSS 4')
	
	MsAguarde({|| WaitRun('sc \\terra start "Protheus10 TSS1"',0)},'Inciando TSS 4')
	MsAguarde({|| WaitRun('sc \\terra start "Protheus10 TSS2"',0)},'Inciando TSS 3')
	MsAguarde({|| WaitRun('sc \\terra start "Protheus10 TSS3"',0)},'Inciando TSS 2')
	MsAguarde({|| WaitRun('sc \\terra start "Protheus10 TSS4"',0)},'Inciando TSS 1')

	MsgBox('Servi�os reiniciados com sucesso','OK','INFO')
	
Else
	
	MsgBox('Somente usu�rios autorizados podem reiniciar os servi�os TSS (LS_TSS)','ATEN��O!!!','ALERT')

EndIf

return()


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_Central()
//////////////////////

If __cUserId $ GetMv('LA_PODER') + '/' + GetMv('LS_TSS')                                                 

	_nOpc := Aviso('Central de Compras','Escolha uma op��o:',{'Iniciar Servi�o','Parar/Iniciar Servi�o','Cancelar'},3,'Reinicializa��o do Servi�o Central de Compras')
	If _nOpc == 2
		WaitRun('taskkill /S terra  /U ADMINISTRADOR /P _book5t0r3_ /F /IM TotvsAppServer_Central.exe', 0)
	EndIf
	WaitRun('sc \\terra start "Protheus10Central"',0)
	MsgBox('Servi�o reiniciado com sucesso','OK','INFO')
Else
	MsgBox('Somente usu�rios autorizados podem reiniciar o servi�o Central de Compras (LS_TSS)','ATEN��O!!!','ALERT')
EndIf

return()
	
	
// \system\lsvcoma11.xnu                             
// \SYSTEM\LSVCOMA.xnu                               