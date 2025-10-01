library(lubridate)
# deploy to shiny in root context
# ln -s /usr/local/lib/R/site-library/swedishbirdrecoveries/shiny-apps/birdrecoveries/* .
library(swedishbirdrecoveries)
library(leaflet.extras)

# library(DBI)
# library(RSQLite)

data("birdrecoveries_eng")
data("birdrecoveries_swe")
data("birdrecoveries_i18n")

# shinyServer(function(input, output) {

server <- function(input, output, session) {
	# sex <- birds %>% distinct(ringing_sex) %>% .$ringing_sex
	# age <- birds %>% distinct(ringing_age) %>% .$ringing_age
	# code <- birds %>% distinct(recovery_code) %>% .$recovery_code
	cmin <- function(x)
		floor(min(x, na.rm = TRUE))
	cmax <- function(x)
		ceiling(max(x, na.rm = TRUE))

	df <- reactive({
		req(birds())

		b <- birds()

		# message("birds() has ", nrow(b), " rows")

		filter_species <- input$species
		filter_source <- input$source
		filter_lat_min <- input$lats[1]
		filter_lat_max <- input$lats[2]
		filter_lon_min <- input$lons[1]
		filter_lon_max <- input$lons[2]
		filter_country <- input$country
		filter_lang <- input$lang
		filter_years <- input$years
		filter_months <- input$months

		# message(
		# 	"Species: ", filter_species,
		# 	"Source: ", filter_source,
		# 	"Coords lat: ", filter_lat_min, ", ", filter_lat_max,
		# 	"Coords lon:", filter_lon_min, ", ", filter_lon_max,
		# 	"Country: ", filter_country,
		# 	"Months: ", filter_months,
		# 	"Years: ", filter_years,
		# 	"Lang: ", filter_lang
		# )


		# Optional filters

		if (length(filter_species) > 0) {
			b <- b %>% filter(name %in% filter_species)
		}

		if (length(filter_source) > 0) {
			b <- b %>% filter(recovery_source %in% filter_source)
		}

		if (length(filter_lat_min) > 0 && length(filter_lat_max) > 0) {
			b <- b %>% filter(recovery_lat <= filter_lat_max,
												recovery_lat >= filter_lat_min)
		}

		if (length(filter_lon_min) > 0 && length(filter_lon_max) > 0) {
			b <- b %>% filter(recovery_lon <= filter_lon_max,
												recovery_lon >= filter_lon_min)
		}

		if (length(filter_country) > 0) {
			b <- b %>% filter(recovery_country %in% filter_country)
		}

		if (length(filter_months) > 0) {
			b <- b %>% filter(month.name[month(recovery_date)] %in% filter_months)
		}

		if (length(filter_years) > 0) {
			b <- b %>% filter(year(recovery_date) %in% filter_years)
		}
		hits <- nrow(b)
		max_rows_raw <- Sys.getenv("MAX_ROWS", "40000")

		if (toupper(max_rows_raw) %in% c("0", "ALL", "INF")) {
			max_rows <- Inf   # no limit
		} else {
			max_rows <- as.integer(max_rows_raw)
		}

		if (is.finite(max_rows)) {
			status_swe <- paste0("Nuvarande urval: ",
													 hits,
													 " (visar max ",
													 max_rows,
													 " av de senaste återfynden)")
			status_eng <- paste0(
				"Current selection: ",
				hits,
				" (displaying max ",
				max_rows,
				" of the most recent recoveries)"
			)
		} else {
			status_swe <- paste0("Nuvarande urval: ", hits, " (visar alla återfynd)")
			status_eng <- paste0("Current selection: ", hits, " (displaying all recoveries)")
		}

		status <- if (filter_lang == "Svenska")
			status_swe
		else
			status_eng
		message("status: ", status)

		b <- b %>%
			arrange(desc(recovery_date)) %>%
			head(max_rows)

		res <- list(status = status, df = b)

		return(res)
	})

	lang <- reactive({
		req(input$lang)
		if (input$lang == "Svenska") {
			return("swe")
		}
		if (input$lang == "English") {
			return("eng")
		}
	})

	birds <- reactive({
		get(paste0("birdrecoveries_", lang()))
		#  	req(input$lang)
		#  	if (input$lang == "Svenska") return (birdrecoveries_swe)
		# 		return (birdrecoveries_eng)
	})

	output$lang <- renderUI({
		radioButtons(
			inputId = "lang",
			width = "300px",
			inline = TRUE,
			label = NULL,
			choices = c("English", "Svenska"),
			selected = "Svenska"
		)
	})

	output$species <- renderUI({
	    env_species <- Sys.getenv("DEFAULT_SPECIES", unset = "Erithacus rubecula")
        default_species <- birds() %>%
        filter(sciname == env_species) %>%
			select(name) %>%
			distinct() %>%
			.$name
		message("Default species: ", paste(default_species, collapse = ", "))
		selectizeInput(
			"species",
			label = i18n("name", lang()),
			choices = NULL,
			selected = default_species,
			multiple = TRUE,
			options = list(maxItems = 20)
		)
	})

	output$source <- renderUI({
		selectizeInput(
			"source",
			label = i18n("recovery_source", lang()),
			choices = NULL,
			multiple = TRUE,
			options = list(maxItems = 20)
		)
	})

	output$country <- renderUI({
		selectizeInput(
			"country",
			label = i18n("recovery_country", lang()),
			choices = NULL,
			multiple = TRUE,
			options = list(maxItems = 20)
		)
	})

	observeEvent(birds(), {
		# Update source
		source_choices <- birds() %>%
			distinct(recovery_source) %>%
			.$recovery_source
		updateSelectizeInput(session, "source", choices = source_choices, server = TRUE)

		# Update species
		species_choices <- birds() %>%
			distinct(name) %>%
			arrange(name) %>%
			.$name
		env_species <- Sys.getenv("DEFAULT_SPECIES", unset = "Erithacus rubecula")
        default_species <- birds() %>%
            filter(sciname == env_species) %>%
			select(name) %>%
			distinct() %>%
			.$name
		selected_species <- if (is.null(input$species) || length(input$species) == 0) default_species else input$species
		updateSelectizeInput(session, "species", choices = species_choices, selected = selected_species, server = TRUE)

		# Update country
		country_choices <- birds() %>%
			distinct(recovery_country) %>%
			arrange(recovery_country) %>%
			.$recovery_country
		updateSelectizeInput(session, "country", choices = country_choices, selected = input$country, server = TRUE)
	})

	# Species on language change
	observeEvent(input$lang, {
		species_choices <- birds() %>%
			distinct(name) %>%
			arrange(name) %>%
			.$name
		env_species <- Sys.getenv("DEFAULT_SPECIES", unset = "Erithacus rubecula")
        default_species <- birds() %>%
        filter(sciname == env_species) %>%
			select(name) %>%
			distinct() %>%
			.$name
		updateSelectizeInput(session, "species", choices = species_choices, selected = default_species, server = TRUE)
	})

	output$months <- renderUI({
		month.name.swe <- c(
			"Januari",
			"Februari",
			"Mars",
			"April",
			"Maj",
			"Juni",
			"Juli",
			"Augusti",
			"September",
			"October",
			"November",
			"December"
		)

		month_choices <- month.name
		names(month_choices) <- month.name
		if (lang() == "swe")
			names(month_choices) <- month.name.swe

		selectizeInput(
			"months",
			label = i18n("ui_recovery_month", lang()),
			choices = month_choices,
			multiple = TRUE,
			options = list(maxItems = 12)
		)
	})

	output$years <- renderUI({
		y <- sort(unique(year(birdrecoveries_eng$recovery_date)), decreasing = TRUE)
		selectizeInput(
			"years",
			label = i18n("ui_recovery_year", lang()),
			choices = y,
			multiple = TRUE,
			options = list(maxItems = 20)
		)
	})

	output$lats <- renderUI({
		lat_min <- cmin(birds()$recovery_lat)
		lat_max <- cmax(birds()$recovery_lat)
		sliderInput(
			"lats",
			i18n("recovery_lat", lang()),
			lat_min,
			lat_max,
			value = c(lat_min, lat_max),
			step = 1
		)
	})

	output$lons <- renderUI({
		lon_min <- cmin(birds()$recovery_lon)
		lon_max <- cmax(birds()$recovery_lon)
		sliderInput(
			"lons",
			i18n("recovery_lon", lang()),
			lon_min,
			lon_max,
			value = c(lon_min, lon_max),
			step = 1
		)
	})

	output$birdmap <- renderLeaflet({
		out <- df()$df

		# attempt to do specifically requested popup detail strings formatting
		pop <-
			out %>%
			select(
				name,
				recovery_details,
				ringing_date,
				ringing_country,
				ringing_province,
				ringing_majorplace,
				ringing_minorplace,
				recovery_date,
				recovery_country,
				recovery_province,
				recovery_majorplace,
				recovery_minorplace
			) %>%
			mutate_all(
				.funs = function(x)
					recode(as.character(x), .missing = "")
			) %>%
			mutate(
				ringing_loc = if_else(
					ringing_country == "Sverige" | ringing_country == "Sweden",
					paste(ringing_province, ringing_majorplace, ringing_minorplace),
					paste(
						ringing_country,
						ringing_province,
						ringing_majorplace,
						ringing_minorplace
					)
				)
			) %>%
			mutate(
				recovery_loc = if_else(
					recovery_country == "Sverige" | recovery_country == "Sweden",
					paste(
						recovery_province,
						recovery_majorplace,
						recovery_minorplace
					),
					paste(
						recovery_country,
						recovery_province,
						recovery_majorplace,
						recovery_minorplace
					)
				)
			)

		popup_content <- # htmltools::htmlEscape(
			paste(
				sep = "",
				"<b>",
				i18n("name", lang()),
				":</b> ",
				pop$name,
				"<br/>",
				"<b>",
				i18n("recovery_details", lang()),
				":</b> ",
				pop$recovery_details,
				"<br/>",
				"<b>",
				i18n("ringing_date", lang()),
				":</b> ",
				pop$ringing_date,
				"<br/>",
				# " ", pop$ringing_majorplace, ", ", pop$ringing_minorplace, "", "<br/>",
				" ",
				pop$ringing_loc,
				"<br/>",
				"<b>",
				i18n("recovery_date", lang()),
				":</b> ",
				pop$recovery_date,
				"<br/>",
				#      " ", pop$recovery_majorplace, ", ", pop$recovery_minorplace, "", "<br/>",
				" ",
				pop$recovery_loc,
				"<br/>",
				"<br/>"
			)


		leaflet(data = out) %>%
			# OpenStreetMap
			addProviderTiles("OpenStreetMap", group = "OSM") %>%
			# Carto Dark
			addProviderTiles("CartoDB.DarkMatter", group = "Carto Dark") %>%
			# Carto Light
			addProviderTiles("CartoDB.Positron", group = "Carto Light") %>%
			# clustered points
			addMarkers(
				~ recovery_lon,
				~ recovery_lat,
				popup = popup_content,
				clusterOptions = markerClusterOptions(),
				group = "Clustered"
			) %>%
			# plain (non-clustered) markers
			addCircleMarkers(
				~ recovery_lon,
				~ recovery_lat,
				radius = 4,
				color = "blue",
				popup = popup_content,
				group = "Points"
			) %>%
			# heatmap layer
			leaflet.extras::addHeatmap(
				lng = ~ recovery_lon,
				lat = ~ recovery_lat,
				blur = 20,
				max = 0.05,
				radius = 15,
				group = "Heatmap"
			) %>%
			# add layer control
			addLayersControl(
				baseGroups = c("OSM", "Carto Light", "Carto Dark"),
				overlayGroups = c("Clustered", "Points", "Heatmap"),
				options = layersControlOptions(collapsed = TRUE)
			) %>%
			hideGroup(c("Points", "Heatmap"))
	})
	output$table <- DT::renderDataTable({
		# show a subset of relevant columns
		out <- df()$df %>%
			select(
				modified_date,
				name,
				sciname,
				ringing_age,
				ringing_date,
				ringing_country,
				ringing_province,
				recovery_date,
				recovery_country,
				recovery_province,
				recovery_details
			)
		headings <- purrr::map_chr(names(out), function(x)
			i18n(x, lang()))
		names(out) <- headings
		out
	}, options = list(
		scrollX = TRUE,
		pageLength = 5,
		lengthChange = FALSE,
		rownames = FALSE
	))

	output$dl <- downloadHandler(
		"birdrecoveries.csv",
		contentType = "text/csv",
		content = function(file) {
			write.csv(df()$df, file, row.names = FALSE)
		}
	)


	output$tab_box <- renderUI({
		fluidRow(
			tabBox(
				title = "",
				id = "tabset1",
				height = "100%",
				width = 12,
				tabPanel(
					ifelse(lang() == "swe", "Karta", "Map"),
					leafletOutput("birdmap")
				),
				# tags$head(tags$style(HTML(" #mapbox { height:85vh !important; } "#))),
				# 				leafletOutput("birdmap", width = "100%"))),
				tabPanel(
					ifelse(lang() == "swe", "Tabell", "Table"),
					DT::dataTableOutput("table")
				),
				tabPanel(
					ifelse(lang() == "swe", "Info", "About"),
					uiOutput("menu2_UI")
				)
			)
		)
	})

	output$test_UI <- renderUI({
		tabItems(
			#  		tabItem(tabName = "menu1", uiOutput("menu1_UI")),
			#  		tabItem(tabName = "latest", leafletOutput("birdmap", height = "100%", width = "100%")),
			#  		tabItem(tabName = "about", uiOutput("menu2_UI")),
			tabItem(tabName = "all", box(
				# tags$head(tags$style(HTML(" #mapbox { height:85vh !important; } "))),
				id = "mapbox",
				width = 12,
				leafletOutput("birdmap", width = "100%")
			)) # , height = "100%"))
		)
	})


	output$body_UI <- renderUI({
		p("Default content in body outsite any sidebar menus.")
	})

	output$menu1_UI <- renderUI({
		res <- includeHTML("www/about_eng.html")
		fluidRow(box(res, width = 12))
	})

	output$menu2_UI <- renderUI({
		message("Lang is: ", lang())
		if (input$lang != "Svenska") {
			res <- includeHTML("www/about_eng.html")
		} else {
			res <- includeHTML("www/about_swe.html")
		}
		fluidRow(box(res, width = 12))
	})


	output$mytabitems <- renderUI({
		tabItems(
			tabItem(
				tabName = "menu1",
				tags$a(
					id = "mydiv",
					href = "#",
					"click me",
					onclick = 'Shiny.onInputChange("mydata", Math.random());'
				)
			),
			tabItem(tabName = "about", if (lang() != "swe") {
				includeHTML("www/about_eng.html")
			} else {
				includeHTML("www/about_swe.html")
			}),
			tabItem(tabName = "latest", h2("Latest tab content")),
			tabItem(
				tabName = "all",
				# helpText(df()$status),
				# br(),
				# leafletOutput("birdmap", width = "100%", height = "100%")
				leafletOutput("birdmap")
			)
		)
	})

	output$mytabs <- renderUI({
		myTabs <- list(
			tabPanel(
				title = i18n("ui_tab_map_label", lang()),
				# 				helpText(i18n("ui_tab_map_help", lang())),
				helpText(df()$status),
				br(),
				# leafletOutput("birdmap")
				leafletOutput("birdmap", width = "100%", height = "100%")
			),
			#   	tabPanel(i18n("ui_tab_table_label", lang()),
			# 			helpText(i18n("ui_tab_table_help", lang())),
			# 			br(),
			# 			dataTableOutput("table")
			#   	),
			# tabPanel(i18n("ui_tab_download_label", lang()),
			# 	helpText(i18n("ui_tab_download_help", lang())),
			# 	fluidRow(p(class = "text-center",
			# 	 				 downloadButton("dl", label = i18n("ui_tab_download_help", lang())))
			# 	)
			# ),
			tabPanel(
				i18n("ui_tab_about_label", lang()),
				helpText(i18n("ui_tab_about_help", lang())) # ,
				# if (lang() != "swe") {
				# 	includeHTML("www/about_eng.html")
				# } else {
				# 	includeHTML("www/about_swe.html")
				# }
			)
		)
		do.call(tabsetPanel, myTabs)
	})
}
