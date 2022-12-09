#INCLUDE "RWMAKE.CH"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO5     ºAutor  ³Rafael Alencar      º Data ³  06/28/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Planejamento Estrategico                                  º±±
±±º          ³  Contrato de Performance                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Renova                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function brw00001()

Private cCadastro := "Cadastro de Exemplo"
Private cAlias 	  := "SZ4" 
Private aRotina   := { }  
//Local aCabVar     := {}
//Local aCab        := {}
AADD (aRotina, {"Pesquisar" , "AxPesqui",0,1})
AADD (aRotina, {"Visualizar" ,"U_Md2",0,2})
AADD (aRotina, {"Incluir" , "U_Md2",0,3})
AADD (aRotina, {"Alterar" , "U_Md2",0,4})
AADD (aRotina, {"Excluir" , "U_Md2",0,5})

dbSelectArea("SZ4")
dbSetOrder(1)
mBrowse ( 6, 1,22 ,75 ,cAlias)

Return
    
User Function Md2()
Local nOpc := 3

//+-----------------------------------------------+
//¦ Montando aHeader para a Getdados              ¦
//+-----------------------------------------------+

dbSelectArea("Sx3")
dbSetOrder(1)
dbSeek("SZ4")
nUsado:=0
aHeader:={}
While !Eof() .And. (x3_arquivo == "SZ4")
    IF X3USO(x3_usado) .AND. cNivel >= x3_nivel
        nUsado:=nUsado+1
        AADD(aHeader,{ TRIM(x3_titulo), x3_campo ,;
           x3_picture,x3_tamanho,x3_decimal, ,;
           x3_usado,;
           x3_tipo, x3_arquivo, x3_context } )
    Endif
    dbSkip()
End     

//+-----------------------------------------------+
//¦ Montando aCols para a GetDados               ¦
//+-----------------------------------------------+

aCols:={}

            M->Z4_FUNC := SZ4->Z4_FUNC
           M->Z4_CARGO :=SZ4->Z4_CARGO
           M->Z4_DEPTO := SZ4->Z4_DEPTO

IF nOpc == 3 // Inclusão
        AAdd (aCols, Array (Len(aHeader) + 1))
        For i := 1 to Len (aHeader)
         aCols [1] := Criavar (aHeader [2])
        Next
         aCols [1] [Len (aHeader) +1] := .F.
Else   // Alteração
            
         dbSelectArea(cAlias)
          dbSetOrder(1)        
          dbSeek(xFilial(cAlias) + M->Z4_FUNC)
         While !EOF() .And. (cAlias)->(Z4_Filial+Z4_FUNC) == xFilial(cAlias) + M->Z4_FUNC
          
               dbSkip()
               
               End

     AAdd (aCols, Array (Len(aHeader) + 1))
     For i := 1 To Len(aHeader)
    If aHeader [10] == "R"
    aCols[1] := FieldGet(FieldPos(aHeader[2]))
    Else
       aCols[1] := CriaVar(aHeader[2], .T.)
    Endif
Next
         aCols [1] [Len (aHeader) +1] := .F. 
Endif        

//+----------------------------------------------+
//¦ Variaveis do Cabecalho do Modelo 2           ¦
//+----------------------------------------------+

cFunc    := SZ4->Z4_FUNC
cCargo   := SZ4->Z4_CARGO
cDepto   := SZ4->Z4_DEPTO

//+----------------------------------------------+
//¦ Variaveis do Rodape do Modelo 2
//+----------------------------------------------+

//nLinGetD:=0

cMeta 		:= SZ4->Z4_METAS
cPeso       := SZ4->Z4_PESO
cMetrica    := SZ4->Z4_METRICA
cAcima	  	:= SZ4->Z4_ACIMA
cAlvo		:= SZ4->Z4_ALVO
cAbaixo		:= SZ4->Z4_ABAIXO

//+----------------------------------------------+
//¦ Titulo da Janela                             ¦
//+----------------------------------------------+ 

cTitulo:="CONTRATO DE PERFORMANCE"       

//+----------------------------------------------+
//¦ Array com descricao dos campos do Cabecalho ¦
//+----------------------------------------------+

aC := {cVariavel, {nLin, nCol}, cTitulo, cPicture, Funçao_valida, F3, IEditavel}
aC:={}
//#IFDEF WINDOWS
AADD(aC,{"cfunc" ,{15,10} ,"Colaborador","@!", , ,})
AADD(aC,{"cCargo"    ,{15,80},"Cargo","@!",,"SZ4",})
AADD(aC,{"cDepto"    ,{15,300} ,"Departamento",,,,})
//#ENDIF

//+-------------------------------------------------+
//¦ Array com descricao dos campos do Rodape        ¦
//+-------------------------------------------------+

aR:={}
//#IFDEF WINDOWS
AADD(aR,{"cMeta" ,{100,10} ,"Metas","@!", ,"SZ4",})
AADD(aR,{"cPeso"      ,{20,80},"Peso","@!",,,})
AADD(aR,{"cMetrica"       ,{20,100} ,"Metrica","@!",,,})
//AADD(aR,{"cAcima"             ,{20,160} ,"Acima","@!",,,})
//AADD(aR,{"cAlvo"			      ,{20,230 ,"Alvo","@!",,,})
//AADD(aR,{"cAbaixo"				      ,{20,300 ,"Abaixo","@!",,,})	
//#ENDIF

//+------------------------------------------------+
//¦ Array com coordenadas da GetDados no modelo2   ¦
//+------------------------------------------------+
#IFDEF WINDOWS
   aGetdados:={44,5,118,315}

#ELSE
   aGetdados:={10,04,15,73}
#ENDIF

//+----------------------------------------------+
//¦ Chamada da Modelo2                           ¦
//+----------------------------------------------+
//lRet = .t. se confirmou
//lRet = .f. se cancelou

lRet:=Modelo2(cTitulo,aC,aR,aGetdados,nOpc,"Allwaystrue()","Allwaystrue()", , ) 
//Modelo2 ( cTitulo [ aC ] [ aR ] [ aGd ] [ nOp ] [ cLinhaOk ] [ cTudoOk ]aGetsD [ bF4 ] [ cIniCpos ] [ nMax ] [ aCordW ] [ lDelGetD ] [ lMaximazed ] [ aButtons ] )
       
Return