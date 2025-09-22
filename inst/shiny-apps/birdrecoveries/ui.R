library(leaflet)
library(DT)
library(shinydashboard)
library(shinyjs)

	dbHeader <- dashboardHeader(

		titleWidth = 450,
		title = "Återfynd - Swedish Bird Recoveries", disable = FALSE,

		# tags$li(a(href = 'https://www.nrm.se/faktaomnaturenochrymden/djur/faglar/fagelringar.1289.html',
		# 		img(src = "birds.png", height = 30, width = 30),
		# 		title = "Ring!",
		# 		style = "padding-top:10px; padding-bottom:10px;"),
		# 	class = "dropdown"),
		# tags$li(a(href = 'https://www.nrm.se/RC',
		# 		 img(src = 'logo.png', height = 50, width = 50),
		# 		title = "Ringmärkningscentralen",
		# 		style = "padding-top:10px; padding-bottom:10px;"),
		# 	class = "dropdown")

		tags$li(a(href = 'https://www.nrm.se/RC',
							"Länk till Ringmärkningscentralen",
							style = "padding-top:10px; padding-bottom:10px"),
							class= "dropdown")

		# tags$li(a(href = 'https://nrm.se',
		# 		img(src = "nrm-logo-white.png", height = 40, width = 40),z
		# 		title = "Swedish Museum of Natural History / Naturhistoriska Riksmuseet",
		# 		style = "padding-top:10px; padding-bottom:10px;"),
		# 	class = "dropdown")
	)

function(request) {

	body2 <- dashboardBody(

		tabItems(
			tabItem(
				tabName = 'menu1'
				, tags$a(
					id = "mydiv", href = "#", 'click me',
					onclick = 'Shiny.onInputChange("mydata", Math.random());')
			),
			tabItem(
				tabName = 'menu2'
				, uiOutput('birdmap')
			)
		)
	)

	dashBody <- dashboardBody(

		#tags$style(type = "text/css", "#birdmap {height: calc(100vh - 120px) !important;}"),
		tags$head(
		tags$style(type = "text/css", "#mapbox { height: 80vh !important; }"),
		tags$style(type = "text/css", "#birdmap { height: 75vh !important; }")),
	#	tags$style(type = "text/css", "#tabset1 { height: 80vh !important; }"),
	#	uiOutput("body_UI"),
				useShinyjs(),
		uiOutput("tab_box")
	)

	dashboardPage(

		dbHeader,
	#	dashboardHeader(titleWidth = 450, title = "Återfynd - Swedish Bird Recoveries", disable = FALSE),
		dashboardSidebar(width = 450,
			uiOutput("lang"),
			hr(),
			#sidebarMenuOutput("menu_tabs_ui"),
			#hr(),
			flowLayout(
				uiOutput("species"),
				uiOutput("country")
			),
			hr(),
			flowLayout(
				uiOutput("months"),
				uiOutput("years")
			),
			hr(),
			flowLayout(
				uiOutput("lats"),
				uiOutput("lons")
			),
			hr(),
			flowLayout(
				uiOutput("source")
				# hidden(uiOutput("source"))
			##	bookmarkButton()
			)
		),
		dashBody
	)
}


body2 <- dashboardBody(
	tabItems(
		tabItem(
			tabName = 'menu1'
			, tags$a(
				id = "mydiv", href = "#", 'click me',
				onclick = 'Shiny.onInputChange("mydata", Math.random());')
		),
		tabItem(
			tabName = 'menu2'
			, uiOutput('birdmap')
		)
	)
)

# IE:	adding 'matotomo tracking-id'
dashBody <- dashboardBody(

	tags$head(
		tags$style(HTML("
        .skin-blue .main-header .navbar {
          background-color: #5499c7    ;
        }
        .skin-blue .main-header .logo {
          background-color: #1a5276 ;
        }
        .skin-blue .main-sidebar {
          background-color: #283747 ;
        }
      "))
		),

	#tags$style(type = "text/css", "#birdmap {height: calc(100vh - 120px) !important;}"),
	tags$head(
  tags$head(includeHTML(("matomo7april.html"))),
	tags$style(type = "text/css", "#mapbox { height: 80vh !important; }"),
	tags$style(type = "text/css", "#birdmap { height: 75vh !important; }")),
#	tags$style(type = "text/css", "#tabset1 { height: 80vh !important; }"),
#	uiOutput("body_UI"),
	uiOutput("tab_box")
)

dashboardPage(

	dbHeader,
	dashboardSidebar(width = 450,
		uiOutput("lang"),
		hr(),
		#sidebarMenuOutput("menu_tabs_ui"),
		#hr(),
		flowLayout(
			uiOutput("species"),
			uiOutput("country")
		),
		hr(),
		flowLayout(
			uiOutput("months"),
			uiOutput("years")
		),
		hr(),
		flowLayout(
			uiOutput("lats"),
			uiOutput("lons")
		),
		hr(),
		flowLayout(
			uiOutput("source")
		)
	),
	dashBody

)
