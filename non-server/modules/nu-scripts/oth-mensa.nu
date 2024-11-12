def get-mensa-plan [ selection?: string] {
  let now = (date now)
  let week = ($now | format date '%V' | str trim -l -c '0')
  let url = $"https://www.stwno.de/infomax/daten-extern/csv/HS-R-tag/($week).csv"

  (
    http get --raw $url |
      decode "iso-8859-1" |
      str replace -a "\n(\n|(;|\\())" "$2" |  # fix bullshit
      from csv -s ";" |
      where datum == ($now | format date "%d.%m.%Y") |
      update name {|row| $row.name | str replace '([^\(]+)\(.+\)' '$1' } |
      select warengruppe name kennz stud bed
  )
    | if $selection != null  { $in | where kennz == $selection } else { $in }
}
