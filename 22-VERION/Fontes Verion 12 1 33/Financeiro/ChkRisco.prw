#include "RwMake.ch"
#include "Protheus.ch"
#include "TopConn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CHKRISCO  �Autor  �Fernando Macieira   � Data � 19/Mar/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina que analisa e determina o risco do cliente, como E,  ���
���          �quando o titulo possuir vencimento superior a 28 dias, este ���
���          �definido no parametro MV_XVRISCO.                           ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico Verion                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ChkRisco()

Local aSays,aButtons,cTitulo,nOpc
aSays    := {}
aButtons := {}
nOpc     := 0
cTitulo  := "Analisa clientes com duplicatas vencidas para determinar seu risco"

aAdd(aSays,"V E R I O N")
aAdd(aSays,"-------------------------------------------------------------------------------------")
aAdd(aSays,"Rotina que analisa e determina o risco do cliente, como E, quando o ")
aAdd(aSays,"t�tulo possuir vencimento superior aos dias definidos no par�metro ")
aAdd(aSays,"MV_XVRISCO, utilizando a Data-Base.")

aAdd(aButtons,{1,.t.,{|o|nOpc:=1,o:oWnd:End()}})
aAdd(aButtons,{2,.t.,{|o|nOpc:=2,o:oWnd:End()}})
FormBatch(cTitulo,aSays,aButtons)

If nOpc == 1                                                         
	Pergunte("CHKRISCO", .T.)
	If msgBox("Confirma a execu��o da an�lise?","Confirma","YesNo")
		Processa({||RunRisco()},"Processando an�lise de duplicatas vencidas...")
	EndIf
EndIf

TRB->(dbCloseArea())
Work->(dbCloseArea())
WorkE1->(dbCloseArea())
fErase(CFILE)

Return

//������������������������
Static Function RunRisco()
//������������������������
Local cQuery,aCli,cQry,cCli,cLoja,nDias,dData,cFile,cRazao,cSitAnt

aCli  := {}
nDias := GetMv("MV_XVRISCO")
dData := dDataBase-nDias

aAdd(aCli,{"CLIENTE","C",06,0})
aAdd(aCli,{"LOJA   ","C",02,0})
aAdd(aCli,{"RAZAO  ","C",60,0})
aAdd(aCli,{"SIT_ANT","C",01,0})

cFile := e_CriaTrab(,aCli,"TRB")

If Select("Work") > 0
	Work->(dbCloseArea())
EndIf

cQuery := " SELECT * "
cQuery += " FROM " +RetSqlName("SA1") "
cQuery += " WHERE A1_FILIAL = '"+xFilial("SA1")+"' "
cQuery += " AND A1_RISCO <> 'E' "
cQuery += " AND D_E_L_E_T_ = ' ' "
tcQuery cQuery New Alias "Work"

ProcRegua(0)

dbSelectArea("Work")
Work->(dbGoTop())
While Work->(!EOF())
	cCli    := Work->A1_COD
	cLoja   := Work->A1_LOJA
	cRazao  := Work->A1_NOME
	cSitAnt := Work->A1_RISCO

	IncProc(AllTrim(cCli+"/"+cLoja+" - "+cRazao))

	If Select("WorkE1") > 0
		WorkE1->(dbCloseArea())
	EndIf

	cQry := " SELECT COUNT(1) REGS "
	cQry += " FROM " +RetSqlName("SE1") "
	cQry += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' "
	cQry += " AND E1_CLIENTE = '"+cCli+"' "
	cQry += " AND E1_LOJA = '"+cLoja+"' "
	cQry += " AND E1_TIPO NOT IN ('NCC','RA','PI-','CS-','CF-','AB-') "
	cQry += " AND E1_SALDO > 0 "
	cQry += " AND E1_VENCREA <= '"+DtoS(dData)+"' " 
	cQry += " AND D_E_L_E_T_ = ' ' "
	cQry += " AND E1_EMISSAO >= '"+DtoS(mv_par01)+"' " 
	
	tcQuery cQry New Alias "WorkE1"
	
	If (WorkE1->REGS) > 0
		RecLock("TRB",.t.)
		 CLIENTE := cCli
		 LOJA    := cLoja
		 RAZAO   := cRazao
		 SIT_ANT := cSitAnt
		TRB->(msUnLock())
		AltRisco(cCli,cLoja)
	EndIf
	Work->(dbSkip())
End

If TRB->(RecCount()) > 0
	Processa({||GeraTXT()},"Gerando arquivo dos clientes alterados...")
Else 
	msgStop("Nenhum cliente alterado","Aten��o")
EndIf
Return
                                  
//����������������������������������
Static Function AltRisco(cCli,cLoja)
//����������������������������������
Local cQuery
cQuery := " UPDATE " +RetSqlName("SA1")+ " SET A1_RISCO = 'E' "
cQuery += " WHERE A1_FILIAL = '"+xFilial("SA1")+"' "
cQuery += " AND A1_COD = '"+cCli+"' "
cQuery += " AND A1_LOJA = '"+cLoja+"' "
cQuery += " AND D_E_L_E_T_ = ' '
tcSqlExec(cQuery)
tcSqlExec("Commit")
Return
                                  
//����������������������������������
Static Function GeraTXT()
//����������������������������������
Local cTxt,nRegCount,cEOL,cNomArq,nHdlText
                    
nRegCount := 0
cNomArq   := "CLIRISCO"
cEOL      := Chr(13)+Chr(10)

//Cria arquivo texto
cDir      := cGetFile("Arquivos Texto|*.TXT|Todos os Arquivos|*.*",;
             OEMtoAnsi("Selecione o diret�rio de grava��odo arquivo "+AllTrim(cNomArq)+".txt"),0,"SERVIDOR\",.T.,GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY)
cDir      := AllTrim(cDir)+cNomArq+".TXT"

If At(".TXT",cDir) > 0
	nHdlText := fCreate(cDir)
Else
	Aviso("Clientes Risco E","N�o foi selecionado nenhum arquivo para gravar",{"&Ok"},,"Sem Arquivo")
EndIf

cTxt := ""
cTxt := "CLIENTE"+";"+"LOJA"+";"+"NOME"+";"+"Situacao Anterior"
fWrite(nHdlText,cTxt+cEOL)

ProcRegua(0)

dbSelectArea("TRB")
TRB->(dbGoTop())
While TRB->(!EOF())
	IncProc("Processados " +Chr(32)+AllTrim(Str(nRegCount+1))+ " registros ")

	cTxt := ""
	cTxt := CLIENTE+";"+LOJA+";"+RAZAO+";"+SIT_ANT
	fWrite(nHdlText,cTxt+cEOL)
	
	TRB->(dbSkip())
	nRegCount++
End

fClose(nHdlText)
msgInfo("Arquivo gerado com sucesso!")

oExcelApp := msExcel():New()
oExcelApp:SetVisible(.t.)   
Return                                                                    
