// Funcao de execucao unica, para criar campo adicional na GTOUT
User Function UpdCertOu()

rpcsetenv('01','02')

USE GTOUT ALIAS GTOUT SHARED NEW VIA "TOPCONN"
If neterr()
	MsgStop("Falha ao abrir GTOUT")
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

lOk := TcAlter("GTOUT",aStru,aNewStru)

IF !lOk
	MsgStop(tcsqlerror(),"Falha em TCAlter GTOUT")
Else
	MSgInfo("Campos acrescentados com sucesso GTOUT")
Endif

Return
