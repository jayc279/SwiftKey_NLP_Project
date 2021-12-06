shinyUI(fluidPage(
	navbarPage("Swiftkey - Next Word Prediction",
		tabPanel("Shiny App",
	    	width=6 ,uiOutput("topPanel") ,p(),
			tags$textarea(id="str", rows=6, cols=50, "Thank you for ") ,p(),
        	uiOutput("pred") ,p(),
        	sliderInput("n", "Select number of words to predict:",
				value=8,min=1,max=25, step=1)
		),
		tabPanel("About Model", includeMarkdown("docs/about_model.Rmd")),
		tabPanel("About Data", includeMarkdown("docs/about_data.Rmd"))
	)
))
