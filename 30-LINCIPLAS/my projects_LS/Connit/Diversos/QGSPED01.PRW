#INCLUDE "rwmake.ch"                                

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ QGSPED01 º Autor ³ Ricardo Felipelli  º Data ³  04/02/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Integracao da folha de pagamento na contabilidade          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ mp8 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function QGSPED01
Local _Opcao := .f.

If MsgYesNO("Confirma Processamento?","Corrige Codigo Municipio SA1/SA2 - SPED")
	Processa({|| CorSA1SA2()},"Corrigindo Dados...")
	MsgStop("Correcao Finalizada!!!")
	
EndIf

Return nil



Static Function CorSA1SA2()

cArqLog := Criatrab(nil,.f.)

nHdlArq:=FCreate(cArqLOG)
PAGI  :=  1
li    := 80
cLine := ""
cCRLF := CHR(13)+CHR(10)
If nHdlArq==-1
	tone(5000,1)
	alert("Impossivel Criar Arquivo LOG " + cArqLog + " Verificar...")
	Return nil
Endif
nCtErro:=0

cLine := "INICIANDO O LOG - CORRECAO DO CODIGO DO MUNICIPIO - SPED" + cCRLF
fWrite(nHdlArq,cLine,Len(cLine))

cLine := "-------------------------------------"
fWrite(nHdlArq,cLine,Len(cLine))

cLine := "DataBase...........: "+Dtoc(dDataBase) + cCRLF
fWrite(nHdlArq,cLine,Len(cLine))

cLine := "Data...............: "+Dtoc(MsDate()) + cCRLF
fWrite(nHdlArq,cLine,Len(cLine))

cLine := "Hora...............: "+Time() + cCRLF
fWrite(nHdlArq,cLine,Len(cLine))

cLine := "Environment........: "+GetEnvServer() + cCRLF
fWrite(nHdlArq,cLine,Len(cLine))


cLine := "" + cCRLF
fWrite(nHdlArq,cLine,Len(cLine))
cLine := "" + cCRLF
fWrite(nHdlArq,cLine,Len(cLine))

dbselectarea("SA1")
dbsetorder(01)
dbselectarea("SA2")
dbsetorder(01)
dbselectarea("CC2")
dbsetorder(02)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CRIA / Abre os Arquivos de Trabalho      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArquivo  := Directory("E:\Protheus_Data\system\Integracao\FolhaPag\TST\*.dbf","D")     
cDiretorio:= "\system\Integracao\FolhaPag\TST\"
//cDiretorio:= "\system\Integracao\FolhaPag\"                                        
//E:\Protheus_Data\system\Integracao\FolhaPag\TST


DBUseArea( .T.,,"MUNICIP", "MUN", .F., .F. )         
cChave := "MUNICM"
cindex := Criatrab(Nil,.F.)
IndRegua("MUN",cindex,cChave,,,"Selecionando Registros")


dbselectarea("SA1")
dbsetorder(01)
cLine := "Arquivo............: SA1010" + cCRLF
fWrite(nHdlArq,cLine,Len(cLine))
while SA1->(!eof())
                          
	IncProc("Corrigindo... Aguarde...")
	CC2->(dbseek(space(02)+ALLTRIM(SA1->A1_MUN)))
	if CC2->(found())
		if empty(SA1->A1_COD_MUN)
				RecLock("SA1",.F.)
				SA1->A1_COD_MUN := CC2->CC2_CODMUN
				MsUnLock()
				cLine := "Municipio: " + SA1->A1_MUN + " - " + CC2->CC2_CODMUN
				fWrite(nHdlArq,cLine,Len(cLine))
		endif
	endif
	
	SA1->(DBSKIP())	
enddo


dbselectarea("SA2")
dbsetorder(01)
cLine := "Arquivo............: SA2010" + cCRLF
fWrite(nHdlArq,cLine,Len(cLine))
while SA2->(!eof())
                          
	IncProc("Corrigindo... Aguarde...")
	CC2->(dbseek(space(02)+ALLTRIM(SA2->A2_MUN)))
	if CC2->(found())
		if empty(SA2->A2_COD_MUN)
				RecLock("SA2",.F.)
				SA2->A2_COD_MUN := CC2->CC2_CODMUN
				MsUnLock()
				cLine := "Municipio: " + SA2->A2_MUN + " - " + CC2->CC2_CODMUN
				fWrite(nHdlArq,cLine,Len(cLine))
		endif
	endif
	
	SA2->(DBSKIP())	
enddo


dbselectarea("SM0")
dbsetorder(1)
cLine := "Arquivo............: SIGAMAT" + cCRLF
fWrite(nHdlArq,cLine,Len(cLine))
while SM0->(!eof())                          
	IncProc("Corrigindo... Aguarde...")
	CC2->(dbseek(space(02) + SM0->M0_ESTCOB + SM0->M0_CIDCOB))
	//cc2_filial, cc2_est, cc2_codmun
	if CC2->(found())
//		if empty(SA2->A2_COD_MUN)
				RecLock("SM0",.F.)
				SM0->M0_CODMUN := CC2->CC2_CODMUN
				MsUnLock()
				cLine := "Municipio: " + SM0->M0_CIDCOB + " - " + CC2->CC2_CODMUN
				fWrite(nHdlArq,cLine,Len(cLine))
//		endif
	endif
	
	SA2->(DBSKIP())	
enddo


  
fclose(nHdlArq)
/*
_abre_arq := "\system\" + cArqLog 
LjMsgRun("Aguarde a exibicao do Log.",,{|| WaitRun("WRITE "+&_abre_arq+'"') } )  
*/
  

return nil


