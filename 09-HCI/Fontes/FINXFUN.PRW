#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH"
#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 14/12/01
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBarVld   บAutor  ณClaudio D. de Souza บ Data ณ  14/12/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validar o codigo de barras ou a linha digitavel de titulos บฑฑ
ฑฑบ          ณ a pagar ou a receber                                       บฑฑ
ฑฑบ          ณ Parametros: cCodBar - Codigo de barras ou linha digitavel  บฑฑ
ฑฑบ          ณ Retorno   : aRet    - Matriz com os retornos possiveis     บฑฑ
ฑฑบ          ณ             aRet[1] - 0 Codigo de barras de titulos/Boletosบฑฑ
ฑฑบ          ณ                       1 Codigo de barras de concessionariasบฑฑ
ฑฑบ          ณ                       2 Linha digitavel de titulos/Boletos บฑฑ
ฑฑบ          ณ                       3 Linha digitavel de concessionarias บฑฑ
ฑฑบ          ณ             aRet[2] - .T. Codigo de barras ou linha digita-บฑฑ
ฑฑบ          ณ                           vel validos                      บฑฑ
ฑฑบ          ณ                       .F. Caso contrario                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CBarVld(cCodBar)
Local lRet := .T.,;
		nX			  ,;
		cCampo     ,;
		nRet := 0

cCodBar := Alltrim(cCodBar)
// Completa o tamanho do codigo de barras se ele for menor que 44 por se tratar de uma
// linha digitavel.
If Len(cCodBar) < 44
	cCodBar := Left(cCodBar+Replicate("0", 48-Len(cCodBar)),47)
Endif

Do Case
Case Len(cCodBar)==44 // Validacao do codigo de Barras
	// Boletos
	nRet := 0
	// Se nao conseguir validar o DV do codigo de barras, tenta validar como
	// se fosse titulo de concessionaria.	
	If Dv_BarCode(Left(cCodBar,4)+SubStr(cCodBar,6))!=SubStr(cCodBar,5,1)
		nRet := 1 // Codigo de barras de concessionarias
		// Concessionarias
		If Mod10(Left(cCodBar,3)+SubStr(cCodBar,5))!=SubStr(cCodBar,4,1)
			lRet := .F. // Invalido
		Endif	
	Endif
Case Len(cCodBar)==47 // Validacao da linha digitavel 
	nRet := 2
	// Elimina os digitos
	cCodSemDv := Left(cCodBar,9)+SubStr(cCodBar,11,10)+SubStr(cCodBar,22,10)
	// Calcula os digitos e os compara com os digitos informados
	For nX := 1 To 3
		cCampo := SubStr(cCodSemDv,If(nX==1,1,If(nX==2,10,20)),If(nX==1,9,10))
		If Mod10(cCampo) != SubStr(cCodBar,If(nX==1,10,If(nX==2,21,32)),1)
			lRet := .F.
			Exit
		Endif
	Next
OtherWise // Validacao da linha digitavel de concessionarias
	nRet := 3
	// Elimina os digitos
	cCodSemDv := Left(cCodBar,11)+SubStr(cCodBar,13,11)+SubStr(cCodBar,25,11)+SubStr(cCodBar,37,11)
	// Calcula os digitos e os compara com os digitos informados
	For nX := 1 To Len(cCodSemDv) Step 11
		cCampo := SubStr(cCodSemDv,nX,11)
//		If Mod10(cCampo) != SubStr(cCodBar,nX+If(nX==1,11,12),1)
		If nX == 1
			nAju := 11
		Elseif nX == 12  
			nAju := 12
		ElseIf nX == 23
			nAju := 13
		ElseIf nX == 34 
			nAju := 14		
		EndIf	
				
		If Mod10(cCampo) != SubStr(cCodBar,nX+nAju,1)		
			lRet := .F.
			Exit
		Endif
	Next
EndCase
Return {nRet,lRet}

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณDv_BarCodeบAutor  ณClaudio D. de Souza บ Data ณ  14/12/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCalcula o digito verificador de um codigo de barras padrao  บฑฑ
ฑฑบ          ณFebraban.                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CodBarVl2                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function DV_BarCode( cBarCode )
Local cDig     ,;
      nPos     ,;
      nAux := 0

    For nPos := 1 To 43
        nAux += Val(SubStr(cBarCode,nPos,1)) * If( nPos<= 3, ( 5-nPos),     ;
                                                If( nPos<=11, (13-nPos),     ;
                                                If( nPos<=19, (21-nPos),     ;
                                                If( nPos<=27, (29-nPos),     ;
                                                If( nPos<=35, (37-nPos),     ;
                                                               (45-nPos) )))))
    Next
    nAux := nAux % 11
    cDig := If( (11-nAux)>9, 1, (11-nAux) )
    
Return StrZero( cDig, 1 )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณMod10     บAutor  ณClaudio D. de Souza บ Data ณ  14/12/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCalcula o digito verificador de uma sequencia de numeros    บฑฑ
ฑฑบ          ณbaseando-se no modulo 10. Utilizado para verificar o digito บฑฑ
ฑฑบ          ณem linhas digitaveis e codigo de barras de concessionarias  บฑฑ
ฑฑบ          ณde servicos publicos                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CodBarVl2                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Mod10( cNum )
Local nFor    := 0,;
      nTot    := 0,;
      cNumAux

   If Len(cNum)%2 #0
      cNum := "0"+cNum
   EndIf

   For nFor := 1 To Len(cNum)
      If nFor%2 == 0
         cNumAux := StrZero(2 * Val(SubStr(cNum,nFor,1)), 2)
      Else
         cNumAux := StrZero(Val(SubStr(cNum,nFor,1))    , 2)
      Endif
      nTot += ( Val(LEFT(cNumAux,1)) + Val(Right(cNumAux,1)) )
   Next

   nTot := nTot % 10
   nTot := If( nTot#0, 10-nTot, nTot )

Return StrZero(nTot,1)

#include "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณCBarTRF   บ Autor ณ  Andreza Favero    บ Data ณ  03/06/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Desc.    ณTransforma a linha digitavel em codigo de barras.           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Uso      ณ AP5                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

// A funcao CBarTRF ้ usada como um gatilho de E2_CODBAR para E2_CODBAR
User Function CBarTRF()

Local cMonta1 := ""
Local cMonta2 := ""
Local cMonta3 := ""
Local cMonta4 := ""
Local cMonta5 := ""
Local cMonta6 := ""
Local cMonta7 := ""
Local cReturn := ""
Local cCodbar := Trim(M->E2_CODBAR)
Local nTamCod := Len(cCodbar)
Local nTamVal := Len(cCodbar)-33

// Verifica tamanho da linha digitแvel
If !empty(alltrim(cCodbar))
	
	If nTamCod == 44
		cReturn := cCodbar
	Else
		If Substr(M->E2_CODBAR,1,1) <> "8"
			
			If nTamVal < 14        // Codigo de Barras sem fator de vencimento.
				cMonta3 := "0000"
				cMonta4 := Strzero(Val(Substr(cCodbar,34,nTamVal)),10)
			Else                    // Codigo de Barras com fator de vencimento.
				cMonta3:= Substr(cCodbar,34,4)
				cMonta4:= Substr(cCodbar,38,10)
			Endif
			
			// Monta o Codigo de Barras
			cMonta1:= Substr(cCodbar,1,4)
			cMonta2:= Substr(cCodbar,33,1)
			cMonta5:= Substr(cCodbar,5,5)
			cMonta6:= Substr(cCodbar,11,10)
			cMonta7:= Substr(cCodbar,22,10)
			
			cCodBar := cMonta1 + cMonta2 + cMonta3 + cMonta4 + cMonta5 + cMonta6 + cMonta7
			
		Else
			// Faz o desmembramento para codigo de barra de boleto
			// para pagamento de Concessionarias de Serv. Publicos (agua, luz, telefone,...)
			
			cMonta1:= Substr(cCodbar,1,11)
			cMonta2:= Substr(cCodbar,13,11)
			cMonta3:= Substr(cCodbar,25,11)
			cMonta4:= Substr(cCodbar,37,11)
			
			cCodBar := cMonta1 + cMonta2 + cMonta3 + cMonta4
			
		Endif
	EndIf
EndIf

Return(cCodBar)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALCOD1   บAutor  ณAndreza Favero      บ Data ณ  03/06/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณvalida a linha digitavel / codigo de barras.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

// A funcao VALCOD1() devera ser incluida no X3_VLDUSER do campo E2_CODBAR
User Function VALCOD1()

LRET := .F.

if ValType(M->E2_CODBAR) == NIL
	Return(.t.)
Endif

If EMPTY(alltrim(M->E2_CODBAR))
	Return(.t.)
Endif

cStr := M->E2_CODBAR

If "*" $ cStr
	Help(" ", 1, "ONLYNUM")
	Return(.f.)
EndIf

i := 0
nMult := 2
nModulo := 0
cChar := SPACE(1)
cDigito := SPACE(1)

If len(AllTrim(cStr)) > 44  // linha digitada  (sera valido para boletos normais e concessionarios publicos)
	
	If Substr(M->E2_CODBAR,1,1) <> "8"
		
		cDV1    := SUBSTR(cStr,10, 1)
		cDV2    := SUBSTR(cStr,21, 1)
		cDV3    := SUBSTR(cStr,32, 1)
		
		cCampo1 := SUBSTR(cStr, 1, 9)
		cCampo2 := SUBSTR(cStr,11,10)
		cCampo3 := SUBSTR(cStr,22,10)
		
		/*
		ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
		ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
		ฑฑณDescri…o ณ Calculo do modulo 10 sugerido pelo ITAU. Esta funcao       ณฑฑ
		ฑฑณ          ณ somente e utilizada como validacao do campo E2_CODBAR      ณฑฑ
		ฑฑณ          ณ Verifica a digitacao do codigo de barras                   ณฑฑ
		ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
		ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
		*/
		
		//
		// Calcula DV1
		//
		
		nMult := 2
		nModulo := 0
		nVal := 0
		
		For i := Len(cCampo1) to 1 Step -1
			cChar := Substr(cCampo1,i,1)
			if isAlpha(cChar)
				Help(" ", 1, "ONLYNUM")
				Return(.f.)
			endif
			nModulo := Val(cChar)*nMult
			If nModulo >= 10
				nVal := NVAL + 1
				nVal := nVal + (nModulo-10)
			Else
				nVal := nVal + nModulo
			EndIf
			nMult:= if(nMult==2,1,2)
		Next
		nCalc_DV1 := 10 - (nVal % 10)
		if nCalc_DV1 == 10
			nCalc_DV1:=0
		endif
		
		//
		// Calcula DV2
		//
		nMult := 2
		nModulo := 0
		nVal := 0
		
		For i := Len(cCampo2) to 1 Step -1
			cChar := Substr(cCampo2,i,1)
			if isAlpha(cChar)
				Help(" ", 1, "ONLYNUM")
				Return(.f.)
			endif
			nModulo := Val(cChar)*nMult
			If nModulo >= 10
				nVal := nVal + 1
				nVal := nVal + (nModulo-10)
			Else
				nVal := nVal + nModulo
			EndIf
			nMult:= if(nMult==2,1,2)
		Next
		nCalc_DV2 := 10 - (nVal % 10)
		if nCalc_DV2==10
			nCalc_DV2:=0
		endif
		//
		// Calcula DV3
		//
		nMult := 2
		nModulo := 0
		nVal := 0
		
		For i := Len(cCampo3) to 1 Step -1
			cChar := Substr(cCampo3,i,1)
			if isAlpha(cChar)
				Help(" ", 1, "ONLYNUM")
				Return(.f.)
			endif
			nModulo := Val(cChar)*nMult
			If nModulo >= 10
				nVal := nVal + 1
				nVal := nVal + (nModulo-10)
			Else
				nVal := nVal + nModulo
			EndIf
			nMult:= if(nMult==2,1,2)
		Next
		nCalc_DV3 := 10 - (nVal % 10)
		
		if nCalc_DV3==10
			nCalc_DV3:=0
		endif
		
		if !(nCalc_DV1 == Val(cDV1) .and. nCalc_DV2 == Val(cDV2) .and. nCalc_DV3 == Val(cDV3) )
			Help(" ",1,"INVALCODBAR")
			lRet := .f.
		else
			lRet := .t.
		endif
		
	Else
		// Faz validacao para cod de barras de pagamento a Concessionarios Publicos
		
		cDV1    := SUBSTR(cStr,12, 1)
		cDV2    := SUBSTR(cStr,24, 1)
		cDV3    := SUBSTR(cStr,36, 1)
		cDV4    := SUBSTR(cStr,48, 1)
		
		cCampo1 := SUBSTR(cStr, 1, 11)
		cCampo2 := SUBSTR(cStr,13,11)
		cCampo3 := SUBSTR(cStr,25,11)
		cCampo4 := SUBSTR(cStr,37,11)
		
		//
		// Calcula DV1
		//
		
		nMult := 2
		nModulo := 0
		nVal := 0
		
		For i := Len(cCampo1) to 1 Step -1
			cChar := Substr(cCampo1,i,1)
			if isAlpha(cChar)
				Help(" ", 1, "ONLYNUM")
				Return(.f.)
			endif
			nModulo := Val(cChar)*nMult
			If nModulo >= 10
				nVal := NVAL + 1
				nVal := nVal + (nModulo-10)
			Else
				nVal := nVal + nModulo
			EndIf
			nMult:= if(nMult==2,1,2)
		Next
		nCalc_DV1 := 10 - (nVal % 10)
		if nCalc_DV1 == 10
			nCalc_DV1:=0
		endif
		
		//
		// Calcula DV2
		//
		nMult := 2
		nModulo := 0
		nVal := 0
		
		For i := Len(cCampo2) to 1 Step -1
			cChar := Substr(cCampo2,i,1)
			if isAlpha(cChar)
				Help(" ", 1, "ONLYNUM")
				Return(.f.)
			endif
			nModulo := Val(cChar)*nMult
			If nModulo >= 10
				nVal := nVal + 1
				nVal := nVal + (nModulo-10)
			Else
				nVal := nVal + nModulo
			EndIf
			nMult:= if(nMult==2,1,2)
		Next
		nCalc_DV2 := 10 - (nVal % 10)
		if nCalc_DV2==10
			nCalc_DV2:=0
		endif
		//
		// Calcula DV3
		//
		nMult := 2
		nModulo := 0
		nVal := 0
		
		For i := Len(cCampo3) to 1 Step -1
			cChar := Substr(cCampo3,i,1)
			if isAlpha(cChar)
				Help(" ", 1, "ONLYNUM")
				Return(.f.)
			endif
			nModulo := Val(cChar)*nMult
			If nModulo >= 10
				nVal := nVal + 1
				nVal := nVal + (nModulo-10)
			Else
				nVal := nVal + nModulo
			EndIf
			nMult:= if(nMult==2,1,2)
		Next
		nCalc_DV3 := 10 - (nVal % 10)
		
		if nCalc_DV3==10
			nCalc_DV3:=0
		endif
		
		//
		// Calcula DV4
		//
		
		nMult := 2
		nModulo := 0
		nVal := 0
		
		For i := Len(cCampo4) to 1 Step -1
			cChar := Substr(cCampo4,i,1)
			if isAlpha(cChar)
				Help(" ", 1, "ONLYNUM")
				Return(.f.)
			endif
			nModulo := Val(cChar)*nMult
			If nModulo >= 10
				nVal := nVal + 1
				nVal := nVal + (nModulo-10)
			Else
				nVal := nVal + nModulo
			EndIf
			nMult:= if(nMult==2,1,2)
		Next
		nCalc_DV4 := 10 - (nVal % 10)
		
		if nCalc_DV4==10
			nCalc_DV4:=0
		endif
		
		if !(nCalc_DV1 == Val(cDV1) .and. nCalc_DV2 == Val(cDV2) .and. nCalc_DV3 == Val(cDV3) .and. nCalc_DV4 == Val(cDV4))
			Help(" ",1,"INVALCODBAR")
			lRet := .f.
		else
			lRet := .t.
		endif
	EndIf
	
	// CONSISTE O CODIGO DE BARRAS GERADO PELA LEITORA
Else
	
	// Valida os boletos normais
	If Substr(M->E2_CODBAR,1,1) <> "8"
		cDigito := SUBSTR(cStr,5, 1)
		cStr    := SUBSTR(cStr,1, 4)+ ;
		SUBSTR(cStr,6,39)
		
		/*
		ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
		ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
		ฑฑณDescri…o ณ Calculo do modulo 11 sugerido pelo ITAU. Esta funcao       ณฑฑ
		ฑฑณ          ณ somente e utilizada como validacao do campo E2_CODBAR.     ณฑฑ
		ฑฑณ          ณ Verifica o codigo de barras grafico (Atraves de leitor)    ณฑฑ
		ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
		ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
		*/
		cStr := AllTrim(cStr)
		
		if Len(cStr) < 43
			Help(" ", 1, "FALTADG")
			Return(.f.)
		Endif
		
		For i := Len(cStr) to 1 Step -1
			cChar := Substr(cStr,i,1)
			if isAlpha(cChar)
				Help(" ", 1, "ONLYNUM")
				Return(.f.)
			endif
			nModulo := nModulo + Val(cChar)*nMult
			nMult:= if(nMult==9,2,nMult+1)
		Next
		nRest := 11 - (nModulo % 11)
		nRest := if(nRest==10 .or. nRest==11 .or. nRest == 0,1,nRest)
		if nRest <> Val(cDigito)
			Help(" ",1,"DgCnab")
			lRet := .f.
		else
			lRet := .t.
		endif
		
	Else
		// Neste momento sera consistido o codigo de barras
		// para Concessionarias de Servicos Publicos (telofone, agua, luz, etc...)
		// Sera consistido pelo Modulo 10
		
		cDigito := SUBSTR(cStr,4,1)
		cStr    := SUBSTR(cStr,1,3)+SUBSTR(cStr,5,40)
		
		cStr := AllTrim(cStr)
		
		if Len(cStr) < 43
			Help(" ", 1, "FALTADG")
			Return(.f.)
		Endif

		nMult := 2
		nModulo := 0
		nVal := 0

		/*
		ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
		ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
		ฑฑณDescri…o ณ Os boletos para pagamento a concessionarias publicas       ณฑฑ
		ฑฑณ          ณ sera consistido pelo Modulo 10.                            ณฑฑ
		ฑฑณ          ณ Verifica o codigo de barras grafico (Atraves de leitor)    ณฑฑ
		ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
		ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
		*/
		
		For i := Len(cStr) to 1 Step -1
			cChar := Substr(cStr,i,1)
			if isAlpha(cChar)
				Help(" ", 1, "ONLYNUM")
				Return(.f.)
			endif
			nModulo := Val(cChar)*nMult
			If nModulo >= 10
				nVal := NVAL + 1
				nVal := nVal + (nModulo-10)
			Else
				nVal := nVal + nModulo
			EndIf
			nMult:= if(nMult==2,1,2)
		Next
		
		nRest := 10 - (nVal % 10)
		if nRest == 10
			nRest:=0
		endif
		
		if nRest <> Val(cDigito)
			Help(" ",1,"DgCnab")
			lRet := .f.
		else
			lRet := .t.
		endif
		
	EndIf	
Endif

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetVarMem บAutor  ณ Deny Mendonca      บ Data ณ  10.04.06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna Conteudo os valores da Variavel de Memoria de Calc  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GetVarMem(cId, cVariav, xDimen1, xDimen2, xDimen3, cTexto)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclaracao de variaveis                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local xRet  	:= ''
Local aArea		:= GetArea()
Local aAreaPB6	:= PB6->(GetArea())
Default xDimen1 := ''
Default xDimen2 := ''
Default xDimen3 := ''
Default cTexto 	:= ''
//Procura pela Variavel
dbSelectArea("PB4")
dbSetOrder(1)
If !dbSeek(xfilial("PB4")+cVariav)
	Aviso("Atencใo !","Variavel nao Encontrada, verifique o cadastro de Variaveis: "+Alltrim(cVariav)+Alltrim(cTexto),{"Ok"})
	Return(xRet)
EndIf

/*  Essa consistencia nao eh necessaria
// Procura pelo Id de Processamento
dbSelectArea("PB5")
dbSetOrder(1)
If !dbSeek(xfilial("PB5")+cId)
	MsgStop("Id de Memoria de Calculo nao Encontrado:"+cId)
	Return(xRet)
EndIf
*/ 

//Converte Dimensoes
xDimen1 := Iif(Empty(xDimen1).And.!Valtype(xDimen1)=='L','',Alltrim(GetVarDim(1, xDimen1)))
xDimen2 := Iif(Empty(xDimen2).And.!Valtype(xDimen2)=='L','',Alltrim(GetVarDim(2, xDimen2)))
xDimen3 := Iif(Empty(xDimen3).And.!Valtype(xDimen3)=='L','',Alltrim(GetVarDim(3, xDimen3)))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefine o retorno default                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If PB4->PB4_TIPO == '1'
	xRet := 0
ElseIf PB4->PB4_TIPO == '2'
	xRet := ""
ElseIf PB4->PB4_TIPO == '3'
	xRet := CTOD("")
ElseIf PB4->PB4_TIPO == '4'
	xRet := .f.
EndIf	

// Procura pelo Id de Processamento
dbSelectArea("PB6")
dbSetOrder(1)
If !dbSeek(xfilial("PB6")+cId+Padr(cVariav,tamsx3('PB6_VARIAV')[1])+Padr(xDimen1,tamsx3('PB6_DIMEN1')[1])+Padr(xDimen2,tamsx3('PB6_DIMEN2')[1])+Padr(xDimen3,tamsx3('PB6_DIMEN3')[1]))
	Aviso("Atencใo !","Variavel nao Encontrada no Id:"+cId+", verifique o cadastro de Variaveis: "+cVariav+cTexto,{"Ok"})
	RestArea(aAreaPB6)
	RestArea(aArea)
	Return(xRet)
EndIf

If PB4->PB4_TIPO == '1'
	xRet := Val(PB6->PB6_CONTEU)
ElseIf PB4->PB4_TIPO == '2'
	xRet := Alltrim(PB6->PB6_CONTEU)
ElseIf PB4->PB4_TIPO == '3'
	xRet := StoD(PB6->PB6_CONTEU)
ElseIf PB4->PB4_TIPO == '4'
	xRet := Iif(Upper(Alltrim(PB6->PB6_CONTEU)) == ".F.",.f.,.t.)
EndIf	
RestArea(aAreaPB6)
RestArea(aArea)
Return(xRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetVarDim บAutor  ณ Deny Mendonca      บ Data ณ  10.04.06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetVarDim(nDimensao, xContDim)
Local xRet := ''
Local nTipo
Local nA := 0
Local lDimInv := .f.

nTipo  := &('PB4->PB4_TIPOD'+Alltrim(Str(nDimensao))) 
	
If nTipo == '1'
	If Valtype(xContDim) <> 'N'
		lDimInv := .t.
	Else
		xRet := Alltrim(Str(xContDim))
	EndIf
ElseIf nTipo == '2'
	If Valtype(xContDim) <> 'C'
		lDimInv := .t.
	Else
		xRet := xContDim
	EndIf
ElseIf nTipo == '3'
	If Valtype(xContDim) <> 'D'
		lDimInv := .t.
	Else
		xRet := Dtos(xContDim)
	EndIf
ElseIf nTipo == '4'
	If Valtype(xContDim) <> 'L'
		lDimInv := .t.
	Else
		xRet := Iif(xContDim,".T.",".F.")
	EndIf
EndIf	

If lDimInv
	MsgStop("Formato da dimensao invalida, verifique o cadastro de Variaveis: "+PB4->PB4_VARIAV+" Dimensao:"+Alltrim(Str(nDimensao)))
	xRet := ''
EndIf

Return(xRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetVarMem บAutor  ณ Deny Mendonca      บ Data ณ  12.04.06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGrva valores da Variavel de Memoria de Calc                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GrvVarMem(cId, cVariav, lCheck, xConteudo, xDimen1, xDimen2, xDimen3)

Local nRet  		:= 1 	// 0 - Nao encontrou variavel
								// 1 - Gravacao Ok - novo Registro
								// 2 - Gravacao Ok - Registro Alterado
								// 3 - Achou a variavel para o Id e o Conteudo eh o mesmo
								// 4 - Achou a variavel para o Id e o Conteudo NAO eh o mesmo
Local lLock 		:= .t.
Local lTipoinv		:= .f.
Default xDimen1 	:= ''
Default xDimen2 	:= ''
Default xDimen3 	:= ''
Default lCheck 	:= .f.

//Procura pela Variavel
dbSelectArea("PB4")
dbSetOrder(1)
If !dbSeek(xfilial("PB4")+cVariav)
	MsgStop("Variavel nao Encontrada, verifique o cadastro de Variaveis: "+cVariav)
	Return(0)
EndIf

//Converte Dimensoes
xDimen1 := Iif(Empty(xDimen1).And.!Valtype(xDimen1)=='L','',Alltrim(GetVarDim(1, xDimen1)))
xDimen2 := Iif(Empty(xDimen2).And.!Valtype(xDimen2)=='L','',Alltrim(GetVarDim(2, xDimen2)))
xDimen3 := Iif(Empty(xDimen3).And.!Valtype(xDimen3)=='L','',Alltrim(GetVarDim(3, xDimen3)))
//MSGSTOP(str(U_GrvVarMem('000002','COENELRMED',.f., 1234,'1',ctod('30/08/1978'),.f.)))

If PB4->PB4_TIPO == '1'
	If Valtype(xConteudo) <> 'N'
		lTipoinv := .t.
	Else
		xConteudo := Alltrim(Str(xConteudo))
	EndIf
ElseIf PB4->PB4_TIPO == '2'
	If Valtype(xConteudo) <> 'C'
		lTipoinv := .t.
	Else
		xConteudo := xConteudo
	EndIf
ElseIf PB4->PB4_TIPO == '3'
	If Valtype(xConteudo) <> 'D'
		lTipoinv := .t.
	Else
		xConteudo := DTOS(xConteudo)
	EndIf
ElseIf PB4->PB4_TIPO == '4'
	If Valtype(xConteudo) <> 'L'
		lTipoinv := .t.
	Else
		xConteudo := Iif(xConteudo,'.T.','.F.')
	EndIf
EndIf	

If lTipoinv
	MsgStop("Formato Invalido para a Variavel, verifique o cadastro de Variaveis: "+PB4->PB4_VARIAV)
	Return(0) // Nao Achou a variavel para o Id
EndIf

// Procura pelo Id de Processamento
dbSelectArea("PB6")
dbSetOrder(1)
If dbSeek(xfilial("PB6")+cId+Padr(cVariav,tamsx3('PB6_VARIAV')[1])+Padr(xDimen1,tamsx3('PB6_DIMEN1')[1])+Padr(xDimen2,tamsx3('PB6_DIMEN2')[1])+Padr(xDimen3,tamsx3('PB6_DIMEN3')[1]))
	lLock := .f.
	nRet	:= 2
	If lCheck
		If Alltrim(PB6->PB6_CONTEU) == Alltrim(xConteudo)
			Return(3) // Achou a variavel para o Id e o Conteudo eh o mesmo
		Else
			Return(4) // Achou a variavel para o Id e o Conteudo NAO eh o mesmo
		EndIf
	EndIf
Else
	lLock := .t.
	nRet	:= 1
	If lCheck
		Return(0) // Nao Achou a variavel para o Id
	EndIf
EndIf

dbSelectArea("PB6")
RecLock("PB6",lLock)
	PB6->PB6_FILIAL	:= xFilial("PB6")
	PB6->PB6_ID			:= cId
	PB6->PB6_VARIAV	:= cVariav
	PB6->PB6_CONTEU	:= xConteudo
	PB6->PB6_DIMEN1	:= xDimen1
	PB6->PB6_DIMEN2	:= xDimen2
	PB6->PB6_DIMEN3	:= xDimen3
MsUnlock()

Return(nRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetVarMem บAutor  ณ Deny Mendonca      บ Data ณ  12.04.06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGrva valores da Variavel de Memoria de Calc                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GetProxId()
Local cParametro 	:= "CO_NUMIDMC"
Local cId 			:= GetMv( cParametro , .F. , "0000000001" )
Local nCount 		:= 1
Local cQuery		:= ""
Local cProxID		:= 0

While .T. .And. nCount < 36
	If cId <> "*"
		DbSelectArea("SX6")
		// Bloqueio o Parametro para uso enquando existe a validacao
		PutMv(cParametro,"*")
		Exit
	Else
		CursorWait()
	   MsAguarde({ || } 	,"Aguardando Libera็ใo","ID de Mem๓ria de Cแlculo:"+Strzero(nCount*5,3)+"/180 Seg...",.F.)
		nCount++
		Sleep(5000)
		CursorArrow()
	EndIf
EndDo

If cId == "*"
	Aviso("Atencใo !","Nใo foi possํvel definir o pr๓ximo ID de Calculo.",{"Ok"})
	cId := ""
Else
	dbSelectArea("PB6")
	dbSetOrder(1)
	If dbSeek(xfilial("PB6")+cId)
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Procura pela revisao                                                     	  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cQuery	:= " SELECT ISNULL(MAX(PB6_ID),'000000') AS MAXID"
		cQuery	+= " FROM "+RetSqlName("PB6")+" (NOLOCK)"
		cQuery	+= " WHERE PB6_FILIAL = '"+xFilial("PB6")+"'"
		cQuery	+= " AND D_E_L_E_T_ <> '*'"

		U_FinalArea("MAXID")
		TcQuery cQuery New Alias "MAXID"
		cProxID :=	Soma1(MAXID->MAXID,6)
		U_FinalArea("MAXID")
		Aviso("Atencใo !","O ID Definido ja existe, a Rotina serแ cancelada atualize o parametro:"+cParametro+" com o proximo ID de Calculo:"+cProxID,{"Ok"})
		// Volto o Paramatro para o Id Anterior com Teoriacamente com Problema, para evitar que o proximo usuario consiga seguir.
		DbSelectArea("SX6")
		PutMv(cParametro,cId)
		cId := ""
	Else
		// Gravo o Proximo Id no Parametro
		DbSelectArea("SX6")
		PutMv(cParametro,Soma1(cId,6))
	EndIf
EnDIf

Return(cId)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMaxSeqAp  บAutor  ณAndreza Favero      บ Data ณ  04/24/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCalcula a proxima sequencial de apontamento de despesas     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
 
User Function MaxSeqAp(cVend,dData)

Local aArea	:= GetArea()
Local cQuery	:= " "
Local cProxSEQ	:= " "

If cVend == Nil
	cVend	:= M->AD5_VEND
Endif
	
If dData == Nil
	dData	:= M->AD5_DATA
Endif

cQuery	:= " SELECT ISNULL(MAX(AD5_SEQUEN),'00') AS MAXSEQ"
cQuery	+= " FROM "+RetSqlName("AD5")+" (NOLOCK)"
cQuery	+= " WHERE AD5_FILIAL = '"+xFilial("AD5")+"'"
cQuery	+= " AND AD5_VEND = '"+cVend+"'"
cQuery	+= " AND AD5_DATA = '"+dtos(dData)+"'"
cQuery	+= " AND D_E_L_E_T_ <> '*'"
                                              
If Select("MAXSEQ") > 0
	DbCloseArea()
EndIf
	
TcQuery cQuery New Alias "MAXSEQ"

cProxSEQ :=	Soma1(MAXSEQ->MAXSEQ,2)

If Select("MAXSEQ") > 0
	DbCloseArea()
EndIf

RestArea(aArea)

Return(cProxSeq)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrvArrMem บAutor  ณ Deny Mendonca      บ Data ณ  05.05.06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRecebe um Array e grava na Memoria de Calculo               บฑฑ
ฑฑบ          ณ1 - Id de Calculo                                           บฑฑ
ฑฑบ          ณ2 - Variavel                                                บฑฑ
ฑฑบ          ณ3 - Conteudo                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GrvArrMem(cId,aGrvArray)
Local nA := 0
Default aGrvArray := {}

For nA:=1 to Len(aGrvArray)
	u_GrvVarMem(cId,;
				Iif(Len(aGrvArray[nA])>=1,aGrvArray[nA,1],Nil),; //cVariav
				Iif(Len(aGrvArray[nA])>=2,aGrvArray[nA,2],Nil),; //lCheck
				Iif(Len(aGrvArray[nA])>=3,aGrvArray[nA,3],Nil),; //xConteudo
				Iif(Len(aGrvArray[nA])>=4,aGrvArray[nA,4],Nil),; //xDimen1
				Iif(Len(aGrvArray[nA])>=5,aGrvArray[nA,5],Nil),; //xDimen2
				Iif(Len(aGrvArray[nA])>=6,aGrvArray[nA,6],Nil))  //xDimen3
Next nA

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณManutMemo บAutor  ณ Jaime Wikanski     บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTela de manutencao do memo                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ HCI                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ManutMemo(cCpoMemo,lExibe,oGetDad)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis                  								    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local nOpcConf
Local aPosObj    	:= {} 
Local aObjects   	:= {}                        
Local aSize      	:= MsAdvSize() 
Local aCposGet		:= {}                                                             
Local nOpcA			:= 0
Local oDlgMain		:= Nil
Local cMemo			:= Space(1000)
Local aButtons		:= {}
Local cPerg			:= "MANMEM"
Local aRegs			:= {}
Local oFont			:= Nil
Local oMemo			:= Nil
Local cNomeFont		:= ""
Local cLabel		:= Alltrim(RetTitle(StrTran(ReadVar(),"M->","")))+":"
Local lAltMemo		:= .T.
Default cCpoMemo	:= ""
Default lExibe		:= .F.

//If !Alltrim(Upper(Posicione("SX3",2,Alltrim(StrTran(ReadVar(),"M->","")),"X3_WHEN"))) $ "U_MANUTMEMO()" .or. Alltrim(Upper(StrTran(ReadVar(),"M->",""))) <> Alltrim(Upper(cCpoMemo))
If (!Alltrim(Upper(StrTran(ReadVar(),"M->",""))) == Alltrim(Upper(cCpoMemo)) .or. Empty(Alltrim(Upper(StrTran(ReadVar(),"M->",""))))) .and. !lExibe
	Return(.T.)
Endif

If Type("Inclui") <> "U" .and. Type("Altera") <> "U"
	If !Inclui .and. !Altera
		lAltMemo := .F.
	Endif
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefine o conteudo do memo                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !Empty(ReadVar())
	cMemo 	:= &(ReadVar())
Else
	cMemo	:= oGetDad:Acols[oGetDad:nAt][oGetDad:OBROWSE:COLPOS]
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefine os botoes da rotina                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd(aButtons, {'IC_17',{||ParamMemo(cPerg,@oFont,@oMemo)},"Fonte",OemToAnsi("Fonte")} )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta os parametros da rotina                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Aadd(aRegs,{cPerg,"01","Fonte "           		,"","","mv_ch1","N",01,0,2,"C","","MV_PAR01","Arial","","","","","Courier","","","","","Tahoma","","","","","","","","","","","","","","","","",	"","" })					
Aadd(aRegs,{cPerg,"02","Tamanho"           		,"","","mv_ch2","N",02,0,0,"G","","MV_PAR02","",		"","","",		"","",					"","","","","","","","","","","","","","","","","","","",	"","","",""})
U_CriaSx1(aRegs)
Pergunte(cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define a fonte de exibicao do memo                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Do Case
	Case MV_PAR01 == 1
		cNomeFont := "Arial"
	Case MV_PAR01 == 2
		cNomeFont := "Courier"
	Case MV_PAR01 == 3
		cNomeFont := "Tahoma"
Endcase		
oFont := TFont():New(cNomeFont,MV_PAR02-2,MV_PAR02,,.F.,,,,.T.,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefine a area dos objetos                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aObjects := {} 
AAdd( aObjects, { 100, 100, .t., .t. } )

aInfo 		:= { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 } 
aPosObj 	:= MsObjSize( aInfo, aObjects ) 
	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a tela principal                               						ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oDlgMain := TDialog():New(aSize[7],00,aSize[6],aSize[5],cCadastro,,,,,,,,oMainWnd,.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta o memo                                         						ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@ 015,005 Say cLabel OF oDlgMain PIXEL
@ 023,005 GET oMemo VAR cMemo OF oDlgMain MEMO PIXEL FONT oFont COLOR CLR_BLACK SIZE (aPosObj[1,4]-aPosObj[1,2]),(aPosObj[1,3]-aPosObj[1,1])-10 CENTERED WHEN lAltMemo

oDlgMain:Activate(,,,,,,{||EnchoiceBar(oDlgMain,{|| nOpcA := 1, oDlgMain:End() },{||oDlgMain:End()},,aButtons)})
If nOpca == 1
	If !Empty(ReadVar())
		&(ReadVar()) := cMemo
	Else
		oGetDad:Acols[oGetDad:nAt][oGetDad:OBROWSE:COLPOS] := cMemo
	Endif
Endif

Return(.F.)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณParamMemo บAutor  ณ Jaime Wikanski     บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณParametros do campo MEMO                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ HCI                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ParamMemo(cPerg,oFont,oMemo)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis                  								    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cNomeFont		:= ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta os parametros da rotina                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !Pergunte(cPerg,.T.)
	Return
Endif
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define a fonte de exibicao do memo                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Do Case
	Case MV_PAR01 == 1
		cNomeFont := "Arial"
	Case MV_PAR01 == 2
		cNomeFont := "Courier"
	Case MV_PAR01 == 3
		cNomeFont := "Tahoma"
Endcase		
oFont := TFont():New(cNomeFont,MV_PAR02-2,MV_PAR02,,.F.,,,,.T.,.F.)
oMemo:oFont := oFont
oMemo:Refresh(.t.)
Return