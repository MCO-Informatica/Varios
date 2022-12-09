#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFS002    �Autor  �Rodrigo Seiti Mitani� Data �  20/10/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �Libera��o de solicita��o de atendimento CS                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CertiSign                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function CSFS0002()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private aCores := {}
Private cString   := "PA0"
Private cCadastro := "Libera��o Solicita��o de Atendimento"
Private aRotina   := {  {"Pesquisar" ,"AxPesqui"  ,0,1},;
{ "Visualiza",'ExecBlock("CSF01VIS",.T.,.T.)',0,2}, ;
{ "Libera"   ,'ExecBlock("CSF02LIB",.T.,.T.)',0,3},;
{ "Rejeita"  ,'ExecBlock("CSF02REJ",.T.,.T.)',0,4},;
{ "Legenda"  ,'ExecBlock("CSF02LEG",.T.,.T.)',0,5},;
{ "Recepcao" ,'ExecBlock("CSF02REP",.T.,.T.)',0,6}}

aCores := {	{ "PA0_STATUS == 'A'.And.PA0_SITUAC == 'B'",'DISABLE'},;		   	//Pedido Encerrado
			{ "PA0_STATUS == 'F'.And.PA0_SITUAC == 'B'",'BR_MARROM'}}	//Pedido Liberado

dbSelectArea(cString)

bFiltraBrw := {|| FilBrowse("PA0",{},"PA0_SITUAC == 'B'.and. PA0_STATUS <> 'C'") }
Eval(bFiltraBrw)
dbSelectArea(cString)
PA0->(dbSetOrder(1))
MBrowse(6,1,22,75,cString,,,,,,aCores)


Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSF02LIB  �Autor  �Rodrigo Seiti Mitani� Data �  20/10/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �Libera��o de solicita��o de atendimento                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CertiSign                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CSF02LIB()
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private aTela[0][0]
Private aGets[0]
Private aHeader	:= {}
Private aCols	:= {}
Private nUsado	:= 0
_nOpca := 0


dbSelectArea("PA0")
dbSetOrder(1)
//���������������������������������������������������������������������������Ŀ
//� Inicializa desta forma para criar uma nova instancia de variaveis private �
//�����������������������������������������������������������������������������
RegToMemory( "PA0", .F., .F. )

//��������������������Ŀ
//� Inicializa aCols   �
//����������������������

dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("PA1")
While ( !Eof() .And. (SX3->X3_ARQUIVO == "PA1") )
	If X3USO(SX3->X3_USADO)
		nUsado++
		Aadd(aHeader,{ TRIM(X3Titulo()),;
		SX3->X3_CAMPO,;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID,;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT } )
	EndIf
	dbSelectArea("SX3")
	dbSkip()
EndDo

If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea("TRB")
End If


BeginSql Alias "TRB"
%noparser%
Select * From %Table:PA1% PA1
Where PA1_OS = %Exp:PA0->PA0_OS% and PA1_FILIAL = %Exp:xFilial("PA1")%
and PA1.%NotDel%
EndSql

/*
//����������������������������������������������������������Ŀ
//�Carrega o acols com as informa��es do registro posicionado�
//������������������������������������������������������������
*/
Do While !Eof("TRB")
	AADD(aCols,Array(Len(aHeader)+1))
	For nCntFor:=1 To Len(aHeader)
		If ( aHeader[nCntFor,10] <>  "V" )
			aCOLS[Len(aCols)][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor,2]))
		Else
			aCOLS[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor,2])
		EndIf
	Next nCntFor
	aCols[Len(aCols)][Len(aHeader)+1] := .F.
	DbSkip()
End Do

//�����������������������������Ŀ
//� Posiciona os objetos na tela
//�������������������������������

aSize := MsAdvSize()
aObjects := {}
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 015, .t., .f. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,;
{{003,033,160,200,240,263}} )

DEFINE MSDIALOG oDlg TITLE "Libera Solicita��o de Atendimento" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

EnChoice( "PA0", ,2, , , , , aPosObj[1],,3,,,)

oGetd:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],2    ,         ,        ,"",.T.     ,      ,       ,      , 10 ,        ,         ,,      ,    )
//  METHOD          New(nT          ,nL          ,          nB,         nR ,nOpc ,cLinhaOk ,cTudoOk ,cIniCpos ,lDeleta ,aAlter,nFreeze,lEmpty,nMax,cFieldOk,cSuperDel,,cDelOk,oWnd)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||_nOpcA:=1,oDlg:End()},{||oDlg:End()},,)


If _nOpcA == 1
	
	/*
	//����������������������������������������������Ŀ
	//�Grava libera��o da solicita��o de antendimento�
	//������������������������������������������������
	*/
	DbSelectArea("PA0")
	DbSetOrder(1)
	DbSeek(xFilial("PA0")+M->PA0_OS)
	If Found()
		RecLock("PA0",.F.)
		PA0->PA0_SITUAC := 'L'
		MsUnlock()
	End If
End If	

Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSF02REJ  �Autor  �Rodrigo Seiti Mitani� Data �  20/10/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rejeita de solicita��o de atendimento                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CertiSign                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CSF02REJ()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private aTela[0][0]
Private aGets[0]
Private aHeader	:= {}
Private aCols	:= {}
Private nUsado	:= 0
_nOpca := 0


dbSelectArea("PA0")
dbSetOrder(1)
//���������������������������������������������������������������������������Ŀ
//� Inicializa desta forma para criar uma nova instancia de variaveis private �
//�����������������������������������������������������������������������������
RegToMemory( "PA0", .F., .F. )

//��������������������Ŀ
//� Inicializa aCols   �
//����������������������

dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("PA1")
While ( !Eof() .And. (SX3->X3_ARQUIVO == "PA1") )
	If X3USO(SX3->X3_USADO)
		nUsado++
		Aadd(aHeader,{ TRIM(X3Titulo()),;
		SX3->X3_CAMPO,;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID,;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT } )
	EndIf
	dbSelectArea("SX3")
	dbSkip()
EndDo

If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea("TRB")
End If


BeginSql Alias "TRB"
%noparser%
Select * From %Table:PA1% PA1
Where PA1_OS = %Exp:PA0->PA0_OS% and PA1_FILIAL = %Exp:xFilial("PA1")%
and PA1.%NotDel%
EndSql

/*
//����������������������������������������������������������Ŀ
//�Carrega o acols com as informa��es do registro posicionado�
//������������������������������������������������������������
*/
Do While !Eof("TRB")
	AADD(aCols,Array(Len(aHeader)+1))
	For nCntFor:=1 To Len(aHeader)
		If ( aHeader[nCntFor,10] <>  "V" )
			aCOLS[Len(aCols)][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor,2]))
		Else
			aCOLS[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor,2])
		EndIf
	Next nCntFor
	aCols[Len(aCols)][Len(aHeader)+1] := .F.
	DbSkip()
End Do

//�����������������������������Ŀ
//� Posiciona os objetos na tela
//�������������������������������

aSize := MsAdvSize()
aObjects := {}
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 015, .t., .f. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,;
{{003,033,160,200,240,263}} )

DEFINE MSDIALOG oDlg TITLE "Rejeita Solicita��o de Atendimento" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

EnChoice( "PA0", ,2, , , , , aPosObj[1],,3,,,)

oGetd:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],2    ,         ,        ,"",.T.     ,      ,       ,      , 10 ,        ,         ,,      ,    )
//  METHOD          New(nT          ,nL          ,          nB,         nR ,nOpc ,cLinhaOk ,cTudoOk ,cIniCpos ,lDeleta ,aAlter,nFreeze,lEmpty,nMax,cFieldOk,cSuperDel,,cDelOk,oWnd)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||_nOpcA:=1,oDlg:End()},{||oDlg:End()},,)

If _nOpcA == 1
	
	/*
	//������������������������������������Ŀ
	//�Deleta cabe�alho de tabela de pre�os�
	//��������������������������������������
	*/
	DbSelectArea("PA0")
	DbSetOrder(1)
	DbSeek(xFilial("PA0")+M->PA0_OS)
	If Found()
		RecLock("PA0",.F.)
		PA0->PA0_SITUAC := 'R'
		PA0->PA0_STATUS := 'R'
		MsUnlock()
	End If
	
End If	
Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSF02LEG  �Autor  �Rodrigo Seiti Mitani� Data �  20/10/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �Esta rotina monta uma dialog com a descricao das cores da   ���
���          �Mbrowse.                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CertiSign                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CSF02LEG()            
	BrwLegenda("Solicita��o de Atendimento","Liberado/Rejeitado",;
	{	{"DISABLE","Aberto/Bloqueado"},;      
		{"BR_MARROM","Fechado/Bloqueado"}})   
Return(.T.)

                                    

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSF02REP  �Autor  �Douglas Mello		� Data �  17/12/2009  ���
�������������������������������������������������������������������������͹��
���Desc.     �Esta rotina monta a tela somente com os campos para 		  ���
���          �controlar a entrada e saida do Cliente. 					  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CertiSign                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CSF02REP()

Private aTela[0][0]
Private aGets[0]
Private aHeader	:= {}
Private aCols	:= {}
Private nUsado	:= 0
_nOpca := 0


dbSelectArea("PA0")
dbSetOrder(1)
//���������������������������������������������������������������������������Ŀ
//� Inicializa desta forma para criar uma nova instancia de variaveis private �
//�����������������������������������������������������������������������������
RegToMemory( "PA0", .F., .F. )

//��������������������Ŀ
//� Inicializa aCols   �
//����������������������

dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("PA1")
While ( !Eof() .And. (SX3->X3_ARQUIVO == "PA1") )
	If X3USO(SX3->X3_USADO)
		nUsado++
		Aadd(aHeader,{ TRIM(X3Titulo()),;
		SX3->X3_CAMPO,;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID,;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT } )
	EndIf
	dbSelectArea("SX3")
	dbSkip()
EndDo

If Select("TRB") > 0
	DbSelectArea("TRB")
	DbCloseArea("TRB")
End If


BeginSql Alias "TRB"
%noparser%
Select * From %Table:PA1% PA1
Where PA1_OS = %Exp:PA0->PA0_OS% and PA1_FILIAL = %Exp:xFilial("PA1")%
and PA1.%NotDel%
EndSql

/*
//����������������������������������������������������������Ŀ
//�Carrega o acols com as informa��es do registro posicionado�
//������������������������������������������������������������
*/
Do While !Eof("TRB")
	AADD(aCols,Array(Len(aHeader)+1))
	For nCntFor:=1 To Len(aHeader)
		If ( aHeader[nCntFor,10] <>  "V" )
			aCOLS[Len(aCols)][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor,2]))
		Else
			aCOLS[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor,2])
		EndIf
	Next nCntFor
	aCols[Len(aCols)][Len(aHeader)+1] := .F.
	DbSkip()
End Do

//�����������������������������Ŀ
//� Posiciona os objetos na tela
//�������������������������������

aSize := MsAdvSize()
aObjects := {}
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 015, .t., .f. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,;
{{003,033,160,200,240,263}} )

DEFINE MSDIALOG oDlg TITLE "Libera Solicita��o de Atendimento" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

EnChoice( "PA0", ,2, , , , , aPosObj[1],,3,,,)

oGetd:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],2    ,         ,        ,"",.T.     ,      ,       ,      , 10 ,        ,         ,,      ,    )
//  METHOD          New(nT          ,nL          ,          nB,         nR ,nOpc ,cLinhaOk ,cTudoOk ,cIniCpos ,lDeleta ,aAlter,nFreeze,lEmpty,nMax,cFieldOk,cSuperDel,,cDelOk,oWnd)

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||_nOpcA:=1,oDlg:End()},{||oDlg:End()},,)


If _nOpcA == 1
	
	/*
	//����������������������������������������������Ŀ
	//�Grava libera��o da solicita��o de antendimento�
	//������������������������������������������������
	*/
	DbSelectArea("PA0")
	DbSetOrder(1)
	DbSeek(xFilial("PA0")+M->PA0_OS)
	If Found()
		//RecLock("PA0",.F.)
		//PA0->PA0_SITUAC := 'L'
		//MsUnlock()
	End If
End If	
      


Return