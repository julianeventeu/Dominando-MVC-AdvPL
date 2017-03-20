#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'

User Function CMVC_04()
Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZB5')
	oBrowse:SetDescription('Cadastro de Turma x Aluno')
	oBrowse:Activate()
Return

Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.CMVC_04' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.CMVC_04' OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.CMVC_04' OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.CMVC_04' OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.CMVC_04' OPERATION 8 ACCESS 0
ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.CMVC_04' OPERATION 9 ACCESS 0

Return aRotina

Static Function ModelDef()
Local oModel
Local oStruZB5 := FWFormStruct(1,"ZB5")
Local oStruZB6 := FWFormStruct(1,"ZB6")

	oModel := MPFormModel():New("MD_TURMA_ALUNO")
	oModel:SetDescription("Cadastro de Turma x Aluno")
	
	oModel:addFields('MASTERZB5',,oStruZB5,,{|oFieldZB5| TurmaPosValid(oFieldZB5)})
	oModel:addGrid('DETAILZB6','MASTERZB5',oStruZB6,{|oGrid,nLine,cAction| LinePreAluno(oGrid,nLine,cAction)},{|oGrid| AlunoLinePos(oGrid)})
	
	oModel:getModel('MASTERZB5'):SetDescription('Dados da Turma')
	oModel:getModel('DETAILZB6'):SetDescription('Dados do Aluno')
	
	oModel:SetRelation("DETAILZB6", ;
						{{"ZB6_FILIAL",'xFilial("ZB6")'},;
						 {"ZB6_CODTUR","ZB5_CODTUR"  }}, ;
						ZB6->(IndexKey(1)))
						
	oModel:AddCalc( 'CALC_ALUNO', 'MASTERZB5', 'DETAILZB6', 'ZB6_RA', 'CALC_ALUNO', 'COUNT', /*bCondition*/, /*bInitValue*/,'Número de alunos da Turma' /*cTitle*/, /*bFormula*/)
			
Return oModel

Static Function ViewDef()
Local oModel := ModelDef()
Local oView
Local oStrZB5:= FWFormStruct(2, 'ZB5')	 
Local oStrZB6:= FWFormStruct(2, 'ZB6', {|cField| AllTrim(Upper(cField)) $ "ZB6_RA" })  
Local oStr2:= FWCalcStruct( oModel:GetModel('CALC_ALUNO') )  

	
	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	oView:AddField('FORM_TURMA' , oStrZB5,'MASTERZB5' )
	oView:AddGrid('FORM_ALUNOS' , oStrZB6,'DETAILZB6')	
	oView:AddField('CALC1', oStr2,'CALC_ALUNO')
	
	oView:CreateHorizontalBox( 'BOX_FORM_TURMA', 19)
	oView:CreateHorizontalBox( 'BOX_FORM_ALUNOS', 44)
	
	oView:CreateHorizontalBox( 'BOX_CALCS', 37)
	oView:CreateVerticalBox( 'BOX_CALC_ALUNO', 100, 'BOX_CALCS')
	
	oView:SetOwnerView('CALC1','BOX_CALC_ALUNO')	
	oView:SetOwnerView('FORM_ALUNOS','BOX_FORM_ALUNOS')
	oView:SetOwnerView('FORM_TURMA','BOX_FORM_TURMA')
	
	oView:AddUserButton('Nova Turma','',{ || novaTurma()})
	
Return oView

Static Function TurmaPosValid(oField)
Local lValid := .T.
Local cDescr := oField:GetValue("ZB5_DESTUR")

	If "TURMA" $ Upper(cDescr)
		Help( ,, 'HELP',, 'A descrição da turma não pode conter o nome "TURMA".', 1, 0)
		lValid := .F.
	EndIf
	
Return lValid

Static Function AlunoLinePos(oGrid)
Local lValid := .T.
Local cRA := oGrid:GetValue("ZB6_RA")

	If IsAlpha(cRA)
		Help( ,, 'HELP',, 'O RA do aluno não pode iniciar com uma letra.', 1, 0)
		lValid := .F.
	EndIf

Return lValid 

Static Function LinePreAluno(oGrid,nLine,cAction)
Local lValid := .T.
	
	If cAction == "UNDELETE"
		Help( ,, 'HELP',, 'Não é possivel desfazer a deleção de um Aluno da turma.', 1, 0)
		lValid := .F.
	EndIf	
	
Return lValid

Static Function novaTurma()
Local aButtons := {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,"Salvar"},{.T.,"Cancelar"},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil},{.T.,Nil}}

FWExecView('Nova Turma','CMVC_01', MODEL_OPERATION_INSERT, , { || .T. }, , ,aButtons )

Return
