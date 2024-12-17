def format_date [date] -> str {
  $date | date humanize
}

def get_running_tasks [tasks: list] -> list {
  mut list = []

  mut tasks = $tasks

  for index in 0..(($tasks | length) - 1) {
    let entry = $tasks | get $index

    if "start" in $entry {
      mut mod_entry = $entry
      $mod_entry.index = $index
      $list = $list | append $mod_entry
    }
  }

  for index in 0..(($list | length) - 1) {
    let entry = $list | get $index

    $tasks = $tasks | drop nth $entry.index
  }

  {
    running: $list,
    all: $tasks
  }
}

def format_rest [tasks: list] -> json {
  let length = $tasks | length

  if $length < 1 {
    return [ "No more tasks!" ]
  }

  mut big_list = []

  for index in 1..$length {
    let entry = $tasks | get ($index - 1)
    let string = $"- \(($entry.urgency)\) (if "tags" in $entry { [($entry.tags | str join ', ')] }) \'($entry.description)\' (if "due" in $entry { 'due ' + ($entry.due | date humanize) + ' '})(if "scheduled" in $entry { 'scheduled ' + (format_date $entry.scheduled) + ' '})(if "start" in $entry { 'running since ' + (format_date $entry.start) + ' '})"
    $big_list = ($big_list | append $string)
  }

  $big_list
}


def main [] {
  mut all_tasks = (task export | from json | where status != "deleted" and status != "completed" | sort-by urgency | reverse)

  let result = get_running_tasks $all_tasks
  let running_tasks = $result.running
  $all_tasks = $result.all
  if ($running_tasks | length) > 0 {
    let entry = $running_tasks.0
   
    return ({
      text: $"Current running task: \'($entry.description)\' running since (format_date $entry.start)",
      tooltip: (format_rest $all_tasks | str join "\n")
    } | to json -r)
  }

  mut string = "No task found"

  if ($all_tasks | length) > 0 {
    let most_urgent = $all_tasks.0
    $all_tasks = $all_tasks | skip 1
    $string = $"Most urgent task: \'($most_urgent.description)\' (if "due" in $most_urgent { $most_urgent.due | date humanize })"
  }

  { 
    text: $string, 
    tooltip: (format_rest $all_tasks | str join "\n"),
    class: "main",
    percentage: 100,
  } | to json -r
}
