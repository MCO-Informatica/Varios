#INCLUDE "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
����������������������-��������������������������������������������������Ŀ��
���Fun�ao    �GH999999  � Autor � MICROSIGA             � Data � 12/02/2019 ���
�����������������������-�������������������������������������������������Ĵ��
���Descri�ao � Funcao Principal                                           ���
������������������������-������������������������������������������������Ĵ��
���Uso       � Gestao Hospitalar                                          ���
������������������������-�������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function UPDFLGNF()

cArqEmp 					:= "SigaMat.Emp"
__cInterNet 	:= Nil

PRIVATE cMessage
PRIVATE aArqUpd	 := {}
PRIVATE aREOPEN	 := {}
PRIVATE oMainWnd
Private nModulo 	:= 51 // modulo SIGAHSP

Set Dele On

lEmpenho				:= .F.
lAtuMnu					:= .F.

Processa({|| ProcATU()},"Processando [UPDFLGNF]","Aguarde , processando prepara��o dos arquivos")

Return()


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �ProcATU   � Autor �                       � Data �  /  /    ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao de processamento da gravacao dos arquivos           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Baseado na funcao criada por Eduardo Riera em 01/02/2002   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function ProcATU()
Local cTexto    	:= ""
Local cFile     	:= ""
Local cMask     	:= "Arquivos Texto (*.TXT) |*.txt|"
Local nRecno    	:= 0
Local nI        	:= 0
Local nX        	:= 0
Local aRecnoSM0 	:= {}
Local lOpen     	:= .F.

ProcRegua(1)
IncProc("Verificando integridade dos dicion�rios....")
If (lOpen := IIF(Alias() <> "SM0", MyOpenSm0Ex(), .T. ))

	dbSelectArea("SM0")
	dbGotop()
	While !Eof()
  		If Ascan(aRecnoSM0,{ |x| x[2] == M0_CODIGO}) == 0 .and. M0_CODIGO = "01"
			Aadd(aRecnoSM0,{Recno(),M0_CODIGO})
		EndIf			
		dbSkip()
	EndDo	

	If lOpen
		For nI := 1 To Len(aRecnoSM0)
			SM0->(dbGoto(aRecnoSM0[nI,1]))
			RpcSetType(2)
			RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
 		nModulo := 51 // modulo SIGAHSP
			lMsFinalAuto := .F.
			cTexto += Replicate("-",128)+CHR(13)+CHR(10)
			cTexto += "Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME+CHR(13)+CHR(10)

			ProcRegua(8)

			Begin Transaction

			//�������������������������������Ŀ
			//�Atualiza o dicionario de dados.�
			//���������������������������������
			IncProc("Analisando Dicionario de Dados...")
			cTexto += GeraSX3()
			
			End Transaction
	
			__SetX31Mode(.F.)
			For nX := 1 To Len(aArqUpd)
				IncProc("Atualizando estruturas. Aguarde... ["+aArqUpd[nx]+"]")
				If Select(aArqUpd[nx])>0
					dbSelecTArea(aArqUpd[nx])
					dbCloseArea()
				EndIf
				X31UpdTable(aArqUpd[nx])
				If __GetX31Error()
					Alert(__GetX31Trace())
					Aviso("Atencao!","Ocorreu um erro desconhecido durante a atualizacao da tabela : "+ aArqUpd[nx] + ". Verifique a integridade do dicionario e da tabela.",{"Continuar"},2)
					cTexto += "Ocorreu um erro desconhecido durante a atualizacao da estrutura da tabela : "+aArqUpd[nx] +CHR(13)+CHR(10)
				EndIf
				dbSelectArea(aArqUpd[nx])
			Next nX		

			RpcClearEnv()
			If !( lOpen := MyOpenSm0Ex() )
				Exit
		 EndIf
		Next nI
		
		If lOpen
			
			cTexto 				:= "Log da atualizacao " + CHR(13) + CHR(10) + cTexto
			__cFileLog := MemoWrite(Criatrab(,.f.) + ".LOG", cTexto)
			
			DEFINE FONT oFont NAME "Mono AS" SIZE 5,12
			DEFINE MSDIALOG oDlg TITLE "Atualizador [GH999999] - Atualizacao concluida." From 3,0 to 340,417 PIXEL
				@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL
				oMemo:bRClicked := {||AllwaysTrue()}
				oMemo:oFont:=oFont
				DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
				DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,""),If(cFile="",.t.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL //Salva e Apaga //"Salvar Como..."
			ACTIVATE MSDIALOG oDlg CENTER
	
		EndIf
		
	EndIf
		
EndIf 	

Return(Nil)


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MyOpenSM0Ex� Autor �Sergio Silveira       � Data �07/01/2003���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Efetua a abertura do SM0 exclusivo                         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Atualizacao FIS                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function MyOpenSM0Ex()

Local lOpen := .F.
Local nLoop := 0

For nLoop := 1 To 20
	dbUseArea( .T.,, "SIGAMAT.EMP", "SM0", .F., .F. )
	If !Empty( Select( "SM0" ) )
		lOpen := .T.
		dbSetIndex("SIGAMAT.IND")
		Exit	
	EndIf
	Sleep( 500 )
Next nLoop

If !lOpen
	Aviso( "Atencao !", "Nao foi possivel a abertura da tabela de empresas de forma exclusiva !", { "Ok" }, 2 )
EndIf

Return( lOpen )




/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � GeraSX3  � Autor � MICROSIGA             � Data �   /  /   ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Funcao generica para copia de dicionarios                  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function GeraSX3()
Local aArea 			:= GetArea()
Local i      		:= 0
Local j      		:= 0
Local aRegs  		:= {}
Local cTexto 		:= ''
Local lInclui		:= .F.

aRegs  := {}
AADD(aRegs,{"SC5","L6","C5_XFLAGRC","C",01,00,"Flag Env Rec","Flag Env Rec","Flag Env Sit","Flag Envio Site Recibo   ","Flag Envio Site          ","Flag Envio Site          ","@!                                           ","                                                                                                                                ","���������������","                                                                                                                                ","      ",00,"��"," "," ","U","N","V","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   ","1"," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","                                                  ","N  "," "," ","N","N","N"})
AADD(aRegs,{"SC5","L7","C5_XFLAGSF","C",01,00,"Flag Env Sof","Flag Env Sof","Flag Env Sit","Flag Envio Site Software ","Flag Envio Site          ","Flag Envio Site          ","@!                                           ","                                                                                                                                ","���������������","                                                                                                                                ","      ",00,"��"," "," ","U","N","V","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   ","1"," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","                                                  ","N  "," "," ","N","N","N"})
AADD(aRegs,{"SC5","L8","C5_XFLAGHW","C",01,00,"Flag Env Har","Flag Env Har","Flag Env Sit","Flag Envio Site Hardware ","Flag Envio Site          ","Flag Envio Site          ","@!                                           ","                                                                                                                                ","���������������","                                                                                                                                ","      ",00,"��"," "," ","U","N","V","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   ","1"," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","                                                  ","N  "," "," ","N","N","N"})
AADD(aRegs,{"SC5","L9","C5_XFLAGEN","C",01,00,"Flag Env Ent","Flag Env Ent","Flag Env Sit","Flag Envio Site Entrega  ","Flag Envio Site          ","Flag Envio Site          ","@!                                           ","                                                                                                                                ","���������������","                                                                                                                                ","      ",00,"��"," "," ","U","N","V","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   ","1"," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","                                                  ","N  "," "," ","N","N","N"})
AADD(aRegs,{"SC5","M0","C5_XFLAGCA","C",01,00,"Flag Env Can","Flag Env Can","Flag Env Sit","Flag Envio Site Cancela  ","Flag Envio Site          ","Flag Envio Site          ","@!                                           ","                                                                                                                                ","���������������","                                                                                                                                ","      ",00,"��"," "," ","U","N","V","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   ","1"," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","                                                  ","N  "," "," ","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,3] $ cTexto, "", aRegs[i,3] + "\")

 RecLock("SX3", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i


aRegs  := {}
AADD(aRegs,{"SC6","J6","C6_XFLAGRC","C",01,00,"Flag Env Rec","Flag Env Rec","Flag Env Sit","Flag Envio Site Recibo   ","Flag Envio Site          ","Flag Envio Site          ","@!                                           ","                                                                                                                                ","���������������","                                                                                                                                ","      ",00,"��"," "," ","U","N","V","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   ","1"," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","                                                  ","N  "," "," ","N","N","N"})
AADD(aRegs,{"SC6","J7","C6_XFLAGSF","C",01,00,"Flag Env Sof","Flag Env Sof","Flag Env Sit","Flag Envio Site Software ","Flag Envio Site          ","Flag Envio Site          ","@!                                           ","                                                                                                                                ","���������������","                                                                                                                                ","      ",00,"��"," "," ","U","N","V","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   ","1"," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","                                                  ","N  "," "," ","N","N","N"})
AADD(aRegs,{"SC6","J8","C6_XFLAGHW","C",01,00,"Flag Env Har","Flag Env Har","Flag Env Sit","Flag Envio Site Hardware ","Flag Envio Site          ","Flag Envio Site          ","@!                                           ","                                                                                                                                ","���������������","                                                                                                                                ","      ",00,"��"," "," ","U","N","V","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   ","1"," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","                                                  ","N  "," "," ","N","N","N"})
AADD(aRegs,{"SC6","J9","C6_XFLAGEN","C",01,00,"Flag Env Ent","Flag Env Ent","Flag Env Sit","Flag Envio Site Entrega  ","Flag Envio Site          ","Flag Envio Site          ","@!                                           ","                                                                                                                                ","���������������","                                                                                                                                ","      ",00,"��"," "," ","U","N","V","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   ","1"," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","                                                  ","N  "," "," ","N","N","N"})
AADD(aRegs,{"SC6","K0","C6_XFLAGCA","C",01,00,"Flag Env Can","Flag Env Can","Flag Env Sit","Flag Envio Site Cancela  ","Flag Envio Site          ","Flag Envio Site          ","@!                                           ","                                                                                                                                ","���������������","                                                                                                                                ","      ",00,"��"," "," ","U","N","V","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   ","1"," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","                                                  ","N  "," "," ","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,3] $ cTexto, "", aRegs[i,3] + "\")

 RecLock("SX3", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i

RestArea(aArea)
Return('SX3 : ' + cTexto  + CHR(13) + CHR(10))