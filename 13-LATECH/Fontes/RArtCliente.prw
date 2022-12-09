          
#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/12/01
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Cliente   ³Kenia  	                  		          				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa: ³RFATR11      ³ Respons vel: ³                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao:³ RELATORIO DE CLIENTES POR ARTIGO                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Data:     ³ 30.05.08    ³ Implantacao: ³ 06 05                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programad:³ Leitao                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function RArtCliente()        // incluido pelo assistente de conversao do AP5 IDE em 13/12/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, 
 //criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,CSIT,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,M_PAG,WNREL,LI,_CVEND,_CNVEND,CGERV,NREC,CTRANSP,CPEDIDO,CSTATUS")

cString   :="SHE"
cDesc1    := OemToAnsi("Este relatorio lista os clientes  ")
cDesc2    := OemToAnsi("que nao compraram o artigo C01,  ")
//cDesc3    :=
tamanho   := "M"
cabec1	  := ""
cabec2	  := ""
limite    := 132
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog  := "ClinteArt"
cPerg     := "PERGV"
aLinha    := { }
aSaldo    := { }
nLastKey  := 0
cSit      := ""
cCancel   := "***** CANCELADO PELO OPERADOR *****"
cQuebra   := ""
cQuebra2  := ""
titulo	  := "Relatorio de Clintes que nao Compraram o  Artigo  " + MV_PAR05
m_pag     := 1
nStatus   := 0
li  	  := 80
wnrel     := "RFATR11"  



//validperg()

pergunte(cPerg,.T.)

SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({||Imprel()})


Return(.T.)   


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Imprel    ³ Autor ³Leandro Nobrega        ³ Data ³ 13.04.07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Impressao do corpo do relatorio                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Static Function Imprel()




cQuery	:=	" SELECT DISTINCT SA1010.A1_COD,SA1010.A1_NREDUZ,SA1010.A1_RISCO,SA1010.A1_TIPO,SA1010.A1_VEND,SA3010.A3_NREDUZ  "
cQuery	+=  "FROM         SC6010 AS SC6010_1 INNER JOIN"                  
cQuery	+=  "             SC5010 ON SC6010_1.C6_NUM = SC5010.C5_NUM INNER JOIN"    
cQuery	+=  "             SA1010 ON SC5010.C5_CLIENTE = SA1010.A1_COD INNER JOIN SA3010 ON SC5010.C5_VEND1 = SA3010.A3_COD  "
cQuery	+=  "             WHERE     (SC6010_1.C6_PRODUTO <> '+"+MV_PAR05+"') AND (SC5010.C5_NATUREZ = '0000') AND (SC6010_1.C6_TES = '526') AND"                                                                                  
cQuery	+=  "             (SC5010.C5_EMISSAO >= '"+DTOS(MV_PAR01)+"') AND ( SC5010.C5_EMISSAO <= '"+DTOS(MV_PAR02)+"' ) OR "                                                                                 
cQuery	+=  "             (SC6010_1.C6_TES = '521')    "                                                                                                  
cQuery	+=  "  ORDER BY  SA1010.A1_NREDUZ  "
cQuery := ChangeQuery(cQuery)

dbUseArea(.T., 'TOPCONN', TCGenQry(,,cQuery), 'Query', .F., .F.)
dbSelectArea("Query")
Query->(dbGoTop())
SetRegua(LastRec())

IncRegua()

If li > 55
	li := Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18) //Impressao do cabecalho
	li++
EndIf
      

Do While !EOF()
	//cQuebra     := Query->     //QUEBRA POR Cliente
	
    If li > 55
	   li := Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18) //Impressao do cabecalho
   	   li++
    EndIf
    
   	
	@ li , 000 PSAY "Artigo: " + MV_PAR05
	
	
	li++
	
	
	li:=li+1 
	
	@ li , 000 PSAY "Cliente              Risco       Tipo      Representante       "
	@ li , 000 PSAY "____________________________________________________________________________________________________________________________________"
		
		
While !EOF() //.and. cQuebra == Query->C5_CLIENTE 						// QUEBRA POR Cliente
	
	
	li++
	
	If li > 55
		li := Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18) //Impressao do cabecalho
		li++
	EndIf
	
	
	@ li , 000 PSAY Query->A1_NREDUZ
	@ li , 025 PSAY Query->A1_RISCO
	@ li , 033 PSAY Query->A1_TIPO
	@ li , 045 PSAY Query->A3_NREDUZ
 
	
	dbSkip()
	
Enddo
		    
		    
	    		   
			li:=li+4
        	@ li , 000 PSAY "====================================================================================================================================" 		
			li:=li+5
			li:= 56
    
EndDo
        
DBCLOSEAREA("query")


dbCommitAll()
Set Device to Screen

If aReturn[5] == 1
	Set Printer To
	ourspool(wnrel) // Chamada do Spool de Impressao
Endif
MS_FLUSH() 			// Libera fila de relatorios em spool

Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³VALIDPERG º Autor ³ AP5 IDE            º Data ³  13/04/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Verifica a existencia das perguntas criando-as caso seja   º±±
±±º          ³ necessario                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
/*
Static Function ValidPerg

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,6)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Da Data                ?","Da Data                ?","Da Data                ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Ate a Data             ?","Ate a Data             ?","Ate a Data             ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Do Cliente  ?","Do Cliente  ?  ?","Do Cliente  ?  ?","mv_ch1","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Ate o Cliente  ?","Ate o Cliente ?","Ate o Cliente ?","mv_ch2","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Produto  ?","Produto ?","Produto ?","mv_ch1","C",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})


For i := 1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return    */

      
  











