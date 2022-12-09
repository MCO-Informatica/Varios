User Function MT410TOK()

    Local _aArea := GetArea()

    _cArmFIL	:=	Subs(cFilAnt,3,2)+"A1"
    _cArmSC5	:=	M->C5_X_ARMAZ
    _aArea		:=	GetArea()
    _lRet		:=	.t.
    _cDescAmz	:=	""
    _cTipoPag	:=	Posicione("SE4",1,xFilial("SE4")+M->C5_CONDPAG,"E4_TIPO")
    _cFormaPg	:=	M->C5_FORMAPG
    _nValMerc   :=  0
    _nValKit    :=  0
    _nX         :=  0

    If _cArmSC5 == "01A1"
        _cDescAmz	:=	"LOOK LOG"
    ElseIf _cArmSC5 == "02A1"
        _cDescAmz	:=	"ALPHAVILLE"
    ElseIf _cArmSC5 == "03A1"
        _cDescAmz	:=	"FABRICA"
    ElseIf _cArmSC5 == "07A1"
        _cDescAmz	:=	"RIO DE JANEIRO"
    ElseIf _cArmSC5 == "08A1"
        _cDescAmz	:=	"RECIFE"
    ElseIf _cArmSC5 == "09A1"
        _cDescAmz	:=	"SOROCABA"
    ElseIf _cArmSC5 == "10A1"
        _cDescAmz	:=	"UBERLANDIA"
    ElseIf _cArmSC5 == "11A1"
        _cDescAmz	:=	"CAMPINAS"
    ElseIf _cArmSC5 == "13A1"
        _cDescAmz	:=	"BAURU"
    ElseIf _cArmSC5 == "14A1"
        _cDescAmz	:=	"PALMAS"
    ElseIf _cArmSC5 == "15A1"
        _cDescAmz	:=	"GOIANIA"
    Else
        _cDescAmz	:=	"NAO EXISTE ESTOQUE FISICO NESTE LOCAL"
    EndIf

    If INCLUI
        If _cArmFIL <> _cArmSC5
            If MsgYesNo("Tem certeza que o pedido será entregue pelo ARMAZÉM "+_cArmSC5+" "+_cDescAmz+"?","Validação Armzém")
                _lRet	:=	.t.
            Else
                _lRet	:=	.f.
            EndIf
        EndIf
    EndIf

    If _cTipoPag$"9"
        If M->C5_DATA1 < dDataBase .or. M->C5_PARC1 <= 0
            MsgAlert("Condição de Pagamento Negociada. É necessário preencher os valores e vencimentos.")
            _lRet	:=	.f.
        EndIf
    Else
        _lRet	:=	.t.
    EndIf

    If _cFormaPg$"CC/CD"
        If Empty(M->C5_X_AUTOR) .OR. Empty(M->C5_X_TERMI)
            MsgAlert("Os dados da autorização e terminal não foram preenchidos para pagamento com cartão de crédito/débito.")
            _lRet	:=	.f.
        EndIf
    Else
        _lRet	:=	.t.
    EndIf

    If M->C5_VENDE$"3" .And. Empty(M->C5_PEDECOM)
        MsgAlert("A origem do pedido é E-COMMERCE, portanto é necessário preencher o número do pedido de origem (VTEX/OLIST).")
        _lRet	:=	.f.
    Else
        _lRet	:=	.t.
    EndIf

    /*
    //----> VALIDA OS VALORES DOS KITS
    For _nX := 1 to Len(aCols)

        If _nX > 1
            If aCols[_nX,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_X_KIT"})]$"S" .And. aCols[_nX-1,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_X_PRKIT"})] == aCols[_nX,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_X_PRKIT"})]
                If aCols[_nX,Len(aHeader)+1]
                    _nValKit    += aCols[_nX,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_VALOR"})]
                EndIf        
                If !aCols[_nX,Len(aHeader)+1]                    
                    _nValMerc   += aCols[_nX,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_VALOR"})]
                EndIf
            EndIf
        Else
            If aCols[_nX,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_X_KIT"})]$"S"
                If aCols[_nX,Len(aHeader)+1]
                    _nValKit    += aCols[_nX,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_VALOR"})]
                EndIf
                If !aCols[_nX,Len(aHeader)+1]        
                    _nValMerc   += aCols[_nX,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_VALOR"})]
                EndIf
            EndIf
        EndIf
        
        If _nValMerc <> _nValKit
            _lRet := .f.
            _nValKit := 0
            _nValMerc:= 0
            MsgStop("Existe algum produto a mais ou a menos nos kits promocionais. Favor revisar o pedido no KIT "+aCols[_nX,Ascan(aHeader, {|x| Alltrim(x[2]) == "C6_X_PRKIT"})])
        EndIf

    Next _nX
    */
    
    RestArea(_aArea)

Return(_lRet)
