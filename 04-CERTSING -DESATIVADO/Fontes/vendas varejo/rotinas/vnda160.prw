#INCLUDE "PROTHEUS.CH"                                         
#INCLUDE "FWMVCDEF.CH"


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VNDA160  � Autor �                    � Data �             ���
�������������������������������������������������������������������������͹��
���Descricao � Job de Pesquisa para Cnabs no diretorio parametrizado      ���
���          � e inclusao no banco de conhecimento                        ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs / Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������  
/*/    

User Function VNDA160(aParSch)

Local aPedGar := {}     

Local cJobEmp		:= aParSch[1]   //Empresa que ser� usada para abertura do atendimento
Local cJobFil 		:= aParSch[2]   //Filial que ser� usada para abertura do atendimento     
Local cSqlRet := ""
Local cArqCnab := ""
Local cArqCProc := ""
Local aDir  := {}
Local nCount := 1   
Local cID := ""
Local oModel 
Local _lJob 		:= (Select('SX6')==0) //Executa o acesso ao Servidor 

If _lJob
	RpcSetType(3)
	RpcSetEnv(cJobEmp,cJobFil)
EndIf

cArqCnab := GetNewPar("MV_DIRCNAB","\CNAB\PROCESSAR\")
cArqCProc := GetNewPar("MV_DIRCPRO","\CNAB\PROCESSADAS\")

//U_VNDA250(,)

oModel := FWLoadModel('VNDA250')

aDir := Directory(cArqCnab+"*.ret")

IF !Empty(aDir)
	For nCount := 1 to len(aDir) 

		oModel:SetOperation(MODEL_OPERATION_INSERT)
		oModel:Activate()
		oModel:SetValue("SZPMASTER","ZP_ARQUIVO",cArqCnab + aDir[nCount][1])

		If oModel:VldData()
			oModel:CommitData()
			U_GerFTCProc(cArqCnab + aDir[nCount][1], 1)
			FRename (cArqCnab + aDir[nCount][1],cArqCProc + aDir[nCount][1]	)    
		Else
			VarInfo("",oModel:GetErrorMessage())	
		Endif
		
		oModel:DeActivate()   
	Next
Endif