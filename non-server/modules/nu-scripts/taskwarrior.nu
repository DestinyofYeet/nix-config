def get_most_urgent_list [] {
  return (task export | from json | where status != "deleted" and status != "completed" | sort-by urgency | reverse)
}

def main [] {
  let most_urgent_list = get_most_urgent_list
  mut string = "No task found"

  if ($most_urgent_list | length) > 0 {
    let most_urgent = $most_urgent_list.0
    $string = $"\'($most_urgent.description)\' (if "due" in $most_urgent { $most_urgent.due | date humanize })"
  }   

  { 
    text: $string, 
    tooltip: (main extended | str join "\n"),
    class: "main",
    percentage: 100,
  } | to json -r
}

def "main extended" [] {
  let list = get_most_urgent_list
  let length = $list | length

  if $length < 1 {
    print "No more tasks!"
    return
  }

  mut big_list = []

  for index in 1..($length - 1) {
    let entry = $list | get ($index)
    let string = $"- \(($entry.urgency)\) (if "tags" in $entry { [($entry.tags | str join ', ')] })  \'($entry.description)\' (if "due" in $entry { $entry.due | date humanize})"
    $big_list = ($big_list | append $string)
  }

  $big_list
}
