#Include "Protheus.Ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFAT001   �Autor  �Paulo Sampaio		 � Data � 08/12/2007  ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para registrar os Itens que serao devolvidos da NF.  ���
���          �                                                            ���
���          �Tabelas:												      ���
���          � PA0 - Devolucao Intes NF.							      ���
�������������������������������������������������������������������������͹��
���Uso       � SERCON MP8.11.											  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CFAT001()

Local aArea			:= GetArea()
Local oDlg			:= Nil
Local oGetSD2		:= Nil
Local oGetSE1		:= Nil
Local oFolder		:= Nil
Local aPages		:= {"HEADER"}
Local aTitles		:= {"Itens Nota","Contas a Receber"}
Local nOpc			:= 2
Local aObjects  	:= {}                        
Local aInfo 		:= {}	
Local aSize     	:= MsAdvSize( .F. )
Local aPosObj   	:= {} 
Local aPosGet 		:= {} 
Local aSD2Header	:= {}
Local aSD2Cols      := {}
Local aSE1Header	:= {}
Local aSE1Cols      := {}
Local nTamAux 		:= 0
Local bViewEnt 		:= { |x| IIf( oFolder:nOption == 1 , fViewEnt("SD2",oGetSD2) , fViewEnt("SE1",oGetSE1) ) }
Local cSavCad		:= IIf( Type("cCadastro")	== "C" 	, cCadastro , "" )	
Local aSavAhead		:= IIf(	Type("aHeader")		== "A"	, aClone(aHeader) , {} )
Local aSavAcol 		:= IIf(	Type("aCols")		== "A"	, aClone(aCols) ,{} )
Local nSavN    		:= IIf(	Type("n") 			== "N"	, n , 0 )
Local lOldInc		:= IIf(	Type("INCLUI")		== "L"	, INCLUI , .F. )
Local lOldAlt		:= IIf(	Type("ALTERA")		== "L"	, ALTERA , .F. )

//�������������������������������������������������������������������������������Ŀ
//�Chama a Funcao que define cor na Leganda para ver se o Pedido possui Devolucao.�
//���������������������������������������������������������������������������������
If	!U_ACORDFDE()
	MsgInfo("Esse pedido n�o possui devolu��o.","Devolu��o")
	Return()
EndIf

//���������������������������������������������������������Ŀ
//�Montagem do aHeader e aCols dos Acessorios da Ficha.		�
//�����������������������������������������������������������
fIntGet("SD2",@aSD2Header,@aSD2Cols,"D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA"  ,xFilial("SD2")+SC5->(C5_NOTA+C5_SERIE+C5_CLIENTE+C5_LOJACLI),3,nOpc==3,"","","")
fIntGet("SE1",@aSE1Header,@aSE1Cols,"E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM",xFilial("SE1")+SC5->(C5_CLIENTE+C5_LOJACLI+C5_SERIE+C5_NOTA),2,nOpc==3,"","","")

//������������������������������������������������������Ŀ
//� Faz o calculo automatico de dimensoes de objetos     �
//��������������������������������������������������������
AAdd( aObjects, { 100, 100, .T., .T. } )
AAdd( aObjects, { 100, 020, .T., .F. } )

aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 0, 0 }
aPosObj := MsObjSize( aInfo, aObjects )

aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,263}} )

DEFINE MSDIALOG oDlg TITLE cCadastro FROM 000,000 To aSize[6],aSize[5] OF oMainWnd PIXEL

@aPosObj[1,1],aPosObj[1,2] To aPosObj[1,3],aPosObj[1,4] LABEL "Dados do Cliente" OF oDlg PIXEL         

oFolder := TFolder():New(aPosObj[1,1],aPosObj[1,2],aTitles,aPages,oDlg,,,, .T., .F.,aPosObj[1,4]-aPosObj[1,2],aPosObj[1,3]-aPosObj[1,1],)
                         
//�������������������������Ŀ
//�GetDados com Itens da NF.�
//���������������������������
oGetSD2	:= MsNewGetDados():New(2,2,aPosObj[1,3]-aPosObj[1,1]-15,aPosObj[1,4]-aPosObj[1,2]-5,0,/*linok*/,/*tudok*/,/*cInitCpo*/,/*cCpoAlt*/,/*freeze*/,100,/*fieldok*/,/*superdel*/,/*delok*/,oFolder:aDialogs[1],aSD2Header,aSD2Cols)
oGetSD2:oBrowse:bLDblClick := { || Eval(bViewEnt) }

//�������������������������������Ŀ
//�GetDados com Titulos a Receber.�
//���������������������������������
oGetSE1	:= MsNewGetDados():New(2,2,aPosObj[1,3]-aPosObj[1,1]-15,aPosObj[1,4]-aPosObj[1,2]-5,0,/*linok*/,/*tudok*/,/*cInitCpo*/,/*cCpoAlt*/,/*freeze*/,100,/*fieldok*/,/*superdel*/,/*delok*/,oFolder:aDialogs[2],aSE1Header,aSE1Cols)
oGetSE1:oBrowse:bLDblClick := { || Eval(bViewEnt) }

//��������������������Ŀ
//�Label com os Botoes.�
//����������������������
@aPosObj[2][1],aPosObj[2][2] To aPosObj[2][3],aPosObj[2][4] LABEL "" OF oDlg PIXEL

//�������Ŀ
//�Botoes.�
//���������
nTamAux := 50
@aPosObj[2][1]+04 ,aPosObj[2][4] - nTamAux BUTTON "Sair"			SIZE 40,12 OF oDlg PIXEL ACTION oDlg:End() ; nTamAux += 50
@aPosObj[2][1]+04 ,aPosObj[2][4] - nTamAux BUTTON "Exp. Excel"		SIZE 40,12 OF oDlg PIXEL ACTION DlgToExcel({{"GETDADOS","Itens da Nota",oGetSD2:aHeader,oGetSD2:aCols} , {"GETDADOS","Contas a Receber",oGetSE1:aHeader,oGetSE1:aCols}}) ; nTamAux += 50
@aPosObj[2][1]+04 ,aPosObj[2][4] - nTamAux BUTTON "Visualizar"		SIZE 40,12 OF oDlg PIXEL ACTION Eval(bViewEnt) ;nTamAux += 50

oDlg:lMaximized := .T.

ACTIVATE MSDIALOG oDlg CENTERED
     
//������������������������������������������������������������������������Ŀ
//�Restaura a Integridade dos Dados                                        �
//��������������������������������������������������������������������������
aHeader 	:= aClone(aSavAHead)
aCols   	:= aClone(aSavACol)
n       	:= nSavN
cCadastro	:= cSavCad
INCLUI		:= lOldInc
ALTERA		:= lOldAlt

RestArea(aArea)

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �fIntGet   �Autor  �Paulo Sampaio       � Data � 08/12/2007  ���
�������������������������������������������������������������������������͹��
���Desc.     �Monta o aHeader e aCols.                                    ���
�������������������������������������������������������������������������͹��
���          �cAliasH    : Alias da tabela trabalhada.                    ���
���          �aHeaderAux : Cabecalho do Get.                              ���
���          �aColsAux   : Colunas do Get.                                ���
���          �cCamChave  : Campos Chaves da tabela. Deve ser Concatenado. ���
���          �cChave     : Chave que deve ser comparada a cCamChave.      ���
���          �lInclui    : Indica se e uma inclusao ou nao.               ���
���          �cCpoIncre  : Campo que deve ser auto incrementado.          ���
���          �cOculta    : Campos que nao devem aparecer no cabecalho.    ���
�������������������������������������������������������������������������͹��
���Uso       � SERCON MP8.11.											  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function fIntGet(cAliasAux,aHeaderAux,aColsAux,cCamChave,cChave,nOrderSix,lInclui,cCpoIncre,cOculta,cCpoCols)
           
Local	nUsado 		:= 0
Local 	nX			:= 0

//�������������������������������������������������������Ŀ
//� Monta o aHeader.                                      �
//���������������������������������������������������������

aHeaderAux := {}
aColsAux   := {}

DBSelectArea("SX3")
SX3->(DBSetOrder(1))
SX3->(DBSeek(cAliasAux,.T.))

While (  SX3->(!Eof()) .And. SX3->X3_ARQUIVO == cAliasAux )
	
	If 	X3USO(SX3->X3_USADO) 		.And. ;
		cNivel >= SX3->X3_NIVEL		//.And. ;
		//SX3->X3_BROWSE == "S"		
		
		 aAdd(aHeaderAux,{ 	AllTrim(X3Titulo()),;
							SX3->X3_CAMPO,;
							SX3->X3_PICTURE,;
							SX3->X3_TAMANHO,;
							SX3->X3_DECIMAL,;
							SX3->X3_VALID,;
							SX3->X3_USADO,;
							SX3->X3_TIPO,;
							SX3->X3_F3,;
							SX3->X3_CONTEXT } )
	EndIf              
	
SX3->(DBSkip())
EndDo

aAdd(aHeaderAux,{"Registro","XX_RECNO","",12,2,,,"N",,"V"})

//�������������������������������������������������������Ŀ
//� Monta o aCols.                                        �
//���������������������������������������������������������

nUsado := Len(aHeaderAux)

If !lInclui // Visualizacao, edicao ou exclusao.
   
   aColsAux := {}
      
   DBSelectArea(cAliasAux)
   DBSetOrder(nOrderSix)
   DBSeek(cChave)

   While !Eof() .And. &cCamChave==cChave

   	    aADD(aColsAux, Array(nUsado+1))
   	    
   	    For nX := 1 To nUsado
			If 		AllTrim(aHeaderAux[nX,2]) == "XX_RECNO"
					aColsAux[Len(aColsAux)][nX] := Recno()
   	    	ElseIf (aHeaderAux[nX,10] != "V")
   	    			aColsAux[Len(aColsAux)][nX] := FieldGet(FieldPos(aHeaderAux[nX,2]))
   	    	Else
   	    			aColsAux[Len(aColsAux)][nX] := CriaVar(aHeaderAux[nX,2],.T.)
   	    	EndIf
   	    Next

   	    aColsAux[Len(aColsAux)][nUsado+1] := .F.

	DBSelectArea(cAliasAux)
 	DBSkip()
   	EndDo
EndIf

If 	Empty(aColsAux)

   	aAdd(aColsAux, Array(nUsado+1))
    	
	For nX := 1 To nUsado
		If AllTrim(aHeaderAux[nX,2]) == cCpoIncre
		    aColsAux[Len(aColsAux)][nX]:= StrZero(1,aHeaderAux[nX,4])
		Else
			aColsAux[Len(aColsAux)][nX]:= CriaVar(aHeaderAux[nX,2],.T.)
		EndIf
	Next nX
	aColsAux[Len(aColsAux)][nUsado+1] := .F.  // Campo D_E_L_E_T_
	
EndIf

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �fViewEnt  �Autor  �Paulo Sampaio       � Data � 08/12/2007  ���
�������������������������������������������������������������������������͹��
���Desc.     �Chama a rotina de visualizacao da Entidade passada como	  ���
���          �parametro.					                              ���
���          �Para funcionar o aHeader do obsejo precisa ter um campo	  ���
���          �XX_RECNO armazenando o Recno da Entidade.                   ���
�������������������������������������������������������������������������͹��
���Uso       � SERCON MP8.11.											  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fViewEnt( cAliasEnt , oGetEnt )

Local nRegEnt	:= oGetEnt:aCols[oGetEnt:oBrowse:nAt][ aScan( oGetEnt:aHeader, { |x| AllTrim(x[02]) == "XX_RECNO" } ) ]
Local aArea		:= GetArea()

DBSelectArea(cAliasEnt)
MsGoTo(nRegEnt)
AxVisual(cAliasEnt,nRegEnt,2)

RestArea(aArea)

Return()
