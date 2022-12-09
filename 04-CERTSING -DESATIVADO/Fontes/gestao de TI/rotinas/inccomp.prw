#INCLUDE "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIncComp   บAutor  ณDouglas Mello		 บ Data ณ  22/05/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEste programa ira importar o arquivo CSV ao cadastro de     บฑฑ
ฑฑบ          ณHardware.                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function IncComp()

Private aSay 		:= {}
Private aButton 	:= {}                     
Private nOpc 		:= 1

aAdd(aSay, "Esta rotina irแ efetuar a leitura de um arquivo CSV e importar no cadastro de Hardware.") 

aAdd(aButton, {5,.T.,{|| Pergunte("INCCOMP",.T. ) } } ) 
aAdd(aButton, {1,.T.,{|| nOpc := 1, FechaBatch()}})
aAdd(aButton, {2,.T.,{|| FechaBatch() }})
 
FormBatch(cCadastro,aSay,aButton)
 
If nOpc == 1

 Processa({|| Process() }, "Processando...")

Endif

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINCCOMP   บAutor  ณMicrosiga           บ Data ณ  05/23/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Process()

Local cCodPrd

DbselectArea("U00")
DbgoTop()
DbSetOrder(1) // U00_FILIAL+U00_CODHRD

If Select("ATMP") > 0
	dbSelectArea("ATMP")
	dbCloseArea()                                                                          	
EndIf
                       
learq() //Ler csv do usuario

DbselectArea("ATMP")
DbgoTop()

While !EOF("ATMP") .and. ATMP->ATIVO <> " "
	cCodPrd := GetSXENum("U00", "U00_CODHRD")
	ConfirmSX8()
	RecLock("U00",.T.)
		U00_FILIAL	:=	xFilial("U00")
		U00_CODHRD	:=	cCodPrd
		U00_DESHRD	:=	ATMP->MODELO
		U00_MARCA 	:= 	ATMP->MARCA
		U00_COMATV	:=	ATMP->ATIVO
		U00_NUMSER	:=	ATMP->SN
		U00_STATUS	:=	"3"
		U00_NOMTEC	:=	Substr(cUsuario,7,15)
		U00_PROPRI	:=	"1"
		U00_CODLOC	:=	"003442"
		U00_DATHRD	:=	date()
		U00_GRUATD	:= "000001"
		U00_SETOR	:=	"INFRAESTRUTURA"
		U00_TIPHRD	:=	mv_par02
	U00->(MsUnlock())	
	ATMP->(Dbskip())
EndDo	        

U00->(dbCommitAll())

MsgAlert(" Inclusao efetuada")
	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณINCCOMP   บAutor  ณMicrosiga           บ Data ณ  05/23/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function learq()
 
Local aColun 	:= {}
Local x 		:= 1
Local aCampos	:= {}

Aadd(aCampos,{ "ATIVO"  , "C" , 004 , 0 })
Aadd(aCampos,{ "SN"    , "C" , 040 , 0 })
Aadd(aCampos,{ "MODELO"    , "C" , 040 , 0 })
Aadd(aCampos,{ "MARCA"    , "C" , 040 , 0 })

cArqDbf := CriaTrab( aCampos, .T. )
dbUseArea( .T.,, cArqDbf, "ATMP", .F. )
	
//INICIO DA LEITURA DO TXT
// Abre o arquivo
nHandle := FT_FUse(mv_par01)

// Se houver erro de abertura abandona processamento
If nHandle = -1
	return
Endif

FT_FGoTop() // Posiciona na primeria linha
nLast := FT_FLastRec() // Retorna o n๚mero de linhas do arquivo

While !FT_FEOF()
	cLine := FT_FReadLn() // Retorna a linha corrente
	While substr(cLine,1,1) == "1" .or. substr(cLine,1,1) == "2"// Cabecalho
		FT_FSKIP() // Pula para pr๓xima linha
		cLine := FT_FReadLn() // Retorna a linha corrente
	EndDo
	aAdd(aColun,{at(";",cLine)})
	cLine := substr(cLine,at(";",cLine)+1,len(cLine))
	While x <> len(cLine)
		If (aColun[x][1]) <> 0
			aAdd(aColun,{at(";",cLine)+(aColun[x][1])})
			cLine := substr(cLine,at(";",cLine)+1,len(cLine))
		EndIf
		x++
		If (aColun[x][1]) == (aColun[x-1][1])
			x := len(cLine)
		EndIf		
	EndDo 
	cLine := FT_FReadLn() // Retorna a linha corrente
	
	DbSelectArea( "ATMP" )
	
	RecLock("ATMP",.T.)
		ATMP->ATIVO 	:= 	substr(cLine,aColun[1][1]+1,aColun[2][1]-aColun[1][1]-1) // Ativo
		ATMP->SN		:= 	substr(cLine,aColun[2][1]+1,aColun[3][1]-aColun[2][1]-1) // S/N
		ATMP->MODELO	:=	substr(cLine,aColun[3][1]+1,aColun[4][1]-aColun[3][1]-1) // Modelo
		ATMP->MARCA		:=	substr(cLine,aColun[4][1]+1,len(cLine)) // Marca
	ATMP->(MsUnlock())
    
    aColun 	:= {}
	x 		:= 1
	FT_FSKIP() // Pula para pr๓xima linha
	
EndDo

FT_FUSE() // Fecha o Arquivo - FIM DA LEITURA DO TXT

Return
