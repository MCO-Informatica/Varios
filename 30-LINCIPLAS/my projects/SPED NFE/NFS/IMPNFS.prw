/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  |IMPNFS 	� Autor � Alessandra STCH	 �Data  |   24/02/12  ���
�������������������������������������������������������������������������͹��
���Descricao � Impressao da Nota Fiscal de Servi�o gerada pela            ���
���          �  Prefeitura de Guarulhos                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Linciplas							              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
#Include "PROTHEUS.CH"

User Function IMPNFS() 

	
	Local cNF
	Local cCodNFE
	Local cCCM 
	Local cCNPJ
	Local cCodNFE
	Local cLink
	Local cPosHif
	
	Private cPerg	:= "IMPRPS"                
	
	AjustaSx1(cPerg)  
	
	Pergunte(cPerg,.T.)
	
    DbSelectArea("SF3")
    DbSetOrder(6)
    DbgoTop()
    IF (DbSeek(xFilial("SF3")+MV_PAR02+MV_PAR01))
    
	    cNF:=""
		cCodNFE:=""
	
		IF !EMPTY(SF3->F3_DTCANC)
			MSGINFO("NF CANCELADA")
		ELSEIF !EMPTY(SF3->F3_NFELETR).AND.!EMPTY(SF3->F3_CODNFE)                   
		
			cCCM:="49256"
			cCNPJ:="62016217000147"
			cNF:=ALLTRIM(SF3->F3_NFELETR) 
			cCodNFE:= ALLTRIM(SF3->F3_CODNFE)
			cCodNFE1:= cCodNFE
			
			cPosHif:= AT("-",cCodNFE1)
			
			IF cPosHif > 0
				cCodNFE1:= SUBSTR(cCodNFE,1,cPosHif-1)
				cCodNFE1+= SUBSTR(cCodNFE,cPosHif+1,Len(cCodNFE)-cPosHif)
			ENDIF                   
			
			IF MV_PAR03 == 1
				cLink:= "http://guarulhos.ginfes.com.br/report/consultarNota?__report=nfs_ver4&cdVerificacao="
			ELSE
		   		cLink:= "http://guarulhos.ginfesh.com.br/report/consultarNota?__report=nfs_ver4&cdVerificacao="
			ENDIF
			
			cLink+= cCodNFE
			cLink+= "&numNota=
			cLink+= cNF 
			cLink+= "&cnpjPrestador=" 
			
			IF MV_PAR03 == 1
				cLink+= cCNPJ
			ELSE
		   		cLink+= "null#"
			ENDIF
			
			
			
			//WinExec("C:\Arquivos de Programas\Internet Explorer\iexplore.exe www.google.com")
			ShellExecute("open","iexplore.exe",cLink,"", 1 )              
		ENDIF
   ENDIF

Return         

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � AjustaSX1 � Autor � Eduardo Zanardo      � Data �19.12.2003���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ajusta as Perguntas do SX1                                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � AjustaSX1()                                                ���
�������������������������������������������������������������������������Ĵ��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function AjustaSx1(cPerg)
Local aArea := GetArea()

//+--------------------------------------------------------------+
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // RPS:            		         �
//+--------------------------------------------------------------+
PutSx1(cPerg,"01","Serie:","","","mv_ch1","C",3,0,0,"G","","SF201","","",;
		"MV_PAR01","","","","","","","","","","","","","","","","")  
PutSx1(cPerg,"02","Nro RPS:","","","mv_ch2","C",9,0,0,"G","","","","",;
		"MV_PAR02","","","","","","","","","","","","","","","","") 
PutSx1(cPerg,"03","Ambiente:","","","mv_ch3","C",1,0,1,"C","","","","",;
		"MV_PAR03","Producao","","","1","Homologa��o","","","","","","","","","","","") 


RestArea(aArea)

Return(.T.)