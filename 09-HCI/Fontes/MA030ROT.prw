#INCLUDE "PROTHEUS.CH"
#INCLUDE "JPEG.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA030ROT  �Autor  �ROGERIO NAGY        � Data �  07/20/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada no cadastro de clientes.                   ���
���          �Inclui Botoes Socios e Documentos no menu da rotina         ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MA030ROT()             

Return({{"Socios"		,"U_MA030RO1()" , 0 , 3},;
		{"Documentos"	,"U_MA030RO2()" , 0 , 3}})


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA030RO1  �Autor  �ROGERIO NAGY        � Data �  07/20/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina de Manutencao de Socios                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MA030RO1()

Local lConfirma := .f.

Private _oDlg				
Private INCLUI := .F.	
Private oGet1

DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Cadastro de S�cios do Cliente") FROM C(178),C(181) TO C(645),C(763) PIXEL

@ C(014),C(005) Say "Cliente.: " + SA1->A1_COD + "/" + SA1->A1_LOJA + " - " + SA1->A1_NOME Size C(284),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
GetSocios()

ACTIVATE MSDIALOG _oDlg CENTERED  ON INIT EnchoiceBar(_oDlg, {|| If(oGet1:TudoOk(), (lConfirma := .t.,_oDlg:End()), nil) },{||_oDlg:End()},,)
                                                                                 
If lConfirma
	SZ2->(DbSetOrder(1))

	For n:= 1 to Len(oGet1:aCols)
		                      
		// Linha Deletada
        If oGet1:aCols[n][5] 
	        If SZ2->(DbSeek(xFilial("SZ2")+SA1->A1_COD + SA1->A1_LOJA + oGet1:aCols[n][2]))
	        	RecLock("SZ2",.F.)
		       	SZ2->(DbDelete())
				SZ2->(MsUnlock())
	        EndIf
		// Linha Normal
		Else
	        If !SZ2->(DbSeek(xFilial("SZ2")+SA1->A1_COD + SA1->A1_LOJA + oGet1:aCols[n][2]))
				RecLock("SZ2",.T.)
	        Else
	        	RecLock("SZ2",.F.)
	        EndIf
        
			SZ2->Z2_FILIAL	:= xFilial("SZ4")
			SZ2->Z2_XCLIENT := SA1->A1_COD   
			SZ2->Z2_XLOJA	:= SA1->A1_LOJA
			SZ2->Z2_XTIPO   := oGet1:aCols[n][1]       // TIPO
			SZ2->Z2_XCPF   	:= oGet1:aCols[n][2]		// CPF
			SZ2->Z2_XPORCEN	:= oGet1:aCols[n][4]		// Participacao
			SZ2->(MsUnlock())
		Endif
	Next
Endif

Return(.T.)

/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   �GetSocios() � Autor � Rogerio Nagy          � Data �19/07/2006���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Montagem da GetDados - Socios                                ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
Static Function GetSocios()
                                                                                                        
Local nX			:= 0                                                                                                              
Local aCpoGDa       	:= {"Z2_XTIPO","Z2_XCPF","Z2_XNOME","Z2_XPORCEN"}                                                                                                 
Local aAlter       	:= {"Z2_XTIPO","Z2_XCPF","Z2_XNOME","Z2_XPORCEN"}
Local nSuperior    	:= C(022)           
Local nEsquerda    	:= C(004)           
Local nInferior    	:= C(229)           
Local nDireita     	:= C(290)           

// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia  
Local nOpc         	:= GD_INSERT+GD_DELETE+GD_UPDATE                                                                            
Local cLinhaOk     	:= "AllwaysTrue"    // Funcao executada para validar o contexto da linha atual do aCols                  
Local cTudoOk      	:= "{ || U_TudoSoc() }"  // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)      
Local cIniCpos     	:= ""               // Nome dos campos do tipo caracter que utilizarao incremento automatico.            
                                         // Este parametro deve ser no formato "+<nome do primeiro campo>+<nome do            
                                         // segundo campo>+..."                                                               
Local nFreeze      	:= 000              // Campos estaticos na GetDados.                                                               
Local nMax         	:= 99               // Numero maximo de linhas permitidas. Valor padrao 99                           
Local cCampoOk     	:= "AllwaysTrue"    // Funcao executada na validacao do campo                                           
Local cSuperApagar 	:= ""               // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>                    
Local cApagaOk     	:= "AllwaysTrue"    // Funcao executada para validar a exclusao de uma linha do aCols                   
                                   
Local oWnd         	:= _oDlg                                                                                                  
Local aHead        	:= {}               // Array a ser tratado internamente na MsNewGetDados como aHeader                    
Local aCol         	:= {}               // Array a ser tratado internamente na MsNewGetDados como aCols                      
                                                                                                                                
// Carrega aHead                                                                                                                
DbSelectArea("SX3")                                                                                                             
SX3->(DbSetOrder(2)) // Campo                                                                                                   
For nX := 1 to Len(aCpoGDa)                                                                                                     
	If SX3->(DbSeek(aCpoGDa[nX]))                                                                                                 
		Aadd(aHead,{ AllTrim(X3Titulo()),;                                                                                         
			SX3->X3_CAMPO	,;                                                                                                       
			SX3->X3_PICTURE,;                                                                                                       
			SX3->X3_TAMANHO,;                                                                                                       
			SX3->X3_DECIMAL,;                                                                                                       
			SX3->X3_VALID	,;                                                                                                       
			SX3->X3_USADO	,;                                                                                                       
			SX3->X3_TIPO	,;                                                                                                       
			SX3->X3_F3 		,;                                                                                                       
			SX3->X3_CONTEXT,;                                                                                                       
			SX3->X3_CBOX	,;                                                                                                       
			SX3->X3_RELACAO})                                                                                                       
	Endif                                                                                                                         
Next nX                                                                                                                         

// Montagem da aCol                                                                                         
If SZ2->(DbSeek(xFilial("SZ2")+SA1->A1_COD + SA1->A1_LOJA))
	While xFilial("SZ2") == SZ2->Z2_FILIAL .and. ! SZ2->(Eof()) .and. ; 
		SZ2->Z2_XCLIENT == SA1->A1_COD .AND. ;
		SZ2->Z2_XLOJA   == SA1->A1_LOJA    
		aAdd(aCol,{SZ2->Z2_XTIPO,SZ2->Z2_XCPF, Posicione("SZ1",1,xFilial("SZ1")+SZ2->Z2_XCPF,"Z1_XNOME"),SZ2->Z2_XPORCEN,.F.})
		SZ2->(DbSkip())
	EndDo
Else
	aAux := {}                                                                                                                      
	For nX := 1 to Len(aCpoGDa)                                                                                                     
		If DbSeek(aCpoGDa[nX])                                                                                                        
			Aadd(aAux,CriaVar(SX3->X3_CAMPO))                                                                                          
		Endif                                                                                                                         
	Next nX                                                                                                                         
	Aadd(aAux,.F.)                                                                                                                  
	Aadd(aCol,aAux)                                                                                                                 
Endif                        

oGet1 := MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,nOpc,cLinhaOk,{|| U_TudoSoc()},cIniCpos,;                               
                             aAlter,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oWnd,aHead,aCol)                                   
Return Nil                                                                                                                      



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TudoSoc   �Autor  �Rogerio Nagy        � Data �  08/02/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �TudoOk de Socios                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TudoSoc()

Local nConta 	:= 1
Local nConta1	:= 1
Local nTotal 	:= 0
Local cTexto 	:= ""
Local nRegSA1 	:= SA1->(Recno())
Local cCliente 	:= SA1->(A1_COD + A1_LOJA)
    
   
//�����������������������������������������������������Ŀ                                               
//�Varre acols verificando se CPF estao duplicados      �                                               
//�������������������������������������������������������                                               
For nConta := 1 To Len(oGet1:aCols)
	For nConta1 := 1 To Len(oGet1:aCols)
		If nConta <> nConta1
			 If oGet1:aCols[nConta,2] == oGet1:aCols[nConta1,2]
			 	MsgInfo("CPF/CNPJ " + oGet1:aCols[nConta,2] + " duplicado. Verifique")
			 	Return .f.
			Endif
		Endif
	Next nConta1
Next nConta

//�����������������������������������������������������Ŀ                                               
//�Varre acols verificando % de Participacao dos socios �                                               
//�������������������������������������������������������                                               
For nConta := 1 To Len(oGet1:aCols)
	If ! oGet1:aCols[nConta][Len(aHeader)+1]
		nTotal += oGet1:aCols[nConta,4]
	Endif
Next nConta

If nTotal <> 100
	MsgInfo("Participa��o dos s�cios n�o atingiu 100%. Verifique")
	Return .f.
Endif

//�������������������������������������������������������Ŀ                                               
//�Verifica se socios ja estao presentes em outro cliente �                                               
//���������������������������������������������������������
SZ2->(DbSetOrder(2))	// Z2_FILIAL + Z2_XCPF
For nConta := 1 To Len(oGet1:aCols)
	If ! oGet1:aCols[nConta][Len(aHeader)+1]
		If SZ2->(DbSeek(xFilial("SZ2") + aCols[nConta,2]))
			//�������������������������������������������������������Ŀ                                               
			//� Desconsidera cliente atual                            �                                               
			//���������������������������������������������������������
			cTextoPar := ""
			While ! SZ2->(Eof()) .and. SZ2->Z2_FILIAL == xFilial("SZ2") .and. ;
				SZ2->Z2_XCPF == aCols[nConta,2]
				If SZ2->(Z2_XCLIENT + Z2_XLOJA) <> cCliente
					cTextoPar += DadosCli(SZ2->Z2_XCLIENT + SZ2->Z2_XLOJA)					
				Endif
				SZ2->(DbSkip())
			Enddo
			If ! Empty(cTextoPar)
				cTexto += "CPF/CNPJ " + aCols[nConta,2] + "-" + AllTrim(aCols[nConta,3]) + " tamb�m � s�cio no(s) cliente(s)" + Chr(13) + Chr(10)
				cTexto += cTextoPar + Chr(13) + Chr(10)
			Endif
		Endif
	Endif
Next nConta
                  
If ! Empty(cTexto)
	MsgAlert(cTexto,"S�cio(s) pertence a outro cliente",)                                               
Endif

SA1->(DbGoTo(nRegSA1))

Return .t.
   
      
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DadosCli  �Autor  �Rogerio Nagy        � Data �  08/03/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Monta String com dados do cliente para apresentar ao       ���
���          � usuario                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function DadosCli(cCodigo)

Local cRet := ""

SA1->(DbSetOrder(1))
If SA1->(DbSeek(xFilial("SA1") + cCodigo))
	cRet := "Cliente " + SA1->A1_COD + "/" + SA1->A1_LOJA + "-" + SA1->A1_NOME + " Risco " + SA1->A1_RISCO + Chr(13) + Chr(10)
Endif

Return(cRet)

/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   �   C()      � Autor � Norbert Waage Junior  � Data �10/05/2005���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Funcao responsavel por manter o Layout independente da       ���
���           � resolu��o horizontal do Monitor do Usuario.                  ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
Static Function C(nTam)                                                         
Local nHRes	:=	oMainWnd:nClientWidth	//Resolucao horizontal do monitor      
Do Case                                                                         
	Case nHRes == 640	//Resolucao 640x480                                         
		nTam *= 0.8                                                                
	Case nHRes == 800	//Resolucao 800x600                                         
		nTam *= 1                                                                  
	OtherWise			//Resolucao 1024x768 e acima                                
		nTam *= 1.28                                                               
EndCase                                                                         
If "MP8" $ oApp:cVersion                                                        
  //���������������������������Ŀ                                               
  //�Tratamento para tema "Flat"�                                               
  //�����������������������������                                               
  If (Alltrim(GetTheme()) == "FLAT").Or. SetMdiChild()                          
       	nTam *= 0.90                                                            
  EndIf                                                                         
EndIf                                                                           
Return Int(nTam) 




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA030R02  �Autor  �Rogerio Nagy        � Data �  07/20/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cadastro de Documentos do Cliente                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MA030RO2()

Local lConfirma := .f.

Private _oDlg			
Private INCLUI := .F.	
Private oGet1

DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Cadastro de Documentos") FROM C(178),C(181) TO C(645),C(763) PIXEL

@ C(014),C(005) Say "Cliente.: " + SA1->A1_COD + "/" + SA1->A1_LOJA + " - " + SA1->A1_NOME Size C(284),C(008) COLOR CLR_BLACK PIXEL OF _oDlg

GetDocs()

ACTIVATE MSDIALOG _oDlg CENTERED  ON INIT EnchoiceBar(_oDlg, {|| If(oGet1:TudoOk(), (lConfirma := .t.,_oDlg:End()), nil) },{||_oDlg:End()},,)
                                                                                 
If lConfirma
	
	SZ4->(DbSetOrder(1))
	For n:= 1 to Len(oGet1:aCols)
		           
		// Linha Deletada
        If oGet1:aCols[n][5] 
	        If SZ4->(DbSeek(xFilial("SZ4")+SA1->A1_COD + SA1->A1_LOJA + oGet1:aCols[n][2]))
	        	RecLock("SZ4",.F.)
		       	SZ4->(DbDelete())
				SZ4->(MsUnlock())
	        EndIf
		// Linha Normal
		Else
	        If !SZ4->(DbSeek(xFilial("SZ4")+SA1->A1_COD + SA1->A1_LOJA + oGet1:aCols[n][2]))
				RecLock("SZ4",.T.)
	        Else
	        	RecLock("SZ4",.F.)
	        EndIf
        
			SZ4->Z4_FILIAL	:= xFilial("SZ4")
			SZ4->Z4_XCLIENT	:= SA1->A1_COD   
			SZ4->Z4_XLOJA	:= SA1->A1_LOJA
			SZ4->Z4_XTIPO   := oGet1:aCols[n][1]       // TIPO
			SZ4->Z4_XCODIGO	:= oGet1:aCols[n][2]		// Codigo Documento
			SZ4->Z4_XVALIDA	:= oGet1:aCols[n][4]		// Validade
			SZ4->(MsUnlock())
		Endif
	Next
Endif

Return(.T.)

/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   �GetDocs()   � Autor � Rogerio Nagy          � Data �19/07/2006���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Montagem da GetDados - Documentos                            ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
Static Function GetDocs()
Local nX			:= 0                                                                                                              
Local aCpoGDa      	:= {"Z4_XTIPO","Z4_XCODIGO","Z4_XNOME","Z4_XVALIDA"}                                                                                                 
Local aAlter       	:= {"Z4_XTIPO","Z4_XCODIGO","Z4_XNOME","Z4_XVALIDA"}
Local nSuperior    	:= C(022)           
Local nEsquerda    	:= C(004)           
Local nInferior    	:= C(229)           
Local nDireita     	:= C(290)           

// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia  
Local nOpc         	:= GD_INSERT+GD_DELETE+GD_UPDATE                                                                            
Local cLinhaOk     	:= "AllwaysTrue"    // Funcao executada para validar o contexto da linha atual do aCols                  
Local cTudoOk      	:= "U_TudoDoc()"    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)      
Local cIniCpos     	:= ""               // Nome dos campos do tipo caracter que utilizarao incremento automatico.            
                                         // Este parametro deve ser no formato "+<nome do primeiro campo>+<nome do            
                                         // segundo campo>+..."                                                               
Local nFreeze      	:= 000              // Campos estaticos na GetDados.                                                               
Local nMax         	:= 99               // Numero maximo de linhas permitidas. Valor padrao 99                           
Local cCampoOk     	:= "AllwaysTrue"    // Funcao executada na validacao do campo                                           
Local cSuperApagar 	:= ""               // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>                    
Local cApagaOk     	:= "AllwaysTrue"    // Funcao executada para validar a exclusao de uma linha do aCols                   

Local oWnd         	:= _oDlg                                                                                                  
Local aHead        	:= {}               // Array a ser tratado internamente na MsNewGetDados como aHeader                    
Local aCol         	:= {}               // Array a ser tratado internamente na MsNewGetDados como aCols                      
                                                                                                                                
// Carrega aHead                                                                                                                
DbSelectArea("SX3")                                                                                                             
SX3->(DbSetOrder(2)) // Campo                                                                                                   
For nX := 1 to Len(aCpoGDa)                                                                                                     
	If SX3->(DbSeek(aCpoGDa[nX]))                                                                                                 
		Aadd(aHead,{ AllTrim(X3Titulo()),;                                                                                         
			SX3->X3_CAMPO	,;                                                                                                       
			SX3->X3_PICTURE,;                                                                                                       
			SX3->X3_TAMANHO,;                                                                                                       
			SX3->X3_DECIMAL,;                                                                                                       
			SX3->X3_VALID	,;                                                                                                       
			SX3->X3_USADO	,;                                                                                                       
			SX3->X3_TIPO	,;                                                                                                       
			SX3->X3_F3 		,;                                                                                                       
			SX3->X3_CONTEXT,;                                                                                                       
			SX3->X3_CBOX	,;                                                                                                       
			SX3->X3_RELACAO})                                                                                                       
	Endif                                                                                                                         
Next nX                                                                                                                         

// Carrega aCol                                                                                         
If SZ4->(DbSeek(xFilial("SZ4")+SA1->A1_COD + SA1->A1_LOJA))
	While xFilial("SZ4") == SZ4->Z4_FILIAL .and. ! SZ4->(Eof()) .and. ; 
		SZ4->Z4_XCLIENT == SA1->A1_COD .AND. ;
		SZ4->Z4_XLOJA   == SA1->A1_LOJA    
		aAdd(aCol,{SZ4->Z4_XTIPO, SZ4->Z4_XCODIGO, Posicione("SZ3",1,xFilial("SZ3")+SZ4->Z4_XCODIGO,"Z3_XNOME"),SZ4->Z4_XVALIDA,.F.})
		SZ4->(DbSkip())
	EndDo
Else
	aAux := {}                                                                                                                      
	For nX := 1 to Len(aCpoGDa)                                                                                                     
		If DbSeek(aCpoGDa[nX])                                                                                                        
			Aadd(aAux,CriaVar(SX3->X3_CAMPO))                                                                                          
		Endif                                                                                                                         
	Next nX                                                                                                                         
	Aadd(aAux,.F.)                                                                                                                  
	Aadd(aCol,aAux)                                                                                                                 
Endif

oGet1 := MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,nOpc,cLinhaOk,{|| U_TudoDoc()},cIniCpos,;                               
                             aAlter,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oWnd,aHead,aCol)                                   
Return Nil                                                                                                                      
     
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TudoDoc   �Autor  �Rogerio Nagy        � Data �  08/02/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �TudoOk de Documentos                                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TudoDoc()

Local nConta 	:= 1
Local nConta1	:= 1
    
//�������������������������������������������������������Ŀ                                               
//�Varre acols verificando se Documentos estao duplicados �
//���������������������������������������������������������                                               
For nConta := 1 To Len(oGet1:aCols)
	For nConta1 := 1 To Len(oGet1:aCols)
		If nConta <> nConta1
			If oGet1:aCols[nConta,2] == oGet1:aCols[nConta1,2]
				MsgInfo("Documento " + oGet1:aCols[nConta,2] + " duplicado. Verifique")
				Return .f.
			Endif
		Endif
	Next nConta1
Next nConta

Return .t.
  
/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   �   R030CGC()� Autor � ROBSON BUENO DA SILVA � Data �18/09/2007���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Funcao responsavel por manter o Layout independente da       ���
���           � resolu��o horizontal do Monitor do Usuario.                  ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
User Function R030CGC(cTipPes,cCNPJ)

Local aArea     := GetArea()
Local aAreaSZ1  := SZ1->(GetArea())
Local lRetorno  := .T.
Local cCNPJBase := ""
DEFAULT cCNPJ   := &(ReadVar())

//��������������������������������������������������������������Ŀ
//� Valida o tipo de pessoa                                      �
//����������������������������������������������������������������  
If cTipPes == "F" .And. !(Len(AllTrim(cCNPJ))==11)
	Help(" ",1,"CPFINVALID")
	lRetorno := .F.
ElseIf cTipPes == "J" .And. !(Len(AllTrim(cCNPJ))==14)  
	Help(" ",1,"CGC")     
	lRetorno := .F.
EndIf     
			
//��������������������������������������������������������������Ŀ
//� Valida a duplicidade do CGC                                  �
//����������������������������������������������������������������
If lRetorno .And. Pcount() > 1 
	If cTipPes == "J"
		dbSelectArea("SA1")
		dbSetOrder(3)
		If MsSeek(xFilial("SA1")+cCNPJ)
			If Aviso("Aten��o","O CNPJ informado j� foi utilizado no cliente "+SA1->A1_COD+"/"+SA1->A1_LOJA+" - "+SA1->A1_NOME+" - "+AllTrim(RetTitle("A1_INSCR"))+": "+SA1->A1_INSCR,{"Aceitar","Cancelar"},2)==2//"Aten��o"###"O CNPJ informado j� foi utilizado no cliente "###"Aceitar"###"Cancelar"
				lRetorno := .F.
			EndIf
		ElseIf lRetorno
			cCNPJBase := SubStr(cCNPJ,1,8)
			dbSelectArea("SA1")
			dbSetOrder(3)
			If MsSeek(xFilial("SA1")+cCNPJBase) .And. M->A1_COD <> SA1->A1_COD
				If Aviso("Aten��o","O CNPJ informado j� foi utilizado no cliente "+SA1->A1_COD+"/"+SA1->A1_LOJA+" - "+SA1->A1_NOME+".",{"Aceitar","Cancelar"},2)==2//"Aten��o"###"O CNPJ informado j� foi utilizado no cliente "###"Aceitar"###"Cancelar"
				   lRetorno := .F.
				EndIf
			EndIf
		EndIf
	Else
		dbSelectArea("SA1")
		dbSetOrder(3)
		If MsSeek(xFilial("SA1")+cCNPJ) .And. M->A1_COD <> SA1->A1_COD
			If Aviso("Aten��o","O CNPJ informado j� foi utilizado no cliente "+SA1->A1_COD+"/"+SA1->A1_LOJA+" - "+SA1->A1_NOME+".",{"Aceitar","Cancelar"},2)==2//"Aten��o"###"O CPF informado j� foi utilizado cliente "###"Aceitar"###"Cancelar"
			   lRetorno := .F.
			EndIf
		EndIf		
	EndIf
EndIf

RestArea(aAreaSA1)
RestArea(aArea)
Return lRetorno       






