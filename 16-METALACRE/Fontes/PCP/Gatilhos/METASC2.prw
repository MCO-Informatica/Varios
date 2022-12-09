#include 'Protheus.ch'
#include 'TopConn.ch'
#include 'MsgOpManual.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³METASC2   ºAutor  ³Bruno Daniel Abrigo º Data ³  12/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa responsavel para controlar o sequencial da OP     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Metalacre                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function METASC2(_xNum,_xTipo,_nOpoc)
Local cQry			:=""
Local cLetra		:=""
Local _aArea        := GetARea()   
//Local _nRecSX1		:= SX1->(Recno())
//Local _cPergX1		:= SX1->X1_GRUPO

If cEmpAnt <> '01'
	Return _xNum
Endif

If Type("l650Auto") == "U"
	l650Auto := .f.
Endif
If l650Auto	// Se Estiver sendo Executado ExecAuto Então Não Processa
	Return _xNum
Endif

If Type("_cNumSeqSC2") == "U"
	Public _cNumSeqSC2 := _xNum
Endif

If _nOpoc == 1
	Return(_cNumSeqSC2)
Else
	If M->C2_XLETRA == "1"
		cLetra := 'S'
	ELSEif M->C2_XLETRA == "2"
		cLetra := 'C'
	ELSEif M->C2_XLETRA == "3"
		cLetra := 'H'
	ELSEif M->C2_XLETRA == "4"
		cLetra := 'P' 
	ELSEif M->C2_XLETRA == "5"
		cLetra := 'V' 
	ELSEif M->C2_XLETRA == "6"
		cLetra := 'I'
	ELSEif M->C2_XLETRA == "7"
		cLetra := 'B'		
	ELSEif M->C2_XLETRA == "8"
		cLetra := 'X'		
	ELSEif M->C2_XLETRA == "9"
		cLetra := 'R'		
	ENDIF

	
	if Empty(cLetra)
	
		If _xTipo == "1"
			cLetra:="M"
		Elseif _xTipo == "2"
			cLetra:="E"
		Else
			cLetra:=""
		Endif
    endif
    		
	if cLetra != ""
		cQry:= "SELECT "+CRLF
		cQry+="   CASE WHEN "+CRLF
		cQry+="     '"+cLetra+"'+REPLICATE('0',5-LEN(MAX(SUBSTRING(C2_NUM,2,6))+1))+''+CONVERT(VARCHAR,MAX(SUBSTRING(C2_NUM,2,6))+1) IS NULL "+CRLF
		cQry+="         THEN "+CRLF
		cQry+="            '"+cLetra+"'+'00001' "+CRLF
		cQry+="		 ELSE "+CRLF
		cQry+="            '"+cLetra+"'+REPLICATE('0',5-LEN(MAX(SUBSTRING(C2_NUM,2,6))+1))+''+CONVERT(VARCHAR,MAX(SUBSTRING(C2_NUM,2,6))+1)"+CRLF
		cQry+="	   END 'NUMSEQ' "+CRLF
		cQry+="FROM " + RetSqlName("SC2") + " WITH(NOLOCK)"+CRLF
		//cQry+=" WHERE D_E_L_E_T_ <> '*'"+CRLF comentado devido ser considerado no momento da exclusao a numeracao
		cQry+="   WHERE LEFT(C2_NUM,1) = '"+cLetra+"'	AND LEN(RTRIM(C2_NUM)) = 6 AND RIGHT(RTRIM(C2_NUM),1) IN ('0','1','2','3','4','5','6','7','8','9') AND D_E_L_E_T_ = ''	"+CRLF      
		MemowRite("c:\temp\Qryout.sql",cQry)
		
		If Select("TRB") > 0
			TRB->(dbCloseArea())  // INSERIDO POR MATEUS HENGLE - 17/03/14 PARA TENTAR SOLUCIONAR O ERRO
		EndIf
		
		TcQuery cQry New Alias "TRB"
		
		DbSelectArea("TRB");TRB->(dbGotop())
		DbSelectArea("SC2");SC2->(dbSetOrder(1)) // Necessario para abrir WorkArea
		if TRB->(!Eof())
			_xNum:=Alltrim(TRB->NUMSEQ)
		Else
			Msginfo(STR0016)
		Endif
		TRB->(dbCloseArea())
		
	Else
		Return(_cNumSeqSC2)
	Endif
Endif
Return(_xNum)
              
Static Function EscLetra()
            
local Letra := ''

Local aRet := {}
Local aParamBox := {}
Local aCombo := {"S=MTG38","C=CORTE","H=HOT","P=PRENSA","V=MTG28","I=INSP","B=SEALBAG"}
Local i	:= 0
Private cCadastro := "xParambox"


AADD(aParamBox,{2,"Escolha ou clique em cancelar",1,aCombo,50,"",.F.})    


If ParamBox(aParamBox,"Escolha da Letra",@aRet)    
	if valType(aret[1]) == 'N'
		Letra := Substr(aCombo[aRet[1]],1,1)
	else
      	Letra := substr(aRet[1],1,1)
 	endif
Endif



Return letra    

/////////////////////////////
Static Function ValidPerg()
/////////////////////////////

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

DbSelectArea("SX1")
DbSetOrder(1)

cPerg := "METASC2"           //aqui definir os parametros

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Letra	?","","","mv_ch1","N",1,0,0,"C","","mv_par01","S=MTG38","","","","","C=CORTE","","","","","H=HOT","","","","","P=PRENSA","","","","","V=MTG28","","","","   ",""})
        // Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01     /Var02   /Def02/Cnt02/Var03/Def03/Cnt03     /Var04/Def04/Cnt04/Var05/Def05/Cnt05

For i:=1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

Return

