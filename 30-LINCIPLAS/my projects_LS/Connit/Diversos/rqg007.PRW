#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ rqg007  			 Ricardo Felipelli   º Data ³  16/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Corrige descricao migrada com caracteres invalidos         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Laselva                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function rqg007()
Local _Opcao := .f.

If MsgYesNO("Corrige descricao SN1  ??  ","executa")
	Processa({|| ImpAtiv()},"Processando...")
EndIf

Return nil

Static Function ImpAtiv()

// € = C
// å = O
// à = O
                  
cArqSaida := CriaTrab( , .F. )
nHdlArq   := FCreate(cArqSaida)
cCRLF     := CHR(13)+CHR(10)

If nHdlArq==-1
	MsgStop("Nao foi possivel criar o arquivo "+cArqSaida+", Verificar...")
	Return nil
EndIf

cLine := "Descricao SN1 com problema" + cCRLF
fWrite(nHdlArq,cLine,Len(cLine))

cLine := "--------------------------------------------------" + cCRLF
fWrite(nHdlArq,cLine,Len(cLine))
cLine := ''
fWrite(nHdlArq,cLine,Len(cLine))
fWrite(nHdlArq,cLine,Len(cLine))

                  
                    
Dbselectarea("SN1")
dbsetorder(1)
SN1->(dbgotop())   
ProcRegua( LastRec() )


while SN1->(!eof())                 
	IncProc( SN1->N1_DESCRIC )        
	_catual := 1
	while _catual <= 40
		_cchar := subst(SN1->N1_DESCRIC,_catual,1)
		if asc(_cchar) < 65 .or. asc(_cchar) > 90   // letras maiusculas              
			if asc(_cchar) < 97 .or. asc(_cchar) > 122   // letras minusculas
				if asc(_cchar) < 48 .or. asc(_cchar) > 57  // numeros
					if asc(_cchar) <> 32 // espaco
						if asc(_cchar) <> 47  // /
							if asc(_cchar) <> 46  // .
								if asc(_cchar) <> 44  // ,
									if asc(_cchar) <> 34  // "
										if asc(_cchar) <> 45  // -
											if asc(_cchar) <> 43  // +   
												if asc(_cchar) <> 39  // ' 
													if asc(_cchar) <> 40  // ( 
 														if asc(_cchar) <> 41  // ( 
															cLine := SN1->N1_DESCRIC + ' - ' + SN1->N1_CBASE + cCRLF
															fWrite(nHdlArq,cLine,Len(cLine))  
															exit
														endif
													endif
												endif
											endif
										endif
									endif
								endif
							endif
						endif
					endif
				endif
			endif
		endif  
		_catual++                                                                                                                            
	
	enddo  
	SN1->(dbskip())
enddo

FClose(nHdlArq)

MsgStop("Temporario: "+cArqSaida)

  

If MsgYesNO("Corrige as descricao erradas  ??  ","executa")
	Processa({|| CORRAtiv()},"Processando...")
EndIf


Return nil




Static Function CORRAtiv()
Dbselectarea("SN1")
dbsetorder(1)
SN1->(dbgotop())   
ProcRegua( LastRec() )

while SN1->(!eof())                 
	IncProc( SN1->N1_DESCRIC )        
	_catual := 1
	_cerro  := 0
	_cdesc  := ''
	while _catual <= 40
		_cchar    := subst(SN1->N1_DESCRIC,_catual,1)
		_ccharcor := subst(SN1->N1_DESCRIC,_catual,1)  
		if asc(_cchar) == 10    
			_ccharcor := ''
			_cerro++
		elseif asc(_cchar) == 13    
			_ccharcor := ''
			_cerro++
		elseif asc(_cchar) == 128    
			_ccharcor := 'C'
			_cerro++
		elseif asc(_cchar) == 183
			_ccharcor := ' '
			_cerro++
		elseif asc(_cchar) == 199
			_ccharcor := 'A'
			_cerro++
		elseif asc(_cchar) == 224
			_ccharcor := 'O'
			_cerro++
		elseif asc(_cchar) == 214
			_ccharcor := 'I'
			_cerro++
		elseif asc(_cchar) == 229
			_ccharcor := 'O'
			_cerro++
		elseif asc(_cchar) == 181
			_ccharcor := 'A'
			_cerro++
		elseif asc(_cchar) == 144
			_ccharcor := 'E'
			_cerro++
		elseif asc(_cchar) == 38
			_ccharcor := 'E'
			_cerro++
		elseif asc(_cchar) == 233
			_ccharcor := 'E'
			_cerro++
		elseif asc(_cchar) == 226
			_ccharcor := 'O'
			_cerro++
		elseif asc(_cchar) == 166
			_ccharcor := '.'
			_cerro++
		elseif asc(_cchar) == 210
			_ccharcor := 'O'
			_cerro++
		elseif asc(_cchar) == 135
			_ccharcor := 'c'
			_cerro++
		elseif asc(_cchar) == 253
			_ccharcor := 'M'
			_cerro++
		elseif asc(_cchar) == 253
			_ccharcor := 'M'
			_cerro++
		elseif asc(_cchar) == 167
			_ccharcor := 'o'
			_cerro++
		elseif asc(_cchar) == 182
			_ccharcor := 'A'
			_cerro++
		endif

		_catual++
		_cdesc += _ccharcor
	enddo  
	
	if _cerro > 0
 		If MsgYesNO("Corrige? "+ SN1->N1_DESCRIC+ " Por "+_cdesc,"executa")
			RecLock("SN1",.F.)
			SN1->N1_DESCRIC := 	_cdesc
			MsUnLock()
		
		EndIf
	endif		
	SN1->(dbskip())
	
enddo

Return nil



