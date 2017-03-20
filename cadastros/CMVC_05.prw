#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'
#INCLUDE "MSGRAPHI.CH"

User Function CMVC_05()
Local oBrowse
Static oGrafBar

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZB5')
	oBrowse:SetDescription('Cadastro de Turma x Aluno')
	oBrowse:Activate()
Return

Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.CMVC_05' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.CMVC_05' OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.CMVC_05' OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.CMVC_05' OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.CMVC_05' OPERATION 8 ACCESS 0
ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.CMVC_05' OPERATION 9 ACCESS 0

Return aRotina

Static Function ModelDef()
Local oModel := FWLoadModel("CMVC_04")
Local oStruZB7 := FWFormStruct(1,"ZB7")
Local aAux 

	aAux :=	FwStruTrigger( "ZB7_NOTA"     ,; // Campo Dominio
							"LEGENDA"     ,; // Campo de Contradominio
							"U_LEGENDA()") // Regra de Preenchimento
		
	oStruZB7:AddField('Legenda', 'Legenda', 'LEGENDA', 'C', 20, 0, ,, {}, .F., ;
	FWBuildFeature( STRUCT_FEATURE_INIPAD, "'BR_AZUL.BMP'"), .F., .F., .T., , )
	
	oStruZB7:AddTrigger( ;
		aAux[1]  , ;  		// [01] Id do campo de origem
		aAux[2]  , ;  		// [02] Id do campo de destino
		aAux[3]  , ;  		// [03] Bloco de codigo de validação da execução do gatilho
		aAux[4]  )    		// [04] Bloco de codigo de execução do gatilho
	
	oModel:addGrid('DETAILZB7','DETAILZB6',oStruZB7)

	oModel:getModel('DETAILZB7'):SetDescription('Dados das Notas do Aluno')
	
	oModel:SetRelation("DETAILZB7", ;
						{{"ZB7_FILIAL",'xFilial("ZB7")'},;
						 {"ZB7_CODTUR","ZB6_CODTUR"  },;
						 {"ZB7_RA","ZB6_RA"}}, ;
						ZB7->(IndexKey(1)))
	
	oModel:AddCalc( 'CALC_NOTA', 'DETAILZB6', 'DETAILZB7', 'ZB7_NOTA', 'MEDIA', 'AVERAGE', /*bCondition*/, /*bInitValue*/,'Media' /*cTitle*/, /*bFormula*/)
		
Return oModel

Static Function ViewDef()
Local oModel := ModelDef()
Local oView
Local oStrZB5:= FWFormStruct(2, 'ZB5')	 
Local oStrZB6:= FWFormStruct(2, 'ZB6')  
Local oStr2:= FWCalcStruct( oModel:GetModel('CALC_ALUNO') ) 
Local oStr4:= FWCalcStruct( oModel:GetModel('CALC_NOTA') ) 
Local oStruZB7:= FWFormStruct(2, 'ZB7')
	
	oStruZB7:AddField( 'LEGENDA','01','Legenda','Legenda',, 'Get' ,'@BMP',,,.F.,,,,,,.T.,, )
	
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	oView:AddField('FORM_TURMA' , oStrZB5,'MASTERZB5' )
	oView:AddGrid('FORM_ALUNOS' , oStrZB6,'DETAILZB6')
	oView:AddGrid('FORM_NOTA' , oStruZB7,'DETAILZB7')
	oView:AddOtherObject('OTHER_GRAFICO',{|oPanel| CriaGrafico(oPanel)},{|| }) 
	
	oView:AddField('CALC2', oStr4,'CALC_NOTA')
	oView:AddField('CALC1', oStr2,'CALC_ALUNO')
	
	oView:CreateHorizontalBox( 'BOX_FORM_TURMA', 36)	
	oView:CreateHorizontalBox( 'BOX_FOLDER', 64)
		
	oView:CreateFolder( 'FOLDER', 'BOX_FOLDER')
	
	oView:AddSheet('FOLDER','SHEET_ALUNO','Alunos')
	oView:CreateHorizontalBox( 'BOX_FORM_ALUNOS', 100, /*owner*/, /*lUsePixel*/, 'FOLDER', 'SHEET_ALUNO')
	
	oView:AddSheet('FOLDER','SHEET_NOTAS','Notas')
	oView:CreateHorizontalBox( 'BOX_NOTA', 100, /*owner*/, /*lUsePixel*/, 'FOLDER', 'SHEET_NOTAS')
	
	oView:AddSheet('FOLDER','SHEET_CALC','Analises')
	oView:CreateHorizontalBox( 'BOX_ANALISES', 100, /*owner*/, /*lPixel*/, 'FOLDER', 'SHEET_CALC')
	
	oView:CreateVerticalBox( 'BOX_GRAFICO', 60, 'BOX_ANALISES', /*lUsePixel*/, 'FOLDER', 'SHEET_CALC')
	oView:CreateVerticalBox( 'BOX_CALC', 40, 'BOX_ANALISES', /*lPixel*/, 'FOLDER', 'SHEET_CALC')
	oView:CreateHorizontalBox( 'BOX_CALC_ALUNO', 46, 'BOX_CALC', /*lUsePixel*/, 'FOLDER', 'SHEET_CALC')
	oView:CreateHorizontalBox( 'BOX_CALC_NOTA', 54, 'BOX_CALC', /*lUsePixel*/, 'FOLDER', 'SHEET_CALC')

	oView:SetOwnerView('FORM_NOTA','BOX_NOTA')
	oView:SetOwnerView('CALC2','BOX_CALC_NOTA')
	oView:SetOwnerView('CALC1','BOX_CALC_ALUNO')	
	oView:SetOwnerView('FORM_ALUNOS','BOX_FORM_ALUNOS')
	oView:SetOwnerView('FORM_TURMA','BOX_FORM_TURMA')
	oView:SetOwnerView('OTHER_GRAFICO','BOX_GRAFICO')

	oView:EnableTitleView('FORM_TURMA' , 'Turma' ) 
			
	oView:AddUserButton('Incluir Aluno','',{|oView|NovoAluno(oView)},'Inclui um novo aluno',/*nShortCut*/,{MODEL_OPERATION_INSERT, MODEL_OPERATION_UPDATE})
	
	oView:SetFieldAction( 'ZB7_NOTA', { |oView, cIDView, cField, xValue| GraRefresh() } )
	oView:SetViewAction( 'DELETELINE'  , { |oView| GraRefresh() } )
	oView:SetViewAction( 'UNDELETELINE', { |oView| GraRefresh() } )
	oView:SetViewProperty('FORM_ALUNOS' , 'ENABLEDGRIDDETAIL' , {70} ) 
	
	oView:SetVldFolder({ |cFolderID,nOldSheet, nSelSheet| vldFolder(cFolderID,nOldSheet, nSelSheet) })

	oView:SetProgressBar(.T.)
	
Return oView

Static Function CriaGrafico(oPanel, lReDraw)
Local oModel	 := FWModelActive()
Local oModelNotas  := oModel:GetModel('DETAILZB7')
Local nI
Local nNotaGeral := 0
Local aMedia := {}
Local cDisc
Local nNotaDisc
Local nPos

Default lReDraw := .F.

FWSaveRows()

For nI := 1 To oModelNotas:Length()
	oModelNotas:GoLine(nI)
	If !oModelNotas:IsDeleted()
		nNotaDisc := oModelNotas:GetValue("ZB7_NOTA")
		cDisc := oModelNotas:GetValue("ZB7_CODDIS")
	
		nNotaGeral += nNotaDisc
		
		nPos := aScan(aMedia, {|x| x[1] == cDisc})
		
		If nPos == 0
			aAdd(aMedia, {cDisc, nNotaDisc, oModelNotas:GetValue('ZB7_DESDIS')} )
		Else
			aMedia[nPos][2] += nNotaDisc
		EndIf
	EndIf
Next

If !lReDraw
	oGrafBar := FWChartFactory():New()
	oGrafBar := oGrafBar:GetInstance( BARCHART )
	oGrafBar:Init( oPanel, .F., .F. )
	oGrafBar:SetMaxY( 5 )
	oGrafBar:SetTitle( "Media das Notas por Disciplina", CONTROL_ALIGN_CENTER )
	oGrafBar:SetLegend( CONTROL_ALIGN_RIGHT )
Else
	oGrafBar:Reset()
EndIf

For nI:=1 to Len(aMedia)
	oGrafBar:addSerie( aMedia[nI][3]    , aMedia[nI][2] )
Next nI 

oGrafBar:build()

FWRestRows()

Return

Static Function GraRefresh()
CriaGrafico( oGrafBar:oOwner, .T. )
Return NIL

Static Function vldFolder(cFolderID,nOldSheet, nSelSheet)
Local lValid := .T.
Local oModel := FWModelActive()
Local oModelZB6	
	
	// Quando selecionada a aba 2 (Notas) na pasta FOLDER
	If cFolderID == "FOLDER" .And. nSelSheet == 2
		oModelZB6 := oModel:GetModel("DETAILZB6")
		If oModelZB6:IsEmpty()
			lValid := .F.
			Help( ,, 'HELP',, 'Inclua Alunos antes de incluir notas para o aluno.', 1, 0)
		EndIf	
	EndIf
	
Return lValid