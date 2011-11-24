$.timeago.settings.strings =
  day: "1 jour"
  days: "%d jours"
  hour: "1 heure"
  hours: "%d heures"
  minute: "1 minute"
  minutes: "%d minutes"
  month: "1 mois"
  months: "%d mois"
  prefixAgo: "Il y a"
  prefixFromNow: "D'ici"
  seconds: "1 minute"
  suffixAgo: null
  suffixFromNow: null
  year: "1 année"
  years: "%d années"

$ ->
  $('.alert-message').alert()
  $('.timeago').timeago()
