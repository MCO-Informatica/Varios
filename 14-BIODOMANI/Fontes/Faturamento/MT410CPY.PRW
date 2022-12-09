User Function MT410CPY()

    Local _aArea := GetArea()

    _aArea		:=	GetArea()
    _lRet		:=	.t.

    M->C5_X_USERS := CUSERNAME

    RestArea(_aArea)

Return(_lRet)