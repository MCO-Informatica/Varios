/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FGEN009  � Autor � Alexandre Martins  � Data �  25/02/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Le um arquivo html modelo e gera o arquivo atualizando seus���
���          � dados conforme disponibilidade de variaveis.               ���
�������������������������������������������������������������������������͹��
���Parametros� c_FileOrig => Arquivo de Entrada.                          ���
���          � c_FileDest => Arquivo de Saida.                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico OmniLink.                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FGEN009(c_FileOrig, c_FileDest)

//	Local c_FileOrig 	:= "\CONTRATOS\PG_TESTE.HTML" //Apenas para Testes
//	Local c_FileDest	:= "C:\SIGA.HTML"			  //Apenas para Testes
	Local l_Continua	:= .T.

	Processa({|lend| l_Continua := fArquivo(c_FileOrig, c_FileDest)},"Preparando arquivo... Por favor aguarde.")
	
	If l_Continua
		c_Win95 := "C:\ARQUIV~1\INTERN~1\IEXPLORE.EXE "
		If File(c_Win95) 
			c_Cmd := c_Win95 + c_FileDest
		Else
			c_Cmd := "Explorer " + c_FileDest
		Endif
		WinExec(c_Cmd)
	Endif
	
Return Nil

Static Function fArquivo(c_FileOrig, c_FileDest)
	
	Local l_Ret 	:= .T.
	Local c_Buffer	:= ""
	Local n_Posicao	:= 0
	Local n_QtdReg	:= 0
	Local n_RegAtu	:= 0
	
	If !File(c_FileOrig)
		l_Ret := .F.
		MsgStop("Arquivo [ "+c_FileOrig+" ] n�o localizado.", "N�o localizou")
	Else
		
		Ft_fuse( c_FileOrig ) 		// Abre o arquivo
		Ft_FGoTop()
		n_QtdReg := Ft_fLastRec()
		ProcRegua(n_QtdReg) 	// Numero de registros a processar
		
		nHandle	:= MSFCREATE( c_FileDest )

		///////////////////////////////////
		// Carregar o array com os itens //
		///////////////////////////////////
		While !ft_fEof() .And. l_Ret
			
			c_Buffer := ft_fReadln()
			
			n_RegAtu++
			IncProc("Concluindo ... "+AllTrim(Str((n_RegAtu/n_QtdReg)*100, 5))+" %")
			
			FWrite(nHandle, &("'" + c_Buffer + "'"))
			ft_fSkip()
			
		Enddo
		
		FClose(nHandle)
		FT_FUse()
	Endif
	
Return l_Ret
