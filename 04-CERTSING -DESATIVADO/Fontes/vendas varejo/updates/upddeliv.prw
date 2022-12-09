#INCLUDE "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
����������������������-��������������������������������������������������Ŀ��
���Fun�ao    �UPDDELIV  � Autor � MICROSIGA             � Data � 18/02/14 ���
�����������������������-�������������������������������������������������Ĵ��
���Descri�ao � Funcao Principal                                           ���
������������������������-������������������������������������������������Ĵ��
���Uso       � Gestao Hospitalar                                          ���
������������������������-�������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function UPDDELIV()

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

Processa({|| ProcATU()},"Processando [UPDDELIV]","Aguarde , processando prepara��o dos arquivos")

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
  		If Ascan(aRecnoSM0,{ |x| x[2] == M0_CODIGO}) == 0 //.AND. M0_CODIGO == "01" 
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

			//����������������������������������Ŀ
			//�Atualiza o dicionario de arquivos.�
			//������������������������������������
			IncProc("Analisando Dicionario de Arquivos...")
			cTexto += GeraSX2()
			//�������������������������������Ŀ
			//�Atualiza o dicionario de dados.�
			//���������������������������������
			IncProc("Analisando Dicionario de Dados...")
			cTexto += GeraSX3()
			//��������������������Ŀ
			//�Atualiza os indices.�
			//����������������������
			IncProc("Analisando arquivos de �ndices. "+"Empresa : "+SM0->M0_CODIGO+" Filial : "+SM0->M0_CODFIL+"-"+SM0->M0_NOME)
			cTexto += GeraSIX()

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
			DEFINE MSDIALOG oDlg TITLE "Atualizador [GH876767] - Atualizacao concluida." From 3,0 to 340,417 PIXEL
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
���Fun�ao    � GeraSX2  � Autor � MICROSIGA             � Data �   /  /   ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Funcao generica para copia de dicionarios                  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function GeraSX2()
Local aArea 			:= GetArea()
Local i      		:= 0
Local j      		:= 0
Local aRegs  		:= {}
Local cTexto 		:= ''
Local lInclui		:= .F.

aRegs  := {}
AADD(aRegs,{"PAG","                                        ","PAG010  ","Cod Rastreamento x Tranportado","Cod Rastreamento x Tranportado","Cod Rastreamento x Tranportado","                                        ","C","C","C",00," ","                                                                                                                                                                                                                                                          "," ",00,"                                                                                                                                                                                                                                                              ","                              ","                              "})

dbSelectArea("SX2")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX2", lInclui)
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
Return('SX2 : ' + cTexto  + CHR(13) + CHR(10))
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
AADD(aRegs,{"PAG","01","PAG_FILIAL","C",02,00,"Filial","Filial","Filial","Filial","Filial","Filial","","","���������������","","",01,"��","","","U","S","A","R","","","","","","","","","033","","N","","","N","N","","","","N","N","N"})
AADD(aRegs,{"PAG","02","PAG_CODTRA","C",06,00,"Cod.Transp.","Cod.Transp.","Cod.Transp.","Cod.Transp.","Cod.Transp.","Cod.Transp.","@!","","���������������","","",01,"��","","","U","N","","","","","","","","","","","","","S","","","S","N","","","","N","N","N"})
AADD(aRegs,{"PAG","03","PAG_CODRAS","C",13,00,"Rastreamento","Rastreamento","Rastreamento","Rastreamento","Rastreamento","Rastreamento","@!","","���������������","","",01,"��","","","U","S","","","","","","","","","","","","","S","","","N","N","","","","N","N","N"})
AADD(aRegs,{"PAG","04","PAG_CODPED","C",06,00,"PedidoVenda","PedidoVenda","PedidoVenda","PedidoVenda","PedidoVenda","PedidoVenda","@!","","���������������","","",01,"��","","","U","S","","","","","","","","","","","","","S","","","N","N","","","","N","N","N"})
AADD(aRegs,{"PAG","05","PAG_STATUS","C",01,00,"Status","Status","Status","Status","Status","Status","","","���������������","","",01,"��","","","U","S","","","","","1=Incluido;2=Utilizado;3=Postado","1=Incluido;2=Utilizado;3=Postado","1=Incluido;2=Utilizado;3=Postado","","","","","","S","","","N","N","","","","N","N","N"})
AADD(aRegs,{"PAG","06","PAG_ENTREG","C",05,00,"Pos.Entrega","Pos.Entrega","Pos.Entrega","Pos.Entrega","Pos.Entrega","Pos.Entrega","","","���������������","","PG",01,"��","","","U","S","","","","","","","","","","","","","S","","","N","N","","","","N","N","N"})
AADD(aRegs,{"PAG","07","PAG_DESENT","C",40,00,"Desc.Posic.","Desc.Posic.","Desc.Posic.","Desc.Posic.","Desc.Posic.","Desc.Posic.","","","���������������","","",01,"��","","","U","S","V","V","","","","","","","","","","","S","","","N","N","","","","N","N","N"})
AADD(aRegs,{"PAG","08","PAG_CODPLP","C",09,00,"Cod.PLP","CodPLP","CodPLP","CodigoPLP","CodigoPLP","CodigoPLP","999999999","","���������������","","",00,"��","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

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
AADD(aRegs,{"SA1","O0","A1_XCOMPEN","C",40,00,"Comp.End.Ent","Comp.End.Ent","Comp.End.Ent","Comp.End.Entrega","Comp.End.Entrega","Comp.End.Entrega","@!","","���������������","","",01,"��","","","U","N","A","R","","texto()","","","","","","","","3","S","","","N","N","","","","N","N","N"})
AADD(aRegs,{"SA1","O0","A1_XNUMENT","N",5,00,"NumEndEntr","NumEndEntr","NumEndEntr","Num.End.Entrega","Num.End.Entrega","Num.End.Entrega","99999","","���������������","","",01,"��","","","U","N","A","R","","positivo()","","","","","","","","3","S","","","N","N","","","","N","N","N"})

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

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
AADD(aRegs,{"SC5","11","C5_CLIENTE","C",06,00,"Cliente","Cliente","Customer","CodigodoCliente","CodigodelCliente","CustomerCode","@!","A410Cli().And.A410ReCalc()","���������������","","SA1",01,"��","","","","S","","","","","","","","","","","001","1","S","","","N","N","","","N","N","N","N"})
AADD(aRegs,{"SC5","14","C5_TRANSP","C",06,00,"Transp.","Transp.","Carrier","CodigodaTransportadora","CodigodelTransportador","CarrierCode","@X","","���������������","","SA4",01,"��","","","","N","","","","","","","","","","","","1","S","","","N","N","","","N","N","N","N"})
AADD(aRegs,{"SC5","50","C5_TPFRETE","C",01,00,"TipoFrete","Tipoflete","FreightType","TipodoFreteUtilizado","TipodefleteUtiliz.","TypeofFreightUsed","X","pertence('CFTS')","���������������","","",01,"��","","","S","N","","R","","pertence('CFTS')","C=CIF;F=FOB;T=Porcontaterceiros;S=Semfrete","C=CIF;F=FOB;T=Porcontaterceiros;S=Semfrete","C=CIF;F=FOB;T=Porcontaterceiros;S=Semfrete","","","","","1","S","","","N","N","","","N","N","N","N"})
AADD(aRegs,{"SC5","51","C5_FRETE","N",12,02,"Frete","Flete","Freight","ValordoFrete","ValordelFlete","FreightValue","@E999,999,999.99","positivo().or.vazio()","���������������","","",01,"��","","","","N","","","","","","","","","","","","1","S","","","N","N","","","N","N","N","N"})
AADD(aRegs,{"SC5","79","C5_TPCARGA","C",01,00,"Carga","Carga","Cargo","Carga","Carga","Cargo","@!","Pertence('12')","���������������","'2'","",01,"��","","","","N","","","","","1=Utiliza;2=Naoutiliza","1=Utiliza;2=Noutiliza","1=Use;2=Doesnotuse","","","","","1","N","","","N","N","","","N","N","N","N"})

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

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
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    � GeraSIX  � Autor � MICROSIGA             � Data �   /  /   ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Funcao generica para copia de dicionarios                  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function GeraSIX()
Local aArea 			:= GetArea()
Local i      		:= 0
Local j      		:= 0
Local aRegs  		:= {}
Local cTexto 		:= ''
Local lInclui		:= .F.

aRegs  := {}
AADD(aRegs,{"PAG","1","PAG_FILIAL+PAG_CODTRA+PAG_CODRAS","Cod.Transp.+Rastreamento","Cod.Transp.+Rastreamento","Cod.Transp.+Rastreamento","U","","","S"})
AADD(aRegs,{"PAG","2","PAG_FILIAL+PAG_CODRAS+PAG_CODTRA","Rastreamento+Cod.Transp.","Rastreamento+Cod.Transp.","Rastreamento+Cod.Transp.","U","","","S"})
AADD(aRegs,{"PAG","3","PAG_FILIAL+PAG_CODPED+PAG_ENTREG","PedidoVenda+Pos.Entrega","PedidoVenda+Pos.Entrega","PedidoVenda+Pos.Entrega","U","","",""})

dbSelectArea("SIX")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])
 If !lInclui
  TcInternal(60,RetSqlName(aRegs[i, 1]) + "|" + RetSqlName(aRegs[i, 1]) + aRegs[i, 2])
 Endif

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SIX", lInclui)
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
Return('SIX : ' + cTexto  + CHR(13) + CHR(10))