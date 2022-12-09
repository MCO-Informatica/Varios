#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

User Function PMSA600PV()

    Local _cProjet	:= AF9->AF9_PROJET
    Local _cRevisa	:= AF9->AF9_REVISA
    Local _cTarefa	:= Alltrim(AF9->AF9_TAREFA)
    Local _lPassou	:= .F.
    Local _aArea	:= GetArea()

    If !_lPassou
        M->C5_XMENNOT 	:=	AF9->AF9_DESCRI
        M->C5_MENNOTA 	:=	Iif(!Empty(AF9->AF9_XNUMPO),"PEDIDO DE COMPRA: " + AF9->AF9_XNUMPO + "  ITEM: " + AF9->AF9_XITEPO,"")
        M->C5_TRANSP	:=	"000008" //---->NOSSO CARRO
        M->C5_NATUREZ	:=	AF9->AF9_XNAT
        M->C5_ESTPRES	:=	Posicione("AF8",1,xFilial("AF8")+_cProjet,"AF8_EST")
        M->C5_MUNPRES	:=	Posicione("AF8",1,xFilial("AF8")+_cProjet,"AF8_CODMUN")
        M->C5_DESCMUN	:=	Posicione("AF8",1,xFilial("AF8")+_cProjet,"AF8_MUN")
        M->C5_RECISS	:=	'1'
        M->C5_XTIPONF	:=	AF9->AF9_XTIPNF
        _lPassou := .T.
    Endif

    For _nY := 1 to Len(aCols)

        //----> DEFINE O CFOP
        _aDadosCFO := {}
        Aadd(_aDadosCfo,{"OPERNF","S"})
        Aadd(_aDadosCfo,{"TPCLIFOR",Posicione("SA1",1,xFilial("SA1")+AF8->AF8_CLIENT+AF8->AF8_LOJA,"A1_TIPO")})
        Aadd(_aDadosCfo,{"UFDEST"  ,Posicione("SA1",1,xFilial("SA1")+AF8->AF8_CLIENT+AF8->AF8_LOJA,"A1_EST")})

        //----> VERIFICA SE FATURA PERMITE DEDUCAO DE MATERIAL NA BASE DE CALCULO DE INSS/ISS
        If AF9->AF9_XFATMA = "S"
            aCols[_nY][09] := (aCols[_nY][8] * (AF9->AF9_XPERMA/100))      	//C6_ABATMAT
            aCols[_nY][10] := (aCols[_nY][8] * (AF9->AF9_XPERMA/100))      	//C6_ABATINS
        Endif

        //----> VERIFICA SE FATURA NAO PERMITE DEDUCAO DE MATERIAL NA BASE DE CALCULO DO ISS
        If AF9->AF9_XFATIS = "N"
            aCols[_nY][09] := 0		//C6_ABATMAT
        Endif

        aCols[_nY][14] := AF9->AF9_XTES
        aCols[_nY][15] := MaFisCfo(,Posicione("SF4",1,xFilial("SF4")+AF9->AF9_XTES,"F4_CF"),_aDadosCfo)
        aCols[_nY][16] := Posicione("SB1",1,xFilial("SB1")+aCols[_nY][2],"B1_CODISS")

    Next

    RestArea(_aArea)

Return