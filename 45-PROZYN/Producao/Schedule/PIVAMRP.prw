#INCLUDE "protheus.ch"
#include 'TBICONN.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³PIVAMRP		ºAutor  ³Guilherme C.    º Data ³  09/09/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Schedule MRP (Utilizado em menu)		    				  º±±
±±º          ³                											  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Diário	                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß 
*/

User Function PIVAMRP()

//Local _cParGer	:= 	AllTrim(SUPERGetMv("ML_MRPGEPR"))  	// Gera/Nao Gera OPs e SCs depois do calculo da necessidade.
Local lBatch    	:= 	.T.  	// Identifica MRP rodado em modo Batch
Local nTipoPer  	:= 	 2  	// Tipo de periodo 1=Diario;2=Semanal;3=Quinzenal;4=Mensal;5=Trimestral;6=Semestral
Local nPeriodos 	:= 	 4   	// Quantidade de periodos
Local lPedidos  	:= 	.T.  	// Considera Pedidos em Carteira
Local aTipo     	:= 	{}  	// Array contendo Tipos  de produtos a serem considerados (se Nil, assume padrao)
Local aGrupo    	:= 	{}  	// Array contendo Grupos de produtos a serem considerados (se Nil, assume padrao)
Local lGeraOpSc 	:= 	.F.  	// Gera/Nao Gera OPs e SCs depois do calculo da necessidade.
Local lLogMrp   	:= 	.T.  	// Indica se monta log do MRP 
Local cNumOpDig 	:= 	" "		// Numero da Op Inicial

Local dDateIn       := Date()
Local dDateFi       := DaySum(dDateIn,28)
Local nData         := 1

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "PCP"


conout("PIVAMRP Inicio ")

aTipo	:=	{{.F.,'AI'},{.F.,'BN'},{.T.,'EM'},{.F.,'EP'},{.F.,'EQ'},{.F.,'GE'},{.F.,'GG'},{.F.,'GN'},{.F.,'IA'},{.F.,'II'},{.F.,'IN'},{.F.,'KT'},{.F.,'MC'},{.T.,'ME'},{.F.,'MM'},{.F.,'MO'},{.F.,'MO'},{.T.,'MP'},{.F.,'OI'},{.T.,'PA'},{.F.,'PC'},{.T.,'PI'},{.F.,'PP'},{.F.,'PV'},{.F.,'SL'},{.F.,'SM'},{.F.,'SP'},{.F.,'SV'}}
//aTipo	:=	{{.T.,'EM'}}//,{.T.,'ME'},{.T.,'MP'},{.T.,'PA'},{.T.,'PI'}}
//aTipo  := {{"EM", "ME", "MP", "PA", "PI"}}
aGrupo := {{.T., '    '},{.T., '1000'},{.T., '2000'},{.T., '3000'},{.T., '4000'},{.T., '8000'},{.T., '9000'},{.T., '9001'},{.T., '9999'}}
//aGrupo	:=	{{.T.,"0020"}}
For nData := 6 to 0 step -1 

	If Dow(dDateIn) <> 2    // Se for segunda
		dDateIn := daySub(dDateIn,1)
	Else
        dDateIn := dDateIn
    EndIf

    If Dow(dDateFi) <> 2    // Se for segunda
		dDateFi := daySub(dDateFi,1)
	Else
        dDateFi := dDateFi
    EndIf

Next


Pergunte("MTA712",.T.)
    MV_PAR01        := 1
    MV_PAR02        := 2
    MV_PAR03        := 1
    MV_PAR04        := 2
    MV_PAR05        := dDateIn
    MV_PAR06        := dDateFi
    MV_PAR07        := 2 
    MV_PAR08        := "  "
    MV_PAR09        := "ZZ"
    MV_PAR10        := 1
    MV_PAR11        := 2
    MV_PAR12        := 2
    MV_PAR13        := 2
    MV_PAR14        := 2
    MV_PAR15        := 2
    MV_PAR16        := 2
    MV_PAR17        := 1
    MV_PAR18        := 1
    MV_PAR19        := 1
    MV_PAR20        := 2
    MV_PAR21        := 2
    MV_PAR22        := 2
    MV_PAR23        := "ZZZZZZZZZ"
    MV_PAR24        := "ZZZZZZZZZ"
    MV_PAR25        := 2
    MV_PAR26        := 2
    MV_PAR27        := 1
    MV_PAR28        := 2
    MV_PAR29        := 2
    MV_PAR30        := 1
    MV_PAR31        := 2
    MV_PAR32        := 1
    MV_PAR33        := dDateIn
    MV_PAR34        := dDateFi
    MV_PAR35        := 1


//Início: de Segunda para terça; Fim: de sexta para sábado
MATA712(lBatch, {nTipoPer, nPeriodos, lPedidos, aTipo, aGrupo, lGeraOpSc, lLogMRP, cNumOpDig} )
//MATA712( lBatch, {nTipoPer, nPeriodos, lPedidos, aTipo, aGrupo, 1GeraOpSc, lLogMRP, cNumOpDig} )

conout("PIVAMRP FIM ")

 
Reset Environment



Return
