#' Font Awesome icons
#'
#' A list of font awesome icons.
#'
#' @usage
#'
#' fa$<icon name>()
#'
#' @param ... Additional named arguments passed as HTML attributes to the parent
#'   element.
#'
#' @export
#' @examples
#'
#' if (interactive()) {
#'   shinyApp(
#'     ui = container(
#'       fluid = FALSE,
#'       selectInput(
#'         id = "name",
#'         choices = names(fa)
#'       ) %>%
#'         margins(3),
#'       div(
#'         htmlOutput("icon"),
#'         verbatimTextOutput("call")
#'       ) %>%
#'         margins(3) %>%
#'         display("flex") %>%
#'         direction("column") %>%
#'         items("center")
#'     ),
#'     server = function(input, output) {
#'       output$icon <- renderUI({
#'         fa[[input$name]](class = "fa-10x")
#'       })
#'
#'       output$call <- renderText({
#'         paste0("fa$", input$name, "()")
#'       })
#'     }
#'   )
#' }
#'
fa <- list()

fontAwesome <- function(`_icon_classes`, ...) {
  tags$i(class = `_icon_classes`, ...)
}

fa$addressBook <- function(...) fontAwesome("fas fa-address-book", ...)

fa$addressCard <- function(...) fontAwesome("fas fa-address-card", ...)

fa$adjust <- function(...) fontAwesome("fas fa-adjust", ...)

fa$alignCenter <- function(...) fontAwesome("fas fa-align-center", ...)

fa$alignJustify <- function(...) fontAwesome("fas fa-align-justify", ...)

fa$alignLeft <- function(...) fontAwesome("fas fa-align-left", ...)

fa$alignRight <- function(...) fontAwesome("fas fa-align-right", ...)

fa$allergies <- function(...) fontAwesome("fas fa-allergies", ...)

fa$ambulance <- function(...) fontAwesome("fas fa-ambulance", ...)

fa$americanSignLanguageInterpreting <- function(...) fontAwesome("fas fa-american-sign-language-interpreting", ...)

fa$anchor <- function(...) fontAwesome("fas fa-anchor", ...)

fa$angleDoubleDown <- function(...) fontAwesome("fas fa-angle-double-down", ...)

fa$angleDoubleLeft <- function(...) fontAwesome("fas fa-angle-double-left", ...)

fa$angleDoubleRight <- function(...) fontAwesome("fas fa-angle-double-right", ...)

fa$angleDoubleUp <- function(...) fontAwesome("fas fa-angle-double-up", ...)

fa$angleDown <- function(...) fontAwesome("fas fa-angle-down", ...)

fa$angleLeft <- function(...) fontAwesome("fas fa-angle-left", ...)

fa$angleRight <- function(...) fontAwesome("fas fa-angle-right", ...)

fa$angleUp <- function(...) fontAwesome("fas fa-angle-up", ...)

fa$archive <- function(...) fontAwesome("fas fa-archive", ...)

fa$arrowAltCircleDown <- function(...) fontAwesome("fas fa-arrow-alt-circle-down", ...)

fa$arrowAltCircleLeft <- function(...) fontAwesome("fas fa-arrow-alt-circle-left", ...)

fa$arrowAltCircleRight <- function(...) fontAwesome("fas fa-arrow-alt-circle-right", ...)

fa$arrowAltCircleUp <- function(...) fontAwesome("fas fa-arrow-alt-circle-up", ...)

fa$arrowCircleDown <- function(...) fontAwesome("fas fa-arrow-circle-down", ...)

fa$arrowCircleLeft <- function(...) fontAwesome("fas fa-arrow-circle-left", ...)

fa$arrowCircleRight <- function(...) fontAwesome("fas fa-arrow-circle-right", ...)

fa$arrowCircleUp <- function(...) fontAwesome("fas fa-arrow-circle-up", ...)

fa$arrowDown <- function(...) fontAwesome("fas fa-arrow-down", ...)

fa$arrowLeft <- function(...) fontAwesome("fas fa-arrow-left", ...)

fa$arrowRight <- function(...) fontAwesome("fas fa-arrow-right", ...)

fa$arrowUp <- function(...) fontAwesome("fas fa-arrow-up", ...)

fa$arrowsAlt <- function(...) fontAwesome("fas fa-arrows-alt", ...)

fa$arrowsAltH <- function(...) fontAwesome("fas fa-arrows-alt-h", ...)

fa$arrowsAltV <- function(...) fontAwesome("fas fa-arrows-alt-v", ...)

fa$assistiveListeningSystems <- function(...) fontAwesome("fas fa-assistive-listening-systems", ...)

fa$asterisk <- function(...) fontAwesome("fas fa-asterisk", ...)

fa$at <- function(...) fontAwesome("fas fa-at", ...)

fa$audioDescription <- function(...) fontAwesome("fas fa-audio-description", ...)

fa$backward <- function(...) fontAwesome("fas fa-backward", ...)

fa$balanceScale <- function(...) fontAwesome("fas fa-balance-scale", ...)

fa$ban <- function(...) fontAwesome("fas fa-ban", ...)

fa$bandAid <- function(...) fontAwesome("fas fa-band-aid", ...)

fa$barcode <- function(...) fontAwesome("fas fa-barcode", ...)

fa$bars <- function(...) fontAwesome("fas fa-bars", ...)

fa$baseballBall <- function(...) fontAwesome("fas fa-baseball-ball", ...)

fa$basketballBall <- function(...) fontAwesome("fas fa-basketball-ball", ...)

fa$bath <- function(...) fontAwesome("fas fa-bath", ...)

fa$batteryEmpty <- function(...) fontAwesome("fas fa-battery-empty", ...)

fa$batteryFull <- function(...) fontAwesome("fas fa-battery-full", ...)

fa$batteryHalf <- function(...) fontAwesome("fas fa-battery-half", ...)

fa$batteryQuarter <- function(...) fontAwesome("fas fa-battery-quarter", ...)

fa$batteryThreeQuarters <- function(...) fontAwesome("fas fa-battery-three-quarters", ...)

fa$bed <- function(...) fontAwesome("fas fa-bed", ...)

fa$beer <- function(...) fontAwesome("fas fa-beer", ...)

fa$bell <- function(...) fontAwesome("fas fa-bell", ...)

fa$bellSlash <- function(...) fontAwesome("fas fa-bell-slash", ...)

fa$bicycle <- function(...) fontAwesome("fas fa-bicycle", ...)

fa$binoculars <- function(...) fontAwesome("fas fa-binoculars", ...)

fa$birthdayCake <- function(...) fontAwesome("fas fa-birthday-cake", ...)

fa$blind <- function(...) fontAwesome("fas fa-blind", ...)

fa$bold <- function(...) fontAwesome("fas fa-bold", ...)

fa$bolt <- function(...) fontAwesome("fas fa-bolt", ...)

fa$bomb <- function(...) fontAwesome("fas fa-bomb", ...)

fa$book <- function(...) fontAwesome("fas fa-book", ...)

fa$bookmark <- function(...) fontAwesome("fas fa-bookmark", ...)

fa$bowlingBall <- function(...) fontAwesome("fas fa-bowling-ball", ...)

fa$box <- function(...) fontAwesome("fas fa-box", ...)

fa$boxOpen <- function(...) fontAwesome("fas fa-box-open", ...)

fa$boxes <- function(...) fontAwesome("fas fa-boxes", ...)

fa$braille <- function(...) fontAwesome("fas fa-braille", ...)

fa$briefcase <- function(...) fontAwesome("fas fa-briefcase", ...)

fa$briefcaseMedical <- function(...) fontAwesome("fas fa-briefcase-medical", ...)

fa$bug <- function(...) fontAwesome("fas fa-bug", ...)

fa$building <- function(...) fontAwesome("fas fa-building", ...)

fa$bullhorn <- function(...) fontAwesome("fas fa-bullhorn", ...)

fa$bullseye <- function(...) fontAwesome("fas fa-bullseye", ...)

fa$burn <- function(...) fontAwesome("fas fa-burn", ...)

fa$bus <- function(...) fontAwesome("fas fa-bus", ...)

fa$calculator <- function(...) fontAwesome("fas fa-calculator", ...)

fa$calendar <- function(...) fontAwesome("fas fa-calendar", ...)

fa$calendarAlt <- function(...) fontAwesome("fas fa-calendar-alt", ...)

fa$calendarCheck <- function(...) fontAwesome("fas fa-calendar-check", ...)

fa$calendarMinus <- function(...) fontAwesome("fas fa-calendar-minus", ...)

fa$calendarPlus <- function(...) fontAwesome("fas fa-calendar-plus", ...)

fa$calendarTimes <- function(...) fontAwesome("fas fa-calendar-times", ...)

fa$camera <- function(...) fontAwesome("fas fa-camera", ...)

fa$cameraRetro <- function(...) fontAwesome("fas fa-camera-retro", ...)

fa$capsules <- function(...) fontAwesome("fas fa-capsules", ...)

fa$car <- function(...) fontAwesome("fas fa-car", ...)

fa$caretDown <- function(...) fontAwesome("fas fa-caret-down", ...)

fa$caretLeft <- function(...) fontAwesome("fas fa-caret-left", ...)

fa$caretRight <- function(...) fontAwesome("fas fa-caret-right", ...)

fa$caretSquareDown <- function(...) fontAwesome("fas fa-caret-square-down", ...)

fa$caretSquareLeft <- function(...) fontAwesome("fas fa-caret-square-left", ...)

fa$caretSquareRight <- function(...) fontAwesome("fas fa-caret-square-right", ...)

fa$caretSquareUp <- function(...) fontAwesome("fas fa-caret-square-up", ...)

fa$caretUp <- function(...) fontAwesome("fas fa-caret-up", ...)

fa$cartArrowDown <- function(...) fontAwesome("fas fa-cart-arrow-down", ...)

fa$cartPlus <- function(...) fontAwesome("fas fa-cart-plus", ...)

fa$certificate <- function(...) fontAwesome("fas fa-certificate", ...)

fa$chartArea <- function(...) fontAwesome("fas fa-chart-area", ...)

fa$chartBar <- function(...) fontAwesome("fas fa-chart-bar", ...)

fa$chartLine <- function(...) fontAwesome("fas fa-chart-line", ...)

fa$chartPie <- function(...) fontAwesome("fas fa-chart-pie", ...)

fa$check <- function(...) fontAwesome("fas fa-check", ...)

fa$checkCircle <- function(...) fontAwesome("fas fa-check-circle", ...)

fa$checkSquare <- function(...) fontAwesome("fas fa-check-square", ...)

fa$chess <- function(...) fontAwesome("fas fa-chess", ...)

fa$chessBishop <- function(...) fontAwesome("fas fa-chess-bishop", ...)

fa$chessBoard <- function(...) fontAwesome("fas fa-chess-board", ...)

fa$chessKing <- function(...) fontAwesome("fas fa-chess-king", ...)

fa$chessKnight <- function(...) fontAwesome("fas fa-chess-knight", ...)

fa$chessPawn <- function(...) fontAwesome("fas fa-chess-pawn", ...)

fa$chessQueen <- function(...) fontAwesome("fas fa-chess-queen", ...)

fa$chessRook <- function(...) fontAwesome("fas fa-chess-rook", ...)

fa$chevronCircleDown <- function(...) fontAwesome("fas fa-chevron-circle-down", ...)

fa$chevronCircleLeft <- function(...) fontAwesome("fas fa-chevron-circle-left", ...)

fa$chevronCircleRight <- function(...) fontAwesome("fas fa-chevron-circle-right", ...)

fa$chevronCircleUp <- function(...) fontAwesome("fas fa-chevron-circle-up", ...)

fa$chevronDown <- function(...) fontAwesome("fas fa-chevron-down", ...)

fa$chevronLeft <- function(...) fontAwesome("fas fa-chevron-left", ...)

fa$chevronRight <- function(...) fontAwesome("fas fa-chevron-right", ...)

fa$chevronUp <- function(...) fontAwesome("fas fa-chevron-up", ...)

fa$child <- function(...) fontAwesome("fas fa-child", ...)

fa$circle <- function(...) fontAwesome("fas fa-circle", ...)

fa$circleNotch <- function(...) fontAwesome("fas fa-circle-notch", ...)

fa$clipboard <- function(...) fontAwesome("fas fa-clipboard", ...)

fa$clipboardCheck <- function(...) fontAwesome("fas fa-clipboard-check", ...)

fa$clipboardList <- function(...) fontAwesome("fas fa-clipboard-list", ...)

fa$clock <- function(...) fontAwesome("fas fa-clock", ...)

fa$clone <- function(...) fontAwesome("fas fa-clone", ...)

fa$closedCaptioning <- function(...) fontAwesome("fas fa-closed-captioning", ...)

fa$cloud <- function(...) fontAwesome("fas fa-cloud", ...)

fa$cloudDownloadAlt <- function(...) fontAwesome("fas fa-cloud-download-alt", ...)

fa$cloudUploadAlt <- function(...) fontAwesome("fas fa-cloud-upload-alt", ...)

fa$code <- function(...) fontAwesome("fas fa-code", ...)

fa$codeBranch <- function(...) fontAwesome("fas fa-code-branch", ...)

fa$coffee <- function(...) fontAwesome("fas fa-coffee", ...)

fa$cog <- function(...) fontAwesome("fas fa-cog", ...)

fa$cogs <- function(...) fontAwesome("fas fa-cogs", ...)

fa$columns <- function(...) fontAwesome("fas fa-columns", ...)

fa$comment <- function(...) fontAwesome("fas fa-comment", ...)

fa$commentAlt <- function(...) fontAwesome("fas fa-comment-alt", ...)

fa$commentDots <- function(...) fontAwesome("fas fa-comment-dots", ...)

fa$commentSlash <- function(...) fontAwesome("fas fa-comment-slash", ...)

fa$comments <- function(...) fontAwesome("fas fa-comments", ...)

fa$compass <- function(...) fontAwesome("fas fa-compass", ...)

fa$compress <- function(...) fontAwesome("fas fa-compress", ...)

fa$copy <- function(...) fontAwesome("fas fa-copy", ...)

fa$copyright <- function(...) fontAwesome("fas fa-copyright", ...)

fa$couch <- function(...) fontAwesome("fas fa-couch", ...)

fa$creditCard <- function(...) fontAwesome("fas fa-credit-card", ...)

fa$crop <- function(...) fontAwesome("fas fa-crop", ...)

fa$crosshairs <- function(...) fontAwesome("fas fa-crosshairs", ...)

fa$cube <- function(...) fontAwesome("fas fa-cube", ...)

fa$cubes <- function(...) fontAwesome("fas fa-cubes", ...)

fa$cut <- function(...) fontAwesome("fas fa-cut", ...)

fa$database <- function(...) fontAwesome("fas fa-database", ...)

fa$deaf <- function(...) fontAwesome("fas fa-deaf", ...)

fa$desktop <- function(...) fontAwesome("fas fa-desktop", ...)

fa$diagnoses <- function(...) fontAwesome("fas fa-diagnoses", ...)

fa$dna <- function(...) fontAwesome("fas fa-dna", ...)

fa$dollarSign <- function(...) fontAwesome("fas fa-dollar-sign", ...)

fa$dolly <- function(...) fontAwesome("fas fa-dolly", ...)

fa$dollyFlatbed <- function(...) fontAwesome("fas fa-dolly-flatbed", ...)

fa$donate <- function(...) fontAwesome("fas fa-donate", ...)

fa$dotCircle <- function(...) fontAwesome("fas fa-dot-circle", ...)

fa$dove <- function(...) fontAwesome("fas fa-dove", ...)

fa$download <- function(...) fontAwesome("fas fa-download", ...)

fa$edit <- function(...) fontAwesome("fas fa-edit", ...)

fa$eject <- function(...) fontAwesome("fas fa-eject", ...)

fa$ellipsisH <- function(...) fontAwesome("fas fa-ellipsis-h", ...)

fa$ellipsisV <- function(...) fontAwesome("fas fa-ellipsis-v", ...)

fa$envelope <- function(...) fontAwesome("fas fa-envelope", ...)

fa$envelopeOpen <- function(...) fontAwesome("fas fa-envelope-open", ...)

fa$envelopeSquare <- function(...) fontAwesome("fas fa-envelope-square", ...)

fa$eraser <- function(...) fontAwesome("fas fa-eraser", ...)

fa$euroSign <- function(...) fontAwesome("fas fa-euro-sign", ...)

fa$exchangeAlt <- function(...) fontAwesome("fas fa-exchange-alt", ...)

fa$exclamation <- function(...) fontAwesome("fas fa-exclamation", ...)

fa$exclamationCircle <- function(...) fontAwesome("fas fa-exclamation-circle", ...)

fa$exclamationTriangle <- function(...) fontAwesome("fas fa-exclamation-triangle", ...)

fa$expand <- function(...) fontAwesome("fas fa-expand", ...)

fa$expandArrowsAlt <- function(...) fontAwesome("fas fa-expand-arrows-alt", ...)

fa$externalLinkAlt <- function(...) fontAwesome("fas fa-external-link-alt", ...)

fa$externalLinkSquareAlt <- function(...) fontAwesome("fas fa-external-link-square-alt", ...)

fa$eye <- function(...) fontAwesome("fas fa-eye", ...)

fa$eyeDropper <- function(...) fontAwesome("fas fa-eye-dropper", ...)

fa$eyeSlash <- function(...) fontAwesome("fas fa-eye-slash", ...)

fa$fastBackward <- function(...) fontAwesome("fas fa-fast-backward", ...)

fa$fastForward <- function(...) fontAwesome("fas fa-fast-forward", ...)

fa$fax <- function(...) fontAwesome("fas fa-fax", ...)

fa$female <- function(...) fontAwesome("fas fa-female", ...)

fa$fighterJet <- function(...) fontAwesome("fas fa-fighter-jet", ...)

fa$file <- function(...) fontAwesome("fas fa-file", ...)

fa$fileAlt <- function(...) fontAwesome("fas fa-file-alt", ...)

fa$fileArchive <- function(...) fontAwesome("fas fa-file-archive", ...)

fa$fileAudio <- function(...) fontAwesome("fas fa-file-audio", ...)

fa$fileCode <- function(...) fontAwesome("fas fa-file-code", ...)

fa$fileExcel <- function(...) fontAwesome("fas fa-file-excel", ...)

fa$fileImage <- function(...) fontAwesome("fas fa-file-image", ...)

fa$fileMedical <- function(...) fontAwesome("fas fa-file-medical", ...)

fa$fileMedicalAlt <- function(...) fontAwesome("fas fa-file-medical-alt", ...)

fa$filePdf <- function(...) fontAwesome("fas fa-file-pdf", ...)

fa$filePowerpoint <- function(...) fontAwesome("fas fa-file-powerpoint", ...)

fa$fileVideo <- function(...) fontAwesome("fas fa-file-video", ...)

fa$fileWord <- function(...) fontAwesome("fas fa-file-word", ...)

fa$film <- function(...) fontAwesome("fas fa-film", ...)

fa$filter <- function(...) fontAwesome("fas fa-filter", ...)

fa$fire <- function(...) fontAwesome("fas fa-fire", ...)

fa$fireExtinguisher <- function(...) fontAwesome("fas fa-fire-extinguisher", ...)

fa$firstAid <- function(...) fontAwesome("fas fa-first-aid", ...)

fa$flag <- function(...) fontAwesome("fas fa-flag", ...)

fa$flagCheckered <- function(...) fontAwesome("fas fa-flag-checkered", ...)

fa$flask <- function(...) fontAwesome("fas fa-flask", ...)

fa$folder <- function(...) fontAwesome("fas fa-folder", ...)

fa$folderOpen <- function(...) fontAwesome("fas fa-folder-open", ...)

fa$font <- function(...) fontAwesome("fas fa-font", ...)

fa$footballBall <- function(...) fontAwesome("fas fa-football-ball", ...)

fa$forward <- function(...) fontAwesome("fas fa-forward", ...)

fa$frown <- function(...) fontAwesome("fas fa-frown", ...)

fa$futbol <- function(...) fontAwesome("fas fa-futbol", ...)

fa$gamepad <- function(...) fontAwesome("fas fa-gamepad", ...)

fa$gavel <- function(...) fontAwesome("fas fa-gavel", ...)

fa$gem <- function(...) fontAwesome("fas fa-gem", ...)

fa$genderless <- function(...) fontAwesome("fas fa-genderless", ...)

fa$gift <- function(...) fontAwesome("fas fa-gift", ...)

fa$glassMartini <- function(...) fontAwesome("fas fa-glass-martini", ...)

fa$globe <- function(...) fontAwesome("fas fa-globe", ...)

fa$golfBall <- function(...) fontAwesome("fas fa-golf-ball", ...)

fa$graduationCap <- function(...) fontAwesome("fas fa-graduation-cap", ...)

fa$hSquare <- function(...) fontAwesome("fas fa-h-square", ...)

fa$handHolding <- function(...) fontAwesome("fas fa-hand-holding", ...)

fa$handHoldingHeart <- function(...) fontAwesome("fas fa-hand-holding-heart", ...)

fa$handHoldingUsd <- function(...) fontAwesome("fas fa-hand-holding-usd", ...)

fa$handLizard <- function(...) fontAwesome("fas fa-hand-lizard", ...)

fa$handPaper <- function(...) fontAwesome("fas fa-hand-paper", ...)

fa$handPeace <- function(...) fontAwesome("fas fa-hand-peace", ...)

fa$handPointDown <- function(...) fontAwesome("fas fa-hand-point-down", ...)

fa$handPointLeft <- function(...) fontAwesome("fas fa-hand-point-left", ...)

fa$handPointRight <- function(...) fontAwesome("fas fa-hand-point-right", ...)

fa$handPointUp <- function(...) fontAwesome("fas fa-hand-point-up", ...)

fa$handPointer <- function(...) fontAwesome("fas fa-hand-pointer", ...)

fa$handRock <- function(...) fontAwesome("fas fa-hand-rock", ...)

fa$handScissors <- function(...) fontAwesome("fas fa-hand-scissors", ...)

fa$handSpock <- function(...) fontAwesome("fas fa-hand-spock", ...)

fa$hands <- function(...) fontAwesome("fas fa-hands", ...)

fa$handsHelping <- function(...) fontAwesome("fas fa-hands-helping", ...)

fa$handshake <- function(...) fontAwesome("fas fa-handshake", ...)

fa$hashtag <- function(...) fontAwesome("fas fa-hashtag", ...)

fa$hdd <- function(...) fontAwesome("fas fa-hdd", ...)

fa$heading <- function(...) fontAwesome("fas fa-heading", ...)

fa$headphones <- function(...) fontAwesome("fas fa-headphones", ...)

fa$heart <- function(...) fontAwesome("fas fa-heart", ...)

fa$heartbeat <- function(...) fontAwesome("fas fa-heartbeat", ...)

fa$history <- function(...) fontAwesome("fas fa-history", ...)

fa$hockeyPuck <- function(...) fontAwesome("fas fa-hockey-puck", ...)

fa$home <- function(...) fontAwesome("fas fa-home", ...)

fa$hospital <- function(...) fontAwesome("fas fa-hospital", ...)

fa$hospitalAlt <- function(...) fontAwesome("fas fa-hospital-alt", ...)

fa$hospitalSymbol <- function(...) fontAwesome("fas fa-hospital-symbol", ...)

fa$hourglass <- function(...) fontAwesome("fas fa-hourglass", ...)

fa$hourglassEnd <- function(...) fontAwesome("fas fa-hourglass-end", ...)

fa$hourglassHalf <- function(...) fontAwesome("fas fa-hourglass-half", ...)

fa$hourglassStart <- function(...) fontAwesome("fas fa-hourglass-start", ...)

fa$iCursor <- function(...) fontAwesome("fas fa-i-cursor", ...)

fa$idBadge <- function(...) fontAwesome("fas fa-id-badge", ...)

fa$idCard <- function(...) fontAwesome("fas fa-id-card", ...)

fa$idCardAlt <- function(...) fontAwesome("fas fa-id-card-alt", ...)

fa$image <- function(...) fontAwesome("fas fa-image", ...)

fa$images <- function(...) fontAwesome("fas fa-images", ...)

fa$inbox <- function(...) fontAwesome("fas fa-inbox", ...)

fa$indent <- function(...) fontAwesome("fas fa-indent", ...)

fa$industry <- function(...) fontAwesome("fas fa-industry", ...)

fa$info <- function(...) fontAwesome("fas fa-info", ...)

fa$infoCircle <- function(...) fontAwesome("fas fa-info-circle", ...)

fa$italic <- function(...) fontAwesome("fas fa-italic", ...)

fa$key <- function(...) fontAwesome("fas fa-key", ...)

fa$keyboard <- function(...) fontAwesome("fas fa-keyboard", ...)

fa$language <- function(...) fontAwesome("fas fa-language", ...)

fa$laptop <- function(...) fontAwesome("fas fa-laptop", ...)

fa$leaf <- function(...) fontAwesome("fas fa-leaf", ...)

fa$lemon <- function(...) fontAwesome("fas fa-lemon", ...)

fa$levelDownAlt <- function(...) fontAwesome("fas fa-level-down-alt", ...)

fa$levelUpAlt <- function(...) fontAwesome("fas fa-level-up-alt", ...)

fa$lifeRing <- function(...) fontAwesome("fas fa-life-ring", ...)

fa$lightbulb <- function(...) fontAwesome("fas fa-lightbulb", ...)

fa$link <- function(...) fontAwesome("fas fa-link", ...)

fa$liraSign <- function(...) fontAwesome("fas fa-lira-sign", ...)

fa$list <- function(...) fontAwesome("fas fa-list", ...)

fa$listAlt <- function(...) fontAwesome("fas fa-list-alt", ...)

fa$listOl <- function(...) fontAwesome("fas fa-list-ol", ...)

fa$listUl <- function(...) fontAwesome("fas fa-list-ul", ...)

fa$locationArrow <- function(...) fontAwesome("fas fa-location-arrow", ...)

fa$lock <- function(...) fontAwesome("fas fa-lock", ...)

fa$lockOpen <- function(...) fontAwesome("fas fa-lock-open", ...)

fa$longArrowAltDown <- function(...) fontAwesome("fas fa-long-arrow-alt-down", ...)

fa$longArrowAltLeft <- function(...) fontAwesome("fas fa-long-arrow-alt-left", ...)

fa$longArrowAltRight <- function(...) fontAwesome("fas fa-long-arrow-alt-right", ...)

fa$longArrowAltUp <- function(...) fontAwesome("fas fa-long-arrow-alt-up", ...)

fa$lowVision <- function(...) fontAwesome("fas fa-low-vision", ...)

fa$magic <- function(...) fontAwesome("fas fa-magic", ...)

fa$magnet <- function(...) fontAwesome("fas fa-magnet", ...)

fa$male <- function(...) fontAwesome("fas fa-male", ...)

fa$map <- function(...) fontAwesome("fas fa-map", ...)

fa$mapMarker <- function(...) fontAwesome("fas fa-map-marker", ...)

fa$mapMarkerAlt <- function(...) fontAwesome("fas fa-map-marker-alt", ...)

fa$mapPin <- function(...) fontAwesome("fas fa-map-pin", ...)

fa$mapSigns <- function(...) fontAwesome("fas fa-map-signs", ...)

fa$mars <- function(...) fontAwesome("fas fa-mars", ...)

fa$marsDouble <- function(...) fontAwesome("fas fa-mars-double", ...)

fa$marsStroke <- function(...) fontAwesome("fas fa-mars-stroke", ...)

fa$marsStrokeH <- function(...) fontAwesome("fas fa-mars-stroke-h", ...)

fa$marsStrokeV <- function(...) fontAwesome("fas fa-mars-stroke-v", ...)

fa$medkit <- function(...) fontAwesome("fas fa-medkit", ...)

fa$meh <- function(...) fontAwesome("fas fa-meh", ...)

fa$mercury <- function(...) fontAwesome("fas fa-mercury", ...)

fa$microchip <- function(...) fontAwesome("fas fa-microchip", ...)

fa$microphone <- function(...) fontAwesome("fas fa-microphone", ...)

fa$microphoneSlash <- function(...) fontAwesome("fas fa-microphone-slash", ...)

fa$minus <- function(...) fontAwesome("fas fa-minus", ...)

fa$minusCircle <- function(...) fontAwesome("fas fa-minus-circle", ...)

fa$minusSquare <- function(...) fontAwesome("fas fa-minus-square", ...)

fa$mobile <- function(...) fontAwesome("fas fa-mobile", ...)

fa$mobileAlt <- function(...) fontAwesome("fas fa-mobile-alt", ...)

fa$moneyBillAlt <- function(...) fontAwesome("fas fa-money-bill-alt", ...)

fa$moon <- function(...) fontAwesome("fas fa-moon", ...)

fa$motorcycle <- function(...) fontAwesome("fas fa-motorcycle", ...)

fa$mousePointer <- function(...) fontAwesome("fas fa-mouse-pointer", ...)

fa$music <- function(...) fontAwesome("fas fa-music", ...)

fa$neuter <- function(...) fontAwesome("fas fa-neuter", ...)

fa$newspaper <- function(...) fontAwesome("fas fa-newspaper", ...)

fa$notesMedical <- function(...) fontAwesome("fas fa-notes-medical", ...)

fa$objectGroup <- function(...) fontAwesome("fas fa-object-group", ...)

fa$objectUngroup <- function(...) fontAwesome("fas fa-object-ungroup", ...)

fa$outdent <- function(...) fontAwesome("fas fa-outdent", ...)

fa$paintBrush <- function(...) fontAwesome("fas fa-paint-brush", ...)

fa$pallet <- function(...) fontAwesome("fas fa-pallet", ...)

fa$paperPlane <- function(...) fontAwesome("fas fa-paper-plane", ...)

fa$paperclip <- function(...) fontAwesome("fas fa-paperclip", ...)

fa$parachuteBox <- function(...) fontAwesome("fas fa-parachute-box", ...)

fa$paragraph <- function(...) fontAwesome("fas fa-paragraph", ...)

fa$paste <- function(...) fontAwesome("fas fa-paste", ...)

fa$pause <- function(...) fontAwesome("fas fa-pause", ...)

fa$pauseCircle <- function(...) fontAwesome("fas fa-pause-circle", ...)

fa$paw <- function(...) fontAwesome("fas fa-paw", ...)

fa$penSquare <- function(...) fontAwesome("fas fa-pen-square", ...)

fa$pencilAlt <- function(...) fontAwesome("fas fa-pencil-alt", ...)

fa$peopleCarry <- function(...) fontAwesome("fas fa-people-carry", ...)

fa$percent <- function(...) fontAwesome("fas fa-percent", ...)

fa$phone <- function(...) fontAwesome("fas fa-phone", ...)

fa$phoneSlash <- function(...) fontAwesome("fas fa-phone-slash", ...)

fa$phoneSquare <- function(...) fontAwesome("fas fa-phone-square", ...)

fa$phoneVolume <- function(...) fontAwesome("fas fa-phone-volume", ...)

fa$piggyBank <- function(...) fontAwesome("fas fa-piggy-bank", ...)

fa$pills <- function(...) fontAwesome("fas fa-pills", ...)

fa$plane <- function(...) fontAwesome("fas fa-plane", ...)

fa$play <- function(...) fontAwesome("fas fa-play", ...)

fa$playCircle <- function(...) fontAwesome("fas fa-play-circle", ...)

fa$plug <- function(...) fontAwesome("fas fa-plug", ...)

fa$plus <- function(...) fontAwesome("fas fa-plus", ...)

fa$plusCircle <- function(...) fontAwesome("fas fa-plus-circle", ...)

fa$plusSquare <- function(...) fontAwesome("fas fa-plus-square", ...)

fa$podcast <- function(...) fontAwesome("fas fa-podcast", ...)

fa$poo <- function(...) fontAwesome("fas fa-poo", ...)

fa$poundSign <- function(...) fontAwesome("fas fa-pound-sign", ...)

fa$powerOff <- function(...) fontAwesome("fas fa-power-off", ...)

fa$prescriptionBottle <- function(...) fontAwesome("fas fa-prescription-bottle", ...)

fa$prescriptionBottleAlt <- function(...) fontAwesome("fas fa-prescription-bottle-alt", ...)

fa$print <- function(...) fontAwesome("fas fa-print", ...)

fa$procedures <- function(...) fontAwesome("fas fa-procedures", ...)

fa$puzzlePiece <- function(...) fontAwesome("fas fa-puzzle-piece", ...)

fa$qrcode <- function(...) fontAwesome("fas fa-qrcode", ...)

fa$question <- function(...) fontAwesome("fas fa-question", ...)

fa$questionCircle <- function(...) fontAwesome("fas fa-question-circle", ...)

fa$quidditch <- function(...) fontAwesome("fas fa-quidditch", ...)

fa$quoteLeft <- function(...) fontAwesome("fas fa-quote-left", ...)

fa$quoteRight <- function(...) fontAwesome("fas fa-quote-right", ...)

fa$random <- function(...) fontAwesome("fas fa-random", ...)

fa$recycle <- function(...) fontAwesome("fas fa-recycle", ...)

fa$redo <- function(...) fontAwesome("fas fa-redo", ...)

fa$redoAlt <- function(...) fontAwesome("fas fa-redo-alt", ...)

fa$registered <- function(...) fontAwesome("fas fa-registered", ...)

fa$reply <- function(...) fontAwesome("fas fa-reply", ...)

fa$replyAll <- function(...) fontAwesome("fas fa-reply-all", ...)

fa$retweet <- function(...) fontAwesome("fas fa-retweet", ...)

fa$ribbon <- function(...) fontAwesome("fas fa-ribbon", ...)

fa$road <- function(...) fontAwesome("fas fa-road", ...)

fa$rocket <- function(...) fontAwesome("fas fa-rocket", ...)

fa$rss <- function(...) fontAwesome("fas fa-rss", ...)

fa$rssSquare <- function(...) fontAwesome("fas fa-rss-square", ...)

fa$rubleSign <- function(...) fontAwesome("fas fa-ruble-sign", ...)

fa$rupeeSign <- function(...) fontAwesome("fas fa-rupee-sign", ...)

fa$save <- function(...) fontAwesome("fas fa-save", ...)

fa$search <- function(...) fontAwesome("fas fa-search", ...)

fa$searchMinus <- function(...) fontAwesome("fas fa-search-minus", ...)

fa$searchPlus <- function(...) fontAwesome("fas fa-search-plus", ...)

fa$seedling <- function(...) fontAwesome("fas fa-seedling", ...)

fa$server <- function(...) fontAwesome("fas fa-server", ...)

fa$share <- function(...) fontAwesome("fas fa-share", ...)

fa$shareAlt <- function(...) fontAwesome("fas fa-share-alt", ...)

fa$shareAltSquare <- function(...) fontAwesome("fas fa-share-alt-square", ...)

fa$shareSquare <- function(...) fontAwesome("fas fa-share-square", ...)

fa$shekelSign <- function(...) fontAwesome("fas fa-shekel-sign", ...)

fa$shieldAlt <- function(...) fontAwesome("fas fa-shield-alt", ...)

fa$ship <- function(...) fontAwesome("fas fa-ship", ...)

fa$shippingFast <- function(...) fontAwesome("fas fa-shipping-fast", ...)

fa$shoppingBag <- function(...) fontAwesome("fas fa-shopping-bag", ...)

fa$shoppingBasket <- function(...) fontAwesome("fas fa-shopping-basket", ...)

fa$shoppingCart <- function(...) fontAwesome("fas fa-shopping-cart", ...)

fa$shower <- function(...) fontAwesome("fas fa-shower", ...)

fa$sign <- function(...) fontAwesome("fas fa-sign", ...)

fa$signInAlt <- function(...) fontAwesome("fas fa-sign-in-alt", ...)

fa$signLanguage <- function(...) fontAwesome("fas fa-sign-language", ...)

fa$signOutAlt <- function(...) fontAwesome("fas fa-sign-out-alt", ...)

fa$signal <- function(...) fontAwesome("fas fa-signal", ...)

fa$sitemap <- function(...) fontAwesome("fas fa-sitemap", ...)

fa$slidersH <- function(...) fontAwesome("fas fa-sliders-h", ...)

fa$smile <- function(...) fontAwesome("fas fa-smile", ...)

fa$smoking <- function(...) fontAwesome("fas fa-smoking", ...)

fa$snowflake <- function(...) fontAwesome("fas fa-snowflake", ...)

fa$sort <- function(...) fontAwesome("fas fa-sort", ...)

fa$sortAlphaDown <- function(...) fontAwesome("fas fa-sort-alpha-down", ...)

fa$sortAlphaUp <- function(...) fontAwesome("fas fa-sort-alpha-up", ...)

fa$sortAmountDown <- function(...) fontAwesome("fas fa-sort-amount-down", ...)

fa$sortAmountUp <- function(...) fontAwesome("fas fa-sort-amount-up", ...)

fa$sortDown <- function(...) fontAwesome("fas fa-sort-down", ...)

fa$sortNumericDown <- function(...) fontAwesome("fas fa-sort-numeric-down", ...)

fa$sortNumericUp <- function(...) fontAwesome("fas fa-sort-numeric-up", ...)

fa$sortUp <- function(...) fontAwesome("fas fa-sort-up", ...)

fa$spaceShuttle <- function(...) fontAwesome("fas fa-space-shuttle", ...)

fa$spinner <- function(...) fontAwesome("fas fa-spinner", ...)

fa$square <- function(...) fontAwesome("fas fa-square", ...)

fa$squareFull <- function(...) fontAwesome("fas fa-square-full", ...)

fa$star <- function(...) fontAwesome("fas fa-star", ...)

fa$starHalf <- function(...) fontAwesome("fas fa-star-half", ...)

fa$stepBackward <- function(...) fontAwesome("fas fa-step-backward", ...)

fa$stepForward <- function(...) fontAwesome("fas fa-step-forward", ...)

fa$stethoscope <- function(...) fontAwesome("fas fa-stethoscope", ...)

fa$stickyNote <- function(...) fontAwesome("fas fa-sticky-note", ...)

fa$stop <- function(...) fontAwesome("fas fa-stop", ...)

fa$stopCircle <- function(...) fontAwesome("fas fa-stop-circle", ...)

fa$stopwatch <- function(...) fontAwesome("fas fa-stopwatch", ...)

fa$streetView <- function(...) fontAwesome("fas fa-street-view", ...)

fa$strikethrough <- function(...) fontAwesome("fas fa-strikethrough", ...)

fa$subscript <- function(...) fontAwesome("fas fa-subscript", ...)

fa$subway <- function(...) fontAwesome("fas fa-subway", ...)

fa$suitcase <- function(...) fontAwesome("fas fa-suitcase", ...)

fa$sun <- function(...) fontAwesome("fas fa-sun", ...)

fa$superscript <- function(...) fontAwesome("fas fa-superscript", ...)

fa$sync <- function(...) fontAwesome("fas fa-sync", ...)

fa$syncAlt <- function(...) fontAwesome("fas fa-sync-alt", ...)

fa$syringe <- function(...) fontAwesome("fas fa-syringe", ...)

fa$table <- function(...) fontAwesome("fas fa-table", ...)

fa$tableTennis <- function(...) fontAwesome("fas fa-table-tennis", ...)

fa$tablet <- function(...) fontAwesome("fas fa-tablet", ...)

fa$tabletAlt <- function(...) fontAwesome("fas fa-tablet-alt", ...)

fa$tablets <- function(...) fontAwesome("fas fa-tablets", ...)

fa$tachometerAlt <- function(...) fontAwesome("fas fa-tachometer-alt", ...)

fa$tag <- function(...) fontAwesome("fas fa-tag", ...)

fa$tags <- function(...) fontAwesome("fas fa-tags", ...)

fa$tape <- function(...) fontAwesome("fas fa-tape", ...)

fa$tasks <- function(...) fontAwesome("fas fa-tasks", ...)

fa$taxi <- function(...) fontAwesome("fas fa-taxi", ...)

fa$terminal <- function(...) fontAwesome("fas fa-terminal", ...)

fa$textHeight <- function(...) fontAwesome("fas fa-text-height", ...)

fa$textWidth <- function(...) fontAwesome("fas fa-text-width", ...)

fa$th <- function(...) fontAwesome("fas fa-th", ...)

fa$thLarge <- function(...) fontAwesome("fas fa-th-large", ...)

fa$thList <- function(...) fontAwesome("fas fa-th-list", ...)

fa$thermometer <- function(...) fontAwesome("fas fa-thermometer", ...)

fa$thermometerEmpty <- function(...) fontAwesome("fas fa-thermometer-empty", ...)

fa$thermometerFull <- function(...) fontAwesome("fas fa-thermometer-full", ...)

fa$thermometerHalf <- function(...) fontAwesome("fas fa-thermometer-half", ...)

fa$thermometerQuarter <- function(...) fontAwesome("fas fa-thermometer-quarter", ...)

fa$thermometerThreeQuarters <- function(...) fontAwesome("fas fa-thermometer-three-quarters", ...)

fa$thumbsDown <- function(...) fontAwesome("fas fa-thumbs-down", ...)

fa$thumbsUp <- function(...) fontAwesome("fas fa-thumbs-up", ...)

fa$thumbtack <- function(...) fontAwesome("fas fa-thumbtack", ...)

fa$ticketAlt <- function(...) fontAwesome("fas fa-ticket-alt", ...)

fa$times <- function(...) fontAwesome("fas fa-times", ...)

fa$timesCircle <- function(...) fontAwesome("fas fa-times-circle", ...)

fa$tint <- function(...) fontAwesome("fas fa-tint", ...)

fa$toggleOff <- function(...) fontAwesome("fas fa-toggle-off", ...)

fa$toggleOn <- function(...) fontAwesome("fas fa-toggle-on", ...)

fa$trademark <- function(...) fontAwesome("fas fa-trademark", ...)

fa$train <- function(...) fontAwesome("fas fa-train", ...)

fa$transgender <- function(...) fontAwesome("fas fa-transgender", ...)

fa$transgenderAlt <- function(...) fontAwesome("fas fa-transgender-alt", ...)

fa$trash <- function(...) fontAwesome("fas fa-trash", ...)

fa$trashAlt <- function(...) fontAwesome("fas fa-trash-alt", ...)

fa$tree <- function(...) fontAwesome("fas fa-tree", ...)

fa$trophy <- function(...) fontAwesome("fas fa-trophy", ...)

fa$truck <- function(...) fontAwesome("fas fa-truck", ...)

fa$truckLoading <- function(...) fontAwesome("fas fa-truck-loading", ...)

fa$truckMoving <- function(...) fontAwesome("fas fa-truck-moving", ...)

fa$tty <- function(...) fontAwesome("fas fa-tty", ...)

fa$tv <- function(...) fontAwesome("fas fa-tv", ...)

fa$umbrella <- function(...) fontAwesome("fas fa-umbrella", ...)

fa$underline <- function(...) fontAwesome("fas fa-underline", ...)

fa$undo <- function(...) fontAwesome("fas fa-undo", ...)

fa$undoAlt <- function(...) fontAwesome("fas fa-undo-alt", ...)

fa$universalAccess <- function(...) fontAwesome("fas fa-universal-access", ...)

fa$university <- function(...) fontAwesome("fas fa-university", ...)

fa$unlink <- function(...) fontAwesome("fas fa-unlink", ...)

fa$unlock <- function(...) fontAwesome("fas fa-unlock", ...)

fa$unlockAlt <- function(...) fontAwesome("fas fa-unlock-alt", ...)

fa$upload <- function(...) fontAwesome("fas fa-upload", ...)

fa$user <- function(...) fontAwesome("fas fa-user", ...)

fa$userCircle <- function(...) fontAwesome("fas fa-user-circle", ...)

fa$userMd <- function(...) fontAwesome("fas fa-user-md", ...)

fa$userPlus <- function(...) fontAwesome("fas fa-user-plus", ...)

fa$userSecret <- function(...) fontAwesome("fas fa-user-secret", ...)

fa$userTimes <- function(...) fontAwesome("fas fa-user-times", ...)

fa$users <- function(...) fontAwesome("fas fa-users", ...)

fa$utensilSpoon <- function(...) fontAwesome("fas fa-utensil-spoon", ...)

fa$utensils <- function(...) fontAwesome("fas fa-utensils", ...)

fa$venus <- function(...) fontAwesome("fas fa-venus", ...)

fa$venusDouble <- function(...) fontAwesome("fas fa-venus-double", ...)

fa$venusMars <- function(...) fontAwesome("fas fa-venus-mars", ...)

fa$vial <- function(...) fontAwesome("fas fa-vial", ...)

fa$vials <- function(...) fontAwesome("fas fa-vials", ...)

fa$video <- function(...) fontAwesome("fas fa-video", ...)

fa$videoSlash <- function(...) fontAwesome("fas fa-video-slash", ...)

fa$volleyballBall <- function(...) fontAwesome("fas fa-volleyball-ball", ...)

fa$volumeDown <- function(...) fontAwesome("fas fa-volume-down", ...)

fa$volumeOff <- function(...) fontAwesome("fas fa-volume-off", ...)

fa$volumeUp <- function(...) fontAwesome("fas fa-volume-up", ...)

fa$warehouse <- function(...) fontAwesome("fas fa-warehouse", ...)

fa$weight <- function(...) fontAwesome("fas fa-weight", ...)

fa$wheelchair <- function(...) fontAwesome("fas fa-wheelchair", ...)

fa$wifi <- function(...) fontAwesome("fas fa-wifi", ...)

fa$windowClose <- function(...) fontAwesome("fas fa-window-close", ...)

fa$windowMaximize <- function(...) fontAwesome("fas fa-window-maximize", ...)

fa$windowMinimize <- function(...) fontAwesome("fas fa-window-minimize", ...)

fa$windowRestore <- function(...) fontAwesome("fas fa-window-restore", ...)

fa$wineGlass <- function(...) fontAwesome("fas fa-wine-glass", ...)

fa$wonSign <- function(...) fontAwesome("fas fa-won-sign", ...)

fa$wrench <- function(...) fontAwesome("fas fa-wrench", ...)

fa$xRay <- function(...) fontAwesome("fas fa-x-ray", ...)

fa$yenSign <- function(...) fontAwesome("fas fa-yen-sign", ...)

fa$`500Px` <- function(...) fontAwesome("fab fa-500px", ...)

fa$accessibleIcon <- function(...) fontAwesome("fab fa-accessible-icon", ...)

fa$accusoft <- function(...) fontAwesome("fab fa-accusoft", ...)

fa$adn <- function(...) fontAwesome("fab fa-adn", ...)

fa$adversal <- function(...) fontAwesome("fab fa-adversal", ...)

fa$affiliatetheme <- function(...) fontAwesome("fab fa-affiliatetheme", ...)

fa$algolia <- function(...) fontAwesome("fab fa-algolia", ...)

fa$amazon <- function(...) fontAwesome("fab fa-amazon", ...)

fa$amazonPay <- function(...) fontAwesome("fab fa-amazon-pay", ...)

fa$amilia <- function(...) fontAwesome("fab fa-amilia", ...)

fa$android <- function(...) fontAwesome("fab fa-android", ...)

fa$angellist <- function(...) fontAwesome("fab fa-angellist", ...)

fa$angrycreative <- function(...) fontAwesome("fab fa-angrycreative", ...)

fa$angular <- function(...) fontAwesome("fab fa-angular", ...)

fa$appStore <- function(...) fontAwesome("fab fa-app-store", ...)

fa$appStoreIos <- function(...) fontAwesome("fab fa-app-store-ios", ...)

fa$apper <- function(...) fontAwesome("fab fa-apper", ...)

fa$apple <- function(...) fontAwesome("fab fa-apple", ...)

fa$applePay <- function(...) fontAwesome("fab fa-apple-pay", ...)

fa$asymmetrik <- function(...) fontAwesome("fab fa-asymmetrik", ...)

fa$audible <- function(...) fontAwesome("fab fa-audible", ...)

fa$autoprefixer <- function(...) fontAwesome("fab fa-autoprefixer", ...)

fa$avianex <- function(...) fontAwesome("fab fa-avianex", ...)

fa$aviato <- function(...) fontAwesome("fab fa-aviato", ...)

fa$aws <- function(...) fontAwesome("fab fa-aws", ...)

fa$bandcamp <- function(...) fontAwesome("fab fa-bandcamp", ...)

fa$behance <- function(...) fontAwesome("fab fa-behance", ...)

fa$behanceSquare <- function(...) fontAwesome("fab fa-behance-square", ...)

fa$bimobject <- function(...) fontAwesome("fab fa-bimobject", ...)

fa$bitbucket <- function(...) fontAwesome("fab fa-bitbucket", ...)

fa$bitcoin <- function(...) fontAwesome("fab fa-bitcoin", ...)

fa$bity <- function(...) fontAwesome("fab fa-bity", ...)

fa$blackTie <- function(...) fontAwesome("fab fa-black-tie", ...)

fa$blackberry <- function(...) fontAwesome("fab fa-blackberry", ...)

fa$blogger <- function(...) fontAwesome("fab fa-blogger", ...)

fa$bloggerB <- function(...) fontAwesome("fab fa-blogger-b", ...)

fa$bluetooth <- function(...) fontAwesome("fab fa-bluetooth", ...)

fa$bluetoothB <- function(...) fontAwesome("fab fa-bluetooth-b", ...)

fa$btc <- function(...) fontAwesome("fab fa-btc", ...)

fa$buromobelexperte <- function(...) fontAwesome("fab fa-buromobelexperte", ...)

fa$buysellads <- function(...) fontAwesome("fab fa-buysellads", ...)

fa$ccAmazonPay <- function(...) fontAwesome("fab fa-cc-amazon-pay", ...)

fa$ccAmex <- function(...) fontAwesome("fab fa-cc-amex", ...)

fa$ccApplePay <- function(...) fontAwesome("fab fa-cc-apple-pay", ...)

fa$ccDinersClub <- function(...) fontAwesome("fab fa-cc-diners-club", ...)

fa$ccDiscover <- function(...) fontAwesome("fab fa-cc-discover", ...)

fa$ccJcb <- function(...) fontAwesome("fab fa-cc-jcb", ...)

fa$ccMastercard <- function(...) fontAwesome("fab fa-cc-mastercard", ...)

fa$ccPaypal <- function(...) fontAwesome("fab fa-cc-paypal", ...)

fa$ccStripe <- function(...) fontAwesome("fab fa-cc-stripe", ...)

fa$ccVisa <- function(...) fontAwesome("fab fa-cc-visa", ...)

fa$centercode <- function(...) fontAwesome("fab fa-centercode", ...)

fa$chrome <- function(...) fontAwesome("fab fa-chrome", ...)

fa$cloudscale <- function(...) fontAwesome("fab fa-cloudscale", ...)

fa$cloudsmith <- function(...) fontAwesome("fab fa-cloudsmith", ...)

fa$cloudversify <- function(...) fontAwesome("fab fa-cloudversify", ...)

fa$codepen <- function(...) fontAwesome("fab fa-codepen", ...)

fa$codiepie <- function(...) fontAwesome("fab fa-codiepie", ...)

fa$connectdevelop <- function(...) fontAwesome("fab fa-connectdevelop", ...)

fa$contao <- function(...) fontAwesome("fab fa-contao", ...)

fa$cpanel <- function(...) fontAwesome("fab fa-cpanel", ...)

fa$creativeCommons <- function(...) fontAwesome("fab fa-creative-commons", ...)

fa$css3 <- function(...) fontAwesome("fab fa-css3", ...)

fa$css3Alt <- function(...) fontAwesome("fab fa-css3-alt", ...)

fa$cuttlefish <- function(...) fontAwesome("fab fa-cuttlefish", ...)

fa$dAndD <- function(...) fontAwesome("fab fa-d-and-d", ...)

fa$dashcube <- function(...) fontAwesome("fab fa-dashcube", ...)

fa$delicious <- function(...) fontAwesome("fab fa-delicious", ...)

fa$deploydog <- function(...) fontAwesome("fab fa-deploydog", ...)

fa$deskpro <- function(...) fontAwesome("fab fa-deskpro", ...)

fa$deviantart <- function(...) fontAwesome("fab fa-deviantart", ...)

fa$digg <- function(...) fontAwesome("fab fa-digg", ...)

fa$digitalOcean <- function(...) fontAwesome("fab fa-digital-ocean", ...)

fa$discord <- function(...) fontAwesome("fab fa-discord", ...)

fa$discourse <- function(...) fontAwesome("fab fa-discourse", ...)

fa$dochub <- function(...) fontAwesome("fab fa-dochub", ...)

fa$docker <- function(...) fontAwesome("fab fa-docker", ...)

fa$draft2digital <- function(...) fontAwesome("fab fa-draft2digital", ...)

fa$dribbble <- function(...) fontAwesome("fab fa-dribbble", ...)

fa$dribbbleSquare <- function(...) fontAwesome("fab fa-dribbble-square", ...)

fa$dropbox <- function(...) fontAwesome("fab fa-dropbox", ...)

fa$drupal <- function(...) fontAwesome("fab fa-drupal", ...)

fa$dyalog <- function(...) fontAwesome("fab fa-dyalog", ...)

fa$earlybirds <- function(...) fontAwesome("fab fa-earlybirds", ...)

fa$edge <- function(...) fontAwesome("fab fa-edge", ...)

fa$elementor <- function(...) fontAwesome("fab fa-elementor", ...)

fa$ember <- function(...) fontAwesome("fab fa-ember", ...)

fa$empire <- function(...) fontAwesome("fab fa-empire", ...)

fa$envira <- function(...) fontAwesome("fab fa-envira", ...)

fa$erlang <- function(...) fontAwesome("fab fa-erlang", ...)

fa$ethereum <- function(...) fontAwesome("fab fa-ethereum", ...)

fa$etsy <- function(...) fontAwesome("fab fa-etsy", ...)

fa$expeditedssl <- function(...) fontAwesome("fab fa-expeditedssl", ...)

fa$facebook <- function(...) fontAwesome("fab fa-facebook", ...)

fa$facebookF <- function(...) fontAwesome("fab fa-facebook-f", ...)

fa$facebookMessenger <- function(...) fontAwesome("fab fa-facebook-messenger", ...)

fa$facebookSquare <- function(...) fontAwesome("fab fa-facebook-square", ...)

fa$firefox <- function(...) fontAwesome("fab fa-firefox", ...)

fa$firstOrder <- function(...) fontAwesome("fab fa-first-order", ...)

fa$firstdraft <- function(...) fontAwesome("fab fa-firstdraft", ...)

fa$flickr <- function(...) fontAwesome("fab fa-flickr", ...)

fa$flipboard <- function(...) fontAwesome("fab fa-flipboard", ...)

fa$fly <- function(...) fontAwesome("fab fa-fly", ...)

fa$fontAwesome <- function(...) fontAwesome("fab fa-font-awesome", ...)

fa$fontAwesomeAlt <- function(...) fontAwesome("fab fa-font-awesome-alt", ...)

fa$fontAwesomeFlag <- function(...) fontAwesome("fab fa-font-awesome-flag", ...)

fa$fonticons <- function(...) fontAwesome("fab fa-fonticons", ...)

fa$fonticonsFi <- function(...) fontAwesome("fab fa-fonticons-fi", ...)

fa$fortAwesome <- function(...) fontAwesome("fab fa-fort-awesome", ...)

fa$fortAwesomeAlt <- function(...) fontAwesome("fab fa-fort-awesome-alt", ...)

fa$forumbee <- function(...) fontAwesome("fab fa-forumbee", ...)

fa$foursquare <- function(...) fontAwesome("fab fa-foursquare", ...)

fa$freeCodeCamp <- function(...) fontAwesome("fab fa-free-code-camp", ...)

fa$freebsd <- function(...) fontAwesome("fab fa-freebsd", ...)

fa$getPocket <- function(...) fontAwesome("fab fa-get-pocket", ...)

fa$gg <- function(...) fontAwesome("fab fa-gg", ...)

fa$ggCircle <- function(...) fontAwesome("fab fa-gg-circle", ...)

fa$git <- function(...) fontAwesome("fab fa-git", ...)

fa$gitSquare <- function(...) fontAwesome("fab fa-git-square", ...)

fa$github <- function(...) fontAwesome("fab fa-github", ...)

fa$githubAlt <- function(...) fontAwesome("fab fa-github-alt", ...)

fa$githubSquare <- function(...) fontAwesome("fab fa-github-square", ...)

fa$gitkraken <- function(...) fontAwesome("fab fa-gitkraken", ...)

fa$gitlab <- function(...) fontAwesome("fab fa-gitlab", ...)

fa$gitter <- function(...) fontAwesome("fab fa-gitter", ...)

fa$glide <- function(...) fontAwesome("fab fa-glide", ...)

fa$glideG <- function(...) fontAwesome("fab fa-glide-g", ...)

fa$gofore <- function(...) fontAwesome("fab fa-gofore", ...)

fa$goodreads <- function(...) fontAwesome("fab fa-goodreads", ...)

fa$goodreadsG <- function(...) fontAwesome("fab fa-goodreads-g", ...)

fa$google <- function(...) fontAwesome("fab fa-google", ...)

fa$googleDrive <- function(...) fontAwesome("fab fa-google-drive", ...)

fa$googlePlay <- function(...) fontAwesome("fab fa-google-play", ...)

fa$googlePlus <- function(...) fontAwesome("fab fa-google-plus", ...)

fa$googlePlusG <- function(...) fontAwesome("fab fa-google-plus-g", ...)

fa$googlePlusSquare <- function(...) fontAwesome("fab fa-google-plus-square", ...)

fa$googleWallet <- function(...) fontAwesome("fab fa-google-wallet", ...)

fa$gratipay <- function(...) fontAwesome("fab fa-gratipay", ...)

fa$grav <- function(...) fontAwesome("fab fa-grav", ...)

fa$gripfire <- function(...) fontAwesome("fab fa-gripfire", ...)

fa$grunt <- function(...) fontAwesome("fab fa-grunt", ...)

fa$gulp <- function(...) fontAwesome("fab fa-gulp", ...)

fa$hackerNews <- function(...) fontAwesome("fab fa-hacker-news", ...)

fa$hackerNewsSquare <- function(...) fontAwesome("fab fa-hacker-news-square", ...)

fa$hips <- function(...) fontAwesome("fab fa-hips", ...)

fa$hireAHelper <- function(...) fontAwesome("fab fa-hire-a-helper", ...)

fa$hooli <- function(...) fontAwesome("fab fa-hooli", ...)

fa$hotjar <- function(...) fontAwesome("fab fa-hotjar", ...)

fa$houzz <- function(...) fontAwesome("fab fa-houzz", ...)

fa$html5 <- function(...) fontAwesome("fab fa-html5", ...)

fa$hubspot <- function(...) fontAwesome("fab fa-hubspot", ...)

fa$imdb <- function(...) fontAwesome("fab fa-imdb", ...)

fa$instagram <- function(...) fontAwesome("fab fa-instagram", ...)

fa$internetExplorer <- function(...) fontAwesome("fab fa-internet-explorer", ...)

fa$ioxhost <- function(...) fontAwesome("fab fa-ioxhost", ...)

fa$itunes <- function(...) fontAwesome("fab fa-itunes", ...)

fa$itunesNote <- function(...) fontAwesome("fab fa-itunes-note", ...)

fa$java <- function(...) fontAwesome("fab fa-java", ...)

fa$jenkins <- function(...) fontAwesome("fab fa-jenkins", ...)

fa$joget <- function(...) fontAwesome("fab fa-joget", ...)

fa$joomla <- function(...) fontAwesome("fab fa-joomla", ...)

fa$js <- function(...) fontAwesome("fab fa-js", ...)

fa$jsSquare <- function(...) fontAwesome("fab fa-js-square", ...)

fa$jsfiddle <- function(...) fontAwesome("fab fa-jsfiddle", ...)

fa$keycdn <- function(...) fontAwesome("fab fa-keycdn", ...)

fa$kickstarter <- function(...) fontAwesome("fab fa-kickstarter", ...)

fa$kickstarterK <- function(...) fontAwesome("fab fa-kickstarter-k", ...)

fa$korvue <- function(...) fontAwesome("fab fa-korvue", ...)

fa$laravel <- function(...) fontAwesome("fab fa-laravel", ...)

fa$lastfm <- function(...) fontAwesome("fab fa-lastfm", ...)

fa$lastfmSquare <- function(...) fontAwesome("fab fa-lastfm-square", ...)

fa$leanpub <- function(...) fontAwesome("fab fa-leanpub", ...)

fa$less <- function(...) fontAwesome("fab fa-less", ...)

fa$line <- function(...) fontAwesome("fab fa-line", ...)

fa$linkedin <- function(...) fontAwesome("fab fa-linkedin", ...)

fa$linkedinIn <- function(...) fontAwesome("fab fa-linkedin-in", ...)

fa$linode <- function(...) fontAwesome("fab fa-linode", ...)

fa$linux <- function(...) fontAwesome("fab fa-linux", ...)

fa$lyft <- function(...) fontAwesome("fab fa-lyft", ...)

fa$magento <- function(...) fontAwesome("fab fa-magento", ...)

fa$maxcdn <- function(...) fontAwesome("fab fa-maxcdn", ...)

fa$medapps <- function(...) fontAwesome("fab fa-medapps", ...)

fa$medium <- function(...) fontAwesome("fab fa-medium", ...)

fa$mediumM <- function(...) fontAwesome("fab fa-medium-m", ...)

fa$medrt <- function(...) fontAwesome("fab fa-medrt", ...)

fa$meetup <- function(...) fontAwesome("fab fa-meetup", ...)

fa$microsoft <- function(...) fontAwesome("fab fa-microsoft", ...)

fa$mix <- function(...) fontAwesome("fab fa-mix", ...)

fa$mixcloud <- function(...) fontAwesome("fab fa-mixcloud", ...)

fa$mizuni <- function(...) fontAwesome("fab fa-mizuni", ...)

fa$modx <- function(...) fontAwesome("fab fa-modx", ...)

fa$monero <- function(...) fontAwesome("fab fa-monero", ...)

fa$napster <- function(...) fontAwesome("fab fa-napster", ...)

fa$nintendoSwitch <- function(...) fontAwesome("fab fa-nintendo-switch", ...)

fa$node <- function(...) fontAwesome("fab fa-node", ...)

fa$nodeJs <- function(...) fontAwesome("fab fa-node-js", ...)

fa$npm <- function(...) fontAwesome("fab fa-npm", ...)

fa$ns8 <- function(...) fontAwesome("fab fa-ns8", ...)

fa$nutritionix <- function(...) fontAwesome("fab fa-nutritionix", ...)

fa$odnoklassniki <- function(...) fontAwesome("fab fa-odnoklassniki", ...)

fa$odnoklassnikiSquare <- function(...) fontAwesome("fab fa-odnoklassniki-square", ...)

fa$opencart <- function(...) fontAwesome("fab fa-opencart", ...)

fa$openid <- function(...) fontAwesome("fab fa-openid", ...)

fa$opera <- function(...) fontAwesome("fab fa-opera", ...)

fa$optinMonster <- function(...) fontAwesome("fab fa-optin-monster", ...)

fa$osi <- function(...) fontAwesome("fab fa-osi", ...)

fa$page4 <- function(...) fontAwesome("fab fa-page4", ...)

fa$pagelines <- function(...) fontAwesome("fab fa-pagelines", ...)

fa$palfed <- function(...) fontAwesome("fab fa-palfed", ...)

fa$patreon <- function(...) fontAwesome("fab fa-patreon", ...)

fa$paypal <- function(...) fontAwesome("fab fa-paypal", ...)

fa$periscope <- function(...) fontAwesome("fab fa-periscope", ...)

fa$phabricator <- function(...) fontAwesome("fab fa-phabricator", ...)

fa$phoenixFramework <- function(...) fontAwesome("fab fa-phoenix-framework", ...)

fa$php <- function(...) fontAwesome("fab fa-php", ...)

fa$piedPiper <- function(...) fontAwesome("fab fa-pied-piper", ...)

fa$piedPiperAlt <- function(...) fontAwesome("fab fa-pied-piper-alt", ...)

fa$piedPiperHat <- function(...) fontAwesome("fab fa-pied-piper-hat", ...)

fa$piedPiperPp <- function(...) fontAwesome("fab fa-pied-piper-pp", ...)

fa$pinterest <- function(...) fontAwesome("fab fa-pinterest", ...)

fa$pinterestP <- function(...) fontAwesome("fab fa-pinterest-p", ...)

fa$pinterestSquare <- function(...) fontAwesome("fab fa-pinterest-square", ...)

fa$playstation <- function(...) fontAwesome("fab fa-playstation", ...)

fa$productHunt <- function(...) fontAwesome("fab fa-product-hunt", ...)

fa$pushed <- function(...) fontAwesome("fab fa-pushed", ...)

fa$python <- function(...) fontAwesome("fab fa-python", ...)

fa$qq <- function(...) fontAwesome("fab fa-qq", ...)

fa$quinscape <- function(...) fontAwesome("fab fa-quinscape", ...)

fa$quora <- function(...) fontAwesome("fab fa-quora", ...)

fa$ravelry <- function(...) fontAwesome("fab fa-ravelry", ...)

fa$react <- function(...) fontAwesome("fab fa-react", ...)

fa$readme <- function(...) fontAwesome("fab fa-readme", ...)

fa$rebel <- function(...) fontAwesome("fab fa-rebel", ...)

fa$redRiver <- function(...) fontAwesome("fab fa-red-river", ...)

fa$reddit <- function(...) fontAwesome("fab fa-reddit", ...)

fa$redditAlien <- function(...) fontAwesome("fab fa-reddit-alien", ...)

fa$redditSquare <- function(...) fontAwesome("fab fa-reddit-square", ...)

fa$rendact <- function(...) fontAwesome("fab fa-rendact", ...)

fa$renren <- function(...) fontAwesome("fab fa-renren", ...)

fa$replyd <- function(...) fontAwesome("fab fa-replyd", ...)

fa$resolving <- function(...) fontAwesome("fab fa-resolving", ...)

fa$rocketchat <- function(...) fontAwesome("fab fa-rocketchat", ...)

fa$rockrms <- function(...) fontAwesome("fab fa-rockrms", ...)

fa$safari <- function(...) fontAwesome("fab fa-safari", ...)

fa$sass <- function(...) fontAwesome("fab fa-sass", ...)

fa$schlix <- function(...) fontAwesome("fab fa-schlix", ...)

fa$scribd <- function(...) fontAwesome("fab fa-scribd", ...)

fa$searchengin <- function(...) fontAwesome("fab fa-searchengin", ...)

fa$sellcast <- function(...) fontAwesome("fab fa-sellcast", ...)

fa$sellsy <- function(...) fontAwesome("fab fa-sellsy", ...)

fa$servicestack <- function(...) fontAwesome("fab fa-servicestack", ...)

fa$shirtsinbulk <- function(...) fontAwesome("fab fa-shirtsinbulk", ...)

fa$simplybuilt <- function(...) fontAwesome("fab fa-simplybuilt", ...)

fa$sistrix <- function(...) fontAwesome("fab fa-sistrix", ...)

fa$skyatlas <- function(...) fontAwesome("fab fa-skyatlas", ...)

fa$skype <- function(...) fontAwesome("fab fa-skype", ...)

fa$slack <- function(...) fontAwesome("fab fa-slack", ...)

fa$slackHash <- function(...) fontAwesome("fab fa-slack-hash", ...)

fa$slideshare <- function(...) fontAwesome("fab fa-slideshare", ...)

fa$snapchat <- function(...) fontAwesome("fab fa-snapchat", ...)

fa$snapchatGhost <- function(...) fontAwesome("fab fa-snapchat-ghost", ...)

fa$snapchatSquare <- function(...) fontAwesome("fab fa-snapchat-square", ...)

fa$soundcloud <- function(...) fontAwesome("fab fa-soundcloud", ...)

fa$speakap <- function(...) fontAwesome("fab fa-speakap", ...)

fa$spotify <- function(...) fontAwesome("fab fa-spotify", ...)

fa$stackExchange <- function(...) fontAwesome("fab fa-stack-exchange", ...)

fa$stackOverflow <- function(...) fontAwesome("fab fa-stack-overflow", ...)

fa$staylinked <- function(...) fontAwesome("fab fa-staylinked", ...)

fa$steam <- function(...) fontAwesome("fab fa-steam", ...)

fa$steamSquare <- function(...) fontAwesome("fab fa-steam-square", ...)

fa$steamSymbol <- function(...) fontAwesome("fab fa-steam-symbol", ...)

fa$stickerMule <- function(...) fontAwesome("fab fa-sticker-mule", ...)

fa$strava <- function(...) fontAwesome("fab fa-strava", ...)

fa$stripe <- function(...) fontAwesome("fab fa-stripe", ...)

fa$stripeS <- function(...) fontAwesome("fab fa-stripe-s", ...)

fa$studiovinari <- function(...) fontAwesome("fab fa-studiovinari", ...)

fa$stumbleupon <- function(...) fontAwesome("fab fa-stumbleupon", ...)

fa$stumbleuponCircle <- function(...) fontAwesome("fab fa-stumbleupon-circle", ...)

fa$superpowers <- function(...) fontAwesome("fab fa-superpowers", ...)

fa$supple <- function(...) fontAwesome("fab fa-supple", ...)

fa$telegram <- function(...) fontAwesome("fab fa-telegram", ...)

fa$telegramPlane <- function(...) fontAwesome("fab fa-telegram-plane", ...)

fa$tencentWeibo <- function(...) fontAwesome("fab fa-tencent-weibo", ...)

fa$themeisle <- function(...) fontAwesome("fab fa-themeisle", ...)

fa$trello <- function(...) fontAwesome("fab fa-trello", ...)

fa$tripadvisor <- function(...) fontAwesome("fab fa-tripadvisor", ...)

fa$tumblr <- function(...) fontAwesome("fab fa-tumblr", ...)

fa$tumblrSquare <- function(...) fontAwesome("fab fa-tumblr-square", ...)

fa$twitch <- function(...) fontAwesome("fab fa-twitch", ...)

fa$twitter <- function(...) fontAwesome("fab fa-twitter", ...)

fa$twitterSquare <- function(...) fontAwesome("fab fa-twitter-square", ...)

fa$typo3 <- function(...) fontAwesome("fab fa-typo3", ...)

fa$uber <- function(...) fontAwesome("fab fa-uber", ...)

fa$uikit <- function(...) fontAwesome("fab fa-uikit", ...)

fa$uniregistry <- function(...) fontAwesome("fab fa-uniregistry", ...)

fa$untappd <- function(...) fontAwesome("fab fa-untappd", ...)

fa$usb <- function(...) fontAwesome("fab fa-usb", ...)

fa$ussunnah <- function(...) fontAwesome("fab fa-ussunnah", ...)

fa$vaadin <- function(...) fontAwesome("fab fa-vaadin", ...)

fa$viacoin <- function(...) fontAwesome("fab fa-viacoin", ...)

fa$viadeo <- function(...) fontAwesome("fab fa-viadeo", ...)

fa$viadeoSquare <- function(...) fontAwesome("fab fa-viadeo-square", ...)

fa$viber <- function(...) fontAwesome("fab fa-viber", ...)

fa$vimeo <- function(...) fontAwesome("fab fa-vimeo", ...)

fa$vimeoSquare <- function(...) fontAwesome("fab fa-vimeo-square", ...)

fa$vimeoV <- function(...) fontAwesome("fab fa-vimeo-v", ...)

fa$vine <- function(...) fontAwesome("fab fa-vine", ...)

fa$vk <- function(...) fontAwesome("fab fa-vk", ...)

fa$vnv <- function(...) fontAwesome("fab fa-vnv", ...)

fa$vuejs <- function(...) fontAwesome("fab fa-vuejs", ...)

fa$weibo <- function(...) fontAwesome("fab fa-weibo", ...)

fa$weixin <- function(...) fontAwesome("fab fa-weixin", ...)

fa$whatsapp <- function(...) fontAwesome("fab fa-whatsapp", ...)

fa$whatsappSquare <- function(...) fontAwesome("fab fa-whatsapp-square", ...)

fa$whmcs <- function(...) fontAwesome("fab fa-whmcs", ...)

fa$wikipediaW <- function(...) fontAwesome("fab fa-wikipedia-w", ...)

fa$windows <- function(...) fontAwesome("fab fa-windows", ...)

fa$wordpress <- function(...) fontAwesome("fab fa-wordpress", ...)

fa$wordpressSimple <- function(...) fontAwesome("fab fa-wordpress-simple", ...)

fa$wpbeginner <- function(...) fontAwesome("fab fa-wpbeginner", ...)

fa$wpexplorer <- function(...) fontAwesome("fab fa-wpexplorer", ...)

fa$wpforms <- function(...) fontAwesome("fab fa-wpforms", ...)

fa$xbox <- function(...) fontAwesome("fab fa-xbox", ...)

fa$xing <- function(...) fontAwesome("fab fa-xing", ...)

fa$xingSquare <- function(...) fontAwesome("fab fa-xing-square", ...)

fa$yCombinator <- function(...) fontAwesome("fab fa-y-combinator", ...)

fa$yahoo <- function(...) fontAwesome("fab fa-yahoo", ...)

fa$yandex <- function(...) fontAwesome("fab fa-yandex", ...)

fa$yandexInternational <- function(...) fontAwesome("fab fa-yandex-international", ...)

fa$yelp <- function(...) fontAwesome("fab fa-yelp", ...)

fa$yoast <- function(...) fontAwesome("fab fa-yoast", ...)

fa$youtube <- function(...) fontAwesome("fab fa-youtube", ...)

fa$youtubeSquare <- function(...) fontAwesome("fab fa-youtube-square", ...)

