define [], ->
  # Globals used throughout the app, accessible via window.GLOBALS.
  GLOBALS =
    API_DATE: "20130901" # https://developer.foursquare.com/overview/versioning
    API_URL: "https://api.foursquare.com/v2/"
    AUTH_URL: ""
    CLIENT_ID: "Y50ARQDQNJGI2JU3SPTI1MVEM3OZJ1H120H3UXCQVMAI05OJ"
    DATABASE_NAME: "around"
    HAS:
      nativeScroll: (->
        "WebkitOverflowScrolling" in window.document.createElement("div").style
      )()
    LANGUAGE: window.navigator.language # HACK: Better way for this, I assume?
    MAX_DOWNLOADS: 2 # Maximum number of podcast downloads at one time.
    OBJECT_STORE_NAME: "around"
    TOKEN: window.localStorage._ACCESS_TOKEN
  GLOBALS.AUTH_URL = "https://foursquare.com/oauth2/authenticate?client_id=#{GLOBALS.CLIENT_ID}&response_type=token&redirect_uri=#{window.location.origin}"
  window.GLOBALS = GLOBALS;

  # Format a time in seconds to a pretty 5:22:75 style time. Cribbed from
  # the Gaia Music app.
  formatTime = (secs) ->
    if isNaN(secs)
      return "--:--"

    hours = parseInt(secs / 3600, 10) % 24
    hours = if hours != 0 then "#{hours}:" else ""
    minutes = parseInt(secs / 60, 10) % 60
    minutes = if minutes < 10 then "0#{minutes}" else minutes
    seconds = parseInt(secs % 60, 10)
    seconds = if seconds < 10 then "0#{seconds}" else seconds

    "#{hours}#{minutes}:#{seconds}"
  window.formatTime = formatTime

  # Return gettext-style strings as they were supplied. An easy way to mock
  # out gettext calls, in case no locale data is available.
  mockL10n = ->
    window._l10n = null
    window.l = (key) ->
      key

  # Set the language of the app and retrieve the proper localization files.
  # This could be improved, but for now works fine.
  setLanguage = (callback, override) ->
    request = new window.XMLHttpRequest()

    request.open "GET", "locale/#{override || GLOBALS.LANGUAGE}.json", true

    request.addEventListener "load", (event) ->
      if request.status is 200
        # Alias _ for gettext-style l10n jazz.
        l10n = new Jed(
          locale_data: JSON.parse(request.response)
        )

        # TODO: This seems a bit hacky; maybe we can do better?
        window._l10n = l10n
        window.l = (key) ->
          l10n.gettext(key)

        # Localize any data not rendered by EJS templates, eg. stuff
        # in index.html (currently just the <title> tag).
        # TODO: Allow our localization files to pickup on these
        # attributes, which currently we just get lucky with as they
        # are found elsewhere.
        $("[data-l10n]").each ->
          $(this).text(window.l($(this).data("l10n")))
      else
        mockL10n()

      if callback
        callback()

    try
      request.send();
    catch error
      console.log(error)
      mockL10n()
  window.setLanguage = setLanguage

  # Return a timestamp from a JavaScript Date object. If no argument is
  # supplied, return the timestamp for "right now".
  timestamp = (date = new Date()) ->
    Math.round(date.getTime() / 1000)
  window.timestamp = timestamp
