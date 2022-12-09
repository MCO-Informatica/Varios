#Include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �CCDFUNC1  � Autor �Henio Brasil Claudino  � Data � 20/03/07 ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao �Chamada das funcoes de Interface de Clientes e Interface    ���
���          �de Pedidos de Vendas                                        ���
�������������������������������������������������������������������������Ĵ��
���Uso       �CertiSign Certificadora Digital S/A                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �CHOSFILE  � Autor �Henio Brasil Claudino  � Data � 20/03/07 ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao �Interface para selecao de multiplos arquivos.               ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �CertiSign Certificadora Digital S/A                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Chosfile(aSource,aTarget)				// Antigo Ecoma06() 

Local nSource  := 0
Local nTarget  := 0
Local nNewTam  := 0

Local oSel
Local oSource
Local oTarget

// ConOut(" TESTE - Pergunta se esta no JOB ou nao. ")
/*
�������������������������������������������������������Ŀ
�Chamada do Job para a funcao Processa()                �
���������������������������������������������������������*/
Private _lJob := (U_CallFunc("U_CALLJOB1"))
If _lJob    

	// ConOut(" TESTE - Aqui transfere os arquivos automatico  "+str(nSource,2)+"  "+str(nTarget,2) )
	
	Add(@aSource,@nSource,oSource,@aTarget,@nTarget,oTarget,@nNewTam)
	If nSource != 0
	   aadd(aTarget,aSource[nSource])
	   oTarget:SetItems(aTarget)
	   nNewTam := Len(aSource) - 1
	   aSource := aSize(aDel(aSource,nSource),nNewTam)
	   oSource:SetItems(aSource)
	   oSource:SetFocus()
	   oSource:GoTop()
	Endif

  Else 
	/*
	���������������������������������������������������������������������Ŀ
	� Criacao do dialogo principal                                        �
	�����������������������������������������������������������������������*/
	@ 065,000 To 365,480 Dialog oSel Title OemToAnsi("Selecao de arquivos para importacao")
	@ 017,008 ListBox nSource Items aSource Size 80,120 Object oSource
	@ 017,146 ListBox nTarget Items aTarget Size 80,120 Object oTarget
	@ 046,097 Button OemToAnsi("_Adicionar>>") Size 36,16 ;
	  Action Add(@aSource,@nSource,oSource,@aTarget,@nTarget,oTarget,@nNewTam)
	@ 076,097 Button OemToAnsi("<<_Remover")   Size 36,16 ;
	  Action Remove(@aSource,@nSource,oSource,@aTarget,@nTarget,oTarget,@nNewTam)
	@ 106,097 Button OemToAnsi("Ok")           Size 36,16 Action Close(oSel)
	Activate Dialog oSel Centered
Endif 	

Return(.t.)                          


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �ADD       � Autor �Henio Brasil Claudino  � Data � 20/03/07 ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao �Adiciona o novo arquivo na selecao                          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �CertiSign Certificadora Digital S/A                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Add(aSource,nSource,oSource,aTarget,nTarget,oTarget,nNewTam)
	
If nSource != 0
   aadd(aTarget,aSource[nSource])
   oTarget:SetItems(aTarget)
   nNewTam := Len(aSource) - 1
   aSource := aSize(aDel(aSource,nSource),nNewTam)
   oSource:SetItems(aSource)
   oSource:SetFocus()
   oSource:GoTop()
Endif
Return     


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �REMOVE    � Autor �Henio Brasil Claudino  � Data � 20/03/07 ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao �Remove o arquivo selecionado pela funcao ADD                ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �CertiSign Certificadora Digital S/A                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Remove(aSource,nSource,oSource,aTarget,nTarget,oTarget,nNewTam)
If nTarget != 0
	aAdd(aSource,aTarget[nTarget])
	oSource:SetItems(aSource)
	nNewTam := Len(aTarget) - 1
	aTarget := aSize(aDel(aTarget,nTarget), nNewTam)
	oTarget:SetItems(aTarget)
	oTarget:SetFocus()
	oTarget:GoTop()
Endif
Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �ADDJOB    � Autor �Henio Brasil Claudino  � Data � 20/03/07 ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao �Adiciona todos os arquivos origem como destino para inicio  ���
���          �do processamento.                                           ���
�������������������������������������������������������������������������Ĵ��
���Uso       �CertiSign Certificadora Digital S/A                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������

Static Function AddJob(aSource,nSource,oSource,aTarget,nTarget,oTarget,nNewTam)

Local nSource  := 0
Local nTarget  := 0
Local nNewTam  := 0

Local oSel
Local oSource
Local oTarget
	
If nSource != 0
   aadd(aTarget,aSource[nSource])
   oTarget:SetItems(aTarget)
   nNewTam := Len(aSource) - 1
   aSource := aSize(aDel(aSource,nSource),nNewTam)
   oSource:SetItems(aSource)
   oSource:SetFocus()
   oSource:GoTop()
Endif
Return     					*/ 


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �CGC       � Autor �Henio Brasil Claudino  � Data � 20/03/07 ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao �Valida conteudo do CGC informado como variavel              ���
���          �                                                            ���
���          �Cgc(ExpC1,ExpC2)                                            ���
���          �Onde: ExpC1 - Numero do Cgc                                 ���
���          �  	ExpC2 - Variavel de memoria a ser retornada           ���
�������������������������������������������������������������������������Ĵ��
���Uso       �CertiSign Certificadora Digital S/A                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CgcEsp(cCGC, cVar)

Local nCnt,i,j,cDVC,nSum,nDIG,cDIG:="",cSavAlias,nSavRec,nSavOrd
cCGC  := iif(cCgc  == Nil,&(ReadVar()),cCGC)
cVar  := iif(ValType(cVar) = "U", ReadVar(), cVar)
If cCgc == "00000000000000"
   Return .t.
Endif

nTamanho:=Len(AllTrim(cCGC))
cDVC	:=SubStr(cCGC,13,2)
cCGC	:=SubStr(cCGC,1,12)

For j := 12 to 13
	nCnt := 1
	nSum := 0
	For i := j to 1 Step -1
		nCnt++
		If nCnt>9;nCnt:=2;EndIf
		nSum += (Val(SubStr(cCGC,i,1))*nCnt)
	Next i
	nDIG := iif((nSum%11)<2,0,11-(nSum%11))
	cCGC := cCGC+STR(nDIG,1)
	cDIG := cDIG+STR(nDIG,1)
Next j
lRet:=iif(cDIG==cDVC,.T.,.F.)

If !lRet
	If nTamanho < 14
		cDVC:=SubStr(cCGC,10,2)
		cCPF:=SubStr(cCGC,1,9)
		cDIG:=""

		For j := 10 to 11
			nCnt := j
			nSum := 0
			For i:= 1 To Len(Trim(cCPF))
				nSum += (Val(SubStr(cCPF,i,1))*nCnt)
				nCnt--
			Next i
			nDIG:=iif((nSum%11)<2,0,11-(nSum%11))
			cCPF:=cCPF+STR(nDIG,1)
			cDIG:=cDIG+STR(nDIG,1)
		Next j

		/*
		If cDIG != cDVC
			Help(" ",1,"CGC")
		Endif		*/

		lRet:=iif(cDIG==cDVC,.T.,.F.)
		If lRet;&cVar:=cCPF+Space(3);EndIF
	// Else
	   //	Help(" ",1,"CGC")
	EndIf
EndIf
Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�ao    �MAKETXT   � Autor �Henio Brasil Claudino  � Data � 20/03/07 ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao �Gera arquivo Txt de Log p/ depuracao de Erros na interface  ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �CertiSign Certificadora Digital S/A                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
User Function MakeTxt(aSource,nSource,oSource,aTarget,nTarget,oTarget,nNewTam)
User Function MakeTxt(cOrigName,cTexto,lStatus)			...caso fosse preciso criar e fechar o arquivo
*/ 

User Function MakeTxt(nHld,cOrgName,cTexto)

// Local cArqTxt := ''
// Local nArqSai := cOrigName 
Local cLinha1 := ''
Local cLinha2 := Replicate("=", 90) 

cLinha1 += cTexto 
FWrite(nHld, cLinha1+Chr(13)+Chr(10))  
Return 

// cLinha1 += cLinha2
// FWrite(nHld, cLinha1+Chr(13)+Chr(10))        

/* Abertura do Arquivo Log 
Local lStatus := iif(Type("lStatus")="U", 2, lStatus) 
If lStatus == 1 
   cArqTxt 	:= 'PV'+cOrigName+Dtos(dDataBase)+'.log'
   nArqSai 	:= FCreate(cArqTxt,0)
   cLinha1 	:= 'Arquivo de Log ==> PV'+cOrigName+'  Gerado em  '+Dtoc(dDataBase)+'  As '+Str(Time()) 
   FWrite(nArqSai,cLinha1+Chr(10)+Chr(13))
   FWrite(nArqSai,cLinha2+Chr(10)+Chr(13))        
Endif                      	
// Fechamento Arquivo Log          
If lStatus == 2          
   FClose(nArqSai)		   
Endif 
FWrite(nHld,nArqSai,cLinha1+Chr(10)+Chr(13))                              */ 
