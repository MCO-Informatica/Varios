// Funcao de execucao unica, para criar campo adicional na GTIN
User Function UpdCertIN()

rpcsetenv('01','02')

USE GTIN ALIAS GTIN SHARED NEW VIA "TOPCONN"
If neterr()
	MsgStop("Falha ao abrir GTIN")
	return
Endif

If ( fieldpos("GT_CCDOC") > 0 ) .OR. ( fieldpos("GT_CCCONF") > 0 ) .OR. ( fieldpos("GT_CCAUT") > 0 ) 
	MsgInfo("Campos JA CRIADOS NA TABELA GTIN")
	Return
Endif


aStru := dbstruct()

aNewStru := aclone(aStru)

aadd(aNewStru,{"GT_CCDOC"  ,"C",16,0})
aadd(aNewStru,{"GT_CCCONF" ,"C",16,0})
aadd(aNewStru,{"GT_CCAUT"  ,"C",16,0})

USE 



lOk := TcAlter("GTIN",aStru,aNewStru)

IF !lOk
	MsgStop(tcsqlerror(),"Falha em TCAlter GTIN")
Else
	MSgInfo("Campos acrescentados com sucesso GTIN")
Endif

Return
