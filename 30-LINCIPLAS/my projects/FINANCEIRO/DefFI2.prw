/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噭o	 矰EFFI2    � Autor � Claudio D. de Souza   � Data �30.09.05  潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噭o 砄correncias padroes conforme a alteracao efetuada no titulo 潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso		 � Contas a Receber											  潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
User Function DefFI2

Local aCampos	:= ParamIxb[2]
Local aDados	:= ParamIxb[3]
Local lAbatim   := ParamIxb[4]
Local lProtesto := ParamIxb[5]
Local lCancProt := ParamIxb[6]
Local aRet		:= {}
Local nX    

If !lAbatim .And. !lProtesto .And. !lCancProt
	For nX := 1 To Len(aCampos)
		If AllTrim(aCampos[nX]) = "E1_VENCREA" .And.;
			((ValType(aDados) ="A" .And. aDados[nX] != SE1->&(aCampos[nX])) .Or.;
			(M->&(aCampos[nX]) != SE1->&(aCampos[nX])))
			If SE1->E1_PORTADO = "237"
				Aadd(aRet, { "E1_VENCREA", { || "06" }, { || .T. } } )
			Endif	
		Else
			If AllTrim(aCampos[nX]) != "E1_VENCTO" .And.;
				((ValType(aDados) ="A" .And. aDados[nX] != SE1->&(aCampos[nX])) .Or.;
				(M->&(aCampos[nX]) != SE1->&(aCampos[nX]))) // Alteracao de outros dados, instrucao sera 31
				If SE1->E1_PORTADO = "237"
					Aadd(aRet, { aCampos[nX], { || "31" }, { || .T. } } )
				Endif
			Endif
		Endif
	Next
Endif  

If Empty(aRet)
	If !lAbatim .And. !lProtesto .And. !lCancProt
		Aadd(aRet, { Space(10), { || Space(2) }, { || .T. } } )
	Else
		If SE1->E1_PORTADO = "237"
			If lAbatim
				Aadd(aRet, { Space(10), { || "04" }, { || .T. } } ) // Instrucao de abatimento para banco 237
			Elseif lProtesto
				Aadd(aRet, { Space(10), { || "09" }, { || .T. } } ) // Instrucao de Protesto para banco 237
			Elseif lCancProt
				Aadd(aRet, { Space(10), { || "10" }, { || .T. } } ) // Instrucao de Canc. Protesto para banco 237 (Verificar)
			Endif	
		Endif
	Endif	
Endif 
	
Return aRet