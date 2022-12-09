#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "TbiConn.ch"


User Function TMata260()

Local aAuto := {}
Local cDocumento := GetSxENum("SD3","D3_DOC",1)
Private lMsErroAuto := .F.

aAdd(aAuto,{cDocumento,ddatabase})

aAdd(aAuto, {"061230110503 ",; //1 Prod.Orig.
"EMB ",; //2 Desc.Orig.
"CX",; //3 UM Orig.
"300",; //4 Armazem Or
"",; //5 Endereco O
"061230110503 ",; //6 Prod.Desti
"EMB ",; //7 Desc.Desti
"CX",; //8 UM Destino
"350",; //9 Armazem De
"",; //10 Endereco D
"",; //11 Numero Ser
"",; //12 Lote
"",; //13 Sub-Lote
ddatabase,;	//14 Validade
000.00,; //15 Potencia
10.0,; //16 Quantidade
10.0,; //17 Qt 2aUM
"",; //18 Estornado
"",; //19 Sequencia
"",; //20 Lote Desti
ddatabase,;	//21 Validade D
""}) //22 Item Grade





MSExecAuto({|x,y| mata261(x,y)},aAuto,3)//inclusão
If lMsErroAuto
ConOut("Erro na inclusao!")
MostraErro()
EndIf
//
Return !lMsErroAuto