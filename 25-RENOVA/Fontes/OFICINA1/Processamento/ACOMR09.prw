#include "topconn.ch"
#include "protheus.ch"
#INCLUDE "FILEIO.CH"
#INCLUDE "APWEBSRV.CH"   

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ACOMR09   �Autor  �Felipi Marques      � Data �  05/31/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �   Fun��o que configura de acordo com a entidade o          ���
���          � certificado decomunica��o SSL utilizado pelo server.       ���
���          � TSSConfigSSL                                               ���
�������������������������������������������������������������������������͹�� 
���Retorno   � Array com o retorno dos certificados e senha               ���
���          � 	aReturn[1] -> Certificado _All.pem                        ���
���          �	aReturn[2] -> Certificado _Key.pem                        ���
���          �	aReturn[3] -> Senha do certificado                        ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function ACOMR09(cEntidade, cErro, oWs)

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cCertDir     	:= IIf(IsSrvUnix(),"/certs/", "\certs\") 
Local cPassCrt    	:= "" 
Local cFilePemKey	:= ""
Local cFilePemAll	:= ""
Local aReturn		:= {}
Local cAliasSpd 	:= GetNextAlias()
Local nCon          := 0
Local nAnt          := 0
Local lRotAuto      := .T.

DEFAULT cEntidade   := ""  
DEFAULT cErro		:= "" 
DEFAULT oWs			:= NIL 

//��������������������������������������Ŀ
//�Busca a senha na tabela de edentidades�
//����������������������������������������
DbSelectArea("Z05")
Z05->(DbSetOrder(1))   
IF Z05->(dbSeek(xFilial("Z05")+Alltrim(cIdEnt) )) 
	cPassCrt := Alltrim(Z05-> Z05_SENHA)
Else
	Conout( "| ACOMR09 | N�o encontrado o cadastro da endidade" ) 
EndIf

/*Monta o nome dos arquivos dos certificados de acordo com a entidade*/
cFilePemKey	:= cCertDir+cEntidade+"_key.pem"
cFilePemAll	:= cCertDir+cEntidade+"_all.pem" 
 
/*Verifica se existi os certificados para retornar*/
If ( File(cFilePemKey) .And. File(cFilePemAll) ) 
	aAdd(aReturn,cFilePemAll)
	aAdd(aReturn,cFilePemKey)
	aAdd(aReturn,AllTrim(  cPassCrt  )) 
		
	/*Caso o WS tenha sido passado no par�metro � atribu�do*/
	If ( oWs <>  NIL )      
		oWs:_CERT			:= cFilePemAll
		oWs:_PRIVKEY		:= cFilePemKey
		oWs:_PASSPHRASE		:= AllTrim(cPassCrt)	 		
	EndIf
Else
		Conout(CRLF + CRLF + "Verificar se os arquivos "+ cFilePemKey + " e " + cFilePemAll +" estao no diretorio "+ cCertDir + " ou se existem." + CRLF)
EndIf
		
Return aReturn